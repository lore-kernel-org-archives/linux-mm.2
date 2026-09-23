Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CEBFC98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 06:54:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E3976B0093; Wed, 23 Sep 2026 02:54:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 593D76B0095; Wed, 23 Sep 2026 02:54:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 482B36B0096; Wed, 23 Sep 2026 02:54:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 281566B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:54:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE242A06E5
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:54:15 +0000 (UTC)
X-FDA: 85244112870.28.DFF9030
Received: from mta0.migadu.com (out-38.mta0.migadu.com [91.218.175.38])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7C6AC20005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:54:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=flTc8AgK;
	spf=pass (imf13.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.38 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790146453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5kopgcWYbN3BW0kndYJzxwmRs5SvG6fHT0WTJiDxdZ0=;
	b=4OtuWEIV4B9iQ5rGppgU8+lOGu9FPZVkISCVdexhu9ortSMcEABeAeNVzdWkyby1A0OoY+
	bM83lI23uBZtJHtazjOmQM8Oav+jRgrifgs3gYgIig1JkH0FMMuaDJ0lJXjoQ/9mfD3GIo
	1VFGQuur73D263RCpOBtrNE/zrcuGH0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=flTc8AgK;
	spf=pass (imf13.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.38 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790146453;
	b=AOjJpdZAEdsSqxIzhkDlNxd4YhW5tNXsSoJY8qUbZ9CoX+hZbsz19h859g51Vs67MjDSm9
	i4lkEsMFIT0RwOIGL9A3MdihG3aDK0s6b3DSD3Affbe91CeblJqPLRf0y0pO6YuybzCGES
	4gAMGVFCikWMPhFsFcCJLMykzCzGTHs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=43+l31JigLayJwEUrA9Gq86evXfBT+ruBR6R0luZO0g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790146451; v=1; x=1790751251;
 b=flTc8AgKmBrszDcS3y8R+r/Vndduqn25ojt2CSXyKQu8YUvsTPBZ4RPD7ZgppduPuiozng4F
 xxpn56rJPR/FHxe7nBdGMtWHRumeA5ycJdofRWLEOiZneN+aEeoLCFAm8n6kuo7Xh662pjARwhm
 gyPE223Oujk7tkCp5mXCPl40=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3514f7bca8d9eeb1;
	Wed, 23 Sep 2026 06:54:11 +0000
X-Mizu-Trace-ID: 3514f7bca8d9eeb1
X-Migadu-Flow: FLOW_OUT
Message-ID: <31772847-fd8b-4c3c-b2e5-a169193fcfd4@linux.dev>
Date: Wed, 23 Sep 2026 14:55:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 6/6] alloc_tag: Defer /proc/allocinfo removal to a
 workqueue
To: Suren Baghdasaryan <surenb@google.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
 Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 Aaron Tomlin <atomlin@atomlin.com>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, linux-modules@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
References: <20260915070001.113559-1-hao.ge@linux.dev>
 <20260915070001.113559-7-hao.ge@linux.dev>
 <CAJuCfpGMQqjHsAvW=XUA1Q3AyaVJKM2bKYVja_fgn0wa1tk7DA@mail.gmail.com>
 <d7327cdd-43df-46f8-92d4-c25dda7ae684@linux.dev>
 <CAJuCfpHMdZzJNSRgysbS7vOBmTwEPSYfPYUvt_5+uZ-Ydvw+hw@mail.gmail.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpHMdZzJNSRgysbS7vOBmTwEPSYfPYUvt_5+uZ-Ydvw+hw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7C6AC20005
X-Stat-Signature: wedkh5kprkrxx38tqryr933nnk951yrq
X-Rspam-User: 
X-HE-Tag: 1790146453-927881
X-HE-Meta: U2FsdGVkX19Z0P6WA5rG29sVfvHHKOmgaCiu96d+cErFmLAX+SwJns8m6+3hU8QBCXkv5vFLrl9XdoTum+GYfvBWOKge7DwvQFerPuJbaeMMiZxYg8TPpD7m6qxXELAZku8GWLYwd1poMUbVgC9ZFkiXZsG1YNy3L85kd+0xdu6CdlDvGuJidDPO7ZWQDoK6L6DtxsdY5+2xFwykuCGXADCv+mTiJdf3JNjQdOWARdfNjpCWpYpqsWd9Icp5OoTRHEQF7FzvFo9Aq47lmXlZlB4raD6QnF3eRrjTHEP6KaQQyEEyJ/1Li1VVNeg2vdrajB5lRh4DB8xo5yg23K0j8RPraje1YnN2bM42qaBuKSI+TOgJRpfrZkR6J0/0viIH1mX4moGTDUgCUy9kwCHAP3hrrXCWZxCzlsW4qtQhnmiHDhw2a1zeH1+A0SN4hW+m1NasyN9FixYDMPFJz0gkOxkhE8M07r643JSA6C0rn5q//o0HjkcxWxQ8gSJxUcowJeDyuQWemz2KEeJuWbBic1vxIACWDlFeXb+c7bK7zN/T0f64+J7s83BQCGI+lzHkn+KqUU9K2TVVMlMT1nprtObNH8wmiZsYORYaWffQcqiV19mYmkt6FhesZGnZ6Y5QVXdeowHy6x3kcRgl7UAPNh1ve5OZBA8BfqJP09tciJ2xHxDbfoeVDtgknoWPJGU14dAXYU8koXRcBL0v2zJmCIzueDXGarQyGskWY3WvaC3fDSFCn1NYoHt+l1daI57rFb0IXDLlr9JEGf5HA9R+7Q59jKu+4g7IW8+I5QuCf3/oZbFgdnOwCGqUkSqzUciyieFQZ0LAm/sFS+s/Hcb0IbJx0IywZB68St9IINJX5SFv5m3tdjp8+lH92/gPdAFko/7RhJjVPm/bppsf8WppJ5IJuK3eEwESwZetjBJmiazP9KiOD74lg/XiZ0lOh7SXcre8MpK0g/qfvJUQDu4
 f8VTOwrl
 j8/a+cepS2M0CCdD5pYmOHm3SdyMiYg6lXMQi7xALOQ24Rrpxnw90322VgzUwoxIICY9Be1cmYzfbFvtLNZeFtUcVkDlY74YX5dZxFTaYomVb5Em8h3ZlL4/xvnzRdO/VZ6Hp8697Ra5cuXXoOpPSA5yB3xa3DFv6rvJX+JdtAn1wrfeL5s4NBdRGzO2VeYttwoUvVodjp/+3L+TPDo+tsYsp7lKYhpOL3yeQK6ZEBPn+GJdlIRhdXRRFtQAqFO3+XGjHmBuki8Jf3tpQCYflnywhZJxFusPehpyTAcx9bxLGi0o14n0huRye0ZBtiDH6Br/trMnfWb1WKds1PnltMMQv+qLVuA/I5sg/Wc61uFQvnUkHzd9SXiGqgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren

On 2026/9/23 10:41, Suren Baghdasaryan wrote:
> On Thu, Sep 17, 2026 at 6:38 PM Hao Ge <hao.ge@linux.dev> wrote:
>>
>> Hi Suren
>>
>>
>> On 2026/9/18 09:09, Suren Baghdasaryan wrote:
>>> On Mon, Sep 14, 2026 at 11:59 PM Hao Ge <hao.ge@linux.dev> wrote:
>>>>
>>>> shutdown_mem_profiling() calls remove_proc_entry() from
>>>> reserve_module_tags(), which runs under mod_lock held for write.
>>>> remove_proc_entry() waits for readers, and a reader takes mod_lock for
>>>> read in allocinfo_start():
>>>>
>>>>   CPU0 (insmod)                      CPU1 (read /proc/allocinfo)
>>>>   ----------------                   ----------------------------
>>>>   reserve_module_tags()
>>>>     down_write(&mod_lock)  [held]
>>>>                                      use_pde()            [in_use++]
>>>>                                      allocinfo_start()
>>>>                                        down_read(&mod_lock)  <- blocks
>>>>     shutdown_mem_profiling()
>>>>       remove_proc_entry()
>>>>         wait for in_use == 0         <- blocks
>>>>
>>>> Move remove_proc_entry() to a workqueue.
>>>>
>>>> The file creation is moved to the end of alloc_tag_init() as well.
>>>> If alloc_tag_init() fails with alloc_tag_cttype still NULL or an
>>>> error pointer, a concurrent reader of the leftover file would
>>>> dereference it in allocinfo_start() and panic.
>>>>
>>>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>>>> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>>>> ---
>>>>  mm/alloc_tag.c | 26 +++++++++++++++++---------
>>>>  1 file changed, 17 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
>>>> index 1ca0409b492b..cfa0fc84b68f 100644
>>>> --- a/mm/alloc_tag.c
>>>> +++ b/mm/alloc_tag.c
>>>> @@ -15,6 +15,7 @@
>>>>  #include <linux/seq_file.h>
>>>>  #include <linux/string_choices.h>
>>>>  #include <linux/vmalloc.h>
>>>> +#include <linux/workqueue.h>
>>>>  #include <linux/kmemleak.h>
>>>>  #include <uapi/linux/alloc_tag.h>
>>>>
>>>> @@ -591,6 +592,13 @@ void pgalloc_tag_swap(struct folio *new, struct folio *old)
>>>>         put_page_tag_ref(handle_new);
>>>>  }
>>>>
>>>> +static void remove_allocinfo_file(struct work_struct *work)
>>>> +{
>>>> +       remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
>>>> +}
>>>> +
>>>> +static DECLARE_WORK(remove_allocinfo_work, remove_allocinfo_file);
>>>> +
>>>>  static void shutdown_mem_profiling(bool remove_file)
>>>>  {
>>>>         if (mem_alloc_profiling_enabled())
>>>> @@ -600,7 +608,7 @@ static void shutdown_mem_profiling(bool remove_file)
>>>>                 return;
>>>>
>>>>         if (remove_file)
>>>> -               remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
>>>> +               schedule_work(&remove_allocinfo_work);
>>>>         mem_profiling_support = false;
>>>>  }
>>>>
>>>> @@ -1358,16 +1366,10 @@ static int __init alloc_tag_init(void)
>>>>                 return 0;
>>>>         }
>>>>
>>>> -       if (!proc_create(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_proc_ops)) {
>>>> -               pr_err("Failed to create %s file\n", ALLOCINFO_FILE_NAME);
>>>> -               shutdown_mem_profiling(false);
>>>> -               return -ENOMEM;
>>>> -       }
>>>> -
>>>>         res = alloc_mod_tags_mem();
>>>>         if (res) {
>>>>                 pr_err("Failed to reserve address space for module tags, errno = %d\n", res);
>>>> -               shutdown_mem_profiling(true);
>>>> +               shutdown_mem_profiling(false);
>>>>                 return res;
>>>>         }
>>>>
>>>> @@ -1375,10 +1377,16 @@ static int __init alloc_tag_init(void)
>>>>         if (IS_ERR(alloc_tag_cttype)) {
>>>>                 pr_err("Allocation tags registration failed, errno = %pe\n", alloc_tag_cttype);
>>>>                 free_mod_tags_mem();
>>>> -               shutdown_mem_profiling(true);
>>>> +               shutdown_mem_profiling(false);
>>>>                 return PTR_ERR(alloc_tag_cttype);
>>>>         }
>>>>
>>>> +       if (!proc_create(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_proc_ops)) {
>>>> +               pr_err("Failed to create %s file\n", ALLOCINFO_FILE_NAME);
>>>> +               shutdown_mem_profiling(false);
>>>
>>> You need free_mod_tags_mem() here.
>>>
>>
>> Right. Another problem is exposed here: moving proc_create() to the end
>> implies successful return from codetag_register_type(),
>> so alloc_tag is already added into codetag_types.
>> That looks a bit odd to me. Because all places inside codetag that access this
>> linked list will access this incompletely‑initialized codetag_type.
>> There is currently no matching unregister interface to tear it down.
>> So I drafted one previously:
>> void codetag_unregister_type(struct codetag_type *cttype)
>> {
>>         struct codetag_module *cmod;
>>         unsigned long id, tmp;
>>
>>         mutex_lock(&codetag_lock);
>>         list_del(&cttype->link);
>>         mutex_unlock(&codetag_lock);
>>
>>         codetag_lock_module_list(cttype);
>>         idr_for_each_entry_ul(&cttype->mod_idr, cmod, tmp, id)
>>                 kfree(cmod);
>>         idr_destroy(&cttype->mod_idr);
>>         codetag_unlock_module_list(cttype);
>>
>>         kfree(cttype);
>> }
>>
>> But looking back, do we really need to do this? I'm not so sure.
> 
> I think having codetag_unregister_type() would be a good idea. For now
> it's used only in this failure case, so we can make it an __init
> function and not waste any memory at all.
>
Thank you for the valuable suggestion, I will take this approach.
I've found there could be a race condition with alloc_tag_top_users.
I'll analyze it.

Thanks
Best Regards
Hao

>> I previously thought the issue reported by Sashiko was a false positive,
>> and I laid out my thoughts back then:
>> https://lore.kernel.org/all/afa606df-3d5b-47c2-9972-f3e0c2e13c12@linux.dev/
>> and I thought the change would be straightforward, and defensive programming
>> felt acceptable to me, but it turns out to be a little more complex than I expected.
>>
>> Suren, could you help me analyze this? Thank you very much for your valuable feedback
>>
>> Thanks
>> Best Regards
>> Hao
>>
>>>> +               return -ENOMEM;
>>>> +       }
>>>> +
>>>>         return 0;
>>>>  }
>>>>  module_init(alloc_tag_init);
>>>> --
>>>> 2.25.1
>>>>

