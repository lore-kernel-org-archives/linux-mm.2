Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D4D4606A335
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 21:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SDmzrH7j
Received: by kanga.kvack.org (Postfix)
	id C1E0A6B05B3; Tue,  3 Nov 2026 16:00:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF4386B05B6; Tue,  3 Nov 2026 16:00:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A46A66B05B4; Tue,  3 Nov 2026 16:00:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 735486B05B3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:00:54 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0A806A057D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:00:54 +0000 (UTC)
X-FDA: 85395027228.18.C1CD1A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id D48CAC0014
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:00:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SDmzrH7j;
	spf=pass (imf28.hostedemail.com: domain of devnull+mt4022.columbia.edu@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mt4022.columbia.edu@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793739652;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wHJUzXmrAF9C150R57fNbacGrKg8aH4pOauYcunkpBc=;
	b=DnhM9rBQPDTXFwx49qRlOuQYbxBvEkfRG73ejxjpyeC87mSRRw5lc+uQk9Yp8kE8yliqmb
	SLUWzwYh1CFoohYpOwy1nUC9bxltvPxy12tR0tCn2OgItyYOnNCCQyFORMipqzWu7r5Pc9
	y61kNwns2v+N3+HNQnCAtc65+u7RzQ4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793739652;
	b=dI63GX6yKoCy68Owex2s+Mwb7tORDt/4jz8HWF/BmYix1RApZ3aZ2apXDNoWkYTuVKICw2
	k/qiJFAfj+dsp25sDocl6CNvdV0rYPH2cL8uZtdy6p/Ny+qumesKjXx7HqEbtRuWRdkP6y
	b7uL5ZVnnYBz9T0SH3dKL8evo+3Am+g=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SDmzrH7j;
	spf=pass (imf28.hostedemail.com: domain of devnull+mt4022.columbia.edu@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mt4022.columbia.edu@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A3F8F4365F;
	Tue,  3 Nov 2026 21:00:50 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793739650;
	b=mYesL1myPZGvUVULRmgcNIrdN4oShjQDfGH8gAkoLB2UAL0SnS8QBqQA2l+lQ51c/CUx
	 eJm/aW3iQS/R3seGf153siMGdPzf1GKArLNAt61gcHY/Op1mExSZnCjYHoT7YfoYjhhqi
	 c0rUCjfBg3Lvq2RAIpF1HKhCJjGk+vfMeSaZCPoeUCFkHDXPgaRcdo27Vn9nzPtZwTzWZ
	 4v420gHEmFt5VRy5WuP/typ5TFAPXrBFUnqFgoqW7xMiaYQ1RMDsDUAjqrZxYC8hTPpaL
	 9pEl1vjLoYWsQv/ksPM5wmhF8Bxtg2sIJEukZsl/kJ3AVFLSrOPLrKlgBkHYeIcE9ig==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793739650;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=wHJUzXmrAF9C150R57fNbacGrKg8aH4pOauYcunkpBc=;
	b=Q5fR2i0knS07LPktU+AKdmzgfHZFR9H2e4kHycQG44tzzlChoUxCFEfc9JUApK4MuMpF
	 rilZKyK63OsE9sMhVeeXzeEC1EQBQFD9qKOvghVmfRfaFVXg1RDAx9v8aeUOjzAqx/eRF
	 sRcr1xh1sd+X6taJtFQ3fVuStZ6HiZMMcWnQf4ZxGabvc86/0GRKNriqByDpQ59HDw+b5
	 0E54jnJgQ92AwNoDKtIC8VyvDfgLK4qFQ3CmeHtibEcOTxNLB9LObGpUeYrGSOhNq9nhj
	 sv9LHhpPfL7V4d4x63foKGlL/uhA1AlM3UXCjwgbhC4k9Q4g+ejeJBfy9n7zUSYbcRg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id EEFBA1F00A20;
	Tue,  3 Nov 2026 21:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793739650;
	bh=wHJUzXmrAF9C150R57fNbacGrKg8aH4pOauYcunkpBc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=SDmzrH7jCpkAPutlRcigOiRnlE0QoFf9Ww5DcM8AOIlsuwsQNig5d48FH8qXds9GU
	 pLxQWQagZ58xiHkvYuCOe1u1dxeV3BU/VAVtS65thyUFe5utqmNjUdZ2kmrSJfekdd
	 E9OR4KoSqZuuD5CovsyXzSWa2/Z/HWiP7hAdgE4GvJczYEtTH66alKOHidAlofre/U
	 GEdUO4Z0DGze8gKPTV7Zr7JBWprzc+pTHhffUFQm2HBy/AdVZgmA1tbH43J0OYMCq6
	 LnnVY/jwQNg/Ko4Tc1bOhgTF18yZPT0s59IviN5W01LeUk/xDFcUJrjsiJK9ZiYzrr
	 TlOHpB5lVDOfQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 5AB1E46B12;
	Tue,  3 Nov 2026 21:00:49 +0000 (UTC)
From: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>
Date: Tue, 03 Nov 2026 16:00:49 -0500
Subject: [PATCH v2 1/2] mm/memory-failure: don't unpoison a leaked
 raw_hwp_unreliable folio
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261103-hugetlb-hwpoison-leak-v2-1-98085750c145@columbia.edu>
References: <20261103-hugetlb-hwpoison-leak-v2-0-98085750c145@columbia.edu>
In-Reply-To: <20261103-hugetlb-hwpoison-leak-v2-0-98085750c145@columbia.edu>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Matthew Wilcox <willy@infradead.org>, Jane Chu <jane.chu@oracle.com>, 
 Zi Yan <ziy@nvidia.com>, Kaitao Cheng <kaitao.cheng@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Mike Kravetz <mike.kravetz@oracle.com>, 
 Yu Zhao <yuzhao@google.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, tz2294@columbia.edu, stable@vger.kernel.org, 
 Mani Tofigh <mt4022@columbia.edu>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793739649; l=1959;
 i=mt4022@columbia.edu; s=20261026; h=from:subject:message-id;
 bh=QKydKJ4ULQzr2TWbUaUZ31FxafHdsfMjukKm4+Y/tFQ=;
 b=SJLl5itZOXZdXocudWDHOPpqGm7WPscqvj34RDOCSjv1/dQqDbfcDehqvMdV2OWf4dkqSsplW
 3LJLVsPFS7OBgAZhQlhMVCsD6I7lz3GBvWfObDnz22fxvnZpxoyC9Ux
X-Developer-Key: i=mt4022@columbia.edu; a=ed25519;
 pk=gljCMQDuxyKPmd5y37CRpEJGSPXDV1MyAnHBhCgXl0I=
X-Endpoint-Received: by B4 Relay for mt4022@columbia.edu/20261026 with
 auth_id=1322
X-Original-From: Mani Tofigh <mt4022@columbia.edu>
Reply-To: mt4022@columbia.edu
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: n7f7yb1c86pdp6ey67tcoffx8auddjc6
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D48CAC0014
X-Rspam-User: 
X-HE-Tag: 1793739651-60645
X-HE-Meta: U2FsdGVkX19CfyY0/jr6bilnuF6DYnJz5S9r1E4MNJPK24IaaRm7z5ucYywQE66u7jTWOk4Qki68RfTT/24ky5/CZHK+zggxj3zAkqfQ0qT/dNLj/h/0n6Bp08pKYNwDeyVJckbyqtqoe6DvKSRgfhCyzdG4x+h6esli74PVbla+SisxPMGDCkod23T/CgnnKAj9UEaI/Iq2x+4SDhO0jGNgg/A+jJ/HQ9DJ5KcpCbHTeMmo24qb/seIltXjTfCQoTfwdBpo7453MRS/xxsMxoZY6hKC46NdeOt4ds1SeA33hXaDeKwBqyR5w5B1yvZxPCVq4tgknRg8nHX6sKiKGtvUW6G0j1qxuGhUB0nra7D8b0W9mnr8JPZA0RWoVOjLnRoFZjbIYuiQY3hPnTPelZRYi554myUhPUASOgsXZbVwP4xdSrXDZDRTRrGxigMufL7R826W3nSlYbt+kB/YjaiaRZ50VpniliksmMMuauhJZB/1jATqCoFy1qQaPYjNTOj7kMQ2zUau5kUUWlDkTHyX5nJm2Ivpr325ft/21X537zOxMdhm+tOdFXWZvr0Tp9E2S++lpJ13BG4OsquJqrFjZ4PjfJXkUOW7i27XoBlJDpdlbQROI/vqJst/EpzgxS4iZTp71wrqQQ6mN8XHFSVA25WnooTVG2BMr9RpRo3kWNn8qZaX+tO36BQsRoTe8qaOANshPV+61ZjBxnweZAd0eZu9FV0PK3uVgQsCEgSd6Ro6x4HI8UMoiRHAowBQwDZq9PJgisK+4EGpRWlrtEIbEMWmZ3CyPP2xKxUS0LFJi8Z7gHgPzrFoHmjO8tUq1hnGSzdKEXoXdZK42iMShPr0uwlfiA36q+osr/FcJSDgkZdYZcX5ezASasjF1X3b4g4gtCDnEECI/7eEP6GiONhpq+2MDhjfnYKNLgKjaQLUKHlCqMVV8hpGlqzQGfam1imTw6q5Do94+bHMnq3
 q/+PbEid
 uNoWZqhldLnUlC+7fJPteQpIcA3OoA8YSV6eCd6XvdhWrcw37NoE9z1e+FKEbTUJP9QKubOsN/zpY9tFWB5DL90pC+njUJVwDP/y2WszySIYCpinHNpbuBqJB8bHNKnTg/vCBRK08Nsgz0wokmgiR5LNtk2FFFVp54/+Pi5FB0id87SEslvSl1Mef066rulMiwpcLO5zU2uRptolZgu4pxa2nVGBj44O7P2itFMq/y+J96Og+y8T/oxFQq65FzHhWpvLYYPax10A1+vUfG97PmSnCFrKI29LnS8OI/+TJbw5jCxQwXwknCXKtqaWV1rJcnNTFoMixwOT4Z02cSs7bqFXocyqH+m0YL6f3zSmOQmJcmK9vLlOm0UQaVrqrn1jh7NjUnezOAQRIFBix//IZhapuhGmZECnaGzVHPsQi2OrrkFwiRDP/uwCzNxBSnLmfCB7FsGlaIMi+d9xgwL6xZAYTAvbRlLyunJG5520Wd05tk0QxfDJ/7E2I6W/6MuG5ktK5fj2rXJKATBGnrwk0NAQoc/U5CGk/wopEI0km0uW5nHvb6zN2fI72uFgYmw5/49ydCoeY02K/CerE/ZUCmXqB23KEvkD8mLGG4lQz/ZCSQhc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mani Tofigh <mt4022@columbia.edu>

If memory_failure() can't save the raw error page of a hugetlb folio,
it marks the folio raw_hwp_unreliable and unpoison_memory() refuses to
unpoison it, since we don't know which subpages are poisoned.  Once the
folio is freed, __update_and_free_hugetlb_folio() leaks it on purpose.
If its hugetlb flag is cleared by then, e.g., without vmemmap
optimization, unpoison_memory() doesn't see a hugetlb folio anymore.
It treats the leaked folio as a normal page and clears PG_hwpoison on
its head, while the poisoned subpages are still unknown.

The leaked folio is still a large folio and raw_hwp_unreliable stays set
in folio->private.  We now check it on any large folio before taking the
page, so unpoison_memory() refuses the folio whether it's still hugetlb
or not.  With the fix, it returns -EBUSY for the leaked folio as it did
before the folio was freed.

Fixes: ac5fcde0a96a ("mm, hwpoison: make unpoison aware of raw error info in hwpoisoned hugepage")
Reported-by: Miaohe Lin <linmiaohe@huawei.com>
Closes: https://lore.kernel.org/all/ae6058ae-3703-a1d5-d82f-4102b46f227b@huawei.com/
Cc: stable@vger.kernel.org
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
---
 mm/memory-failure.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index b215312f261b..496eacbefdf2 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2809,6 +2809,15 @@ int unpoison_memory(unsigned long pfn)
 		goto unlock_mutex;
 	}
 
+	/*
+	 * A hugetlb folio without reliable raw error info is leaked once it
+	 * is freed, and its hugetlb flag may be cleared by then.  Check the
+	 * flag in folio->private, which stays set on the leaked folio.
+	 */
+	if (folio_test_large(folio) &&
+	    folio_test_hugetlb_raw_hwp_unreliable(folio))
+		goto unlock_mutex;
+
 	ghp = get_hwpoison_page(p, MF_UNPOISON);
 	if (!ghp) {
 		if (folio_test_hugetlb(folio)) {

-- 
2.53.0



