Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2D1AFF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 10:05:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B83F56B0088; Tue, 28 Apr 2026 06:05:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B34BC6B008A; Tue, 28 Apr 2026 06:05:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4A9E6B008C; Tue, 28 Apr 2026 06:05:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 96E9B6B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:05:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F26CEC1E22
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:05:18 +0000 (UTC)
X-FDA: 84707531916.28.D8932A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 60362120005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:05:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="vG/WzYHv";
	spf=pass (imf29.hostedemail.com: domain of andi.shyti@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=andi.shyti@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777370717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pc9V1guAjpY6hcCWkEhlDkaJeXpZ9rqyatqPfyRc7ws=;
	b=nBjD+QOKrVD1IbsCd8Q1NBvvxYW9gtDSor9psp09J+O+Q04g/DN3UFGPQMWyxxsatf1WN0
	FV7FhvpPjZJMH92WGPUx4bCOMGpCX47A1J7LGRTl9M3KXoB6V4wqdSaxXSQuMzPMxEILp1
	JPwzcvIVmOvZKtNdWKcLs3ZFXLckAik=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777370717; a=rsa-sha256;
	cv=none;
	b=hOQKLqSq+Fx6JZ/q+Gr/EQPQ9SA59RIjgCzhxfsPkjRUwPLDAVX5JZ5sKbbyEkatxc7b/a
	GXk1AzW0ArDJUnpJzWwLRsNRgCz6060Z9EpiHmIy3Hmhb9bdPOS2g3ut1rXWL2IlGpLoAj
	Q+yyDGluR+r6qUbtLG90cvVH8nGMgGE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="vG/WzYHv";
	spf=pass (imf29.hostedemail.com: domain of andi.shyti@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=andi.shyti@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9E07F60141;
	Tue, 28 Apr 2026 10:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB50FC2BCAF;
	Tue, 28 Apr 2026 10:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777370716;
	bh=PMHKsltO7uhCWPnxhy5s2BeEnZwPfjveCg8V9/Ctj0k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vG/WzYHvsXBRMAmai16ySAgggPZGU8MpWPAZWv9sWPMFTh5ERt2inEMiDdtoi/aR4
	 FI++YsyUaj2kd1OSC6Dr0o2A7MlUN9vgoI4RIeYUl3oVe8MHcTtGBJYGHNxb2eI3gg
	 zdjTpZBT8Li0oVvjexA0TrDsq9jnKiEsOQS7LrG2vnMM1hPMaP8aufj0UWcPvH/DaU
	 3WB5kHhF4+IDva8AOB/bnULOD/+AIOYZ+RYK9RJMUqYSV4u7y0BWh3aSgFz+VXCPtv
	 Cd79m761OIkHPLDloZQUgdwQVv9YA+cfPqOIMcvXUEFTl5et0xcJHHtxxcLtKUxvfE
	 ZmmnsWVZV3kmg==
Date: Tue, 28 Apr 2026 12:05:13 +0200
From: Andi Shyti <andi.shyti@kernel.org>
To: Matthew Brost <matthew.brost@intel.com>
Cc: intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] mm: Introduce zone_appears_fragmented()
Message-ID: <afCGGC6MUi1m-Ej5@zenone.zhora.eu>
References: <20260423055656.1696379-1-matthew.brost@intel.com>
 <20260423055656.1696379-2-matthew.brost@intel.com>
 <afCCCuLglfi70Tgq@zenone.zhora.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afCCCuLglfi70Tgq@zenone.zhora.eu>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 60362120005
X-Stat-Signature: brnk9bgiaz43hd1ixcshxackj75jazbz
X-Rspam-User: 
X-HE-Tag: 1777370717-31858
X-HE-Meta: U2FsdGVkX19W5JL7Lb0S5+siWTY8JJzBFPZOwjiv9bPweJ0chustY2UwoC4W7cTFOm3qXdSZMDfuDK03jifloksxp9I145cnvy9U03NpFSr1xGyYsvPkEZkgD61SCQgXHXtXS7XHFS9BsnIJ4FF1R+NDv3iM+raU1f2w+N8ywpQNp+wVYXP0tMDEgRXxkDzYibnK2LBHGVqVc58BEej/+z+pIxwBYoFaM3ux905F9fZzmMkQBsSgCQ//jncgdfI80BfdSqqhrjfI6DhOJIU/wyPhznNFgHkbgTvpYE725ci5EtcuwVtFIc5hVcwJ1fIeU9zOhmx3Hqul+Wc8Gb1+xFZt7VJX8Ns2GT/T12XRyqreeZjdcH3jau192INc6XfmaaMlbVhjGEeUUrjgKUKTOPK8qAvoQUmqcix+E1bOyJpdG8ChK2c0CZSLmcL0Lm3Iel2xUQRKnVQ+KGd0xKk+ftmQzPwxE3H4AYIUzXXVGJMAiivIsWIsdgjb+ESQ5zyA7GaNAMdl/a2MusLOP6Xh0uvgYuKQMs3655osBSdWJqgZ78duUDBMv9VE1P3AO0M7SuZ9hVzeka0xXUSVVAdao4k1qq8izllmdttGTxTS8/kaTj6Iccz9DDkKxverORd8WGvRgpa7tebXfEqZJxlZJw37kEoJ8iKopArLB+v6X+rl0i+iwEVC7Wk1TEZEdZRJhE0ZOHzha/malGtr2eaZs039CYC5d9Tsv/YnijcgguQ482sdG8UOt24UY73EeA97p7/zElDfJw2+ZzHPVaHo5DSFKH3kMq9TB1Wp5y2KsVdRt/QmeRQ/S/QfnnFXazylyum1ZNpaWTgKvK1UPTB1BqPntMUbiMBfP+h8TPZRlArq7yKDhEcW6IrH1FgvtELS40y7C1USHVzluYTZNdtHYhxSP0Er7FsNijDAU4Cxf1PEeakUTeXgwh4b357WE1+C58x3tum/K0k1Z1nguV0
 tqg07TLr
 VwCnZYleH6NlbQlnkYjPRbRBTTjk3bPZUjJCW9iEUDNZU1Z5EJeXF/0wbgPzAU72krM+kYJxTA1cP0WJvtA3SBKAzB4kb2gYlNghNE1RjwSFtCS9PS1zOl4oyYMuj1a/Y6hvUMAWZA1CZyIArRcJJMYwc+94GA9W9+d7agHBhvp0NNXxwSXUZFcpSQxwx8a+LFk4OI7cJ+VCrXXrRJkcuZ5QR0fAtsaCfQJ54iGpo1dLSQsx11/WKTwZvndx0KZfnuxngT9WFuDHUrIA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > +	if (zone_page_state(zone, NR_FREE_PAGES) > high_wmark_pages(zone) * 2)
> > +		return true;
> > +
> > +	return false;

P.S.: If you want, this can also be written:

	return (zone_page_state(zone, NR_FREE_PAGES) > high_wmark_pages(zone) * 2);

> > +}

