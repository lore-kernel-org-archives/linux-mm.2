Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3B35CA5FD4
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 12:43:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBEE66B0093; Thu,  1 Oct 2026 08:43:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B70426B0095; Thu,  1 Oct 2026 08:43:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5E8C6B0096; Thu,  1 Oct 2026 08:43:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 860E26B0093
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:43:05 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13159C0267
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 12:43:05 +0000 (UTC)
X-FDA: 85274022330.15.90373B7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id E75E140003
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 12:43:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qjY3z5xS;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790858583;
	b=ZAqme9HozF4IluSuO4jhrsN3Gwrfd/mkU1nbWcjizB0FxejD9lJECUuEX0Fo/MPpKEKOLj
	56+MaDvdI7nQb8n6DBzSZr/k9HbdHfNGTP0zhXeyMbRJJFNVa/qOqDzhkITY+/bSRl+Sdi
	e2MfkTsIm8Wuw7253uWag/fITxNBeHw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qjY3z5xS;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790858583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=meMXLwXbzyJUyptSUM1vgIc7OYDmmePWyviPVaNaans=;
	b=GGwABYOJ2GxDuiAHN+vduxgDBX+8iVlrzOZuEJ2umo2cy58RUJH2tmZ46A5hJhQW6mGGDM
	4vX09zFiSqdPHI8ZfNw5mNSQTswjHwT6NV1qv4IiDLvLn8/KjcECDoMBa8M+rfk56DgR3R
	PXZx9XhDG7IRqS9L2dmmAjhEL/W5emo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 67165497;
	Thu,  1 Oct 2026 05:42:58 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C09393F85F;
	Thu,  1 Oct 2026 05:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790858581; bh=qvewlw/Btz4CWYKXaWo7kc/e0lrDVpSgqkNIen4sfq4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qjY3z5xSIVBzLjhjRFSAaxKTdMPP9C3kr+4Wkak6jqEWyQRyjgcztYf3mpofcS3Ru
	 R1clqJGcAJxIcFoQj8TB6EEfEPlDJy3h4j7P70y0kHvoQdyaKq87Vi5Er6Fwxyl4HI
	 Adiung6RyI60Ndt0Ujgzld7AZQBrqwEQOK7NnZSs=
Message-ID: <59c330ba-211f-46d9-902f-59ca5f0f8120@arm.com>
Date: Thu, 1 Oct 2026 18:12:55 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND 4/9] selftests/mm: mremap_test: correct multiple
 VMA range size
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 John Hubbard <jhubbard@nvidia.com>, Kalesh Singh <kaleshsingh@google.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Park Tae-sun
 <ts930@dgu.ac.kr>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260924050009.19974-1-sarthak.sharma@arm.com>
 <20260924050009.19974-5-sarthak.sharma@arm.com>
 <3d13be9d-a4c9-4123-a047-67371fa4586e@kernel.org>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <3d13be9d-a4c9-4123-a047-67371fa4586e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: znax75a5s7o6fb1k1wj9cg86d6owqhud
