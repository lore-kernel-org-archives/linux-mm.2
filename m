Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D524DCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 07:49:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40E348E0015; Tue, 21 Oct 2025 03:49:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BE758E0002; Tue, 21 Oct 2025 03:49:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FB9A8E0015; Tue, 21 Oct 2025 03:49:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1F3578E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:49:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C606358A7C
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:49:54 +0000 (UTC)
X-FDA: 84021347508.06.C9AB5E9
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf10.hostedemail.com (Postfix) with ESMTP id 52EE5C000D
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:49:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=OW3j3cpZ
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761032993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X1AmHMZPbGfEo4D99A/2+yXenwXAflQA3dgEjfBmhjE=;
	b=WCMhxpd8SnCejvQz9FyXA7LxpUqOlg42utRVc8xklWruiKhRAIp7gmMgcebtnTeGLR56kB
	kxmrPC0rxayNVkMW7aV01Kt2qsldp5VhUNmck8IbZH6Nwl6Lrm45DsQWoKx1UK07en3DpZ
	tZO6Hl4OSwvQyrdtw+SfqPjSm3MhjyA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=OW3j3cpZ;
	spf=none (imf10.hostedemail.com: domain of BATV+5669af1c49f76a6ebb22+8094+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+5669af1c49f76a6ebb22+8094+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761032993; a=rsa-sha256;
	cv=none;
	b=IWDydrpZfD+3yZVTWBR1hCmZoI+emz4rDvciqvkRHwi1+BemA3+pUotWseOm+7YP9WnYWJ
	YlvgVFpmy3OvrCG1lTVwSjBm3vEZDw1sexf7tukDwoKy8wprMAiVkKE2x+WZgiyI1XlN7Q
	CSmxT8dSP0dfBjkDEU38vW/2jF9Tt6Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=X1AmHMZPbGfEo4D99A/2+yXenwXAflQA3dgEjfBmhjE=; b=OW3j3cpZD7DfoFDCZc8YBGCHTV
	Gq2dCWXiw0YgkWz2d3KTGPIHB2riACl8SwC/9E8acFS+o87US7hYHRnNvHi8P3isvf6E7EdjhZ12S
	uUxr2G7dYbyXEzHhGi6xTEvanmO6U7JcqtlHB93XzB1musPKxmhGI9V07bNQYdGnX0g6rMwL/8L0a
	cIZMk2dZ3lrYsgyZsh3JRmv1VL1JCmcOjCdeiOIsT8BS7/aVFiPF0C45ECw+Lfj9Y1G8pWFzrD72t
	qOqKJAjdwLizVgLuTU3p3wF9mQKsHG9fjhkwp5r0XOhzc/sCvqgeaIb7NUK0CNGKiKkWw2GhZ/BnX
	s57SBmXA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vB77t-0000000G9z4-184H;
	Tue, 21 Oct 2025 07:49:49 +0000
Date: Tue, 21 Oct 2025 00:49:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>,
	linux-btrfs@vger.kernel.org, djwong@kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	martin.petersen@oracle.com, jack@suse.com
Subject: Re: O_DIRECT vs BLK_FEAT_STABLE_WRITES, was Re: [PATCH] btrfs: never
 trust the bio from direct IO
Message-ID: <aPc7HVRJYXA1hT8h@infradead.org>
References: <1ee861df6fbd8bf45ab42154f429a31819294352.1760951886.git.wqu@suse.com>
 <aPYIS5rDfXhNNDHP@infradead.org>
 <56o3re2wspflt32t6mrfg66dec4hneuixheroax2lmo2ilcgay@zehhm5yaupav>
 <aPYgm3ey4eiFB4_o@infradead.org>
 <mciqzktudhier5d2wvjmh4odwqdszvbtcixbthiuuwrufrw3cj@5s2ffnffu4gc>
 <aPZOO3dFv61blHBz@casper.infradead.org>
 <xc2orfhavfqaxrmxtsbf4kepglfujjodvhfzhzfawwaxlyrhlb@gammchkzoh2m>
 <5bd1d360-bee0-4fa2-80c8-476519e98b00@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bd1d360-bee0-4fa2-80c8-476519e98b00@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 52EE5C000D
X-Stat-Signature: q18wmajiqr1puouq85d3c7d7i8sstnnu
X-Rspam-User: 
X-HE-Tag: 1761032993-319472
X-HE-Meta: U2FsdGVkX191x3HBSB69yY4jQuLCex5cuVF0pGu3r3qXkFpq2ZPe5nvqVChxorYBt4DkhAIijldXqKcpy+BZhfOIiNL8Q9SSpw0d9P5OzM66ot5fOA7ZtSDgdSTyaxZ+MkfWuN3KFn/TrOM8W4vj5mH/NgjjMAS0udbvfWoCYd3vZ9md8bhmfjLYpYUTnZKJ68z9CqKRAOfWlSKh7yBZogHr4FiEkKn3RhgCFmXurT5ndT+yynUy96jeRZtlGIlcS6CSqxTHs5g3QZA78G69A1AlbwzfKzWtQFFtR/uxX+dq/l/+RJWyFPNFRD2goZcE+SGL0pW1RqcvlxX/+AIn+lrzqkpFw9XRwTglnUdUqOT+RyRDM+oVho+oXaAxqS8IRtLhqTwcQMRSAGpGkA7gWjdDNyRLTvouK9OOIBpU52bOiyrJktV3xCj2n4Equ3gs/V0wMVD6J8r3ymaocvcL9N2iQ3CY5eZSLkdJdjbOZ5kFDTUJoJc2rcAmXSB+pcN1zKmW7pJcX1z+G677RFp6G4RGRAZ44NpNeSzkS1xrfLrmEY2TYNv/vzLum++JdQIThYeBalozdrFzqfTRqvdhcVajXsDtlnualbZQOT5CCGec/ni6wkrGHAVOghcXhyXddHGwjWgIAP3jInsbaLJ/OYx3TUPwc3pFCakYyUH4IJvSZGcP15Y2wIn2ZV6n16AaAk9KplmFr0VBvQj5BVA05oG62rdSInRwn/tqL1AmcFlSsHK4rJuvUCZqkfdSePYcX4NiPV2n2q7pIldrPIX3EOyz9BaHhWomZj52jIvjdXcq/SvGZqWVDvktn8tq5fgMd09RSEVRPZdEeXzB+zCQd4zlPgjzIptPlCQMGkHOuO3KJXc4imKDHhOsF7B1vXhQAi2TxQdVt0ztpl7MjLpBnoU88JVz6rP7YYUgUQCSZdhBXZUTR9CmK3k5FQdARldKw2CWAzeKac+VYsKiHMi
 427N2YYu
 eQFPgafKspZZrLHunMkVaroWq68gzszRTQaDmYTMZ0jvJXmhhgJZSHioZnP3phB9C6eRMQvi3YdUDeLldInZwyX9sn/VxLTAedHwnDwQR2zh0Wbj7CmrFVkZg4NudZU89E4kwv4sxvr+gc4Xb2ahg+f5V3aiBZmKy/FCJO1Q+BS0oARJmxl71k+s0nA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 09:00:50PM +0200, David Hildenbrand wrote:
> Just FYI, because it might be interesting in this context.
> 
> For anonymous memory we have this working by only writing the folio out if
> it is completely unmapped and there are no unexpected folio references/pins
> (see pageout()), and only allowing to write to such a folio ("reuse") if
> SWP_STABLE_WRITES is not set (see do_swap_page()).
> 
> So once we start writeback the folio has no writable page table mappings
> (unmapped) and no GUP pins. Consequently, when trying to write to it we can
> just fallback to creating a page copy without causing trouble with GUP pins.

Yeah.  But anonymous is the easy case, the pain is direct I/O to file
mappings.  Mapping the right answer is to just fail pinning them and fall 
back to (dontcache) buffered I/O.


