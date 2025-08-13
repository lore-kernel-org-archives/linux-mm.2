Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5CC8CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 12:43:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84A14900069; Wed, 13 Aug 2025 08:43:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FA25900044; Wed, 13 Aug 2025 08:43:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C26A900069; Wed, 13 Aug 2025 08:43:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5A578900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:43:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 22466C035F
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 12:43:00 +0000 (UTC)
X-FDA: 83771698920.11.9D9B934
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 84768180006
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 12:42:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=abcQxx+2;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755088978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dCF1ll+qwi8DwkSC++8jGcwtkVYst8WfAJdQUnzbEu0=;
	b=1/8iHexkpplayVSi6uJrGEJEL6vlTmIAowB5APwRvrGuQ6ttRdk0DEH2BdKs5hfBUxP8dh
	ItxFcfpsXudP9t/oVGzInueVizmm4M1D9tH4B/vKHznAczt+o6/RJUhXabjbgC2wIpK8qq
	nwZt0R+/t2rlOEZHbuNYXqt6BFl9ZzA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755088978; a=rsa-sha256;
	cv=none;
	b=ORlBEjnQJYHaoP5GPRrLbR9vDxZQUfIiE7MBLTzjwZcEyyoszoJZhsBIwdCOTn/2tgJmXy
	CjNPcFfyljgVkWNFtvRXIwsVBrJlN/tYEdo80oUgnSTmyneAfnipo6RMImnj8vfIfvOgWH
	l+NCrjs++HDh51O2L3E/iUMTfobeWAw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=abcQxx+2;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 96809601E1;
	Wed, 13 Aug 2025 12:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B89C4CEEB;
	Wed, 13 Aug 2025 12:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755088977;
	bh=LDj2QuAauZIfATyz/j1HGW1zmOPF+xKh5rLzTFxXMTw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=abcQxx+2rtJfHkVvpjEviY5OyOiZUaFIpnFBGZHCKkIxAIF1d61SW9piap09pmUm0
	 186Dc2YxQSCoIRn+xcQHv+CoEnq/0krk+ci4a+VQSRrAkNeFrCwMdyTumguGilaKvk
	 weRcPWRNVzDxYkl2M1qZ3jNA6bHY1yHD5w22GQL78BS5PP3UlJJbYaxmu6dH3dFFie
	 Zhrn738C6i3hm6OUaurtWBNHHy0wlzf9wInTPabX2fwQblkyBUq0bf2nEzhdcJGPmu
	 O9NpQhVkb76Vjp8vRuKGBejjHufDaD5xh2BiRDsXZ/pwilC6xh/BNfAjYrYxCmJXKY
	 tSNtMwX7h5QJw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Vipin Sharma <vipinsh@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  pratyush@kernel.org,
  jasonmiu@google.com,  graf@amazon.com,  changyuanl@google.com,
  rppt@kernel.org,  dmatlack@google.com,  rientjes@google.com,
  corbet@lwn.net,  rdunlap@infradead.org,  ilpo.jarvinen@linux.intel.com,
  kanie@linux.alibaba.com,  ojeda@kernel.org,  aliceryhl@google.com,
  masahiroy@kernel.org,  akpm@linux-foundation.org,  tj@kernel.org,
  yoann.congal@smile.fr,  mmaurer@google.com,  roman.gushchin@linux.dev,
  chenridong@huawei.com,  axboe@kernel.dk,  mark.rutland@arm.com,
  jannh@google.com,  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
  dan.j.williams@intel.com,  david@redhat.com,  joel.granados@kernel.org,
  rostedt@goodmis.org,  anna.schumaker@oracle.com,  song@kernel.org,
  zhangguopeng@kylinos.cn,  linux@weissschuh.net,
  linux-kernel@vger.kernel.org,  linux-doc@vger.kernel.org,
  linux-mm@kvack.org,  gregkh@linuxfoundation.org,  tglx@linutronix.de,
  mingo@redhat.com,  bp@alien8.de,  dave.hansen@linux.intel.com,
  x86@kernel.org,  hpa@zytor.com,  rafael@kernel.org,  dakr@kernel.org,
  bartosz.golaszewski@linaro.org,  cw00.choi@samsung.com,
  myungjoo.ham@samsung.com,  yesanishhere@gmail.com,
  Jonathan.Cameron@huawei.com,  quic_zijuhu@quicinc.com,
  aleksander.lobakin@intel.com,  ira.weiny@intel.com,
  andriy.shevchenko@linux.intel.com,  leon@kernel.org,  lukas@wunner.de,
  bhelgaas@google.com,  wagi@kernel.org,  djeffery@redhat.com,
  stuart.w.hayes@gmail.com,  lennart@poettering.net,  brauner@kernel.org,
  linux-api@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  saeedm@nvidia.com,  ajayachandra@nvidia.com,  jgg@nvidia.com,
  parav@nvidia.com,  leonro@nvidia.com,  witu@nvidia.com
Subject: Re: [PATCH v3 26/30] mm: shmem: use SHMEM_F_* flags instead of VM_*
 flags
In-Reply-To: <20250811231107.GA2328988.vipinsh@google.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
	<20250807014442.3829950-27-pasha.tatashin@soleen.com>
	<20250811231107.GA2328988.vipinsh@google.com>
