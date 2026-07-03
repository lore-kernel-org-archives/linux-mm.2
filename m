Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27043C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 14:56:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D6636B00E2; Fri,  3 Jul 2026 10:56:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ADA96B00E4; Fri,  3 Jul 2026 10:56:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2CCE6B00E7; Fri,  3 Jul 2026 10:55:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C90D86B00E2
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 10:55:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 612D916748D
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:55:59 +0000 (UTC)
X-FDA: 84947765238.10.DC634F4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 79C5C4000A
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:55:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=S9oYgrZ6;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783090557;
	b=drXFJTWKfYIfOiUZazgHurzsZFwsfbdP9nIRIp8t7H+439HvbLs5omxnm84VUBKShThLY2
	5xA2Cnlgm7j4GVtV/g1NQBxBc41BzzuvsMJYos+aWOcdNqdlQMZZcniHfmYkhbqS2ouhJC
	r0X3FP5eFlyPXgBUtcVVhnuZmwm64Vk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783090557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cGWlFizItLokHbB6gyTMYbR1Uonw5gP5kj/g/LGNvhc=;
	b=tHshbqnC9Az8NkZdUNQCw1zgswAmun/FE+8zxbRTX/s9viFUz1RR3eCWsvFbqxXLa4YynC
	CXMYhERLOcCNCOswHVYnHSJuQzH28C9oEGviCLxfpwjlu50BzfH/lVTn7Hv671bM00XmXJ
	nB0HUNwQTpra+jONiZYArY8rS9TpX2A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=S9oYgrZ6;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 09F25463D;
	Fri,  3 Jul 2026 07:55:52 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 232E63F905;
	Fri,  3 Jul 2026 07:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783090556; bh=SK6N+4Kw2vy3x3+hsIpZLgF9nRE23C7o4xhOpyb/k/c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S9oYgrZ6oZsHOH0UoMqYEbvDMsroTPuwSE+HzZ1xYfswP+KuNpt4B4BU+MPhwQaMI
	 EqEgmcaEU87K9wHDfliJoPeBcjQLouWsiRU70cB2lNN4blfSISh21tM0JSG018OnTH
	 MG/uKQvVHeqECM5D5aO7kSxfdYFOQ07yVWLmxUDw=
Date: Fri, 3 Jul 2026 15:55:52 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 2/2] selftests/mm: test kmemleak's N-consecutive-scan
 leak confirmation
Message-ID: <akfNeK7OOpvoZE9z@arm.com>
References: <20260626-kmemleak_twice-v1-0-ab28f7cc0971@debian.org>
 <20260626-kmemleak_twice-v1-2-ab28f7cc0971@debian.org>
 <akYkKgWOsYnw6ETE@arm.com>
 <akZ4tzQw70x3RR2D@gmail.com>
 <akeX8mFiizd65pDw@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akeX8mFiizd65pDw@gmail.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: op1yf9ied943udc7d8gzhj5x7odqu5yq
X-Rspamd-Queue-Id: 79C5C4000A
X-HE-Tag: 1783090557-562971
X-HE-Meta: U2FsdGVkX18PsqUmf9XW8RA1EujKNQqMZk0G/yON0BfnOyEC07NQjmEord/xTcs+QZKVrvuJ1f6fWzJpgWjwXPcSlD3fZnMKJA7eSaKDYeb5v8TVk5lU89MHtMAqGqgHDNm6L0FUTmhJqzp7lnI83I//nPXieb80oG/L48PIbJqLD+vDHwLShP8wmrAFqKUMC3PZeMaPgYVTPzye4SEwSNz/sTLETEFxx5p+/A1+q7EZGsqKPSx7AWmaRRfsJ73I51/gzQfo0brPJMFrm3Y+XpIH88JBzWm3+MI2aFBWaCizFu4GAIdYFIZkxqfQDpZdkND5tPXHNhDQ5jJNHSPKmQNm+5u102xd3dYBPOcNk+ZTUypK2U8/hGnJKn0PaLQVoV3XPRQdphWUfhUzJJTc9nMHiiyqMXR9v+OekYnKJIw3A5RIJsAcmKP9iHS9l+FDI5A5J/f5Y14GPWI2N8aIaQKb8G6+tTiqu5JK6bhhrKmtd930FLdi9KLXUdc69XJvWre8nmSTxAwDX8cvby6KqO82pfqc4Z21aytPhDBDWAxlu1H7aun+B0tvyyS4UyFLypfOg2HPMOvWI/zPtjQCv5b/97l2xAl/IgQCm7vFyRWrcLv6PJ7z8Af0iTZ53hzo/xt2dLXsskLUu988KrJxTUOw0NXmS+dN+AvQxuNO8hLdf3/QcrObm8uQDO9A4fKLYDOPhfl51V84sEopl/wB/DVrCF7g5zWSLWFUY8XrVS/cbo/WwJPuZUJTUd97IJoHRlSbkS0aCw2TVFdH6Wi8loMkRt6z5X0QD1LQN0IJX7i7iW3ZeJ4uyR+Oyx7ptO8vmxk0ElDQYy3VpSntqO4w6bQiPUg1HfgdQwX8Y7AieNCHwE8DO2HT5I/lrrBrVEZBc1QKWbaVxiODJSpmJEfnHWxcX8paqhHJB6uP2n7vDn87ITol2bjmvGeRD90ExJ180V2Z6u+CwJQ0UiPJO2x
 JS+OZr1U
 3VZ6G0+XgzLWsaKtHwnlxW4QwCX4JOaKDBVKsYzGsujuphJbNbj+wr5uZya2cRJaQxDjlv/YX/h2Zvk0GXgvtM94FT3WDMKzxRDi743E3KoVFO2GDMgbZCOXW+OvUgnc14WSamOK3eaJviDYFgZQrO7x2IY9hDiBLGb1Kd36U5oYuPgqcP8omTUjqhFiY7cOTXnHZdLR7OEcxUIeuky3lzuzIwXS1pIf5bWBJcRtXum4wwkg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03, 2026 at 04:24:09AM -0700, Breno Leitao wrote:
