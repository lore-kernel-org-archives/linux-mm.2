Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA9EBEDEC03
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 03:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AAB06B0089; Tue,  3 Mar 2026 22:24:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26AEA6B008A; Tue,  3 Mar 2026 22:24:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1612B6B008C; Tue,  3 Mar 2026 22:24:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 084B16B0089
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 22:24:32 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9A03B1C446
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 03:24:31 +0000 (UTC)
X-FDA: 84506937942.15.1FBEB5F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9225610000E
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 03:24:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Y55ilsFI;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772594668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uwaew1TASwLFpWF0VG/+hJg8qwclvjQWd4Xpfif75xM=;
	b=CodGcQ39oUGavbz1IS06ou0Uxp9mqM8nEh8ykDE84GNfnbRcgd7bKmhGKx+xpqz5XwisHT
	SwvKgmGvCfWq6I2uWAlHblaC2V8gDY8X/XMTEKtEvSmOoQx5orQotOMsseA3hIvHd1a5Pe
	UDw3Py/ZsecOWZ+dcqALzSFxlR08D9E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Y55ilsFI;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772594668; a=rsa-sha256;
	cv=none;
	b=udtcULsjuhfalmAV5HetQT9mILNA5bfkGYihEz48ePBCYU+R1+OJFM4V7HD2OfBNdhaCUP
	ZenNtPQQ87qWxMMGbWpMBnFa8TVJIPof7SyfOSB42ZUVQ3EA8CVuyWffNp/ZxtTNHSzE9c
	r3UxZzRfHKn75orvB6cPsHdGMkruDX8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=uwaew1TASwLFpWF0VG/+hJg8qwclvjQWd4Xpfif75xM=; b=Y55ilsFIY2uEBOFXIvrtEYMcxx
	V/JrCLDxgjkhM/9AmmOM6p2YDvZEp3at1c81Mie4L08hbvdW5XczTSkOpKUYldRXpbRkzcpST75rE
	JSYtWs4lPnRkwt7VLpWnZS8EYTQrG9i0BWDSDV+inn6J4BRublQVBcsZz3JeLdeZOhCHNoqKY6jbX
	slhEqOeUTLTlm9sVqBgehi2kNsWbfS4dhEWJs3o+XtyJnOKyJLFluQ6KxU+iVO6wjIpviTd1Jv27X
	wgrr6MdnWMKHkAWtXiFA2/xvfrUlXJBSn38A1vOyJKFa1OXMKd+jiad+JQnbO2GJUwecYvLglkRKO
	MBiTn2xw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxcqD-0000000Cdoe-3gHX;
	Wed, 04 Mar 2026 03:24:05 +0000
Date: Wed, 4 Mar 2026 03:24:05 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, akpm@linux-foundation.org,
	david@kernel.org, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz,
	jannh@google.com, rppt@kernel.org, mhocko@suse.com,
	pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com,
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org,
	borntraeger@linux.ibm.com, frankja@linux.ibm.com,
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
	agordeev@linux.ibm.com, svens@linux.ibm.com,
	gerald.schaefer@linux.ibm.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: Re: [PATCH v3 2/3] mm: replace vma_start_write() with
 vma_start_write_killable()
Message-ID: <aael1XWaOJN134la@casper.infradead.org>
References: <20260226070609.3072570-1-surenb@google.com>
 <20260226070609.3072570-3-surenb@google.com>
 <74bffc7a-2b8c-40ae-ab02-cd0ced082e18@lucifer.local>
 <CAJuCfpHBfhKFeWAtQo4r-ofVtO=5MvG+OToEgc2DEY+cuZDSGw@mail.gmail.com>
 <aadeHiMqhHF0EQkt@casper.infradead.org>
 <CAJuCfpFB1ON8=rkqu3MkrbD2mVBeHLK4122nm9RH31fH3hT2Hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFB1ON8=rkqu3MkrbD2mVBeHLK4122nm9RH31fH3hT2Hw@mail.gmail.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9225610000E
