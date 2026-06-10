Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BCADCD8CA8
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 01:29:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7FA86B00BD; Tue,  9 Jun 2026 21:29:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B313A6B00BF; Tue,  9 Jun 2026 21:29:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A46EB6B00C0; Tue,  9 Jun 2026 21:29:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9250A6B00BD
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 21:29:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 64C2216516C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:29:09 +0000 (UTC)
X-FDA: 84862269618.15.AE8AC6F
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4D037140004
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:29:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A6KFAkQE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781054947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RbTmtyy/kYHDLjmastbXSmOvjGtY8NxOBSppkzk+hxs=;
	b=0xgnJp0t8tUfuZwHFgLyzgRMJHm6qRMH/HXZl0fvoH2sBd8KduUdVT9VrcyaY4fgtJF3rr
	mmwZi2gZDM1mhkQY3xND0MxZhmlsc08PiFcNiuaiSYd8pEUf3HBtdKtqWzgaYqXJKEP0rt
	rxGnar8PlCOF7peVI6L/+Y3fyxJNX0s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A6KFAkQE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781054947;
	b=IdBr8vAy+8A6BSKedn+pRJ8hbADqZ9TrgjexHXdY18OswK9uMHbgYqgWwFf2glyzrEkoTk
	vooojB4K1wVj1PigNX16xWhpgOe1a2fKaFjSKYI4taPNVz34njHy7r0+XErJLxmImHb9eY
	H4UYSuh9MByDec93RfSp0ASgdf0QuL8=
Message-ID: <b1f95dc3-0e9b-459e-8f7c-d85a38d647e1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781054945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RbTmtyy/kYHDLjmastbXSmOvjGtY8NxOBSppkzk+hxs=;
	b=A6KFAkQEZo+8Yc/swa9vPoRs5mOgKVIeZd42lTtzZ87BKjUbKBFt05ydqz3z5w9u0LQhkJ
	Lk4y+b5XmsFX9f6AixoorQnDL9uxPi+gZlBc+2ipRGJ0dSP6qXSIGc8fSFGomO8KAYol5t
	e0OPkyzJOVvoiPAclY22mzHVl2K7wxE=
Date: Wed, 10 Jun 2026 09:28:05 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 1/6] alloc_tag: add ioctl to /proc/allocinfo
To: Abhishek Bapat <abhishekbapat@google.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Sourav Panda <souravpanda@google.com>
References: <cover.1781042698.git.abhishekbapat@google.com>
 <b58a0d01c8bb6d7c1d2350599c1b0170be161489.1781042698.git.abhishekbapat@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <b58a0d01c8bb6d7c1d2350599c1b0170be161489.1781042698.git.abhishekbapat@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4D037140004
