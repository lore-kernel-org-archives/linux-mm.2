Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DB9FCCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 19:28:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69C278E0101; Tue, 14 Oct 2025 15:28:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6742A8E0090; Tue, 14 Oct 2025 15:28:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 562478E0101; Tue, 14 Oct 2025 15:28:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 448CD8E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:28:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E6E36BCB70
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 19:28:56 +0000 (UTC)
X-FDA: 83997707472.12.9B81F50
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2DF81180010
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 19:28:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SsMG6WBl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760470135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BznyztNdIKqiPGunKGQKnMKEgfA7Hg4YA0DdSTYZc+4=;
	b=fAKCznrgAN7DQ4TV6i5prsdu8+2BF318jWSvSYA6bcDyX6dJyFxSIshMAx7sswvLP4KR3q
	w8rUgjPN7mE/CAZsbkTtIoh0WbXMUtdr8+e7NkiFJfod9aaGIBqixEtd5BogayCN0AvWcb
	MUEoIBlbOuCbLr8lCxaqZAYzhNq99LU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SsMG6WBl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760470135; a=rsa-sha256;
	cv=none;
	b=6bYdwbkMmwOUTwDu+Ck/rxNHO0z0beDxuBGzYqK7uVqGn8siKU6eSuyaZttilDU1PevggS
	xO0dpbW8mdUDtocZxNuWdt5XIa+hzXHkwsFg/cIbiQ/O1mBfnZ2fl0IVKO+oaeogtqRizo
	tx4tVQeY2tAnDoDe+4aO6qKoI1+vvJs=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-7815092cd0aso10619007b3.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760470134; x=1761074934; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BznyztNdIKqiPGunKGQKnMKEgfA7Hg4YA0DdSTYZc+4=;
        b=SsMG6WBlVEuVGVL7+CAqdO8KU0ot7DzM6Y2eGqM7jqh4aYhG4p5ByYCYira7tIs0eN
         SZVvjWZsZC+1j13GSIald0Y7HiqcmGUmZSIXgkn80hrjUzzJU3A4cA1Ioe2/3E89ihWB
         yWSwRlDK2Wynx1H1pJ0SPery58na41poigVcRcUe//nD6eS4lb/sbCiqyJUFDi+or3dp
         z9IYGkm9qTuqHjIK+IaHNciHJRTLQwY8L9LiLQpuACz6lUUZIuqtgQ1PIQCmTpRhexRn
         QmxMBphkCEPLugPnRXQm3F87IvB9FtSX6PQGAPa3NqvVAJMsyiU3zcjXSWrY7BXRdwK9
         Pytw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760470134; x=1761074934;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BznyztNdIKqiPGunKGQKnMKEgfA7Hg4YA0DdSTYZc+4=;
        b=FG2e+Ci/jmcHVnZBpGsEvRo8ph1sxkVDc7v/IL8UTD2I5oDXMlKZYja+wQbLOUHxJ2
         Gf8DKxwvefBlwFxKo/Ay8NtJa/nLU1X9HMRbcJChjRheDLIcVMAJRhBD03h/BN4phF16
         fK6CE6y3t69RLFaM+2MpaDRxrbY3XJDnJsCubtJIouDbRGktnjHWfCPvVL1TqYu2YXQA
         UILS1Q1NZBQf03eoOwtUmJMA1M/qxzInRgr5c2iysG73CZQykj7AWQmbWRttDn5OVEiZ
         jOeX42Pf/ck79TEw7RFpnBIH3ObT/1PnGkPj2xOl+wYOZqpTO1SY7KEJbj3UMTNH3i2w
         NFXg==
X-Forwarded-Encrypted: i=1; AJvYcCW4dkSsJsFPTI25Cqp2RhF41iadGTq52u3U//eBdUJrmj1ugJ4t5qEFbd6A9jkrwexrhXyeB1t7qA==@kvack.org
X-Gm-Message-State: AOJu0YxXiGSEp9kgIH5tgMdPYxTOG9dSE2a4HEPXpX62EMCujqxAZhwy
	QJC6UWjHiEbwqxGU0q0tBP2GHNSjTxtS5Om46sG76DBGGGdOXu4BRza0
X-Gm-Gg: ASbGncuxLWSORbVShHvpjLQcbZkKEZgPAbhf3VCCZ2bXr0/OVNbaGvlGDsYpl40ClP7
	aHYhfHwIlFYQZf0R3uZ1FHgrciM0wvUnv5U6kfYmCdpJJWBNfCb7U4dqwCvEMrIUppAxfxZwQ7Q
	OSv/eMPLwNuuZvLt3NWd68/F4fgW6MdfMd8JkEN8cwsPgnlhzdWgikEZl+0J4YJ/gXPaxodmjYo
	WzmIZQeVMpwZWJi2axTi+GwQwcuBTe8VFWKGYEy00ZfwAxXM/dNIE78x40HKU4xZ3Yh/ASanP32
	qeCs9Snpbk027rJfSSauZuQg3yCL9RHyy8Bi+8DETdRRZ21ojnNxz8djfl7wXdIJJGgp8z4G5Ap
	7dQrufug8bO3tAwyXGfi9JlVdLG5YH71qcC/4Y7qi9LH4UHB61TKGOtySFdFeu6V8YCtsl1IqdI
	695nED5g4V
X-Google-Smtp-Source: AGHT+IHUNZvALbfEmm2kCV99S3+gpLu5CmEocy1YAJb3Ch2vMTwHdbAyyx2AzGcyVwiIQNB9n3ZAmg==
X-Received: by 2002:a05:690c:b9e:b0:781:23f5:17a7 with SMTP id 00721157ae682-78123f522d2mr111503887b3.11.1760470134198;
        Tue, 14 Oct 2025 12:28:54 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:5f::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-781072bb8easm35715457b3.60.2025.10.14.12.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 12:28:53 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v5 3/3] mm/page_alloc: Batch page freeing in free_frozen_page_commit
