Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E3BBC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 05:07:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFDE26B008A; Tue,  8 Sep 2026 01:07:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAECC6B008C; Tue,  8 Sep 2026 01:07:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9DB96B0092; Tue,  8 Sep 2026 01:07:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 93EED6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 01:07:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 74D80C0397
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:07:29 +0000 (UTC)
X-FDA: 85189411818.17.EA510EF
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf25.hostedemail.com (Postfix) with ESMTP id 89B14A0006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:07:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=s6Hafz1v;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788844047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UWcBEnY3lcCoe/+fMZWd8DtZju2DWgUR7crGFV5Lj3U=;
	b=hxyqC97p6CPj1fzm2RfpUXPZm8eb0iZCLaQHyI/lBwthM7GOTHz3oH/luBJdz0Lg1bOie/
	hoPrYgX6xvGtLZKTG6Su0/Zz39S5E5akLQ2UUpV3WgadiRrdzDFyxUcOFXtHtpDaLS5zxP
	RGVVLfAVGdCTHDWfPcPYH5HGSlRoZGc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788844047;
	b=UxlE8mhRM1u7BpvXqTDYR/SXyCAYLHTXSlAxWcDW1yCO9Hv47v//rVVGgdx2S++/v+ZAO5
	fwtZzjYA5lGtRqL7wI0WX19Qamzd4SH/dPz4PH2x/XZDSp5xixInbzi77FrmdliPnZNnu4
	aL6EHWayJ7W5lbpJ0/JSgwuRgKbGzwU=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=s6Hafz1v;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c259e5c22ffso313764966b.1
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 22:07:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788844046; cv=none;
        d=google.com; s=arc-20260327;
        b=pSBPXI6RUPbBeh2u36Hg69qvrCf+eTYnPtEwW6+smo9mIyhPGtBseeYYu0G3kslvl0
         BIo+XCLBinPGbbi/sY8W4o0JzFxYBjtU134GerN2CaXWD31to7yrg50tt4hqK/JxPOLH
         6vhBDQm5YpS2ucfOds8HvqoYC/l6eEUNNl4jdEnWis1B4/trhFHUxab2e19K4Dmw2q2B
         otQsF32xuZ9zn0xYtaouS03XUaQ17fB8magOAtQSvyBN3OAo2ETa+ZJxSD2gkTRociVl
         Krf14DChwoxBRmFqONLZpx/hbe+2S1rR7QOJ7ycYMLXvo47rIKEeLMEowlLiFo0jw1R3
         9pRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UWcBEnY3lcCoe/+fMZWd8DtZju2DWgUR7crGFV5Lj3U=;
        fh=9cxSIYT8zxIbVurYGI9X6GC5pPljdZBFvZ1DCi6pcV0=;
        b=dgp2ihWtF8S641/xLNIHBCzWKXNqU18a5frqlh9nG5BC5+za/nLTotRJfU1jeui7Wh
         AunbK1dgmci6/zMjXAD3zMo6K2qbqrYHUg8Mpdnt1Bm9znsSO0b4iKqBopA2zbmgT/AA
         4R4zOwwK+U4lBpd6bUCfDdg7YJGjRjczTNjaKF91UCNCsf/fkdogh4lj/rlEs5nIiNz4
         m7o9DjjTsy8DR69VedMk8pU3FgR109Bfr0CGsagig6TpxCT4ZxZ8I5YXjZYCjzcmrsgj
         TCupbthNCZgmZeHWgXZspG9w5vQuE4zDggWjLOjeO5ohxFMmnu8ByWIp2cOHd60L+HPt
         8BFQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788844046; x=1789448846; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UWcBEnY3lcCoe/+fMZWd8DtZju2DWgUR7crGFV5Lj3U=;
        b=s6Hafz1vW6GqR5P5+tbfq04HA8rbYQY+gXNhR+OD1K63JNZZIAii0oMNPZn83AGV3C
         Us7yBK67BalQJtLP+5iGvEN2j1Q4dv12iO9ETEtLnU3BuR4aKQqgZZrBZHyR/fZlL3nL
         FfLWEb/aoewQmUe1Fd0/+P1LdE51OjfQu2NOE5zzos4LQOv3HmD3IvmUFP6UETycfSVT
         Nakgf5HL6lgVpBeYZTR+oWOLz7NM3WU3USITpj0mn8QiI9tsStrTgrqEtOu+rmfTXBmg
         gDML/uyrc5hWFpEiS+czTk9QesKYZCqdLhMhnUBHu/PJ6ptJAnmSq4mtQv+7zaJBa9BK
         meYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788844046; x=1789448846;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UWcBEnY3lcCoe/+fMZWd8DtZju2DWgUR7crGFV5Lj3U=;
        b=H4qU78R7jvebvOkw7sr4HIkMQOt29Nj9ErPYJJRv4NjL8CrSZQHW3N4kgEryJnW5SY
         n4ezjGd7USIL5cV1I+xFmL1V0dkkR2CcXbdAKtmU5gNssTN96ODIb4f2h4fhMl/ybb9v
         liqbVvM8/hgi8R50z0wPt1iQPeS0QD4V1L4o8xNzB5K3FJc9S39XDQ6UGtsjXRgeB03E
         q7c5RACQ/oLIE7/16YeVNyxbb8ssb8ayqzw+zmX5+TFYx3BMQKfkMnlx/NFiiH184NdB
         TRiGBZ58qcnIYJ0p3oUw1z2qQi00NK8KuBQvSb0NGd4HsiNcCUJTMxDOctf95cL7pX3g
         Ieow==
