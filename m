Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73532606A323
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 03:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=bwdlVs0V
Received: by kanga.kvack.org (Postfix)
	id 4A9F06B05B8; Thu, 26 Nov 2026 22:17:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45A9C6B05B9; Thu, 26 Nov 2026 22:17:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3706C6B05BA; Thu, 26 Nov 2026 22:17:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 15EBD6B05B8
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 22:17:08 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9988C1601B4
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 03:17:07 +0000 (UTC)
X-FDA: 85479437694.17.F3EA80A
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf11.hostedemail.com (Postfix) with ESMTP id D0A2E40007
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 03:17:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=bwdlVs0V;
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795749426;
	b=tbuIB2CZIlJ+zOUReAnrgYEkDVURDgHkWJtjCx+GZtNaYagG+T349I/vACYJ0nDKp/xdtK
	i+Sk9mnlOoHWbszLzSFhp+9DBin+FgBodIqB0MVTnXqK0uZwVud2ytQh+638j6ge9cUQTA
	3ihoyr9r2uHqAT9fjL5w4Ozm+5xG900=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795749426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zYwGFrVXRtVQNbh2j9jq0UMXN8rATCr949DIEhCXwno=;
	b=gAtISEXPFg51jMnh1KB/3iA1BDIdEYXp9I/6GB+hgXGyWN69G5UCG4f5nRa/lI0Ddyww8p
	BkYVVRqhi38rUYCGf5PB9Hn6gUEiVh/aWL8uGFEvyKuG0Lhi7v4IE0UgWaoFOe+BZ7erZr
	x+RyGx/lWT/I1aKFKqJhfWBqT8Q58ug=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=bwdlVs0V;
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8a07078200fso4036688b3a.2
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 19:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795749424; x=1796354224; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zYwGFrVXRtVQNbh2j9jq0UMXN8rATCr949DIEhCXwno=;
        b=bwdlVs0VsWRDprlz6L5Y/g2y90af1NqxI8Zlm1uc3HIJJc95T1blXMG3fDQDdSGYs/
         td5R/0QIoUuMwto/AuIMUv0zCJ+Ki+DoUgnpD6c8yOChFPmPa6O1Y+iAZ18dSdZBp2g9
         hlnoJKY36fDgg9r3dVXAC+P60bzslgOFZ2/sQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795749424; x=1796354224;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zYwGFrVXRtVQNbh2j9jq0UMXN8rATCr949DIEhCXwno=;
        b=Xcqbqa+DwuQ0wu1pjkVFxBTwM8hQp2B+FIq2+QxHHiMbwLJxPZHvjspTCyVkDbPZIr
         dmGqGISf6P30TOu3DO2QPc5TYrTCO2oNHq8FdeypN9VcRCR34zdaG8qQAzkY9jWYLUqA
         oMxz8iSZAoRLCbTzsSJkK5GqcyCiRuNZyBYuxV+hTb+/0qw9L3ozD1HceRpLWmgysiFE
         1GH6CoO818W5fkM4eCFfBrG3+qiVFvUrYO8AKvhwh4o/EPm+ZWX98L7qYF/eRWEX0BuF
         /h4BQ6MYwlyPYkHM/dTT+3llF6IhmvJVPsj6hPbfZqb9HEcOn1RfzF8CiOP4ttZ4YQS8
         J+qQ==
X-Forwarded-Encrypted: i=1; AL+hErErHyyhkfu9dLVLLmfd3/G7oNYSdwQvO5FYyEQ+C4xklZcVX1k6CpDGvlYUnwGbwWjVqCyHGPK1cw==@kvack.org
X-Gm-Message-State: APuU4Z9TuJxFRxzkWrLTHNUiLH8VwHVZKq/Np10SOxpzPC1gbDALqqHg
	AsJ2Tjc05kfXXP13uT6MHzC22xWB+3BMrx14/v7p+13j0NAxLHzL8fjIEECOA8sbbQ==
X-Gm-Gg: AZFdTZcQfpzWh+FJdnQRMjF3YE/xv+Na0atqFEQDHj0w6IQMbI5VoROJVCSN9raR8SZ
	6mJdRAKAMGAWupcvvuarKU7BebsRdiQVVRNXpodUXB5vOn5vXE2gwRMmT0IRbnM/LJ4Wjf0mpv5
	YrKxJ5F7ee3AhUYmYJYQVT7zrXQqZxMbTt5TnOrr3C1245ZM1eagzjYscH43lzak5ZOOUfVoBof
	Sn9ou6/WEkwwNFMkwbH73wVuw9+6UmsMnS0Ux7jslWLroLWFSXcMRhRzH7ZU8eVv/K8wXe4JWhx
	0p6wwBLt2oshZVuq49vD6RN+Q8Lt1E9wRZcwRdJ3Ul+vgZU3BPpX9k08/qFWkknuPaL5TAXGE6j
	67dhchFca3RtPXauXvssQY3ddDQI5UudLWPQtdp2mReGMLuJiJazkain1SyT6+AScH4aZFuWheh
	Z/SNiqi0vJcw+QQpKbf8huyQxCIyBsD4NVCqX6HnCoqlLsm2r5QCZBeiCliMQeVH+7qpfDwhyA1
	SjTR6NN0MZg/tfNO8q+57+REI5rt0RPuvIk9BPVLEeU2toMInvVJfPFvcjigQH9yTJrA869r2FY
	kv8a2MVzLdNYS77LsWZFFKK/8ADcemVDsG1TRhIlMGMgJEewZlRY1A5dIOSWV9+TT0dIVie0nO9
	cO3FLJxWsTL6DyYEgNw==
