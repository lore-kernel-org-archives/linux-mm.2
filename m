Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77DBFC88E5C
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 17:13:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89A976B009D; Sun, 13 Sep 2026 13:11:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 879A86B009E; Sun, 13 Sep 2026 13:11:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EB5B6B009F; Sun, 13 Sep 2026 13:11:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F272D6B009D
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 13:11:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E20561C2D62
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:11:46 +0000 (UTC)
X-FDA: 85209381012.08.7CA78DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 17DCCC0002
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:11:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dtc1pxec;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789319505;
	b=q4Ha1sLNYBsFvH3sFPoDkCbNZfOX/ixUQGO8FEI8TI4QwTWrPSA7rpX2h4PXAUPWTKmaXa
	Wf074pjFijJb+dgAugKyKqV53eXSJtZphkBtggsNFAZEFjO0LeV7qkrSnafYlEaHvu2M8G
	6yAqbGt1ieukdAWiL//nidpdob96S2s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dtc1pxec;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789319505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KlTkThYMNDC2bLrO2MA1hCJuFVsV7BXLwZ+Px5RpEUU=;
	b=SsKRCB5n4q49bXJvlc3ZPgL5iENB4RKaNO2GUu6fTj2CqW2/hj6ZWl2C67QlcxqQT0mTrP
	IuuRmDAmsND/6HnpjxMVqAvN5v5f1ZVugor7Ha/JThyIdGHsrev48UgCIk4muRiBJECrwV
	gwR+Fs8HOD5GFplQpu03gP+OMJtoQNg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AD04060E90;
	Sun, 13 Sep 2026 17:11:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F971F0089A;
	Sun, 13 Sep 2026 17:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789319504;
	bh=KlTkThYMNDC2bLrO2MA1hCJuFVsV7BXLwZ+Px5RpEUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dtc1pxeclo0Lzcvm9Ju7ImpdlIkpMR4zxG8Q16pBT2V9rK9BFgtLMIVk+r0rEZVdu
	 qqyso3lFo9zmZi9YJZPOExTH4wxs/vwm9MrdyNv8OWVDpNrFZIIvlAD3GMU7K9VTio
	 Xq1c3CkLRHzkmLkfcHamvMWiEIudHAgcvmMvFiWmh2c3967ddN/9mK6zcfp5eHsVcq
	 CiJqWcQODsLk6ErNRibLkv/6vIkgq6PwDtPe100ETqHERavMVWA1albjSPn0L4iCuy
	 LpnATobtsRv46Z6mBZq6BT4vPjR/CplutCIFOnnkh/yL9HZkRlcYXV7qzoev/kT4Dl
	 oGN8J/Jwbu73Q==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6/8] Docs/mm/damon/design: update for hugepage_size probe filter
Date: Sun, 13 Sep 2026 10:11:28 -0700
Message-ID: <20260913171133.102366-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260913171133.102366-1-sj@kernel.org>
References: <20260913171133.102366-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 17DCCC0002
X-Stat-Signature: bc4du784mk8e4fiepixm1ucywymgapky
X-HE-Tag: 1789319504-849760
X-HE-Meta: U2FsdGVkX1+dMMGl//GEnkUvOmNLVXRi2qUHOowIEuWQlmFG4/LpVt89sIaE9+vsOFpkYSqBoJTiQPVK9eYAsaV0MyKLH2syOvKxBtL+LPLeBa1h2eAMTSXI+mTcSmDPxbX1Fa4K75gVJYjEmJFsWUVuqfvRE1Im8lieA/+m/tgcFA8egO0M8HPmGM93xoGfCj/CF0zsuJzp7qZoqcAdH1wbz/T5Cuk+N3BVx0pAltZGp69bwZaDOA/KoZYfXSI5tKVq3eC+LYBl42+xHzrIlzwkXiwDZy4BnIx2F4Ih6t2Ij78rnQ+MOevUDvGAoy8oRX/FLGKE4vVNv5jKAZITLH2Z+6+LMVrbrEJ/Q/K0wn3cFG/XNX0lhOyeRPmrw17LPTzAEbiNx0Vept0ImBnHyDWU8F62NsvVOjZIWkYfCfOKtYW7gZXKYfczk2MOz5hyyoVSAKJAeZCO0KQoL61MDF/J1wsQczHXyjegxBeND/Ck0mQDu/xxRBT+5uS82PhhszRaXJ3PC/dz+9J61hgflkckda5T9eb9Pluze0yi84jNEcej4QSa1pPcbi+B8qE11/wfsds2Zs2uSxUY7Vu0ffgm7TmmDTlJpC+2buJTbnUKBhnNxqGxMWDoQrKW1UOXnDj2vO1ytf/olY0l5e4vIvg8gKyyqO6apMeZXimPs4pW0t+2fmtt3iXSsee74cf7zw6KFv8IlduE7d0ZnpzEF/xQ2xtzc7M0GRw+pj37MuDvDJ7o91D2uRVgl/sLpAGAsFqBMaOx+JSgRH/bdD16h9D8z7i8n+x7677YZfBSzswD8j72KJn6hgn6FRWov3lh85SxCVdVW1zIqj9++RBGq/bL/wGnAfDBLCUherJIicTlyXKmB3/IaLswkzf5rtnz+gSeTudxGk7b3lsNCWhstoPKNfmfcb2FRYvL/Ew67vxiDvWKMevjoTE6zSFLeRJWF7txxBIj4GHX0ATmdm+
 Yz3inU3z
 Rt1H3Kmc+uosdgcE5QKVRtzzfi1i/rhkF2MeCuD0mKkwSIPEj6afA4F6Xd0o0Gwj/Jh1ZOHWl2uepPS92Vxx2GjBaZ2Jp41uFPAYaeEq5Gci4tsuMOVjGxg4SpsOqaqGgvvOHsPlw8d/34HyQQYUYtqw95oWQkqBDLclEHep9bI+KdWWIljUxLlKVQxPJVXEqZLnCdVzRThfwcr/9naaV+umdx9apMYzT5eaDbhPLfLfjiULg5IWrLKP5hXY6w2YRjnM1cU0PD9hu4Vw23NpPexgCUe3mQSYwSu/P6HY5pbEcBKVbunPTvf9A3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added hugepage_size data
attribute probe filter type.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 707170bcd1b33..0a86792f90a18 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -300,6 +300,8 @@ filter types.  Currently below filter types are supported.
 - ``pgidle_unset``: Matches if the page for the memory is marked as not
   access-idle.
 - ``pgidle_set``: Matches if the page for the memory is marked as access-idle.
+- ``hugepage_size``: Matches if the page for the memory is a part of a hugepage
+  of a given size range.
 
 If such probes are registered, DAMON executes the probes for each region's
 sampling memory when it does the access :ref:`sampling
-- 
2.47.3

