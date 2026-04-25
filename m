Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD5BEFF8850
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 00:58:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1282F6B0005; Fri, 24 Apr 2026 20:58:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D85D6B008A; Fri, 24 Apr 2026 20:58:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F09436B008C; Fri, 24 Apr 2026 20:58:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DDDE56B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 20:58:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 749F5401D1
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 00:58:36 +0000 (UTC)
X-FDA: 84695267832.27.15A2AA1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id BE80AC000C
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 00:58:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r6lj8ZcI;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777078714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bmgfzRfeEOBNZN7avekUGacGS5g1movze6OSAnCfGl8=;
	b=LCRpx9OpYM6OpOGzygr/nGWdmwH+2uir4aOltHsI8O1oxC3S+6WU/wwLPvbs/6cIeFW3EV
	n7JAtWMlLHChr13bOHRIwME+8hKbe62TPGhRhY9sBn+iv3FKMIGFzHB+KAcaZzEKHGCn7P
	tyQ9k5v8+y84l5qgKKZk4PowvN2FvJ8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r6lj8ZcI;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777078714; a=rsa-sha256;
	cv=none;
	b=2GbZJJGg55PCAYNPSm/vSwUdXSKDYTrSxxldoMdx01E9ca6zjLAi3Fr3gZAiVixsjQHET+
	2M08UEOB0OHxD0CdOSY+Gqgt7BAfLc+1wZrfo3R1h2yktcaNVx2feZC0r8wVWOcbm2Dnxs
	gqvq3ljl0ofVobk49fSpOFJdrfvi5oU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B139F600AE;
	Sat, 25 Apr 2026 00:58:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C2CC19425;
	Sat, 25 Apr 2026 00:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777078713;
	bh=OXNxLHcbXvYstCd0hV40g2fHvy0QoEeo82TGhCpF1qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r6lj8ZcIssuYUzBmdUm2MTEcxm0OX5yYkORS/Teky3PLp5AKGzuJC2+02+AVURTJe
	 4HC52cDmZgNUic/X2A2ZBPbi5YYFTNtZ+iltBZGhFNyjP99MuV5jbbdJfEtD0eiR1q
	 ZogmJ+phFmniFFp+haYiOe0Kw+dnIWEvt8VvaJD8FaqCI3nHuF/Fm16U8dHeAHFTGc
	 fG5CD/E4KXZT5RGkE1uat0Y7fWE3lNk2TkfpLnNlwIUVz8LRFwdBR3gh0fFBh6pvbx
	 Ci0Zu2cVA1XvRKVCOCdN91qeB1Efixa2bjCPl8tR+qm0e46JOyXaKSMfVGX6DEhFt+
	 eiHpqN7AzWeCg==
From: SeongJae Park <sj@kernel.org>
To: Yosry Ahmed <yosry@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Lance Yang <lance.yang@linux.dev>,
	dave.hansen@intel.com,
	dave.hansen@linux.intel.com,
	ypodemsk@redhat.com,
	hughd@google.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	shy828301@gmail.com,
	riel@surriel.com,
	jannh@google.com,
	jgross@suse.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	boris.ostrovsky@oracle.com,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ioworker0@gmail.com,
	roman.gushchin@linux.dev
