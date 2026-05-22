Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7A26CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:42:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59AE26B00C7; Fri, 22 May 2026 11:42:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54AB86B00C8; Fri, 22 May 2026 11:42:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 439436B00C9; Fri, 22 May 2026 11:42:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2CA036B00C7
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:42:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EB2B01C08DE
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:42:45 +0000 (UTC)
X-FDA: 84795473490.11.63DAF50
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4DE1A2000C
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:42:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fevBbZWW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779464564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JCpY0JkuhcYxNLRV1IUbXIozIjXdostYdAAnrNS61cE=;
	b=hTwAO5f6kZ/nKjwoY0Xy9mP0T9fJ2djjPJpx98sDEbhyqhLKix7XEgA3+nkPBg7soV7tQH
	4DVs0SLGDQmKpJK6jWJp4NuZDQLZThZJkCqTBmbzjanIJ4Po4cyIyZcOU7RzJlhUd1QZ5e
	KYljihw7IqKc/tEXZq91e8GJsK0VgmA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fevBbZWW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779464564; a=rsa-sha256;
	cv=none;
	b=lrKArz3hrRIo/optFcbfccfuldD7bP3DROZiv1oUHA4jpfKP/jpGbetoWu9XlTNdGKQ375
	ex0tlPlZOP7ENrGnrAyAfWVsuKmV+OnBcneUtuZtHHw2udPddGa4QC/jgcToSsXUruAtGD
	n+q05T59d/1Jl3AOcXgxpwVvklVqfds=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CECB060138;
	Fri, 22 May 2026 15:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E9D1F000E9;
	Fri, 22 May 2026 15:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779464563;
	bh=JCpY0JkuhcYxNLRV1IUbXIozIjXdostYdAAnrNS61cE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fevBbZWW+amNTaTyKMVEGcATHJGI5beCyHSrNicjKpiIEwqwkPh/z0cIoe3sMBOEF
	 9KpGqhtEFq0bU7LJzRPro+xlky95JCucz80W5KK1l7KFP6+a4UbvOddg/RjiUMRrBc
	 TnJmst4YvoB1b0exji4XGaiDzIYHqxZdQizL+lY9YRCXPqsiUNa4Iwizpjdil6w8kp
	 avB7IiJOReUiZACrj/lPByfzfPgo+MU9KSfdz4bAzD5EbUs+mS2HRvW6EaIzmE8J07
	 jvv3I3rp4Q5xcvMk2ehvO5RHd+1nyNoGg6Bez7jfcnci4AcbssWI275h4ttA7+QWrP
	 1r5bMWvNKzJAA==
Date: Fri, 22 May 2026 16:42:34 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Barry Song <baohua@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, 
	bhe@redhat.com, chentao@kylinos.cn, chrisl@kernel.org, david@kernel.org, 
	jack@suse.cz, kasong@tencent.com, kunwu.chan@gmail.com, liam@infradead.org, 
	lianux.mm@gmail.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, liyangouwen1@oppo.com, 
	loongarch@lists.linux.dev, mhocko@suse.com, nphamcs@gmail.com, nzzhao@126.com, 
	pfalcato@suse.de, rppt@kernel.org, shikemeng@huaweicloud.com, surenb@google.com, 
	vbabka@kernel.org, wanglian@kylinos.cn, youngjun.park@lge.com
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
Message-ID: <ahB4_m6H37K7kDdO@lucifer>
References: <ag4kj84EcKqamdB-@casper.infradead.org>
 <20260522023305.98223-1-baohua@kernel.org>
 <ahBVh4NM2uoyhPNm@casper.infradead.org>
 <CAGsJ_4zQuJx1reJxgV387Gh0AqWF0KdoFn9KahQ1BNLPRm57TQ@mail.gmail.com>
 <CAGsJ_4zrm3sCp8Uz0Gh+sAwRcdtNF8rDLqX250sFVG3rZy9HNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4zrm3sCp8Uz0Gh+sAwRcdtNF8rDLqX250sFVG3rZy9HNw@mail.gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4DE1A2000C
