Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07627CD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 08:46:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5076C6B0005; Tue,  9 Jun 2026 04:46:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DF2A6B0088; Tue,  9 Jun 2026 04:46:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 443716B008A; Tue,  9 Jun 2026 04:46:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 390DF6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:46:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 022351C276C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:46:45 +0000 (UTC)
X-FDA: 84859743612.12.9CFA3B7
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5ED5DC0002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:46:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf10.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780994804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DYVNx1uOsTLeOYeVo31w59uoqTKrWOiDvlZxjHF6Wwc=;
	b=QFAmH8c7jNRfw5cZ5qgn2JOvMon1MxJGWlNZhhZsptuODtJjAEVuQwZnS6uJSvAsIi2BWw
	jm8QyAaQjBcaOTcvCmXKy/xbEpNUUybvzV3KuyPdRbKNZmFsUPsTECVPEurt6yiWhfK7nm
	HMZR47Lw8UGV89aHh+rdUBDMpY+I7gY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf10.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780994804;
	b=6bKvSzPmxPHx+0cYmArqv7Scn2I+VMF/XPXBEdeQHIWOb+3me8GoaMpzYwnYsel/XQJIV2
	6HNyeeoV7TMq9upejz0pdZe4nmDbXVyq8FnIZvL2qptrJGwAFOFngxYkJV22jISHNbxbAb
	XeCjiuvwwPNSN0oxn16r79s1Y7aYeLk=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1431468B05; Tue,  9 Jun 2026 10:46:42 +0200 (CEST)
Date: Tue, 9 Jun 2026 10:46:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: Baoquan He <baoquan.he@linux.dev>
Cc: Christoph Hellwig <hch@lst.de>, akpm@linux-foundation.org,
	chrisl@kernel.org, usama.arif@linux.dev, kasong@tencent.com,
	nphamcs@gmail.com, shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-mm@kvack.org
Subject: Re: [PATCH 8/8] mm/vmstat: add NRSWP{IN,OUT} counters
Message-ID: <20260609084641.GC11917@lst.de>
References: <20260601113449.3464734-1-hch@lst.de> <20260601113449.3464734-9-hch@lst.de> <aiJ3xfFxcS62MOK9@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiJ3xfFxcS62MOK9@MiWiFi-R3L-srv>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: yacibto964e7y4tpqx1pyntrqjhf1b6u
X-Rspamd-Queue-Id: 5ED5DC0002
X-HE-Tag: 1780994804-511204
X-HE-Meta: U2FsdGVkX1/9n7MnhkNm06gxNE0yBTX92u30fuls9BK9EDIvx8dTM36mtQRfWmafRBzBZwPkgqNxs+gS6wliPyyDHPSviKFa3gr3IkFVNp4nFmfqO1eQMToJUoCyxCcYrLgjx5InZn3iPXcjqUKD6hhx+CTmgsNPep3ky1DhlEaYaOmU/EtcB1Rm8c5QPNxpnH/nc7FUlAIVAUJNDR6BVVdfhIveA36JnuRLApMwJVOfdEc6K67qZkVx4VKqcocNkhV6EnfKj4HRgn8jBDRSTPE/jXclP45Aa0Am8c8DTqai4Z3JtNMOBYoub2OEYFuu9oq93k/j8qAeBXMy8yXMLPPc08q10XgQhtXR/aNpgo8qv1HFZXorbLZZM0CLBTtUQQDe6jINVoAqPPmz1FYlkcqqQXP6VcHM7tchUVWWUgFKpFGiSNuvX0tLoHNhvGfEgtwAyVG+ZBcD1GTuaKpaidH2ZV6e/XcpROIKsg8dT/x31Vp3pzYaOKzomEPj+Z6LBIdB7FuRqUjd1NtRIspSXcnoHVwu+pLbQGyjEP0NDh8H7ZZKddTnmD/DnUgHts7Qf12LtOZm2JCPEScn4eyIC8ViPNQmwKzkHzss7wRINwPe5+geLMiiTSnaQXws0d50BxYfWrrbmLszHCODvj5yhQFLhJlV+T6lAi3jYBLXA2+TMxjJygRWCQ6135VQySOg4AdN0m2mKtxxVHkK93vhJtKpY6nnPFTQBFjC3cfX/XVhlVE9y20fZxU+rk6FifocX6l6sVUpDRiQMCXmZzyyVo2fkOAhfnTAFMLamvkeo5pYDHQhbCO4k4yUPCFLIgzPtwN2lgi+44WSe5vuxuWWuxC7Q0z3bJgaW5XUWxsoNReg4/lXJ90t2Hil+G+A4v8ph4cL/Xr+aQut7e0xwLhpFzSpD+0r0lqaurUhAZFJc2w0O+kS6T/Oy/X22XkpQJqub9BU9BZIVYyUBfn/qzx
 fOn05pcc
 Wck5ZVYZgU8/H0CvCoJPFbCXl3hi2r+hWKuBZHgacOnbT1QiHj7dubBrnVb+GXVk9cPenQ8VI3zTwm7N4r3RVND/JKRFaDmR+9+RX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05, 2026 at 03:16:21PM +0800, Baoquan He wrote:
> >  #endif /* CONFIG_DEBUG_STACK_USAGE */
> > +#ifdef CONFIG_SWAP
> > +		NRSWPIN,
> > +		NRSWPOUT,
> > +#endif /* CONFIG_SWAP */
> 
> Putting them together with 'SWAP_RA ... SWPOUT_ZERO' could impact the
> ongoing program/script?

I was under the impression that we should not reorder vmstate events?

If reordering the vmstat output is fine, I can group them.


