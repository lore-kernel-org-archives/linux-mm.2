Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D50FCAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 10:34:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBDE28E000D; Mon, 22 Sep 2025 06:34:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E94C58E0001; Mon, 22 Sep 2025 06:34:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D84568E000D; Mon, 22 Sep 2025 06:34:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C05528E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:34:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6BE72C05C5
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:34:52 +0000 (UTC)
X-FDA: 83916528024.20.D265010
Received: from fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.132.221])
	by imf21.hostedemail.com (Postfix) with ESMTP id 340A81C0008
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:34:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=XHJH4sgO;
	spf=pass (imf21.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758537290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=53eVwgGixhXV+kpfakHG+WH3ZWofjOecJWw4cVQPdGA=;
	b=RCJ9n1V9R2gAdHFOs1GzEiQAX/5DhkZaN8DFrCTjZzLAP3kPL/xK05ET2vJJNcZabhD/h+
	aG8aAhdrzC61ZoqmMQBqdaxbd1uPqXqNwzN2/BpFbnYa2C3hjg3UyYGUIrsqgL+KPxtUlT
	rzGSdGe00gs+7ySS2JHmn/mVvKcwiek=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=XHJH4sgO;
	spf=pass (imf21.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758537290; a=rsa-sha256;
	cv=none;
	b=PoveP9RtJVx0fWajrkigL8mvoEyoir9Gw1zGUzn3rwgMaaf82xvlMwYlw2eFrlJ5MKyggB
	IOR7rV5UeufDVaQS4IXySNuB9nLEulnCXt+X2XW/6bfiZygcFHCwKM35gDcC+UobhZQpHO
	K7gv3Yq3uaRIAsplGDs1E5KKU3UeZM0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758537290; x=1790073290;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=53eVwgGixhXV+kpfakHG+WH3ZWofjOecJWw4cVQPdGA=;
  b=XHJH4sgObGlBxOkeD4Vx1kzi8WatryZMMfnb/Xca5M1b7nyM1n2Ktkqk
   NtK7y1GhqeFEgaQtpaCfq2Rv35MrrlkE2AORq2RifaRoq1n9gYb89CyHA
   vI4NubbU4ik2855hSyQfIo3sdGLgv7jJWnVQCOFix2fmgPr6v0O6NN1Hb
   RP2wmtqGCQCU43fp4BhBGQLvVnsiJo091mggDAx69i019I37GQCh4TbDB
   omM+5V26UfOhiU0R7zgGy+p1Zd9VNlXtfU5b++TaM+NLsDByWs6WEBAeF
   Z9Lq90BRyVfX6zdEl04mU0OsXYrp3VFkCSZxRWxxjogcVPdbGb9Q5Sbtd
   w==;
X-CSE-ConnectionGUID: 4x3QIX9TTLS21toa+JxppA==
X-CSE-MsgGUID: WjsGUbI6TSO4KI5XODdX/A==
X-IronPort-AV: E=Sophos;i="6.18,284,1751241600"; 
   d="scan'208";a="2371908"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 10:34:38 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:5562]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.47.2:2525] with esmtp (Farcaster)
 id 1d78e8a1-c17b-4606-abb5-a1fefadad1fc; Mon, 22 Sep 2025 10:34:38 +0000 (UTC)
X-Farcaster-Flow-ID: 1d78e8a1-c17b-4606-abb5-a1fefadad1fc
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 22 Sep 2025 10:34:29 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Mon, 22 Sep 2025
 10:34:04 +0000
