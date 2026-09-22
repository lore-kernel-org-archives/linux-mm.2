Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 521D9C98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 13:53:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38E596B009F; Tue, 22 Sep 2026 09:53:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 365A96B00A0; Tue, 22 Sep 2026 09:53:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27BF36B00A1; Tue, 22 Sep 2026 09:53:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F24C26B009F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:53:49 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A756A04E3
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:53:49 +0000 (UTC)
X-FDA: 85241541378.05.EAC46F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id C412820005
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:53:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O52dv8lN;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790085227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VxeDKpLb30tS9iUp7//tyWkfTRpjfWGBd6HAgB/7yaQ=;
	b=OG03LK+4cVVix0OebQaE5vg+drcgGEr4WPeGInAxyytdkozbnTRMWbiAllDI4+Ez1XqTKI
	atM/MGA5qV2qNebAUjvhtq8af3HQ7VNnmLFQvVrYq87HiSi4eWhd41of+tkBj63dlqEpv+
	I3pyMI5L1tyEDS3NkHXwUuOZt0FQs6w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790085227;
	b=HrHMlnT7UZmZlK/yAsOmUUSDVTIPpLpiRfp4eoR8RvfFmi7zbd6ub2mNDLbAHThKA9e99d
	fGQNgJrgpyuNNCdKd1lp8BfEeNzzCGCxWvgZViqBT8GybVzBZX8+QFNH0U6gssi50wDzs6
	V5eP0QJxdydBZbUOZTQe0Gz89KMrJTw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O52dv8lN;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4B2BF6020F;
	Tue, 22 Sep 2026 13:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9134E1F000FF;
	Tue, 22 Sep 2026 13:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790085227;
	bh=VxeDKpLb30tS9iUp7//tyWkfTRpjfWGBd6HAgB/7yaQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=O52dv8lNK2jzOlcw6CykHwk7L7wkHDeVC7o0IltlfQxB3D0+mzyVDqnT9Hxr2yuOF
	 RFmM8SugGTS+VcGIA6LkIn7LxhU+jaitW4TbAUSdz+jaOvwQVAszl/VXCW0pHgD6v/
	 0HdGraAqS5pFAhbhPwnH/QFeJBr8Z9HIXuMx7ZJmF4fHHvANyENoGkVeaxGTImeldB
	 W2cKrkqE7uxyRBTA1s5xaDiBUV93v2Lz485yS6wFR5DpCZvxBCk3P6igzQyJn3o80k
	 H4huLj8gRm9Uf9R+BJyddzelXYFmNGu2Lb0TUwf3JkC5yhhBk3m77HWqjo3jjzBRHh
	 8hrzmQy1r0pkA==
Message-ID: <adef166c-ba85-4e24-806b-b725911c4d6f@kernel.org>
Date: Tue, 22 Sep 2026 15:53:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 7/9] drivers/base/memory: count inherited poisoned
 frames into the block
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Breno Leitao <leitao@debian.org>, Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
 kexec@lists.infradead.org, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Brendan Jackman
 <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 hannes@cmpxchg.or, shakeel.butt@linux.dev, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, rmikey@meta.com,
 riel@surriel.com, harry@kernel.org, linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev, kernel-team@meta.com
References: <20260915-hwpoison-kho-v5-7-3bc7a57bd503@debian.org>
 <de41b78a-8471-4832-be0c-35d410a4499a@kernel.org>
 <aqpczrtIwSG948iv@gmail.com>
 <b8ad366a-a019-4462-9dce-f687f60ee7f2@kernel.org>
 <aqvHHHuWJ-y4WRJZ@gmail.com>
 <caac2cb9-8faa-49bc-ae8a-47c5fd7b7e58@kernel.org>
 <aq1RaH0eE0hZfNpr@gmail.com>
 <fb2237be-f7bc-4ad6-bcb0-7c3ef53136ef@kernel.org>
 <arE3UjqPsxctWckg@gmail.com>
 <ad2ed3ed-959a-4af3-a2f5-4c21e5af62d6@kernel.org>
 <arJ5I9QHHBvuGH_F@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <arJ5I9QHHBvuGH_F@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C412820005
