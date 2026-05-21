Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 461B3CD5BA4
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 08:20:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E9E26B0088; Thu, 21 May 2026 04:20:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C7AC6B008A; Thu, 21 May 2026 04:20:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FEAD6B008C; Thu, 21 May 2026 04:20:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 502436B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:20:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F349B1C03A8
	for <linux-mm@kvack.org>; Thu, 21 May 2026 08:20:38 +0000 (UTC)
X-FDA: 84790730556.09.B426E2A
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id F315114000B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 08:20:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qR6G6bnN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779351637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6NlNc1+nwiZFZKoNjYUpUqID0zmi9l1jkEZN2iRwBig=;
	b=cezoT6BnlCrKYes9MI+DVJj/NlQbGeYjcNzHNggWVUNy5RctLUWfhi9shbYopdhsRmgmHn
	ZjuB9AbfL5JcJnCbM+hJFnOu8rIDBjndMrW3chYDcQHQB6sAuxdJOZYQPfxIYgFsvSpAIF
	J+j2o8CfP/VRo01Uk5+5g+h79Dgor4Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779351637; a=rsa-sha256;
	cv=none;
	b=1O42B6P9lu3GKDgq2IvCYjf6yA3g/lp1pAlaHnc2AqKcVtbGH2OcaTSKwfmIe6dJQY7nfP
	dOPjSLLHXVnv7LCbXYOptd+FREfDo06EVBRvRFaMVy/J2hsOgyYhuMENdbzaGb2Us8QjNO
	6Zwd/+TTfn/cuPi0DdN1kgyzwJBXvGA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qR6G6bnN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
Message-ID: <b15d5320-f3ce-4b69-b6e1-b422173acbf0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779351634;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6NlNc1+nwiZFZKoNjYUpUqID0zmi9l1jkEZN2iRwBig=;
	b=qR6G6bnNAnHQmudpOiI76lXzlTEEQG5ZwLoa9HgSekmeogYJrnyJnWMN/XhWfaVS7QMSUQ
	myLloL5quxGqy6LCkHBjz3OxleWhms6C4V5i7yfEe2Q5Ye2BOjwvLE+HVyKGlQbx84ELWZ
	/V0VvacCC/K0ihtpyh2DYoZnwN3DhLA=
Date: Thu, 21 May 2026 16:19:43 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/6] alloc_tag: add ioctl to /proc/allocinfo
To: Suren Baghdasaryan <surenb@google.com>,
 Abhishek Bapat <abhishekbapat@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Sourav Panda <souravpanda@google.com>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
References: <cover.1777936301.git.abhishekbapat@google.com>
 <d064a1a8de127c0e321f675a9966e533a0917e7e.1777936301.git.abhishekbapat@google.com>
 <2f546525-8ff6-4bbe-86ae-6f474f7cefe3@linux.dev>
 <CAL41Mv7zCEFUAD43wBRo+rno2AK-teUUaVSdx2Pd7qDU0uNwsg@mail.gmail.com>
 <c627136d-8060-4e2d-8473-0fe322ce1e6c@linux.dev>
 <CAJuCfpFn0Oefewvjp1jBhCOgxxwhHFy_RK08DwQywOjYcfr2pw@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpFn0Oefewvjp1jBhCOgxxwhHFy_RK08DwQywOjYcfr2pw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: F315114000B