> On Thu, Jul 02, 2026 at 07:55:42AM -0700, Breno Leitao wrote:
> > On Thu, Jul 02, 2026 at 09:41:14AM +0100, Catalin Marinas wrote:
> > > On Fri, Jun 26, 2026 at 08:52:03AM -0700, Breno Leitao wrote:
> > > > +pass "min_unref_scans=1 immediate; =2 gated to 2nd scan (counts $first/$s1/$s2); param read-back ok"
> > > 
> > > Are these off by one?
> > 
> > They seem to be OK, and I've tested it multiple times.
> > 
> > > Kmemleak has a mechanism to detect live objects
> > > via the checksum. A side effect is that on allocation, the checksum is 0
> > > and only after the first scan the checksum is changed.
> > 
> > I got the impression that checksum continues to be zero for these
> > objects during the whole life time? (weird). 
> 
> I've investigated this a bit more and I found something interesting, in
> our per_pcu checksum. The code in update_checksum() is:
> 
> 	for_each_possible_cpu(cpu) {
> 		void *ptr = per_cpu_ptr((void __percpu *)object->pointer, cpu);
> 
> 		object->checksum ^= crc32(0, kasan_reset_tag((void *)ptr), object->size);
> 	}
> 
> From my naive view, this has two concerns:
> 
> 1) In the kernel, crc32(0, <64 zero bytes>, 64) is zero, and the samples' test
> I am using (kmemleak-test.c) has:
> 
> 	pr_info("__alloc_percpu(64, 4) = 0x%px\n", __alloc_percpu(64, 4)); 
> 
> alloc_percpu returns ZEROed memory, so, we are checkingsuming zero content.
> Because we are using 0 as seed, that is returning zero.
> 
> object->checksum is a bunch of 0 XOR 0 XOR 0 and so forth.

Ah, yes, you are right. Irrespective of the per-cpu xor, I think we
should seed the checksum with something other than 0 (say -1 or some
random clock value).

> 2) that XOR above seems very weird. Basically we want to detect if some of
> those per-cpu areas changed, here, but, if checksum goes to zero if two object content is similar.
> 
> Let me give you a simple example. We have SMP=2, and both objects have crc32 =
> 0x42. At the end of that function, object->checksum will be zero, given 0x42
> XOR 0x42 is zero.
> 
> If both object changes their content at the same time, object->checksum will
> continue to be zero (although the content (and checksum) HAS changed).
> 
> I understand we want to detect any change in any of these per cpu field and
> catch it independent of the CPU. I am inclined toward that.
> 
> 	--- a/mm/kmemleak.c
> 	+++ b/mm/kmemleak.c
> 	@@ -1409,8 +1409,9 @@ static bool update_checksum(struct kmemleak_object *object)
> 			object->checksum = 0;
> 			for_each_possible_cpu(cpu) {
> 				void *ptr = per_cpu_ptr((void __percpu *)object->pointer, cpu);
> 	+                       u32 seed = object->checksum + cpu;
> 
> 	-                       object->checksum ^= crc32(0, kasan_reset_tag((void *)ptr), object->size);
> 	+                       object->checksum ^= crc32(seed, kasan_reset_tag((void *)ptr), object->size);

Yeah, the xor wasn't a great idea. What about initialising the checksum
value on object allocation to ~0 (for the two-scans idea) and for
per-cpu, just build the crc on top of the previous crc, something like:

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 7c7ba17ce7af..e196f53f9b46 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -687,7 +687,7 @@ static struct kmemleak_object *__alloc_object(gfp_t gfp)
 	atomic_set(&object->use_count, 1);
 	object->excess_ref = 0;
 	object->count = 0;			/* white color initially */
-	object->checksum = 0;
+	object->checksum = ~0;
 	object->del_state = 0;
 
 	/* task information */
@@ -981,7 +981,7 @@ static void reset_checksum(unsigned long ptr)
 	}
 
 	raw_spin_lock_irqsave(&object->lock, flags);
-	object->checksum = 0;
+	object->checksum = ~0;
 	raw_spin_unlock_irqrestore(&object->lock, flags);
 	put_object(object);
 }
@@ -1410,7 +1410,8 @@ static bool update_checksum(struct kmemleak_object *object)
 		for_each_possible_cpu(cpu) {
 			void *ptr = per_cpu_ptr((void __percpu *)object->pointer, cpu);
 
-			object->checksum ^= crc32(0, kasan_reset_tag((void *)ptr), object->size);
+			object->checksum = crc32(object->checksum,
+						 kasan_reset_tag((void *)ptr), object->size);
 		}
 	} else {
 		object->checksum = crc32(0, kasan_reset_tag((void *)object->pointer), object->size);

-- 
Catalin

