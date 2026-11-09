Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30741606A331
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PVi9ExRv
Received: by kanga.kvack.org (Postfix)
	id 4A53C6B05B9; Mon,  9 Nov 2026 07:39:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4556C6B05DE; Mon,  9 Nov 2026 07:39:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 344076B05DF; Mon,  9 Nov 2026 07:39:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A9E86B05B9
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:39:02 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95687160649
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:39:02 +0000 (UTC)
X-FDA: 85415535324.03.4B946D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id BABE716000A
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:39:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PVi9ExRv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794227941;
	b=A5GV7hcTXR1vitcxQdV2ZwNwMmnhsy5H6E77T0ACzYyuRIQt89iGWEUTCCGPe10h0MfvOE
	8FTBmLptnjktJYnfhbf1a+W61we7/7LtjeJ0MLm63mV4YRtoZKJuy7J7lBAs4CZKFGmND7
	UTelHComGQP2mDPdNJG93X1gtIZPs0w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794227941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7GTC++ZMMrh2UpAsBfysFwhgv6qa+5jYeQOMNhHNDPU=;
	b=Ujotsrk20Px1Za1iAaWyF9W8tuxXnPrgvw1nHCXedjCV7LSAH7pWHn0jH4k7h++mMrq/tW
	N2Jco0jAccNuTt4zTVqz0u4+vWkeBkGPATkJsdPuLtZYMUFUOf1RCUbZLgr1drkve/4tyK
	fewLpHxSewGINszk7zWOh//AEHaj6tM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PVi9ExRv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E4AC942A56;
	Mon,  9 Nov 2026 12:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70431F0089F;
	Mon,  9 Nov 2026 12:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794227939;
	bh=7GTC++ZMMrh2UpAsBfysFwhgv6qa+5jYeQOMNhHNDPU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PVi9ExRvticpORWb6/lrgnxXQNgvHan2XkrmuNoaSfhsTKb3STay5n3vH75W1mtA+
	 CImQUbnr+hZMm9l4iESygtu8k7SPlRxZjFCsarnVozOc6/UNn866lM1fY9zTfhvYf1
	 geLJIS2bFQdWfYnSYwawzmGaeRLjjxWGNw3sF7ysNfZrf3flkzPleBoXwH2x809rgL
	 VGgxXo68syutPo1OtpY1nENuTLZEVNWw39/VpiFoUR9RsZJoQealFXvPgOmm51pir9
	 b7s9UND0Y6dyAj6yXfD5CrxnY3hOJwc9L4q7ha2EW82+AzWRqUK8xuEm9O9zJbSdhs
	 RY0njpqqSLIQA==
Message-ID: <8843ded2-70ed-4b8d-afaa-fcc330725931@kernel.org>
Date: Mon, 9 Nov 2026 13:38:52 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/ksm: fix ksm_exit() deadlock on exec error path
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
 xu.xin@linux.dev, chengming.zhou@linux.dev, liam@infradead.org,
 ljs@kernel.org, vbabka@kernel.org, jannh@google.com, pfalcato@suse.de,
 kees@kernel.org, ziy@nvidia.com, gourry@gourry.net,
 anthony.yznaga@oracle.com, linux-mm@kvack.org
Cc: wangkefeng.wang@huawei.com, sunnanyong@huawei.com
References: <20261106013906.2229780-1-tujinjiang@huawei.com>
 <a712518e-e094-474a-b7c3-bb9723917960@kernel.org>
 <3f2cefd5-837c-4d80-bd80-4590f1684383@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <3f2cefd5-837c-4d80-bd80-4590f1684383@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BABE716000A
