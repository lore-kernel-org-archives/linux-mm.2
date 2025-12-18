Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9959ED66BB3
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 05:15:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF7096B0088; Thu, 18 Dec 2025 00:15:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA4876B0089; Thu, 18 Dec 2025 00:15:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB06D6B008A; Thu, 18 Dec 2025 00:15:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9B376B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 00:15:20 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7A5DE1A0CDB
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 05:15:20 +0000 (UTC)
X-FDA: 84231428400.08.EAEB97C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf10.hostedemail.com (Postfix) with ESMTP id D5788C0007
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 05:15:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=DlXsNLWy;
	spf=none (imf10.hostedemail.com: domain of BATV+3d4854a57dc9b1fc88a2+8152+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+3d4854a57dc9b1fc88a2+8152+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766034918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pZxlOMsvE+RH64A0rSpIUqm1vokkH/Qn2MzrD405vQw=;
	b=jXlb6K6MRc96uwQAA6A1bR0GH7TjH/EMIWzjiQUaeTraazkFoGNNMHg4CVwMOqeb6apu/5
	jXPo6I/hcIollDAHR0HMDku7f13i9nuEVCzP1Pb+3w1yfLe2T4t6UPUvg2Z8pPTYgg8wsN
	BWZs0f/ZWn6CtS6m5b1p6ABDsmb+CNY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=DlXsNLWy;
	spf=none (imf10.hostedemail.com: domain of BATV+3d4854a57dc9b1fc88a2+8152+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+3d4854a57dc9b1fc88a2+8152+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766034918; a=rsa-sha256;
	cv=none;
	b=WUAwpH03H76A9Q3sD2JrGUpYr4/v5oiZykcvTyYEvZdLz5cWQaCsPDSDEtFysv3NjTNkYJ
	md+5OygDTcPmySNvt9vGg5RJI+uYJoy0RkKdP+Hxcf4wRTf8MaioN3FSeRuXK48IxqrHG2
	3oFrlOdiQ7GWjr2nsU1qfhvggBMqHg4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pZxlOMsvE+RH64A0rSpIUqm1vokkH/Qn2MzrD405vQw=; b=DlXsNLWyGVACHQopBo43OKOTbE
	L2Z4elzxjIShvywtgctmFqnKNuN6iyI7sc+uo7cx44sXqLiAHBUBYY+GTEtlmt3b9Eri/TM/Q2Gf7
	M2+6SH1Uc/VyZzs+EL1ZJRCoNIPQpjvhVhHueU6m9MCBiJognqqIFDRUCAbHYyxGBtdYNWJqikE3Q
	WdMFI6sx3MkyrmGcUNbZzDZJnh/K6eiuPtzZzXfgrwTkO/2PJcCJmO34EDCUrXMlFudPyonZnbm9H
	sMKdwFUY+5V/BZFnAjm6xuwYHonn50X/qqrRtYx2KvswMBsjr4vwKrOpUR0XajEAcP3V6WMaK3CFE
	3XjkA3Dg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vW6M7-00000007osb-1ujc;
	Thu, 18 Dec 2025 05:15:15 +0000
Date: Wed, 17 Dec 2025 21:15:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: syzbot <syzbot+ccf9f05f06b4b951f3cd@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, cem@kernel.org,
	david@kernel.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org,
	lorenzo.stoakes@oracle.com, mhocko@kernel.org,
	shakeel.butt@linux.dev, syzkaller-bugs@googlegroups.com,
	weixugc@google.com, yuanchu@google.com, zhengqi.arch@bytedance.com
Subject: Re: [syzbot] [xfs] general protection fault in workingset_refault (3)
Message-ID: <aUON4007YupX-eRQ@infradead.org>
References: <6942c6f5.a70a0220.207337.0063.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6942c6f5.a70a0220.207337.0063.GAE@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D5788C0007
X-Stat-Signature: 74sz7gco6a9sdt48raqxoxjf11jexsit
X-Rspam-User: 
X-HE-Tag: 1766034918-214
X-HE-Meta: U2FsdGVkX1/D7XUV0i4RP2qMof2VQBmZ4ODB9WvCjcZwWIotKzkQecoIUrYaVJWqydgMUvZtbxgG8V/KgYL2pNG18vQGYlALxzWP71ygfAOrMeDbaBpbAssoDGG1CVoaHIX/HMB87/idDa7fNHHauHKByCmlaZt8yOX2K7BT4Wwd39Tv8kvMh1CWB405i+JyRUQFy4VyqM9xctH2XKKpOS7PzRaF0cCJlzkFPjL8tpRYno3tDeCwuXKE1ZF442DuUY8d+t4tvcOlx8nN1ztzYu83qaFQyx8Ya7ThHaqB4k2S7df2zPglNdbDzZFPBLktItK/SXVq+YGhKt5So+BtLE8r/rzoTrPrNcBXNw9ebwsxc7CI2sBhhr40KxPkBdtYbrU2ncKCloL9EkyK1K2eocCz3dWzKXHMhDL4q5dqNGBGg6bKK+tOQRS+VZmSGY1B1CP+10/GNg3qrJR6pEneqdlOLXgvCorOFdVOQm5pC8vxUIOwUObXtuJwvFsH09wyRQDb0qu2XTLPM9xZDPnOfyv9+x2neSgqP+o85AIphxEBPlfj0v9XFHb5y5qJ7ONzKRmmqhZ9HiYkHC4OPD1L2OKi4p4XNRWWvM3+dcJ98idEQjoHq9kud/1Gm4AzzBYjL+MleHlGV6J+uw4QxjUpLzyb0xMCA0EtxluKiFQVVqhrDVMgxE6FgGLgufWHN80WzpOfg6GtCy/YlLWbgOfxAjOLnvLzzk4/MlvOuTSe7sawCIR+1VNsmvuZGwSuwmrqUyxJzSH7veNUIwgqbV5Pb04t5C/c4/FasOrPLIVBdUqgWHOpY/mRSkxM6bXPqP2Bc6vJmuOYm8kO/3JP6l+jdKC2kuwut7qSDQ065vFTnPf61uqcN73g30X4r7iD/JOseNIO5bDZSvUypEqSm+vNDY8DoX9xx7HRpkKKL2N/qLi0szwkWyvFT4H5ObhAEdmvpfsvFnVd+cbMlvn3gDp
 gkDy4+m5
 HBW4/jYc+sh43GhMSljcMw5LX6y7w86sqUxLH6+h6IY+ep+VDDKnOUef9GwdLxETawhA5FUc79hh2wMKt+41zX5UecR6s/ymKJELtw1if2fECNh774KB9wMriZvaK/+zllCKEefNPlSEuZ1jh+P0ZbaT1ZKUnP1qAOGoJrwgRuXlmc1HagKLTqYfSL+E0iPESHsdLuR5BjYJWkYipSO9ueCmiLOK1Mytu5pUi3PL1/D1jL+ojCz46pcXm6f6zj69ozLIhZUNF1PEtq3jwRjNPB4I8c9EBW9PgydkKGPKBRrmHvUZ1Md19mMxC5o/7/GpTytKJ4xW8IF2SQEVtkts6/qOA9sdDmNvYVxI1OJGV0ymBmQ4wi2KyuUdMP7BJCCSSuiJ+vZ3GRw7WgevtRCikhzJMo/bVC0QJvaa/yMfAfB9SdgLEldN0inQnf6YIWjlLZOv5dGegJUH+kQupyKyDtMlnGrdrfBquU/cN4fpMp47HXMcw78H3E094upbJyAh8CoCyR9Hqr6B2jg/jSzrKFA4OMYOQ+De9sF2A0UXnksu6pkHsJDSaF1K/rMPrJ5NQZ0qoQrhecHgzCmJLHLyuUe6ix6o2uFYKdLv/4/Jlg7Fp4esp/zZ7XlhaVzoBVYB4HlhsE4k/KN6iN7w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This looks like more of the freader mess and not xfs. In fact I don't
see xfs anywhere in the call stack.


