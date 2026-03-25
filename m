Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E40CA109C033
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 15:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3320E6B008A; Wed, 25 Mar 2026 11:28:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3096F6B0096; Wed, 25 Mar 2026 11:28:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2470E6B0098; Wed, 25 Mar 2026 11:28:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1554E6B008A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:28:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C7386E0E07
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:28:43 +0000 (UTC)
X-FDA: 84584967726.17.5C9696C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id 33604160002
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:28:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=g+6UZMLU;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf08.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774452522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aAaE1cmct4Ax0hsF4P3343EFIFASkKmlY++QqxjAvYQ=;
	b=xdc8H+YmGuk0CHfZPC07KuMDhxFtXV/6bb0jFujA2pkpWT9k6u4yfYX6WL6l+IBAiyg+wz
	7tnjA4lBiyzfmH+Yi2KyJKsMUAR5x65Qck65hKT+VQBHAAcuvkpVEUbKD6i4yTB52ppgnz
	ojzGoeXB4Sbh9Oswg0UiPVga7oNZZ9A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774452522; a=rsa-sha256;
	cv=none;
	b=6DpD0lZ1qK3LceqkmmtBOcKw6MbGvE3fbNcVuZMetU3tntRccrK5PGNJL+AOtw+1dmvLxv
	hYkncGij92j2DB78ktGi7+dX9S20UTMc4+IBwnqnjnFrBwtb7O2tPbbgcwYYOaC3OJ3rL+
	nnbEoV6r95VVdaAzHAdlS6L+YJoJNAQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=g+6UZMLU;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf08.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aAaE1cmct4Ax0hsF4P3343EFIFASkKmlY++QqxjAvYQ=; b=g+6UZMLU6OPQTahV7L1Or45Qhk
	teEyLF1KRx8BhTgUFvG1thOrA1Xv0GZL6YaRCjndq9v9zKSpSyX6ou8ICcdBGBBt2gBEEwAgRDjnk
	PtSWnYIjviyGCH3Txk7PIepvcN5vclndlCx73JxK1M6bA5HEkt0zlsMjK0GfI/mBQABLEohi6D9wN
	NaGwB67xEeqnq6I8KGxoIGBetL8nMHS2PwDgTU6Gv96qYVQLWqjs92rNs3+eVO7ctO1ac3C3ra9xP
	5PTIiliCrujAHucK5CVuuROFTGwuQruIicSlp8xf9k+Mr2TWRXMZMFUh/3WNRQ+3GN5diElo3g0Xd
	CijWneog==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5Q9l-0000000G4b2-2rml;
	Wed, 25 Mar 2026 15:28:30 +0000
Date: Wed, 25 Mar 2026 15:28:29 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	"Garg, Shivank" <shivankg@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/migrate: rename PAGE_ migration flags to FOLIO_
Message-ID: <acP_HVmrhP9_6s7j@casper.infradead.org>
References: <20260324114720.864478-2-shivankg@amd.com>
 <54398FC0-2F68-410C-B9C4-2802810C119B@nvidia.com>
 <41cd005e-3702-4c67-8d32-0c09274194e9@amd.com>
 <cb383f3f-b74c-41a8-a77d-d00e93b7fe94@kernel.org>
 <f844a2ce-105e-4002-a106-b936ddd98a99@amd.com>
 <857B5E73-94AC-41B9-A3BE-953E59A5DB40@nvidia.com>
 <27b1b602-129f-4bc5-a553-386e8d1f5d90@kernel.org>
 <539EA481-9CA0-4B2A-B0B4-C254E34BA7EC@nvidia.com>
 <218144c5-6f51-44c9-bd70-e171005d3606@kernel.org>
 <925CC2D7-D525-4272-A01D-2A1E50127401@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <925CC2D7-D525-4272-A01D-2A1E50127401@nvidia.com>
