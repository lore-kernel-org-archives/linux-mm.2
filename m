Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A994CD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 01:44:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C6CC6B0005; Mon,  8 Jun 2026 21:44:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 177736B0088; Mon,  8 Jun 2026 21:44:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 066686B008A; Mon,  8 Jun 2026 21:44:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E687B6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:44:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6CD62C19E6
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 01:44:02 +0000 (UTC)
X-FDA: 84858678324.06.4682D3C
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id DC8ADC000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 01:43:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k6Q9WdvM;
	spf=pass (imf10.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780969440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KN2NpTJpJ6jSCQrNwdqnWftbSZQXv3T7wLZL+abW+Ds=;
	b=3NFnAVmd6cuGIL2rf2RRjdjQgmECOGbofPiHNL+EFUTAHtAevYXAtzX2Xk3iK7Lk+M4Vik
	kqlqP45um0bjrrVgfzliNRAYVN73i+hVoNWbq57CST3scC+Un74o69Mcm8r0mJRHX7b/Bn
	ZFvyY/h5+BmyJsgs7+bZo+one5tR3eM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780969440;
	b=MmQaFkSjw56OccaE0FryAlfF23J/MbxxwXlT0h4oakdS7Mlb3Mm1NCMrdo0UhTfExAJJfi
	syVJUUTOnRkhRJ8eAiKa9+L9XnR0Jd+KA/i9gYfbIAgJFTtDEQ5rcG4sGBLXyKPb/UnbUZ
	5ge/KCWzj01/nYNCBR3QXot4roooGmc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k6Q9WdvM;
	spf=pass (imf10.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <2b7fa423-c721-4157-96ba-93bee5010044@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780969437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KN2NpTJpJ6jSCQrNwdqnWftbSZQXv3T7wLZL+abW+Ds=;
	b=k6Q9WdvM8HuZyQdPUOsfaVbJ1UgmF1LGHvXePtAJuA0I+QODdwbKHO3L0DEA6/YFqwMA4Z
	BTiDK7/2SvVFuaptwYYKRrx9iuWiWQnwWQfVhy5WqS1E1/MVWO9xKcWK7rq4uWQD3PIffS
	HyxDrPjyVpAezLlUh2OdXu6csZeciNw=
Date: Tue, 9 Jun 2026 09:43:16 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 1/6] alloc_tag: add ioctl to /proc/allocinfo
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Sourav Panda <souravpanda@google.com>
References: <cover.1780701922.git.abhishekbapat@google.com>
 <0e91fdd3a88dbe5220d15c4c8ff7b8f66e86af7c.1780701922.git.abhishekbapat@google.com>
 <41a7ebb9-1113-4f13-abbf-6f55d99d62f3@linux.dev>
 <CAL41Mv7jOJ0rtAEDZP2DEGa5d1GfTbK=DXg8k1BL5qjFuQjNuA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAL41Mv7jOJ0rtAEDZP2DEGa5d1GfTbK=DXg8k1BL5qjFuQjNuA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: DC8ADC000A
X-Rspam-User: 
X-Stat-Signature: 68dnrryqwjt55cpiy8zs7sqkdh4cbaka
X-Rspamd-Server: rspam08
X-HE-Tag: 1780969439-809
X-HE-Meta: U2FsdGVkX1+aF/nnrrxMHTSdayJG7C+f8GBOM/WYMH0J48KtQu9QJWD+Iu4CafUzwiJP+hVa5Yi4JaBKeZ4a50xcOxwCkmM/PmGeJkcNOwVTNGvqKNgOUnsrqgcuGkV/tnJsBLgcLwslsFpzNjrfvXlNuWe/5CvYRs8uZGHDG5dhtT+IyAqwSULuI4OAdnian1cfnGfTiAL9EIrfcONjDMkpcdc6e+yXOy+rlb0s0dTAvDU2/QLZPcEQPb5LiEpXAGQk0X3/7NO0N0JjKLKc7evq5undBq0gYcnRl6UEJJYqmxDFFiascWUEOjNGYYWaaE8StOFO3x4+Byzt123ewFsNHUjWJYU0roSBvd03wF3Z4JT+S/+pdQ/h6Apr7l6MHPZXcLQ3ft9caj5ID0UVrzdXVRdaqDoPxQqq6OegKjPn7qHy03Gjy73ZrS+pN/TMalF+ZD+7LrgV+BEx3Ff7EqfgrMoTbPEjNfBIcfPF+IUW+ciSoP25gGqa6xMNqGvzCYAZPVXO+cm2y1Aafjec9CIbRXyoRnOFLB8GBm9R/qjFdhJ0C+vlxWwel5aTliiSOlr7KbHk8RNks40l/iJ3N3CvFJqdcikN08F3xDzyOWAKgsWU7rBFMP0SyeKSBlqB68QPaPveBz1Mi4txFvB1BBCd8dD0NrUE0TfFmTuGLjTH2G0g22WXzIvypn2qkSkR7nyN2S/dE/CXAcib49RculqlTLm+6EyEV59WS0dRXX+5feJnhXq30g0QHiZ1DvzaVktFlytAXIzh4z3h7QKP661Z4O4r5VnOtVv0Ff9wq0K5B8X5XodzfmiToRGpbYg8QJu6a6FU9ihnRlzQlTKCBwOb7fNzkHLM+OS/+PRZooKYpV+PSv0mVzFSMIM6bRC6/pF5RLk53jDlz8ukvEiVyYWvnEzjNHC4IQg3nYUR3lRLI9l65wD8nRwbX2oETEiL+V1Uv3tAnCy/ozMKkyg
 JoSTFAS5
 1R7s5K/WDXopQ4z7UwACs/yfVx7LI4FJGqLCHACdapruqPtW6p/X5Wn52nvm7SwMOuRNut1NPOP4Ybs6T6leFpCIbE2c3J14zSakDngGSZO32DB/yn90TIZrh3hKAsb8yeM40PzbM/pJzKpevqMl9JzcRZxsLAqnl+1EnGBhrH53gsN+grAXkbOPRDKbLXE2LR36lyYcwEyUREuhk7gfsb1wl2qGnXjTeQ1e/lS7+E9Eb6bvZ+KWJBcFKlk8lNHMzNPmBxT4tiNLSVvRZJSNMWbgnTaeiPgQwMtanCiiTHWHqt7x8d8nZQr+H5dep17hHzjwNtwMtF6PABWc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Abhishek


On 2026/6/9 08:19, Abhishek Bapat wrote:
> On Sun, Jun 7, 2026 at 6:53 PM Hao Ge <hao.ge@linux.dev> wrote:
>> Hi Suren and Abhishek
>>
>>
>> Thanks for the new version.
>>
>>
>> On 2026/6/6 07:36, Abhishek Bapat wrote:
>>> From: Suren Baghdasaryan <surenb@google.com>
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
>>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>>> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
>>> ---
>>>    Documentation/mm/allocation-profiling.rst     |   5 +
>>>    .../userspace-api/ioctl/ioctl-number.rst      |   2 +
>>>    MAINTAINERS                                   |   1 +
>>>    include/linux/codetag.h                       |   2 +
>>>    include/uapi/linux/alloc_tag.h                |  54 ++++
>>>    lib/alloc_tag.c                               | 232 +++++++++++++++++-
>>>    lib/codetag.c                                 |  18 ++
>>>    7 files changed, 312 insertions(+), 2 deletions(-)
>>>    create mode 100644 include/uapi/linux/alloc_tag.h
>>>
>>> diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm/allocation-profiling.rst
>>> index 5389d241176a..c3a28467955f 100644
>>> --- a/Documentation/mm/allocation-profiling.rst
>>> +++ b/Documentation/mm/allocation-profiling.rst
>>> @@ -46,6 +46,11 @@ sysctl:
>>>    Runtime info:
>>>      /proc/allocinfo
>>>
>>> +  Profiling data can be retrieved either by reading `/proc/allocinfo` directly as
>>> +  text or programmatically via `ioctl()` calls defined in `<uapi/linux/alloc_tag.h>`.
>>> +  The ioctl interface supports structured binary data extraction as well as filtering
>>> +  by module name, function, file, line number, accuracy, or allocation size limits.
>>> +
>>>    Example output::
>>>
>>>      root@moria-kvm:~# sort -g /proc/allocinfo|tail|numfmt --to=iec
>>> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
>>> index 331223761fff..84f6808a8578 100644
>>> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
>>> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
>>> @@ -349,6 +349,8 @@ Code  Seq#    Include File                                             Comments
>>>                                                                           <mailto:luzmaximilian@gmail.com>
>>>    0xA5  20-2F  linux/surface_aggregator/dtx.h                            Microsoft Surface DTX driver
>>>                                                                           <mailto:luzmaximilian@gmail.com>
>>> +0xA6  00-0F  uapi/linux/alloc_tag.h                                    Memory allocation profiling
>>> +                                                                       <mailto:surenb@google.com>
>>>    0xAA  00-3F  linux/uapi/linux/userfaultfd.h
>>>    0xAB  00-1F  linux/nbd.h
>>>    0xAC  00-1F  linux/raw.h
>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>> index a31f6f207afd..77f3fc487691 100644
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -16711,6 +16711,7 @@ S:    Maintained
>>>    F:  Documentation/mm/allocation-profiling.rst
>>>    F:  include/linux/alloc_tag.h
>>>    F:  include/linux/pgalloc_tag.h
>>> +F:   include/uapi/linux/alloc_tag.h
>>>    F:  lib/alloc_tag.c
>>>
>>>    MEMORY CONTROLLER DRIVERS
>>> diff --git a/include/linux/codetag.h b/include/linux/codetag.h
>>> index ddae7484ca45..a25a085c2df1 100644
>>> --- a/include/linux/codetag.h
>>> +++ b/include/linux/codetag.h
>>> @@ -77,6 +77,8 @@ struct codetag_iterator {
>>>    void codetag_lock_module_list(struct codetag_type *cttype);
>>>    bool codetag_trylock_module_list(struct codetag_type *cttype);
>>>    void codetag_unlock_module_list(struct codetag_type *cttype);
>>> +unsigned long codetag_get_content_id(struct codetag_type *cttype);
>>> +unsigned int codetag_get_count(struct codetag_type *cttype);
>>>    struct codetag_iterator codetag_get_ct_iter(struct codetag_type *cttype);
>>>    struct codetag *codetag_next_ct(struct codetag_iterator *iter);
>>>
>>> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
>>> new file mode 100644
>>> index 000000000000..901199bad514
>>> --- /dev/null
>>> +++ b/include/uapi/linux/alloc_tag.h
>>> @@ -0,0 +1,54 @@
>>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>>> +/*
>>> + *  include/linux/alloc_tag.h
>> nit: it should be include/uapi/linux/alloc_tag.h
>>
>> (I guess you may have missed the comment I brought up before. It is not
>> a critical problem though.)
>>
> Apologies, I missed that comment earlier. Included in the v4 patchset.
> Thanks for bringing this up.
>
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
>>> +/* The alignment ensures 32-bit compatible interfaces are not broken */
>>> +struct allocinfo_counter {
>>> +     __u64 bytes;
>>> +     __u64 calls;
>>> +     __u8 accurate;
>>> +} __attribute__((aligned(8)));
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
>>> index d9be1cf5187d..a0577215eb3d 100644
>>> --- a/lib/alloc_tag.c
>>> +++ b/lib/alloc_tag.c
>>> @@ -5,6 +5,7 @@
>>>    #include <linux/gfp.h>
>>>    #include <linux/kallsyms.h>
>>>    #include <linux/module.h>
>>> +#include <linux/mutex.h>
>>>    #include <linux/page_ext.h>
>>>    #include <linux/pgalloc_tag.h>
>>>    #include <linux/proc_fs.h>
>>> @@ -14,6 +15,7 @@
>>>    #include <linux/string_choices.h>
>>>    #include <linux/vmalloc.h>
>>>    #include <linux/kmemleak.h>
>>> +#include <uapi/linux/alloc_tag.h>
>>>
>>>    #define ALLOCINFO_FILE_NAME         "allocinfo"
>>>    #define MODULE_ALLOC_TAG_VMAP_SIZE  (100000UL * sizeof(struct alloc_tag))
>>> @@ -47,6 +49,10 @@ struct allocinfo_private {
>>>        struct codetag_iterator iter;
>>>        struct codetag_iterator reported_iter;
>>>        bool print_header;
>>> +     /* ioctl uses a separate iterator not to interfere with reads */
>>> +     struct codetag_iterator ioctl_iter;
>>> +     bool positioned; /* seq_open_private() sets to 0 */
>>> +     struct mutex ioctl_lock;
>>>    };
>>>
>>>    static void *allocinfo_start(struct seq_file *m, loff_t *pos)
>>> @@ -130,6 +136,229 @@ static const struct seq_operations allocinfo_seq_op = {
>>>        .show   = allocinfo_show,
>>>    };
>>>
>>> +/*
>>> + * Initializes seq_file operations and allocates private state when opening
>>> + * the /proc/allocinfo procfs entry.
>>> + */
>>> +static int allocinfo_open(struct inode *inode, struct file *file)
>>> +{
>>> +     int ret;
>>> +
>>> +     ret = seq_open_private(file, &allocinfo_seq_op,
>>> +                            sizeof(struct allocinfo_private));
>>> +     if (!ret) {
>>> +             struct seq_file *m = file->private_data;
>>> +             struct allocinfo_private *priv = m->private;
>>> +
>>> +             mutex_init(&priv->ioctl_lock);
>>> +     }
>>> +     return ret;
>>> +}
>>> +
>>> +/*
>>> + * Cleans up the seq_file state and frees up the private state allocated in
>>> + * allocinfo_open() when closing the /proc/allocinfo file descriptor.
>>> + */
>>> +static int allocinfo_release(struct inode *inode, struct file *file)
>>> +{
>>> +     return seq_release_private(inode, file);
>>> +}
>>> +
>>> +/*
>>> + * Returns a pointer to the suffix of a string so that its length fits within
>>> + * ALLOCINFO_STR_SIZE, preserving the trailing characters.
>>> + */
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
>>> +     strscpy_pad(dest, allocinfo_str(src), ALLOCINFO_STR_SIZE);
>>> +}
>>> +
>>> +/*
>>> + * Populates the UAPI allocinfo_tag_data structure with active runtime
>>> + * profiling counters extracted from the given kernel codetag.
>>> + */
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
>>> +     allocinfo_copy_str(data->tag.function, ct->function);
>>> +     allocinfo_copy_str(data->tag.filename, ct->filename);
>>> +     data->tag.lineno = ct->lineno;
>>> +     data->counter.bytes = counter.bytes;
>>> +     data->counter.calls = counter.calls;
>>> +     data->counter.accurate = !alloc_tag_is_inaccurate(tag);
>>> +}
>>> +
>>> +/*
>>> + * Retrieves the unique content ID representing the current allocation tag module
>>> + * layout, allowing userspace to detect if modules were loaded / unloaded.
>>> + */
>>> +static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __user *arg)
>>> +{
>>> +     struct allocinfo_content_id params;
>>> +
>>> +     codetag_lock_module_list(alloc_tag_cttype);
>>> +     params.id = codetag_get_content_id(alloc_tag_cttype);
>>> +     codetag_unlock_module_list(alloc_tag_cttype);
>>> +     if (copy_to_user(arg, &params, sizeof(params)))
>>> +             return -EFAULT;
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +/*
>>> + * Seeks the ioctl iterator to the specified 0-indexed tag position, reads its
>>> + * profiling data and returns it to userspace.
>>> + */
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
>>> +     priv = m->private;
>>> +     pos = params.pos;
>>> +
>>> +     mutex_lock(&priv->ioctl_lock);
>>> +     codetag_lock_module_list(alloc_tag_cttype);
>>> +
>>> +     if (pos >= codetag_get_count(alloc_tag_cttype)) {
>>> +             codetag_unlock_module_list(alloc_tag_cttype);
>>> +             mutex_unlock(&priv->ioctl_lock);
>>> +             return -ENOENT;
>>> +     }
>>> +
>>> +     /* Find the codetag */
>>> +     priv->ioctl_iter = codetag_get_ct_iter(alloc_tag_cttype);
>>> +     ct = codetag_next_ct(&priv->ioctl_iter);
>>> +     while (ct && pos--)
>>> +             ct = codetag_next_ct(&priv->ioctl_iter);
>>> +     if (ct) {
>>> +             allocinfo_to_params(ct, &params.data);
>>> +             priv->positioned = true;
>>> +     }
>>> +
>>> +     codetag_unlock_module_list(alloc_tag_cttype);
>>> +     mutex_unlock(&priv->ioctl_lock);
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
>>> +/*
>>> + * Advances the ioctl iterator to the next allocation tag in the sequence and
>>> + * returns its profiling data to userspace.
>>> + */
>>> +static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
>>> +{
>>> +     struct allocinfo_private *priv;
>>> +     struct codetag *ct;
>>> +     struct allocinfo_tag_data params;
>>> +     int ret = 0;
>>> +
>>> +     memset(&params, 0, sizeof(params));
>>> +     priv = m->private;
>>> +
>>> +     mutex_lock(&priv->ioctl_lock);
>>> +     codetag_lock_module_list(alloc_tag_cttype);
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
>>> +     codetag_unlock_module_list(alloc_tag_cttype);
>>> +     mutex_unlock(&priv->ioctl_lock);
>>> +
>>> +     if (ret == 0) {
>>> +             if (copy_to_user(arg, &params, sizeof(params)))
>>> +                     return -EFAULT;
>>> +     }
>>> +     return ret;
>>> +}
>>> +
>>> +/*
>>> + * Entry point ioctl function for /proc/allocinfo routing requests to fetch the
>>> + * layout content ID, seek to a specific tag, or read sequential tags.
>>> + */
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
>>> @@ -993,8 +1222,7 @@ static int __init alloc_tag_init(void)
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
>>> index 4001a7ea6675..a9cda4c962a3 100644
>>> --- a/lib/codetag.c
>>> +++ b/lib/codetag.c
>>> @@ -19,6 +19,8 @@ struct codetag_type {
>>>        struct codetag_type_desc desc;
>>>        /* generates unique sequence number for module load */
>>>        unsigned long next_mod_seq;
>>> +     /* bumped on every module load and unload */
>>> +     unsigned long content_id;
>>>    };
>>>
>>>    struct codetag_range {
>>> @@ -50,6 +52,20 @@ void codetag_unlock_module_list(struct codetag_type *cttype)
>>>        up_read(&cttype->mod_lock);
>>>    }
>>>
>>> +unsigned long codetag_get_content_id(struct codetag_type *cttype)
>>> +{
>>> +     lockdep_assert_held(&cttype->mod_lock);
>>> +
>>> +     return cttype->content_id;
>>> +}
>>> +
>>> +unsigned int codetag_get_count(struct codetag_type *cttype)
>>> +{
>>> +     lockdep_assert_held(&cttype->mod_lock);
>>> +
>>> +     return cttype->count;
>>> +}
>>> +
>>>    struct codetag_iterator codetag_get_ct_iter(struct codetag_type *cttype)
>>>    {
>>>        struct codetag_iterator iter = {
>>> @@ -204,6 +220,7 @@ static int codetag_module_init(struct codetag_type *cttype, struct module *mod)
>>>
>>>        down_write(&cttype->mod_lock);
>>>        cmod->mod_seq = ++cttype->next_mod_seq;
>>> +     ++cttype->content_id;
>> I have a comment on the content_id bump placement.
>>
>> ++cttype->content_id is placed before idr_alloc and the module_load
>>
>> callback. If idr_alloc fails or module_load returns an error
>>
>> (While the chance of this occurring is very low.), the idr entry gets
>>
>> rolled back but content_id has already been bumped. The actual
>>
>> content didn't change in this case, so userspace would see a
>>
>> different content_id and assume the data is inconsistent when it
>>
>> isn't.
>>
>>
>> Thanks
>>
>> Best Regards
>>
>> Hao
> While I agree with your comment, I decided to place the counter
> increment there because the chance of failure is low. Furthermore,
> even if it falsely invalidates user data, the user will simply query
> the content again. This placement also aligns with where the
> previously used field (cttype->next_mod_seq) was incremented. Let me
> know if you still think I should move it. Thanks!

Sorry, I should have marked this as a nit when I raised the comment.

Given its low probability of occurring, it doesn't block anything for now.

The reason I raised this comment was just in case someone adds new logic

in the feature  that could fail. But if that happens, we can move both 
next_mod_seq

and content_id down together.


Thanks

Best Regards

Hao

>>>        mod_id = idr_alloc(&cttype->mod_idr, cmod, 0, 0, GFP_KERNEL);
>>>        if (mod_id >= 0) {
>>>                if (cttype->desc.module_load) {
>>> @@ -368,6 +385,7 @@ void codetag_unload_module(struct module *mod)
>>>                        cttype->count -= range_size(cttype, &cmod->range);
>>>                        idr_remove(&cttype->mod_idr, mod_id);
>>>                        kfree(cmod);
>>> +                     ++cttype->content_id;
>>>                }
>>>                up_write(&cttype->mod_lock);
>>>                if (found && cttype->desc.free_section_mem)

