Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E744C982FB
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 19:27:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8CA76B0005; Fri, 16 Jan 2026 14:27:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D39E96B0088; Fri, 16 Jan 2026 14:27:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1C3D6B0089; Fri, 16 Jan 2026 14:27:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B06176B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:27:21 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 583A7C10AB
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 19:27:21 +0000 (UTC)
X-FDA: 84338810682.01.A9EE361
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id 87E0320004
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 19:27:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cw01Huco;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768591639; a=rsa-sha256;
	cv=none;
	b=7GsgKav3McEGlypTLzly+xro4ItSx0EcWFtf5nBsgAPMNrVIpWTSw4U+r2Y+ddSd3XikHN
	4TGWrxHM+IdsxAHTz6wtvAgjRAY9ud9ZNOUc7ITbAXwhoIauTfIKHmGsuDPE7l/pUmjfpn
	0s2Qo+/hzjLZvG4P/X6GYdj3NqqterU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cw01Huco;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768591639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uTMBfChikiIcOHf6FYYpeyBEYYwNF4nP+fKI7jaBDyU=;
	b=zpjdl/paeppm9xjXpIKCWEINyduvly0pJeGJuHEUWhDFCIJLc+2vmAKfvUHgskfBMDXF1f
	ENq6IqhA3hGaWf2eqs5C4VFG746/7gJEpJW15aIa2dcbcX9rxfs26EUL5SwNYYb5U+7Sks
	urOFBxk48RjooDyFWUuk0qExXF8GSEo=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-79088484065so23816387b3.1
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:27:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768591638; x=1769196438; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uTMBfChikiIcOHf6FYYpeyBEYYwNF4nP+fKI7jaBDyU=;
        b=cw01Huco06wFLUuhc2Tk9YIWsD0Q5v6aavFwS+g5ubhWHaxRVXyMVXZZgWK7WC5JIm
         H/k2MfhxKFEaaHmiac2KjqZmL/Np9BXu7sr4yeV0U83EuUwsguJtvbozpk3tz50OKQsb
         nNcsqKLjEFJcjrz52Dodj/nbozBDQP5SQVETjHct9/sJMIMf2Kmzm+3wNLtfF+aYyejq
         4Yp0s5KaMpN5l+lTs1B1l0EgW17WsDhQ1Db41dvrhILMmE2+XQuP+LgftPwd9p1JuNit
         38PgJuUiU1BbU60V7opZj7JQ5toXy/1ZfsZWq/5FTiedZJ+j6lZrDeHHQ15Ef38XhNxk
         DLuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768591638; x=1769196438;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uTMBfChikiIcOHf6FYYpeyBEYYwNF4nP+fKI7jaBDyU=;
        b=mWjy3EXXZTQSsu0/JeVTVFYdX+6PgdxCG1UsOExBBbVYMeURkEbbN2qGxXjIPrVOo8
         u3pGgf/EaErjq1QQuOTzaA6vPvnjkpG0LGuML5QjbyIP9RquovCZgjwHapvfKSlbPNCX
         3i3i0dANqRPBpM8BMT3s2DfmlyGcvizW7uAd+CaLT2AjyXafC6bZIrXn7hLTUa4pjhQ6
         e4AeYxLe3HlnP47jlNmrrdniqOFCotvrCl1GWjoHinbFI5U6YWP0XkRs5ekzedxfGosj
         58wa+q+JA8jmaR9ASG4dLwilSydRkKgVoBvKs2MA7eCtj5taSxygVdlWw4tDDbGWnWAo
         1SDg==
X-Forwarded-Encrypted: i=1; AJvYcCUup2adiho2nhOedpzfhYiBltLP8ep7F0qHzqqDY6QH1OcnOhKuN4m6wNvI/xJ2YFyJFhwEV3gFxg==@kvack.org
X-Gm-Message-State: AOJu0YyH97CFCFNqM7sRFMaMjTsH5bSmyNz3XwA8ukom6XND0C+lYKne
	CeURDEebhRgE8CWDGHn5J69ac4iphJitJJJNtZ9keE3Moh2EIET34Uei
X-Gm-Gg: AY/fxX4b0Tu9Od7kZlG20nkImXNwpNDoqICtrj0/jhTX+BaKzuTTJRMAv1Si3vWDe/f
	4syxg08z5YgBQl0jnZuMyjMuVO70f27xNSFhwVx+zMahTr1Orsl/AYS2pAN+oAAHjwPiKCtPeKO
	iLNITYzN+5AJbxwADqFfiMv3GRIXacpYnhDRKyIzRb56MpY5xZ6OyGH3BtUADOrzeAu7i4ISeqH
	aRSgQjcd1yjgpBd1Gp6+LwqYVpa+SVl0JQxJcE3wxBzEMPkQBvAoKB2SPoxtNlcfX/HltHs4U44
	w0w0J8PL1rdKOUtdQIMX6tixi5IqPWP9WaKfd7JXLzUiFf+8r/cH3yoavxvtTpaYRbXvcVgXYyG
	1EzxSXi2HYouEOi2pw/3xQXRYDTZZsJ+4cNMYvdQnjUIrp/yfe1tszXb0jGFXhxWmwftZf943y6
	RRs1kdNROa
X-Received: by 2002:a05:690c:398:b0:792:7745:730b with SMTP id 00721157ae682-793c53851b5mr78967317b3.43.1768591638464;
        Fri, 16 Jan 2026 11:27:18 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:5::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-793c68312adsm12088897b3.33.2026.01.16.11.27.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 11:27:18 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v2 1/2] mm/hugetlb: Remove unnecessary if condition