X-Stat-Signature: yc3u4ajyu1pnpf4qmh1cgbdn4uohguaj
X-Rspam-User: 
X-HE-Tag: 1772594667-549994
X-HE-Meta: U2FsdGVkX18LiMgOfav/BvkHC7OnePXrCZBXvWLFkT2sUnuc3zvSaGWsKW0npgSZi9pnexepdNB20fYrU8EMm7RrEI1nTmw4PaqFv7e5XgzCf1z0EtLlVd8aZ0JZAQXHYyNiDTDtNuR6Emz0z2pM5y9pe3KL8YPjlGIuu0tCpTJjbhGSm4M0xWRYgdiS3dI/w58Re29PFX5RhYs+UtbAVU3j+KsJosYO2uwIQBejmTUphAqOoNuIypq5vMCa6yJ9FAqpjeUg+dsI/pfhe005/JsRrmO1N9Z+EYGvxR5btc7At0lZLcFpuQkEshqInmKm1x1C3xbB9vvJ8RaZE7s8MuV3VBwdM3bFhK2PKVB1GRKxHvbERak9N1jiN61lVW9BLoNtM1Coct1keAaOXJLzZfP7dEMnUA7pqrtz3icUzIDUxDMQIG8OtphsPmU3I+jBX7Zrt4CHrmqzF3mjKP8Twy4e9dyT3kKsZSteORHb4udu40T1MECzSlRQ2vsZ3PwhvzjunRJ80Qy6BiGYnA4gMTtrHXSRzcqC3d0U61Fl1MHw9xruPYgn741CFzxtN7Ud7y8KoKSkmgy3LWscWk3Pv9h4UVY5R0KF4qG9hh63A4qMmBdChxkYVFAy0PFWQg++MOvGYlxW3J3AmMa/1hVsrSyjRBhwX1ACFOuUBkmWn30nbyDNk+xJIbfkZxschGo6JXTGdH8SpKdAiMbqaosmdEuXciSIJNHTo6e+icBZ6QmASQTuwoEDh6gZWKBM6ZDNZGrk9L5Eb/txGUxPlh2OvTqlWOAGXaA6NrMD2bsMjzG+wuFo9a6qzK+ilRClx0YBkmYbU38kgztpL5PY0XOcaTE3MiwQJbNMvWzofbuLD0kVP02HvtqfhTmlj/4eTeVqXx6TTVeN6EXzZ/xKs0qi/eQISoMUzPNyCGKJlqaZx+91piJd0DddKC7rnmNXQWMAhTflCvfj2eDvRMn/CWJ
 bL06lfdz
 GoqI1wWOPZrv+LIJ2+s9QIX/hMeAkFMij7RDkOtyhZEd2I4ZiUqaY8ZdgYaTzOm9A3WZzjZoYtl2lJAk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 04:02:50PM -0800, Suren Baghdasaryan wrote:
> On Tue, Mar 3, 2026 at 2:18 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Tue, Mar 03, 2026 at 02:11:31PM -0800, Suren Baghdasaryan wrote:
> > > On Mon, Mar 2, 2026 at 6:53 AM Lorenzo Stoakes
> > > <lorenzo.stoakes@oracle.com> wrote:
> > > > Overall I'm a little concerned about whether callers can handle -EINTR in all
> > > > cases, have you checked? Might we cause some weirdness in userspace if a syscall
> > > > suddenly returns -EINTR when before it didn't?
> > >
> > > I did check the kernel users and put the patchset through AI reviews.
> > > I haven't checked if any of the affected syscalls do not advertise
> > > -EINTR as a possible error. Adding that to my todo list for the next
> > > respin.
> >
> > This only allows interruption by *fatal* signals.  ie there's no way
> > that userspace will see -EINTR because it's dead before the syscall
> > returns to userspace.  That was the whole point of killable instead of
> > interruptible.
> 
> Ah, I see. So, IIUC, that means any syscall can potentially fail with
> -EINTR and this failure code doesn't need to be documented. Is that
> right?

We could literally return any error code -- it never makes it to
userspace.  I forget where it is, but if you follow the syscall
return to user path, a dying task never makes it to running a single
instruction.

