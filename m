Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B384A606EE91
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 20:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c8GiealS
Received: by kanga.kvack.org (Postfix)
	id 3E2D06B05B2; Sat,  7 Nov 2026 15:10:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3067B6B05B6; Sat,  7 Nov 2026 15:10:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A6EB6B05B4; Sat,  7 Nov 2026 15:10:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2DAA6B05B3
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 15:10:13 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 672B7A7FB5
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:10:13 +0000 (UTC)
X-FDA: 85409414706.21.E29453A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id CAF3FC0003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:10:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c8GiealS;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794082211;
	b=KobKca9x4s3OpAk6Q8DqR+VLrS4OMGKcht6OkLLqh4yggwBBiQ+7mzlYoHuAzmmy3N/SE/
	zba3zuaO76Gpv6CjcQGzqGT45G0Nsv88maRI4t8sBxfCix3t1uLnUk1PoyP0srszT4xTX8
	fuW8HNLskFjQ1nqZxfUv5PZJ+KPsye8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c8GiealS;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794082211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oUgpNIq5y7P8hrOoDRzoRBlVsghumVDo96fytymZU4o=;
	b=xctisvf3I2lJa8ZjLgf1mN6mxPJRoHgP8RXdkjQCagLfo/c8f/KQSTdLFNVEiBaNDaJomG
	+iGio3gbZGC14JUEMfhf9ekzWRu+UolHJbiAGlMtQGFzINHzn2+WS5RS0qnij76qci6Dz3
	ZZsKVKCICLJ5FFaX3voxbUQmTh3DO4s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 71D8C611B1;
	Sat,  7 Nov 2026 20:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC091F008A7;
	Sat,  7 Nov 2026 20:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794082211;
	bh=oUgpNIq5y7P8hrOoDRzoRBlVsghumVDo96fytymZU4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c8GiealSX7kI27Hkj91eti8JBokuozsH9hmLJ2W+cHpUKvghW7FhbRPdGgKqdIImM
	 5MVOfYeYluV3UkNGpqzbB90EiRcgKcT25oJrfVu7Pu+tQu6qn/vK01Fg53jesd9FCI
	 4/5h0ACmiirgOTFGbgzFUfD8Oe/TGZ6H9bnCD8BV+IibAKWyUpNQghLscLvQp1MRQE
	 8tXNithdLu9suG7QjyiOLWuDZy6+NHUUd1c/qLRJnbAvNYszj+dW0JUfdV8YwAmb9o
	 uOjd+lD+sdGF5J3wCQYXfSzn4/4v58IVs9sBUhzFm+l8AQLVgePEKHvp3HufUPsy2A
	 35BW5Dp2u7rEA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6.18.y 4/5] mm/damon/core: remove unreachable damos charge_{target,addr}_from
