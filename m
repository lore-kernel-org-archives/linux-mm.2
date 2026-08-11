Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E9B7C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:12:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75AF16B0098; Tue, 11 Aug 2026 12:12:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E6096B0099; Tue, 11 Aug 2026 12:12:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D3B06B009B; Tue, 11 Aug 2026 12:12:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 379396B0098
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:12:13 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C07591403E4
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:12:12 +0000 (UTC)
X-FDA: 85089480504.19.DC965AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0F19D80002
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:12:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M9DrDGuc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786464731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HSnn0MPq99CU28zO6gTTV6eheUqywHGvJpVNl3p+JTs=;
	b=Okyup5SIEVKDCWFTFkz4ZY3dPj1k9d3TBDf48rKpVAVcq9Tc81jyJGM7aHIdBHyODC8jvl
	AxDx40spPGyG4Dg2RDTGX+qnleFCD1s9coulv14bhJlnjwqVoyTXZIOsHzHRXDkOgx/Ltv
	H4TKaUN4MaNchQ5cgscuHjQIGZsopas=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M9DrDGuc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786464731;
	b=tQyTaaFp6pLRvxErIjcYr5nAk+/DeP1NpmSxFCY6YVumhWB8zp9Krne/c4bfjLijbls9TK
	sR7/OtZ/NdVSby1+P/xd5LGRELYj8Q0WS/3JhOUxNxo8+qATkcupj2XcBKLTRiamEDqUx+
	eLEQIrRG1iGCAyDYBaYZ9wLfq8f5Nb4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E0A640963;
	Tue, 11 Aug 2026 16:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2521F000E9;
	Tue, 11 Aug 2026 16:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786464730;
	bh=HSnn0MPq99CU28zO6gTTV6eheUqywHGvJpVNl3p+JTs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M9DrDGuctQ3D4NFi1sRnvhYyHUuTquH8FssbntfsOz39lghpKYh7FYhIaMrtGrmwV
	 Zr4IGlf6rkAopoSS7A39kWT+VW2koRi6zdM9Bjv/JYQLyIjpimuNoZQ8PBeNFFo6P9
	 ZLeOfGUVv0nyzf8BYRmgrEhZx1JProqnsI5HrfOj4ihEquUmzeDsLSg+upLjPtBkcn
	 faQRbzEEvcSR88UnmlUb/JGjA6Bahy+Ag3C8v10Zuo/CTNlGNI0Ab8Jzemo343bGL6
	 F7X8SbET+YyvyrqfoSxzmiAQElKpCUgbSy1N9XSoR60mTSq3RlIRmb/ZIssFg3i6hX
	 JchMW4c9RZTzg==
Date: Tue, 11 Aug 2026 17:12:05 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: vova tokarev <vladimirelitokarev@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Pedro Falcato <pfalcato@suse.de>, akpm@linux-foundation.org, 
	security@kernel.org, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: Fwd: BadBunny: UFFDIO_COPY shmem killpriv bypass leading to
 local privilege escalation
Message-ID: <antHw-EHZL1erVTH@gremlin>
References: <CAGBKPgOm8q-8_rwyRPEmSj8JXdh_GaK1Q8vpJ=j-+yA0SgcNQw@mail.gmail.com>
 <CAGBKPgPPALX_5CQJAKUNjwi2fD28pBeS5pRuwQgePU93pOy8EA@mail.gmail.com>
 <anXnHMInq_JLYbWc@pedro-suse.lan>
 <CAGBKPgOfbMJruqcegJca6BBpEtpd91s5ASF_VU+gucWsjwp8WA@mail.gmail.com>
 <ancYCBUT8aB0qHwz@pedro-suse.lan>
 <anlOGOmO1HWVCMdF@casper.infradead.org>
 <20260811-knieprobleme-holten-palmen-4d42742b1962@brauner>
 <CAGBKPgPanzn8WuHK1hm44FLCXwJcnk7W=J6b17D9UzScWW7SJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGBKPgPanzn8WuHK1hm44FLCXwJcnk7W=J6b17D9UzScWW7SJQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 0F19D80002
