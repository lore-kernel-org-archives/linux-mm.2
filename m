Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92392CA0EC4
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 23:11:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0A7B8E00A5; Mon, 11 Aug 2025 19:11:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBAA48E0045; Mon, 11 Aug 2025 19:11:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA9A28E00A5; Mon, 11 Aug 2025 19:11:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3A628E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 19:11:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5180D114D50
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 23:11:16 +0000 (UTC)
X-FDA: 83766024552.25.42CC822
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id 768C2A000B
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 23:11:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZT1qcHPM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=vipinsh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754953874; a=rsa-sha256;
	cv=none;
	b=MQ2XgshECqluss2IduUapq/r3ODIP0JcRGY6GSOu1daEcDfmfkPM49/DsYsdVmXF9Qe8yY
	s4bD2Hh1sWKwYEYtbxCIT1kx9NGuiz7AOTRJDE3k06kS4fEhwAb3YOQGdM1AqApVgdztX0
	5rmx61Zb7RWbZlmC0TZeNvaL3kOVooo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZT1qcHPM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=vipinsh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754953874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t1oV7yVKsQ5TCnNZCaQ3AZrRbIoYDq2nQJuy1DeTjIQ=;
	b=ErBlgzgwMo6nR6hktXl9RkXeWOnKZtIk6GU3QmCX6L90xwjQzplD2n2mNBXPnkH0YCocdR
	fXooDcYcdtc95RRHTQezEPJ+o69y9RIzyXyLXzxglmUzx5ytcbH5tSWmWnJmoMr/+09UQO
	hQTCa4IB8O7rya7F+OBbOtrutqzETt8=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-242d1e9c6b4so89715ad.0
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 16:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754953873; x=1755558673; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=t1oV7yVKsQ5TCnNZCaQ3AZrRbIoYDq2nQJuy1DeTjIQ=;
        b=ZT1qcHPM0cEE9e/a1U9QTuR/f4A6RLhaG00elt9V71UQ2YzdS2r3cROgIlLViNVPNM
         uTvAB2zn+lYf+6lc/61p+V74IEzriDWHNTcbfk3RUykuy9dxWwz00IonMr2/loJUiR5L
         2dQ3kKyXxTXMjPn5K7uYxjrTL1BEWQZAgXDDgBureKGf29Rkwy2xcaGe5eRnTiHtZKFV
         s1BrQMkmDeFV6N0SWlSqPEkS3GQ3Pz1JwQLZG6czsjazlh1zIgQnoLtW14+97uNGUqPA
         COPUY4RIakQxtQzgOR/qx/O503UPnkfTfNES41H+Lg53og5asvSND4x4HwtCtzMOaik3
         Nmig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754953873; x=1755558673;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t1oV7yVKsQ5TCnNZCaQ3AZrRbIoYDq2nQJuy1DeTjIQ=;
        b=JMbRvj/+iVp08XxEtqkF53HDpKlZLgOQ3K7dYoQ11Nboq3hJY0Yohj1VLMcBoaqkv6
         sX5E/3Ml6cDIY12gb129JnlOAwImdPrAz8RDr+BKRNDJMW3lgzQ8G1UKQfEMcAUDsuqz
         KNlB6k0a+j4rBXM7MENC/5uxAY9Uvdy6M62nteegAERo2QO9t0ntVziy8xlaZjUUUa1G
         zyAzH4LcclZk/NAytT2v6lfzpDgUXXDp6rMb/N3Q9Crmj21zBvTjOgsRUwOSqXlCeBMe
         eihfSKxRxZjg2PUtto1ZxukEDWpwxO4E/WrOHr4CD7Dwkk7hX0InC0Qqkk07BA1iKGA9
         Sz6w==
X-Forwarded-Encrypted: i=1; AJvYcCXGOh2o/17rWGtSzYt8ZXIGEMIUqpVuIC724iZHGR/erSVD54vJ+zB94eAMFyTZNU/YUV1T3NkDkg==@kvack.org
X-Gm-Message-State: AOJu0YwthT6Q+YwO7jM6Yw88tRachBlkkCxInSYfefwOX16z0jP8rf38
	jkvQig1c8mNKRs00Chm2X7dYwxEk9DOD9hSUMhOhlgz7TxwYhUopWvJ1PshSLMijnw==