X-Rspam-User: 
X-Rspamd-Queue-Id: E75E140003
X-HE-Tag: 1790858582-352950
X-HE-Meta: U2FsdGVkX1/DzEkseWE3pAGLhqlseYnYqE59fcmHx6qvW9bygs1suHyYqrNokl4dhWCnKOM5SUsBbJlQKKhLYfz6yLKM8L9CnNyersl/ZOtp79G7Qqw+WPbeIA7fA+WJ/2IhwsccGkyGyPnXIW2s88iheG18htOMb2RwshVcVhhiVI+vW/J/xZyXJ9qizquFQcQAvmB1q7wLho95GQYxbhvG1BlIS7SxYCG+4yuYUE4DUscodAzWwuoV33J6eH11w5FUAF4SdZM+lN5LV8ZmrygvZVOWXiqUBP3E2t4u8FQz2tslOI5j/tnO3ytx3JUMawFxLm4TGs1xq6OQ0Kaev0gHGVtcT4+S60UXbl9SQJfXizUivTutJcFxrFi9PVb93dB9y17X/0Y9aiPCTLiIrKFzE8Wwasfh6AEXLUDJUfkgh5YbuGWJHtbF6Uo+jisgVa9wZPxq7fstgTNn60V3vd3hDP4I6LkpbfFOsrostwuj/4aWWYowjuif92qcQG9/iDzjFOmvrDfjf/pRyBnECsRgZqgcqcA+qXFnW82TjHEWLdcRFWyDC4OcydisVhp6FIAWzvOv2Ha6d1HRY+tSHakhH2EmqLv4mrDEusc4OaibOtFb9p5Vt/Zl+4NeHCZSa1Op01U7E2PbI7gSNvJhzzuRDc5omVBFBHeObsONBAEGVWLf6uZ1jFNsiLILXU5IfwhBZX1iQRhak7Y+5IGUjY77lfkkaVVTw6RTlKljpmBKFii4JE+qwtsM0Jg8ZX+r28Ux8/XtqMos4hwGGZXS40AeZ5QzGEdTvIv9C1jjRYG0jRGjHurwjQSqm2MM7QRcYrT2yv8QHvF5H9LRL6lDV+qFqG7rzOMiR2yNYi7s0asJKTam38DWrzrbBrQZxWQyuUdkb+l09ocWFqoZkcTEKmurnf0rk9ZIAGRgTGAs+M8OWmYoJgHuDcRu+5cytfZduTY8h+gp8k/p/bEcI82
 JcgLWbGb
 UwnD4x/6TPU+L0gUG38QDmrSWN35L96SfKgL+YSK4r9cVgSTW3gkL7aCBo1uonqNAX39Ak3/zr6uq2DSGQi/nX1h4iPm2U42d2HdLqZCqVYw1gVQPDxW2cGoSFErV5LWXrwJeUIYD2LezDCtGDpN7Ptvi7d4Z2FdbHDkYu57b1HruoWtf2z67/ghij/S77qEVEODpM4KozR0ASL4IN3lFsnc0Bc0mf/KYPHcs/6tEVVmC0igfV1fqYYKm67pIW1me1+A2eZLKW6RPksMekUnxw3FsIKb/amKOXjS8ZmYOmM4zZ2iK4PMl1iwILOpZGXDGdjoLZTRbyRPVEm6w8M73R2+RNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David!

On 10/1/26 5:24 PM, David Hildenbrand (Arm) wrote:
> On 9/24/26 07:00, Sarthak Sharma wrote:
>> In the test mremap_move_multiple_vmas(), pages 4
>> to 6 form a single VMA. But the helper function
>> is_multiple_vma_range_ok() checks pages 4 and 5 as
>> one range and treats page 6 separately.
>>
>> Check all three pages as a single range and skip
>> the page 6 iteration to match the actual VMA layout.
>>
>> Fixes: d53f248258e1 ("tools/testing/selftests: extend mremap_test to test multi-VMA mremap")
>> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
>> ---
>>  tools/testing/selftests/mm/mremap_test.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
>> index ba9b7f7566d0..869df22d46db 100644
>> --- a/tools/testing/selftests/mm/mremap_test.c
>> +++ b/tools/testing/selftests/mm/mremap_test.c
>> @@ -373,7 +373,10 @@ static bool is_multiple_vma_range_ok(unsigned int pattern_seed,
>>  	for (i = 0; i <= 10; i += 2) {
>>  		int j;
>>  		char *buf = &ptr[i * page_size];
>> -		size_t size = i == 4 ? 2 * page_size : page_size;
>> +		size_t size = i == 4 ? 3 * page_size : page_size;
>> +
>> +		if (i == 6)
>> +			continue;
>>  
>>  		for (j = 0; j < size; j++) {
>>  			char chr = rand();
> 
> What is the impact of this that it warrants a Fixes? Will the test fail?

I read through this again, and realized it is just populating and
validating parts of one VMA in two iterations, which is not wrong, just
a bit odd since others VMAs were being validated in one go. I think I'd
gotten confused with the layout and pictured something else :).

So you're right, this doesn't require a Fixes tag. Infact I think I'll
drop this patch altogether since it is validating stuff correctly.


