Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9E2ACCF9EC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 11:56:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2583180040; Mon, 27 Oct 2025 07:56:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22FA58003E; Mon, 27 Oct 2025 07:56:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D7DB80040; Mon, 27 Oct 2025 07:56:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ECCDB8003E
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 07:56:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9791516058A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 11:56:53 +0000 (UTC)
X-FDA: 84043742706.27.61BA100
Received: from flow-a7-smtp.messagingengine.com (flow-a7-smtp.messagingengine.com [103.168.172.142])
	by imf29.hostedemail.com (Postfix) with ESMTP id A89FA120002
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 11:56:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="J gXUErh";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=c1+dniXl;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761566211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K3fQ2fEoyjQsfqeD80DG/98tb3JsUKWLI+ymnihBKZ4=;
	b=EV6s+W+yDaFrAUDelsX+gtBIs379fyRzkJVjH1tl5ye+YoE4U3ltGk/2tAJ5/EAb/EK3ed
	N32D2p+wlSC8TbWsE8TmAH5JR0pyO0LIbf0wRyCs5bMtEsVB5XRzi8uQIoO1fQkf08XoMD
	f5UKlg3Ee3dZtYbfD7KahmXZlazw4xs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761566211; a=rsa-sha256;
	cv=none;
	b=NFKsv36tKojsbFbKCVurbg1Lrr/I2VpkHQw6UfF5CVTIIb9OQGbH72lZPa0e+2jmTe673R
	ARtLnd/hBlNzt0WYL/S2ig218RVWH2Uf3+kFn7MKAgFgrcCiMMcxHiwdG59vo/JF61zK/j
	Ua40irLK0BdB5qM7WCPqQCmOzLnQU5g=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="J gXUErh";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=c1+dniXl;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.phl.internal (Postfix) with ESMTP id 1D85E138026E;
	Mon, 27 Oct 2025 07:56:51 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Mon, 27 Oct 2025 07:56:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1761566211; x=
	1761573411; bh=K3fQ2fEoyjQsfqeD80DG/98tb3JsUKWLI+ymnihBKZ4=; b=J
	gXUErhSWuZVAtKi8moOJOqmc5aoBDcOEaWX1mwnXUdmPhGK+tIZqpzdUl+FpCvSx
	074QdIvn3KUhh8GwEIddVren7KuYmpE4RprMoQYMtin4SQ1CsUYYL+4p1qwpaOqN
	piTECd0loRLFafAswOP8eHjBX6Hn69qDVSmd5IKnr0mOZcPfLgIM27oSjaf//brV
	L4VkrZ0iuCF13hQLup0736cGRQ1qXKewuIjCeN1ae43Vp4TrNUmnsk0paXPiM9AD
	XpuQOO/3GHxCZFI9yMAMRB5bqBx19MLkVnUqJlfUzbxbk+oOMH2vB9y899m+nK6r
	sD5VS01VbFUB/YAqxrZ0Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1761566211; x=1761573411; bh=K
	3fQ2fEoyjQsfqeD80DG/98tb3JsUKWLI+ymnihBKZ4=; b=c1+dniXl1Jm+aRbgu
	hNs/r6PllBXokTSetn1vUY/FHeXtwdFyjpIXs0l/yVF097lGFYv6MJQCco+n/Zjj
	rRtKffdZhd4oC/YYDheQHUV6+ow+nMPKYsYMUbMUzKY8jDPTbtbt5dUT28Kbta4h
	/4/3rIT+QM1w6Ei9/LaLr0BT6h9n9hhdrXhPUgJ4Yn09tAy1wer1LxIRDHkIjJQa
	V1N32j/lsCKFcu0x9oZbJyq8RIVGP4Nzeg2mxSzMJpfbwPgAxYbxs8zmevn0dFRV
	y8boD/odka6CE+62LuswRvxVs4CP1MEAS1pxNdJSU0vaTBX+9N/nd+kH22A08PbT
	N3NxQ==
X-ME-Sender: <xms:Al7_aC5IuUdzJqK3iP8eLwKCiHI8gAls2sxDUHgrzo9mU6ZphfpM6A>
    <xme:Al7_aAwDdnG3plAFjSOAuXKUJCQNoXraShk1clljJR9vjNjFl0BVwNl1wjMnyOUaS
    rLVgsVrxyOW1GloZ_J9n9DkjmBjq4JayRjDG0weQWRSZK-gYdyeiLA>
