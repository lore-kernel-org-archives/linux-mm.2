Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5602FD874A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 11:49:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 229426B0088; Tue, 17 Mar 2026 07:49:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2009D6B0089; Tue, 17 Mar 2026 07:49:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 116726B008A; Tue, 17 Mar 2026 07:49:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F3C616B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:49:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9B93D1B5F2C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:49:18 +0000 (UTC)
X-FDA: 84555384396.22.906C944
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0448340013
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:49:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=v2kUwuWl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773748157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0N0UaS69pBYbj3xcnEh+mIbQAk5ZDxTv3h+D8hQJdJc=;
	b=wfS2ISnA7wYqUg+z6DULlH35lgyZF0GcDU9CT93SNron5/nb0N3+6IpoXMZHy3qvX9H36Y
	RbWu2gqWa0c11L4b0jilI3Dxor3YRisqpvGoC8QifUQIGbhG1ec66P/8T1SgVVV6zzenuW
	MqM6/0lMG70mW5sf0a76gfhy3/wCaFs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=v2kUwuWl;
	dmarc=none;
	spf=none (imf17.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773748157; a=rsa-sha256;
	cv=none;
	b=RiWDMKz8xmRRByiJk2K4Q84yMSr5zcCFkqqxHFLQzMBAePP9qbXQ/swwCCZKx16eo3rnjW
	zIupCbmm9mFSKoJNNv1vPKCVIqt0Ao2hgb4DJxYZC6uOf33agqcZns9OBvce1VENl/dl5K
	8miaMCt3i3V30ac/Pk9AdffWSbvYlTo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0N0UaS69pBYbj3xcnEh+mIbQAk5ZDxTv3h+D8hQJdJc=; b=v2kUwuWlvUx/fG/zQ3I3JU232+
	VeUy1r2VvJGOvEhPJBhNpa8ohzOurwCspdZlkCbyzRs7M/qlHsFihbQE04uGSuXBD8RDL4HLEQ/Zv
	qWmf+a5pD/xwZ5vCJAo+N/dkLgPL7uZqAF/tEIFOJwdfEhBNF7eDP0QSY/eljZRq/X+2SJ6Vh0qZv
	NZwlQ/xHFniOkGGpi+e1GbveyztdLs5eeINKsRgCxSpxHrgSR7UbSYR4neJO5T7PgxoZQ02Q64eCO
	c0w73u/2cU2KpIsPDYz3B0lfqb0FiasE0yLbmQhGDXBb61GtMNKtMJPmi/xDINjCz4wy4hkfkugR1
	IAU4n1+g==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w2Suv-002rYf-Kb; Tue, 17 Mar 2026 11:48:56 +0000
Date: Tue, 17 Mar 2026 04:48:50 -0700
From: Breno Leitao <leitao@debian.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Sohil Mehta <sohil.mehta@intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
	Wei Yang <richard.weiyang@gmail.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>
Subject: Re: [PATCH v6 3/4] mm: huge_memory: refactor enabled_store() with
 change_enabled()
Message-ID: <abk9zDc7afPDozdx@gmail.com>
References: <20260311-thp_logs-v6-0-421e30d881e0@debian.org>
 <20260311-thp_logs-v6-3-421e30d881e0@debian.org>
 <322f6f2f-840e-462f-96b0-b603b9c88582@intel.com>
 <abfVLky1zanZyEx8@gmail.com>
 <a503cbfc-e7d9-40f0-99ef-d640a0b5d78e@intel.com>
 <1b7d1bdf-c002-4543-b858-09fd2b1b73f9@lucifer.local>
 <abk5eqVbwlw1FGsI@gmail.com>
 <8f873cbb-93ef-40d9-99c8-ce9970aefb82@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f873cbb-93ef-40d9-99c8-ce9970aefb82@lucifer.local>
X-Debian-User: leitao
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0448340013
X-Stat-Signature: mrdqky15tsifbxq17g19fi87oezazkzs
X-Rspam-User: 
X-HE-Tag: 1773748156-425364
X-HE-Meta: U2FsdGVkX18bZYNYXFLhMqHZbd2pVYOjltwr1u9jY9Knx26Q4pLQxFEmBG6oB+gEcFT3R6p14HVQQzRTFmnoEhcVpN/30hwMVR/kb1wXorQarVKXa5YeXKGwkc0o5/eJEBqAQEE9NvYS1BybhXM5OblAKNHSGmZ89AkCNN9tGQeKn2O1uMwbRtl/S3z5mZsLuA+Qh404fLIUaMpGqUQYZFDYGQt/vRIF5FpjRVjwDFH8Bur2ksBKOpzJwGrr4oMuvjH4OoZzxq5XIrj/Dou4e2LHnvYav/DpfZNXLJpWDyBbRQ4M1qSFTcp3mHzwBy7teK5jdhtv6aASaWlAIoXoK1d9yL4yyklGL5YILKgVYKKWyrE0yi8lEIefm0UqdO0ORu0JYRkLUNqIpDO4snNR+pQxgTdDT/4NWWGEloFPHBBI7QDpZ6+qXVjRdfbFde+ODiPiN6DB8ltZs8AH8gAwKAwaSNRv//AL71QF9sviaHrNdUlFruDNSuiDKr5FIH2LIjdJbnVpVuvXNnJXsuESP9kk/n1xw1ewTftSH69leh8YwyhmYZ4ttPt3OitONhvhUhObaJVUP9c5DVL9ul0wJwCmET7e3SFoisQREGc1eiy/YKja9fRWcr6SEygVHhlh/J/v6CQ/O9GWz2URo1mhUnwAslpOH+CQvni3YiGsRKgGVMh4CmrnaLxHnQEdCmctctOmcrESN76vyL6/KqhifBy3XzOMEwxAeqmShXyTGAkRNPstPrMGOokV+efvFE0wOsEY47pTG89ad7V53dkDita1fOF67ntDm5YOdAqk9VdJ0D+bNkRapBFUfND8eY94lVby9S0xqYd2FuIwQKSjO5T1EdmnhRknDJt+1bqfUklxkYEzUwJZBLVoQOF/Giz1s1fiVjlu1E1gkTTMd6WRMBvM2Nl7b7XZIuXox9R9KH4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 11:25:23AM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Tue, Mar 17, 2026 at 04:23:37AM -0700, Breno Leitao wrote:
> > On Tue, Mar 17, 2026 at 09:37:39AM +0000, Lorenzo Stoakes (Oracle) wrote:
> > >
> > > Given the above I think we should switch back to the atomic accessors.
> > >
> > > We can address the broader issues with this horrible code in a separate
> > > series.
> >
> > Ack. let me respin then.
> 
> Thanks!
> 
> >
> > > > Overall, as you mentioned below, protecting transparent_hugepage_flags
> > > > with a spinlock seems like a better, long-term solution to me as well.
> > >
> > > Yeah, let's look at doing a follow up that cleans this up in general and
> > > address that then.
> >
> > Sure. I am planning to improve defrag_store() as the next work, and then
> > come up with this additional spinlock for transparent_hugepage_flags.
> >
> 
> To be clear by the way by 'horrible code' I meant the existing logic with the
> globals etc. not your change which is positive and welcome :)

lol. Not once did it cross my mind that you might be referring to my
changes. I have never written horrible code in my life. :-P

