Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C36F8FED3FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 20:12:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F12536B00A2; Fri, 24 Apr 2026 16:12:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBB836B00A6; Fri, 24 Apr 2026 16:12:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAA366B00A8; Fri, 24 Apr 2026 16:12:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C4F9C6B00A2
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 16:12:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E6417160387
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 20:12:14 +0000 (UTC)
X-FDA: 84694546188.27.4D82DB2
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf22.hostedemail.com (Postfix) with ESMTP id E054EC0008
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 20:12:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=ffWhi37p;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf22.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777061533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R2gaRjg/CIye/6fA05gchsWC8RdbQ511C4bcMcmE3UY=;
	b=5iZ4jlQfQWImMSjdMjz4wg5WpXixJ9+eIjcBJqF9QOXEBR7Iy8tFwFsCD7EX3pDf6lc0IE
	OXVCVNLNvEHmvSbrBlARkkdcq+49in1U3bJbEFtk4tjzj7nqS1p6TjpeyjLgQX5ax3eFCV
	Bv5bZmf9ZyHHNQjSHcT1Wubr+pYuca4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777061533; a=rsa-sha256;
	cv=none;
	b=k0cnEXg0zcoigrBSemZBhD8PFAdLwJATilLYzc5QGiQH8I+zcWzc2tjNerQOJmnJrIjmT/
	upBNkTQFS2wd+uRyF4AbOfLolZ9v/f08jut2XcseTiWWcplwpvD8y0V/xUfCDWpuKb9G7B
	SBdQQTBL+AQfn1OqYY3fixc098aLNiQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=ffWhi37p;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf22.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=R2gaRjg/CIye/6fA05gchsWC8RdbQ511C4bcMcmE3UY=; b=ffWhi37pPSombHmnM7V2siTel6
	XhOcC9uho2ip4uKGHzUY6KCWyA25VVTTIu+jmD6PKyw7uzEPPidXyBdTKpBF3db7hQ2CXEirPYM7d
	mbOuK3/bq1/NWyyf7j4gAtJ1dikM9FQ4urbzO4xcmkGKMjK19qdLVoy75SILKV6DKjQOZ7IxoBCRw
	rNusdzBNhnsOrlUg3KPcYHo++EPYC918x1pjSWji81mw1OCWux+8lta2a/0fBTFCp+0rmyJMk+gYJ
	LmthHCuq/1mMFIcTpOpWJ1LoYXpqHHM/ov0DGrQ8OFeuJl/s4tVY3n3GMvDgz81Lb4EvvDnwfjifb
	07TEMcGw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wGMsb-0000000FR5i-1WST;
	Fri, 24 Apr 2026 20:12:02 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id D3EA7301142; Fri, 24 Apr 2026 22:11:59 +0200 (CEST)
Date: Fri, 24 Apr 2026 22:11:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>, Yosry Ahmed <yosry@kernel.org>,
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
	linux-kernel@vger.kernel.org, ioworker0@gmail.com
Subject: Re: [PATCH 7.2 v10 0/2] skip redundant sync IPIs when TLB flush sent
 them
Message-ID: <20260424201159.GD3783056@noisy.programming.kicks-ass.net>
References: <20260424071533.d28ce90126f05e1c6fc1b740@linux-foundation.org>
 <80ab39c2-efb9-4a23-bd56-46d9bb4e41bb@kernel.org>
 <20260424073145.b990fe9b925da304508aad71@linux-foundation.org>
 <644e65dc-3d39-4137-b51f-51d953b67d50@kernel.org>
 <CAO9r8zN1pRfyC0Rh+UdW-Lsret=z3oveT3=gnZftX-Sr_ubyyQ@mail.gmail.com>
 <20260424190141.GA3783056@noisy.programming.kicks-ass.net>
 <E375C69C-557E-44EB-9B3C-618C9F7BA9D8@nvidia.com>
 <20260424192250.GC3783056@noisy.programming.kicks-ass.net>
 <20260424193529.GA3853824@noisy.programming.kicks-ass.net>
 <7ia45x5gktx9.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ia45x5gktx9.fsf@castle.c.googlers.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: E054EC0008
