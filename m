Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33DF460A3817
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 12:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Sw+K+Upy
Received: by kanga.kvack.org (Postfix)
	id 4B1516B0701; Wed, 21 Oct 2026 08:32:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4614C6B0702; Wed, 21 Oct 2026 08:32:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34FCF6B0703; Wed, 21 Oct 2026 08:32:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A0836B0701
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:32:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2186D80506
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 12:32:10 +0000 (UTC)
X-FDA: 85346570820.27.7A3C046
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3870E100002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 12:32:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Sw+K+Upy;
	spf=pass (imf05.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792585928;
	b=3kCG+SFfXzQIyWEqBMaWOn+t4Ib2+hq24n3DjQyPMpAsh2rik20bpbQz2tjwW0v2t3EIa3
	SyumjSy8hmVxGWP8H8MRpnRLp5xWKXn7zedNhCLXTXB+Z2jI8FTooiZM0EC31+tsWpLRs3
	6egFJkG+e8de78iu6BSo3Ap34jYj79Q=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Sw+K+Upy;
	spf=pass (imf05.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792585928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ce1C2Fjg1s3ZxxFhfwNc4CspMfGOZG4qRjZvIxl9lQ=;
	b=YaJrr8s5arnYri7dWjU0zk3Vheck/3MTeMqC6D2ERveJO0QJCYgsnwdrZKoVwg4vmBiUPg
	4XCxRaBmBNToTq3h5b89xLdhKTUhaYRtp9cEupOxLOh4EK+dwZVyHFYVTKJFnvwJjCMC5W
	5pLYm1UJKepHEv2PCjwVT5RTqPqfiHk=
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-15dd124bbe7so1202496c88.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 05:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792585927; x=1793190727; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/ce1C2Fjg1s3ZxxFhfwNc4CspMfGOZG4qRjZvIxl9lQ=;
        b=Sw+K+Upy1SdZGaZfnaz3HIAeDdHAOsAqsgJXyGYNmT3SS+9m1Bjie5XjzMg5cPDL49
         i1RYJDQADf8U/eLtL4HGZ5P3qSFSkGqJYGBedPxsos8crool0sjvq21i6eGAFCPC8nE9
         Y2sngq1Mh1bDb6ZGGtxbSWIR9C0zd6JQ3NgF4Rg4repoRaeHL1hbKkDNygtk1SnK07QK
         C6jMIFlq7uYBKW/ND6e9HSmjB4WK53B+8DNolnc6CkWveR444e+3Pj7zWBDEcbUPgt1D
         XpyZfdEFA8I7O0IrAdWnEl5KFMFgdOvAdQXW07PgbkMp28WZSB4d4tH+UsTe1QqXacky
         yCPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792585927; x=1793190727;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/ce1C2Fjg1s3ZxxFhfwNc4CspMfGOZG4qRjZvIxl9lQ=;
        b=EisxZon6zxt1zpaIhfB1Fa99MMkXRFEKaN/KTxImQXBOcEYGyhNPOB5tlP0CYm5uN5
         rvKtQ2bzELVuGN5F2v86gMeCiwhwWXMlMOBmGnmGsQMx0/GOU41vwZvRkjQtx/JMrfx3
         B/Si72VQq9wo7eW+P2o+03Kz0kNP5VmgQI2RkkMjNHLwllHsRqiglMDR3PnaEPkCf1uD
         cwsZ3e10m8f67bp2fHYYaC6OBhnJO+m3g0oqgG4mXmXfuGzenHfMadp+bhVYEhhjXLE5
         ti7KpJ22t2QrWYtR0WHgDeR9lu7/HCbvC0vCI0FskyNdA2cxfxsuSGvTb8hmxLfb0B05
         whcg==
X-Forwarded-Encrypted: i=1; AKwUvBxEn1oPyQfCM0gCs/JyExtkn/ecI/Mga1EztZla1ldm/qDZVTvXz+wGtc2nkjB9H1G3iV7g5zfsyQ==@kvack.org
X-Gm-Message-State: AFq9FYKlUV9lIqkPxXOez8PP/prkviA2/nO5dDvHEmkrHSqxrtMZvlOV
	dCizrAdkg52/+iv9XTiw0+iFsAVQIgBJBG6UDqcPSj5W44PI45RuNKj2
X-Gm-Gg: AYBFou2RROBnXMf+Oax1eK7qIS7yn73xpRggdBb1M51xBAu4yr5YD0Wl1j3dCkNoY5V
	BkCy4mCUoCVwp7vulERz+TObDq/Id2zfsIifCfFxiGso8iR/DoDPRQh0kqrs0nHjbK8ysAWYshp
	oKIhQIM9CX1Tro3vH0QzbejY6OOmBWA5j84V4/BJweVMkl490XYp4tEEl3qsJWx2G0R47vDNkzF
	HUHZJlDAqL5LC8+QMb/PMqRsP6y1jFLWBVP3fskC+HBPR1D57CeabJfJTPTy+dZTeSIsCHESZdQ
	mhqkcLeKlcRLyh7KO052yQBkelBQWcS8Ek0G/+D3j5jyBYxPVKlQUPIIy/o9V4WknUmC/Vmp9P2
	4pc65nQ96nmw8fXmmZDBsAnRuYsjDbK03D75XMvmwwPrWqiU5WaxL/ZLS8cxlCNOqs0LeOjAMh9
	rWC9sYvgNlEwiyUhy9pCngaY+8SeP5uJh8J46Nno6ZeJg2RTIMOAt1kdfpnvh2dWFePWGj5TuCA
	f7IuxKbP2sT39aeNIf0LXXvwrMsw+OOibFptUrL2oEzYcdCjC9yYMDFyMHSXwn4rWl1T6m6Cw==
X-Received: by 2002:a05:7022:5f1b:b0:14d:baf5:c419 with SMTP id a92af1059eb24-1909f5c8400mr1785476c88.6.1792585926762;
        Wed, 21 Oct 2026 05:32:06 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1903e02901fsm6268475c88.22.2026.10.21.05.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 05:32:04 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: vbabka@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhaonanzhe@xiaomi.com,
	lipengfei28@xiaomi.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/4] mm: compaction: mTHP-friendly memory compaction
Date: Wed, 21 Oct 2026 20:31:55 +0800
Message-Id: <20261021123155.2295447-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <e6ba0e36-c0b6-4cd0-b2fb-fc288468bce4@kernel.org>
References: <e6ba0e36-c0b6-4cd0-b2fb-fc288468bce4@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3870E100002
X-Stat-Signature: eo6zp1qsc5bmgmus3rgps5acqmnmub7c
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792585927-960094
X-HE-Meta: U2FsdGVkX18wiVMGnnlltrDBWTS0SdguyqTMNvxVmEHwl3MTsj0bSU5yw8/YjuM+NiAbfCAiYurimApNeuEoCXbic/Mvw11eduRZMbmXuVv183hyYSKWhOP+nj0Ul6JgADb/tIbE1S6rcxeh6KuA7SXy+yCWNkKm98f1umdCoEcG1gbJRVUNGcuvUf4gR20XiZniIzfoHLR3AvkoaAuKz6mALJsiwSkfxa5PDSg+VSP8Tc/Vbm+3MyZi7oKuYJwMqWjF3S8NASoHFE2KZ6Bj6EBq/hHegiQTRSqWZT+L6yboY31g3zvpTwHXE0aNZTU4pRJNIHna2F2v3DUr77VA8/0ZmgKdka2UqG2NBB6zopOsXjo7+AmwJX7OcHhcl60mv1gQcO1vW0Jhu4u+vfs2sHF8eCAGB6b1AwXD0Ss7YXLIBV0Y1jH2CsuDZBN2ppom9gwjUTLT2nWfCuRVfrsdtVrdzM5VtiUHIBIG70ANlpygI378ITFXtyJRVS74ZGgHn2i4xVu4Qa5bB8F6VtRM5Gt7Mb+kCEXdsDhArOJ0vhek30DzxtMCxwBgDnRIE9fLVSbIRbxtSt3foeKd5D3O584F1Kz4E6/QVDMZpWxa+rGrm0CkspCMK9dDUXpUERv7W8odMAsAxFb/CGP7YhH1fl6ufJr1qYFsdNV9rqNI1z32kYwA7VuTkC1ruqdSVvH+Z6W/E535+teVhRcK9uxs3M1iJZ/H5R6NRNU/rQUcXQNlr+Mbtulxj6JY8R2w/BKJEckG87rz3eumXx3H9kZxfxp6C+U6qA4/PzILGpy8caafRHQE77wqTIwEiR5HC/yHDqm/mTknkYJFb7eJuTj/BDa9fs4rPHUvWkaJRcy2lxa56C/3lY9M9wfEXxE3uhseyfTHoV9oEFD4ujNKmMIX7OYiuYwi0KHF4LbJTdb2TZSQW8V+zAfHam6fSNEeV6aQZPoQMVbOl9zTU1JH0r7
 xN5+XAZx
 70MdrDcg206GWRse51eL4Fpb4Wxr403Jhs8QL0FQ8MW8SbIs8EpHEalt627FIWrOqD7LzJpop7ZzR1N5SnJqCilCucg8taDz279Uh2gULXZxdlhOSyVKIjUr/DS68YMlePeetKqz4qdkr3Ils3ieO662tZtnlP2mIe9sdVTsVRltjKPrlSeKfnyhd3UXQjn0U8q1i+13H7QLtGgQGk8Wim+CRyxZdjg1DejcXdoLhspr1Y/5YDKOQ7DLG4206H/LcK8nZr6QJgXllYUATxEbxYrp8IVYfSHizJxPeAy+O/Hrj/2SebzBdG+Ewxj3+Nf8WKMXYuHTjKoLd4kcj1KZO54RHXXUnJPSO3lr+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/21/26 11:31, Vlastimil Babka (SUSE) wrote:
> I'm not going to answer your LLM's questions for you.

Sorry for the previous mail, which polished my English by AI.
Let me put it in my own words.

Last mail you advised me to use cc->order to pass the target order,
however /proc/sys/vm/compact_memory and kcompactd work could
only be distinguished by order. Because in both cases the variable
direct_compaction and proactive_compaction are false.

Without adding new members to compact_control, it's impossible
to use the bool instead of is_via_compact_memory to achieve the 
same goal (Or maybe I missed something)

For skip_isolation_on_order, I want the new logic to take effect:
with a real order it will skip folios already >= the target order.
This is what patch 3 does.

I will keep the original behaviour for fast_isolate_freepages,
suitable_migration_target and compact_zone functions. I will use
the bool variables to express the same logic.

But in compact_zone, should we exit the compaction when the order
is already satisfied by the watermark? That is I want to discuss.

Thanks
Bo



