Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38209CCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 11:56:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 824CC8003D; Mon, 27 Oct 2025 07:56:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FC9E8000A; Mon, 27 Oct 2025 07:56:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 711D48003D; Mon, 27 Oct 2025 07:56:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 614FE8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 07:56:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0D5EC1DFED9
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 11:56:49 +0000 (UTC)
X-FDA: 84043742538.10.8F37B10
Received: from flow-a7-smtp.messagingengine.com (flow-a7-smtp.messagingengine.com [103.168.172.142])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4BA9712000D
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 11:56:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=AOl3ZdS+;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="0Nz516H/";
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761566207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8QkiUhrwE7SvkxSp/9VIHNDJrnJl5Yf/PMzKGs/KsxY=;
	b=RfjwSsY/ilWbiP+ikNM4ZiqSxNf43iRklhYO2SO0SG58D3y7PzolGQklXUtrCCZ2E4OG0d
	S8wGdmfiq7rVikuMvFXXk3Hm/f7Py/jikdRX1I/QjcxqzCWHZ+gd7g4iHbJ8GcCjyNP/j6
	/nfuqGZ0gsHY0N6Uj6lEvH+zD0TsvGY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=AOl3ZdS+;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="0Nz516H/";
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761566207; a=rsa-sha256;
	cv=none;
	b=JIVlGaO5f+X3y1yYWX/b2cypXLKdWF63HASoOHoAR+GnDBqMVwA/N5KmCOpBthhKvr0uqz
	hxltO6DpbEBxKSS28+LtUO4q9VitMYUe+1STSzSYQ1YvqXX8Pjg0+4aPCPmQwowAigrMgs
	E8FI7/KS+9KGWZbttZ72vAlbObmSfUs=
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailflow.phl.internal (Postfix) with ESMTP id 7E55F138020C;
	Mon, 27 Oct 2025 07:56:46 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Mon, 27 Oct 2025 07:56:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm1; t=1761566206; x=1761573406; bh=8QkiUhrwE7
	SvkxSp/9VIHNDJrnJl5Yf/PMzKGs/KsxY=; b=AOl3ZdS+ebhNCWQTP52MwZtdDy
	ifgX9Qmf/dZ1ZyXAzI6r3tRNGQ16WeG47Hz6WHPPGsXPshZYcQwCHAxcatfs+VUj
	95DoykQF93sMsvU6GWwhz3D9y7i2HXLrz7lnM26lLHOzEpRuVG1l7DpuVq9fw2Iz
	UYVE+UFIEs7wiAG4KSDLpJiKe8bhK6WkdbGxeV/O/c3RtwEC6RpiFbirWYi2vqS/
	qYRSgUzUhLy7cZ/kFWHLlfQJmwciNkcN+KX2MaM+CUox+vV7JtBwV9JV14mp4mGX
	4ZxnPO+Gc86S/0uaIFvBRS/qc+R8E3E6psIjUGkOJqwlHYmYAJld7WNwHf1Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1761566206; x=1761573406; bh=8QkiUhrwE7SvkxSp/9VIHNDJrnJl5Yf/PMz
	KGs/KsxY=; b=0Nz516H/O3edNSM7DWL5+Oh2DWYUWiSWSfVi48ls5mv32NQYKsS
	mmu8DoFt5EqUhpLQbLr5A8LCs9vqXyvWTdxQohnR3eKHlmZpYjhgv5NhpxYsn6Ml
	4gHJ0LSOD5ZyWj2hTTXLET0Vj5i1jMWijF+JJDC59UO5v086ZKuwWHehl1FoAXA5
	9kGYBswARJ2HpPVkJYCF01VvlIPv4vxAQevEWmXFe+cRGG5XzcbFXMy2h3hvGsq5
	PfqqtX/8oeHPFtEBkShlwBgjWNh3NeQWSE85H3t7WWWzsT8b0m+yAqEIcON6FyH0
	eHE/Isq75ab8tbGezAhy/D6N1MJiNAEfv8g==
X-ME-Sender: <xms:_F3_aEM5_LGg1cszjjnbkCxMxkhGvwLAKwaDuMHsIwAnn6jXSwZuAQ>
    <xme:_F3_aP2G60ni6qJQkM34HC1YMA7vvtXyGD08pzqUXMy5p940bDrSswHuJ63IjQx0z
    YcH8wAQzNXDKSEU4xSjccSMuFkHZClSYaZnZH4OjEb70g2EH1rfNHM>
