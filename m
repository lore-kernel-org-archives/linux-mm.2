Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EAB4C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 09:30:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 838316B007B; Fri, 24 Jul 2026 05:30:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E9096B0088; Fri, 24 Jul 2026 05:30:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B1F66B008A; Fri, 24 Jul 2026 05:30:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D1C16B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 05:30:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A247D140226
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 09:30:30 +0000 (UTC)
X-FDA: 85023149820.05.00ABAC9
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7160720006
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 09:30:28 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pmgFhNA5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="t/RKhmKJ";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pmgFhNA5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="t/RKhmKJ";
	spf=pass (imf31.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784885428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LKdkuQQf5JwTFfmj36cCb4Q9gjlzzdrKvccqkkcvgYU=;
	b=4iNQV1IARmTeDhDzL7vGQlnERKdtMwkmUtCYU1BMqf/FpGXg1jTkSDH4mkLhmlLpqMrtpn
	4J/JJonhA66RwCIfgTvoly0lDa8R3txFcvolJo3bwc2+tqaPWBa8wP+1q6Ws7hlBGpb44/
	K9pXHh3xAKgGb3c+VeeX74nolFJ131s=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pmgFhNA5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="t/RKhmKJ";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pmgFhNA5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="t/RKhmKJ";
	spf=pass (imf31.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784885428;
	b=IXHbBlAMkKrMtXso//OJCyj3nmItQrm3DpdjO4g9/W8o+ITCga8mET+3NyYNFXb0l1McPv
	rcLdX9W019WAB3q2mqKO8pHAXvtADhz5e1Mn6L4B6upFvbRwCjKeJS/ipIWBWVz94gIQTn
	fXz2Qcn9wJ1ckL+pbYKMrLussfz/9HY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 947773E87;
	Fri, 24 Jul 2026 09:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784885426; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LKdkuQQf5JwTFfmj36cCb4Q9gjlzzdrKvccqkkcvgYU=;
	b=pmgFhNA5ymxF0V2uIlbnVjGmSctKamWhT4w3Ni8Qt5sL1+YUwrWhdvq2TNHyMjpG3rkuMv
	59G3SF8LuUdkr+2EYRjd/g8+tCrzvlsH05YNoETbqPoPY5l3K2GC8dIaD32naitXDiJ+Ce
	J1E7l8mJVDWe8FYyglJ8ib7faqf04SU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784885426;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LKdkuQQf5JwTFfmj36cCb4Q9gjlzzdrKvccqkkcvgYU=;
	b=t/RKhmKJQ0guyWrvrw9HriaECpeLpVNpLOpUKQ4RdGQsE72pEohI3pm3q6ND0UpcascJQW
	H5R+Mgodq5v4+yDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784885426; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LKdkuQQf5JwTFfmj36cCb4Q9gjlzzdrKvccqkkcvgYU=;
	b=pmgFhNA5ymxF0V2uIlbnVjGmSctKamWhT4w3Ni8Qt5sL1+YUwrWhdvq2TNHyMjpG3rkuMv
	59G3SF8LuUdkr+2EYRjd/g8+tCrzvlsH05YNoETbqPoPY5l3K2GC8dIaD32naitXDiJ+Ce
	J1E7l8mJVDWe8FYyglJ8ib7faqf04SU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784885426;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LKdkuQQf5JwTFfmj36cCb4Q9gjlzzdrKvccqkkcvgYU=;
	b=t/RKhmKJQ0guyWrvrw9HriaECpeLpVNpLOpUKQ4RdGQsE72pEohI3pm3q6ND0UpcascJQW
	H5R+Mgodq5v4+yDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4373A779BA;
	Fri, 24 Jul 2026 09:30:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 280/DbEwY2r9NwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 24 Jul 2026 09:30:25 +0000
Date: Fri, 24 Jul 2026 10:30:23 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Zi Yan <ziy@nvidia.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Samuel Holland <samuel.holland@sifive.com>, 
	linux-s390@vger.kernel.org
Subject: Re: mm: opaque hardware page-table entry handles
Message-ID: <amMvuPZ0tglCoi1M@pedro-suse.lan>
References: <74182e50-b54f-4d2d-a27f-3a59a538d6bc@arm.com>
 <31d36023-d728-4eee-90f8-158c7066f565@kernel.org>
 <e22407d8-4509-4a53-9ba4-491b9d5c5ef7@arm.com>
 <4bfeb697-9c1f-4316-96bb-9bfd66f959df@kernel.org>
 <6110202c-057b-4701-8c04-1a76ee7bb9ab@arm.com>
 <20260721124057.2820903Adf-agordeev@linux.ibm.com>
 <3c21586c-0ffe-4ebc-97f1-803e8acfc5c1@arm.com>
 <716f73c1-41cc-48a5-b0e1-a47403a30da1@kernel.org>
 <47b4e62e-b001-465c-9c3b-ea0636925387@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47b4e62e-b001-465c-9c3b-ea0636925387@arm.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7160720006
X-Stat-Signature: zp4474p3ekj5cbx65zbce43q73a99bn1
X-HE-Tag: 1784885428-176075
X-HE-Meta: U2FsdGVkX1+t5bYnxvE6iFegqGxxrcG01hHM+BlzW+xRwRnrAQTEn+25Rtu55HuKvvrusAsGUUhZ0D0KHYPgPu1Vm8ZEYkMYUpzLJ0XZLxlN3jkel71m29Bb7gh3U7PZuAhX8s1AKU9J8RsfF2N8YZRuuqY2aW62yDC9Td/x2x+tClKZ9u8R9NAXjVHTgHhvhODj1eW7y02KI0SkoPFdcQA26mpkhfuHJWl8pQIiOQUkWh3uYr+q+xJM+k6z8DZw3eeJ4AmXclZf3raS8i6PPMvVzmmBsOxPSRrFZyEuLEsh2NZ7xMtGiyoiXa061QiDOP3oi6atwR/4qMiybmAeOFkZsuVnV9oNuIG/koA3gI7dCE8h8xCon6VMXU+5ab60XREIRwHvx6LpIEZeT3sqCEgg/w0RcfRep9H8FY+Q9qr9ctJkpNYemoNMIFYSO4gXzXYnL8uixn2DTA7eooSICKzkLekvKlsByjVWCJAagoiyj9hP9ksW4NzxrLA4ZfhFz7lssgH15pW37tWWWAWITnhKIVNwRL4xALevtTJDVFozrm3Os3uHAlZhsQ03jpXrxp+YkmwxdxO7LCkliu+GegnwO624HLwC+4z7pxhITy5sSLHW95E2JNOue/mHzCAbKTtfWXJ7v3Q7cguYF+FYr/QgBCyVaJ0qNpzR9D6m1hrD7Hc6jYnMJCp5n412kFsC7igNkii8LiP6ShExJZlHo0ZpWl+m46K59C/xCnv2qNR/w118i0JBkIAt0cEWTo5RYF1TaxHzc1cDse1vDdLCIlD5RsAfnmRIIgJyAvejMJjRMzTQQyyrbjJi5uLwlGcfpkCclWKBMVFUBGhSFJCN8paumYBmUMXTkMtIvZqrhO6XCWB4bFYXYVFKBsVZocCp44DcvlOf01kpxg30Q1gW1lumMi++xTDpFUcXqNwb6MVPhAYZANr9LCFTGcX4Qo4FcTTEDR+5/5iZTEvkPOh
 QxwGKUoG
 ruIPRmgwCH3Ow5angpTsw7ZdWH2tAXnogok/eg1UUhMt+YLn9fVfGISgS6h4pKOMyYzUJ3fEspfQsWm7F7Li6317BycVeYgZ0pSx6gB7y5oFVa0ilW5Z3HUFHsSu0v4wZdhIdvvn+kywX9QMprX86Zw8V1loO8+VDyoJmu1eaHfDblEBAX0/kvuocEKQVEaqMURMHm10RAXSOerwA3bRAGzCulWppqXY38JVNTLZ8An7raXBf9VsYgwiI78CSZKAZjQ0mDp6nLpUSHqA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 06:01:49PM +0100, Muhammad Usama Anjum wrote:
> On 23/07/2026 5:38 pm, David Hildenbrand (Arm) wrote:
> > 
> >> So after the conversion, it doesn't makes sense to keep STRICT_MM_TYPECHECKS
> >> around. Please correct me if I'm wrong.
> >>
> >> This brings another thing in my mind that in ideal world we would just
> >> turn STRICT_MM_TYPECHECKS on for all arches all the time. But the problem
> >> with it is that STRICT_MM_TYPECHECKS defines pte_t which will stay double
> >> meaning still. So we want sort of STRICT_MM_TYPECHECKS with different name
> >> and separate stack and hardware types.
> > 
> > I think STRICT_MM_TYPECHECKS is also to avoid catching when passing a pte_t into
> > a function that consumes a pmd_t, and vice versa.
> > 
> > STRICT_MM_TYPECHECKS makes the compiler generate worse code today, which is why
> > we don't enable it always.
> > 
> >>
> >>>
> >>> We would like to keep it, and I guess some other architectures too.
> >> David had summarized it well. We'll convert generic code to use hw_p*_t
> >> types which would be typedef to p*_t for those architectures which don't
> >> care about. But if an architecture wants to interpret these types
> >> differently or want to make sure the type is enforced and not directly
> >> dereferenced, they need to convert the arch code a well. But it can be
> >> done slowly.
> > 
> > I think what Alexander meant is: they want to keep STRICT_MM_TYPECHECKS (or
> > something that achieves something similar :) ). So as long as that keeps on
> > working, all good :)
> Thank you for clarifying.
> 
> It has been a month since I started this discussion. We don't have any
> disagreement on it. Should I proceed to post first part patch series considering
> most people must already have viewed these emails and are on-board with it?

Besides the vague disagreement I have (about whether this is worth it or
not), I have an actual objection: I've been doing some constifying of pte_t*
for various reasons lately, and something that just just came up is how
hw_ptep will _not_ work with const, unless you do something like
const_hw_ptep, in which case welcome to Win32 programming or something :|

(I'm assuming the idea still is typedef struct { pte_t *pte; } hw_ptep;)

Have you tried sparse instead?

-- 
Pedro

