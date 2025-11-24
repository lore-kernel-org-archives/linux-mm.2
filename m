Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCA1DCFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 15:06:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 065A56B0011; Mon, 24 Nov 2025 10:06:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0168C6B002A; Mon, 24 Nov 2025 10:06:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E472A6B002B; Mon, 24 Nov 2025 10:06:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CE30F6B0011
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:06:57 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8179D13064C
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:06:57 +0000 (UTC)
X-FDA: 84145828074.01.150C0CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id DDA0F140011
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:06:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cL1v2+Ts;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763996815; a=rsa-sha256;
	cv=none;
	b=LWXxgi0FmsFE+rlyOD6oEUZAuitngks/rE5qxdiTUNa+kd7qFMzj6OfBrwR5ad3z9s2kkU
	yhsd1TYF9svVs1C//mdo0kC70xDC3Fj5+xFWDEVPu+dc30ojYpqEGkSBrDnia2DS1m3icW
	XprrvdqmBvC+XTXAZi7Cr6+5ucoiFKc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cL1v2+Ts;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763996815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b1lWIw4AWK0j2zoIr5ruQzK4GMtbC6WJCjQ15d4W05c=;
	b=xHb4HmRe6Z7cyNrav7vdGPHMp4po5AK0BXJeWU63PiIvYl5yoEbVTmz7J9jcvaSe5pEiUN
	dGa4NhLJF6iUg0/aDFZrTrSlKScaPdDkzQOHaVvpWHBhMCclyf2PQqJH91+8SrlgYqU2YX
	H/mgwHGEOkwkUpMzUmgoO9eGNFP5xMQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 00630600C3;
	Mon, 24 Nov 2025 15:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91754C19421;
	Mon, 24 Nov 2025 15:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763996814;
	bh=hjVka/8UJVXnMcGE16R4he/m5Oo5PixYwejWPEsOQ1g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=cL1v2+Tszy/h+jhmobTHqTpgFHjagqVVaCUaz+wK13OfbBpa6MzGIDAh0nshBcutN
	 DrH2mDUz8PxmhHv5LoIvBZFwpOOKPBZRDC5Ky6KqbUTFP9BjytnUFoiHjShjtbeOdH
	 QhNyc2aLiQekqmQUuvjVnMXvaHFqDMo0Fnh05ZtXsbUoS83jn2aufdoRzu+nEo3ct1
	 rqvQAkV60dhx2utBqGybYIBcJnWOhYuTDU29Auvog8yWViX9GLTTDzxOv6yUVvFg36
	 WxW6JlNJKKhQqU+3Q3B46N1SNHKRH611QELwaMl2ZV8uKpDXXP3benVY5Qh1MCN2ud
	 qeRYO+2kGet2Q==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  pratyush@kernel.org,
  jasonmiu@google.com,  graf@amazon.com,  dmatlack@google.com,
  rientjes@google.com,  corbet@lwn.net,  rdunlap@infradead.org,
  ilpo.jarvinen@linux.intel.com,  kanie@linux.alibaba.com,
  ojeda@kernel.org,  aliceryhl@google.com,  masahiroy@kernel.org,
  akpm@linux-foundation.org,  tj@kernel.org,  yoann.congal@smile.fr,
  mmaurer@google.com,  roman.gushchin@linux.dev,  chenridong@huawei.com,
  axboe@kernel.dk,  mark.rutland@arm.com,  jannh@google.com,
  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
  dan.j.williams@intel.com,  david@redhat.com,  joel.granados@kernel.org,
  rostedt@goodmis.org,  anna.schumaker@oracle.com,  song@kernel.org,
  linux@weissschuh.net,  linux-kernel@vger.kernel.org,
  linux-doc@vger.kernel.org,  linux-mm@kvack.org,
  gregkh@linuxfoundation.org,  tglx@linutronix.de,  mingo@redhat.com,
  bp@alien8.de,  dave.hansen@linux.intel.com,  x86@kernel.org,
  hpa@zytor.com,  rafael@kernel.org,  dakr@kernel.org,
  bartosz.golaszewski@linaro.org,  cw00.choi@samsung.com,
  myungjoo.ham@samsung.com,  yesanishhere@gmail.com,
  Jonathan.Cameron@huawei.com,  quic_zijuhu@quicinc.com,
  aleksander.lobakin@intel.com,  ira.weiny@intel.com,
  andriy.shevchenko@linux.intel.com,  leon@kernel.org,  lukas@wunner.de,
  bhelgaas@google.com,  wagi@kernel.org,  djeffery@redhat.com,
  stuart.w.hayes@gmail.com,  lennart@poettering.net,  brauner@kernel.org,
  linux-api@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  saeedm@nvidia.com,  ajayachandra@nvidia.com,  jgg@nvidia.com,
  parav@nvidia.com,  leonro@nvidia.com,  witu@nvidia.com,
  hughd@google.com,  skhawaja@google.com,  chrisl@kernel.org