X-Rspamd-Server: rspam04
X-Stat-Signature: rwmw6bzkm6oasriuhjtfc548f4g1exfe
X-HE-Tag: 1779351636-726165
X-HE-Meta: U2FsdGVkX1+TsDMqJosAaW7P2RdVGV6cCY/fqN5URKSByDzgIDMD3CLb0Z72U1JgZnuCsJjech7qZdwLD5SzOfW5lD1fmHoVgNY9yG36Cr3vJiC727Rn6Vpk5UYghNenuNabJ+aebq15vjjzGtBlaQlL73QiuZCdIVXE4/NzR6tUYXHkaa3gwcW9yUsHvG0nvlBggbqaKKHbm1VrX4R/I11tSYnXEuteUnfaOoP+4Ck10gZslAq+JU6WAfi/2UiGqj3ZJkFlfLEReU7+HSlY2jQVrIu071i4vwKSyBsrxqF6MW9RNorqR11Peb9WQMeuULw6J7HvqVRJrLA0IbHninFmS2iX8nJNNIO8yoPMA70DFO3uCBsAUvggv5AUtg9yyw/MqT+M8Zk1JZgudaM5CHJ0OPCIAG8fwF3GlU75pD1xI0zCt0SwnxYKDBVGIqSz2BsC+RZEjWk0rgyAyWcSq0HfFphLbSYvZinIQ4YnqGKtjRaSc4uBNLNLz69li58fhc4AZ9D7fKkclB2LwNHy68XQZaK4H0S5DsB2pay+rEd+ipnp4Iasy278lzn02sMy62G5j3VW4c09jernBrfO9h4yL4C4iyhiH34Udzqh4rd59GcCpvR3kHQBaA/eCkFl6qiOhUgV9suInAUDSbGh5SL/IcZpE67thxoD9ztP8BFQML6lOCCJcTVEk2lrRo05Xt2wgcEQwh8KWi7HAvKLkLdevs9I7UIyeK0yNtXL3+nOxNORDNw6Ztr5Z7Q4IKVUeVoCDyySvD0qHVkG4/rW6jUvf/WTpPsYGUWUCz7SpoJk7OshxW0c4IpGZRnmtgrRfuSCxGgsD3gF6IB/ZQb4ge6U+Mq2hrNghHQu4SgTm+0fKWOe0Hu0V5PvjncBjkKoXrkQq0YwmeftVI0UvmpkPCSJp3jcAFmjitRezWuk77r1tKQb9zUsZmUN1cgbgWQez8WR71f67PotUlVMZ67
 DINam8N6
 gyEUTAUm7vuoNuTvnEFpUiQ/7ejNupLR5Q1WaJmDeVVrQo6o6y7EhiVFEGc3xa7JTGYpIJNpQVum3LL1BjnlXu/pIi8Xgj4/jYJO8Y+Q2379LFeXWCQAmBaEXEE+FrMCXMviua7Av5BANGK94ZGC0CEkgrusf2LSuZb+sZdhnlSqCMwJX1HbNAEDdOCIqXIbMs6JFiSp3VqlcXQOxqbRkEDEGO08RTgYFpQJCQzdJU2i6QWWtytf+LOo8DLVTUpmfo/sGfKzGUp+X+vOVJnImSzO4atjjT9HLgtWPUV/ySAzfhbfP/Hpinoo+vMI3cT+g3Ne+myeJVup77j8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/5/20 01:42, Suren Baghdasaryan wrote:
