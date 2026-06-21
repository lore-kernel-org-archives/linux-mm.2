Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3271CD4F26
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 02:33:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F1A46B008C; Sat, 20 Jun 2026 22:33:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A31A6B0092; Sat, 20 Jun 2026 22:33:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4929B6B0093; Sat, 20 Jun 2026 22:33:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1736B6B008C
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 22:33:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 76986C144B
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 02:33:15 +0000 (UTC)
X-FDA: 84902347950.24.00E575F
Received: from xmbgsz5.mail.qq.com (xmbgsz5.mail.qq.com [113.108.92.97])
	by imf19.hostedemail.com (Postfix) with ESMTP id A1E681A0006
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 02:33:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=XfO1YKqX;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf19.hostedemail.com: domain of xiaowu.417@qq.com designates 113.108.92.97 as permitted sender) smtp.mailfrom=xiaowu.417@qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782009193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tV+HkNoqzvKpgSRnvGC6RmogVfBvelOvm7aH4UT4sWE=;
	b=mbWlYHj09z7PRGKeKmVQrJL1aC61qOYIgUXAHGHac3jj1TVnGz+DhTzePkAFfqX12zm4Wr
	Hq8WDlmLnBmW6Wp1+qFZVUeo3gZodVBiJQUinElNNo3jabYGlo/T7OzPNUmOrybygxNwJb
	UC4jzjAPN4BdsktnhS3WW+z2+btfza4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=XfO1YKqX;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf19.hostedemail.com: domain of xiaowu.417@qq.com designates 113.108.92.97 as permitted sender) smtp.mailfrom=xiaowu.417@qq.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782009193;
	b=cAsSo5r6tBsbSpfZWN1VNmsWonwAH+M363aLb4uRWZb2hdF8PblSMd37fgwUkM30KiFws6
	vvVxjd77M9e2JXm316OU+4uK7JtYGyxLrhDfUBpsBP9DH4auAJ2KKhf1vJNYT13vikmNjF
	Z6ffoqRuthjcb2ANJjHW0HWPviQnI9w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1782009188; bh=tV+HkNoqzvKpgSRnvGC6RmogVfBvelOvm7aH4UT4sWE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XfO1YKqXVycZDP1g0d5ng3Nc/Xx/VfsVGIZ06/4Uyug0ZMjpF783NjfJG1AQcZpzj
	 pC7Zw+oQzdKf6qWjPZQXKo4SSK6vSmfBBN0PLO7TPGwuOEa89imEN43k+7nbtTaoV5
	 kmiRwEGujnGX+U8bVuyugflqG5NpCiq6x1/Ymh7o=
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-XMAILINFO: MF2s0TKt0BDQ/rAu5/bVF6ZNILrc10mr2NDK5So5PZea2C0ouyc6T0AU7Lv/0m
	 M+tiChHuvcTMkEr7KxEG8VnMxxBZg/FL2VWvaGR+PVbmIS213R4X2rMZTUn0tTK8tqPcAkg54H8hm
	 MolsdFNAM21nSu+sGsS6BwabyTIUlI87LRHTYv6OC+bpdKnIYgkHyx1/8aIg+QOWQKCsFrCuAEOO2
	 ikeK44vqRz3+kEZjQZYtGJHxm7o3OOGlLSLYGaQwguUUo+5isE5F3rdwiQiijWZjrFNcwDinft0xJ
	 uk7SlLwRsMpfemvZf2tyJ/wRtmyJ42c5xoan+9jdHzbu0Fpn0ukU/uLfWzm8UBXVLWgLW68OtxZ+s
	 s7UubAhyGi2OXhd37kt3OG1hB0sUBXP2GDdavSpB4w/mabdznQ6reeBY0HrU5tjSNazw2ZvnH+27l
	 uqBEdF9IFVj65f8p9WJFtt4qO67/4cTjlD03/NsuvHON5OvsdOYj3DQLKVX3cxKysLMUcrFUicMfa
	 FRz+GSBnNjRJtKh047QqHUJ6ONmwAQ7sKinwsMjiHzBWJDzh6flXhZLfD7Qc9nuYS/aj9/xuI2mwd
	 KUiC9lDTKL4D0Tp1LKzldI1FK8ChtHutDuZSilufRP37SnjVKthlobfWZuOgNjb/kWKeFtChGZuoH
	 NIuCGmd2y1PzzrJZyjDT55awvUINzzRpq7VIEjGHNkMHYJL9ZLN8GzWrfqZupeaUNdKg9Q7aljomT
	 czs0HD+4/Bo9RHbKxfmm5qwKbCx0TrClmnshOdZFSxwK3i/Vi8XplgVonX78ZqRHzeRM9wJaZo5jW
	 GxQ+316YYUksIkDpl25GrCh8UrMjB8JQwBbhcROpPiidgoCq8VTZCJuvrlJ0NGU5k2oFk5jd4bI3/
	 x/v8/Sb9BSVlp2QtLRfJYGnW3htAUjy+MT2fam177lsNCnPgb3wNlAgG1RkN3yTeR27g8bfs7+efn
	 +N3w9NvhV6ONr0SHy1f06fEgazvq7hkv5k/ZVjvYsP/w0D4rwV+tYIpXyvr7/g6mJv4/wHNOA9YYv
	 81WKVzAZj0/KqNn4jFku/Aso0866oBomlIAXyY7yYVbBfVMCMRV4ITq3GnogfuCWqPonFdPZgNvcK
	 jcjUlIxFvNXuePoauHAU+5rTvg95QwdWsFBdxMzP9IYHeg==