From: Eliav Farber <farbere@amazon.com>
To: <richard@nod.at>, <anton.ivanov@cambridgegreys.com>,
	<johannes@sipsolutions.net>, <dave.hansen@linux.intel.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>,
	<tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>,
	<mchehab@kernel.org>, <rric@kernel.org>, <harry.wentland@amd.com>,
	<sunpeng.li@amd.com>, <Rodrigo.Siqueira@amd.com>,
	<alexander.deucher@amd.com>, <christian.koenig@amd.com>,
	<Xinhui.Pan@amd.com>, <airlied@gmail.com>, <daniel@ffwll.ch>,
	<evan.quan@amd.com>, <maarten.lankhorst@linux.intel.com>,
	<mripard@kernel.org>, <tzimmermann@suse.de>, <jdelvare@suse.com>,
	<linux@roeck-us.net>, <linus.walleij@linaro.org>,
	<dmitry.torokhov@gmail.com>, <wens@csie.org>, <jernej.skrabec@gmail.com>,
	<samuel@sholland.org>, <agk@redhat.com>, <snitzer@kernel.org>,
	<dm-devel@lists.linux.dev>, <mailhol.vincent@wanadoo.fr>,
	<wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>,
	<mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@linaro.org>,
	<malattia@linux.it>, <hdegoede@redhat.com>, <ilpo.jarvinen@linux.intel.com>,
	<markgross@kernel.org>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>,
	<gregkh@linuxfoundation.org>, <clm@fb.com>, <josef@toxicpanda.com>,
	<dsterba@suse.com>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>,
	<mhiramat@kernel.org>, <pmladek@suse.com>,
	<andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
	<senozhatsky@chromium.org>, <minchan@kernel.org>,
	<akpm@linux-foundation.org>, <dsahern@kernel.org>, <shuah@kernel.org>,
	<keescook@chromium.org>, <wad@chromium.org>, <farbere@amazon.com>,
	<David.Laight@ACULAB.COM>, <arnd@kernel.org>, <linux-um@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>,
	<amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	<linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-sunxi@lists.linux.dev>,
	<linux-media@vger.kernel.org>, <linux-can@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
	<platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>,
	<linux-sparse@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>,
	<bpf@vger.kernel.org>, <stable@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, David Laight
	<David.Laight@aculab.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 03/15 6.6.y] minmax: add a few more MIN_T/MAX_T users
Date: Mon, 22 Sep 2025 10:32:29 +0000
Message-ID: <20250922103241.16213-4-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250922103241.16213-1-farbere@amazon.com>
References: <20250922103241.16213-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D039UWB002.ant.amazon.com (10.13.138.79) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Queue-Id: 340A81C0008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: gc16557trezoorujxtotdwb4erb4deu3
X-HE-Tag: 1758537289-657759
X-HE-Meta: U2FsdGVkX1+IH2e8GvDu23obdG8z680eE3lowcVYJfifDyd90+gh8C9/PrkOlmUOyN3MPJI1dCQS5iQf7Q/ZKwlMvW7T0KBpUsSnL2BA5gTShMfFqNuw1eT8QhXsJj1prqN0Qe1YgqP0U3qBd5xPesLc5vv5LOyUXXHmByKc86R8ZiJx2ShnRlURsXEthIQHYwH3sMfP6A/wQBFy2exGzY1CuLnJ4uNTFL636+hB6wz4/RNY8rssAX0DeBB715p1ggenqIcsuwVmvRmmYtPcLOUZSL57YaSq1DabE7MWV6YKtWzDSSs+akK1Xs1Z9g0ivit6UYT+gGHawwFMUT2D1AMBR8OV0gmu4c1aaRkXh7/of5rC6vnMnq8yAeIYAZHrs0n89VkeGazLFDHDazNU8mNRkED8xR6rbtjhzoXMQmU8MTIfupvZs9vp50mwMOz0nZfGmlpaCVavfP1BDeRWuzIcAfeD0vLOs6h5kQgop6+Y0JJzWbnxC7YgpMdidu6wMTkzcWJVl94LZ8fBP5Y/rD14EsQ5F8qPZcnoS4OBIcw0c9GdJtwy/IfLORmZ/8lKkbZGyglU5aYOuLX+IAP55NGwwCnIurB4anRjrUvgCdu0nRB2eIhe5daiyNNMo2Gv4UufpteUtdteewdNaxyEwBR9sBoyIUH1CZKOoZFJh3+edoI5vvjj81i53lVg1GgbqyfVxdSVrbVP9celtoLtGavkOX2nXQpgpiYUNWqIS/gF86hDAFw1qBWYCQNp6lyyOaYGG/Tx4wXZ+SK9AHH9Yqb8xroJWBR5NjE/rZQDZ1xSa01dBtcrcEhHKgS021R5bslQHGwKLTny6BzVShQX6Gqi77PysUcT5IQoLt61K90dHqzYFWNGAB10sSOJIfaldaF/4TQKdpKQHdBksF48opB9U9gYKSgmSkxUp8SEd/VirdesqVfgfB53LJKYHnY9NkFBWA3SoTg9sG2WHp+
 boQHne08
 dUMXks8iGwkX2nEKsq2iH1yBzlTyp/JAXudAPf6uZuQz0z2Chg3R9RFYe7ckV2NaZNJXe98Dh5Epxn9q36bXkw4NUaSSmZRWg4FztkWAjf8V4sDanrFXl0MPawWwWlSuNhety+/AzSzXplmkN4xyTHRFhdCMItZP74kW7S9xdKkj1qvwPbnhcegm4ErY1uHkN851ceoWE71OPt2TJFMLVZxNHgAFDMA9cSKRalzY3720nGAp9Bib6qvsiSFyyiLVH4BdSBBwvf2dOo6ZLI/OnFddTvGGgkIwv0tfmZDoHU4bQhk0FQlRjLwTwa3YzhAil1Q/NrVlHqQZM0BrIzRYyN6HarC9/BXFR5RO8eLFWPbllg4zi+mRYb2Krz8ui5e7RTIwu2QONte8GY3PMlkPtrrUKdE2n9CWdtidV1SrjX30XKT8wUGqJziXapOrZij4RA0Jn1SGIxvgDrAI15m8Kk58Eqyvd9HFdAhKTL4MY+MKOae8RUvwQamNdoprHKDTMORQ97Qc91cMHaycVXopEmrUXsKb1XbZB+SwsqbIgzKcvG2aJLWANHJQSp+o4FAIeVTUDe4DfTHJDLgziL1X2X9o3UxKnMCkd6u9CUFXDMKAY6H6IXuCIDptJRpuZss6MlXZ4GcMeogSmlPJBiCb8syxnCRv/EcL+IoxQVMRo8OSiIRR4lgqi7paflAuCcruhIj1hqHF/r8nr/hEwm2a9TW/gBK9Bjr7pBHLTxPLcxb+mvRwomdfelab4/FTnBbQQwRplO+VUlYW5yGmlHBneB54erg1j9Fd1rWlS21qx6wKNZ/JT6Tf+ogYx3KCvOdcCGrdUsUnEYQcAqmQIxjOt0bk28no0sR9CAz087+nBGS6Qwl2kbc0upXSHZkEbXtK0AXS2e+GGDeq0HbtFD6V2+j9btkZJQnvD6/ZHq84JHTFMLDYOzXyDuy9xbyASvuGhiSoQ5OZBDwoJhA0CEUS2inCWRi7C
 EHx2uTzT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 4477b39c32fdc03363affef4b11d48391e6dc9ff ]

