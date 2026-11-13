Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E432606A32D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 20:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ksqi3hNT
Received: by kanga.kvack.org (Postfix)
	id 0E0BC6B05B5; Fri, 13 Nov 2026 15:17:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B7ED6B05B6; Fri, 13 Nov 2026 15:17:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE8AB6B05B7; Fri, 13 Nov 2026 15:17:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CB0BA6B05B5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:17:37 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C5461A0247
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:17:36 +0000 (UTC)
X-FDA: 85431206112.20.3C8D104
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 156F810000D
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:17:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ksqi3hNT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794601055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KMgyZIG0LH+AzucSoXIEUf07GbSesuvgObEN4MQKmJA=;
	b=6D9AolC1bmZjUMGP3d8OiP270dcKT++XRaWIMfQMoKQlT5WnxZJMMai1TuSVnXFHGkP5Wk
	PoTl7oOAoXwY6Z92HEajvPYaS58WrVyZuTkGvftvxz4swNJSraYjLAGAhWWQ+QeRm1AGmU
	EKO27/rQ64DCAO6AAVC07XzMbeT1JIg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ksqi3hNT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794601055;
	b=KRUs36dlj8g3sFiIy/aoxyrLzeXDf4T1dW2P11V6Z9lEZ2bUBHldlCFTdbnveyE8ktoRk1
	UJG1mU7iQAqR7NdbNlbRIJX75Et4k2OoHmSfp9MwAwosFBIOruCvJVvz7K7yaRDYXKBDlI
	wflQBoAOeZsTjvaChHw++ESi5YHLcis=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 661BB40348;
	Fri, 13 Nov 2026 20:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B491F000CC;
	Fri, 13 Nov 2026 20:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794601054;
	bh=KMgyZIG0LH+AzucSoXIEUf07GbSesuvgObEN4MQKmJA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ksqi3hNTqNIsecm151Mv4zSREdF6VM4gl6f8ebPK6i7vV0hrw+/+FObf1VxUFmbpi
	 umsaygAIzu3XejhtNSTV0Z/s9bDVREmw5UkYREtqjHCOhxGefLP550uo5bFjSYYT5d
	 Q0RmM9fQJBQozX73fsKKRg/23UmLZw9xYshKQzu+vaGI1ZzcXoUOkJhJFVkfp6q+N5
	 4B+2plORdoYB2HDLR7B9G7jOJSbByw0nX0iHmd+zM/JA6G82WuxemUZuEPUDpbLpTR
	 3a+r6bImtnlsekCk0Xxi4ulszOGd1FAkrN0DdrnW8h1cdSj62j0799TsuYtKnErrAF
	 vgJqz7bboW7MQ==
Date: Fri, 13 Nov 2026 20:17:22 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: sashiko-reviews@lists.linux.dev, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Yu-cheng Yu <yu-cheng.yu@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, Chris Mason <mason@kernel.org>, 
	linux-mm@kvack.org, Borislav Petkov <bp@alien8.de>, Mark Brown <broonie@kernel.org>, 
	Dennis Zhou <dennisszhou@gmail.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH 10/13] mm/migrate_device: refuse to migrate shadow stacks