Received: from [192.168.1.100] ([183.94.22.181])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 75E2FA1F; Sun, 21 Jun 2026 08:29:30 +0800
X-QQ-mid: xmsmtpt1782001770t17vm1vd5
Message-ID: <tencent_45CAE878B5922990DB102BE05A1BAD50DA09@qq.com>
X-OQ-MSGID: <213501bc-74e7-43ef-b72e-83ed5976371b@qq.com>
Date: Sun, 21 Jun 2026 08:29:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next v3 7/9] mm/slab: introduce kfree_rcu_nolock()
To: "Harry Yoo (Oracle)" <harry@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
 <20260615-kfree_rcu_nolock-v3-7-70a54f3775bb@kernel.org>
From: XIAO WU <xiaowu.417@qq.com>
In-Reply-To: <20260615-kfree_rcu_nolock-v3-7-70a54f3775bb@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A1E681A0006
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: ry4w9su48mkzdbfeobocu7nqiz5q9hzi
X-HE-Tag: 1782009192-735133
X-HE-Meta: U2FsdGVkX1+Q9r6z+u8StHtEFF1bkA6F3RXDAA0rlWna23LT3kV4CBLuz6CI3cocRX5ouqQl18XF+CK9XBL5kEYCU8yy4otdkgwd3JJIGkRr874vw0jDcqjUvBda/8fYT4+CXNYF9khAwEajnwnm6GPsWhCNZK0mNpxiDsJmsjfCSeW1GHyXwvdV+nWE653X+x2mIale50Ce7owuA6rluPotQogR2q4zr4Blt8YHvE5Fnc88Uzto03hJrcayqb2ytmMHdejLxC036cAtvotZyF5tg/ifcWMvW28YvTnTnIuoiuVobara5etuoNT9RLrrVfFQ/C1QMJB4Cq56jHki0M7C9p3+LJ/nQm6ZU13YRJh3E/9+CKDV8xwg41oLPUzsoLx5x0wYqhJ26NYRKAnfaubVIlb+8/zgXz6/Z3zPYk/Kzvggd0gsSS+/9xeyzdlD45RqkFxvZmqQkkl/oyUS9RN0yzLTp6sHei852r47PI+3otXMtszfiqkTR+VfB2lT25dWISb+v0f7hWzZaiJ5H+E/wca1+iv3pwNZqEMYBunxA3uOIbTshF4YPHAYucKjHu4agWhepKltytbXmmGqNWXmjPaui40HJTJyFYW05eRErsUBDUbnx49S8B4mPO1LC7Gi/JgUvZtmSOGOE7hbDgQkCPCsmPa4vpDtXbsziTEseCro9hk1CZJ2cFLPWHWEMPP21pxbvV682pDIzTGux2mncI8j6KLwHy6KzztUBaSseFzRpx/M0G7fvS1DDwpeuxm1e4r3ZCCWTqDDA7FApKj/LosROZcI0QO/c4XFUr6ObAsKUEbXTOa3rYRQGCH5f/HKG62p1XeGl1V8x/yAMK+NLCs2fa8xse7jIzTXh4FBdxap2E6QBCJWx0BRmoaDjE+KX9hjBLiK1SQJghUjl3aIilUrCUVsjOYVm7OcOgu9dS09Bo+Q3aNQG1xGbWQsmuoMqkMS+ZoWiVF/9cR
 Gp0i/Vdg
 vziANuAfsfwNpiSnsIoTtOIBFo6LKGCRkJX+KfH2JPIl3CcAwqTMUd24tIJT3/c6jojYtlLbNi0n8qd8eXGPL57LD+5NdtU32NOQheEjf5Cn9zmQmCs/kC1v4cxafrMDqEAsxL1ya5w7sLEXmCiqjEWU3sm9Lna+PwG3fpKyp5xkVF1IIy2GB1R78/V4jvqvVlWiJ0N3RfHbnXSNs6d+UB3wDMQHrUe/+7v7O0pCDTIqVY7xOdl8G02aa6mu8TJloE2mW3NVwUZjilbc5asn9c+kwVRhW5MOTO7kAWzzECfXjaYcFCgQ2MC91IWvYYAKz2zpMtPBmIdAjeYdU94Mh2S0iyYWkcxM0P0P3vIeCd7aG/4gVB3dnLVLXy6jB5f2CHG4UK98Tt/bjYCQ/7+1+hYNSW7uymXjjBX1zdJu3afr33wVX8Wn4DSL43KbyULtJPZUU0mgg7q7w4cb+zqSn2fldVbcK/3S9Dd4nvXUicgKi2h6L2o+WBcEqVQGGWxvMlRAn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I noticed the Sashiko AI review [1] in this thread flagged that
