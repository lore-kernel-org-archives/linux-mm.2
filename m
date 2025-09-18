Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5904CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 11:22:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE47E8E00F3; Thu, 18 Sep 2025 07:22:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FC498E0093; Thu, 18 Sep 2025 07:22:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761F78E00F3; Thu, 18 Sep 2025 07:22:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 64DF48E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:22:09 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 30705C0146
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:22:09 +0000 (UTC)
X-FDA: 83902131978.22.D795E4D
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4391110000A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:22:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="H PN7TsE";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=MnNJsRCt;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758194527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JF8klN+Ypxvh4q7BTrSxqIYNo6Zuu1c2pmf4rhg8wJA=;
	b=KeDYYdNPaSjUYh5s/WOfaLN85+kTrfyCFSkSpuwaGdenZ/6USq03K+v3EJuXLQt089TB1p
	SHOwxf3yX6qJHs6lsu+L60rECxtdEnD1DI53Li9FCi6rUOX34+oBo+kQWyydi6nubkabfR
	E9fOkgCAHsUfEK1l3ZHq/iJPwL2VgmU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758194527; a=rsa-sha256;
	cv=none;
	b=n9WRKkQ24h6e4nY/s9/P7Fnfize8AtyPZygKQUgh9V5iMlLrM+aCgGGmD8pvcz0Ao8AOAX
	pbLlg5L7pe9NSdBmBvpBnqfQCzgsr5KxzT863WBeUmvGTLSET1Z96cUlzrA85j+Hut6QTY
	Lgjxlpv/RelUhksVorqi7FOoHxzrEq8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="H PN7TsE";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=MnNJsRCt;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.phl.internal (Postfix) with ESMTP id ABA85EC027C;
	Thu, 18 Sep 2025 07:22:06 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Thu, 18 Sep 2025 07:22:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758194526; x=
	1758280926; bh=JF8klN+Ypxvh4q7BTrSxqIYNo6Zuu1c2pmf4rhg8wJA=; b=H
	PN7TsEadiv1A6p5PKtA+HdyGDKp2K5fYXJUx8wc+7Wge1zjaf50Op5oByjV+U9dj
	g1qqVdEVrltShIqs7AQ0nYKDyWVJvpbpnJ/SfOsHgsxLJycqeTHG6UHFWphBr6sv
	A74Z1//gyXP+zUfZmOFyMepjTGYcZWzlsMYRcVMMpYEeDBxrIHEvfmvAfLr238dV
	mTErZ932q/+LYJXiyXXyI1Y5sTUIAwGsejwYt42AAozbcwYR0zi5zlIno7zmCM/A
	Zht6+CLq5tYNHTgCBJOvZB/1FaSwzy07G32w4eKsdYlTj1cxVNtYRZ+8i1S5pjx0
	UWpC0R8vBBlGq/lBLytAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1758194526; x=1758280926; bh=J
	F8klN+Ypxvh4q7BTrSxqIYNo6Zuu1c2pmf4rhg8wJA=; b=MnNJsRCtFpCQ8/0Cy
	wat4pb/PirvlQfkhl7MaLNQ38toBIi2WIqACffDnK1jbbVGLtdV/bI+r+OiNEAje
	8iXDazoJ5nGTXuG+OxtJWXkkDuJepEamwUaT1SsLpcWNr1FSdvcoPBP4nv0DCwQi
	Kjq3hOhdUcHY7ThJclrnGCb1HYnScvL8Joa3p5EODCK1xOST3rRFltej+i0pnU4a
	WpM5NPW5np7cxrZaIY5JEOUraHfHS82OVb4ef+MvFJvzvqy/OGkAiIHglBuiexeV
	tvxgNGUdfni1VWmCpoxS4T1EjO7fTqWr3PMic9/nUvlO5HiLAoi4xOsSWE9Qy7+B
	P8tGA==
X-ME-Sender: <xms:XuvLaOhaRhgwY9i0cMzi7gSsn7XFgzzUtLL-AuuPMq_IZZtButwn3g>
    <xme:XuvLaJ5Aff_rawvaxv6TAcMWnZ11BIs3hNBySE-LiZZeynxr8UUb6RLQbDEcLqI9N
    hli3ClimtgCanZyFsk>
X-ME-Received: <xmr:XuvLaATDcLd6DXnaIjQU7JPnu1J5RNvIRGQvF4fPoszEU6qA2ggRay09J2vlrQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdegiedulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpehkihhrihhllhes
    shhhuhhtvghmohhvrdhnrghmvgenucggtffrrghtthgvrhhnpeejgeevheeuieefheekle
    eiheefkeekieevteefudefveehhfevffeludejgfehueenucevlhhushhtvghrufhiiigv
    pedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepudejpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    epuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtohephhhughhhugesghhoohhg
    lhgvrdgtohhmpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdrohhrghdprh
    gtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdrtghomhdprhgt
    phhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtoh
    epvhgsrggskhgrsehsuhhsvgdrtgiipdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:XuvLaI_e53nSiG-HtegQ2-ArbMMG9bV8nqg7c2huLkIooPp5HpcLHA>
    <xmx:XuvLaBq7uqO3B121XWMb9f5FMxBGPyNveuWbkvpOPgNiEbFXqquY8A>
    <xmx:XuvLaOULQGGq_YJuuRd6SOmah-k070H_wFAw4C88bUW4sqN1zTt1Mg>
    <xmx:XuvLaG6Yki06THTaeVFkrClSxyAdXAp9eUs8emTL31UMR_7NMeDf1A>
    <xmx:XuvLaDgoB5i7WgUKQUlGvgX9sC0VLA-HLZyGGxwa-XtgWwcCQoQp1-mB>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Sep 2025 07:22:05 -0400 (EDT)
