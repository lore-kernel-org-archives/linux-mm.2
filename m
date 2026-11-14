Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1695F606A33D
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 09:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Cc/Urxep
Received: by kanga.kvack.org (Postfix)
	id 1673E6B00EF; Sat, 14 Nov 2026 04:34:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F19C6B05B0; Sat, 14 Nov 2026 04:34:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFAA76B05B1; Sat, 14 Nov 2026 04:34:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C717A6B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 04:34:48 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 20AA41C3A7A
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 09:34:47 +0000 (UTC)
X-FDA: 85433215014.09.0DA996D
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6520F80002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 09:34:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="Cc/Urxep";
	spf=pass (imf30.hostedemail.com: domain of 3Myv4agkKCMg7o5816ov8u22uzs.q20zw18B-00y9oqy.25u@flex--tarunsahu.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3Myv4agkKCMg7o5816ov8u22uzs.q20zw18B-00y9oqy.25u@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794648885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cYfB8ZYjzkbZTu8PkWr5VdyVYonCx+ZsO65KHqfQojE=;
	b=cA/isXwphQlLy3bjQMwTtHxnn9s9GnQ+jQ9OJnUdbN6np3dy4HAT/yppGUTedLTofEWFX5
	Ka+7FZGmDILn/Ejob+v98p+Bsas+1xQhZqMqMQTRvRrsk29lwDZsAEEVgTUjqTglXUCYQF
	32dU8Aq97BZ2N7eIqmxX7Xd26jTBt9o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794648885;
	b=brQOxHznwXCLKa/suESN4FRWbvKyN3hNdiFULvsxH6WJrecxUvU3WNkbG++C6hBHZJVRPp
	Jf8hJqyyrt2bwT4RTzERgQFSybVydWpc/T0h+2cT/CT6pd7aikdVrnbrc5xM4PiJghHzzp
	fTGY6zmmxySMSY+6XiT/NmGb42uVdrw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="Cc/Urxep";
	spf=pass (imf30.hostedemail.com: domain of 3Myv4agkKCMg7o5816ov8u22uzs.q20zw18B-00y9oqy.25u@flex--tarunsahu.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3Myv4agkKCMg7o5816ov8u22uzs.q20zw18B-00y9oqy.25u@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c4d34d6082fso170335466b.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 01:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794648884; x=1795253684; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cYfB8ZYjzkbZTu8PkWr5VdyVYonCx+ZsO65KHqfQojE=;
        b=Cc/UrxepoaZwbFsrFkYHW9ZZdbCY3iynOdq2onR4pOihOMiUdZ1XdgwDx5xc5j/5dH
         EjWlgYAb8osS0TLno7rui3FNkiOek4/qwsXKMx/2JOurYn6/cOWt/7rn3RFUyumpfqQa
         bHB0QPEh7RY43IigbCqRNuW9D1KLCu/YZILN9J0PYv6ReWWIu8vbymFEPwK0TfDyy9RC
         ql9l7zyzEmVBnMHvSqmbJETulTH8xBzqC2xDjWlQ1LSneSAwJTuGjpRYwRBQaK2ZZKGP
         S1W1dar8tF18DZ44JFxoYaAQquSR8yInh7y9yxLWXzYWVxZHzGfAHKINOUypG5SgcD2N
         wCHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794648884; x=1795253684;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cYfB8ZYjzkbZTu8PkWr5VdyVYonCx+ZsO65KHqfQojE=;
        b=RPrgWvGC+dkEYFVXwXrLx52cgL+ygvZqAGScw6xuN889laIyq/EyvStQ03bwfKiQnr
         24I9Dzcy/FVPGXtmFFcItqGgO1rrxmMpYIZt67BetZhJsYMcLJMRxyqf2OsKVi+UbOF6
         /25e5zEztuDkZTGLnI8v9qNdW+BhVKFYGiM/grQTqU5CTS4vVjBHBolAv3te+BFb83dF
         6B8WOA/BNJToSmZHe9lWqeBc99C1r7QKvLH2xOGMdAinnHfzrtiw27SnW9HhxJ+oOjJf
         prdSeCkPgjvf3pDPyZRrV77GIuzoUQQMTO+51G13c8K9apMXz+gSrxe9NyzVBN9CRx9X
         JVMQ==
X-Forwarded-Encrypted: i=1; AL+hErEwz4QAcZ8u9/10UlMyQSy/hdO9QWTMuR+pCqQylmSqdGKKlsmqtkgFmga2EkmHmRpd9Yx7qHHJcA==@kvack.org
X-Gm-Message-State: APuU4Z824BwBLW4Wa/jDuNzopjgVfXaY8khSa0krZSoXUXlvv+06WsIz
	zkK8cYN2fRREWwfecxbT08iIvcgUqUVCP8FXxMVwYE2dQSeM0hhmTBKPUbqbxUg74XzjsmWIY2Y
	Ce7YpVau5ib8S/gPdWA==
X-Received: from ejbgl17.prod.google.com ([2002:a17:906:e0d1:b0:c50:537a:6835])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:7b83:b0:c41:b4e4:7958 with SMTP id a640c23a62f3a-c5095dd7931mr418395066b.0.1794648883281;
 Sat, 14 Nov 2026 01:34:43 -0800 (PST)
Date: Sat, 14 Nov 2026 09:34:41 +0000
In-Reply-To: <DMRP21FATCC0.ARAURXWV85JP@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com> <20261110050202.529473-9-tarunsahu@google.com>
 <DMRP21FATCC0.ARAURXWV85JP@google.com>
Message-ID: <9huzse13pxhq.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 08/19] kho: block: Add the feature header to blocks
From: tarunsahu@google.com
To: David Matlack <dmatlack@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, maz@kernel.org, will@kernel.org, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: chq6gqaesjtqm65g9eoxmwioioy1p915
X-Rspamd-Queue-Id: 6520F80002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794648885-216437
X-HE-Meta: U2FsdGVkX1/5iT+yulF/K27lchH+0alSTFWDubskIjBFbitTy3Sluc7w+XAf+6iFv3E+OpTtElmyaz9NQordYn5xEuT+Y86dmbCmpqoJamBvBFY1laCpmwKOpnZ11964h3NCusQiaBGiX28oe8qHqq5nsKjetCVX7M+I242IRNe5N9juQHeuMzW9A6JmGMGQbR7BHGZ4EP1Xvow751/ISwoYZ9c8n8Xqe1p5XKRpLj+qYjW68NjB4VHc5jt8Z77axXMsYCZTb7CP8zSZecOzTbpxTA0PUSxvuPgjM2Ny5swJ3tkcwfk/ZWgejgFegNou7vvsy4Mlsl+KQAjIliGX1uYkteYTPeH4Rn8yt6HksSjm2PWGJk4AJ89ABAQojYlmfxws9hFk68eaLIIUqUy4g55YVRCq9zStQN+kCQYcSxhcrJ7RjAUIeAH7v7osiYCy21llWjWl4eRie0vBXksungI9p3Q407aAbCvByAkGgyj/MRAg4d/A3+TgnaFbePF/+RgScodkkjVaOcW4SFS+Jm+lX4LlszsnGbnxIGP+Qz+3Vm7Lu3eIs7CiTJx3QmrB+9F7x3iuGYGTQ5KNVitGh7uv7FqgJNGpzs4BIA0F/7oqQ53841sjUnj6vj88OKfbSdmdbcJsMAcdLILD6eFHnwGHgVHJb7eZUgFpKwkJBlBs/UPoF6gteCuU37o2+11gCXISfGl4AZfF7ZtHcP5hntjIGwdc/BrRm9gPVn565vkgqYxNxf41HxPxBACKgwJ4RwAmu3kFlDTWhlU0PYoFg2H/iaYJX7Kfo3oBBE5NTMauFP4BjHYzySA/ofDb4o6dZfarxJllYxJLhIT5VadoyNjYRwHm7w1jfOgjKr48Lr9lqzIpTz/xUbNtP/EoDHGEDkNQ12khQFXVk9uZzXEmQ/7Gu2A5bt73BMY/Pr/J606zrJPG9GL3wfx8aZv8guvqpRF99AYEzZMJ/t+sIwT
 j7LOBAJw
 37bpKijdOVErVYE72PI+O5cziM5OQrTcJQ+Iom0hNGbyFlGO5nNMbcXxgEVmJY7wYvU6XKlig8/f7nHseix9+2ZR1CKq8RpDyKMjy/UUG9DXA0mf7LHJUJClk+fUJzKKoSpGuLwrV1Nd9Vh8xZUr5+viaM1CpwytceoosXt2juIDpV8Lq5OZOE+MqX5kpiBaLsSesRYotM0ZeP7agqW5NQew8605MjFg6d9YwjYKbQxPXrSes1XiLCWoyKAxSE9WkjAtrTIsQDNJFv+nCZoX1UBR6nmr57utlQLvDHGkI8MJQ55MsI9iVeN8S5la5MSZOpj9gDIMeBiCoZGYiTcIzAeiYD8VJjwvOAaV0Fo6A7Wsh0IVm2MyYKRAce4yHfkplUbcDe97MEKB9BkukczT1EuX9R25hGU0vGu+tJfh1QLkY77unzk7RX3VKLvQ65WpEy2rG46yJE1j0Berq9/1E/FJJKbflCHmSw7H2ehwlzyKo4ol5l+E+4W9kQWreEfAuKddc7gBMhRGUsdXWiiOVJ/bdu7TDclwfOc1qKCPg/122+EIk5Qn5h9L9raxcce+/wKQ/cQT111qRFH14VMg24ojE3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"David Matlack" <dmatlack@google.com> writes:

> On Tue Nov 10, 2026 at 5:01 AM UTC, Tarun Sahu wrote:
>> Precede struct kho_block_header_ser with struct kho_ser_hdr using
>> DECLARE_KHO_SER. Each block in a block set starts with struct
>> kho_ser_hdr followed by struct kho_block_header_ser. Serialized entries
>> start immediately after the header payload at offset fhdr->size.
>
> This adds a feature header to every block in the set, but the layout it
> describes is a property of the whole set: all blocks are written by the
> same kernel with the same header.
>
> Blocks are only ever added and removed at the tail, so the head block
> is stable for the lifetime of the set. I'd put a single set-wide
> header in the first block only, e.g. a struct kho_block_set_ser with
> its own feature header, and keep the per-block header to next and
> count.
>
> entry_size (added in patch 2) is another set-wide property that belongs
> there. All blocks in a set have the same entry size, so recording it in
> every block is redundant, and restore has to check that the copies
> agree.
>

Yes, adding a ser_hdr to each block_header is unnecessary and also cause
8 bytes to get added to every block. This can be solved like you said by
adding it only to the first block. But this will make number of entries
in block[0] to be less than blocks 1..N. I am not sure if that is
acceptable but if it can be then we can avoid adding ser_hdr to each
block. Same for entry_size which can be moved to the first block only
like you suggested part of struct kho_block_set_ser.

> [...]
>
>>  		entry_size = ser->entry_size;
>>  		bs->entry_size = entry_size;
>> -		capacity = (KHO_BLOCK_SIZE - sizeof(*ser)) / bs->entry_size;
>> +		capacity = (KHO_BLOCK_SIZE - fhdr->size) / bs->entry_size;
>>  		bs->count_per_block = capacity;
>
> Nothing checks that the blocks agree. Each block's entries start at its
> own fhdr->size, and count_per_block ends up being whatever the last
> block implies. With a single set-wide header this can't happen.

yes.

~Tarun

