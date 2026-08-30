Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DF63C61DD6
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 00:21:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94FAA6B0092; Sat, 29 Aug 2026 20:21:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9272B6B0095; Sat, 29 Aug 2026 20:21:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 815CB6B0096; Sat, 29 Aug 2026 20:21:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E8FC6B0092
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 20:21:33 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D9121A306B
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:21:32 +0000 (UTC)
X-FDA: 85156032024.14.81FF855
Received: from mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf20.hostedemail.com (Postfix) with ESMTP id E7AA81C0002
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:21:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="cv5J/t3a";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788049291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2xV7/sSOP8gJsxvvOySKe6GHZrDy3lTpXUj+7CugGvQ=;
	b=4zSWtTxXY9uICjNSVJkSBqaZiVv1ujonlsGTCmfeJEEaduvzqTi11dIjZxwODrxrSo9xyT
	iyEtWOmB4GtMFlh0usXmeRqGznsAHYk/5I3mIeI/1JC8A/pKzuxdT+HSTQSRcdboQ0rCbf
	A5IfwaoTvsvnknsdwySu2tqlBtVk0fw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="cv5J/t3a";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788049291;
	b=7jWW7S54grz7Gb3L8Lrz+UwVBSrS3QzGNRF4Lv9x/icQOTHjNsP86YoOTEvFsObfobqJMF
	yZevPFFv7Y9OTke1T8ohcKEuoOXu1omJ8+rDVZNeSpPWY1O1bn7Bf7ewZyuSTtfb7y3O4S
	6z9ZRSqWetQ4QSQNh15HCKKgrf9fzhw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HW0I75C/5UBwwd+jukPw0ARJed7HblTEcNCAI5VbTdI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788049289; v=1; x=1788654089;
 b=cv5J/t3aEBhM4DKLAaOZG4aDJjyvdVlwaVEnSmjLfQx0ZFmRa45LBUDqVbjlbP0DwkvrP81S
 FeQSBC6pO23xN4OYtcPP1Xggo7ZHjbu6LvSoMZubHavDI2ci1/0xGhb/KEdjtYW8Nu61ERUtFDr
 Bu+zv/3Yn6pU/bvtFpJ6H90w=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 485d79aea16e38b9;
	Sun, 30 Aug 2026 00:21:29 +0000
