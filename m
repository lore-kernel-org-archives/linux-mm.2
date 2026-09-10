Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2EC2C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:03:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0C866B00A5; Thu, 10 Sep 2026 07:03:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDDCE6B00B3; Thu, 10 Sep 2026 07:03:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACD616B00B4; Thu, 10 Sep 2026 07:03:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 905796B00A5
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:03:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E0FAB404A0
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:03:02 +0000 (UTC)
X-FDA: 85197565404.30.FC1A663
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2B180A0003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:03:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mzqBx2zP;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789038181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P32ieGJu3Afv0kkfEMjK/YLsgguxDMlrGHW+fqvIAaE=;
	b=ZQPv9qhp0y3EgbNt05KmqyxlcI+Hf9wpU1jc/yjpr9Oxz6rfzJsH1cFLcFYOaDjW1OqfC2
	0XfcEErC+jqFYtnfst/2Hl7NjJHuJO/nrdRiBtxrtqzpng8ajvaJ9SHsK6QeJfSLGLszaN
	GcmH/JZDWMqV+/hsPoSAkxzcjorBFdI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789038181;
	b=FAJYtMdNE1QJcCEfgrBjazrKY5ZyhcvanokwFRYRkNWdsYq8hraqU2RTTzlqMtjafzyhZ3
	n7gzkuzrh8FlS+BSsKlYUlpRTtQV6+vnAVrzPnsEW4xghR5c9vaHfF3WtoTBXexCs66UjU
	Yv2EVCd/f20kCInfGW/tw14cBuBQD1g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mzqBx2zP;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B5177600CB;
	Thu, 10 Sep 2026 11:03:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55F31F000FF;
	Thu, 10 Sep 2026 11:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789038180;
	bh=P32ieGJu3Afv0kkfEMjK/YLsgguxDMlrGHW+fqvIAaE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mzqBx2zPfVH2uaOqGHJT+gorRxvbdB9Eu96N466UgnMc/0WaAuPusdTDE3e4SddEo
	 oZEvVBu9/jzNKA1b4F+Fd/zt0Ue5fhsx6pWVwnjEzoEtfkHCqaECBf98JP/mtBJdKx
	 jkJtRp37Kct1mkXbsdrbOygxZfFXYfUvPMKyUSV80GDQX7aUywvMFW23x4w0RhkWic
	 veNENsZLVqikPST9m2zltfy+UwD7oK+w5XCZRY6eRnyLViMYHFjqJQwti6Rpznv1QE
	 nQMOMg2uSi17MwlrDqZDBgY4oCPZ5751gua4DWnnpcb59v0nNHol5kgsOwYhuItgGM
	 L0Uhy5a3RQsXA==
Message-ID: <aed03085-1d9c-4a26-be9e-196c3ea941d1@kernel.org>
Date: Thu, 10 Sep 2026 13:02:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 13/21] x86: mm: use pgtable_level enum in
 effective_prot_pXd()
To: Dave Hansen <dave.hansen@intel.com>, Yeoreum Yun <yeoreum.yun@arm.com>,
 Russell King <linux@armlinux.org.uk>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonas Bonn <jonas@southpole.se>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-openrisc@vger.kernel.org
References: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
 <20260902-dummy_ptxp3-v3-13-5d8f5b17c25c@arm.com>
 <8f3979a9-238a-4d7d-a040-6aa526fedec5@intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <8f3979a9-238a-4d7d-a040-6aa526fedec5@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2B180A0003
X-Stat-Signature: bidh9cg99ofjhdhmkcpmiz639576yn5o
X-Rspam-User: 
X-HE-Tag: 1789038180-935317
X-HE-Meta: U2FsdGVkX1+vyWvkmD5S8v3KBfubriOtNBP2juT7TNVO8PahsAhEGKFuXt+qKsNuTPhdnba5wop5DtW95QbH0m68DVtZuzN8GLdMJymIQCrBJe7WsyH8kYyt4WGMOiUm7hqMPHtLgUqUaY6LSSueEg9Sjxv4FhexTNTvQS6OixXYKFD9GZyLHOPSUZqa850wotROjPvstdlK/oukbw6GWxyHP/MT2C0bONGl7Psw5S5nc2HE3YMDGelC2zs/YzADbiXUGEymuspGMDQjd8K5A0fJZSvvAHTBKe5r2bmaXE4oEAlppX9b7J7PKQIXo+nMaZyc3+oHmCjWoMpVqLPlZpAqyRtlvy89Dzwy522fBbKKnThwDe/mkbo0Q67itmj2nyAI0zC3M5FYq0y4UxHWmhqJzpzJ+viDSpKTnSmGK7Q2MMXl2SQrCRY9sCRcdqDLxP7JVURycsmCyWT433pzsKknVZZHom6M0OAA+wluuWzW5zKWLix4W5+loE4d58/PL4xazFafA9LyKbpPjEcdnc8uBFCcQvQOMxQFFQYPajTpq+vmQZgQBEmSTuN5TMrP5YsVWL3MXojyAPedKvIWK/L1hx3SU6rJRxBVh3jB9LLtheYdHSHJVeXX9AtDcLw5YjI2GQbrIWbviU5htyjReG65U+YPvpdsbiWJ2B0HDuUsU4VZnYSNq07KTmcRC9c5pGJzxqNR2iLGCfCfwgYiBLHBgZZSiz7jSUz54rAdthfqJOaYnqAF2ebzR//9MgKwrMcbAAQCVbwwvsrLg28nBV9hmU5IoPlatJTvv1XcB7Y33MGMyaALm3wTNOH8DRvMJlk8HsisV1lKsgUM9iD1Z9N+bk4pWqBI4OBcz6nW0UZfT4FF6YED0aWaok//3Re7WZMXOZn/R9m8KRbGqSz5B4LshJpiqmsELCZjhahLtwkk7YhZuOd7CUUjfmfEw6Lieb93CSzvjubrXgSYYi2
 I8tW0G9K
 k2ightujPqCr15tDihobKoI1VP4q85wSYb3AeO0Ll2I5P7HnuGsvvK8Pavp/owqugHsiMlMJScAxN5RgAnbt8P/6jme+DZxbfCSjjGqtR6WUKo4LJqQeZXA0/rlUaU1ZYglLRB2Pk4OpKo1MAc32f5SHVMdBoP6r5g6L160IVRcGBawB8dEn6mYlVqBwCXxMIS3GW+OhkmDjpOvIT1wgY7AUg5OUxEyphsbOr5D7V1c0ovC81lsjCR9Yo/F/grHt7DFStgx7jvfhtomGgNMjDiQMy9qR384NWtQ0dAOIOWvlDTn7XH9P/IueQng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/26 22:48, Dave Hansen wrote:
> On 9/2/26 04:56, Yeoreum Yun wrote:
>> Instead of using hard-coded integer in effective_prot_pXd(), use
>> pgtable level enum.
> 
> Does this actually *do* anything? ;)
> 
> I guess it's nice to have a wee bit of type safety from the enum and it
> means that you don't have to *know* which level number a PUD is, for
> example.

The next patch passes the value to mm_first_pgtable_level(). Not sure what x86's
preference is to spell something like that out in the patch description.

"Prepare for future code changes that will consume the generic enum
pgtable_level from inside effective_prot()."

-- 
Cheers,

David

