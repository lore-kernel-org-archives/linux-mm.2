Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1239FB5EAB
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 08:31:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BF106B012F; Wed, 18 Mar 2026 04:31:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06EF76B0131; Wed, 18 Mar 2026 04:31:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC7236B0132; Wed, 18 Mar 2026 04:31:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D70C56B012F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 04:31:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 888021604A2
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:31:39 +0000 (UTC)
X-FDA: 84558515118.20.9DAECB2
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id C2AC8100011
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:31:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="QLxLSZ7/";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773822697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6skfg/AvsBEcmXuLugiIr35grUcj1HHR8OGJRT9dj14=;
	b=IHRK7aHNObR+BONvZ+4RP7/VBcaFq7TgxecZ9wYPDJpUbnEHjiex0PymyH6r5AYnFkUfsi
	j/PKBq3mhwvZSAdr7OOhWtg3ASw/qHWzo2L9bEeHuHN1Gb5b5PggGlMid7oD/xzmVyjLKe
	LGheqG8vja8SMhA9qMgNht1TGXJ/jBQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="QLxLSZ7/";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773822697; a=rsa-sha256;
	cv=none;
	b=LZMkm6va5BH3gVpUi/Ta6LYsSx7B4VYJejEIgGvKcsVnTNBcmNBHwy9H2FQuwmlsTLUHqE
	E50UgTlzcOQ/X13Lu4yO+KmzK+uE0XCdDYCcbVWmM5r3oz/kcSoDxhV+VqBEDAcIutc/ne
	PDeLB/YGQ2KrvHgJ3gc4ZXqxvrkdbEA=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-485410a0a8aso59283135e9.2
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 01:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773822696; x=1774427496; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6skfg/AvsBEcmXuLugiIr35grUcj1HHR8OGJRT9dj14=;
        b=QLxLSZ7/+oG8MNgzS1PvbjBN11XIGXdibojgcODJNU95Fm2EfL/+IwpmzX93ewm8Rm
         l0JFc5yQvy2B99WZnStEtmUsi6bYJvRodb+UKa/KoA/EbaKRDjqZ/ML9hFTjyh89fUwl
         eUlN7UDtSWyQ57pZjZvFb7r3Q2NZyU+7ydvel8zU5OJTL5q8uyIkeIorMqLbPcA9TFDD
         0sjSc2Ppft9zIcWvRTMjyEklur7tltco+RfDsxfwsZRlphLBR2v0VSnt4GCDhB5w/pBe
         X8Qt1bOViuK1mO1yU4FMRDmc7GiqHKwD6jbd2L4QOsmwA2/nwUhuHcS2Q3XSWsgHkCuc
         VLbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773822696; x=1774427496;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6skfg/AvsBEcmXuLugiIr35grUcj1HHR8OGJRT9dj14=;
        b=VJnO/dGkDsIQhOKLJXbIVqHANKfa61V2B+Wuk+OhnJ7POwMue2hIbcvC4leF9nxXzo
         nyPMlAcv87vLG5ZiTjhAenZsU5V2H4P2LHARq6zSyVqlZB7YfF0eaKKprF6as+4eSXpP
         0CTl6LUWrxe7CAkWn0Td8Q4MxEhBwzmUqMz1PmJiASkzxGRM1hz4dBgsSBvS5LhP6MuD
         KWIqKTpJU80cy0hv/whip7QbYYINfOrv8CUyM5aXtCWligQvmeI2c851WkDnIMCCIk4Y
         GGib4MIgZbFXChPz3/MwpJVstTHLRB54Tf4iWuSLnI7UQRgCmqXe9lwE3S613DiMnzQN
         dGmA==
X-Forwarded-Encrypted: i=1; AJvYcCVICXwBafT54Wfuxh2FmucRZnki7alEcPQCX0/8C+Mvk9cOE4dCR9GEUYJocCN62d4Ws9DCmCeHVg==@kvack.org
X-Gm-Message-State: AOJu0Yw2gF3MfO5y9MPae+Z+vdj9sdPgv5SmqwSHyI5bmIo4E5vxsRSI
	cFHhmPGBR0aFc8fwzY5AysSIaiE1Mul5cJ6zp5j8o1Xfw6v/bCisuJ4hZZeCSqId+lM=
