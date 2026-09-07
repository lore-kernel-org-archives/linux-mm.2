Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 053B2C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 17:12:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B8E66B009E; Mon,  7 Sep 2026 13:12:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11B1A6B009F; Mon,  7 Sep 2026 13:12:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB1D06B00A0; Mon,  7 Sep 2026 13:12:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C28F86B009E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:12:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 56FAE14026E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:12:30 +0000 (UTC)
X-FDA: 85187610060.17.2591D8D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id B4AC7140002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:12:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ULOcj1+A;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788801148;
	b=7d0OJho/SB+DJWbRQwwek9MNb6d/pj0TMmXI7aWJdiM2eXweqTtVqlCAM0SH/gMfKNsthP
	0wmieH5dIFW5y1jOIJ/bJWqOFVnn/HIQpIBu987Y2Fv1W3yZ19wyqyLDqIdB0IRF5pr0qf
	tz2jAKYjbcfh2rawy4rPIk6JZjg/SHk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ULOcj1+A;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788801148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3QelAmhdJ8KPxvwLkmNC9X/53BNSeYX//IkIfked+Kg=;
	b=QdWhQNRDRqA7bAm3mREyf71kd2H9ZnOtsEJtesXvQlLAv6C4R20iFNZW3rl1OT0qqzR62D
	3TORAJ8/9fCEgQ/1f7VRMHYped6pC+Tw8Cfc9UboccnwZi7Mva0zHDzSeVLulH73a4TgAJ
	nCsgcK71NA+8D1KJyo97M/St0ETS3yY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EF00443CCB;
	Mon,  7 Sep 2026 17:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547671F00ACF;
	Mon,  7 Sep 2026 17:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788801147;
	bh=3QelAmhdJ8KPxvwLkmNC9X/53BNSeYX//IkIfked+Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ULOcj1+AJUjnPLd17XkSPhcPcHUidVKWGqekiLNjlvxtZ3f+/XbjQoNwssXBu8OzU
	 G3zcFDrA1JQRHS4fK21J8STziU+/+9C+Vqn/1qmxpGe8cM8YtTwrKVz9ayrRyRHkjl
	 W5bCGu2n05qfFsaGOdhPfDz8v7BclHFLLwgr6zoyUPX7W1jedNkN7rgGGpp2FrgwcZ
	 6YgBtAvzZlEEM1BqM8e2trpVuPTOJQbYGvsy0eCm7LoUmMzk+s4iR2LarRMAi/g2mY
	 AYtqHxN6V8Wey793BFm5f+uhDMEEYTm5KIxG4KfdeP3UWnwssw4h6NxG+uBX+WiE05
	 OYGzpEk1N4GhA==
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
Subject: [RFC PATCH v2 6/7] Docs/mm/damon/design: update for probe_hits_wsum DAMOS core filter
Date: Mon,  7 Sep 2026 10:12:15 -0700
Message-ID: <20260907171218.101430-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907171218.101430-1-sj@kernel.org>
References: <20260907171218.101430-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: si438hf8usdicyit1nc494nt5qaaxnza
X-Rspamd-Queue-Id: B4AC7140002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788801148-638206
X-HE-Meta: U2FsdGVkX1//NHk1BGyRc3u72Ai3PFTiHom1HJm4LsLkrFJpPs/MRk5SCYj/+Yp9Zn+RFMdt9zJC9C9mbP9wEXrVGfLPLOgiVyDVy+0IkKiE2GnTb56B98FpbCt+xeVPD89s7+MwremDNNR4XfjeuHycvxlT82RUpbuXSlTeQIXeXzVL1orvpuPE2MkmCz+Jbj5VfbN53bdNVunLlBXNla7U2EQADJSjSf/nMUDBrtZCyc0Gh/LSlvA3kqEEF92JAmjN/B1kkpwBCbzSeTi8joFRwSQQCGeMbmpzgWT2oapHIBGPGnp8+KgUxYQHPo/MTvnK1V/tWAdJsf7CfNQPgArtdCP+UWvesYi8wX3VRUMBKXBUrx1ZmVJLaWTPMT5+EsSa5ZWJUh1O2/x8JXYJcqd2yyLAA2k9TTL/wWRbIju9DX8Sj0leqPmR5IXDOoUdO4/TquLNt5qcaE5MDHaMCGbLVEOmqpCQ1m7vNaptgJLGFNV5PFD7keTiIAiJFRIuHdcF0jWtDtt0ysvNVxaxC+6EMAfAplHuA0t+blXTsmCxSANPFbWWDdXRuHBmB16bHGMVfOFG58xpbtKIqspQeAYB/mRBfsuW/I1o6BWgj/SCdY3gFN6V8mybKe2cZh2D+5HvXgQLwccrcxAOmUeWAmwX7D57u1xvlcGIqbI/TG3sje9EY3nsCQZH9iuAjc7rOMlaWEP+wlrEqtHl03OazuBoEHCtcEpx8H5eIz+GoY/euVhN+Gyu+DoklcEJAqiOzRbDj4AukS7HluYgMxYDVx6Wvf6G8zXQrYLA2+NvWT7RMZMY7Jvz3JwWQzhZvJEiU1A2IDUOAsZqtJ8RXIuXZSacjHNiODJeS6Teop11p0NSv55K5AEtVmIe6NuFtZ230ncdfxXSoMnJZaiFYYi8nBjfAh3Fo0xEWgJLE2z5Y2X9b6Mk3Z9pcJ8sgggLFOX49x+NIOtXxin/R11ZlKe
 f82e4a7v
 utbd1yDG9IVNXPM6DZpuMlkEfdoZY2F+wdgZeCrn+2LM1y8yOmv/D8/Z/O+IPcQgcgj1AqFlPLtZ6HV44ETDdpsDMixAs9vqf1IIdNcsq1iWMnamNSlJQmOtpIS/GhYKwVilmnjadNuw1BludwFP4Efq4lXsC5FfJDmdg1gWYCKVWLqomC8yVfc+laURndkEIW8X1HJ2Nyjw4s5yIGN58FzxN95q15/HMhGN9i5pIgBLDHLyvaSHJsjE7H7GdTuUklAOe+rk+7vsQrcMjS9rOQG4e7t2UIOTWridn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added probe hits weighted sum
based DAMOS core filter type.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index aac84de261aa8..8e980dde362de 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -822,6 +822,9 @@ Below ``type`` of filters are currently supported.
         - Applied to pages that belonging to a given address range.
     - target
         - Applied to pages that belonging to a given DAMON monitoring target.
+    - probe_hits_wsum
+        - Matches to monitoring regions having a given range of :ref:`probe
+          hits weighted sum <damon_design_attrs_only_monitoring>` value.
 - Operations layer handled, supported by only ``paddr`` operations set.
     - anon
         - Applied to pages that containing data that not stored in files.
-- 
2.47.3