X-Mizu-Trace-ID: 485d79aea16e38b9
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	David Finkel <davidf@vimeo.com>,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-kernel@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v4 RESEND 2/2] mm, memcg: fix memory.peak reset clobbering other fds' watermark
Date: Sun, 30 Aug 2026 08:20:44 +0800
Message-Id: <20260830002044.1938621-3-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260830002044.1938621-1-ridong.chen@linux.dev>
References: <20260830002044.1938621-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qngmswptrm3kophduxcgd7oodc8ntcaa
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E7AA81C0002
X-Rspam-User: 
X-HE-Tag: 1788049290-374034
X-HE-Meta: U2FsdGVkX1/elTjSQPm3EmREDGmRjFmI28VGKlG8jsElkaFM/IFcl17JoQoajArLZEjeK8UxZUO2NzlqZ59GrrMZuxrqQski0J6u/MSKwHGW58Y144Zvoo7sDcFZQvRnP9xwEc6C9S9iDk6cm2YnKpRbRhH6D86gd4mXtZkDnXQ/HZFa3mKe4JtYbT+0IGfcmzU1WjnMP/2u6ggOvOW8IyUxZbd1niIFpv0izrXF13aBBBpS0wivTnf6R2rTeDVV8Y2RjJY2Pju+mJK2aGGGHbdtUgOBVkUWaPsnkY7ocxZOAnFWroRnLHsUEmalxs2CRTYsEafQQhfGGFvB2WyZOnCdx6UcqGz1Cpk1yz81otpyqeT5/WRD/o3CAI96S9xgvunCCkeck2CP901agjXjpWdxZvtETly0xUVJBEApXAQHdKSnz+39lfqO1XLDYkWSQFnps2PJS3vFaHA0ss8KjcLy8hinIUZPoUGa2jBBYdy0KnsRodsgz6V/YjzSpJGuW9qByH2hy/4XYcaOzn3Ah4P2aQ0xBfDOqy/o5ssMMNumeJueUweYqGFYZ+YVnVzZdhPEO1rGgUfTvw9LDTaGySDlNMq8TtfET3mIp3c6yJ43/n7CFcudf321OZeVUvKm7PnUVx8ELT7A2B8f18IpxVCUOUVhYazWnbcn+m4w0k0T0TqnYr3E8o78oREd0W307krg8UzMF4TS8Ui/e66OcpjNERV6+1gndpH/9SZitlnROLpNGbFoEaTTwuDd6k/mB/K8cP5TM7LvspKD2oAJSzy5lGhjPaix0R6Gj0Z1FBMVFWH0OQBsEhd27QLXPTLw9lrTCQxLcHfDnYG0PwoV0Wqy9V5hJRB1GZ6lz5UuNt3/rBg4dbYMOkPUlIX/7kJjyEanUHRC6CeQqqkdT/pWZUvosq2Hs3s+PNewhrCC34hf0Yiro31wajXiWnQTbFeuRXOZd/5kFCEJlq0NwYn
 jmi/fY7L
 9JL4GbXnv4A4mHizE+krEupNKccbSWKesaKN2mlCAJbiIBW1WQHzQWYRkozSqUM1oOBxe74P7OQAw8M7RQ94SLX78Vv2eKN5DiHVes6m335u2icYnMSB32Ingvl6NRDOvOJyRnxzd9r2WdcCo/r89WVEUPTBjNzgDEmmad+KZlCQAwiv1YIMpiatSUZlG7aX1vzGuQEqXHIE5HoYj22vd0SVvWXJhKXWPpTqMpVP5sFt8gXUTTjyNZl0GmOoU8Ql8Gl2HbPHKoGaUGG1YDeCO7WtHsg/n9Yd4SsWIwO+NmJ1moXx4i/Do7TAuleCu1kIGnmZaJZl1rU4FdwDvGilwoZ2DiXBx2nYueIoMxOV/NYL61fgeBaogrAylJg0v2BpBBkVSfhamVh4Rnr11CvxzNGsFFWEFV7/X5YrVCOiwo7ZTs59tvUYYiuS2IZy9T2tGZgX9v0HmJRVbNIh3mKGEUi6tZO+vIkde61VD8dmVaGN9qXDM//q5HHMN9WDCdww5OwQtJ+2YK020MBOjlJb3G2NoTdaUtdUH+pgLn/wkXtQHv8hP/s8r6HGnbpVGPFDRSp3G23NE5nmcYuQTqasoGweDHzMkNkIQZKV5tKqqqBQ92awuxJ+kX6fERBD263p+vuv6JOapbmRIZ+Dm4pZlZ4q8R241iVRasJ2g8m1+hrvvoxA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

Writing to memory.peak resets the peak for that fd only. Each fd is a
watcher and reads back max(its own value, the shared local_watermark).

peak_write() resets by lowering local_watermark to the current usage.
To keep the other watchers' peaks it then walks the watcher list, but it
stores the current usage into them instead of the old watermark. So once
usage has dropped from a peak, a reset on one fd wrongly drags every
other fd's peak down too, even fds that never reset.

Reproduced on 7.2.0-rc5-next under QEMU, two fds A and B on one cgroup:
B sees the peak (410624 KB), usage drops, then A resets -- and B's peak
collapses to 1060 KB although B never reset. With this patch B keeps
reading 410624 KB.

Fix: save the old watermark before lowering it and use that to floor the
other watchers, so a reset only affects the fd that issued it.

Fixes: c6f53ed8f213 ("mm, memcg: cg2 memory{.swap,}.peak write handlers")
Closes: https://sashiko.dev/#/patchset/20260807090000.1532495-1-ridong.chen@linux.dev
Assisted-by: Claude:claude-opus-4-8
Acked-by: Tao Cui <cuitao@kylinos.cn>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/memcontrol.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b84f448fe984..4c02d7de460c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4749,7 +4749,7 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
 			  loff_t off, struct page_counter *pc,
 			  struct list_head *watchers)
 {
-	unsigned long usage;
+	unsigned long usage, old_watermark;
 	struct cgroup_of_peak *peer_ctx;
 	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
 	struct cgroup_of_peak *ofp = of_peak(of);
@@ -4757,11 +4757,12 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
 	spin_lock(&memcg->peaks_lock);
 
 	usage = page_counter_read(pc);
+	old_watermark = READ_ONCE(pc->local_watermark);
 	WRITE_ONCE(pc->local_watermark, usage);
 
 	list_for_each_entry(peer_ctx, watchers, list)
-		if (usage > peer_ctx->value)
-			WRITE_ONCE(peer_ctx->value, usage);
+		if (peer_ctx != ofp && old_watermark > peer_ctx->value)
+			WRITE_ONCE(peer_ctx->value, old_watermark);
 
 	/* initial write, register watcher */
 	if (ofp->value == OFP_PEAK_UNSET)
-- 
2.34.1


