Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FA3EFD0049
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 01:35:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A265F6B0093; Sat, 28 Feb 2026 20:35:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A11126B0095; Sat, 28 Feb 2026 20:35:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94B2C6B0096; Sat, 28 Feb 2026 20:35:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86F7A6B0093
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:35:47 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 43BCA1C2D2
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:35:47 +0000 (UTC)
X-FDA: 84495777534.03.B68CBD1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id AEA75140009
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:35:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dzMNRBQu;
	spf=pass (imf26.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772328945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5d7ZzWGDfU1LQlXJv5z6ZbYlcm+c//vZQi0epOzSp40=;
	b=jSrQwSrsBCdSA+FbBYI74NLAt6IPbvxXvK77kJyk7UxbCvUjKPIM592bbMPvN+guGXPxyB
	3tymL8aTMNHY25LNmOxueH8O/U1B7qMK/J1YXSIIjBOjMGuL0dlESHsqbf+pfiui6jhsbc
	PHLGC8EmDGN1d+dkcI+CxMz7hh0GoAI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dzMNRBQu;
	spf=pass (imf26.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772328945; a=rsa-sha256;
	cv=none;
	b=DsofUXFUg+V6YLADd0aqefQ8ibjqaB3kq3QWvfH6UTZqxQgJNbA0HSCK4A8TIFkl7xqxHU
	5TkCVA95Ja4qdDidz20+iyXvKUSmit9SF/p0cxXD1IFw6j4poCY0eitVSejz6B5U/tlYzu
	jWQXMgWLAWGPJi7qCMty4YXETD6rbaw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E80060126;
	Sun,  1 Mar 2026 01:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B146C19421;
	Sun,  1 Mar 2026 01:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328944;
	bh=Nl0mnI52GrpE5DPaxeEY3EOBXIawluoU8XfW6848HIM=;
	h=From:To:Cc:Subject:Date:From;
	b=dzMNRBQuFhmdDHMH4Ki1HnsSzU/VexuA0ZMgP+LJe7AjYORt9dEr+jkSlfMgZxeuE
	 iKJLf0FAI9iJacXRPtNUVWFCtt2jhfJ/xioNCYEusMpb5zQsQqZVviveCY/c6Rcec5
	 FH4X991/L4QgfqSGmM2RaqKDcubjsPTwq2InSjwVwGIzf2yJHS06rmtRJYDAX1rOK8
	 rmjjCgpoUqnAesOuzkOaFl7CZo8sZhqFz3i/eUDJM1i59PIfEk4ZXHQqUWNctHCfDD
	 /AObwX3xd/ywwYIdvqmKoIQSLm4VlaxxRl4QuyKawjgEaivNJbN54ePw6xw+L9R30B
	 SRdxJvUZ92lhg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	williamt@cadence.com
Cc: Max Filippov <jcmvbkbc@gmail.com>,
	Chris Zankel <chris@zankel.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Subject: FAILED: Patch "mm/highmem: fix __kmap_to_page() build error" failed to apply to 6.6-stable tree
Date: Sat, 28 Feb 2026 20:35:42 -0500
Message-ID: <20260301013543.1695499-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AEA75140009
X-Stat-Signature: 1e3ec8r8btwe79p5qj7178aruuksnhkm
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772328945-182487
X-HE-Meta: U2FsdGVkX19s632/7/BxJGcmQHkPRdMBij5im9MHDYP5xkZ5avXFycDWmnu0sSPMQHSGtYg/dPt1BdG4sk03QjYoiY0ms77yw3zyLqXJTDg50sgLKedcKs6U1w7sEY++hYEPAJ9DH9m70uFJNHRlAHuPnuYobjEP7rg++XIeO/Hz7cRqj93OlCJ7n9ZBh3TnRF6eHKQjXC7fvsYPRJWzEVVzk0rlksBjnNs7+OwYfU8wfh7sIaOTwDs5NhP01k5P91aH4bI3IhUXob53HQY06JumgZDp/c/fDYtBhIH2QZbg7HvjvvV3VXFiqn6Ef8D7yGnVNpsFA+gbJ3wDvROflgssbtxQCTu63DsM+iDUDDkqD6SLjepSvePyCUMU1ivYZh2iwv15yJY3qwW0WrnvNGLNhCLnk6jyIIQ477It5hzbgVnjCnVhdQSAFMwrIMsR8MXdaCu/VPvvhhCH4NZ3+A4Ryciy4w8smiJfnQLlsFzj7g2xAn0IzQIkak5GXtgRv0hgNG8e5mOIw37bgyq5KCQCV6dXMVlMT/XontNDAH1cuENfzq4B8/FKJN4DKXKaPh7apj42MapQ79/a2BQRjY8RdEsW9yTH6mYRwPxe0mwGzESs1RxTsopy4n4XNpOexyhSj8A3xIsiUeURz15GFdUs4G8lJdPCin6/S2b/LOKKkIt0jx6VgmPCws9rEmQRPaf//Ka3pEketk4GRFMALTg3gvthSWjdeuh9V8BZtUtVxRI84GZLT8ulMnLWKt0IqN3Y3mgw2KKVMr44bZ9WtgRTI1KsidLhd4d4KjQZhuBZ8UYYjEZvHlyvgbERvNbkKnuctmGaue0Eo5k1jxrcXP37DBKovXyitYB4H1BMiiCYCx8kC+ntsmdQNQWQiVWzV1ILVqJaTLGrvTs51+QlELPUSTxAreR9PVRW49DW8FwkQyJInJVyZyFUCW55rVFR6VXD0TH+SLFUssLC/U6
 Mwqu5qKz
 6BMc9ZbB0ylDsCIPGzc7pNwgonLiOsIPVDH2DkdaR81TrQ7twHwslu3ru9iiJ/xR7RS8lZ3tU+Xxng8DwpZnD1hjjxm7Psi47PDGsnVl31nmrACTRvyZS1Wwdxsi7NOoKCoduZFeGejhBgMx4kzxgYrlxal2KaL1OILuyFTWf2jbGwRhfBmMj3Pofoa903nElq6/5f8Y6FChjFF/I5tZ9OLODB7YR1v8b7OJ8a58A4yalX+G9Y9df/Taoe8AczJDWrvBB5hvH+6Gag9aDf288tbBXGdL1gw0ABLm0zu5K9jrJHhUCW8v4g+5S+9olLkZMG15KNbTXi5FmRrHoMEq7oCLz5yeLMriQWgMKJiB4Kzwm0Sf4mrqI21MM5etRpr7XLLN/6icW5jLqyHlG1YVeIRbngN6zMJKlnBHQfF5jcxfD85VCxgguMAlW6GwNsZbfdFWGSEajKLlGAdhf8uG0q+VglL8N4F/cLNH3l9Pei4l+U9y0L7P4a9hu4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch below does not apply to the 6.6-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 94350fe6cad77b46c3dcb8c96543bef7647efbc0 Mon Sep 17 00:00:00 2001
From: William Tambe <williamt@cadence.com>
Date: Thu, 11 Dec 2025 12:38:19 -0800
Subject: [PATCH] mm/highmem: fix __kmap_to_page() build error

This changes fixes following build error which is a miss from ef6e06b2ef87
("highmem: fix kmap_to_page() for kmap_local_page() addresses").

mm/highmem.c:184:66: error: 'pteval' undeclared (first use in this
function); did you mean 'pte_val'?
184 | idx = arch_kmap_local_map_idx(i, pte_pfn(pteval));

In __kmap_to_page(), pteval is used but does not exist in the function.

(akpm: affects xtensa only)

Link: https://lkml.kernel.org/r/SJ0PR07MB86317E00EC0C59DA60935FDCD18DA@SJ0PR07MB8631.namprd07.prod.outlook.com
Fixes: ef6e06b2ef87 ("highmem: fix kmap_to_page() for kmap_local_page() addresses")
Signed-off-by: William Tambe <williamt@cadence.com>
Reviewed-by: Max Filippov <jcmvbkbc@gmail.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 mm/highmem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/highmem.c b/mm/highmem.c
index b5c8e4c2d5d49..a33e411839517 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -180,12 +180,13 @@ struct page *__kmap_to_page(void *vaddr)
 		for (i = 0; i < kctrl->idx; i++) {
 			unsigned long base_addr;
 			int idx;
+			pte_t pteval = kctrl->pteval[i];
 
 			idx = arch_kmap_local_map_idx(i, pte_pfn(pteval));
 			base_addr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 
 			if (base_addr == base)
-				return pte_page(kctrl->pteval[i]);
+				return pte_page(pteval);
 		}
 	}
 
-- 
2.51.0





