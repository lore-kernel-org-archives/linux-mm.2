Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7629C79FA1
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 03:01:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96B3A6B008A; Tue,  8 Sep 2026 23:01:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91BD36B0098; Tue,  8 Sep 2026 23:01:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 831306B0099; Tue,  8 Sep 2026 23:01:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5F84C6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 23:01:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BF7EE12081E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 03:01:51 +0000 (UTC)
X-FDA: 85192724022.08.646D300
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0D88B80003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 03:01:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Q1IpD1Hx;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788922910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kc06zxE/Bjqp5n3wC4pieXl66HJVnzVmQPMZqAd6sS8=;
	b=B7Qpxw+kMBmagSRduFV8NIhU/vbVfjaWLfU2CWyVHLbx0mLur5UW8/E8xz41nGmC15ieTE
	oyT047dP+SElzPcOLPZGn0HjT32O2j0fnGz6p6sNCrRH7QMjFzUh/rKjGZUd6VCxQ2R2YV
	iS6Q1M/atgeUAD12qQzqi2p0HIwMujc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788922910;
	b=6/4DaGo/8sB8sIiLqXnVEOawUGEfB/Lm5al7s6CCQeTIrc+SDDd7ILc0cQXD+Ouo+fdCN9
	izP+gTcHZV0N+DAG1XdIHKzLTo5ZUpBVkP5ls8+DH953uQhgCDGkCLWr9HUP+Kkp8PkcWw
	mn5j+U1GoX5KaI+5iRZRpPFNrDNvQJs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Q1IpD1Hx;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A281601FB;
	Wed,  9 Sep 2026 03:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E891D1F00A3A;
	Wed,  9 Sep 2026 03:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788922908;
	bh=Kc06zxE/Bjqp5n3wC4pieXl66HJVnzVmQPMZqAd6sS8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Q1IpD1HxMw6HNPSAEysP9kNZ+6P6fpWei2RjGshOOiRNVy0durQ619h/83xP7uT0f
	 y5Z4d9tUiT1AxCg3mSUKN1YGDe4h+d52PaXc2i2QcPKhMP1ZO3+l6VFkL6h7VxUlbe
	 Wge+J/xfedVUBsFbG7Dw1P5BnvT50abCH2uGC2RU=
Date: Tue, 8 Sep 2026 20:01:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Zi Yan" <ziy@nvidia.com>
Cc: "SJ Park" <sj@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "David Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>,
 "Michal Hocko" <mhocko@suse.com>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Vlastimil Babka"
 <vbabka@kernel.org>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH] mm/memory: fix hugetlb_zap_begin() call in
 zap_vma_range_batched()
Message-Id: <20260908200147.2c2765fc8403a7db8296d041@linux-foundation.org>
In-Reply-To: <DL9I2ENHO8WT.2THUK1IVTIS8D@nvidia.com>
References: <20260904000028.149656-1-sj@kernel.org>
	<20260903173540.e8f660dcaf083946417cba3e@linux-foundation.org>
	<DL9I2ENHO8WT.2THUK1IVTIS8D@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qks7ieub1njoa4997zucsuu6t3w3i7x9
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D88B80003
X-Rspamd-Server: rspam03
X-HE-Tag: 1788922909-940641
X-HE-Meta: U2FsdGVkX19Dhne6LxYQUzG9T+tKSKkP80wFpOdFA9QvNkOord8icPaz+J3YdVDYkh/KPqapU36ejNQtfNPaA4qiYIf0OqYujCVXmwKE8sQ8mIZ01VeDz2j+xnzj9V5SjfqvixrcqCZZkKLnCSfZ0v7LuDrf91PEaBipplbKTk3/uqvI4Nb6mwdBEHDR+4m0KUx42u2egrZ1cAiv4vZSM+125BuK2PJ66i4nlcAqPb8mBSB4vwllcTOOYZ3BtYtgkEbyL5bK0jFN2YwEoXXhUdW7jZnhbZ+zh8hL05hieAz2S6Lfve3o78SOTUcN8EOIWBc9Yp7yp22nRJY/ylyj/i3YBv6UXcxUJPm511mFObEp7njzqdS3raYYeSbQI6l9Mj09pZUTjVO55N2d5B6dodXFQw2mWAUzYz1+L7JI2E9QYPlA2c1gnQio1TJMe/mgGWjB0ZZ3SR+6hM1g6acCK1ho/3N9XU3Hl0q7oELyD11Sd9iz5Ui1xisiTpBSvbDwUY2GYNU+XEN18N6w1TmJ3PG/nCubBXb3TWB2ez6IQ2oC0DNnPCg8JdG7iRhupjFuSGpWskBAq2L0V6etn7RrwuK7bX4q5rxEqS3W3b6MrkGGhyAa9vCJSd/YogPbCA1jyov911JFi80uTPAZWeXPudY6ah1CpsUAp6hh/Xe5VKceUBs+jrPftavoWZwCijrG4i/RBLtVha3c6Cb4TZZiezJydeETeSySHj2R9lgsSC9WMgtd70KjEcoEPgf89RGaVkwLzXNknRmUWHM+ImL82fJzuDlymRXMFIdHh2r0+OCS5IWLHWeGOdN4gKUbr42q7XoHRwX0o9BpLAkaFpeuli0TSdjNo+fQg3sZhXm0d9QDTo6pHtfpQvf/g4t7E953vTFep4UbaVoXs28NW2BwaspemmiwefnNWKuKoVGXaw67jo8V/lZJX9h+/scjHT2KuB/qnmoEPOEsUGfmWN2
 fzvknMjn
 XcCSzP1sXPR0D7TmdnNu1e6xpTim2JBuYEvt4W39epUntAjwGzk4XFZH2fiT0dJkkYCQiQ4zLQd+2HAKPajV75ow8dxsZN3/LYyfzf9Syg8fhMt4DDNLa0CJwkStgILF3Mjw7LrUm6x46bms9Z8jtlqosdGrrEKMdj9P1pQSF55b24NOVYUWSV+K3KXCZnp3qJ1lThw7mwyK3PY7C3mFWdiUhHMuoIwS7YzYlBNi26XxAWVIaWmXp/rf2SXOughU0ZBNMgKxTwtui92FXGwOUdDEEw5XY9OE7g9k7DhM/vy09vmyV6n4/DMizWPcq8RyZr4NT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 07 Sep 2026 20:14:45 -0400 "Zi Yan" <ziy@nvidia.com> wrote:

> > ---
> >
> >  include/linux/hugetlb.h |    8 +++++---
> >  mm/hugetlb.c            |   16 ++++++++++++++--
> >  mm/memory.c             |    4 ++--
> >  3 files changed, 21 insertions(+), 7 deletions(-)
> >
> 
> hugetlb-madvise got stuck because of this. Reverting the patch fixed the
> issue.

oops, thanks, that patch isn't supposed to be in mm.git.

