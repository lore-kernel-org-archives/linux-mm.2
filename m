Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9801CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 17:44:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02E196B8001; Fri, 22 Aug 2025 13:44:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F20018E009D; Fri, 22 Aug 2025 13:44:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E10E06B8001; Fri, 22 Aug 2025 13:44:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CD3038E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:44:20 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 82FF157B6A
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:44:20 +0000 (UTC)
X-FDA: 83805117480.06.207386D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id E72E110000D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:44:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vFZeOZTy
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755884659; a=rsa-sha256;
	cv=none;
	b=Fj0GQqaDgU9lI2U7dme4xl+jCkkgY6k4fpGgZff056flopeveVzb+Vnwo6gcHnSfy0bWIj
	Af/TTz2pZz+neB7rWc57/42kR3Doo/YILrKLORfjQkRNZ7S0CdyfdS3T6xotGL41fwrBXx
	TSmYMYWhQyqIJ/wo9nq/xEE4yVusI38=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vFZeOZTy;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755884659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oTJjicaLJIAJUskoLvi8hPpWtcjqd5f2viAMGrcaP2k=;
	b=ib7ZUOSg5rGksN94HDXeGIN8qNhTy0Drm8Bqk/RTQP6zAMwurSBX1NjqfZP1MQzIHZ82Vs
	J+047uSTRAINeUpMvM9+hInVqI9Z/mm8DeQjmdRFGbN4SOhdkagWkmz6oq/CVaXbgPQ6mX
	qLIRgNw8Mqc/mLd+vWpk/PAo72BXfPM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oTJjicaLJIAJUskoLvi8hPpWtcjqd5f2viAMGrcaP2k=; b=vFZeOZTyAO289lSSB71sUt6gZB
	0azEL/iAAphj41V/24KeFpAICY6Bom7PP6OnoHsBKpmPI198Ep+4SJ8R7vybYuetXCgU995YhU4AS
	SM/JfEis1gbqev05PEOPnxXjz7PYeNMQ5Moib4kIsM0eDUEHfcpPVs6r6ZssJXv5RZBBy2/kBBASO
	c3lHbFVFZWz2hACto4ESS5Z1PFvDsplNg9KrmOschrtQuzmB+Xs4XNwkNCKzTnJ6MCy9Sf23gzgk0
	DvWG+IS/5Llh57rcxgfcjiCIz/OTUzxl7exOnK2s0sEXSQdRacX0WDacdty9A1kinQMHrkyOv+FcM
	Hm/ks5Dw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1upVoE-0000000AnCH-0Ctc;
	Fri, 22 Aug 2025 17:44:14 +0000
Date: Fri, 22 Aug 2025 18:44:13 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Harry Yoo <harry.yoo@oracle.com>, Zi Yan <ziy@nvidia.com>,
	Barry Song <21cnbao@gmail.com>,
	"open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	android-mm <android-mm@google.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Jann Horn <jannh@google.com>, Rik van Riel <riel@surriel.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [DISCUSSION] Unconditionally lock folios when calling rmap_walk()
Message-ID: <aKisbbkNcuZoT2RB@casper.infradead.org>
References: <CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4aDx5jh2DvY6UHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4aDx5jh2DvY6UHg@mail.gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E72E110000D
X-Stat-Signature: bqkequ9ntwrmnkmqmdqrjq7jre6d43k9
X-Rspam-User: 
X-HE-Tag: 1755884658-137869
X-HE-Meta: U2FsdGVkX18Copx2vfy2K27WLKBsCNQzymIDloOfZB0w/G1pzYZyRr2q5u0hugjH6SJSe1gaj9w3jF8yM8PRCt7/raF6UE8s8Vls9qRtcr2EfZhK6WQMx9hzjVjGGC6G+amti/rxZQ+L6TTt9LeUOOhSvOvQK/wWwMdNV85a1zxEweFKF2LoVvVucSweso+e6aQMhUWN1J0P0jGFklPfmFo+D8C35kx2I65eG4Ij8BGeXx1vqHh0qcSIu3me6jbYAyMop0Cov5n0DjTKg0B5R7uWBG1wOKhkk7ZdbSiHmp2aq8qr3oyzdpJ1PJQx+W8jusp9AuCRIHrrI7SQgdYqfBkEmvBv/u9I7uMGyxoqOQ53o7ilF1MCK50ljdWCMWngYm8RaRhT5ocDPT293b5dAkP8AKSyDn1x53t2JUfKWn7DegBZ8qj1QXCAtpWexN6s9SC7A3RbVimQA/42rcN17ISrVs8MWIAaUPU0Xj8hn276+3DkjyZEZmKJJKmh2MONvs3hQl4dtQf3lL5nndlpsyZeZzjHGpByqdfnQaBat7zfuzYrnSZbYTLt+0uqN2oea4lylIb1u1/7XtACJT+9wZSi8NqhFZ1RtIPqOxhUgE18ul3aKvLNgT9VVT3Uc7CZCJTHFCwutnTT2VADS1WmkcXwrdvBrUpt6qq40GCAIaY7maf7sRntl/htYh4VrOA9goVwAJ8erZGYRGSG2v83OLxPVNsPaUxtCL9mbF2AVD8kFbQftctdiZFzv6SjeBuh4r9l6VIxJoCY723Xn2X61iQCzuFZyyxKikIomWGTCnYiBLx036vMyGmkbnMza9c/vV5jhJT8pRG9UZ/9XxsLVAMrjNCdCk4sZzgDVBYzsLOc7K+jjiwqry6hI2T2xCgUtsIckJ2dE/0WOBq3Wd6gWWvofqLe8/eq7w04OFmY0/cVCdRtYPqmaUn/z95RqoFjaDa1FZ4NjhQ2Hc2GK/N
 FOZTVOnH
 qez6z5U4MsjH+K2z2IR+dZjSZv0v4YbctwhgBqmNF/KajBT6s6cRS6GcpLlSZOGJoxVQMzqBJxb3dA+j2r8YcSUSe2vJfqtJ70OriEGEZ+l4rekFe0GsCRKYomvVSq0HpTmfa/rc/m9tmBEj/bb2E1gnWM/QvRqBMvRGm+PerqKmj2EYQ3qYfYPKDly7Lmk//GLTqdATVNP622Q+GOvOMPx+gNl1XsZHEX/uCxop+Yn/5dXCj8f8P9nWsaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 10:29:52AM -0700, Lokesh Gidra wrote:
> Currently, some callers of rmap_walk() conditionally avoid try-locking
> non-ksm anon folios. This necessitates serialization through anon_vma

... this seems awfully familiar.  Why did you send it again after
a bunch of people had already said useful things on that thread?

