Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66EA6C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 04:15:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8183D6B007B; Tue,  4 Aug 2026 00:15:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D7636B0088; Tue,  4 Aug 2026 00:15:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 714866B008A; Tue,  4 Aug 2026 00:15:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 57FE76B007B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:15:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F1031408C3
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:15:16 +0000 (UTC)
X-FDA: 85062272232.23.3D6AF7E
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id B2CE2A0003
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:15:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jXAJo2n/";
	spf=pass (imf25.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785816915;
	b=ewJBV1voJ4FBp8EJAges0cWsRkKNwB7s9z2GYAzjYXLRu+CwpqRDaBc+15v3WSGuAQc+jv
	DKID9ct7fdIJBfsfWs6iv7tjVQ3HyWufLcRVa8XYQe2d5F1Vkrgn/BnRCeCQhVPwcDqwKp
	8Qk/F57Jli9zQk0+DKr1grh38UYyV8o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jXAJo2n/";
	spf=pass (imf25.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785816915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ps1Dri8UzSB1jjTvWRqSQYPr91u6L8+5z9psY43bCwg=;
	b=s+Di2DqCOboPaigbg49dhd/mra65KSI7S7YVbPtjTO5PNBKqlcXvYoMkyB1jNZlsQmeWFI
	RbhWMWZTg23eALTYoEaU0DTQ03F8RwHNSTR9xiztt4bwfsX6fvhjjUDefwqtpDucNeaOQd
	Tqi4IYTBuxX1vSZ6IR9ygmQVtUX+sgw=
Message-ID: <7eaf894f-5824-47e8-bcb5-94c0aad52e8b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785807671;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ps1Dri8UzSB1jjTvWRqSQYPr91u6L8+5z9psY43bCwg=;
	b=jXAJo2n/7Gy350ZhhSbx7e2YAEQsX+iOt0Cn1Ss7DMlkV+xkRsdz8HOnQedDKhCy7RXRgw
	KKPEA9NoIZeFnHCVz4RaQBruRzlz9jY5j87TyFg5xiFL0qftMHeI+UEImNudBTq88LgpEH
	1R273tJiGML9EU9cmVjNHg6BNWN9CAM=
Date: Tue, 4 Aug 2026 09:40:46 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3] alloc_tag: expose profiling and compression states
To: Suren Baghdasaryan <surenb@google.com>,
 Abhishek Bapat <abhishekbapat@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <d635115cfafcd35c8e3344b418acb1020aba1052.1785794035.git.abhishekbapat@google.com>
 <CAJuCfpGA7F80yW1=bSXsZre4=Tx=peqNbkWvKF0up8xJdSvrgA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpGA7F80yW1=bSXsZre4=Tx=peqNbkWvKF0up8xJdSvrgA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ce7edfpyss6bpaxobu73ns3b4o3hymcz
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B2CE2A0003
X-HE-Tag: 1785816914-299531
X-HE-Meta: U2FsdGVkX180S75dTBC5aEAj8iOnF5mk/t/1fyFN/p0cun9JsQUoAtqMARQRwEAxBvE13v4zSG+VCIoI4RmaC6ESYyubwj1sj2Ha0Lr1wfD0VtEWkcZkGtHNK1xs5ohNJtGcySV8vX7v9WiZ7EcHAKJr9N00N9sMkJm5MlnrYwD1fUo73VY9ZmDBcRA8sFAV+hdpXLjdQ/w1GySlfSopPWOmarHkcY01xEz011C6VZGBj/5Ie3r4oLlpAiev5hJ+I9yU29GXQtPTgPGy+ibnYm+7CAai0h3l7Y897Sv0jHhkShvWEGIfLvNX0QV0y75NWYenQmshZOBX3kIIiWl40H63v7rl3b6ehcr+1IgKXt+mUocShVob58iqKnVc9F53ZLKarrK1t8KHerDV0e1UZKnVz4RVYQlLSTN2DV8BBXUc27pdyIKld2H8dOeoNnLbuYkH9TjkM4N4bc00DAJ4R2YXrj95ORLSKrTNQnqB+sn8xbhh+Spl2RAZFBkdLY8W5wxQBvahi1m7oM5MX1v7PXqm0lz+miH/Boieq6BhXXAn2K2SdDCMDtphw5t59Nx5sRYO4+41glQHElInqYnPgOGrlXfHjz4lIS29ZsmNe/yyPMGyu5dKoZAUXDdTkl1rNc3cK4t5lGz0BEQKYlGu5y0zFtfWT0RfElkuYNBbQi5B+i+EAhJhqv7gTS0CbevXCz04md9nDiCdbNPMrPFGaPqomSDRp40MvzST1jGveGoxqPVln8DaoEiSXdoY6Gf9kPb81OtgtVdRzu/flDD36oNv4JVLUMgxTH5Yc1AvgySpXAmDgk5W3q6Vn1JtGjfBxUlF0lzktZdtU2AV9op1hoHC2vGNSSbAqESKgjanMs313WOOqAOSAq8GZAn9wisHXQoJeafOZvkm2DbmDHatkftuOnj7mvj/BoyyHlY9ZcrW9ZwgszcLhxUI9HAHOiXbay+lirRADerETgNttc0
 sQl2jfdT
 48zoQ0ZY27+AuiMfbJO9RcaZS3n8sx7BYVhNOb7+G4cMPqN6vRG5GHFBNdFM5haJxYV6z9EG1OsOSDRrS+LsC0oeztfHe2EBvIiJ+CwXOtLAxA+0S4QB0AOQZxJ9/z6VC6nQxqDjQnYaj4B3RLTPtL0TcKywujjDXCw1PXnFygoaKM6niD/KVuegTvDbLM4DbDpHXRUzA83xE0MzjaL+TeJI2Pf53SPz2TBtR48vQflPscei0DxCOogMNCi83Fd/ySWTJZjJfDUwrZZwPFdau41nWXSmgB5o2i9SEFbkG5Mg8bn+Va0DPIqyW6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2026/8/4 08:30, Suren Baghdasaryan wrote:
> On Mon, Aug 3, 2026 at 2:54 PM Abhishek Bapat <abhishekbapat@google.com> wrote:
>> Currently, userspace has limited visibility into the exact active
>> runtime state of memory allocation profiling and its page extension
>> compression ('sysctl.vm.mem_profiling={0|1|never}[,compressed]').
>>
>> While reading the sysctl provides basic on/off status, it is currently
>> impossible for userspace to natively determine whether page-tag
>> compression was successfully enabled without scraping dmesg boot logs.
>>
>> Resolve this ambiguity by exposing the active compression state by
>> adding a new read-only sysctl `vm.mem_profiling_compressed` to output the
> "Resolve this ambiguity by exposing the active compression state by
> adding a new read-only sysctl" sounds too elaborate. This also
> conflicts with the documentation you added which states
> "`mem_profiling_compressed` represents the state configured at boot
> time", so your description of it representing "the active compression
> state" is incorrect.
> How about: "Add a new read-only sysctl representing how compression
> was configured at boot time."?
>
>> state.
>>
>> v3 change:
>> - Added documentation about the behaviour details of the new sysctl.
>>
>> v2 change:
>> - Moved from displaying the state in /proc/allocinfo to a new read-only
>> sysctl.
>>
>> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
>> ---
>>   Documentation/mm/allocation-profiling.rst | 13 +++++++++++++
>>   mm/alloc_tag.c                            |  6 ++++++
>>   2 files changed, 19 insertions(+)
>>
>> diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm/allocation-profiling.rst
>> index c3a28467955f..3ad1e9aacb9a 100644
>> --- a/Documentation/mm/allocation-profiling.rst
>> +++ b/Documentation/mm/allocation-profiling.rst
>> @@ -43,6 +43,19 @@ sysctl:
>>     warnings produced by allocations made while profiling is disabled and freed
>>     when it's enabled.
>>
>> +  /proc/sys/vm/mem_profiling_compressed
>> +
>> +  1: Page extension compression is enabled.
> We are not compressing page extensions but rather page allocation
> tags, so "Page extension compression" is misleading. I think "Page
> allocation tag compression is enabled." would be better.


Agree. The commit message describes it the same way ("page extension 
compression"),

so that needs fixing too.


Thanks

Best Regards

Hao


>
>> +
>> +  0: Page extension compression is disabled.
>> +
>> +  This control is read-only and reflects the compression status initialized at boot.
>> +  Note that, unlike `mem_profiling`, which represents the current state of profiling,
>> +  `mem_profiling_compressed` represents the state configured at boot time. Turning off
>> +  profiling at runtime will implicitly make this sysctl effectively dormant. However, if
>> +  profiling is toggled off and then toggled on again, it will resume with compression
>> +  still enabled as long as the value of `mem_profiling_compressed` is 1.
>> +
>>   Runtime info:
>>     /proc/allocinfo
>>
>> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
>> index 52aece27b00e..877068241f06 100644
>> --- a/mm/alloc_tag.c
>> +++ b/mm/alloc_tag.c
>> @@ -1303,6 +1303,12 @@ static const struct ctl_table memory_allocation_profiling_sysctls[] = {
>>                  .mode           = 0644,
>>                  .proc_handler   = proc_mem_profiling_handler,
>>          },
>> +       {
>> +               .procname       = "mem_profiling_compressed",
>> +               .data           = &mem_profiling_compressed,
>> +               .mode           = 0444,
>> +               .proc_handler   = proc_do_static_key,
>> +       },
>>   };
>>
>>   static void __init sysctl_init(void)
>>
>> base-commit: 94f9b3980dd446b56acf1dfed649e9b32a9f3813
>> --
>> 2.55.0.508.g3f0d502094-goog
>>

