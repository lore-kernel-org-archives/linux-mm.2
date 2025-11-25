Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2385D0EE13
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 18:31:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BDCB6B00B2; Tue, 25 Nov 2025 13:31:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36E9C6B00B4; Tue, 25 Nov 2025 13:31:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 210416B00B6; Tue, 25 Nov 2025 13:31:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C6316B00B2
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:31:27 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8E6FD4FA60
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:31:26 +0000 (UTC)
X-FDA: 84149972172.29.6B5545F
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7B62B18000C
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:31:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mRMyU9oR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764095484; a=rsa-sha256;
	cv=none;
	b=JxHgYVxoy/rN7bgZ+wSnXrlt7hEZgAk07ppchqW1whgdyQMMt2cN1v5mQ2PnOgzA3ySBbg
	lo5JjuNsIcU8aXN7JWcHVr1jhceYxoQjIAQTq35sa69KvR8qbIh631A2Gh32j8hobX2ac8
	F6cJkym0nN3pYQEEQ49FHsvztCxnlV0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mRMyU9oR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764095484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7O4GSlYSAloya2gWAKt06Wd2oP8bRALkgcDobg98SWs=;
	b=jT3NWVUxo0+/K4xXZ61iRm9bRhL/m5nuDqmE/+OR1ugazCEEL5+Gm2xQRyt29w96kHgd59
	3n1z8i9JG3NeZR87uCzkV4u/7nxPRp4TJAabd/iJwXkD5rBmJIn7yTvLMwUtDDcl8ax7wz
	odgrUlankgfPhIVRxWcbYQx/6FBQnrg=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-29555b384acso73208345ad.1
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764095483; x=1764700283; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7O4GSlYSAloya2gWAKt06Wd2oP8bRALkgcDobg98SWs=;
        b=mRMyU9oRKymSfGt6neU7lpuztDYf8Bk9RubLe4FSo1C0H0vYGTC037pRaAOMYM+yvt
         8Aitb0Rg8wTdNljybZM8HUYvSl8BdJC0dByNXqjOAhhmihxawVAzBgqNymg9z8GxsL7Z
         j8tupwFOp1EDcLqQtE0224F2XPJc18A0r1JTmhOgZrOQ5ZNl4tqj01LRa+TNr0AL78LE
         4ebuWUVt2+ZvU32otxbh8C6kUErr1toK8gy0KYZQPGiWkOQesiG51GG3tLCjtCwq9XwN
         awUotRjf71ZzW5B+CdUSPqeav91cffzjIJ4Zc7W2lf+1h8FtJDc7NAVQwUVgXBrOaHwG
         b/Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764095483; x=1764700283;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7O4GSlYSAloya2gWAKt06Wd2oP8bRALkgcDobg98SWs=;
        b=NSSVkqUUqjwDkvXHPOOzVl8ejhOF/lAr0vQQSNoay0zk9zw6jPRPcNpDIOsfG4ahDD
         B1WOzVAsdEtg17NeYuGB6IcPe8WZ3MC67xGKWjk9gQwMBU+ZeKgLCWqxzNtaKFDyZaN4
         eCpEYsvBAuFPxW5zahuB4dm2lgO/MmFZFI+FtMP+FZcvK0RDVebSYfZw3d64Z8rLcFnh
         N4VxwaHWnZNkXyWh7s3XcSBwwsqii2BATNpuzIpVFfRhRY2Nu/v0SC4HKEV1j6xzVw9r
         5LXtzbVzrgGtSuizbz7QGWhtvf311594msPnGG+PgN8bRHQc8ersRZmnGHrsrbGK5ZIo
         waXw==
X-Forwarded-Encrypted: i=1; AJvYcCUs0B2x/kZnA+wt6TiSiQ/I/XgEtypqv0dCTKg90aO2cXI/popC1ssGOrKLSj0DKfzmwt96jfY7zg==@kvack.org
X-Gm-Message-State: AOJu0Yw3xzSjx8QArQ1GXUtDoM16Fr+qSDapeqdvv0EofYmQfpXvsfbA
	OVBdCXv9oqsUhhuysJ7ZdUQcZMDCjk2Ym6DYkgUfTK4GifywHhgfZYUW1h7SWQBjRA==
X-Gm-Gg: ASbGncvvmmIPRla2tpvBHSuZ4ZhvWW7nOmiFLmxxF4a4PArvf2OWL1JJNDfZuJNuNRh
	Nc+S/DTVfMyRBBvfELEqU8Y3txR6wTTOhtSTcqGXUSupSQW442JaL8Jg8+A13KVWgM3BdsFdHnK
	hwwij8d2IccTFndT0zdONZFd2wZrU64UUIN/apE7XUDRk9JeIEBvqXw6qULclEvkhgUxqSj7NDZ
	zG6sTdqHxfHLUL5/fFF8A319opDZ9VprJz3k6kLUgKPnQK02cDqqzsI1BFaHrgmF0RrD/6KHU4l
	X/ZBhXgE86/3fN/RB6dQbVhrj3FE0Q72ws12PNRmaCm37u6zBSFnYtKJPq/c8q9gG4rtCLCF1Em
	O/1qKh6r7mUQXfjZiSHEeUsSjAQHUoxqxmVlpQheLJwYxeQsmQIHahXBVo0XBLQJvmsu8G789Ye
	JduJkbTryONQrbRjBkBGuKXoKXUQPDYaDipF9+GBQ30Ux7lMw=
