Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 514DAC982D0
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 01:38:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E247C6B008A; Thu, 17 Sep 2026 21:38:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD5586B008C; Thu, 17 Sep 2026 21:38:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9C1C6B0092; Thu, 17 Sep 2026 21:38:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 85BEA6B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:38:24 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E1A2E404FE
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:38:23 +0000 (UTC)
X-FDA: 85225172886.09.A641683
Received: from mta0.migadu.com (out-209.mta0.migadu.com [91.218.175.209])
	by imf13.hostedemail.com (Postfix) with ESMTP id 82D4520003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:38:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HAvJJQz0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.209 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789695502;
	b=ZzAoqQqC247M6WDRo0qzrqz45T9ZmwsA+NAdJj5sXTZpbyabbIBoxNxOZknv2Hg/uSqc97
	pBmPrOChpnwEgvUoOCQxiNs6aC1hwsX09vR70mVy8j2I39Stz0M9Jnq4AdO6E8nJ4iRjGL
	eC5zz+8AOMIg5JiMICXc+ef+yTeNKXM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HAvJJQz0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.209 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789695502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eNbq/pu/gt1YqRcwcDAaZLmzUiWN9G6WW7z1KlzwjUA=;
	b=b7cbmw4j9Dr7n6enSLrmofexsNjMhmKiWM2n98DfgbbJH2waQHpBUF85uy3UKM0raNA58g
	syML5zl1dWe5VWFmpvmO5ZJmPxrI0tOT/g2u/iAie9TlTY48CO63DoNG0m5hRtiBaDXAyr
	zCkO1Z0MgRyWstzQx3he6wQ6L2FXRwg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nhaB4QCyvY2vj/8aUqYIKXSALA608i9qAGxN94zUC5o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789695500; v=1; x=1790300300;
 b=HAvJJQz0TIzLUIFAdl3YNUx8wR5LfXsxyzZEgqmASqxWFXXgizDSQfifrtIrPdNXMJ1PYVQt
 jTrjTQqLJZDPgoVDGZzAtVGKUI0luDbEqDIVBhf0SZKlkDzkWoKMPXvaWY0kp/CZdpffFB4BuSQ
 licyAOnlz1qtWlDCslxcgpyk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9f10f04cf85e3f6a;
	Fri, 18 Sep 2026 01:38:20 +0000