X-Rspamd-Server: rspam04
X-Stat-Signature: pnrzkhceo6hjixxj7o9srh8rwe9wrzb4
X-HE-Tag: 1777061532-978897
X-HE-Meta: U2FsdGVkX19s1b/8gBnLiSWeB/TO9OEXfp7NjkUVoQecRQpFXu00usgK1zO8lPE+PNK9IaVOYOxsiPnqiHt/hSckvkttirrM8UGuw2iv5YvEL2PmGSL08WcbNtJJsKbO4dlU6HgLjZCZLZqNQX1B1HTUcXJkkD46IC9N68YvhXVdfRXw1WRcco/bhWaZHF4gBIgpJE/JOApn0dfhWZRoHmXwUQl3AfyMfBjwCTUt0fJpQ7OJtFKSUC1PsXJ2lR2tnQZrrrjb58w1CIJQyrQMEUPsWsM7wn1WN/mvEBMVCKiPHeiImVbty9CxxE5KkRSr6nrtE16Vnz51mpIoX3UPlliGmfDhhSwGr+wy8Up5k5tUH/ZYISnv0tAjLXSRmeklBkTrF4/nwzvIx35lqy8+ZtoFNCbFuPv40fwNVUqXoDOv8tWZKeUaztkICr+AJJ3mDxCRrl1TTdKFb2NYdrJ+P3G4K5TxcPHP3+qujMIsYt5yrja5AbKzLJiCDrRdcx04vRQHuBLxSphQnZIZP1CgTO/p83Q7fofaFBGCBk92bx0uulkExUZjJv+/lryWH+YTx3kmzJs5CKYnMU9N1EC7M2GMCW5sZgrwazeDTK6lUrr0P6gveOIx1DxHX2i7M3OqxuUINSd+4laAkwvDoXjE553/Rnr6k4XviAXidCEsG31l8k8vZnd+2IobK1tye8+urI7RYxXEhwoU+W5Fikdz1puJHoo5Z9OkfiukvsigFJemFhAEZWVKAykYdWMj9nTrJ9YZoZOgKFh8Nde9Pg21pj3AAslBrwrJ7Q2gS/TSPoCqfcTM3DVB5m+RJGUQrg1yJwKcmt7S26dByerosZMNaw1r9UPyvRjQjM3zEcyVg0+cx3MgnRIE/gs9VD3qFCp5MJo9vR2RUO/zi/g7YKgY5Mfw5PUX2+wUsW+SAQ4XN3I6iLcCpoK9T1iidSkjxr0VSU4cp39rLdJ38bDttIX
 Qzi3F0bN
 npZApQrv+15D5nAN9mKyocZg6k0W9D/KpYHeBcq74dHdEK0eQwEvkaIwGkp1PemuT4WaR/IvikPIIiyogjo5IiOnzyqQhRVXcR0lMugkOto4skPiZXn4s5v2X7YMk2HVRWsws0Sv+PTGmsKvu2ld3K755gXV9vnDHTT7sSb//BYKQ1hS4KN/lRSFbY8+5XdGUBza6d5oPdP5VUwvAoJcD45Dc2fcQwuvktN5K1wBCVUKs05gxEP3I5+y+a/Nn3SeGsUG1icpsq0VXIzk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 08:03:14PM +0000, Roman Gushchin wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> 
> > On Fri, Apr 24, 2026 at 09:22:51PM +0200, Peter Zijlstra wrote:
> >
> >>     mdir = mailbox.Maildir('~/Maildir/');
> >> 
> >>     for i, r in enumerate(reviews):
> >>         inline = r.get('inline_review', '') or ''
> >>         if not inline:
> >>             continue
> >> 
> >>         author_name = r.get('author_name', 'Sashiko Reviewer')
> >>         author_email = r.get('author_email', 'noreply@sashiko.dev')
> >> 
> >>         msgid = msgids[r['patch_id']]
> >>         subject = subjects[r['patch_id']]
> >> 
> >>         # Create the Email object
> >>         msg = EmailMessage()
> >>         msg['Subject'] = f"Re: {subject}"
> >>         msg['From'] = f"{author_name} <{author_email}>"
> >>         msg['To'] = "peterz@infradead.org"
> >>         msg['Date'] = formatdate(localtime=True)
> >> 
> >>         # The critical threading headers
> >>         msg['Message-ID'] = f"<review-{i}-{msgid}>"
> >>         msg['References'] = f"<{msgid}>"
> >>         msg['In-Reply-To'] = f"<{msgid}>"
> >> 
> >>         msg.set_content(inline)
> >> 
> >>         mdir.add(msg)
> >> 
> >>     mdir.flush()
> >
> > So Ideally I would have 'Reply-to' header set to the original sender and
> > added 'Cc' like the original email. However, AFAICT the JSON does not
> > contain this information, and while I could use the mdir object to find
> > the original message in my Inbox, this is incredibly slow.
> >
> > I have a TODO to use python-notmuch to do this, but haven't gotten
> > around to doing this yet.
> >
> > With that 'fixed' I could actually reply to these messages and it would
> > all 'just' work. For now I copy/paste when needed.
> 
> I can add an api to return a json with the review and all
> meta-information by the original msgid, will it be useful?

Oh yes, that would be more convenient. Thanks!

