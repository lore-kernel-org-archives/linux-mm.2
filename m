Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D57EC79FA1
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 07:12:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F2AE6B008A; Fri, 11 Sep 2026 03:12:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57BD16B008C; Fri, 11 Sep 2026 03:12:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4447D6B0092; Fri, 11 Sep 2026 03:12:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2245B6B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 03:12:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A6781140107
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:12:33 +0000 (UTC)
X-FDA: 85200613386.24.6FADF31
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id DF30720003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:12:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=mZ27Wgh0;
	spf=none (imf13.hostedemail.com: domain of BATV+897ba43dc7b1535f2158+8419+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+897ba43dc7b1535f2158+8419+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789110752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CSLl2pTV9G5RNi/qW1WAhE3OwQjF0Em548onbv341dk=;
	b=Mg0qIbY2Pe7IvoXGvL0ZSPuW3YOr/MZJy5maJLK0URK93zaAXS+29uIjYsgj4RuHJ7G0Gm
	HzEBWA/E8oSvXWNaV+nkEJnqSuGwdD6IAUk0Ys+lit4ITDkmBHuJj8U4MkvNjK931ddwr/
	SX3FH77YFICw99uP+TanHqGM3zfh+jg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789110752;
	b=SewxVuy9opwKpJKzSUfpQYiLZnL0Y3ulA/86lt4l/8kpvJUx+72cYjCKhRifrtso97wQ+T
	kY+dbAC062tadKnwYdBeXRllcBcvKzyLe+kqdzeE7WI1dQlGd3hDlib0kPqL+OZ5d2oM4/
	DKBe9+r7ugKVcCXA+TqtcI34NRysMEg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=mZ27Wgh0;
	spf=none (imf13.hostedemail.com: domain of BATV+897ba43dc7b1535f2158+8419+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+897ba43dc7b1535f2158+8419+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CSLl2pTV9G5RNi/qW1WAhE3OwQjF0Em548onbv341dk=; b=mZ27Wgh0fh4rJTM043iPLCyA2S
	S13CZu2W4O8GvGPHN9qwQG/Z2gy3iC3U/bqNmqbzQySy5Y0ZtGr33+DD+UeoPiCWKB1Wo6xv+0lGY
	auk8hxk0OaNMWG9KHl82aC0nZzdxMf5KVHaNyr+YMnCkm+iWOj7RYlEzILWR9NNjjL3bfukiQ0BOP
	Xopf/XWgZxQq0rbAfStyERZQ+b6DSNRhNAb9W2P/0316R9bIeCncmLVahaFGsVRe2K+z8uMTRZfYE
	gHZXNvqKkHTDjeJQxa4cGdo2RddJfnfnIbm4sGbIjS26CdpTe1MYDdRLCTJRCehE/Dy2xEujYCmJ5
	MV8MsGRg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4vQp-0000000G0Hn-1o0m;
	Fri, 11 Sep 2026 07:12:19 +0000
Date: Fri, 11 Sep 2026 00:12:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Brian Foster <bfoster@redhat.com>, brauner@kernel.org,
	djwong@kernel.org, cem@kernel.org, akpm@linux-foundation.org,
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
	brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com,
	david@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
	ljs@kernel.org, linux-xfs@vger.kernel.org,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH] xfs: kill xfs_trans_set/clear_context() helpers
Message-ID: <aqOp035i41XIrDXg@infradead.org>
References: <20260903133756.2006032-1-wangkefeng.wang@huawei.com>
 <20260910140742.833170-1-wangkefeng.wang@huawei.com>
 <aqLqeTsbKBMEsl-G@bfoster>
 <93256043-c590-4001-bd7f-41ba36055b94@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93256043-c590-4001-bd7f-41ba36055b94@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DF30720003
X-Stat-Signature: jbffzkcwwifik8gfs6xp5dninsyxku5e
X-Rspam-User: 
X-HE-Tag: 1789110750-285834
X-HE-Meta: U2FsdGVkX1/G/i7r5avqvign/4IigNO7waEQdqm6Z+opzJ7rpqNcAAINMoN8fIp6+aFqwmb4fcNueI+L8av5JdReI96uZDabdUkJZwjPwW4y3HRhGehubwaXDQ+QSjcuMT2o/HbtEgSYMlNeT+VVQa3/aBdCz5BETb/i8lFAEWYHGJGsz1xzf/OJu0kvHp02xKY0VJMmnGxT2eOX/U8i/t1l/Qw76Z5R4qFzZNPSAalmWnf16TzZbBW5xMcfIgFAi/8rkY2QIAIqbQ8HXm1rI8d7uEc7NDqSlIq8ADJeqHt3M4jOeEnZbXt+ovwCt2+A/vfglJnQM80GMieryk7RHYzBQ1Asu/ZaTiFw+icjIDxis73Y2bgO432CSEXmUkceOjCHKBsyfoUNAhssrVM3Y4vmOn6jZbFLpaXaqqX/68k4pl777vyV1XKABxRJhOUwxv2qTZ9Z6dMmOKTMZX2oeFLfbfjTrxarRjkKnPnMAv9bingcCXF9kpYmWiiWx3NYx6kSJx3cP9tNoqNmPpp0jK/itsLWBTdSZtVITLMwHDl75jqF0af55dUnXwrNoThlo+fDFGoSOPHbqhdtDch8gqttrE7S2OJ9cINop9VlJoFqhG96YZhV4HFgiA/PEDwLbUfGDJ8KSBG9aj+8Rc84jEyAkzOrH+pse/emF2vJosnp9M2ODSk1lZ6NXlISl1sZztijzt/VG7IbGv7zfrJajSor+IihvZX0ABIMxbmKQ8nYAnW9Jh9lA+1PFpAanGIC2NrHy/kkNECYp32DtCj/V4VTJ2XZhviD5JFBcK26Bg02/WM07YEGRazxgMyhxO7R33wNMVCyyzrzFF6h5+ydC9Q3G1FL930oTEVaCA8kSEFjqxvBk09a2Xz+car8s36xppXCZyCe0HEnOpx7yr+FSqLkD0N8uPe4/fkId9SyQNux0kMVeA5AMuEXOdomZPtXmFbnWuNLG4itd48xdOb
 wKhz4c/3
 N2Erjji16tem5G3MGwl/sPgWozNz8DdxEZLf71cp/9wxENahZCmVtYzMC7kdctGw8bDCpi/6spJ3uir9ny/60Vu2XHoA97jQUVcNe3utc0IQWZgYZcFygKGsjf1uS6nXhRy+E17eZ+bkiTyuT//m9Y/rxuyS/SnTJ98hvKtQxQEn7x5BamJveAJmvYb98Av043Nb74NTZuKpLskmfXXwgKeRyrBuBNhbfewZIpxWAbx4T2qhRYit8lHk7n5EflhhqldAjJXwDRKtDgCXlrn27jJAoRffNUri1aZ+s4GheBHMvzLwsryWyCEdRifUeRxdaNrGbMSkEC0gtILgfKQCnmk4h/pCSHNpeSmkkzyUmepsFfCo6SXNehW3mOtA5El161FL7lJyczsZDVPM9rEQe1rkzl//kZy+dm5arunO63VPQlMUaJfgBZj4SXz74k9dTvO+RsLxqiQCWKbtMIzkcbQlnji0nsey2u0Yw6UV12TSHjaQV0zqyyH+3oQLdsAGA3w5WQL+149gyVlIOQUmNDTst7DEDMPZENsNjQxu1/6Usptj3cpxcshLQ3eLac2dhdq88FlVqh/G2WaOw+FlXcAASdPhYgQogo8SZXYboCuD7NdH1DfVak5F/xA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 08:57:53AM +0800, Kefeng Wang wrote:
> Another question is the target repository for merging this patch.
> Both this patch and the previous bug fix are based on the mm-new
> branch. Merging into xfs separately (if an independent branch exists) might
> cause conflicts.

Your first follow up fixes a xfs bug that can have somewhat nasty
consequences.  So I'd suggest you send us a standalone series that
we can get into 7.3 and -stable with as few dependencies as possible.
mm-new can get rebased on top of that, and then we can delay the pure
cleanups for xfs until after that is merged


