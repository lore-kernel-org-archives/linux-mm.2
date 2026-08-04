Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0363BC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 18:07:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5E776B00E6; Tue,  4 Aug 2026 14:06:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE8406B00E7; Tue,  4 Aug 2026 14:06:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB2CE6B00E8; Tue,  4 Aug 2026 14:06:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89F436B00E6
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:06:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0E55180278
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:06:59 +0000 (UTC)
X-FDA: 85064368158.29.7A470CD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id 02A3B1C000C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:06:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=TpyaRaYZ;
	spf=pass (imf18.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785866817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4pNvk/hVxan4X92LEuNLrhC26XmWg6H10cQTm3nYIy8=;
	b=PkSFXGersb73HNfQQz/FWtLwa6OfebdrlzZyzCmEbTykwlo2Ppwku4sZ+ZuD9E5UVsIyAv
	Ex170p2/pqoCskyU+T4NJhgQ8zNAtUDkOgYfZ5syhBPVU9oBrkLG+7Hy0DjgKLhMIU0Df9
	AksxbBQHxlth4Zr/4YjPxcyrObpc33Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785866817;
	b=TLg5GlyjERBc4CL7x4EV7YHBRS9QscCSinzq01SAedrSkjx74Y5wccQsjAtA6MRTElDqyB
	0acppTR/HNPAGI1LV0cy76CtO834/Cp65Ia7v8NVBsL8FhOVhYKIg7TZi0KxNxWypA4ve9
	StbwdA1Od0GDdEGWsRHQhDtJQc9nLHo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=TpyaRaYZ;
	spf=pass (imf18.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4pNvk/hVxan4X92LEuNLrhC26XmWg6H10cQTm3nYIy8=; b=TpyaRaYZLg/n2BYtHJXErQH29W
	6pY46PDbcU/PJH6PFMKJMixpiZtwudk778hqs51AMMiK/YZTaHHmwNyd5NQnvASuFayXom6gJ/viN
	CBa9xLRHNV2SDR9WVxhUb9u1vohm90k5Vqbs4Kh+XAiMe28Xfa2rKTBBJzp7xy7LZ5N4maISrddCD
	M7UQfCBzU4lu+qb3CLknfmWgfsJ0R31KepvHYgd3/fWwlH9ldg4ILGUOdWyEnfN9MxQDjwF0pv4q8
	ZJeRe9Wqm1Ij/J4TxN4bPCrPtfEEv30uJE5Z2zqzfPZ7ZRjDlgfbTtm/YYGyDbgIERxzyby5g2tsA
	ITpE0eFA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrJXP-00000004SL5-3nTg;
	Tue, 04 Aug 2026 18:06:51 +0000
Date: Tue, 4 Aug 2026 19:06:51 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Christoph Lameter (Ampere)" <cl@gentwo.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org,
	tj@kernel.org, urezki@gmail.com, catalin.marinas@arm.com,
	will@kernel.org, akpm@linux-foundation.org, hca@linux.ibm.com,
	gor@linux.ibm.com, agordeev@linux.ibm.com, linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
Message-ID: <anIqO2AiVlLTEPOd@casper.infradead.org>
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
 <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com>
 <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
 <amCPBrdltFSE_fEf@J2N7QTR9R3>
 <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
 <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org>
 <anHuLy52o5S9Nlwp@lucifer>
 <anH1CgpwS3PHeDRq@lucifer>
 <20260804144054.GE27883@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804144054.GE27883@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 02A3B1C000C
X-Stat-Signature: n84geadbr9ze513drppgg3ca8brm4o9t
X-HE-Tag: 1785866816-280206
X-HE-Meta: U2FsdGVkX1+/M18cdTmwDFw9WHQD6qMABA3ojveecIfikcl4G1WWmerJ4MYevYi394fZJ3tDloL9OJN9nhb+vhAReWJG6m60akdZGrVfsHQZCAcg/n1Y+8oY82LYkfpmYVdqPbNH3zoT6lHjOuCQuyLcUWkg11wqTPvUXnPbZSTchg2b0yZLdSQp7tAIT2aCK27izH4YQgeK8MJanRDbTh+lPJeXywg5k2U/q9H4F/8izJ2koCbITB5xAWrwz04AfNmUyvsairXCs8ZWWKd9baAq05HehyCv8b68UdTUQQW5aOXg2O8jI0nwCAfWSbexVLBLZGQS9tRTYPj//4XNvsO4i9nV+H7TKutdEDDHNGdUs0sTmJ0fjjpC273LLWFeqW/Z5F4MJcJinVnLIYMh+H0xWrCI3giXHlWXAJMXlNpINKl+dwUyl2eteAnR2OQRlJRln5V1ruAX1Tx9ruI2JNwgrYcBaOEbxIQFnGwO1GVv6cJ7IJvw4/lxRQWduDlwsc09xD55Hit5LIiCTUA6InJ/DLhJesx1giTERJMWSzVoKDota8wyyn0vseJreFTTi4f6A6ZziJExzwqhWSzqDy84aSRtU7uA8JglWqBRT6E1O9X3S0XkPTP19rGWYQF4ISAjCTdgqozAbdsrEltYfDLARkaJ0iSfm9ET09iAcQ+84hU190+eZC60Zb2k2fxuKvrz/J3Sr9o8bsn7pXD3AuDU2zlXvO+w4LDco0t73msB9+qChkPw08sgAJIyRboLFFQGhBEBGA8SPXHmDv6ZIz6kjI5A0qnkXwh16L0zp6BYk/5X1rH3KRy9NIrExQnJ022yw+++ejP/DG62mNUPtTcK/iDj3v7WplIU7ktk2sEPxKPl1jVO6nfe1OpcYaO5QUgAl2xZGoSx4zvIU8WQwjyUbguqGdDUi9MqYnqDlLU+sEQWMw+jL1nW6cWaNB1Er0TKEZrI4CGKNqBBl7R
 ftNuXeJh
 VOl6LeBWe5cszroGHnHzIc9F+dbqs9VcX9eGN6RkwTWI3vItk3TSSEQ8LXhAkDznnTeJxMbOXcoN0X+rxb7878OVJjaO3g+uwgnGlV55O94rRu0dyx1DE0H6VtseQ3z4Fevf79ZUGm+45np9GTykwuu24nokusJgm5rhLEJV0lw7vvD3jO1GtplAEQfqhbVGgbmoJHLw7RK7ZLokmsMQcb5ZvNqljv9hAVuZU2xgIsuG3XQeuTerISTYwGjPBoyYUZSOnTz4/cgOBFDmR8B6V7O9iR4fMN363EKrQnyQMAnJvfFXX8SsYLJJv6T0A5VI617oJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 11:40:54AM -0300, Jason Gunthorpe wrote:
> That said there is still a merit for things like replicating .text, and
> I think we will also have some multi-socket systems that would benefit
> from this too..

Are you referring to kernel text replication or userspace text
replication?  If the latter, I don't think we need per-CPU page tables
to do it.

