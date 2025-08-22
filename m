Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 472E2CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 06:33:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 740148E0072; Fri, 22 Aug 2025 02:33:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 717898E0056; Fri, 22 Aug 2025 02:33:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 606498E0072; Fri, 22 Aug 2025 02:33:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D24C8E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 02:33:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E8930160668
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 06:33:39 +0000 (UTC)
X-FDA: 83803427358.03.B4A6973
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4B6381C0003
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 06:33:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="fWf9bF/F";
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755844418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=nYgWrTDKeCSkoPnBZGqn59HSOrAsr0K77JqRZD3h0Wk=;
	b=cskCJEU3r+vN+DEgcKlK/yoAmJQWGgLQ3+H5PmyBLXQ18CCjYTfSMqMTdk/4EfCJXYjico
	CrCya21icEz9GPgE2frUTeWkSeyRucTtv0dTuVuFQjdJu9mRv3QVGEE35UtB5sIJFR+rGA
	z6SSMe2dVvAne5u1yxGM6MNcTl3OEmg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="fWf9bF/F";
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755844418; a=rsa-sha256;
	cv=none;
	b=xnhaAV/724SxZFBTl1fzRmnn7Y+vViPFeFY+n8niqr9wPUbXOzaZfwuq2aiF5AOw0DoCo7
	9coekdOHA8GdBOcn4eXtUaaWNOWQLL7TEiNsnPBXhxMGO4yyKr+ndENdp0ZWMh3wTdmfy4
	+if24UvDXL9p7Z2cPM3TKmTob1g3S34=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-afcb7a3a085so287950266b.2
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 23:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755844417; x=1756449217; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nYgWrTDKeCSkoPnBZGqn59HSOrAsr0K77JqRZD3h0Wk=;
        b=fWf9bF/FibIgiAFY7sDwDNLbIyX+LMRNFdZ+SOpoy9Qja49PIFfpwSbH+yse5W5Kbx
         aGkgsH+RMQziBx9d7dxEx8rN4qu235sM/LaEu7Nfsvm9M6myholwzdSELjY5wTp4TaxZ
         8Ft5SndlPtDFQNyEceYP1mlImdDA7meiwetaE1B7gAPmnit6mTaGyCF220cbapkTxcSF
         fI5dbTZH54lLpc7SIL35Pb4WvSIs2kPWOGdLVL3EiKXmoOmUdS6q2zjG6k4BpdH+YnGG
         mP7wCijTkQikBQzdDxoR28+KXN4KjmvKpItUF0t+HTHjfRrzUR1lPvGGWzLW3rfBJicT
         +MSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755844417; x=1756449217;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nYgWrTDKeCSkoPnBZGqn59HSOrAsr0K77JqRZD3h0Wk=;
        b=DdqMDvHFVc7IF+XcxKAZUG/xoZ3nybQhRGJ8jF8QphIJFaRnblK5W4LCbyY100jlZh
         F9J6Q3fHPrjvxvQKhYDCQY3W8EP3189tepElYsBffjINzKoAFZUGPFz8HzdWiV7h05gG
         VZdh11dhuFuCZbt+mTM7UG9lSp5zKxluIRSk6HLmyiQESg37eiiRV31aIHBrwgwa5LPh
         7Zf18g3Bv7Ove9OXUoh2L+Jl1mcmkjiYhOjxh2TYI4+FNBLVuGqCklGAmeulHZm26qVP
         s98YMWyWDVzLtq6zywqBSxFfOEJyhlJYZG244CXICOCi0Il/I6H/K2a6ojFErhZGA9dP
         lkYA==
X-Gm-Message-State: AOJu0YypJxlAlc6JAGwUgiapA8x03k+RH9tGmvRAD+jh4d4RzYCfaLUC
	9GY7+BqbOFnpXhcpQLyEZcUTg0LrjLA67KGUxh3mD+EQCJ6FbQ5NcpFK
X-Gm-Gg: ASbGncsX7DWEmnVLAnZWR+fKqXpvUbeZpjhmW7gHh9lJUUW9qNRaPEg0uw+jTOX9rFJ
	YlFwexSJNJNTCIiC/DUW8xL5kAhoZMPSnCeOejQhu6aPTs/a6IVMb57futXGDZueYFZ1saX4Mwj
	w1ha+AYWlQhbcau4JwfQQR5N9mnCVGrtjl12Id3Ttd4OQPsLQDEWBx2SJM/99geRMBdhddDHsSj
	93kHPY9ddzCADSj4jXhwqsa10Ph1GTzcIVgBVwYmelN1ErgtMc7mngqirgPQL47ifcva7+yVLOF
	fBEmau7pzh/oWd33XrpzpssVhRuJGyba2PLGKQBaOTRlJzQWu1zHpFpCZnVtfk+3q2awFPyq1hd
	ykN/wDRbg9NFYGgneGRbGg2Z9YqgJ22e/nua1
X-Google-Smtp-Source: AGHT+IH9r+KFcy5AFRt3q+bnI1jzb1hmCjNuSgGHLfGMNgn5kympgvMzvvGImWzn/C5lT7w7/btAtw==
X-Received: by 2002:a17:907:72d4:b0:afd:d9e4:5a4a with SMTP id a640c23a62f3a-afe296b7cafmr157878166b.62.1755844416438;
        Thu, 21 Aug 2025 23:33:36 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afded2fc568sm542472066b.38.2025.08.21.23.33.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 21 Aug 2025 23:33:36 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/khugepaged: fix the address passed to notifier on testing young
