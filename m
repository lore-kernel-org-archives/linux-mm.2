Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5245FCA5FAB
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 00:27:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4266F6B008C; Mon, 28 Sep 2026 20:27:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FDE66B0092; Mon, 28 Sep 2026 20:27:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33B8F6B0093; Mon, 28 Sep 2026 20:27:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 12FDC6B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 20:27:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 95D231C293D
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 00:27:19 +0000 (UTC)
X-FDA: 85264910598.24.5BB6214
Received: from mta1.migadu.com (out-207.mta1.migadu.com [95.215.58.207])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2E03F180002
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 00:27:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="M4U/OkMI";
	spf=pass (imf16.hostedemail.com: domain of ruirui.yang@linux.dev designates 95.215.58.207 as permitted sender) smtp.mailfrom=ruirui.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790641637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/y7v+SCp59Xm7LWoMBFV6n7GtotDVpeBZst7IFV6LyY=;
	b=uD1Aci7Wuq199gvtikLCyB5dy1AACBpiTos4VL7gl90xpteGuZ1XO/jmso/59rA5LgKSpV
	5nV8XFVzn/v0ESkRv9edhBZEuFvZonSN5OROdAeGTJhySnLBKtMJHOTaygpDH0uiwl42/t
	dTpuSwtxkyEJOKNvWMlCFvXMzkIrrZE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="M4U/OkMI";
	spf=pass (imf16.hostedemail.com: domain of ruirui.yang@linux.dev designates 95.215.58.207 as permitted sender) smtp.mailfrom=ruirui.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790641637;
	b=l58WlA9oot3sAmDH2SN3NUOoYVK86zcUJIVIYYtSBGlnkruPQ12nYMVogh8qXq10o/T8Tj
	BbHBoKYcY3DEJ6eORj1Wi8FwlBaq6lY0840tuYLUKKKZ/ouaYdhMBt4nVgXL0IjCokwfSf
	QhvoGXt0OFIkL3QIlsYHF18e+XvMyCY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=bpMYWBp/sPJNiQHEYw1MOd5uAxCLyuUtVHzuC15+pHA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790641635; v=1; x=1791246435;
 b=M4U/OkMI2b8ylZ9gZAaoGSa5muprJ8ikog70F9ltHHBXhn1lBPHHEJ7gNE6p8zeqyvBu2qMY
 1yKuI5FCX9A1NPlDHOuCRVNgP95FGdwyPf8sb6WmMpHcCOlnQhihnbBX3hCbThtkCoEV9wTqObp
 9wJYL3/DP4qInZw4hpT2Vs68=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 27dc7108c083eaec;
	Tue, 29 Sep 2026 00:27:15 +0000
X-Mizu-Trace-ID: 27dc7108c083eaec
X-Migadu-Flow: FLOW_OUT
Message-ID: <a13c01e1-def0-4aa5-b54f-18e523082b29@linux.dev>
Date: Tue, 29 Sep 2026 08:25:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vmcoreinfo: export SECTION_HAS_MEM_MAP
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Baoquan He
 <baoquan.he@linux.dev>, David Carlier <devnexen@gmail.com>,
 Tao Liu <ltao@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kexec@lists.infradead.org
References: <20260928-section_has_mem_map-v1-1-4129f6ba2838@kernel.org>
 <9c47dad9-2716-4ae0-b6e2-9e6b5c718859@linux.dev>
 <4a57b255-cb38-4e8e-908b-d32e55a1a326@kernel.org>
