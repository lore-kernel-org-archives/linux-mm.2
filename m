Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 455EBC9830D
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 03:41:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CE086B0088; Wed, 23 Sep 2026 23:41:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07EDD6B008A; Wed, 23 Sep 2026 23:41:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAFA26B008C; Wed, 23 Sep 2026 23:41:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BFA836B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:41:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0CA9FC01EF
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:41:01 +0000 (UTC)
X-FDA: 85247254722.14.DFB0544
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3839F40002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:40:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790221258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EvlevEr4nSJx6drlOKSXiu8kTax7X30sHgDZ/znceM4=;
	b=yO2tPhVREXPgZuwYuQME2Xk847LXq8ZrdTvfzuJmCbKXqRwbblymCa/72Yy7CXlUEqverE
	mvCj8HOyEBgsVBHwr9+Hyqw8AJnazisHbXbc0Ea5Ueg7IR28kgxTRDm8DnSUvoQlkef8hP
	zC5D/KgqtUiZ3ZPk2a1of9whNveMijE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790221258;
	b=wdvYC9iqzOCP/JEWWRr6c8WZ46klOQ8RowggyAnftbrLDG7LB3YBLiOAXvC5Kz+G5G7dxU
	7PH4O802JsGH480meUhp90mrB7YjoIsMFPx8Ygu9TJ5bR5n3+jnfG2hU4vCs85/MB6J6iJ
	nRioMdGThOsnkoTBAlX/qE7b4sbLNr0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4hr03n4DKpz8XrrJ;
	Thu, 24 Sep 2026 11:40:53 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 68O3ekJR063160;
	Thu, 24 Sep 2026 11:40:46 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 24 Sep 2026 11:40:48 +0800 (CST)
X-Zmail-TransId: 2afb6ab49bc0afc-d0621
X-Mailer: Zmail v1.0
Message-ID: <202609241140480776ICmMIKoP7Sa8CiYKlmUF@zte.com.cn>
In-Reply-To: <fd88104a-982a-4c73-9a5f-8c67ded3d5ca@huawei.com>
References: 20260913121716693wiN5osmShywgtitghSm7G@zte.com.cn,a19a0c1d-d2bf-4c40-9308-e815f925f87a@huawei.com,fd88104a-982a-4c73-9a5f-8c67ded3d5ca@huawei.com
Date: Thu, 24 Sep 2026 11:40:48 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <tujinjiang@huawei.com>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <liam@infradead.org>,
        <surenb@google.com>, <rppt@kernel.org>, <ziy@nvidia.com>,
        <baolin.wang@linux.alibaba.com>, <nico.pache@linux.dev>,
        <dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
        <chengming.zhou@linux.dev>, <usama.arif@linux.dev>,
        <gourry@gourry.net>, <harry@kernel.org>, <vbabka@kernel.org>,
        <peterz@infradead.org>, <borntraeger@linux.ibm.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCAwLzRdIG1tL2tzbTogdXNlIHBlci1WTUEgbG9ja2luZyBmb3IgZmluZF9tZXJnZWFibGVfdm1hKCk=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 68O3ekJR063160
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Thu, 24 Sep 2026 11:40:53 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AB49BC5.000/4hr03n4DKpz8XrrJ
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3839F40002
X-Stat-Signature: nrnin3cbmdwjhsb5a56h6ne38mqpj5h1
X-Rspam-User: 
X-HE-Tag: 1790221258-465196
X-HE-Meta: U2FsdGVkX18awDOWdLtfH3+Yt8Gt8vNcUqVh1duPh9Zm1ge08bfFQULHV0CK7w1bBphqaFv98Py3BMC5tH/vUtzgTnn28Yd8RS2Qye807G+buUwvczAMVV5TfB4xBxvios2ldwk3x4gVNgEHWkmN1CY6VE2Mr7vDdbryFJYZ+vPQShZybv02wXWv0DbFpaTgZMbM3waGThnnzXUaMW+rcktBw/GRvh9eibLyjdU2KFNN15sE07cuE9AnUKnZZO0AKYeFJuyjoRZ3g8yzTrJtSNdEJLRmvMgjJOE5ctFeYsDvalcQ004dLORPNSoraQD00lsc/WcBkPZgrd5QYFY/sZvkjKbNDAIHhJAZa6kkdUJ2Qn9siVXDaxg631X8AB2eFQ6+4UdFFY4Vz0GT/U9L7u78Zg4/UbFU/QhONaqg3+hiuNglbulBKWu5idkV6/PuUGv/YMdPuT8FXzn8//kUsx2ycN2SmBa6cCtvNQbeuK5HRfIEPZKkqGWq1C5IxpEiIhGFryu3BXx1WeoVoEa4y3WxDXFCn4ZrQwEQK9b3i0OxqEaFnNkvITDY6YqmUEKT5hFtKPulw6vS5Nbcw3l8OK2Jx2Id5pwXJsHJf5dRELSeYfNtBl3X1kVXdQKicjNv2irI9vp5C1xAwyXbza4R/DD+YNe7Lj2uL9bOx2MH0v9NHjTSfdQ0lsN3sSypT/VCdBM/wZttyb0mNPG7awDW0E+OQ7LMWoqhPVJnDvHQ4z0h3mAKrjgJFQkUvNZwDjfI3I+u8yKipb5U7q8XiJ2TguPx7eR3Xo0keWpzNpGprLHTXteceEd1FRFzvXjhej0rWGBl93YjXJi7ixc0Gc/H+WNKbIZrpiBsvTkibT1/XU1OY2Ef7K417C8ouK5c+MKF4cDJyXuM45ITaZ1n2tGL/2oW2hJYE/JdQYqE1EdOABQPQHcRaYhx6I6zBcGGDDAlG9l1K8XpdCyHoq4b6pC
 //cXVkSE
 RL9zZPZrALwaP0HaJsrNuNrTn1gzuuGPjG3p/cjEL/Xpl/KZvmALsLJ6kWAm6iEaEEi996kH8NkBlLcqqRrJ6T2GGpHYaDLZUOsvSKJnQvG258N9O7Z24B4HRpT34D23rNClD7/wJBvDWrdDkFwVnJd88ZDxG6MWCTLbUtoTgY5S1u0XDom31XYKPVA4C/KaJmDDYXuX/+Nn0cTA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>> A possible approach to restore the necessary guarantee is to pin 
