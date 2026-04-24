Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBDA7FED3FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:35:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 116CD6B00AB; Fri, 24 Apr 2026 15:35:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A0A66B00AC; Fri, 24 Apr 2026 15:35:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAAE96B00B0; Fri, 24 Apr 2026 15:35:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D65346B00AB
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:35:40 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 826E41B6FEF
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:35:40 +0000 (UTC)
X-FDA: 84694454040.01.7415E80
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id D6A79C0003
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:35:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dLRk3Exc;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf28.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777059338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XdkH1kke8xKNHhewDP/J3YySwRvCbjXWp0T4uztq+es=;
	b=KSX9YISqQe0ZgrGqxx5I53jeGamrBzp3bRE6cz62Ekfwuco/AOz8Jw8bJQ07EGdRoCMMOz
	L/taMdV92EukYnLOELKwu17/E3fLVI4d0lTCele+9hVZ8HwJR76LYI7rFkEITyMvAu8i8b
	5bWvzHfjalpVhIPfSdjs89XuE0HRGM0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777059338; a=rsa-sha256;
	cv=none;
	b=4/n8l8hd9ulrSVd7UpjftFne/RVH7mRK7O2q8f+AslC1A0S4NaovAbkNfSgrSse3hwSMUW
	IWC3xUtdpKebcOx+XxpZ36q2syQfAzVgwwunqw/N7YE6BQUxR+xfNm5iK7SNAOA0S+rCEt
	/Z3+8Vd0jyoySdpbbUT+2iZd4JCio9o=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dLRk3Exc;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf28.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XdkH1kke8xKNHhewDP/J3YySwRvCbjXWp0T4uztq+es=; b=dLRk3ExcR3bJdP3rx8RDX2VDn+
	XXZVHvWmgCd7fo/OIGaJC63rzZiZIz2LpR47O5RLmEJzgdJs7Bo/5H1POeKA7czocmGPzuTyuI26v
	6g3xKivFhtkRJJJnZb3SBZ3k0jTcevV+iuI+a66hVCa8UphNH/U2PpNiRSKWONOMvFurwnOcZR/F+
	1KCteXs6F5aLAQZFcodjh5JGIh3uoaNNfiYci4x02r6w/pg+dBuMNZoewQyvAorQ+puyBEuFT33Fl
	W9qQ8PjQEVS6lQ1ng7yqkVdECou37wa5YEtpbc9+ovZvy11plaEo3qbSSvg9nqqUxLm0tRfv+/SVt
	b0IJTefQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wGMJG-0000000FhuN-2hyR;
	Fri, 24 Apr 2026 19:35:30 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 47CCF301142; Fri, 24 Apr 2026 21:35:29 +0200 (CEST)
Date: Fri, 24 Apr 2026 21:35:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Yosry Ahmed <yosry@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Lance Yang <lance.yang@linux.dev>, dave.hansen@intel.com,
	dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com,
	will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
	hpa@zytor.com, arnd@arndb.de, ljs@kernel.org,
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
Message-ID: <20260424193529.GA3853824@noisy.programming.kicks-ass.net>
References: <20260424063024.ce42ee6a5546e4d9337dd007@linux-foundation.org>
 <aetw4aoABYj3keMh@plex>
 <20260424071533.d28ce90126f05e1c6fc1b740@linux-foundation.org>
 <80ab39c2-efb9-4a23-bd56-46d9bb4e41bb@kernel.org>
 <20260424073145.b990fe9b925da304508aad71@linux-foundation.org>
 <644e65dc-3d39-4137-b51f-51d953b67d50@kernel.org>
 <CAO9r8zN1pRfyC0Rh+UdW-Lsret=z3oveT3=gnZftX-Sr_ubyyQ@mail.gmail.com>
 <20260424190141.GA3783056@noisy.programming.kicks-ass.net>
 <E375C69C-557E-44EB-9B3C-618C9F7BA9D8@nvidia.com>
 <20260424192250.GC3783056@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424192250.GC3783056@noisy.programming.kicks-ass.net>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D6A79C0003
