Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27B2C606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 01:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=6APbNeQF
Received: by kanga.kvack.org (Postfix)
	id E6D476B05B8; Sun,  8 Nov 2026 20:53:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1DBE6B05B9; Sun,  8 Nov 2026 20:53:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE5E16B05BA; Sun,  8 Nov 2026 20:53:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B16116B05B8
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:53:32 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4307D1C1F2F
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:53:32 +0000 (UTC)
X-FDA: 85413908664.18.0A00725
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2AE4420005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:53:29 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=6APbNeQF;
	spf=pass (imf31.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794189210;
	b=ZtPvOa3g100LN4ZkfF0mFvgXtte5pxSHXxg7nRO24VKxcrMLugQ87+6XTVnm0GnLXRWhBU
	tUGK5jy7hefnC/odkqSi9AIqXKnMqqw9BPN4+Uhc01rqRQALQvgZmdRu1pSqfO3/BCiAnn
	aDIds0n8aYhFUQCo/t+Di/2ipfT9YZI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=6APbNeQF;
	spf=pass (imf31.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794189210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2nc0cbykH2c/mCQYtXun5pdfE/aQLdbexLHm6tfOEQI=;
	b=7v4xY7kUuOIXWKKmsgHlg5wOmm5qKTaRYl7fa9YbpBv5Ap62Gg5W2XHrg+NBPvrNTmeHoO
	B+Vx1eMhAT4rcdCl/VBsKagvI4hcez8VFv7+ZMzeAfAi0nACXoMw2vmZtU/MpqpKPV/Ysh
	oDzkXUqWWzj3bgx4EA9Lh+x+3eyqSnU=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=2nc0cbykH2c/mCQYtXun5pdfE/aQLdbexLHm6tfOEQI=;
	b=6APbNeQF1wiZEbIjn+DlBpeuY47yu5Y/ioU7l0JYf3WVd6lWzNNb4H/uVq19lsQgabbWnnikY
	kA/QdaAK3nbe33xvDaa20Td3ApEx+6FqBMOC2TLatVtIPGoGsWEXCKyvooEQrj5Ti1hBzd0uF6+
	SNsCdHDPjs0H3eMTT8L1kzM=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4jNCTn3h2yzcbP6;
	Mon,  9 Nov 2026 09:52:45 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id DD6674056E;
	Mon,  9 Nov 2026 09:53:20 +0800 (CST)
Received: from [10.174.178.56] (10.174.178.56) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 9 Nov 2026 09:53:19 +0800
Message-ID: <3f2cefd5-837c-4d80-bd80-4590f1684383@huawei.com>
Date: Mon, 9 Nov 2026 09:53:18 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/ksm: fix ksm_exit() deadlock on exec error path
To: "David Hildenbrand (Arm)" <david@kernel.org>, <akpm@linux-foundation.org>,
	<xu.xin@linux.dev>, <chengming.zhou@linux.dev>, <liam@infradead.org>,
	<ljs@kernel.org>, <vbabka@kernel.org>, <jannh@google.com>,
	<pfalcato@suse.de>, <kees@kernel.org>, <ziy@nvidia.com>, <gourry@gourry.net>,
	<anthony.yznaga@oracle.com>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
References: <20261106013906.2229780-1-tujinjiang@huawei.com>
 <a712518e-e094-474a-b7c3-bb9723917960@kernel.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <a712518e-e094-474a-b7c3-bb9723917960@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Stat-Signature: a4ip8yb9k6djomg4ct7iko3tc5s1garq
X-Rspamd-Queue-Id: 2AE4420005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794189209-70263
X-HE-Meta: U2FsdGVkX1++KdAoE0amFOnvmltleMGJgmiWSdZwpJ7a/TGfMPtGZ4wXGOeOdGtmqsRWjIyTi6SZSjvRXkB9G3Ng6CYvMWfbb5fEvpQbxiiS7JhEaLPFvq5GJUkd4ECOST4mSEKEhJe1k/ILwddfc5Ph7AuY7Jnf1B2KCnzIZyw81Iki+pcYOQVIwXLsst1uEEaEBdPYCVXzRRDRAymb9OoUyTWRyCGfOGDc771BNE00o1OqGRzZM60J6D5ubmufej6Cslsp2b9TUsxijfzFnmJUOLzU0NM04F0ip70cNut6lNZPYkdOmysOQj4yWMHC2Kwmdkdy4TOz/vm3JM1RVrWoYMvMXonTEL678MgNVfKYbzG8U22bQ0M6NiRksvZBOyLvcPHeTyHyQsyh0UC89K82qGQE0RiAhQBLWJd9WqD37iywLFY4FKRUdNdmQ9ufZ04Jnp2FKi6d6es237Po9jNFH+5KOvf8F4Qfdd3DtIkpgQdihQP61CTrMNVFeRMGIrpTRHcojiukZO4lWAXjmHulMdsAXP/31g2oB53lQfhQ9uzDJw2fpQ7zEBrSk7icMU8pURT1QyP5M7haPDk4xsbNtkaI4xUkQjykRWJKlBs4SAIA+1XVITj2R40wJ/5aBmxaUmW3OgOOX02C+iwSorD5IeCz30hopB4UrjPAkOQWTnPXNNSTsb3vzQXOD3FQkMmZPIgXFHjuZeXaLue1wcu+tFvoUDnEx1K17oAcKgacV43qOQmkc8IgSSzvToK/WbdGQPu/vDGGLcorXFl5baPXz/FtQ5RsHVAz4ot1mD6rfSNkMdbu/BoEcJq3ewZlgnoQ6m1WseC1iceZqs+TwlOCcLlA00jEw83kt5uVmzX+/1F/QwUMX6aEs9nG/1n/slgbI0bhEeIAn6AfM02V3ZzMbBqX3AhTslrBMJGDrHMeUkDCPbr5uTANBxBEU0MtoVn5Y9DEEWhIzjQpxwi
 3reeFjIz
 xYDzh43d+ubLKBo77qqt0r2uxl2Ws6Rf7RGmmaup8s5o2+jMf5tcDvIfwfMLgAOW8cMVboThVg414v74txuqq7iVjY9gdNb0sOz9kNUyAzS6+UlmlBZY8a4T/Wf3at2qe++Pbp6FY3spnFl+xXBg3JkbmJCwZieRBIxi5kfnChTm/NmzcbvKrP/9OwkATH/7yICGScAsq+QxHbHW4WaefH09FE7/tyi8AozJJIGq6LJY59m8DPTY8nDi35WXlNnvnhWCG+RYSU91dRgXSgB/+Dgo1aCwB12XrjGlMWZVEuoc/udVHkwmX3Jkjn61N7Wgxu+VZ9xHHsLA3AlZ34ke9EZYpzXOHeNHK9skdd4pwVUTU47c8eUbbTbamN6HEMv/ZVoqBHpCT/v5CQXc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


在 2026/11/8 3:06, David Hildenbrand (Arm) 写道:
> On 11/6/26 02:39, Jinjiang Tu wrote:
>> create_init_stack_vma() registers the new mm with ksmd via ksm_execve()
>> while holding mmap_write_lock(), and calls ksm_exit() before dropping the
>> lock. When insert_vm_struct() fails, __ksm_exit() takes mmap_write_lock()
>> again when the mm is ksmd's current scan cursor, leading to deadlock.
>>
>> The early registration is no longer needed after commit 590c03ca6a3f
>> ("mm/ksm: fix exec/fork inheritance support for prctl"). ksm_vma_flags()
>> calls __ksm_enter() when the first mergeable VMA is created. Remove
>> ksm_execve() and its stubs.
> I assume you mean the
>
> } else if (mm_slot) {
> 	mmap_write_lock(mm);
> 	mmap_write_unlock(mm);
> }
>
> Can that actually trigger?
>
> IOW, can we have an slot, and the slot can already have a mm_slot->rmap_list?

This doesn't need mm_slot->rmap_list != NULL.

In __ksm_exit(), if ksm_scan.mm_slot == mm_slot, will lock and unlock mmap rwsem.


  mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
  if (ksm_scan.mm_slot == mm_slot)
  	goto unlock;

  ...

unlock:
  ...

  } else if (mm_slot) {
	mmap_write_lock(mm);
	mmap_write_unlock(mm);
  }


`ksm_scan.mm_slot == mm_slot` means ksmd is currently scanning current's mm_slot.
After ksm_execve(), current's mm_slot has been added to ksm_mm_head list, and
ksmd could find the mm_slot in scan_get_next_rmap_item().

>

