Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15756FED3FB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:08:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 694176B0005; Fri, 24 Apr 2026 15:08:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 644FC6B008A; Fri, 24 Apr 2026 15:08:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55B3A6B008C; Fri, 24 Apr 2026 15:08:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4308A6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:08:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BBD94C174C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:08:38 +0000 (UTC)
X-FDA: 84694385916.07.8D0759A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id F05A1C0014
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:08:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=o+YeHDZt;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777057717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q2G1/AWZ9TiyhuXddGKAMfHim7th2bFYR+TjmjXX1jE=;
	b=FkBEw6+zXfHy93v1GX9ZmypS+Ec6HhATAcKnZizprBvO9XMn0a4TvCAjOdLUACPxOvyJid
	JIbIG7GgBlpGkAtH5sdbGNL62HHtJvGk0wh8IoDXpHs5EmWPGVb9oDIpr2eqE8jxV5Sc1r
	QSA1PIZfvpxEV/wpxuMfYV//F+tgvgc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777057717; a=rsa-sha256;
	cv=none;
	b=lif8OEYm1vKxBfU8C7WZXlpBxbYj5FKMUF3roGmjWVHaNBZvezfXO68tdsVffOT5S+s5/e
	aMWUsZRb+bxrlKGixzcEQ4fF7c1j1rOp7Rha8AJmJqnj1Pz3e8yzPMfmGB0BDvZ63Y44gP
	/AHkYTV1ad2omX9fnEHKeYbpoO2Zoyw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=o+YeHDZt;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 09933600AE;
	Fri, 24 Apr 2026 19:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87502C19425;
	Fri, 24 Apr 2026 19:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777057715;
	bh=NIslsik2bfMFifVngfMjs60MjOCxmWpxVeRk5iyfLnI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=o+YeHDZtlw2/jrwRhrBGxNaIXgAE2Oyte35CJEGmKkM0xU8Lj7cjnshAiz4uj4LaQ
	 b6Im1fEwd/7w5TXPO9uSQ4oqSCNMSqnhw6xcDqjbDUCVbxyoecZUxOprgzPAq5Cstm
	 v6ODDyYliLGfiHysiDbE44Ndo58RVlZJ6NXIBY3c=
Date: Fri, 24 Apr 2026 12:08:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yosry Ahmed <yosry@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Lance Yang <lance.yang@linux.dev>,
 peterz@infradead.org, dave.hansen@intel.com, dave.hansen@linux.intel.com,
 ypodemsk@redhat.com, hughd@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
 arnd@arndb.de, ljs@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com, jgross@suse.com,
 seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com, roman.gushchin@linux.dev
Subject: Re: [PATCH 7.2 v10 0/2] skip redundant sync IPIs when TLB flush
 sent them
Message-Id: <20260424120833.130df9049a1533396f608c8e@linux-foundation.org>
In-Reply-To: <CAO9r8zN1pRfyC0Rh+UdW-Lsret=z3oveT3=gnZftX-Sr_ubyyQ@mail.gmail.com>
References: <20260424062528.71951-1-lance.yang@linux.dev>
	<20260424063024.ce42ee6a5546e4d9337dd007@linux-foundation.org>
	<aetw4aoABYj3keMh@plex>
	<20260424071533.d28ce90126f05e1c6fc1b740@linux-foundation.org>
	<80ab39c2-efb9-4a23-bd56-46d9bb4e41bb@kernel.org>
	<20260424073145.b990fe9b925da304508aad71@linux-foundation.org>
	<644e65dc-3d39-4137-b51f-51d953b67d50@kernel.org>
	<CAO9r8zN1pRfyC0Rh+UdW-Lsret=z3oveT3=gnZftX-Sr_ubyyQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F05A1C0014
