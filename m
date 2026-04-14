Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 749D1F9D0D2
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 14:24:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D07A66B0098; Tue, 14 Apr 2026 10:24:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6A126B009B; Tue, 14 Apr 2026 10:24:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B12736B0098; Tue, 14 Apr 2026 10:24:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0AF76B0098
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:24:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 60692C103B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:24:11 +0000 (UTC)
X-FDA: 84657381102.29.B7B528A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 68C2C40012
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:24:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J+UwIEDX;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776176649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VwAzeixR9mzgXgbmCFPNFFmxHBx4TUh2MXW2O0WQr5M=;
	b=VVXK5xExlgUeE528lahyMhcMpU4nEOfQiVFv8xZPtBZET0QFk9pWbGLYAJy5nTo7oiu4fG
	YGOHOO4sJdLMWxlhcBrKXcLZenxWmblgl8wgRfOmIC5oMrHYtJVBG1IrYojjK3jfZ5nQPA
	pxDt45mtcFdU2QrOv8PrLjF2U/mkxnY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J+UwIEDX;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776176649; a=rsa-sha256;
	cv=none;
	b=5u+4iE2XvgW86pwTXIITNSiJMCgaXbrqIFt5i5sE+9mys8YoErwfUgX5MZJamB5XVh07sE
	lQZpLc7LL6FHb1saO4o/7Tf0TeMGVDoisFJvi5MrNEeSFS7nywowNNfjMhwin55i1z5h8s
	Y6ffseIyB/uNcEEtJPMmotVmoYnkkWA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E28A760125;
	Tue, 14 Apr 2026 14:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9FAC4AF09;
	Tue, 14 Apr 2026 14:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776176648;
	bh=T8LSXzdMMBigtmoOeSLgAOloW5y/jN/E21D4tN7gU44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J+UwIEDX2Hno7gZ503jzP6kL7LODZ4sZ+n63LCpskA+XB/LGFfhvxV7WdIshMiueP
	 MMT/fvUJSbgCgMW/NpkAKJYpyj/aJ9XcFmqAgqvR826+dY37p7ftcNmsX9hcUpPyW+
	 aodKxUyfnQJDjn1uWyuv5rN9eM+BtFI7/1AUKembwagUrYr9pj0XFP1G6w/eUdUKy+
	 cozWgNeXmuep77Cp7V0HVnMur3Loy2I8qq8IC8V8LoJRzZ5MjblvRQmYFALCC0vPUm
	 PtQjau+pBPSuQJ0m+IlbLzoVgsUIhkn03gtVs0ZbMCdDiKDkxLW0Bbj2nI1mwBfbiN
	 zO4vQaUUNN4Bw==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 876FEF4006B;
	Tue, 14 Apr 2026 10:24:07 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 14 Apr 2026 10:24:07 -0400
X-ME-Sender: <xms:B07eaamlq86m5G7fwWFFR89ilsVMxxDzx0XuBlJMg5xo323pXDsMKQ>
    <xme:B07eaRGXbaDkgYaGFJr8RBXQht6hLx4UgETebC_5OafBcTY7SEBW0NVJvq24OnlG4
    KJtnqKMxTzxlLSNk9o6aMiDCQgTvg95FOW78mrBSzDbQn_2ePchSA>
X-ME-Received: <xmr:B07eabeMbeDUVLk-Wa0m1mAAVLvqnaejVtBwAYt1XNG5BhJBHLWUPfNM_2tmwQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdegudefkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpedfmfhirhihlhcu
    ufhhuhhtshgvmhgruhculdfovghtrgdmfdcuoehkrghssehkvghrnhgvlhdrohhrgheqne
    cuggftrfgrthhtvghrnhephfdujeefvdegkefffedvkeehkeekueevfedtleehgeetlefg
    feevveeukefhtdetnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilh
    hfrhhomhepkhhirhhilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqddu
    ieduudeivdeiheehqddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghessh
    hhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepudelpdhmohguvgepshhmthhp
    ohhuthdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorh
    hgpdhrtghpthhtohepphgvthgvrhigsehrvgguhhgrthdrtghomhdprhgtphhtthhopegu
    rghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopehljhhssehkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhu
    rhgvnhgssehgohhoghhlvgdrtghomhdprhgtphhtthhopehvsggrsghkrgeskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtgho
    mhdprhgtphhtthhopeiiihihsehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:B07eaWErl-LdWJDCm7RWmTfhyWg3YDUCMEWb4RILl456wawMgM4uZA>
    <xmx:B07eadHmDpoEsd3AyN0xUeV-fLAvQCQUHiYBBe7xfVuHbpMB1fazfw>
    <xmx:B07eaeNbZ96vkjZ1yFqGzoVG9Wqyy4UlHfThJLX1-emptJRERr-_mA>
    <xmx:B07eaar45yZpIUMhk5LThQEQds1mx9n6UdimwEXg3QZCGnR9QuApxQ>
    <xmx:B07eaXCGWPatpEzoVg1MgpCPmIqFcAfTt3ZSkrpQjgy7K-ulPvEs4HXd>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Apr 2026 10:24:07 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [RFC, PATCH 06/12] userfaultfd: auto-resolve shmem and hugetlbfs minor faults in async mode