X-Stat-Signature: ijodbukfsukt99j195f8c48h1gpq5z9t
X-HE-Tag: 1781054947-342639
X-HE-Meta: U2FsdGVkX1/80jP+tR5/bB2C4jeMR0otPfV8Gt+XG+k6eWN0XyhnrdIlJSzpG6MCwmJ6c5tqa5a4EdiCePhm2PQGJlBr1xo7oGDAX8NzbvA9uq9C3msKZp6bE+nzxw5yn0FiqNpajRqXrBtw3QRfcd+K55UC6rDy3iNt2cV0icoO0bhhg9zISDhHSspy0cTO7G+HyN0TF8/qglNuuLyO2G0weq6kH8+wF13CGH/XDnLFEw4w7Mi9FvVWh3NFE5uE7FaScYofsbkNH4Nm2GKOQUEUuyfJHVtiRifxEN+LCORUTfUsLmbTRRjlgjWwl1QkkKoc899fzXXAmS2Cgjv0J2/XlYg5r1EKIXW46KVu7SlglVud/JMOAtk7v7axqQwhigJHaP/0V1hoWiGg1WUtrlUh7dLFf9lO8Y12lNkBCoCb0EjzC17IrtNfkwLx/xXdUamPV2yvzoRYnrIhuNYJ107ewksJgLWY0j997ZRVcxgO2u3c2dLQZzqSjmMdfsZb5qoYx1vgE2lHGl3uM+RUh470m71T6d/s0RfNqDGNI+ByYroc8klwpW/VuiddNRpJ84H5gWLE/747YQkj7Aa0SvRRi9NDNkemxvQzaa+jXFgPLKDKR0SHy7181MemcE/CyWfqHB4qMBwJwRYTAF6I5kEOIiWnEegg+v2Luhu9sv6u6yPmH3utmRzdlIjEJEVahcuufFYf+Pv9egsWjGl5QiO/9ysMBn1kS4SKRlxUe5oEiyqYzdQshVoi9Jx4a2O1X0A0rTuE6W0lfSY4BwEYhnIs4bOPpsQ5u26sJXloq9+7sl2CGzLRIKEpodz1lbYnOrOmMM7ig5Tt69lXcoWvonDItE/9gmXYOUrzQPwOcb33USXCoxD63Hl0Tf/WtkZvt5JUBCq7xIJSyfz0EAS8Nj/3byfnyBEDAmni97Wzin/sYAE+XN0F8wpQQ6Jl3i00mAG/U3VRM1nUjfMBxjM
 9BqA0Brq
 zoegGqpUDQyGAVdQxmZN/jYPSg0Oopd8oIFB6gGXiMpexR9BUQoJPa5BGEgP1Qt4lq26JWKisX35Nt5qCBgenAlR75TWmkJZMHTEnUTUu4wFmiS7GLJwBt/xKQJQ8QQlQnuJMYzmvsUxZgDre7rcntyEJUGS20ICq1KuDthDaVhFptdT90D9ftmJkeXIjmx+eldUGEYSfG4nN+KkqLk/bdssP45GKF9W8NbGrevJqCIg8gldqmYLupqIg42zpETdYNzwY0kD5Z9abJvAW9E74xYh5DbaK1PITwBX33/eCYWIEzHrMcP+8JkHvxk/U0uu3VcrY4HFch5uctCs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2026/6/10 08:12, Abhishek Bapat wrote:
> From: Suren Baghdasaryan <surenb@google.com>
>
> Add the following ioctl commands for /proc/allocinfo file:
>
> ALLOCINFO_IOC_CONTENT_ID - gets content identifier which can be used
> to check whether the file content has changed specifically due to module
> load/unload. Every time a module is loaded / unloaded, the returned
> value will be different. By comparing the identifier value at the
> beginning and at the end of the content retrieval operation, users can
> validate retrieved information for consistency.
>
> ALLOCINFO_IOC_GET_AT - gets the record at the specified position. This
> is the position of a record in /proc/allocinfo.
>
> ALLOCINFO_IOC_GET_NEXT - gets the record next to the last retrieved
> one. If no records were previously retrieved, returns the first
> record.
>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>


Acked-by: Hao Ge <hao.ge@linux.dev>


