Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 840D8CA5FE6
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 19:53:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41B2E6B008A; Sat,  3 Oct 2026 15:53:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CB9D6B008C; Sat,  3 Oct 2026 15:53:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 307DB6B0092; Sat,  3 Oct 2026 15:53:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0E77B6B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 15:53:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 99762120A90
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 19:53:31 +0000 (UTC)
X-FDA: 85282364622.22.FD58249
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id EA33DC0006
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 19:53:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mme6ou2f;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of neganhat@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=neganhat@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791057209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6ODm/v6+HJBQfxMagJqNA1a/frsMk+53MtU+BX7MWQM=;
	b=pYIwKy90onqLm6pStxmD7sAbEubuQ+pVz12/LVeplDOlP3hWGtApldaywvbciHAGeHaeDG
	1Z510eP7MGc3IrULeBAj1lx48jvtBslp+za7VU56hbIM0A6P5IgRiakZOFw5fYkVQRFB+n
	T1h6VA8z67ZHmutf6fjyNRf9wBFCt4s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mme6ou2f;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of neganhat@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=neganhat@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791057209;
	b=T6FzXWOXrm7auo29t14fJxmAxXmFEzwE1dRVIRP8g4x90f2fJOQuH7We8EhtsqMupWP/TG
	49pKIJ20STRdwxGmPPis27AyrUpgxiMYup5S3lloS3jShy6ePZyo7aERu1JktFux0bgcAO
	+oDAmnkC8LZeJi5cxbOWs18dqgwBt3c=
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-396ccdaea76so131983a91.0
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 12:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791057209; x=1791662009; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6ODm/v6+HJBQfxMagJqNA1a/frsMk+53MtU+BX7MWQM=;
        b=mme6ou2f5M4y3dfJmZlNFfmdwJDLFSxLgY9rw3xTkteLpHB+JnCkARqEm7hgtm1zse
         oc2uIJknKeTm0mQMRDjvC3OuVJ3mUp+Lrey/A8uYycazM10keCZx/6LNUo1J4eMVmLgQ
         Q0Dxy0sy48lVerGRWCcNj6Io3/6nUTZ8xgwzeKyuuCBwMsPwD0/ywdasPqwBoMazZRq2
         gH+Btsvx2wYn6S50A+k6njnAEmC966C2QC3b2f6Dd/8UgsFqTDgpgkVL0zf6olZwxs1X
         c4XEkNA48g+fE1ThfQLSbAxEH7ibH3DJYJKKPthVVfrdIRxj6tHvlEDXG+qpKI2vP0f6
         SdyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791057209; x=1791662009;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6ODm/v6+HJBQfxMagJqNA1a/frsMk+53MtU+BX7MWQM=;
        b=iEf1YSpJ4gBaMF6JHGT79lRctc0SKuVTHyWhps7g2aW64AyVqPLcucO/l7fbKke9zk
         QnseCmVYVDiRGnhAJp8z4LXEY2RgOi9DfdZpKZDI4x26ELyKDJicQEhEJXShe1SywHQ9
         8EZUB1oxu3cDyM2szdms6s937sHGsO77fBCUznCprCL2l6OIbmA4ETgC20hnCk2CcJTp
         CTU42tLNqcwzOh0osPDf+iWaZlng/IYuAxDwWpBSoxcyFVUla7g3nZIJ517S/Qsp5Tm5
         id+WvbPTAXkfGu07eRzqhjOXW5vcrPP1cBLQxBdewlsyEhlxWKL5+kIAtq7njGQeFXrB
         96vw==
X-Forwarded-Encrypted: i=1; AKwUvBxh8kpLaBwUQkczICr6/7+pSrwf/jTBg5D5J0zcd/F5rTmUFP/VCR4b3WwE1Rz7owDZtHYfk8x+RA==@kvack.org
X-Gm-Message-State: AFq9FYIL/Mmf2fVCsZwvAf+6bictOzdpbsH9IBatr9jwveTCQngwOdU9
	1yLj/JdCrUApCNvil16ZGG6+Yc3dtnDqAKfQfJlg0xDb8FnU10pnpRBN
X-Gm-Gg: AYBFou2ueekp16H3cewubj67lI0yFYfy4Ql9jyw4dzaLrFURpMKnfivjJhq1d78UU+6
	gbFLJ9T8NyRgvW7x6usZrI5h0XFKyR1Kf3eb+Sxkg8oLNvWFCdS4LZPQv7D4w6b35tiqRevAGEO
	dCugzgBIun6qpWSOIXmOhRO++3TFGIjjGtWaE40qf07Qqf6SL1Es7s/FxYNG1ItnrYS5Rmats5j
	FwJuby7z7zk/pxUhqok6SsUuG2QKexmojHQ3WCU6Qdk6dMyet0Sio4sGg5h+m2mZyvOxcQL7LUW
	dzc2yKDgqAWfnCHhIS6CnPfmVI73ohL/7aVKnkfMdEAxwvsJa6ShkHYTB2jS875Ru52PnfXj2jQ
	gdMwluQTGdcRHewPhP2VtUlhrWoqe/4Vl/KBbUGA52SDQsTgGHgE/nJVL//gKTRZ7LlT//q80EM
	VlB04k/DeAMj3viSLhpprUYuHG4bT0U/gWE09xA3spGzzby62lGnd9i8/pJN/tOE0oRB7iJPSDS
	sPuEQW1ITgq8AY7cVPRdru2nn37O3Lk7V8xcfdPt5ZnDta7MEOr
X-Received: by 2002:a17:90b:268f:b0:3a4:e735:b3a3 with SMTP id 98e67ed59e1d1-3a6cec8cd26mr3724608a91.40.1791057208655;
        Sat, 03 Oct 2026 12:53:28 -0700 (PDT)
