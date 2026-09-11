Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC41EC88E41
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 01:14:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 456F26B0098; Thu, 10 Sep 2026 21:13:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E74C6B0099; Thu, 10 Sep 2026 21:13:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2823E6B009B; Thu, 10 Sep 2026 21:13:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D093D6B0098
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 21:13:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2376114068D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:13:44 +0000 (UTC)
X-FDA: 85199709168.09.AA7072F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 864DF1A0003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:13:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fg2mazDx;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789089222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3QelAmhdJ8KPxvwLkmNC9X/53BNSeYX//IkIfked+Kg=;
	b=R9yQXZsy1TEIuKyFyYzuGsUxMESWOAia74pToRzbrSqnpArWC2GxhX5zwXfJGJqTLEMo26
	YZ7aU7JReyVKaT5Z2PJ8gHToRU1c0iCs8zBIWgq5ZmQvHkfYzqbFChpfUbR/5ouVBPFsSm
	bgiYFkvFJGJNQoMYjk+3ptJa7WtbDa8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789089222;
	b=bUHEqGXKOA3WHix3eq/3wN2dK/64hltHWc/+li7NS3g0eT9yxsWRCnNaISHR1c88H5N4pj
	JRKSyX8uq2H9kIsSebocisOlEV04ogXJQL+GadDoTwwCL9Kghh3SURRGFqnCd4ek0PqnHY
	CSpGd4Dj7Jk8jF2LPkg/kjFT0LTkoIM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fg2mazDx;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A97C642A24;
	Fri, 11 Sep 2026 01:13:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071401F0089A;
	Fri, 11 Sep 2026 01:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789089220;
	bh=3QelAmhdJ8KPxvwLkmNC9X/53BNSeYX//IkIfked+Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fg2mazDxtko1NJs5ZAtSFvkDkDiew0FG9K+ghDuUOMhDB9PA2cT/E5CPJJVlhpe0t
	 T1hpw8QkyEnmA78rSVSn0OXR2OOddYyfEbch/4plgRJwff4HWE4fQJEPMk59nNqIjl
	 xn7/ynmGmUGnU/Xszv3mbMax4sFreVELh9Aw/JuCWv1u6M2XP/zv/bmj9NPQg72XgN
	 oUGQe2/u9XngeI0scTHJZ/drVtNoGQ009+TtotaldLT2nMlgmglgz82cNuvOh7sDZ9
	 PSDTR55CI5VtyTXVdQM+gG8D3oTrLDFBw7MyUkK5+2EGovdYfhfhERKayWfzKctf0G
	 xMzozyY05iczw==
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
Subject: [RFC PATCH v2.2 6/7] Docs/mm/damon/design: update for probe_hits_wsum DAMOS core filter
Date: Thu, 10 Sep 2026 18:13:27 -0700
Message-ID: <20260911011330.93678-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911011330.93678-1-sj@kernel.org>
References: <20260911011330.93678-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: k418kmpuik6eiwcde49an7m8mdeohhac
X-Rspamd-Queue-Id: 864DF1A0003
X-HE-Tag: 1789089222-347138
X-HE-Meta: U2FsdGVkX18psE7gh13zGGuvqKuKxityj/cbX6L1ydr+B9b5CgAVlZoFspq+S+Uv0VhZedUfFagNfERM5LcZAtg2Xc4XRXDzleMlqxR+ZnscX7FYC1NScAL1AeIZwsmROfw4pWSgaTqRFnMqi8bJPRdbEZeopF9RWoYZRQQdpLMnVds/DvPQhY5/z1F7+el2xG6F4ny9VNvmL6Kh3DhrOSYaGrUv4L3YB7jz0aXYbWmJTa3RTrom4oPvVdTLrxgqq3MxGxTHdffNdnTChJJ4wMRPk0MRstGQ8LjfEO7axMEFfKk/LokHLbga/YAhWFKtinzLTWbAiu1HyeZe7bNwE1zgNCC1OGIcsNXjemQh5I8VqX/kBt32eI+LIASITdi4hT3UouzfCHnXCqTv422iYIQYih0FuXh2r/8czM1HU7xLRqIgXEg7mP67YMQPETFZDdHxDk9/LhOJdadIUm7Bru55zmUzYJsStJz+/5h9YEdTNXh0WnZDff51dc8lsPK4PJ3p5o2g+kSVE0mFWj1llVD3z69qsBfWUQMvnVQIraMcPyoEAmlzINFsOhEsBUZ2JdqplwEP8nZYNLEKEk9oALmxEhV/ZQ0AWzWM8x9Mezmjba29c8+M8NoSVixTozLhqTrxb2zXEGR5/C9UkSFhvWPSWqUo3LEIuDoupy8wkUSC7/CmNlBc901CJA1opxexs41ZXSMRmFex/nXPkCLXm4uXnuJlyDx+S+oRXO4XOOvbnEgzL0Y4bwO06znZkwig1or/UiddiLoYrmkrtMbxOL47vJnczBUXSCtAHV3NJvcKhOndHvzLlMoMTgmb/DBgxkKtSGlvtiRa5PHQzqsX88z4OAJ9MMEnIGjTQb6ACL51Du0e+/4wDvv5fXs6HRNzZy6K7atHY/0ueCRHUBOVTHqrkS/7aKeGAuUyjwfxvniMGoFwOAYSxfhiD8+Wopo7BIdL1HQk6hsUtGZKiWg
 eYQnXcX6
 8pai3u3wYHNayH5r5n1B0Y7MMtWLgmnTiWxVAb+IITOaV0YAwpyt/O13Iiz06/4foLe0ogMOIrm77qhc+7Kbyxun4a2EOtfpvkc3r7nPM6/3ex/gDdUaDmgIeRw6kgfKuOuEgOctLyICJEJPim+fpcXYToa+Yz/9wnLzp8GD7jXEFL8ObQVvtMWc0eMLSkpS+be9gOrWrKkaAN3PpFE02wva1vkhAxh513rQQyS00i90/RwCq/P+xmdOm3WaP0PVUjjzT/OCF1mZoZytN1dbh2gEfg2JD4NQiKstK
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

