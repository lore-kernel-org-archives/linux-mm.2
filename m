Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DF1CD31A09
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 04:30:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 685876B0089; Tue, 13 Jan 2026 23:30:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65B176B008C; Tue, 13 Jan 2026 23:30:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 591756B0092; Tue, 13 Jan 2026 23:30:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4416E6B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 23:30:27 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AF656140280
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 04:30:26 +0000 (UTC)
X-FDA: 84329292852.06.87F5225
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf18.hostedemail.com (Postfix) with ESMTP id 925D51C0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 04:30:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=YA72Lkoc;
	spf=pass (imf18.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768365025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c54yyOgKWU3UcRhYLgdv4hIpfkij19xD2QDOn7kfvSE=;
	b=tHguO4YrfZjP8o3V7JAxKGbwOsyvvZ507dcAEOXUdh/ZzDHquy2eDrbLji8yhYkKQIQTx3
	1V6lf/c7YelV7jyHbeESCGgmETTBq5tXGxM3rzOjKODT6zZa2TQFQG1uVtWQzh5Z94FPmn
	RDjGRsbhgbIVZiqL1iOmLrpTUl5pE9g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=YA72Lkoc;
	spf=pass (imf18.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768365025; a=rsa-sha256;
	cv=none;
	b=QLPz+OraSxZvxIJ+jOyyTE3XaffYHr3/+kSDRf4vzioUM69twjRLeHr7VK4zNdfNdeS/QN
	/ruwdfHOm6fW+iDDjJkJ/ks+cf+gAV6S/bdirekAUlP5XQ6vov1J6Qgq1wnkZAe48hkPk4
	MC5zACM1FgjrJPsb2wDj9Yo2xUhC/YU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version:
	Content-Type; bh=c54yyOgKWU3UcRhYLgdv4hIpfkij19xD2QDOn7kfvSE=;
	b=YA72LkocQ9tsCZzGg+LWG6+QqGKVRW9RnYEO9c84ihV5/C2xSpCQtzuScal2C6
	ki4PFrTgZtHVzH9zmnqGVJDD0e2I9/SZOImN1clNJcBTb9msbloarndPVWnhElCV
	0YReg5bcVuyW3I9xHuPKS+Kaw3TWjhk5rwezvDkf2Kj88=
Received: from ubuntu24-z.. (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgAH3azEG2dpCT6CLQ--.114S2;
	Wed, 14 Jan 2026 12:29:59 +0800 (CST)
From: ranxiaokai627@163.com
To: surenb@google.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	david@kernel.org,
	kent.overstreet@linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com,
	rppt@kernel.org,
	vbabka@suse.cz
Subject: Re: [PATCH] alloc_tag: remove sysctl prefix from mem_profiling boot parameter
Date: Wed, 14 Jan 2026 04:29:41 +0000
Message-ID: <20260114042954.163174-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAJuCfpFTJUowSAjNum1zecDJYuyUi84vUNkoNNf=CnUwpsTVeg@mail.gmail.com>
References: <CAJuCfpFTJUowSAjNum1zecDJYuyUi84vUNkoNNf=CnUwpsTVeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgAH3azEG2dpCT6CLQ--.114S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjTRiDG5UUUUU
X-Originating-IP: [117.176.243.29]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxQcseGlnG8eyIAAA3W
X-Stat-Signature: zj3gn11uuwepa5gcz7jjh67qmpw4xznt
X-Rspamd-Queue-Id: 925D51C0005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768365023-401757
X-HE-Meta: U2FsdGVkX1/49Ncxw58Ph2uLH97ECpA8fqMWlIFzT7OJ6qQXDlL4dHRx38evIrI4TX0gYjSNrhVNRpLDu1lisQ+Z715o3kAakxjYvV6eFbM/G7Y2USQIisSMbKnQCORZKfQdDFIr2PaQl08D0D4D1+f5f60wnC909XMP+JyeeF+H0jINqLYx7iiLdaJYl+O6raBcNEtqFcv8fv7sDx6hDL/UZ8H7wJXp19N3Q1iBanDC868JB5fbMbhc6J6uOWkBU6NYk4f+Ul4xhTxq0l7nRuvGh7jR1QmTiUJ8ZlsAQkF8sWv+R8nLzIlLZ2Xn46Gv+rXOM/IFS5Dtyc6ae7zb/wobt7jG7Ns27YUPy4RKZIHVo/A06wuqtsWGGICBclxp2DU4kgeTocgV+SWvRGOZvrkvsRP9t2+O9U7BVbJbFbJptmmrvIvbD2Xu/NW3rZYHDyJ5TQDw3TvMNqjSJp9Wz+7KwDPXsX1+olPU6XvH0cgzUtjYSdUsen3A1KeKU1P9puxlXMbINYLtwR88Pu7CwGyqCh5R7W9SBAkFtkujfMMbijMf+POUb15j9X8A3kFCAJcVtq5k824D8xDZyGh8g+hSLBntxsUnlMEz0ttwbk196pkeAMKSXMRFCMuE/lK9g2h444ck4rI2K7oVwtKlOim+KGst2hWR+UBcdm31VMd79yrTAVKsguhzE9OzzhPANWiIykNEK+KJwub4QjhT/7ggzJONv8De+dsF0yngWW7enDzP8y6bgF6BPTCFD8uQz9z9ySgtftGYzVcK28xnli7EfZ3P4g3bJPchvtppEdf4GIuTAoTyAcSiK/G5KNKXssdiWaKT5HtHKryLSpDkOG2U7uF316jnNfKm8kFVMnqN537dY5wZmDWwEJrNxW5m4j+S36sbWExJkS/WXWzBmRnyVpR3x/h7Ab+muHmatPva4xhHCGBWgpmb4sKZLEHQHBATnPQOUYi8XFxHQ6j
 ryZb+nJv
 9tBFNg7RuZM4ON5vte1m1ECQwMX6SqmgQV5IdVsJWNLoCrhc/fEd70zgP1fZBBrBE2RhCs0Y6PCCDXErwb68xEl5WBcQFwu3amuA60cuXF/b+1J5qTCEU/GefTla/TAQciQ9RJBbkWSPmse3u4HWEznnsmiy4LKNDS+RoGaWhu37/EIy5l91A7QfHDsqIv69KwQ1tahIedjWqReN5BjySi9o/TmGq47hdIwWmleGDRZQAquYIsmvkdvgduXOr5B2hyvu9jyKUHVGfBUzmybyf06UVsOI867TFLmLOlhUizJ8iZU/GtjNQ8R2M9+n34cD41TSPDgq1tOHcD/88/Jr8FqGWPptFuQBtyZRovJVXNmOO8C97+HUxd+nHQgyJr+hh4Su9jlEWvVAvT72DuHS1fLzfwzzt1kgtlqaPIHYYlD1qIpE7CWvKMf2ry4O0EQMHa1Kv3yyfd0gYvlNOeGdNys9FPnA3BejaY2MPSE45M99QZHylFB2Jgzf072O7tnbwMb4cRtxq5H/rcLhHqhdjX4gAgQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>On Mon, Jan 12, 2026 at 7:50 PM Kent Overstreet
><kent.overstreet@linux.dev> wrote:
>>
>> On Tue, Jan 13, 2026 at 03:27:35AM +0000, ranxiaokai627@163.com wrote:
>> > >On Fri, Jan 09, 2026 at 06:24:19AM +0000, ranxiaokai627@163.com wrote:
>> > >> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>> > >>
>> > >> Boot parameters prefixed with "sysctl." are processed separately
>> > >> during the final stage of system initialization via kernel_init()->
>> > >> do_sysctl_args(). Since mem_profiling support should be parsed
>> > >> in early boot stage, it is unsuitable for centralized handling
>> > >> in do_sysctl_args().
>> > >> Also, when CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled,
>> > >> the sysctl.vm.mem_profiling entry is not writable and will cause
>> > >> a warning. To prevent duplicate processing of sysctl.vm.mem_profiling,
>> > >> rename the boot parameter to "mem_profiling".
>> > >>
>> > >> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>> > >
>> > >How was this observed/detected?
>> >
>> > Actually no kernel bug or funtional defect was observed through testing.
>> > Via code reading, i found after commit [1],
>> > boot parameters prefixed with sysctl is processed redundantly.
>
>I was able to reproduce the warning by enabling
>CONFIG_MEM_ALLOC_PROFILING,
>CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
>CONFIG_MEM_ALLOC_PROFILING_DEBUG, CONFIG_SYSCTL and setting
>CONFIG_CMDLINE="1".
>The fix I posted eliminates that warning. Ran, you can post my
>suggestion yourself with me as Suggested-by or I can post it with you
>as Reported-by. Let me know your preference.

Hi, Suren

Thanks for your review and suggestion.
I will send v2 with the Suggested-by label.

I changed the code a little, because when i tested with
CONFIG_MEM_ALLOC_PROFILING_DEBUG disalbed and CONFIG_CMDLINE="1,compressed",
the warning remains:

Failed to set sysctl parameter 'vm.mem_profiling=1,compressed': invalid value

This is because proc_do_static_key() only accept 0 or 1 for write.

Subject: [PATCH] alloc_tag: fix rw permission issue when handling boot parameter

Boot parameters prefixed with "sysctl." are processed
during the final stage of system initialization via kernel_init()->
do_sysctl_args(). When CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled,
the sysctl.vm.mem_profiling entry is not writable and will cause
a warning.

Before run_init_process(), system initialization executes in kernel
thread context. Use current->mm to distinguish sysctl writes during
do_sysctl_args() from user-space triggered ones.

And when the proc_handler is from do_sysctl_args(), always return success
because the same value was already set by setup_early_mem_profiling()
and this eliminates a permission denied warning.

Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Suggested-by: Suren Baghdasaryan <surenb@google.com>
---
 lib/alloc_tag.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index 846a5b5b44a4..c534c1c45f32 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -776,8 +776,22 @@ EXPORT_SYMBOL(page_alloc_tagging_ops);
 static int proc_mem_profiling_handler(const struct ctl_table *table, int write,
 				      void *buffer, size_t *lenp, loff_t *ppos)
 {
-	if (!mem_profiling_support && write)
-		return -EINVAL;
+	if (write) {
+		if (!current->mm)
+			/*
+			 * Call from do_sysctl_args() which is a no-op since the same
+			 * value was already set by setup_early_mem_profiling.
+			 * Return success to avoid warnings from do_sysctl_args().
+			 */
+			return 0;
+#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
+		else
+			/* User can't toggle profiling while debugging */
+			return -EACCES;
+#endif
+		if (!mem_profiling_support)
+			return -EINVAL;
+	}
 
 	return proc_do_static_key(table, write, buffer, lenp, ppos);
 }
@@ -787,11 +801,7 @@ static const struct ctl_table memory_allocation_profiling_sysctls[] = {
 	{
 		.procname	= "mem_profiling",
 		.data		= &mem_alloc_profiling_key,
-#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
-		.mode		= 0444,
-#else
 		.mode		= 0644,
-#endif
 		.proc_handler	= proc_mem_profiling_handler,
 	},
 };
-- 
2.25.1

what do you think?

>> When bcachefs was in the kernel, I spent an inordinate amount of time in
>> code reviews trying to convince people that yes, they really do need to
>> be testing their code.
>>
>> Strangely enough, I have never had this issue with project contributors
>> who did not come to the project by way of the kernel community... :)


