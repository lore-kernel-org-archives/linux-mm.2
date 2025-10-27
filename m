Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 121D2CCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 07:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BA838001E; Mon, 27 Oct 2025 03:40:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 544A58000A; Mon, 27 Oct 2025 03:40:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 433348001E; Mon, 27 Oct 2025 03:40:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2CD0F8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 03:40:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A8FD4C0506
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 07:40:18 +0000 (UTC)
X-FDA: 84043096116.10.6CE0CAA
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1A47DA0009
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 07:40:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=PiheCWsq;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf25.hostedemail.com: domain of BATV+f89618a03c6ce0da8aec+8100+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f89618a03c6ce0da8aec+8100+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761550817; a=rsa-sha256;
	cv=none;
	b=fZgcBjS7xuF2TxhOeIvn/f36qEOeWoXn6OB0eGlqU5oI2D8xr3uc6OARVKlWIZwyam+T9R
	qLVw0roLt6DnVWWC8sHFnFfHtFZVj941rSMSP4yMtLhF3b55ZWOOHTixXPolrc1qMRohnr
	2+Y0mW0Rw2pWHN6Bzwsh6Hr82QlptLo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=PiheCWsq;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf25.hostedemail.com: domain of BATV+f89618a03c6ce0da8aec+8100+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f89618a03c6ce0da8aec+8100+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761550817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9jMl20VeWz5/kixKog9nGx1c3XBZkDdSCBaR7mjSQx8=;
	b=PzG9QNs7NF13nUBoQImclelgtbIDjtGRZsOIKXxvNZ/PmdBPJbceYYPt79o3Ky9fCg0yPK
	DylQ5LJubEadUzN1lhncxe/OhtVWwRZUZFO+kiGPG/eJrDcdUtHONln/cW1h78xMSzxSo0
	3CzRL02CEL5FBYyZTiyQba895TR0dd0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9jMl20VeWz5/kixKog9nGx1c3XBZkDdSCBaR7mjSQx8=; b=PiheCWsq42Vhc0KTiC/bg8ndkG
	MeK55Ev+k6GwF8Vb5G4IDqHCtpXpfby7eMipiOb16PeGrIljYOjpJEdHJqF95VaEMSdVojOn6Nv/A
	EG/mDPY166eH6hQ1JSoHjFVhYQT5TSZol8BJqgbJBEnM8vrIbge33wl3i0a7ePlte9O4fs5+i22tt
	qLKNBCWPGm9yg0JrOc6ivDGSWeVOOFu3DW31rm53IlzXqlAiVzK5KJlOCDoPgUhefNlokG+TJ3MH2
	fXm3s8eNmp786D/xL/55EOEiQJh8OrDFryydlujf/BM8QHr3/Frek4i0leO8GuZhM4DKOVH0zr/XT
	v946VGTA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDHpm-0000000DI50-0JnV;
	Mon, 27 Oct 2025 07:40:06 +0000
Date: Mon, 27 Oct 2025 00:40:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Baokun Li <libaokun@huaweicloud.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
	linux-kernel@vger.kernel.org, kernel@pankajraghav.com,
	mcgrof@kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, yi.zhang@huawei.com, yangerkun@huawei.com,
	chengzhihao1@huawei.com, libaokun1@huawei.com,
	catherine.hoang@oracle.com
Subject: Re: [PATCH 22/25] fs/buffer: prevent WARN_ON in
 __alloc_pages_slowpath() when BS > PS
Message-ID: <aP8h1jz8JEN-3du0@infradead.org>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-23-libaokun@huaweicloud.com>
 <aPxV6QnXu-OufSDH@casper.infradead.org>
 <adccaa99-ffbc-4fbf-9210-47932724c184@huaweicloud.com>
 <aP0PachXS8Qxjo9Q@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aP0PachXS8Qxjo9Q@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: agkwfagp9zg8bk8ghtiwotudinjzdte1