X-Stat-Signature: jrhkxr4iwg336584j4ut6ocnw5qeficj
X-HE-Tag: 1790085227-714013
X-HE-Meta: U2FsdGVkX18xqhaQqMTe//oBMayLSgtdTrWysvSBOvHLpo2nKl9Le7XVuW+VFq/iHh2QDbaWe43/X4F9jRfrj3+9slxh1hlxGunvxJ3C43S194ywwDSQnbg0xYrVoqShjsEb+4ibliC3b8b9bIce89pDDhe3XMVIXL5Y8Va0mGfQTX0SGtKm18UQNeHkC05d+Ku4rSQ4AGXWus9l/x8hZByMu68V37TkkQg5RrMYSl+5LCyHBvoMLKnwF/b9QcMpXmeYQLblutmEk03zrQUf2epVl4Jh0o5sOQ7BcdaD/jYJRkTMnCAeO5PxTczz6rnjd+mHNHJIXPqiNnRXBfrwPyihQVhK1N62U2FnJUU5cn56ovFTqvQGtYorRwCOx26DX/XmFfUxC8L9Knu/8LMb4g9CrnqiXyG8Tar9OlKqC8irCHvZ0j+W4Qzlrtvck3fyYsRHzzsuCBHw6VYbxhkEqh6XYxMWj8MFdbj/8Qmbu54wacF30dkyDxMiYUXblkgIvM+8I0a1GpxnKQfY/tMCSck1LUYwgF09YwP5xnevYzwLdCYb0dvKOS+eFpeVRjlozrwfWO2u9OSKYtIO7Lvgi8glK153kAEBlTs4sRdQIrRX9g2I2PTD6xw0YbIzXvXCtoj9ecoxfp2qJh71BykYJPismJPIsGqeF4KMj4DfpBMOmUpYbqXVdoEZA4ymKDRiag1GVFqIeYeHST/ddbxbvwEEVV4BV36ReQlZsBSmmnXtMkVlQTnUvfN3xewvy/z+KQAY78+K+xtxGWrTxugNrZ3es240nvB7Q4ooSwRx07yrkjPM9ypabp4R9OMH7Q4sm7dalJkSpjWvLHsag49zd+GGMQgoR1IUBA3SUeZnbw7pqk05VZfcjZ+4a8rlISBdHcG9LcP69KPXOypB3kXE1WzhAX3NYJ6ddoasW74qugG/F8nJtIuHWxVj//OK7RHzSweMhXRvMg6YR3mimSw
 0Fh42eYy
 uqtiEbM+PjpOEC/z9TWwdMWnI8fYBwW2ABFk/g/Vl5fFr14J4/DmmouMvO/Gn8KtB257fdVw2RUkxbIRnYb/4cfYyGxHqr6sMMz39juhwDcs0nkq6MgBvvAdynmG3BHPHM85UC7aCcv8mVh5ElG4xBowXrVx7/BG+dl4R5rIPIIJlGPSCq9tDBe1i2eF+PxGEDPgR45xAlMWSSf+XZtrsfq4WT3TOUlS+xWH0VoCpZ04o5nyeh1oVXpf+qrdLous+cmK3/r0lRnw5a3jjZ1SrwyNpklnazARTYB9QQBz6HxRG13yCF7AkOrGcuGEE7cmeoSqH+rbugco3sdI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/22/26 14:51, Kiryl Shutsemau wrote:
> On Tue, Sep 22, 2026 at 01:33:51PM +0200, David Hildenbrand (Arm) wrote:
>> On 9/21/26 16:31, Breno Leitao wrote:
>>>
>>> The EFI table is only written when there is a memory failure. That is
>>> the only thing that writes to it:
>>>
>>> 	action_result() -> efi_hwpoison_record_pfn() -> set_bit()
>>>
>>> You can see it on patch "mm/memory-failure: efi: record
>>> hardware-poisoned frames into the poisoned-memory table"
>>>
>>> Then, when the kernel kexecs into a second kernel, the EFI config table
>>> is queried and the pages are poisoned from it at boot, as they are
>>> getting into the buddy allocator, in __free_pages_core().
>>
>> I am not sure that is really the right place. That means we only poison free
>> memory. Shouldn't we poison as soon as we initialize the memmap, and check
>> whether any memblock allocations ended up on that poisoned memory and bail out?
> 
> __free_pages_core() is how we hand over pages from memblock to page allocator
> initially -- from memblock_free_pages(), deferred_free_pages() and
> hotplug. It is the right place to never allow them on free lists.

Only free pages. We initialize the memmap earlier. And there, we should consult
the bitmap once for the entire bitmap and mask *anything* poisoned, not just
free pages.

-- 
Cheers,

David