Subject: Re: [PATCH v6 12/20] mm: shmem: allow freezing inode mapping
In-Reply-To: <aRr0CQsV16usRW1J@kernel.org> (Mike Rapoport's message of "Mon,
	17 Nov 2025 12:08:09 +0200")
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
	<20251115233409.768044-13-pasha.tatashin@soleen.com>
	<aRr0CQsV16usRW1J@kernel.org>
Date: Mon, 24 Nov 2025 16:06:44 +0100
Message-ID: <mafs0a50bzczf.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DDA0F140011
X-Stat-Signature: hdtuw9q8u9gq4o3x1nhh4xrtdeursr3x
X-Rspam-User: 
X-HE-Tag: 1763996815-597645
X-HE-Meta: U2FsdGVkX1+yIwwvtkh4sJT+ThqaBgNhbevJ2lW+wllpzbZMSPv2MX+/C6unwC4mvGTNY07wArXft2+U+QYhTRYf1UiYlcdZ0/FvtLnIQ9daJ9lOUbnUGsSA24M4Eq3mW2Ie2iylW0f+j1Ez1gUPrm5G0/LRaJi8ERfueGxqvplZNe8FNRIBZo/Npsmg+9wfQwk35Qq7qyjU+20bU8J+AchaKZWeYT8mtLnISrIZuLeJBAFV+JdeS5TlbBZ2y1u3EiewH3c5MCbAZk666y2vyi/ypsu9GcOb5C10WkRsunRlV9yKvFS63E/iH2pI0LdZjKGw/SgYhykjmfh9HjUvwz2PzKjixFLs3gMDcGcxAxqfTsAaFCjBijllAZaLPDT8ZLa7ThNXDxEBEwK4+LodNVKXEnqDqXzS62pPvdJXTa+Oa0YGNUA9n25QSv8Ah2mGgNSrD6jawxJ1RXQxjoWmYJJsI3UAf5fAe5RElm6BAHuHzDGmGwceMMsSwDYS7Qm7dYqpX5itOYMSweNSvpHhTI0C4xl/hoVN1jcPhanSTgAKiSxxq2C+HNTuvzcdk9UibThuiW/GVjvkvQNfAbNLlw5cSCk5KlwKVSfjxn9rI9Gg3OnBNp6s5lRW2OPH9uQGrsIfkY8YKhypBKRbeiCokqZROMwNbdva5wtU7hRaHFdzNbHhQvRhBa6MU67JjvNXg6XxLcJwGkEX9yrVzePuoGNm65QU7At5pCYRo1jVxTjj6vC1xXF2TnBqwu4dqx8RmsqM9ROTuh2x5VvqqBV+u/PMOah8eS9VhGSijxgSsjKgXVjynGX0OgivWXnhG91107KLjduhZ5PxqHvS0LwfTlK1mw10wwDvh8GZwmaR1wabxvA4VBJDV953fIKT12HIOGfBSAfiG/We2eodKJNmG9AX+CBai5DTlEmb2PVwdJmCnG7U0ZYUf/XZvXMzs1c9x9hwbSS5pvLDToaEX/x
 vR8yWEJg
 YuFnwTH8zTO0GQTye/dT0AxyNQ90S7vuwIMrCC6SwmV2X62fUbtDuaXoJEHZlyUxIR5ZwfxIsF5p3xNFdosV1SbkZ1rJcPkQjXWE+/14vnrtuaPnfrnutcJosltaRUnkLGLg/x6W7P5e2HListJKVL23MoChcVRpNIUyPO7qrXSZ+aEfJUk3GoF8jmTw5Syo1fS1Kv4tzkHFeTlVxmKRnAsJZRh7+ltuwDNQNdW/dgbxpzvC0ZKVOugwlxHYY9fmBEUIdtd4wj48+ga9cyKebFpSya/tWemeFLLWQWmsRqICaZ1E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17 2025, Mike Rapoport wrote:

> On Sat, Nov 15, 2025 at 06:33:58PM -0500, Pasha Tatashin wrote:
>> From: Pratyush Yadav <ptyadav@amazon.de>
>> 
>> To prepare a shmem inode for live update via the Live Update
>> Orchestrator (LUO), its index -> folio mappings must be serialized. Once
>> the mappings are serialized, they cannot change since it would cause the
>> serialized data to become inconsistent. This can be done by pinning the
>> folios to avoid migration, and by making sure no folios can be added to
>> or removed from the inode.
>> 
>> While mechanisms to pin folios already exist, the only way to stop
>> folios being added or removed are the grow and shrink file seals. But
>> file seals come with their own semantics, one of which is that they
>> can't be removed. This doesn't work with liveupdate since it can be
>> cancelled or error out, which would need the seals to be removed and the
>> file's normal functionality to be restored.
>> 
>> Introduce SHMEM_F_MAPPING_FROZEN to indicate this instead. It is
>> internal to shmem and is not directly exposed to userspace. It functions
>> similar to F_SEAL_GROW | F_SEAL_SHRINK, but additionally disallows hole
>> punching, and can be removed.
>> 
>> Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
>> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>> ---
[...]
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 1d5036dec08a..05c3db840257 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -1292,7 +1292,8 @@ static int shmem_setattr(struct mnt_idmap *idmap,
>>  		loff_t newsize = attr->ia_size;
>>  
>>  		/* protected by i_rwsem */
>> -		if ((newsize < oldsize && (info->seals & F_SEAL_SHRINK)) ||
>> +		if ((info->flags & SHMEM_F_MAPPING_FROZEN) ||
>
> A corner case: if newsize == oldsize this will be a false positive

Good catch. Though I wonder why anyone would do a truncate with the same
size.

>
>> +		    (newsize < oldsize && (info->seals & F_SEAL_SHRINK)) ||
>>  		    (newsize > oldsize && (info->seals & F_SEAL_GROW)))
>>  			return -EPERM;
>>  
[...]

-- 
Regards,
Pratyush Yadav

