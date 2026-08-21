Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9660DC5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 12:03:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A29EC6B008C; Fri, 21 Aug 2026 08:03:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A00BA6B0092; Fri, 21 Aug 2026 08:03:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93D926B0095; Fri, 21 Aug 2026 08:03:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 72FA06B008C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:03:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0F52340446
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 12:03:37 +0000 (UTC)
X-FDA: 85125142074.09.4B69194
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6C55E180014
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 12:03:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FW9VNZWW;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787313815;
	b=Wfj9+fk6nBaTvf4DljIUJguFT6DAq8ulxpUYaNvihnzfjZYQXPYiI26fR8BZE8F55WExVh
	JrUo+4vS0cRWcB6c89+Otkfjx1g0559EMGyNlMx2mCfhxYwoqIc+uTIQuas20xHLffUvLi
	cC75HDV9XbhL2XjpvxnOsdWoggt+tBE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FW9VNZWW;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787313815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CPHwxj7cgfi/sRFO/JKzf12L/v93WRQC6iXrX/2UKjo=;
	b=Clhoot51lQ3v3GyfnPh1JUZYj2yy6fi8Rz86V1wNP/4fuJ7qdHr3QdhUnmJIxOosDId8lx
	WfF5ph4zLr6UxDv8ajcsM+9Z5M3qsGa/4IOhgo9CKzZRcxyj2eWwHJ0lAaI4ceJgKYt0Je
	JKWbcdJ7oo2zWQysDGR19LXNa4wTYkw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D7A7408BD;
	Fri, 21 Aug 2026 12:03:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C4D1F000E9;
	Fri, 21 Aug 2026 12:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787313814;
	bh=CPHwxj7cgfi/sRFO/JKzf12L/v93WRQC6iXrX/2UKjo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=FW9VNZWWcJRWeOTsfqG/VhlOIWFBxJVwe8qQ5oJ/6a+dgxXFiuOpleuNfo9Kkc0oN
	 fHUnbSoLU47lPBjGpbLd+GTnToWJMfgE8eYvsOwQyYGZoyeRKRZDW5gVfbv8ptCjeP
	 mJaQcjqZeExwsqMZ75PrZ4/GkUrYy5pePxw9k1XndOqQ2MTJN0p6wU8vJuqI5d6Z85
	 h9addDWDBzemyOtuPqhXh3Gw3q8MMCJie0Q6FJA1FuutruSnBMf5KBF7Ryb4po7Pba
	 R1geGg21BhmJ+PWE32ng98qsO9u0picoefL+3Pl3+RVNqPH4ZPWk+VylifnTNONXTY
	 zQtrFIATDMPbQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Breno Leitao <leitao@debian.org>,  Ard Biesheuvel <ardb@kernel.org>,
  Ilias Apalodimas <ilias.apalodimas@linaro.org>,  Miaohe Lin
 <linmiaohe@huawei.com>,  Naoya Horiguchi <nao.horiguchi@gmail.com>,
  Andrew Morton <akpm@linux-foundation.org>,  linux-efi@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,  rmikey@meta.com,
  riel@surriel.com,  kexec@lists.infradead.org,  kernel-team@meta.com
Subject: Re: [PATCH v2 2/6] efi: add the LINUX_EFI_POISONED_MEMORY
 configuration table
In-Reply-To: <aog7bwfMVpSy9LcY@thinkstation> (Kiryl Shutsemau's message of
	"Fri, 21 Aug 2026 12:51:34 +0100")
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
	<20260821-hwpoison-kho-v2-2-5743791e48e6@debian.org>
	<aog7bwfMVpSy9LcY@thinkstation>
