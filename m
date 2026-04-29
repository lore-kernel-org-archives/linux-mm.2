Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28192FF886F
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 03:09:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5021C6B00A0; Tue, 28 Apr 2026 23:09:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D7EA6B00A1; Tue, 28 Apr 2026 23:09:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EF7C6B00A2; Tue, 28 Apr 2026 23:09:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2A8486B00A0
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:09:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C7498A048D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 03:09:00 +0000 (UTC)
X-FDA: 84710111640.09.51B153E
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6B794A0002
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 03:08:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=wRZEtqG1;
	spf=pass (imf25.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777432138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xX0viIPInKzZ41oL478Oobdtorp+A0qdchKgB4MiC+Q=;
	b=Cs+K7UEDRRJkC051YBXiY464MN7SLBPHltSoOJLHEr6nn1sStGhuVIWgVaR6Ui5WCNC+a6
	c7Ky1TPeNdxzNH3RNldN0zK0O1ekPyO+XqyRxhS2TpEUMkQRLKP2TRjhKh+8o9aURYgsQG
	GevMlLjjvyTlOdOautUUrWqbkbMDfAU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=wRZEtqG1;
	spf=pass (imf25.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777432138; a=rsa-sha256;
	cv=none;
	b=LQcBrCoJx6zOxyToeU5iKz8tQhDQgLDC+fmELa6On6uCoglYYaComw7tcWtKEz248zaJfz
	3Fm82At/rgmr0q5RZGILMpF1B3cMRMOd8M0k0xk+KPlL6q0dgpYrVWwCSN3/VzAjqnxdyp
	mzG53ScTYum0xGUJk+Js603RINcoWH0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=xX0viIPInKzZ41oL478Oobdtorp+A0qdchKgB4MiC+Q=;
	b=wRZEtqG1ojzHisLsXlxwRdn5+Jd5rHXE0MjAblypteB/4bP6N7dY8K21sfS5P7ly81FOyw/br
	+XvZYTvTsjMIkOWPKa2WMJGGARA4Rrs1RTZvJr0EnSiuUngmfpopv1U5etxTXFX5Ufm5QwPFXdA
	iwWjvTtUImaOvMTxi+2vwng=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4g52C92vVHzcZxk;
	Wed, 29 Apr 2026 11:01:57 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 95FDD4048F;
	Wed, 29 Apr 2026 11:08:52 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 29 Apr 2026 11:08:52 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 29 Apr 2026 11:08:51 +0800
Subject: Re: [PATCH v2 3/3] drivers/base/memory: fix locking for poison
 accounting lookup
To: Muchun Song <muchun.song@linux.dev>
CC: Muchun Song <songmuchun@bytedance.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Ying Huang <huang.ying.caritas@gmail.com>, "Dan
 Williams" <djbw@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
	<linux-mm@kvack.org>, <linux-cxl@vger.kernel.org>,
	<driver-core@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>, David Hildenbrand <david@kernel.org>, "Oscar
 Salvador" <osalvador@suse.de>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Rafael J Wysocki <rafael@kernel.org>, "Danilo
 Krummrich" <dakr@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
References: <94F5B89A-008A-4EDB-920F-31B4895C2699@linux.dev>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <c6e1df1e-be5e-2468-d46e-453985ba1e79@huawei.com>
Date: Wed, 29 Apr 2026 11:08:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <94F5B89A-008A-4EDB-920F-31B4895C2699@linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6B794A0002
X-Stat-Signature: ygd1swih4x998gy83yehepccczh7bfjd
X-HE-Tag: 1777432137-717628
X-HE-Meta: U2FsdGVkX1/X/MKgCOC317ghbB3gjCD/GyNMfyJeY6NHS3F6vrILt74cW7TjLd2xuZFnfaEfUa19X5GlsyAEVx6zGyvrHb+aYBQmvQadhhrS3Qjrk92Y8XRRjMZcXFcgJNgwyX35PC1S5GcN853DdcchzB/Nc7X8NCYl1qYU6yh2c7trFCRLIV/8pgVRbcgEPluABgLpHasfMV8JJWTfOugcSA/s6YmjTuzuf7/Ao3oaP/95SI5igKZ4i6EA/1zzD89Q7m3CIyW06iBv4N7HVCy5F9sAmaajr5WkYjLJm2QA0fyJAyuToRvDw0Davy96/aJsYJggAgY8PRKfOsxim8LFKv8jmBFU0bEMzb3pAmwwtSPM97Dv9py2XamvBBWOJNkH3wm34IRjP4zrjTqGE06YKZ/cx+KnzVUzbcLyneSAutkQLyLw+USKbgewVelu+0wolmWqook6jrtfdSTRcFJMaQN0tKBKLpFL6Y2E88kQiQJupU0R1RJBTcbybJMExE8QeTQ1KFREzuTg69bauMcLGfAb+cDdPMWGV2Y0VgYS4IkyXyXOqvdCDjLbmRAXJfqcf5OlA4hCPG/WtIhgRE38ZAdgPHeyau1i/iOmhBoPOVHGABrplC0nsi0VjVuwz+SB3J9lFchKuQNnGRO9xJi+klMXQ8JtdWxb3NiGugmC46CMCz6XAvE+NkI9N1fShWtOzdw5jvmkoblD2HkJKYCnmGSjqTKZrk2y1WqlDCSNPlyKG8Vu5OqTffXRRHATP2Hz9k3yns5wujgXaofLR6EvSi8Bvxf5GCodiBUgr7fip99AS09RtLh5GQZLa7JLDjhKkb1h2vjRZ4K6lk/LFTrJSiwoI3zrY5RG6Du6oykNq9EtdIee+6pxqH6j6J2fJtRaDuEReMV8zEozll1ds1/Qs4lTeHH8cA2UtBdKLab4ysJEaDITwndVEgQpy6iRGm1qOnbrD+jmrGFxez4
 iSDgDxEQ
 ELDXMN31tyCEsKoKmYWTuMM0ia6DknlNXLZyfSFhbAZe7kuIMGpetHdKhmyRuW8DuimpNWq+b6wFHTjKzjq0Yjc49nzZRFB3i/1pv+GlE+/7R2plwBUf9vAa5XBXmjvifqSAMpmPIkRLbKfrQqoQeHqZMP10hsiJ1biabf7JsCBFxm9eF0jZTtgjXYepvLXVFFoogLhF0+VRdZDoHFkOL8cHVNUldW3iAz2Tt/hTy4eqVXZZpU5ydl9Ov1Y5nSH1G38xPNiTIjd/2PipDUgtg62/n5iXlwEAqH+4IRMEqPE/mwESD7ddWp+ko8MQ66VFpGlLkeleeWktryvxy2uetxRnkKYjuii+aqne49PrtZBykijc7+Nt2/QLOPZ9rHmjExD+PzgYbLwa94U86Cv5SGVBLaNtPzM0gJy8bEwNC+BBSkgJriAzpX16XCqmpl6eYaZ8G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/4/28 21:52, Muchun Song wrote:
> 
> 
> 
>> On Apr 28, 2026, at 20:34, Miaohe Lin <linmiaohe@huawei.com> wrote:
>> ﻿On 2026/4/28 19:40, Muchun Song wrote:
>>>
>>>
>>>> On Apr 28, 2026, at 19:37, Miaohe Lin <linmiaohe@huawei.com> wrote:
>>>> On 2026/4/28 16:52, Muchun Song wrote:
>>>>> memblk_nr_poison_inc() and memblk_nr_poison_sub() call
>>>>> find_memory_block_by_id(), which requires device_hotplug_lock to
>>>>> serialize the xarray lookup against memory block removal.
>>>>> Take device_hotplug_lock around the lookup and nr_hwpoison update so
>>>>> the memory block cannot disappear between xa_load() and get_device().
>>>>> Fixes: 5033091de814 ("mm/hwpoison: introduce per-memory_block hwpoison counter")
>>>>> Cc: stable@vger.kernel.org
>>>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>>> Thanks for update.
>>>>> ---
>>>>> drivers/base/memory.c | 10 ++++++++--
>>>>> 1 file changed, 8 insertions(+), 2 deletions(-)
>>>>> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
>>>>> index 6981b55d582a..f76aee29e9a5 100644
>>>>> --- a/drivers/base/memory.c
>>>>> +++ b/drivers/base/memory.c
>>>>> @@ -1228,23 +1228,29 @@ int walk_dynamic_memory_groups(int nid, walk_memory_groups_func_t func,
>>>>> void memblk_nr_poison_inc(unsigned long pfn)
>>>>> {
>>>>>    const unsigned long block_id = pfn_to_block_id(pfn);
>>>>> -    struct memory_block *mem = find_memory_block_by_id(block_id);
>>>>> +    struct memory_block *mem;
>>>>> +    lock_device_hotplug();
>>>> memblk_nr_poison_inc() and memblk_nr_poison_sub() are both called from memory_failure() context.
>>>> I'm afraid if memory_failure() is triggered while lock_device_hotplug is held, it will lead to
>>>> deadlock. Or am I miss something?
>>>
>>> I am curious is there any place where memory_failure() is called with holding lock_device_hotplug?
>>
>> Sorry for dumb scenario, I was a bit too presumptuous. But there might be another possible deadlock:
>>
>> remove_memory
>>  lock_device_hotplug <-- first called here
>>  try_remove_memory
>>    remove_memory_block_devices
>>      num_poisoned_pages_sub
> 
> Passing pfn = -1 here.
> 
>>        memblk_nr_poison_sub
>>          lock_device_hotplug <-- deadlock here
> 
> No. Can’t reach here. No deadlock.

Right, I missed that. Thanks. But I'm still worried that there might be potential issues.
For example, this function could be called while lock_page is held. Acquiring lock_device_hotplug
while already holding lock_page might cause problems, though I haven't seen any specific issues yet.
Also there might be some other potential scenarios that haven't been considered. Hope I'm just
overthinking it. :)

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

