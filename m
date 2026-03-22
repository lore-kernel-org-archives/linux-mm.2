Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85A36FC72AA
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 05:21:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5242D6B0005; Sun, 22 Mar 2026 01:21:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D3C16B0088; Sun, 22 Mar 2026 01:21:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E9AF6B0089; Sun, 22 Mar 2026 01:21:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2CDB86B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 01:21:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6597AC1F43
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 05:21:28 +0000 (UTC)
X-FDA: 84572551056.09.4B1D064
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8BC074000A
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 05:21:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F7y1Q72q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of devnexen@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=devnexen@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774156886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lc7WXv5QbRK7FJAPa9CcSx+GAiaj9ytLHKKih0IedjA=;
	b=xRxFkW9OpeiTnn/09efGYchJlIDPEyoBm5oBADokDBM64xUQ1qwSnFe8SrzGmkhX8pgLas
	sMmG/OaslrDBCBH8ZwPKCpk/T/8Yjyh8zYToFYsFCm6JRS+c0eNXbXchOTDgIRna5OC4Hb
	Gt/67lHzPZSqlFjijQvFSTrZ7PD3wao=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F7y1Q72q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of devnexen@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=devnexen@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774156886; a=rsa-sha256;
	cv=none;
	b=H9/TSLRBO0+hy5Tl7H93NcuKg60GA8AJAHj7P+3X5zYutoD6bEfhbWBRLIrAvrQHcAkKv/
	npK7w6lexAP8zSV40994wG1l+4tu0yV6LQPK/yUzH9VLwIphmb3eLFZIpO7xhAiNwfHuS3
	R/0Ip26JXFx9dxqcGYQmZmyqD2DjqvE=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-439af7d77f0so2268950f8f.0
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 22:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774156885; x=1774761685; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lc7WXv5QbRK7FJAPa9CcSx+GAiaj9ytLHKKih0IedjA=;
        b=F7y1Q72qGZ6GryKzW5BwasbtKBXkya7MmGsf029/GV7RsxPHCcRb3s04Me1dc1KFBL
         obwHvTMb51SJr87nthXHDNLbzMTzOddnE4SQR1BlOKKZLIMKy2jn9WCAky+Vrj+qIplc
         RyBOBaF8te/ERH81+B2dAPQVxEyfw36N5FbSgXltOIrRIEbhihhUbTIK46de7TYqlT8u
         0XNJYU8EpwuAn7a5g6ffVyTMVUtPITbsJZPYgQ8Fz/DDmNFPGFfXkge/h4aeUSuesMCa
         XMTz1xEoqEdCba2HroXIaMCuGtmmuvG6iTzSkFQRXkGf3venpTTSEJJAf1fbfZBYVnlG
         s5UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774156885; x=1774761685;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lc7WXv5QbRK7FJAPa9CcSx+GAiaj9ytLHKKih0IedjA=;
        b=aHa///zlQGmMQgUR0IRN8LJ4Ff23G526RPGyEBbqQsapwlzTPTHKrJhLqH1XpvP0oW
         rkujr8MJk9CpATUgKuW0m87fy4F5w+qiElC57PZfncvGp4FF65t1+pRQo3Ad9yKmJAW0
         uhMEPdfzfDmffRDa9rRQ0o1ETLLZ+Y7W7/ZJbBgSZncYC2WD7nWmmX/xzZ7q+s0NMAC1
         l+NG9XVpvMePUo8D81jX/Urm/ehPacRAvvtERoL/oIpls0vyMFBUZnDntoT0P0Ol2xeH
         pYb1q/DCB56twLTXfgMMVqwRgFFiHSqOyJ2BtT41PeD6J4F+JUQGKmzeoaNMFkKSf0QG
         928g==
X-Gm-Message-State: AOJu0YyNIRsK4e4BVsDDVX07ZBCzY4FGJQKMNaAZSsO+N40hue3ZSPNE
	g0KxeinV23V0Z53FtjF9hyj2eHJ8sc/CF8J6osfYSudj9j4xAhnkX9Us
X-Gm-Gg: ATEYQzz81pDqJXLS996c9XIwCFFfx037VXrUoDrBlaxxdySyKG82FI9BbYj0NfgxdLx
	kkVgldEMFcDJawmHqLr8R4K6V4tXfK2BTCIiPIqHLv4lf0FZTDFTjaZrjNzprGW2NP8pp703g3v
	LYufDYPYKe/e1Ua4xSH9JLpcIjG3KTD60DYQAdPbzAnrzaXNMzTIScgSyMOFyDBE0Y+ctuZSQtX
	ZfgNA+yxAIyNnYYgvPoeN97szzfwpa5ho347BgUpbxibfr+P8jSJIN5ZQWCLkCfDMB6nHAEQThu
	WHBAHnVMhDXMeKQnsis3jWjQzETnXl3Qev17CNSkYYqVcpEXQ8rHRq+6JcHngLgzLVpTTGTvKzb
	CSewMplEPSg5XDCgCA/VRkYHPcV+qpDWjySEmei/SPU3FaMdcl2D+KVLvMScXCfr8SO7N7r3f2G
	kL2ZJZ8cepGnhgo0cTiNq+T9I/bJkqfPonsrgInm+JzqWkuSrSyUHHU08JWzonIixXHhiEYVEst
	KxzHTEdwt/H
