Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD450CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 15:44:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3405C6B00A1; Wed,  3 Jun 2026 11:44:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F0A36B00A2; Wed,  3 Jun 2026 11:44:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DEFC6B00A3; Wed,  3 Jun 2026 11:44:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 09E656B00A1
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:44:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A032816246E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:44:18 +0000 (UTC)
X-FDA: 84839022996.27.2EECC4A
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf16.hostedemail.com (Postfix) with ESMTP id D0B0D180002
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:44:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Wuucv7PV;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780501456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yVlCXZe8SHDSOJUkKVBaYBikNvs5G4Pkl6SfmcOaAr0=;
	b=dqRMkWuPBAPqFSNS/g4dALM/YOsCnEySd0LmtrezM5iKmaQ0jQBE8ICZHaUmq5QPY1M3h7
	XriaTP/cBNmgSJqVJ6K8WcektstOY/J2Oeau0cp7LgpGLhbUh7bySQBGGfpWmvRQ65b9iB
	bljADmVR/4C74k7x0UyqlpjY0NY+Mvc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Wuucv7PV;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780501456;
	b=1FFbdkNSPeUQUDdCioCfeFH46Tc3pjqK3IC0lxaOxywXrf9Iwgg9TiIQSSr/PqjIffmw1/
	Q1IqGnBVk4xuMIyA718p7jUcnKAaqNjhq1nVTIkd+iv7dibVzVv0OIZilAk4n7dp/gLNGU
	i9TAXhEqvE83wcyunIzemh/vvjg1Lis=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8cceb2ecc03so38379626d6.3
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 08:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780501456; x=1781106256; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yVlCXZe8SHDSOJUkKVBaYBikNvs5G4Pkl6SfmcOaAr0=;
        b=Wuucv7PVpShnQEh/lEaYKeHYDLJm39PCOnkN2RTZe6iT37unqcfM5VIYncgwKeMPZE
         Y/lRuq+KV4n2y5Rae/YrErzkPKitELGwLrfm5Fx4SBuY5R/bI4sXKRVjaSj0QmBDhLMV
         c9zeF+ARtWN6z7yhHq4rvBnh/NKhw3abMLJuWGT3uIf2Ulea5hkO6FM6Otu+QEH5bZ6f
         jpDLevdaAAaE8/GafHxt2GQ5y1cD7FjIS2IrIJKg22IU51G4leyWGX6IZSUQr6C2J6jy
         6+qN2fipyHKI/RL0WuChrq3S5fUWNnMTw85w+MDzJX9m/G/kU9sGJ+C8Ds5fd13f1zJM
         66xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780501456; x=1781106256;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yVlCXZe8SHDSOJUkKVBaYBikNvs5G4Pkl6SfmcOaAr0=;
        b=miF4v1Efg8JQcdns7hvTbNtIdJYiHsHY9Ro+wlLLB/dwrOULnkPhYrD7oO7sua+C2f
         AK+6AGYhdWAI/2oZ1tmmalwqPXiK8FtDBEf0cY1AjaPbK7G/7EdA6AXHI9VGvwfpK9tX
         sP39CBQQim3XCfiHsOxA5gzlZGDYKocd+iTBc2F9nnle1ZzX1jGTI+aoyGkDaJ2pDbV9
         NjYO4xz4vFQw9PMKUewm7huUbPg0rOwNSKMf1DC2FispwIlKwHC+9VFLTJ16aM3HWh5f
         u19JrP7u1dX2wl+1PLeqvSRRhdiBDG1GlF/e2LpF0mMYLtOt6L91wpKR7MgVHdXisFPI
         6Ldg==
X-Forwarded-Encrypted: i=1; AFNElJ+2/JCxrnQgJvBReMm9npwHoKqjK40lV0y4Qx3B7JUsjflBHLaAFUY585pr2G5ccfjHFP8PxCbj4Q==@kvack.org
X-Gm-Message-State: AOJu0YzO+BZVYHKmJa7zFwbuCTORGlrH86Z9hpk1PfhyoRWhTgKfNcl7
	hJj7ESvYMHC+hxbsQCf8fapBBhM9dA1t1BRSCGym5P/YPkv7gsrEznIwobbImkQHvCE=
X-Gm-Gg: Acq92OEL7NPClqZ0V0Pj5JdP/LCDhPNHINpz0s8CBY9zHvwQBElGnCpDg6YTypx10CW
	x+0TwrQAdbjzw2elzWLjMp0mkl7HL2cdHxCJgTjUrM2Mmpz2XqMtbxj2AHw8pa6yfNpsdBR0XUU
	/A4e3X5NW2eOqzQQoiF868D4xnokjxoF9tq2vs2UnGR0fDBAZNvGJLHRkEMNQr1BmduHPBhy2qu
	TA3VeLYxFzegGtobrUZzNy1HWRjE8wPtJg9nybvHPQljq9XIBPrRjFW2LQDmJDfXGPF/43jsY5c
	AwV6Gxa7TKH7IT+wA0xDRhTXH7hu55EDKDilvEHmVP6coCoPpDoYkpO9s9Q9ojApJZBPDec4Rfl
	6OyMchCveMrufVFoV+p0FOjbHhK0pOr0Nz0icqzuBEPEWYvFSqFyhntCvPXwiKdQbHF6Tku2tD3
	QR2YyQol/9kaAcSRUg/m22RUjKwcFeYRXomiqi+xXvWjuFjkaizWk9TjTVn3jiXA==
