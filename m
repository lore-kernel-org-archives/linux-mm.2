Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7C8D606A332
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=b4UlxNx+
Received: by kanga.kvack.org (Postfix)
	id 0C0A96B0805; Tue, 24 Nov 2026 12:33:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0989D6B0807; Tue, 24 Nov 2026 12:33:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F18666B0808; Tue, 24 Nov 2026 12:33:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D45956B0805
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:33:33 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4CAFA140C90
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:33:33 +0000 (UTC)
X-FDA: 85470709506.23.F865C27
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5F797180015
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:33:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=b4UlxNx+;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795541611;
	b=bAWZQOjks+jiKzJ7uvvQhoI7BL9bHfZDdqsJE87+tIsFJ7fyXZcYjBpnYACoWPz8tLZzO2
	GEk82lkkFtyqRrUE/u9gfn1bSfGKNiqL47BgRUYveNgYWSSxmQb3H11hCAxEBqfVxLcT4H
	8wul1TISfwFZbkLzYGHyRVJ3Y2aM+Ac=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795541611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=blq/el2aPt5UfDt/KiVCvCZ0Fkkm7VLYJBz/or3AGCI=;
	b=bKfzVdvhuzmRaZnOvnPsb8mlPAI2PqsD+4M2ED/ETb2WkwvpQDj+4hP66GJoj0fGAz9Vlt
	q2UxkiWZmvJY7jSLZ4XCQyqTdkVHRaQ7XxmOe1qVHDrJ65m5jHlQ4tKfX6Phj0vnRXyioB
	g0JZ6Ip9P0JdqYhDORQ6CUFFAJH6710=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=b4UlxNx+;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AC8F862639;
	Tue, 24 Nov 2026 17:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090C61F000E0;
	Tue, 24 Nov 2026 17:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795541610;
	bh=blq/el2aPt5UfDt/KiVCvCZ0Fkkm7VLYJBz/or3AGCI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=b4UlxNx+hHhTvQlpuWn5Ve2tZChP3vfavnkVO8u3JGwAdSDvVnEl9QrxbONCENhk3
	 DWYyWCuN5+CAQekwedZhHBjXousbu7eTBul+L2nCB4J8Y16encOJ22C99TIMv0Paca
	 mifcMmZICk8tDWEmGDl+z8GQuiwgDybK5mZ9iTx4=
Date: Tue, 24 Nov 2026 09:33:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Puranjay Mohan
 <puranjay12@gmail.com>, Pedro Falcato <pfalcato@suse.de>, Ingo Molnar
 <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli
 <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt
 <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman
 <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, K Prateek
 Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, David
 Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>, Jann
 Horn <jannh@google.com>, Alexei Starovoitov <ast@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/vma: drop mm asynchronously in vma_start_read()
Message-Id: <20261124093328.3ba2e066e5d5081c69e0e667@linux-foundation.org>
In-Reply-To: <awXHR007d8MlhJUC@gremlin>
References: <20261124-vma-read-lock-mmdrop-async-v1-1-257f99f551de@kernel.org>
	<awWLCZ-jBjSD7V3M@pedro-suse.tail5790ac.ts.net>
	<CAJuCfpGk6eYK43Unxo+O4ML5=GM_siZ9owp6oa9fO0ipZXVg-g@mail.gmail.com>
	<CAJuCfpEd1rz3P7fB7W_mHkyzbpq9TscRE+QNwvHdYME=WJj6cw@mail.gmail.com>
	<awWz3nc_b8x3mIXq@gremlin>
	<CANk7y0gAxY18Ew+6j5YsqrOsf5Dx+v5M78r7_8JLXh5RHZj4qA@mail.gmail.com>
	<CAJuCfpFuDCUPTUi3SuAhmbtw5tubRZ0+YEY3PotjyJ8Or8pdQQ@mail.gmail.com>
	<awXHR007d8MlhJUC@gremlin>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z1pnfzqnofudsp1zabeckmq8ba8z85wn
