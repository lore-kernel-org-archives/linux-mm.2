Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 582A8CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 09:33:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64A728E000E; Thu, 23 Oct 2025 05:33:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 621EE8E0002; Thu, 23 Oct 2025 05:33:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 537648E000E; Thu, 23 Oct 2025 05:33:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3EDCB8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 05:33:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 10155BCD0C
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:33:00 +0000 (UTC)
X-FDA: 84028864920.21.4931F82
Received: from flow-b4-smtp.messagingengine.com (flow-b4-smtp.messagingengine.com [202.12.124.139])
	by imf17.hostedemail.com (Postfix) with ESMTP id 104A840004
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:32:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=WXD9J2qo;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=Ywj7+ApG;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761211978; a=rsa-sha256;
	cv=none;
	b=Q7VpGcqe3poFCM1vRs0ARGQdtfADXjrRMV/WQxTfnNBAZX89NwQaRrIpP0aMUVcawMW4g4
	D/legFgy3xzVgtbdiC1tS7h0Ucujzml4wN3JV0VDBCix/HaS2AnmA9jl2bqr5RyOHXBXvo
	Pj1L4qI1sCx6AC5JEpMsuMMGfaBPRJo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=WXD9J2qo;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=Ywj7+ApG;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761211978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JpEbXLdyv4zRi9q4jG2thsTB7UumiqydROSACboCZdc=;
	b=YYkCM723/O3iVZwDzqXDnfL5piKRPSP41OHMeSjlJnOpki+sXH8XWU/cblysQKI3KspcPj
	GMSrGmOftkhV89CPn9xU2VGNNWe7BsT9Pj0Ye0fP+POcXJy/UmWOg1sjRtcl5FbLgedBy7
	KFypt4ZcVWmeNMcqzXOTGDVswTX0ztU=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.stl.internal (Postfix) with ESMTP id 9B08F13000DF;
	Thu, 23 Oct 2025 05:32:56 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 23 Oct 2025 05:32:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm1; t=1761211976; x=1761219176; bh=JpEbXLdyv4
	zRi9q4jG2thsTB7UumiqydROSACboCZdc=; b=WXD9J2qolILlMu/wSfALLzy5zp
	xKjuoLs2NvfrOf0avtbD1zadDqGtSUN/e3+8hhElUB/pWrZGRa35cvxL8CBOytZZ
	IF1Uw+lZ2KJOdJf4vteKev+a1a7iw5GvY1r3EHBTrrMvRMZ6IHMj5o9kajt9gr1j
	7TKc6HCl7BA4X/tUQ9OJpR6TlAykA6owKUy2C0v0+MEK7OUjisf2ey999kmUH6Ke
	2IQ4YbLjrIY7by03g+zjshZ4TTips3/2DSlExeHa1IIhz300Kz3svDGh7LJutbdw
	MsAJMJ49e0blRJ3Bu5YpFC7UG0Lxunwxd7Kv5sR75wppGjfaxjtfMrPUDv7Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1761211976; x=1761219176; bh=JpEbXLdyv4zRi9q4jG2thsTB7UumiqydROS
	ACboCZdc=; b=Ywj7+ApGd0dfST1EClxkJiq63ZVw8nS0I0KH0NzRG11rhKpQl9d
	UM5sQScTUXrhgnrkSNEK86ZcySei+uZzegDTPrCSu6Z4m8Ucb5Kvy95CwaGbnY88
	/TvffQIincitKWd7fKUQH21EpwTCLTH/bqpg0mxyIivhUIBVyTajkURTozxNpaik
	McbN+nGqf2d5xux6FrXiCqN+og9yXTef9BrThVkhOIkM22GL95a09N48tdWmuSAM
	NxT60nYfqZyEmF1m7q1k+BwhS/hJmFBJnccCXPNCk/w/wWM7iyq1TvgZQR4BkiIB
	T3EUqbbSSOCZ9gN7BRGWKIlQZigXDJrWy5w==
