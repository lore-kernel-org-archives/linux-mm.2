Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8129FCD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 11:57:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6221B6B0005; Fri, 12 Jun 2026 07:57:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F9B36B0088; Fri, 12 Jun 2026 07:57:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 536DF6B008C; Fri, 12 Jun 2026 07:57:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 483936B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:57:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3F15A07F5
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:57:28 +0000 (UTC)
X-FDA: 84871110576.08.8C90712
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2648A180003
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:57:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=QddhunSb;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf16.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781265447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eW9tYSWRM+JFfYWM3cisOEdp7zn6Ni4KfLHcXz8CmGM=;
	b=BH/7zc83tfdCKdUlEsaWzJnAwLZkgDDbHLNOi1fpObxj7RuaC8U0GdPqI44FKdlSujpmsk
	xMIArs99Ps+sV5sCUbfMMUxkKdbUR2FPpwG/LftNKklrq6ykuBtC4h1O2Yf65dBv5D35JR
	ixVSJLlrqcdS+72NK1DAN5oFLVwnilA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=QddhunSb;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf16.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781265447;
	b=MelUS+pn9zI20D3Yn8egX8MxXP8bUyhRGAKqXsfzLcIkhq33PZ+1UU84kcYDzfXhkInpbk
	afrQud+qGTU9RZC9YR3l0tKPf92CbmelBH520oTheotQG69IRMQITwFCZKmKCfP2cMBYe+
	MkrC2KfivPni3ZFGA9cCk55Sb+IFFP4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eW9tYSWRM+JFfYWM3cisOEdp7zn6Ni4KfLHcXz8CmGM=; b=QddhunSbG4e5NkzuFiBHtpO9jz
	zhJ21piPLJS0v+4HnxX4yblnhC7jMWj2Fe/zZ3bvre4mpQssMGlrblKWjTYnoZZlrZG1eiPkIBUBk
	MN4ULUSKz4Xo4C0/S8WpSNt2VRMZHEAwHqYlrOgMOAkc1+oCoufWIhCSlnxVR9GvCzr3GmDNuM4DL
	PLm3qs2l9QDpwQdmyxqAeih3/nxq+A4t2Fn9UjenVImWy57bFEubAG09TR+q0qLHfJBdAQ5FH1P9l
	C3qvbc2QvuoK8j9bAU11IVMqR7nkba6E80Ao7t6eGCEgzCd+P5fSNEDEwE6tRC/qpZw1sGn2mgCiT
	KiwCdKTg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wY0Vl-00AiTX-0J;
	Fri, 12 Jun 2026 11:57:21 +0000
Date: Fri, 12 Jun 2026 04:57:17 -0700
From: Breno Leitao <leitao@debian.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: catalin.marinas@arm.com, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, sj@kernel.org
Subject: Re: [PATCH RFC] mm/kmemleak: avoid soft lockup when scanning task
 stacks
Message-ID: <aivz-Kwbw3ZfDJci@gmail.com>
References: <20260611-kmemleak-stack-resched-v1-1-d6248ade5f4a@debian.org>
 <20260612031605.58235-1-lance.yang@linux.dev>
 <aivJ5Dv0hAQ1sJu1@gmail.com>
 <6bc446b7-8e25-4add-9d72-a3c9e9191533@linux.dev>
 <aivhX7RtLVwBkNj6@gmail.com>
 <086712c1-18bc-414a-9a7a-723b9498847a@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <086712c1-18bc-414a-9a7a-723b9498847a@linux.dev>
