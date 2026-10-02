Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB934CA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 10:09:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6EF46B009B; Fri,  2 Oct 2026 06:09:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2E846B009D; Fri,  2 Oct 2026 06:09:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B43B16B009E; Fri,  2 Oct 2026 06:09:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 96B546B009B
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 06:09:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2B2B31A062C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 10:09:41 +0000 (UTC)
X-FDA: 85277264562.30.598C797
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 96CC6C0005
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 10:09:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YhVvlZIm;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790935779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kTIjevvHnI6tk3I7bdraP1aqxwTnNibc6cViojCA4r0=;
	b=dYdOomUn0ufhnuiFaDSQPLZPUqyGguQCVDCFksLoXT+sBdNMQes74xqDVUyYLdclw0Bqqk
	eoN9cYTQuA27MYCQGa0++hMenQ5QpsfakSmVLV4o+hraLshm5eLaBxUQugDbhCAh8o6Dgp
	6Sm9xDPeSirBUYg4L8JHHUTfDd1tnB8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YhVvlZIm;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790935779;
	b=2P2xNVYzUDQ2dJuUBJ0X+WPnDkDRkEVq16tloQMIgzk8XCears+PawRuZ69VK28pg4stzI
	/fLeEqp54Y2I8mebBxbKl2KYOEqgx/LaeT4GHsMXWZ6Bdhvl6xaoQPu94Pyv7wgpLlbMf8
	9E6LDkQRkjyf0SNiVKpz3f6xYnMCqY0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 25B6860A89;
	Fri,  2 Oct 2026 10:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85DA1F000FF;
	Fri,  2 Oct 2026 10:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790935778;
	bh=kTIjevvHnI6tk3I7bdraP1aqxwTnNibc6cViojCA4r0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YhVvlZImIxqbuB1Yq+sA//Rjnrhz17zbePIJ3Hk12l5kR818rurMHr0iK1fKiEIN4
	 +3SC+5eCeFgnA5mccvC/WsywRCPcTINbKsGABNrWkQmRL5z816D6nk3pVcta6jXMKD
	 kQqL/rJZ1VIVxJl1oLK+V5U4VJOe1Q5W4ZfPCD/ppDm1g3oYiCeomoXB2l7zGoktNW
	 ATyLovjbAJmTGV4MiVzlVezyw/JrrU1QS2iOvBeque3nEnazbzCiiupN2T8NI3D0TY
	 dpvEcpS/8dYMSr00RAL3b3PfrnQu1MrTRMtgUXjUBfXaOvZfMAAHxuY+/VQgpJS6kX
	 NurVf28Zra+Ag==
Date: Fri, 2 Oct 2026 11:09:33 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>, 
	akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, peterx@redhat.com, dave.hansen@linux.intel.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+49b1021becba70c1f3f6@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm: don't ioremap COWed anon pages in
 generic_access_phys()
Message-ID: <ar-Cq0YNpQ6_3fDG@gremlin>
References: <699ae98c.050a0220.340abe.0d31.GAE@google.com>
 <20261001152524.171115-1-ngocthang2710.1999@gmail.com>
 <32fe40e2-854a-47ec-9d95-93e23f9a7af4@kernel.org>
 <ar9omYD3HcTDBpGA@gremlin>
 <c6253814-0cf6-48f3-8f81-3285466dca45@kernel.org>
 <9d43234f-93cb-4c86-a2a6-a3cdebf48f3b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d43234f-93cb-4c86-a2a6-a3cdebf48f3b@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 96CC6C0005
