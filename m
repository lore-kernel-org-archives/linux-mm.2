Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58D5EEE36B4
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 17:54:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADB276B0089; Thu, 12 Feb 2026 12:54:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB3146B008A; Thu, 12 Feb 2026 12:54:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E97D6B008C; Thu, 12 Feb 2026 12:54:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8D9E06B0089
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:54:27 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 44DABC1382
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:54:27 +0000 (UTC)
X-FDA: 84436554174.23.1991BAA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 51A13140008
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:54:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770918865; a=rsa-sha256;
	cv=none;
	b=HwY9GNpEKH+i+0vpeAOvsizD75G4O8M5vJnNHTmWLO33PwqTktWozBCDIQDPZ/QIa1tgmB
	WaUpHCm+9BzXHpJ2438/kTKnW2VVgV4iqNs6pfR480JM42nbfbMHp86MXxGQy4fsO4ZSBH
	6v9jwHd7gkyTnx0WgrLCc9A3xmbxneU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770918865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XjwRo3/aNHQI0fko4fjuhSSl5Zy+5yR8Y/GvkeqBeMM=;
	b=zKk8ZmZnuipq7uLnwmu8m8WKWdLTNnpBcGqIhjbVylJ6XY0MrAyyQ/KxRcLgtjE7KiWQ8v
	jlP8irnQJJWx1E9U12cPE0eJuNQ9YeMFEGsTE0fwC6f2yFNo7oFjg2whoGDwyWy2LlZioK
	tf//76uS3ZJY+FDUJ0uMPzaJ4EcUpaQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 250EA339;
	Thu, 12 Feb 2026 09:54:18 -0800 (PST)