X-Stat-Signature: 9mjxmtnat1x3b3u191yq3mozexmbp6c3
X-Rspam-User: 
X-HE-Tag: 1777059338-909665
X-HE-Meta: U2FsdGVkX1+SSeonXnuZJmH8ohYc6vkk4Kz4puHAhOO1aYXYxBzIa0+OvR4z0NPfvt91hGMq9PTpX/lmtg7cvJVpsu4sYnV/gTEmUlvkpbnqyGyUxMANnjTuJG61icu7XGcRPSl6bhBCnxvfJjrSjfGOclToPQPbWinE+MCDQBWWQJ5NguZe7fQpMmYwOhtd0FNaCpBs2R6wG9wZJlSnZz3g6z5EyV3zjR4vmUV3L/ARuFY1NWM6iuIpJe9X8fxYCeFpHkHjkxlOF2jZMXCWdVtKnjaS6EER6nhwCubn76cBOTtYikOc6qXt41P0uJM2r1cd0V6bpDSl93CxT1Xk1eoaO3mbfwoCt76do8adK5o2+t1yZGWqjupxRWYuBfcCAP0PVcrO5F90lSYBtpl/gRb2gqBxEGbnMqnZWvXZ2fFCoD8iVXTZ3qdt0XdAUTErcnoB/1qBpc59xg9tD0j4KqCARrLrNSXbbOxNTcpPCBclPBl2UmJr5quI7/29ne7Ukctp84mcDoNua/I3rq0bowVQ/yeYy2eC6ySNdufzoTklgsX0Xc8j5OqtSBtBNQivj/Q5iL/UNdjCS+yf6F0lgaBss2h/7OYPEneoJ0AZH34vPzOcTQTYK//VbijIqV3dhRLLuXR9SaTBOCd8El8SxLKt2YoI3pqVqpSshG7fVO/lGUp9WeYhqBvYMfSHwM7R+sByvwLNhUWywGynTl9XbId3TRbETTjUNtI29qWhn94DcEsONuk1VpWCBNXvh0qjIXxVuCLpQbJaJ56o2ZI+L+4sBXPHvdssBxTQuzraaHtVRmZdm1mOWW5GWmyWzpUMQkI3b9d65erVwXzyDbXB0rCyQxXLPQcLtisQfvwpwvHrARLUB0JCyl5IXPKEsUFoP/Oh+8uCSQWQj6ZO/rkRjkkbQsArFMQ9PpruwVSh6dU0VJhh3szR8sTbb41/prCmUMWYd9REl/gzi/Aqz1X
 hYTshi3p
 gpx4mQ6HJIP6JGIIKp8AOKC5nt5JFemm/wlVow24qsHpc5d6jWpyN3oopQuXhWw/EICDfFsym1iO73Pa2yDDSeogLvtNEMi2fQc9etynae2wQ5JaZzlBNiLVcXQ3L3fubBN++I2DNE+T12Q5LFxztB5XsL1aHNJzheNS30RSO6XtIIKnJrZcgnbyGUEnpdhGrMB+hScarN6mC3uNF1XebL74jgML1J/gw59vlC6q8imur/GRvPpnlp6WPeVYc7nzDcLUnJ32+Qdvt+n8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 09:22:51PM +0200, Peter Zijlstra wrote:

>     mdir = mailbox.Maildir('~/Maildir/');
> 
>     for i, r in enumerate(reviews):
>         inline = r.get('inline_review', '') or ''
>         if not inline:
>             continue
> 
>         author_name = r.get('author_name', 'Sashiko Reviewer')
>         author_email = r.get('author_email', 'noreply@sashiko.dev')
> 
>         msgid = msgids[r['patch_id']]
>         subject = subjects[r['patch_id']]
> 
>         # Create the Email object
>         msg = EmailMessage()
>         msg['Subject'] = f"Re: {subject}"
>         msg['From'] = f"{author_name} <{author_email}>"
>         msg['To'] = "peterz@infradead.org"
>         msg['Date'] = formatdate(localtime=True)
> 
>         # The critical threading headers
>         msg['Message-ID'] = f"<review-{i}-{msgid}>"
>         msg['References'] = f"<{msgid}>"
>         msg['In-Reply-To'] = f"<{msgid}>"
> 
>         msg.set_content(inline)
> 
>         mdir.add(msg)
> 
>     mdir.flush()

So Ideally I would have 'Reply-to' header set to the original sender and
added 'Cc' like the original email. However, AFAICT the JSON does not
contain this information, and while I could use the mdir object to find
the original message in my Inbox, this is incredibly slow.

I have a TODO to use python-notmuch to do this, but haven't gotten
around to doing this yet.

With that 'fixed' I could actually reply to these messages and it would
all 'just' work. For now I copy/paste when needed.

