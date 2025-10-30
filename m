Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DF76CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 13:38:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1AEC8E014A; Thu, 30 Oct 2025 09:38:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF2CD8E007D; Thu, 30 Oct 2025 09:38:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB9F18E014A; Thu, 30 Oct 2025 09:38:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 80D688E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 09:38:53 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 40B6B1DD889
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 13:38:53 +0000 (UTC)
X-FDA: 84054886146.18.12BBCC1
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf18.hostedemail.com (Postfix) with ESMTP id 362151C0009
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 13:38:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=t9zA7uUa;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3aWoDaQkKCJo4FC68LSBFAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--aliceryhl.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3aWoDaQkKCJo4FC68LSBFAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761831531; a=rsa-sha256;
	cv=none;
	b=7fFcWPC7UbQi6Mjd4SmpkuoP9YR84FuiqWbJBCZ2zDLtDPdSEb4IQM6zPV5GMaYBcOU6W6
	xwqNI431XV9qiHsfFxf2/MT2cxy1VbbZcsCAAoJYfu1s/RS1ztpDtc7YhlA570Kaq6DROM
	+UGtf9IM/TXUq/FhSVt3/fGIgONsO3w=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=t9zA7uUa;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3aWoDaQkKCJo4FC68LSBFAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--aliceryhl.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3aWoDaQkKCJo4FC68LSBFAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761831531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rzizyigWEWNNu2Rm/2eP+nusGTJ78MPlsLNlCE42LDg=;
	b=qPHwGJS8hIvnIjdiSWCV86yTScZ8G9KhQkUw2iJL4j/zoupeL3weOHXh/zgY5fdgUZ0w8y
	rTf2rWsLcRfIeC+VnVuW5qecAHYbKmKw/vfgNf5Jm6rc8Vk4Hr0lmkh2ewKoR8lRrzYEt4
	kO7JwA7id+Ccvj9HM+7qzGq8yGRCNo8=
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b2ef8e0133fso126553366b.0
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 06:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761831529; x=1762436329; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rzizyigWEWNNu2Rm/2eP+nusGTJ78MPlsLNlCE42LDg=;
        b=t9zA7uUaSl+BsKGjYHcYGhA7PTuixxTOnz1gkneAbQS7WFiVjO8xzw7QUy81cmCDmV
         skxEpeKSmTNjX3Y2u7y6FRwmDKWvhn/LjpGJpWROtMXtn6N96MQweUcz1Wgykp76wv5O
         JBCJk2wrlcOo2U7csu7sDkiKnyA84WpSap2ab0MuWm14yOduEbnvcBh24h+sG8b4GYiZ
         4McYYHxiDODD8Qabj6Y5/YKEd/v8GBP7yRbCS439MYkaPbt29m5bcQXGpobfTs5v2rwg
         fS0HKxRzScPPrZVmA4l8uxV7XJNOWpP4K0FyifZH2LFptNiGwKqYK4G//AlfmFXIMgmB
         4l9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761831529; x=1762436329;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rzizyigWEWNNu2Rm/2eP+nusGTJ78MPlsLNlCE42LDg=;
        b=wQgN6X3u7a/lXW0xeKp2HIV5XXscRRdEH2PjLjJSgOtYJu2hWUf9JJBbK93TBlPGbH
         R276Bo8QBCA28xKLnJN8bHibiAmsG4uzr5E3dFkLn22KnRZ7rAjNX4HC0nFu5Kae8p4Z
         3RVwtrPNgvRJiHVQvE/Tw/jbK3QFZA0Sult98pnWhXo9DJOBsQgDgnF5qiKRoclrs2nT
         b/DfJUsDdATAlUXCX/6OXoe1RFr/tc/B0xPoFosXdc2Vgnh2trIXBuKVilOtjPJ1EoZM
         Cenj0Ks7Gf0nwUSkXyJV5Qk8Ha1JTBBHfqXUiPHUOkGUM4s/R8nxMfoLfXA+yuoDqVS5
         xvoA==
X-Forwarded-Encrypted: i=1; AJvYcCX9VZtww4K8EfQT9dl4zHo1RL14elClQmcEDkeocCWkjH6GcabMVyKLK69p0XSglBw7l4QtG23njQ==@kvack.org
X-Gm-Message-State: AOJu0YzEiDTaZlIf0Z1gwuM8TbDGhf+2HbKMPtx2dsg47Cp6siByg6tW
	rRpe5NTCSH11IevQ/115qteAo1T9XpjsPIN3oynKrWGFu0oKb5r0hu2LRAIamg3eT8X5hCr7aSF
	jZ9Z4HXsfDw5qf3snvQ==
