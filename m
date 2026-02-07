Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CE29EE6B7C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 08:17:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1034F6B00A3; Sat,  7 Feb 2026 03:17:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CB0B6B00A4; Sat,  7 Feb 2026 03:17:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F19156B00A5; Sat,  7 Feb 2026 03:17:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E1D4E6B00A3
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 03:17:03 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AF910D5CA7
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 08:17:03 +0000 (UTC)
X-FDA: 84416955126.04.E839EEC
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf29.hostedemail.com (Postfix) with ESMTP id 008E0120002
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 08:17:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=daOz91y1;
	spf=pass (imf29.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770452222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xJyWfDVg0o3SBi33JofJIZ8UeyAfWxaA6T2+Wopx5fg=;
	b=CaaJ5ud2qCGMJBhqe5Q+M6KgCXcEB7vTjG3Y8f9uqdOA657PejzFsG4gQSuO6Ex6VBz6NU
	Yz+vmCZZEDPTfK2WbXOoN9apqPRY2t1PcEvBwSUL7DR8Ihep7ZcMZBO5Kr/AIAUNsCt0Oe
	ogMCL8+HattbYt0PgAAJafr9fF3xVtM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=daOz91y1;
	spf=pass (imf29.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770452222; a=rsa-sha256;
	cv=none;
	b=qbgWLdgrzSMl9vpVkTwbGWm1fzGBw6qmaCOlETAWF345nhFjXy0wYkvqV0nF2SmOILBsEk
	+nfaHKQ7pvBZTiHu63rVju9+zmWSyX6EQbGpIsWrpL51tb2nuH7LahTLSof1RH3/w34P0w
	+muu7MbcmUYVNDPd5UUeCLH8IEudMu4=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-354a5da7910so1291475a91.0
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 00:17:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770452221; x=1771057021; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xJyWfDVg0o3SBi33JofJIZ8UeyAfWxaA6T2+Wopx5fg=;
        b=daOz91y1Zp+BupW2b1wCI4sa+0ynmZxIOfJ+BDH32CRX7zAdSheOZ0XO2GD8Mtz0OE
         42RpdqrjsAJQABBzgODWtuAYfiSSBXDYDMrhp/J2CzRStNJuLEmvzzfwByWyq1Fyqd2S
         5L33fZllCdgv+ThlfBzyHWfqKNPESBN7Ey+nTRkozcn9Q1qQYTXf/TAlO6EizTnNM1l4
         7Pv7+754lAGVkDzDBViYndVJeh5byAs+jKt/8vrACuXLTAMjAGYxT5UctsFEyV6EsThZ
         VQl/kLR5AFsBIm6OsiDiJt/Cu6LrEMb2AT7svNvFXsZo9ldli4pq3IT8L4lewUtNS59d
         Yt1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770452221; x=1771057021;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xJyWfDVg0o3SBi33JofJIZ8UeyAfWxaA6T2+Wopx5fg=;
        b=U3xRJxotANZ3rOjS2OE5NakFExirUzhdbHBVg9VL/oCe9kFrsdGhVYwlOvPiWklVBG
         WF9+91ZWR7NOmNWrjyGzZWp+3qJT3u/Fr2bCzYI6ZtXVJBI3A2K/+m8PCJ5Di90z+vuG
         nV+a6XwF8wnaEVG8UC1iTyE4t+ByJuEMs/MPFJqY8M2NSaaQwE2s2fGQYojPt4n8p/la
         7r049VuAS8Dp7+0VG/D9d9V0aA1LuivmjOU7KzPYJaiu9oxFaNY40WgfgQvnx5+vyVqT
         Yv2ySk5WmKWO6hIJgqEfMyhD6wwac/n4tP8WPl01QUXMmW2Le+6hV3zC1Grz5Dmzu69U
         JILg==
X-Forwarded-Encrypted: i=1; AJvYcCXwdq9caCRIXSpUaSd9b7XyXGr5CuGEQbw4Ftuz4aQX4DjvvptQad1ElrOKGw8hJtK3SzPZ2qjhjw==@kvack.org
X-Gm-Message-State: AOJu0Yxq4ZTPPfSgYJZDinNlBs8vhleOYm9zxiSe58Um/vorgsrwXFeu
	ONiNorMK7E9VhIdxyTRceB7IIxMic4zPmlOhO1O3wD5jvelG0IO3+pML
X-Gm-Gg: AZuq6aIRe6pFp/yoUasE7aiqhLg01Tiou0r1stw2B0896W4kRDLaiIQVUBtiHDnZG2y
	HkQG2ImVsOkbLUjRErPtH2zqByfoedy0IM0zGF0CTmPhkw26nk/97Zu8gJEM2gafV//2jriaYKi
	Tc1wgOIhrUHHi3WzCdy/0ve210skvOLJeYbW0FqKaRkH3REOA7Q4ATroKfzc5p9Z3ksC1BsIX+e
	Tlduhape1XDI+bVDXMNbcxLUEnNmnCAl4BrMzoZQ5g5UgeL4GHzRYxy6R6uuDXDg3W+Ak1jEdSP
	IMJ55jEqeWM3Brs+0OZ8QUPjFxJYMaUfRzuM9YQpMiTJOhKCZlv+ejVhofQamR8VM9Kg8aQxLh+
	dfmpC0U1SiVU5RP+h73u/fm3AB7/pfrUJpGiBstXq/IjBfNBKR0Orfx/Wl/Liq7IK3tD/0oFBqw
	8VOsKq+M9AAnZ0gxLgZJZJuIs=
X-Received: by 2002:a17:90b:3d90:b0:354:bd08:4812 with SMTP id 98e67ed59e1d1-354bd084d2bmr3021238a91.31.1770452220884;
        Sat, 07 Feb 2026 00:17:00 -0800 (PST)
Received: from localhost.localdomain ([114.231.118.96])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3549c5955a7sm8028189a91.17.2026.02.07.00.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Feb 2026 00:17:00 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH mm-new v7 5/5] mm: khugepaged: set to next mm direct when mm has MMF_DISABLE_THP_COMPLETELY
Date: Sat,  7 Feb 2026 16:16:13 +0800
Message-ID: <20260207081613.588598-6-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260207081613.588598-1-vernon2gm@gmail.com>
References: <20260207081613.588598-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 008E0120002
X-Stat-Signature: dy34nqotux9zyoeqkqrppocemz4krwaz
X-Rspam-User: 
X-HE-Tag: 1770452221-291427
X-HE-Meta: U2FsdGVkX18i0xgVoC+utkrFHVC77Joi03l3Uw1kkzCWxkr17B3JF5ZC80Xgp3XyanVAqmMlLafpyzW9oI7titqNRmx6Pp5rCaz3LgxbSX1G3YjHW+9beShKR4UIxOKoNvzQsEl6kMXLC/wbvwfkxwOTD9mwHRwpnoIP++dNXr9jijPBck5amDOfyElk3B10o5JuMDDfK7JGHufkiU+EGNLv8cyB/vqH0AtKBqH0g5bC/KsAgJq48RKIWO0zMVFTZBqfIUkA5wWR7+Zt+GFbmQTBuRXuY1dDxnuFu8kwXOq0KZcH2m60jp9tW7u/sb/6RxiugHnK+1xvyKScFbceS6PLh5WNthf/HeqxXUJX0OBgh49YrlazDcHX5RxKB+++8kiu5oZVNm3kBRsC8ZnFqM3HkUxcDlgAKuUAUXed2VlAKeMjoZ2gtKY+AoMSi1RmiFfiftwJnpNT9DLZbVEZAos5jzvsPlrcLyYocSULfQVzFDZqJ0UQbXx4BKytfiuAxVSh0gZ24kaf+5jnnzqqdzifcX55GctUBaNVkFODvrKHvy6zVsG8SWE2LdkEMH4vdm90iuQQiNFmYvemLeMw5+XdF1v6RZJYGbfA1JrH+28WwDKN9W6VADOjydnYcIaJ3kAYAvCdSF4EH2w6bPfhVdG/+jJg2HGc689Zv2w/xaNQiaXUx7nuZ4i1YSp8JQSctimw++lF2A3SJxpXxe6vcprcJ+FV4cO1x4EAC1BSZE3D71fKNIIFMgn7WULr6+RQVtfxxeEnZT/y1sZv2YAus3W7fsfYR0E/tXBulkgi8qrjL0jqO51xUgnVW2DhJeqK/++udExdgu46NuOAVQFQlSd1VGIGJMDuQBbxdGNZk70HfJSZEtYSiGkH145I0dGM9suyz+ZF79QCw1KYKouPyTkNIEqQPpoyGBTRNehxVU1PUOVoFXbfk8YPxk7CMDQtEQwmATaV88VstcZQ9A+
 xwAQdbMZ
 a9/VvRkw3h1VGP+abfHMWsr6KUQkzmCwzOKCYtKr1A/5faxGuwEQKNwH8brAoSFIV+8DE9MS+DoKayRE0q7ujc3lMjZ8EBE9nt8DTI4h9eISYH9STLIvoKFAs2v6S5nOLhXmwMyxRm4QvFY/3KDzQKg+sAC7TA60T7/J1M2K1HVMMlthVG/Xic+fnVFrHpoFDCa/CyYDhfJEILZ4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

When an mm with the MMF_DISABLE_THP_COMPLETELY flag is detected during
scanning, directly set khugepaged_scan.mm_slot to the next mm_slot,
reduce redundant operation.

Without this patch, entering khugepaged_scan_mm_slot() next time, we
will set khugepaged_scan.mm_slot to the next mm_slot.

With this patch, we will directly set khugepaged_scan.mm_slot to the
next mm_slot.

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 mm/khugepaged.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 0d160e612e16..b3854d990fd9 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2548,9 +2548,9 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 	VM_BUG_ON(khugepaged_scan.mm_slot != slot);
 	/*
 	 * Release the current mm_slot if this mm is about to die, or
-	 * if we scanned all vmas of this mm.
+	 * if we scanned all vmas of this mm, or THP got disabled.
 	 */
-	if (hpage_collapse_test_exit(mm) || !vma) {
+	if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
 		/*
 		 * Make sure that if mm_users is reaching zero while
 		 * khugepaged runs here, khugepaged_exit will find
-- 
2.51.0


