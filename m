Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A549CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 23:47:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65CB66B0088; Wed, 20 May 2026 19:47:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6345F6B008A; Wed, 20 May 2026 19:47:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 571936B008C; Wed, 20 May 2026 19:47:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 465CC6B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 19:47:36 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D44031C0349
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:47:35 +0000 (UTC)
X-FDA: 84789437670.07.46CF7C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 53F9C4000C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:47:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GCfZVT5i;
	spf=pass (imf17.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779320854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=VqdUhxQRHfKc2fYQUeGieNHRoLL+vlXd4MzpyPnbOnc=;
	b=1EzxWqcxmpW4tEQgy4w6V6K7lcxO6weU5kZs+hGy0DNjpNw8zb+WhZ28MbK9Z1p/yW0jhs
	whhsSitmHQ1Hgdfwv3m2YumGQs3DNJXvzPlBRGAuHcBds0nVlUi6JD7bBmzRQPqNlVveWw
	Z5ztUEMLMWLIdYr6Wt/OPLAKoUHJacc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GCfZVT5i;
	spf=pass (imf17.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779320854; a=rsa-sha256;
	cv=none;
	b=xnRYO2A0sYo8QDrT3/Is/X7pztuZNgot98lRuMGJQdvikH9CgiCjBZLTJ8cuqjypIT0PuC
	xQPezspchK6NcyMLEP3Hw7WgDdO6b9x4b5913ubUwPpNcBBMH18Jtw+vYqhaqSSZxsINdM
	GK7VKb4oBUsE5zUC6pF6q78kT92s0Lk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5059441773;
	Wed, 20 May 2026 23:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2081F00A39;
	Wed, 20 May 2026 23:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779320853;
	bh=VqdUhxQRHfKc2fYQUeGieNHRoLL+vlXd4MzpyPnbOnc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=GCfZVT5iBwTSlw1drAnQSELAuPQwkctGKQNFw1NbcFq6SBdMsZGCLPhwT2W47gHks
	 cDXQGOfTuCpOFeWIDO5aHSNt+zM0B3R0wvRot5jCZ/VWwV1I/T2K/9dguvz+JcMQl0
	 pD2MNtdMF4ps/3nfkuzmYRGeAExG6A5+AAt3qYb27khyYGuWR3kNXstvWYD8PuOmlx
	 fE85ErDNWg1KohaQpt1/fKjNC/0QuK9kzppfpYd2lc2b8ifhganknb2H4Sw25SvlK4
	 x/5iCHiArTnGiXX97nQdiSJlkTYt1htEXl+YtLH8Ycnomv4wC7phNNQNTOLAl+IbQX
	 EqGjZ8xh7CPqQ==
Date: Wed, 20 May 2026 13:47:32 -1000
Message-ID: <eaeb316b7a45956ed5f335050e6e9538@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>
Cc: David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	sched-ext@lists.linux.dev,
	bpf@vger.kernel.org,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] sched_ext: Sub-allocator over kernel-claimed BPF arena pages
In-Reply-To: <DIM6W7GRZK2N.14AH43S1XTFCG@gmail.com>
References: <20260517211232.1670594-1-tj@kernel.org>
 <20260517211232.1670594-8-tj@kernel.org>
 <20260518072042.GP3102624@noisy.programming.kicks-ass.net>
 <agtt2dEjS4Qg7a_P@slm.duckdns.org>
 <DIM6W7GRZK2N.14AH43S1XTFCG@gmail.com>
X-Stat-Signature: amnhbz4s1mjm3huq8z6ao4d4iukm31tp
X-Rspamd-Queue-Id: 53F9C4000C
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779320854-473679
X-HE-Meta: U2FsdGVkX1+4/ra12Q3gRfXedqxISESguHYcB4cfIfesz2PFRWKKxYLP35M0FI6Yb4mJAbmlQrnq6l8Ip++UUUdanLC3BRnUczcr3nP8PE4pyRB+om03HU8aCVpHU1w2B/Pt2G/PJlN1Po9+N4+abVw3PBfAmq9gtFJeV9q+qVyY0ULaOJ5P1hyEiMUklSmAqZah4OIWfJNohJbgJjr+HMKofSQAljnK4iSTwN2j/k0KI7JV4BCmtwHRcgmcdhmUI2F3vJyQS865CrBWvCNtLPwsvqoubtHdhMmFO9x263Ppx8KcJCwttAwAob7Y4x0X/0j9kQ0FIhliVa02pd8OU1FKijVih0es6DM4pID1pJvdOwfSxpaMz3MMA5FIQO7p9E3MiONEYmI4h/Ic4+geZLLL8niniVAeltnFdAohxw+tG9GfOGhaimTZH1rSujbTwLbvUObgVh/TBfyENJCJsZhw7+tY0Vtt5NGgiMwAcc4XbHuf/AdVaw2o1wvOXBUkwV5iD7SJAkG5hm/O3ay39OZ6QKMmXrth7ihyQxqYDmMGSuhDCxSOYh2u31DHcx0OUMQa+NENo7+BeeUG6JrDSiqil8Umcej6U/kGPvyx3zYsjBU+3atDcBWt2w2i5YnncGRK7RqPf87/o/DFAWm6aIXvVO2szK8Z/gqXNrseBDWJSrSq3GMDDO+HhfvtcU3kYCUtLOFSiGvxY0+6+QQFbE4mwDcXEjESiDEqHeTyan2wVuc9IW1rZu5/paK3huPiNNV4c2lf1fp9I883C2FRA8n96shGACsa2NxUlMtnEFWIn8Nfn6EUMKeVXct6HSMzZuqol3GTa6ntbFLv+idnX31adpxb1Sq+Jm3AOW1YRYfZ9meIwXkuEESvLe9cSGqgKRCQH5zxrsoOMGdMu/VAdHSSTHWPRz7UjrrYBSmALB5jsmgZsxPslZEbImZ+ka5Xo2NOOExOhwJ+znorwXP
 slRQqKQG
 F2UYDB4tSk0at+LH3wP/w4GZfQTJoQOAB8/Rw8WXTbhUL2t1kzqE9ofeAcT5qTb5b3W31o/oQ5Ep2JtFf3dtdm5iQaorIGNTYHleUAlfa43OG0dGrMLoDGU0WEVyjSxu+SIKCzUi5Bxe1E0CHJXeoDJnSe8P6/mgVIIPFg0UrEYEPYUL+DYFGpwU3Oz53yHmprN9j/vWUX3wcPS85A1t97UY3mw+oTLy7YyPpN8eyKjIt6FptGTTY99DUzqmxfkWOVZgwshQm692J+rt3EsPW52hH/JS6dPUGzvfrNUuOBf3SHv3HfwMni6qa3duKoZOihlg5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Mon, May 18, 2026 at 04:26:11PM -0700, Alexei Starovoitov wrote:
> Well, this gen_pool based allocator of arena memory is a temporary hack.
> It's ok for rare allocation like in this at scx init time, but not suitable
> for active arena management. We don't need to expose it beyond scx.

I see. Peter, as Alexei is already prototyping a slab-based arena
allocator, how about keeping the gen_pool layer scx-local for now? Once
the proper allocator lands, scx can switch to it and the custom piece
goes away.

Thanks.

--
tejun

