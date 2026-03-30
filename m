Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A038FF4947
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 06:08:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7767D6B0092; Mon, 30 Mar 2026 02:08:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 726FB6B0095; Mon, 30 Mar 2026 02:08:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63CB56B0098; Mon, 30 Mar 2026 02:08:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 51BC86B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 02:08:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E5A431A06ED
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:08:56 +0000 (UTC)
X-FDA: 84601701072.16.B88DAB9
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1C7EDC0008
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:08:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i6nLqqhn;
	spf=pass (imf28.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i6nLqqhn;
	spf=pass (imf28.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774850935; a=rsa-sha256;
	cv=none;
	b=BTPeRfeB0J0V1R6+7V1iQ6m1hO+LGnimKQxpmFXZXInNvDuRGCFr+sPJhW0Gec9p7Dx4h8
	GVVkxlCa+lbd6RnMl6ueMy411FXWTrJrCKV7EGcY9tyEZ+yK90Ia9pWyOWNHmPpbOqHtk8
	0Wk49FhO5TAWNn4vlKEyKZy/oSbGjM0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774850935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AYECvkLYIdqO7PMq8pUGmPwH0CV33XwnM84wxRtZNC0=;
	b=GI0jYDv1jLk5+02pPG4dhLS0xwL4Z+wI73zGukF3a3vqSHUG4/fF4ZtIpi5wfG6KssXcn/
	n4jYWQYmTeHXa557AIP1hnv2pTQqHm2B0od13TWXKeIfPD+b1V346m2KwweSBPj2iHBG+f
	hGDT0vsQ/txK/dWE3aiDCjKSlALKvs8=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-35d9749c26dso1139079a91.2
        for <linux-mm@kvack.org>; Sun, 29 Mar 2026 23:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774850934; x=1775455734; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AYECvkLYIdqO7PMq8pUGmPwH0CV33XwnM84wxRtZNC0=;
        b=i6nLqqhnA1VUcvnfj8SL/tlasiXT/KlbCDHAAessuUqxO8K2gri7yH3PoEDXmivyKO
         XGot2qm2mpCXqOTNyQxEsMTgn+3wXSeby8fpH1A/DFJqN3NTPgoz+DIThDO2phZF0JZv
         rly0K9bKhagjFD3FxTCZBVCGHYUea0SSPmz1BnpXbqgwuiMDVwuk5A7i9KSSjn1ydQFn
         8oW37fsZd0zANzVuuGlCuIccjFh3Dg0+mM7ThU1hSffsNu6FM+nxOpZyFEkV53a5+zcO
         fjC8Qw3XJTNbEzw47+xUG6xxbZnDltz9RGwOwQWQ72HK8BsHCszohD4nOfZXcmyDYtGG
         94IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774850934; x=1775455734;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AYECvkLYIdqO7PMq8pUGmPwH0CV33XwnM84wxRtZNC0=;
        b=QYXRnHPU7lBNYXCoUJPRsN/vhfgkkhO/F45NQl8+foucsr2an3oYKLHHL6pWEIAEUv
         Jw24GPl6G/5f5LQ00LYpLy+1QlH4yHxZLcYv+sotKY+nlExNPvxD6GWeiYvBGO2I0LBA
         xa9cl6lA/kAO3m4gLunNiqaA7ZMPjWOYshr+FJKZCYQ9NImFTa6Wap4QockZ6aV76ut3
         eWTVKpbzWy1VgpN41cV7jG4AezTykVLOxTv83O5+h0xczm+ylWXhUeoqdOzThAc2nPQx
         7P+NOo/ZMrl5BEwG60EQUwiNlpSUbH3a86bEVn+8ZqqgPg0usL2uAV6NA/Ux24NDU118
         fZLQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYQGw1NbXsPK6a+TpwCJjSrSI8JipqMrYjgmOepqZGO69Duf8oxkoX/ZnFUr+O4AUwq/h02q67Hw==@kvack.org
X-Gm-Message-State: AOJu0YztfDe29JlD0W7mcDpUy6hCi7wpvHWw8bMtFjIlifqC3rkgEnlW
	9KQdqIR8ZyAp4ViK3gcI6ayJEoU9tMqtGSKsWeehFfSEqxPujvlDp/L4
X-Gm-Gg: ATEYQzwSx8gtPQnfmSV0kNeV0IfsUEeRfMsAE3z+8RW5RT6w+dkznvrQ0A9PtSdRkxT
	WRqHBhrLKHo5K7xZEdODqw0gd1jqeGAFSF50r5/MYDlnqhRG/sfUk8N1c2XEFvNuQ0PGU3tpzXr
	mVmpyYibiddmKktPj0CDCjd5SbEVessoNf0aDcMj97seLJz2GsDqEq0fZGKMOks8ZJlNzl6FGPt
	c36/Pq37g6jjnXHl6/2SAdDkpgcrEPORk4yhbf5CxpGMoQE8smHPwPA9AfOrPkSZ7BQzUReqChu
	/Dbys2C9JQoXhXyxBL/TRsUi/qN81K+VtI3ULoTTGbHGx2Or1gKCZbyAJ0ILRka8nZfB70oOc0d
	6i4INOQGGvbwhWZ8xNTMaPC98ptjdqWe0SAPUSF2RtxMjooPUkFwvOd5Fk349PrXgOTQLAM5uDd
	zpCdgLFy/Qhn8g7xsattBSVSbnFb26i7u/cKgWjzsvezlLySJhH+w=
X-Received: by 2002:a17:90b:2d86:b0:35d:a3b4:2f00 with SMTP id 98e67ed59e1d1-35da3b4314bmr3334498a91.8.1774850933713;
        Sun, 29 Mar 2026 23:08:53 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35d950b5583sm5840224a91.14.2026.03.29.23.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2026 23:08:53 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: validate addr_unit to be power of 2
Date: Mon, 30 Mar 2026 14:08:51 +0800
Message-ID: <20260330060851.4659-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260329151507.44171-1-sj@kernel.org>
References: <20260329151507.44171-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1C7EDC0008
X-Stat-Signature: cn78wncerra8z5yajep559w3jnkc9j4p
X-Rspam-User: 
X-HE-Tag: 1774850934-754882
X-HE-Meta: U2FsdGVkX18zMcHhUWdmCgMT1/kns2PEG/LzmmnWKxpUWfc1fQYwoPXHpVHx2OX0ILIcDbNn44MctKE/wFDf13FdSzcHxxlN4YMO3UrErRKN5f+2rRKaFsRHtgabFBVFC7Y9R+Dq7kgS7cJCilgrvPHL8kDbyyX7yDfayAlLa/8U9XqOxGkGjtAEPKGStif+qlv5T6gll53/YXyApQ3pOptRyVDTTM1OV/GK/gWg5PO8rF0Gg7fiYlPm0NjqtN/dHuBhLzsVPdlVPssmy/8oL+U7EYcNGrKa5MKq5/mzgceRDcw5qbZSDz/49mVmTzarW4JEieRhJ29MfUE14StlzKhS8rcis3l/YbC1D8dIXaCV4V8c0oSSxmCVcLOvyx0C/eVeptxYIPvC/NEotBF40qQPNZJKkbe4yA1OSpL1Mzg92T4n8yy6+aaVFPxM7DnauUcT22VXA0ZYxk8efnvY+hfBZIdQ2Ehbt1WQDYopzM8yp+GyqMcpkdHJOUQ1SPma3Tce1hHuQKtBvEuwp9atY5/B/mW8oEKP/kseZGFxvrrgfHL+J4OFJaTESmJPvkU+M5bNCyyn+H/cT7ahPz4Q4Q2pkTjPpBhjVBipGzTDDVzPosBh/CGssDDPv1+YrUS9N+QmDpUtCjnnS3/mtv08JCr8PMJyC14WZcGJG9F78xcQaL8a6dlemt7YeERyJoNTvnmsJK89uCIqtAZPWsVMwfjTFMuCQSHFHsf9GfjilVVDxw8sLqB9/49+Fa6zG/m6hOd2jTpevx47rGgoXhMpfb5WLLnuhmvcW7XZ4IMbIJ9Lv3tIBTLKlaqitD//VB4gSCKz2GgFpvkhTQsf5QK997yvvRZ2pxUEWF7bcLGM6Zc6kcAuLDfwEpdnhbTzYPxJGzbLOxUMbAQLjKmmYehXZSNycu0i4eXW1j4cckq8IUcB/4l+iMtPFB9AGeLpMHliZcLXtsS5HtRLJe3E2NN
 3CfF3ug+
 lrsNRh86mviz1ucH2yfx6MiFVjx49+3ufl8JB1+FbdVLhA1QEMWxiEi5Aa4/blPOyyvl4MGBov9JDXrV1hN9h42qEgU08dIkd5YKg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

On Sun, 29 Mar 2026 08:15:07 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Sun, 29 Mar 2026 15:51:07 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> [...]
> > To confirm, are you suggesting something like the first approach [1]?
> > 
> >     if (input_addr_unit < PAGE_SIZE && !is_power_of_2(input_addr_unit))
> >         return -EINVAL;
> 
> Yes.  But the real constraint is min_region_sz, so testing it would be more
> simple and effective.  E.g.,
> 
> 	if (!is_power_of_2(param_ctx->min_region_sz))
> 		return -EINVAL;
> > 
> > [1] https://lore.kernel.org/20260325071709.9699-1-aethernet65535@gmail.com

Thank you for the example.

The 'param_ctx' you mentioned confused me for a moment, as it doesn't
exist in the current addr_unit_store(). But I assume you are suggesting
that we should validate the result of 'min_region_sz' rather than the
'addr_unit' itself, and this check should happen within the
addr_unit_store() callback.

So, would something like this in addr_uint_store() be what you expect?

    if (!input_addr_unit)
        return -EINVAL;

    min_region_sz = max(PAGE_SIZE / input_addr_unit, 1);
    if (!is_power_of_2(min_region_sz))
        return -EINVAL;

This keeps the fix local to the modules, and directly enforces the
power-of-2 constraint on the actual monitoring granularity.

Best regards,
Rui Yan