X-Gm-Gg: ASbGncusJ4doIMBVUTtObX/J37hymEkd8pYglixX9XeuDoIGlxalqjGyXJylXwR6oTZ
	8hWcRi7/JLcBfkLBJoWO2Vwbs4tJTTEJuswFDT8B0CXP+bXtU4z2WNYTc62dG9WSqKcox88W7Y/
	uRu9m2Tu3KZMrktwBwbKXWJaRcPbCwfBczGIyUuAR2wGLsmrpOt+L3CKqknTA7EhWekoREncQiQ
	tjJJcpDua1zKgzcnCQ4uysrD1c3VTa+Q27Ak6ll6dY3kfYV5ZSoB7mC4Xq0YRMrmHw0EVhROlNa
	u9DdwlAyDNCvRK4YSRWSQvWcn1wGr+ZAFDNa0q1KhTxoXVTz9w5G/QRnDY3Uk5I27ct09kD2+Y0
	P9PL7d7Xg7sRiEGHrAzT2sO9ivc5KkFv3ruvuFcACuK50d6+Mj+aHEAlMO56s317Ka1+j3Q==
X-Google-Smtp-Source: AGHT+IFzyKR/w1E27eWm6IovhDIP1SONsBPcExVJWFEliFhx+rfqf71Fi48caAfu36gGEzgxJL2HPA==
X-Received: by 2002:a17:903:41c5:b0:240:520b:3cbc with SMTP id d9443c01a7336-242fd3660c2mr1826635ad.14.1754953872909;
        Mon, 11 Aug 2025 16:11:12 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bccead450sm27859139b3a.54.2025.08.11.16.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 16:11:12 -0700 (PDT)
Date: Mon, 11 Aug 2025 16:11:07 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com,
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com,
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org,
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr,
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com,
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com,
	vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com
Subject: Re: [PATCH v3 26/30] mm: shmem: use SHMEM_F_* flags instead of VM_*
 flags
Message-ID: <20250811231107.GA2328988.vipinsh@google.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-27-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807014442.3829950-27-pasha.tatashin@soleen.com>
X-Stat-Signature: xjxqmujqzma7r8r9oyj4xzfmypf35jzf
X-Rspam-User: 
X-Rspamd-Queue-Id: 768C2A000B
X-Rspamd-Server: rspam02
X-HE-Tag: 1754953874-434516
X-HE-Meta: U2FsdGVkX1/9K1lIQhCfHGt9QWqBqxiNYdvBOeWo2Pss1Pc9dYSVTIVBHmNorH2YoXOYe9CX/oY6WuN19Ychc5mEneacFgme6Rk+r9fLyN9H09jKQQPJztVsx+UuA4tu6e+alGC0nWiGK3oGmIAMor18vlbljlOp0/4KwZUsKIkXqTpYaPyuE2oSd468CrUJcbOvwy8epXIfwcUgGVfRo9Vm18JPuQzII8/YCqgNGOllw8P/CISRtJfUK8iGf+bRy9J63aPNB+eHdJQ9awLnL9JDZSXe9fafmXYcP2/u1An0VTV2c/Msimls4ezMd3WESqEFewHlkR370PMKwHuyp6rYYRa/n5uMJG71WVDrjb/GoVFWpmH6wUdtuBGLZz1sjq/xjkIUkpdfhI+AjKNm8FqXnLi9DYl4u/QLb5swp8xNc30hVO4mROrS4QXSR7tMFxrGxPM7Cl3Esg7eXT2Lhrqx3bHAr0Er9qkPpuMynkj45EaiQrIW7muTar0KFJFly2IwrncFranY1ZfBiKFiZcaEfLzpqYIRnfcTYeBCI3cphP+odrnvqICVAYWhQ4K4k49vCV+7FPexND6AqdpHDEY/lIAKmgIpY96cJLrDdASWc9dKutTZq5PU/rT/rl87/YiI0j1wk9Uy3n5b4dk322WczpaE82PnxkZ3yD0pouNJLUl0hnFLT6vg8LHNEaw0kW3shqMNBLowf16C7eCjHLV83uPQ+NO0NsIarzQcdW+kENz5mDON4UOAXJ5i6j6ZeX+0IhonpyLZ88c9QkCOKcPYReDdZwjZ8D5m8n3nReJUdoFct80eyEFKGjfbyBt6zvHQFGRilUHwLkOVwCEWwJ+6R0dDEkBNQf9xUguu0iOvA5p96XShl/ntZ5Dbcd3D7quclkw9i+P0wbeMh11aFjHeSorAYRfd7e9zv/P3AHiy/Fx3pIDk6jsoeTEzVii06JW8jkzgzVQJ+/xoU49
 Cj97TfWY
 osC4YptCf0ZF90Ae2a78aCGQEqVTVPAuLJepfPzM8W8NTwN2Y+hLu1qXpWJ2uwlZ5KAgcIQyRPzsHzaKhnDCQN6txTUa3yg/Ann7z0YHQM1WJMpPPLlpY8NM8O96hLLy/bRCBhkd4jnmmH090Cfh2CufjwbyZOEMefPQ7WSvRVZRyLrpDvdmucvnqjQEtudqburUO8ta0ktPtWh83qoxbyOfBfpd77Zt/qcj8VfAvtMC65QDxMKNlJm4mt43zJWY8HGrUKDhPdIG0oBkiI9nmh7xj7WD51HVX0XchHcdCBqLDPLATAjSjOBQHzPDdGQUqeTVP7Kyp80fV/xatNudNBkrAJpH3aRNzIUdItyTaMQbJQ7Fjsf6jm4UAvHAl8Udquwsh0bX3QEEb+EXS9OZgNupmtYiu/q/jGVH0T6cRQ6Qr4uMULKAU++w3/tq511PIEtNoxrEpQq2Q77TUMKkjZp0eyXJLfaILyPLN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-08-07 01:44:32, Pasha Tatashin wrote:
