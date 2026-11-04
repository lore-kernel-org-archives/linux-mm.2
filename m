Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E1D0606EEA3
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=S5NAfVJU
Received: by kanga.kvack.org (Postfix)
	id CAA1A6B05C0; Wed,  4 Nov 2026 14:03:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C83D26B05C1; Wed,  4 Nov 2026 14:03:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B98C56B05C2; Wed,  4 Nov 2026 14:03:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 85DC16B05C0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:03:51 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DB2DD1207F6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:03:50 +0000 (UTC)
X-FDA: 85398361020.12.A1787D9
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by imf13.hostedemail.com (Postfix) with ESMTP id 162D52000E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:03:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=S5NAfVJU;
	spf=pass (imf13.hostedemail.com: domain of 3kYHrag0KCKAABHISHEKBAPATGOOGLE.COMLINUX-MMKVACK.ORG@flex--abhishekbapat.bounces.google.com designates 74.125.82.199 as permitted sender) smtp.mailfrom=3kYHrag0KCKAABHISHEKBAPATGOOGLE.COMLINUX-MMKVACK.ORG@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793819029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DUcpgfrjS6s9SSnfNEZAg7l7UHGbgZn+gcmgz0ne79Y=;
	b=IEF5bF4WcJ+2yurLyYY71+V60/RVUX3mO/pyQee5t66OeVJOBstGUUharnKElpvRa3lBM3
	Ywn/WHvlUaP1Pt4tcLLCqgdsdz9AuMWEud/GhSeM0DdZsM7d3fKNxYg6iQoiatRZRhW1+N
	GlVJSVv7/I01m2sJQTAHa8z5bLpUDww=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793819029;
	b=FxdoWhMSUpKIay2BHXrw1fz7KKjAZZyA5ImmuHYGlNvOJe1ecUSzchKEHmyloC7AhMwYxd
	z4lOtLtaYxOIZoFirG+xBWBGxgZ1IytCRYebdWnqNglBsQLLWvIprgwvCrnLHLVSyNhzG9
	2yy5aItT0IpGqR1Q0jZ+dFGDW9/Hhsc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=S5NAfVJU;
	spf=pass (imf13.hostedemail.com: domain of 3kYHrag0KCKAABHISHEKBAPATGOOGLE.COMLINUX-MMKVACK.ORG@flex--abhishekbapat.bounces.google.com designates 74.125.82.199 as permitted sender) smtp.mailfrom=3kYHrag0KCKAABHISHEKBAPATGOOGLE.COMLINUX-MMKVACK.ORG@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-36a223755e4so3565644eec.0
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 11:03:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793819028; x=1794423828; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DUcpgfrjS6s9SSnfNEZAg7l7UHGbgZn+gcmgz0ne79Y=;
        b=S5NAfVJUM7hhUcnivfu3hsi8+7WV3IOZQfi/KAy3/Xowu0wnyJ5pUunjMvJrcOgNER
         zVOBS4oi9qtP2jiRlK7EybsCd2hTzcCLRYyYmHhWIFRGgOXWiUEx/hh68s9XXAyl4jFI
         zEqD1/FEkTHuTAldm9/pq7PdEl+belD7pRW/KMUlK7XsPLOWmbbCF4FwdQeN3KQbz6mC
         28Y4sPbfT9UiduRsBU7b/BvGXlrPUU+k8vVCLEiqXKXW+Ye2YMmvoTHLwsnCGZmChe8R
         ab60jaL1QaZHmE5fAjS7ZfbdqqgmtWODEbxvyUilfircspVTKNRY3i8xFy0uqtuXGpCS
         Ho+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793819028; x=1794423828;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DUcpgfrjS6s9SSnfNEZAg7l7UHGbgZn+gcmgz0ne79Y=;
        b=nyUjqoVPDKyT3RhhFZfEYBdLGI2e9myPEUBQ8PElydssbD9lgsbUaJz8aJ0fJvKPKK
         azS9wvwfEOg/d7NFQF8dA4QtoHLbGFjoztUgfLEX5xR1n1ei5akUL1w/1JeDxy6tVtgm
         or1C9pd2OrpyWf4pvp2YmiWNcjn5T+wBsqfsofUsRcT2fehMBEhYBVrlLyWYShSD/r5s
         ZrD0nLRTOiscw2PFRuziIXYaZCenqMZwF51dD325vRWJVTpq/FfalClS0+CT5qVKAmFr
         Kobqtnc0fuhQCtHi70RWRUwRnYSuqCPMLGamti0TSt3Y40s4LkWxumixOmK/Bz3A9nGZ
         sBOg==