Date: Fri, 16 Jan 2026 14:27:15 -0500
Message-ID: <20260116192717.1600049-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cbqg8i5ditcgxegtgzp3eky91goose3j
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 87E0320004
X-Rspam-User: 
X-HE-Tag: 1768591639-427669
X-HE-Meta: U2FsdGVkX1/h20TXCoW1bdfuxzXWngKQ2nALh1a13Tdpk70spGb+nmvjZROOQJa1aZQHEXFzp32R1tjSbo5mNDWvWnaWCwL++PLgrJhxRdG/kI40/vQfwW32rj3WcCnR/4B5PDLmSFkKl/6yhbdHEF15nqs4KaQl1pkkNZjnrK8m2MVxKT6831W2OhpNcKIRnR638Ex8WdCS0Pp9qybrxcah80RH3ySW3UdfDdsL0kwbb8EUAtQDjQaLV1/ct2sRi7krY/5oD6UcPPUEjFmDrr3qO3WAxIDt2E9bA9EvvZLh7RCIAA8cyLCxywhJ6YRKf+81nK9IyXDsPC94QCfmypTFAt0R+6C39rO5flYgtTZPf4tpw+avLTuU0L235XZiLlQFP9+kgO3TeaR4+QLQSXAeHBuo2hM2SNsAvm+7KBTfCzZEk4/1AT6MEKmaw7k5L+km1NJPj+Nl3O2ZlSYRKev8FPnuoDAoO6TX3GlYzi+tSrjMtkc6qNj4SHvIVer2qeijc14dbaCgSUGheUtoieMPdO5xkIZF32WYvwC+ZMuKXx6BCZrfRkdoa0ivV0pJbg9sZ5xdcMcm+tkY49jyAX3LEcOoHRu7xw4y15nIGhQtdKnoGj8b1fgS9b03LBmFSBYPtMExoQI4t8VLsFAnSk+TXZDj2cZ5qKZd54aG2DAI0wjemlM8+ACqYhTZN5tnDVVPVZwfiNCp9qGWOqLLOehkBWgu6TfbshDNWHQ0ZgLhTAsyug0bxEB7m0eBmWLJ35owQNMlHi8RRqeb51TzWLoj/9edYxcrU7hC7GajA2VZfs7pRHYIl9szzPg2aWAFWPvMr/DwZbBPgIAWsXDeMM5KGAYsk/dJ6kCnDF2St1jKnnpuJFulbYFpgUdIlfdpquA+fq8raVnfXxc53Fx0sxgjsLyA1wV+JC6lIkVBbKgdoOagpujpCzu2lr+eOm5o6pWO/JsltAczHCpI19i
 1jbTnyCO
 TFrFdGDh96cuRfjujXt1W1VRbrIz6TwybcjsvIF3lSJ5fVnh02BVty+61r7p0O3T9ahH6mhVoDPH3S9hUXKFHOlUUvDgTT4xdkT0o/5PqKiE200H8a04TcafIlrPc7K/Qt+rFPPaEqfC8k2WqGyUbobsFUJI8Uky6k6Ny7VEFkv6bxUuxhAGnGaBXvRDhGBRGxHPEmcV+YiQ2w095RKSpTHZxnEDxZKDomLmqWjcdQniTJXxJkVs9sEnMSYmuZiorYj5bWE7w55dNUkUm3YkSPAz5+nMc+VRUN2uIG8PVUz/1i/nSwTroVpQjMEmNluXvKRZSJRKVaVRd6zViK1zz4h2BaITlaHb/sBXWg0yCM6ctzaGs+yy4ztI9pD8V+JAY/wxFwZPOGEn2aCXR/mfk+wl53Dec9BE+uob5NWOkZxtBpAoV+BgL6jVR4SEYN5khA5oxNa4m/jRNrR6xDJunoOVj5bh89RQq/nAjwD3aukDqOpJm1kI2++8KU4jCv+ebhhNJUZ4iu0AirMk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

if (map_chg) is always true, since it is nested in another if statement
which checks for map_chg == MAP_CHG_NEEDED, which is equal to 1.

if (unlikely(map_chg == MAP_CHG_NEEDED && retval == 0)) {
	...

	if (map_chg) {
		...
	}
}

Remove the check, un-indent, and collapse the function call for
readability.

No functional change intended.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
v1 --> v2:
- Collapse the "folio" argument into the line above, as suggested by Andrew
  and SeongJae.
- Explicitly note that MAP_CHG_NEEDED == 1, as suggested by David.
- Collect signatures.

 mm/hugetlb.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 5a147026633f..2e5592c5cbb2 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3028,13 +3028,10 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 			rsv_adjust = hugepage_subpool_put_pages(spool, 1);
 			hugetlb_acct_memory(h, -rsv_adjust);
-			if (map_chg) {
-				spin_lock_irq(&hugetlb_lock);
-				hugetlb_cgroup_uncharge_folio_rsvd(
-				    hstate_index(h), pages_per_huge_page(h),
-				    folio);
-				spin_unlock_irq(&hugetlb_lock);
-			}
+			spin_lock_irq(&hugetlb_lock);
+			hugetlb_cgroup_uncharge_folio_rsvd(
+			    hstate_index(h), pages_per_huge_page(h), folio);
+			spin_unlock_irq(&hugetlb_lock);
 		}
 	}
 
-- 
2.47.3