Date: Sat,  7 Nov 2026 12:10:00 -0800
Message-ID: <20261107201001.206120-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261107201001.206120-1-sj@kernel.org>
References: <20261107201001.206120-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CAF3FC0003
X-Stat-Signature: cwrttaq6131my1x86enyuw6s9gp6an8g
X-Rspam-User: 
X-HE-Tag: 1794082211-814187
X-HE-Meta: U2FsdGVkX1/duvOYEgKetWjTKGFP7R8YG0IxdQf/B6xHd6DCGy84QVTUunfWfr71BlxxDv4+M9FtL2f0UqQMVkC35vqUEv8nqFpWg6AY1gPLExVrRCzMy558lNSerscNew7vJGi5HAKDnvvHnDpNOP0SxB54qqpk6lgGwewIpmnkPrTHxJ4jD+hsV0GXM8IfhhEcOx/+WQM5AO+hc79nNpN0cKCr53X8XhQAbhR9ExUmAoV1eHpeXZYyKadbJsDb4TbUzbHZ4sF1xjrviRUZOGjMncJz1Zx1wIimW45AM5FQRXcHDyclsXUnJwdGlJiGv4bxOdEkdoig+o4ffDEiy/Rz4IUUEK30M7FuzW/HmbJVn+leC23IeKIfhE+ApEppywTeKvjGM1i58o+KRSvlFJnYhmf0+FEDGhctxVyTtMMlR33/c6kbjoW8utKxb35Jp0qun4qGWAVF0Bx2bz8+5VIMJW2Q2MVS+pi071WXXXht0Yg6xaj1I+ta4sqMaQ2zIVxJjWD0bXBxWVPtIpbhrNhJz7YU89OAj+j2uxH6QPDZFKg6KmN6uMe77KkY35QsngTP9qUkvMYOPVGikyt4ZjdDR7kwk4ZVKNm9eKGyXw5oVLzA+1cLp20IvtpnrUb7yCjijk0X4SySP6B7WDnJ0P3bObabJD2iZv/IvUPYcJvUkOMRtcSMcGXHFRKt3MawmTd31MdP18bnH6EN1VG8zUOmzWlvE8byowutEHgLfCZ65qMBLVkTLxvExGUQwBhxco8nFuaqwlBe/wNYbIh92gdbtCD1yYTXPfLqmk4YIzy/tSAAf/VLtEGn8EslllubLKn7zjeTQrJesKsY40jq60S+AOwX/BjMjbNBIIGf5fOrB7luzc15FEbQXtK6Fs6M5wtRTWcXriQQNsn2tBWoRTmm8sHn0r5fm8KPnIp9K37dQsGfLQfSZ3CNlkOw4w8Xb23uM1VeUam65gjbxJx
 4x1hZ4tC
 fZd9S3W8LFadFgFTpCNVu3OZzL3Z/Z4hg4Jo8jTn8gspvxDPY9cFWDCLpKpK5hqZa2QdyBrthHhlamcGYMCwbFAhEC04/88ebcP1Lg490KvraTK8fsocFksHxl8eGRpvJYqtsIZVmTnoMOQUzK+gS8yjAXVPfWQviGr06j19lMMen36Nb0aCHoUd5ZHKVlxU/wVq3XvOhAjPoi/EilI/KhXTpuiMzMqVBCufy/h9VQsd69ajh1JIhVMGpq1sI0+U5+BAXgIBPsIBwruxpO/u4kLs9T578Vm301fBcdzycS3z/3irSa5s0vGeo6NEuDOY1miEYi5cbBa60vgDt7DzC+4FeF6RLQcGvHWA9bZY3SCNMEzT1rGtiA2o6Lo2YWtvFMhMmj6Iq/smJv7XOKathg9fHsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damos_quota->charge_{target,addr}_from saves the target and region the
scheme's quota limit is reached.  damos_skip_charged_region() skips the
target and regions before the point.  The target that was assigned to
charge_target_from could be dynamically removed from the context by the
runtime parameters update (aka commit) feature.  In this case,
damos_skip_charged_region() cannot find if the point is passed or not,
so the scheme is effectively disabled.

Similarly, the user could also remove all the regions of the target
using the runtime parameters update feature.  It would be uncommon to do
that, but it is a supported feature.  Because the skip pointer detection
logic (damos_skip_charged_region()) works for each region of targets,
this result in the logic is entirely skipped and the scheme is
effectively disabled again.

The user impact is that the DAMOS scheme could suddenly stop working
under certain uses of the runtime parameters update feature.  It could
surprise users. No crash or leak happens though.  Users could also
simply work around by re-installing the scheme.

Catch the corner cases in damos_adjust_quota() and reset the pointers.

Link: https://lore.kernel.org/20261020023958.108276-1-sj@kernel.org
Fixes: da87878010e5 ("mm/damon/sysfs: support online inputs update")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://sashiko.dev/#/bug/linux-cd0c55fc-0cc8-45d8-9637-3334811c49b8
Cc: <stable@vger.kernel.org> # 5.19.x
(cherry picked from commit 5695abc4e742b947f586bfb6a080a80ad9957e5d)
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index f2666770b5436..00cd0e2a1e341 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2261,6 +2261,26 @@ static void damos_trace_esz(struct damon_ctx *c, struct damos *s,
 	trace_damos_esz(cidx, sidx, quota->esz);
 }
 
+static void damos_fix_stale_charge_pointers(struct damon_ctx *c,
+		struct damos *s)
+{
+	struct damos_quota *quota;
+	struct damon_target *t;
+
+	quota = &s->quota;
+	if (!quota->charge_target_from)
+		return;
+	damon_for_each_target(t, c) {
+		if (t == quota->charge_target_from) {
+			if (damon_nr_regions(t) > 0)
+				return;
+			break;
+		}
+	}
+	quota->charge_target_from = NULL;
+	quota->charge_addr_from = 0;
+}
+
 static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 {
 	struct damos_quota *quota = &s->quota;
@@ -2297,6 +2317,8 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 			damos_trace_esz(c, s, quota);
 	}
 
+	damos_fix_stale_charge_pointers(c, s);
+
 	if (!c->ops.get_scheme_score)
 		return;
 
-- 
2.47.3