X-Forwarded-Encrypted: i=1; AKwUvBwTkSqdb8ISXtFzxmEYAq8tLgInKtpBvezxFlsfZzM4gC6mMryDBzpl8tpgUuR09b9bzwWGLpw/WA==@kvack.org
X-Gm-Message-State: APuU4Z9/cR3A9NCQItNTWpg8Dkdo8uIoVjk4g4HDsZX8qRhtJLgwYlzX
	h5qJ5nq+vN2aFZSZiv4FCvSEDuuNH52/EYEAw4GKgGW18+AnsXe+b3+aidtNjVmDJpMnJW8IYpo
	lgZcuX88RQK7kndPernBIBBCfJfUQw1bh4g==
X-Received: from dybgl9.prod.google.com ([2002:a05:7300:e009:b0:36a:c06:2852])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:3d17:b0:36c:9af3:22f3 with SMTP id 5a478bee46e88-36c9af33136mr9263147eec.37.1793819025727;
 Wed, 04 Nov 2026 11:03:45 -0800 (PST)
Date: Wed,  4 Nov 2026 19:03:38 +0000
In-Reply-To: <cover.1793818636.git.abhishekbapat@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <cover.1793818636.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <64ce5ba6eedf0950c22d1416b794e83afbab8ea8.1793818636.git.abhishekbapat@google.com>
Subject: [PATCH v5 3/5] alloc_tag: Add a flags field to allocinfo_filter
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 3tiowndqstg6qha5g9t8y5ycr41qrhtf
X-Rspamd-Queue-Id: 162D52000E
X-Rspam-User: 
X-HE-Tag: 1793819028-511183
X-HE-Meta: U2FsdGVkX1/BtycXrIXUAl2E9qFACIGsq4dpEI61xNAylq9Lrvc8DcF4/DMLPUMHiSRcSXr0qUEDEaAtf7GNBgW3qpGx1IUJP7wJSim5YuBxos0UemPea2Ta9LQTc/QSuY6k56D3toKhpsnarUM0p30DmzbmJkwstTci0LIj5/LtkokCqBasSatFib7TsLfgyUe7rZsZGG+GDE+m208HnMiUNvig5JaM8ocWUizlEtfQYv4WTArKhN0hXN6sHXR291ESjGd7pPaeMfok2XvpvYE0/jD9o0uUT9KLCLbulhjdXf87czMxZj1+2EmYyTs7I0qn8ixTUmHwz7KP6kPxFHCV1+lvgGv7w8dOzd4kR+hhPHGDzZ0Y6KMxQ2LZI6+Op48oPMEjohoMM2OCd2eaxFRWI39nF+C4ZO5APfDMjSskQWI5tm6Q1IA6KIm9T9BJisuFaBtigl/nRoE/jtxGMuCowCJ1MfR+LQfjdeWJ4qXjy55+oH+4k5uF2RR8PqgkyduRuD8ZahkfxY16PwEyogi9Ba/k12TyLYMRCVZjrOd4XLJLbcf/sUzRw35jdYYXrv2/JM8EX5witHsaoGyk1LhgFl14xViTMxjuFJcuy1txDM3Bp/HBsHVY8IGbfWMKAQ4TCp/BLZCe9uaB18VS3hDCZZ7AqkYbu69V5YCukl9nky2leCyZf5hOgdUmO1IaKjOfVfNTAkcoFPKy4jdfnqqeKnBRLoecH12/QgDqZz6OpF2g2yL5AVxKZkGyuRiWBg+5l2GCK68CbI0Qtqq0IFqrydzO25GCnUuzfKpP9bebM6X56tbZyBFGTfXJIc+dcxH5v5+hUTneIJ6atrNtLbkEXYylwmdCBzs/PTKO7AN8W3KNyJ4swkfoUpuUoU+2fpFc7HE8zpH5voHXZYhutaf0LmRjchY/jP7Gtj5KNejAh+6NSYgW+C88jivtz5mpZDqwdKX9WL8yc+MHYHs
 K8GZioet
 gE+0PyEIharPbbhh4C/nAyksnzN7/Y0FsIyEEcJadFVdHnFQQk8CymljWwAN8WJ5Xh/+i6iYisJakWCrlhgje+7sCMS4eeCASW85aX7Hsr8tEHnPlDReVL9/JHatjo8yEBX9YeXtI3sUz4Cn95jQ1NoFGFeZqDrXSYnyAwxXI70+YQ55TCLdWLinXBp4+I4fFLgcR/MsFvYdx5n0zZBKI1LV9Tt8QKNyLarxAkVIVfCTRUw4sskwC3DELPBtxvNhWubnxy2eHRPCMrZwBEaD0bJRcN88VmIu5NtG74Bn/Kx/zmpKHuY9W7bmuuonfHhxI3CzakWtfpxa3REVPjnEUeXGe0GpuoD+zs7MYNkcTg9avhDNX6cGuofCyGH8hhUruzbliWFZom7fe6pKR/9MpqV4zAUyGFyDywutbnltM+AUHUkX2ek8gAOlN5PuD7A8IzIJdrl/PpAUpcqJ536lUuj3fVR/3h1jOppyCMVfA3ibAyjUwrhUTraf6kSuHa9hbMV9D9ftWvP/YnmKWYc+IY/fdkKmB3p8EO+yD0ESZxgT91TIATcoP6OW3YSPB8meY2pRYqr3eBPx1zFMt0cEWVgptZDOmQdI7JvuaVIzHiNI6c4gGEjhWrum3B5af1+crVw6wve2L/1p7b4t2sjEYUOfG6VU5CuJ+MWeJokGpuRSAaZ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

