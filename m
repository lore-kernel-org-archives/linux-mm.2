Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8441C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 11:58:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA9486B009F; Tue,  7 Jul 2026 07:58:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A804C6B00A3; Tue,  7 Jul 2026 07:58:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 996D46B00A4; Tue,  7 Jul 2026 07:58:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F1C86B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:58:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 002941A041D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:58:43 +0000 (UTC)
X-FDA: 84961833726.06.8BAE121
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	by imf22.hostedemail.com (Postfix) with ESMTP id 07592C000A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:58:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=CQap+tka;
	spf=none (imf22.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783425522;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=stkx+vjsKdhX968mmJiOePHn7dujN6VJDWqehc4K6N4=;
	b=1dJ3ONyrC36l4VBIELfkzEyBMpLwOQN+SwZBKUbv/zNMc1d8M3viEAIRWPpxytro+8pgoT
	DsGqXbJnEWpmegsD78giRhTe8nzG3dzQ7HLK8a3j6M3B+ALanfnsaYyO0FB/GTQsRE56c8
	KlmPPnvXKyGJ0kSU8UDFWOhmE6NhQIc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783425522;
	b=j1oBxj7zFRraSF2ayc9Lc7pVFuYrIOOPoDY8IS8jnW91cd35Xvu3G6h5UcErAgjiv1f+E8
	Q9M04KOG7aRQidHouiR2SPS9wXTeZSrKP3IOq3LjFEPeDLFgsKti5wVH2JSRNhsGe638ff
	8f6pZIxeKibi5fnXadOISqhbNFFO/Cs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=CQap+tka;
	spf=none (imf22.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=stkx+vjsKdhX968mmJiOePHn7dujN6VJDWqehc4K6N4=; b=CQap+tkaox9/fVICER9FoFNvDu
	e//Xtvd6Qs1gsrYGHA+TRKpq5dBGjLojzL9FfGAqF+24spZ1aqVFVlU0uyeRXvH8QEY9XSUM1GI4+
	sApiwFB89AG0Yy64xD4vHmmZimtSrgLMrpXzjSDE7Z4vyLLGQelEV1efYgpyRyGPfCGsaxfj08E9a
	nmWAe1pnoyFsQHl+gzgze0DQfQSp7FyDtz4+SLME7De/bvDvuu8whgrA8YE0p26g/XsMbHfVT6ne0
	6Qs2eCUnsoJBmNA8dmndgy5vIf4dszJr+Wfw15tEDQSWyGoFlB0pm44BxnHSIeF7tENXo66tVldoG
	I323MjOQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45516)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1wh4Qu-000000000mm-2UGt;
	Tue, 07 Jul 2026 12:57:48 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.98.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1wh4Qr-000000006gy-3vIs;
	Tue, 07 Jul 2026 12:57:45 +0100
Date: Tue, 7 Jul 2026 12:57:45 +0100
From: Russell King <linux@armlinux.org.uk>
To: Qi Xi <xiqi2@huawei.com>
Cc: Xie Yuanbin <xieyuanbin1@huawei.com>, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, linusw@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	sunnanyong@huawei.com, linux-mm@kvack.org, lilinjie8@huawei.com,
	liaohua4@huawei.com
Subject: Re: [PATCH v3 1/2] ARM: mm: fix use-after-free in __do_user_fault()
 under CONFIG_DEBUG_USER
Message-ID: <akzpuerKqOY7qfFi@shell.armlinux.org.uk>
References: <20260626073048.3595106-2-xiqi2@huawei.com>
 <20260706133247.145485-1-xieyuanbin1@huawei.com>
 <c11452a3-b918-4d4c-afd7-a835a1d0a3bc@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c11452a3-b918-4d4c-afd7-a835a1d0a3bc@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 07592C000A
X-Stat-Signature: ghwow6ijr5edykffwzfpswynis7z1m1s
X-HE-Tag: 1783425521-559651
X-HE-Meta: U2FsdGVkX1+qXinb4WsliJBJkjmha2NncxnvoJOMHIzhfGes10kZj9qzyFN9Fs5sHZJH61fwF65H8Ter1CrOr44sYGBgeXL9Epp9QQohxTxstqUgb6gZTHp++uJYfnETl8oNVqPkMqTpsctDb07Q2+nITtRd/FjF+mHh51O/87JNZuMi06Ca/3ATPkmZvFW4yrySjpZoRZCnDLvY7CKJK/vdxRFNhuaVgrPJ7wWhrF+heY105k+hFx/NbEbQTXIHhGnsBuDSHZaR1nxuTYlgdZPHrfJ9hsUR2RSl07zQ4CqgVy/XiN7kYfU93RSti9AGZJlogrtHMdfeWClRpQF6djHqXQA8ipkIB6T2kSbaj0B4TnlSslHpwK2TQWYuhqU5cUzd0V+ij0a1a3DVzeMa7rEAzlt1tA9YMX3Xt7hm7HdjpdmfIjDxP2fxwvjcRZBVfysH7Ip0RPXN3nEi4BtQs7k+f4dV2WT1lu2OtFou1NLPYGFd2QFdGZo8EdMIuOGbYwbbAB3R/+mEUushJzZYe+VBvnnpWK2FFDaOlGWw4EL4K6zurNUidHoxMwj02mXVoEmjWOkbwC+w53WU8a2qdU2oSjx5pofN5yJFWD88og7to4SCep4j4M67ohKHNy6mtdLvQ1pcqIfyZ4M92pNfmZTsrF1MUMmLGUb0Y9dYgAFseiP8T+JRepSTT5yFwSi7PZUT4DZc6D+yib5ahZwhMS682Q5Y8gG6AIseOFqZanuAuQuVCF1i8wO2ebJYGE5Au/v7nQgD4/RIxLmKLjpoJWqdK0Lff13iQv3yzlL2fHS6z0G5uHRw+N4X3wp0ww8SPTjPwswC/E++97FSKKEAp+XvLTGylLDaSQ4B5ccwdRj+AmdLS3Yr7H7BGCqsLJ3nPknxoZ7wUjWBwpFSyqLJBJgeJI1zmwpo2JtOwxJm5cKjoXugND7KlGE7WryWtLhN6BqSR6zm/KGK6KHb77m
 QAnsr6hW
 BKAPxHutidUON2z7iqClAFjkzZQe0NTncl42DnsLQgRoZtjemeu2n8Inapvha6r40447e3a1k1NU4kjMUroZAO6HkEAgPWVkRvwXroson8lESvPOXEPEsJTyDfzHx1R3FwG5XG+cMtTK/N09M7vlbh1Qx5ZEy/yq3lZRz4nyQt85c95rGOz0mV/+WuSaXtpfxyCdeUgF8d0MMkrNKbg5AG5M6oPIYNWVuj59gurjIcDAWjJFdghWsGoLWeWbtZDd7E5Tnc0T3FmO0HQKh5E/ar6MSo5pe9xNo3c+SvoPtcy/xrnV1PBpIHin4d4ifWRRUyPmGIVwL0pwQdi3dzgP8dnVrlFUOUvg60B1sp9m7Vk2AqMFx+o2+HrSoYMoFwoBkIunP30Paf5557iAyU4Iz64yVSU8r7x7pXOuVo3GXgNNee+WP2hP2hQu0SqeGlKYSpUj21ieQ7XnzaDObzUOVbpZ/DroaBXIKJkF9huHKNYqy32H0AOgo7MbZ1G4gt24uonughESrn7m1NcmbKL8McpC/X3eTorJd3xlUn/Cldt+ee8txUhAsj5Mq9fBg2c2SovwIoX6Nj+xEstviUSxrO9V88lPRQT4Fx7gzBIo5HRTz3MA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 07:48:12PM +0800, Qi Xi wrote:
> 
> 
> On 06/07/2026 21:32, Xie Yuanbin wrote:
> > On Fri, 26 Jun 2026 15:30:47 +0800, Qi Xi wrote:
> > > @@ -181,7 +181,9 @@ __do_user_fault(unsigned long addr, unsigned int fsr, unsigned int sig,
> > >   		pr_err("8<--- cut here ---\n");
> > >   		pr_err("%s: unhandled page fault (%d) at 0x%08lx, code 0x%03x\n",
> > >   		       tsk->comm, sig, addr, fsr);
> > > +		mmap_read_lock(tsk->mm);
> > >   		show_pte(KERN_ERR, tsk->mm, addr);
> > > +		mmap_read_unlock(tsk->mm);
> > >   		show_regs(regs);
> > >   	}
> > >   #endif
> > I found that this fix does not completely solve the problem. For a user
> > fault, the addr could also be a kernel address. For arm32/x86, the kernel
> > address space and user address space share the same pgd page table,
> > but the kernel address space's page table is not protected by
> > current->mm->mmap_lock.
> > 
> > I have written a use case to construct and verify this point. When A user
> > program accesses a kernel address and triggers __do_user_fault(),
> > show_pte() will directly print the kernel page table.
> > 
> > So, I suggest that:
> > ```c
> > 	if (user_mode(regs)) {
> > 		struct mm_struct *const pt_mm = addr >= TASK_SIZE ?
> > 			&init_mm : current->mm;
> > 
> > 		mmap_read_lock(pt_mm);
> > 		show_pte(KERN_ALERT, pt_mm, addr);
> > 		mmap_read_unlock(pt_mm);
> > 	} else {
> > 		// .. keep nothing change
> > 		show_pte(KERN_ALERT, current->mm, addr);
> > 	}
> > ```
> > 
> > I have read this article:
> > Link: https://docs.kernel.org/mm/process_addrs.html
> > `mmap_read_lock(&init_mm)` should be able to ensure that the kernel
> > address's page tables can be traversed. But I'm not quite sure if
> > `mmap_read_lock(&current->mm)` provides protection for user-space non-VMA
> > addresses?
> You're right. And I think the fix is to simply skip show_pte() for kernel
> addresses.

No. This information is useful debug for kernel oops.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