X-ME-Sender: <xms:Rvb5aKJAEFanFnza2LtsAO3cwa5TVb5mtWsDDG0jRIpJ2WKxGGjKtA>
    <xme:Rvb5aHAEplJEeuqtc52ETz3YkyokLCLggxeLN2CZ4nc8xukvTHgYszQFirKFuHs6Z
    Wsc8iSUYVutEDYmu1EkUnGgqPsi2ox2E5gdIw1vl58KJ8LQHgW33Zo>
X-ME-Received: <xmr:Rvb5aISUGOid_JLDRxWbZ1bLIfQEdaLvUzXw18E9pSwAXfNoefyzIi5td670sw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddugeeiudduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecuggftrf
    grthhtvghrnhepueeivefhieejtefgtdekveefueeffedutdeukeehvdduveeufedvuddu
    geffgfdunecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpohhpvghnghhrohhuphdroh
    hrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehk
    ihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepvdefpdhmoh
    guvgepshhmthhpohhuthdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggr
    thhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtg
    hpthhtohephhhughhhugesghhoohhglhgvrdgtohhmpdhrtghpthhtohepfihilhhlhies
    ihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehvihhrohesiigvnhhivhdrlhhinh
    hugidrohhrghdruhhkpdhrtghpthhtohepsghrrghunhgvrheskhgvrhhnvghlrdhorhhg
    pdhrtghpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpd
    hrtghpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphht
    thhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:Rvb5aBekOFYmCwP8MdsVJR3vq8SjIXp0-rmqH_luY0mDmdodx3ybVQ>
    <xmx:Rvb5aAjhBm2328QNuqORXYxyoEmVUseXfE8zil5T5WC2uHeKtZgZdA>
    <xmx:Rvb5aM9HpcvjXQNOWjwIQUeVq8LUtTXKKLHeKPmk6e5zK33H51vN-g>
    <xmx:Rvb5aAnNdDGFi26z0v-H_e4ek3IDZD6UN9okh2xgtUVdCls8yk-Cug>
    <xmx:SPb5aIzkbfmr8tJe4A1IXhYXWGIKA1RCbS7L7CafQe7XKPOui_lhaVjU>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Oct 2025 05:32:53 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv2 0/2] Fix SIGBUS semantics with large folios
Date: Thu, 23 Oct 2025 10:32:49 +0100
Message-ID: <20251023093251.54146-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 104A840004
X-Stat-Signature: zcopyxskn3sn97egm8um34yd1wt1sqsx
X-HE-Tag: 1761211977-794862
X-HE-Meta: U2FsdGVkX18bFmpbp5sScbr3QBcO/5d/s0TqiLOTtaYPWTD9sOo0L/dTEaD9mWoPM1d0btOtTgMSAF/5u92Yy8EO4QVfUnjWyGuTSMWnw91gTdagYrlz8FtAKFo6iBENdlFGZeAxEwLbzqPhgtwImtyeEncwtZD28CAoymZV+PBNMPO7vibXIj+WWm99p5ypNO08YEtwBaQwVj5Julk95v8ZvY2cghTrYPKLPCTmp2V+Frl2kjMt+JGIkC2po6DWKOyuxKCA40HzGikXhbpPLqaZLoNi6pd5q3vEtg6UovpD2nRCGtP8Bci1hLqaZQZB74qUpRe2h8Mbw+jume1AK2Z7gs8E4HZY08pPp2ENRll+vGR0b6KB3OMhwrWDQLWDyqOP2LT9jWUkmubX8gBGaeCLl/wvEcT06Fmagy4/qxf1ZSFg376OzLizDtJ2stPAHZpfsGvgmVCDkHeg4ucQA6JecOAetw9GI8pXuXmLTz82HsWjNL8N7H/Za7fM4YnvwwNk1+UMrVeDj5/45Ux3y6f0Nolgjoz+VuE+FvfcGl7XHJ84dHcvQM2YwZd6bYj5y7Lhw/mcR7fF7hd+cImhwtOYWj5PRH3aYH2vsA4nQOFYDg/Je4fl0D6ERAWLQdoD6Jx8yVtmrfSo137eWyV/E0s2Gv474XZJBXKj4ZdW7d4gQ+DZtnWSiMfA6A1ArF1mcfgClqrX9lnMDS2BI5+nSSrnOh+tWUtWlpBQYbTnBxxUyflyXwlYbN94i7Apq7vMemiEMqMirFcwDs07lgfcg7XsDnHzh32FoveNHPKLj6I0fvxGkLqtbbJq5/8vWQfWp7RDsKcsV96WcRROrL2Jz/wp03+oUuB/RA1nFKyowoUTu7XwueWapBpDeKKPEg8md3qYFikA96HG468i53ktaDUYsh6N0c/+SB+x91XXv1OsZuZ0JwOPZWELAoElxC1BRNYRzAz6dLNXCm2rOYX
 mdaS673d
 f5hSeyHM/wNXpYPlRSzGF8ZeIYLn/zwAYUJBjCuh61g1m/l5gfAn8RbiC5ah0wakFlk54mtdIlquZWB02RPtl9nm5dqZusnz3zAIGIWQo05XMs1/8lFFzR9yQxCmECInujvQoGCV/CVmf3m09TI4vkSOUAuxG9doEJE8NnPGafBx6Ho4Rz+6iMLDAJcp9RSqPnKZJLNemlMh1zS0kJF12siha5uNOSTTlR8DWS19BMcE/ORJe6qY2GeZFq6B22TY/yeearuOJv5xBPndYjLN87UHkzLupv9M4PyYgzlPi7bWhX9TjXfuppKMo/SBQuyC0FCx2mtRSK/v7yqMTiiRnOe2eX2x0UezCDnDJHMtnXRakIeFwgx9L2l06SibVjsSssAyNpwdchjXZ/LedVYaNL+h/2n5+bL/5rjtUplzoU+ar8Y/xadF3rkfxGso/nkOkSNbgI2PZSG9I1k3dS2N+KPA89YUxeorZKg4wvzByqM90OT9l451FF5FPN1OzdjTyxA2f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