X-Debian-User: leitao
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: dc17xy95wdgzrzwkooqzt9kwmgdb1am5
X-Rspamd-Queue-Id: 2648A180003
X-HE-Tag: 1781265446-969430
X-HE-Meta: U2FsdGVkX199evGLo30btdKNBCrsG7s7iAOC/Uze5xEDKaw7cHz5JU50e/u5nPRkh8TGuyg8sKxBlRsWnFjR7QZTEWVVsU1ChJmYRdxf5UwNiXsCVn12BaybC17UAAOJauFe2cbzuPiioES3pPrK+0Kkdm/u/IFV8pgGHhE/OMIrsExlMwpEtimp1F7Jg+ck4aEjmouSA1jCZe/rfzeQJKkZhJfPCNsjiB3d4Y8TJQXqlqiTsXZbTMR/nlMKxV1xniMGBHSE9wnpAxAcNxpHBAnPikSyr66gwHhlV0oKS2vBU7tG8ua9fojKwyfazVPqVOWcamsINPmwz6rAEt1PTw4gYaiGwj8IyhCJYADyxhFTpmZOBIc3CwGkv5l50oYTBXjB6v2MQ0euCGdG3sA9s0zFjQnMcFXBPj+OZMI2H6jt2rGrxuwgfv5esiJ9FLOPUbyUhmOAZISH9XbV+0pMHonk3Qf7scHzxKUXFqYhOyfDNLFGz3JU+vOsvcWgD47kB/BGselCkYXtiz0/UNFsvUyLl0S9IYZx5PSrNbsHHAELpzbMd++62Wz3fVihZQq11h+lx+skJY8D+PbxLTg/KUCpbjWzPyXEZ4c12MhoDq0NXuiUi0dO1dFJJW0G3lUsZOrP/tGbsoorBix2rcgJhA+uLvKYDs0JbJykQTrczAyEwxtyuFvvcge8ugGDFu8oVmuzy5F0ak7lSd5Sir2MKFeOwZHkxawml1hoQuL4A4CdfIK6qDOc1UZ2Uao9JiSiUC3Ltcvgk03aMF/TaWDfJHquT2Fgvo0Zz+63dhlUPcRPAe459Ru+xx+0YGh9wXB/1XetpPPj6P/fH3QOA01PJgF0iqVOxrCejxZUaaZQTzjM2yVLi4wgwdTNxbsEcy7s6OJynFcvaGmsI9LBYUwdfB+fFoQv+x5QVMv2RmyvfZTcJP92pOtPgyYiMK5H1PC8lEVpWLPjjB2T/Bes8Yz
 MPXNu2Zq
 gVDao3wJ8bI+jjwk7ANT6jwQDv/aWzTRqfjPd4TZzg5W5qC7H4ZIlMvxIj5+t98TWOwyW55aZ87Ijqvfq5l9K+3PYEyrIfGJwJLTnjgVPW1SdjlYPKJRL8THBFQELFu8lVZk9XZp1AikoyxaVKVK7D4E3NLOuD0O0c03BE/nJrXI1fvhW6jvHiGdvF22rhnAe175T1NfR2kYqWgWiPQw6mqVtzqX9rDsbcv5KjjYli8cHIN8BGnqeLrGzwphde4WJT++U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 07:22:38PM +0800, Lance Yang wrote:
> 
> 
> On 2026/6/12 18:39, Breno Leitao wrote:
> > On Fri, Jun 12, 2026 at 05:57:12PM +0800, Lance Yang wrote:
> > 
> > > > If we go this route, the aborted round has to suppress reporting, reusing
> > > > kmemleak's existing "scan was interrupted -> don't report" path:
> > > > 
> > > >         if (need_resched() && !kmemleak_stack_scan_break(g, p)) {
> > > >                 aborted = true;
> > > >                 goto unlock;
> > > >         }
> > > 
> > > I'd expect the normal case to just drop RCU, cond_resched(), take RCU
> > > again, see both cursors still alive, and keep walking :)
> > > 
> > > >         ...
> > > >         if (scan_should_stop() || aborted)
> > > >                 return;
> > > 
> > > And yeah, you're right. If we do lost a cursor, bailing out and
> > > skipping reporting fot that incomplete root scan should be the
> > > right thing, I guess :D
> > 
> > Thanks! Under what circumstances would the cursor actually be lost?
> 
> It should be race, but possible, that we happen to stop on g/p,
> drop RCU, and one of them is gone by the time we come back.

ACk, that makes sense, with that, I think this approach might be better
than the original one in this patchset. Let me play with it.

Thanks for the suggestion,
--breno

