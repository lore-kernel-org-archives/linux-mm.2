Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18EC8FED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:01:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DED56B0005; Fri, 24 Apr 2026 15:01:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 688896B008A; Fri, 24 Apr 2026 15:01:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5774D6B008C; Fri, 24 Apr 2026 15:01:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4003C6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:01:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CE02C8AAFF
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:01:55 +0000 (UTC)
X-FDA: 84694368990.29.C853DF0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id BCD2B120009
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:01:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=iBXOAcq5;
	spf=none (imf29.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777057314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qXXPhIB0sL9TCVVBti/PLOD4VulXmM4RrN7ox2Cw8JM=;
	b=QspUaefQvkTSj8YiqbZ84DDGny2UbvPHcoqm7fttymFiXJhb5IoxpTx0H/b9MIcM9HImjF
	oqlulNq300TcGe/7dL9OIl7ynFJwAXsl8h7bAqvupAXhn6xpICq78+oo8JrmluSDOrL6k9
	ZJET+n1e6Lcdb43W4Il9QD4FALYd7ds=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=iBXOAcq5;
	spf=none (imf29.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777057314; a=rsa-sha256;
	cv=none;
	b=BiYHrZJj8M72eV0iBldsSwYW598JuoOpzaojzfBauaIGDVrsk19V/Xk2M0YORhsNMPy4t3
	KqW3mcECfZ8LGDS/+uXSnb7hd8YhMlZXFkgCanNVwPsP5yTIO7VceVgySF1uyMQVWmFcJq
	kIW+CE5fBZYU8dQE7dEhvcmVjWGXHi4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qXXPhIB0sL9TCVVBti/PLOD4VulXmM4RrN7ox2Cw8JM=; b=iBXOAcq54PklkFMQVTXPK7sgiS
	h+ozXVaSzR3kNof5rtS70uCRPVLWxdrU91OeILCZjWSikajxROUfVFhAt4h4Fk8xev1J3hJkoDq0R
	bBjGkp/fQSpDHNocIILF0xWu7gO7Bi3zJ1o2cr0lKkwxwO3hbPspsz4H0Vr7shRGdUpk6/TEhm3G3
	HG/zaOaBUgiTHVjKONV37n+RkB+KSmPliyu6RRYec7HGGWjUxmpQO4o7m2vFwHDzXy000LFvV2Xbu
	+dcyqBKtgSU0PetS5UvBj0k9yRGY4G8ULhSIJxJiPV2Pq7ZwXMFsrbRDGq0Drb0wAM0hyGKX6SwiK
	/1xg61yA==;
Received: from 2001-1c00-8d85-4b00-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:4b00:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wGLmZ-0000000FfiV-2WUs;
	Fri, 24 Apr 2026 19:01:43 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 0D4E7301142; Fri, 24 Apr 2026 21:01:42 +0200 (CEST)
Date: Fri, 24 Apr 2026 21:01:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yosry Ahmed <yosry@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Lance Yang <lance.yang@linux.dev>, dave.hansen@intel.com,
	dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com,
	will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
	hpa@zytor.com, arnd@arndb.de, ljs@kernel.org, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, shy828301@gmail.com, riel@surriel.com,
	jannh@google.com, jgross@suse.com, seanjc@google.com,
	pbonzini@redhat.com, boris.ostrovsky@oracle.com,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, ioworker0@gmail.com,
	roman.gushchin@linux.dev
Subject: Re: [PATCH 7.2 v10 0/2] skip redundant sync IPIs when TLB flush sent
 them
Message-ID: <20260424190141.GA3783056@noisy.programming.kicks-ass.net>
References: <20260424062528.71951-1-lance.yang@linux.dev>
 <20260424063024.ce42ee6a5546e4d9337dd007@linux-foundation.org>
 <aetw4aoABYj3keMh@plex>
 <20260424071533.d28ce90126f05e1c6fc1b740@linux-foundation.org>
 <80ab39c2-efb9-4a23-bd56-46d9bb4e41bb@kernel.org>
 <20260424073145.b990fe9b925da304508aad71@linux-foundation.org>
 <644e65dc-3d39-4137-b51f-51d953b67d50@kernel.org>
 <CAO9r8zN1pRfyC0Rh+UdW-Lsret=z3oveT3=gnZftX-Sr_ubyyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO9r8zN1pRfyC0Rh+UdW-Lsret=z3oveT3=gnZftX-Sr_ubyyQ@mail.gmail.com>
X-Stat-Signature: job6orbw1roenjnd3skzzffm4unwr9ae
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BCD2B120009
X-Rspam-User: 
X-HE-Tag: 1777057313-100655
X-HE-Meta: U2FsdGVkX19QsbA5Ka0UQKRiW8tT1vBkxdHV3hr7DTJUMXzGOSvQywhkVu2ytCf0NdNlJXfOoYyBxq/rKomw+mj7IWcBF1MLFo6QG5awUpI2y/LMgkS1mX8gUbDpoxJZ8FDjNYCgGNGHkPpi0oPv8MkMXWXhDnNFqa2KJIRyQkaBUPdICyL2jJB0pVcY27xDjSXo1T8s/A73keyYPXKvaPH2HDoh0o0yNsp8WxaZSchiZivP+2eLuUnpCq9rRVCWuzvuLI0Z32dfpZioiBiCMXN7bcmFGyv/w55WdRnhdQ+wec5osjgPPhXMwe2tiwvbYSt3Aef82NYdS4ibR5ZwhPmjhhy/YMrfmzavaXa/nqHIAvjSgsqn9f08SognNwGDShV+vNWaAjRVlPMMYNPR0Si1wWEXQN5J8m4eJFt+/6PJa70i5QpS0NO2hJDJ3se2owAbtQjRD8B8vPEUHl380184dsOYzIlbtfY72R8CmPGo66vTRMCBI+zalwcp2Kx602dc74NNqgsF13KtBrXV89bhtjHExLpEOPnD/mQOKeXJ0Y45qoDg3kR72nwRdQZbIeRbYlB9z/YflxP8p8VAEqNHS1eDkn1DADTC1jCa5QtS6XmZnj3mLpbqUVQCpruHDvfNlPolh6NMn7UDjoPQm+oPey1kRqw+EoI8qAlY/7B+p6yslayaMTFu2M9j8vdX5gwdlGkJdjU2Ph1erBlIy17cHco/lUHT+BoxyPK6Te90mgMQDapmehM/URK9XDV240g5okPrrgetL1KLcdIgI/dYMlaZHJVwpi+Z9gMtoU4kxirDbamsDzZAnf/VicJSLJdnvld0yfF0SXRXb3miyLwvvgH9HHFZ1ULVaM/6N20kidyw7Q6P7ocwElkN4A2mS0czQ3V49Lk4PJP0ZJ5+cPjJrIpgvEx2TtgM7DLDK/CDCJAYNKOOEyDDXUrqv7miR0ldBxXcOrYiHKhUy3i
 8aBoQa7Y
 Pfy5NdsXhI7m2VMvpRVQYHhZcg+HbAJz05aN/09odrfeMd7YfuPMVFxmjCYe7b/A5OK59VWI0FC6SwqUG9CipOFwUPDGWChOu3CxWkpwoaNQOuWPNi8Hm8fMOTW6zvGJtA4C7CbXmrgUQRZpz/p4aJ54t7ilOGO9ESYGM+KrkdEgwFORvIirCmH7uJGpKAsALEdzKG67M3oXJV8w4FU63Baah5Hndl8ZJCgHxMEjfUqXo3gs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 11:50:03AM -0700, Yosry Ahmed wrote:

> But I imagine it's useful for reviewers to see Sashiko's feedback as
> well (without having to go look on the website).

That's why I have a script; if I press 'S' in mutt on an 0/n email, said
script goes and does webrequest to sashiko and inserts the review
comments into my local maildir as properly threaded replies to the
series at hand.

No looking at website needed.

