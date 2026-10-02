Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68012CA5FE6
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 19:30:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A52F6B0095; Fri,  2 Oct 2026 15:30:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67BD96B0096; Fri,  2 Oct 2026 15:30:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 569BE6B0098; Fri,  2 Oct 2026 15:30:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 22B366B0095
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 15:30:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ADB0DA0822
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:30:48 +0000 (UTC)
X-FDA: 85278678576.09.0856567
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id F3F671C0010
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:30:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d2r2hK5k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790969447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ekKUYOby3c2j+NEGwfq/n/16hDsQN2mSgzvQPgHiWWI=;
	b=VQ/MPajuL5DQp6kFIvwQfrLVY+lbD2lSHW21YH5NAZCSlyfzdCkGsA6mThSY6wBU5ts2+j
	4rIRygyBQqeEnHacdu5o7TvoQhrOA5zSLxuqbreBdCVCub9k0pG1E12hvqBfoVvJvIZLzj
	ckS5KKCNwZUb1hWZjn8RBcNaZbfrKEI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d2r2hK5k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790969447;
	b=VMHLZbfeG/5nJzQOKNuOAExVzhVuj+mYnlodzLQzxTR2i4gSVt/xaAfUb19WZWprwxpf7V
	b2Tk9274rBQUv2eafNuRtIPaU9/pQvuhIp3I/Azy2+ql/iTiK8LWpVePoto4gzy7b2y9/S
	4c5I6wje9t4QdkQpvC2NluDhDkABJNk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8CF3360D77;
	Fri,  2 Oct 2026 19:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748A01F000FF;
	Fri,  2 Oct 2026 19:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790969446;
	bh=ekKUYOby3c2j+NEGwfq/n/16hDsQN2mSgzvQPgHiWWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d2r2hK5kCljTlCYwbBufk/wivX4jkvPY5GtMgJLcUIUGT4ktspgfRBivcG57guSh0
	 hmkWr9NCuIzN8DuY1j8dpdZ4MIgpfoMkhqfwhFne9TUTm7tvkDIkyqcyp6gifsaedU
	 mNrCV965QKAOpjo5mT0u9456Q2feFcLsrcpn4yK2t79qy6ksjZH9IjiJABakb9YbL5
	 heJGGdWiGwwTNHAPJgbj/idVxDZSAeMzL3J8SODqqJovLo/2+7RpFWIqHOSOxNi79y
	 Uw9DHbuSk9BoX3hzMhPL2bfOom2XjyLWZ7KwO9IQVaU87sthIFLqZfHTTSxGRCaWc8
	 PWPWsigErZcDg==
From: Barry Song <baohua@kernel.org>
To: willy@infradead.org
Cc: agordeev@linux.ibm.com,
	akpm@linux-foundation.org,
	alex@ghiti.fr,
	aou@eecs.berkeley.edu,
	baohua@kernel.org,
	borntraeger@linux.ibm.com,
	bp@alien8.de,
	catalin.marinas@arm.com,
	chenhuacai@kernel.org,
	chleroy@kernel.org,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	gerald.schaefer@linux.ibm.com,
	gor@linux.ibm.com,
	hca@linux.ibm.com,
	hpa@zytor.com,
	kernel@xen0n.name,
	liam@infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux@armlinux.org.uk,
	linuxppc-dev@lists.ozlabs.org,
	ljs@kernel.org,
	loongarch@lists.linux.dev,
	luto@kernel.org,
	maddy@linux.ibm.com,
	mark.rutland@arm.com,
	mhocko@suse.com,
	mingo@redhat.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	palmer@dabbelt.com,
	peterz@infradead.org,
	pjw@kernel.org,
	rppt@kernel.org,
	shakeel.butt@linux.dev,
	surenb@google.com,
	svens@linux.ibm.com,
	tglx@kernel.org,
	vbabka@kernel.org,
	will@kernel.org,
	x86@kernel.org,
	zhanghongru06@gmail.com,
	zhanghongru@xiaomi.com,
	zhaonanzhe@xiaomi.com