Received: from arm.com (arrakis.cambridge.arm.com [10.1.197.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6E4D33F63F;
	Thu, 12 Feb 2026 09:54:22 -0800 (PST)
Date: Thu, 12 Feb 2026 17:54:19 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yang Shi <shy828301@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, lsf-pc@lists.linux-foundation.org,
	Linux MM <linux-mm@kvack.org>,
	"Christoph Lameter (Ampere)" <cl@gentwo.org>, dennis@kernel.org,
	urezki@gmail.com, Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>
Subject: Re: [LSF/MM/BPF TOPIC] Improve this_cpu_ops performance for ARM64
 (and potentially other architectures)
Message-ID: <aY4Ty6G6A3478_JS@arm.com>
References: <CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com>
 <aY0Q7QhGDKwKk2ie@slm.duckdns.org>
 <CAHbLzkoE0UQLZSKQJttv1_XGT-6HPKdj5o7aYnpuiXEyvbAHxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHbLzkoE0UQLZSKQJttv1_XGT-6HPKdj5o7aYnpuiXEyvbAHxA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 51A13140008
X-Stat-Signature: gomdbwi3a6r81u7eup4aanbgnmspobfi
X-HE-Tag: 1770918865-136024
X-HE-Meta: U2FsdGVkX19IsZ1oX5KLn8qu9zXgpwyJUumU5/DZuTkgzIuIzGfErPFN/+1n4Wew6rn9iXZ0wpbvNIgvZ8t4rn/Zyi1ZNKrma+E+dRII+ZZRKMTNqNKuMWzIKRCMrle39WoRs21TufTpQH6wITl7RtejlEgtaQ/xtBB0XKGG/IhIXrVp2BwLoyCJjrIepBT9bm/gMv839ouYZtKOu2ymIldvwfyD98LCUFyRvdmgFyq1rsPoAJLd3aLARqkKgK+Z9ePwqZ8IiGetWUQAUKWhijjyez4IEJlAxoyrqeWDO6/1j8cQAyXdfjBSVVFphlJVZ+L/VVQTnXJkCs6Rc8HBF9x8i2RCBpDMmKxnOjc4WYxNH8II0DR4wUcedJzJEkBe+FgNcYBs3w1ZcIZnWSrV5xjhwLuRfwK9KYEuZke9PX5893Jmrfltl/B3KGx5FB3oQL8KR5dc+1Z+rli3/i+Xi5BXAednYC+KCC36UoT9fguXDraNj/n9NVITLAJIV02JQD0i1FcfltJTZDySPZW2zhwkT/jn2RuI1T2uDcZprEP4N70mJcWvvrqcYSkPrGINLTqhm8g9+TuAY+yUT434YSwkiUiXTjkUFM+7g8yUa8iX3WQKssc479SjskjHSjpIVJXqurCfRSAXQqMyPK//i0cUWEyKxt8fYKu+Fp+mf1SnIMnLnmE9VXwvpoY2T0cmXQFJ2jF3n8qHA6149QoorSJxSzbg8L1kOgh8bLBHuxe7UwOXSkbfbLi+RfM3gEj1emO8S4dFOyXGp6P1BtnsGqVJSj52p81rhBjoyd9584U0JzclxHjcvfyvPsceEVjdjf/Az0MY8NAt2SxzCtis1rUa/fMsXg9btcxh6hfoQVJ+IdUxrJG7b4YvO+zsHLWtGEp3i0YD5xG49HuTzM9lpH6jlqUrIGC/jHNsMCfL8jyu0mroN66B7qHd9+/CmuOIuvTuoR1FLTTVWrU4qoi
 s3QzkbrH
 hhZ+xuUZD8tpzUwTz9NtfsQkHnhRWDvh8R2y6cF25NBsV7dGWQArOVoYEaj6GfE/3R/6L7CX4Uwwa0/n61yL+K5M16wH37EXGP9t6e8laBEvwyNGREoevwEB4tMo2v43AVM6mBATOYsyFdPjTr7YVHOwzw4po/ldl7vu35EYtqu15VGmYtipWtCoEm6DsNhWTMp5C8oQcRbuzbvRlKK4hbIvAZ8C8hdlJC3OPx1BwXt8szeM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 03:58:50PM -0800, Yang Shi wrote:
> On Wed, Feb 11, 2026 at 3:29 PM Tejun Heo <tj@kernel.org> wrote:
> > On Wed, Feb 11, 2026 at 03:14:57PM -0800, Yang Shi wrote:
> > ...
> > > Overhead
> > > ========
> > > 1. Some extra virtual memory space. But it shouldn’t be too much. I
> > > saw 960K with Fedora default kernel config. Given terabytes virtual
> > > memory space on 64 bit machine, 960K is negligible.
> > > 2. Some extra physical memory for percpu kernel page table. 4K *
> > > (nr_cpus – 1) for PGD pages, plus the page tables used by percpu local
> > > mapping area. A couple of megabytes with Fedora default kernel config
> > > on AmpereOne with 160 cores.
> > > 3. Percpu allocation and free will be slower due to extra virtual
> > > memory allocation and page table manipulation. However, percpu is
> > > allocated by chunk. One chunk typically holds a lot percpu variables.
> > > So the slowdown should be negligible. The test result below also
> > > proved it.
[...]
> > One property that this breaks is per_cpu_ptr() of a given CPU disagreeing
> > with this_cpu_ptr(). e.g. If there are users that take this_cpu_ptr() and
> > uses that outside preempt disable block (which is a bit odd but allowed),
> > the end result would be surprising. Hmm... I wonder whether it'd be
> > worthwhile to keep this_cpu_ptr() returning the global address - ie. make it
> > access global offset from local mapping and then return the computed global
> > address. This should still be pretty cheap and gets rid of surprising and
> > potentially extremely subtle corner cases.
> 
> Yes, this is going to be a problem. So we don't change how
> this_cpu_ptr() works and keep it returning the global address. Because
> I noticed this may cause confusion for list APIs too. For example,
> when initializing a list embedded into a percpu variable, the ->next
> and ->prev will be initialized to global addresses by using
> per_cpu_ptr(), but if the list is accessed via this_cpu_ptr(), list
> head will be dereferenced by using local address, then list_empty()
> will complain, which compare the list head pointer and ->next pointer.
> This will cause some problems.
> 
> So we just use the local address for this_cpu_add/sub/inc/dec and so
> on, which just manipulate a scalar counter.

I wonder how much overhead is caused by calling into the scheduler on
preempt_enable(). It would be good to get some numbers for something
like the patch below (also removing the preempt disabling for
this_cpu_read() as I don't think it matters - a thread cannot
distinguish whether it was preempted between TPIDR read and variable
read or immediately after the variable read; we can't do this for writes
as other threads may notice unexpected updates).

Another wild hack could be to read the kernel instruction at
(current_pt_regs()->pc - 4) in arch_irqentry_exit_need_resched() and
return false if it's a read from TPIDR_EL1/2, together with removing the
preempt disabling. Or some other lighter way of detecting this_cpu_*
constructs without full preemption disabling.

-----------------8<------------------------------------
diff --git a/arch/arm64/include/asm/percpu.h b/arch/arm64/include/asm/percpu.h
index b57b2bb00967..7194cc997293 100644
--- a/arch/arm64/include/asm/percpu.h
+++ b/arch/arm64/include/asm/percpu.h
@@ -153,11 +153,17 @@ PERCPU_RET_OP(add, add, ldadd)
  * disabled.
  */
 
+#ifdef preempt_enable_no_resched_notrace
+#define _pcp_preempt_enable_notrace	preempt_enable_no_resched_notrace
+#else
+#define _pcp_preempt_enable_notrace	preempt_enable_notrace
+#endif
+
 #define _pcp_protect(op, pcp, ...)					\
 ({									\
 	preempt_disable_notrace();					\
 	op(raw_cpu_ptr(&(pcp)), __VA_ARGS__);				\
-	preempt_enable_notrace();					\
+	_pcp_preempt_enable_notrace();					\
 })
 
 #define _pcp_protect_return(op, pcp, args...)				\
@@ -165,18 +171,21 @@ PERCPU_RET_OP(add, add, ldadd)
 	typeof(pcp) __retval;						\
 	preempt_disable_notrace();					\
 	__retval = (typeof(pcp))op(raw_cpu_ptr(&(pcp)), ##args);	\
-	preempt_enable_notrace();					\
+	_pcp_preempt_enable_notrace();					\
 	__retval;							\
 })
 
+#define _pcp_return(op, pcp, args...)					\
+	((typeof(pcp))op(raw_cpu_ptr(&(pcp)), ##args))
+
 #define this_cpu_read_1(pcp)		\
-	_pcp_protect_return(__percpu_read_8, pcp)
+	_pcp_return(__percpu_read_8, pcp)
 #define this_cpu_read_2(pcp)		\
-	_pcp_protect_return(__percpu_read_16, pcp)
+	_pcp_return(__percpu_read_16, pcp)
 #define this_cpu_read_4(pcp)		\
-	_pcp_protect_return(__percpu_read_32, pcp)
+	_pcp_return(__percpu_read_32, pcp)
 #define this_cpu_read_8(pcp)		\
-	_pcp_protect_return(__percpu_read_64, pcp)
+	_pcp_return(__percpu_read_64, pcp)
 
 #define this_cpu_write_1(pcp, val)	\
 	_pcp_protect(__percpu_write_8, pcp, (unsigned long)val)
@@ -253,7 +262,7 @@ PERCPU_RET_OP(add, add, ldadd)
 	preempt_disable_notrace();					\
 	ptr__ = raw_cpu_ptr(&(pcp));					\
 	ret__ = cmpxchg128_local((void *)ptr__, old__, new__);		\
-	preempt_enable_notrace();					\
+	_pcp_preempt_enable_notrace();					\
 	ret__;								\
 })
 

