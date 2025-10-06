Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67E96CAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 14:46:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89C0C8E0019; Mon,  6 Oct 2025 10:46:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84BDE8E0002; Mon,  6 Oct 2025 10:46:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 714648E0019; Mon,  6 Oct 2025 10:46:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5F6998E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 10:46:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D39F160602
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 14:46:13 +0000 (UTC)
X-FDA: 83967964626.21.C63B2E7
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf26.hostedemail.com (Postfix) with ESMTP id 424FD140007
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 14:46:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759761971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=649nZTMG4mv8/3awtUVARgVLbCDTskFROC1ICZKpw3o=;
	b=QE2O0hCrlAblxAmXTE/P9lTJwwrEMXZ8Bs5Jy5B9BFTM4t/IhA/CDPslR7tHFJGRmYZqYL
	yyw77UHNo4ZyD6q+we+4QtPy5z7IBvAyjpf9UgXUFfnxip9XVKw5zwrrvyYwIWqJ0dvJ23
	XVzVemeWprhT92JXWrxhADGKl4fdw9Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759761971; a=rsa-sha256;
	cv=none;
	b=SrXaul513e317VFB9vpfJ3Qx0y1gEwMeDQSggBIUH5H8G2QVARXbd1dI5/t+uaRyajAkau
	VE9mCcFfsfSyQZnqhYfs8ffiHx1DNX3L7AE1wLSUSn4BY74nxxx24lPVNri1VbHvsUOe7R
	aLFEVcj0zgehDjDVq4WyOB1/FT6x3Fw=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3f0308469a4so2851755f8f.0
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 07:46:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759761970; x=1760366770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=649nZTMG4mv8/3awtUVARgVLbCDTskFROC1ICZKpw3o=;
        b=HtX3PuCjYbBX5fO66W4WWN7SRFFvX4yMHdB1FhcVKHJgBTM4+gyWIB9XORsyQDwB3o
         yTlhU8S3JWyL0m2HQWvrfd6dF/ImEsyn3ffsZ+FWKEE8Fwfe8m3AuJFMLiGQYJZQXO/8
         2kFpipD61hsUXTquZFFth+9lgSOhFewYYNCIBFLfWkSDnlDJJNScX07wjKmTrBYqOcGU
         1RP/E3jCZ5F4k4IKagGe/Z0iaQGhTstUVvyGKAXSi9RnupYO6eGuwyJFES3Qm7gVebCF
         7CF9KAM2b7oUAf5E3eRRd9DXzw3PY4+dtzvZR+8dSacSRuOerpbzYKNwOBEZw31qYzdQ
         UZFg==
X-Forwarded-Encrypted: i=1; AJvYcCXjcIDI19XKXyzMaVVgqprQ0mp9+cxLVvimXQhQRx/wMOrB2mKmbFapq/xgxoprALdSM7Utug3sSA==@kvack.org
X-Gm-Message-State: AOJu0YznWT1k7IOE+EygqArUahLm4leJ4FatfvEFAQGt3Jk1jtGSoilg
	ZHMHR0ByyIuipYJQhbX3bT2m6Mr/GGkVvpy6vL63d+xBXOF/HJTGfScF
X-Gm-Gg: ASbGncuMJYY3PmuLMLgQ7Tw+Tk9k5a1s6G4H6OpCXCwsUWF4EW/Kr6Dt4lp6JFjy2bn
	13CR669AGieDCKel6sxuOKDXdRVMiMdzbFntcjcIqmYvi/Hv6f7IVjEZSGNPXge+zEURxXVbqZ9
	wDJ2ztnoiBJU6ziOLXHA6Vo8Ryd2DXc0Idt8FNJ5sErZzT5b+ogrKwNJsZXtSBt56JoLzPJ6bws
	Hb0XJkC+VabG24vrqskJrHd7u0CKzVjsQF7nsKI5xboSIEJ3PKMXZ58753xDNQS2bmdgfSSbSC6
	XLAR0JKRGMk2tRXBhNAzX4X1GDaIaH4MiYig6dq+FDdd0KYDFytYpeSNPuOVW5jKada1O/1RUT+
	VAwGPVwoIx8D8mR2RrfwDiA17IzJM6anY76mVyYJb8vKO1iRz6g==
X-Google-Smtp-Source: AGHT+IHsvo1NFjf4HpsLiEoWsR+LDPyy+zHQNwaRaqIbmEz4o2SjKSjK/jE9Hcm/iL4OkfOeqSHQKw==
X-Received: by 2002:a05:6000:186f:b0:3e7:6104:35a8 with SMTP id ffacd0b85a97d-425671c0deemr8140370f8f.35.1759761969743;
        Mon, 06 Oct 2025 07:46:09 -0700 (PDT)