X-Rspam-User:
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5F797180015
X-Rspamd-Server: rspam03
X-HE-Tag: 1795541611-375032
X-HE-Meta: U2FsdGVkX18dqOExbMP87YQkB+2qjl/enqVSaCfjUkRrl/DMGicS2d+aLKjg//1yBXEHzmqmSicn2UAaWgSWCbikX3KvvcChIDRzI2HCxXy0VvhqFRdBtiPHIktmZUhvze5g9rzLBgbVdsw0wkhO2/mlzkUtzzVcA5FbPv6hEPOwznTP1g6WHZ816lkazC2B8DGnO1ieFPnjGKfm6caK6sPUSpbuk2Iz6Iuq3Zbrlyo6Bhvc6TWQJlv87Xvi59uh5Hgsx+LBxlo/TyAfc/eMZ+6QTkJp0PHSHD4kf+ZtZFtDdV2S8naVxrLX/ZzzGTWS0towQgdaj6AymQDHudThiAFPoJoviDTlUvBtf7TUuEhqPYEJs5L/1ZJns1HbAIeDVnLeeKE2WifLzxkFLi9FImzX7NQYtfXiCp2JkZDCnEjFSOPD0jSe7lMG1mq/yY3Hu3BVtC07pzPkapZ+O/yZzZBD8g7xiDlAHTYsWuxbaAmEcn4pPoQt5RxsdXmNZcSavwMqQ1WRCOVuoO8x6NYriKMMXhE7/9O4s5tqvJpcdiHWjhECP2P0yLEpEuCbMRdZ1KVJR23PdZzcK5CJO1Vvzr/6P/mEW5HSVNKK5cCMzdn+vhyjmL82SEA57mPUdCL7DbUOtcLJCEdGjvv59Zfz5yTsgDVMV40o2ah/HF2jGIDF2TrR7pnOHHO+MyAxmFzwHHNkYYmibyJxnFRzdSetVn/YPR4Ugpm0kcgaSlE32+anu6QB1P7EomhcjqcNKUaeNTWzB4AlKYHzhKkd/5TmFM4G9thHYGxeKPwkyUSte6YyjM1SLG5sqwbcpFPUahFwCYKyrGsdWfyssVTfQNfpb+PPZ6Uh1hsvb4lTdDcU/zELAiGZZe78A0VMC6ZHl9+j/BUs+MEBB/VYbC6ykEUSBE+oJUHm0I9fFSZ9d2Y1DPR1AaNzQv2N4ZCNFzu489psvK/+LFe8i3x1MVaZyaN
 KWlyXTKp
 nWDoUAzFGbqxObf9ILT0dO87IWZdzKXwKzBzOmNQ1Z0me9LCybJIAtMM4rI3yvQz64Rjo/mZVIARN5JE2f5pytB8HlVMp7wfi/6CC9QZ8/C3hfI8WCXrEVp2m0VA3hH/DnRE1IPkcqPTpK3hzEsNTokeJHHPTJYN2PL7O02AVppSLmw8COM+8VA+mXnLeltj80GxNOt14jtHWAF419qpQb2u7ZjakG9OP+BgNYiw9jSkQCSq3DX+ohBalfwxylByMPTUG/X2wW8/pKjr6biGoDZ55ylE+CPXa7DmEUihT5Jhdq1QTh9zoVBAzw21PDz74wPgJwPGk1qjfgHo+AB12AKvcBslyAt3bV9KO7CRW+yOdO4JBkI7vPTJprwWYqf0NjQBTBWJBeWfAE8Imjo+vh0zWuDjxYZjQU8CZxT5C0uREZn0x8OaSiXqGGViAyG1+8WN4PBaGSiDHcthX2jTLa3DhR92SV+sN4KPAipbJMk3J7w7D/+KoCNR45sFjERMrLtKtoZRzv2pt68Dro0k5gHhfP2K967wbSpvnjn301sZSE0U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 24 Nov 2026 17:23:35 +0000 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> On Tue, Nov 24, 2026 at 08:34:40AM -0800, Suren Baghdasaryan wrote:
> > On Tue, Nov 24, 2026 at 8:06 AM Puranjay Mohan <puranjay12@gmail.com> wrote:
> > >
> > > On Tue, Nov 24, 2026 at 9:28 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> > > >
> > > > On Tue, Nov 24, 2026 at 07:51:42AM -0800, Suren Baghdasaryan wrote:
> > > > > Actually, VMAs are allocated from a SLAB_TYPESAFE_BY_RCU slub. With
> > > > > that RCU unlocking move you don't need other_mm copy and the comment
> > > > > that comes with it. VMA won't be freed until RCU lock is dropped.
> > > >
> > > > Yeah but they can be reassigned? They won't be _freed_ until a grace period but
> > > > they can go back to the slab and then allocated elsewhere  right?
> > > >
> > >
> > > Yes, they can go back to the slab and become a different VMA.
> >
> > Yeah, you are right about that. So, we either have to keep the RCU
> > unlock in place to keep other_mm comment valid (my personal
> > preference) or update the comment next to other_mm to explain the new
> > reason it is needed. Either way is fine with me.
> 
> I think let's just change the comment?
> 
> Andrew could you change:
> 
> 	 * stable and can be freed in the narrow window after vma->vm_refcnt
> 
> ->
> 
> 	 * stable and can be reused in the narrow window after vma->vm_refcnt
> 	                     ^
> 			     |
> 			     just this freed -> reused :)
> 

np.

--- a/mm/mmap_lock.c~mm-vma-drop-mm-asynchronously-in-vma_start_read-fix
+++ a/mm/mmap_lock.c
@@ -300,7 +300,7 @@ err:
 err_unstable:
 	/*
 	 * If vma got attached to another mm from under us, that mm is not
-	 * stable and can be freed in the narrow window after vma->vm_refcnt
+	 * stable and can be reused in the narrow window after vma->vm_refcnt
 	 * is dropped and before rcuwait_wake_up(mm) is called. Grab it before
 	 * releasing vma->vm_refcnt.
 	 */
_


