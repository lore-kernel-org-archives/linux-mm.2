Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EAA7C87FD2
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 00:10:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F70F6B00A1; Tue,  5 Aug 2025 20:10:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A7DB6B00A3; Tue,  5 Aug 2025 20:10:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8AAF6B00A4; Tue,  5 Aug 2025 20:10:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D37906B00A1
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 20:10:57 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 65D3257F6F
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 00:10:57 +0000 (UTC)
X-FDA: 83744402154.19.05EEF43
Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	by imf04.hostedemail.com (Postfix) with ESMTP id 582BE40005
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 00:10:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="i L6Oybb";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=iym+k+EV;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of boris@bur.io designates 202.12.124.146 as permitted sender) smtp.mailfrom=boris@bur.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754439055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1phRvSNuTKIF+bCvTZCq9ZVaDd/RaEEPdjAvv51sVaY=;
	b=ho/lrebNp21J+M/+u7zrwNGdWdTrtCti/uiO1UNOJaqUrd0u+WS5W/lGRZWS5XpRwYPHVQ
	6BHmfTEqhJ6nSzM5xcsaGRUS/Qj9POUhHuqbDA5OKtoiTZEZVeVR/ZB60YCumTA1WGIVRj
	F4AitOG0WMxMlt8dBK4ANfWkjZf260s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754439055; a=rsa-sha256;
	cv=none;
	b=foWatHjmvnPDp72LPaL/7bb7DNHqcgzrLhAqsR1iTgPDUOPMK6S1BmNVXGucksLYMbNHrX
	uTpafQPqlugp6kjRZ/1Te203GJ8uM2EOPhu4Qc1VE9+cYHs1g/kjNrFr/e+E9XJu0J8VTl
	bCoxZvDfM51/8NKaPnYL1100dD4uYkg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="i L6Oybb";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=iym+k+EV;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of boris@bur.io designates 202.12.124.146 as permitted sender) smtp.mailfrom=boris@bur.io
Received: from phl-compute-07.internal (phl-compute-07.phl.internal [10.202.2.47])
	by mailfout.stl.internal (Postfix) with ESMTP id 693F01D00245;
	Tue,  5 Aug 2025 20:10:54 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Tue, 05 Aug 2025 20:10:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1754439054; x=
	1754525454; bh=1phRvSNuTKIF+bCvTZCq9ZVaDd/RaEEPdjAvv51sVaY=; b=i
	L6OybbpyE+rOwlETZcQyAlbv5ro83/9Q6ceQk/Q0cgyUb8IKGonHNw9H8qFbjFEY
	cPlwQrvT/neTJpYkddiXLm+rasmq+6C04rAOULRELZmN3YhL7QAlzW9zhs8/GjeX
	HWFOiFvObXPugP4bbc1bAh9KXFHuACFit2Gw073yBE0wyYugv4pfQX8d9ekgLqy+
	eL4CkezBvGpBt7l/gJ95bZRefU5oqIrv+zOOHaWPLCOnrspP90x6u+znsljFsBPC
	9NqE0QGNsUMj+lUbecjjWcjnvfkxYr3S+220E1phU02bLGlqp58Oa7VPE8ZZpGBt
	z5ZhdFYv3phBfUPC271Hw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1754439054; x=1754525454; bh=1
	phRvSNuTKIF+bCvTZCq9ZVaDd/RaEEPdjAvv51sVaY=; b=iym+k+EVVQzDVp3Nw
	maO/VAOzJ1vRfnCTZoXEm6tVcpK6VgRDravj09yHQXicIWzvH58WNq8hTRSooGKP
	4BLozYGl+F+3/QlvmaYa74td3mIA8EF6VBJRLRFdTrTfIqakuR/8ua38g4v6R2nl
	UrzIrBoKLqo55uLhhSJOLILToNkH0gZ7yK5Nw5kmbG5RYGpquTbUjCKbzu1z25TS
	93dlm/hEQGVQ6IAa+0ApQ6IzBXSu1ejN7v7Y8PbzQfZHEzzomfk+6f2IVWktQzDR
	l+sneN+O82lfhy0pjCKUcTbACGJCJCRqAyPpjvkZob1fUX+qqCMx7+5ZcXj6nSgH
	wrd/w==
X-ME-Sender: <xms:jZ2SaPMRHOpSBKuSiS72fY6heztTwJylPXv17-3XEB7jFtqfixMZWA>
    <xme:jZ2SaNzKzHMR4jLS_fkeSoj6F2jA6XSYYSdAo7JfV32KDwaxeHHjB36bXrV6GLyyZ
    6hLjDmIutnS_EGJd4Q>