X-Rspamd-Server: rspam07
X-Stat-Signature: 5i5m67jy4fy5pw4nwrmtgji63j4t64ie
X-HE-Tag: 1786464730-92703
X-HE-Meta: U2FsdGVkX18vg5UGvjCJsWjsplgaIp4sYRxftvKm6Ct406m1s2kmxz+jQRTZlID3hd/dDiY/crKMw9hrFsiLu3vc2kL1+QCjjGhp3v5xfRO5sMHt/F7XEaWaDZmSVncTaJxU242Ais2KKSXER2kHGkA6X5Bc279ON6/0bi1CDbrfBmrkrIcRCESQNwcGOlcp2SWDbnXvDvG/7+KZ5PI904w302AJgOivy8sGvHrGwZpPsV1Sxe9Q5IopdmKvPbUlxHgnPWEEcaauRK4Jrjh0bNj1bAi+bUzoEXijOMTMb6moib0R7PWUMjvFNUL3aFExnrHSqyjbGgcbKJTRZlMT72vflYWBRG599hxGjZvfm6sqNXjfypxlxMzEtQ45J7Ji6wHQPSB2O4j7MOXpq4F7+36OOPZ7vugEFLqfgF3xFmh63v8RH2Z70oazYIFY49SpJW5YHmefnXtsHK+j8CuBuQTefm5ImvAnkWhumm2Q1ZZGYa5P7v8EB42Iss+pbCGJV5nJNNF5v28Sh7Hsk813vyfyWUS0orx8enWM0AIB3NlEuIeWe0/7ZQV/aUOgG29ugOaJ3/3c6N1UNNMtlDmGeVvPAc+QQ8WHfE4FgV06VB+5KU1uIhsTx0bxVXTWF0InPgmW8ek7atCLoAFt3G80u/cGN9p7IuSwchUuRGGjjtfQ5lpo8zu9SfVterI4W8zbkNqkJ6VBrCX50Nn0bP5v0D3Uvgo/PQ6lpplMHtCrRU99lFRsajAEIpcdG4pooHJwh41PJ/n9eF70doTE7Uq/vAHkiAQrTO4zd827xHA1Qi4pnwZ64S8CQ7+ZWvopV8xOgi57nb2qOPr33E3vnuP03lUy0WshkKQHW9r3aRhnNLAvXuzkp0lWXBw41LZa0UM4dC0Y7DBCCq4AbyKgYES5ithNkj+Hxz8ZPJ/DUg81hYwas6GWn5ePki/oOUgsqZVwZI7ZiidinJFv9b953FH
 ZMVpiLLv
 bC/niFvCDzvBlKYnAmkWZ1emtG7hjbud6/vQGBvcwsjPvCCnoYGsrKrwQcr7+aC7wxTb7zc+Uoa0GZvPmghL9IH1NNPgUY12ZAVlQr5rwcfFCppj2bwf8NO8hXoX6rAzmCPJ3oCG+U/1b85ZxEq3UuaPJ+JRmOAWNFFO2a+YmF2Ty4M1bmYgaO9lpE91TJgWsAOHbV6xx4l+5zcHSHraPcZiusrmtS7mWaEJKMZwrkkQTDytdKPAxeq5DjzPVi/6f0Ev4doUM2t7Ej8NdFEGfQUiD/NKDTGxPuqm3spOJmYcIL0l54byXhGGHJoIknlLBxJAOmrN0p1ZDOvF7VuN2q+oY17bccvAeEKF2NKZxSOK7oKUfYwwWy0Qv0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 02:16:31PM +0300, vova tokarev wrote:
> Matthew, Christian, Pedro,
>
> Lol - fair point, I'll keep the reggaeton references out of future
> commit messages.
>
> Agreed on severity - but this is a
> killpriv invariant violation, and the kernel has treated those as
> security fixes worth backporting before.
>
> 1. The fallocate killpriv fixes (XFS fbe7e5200365, ext4, f2fs) are
>    exact precedent: same reasoning ("can change the file contents [...]
>    should drop file privileges like suid just like we do for a regular
>    write()"), same one-line fix, and they went through the security fix
>    process with CVE assignment and stable backports.
>
> 2. CVE-2023-0386 (overlayfs SUID preservation) -- same bug class,
>    CVSS 7.8, CISA KEV.
>
> 3. If permissions alone protected SUID, write() wouldn't strip it.
>    killpriv exists for POSIX ACLs granting write to non-owners,
>    group-writable SUID, container shared mounts, and chaining with
>    other write-access bugs.
>
> 4. This path is reachable unprivileged even with
>    vm.unprivileged_userfaultfd=0 (UFFD_USER_MODE_ONLY bypasses it).
>
> 5. Pedro's point that MAP_SHARED faults also skip killpriv isn't a
>    counterargument -- it's another instance of the same class. We can
>    fix them independently.
>
> Given that the fallocate killpriv fixes went through the security fix
> process (CVE + stable backport), should this follow the same path?
> Happy to send the patch either way.
>
> Thanks,
> Vladimir

Please don't send what sounds exactly like an undisclosed AI-generated
'summary' type email.

https://docs.kernel.org/process/coding-assistants.html
https://docs.kernel.org/process/generated-content.html

I really wonder if this summary email trend (never ever saw it before LLMs
came into being) is just there to workslop people into providing the next
LLM prompt...

Please don't send top-posted email quoting everything below it - at least
put in the bare minimum effort required to see how kernel discussions have
functioned for the past 3+ decades.

Especially if you are looking to assign some silly name to an alleged
vulnerability.

I _hate_ how this stuff has impacted the mailing list.

--
Cheers, Lorenzo