From: kirill@shutemov.name
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
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCH 2/2] mm/rmap: Improve mlock tracking for large folios
Date: Thu, 18 Sep 2025 12:21:57 +0100
Message-ID: <20250918112157.410172-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250918112157.410172-1-kirill@shutemov.name>
References: <20250918112157.410172-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4391110000A
X-Stat-Signature: nupt7qpnu6y4jee43yhemywgud7x4byg
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758194527-532766
X-HE-Meta: U2FsdGVkX18ZmB6ZZzhIcXDnq+O0pexJczwCXNrS+pYuaxCsE3MLwKqyFhJMLs9rbe8UJTxZ1dXm6meU9bCT7SPM1/boWp5jxv/2Cdu2n/rTuTa6eEjuSNJ09ySArLXbqNB6aoA7cUmZCROWF3jOWqbuffZ4XgEBhFoo6TcJJkfNnssTKokBKvi7KYb6oohYeCEyzD+3CucovSfiHZFgnnIbjf2r6vOvTlHlb1VGBAbNQx4jXUj+unWkXBBfjABCZN5d/cBVPZlgThxBUMYaffQ5XPnaJUy74CFQ6eBd/KnXgy1PyGaMzCfhb5eB9n9mLtByP6BKjwpwjrttU/qEncSGyWaIt4PvyjYvykvnfnw0n//ZYRVf7isLlPa/ulJnFbGLHzNVzjOPD8iXgrKhAZLTHT7CL9i303gCEd+ErDt2ly1jkvv+hKtaBYXOBhCc9u7TJJpajvKXdQmL5YFzP0eqpmnAQimb+H8Alq9GoQykZC4Jfc4ayAUo9k/SXWGCgrbwM+cWAOPAnQqXO9xcPoUdL2kZZdGGdhy16bkHLqGPY48jYCeM09FLh5C4xMuFkfUEE8ghydVHmxA6DGhgj0MylYzTtaVGx5joDXd1CFWT+NMkAYOIDYoHpU+BJEZ0+LIMU28o36wLA9O5dYMaoVVJxvBaKb7majg6ffeLfQtGrI4ei1otqsacU5Gk5UlChaXgRVpOCO7akUBB1g/YRCj/ejNnERGXyI9ESQikXUlN294lPG4TjJ8X0EDGWZjh176nrjOsboLnCWWuvx8JOKpxH94mXtg3rsj7QrdWxqm7B59mY7GIt/lg07O4khNITjEc55Nu5dAWlX7vCGxBPRqXYI2hvimmAzDRAAqk7LyyatpQA1Kdeu9F3Au2FWEFik9w6QQW60OdWlq4hfa+QyuxA3T1gQBMNpW0hg1bogZqyKyeFS3S7xIbyOlKqSuHjUWvzlsBTq3MDKxKqUs
 T7FRAmtN
 6saJ4bIZmN94T7gCVGgdcobTYWRWMS7I8pSTI8ToIvArk92o2S6MYOjggumXCpW8OwAMsKIbtFmXlc3Wn8kUHcG0MOrKaoFS218m3YDOAefMU5cAhw6yy+hPriusJtxlkrRTRYHKc6QEbk8q3pFerx43HZfsC3Orx20cajLpqt09tjkO0T83mewuixhGuJMxVWHLN8gjXqa5X74oSE3K8IGU4dPnjMjrJemE7YqItxfwx/g2Z4SZuytOwwCwbl/Tc/Xo8WKmUQ5Sg1SdgKWMyzBb5ErvfYh/UoeoFUueKIKl3MVZV/3ERa5PRxX+DXs0RPQhykOMBS98y4lJesJ/cE1Uff2eFu9z4KOpdVEEMNl4ltdMB5I1ICcGS1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

The kernel currently does not mlock large folios when adding them to
rmap, stating that it is difficult to confirm that the folio is fully
mapped and safe to mlock it. However, nowadays the caller passes a
number of pages of the folio that are getting mapped, making it easy to
check if the entire folio is mapped to the VMA.

mlock the folio on rmap if it is fully mapped to the VMA.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 mm/rmap.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 568198e9efc2..ca8d4ef42c2d 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1478,13 +1478,8 @@ static __always_inline void __folio_add_anon_rmap(struct folio *folio,
 				 PageAnonExclusive(cur_page), folio);
 	}
 
-	/*
-	 * For large folio, only mlock it if it's fully mapped to VMA. It's
-	 * not easy to check whether the large folio is fully mapped to VMA
-	 * here. Only mlock normal 4K folio and leave page reclaim to handle
-	 * large folio.
-	 */
-	if (!folio_test_large(folio))
+	/* Only mlock it if the folio is fully mapped to the VMA */
+	if (folio_nr_pages(folio) == nr_pages)
 		mlock_vma_folio(folio, vma);
 }
 
@@ -1620,8 +1615,8 @@ static __always_inline void __folio_add_file_rmap(struct folio *folio,
 	nr = __folio_add_rmap(folio, page, nr_pages, vma, level, &nr_pmdmapped);
 	__folio_mod_stat(folio, nr, nr_pmdmapped);
 
-	/* See comments in folio_add_anon_rmap_*() */
-	if (!folio_test_large(folio))
+	/* Only mlock it if the folio is fully mapped to the VMA */
+	if (folio_nr_pages(folio) == nr_pages)
 		mlock_vma_folio(folio, vma);
 }
 
-- 
2.50.1


