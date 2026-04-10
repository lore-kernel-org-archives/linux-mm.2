Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DBE9F44858
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 13:06:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C9C06B0089; Fri, 10 Apr 2026 09:06:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A1976B008A; Fri, 10 Apr 2026 09:06:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B7DC6B0092; Fri, 10 Apr 2026 09:06:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0EA076B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:06:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B68C41B820B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:06:51 +0000 (UTC)
X-FDA: 84642671022.17.E4714AB
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf22.hostedemail.com (Postfix) with ESMTP id D9D1FC000E
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:06:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=XBek3pWU
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775826410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ewzBU+Ju9nP+QlSxDY1jLX0KP+2OHVSPkcDbhEBxrLw=;
	b=VJ4yg6C42TgAErRwVHJjfpEwrj/YqvxhQARLysDSeOGF66J6Mr2wEP2yFfI57w88JCrUWW
	nq9zR9DsOLSI6LaaBJ2aUju7PxG/ZHnXvekSxIAcqkvIPz4gu/BiM1NU9qeon3HXMI4c9o
	qZ661k/OIDv2Q3mqdCM/LV7l3Dzfc4U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775826410; a=rsa-sha256;
	cv=none;
	b=wAFqnKNvc1pjXTLydixMIbUe+IlUDLbVTio++PZUXWDv+VQ6W/2+P0jl93mbkJZyd9Z62N
	CJjn5QyyBrZPZYfj//7EhIznZl9ZmVrj8rwaeoqraCuS5TLokvgkEFj4J+GxgzYOZvrNRA
	WepGw7xzPtTDgDlLcYspayc6yW8Ml+8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=XBek3pWU;
	dmarc=none;
	spf=none (imf22.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ewzBU+Ju9nP+QlSxDY1jLX0KP+2OHVSPkcDbhEBxrLw=; b=XBek3pWUq7o4iwoPUMzm8Z1aDx
	N+m/HJ90g6gnd66YB6aN3s2/1bN1j3SBTVarxKgyMkEaNV82PKPpy8k07Q0OCP62d2g/13ce6D5KZ
	YWHOsiOSgdFBMkAFUFhcFjKcPIDPvE2GZ4wae7DNP+rJH/oXQ7HfB7GeVnWMYxtRvmcrb8Ynk4agv
	QL9kADWnINQUdsSyMks9OZU31Q5zkB8W4LJ6Jj6uLT4n5cHZqlArVzsf36YphzUcPoDO1O0UxwjHF
	foZxmXlo1f7/91RZz9FhlVJaZLb1Z0VwO+vNfD1dmsRuFLbVJdzRnFAlVZ504lN34a8wasj3nwG6T
	d9AbTguA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wBBZH-009zxp-1W;
	Fri, 10 Apr 2026 13:06:39 +0000
Date: Fri, 10 Apr 2026 06:06:34 -0700
From: Breno Leitao <leitao@debian.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Christoph Lameter <cl@linux.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kas@kernel.org, shakeel.butt@linux.dev, usama.arif@linux.dev, 
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm/vmstat: fix vmstat_shepherd double-scheduling
 vmstat_update
Message-ID: <adj10gqqGUtrSeUn@gmail.com>
References: <20260409-vmstat-v2-1-e9d9a6db08ad@debian.org>
 <7cf39b82-ff21-4d9e-b2fd-1636c3e203ce@kernel.org>
 <adiuinlYfkIjuoOJ@gmail.com>
 <adjWGyiVZ4neZRCw@shell.ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adjWGyiVZ4neZRCw@shell.ilvokhin.com>
X-Debian-User: leitao
X-Rspamd-Queue-Id: D9D1FC000E
X-Stat-Signature: yxd1yfuwuoifkawnbdw9od85h8egik8r
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775826409-541006
X-HE-Meta: U2FsdGVkX1/Mr1bI6PRwc/TBwADVu5PhRGtSRBGAiEe4uxCeiMl4Mw+q2IZeszScNwN60I1hJnvZaCur8KKplW2/upnPxBbbC2jMaWXzng8RiF/BDuP/TYXU8LEMT7YE/zVlvh3ZBIWm2QE3HiQJRh9VC7vMH4kH/OA3ytlo8uv2aHFb7rZHHWKLDPayHqsDRDkj9FAHkl1gHxPXytci5so98LhDuTz5JlXue1BIRyGzeeGx+AsViokx4DqkUSl7EeMC5uyJj90/jeFGoh0c2xhX+gvk0eMkXxQAN9x+bXjGN9iMVyMUQzNH4feJ60X9CJEWfd2sV+gnvIZRxLzsNvxyskhqCG00BUUalvNKPOCnxGbEKrba3oCJQ6L2hCbJHlM+kc+TCs0Z3JYPquWRe9Jacax73DMOqUMnsG5QB1wuQbLz3HzQ6UjW4pKkAdNcW3blXpso9K9i5KBmpWU+F5ZvQo1mKUYPr/5AG/NIMftcj1Q9jVBcWzs6SE1VhTxc3dT0aekTJKiaob6VGjU9Jxn/+cQFaXNxEy97WE3AiiDq9OJuHpvHoIT/Poqld/8BfRNzOXtG09Ca6P0L8KLZrNfrKIbumMs2l59NG8zRw5xUwBB4FirYnlgaZ2TViZZeNdsu178ma2IKrJ26F53+4ojM8XWEIEzXwA3NDtJBPoXunebSweTzOpKguKQCRzQTj1bGZbQYy0/ZHio5BDv6Y/Atb2e6dbP7IifRKdzOOjdFE/PboAT83yY31rWFl0pnRn6JRmavyyIpE3xlzW8WGnC0xCMxFUgpaWVSCe5TlpuwkRCZQFHJxNlidg1+QPebGd8rUKaDtUtJfbMeBDJl+8a2syPNedIclKmL4Sdwzh19kzF4ZnhZYjdkR/Vhqh++jRncWCsijLZ0iQUDyMoUmOm/5ChpbI7PJw9s47ln+/ir15jWwuMFJtF/vNGFGPlnxkoJDk3uJ3vB7nR+rpj
 /O1PRETs
 ZRzjBS2NpHY03866ESP+L7vRqXIyG9ltNIPKMQq4C8US8JCDIGp3K+9EGRE1JP05V1aaJbmbalYIzNv/9sOnALAuHR7eMUWMCRyq0GokNtFjXWhks5H4kDLEcMk/AA46H8lbttah/09/ZpuW3ZMZqhOBTzf553GUQs2qqcRjyEw0aKQMa5xbFSWt7Y7YuwkF8Q54mZ7SoxuAAPNgmQa0+tSW0XcniVPQM2q0dApEXun9rKPrsTe7iVb+9xZZc8xXWDGCv0twDDa6dbSv6jOg8baLYyZz/ofgbGip0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 10:51:07AM +0000, Dmitry Ilvokhin wrote:
> On Fri, Apr 10, 2026 at 01:03:54AM -0700, Breno Leitao wrote:
> > On Thu, Apr 09, 2026 at 07:01:01PM +0200, Vlastimil Babka (SUSE) wrote:
> > > On 4/9/26 14:26, Breno Leitao wrote:
> > > > Fixes: 7b8da4c7f07774 ("vmstat: get rid of the ugly cpu_stat_off variable")
> > > > Signed-off-by: Breno Leitao <leitao@debian.org>
> > > > Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > >
> > > Looks like v2 posting raced with Dmitry adding R-b tag to the posting in v1
> > > thread:
> > >
> > > https://lore.kernel.org/all/adebKQaiAP4G3liv@shell.ilvokhin.com/
> > 
> > Dmitry, would you mind reviewing this version as well to keep the review
> > trail complete?
> > 
> > This is essentially the same patch you already reviewed.
> 
> Andrew seems to have already picked up my Reviewed-by in mm-new.
> 
> There are also several other tags there, but most of them were given for
> v1, while the current patch (v2) differs, so they may no longer apply.
> 
> I've added my Reviewed-by again for this version.

Thanks Dmitry!

