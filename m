Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2347DCCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 14:51:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E7398E00AC; Fri, 24 Oct 2025 10:51:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 798098E0042; Fri, 24 Oct 2025 10:51:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 686D08E00AC; Fri, 24 Oct 2025 10:51:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 50D088E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:51:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D934112A2F8
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:51:24 +0000 (UTC)
X-FDA: 84033296088.22.2296CAF
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3291CA000C
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:51:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=g8+UZBbz;
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761317483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L7cVYUStCkt8XojXZTnoP+mO2e7B0TZmjY3DmPJXY74=;
	b=LKQZ4UT52IPebr02y5ivuEAjx2vQSNQuqyaowlpwMKIzD2KVbMeBFLaODFJeWufSaCPkpg
	mQwU1jBkfSwnTC24FzYM2VXUUcPYYRbzoN320bkhzR8a5wwsxm1SWxvKrTpvn9HnoPRFlL
	dehMGkOHTDujZHVsOv4+zoYgOvASfaM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=g8+UZBbz;
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761317483; a=rsa-sha256;
	cv=none;
	b=Re/2XOOQTpkm0wYBZrHO/jMRnRn5ooRF6etNpYNVkSP2qayPnnjB8AkI+o3sqhFziIM2Cs
	4jVtYM7/8cV0KmLFttwrTSoXhLLm1FBLLnq0LBPTEFiQtHm0wr63AWCbzMp3LKN2eTypUt
	XbdnFpsC/UDAkPLMEaQmFQf8KIpkpw4=
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-784807fa38dso25676097b3.2
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761317482; x=1761922282; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L7cVYUStCkt8XojXZTnoP+mO2e7B0TZmjY3DmPJXY74=;
        b=g8+UZBbzMnEWy2y36UJZ0WAEt77U2pzxwZInxq56VHXOPJWrwW0H79HZvrDLrd0Z4f
         nwJg4ZWh/o+yTwIRPsMzB7az8ux+qXp8Knefjc+JS7NQAYIgT9uLMqUqctxjepfLlqjQ
         W6rOkpKleXQ0DucxgJurTWxLWUfpT41RdKjes2Qd8KqfamdwXKkjHggofXRz+WIYBw+R
         MHJJC4Fpc3vMX/RXhhaSJDRboqUTLE6x7WhlUL1R2nMOje+aVYEOovLBCHs3M2VguhFs
         kdrvNbhrM2PTff2xT1UUSJDJs3VPWZo3GMryOmcOk598IdUywQJJHWJzQKQR6RlwmC0j
         yx9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761317482; x=1761922282;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L7cVYUStCkt8XojXZTnoP+mO2e7B0TZmjY3DmPJXY74=;
        b=Fi2MwW4a54o5bfuRLFJbff3tlvbHbHvS9fcP69V2xShmB8+6syAjmBABxogrtKiWKs
         /8CCDdDqoOxEP3EMIquBiUGHN8GJTEu5bTMwQOFMASt1Ptajf9DVbumhQoNWeK2vxBo2
         gPJDJOgVWhfjM5r5kqQ69d20K/feS2OTHwud2OrS+rWnFfKylMP8ofOgrxaJc5GrH9YH
         xYR0ecnl5m9JUs6jUkBaQ68DUKZsILAx4mSSxdZyLByrqcdZ6l8Ow45wv3wIsgbtcMEy
         4ZOgHqsyLW7KMfoa58WvjaMlIahQ5Cr82lWJKfXwXFlcKhX/enc8azLATpqAKvgg9wRt
         nttA==
X-Gm-Message-State: AOJu0YzMgEVm9y/AbHv/ACmb3kRizb25xdScfbxCP7EqsDp4k+fTWFJu
	oRC0WcM4gTunVLdfK925siQIMD/GNwZ03eR2cRleP89glqy2fPf7DZEY
X-Gm-Gg: ASbGncuF73Ms1CRjuG37oM1ytGE9sRAb3RvjCrk+dd1eu3hC7/gdIpE7cWOtJY13EQd
	p1ZFFdiZd3deJQBHgAMv0cTYhYIjQ1rXTm2RgsaElsmm+rQYOfF14Qisvmwd2+HTgmh5hXHpzH9
	MNIMCy1yWUYTnvEz4IXXfQQr2D0TAoO2YCZh++0zg++S/n5KT+XzKhS7Cn9q7u0msyPVyqVJzzo
	6nVJT1o/uRWqRmiC21LbqZwpxAb60p7NYNTbvE0ELx07KSkJ4H9bWQ+EIAMPrfs9Xp7nBnO2dLv
	fsINIG/cpUm/RFu75jMXZaEYjS/+QbtfYGyJJ2Wz5a5j/Q3NfGIK6qrskFJPjWQMzQAhix1PUEG
	l42WZ1DuEn4Mv+LmX8P4xldIdcaZ7w9ckcz4cMHreF09JSYyzBn2OUG3QacUFGvL83PSDlmjGhb
	MmruYmKMVk5dY6VSed6ZG1+kJUg52iLYUfUcxs2Z1DnkWBssHSmif18A==
