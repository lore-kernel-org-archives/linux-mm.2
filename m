Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 478B2CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 17:21:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 284036B0088; Mon, 12 Oct 2026 13:21:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 235386B008A; Mon, 12 Oct 2026 13:21:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 124A46B008C; Mon, 12 Oct 2026 13:21:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DAA906B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:21:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 654561C4C09
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 17:21:23 +0000 (UTC)
X-FDA: 85314640446.21.A4DA64B
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id 692DA12000E
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 17:21:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OGVcKFz7;
	spf=pass (imf29.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791825681;
	b=4xTOoLMaheDV5F67cviwAFL4UQV7gLhbS1dWlPWiHk9WarHn3BbZo+klVN8/uc9Ypl2wWW
	TQHMN6ZMu8dsmsUyBwmyd73J7ubTH/j7o0kLlNsXLSU9bPT00uog23kbz2K/moHzpF/qWK
	Th8Bg0TpMfsxdkJpA4EQ3aXucVzcX3Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OGVcKFz7;
	spf=pass (imf29.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791825681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XVOLHzyfqUmv7StJG1aPauWki6PAmKd3K90h79SeG0Q=;
	b=dLuvHSBSq888/45cU6JYw8xvenYUwjsbAwgrvoFMSZLV0Le1gaOwBV3oJxviCBY8hw5Rzu
	FKdMeEKlfX5pl+QRHR/xVg3lo0UTyBXlMOUNmTMxbvxSDgaZ6psmWxDsAa04X8+9Ov28SD
	Pb8+TLZJBC1mupYzVjTaCuK8G1S/a50=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48b042c0759so1608023f8f.2
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791825680; x=1792430480; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XVOLHzyfqUmv7StJG1aPauWki6PAmKd3K90h79SeG0Q=;
        b=OGVcKFz7oblPM5LRuE/7xTHEHF7OGJzuDdpwU4VbJZC5JkdhjZY3jKrSgvrWhvrpHB
         xGM4NnjZGRE18m0i3Y2C8mrej8XMZxs4B0efcLYLe7kmbQrkllc3pLHazbY8S7FDmXPQ
         arNRNXHaYRb3j8gsZfT0kL8u+ftRABrbepeWFSHzYM+MsHv8kKRyAAnV17+5eSaZA4kb
         82sJ2ed6lBcijfJfHYLHkI4ZAeuOm5UPlxhSHZkgofv3nhi6Ks4z0oFmmogCLrYAO91b
         dWISnGcXKuXvnKzLN8keRT8SJMge3LKb1DwOXVIxPLli7IDm5zAC6pkJinH2j0LEjjlq
         9lkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791825680; x=1792430480;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XVOLHzyfqUmv7StJG1aPauWki6PAmKd3K90h79SeG0Q=;
        b=evWry5zV2dGV8I2wyemWKuDaNdfo9Lmc8ouCXQwMI82AnGpHuibNyLgBstBA606zR7
         bKaYNzD+9oXyJkeElBjpVsPzx94vUjm5PTXgj28jfXrx4He2r4vE1CNmbLC6MfatZwNQ
         pE1Cve/YRey1I7UJ8t+YrFlQ0k8Nv6R4uGLUv99HAp1pk2AVMUS4mpx3CUrNthfCtt4H
         ih83GElOK2YMpIDZ4wGyHKrbdXmu8uKliFJC+yzx8BQcrWZcKE57LKWX6VlgovJABUL4
         hlXJijbzY+k9jmLbqWgQ/3/oiKup/nblDqBfIp4HW+IC0CvejegwH57KUHmDNQujn2xs
         Td0Q==
X-Forwarded-Encrypted: i=1; AKwUvBwzZ0t3njIDFen9TD5vLtcSMfXVgqnPbmRdhRjO8dGZ9pOJl5j7b8Gm16RpeMVbvHp9pp+57qmcpw==@kvack.org
X-Gm-Message-State: AFq9FYKF2977cxROhD2DOcnbIIsbOnO0h3gg5tnzxPXP5fZDQMVpTZ8c
	GSn63XdnCLGmBn+sXOYTBf7d/ffIrFgQucvAyRkwYUJDD5tPBaIiTFzp
X-Gm-Gg: AYBFou0EJRPfYeURmbR1j9g0RFVIzAS58a0DvHp1S8GZJpuBu87neZY/rgbgxJz2t7H
	51W2SxmbYJ0AHY3lM4a4zzPOANonN7+fiOdMaM6dEQncGB2ekLj5Oi5z6Kv9QuhAobzKBrq8otF
	QNWUQPVLojI+M/1y5TNf1sMr7fi+pl8nnieg37TYFW/X+7a/oR51txn2lfgQlr30MmWaxCt+VqX
	hbgqd/E3F8q3eWeC+ziQ/Ks+7xm9ovrw/VG1H3ybuIh8IKpFrNPfnxcV3NHfflugXKtYJC4LsnO
	BeyJ3+pr+l2nJTYBin9d8STYcyGU+UIBS6p/APQlJ6fMbZ4ehjWXrwVoR05HTjbHPQM2DbMkh8T
	jakR5/DJzhOomLmqS5K0Xi//PO+JobRQbgamixWcjisQT/YhtH3hVgLRp+o0hwMcPILynAG31kC
	XjxJUPRf8k2N24nFxbq+EprWUysqgKW4/d8EHBbWzYEVmOAi+FGyKT+ECycwsNBY2ioA==
X-Received: by 2002:a05:6000:2990:10b0:48d:de7b:9caf with SMTP id ffacd0b85a97d-48dde7b9d70mr2473124f8f.8.1791825679711;
        Mon, 12 Oct 2026 10:21:19 -0700 (PDT)
Received: from [192.168.1.18] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0aaaa21sm583094f8f.9.2026.10.12.10.21.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2026 10:21:18 -0700 (PDT)
Message-ID: <3ab63358-8bbe-4457-b21c-bb81bca804cc@gmail.com>
Date: Mon, 12 Oct 2026 19:21:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm: fix missing page-table destructor in
 pagetable_free()
To: Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <songmuchun@bytedance.com>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Dave Hansen <dave.hansen@intel.com>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?=
 <bjorn@rivosinc.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261010112457.49485-1-songmuchun@bytedance.com>
 <20261010112457.49485-2-songmuchun@bytedance.com>
 <asy-b7_C3SjnmSaS@gmail.com> <145CD5DC-6457-4E1E-8B9D-AE7D1EDB0AB8@linux.dev>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <145CD5DC-6457-4E1E-8B9D-AE7D1EDB0AB8@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 692DA12000E
X-Stat-Signature: 4yogrrwf4fhzpduhdooz6ywtykhsymgh
X-HE-Tag: 1791825681-793377
X-HE-Meta: U2FsdGVkX1/0tIc8yLv6cAfO61IOxgWwmBGxrxOvlHOwKiHYJ8P3b4mL2LCi7PU3piYn/9Rf+WTzr/p6gOvMBjc3fmFtdgPilK8bl+ro23At2ozyomHHWnlFZJ4E/4KiLSCEWrhG7hKKFzKXrbIE9Kv42AcCzqlFjK1Wpcp9qzJXx1B/aHp7uZgeUyEohF3hbtCYTYLuvzvKmMOSqKG9zYdEm3XfoS8+f4R9928wVtTahga1c5Kjjcs3g0GtLmZCIPKAkKwG4EDyhvzpAa5LaKgjwhPT+1aq1BoKAc39xiWA0wNhMbMi40gGu8unuFGjX+sfCpZnUWHqb+aeqbD9XKa+InrtlhkB7/pXk3x0zVWwiiIVaEwjuNM6rRe+uFbDSx6uUgyKcJGUIy6ZWIp2vIpToypqew7482J6VbeZPjfFUXgDG0bZ75ia11fYY8Rf0Wh100BkeFGko7o9lFGFhLdSux52b343SSOpN45sEZsY3T7r45QK9oyenhM+7u4OdaGzMTya9eyU1m38xwmB0sIuNGU8U5zSQIzqSYKkYsEf5AQQeSRA/FL+3byZSh4jeqbQDla7IE+MjtXgvJJXrlKtGxlxb5cB6Ohwk2iFzkWwtclnUbZtHNb9kz8FtcBLs+NLtk3KSFII/yh3BsaXIh74idl7KQVpkPbhEICH3HE9wZxAHI0dez2xIWrybMALl5S1fkSOF/oW525shPfgx500kmXVttTIv08lvOux6x47LRn4bo+8WfDCgZ4w6GoodgFbNQdW9XAJw5ZzkCFuLYe4KMT7A4+A2ClmoN3b9M6q/ya+7H6LjLwMIFjNEohdwXg1Sjkd2Af912NnaGwLK3/34gW3SisprXjL8FEztaJfybTY1Mzf1SSsVxlcQPHzOqRvd+dfcdT+7arMGqo3BjV/14b/xg0fvIezcywLZPHiVCAwPQHYfFvL2TqZDcoPEQQ3xCyfvHRPFyvMn5x
 EEkqp+JK
 ow03qJT5ubHvRb8ez8559dN5HpOwB/gUXezMnVHmG1WaUY1+V/GJuRq7te0RvrsTPvUSFydjPXHACWq8j66/wlcRLJ6Ju4lKsYyn3kuiMUf3GHaDvW3A7rIPKsD3CEIKr+Z5UP3mi0XV8x8IQ796gSnzmB0oiUnO2ayxr2fqrz2gIBL+ETVyb+IxZYUdobnYi5/YBk+DmrbTHhnm+34sGf2SS33k3bd28OykrIre5ubQ0qORgWcmsArj9b4bZZx3DfPOQKIU6N2aF26Ra6poN7+LuSog9Tid4vluzK/1CIBLJQyV/RZtouiYhxPQc9He378AU58/9uoWFtjhe7KfLfqRkaJGstcH4HPcMt4YvJnesYgkYmsPTCYjthrCU91cJLcoqaWywaYlPuwxpZE792l4yyYHOAi5Bk9ZS+z0puv36wYTX0Sf/31BN4JWVm5UznQ4qp1Hzmz0sJfQylsvB+cjEF59//j+C6isFbtDQQubPybsV1p/BrZNcMoJtzc5EHdbE6XXWgbuvhwwOh5BsvtHP8YOtwX/cfwIAsBCenq9OV9vMqwRXOjr9yQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/12/26 2:55 PM, Muchun Song wrote:
> 
> 
>> On Oct 12, 2026, at 19:15, Jose A. Perez de Azpillaga <azpijr@gmail.com> wrote:
>>
>> On Sat, Oct 10, 2026 at 07:24:54PM +0800, Muchun Song wrote:
>>> Since commit 49f599666420 ("mm: call ctor/dtor for kernel PTEs"),
>>> pte_alloc_one_kernel() runs the page-table constructor for kernel PTE
>>> tables.
>>>
>>> HVO (HugeTLB Vmemmap Optimization) uses pte_alloc_one_kernel() when
>>> splitting a PMD. Restoring the vmemmap backing pages does not collapse
>>> the PTE table, so a later memory hot-remove eventually frees it through
>>> pagetable_free() on x86-64. That releases the page without running the
>>> matching destructor and leaves NR_PAGETABLE elevated.
>>>
>>> Make pagetable_free() detect constructor-backed pages and run the
>>> destructor before releasing their memory to fix the problem.
>>>
>>> Fixes: 49f599666420 ("mm: call ctor/dtor for kernel PTEs")
>>> Cc: stable@vger.kernel.org
>>
>> is the x86 case covered for 6.16-6.18? as far as I can see, x86
>> free_pagetable() only uses pagetable_free() since bf9e4e30f353
>> ("x86/mm: use pagetable_free()") in v6.19, so the backport wouldn't
>> change anything there. or am I missing something?
> 
> Yes, you are absolutely right — thanks for catching this.
> 
> I double-checked and indeed x86's free_pagetable() only starts using
> pagetable_free() since bf9e4e30f353 ("x86/mm: use pagetable_free()"),
> which landed in v6.19. So for 6.16-6.18 the prerequisite is not present
> and the backport would be a no-op there.
> 
> The correct trailer is:
> 
> Cc: <stable@vger.kernel.org> # 6.16-6.18: bf9e4e30f353: x86/mm: use pagetable_free()

also, bf9e4e30f353 alone leaks PMD-sized vmemmap pages on those trees,
it needs 39406c05f8f1 ("x86/mm: Fix freeing of PMD-sized vmemmap pages")
as well :)

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

