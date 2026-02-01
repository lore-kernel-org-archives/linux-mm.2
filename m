Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCD8BE65298
	for <linux-mm@archiver.kernel.org>; Sun,  1 Feb 2026 17:47:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F6246B0005; Sun,  1 Feb 2026 12:47:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B6C56B0089; Sun,  1 Feb 2026 12:47:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C6BD6B008A; Sun,  1 Feb 2026 12:47:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 090196B0005
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 12:47:51 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 95DDD5BC37
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 17:47:50 +0000 (UTC)
X-FDA: 84396620700.11.49D03A7
Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com [209.85.210.193])
	by imf04.hostedemail.com (Postfix) with ESMTP id A054B40002
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 17:47:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hK9DHf8h;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.193 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769968068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Qs+0PjG7we/2y/IeweOE2VC49SWcJ6UpvgcbMN4J8Kg=;
	b=D0UcAuaVc+9KVeVRhgnaV5SPZ9DAleWtZ+6/ujwEPHEgNHqlk9cwPb2tw6BdNd5gFyYRN8
	yKqhkw0r5vPMfGzCwiYH5R74MBWC3mvmIYlnX19lgAMYjIsMm95Ez04thJE/vWsWFLOmLO
	Asud/xo0D+/Hm4dDuZr01cjtpDba0sc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769968068; a=rsa-sha256;
	cv=none;
	b=AuAU6YvXpZhmtyPg1/apdTzo3XB+vjOf6AjHJDP4jkshSRlkjAuj3nnIM9mMAc1rW3zWDh
	IC9u7hJF6yJKKfiq0mXz42jGpiW5gQo5SPQeATVDkAImUMhbQH860k7TuobtS41aPo05hS
	GfeQjvS0t4UbTQbQ1rBAW8fl1hTU+b4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hK9DHf8h;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.193 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pf1-f193.google.com with SMTP id d2e1a72fcca58-8230c33f477so1549243b3a.2
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 09:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769968067; x=1770572867; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Qs+0PjG7we/2y/IeweOE2VC49SWcJ6UpvgcbMN4J8Kg=;
        b=hK9DHf8hWkKNYed8mpNmBGkLiruYLbxtlbZK9RFlk2859jjEmOhR5Z+ZfA5tHWDCUp
         CeIJZNmeYk8iUOVNTBzux4+bGGWWYc/Eis/h9SxWAzZ37N41wb10bttuoHv5QmSSlzAA
         RXOAxOv10+aVDRzsA+qnNqhghopCyDgIkANOiDMkRbiioh32gA05XuIXIGu0z2W481a5
         bep7/fT82PyhI6HkcsdmVlsGjy+Ttpre91em6U0HnEmUVeBuvFO444yxr9ddiiuAiKwJ
         JWRmmtWalbNB7Y/L08sewQwt3bP3O8rJ7DFR6DcSG7F8pphBSQ0Z7FhhtQxghEsVgcSn
         +LYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769968067; x=1770572867;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qs+0PjG7we/2y/IeweOE2VC49SWcJ6UpvgcbMN4J8Kg=;
        b=eun9VPjSaNyy9PdDz0OIlRqmn5TjmktR258rXBTYXmE8kXXizmL+nK8GKCII3eazsv
         qYS/8cxZMrjzwlJkv1VZBirMd0m7jrsocFfknhEZVLySLQHGcpFe1x73Aiz/FrEvwJeG
         forpbyJYo5gnMLwq57k47oeXZzidNulp5p4ak0PPOzxoxl6xfOxikjXBflQW9RpYOVQZ
         BWx62oDH4cpryzjzPDQmn+zs1Si4TQFefUK+WlinX7Ot89b4e8OTVb+lDGILMQOqSWs3
         GSkItxT4P+aooEo2X0MYJnFMFNvJy/nKCn7Ktl1YwLyRuK1XBdXxotpX/rHDZht0x81R
         orfw==
X-Gm-Message-State: AOJu0YzXi+gNTmi5vKgl2I96mEoa+7cx5zr++NTk3BudUkAJcsUmW1d9
	y+o1HkMZCBInxNQoIO+vq9/LQPNHtr7azk5ywDFxVIl26G9cuNObCIy4