X-Google-Smtp-Source: AGHT+IFQZ/SjAgSITlmWeur1y2C8MijeD0xlGb6/8NoKt+QVOUWdbp57xlCr+JyU4QefHZOGRpfsOoboSN1j5ds=
X-Received: from edben19.prod.google.com ([2002:a05:6402:5293:b0:63c:1259:729e])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:1d4a:b0:63e:405d:579c with SMTP id 4fb4d7f45d1cf-64061a75a54mr2583600a12.29.1761831529129;
 Thu, 30 Oct 2025 06:38:49 -0700 (PDT)
Date: Thu, 30 Oct 2025 13:38:48 +0000
In-Reply-To: <de187794-8a28-482d-802c-8e0fb6f89e5c@lucifer.local>
Mime-Version: 1.0
References: <cover.1761757731.git.lorenzo.stoakes@oracle.com>
 <CAA1CXcCiS37Kw78pam3=htBX5FvtbFOWvYNA0nPWLyE93HPtwA@mail.gmail.com>
 <4e6d3f7b-551f-4cbf-8c00-2b9bb1f54d68@lucifer.local> <aQNPXcxcxcX3Lwv0@google.com>
 <de187794-8a28-482d-802c-8e0fb6f89e5c@lucifer.local>
Message-ID: <aQNqaPOPzkz2eFUY@google.com>
Subject: Re: [PATCH 0/4] initial work on making VMA flags a bitmap
From: Alice Ryhl <aliceryhl@google.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@redhat.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Peter Xu <peterx@redhat.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Kees Cook <kees@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Jann Horn <jannh@google.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Pedro Falcato <pfalcato@suse.de>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Rientjes <rientjes@google.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: mj3k98ui7jxss9qo7zoa343jownpdq6s
X-Rspamd-Queue-Id: 362151C0009
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761831530-142388
X-HE-Meta: U2FsdGVkX1+GSeYz33Dui/4NfFdDoX2N5w4oJisTvO2zQglGltjQkqgTc68Azh9clOJV7GEKvPPPqHGhGcsfuAis52YLQNpyWgU9UEFIdOJsFSu5ncbhVgdGFweEG8XeOet5j3tojVNar2s7uQ8yqh9S7l5eoqVsDQwI8NgLv25rOZBB8WvtK3H4ZVaEQdaXnq220A/VgZT2zwel+O4PODAjUDcxUNeciOB7brpOsYQB+UghdZeTh+YPVfH1QJlHTE5JMCb1aqcBSd8cC4PEMao+CfZpscl18TzV+Xl2jixHxLZHsOU5tLVhW+cDKYIUVAAMhWJIIp7vA1w+8kW254zOJQpLhGlcWYb9fxitQXJSmZHZyyFqZVGAbPCU+4+ZOnNLVH81CQXMuzfqRJNv1fy9AYJhet94HJfV+sPNA9CV35PFsd7Vf1L34WXN5agonL5bBNBtVeL9C8phB+Fa72TcdjG4ctiLQP4UXT2CIcRaTDUie/pJ6/Z1+AxJqVOQN7UV5KG8z+kzCbRYAbtH8MmJ/6mDTJyAat75ocLnQxlFfldIdADDLYn6UtfI0igzVXlvaUn1sz6Wo51LQwt7z7GM9E47+RqZcdxuO+05ptxOs92EqQm9AmHAFEcj4mRM/AfmOLHEac5C4+yaaP2U6PDIKpBR7VUVnlIyr9qBqtnCWEY2n/z2A84iNLONb0yeVylSw97062N+4ycmh0HjZFFhY0cPrBTBbCXdBNwNW6G0YpOSRYdofhVtZOWdLFe6U6y1Uq3RoDgMj3bdlbw0GHRlQQin4cyR3NiVQITbQmBWjMTDPJFyjDglI84ZmXhEyoMUGV0T2yrmsvdIN3mSj1IiKE+8utcBF5+D8DsE9pRiNkpfP9TbZOknepL0RgjYE8XQrVW0dY/8cxLJ0N3lyW9p7HhGs0pDbw5YftULfmd2rYAuHaycrKA4i2y24amjLlXV9BUY2wfKT57+3Jf
 9wcGtljR
 UbUBvZQc1SlteNQQeeQIS4lFrwu8NJyAl/RG5z5M03QM6dAV/5e3c/U9vbLiikLUoOk4vx0QjgNADnGL5R4Yst7tClk8VWaZFv+G536FVD+wghaAf1891hA9QdPIsHzEgQqsT036x0kgpEIymEaIm/538rwQrYFDfgAHe6CZl75w3aBy8UQ432vyAvitsNvscbgTmXQ1B2K6V4Dgt3d0aQQsp/woihP9aPtwjR5AiFXz+sqsSkMrzj5jF7Haxaqt5VOheg0m8BuYG9VpkyHUaTLOnnDd00v6PidYrRPB9dsO0rWzWvGrf0Xg2F52JRErBnV9I1excud4MIEcfIBB6ZbYcTLJ5QmxE84k3H9qLAyw3aL8L+TIgHF8f61GHAqsybLa2pS2Ew1puI5yWvc51+j/hAAJbsGMb6rXuIt7WvReeHJ0FQGR/ZkDzwwaqOpeSckI3ic/Ze7YvxwSbEWYtYOP6n7V5cYNwpPVxkgOsu9RfrV+0y2bA14eUYt8kf3/ZKhhBcnJTRwVzGacBICfTcJYc4yGBOJdF50m2YF/Z2d9IQ50LtbBVx/r9EQALnRiTHb060QK+NfBOCUVrNF6XkSvT03Uuy/6dO/Kxf4dn0GJVJTsFhEYKKw1e2UcmvqPctZ3u2j7xlWrNETo6Y025ereic8Vhj1y5Hlw/I0WSItWQdOfu9S32VzisKSOX4HP5HyJ3SVzpxWLtPyxbumnpLqRFANt6ln7ciIHL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 12:02:58PM +0000, Lorenzo Stoakes wrote:
> On Thu, Oct 30, 2025 at 11:43:25AM +0000, Alice Ryhl wrote:
> > On Thu, Oct 30, 2025 at 08:33:10AM +0000, Lorenzo Stoakes wrote:
> > > +cc Alice - could you help look at this? It seems I have broken the rust
> > > bindings here :)
> > >
> > > Thanks!
> > >
> > > On Wed, Oct 29, 2025 at 09:07:07PM -0600, Nico Pache wrote:
> > > > Hey Lorenzo,
> > > >
> > > > I put your patchset into the Fedora Koji system to run some CI on it for you.
> > > >
> > > > It failed to build due to what looks like some Rust bindings.
> > > >
> > > > Heres the build: https://koji.fedoraproject.org/koji/taskinfo?taskID=138547842
> > > >
> > > > And x86 build logs:
> > > > https://kojipkgs.fedoraproject.org//work/tasks/7966/138547966/build.log
> > > >
> > > > The error is pretty large but here's a snippet if you want an idea
> > > >
> > > > error[E0425]: cannot find value `VM_READ` in crate `bindings`
> > > >    --> rust/kernel/mm/virt.rs:399:44
> > > >     |
> > > > 399 |     pub const READ: vm_flags_t = bindings::VM_READ as vm_flags_t;
> > > >     |                                            ^^^^^^^ not found in `bindings`
> > > > error[E0425]: cannot find value `VM_WRITE` in crate `bindings`
> > > >    --> rust/kernel/mm/virt.rs:402:45
> > > >     |
> > > > 402 |     pub const WRITE: vm_flags_t = bindings::VM_WRITE as vm_flags_t;
> > > >     |                                             ^^^^^^^^ not found
> > > > in `bindings`
> > > > error[E0425]: cannot find value `VM_EXEC` in crate `bindings`
> > > >      --> rust/kernel/mm/virt.rs:405:44
> > > >       |
> > > >   405 |     pub const EXEC: vm_flags_t = bindings::VM_EXEC as vm_flags_t;
> > > >       |                                            ^^^^^^^ help: a
> > > > constant with a similar name exists: `ET_EXEC`
> > > >       |
> > > >      ::: /builddir/build/BUILD/kernel-6.18.0-build/kernel-6.18-rc3-16-ge53642b87a4f/linux-6.18.0-0.rc3.e53642b87a4f.31.bitvma.fc44.x86_64/rust/bindings/bindings_generated.rs:13881:1
> > > >       |
> > > > 13881 | pub const ET_EXEC: u32 = 2;
> > > >       | ---------------------- similarly named constant `ET_EXEC` defined here
> > > > error[E0425]: cannot find value `VM_SHARED` in crate `bindings`
> > > >    --> rust/kernel/mm/virt.rs:408:46
> > > >     |
> > > > 408 |     pub const SHARED: vm_flags_t = bindings::VM_SHARED as vm_flags_t;
> > > >     |                                              ^^^^^^^^^ not found
> > > > in `bindings`
> > > >
> > > > In the next version Ill do the same and continue with the CI testing for you!
> > >
> > > Thanks much appreciated :)
> > >
> > > It seems I broke the rust bindings (clearly), have pinged Alice to have a
> > > look!
> > >
> > > May try and repro my side to see if there's something trivial that I could
> > > take a look at.
> > >
> > > I ran this through mm self tests, allmodconfig + a bunch of other checks
> > > but ofc enabling rust was not one, I should probably update my scripts [0]
> > > to do that too :)
> > >
> > > Cheers, Lorenzo
> > >
> > > [0]:https://github.com/lorenzo-stoakes/review-scripts
> >
> > I can help convert the Rust bindings to work with this approach. I see
> > there is a nice and simple vma_test() method for checking a flag, but I
> > don't see any equivalent method for setting or unsetting a given bit.
> > What would be the best function for Rust to call to set or unset a given
> > bit in the vma flags?
> 
> Thanks much appreciated!
> 
> I was thinking of adding that in but have no C users currently, on respin
> can add.
> 
> If you give me a rough idea of what needs to be changed I can always try
> and wrap that into my respin?