X-Rspamd-Queue-Id: 33604160002
X-Stat-Signature: oxjsjjgregx6c3aca9jswc1euw7hqu8b
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774452521-6286
X-HE-Meta: U2FsdGVkX1+bzk07re4oUq1qs0a98tbK0Uz4GbtGhyK5k95FCVRMPUCvXmoMs0iYWiQG3ieEacuShvSXAlmxlmCpoznLI8tlCR7EyuMjiIiP2ITi9v6IPOX8e4I/GtrHhY1gGAAsd9ZPXW0FpFRj9S3CgSfkUrLMX3zEEn10SHXTzztiNUOIfx2fWvG65hrko1p+7bBtgFD6Vy4kIjen9yWXm5FDEazhs8/oWcQq7mODSsFLWPHNnF7ika5KXkQy4WOLgaaxw0ukV3rQRxbyRWmzhZbqyYDDNcugcwp0SaRInktNMgSNDLwVV8HCOYv7szYosYzamtEt9OxI1Dr/FVdqiNPvIlSs3t0sFkI7eA8MUcF3H9upg0T2EB/OJfbVQ6C+Q2SAZ985YcCHTaZAHpQxCIi8K6rxdc2Tz04LTJ4wpYIjFfDayihmmNVj8H7rwpNhRXRduHalKHgcfZ7Yn2w4tu064z1FKl1rbaZ4yLp2HFCbIhPBPsbkEEoT2D+fvLX8Y5gNzuscqIQY/8dPgVEl9zjfLnmG5VmZN0pDCSkgsT2jYsvkF1PE06vKZZFdEar+g466Mtj9ztxkaSliBfqUewIpCwAbPJxTs0G/6o3B0UNjX0rkJq5uxZ08FqkcdErhzU9uldO0HBlIb6VU49MDeOOw7DmDHUTRUf+YKcFHeEY08urzOfydki3yyjQYso3m1zUcrAuGp02eFG1sne2lyCZ55ravJYtI5+BFEuPbzTd8p0g8cfMkDOzMiW62ljFv41JpWcF2tm1q8PgIAILcVlKA+6wXhSs50jxT4kafRpt2+8R6f5Ar5J49/SdYU/Qlp7RR/CxkiVOfSvIUuGIPAJk9667TwrrQ9gpe1qZ/zVxK1/2Se88ICHBHeQdl507ENAWe9rV37inNBzl+edgPsp77woArnwUQKcViMKa/6miCc65w0WSRVBpQrU2r+fcqlerlau+j2YSnNij
 nssbCdeU
 qvBrKPlctwZKQemB7viIq7p4xgoi05u3S04CYnc/BPGP+DK9kPCtXpEv5DGtY9H114/z7N934Hch6lqOmm45TD7jOQ3YnJ7w3BqOJYQojc3rd22WcrN67Izoe1GHxgBDE0h1P7htUYklZMXEWJo8082hLBKhHHmdVM0qatYGJ1meqj1ieYxuGJ4kqa/SX13h0KcT9Trj6WCccLH+xES62GEf62lvk83VrJmgC1MFUmZYwl0sVdxw14OBj50c4TMq1++lgzWLEcPv/nHOfFzcStuFB/Ur3g7FHZ3kiYfnObt25LjiKoJiuROsydY8Yx5I0pV78kX5w3qVQ+kfUN7V8ry/hjffZop1Vx31rEsUJCwMqhJ37u/s4DF2t1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 11:05:44AM -0400, Zi Yan wrote:
> On 25 Mar 2026, at 11:04, David Hildenbrand (Arm) wrote:
> 
> > On 3/25/26 16:00, Zi Yan wrote:
> >> On 25 Mar 2026, at 10:53, David Hildenbrand (Arm) wrote:
> >>
> >>> On 3/25/26 15:21, Zi Yan wrote:
> >>>>
> >>>>
> >>>> Hi David,
> >>>
> >>> Hi,
> >>>
> >>>>
> >>>> In terms of folio_change_private(), I did not think it is related to
> >>>> folio_{attach,detach}_private(), since the latter change folio refcount during
> >>>> the operation. If folio_change_private() is related to attach/detach,
> >>>> I imagine it would check folio refcount before touches ->private. But
> >>>> that is my interpretation.
> >>>
> >>> I mean, given that
> >>>
> >>> a) It's located in pagemap.h in between folio_attach_private() and
> >>> folio_detach_private()
> >>>
> >>> b) It clearly states that "The page must previously have had data
> >>> attached and the data must be detached before the folio will be freed."
> >>>
> >>> This is the wrong API to use?
> >>>
> >>> Sure, it sets folio->private but in different context.
> >>>
> >>> I can spot one user in mm/hugetlb.c, that likely also should not be
> >>> using this API, because there likely was no previous attach/detach.
> >>>
> >>>>
> >>>> BTW, do you know why we have set_page_private() but no folio_set_private()?
> >>>> I would suggest folio_set_private() if it exists.
> >>>
> >>> folio_set_private() sets ... PG_private. :)
> >>>
> >>> folio_test_private() checks PG_private and folio_get_private() returns
> >>> page->private.
> >>>
> >>> A cursed interface.
> >>
> >> Oh man. folio_get_private() should be renamed to folio_get_private_data(),
> >> so that we can have folio_set_private_data().
> >
> > Likely we should strive towards only using folio->private (and the API)
> > really for fs-private data (i.e., the pagemap.h interface), and add
> > proper custom members for all other use cases.
> >
> > For page->private it's a different discussion (requires more work I
> > guess, because there are many more use cases.
> >
> Makes sense to me.

The long term plan ...

 - Remove PG_private (we're pretty close actually).  That kills off
   folio_set_private() / folio_clear_private()
 - Reimplement folio_test_private().  It just checks whether folio->private is
   NULL.
 - Remove folio_get_private().  It's actually longer than just using
   folio->private and offers no advantages.