struct allocinfo_filter uses a whole __u64 to hold the single boolean
used by the accuracy filter. Adding another boolean criterion the same
way would grow struct allocinfo_get_at, which changes the
ALLOCINFO_IOC_GET_AT ioctl number and breaks the UAPI.

Add a `flags` field that shares storage with `inaccurate` through an
anonymous union, and use bit 0, ALLOCINFO_FILTER_FLAG_INACCURATE, for
the accuracy criterion. New boolean criteria can take the remaining
bits without changing the struct layout.

Keeping `inaccurate` in the union means userspace built against the
older API still compiles, and the values 0 and 1 keep their meaning.
Previously any non-zero value selected inaccurate tags; now only bit 0
is checked, so a value such as 2 selects accurate tags instead.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
---
 include/uapi/linux/alloc_tag.h | 16 ++++++++++++++--
 mm/alloc_tag.c                 |  2 +-
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
index dafcba2f7e2c..2fc843bb06bc 100644
--- a/include/uapi/linux/alloc_tag.h
+++ b/include/uapi/linux/alloc_tag.h
@@ -68,13 +68,25 @@ enum {
 #define ALLOCINFO_FILTER_MASKS \
 	((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
 
+#define ALLOCINFO_FILTER_FLAG_INACCURATE	(1ULL << 0)
+
 struct allocinfo_filter {
 	__u64 mask; /* bitmask of the filter fields used */
 	struct allocinfo_tag fields;
 	__u64 min_size;
 	__u64 max_size;
-	/* filter criteria only; see allocinfo_counter.accurate for actual accuracy */
-	__u64 inaccurate;
+	/*
+	 * Filter criteria only; see allocinfo_counter for the actual state.
+	 * Set ALLOCINFO_FILTER_FLAG_* bits in flags for the criteria selected
+	 * in mask. inaccurate is kept as an alias of flags so that userspace
+	 * built against the older API still compiles. Note that only
+	 * ALLOCINFO_FILTER_FLAG_INACCURATE is checked, so a non-zero value
+	 * with bit 0 clear no longer selects inaccurate tags.
+	 */
+	union {
+		__u64 inaccurate;
+		__u64 flags;
+	};
 };
 
 struct allocinfo_get_at {
diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 9ff9dd04d692..504c1a85050d 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -306,7 +306,7 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
 
 	if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
 		inaccurate = alloc_tag_is_inaccurate(ct_to_alloc_tag(ct));
-		if (inaccurate != !!(filter->inaccurate))
+		if (inaccurate != !!(filter->flags & ALLOCINFO_FILTER_FLAG_INACCURATE))
 			return false;
 	}
 
-- 
2.56.0.506.g506a7eabc5-goog


