Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20D0FC9831E
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 05:58:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5E8B6B0096; Sat, 26 Sep 2026 01:58:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0FD16B0098; Sat, 26 Sep 2026 01:58:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FE256B0099; Sat, 26 Sep 2026 01:58:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 674046B0096
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 01:58:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 71667A6EFE
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:58:38 +0000 (UTC)
X-FDA: 85254859116.13.D0DBD00
Received: from gwu.lbox.cz (gwu.lbox.cz [62.245.111.132])
	by imf31.hostedemail.com (Postfix) with ESMTP id A5CE020003
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:58:35 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b=kNOrwTTO;
	dmarc=pass (policy=none) header.from=linuxbox.cz;
	spf=pass (imf31.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790402316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vFTBSjtFpabMGTry+CN1XGKXyVis+z1W2WXOf4oIR/U=;
	b=tfHIpPK7Su1WB5b1VLQ4szpLNVHZvkhcIEsvODhiq0G9gPpOknKijSGTtO374Ic8YEKw1H
	RkuQ4PKE0NlA3A41qNGuxx9qvINPieotXxhsnlsnUWBK0G9S3xwh6bUJxkRL5JUIixwZqs
	G+qZ/dRxZAzAMSzBjSeoROWfW+Yt1FU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b=kNOrwTTO;
	dmarc=pass (policy=none) header.from=linuxbox.cz;
	spf=pass (imf31.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790402316;
	b=VE1VR2pYnzPHKAQZ/CuObnQkMxXjmH8NMuKgXJimlKFGU73gRegl9szXFZoztf++BsUjbg
	U7Tu1+BdzYM1KsDCBiSJuctW0t8dacNAy5Aiy5vLqwyY1T3dAEpNFRm+IX+ZCwq4N16QQI
	CF0wpi0PZYf8gEUEyBo2B2Uk96RmTCU=
Received: from linuxbox.linuxbox.cz (linuxbox.linuxbox.cz [10.76.66.10])
	by gwu.lbox.cz (Sendmail) with ESMTPS id 68Q5wQ2t3048350
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Sat, 26 Sep 2026 07:58:27 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 gwu.lbox.cz 68Q5wQ2t3048350
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxbox.cz;
	s=default; t=1790402307;
	bh=vFTBSjtFpabMGTry+CN1XGKXyVis+z1W2WXOf4oIR/U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kNOrwTTOQsj2c/9Onuuv1QoJhX6And6UVqzdqhNtBz7r1uADuV4ONdew0BqJqQ2J6
	 FgfTOJ8VTuH2p3sjr2x3pcjYzv+CsNUk2MRwEtCCjbkfgbgwvFk3o+Z14wzEosBgcH
	 FaqI5F7MCG+MTK+RLbPiMe35U5K9N/lTFU+D0ipc=
Received: from pcnci.linuxbox.cz (pcnci.linuxbox.cz [10.76.3.14])
	by linuxbox.linuxbox.cz (Sendmail) with ESMTPS id 68Q5wPV9046372
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Sat, 26 Sep 2026 07:58:25 +0200
Received: from pcnci.linuxbox.cz (localhost [127.0.0.1])
	by pcnci.linuxbox.cz (8.18.1/8.15.2) with ESMTPS id 68Q5wMoZ1898559
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 26 Sep 2026 07:58:24 +0200
Date: Sat, 26 Sep 2026 07:58:22 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, david@kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <arde/t0zQNEkWqi5@pcnci.linuxbox.cz>
References: <arY1Wq6R9OY20ans@pcnci.linuxbox.cz>
 <arZHp8hjYFXE8Rkt@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <arZHp8hjYFXE8Rkt@gremlin>
X-Scanned-By: MIMEDefang 3.7.1 on 10.76.66.3
X-Scanned-By: MIMEDefang v3.7.1/SpamAssassin v4.000002 on lbxovapx9 (nik)
X-Scanned-By: MIMEDefang 2.86 on 10.76.66.10
X-Antivirus: on lbxovapx9 by Antivirus 
X-Milter-Copy-Status: O
X-Rspamd-Queue-Id: A5CE020003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: xy913845iec87bux3kc6syfc18q5wtrs
X-HE-Tag: 1790402315-53548
X-HE-Meta: U2FsdGVkX1/ydUcmRi4a9GJKUg8lo/MYBTkWpf22PGCbQUthJWDwUT5SYfKE6qvN5kBn1I3cbllZ3D2VhK3DRuBzVGHNqnrvVnHlHb97ixyoUuBcDko6Dvi/v+19GeCZdqIugGZRfz4Gt3/qJoi6L5BkN4HO9NjA683WJpBprtdqQWsZ9GAOznqaPxaMvYCaLVDrLEHja6102wbkzsE+bYrawW1UwrmsENWKkVEsJeFJOxzkgJWyYzt5FN2dYcu10NH9OlqegMbrNkZUrgLE71U01djMbz54fnaYfvrcn8fIo3iwDjGNoTY86brZ0gpF2SFq/oJm/YW6bCNiNqJkoY0PRAgnCwDQ7IGZrksdw9n54nG2onV6nfZHrMxQgZBZBdyrsUxjjI80FR0+Sd3hbpeqmWqd7QnGcbHe4tHqRG6Kv4+ACHb1HFh1bP9bqoZeG1ewhtD8GY9ufIMdv4u8Eyw0UaDs6awmY9soCHo54z198n7Ok25XNn8DXyrYN2IJq4sh4uKsMc5gqVErj4wpNvmEtPOLpgiKRDk7e8pU2iMv8JzwK94CX/yYz6wiPGvek8dlx3xhI7id7ZT1yQKuV6f7Wf9YbmHLhPsoEcw/oB8zkcT0VdegixS4Zh1ZIlKvvD85ayARMmL8/Qub64zNcRWzLervj1X7lPmLGKCKY3UgOHIQs0Qn6iGQ5qq5wQY5nX2+V5j0ihCc3gy0BVDenIM8oCM3MefL+AKh53m2JxT/iB2tHvQ/30Y0f8XDkIX2THfYbedWF3GzME3MiF1wno0aQ9hb1ZTNpj1FUEe+bGqHEDU44Wt4WUU/ff6sDWCCDLAZTCw2yVrUyHu3oTUHkNke1iN15hepFvQONgVO823foBYHHSQYAPkbAmPHU5rwqbWk62ucGuetPR8cOsmp3k78lyiWcWcDf3s55NnqI/zWXHrAixz9ejX8YzbnuJqWwQZ9pqN2HHqM/LoVOCt
 +LD+YsZ3
 Q13ig9UDhH12socGdGSjssrpUoPR1UCxFwflZ+zB509y2smbzQOygr66oxSgUJQ/zZFV2iGwCG9B+j80YqmXLIk3ZlNorYmqDEU1803jTMaz2dz/7BVVQOXW/mloIdGno91zkAcIbBLE4cVRWVzdXtok4D8NrV19tR2sxLed6W/Xm84rQzgW34WAk5sYERlIphy43BtzbpeFCPWkD+b6nSZTuV6U6U5LxtkuZZSv4Q9TNKeGeftgZ7cNnr+Kb0XJDuj7ha4Vo+DfOB/Az4YerXr7CtNvykb7ChRqFgJMfzPNj2MQOw/+XTBSvwCWYoq7UAsz6XaJU2NVohqLKoP0NDP/FnNe95dPbVCL+daueb+qg2SyyhnQKa9po7yYD2apcnX+E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Lorenzo (and others),

thank you for your time looking into this..

(replies inline)

On Fri, Sep 25, 2026 at 01:13:52PM +0100, Lorenzo Stoakes (ARM) wrote:
> +cc various
> 
> Tl;DR before I dig in, I had an AI dig into the report (as they're
> essentially superhuman at this kind of thing so always worth doing), and it
> seems the recently fixed CPA bugs are likely to be the underlying cause
> here.
> 
> EDIT: OK so I spent 2+ hrs analysing this :>))) but hopefully it's useful,
> I wanted to make sure what the LLM came up with was vaguely sensible.
> 
> It's speculative, but I really think the below is the best explanation for
> what you're observing.
> 
> And TL;DR is that 6.18.53 should fix it.
> 
> On Fri, Sep 25, 2026 at 10:48:26AM +0200, Nikola Ciprich wrote:
.. truncated ..
> >
> > The problems started after we moved from 5.15.x to 6.18.x kernels.
> 
> It seems that commit 41d88484c71c ("x86/mm/pat: restore large ROX pages after
> fragmentation") is the underlying cause (landed in 6.15).
> 
> It impacts CPA or 'Change Page Attributes' which is the means by which direct
> mapping page table entries are updated to reflect underlying attribute changes
> for ranges, often (and the motivation behind this change) read-only executable
> ranges for e.g. JITters etc.
> 
> When it does this it sees if the range being changed can be 'collapsed' into a
> huge page, i.e. mapped at PMD level for instance rather than PTE level to avoid
> fragmentation of the direct map.
> 
> In particular the change introduces cpa_collapse_large_pages(), which frees
> kernel page tables when it does this.
> 
> And this is problematic, because it did that without properly synchronising
> against concurrent readers.
> 
> And I think in particular the issue here is the one fixed by Pedro in commit
> 1587d3394e25 ("x86/alternatives: Exclude text poking against
> change_page_attr()").
> 
> >
> > Since then I've spent a lot of time trying to reproduce it on a lab
> > cluster, and we were able to trigger some corruption after days of
> > migrating VMs back and forth. At first I suspected the Intel ice driver,
> 
> Yeah these race bugs can be VERY painful, sorry about that!
> 
> > for which I found similar reports, but we saw new problems even after
> > backporting fixes (and also with Mellanox cards).
> >
> > So far we've hit three different kinds of problems, which may or may
> > not be related:
> >
> > - .so library corruption right after VM migration
> > - VM crashes (or process crashes inside VMs), possibly related to
> >   migration (those always happened during migration)
> > - host crashes due to kernel structure corruption (these happened
> >   without any VM migration)
> 
> So there are two sides to the race: set_memory_rox() - triggered on module
> load, ftrace trampoline creation and every new BPF 2M program pack.
> 
> The other side is execmem_force_rw() -> set_memory_[nx,rw]() (concurrent
> module load or ftrace trampoline allocation) __text_poke() ->
> vmalloc_to_page() for patching module text, kprobe slots, trampolines or
> BPF.
> 
> Both are happening a lot at KVM host bringup (module autoload, per-VM
> seccomp filters, perf, BPF probes, etc.

one note here, at least last mentioned crash (with 6.18.44) happened with
host running only windows guest, in general we're seeing those problems
mosly with windows VM hosting machines.. so maybe they're triggerng the
problem with some other, but similar mechanism?

> 
> So this aligns with the theory.
> 
> >
> > We first hit these problems with 6.18.31; the last crash I saw was
> > with 6.18.44.
> 
> Yeah, the fact you didn't see an issue with 5.15 matches commit
> 41d88484c71c ("x86/mm/pat: restore large ROX pages after fragmentation")
> being the cause.
> 
> >
> > All affected machines use AMD EPYC CPUs and act as KVM hosts; the OS
> > is AlmaLinux 9.
> >
> > I suspect two subsystems that have seen a lot of changes:
> >
> > - transparent hugepages
> > - NUMA balancing
> >
> > (but those are just my guesses)
> >
> > As a safety measure, we've disabled THP and NUMA balancing on all hosts.
> 
> Actually I think doing this doesn't actually save you at all, since the
> collapse happens even without THP enabled, and NUMA balancing shouldn't
> impact any of this.
> 
> >
> > I'm aware this is still a very vague report with a lot of guessing,
> > but my question is: has anybody hit similar problems with 6.18 or
> > newer kernels?
> 
> Yeah, the description of a fix for this mentions something that seems
> exactly like this bug:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1aac65f3e651334259ecb2a5f5ddb81c01f02599
> 
> Though note that that patch doesn't actually solve the problem, you need
> fixes from 6.18.53 to resolve the bug:
> 
> Commit a1c7570cedd0 ("x86/mm/pat: Acquire init_mm write lock on collapse to avoid UAF")
> Commit d5d8b8662e6e ("x86/mm/pat: Acquire init_mm read lock on attribute changes to avoid UAF")
> 
> These are prerequisites ^^^ for the actual fix for this vvv
> 
> Commit 1587d3394e25 ("x86/alternatives: Exclude text poking against change_page_attr()")
> 
> >
> > I see a lot of patches in every stable release, but simply trying
> > newer kernels doesn't seem efficient here. Deploying them is also
> > risky, since the hosts have to be emptied by migrating VMs off them
> > before reboot, and that migration itself may trigger more crashes.
> > None of the released or queued fixes for 6.18 seem to be directly
> > related.
> >
> > I tried running my migration tests on hosts with KASAN enabled, and
> > also with SLUB debugging, but was never able to reproduce the problem
> > with those enabled (without them, I was able to hit issues within
> > days).
> 
> Ugh, unhelpful, but makes sense as it changes race windows.
> 
> >
> > I'll start another round of migration tests in the lab, now with
> > 6.18.54-rc1, but I still thought it would be good to report this and
> > ask here.
> >
> 
> Ah yeah you're already going to be testing the fixed series then :)
> 
> Obviously if the issue re-triggers there, back to the drawing board. But I
> don't think it will.
> 
> > last but not least, here's kdump from last crash (this was not related
> > to any VM migration, but is very similar to another few crashes
> > we got):
> >
> > [1924553.414736] Oops: general protection fault, probably for non-canonical address 0xfffffff0c930038: 0000 [#1] SMP NOPTI
> > [1924553.434800] CPU: 23 UID: 189 PID: 7538 Comm: pacemaker-contr Kdump: loaded Tainted: G            E       6.18.44lb9.01 #1 PREEMPT(voluntary)
> > [1924553.456934] Tainted: [E]=UNSIGNED_MODULE
> > [1924553.465551] Hardware name: ASUSTeK COMPUTER INC. RS720A-E12-RS12/K14PP-D24 Series, BIOS 2305 11/21/2025
> > [1924553.484152] RIP: 0010:__d_lookup+0x4a/0xc0
> 
> So __d_lookup() is where the invalid address oops happened.
> 
> > [1924553.492878] Code: ff 48 89 c5 c1 e8 07 48 8d 1c c2 e8 60 8f d1 ff 48 8b 03 48 89 c3 48 83 e3 fe 48 83 f8 01 77 0a eb 2f 48 8b 1b 48 85 db 74 27 <39> 6b 18 75 f3 4c 8d 63 78 4c 89 e7 e8
> > d5 e1 7c 00 4c 39 6b 10 74
> > [1924553.525191] RSP: 0018:ff7532a13699fda0 EFLAGS: 00010212
> > [1924553.534986] RAX: 0fffffff0c930020 RBX: 0fffffff0c930020 RCX: 0000000000000000
> > [1924553.546679] RDX: ff2e6dbe0d9b6000 RSI: ff7532a13699fe60 RDI: ff2e6d1e4e630d80
> > [1924553.558367] RBP: 000000000b654440 R08: 0000000000002403 R09: 0000000000000179
> > [1924553.570026] R10: 000000000000000d R11: 0000000000000000 R12: 0000000001876e5c
> > [1924553.581601] R13: ff2e6d1e4e630d80 R14: ff7532a13699fe60 R15: 0000000000000000
> > [1924553.593115] FS:  00007ff8743aaa80(0000) GS:ff2e6e5e94c45000(0000) knlGS:0000000000000000
> > [1924553.605576] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [1924553.615611] CR2: 00007ffcd63a5000 CR3: 00000003ee840001 CR4: 0000000000771ef0
> > [1924553.627022] PKRU: 55555554
> > [1924553.633869] Call Trace:
> > [1924553.640353]  <TASK>
> > [1924553.646369]  d_lookup+0x27/0x50
> > [1924553.653366]  lookup_dcache+0x1f/0x80
> > [1924553.660713]  lookup_one_qstr_excl+0x1e/0xe0
> > [1924553.668589]  ? preempt_schedule_common+0x2c/0x70
> > [1924553.676837]  filename_create+0xc4/0x160
> > [1924553.684209]  do_mkdirat+0x5a/0x190
> > [1924553.691050]  __x64_sys_mkdir+0x42/0x60
> > [1924553.698163]  do_syscall_64+0x64/0xbf0
> > [1924553.705145]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > [1924553.713533] RIP: 0033:0x7ff8754ff08b
> > [1924553.720358] Code: 8b 05 91 bd 0f 00 41 bc ff ff ff ff 64 c7 00 16 00 00 00 e9 4f ff ff ff e8 12 f7 01 00 66 90 f3 0f 1e fa b8 53 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 5d
> > bd 0f 00 f7 d8 64 89 01 48
> > [1924553.748552] RSP: 002b:00007ffc05e5c148 EFLAGS: 00000246 ORIG_RAX: 0000000000000053
> > [1924553.759401] RAX: ffffffffffffffda RBX: 00005623cc0bd513 RCX: 00007ff8754ff08b
> > [1924553.769760] RDX: 000000000fde421b RSI: 00000000000001c0 RDI: 00005623cc0bd4f4
> > [1924553.780083] RBP: f49998db0aa753ff R08: 0000000000000004 R09: 0000000000000001
> > [1924553.790348] R10: 00007ff87587d000 R11: 0000000000000246 R12: 8421084210842109
> > [1924553.800604] R13: 00005623cc0bd513 R14: 00007ff8755bd740 R15: 000000000fde421b
> > [1924553.810819]  </TASK>
> 
> So the LLM went to town on this and it's quite interesting.
> 
> The code (6.18.44) disassembles to:
> 
> struct dentry *__d_lookup(const struct dentry *parent, const struct qstr *name)
> {
> 	...
> 
> 	hlist_bl_for_each_entry_rcu(dentry, node, b, d_hash) {
> 
> Which is:
> 
> #define hlist_bl_for_each_entry_rcu(tpos, pos, head, member)		\
> 	for (pos = hlist_bl_first_rcu(head);				\
> 		pos &&							\
> 		({ tpos = hlist_bl_entry(pos, typeof(*tpos), member); 1; }); \
> 		pos = rcu_dereference_raw(pos->next))
> 
> And:
> 
> static inline struct hlist_bl_node *hlist_bl_first_rcu(struct hlist_bl_head *h)
> {
> 	return (struct hlist_bl_node *)
> 		((unsigned long)rcu_dereference_check(h->first, hlist_bl_is_locked(h)) & ~LIST_BL_LOCKMASK);
> }
> 
> And:
> 
> static inline bool hlist_bl_is_locked(struct hlist_bl_head *b)
> {
> 	return bit_spin_is_locked(0, (unsigned long *)b);
> }
> 
>   mov    (%rbx),%rax          ; rax = h->first = 0x0fffffff0c930020
> 
>   mov    %rax,%rbx
>   and    $-2,%rbx             ; strip hlist_bl lock bit (no-op, bit 0 clear)
>   cmp    $1,%rax              ; hlist_bl_is_locked()
>   ja     body                 ; non-empty, enter loop
>   ...
> 
> 		if (dentry->d_name.hash != hash)
> 			continue;
> body:
>   cmp    %ebp,0x18(%rbx)      ; <-- FAULT: deref of dentry->d_name.hash
> 
> So dentry is corrupted.
> 
> The code and registers are consistent with this being the first iteration
> of the loop, which you'd expect with corrupted dentry.
> 
> Looking further back in the code:
> 
> struct dentry *__d_lookup(const struct dentry *parent, const struct qstr *name)
> {
> 	...
> 	struct hlist_bl_head *b = d_hash(hash);
> 
> And:
> 
> static inline struct hlist_bl_head *d_hash(unsigned long hashlen)
> {
> 	return runtime_const_ptr(dentry_hashtable) +
> 		runtime_const_shift_right_32(hashlen, d_hash_shift);
> }
> 
> Only the trailing ff is in the code output from the splat but the movabs is
> there -> RDX: so:
> 
>   movabs	$0xff2e6dbe0d9b6000,%rdx	; runtime_const_ptr(dentry_hashtable)
>   mov		%rax, %rbp
>   shr		$0x7, %eax			; runtime_const_shift_right_32(hashlen, d_hash_shift);
>   lea		(%rdx, %rax, 8), %rbx		; bucket = &dentry_hashtable[hash >> 7]
> 
> (The 8 is multiplying the size of the 8 byte pointers)
> 
> Note that rbp retains RAX's value = 0xb654440 (not clobbered elsewehre), so
> the hlist_bl_head bucket pointer is
> 
> 	0xff2e6dbe0d9b6000 + (0xb654440 >> 7) * 8
> 
> So:
> 
> b = 0xff2e6dbe0e51b440
> 
> This matters, because in hlist_bl_first_rcu() this pointer is treated as a
> valid struct hlist_bl_head pointer:
> 
> struct hlist_bl_head {
> 	struct hlist_bl_node *first;
> };
> 
> And the data at 0xff2e6dbe0e51b440 contains 0x0fffffff0c930020 (rbx), which
> is assumed to be a valid struct hlist_bl_node * embedded in a dentry.
> 
> IOW, RDX contains the dentry_hashtable pointer:
> 
> static struct hlist_bl_head *dentry_hashtable __ro_after_init __used;
> 
> That is allocated in dcache_init_early() and never freed:
> 
> static void __init dcache_init_early(void)
> {
> 	...
> 	dentry_hashtable =
> 		alloc_large_system_hash("Dentry cache",
> 					sizeof(struct hlist_bl_head),
> 					dhash_entries,
> 					13,
> 					HASH_EARLY | HASH_ZERO,
> 					&d_hash_shift,
> 					NULL,
> 					2,
> 					0);
> 	...
> }
> 
> So that allocate has to be legit, somehow the data there got corrupted.
> 
> This is allocated early by memblock.
> 
> d_hash_shift = 7 = 32 - lg(entries), so entries = 25, and 2^25 entries of 8
> bytes each = a 256 MiB table.
> 
> So it's legit data that got corrupted.
> 
> RDI contains the parent dentry at 0xff2e6d1e4e630d80 (the disassembly at
> __d_lookup() confirms).
> 
> KASLR makes things tricky but this is most definitely a slab allocation in
> the direct map and the stack (VMAP_STACK) is at 0xff7532a13699fda0 (rsp)
> ~70 TiB higher which sits at least 10 TiB padded above the direct map so
> it's safe to say that this is in the direct map.
> 
> And the corrupted value (rbx) 0x0fffffff0c930020 is interesting - it's an
> exactly a x86-64 swap softleaf value:
> 
> __swp_type()   = val >> (64 - SWP_TYPE_BITS=5) = val >> 59 = 1
> __swp_offset() = (~(x).val << SWP_TYPE_BITS >> SWP_OFFSET_SHIFT) = (~val << 6 >> 14)
>                = 0x79b67f
> 
> I.e. it's a swap softleaf entry 0x79b67f 4 KiB pages into the swap = ~30.4 GiB.
> 
> It's also the _second_ swap in the system (Nikola - if you have a 2nd swap
> on the reporting system of >=~30 GiB that kinda confirms it).

I suspect this may be a bit of a red herring...

actually there is NO swap on that machine, also there were no linux guests.. so
that might just be a coincidence? not sure if it changes anything..

> 
> Also, interstingly, bit 5 is set, which is one of the bits allowed to be
> set (possibly by hardware) in the swap entry.
> 
> __swp_entry() clears bits 0-8 and only bits 1-3 are software bits in a
> non-present PTE.
> 
> This is _PAGE_ACCESSED (1 << _PAGE_BIT_ACCESSED = 5) = 0x20. So it makes
> sense that hardware might have set it.
> 
> In effect - every single bit is exactly how it should be for a valid swap
> entry (since commit 00839ee3b299 ("x86/mm: Move swap offset/type up in PTE
> to work around erratum"))..
> 
> It seems more than a coincidence :)
> 
> This speaks to some kind of memory corruption that has resulted in a store
> to an arbitrary physical address that happens to be the dentry.
> 
> Now looking to the proposed CPA cause (ultimately the thing solved by
> 
> 
> So the speculated race here is:
> 
> pfn_exec: pfn of the module text page CPU A is changing attributes on
> pfn_dh:   pfn of the dentry hash table page the swap PTE ends up in
> 
> CPU A: set_memory_nx() (text_poke)     CPU B: set_memory_rox() (module load)
> ------------------------------------   -----------------------------------------
> __change_page_attr()
>   kpte = lookup (lockless)
>   <preempted>
>                                        cpa_collapse_large_pages()
>                                          set_pmd(leaf)
>                                          __free_pages(old PTE table)
> 
>                                        some process: pte_alloc() gets
>                                        that page as a user page table
> 
>   UAF!!! Writing into arbitrary memory
>   set_pte_atomic(kpte,
>       pfn_pte(pfn_exec, prot))         <- lands in that page table:
>                                           entry -> pfn_exec (module text)
> 
>                                        process faults on it, GUP follows
>                                        it, later zap frees the data page at
> 				       pfn_exec while it is still live module
> 				       text!!!
> 
>                                        That data page is reallocated as a PMD
>                                        table.
> 
> 					text_poke() keeps writing
>                                        code bytes into it -> entries
>                                        with arbitrary pfns, one of them
>                                        pfn_dh
> 
>                                        reclaim: try_to_unmap_one()
>                                          pte_offset_map() -> __va(pfn_dh)
>                                          set_pte_at(swap PTE)   <- dentry
>                                                                    hash table
> 
> (The reason it needs to be interpreted as a PMD page table is otherwise
> reclaim wouldn't be trying to write a swap PTE entry into it).
> 
> And this is exactly what commit 1587d3394e25 ("x86/alternatives: Exclude
> text poking against change_page_attr()") protects against.
> 
> Yes it's out on a limb (and I spent FAR TOO LONG going through this
> analysis) but there's really no other sensible explanation as to why dentry
> data got corrupted like that to that exact shape.
> 
> Which goes to show how nasty this kind of data corruption issue can be.
> 
> >
> > I'll be very very gratefull for any hints here..
> 
> As above :)
> 
> >
> > with best regards
> >
> > nikola ciprich
> >
> > PS: I tried to CC maintainers of suspected subsystems, but those are just my guesses,
> > so I hope I won't offend anyone.
> >
> 
> Don't worry about that, I think we're all happy to get legit bug
> reports. We just might be too busy to reply right away :)
> 
> The LLM added on some hints for confirmation of this:
> 
> Schlopp>>
> 
> Log greps, across all affected hosts and all boots, not just the ones
> that crashed:
> 
>     grep -i 'Bad page map' /var/log/messages*
>     grep -i 'bad pmd' /var/log/messages*
>     grep -i 'bad pud' /var/log/messages*
>     grep -i 'Bad page state' /var/log/messages*
>     grep -i 'CPA: called for zero pte' /var/log/messages*

not a single occurance (this machine uses journal, but I checked those
and no such messages.. in general i tend to check dmesg and system logs
a lot, so I'd have already reported such messages..

> 
> Any of these, particularly "bad pmd", is direct evidence that a freed
> kernel PTE table was reused as a user page table. "CPA: called for zero
> pte" would be the CPA walker itself tripping over a collapsed mapping.
> 
> Questions:
> 
> 1. swapon --show on the host, and inside the guests. Is there a swap
>    device with index 1 and a size of at least roughly 30.5GiB? That
>    tells us whether the corrupt word is a host swap PTE or a guest one,
>    which distinguishes case A from case B above.
> 
> 2. From the vmcore, dump the 4K page containing 0xff2e6dbe0e51b440. If
>    the neighbouring words are also PTE-shaped, the page was being used
>    as a page table and the diagnosis above is confirmed. If only the
>    one word is corrupt, it was a single stray store.
unfortunately I don't have full vmcore from that crash, as it didn't fit
to /var/crash, backtrace I posted is from vmcore-dmesg.txt so can't confirm
that..


> 
> 3. What are CONFIG_DEBUG_VM, init_on_alloc, init_on_free and
>    page_poison set to in the production build versus the KASAN build?
>    free_page_is_bad() is gated on is_check_pages_enabled(), which needs
>    CONFIG_DEBUG_VM, so the production kernel would not report the bad
>    free even if it happened.

I don't have CONFIG_DEBUG_VM enabled in production..

> 
> 4. Are any of the crashing guests Windows, and is hv-tlbflush set on
>    them? That decides whether 26505e1b5b54 matters for you.
yes, windows, but hv-tlbflush is enabled on a sigle VM and it runs od
different node all the time.


> 
> 5. Has any corruption occurred since THP was disabled? If yes, that
>    supports the CPA race over your THP theory.
not yet, but it's not happening that often, so unsure here

> 
> 6. When you run the 6.18.54-rc1 test, please note that 6.18.52 is only
>    a partial fix, so if you have any results from a 6.18.52 kernel they
>    should not be treated as a clean run.
sure, I'll start today with 6.18.54, won't consider older tests.


> 
> << Schlopp
> 
> But really a run against 6.18.53 being OK under heavy testing for several
> days should confirm it also.
> 
> If it turns out it's not this then back to the drawing board I guess! Let
> us know.
I surely will!

cheers, nik




> 
> --
> Cheers, Lorenzo
> 

-- 
Ing. Nikola CIPRICH
technický ředitel

+420 591 166 214
+420 777 093 799
nikola.ciprich@linuxbox.cz

www.linuxbox.cz