Message-ID: <avdveCV9uW1zwXXd@gremlin>
References: <avYJ-CxBEpdO1Wmu@gremlin>
 <816E22E2-C7DD-4DD1-AAC9-F51F4D1ED71C@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <816E22E2-C7DD-4DD1-AAC9-F51F4D1ED71C@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 156F810000D
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: tei3pgdidwwxjmp3o583kts5xpu5cisr
X-HE-Tag: 1794601054-867790
X-HE-Meta: U2FsdGVkX1+vbFijmFELPU9Kyy4QXt5T9cAhzY1RlT2gFtIrSenOfIw69LwNgem4Eh/5yCWN++vIE4q5k+g1+sYrx3fhMOllIlOlaesG+889+TvVtRZyJTrfkaAFz66VTuJIaSacX4ptRKHeUKtAUt4L/3dpzVu2JkxsBKfIyBn6gXrR0UhbeA/Gb5ddgMK4E0de4RBO/f08rlIa4kh0abUaS1u+mk8j4ZVNubuY7m7gJhASH5hrcexTfaWXdyU5OsUkfiDOdAWWNyecH321qLmSMwKqMxfw1LFrbZ0/dOTYt7bmvbHT2ltCpy7fxlDQSlbROVD75KjA/wgZEgpyMEyRSXoyUuwZpBOF816kDcKbwEdCCD7JUq5bgSO/mseJ45b7tXbiZh2lu9J0Jch7xmhY6tyD7fMWSyqo7jjAlmFVQGMPQGqJj1cNY+SvVHMWKsVHCj74q9bvr7XzK7/XRCEjlLVTQBe8VIwIO3vBxotjQ77Z/o3udfsUohgmLZkjJFRAIn6RbAz2fzOFgTQVJNt5ZeeNQfMBNUIx/0LQjl4eY7V3D5zbRy8WS5TnIUKICH+wvzRWeq8/a1hBkvOozNeRIgs1fT0qNygi5mSrkHJW6yukzQp1RoQEoD+DUTZGHqj811d7oHWkpsL+yzUTaVEkLQ2Y9WL7NjcuhTBjfBGrRoQTECYpDfLBeoWT9JKM8EMLo+fAyvNJDIMBeSbT9X05t+46hIbfX3rnqUiZGbJUarNdHqErJMgMA+pbBLdLn/sf7035a8xnN9j/gHpYdhMfyM3s10DCtpPNXTR4On2cH/ReR1stkDZazMV7OKEY/fpr5oSZVlHIAbWRREfc4mdoQMw01q2lU/BNfn7LjaCTLGJ5ojAUtizqpXkEtMoJMmmc3H7iKtXWzMUCU+/2pmrVqs+BQVFCptf/yiBTt4cgmYnf6tvRJqQlnM4KxbgrXibNOg3bw+arkkGEfgM
 VZSgPS+e
 46//GH8mCsqL0p9gpR1HxYfmQ7TcQiKIDWdoDElLs/1hzB9QJbJggOZS92zQyhGWrO9+ftNsIrcrAPi/rLoNV1I96ez83TZyizUMZsC+GjzfuWIJ6ZK1b54DpZb/BHIFMEK0nGKEW/VjijBM22obKgmqtzyMjbpdus1PmdUi387Pb4DtgyiKNc3OVDSuuvoRjNmPpe7kPcXiOqgDLpjBXDdk6Rt0HtTqaQvL5JabAX2Whg6tYZQfvPcF0Y4yawrHzljMTZmKdouPgt6T5S07EnixtsgtXzezkDwEF9Sb0TkEOupmh/Ur531vZSUFN8FcQM/ZKGme+BO1Ga2X5zHw0BoQFyCxPeq7HpdeGIUKa8jLeEASwh4Yoa14EQCJAo/YsyweAINULY4KeKeqFM0cScGdlTvFDEGlVonj3EBfVY0/Wi4Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 02:53:44PM -0800, Roman Gushchin wrote:
> > On Nov 12, 2026, at 11:03 AM, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > ﻿+cc Roman
> >
> > Roman - see below - I was under the impression mm was not supposed to receive
> > 'unrelated to this patch but' reports? Did something change?
>
> Yes, sashiko started reporting pre-existing bugs again, but in a better way:
> strictly once (per bug)
> only for the first non-rfc version
> somewhat related to the proposed patch
> not more than 1-2 per patch
> not exposing security-sensitive stuff this way
>
> Obviously the goal here it to increase the chances for the problem to be fixed.
> It’s global, not mm-specific.

(Sorry only just saw this!)

Ah, I thought it was an mm opt-out.

In general they're spawning a lot of AI sloppers to go off and send ever
more fixes and causing ever longer days for us, it's quite a noticeable
impact unfortunately.

And often they're duplicative of already-sent fixes so you can see the
conundrum with this :)

So ideally we'd like a way to embargo these or have a maintainers-only view
of them etc. so we can figure out a way of reasonably getting to valid
cases.

--
Cheers, Lorenzo

