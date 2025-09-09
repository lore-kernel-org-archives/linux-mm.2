Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02A06CAC581
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 03:51:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 357B38E0008; Mon,  8 Sep 2025 23:51:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 308258E0001; Mon,  8 Sep 2025 23:51:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 244FC8E0008; Mon,  8 Sep 2025 23:51:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 168548E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 23:51:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CC82E119A2B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 03:51:47 +0000 (UTC)
X-FDA: 83868337854.28.56C5BC5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4A0D040003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 03:51:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eBxgxzOE;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757389906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K6mm++LCTNwLVmu78sqfeA8i/2S8k2baRVY2lU1scII=;
	b=MtLa2VKmJtfRD5A9qjsRrNM/rELr4ITifHDTMeHxXb6i5j413yJtKLffV3M8YpYfgnwNrd
	CUxboE+kOEoReMsdjJGR0PyCvup9G6mcMrmzvx1MgcgCst+SnpzeD6oOePYLJAwv3FNbnL
	rvbAxHAUuUMGQ8J3XbcKQ2lNYszv67o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eBxgxzOE;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757389906; a=rsa-sha256;
	cv=none;
	b=mYbxthvQpoMuZpO5JBxIfD24xRoDixFTEkjYOV8QcB948i/P64Xu+pIM5DUGrBbMGBIepP
	9W1F6gxyrmZrVmxrc6ag5xzc8KqfgzG2Io7spFNde2evsGKbS2eVrrZ3PPZq/hN70jkkox
	XNXfb2oYP2ByOu1JCesv7t4H68IeZ2k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6497760097;
	Tue,  9 Sep 2025 03:51:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6069C4CEF4;
	Tue,  9 Sep 2025 03:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757389905;
	bh=hDFSqIoDGm+oeOAZ9q443ZWBkCIE3hQkRhHMZyq47fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eBxgxzOEa8Ac6u4NfIJZg7uvYs9srT6Cy6snFEvxalwi+d2+6suPkVf9VfqXgfDcc
	 JlcT0Q2YpAFnYky/zbHUDTmhp4KPF5M/taeWvmOUGamiJuPnnxVp7A7ydYwx6Ze8Z3
	 BFTHiDwU/RdL3NfWk9uT3DMra1l/NgC50To6cwWVdqfyEO+jEwKlSEIsZvz7qvo7PR
	 +P+WMi8LelFiKdOv04IW/kXl50UZsCYPBmiTg+jaKTruDc4//pRE6p6OZ0aoTz1eky
	 K+xL55w8cQw6Pvkk95z9e69KgSjNLDJEWHMcRI1opEaT5utpHCwFqL/biZlW8AeBlz
	 HCctCpmAXk01Q==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 17-rc1" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/3] samples/damon: fix boot time enable handling fixup merge mistakes
Date: Mon,  8 Sep 2025 20:51:41 -0700
Message-Id: <20250909035141.7545-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250908193548.a153ef39d85cc54816950f71@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4A0D040003
X-Stat-Signature: 7cw35pgx9zirk65gdjdreg1338crugic
X-HE-Tag: 1757389906-637756
X-HE-Meta: U2FsdGVkX1/M4PC2thtCV4gRbVrkn7+toPNljdLttDHWoif7mVw/AcYxw+cMH8Jg+rZsmCF4cl+HP75YkjgOrnZ+KED20FNrxD6n3o99lRXFMieJiEiH2ccnPmDvypdJGaUt3QW0EWZO9BVxf+4riO/V5chXRAYKI1gwf478QxzapU87nVfrOZvNvmXaB/PWT4whKa+8YFtxKWuqevclaBcqQhVls1rZ5UEhdA8LlSJVUxc5EwcOYUs4MEyDzsor2vvTRxzRVxpwi/2thqyJ5gFZH/VTvb4HmBoduxOf40Ojwa9d9OBD4dg0IBSPFKK71O1QySnWTJ1cf30fXXWVoT2lEwH4bRq2T/02pqz9uLnyCknJBv6j+UsCTvwIrLwid9JgKOS1iKmov6D54OPu19Z/rtzF0yKINPuLszsSOBDsjjn91vopit3f+yu6QcZIgGwhYCM1MWZY0+xjWyC1vangSZmhdWteRR5Og07TEk8r7gOBs0MMbuDgui/8r/71TShJm3xAXuAvil4X8YO/tuZpD0dMBOq6ejqzUaQiPZUwnx67oVla2KR7eAvy+bCVW31vDOX+i0zNjkeRS/jfbc0beIxhUnbS5unr/SF3ITHf9qlGqBivACXIybSJud/bAcwhFB6WeMngZk8F/AM5A8ui/KRcpDCsSs9oODDxwXPyYsw+hRpGgazDsYSop2yVxT+t6twTd60udmSzpTxFy6R04l7x0wBx0peNes3se05oi2yFO9PsDz1ibYajuCv+fVFmLXKnPqvt4ccmOBaAGh3uMhPWGS5ApfT2xeIeB7XogCdOpjSJW0rIcNT8sgS4HEsLOs5GWcCnfIts06Cj/d2GuOWmzvsmnkknal1TG22lPD200u1Eb4Ivgc5vxtWNnECXC8oBgvtOYm7GSloz5rbFbxo/q7Yse58j5/leFQzcMdd0IkXsZ8XmWH1RquxN2RoCf8PY35gOz0Io/Sc
 lH9v0wTd
 anQfKmNL25fRSsrB8MD8OtjPGOlArfuBmifg+MHFXpKgJbrwHZgwkksQ9UP9kWg8SlyETZQDkIkkNtFzn8Sx10AOjhhIXEOTxQ2kC5HDu5++GWPOgpeUBeqiQO40+QT76ru1qWWqe2sJbJc12wLQaxn+1sLATse3tBCf+nBAuru+n9vTpAITIpam3a0V0ATA4rf3qw3uL1VJ706IXY9KJDgFsMVbstLkuvRPGpRe2emD/G+iJj4+FJCSV5PzWzjQ9vBF5cnt2ETofr2zO3R8K9KWhrOMe1Z+9X9tv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 8 Sep 2025 19:35:48 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon,  8 Sep 2025 19:22:35 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > First three patches of the patch series "mm/damon: fix misc bugs in
> > DAMON modules" [1] was trying to fix boot time DAMON sample modules
> > enabling issues by avoiding starting DAMON before the module
> > initialization phase.  However, probably by a mistake during a merge,
> > only half of the change is merged, and the part for avoiding the
> > starting of DAMON before the module initialized is missed.  So the
> > problem is not solved.  Fix those.
> > 
> > Note that the broken commits are merged into 6.17-rc1, but also
> > backported to relevant stable kernels.  So this series also need to be
> > merged into the stable kernels.  Hence Cc-ing stable@.
> 
> That's unfortunate, but the about doesn't actually tell us what this
> series does.  

Good point.  The issue is that the sample modules can crash if those are
enabled at boot time before DAMON is initialized, via kernel command line.

Would you prefer me sending another version of this patch series with an
elaborated cover letter?

> 
> > [1] https://lore.kernel.org/20250706193207.39810-1-sj@kernel.org
> 
> Presumably it's in there somewhere?

You're right.  Both the cover letter and the individual fix patches (first
three of the series) describes the issue and origin broken commit.

Please let me know if there is anything I can help for this patch series from
my side :)


Thanks,
SJ