X-Received: by 2002:a05:6000:26c2:b0:43b:3d44:6624 with SMTP id ffacd0b85a97d-43b64232862mr12944534f8f.2.1774156884544;
        Sat, 21 Mar 2026 22:21:24 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b646b0d3dsm19494208f8f.16.2026.03.21.22.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 22:21:23 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	YueHaibing <yuehaibing@huawei.com>,
	Mina Almasry <almasrymina@google.com>
Cc: linux-mm@kvack.org,
	David Carlier <devnexen@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/hugetlb: restore reservation on error in hugetlb_mfill_atomic_pte() resubmission path
Date: Sun, 22 Mar 2026 05:21:20 +0000
Message-ID: <20260322052120.14021-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8BC074000A
X-Stat-Signature: kmfho8wze6a6stqsx638kmx87bzo31ep
X-Rspam-User: 
X-HE-Tag: 1774156886-469011
X-HE-Meta: U2FsdGVkX18MSDLk78k3oLw0i+755L4Z+jwhHAYwRXqaooxRN+RtNNhf6iLn8e0vZYt0fwl2EgdP4UeVmv7SsVX/7I4RU5qyLwIFbyRmKZ/NYVUtlXfLi3vearXh6fQ18J7q4Nwkh/KgQl6Ud37Z2ygHz0dJAijGWqzNdEnuprMe9vbkm0Kp1BsR9OqE3q7+OnrInkxa6sO3hyLgdlHyiqOi4xsjMAcRzDQoxABHHJe/s9DLr79digE0108LleIIS7EKW5yUQIpRynzOCEKTi4M5TYKRm9d31dkWZ2pVW2WUimTZyWgJ/DVKoE//s4HLY+u8/nqWbW1zasgRiyIX8hsCbJ1DS8Zw/X8bvQP3bRUMcaGw4vqOeEpx/+EgwkoD/V4917o6IopptBC1ejoM09YTTwsoWNGQ9X4vLGEinZfnQWj5fCWb7vVY9i9NtQmlZugj5MAlAl69aDLWxFtHstPnmyf2KzwA74cuWN1BpFod+EmNIL5PJPMLnmOMNNJEECNGAGNYJK3XGDehzLwCY/8i8+B/bpktlm+UPxnmiHyc16neDguYqiDhlhUCAx8DuNVrUIYd/8SNhkLBB26JjG0JeMM7Ct/3k1s6vXCYhAvKk8nR9LfwhRVbvqjJwFuFZ7YSS21jsBKdcGl8L8QllJvhAI7/JTq1Ia2nWBh/woBMX5DrgOkZtuWJco3Z751C4YVlTVNP2cfRdnpAGja5m4OYKk0wze2+n6SXQRdV1MGPuM+BhpTadmtez9FwY+kVwMJqzPhQZ+P2YM8bylMDX9dcgqvyzeuCK9I1dbFr2NkK1QBGHgRyXGA9YvMQT6p84u6zvTjMyTXxyf/JZrYFApYhd2kPwhF9avWFShi2IZYPr+ElvqY66V/OUVR9YstfUMnwTzaDpxBOnmnzXyY0iOezvRICXlhaqC9W9AhDHP8xMObTt1/uPRQ7Ue61ldLTD4uCTOxKtDuQLGhtfYv
 qU2+86qa
 QERFPLzF836CehecJXVZu/7MF+FI6Z+Z3Y1fjkTcZVNrg2JQrXmYwS/M564OXBZCI93RaxlNOSD2ZK1jdmJvODPVlhvGiHY76UUUy/ZoNpKQXKDb3OsQOueoAXtTnrHksQSN8cocFMRHl7e67EWnf1lRkoFAISTrujoB7P0u+SQITf23tK6IaTO0RhR5vh/Tlu5Md6tEYafwLBfF90uJ8vKovNtzlyfyVhrs7Ux7QMv7oxCKUNpk2cXhJ6LSb6yFuB6bHHfvbf7iDt2Bahnaf0g8Xz0bhOXO7Ld89/8V2m8JNjp2X2HDBkFLgsIOQ+Qs3+UqRbdmv1fKffsBV34KtdXbothd/yW+xTJL0Rc27t9hs7mxIjCEW8wPPyT834ts8kRvXvROvypyLy+gF6jSE9P8od+LEyO7zeIhBP4REZfF/3wNrQLhAryMLPNquVAHhkM1k3jAv4XlQdMRMZweVrFCNY21/o9OWEWk7vlWt7JDqoUs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the resubmission path in hugetlb_mfill_atomic_pte() allocates a new
hugetlb folio via alloc_hugetlb_folio(), a VMA reservation is consumed. If
copy_user_large_folio() subsequently fails, folio_put() restores the global
hugetlb pool count through free_huge_folio(), but the per-VMA reservation
map entry is left in an inconsistent state.

Add the missing restore_reserve_on_error() call before folio_put(), matching
the first-attempt error path which already handles this correctly.

Fixes: 8cc5fcbb5be8 ("mm, hugetlb: fix racy resv_huge_pages underflow on UFFDIO_COPY")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
---
 mm/hugetlb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 88009cd2a846..d6ea11113f1d 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6295,6 +6295,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 		folio_put(*foliop);
 		*foliop = NULL;
 		if (ret) {
+			restore_reserve_on_error(h, dst_vma, dst_addr, folio);
 			folio_put(folio);
 			goto out;
 		}
-- 
2.53.0