>>> mm_users while
>>> ksmd is walking the page tables:
>>>
>>> Before scanning a given mm, try to take a reference with 
>>> mmget_not_zero(mm).
>>> If it fails, the mm is exiting, so we skip it.
>>>
>>> Hold that reference for the entire duration of scanning that mm (not 
>>> per-VMA),
>>> and drop it with mmput() when done.
>>>
>>> On the fallback path where we need to acquire mmap_read_lock(), drop 
>>> the mm_users
>>> reference before waiting, to avoid delaying an exiting mm.
>>
>> We should avoid holding mm_users ref too long. Otherwise, when the 
>> task being scanned
>> by ksmd is OOM-skilled, even though the victim task has responsed 
>> SIGKILL signal and
>> exited, the mmaps aren't released due to mm_user > 0.
>
>In this case, we have to relying on OOM reaper to work. But it need to wait OOM_REAPER_DELAY
>(2s) to response.

It shouldn't be too long if holding mm_users only during ksmd accesses mm's pagetable.
Essentially, the delayed time of releasing mmap has no difference to the original approach by
mmap_write_lock.

Or If we want to keep the code simpler, we can consider the other way to keep serialization
and synchronization between __ksm_exit() and ksmd thread, that is: Adding vma_start_write()
for each vma? like:

diff --git a/mm/ksm.c b/mm/ksm.c
index 624f37975e12..1f11646bb00d 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3129,6 +3129,10 @@ void __ksm_exit(struct mm_struct *mm)
                mmdrop(mm);
        } else if (mm_slot) {
                mmap_write_lock(mm);
+               VMA_ITERATOR(vmi, mm, 0);
+               for_each_vma(vmi, vma)
+                       vma_start_write(vma);
+
                mmap_write_unlock(mm);
        }