> On Mon, May 18, 2026 at 7:53 PM Hao Ge <hao.ge@linux.dev> wrote:
>> Hi Abhishek
>>
>>
>> Thanks for the follow-up.
>>
>>
>> On 2026/5/19 07:41, Abhishek Bapat wrote:
>>> On Wed, May 13, 2026 at 9:38 PM Hao Ge<hao.ge@linux.dev>  wrote:
>>>> Hi Suren and Abhishek
>>>>
>>>>
>>>> Thanks for the patch! A couple of minor comments below.
>>>>
>>>>
>>>> On 2026/5/5 07:36, Abhishek Bapat wrote:
>>>>> From: Suren Baghdasaryan<surenb@google.com>
>>>>>
>>>>> Add the following ioctl commands for /proc/allocinfo file:
>>>>>
>>>>> ALLOCINFO_IOC_CONTENT_ID - gets content identifier which can be used
>>>>> to check whether the file content has changed specifically due to module
>>>>> load/unload. Every time a module is loaded / unloaded, the returned
>>>>> value will be different. By comparing the identifier value at the
>>>>> beginning and at the end of the content retrieval operation, users can
>>>>> validate retrieved information for consistency.
>>>>>
>>>>> ALLOCINFO_IOC_GET_AT - gets the record at the specified position. This
>>>>> is the position of a record in /proc/allocinfo.
>>>>>
>>>>> ALLOCINFO_IOC_GET_NEXT - gets the record next to the last retrieved
>>>>> one. If no records were previously retrieved, returns the first
>>>>> record.
>>>>>
>>>>> Signed-off-by: Suren Baghdasaryan<surenb@google.com>
>>>>> Signed-off-by: Abhishek Bapat<abhishekbapat@google.com>
>>>>> ---
>>>>>     .../userspace-api/ioctl/ioctl-number.rst      |   2 +
>>>>>     include/linux/codetag.h                       |   1 +
>>>>>     include/uapi/linux/alloc_tag.h                |  54 ++++++
>>>>>     lib/alloc_tag.c                               | 178 +++++++++++++++++-
>>>>>     lib/codetag.c                                 |  11 ++
>>>>>     5 files changed, 244 insertions(+), 2 deletions(-)
>>>>>     create mode 100644 include/uapi/linux/alloc_tag.h
>>>>>
>>>>> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
>>>>> index 331223761fff..84f6808a8578 100644
>>>>> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
>>>>> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
>>>>> @@ -349,6 +349,8 @@ Code  Seq#    Include File                                             Comments
>>>>>                                                                            <mailto:luzmaximilian@gmail.com>
>>>>>     0xA5  20-2F  linux/surface_aggregator/dtx.h                            Microsoft Surface DTX driver
>>>>>                                                                            <mailto:luzmaximilian@gmail.com>
>>>>> +0xA6  00-0F  uapi/linux/alloc_tag.h                                    Memory allocation profiling
>>>>> +<mailto:surenb@google.com>
>>>>>     0xAA  00-3F  linux/uapi/linux/userfaultfd.h
>>>>>     0xAB  00-1F  linux/nbd.h
>>>>>     0xAC  00-1F  linux/raw.h
>>>>> diff --git a/include/linux/codetag.h b/include/linux/codetag.h
>>>>> index 8ea2a5f7c98a..2bcd4e7c809e 100644
>>>>> --- a/include/linux/codetag.h
>>>>> +++ b/include/linux/codetag.h
>>>>> @@ -76,6 +76,7 @@ struct codetag_iterator {
>>>>>
>>>>>     void codetag_lock_module_list(struct codetag_type *cttype, bool lock);
>>>>>     bool codetag_trylock_module_list(struct codetag_type *cttype);
>>>>> +unsigned long codetag_get_content_id(struct codetag_type *cttype);
>>>>>     struct codetag_iterator codetag_get_ct_iter(struct codetag_type *cttype);
>>>>>     struct codetag *codetag_next_ct(struct codetag_iterator *iter);
>>>>>
>>>>> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
>>>>> new file mode 100644
>>>>> index 000000000000..e9a5b55fcc7a
>>>>> --- /dev/null
>>>>> +++ b/include/uapi/linux/alloc_tag.h
>>>>> @@ -0,0 +1,54 @@
>>>>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>>>>> +/*
>>>>> + *  include/linux/alloc_tag.h
>>>>> + */
>>>>> +
>>>>> +#ifndef _UAPI_ALLOC_TAG_H
>>>>> +#define _UAPI_ALLOC_TAG_H
>>>>> +
>>>>> +#include <linux/types.h>
>>>>> +
>>>>> +#define ALLOCINFO_STR_SIZE   64
>>>>> +
>>>>> +struct allocinfo_content_id {
>>>>> +     __u64 id;
>>>>> +};
>>>>> +
>>>>> +struct allocinfo_tag {
>>>>> +     /* Longer names are trimmed */
>>>>> +     char modname[ALLOCINFO_STR_SIZE];
>>>>> +     char function[ALLOCINFO_STR_SIZE];
>>>>> +     char filename[ALLOCINFO_STR_SIZE];
>>>>> +     __u64 lineno;
>>>>> +};
>>>>> +
>>>>> +struct allocinfo_counter {
>>>>> +     __u64 bytes;
>>>>> +     __u64 calls;
>>>>> +     __u8 accurate;
>>>>> +     __u8 pad[7]; /* Add alignment to not break the 32-bit compatible interface */
>>>>> +};
>>>>> +
>>>>> +struct allocinfo_tag_data {
>>>>> +     struct allocinfo_tag tag;
>>>>> +     struct allocinfo_counter counter;
>>>>> +};
>>>>> +
>>>>> +struct allocinfo_get_at {
>>>>> +     __u64 pos;      /* input */
>>>>> +     struct allocinfo_tag_data data;
>>>>> +};
>>>>> +
>>>>> +#define _ALLOCINFO_IOC_CONTENT_ID    0
>>>>> +#define _ALLOCINFO_IOC_GET_AT                1
>>>>> +#define _ALLOCINFO_IOC_GET_NEXT              2
>>>>> +
>>>>> +#define ALLOCINFO_IOC_BASE           0xA6
>>>>> +#define ALLOCINFO_IOC_CONTENT_ID     _IOR(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_CONTENT_ID,     \
>>>>> +                                          struct allocinfo_content_id)
>>>>> +#define ALLOCINFO_IOC_GET_AT         _IOWR(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_GET_AT,        \
>>>>> +                                           struct allocinfo_get_at)
>>>>> +#define ALLOCINFO_IOC_GET_NEXT               _IOR(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_GET_NEXT,       \
>>>>> +                                          struct allocinfo_tag_data)
>>>>> +
>>>>> +#endif /* _UAPI_ALLOC_TAG_H */
>>>>> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
>>>>> index ed1bdcf1f8ab..5c24d2f954d4 100644
>>>>> --- a/lib/alloc_tag.c
>>>>> +++ b/lib/alloc_tag.c
>>>>> @@ -14,6 +14,7 @@
>>>>>     #include <linux/string_choices.h>
>>>>>     #include <linux/vmalloc.h>
>>>>>     #include <linux/kmemleak.h>
>>>>> +#include <uapi/linux/alloc_tag.h>
>>>>>
>>>>>     #define ALLOCINFO_FILE_NAME         "allocinfo"
>>>>>     #define MODULE_ALLOC_TAG_VMAP_SIZE  (100000UL * sizeof(struct alloc_tag))
>>>>> @@ -46,6 +47,9 @@ int alloc_tag_ref_offs;
>>>>>     struct allocinfo_private {
>>>>>         struct codetag_iterator iter;
>>>>>         bool print_header;
>>>>> +     /* ioctl uses a separate iterator not to interfere with reads */
>>>>> +     struct codetag_iterator ioctl_iter;
>>>>> +     bool positioned; /* seq_open_private() sets to 0 */
>>>>>     };
>>>>>
>>>>>     static void *allocinfo_start(struct seq_file *m, loff_t *pos)
>>>>> @@ -125,6 +129,177 @@ static const struct seq_operations allocinfo_seq_op = {
>>>>>         .show   = allocinfo_show,
>>>>>     };
>>>>>
>>>>> +static int allocinfo_open(struct inode *inode, struct file *file)
>>>>> +{
>>>>> +     return seq_open_private(file, &allocinfo_seq_op,
>>>>> +                             sizeof(struct allocinfo_private));
>>>>> +}
>>>>> +
>>>>> +static int allocinfo_release(struct inode *inode, struct file *file)
>>>>> +{
>>>>> +     return seq_release_private(inode, file);
>>>>> +}
>>>>> +
>>>>> +static const char *allocinfo_str(const char *str)
>>>>> +{
>>>>> +     size_t len = strlen(str);
>>>>> +
>>>>> +     /* Keep an extra space for the trailing NULL. */
>>>>> +     if (len >= ALLOCINFO_STR_SIZE)
>>>>> +             str += (len - ALLOCINFO_STR_SIZE) + 1;
>>>>> +     return str;
>>>>> +}
>>>>> +
>>>>> +/* Copy a string and trim from the beginning if it's too long */
>>>>> +static void allocinfo_copy_str(char *dest, const char *src)
>>>>> +{
>>>>> +     strscpy(dest, allocinfo_str(src), ALLOCINFO_STR_SIZE);
>>>>> +}
>>>>> +
>>>>> +static void allocinfo_to_params(struct codetag *ct,
>>>>> +                             struct allocinfo_tag_data *data)
>>>>> +{
>>>>> +     struct alloc_tag *tag = ct_to_alloc_tag(ct);
>>>>> +     struct alloc_tag_counters counter = alloc_tag_read(tag);
>>>>> +
>>>>> +     if (ct->modname)
>>>>> +             allocinfo_copy_str(data->tag.modname, ct->modname);
>>>>> +     else
>>>>> +             data->tag.modname[0] = '\0';
>>>> Minor nit about allocinfo_to_params():
>>>>
>>>> When modname is NULL (built-in kernel code), the current code sets it
>>>>
>>>> to an empty string:
>>>>
>>>>        if (ct->modname)
>>>>
>>>>            allocinfo_copy_str(data->tag.modname, ct->modname);
>>>>
>>>>        else
>>>>
>>>>            data->tag.modname[0] = '\0';
>>>>
>>>> This is of course workable in userspace by checking for an empty
>>>>
>>>> string, but I was wondering if it would be cleaner to use "vmlinux"
>>>>
>>>> as a default:
>>>>
>>>> else
>>>>
>>>>              allocinfo_copy_str(data->tag.modname, "vmlinux");
>>>>
>>>>
>>>> For some context, in our memory analysis workflow we often group
>>>>
>>>> allocations by module to get a quick overview of where memory goes,
>>>>
>>>> for example:
>>>>
>>>> vmlinux:    2.1 GB    (kernel core)
>>>>
>>>> nvidia:     1.2 GB    (GPU driver)
>>>>
>>>> iwlwifi:    800 MB    (WiFi driver)
>>>>
>>>> ext4:       500 MB    (filesystem)
>>>>
>>>> Having a consistent identifier for kernel built-in allocations would
>>>>
>>>> avoid each userspace tool needing to handle the empty string as a
>>>>
>>>> special case. Totally fine if this is intentional though.
>>>>
>>> Thanks for bringing this up, I can certainly make this change.
>>> However, the information is not currently exposed this way through
>>> /proc/allocinfo. /proc/allocinfo does not categorize kernel non-module
>>> allocations as vmlinux, so there will a delta between how IOCTL and
>>> /proc/allocinfo behave. Suren, could you comment on whether this
>>> recommendation is fine by you?
>>>
>> Right, /proc/allocinfo indeed doesn't categorize them as vmlinux currently.
>>
>> It's just that in practice we often group allocations by module, so
>> having "vmlinux" as a default
>>
>> would be convenient. Let's wait for Suren's input.
> Hi Folks,
> I would prefer to keep it empty because vmlinux is not really a module
> and hardcoding this name also seems suboptimal (in case it ever
> changes). Empty string also aligns with how we output /proc/allocinfo
> data. If the symbol is in the kernel itself, we do not display the
> module name at all. So, all in all, unless there is a strong reason
> against it, I think we should keep it empty.

Hi Suren


Thanks for the clarification, that makes sense.

For userspace tools that want to group by module, we can always map an 
empty modname to "vmlinux" at the

presentation layer — no need to hardcode that in the kernel.


Hi Abhishek

I noticed the new files (like include/uapi/linux/alloc_tag.h) were added 
in this patchset.

Should they be reflected in the MAINTAINERS file for easier future 
maintenance?

Thanks

Best Regards

Hao

>>>>> +     allocinfo_copy_str(data->tag.function, ct->function);
>>>>> +     allocinfo_copy_str(data->tag.filename, ct->filename);
>>>>> +     data->tag.lineno = ct->lineno;
>>>>> +     data->counter.bytes = counter.bytes;
>>>>> +     data->counter.calls = counter.calls;
>>>>> +     data->counter.accurate = !alloc_tag_is_inaccurate(tag);
>>>>> +}
>>>>> +
>>>>> +static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __user *arg)
>>>>> +{
>>>>> +     struct allocinfo_content_id params;
>>>>> +
>>>>> +     codetag_lock_module_list(alloc_tag_cttype, true);
>>>>> +     params.id = codetag_get_content_id(alloc_tag_cttype);
>>>>> +     codetag_lock_module_list(alloc_tag_cttype, false);
>>>>> +     if (copy_to_user(arg, &params, sizeof(params)))
>>>>> +             return -EFAULT;
>>>>> +
>>>>> +     return 0;
>>>>> +}
>>>>> +
>>>>> +static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
>>>>> +{
>>>>> +     struct allocinfo_private *priv;
>>>>> +     struct codetag *ct;
>>>>> +     __u64 pos;
>>>>> +     struct allocinfo_get_at params = {0};
>>>>> +
>>>>> +     if (copy_from_user(&params, arg, sizeof(params)))
>>>>> +             return -EFAULT;
>>>>> +
>>>>> +     priv = (struct allocinfo_private *)m->private;
>>>>> +     pos = params.pos;
>>>>> +
>>>>> +     codetag_lock_module_list(alloc_tag_cttype, true);
>>>>> +
>>>>> +     /* Find the codetag */
>>>>> +     priv->ioctl_iter = codetag_get_ct_iter(alloc_tag_cttype);
>>>>> +     ct = codetag_next_ct(&priv->ioctl_iter);
>>>>> +     while (ct && pos--)
>>>>> +             ct = codetag_next_ct(&priv->ioctl_iter);
>>>> I noticed that codetag_next_ct(&priv->ioctl_iter) and
>>>>
>>>> priv->positioned are accessed without serialization in the ioctl
>>>>
>>>> path. Concurrent ioctl calls on the same fd could race on these
>>>>
>>>> fields. Just something I spotted while reading the code.
>>>>
>>>>
>>>> Thanks
>>>>
>>>> Best Regards
>>>>
>>>> Hao
>>>>
>>> I believe this should be prevented by `codetag_lock_module_list`; am I
>>> wrong in my understanding?
>> Thanks for the explanation! codetag_lock_module_list is designed to
>> protect the module list from concurrent load/unload, which it does
>>
>> correctly. However, it doesn't cover the race between concurrent ioctl
>> calls on the same fd, since it acquires cttype->mod_lock via
>>
>> down_read() and rwsem read locks allow multiple readers to proceed
>> concurrently:
>>
>> Thread A: ALLOCINFO_IOC_GET_AT
>>
>> down_read(&cttype->mod_lock)              // read lock acquired
>>
>> priv->ioctl_iter = codetag_get_ct_iter(...)
>>
>> ct = codetag_next_ct(&priv->ioctl_iter)
>>
>> priv->positioned = true;
>>
>> Thread B: ALLOCINFO_IOC_GET_NEXT            // concurrent ioctl on same fd
>>
>> down_read(&cttype->mod_lock)              // read locks don't exclude
>> each other
>>
>> if (!priv->positioned) {                  // sees partial state from
>> Thread A
>>
>> priv->ioctl_iter = ...                // overwrites Thread A's iterator
>>
>> }
>>
>> ct = codetag_next_ct(&priv->ioctl_iter)   // corrupted iterator
>>
>> priv->ioctl_iter and priv->positioned are per-fd state with no
>> serialization in the ioctl path.
> Yep, you are right. codetag_lock_module_list() is not enough here to
> protect from such races. I guess allocinfo_private would need another
> lock.
> Thanks,
> Suren.
>
>
>> Just something I spotted.
>>
>> Thanks
>>
>> Best Regards
>>
>> Hao
>>
>>>>> +     if (ct) {
>>>>> +             allocinfo_to_params(ct, &params.data);
>>>>> +             priv->positioned = true;
>>>>> +     }
>>>>> +
>>>>> +     codetag_lock_module_list(alloc_tag_cttype, false);
>>>>> +
>>>>> +     if (!ct)
>>>>> +             return -ENOENT;
>>>>> +
>>>>> +     if (copy_to_user(arg, &params, sizeof(params)))
>>>>> +             return -EFAULT;
>>>>> +
>>>>> +     return 0;
>>>>> +}
>>>>> +
>>>>> +static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
>>>>> +{
>>>>> +     struct allocinfo_private *priv;
>>>>> +     struct codetag *ct;
>>>>> +     struct allocinfo_tag_data params = {0};
>>>>> +     int ret = 0;
>>>>> +
>>>>> +     priv = (struct allocinfo_private *)m->private;
>>>>> +
>>>>> +     codetag_lock_module_list(alloc_tag_cttype, true);
>>>>> +
>>>>> +     if (!priv->positioned) {
>>>>> +             priv->ioctl_iter = codetag_get_ct_iter(alloc_tag_cttype);
>>>>> +             priv->positioned = true;
>>>>> +     }
>>>>> +
>>>>> +     ct = codetag_next_ct(&priv->ioctl_iter);
>>>>> +     if (ct)
>>>>> +             allocinfo_to_params(ct, &params);
>>>>> +
>>>>> +     if (!ct) {
>>>>> +             priv->positioned = false;
>>>>> +             ret = -ENOENT;
>>>>> +     }
>>>>> +     codetag_lock_module_list(alloc_tag_cttype, false);
>>>>> +
>>>>> +     if (ret == 0) {
>>>>> +             if (copy_to_user(arg, &params, sizeof(params)))
>>>>> +                     return -EFAULT;
>>>>> +     }
>>>>> +     return ret;
>>>>> +}
>>>>> +
>>>>> +static long allocinfo_ioctl(struct file *file, unsigned int cmd,
>>>>> +                         unsigned long __arg)
>>>>> +{
>>>>> +     void __user *arg = (void __user *)__arg;
>>>>> +     int ret;
>>>>> +
>>>>> +     switch (cmd) {
>>>>> +     case ALLOCINFO_IOC_CONTENT_ID:
>>>>> +             ret = allocinfo_ioctl_get_content_id(file->private_data, arg);
>>>>> +             break;
>>>>> +     case ALLOCINFO_IOC_GET_AT:
>>>>> +             ret = allocinfo_ioctl_get_at(file->private_data, arg);
>>>>> +             break;
>>>>> +     case ALLOCINFO_IOC_GET_NEXT:
>>>>> +             ret = allocinfo_ioctl_get_next(file->private_data, arg);
>>>>> +             break;
>>>>> +     default:
>>>>> +             ret = -ENOIOCTLCMD;
>>>>> +             break;
>>>>> +     }
>>>>> +
>>>>> +     return ret;
>>>>> +}
>>>>> +
>>>>> +#ifdef CONFIG_COMPAT
>>>>> +static long allocinfo_compat_ioctl(struct file *file, unsigned int cmd,
>>>>> +                                unsigned long arg)
>>>>> +{
>>>>> +     return allocinfo_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
>>>>> +}
>>>>> +#endif
>>>>> +
>>>>> +static const struct proc_ops allocinfo_proc_ops = {
>>>>> +     .proc_open              = allocinfo_open,
>>>>> +     .proc_read_iter         = seq_read_iter,
>>>>> +     .proc_lseek             = seq_lseek,
>>>>> +     .proc_release           = allocinfo_release,
>>>>> +     .proc_ioctl             = allocinfo_ioctl,
>>>>> +#ifdef CONFIG_COMPAT
>>>>> +     .proc_compat_ioctl      = allocinfo_compat_ioctl,
>>>>> +#endif
>>>>> +
>>>>> +};
>>>>> +
>>>>>     size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count, bool can_sleep)
>>>>>     {
>>>>>         struct codetag_iterator iter;
>>>>> @@ -946,8 +1121,7 @@ static int __init alloc_tag_init(void)
>>>>>                 return 0;
>>>>>         }
>>>>>
>>>>> -     if (!proc_create_seq_private(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_seq_op,
>>>>> -                                  sizeof(struct allocinfo_private), NULL)) {
>>>>> +     if (!proc_create(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_proc_ops)) {
>>>>>                 pr_err("Failed to create %s file\n", ALLOCINFO_FILE_NAME);
>>>>>                 shutdown_mem_profiling(false);
>>>>>                 return -ENOMEM;
>>>>> diff --git a/lib/codetag.c b/lib/codetag.c
>>>>> index 304667897ad4..93aa30991563 100644
>>>>> --- a/lib/codetag.c
>>>>> +++ b/lib/codetag.c
>>>>> @@ -48,6 +48,17 @@ bool codetag_trylock_module_list(struct codetag_type *cttype)
>>>>>         return down_read_trylock(&cttype->mod_lock) != 0;
>>>>>     }
>>>>>
>>>>> +unsigned long codetag_get_content_id(struct codetag_type *cttype)
>>>>> +{
>>>>> +     lockdep_assert_held(&cttype->mod_lock);
>>>>> +
>>>>> +     /*
>>>>> +      * next_mod_seq is updated on every load, so can be used to identify
>>>>> +      * content changes.
>>>>> +      */
>>>>> +     return cttype->next_mod_seq;
>>>>> +}
>>>>> +
>>>>>     struct codetag_iterator codetag_get_ct_iter(struct codetag_type *cttype)
>>>>>     {
>>>>>         struct codetag_iterator iter = {
>>> Note, I will be following up with a v2 patchset with your feedback
>>> included. Please bring up any other points you'd want to clarify so
>>> that I can include all the changes in the v2 patchset. Thanks for
>>> reviewing!