X-Gm-Gg: ATEYQzwvCGRj4ZZIm/v8JhPNcknlQhpsvTFUrB9f+qAhq4T+sx1XShSm7/RxzxhDf3h
	op1M3sL6Ij0bnJHxERgMglX8EAZ5vnGRCskyTfkvK7uxsacJNcAdjZL8gZRHToQip8AEG7xzQsq
	OLYVyBoINzOotlSZj0g+d59elv01J+CqwioO5+MnH0tXzWmKl/p97QYWur/t+1n/SCPpxxAHZej
	YjW/a95WCtm1NuBJjqwGOjLhhVRSeDa2qHTfXnRmncUzXdCcT4UFvoTWARBGWclpKj9cqHCzsHr
	iujs6Cy/6egBGmLmaaxgrD5kx72/o5bNtIUDm8auBBA8eBC2M9QBDI9ROYD4Vav1sN8neSkvW54
	Ic6QD3Dgc86NFag+9yi3pZXTx8e0Cr6B+RIa7Mr3xdOxArwO8r4T9N3Ayb9B5R1RUs46gV6IJhb
	c0UUyrVVZOtKKFJP3IVmwuK6QYajTkn6142Cf1
X-Received: by 2002:a05:600c:3b07:b0:485:3026:2b8b with SMTP id 5b1f17b1804b1-486f446fab2mr40802755e9.29.1773822696147;
        Wed, 18 Mar 2026 01:31:36 -0700 (PDT)
Received: from localhost (109-81-21-195.rct.o2.cz. [109.81.21.195])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486f4214ab8sm48028185e9.6.2026.03.18.01.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 01:31:35 -0700 (PDT)
Date: Wed, 18 Mar 2026 09:31:34 +0100
From: Michal Hocko <mhocko@suse.com>
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"T . J . Mercier" <tjmercier@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Zhaoyang Huang <huangzhaoyang@gmail.com>, steve.kang@unisoc.com,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>
Subject: Re: [PATCHv3] mm: remove '!root_reclaim' checking in
 should_abort_scan()
