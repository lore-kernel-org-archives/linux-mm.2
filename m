Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6349FCD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 02:53:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B27CC6B008C; Mon, 18 May 2026 22:53:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFEA26B0092; Mon, 18 May 2026 22:53:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A14816B0093; Mon, 18 May 2026 22:53:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8F89C6B008C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 22:53:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 45F6D1C026E
	for <linux-mm@kvack.org>; Tue, 19 May 2026 02:53:08 +0000 (UTC)
X-FDA: 84782647656.06.25CE66C
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf18.hostedemail.com (Postfix) with ESMTP id 06DB71C0009
	for <linux-mm@kvack.org>; Tue, 19 May 2026 02:53:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FMiZajGo;
	spf=pass (imf18.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779159186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZhSe7EF8jKr6zX/CoCmPe82XnXTiCTnwbuDcj7k1W6I=;
	b=7mGf5g0toczJfmGVdA6Qp2oiWS8kMQ+D5tG8p0ogvxZLeeyTAnYkGOEd2XwCuguphJP4mz
	Lqw6yZrTbwu8fI2cQC9hXV2HQx1hZjKV5opSz9je/2cEU8lgp9xMBMIBUAORTje0bDEVFY
	2hWetCXhWg4m6q92CQRyk83oIlSufA4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FMiZajGo;
	spf=pass (imf18.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779159186; a=rsa-sha256;
	cv=none;
	b=481anOxJgpDaqwlp8aQc6GtAUbAle2OjVU4eeif2l5P2/lbtC6s0XYMqCCzLXUuxDGJBiH
	CMKf2iAQ/7P4fWJspPl9/lH0FLEbJqx9OsD5KM4aSPvdjhP/IRB8Rd+pm/NgyOG89OQkze
	taI4f5/aoMkT/9KaFVxQG05NrQsUohA=
Message-ID: <c627136d-8060-4e2d-8473-0fe322ce1e6c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779159182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZhSe7EF8jKr6zX/CoCmPe82XnXTiCTnwbuDcj7k1W6I=;
	b=FMiZajGoH2qCEZ6ljm1Wc1NNkryTBnwl7aDcHNwHVqBuTRNDgoMQ/1ofhwf1RLMBVamIyU
	5hC71RyhcNzuAUbm/+kY30ClZwMc3Ox5GO/vXwW6IzRDnSZ1ngtVqhme4dwIAc/dN5EF1P
	FaYKt5xRiTar+a+2nf1WxrQ+oDGVKhc=
Date: Tue, 19 May 2026 10:52:09 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/6] alloc_tag: add ioctl to /proc/allocinfo
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Sourav Panda <souravpanda@google.com>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
References: <cover.1777936301.git.abhishekbapat@google.com>
 <d064a1a8de127c0e321f675a9966e533a0917e7e.1777936301.git.abhishekbapat@google.com>
 <2f546525-8ff6-4bbe-86ae-6f474f7cefe3@linux.dev>
 <CAL41Mv7zCEFUAD43wBRo+rno2AK-teUUaVSdx2Pd7qDU0uNwsg@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAL41Mv7zCEFUAD43wBRo+rno2AK-teUUaVSdx2Pd7qDU0uNwsg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: x4u4eoosrzk5yjt1wxyp5u5qs983qc1q
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 06DB71C0009
X-Rspam-User: 
X-HE-Tag: 1779159185-575659
X-HE-Meta: U2FsdGVkX19f48tz1GQc8hdAhmIu9J8l9V5XyH1QnmkRCXW9P/rkx0+GBfo0V3XsIIpDegaw6seyNu1PUmw6tbduG4xQd+mkbPj1rLHw0mr8r1mdxeMDbCCJXNoPwbe18bmW/M8uLn/Z3AAyEON1lJqXTd1fBVd5dGkByDCAyyXzbZWZrhWgKQEnP/e35wYASAoSSZE2+HB6SWVZgEeO+EtcIgGkVdmYHlTf+UyWyrdS3/jwGcpYj1xLzqUL6CtjJOKbBMbsOqb1/g1SIMNZYtHigPtR4fUFAaduAt6UTOXrvbvBnyQfj1k9azYmCj9sWdos44gUynLUcYFyM9niyqKSXeH6GfPG4gdgrK1jyiB+Ef2op33V16DEinIywHI3nQgmsAPfYRUTIKB0i1kz8AKkZQrncOE7sUEG6gK5JfxdM1RPOW3Qe5Ma76RnUoGkPi/TQH+eSvqVNjZFN7FEE7/A7cYUVtfC/wsfIfd68NSW3yVfo5PTruE8UhnQI4vV5FOoA2uyP+N35qeSyG5pTYq5aPMlVIVvwWG8x1hXxQU2joCGiUctRYDxWDS9tf/+KiI2xl9A6QztLtMl+lFwFD1fmtO4fDAdDfHj9fruUDVHu7DVj4djR3w8buuZTz1NkMi5EFDB9tpWvm0lvdx7CLvh7Tp9CWY/1PJz+GbUW28fYqcMGtBRERxJr+PVtbDwlbkLz84x/X1Wm0wHnvwWSfD6N3lpdVY0NFF1YsN72FeGbddJPHnH7oJCCsiqGo9nK4q0wdvtNT2Lfz2Ta4vX2bSCI9EpAQsdRHho4FiaiQCmTQuPsI4KMERsvmN8U8zUMiXzCB9hZ8NjjvxHSUYa7GBjbba/bHu6TrOzm5BMN70nkyTTL8M/FWlzjL8yxqTzPiHINVlRVjDnsr5uJi4FRN9oJa/j6MH6a39t8pgZknaW2yqtwMJAQDXFqR5MM/kk9UpAbkmMW3xlODyfWiI
 ezh3CJkA
 eFzBKBabgasWTWpxzY4xHEYJFGUYYuonin5yoeLw4X0RmFdozFqRuWP03zqSueiQmDN7lDVohrGHLdtUiSuNjZp/URRaGBkGBwSp/l5uzyOURk0d+q92I+7OblbP/U+wL9cTI1LuSGb2EoNY/fi2cHiPbW9MjEFOfKsFdqypBkJtl7XniuLWAF1jStWo/NYZT4/xgjgF0VnzTq5BCBHfXvireaVrREhOK8PZ7Swk+SYreA2jDtVJEVJ08wI+nsEee16x717nLUnUlLiqbxjlYVkA+O+xoQy0ZXrMgAb7s/GTR0LXo2IlpvnKpf5C9Qph53CFl+fTKK9UVy3M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Abhishek


Thanks for the follow-up.


On 2026/5/19 07:41, Abhishek Bapat wrote:
> On Wed, May 13, 2026 at 9:38 PM Hao Ge<hao.ge@linux.dev>  wrote:
>> Hi Suren and Abhishek
>>
>>
>> Thanks for the patch! A couple of minor comments below.
>>
>>
>> On 2026/5/5 07:36, Abhishek Bapat wrote:
>>> From: Suren Baghdasaryan<surenb@google.com>
>>>
>>> Add the following ioctl commands for /proc/allocinfo file:
>>>
>>> ALLOCINFO_IOC_CONTENT_ID - gets content identifier which can be used
>>> to check whether the file content has changed specifically due to module
>>> load/unload. Every time a module is loaded / unloaded, the returned
>>> value will be different. By comparing the identifier value at the
>>> beginning and at the end of the content retrieval operation, users can
>>> validate retrieved information for consistency.
>>>
>>> ALLOCINFO_IOC_GET_AT - gets the record at the specified position. This
>>> is the position of a record in /proc/allocinfo.
>>>
>>> ALLOCINFO_IOC_GET_NEXT - gets the record next to the last retrieved
>>> one. If no records were previously retrieved, returns the first
>>> record.
>>>
>>> Signed-off-by: Suren Baghdasaryan<surenb@google.com>
>>> Signed-off-by: Abhishek Bapat<abhishekbapat@google.com>
>>> ---
>>>    .../userspace-api/ioctl/ioctl-number.rst      |   2 +
>>>    include/linux/codetag.h                       |   1 +
>>>    include/uapi/linux/alloc_tag.h                |  54 ++++++
>>>    lib/alloc_tag.c                               | 178 +++++++++++++++++-
>>>    lib/codetag.c                                 |  11 ++
>>>    5 files changed, 244 insertions(+), 2 deletions(-)
>>>    create mode 100644 include/uapi/linux/alloc_tag.h
>>>
>>> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
>>> index 331223761fff..84f6808a8578 100644
>>> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
>>> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
>>> @@ -349,6 +349,8 @@ Code  Seq#    Include File                                             Comments
>>>                                                                           <mailto:luzmaximilian@gmail.com>
>>>    0xA5  20-2F  linux/surface_aggregator/dtx.h                            Microsoft Surface DTX driver
>>>                                                                           <mailto:luzmaximilian@gmail.com>
>>> +0xA6  00-0F  uapi/linux/alloc_tag.h                                    Memory allocation profiling
>>> +<mailto:surenb@google.com>
>>>    0xAA  00-3F  linux/uapi/linux/userfaultfd.h
>>>    0xAB  00-1F  linux/nbd.h
>>>    0xAC  00-1F  linux/raw.h
>>> diff --git a/include/linux/codetag.h b/include/linux/codetag.h
>>> index 8ea2a5f7c98a..2bcd4e7c809e 100644
>>> --- a/include/linux/codetag.h
>>> +++ b/include/linux/codetag.h
>>> @@ -76,6 +76,7 @@ struct codetag_iterator {
>>>
>>>    void codetag_lock_module_list(struct codetag_type *cttype, bool lock);
>>>    bool codetag_trylock_module_list(struct codetag_type *cttype);
>>> +unsigned long codetag_get_content_id(struct codetag_type *cttype);
>>>    struct codetag_iterator codetag_get_ct_iter(struct codetag_type *cttype);
>>>    struct codetag *codetag_next_ct(struct codetag_iterator *iter);
>>>
>>> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
>>> new file mode 100644
>>> index 000000000000..e9a5b55fcc7a
>>> --- /dev/null
>>> +++ b/include/uapi/linux/alloc_tag.h
>>> @@ -0,0 +1,54 @@
>>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>>> +/*
>>> + *  include/linux/alloc_tag.h
>>> + */
>>> +
>>> +#ifndef _UAPI_ALLOC_TAG_H
>>> +#define _UAPI_ALLOC_TAG_H
>>> +
>>> +#include <linux/types.h>
>>> +
>>> +#define ALLOCINFO_STR_SIZE   64
>>> +
>>> +struct allocinfo_content_id {
>>> +     __u64 id;
>>> +};
>>> +
>>> +struct allocinfo_tag {
>>> +     /* Longer names are trimmed */
>>> +     char modname[ALLOCINFO_STR_SIZE];
>>> +     char function[ALLOCINFO_STR_SIZE];
>>> +     char filename[ALLOCINFO_STR_SIZE];
>>> +     __u64 lineno;
>>> +};
>>> +
>>> +struct allocinfo_counter {
>>> +     __u64 bytes;
>>> +     __u64 calls;
>>> +     __u8 accurate;
>>> +     __u8 pad[7]; /* Add alignment to not break the 32-bit compatible interface */
>>> +};
>>> +
>>> +struct allocinfo_tag_data {
>>> +     struct allocinfo_tag tag;
>>> +     struct allocinfo_counter counter;
>>> +};
>>> +
>>> +struct allocinfo_get_at {
>>> +     __u64 pos;      /* input */
>>> +     struct allocinfo_tag_data data;
>>> +};
>>> +
>>> +#define _ALLOCINFO_IOC_CONTENT_ID    0
>>> +#define _ALLOCINFO_IOC_GET_AT                1
>>> +#define _ALLOCINFO_IOC_GET_NEXT              2
>>> +
>>> +#define ALLOCINFO_IOC_BASE           0xA6
>>> +#define ALLOCINFO_IOC_CONTENT_ID     _IOR(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_CONTENT_ID,     \
>>> +                                          struct allocinfo_content_id)
>>> +#define ALLOCINFO_IOC_GET_AT         _IOWR(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_GET_AT,        \
>>> +                                           struct allocinfo_get_at)
>>> +#define ALLOCINFO_IOC_GET_NEXT               _IOR(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_GET_NEXT,       \
>>> +                                          struct allocinfo_tag_data)
>>> +
>>> +#endif /* _UAPI_ALLOC_TAG_H */
>>> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
>>> index ed1bdcf1f8ab..5c24d2f954d4 100644
>>> --- a/lib/alloc_tag.c
>>> +++ b/lib/alloc_tag.c
>>> @@ -14,6 +14,7 @@
>>>    #include <linux/string_choices.h>
>>>    #include <linux/vmalloc.h>
>>>    #include <linux/kmemleak.h>
>>> +#include <uapi/linux/alloc_tag.h>
>>>
>>>    #define ALLOCINFO_FILE_NAME         "allocinfo"
>>>    #define MODULE_ALLOC_TAG_VMAP_SIZE  (100000UL * sizeof(struct alloc_tag))
>>> @@ -46,6 +47,9 @@ int alloc_tag_ref_offs;
>>>    struct allocinfo_private {
>>>        struct codetag_iterator iter;
>>>        bool print_header;
>>> +     /* ioctl uses a separate iterator not to interfere with reads */
>>> +     struct codetag_iterator ioctl_iter;
>>> +     bool positioned; /* seq_open_private() sets to 0 */
>>>    };
>>>
>>>    static void *allocinfo_start(struct seq_file *m, loff_t *pos)
>>> @@ -125,6 +129,177 @@ static const struct seq_operations allocinfo_seq_op = {
>>>        .show   = allocinfo_show,
>>>    };
>>>
>>> +static int allocinfo_open(struct inode *inode, struct file *file)
>>> +{
>>> +     return seq_open_private(file, &allocinfo_seq_op,
>>> +                             sizeof(struct allocinfo_private));
>>> +}
>>> +
>>> +static int allocinfo_release(struct inode *inode, struct file *file)
>>> +{
>>> +     return seq_release_private(inode, file);
>>> +}
>>> +
>>> +static const char *allocinfo_str(const char *str)
>>> +{
>>> +     size_t len = strlen(str);
>>> +
>>> +     /* Keep an extra space for the trailing NULL. */
>>> +     if (len >= ALLOCINFO_STR_SIZE)
>>> +             str += (len - ALLOCINFO_STR_SIZE) + 1;
>>> +     return str;
>>> +}
>>> +
>>> +/* Copy a string and trim from the beginning if it's too long */
>>> +static void allocinfo_copy_str(char *dest, const char *src)
>>> +{
>>> +     strscpy(dest, allocinfo_str(src), ALLOCINFO_STR_SIZE);
>>> +}
>>> +
>>> +static void allocinfo_to_params(struct codetag *ct,
>>> +                             struct allocinfo_tag_data *data)
>>> +{
>>> +     struct alloc_tag *tag = ct_to_alloc_tag(ct);
>>> +     struct alloc_tag_counters counter = alloc_tag_read(tag);
>>> +
>>> +     if (ct->modname)
>>> +             allocinfo_copy_str(data->tag.modname, ct->modname);
>>> +     else
>>> +             data->tag.modname[0] = '\0';
>> Minor nit about allocinfo_to_params():
>>
>> When modname is NULL (built-in kernel code), the current code sets it
>>
>> to an empty string:
>>
>>       if (ct->modname)
>>
>>           allocinfo_copy_str(data->tag.modname, ct->modname);
>>
>>       else
>>
>>           data->tag.modname[0] = '\0';
>>
>> This is of course workable in userspace by checking for an empty
>>
>> string, but I was wondering if it would be cleaner to use "vmlinux"
>>
>> as a default:
>>
>> else
>>
>>             allocinfo_copy_str(data->tag.modname, "vmlinux");
>>
>>
>> For some context, in our memory analysis workflow we often group
>>
>> allocations by module to get a quick overview of where memory goes,
>>
>> for example:
>>
>> vmlinux:    2.1 GB    (kernel core)
>>
>> nvidia:     1.2 GB    (GPU driver)
>>
>> iwlwifi:    800 MB    (WiFi driver)
>>
>> ext4:       500 MB    (filesystem)
>>
>> Having a consistent identifier for kernel built-in allocations would
>>
>> avoid each userspace tool needing to handle the empty string as a
>>
>> special case. Totally fine if this is intentional though.
>>
> Thanks for bringing this up, I can certainly make this change.
> However, the information is not currently exposed this way through
> /proc/allocinfo. /proc/allocinfo does not categorize kernel non-module
> allocations as vmlinux, so there will a delta between how IOCTL and
> /proc/allocinfo behave. Suren, could you comment on whether this
> recommendation is fine by you?
>
Right, /proc/allocinfo indeed doesn't categorize them as vmlinux currently.

It's just that in practice we often group allocations by module, so 
having "vmlinux" as a default

would be convenient. Let's wait for Suren's input.

>>> +     allocinfo_copy_str(data->tag.function, ct->function);
>>> +     allocinfo_copy_str(data->tag.filename, ct->filename);
>>> +     data->tag.lineno = ct->lineno;
>>> +     data->counter.bytes = counter.bytes;
>>> +     data->counter.calls = counter.calls;
>>> +     data->counter.accurate = !alloc_tag_is_inaccurate(tag);
>>> +}
>>> +
>>> +static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __user *arg)
>>> +{
>>> +     struct allocinfo_content_id params;
>>> +
>>> +     codetag_lock_module_list(alloc_tag_cttype, true);
>>> +     params.id = codetag_get_content_id(alloc_tag_cttype);
>>> +     codetag_lock_module_list(alloc_tag_cttype, false);
>>> +     if (copy_to_user(arg, &params, sizeof(params)))
>>> +             return -EFAULT;
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
>>> +{
>>> +     struct allocinfo_private *priv;
>>> +     struct codetag *ct;
>>> +     __u64 pos;
>>> +     struct allocinfo_get_at params = {0};
>>> +
>>> +     if (copy_from_user(&params, arg, sizeof(params)))
>>> +             return -EFAULT;
>>> +
>>> +     priv = (struct allocinfo_private *)m->private;
>>> +     pos = params.pos;
>>> +
>>> +     codetag_lock_module_list(alloc_tag_cttype, true);
>>> +
>>> +     /* Find the codetag */
>>> +     priv->ioctl_iter = codetag_get_ct_iter(alloc_tag_cttype);
>>> +     ct = codetag_next_ct(&priv->ioctl_iter);
>>> +     while (ct && pos--)
>>> +             ct = codetag_next_ct(&priv->ioctl_iter);
>> I noticed that codetag_next_ct(&priv->ioctl_iter) and
>>
>> priv->positioned are accessed without serialization in the ioctl
>>
>> path. Concurrent ioctl calls on the same fd could race on these
>>
>> fields. Just something I spotted while reading the code.
>>
>>
>> Thanks
>>
>> Best Regards
>>
>> Hao
>>
> I believe this should be prevented by `codetag_lock_module_list`; am I
> wrong in my understanding?

Thanks for the explanation! codetag_lock_module_list is designed to 
protect the module list from concurrent load/unload, which it does

correctly. However, it doesn't cover the race between concurrent ioctl 
calls on the same fd, since it acquires cttype->mod_lock via

down_read() and rwsem read locks allow multiple readers to proceed 
concurrently:

Thread A: ALLOCINFO_IOC_GET_AT

down_read(&cttype->mod_lock)              // read lock acquired

priv->ioctl_iter = codetag_get_ct_iter(...)

ct = codetag_next_ct(&priv->ioctl_iter)

priv->positioned = true;

Thread B: ALLOCINFO_IOC_GET_NEXT            // concurrent ioctl on same fd

down_read(&cttype->mod_lock)              // read locks don't exclude 
each other

if (!priv->positioned) {                  // sees partial state from 
Thread A

priv->ioctl_iter = ...                // overwrites Thread A's iterator

}

ct = codetag_next_ct(&priv->ioctl_iter)   // corrupted iterator

priv->ioctl_iter and priv->positioned are per-fd state with no 
serialization in the ioctl path.

Just something I spotted.

Thanks

Best Regards

Hao

>>> +     if (ct) {
>>> +             allocinfo_to_params(ct, &params.data);
>>> +             priv->positioned = true;
>>> +     }
>>> +
>>> +     codetag_lock_module_list(alloc_tag_cttype, false);
>>> +
>>> +     if (!ct)
>>> +             return -ENOENT;
>>> +
>>> +     if (copy_to_user(arg, &params, sizeof(params)))
>>> +             return -EFAULT;
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
>>> +{
>>> +     struct allocinfo_private *priv;
>>> +     struct codetag *ct;
>>> +     struct allocinfo_tag_data params = {0};
>>> +     int ret = 0;
>>> +
>>> +     priv = (struct allocinfo_private *)m->private;
>>> +
>>> +     codetag_lock_module_list(alloc_tag_cttype, true);
>>> +
>>> +     if (!priv->positioned) {
>>> +             priv->ioctl_iter = codetag_get_ct_iter(alloc_tag_cttype);
>>> +             priv->positioned = true;
>>> +     }
>>> +
>>> +     ct = codetag_next_ct(&priv->ioctl_iter);
>>> +     if (ct)
>>> +             allocinfo_to_params(ct, &params);
>>> +
>>> +     if (!ct) {
>>> +             priv->positioned = false;
>>> +             ret = -ENOENT;
>>> +     }
>>> +     codetag_lock_module_list(alloc_tag_cttype, false);
>>> +
>>> +     if (ret == 0) {
>>> +             if (copy_to_user(arg, &params, sizeof(params)))
>>> +                     return -EFAULT;
>>> +     }
>>> +     return ret;
>>> +}
>>> +
>>> +static long allocinfo_ioctl(struct file *file, unsigned int cmd,
>>> +                         unsigned long __arg)
>>> +{
>>> +     void __user *arg = (void __user *)__arg;
>>> +     int ret;
>>> +
>>> +     switch (cmd) {
>>> +     case ALLOCINFO_IOC_CONTENT_ID:
>>> +             ret = allocinfo_ioctl_get_content_id(file->private_data, arg);
>>> +             break;
>>> +     case ALLOCINFO_IOC_GET_AT:
>>> +             ret = allocinfo_ioctl_get_at(file->private_data, arg);
>>> +             break;
>>> +     case ALLOCINFO_IOC_GET_NEXT:
>>> +             ret = allocinfo_ioctl_get_next(file->private_data, arg);
>>> +             break;
>>> +     default:
>>> +             ret = -ENOIOCTLCMD;
>>> +             break;
>>> +     }
>>> +
>>> +     return ret;
>>> +}
>>> +
>>> +#ifdef CONFIG_COMPAT
>>> +static long allocinfo_compat_ioctl(struct file *file, unsigned int cmd,
>>> +                                unsigned long arg)
>>> +{
>>> +     return allocinfo_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
>>> +}
>>> +#endif
>>> +
>>> +static const struct proc_ops allocinfo_proc_ops = {
>>> +     .proc_open              = allocinfo_open,
>>> +     .proc_read_iter         = seq_read_iter,
>>> +     .proc_lseek             = seq_lseek,
>>> +     .proc_release           = allocinfo_release,
>>> +     .proc_ioctl             = allocinfo_ioctl,
>>> +#ifdef CONFIG_COMPAT
>>> +     .proc_compat_ioctl      = allocinfo_compat_ioctl,
>>> +#endif
>>> +
>>> +};
>>> +
>>>    size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count, bool can_sleep)
>>>    {
>>>        struct codetag_iterator iter;
>>> @@ -946,8 +1121,7 @@ static int __init alloc_tag_init(void)
>>>                return 0;
>>>        }
>>>
>>> -     if (!proc_create_seq_private(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_seq_op,
>>> -                                  sizeof(struct allocinfo_private), NULL)) {
>>> +     if (!proc_create(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_proc_ops)) {
>>>                pr_err("Failed to create %s file\n", ALLOCINFO_FILE_NAME);
>>>                shutdown_mem_profiling(false);
>>>                return -ENOMEM;
>>> diff --git a/lib/codetag.c b/lib/codetag.c
>>> index 304667897ad4..93aa30991563 100644
>>> --- a/lib/codetag.c
>>> +++ b/lib/codetag.c
>>> @@ -48,6 +48,17 @@ bool codetag_trylock_module_list(struct codetag_type *cttype)
>>>        return down_read_trylock(&cttype->mod_lock) != 0;
>>>    }
>>>
>>> +unsigned long codetag_get_content_id(struct codetag_type *cttype)
>>> +{
>>> +     lockdep_assert_held(&cttype->mod_lock);
>>> +
>>> +     /*
>>> +      * next_mod_seq is updated on every load, so can be used to identify
>>> +      * content changes.
>>> +      */
>>> +     return cttype->next_mod_seq;
>>> +}
>>> +
>>>    struct codetag_iterator codetag_get_ct_iter(struct codetag_type *cttype)
>>>    {
>>>        struct codetag_iterator iter = {
> Note, I will be following up with a v2 patchset with your feedback
> included. Please bring up any other points you'd want to clarify so
> that I can include all the changes in the v2 patchset. Thanks for
> reviewing!

