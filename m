Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5E13FA374F
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 15:14:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37EA56B0088; Fri,  2 Jan 2026 10:14:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 335C46B0089; Fri,  2 Jan 2026 10:14:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 282FA6B008A; Fri,  2 Jan 2026 10:14:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1945E6B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 10:14:27 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 20FC78B9E3
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 15:14:26 +0000 (UTC)
X-FDA: 84287370132.02.8CC58AC
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf11.hostedemail.com (Postfix) with ESMTP id 699124000E
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 15:14:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=WeGY8daE
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767366864; a=rsa-sha256;
	cv=none;
	b=pcV5OxzlpXwp/wGarI/sRwtxM6q5W8myryDTfKmv0zr+YW1WRGC4lRfXVC9fmE8KplaHYK
	B9i0KV3LqNpZwQIhw19NQTbf3agru4nRWMteR7kYrgg1Cnm4O1+o6A288xJ4jjti8tBoiO
	kmDS/rl6hsEdzLEDU+M23Rsj5v4HXJc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=WeGY8daE;
	dmarc=none;
	spf=none (imf11.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767366864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fsMs/AbVOowjNRNxn0Ki17k90jR/IkzF8PcKdqkkE2E=;
	b=cko0KkAp87I43CkEYJWjwSTLroKvRLVnSK8lY2gocraDDt1OAHE3untyitgFJ1tVpPfyJ5
	wfiSEHevlvax2PMqlWf+4VbgqDhlSIeOhkiDRYS159OuLBw1fxpirN9lLcPBmEiWNQTLOe
	WZV+uO77uuK7JiCDnrt6/p8VW7Dh9JQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fsMs/AbVOowjNRNxn0Ki17k90jR/IkzF8PcKdqkkE2E=; b=WeGY8daE2/Lrj9EhBZvneJjFAD
	EvyJXA/NWTiTuZiuzCVVY4jX3BBlfm+66hCRtP6/aD88000k2Bfg2TGa4TKiE5H3fql4v70GMVLsK
	B/PO7zOTDIWwQ0I3wZyg9lHE5u4N6gULreaY2dDUk3Y5G1Vb95ipEvIWRM8UKB3xQ3K3KHfpA6lXt
	P56r/CxbiwmbcpctCj4DHviLLcpZaT2IaUF6cQHblaYbnEqrCrGDJGhC4i2SVMckxn29Y1HwRsW3M
	7SJ6fNjcuB1GeiVHNoXxJKQNltzFMbtoU6caJoZve3fjcnNtjS0baiog41RumgypAWy0dJwrDyXIM
	rVNn4FKg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vbgqw-00EXc4-A9; Fri, 02 Jan 2026 15:14:10 +0000
Date: Fri, 2 Jan 2026 07:14:05 -0800
From: Breno Leitao <leitao@debian.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org, rmikey@meta.com, 
	clm@fb.com, riel@surriel.com, kernel-team@meta.com
Subject: Re: [PATCH v2 1/2] kexec: history: track previous kernel version
Message-ID: <dc7x5xq2ufanc5vesvs6ccvulfiddqjcf74r7pp3tr4bfiomib@akskveejglww>
References: <20260102-kho-v2-0-1747b1a3a1d6@debian.org>
 <20260102-kho-v2-1-1747b1a3a1d6@debian.org>
 <2b315095-2393-45d5-b0bf-ea9fbecd2607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b315095-2393-45d5-b0bf-ea9fbecd2607@gmail.com>
X-Debian-User: leitao
X-Rspamd-Queue-Id: 699124000E
X-Rspamd-Server: rspam03
X-Stat-Signature: tz1xhfrqts8iw1qnh7sxq8n58qj46a3o
X-Rspam-User: 
X-HE-Tag: 1767366864-968605
X-HE-Meta: U2FsdGVkX1/HAptC+fzNpRWQF5Y+WlFLLw3XQjFcRX41GTXfvENCMHlbbbVYPRAgOluaBuiKKZJhVL+6CL+4EmtAI8R/GCeb6Fc4rX8cufERpsqQnrRFnAdf7n0c/8g9jtgh6NhnQInIhT4JDmJZHVlRHDNfayYlnXnGOmXgZIv54pMJaY51x9fLJzeR34U8U7VfSznejNsaEQBNCcXkkTVq+csBdQviO4ShW6x7amUMOzVqtAKp51NdBOh9bA6Tr1DO51bcl7kuiJ35WGnPVQ4xEAj14bIYBK1jyXmNz8dg5QsJV5t50TaMau2jPlhQiDoRBSj4JteX2m1isQUHkWr2a1AsgmOu5qDmyrheV5kbqrxbfczX6q1StW5M39D27jmdX/6oRcyMGnc/73XJ5u4j58kCdC5iIKd/mZlLjtefY9SjokP5cNGPxfVJ539JUZd/z9x9SaKwOXyDF91kmdg0MvTcsyRYNapa98VFHWAy0aS9SUOQd++SP3zKjs6pAAeRkuebsElk1dkbe/uX2vz0Ts60fYU9epfwWw9R4GRCXlL81znys2kEOy5qfNP9mEKwFoSgx9yHbU50IJvC4zlWZZMdXPFHuHaKJ686JMgjA3sVLeOvELek/Ujtfc7XdZZjx9/rDH1Lpk12oD9AfelPoDTIr5JWr54EtOMLkad41CBnlRC2qiMnl6fIN5qj66wVCW+bc/c6seG5dt+396UZpLRPaH8ZFEDdG8u18XqSFmHc949bpL1os4snnLIk27LxIHegLLsH0kvKolHvHWxiunbujgcK0S7NTeDYdqyo5DZKpdY/9PNAx0U7m+g0k6llukxuMjBPYVZ0w5mfCwHdJClvkC6/XSAM0/FrcnCH8Etwf+MDCYdqIwVCt+5kT6/2srSROUsQsfCNP1Z5MkaeF18yXw9WlP9QxiCDXVlwt73Vth9sJ22sJkC56a8WEllPjplur64q3tXG7YD
 7HxUdn2j
 kNs8DdJDvasyh7ITz2fgDNcO8b3gAcAp+Zz/nGBGFF+rd/ox2Xq2UcoDc8TtAsp3Tyjbx89E5wWOE1p+V74ajOJ+UHAKyaOJ3v6vAalevPPeEexar7Q0EQBJLdc3KZiOZNK+C/lb55EMBFgxHInw3jt/gw1Lx86z0HT5IPCQ81k4GESI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Usama,

On Fri, Jan 02, 2026 at 06:02:39PM +0300, Usama Arif wrote:
> On 02/01/2026 17:53, Breno Leitao wrote:
> I think we should make this default if KHO is enabled, i.e. not have a Kconfig
> option for this. The cost of storing the char array is negligable.

Sure, I can get it enabled by default once KHO gets enabled. Thanks for
the feedback.

> > +	pr_info("This kernel was kexec'ed from kernel release: %s\n",
> > +		kho_in.previous_release);
> 
> Maybe s/release/version everywhere? It might not be a release, but no strong opinion.

As I understand, in the kernel parlance, "version" is something
different from "release", and what we want here is "release". Here is an
example of uname, which also matches with kernel source code and UTS.

  # uname --kernel-version
  #1 SMP Mon Nov 17 07:00:42 PST 2025

  # uname --kernel-release
  6.16.1-0_gc0739ee5037a

Thanks for the review,
--breno

