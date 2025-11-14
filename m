Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEB0DCE8D4F
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 16:11:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CFC08E000C; Fri, 14 Nov 2025 11:11:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30AF08E0005; Fri, 14 Nov 2025 11:11:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2213B8E000C; Fri, 14 Nov 2025 11:11:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 10B428E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:11:45 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD29188D2F
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:11:44 +0000 (UTC)
X-FDA: 84109703328.28.1E5EC55
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id DE1B8140004
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:11:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TM5e+BKI;
	spf=pass (imf23.hostedemail.com: domain of peng8420.li@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=peng8420.li@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763136702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vhc/zAuTGQVZ8JaTdN8K+Oo0c5+Z/1J3kDu+xR7CKJc=;
	b=EglZ6z6pXZfjGBZLfTM/Z2sDX+SEd4BE3iUEO7+z+MgQscVGgo6Sgtwqy7+9gsd/BVnFWD
	E4PNa1zlrUMY7DqCnrAwgScB19xoBe6QwHYOL0O7iJQaGM1xxkAD4086IcqZbFdsMH25ax
	BxnIZ1K8l12xxtI6eYvwMjMscJpgd3g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TM5e+BKI;
	spf=pass (imf23.hostedemail.com: domain of peng8420.li@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=peng8420.li@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763136702; a=rsa-sha256;
	cv=none;
	b=EGUTNPYcDeJ5DcyyuJVQ3n1EdWwGcgSZ0rh6ifu2QFcMjWAR9DNa3wr71H2bA7oFFpnahH
	3hF8kyB+XeRWioYpkQfFWXf6As83FwbF985b3CwvIiBqPHtfpAqglwnblnswEOsudZ3wym
	Db6RCWBPPJokLk+Ow+jF5/jZ0dWixVo=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-297f35be2ffso32212975ad.2
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:11:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763136702; x=1763741502; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vhc/zAuTGQVZ8JaTdN8K+Oo0c5+Z/1J3kDu+xR7CKJc=;
        b=TM5e+BKIAnGrgyHRk/8HJUTC1M5XtSJwL8PhR//dpTrzNWPm05D3icuq0VkDVbfL0z
         kb1fMJcvx5aN8AnURLbqja+rVrghyB0fgIN5BBA1dXNsjswl96Et+bmX0uWiGnZDe0uB
         vSMCu/BbvrYyXjwFdvddAgIOUlzxkIqw1gcRjwYv27+QNMCOyUgXbPdPs9zMLqOSCYnl
         VK60p0oJdk7oWaqMHt3euF8VVAtP3/DjoQmCTgrLgi+QaCHE1GPy7qnh1h7cI5NVAjH1
         GBo/SjQHo5rrLEBQF49/gTQduzuV7IUqZSBdMDHFITOn0ud1qonk76MxtLJCCW7EB3jI
         yLLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763136702; x=1763741502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Vhc/zAuTGQVZ8JaTdN8K+Oo0c5+Z/1J3kDu+xR7CKJc=;
        b=RNwhJF33EoEPwMiJIbZttl5SohdSHoLWV/AGPK4ExL9fhvDS0Uv8gR5GAsuadY9njb
         GuNWAIZIcf6toGWBxvMCsbCX5sL+rPkKMyYjPQJRFuzCDNhp2pWA2ye2b4XpZuIKdkNX
         rSV9fjB+cVjKTBWPDPh8tuvV7zM9758+o8N9zhng74ZmfVH3TWHJCaKv9KeEwu32RiIx
         GfFVWHKqcDr+eyFs44ckn91rxQdnOH7XmCjAeVh8/741ligZePpR00AzIx3oUteR6rv6
         z5Tsprgdv5Ui+hU/HZUuRO/pCxxnDX4LXpmc+dXclRYjWs73DSYDjOk9PM74WAWcchUn
         b8Bw==
X-Gm-Message-State: AOJu0YwQgi9NxNp8jWR6Nru0eccfkF0sKnb3ZjXKQdp+ftMrslEntpaR
	Pwu2FNJhj63xCpMMt5CRSxijDwdCI07dcrXvkz/T9yq0mw6MKCNkpA2Bf3QbduwApuA=
X-Gm-Gg: ASbGncs4L0gj3iFxC5UNwJpSupCkQkqgys/M2ERNJH0/OGH/tL6L/YcMY/cdyFQTLHv
	yBiAHZJ/sT+XIJTeDRPpLkGATtfnXkIorOo3b4WxHoC86uV6BYlSXkQylv6O1/RhgJ1mHSEP6dU
	/KmDVreOccpPviOzVJkUnURyKEnFJRkSyAiQi+yaDdXilRNFEqp52TBm9jAaERk/ko2vBbGZ2pS
	g0K60xfaym3FChzEahm0oMRC/zBLAHnHCyen54o3jJyv79upIPYNtGnzz2Y8rzDLGwkT15jmq8q
	ugkg/Ii3kpOFZXEkszp6f8mOhzE/yu5ug3r+LX1K49MTUk3bI2FuEe+tJn3dfyAZnhqm+vqMy7x
	QBlPDafxemuydwyZ9Iptj5Xaqrt/q7VAiNMBsQDaiyQYHMSocMNKonhD2Ypcz1Eh7fxtscZ8qSy
	Q=
X-Google-Smtp-Source: AGHT+IFlZcha6H/DsVinWBqqf6oWZTx/2Qg/wcFkZfj/srVzxyOPB116oQRPQl6PBozvaWSue3LTWg==
X-Received: by 2002:a17:903:1786:b0:24b:24dc:91a7 with SMTP id d9443c01a7336-2986a754e70mr40681165ad.45.1763136701667;
        Fri, 14 Nov 2025 08:11:41 -0800 (PST)
Received: from gmail.com ([117.147.72.154])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985ce19a20sm58384365ad.84.2025.11.14.08.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 08:11:41 -0800 (PST)
From: peng8420.li@gmail.com
To: linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: david@redhat.com,
	osalvador@suse.de,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	linux-kernel@vger.kernel.org,
	dan.j.williams@intel.com,
	"peng8420.li" <peng8420.li@gmail.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: [PATCH v2 2/2] Fix the source file annotation information for the "FOLL_WRITE" macro copied.
Date: Sat, 15 Nov 2025 00:11:27 +0800
Message-ID: <20251114161127.193707-2-peng8420.li@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251114161127.193707-1-peng8420.li@gmail.com>
References: <20251114161127.193707-1-peng8420.li@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DE1B8140004
X-Stat-Signature: 3mjdz41ih4n94mcxjpp5y6weihxqco17
X-Rspam-User: 
X-HE-Tag: 1763136702-262907
X-HE-Meta: U2FsdGVkX19/O1nDBZVzvCY7F22f+Fz+9zMU8CB7kVs4e1D0NLpRKNZjsCrPQ/vRqlH2mQzCLrfEDvjFVIOxQMytenvnldVyTzibiE6IZfOapt7gbETRuc5Vx7s051HeF65TIdr92AAmnewO+4E3Lj1vUlI3E4CgyOhFbYiRpClptzfSRx+72+BflBwz7pu8QTBkkODD99uoeiD+4g8x9B7TZSfHnVlGbO1RZGmhgHzzwxby+AZZdjoSvddy0LDfoouDmhamKTwBN7gCl8nB5PNWpOyb6mMmQVOzgA4pSi8I4xJKb9QG7DlZdNspJ5INsGeBPTNxP9/q89UJ+Nfm2hykqSrf/E5a/bNdCqQs+/AJmpWo+182izub3hA+JXpSIHeObKNk6l/Bm7F5vgbY8Jl1TyUru5Shk9gbr3+n5+6DhHqGODYxSLUH83DG6KuKIET9nbVVfy04bv7NaXjdAExiNf2k1GTMTXiFDLk2kSKvDib6UYtEJi4Cu7EWxDs/9RsTKQnmY8Tb7e4407ItW//33qL3NRkWWX2F1yimoecwQyqoFcgvii0VjOTxaRmSpJzfdRyuwhyURa4dGjXsAeLI538uwWLNHmh4DAI+PGP6vZC16QtYrqWg2gYI2MaNnHNU8P4EMXGnAyA8A+5xaeMn92EdDlz6ljcz0IYmAvS+9dB0FpTarN5JOI5lGjkewRxT4PlSsvQ/bXoJjhdqKB+/Bmuhhw6t6iKgDbCrIrB99K3DUvqTgLcwNErzSrxMJiIosLXJCjoEwBv9Ac1kz+gcjMC+shX361Y88OFSej0D6i4Cw9KaO6FhrFgC+7m9+KRVCv7RgAMyhJ8gScmBfVRwcD2nuh3/4larkoRIzIKucD3YvyghOLX6FUHJMvIe5DidBXwD4ggwWUvQwfPYRgmGSKgRfehqrd7cEXwKnePegd2iUwdfRUPePK4aytCdfJ2DdFHEO+7ySGBrXtj
 MusBcHlh
 HzxjSTUMnY2gGdO1wNQQ/ClqZWhnTk89JEnSeu1kMxjleukorqHRODV74MqLtVdcBtha4YF6nIUiWg8DRZe0ThVkThNYFoN+5qo/ApNf1V6MbgShkG/1furpMMV4Y3jP5/fYtVHTYCKAZQED6prsu+xX9Zx+HY1yv9xK0xAKoCEHq0b5NXfAQiu/wJ30ujufDGkGjlgjY4qTqdCu74HrO4s6Y7uOff3+MKU/6DV93rK7h8lCBVPV5JXuwzSz44x3CcBQTTPljPlb6pH1QyZU03RnezbL22yItBuk1asnn+qFsOGcxGJ7G3XFbw48DI+db8hMMJexZRb89q6UWqmDsly/EueCM6VQeQQ06pELehfmjkSn1bM6YlLhtCXBEA/MuHPl5zLYGQ89KHi3aT77ZB/CthvOkSgzTDIMKiiiVI0Hdp3QwN0wVMfSVmjjXtraNy1vcUOASxn590S1t8ZnlW4d4fb24cpM3rUKish4fPEk1mr3XnE0s/5lc0cz6rfQe8IIzX2kWaOj5ttrFZzDS8+S2MmLKMY3by08m
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "peng8420.li" <peng8420.li@gmail.com>

The 'FOLL_RITE' of the copied source is located in mm_types. h of mm, not mm. h, so fix it.

Suggested-by: "David Hildenbrand (Red Hat)" <david@kernel.org>
Signed-off-by: peng8420.li <peng8420.li@gmail.com>
---
 tools/testing/selftests/mm/gup_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/gup_test.c b/tools/testing/selftests/mm/gup_test.c
index 75f7134d529d..40c1538a17b4 100644
--- a/tools/testing/selftests/mm/gup_test.c
+++ b/tools/testing/selftests/mm/gup_test.c
@@ -17,7 +17,7 @@
 
 #define MB (1UL << 20)
 
-/* Just the flags we need, copied from mm.h: */
+/* Just the flags we need, copied from the kernel internals. */
 #define FOLL_WRITE	0x01	/* check pte is writable */
 
 #define GUP_TEST_FILE "/sys/kernel/debug/gup_test"
-- 
2.43.0