X-Gm-Gg: AZuq6aJCG8uhMWIZxE1XlTHvQQ8QfqJcIGzJrZgdH1O/SDt5Pjcq21c+i55wWkpICtl
	j44VwAd3DBxIT7gK4iJe5p2Q5HsEpCOKPEv0cqsuE0VC8Xk2Gc47OnPZ6LgvGgTr/s7TlBOXGFI
	oId/z+4U0nMQFrA9WFsj2A1eRfeZq7Bz7SB5gCsNydjMLSzXaH7yvb2LlwkPL/bJ9JjcnjHaW3/
	wd9U+NVEYIT6GZDnGPJqaMxQ5svfZA0s3mD7pxjzH+dcXVQvMjXZboYhMhZXVSOoLlWO9uiKc07
	k69rGX7hBT74KjmRgRePinCwGwqArIoOmAixb82xTZE/w2+GAjyo872FjpM2q1VumapUwzAotBC
	HueN1jv2gUH7BRRr3DAvULkQZYDw418eZ3/KaNu9D9ICfmOt/WT2AD6Cy1sJcIIEBeP6V/r2LXU
	eWkAQpYmo+RrFS18JYGSDfNRjfaDpFWkaEVQBL+vKEGoJVCsRD
X-Received: by 2002:a05:6a00:1ca1:b0:823:167a:4790 with SMTP id d2e1a72fcca58-823ab6bb713mr7915396b3a.26.1769968067356;
        Sun, 01 Feb 2026 09:47:47 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379bfd8desm13596758b3a.33.2026.02.01.09.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 09:47:46 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 02 Feb 2026 01:47:32 +0800
Subject: [PATCH] mm/zswap: remove SWP_SYNCHRONOUS_IO swapcache bypass
 workaround
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260202-zswap-syncio-cleanup-v1-1-86bb24a64521@tencent.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1NDIyMz3ari8sQC3eLKvOTMfN3knNTEvNIC3UQD0yTztGQzQwuDNCWg1oK
 i1LTMCrCx0bG1tQBq9LFhZgAAAA==
