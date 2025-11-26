Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41B1CD111BE
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 23:31:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8338A6B0012; Wed, 26 Nov 2025 18:31:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BC586B0022; Wed, 26 Nov 2025 18:31:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AB326B0024; Wed, 26 Nov 2025 18:31:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 52ACC6B0012
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:31:25 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA0D21A05FC
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 23:31:24 +0000 (UTC)
X-FDA: 84154356888.14.ADD749E
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	by imf01.hostedemail.com (Postfix) with ESMTP id C2B4D40006
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 23:31:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=OMQTGPEv;
	spf=none (imf01.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764199883;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ICd8G5D0Nxy6iHBtTIxjwZs9PaKgLQ/+fqX/nFiMHTk=;
	b=dkgip7Ao3V0eGTph8l6/QzUm8BHoLwMXBRwBvKJNJGQieRV+Atr2wwDBxkoHGU37awh9UC
	16vVH0x1sXao/SWk8iPb8h4gy4iMeoxuPV9FavZ5E2jVpgemid9LuaHig/s6IT/GPTghus
	J/rh5C8Ydzfeu1D6n5bQ5NTXk1eYYW4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764199883; a=rsa-sha256;
	cv=none;
	b=V27rur9NY7auUmfytk+6YOMe7fe4X0XBVrYUBkA6tnkaMXhSY+nSAXzQncEm72FnNuhhLK
	sbwox1MjoxsuczaQz+KWIWTWDWIzYs1+zVurpxsXfktsGO4CNeB/oth0iuGFE6Xz4qS5Lg
	uGBqmqFpufIXvfizH+Xiyv6opPmoxdo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=OMQTGPEv;
	spf=none (imf01.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ICd8G5D0Nxy6iHBtTIxjwZs9PaKgLQ/+fqX/nFiMHTk=; b=OMQTGPEv+0m2vczeCsiycqa7Ei
	Wuo0I3V8eJv5d0zYs5flQN4ysmgsl3TmQvaNIjAK5mAX+icsKntbdAQLW7GcLaWXNhd3Cs7yk3Zz0
	LVB+3AsbzWJ/versa1R4lmzwjvA2MQsPskSNcbiAyvLXQoEW2yueeaVi7E1gnca2sAi9NasppJXra
	45y58mWzoBjoFcYosAc1YeAPNKd+F0JIELmxQavxHiBvwlH1USlL6c8XfFXYFkFIud8OHr+DyswYd
	dPVYh1U0qeE6tFGZ7kYTuGifiPS99/Z05fE3k+aNQiCNiYTvsW2+IUZHFHM3U1IgOoCo6j4ec6asQ
	9HlCJLWQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59528)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1vOOyW-000000004bn-3yEF;
	Wed, 26 Nov 2025 23:31:05 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.98.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1vOOyS-00000000274-2rWk;
	Wed, 26 Nov 2025 23:31:00 +0000
Date: Wed, 26 Nov 2025 23:31:00 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Xie Yuanbin <xieyuanbin1@huawei.com>, brauner@kernel.org, jack@suse.cz,
	will@kernel.org, nico@fluxnic.net, akpm@linux-foundation.org,
	hch@lst.de, jack@suse.com, wozizhi@huaweicloud.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	lilinjie8@huawei.com, liaohua4@huawei.com,
	wangkefeng.wang@huawei.com, pangliyuan1@huawei.com
Subject: Re: [RFC PATCH] vfs: Fix might sleep in load_unaligned_zeropad()
 with rcu read lock held
Message-ID: <aSeNtFxD1WRjFaiR@shell.armlinux.org.uk>
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <20251126101952.174467-1-xieyuanbin1@huawei.com>
 <20251126181031.GA3538@ZenIV>
 <20251126184820.GB3538@ZenIV>
 <aSdPYYqPD5V7Yeh6@shell.armlinux.org.uk>
 <20251126192640.GD3538@ZenIV>
 <aSdaWjgqP4IVivlN@shell.armlinux.org.uk>
 <20251126200221.GE3538@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126200221.GE3538@ZenIV>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C2B4D40006
X-Stat-Signature: 5ctufk9xb9xhd1bqmn1ienx7ksjtmnw8
X-Rspam-User: 
X-HE-Tag: 1764199882-749366
X-HE-Meta: U2FsdGVkX1+a97hb5UcarfM88mhlceE3YCJsKzZAlzjC00qPnyOK7ieYKTNl6mM882p2PY8LlZc9hk2uefDPW/hoIbyjLaClcv8am0Sr1EAUs2Oi885UMuKTMzf+Fhu018zIoxpEvxntCitiEg/0QbCC56v0ijKDou08RoiWA7VZSH4DvUsF8uF7fa9PnvEvkN70r80aIiIM90K9BySgkSgMF08ro/mPLBWBvB4eHkmcMOzH1z6evJN0x3H0O6+1pStM04d9UnIHH4jH8KLOoayb7X9vFB7p6jZT2aIfdSMtm7Y/8vxJtzqrrr+StmzTsizxF00/GjgQKFZ/luINGAW13hzHj5bkP6xDEp0+c9nlLrGTOch1o3OAO/dmXXt0j6Jl3YzN/h6jtSVLmPnTfZzIxTrShXMV/Dsd9nLz1Z5PAITRYibZFSYfnB4UVhEcvsSm59+cH6JTOwSLo64ZgamZJaJNa66zutI0s9zVJYinMk383cW00Q5TfmbiXzVUKCPfZYU6TbNrIRALR2NLoQlxO/2W3ee3v1jBvMWHiFM2fv7KdcV2m4264V/cGc/hH8dlHVV79vsbvbMXZQiZkHa6cOcarU+lM7KskZZeqqKT0SZLGFTBW0YCd/985YMG0qvcOCQJkfKsRwNAn5/SI18HAaiAPRhY+bUsdXJCcnUFU/OgfKYSRhk/aFEjLMPNGRn+qsgPgO3hd0dXeozHWw81Z3SDTU9TqWpU1iyFfGGQIA1Kc+XElNIv5CtXJ23pWgiOheJoYJ42u3B8myRkN7liLkZD0QEftkcjir5DjwkW9QjuOF0tTL/dufR+LKZFLUIIp42U1DFmJVjuoriYHkp83lsLrNzi2rKw7MEXet6tgJaQTsAM+22O5aOvz+dW/xH+NzpA9METWjxe8pYqyUsKra23C+1ifMdy5dCn8/GjApZOJMaKrxhdzL+6qeRwWs/BkxEPLJC/3LLnfhD
 +wFslYdv
 F5/xOsI25iN304xHThQqJlOacImsaSaLtpo+BS0H59S452Y3fAuCKGEHpBVVhJd0lGeKRYe7se2RNQwtP5t7sH2oAOdCZQgvNWLCtcq56+pK4zN1XmxtRzWAFF4l7bxzDE4CwmH403ngH29+SjmNzPJEkcxqBtoGXZ0J5W1mS1PNozMIYEG6HwqahnmFhYgUrhws1SPYphO2W/v/oaT+uZBLiSg+lVx2oAUiNFUVRgtsSr6+aVpztiX0wUz0lKzlx4yv/9t/m75d82e+hY+O6eussSrJiLLIxVyvJjapKYQs35BOHk8oJQWXq8O4iBFV2MSu7E8o0hAILst94Yt0IeZ8RIh8+4vEbhMbL4+IGBRBRM9eM9dNUe8Tv8Ss+DHst7YDbX+wzrz5fChl1eNmrfcwhRClmfb+6DHkNvgBTItNIcphlGCcHr4gyB1RQxR6jVUBzMyqzOvCs6JDiMeAGNkKlqRX2statwwH9+AVp3a98ZEELRChpdMNpQ23ZHzymGZSvGeRxnxtsdckcvtcwlPjQYQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 08:02:21PM +0000, Al Viro wrote:
> On Wed, Nov 26, 2025 at 07:51:54PM +0000, Russell King (Oracle) wrote:
> 
> > I don't understand how that helps. Wasn't the report that the filename
> > crosses a page boundary in userspace, but the following page is
> > inaccessible which causes a fault to be taken (as it always would do).
> > Thus, wouldn't "addr" be a userspace address (that the kernel is
> > accessing) and thus be below TASK_SIZE ?
> > 
> > I'm also confused - if we can't take a fault and handle it while
> > reading the filename from userspace, how are pages that have been
> > swapped out or evicted from the page cache read back in from storage
> > which invariably results in sleeping - which we can't do here because
> > of the RCU context (not that I've ever understood RCU, which is why
> > I've always referred those bugs to Paul.)
> 
> No, the filename is already copied in kernel space *and* it's long enough
> to end right next to the end of page.  There's NUL before the end of page,
> at that, with '/' a couple of bytes prior.  We attempt to save on memory
> accesses, doing word-by-word fetches, starting from the beginning of
> component.  We *will* detect NUL and ignore all subsequent bytes; the
> problem is that the last 3 bytes of page might be '/', 'x' and '\0'.
> We call load_unaligned_zeropad() on page + PAGE_SIZE - 2.  And get
> a fetch that spans the end of page.
> 
> We don't care what's in the next page, if there is one mapped there
> to start with.  If there's nothing mapped, we want zeroes read from
> it, but all we really care about is having the bytes within *our*
> page read correctly - and no oops happening, obviously.
> 
> That fault is an extremely cold case on a fairly hot path.  We don't
> want to mess with disabling pagefaults, etc. - not for the sake
> of that.

I think, looking at the x86 handling, 32-bit ARM has missed a heck of
a lot of changes to the fault handling code, going all the way back to
pre-git history.

I seem to remember that I had updated it to match i386's implementation
at one point in the distant past, which is essentially what we have
today with a few tweaks. As code ages, it gets more difficult to
justify wholesale rewrites to bring it back up.

Relevant to this, looking at i386, that at some point added:

+       /*
+        * We fault-in kernel-space virtual memory on-demand. The
+        * 'reference' page table is init_mm.pgd.
+        *
+        * NOTE! We MUST NOT take any locks for this case. We may
+        * be in an interrupt or a critical region, and should
+        * only copy the information from the master page table,
+        * nothing more.
+        *
+        * This verifies that the fault happens in kernel space
+        * (error_code & 4) == 0, and that the fault was not a
+        * protection error (error_code & 1) == 0.
+        */
+       if (unlikely(address >= TASK_SIZE)) {
+               if (!(error_code & 5))
+                       goto vmalloc_fault;
+               /*
+                * Don't take the mm semaphore here. If we fixup a prefetch
+                * fault we could otherwise deadlock.
+                */
+               goto bad_area_nosemaphore;
+       }

which is after notify_die() and the test to see whether we need a
local_irq_enable(). This means we go straight to the fixing up etc
for these addresses.

In today's kernel, this has morphed into:

        /* Was the fault on kernel-controlled part of the address space? */
        if (unlikely(fault_in_kernel_space(address))) {
                do_kern_addr_fault(regs, error_code, address);
        } else {
                do_user_addr_fault(regs, error_code, address);

meaning any page fault for a kernel space address is handled entirely
separately from the normal page fault handling, and it looks like
this is entirely sensible.

Interestingly, however, I notice that x86 appears to no longer call
notify_die(DIE_PAGE_FAULT) in its page fault handling path, and I
wonder whether that's a regression on x86.

Now, for 32-bit ARM, I think I am coming to the conclusion that Al's
suggestion is probably the easiest solution. However, whether it has
side effects, I couldn't say - the 32-bit ARM fault code has been
modified by quite a few people in ways I don't yet understand, so I
can't be certain at the moment whether it would cause problems.

I think the only thing to do is to try the solution and see what
breaks. I'm not in a position to be able to do that as, having not
had reason to touch 32-bit ARM for years, I don't have a hackable
platform nearby. Maybe Xie Yuanbin can test it?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

