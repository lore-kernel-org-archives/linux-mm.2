Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70408F9D0CA
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 12:18:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD0A46B0095; Tue, 14 Apr 2026 08:18:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D81CB6B0096; Tue, 14 Apr 2026 08:18:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C70AE6B0098; Tue, 14 Apr 2026 08:18:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B73186B0095
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:18:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6A9BA14056F
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:18:13 +0000 (UTC)
X-FDA: 84657063666.17.39C1DF5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 92F1AC000E
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:18:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U3zXDr5j;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776169091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tlpYa+npWK67wu3fERr4rFjUXk6//B5ou/GHEgHbvRs=;
	b=T84Apo5eFjTnlLZwS8ezZgzM35pqzFSATRC5LaWchBM5S92yVNbORAwISXaA9jqw62WFSU
	0MYIaI6+5WJoFOuoTs1qzi9c2EW6CKjIkLeTYAkiC9AfUUASvlBFQD+OwLnnC8nSWnuBLN
	kLCXq39BxSxHryXvsVeWYkjQhT0tnXA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U3zXDr5j;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776169091; a=rsa-sha256;
	cv=none;
	b=CnP13Vd+wDCPI+Se2IMlHReTCWwOFy+Mo78JIDzE4+XCK2iLf02g+fO2E+JYm/4z+PSBUr
	FuSYEd+VGDuc302jKWMECXPQ2HnT7hgdLd5/+losprwAxnmQSmIJ1xyXmIhOuMLg2tjvOW
	l5y9LXtQ6h18jc1g30kZuBePXba9CSs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1DF2F6012B;
	Tue, 14 Apr 2026 12:18:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB242C19425;
	Tue, 14 Apr 2026 12:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776169090;
	bh=YNjBFynSiYepy00+I6db/urO7I1hBrfVj/khQB19l1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U3zXDr5j1rSJQN6toL3I54tNohQfqxRv+hW0/rWKHKA0bLXHFIbj9IgaAMIVFX31r
	 T91EZt+9pUl23IvZybUc/4WG4ycVX9PHSrV8Cwdnns48sBq85uvhRXJsFRddSCHlgD
	 SAxHWzJwnVlbesq0LXF4/C9PHuLu7GNpivAJyErPzuZXMm/7S/tgyssDVh5v4c9lgK
	 pkysQFh+CBSJU2fyKxGHBblbhHTbVNds3x87UAZHpA2wAk3UyPaYvN3KO/VAI7jyHB
	 4MULX+QMgY9RHEECrszZ2KhKgayn30bINuhpXf43iFQyWWyHT4utf1yNNbxmHVE7id
	 duUYJT3fhZNgw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] MAINTAINERS: drop include/linux/liveupdate from LIVE UPDATE
Date: Tue, 14 Apr 2026 12:17:20 +0000
Message-ID: <20260414121752.1912847-4-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.rc0.605.g598a273b03-goog
In-Reply-To: <20260414121752.1912847-1-pratyush@kernel.org>
References: <20260414121752.1912847-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4y5xe785zgm6tif7opp9e8d6ee71kmau
X-Rspamd-Queue-Id: 92F1AC000E
X-Rspamd-Server: rspam09
X-HE-Tag: 1776169091-80921
X-HE-Meta: U2FsdGVkX19GyMyJWMowneqHB3yCul1mSQhklmARIutrwtb1zOLXFJ5fdpYKpE4KYYf6/hjLAH7c6d4MZoWlE81MkBZLpxMHMKzJ8DreXTnYONomJ1+Z+99HSti/+5bshTsxpZncpl0mbc43rCuSA1W/FGKKlMFldOAgtEOCzvK4j0HdvNI7ujjc/V9TF8bvgKMdBxo2b+/zgKUuocf9NoW5GrOoBNcs7IFk1YWVqw1mpB38JVCWg5oUpaWWWNSDXkZbnoZ1hNZWn8K5Xfjtk+Gw6X1LIFNxkDxt+fuc+kju2S3gk4ghgIYhjT3bfuw6FOZgs23n2wtMxUwSccgcInF8fK08qaHWEIpnqaYRr41skUKavAAoyWB1iCQa5zh5mfEhWYfflshZTDbFQeQWgrlaIUZC3Auz4E6hMQ7KDoay77RqtVIgaf/jZRSqr9EoJucv42zFjzIL42rP833T2wdyweiXZdrBu97mphejzRBsZ+2xcUVAbGChA3iySL4eNvOWA0/i+bb4/OCTnqU/hCu5qoiByYbmXDq3c27mB7lCtx/Z2o1BfzqB9K4Vd6l0EIgJXLl7lMnYbiKXzfVQWuxGRkmRg84n+UQq4rYrPr4lm4CCoYL2mboo5yT41Mo/CelmF4TSYb8yZyHuhxtnVzAGEyQTW+HuLXjUKup+TTAJBLHJy1VN83l2rL3X4SzGLvsxEfpyPagNjPCQOq+lGSzDKrJPf10pGmCtQkadmDa8K9hNl45+/wYKYsJcV9Xn3QB22hs3yvBjYtKuyrh/ZSjYuwg0mjZ2jjcGRdGWo1U1XW4ZHLv8JQ0Fq+8tWSznGU4k9upSoyItFc6IA3JmRywHP2CNUffz5qoVlYKy5o+duqtmh/xRrpHQfMwIY1+fGfDxU4DLJCaQ06IWbUKvzbEszQM/v3k0VO53K00zw9wgQMObl78+fQaPw6oYv86tHpKClm5T2SvbB4fUP3v
 0Ee2QNaQ
 138Ifh7HgOWHm/1lz4TtABpGMQI3jfohHmvu8+gbgS61drrgC3diNyYU2JQERqGsomLW1Q5w7KKCRMDXYO6aGDaa24gtHkoV2DXosLJLU8LUubJJvk1CgB1gMRiT3/gyzfiny5nTgcK7Oos6DbmMiYng3QkTSv8Ooh1NsyaDkAOFip+0m7rpGfI9sPZX+TIZGi486Ur0M97qBrlx4T1og29kNZ1Ttf9i9L+ja9vhSINkRC5o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The directory does not exist any more.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c1e2cefb4493..bb588928533f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14811,7 +14811,6 @@ F:	Documentation/mm/memfd_preservation.rst
 F:	Documentation/userspace-api/liveupdate.rst
 F:	include/linux/kho/abi/
 F:	include/linux/liveupdate.h
-F:	include/linux/liveupdate/
 F:	include/uapi/linux/liveupdate.h
 F:	kernel/liveupdate/
 F:	lib/tests/liveupdate.c
-- 
2.54.0.rc0.605.g598a273b03-goog