Date: Tue, 14 Oct 2025 12:28:22 -0700
Message-ID: <20251014192827.851389-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251014145011.3427205-4-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DF81180010
X-Rspamd-Server: rspam03
X-Stat-Signature: 5tqygbe5989ueci16bmura334feybw48
X-HE-Tag: 1760470134-608043
X-HE-Meta: U2FsdGVkX1/F0Idi2ld7gOPHW5KGgjLh6ey2fcSt1FkmGG+bc0TPXGwLtKOndtO/b/xiIsu0WaIaBz/49aMrHGs5quvsJIeqX1og5Dwc3IIGBGT0uD7jyaoxcd98BBCN2zVKvp5W+zHGKH0mR21daKYF+wzRlkQrK+Eem86OrbkPNNyLYp7ASI1ONOS5GnpD+yzkblcrAYobfaXqPUyYgMYCUIfG8J7tqcy7sD+FZh84uwz52DMCDrhArW3S/mAAFEGbpuXkDv6wo9yEocFfVYyZY31UAdi0tothzgwObAD8dLwloY2MKfqh2tEe7/KLUf+XhobJVGYzm4XJW4/RVjhG3ggRBcMWAttHMtAxPN5yBkcQdv7xaf8/Nc5/BQxAd4VDi+wllqIlJNVWTblSIXb/wHPOmpNaiFafCP76mZ335lkFI7mLhMV78LdjbB/ty2Hrfk1K1ahYt5gZny8c/KA0yYbOdghmUnrav6cJwcW4jl0MySmwy4d4KqviaimQkhf9scW7YdEunKIL3fMDisEyya+eiOUUf2TLP9ptJDEuxWSUE5EuqPwoY3oAJJQyN4sOTLQjgoPyAgLdqnpZigUm7FW+tDmaSExl2tED56g9cgSOHVnYhu8ZtNedyFwOioZX/nDrYx2AvP2tOyRm69oDeXLF3jZ8eACBXw3it6XnQuel/Oki/qrdCS4KOrFPt/Qu8pQe14QX3gLKWL+y8bBAa/gTVWtpVF6anpkM6214f2/bk5TvvNfFkQEhkytl1HOn7AsEXeLs/GtQuIOgRJyn+kp+qZhfEPCoXXN0BkdjGe/zsHBxbU2FM3gv9MouMkB3p+oMgq0Y8O6MqI9w4AcZdSSb/7QRNHpLlydDmgkI/GCXUGZLBOqN47R49AcR180NxDrXXGt8Bc2jWiFtICd+NUMaEUmD1wBa7a6yvuhsBHfmvB66YEqYR9zU5uwqVQHEsB/MQNFH4jfpayK
 3szyAQBh
 CdiMyHdf6Ns9i3DAbQWRHMfqXE4afdKJ2lQAT+e/VZrOaJilW0TzykVqYBw1TiWX457loUws3cFNFmrcVA/yccVLUe9JaMX473QeC2w6bIBBSI0e49cKwv+qjc7i5Iu5e74+wKUvbe/a7tH2h5ausUxYGrTMbMnAscWvBO+Vr/uxLdexu7Dg7pi7EgfC7foicXQKxm9zSWLM2cJQ6OUx4KZ8KX+ksjQQU92BYZ9jz8qSHxBOlB6N1UD9WnRJop6ekA0rq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Oct 2025 07:50:10 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> Before returning, free_frozen_page_commit calls free_pcppages_bulk using
> nr_pcp_free to determine how many pages can appropritately be freed,
> based on the tunable parameters stored in pcp. While this number is an
> accurate representation of how many pages should be freed in total, it
> is not an appropriate number of pages to free at once using
> free_pcppages_bulk, since we have seen the value consistently go above
> 2000 in the Meta fleet on larger machines.
> 
> As such, perform batched page freeing in free_pcppages_bulk by using
> pcp->batch. In order to ensure that other processes are not starved of the
> zone lock, free both the zone lock and pcp lock to yield to other threads.
> 
> Note that because free_frozen_page_commit now performs a spinlock inside the
> function (and can fail), the function may now return with a freed pcp.
> To handle this, return true if the pcp is locked on exit and false otherwise.
> 
> In addition, since free_frozen_page_commit must now be aware of what UP
> flags were stored at the time of the spin lock, and because we must be
> able to report new UP flags to the callers, add a new unsigned long*
> parameter UP_flags to keep track of this.

[...snip...]

Hello Andrew, I hope you are doing well! I was wondering if you could help
adding this as a fixlet for the patch I am writing this reply to. Vlastimil
kindly pointed out that they should never go negative, so checking for
0-ness should be sufficient and more readable than the <= checks.

I think it is OK to leave the changelog in 0/3 unchanged, since it will not go
into the commit history and Vlastimil has already left a correction. But
please let me know if you would like me to add a correction for that as well.

Thank you as always, for your help! I hope you have a great day!
Joshua

...

Since to_free and pcp->count cannot become negative, make the checks into an
equality check instead.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6d544521e49c..fd46a982ce3c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2884,7 +2884,7 @@ static bool free_frozen_page_commit(struct zone *zone,
                free_pcppages_bulk(zone, to_free_batched, pcp, pindex);
                to_free -= to_free_batched;

-               if (to_free <= 0 || pcp->count <= 0)
+               if (to_free == 0 || pcp->count == 0)
                        break;

                pcp_spin_unlock(pcp);