Date: Fri, 22 Aug 2025 06:33:18 +0000
Message-Id: <20250822063318.11644-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Stat-Signature: a9e7sh4nih33q9cmdoxk4yt4izn5ic7t
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B6381C0003
X-Rspamd-Server: rspam01
X-HE-Tag: 1755844418-831033
X-HE-Meta: U2FsdGVkX1+TW6MrCdf95j+OClyIpyRL3AxtEX158BqjvCwdgxpVGJhVVstFT09/kzaJf3akA99B8KNBXsrNhjhuJrtX9Y7wa9Ku+PViamY3huAp4gPut17mZQ+6kgP+7U7xa93BXF+IUlF+Dwm5FWLzhXSMSpqRQG7zL6nZ6t5Vx7+TIZwbGIqecMHGdn5cryiwuRzOBKnuYSta2Dvy5mI/ssQRJ4DcoDc+GD9tUgt/ErmyqzzAC6zgv4y9T0RZLwznfQefTupAwDtrC0uzRtHeFdQ0AgnThO1x+hG3BzwlEHBFj5d7kT8vy4Spxpw0UYQszKmv/zpDmYErqn09OLtR37DV/MEjI5l83q7eZK4W3JVHD+A9AA4D2fkIUk8/GSGmqfjOkVXvHPRhLR+B/YxPSiMTkwsEdLoDYSMv/OnY+ANntdivHhRyeZG7UASAPsU0/5fkrxAAxzOaQCMADb1ga1y42N0q1BM14OxeKaaW9xCDrNvQo/Ta619hpJ4uQzi9Bsp6Wl8RpUyDk4n6Y+qeOJtV7PuLdivBrt3hin8myhKNr8SALMA0RnWh8nw2V7Gfl0Fk3RNsRfVxuXOVtGTTpW5UleQwhrTS08oqDqK2oGQ5V9NasR5KO+w0ZAJrzt/kCnoduPc6PqVsSN2+cxYEeCmRZAnI8RpSO/9OV2gD6NQPxx9PsjOLVl9VQEiOFh37v3Zk7G3a0xJHybFtNSmOzx0AuRqyFXGZP3ZT0i/5sSjsZuolD4nF49pvlPUc+9gkQyb3uOEtFv6nHJIwHOnlYmcesOh1LXjoFlb8XyZnF9y4xMY0z0vdp14rE8JlBSeQL2IAKPrv0Yo9cbURPpYR9jbpQrTzB2eFNp8n38zYykjMgYXDXPYrwmICXWcXuxILXJdy4koqcQ36Mcj/3wNRL+8MVJXj+9Rb8XLO6KHjQXuKqA1OKbNhMfEFuBp8WUXQihG3PJSaGss0jcr
 zrV0TdLF
 OvZ5HfFtHfiSWJZu8LiP49Ip+K5gOmHkhGWCSMw9VoV9UBLoNU/wG8naxMmXVH39LTcfK4j+m6xlGchHtfpx/Ez/zKx79pc+0IIOqbCKzwzQYRMlkNw3G5GT+oY9P8zKgs9hKKtOhbE2BGPArgZ7PSbpsF1MT2r5WurYWzkh6nNRO9tZta/o2irjPmq3m5Qt1Vw1sg9ZNXKXctpbO+Ric01fOGq9UJAaoCBl/xMqflxGbSGOvPqm47XwSwdq/Nl4aQag36OHrVJg8kfEyCc69cONCpRsxVO879/q+BrGu8AZO+DxBic1Uc1/mhpfUmAGqEq0mwiAatLXm91x5NEnB4x4FdgHbC9NdJ39SDkl5OdCyhk1SNJ1sQ1NRlB3DkmvX/6c/UhlB8kxAsChdf8BtpsIWR7b7JiD+fznNivWNE7d+H21tF5xR4mIogzacDMmLKsT/XFEIFNlbrLxd6thCRiupWzJieWmJRrR2AcW4YG6AU08EOrSnU5PydE5l8pTGwBTeDjvyCBHGwGA0G3ClptnbE9NgxkYjl76S0swAMga9QF4A2eT9f7walg7KKdVs87wLSwInmsjiJo21m0eeShbKpqAFTHVxruxhLHZxKdwWwsApzRfVFrXqeS7qCzIL8PTg1o5pGwXuXissts2eGjyLN20YRZWPwDKMEBzlCmvhLKbRRDttZGM9dCP0D/hxPFXILMj8mJ9UxII7pSgcxZtc80xy7qwsK6L0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 8ee53820edfd ("thp: mmu_notifier_test_young") introduced
mmu_notifier_test_young(), but we should pass the address need to test.
In xxx_scan_pmd(), the actual iteration address is "_address" not
"address". We seem to misuse the variable on the very beginning.

Change it to the right one.

Fixes: 8ee53820edfd ("thp: mmu_notifier_test_young")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
CC: <stable@vger.kernel.org>

---
The original commit 8ee53820edfd is at 2011.
Then the code is moved to khugepaged.c in commit b46e756f5e470 ("thp:
extract khugepaged from mm/huge_memory.c") in 2022.
---
 mm/khugepaged.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 24e18a7f8a93..b000942250d1 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1418,7 +1418,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 		if (cc->is_khugepaged &&
 		    (pte_young(pteval) || folio_test_young(folio) ||
 		     folio_test_referenced(folio) || mmu_notifier_test_young(vma->vm_mm,
-								     address)))
+								     _address)))
 			referenced++;
 	}
 	if (!writable) {
-- 
2.34.1