X-Stat-Signature: 4x68tf89qq47r7ghh94s96fjtqm5z9c5
X-Rspam-User: 
X-HE-Tag: 1777057716-552666
X-HE-Meta: U2FsdGVkX18iZydYJxPcpHEy6f92BcY0UlzddJvHLyt+7hJjNZumEz71B9KKzoLKPyy8HJG7Ry5w4wqsmqQp95JlR2C5XGIeEm3f5BDjL3BtwtludBwhX1hlfOzHih9DE2wYdlBtxob4qe61T4N3iy9zitPReDCtZESkRvc/RmQXrFfdMNNp8Jo0z17ilzoJSPPvfZJx7nh12PiYgrb/wvR+uIx4pBYIaLNXvX6/48G3klKNvPrPM21V3+ispIK/uuEOxEgSO2nK98AjEGQp+r3dFqwDkw18pTu5lgtiG1eBNJtsJFJLw5/XMzh6/8ag1Nb2k1VdGynwuaEKI8bRbPVWxIOU7N/Ct8EDI9UEgVr/eg42VD/SqDPFCcNPnm7UNjWM6RAOMaruB8snvexhSkdjTITMIcy9P8ZPc4EoTc/sA1oRMVZiJaKCGn49PJbLJ3wNO91htUN9lDW7VKaMlnen2nOPHr5WUlxOxIThSocgQ+S/3Pz2adb4E1Cjo0hA0UmMDJqalgCevFydPZ/lnrKI32ZddxLwQRVR6xGEbBFrtwDAsrn1aVR/MPEX2uN19cI23AHmDNGLH/tOFJfDCAiot51d8AIiok8dFiqd9Ume9+K7hXexxJbOPqPpKACrWMHqCRhFuDWidqhJpjfAWssJil8VAk6WCI3kPjoqVC5TEIoHFjnyngCD0xPk8rHd+R47XN4dtzqDOA1RVTtJ4TViLMHMZN1Em4uUte/6qHaWtCq4ryW5s1pVLe7uNxOD2SO+HGiSUKi7InN5RofWmN9ZNIA5ghq/YAns3qGqfShXtTd0Tc9g3+7pgwc7bvO/QLi/uAAdeJ+KW/k74KDBudESU5cig3CAIa0ZU102Pg+XvkB0gEkGrfGPxzSwRI7sUQbynI73bCJaTYQUoRKjib/2TmN/4ZdAWK9CGIVbfkiiBqCCeD3pBTsGxJIUzK5jUKqxx0HurVXzd0Cf+7f
 lPky+dWc
 ObxUls36RdJL4j2frukttvZHyrJ903CLHnjNRFXG+KlZMpdhya/iD1tUHWm/f4r7SaFvIwUgdJ/BNQSrkMG4zS/80e+/37Eg40OLytAAQwssqRsKEWVcJXFe65k0u+VXsnGuIKR4oJ4K7f9a791er6VHJG3qYTxyoilBqm9izWT08utWlwKKdZ6H5M8RAHPmIs0EecGTQvbRXsBTOJNRf1t1ReIDQjhlsDuIn33AILVCGiywZ3m4RKOUplT8ci4VT+Wh5ovy7pwTYDZfOtOzUYzTwig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Apr 2026 11:50:03 -0700 Yosry Ahmed <yosry@kernel.org> wrote:

> > >>> Preferences?
> > >>
> > >> Reply-to-author would likely be better as a first step.
> > >
> > > Why do you think so?
> >
> > The most important part for me is that authors are aware of the reports.
> >
> > Sending them as a mail forces people to publicly reply to the feedback, and at
> > this point in time, I am not convinced that that is the right approach.
> 
> But I imagine it's useful for reviewers to see Sashiko's feedback as
> well (without having to go look on the website). It's possible that
> Sashiko is right but the author isn't convinced, so getting more eyes
> on the feedback would help. If Sashiko is wrong, it's still useful for
> more people to see it and point it out, instead of Sashiko privately
> misguiding the author, especially that reviewers are probably more
> likely to tell if Sashiko is right or wrong.

Also, Sashiko does like to find unrelated bugs in surrounding code.  I
saw two of these today.

But whatever, one step at a time.  My main interest at present is to
stop having to send lame emails linking to the Sashiko reports!