X-Change-ID: 20251226-zswap-syncio-cleanup-a05b7fc6180f
To: linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
 Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769968064; l=2359;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ErqyaqA8QnNQl+WnQiuzCLJFhc1Lwvr1urzWqbT1kt0=;
 b=QKR3/i4gsNjHNsEGMaO5PSlKr36As5/kOAviyuIt1z9Rc7llhDlVcFS52ClbzxG3P7ei6NF9g
 Uqd6l8vHd1zCKuadFoGKYcX9Pgxn+sndThGpjseiGXTInEAOQnBp0Fq
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Queue-Id: A054B40002
X-Stat-Signature: 7rggzj7drsjkboju1fc78e5td4iam8e3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769968068-135304
X-HE-Meta: U2FsdGVkX1+ctv4+FCvXSacIKymuS9WLfApbJY1El0ofHJldzrOdCUvHcgKf76te2IWJWoBHPSScC/VEAqZzs2Fl5nQdyAX4HTFdeyE5V9au4YkNT3bV5AJybjfcF5EAOOw/T+m5hTASpcy2zyLf0GH6SSUDY0H6Z2yQ93uW/wU/GD6o1swZSRNb4o65uUyhBAaLbnI8MSPUMqhDHEeyQawvHbHZRNTHms8HlEkbMQZIYfIOMnXirEG932Y02RLI9Lb8aFy6V7Ix+VR/8IruZwkItmer9vsYH6HGSisJo3pBnePngV1UadDTOVhAD2kF1KR5K0zV3cka6mxyuhbZ3Om1APqVw3mjv4YxmfZ0Fv59Z+7E6TSHB68EzyL92bNIv0Am0B4Zl+uML/oh6lZ5W3+au8Elj9PgFqmEPcxibivQnBgRl/CuWMXL1X6Wbgh7WZbHE6Evgy8Et1LZqtYCZ34B0PthI0xMIw+AeagEpOyqRiTkXbPT3kos3Ex9DLKq2lPaMEpig4zbsxYVfsPXYHQYQr1XGxCM0SrJDw2C6JwqxEuouweCP4bxLNG0/S7TJWmFicTJC5czSAwjr3Wbk7kHgNF8ZHTCZdMmV6Aw99PIeO6SkrO3gpupY/sYX0eDBc8dbTaxd+u8DGoMwJ5Q9K5vNQlJ6RLWHe3A8Ig+bnRA9k4qgyblzYhFpTxmEtjlRn/tOEcaS+7sjO9DDQ1SW3x5CCAT9Nq8Fg1/c4YoQ5JQ5NPRFRcmopS4XkubKpBCkzykGVRn/Czc7DL0sn1kLLXV1+PwJK8j+kkpkZiscXl0kRB/Tlv/ER6fFAX2jLhlhkflex2JJwx246wEzZIXw4hpwySBUUH7LzodM3dTNXNHWk40qvtwYCiUyrRbyvR+UcWpB7rBPaKMaE1nYzSQo7tCyohPNDTu0T5lsnefGaSF+0DPpw2V1Ao3IZz2WLzIvn8oNq7yzTfKtor6KWF
 HPt15i6B
 rUnTi6Ytpw/yj95W5khihvuzcc9xbifQZuYpuNNY8R9juzwH2HZqU5X65fYlB83FbXux4DsxsNLk9nJBd0+HDqyjtK/Irf75hBqqTdRp67zD+jljUXoIfharf61SyqoU8Xest/s6tBVxDOG6I+9D9BtL/NWLVsgubNYznRR012wqsaNA0uw2L45ItIUBUXlem5jGHrvFaUbo3XR3O8B/+MfEychQO4U5+dABqpcUvQrGq/y/zFVRadmg2OiVdu+p8YkPEyRPODXvL/T5XNsyTIG3E7xTc5Nrz8XIV72m+hRD2n6aNk0i1gPg9KAIKQlbCONyJ0WkCPE61tYVBYN1zDkt5L3K2vVH+lojvo/90rcExio9qwJWc53kN8uIaeUSTUKnUV3+s2Xt/nlTAouI7+8E76e0l6KYCpGn/0E8CLNhWseKOqQHcQn13S/5Vj646aujrV/wlNvEkztgRMWN/ZbYm99j1oHThZLzrpoOthE7O315epQbtzCf8MF6sxVSWYbOy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Since commit f1879e8a0c60 ("mm, swap: never bypass the swap cache even
for SWP_SYNCHRONOUS_IO"), all swap-in operations go through the swap
cache, including those from SWP_SYNCHRONOUS_IO devices like
zram. Which means the workaround for swap cache bypassing
introduced by commit 25cd241408a2 ("mm: zswap: fix data loss on
SWP_SYNCHRONOUS_IO devices") is no longer needed. Remove it, but
keep the comments that are still helpful.

Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/zswap.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 3d2d59ac3f9c..8cd61603ff79 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1589,11 +1589,11 @@ int zswap_load(struct folio *folio)
 {
 	swp_entry_t swp = folio->swap;
 	pgoff_t offset = swp_offset(swp);
-	bool swapcache = folio_test_swapcache(folio);
 	struct xarray *tree = swap_zswap_tree(swp);
 	struct zswap_entry *entry;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
+	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
 
 	if (zswap_never_enabled())
 		return -ENOENT;
@@ -1624,22 +1624,15 @@ int zswap_load(struct folio *folio)
 		count_objcg_events(entry->objcg, ZSWPIN, 1);
 
 	/*
-	 * When reading into the swapcache, invalidate our entry. The
-	 * swapcache can be the authoritative owner of the page and
+	 * We are reading into the swapcache, invalidate zswap entry.
+	 * The swapcache is the authoritative owner of the page and
 	 * its mappings, and the pressure that results from having two
 	 * in-memory copies outweighs any benefits of caching the
 	 * compression work.
-	 *
-	 * (Most swapins go through the swapcache. The notable
-	 * exception is the singleton fault on SWP_SYNCHRONOUS_IO
-	 * files, which reads into a private page and may free it if
-	 * the fault fails. We remain the primary owner of the entry.)
 	 */
-	if (swapcache) {
-		folio_mark_dirty(folio);
-		xa_erase(tree, offset);
-		zswap_entry_free(entry);
-	}
+	folio_mark_dirty(folio);
+	xa_erase(tree, offset);
+	zswap_entry_free(entry);
 
 	folio_unlock(folio);
 	return 0;

---
base-commit: 2c263046cbe6d9d5fce3dfeba063f199f7e6298f
change-id: 20251226-zswap-syncio-cleanup-a05b7fc6180f

Best regards,
-- 
Kairui Song <kasong@tencent.com>