Received: from localhost.localdomain ([2a09:0:1:2::301b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8ab8b0sm21242624f8f.18.2025.10.06.07.46.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Oct 2025 07:46:09 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ioworker0@gmail.com,
	richard.weiyang@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH mm-new v2 2/3] mm/khugepaged: use VM_WARN_ON_FOLIO instead of VM_BUG_ON_FOLIO for non-anon folios
Date: Mon,  6 Oct 2025 22:43:37 +0800
Message-ID: <20251006144338.96519-3-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251006144338.96519-1-lance.yang@linux.dev>
References: <20251006144338.96519-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 424FD140007
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 8cagb98tzddfy9xicxrs4c7o4j68b3jm
X-HE-Tag: 1759761971-684141
X-HE-Meta: U2FsdGVkX1+mhPebAcDMqquTcOH5nDHC0w1W0+WeRJjRax3S/aAeBpRMb0KbUagqOmTzXHvdP0tCrTqAlw1U7IZlG9L5gXeElHOUI7hO8VIMRYwH66k3tit3vicAWMysnl2oz0MdhBuNbbU6P6Kqy3Q+gfbCL//ju9LZ05kZcpS+W/iQU+Ju1pmBkyIguUKbcS1OVhSxB62WdttXFOWJX6zZddFeRbvPqsQb+JXOA4TUrY+cOOWV+nUPhVqCdTg8T0HgimDv7A0/dm+FO0CSfNX52lLYlCbJ7HbaHx8gJNSDv1CdZxMZKH0CM5kEi7EgRJXo0LHosTTOSaVdDv/WAY5bj9FQZ3HppstLCWxO1iToMF52s43youPGZ5SmsDM8pXxdR7UjU9Z2c1rfafQ9jD+na/YfngXrmLqk1qE2KYKtlp3SgzSWGlVpry2jlaQdSVrAVEv8mNimWvpQxx11HxoeOE0UKhlC1F0xdH3saB1AhXtujDEnbL40gEAMb+tfRyrXQQ6AbuptMBIUQcPDoNRWVz/U2xPeuyHrt9Lg69hyBqPKyqdIlvLzr8UT/5Q0rnK7N3/8DgKEvxwX9XnEAxmGby9yaSgElvWLKIAtWKdUl3iNipHZnu89A/foWFX6HV2U26aT55NEF1krSntzXMtPJ2Dbj+Yw48mbs90uNg4/zxoRzfaxfrAozL6zkindedKULGdlcAJIwEeeNjtp6tNcAe6SnzFonWmhBNx5kcsqpzjZQ9+d1x43ZEsP4UWTepBPM8aDS+NjsplUQ57ABDFdktPGKkGax3uRsY17V736YSzDPMFDENWY1WVnYVLEeUrFt+bB1VFcPB5CAAjbBH66un6qg+WrYyb6a6q9I55lFNe0Nj9afn6zsecDlQH220YVCSexGmXYpwsCB7Wle/Z93DLZffIbwjuRcYKebJA3KbRHxzm5PAxeG8Y9Q7PagOMvnPCsXxxN+LW61di
 pnOzJXKq
 wH88MGpk69GL+ouKDXxadc5gLWSuPewgJ753I0wRBGObHOscEMHO86Zh4Pl0vJdAmLhmL1f+7Q/AKrGoqwxwbN24mGIJAdbCBXfXRmEwPuwluHoswYnQXqqVs0LyiD8sm+InbGYaUh3avJ9l+avad0K8L8BO3IDMOt53mDUME1JPeJz3UiDo4Ymmu+TLWoWIl32Qu+eXWTJxxnoYqt9wrdepPINuS2vDcvYYyF1zqy4sXx6TN9hL3dGhShSx521KWEMYaEgxlKYbA4UMmOQVg7g2bOw6kpZ4GP7NuiqmoHpKS90Y65a6MovxR/Nh43ASDll08zi6zEr8VjuTW0z2n9kOGmt2vMbxW94AZ7Q5JBAE+elVp8I4b627J2jhhXIOW0vySIwXR71BJ85U8WsYZ325FMXoGk+huClAnQGWZfLJaRrHjT0On6NLsrl0EBijukJ+vm7Syofz+ziEQTonGAvnU9IWZFRDV5dm+gLTkPaehjbRMUnSz1I9G0TsokbKQKL3x/aIJ+h9oauwYKmAjBKnPTk5VWrK99RtxiRykmr3zS6rj9RFlq2MWPRcxskbiZBRNntSs/u3IR+RcRyOYzxP1JXVBdgZs16vEZVfLP67+XEEXu7EbwLrTfXfyQnvR7Chi8lkmTdLOUmUleRgaklcJg2YAHzsyqFd81OkzETrBViOalxj7GLRHzA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

As Zi pointed out, we should avoid crashing the kernel for conditions
that can be handled gracefully. Encountering a non-anonymous folio in an
anonymous VMA is a bug, but a warning is sufficient.

This patch changes the VM_BUG_ON_FOLIO(!folio_test_anon(folio)) to a
VM_WARN_ON_FOLIO() in both __collapse_huge_page_isolate() and
hpage_collapse_scan_pmd(), and then aborts the scan with SCAN_PAGE_ANON.

Making more of the scanning logic common between hpage_collapse_scan_pmd()
and __collapse_huge_page_isolate(), as suggested by Dev.

Suggested-by: Dev Jain <dev.jain@arm.com>
Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 mm/khugepaged.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 808523f92c7b..87a8df90b3a6 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -573,7 +573,11 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		}
 
 		folio = page_folio(page);
-		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
+		if (!folio_test_anon(folio)) {
+			VM_WARN_ON_FOLIO(true, folio);
+			result = SCAN_PAGE_ANON;
+			goto out;
+		}
 
 		/* See hpage_collapse_scan_pmd(). */
 		if (folio_maybe_mapped_shared(folio)) {
@@ -1335,6 +1339,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 		folio = page_folio(page);
 
 		if (!folio_test_anon(folio)) {
+			VM_WARN_ON_FOLIO(true, folio);
 			result = SCAN_PAGE_ANON;
 			goto out_unmap;
 		}
-- 
2.49.0


