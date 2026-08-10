Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD12FC5AE49
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 13:08:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96A586B007B; Mon, 10 Aug 2026 09:08:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91A876B008C; Mon, 10 Aug 2026 09:08:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 831496B0092; Mon, 10 Aug 2026 09:08:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4DC806B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:08:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C59964019D
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 13:08:54 +0000 (UTC)
X-FDA: 85085389788.24.5F75FD0
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2146220014
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 13:08:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VZOxkspF;
	spf=pass (imf03.hostedemail.com: domain of 3Y815agkKCEAvctwpucjwiqqing.eqonkpwz-oomxcem.qti@flex--tarunsahu.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=3Y815agkKCEAvctwpucjwiqqing.eqonkpwz-oomxcem.qti@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786367333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oMcbMXyReyKJIZVlqYCZytsphgwWMjfKxVFVMEfDD0k=;
	b=QsPN5ZraLiYjtF3XA/zpTsz/J6/g5De26G870IeUGwzLx+vcSIEBEvbBM4DELDufuVt6qx
	++Jk/Ny7COTEbrAY9DMsArOR1TUD4j18xpYcBJzdAhSQAa4mDts8RPPwiW+uXx/LiQFzFO
	lLa7poR6BOoMQdp3j3PEHMwtivmmDcE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VZOxkspF;
	spf=pass (imf03.hostedemail.com: domain of 3Y815agkKCEAvctwpucjwiqqing.eqonkpwz-oomxcem.qti@flex--tarunsahu.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=3Y815agkKCEAvctwpucjwiqqing.eqonkpwz-oomxcem.qti@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786367333;
	b=NgV7+NSIh6/n7YGjDWeo8NqkKOqWqmMK+qr+MRSczBTITftQ7dl9uem9YLbQPLMlW41IBo
	DJWSRN8KAiLflFs+jK5LyKRMt9+MBm7Me0wXgK4dKrp0bjFUq9ogQlcIQm8DL6iugiQUIt
	kiD0mFa5yFe/3tPUXjlsyxhkyAPniQ8=
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-69cd6606b19so1548445a12.1
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 06:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786367331; x=1786972131; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oMcbMXyReyKJIZVlqYCZytsphgwWMjfKxVFVMEfDD0k=;
        b=VZOxkspFa6OGopYBF9dozMo7+8A69wkT2V0GQuVDcJfxfHI0F/VJJPD4rbdEeMboeK
         wXTg4c9cdm9wFUAbggRXsZwvtXM/lfKp+A1WkiBOTeY63VqCDFpkSc0hUmcSvlWREkl5
         CmUlNSF4y+YC7S1Zv/SIfjCW9grTjrIn+bcGobO6zjEQuBOI8Cy0QPoVWj0cExPCxT2O
         V2wRVpe31bjvoRocp3BSEdjqN102iHF7qi5dEIy6eD8AimUd0yLRpOlfwUAZUtmghTAy
         yQ6kylLoq4uEOFWJWPoQnLQeSh+j3NjLkteFpyrDexwBPQk7Tuk1cLy2qwAoTcnuf8RI
         7GEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786367331; x=1786972131;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oMcbMXyReyKJIZVlqYCZytsphgwWMjfKxVFVMEfDD0k=;
        b=ddW9awWenFKFetuSFGF3XBZUMdoJKfVoSgAMpbuO7D3y2FzW+QLqRKzQf+QnZtvid/
         oLVi0xYtgce6vjgnnlubxdddqItlwvkihyA536s8Bj4VvKY/JhrTasiomaVf5OmgMgm4
         zJwHrEkqG7o7uvxF6Ap10lOf6S3ra9f/HxhJ9jjzWtBszrzyfRz/i4da98r8RXzuuSj7
         Xa9ONIHAiO/zhYEW4ju/II7c7hSqiD/Ip1EpW9RXRZkjgqd0QHXWTBE+ljaGA9ZSrZ3O
         HQ1OXbBi3yS1+bWua8Tx9qteoEzslJgMawDNcBw9F8k/OkfR0aann055af602Ed67gWE
         WLvw==
X-Forwarded-Encrypted: i=1; AHgh+RqjHedmJt4DIPuSR7Wp3WcawBS4txAwq0YPIQ/ljeJgH2KjzbCwBa5Kwj4a1s+MymRKwXQI5tsQDg==@kvack.org
X-Gm-Message-State: AOJu0Yz/GoNnUWgrPSOytFA0e9fLJwiRWB9BHtauigyl65sJV2goERur
	AJjthiL/fcW0YOcdNIyYQaHvzNgjxnLPxV/vBNQm/XdK/7+JE5k2GPlBouP1+y6ZE51hSq4yn4S
	jUSoRq5Zlo9tGUFydng==
X-Received: from edbek14.prod.google.com ([2002:a05:6402:370e:b0:69f:da3d:dc37])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:5048:b0:69a:a4cb:2882 with SMTP id 4fb4d7f45d1cf-6a355db411emr1046692a12.9.1786367331218;
 Mon, 10 Aug 2026 06:08:51 -0700 (PDT)
Date: Mon, 10 Aug 2026 13:08:50 +0000
In-Reply-To: <CAEvNRgHW0P78eL0ip799XF+2geKwz7MQrjSFTgvCdUAuh9oykg@mail.gmail.com>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-8-tarunsahu@google.com> <CAEvNRgHW0P78eL0ip799XF+2geKwz7MQrjSFTgvCdUAuh9oykg@mail.gmail.com>
Message-ID: <9huz7bly86n1.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 07/11] KVM: guest_memfd: Add support for freezing mappings
From: tarunsahu@google.com
To: Ackerley Tng <ackerleytng@google.com>, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2146220014
X-Stat-Signature: kmqytn71etyfmo3mcdofsuj8b31umj4j
X-HE-Tag: 1786367332-611413
X-HE-Meta: U2FsdGVkX18IVGUYG4zOfsA//ucf+2Kjv+cVG++HiHpuBF8VDs8rQqIDTF/rJkiDBqI/91YFtlb2E1KBkdjDSfQBphevUKU53BmDgKs6O4NJVKs6GXEaj2+exEEFKfVqZeMcgATtIWsXkSIhDFR4WU3Vw2kJkvHV5CYrG29m4M0gVGatWjjiLmgkkC/lt/P4BrPAHbKATwaDclSDj9Wjhe0c6pjN6WKYdu/XPbnpt2fT3/NE9g8OO3uBntZq0QvmHODDoyqqpeZ3ODyRrr8YZjorWUJuYP287Q+7Od0CBTiaQFWWSLjtBQAfb5Ou9Aw9sOwbeIyvWWhwBwBO+M8goE8DJRi5iN2qvLcoXcpXUdccTjulg2hP4NEmRbYjGFLZpuNOKgqefdxAzqMSakGQf3P2sfrYWYJM9dKZw8UyfdKpnSzPrE3zQcWjRq5virMRR4Eg7Yx3wmuImYbETgWA2ctA+uciFz+IK+BCXYNMfqbJwHOBAopCBkw7/8AhYN90Mogd9rQ2VmQJ59KGrFxl+oW8JrRkHywEzTbjtq7SpNIQunJKBfA5hYK7XV9m3lqtA4l0Xu5cBsdmUPxsPOSlGj9rv1hlFjkkTInDABIBATSHBStXnuCi+n9Yi4Ba9f9PCRRptY1SzSv3CXAQTud4LGdu+ItPZ/ODfHg030wN7zrtZR8rbZspr7c1A9+MTNpRzV+sU3zZQd/GR/pzcGc4JSm2nyKhFeSdTQHMsn4n/izjiFxTWTOARExEygpzRHByAbv4J+VYpNg2tk1mzNzt/1LUzOUL7NK1WlYYuC6a0S6LcUDKGocDnpnNtimGSxpNZOBsnf0v8j6E8dPv1m6iVxdW3uCtSNosnabfQXHgOTz6se7xfuqcxIGJ36I8wjCbn7YZJDDYW3tYuPHVpBB9kajCc3VfHphvG0CzpW4nWEmN/PoMp8G5v/IKFaQ3bIBe2y+9oCZcIBdlG8mi9Wo
 bsoNgdb9
 N9YaYV6SNLwQPasN+IEsoQpnV7u1ML9KTJ39LhxL+uqpesMvI5BXKIsP6UFUBQJ0Dk6Aj0yKpp1K31xO+gvurgGW90gvjRsRrxtTACe6A/N2LCi9Q/13ra4hos0sFhrGR6I1kz8YPoQbQwGhpvyahianKXqKDqSiUS6U2MrBYYGLg/b+NXxC04o7ufTvZ5kWgxsNYAtvhsw2HABWcCdykLe6kH8+SvtR1WRGKoo7oJ3CAdz172bRgJvT+YsxzISsrsz6kQyRhYQaDz0YtlkjfMYa348eI67FtGOYFW63fdzsKeGPldNYxwH6781tEo9052IoyjBtSJ7/yyy2DPCRADLhLl/Nh1haa1xhPpGAEuEeFco7i+7jNSlVAWd8BrCSl1+I9IUEcO1llZFZDUKmWjTRe/TLDIKSvyPfn9zbeY8yUpye2MuFVlZPZ2/6Z25rHvN1XLg9M2++o9a9URTkcytnWIab0RzQrTwByQJJfry5p2jD3vgGdBojUUEDivmlpy4LoScFH9L6iPdRe18oNxrTFHlmAcAzU4vlTGOcTUDBCDEsIw8LZwwEGa67zrUIHavhj2/HXz8fZ3t/5ez9Pei3x9bQYGccogr/AwV5zF9TfPTKHy+s9wxjjIsTlyIKk6t3ydYdVdM22EYZEFgFuT2/z6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

> Tarun Sahu <tarunsahu@google.com> writes:
>
>>
>> [...snip...]
>>
>> @@ -273,16 +284,30 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
>>  static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
>>  			       loff_t len)
>>  {
>> +	struct inode *inode = file_inode(file);
>>  	int ret;
>> +	int idx;
>>
>> -	if (!(mode & FALLOC_FL_KEEP_SIZE))
>> -		return -EOPNOTSUPP;
>> +	idx = srcu_read_lock(&kvm_gmem_freeze_srcu);
>> +	if (kvm_gmem_is_frozen(inode)) {
>> +		srcu_read_unlock(&kvm_gmem_freeze_srcu, idx);
>> +		return -EPERM;
>> +	}
>>
>> -	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
>> -		return -EOPNOTSUPP;
>> +	if (!(mode & FALLOC_FL_KEEP_SIZE)) {
>> +		ret = -EOPNOTSUPP;
>> +		goto out;
>> +	}
>>
>> -	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len))
>> -		return -EINVAL;
>> +	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE)) {
>> +		ret = -EOPNOTSUPP;
>> +		goto out;
>> +	}
>> +
>> +	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len)) {
>> +		ret = -EINVAL;
>> +		goto out;
>> +	}
>>
>
> Continuing from [1], this guard is actually meant for PUNCH_HOLE... I
> wonder if there could be a deeper refactoring to check when actually
> punching a hole, basically the equivalent place as kvm_gmem_get_folio()
> in the flow of fallocating.
>
> Will srcu_read_lock() be taken in a nested way for the fallocate case?
> It can be taken in a nested way with some intricacies, but maybe if the
> freeze check can be done just as the folio is about to be removed (as
> described in the above paragraph), it would avoid this nested locking
> here.
>
> [1] https://lore.kernel.org/all/2vxzzf0kl3dt.fsf@kernel.org/

Instead of avoiding on remove folio, We can just add the freeze check
across the PUNCH_HOLE, So there will be no nested lock anymore. Nested
lock is just with fallocate populate -> kvm_gmem_get_pfn. So this nested
ness will be removed with this update.

~Tarun

>
>>  	if (mode & FALLOC_FL_PUNCH_HOLE)
>>  		ret = kvm_gmem_punch_hole(file_inode(file), offset, len);
>> @@ -291,6 +316,9 @@ static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
>>
>>  	if (!ret)
>>  		file_modified(file);
>> +
>> +out:
>> +	srcu_read_unlock(&kvm_gmem_freeze_srcu, idx);
>>  	return ret;
>>  }
>>
>>
>> [...snip...]
>>