Message-ID: <abpi5gh9XhUygW-J@tiehlicka>
References: <20260318011558.1696310-1-zhaoyang.huang@unisoc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318011558.1696310-1-zhaoyang.huang@unisoc.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C2AC8100011
X-Stat-Signature: 3mgep6i41u5tdmsqngmucfrzen8gpu61
X-Rspam-User: 
X-HE-Tag: 1773822697-486308
X-HE-Meta: U2FsdGVkX1+9jwHW+QOhMkKi5Bh0+ZCeBIwGe0slq1YTlweRYDQs6NuEnSA1NkuNJ4i3ypV4jkWZAXQI5lhD+wjKIdgyZvBFx0L4ZU9j7knUiKjUb5pShLaIBkFiWoPm2ClY0l3bqnhucj4MFvzOwMnKS2VXepaFHTZ+o+lA1+3MSLxQNE0+6UTT/c9KTa4sdFHWAuz1MdaYQUavYs2nxfyAurlo1XGhoYs2uM0V2vmxn8bNDH55A7EJwxp19l0g0lCGQAMkefMCvuGlDe7H8X0BPY8gdepbI4kVqoA3nRYlOvkPAkquA8jzSS8oLi46i6eIfPuMsKmZcjYC+wtSYRLUA7it0PUtDsHKVzKqJejA5HCQ/uMSb3pVZ1nw+m6nW1F6UcZ+4RbLJO8atzwR/BfzeOVroFIzwTCjYDb3HHor0PbdWKxsBmvkdF7AXB81KeXJgJ7eNQooavpXZ7C59VCjhcWEZd+wWE0qvk9YLPRjBUIbyxA6aBlGBZUkC82WSRFl/gSX/c0Dz15b1O6KeRogE7mtO8rqMa7yVHzeRNqRJS0D+1NhB/mP7Lr1ZF3ySf2BkkVQeedrIC+TIkK4cyCLjsrJ8WKk0Na5LZxmvkQKSE3jO0yXiBjd7qIWkOnBDbUZrqkwdbxq1G2VUPHloagdR9WF+QWXVIE9z/608awtP1ohZKN3AnDhkNBVuGAGSQjwQKOGp8x/ErYMycAI3dkreGpLItvFTmDQI0K2T/0pUWSpSmnyKUWIDg8oeGdLoDM5UYaVkoCrBfHDOhJAiPuNooe7SjEOY1PRrvn5T1Re69MN03OHVM+h3VKiTRDxxOwyMh6rXaP6h9OYphc3oUMql1+OSeb53Mt/r8glpB4Vlu186C3tJZ2BvbWquI0oAaCvCgmMn6wYxVFXocQrgQUBd6Ay4v7+7egIufBMfX6EcIZgHryq1aQ16aAepQpmWV3E6XD+GQpB6W0+7A1
 g/I5jxdB
 gJ5fFPhZNUKx4vst43UI857GPyvLlm7BvGwj++pOi2i1FH89gXRWcpcaRgujMLb33+a647WKT062OQywhAwIGAmvAYJcoZooGJOcnpR7FRbIr79ooKhU9cnPC5g7GZBXIQIQkf5HWV1/3CtPdMN+33eq2czXr4jcOf1kTFxPH0Y8xdtScSqkL3Ils6bxC2PKvOpHIH3mmNRhDZzyCToHJJeAyRn1vXqwe6uCt/JHFFlb4MsA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 18-03-26 09:15:58, zhaoyang.huang wrote:
> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> 
> Android systems usually use memory.reclaim interface to implement user
> space memory management which expects that the requested reclaim target
> and actually reclaimed amount memory are not diverging by too much. With
> the current MGRLU implementation there is, however, no bail out when the
> reclaim target is reached and this could lead to an excessive reclaim
> that scales with the reclaim hierarchy size.For example, we can get a
> nr_reclaimed=394/nr_to_reclaim=32 proactive reclaim under a common 1-N
> cgroup hierarchy.
> This defect arised from the goal of keeping fairness among memcgs that
> is, for try_to_free_mem_cgroup_pages -> shrink_node_memcgs ->
> shrink_lruvec -> lru_gen_shrink_lruvec -> try_to_shrink_lruvec, the
> !root_reclaim(sc) check was there for reclaim fairness, which was
> necessary before commit 'b82b530740b9' ("mm: vmscan: restore
> incremental cgroup iteration") because the fairness depended on
> attempted proportional reclaim from every memcg under the target
> memcg. However after commit 'b82b530740b9' there is no longer a need
> to visit every memcg to ensure fairness. Let's have try_to_shrink_lruvec
> bail out when the nr_reclaimed achieved.
> 
> Suggested-by: T.J.Mercier <tjmercier@google.com>
> Reviewed-by: T.J.Mercier <tjmercier@google.com>
> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

OK, this is easier to understand. Although you have avoided some
clarifications I have asked for explicitly in prior version. If MGLRU
maintainers are OK with this then just go ahead. Btw. I have only now
noticed that they have not been involved. Adding them now.

> ---
> Patchv2,v3: update commit message
> ---
> ---
>  mm/vmscan.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 0fc9373e8251..10f1e7d716ca 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4839,10 +4839,6 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
>  	int i;
>  	enum zone_watermarks mark;
>  
> -	/* don't abort memcg reclaim to ensure fairness */
> -	if (!root_reclaim(sc))
> -		return false;
> -
>  	if (sc->nr_reclaimed >= max(sc->nr_to_reclaim, compact_gap(sc->order)))
>  		return true;
>  
> -- 
> 2.25.1

-- 
Michal Hocko
SUSE Labs