> ---
>   Documentation/mm/allocation-profiling.rst     |   5 +
>   .../userspace-api/ioctl/ioctl-number.rst      |   2 +
>   MAINTAINERS                                   |   1 +
>   include/linux/codetag.h                       |   2 +
>   include/uapi/linux/alloc_tag.h                |  60 +++++
>   lib/alloc_tag.c                               | 232 +++++++++++++++++-
>   lib/codetag.c                                 |  18 ++
>   7 files changed, 318 insertions(+), 2 deletions(-)
>   create mode 100644 include/uapi/linux/alloc_tag.h
>
> diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm/allocation-profiling.rst
> index 5389d241176a..c3a28467955f 100644
> --- a/Documentation/mm/allocation-profiling.rst
> +++ b/Documentation/mm/allocation-profiling.rst
> @@ -46,6 +46,11 @@ sysctl:
>   Runtime info:
>     /proc/allocinfo
>   
> +  Profiling data can be retrieved either by reading `/proc/allocinfo` directly as
> +  text or programmatically via `ioctl()` calls defined in `<uapi/linux/alloc_tag.h>`.
> +  The ioctl interface supports structured binary data extraction as well as filtering
> +  by module name, function, file, line number, accuracy, or allocation size limits.
> +
>   Example output::
>   
>     root@moria-kvm:~# sort -g /proc/allocinfo|tail|numfmt --to=iec
> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
> index 331223761fff..84f6808a8578 100644
> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> @@ -349,6 +349,8 @@ Code  Seq#    Include File                                             Comments
>                                                                          <mailto:luzmaximilian@gmail.com>
>   0xA5  20-2F  linux/surface_aggregator/dtx.h                            Microsoft Surface DTX driver
>                                                                          <mailto:luzmaximilian@gmail.com>
> +0xA6  00-0F  uapi/linux/alloc_tag.h                                    Memory allocation profiling
> +                                                                       <mailto:surenb@google.com>
>   0xAA  00-3F  linux/uapi/linux/userfaultfd.h
>   0xAB  00-1F  linux/nbd.h
>   0xAC  00-1F  linux/raw.h
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 65bd4328fe05..019cc4c285a3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16713,6 +16713,7 @@ S:	Maintained
>   F:	Documentation/mm/allocation-profiling.rst
>   F:	include/linux/alloc_tag.h
>   F:	include/linux/pgalloc_tag.h
> +F:	include/uapi/linux/alloc_tag.h
>   F:	lib/alloc_tag.c
>   
>   MEMORY CONTROLLER DRIVERS
> diff --git a/include/linux/codetag.h b/include/linux/codetag.h
> index ddae7484ca45..a25a085c2df1 100644
> --- a/include/linux/codetag.h
> +++ b/include/linux/codetag.h
> @@ -77,6 +77,8 @@ struct codetag_iterator {
>   void codetag_lock_module_list(struct codetag_type *cttype);
>   bool codetag_trylock_module_list(struct codetag_type *cttype);
>   void codetag_unlock_module_list(struct codetag_type *cttype);
> +unsigned long codetag_get_content_id(struct codetag_type *cttype);
> +unsigned int codetag_get_count(struct codetag_type *cttype);
>   struct codetag_iterator codetag_get_ct_iter(struct codetag_type *cttype);
>   struct codetag *codetag_next_ct(struct codetag_iterator *iter);
>   
> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
> new file mode 100644
> index 000000000000..0928e1a48d49
> --- /dev/null
> +++ b/include/uapi/linux/alloc_tag.h
> @@ -0,0 +1,60 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/*
> + * alloc_tag IOCTL API definition
> + *
> + * Copyright (C) 2026 Google, LLC.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef _UAPI_ALLOC_TAG_H
> +#define _UAPI_ALLOC_TAG_H
> +
> +#include <linux/types.h>
> +
> +#define ALLOCINFO_STR_SIZE	64
> +
> +struct allocinfo_content_id {
> +	__u64 id;
> +};
> +
> +struct allocinfo_tag {
> +	/* Longer names are trimmed */
> +	char modname[ALLOCINFO_STR_SIZE];
> +	char function[ALLOCINFO_STR_SIZE];
> +	char filename[ALLOCINFO_STR_SIZE];
> +	__u64 lineno;
> +};
> +
> +/* The alignment ensures 32-bit compatible interfaces are not broken */
> +struct allocinfo_counter {
> +	__u64 bytes;
> +	__u64 calls;
> +	__u8 accurate;
> +} __attribute__((aligned(8)));
> +
> +struct allocinfo_tag_data {
> +	struct allocinfo_tag tag;
> +	struct allocinfo_counter counter;
> +};
> +
> +struct allocinfo_get_at {
> +	__u64 pos;	/* input */
> +	struct allocinfo_tag_data data;
> +};
> +
> +#define _ALLOCINFO_IOC_CONTENT_ID	0
> +#define _ALLOCINFO_IOC_GET_AT		1
> +#define _ALLOCINFO_IOC_GET_NEXT		2
> +
> +#define ALLOCINFO_IOC_BASE		0xA6
> +#define ALLOCINFO_IOC_CONTENT_ID	_IOR(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_CONTENT_ID,	\
> +					     struct allocinfo_content_id)
> +#define ALLOCINFO_IOC_GET_AT		_IOWR(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_GET_AT,	\
> +					      struct allocinfo_get_at)
> +#define ALLOCINFO_IOC_GET_NEXT		_IOR(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_GET_NEXT,	\
> +					     struct allocinfo_tag_data)
> +
> +#endif /* _UAPI_ALLOC_TAG_H */
> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> index d9be1cf5187d..a0577215eb3d 100644
> --- a/lib/alloc_tag.c
> +++ b/lib/alloc_tag.c
> @@ -5,6 +5,7 @@
>   #include <linux/gfp.h>
>   #include <linux/kallsyms.h>
>   #include <linux/module.h>
> +#include <linux/mutex.h>
>   #include <linux/page_ext.h>
>   #include <linux/pgalloc_tag.h>
>   #include <linux/proc_fs.h>
> @@ -14,6 +15,7 @@
>   #include <linux/string_choices.h>
>   #include <linux/vmalloc.h>
>   #include <linux/kmemleak.h>
> +#include <uapi/linux/alloc_tag.h>
>   
>   #define ALLOCINFO_FILE_NAME		"allocinfo"
>   #define MODULE_ALLOC_TAG_VMAP_SIZE	(100000UL * sizeof(struct alloc_tag))
> @@ -47,6 +49,10 @@ struct allocinfo_private {
>   	struct codetag_iterator iter;
>   	struct codetag_iterator reported_iter;
>   	bool print_header;
> +	/* ioctl uses a separate iterator not to interfere with reads */
> +	struct codetag_iterator ioctl_iter;
> +	bool positioned; /* seq_open_private() sets to 0 */
> +	struct mutex ioctl_lock;
>   };
>   
>   static void *allocinfo_start(struct seq_file *m, loff_t *pos)
> @@ -130,6 +136,229 @@ static const struct seq_operations allocinfo_seq_op = {
>   	.show	= allocinfo_show,
>   };
>   
> +/*
> + * Initializes seq_file operations and allocates private state when opening
> + * the /proc/allocinfo procfs entry.
> + */
> +static int allocinfo_open(struct inode *inode, struct file *file)
> +{
> +	int ret;
> +
> +	ret = seq_open_private(file, &allocinfo_seq_op,
> +			       sizeof(struct allocinfo_private));
> +	if (!ret) {
> +		struct seq_file *m = file->private_data;
> +		struct allocinfo_private *priv = m->private;
> +
> +		mutex_init(&priv->ioctl_lock);
> +	}
> +	return ret;
> +}
> +
> +/*
> + * Cleans up the seq_file state and frees up the private state allocated in
> + * allocinfo_open() when closing the /proc/allocinfo file descriptor.
> + */
> +static int allocinfo_release(struct inode *inode, struct file *file)
> +{
> +	return seq_release_private(inode, file);
> +}
> +
> +/*
> + * Returns a pointer to the suffix of a string so that its length fits within
> + * ALLOCINFO_STR_SIZE, preserving the trailing characters.
> + */
> +static const char *allocinfo_str(const char *str)
> +{
> +	size_t len = strlen(str);
> +
> +	/* Keep an extra space for the trailing NULL. */
> +	if (len >= ALLOCINFO_STR_SIZE)
> +		str += (len - ALLOCINFO_STR_SIZE) + 1;
> +	return str;
> +}
> +
> +/* Copy a string and trim from the beginning if it's too long */
> +static void allocinfo_copy_str(char *dest, const char *src)
> +{
> +	strscpy_pad(dest, allocinfo_str(src), ALLOCINFO_STR_SIZE);
> +}
> +
> +/*
> + * Populates the UAPI allocinfo_tag_data structure with active runtime
> + * profiling counters extracted from the given kernel codetag.
> + */
> +static void allocinfo_to_params(struct codetag *ct,
> +				struct allocinfo_tag_data *data)
> +{
> +	struct alloc_tag *tag = ct_to_alloc_tag(ct);
> +	struct alloc_tag_counters counter = alloc_tag_read(tag);
> +
> +	if (ct->modname)
> +		allocinfo_copy_str(data->tag.modname, ct->modname);
> +	else
> +		data->tag.modname[0] = '\0';
> +	allocinfo_copy_str(data->tag.function, ct->function);
> +	allocinfo_copy_str(data->tag.filename, ct->filename);
> +	data->tag.lineno = ct->lineno;
> +	data->counter.bytes = counter.bytes;
> +	data->counter.calls = counter.calls;
> +	data->counter.accurate = !alloc_tag_is_inaccurate(tag);
> +}
> +
> +/*
> + * Retrieves the unique content ID representing the current allocation tag module
> + * layout, allowing userspace to detect if modules were loaded / unloaded.
> + */
> +static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __user *arg)
> +{
> +	struct allocinfo_content_id params;
> +
> +	codetag_lock_module_list(alloc_tag_cttype);
> +	params.id = codetag_get_content_id(alloc_tag_cttype);
> +	codetag_unlock_module_list(alloc_tag_cttype);
> +	if (copy_to_user(arg, &params, sizeof(params)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +/*
> + * Seeks the ioctl iterator to the specified 0-indexed tag position, reads its
> + * profiling data and returns it to userspace.
> + */
> +static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
> +{
> +	struct allocinfo_private *priv;
> +	struct codetag *ct;
> +	__u64 pos;
> +	struct allocinfo_get_at params = {0};
> +
> +	if (copy_from_user(&params, arg, sizeof(params)))
> +		return -EFAULT;
> +
> +	priv = m->private;
> +	pos = params.pos;
> +
> +	mutex_lock(&priv->ioctl_lock);
> +	codetag_lock_module_list(alloc_tag_cttype);
> +
> +	if (pos >= codetag_get_count(alloc_tag_cttype)) {
> +		codetag_unlock_module_list(alloc_tag_cttype);
> +		mutex_unlock(&priv->ioctl_lock);
> +		return -ENOENT;
> +	}
> +
> +	/* Find the codetag */
> +	priv->ioctl_iter = codetag_get_ct_iter(alloc_tag_cttype);
> +	ct = codetag_next_ct(&priv->ioctl_iter);
> +	while (ct && pos--)
> +		ct = codetag_next_ct(&priv->ioctl_iter);
> +	if (ct) {
> +		allocinfo_to_params(ct, &params.data);
> +		priv->positioned = true;
> +	}
> +
> +	codetag_unlock_module_list(alloc_tag_cttype);
> +	mutex_unlock(&priv->ioctl_lock);
> +
> +	if (!ct)
> +		return -ENOENT;
> +
> +	if (copy_to_user(arg, &params, sizeof(params)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +/*
> + * Advances the ioctl iterator to the next allocation tag in the sequence and
> + * returns its profiling data to userspace.
> + */
> +static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
> +{
> +	struct allocinfo_private *priv;
> +	struct codetag *ct;
> +	struct allocinfo_tag_data params;
> +	int ret = 0;
> +
> +	memset(&params, 0, sizeof(params));
> +	priv = m->private;
> +
> +	mutex_lock(&priv->ioctl_lock);
> +	codetag_lock_module_list(alloc_tag_cttype);
> +
> +	if (!priv->positioned) {
> +		priv->ioctl_iter = codetag_get_ct_iter(alloc_tag_cttype);
> +		priv->positioned = true;
> +	}
> +
> +	ct = codetag_next_ct(&priv->ioctl_iter);
> +	if (ct)
> +		allocinfo_to_params(ct, &params);
> +
> +	if (!ct) {
> +		priv->positioned = false;
> +		ret = -ENOENT;
> +	}
> +	codetag_unlock_module_list(alloc_tag_cttype);
> +	mutex_unlock(&priv->ioctl_lock);
> +
> +	if (ret == 0) {
> +		if (copy_to_user(arg, &params, sizeof(params)))
> +			return -EFAULT;
> +	}
> +	return ret;
> +}
> +
> +/*
> + * Entry point ioctl function for /proc/allocinfo routing requests to fetch the
> + * layout content ID, seek to a specific tag, or read sequential tags.
> + */
> +static long allocinfo_ioctl(struct file *file, unsigned int cmd,
> +			    unsigned long __arg)
> +{
> +	void __user *arg = (void __user *)__arg;
> +	int ret;
> +
> +	switch (cmd) {
> +	case ALLOCINFO_IOC_CONTENT_ID:
> +		ret = allocinfo_ioctl_get_content_id(file->private_data, arg);
> +		break;
> +	case ALLOCINFO_IOC_GET_AT:
> +		ret = allocinfo_ioctl_get_at(file->private_data, arg);
> +		break;
> +	case ALLOCINFO_IOC_GET_NEXT:
> +		ret = allocinfo_ioctl_get_next(file->private_data, arg);
> +		break;
> +	default:
> +		ret = -ENOIOCTLCMD;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +#ifdef CONFIG_COMPAT
> +static long allocinfo_compat_ioctl(struct file *file, unsigned int cmd,
> +				   unsigned long arg)
> +{
> +	return allocinfo_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
> +}
> +#endif
> +
> +static const struct proc_ops allocinfo_proc_ops = {
> +	.proc_open		= allocinfo_open,
> +	.proc_read_iter		= seq_read_iter,
> +	.proc_lseek		= seq_lseek,
> +	.proc_release		= allocinfo_release,
> +	.proc_ioctl		= allocinfo_ioctl,
> +#ifdef CONFIG_COMPAT
> +	.proc_compat_ioctl	= allocinfo_compat_ioctl,
> +#endif
> +
> +};
> +
>   size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count, bool can_sleep)
>   {
>   	struct codetag_iterator iter;
> @@ -993,8 +1222,7 @@ static int __init alloc_tag_init(void)
>   		return 0;
>   	}
>   
> -	if (!proc_create_seq_private(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_seq_op,
> -				     sizeof(struct allocinfo_private), NULL)) {
> +	if (!proc_create(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_proc_ops)) {
>   		pr_err("Failed to create %s file\n", ALLOCINFO_FILE_NAME);
>   		shutdown_mem_profiling(false);
>   		return -ENOMEM;
> diff --git a/lib/codetag.c b/lib/codetag.c
> index 4001a7ea6675..a9cda4c962a3 100644
> --- a/lib/codetag.c
> +++ b/lib/codetag.c
> @@ -19,6 +19,8 @@ struct codetag_type {
>   	struct codetag_type_desc desc;
>   	/* generates unique sequence number for module load */
>   	unsigned long next_mod_seq;
> +	/* bumped on every module load and unload */
> +	unsigned long content_id;
>   };
>   
>   struct codetag_range {
> @@ -50,6 +52,20 @@ void codetag_unlock_module_list(struct codetag_type *cttype)
>   	up_read(&cttype->mod_lock);
>   }
>   
> +unsigned long codetag_get_content_id(struct codetag_type *cttype)
> +{
> +	lockdep_assert_held(&cttype->mod_lock);
> +
> +	return cttype->content_id;
> +}
> +
> +unsigned int codetag_get_count(struct codetag_type *cttype)
> +{
> +	lockdep_assert_held(&cttype->mod_lock);
> +
> +	return cttype->count;
> +}
> +
>   struct codetag_iterator codetag_get_ct_iter(struct codetag_type *cttype)
>   {
>   	struct codetag_iterator iter = {
> @@ -204,6 +220,7 @@ static int codetag_module_init(struct codetag_type *cttype, struct module *mod)
>   
>   	down_write(&cttype->mod_lock);
>   	cmod->mod_seq = ++cttype->next_mod_seq;
> +	++cttype->content_id;
>   	mod_id = idr_alloc(&cttype->mod_idr, cmod, 0, 0, GFP_KERNEL);
>   	if (mod_id >= 0) {
>   		if (cttype->desc.module_load) {
> @@ -368,6 +385,7 @@ void codetag_unload_module(struct module *mod)
>   			cttype->count -= range_size(cttype, &cmod->range);
>   			idr_remove(&cttype->mod_idr, mod_id);
>   			kfree(cmod);
> +			++cttype->content_id;
>   		}
>   		up_write(&cttype->mod_lock);
>   		if (found && cttype->desc.free_section_mem)

