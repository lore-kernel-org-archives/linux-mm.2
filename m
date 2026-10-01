Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25E33CA5FCF
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 08:42:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67CF66B0088; Thu,  1 Oct 2026 04:42:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 633BC6B008A; Thu,  1 Oct 2026 04:42:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 544276B008C; Thu,  1 Oct 2026 04:42:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 302786B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 04:42:56 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 901BD12036D
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:42:55 +0000 (UTC)
X-FDA: 85273417110.09.0BDDDEB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id E2496160009
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:42:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gRf36Abp;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790844174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TnzQmvC3sunYN3GNXk1Foa5cJ0VirJG5aSp7n+hYENY=;
	b=sZZAIP6HVrA8Wq7bsc8m+29B5T97hd6DVJIt5j9KeYlhsOcGPxyoZzJaXzydf/zobw2LIg
	M6CCURkutWSErRhE4eRFidCO7ESaLAMC4ka2TWkXIx3NUVCf52AfTHazhaZCOqbQTv9HlP
	Z5JO8p/0Ock87oDJiWF0sCNybOFkWSs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gRf36Abp;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790844174;
	b=j2hsiirGjgkA+M8VetdQLjPMoV8EbhSq5aGf9/z8MznNJH8tUnGt7Mg7zYiCqBdZLOght1
	/VtBeg3677ViAVAjzjpM5w4UY8JiEJB4vE5TMBi9BFprfOU+uW73RIgVHdmrjRwduBOsDw
	sIB3SUZ0gyvsw5sxz58C0bELWnMCGjw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC07643E62;
	Thu,  1 Oct 2026 08:42:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A82A1F000FF;
	Thu,  1 Oct 2026 08:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790844172;
	bh=TnzQmvC3sunYN3GNXk1Foa5cJ0VirJG5aSp7n+hYENY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gRf36AbpG/tNmQziL1i7biGBsDrpNwePS1Hc7bPUNXRDlTe3JSL7h4VZXHkc5TyEK
	 /LsnOg34Y7B6NJ7Utc36TMCrNNJ1IuFksJEww5Np8KSmDpMzXijdqOGzdBlV5JFoej
	 UMJkCwMeXRkpF0Nj/QP/dbokZ9eFfYuu/3WJwWBwsdni72HmYC+TO7m3ofNPXvO5c+
	 XBaIlWGwN6T63hTPLEDp0qi02TKmljR+MmaHpPRcd3kqFtJ9y5Ru7GuFI2pf8OH0Da
	 itxDrLPVB9H0NKre8mVDdg3f8loxIEv5w19+TIXuUG+6eTu2yJcVnA+yQxqi+3BPJZ
	 OiasMCzsukuIw==
Date: Thu, 1 Oct 2026 09:42:44 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Hajime Tazaki <thehajime@gmail.com>, linux-mm@kvack.org, 
	liam@infradead.org, rbm@suse.com, akpm@linux-foundation.org, luto@amacapital.net, 
	brendan.jackman@linux.dev, liuhangbin@gmail.com, corbet@lwn.net, kees@kernel.org, 
	broonie@kernel.org, mhocko@suse.com, rppt@kernel.org, shuah@kernel.org, 
	surenb@google.com, vbabka@kernel.org, wad@chromium.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-um@lists.infradead.org, geert@linux-m68k.org, 
	daniel@thingy.jp
Subject: Re: [PATCH v4 1/2] selftests: run tests on nommu architecture
Message-ID: <ar4br2vW7yZGd3gt@gremlin>
References: <20260929235711.2287931-1-thehajime@gmail.com>
 <20260929235711.2287931-2-thehajime@gmail.com>
 <bda5eeaa-7868-4d4a-9026-9e99347afd7c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bda5eeaa-7868-4d4a-9026-9e99347afd7c@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E2496160009