> From: Pratyush Yadav <ptyadav@amazon.de>
> @@ -3123,7 +3123,9 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
>  	spin_lock_init(&info->lock);
>  	atomic_set(&info->stop_eviction, 0);
>  	info->seals = F_SEAL_SEAL;
> -	info->flags = flags & VM_NORESERVE;
> +	info->flags = 0;

This is not needed as the 'info' is being set to 0 just above
spin_lock_init.

> +	if (flags & VM_NORESERVE)
> +		info->flags |= SHMEM_F_NORESERVE;

As info->flags will be 0, this can be just direct assignment '='.

>  	info->i_crtime = inode_get_mtime(inode);
>  	info->fsflags = (dir == NULL) ? 0 :
>  		SHMEM_I(dir)->fsflags & SHMEM_FL_INHERITED;
> @@ -5862,8 +5864,10 @@ static inline struct inode *shmem_get_inode(struct mnt_idmap *idmap,
>  /* common code */
>  
>  static struct file *__shmem_file_setup(struct vfsmount *mnt, const char *name,
> -			loff_t size, unsigned long flags, unsigned int i_flags)
> +				       loff_t size, unsigned long vm_flags,
> +				       unsigned int i_flags)

Nit: Might be just my editor, but this alignment seems off.

>  {
> +	unsigned long flags = (vm_flags & VM_NORESERVE) ? SHMEM_F_NORESERVE : 0;
>  	struct inode *inode;
>  	struct file *res;
>  
> @@ -5880,7 +5884,7 @@ static struct file *__shmem_file_setup(struct vfsmount *mnt, const char *name,
>  		return ERR_PTR(-ENOMEM);
>  
>  	inode = shmem_get_inode(&nop_mnt_idmap, mnt->mnt_sb, NULL,
> -				S_IFREG | S_IRWXUGO, 0, flags);
> +				S_IFREG | S_IRWXUGO, 0, vm_flags);
>  	if (IS_ERR(inode)) {
>  		shmem_unacct_size(flags, size);
>  		return ERR_CAST(inode);
> -- 
> 2.50.1.565.gc32cd1483b-goog
> 