kfree_call_rcu_nolock() dereferences slab->slab_cache even when
virt_to_slab() returns NULL (for large kmalloc objects that bypass
SLUB, or vmalloc addresses).  The VM_WARN_ON_ONCE fires but does not
stop execution, and the subsequent NULL dereference is deterministic.

I was able to reproduce this in QEMU with KASAN.  The trigger is as
simple as passing a large (>8KB) kmalloc buffer to the new function.

On Tue, Jun 16, 2026 at 12:06:14AM +0800, Harry Yoo (Oracle) wrote:
 > This commit introduces kfree_rcu_nolock(), a variant of kfree_rcu()
 > designed to be safely called from unknown contexts without falling
 > back to batched processing.
...
 > +void kfree_call_rcu_nolock(struct rcu_head *head, void *ptr)
 > +{
 > +    struct slab *slab;
 > +    struct kmem_cache *s;
 > +
 > +    VM_WARN_ON_ONCE(is_vmalloc_addr(ptr) || !virt_to_slab(ptr));
 > +
 > +    slab = virt_to_slab(ptr);
 > +    s = slab->slab_cache;

The problem: if ptr is a large kmalloc object (> KMALLOC_MAX_CACHE_SIZE,
which is 8 KB on x86_64), the allocation bypasses SLUB and comes from
the page allocator.  virt_to_slab() returns NULL.  VM_WARN_ON_ONCE
prints a warning but does NOT return, and the next line dereferences
NULL->slab_cache at offset 0x8.

[Reproduction]

I rebuilt the kernel with CONFIG_KASAN=y and added a small late_initcall
that allocates a 16 KB buffer and passes it to kfree_call_rcu_nolock():

   static int __init kfree_rcu_nolock_poc_trigger(void)
   {
       void *p = kmalloc(16384, GFP_KERNEL);
       struct rcu_head *head = kmalloc(sizeof(*head), GFP_KERNEL);
       kfree_call_rcu_nolock(head, p);
       return 0;
   }
   late_initcall(kfree_rcu_nolock_poc_trigger);

[Crash log — kernel 6.19.0-rc5, CONFIG_KASAN=y, CONFIG_DEBUG_VM=y]

   kfree_rcu_nolock PoC: calling kfree_call_rcu_nolock on large obj 
ffff888026c5c000

   WARNING: mm/slab_common.c:1271 at kfree_call_rcu_nolock+0x1e/0xc0
   VM_WARN_ON_ONCE(is_vmalloc_addr(ptr) || !virt_to_slab(ptr))

   BUG: kernel NULL pointer dereference, address: 0000000000000008
   #PF: supervisor read access in kernel mode
   #PF: error_code(0x0000) - not-present page

   RIP: 0010:kfree_call_rcu_nolock+0x5c/0xc0
   Call Trace:
    <TASK>
    poc_trigger_init+0x2a/0x40
    do_one_initcall+0x131/0x730
    kernel_init_freeable+0x471/0x7e0
    kernel_init+0x28/0x300
    ret_from_fork+0x2c/0xc0
    </TASK>

   Kernel panic - not syncing: Fatal exception

The crash is at offset 0x5c inside kfree_call_rcu_nolock(), which
corresponds to `s = slab->slab_cache`.  The fault address 0x8 is
exactly offsetof(struct slab, slab_cache).


[1] 
https://sashiko.dev/#/patchset/20260615-kfree_rcu_nolock-v3-0-70a54f3775bb%40kernel.org
     (Sashiko AI code review — "Null Pointer Dereference", Severity: 
Critical)

Thanks,
XIAO



