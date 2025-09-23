Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AC59CAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 11:07:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C0448E0001; Tue, 23 Sep 2025 07:07:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16B198E0020; Tue, 23 Sep 2025 07:07:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB1EB8E0001; Tue, 23 Sep 2025 07:07:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF3478E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:07:29 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 863E411A19B
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:07:29 +0000 (UTC)
X-FDA: 83920239018.26.AEA9A2C
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8FA201C0016
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:07:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="E ze+Ws0";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=ZTi2hcEK;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758625647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jFlzJ6561wUPMtQD7f6sb4ugc+4wKUHkJSRo02E7hiw=;
	b=TB6SrFDRzl5ijICcmJZY6Su77RUxIo7WRQtl/QD6Spq51ua5Zvg6V+AUoCwNkY9TjO73+8
	vd1j1IMQZMAnKxDscZwfKMfX1TtSzNbm+bF/Crs2/SC+V5AP8DqsiGADsEhpJDv7kfbYnf
	jy+u1jVbbEp8abT4mSb0GAl2MoY6sdE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758625647; a=rsa-sha256;
	cv=none;
	b=3L4BSF6jQOjBlLxdOiG+qiZkeshAdiDwiHsKnuqxQQj8gGvdpwuhPFmklTjPL4Z3E8iru9
	UAxyOHLw06JNl9ezbEFIoBZtjDqX2UtFAVwJWb3XDtiEa8y/VJgljM5nPIwEsca+aagObF
	9quS6Q6IVTLEeOaFhxdo61escVoaUdM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="E ze+Ws0";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=ZTi2hcEK;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 0127AEC00DA;
	Tue, 23 Sep 2025 07:07:27 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Tue, 23 Sep 2025 07:07:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758625646; x=
	1758712046; bh=jFlzJ6561wUPMtQD7f6sb4ugc+4wKUHkJSRo02E7hiw=; b=E
	ze+Ws0aoQB5hiu7xli1pwslSt17+MJcyNGgvrBHKLt47m4/Md6BjcySKTgOB++nC
	xA3ZbtSTPwFhnMLkMrT06I69isCgR8NWfWZz30qZOnB8xO0bFI8myTXExeXKyfGH
	m8sjTajuOZ2x/5irzu/Nwy8evqicCQRMNbvvq0qAha2Ls9OaawCHlCK8MUSPc6sn
	S3XblAcUsfnXoD3FtVJc3r1rckEfeu4PejzaKaeL+GK9YvAqWa4NHvmi1J/EXdRD
	dVVPFj/omcTcqlGjzMVhy/STMkwzNZzIapZfawd/KrWzV6o2zkUdaXW0UXanTyoj
	6k150cvLysz/gzATxgkCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1758625646; x=1758712046; bh=j
	FlzJ6561wUPMtQD7f6sb4ugc+4wKUHkJSRo02E7hiw=; b=ZTi2hcEK11wqhlduw
	qtK9TkufynYkoGXDdG37857a57gfcuUX3y/iEibPSryT5Aq1Hjsa+HOzcBLj31qg
	i9NohoVPqio9QBMrjxupABty1nZl1Wk8BB1rNTHkaIKg6pHhEAy1cxq27bP9XdX5
	mqdDpc+Kjr7xV5/FBi1tqs8z/uTMk9HJZgBpd5uiKss8JIw/Iuf3MKAt7jaI3jh7
	2Wtd4x2f41kpxwiJPvX6rRJoRHLA0hp2oDBt+pyys0v1mhGpkrVbPQConU0GNIes
	x6Kf04NyeBIuAu+KQBq8r2Cn3YZTVBGsNYgG0AZYYmISEwE8HXbnO9ObcxEuW1po
	vjCRA==
X-ME-Sender: <xms:bn_SaGoWzQg_xC10MPIN1r4H7jbofypKHNCZ_eoTBIV0STgbl1491w>
    <xme:bn_SaAmGcuBLz5ZabpfodygdJubIbpoecMcUr7SXC-uXtRauPsAgviKk1Mk-eaklm
    DOSHmZ5pKy0M2tyrUHtFFFxydYjaX_H3eA5HM9R3mgb4ZAw1Kn49Q>
