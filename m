Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C67FD31A15
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 07:25:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EDF26B0089; Wed, 14 Jan 2026 02:25:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BB3C6B008C; Wed, 14 Jan 2026 02:25:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DE966B0098; Wed, 14 Jan 2026 02:25:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6CBF46B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:25:55 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DEB8A8B8E3
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:25:54 +0000 (UTC)
X-FDA: 84329735028.26.DA5AF6B
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf08.hostedemail.com (Postfix) with ESMTP id D923E160005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:25:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=iCU2IWq3;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf08.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768375553; a=rsa-sha256;
	cv=none;
	b=OlPwIGeYC2Av2K0WDGDus3HYkMYcvkp6ZPswjLgAaUAmuhcVwjs7hgP4TbW3/t9Vs+XLZK
	ZtPuQCGyLy/W2GRLXh5pCrn1BBQsnjvXw955nQpCfDymCCl4zgxqB3HNpXwIBTFXhG1X8f
	MhOJ9j5rnp9AoDamtrGt0cKrfdjsjmY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=iCU2IWq3;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf08.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768375553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sDfhHZq7pNuGramNwSmcc9whrmx0jtWM21KT7YNBBeQ=;
	b=5xbM9rfRHztZRjcjCkdSCzWRyTlo8mIFff9CUgLzAExBT6kRFtLBUlz3mOCMmbVBILNUEL
	gYVHpcIwP+f2+vjiT5tC3bv6iufvKsOKdx8P+uP7Vqc4eXyEWLu5J2U0OioRY0Z651xpDz
	ARhABsy2X/gcyL/yfto9YaiXqHYyIVY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version:
	Content-Type; bh=sDfhHZq7pNuGramNwSmcc9whrmx0jtWM21KT7YNBBeQ=;
	b=iCU2IWq3Z1xq2GxuiyHBBn5sQAv+AskaZoeE6RjOELgW1d5TomuijJU/q8M53k
	0dgxPAyfvfJGXN1iFVNtgOZzJ6b26XQnzYgXqM7x+r0F2QR0hOKfIY/0Y0wmkC2I
	gxlgoylmKpYu7tuYN+i7rKhoewFrLqvo4YNBIIVBTbMCQ=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wBXu7XVRGdpOfHRFw--.72S2;
	Wed, 14 Jan 2026 15:25:11 +0800 (CST)
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
Date: Wed, 14 Jan 2026 07:25:00 +0000
Message-ID: <20260114072507.163364-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAJuCfpFTJUowSAjNum1zecDJYuyUi84vUNkoNNf=CnUwpsTVeg@mail.gmail.com>
References: <CAJuCfpFTJUowSAjNum1zecDJYuyUi84vUNkoNNf=CnUwpsTVeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBXu7XVRGdpOfHRFw--.72S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGryUWry3Kr4rKr4kKw1kuFg_yoWrAF1fpF
	y0gF1Ykw4kJryxCr92ya4Ik34Syw48Jw42qasFgry7ZwnIkrWDJr1kKFWS9FnrXFZFkF4r
	XF1jvr97uw1UAwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUo5lUUUUUU=