X-ME-Received: <xmr:Al7_aPAkOOXH4XfGVOWUniHLloKqzN80GbDARzvXypfLcf1RGQvVwZWhatfRVA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduheejleduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepgeevhedtgfdvhfdugeffueduvdegveejhfevveeghfdvveeiveet
    iedvheejhfejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedv
    fedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfoh
    hunhgurghtihhonhdrohhrghdprhgtphhtthhopegurghvihgusehrvgguhhgrthdrtgho
    mhdprhgtphhtthhopehhuhhghhgusehgohhoghhlvgdrtghomhdprhgtphhtthhopeifih
    hllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepvhhirhhoseiivghnihhv
    rdhlihhnuhigrdhorhhgrdhukhdprhgtphhtthhopegsrhgruhhnvghrsehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdr
    tghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpd
    hrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:Al7_aBMq-kOmga7bCEzut5AgYefmNmDwOSaZ-O_TGXzLgWzOsMCWkQ>
    <xmx:Al7_aFRVHZOp9IFZGohrX1EBQ_ko5Nt4iCkzd63ee2m7TR400goGag>
    <xmx:Al7_aCsUwU37XITVB9K7Z_eMbIcBZwsjQfeyS1Lidrv_8z-_inEYdw>
    <xmx:Al7_aDV4tb0_boeDmoFDjtwGrSrjWsbzqDsZK0Y6noLl8H0oNaPdrQ>
    <xmx:A17_aLjWiwemAVVxhDloKxT3SckY4vHvc1iyiDO7BYQvIHg6LnCop8mf>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Oct 2025 07:56:50 -0400 (EDT)
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
Subject: [PATCHv3 2/2] mm/truncate: Unmap large folio on split failure
Date: Mon, 27 Oct 2025 11:56:36 +0000
Message-ID: <20251027115636.82382-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251027115636.82382-1-kirill@shutemov.name>
References: <20251027115636.82382-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A89FA120002
X-Rspamd-Server: rspam02
X-Stat-Signature: ug16unyzed6uxdho8z83jriehff4u8gc
X-HE-Tag: 1761566211-190223
X-HE-Meta: U2FsdGVkX18nLOEJVIHBrZyc+lYn7dPFRZxgfU0t0sV2GuXrbzlGS3iH6HcXTEB4msM2i6x8nOnvWYU6dYntQosIwE3n3r0ERpfWVtd5pFYyAqgF3HYs+TGdAVy+k/Jnl2sArnlLZyJ+rMZNE/TJU2P6ms5j+/7clESvmLx8E9rEYqJPMKObwRrJ+LkupPMqhRnj/gmoG31j9SbRJPDNCE2Ti0pVgxvX0gsKDDE/WMeN/8TzcSPCP+POkhrHgTjG82nYuUUehcKatiqSwfVKB26SPhphU/5MsuMpArRfhRIqFhpuBwEhhdDLu2HWw+wk0cr/pmmjPniRcFJ1WGYdG/++h2pQIlH4vTC47aTjmr49a4COJWpo261KifF/efYT/df4YwwvJO3eypBH9RoCrigVTRJwhd+AfxvFrashT6hKsgw23FHEYRhenta71BJZLNKFB68MCO7m+ivHJDilEL3m04IJIX8qX3BPjfZbyNdaWaFwy3Ml3tmrilSpwSQgBiLUoBH3OE4QiQw1v2vZ3aKvvRu808SDrfB3WUqetKndg94qHPnoa5w0d9Quc7ulPqhDRM8B5YplaISSC/B/AnjgB8ZBFmVSnYm/s7eYJmEjV40VE2L69UN2TaH0XZ7EYkSHwZdjHIdDZeZ85wwt4uty0CY5BkxW2eyinM/KgIukzw7Xlg48LG6dh1uaEejwCQebGB3z/9GPm8uxUCct4NoGSSyRhJ1sYmJlrdKYZEqRU7u9svOBFesnuz+FYWNJue/6HKY4pbWJlaH0lTJ3vEcF0lztQS01OEGX1zKoaxskVzA3T47ZDBUNiM6hDSYeaKualZye+NONuaI9sHPRsRh4cAXnbhi+X1B/yNOwxrGmhh4FqWc3+6MWLltcuf752+JzvkkzAgLwe04PoxicIX4vSMXrut0ZNImjgfeCU5FfAehmluAV2H0IxwIGByYN8xK/qdLafpp7GK96Toh
 I+DKillY
 FVxnt1kdZAyaoplF5l3PBCWMxLnR8z6+NRo6+odYX8hq+SBVt+tRl8NBlEkpQXQVSoa7SQU13iLUARUSJgEjpaDNJEUea0iefT4Rsjnivh9Pw1+s23YvPyvIo5z/MxxyrhDVR6AVdFzhL2Mrox27/8wHKi8iC6kY+zmptpOwq0ePp+MA2us7pozwnRJ3+Iw0uZ14P5SzAIqfidhGwxERmV/SYXMEzyvnq+jsohh8XUIl/50NbmbyBIZYO2x5RYzJR29GpQDzJPmaA91FbZeHhXyD//fIc/U/i3JP8IBXLzfr9L98b1XYqcCfA4hkc+OzS+CCX1LwSvOUE58vUlgzyfgdsUowqk0trS0vgcRo2IpvFQDzHDGHueBZt4qcSwYhHwXxf3MKqtI6SCPzjviWrHmpE3gpqVcUZ68L3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

