Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F24FFCD5BAC
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 20:11:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63C0D6B0096; Fri, 22 May 2026 16:11:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ECF86B0098; Fri, 22 May 2026 16:11:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 502756B0099; Fri, 22 May 2026 16:11:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3FC956B0096
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:11:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E03101C060E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:11:51 +0000 (UTC)
X-FDA: 84796151622.25.6275966
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 417B610000A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:11:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bbaUUn1u;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779480710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8mLMHmRZ08707jDd+gxfnCu333tK5LX5G+5DzAWfNeo=;
	b=k8Ursafvvuf097XhbfTb61ByA2Wg9ez7avYmWz3L3diUOEWGBSpTIk6Xz49yMcQNekA3po
	imCz2Xvria0uY8Wa5CbFekoKjvRXLWh4HvjdkwI2d4+8J8HgNa8DbV8dzQdVXKusoh9eaS
	Kc/FIlWmWRptyIX1COny+KqaKerV+ss=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779480710; a=rsa-sha256;
	cv=none;
	b=jQbeCUo20JNdHb+iQ8WJxmgrP7YjQHINQw89+9bZ2vdiWiDv13D2EX9kAd9Pc+b/+aDsVl
	5fGo+6zAlHXBWgP49yi/w8NgWzXAUHB96ISKg8f3O02NewvV2SoCmpWdhMGmGhCduYre2n
	sc6U09UGI8Z/qMPnwv+7C+JMNeCqSLM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bbaUUn1u;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D4BC460136;
	Fri, 22 May 2026 20:11:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B461F000E9;
	Fri, 22 May 2026 20:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779480709;
	bh=8mLMHmRZ08707jDd+gxfnCu333tK5LX5G+5DzAWfNeo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bbaUUn1uuVcwqyPDYbBJrtMO4qSnblWDbY2rTctROGYySSJz2dYB0WBbfrlQJtwPf
	 lTmr2Xzhrvdq8ceT/2/Q2LAOZBWpY0LChG8uiDgIxKyuGBWQ1fRJPu5Z7OPeyLLv6b
	 yFpBo6CnsMqW6BjjLJwC9YzjEDxw+MpdpFnxBLfg=
Date: Fri, 22 May 2026 13:11:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>, Kent Overstreet
 <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>, Shuah Khan
 <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>
Subject: Re: [PATCH v2 1/6] alloc_tag: add ioctl to /proc/allocinfo
Message-Id: <20260522131148.059d7589666e4a35af1430e5@linux-foundation.org>
In-Reply-To: <8ffa0cef49b10026f2171d41b963c39201c9bd5b.1779471082.git.abhishekbapat@google.com>
References: <cover.1779471082.git.abhishekbapat@google.com>
	<8ffa0cef49b10026f2171d41b963c39201c9bd5b.1779471082.git.abhishekbapat@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 417B610000A
