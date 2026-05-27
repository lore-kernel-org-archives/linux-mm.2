Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11B76CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 07:18:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FC806B0005; Wed, 27 May 2026 03:18:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AD296B008A; Wed, 27 May 2026 03:18:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E9E46B008C; Wed, 27 May 2026 03:18:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E8D96B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:18:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CC4298F90F
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:18:25 +0000 (UTC)
X-FDA: 84812346570.21.C8AB16A
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4500FA000F
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:18:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf25.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779866304; a=rsa-sha256;
	cv=none;
	b=EtxI4taAEN92YDYHuLtIlw2H1SSFFVSt/cVGURWvfnDKuwtb1mysOkVxvk/+wkGnExxgjj
	oFtnjm/UBpv5r1Wdjx9w6TCL0XreD/5+4Yqs1JOucGTUcphtkaoe6Jj7zopMj2UpmxVoGe
	hc97gBWhMJDqNXZM6R5FZVMJt3NdKGI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf25.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779866304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=BbtQydTOReLdtnaj1/a9kwzZmHjmO9N1n0Ii5e24DXA=;
	b=J2PqaN3A1ybspf6z0Qwp6LsTMnuRGGv/AkkYID4Zbr1AvKCA37TMUCPFCwjCfrqZVSOTmU
	yqRnjvsS5Lrqgn4dnHdq4xqhpMufPMccL+4Q3S+y8XNBEbC8xiaaXDwS54BtTV9himdpKi
	Ke8nSimz/cX41fNodcchWGoHz9gEAx4=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8295768C4E; Wed, 27 May 2026 09:18:17 +0200 (CEST)
Date: Wed, 27 May 2026 09:18:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-nfs@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: revisiting alloc_pages_bulks semantics?
Message-ID: <20260527071816.GA17632@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4500FA000F
X-Stat-Signature: 1odr5nskqwdse3uqp1qyzxoa41uhadtm
X-HE-Tag: 1779866304-377746
X-HE-Meta: U2FsdGVkX1+S37HaFhvsxmxGm1cN19bG7dcId0GVI7x9L3DzxQdc/bCIVdgh9JeskM/+SxJ87Hrau7kGcVfcA9iFi25z1OA37EZ7sF4KY5QTbTGxUOfcyw6st4/zhdhuQMPNYSBhzDmUeh0IOHWmYJulGV6fsW+TSipIisfh+tEiZ/ERaTDMj2YIf2o4TI5Hdsa+dBev3uqF0lLmqZXTgOmMuPnCZ9uuMjFHsErBMHlD8CkQIb3IjwuShYIPfPgyIae0XhidoBprkpCqpBoioxy1KhcTWi7hYuxMTaihi6Ro6ctrMJZqzVqCQqevNYGVPVOaSqrekjZ2Af9b7aENo+PinVeZ9ZTSa52JBPXuYbxKEatlRp1D7BBtAPOXW677zyi7WIKgjf8P2U1bfyz2fmYnyZ0cMVREaUNQ75ya6b+Xt4EqYG22KscX791LvazCww5dBhfDpZaNSbJBTkK3o1RSWMHcv1z1td4tGjWDK6FCtvFadFh2f+y+/KPdpQ194EoK/+N1t8wzBDULHIY9TXHIt8gV+PQcSwIOXrnXVtvICkdWE9QQufaDDFy8sfqhqnu8IbvpqQ5AGTRjO58IvWJxSbmng7iXWyqo4ZRmda5bZE5IP+am+6h2/VFjeqKn1JT0Ff64a+XVpc6uOjQa0Tlg8+coX9XIJNXO5oCP60QogkuGvFCXp+sI3wTRy4c/iqyevxPuZAhzMlotGRk93zGA0K59abKWBoPefbCi9ZoDB6voocpiRfSde7MTAmHUz8lHPkLRdaJAJqV7Md0Cq0zInzlhgke5brSpr0Jt3LapIE8UsMf8eNMkhuuHm28TogP/UXqR0QTEmTgRoDa3z2RbLhFbYT4q3rgjO7FEVhN328XVlJtbglO+UC7pD15ZirZFTe/Kr1nvfbC1Xfvn0d1dcHKJFzSAsHt2/+nJ/tKNzm+AQYizvyw0k6QsqDIQj4AVRnSJd03mV8/SZa5
 u5eD6Qn+
 msJFxGqC8XtBqGsH4SW89KxpezOn6VWU+jGqmmyAfU+vZZRt0TngCYfLegeH492VGA6kGaysHD3O97YeUqlUv9oZ50E/WOmjOe/u50YPD9fyXg7LoVS+c892E+gyQz1Z6WZwukGpLtttpQ9ngtvRVbqyqkldUuGCI5hww8Hzw+50opE45+xnZlcaW810Aou1v/NPr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

I've been looking into using alloc_pages_bulks in a few places lately,
and have run into issues with the API.  Here is my suggestions for how
to make this more useful, although only some of them are something
I'd feel comfortable to do myself:

1) early fail semantics

alloc_pages_bulks can do partial allocations for some reasons, and
users usually have a fallback by either looping and calling it again
or falling back to single page allocations.  This sucks!  Why can't
we get our usual try as hard as you can semantics, requiring
GFP_NORETRY or similar to relax it?

2) pre-zeroed page array 

There is one single user (svc_fill_pages in sunrpc) that relies on it.
For everyone else it creates extra burden and is very error prone
(speaking from experience).

3) page instead of folio

We're allocating folios, so we should have a folio API.

4) > order 0 support

The bulk allocator is limited to order 0 which limits it's usefulness
these days.  It would be really helpful to do bulk allocations for
the pagecache or bounce buffering.

