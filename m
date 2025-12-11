Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9892AD3B9AB
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 21:58:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C25866B0006; Wed, 10 Dec 2025 16:58:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFC9A6B0007; Wed, 10 Dec 2025 16:58:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEC316B0008; Wed, 10 Dec 2025 16:58:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9FCB76B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 16:58:00 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 72F3559CA9
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 21:58:00 +0000 (UTC)
X-FDA: 84204924720.13.CBBA9D2
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf14.hostedemail.com (Postfix) with ESMTP id 979A410000D
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 21:57:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BiELn8se;
	spf=pass (imf14.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765403878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+hm1NbizhX2u/6oOBSk1ArXnzSC2i/yu4zfAVJxLwRo=;
	b=Gjki47zetYujux/7Wnxv+TPXB3C/RAxtev73e2VxVNqZvGe+OLjenhe/KeGkbOrFmAjMYk
	FeU8dTusikxs3N7sLm3aFoNLVSOlj36y0tPjqwDr/HO+QO6QsGhV1m/tkZzzOtJ6MnIOs3
	1KhHKQZdLe2rSsFw6nY4Ssv63pP7tz8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BiELn8se;
	spf=pass (imf14.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765403878; a=rsa-sha256;
	cv=none;
	b=73ZCI+pgCpXDdJ4uUt/PIG4SS3py5CMFIYQLjGxZWcoTAnxcYyBXvQw3hIuBIc4siznV8F
	u06ODT1SzPr3bqU/xu1ODOLnR5eUbhozrmlUKPGN/VXDMg7YjbSAHWwrzViZVxixUt7CPG
	axRKiG/3+snvxWSPZ+cQuMac/xdV6i4=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7aab061e7cbso334311b3a.1
        for <linux-mm@kvack.org>; Wed, 10 Dec 2025 13:57:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765403877; x=1766008677; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+hm1NbizhX2u/6oOBSk1ArXnzSC2i/yu4zfAVJxLwRo=;
        b=BiELn8se2bKTp/vBreSyUxdcKqFeiva6gPssKPReJTzcBBvFqLDj7Mb/On5zC6v2Lf
         3vw3oqg/MHLloxrtoXVvQgUm4p8hejHCGHrDmbWSrA8uQenIv4kSc+AyJN47e3gS7yFj
         iD2B+0yzZTrYmbWM6+exoRNn8PCFs0M6hT0JPAZf1vp7r8gZTjUY4r4l3YfPpVCUyIwr
         w/RH4jZlb/ECdJ+Fvw34c8it3AvlDcqoOrXO0pN/qh4VDRppeqFTQ+zHy+qGxv0kvVXz
         2TfBkk3zezP7y89IBcDGSOCP1j3ETFo7OBIgqjfdJALeUDh8cSPMJ2dZmbLr0/7ZmAs0
         N3CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765403877; x=1766008677;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+hm1NbizhX2u/6oOBSk1ArXnzSC2i/yu4zfAVJxLwRo=;
        b=ZvuMRXT1ORVe08tFbnFUVCoSVwkEAHgCghFYAkNR0SCLAxceho8qkjAjeRMMsyVzLP
         ASBlN7FHSMYLEphz9GvSi812eWJnZmcJAwh7hIazgsioBiuClJaPzlEzPNyI6/vJPoVr
         cUKe09ktoQTxaRJvb3xM6cr0tbQ+B344A2bMGaGqDjXrQoPh90+8D/LhWYApr9GK6TdW
         YqcCp9O31wocsBnD6UfTHfijK1y8HeLD/IW3fmkSVB0bZ9ie8Q11fGAS8FwTJzPWa1Sl
         36jRV7FtIb5ILI+gTTYq6zPTpZsp+4k6vOgll7/b2QVX2GTsv/w9QAhZyTWIRNKEFitD
         k34g==
X-Forwarded-Encrypted: i=1; AJvYcCVYud3MTjFW6JhlTCC0+cV40yVV+12MCTCHaXSM+g/Ej737P47HBpOUFuF+H3UZ9lPZRQHcHxhNtA==@kvack.org
X-Gm-Message-State: AOJu0Ywx17YYQPC7KiUZavoPVT4NAtWkVU/Y3qf4HPaqanlvp6eY0yay
	/YmRggq1LsPKtykIvqpafUAT4M5VrmDauBnMHgMSFj3XEUBsd2vIJ2A6
X-Gm-Gg: AY/fxX678XBb/OhhJryUy58Wg9LXiIs1gsWTqwN1Muh/TYWFd9fdKO0JtI7FdrgLvqW
	03aDCYgWIAzEGbcAnuCcA63mSHpgmIQewPqL+vK4nIK/ZPRlfqROsUmt96HH6RgLMRgyWcwTbQm
	XEDtSUGo5kVoNGti2fCF/S7NC9MLSAxvV4MdRz2sQf1cXJYA4uDR6sfa0C0rYVoms0jMPhyGy8b
	J9afUH+Q8H0p6k25itojtvWuVan6IhijVp1lnZ6q0Kd4PI2RRKUVYrCynFZv6mB2tO4f2CP3MlN
	g6mrbL8+KbVfXOe93v8blnBeO+KVLtwhf9uDUPSVi949tgwE7xUuo2J2Y8SvO0fqzt5cKVy1iv0
	6m7zlGFv0nFj/IAIElWP9lwZ6gmzb/ILan6o0N9Cbd0dAZHCdsKXhhshr4Goa/pdUaWuKMbW+QZ
	OJJ+J1KkE3m1k4eW8MXfk+nniEVgM=
X-Google-Smtp-Source: AGHT+IHA+9Qz7ydU3Ty9NpHFSEVIZQE81z8wV2mYZQOhee792sM2qH9nyagSd+BRXofaMXiX+aNkbA==
X-Received: by 2002:a05:6a00:4f82:b0:7f1:7c82:fe2e with SMTP id d2e1a72fcca58-7f22dabffacmr4111460b3a.1.1765403877452;
        Wed, 10 Dec 2025 13:57:57 -0800 (PST)
Received: from LilGuy ([2409:40c2:1056:3997:289:7d28:d8ed:a86])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-7f4c54812aesm453133b3a.65.2025.12.10.13.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 13:57:56 -0800 (PST)
From: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev (open list:DAMON),
	linux-mm@kvack.org (open list:DAMON),
	linux-kernel@vger.kernel.org (open list)
Cc: skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Subject: [PATCH v3] mm/damon/sysfs-schemes: Remove outdated TODO in target_nid_store()
Date: Thu, 11 Dec 2025 03:27:22 +0000
Message-ID: <20251211032722.4928-2-swarajgaikwad1925@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nnikjtgn4b8kfnk1qdhic5oowbskq118
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 979A410000D
X-HE-Tag: 1765403878-317887
X-HE-Meta: U2FsdGVkX1//TOWtighfRZApEI6aXsH6bwchbMo5V5nqfd8cG0qClSITC1RsL39VJFO8FNrqhYd5N18iNek8BCTBbx559qXMj5uL+9DqiNl4Dbi0gWVIdqO0qoIOuN9v9mYXLfbBvjAXS/DBQDL2z2ZAK/JIxFQmGEFa8jGNVgVUwkCKq8SFVsvl8+hwOrm7y+UyGiCZyCvUA4T/GjGHw92p55w+9idhkd1ezewR28zyNphoEyiCgyALeWq5lIvP5QAZx5X3oxweCzCEnSmi9vOiel5jYfXqnQmXX0nm8gEoaR8Z/Wk7oLexcn3Lsr8NkRh7KElNlm8SYpmUQSDRhsTwRVPQ3D9w151N9WGN3Zs9658WkzTY+DVRphkG5/UwQJ4rWjsRKlWXg1PnrjUEIoaf5G5fPBSLEpZ3sb+Nge9WZqyFLESdARU30jOgkDEYg0H8jK0ZED2rl7ZiDik7twnLd/Dz7YAT+jRv1KiEsoRZiMHOXMU+UlnylTAKr9H1EhFMSceKv+PdQKXRnuOGL+XcYLiNFugnCT4sZeod2pdF3nOq4gR1yoD0Cgh9DkIs9zpjRJb9oT6Tubm9JneplBnjMznb3fs23QRnhFiOlcjDEeLwIX3poVrVjH6qenKdsIxkAhPk5y1tOYXCB0Ik1xhWFzcJ8Uomlc5+92crzWkDW4xXm7zOz1rxs0nRSQHab7GGarNxX4MnU6uySJ7RqOzN2So89Iv82H2CM/2j2ja3SUAXdjtq+cYkX9wSmpcQxKjE0cncInp/sOP+RrVVcD+OJPMtKhzljYt+2yEfa+2YsPT9TX/9+cx+lbjiqBFdebKUluju1MC659xzOwVcA5sc2HJ4ugWbFaWOBoOzTIon2m9O6yP+Tzjo0CjacMIiOD64ZCexON4/UWLHClMjMgBhkymRCmyV1S9me28HmVLAz8nD6uvedtuPhXPY94eLxSFhUbmJ2y/NLvkysea
 4YSZ4lUU
 zugcT/M6CpYHdZ1XyjxHZMXipseW2SNkTpfZanDeVdcwdRz5aTp6VKZya5wKAaez9BFQCIMpTxh2wYcq6VAkSHGbE/+DXmOgVKUti/o9Rjl2kc8b+wpRO0At6xzLCpkA8XkcNNJJj/WzHERO8TDNH5KCxwtpqFzVS3ju0e0yS1UtBqMlJTbcL4CM7gJTTosEuaGGuzxMWx0ZxnhMbm1ma2qHdP5Ucjs5MJEE3LEzNJqtTHH+rj/udcVN/kC2bMxEIo3oEYUbAJ5mBA3NVuAqvnQSOeiNg/6SW65tmrJ1Kpl2/RB4q0yHgXtmjI4mv6GvKnwtvLbkF9UY5jwkVkxe58Ro+X0JNx1i5P/TSfHE2ooCYNo4dp2EzPbXjUD0Eh8U01Hkev4B31P5qusm7ptGNbqPd3cZ+jG1X2L1ZAfWwnVE5MDYxLuC1LTmw0O8G7OtqmtCvP5QSUE1vLRrfKryZwBAKsywuKFvjLPxS2rol7oALK9XQAjpLGHeB4enuK3uhlZmEC09f24/CUoeUWLMQ8748OHYqdnOVKkV80xSs99AxGxUvjrLwzNk5h5M/apDZSaLN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The TODO comment in target_nid_store() suggested adding range validation
for target_nid. As discussed in [1], the current behavior of accepting
any integer value is intentional. DAMON sysfs aims to remain flexible,
including supporting users who prepare node IDs before future NUMA hotplug
events.

Because this behavior matches the broader design philosophy of the DAMON
sysfs interface, the TODO comment is now misleading. This patch removes the
comment without introducing any behavioral change.

No functional changes.

[1] https://lore.kernel.org/lkml/20251210150930.57679-1-sj@kernel.org/

Suggested-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
---
v3:
 - Added Reviewed-by tag.
 - Moved version history below the '---' line.

v2:
 - Removed the logic changes (validation) introduced in v1.
 - Updated commit message to reflect that only the comment is
   being removed.

 mm/damon/sysfs-schemes.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 6536f16006c9..14a17da350ab 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2245,7 +2245,6 @@ static ssize_t target_nid_store(struct kobject *kobj,
 			struct damon_sysfs_scheme, kobj);
 	int err = 0;

-	/* TODO: error handling for target_nid range. */
 	err = kstrtoint(buf, 0, &scheme->target_nid);

 	return err ? err : count;

base-commit: e9a6fb0bcdd7609be6969112f3fbfcce3b1d4a7c
--
2.52.0


