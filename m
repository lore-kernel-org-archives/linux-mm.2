Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECC76CD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 11:10:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E85FE6B0005; Fri, 29 May 2026 07:10:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0F596B0088; Fri, 29 May 2026 07:10:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD7756B008A; Fri, 29 May 2026 07:10:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8ED46B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 07:10:25 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 465951411D7
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:10:25 +0000 (UTC)
X-FDA: 84820188810.25.4F9A90A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id C6B161A0009
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:10:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jD0ZTL7V;
	spf=pass (imf19.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780053023; a=rsa-sha256;
	cv=none;
	b=uW3xdo5M8AbzEhW4sAWo9r1hMqY9s56YuOsDV/nyPdLsMnLjNQm8Bl1VWvjcCd0DW4s9gh
	uLmf3ykldLGrfIGngRZVBsZ2gQPHxBKcg7cOyk4K0oEZIJQBp7BWJeptunYiCfS4eD890w
	5vyG2ZAM7RBBMi0sZyqh5dIMVngUzbQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jD0ZTL7V;
	spf=pass (imf19.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780053023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nRkEGXP11hFVJhyK9fz69KbA7K+xdDcBYB3fNOZPNoc=;
	b=sBM5+0xEWE5BfLZnoMDyuJbRhIpOkk0L9uIp8TS5kOoteIwGsVWx4eNn9nnJYtEFvOjRyn
	FYGk8Fp8zdDOQnAnw8keBMc7GTq4zrKh+MQxkpa1hlnznQcijRSgcUlmtrRkvTLUR8Hxna
	wTxBn9JwuYfCg434dDNxUIwb+OWsKJA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nRkEGXP11hFVJhyK9fz69KbA7K+xdDcBYB3fNOZPNoc=; b=jD0ZTL7VZL3PdRN8lqnvI7EMm/
	cwIN41nkcKFCkXuhq9JMAaNjzoF5EmP/5hSA05BsKqCwFXKlPpqQ3u5dKlnO99GUuV8jyO/fBaCCB
	Z0Zwa2NDhkxXBQYRoGqPjbM7LC47WJhSdvG3dKwaq7/KYnyZGmGCvZAMOKGQ8A26r1pfNONyyvwon
	BsJuSJfYSNH+AGaBXjF2Ei01nwJmWB36T8VzStOmpSdRy6iK2xTXjFsRIqCr+oiIoUyBpbHvtX2U/
	e9OfFFdrv44Dl78xJDJ48IN6BEynEF9gXrR75FToAdOYZyF/e2EQRuSseX39PW3HzEDSJ/tATWsdn
	VCnlsYlQ==;
Received: from 2001-1c00-8d85-4b00-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:4b00:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSv6S-000000060Uo-2N4R;
	Fri, 29 May 2026 11:10:12 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 06D5E30036F; Fri, 29 May 2026 13:10:12 +0200 (CEST)
Date: Fri, 29 May 2026 13:10:11 +0200
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
Message-ID: <20260529111011.GH3493090@noisy.programming.kicks-ass.net>
References: <80ab39c2-efb9-4a23-bd56-46d9bb4e41bb@kernel.org>
 <20260424073145.b990fe9b925da304508aad71@linux-foundation.org>
 <644e65dc-3d39-4137-b51f-51d953b67d50@kernel.org>
 <CAO9r8zN1pRfyC0Rh+UdW-Lsret=z3oveT3=gnZftX-Sr_ubyyQ@mail.gmail.com>
 <20260424190141.GA3783056@noisy.programming.kicks-ass.net>
 <E375C69C-557E-44EB-9B3C-618C9F7BA9D8@nvidia.com>
 <20260424192250.GC3783056@noisy.programming.kicks-ass.net>
 <20260424193529.GA3853824@noisy.programming.kicks-ass.net>
 <7ia45x5gktx9.fsf@castle.c.googlers.com>
 <20260424201159.GD3783056@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424201159.GD3783056@noisy.programming.kicks-ass.net>
X-Rspam-User: 
X-Rspamd-Queue-Id: C6B161A0009
X-Rspamd-Server: rspam03
X-Stat-Signature: kyk1rini9sa3b6cu1ssi4wextxiafhbr
X-HE-Tag: 1780053022-900105
X-HE-Meta: U2FsdGVkX1+eFF+PVs1xbEuOWQJAossXhHOgFCWBElRlrJTVmJAAu6KM8zLZWuia5p6MwKEcN5S0qfuU5yoaypnEK9gLjX8M2gG7VV6yUJXJN6yGO8DbK8sit09FTnYXjgoMIEMKqUAInLbv01AR+gwvjzYAjUb43ZrzMZk/MZ0mzctY9C+JCX5pJK8p/+dKCUIY1pJrRKJlhVzGA8gzwi/jccPHX5ALbmjLZgtLfYPIHk67BVmhgtnMD3O7LdjdK3Sb3H+jP1WpCBQZX1+DZkx+vC7pMqkJAg/JcKC8/kXI8GhChQfiuoHse+rRuU4G1+0skSIsmMkBZ7M3DwyR2N+nX1F/v/YxbjoupWbydHZIcaPXky1S44AM8fJfXRvIim6EmnRVLHG1DiqKDIoCyHdgM2RVpGhSrofit8X38U/RPOXUtTUWm5eCvdL2EM1TJ1zZJ9Mwl1GFaCNQPZ7eJ6KgPgYraLLghUJa5x2AN/SWIgOnVpMf/YS2OEcDxSbBUkB5F93p/OCKApcQt6EjVA9J4OWhJ4/btllaqSWxbwFn0arvYDyaDuAPq6m+O5wjergsXnP1ITPk/rCCGFemt4XaVqJVc19BxAtKI0UaVSlxpGwbqsaPfurRFWTw7SakGw9QmfLcSLBvGdo03lEIIT+440FX1qbUiLqCT9y3G782UJktNk1Ha4CRTz3Zkqz2D6h1dc3GzphVWu6V1i1yG2Yg64PPVhYPdUNC1yRHZLIqnSDh7MfZvXIMb+ouB5IKELeRpitx87HsiOHylWWUKwykHlkmiQGRY8tu5WPxh4qywbSHhVWlKuDr1zlF460H5Sf4K3VBHiMHBEh6toBJt04TWrViDG1awWiDP8KoMJ4h3SFyq2D+txk+DzDMYs4ibtNzN+JIykEFum5fK/xBVZ2tDRY9FrtLXVWhIdCjJU5DKPB//e02i/5Kdw4gYcXN5cz+JToVMM1dQx56qFj
 R0I09tI8
 1ivJ8/jGgg3oovFXCwTeRgftkvrZhruW4fXEEw5+L4Gf/oMY9zWRXyew6iu3m9Wt+M6jBe5YwMVp1AyJzP/3BLqanETDAPrb2NmYQBM2fMRKH4tVp8XokMdURHa1B4vF6FhXYwtkc7Mwq83qJkaV+J3V5PAaR9cWTpsN0CdFUgBNa5lskcuwI1pn4ZpZwguYAPcRPD4GhMwzyfV774l90jbJIGCbfT8Anvp5XC0Qhp39IKypbi/N0cPSMpTKhjcpUMOIDLqCLX4n+Rt/J4c6rQK2wXwYASt4x3zggoMtdr/o8w2zuj+6iWjVxtDDAZsw+Cf0B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 10:11:59PM +0200, Peter Zijlstra wrote:
> On Fri, Apr 24, 2026 at 08:03:14PM +0000, Roman Gushchin wrote:
> > Peter Zijlstra <peterz@infradead.org> writes:
> > 
> > > On Fri, Apr 24, 2026 at 09:22:51PM +0200, Peter Zijlstra wrote:
> > >
> > >>     mdir = mailbox.Maildir('~/Maildir/');
> > >> 
> > >>     for i, r in enumerate(reviews):
> > >>         inline = r.get('inline_review', '') or ''
> > >>         if not inline:
> > >>             continue
> > >> 
> > >>         author_name = r.get('author_name', 'Sashiko Reviewer')
> > >>         author_email = r.get('author_email', 'noreply@sashiko.dev')
> > >> 
> > >>         msgid = msgids[r['patch_id']]
> > >>         subject = subjects[r['patch_id']]
> > >> 
> > >>         # Create the Email object
> > >>         msg = EmailMessage()
> > >>         msg['Subject'] = f"Re: {subject}"
> > >>         msg['From'] = f"{author_name} <{author_email}>"
> > >>         msg['To'] = "peterz@infradead.org"
> > >>         msg['Date'] = formatdate(localtime=True)
> > >> 
> > >>         # The critical threading headers
> > >>         msg['Message-ID'] = f"<review-{i}-{msgid}>"
> > >>         msg['References'] = f"<{msgid}>"
> > >>         msg['In-Reply-To'] = f"<{msgid}>"
> > >> 
> > >>         msg.set_content(inline)
> > >> 
> > >>         mdir.add(msg)
> > >> 
> > >>     mdir.flush()
> > >
> > > So Ideally I would have 'Reply-to' header set to the original sender and
> > > added 'Cc' like the original email. However, AFAICT the JSON does not
> > > contain this information, and while I could use the mdir object to find
> > > the original message in my Inbox, this is incredibly slow.
> > >
> > > I have a TODO to use python-notmuch to do this, but haven't gotten
> > > around to doing this yet.
> > >
> > > With that 'fixed' I could actually reply to these messages and it would
> > > all 'just' work. For now I copy/paste when needed.
> > 
> > I can add an api to return a json with the review and all
> > meta-information by the original msgid, will it be useful?
> 
> Oh yes, that would be more convenient. Thanks!

Roman, did you find time to do this? If not, I'll patiently wait :-)


