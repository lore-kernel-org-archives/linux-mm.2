Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63FDBC982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 00:25:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B231E6B00B4; Fri, 18 Sep 2026 20:25:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD4926B00B5; Fri, 18 Sep 2026 20:25:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99C426B00B6; Fri, 18 Sep 2026 20:25:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A1406B00B4
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:25:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A9A66140148
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:25:16 +0000 (UTC)
X-FDA: 85228617432.25.A6EB459
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf29.hostedemail.com (Postfix) with ESMTP id C1C2C120008
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:25:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Q wotEtq";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=pd4ebgcr;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789777514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r5nTkTHjVvMlyFTA7E1YaHuqOSpZFDKLhDsNT7zZVk4=;
	b=bIOohkdTaMq9OrWGWLIdGKNC07y8irCXlvlIrCvsydb7R+ctd5nGg5iyNff/xgSeF/yDAo
	pjv8zika2RLFOHuOPiPnDeJ54cKF/yyfT+U5I7+pKZLyPv3m9XSTwCS5ewfolfyT2RCeKp
	YpDU8zJR3fZ6UlxCq0+Y/DMkBakATmg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789777514;
	b=xevoiVV7ZmVK0ui+0z6ybHO1tq9lezLRd+m6Nlw63aDTgDQbsPso17bm4S6FkV3OjBL6YI
	mOH2VtRr+tbLaLetPfauReSDGGO3EeIl+4gB1ttjnTYarxQJGQ/EmSYSrMVnssqmi4OYde
	sGKv7XpEm3eEI6j0hd2YTUJ48SmEMSE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Q wotEtq";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=pd4ebgcr;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.phl.internal (Postfix) with ESMTP id 62F40EC01A0;
	Fri, 18 Sep 2026 20:25:14 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Fri, 18 Sep 2026 20:25:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789777514; x=
	1789863914; bh=r5nTkTHjVvMlyFTA7E1YaHuqOSpZFDKLhDsNT7zZVk4=; b=Q
	wotEtqlZ0AxHw8nD1qvwn+xUskD7FqxxJ5G5WbdDPSvVhIODO1ylw2Of7xnF4gz4
	FdgWnoGi0829zhFZMehVtg0hlnybpRjfqhgbdg0lHxrLBFcN/Yo0U80gEYvqCGqA
	pMRILwvlMkB1sbutBq/O9c2fpPiF/mdLnkkdnbCv4HTf+hzx/oIF1qQnPoyHLSl6
	HkBAfWLk0WpqJFJaoCWOmnVrOXRlf1u56S5Paj2KOTcVQLpqi2Y1kMfFLnJDEl7K
	JHMKN0G6FXtSZPqFeLdhPHKYqCjOCg8EUv5zzV6WvhGsDK5EzbaM+RpT6OwVPK2R
	+YALW5APEDFLUlZljiKbQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789777514; x=1789863914; bh=r
	5nTkTHjVvMlyFTA7E1YaHuqOSpZFDKLhDsNT7zZVk4=; b=pd4ebgcrEe4MB+KtT
	StrwrRvM+97GB0qHUIozEgo/p23VongCb5EfL/kL0fPvRti81YsdQPgfj5dDjtvu
	Qyj03KKp/jSHw9g6CFnCstVbqe0lN1aeifxBARqFna1y7DWqeUnrwmYmDUy7ACas
	uGKgpc/kuEjF5K52ySRJk9KYbUVVZ1X0JxJ6NlD7uQWahueF8o2+sYvfuJcdTsVc
	NGfbOD/WC5wcplO3JggmIyinvnuuV2aqVq5PGBOugv8Bs6oYSPwLsz1KLKfTNUlQ
	1SAcrIguzYS9Rp6mABesd8wPeIgS9xdy32PBD8BIsn2Sk9SkaLGk2kI0jAQZYdl+
	/3ILg==
X-ME-Sender: <xms:atatalcZ_JimBUPR7QS3Ey43nuE991V4JgSiq0kNDufC7y76FGrHOg>
    <xme:atatarmMk9r8zPp7b5TmNMPIbCtPKRGVKfA95KIb38XsGbWMEocWtKIByRkLNtdpQ
    AZa5old_5V3-wfzvzV10BLCcSJ-BVm5AbJhUUey2QcM5FtXAJC0o5VV8w>
