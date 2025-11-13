Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27F72CD4F35
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 02:04:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 828DA8E0010; Wed, 12 Nov 2025 21:04:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8006E8E0003; Wed, 12 Nov 2025 21:04:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73D9F8E0010; Wed, 12 Nov 2025 21:04:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63E148E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 21:04:13 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 11B724C958
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:04:13 +0000 (UTC)
X-FDA: 84103938786.19.8130AEB
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf15.hostedemail.com (Postfix) with ESMTP id 25DA3A0007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:04:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Kyv4VMmG;
	spf=pass (imf15.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762999451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CoWXrd8JO+QikmbPgskO6RB2/Wy00bhO0gKhHUyvMV8=;
	b=p9HiuKGytXhYCj9uZpoNAJEqhEBsiMP5ahxRMR5HQSTwfmtjviRKmACc9PR2xqV62mhyds
	rgcEfGpITcX/V3PiuW/wC8GKiM95MULyyWnpNTIlEZG+occzhyC0OcTjjv3fR4OwmUsCbp
	n5OopUUkjzSmzsdcQZWi5RdKthEmuGw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Kyv4VMmG;
	spf=pass (imf15.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762999451; a=rsa-sha256;
	cv=none;
	b=YXKUgAy7Zyf3fYMHsuK/DOtYPtbaZckBQV8GE+26NEiTj9hl8+OtpdAUO1INOHjpozjvyX
	chu7t56pDbxtRsxXqL2P7aN7c6Vf3NGhLXd/vLy0kR27AS35/M1RpOEoCc03IU8P7ck+nv
	SjqqDYTFFdYKq60n5Be5+vEB81F8t+8=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7b80fed1505so223527b3a.3
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 18:04:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1762999450; x=1763604250; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CoWXrd8JO+QikmbPgskO6RB2/Wy00bhO0gKhHUyvMV8=;
        b=Kyv4VMmGUasuOUk6JR1VPIuMGax41bsRuGLMOji7Apmsymg3uBhlLg3yl08w/IVo+D
         6t2P8yEk13u39j7VS73Fj7PEK2Qaj6Rsf/A1JmLam9jjM1ucDnm/iMfhI36Zpx9UgiPf
         0tiVQhwav6DN9s0qJznVkk4DnHGe0lAhb7QWM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762999450; x=1763604250;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CoWXrd8JO+QikmbPgskO6RB2/Wy00bhO0gKhHUyvMV8=;
        b=P4iMrevplx6NGzLlo2pRjKR9wtZScXUaKftAhcXADF/70P4ZubHTIyY8JhJDRh0Kx2
         Z7ftnVEX4d4eyYhS2PvuxRNNXatbaEv38/a4FjzoB6rmdACZ5rE9jTxwFQwRFunlKmJv
         fsLHZJO4lFNNdx/yJTWd5hHC+/r5XHkjrDUy2c81SOiPlTmtK3y2OpqluiuMVDf6pvdH
         zt4+Iv49q+OG40yFpBNTfBfhjrYMQEtVjsEKAqRt8WH+LifM568LH/7fEPjNXibo084D
         gNWTU/sYUJbDZ9+4Hdjrllls/XofxDmcoZkGlaJfHnXu6f4UUGehp0OH+EN/9ROOfoMH
         CTSQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxThDUsTZY5PfucWFp6T6WC9VJR8d7yXr8WBWL9CDlp9Cfq/u1F9xyjGUTFkiIzpS8dyKa4dYW+g==@kvack.org
X-Gm-Message-State: AOJu0Yy6ML+pAYTxb4hhj0sGA5GhyBSGtpvQNn/kZW7V+pO+LAC6XCMy
	V5IY6cr/lSzniytABx2PrN/hq0dXdTJ+NRTd1AvQ5tI6KMXNjbwL1ySyXTscRBtKww==
X-Gm-Gg: ASbGncvKns8pQXnkJ0jVCJcggpz/ZnRZxtTJ9ZBJgXeNVA1TJ3fCvY0xgLMAc6776yM
	+7TTI5LkLvZOhLpjDycKDoZen+jx+ywKAFDH9+AkVktgLK++nbVhqtAsyOHszy/aIxJfCXJVVpq
	weswFH/UgiO4QiYKbDcsMKhCU3pDOsOoFJq9s1mQzcHPV2rklIqzYtROt7gUnxFZcCwPMp1oVMI
	mrq0zCOYp63NV7uEGwb2BGY7ML6GXuzxH5ys3vz5BJKLla4be/ENEGz6DvykyNobX8qGtX2zFUL
	oSIfeAIEolWWK84NRxs7aL7P6jNbemj6v72zocSDUYmGbjSXzX+qdYmRBkpfwBI5k+D/Rn4sY4R
	A0MwZ/GcNbyC/YJLSkexao8AKX8m2KWCRQ1qWM1HKzxfWIu2gh2yRVs6fCLYRnJPOPDYtzJyAVF
	39PV3t
X-Google-Smtp-Source: AGHT+IHfZ2N/MAyyzHG3SVOhKMI92QJpBdZOkjEdKOIsG/60o7oByCcoSoeNxaOzOVUQsWD6YUa5pw==
X-Received: by 2002:a05:6a20:e211:b0:342:5901:fd94 with SMTP id adf61e73a8af0-35909690c20mr6753978637.13.1762999449895;
        Wed, 12 Nov 2025 18:04:09 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:2495:f9c3:243d:2a7e])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b927731a72sm389619b3a.50.2025.11.12.18.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 18:04:09 -0800 (PST)