X-ME-Received: <xmr:jZ2SaHVnkWkSIosASQ1kkY8KjRsiF79ZI_u78QsWWxBTfezfeax_yQ98IRx1SnTzV95G9ZGSEs7MzEDtSadVoyn0ml4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduudeiheekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucgoufhorhhtvggutfgvtghiphdvucdlgedtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeeuohhrihhsuceu
    uhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhephfevke
    ffkeffheeffffhuefggffhhedugfetudetudetueefveeijeefvdduudegnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhiohdpnhgspghrtghpthhtohepjedp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheplhhinhhugidqsghtrhhfshesvhhgvg
    hrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdr
    ohhrghdprhgtphhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesfhgsrdgtohhmpdhrtghp
    thhtohepshhhrghkvggvlhdrsghuthhtsehlihhnuhigrdguvghvpdhrtghpthhtohephh
    gthhesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopeifqhhusehsuhhsvgdrtgho
    mh
X-ME-Proxy: <xmx:jZ2SaHOGkt-mJdAV-dERZ7YY6dOYhpTiqD7QroHalFzzi7Bnb0YCkw>
    <xmx:jZ2SaBCMmxCnDU_v4s-c4ju_1kW1v3l3s_owzwBucCwLGlNYtHwsew>
    <xmx:jZ2SaMfAXWSuNLzH9Jj0GCxjaybrSZYI7oBYDiKf7vb_rzB_nVGpUA>
    <xmx:jZ2SaIP8erXk91TPfiFWpJgspmz4KzGhwO99Wu_8N4Q5Vb1XrOicAg>
    <xmx:jp2SaGsrH4gBG9jUKUa6yMnjoDmezQcZTglqfRRs5halbP3HnzBO3JwD>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 5 Aug 2025 20:10:53 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@fb.com
Cc: shakeel.butt@linux.dev,
	hch@infradead.org,
	wqu@suse.com
Subject: [PATCH 1/3] mm/filemap: add filemap_add_folio_nocharge()
Date: Tue,  5 Aug 2025 17:11:47 -0700
Message-ID: <9be3cdb1c9fb9f848719c20d4659071229f07284.1754438418.git.boris@bur.io>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754438418.git.boris@bur.io>
References: <cover.1754438418.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ujiic1j3thqsm9zrtge5ff7khhzoe3t3
X-Rspamd-Queue-Id: 582BE40005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754439055-128407
X-HE-Meta: U2FsdGVkX18eC8DEokEUos0TpjhYSVP8GjoL0FGfb4mxchRFOgipPhLhBaUUpQXE8bg37n/ZZPj6g4naPACByfKTJgxn7xuUYMRJFkpmX/OynWuvlyMdlC1MP3t23rwyMy7qcwd2oN9QtE+9G+4TojZVd5liztsEh+lnQxrU71uQiDe3cRDMDCQnOAosgDbT3Sl1v6ncMbE8zB6ROV9xaiihblXjj9zAmN19JE3HHa7l8HQjJC3RKN/VqE2T148Dc9qL07I4aJ/Gad/dTG/k+JdmU4NgKwznPqE6DN6FZ47nOwW+wXrLOSB1FX3e1eSqWaE+HmXLOi+JGEHn99WvF1bTXWWCjpvOx8uEO6QRAeqzyxc51u1atRSllIhELG0okvVZj4ZeJv7wPCIVjzPemQw6Jd4yCxjEM9s/Az7eD8bxwfJFg47QAoDqauA+kU5lUaV9bppAIaWlFtomMS/5ayxpBdAS90mcjW90JY64keMZlhPpWlHVAJ4wOaBGiIEZtL7MwmDn2RpN6/AqQY0X0cCQE9DPztYZ+/hCvldN8JsF8im2DZFYltzd+vsCzM3NIb/qLKiYDeJEMIC0ktoZUqWy2u6jbYjTJiyDYAy4vLm+iqhLH9VMTNYgS8VYh7aqkeJsDvfRUPwLZEQgIZw1wqUnWGEwl3lihuf1ymFKA1B3AtZh2anhaO0qFPpWPkAlvFylkVrdsAMXfYFfqrewXlvPDpwThNNy2507lo5cc830NsXPU7eK3DtkJhAcwxo2EBL4TSVgfdrsT2MU3fC+4yPYk2MdnPQWky3uOSQ8zEQIK8jfJYM79usjQUKU4nZyaBLxqR8pPOmEgQ8uZD2rhAo17B0Jj3mytw6WyE32npT2oVwug0seSE1bdw1oITe9M/yza5nV/AS0iDR77LHbJnsOPdhsIoDUJqEWquAMKlMUUuBGwT/p5ytM68JOYJKK7JGRZ3e5xCHUncLku8x
 RLmhHqI9
 i7+vfIr/VFEbcSUlXpKurcLUe6AlDDUQn11DF1K8fGmv4VSrxJIMQWHQbaAGKAlMavly4/MJt29B9H18m1I/OVLxXko0Idl5+mqOdXOp+FQaakMCzT/DFz6gFu08fzKJptxEvcpBQLz8nsmfhwL1ueoSQllq8cFb9F8uEgbo0CoME8HT0WRfssJT5+y7+tJZ93aAumShEcrurp7wkvAdOrE025+pDEL19IxMym058ZDPd2GNTGF/v8HO3UHgIPQFwn6siYMCYugE+jizfv40vYMlKis7WeEeXZojuyfzyLqkWFNSc/Uq4ZyEg4aCpQKT2Vti+2qBsXFVFzesSvgQPVnmnqIr7DUbDF+zAiXIZZyxJLutQoZM2vC4mAmmlF/FkRt4SeFtEdVW8kVRUBO64vTlKl5eTCtuyxlqSm3+yeDABPXaR+oLeLpGlWID/h4HsGzso8Tcl71ju5mw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Btrfs currently tracks its metadata pages in the page cache, using a