X-Originating-IP: [117.176.243.29]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbC7hh7x2lnRNhn2QAA3m
X-Rspamd-Queue-Id: D923E160005
X-Rspamd-Server: rspam06
X-Stat-Signature: 5dh6uoygiwtbzcukrcpdqf3me3sra3aw
X-Rspam-User: 
X-HE-Tag: 1768375551-144481
X-HE-Meta: U2FsdGVkX1/cHtRywmll8P8/YViIvYI51MMQoaLe/EDFlkPoUSO5OReVRoZ2V2jgxx5sJcE+RwmocNg4RuJ/otuKknwKMDEnnQI/JUxdAty48vyxd2teI7iYaxN7kVA0jHQQKD75O8wdWoCPbsnU2l+wZeK9iIpP7Vj5Fb8Z1LwL/dtM4MeA5TYEdWx09bHSowFIaJ1T0Z4NXNPp3RFlAGfC4fwp6CeISTFkaaWkVV3fkhArTabhn37SvbCXTrLW1jWw0hITHc0vZIYgoqRHWJNHHYhiKB9h9bj6cWoVpxrZL3FzfgRYc8CaQY4JviCjyytceZJ2HuX/ghQug9PcnHzlZGuc66IN6+OzuTkngqLLc+O7evMz6RTbAgkV8a93SVeWlfl1kVgRSqHFQxVJhAm5elpgPTLMm4KcMRkyEUQXDb8ohFPOUb/dFVafgtL/ETBA56i/elOT9qhHkeXlrkyU6zY7ijCnE14qYbDF33eSEXtO5rhgNNS1oWWeRUGOQqmRNZhjhVeWztXKmJcBh6CovC1bfbalsBLKDDmgnJQzAqUe5++IPpHs2vXem9TTomPXVo8r6oL4e+DNEOrYjt6v844+Wy6rgr2vy2D/RvPgdU9W5FwA3D/Vggfi67NQwqoDiEYY/4jSJxoEA0/F7PO7aQT5Kdqj8hX7ZEE7cPPz6Jdkv2Juvwfl/dVHTe3wG08vDeyi7aDRLeLat8DtVHthIQIXKX3cQhEQsoSkzlKib98a6W48dt7KG0gVNnoUeMi+/i/8qtHwyE7XfL3hl1CLG/N8tYN9DCB0WjywfcXWGN1ixfMYkP/pNa4vAkfVqLVdWHQJlmdbnx2iZxplq725CFLo5GtlzNs0edjwujCf+CV6Ik4D0ZwGHZVnFZ70fsEARjNo1ZYtZBU8zLwX2uENl2HulGRxKyL+194zj1xuzfUAS3ToSwq/6Y4sD8bxv+gmTBFMBVPL23eiiEB
 +sUg0uW8
 7lh19z55Q/BAlfYhbrfJIopx6eCiBJEzlMI8hNFpuvNe0us91wKynEzeyMOR2gRvzPpS6VpmIYU2wqjqhCb2fDDIzQQJZXDENJeGu5qmvr8X//i5fUYW79oLeYgCx7RzUXbqu39rUETrIY7eDLQ17lNPauBudg3ZIXaa/zAr3L9ERuyJ13y8AOT6RR14UL+XdeavBIL3giGkiVK+tPFZJvsfgzfC3fWrjGaG5reoWI8UpifQ9noUGYvk6Kgsm9IwttaXvoxaQzgRa7MYNs/qnL3B9vRpM1LQ2n1vw9rC0Ds9S8B0W1TPySvdOLryyRnt8qPywH+vfE3bpzEdK4gGGo0m1A3dTdWJrlpQ9Suo+AbdxWDiYILiKAHWolAxGJTRow1gdxv4OMvKtrgj91ORO6T0/u8BzH7V0Lq0f/e9XX7zLDN/2brv9ICTS0/p0eQQHVrnVLi3rwc/WzD0te/GcQ6Hqr3vKK1r9U5NcgpKEynKZi5gFmo19yEpVFedhgMRAl32E
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

I think this version is better.

[PATCH] alloc_tag: fix rw permission issue when handling boot parameter

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
Suggested-by: Suren Baghdasaryan <surenb@google.
---
 lib/alloc_tag.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index 846a5b5b44a4..00ae4673a271 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -776,8 +776,22 @@ EXPORT_SYMBOL(page_alloc_tagging_ops);
 static int proc_mem_profiling_handler(const struct ctl_table *table, int write,
 				      void *buffer, size_t *lenp, loff_t *ppos)
 {
-	if (!mem_profiling_support && write)
-		return -EINVAL;
+	if (write) {
+		/*
+		 * Call from do_sysctl_args() which is a no-op since the same
+		 * value was already set by setup_early_mem_profiling.
+		 * Return success to avoid warnings from do_sysctl_args().
+		 */
+		if (!current->mm)
+			return 0;
+
+#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
+		/* User can't toggle profiling while debugging */
+		return -EACCES;
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


>> When bcachefs was in the kernel, I spent an inordinate amount of time in
>> code reviews trying to convince people that yes, they really do need to
>> be testing their code.
>>
>> Strangely enough, I have never had this issue with project contributors
>> who did not come to the project by way of the kernel community... :)