Accessing memory within a VMA, but beyond i_size rounded up to the next
page size, is supposed to generate SIGBUS.

Darrick reported[1] an xfstests regression in v6.18-rc1. generic/749
failed due to missing SIGBUS. This was caused by my recent changes that
try to fault in the whole folio where possible:

        19773df031bc ("mm/fault: try to map the entire file folio in finish_fault()")
        357b92761d94 ("mm/filemap: map entire large folio faultaround")

These changes did not consider i_size when setting up PTEs, leading to
xfstest breakage.

However, the problem has been present in the kernel for a long time -
since huge tmpfs was introduced in 2016. The kernel happily maps
PMD-sized folios as PMD without checking i_size. And huge=always tmpfs
allocates PMD-size folios on any writes.

I considered this corner case when I implemented a large tmpfs, and my
conclusion was that no one in their right mind should rely on receiving
a SIGBUS signal when accessing beyond i_size. I cannot imagine how it
could be useful for the workload.

But apparently filesystem folks care a lot about preserving strict
SIGBUS semantics.

Generic/749 was introduced last year with reference to POSIX, but no
real workloads were mentioned. It also acknowledged the tmpfs deviation
from the test case.

POSIX indeed says[3]:

        References within the address range starting at pa and
        continuing for len bytes to whole pages following the end of an
        object shall result in delivery of a SIGBUS signal.

The patchset fixes the regression introduced by recent changes as well
as more subtle SIGBUS breakage due to split failure on truncation.

v2:
 - Fix try_to_unmap() flags;
 - Add warning if try_to_unmap() fails to unmap the folio;
 - Adjust comments and commit messages;
 - Whitespace fixes;
v1:
 - Drop RFC;
 - Add Signed-off-bys;

[1] https://lore.kernel.org/all/20251014175214.GW6188@frogsfrogsfrogs
[2]
https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/commit/tests/generic/749?h=for-next&id=e4a6b119e5
229599eac96235fb7e683b8a8bdc53
[3] https://pubs.opengroup.org/onlinepubs/9799919799/
Kiryl Shutsemau (2):
  mm/memory: Do not populate page table entries beyond i_size
  mm/truncate: Unmap large folio on split failure

 mm/filemap.c  | 18 ++++++++++--------
 mm/memory.c   | 13 +++++++++++--
 mm/truncate.c | 31 +++++++++++++++++++++++++------
 3 files changed, 46 insertions(+), 16 deletions(-)

-- 
2.50.1


