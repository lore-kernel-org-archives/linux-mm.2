Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7C2DC624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 23:20:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD9546B0088; Thu,  3 Sep 2026 19:20:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A89FC6B008A; Thu,  3 Sep 2026 19:20:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A0076B008C; Thu,  3 Sep 2026 19:20:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DABA6B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 19:20:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 30D7E80667
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 23:20:04 +0000 (UTC)
X-FDA: 85174021128.21.13A18F9
Received: from mta0.migadu.com (out-40.mta0.migadu.com [91.218.175.40])
	by imf06.hostedemail.com (Postfix) with ESMTP id 25753180002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 23:19:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vAVXZ1FH;
	spf=pass (imf06.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.40 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788477602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=etVLyZHGiczvYHr4q7gdL3rgYyghtZViKm/Y9dp20WY=;
	b=1XOrTcZsfPZlHXUnGGW08FjBdykjdUlSBr6y/NRpk5Ed0mAYZxSYb8C0Yes3pWCmPAzNeK
	vdtqG+hYMmfTUHglHMi0GH0snbl42TvpTxnF6l7cHtzOt4/ny1ujM1GraLo1K5F8+K+en6
	NUQrpMxMdfXHF+AwZABxXecX40E9Ng8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788477602;
	b=Fqnv7OWE9jNwYE2/SHlYFgjCYPe/dEXM5aguVy2DmO7UE07jatUFuOwhKF0DPF8osb3k3z
	NIiEt78/C+cKPmY7rVOYlnjVpXX1Kin5oG8QhfqjKIMjmLnx/dOmLyk0TpuGShzhk+aKL4
	fGNHrreaFpYMEmuRuyGMGt64XMh5NWo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vAVXZ1FH;
	spf=pass (imf06.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.40 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=122pexZufQYfTsSGUStzGsOrhTfJYDQADD35SE5TtB8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788477596; v=1; x=1789082396;
 b=vAVXZ1FH8i9vyLbkLrPwT1oXJT3sx7kmXZjcwfoXbz/nvV+5NvwKWbLekjzDWvPXnQzoaPlD
 +0iIX6OmeNN85hSLP89UksruwXBInYFvwm0mrPW+w3nA6pNLF02UrKMkmxR1nUD88NgAj+EBwAf
 ntiFi9bzYY394gDK2L6nDzUE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 876ef0493799c3d9;
	Thu, 03 Sep 2026 23:19:46 +0000
X-Mizu-Trace-ID: 876ef0493799c3d9
X-Migadu-Flow: FLOW_OUT
Message-ID: <b29fbb51-5d0f-4f82-a06f-55ea080b5629@linux.dev>
Date: Thu, 3 Sep 2026 16:19:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/2] eventfd: luo: luo support for preserving eventfd
To: Chenghao Duan <duanchenghao@kylinos.cn>, viro@zeniv.linux.org.uk,
 brauner@kernel.org, jack@suse.cz, linux-fsdevel@vger.kernel.org,
 pasha.tatashin@soleen.com, linux-kernel@vger.kernel.org, rppt@kernel.org,
 pratyush@kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org
Cc: jianghaoran@kylinos.cn
References: <20260625054946.73445-1-duanchenghao@kylinos.cn>
 <20260625054946.73445-2-duanchenghao@kylinos.cn>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260625054946.73445-2-duanchenghao@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 25753180002
X-Stat-Signature: oy98epx6ynm4atx6xgkr95scrktn3coo
X-HE-Tag: 1788477599-150208
X-HE-Meta: U2FsdGVkX1+px9AlqEheJomqX7WcMsPFvF/wWoWLD3oCdqK08zetQBcP9+9gqaYSevmb1zpQdaZoXClZwHgkDinODjcqLVZmDn5/XMcmLH/3hOS9vshjIP5j4YD4kbbDNLejmWbPSMlOwaqIIq4RlOSWMNSjYNMClydXrxk8eym21SF6yTpwOCyk4ps+XzvKbg/xl8XDSV3RRvTtNNDX2+1A/ZRUXxlV/WQ54BJdEr4xIPe1u/HP41cdr+j1KwwrZs5JJWTk7NlnjAGtquOE8vuZGTJwKWmMnbb2jW7+c8aVxZG3BJPVxJZnbM4dNmkUH0UDkTd9aAwV67wLDH1HnrATG0XzarmRTmuffHbe+HBmTGjTYO8GkUXIj3jMmI/8gLBb60caVjvkxfD63uv8T1Nu+sltamZxtR+6dPDqaRIUMV0K1JtEJjUxtGIpeifcFnPHh2Hy1d0jVhzxg5szq3ZcKVvoIzCmdfr4OUC/enctY/KZ5BO8GOdzqvF4Yng+E4IxstUE8BkNv4ySk33qtvrJBAHghYbVqzcRcUzO9hRK3+BtIRREIsmSIPfnFnnBnXcOMpEBchB3ZJ7dRyv8yIJeGkC0d3HGqjvP+rF408Y+DzkzCmZtJqQ1qgHWkDabuTDXXjisN4yc6s2X2vVqTPBDOGubb5F7vNn0vZVe4tgYBhIfnNZebRjsXXiJR0RxuoSY6JU34WHY0UesrviXufdM4fzwEsfJO+My5NHKPvpXkHCW+MnyrPqkxSo2aO3/NZn95z6kJJn5Gwo/lmF57Z4pUHNs+1ipC3dRAthXvv+hVuh6xGRCreyeWoVzRB08RRlKJgvd0/y/OYiyinXIUKoWVVD6wQ0V/vf86Tw6PaZWUhIUmZuWNJ2NAu3HkU++8DCunaUdeW143k8sLn6BF8aOnN5cJyHsp0ifvIJ3o7u4+5gsi24a1eirXpJJVno+T9WyIFWiyQXhYyAH42E
 rH9le3vn
 2LzRsvBCFIWZflYwXZFmKF0ZheTTG6S0tVs3oWQP3NJzV3xHo2cI9+kqvAO+Ifhg3yQmmpDeYoIyoyy7CWVdGpGyUPSTa7hbsbAxIuxhWAzBrbFOd/Nun721x/CmHfXRA2I/3xjA2QoMrOKVv6K2wpfdrDu85t7I6oGK2q09xERPFOQTcI6JZmtgF4vczxndZA5li/XWON81QrT26gxTQKk2h6he2yWAk3exPXhbtjTHMGiPGnr7tmbobu/Z0yiRrf8XUMmU/F+IY+8tAEZoc9ETY6qjpw9ihhXvduc3RC4YTA+3XIRhrhU+L1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 2026/6/24 22:49, Chenghao Duan 写道:
> This patch adds support for preserving eventfd file descriptors across
> kexec live updates using the Live Update Orchestrator (LUO) framework.
> Userspace applications using eventfd for event notification can now
> maintain their state across kernel updates.
> 
> Preserved State:
> The following properties of the eventfd are preserved across kexec:
> - Counter Value: The current 64-bit counter value, including any pending
>    events that have been signaled but not yet consumed by readers.
> - File Flags: The creation flags (EFD_SEMAPHORE, EFD_CLOEXEC, EFD_NONBLOCK)
>    are preserved.
> 
> Non-Preserved State:
> - File Descriptor Number: The eventfd will be assigned a new fd number
>    in the target process after restore.
> - Wait Queue State: Any processes blocked on read() operations will be
>    woken up and need to re-establish their blocking state.
> - All other internal state is reset to default.
> 
> Changes:
> - fs/eventfd.c: Add eventfd_luo_get_state() to safely read eventfd state
>    (count and flags), and eventfd_create() helper function.
> - fs/eventfd_luo.c: New file implementing LUO file operations:
>    preserve, freeze, unpreserve, retrieve, and finish callbacks.
> - include/linux/eventfd.h: Export new functions.
> - include/linux/kho/abi/eventfd.h: Define the ABI contract with
>    eventfd_luo_ser structure for serialization.
> 
> Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
> ---
>   fs/Makefile                     |   1 +
>   fs/eventfd.c                    |  40 +++++
>   fs/eventfd_luo.c                | 250 ++++++++++++++++++++++++++++++++
>   include/linux/eventfd.h         |   2 +
>   include/linux/kho/abi/eventfd.h |  39 +++++
>   kernel/liveupdate/Kconfig       |  16 ++
>   6 files changed, 348 insertions(+)
>   create mode 100644 fs/eventfd_luo.c
>   create mode 100644 include/linux/kho/abi/eventfd.h
> 
> diff --git a/fs/Makefile b/fs/Makefile
> index 89a8a9d207d1..36d568e6cfc7 100644
> --- a/fs/Makefile
> +++ b/fs/Makefile
> @@ -27,6 +27,7 @@ obj-y				+= anon_inodes.o
>   obj-$(CONFIG_SIGNALFD)		+= signalfd.o
>   obj-$(CONFIG_TIMERFD)		+= timerfd.o
>   obj-$(CONFIG_EVENTFD)		+= eventfd.o
> +obj-$(CONFIG_LIVEUPDATE_EVENTFD)+= eventfd_luo.o
>   obj-$(CONFIG_AIO)               += aio.o
>   obj-$(CONFIG_FS_DAX)		+= dax.o
>   obj-$(CONFIG_FS_ENCRYPTION)	+= crypto/
> diff --git a/fs/eventfd.c b/fs/eventfd.c
> index 9d33a02757d5..9b76cf06135a 100644
> --- a/fs/eventfd.c
> +++ b/fs/eventfd.c
> @@ -376,6 +376,40 @@ struct eventfd_ctx *eventfd_ctx_fileget(struct file *file)
>   }
>   EXPORT_SYMBOL_GPL(eventfd_ctx_fileget);
>   
> +/**
> + * eventfd_luo_get_state - Get eventfd state (count and flags) for LUO
> + * @file: Eventfd file
> + * @count: Output parameter for count value
> + * @flags: Output parameter for flags value
> + *
> + * This function is exported for use by LUO to safely read eventfd state.
> + * Since struct eventfd_ctx is defined in this file, we can access its
> + * members directly here. The function uses the wait queue lock to ensure
> + * atomic access to count.
> + *
> + * Returns 0 on success, negative error code on failure.
> + */
> +int eventfd_luo_get_state(struct file *file, __u64 *count, unsigned int *flags)
> +{
> +	struct eventfd_ctx *ctx;
> +	unsigned long irq_flags;
> +
> +	ctx = eventfd_ctx_fileget(file);
> +	if (IS_ERR(ctx))
> +		return PTR_ERR(ctx);
> +
> +	/* Read count with lock (flags don't need lock) */
> +	spin_lock_irqsave(&ctx->wqh.lock, irq_flags);
> +	*count = ctx->count;
> +	spin_unlock_irqrestore(&ctx->wqh.lock, irq_flags);
> +
> +	*flags = ctx->flags;
> +
> +	eventfd_ctx_put(ctx);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(eventfd_luo_get_state);
> +
>   static int do_eventfd(unsigned int count, int flags)
>   {
>   	struct eventfd_ctx *ctx __free(kfree) = NULL;
> @@ -411,6 +445,12 @@ static int do_eventfd(unsigned int count, int flags)
>   	return fd_publish(fdf);
>   }
>   
> +int eventfd_create(__u64 count, unsigned int flags)
> +{
> +	return do_eventfd(count, flags);
> +}
> +EXPORT_SYMBOL_GPL(eventfd_create);
> +
>   SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
>   {
>   	return do_eventfd(count, flags);
> diff --git a/fs/eventfd_luo.c b/fs/eventfd_luo.c
> new file mode 100644
> index 000000000000..781d90635c52
> --- /dev/null
> +++ b/fs/eventfd_luo.c
> @@ -0,0 +1,250 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2026 KylinSoft Corporation.
> + * Author: Chenghao Duan <duanchenghao@kylinos.cn>
> + */
> +
> +/**
> + * DOC: Eventfd Preservation via LUO
> + *
> + * Overview
> + * ========
> + *
> + * Event file descriptors (eventfd) can be preserved over a kexec using the Live
> + * Update Orchestrator (LUO) file preservation. This allows userspace applications
> + * that use eventfd for event notification to maintain their state across kernel
> + * updates.
> + *
> + * Eventfd is a simple notification mechanism that uses a 64-bit counter for
> + * signaling events between userspace processes or between userspace and kernel.
> + * The preservation ensures that pending events and configuration are not lost
> + * during kexec.
> + *
> + * The preservation is not intended to be transparent. Only select properties of
> + * the eventfd are preserved. All others are reset to default. The preserved
> + * properties are described below.
> + *
> + * Preserved Properties
> + * ====================
> + *
> + * The following properties of the eventfd are preserved across kexec:
> + *
> + * Counter Value
> + *   The current 64-bit counter value is preserved. This includes any pending
> + *   events that have been signaled but not yet consumed by readers.
> + *
> + * File Flags
> + *   The creation flags (EFD_SEMAPHORE, EFD_CLOEXEC, EFD_NONBLOCK) are preserved.
> + *   These control the behavior of read/write operations and file descriptor
> + *   inheritance.
> + *
> + * Non-Preserved Properties
> + * ========================
> + *
> + * All properties which are not preserved must be assumed to be reset to
> + * default. This section describes some of those properties which may be more of
> + * note.
> + *
> + * File Descriptor Number
> + *   The file descriptor number itself is not preserved. After restore, the
> + *   eventfd will be assigned a new file descriptor number in the target process.
> + *
> + * Wait Queue State
> + *   Any processes currently blocked on read() operations will be woken up and
> + *   need to re-establish their blocking state if desired.
> + *
> + * File Position
> + *   Eventfd files don't have a traditional file position, but any internal
> + *   state related to the file descriptor is reset.
> + */
> +
> +#include <linux/err.h>
> +#include <linux/file.h>
> +#include <linux/io.h>
> +#include <linux/kexec_handover.h>
> +#include <linux/kho/abi/eventfd.h>
> +#include <linux/liveupdate.h>
> +#include <linux/module.h>
> +#include <linux/eventfd.h>
> +#include <linux/anon_inodes.h>
> +#include <linux/idr.h>
> +#include <linux/slab.h>
> +#include <linux/wait.h>
> +#include <linux/kref.h>
> +#include <linux/fdtable.h>
> +
> +static int eventfd_luo_preserve(struct liveupdate_file_op_args *args)
> +{
> +	struct eventfd_luo_ser *ser;
> +	u64 count;
> +	unsigned int flags;
> +	int err = 0;
> +
> +	/* Get eventfd state safely */
> +	err = eventfd_luo_get_state(args->file, &count, &flags);
> +	if (err) {
> +		pr_err("Failed to get eventfd state: %d\n", err);
> +		return err;
> +	}
> +
> +	ser = kho_alloc_preserve(sizeof(*ser));
> +	if (IS_ERR(ser)) {
> +		err = PTR_ERR(ser);
> +		pr_err("Failed to allocate preserve memory: %d\n", err);
> +		return err;
> +	}
> +
> +	/* Save eventfd state */
> +	ser->count = count;
> +	ser->flags = flags;
> +
> +	pr_debug("Preserved eventfd: count=%llu, flags=0x%x\n",
> +		ser->count, ser->flags);
> +
> +	/* Return physical address of serialization structure */
> +	args->serialized_data = virt_to_phys(ser);
> +
> +	return 0;
> +}
> +
> +static int eventfd_luo_freeze(struct liveupdate_file_op_args *args)
> +{
> +	struct eventfd_luo_ser *ser;
> +	u64 count;
> +	unsigned int flags;
> +	int err;
> +
> +	if (WARN_ON_ONCE(!args->serialized_data))
> +		return -EINVAL;
> +
> +	ser = phys_to_virt(args->serialized_data);
> +
> +	/* Get current state and update if changed */
> +	err = eventfd_luo_get_state(args->file, &count, &flags);
> +	if (err)
> +		return err;
> +
> +	if (ser->count != count) {
> +		pr_debug("WARNING: Count changed during preserve->freeze! old=%llu, new=%llu\n",
> +			 ser->count, count);
> +	}
> +
> +	ser->count = count;
> +
> +	return 0;
> +}
> +
> +static void eventfd_luo_unpreserve(struct liveupdate_file_op_args *args)
> +{
> +	struct eventfd_luo_ser *ser;
> +
> +	if (WARN_ON_ONCE(!args->serialized_data))
> +		return;
> +
> +	ser = phys_to_virt(args->serialized_data);
> +	kho_unpreserve_free(ser);
> +}
> +
> +static int eventfd_luo_retrieve(struct liveupdate_file_op_args *args)
> +{
> +	struct eventfd_luo_ser *ser;
> +	struct eventfd_ctx *ctx;
> +	struct file *file = NULL;
> +	int eventfd;
> +
> +	ser = phys_to_virt(args->serialized_data);
> +	if (!ser)
> +		return -EINVAL;
> +
> +	/* Create a new eventfd with the preserved count and flags */
> +	eventfd = eventfd_create(ser->count, ser->flags);
> +	if (eventfd < 0) {
> +		pr_err("Failed to create eventfd: %d\n", eventfd);
> +		return eventfd;
> +	}
> +
> +	file = fget(eventfd);
> +	if (!file) {
> +		pr_err("Failed to get file from fd\n");
> +		close_fd(eventfd);
> +		return -EBADF;
> +	}
> +
> +	close_fd(eventfd);
> +
> +	/* Verify the created file has correct internal state */
> +	ctx = eventfd_ctx_fileget(file);
> +	if (IS_ERR(ctx)) {
> +		pr_err("Failed to get context from file\n");
> +		fput(file);
> +		return PTR_ERR(ctx);
> +	}
> +
> +	eventfd_ctx_put(ctx);
> +
> +	args->file = file;
> +	return 0;
> +}
> +
> +static void eventfd_luo_finish(struct liveupdate_file_op_args *args)
> +{
> +	struct eventfd_luo_ser *ser;
> +
> +	if (args->retrieve_status)
> +		return;
> +
> +	if (!args->serialized_data)
> +		return;
> +
> +	ser = phys_to_virt(args->serialized_data);
> +	if (!ser)
> +		return;
> +
> +	kho_restore_free(ser);
> +}
> +
> +static bool eventfd_luo_can_preserve(struct liveupdate_file_handler *handler,
> +				     struct file *file)
> +{
> +	struct eventfd_ctx *ctx;
> +
> +	if (!file->f_op)
> +		return false;
> +
> +	/* Try to get eventfd context - this will fail if not an eventfd */
> +	ctx = eventfd_ctx_fileget(file);
> +	if (IS_ERR(ctx))
> +		return false;
> +
> +	eventfd_ctx_put(ctx);
> +	return true;
> +}
> +
> +static const struct liveupdate_file_ops eventfd_luo_file_ops = {
> +	.preserve = eventfd_luo_preserve,
> +	.unpreserve = eventfd_luo_unpreserve,
> +	.freeze = eventfd_luo_freeze,
> +	.retrieve = eventfd_luo_retrieve,
> +	.finish = eventfd_luo_finish,
> +	.can_preserve = eventfd_luo_can_preserve,
> +	.owner = THIS_MODULE,
> +};
> +
> +static struct liveupdate_file_handler eventfd_luo_handler = {
> +	.ops = &eventfd_luo_file_ops,
> +	.compatible = EVENTFD_LUO_FH_COMPATIBLE,
> +};
> +
> +static int __init eventfd_luo_init(void)
> +{
> +	int err = liveupdate_register_file_handler(&eventfd_luo_handler);

The function liveupdate_unregister_file_handler should also be invoked 
to unregister luo handler.

Zhu Yanjun

> +
> +	if (err && err != -EOPNOTSUPP) {
> +		pr_err("Could not register eventfd LUO handler: %pe\n",
> +		       ERR_PTR(err));
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +late_initcall(eventfd_luo_init);
> diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
> index e32bee4345fb..703e1a126c4d 100644
> --- a/include/linux/eventfd.h
> +++ b/include/linux/eventfd.h
> @@ -35,6 +35,8 @@ void eventfd_ctx_put(struct eventfd_ctx *ctx);
>   struct file *eventfd_fget(int fd);
>   struct eventfd_ctx *eventfd_ctx_fdget(int fd);
>   struct eventfd_ctx *eventfd_ctx_fileget(struct file *file);
> +int eventfd_luo_get_state(struct file *file, __u64 *count, unsigned int *flags);
> +int eventfd_create(__u64 count, unsigned int flags);
>   void eventfd_signal_mask(struct eventfd_ctx *ctx, __poll_t mask);
>   int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx, wait_queue_entry_t *wait,
>   				  __u64 *cnt);
> diff --git a/include/linux/kho/abi/eventfd.h b/include/linux/kho/abi/eventfd.h
> new file mode 100644
> index 000000000000..148beac6bcc7
> --- /dev/null
> +++ b/include/linux/kho/abi/eventfd.h
> @@ -0,0 +1,39 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2026 KylinSoft Corporation.
> + * Author: Chenghao Duan <duanchenghao@kylinos.cn>
> + */
> +
> +#ifndef _LINUX_KHO_ABI_EVENTFD_H
> +#define _LINUX_KHO_ABI_EVENTFD_H
> +
> +#include <linux/types.h>
> +
> +/*
> + * Eventfd Live Update ABI
> + *
> + * This header defines the ABI for preserving eventfd state across kexec.
> + *
> + * The state is serialized into a packed structure `struct eventfd_luo_ser`
> + * which is handed over to the next kernel via the KHO mechanism.
> + *
> + */
> +
> +/**
> + * struct eventfd_luo_ser - Serialized state of an eventfd
> + * @count: The current counter value
> + * @flags: File flags (EFD_SEMAPHORE, EFD_CLOEXEC, EFD_NONBLOCK)
> + *
> + * This structure contains the minimal state needed to restore an eventfd
> + * after kexec. The count represents the current value of the event counter,
> + * and flags represent the file creation flags.
> + */
> +struct eventfd_luo_ser {
> +	__u64 count;
> +	unsigned int  flags;
> +} __packed;
> +
> +/* The compatibility string for eventfd file handler */
> +#define EVENTFD_LUO_FH_COMPATIBLE	"eventfd-v1"
> +
> +#endif /* _LINUX_KHO_ABI_EVENTFD_H */
> diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
> index c13af38ba23a..1361b5733f41 100644
> --- a/kernel/liveupdate/Kconfig
> +++ b/kernel/liveupdate/Kconfig
> @@ -86,4 +86,20 @@ config LIVEUPDATE_MEMFD
>   
>   	  If unsure, say N.
>   
> +config LIVEUPDATE_EVENTFD
> +	bool "Eventfd Live Update Orchestrator support"
> +	depends on EVENTFD
> +	depends on LIVEUPDATE
> +	help
> +	  Enable Live Update Orchestrator support for eventfd file descriptors.
> +	  This allows eventfd files to be preserved and restored across kexec
> +	  operations, maintaining their counter values and flags.
> +
> +	  Eventfd files are commonly used for event notification between
> +	  userspace processes or between userspace and kernel. With this
> +	  option enabled, eventfd state can be handed over to a new kernel
> +	  during live update operations.
> +
> +	  If unsure, say N.
> +
>   endmenu