Date: Tue, 14 Apr 2026 15:23:40 +0100
Message-ID: <20260414142354.1465950-7-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260414142354.1465950-1-kas@kernel.org>
References: <20260414142354.1465950-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 68C2C40012
X-Stat-Signature: x3mdmccjzjmqejqwhyxa3s53rqbz11yi
X-Rspamd-Server: rspam06
X-HE-Tag: 1776176649-699666
X-HE-Meta: U2FsdGVkX1+KjMQV4kRYbPANOLdjtH+u6gJ/5FA0IdtZejiF/f2Nh/GBrP1aGK4JMjRqsr+GxfO1Nb4jZTtr4ASnah40uDs/Cs18lSzW5LXLt/8BHOTWIQLjRqoigiMxT4k7jFM5laq0B7wwUUpCCwZCZX5xb83rR+/59tPdmvVXttg0COp5tfCMyh6HO8vKfhOAhOXCWF1wM5bVIHIwezobM1SutLgpMFTGWcEyPm1nYadBnM6sQ6S+f0dbcJsxNmesY66ui0cNonePuW7eV68AE6yQp6jzesHa+ualMxPmhmgzQdKKPZODPgHwHGpzostu1BWqSkIYdJdyKjasb7XnATXyNmfrYjxu8lul0VlhAiwTwD//1IOvkgtgVMOdtnz1x4yLGxVUQfRuxmsvHxsZcWe719Hjq5fhE6eFM0k/QjgVLYaxams6j+gqOcIjJfZA70MqdCVjT69zfBlPEXL5JqTwRgWnfLNmEI0gf0REupjhkHV8YYClhS85/MdrbkXu4zo8a+WEPw9ce08EFnTzdPtS8vnXCEkSH25PUjDVrK9IHXM43S+14iZYOWtFr88zvk/cmoTPZPwY8szmZfAdwWKKWU09hQ3CN2IYy+oRxwvaYnHE8Zqb1gHBHkZMyEFNAC2D1H3jHmYeJ9z4i2CjnrXKa/n29gyDgTSwgZsY2moEmH4LcVFG98K/gZvrG7Rl/D/7gI8IaAZrQHY8GXpgP3IPEceDWU2nyf7lGPHpmVK10DT1f3QiytpN9fF5Eq1Bh9yzeTtACkHTPVVhg3ZE/J0NH2CPBPFFUzDt4M2GMmEq2sPWjBcG48zb8WjICCGr9sOL0P/WOAcRb0QcvPDHkXPzr7f/GWAXJjqzhgfnsef+tf4sVxuTVMRuCMn7WovCVLdv0cgIUSf9QPNhi5+XiglUGD8sUWWoey1iyExKbEabHdxdYe5oswwYXzTSRaCdmPu3NEO5bYFTHv3
 hvc7dsad
 slUZNoSk2z7e2xr7hKn5sZ+zir2VmuMfETh5YFecDgjhJCEaR+w3vVC6xUVjr/M+7kRZsGJCcSZbYc0a+HARM8kmyBUAneevNuml1aUiv21U/xzv2UCwwFb2JlX0l7W8A8HrfvfGVmUnlagrYnia83Fmsv7YNdWQ0GFqG5HbAW3kC1SgD+mXINrTanfsINeueOkOHWdOTS/XpEFE7cbGlMI6muJQpPpYe4zS3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When UFFD_FEATURE_MINOR_ASYNC is enabled, skip handle_userfault() in
the shmem and hugetlbfs minor fault paths. The normal fault path
installs the PTE from page cache directly.

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
---
 mm/hugetlb.c | 3 ++-
 mm/shmem.c   | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 327eaa4074d3..c10d2432768c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5847,7 +5847,8 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 		}
 
 		/* Check for page in userfault range. */
-		if (userfaultfd_minor(vma)) {
+		if (userfaultfd_minor(vma) &&
+		    !userfaultfd_minor_async(vma)) {
 			folio_unlock(folio);
 			folio_put(folio);
 			/* See comment in userfaultfd_missing() block above */
diff --git a/mm/shmem.c b/mm/shmem.c
index b40f3cd48961..ce47e77fc090 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2489,7 +2489,8 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	fault_mm = vma ? vma->vm_mm : NULL;
 
 	folio = filemap_get_entry(inode->i_mapping, index);
-	if (folio && vma && userfaultfd_minor(vma)) {
+	if (folio && vma && userfaultfd_minor(vma) &&
+	    !userfaultfd_minor_async(vma)) {
 		if (!xa_is_value(folio))
 			folio_put(folio);
 		*fault_type = handle_userfault(vmf, VM_UFFD_MINOR);
-- 
2.51.2


