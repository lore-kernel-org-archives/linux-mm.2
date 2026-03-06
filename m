Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 896D1FCB61B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 15:57:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 035C76B00A1; Fri,  6 Mar 2026 10:57:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F295E6B00A3; Fri,  6 Mar 2026 10:57:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4C286B00A4; Fri,  6 Mar 2026 10:57:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D5D166B00A1
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:57:22 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F2008BA2C4
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:57:21 +0000 (UTC)
X-FDA: 84516092682.28.A232B92
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf09.hostedemail.com (Postfix) with ESMTP id 301E1140019
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:57:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=F6NIVfoi
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772812640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jP9/Cf4cmrfk2eSwJ1fx5VOc1+nY42Td/c4JGIEmTUw=;
	b=droCfNsSpzMDuP3Mric+j8Mfrl72F8iTWVOJGt6ev1ad9uT2Pf/ulcMpG/jkyDFSjO5dLG
	dBQi8vg8JcV5WBNKUQNbG2LH/l6xqcOsHAAMuWd/w4Eea0wQe3MUwlJHmt5HN0aq6EZAYl
	hdQQ46muQELKOq7s9MmlXsPnAUsLSPc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772812640; a=rsa-sha256;
	cv=none;
	b=S3WQZNjRG9qH83DQKS+8jX0xwz1BpUW22U48KmnKMB/6ZjHQg0ag5EAFAsyna7TAlFV6GU
	bUsM0cZGZ0WaTTdRgC3+3MUBoYbwPpUkh46VXEA/r9T7RyRbwpIV0S7sfXUkBAmQT3lWCe
	sDogvvuLriSSJ9ZkpXNaLd+W8AZ86iE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=F6NIVfoi;
	spf=none (imf09.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jP9/Cf4cmrfk2eSwJ1fx5VOc1+nY42Td/c4JGIEmTUw=; b=F6NIVfoiA+3tFLgPUk4X1Fz+2E
	AQZxpp9fR/zZWXR8Sh0kPmBtnIhiex24G6pSq0bqZYKkptt2hA40sWONNhXVRj3ZqS6Q8Dm5EL9Gn
	TZZ2nP7psnS03b5vGK9uhAwBELM2qiQpEroA53FAmPhJJqlSnQCsFjsdAj2JiimmsOT6i4Lzk/Hbt
	YQr2g2AG8fkWW7JcEtEtEMQ1XZdgceD3gh3UbMrnniiTXSE6+gtiHIdsDdlgthhkMmJjnfkiqwip9
	6vTYwHPN8+N4mkwZAXrxgIB+yBZSffdI9LnREny9ICJazfZJWp3QytU1Xnv/IpEoFqhtSKbP4Hz0E
	uZmU0TXw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vyXXr-00010l-C2; Fri, 06 Mar 2026 15:56:55 +0000
Date: Fri, 6 Mar 2026 07:56:48 -0800
From: Breno Leitao <leitao@debian.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 3/3] mm: huge_memory: refactor enabled_store() with
 change_enabled()
Message-ID: <aar479k_ElLUtU8x@gmail.com>
References: <20260305-thp_logs-v2-0-96b3ad795894@debian.org>
 <20260305-thp_logs-v2-3-96b3ad795894@debian.org>
 <ce99b331-809e-48dd-ae8e-19eb6a44b5b4@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce99b331-809e-48dd-ae8e-19eb6a44b5b4@lucifer.local>
X-Debian-User: leitao
X-Stat-Signature: k8xaaji3947is7j8x3hxqrx338je13t6
X-Rspam-User: 
X-Rspamd-Queue-Id: 301E1140019
X-Rspamd-Server: rspam12
X-HE-Tag: 1772812639-913012
X-HE-Meta: U2FsdGVkX1+Oxy+pksum+jh81wxvu/rZ6FDgWJRnZFS0RuSTamIROPinTjMeQdUo5ogKBqvHNEp1JvLm0c/OFRePEJAJaA2/yKPuBs0wpcWjW1VvpgLBgQOqEQeBavb+AY9+XdyfFPcKsYxt+PTDZBQF100BCFgSnMxXhtvIMozcmngYqfeCPCf1fvXAFzfcgU/fSBK+VbdcDj3Uug8TFPWC564pv9BQ3yLFPbkDw0oap/qWuc3Rj0GJDhK7MsAZs99u6SqwH0Lb83V+R61BpzSUFTPAHmS/Tf4MVsBTHgjB2XLGwTko3b3CxXsp7oY3Dm0mKqJ+95cVs4kuGPy2phRP3Kj8Y3jlKVhU0B+ohFAuz9QLFGP1S0IeKxUU1JCUzY2FePEVX96QBkEIz2CBahqR1ajYNQDSPFfKHfo7TtFxEdYO+WUa3P2AB53TJ0qzZOnE76cq+vuldZH1D3pAYhYI9cprgpyKmIS1vKxrqWFCjtscj3e/n7A8OrfeTjtKHRAUTFJcADAjSkHVYT7Sz55lhOLRtV4nw95xqZCNVkc0D3Cst9d+pdtYlUollyNEGrEds624PCCDwcYN4VBjuoi15PGOp8n8XaW/pnxJH0SiD2D3N7ZFsGX7JkJWHSDFXMu4k4jH6Fh8NVjsRLYIB4N+KntFLBrdK+UMKMbYI6oSaMWy03g7lgu+lCguoX5jKgGU5mVQw9l3z/QQo37ZoVVVDGVwehO1d33hg0IcNJc1blCFF+qdd9umJd239DEoZ1OuamETv0TzTICcoOBmPONF1vxd6aL6SeUA8zrT1MnLYB2kOa95xvzah16UEUb5MZIL5D01hkWt7esI4VdOwr5lKxGRsZXyFvLXtBGkhCGnmZrNcEn4ssjBr15wHy0B8/LybZeeZNvs/rWvVnRggf9Cw6W4RjwTEh6WcNk6sNl1V+TIJE4DxLmF57vy+P8CEyWKsL5H1TaAKCTTsGs
 nGBKDljJ
 j4rOrffQAgCYDd+qUoASDISnDO7PiUe1DkDs9jZ1O3M+Q+KPMoWzVm5WOqvU5kXGNo7ynfxffrKarG6Sh86POEacrjlC5PWkVL3c/0JYs7GzSRJ6DcHy0YoJ2pPNrn1LaTVu9osujl+mXn5JPZwQiVe7nGch/CCuVMILzbNSOgsAuA5ZZ7p3kwXm0vumUMsaZokhRmsHrbXVNuNY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 11:39:28AM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Thu, Mar 05, 2026 at 06:04:55AM -0800, Breno Leitao wrote:
> > +	mode = sysfs_match_string(enabled_mode_strings, buf);
> > +	if (mode < 0 || mode == ENABLED_INHERIT)
> > +		return -EINVAL;
> 
> The mode == ENABLED_INHERIT check is weird, it reads like 'oh a user CAN specify
> this, but if they do we error out', but in reality
> /sys/kernel/mm/transparent_hugepage/enabled explicitly outputs only always,
> inherit, maddvise.
> 
> So, even though it's duplicative, I think it's probably saner to have:

Agree. That would be a better approach.

> With that fixed, feel free to add:
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Ack, thanks for the review,
--breno