Date: Fri, 21 Aug 2026 14:03:30 +0200
Message-ID: <2vxz5x13znn1.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6C55E180014
X-Stat-Signature: bg7dspj5fj1bf7czjap7de8fjbx38bt4
X-HE-Tag: 1787313815-943280
X-HE-Meta: U2FsdGVkX1/2nJcqMF4Vun5PKyNmj20z8EjxLP3k6z+LSougSBJ4pRsFUjBkgDKZh6GqyGEttaLR5k8NaSgWWbXloK8YSpCADScqTJrEdt+czd7bOO4zi0qgFI7ayeQ9fmox/Vgspo1xqlCvDSqXc4wD6RW1JOljCPgL/oPkNACo6CAlFkGMJeXLUYONeYnFxzV22UQfifTDQ/Vk82m8fCRwvrRcsm2MBQvEi6qKREnDB1MMpoS1ryBIcfACMtM/5FNYc4xcyotvykJ6vN9+VIEVfqmII0u3aZ0Vgq+ORiWPp9dGr7jZ4ziyJp/38oiIfKIycUS4f9wQiwImZ5wDgmQLD65ghzR1EFt/rwQYV0Egk+oOi8gN+7Oi6k6sgIvRnm+od1/uAyJdcVLrjDs7zaX8TRtlAW9G71YEsbgmThO3swNOoExedLK7wjAOPCr+lf0LJdliKNOkP8oMDhTpsM9bzCiX26t4VdM345Z/DKxRgjY2Aml8+bl7RyWv3TQEiDvXNf7IgRz6v0xzhgj4nOtKENDySqD1GZbxGtQRHCqQe8dO0H7xTROGF5d7g5atUwLLocTzuhLIpgWMdwepIUqA6W0/XE6ibSUDx1ZMQQGyNAAx2mahnz4IBRlhsiP7dzHDMlOXJkwmjEbp0BcqLIikU5zm3POkOIpAnkheUzC1XR++9WadtRH3N5P61D3YSbhkjgVlFL4KSbJfvbqdbkDWrmDs4m3oNc3zChbqzVUxi8brUsa3tqT/X8ALuQjM3nLz/4yI6SLxHpxlRH3oumTSo2FaQef6bcdii11mF38U1LHUoiUT7A2Lb9CjgGphTHZa4xPQzH7LT9TpTyXuM5FvUUJAWHS4s+m6rNtaTDtf2As066NqPiDADuPUXhSe995tEvg8N4LFu4sQaQEIB+KM6mNTS0P4sTlInWzgg4cTxlUhFhrjkR4x08TenOdBV39TXg6D/b4W8SGxF2g
 LfRQ6o/X
 jvRtya2rYHuJb8TW0x30BGDh2Z8KQ9ugp6F3OHPzw7XJ8RXD1kqgcuLg3qSvCqcBkrxGurWPyd5j9+vdF44V74wh7ehayvHpZAKhEf2FUdpp99ozOgcnKsAI28wcww7sP9QEjJwNUc/rvefi0vmKOShB3O8tWQFfzY3i2dK3nBvdN5F71rFvGRSUC9zgPRVhE1sYw42LDPYxd5c8Jaen+oMGWsicyTHIWavsiCHElbOT51AX88X5HczR7LFA4jQ/ZgHBCUU5kiOjolyw7OD9cJ8j4+rrwT5NBlpmbuIpiJ/Nr356D6iLf2ZH94eiIxW+vNuamEdWfIKQkAV0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21 2026, Kiryl Shutsemau wrote:

> On Fri, Aug 21, 2026 at 03:06:02AM -0700, Breno Leitao wrote:
>> diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
>> index 29e0729299f5b..69c0dc02bc112 100644
>> --- a/drivers/firmware/efi/Kconfig
>> +++ b/drivers/firmware/efi/Kconfig
>> @@ -263,6 +263,16 @@ config EFI_COCO_SECRET
>>  	  virt/coco/efi_secret module to access the secrets, which in turn
>>  	  allows userspace programs to access the injected secrets.
>>  
>> +config EFI_POISONED_MEMORY
>> +	bool "Carry hardware-poisoned pages across kexec"
>> +	depends on EFI_STUB && MEMORY_FAILURE && 64BIT
>> +	help
>> +	  Record page frames that are hardware-poisoned while this kernel runs
>> +	  into an EFI configuration table, and honor that table early on the
>> +	  next kernel so a kexec does not hand known-bad RAM back out.
>> +
>> +	  If unsure, say N.
>> +
>
> Do we want to make it conditional? Maybe just for everyone with EFI_STUB
> && MEMORY_FAILURE?

+1. Each config we add is a decision someone has to make when compiling
the kernel. If they rely on the default, they will miss out on this
fairly useful feature.

So, is there any downside to just doing this by default without any
config?

-- 
Regards,
Pratyush Yadav

