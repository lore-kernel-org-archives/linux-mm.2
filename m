Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B0ACE66882
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 18:17:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A16B6B0088; Fri, 19 Dec 2025 13:17:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 172526B0089; Fri, 19 Dec 2025 13:17:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07E866B008A; Fri, 19 Dec 2025 13:17:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ECE576B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:17:44 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9771B569A2
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:17:44 +0000 (UTC)
X-FDA: 84237028848.25.B9A1C5F
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf02.hostedemail.com (Postfix) with ESMTP id B56FF80010
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:17:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=TrCsy59G;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766168262; a=rsa-sha256;
	cv=none;
	b=YbB9hW498Svya/1ffnnLR66H+lsO92CRFwzQdmVaBeE3NX6QwwQipQ7lokOyPblcNRi1Ae
	SPJ6TPS+7tqVnWhRBsGgbPVGXUtrED10+OVJTFj9ziCpTV1DKqutM/hOjmPYAqiL46Vdvh
	1PFXMUbu5C253aPeNqEFZh+m0m05p2c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=TrCsy59G;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766168262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=25Nxn7S4ZrPxgXaTUt8/8ZR8LkJP8cPlzufs9a024sI=;
	b=VU0JY5VE2i+9qq8t7/Je07WDAbTD7jFu3uRQHymPzTWjMn1A3n/bBsZRgXTtlJO8Maf1sD
	0GtTuGyq3OJ87zCfKOmG7lglh3yxxEZLJspdHOvmxyK1PfTeb2jxIv3FePGtFdut31subP
	moDCOKHJvBryz7pXwfHt9i5A374EtZU=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4f1b212ba25so17361911cf.2
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:17:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1766168262; x=1766773062; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=25Nxn7S4ZrPxgXaTUt8/8ZR8LkJP8cPlzufs9a024sI=;
        b=TrCsy59GByy5zQurveJd0zfACroFyLuJShy7c1eQ84h9MTO5rdgUnG7Eh6vAQ6+jqp
         koxnkeqDjQCyU4uItXqqDcG2fh7NUzZhJuliNLqv/vG669vSmCL9J1FJ9YKoo8Te3k7Y
         VOjGHtoatBHkfrONhH7oMnLhwSh3tMl53JU4ZDIGbK4QEA7quoFrwALB2Q029sREIURu
         9QoukT+MjRdkqR++C/1miqtPuks7iRE/fgusYgYxvnZZfY3NYQOZao07L7jGHUfwfrnw
         5u67935UEqhagl/U6yWMhYR09e/zt0VIty51EFScAWNHRzh9aKRT28cR++is7VoW2iqG
         Uslg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766168262; x=1766773062;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=25Nxn7S4ZrPxgXaTUt8/8ZR8LkJP8cPlzufs9a024sI=;
        b=INOKZWuXECw5U7NN8ml0QLkjWSv4ytRhetX/mH/8q0p7H/T4Abi97eosjLW5FNr4gL
         WS7NRCu99GRHr4yfGTwbz9WGXCwZEsUYbRxnXL5Z0FObGZEb7IMY2aNRiGTc5FMfVUET
         Zd8frWMrjVY7LIXT51fuPUGjhMqhgp9NveByDksrHNjf1z1glTDW9no1U0xgifhShi37
         LPV5BusuisHlDdfzmngpWsPJ/dlvCLSAh8PMK0lsfjei70XoAfHLKxC9eNKdLutp0Pfn
         XHG9dOkzzNa5BpHpqVY4b2899f8qGSSiP4uSwuXPZhRdyn/AYXkFJ2yiPiqhyOVo3Srk
         dvKw==