Content-Language: en-US, en-GB
From: Dave Young <ruirui.yang@linux.dev>
In-Reply-To: <4a57b255-cb38-4e8e-908b-d32e55a1a326@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: c7ugeo1oesuehzb15pqbpuhbakegyrf5
X-Rspamd-Queue-Id: 2E03F180002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790641636-533745
X-HE-Meta: U2FsdGVkX1+SZlwqDrLLmwBvcH/FKWZelc3wQPlCNPtnv8A1QepKeFbUN4H5TGK3tSOjY5eS46fciC+2IU5dGaKDYlHckq+tWOhcaYET8z6g87nH6eexW8ZEx7DhgUvHz4+AtwVAYpp5Bh+pSBUw/H4ZIr5zOFfOWRMK131LWff6bTvQ8d9UB8fvqY2CvxiO5jYc0nqLKWGLxamIhjx5Uft22iYAN22UvWkbpZOvrRB/PhpFCai87W6TeHUmZM9v4B593oLPTfAwIS/lkdGoKIQNlCt+wzMwk90h+WbzPFcoqF6ysmacYPd2GMgGnnQ15kd8BK7DZ9jiGcjcDV+c1NS+NUvvLaql8yZ8RftlJ3j90ncfWOHMRO+hfY/TgBBXWnwon+5pHVjbCMh9Gka9KkepXr29WASmwDv3HbO2Sr004Mru9hzukj8epyRuxOYbU4RvbGnWeuKM3BEc8krCjf4RPWe323HwvoXWmoCzaFMnc7HeZnRGvl1IF+hie0KuCMA9AOwqApnfjkb3X6CTBvLeb3Jd1LgVxsV8MyjPtqjIC4inbZxMFHFtddn5z5nNGCwcfcQ4k9CC0yvpQ0g4q2vVDegakFr3knRyCVDYeQ+QbzT4BnwdcC90SWZ8xctWaONwODpdrLFKK7FJZd92KANhO44w8H9TxrpANNH0qHKQV3lM51FHGGvs6D5oI1X7jOn4VtjHo1dF0rRAOXhQL4VTS4PomPm7cs1JL8ihDO4brDk6avy27kyRt4ShHG3fnwxDerd7VeaX8FDr+yVXzUsu3O5cl3xkg/k6KkJWK9jXQMYDAxjhBd58mNLvaLz3qcfLZ+onuEwiP2D+gAXSTp50IqcKrvpe0Nk9lsDqkdanN+gio4etMqjbpITc9RLOigNJ/4pV4DordjoHNJaN5dekp96L/k+i1mZYmDj9j6J1ng2zlYNVjTNHb2YR8dLhr0LVqhjSCVchPEZqwWW
 t5ZYqiT+
 Nm/+hsdnH8UDEaTCMdAjW2iy7zWXms0apVke++wVhoz8ISw/InOSzAwio+2VvECQQbi8c6cOnnRSw3E/7XbcE4LJP3GfYdqmyLFjj0GqJxTxBt7z9Qj+h+N4mAj2O0kybfZXvZkYhuXfFPSoq+itXhXwoPMA0KTfPjC9O5vgiOgd1OVmsSn++KfCDOgJJwkVmb82O/dVAI2y0ukgeN4GmZY0FCcrVgD3oq4ldPio28E4vj4sNs0dbuWXO317hPoWShpcUZP9fcQGDfZTyV3y1BU4zvj5hZdjfcy71CFBFRpkmsB7gO3i3rQPsetnFLRMpp9crCSdJzZj/doeVwpUMXaXCmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/28/26 7:42 PM, David Hildenbrand (Arm) wrote:
> On 9/28/26 12:23, Dave Young wrote:
>> On 9/28/26 4:48 PM, David Hildenbrand (Arm) wrote:
>>> The crash tool currently hardcodes SECTION_HAS_MEM_MAP, and makedumpfile
>>> needs similar information (although still relying on
>>> SECTION_MARKED_PRESENT, it should switch to SECTION_HAS_MEM_MAP).
>>>
>>> Let's just export the value instead, so tools that work on vmcoreinfo
>>> will not have to guess.
>>>
>>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>>> ---
>>> Result of the discussion in reply to "[PATCH v2 00/13] mm/sparse: remove
>>> SECTION_MARKED_PRESENT and further cleanups" [1]
>>>
>>> This patch can go in independently. It would be preferable if both
>>> go into the same kernel release ;)
>>>
>>> [1] https://lore.kernel.org/r/20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org 
>>> ---
>>>  kernel/vmcore_info.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/kernel/vmcore_info.c b/kernel/vmcore_info.c
>>> index 5a417f8a922a..7833a36064a8 100644
>>> --- a/kernel/vmcore_info.c
>>> +++ b/kernel/vmcore_info.c
>>> @@ -182,6 +182,7 @@ static int __init crash_save_vmcoreinfo_init(void)
>>>  	VMCOREINFO_STRUCT_SIZE(mem_section);
>>>  	VMCOREINFO_OFFSET(mem_section, section_mem_map);
>>>  	VMCOREINFO_NUMBER(SECTION_SIZE_BITS);
>>> +	VMCOREINFO_NUMBER(SECTION_HAS_MEM_MAP);
>>>  	VMCOREINFO_NUMBER(MAX_PHYSMEM_BITS);
>>>  #endif
>>>  	VMCOREINFO_STRUCT_SIZE(page);
>>
>> Current crash code looks below:
>> #define SECTION_MARKED_PRESENT          (1UL<<0)
>> #define SECTION_HAS_MEM_MAP             (1UL<<1)
>> #define SECTION_IS_ONLINE               (1UL<<2)
>> #define SECTION_IS_EARLY                (1UL<<3)
>> #define SECTION_TAINT_ZONE_DEVICE       (1UL<<4)
>> #define SECTION_MAP_LAST_BIT            (1UL<<5)
>> #define SECTION_MAP_MASK                (~(SECTION_MAP_LAST_BIT-1))
>>
>>
>> And it does not match the kernel for below chunk with ifdef
>> #ifdef CONFIG_ZONE_DEVICE
>>         SECTION_TAINT_ZONE_DEVICE_BIT,
>> #endif
>> #ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
>>         SECTION_IS_VMEMMAP_PREINIT_BIT,
>> #endif
>>
>> The last bit could be wrong in crash.  So all numbers should be exported in vmcoreinfo.
>>
>> Thoughts?
> 
> You know the crash code best, so likely ... it's time one of the crash people
> takes over this patch?

Rethinking about it I'm hesitating to add many more to vmcoreinfo although it is reasonable,  about the #ifdef things, there are other places other than mm, crash can not depend on the /proc/config.gz which is not reliable in the old kernel memory, maybe it will be helpful to export another elf note for old kernel's kconfig.  So I'd like to support to use your patch for the time being as the first bit is always needed and leave the remaining concerns a follow up item.

Thanks
Dave