X-Received: by 2002:a05:6a00:419b:b0:89a:5:92b9 with SMTP id d2e1a72fcca58-8c87cf2ace1mr19349814b3a.44.1795749424469;
        Thu, 26 Nov 2026 19:17:04 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:5bf8:984e:5bb:e51d])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c872e4d7basm11333567b3a.21.2026.11.26.19.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 19:17:04 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH] MAINTAINERS: add mm and block lists to zram entry
Date: Fri, 27 Nov 2026 12:16:38 +0900
Message-ID: <20261127031658.2049871-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D0A2E40007
X-Rspam-User:
X-Stat-Signature: enyo7t8ihsqea9gmxxppdqhan849k4ei
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795749425-75147
X-HE-Meta: U2FsdGVkX18fSoe24fE6oUoctTjUtk6yjZ6pTsGB87qvHGSUaLknvBIlbtXAOZINlSoMqSiUT1ortrFEvLCqAQCBqjK+vHu3kX58NVnS9HAbtZYE3UmioQ0PgzdLxrTZjvSuHfYLvX4VySx3fL5Y5A156jLAKFdOQzsBpw784J5tda0hWfWqGLWoEn0sHZlKvKva802tVVSMdWjztWtGMADfMccatqMsQmCp0cU+rGbmdNiFvFc5FpHHPvcKLMDP6x8iC0tOowq3tj/St5MxfHrpdcySRgWm6zzkiP9sTyX2Me9FkgVF5QrV5yDzEYDjLBbp1lxmnGU0YcGOMqe9Lyjjzjt+u2uR/MDc1Qso40Majqa6sh/BrMTrMDGVpQOX1zs5odCuInoanNV3gBQImDwtz1+EIgZZUlxWyVGJCHTNDpkGsfKlgUx5G/BiYgqJzREFjluSyXjDr2Uxf9ndzas5mGVjPXubZSezq3YVyHEHqNpHE75876u+x9KWkQtSJdjl1xONjgM/ulpyCjSlbjKwxtxFqjwdKLBeT1kNZRqgqhbH1w4mU6wlDUA9Yy0n1SuGkN+i6yOC+PVf6bCjVygu19t+0In75HgeHHTsIAp40uPYGnzR67N6lXCPVkMHfX6SMMn5UvUwB/4KETE5vX1/FsaQPE1PDu4YfZdV/fCH5fgBBCu90JUxId/UAg/s940/0prhaI1y4JTay3B3lF9yiB0VfUeeYEpdLkteSxcfiecNSA+0CTdEJRit5Vg9cn6ZJFRA38E7JQra6zvUPzYE1xru+dKCP9Lfw7F22TyZLSK5EcO0ygFYpNaTWB4P7iaedoZvShjtNguMl6P46lDNdeE0uZPvQG5BNW9jsk9Y9v+Xs+OvsNYLoCJ4hwOjUNpG7SMFEgOo+xTdJjeS2oTtIGoXSFY/z+V4CvZBE3oqB4N3LzKMK13akVDK6oWC3qaf5jEaG9sH0YNcYte
 GR75EAxV
 lsHNJcx69ot40IncLbVLn1dh1cC1fHVyEucAtXDX4UCZCUbpyJYuSVtEIEvyKwWoQjH9Mc/iuuIFBqouwybLRlYWBShZCkGl0AAQhoGvSBhC8bMeZc1u8xNSHZZk2ClJL0BoVwXQ5aieCe3N1Np+04D42WCciVSdIL+tI930+m+BxLkU3OqGsW0bd+CUnhKYxjdhe/Q8mmY+d2D5G7Ac1a+uiuihx+wV1VNeUgmjnqxpkfv/lwWf4/CPisIReOgIk/BF6kqoCeHJbD69yyTzPVRK8ZHh5ulRwWON1ueth2tyliFFN+YAQ7KQv8pZGlDgVPIi7fvlqnkaoP2d7l1iER3DlkbKob+h7EEwQYP/w40qyAfYsR1B9sqKwhPNmGcM5gh/PSuYs/6D7K0wRmHcD4Fc+PcRmrUwVM+hZLJB687wD3l7dfH0mi9Oyzu0/JlR3eTMp0qlUpj1yEalvGMu41/0dpyEo2A4gMcnOJfTk/ZZH3EWQXjoXkLNkRy1qMnQn3Xtx4lfqOHUf4dsv2B0dvBkkNSZAj6w8LwyzaK8COrIF+PVmrkdI7MwwDH+zRUFFiFLa+1L3BzOCQ2Q9rNtHtoHYhsUnUpJzi4j+xpbq2FMhAie+KvI5HAzuMLIXM3EQbubzR+Tll7jwgHOV+ZKMWZ+NlhT664avRWhm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Route zram patches via linux-mm and linux-block lists,
rather than through the generic linux-kernel.

While at it, fix a DRVIER typo.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 MAINTAINERS | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 68811a0b7916..3f10a5772b31 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -31316,10 +31316,11 @@ Q:	https://patchwork.linuxtv.org/project/linux-media/list/
 F:	Documentation/driver-api/media/drivers/zoran.rst
 F:	drivers/media/pci/zoran/
 
-ZRAM COMPRESSED RAM BLOCK DEVICE DRVIER
+ZRAM COMPRESSED RAM BLOCK DEVICE DRIVER
 M:	Minchan Kim <minchan@kernel.org>
 M:	Sergey Senozhatsky <senozhatsky@chromium.org>
-L:	linux-kernel@vger.kernel.org
+L:	linux-mm@kvack.org
+L:	linux-block@vger.kernel.org
 S:	Maintained
 F:	Documentation/ABI/testing/sysfs-block-zram
 F:	Documentation/ABI/testing/sysfs-class-zram
-- 
2.56.1.839.g22a8290db9-goog