You'll want something along these lines:

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 2e43c66635a2..04b75d4d01c3 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -108,7 +108,6 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRESENT = XA_PRESENT;
 
 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC = XA_FLAGS_ALLOC;
 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 = XA_FLAGS_ALLOC1;
-const vm_flags_t RUST_CONST_HELPER_VM_MERGEABLE = VM_MERGEABLE;
 
 #if IS_ENABLED(CONFIG_ANDROID_BINDER_IPC_RUST)
 #include "../../drivers/android/binder/rust_binder.h"
diff --git a/rust/helpers/mm.c b/rust/helpers/mm.c
index 81b510c96fd2..2aa0dcd98609 100644
--- a/rust/helpers/mm.c
+++ b/rust/helpers/mm.c
@@ -48,3 +48,18 @@ void rust_helper_vma_end_read(struct vm_area_struct *vma)
 {
 	vma_end_read(vma);
 }
+
+bool rust_helper_vma_test(const struct vm_area_struct *vma, vma_flag_t flag)
+{
+	return vma_test(vma, flag);
+}
+
+void rust_helper_vma_set(const struct vm_area_struct *vma, vma_flag_t flag)
+{
+	// TODO
+}
+
+void rust_helper_vma_unset(const struct vm_area_struct *vma, vma_flag_t flag)
+{
+	// TODO
+}
diff --git a/rust/kernel/mm/virt.rs b/rust/kernel/mm/virt.rs
index a1bfa4e19293..151a89bfc8f5 100644
--- a/rust/kernel/mm/virt.rs
+++ b/rust/kernel/mm/virt.rs
@@ -66,14 +66,12 @@ pub fn mm(&self) -> &MmWithUser {
         unsafe { MmWithUser::from_raw((*self.as_ptr()).vm_mm) }
     }
 
-    /// Returns the flags associated with the virtual memory area.
-    ///
-    /// The possible flags are a combination of the constants in [`flags`].
+    /// Returns the value of the given flag.
     #[inline]
-    pub fn flags(&self) -> vm_flags_t {
-        // SAFETY: By the type invariants, the caller holds at least the mmap read lock, so this
-        // access is not a data race.
-        unsafe { (*self.as_ptr()).__bindgen_anon_2.vm_flags }
+    pub fn flag(&self, flag: vma_flag_t) -> bool {
+        // SAFETY: By the type invariants, the caller holds at least the mmap read lock, so it is
+        // safe to read the flags.
+        unsafe { bindings::vma_test(self.as_ptr(), flag) }
     }
 
     /// Returns the (inclusive) start address of the virtual memory area.
@@ -128,16 +126,16 @@ pub fn zap_page_range_single(&self, address: usize, size: usize) {
         };
     }
 
-    /// If the [`VM_MIXEDMAP`] flag is set, returns a [`VmaMixedMap`] to this VMA, otherwise
+    /// If the [`VMA_MIXEDMAP`] flag is set, returns a [`VmaMixedMap`] to this VMA, otherwise
     /// returns `None`.
     ///
-    /// This can be used to access methods that require [`VM_MIXEDMAP`] to be set.
+    /// This can be used to access methods that require [`VMA_MIXEDMAP`] to be set.
     ///
