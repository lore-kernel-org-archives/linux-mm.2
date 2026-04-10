Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6C67E99040
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 07:08:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDEB76B0005; Fri, 10 Apr 2026 03:08:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB6B96B0089; Fri, 10 Apr 2026 03:08:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF3006B008A; Fri, 10 Apr 2026 03:08:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CF2F96B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 03:08:15 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 558E8C1607
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 07:08:15 +0000 (UTC)
X-FDA: 84641767350.12.0C98FEF
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5D9F2180002
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 07:08:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=FtuugAuG;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf24.hostedemail.com: domain of BATV+312a4f9ec2f36cb18775+8265+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+312a4f9ec2f36cb18775+8265+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775804893; a=rsa-sha256;
	cv=none;
	b=eJX4MolcdCjxyTrkQK9XCb9JZ//rRWZHum8btLpdM7xSqbDhW5J3bGVUWLwBlb4ETEvu+m
	J+eOKIYBAhbtpYzoKR9AGkzAlavxnwavTcQ+KL1yNcAnksRtsE1Lgi1Na9dnpqjtP3Utxh
	1nYGsWndzexHZKgD1L3+cQgRTt8gWHs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=FtuugAuG;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf24.hostedemail.com: domain of BATV+312a4f9ec2f36cb18775+8265+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+312a4f9ec2f36cb18775+8265+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775804893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xPaxU+hWT0ZEvzMf51KWwAKk8kmuCkfO6rPBhH2/bDM=;
	b=zP7E0kE9ma7hLPqIuTE72KYVUP/a6JsQHOGx1hbliQveWScIECicPCs2k6kgOOFpuSY5xs
	FK0l1o0DDyI+c0BTbz65mJBPQWY5HlbhZwraKTlES5RjjEgwZWDl72g7IH33tjuhUuccEa
	1zq21NlQzBg5Nrv4cC533AQGjZtAWeA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xPaxU+hWT0ZEvzMf51KWwAKk8kmuCkfO6rPBhH2/bDM=; b=FtuugAuGyqZC2jQrdNhDVwzxpi
	dJ5SExKEL6oOf5ZM/vBhsqAs4X7id6OJQfzGpjXAOPfUG3QNrMgVymo5yGk+Pteme3HlMErSpyosH
	EYzkJi5uupoAJz/H3OiU8lG6oeGCbtitZfMu2UMnGRwKRIFdFU+tCrDVeFYpYQx431oTr73xMcUhn
	yCpRhmC5cUA6nj7lI8wTfCMseD+k5gFAUKi8XRlqnaf3H7ITogD84t5f/p1vk6nUBf8YGj2bMnUnL
	svhucEGk643fE6RXT/3XYZy+TDvUzrnKJD8r4qMP92fSKa+h5rnUf/Pbx0FX9yJkjzeTfF+xJ7WWT
	wc/pBhSg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wB5yM-0000000Bi7B-1NBq;
	Fri, 10 Apr 2026 07:08:10 +0000
Date: Fri, 10 Apr 2026 00:08:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Boris Burkov <boris@bur.io>
Cc: linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
	linux-mm@kvack.org, linux-btrfs@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Direct Reclaim and Filesystems
Message-ID: <adih2i15lagPQmGc@infradead.org>
References: <20260409210906.GA881465@zen.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409210906.GA881465@zen.localdomain>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: mod9e6ta6jphf5rd9jhr6q1xpyophkgu
X-Rspamd-Queue-Id: 5D9F2180002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775804892-6671
X-HE-Meta: U2FsdGVkX19S2ixPXLtPO70T33pUt8Xh9P8NGzZfcASb6w07Mr7T6geFz+W+D0fRwG9QXjjPHyD2yCELpwXFtVS271j41T6rofnfnOAtkALkffCgon/S+xux3tG5DIyvxCQP+jhy32C/YEJwB9RXPIlKRIY/2HHr9mwPgV+rzJE0us9/s/2hqc6taIE5k/1cffe+UmpGZeSgqD8gzoySEAzJ+h8SlChxULzTsDvuil3/jvs9AEBSDdEBgvhUSCSkaaDIghyJdxeKqqgk74fElbfqUiyz421b81pWKQg/dmJfGAeiGxqRq1SjUNPvbnIPtgtNTHbn53HlJ0hTQ8KnvkH4idvzdm8w8/i4WhEF4/9m3Q0g8saeECCrHFHHT5nKCELm6iReJ8K5v+/zdRB5QT873Ux5mu+BvMtLDYZkFmXcZE/w5sihIgX7DizOJ4OjG3D1i8k8kBdc11NVmCjrsnoHWpVb5H4qTC/vTenNlXma9+hiv22V0JoHHexZzz6jvVNiCFzEAJ7+NUT2VLQpGBuJ1FMt63ve075Foa1hZ5V9wrJp3zbiTpZFVXjHH8D973x8AgNYEsp9tT6PlKdK+ANUSzfHbmccA2CT5enb5/TJRtfVHhFN8Y+f6vlXL929jg6y6xaCa2N5ayL5In/7i+CAeQl2pDn0T2Uxn+GWgoCVyiAzmvXax9HtS52GaZVCVjFTG3SX8C6K58zsBGu04Jue7faFNHgc8SAOYQALJLwdhCNTz1tqcMeoj/iSD+xozcJ42cZL2Q+8Huyyble2IjpfbUawG4FH+cwwcPQetAsh/nnpV+FoJlDV942FR/v/7U96OMF+LbaXXWqQYo3z6ix8UaTBHEaf5x0dlVnnK3eyKwgVJG4Nhf4H6z9PM7scVazp01BWSDJ/t6aZglVOVIPlCGZ7o8sS1Jox9nQy4w8wrV1IKBsmKcdYOauF9YcEt3IcbdsHCvHmPCGZWFh
 h6q0Sozm
 0vCwBOH7SpIs63uq3vJhshvjS9b3LMNUekgTtD0++/bgVdIzn/NzXtgoMCknoNNK0sllRkg9wW9JHkYmFdScHDFITeVcVLcrtJPN7MFF4n9mVhtMI1LmAuGADPDr0XwgMtKLYA0SIwn7t41+BOjMWMiEVIEYf9SyvZW91g1h/R8c3bQj6GlObV/kzECoAwA/BmEGCGEuHu5pDPNygiIRGumMoijYvwzgEKNo901ZmElCOZstLovrJTwcQKaYHXr9xll7+RQSHGPhA84lSj6p1QTsgE4YAPA6oWXgKGAlmveJ0/7zzVUPGfsKyhhbm3FEwNLuA512i5iTpbzfbB4s96wIRljO7sDs+FbPOUlAD9iI/wstKUBtPc69+9V32U7P7QQGG6qATZ5DoLnqMZLf8vN9y9rRh9p6W835bCpCBsY5SNBEuVq7wrB+6YfBSJb9uBYHmwIpofnLKrqY0Q9dAlamT51/w43+7SA8pJeFPFrUB9krZUV7Z7DN7QA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 02:09:06PM -0700, Boris Burkov wrote:
> - Reclaim freeing metadata and/or forcing metadata writeback [1][3][4]
> In btrfs, this results in redundant work fetching and writing btree nodes if
> it happens to hot nodes in the btree. Should we be trying to lock some of
> these nodes down from reclaim? If so, how many is appropriate/safe?

The solution to that is object based reclaim as in the xfs buffer
cache.  That way you can set priorities on the nodes to keep them on
the LRU, or even pin things down much more easily.

When we last discussed this Josef didn't think it would work for btrfs
due to the amount of metadata, but I don't think that is a valid
argument.