X-ME-Received: <xmr:atatagt5kfSPPzYlD4AObv1LyweHGU41454ta5pCDWYjAHMKVccBFngbELw>
X-ME-Proxy-Cause: dmFkZTEzseHgHAxanvosBbYuJPOsY+n0X5UbYs0PPazNY//kQZ3NkUWvwvZaeFG4K6MaM1
    51QpOH4aelOmHBptEhruNIkMmEsuOQeZbGrvL7mQj2kdmmCNYrJ7V/Gxu8ar4BzJpo5rV7
    vKP2ia7U0+Vm59vAPsz2JcwivFHP+0OmSoqV+JfA3yKlcOkTPrhdGkX4AgOHLm4XJUt5mM
    HeqMESXl6ibr/xrgjBd4IZM9oAbU6DWk9Q3+fqdUek4rHv8tNSmXbmq+2iLXuPMZjgN42W
    gGRNasGU39A5UL6wnmEy31YC46agADHTZYQX6KPmc3+B0CXfmIhRtSns1d+buSvmpYlDBj
    Riz3LPJ5ewmbfFS034Junho+nA59C2QdPnd8vA078CVbfnIVBuVyeZunIF1BdFpJy+o2iN
    5vZCICEeIFyBnK4XAtYqzjAbdcsq9wu34gWczIkUsEAsprD6tQ8OD8MOQgcBf0ywWXKXFI
    27xd1zREAGJOHifR7SJSbs+DiSkzcOQ8yzDWYHidssHN8IjIbQEtXt1mZ5nMsnBoj8dzhf
    XF1JaGZj3WlcgrIXMSPvCcH52rugKrlwp2TQWMwgehKsP/lB9bPQ7en5g+Lg7wt1jbjF/H
    R5WQnK3fOt+WAqCb1/7XU80vMXxm1AXpyucuzzd4PMOSSe2FT3Iv3q0CecqA
X-ME-Proxy: <xmx:atatamydMuYEKzrLksx08-5ML7T2w2IMdUw2kTrccHLACT19KX0XUQ>
    <xmx:atatajx4XY5GXdiMEN30NNShWbS7oXfb6iUIxKaN1akjbRnfcwq5BQ>
    <xmx:atatas54Mbvq7njHaHNbgrPcTN6Kx8gHdQ9sr4cU4fcQwsYAV-nCSA>
    <xmx:atatasAtc8x1j2Bz_b57MDE0Zr0BhgJ4sKBP-tfdysHH2rwumcYbgw>
    <xmx:atatap2X9xSzIQ6okEXWF0ql2JsLjXgsSXwwqtFBbeXxtp85qJZ2addo>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 20:25:13 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Usama Arif <usama.arif@linux.dev>,
	"Nico Pache (Red Hat)" <nico.pache@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	kernel-team@meta.com
Subject: [PATCH v6 08/19] selftests/mm: add folio-order check for address ranges
Date: Sat, 19 Sep 2026 01:24:38 +0100
Message-ID: <20260919002451.496763-9-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919002451.496763-1-kirill@shutemov.name>
References: <20260919002451.496763-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C1C2C120008
X-Stat-Signature: 8yd39he6khqn5aipzig1gpx19in4f6fo
X-Rspam-User: 
X-HE-Tag: 1789777514-659814
X-HE-Meta: U2FsdGVkX19qia56tucpVf9CUq+saJQeO7BM3oL2OTFgoxHi6oXrpF5Pdt5OaCbvney0i9qqkxIK1B/vc4hwmy1a+iU3pzXi+ds1IoW0O6JYo+gBaNYNYyVfCyJqBFP/obfZ+/EmhbSS7F/mTw/pxFy/+HuvBtFT5cDfJpu7W1Ic0j8DG4eV9A0wQmKeJiPN+PGHV49xt4O2kGps0MAvJB0bp7APOncAaQ3IEeYePt+OmT4cEqiMVmfUqfQ6GVg0McjM6QXxQPt/jy47gXFgKfqpFjKy6fLwsGcnE7IfvVfJ5Vbx772NLUKKg7mOx/WBFfZ+4HLNp7b1j6N2E6WsPdUM9hUQeaAn44NxfDaZBmNACQ2BMEUhuuVa5GnxtBoJGU/xvkoMtzqnH9Bva5/1Gi4l7nKJwMeaDauqIzepohmILbD7W4hqy78vm/NxC/vvvwQq09JPmvBaKm/3PWEgMFfWpeizAheBnY9z5+5VHpeot/IB4hL6D92FQcRlmxijQ6/TkSyZ7672I4/MHM3TdhZD2dZj/tSWHarNrkvMQm2s/cnrlIbE6ypkUIjTb0RkQV50OeQ4TTugSub/7lwDLt1tgvSL6u2RLSnvR3wqVGDV7coznlkZ/N8bv2pNXsFgwVBLN/Gb21R4paiRKAZqh4Xh8DFyYVJOM09F1x0OLnlD6k02qbxAiaZ6AWs4FlKx2XgDQ24KD208azqp3+0ZHRYDgl9yDKtGeZ//gWjbEqx/2IHc4XptW8OedxCA55Qc5Y2A7iHlWacwuQdf6pFzaT+SDmZxRWT/vC5IW7oKNRTSeeRt8Wbf6GbfKroEaJPgR7RLzBUewmbRIjtPcy+SPLtzKsRRs/caE61ui/iBwmZDrxwDoe7oSkj/7oYIiKsfUUI5Qu8zLwHubUnKHYar2Yzyp0hj+pHORct7FGZpV3YDAicNqy3AHBNT9arxKHRUBndm5Y9H5cVyjKz9z+a
 RklI1IiB
 OoeH0Cz1tWLYIxLoDbQBorOSL6heApSah/8RqNQZSP8tLw3uBEQVa61lJc4EQggLbk1rHEuOda1tJgvWkDBUOC5FgiTDSCMpvR9PhTBkkjbJmc7uZuH8CSF0dEq4MWLU7+pm/EGXEWxz5rhf/RL/N4UOqrIJsIsH2+aHifJMLpG8DJ740Eub9m7rTLyLHSyZWjf9dfkMKmfZaroR79slcD/k81xLgbXY+CHe5vb78Vp1OIlsW5lwlt5bkyZrIlNTt3D5P+gcnsv/a1ioNpAQVBSqTaaudkTIWTKV5tO0uKYNe2eCUpVWWrR3rYz2EIAudQ4DYAUCMd9L/3Avcwaz4w07qSSFWNuDNI53P88cHkhOfWngxs7Aps0/lDtWOzFhblzOaOJM4x+CYihoaex2F6mVRY8qTktWd7bP4NE7hrOaXLL486OgPnIvfXoqWufVi7I3mAZ8ucSSIiaRiUetFFr94jl7KC09HYhdFRMGJ3bDXDqiUSUMMi8/C6HU/kn9IseP8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