Commit 3a7e02c040b1 ("minmax: avoid overly complicated constant
expressions in VM code") added the simpler MIN_T/MAX_T macros in order
to avoid some excessive expansion from the rather complicated regular
min/max macros.

The complexity of those macros stems from two issues:

 (a) trying to use them in situations that require a C constant
     expression (in static initializers and for array sizes)

 (b) the type sanity checking

and MIN_T/MAX_T avoids both of these issues.

Now, in the whole (long) discussion about all this, it was pointed out
that the whole type sanity checking is entirely unnecessary for
min_t/max_t which get a fixed type that the comparison is done in.

But that still leaves min_t/max_t unnecessarily complicated due to
worries about the C constant expression case.

However, it turns out that there really aren't very many cases that use
min_t/max_t for this, and we can just force-convert those.

This does exactly that.

Which in turn will then allow for much simpler implementations of
min_t()/max_t().  All the usual "macros in all upper case will evaluate
the arguments multiple times" rules apply.

We should do all the same things for the regular min/max() vs MIN/MAX()
cases, but that has the added complexity of various drivers defining
their own local versions of MIN/MAX, so that needs another level of
fixes first.

Link: https://lore.kernel.org/all/b47fad1d0cf8449886ad148f8c013dae@AcuMS.aculab.com/
Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 arch/x86/mm/pgtable.c                             | 2 +-
 drivers/edac/sb_edac.c                            | 4 ++--
 drivers/gpu/drm/drm_color_mgmt.c                  | 2 +-
 drivers/md/dm-integrity.c                         | 6 +++---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 net/ipv4/proc.c                                   | 2 +-
 net/ipv6/proc.c                                   | 2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index b18f5a71e679..98aa303ad054 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -107,7 +107,7 @@ static inline void pgd_list_del(pgd_t *pgd)
 #define UNSHARED_PTRS_PER_PGD				\
 	(SHARED_KERNEL_PMD ? KERNEL_PGD_BOUNDARY : PTRS_PER_PGD)
 #define MAX_UNSHARED_PTRS_PER_PGD			\
-	max_t(size_t, KERNEL_PGD_BOUNDARY, PTRS_PER_PGD)
+	MAX_T(size_t, KERNEL_PGD_BOUNDARY, PTRS_PER_PGD)
 
 
 static void pgd_set_mm(pgd_t *pgd, struct mm_struct *mm)
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 0c779a0326b6..6c3a40e6f4c6 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -109,8 +109,8 @@ static const u32 knl_interleave_list[] = {
 	0x104, 0x10c, 0x114, 0x11c,   /* 20-23 */
 };
 #define MAX_INTERLEAVE							\
-	(max_t(unsigned int, ARRAY_SIZE(sbridge_interleave_list),	\
-	       max_t(unsigned int, ARRAY_SIZE(ibridge_interleave_list),	\
+	(MAX_T(unsigned int, ARRAY_SIZE(sbridge_interleave_list),	\
+	       MAX_T(unsigned int, ARRAY_SIZE(ibridge_interleave_list),	\
 		     ARRAY_SIZE(knl_interleave_list))))
 
 struct interleave_pkg {
diff --git a/drivers/gpu/drm/drm_color_mgmt.c b/drivers/gpu/drm/drm_color_mgmt.c
index d021497841b8..3969dc548cff 100644
--- a/drivers/gpu/drm/drm_color_mgmt.c
+++ b/drivers/gpu/drm/drm_color_mgmt.c
@@ -532,7 +532,7 @@ int drm_plane_create_color_properties(struct drm_plane *plane,
 {
 	struct drm_device *dev = plane->dev;
 	struct drm_property *prop;
-	struct drm_prop_enum_list enum_list[max_t(int, DRM_COLOR_ENCODING_MAX,
+	struct drm_prop_enum_list enum_list[MAX_T(int, DRM_COLOR_ENCODING_MAX,
 						       DRM_COLOR_RANGE_MAX)];
 	int i, len;
 
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 1e27a5bce2d9..0bd76f8d4dc6 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1794,7 +1794,7 @@ static void integrity_metadata(struct work_struct *w)
 		struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
 		char *checksums;
 		unsigned int extra_space = unlikely(digest_size > ic->tag_size) ? digest_size - ic->tag_size : 0;
-		char checksums_onstack[max_t(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
+		char checksums_onstack[MAX_T(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 		sector_t sector;
 		unsigned int sectors_to_process;
 
@@ -2073,7 +2073,7 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
 				} while (++s < ic->sectors_per_block);
 #ifdef INTERNAL_VERIFY
 				if (ic->internal_hash) {
-					char checksums_onstack[max_t(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
+					char checksums_onstack[MAX_T(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 
 					integrity_sector_checksum(ic, logical_sector, mem + bv.bv_offset, checksums_onstack);
 					if (unlikely(memcmp(checksums_onstack, journal_entry_tag(ic, je), ic->tag_size))) {
@@ -2638,7 +2638,7 @@ static void do_journal_write(struct dm_integrity_c *ic, unsigned int write_start
 				    unlikely(from_replay) &&
 #endif
 				    ic->internal_hash) {
-					char test_tag[max_t(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
+					char test_tag[MAX_T(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 
 					integrity_sector_checksum(ic, sec + ((l - j) << ic->sb->log2_sectors_per_block),
 								  (char *)access_journal_data(ic, i, l), test_tag);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index ff5389a8efc3..f3155d69a013 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2841,7 +2841,7 @@ static void stmmac_dma_interrupt(struct stmmac_priv *priv)
 	u32 channels_to_check = tx_channel_count > rx_channel_count ?
 				tx_channel_count : rx_channel_count;
 	u32 chan;
-	int status[max_t(u32, MTL_MAX_TX_QUEUES, MTL_MAX_RX_QUEUES)];
+	int status[MAX_T(u32, MTL_MAX_TX_QUEUES, MTL_MAX_RX_QUEUES)];
 
 	/* Make sure we never check beyond our status buffer. */
 	if (WARN_ON_ONCE(channels_to_check > ARRAY_SIZE(status)))
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index a85b0aba3646..b444767b15a5 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -43,7 +43,7 @@
 #include <net/sock.h>
 #include <net/raw.h>
 
-#define TCPUDP_MIB_MAX max_t(u32, UDP_MIB_MAX, TCP_MIB_MAX)
+#define TCPUDP_MIB_MAX MAX_T(u32, UDP_MIB_MAX, TCP_MIB_MAX)
 
 /*
  *	Report socket allocation statistics [mea@utu.fi]
diff --git a/net/ipv6/proc.c b/net/ipv6/proc.c
index 6d1d9221649d..752327b10dde 100644
--- a/net/ipv6/proc.c
+++ b/net/ipv6/proc.c
@@ -27,7 +27,7 @@
 #include <net/ipv6.h>
 
 #define MAX4(a, b, c, d) \
-	max_t(u32, max_t(u32, a, b), max_t(u32, c, d))
+	MAX_T(u32, MAX_T(u32, a, b), MAX_T(u32, c, d))
 #define SNMP_MIB_MAX MAX4(UDP_MIB_MAX, TCP_MIB_MAX, \
 			IPSTATS_MIB_MAX, ICMP_MIB_MAX)
 
-- 
2.47.3