X-Forwarded-Encrypted: i=1; AJvYcCUYNvzjPMf+RatBCQ/eSK3uaQFKoIpj/lSMaFe2R+FxrwLfX+4tlGOmZbLJ58/5yVFjf80aiWliXg==@kvack.org
X-Gm-Message-State: AOJu0YxT6RXm2K7LhuP99ngJTSnSYvtpziHr5EtAsi4NxY6bv+KVIXp9
	Aa/NvtJ4e367joKwsTA/6XQTrpAZmgbfLTAUdsJRVv/1zb9fGCOxhieuTwjym7W4S5s=
X-Gm-Gg: AY/fxX4PBHPWluUzZWYvjfv+05K9quDnMMsiFlGr8hTBodzJFDp3OaPoMyXcqYx6FN/
	RnBUqcSPoqHiySpOYBaGPHgF+VkdzzRKuZ+9iCZwfVvxe5DCkY0T9WY6+oqUJcesg8L9bTXytbk
	DKvZM35qCN76f0ODG9qa2Af9RZb+4ERoU7eXh2/40z6C01mVBtk0bHh+NHtmSm0tmTSaxVd9mUQ
	szPlXVvGhiqc1dZ6cF9oNPvczObpHMbL17VcjZTm2hYUbYGYN7p8rydNs2/01dZ3lR1B7KYmTJC
	iXFRxZnYg3tRQTQ0DmKwUW/42zHCvsoolyWRYq7Oa9LFgO1zZ3nQuapd9LlMMnpHY3nChqTrJus
	wWgx2/k7mKM9oGUhVItXu3M88nC7ASSI1uA8r45CmnKld+stzpIHdNlSZtDQovZ6EYU8UNYMtJt
	DsoiVOxQ4tfVsu2K71j1eBbiFh3un+giB9LFZ1ebALh12IQ2H2kUH16slXsEXFfaubPY9s2Q==
X-Google-Smtp-Source: AGHT+IF0gYf3nQ4VOxohCT8XCqBK3I81oOq0wI0PXWLv8zlad6o6AnkQGLlpRe25NrPXHzjn0M4qyA==
X-Received: by 2002:ac8:5a4c:0:b0:4f1:ab28:d9f6 with SMTP id d75a77b69052e-4f4abd03195mr53240571cf.26.1766168261524;
        Fri, 19 Dec 2025 10:17:41 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f4ac66865asm23376721cf.31.2025.12.19.10.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 10:17:40 -0800 (PST)
Date: Fri, 19 Dec 2025 13:17:03 -0500
From: Gregory Price <gourry@gourry.net>
To: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
Cc: patchwork@huawei.com, guohanjun@huawei.com, wangkefeng.wang@huawei.com,
	weiyongjun1@huawei.com, yusongping@huawei.com, leijitang@huawei.com,
	artem.kuzin@huawei.com, stepanov.anatoly@huawei.com,
	alexander.grubnikov@huawei.com, gorbunov.ivan@h-partners.com,
	akpm@linux-foundation.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	harry.yoo@oracle.com, willy@infradead.org, yuzhao@google.com,
	baolin.wang@linux.alibaba.com, muchun.song@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] mm: implement page refcount locking via
 dedicated bit
Message-ID: <aUWWn3YMOrPdyY_c@gourry-fedora-PF4VCD3F>
References: <cover.1766145604.git.gladyshev.ilya1@h-partners.com>
 <81e3c45f49bdac231e831ec7ba09ef42fbb77930.1766145604.git.gladyshev.ilya1@h-partners.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81e3c45f49bdac231e831ec7ba09ef42fbb77930.1766145604.git.gladyshev.ilya1@h-partners.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B56FF80010
