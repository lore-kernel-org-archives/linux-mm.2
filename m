Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6573460A5BC5
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 15:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fUSTHPfX
Received: by kanga.kvack.org (Postfix)
	id 844D76B05B9; Wed,  4 Nov 2026 10:37:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81D396B05BA; Wed,  4 Nov 2026 10:37:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75A0F6B05BB; Wed,  4 Nov 2026 10:37:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 55B2A6B05B9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:37:03 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 67B111607A1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:37:02 +0000 (UTC)
X-FDA: 85397839884.05.826DCC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id CD9CF8000E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:37:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fUSTHPfX;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793806620;
	b=S/Lt0AytPELry01zaosa4bKBJvr+MOQ92nWaPoffDDswPmnXRhvW2KYgTclj90TEq5AZKH
	tbnUhoWZCKWEeW94ksDp7hfbD4woZ9LHjh2SXU8iEpfFV2LsxvKBj4lSmXf7i8uXrpS3x6
	UP7KGMOdsFW9wEbkCX93Kt4ec2onWl0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fUSTHPfX;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793806620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wajzrzMNwWMprOwxfVXw4rbgafdH+J9WHgqDAMj2GDo=;
	b=T3LN1JO1InG2KWPJdTioMTScNa9fc2nXTtE0JVHCjcydUyOswTXr2aZqmCLkgaSngFyQgt
	O/hNw12DpudOX93dRelmG7JNByrvP8TLNTxpdJXylwaJGp1wKfofMJgSColDofnUzzqLck
	HBSqu2CN7Ql2sVadvMTe0nksxaeCaMU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A94C43F3A;
	Wed,  4 Nov 2026 15:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52C81F00A1A;
	Wed,  4 Nov 2026 15:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793806620;
	bh=wajzrzMNwWMprOwxfVXw4rbgafdH+J9WHgqDAMj2GDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fUSTHPfXVyy6eDhEmXV0pnycw1UJqdw0B8+lWylxFcXirpx6O0qCliB9/lW0fp5HW
	 lU+aSu/oYSGUW23wsJuGLsEi6HIdqkO8DI8GmcEVmlyMoZ8Rto3P/+FhZvEsIw61Xb
	 fxlZ9EPX+lm9RxCJOggxpzuGUnhrZz5XQrdf/2Di8zw5WZhrp1GfT3TNIvR9L3AnI3
	 VtWgWNe1lJpxsu1jbFZ48yijjiHQdJwPLDIF6349sO2bzQUgukoFotCiC5+s48wsAA
	 CwFJrWbFeULQ5V9HcAeYXs9YHOXElDKApgfofnzOBANckqnFE+nKdvLvtFXvM00k9B
	 9RSCczVberDDA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 4/4] Docs/admin-guide/mm/damon/usage: update for age_ms damos core filter
Date: Wed,  4 Nov 2026 07:36:43 -0800
Message-ID: <20261104153645.82945-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104153645.82945-1-sj@kernel.org>
References: <20261104153645.82945-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fxrqzrsadsjb1t34wgoqu1h48ngs4616
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CD9CF8000E
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793806620-704772
X-HE-Meta: U2FsdGVkX1/DpUr2FxBULbl2Q/WZYxmJJclm2EiP4YJJsVgo8TjgGHOUBmxAP1dQAFHQ54CadVAf+xj2LmbfFNU1jGwLZ8Ktb1yotqAf2rNUqTn8QzAHq4EVekMLwkBsS7mqUdqClmsnnyuMuS5BH2F82lpm0O6p05Q3n6fP+wgMBIiQqLOvYVPYIztt6nykSl9nlrbk8Ed6KvEcPnc8J3ABzao9/21U+g0pmIRkUB3e8G7SNaH5AGIr+0h12zLbOokM4M7B3Ig64cnLZI7n0yrd5tVNZ4G4f0bFTxA7dk24rH/X/tuI3GmLPjoaeUb+q7swQ272JhU8NvvfpT731PJNMOdbUQy1JUZw6Uj+RdMwMJctqPQ5GxTYEDcemFznXXe4lEJ4HibJo/aYWN0fYIpS5qYzfG8ahTB2KvM7JAai23EDcoUNpeT44ngcCOetAk/LzYRURL46OPZlNgwJe6uQPlJlcwra8hWFh3S6eqwhs2ucigPaHQ7lQIa5TUW6TgAzDJSA9KjZaFsT4oEoS+xfyuqd8+Mu/inpthz32fOu9BHq2Ug6XV1Lu0zCNp5qtr6u+n2xcYH8X4JOwx35SEUfsQDY/oJhWC8C7Y0lITm3sAYrS4/w0yDfgLaYvFQHL1H8yUA4MpFv2wBV9HRlYZGAic6mFaTVspjHZ/Qv+zKnV3pznGkRqWrNcmNNZCxROaAvyhnCblCtkS81mxP7pkHPZtitjD8qlFZ4ENRp1A5fFn3tT3aHntm+9uaJOaBkoRKIBLzFxmUHhg+GKkh1pVhw7wQETnTn5Xo/sjsgGvurBJa1jL/I8AM0wMHLBY8moBFMs1l2dfu4oG5LyjQVcMh+yRPZkJDhCtr5MxrMw+MJndB4UOf4ygMWXZSK3E6DAkWM6/TtZNiNUzyBrskxw1IBxuVBtG/3tm6ff2jBdBYv4gneLH6Oumt3fxl2hb2qb8XlF1dy0tYBveMUn//
 utN1wwf+
 OlJ+SFqdHDKYe+44ORPqEGrbfduKm7x2EbgInG5seHUnHwaLvnudpoesQN3q04ZRXvSEKxJnt7heXhPfogLIgXK2cMhxd9FF0a6dfExhV4hM4MYltp66s4g2EvL6P0OnTRJlUHVjhYg6QFyexwdCwObA80BRF766AMcOB9wXKLhrPrRfepW1wAnGngaH/bQZLAFJupvzIZyQF2yR0CRzfvoPQLNG5bND1M4pQzACVniNIDmbzJCPQnLVCSSj/RhCh/GKnk3B639o+Y5QFkXlIHyhEwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON usage document for the newly added age_ms DAMOS core filter
type.  Add an explanation of how the age range for the filter can be
specified by the user.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index cc7465251bb6f..6093b1c8fbfd9 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -559,6 +559,9 @@ For ``probe_hits_wsum`` type, you can specify the minimum and maximum probe
 hits weighted sum value for the filter to ``min`` and ``max`` files,
 respectively.
 
+For ``age_ms`` type, you can specify the minimum and maximum age in
+milliseconds for the filter to ``min`` and ``max`` files, respectively.
+
 For ``memcg`` type, you can specify the memory cgroup of the interest by
 writing the path of the memory cgroup from the cgroups mount point to
 ``memcg_path`` file.  For ``addr`` type, you can specify the start and end
-- 
2.47.3

