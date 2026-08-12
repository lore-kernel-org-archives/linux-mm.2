Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6462C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D307E6B00FF; Wed, 12 Aug 2026 06:05:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D07E76B0100; Wed, 12 Aug 2026 06:05:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1D456B0101; Wed, 12 Aug 2026 06:05:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 973566B00FF
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:05:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 273CF160180
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:05:01 +0000 (UTC)
X-FDA: 85092184002.04.1F87BE5
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5C662C0008
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:04:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AnWlt6Ml;
	spf=pass (imf28.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786529099;
	b=7RR4D86OrSI+x1I1q1x28s1o4LAWHKJvVD6/eIwddhtA+R9MTUellUrqcA4/KG0iJ+NmQC
	CBZc69fM6nYksR4cCIAxfu4jO6GISa3krt1xdSMD/IWIc2IUWE5of16JpoIFTo2AoxhC+r
	AWx6iPfBDDFD+x196x0WOpXMQy730ME=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AnWlt6Ml;
	spf=pass (imf28.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786529099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5rY136w+JpL/ylEjfYfCsqSvAnSrsJPi+k0wPlzk9EU=;
	b=SmPJIbCnUhAb3gUSzZF9xKBv8eLofs1ZIDd4GREq08Am5BWQUtn+XCFnuXxOHHHjRZdvvj
	Wu97csG6/XEnbgc9TnBAtQNsfhf62mx6lJl7nDRV9SCiCuwTZYuQeIPqBW6J6rBv8TGXCn
	74rCPlpSueZi0otgnsxFP5X6O0Emcz8=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38e08baf860so922036a91.2
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 03:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786529098; x=1787133898; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5rY136w+JpL/ylEjfYfCsqSvAnSrsJPi+k0wPlzk9EU=;
        b=AnWlt6Ml66M6v/ELPrf9yu7m3Jbazhy1g1bybblnqdvSBvyTETuPMKcWefyuXdvCxp
         2o9IhB0rtgfv+nJzAKnGLrBQXsxk0ZGvx5/tNRkKAox6Jgc/et8Vnbg2arHaeYSpWWgH
         ltLNJ85sMDbF9WWbq2KUowZ9xm7xRLnZy1kV9OGiLvOmTRlA9qTES6ZmRpw63WoVX4SO
         9rizrWeFfQqqzhAvQR4Yr7ybvx68XS5kby5MxP3Qmotij8TdgvuZ09f89w7XvPRgPyaT
         CE81Uf0LpztStTrMQLFxJZ5PRbf62/uPhBg7sUnip6Rp23b9Aypsxaen0LlsniER9ste
         1Ahw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786529098; x=1787133898;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5rY136w+JpL/ylEjfYfCsqSvAnSrsJPi+k0wPlzk9EU=;
        b=W9iPRmo8bnN1BfNXCagsxKwD4hTzakmP8Bk1u4YF29lYRjfgo2jzkhJ/kpLCnpnARj
         yFPLJg4FUQENBsmTLqzMDcy0qzendIQ+DVoWeXQ/0tHZByXGlrA+gLubHIz4Ye++UNQ1
         Ln+/AD71d7SKSWKnnI3MTm0DkLoJ2ToMt/zFRMoFRqXW2mCj0pRjmOiIw7hbBa4lDyH+
         ng5NmMR/n1pUyfFFqVD68Iz6ASUALUgmygvauL9fsWTFbv6JOJlsNjZM3ez1jiLDo9HQ
         uVhT77sCvk7g0kJMrV0IrEYnS7XlqM7rdANuPR7p92sTiQ0AZp/dJEl8KjTmjGsVpV1s
         xiwA==
X-Forwarded-Encrypted: i=1; AHgh+RpB3kU94GroXGNA/6o5rRCym2YqrYq2gN6g2bjcCuJbCBUufMykW+k0i7ilXgVx1ij8HaLtvhq+Fg==@kvack.org
X-Gm-Message-State: AOJu0YzY8jHpgw9JmYiSK4aIwFmQeUxHG6hI3CMmqzolrWWAcFrND9GO
	TGTqs15cufqpeaoVEt+Z7bEr4r09LOv59slB3dElMuFMUBN69o5xWN7H
X-Gm-Gg: AR+sD13Uss9s97H2rp0zknWysWcVqC2L+Kg7sGgDMhD8QcAbtpB3LyJc5UZK/FGG4TD
	y2nj5tFYXy5HaKmari5WW9qnmESSGdTwP8JUdSPwIVC0ueNDKmM4nvt08hk7TaGbMGp84dduaZj
	5Sv22Jqx14atOsM7FIoFWX1ZuBY/xDuJibfJKei2mSM+irAMC/TaNLwMJtV89CxYUKbuwsi40kw
	E2kWpQcE5OT5rp77vxpoV0rfdkt4W0tNrNTG/EKVBhQ9cNfcxmkLKcqBa2dLhtmqggbDzb2QZxY
	GkqOrp87NMTwW828lFyluUpsNRAVggWq+D9SC7Fhb6Eg+GQlI1j3PgjhFJQHQZQ0/MzqhsV/JFz
	mmnrqIPC09eF+FBSiw+/6f4PpTLqIXB7NQUDap2zT7kjHftH+1e/tprKPfYFbnP4Dkt8Nrgxf+k
	tiQmvM+r33rgktEeH+dWlufLwocKczeN9giq/3S1Pqh9kRVZgB2y1erBXJGYEXdxxVF2MpY0cLL
	GhDGa1Xsm2gtiQ=
X-Received: by 2002:a17:90b:1a8b:b0:38e:fea2:df53 with SMTP id 98e67ed59e1d1-39301253b3bmr3943475a91.4.1786529098246;
        Wed, 12 Aug 2026 03:04:58 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:85a:5c46:85a5:ec7:8aa8:72be])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14124454d3csm8821247c88.2.2026.08.12.03.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 03:04:57 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH 3/3] docs/mm/damon/design: fix typo of max_nr_snapshots