X-Google-Smtp-Source: AGHT+IHS99RQ+Ik6Il2kKRu5h3zUT8L58Aq7Sm1DcaM2mJ2uG0hFYk6S8DWLpXd612k7ltj6MQYkNA==
X-Received: by 2002:a05:690e:4108:b0:63e:3099:df3e with SMTP id 956f58d0204a3-63f435602c2mr1919452d50.34.1761317482101;
        Fri, 24 Oct 2025 07:51:22 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:56::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-63f37a37d7dsm1684312d50.21.2025.10.24.07.51.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 07:51:21 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Shameer Kolothum <skolothumtho@nvidia.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	vivek.kasireddy@intel.com,
	joshua.hahnjy@gmail.com,
	jgg@nvidia.com,
	nicolinc@nvidia.com,
	nathanc@nvidia.com,
	mochs@nvidia.com
Subject: Re: [PATCH v2] mm/hugetlb: Fix incorrect error return from hugetlb_reserve_pages()
Date: Fri, 24 Oct 2025 07:51:19 -0700
Message-ID: <20251024145119.2315897-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251024094240.337630-1-skolothumtho@nvidia.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: aso3zgqxwgtn5pagbjh97ti9yuhxiicy
X-Rspamd-Queue-Id: 3291CA000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761317483-621442
X-HE-Meta: U2FsdGVkX19iwiaHmsBTH4ZIPKanqVRjafj3tbNORs/Oj3UiHVgLsokl3o5NEaSwU5eNQjEu33CdVEv21x1TNpo05/K4dmxxMuNzstUoXt8ZxQWBg0tz441ag1usYC3w3524PORZZ/yX/+hWLsJsmC3p3Q4OdIqrZFobLHOvUKQR+XZlezEgan+0j4kuRPsdumNR5XjPdcv1qvlvZrOg3KIIPf44FxuasK3rShP5C6cwvqHe6IT5+FcPlHE5lHc9thF2HXxWEatdo3Uw/lgsGfGueFQtaQf8mqDGCBJMSOaujZL99d3IdoBZmogL2FShhYIeiEwBuEHJCfty4skfid8qtXOh95t304+pHb1N8wFl1KwhFivspQ+jZDjry9JCEhg/yuuE1+F5tFxOtDegWEat4mYSsLAj42p3fdVLtbhYvUjE8PUpvCris5r0uSU8GOvEYnPz5yDwxUyvvZLy7eU7HsSXpMvgyjFkv3m75kEGiQVRjNHOusQBsjXyuEbi4ao5x6BrnyvxRVMVjztXlRPYrtviGxyGkMSGp+AfG9ckef6xWXomqJ80MYH5bALo4HtlmgUTTbYb9IAjASMylpx5GkB5+9q8B0kazldVvqk1UK1Z90hPv+FblZ2AeJ/IqNJv4wlcKXYtC2Eqeb9GLbhjjxWtJgKBA1wcrqrFUm7GmEIEWi+Qktf2p9Yn5bTVFfm5qM5tAdR5fHMdqXVUGr28y8Bqp8xtPBfIH1AbaAB77AKjYENmN3jvSzEWTAT7lQy4cvPP3jak9KX5udH7Hb0l4Waq/DPCPIgn/us1y5QnXFc75owmU2PTiq8iujeB6i1qdbOFAwB3beLvLzyGOQ8U2V8x+ejOp+pMa/F1DP3fpifqN+diLCauvoMuWkzovWwjirTyjrsHmhnRum4IAPMfiXwXM8NMdRWX/nukb2XIao0qRIGY4/l26dxR1avOIEf8u8B0eOdNR7yq5CY
 LPM8i2XK
 np6cZ8hKogMX+jBmRNSEFHiHZwo7EmqQDw6GHjNCvYAYZ8zW7DCuYuGfTOHxZ+jDW7briKmeMR5Xs0GokCfWU/St8zaNsvCj9JGAHFY72gXSa2bGgivp9b7NcWLmeI0Z8NyPR+aYwmvd6Nrx86hUoP6Lm7Naz39rqFJcXY65/HrqVGuMk+tpRNQ2XfA/z2VcANfudw70e9cacdWeZoJDNGdAqaA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Oct 2025 10:42:40 +0100 Shameer Kolothum <skolothumtho@nvidia.com> wrote:

> The function hugetlb_reserve_pages() returns the number of pages added
> to the reservation map on success and a negative error code on failure
> (e.g. -EINVAL, -ENOMEM). However, in some error paths, it may return -1
> directly.
> 
> For example, a failure at:
> 
>     if (hugetlb_acct_memory(h, gbl_reserve) < 0)
>         goto out_put_pages;
> 
> results in returning -1 (since add = -1), which may be misinterpreted
> in userspace as -EPERM.
> 
> Fix this by explicitly capturing and propagating the return values from
> helper functions, and using -EINVAL for all other failure cases.
> 
> Fixes: 986f5f2b4be3 ("mm/hugetlb: make hugetlb_reserve_pages() return nr of entries updated")
> Signed-off-by: Shameer Kolothum <skolothumtho@nvidia.com>
> ---
>  Addressed commenst from v1. Thanks!
>  https://lore.kernel.org/linux-mm/20251022102956.245736-1-skolothumtho@nvidia.com/
> ---
>  mm/hugetlb.c | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)

Hello Shameer, LGTM, thank you for addressing the comments! Feel free to add:

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

[...snip...]

> +		/* region_chg() above can return -ENOMEM */
> +		err = (chg == -ENOMEM) ? -ENOMEM : -EINVAL;

And this looks much more elegant than the version I wrote : -)

