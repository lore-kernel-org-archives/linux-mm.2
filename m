Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EF7CCD6E51
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 12:19:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2A496B00A5; Fri, 29 May 2026 08:19:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB3BE6B00A6; Fri, 29 May 2026 08:19:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2CA16B00A7; Fri, 29 May 2026 08:19:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ACB836B00A5
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:19:53 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7502641348
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:19:53 +0000 (UTC)
X-FDA: 84820363866.15.F898A1C
Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
	by imf11.hostedemail.com (Postfix) with ESMTP id EA62340012
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:19:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=bSaVaO1p;
	spf=pass (imf11.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.137 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780057191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0F7tBsnwtr9hum4Sk2+uPTGTQ76BR9xyPCoNaMnjzxw=;
	b=V5HUJPTo4Uea2YdyXv3tdSULNKgg/v/n4sOsiJnPmVT1JTRGHS9CwJwPspVqzA6a+c7QWh
	3PS64hb+TIu4+QZ1NyahHHZfdYHzI1vqvNrOF0MHbJsGHLGkjXCxtmrvKwfrrnliVIB9od
	wdBAvDXFm9uDQ3BakcP2xqJeA0qXnu0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780057191; a=rsa-sha256;
	cv=none;
	b=4k5bjFaJJWUl8ktplBiCRGy1QBGzGWsiOZoFEP7OzRstdQWQbmmO/DqH9H2DrCMUag6qPT
	ND1al+S1cD8ddviv1S9yzHHwv+1B07aDx3mN3klzipfKfoF8KUbtfq0BpfhrjDJ/iB7abB
	Zp73SFO18LYjxeR1omGr57/zaFHnQew=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=bSaVaO1p;
	spf=pass (imf11.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.137 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1780057187; bh=0F7tBsnwtr9hum4Sk2+uPTGTQ76BR9xyPCoNaMnjzxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bSaVaO1pHWsE2as9v5aqSMI3gC6pea5BdBgdNC7Zp/OSLATc3MR/tPAEO2FgIruVC
	 YB9mZhzuJch1Lyv9TcBU1iRgTAX1iW1VQk/UqItvsjW7pq3FuwOdkBfXuvHXobr1Zz
	 JyGIUF9yPPyeUphvvzOes8X1ZlDuBPPGyfWROCuI=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id 4DC10017; Fri, 29 May 2026 20:19:28 +0800
X-QQ-mid: xmsmtpt1780057184ts6fo2ynp
Message-ID: <tencent_0F6F682C60B99E9E0F1553E6BF3D86468409@qq.com>
X-QQ-XMAILINFO: Mzcurg9uYAemtBwe+INFz74//KNnE+Z/ry9r/kfo1MYznumf3xBU+p9iy79Xaw
	 5SFqWyk9ocoWQh4qtxi57Wl8PIpPfEbG5//RFyUtp7BvID1cq8ZOL2RNORIdwQAzWbREte+FISGS
	 rQLBGEYc6eUsDDl76FFUFO5/22ui9p3L6U1JZw0N66akvDKNhv/1ynm4BWilnqfjBg2mCXJnkx67
	 pwCuegeawCfvgAVS+7KNfwxM5DDiHZnFNXH6ZG4+UCSsbK7o40q0YwxET8LyS0tiHcYiLb5VtZFL
	 AhOMNGUUEYOXEXb+8Skf3IL+tU0BsQDlyt/+KP2F+tZGfDgScU1V/cFt104Yj/eM6uMAX/97T5NW
	 74mzCT2cveD5PAqm4nQwFkHJFe5i9cJReF55joujorHiYDxaX8gXPlCIF8ejkOK+BlPhSqw7MEsR
	 GWIOs7Xh0FTyVz+6i/R+CfGiEPU1aMpB+fMq67UMOM0cs+kt69P07GXv8K3gO1g5Nr2DA/5BLnjZ
	 mAToYyjg9Ydu/7jk0GSMBpTyEG0GJEgZ14RiImwQOaFQxrcor9tUVNIuTs/1jVyeZjt/rfUMJH9D
	 H0vc0MXd/ln8DTRmhr0dDIfzVJtXGNKUGZLszineBd2wsEbTzl1DVmsjblQCkRC8dDR3iCGOoC9P
	 KhoOLRf/Y01X/QHibkPXac0vuPGeZFo9sYT5Xajl2kQgof722s+DxCQB4b6domZD1/i4gkgfsLSC
	 AwqOLfuWfOn3JASXbC8cLYiyXjduwjbvL2Y9NYDWSMmWTjAYBO9atEQ0d8770p2vzQ8PyP+KfWqg
	 tx6Y2DHMgRODRVKFoBsMSERP7Ar8uNDk2TvEdEStURJEMO6K50+et+x2VpxYvFUpk2QSPcwSvK0L
	 TXjiwyPvWmy8RVmLFleFoPIBszmIlosHJPcYsGUoKTbY/wH3sFaXX2C3JgUOYva0ncVfCDuOWYMa
	 FPuQLGY7kjudHqGukOTmTK7VYzX/GUfQwLlbrJwUrdcxSdrFqwAbD9eESEvPovIzqoUER1VAm/H6
	 uELPk+BgwYmrm1cLTFhdappr6OAVFkmrqx+qYiY9YcRRoUL9mzGIOdpgDNqH0=
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
From: fujunjie <fujunjie1@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Alexandre Ghiti <alexghiti@meta.com>,
	Kairui Song <kasong@tencent.com>,
	Usama Arif <usamaarif642@gmail.com>
Cc: Chris Li <chrisl@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [RFC PATCH v2 9/9] docs: mm: update THP swapin counter descriptions
Date: Fri, 29 May 2026 12:19:28 +0000
X-OQ-MSGID: <20260529121928.4115683-9-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com>
References: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EA62340012
X-Stat-Signature: m67zdd1rrokqjatsofxtxp65hpsysbq8
X-Rspamd-Server: rspam06
X-HE-Tag: 1780057190-560677
X-HE-Meta: U2FsdGVkX19yFO4xUQYt3JhRTl7v/T09MRDkEHrMIjgn++QtSB1TaFmid6Rc/U3XQDBvDkHFswgcEnA9UtOOa6VxTFD2UYCpeD0MwUNloAcQnONWTSiEexAdjM1Jo0weJHyl9FSzK9ysjDfmLgIbuTL2QKmWlSXlWKHQsymG8sfnD+I8kmv7XcP0/gPhbnyIod9AJWbjiDkU46OGJX0m2IwJ50y2GZJfGNzWzD+q5lHXdygciygmcLkMJvFWMbn6DGrQa6GDiv9bjk9oA2EU/3KHndiMJAUsatSatltiVOhPPIuSy7hOyty0pUXd1agUalc0CX7jeaUo5sQfNeVaYYJ4vo56xiYmpXrXiWg4/QmjW6AeUr1S6WpoorwPUV0V2MF/T3hRb9ibQHsnT2oAZtwHsLBfU885ecjz3HBUbM4Uh2TRtbbC6JwqDHOxOyNLJsk6mUxUeuZyiB6XgKqP+mIO/S8LUtF6AwXMJsgVr7Eh8wkyBzFpHCwIGbx/jsxWwHUvNWLGJr4xQvDuIqSQ59phG9xjVZoo3zRJtGN6INd++KpmKkSh8rFnCJ7tUG9s7VA4Lmx0lZVOfQa/rnpUuHziDhU2VfOqG3eC0yojTKCJ+cE6wkNj2dBmTmSRVKteUwqu4zvqXeOna2SUzebkf0fOKL9C6YSu+Oxy9muUiBO93S+fmhOl24BwmRIcuqlBvMkHTZHGT4LarHrEkSKStRan3fG9UFKoZ349Oe5r9r07Dz1KjW5fyYoEyO6s55gyNLYJD2i7fQ2/ersjlDixQe6mYHmZyM+nwMu3fTKYTzyX5/xChGcDuoaeJ0eg+uRokSrT2SvwTlIdQZtdqTqH/scg8KprzXy0xujUT/T0JRmzoljX/MLWAbBjdJnSF4eL2gvGBldt21XJnIFxMgSQJ0VHVGENt5xfyXchx2Pt6ux244ylARgpbWaE/zdQ4yf1pFSDK2WC+Zvq7CrMbUh
 U6DRKEtp
 zldx8asOhekRHpAWhUzWHM0MwJ2OoWfJSr4Ye1YGgswC5k2RNHjtNWQ4Bq8BUmgO4khofnrbGsJE1uHvU5cvQZILC7NTE8zprVrkkZ9iFSt/82QQbPUI/O6TyH0l5GkaQf6hS7r+bGwOpEhPfg5QXwjrGEF4ujbefvWJAzRBkUNHIjV/rFftsftYBsCOr3at0n70qRJDthc4yWMO0MDFtrWrP8QpKeQGyNhUh/ICsa9hymBfa8wL3VwwtOdPRWoYTLFwMSXFKRvVGQ5I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The THP swapin counter descriptions still describe large swapin as
coming only from non-zswap swap devices. Update them now that
zswap-backed large folio swapin can also increment swpin.

Also describe policy and backend rejection as swpin_fallback cases,
since speculative zswap large swapin can intentionally fall back before
doing large IO.

Signed-off-by: fujunjie <fujunjie1@qq.com>
---
 Documentation/admin-guide/mm/transhuge.rst | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 23f8d13c2629..59b7a0d09243 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -667,13 +667,14 @@ zswpout
 	piece without splitting.
 
 swpin
-	is incremented every time a huge page is swapped in from a non-zswap
-	swap device in one piece.
+	is incremented every time a huge page is swapped in from swap or
+	zswap in one piece.
 
 swpin_fallback
-	is incremented if swapin fails to allocate or charge a huge page
-	and instead falls back to using huge pages with lower orders or
-	small pages.
+	is incremented if swapin cannot use a huge page and instead falls
+	back to using huge pages with lower orders or small pages. This can
+	happen because allocation or charging fails, or because policy or
+	backend state rejects a speculative large swapin.
 
 swpin_fallback_charge
 	is incremented if swapin fails to charge a huge page and instead
-- 
2.34.1