Subject: Re: [PATCH v6] mm: retry page faults once under the per-VMA lock
Date: Sat,  3 Oct 2026 03:30:34 +0800
Message-Id: <20261002193034.86218-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <ar7MsOb6IJLt4eLo@casper.infradead.org>
References: <ar7MsOb6IJLt4eLo@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 3dehgcho47qauigqcobbra85mjfeepue
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F3F671C0010
X-HE-Tag: 1790969446-61307
X-HE-Meta: U2FsdGVkX1/trGbd5pFs0ilppx1pho9qA2sJTE1DLMDHO9oAom7APzW57aWjgbNNL9uPBa2S6huvbazzckgZc6C0zEdM9yI7xvD/6e8foTqStb1L6n9popriffUYPqIw7lUrViLiBumi9IqVl3KAvfzgmp8phAus0PMD6XLW1f1tGRyL64Jkq62aofQn8u/Xbb8xrfvn5RXG59azdpKqW83lQFc0BJqjP6UuwpCaXAvGUCAI24JrCQ2ToyShKxp/d68sELq+E7IITIxb4kapfaPqNygl61fTx5JkOg3pJlG49MoDTcrD+onRWSsx9xsw4clpq28DW8/4PR5hfT2/4S/m/ORC2fMNbCybPA2TJjgMakE0RhGaIpcktifBJszI3j/NK+nGtLJbyUVtRrEGEGPv8aa8MY88MoOA4Q6tHTLr5KMVqN9IQS35+iiQ7jnfuxCD9QBCC3/0H/nAZza8EcU6S5BhCAt/iirf4G5u9INOAhUblhQHLK8VqEctFloxMxzWYLgLF3wCVef2xIlv+aHhNjRl3GLLZndulfLjkwnsYWlHgJGgrQC/WQNcBH170AoxY5V3kSybcaJk4qPpbsjfIfS4Ac3l3GM1C2UvOyTZd4hRRbQNQGdCezbAHABQODk/nEjY7dqvQcT1JioF2It366EHkxUSh1DWvqMuaGMWfr/T+yszVVegzbRPjY7HDUxxw1SqIEtMLiNB+1L6wZ8Wf8at1sPWIqnDXO48X/X9rCMI2uIj/L30lms/pcQKbwQ9BpGIrcbP31N4p6mWS5Wy70iL6BCCA1tS0gyk5z5VIrHiAbiSdSOUX1msJpFrQcOglP/Zn7KucRPD5a/PJ9NfR6Qt4ZLguwTC0R9PRwwP8Jh2jqQpV97PZiV6jSx3KTU1qcJpaEYcfdUlu+QsNiaWuULOrbBeSTE07SYALpmvlFdHdhFbvaFf2Xo3lhkOVjk55LWrr2KvPWXa5dm
 fBoJ0U2u
 HJom/e6sfCET0XjEIZIMLt1xCewhwq7nWIoOazfWcm0Lm6WJw/NQGeaQSyJ2LjNglyckUlotn7wx0BR1/HISfgHehK7Qeatl/GYFeEb82D5dX88BA7D4PvmlgYNKe7NS1wI2MIppAaYQGN1wYJhBShAjpYl70Ab6depmkf1mbMUrFW5JF774yWJFtGpdCeBOKGvgBONSwRXAbDhgBaZwZIgF01WlBlr45doFmVN6oRiKuoVNwx55X1cMPhEj9EobgCQjnwHEs84/NGE+r5BzcBUaFKYA4Ohm3/4Ly+j7UJEesx/JPhYu3qES3NlO38FaznhcGzdofpeZQ32YsaXnbEWdVinew/tPH6QdhiOw/grQRHZc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 2, 2026 at 5:12 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Mon, Sep 28, 2026 at 10:48:41AM +0800, Barry Song wrote:
