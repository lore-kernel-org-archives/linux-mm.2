Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97C7EF99C61
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 19:50:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D95D6B0138; Fri, 17 Apr 2026 15:50:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B1436B0139; Fri, 17 Apr 2026 15:50:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EE916B013A; Fri, 17 Apr 2026 15:50:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4C9F16B0138
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 15:50:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DA23EC1879
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 19:50:09 +0000 (UTC)
X-FDA: 84669088938.13.4D0A948
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5BD4816000B
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 19:50:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ScI8EGGS;
	spf=none (imf08.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776455408; a=rsa-sha256;
	cv=none;
	b=CeoepHHd2MgKdeEbS05g7YS52aQdN1Vg+fK4xsCyxvtaWsNRRcYjPvh3Z/0q9zVUdifsgX
	97Mm2Csio5QKV/Nrle5cIZE/wDCnUmajIinvOEgno1b892EjlgiuEeJqmDm4FDIJT78TAf
	j5/Uk7XwYRLr79rfu3baXrtv5liq86c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ScI8EGGS;
	spf=none (imf08.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776455408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ccgT2l/PPKbrEGp7q7C3uXUssUZuYa5x+/Ij72Wpdp0=;
	b=43IYG0OEW1iykE7mZJQ2rAeQX6z4P0V8qxD15hnsWb3P6MHFJL4C/iQN3g3YRhQ70+BIH2
	e7ZBH8Vza/ZnOQBa0LROzqM3OdnJh2Uz7WlIrpKstKN4mXvrphpsyyxI50oIxvYN2Vosv3
	Jf1n1KYkoTAzLAbHAvazrNQFhy9QbA8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ccgT2l/PPKbrEGp7q7C3uXUssUZuYa5x+/Ij72Wpdp0=; b=ScI8EGGSUQ5qO7AafegmuaTcqp
	VYEiZVnQ8ucQEnaVcuByYS/1BqSEehANP0lBzsJg1KEm+GVKaK7GpjMCSOM2pYlDluFXnySsChWMO
	wWBRiILAFbzbFKFnOK8IvDtJ29faPl+6RSMrLAF7LZNERxURwlqdxoXZJA97ubK5wqqMN2+yC3I2U
	zM8A3khZSfoAXc4VkkZmVQEvMqmiSMPFM0aY/eT0ZNDLfKtjQ9BPqFCdmE0rlvHlLVM9mnWI1vj1O
	PstZGJCCtE1WF/si7PwK12yN9Xih0h9h1zE3twBcPd90MJGlt8i36MZkOtAyp1N5mOu6gjRrsLrwM
	pjofP2Mw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wDpCU-00000004Mws-0vWV;
	Fri, 17 Apr 2026 19:50:02 +0000
Date: Fri, 17 Apr 2026 20:50:01 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Liam R. Howlett" <liam@infradead.org>,
	lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>, Jan Kara <jack@suse.cz>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [LSF/MM/BPF TOPIC] Page cache tracking with the Maple Tree
Message-ID: <aeKO6bKupHa2bgWt@casper.infradead.org>
References: <biynsvpcamct5fva5nxxdvc3q43dqi72jotpyasvrk3pumdz2w@7okprmuwznlo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <biynsvpcamct5fva5nxxdvc3q43dqi72jotpyasvrk3pumdz2w@7okprmuwznlo>
X-Rspamd-Queue-Id: 5BD4816000B
X-Stat-Signature: qr51zg891pnmgka18qs9d6z56jtaogj6
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776455407-692898
X-HE-Meta: U2FsdGVkX19GYkfFJl03+CCGTp9evDxvIo9j32iDTR4COa226Sft0IWt2iCwE9+p3wfsIsdi41R4T89LhYtxnQos++FU1sAyCqLZ5ixGdNkN7S9j0rH/8vZAJiRW3JpA+HvDrzBFzhB0fRCzFwmvydbtNjUR+Ey1cX7f4Tz+WpAr88HWQ/Waq7k3eLBKtt+K4ImyxXfHQcIqiQ4/ZHrbrULN+H7B/fms/E3mHaHBiNa6YfenXaSdDqZ7i0wHFBalzIlriaHW5fPf6MIkQEA7d5IUnBNGtaPouUnevHWev/NSsbVaQjBEr/4GyDFO/uQWx7FDM1MoC8MNe95szA7Mk1K/ciWBlQ4ZL4BgAsY22MCVuY2uQLiQWZ5t2Eg6fByKrI0eO6NrFqnNBRo2+TJxiPkSkuk8UaU5d+vAiIx18mcHSmoRpz5L8F7QTAw4V5IBAJ2mt5dO2L7NCrZkzXVYBSQMG2fnT62ljnQ+L48bYFqnBx7ZA6R3y37N8VQfoH80cE7s750AVw5Fp8ARlGDDBfAjWkucLldfqyFKOlPNR3LGzliYagRP6Z0ciV/m7mj2wK3uDYUEMYwOO9D22rdnv72jddjx7L1KQZvrd4Dzm9biaaR9fyzDOt4XOIOEVUPSEe0olD0aKN3nT6covaJBDYDHROA9NzQmI3uB2eifyS6fPnB+pCmVnPk+37QtoNDQvpa9tHvV82wsGwm/vZbuvfjiGW886zQgvsSpt+k9nu/hosKohn/mkP8k/pxd46Qpu2ycFsZiKUcH/zU8AxaJPFmzHKvcbgCwL3CYgauXqQI8Q6CtTw+/d5T/Lv9/T8mPdV9lbl5Tuk/Ptd/60payi2Wlv2OSiLruGIN2x+H115Xa7MIqqLec4JuMBLfWKTLjasG+gbJKxhYjApHnGCC5xYMFKI3G46bP+60eLzi2JWUTfeHyvFSPAiRJVr/jRgMIGsTpBRAVEOREA9kD5LX
 xEsHjNPe
 /LjHe7+d3yooaSDApjLq71XyXFw3bLCafaxfQ2fcIvaubYIw6CrNpuRMaI+1FkiiPCiQsLPzqMhCN2eB9ukfaJ+lwgf3nOlKquQhZQejtUdSdl2HiqxQv1U5Xk4qn3T6kax0NvFgi9QSZIKm8aZSZ1pd6baW1WCDA+IXBIErdIsQrEH39svLxSZ7ef1XgNgB/fUKvCUx6tdhLDIFvTWzFy0gk17XgAwNOxkiyfyDYgZI96p+q3jxsvvZQHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 12:10:26PM -0500, Liam R. Howlett wrote:
> The Maple Tree needs some enhancements:
>  - Support for purging shadow entries from the page cache

Liam and I hd some preliminary discussions yesterday around this
and we'd like some feedback if anyone has time before LSFMM.

For those who aren't aware, when a folio falls off the end of the
LRU list, we store a shadow entry in the page cache in its place
so that if we access that page again, we know where to put its folio in
the LRU list.

But this creates a problem (documented in mm/workingset.c) where
we can fill up memory with shadow entries.  Currently, we embed a
list_head in xa_node and add nodes which contain only shadow entries
to a list which can be walked by a shrinker when we're low on memory.
Ideally we wouldn't do that with the maple tree.  There are a few
options.

The first question we have is whether it's best to keep nodes around to
wait for a shrinker to kick in.  Was any experimentation done to
see whether eagerly freeing a node that contains only shadow entries
has a bad effect on performance?

The second idea we talked about is that the maple tree is much more
flexible than the radix tree.  Having even a single folio in a node pins
the entire node, so it's "free" to keep the shadow entries in that node
around.  But with the maple tree, we can be much more granular and
delete shadow entries in arbitrary positions.  So we could (for example)
keep track of inodes which contain shadow entries and purge shadow
entries when they reach, say, 10% of the number of pages.  Or 1000
entries, or some other threshold.

The third idea is that instead of having an injected list_head that we
keep a tree pointing to inodes (or even just maple tree nodes which
contain a lot of shadow entries).  That's not how list_lru works today,
so a certain amount of development work would need to be done.

Liam, anything I missed?