X-Google-Smtp-Source: AGHT+IH53ckBol+4yeTGTxnoskxcelqMTn+43AKcIW+arxac7wzKqrO4rD1ChIviUV6IKHO85b4pJw==
X-Received: by 2002:a17:902:f691:b0:295:68dd:4ebf with SMTP id d9443c01a7336-29b6c3e3c48mr197452115ad.16.1764095482759;
        Tue, 25 Nov 2025 10:31:22 -0800 (PST)
Received: from google.com (28.29.230.35.bc.googleusercontent.com. [35.230.29.28])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b26fff4sm176035005ad.68.2025.11.25.10.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 10:31:21 -0800 (PST)
Date: Tue, 25 Nov 2025 18:31:17 +0000
From: David Matlack <dmatlack@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	rppt@kernel.org, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
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
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v8 00/18] Live Update Orchestrator
Message-ID: <aSX19cWypvh1mKWM@google.com>
References: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7B62B18000C
X-Stat-Signature: 6rneieawumn5etd4dc5xauyebgn91s74
X-Rspam-User: 
X-HE-Tag: 1764095484-469582
X-HE-Meta: U2FsdGVkX19kBV90OZI9meZc8OLUtiqICHe/NYNqNgj9XeKUuq1SK0IxxvYdKWSnitwqSN1JeHXJkIIlj3cxSHAUTBlaLdPp2HMfPW5/aYhG4oLBjTMPbWqBeQhx5+PLTUakagNlHMskom5nBshQ7xZTORKY4GCsWgOaxvu4BiK9GpPi0kgxwdYdNvqYi37IpRD2TYE0CK61uHzlEMsmu87DxBq/3HiNAFNo5fb1OCgnLGsqHIyW/gEyjRW+LLphstnkCU5KF2tr2gsXxALzAb4238kRVPNldQS8FJ2KlI7Ly8kzJ+cutdDzazwF4pN9gJ0srzZdfYhNq7RGCS+D2k/l7mukkJghJ9UrhksHkyhOz5oSJngBhyMYyE59y9ZeeSZihEDEKj5Jngt6GfFosinzyn74ykfBE+GYo2s9eFNE5/qpeiNR4SvR4aLsKoIFDzP7q65tpEWKlfN6FucLhzsUpIUJqHzT1NrNOinQKeNxZMn1N/Aa47eGF0QT0gw096nHc73nzz4UWLMpaO4OzOGSLwxtkIrLwozZ6fNreLQtA7bqQyyUN7BIZs9QQEjt2X9g62RucYKEgMvtkRQMJfBcjFs/n++L+vOvIgtrS9uKSsl53hloZk2fNV7Wgx/XCrfD/6uo1UbCZyCdB7/WcTZFhHoeqalyKtPU+QZOglPavld53IZiM3ytm9y5hBefsxFYkIkLg8BjgXHwc8ROoIAtr4uIQR5KcnWD4gKbYVApZXMmLQ9zVn0AS4vPsC0lse8yBc0czZpnwwt7vLiEK8GabPMYx3sGr+YcE1nD1WLyYCfihTwP3rDor/dNX+9TLBAxrzal/Mf5KdrKExIxf/A+e5hT8kuYQVrm4d16LEgRQVMrWy0wwf5nG7s6CF0qgQNnASh2mPqt+oopFUCG9svRdQKd+ymcEy7fEwv9HPmiK4N8fi+wYpvohd5R8a27lvZ+qv0Y4FQAG85z6KQ
 guBn+pMa
 OT0hFZopxCEeaNxhfR1hr1vVpbfSyjEreN0MAJ6ZZQUwe2UUjsxIFIlwDZIkBVzrJihsWqkngDQmujWKAMvE8XtmjNg49BDo9Z78B6l2e5tw1ZMRaTsIyCIc6rJ9X1+Ww+Gy7/0JGbXDdhRThAa4yFTB3HP9zHIii4Yc+dWXNsbsvgbLXIBjGoFijAu9f5i12B5SVFumbVCujustML51+qn9LJWOJXpe3gO7L4/g0tVfguXQ9lQcKB+ARYWw+ZLVMA2f8OZMAehdet0BDOAjFR4QBRjizGjeLCmixvHjl7vTwzyoZisfx6ITe0bPaoHgVM65y7BehthDFUSQ6k5f/c2bxmZGgAMuuTJu5ouC/ZAfv8+mRpYjuPA2jcZMl9LvkECR8S7fc3foqg9Z+73sp/akLguWzt4tCfZwp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-25 11:58 AM, Pasha Tatashin wrote:
> 
> Pasha Tatashin (12):
>   liveupdate: luo_core: Live Update Orchestrato,
>   liveupdate: luo_core: integrate with KHO
>   kexec: call liveupdate_reboot() before kexec
>   liveupdate: luo_session: add sessions support
>   liveupdate: luo_core: add user interface
>   liveupdate: luo_file: implement file systems callbacks
>   liveupdate: luo_session: Add ioctls for file preservation
>   docs: add luo documentation
>   MAINTAINERS: add liveupdate entry
>   selftests/liveupdate: Add userspace API selftests
>   selftests/liveupdate: Add simple kexec-based selftest for LUO
>   selftests/liveupdate: Add kexec test for multiple and empty sessions
> 
> Pratyush Yadav (6):
>   mm: shmem: use SHMEM_F_* flags instead of VM_* flags
>   mm: shmem: allow freezing inode mapping
>   mm: shmem: export some functions to internal.h
>   liveupdate: luo_file: add private argument to store runtime state
>   mm: memfd_luo: allow preserving memfd
>   docs: add documentation for memfd preservation via LUO

I ran all the new selftests, including those that require kexec on an
Intel EMR server, and all tests passed.

Tested-by: David Matlack <dmatlack@google.com>