Date: Thu, 13 Nov 2025 11:04:04 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yuwen Chen <ywen.chen@foxmail.com>
Cc: axboe@kernel.dk, akpm@linux-foundation.org, bgeffon@google.com, 
	licayy@outlook.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, liumartin@google.com, minchan@kernel.org, richardycc@google.com, 
	senozhatsky@chromium.org
Subject: Re: [PATCH v4] zram: Implement multi-page write-back
Message-ID: <rjwycg4sfzuroi3yzsovtebwocabyoq4vq4fuc2cbh3w4n3uo3@o7dpmtvqr7fe>
References: <83d64478-d53c-441f-b5b4-55b5f1530a03@kernel.dk>
 <tencent_0FBBFC8AE0B97BC63B5D47CE1FF2BABFDA09@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_0FBBFC8AE0B97BC63B5D47CE1FF2BABFDA09@qq.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 25DA3A0007
X-Stat-Signature: me566y787c8anm9nfsj9wgpcas9tzw4i
X-Rspam-User: 
X-HE-Tag: 1762999450-936809
X-HE-Meta: U2FsdGVkX18ln7CHqP4hhkAvt0iiQg84UZp/Cj8AuG3Q3xBRRhdnbPDjbhPo6YE/o+sIpVv/ULJOGLERwNISfO51aEl+RR2FenA5hz63/hqzVsHGKpvbF8m7AwShtd46vPAoJG5e8vYHhn2y2YX+UmcQ4ZYBEmMn1F6Khw/LbA6b+Rfgi6hRAuXlo9iWgMwdVpT6v9cZkBw/HQCfldf7HVb7zICtEY0Q2pAfC1NU9FoZzFxwToO6wZzzfz6ieDh5o0pU/EXx6R+Vc3KJeiLAm/GT5ZDXxsSTFB3fPvA98LNmf/EVmUTo2mhLTvEYbs54Hqtm/fBsSPNbK9feY45T+fnTbr2rGGyEBv7fi2ARSMUtVwJieUALxQbjpircV3zeWro4v5y8Ug+6IuZUi+X+tQYNoOW7cdPJRHqWu0S61q35nIfbuHIT918N7A4btMrDtao7D63AAq0pluZA+cFJcu63MUudL46jm5gnWbduo2G7SxtAeUU4TECcQqzEM61pDa1FL+gEvEgXkRTpbcUC3ndhFWqko7NFO2QXuoLMB9UzHaBb7GM/dQA8oOU76vw54l+ej4nWefl19B0cGRMDiZEw1iefWp0sYg/1MzSmuqmmN619FZn0oskab8DygKSklEJZsJzWFfl9G0f2Gbng9iOGPFGQw2mndB/sr96BYXTNwlxYDJ4su+dHfCJSJ9UDmK4TmKT4mLeuAedhQC4BdbxLMYuWavFPH+RyRbOqFJnSsjr0oFekK5Fys0h8/QM6XuuMCzT8DBNxg+cXWld587fdy3xjYBcPz2xumuFzJ7m+suFCrp97+RmoL1FUO1Q1uHoSsJcyD7XJLiSk1Ns9YY/caLzF2o3aYj9+GOP6QwyxYUBBPgtfLC4xiO7ZNYfuFNDCODzJ1UN5KlHPWR+8XwWUdihU0FzdiIDMOOgBmxs0JhySCwmTRd7t/5Y1Z9lhTGK3Ye6pvw3oG9Hzwev
 EJsU6vMm
 rtFA66mUhsGffDgGqJv+pkMWUBVwubd0nya7LEchx4dhfGJ7ViivTnjUgdvVve0IRdcV6FWlfBQ8bwi6LVykzmQoHPTkVj2TBrnVde0z+oi8cgfvWu8mdV6E0lsSeldA9QyJLV+bsioYZGXvt7N37oTD5lO6wJzrXphoHBAM9LFgLN9mBn3MZBgaO2axNAL3pHUB7SHVq0L/V6Pfut8g5nwBDYQlcyXmdiRT/XK7qEa6k+qbcT38Y+pZPBysszZ7Zk4vlsWTOyppHCZvS4TfXSV1CX+gWMj28ccyhbF5bT85j9JLf2QWdJAHqAZ3dmKdYXtw13rR6hO4cS/9bE6m0fWxFBak7v9gwi4lG2cmV4DGol5c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/06 09:49), Yuwen Chen wrote:
> +
> +#define ZRAM_WB_REQ_CNT (32)
> +

How was this number chosen?  Did you try lower/higher values?
I think we might want this to be runtime tunable via sysfs, e.g.
writeback_batch_size attr, with min value of 1.

