Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 593EBCD5BAB
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 02:20:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4AEC6B0098; Sun, 24 May 2026 22:20:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFC2F6B0099; Sun, 24 May 2026 22:20:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B39816B009B; Sun, 24 May 2026 22:20:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F55B6B0098
	for <linux-mm@kvack.org>; Sun, 24 May 2026 22:20:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6A7B71C0C3B
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:20:55 +0000 (UTC)
X-FDA: 84804339270.15.9E8458A
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6DBA840006
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:20:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JJ5IzaFU;
	spf=pass (imf12.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779675653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=72J63drG56sfRi5dGjQE8gXc5sOOPTrEY6cYtD2rlWM=;
	b=Z/XK4CLhtaZtBoMiIdjbXWnMBWwfEggszq1/vwSP/gY0DOREaYrA5xw8okwUcvnihLgfN2
	IeU/mESatw8zmZN8zDdg/jWW0I123AnYkKCNJkl293Zx+m3Gk/r0FSCgRTNB5ZVNT8acjn
	EJOMP1CXLyT0h4mO4mbpTCUdd5/M1gE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JJ5IzaFU;
	spf=pass (imf12.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779675653; a=rsa-sha256;
	cv=none;
	b=Cxq3o1+Y3M6ee8tWZTYWaxpodCdrWo/3C4e0JG6SYEkDVqCCoLL8NWuzFCgKKMKQIOY4As
	qteAN1HBgu3dBwnafZwRkUd5zqaUvt2kgfSj0Rc0xLCtpIGyo+SKE00avUiU0EaNL+z0zz
	ov7rGfeeJDB9kFiKQ1Hx2xe5Uxjzxv4=
Message-ID: <e878da5b-6426-4bc0-924c-ecda72e08813@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779675651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=72J63drG56sfRi5dGjQE8gXc5sOOPTrEY6cYtD2rlWM=;
	b=JJ5IzaFUQFKP13CMr/Kkf7tfqcXixlihUa0HcNKOiyZF9Cmurdwaim43b4jWQ+yUbD1N2Q
	ZTXBrMQzjQHtFATKgjDiUZjMNlk1L2FCj5ZQlQYWDqt2sERfBHWFV78CpM5inoL+RDbPIS
	hJPgrL80k6+v/4LYXiW4FoVKv+EqeFQ=
Date: Mon, 25 May 2026 10:20:01 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/6] alloc_tag: add ioctl to /proc/allocinfo
To: Abhishek Bapat <abhishekbapat@google.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Sourav Panda <souravpanda@google.com>
References: <cover.1779471082.git.abhishekbapat@google.com>
 <8ffa0cef49b10026f2171d41b963c39201c9bd5b.1779471082.git.abhishekbapat@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <8ffa0cef49b10026f2171d41b963c39201c9bd5b.1779471082.git.abhishekbapat@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 6DBA840006
X-Stat-Signature: 1dae34dwcznusfad1ejgw4nfpc4p3xwb
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779675653-32010
X-HE-Meta: U2FsdGVkX1/S8izhKMy/oc/1pr2UXTCMrT6YGY8RqoOuG8aqQs2G+eMqlYaS1eCJTyCvC05ccnyyckxt5pDiW3+aq06f0zQTpAiDhk4Tp0UJlReHy/UnzwhyWeP2WlTs0tkPdSvAppH2TIQT8/9sYT1tNQ9dVkUXrmFKnm38yK8wDUHHh93koJYep8TIuIc28tkvsG6TLYWGGOFkTDuUe7+682qv0FvTJsoflzwIWIrNMB405/EHYNoVJ/VuOmq/JFo0E/VIregZc2etq3fk48c0bu+BZ5vFI8A/DNOAuXAmnCLFf9uhV0x7Fw+rNY8XpKXvemx2azXo7freZIyhLsS5WnzcVouR8U+uMoGB2QDv2yIjGXpZoZf5OwVaTDNn/0jyrfRVCG3i/WAKCfkq/7ppsuO/BNuwP76RUJPGYa1+p25OWvQi3lHh0IAomkDvr+HJCJwycbFsOcF/uj9nuqofG4c3VgbTd98N9nTssHznO7vwTTh0GKCncTYVjwOzzS49x2Fx/DA+oXLv+P55KyVapuA27lazAratib595vNlinF+whuCnrE1HLuWWlKP7CT9sR+euNb8WqcLthbcUHF6/L3MIiDTsOc6f+DahYIpNmMc1t9ELy6u0Gq9y4AXKTd/t3xEhCyy22eUl2+B/KAvcvqA7sYB0HQT8iNH3qlzc/d05WAH8MPtZDvfRNHonGheInrLD94f12esoOii4en639inIC98q0bdrtiK3JPVKeBGqg7rDP5VjvYT2/Gh97ldbIbVVaLk85zQJaskoenOB95xjR8caULJapXPylHwBu3ZDaRt6PaJe06vfLUpJy2Y6fLYZzZcQA5q0IWo5sxIu0SYEZQ7ptnE9LJMtAFCxsKdyTuE0aABg01BqJK1PErq5AZEANEz+LvrzjleeXxlIQXJj1azNovbbs38K6/CIoRbvBvfgsP/6vFBqmMZtdikaVS5Rrw5WDGHVGR
 bVJV9vvn
 yuLzJXh0wSQnEKtcCCHW/JosLsCtZhBg16yL9ie2BgPg174/9GP7IZPgBSIuyc2N5VbfYizyzoEw3Gsha07lkknv8OS8XIEorv75m+AoYuZ9BkFqWE/SWB+0LqXhHz0kJHDy48aPnnGN7y15/lrkYSWZquUj+dEMsFnv/5XkeJ0L7J2nAsStWwJH6IHUZeyGQ4uwJbcwH6HaaeznIEwc2vmI3sIVbyghFBzKcWLwDiP1BtSfEXFOSXEAr/Ill7s7u2Sl+Sr53wUDVsAg6Y87auqlVLHWY0dWPT2eDMgxMRCtvG5+unFAMf8mdq2st5/Dv6pVMHexQeIjCgBWApfTGy9gjeHgRkXprOVEbO1pM7HTVJqfmtZMxECwjsfKEq8lVhZnh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Abhishek


Thanks for this patch. I had a few questions/comments after going

through it.


On 2026/5/23 01:45, Abhishek Bapat wrote:
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

codetag_get_content_id() does not reflect module unload

codetag_get_content_id() returns cttype->next_mod_seq:

unsigned long codetag_get_content_id(struct codetag_type *cttype)

{

     return cttype->next_mod_seq;

}

However, next_mod_seq is only bumped in codetag_module_init(),

i.e.the module load path:

https://elixir.bootlin.com/linux/v7.1-rc4/source/lib/codetag.c#L204

codetag_unload_module() does not increment next_mod_seq. This means

that if only a module unload happens (without a subsequent load),

content_id stays the same, so users comparing the id before and after

won't detect that the content has changed. The commit message says

"Every time a module is loaded / unloaded" -- I was wondering if this

is intentional? If not, would it make sense to also bump next_mod_seq

in the unload path?


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
> ---
>   .../userspace-api/ioctl/ioctl-number.rst      |   2 +
>   MAINTAINERS                                   |   1 +
>   include/linux/codetag.h                       |   1 +
>   include/uapi/linux/alloc_tag.h                |  54 +++++
>   lib/alloc_tag.c                               | 193 +++++++++++++++++-
>   lib/codetag.c                                 |  11 +
>   6 files changed, 260 insertions(+), 2 deletions(-)
>   create mode 100644 include/uapi/linux/alloc_tag.h
>
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
> index 46ed0f0e76d8..d176bde8fbfc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16709,6 +16709,7 @@ S:	Maintained
>   F:	Documentation/mm/allocation-profiling.rst
>   F:	include/linux/alloc_tag.h
>   F:	include/linux/pgalloc_tag.h
> +F:	include/uapi/linux/alloc_tag.h
>   F:	lib/alloc_tag.c
>   
>   MEMORY CONTROLLER DRIVERS
> diff --git a/include/linux/codetag.h b/include/linux/codetag.h
> index 8ea2a5f7c98a..2bcd4e7c809e 100644
> --- a/include/linux/codetag.h
> +++ b/include/linux/codetag.h
> @@ -76,6 +76,7 @@ struct codetag_iterator {
>   
>   void codetag_lock_module_list(struct codetag_type *cttype, bool lock);
>   bool codetag_trylock_module_list(struct codetag_type *cttype);
> +unsigned long codetag_get_content_id(struct codetag_type *cttype);
>   struct codetag_iterator codetag_get_ct_iter(struct codetag_type *cttype);
>   struct codetag *codetag_next_ct(struct codetag_iterator *iter);
>   
> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
> new file mode 100644
> index 000000000000..e9a5b55fcc7a
> --- /dev/null
> +++ b/include/uapi/linux/alloc_tag.h
> @@ -0,0 +1,54 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/*
> + *  include/linux/alloc_tag.h
nit: it should be include/uapi/linux/alloc_tag.h
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
> +struct allocinfo_counter {
> +	__u64 bytes;
> +	__u64 calls;
> +	__u8 accurate;
> +	__u8 pad[7]; /* Add alignment to not break the 32-bit compatible interface */
> +};
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
> index b9ca95d1f506..3598735b6c93 100644
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
> @@ -46,6 +48,10 @@ int alloc_tag_ref_offs;
>   struct allocinfo_private {
>   	struct codetag_iterator iter;
>   	bool print_header;
> +	/* ioctl uses a separate iterator not to interfere with reads */
> +	struct codetag_iterator ioctl_iter;
> +	bool positioned; /* seq_open_private() sets to 0 */
> +	struct mutex ioctl_lock;
>   };
>   
>   static void *allocinfo_start(struct seq_file *m, loff_t *pos)
> @@ -125,6 +131,190 @@ static const struct seq_operations allocinfo_seq_op = {
>   	.show	= allocinfo_show,
>   };
>   
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
> +static int allocinfo_release(struct inode *inode, struct file *file)
> +{
> +	return seq_release_private(inode, file);
> +}
> +
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
> +	strscpy(dest, allocinfo_str(src), ALLOCINFO_STR_SIZE);
> +}
> +
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
> +static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __user *arg)
> +{
> +	struct allocinfo_content_id params;
> +
> +	codetag_lock_module_list(alloc_tag_cttype, true);
> +	params.id = codetag_get_content_id(alloc_tag_cttype);
> +	codetag_lock_module_list(alloc_tag_cttype, false);
> +	if (copy_to_user(arg, &params, sizeof(params)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
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
> +	priv = (struct allocinfo_private *)m->private;
> +	pos = params.pos;
> +
> +	mutex_lock(&priv->ioctl_lock);
> +	codetag_lock_module_list(alloc_tag_cttype, true);
> +
> +	/* Find the codetag */
> +	priv->ioctl_iter = codetag_get_ct_iter(alloc_tag_cttype);
> +	ct = codetag_next_ct(&priv->ioctl_iter);
> +	while (ct && pos--)
> +		ct = codetag_next_ct(&priv->ioctl_iter);

No upper bound check on pos in ALLOCINFO_IOC_GET_AT:

pos comes straight from userspace (__u64) with no validation.

If the system has 10000 tags and someone passes pos=10001,

the loop will still walk all 10000 tags just to return ENOENT

-- all while holding ioctl_lock and mod_lock. It might be worth

checking pos against the total tag count early. struct codetag_type

is not exposed outside codetag.c though, so this would need a small helper.


Thanks

Best Regards

Hao

> +	if (ct) {
> +		allocinfo_to_params(ct, &params.data);
> +		priv->positioned = true;
> +	}
> +
> +	codetag_lock_module_list(alloc_tag_cttype, false);
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
> +static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
> +{
> +	struct allocinfo_private *priv;
> +	struct codetag *ct;
> +	struct allocinfo_tag_data params = {0};
> +	int ret = 0;
> +
> +	priv = (struct allocinfo_private *)m->private;
> +
> +	mutex_lock(&priv->ioctl_lock);
> +	codetag_lock_module_list(alloc_tag_cttype, true);
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
> +	codetag_lock_module_list(alloc_tag_cttype, false);
> +	mutex_unlock(&priv->ioctl_lock);
> +
> +	if (ret == 0) {
> +		if (copy_to_user(arg, &params, sizeof(params)))
> +			return -EFAULT;
> +	}
> +	return ret;
> +}
> +
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
> @@ -989,8 +1179,7 @@ static int __init alloc_tag_init(void)
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
> index 304667897ad4..93aa30991563 100644
> --- a/lib/codetag.c
> +++ b/lib/codetag.c
> @@ -48,6 +48,17 @@ bool codetag_trylock_module_list(struct codetag_type *cttype)
>   	return down_read_trylock(&cttype->mod_lock) != 0;
>   }
>   
> +unsigned long codetag_get_content_id(struct codetag_type *cttype)
> +{
> +	lockdep_assert_held(&cttype->mod_lock);
> +
> +	/*
> +	 * next_mod_seq is updated on every load, so can be used to identify
> +	 * content changes.
> +	 */
> +	return cttype->next_mod_seq;
> +}
> +
>   struct codetag_iterator codetag_get_ct_iter(struct codetag_type *cttype)
>   {
>   	struct codetag_iterator iter = {