Received: from casta ([2401:d800:1f1:cd06:9f1f:eeb6:21ad:cee5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a78e472b48sm3838211a91.8.2026.10.03.12.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 12:53:28 -0700 (PDT)
From: Nguyen Duy Nhat Anh <neganhat@gmail.com>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nguyen Duy Nhat Anh <neganhat@gmail.com>
Subject: [PATCH] mm/gup: fix NULL pointer dereference in fixup_user_fault()
Date: Sun,  4 Oct 2026 02:48:46 +0700
Message-ID: <20261003194846.205918-1-neganhat@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tmo5456xxkiatuethzirx4bxqx9o1gdh
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EA33DC0006
X-HE-Tag: 1791057209-163576
X-HE-Meta: U2FsdGVkX18bG0AXGvjfxnELqO7JGLTKB9Drr9acJum0XvTiwubavqoX4AYjXR1zt9RyNK/FcWqcQXFn+MDHJ9LgL2WhLpDP59LFPC37uwZA4RcPgBcqqnNAyZYOVnntjBqlwnz62ah4ahlW2WfcMZY+52t0kxq888FAllL/smyO7NkCCc74eEgPNAMZPO6Ab3fNXt9B94pedGNZDB+gIzAL2PB78sdYwxbpHWUyDjBeMTPlgomfWMBeGbcMfXmmoH/KYNZR/WiruMZdXHlEsqX5TnTWALDmr/pDYEUUJko4jfshEtxODp5nZRtDf1wLEa9sLQdqOy/KSVDbK5f/oGdKf7WQHuYY+6Oq7g75APcigzd7Uvrr+I+qwnqA+zqUkEv1+LEeQXj14dJJ5SsoAZ1o09mNU0IXNNrKrK9/rat6KIU/LBm6YeOO98ppCUIneFWGWPxFutkM/RZwtfR8hhgkIllLZHpA9wvEoxds2/uLcCktdwrFc5MzYLaryeHmP01G+cY0/63GvkhvjfmoMxPz1riIU4Vvf8x/oBZcgn9IUXfjdM1ejI13mjO9TMSpUA+qaG/tLk/Cgq7/BybenjJ8oi7FtXlWC+ciMzkcHVdXgAp1g7GK25BgN2uKHM+C843DOk/VDx8/i8vMoQYZ/Di8Mllo0C7xmMW7rH+BCO1yW/p2CT/71kW+HNlW9fS5HIkTzf+MYeuMoEM9m0nCZWJEJW4wUGv5cUZ//b3Xt9MeRB6Zyqwe/Jcsx5dLjVUWI5bpXRU7iDn/hJcWS2McZC7UAKf6oqhLXqSzTn2lJC58rJPjoz9yowHNh0XfSna+jAbM8fJYshRuqhZmr/SkG/JVdZEjsdPs/e/FCCAd7wZsJsqm0TK37hg4sWeP+5JfC7gj2Jax3Zz2e3aE9XU4Rrt+0PxGnpvsjhARkxfMfTHyt7ZABGmYHS9yxgj4AOEScSWtNDQrV9DMPMKz+h3
 A7nJ3TGE
 yvmLTychn88tIzt+b2vPFjpdWHeUACXJtl2tDvmEUvxMzKp2o5qGnDSU5PNK8BAam4noIxVtiDdBLSH6le+Vthv2Q9zMtdbEQ60Zrcvv1OVmU6sxgHK/cqcY2wkbXm6ILV528KCjc2ByTQ4k2jwRQJzH7F+XcmREc5XUXpxeUFVImrlsPGGXXtJxJLVlVJ2d7rOtC+s3dJrfhnxI++k0I5hie1PANyTikIME+el3T+mD9JiulZaxJRtXxSAb9kewl1MlEoW9Co2v/OVDTgDa8fXnptf6W3cqpNJwEwLCJnXgBEo8aGeJ9cycgvL5/FCdpQ6bQpJtbOv6PLTDisTiHnKNXqsppZJrt6bk31LPRwdEl+l3CIWw7TeoHHBUCFe/5XjBycCzbWmm4vt5NkKdeEClj4YCX/9Fgv9dP3LWjMiiq8VcMJHl+x0Tte4J2jAvPv59u7SwJnPZe7S0IqD3NV5N8Xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In fixup_user_fault(), the 'unlocked' parameter is checked for NULL
early on, allowing callers to pass NULL if they do not track whether the
mmap lock was dropped.

However, if handle_mm_fault() returns VM_FAULT_COMPLETED, line 1597
dereferences 'unlocked' directly (*unlocked = true) without checking
if it is NULL. Callers like s390's pci_mmio.c pass NULL for 'unlocked',
leading to a kernel NULL pointer dereference when VM_FAULT_COMPLETED
occurs.

Fix this by checking if 'unlocked' is non-NULL before assigning to it.
Signed-off-by: Nguyen Duy Nhat Anh <neganhat@gmail.com>
---
 mm/gup.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index eb898ea1ee22..64f709a45adc 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1594,7 +1594,8 @@ int fixup_user_fault(struct mm_struct *mm,
 		 * could tell the callers so they do not need to unlock.
 		 */
 		mmap_read_lock(mm);
-		*unlocked = true;
+		if (unlocked)
+			*unlocked = true;
 		return 0;
 	}
 
@@ -1608,7 +1609,8 @@ int fixup_user_fault(struct mm_struct *mm,
 
 	if (ret & VM_FAULT_RETRY) {
 		mmap_read_lock(mm);
-		*unlocked = true;
+		if (unlocked)
+			*unlocked = true;
 		fault_flags |= FAULT_FLAG_TRIED;
 		goto retry;
 	}
-- 
2.55.0