X-Rspam-User: 
X-Stat-Signature: tn8zcryo1ah6rgcuqgraxma3rz96bas8
X-HE-Tag: 1790935779-494038
X-HE-Meta: U2FsdGVkX1/misU83mcD9M45LdDtluBSObqhYorwZZN9XEw9NOpqcX2UpEwSgLHB9P3sdUgsv/lFs/GPXsH7RGEkc9p+gxD40+Cd1dgQwYvhzj1Cn3pKNDeOXTdMwKeLNZoCPgeEHF9e+AgqjenSZl/m6uTZ795EpQfMwcS5ThOKRO1mPtp6FZIzyRx53MPOAHBkmHGOjdH2w1t21qnl0m0ZqpOxZhRjm6Kx9LWlEuVPgKTTobBmTcm7yb7kveUCnyolw+OjdLk68D/1cV7q7NiZ3jXV3OBgE7t/WOpr3YLZV+MMsCrm4BgUHjOkDuwWZHwBmej+f9hXzwd7KBBBFM/yKGGlcp4v6ohqNRbVHCh4cE7NAN6AYG+DflQln0J5+EfzlsCQdBIvSMaJxWEU0Qf3LAVUnaJQ0xk0IN4lZ5yIrCG3/Js8YVG1n7mrr29YB5STGUAyOYifVJRn6NAWU6qnhxkHCgNpgt4AMQmZPKTBOJESyyXeO3GjfJxIlGXZ6rMb8uhu7MIdvtn4rPa/6AqT5Kl89XtNMq0l7bTgb55usUUzrHMZyduPKVgpuLIS+Je1tMdtwHg7zkzVW+a/ehOAiAS57OAkf93Wa5Usiky5ev1BVRCZH6qX8/pFtvu7JG4MJvbtNaaVmyS7YWT7DaEYDLx46yzJc3AOxinpfn+vFMZEkOlBBwlpv5lGb1fimUoE0ZhG53xxrTG8ivgaFWC0Hi2a/p77cBh94W27Hkd0+iB4ypKPr9pr52vKFB2Qg/EMwXlQMtRLtATDc97eeyF0QZ7j3dCXPy2eRq+nmXj3EbmaUrlkblUrGXeQoJLKd9unMolrdn9nlLpGmw3JlDAeVbm5q7xe2sh2Xe9OOmoETw1G7Fsiyxwif6pgiWcpfahVd7qFsLAxYHO3vesJqh3rSlCYyd/g45IVuv6Fjyd0X32CcTSdfiNMI/Ru1FILvZy5E4tdC4k3xWdy4ZN
 CZmgAmPW
 1hvyJ0ISf58WFcbrfLhGyVvzREFyR1DKXjLuuhTpIkxN8wnumuTf5nciMqi1LcqsST+LJ0Z6GwOizpCmEN4G+YCowQwPTrXe2gz3P5uV93bSoedSjzZJKIrd1X67hGZKGXYjQODx6LkTCYe4R11gQMe3cJz7hhFpPjrZ25qlxnUe4sNHm0K4kMB/2alzyqS7AnqJVR/jgu2w8dlNKfgAr7zMLiOJTFEMcmiUINyI9tuLjeRQlKzh/BIxxl+krJ2ZaNKK47QmnNvR/Jbs3hVDWqn2P40nGmbRKzkCsTqpF2YUxIO19Hy55L4nD5e2QZ8gHI2u9c5cCSvHgjLJH1IgbjYLPncqdk29W8Xu9o9FUcg7KEopzG0D5Rbqmf2FYgWljdYiHL+3T7v9nQvHuf79f7YmlyRWqmzhia6Up1wqSks4JULal2KU5TGhmMpYrDMj6A3Wa93Yi6BdRarZ5sXTZj19h8PK+Aa+ppRuz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 12:04:27PM +0200, David Hildenbrand (Arm) wrote:
> On 10/2/26 12:02, David Hildenbrand (Arm) wrote:
> > On 10/2/26 10:38, Lorenzo Stoakes (ARM) wrote:
> >> On Thu, Oct 01, 2026 at 10:22:29PM +0200, David Hildenbrand (Arm) wrote:
> >>>
> >>
> >> Sorry to say this looks schlopped.
> >>
> >> This guy has sent 10 series across 6 subsystems over ~21 hrs:
> >>
> >> https://lore.kernel.org/all/?q=f%3Angocthang2710.1999%40gmail.com
> >>
> >> Nguyen - please do not flood the kernel with patches, and please use the
> >> Assisted-by tag for generated content.
> >>
> >> The original code you submitted is really not great even if the issue may
> >> be valid.
> >>
> >> So I'd say somebody from the core team should take over this if we want to
> >> come up with a patch.
> >
> > Yes, I'll take care of it.
> >
> > [...]
> >>>
> >>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> >>
> >> This looks reasonable but I hate that we have 'special' CoW overrides like
> >> this :)
> >
> > After sending this yesterday, I concluded that we can do this cleaner: just have
> >
> > bool normal_page;
> >
> > (naming suggestions?)
> >
> > that express that this is something refcounted with a struct page, like
> > documented for vm_normal_page().
>
> Hmm, have to think about that once more, regarding VM_IO and if there are some
> cases that would actually have to work in generic_access_phys().

Well, my series at least makes it easier to reason about VMA_IO_BIT!

Though not sure if it really touches PFN map cases specifically.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