X-Received: by 2002:a05:620a:2890:b0:915:6cab:768e with SMTP id af79cd13be357-9158a849a62mr658252485a.60.1780501455872;
        Wed, 03 Jun 2026 08:44:15 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a40d566sm266574585a.47.2026.06.03.08.44.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 08:44:15 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	skhawaja@google.com,
	graf@amazon.com
Subject: [PATCH v7 01/13] liveupdate: change file_set->count type to u64 for type safety
Date: Wed,  3 Jun 2026 15:43:50 +0000
Message-ID: <20260603154402.468928-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260603154402.468928-1-pasha.tatashin@soleen.com>
References: <20260603154402.468928-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D0B0D180002
X-Stat-Signature: 55wyjpy3idymz4ipic9i9fwcagyhmdh1
X-Rspam-User: 
X-HE-Tag: 1780501456-741335
X-HE-Meta: U2FsdGVkX1/wlh16WWggeregikHIMPk8I5r8eq6cYcBnKXDf84FpohLYO854W8DHl4rgEeJ5mykpY+YQGj3Yw749shgke0EJcMU/3iU8aF0VvblTXCJ8j1uj3QZLnZMdIp+d6kNN/cx7MIpXuKvu3IpX+zUZZbrbEao7PaGehatCmrzmxesFoeZEIvir9NYUZeM4x4sQAaOHmdBCXROGxulORB+H8M/jj4BeH/MDDZoVNhcJl7HNkVmK+sPOPgp0Vqi5eR2GiJdDw6OxxHU15DjQ9097JP5/i/EIngylr/Lj48luqI7pUTbixJGqabS5elQqe/Dpe/AsdCWqu4n4pA+TUaA5Deosz5SVKT6X1xYEsZUPmKYW0bN1X0K6l+EPUMKeZ8G7NEY9P2fxuBOWyAN5Pcj5ngIC70xbt1Jtdx0zuETg2kFzOqN6kxngF5qgMSOo11riEkPB/kTi6eD77rvQZZ3q2rTh/KxQ1ikyg+lzZFDbKGFl5ypa0NOmT3JSOWiy4wH0gTMUNolipohgtlcuV+8FPwYrLpMMeqNSIdmboS8PipeX+wsBzN5ejft7hvAsoEP1JQ1jT0BRJTztjlrvKPK+zL2axmSSPG4kZh/Z9xLTntP4v9TdE8kzeda2ZyuoSBH7kYe5Y2eixkrBIEpPrCvWnrNZMjMTnSgnRoKkSvxJmPYgsWBthnxL8TEc4cQf986al7JZpm4gN6KVmT6DWoZ3Bz9Jx4qOE3QLQ1AjtVarrVAvZKm0EaoSfyadilYgLv20lVnx2bAwB3+OB5ZORIG1Bq//3G60YLO3R4l/38kGh1Giv5sVZa5oQgo78QzQaBu1pVICZTvFJdxs5h/lRFWtHI8hyhzwHiH84S96kHf2yiMp7TIpyOhIoHJKsC/2Ne2xMt57Al3MrAa2pHqKCh20cQ8+FODNgLHAaSqMtr9wmbeC0Zb2fo6uDPE4J1yeSymAIy9nmEL+B27
 9NMHiUWg
 fKMDoYP38O/OyxeHsUbhFrTl50Uli6IzxExBK/E3wGsAnCuGeHQq5QLM7uJD80gaJBHRnUl/GkxoltKq+9RdJDmdcu4uQRNgfiNibI0HQ5aJvrBnbvxNpH98uaoIobKy6bPq9mKMG9awePIKHamBmxBgWjN2/N8qouIcMx6nthXX1weIsFN5dyLxupFk0dEn/exIKhhriuuskeoOcrYGfxBac2ir+wy5HBsR9XPy4LbOlE/xzfHwIbjtoR82kEl/oXba4ij0fSFsgEuKSaKNdlu9QdT1tOv0982VREcDROToICz2/DAOSuQ7K9ALmpAVndKSHt7ABHxS4/YGZrvthE6aCun03D56AGzaadqmSy9b4pGjTDlJre+6k7I1jm8KJakqwWSMHj8JDVR4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This improves type safety and aligns the in-memory file_set->count with
the serialized count type. It avoids potential truncation or sign
conversion mismatch issues.

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index dd53d4a7277e..ae58206f14ac 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -52,7 +52,7 @@ static inline int luo_ucmd_respond(struct luo_ucmd *ucmd,
 struct luo_file_set {
 	struct list_head files_list;
 	struct luo_file_ser *files;
-	long count;
+	u64 count;
 };
 
 /**
-- 
2.53.0


