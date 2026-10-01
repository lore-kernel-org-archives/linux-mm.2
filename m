Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48053CA5FD2
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 19:41:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E9606B0088; Thu,  1 Oct 2026 15:41:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 099D96B008A; Thu,  1 Oct 2026 15:41:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF1D46B008C; Thu,  1 Oct 2026 15:41:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C74636B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:41:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 380DF120554
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 19:41:22 +0000 (UTC)
X-FDA: 85275076404.13.F534B5F
Received: from gwu.lbox.cz (bck.lbox.cz [193.165.144.186])
	by imf08.hostedemail.com (Postfix) with ESMTP id A2501160008
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 19:41:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b=00COJ5bx;
	spf=pass (imf08.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 193.165.144.186 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz;
	dmarc=pass (policy=none) header.from=linuxbox.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790883680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FZMJ3of9h2zjYqREJLmrVh3ELzDIAAnl2juI8l3qEW0=;
	b=UBzWiE5IdnJwc57SlPaaiTV6SXsG7O2NO0QoDw8An2tq2QOfUIia6OO3V5gkQx71wuJ/ec
	PKPLvGkBHYuBLD2n5ihz0RqHwgAtEFODlaGE8rxuJD/K50J2LWXNYx8c/lG2OnToS30Xch
	Fb2ljMXLYp4QcqnKd4eQm8eOnOUSqIw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b=00COJ5bx;
	spf=pass (imf08.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 193.165.144.186 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz;
	dmarc=pass (policy=none) header.from=linuxbox.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790883680;
	b=l/1rd/GHeHJtqhmHCQoZMLrhS8yvr33U2nwr8IrVr6wauS8fdoTZISgD9y1Rq2ZFJsoOxu
	cafeb6kY/+9garsrjDGYBxxGMokcnPxWj6icj6Q6lcOkwX6hTp1jCV19JtyvCuiDs7nsZ5
	xFFn8pbEYHPHjxdnuXRu09PpurLIPNw=
Received: from linuxbox.linuxbox.cz (linuxbox.linuxbox.cz [10.76.66.10])
	by gwu.lbox.cz (Sendmail) with ESMTPS id 691Jf4gI3748979
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 1 Oct 2026 21:41:04 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 gwu.lbox.cz 691Jf4gI3748979
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxbox.cz;
	s=default; t=1790883665;
	bh=FZMJ3of9h2zjYqREJLmrVh3ELzDIAAnl2juI8l3qEW0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=00COJ5bx/dX149M66PbRPeZIKMv9DUGe5n0iVWaFUnGXov7aPz8wukGlwyAM8MxeA
	 /rhU6q6sh4J2z0yr8z0XQrmybCvqjCu000QiodcBcNz6mdcbk4TYTdEES7QyuLCdBm
	 CeV7u4hWAejVLGqIe8SSFPgXYaLrg/T+vGxCohBU=
Received: from pcnci.linuxbox.cz (pcnci.linuxbox.cz [10.76.3.14])
	by linuxbox.linuxbox.cz (Sendmail) with ESMTPS id 691Jf3MV038171
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 1 Oct 2026 21:41:03 +0200
Received: from pcnci.linuxbox.cz (localhost [127.0.0.1])
	by pcnci.linuxbox.cz (8.18.1/8.15.2) with ESMTPS id 691Jewe32175335
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 1 Oct 2026 21:41:02 +0200
Date: Thu, 1 Oct 2026 21:40:58 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, david@kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>,
        luizcap@redhat.com, pbonzini@redhat.com,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <ar63St2LBfCdyhwj@pcnci.linuxbox.cz>
References: <arY1Wq6R9OY20ans@pcnci.linuxbox.cz>
 <arZHp8hjYFXE8Rkt@gremlin>
 <arde/t0zQNEkWqi5@pcnci.linuxbox.cz>
 <areOeRwZOez0eHm7@gremlin>
 <arotyz5g6LozSjb1@pcnci.linuxbox.cz>
 <arwNebjYXyGqrp32@pcnci.linuxbox.cz>
 <arzRBv9ceJsxJppI@gremlin>
 <ar1Xl7PE2rcoT9h3@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ar1Xl7PE2rcoT9h3@pcnci.linuxbox.cz>
X-Scanned-By: MIMEDefang 3.7.1 on 10.76.66.3
X-Scanned-By: MIMEDefang v3.7.1/SpamAssassin v4.000002 on lbxovapx9 (nik)
X-Scanned-By: MIMEDefang 2.86 on 10.76.66.10
X-Antivirus: on lbxovapx9 by Antivirus 
X-Milter-Copy-Status: O
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A2501160008
X-Stat-Signature: xeq4jz9m15r8q9r5j71xxft1m31aifjk
X-HE-Tag: 1790883679-758827
X-HE-Meta: U2FsdGVkX18vTHMf9assfysr+PcLQDITy1LNjs8nfpCHj5E7R+RqcMp5T2vNPxY6nLEQSWzLLUiFit5shz0N6NnRUn2MQwyJWul/MiqQkoJg1CO47HuVde1OjUjqpYhys5NUN8FSX6Eg07by71Ax9lxsxkTS8kQJCEFs3xEWcZlrlaNCa0nl142qzAFLRLv8K2sIdIvIXyMTVLTner06wK4NYv3HdJFmnxhtlBfB82NqVTouZfMljDvvIvqRkCFFY0Kf6AqMoP1PCJi+n0WR3cIxeYEWMXBb+Fi5G+zkuBdze3gXDXgQ9LvZ86A32+5q4Z7Ad54ozvqql73cese9wdu2KnaP6XRJ/sEoCG8eK/0NsL3YmmZh3cpYChD9mQdeJ+4ON8LbmjWJZTPe225LXsAv5esgYpg5FZBvIpKBMeuaJlwwsYMMYSMbgoTy1mlLMfcshoSROdjQJKdHx29IqORct7XpRwg4E/SvKo7Q35MM3ZWrmaQxvofsao7vFdBwoIlE5CdVe8XUMgIXPnxkEgVZ8mPPWLm7y1pyqwbOo5jXiDsBi8Jh3Ez/Ooed1OtEDT/cMtWRHKBqLaCYjXLfMdMr7QcuzCpacsSOoBj9Jn19nvcx63Vqqvm5veDGTa3xARCI/Ge/gglfT9W0M/sP5E/bCdlKFIBW8nZ8GIoajtEkdwp8Hv5ws1QD2OIHAAJPfUKv73ZQLhnwivOc/EGgZqIDKC5VPjWR3eSZKnv6I8Wim/ugQ8jdhdNQ6WqtzLWj8OpO3nms0gH+250HRFEjAbZ0rxZQmD9ocIc4XPyLCcsmsHD92jXWasMV2UFShdUG/JiOOd6v6Vw1ET/UYdHUD92cJomvF7K6hEb8+WSNtFBJf12I3Vbt6Oqkeeav/AvYFFMBFrRRDrzJJ/NrYS7DZ0Mtx+PN9fqfV6ip5kfntEH8pOrwdVcRftL5K6baWhx/tRXStSz+aFomtHTeIty
 bpz5ZPoC
 U8JKmgcXDYNLIel1eyikHJRwMVjm6osCJz9zNaeJv6b+bvNJ0OZ+7gkd51W3jy9t+1pv/XE5EPjUOMsAewupx3/rPCEmteFcLGdqXBYDMFveDCik4E97TJKmtGodLAav1GgJFZNFCDj+uAOBSlXn/d97sbp0GjgM4qDHOvnZgW4Pu9gXiPLuJDOE0CPEcWIUtM187fE7eeITR3kFiYq0RkvwJs32w+riCo7GbY0ki031lT9WPwLa5n82D2Ia5u5rjRQ5CJMNyyP5d9E2ww8ewB26TO06fLr0rLBHYAcRJG73pO78=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello again,

the good (?) news is, in the meantime we got another crash on different machine
and I have a kdump including complete vmcore. This one was 6.18.53

here are some details:

Hardware: Supermicro AS-2024US-TRT / H12DSU-iN, BIOS 3.5 (2025-09-22). Dual-socket AMD EPYC 7343 16-Core, 32 CPUs, 1024 GB RAM.

analyzed with crash + matching vmlinux debuginfo:

Oops:
general protection fault, probably for non-canonical address 0xfffffff0c930038
RIP: __d_lookup+0x4a/0xc0
Comm: systemd PID: 1274600 CPU: 23
Call trace:
__d_lookup
lookup_fast
walk_component
link_path_walk
path_openat
do_filp_open
do_sys_openat2
__x64_sys_openat
do_syscall_64

Exception frame registers:
RAX: 0fffffff0c930020 RBX: 0fffffff0c930020 RCX: 000000000000000b
RDX: ffff985ffd223600 RSI: ffffb18962823d70 RDI: ffff989ddf09b5c0
RBP: 000000005560450b R8: 000000007fffffff R9: fefefefefefefeff
R10: 0000000000000000 R11: 93c3d2eb02a31dda R12: ffff989ddf09b5c0
R13: ffff989ddf09b5c0 R14: ffffb18962823d70 R15: 0000000000000000

Faulting instruction (cmp %ebp,0x18(%rbx)) dereferences RBX+0x18. RBX held
the non-canonical value 0x0fffffff0c930020, giving fault address
0x0fffffff0c930038. __d_lookup was walking the d_hash (hlist_bl) bucket;
RBX was the node pointer being dereferenced.

Observations from the vmcore:

The faulting value 0x0fffffff0c930020 is non-canonical and is not a mapped
kernel address:
crash> kmem 0x0fffffff0c930020
kmem: cannot determine page for fffffff0c930020
fffffff0c930020: physical address not found in mem map

The dentry being looked up (RDI/R12/R13 = 0xffff989ddf09b5c0) is intact and
well-formed:
 name "app.slice", len 9, d_name.hash 0xCE973022 (consistent)
 d_op = kernfs_dops; valid d_parent, d_inode, d_sb
 d_hash.next = 0x0 (this node is the end of its bucket chain)

 The target dentry and its hash chain in the dump show no corruption; the
 chain terminates cleanly.

No page migration, compaction, or THP activity was in progress on any CPU
at panic. "bt -a" filtered for migrate*/compact*/khugepaged/kcompactd/
kswapd/split_huge*/folio*/d_move/rename returned nothing.

Automatic NUMA balancing was disabled at crash time (read from kernel memory):
 crash> p sysctl_numa_balancing_mode
 $ = 0

Top-level (PMD) transparent hugepage policy was "never" at crash time:
crash> p/x transparent_hugepage_flags
$ = 0x1c0
Bits set: 6 (DEFRAG_REQ_MADV), 7 (DEFRAG_KHUGEPAGED), 8 (USE_ZERO_PAGE).
Bits 0 (TRANSPARENT_HUGEPAGE_FLAG) and 1 (REQ_MADV_FLAG) are clear, i.e.
sysfs enabled = never. Per-order mTHP controls (huge_anon_orders_*) were not
inspected for this dump, so mTHP state is not asserted here.

No MCE/EDAC/hardware-error records are present in the kernel log for this host.

I can provide the full vmcore and the matching vmlinux/debuginfo on request, and
run further crash queries against it.

not sure if this is of any help?

with regards

nik



On Wed, Sep 30, 2026 at 08:40:23PM +0200, Nikola Ciprich wrote:
> (CC Paolo Bonzini)
> 
> Hello Lorenzo,
> 
> > 
> > Yeah 6.18.15 is expected, I'd not say reverting is really worthwhile honestly,
> > given what you've observed previously.
> yes, I wasn't available at the time he was dealing with that..
> 
> 
> > 
> > Maybe worth checking if commit 26505e1b5b54 ("KVM: SVM: make svm_flush_tlb_gva
> > do a full asid flush if NPT enabled") helps in that case?
> sure, I'll do that.. however, the patch doesn't apply cleanly on top of 6.18.54 at
> all.. what do you guys recommend, is it OK to adjust the patch to this kernel
> (I have to admit I'm able to do that, but without any deep knowledge of the subsystem)
> or do you recommend to apply some of the previous patches?
> 
> tried going through them, but its ~134 commits affecting svm.c between
> v6.18 and 26505e1b5b54
> 
> cheers
> 
> nik
> 
> > 
> > --
> > Cheers, Lorenzo
> > 
> 
> -- 
> Ing. Nikola CIPRICH
> technický ředitel
> 
> +420 591 166 214
> +420 777 093 799
> nikola.ciprich@linuxbox.cz
> 
> www.linuxbox.cz
> 

-- 
Ing. Nikola CIPRICH
technický ředitel

+420 591 166 214
+420 777 093 799
nikola.ciprich@linuxbox.cz

www.linuxbox.cz

