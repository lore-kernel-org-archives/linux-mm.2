Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A079C5620A
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 10:07:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 012C36B00A3; Thu,  6 Aug 2026 06:07:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F053F6B00A4; Thu,  6 Aug 2026 06:07:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF4C76B00A5; Thu,  6 Aug 2026 06:07:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8DF86B00A3
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 06:07:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 380541406E2
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:07:45 +0000 (UTC)
X-FDA: 85070418090.16.25CC939
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf21.hostedemail.com (Postfix) with ESMTP id 84EAF1C0007
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:07:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YSyINcT+;
	spf=pass (imf21.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786010863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9jkdh6VKlKFhlDrgR60RC1avyqfvhVLkmPkcfqFabPg=;
	b=Zj1QBzBIlsMhV/9rdHHuDCI2Lc0TsiPpinFf+qsHQeoEbWz9Bn78dA+TXV64rV21qsBSAD
	O63Zq1JhUl6TlrQLNjYj7W4F/UUr2ahGRFhCzg9xOz4RtoHcg5nn+YNFS1w1/VXaSzg9Mi
	jYy0nr6y0K8bqPO3lhP2kb6bqrKmJtY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786010863;
	b=z7vAC9rbur8rPiziH+t9Icl4oPDFtEvIBpctdu+oCG8yuI1GwjZW0PfZdtoYi2zGEy6wO4
	ZoE6tqZmi1eJUiQi5r/vpsOx0xAVrwsi2Cn/IIJDY99tW1FN6Df3eiZEpRfpeWqz5Dw9Ue
	pYPJyeBWahapixvl1Bhf6CKe8Z9+s0M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YSyINcT+;
	spf=pass (imf21.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-47fe76491b8so148690f8f.0
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 03:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786010862; x=1786615662; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9jkdh6VKlKFhlDrgR60RC1avyqfvhVLkmPkcfqFabPg=;
        b=YSyINcT+6nIc958idSLMNc/hXc5cmdXjwPkUOSbmRy9TIU0nA/XjkW2Wsfb3OAqkG9
         DtR3rKK83DpooU3uLw4kDRfzt9m6e2VhRRoA+Venf1ahW64mkp3KRp0ApKU8POe+qx1Y
         79JPhpN/ZYz45lkttHMm3Ro1TKkAHdgQ3UMT3LGq27ox1qU0cKBiVlQSgfcrdCgBs25h
         TqRiLbqn7Dbkl+5qNNpVOn2bsAMbKVqdFucRaJEGDmbl0e8Hy77QreUm/a9cnjXwEwlZ
         eDxNQS5rVHaeFWfxg25Xq31HgkYXueE7dIEBC61w+4vH9w8fKaO855FUpsWPuEQHIBPL
         EQQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786010862; x=1786615662;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9jkdh6VKlKFhlDrgR60RC1avyqfvhVLkmPkcfqFabPg=;
        b=PWr+bgzhQUgIMnc2zjpQuVQxChfGqRkaXfa9b0UZLP1kZ/aEsaAH/3/cBVT7lmUsaq
         bcFGetwUHF++TdGsyFE8nieuJfh61oCYqgNEx9zU4c2Gp87UX2QELnnKVF1I2BdB8rnr
         2YesdmCIS9CAGJBeQtKf18f/LC9g7Qs9QRMU/Y/7tfCSNyqrStSmg8om17sJiUhD7irs
         4vPc7Q6TT/uoNheWJPQc1vH+nXL2zEXXoWsNBESuTRx/NrEu0I0J5d8grILX1ANLoMlQ
         1sqaBKJZ3WV6X+/8+kR+F1t43mcI5RAaVcOaGSM7bsoLwd+Capi390L7yGHeRcJDhl8g
         BlUg==
X-Forwarded-Encrypted: i=1; AHgh+RoAe3Sc/yhMs5ValG5hLtupk67aPQGGhu5of5q1fGT9F6O+dk22I/0vIB6OZZ/zmds7neAvp7Ky2w==@kvack.org
X-Gm-Message-State: AOJu0YwpRuTYbydN6I9XtXL4xCMOXAOmCJAh24dOAcK9M+pnNcVoTfHH
	zFWVEpVZlN2VcMvhNQb26bLnZK6WOGUysm2MbNKyxHslfOAS7KHgWni0
X-Gm-Gg: AR+sD12OE3PkZXE1ylMV2PaWtl4vJa7dAUCseusT1X5SM0QgpQ21pWO507Xt1dkuhPk
	zJSHHqc3Lor+rOcBCuegcxh8VZc2D7metO4VWngZHCaABsezn2226Q5mwkF+SDOCcG+sI1a5PWe
	CmUuYcFEtjZqx+V9oj/0xImkgxHOk1ng5+8MAyZxm6v3NZtKoESdeeEHtcuQVQ3Ip1vedq68vY5
	618Rb+YAZTWNtHay8GSVgP6zpVe7RVJk7N2RbhA0IsyoEvdCr5lGr1+xCV/Yb/gDnSAYjKp0t6Z
	j2DhI6OB8SUf2pz0L1gEZNZ9BuprL7p5zDxba3njEkDrXO5BI8aMqKvNmf44sy/svgcPVxsqzhj
	xYIfIpJ5nKMGnhxn+YJk9GRD588RWWRfBsHv6bmHGzfQf9FoM0pnBibvf/KF2HsQ7MOlisGWD9Z
	/IjYQlQ9nxuyZF6ehxOIflJYbK1LvcHSRWLT5jveTYCQ0cDAZdDZN7//RQyJ48anhb5/TkX+fA5
	ij0mplPksqp5Gsz6iwCI9G4flzex4AGjOe+E3lEePIS+naGWljzdCe64VU+ybxZbQZ2VyJh3qiy
	EnsLs4Qe1RIsFQ==
X-Received: by 2002:a05:6000:200f:b0:46f:7d90:8124 with SMTP id ffacd0b85a97d-47fec528a60mr10218590f8f.2.1786010861910;
        Thu, 06 Aug 2026 03:07:41 -0700 (PDT)
Received: from fedora ([149.3.87.76])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47ff79a718bsm5427264f8f.5.2026.08.06.03.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 03:07:41 -0700 (PDT)
From: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	kexec@lists.infradead.org (open list:LIVE UPDATE),
	linux-kernel@vger.kernel.org (open list:LIVE UPDATE),
	linux-mm@kvack.org (open list:MEMORY MANAGEMENT)
Cc: Giorgi Tchankvetadze <giorgi@tchankvetadze.com>
Subject: [PATCH] mm/memfd_luo: use real folio index in retrieve error logs
Date: Thu,  6 Aug 2026 14:05:39 +0400
Message-ID: <20260806100543.138902-3-giorgitchankvetadze1997@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 84EAF1C0007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: gsx8sqeckymd4aeu4w3mggop8qwegwpe
X-HE-Tag: 1786010863-566947
X-HE-Meta: U2FsdGVkX1/77WzIhFnpij3gjWpRzNhSU+rI2mErE0SEj1YPg43Sos9M13hFfMMYJZ9Uo2LQ1Y6DQQ6WzhuTUGiOF1kvbqrDAZHy96GmQNoV+bAGM67Udo5IDliLmEo9W1/sy/jRp2XDhTouLwBtORTb8hn7c1q63rhTxkzc63fF2m98eHHwQL/AkHVJvQ2uTizzoz987UfFw1P2UH7zJcH6ZF+dXzrsVZpaJbyQtkqe+uJySItNQ9GF75KbNJlpwdbakUGMOwvzbqPAqCzrt40ncxxN8Idz0qehaQPNLGjWRPzyjCNg7urncBh74YGeN/TG3ipXgyIlrM05j+f8S2PCte/uUQMJIgiegpo1wZ9bqMKvpEDp2I3M2lnlAJLrA+Kin8T+RoKk+KXMZt0oz8lyA7Pb7fWgle9KsNy22B82TbVbsUTXsBZqf6CakgXnT4ClKSsKUMk5sRdgceqW2EIxIOvu+0lA5+oXO5J1QKT0iZgaXUFSCVJMpwPAuhCiGqZwXPCVQQ670tmHGAD2GcAyggdHVWFniO6qtSw53kG2CuLqv6v0k1J7jGj+poH1UCste8gFra+vVpAqef2MN/tDMm2gspiP58S9o9dDZDHRzxfRiDjxyZYfmVke6YeSSWxOAdwkZpgUh/eZz0//rpG7ZDbbUzuVPMNhvPWTC2lGex8oL4yXFvYCQjA5+NtFDAh326CWc4gqQ+aaF/55Y7pPTXnn/tjoZrpptYLGQ7zXDf2+X0Nch2h/HZoWtDb1moqhZ4c/OzkrYhNASlI0aFszXscrJGWCb+8K+z+O0WWf4o7duO/QHXCgnivtwRUbZIQqofvL9+r9OgeUbSdyF3pNd0kI4B4PQ9Fs7rQsqxSoajZlkXobf4VJsZYeu67AgDs/9THA2BUrwTYGySJ1rDVF7oRkEw/eJTzeo5QeKVOdERcH2D+yuUpznBd+RgJnC4QlmVO/wl+Wzxajigf
 oC1ORXpd
 /Bhlnqbu6XX37IjQwF+Aee55fJyR9Ykr14CMxH6Kvv2X2tR/eXZHlStYqpulZAFoC5w+yn9nzpWw6x09gLvdAPG8/TgN8XfZUFMeMkzGeoZLDjZ/JaiyJTemGaslzpQR1T0DmBrDiK2SrFfQjPYtZn5oLSSzbI+DDeMtL1Z7rc+kJP4XbCXHVccQIvIG4RryxQ2zKF1QHwGkL7KszGdOkD93X6KvxPxMbZdinqUplUQJy6kjQqSb6FmoPw9LQoB+tklsV9fUg85ymmgC7QYsIweZkw/1ncUc72afVNkB8+WuWEAWqm83tU+jVUM7dJ6nZ/h+bB6W0K0jCGVuZOGdcyOLSmfVMlzMvWZy5Wwvh1MdDXWQuZCoEqmu+qItMC9jbuDKBG50YinFYqiXMaijmX1yPDdYlmVOVka44RxR8IgZNyulMDjtOQTczwHIy+bUrvEX6OU4AxyC1apX3zWxzj1SJ7uYiWR7Aho/nmbcrQMXGe+88Ut7aHTgKLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Giorgi Tchankvetadze <giorgi@tchankvetadze.com>

memfd_luo_retrieve_folios() logs "folio index %ld" on its error paths
but passes the loop counter 'i' instead of the folio's actual index
held in the local 'index' variable (pfolio->index).

Pass 'index' to the three pr_err() calls so the logged index matches
the folio that actually failed. Since the saved index is a u64, use %llu with an
unsigned long long cast when printing it.

Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
Signed-off-by: Giorgi Tchankvetadze <giorgi@tchankvetadze.com>
---
 mm/memfd_luo.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 59de210bee5f..652dd21e6ef0 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -451,16 +451,16 @@ static int memfd_luo_retrieve_folios(struct file *file,
 
 		err = mem_cgroup_charge(folio, NULL, mapping_gfp_mask(mapping));
 		if (err) {
-			pr_err("shmem: failed to charge folio index %ld: %d\n",
-			       i, err);
+			pr_err("shmem: failed to charge folio index %llu: %d\n",
+			       (unsigned long long)index, err);
 			goto unlock_folio;
 		}
 
 		err = shmem_add_to_page_cache(folio, mapping, index, NULL,
 					      mapping_gfp_mask(mapping));
 		if (err) {
-			pr_err("shmem: failed to add to page cache folio index %ld: %d\n",
-			       i, err);
+			pr_err("shmem: failed to add to page cache folio index %llu: %d\n",
+			       (unsigned long long)index, err);
 			goto unlock_folio;
 		}
 
@@ -472,8 +472,8 @@ static int memfd_luo_retrieve_folios(struct file *file,
 		npages = folio_nr_pages(folio);
 		err = shmem_inode_acct_blocks(inode, npages);
 		if (err) {
-			pr_err("shmem: failed to account folio index %ld(%ld pages): %d\n",
-			       i, npages, err);
+			pr_err("shmem: failed to account folio index %llu(%ld pages): %d\n",
+			       (unsigned long long)index, npages, err);
 			goto remove_from_cache;
 		}
 
-- 
2.52.0