X-Stat-Signature: xxryjwm69iaeir5bu34g5htdxkuj3bof
X-Rspam-User: 
X-HE-Tag: 1790844173-388720
X-HE-Meta: U2FsdGVkX191TDJ2R5Rej6DERtEB2N9xxRbDSBZe/g1gKoiRM4bGX0glskBA+dLE9PHgB6o1ZJnRIwY7dCgnOTOlcFgk/EKy0NuAEd3Zv2Y5ELQunidOi3d4nT03xjOmsrcILYgfeqXwChurmghJtv8oQbZ3ko2r1WdYY2cCizmpyb00m5WU50oN7Rl9KicnWTA4aVEe7yt4e53pXlPSwMcwdDHvlHBYXXGwp44lb3bCLQQYGf4/dtcBAX8QmzgFFPvkPuU2gsmNNCqZVTK666BwhM+4Iak7vbLCLsnyVgwbAyS2mpn4EWWbOh2dLYxHDTzagjeKOtMVSxs7UXKGRHv7Oa9MpuvDd+HD0ab1s/IL2ayIwO/kodBAloXTK5CEGTPrsnlM18rANe13ITsSVEb/TYO+BrP3l0fVtwkQzY6CUNX3CIPzL89hIIP2dBehjZrAFh9z1dtIaYGCbf4Fhi+d4t9pqcrXB3Lcd8uQzQQt11zkdVMpBy3q8yMjTyO7K34VL0V8U97ytXoewHuja0qdqWqPzSQG/UZeutURbCaVqgkPPoGJmcX/A1loObR5fIsNoNd6HQHgEDaGp1tpmvScGYenrZJ85CpJRxphNKGLKgUhyqnVY+qOy7SrdCn4whSeMvd3O87fnJLfhpGSXZx5tqlbkmu7OMwj0CRfRjhnLSgwZuPTR0ANvpT+ZkbasDBMXbYX4qmRuW6TMQ9sny3yA604r51+sQeLdTa5SieOOuP81VQQcNNa43KRUL7OzzqGMmIlds8uh4V07KqweSURO3WhFMLHrKFXtqSi3AvjV0PNn0+TdeoaHQe2NKheK9CwZ6ORCX5qTy+fuACAP6+lTjkL2ci7ncX9YASVeJce3y70/DA3isLTcg6p/lD5/WwxPrur42vJFKUKAtGM+SouF5vmZUVIoBAeX2gKGD8X1AGyavd7+xlp9bgYmPmY//g4cBlrTn19afXj9Gx
 0lLgBGLG
 4MB6cV6miOLXfQ/JfPpBV+Dz7BNWLPNaPe9o/fzUy+cDNwDbF5hLOLM1YtuZ7MOAZGDvDbnTeUMfHWsgH0SxnVyquz8yNWFOq9kEkmyOrsRAaMvkn8ddDssbDuaRmGl4qSX2numiKDEFRSJnvHzsGAjzz8KkBoIbN1GiLQ/JfK7pAQQCn6ZGmVrr6WymY4G5Xbnz1rBX2U8MS4J2/pmvp799LsaCdsGD+7WfQJWZhOhefDTykkLO2/iPq6qoEGBRnb65/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 01, 2026 at 09:08:33AM +0200, David Hildenbrand (Arm) wrote:
> On 9/30/26 01:57, Hajime Tazaki wrote:
> > Architectures lacking MMU don't support fork(2) syscall and only
> > vfork(2) is available with limitations.  Thus, we cannot run kselftest
> > on nommu architecture as is.
> >
> > This commit addresses this issue with the following changes:
> >
> > - on test run stage, avoid calling timeout command when NOMMU=1 variable
> >   added to environmental variable, since timeout command uses fork
> >   syscall which nommu platform doesn't support.
> > - describe the difference of nommu tests in the document.
> >
> > So command line to build/execute tests for nommu should be like below:
> >
> >  $ make ARCH=um NOMMU=1 O=build kselftest-all TARGETS=nommu
> >  $ make ARCH=um NOMMU=1 O=build kselftest-install TARGETS=nommu
> >  $ NOMMU=1 ./build/kselftest/kselftest_install/run_kselftest.sh -p \
> >    -c nommu
>
> Is there a way we could derive that from the environment in one of these cases?

I thought maybe uname could help but our LLM overlords tell me no.

It pointed at something though.

In fs/proc/meminfo.c:

#ifndef CONFIG_MMU
	show_val_kb(m, "MmapCopy:       ",
		    (unsigned long)atomic_long_read(&mmap_pages_allocated));
#endif

So MmapCopy in /proc/meminfo tells us definitively, weirdly enough.

Therefore you could have:

function is_nommu()
{
	grep -q "^MmapCopy:" /proc/meminfo
}

if is_nommu; then
	...
fi

>
> I'd assume once could compile and run the nommu um variant, and within there
> simply build the selftests and run them?

Yeah be nice to have something that made it easy.

I'm quite excited about nommu uml in general for the purposes of easily testing
nommu stuff!

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

