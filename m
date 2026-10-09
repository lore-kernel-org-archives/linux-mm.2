Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88AF7CA6019
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 11:16:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EE786B008A; Fri,  9 Oct 2026 07:16:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59F9C6B008C; Fri,  9 Oct 2026 07:16:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B5676B0092; Fri,  9 Oct 2026 07:16:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 20B206B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:16:04 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 874CA160320
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:16:03 +0000 (UTC)
X-FDA: 85302833406.05.87CCF1E
Received: from mta0.migadu.com (out-67.mta0.migadu.com [91.218.175.67])
	by imf16.hostedemail.com (Postfix) with ESMTP id 44665180008
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:16:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IBZkN+lX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.67 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791544561;
	b=PpfhbjU6IonbkNr2Uy0jx7K4EcZxuIXW8LmDAGSZk3ot7mlOPYyeo/CLbLnyJT52ZiDtTw
	wMpaJYWS4puoAhu+6OCtnX6pmluobFNDYT4f1bV7MiUxwq5IrcNNysEbjNMxp84rGMq2qR
	lCBWmFxCGkpUVilliSm3NN94ZdgICXY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IBZkN+lX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.67 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791544561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iwv1BWmAu896MWLG+64UqZ2zg+kLXlIFqA3EzK8LKFg=;
	b=WaOhZrS9YQ1K+SAHv5VBmx0tRjk9DrxKDwyGhKrqGgb+AkhxbZ/j82Q8Pb5jYsuuAGFYFn
	CvXv0cg2Dz0AQIq7+lKc/1t9CVUkbO3Qodp8BfSTsihbN5uwGCMDdUsGX0H3rO0eCQnV7d
	IwCWitfzYy7tihal40DHebcKvoeFh/0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4KiuDAG3gm65cIQ2mqPJSAHpZO66H8hjIEiCXFAoNYM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791544559; v=1; x=1792149359;
 b=IBZkN+lXJtyzzq+HboWEf+pTEmDUHg2mr1J5B0m6Gb40yLOVWgGdhjHg+iFBwA2YXAhJ330P
 6Qwst0ZcwCqwInWNkUASo0zF+lp0YoVSSZtdVwYAgWDjotzsZRv9Q4zZw9hbm5Cn/jzsgp0vtL6
 QfGuKs//YCttNVBhKevKeZPQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 50b57414bfeda855;
	Fri, 09 Oct 2026 11:15:47 +0000
X-Mizu-Trace-ID: 50b57414bfeda855
X-Migadu-Flow: FLOW_OUT
Message-ID: <fc32fbb9-9db2-40f1-88fc-c087927a1eb8@linux.dev>
Date: Fri, 9 Oct 2026 19:16:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 7/7] alloc_tag: fix the /proc/allocinfo lifecycle
To: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
 Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 Aaron Tomlin <atomlin@atomlin.com>, Andrew Morton
 <akpm@linux-foundation.org>, Alexander Potapenko <glider@google.com>,
 Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
 kasan-dev@googlegroups.com, Sashiko <sashiko-bot@kernel.org>,
 stable@vger.kernel.org
References: <20260929082014.160587-1-hao.ge@linux.dev>
 <20260929082014.160587-8-hao.ge@linux.dev>
 <CAJuCfpEwrdOKQmt9_=J4Qawtg48AUuwwbc2Lp-1oWiNbKO_UVw@mail.gmail.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpEwrdOKQmt9_=J4Qawtg48AUuwwbc2Lp-1oWiNbKO_UVw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wefs4t5b57menmte1urco9xpx6yy83ts
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 44665180008
X-HE-Tag: 1791544561-413533
X-HE-Meta: U2FsdGVkX1+YHCKwm2Jx8gosvVOIKR2Iz6xZ54ZsgQRnFtV4W29T3OYxciCpUHTBq8IHu4kHZ4eHBhfVNl5PI2oaB2Amro//SbKshxbqMf4YmGFZfGBJt4sz2xeQ3VZOCZ3cN0DUbGwR9BWE0Wf8uJPd5XD7oWvn44O/mKG/m4ychbBMQmUFh1MTITp97oueGTt5Jo3UlSrc9fd0u/CgrPwAfV9arv8F6wvS28uNJISAF/vXEvesuJ8471hLgrFUf9o9sOTsWJs0pnZrwwaHHWJPFstMQH1M0Zfzpp6jbnIIuNMMka1uX9otKX1t8y6ofGkHT8yE8LrJNa6vnSeq0KXFSdmMke3NcOluZ6uJz9tGk9DYcCq6I0UoheYwkIiRJh9wMaea0Ldha7UzZ3433bWSgaJINcI4v23dCE5gQA0N4GE9vHUyYOlyCbZJpYpmHxkCF/cx/BkqojRsgiDrZBVo+Vz+mQFSfm6DkH8CaMM2Kre2TGl2N8PzJxcYznn8m3689l35ka7XiTrJLC10EMRCdDGj/K/B/ZOfWDZjc8B8y6zel7ts5ofLi+1fksHcnXvEMsP4vxCr9oGsylFZ+T2PTqYc1ENCt/4u9SN2uCLW3/+5EqS/HJ46c09OErGMZDGkud9sHiax0f7sQ9tcrFrUQUL/7WO6fsW1xpSsmxoGC17e/NfRs/N9X4zqLPxLKV9GpEkix3kiHjU3wGoaUEYGUV5t5sdL8lafjWe7V2KS+Vz8XwhiY8KL2nAhlxLm2SQJ/1KTcne3dPxfhpilMZ5OXiYdsn9C2zXIeGrQPoAir3McR1i3dW/+ya3cCVdBg2jcSW7RWTyEHXLP2jW3BJ5tml/vWPds9y2iaxfxKQapA4quFgSpqsjUZ3mICN28TYVZ39oP/XTuc2WnmkEcwdzHiof4MxMa/uRovwCA73NbInQ51/3KO22mv2/HeXg2w08+k25o72c85V86Fwq
 TZmoC4nK
 vGCnMuCpErmqQHVp9negyU6L4qjqp/UGYWSyunezP4pQ/Gaw4YpWRsNcjsxTogC6YzDrxLYKdjFLr4OPayYq346SZ+VmU5v422ESaSdjkFY0e4UNEm9T+VMAcJKVA3dwq18iPJDI/PkRzjFhpDu23Ul1ghjzsJPojZzv6yRlCt7BRey7t0PY7HQuu31qbaqHwVI3JWXYrX/yZMfDBVw3A4xd5a+mBH5V2KdmOFiJ7ktE2fdjS+3alxVihhY3ZiPzNZntTc2fbuVivnNZREqoOWOG2cwt/sVCOugizohvNMSLQmD968qMR5wY6wgopo/jNVtPtjcu11aWJcCt7f9fznnkqfgV6JnFBtwrSTFhGpwcnw4XUBvPM8ZgtBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren


On 2026/10/5 02:23, Suren Baghdasaryan wrote:
> On Tue, Sep 29, 2026 at 10:20 AM Hao Ge <hao.ge@linux.dev> wrote:
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
>> The deferred removal also affects alloc_tag_init(). The file is
>> created before the type, so on a failure it is still there with
>> alloc_tag_cttype NULL or an error pointer, and a reader panics in
>> allocinfo_start(). Create the file at the end of alloc_tag_init()
>> instead, a failed init leaves nothing behind.
>>
>> If proc_create() fails, the codetag type and the module tags memory
>> leak. Call codetag_unregister_type() and free the memory.
>>
>> alloc_tag_cttype can now be freed at runtime. alloc_tag_top_users()
>> reads it from __show_mem() without locks, read the pointer under
>> rcu_read_lock() and take mod_lock before dropping the RCU lock, the
>> type stays alive until then. The only caller never sleeps, drop the
>> can_sleep argument.
>>
>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>> ---
>>  include/linux/alloc_tag.h |  2 +-
>>  include/linux/codetag.h   |  2 ++
>>  lib/codetag.c             | 26 ++++++++++++++++++++
>>  mm/alloc_tag.c            | 52 +++++++++++++++++++++++++++------------
>>  mm/show_mem.c             |  2 +-
>>  5 files changed, 66 insertions(+), 18 deletions(-)
>>
>> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
>> index 7f2d80a59792..852dc10c00ee 100644
>> --- a/include/linux/alloc_tag.h
>> +++ b/include/linux/alloc_tag.h
>> @@ -81,7 +81,7 @@ struct codetag_bytes {
>>         s64 bytes;
>>  };
>>
>> -size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count, bool can_sleep);
>> +size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count);
>>
>>  static inline struct alloc_tag *ct_to_alloc_tag(struct codetag *ct)
>>  {
>> diff --git a/include/linux/codetag.h b/include/linux/codetag.h
>> index a25a085c2df1..0c4e0337b474 100644
>> --- a/include/linux/codetag.h
>> +++ b/include/linux/codetag.h
>> @@ -87,6 +87,8 @@ void codetag_to_text(struct seq_buf *out, struct codetag *ct);
>>  struct codetag_type *
>>  codetag_register_type(const struct codetag_type_desc *desc);
>>
>> +void codetag_unregister_type(struct codetag_type *cttype);
>> +
>>  #if defined(CONFIG_CODE_TAGGING) && defined(CONFIG_MODULES)
>>
>>  bool codetag_needs_module_section(struct module *mod, const char *name,
>> diff --git a/lib/codetag.c b/lib/codetag.c
>> index a0b600720afc..46d0904b08b3 100644
>> --- a/lib/codetag.c
>> +++ b/lib/codetag.c
>> @@ -429,3 +429,29 @@ codetag_register_type(const struct codetag_type_desc *desc)
>>
>>         return cttype;
>>  }
>> +
>> +/**
>> + * codetag_unregister_type - unregister a codetag type
>> + * @cttype: the codetag type to unregister
>> + *
>> + * Undo codetag_register_type() and free @cttype. The caller must make
>> + * sure no lockless reader still uses @cttype, e.g. clear the pointer
>> + * to it and wait for an RCU grace period first.
>> + */
>> +void __init codetag_unregister_type(struct codetag_type *cttype)
>> +{
>> +       struct codetag_module *cmod;
>> +       unsigned long id, tmp;
>> +
>> +       mutex_lock(&codetag_lock);
>> +       list_del(&cttype->link);
>> +       mutex_unlock(&codetag_lock);
>> +
>> +       down_write(&cttype->mod_lock);
>> +       idr_for_each_entry_ul(&cttype->mod_idr, cmod, tmp, id)
>> +               kfree(cmod);
>> +       idr_destroy(&cttype->mod_idr);
>> +       up_write(&cttype->mod_lock);
>> +
>> +       kfree(cttype);
>> +}
>> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
>> index ba8a651769e3..b9af5fe5bba2 100644
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
>> @@ -484,22 +485,28 @@ static const struct proc_ops allocinfo_proc_ops = {
>>  #endif
>>  };
>>
>> -size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count, bool can_sleep)
>> +size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count)
>>  {
>>         struct codetag_iterator iter;
>> +       struct codetag_type *cttype;
>>         struct codetag *ct;
>>         struct codetag_bytes n;
>>         unsigned int i, nr = 0;
>> +       bool locked;
>>
>> -       if (IS_ERR_OR_NULL(alloc_tag_cttype))
>> +       rcu_read_lock();
>> +       cttype = READ_ONCE(alloc_tag_cttype);
> 
> Code looks correct to me but if you are changing alloc_tag_cttype to
> be accessed under RCU, then you should declare it as __rcu and use
> rcu_assign_pointer()/rcu_access_pointer()/rcu_dereference()/rcu_dereference_protected().

Yes. I missed that. Will fix in the next version.

Thanks
Best Regards
Hao

> 
>> +       if (IS_ERR_OR_NULL(cttype)) {
>> +               rcu_read_unlock();
>>                 return 0;
>> +       }
>>
>> -       if (can_sleep)
>> -               codetag_lock_module_list(alloc_tag_cttype);
>> -       else if (!codetag_trylock_module_list(alloc_tag_cttype))
>> +       locked = codetag_trylock_module_list(cttype);
>> +       rcu_read_unlock();
>> +       if (!locked)
>>                 return 0;
>>
>> -       iter = codetag_get_ct_iter(alloc_tag_cttype);
>> +       iter = codetag_get_ct_iter(cttype);
>>         while ((ct = codetag_next_ct(&iter))) {
>>                 struct alloc_tag_counters counter = alloc_tag_read(ct_to_alloc_tag(ct));
>>
>> @@ -520,7 +527,7 @@ size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count, bool can_sl
>>                 }
>>         }
>>
>> -       codetag_unlock_module_list(alloc_tag_cttype);
>> +       codetag_unlock_module_list(cttype);
>>
>>         return nr;
>>  }
>> @@ -591,6 +598,13 @@ void pgalloc_tag_swap(struct folio *new, struct folio *old)
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
>> @@ -600,7 +614,7 @@ static void shutdown_mem_profiling(bool remove_file)
>>                 return;
>>
>>         if (remove_file)
>> -               remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
>> +               schedule_work(&remove_allocinfo_work);
>>         mem_profiling_support = false;
>>  }
>>
>> @@ -1351,16 +1365,10 @@ static int __init alloc_tag_init(void)
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
>> @@ -1368,10 +1376,22 @@ static int __init alloc_tag_init(void)
>>         if (IS_ERR(alloc_tag_cttype)) {
>>                 pr_err("Allocation tags registration failed, errno = %pe\n", alloc_tag_cttype);
>>                 free_mod_tags_mem();
>> -               shutdown_mem_profiling(true);
>> +               shutdown_mem_profiling(false);
>>                 return PTR_ERR(alloc_tag_cttype);
>>         }
>>
>> +       if (!proc_create(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_proc_ops)) {
>> +               struct codetag_type *cttype = alloc_tag_cttype;
>> +
>> +               pr_err("Failed to create %s file\n", ALLOCINFO_FILE_NAME);
>> +               shutdown_mem_profiling(false);
>> +               WRITE_ONCE(alloc_tag_cttype, NULL);
>> +               synchronize_rcu();
>> +               codetag_unregister_type(cttype);
>> +               free_mod_tags_mem();
>> +               return -ENOMEM;
>> +       }
>> +
>>         return 0;
>>  }
>>  module_init(alloc_tag_init);
>> diff --git a/mm/show_mem.c b/mm/show_mem.c
>> index b938cbcd774a..a2e710404a48 100644
>> --- a/mm/show_mem.c
>> +++ b/mm/show_mem.c
>> @@ -439,7 +439,7 @@ void __show_mem(unsigned int filter, const nodemask_t *nodemask,
>>                 struct codetag_bytes tags[10];
>>                 size_t i, nr;
>>
>> -               nr = alloc_tag_top_users(tags, ARRAY_SIZE(tags), false);
>> +               nr = alloc_tag_top_users(tags, ARRAY_SIZE(tags));
>>                 if (nr) {
>>                         pr_notice("Memory allocations (profiling is currently turned %s):\n",
>>                                 mem_alloc_profiling_enabled() ? "on" : "off");
>> --
>> 2.25.1
>>