An mTHP collapse test needs to know that a range is backed by folios of the
target order, and that they sit where a collapse would put them.  Nothing
answers both: is_backed_by_folio() classifies the folio behind a single
page, and check_huge_anon() counts the folios of an order in a range
without saying where they start.

Add is_range_backed_by_order().  It requires every folio-sized, folio-
aligned part of the range to map one folio of that order, head to tail,
with the head at the start of the part.

A part backed by two smaller folios fails, and so does a folio mapped off
its natural alignment.  The mTHP cases need both to tell a collapsed range
from the one beside it.

Assisted-by: LLM
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/vm_util.c | 47 ++++++++++++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h |  2 ++
 2 files changed, 49 insertions(+)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index cc5dfd1e6c94..c8c5cd8ab6c1 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -555,6 +555,53 @@ bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
 	ksft_exit_fail_msg("Failed to get folio info\n");
 }
 
+/**
+ * is_range_backed_by_order() - check that a range is backed by @order folios
+ * @start: start of the range, a multiple of the folio size
+ * @len: length of the range in bytes, a multiple of the folio size
+ * @order: the folio order to check for
+ * @pagemap_fd: open /proc/<pid>/pagemap of the range's owner
+ * @kpageflags_fd: open /proc/kpageflags
+ *
+ * Every folio-sized, folio-aligned part of the range must map one folio of
+ * @order, head to tail, with the head at the start of the part.  A part
+ * backed by several smaller folios fails, and so does a folio mapped off
+ * its natural alignment.
+ *
+ * Returns: true if the whole range is backed that way, false otherwise.
+ */
+bool is_range_backed_by_order(char *start, size_t len, int order,
+			      int pagemap_fd, int kpageflags_fd)
+{
+	const unsigned long nr_pages = 1UL << order;
+	const size_t folio_size = nr_pages * psize();
+	char *vaddr;
+
+	if ((uintptr_t)start % folio_size || len % folio_size)
+		return false;
+
+	for (vaddr = start; vaddr < start + len; vaddr += folio_size) {
+		const unsigned long pfn = pagemap_get_pfn(pagemap_fd, vaddr);
+		unsigned long i;
+
+		/* Not present, or a tail page */
+		if (pfn == -1UL || pfn % nr_pages)
+			return false;
+
+		for (i = 1; i < nr_pages; i++) {
+			char *page = vaddr + i * psize();
+
+			if (pagemap_get_pfn(pagemap_fd, page) != pfn + i)
+				return false;
+		}
+
+		if (!is_backed_by_folio(vaddr, order, pagemap_fd, kpageflags_fd))
+			return false;
+	}
+
+	return true;
+}
+
 /* If `ioctls' non-NULL, the allowed ioctls will be returned into the var */
 int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
 			      bool miss, bool wp, bool minor, uint64_t *ioctls)
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index f12979a70135..0172003c16dc 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -101,6 +101,8 @@ int gather_folio_orders(char *vaddr_start, size_t len,
 		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders);
 bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
 			int kpageflags_fd);
+bool is_range_backed_by_order(char *start, size_t len, int order,
+			      int pagemap_fd, int kpageflags_fd);
 
 int uffd_register(int uffd, void *addr, uint64_t len,
 		  bool miss, bool wp, bool minor);
-- 
2.54.0