X-Rspamd-Server: rspam12
X-Stat-Signature: 9useccosgq6x3hdro9pnpazqcdfcepnc
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794227940-885655
X-HE-Meta: U2FsdGVkX18EWI458bkaxR0hC+M2OXfnEZX6Sosf7OyT75n/MLF2I0ofuaSGtMe/LovoPMchPALDx2vFdWjDg8zgJYh6f6vDYnfNrMayD9h2tXknYTYs2K4iJVpFmwMPk9whBYW968ZPSeXuzDeVAFrwwlkr+jcZaV0zcrntwMJ10lffmP+kd6xBXqfuaLF7b7VnIQe72u7uRz8QzSfhsXer89taldEX5rNWjdtb3Lx67ewwiekVofTXNPLgUAJo85dkOgp4ciTajWqPAdeDOwom4ocNH73nc+I9a3JqDJ0N6iwbmlyQC6kOgz/3hyE/PQr9yPsoS/Y+n1Px5SuaMZQ/5yctR1q2vQj9h5VBSOJIBrEDq5PeEPBT2f5N6wiNJ9IDVX39tWy/U/FAkx6HAu7/lmhE0DuUphx3oo9I3C26X+XMqSUqB0DL+3USKoKYYw+lkcPzEpQpEUaDgZC9vr4grlDV6J8BQqFIDXLpg2duLagRRusxhRPx9nVhwGPhqznFKTVh2ujdRwRJQ4/c43EhdvinxqAN3gchKDD0ex590Gpsfre1ByqOoP+bChD6y4s2ZdZTYORlyriXpnxH391II74mvPfZiWfgAmJVhVIiSvijEFLUar1vTyJZUFxou4osW7brtjoUa6LZFE8Sigzg6w1MLlSV4VBdQxpif3k8cR4ZHTz8XsUP1KpWaPCaJJpIKL+kWjKfxH6B5LxQp2PoX9mUsIWZuFtQsMHQRlz5RZ8kXl6hb3iuy9RwG2ohp95ZZcGMPUbKXRbzwgycY4IVx26y0EsCipcgn8PTrAsaWIM2n9gCBDDRhSEyvu/uKNXoaqOunvnbEAKLrt6d0cyqwTfMsF5/imaRPLEKOzIsQiQ944ZYO/IgK1FFR0qgHH4gPlbT5U3jEvaTLA5HQ/A3yxEROsnbwPsjSE96kZ6lcq3oLD3C0ySdUGMV48pWXo6vF1+p3BY9v4MtH1j
 0/YSZ9q9
 4nvvuWMQMVmo9uU58WiznyX0uCfxQUiAyiDGOk/kv6PCtHtZDiqQ+DrLCdiVDgIJAAtHfmRBSB6Bc9xnFdUmDDPwD8iU5MPE5yy1l4FnBpBAp4r0xutsoABmd70TkDQ2De6m6RLIDjsTkLvErm8d9aVk26LeRYJrmQXh26Y7xGj0NqjPE1sfaxqxWHJdNjGGa7hxfTi3UHoQnT0Sb5Rmikw4NOXozH8JjSzHgCIWBkeETNVGlvr2aelOnjU2Vw9xOIkTsnFraBK+nzogS9RXll2J7vrLnttnDZD3nkcNYYmxmR4qQPVh+Sxz1Bw+lcwYy8B7CzIfXEI5bwDfY2limUqkE244yZzg+JsXMAur0bZe4dAfPJjLFUDr8+dZIVjqbmYBtcp/mYueedkNU9TZX3M30/TcPfKIj/DSGxELK1KuUjZ0Pq8EcPORzfBhvbqePafbE7IDrhbFW4/e60nxGwGe1zQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 02:53, Jinjiang Tu wrote:
> 
> 在 2026/11/8 3:06, David Hildenbrand (Arm) 写道:
>> On 11/6/26 02:39, Jinjiang Tu wrote:
>>> create_init_stack_vma() registers the new mm with ksmd via ksm_execve()
>>> while holding mmap_write_lock(), and calls ksm_exit() before dropping the
>>> lock. When insert_vm_struct() fails, __ksm_exit() takes mmap_write_lock()
>>> again when the mm is ksmd's current scan cursor, leading to deadlock.
>>>
>>> The early registration is no longer needed after commit 590c03ca6a3f
>>> ("mm/ksm: fix exec/fork inheritance support for prctl"). ksm_vma_flags()
>>> calls __ksm_enter() when the first mergeable VMA is created. Remove
>>> ksm_execve() and its stubs.
>> I assume you mean the
>>
>> } else if (mm_slot) {
>>     mmap_write_lock(mm);
>>     mmap_write_unlock(mm);
>> }
>>
>> Can that actually trigger?
>>
>> IOW, can we have an slot, and the slot can already have a mm_slot->rmap_list?
> 
> This doesn't need mm_slot->rmap_list != NULL.
> 
> In __ksm_exit(), if ksm_scan.mm_slot == mm_slot, will lock and unlock mmap rwsem.
> 
> 
>  mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>  if (ksm_scan.mm_slot == mm_slot)
>      goto unlock;
> 
>  ...
> 
> unlock:
>  ...
> 
>  } else if (mm_slot) {
>     mmap_write_lock(mm);
>     mmap_write_unlock(mm);
>  }
> 
> 
> `ksm_scan.mm_slot == mm_slot` means ksmd is currently scanning current's mm_slot.
> After ksm_execve(), current's mm_slot has been added to ksm_mm_head list, and
> ksmd could find the mm_slot in scan_get_next_rmap_item().

Right, nothing stops that from happening. It's all rather unlikely to happen in
practice, but I agree with the fix (and it's an obvious improvement).

I'll pick this up an CC stable.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

