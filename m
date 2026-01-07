Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FAF0D0D143
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 17:15:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E9AF6B0088; Wed,  7 Jan 2026 12:15:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A0A46B0093; Wed,  7 Jan 2026 12:15:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F7376B0095; Wed,  7 Jan 2026 12:15:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4F77F6B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 12:15:39 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D166314044B
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:15:38 +0000 (UTC)
X-FDA: 84305819556.05.C9E1D1F
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1113940003
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:15:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QOSrfjIM;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767806137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=NKbve2SwUIpcAyLnGyzvhsAwSQlv2h8Y1ihQLiLxyzoMccWfIRSPOgmw+2b51xQq/cFOee
	cF8sk5uonpkE7tmnsKNBtOb4hki0aJzOGzL8RxTRzHd9cuFLIOsMBQfpDQdCS8QsxF9Zuu
	F8rCZgJFkJnbL0NEn/DTfHJJex5ZCNI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QOSrfjIM;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767806137; a=rsa-sha256;
	cv=none;
	b=slw7ROabyr17HvekpflWpmzEXPkfkUesrCGZxp0ifBWlrKbueMIlUbuDNtNP+p7t+X33SN
	c20I+ltNw0KFH2xWGlqVHAccCwL4LvpXzAEnodlZjT1yDvflhm6zvj2LH+kp8LyicR3WBs
	0h7lWoyDAfI1z8kFmt6FOdUppfWueao=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8907f0b447aso19628386d6.0
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 09:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767806135; x=1768410935; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=QOSrfjIMbCfOtjD4b+patybfkGbHFIELUuTmc6wRyZAFJeJT0Np5N4uqZrgAmP1eFU
         J6EuWMMNVEhwg2qyBdK6SFB8JwisfYLGmQ6f2GUgBSWe9THD6qZYja9v/w4c2su64Aqn
         WyVM2EV7wFeYcsg6DVTfp+ppGwNbRu1wHp4h7UXFqJ0zU07ZAI2/z8yDgqhB0bS7WPgg
         AAGAoLuqDAE7idksP2LIzR70Tjv3IPk3B49u9IK+75zexeRuQShB/N8YSGN9cd69MI00
         FkMqp1jCWsTPQ+1W+P1YUCDkELr7Ocog0zSd7IGT6ROCJOWIfntUTdDKWg2gyvpYcxXg
         JuYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767806135; x=1768410935;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=axNwkBTgqw4IuToUIq5ktkuxA3OLCeXB+HwawJJwhx98Hakf4wh2Ha5r0ScrC5QgXT
         NmTlHwyyoKIWAKj3m09UDgiq+Jn1pPqfnnFEhI4bs+SdYY0M3QnGNg2/TYmI/8lk3F19
         RK126aYh+kCwfmfR/9CeipY+jXarJ5/DgHTbxsmHknow1QiLkBdwHhYKubiZk8P05/ZN
         7b1mywKZLO+gyp6PJP3R17ln2z1gATC2NGsUkAE1Sd++jQeTx9OSpSppAxHV1ePABYZ2
         9wZFKJkgcsevnbDkFm9Kjv4U6MkeNDJ6cidLKrnkY4Wm9qKMgrUrJNm75GphTD6AJ8+0
         iZzw==
X-Gm-Message-State: AOJu0Yz0f77vWDEA+Jwf6RRdVWcUIfTh33Bo7w0o7m3HPfUDGquMItmg
	tfQSkI5+GgVzWxQ0427rTRv0g0AOQObb990GElflLJGT+chVxCtpHX7N+oaGFq5jKn8=
X-Gm-Gg: AY/fxX4qOTngdV0BasxXWIgBjVgvf5m5rFtdmWA6Rtw0eD66GgGQBQgFKFPh1vtu74g
	G1pTFYSdEyuykGNxiOHNoxL7NJMHvt2Hhi1RcqInfUpA27paBlQLo0iCKoFcYh6bbdH2q2YTK9t
	csakfMB/Zq3hpDkut8UfP6f51UDSNHzq6ocr7KCnPzDqavfYjNYZwvAJl43MMOW6qexWaQ3JoRS
	0mmA0kx5lSq2+xyyTais5OiqYUGMnrBUK2aFOCMNYfeKf3gEDDxKVyrHuJZ3nsGRKPr+QTvGkUv
	VUTBXYNlwQw4hnh/Qnt9r68QdeAKkFB3FYB0Jf2oAMbqiTptJgTt/vDiZecys8nik3ESzJfvXEN
	b98/89Ykbkes3THyC87Loam7ffmIr8XtD0VWAuKwRECLTsULRsdRezMFUsp2ZbRyMbxAbmrW8Ku
	wR2aLiQMHRAFKKANgydZhYicux3UHm5TUot0kdf8lrDcdq7KI=