X-ME-Received: <xmr:bn_SaBXEXJaj92SA0cGWGkO85d-1HCopvf_Q9bboahZ4GQF4bA9oV7lps3pqbQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeitdehjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeegveehtdfgvdfhudegffeuuddvgeevjefhveevgefhvdevieevteei
    vdehjefhjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepudek
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouh
    hnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhm
    pdhrtghpthhtohephhhughhhugesghhoohhglhgvrdgtohhmpdhrtghpthhtohepfihilh
    hlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehlohhrvghniihordhsthho
    rghkvghssehorhgrtghlvgdrtghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtth
    esohhrrggtlhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgiipdhr
    tghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsg
    esghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:bn_SaMQzrHnjNS1zKsNTmHms900OAmbJZ-9yx7NIeBWsUtUG4DiHiw>
    <xmx:bn_SaEDVQ0Is5RrOJyGTjbyE5z1m704ybpkiAlUrx2sUD_6xXl_5Mg>
    <xmx:bn_SaPTnodyBeMz9lxJ20uS_3eYVEIo4pW8HUvfvFqCKJtphAX6Q8w>
    <xmx:bn_SaGQa5B4upTTaqepxXXn9SEIPy36qgGGfEox5aUX_fUOWyF1RNA>
    <xmx:bn_SaDvM95TaG7c2RYzNlENi3tl6IRhBTVM9EBj85A6Gars9Y_qs9vrz>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Sep 2025 07:07:26 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>
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
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv3 5/6] mm/filemap: Map entire large folio faultaround
Date: Tue, 23 Sep 2025 12:07:10 +0100
Message-ID: <20250923110711.690639-6-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250923110711.690639-1-kirill@shutemov.name>
References: <20250923110711.690639-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ukka1pfdhcksjetuf83ccdfkejtzxd3w
X-Rspamd-Queue-Id: 8FA201C0016
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758625647-803898
X-HE-Meta: U2FsdGVkX1/G19fM2kFz5JPt1ILYtzorrwD4I2J7ZOVuToPUYca1n4gJHWp/DzNl2tfyngInfGxg0OROebPEo0YnNwD2Tdno7zrcNzUcQ5jJaLTOKYxACS7GiABvdo52XETwkjykIGlwbksk35eTmVhNGs2PZyRvVDa6JlJBaeqk39EXbFppC0FGFNHFBrQbXlVJdzIXsWZo5YEuFsFliDwihDgLabhebs8ZMxxgQ+7R1F0Uj8xJ/A0k32zbpOioH//XRBZKJ4gDq7YgQOrfJsUEgOYHvKG4xCCx8PqFpnys9AnpG4UIU7szVFlm7b9Sn2In/BcnLRSAU0cA03F+UZxANyU9Nb4cI5VAnmptHFNLsKG1Wx0uFSqmMhCldJWPEFclDn4SS8PRRPTpwni0mjz0r2MlKiu6px9fLbUhd0LcTMaK+KtDDvqOW/Q1uRycdkMjBwEwNR1NZzokZtFXg94s2O2xIDsFb82xETd2qBN7Q9C/If/Sf+xNvmm9EM5bAfBkSAu+m/Snx6YkcGPrAD232AxAlFxpVWaBuZh6yoQnxQyXZ7a0rg/zQvkrJbflZfL1hhzzejHQeMjN0QRb3sEFkWrplo9E7rHxHeam68CSw7cbkVfEbCb5bVZp1ViNwdJFYECcM3PJ0uimu3iTm6kVBD1PaMXqdBAeUECgnnDQg+DOk8q3EAFgaHRlPpx6URkwCe6kyuAEKqxYPWIpO/D6Z2GucaPsiP8r9hbuYvq7ckb1jZf8OckugC8mNFPlK/uiiA4ST950hoN9V9nUFDaaQ3Lp4tJmwXcv2nYXAj61WW/9J4DdQMRuOdtWVZE74VctuOQirfn2JQ+PtJlWuD/dfYtVGI2uy3/yACsXffFYbrBONccLN47AY4oXwqUFOmI/e8+OIzT6AuJZXPItB3IpyxsEkzewDYDkyhC0BwTHAP4UITdi/6e+r9eOZTjZo1hzZ+xJAPLnJbDtoCq
 4fZg16/V
 lc67nB/M9mpYZ8b9P+0ClBZCO7ckhK8+wSLlJRQJcPCqfarqNHvE304VcHIx9yteVwk7Bk5gqf3ZxNVlzsJ8kNzUToyWIxJij9gmouhpTAYge+hmDH7jVBDSh7ReQFGfnbgW10E01vuNg5E48U3eqdsqloBoxth5oUn1aLSOvJgSD5IFXZV//WA2y4UoVWauhbFTjeB+jkyE8qwi2L4V1KlI1bkLvJXxnyEz7VPvj7COaGYB8DABcoXcRiDpRlhg4PX6ZQA9ye2uSWeVUVSMTOSGTyLsII9VoYUn7IlQWEKADOs0P/5bGLuMZXfatnkNwUYXIqa6eUC+8bwKdyXek2bT3x2w2VCHxhImjX1YTVYzq7IBbcvgQSw4OSQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

Currently, kernel only maps part of large folio that fits into
start_pgoff/end_pgoff range.

Map entire folio where possible. It will match finish_fault() behaviour
that user hits on cold page cache.

Mapping large folios at once will allow the rmap code to mlock it on
add, as it will recognize that it is fully mapped and mlocking is safe.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 mm/filemap.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index 751838ef05e5..26cae577ba23 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3643,6 +3643,21 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
 	struct page *page = folio_page(folio, start);
 	unsigned int count = 0;
 	pte_t *old_ptep = vmf->pte;
+	unsigned long addr0;
+
+	/*
+	 * Map the large folio fully where possible.
+	 *
+	 * The folio must not cross VMA or page table boundary.
+	 */
+	addr0 = addr - start * PAGE_SIZE;
+	if (folio_within_vma(folio, vmf->vma) &&
+	    (addr0 & PMD_MASK) == ((addr0 + folio_size(folio) - 1) & PMD_MASK)) {
+		vmf->pte -= start;
+		page -= start;
+		addr = addr0;
+		nr_pages = folio_nr_pages(folio);
+	}
 
 	do {
 		if (PageHWPoison(page + count))
-- 
2.50.1