> > On Mon, Sep 28, 2026 at 6:55 AM Matthew Wilcox <willy@infradead.org> wrote:
> > > So while doing my slides, I realised that what we need to avoid doing
> > > is (a) sleeping while holding the mmap_lock (b) returning RETRY while
> > > holding the VMA lock
> > >
> > > And that turns out to be as simple as this patch:
> > >
> > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > index dd09c438fa23..94ed2333f8d8 100644
> > > --- a/include/linux/mm.h
> > > +++ b/include/linux/mm.h
> > > @@ -723,6 +723,8 @@ enum {
> > >   */
> > >  static inline bool fault_flag_allow_retry_first(enum fault_flag flags)
> > >  {
> > > +       if (flags & FAULT_FLAG_VMA_LOCK)
> > > +               return false;
> > >         return (flags & FAULT_FLAG_ALLOW_RETRY) &&
> > >             (!(flags & FAULT_FLAG_TRIED));
> > >  }
> > >
> > > OK, this is a hack.  The function is spectacularly badly named, and
> > > needs to be renamed before a patch can go upstream.  But this should
> > > fix the contention on mmap_lock.
> >
> > Thanks for your suggestion.
> > This is exactly what we did in Android Common Kernel before we had
> > Lorenzo's proposal (bypassing `fault_flag_allow_retry_first()`):
> >
> > https://android.googlesource.com/kernel/common/+/1b9b045a586245cc1c29b2747c6586234c7f5bad%5E%21/#F2
>
> Looks like that one didn't cover __folio_lock_or_retry(), but that
> doesn't invalidate your point.
Yep. `__folio_lock_or_retry()` will make the same thing true for anon
VMAs, so we intentionally made the hook valid only for file VMAs.Only touching the file retry path seems to involve less VMA
contention.

>
> > Note that Lorenzo's proposal avoids mmap_lock contention without
> > introducing any new VMA lock contention. It also doesn't require a new
> > flag that would break KMI. So this is clearly the preferred approach.
>
> But it does retry multiple times in cases where we know the fault
> will always fail (eg the fault is on a device-private VMA)
>
Right now, these might require a single extra retry for device-private
and `__vmf_anon_prepare()` cases. The commit log also mentions this.

"Some faults may
retry unnecessarily, for example, those in __vmf_anon_prepare() or
device-private fault handling, which require the mmap_lock. However,
these cases are expected to be infrequent and only add one cheap
per-VMA lock attempt."

If we do want to remove the extra VMA lock attempt, we might still
need an additional flag such as VM_FAULT_NEED_MMAP_LOCK:

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 2cecf6ba6df7..2821e3bd7462 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -620,6 +620,7 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
 	struct vm_area_struct *vma;
 	int si_code;
 	int pkey = -1;
+	bool vma_lock_retried = false;
 
 	if (kprobe_page_fault(regs, esr))
 		return 0;
@@ -688,6 +689,7 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
 	if (!(mm_flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+lock_vma:
 	vma = lock_vma_under_rcu(mm, addr);
 	if (!vma)
 		goto lock_mmap;
@@ -734,6 +736,12 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
 			goto no_context;
 		return 0;
 	}
+
+	if (!vma_lock_retried && !(fault & VM_FAULT_NEED_MMAP_LOCK)) {
+		vma_lock_retried = true;
+		goto lock_vma;
+	}
+
 lock_mmap:
 
 retry:
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 6141160ec652..baadab598d98 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1734,10 +1734,11 @@ enum vm_fault_reason {
 	VM_FAULT_NOPAGE         = (__force vm_fault_t)0x000100,
 	VM_FAULT_LOCKED         = (__force vm_fault_t)0x000200,
 	VM_FAULT_RETRY          = (__force vm_fault_t)0x000400,
-	VM_FAULT_FALLBACK       = (__force vm_fault_t)0x000800,
-	VM_FAULT_DONE_COW       = (__force vm_fault_t)0x001000,
-	VM_FAULT_NEEDDSYNC      = (__force vm_fault_t)0x002000,
-	VM_FAULT_COMPLETED      = (__force vm_fault_t)0x004000,
+	VM_FAULT_NEED_MMAP_LOCK     = (__force vm_fault_t)0x000800,
+	VM_FAULT_FALLBACK       = (__force vm_fault_t)0x001000,
+	VM_FAULT_DONE_COW       = (__force vm_fault_t)0x002000,
+	VM_FAULT_NEEDDSYNC      = (__force vm_fault_t)0x004000,
+	VM_FAULT_COMPLETED      = (__force vm_fault_t)0x008000,
 	VM_FAULT_HINDEX_MASK    = (__force vm_fault_t)0x0f0000,
 };
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ddc631a388b9..64e08c6153cf 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1480,7 +1480,7 @@ vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf)
 
 	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
 		vma_end_read(vma);
-		return VM_FAULT_RETRY;
+		return VM_FAULT_RETRY | VM_FAULT_NEED_MMAP_LOCK;
 	}
 
 	ptl = pmd_lock(vma->vm_mm, vmf->pmd);
diff --git a/mm/memory.c b/mm/memory.c
index 1f83a26f8733..89c8c8a52c16 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3980,7 +3980,7 @@ vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf)
 		return 0;
 	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
 		if (!mmap_read_trylock(vma->vm_mm))
-			return VM_FAULT_RETRY;
+			return VM_FAULT_RETRY | VM_FAULT_NEED_MMAP_LOCK;
 	}
 	if (__anon_vma_prepare(vma))
 		ret = VM_FAULT_OOM;
@@ -4937,7 +4937,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 				 * under VMA lock.
 				 */
 				vma_end_read(vma);
-				ret = VM_FAULT_RETRY;
+				ret = VM_FAULT_RETRY | VM_FAULT_NEED_MMAP_LOCK;
 				goto out;
 			}
 
-- 
2.39.3 (Apple Git-146)