X-Google-Smtp-Source: AGHT+IGBcD/eFtEImj7e5KYE8GOV6+e1HKiyKKDtFqn1cFCTIVq/A/5Pxj6UDNDHAc/7Yp4J5A1Nrw==
X-Received: by 2002:a05:6214:20c4:b0:87c:152c:7b25 with SMTP id 6a1803df08f44-8908417a83emr46946426d6.13.1767806135006;
        Wed, 07 Jan 2026 09:15:35 -0800 (PST)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8907726f1f1sm36313046d6.52.2026.01.07.09.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 09:15:33 -0800 (PST)
Date: Thu, 8 Jan 2026 01:15:29 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Linux Memory Management List <linux-mm@kvack.org>, 
	kernel test robot <lkp@intel.com>
Cc: oe-kbuild@lists.linux.dev, Dan Carpenter <error27@gmail.com>
Subject: Re: mm/vmscan.c:784 __remove_mapping() error: uninitialized symbol
 'ci'.
Message-ID: <aV6TfFOYng8mYzK6@KASONG-MC4>
References: <202601010353.E7g5cCo8-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="__Tagbar__.1"
In-Reply-To: <202601010353.E7g5cCo8-lkp@intel.com>
X-Stat-Signature: qdywqkk6naknf1b7b7o5a374uw97dot4
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1113940003
X-HE-Tag: 1767806136-59695
X-HE-Meta: U2FsdGVkX18Kg/eJleio0vHvvBhwA1mrGsLQ3wydV5puS/Z+fPKT7SIXbtv3KjYoc0e3QvRk5SP/voulUvxgm33fMMvA9PPR7x+zi5tW2DxKp3I68NEtEvXh8bSvVaZEKxz8GgykK1j8B8aEmsiyrncspqw3i0HK9Atsv/S0f34Cj2EPSLJIh3gHvUJ0yKhe5Uf94dBfuGAHNGLqgdcNvh/mRn4gtpHoPg5wmd1YmIeg20T8Dxj1rMZ70rZftUUXrdYx1ikg6UOJRjTxV7PqtxsJhmd1iDT6smySXLZuULjl3pI8Zq8r9kQk5nYH1UdDNbHh6d2BDRzPj95v4/0d0WcHW+G2DuhTSlJyJDKazARSV5NbnhzwzjFB7lugvgRDMjB/BwgcHVfHwjSDeKZ2HbaiZmqOagUoQHpH4eF/hW9veaAR3ptYngBHmeAbRVpohIBL6hg9yIqEH1pbVaIY/7uz1QVAs+QJzdwoLdvJUJrtwVugDbPOTgLI/lPKx1PKLtnRN3Zmk2SF3D3vMrwhAwX48Stl+Rl9AzVs75qyICnUwGHZWnR+xxRnwiZvxQucFU49PmLS81wUDL+p+OBoeIGwyO/SK7ne6L6GkYQmmKykTa6JiwkIrVJWX04lDPYfnUjp9o6kkUKIaOPxsbefxgDntUGw0cAK6RwLrOOGBo0qJUBbqN8CXMtcuyMCYVT4tK8XBTRZSRRmbHhYkPWL9ZSCZOddTDTTFVkx6/G6OAoINI1XfrobnPZ1EHFZfOO3pH3Q9MJ1J9bHwMAu+lnk8mm0Sc4wCwAoE2dmVByCnK02K36OwlLDHS59dmw+AoJBfm7h94LbpSasgN3cBjMcY8Bgz/wzauVBn0Oy4CTZi3aoHVP9SiqI0INdZjaREM1c971sNQufRtD6hhu3Km7EcvpdZOXMOUDfBgWPd7aVDuarUEekEXtckZQPIli1lNZrS2EdCl8bAct6WT/bFmj
 dtgauGCu
 ocPM4o86IqJ/RlciTOAn1xUF545gaJLnhMTh3pT67lFD80wMDZiaj2ROIy4UsF8AXeCyDfDxnL/P7yRDYKyRhSV0T49fJ0KHG6AsdML6WPABPQ8XPfM/XQioluFFyQjek4b+4ZhJb1C6xzF2HloraHZ7+Vsvv8fGcZlCrIKIQF3mig0Z9dMWO/wShIh9JRqr6Z7ozvOm4q9McdpYG8R6NFh8RQAhSTl6JgAzz3LqbSIhOSq6tyF3oLxK5yuLXYZbucLjFHy7vY7mfae4pPVWPBmsNRn5u38vLhZxNykmawiqtAFvUnsM1Xy4pTDM94zK6O+wAfKrc96z6Ilp7/pSM+2x3bT2V14LpkP5lbhouSuc1NP/tbvY5p+E4pMei6CUDMzlgoyzwbGWjLM69raogCz1uDqlNCcY8NbG0gOGzTj6FfdimeJgZf3k85tYhgQKgSza8XIbNQHkavvrsQEcYXQVhSo8cKHKDIMWuJDpOMnHpb+MjBg8+Ajs+nMYPti50ZpoVfEiAHyIsms4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000064, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