X-Stat-Signature: fuigzgzfc4xg9dcy8wkcemrpfbbuhfuy
X-Rspam-User: 
X-HE-Tag: 1779464564-317707
X-HE-Meta: U2FsdGVkX18ytVrYkXNKsNEgggfmONfo0QNZvP3vdHEdklimzhJRxpKJXF0QjVgKUzhK2fIJLX4hcEPIRF7c7lpFmEEGXQ67YQS6SnqCBRo+FAuD+xINIVLsqE4Tu56gRyom6Ga4hSo2SgQbN9zyl5Te6/EvIPq8/Zo8I3I0yVMnUS2L4t+OFLiqSl+vokFYBBXDuTmms22cgsxg0X8LMkgbW87VUaBQiTgW4codrCQAP2RekhMx80a/MZLliFUI7rMPO/2iMh8uwvhxbiGE66t0EYLZlT48NCygJvhnlPEC6EZCdMMmgGuwy4agUb6HmyCHDLwKkP0Y5DEMPlJp1BlnlMRO5nga2+Lkqf12fBXhDflqWxlgpVc3gpKenqffy9Nq+l4+jPqmdDte5QoM6jqS76lAYUARYhDUHn7CT6nHd7dkRsME7tqKr1S5ZYz0gfqxKv85kUoh8IFA0ht4K3diMzqLsuizDbZjYl0rVhn1ECMn6DKKOnJ3icZ5S751WQltHoFPhtCf3yJNX8L4d/bevutr57nXLWYXNUPJ3h8H1rzeN2KnzBlOxMl0KBysfe8GF5y5dvR4yjuSUMsoAunJHBOFd0Ggu8/UdDesEHTXzGtD6MIowcmM4y8tECjrK3xIlDRpZZZ8fbi0fc+0/muqCuDTqJrjfDVLohr7uaWolAMTzyeRy26iWkE4UQV9aPT8qtdRpUAZlN7ry8JCXILm5Voy4dLars6CsvFCiU3WYSDe/VKoj3R3jzP7sKsVpxSDlgpu9Mnb6qRqxaEuANINBY/tQBPKXHWw1x2NGiOEUvp2GwjjHzirKntcfy+wxTVsVvILd05sNBXkLi+lhy9ENUiyQe19FgxpTOWSw4N14CimpSK4q7oQAgKmOhgjLooFqu7AWhDk5Qc5oWZsYkabVs8SDAZSgYVoCxAI1jE9iaOLbEqqigvb00yV3rGOAOk20GVFNAhXl1Xg0zT
 6AJN9lGC
 F+woYv+dc/eghd2axX5LhUZmPm1tg7bRuUlP8BPzKjhXPimsoQ0ryJ44iA8YfwTIjGczofTrPEMHMMXCLkQB1LujaRNkr0cI4vALMuu+tFrP8/rZs78iASdGgnBBjnqh2UxzeIda96OdjI8OnQIKT8JMduyZGjCbkbBE+/SQyXo+GbF+OvOgOOt47jg2VrhZOvns3aNX6TCBb7zH7h6x+ciuiukDqI+4CoJhpnMsc7yf1PTkx0MDGNwKgJvPrjO1eFJtLTas9+NToWkMhcEpAo6VoXwsGjJUFXZFBgyqOHUNpqYHxwlN6LPEW2Wy+SPI9sbO2bW/75n28rw7QJQ5krrdU1awpDH8T+SJiyWO/t8bq0R45uIJoHtxvGnF00RGLenFyaS1XIwNDVC6UvQEOuH4zZou1gkKFM6HCbrXDr87NUBmZRs55z587mrX8uyaVca7mEGbqhUWuTH+6Fqc5BcwHml5GbwxkL07m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 09:48:35PM +0800, Barry Song wrote:
> On Fri, May 22, 2026 at 9:36 PM Barry Song <baohua@kernel.org> wrote:
> >
> > On Fri, May 22, 2026 at 9:09 PM Matthew Wilcox <willy@infradead.org> wrote:
> > >
> > > On Fri, May 22, 2026 at 10:33:05AM +0800, Barry Song (Xiaomi) wrote:
> > > > need to touch `filemap.c` at all (probably because you are already
> > > > maintaining `filemap.c` perfectly):
> > >
> > > I'm going to give you one chance to apologise for that.
> >
> > Apologies if my wording caused any misunderstanding.
> > That was not my intention at all.
> >
> > What I meant is that filemap.c already has a very
> > solid design.
> >
> > For memory.c, I had to touch several places for the
> > blacklist; otherwise, the kernel would hang.
> >
> > But for filemap.c, I basically didn't need to touch
> > anything, and preliminary testing shows no issues after
> > moving it from the whitelist to the blacklist. This is
>
> Sorry, I feel I may be causing some misunderstanding
> again.
>
> By "whitelist", I mean I used to allow certain cases
> to use per-vma retry.
>
> By "blacklist", I mean I am now moving to disallow
> certain cases from using per-vma retry.
>
> Right now, I have to add several cases in memory.c
> to the blacklist; otherwise, the kernel would hang.
>
> But it seems that everything in filemap.c is fine so
> far based on testing.
>
> I'm not sure if I've explained things clearly. Please
> let me know if anything is still unclear or insufficient.

Barry - this thread is completely out of hand and getting _rapidly_
unproductive.

It's certainly about as clear as mud where we stand right now, so here's my
suggestion - let's just stop adding to the noise here :) and instead, you
take the approach suggested by Suren at LSF and send that as an _RFC_
series.

That way we can look at that and hopefully actually circle in on a solution
rather than have endless sub threads and sub discussions :) It's far too
sunny out in the UK right now for that ;)

Thanks, Lorenzo

