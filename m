Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B90F6C55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 13:32:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4AB36B008A; Wed,  5 Aug 2026 09:31:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A23346B0092; Wed,  5 Aug 2026 09:31:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9395C6B0093; Wed,  5 Aug 2026 09:31:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 744546B008A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:31:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 06A89A1C3D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 13:31:59 +0000 (UTC)
X-FDA: 85067303958.19.EA361DA
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8AD6B1C0013
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 13:31:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Podj7j9c;
	spf=pass (imf18.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785936717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7QagduqF5182alHHDuFrUaadeLMizdoc4XqlrHexKCg=;
	b=g+ranuw6KtaJ0CtUxUHIGZpkQJ8ScQUccZL8TQki4iB5JFqmhw1mraQZPddmAQhM2dJSVi
	DR+s/hxexhVUg/G64AsPpIiP2BO0BkAt8Lr94RCkMkoxr0GtA4U3CmLyF6eFi3uefsyx/m
	TVYXN5gvvO23vAbVl4AND6ONVZjKgNE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Podj7j9c;
	spf=pass (imf18.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785936717;
	b=Mau67M7bKQyZB3InejS+38r6IYaZ2n3LAByshjQl3jtzg0J2rxZCCPuB90axlYy1gmVxeg
	lwKnhxmRNlORv4UCim9/DwhLTohhPSdLMnpFqfth3Kb/Wkj3TeQ37OYZbp2dY/i7D/28S6
	SpxO68mDSmRTAAKjTDSGapt1ToopnrY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=7QagduqF5182alHHDuFrUaadeLMizdoc4XqlrHexKCg=;
	b=Podj7j9c9hiK214Fe4IvF4hi3KTKqC0gmfCuPQ94Y96RvmIuKN1hCjAUM6ULPT
	/0aRK+lo/4FYWe6gX4jhWWZk5m4spnAzjqULAg3b0M0bsKwGCgr5DwI3UWabuIAw
	AOm/Z/V7q52w2Tc3mKZlHHOqGp425nGYw1p2hcHJW8CZE=
Received: from [198.18.0.1] (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wD3VOw7O3NqLh7VNQ--.53449S2;
	Wed, 05 Aug 2026 21:31:40 +0800 (CST)
Message-ID: <5a0679b0-1133-4640-8a24-f5537308a03a@163.com>
Date: Wed, 5 Aug 2026 21:31:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/ksm: avoid missing ksmd wakeups in ksm_enter
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
 hugh.dickins@tiscali.co.uk, ieidus@redhat.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Longlong Xia <xialonglong@kylinos.cn>
References: <20260803152115.3479919-1-xialonglong2025@163.com>
 <6bb83027-07fb-4152-8edd-f349e6fbcc42@kernel.org>
From: Longlong Xia <xialonglong2025@163.com>
In-Reply-To: <6bb83027-07fb-4152-8edd-f349e6fbcc42@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3VOw7O3NqLh7VNQ--.53449S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ArWxuF43KFWDGw43Kr1fCrg_yoW8Cw1xpa
	1jkayj9r4kZr1Igw17Kr4UAr9Iq398Kr48Gw4Fyas8Zr9xtw40gF45tr1jk34Y9rs2vanx
	ta1Yva9rZFyqvaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UeOJOUUUUU=
X-Originating-IP: [240e:46c:1000:421:34db:efe:597b:d439]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC+BxVTmpzOzxLfQAA3X
X-Stat-Signature: s3ddo349jua3xxzydaj6ymxx1r4fa3s6
X-Rspamd-Queue-Id: 8AD6B1C0013
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785936711-518600
X-HE-Meta: U2FsdGVkX18eBAC9qkouwjSI7chNHlhH4SWbmTj2++ZdsauIM2+2Dki2U4hh/XAmQWoXeFPGZQ/irpMULDVqQI8dxBljqvi6uWl9fC5UFJffxQyF0kodbJea+wvXB1HnPQqVZYwOKNZLQ6ONJdaUQxxI7HX7gY+VqCm1hZ2STejboUMoT7OgbF40EZ3OSMrVxioJGhjwkgskZa3CUNwzP3qhrVAr/j8WFqq+wmTVR+oEdVvoF5/VO0aCqt/GrWz7esI7JSt2h30+tGPdbGFnftzNIDiVjdYUnxVeEnUC/TiF3TjHuFw6xfv14ifVeESS5J7cFKY2e4Dsla2Oza8WxwluFN7xqmXrI9AvYNFvVOlJIA2/GfatbFxrCXEHTQzSYOm75HlKkaNY8fL19TJBrwf5uv9AI+YhFouLoZjsmRzNRgWIAyZlxX5LFvaxunE6Ixmg7hcvGSP5qiD/AkC51WCjQlalqKwsf8Rb6erzivhKqP/VlylUiwaRujyXc3lFwZe66VjHFOiSBxXmwRxjn+JTD/GxIjVhzL736g/WPGPWEsT3t5Uv7J0DNDPfEJJ/WhoJnLrNXzc949vTK4PpitKZld701aCEq2nz5v9xR+UJt6s1Dn/BOIzK+0BMqKUeTNd9Y3HvgKrNJ4nquuVo4j8pcx00G8JkR9tGa8g53wYbntLnNkyFMVzrxFsHfj8u792FpYb5IlKumy1tVJpdDw8uJGBl3TEquy6qdgwzJcV1QAHo+2T2TeRsnXfW/ofLOoqlywA+fLAz3oYMxs63kN+uFlIel4v5MjwOV60+iopkVrvr2aH3CC0jEho67GoUQjuGZEw7ApjEqS2I5tzA6X8b5Pnh97mrWPderShOV1khgJAEHVC8GiBBCQ4EdXj4sPHyTKSVq5NDDly+68AUUYg62KI8n6NUCBZ8kbl07BE9RtrpaOlgJNmJm0pv8MsS+jHzvsRglrUtqmELp3v
 AzIYBuHA
 9DObYfXQ7Z/0fvap14q36FByjztBFrlAfkoX0qzSd9Q8S2eQEILIyzZuaHd8f8jfX2wbrPRAs5lJv7YzUAyheVIePXDnl2ZiDA6/uRx3IqrzsGPojr+9h9IRGISY9/XXt6XnM2uNSbAUC5n8JozN4I4yPwMBeyXgi5j4S2vgnZPQpQuxzffWZYCats7y2S0im4F2XyPgB9WZm+UrJcAEs8OCvPlIRj7s+GYPPFE1weTtTQpHdxUucp9lJ4MLqKlbVuFyePbRWoq/jEQnMVwqYMQie6kiUw9TusBbxn16o5kSddYPzfDbULZRhOPiy7FiqZIeW4M9x/pV8h4pKEeLDuO2tkxZZeksmWeTOoEZON2UymKOf8rpZfxpgoVyzDcnS8zBpCPmiXEMT5EpNA3yyAIq3iqm3DWmGxEszTYtiGHl/YlxEl9Cx1gTeH1p5uaW8nlakIj72SGWhhLg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/8/5 20:26, David Hildenbrand (Arm) 写道:
> On 8/3/26 17:21, Longlong Xia wrote:
>> From: Longlong Xia <xialonglong@kylinos.cn>
>>
>> __ksm_enter() decides whether ksmd needs a wakeup by checking if the
>> mm slot list is empty before inserting the new slot.
>>
>> The empty check is currently outside ksm_mmlist_lock.  Another CPU can
>> remove the last slot and let ksmd go back to sleep after the unlocked
>> check, while this CPU inserts a new slot and skips the wakeup based on
>> the stale result.
>>
>> Take ksm_mmlist_lock before checking the list so the empty-to-nonempty
>> transition and the insertion are observed as one critical section.
>>
>> Fixes: 6e15838425ac ("ksm: keep quiet while list empty")
>> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
>> ---
>>   mm/ksm.c | 5 ++---
>>   1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/ksm.c b/mm/ksm.c
>> index 7d5b76478f0b..3f2f4707ca9e 100644
>> --- a/mm/ksm.c
>> +++ b/mm/ksm.c
>> @@ -3019,7 +3019,7 @@ int __ksm_enter(struct mm_struct *mm)
>>   {
>>   	struct ksm_mm_slot *mm_slot;
>>   	struct mm_slot *slot;
>> -	int needs_wakeup;
>> +	bool needs_wakeup;
> Unrelated change that should not be included here.
>
>>   
>>   	mm_slot = mm_slot_alloc(mm_slot_cache);
>>   	if (!mm_slot)
>> @@ -3027,10 +3027,9 @@ int __ksm_enter(struct mm_struct *mm)
>>   
>>   	slot = &mm_slot->slot;
>>   
>> +	spin_lock(&ksm_mmlist_lock);
>>   	/* Check ksm_run too?  Would need tighter locking */
>>   	needs_wakeup = list_empty(&ksm_mm_head.slot.mm_node);
>> -
>> -	spin_lock(&ksm_mmlist_lock);
>>   	mm_slot_insert(mm_slots_hash, mm, slot);
>>   	/*
>>   	 * When KSM_RUN_MERGE (or KSM_RUN_STOP),
>
> Makes sense to me. With the above variable change removed:
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>


   Thanks for the review.  I will keep `needs_wakeup` as an `int` and send
   v2 with your Acked-by.

   Best regards,
   Longlong