Date: Wed, 13 Aug 2025 14:42:47 +0200
Message-ID: <mafs0sehvwfy0.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 84768180006
X-Stat-Signature: jjdpmc4a4iw6f3ken8iig6xbupayxue5
X-HE-Tag: 1755088978-380344
X-HE-Meta: U2FsdGVkX1+ftWN5DYa1dtE87DuWyuUO1wdTv79R8DOf/QPf2quq15d+wWdNVD+VLzmW81w+6QJH7gkBAnGLxvY1aSiTt8ew87I+W/6TjpIbwNI2TgkYRan+cYlzi8Izrqksv4WWDIWtck5SoN7Mq8bSF+4kS6MoxAE23xpcLY8SY5Zr/ncPWPCgTNcgD4i5Rs1pVN8UNi86Pk7+0rynyqeaGQZtFEqfHf4llK+Rls0MX/0G9XDrViSTeGRVKN6uTNu23OwXIVh5iN30zb/Qh+dO4QdcQcRkfw9H5UPYHNkq71AK4+kj6HLhkRZvhOaF9MYcKjpqShcwjyijNFw8BZ2JUcrlMCuuCH2tM9F9hnmONkak0KD9cYNbVB846Y0FZC1Lb4u0IMNZhj3PSuF1jxA2n+XoJq9bpx1qKccEM/3KfoWSEltrrr+XtywIjJOitPQ26niSlPuBizoJNSm/TCkfDGMQKj4SRuWFMqPKO0/CH3SxtSITzGm1k3+IjuPW8IKIzpE+VGvW/zLoZJtLtZdE7/qLlrCSJhdIxRKTk+IyvTgvI4W5s2RoQldpyE9BbCQQT9imKKHKXCo48iVuhjNAybAMzMUaxy3gAe5J4VjQRbOizUds5qTFY4eny7J/FV/x1fytWEHbUd9yYAeUynkGTlOeOFk2kGHhbrcwoHM/66xLaJkk9LvdlVtFqTXiSwV4lOKDLEOlsL/7+nbvok9/H4/o21o4jXPr3eO6/jfoRJEBRhgPD8C+3gtvg47/UVfTBfFr4RS6D17KM922CAGCYEk4o1groNszqhBloFhnO8gD/xo2207TSeT3bFjJkZjjXHdnwqpAfP77hIh4CifhRAwbr+SAMKsdyHXkS3ufu2WUs2wgzFHBOL5QjG39BUROfWgVR4xoYTUdc9yAp7dEQSwSrlpGGrhysUqKPNTy2JyxVYSnjOKsYDAETICZr7vYhITYanEfLgHxhfK
 nwYgni3V
 rE4ZR+ROAytvV4T+BqDSSLWQAqZjUOFaK/aa3YZ6CMmEf8gbBBw/i5SddK4jKFLYzCxijItbclX84Z7EGezreo3N18sMuz/XZxxR01ACJyE20XrbFfoyp3n/5xC5B9oTH5cDs1JwM5d0g+QnF5g4GCRAU9E/riiDJZNbdDfBYPjfo6wQLz6S5WglYEhKt2QIS1i1Xxh5oqRAgRVWXOUKKLlj/2JH5yc+JgpyQ79UCOQjKNvgwLplW6UITKYeGvL29Gvf1oZLZe8l/cnNdX21b3Oit8BeZRh27s6N4CbsxNzTtw1RPrJUjwtUj0Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11 2025, Vipin Sharma wrote:

> On 2025-08-07 01:44:32, Pasha Tatashin wrote:
>> From: Pratyush Yadav <ptyadav@amazon.de>
>> @@ -3123,7 +3123,9 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
>>  	spin_lock_init(&info->lock);
>>  	atomic_set(&info->stop_eviction, 0);
>>  	info->seals = F_SEAL_SEAL;
>> -	info->flags = flags & VM_NORESERVE;
>> +	info->flags = 0;
>
> This is not needed as the 'info' is being set to 0 just above
> spin_lock_init.
>
>> +	if (flags & VM_NORESERVE)
>> +		info->flags |= SHMEM_F_NORESERVE;
>
> As info->flags will be 0, this can be just direct assignment '='.

I think it is a bit more readable this way.

Anyway, I don't have a strong opinion, so if you insist, I'll change
this.

>
>>  	info->i_crtime = inode_get_mtime(inode);
>>  	info->fsflags = (dir == NULL) ? 0 :
>>  		SHMEM_I(dir)->fsflags & SHMEM_FL_INHERITED;
>> @@ -5862,8 +5864,10 @@ static inline struct inode *shmem_get_inode(struct mnt_idmap *idmap,
>>  /* common code */
>>  
>>  static struct file *__shmem_file_setup(struct vfsmount *mnt, const char *name,
>> -			loff_t size, unsigned long flags, unsigned int i_flags)
>> +				       loff_t size, unsigned long vm_flags,
>> +				       unsigned int i_flags)
>
> Nit: Might be just my editor, but this alignment seems off.

Looks fine for me:
https://gist.github.com/prati0100/a06229ca99cac5aae795fb962bb24ac5

Checkpatch also doesn't complain. Can you double-check? And if it still
looks off, can you describe what's wrong?

>
>>  {
>> +	unsigned long flags = (vm_flags & VM_NORESERVE) ? SHMEM_F_NORESERVE : 0;
>>  	struct inode *inode;
>>  	struct file *res;
>>  
>> @@ -5880,7 +5884,7 @@ static struct file *__shmem_file_setup(struct vfsmount *mnt, const char *name,
>>  		return ERR_PTR(-ENOMEM);
>>  
>>  	inode = shmem_get_inode(&nop_mnt_idmap, mnt->mnt_sb, NULL,
>> -				S_IFREG | S_IRWXUGO, 0, flags);
>> +				S_IFREG | S_IRWXUGO, 0, vm_flags);
>>  	if (IS_ERR(inode)) {
>>  		shmem_unacct_size(flags, size);
>>  		return ERR_CAST(inode);
>> -- 
>> 2.50.1.565.gc32cd1483b-goog
>> 

-- 
Regards,
Pratyush Yadav