-    /// [`VM_MIXEDMAP`]: flags::MIXEDMAP
+    /// [`VMA_MIXEDMAP`]: flags::MIXEDMAP
     #[inline]
     pub fn as_mixedmap_vma(&self) -> Option<&VmaMixedMap> {
-        if self.flags() & flags::MIXEDMAP != 0 {
-            // SAFETY: We just checked that `VM_MIXEDMAP` is set. All other requirements are
+        if self.flag(flags::MIXEDMAP) {
+            // SAFETY: We just checked that `VMA_MIXEDMAP` is set. All other requirements are
             // satisfied by the type invariants of `VmaRef`.
             Some(unsafe { VmaMixedMap::from_raw(self.as_ptr()) })
         } else {
@@ -146,19 +144,19 @@ pub fn as_mixedmap_vma(&self) -> Option<&VmaMixedMap> {
     }
 }
 
-/// A wrapper for the kernel's `struct vm_area_struct` with read access and [`VM_MIXEDMAP`] set.
+/// A wrapper for the kernel's `struct vm_area_struct` with read access and [`VMA_MIXEDMAP`] set.
 ///
 /// It represents an area of virtual memory.
 ///
 /// This struct is identical to [`VmaRef`] except that it must only be used when the
-/// [`VM_MIXEDMAP`] flag is set on the vma.
+/// [`VMA_MIXEDMAP`] flag is set on the vma.
 ///
 /// # Invariants
 ///
-/// The caller must hold the mmap read lock or the vma read lock. The `VM_MIXEDMAP` flag must be
+/// The caller must hold the mmap read lock or the vma read lock. The `VMA_MIXEDMAP` flag must be
 /// set.
 ///
-/// [`VM_MIXEDMAP`]: flags::MIXEDMAP
+/// [`VMA_MIXEDMAP`]: flags::MIXEDMAP
 #[repr(transparent)]
 pub struct VmaMixedMap {
     vma: VmaRef,
@@ -180,7 +178,7 @@ impl VmaMixedMap {
     /// # Safety
     ///
     /// Callers must ensure that `vma` is valid for the duration of 'a, and that the mmap read lock
-    /// (or stronger) is held for at least the duration of 'a. The `VM_MIXEDMAP` flag must be set.
+    /// (or stronger) is held for at least the duration of 'a. The `VMA_MIXEDMAP` flag must be set.
     #[inline]
     pub unsafe fn from_raw<'a>(vma: *const bindings::vm_area_struct) -> &'a Self {
         // SAFETY: The caller ensures that the invariants are satisfied for the duration of 'a.
@@ -193,7 +191,7 @@ pub unsafe fn from_raw<'a>(vma: *const bindings::vm_area_struct) -> &'a Self {
     #[inline]
     pub fn vm_insert_page(&self, address: usize, page: &Page) -> Result {
         // SAFETY: By the type invariant of `Self` caller has read access and has verified that
-        // `VM_MIXEDMAP` is set. By invariant on `Page` the page has order 0.
+        // `VMA_MIXEDMAP` is set. By invariant on `Page` the page has order 0.
         to_result(unsafe { bindings::vm_insert_page(self.as_ptr(), address, page.as_ptr()) })
     }
 }
@@ -236,237 +234,236 @@ pub unsafe fn from_raw<'a>(vma: *mut bindings::vm_area_struct) -> &'a Self {
         unsafe { &*vma.cast() }
     }
 
-    /// Internal method for updating the vma flags.
+    /// Internal method for setting a vma flag.
+    ///
+    /// # Safety
+    ///
+    /// This must not be used to set the flags to an invalid value.
+    #[inline]
+    unsafe fn set_flag(&self, flag: vma_flag_t) {
+        // SAFETY: Caller is not setting flags to an invalid value.
+        unsafe { bindings::vma_set(self.as_ptr(), flag) };
+    }
+
+    /// Internal method for unsetting a vma flag.
     ///
     /// # Safety
     ///
     /// This must not be used to set the flags to an invalid value.
     #[inline]
-    unsafe fn update_flags(&self, set: vm_flags_t, unset: vm_flags_t) {
-        let mut flags = self.flags();
-        flags |= set;
-        flags &= !unset;
-
-        // SAFETY: This is not a data race: the vma is undergoing initial setup, so it's not yet
-        // shared. Additionally, `VmaNew` is `!Sync`, so it cannot be used to write in parallel.
-        // The caller promises that this does not set the flags to an invalid value.
-        unsafe { (*self.as_ptr()).__bindgen_anon_2.__vm_flags = flags };
+    unsafe fn unset_flag(&self, flag: vma_flag_t) {
+        // SAFETY: Caller is not setting flags to an invalid value.
+        unsafe { bindings::vma_unset(self.as_ptr(), flag) };
     }
 
-    /// Set the `VM_MIXEDMAP` flag on this vma.
+    /// Set the `VMA_MIXEDMAP` flag on this vma.
     ///
     /// This enables the vma to contain both `struct page` and pure PFN pages. Returns a reference
     /// that can be used to call `vm_insert_page` on the vma.
     #[inline]
     pub fn set_mixedmap(&self) -> &VmaMixedMap {
-        // SAFETY: We don't yet provide a way to set VM_PFNMAP, so this cannot put the flags in an
+        // SAFETY: We don't yet provide a way to set VMA_PFNMAP, so this cannot put the flags in an
         // invalid state.
-        unsafe { self.update_flags(flags::MIXEDMAP, 0) };
+        unsafe { self.set_flag(flags::MIXEDMAP) };
 
-        // SAFETY: We just set `VM_MIXEDMAP` on the vma.
+        // SAFETY: We just set `VMA_MIXEDMAP` on the vma.
         unsafe { VmaMixedMap::from_raw(self.vma.as_ptr()) }
     }
 
-    /// Set the `VM_IO` flag on this vma.
+    /// Set the `VMA_IO` flag on this vma.
     ///
     /// This is used for memory mapped IO and similar. The flag tells other parts of the kernel to
     /// avoid looking at the pages. For memory mapped IO this is useful as accesses to the pages
     /// could have side effects.
     #[inline]
     pub fn set_io(&self) {
-        // SAFETY: Setting the VM_IO flag is always okay.
-        unsafe { self.update_flags(flags::IO, 0) };
+        // SAFETY: Setting the VMA_IO flag is always okay.
+        unsafe { self.set_flag(flags::IO) };
     }
 
-    /// Set the `VM_DONTEXPAND` flag on this vma.
+    /// Set the `VMA_DONTEXPAND` flag on this vma.
     ///
     /// This prevents the vma from being expanded with `mremap()`.
     #[inline]
     pub fn set_dontexpand(&self) {
-        // SAFETY: Setting the VM_DONTEXPAND flag is always okay.
-        unsafe { self.update_flags(flags::DONTEXPAND, 0) };
+        // SAFETY: Setting the VMA_DONTEXPAND flag is always okay.
+        unsafe { self.set_flag(flags::DONTEXPAND) };
     }
 
-    /// Set the `VM_DONTCOPY` flag on this vma.
+    /// Set the `VMA_DONTCOPY` flag on this vma.
     ///
-    /// This prevents the vma from being copied on fork. This option is only permanent if `VM_IO`
+    /// This prevents the vma from being copied on fork. This option is only permanent if `VMA_IO`
     /// is set.
     #[inline]
     pub fn set_dontcopy(&self) {
-        // SAFETY: Setting the VM_DONTCOPY flag is always okay.
-        unsafe { self.update_flags(flags::DONTCOPY, 0) };
+        // SAFETY: Setting the VMA_DONTCOPY flag is always okay.
+        unsafe { self.set_flag(flags::DONTCOPY) };
     }
 
-    /// Set the `VM_DONTDUMP` flag on this vma.
+    /// Set the `VMA_DONTDUMP` flag on this vma.
     ///
     /// This prevents the vma from being included in core dumps. This option is only permanent if
-    /// `VM_IO` is set.
+    /// `VMA_IO` is set.
     #[inline]
     pub fn set_dontdump(&self) {
-        // SAFETY: Setting the VM_DONTDUMP flag is always okay.
-        unsafe { self.update_flags(flags::DONTDUMP, 0) };
+        // SAFETY: Setting the VMA_DONTDUMP flag is always okay.
+        unsafe { self.set_flag(flags::DONTDUMP) };
     }
 
-    /// Returns whether `VM_READ` is set.
+    /// Returns whether `VMA_READ` is set.
     ///
     /// This flag indicates whether userspace is mapping this vma as readable.
     #[inline]
     pub fn readable(&self) -> bool {
-        (self.flags() & flags::READ) != 0
+        self.flag(flags::READ)
     }
 
-    /// Try to clear the `VM_MAYREAD` flag, failing if `VM_READ` is set.
+    /// Try to clear the `VMA_MAYREAD` flag, failing if `VMA_READ` is set.
     ///
     /// This flag indicates whether userspace is allowed to make this vma readable with
     /// `mprotect()`.
     ///
-    /// Note that this operation is irreversible. Once `VM_MAYREAD` has been cleared, it can never
+    /// Note that this operation is irreversible. Once `VMA_MAYREAD` has been cleared, it can never
     /// be set again.
     #[inline]
     pub fn try_clear_mayread(&self) -> Result {
         if self.readable() {
             return Err(EINVAL);
         }
-        // SAFETY: Clearing `VM_MAYREAD` is okay when `VM_READ` is not set.
-        unsafe { self.update_flags(0, flags::MAYREAD) };
+        // SAFETY: Clearing `VMA_MAYREAD` is okay when `VMA_READ` is not set.
+        unsafe { self.unset_flag(flags::MAYREAD) };
         Ok(())
     }
 
-    /// Returns whether `VM_WRITE` is set.
+    /// Returns whether `VMA_WRITE` is set.
     ///
     /// This flag indicates whether userspace is mapping this vma as writable.
     #[inline]
     pub fn writable(&self) -> bool {
-        (self.flags() & flags::WRITE) != 0
+        self.flag(flags::WRITE)
     }
 
-    /// Try to clear the `VM_MAYWRITE` flag, failing if `VM_WRITE` is set.
+    /// Try to clear the `VMA_MAYWRITE` flag, failing if `VMA_WRITE` is set.
     ///
     /// This flag indicates whether userspace is allowed to make this vma writable with
     /// `mprotect()`.
     ///
-    /// Note that this operation is irreversible. Once `VM_MAYWRITE` has been cleared, it can never
+    /// Note that this operation is irreversible. Once `VMA_MAYWRITE` has been cleared, it can never
     /// be set again.
     #[inline]
     pub fn try_clear_maywrite(&self) -> Result {
         if self.writable() {
             return Err(EINVAL);
         }
-        // SAFETY: Clearing `VM_MAYWRITE` is okay when `VM_WRITE` is not set.
-        unsafe { self.update_flags(0, flags::MAYWRITE) };
+        // SAFETY: Clearing `VMA_MAYWRITE` is okay when `VMA_WRITE` is not set.
+        unsafe { self.unset_flag(flags::MAYWRITE) };
         Ok(())
     }
 
-    /// Returns whether `VM_EXEC` is set.
+    /// Returns whether `VMA_EXEC` is set.
     ///
     /// This flag indicates whether userspace is mapping this vma as executable.
     #[inline]
     pub fn executable(&self) -> bool {
-        (self.flags() & flags::EXEC) != 0
+        self.flag(flags::EXEC)
     }
 
-    /// Try to clear the `VM_MAYEXEC` flag, failing if `VM_EXEC` is set.
+    /// Try to clear the `VMA_MAYEXEC` flag, failing if `VMA_EXEC` is set.
     ///
     /// This flag indicates whether userspace is allowed to make this vma executable with
     /// `mprotect()`.
     ///
-    /// Note that this operation is irreversible. Once `VM_MAYEXEC` has been cleared, it can never
+    /// Note that this operation is irreversible. Once `VMA_MAYEXEC` has been cleared, it can never
     /// be set again.
     #[inline]
     pub fn try_clear_mayexec(&self) -> Result {
         if self.executable() {
             return Err(EINVAL);
         }
-        // SAFETY: Clearing `VM_MAYEXEC` is okay when `VM_EXEC` is not set.
-        unsafe { self.update_flags(0, flags::MAYEXEC) };
+        // SAFETY: Clearing `VMA_MAYEXEC` is okay when `VMA_EXEC` is not set.
+        unsafe { self.unset_flag(flags::MAYEXEC) };
         Ok(())
     }
 }
 
 /// The integer type used for vma flags.
 #[doc(inline)]
-pub use bindings::vm_flags_t;
+pub use bindings::vma_flag_t;
 
 /// All possible flags for [`VmaRef`].
 pub mod flags {
-    use super::vm_flags_t;
+    use super::vma_flag_t;
     use crate::bindings;
 
-    /// No flags are set.
-    pub const NONE: vm_flags_t = bindings::VM_NONE as vm_flags_t;
-
     /// Mapping allows reads.
-    pub const READ: vm_flags_t = bindings::VM_READ as vm_flags_t;
+    pub const READ: vma_flag_t = bindings::VMA_READ_BIT as vma_flag_t;
 
     /// Mapping allows writes.
-    pub const WRITE: vm_flags_t = bindings::VM_WRITE as vm_flags_t;
+    pub const WRITE: vma_flag_t = bindings::VMA_WRITE_BIT as vma_flag_t;
 
     /// Mapping allows execution.
-    pub const EXEC: vm_flags_t = bindings::VM_EXEC as vm_flags_t;
+    pub const EXEC: vma_flag_t = bindings::VMA_EXEC_BIT as vma_flag_t;
 
     /// Mapping is shared.
-    pub const SHARED: vm_flags_t = bindings::VM_SHARED as vm_flags_t;
+    pub const SHARED: vma_flag_t = bindings::VMA_SHARED_BIT as vma_flag_t;
 
     /// Mapping may be updated to allow reads.
-    pub const MAYREAD: vm_flags_t = bindings::VM_MAYREAD as vm_flags_t;
+    pub const MAYREAD: vma_flag_t = bindings::VMA_MAYREAD_BIT as vma_flag_t;
 
     /// Mapping may be updated to allow writes.
-    pub const MAYWRITE: vm_flags_t = bindings::VM_MAYWRITE as vm_flags_t;
+    pub const MAYWRITE: vma_flag_t = bindings::VMA_MAYWRITE_BIT as vma_flag_t;
 
     /// Mapping may be updated to allow execution.
-    pub const MAYEXEC: vm_flags_t = bindings::VM_MAYEXEC as vm_flags_t;
+    pub const MAYEXEC: vma_flag_t = bindings::VMA_MAYEXEC_BIT as vma_flag_t;
 
     /// Mapping may be updated to be shared.
-    pub const MAYSHARE: vm_flags_t = bindings::VM_MAYSHARE as vm_flags_t;
+    pub const MAYSHARE: vma_flag_t = bindings::VMA_MAYSHARE_BIT as vma_flag_t;
 
     /// Page-ranges managed without `struct page`, just pure PFN.
-    pub const PFNMAP: vm_flags_t = bindings::VM_PFNMAP as vm_flags_t;
+    pub const PFNMAP: vma_flag_t = bindings::VMA_PFNMAP_BIT as vma_flag_t;
 
     /// Memory mapped I/O or similar.
-    pub const IO: vm_flags_t = bindings::VM_IO as vm_flags_t;
+    pub const IO: vma_flag_t = bindings::VMA_IO_BIT as vma_flag_t;
 
     /// Do not copy this vma on fork.
-    pub const DONTCOPY: vm_flags_t = bindings::VM_DONTCOPY as vm_flags_t;
+    pub const DONTCOPY: vma_flag_t = bindings::VMA_DONTCOPY_BIT as vma_flag_t;
 
     /// Cannot expand with mremap().
-    pub const DONTEXPAND: vm_flags_t = bindings::VM_DONTEXPAND as vm_flags_t;
+    pub const DONTEXPAND: vma_flag_t = bindings::VMA_DONTEXPAND_BIT as vma_flag_t;
 
     /// Lock the pages covered when they are faulted in.
-    pub const LOCKONFAULT: vm_flags_t = bindings::VM_LOCKONFAULT as vm_flags_t;
+    pub const LOCKONFAULT: vma_flag_t = bindings::VMA_LOCKONFAULT_BIT as vma_flag_t;
 
     /// Is a VM accounted object.
-    pub const ACCOUNT: vm_flags_t = bindings::VM_ACCOUNT as vm_flags_t;
+    pub const ACCOUNT: vma_flag_t = bindings::VMA_ACCOUNT_BIT as vma_flag_t;
 
     /// Should the VM suppress accounting.
-    pub const NORESERVE: vm_flags_t = bindings::VM_NORESERVE as vm_flags_t;
+    pub const NORESERVE: vma_flag_t = bindings::VMA_NORESERVE_BIT as vma_flag_t;
 
     /// Huge TLB Page VM.
-    pub const HUGETLB: vm_flags_t = bindings::VM_HUGETLB as vm_flags_t;
+    pub const HUGETLB: vma_flag_t = bindings::VMA_HUGETLB_BIT as vma_flag_t;
 
     /// Synchronous page faults. (DAX-specific)
-    pub const SYNC: vm_flags_t = bindings::VM_SYNC as vm_flags_t;
+    pub const SYNC: vma_flag_t = bindings::VMA_SYNC_BIT as vma_flag_t;
 
     /// Architecture-specific flag.
-    pub const ARCH_1: vm_flags_t = bindings::VM_ARCH_1 as vm_flags_t;
+    pub const ARCH_1: vma_flag_t = bindings::VMA_ARCH_1_BIT as vma_flag_t;
 
     /// Wipe VMA contents in child on fork.
-    pub const WIPEONFORK: vm_flags_t = bindings::VM_WIPEONFORK as vm_flags_t;
+    pub const WIPEONFORK: vma_flag_t = bindings::VMA_WIPEONFORK_BIT as vma_flag_t;
 
     /// Do not include in the core dump.
-    pub const DONTDUMP: vm_flags_t = bindings::VM_DONTDUMP as vm_flags_t;
+    pub const DONTDUMP: vma_flag_t = bindings::VMA_DONTDUMP_BIT as vma_flag_t;
-
-    /// Not soft dirty clean area.
-    pub const SOFTDIRTY: vm_flags_t = bindings::VM_SOFTDIRTY as vm_flags_t;
 
     /// Can contain `struct page` and pure PFN pages.
-    pub const MIXEDMAP: vm_flags_t = bindings::VM_MIXEDMAP as vm_flags_t;
+    pub const MIXEDMAP: vma_flag_t = bindings::VMA_MIXEDMAP_BIT as vma_flag_t;
 
     /// MADV_HUGEPAGE marked this vma.
-    pub const HUGEPAGE: vm_flags_t = bindings::VM_HUGEPAGE as vm_flags_t;
+    pub const HUGEPAGE: vma_flag_t = bindings::VMA_HUGEPAGE_BIT as vma_flag_t;
 
     /// MADV_NOHUGEPAGE marked this vma.
-    pub const NOHUGEPAGE: vm_flags_t = bindings::VM_NOHUGEPAGE as vm_flags_t;
+    pub const NOHUGEPAGE: vma_flag_t = bindings::VMA_NOHUGEPAGE_BIT as vma_flag_t;
 
     /// KSM may merge identical pages.
-    pub const MERGEABLE: vm_flags_t = bindings::VM_MERGEABLE as vm_flags_t;
+    pub const MERGEABLE: vma_flag_t = bindings::VMA_MERGEABLE_BIT as vma_flag_t;
 }