Subject: Re: [PATCH 7.2 v10 0/2] skip redundant sync IPIs when TLB flush sent them
Date: Fri, 24 Apr 2026 17:58:22 -0700
Message-ID: <20260425005824.85689-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAO9r8zOTFUSXc_iZ3i9iL3v9Fw+SOFoROj0vcO_1GwBxO9CVqA@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bwe4pxpkcqgo7jqyhtqr6crmf4hy4wq7
X-Rspamd-Queue-Id: BE80AC000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777078714-153024
X-HE-Meta: U2FsdGVkX189DBo/kkt6JNReGwvcRGrd4TiowKb41Mby5Acd0xXl/21MCiF2SKdv5CTr13RZN3SBjTgHQKXBmFSKX/jIsgDf781ZpHN4U1VWhYySKbCYkPj4T3YSSuVfHLUPUQjSeVOmPVrVzxtBKqiYEEVoel3/RPymTtwcVO2CdsdoJR1ynpJU445gYfQAkj0zP3v+iqLaCqw2mrYinMF5sZpMJYhtKuC3zgGiifPm3SbSrS06h3pSDbKCsTW5WDn7bD88vgWml63CWFsXIeXk0hmxbxP+KLUkfe699JiApTYziuawyGLh6erOCy6CfebACsGg7hpcT43QSRAN6ZWt4BenwcojDUvGEQmSralOMzkZ3Wh690DnUuVw3EOQSaVK3S4YKJiVPB3EYxhgsZDiWqOw9Q4iTLtrqAF6NCn19rH0Fh+AwQ87ObI8qOJijyVppIjCWVlE/hARydqb65JO+I2mDyeZQYpj1M1K3qwVHtKnJv6jrwuI6JMsaCmnqMsTQ0xCr3ar8NQwmKF2c0EebFSPYuzg0LdFSSLlwm4Y1Ge8/9Fl435JmQmfbpO73HTWfj3PlFXhEEs8KTKuzQbB+AbjK7jnQ8xJBOb4n50pw0bmx5G5fBKSVtSL4BNYcua9O5F0vfipalG93ABKzyFlDRBm8B+vNj9ohoX74y1oq6uaNybU5moasvSQoXzL8IooRIEmuJ5TpJzdxOGz/lPX2Lkq1SG7BeeUROqwxBs6l+sdo9BBqu7W+eTGbVyYG2JfZsinU8MSGzHjhMmoc3KMvuSVzZ8KXo8Y1TOQUWjMK/SsL81mgLKe1PGyX+KQOO3Wi1jWG0SxcxgvftsIIQa3AmzKOhQMU378v13I8Lzzj1VmrBtDVsTcI+26q9KmxSQOuZHwpP+9R03so8HRX/2u2B5x2hXW+heFyCSXZlhVaR0MzNP2bvARC2G23IF1i1GU7Vy7T2xpp/oUu7i
 tQ7x4FOC
 lMwsWgqfESzDuAu4Wa3mY02tj67L816pWgpC3O82WZF8UiQtmiDK4NYay72L/FUXZh1TH6XGdWP5ithMg/AS36+oH3IEQIQRYItUaAHNafYtOybLuWYGzDsxgHGcIEFAthLmLIqsV8f00YZwYgjms7HLw8+toL25cklgv231lJIZMFoYTvjQGlyW0KrDUeGLTFEhWSPF6oll+HetWGptVaA9VsQf2UkJB2g+VVYHQPUl4BaEdD18I85rDZBgBJO2Nws5esNcBmIGErppetZGi1SO4IGjZFec8IRrIsUs2Gxt8Eub2cLQXoMfrMhzeCFyF60A7fnbX0teZAXSaAhn7y3awm2WyXJ62jxaN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Apr 2026 12:15:30 -0700 Yosry Ahmed <yosry@kernel.org> wrote:

> On Fri, Apr 24, 2026 at 12:12 PM Zi Yan <ziy@nvidia.com> wrote:
> >
> > On 24 Apr 2026, at 15:01, Peter Zijlstra wrote:
> >
> > > On Fri, Apr 24, 2026 at 11:50:03AM -0700, Yosry Ahmed wrote:
> > >
> > >> But I imagine it's useful for reviewers to see Sashiko's feedback as
> > >> well (without having to go look on the website).
> > >
> > > That's why I have a script; if I press 'S' in mutt on an 0/n email, said
> > > script goes and does webrequest to sashiko and inserts the review
> > > comments into my local maildir as properly threaded replies to the
> > > series at hand.
> > >
> > > No looking at website needed.
> >
> > Do you mind sharing that script? It looks like a great work flow. Thanks.
> 
> Yeah that sounds great :)

FWIW my workflow was also similar to PeterZ [1], except I use hkml's Sashiko
integration.

The hkml integration requires two key strokes to get the Sashiko review, so I
think Peter's script is superior.  It provides a draft [2] for sharing full
Sashiko review that I can further writeup my comment and directly send, though.
It is helpful for asking the author their opinion about Sashiko's review, with
a fine pointer to the question.

So I initially started opening web browser to check Sashiko review.  After that
I used hkml to read the review on terminal and copy-pasted the output to ask
question to authors with quote of Sashiko review.  Finally I was able to just
forward Sashiko review together with my questions to authors.  Each step of the
changes made my life much easier.

DAMON is opted in to the Sashiko's mail reply service from the beginning, and
recently Sashiko started the mail delivery.  Now I don't need to use the hkml
integration, and I feel my life has been even much easier than before.

[1] https://github.com/sjp38/hackermail/blob/master/USAGE.md#sashikodev
[2] https://github.com/sjp38/hackermail/blob/master/USAGE.md#forwarding-sashikodev-statuscomments-to-mailing-list


Thanks,
SJ