X-Mizu-Trace-ID: 9f10f04cf85e3f6a
X-Migadu-Flow: FLOW_OUT
Message-ID: <d7327cdd-43df-46f8-92d4-c25dda7ae684@linux.dev>
Date: Fri, 18 Sep 2026 09:39:12 +0800
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
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpGMQqjHsAvW=XUA1Q3AyaVJKM2bKYVja_fgn0wa1tk7DA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 82D4520003
X-Stat-Signature: rhmqydjz81idsdrh3ungz79wx5fszpgw
X-HE-Tag: 1789695501-648599
X-HE-Meta: U2FsdGVkX18TCfARmDd2qcUFtSmqARVRrvW9pgm4vYzCTkNkmjZ5lzRzs5xo6ZHimbHLHlFhnxND/aGNwzTAMfPKoGvFqvGYUozmBaplMvXoA4RC2nMxenL6f7HJOnlIi7fXf6T1D9GjIhw3Of+7dDGQd2TMhJEhW/5twM9jxQaU79wWhTGQGAu+KzTkEp+lstSY7jXkR2uqqf8ygjUiqYJraqQpaMf+dy1B6l7y7EGtaGmvQKAgQAE+eKS9N2MeqsC6HWz2WVBt+FsG8hd6kZyXMycaXQjvVX3kHse8XksohQ6D1gA8OXHf/nruZmXswzpzxCxlRoQoyu4HgbRpvTgSe9bHXHx+g0ZCYV1pUL2PIOgcbzW5L8nMRDern2AhBpXXIIbn++/RnSdoBTFjMTtQ+HRdlZghONWTTgozSxHG0bv0XgceJZc/EIzFnxRA9tN2fYbPqhYkPivBjXMhwpTq1wTQ6M/qXCWbXXJ3ai3e5//utxzrtJgFaUfx2NJwuA3qGMPdIFN8sXW77A0jho2hNV3CvMkwGrSZ4nXCs5+PhLAeXKYMW9ORRALD0OGznWzcIiv1IhztqCE/fhQQZFrinlV8sSA+5BXzrGDvYizlikGD1fzrGkyxv6oBmWxBrdf8v7XZE0GqmoWFEZ66LLXyUUwomWAge250XxTInIAbKOvarTQGfUhyAFlK429+vT72CD/wj02sMDGXeig39Be4foGLtjaV6N1e6LoYp+65Xr55t1G6Qo8qtog2DOuMSFhP0e2JPlCF4aGH+liZKhmOT2v+mW/SqYH8soQDAUIswss4HxN5fRPxfsMZ+UImDDuJJ2jth3qj39SHZllpzaV/gFZ8yGCj0JZ7s8hcNesPqeNDNfQo2imzZGZoyhEB3xbSyWdWAoT2VV9j9XK1EohDHhv+9Bs64dMZDlvSbbXCdmDCmUH5n+EYTEJPbYAC/ye50joPTeKnxVaGXl6
 orxNPHA0
 uu+l2Z08FSybpAKFGHCXCqV5Fusz8c/RiRqtUWhkogG4ngxij42zWW/7oOWglGVaCnfa/CjqkTzTsYpjgeediLo14BLcERO238tBRaIzBtr2r6rvy4KCC55igBbvVpvUc6h0ufM4+1i6hS4Ij6joFJCOaJBgcNbTzpbC6FC7wego++8KHrlAOvyHH8D17FT+aDBluAT/qmEK2RMmCDfq1RWvwOypAm3hVd7LwI9LGb5na4hA2B9EMJ/hQaE2YpZt8x9GtPU+uCGFrE7wPtpRUfnpLjDKBKcbMXVzSF2xK6fIAAjmQ2sBS6FYrMPfeTejzoWrOA8ciqOWmB7iCttJ3qOU3EcX8TUdGfuXWrlVwhqB2hf0SwuBM3ugNtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren


On 2026/9/18 09:09, Suren Baghdasaryan wrote:
> On Mon, Sep 14, 2026 at 11:59 PM Hao Ge <hao.ge@linux.dev> wrote:
>>
>> shutdown_mem_profiling() calls remove_proc_entry() from
>> reserve_module_tags(), which runs under mod_lock held for write.
>> remove_proc_entry() waits for readers, and a reader takes mod_lock for
>> read in allocinfo_start():
>>
>>   CPU0 (insmod)                      CPU1 (read /proc/allocinfo)
>>   ----------------                   ----------------------------
>>   reserve_module_tags()
>>     down_write(&mod_lock)  [held]
>>                                      use_pde()            [in_use++]
>>                                      allocinfo_start()
>>                                        down_read(&mod_lock)  <- blocks
>>     shutdown_mem_profiling()
>>       remove_proc_entry()
>>         wait for in_use == 0         <- blocks
>>
>> Move remove_proc_entry() to a workqueue.
>>
>> The file creation is moved to the end of alloc_tag_init() as well.
>> If alloc_tag_init() fails with alloc_tag_cttype still NULL or an
>> error pointer, a concurrent reader of the leftover file would
>> dereference it in allocinfo_start() and panic.
>>
>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>> ---
>>  mm/alloc_tag.c | 26 +++++++++++++++++---------
>>  1 file changed, 17 insertions(+), 9 deletions(-)
>>
>> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
>> index 1ca0409b492b..cfa0fc84b68f 100644
>> --- a/mm/alloc_tag.c
>> +++ b/mm/alloc_tag.c
>> @@ -15,6 +15,7 @@
>>  #include <linux/seq_file.h>
>>  #include <linux/string_choices.h>
>>  #include <linux/vmalloc.h>
>> +#include <linux/workqueue.h>
>>  #include <linux/kmemleak.h>
>>  #include <uapi/linux/alloc_tag.h>
>>
>> @@ -591,6 +592,13 @@ void pgalloc_tag_swap(struct folio *new, struct folio *old)
>>         put_page_tag_ref(handle_new);
>>  }
>>
>> +static void remove_allocinfo_file(struct work_struct *work)
>> +{
>> +       remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
>> +}
>> +
>> +static DECLARE_WORK(remove_allocinfo_work, remove_allocinfo_file);
>> +
>>  static void shutdown_mem_profiling(bool remove_file)
>>  {
>>         if (mem_alloc_profiling_enabled())
>> @@ -600,7 +608,7 @@ static void shutdown_mem_profiling(bool remove_file)
>>                 return;
>>
>>         if (remove_file)
>> -               remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
>> +               schedule_work(&remove_allocinfo_work);
>>         mem_profiling_support = false;
>>  }
>>
>> @@ -1358,16 +1366,10 @@ static int __init alloc_tag_init(void)
>>                 return 0;
>>         }
>>
>> -       if (!proc_create(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_proc_ops)) {
>> -               pr_err("Failed to create %s file\n", ALLOCINFO_FILE_NAME);
>> -               shutdown_mem_profiling(false);
>> -               return -ENOMEM;
>> -       }
>> -
>>         res = alloc_mod_tags_mem();
>>         if (res) {
>>                 pr_err("Failed to reserve address space for module tags, errno = %d\n", res);
>> -               shutdown_mem_profiling(true);
>> +               shutdown_mem_profiling(false);
>>                 return res;
>>         }
>>
>> @@ -1375,10 +1377,16 @@ static int __init alloc_tag_init(void)
>>         if (IS_ERR(alloc_tag_cttype)) {
>>                 pr_err("Allocation tags registration failed, errno = %pe\n", alloc_tag_cttype);
>>                 free_mod_tags_mem();
>> -               shutdown_mem_profiling(true);
>> +               shutdown_mem_profiling(false);
>>                 return PTR_ERR(alloc_tag_cttype);
>>         }
>>
>> +       if (!proc_create(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_proc_ops)) {
>> +               pr_err("Failed to create %s file\n", ALLOCINFO_FILE_NAME);
>> +               shutdown_mem_profiling(false);
> 
> You need free_mod_tags_mem() here.
>

Right. Another problem is exposed here: moving proc_create() to the end
implies successful return from codetag_register_type(),
so alloc_tag is already added into codetag_types.
That looks a bit odd to me. Because all places inside codetag that access this
linked list will access this incompletely‑initialized codetag_type.
There is currently no matching unregister interface to tear it down.
So I drafted one previously:
void codetag_unregister_type(struct codetag_type *cttype)                                                                                                                                                                                                                      
{                                                                                                                                                                                                                                                                              
	struct codetag_module *cmod;                                                                                                                                                                                                                                                 
	unsigned long id, tmp;                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                             
	mutex_lock(&codetag_lock);                                                                                                                                                                                                                                                   
	list_del(&cttype->link);                                                                                                                                                                                                                                                     
	mutex_unlock(&codetag_lock);                                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                                              
	codetag_lock_module_list(cttype);                                                                                                                                                                                                                                               
	idr_for_each_entry_ul(&cttype->mod_idr, cmod, tmp, id)                                                                                                                                                                                                                       
		kfree(cmod);                                                                                                                                                                                                                                                               
	idr_destroy(&cttype->mod_idr);                                                                                                                                                                                                                                               
	codetag_unlock_module_list(cttype);                                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                                             
	kfree(cttype);                                                                                                                                                                                                                                                               
}

But looking back, do we really need to do this? I'm not so sure.
I previously thought the issue reported by Sashiko was a false positive,
and I laid out my thoughts back then:
https://lore.kernel.org/all/afa606df-3d5b-47c2-9972-f3e0c2e13c12@linux.dev/
and I thought the change would be straightforward, and defensive programming
felt acceptable to me, but it turns out to be a little more complex than I expected.

Suren, could you help me analyze this? Thank you very much for your valuable feedback

Thanks
Best Regards
Hao

>> +               return -ENOMEM;
>> +       }
>> +
>>         return 0;
>>  }
>>  module_init(alloc_tag_init);
>> --
>> 2.25.1
>>