X-Forwarded-Encrypted: i=1; AKwUvBzAxxBPoqaghJOSTCc42itmV4lap1G0D5IH6/blk15zd8KQfiwAQEZbF9x/JdKrR0ass00utW/S2g==@kvack.org
X-Gm-Message-State: AFuF++kMeC0IX6qVbRSiu3QTDQZnO6EcQAgWmVgOxpUQQfY0WAuqxrYx
	PA1y7p/zd4x6Gu4H9bA7S6bHbKoyThlMutSGB6SJXO3koqc9jvSZ++cQVfC5NhQPdHNQfuEbyll
	5OSFPj4BgjWFG+EVQkaf3+qIi5KXWQK0=
X-Gm-Gg: AYBFou1/rvpIu88upzxdpyZ5xEI5Nut16eHfo7Xr+vp4MfCvsppmdtw6h4vVtaRR81P
	gj7KhF8KRh3cw2z4jDhS77QXd9V9iwO+zXSAVaGGtYm2Kt3QcZ2Oyzs59J904GeRGj6jJVLfsV3
	eRxEceu1nmsB6C9YAjbZTXb8BwV35pmmjQ0Ti/KKLgUhISv464OCdYapbw0Ql5iaCA0onaNYNfc
	fQXJwdy0R8ERNMV05UjM5/F5HzyZg2v5hYHue6sil1X2vch03rKHhtre+Sltrzil1lHNvO6rn42
	AhX25LO8g3Ql84tN9YRnzD+Y801whdxDz62bDLT9HJQ7cpHra7iwftxG2E+xSO792lGX+BhWY+z
	GOQ==
X-Received: by 2002:a17:907:3f8b:b0:c28:e01d:1d10 with SMTP id
 a640c23a62f3a-c28e01d2ae8mr559389366b.49.1788844045795; Mon, 07 Sep 2026
 22:07:25 -0700 (PDT)