X-Stat-Signature: 5uspm1zwo6xwwn18qggdkpyk6x6w4oro
X-Rspamd-Server: rspam06
X-HE-Tag: 1779480710-664393
X-HE-Meta: U2FsdGVkX1+CScMzSU75Ly2mz46uG/bkBEmZ4GBUtNPed73d4zy8+KGrrNXgATsIa460EeqXGMhyHtNjpnIVxcDxOg2qVyGcbClEYwa1IPc0aSCPqGE0wxn39AYxs42PEZW5G+pKeN3MrJdF4u+fXQEp3PqQLpZKHzLTCUptru/w+F3laa5ubMiCXNLVDXgocGGT8onNaa/S+k4D/C2ww4cS+CJ80frv8i6Jv+sej5jEvZRKd3SAs1OJr+e5tZwgLbNh6xIOpqEbNSOTehs/sk2RrPRqFDJ4klg5wuo1cJDgpWXgDz06CqZQ5aa7m4eEyD2bmv/Gc78VXMyrztu99M2w5Z1C8w3Zkw8byxGbYZwsSNrx88gnw9wB97+K8DFm6g9ag5lAT6SWroE+qJhuVX5lHkQWWhIdA44lxP8T+NpJoEL4hezOyLVhTdW75u5gawVMv6tYLYvN+9fSLsOokl9RKoGWuTcOMu9JhCwF19x6AH+HeNSKaITYUMHUsKaIhBLMbmkEmlHawVybS6buaC6uz9rmwVOR+MNWgdu30JIEZmvynPEh8YDyceT0dmYMCgxIl1EtNg4dAoYpR/CyAZWnRoLToP6Oeu2VtJDJ0rIupxazoJOz9MTUAdRbfBusbIq0HZwWd0z7nbhP/UHp1l8ceAbjccHnOCUU95AQi1KyuK+fpODv+9qBnSv4nnVYfPCat3T1qZRvVR+tRgUsj5MEKy0ViJgXDfLEcKmSFcFlQhVTHdkVgEASn17due/w+YAG4HbFDKXSK8wSMqGuoUXZSJZrTmqOOzTprQORf/fziqc/Q0HpDBcoT37j4bo984pF7P7vIBL2ZJ2EgSSVCn3WLXSriPQ5TL8ynRqJrCGOvamIVt3+IJbRJNJCnrj22ElCf+St3YOYUBB3olkCpSEKUlP41bYOUI33Fhtf4o/xyit9lEMOAOa9fqEycuTxRCmc0/63sFxqAymGNE+
 rq1CDwBR
 qRpXrLcu5XMmw+qA5cJVnjVaqO43yQOiHIU1u3WTKt8McGtAW9+C8A6vUfUaZjzACV5kIDm1Tqkxp4TPRAeftkhJXxGD0TG3w3P7KMoPdh7NBYdCEfttg2A+SEMF/UGabBzZqgi5o1iBxn//457/QCLDNRbRnPjT+0y/Et3NIWNOFGsWXMRWVXWVBHheaw4C1cBD3nOa559q6TI4VdMKSiImBKpRceLLgSKY1ekSso/Z/NOiUBiv8hHIjE++mJMnEQR2p4O6hdQ6i6rc25pbRRzKn95VvJmsScqLwuljk2tnHUWrBnxJ1TkgmNBHBtlZJSx0E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 May 2026 17:45:33 +0000 Abhishek Bapat <abhishekbapat@google.com> wrote:

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
> index 000000000000..e9a5b55fcc7a
> --- /dev/null
> +++ b/include/uapi/linux/alloc_tag.h
> @@ -0,0 +1,54 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/*
> + *  include/linux/alloc_tag.h
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

This seems rather fragile, and makes assumptions about compiler layout?

Can't we use __attribute__((aligned)) in some fashion?

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
>  #include <linux/gfp.h>
>  #include <linux/kallsyms.h>
>  #include <linux/module.h>
> +#include <linux/mutex.h>
>  #include <linux/page_ext.h>
>  #include <linux/pgalloc_tag.h>
>  #include <linux/proc_fs.h>
> @@ -14,6 +15,7 @@
>  #include <linux/string_choices.h>
>  #include <linux/vmalloc.h>
>  #include <linux/kmemleak.h>
> +#include <uapi/linux/alloc_tag.h>
>  
>  #define ALLOCINFO_FILE_NAME		"allocinfo"
>  #define MODULE_ALLOC_TAG_VMAP_SIZE	(100000UL * sizeof(struct alloc_tag))
> @@ -46,6 +48,10 @@ int alloc_tag_ref_offs;
>  struct allocinfo_private {
>  	struct codetag_iterator iter;
>  	bool print_header;
> +	/* ioctl uses a separate iterator not to interfere with reads */
> +	struct codetag_iterator ioctl_iter;
> +	bool positioned; /* seq_open_private() sets to 0 */
> +	struct mutex ioctl_lock;
>  };
>  
>  static void *allocinfo_start(struct seq_file *m, loff_t *pos)
> @@ -125,6 +131,190 @@ static const struct seq_operations allocinfo_seq_op = {
>  	.show	= allocinfo_show,
>  };
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

Generally, the commenting in here is very thin.  Add some explanations
of what the various functions do and, especially, why they do it?

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

See, even these two little functions are unnecessarily difficult to
review when one doesn"t know what they are setting out to do.  One has
to first reverse engineer their intent from the implementation, then
check that the implementation implements that intent.

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

Unneeded cast.

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

Ditto.

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
>
> ...
>