fake inode (fs_info->btree_inode) with offsets corresponding to where
the metadata is stored in the filesystem's full logical address space.

A consequence of this is that when btrfs uses filemap_add_folio(), this
usage is charged to the cgroup of whichever task happens to be running
at the time. These folios don't belong to any particular user cgroup, so
I don't think it makes much sense for them to be charged in that way.
Some negative consequences as a result:
- A task can be holding some important btrfs locks, then need to lookup
  some metadata and go into reclaim, extending the duration it holds
  that lock for, and unfairly pushing its own reclaim pain onto other
  cgroups.
- If that cgroup goes into reclaim, it might reclaim these folios a
  different non-reclaiming cgroup might need soon. This is naturally
  offset by LRU reclaim, but still.

A very similar proposal to use the root cgroup was previously made by
Qu, but he was advised by Christoph to instead introduce a _nocharge
variant of filemap_add_folio.

Link: https://lore.kernel.org/linux-mm/b5fef5372ae454a7b6da4f2f75c427aeab6a07d6.1727498749.git.wqu@suse.com/
Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Boris Burkov <boris@bur.io>
---
 include/linux/pagemap.h |  2 ++
 mm/filemap.c            | 23 +++++++++++++++++------
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index e63fbfbd5b0f..acc8d390ecbb 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1237,6 +1237,8 @@ size_t fault_in_readable(const char __user *uaddr, size_t size);
 
 int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
 		pgoff_t index, gfp_t gfp);
+int filemap_add_folio_nocharge(struct address_space *mapping,
+			       struct folio *folio, pgoff_t index, gfp_t gfp);
 int filemap_add_folio(struct address_space *mapping, struct folio *folio,
 		pgoff_t index, gfp_t gfp);
 void filemap_remove_folio(struct folio *folio);
diff --git a/mm/filemap.c b/mm/filemap.c
index bada249b9fb7..ccc9cfb4d418 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -955,20 +955,15 @@ noinline int __filemap_add_folio(struct address_space *mapping,
 }
 ALLOW_ERROR_INJECTION(__filemap_add_folio, ERRNO);
 
-int filemap_add_folio(struct address_space *mapping, struct folio *folio,
+int filemap_add_folio_nocharge(struct address_space *mapping, struct folio *folio,
 				pgoff_t index, gfp_t gfp)
 {
 	void *shadow = NULL;
 	int ret;
 
-	ret = mem_cgroup_charge(folio, NULL, gfp);
-	if (ret)
-		return ret;
-
 	__folio_set_locked(folio);
 	ret = __filemap_add_folio(mapping, folio, index, gfp, &shadow);
 	if (unlikely(ret)) {
-		mem_cgroup_uncharge(folio);
 		__folio_clear_locked(folio);
 	} else {
 		/*
@@ -986,6 +981,22 @@ int filemap_add_folio(struct address_space *mapping, struct folio *folio,
 	}
 	return ret;
 }
+EXPORT_SYMBOL_GPL(filemap_add_folio_nocharge);
+
+int filemap_add_folio(struct address_space *mapping, struct folio *folio,
+				pgoff_t index, gfp_t gfp)
+{
+	int ret;
+
+	ret = mem_cgroup_charge(folio, NULL, gfp);
+	if (ret)
+		return ret;
+
+	ret = filemap_add_folio_nocharge(mapping, folio, index, gfp);
+	if (ret)
+		mem_cgroup_uncharge(folio);
+	return ret;
+}
 EXPORT_SYMBOL_GPL(filemap_add_folio);
 
 #ifdef CONFIG_NUMA
-- 
2.50.1