MIME-Version: 1.0
References: <06e20ef4f603a4ffeafcdbf623ce2936281457bf.1788831480.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <06e20ef4f603a4ffeafcdbf623ce2936281457bf.1788831480.git.baolin.wang@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 8 Sep 2026 13:06:49 +0800
X-Gm-Features: AcwNN1X3IOriyY0OSA24PdS9488O3mnHRSrmRgX7l0MgKqibRONbqs9nqOKVO6M
Message-ID: <CAMgjq7B4YbKYvRJ8VSi1-gqL=cTGsF=M0GWMdt_tFgBtcWNSgQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add Baoquan and me as MGLRU reviewers
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 89B14A0006
X-Stat-Signature: 1qeubjsro5z4c5oqo8k5rw9u91bjdwhm
X-HE-Tag: 1788844047-497370
X-HE-Meta: U2FsdGVkX1/hsoYUd7/VdlhYxnm3MKg81QoS+YYCnktNichQ6tBCKQz4LxUr2pNPkjszIGVUD4J8URJ+lYv0UfCAW8Kddhc/Zsh0fOy0hlH/F75hhxf5ETcRhSyRmj7zeEQRMYEnmar9JAqrWdNpjBrNF4RFyASy9/hhuCwJvdrKaGc97yEDVipqDVEjuI/N8s+8mwAd/1E+dPOOoujIi+NIAdxZLoIPoEwowlsf57+ZVBCPemxHzIW55SIcg70UdChMgiKCD/I3BxuzUA+YsnChza4NYBQSnO3p8uRSdy7u9D5VQlvU5rQo1jI8XHPjVyouyelcu+/YWTSVVuKRuYzkVl/ltXdmnI8hntazhdcWx7gLfaTUin0ky5U6y7R08dsN+he8CkV9/b6JGvw993wOCaql0yzI1tSP8lUkcbxXFUL/XXtutA0baZ7OEa1aHH7sgtqG9Qz3dF0bnzKsrnlhUeRMg4NP+agBuaVp6xhM7q9c/4ysUrhnTPOi6cUK41QEztH1FhQKGJZ5T8aHF1JLkD9sogZ9rvnQM5kN1R4+KH9cgRzfrXe+x+drAATGK9nvJgRIkVBe1rnPa1ccLOh6Ex+u68xqfrrk5LYyA59IWnQXmo5Meb5g/wJr7mMlS+270AtTuDQvov8Z8pG4+cy+GJyMFAWkoHNeZLo/GkLBvojykGYCoz8lq+n+3TV/rL2GYUrC1eGf60RqPYF0SJfVEZL9P76AwDCUBJdiVdM60uNvVDRONh7TlAUdMkdUsj6NXu3BxNLD5aDFP/6MXjthe1V/lGgH1evKe7zjLwzVfGdUcMfaWtwDV4u5AFrFb2fV8ZCkcaVzgEVVYSOV7NeQSpIFbY8gX6NTNlUM9Jjrmh9WvRGC9n6+2633yPaqiX19sASJ0eriPM9K2+dnDjf4j99TFiqSnHup8KIVofROkUqsUpBnNTZE4tT4w43q3qMcih2XImnmFRlfiFW
 2zpkxYGo
 nZ8ETAJLSK+oLnKN/krDmst2pSY5mIw0d8Ie0k0ASDgnjllhCTKG2oTIUisPAl2LmhQyrOvqDCMoEfQorjTvQ7WqoxZkQ8HOyhvV37DZB/3LeXzBvtav2ovqkDY88n2c4ad+kJyV+poVADGEZKsfCSyzd5E+MRfSPaja565WCpwSdVHiEYJiQEaGuuabL08arrsjKru4kN8EWd87cnBJfgYpIgsKKhaSlWQtaGjbQCLH2S5KelHhIrbTe/3hAlHp2o83FDCwdYJ9MWUv8HT2zCE8bAVqZYlImDytxbqnvoQcoYCXmHubQPMJtUrCJDN3M/HUOtrc/55vG9joTE8AjS2NKjPGCustLTCgim1XzPs50airri7wTWxxxPlffqePIDFrybWPsKG6Et5CFw2RlehKjOriDDo0P3sRbutIITOyhB65DPW3LudSNBzeiGdgizCORKA+K5cA1zcXKhpDyiXIi/iQAMA+I+j+ce7qV/HdfPAGGfmFoIljCRMwnBMfxV0RM2M9NOsrdPOAc38I1LKCSwi2jbSRLnFoU4+DUA8NRxC7cyymuQNGP+MogalBYC/8t81hu9V2jY76PYnSPdRdxAQYES77yr5hJbugZOQsln1s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 8, 2026 at 9:44=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> Baoquan and I have been contributing MGLRU patches and helping review MGL=
RU
> related patches for some time. We will continue to follow MGLRU changes, =
so
> we'd like to be CC'd on MGLRU related patches.
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  MAINTAINERS | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4d1ff4c76496..c558d5370dd0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17242,6 +17242,8 @@ R:      Barry Song <baohua@kernel.org>
>  R:     Axel Rasmussen <axelrasmussen@google.com>
>  R:     Yuanchu Xie <yuanchu@google.com>
>  R:     Wei Xu <weixugc@google.com>
> +R:     Baoquan He <baoquan.he@linux.dev>
> +R:     Baolin Wang <baolin.wang@linux.alibaba.com>
>  L:     linux-mm@kvack.org
>  S:     Maintained
>  W:     http://www.linux-mm.org
> --
> 2.47.3

Baoquan and Baolin have been very helpful on the development of MGLRU
upstream, it's great to have your help!

Acked-by: Kairui Song <kasong@tencent.com>