X-ME-Received: <xmr:_F3_aI3Y90Pe-2fbuwd7Cb-_oz_EIIUJh9Gcclytji6UNGOo3XZjgXcIsVAHkw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduheejleduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecuggftrf
    grthhtvghrnhepteffudduheevjeefudegkedttdevtdfhheefheetffelteeiveehvdef
    gedtheefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedvfedp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunh
    gurghtihhonhdrohhrghdprhgtphhtthhopegurghvihgusehrvgguhhgrthdrtghomhdp
    rhgtphhtthhopehhuhhghhgusehgohhoghhlvgdrtghomhdprhgtphhtthhopeifihhllh
    ihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepvhhirhhoseiivghnihhvrdhl
    ihhnuhigrdhorhhgrdhukhdprhgtphhtthhopegsrhgruhhnvghrsehkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdrtgho
    mhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtg
    hpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:_F3_aOyxtJGiAVeIFw5YuI7E3rf0w24TeZ_3QWJEHQ3wnzXsd43zLQ>
    <xmx:_F3_aLkioqsZ4O8fSJGjV_Ajxfn2pp9jj1iJPqAYMafdU-kELBIMEQ>
    <xmx:_F3_aCxG8f0xFXuOh_887PP1j7WImMOsAibUdZjOegr_mWgAFkVY9w>
    <xmx:_F3_aKKoEwbsq_SgslE1B4k74GLwG7K0eX5YBbVmH12VlgYr4gSzLQ>
    <xmx:_l3_aGXbf2WLSgColDcOgQZY_p2Sirf6o6-tGU_Ywk1gS-xom0z-jX2j>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Oct 2025 07:56:44 -0400 (EDT)
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
Subject: [PATCHv3 0/2] Fix SIGBUS semantics with large folios
Date: Mon, 27 Oct 2025 11:56:34 +0000
Message-ID: <20251027115636.82382-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: egmxgejm7c8or95qe5hmbwpx38d3aqao
X-Rspamd-Queue-Id: 4BA9712000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761566207-952467
X-HE-Meta: U2FsdGVkX1/dDJJXVS8/kTbL8vBlqLzb/C7cAJd4dR3yrDlm4pN/mirHyL2RLpcqU0hUwkLIj01NtR9jGUQ/Gt4XDUPQYGGKxuxGIWN1fUwxA38OqM7lSx9F+Bq/t7rSfQ+rL014U8S2Iez5VrCf9b4Tw9tiTDm5B5KcwRiHshDxDHfEVfhNV5niUpTXJuLPMCnnHaz4an8M7m5lZ2M3INXZ9BDECDqVJc/ws7Ay8oq1P7WnNYO8HwElg63avvFP3VDmbAxAAbo4YCxqUygACah+tAKLKHYwT0oaUZiLSN5I1nLGGtaWUMMzXI5J5zDtVoaE5b0dqc55QTy64q7CNQwnvOYud8Y1X/rxvK/i2kpNfgIU8Oa9Smo1s40o3yM9PEMT+T3mp1i8z+jQVxasBK3Hmez8iys/lK2kaLQIpI/k0WpoEDJQtjow7ueT2Rc2gkERHWBj26q1H5I5cReRcnXDgRMUmsp2mDROgg7XFsPQYx00dPMAkWnn4u82eLaVUjINxnJ0z/aqu06XNejb30hJ9+paYgPK3iX8S+7Mar3PqKxYPjyxrg/6uwfArRzj8cda7Tt4fiodIm+D8UxHNgNl41ImzpVB0zZZSFlbLe+DFPoIJQFnIGm0/mhvRBSggxUwSfLskpZ9LrZSk4w7KBb0JuL9DbMUd8YO5wcQ3rRrMwuVDW78VuYUPaU4uOhudML5SAqi9Bp3AisEMmRaVl5YidDQzIOYlV+CQNZnb+OR5m4lyx9CMBOozBrSZFrUzIOTWMAFqdLzxih0HqR9tDswnAl5ZN4tQiHX601B49aBscIoB+RieY8syrUgE8TBKLTddf7DnO1kXBr6sx8SCU9TlmDZ+/qbNS9DmD5+BJ+RcUeeHTrWTrXA59RoWi5MrhPVp+x3LOUq9QcYVPym4Y3T3sRLXLg8zQWhZwxUqGdYHaOzQD5UrnUVkC8AQgry
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

v3:
 - Make an exception for tmpfs/shmem, code restructured;
 - Rebased to mm-everything (v2 of the patchset reverted);
v2:
 - Fix try_to_unmap() flags;
 - Add warning if try_to_unmap() fails to unmap the folio;
 - Adjust comments and commit messages;
 - Whitespace fixes;
v1:
 - Drop RFC;
 - Add Signed-off-bys;

Kiryl Shutsemau (2):
  mm/memory: Do not populate page table entries beyond i_size
  mm/truncate: Unmap large folio on split failure

 mm/filemap.c  | 28 ++++++++++++++++++++--------
 mm/memory.c   | 20 +++++++++++++++++++-
 mm/truncate.c | 35 +++++++++++++++++++++++++++++------
 3 files changed, 68 insertions(+), 15 deletions(-)

-- 
2.50.1