Date: Wed, 12 Aug 2026 18:04:33 +0800
Message-ID: <20260812100433.6288-4-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812100433.6288-1-aethernet65535@gmail.com>
References: <20260812100433.6288-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5C662C0008
X-Rspam-User: 
X-Stat-Signature: j556fggaphjweff6sx55w5zxg1bbhnec
X-Rspamd-Server: rspam06
X-HE-Tag: 1786529099-493855
X-HE-Meta: U2FsdGVkX185LjKIBJBPiqvh2wrFZi4Vk0sEitZ5zA+2NsUD+s+Aef0U9JzbIhmWECyuKbmJXffCrpSUUgs47FmxDFT3yoCw20O8mItMZBO6GkUwlI1IJN1vu+fmZpIIKkx3Fnwyn18gyk0ciDvMljvBUWndXaGVCl3PlfXlu4NmTf+HEyWv2RtWKRpKSN2H51Fg8ErvfuPX5oi81J1GJXEkjj6xjTLLpQKO4t3rOgJns2cvnNhZ1MGjQI6jPSa5ImL7OIvLdy82g/h2y9FMtEgek+JQR/VkGAj023zD4e2UShJeqbre9DIueoGzjY4afoq2jlA+brr4NlSVyeJ9x5VKE8v0LzLPsux2xWO+NLp10A6vyfinKw2ILV/lcxdeoyvrnkA5O/k6GL8478QotI7mQ8wP48I3DZdH3G5KRDUSOb9B2lf5IxCEZOaMuVbxF4f0SdvKbD+Xzj+rkrzT9SSihfioJoacs9lH0Pt4yfE4f0yPmnuXRd58e18Jzfhq4ug7aUJp0D9Y7NHtJ6U+GpWgn1tfd5HheEJAQOpsMPu0KiCgFiFcpCIr9sC83ElXXLfoZOs/Sfhti65SXVEFpl7yxbDVh8WNtPqYkgnHgpLIciBVvLju7rozZjVBWU/K/inVOJvxKxYUZrP7yP0TcvnA2QDjmiMpLdZacsdg3bQTTSKkVVox3IS1YyUi6epoURCqG3sB7+wAE1QsebcAnEqcZViiYlOCNHghOU1bqV9CFPLoWreA4HvcthMKymFCY5fHN53wzWZJg+o8fbGdv81M4v7NdmgAf9B+ZEtZtUa97lbGdNfTsTV8ybLCIxXtzYZBH9eOJ49h0NDxpAzbyimdPlcBI4uujrJf7xEimvQiBaAjAch8mPvjCqvEFa0RE3PXu/s09DLAsCBd4C6gW2sG3CMpBnfPVa62gQUAhC7ODa7M9AJ0HNSzF2My6a1CZCcRNx+KZUAhYceGtIs
 NRUCSHH1
 ajFv5RXjhR0oYaJv7Y8M02RQIOtxmfonyO6hOPOBgSMYXWJUMak2zC1dEC1uSG6Qzk5J2NF59cTEphfcDw5UI5nrOl2Ll8r6SzWMkgLIn83zyhBCLUKelpdaSOEExBgD0P0TyQlWtRsKqkRczUlIG0hFQbHVGM6jFtn8SgZvTO0RUmA3EoMTOMMfO097kjJOzUst8FKlKuxeXrTCiKii8zLJ80fHtIcM+xfYZtsuzsak4mm07Oj9p/4UdxgH3Aqa5kDEncHZaaj0yhWQ2/28f2vAKYg7Nh7f5k4f0CreJO51fBtwjsXy/sD8nATAOPPBffAObeO8BUQ2DFLkqgD9tfI1HdUSLhz/Zzykp+Bz1Uor27AfawlP+OoR7M95jw5CIF60uIspEc4L6J/9C+2c1wwrqKlqApYTOBkRzPwT9q+KMBojJVc7HubgkcKTwkGhBQ7PihB3BH00nIislAmUfM+7cH2KDgCazmWXBGNHzWM5RoeQ10EdmBQRTBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fixes a typo (nr_snapshots -> max_nr_snapshots) and corrects a grammar
error.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 4 ++--
 include/linux/damon.h             | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 1fcf0b8c044b..62ba6cc2e999 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -871,8 +871,8 @@ action is ``pageout`` while all pages of the region are unreclaimable, applying
 the action to the region will fail.
 
 Unlike normal stats, ``max_nr_snapshots`` is set by users.  If it is set as
-non-zero and ``nr_snapshots`` be same to or greater than ``nr_snapshots``, the
-scheme is deactivated. Note that, unlike watermarks, even if a scheme's
+non-zero and ``nr_snapshots`` equals or is greater than ``max_nr_snapshots``,
+the scheme is deactivated. Note that, unlike watermarks, even if a scheme's
 ``nr_snapshots`` reaches ``max_nr_snapshots``, monitoring will not stop.
 
 To know how user-space can read the stats via :ref:`DAMON sysfs interface
diff --git a/include/linux/damon.h b/include/linux/damon.h
index d642ce4fc83c..75ece3d03be2 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -549,7 +549,7 @@ struct damos_migrate_dests {
  *
  * After applying the &action to each region, &stat is updated.
  *
- * If &max_nr_snapshots is set as non-zero and &stat.nr_snapshots be same to or
+ * If &max_nr_snapshots is set as non-zero and &stat.nr_snapshots equals or is
  * greater than it, the scheme is deactivated.
  */
 struct damos {
-- 
2.55.0