X-Rspamd-Queue-Id: 1A47DA0009
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761550816-998363
X-HE-Meta: U2FsdGVkX1/+gw3FrwOTAiQBK9Cm/TgLu7xijzkJ8eXuOibI6dsl9as9KEUTZjeJ84ABU0BlcSm8tK3sCZp/nxpayANfNF8WSbIwmVzJsQBERUCMBbOpsTTf2OQZVtMhNVBEG7VPsGh2FVqQTAlshyQV6Q6CNiytVXoGgf3yrD+qEVm0mCBfsuDZT1t2YDIrq6oNg2EM5WP253V5XsVd1bDkYW+0z9VywdJIXVV0E3wC7jZPs+Mp+KnRSlCitL3wZ13B64KIkHkXFDPwb6QYN1DZlppsehxIDCv+PZ+ezB/ny4JwK8zkPJUbNJVC/1Db5vrYzgdRoNLTQQeJ+n2cFzka7z5mR5ThexVbdxd//0vLUR88ZetEtlVArfAF52BKLHJDeEAAcTArsq1O+0+Dy+h8YagdKfXdSu3QmoC08WdyEF+QapoqS396bZuryv7iUZLVjeZGkbI1Ru+nQMYam2ncb9GFe9QfKvi0x2OJtHke202uC0I5e+g8tvQ9+hqlF96aHMv1Vjx6TJ+xHBEgG0mZAQ32Inpo8v1DQGT7cB4+77X3XVRkHzTy3mX/AjJ3HRJIWDVOrnzMDe5RgNQshYlNwAPrJRxGOgSuoUiLt1gcwlX8mou4Gp9fSXrphdaLz/jCpptUlTEfCpJ7+hoJW0hnnBl8wmA4t6WIRkCheviSt3l+GHkxh7i0Gp0L0yqyP70K7O6m/7VFDoYshPtfkGOKRwFPPHWHho1z7Wn2c4jQ5UIMDbsvzszvN2lU64hkO3O0YYyOU++z3KKpo9XYnD1OZNB1U1p4W1yZmgfH92wyP20+m3jLJLWm2iVr+0jg7UjefdWHj5M0oU6ROduRKl8RxQd5XH0JNIFbpMqo3qFKjCjmH9VbtZbULvcrM6ihcUcDlelsH1fdzP266YiC2pq26BXPkS9GqcN2nOzwyodQr2cl5Btgwx1xRRUyRWE+NtMah04CMqn+vxPCSy0
 Gw4dNhiE
 3/ESqKk6ubWI1B4XYYWnQ5Yw0D1XLrVzCfnP19OsuQyIl3sNdIlB4MV3dh389ZvhPoCBjAvR+LCU7H8lG7AEJGLlZdF3tKYpGepQMNIiRoHr7C2pxf8UPphDAIkJR2lsSj6G6LOx2Ei1SCYsYWiBSH+sz+mRBIf9b4ujmmNBVQLJfv9dL2HhaJaFje9tQifyThxrmlY5ckmpewys1zi120zu8XXh4Hw/zJISQy7QOQ9XTpafIjkJamn5wo3BQbgNkSXLIVkizcjN2gNeF45QaJBaGmbQ2pXmhJSUNVbaCT/jpI57DN9Iv8/BmH9fhigcLzthNdhBqebd8fodrn6QVEIcVpuSRr7etnts2NDsF0DMz/5IHZFR9QOvg+fusAxaMShsIEV6Awb12HXA0ewBVeCBDB4gDDrrDHbuevg33k3q8GcQWVlobCEzlOyXjAYm6rHVLxgMb1HzwYJRiRG+kcq+GMX22p/9c8ntNusy52tupbwcYqWP21sI6LL6ZnZbOX7nC6ORB59TpxStjfhj5AA2n8DzkXXi2dKyDjl8BIrdU+io=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 25, 2025 at 06:56:57PM +0100, Matthew Wilcox wrote:
> If filesystems actually require __GFP_NOFAIL for high-order allocations,
> then this is a new requirement that needs to be communicated to the MM
> developers, not hacked around in filesystems (or the VFS).  And that
> communication needs to be a separate thread with a clear subject line
> to attract the right attention, not buried in patch 26/28.

It's not really new.  XFS had this basically since day 1, but with
Linus having a religious aversion against __GFP_NOFAIL most folks
have given up on trying to improve it as it just ends up in shouting
matches in political grounds.  XFS just ends up with it's own fallback
in xfs_buf_alloc_backing_mem which survives the various rounds of
refactoring since XFS was merged.  Given that weird behavior in some
of the memory allocators where GFP_NOFAIL is simply ignored for too
large allocations that seems like by far the sanest option in the
current Linux environment unfortunately.