Accesses within VMA, but beyond i_size rounded up to PAGE_SIZE are
supposed to generate SIGBUS.

This behavior might not be respected on truncation.

During truncation, the kernel splits a large folio in order to reclaim
memory. As a side effect, it unmaps the folio and destroys PMD mappings
of the folio. The folio will be refaulted as PTEs and SIGBUS semantics
are preserved.

However, if the split fails, PMD mappings are preserved and the user
will not receive SIGBUS on any accesses within the PMD.

Unmap the folio on split failure. It will lead to refault as PTEs and
preserve SIGBUS semantics.

Make an exception for shmem/tmpfs that for long time intentionally
mapped with PMDs across i_size.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 mm/truncate.c | 35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 9210cf808f5c..3c5a50ae3274 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -177,6 +177,32 @@ int truncate_inode_folio(struct address_space *mapping, struct folio *folio)
 	return 0;
 }
 
+static int try_folio_split_or_unmap(struct folio *folio, struct page *split_at,
+				    unsigned long min_order)
+{
+	enum ttu_flags ttu_flags =
+		TTU_SYNC |
+		TTU_SPLIT_HUGE_PMD |
+		TTU_IGNORE_MLOCK;
+	int ret;
+
+	ret = try_folio_split_to_order(folio, split_at, min_order);
+
+	/*
+	 * If the split fails, unmap the folio, so it will be refaulted
+	 * with PTEs to respect SIGBUS semantics.
+	 *
+	 * Make an exception for shmem/tmpfs that for long time
+	 * intentionally mapped with PMDs across i_size.
+	 */
+	if (ret && !shmem_mapping(folio->mapping)) {
+		try_to_unmap(folio, ttu_flags);
+		WARN_ON(folio_mapped(folio));
+	}
+
+	return ret;
+}
+
 /*
  * Handle partial folios.  The folio may be entirely within the
  * range if a split has raced with us.  If not, we zero the part of the
@@ -226,7 +252,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 
 	min_order = mapping_min_folio_order(folio->mapping);
 	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
-	if (!try_folio_split_to_order(folio, split_at, min_order)) {
+	if (!try_folio_split_or_unmap(folio, split_at, min_order)) {
 		/*
 		 * try to split at offset + length to make sure folios within
 		 * the range can be dropped, especially to avoid memory waste
@@ -250,13 +276,10 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 		if (!folio_trylock(folio2))
 			goto out;
 
-		/*
-		 * make sure folio2 is large and does not change its mapping.
-		 * Its split result does not matter here.
-		 */
+		/* make sure folio2 is large and does not change its mapping */
 		if (folio_test_large(folio2) &&
 		    folio2->mapping == folio->mapping)
-			try_folio_split_to_order(folio2, split_at2, min_order);
+			try_folio_split_or_unmap(folio2, split_at2, min_order);
 
 		folio_unlock(folio2);
 out:
-- 
2.50.1