X-Stat-Signature: 3m8xnog8wrx54dyq9raft1utyskxyrc8
X-Rspam-User: 
X-HE-Tag: 1766168262-490565
X-HE-Meta: U2FsdGVkX194FNv4rldvJYqKKUb1+KpIKJ9P29RcCdPRYQOKspEI5X6CPIvPh1z81blgUN3/QhB2bZr/4lpR5ykbguPuqCar2DvYT309VNCdPRHxpLwQfTNWInQRGxKYTon4UhBPxGYWRPIc6d/E0Kxe+9xujRlfWxX5LC3OCPzTyAkLHGbfT7VJSCdI0MSXb5MGc57mBVgxBqrA1R3Ww5EBiGABfG02L8YBd2zXGl6IU7PD2CUy+0xXytvM9YwKDN20tjDWp1zY4m1i5WruqMnzmGtSxns1JrPNN5ELAyiV3JbpP90/uHlcD6UIZz647HW5Jmgyo/CFT++2lK33C648kzyCuP6zDFul1dIE4Eo0crii+XnjzfJBfphs78kEGJkRjChqvw0hkttMO4P/XN5xsVPHvSOrA5wLlaiHW6Kv8bWG8icLFj/HHNfbeWRw0I/S+HPZzSYcinHz1QVNC+o1GVp7Zbzep3uOxErzE5/4RrJC6gr7WyOFz0trbYwQ5g7aYth8nBiZny+qt8jMupUeS4bnKsZuFbaHY1gUoOXRFH0aXKqnrBopAnlabZXdHB5e2RGuZk7Ulle+2LTsabn3PtcdwRZvzzzU4ZYhbHRUuPNwzWmRGdzJjjoMH4gbEbWh97ytqVX4HPbGKlWb2yCWoSzmbadq0KEurA3d6d7cEbrR6xjSOmSiP7ybWwVGL7Fr8IfT7HBpWXhji4Ef3udtKUS+Q7RISG4yoe6s3fGQPwEWm/4z+OXWlzvIgaRqX2lO3Xf9YE9WJGKTPFccttKdMHHxdAu3bZv/3ACnJeIRqf83rm4EbwDs1BMM6peHBexYodJUt5LptcgSVk7RUGlHuy6cFw9uhzw3/L/CCxvvaOVSB9VTofeaEOk+w6y0pTYtK9VJ5m9hsj1JjuRwKtwl86XNHot20A0TNCgbbnDXCl+nnlxCN0lAu/1wwdjhkmgKfQTqIBJaO2AsV65
 Bv9z2Mip
 eY/KfsIJKLvFN3t1zsGv+v96dr1CI5DAoTTEt1J7Jl1tIUfdw9C1szImoVgnyXoshIvnTXqloo6PhzMV4BZw0d/uy0ZAFySD/hhJSnLDp3qEhu5lC4BW7gYK2Q/dXxR5HVRqr1Vh/vJ/y04h/FLBGpxuwS6feyoKQiNg9+s2Wf4V06sU38H0Rzg1a/qPl5rak2wCV0TI+RV3f0tyf6K9Q6ExO/gkn6/9jMZBuCDfN700kkDhvzZEMPYMzrxbBq2s8EEwPPGnd5hKvdjywPgaVz7Q2agVebrk73LtgFAbwh8YrCXTkz/WeQa9X0Yk/O7bbiXVXNvvKcWfXzcs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 12:46:39PM +0000, Gladyshev Ilya wrote:
> The current atomic-based page refcount implementation treats zero
> counter as dead and requires a compare-and-swap loop in folio_try_get()
> to prevent incrementing a dead refcount. This CAS loop acts as a
> serialization point and can become a significant bottleneck during
> high-frequency file read operations.
> 
> This patch introduces FOLIO_LOCKED_BIT to distinguish between a
> (temporary) zero refcount and a locked (dead/frozen) state. Because now
> incrementing counter doesn't affect it's locked/unlocked state, it is
> possible to use an optimistic atomic_fetch_add() in
> page_ref_add_unless_zero() that operates independently of the locked bit.
> The locked state is handled after the increment attempt, eliminating the
> need for the CAS loop.
>

Such a fundamental change needs additional validation to show there's no
obvious failures.  Have you run this through a model checker to verify
the only failure condition is the 2^31 overflow condition you describe?

A single benchmark and a short changelog is leaves me very uneasy about
such a change.

~Gregory

