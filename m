Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09C79CAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 14:49:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6830D8E0010; Thu, 25 Sep 2025 10:49:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65A8B8E0006; Thu, 25 Sep 2025 10:49:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 597BA8E0010; Thu, 25 Sep 2025 10:49:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 46B688E0006
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:49:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F3E151602C4
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:49:46 +0000 (UTC)
X-FDA: 83928056772.05.E1CF07F
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2585A4000C
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:49:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k2g4U5yo;
	spf=pass (imf07.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758811785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rovQXBMGlH+WdMko9tBwUJE7c1iL7Sj9W2ARd93iF4Q=;
	b=RASsxPnFj1BMmklZCfs46VgET+vPFSS7dmthMscpSp58sAjCyUCzKCDhbK5H90WG9aYuNc
	qL46RojQ/DCMvs4vVC/IvtboEa4WlRmvqy9nWUggw51p9H5pTWBNf5PAc//og/mFOJjKOA
	ikj/qhur2wX/7qTNhXaey0XwNG4Nmco=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758811785; a=rsa-sha256;
	cv=none;
	b=637OlPecC76gxthe0jOtsDaM0LVUHZLms/hYo2GdvRKS739iCdg6ANjMobGdNk2tbbY8At
	30OJ1dRZ+00qee+H2APkLFnywqH+TDhPlrYJlZbUl67GO6gcubyP5Qq/j0qYSHuL3VKoW/
	sZLilpwUoVT2vMN6EQN8VvYsjy1HWbk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k2g4U5yo;
	spf=pass (imf07.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-27d3540a43fso11737445ad.3
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 07:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758811784; x=1759416584; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rovQXBMGlH+WdMko9tBwUJE7c1iL7Sj9W2ARd93iF4Q=;
        b=k2g4U5yo9iBHVb5tYs+SjiCaomp/ZW6ldAv8o6Nj3hexsJsBLhebOMa2eQ5WuqNx6I
         fMPuwA89PfxFPVdacX7X4pslccToGJ42iLba2ugEKurEbCaKP7s3RDXd+sthYgbRhGQu
         GeYR1CGLpqWPKoiq7FtGtaK0jf2kR7EhT2fi+pqXi0//RlQkcoy0MbMA91c7pAS+n7jl
         ll5G48l/rfxvHgku8kkByUYNaRMyYlGApwQSG6GD80HIhQOPHZgWDhiVckQEJdiRmbhS
         3mZUG+5ZXf8jJ+OrPM4IkwbLZCzEmpfFsToatzZgU/lD9kdX7cnigtIeLOjI1BezViw1
         YkjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758811784; x=1759416584;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rovQXBMGlH+WdMko9tBwUJE7c1iL7Sj9W2ARd93iF4Q=;
        b=eZud7cy2aJYz0OJs0cTRNNa8IfFFf/nC9s45kXe8LzrdpGNFlOdy/QQw27ECMLQOps
         la393/S3j0hRxmZoXu9wZIvRctat+S44QHAB9sJVUIFe01T3Rs2XDBDDnRS6fIE2mKFe
         t7ggARY1/6tJDmZA99+12L3qkiTx9G0D3lgKBegNMyFUYilJ6TgptQmJcKbmF5VIa+ff
         BT1X+xShrPsPf/T5o5FjnIegSGPWSl76uXBp4F8zbitj3a8AeIK4W7r0wnUZKS6IvdfM
         6LV2E35bliKa2/ekTvVsU3/FrLWRc2bfi85GE1/3zZJlRJZaRmMhTL8wF86YlaxG2Lcq
         nhfg==
X-Forwarded-Encrypted: i=1; AJvYcCWbRTVKWMUN5GpCaVCZF/Mt9y0ohau4FuWoTHztWfoSfZe5LSgzxRxRgU/VAQ73bHwAZf0cu0k45g==@kvack.org
X-Gm-Message-State: AOJu0Yxa82kA2CseNkrTjuKxVCa7ogRI8UBj+zIhltc4biejwhD0Bd8w
	zU/KyWGJ6okoY2DKAQyD5dg24wW+IovnEisP9sXlIhvYqsDBkY03r/8h
X-Gm-Gg: ASbGncsoQ67L6HQtT8q7qjRx9wXVBEmbO2JzG5AHmiDMpG5xvEYTg1REqjAKamDGmja
	UuKRiS7igPdeGeKLWgNqe29njLnTGpWrUoKfrd5uPiScctTu6uvtZpDBy/Rum1o/hDc9hoc0dEZ
	joqVcY4KKZF4ScG3yzC0N23rN8VuJVnUOv6BBhe+epgF5iMPDZKUv7fFZcHhdZpLy0GEe/OQWyz
	fclFFpo7DoNcBoA+50hZxNaJDZCQRrzYg1fKt5xtmwyyMx6loHuO0XL9j1ozenTX1B7+FFtf8Gh
	eX6n/8UfcHRWIRxmRdOpyGErAu+I6StYcXP0lhexPwlpZs6SXi66wLigZu2ob37ilzZqRnh5Cf+
	Jk8MbkUnrg5r5hToPVaWumua7RSSm9zP7ecv1zV/heY1Kv/PvItnE38CcCN3OhnanTxSYnZJd/W
	P6xpA=
X-Google-Smtp-Source: AGHT+IHCZkipERRfFFQvCNVbKNbLe7gqjyfLJr0sdOftwhgT3H9vNK2pNjmfJvAfYa/v+uljVYabag==
X-Received: by 2002:a17:902:f546:b0:273:240a:9b6f with SMTP id d9443c01a7336-27ed4a76ec0mr39941125ad.39.1758811783941;
        Thu, 25 Sep 2025 07:49:43 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:3094:17a4:33dc:a325:4bce])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed65e8e89sm28432605ad.0.2025.09.25.07.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 07:49:43 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@redhat.com
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Subject: [PATCH] hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list
Date: Thu, 25 Sep 2025 20:19:32 +0530
Message-ID: <20250925144934.150299-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8obamk8ze8n3yrmnzirx5jg8q6zou7fs
X-Rspam-User: 
X-Rspamd-Queue-Id: 2585A4000C
X-Rspamd-Server: rspam10
X-HE-Tag: 1758811784-675558
X-HE-Meta: U2FsdGVkX1+BJN/ZNNGokwpXehDtj9SyEdTClK904Wtrpx4WldMrISqOTuF5DX53APx4j3bsb3Roh4LW3lpcddQrEmUl5mIYqot9A72PBK8UbVUFHxl10IyEfFHZo1WQp2QL4EsrN3unS5cMAc6FbdYTUEKO2V4AcwkY1/0CfgSCcftivT63bxaiFJcuQq1gs4RoC3swuksk0ZfuYFm+tuuBdLYyg5jlb7b5lvWHjG6x80Gc3weMQh5OAXfSRv924ZXeH2o+1Ri/Xnc5e8ViABBMkczwhkqhLjXY8WxuHgDo9CqKsXKRv4jHK+A5vOKVoUl1x5fyqYKurzOnnToIhWkM9jCbRAYSHbwZryVOJy6Xppp91f+QK9YccIaBWeajkxih1/nKBr9MTLb9yl87g2guCjxFo+wfabB+8OfHNoNbqDfWlOBorx0vqGavkXXxc2NvEZr7p6VBQBOY8nVm3LAeNz0qR27qNhE3XTJPyYIL/6RaqUhkrQoLrFS7GeLmhEKx19hk7iii3du5s0AJUCW02H7+uhqGrsc9qB9v90UBoJKgYYC6lzBLwNfYcR8uJm99B9PJCnOnzE8ORwT5rUJ5xibAOvzny97buEK43wWME6fDBnz0hv/W6C1olsDfowrUDwthuukrcUlObezyEFOtTUCQeDDH9c/mB6Gjg0Ov/5WBqrBnYrZ/1uYWQAjV076bLjDDGS6GQoUQPXBTzqXLbWPkMz0O/he9bmmhxBXyQa8hkCmcET9VMqAUMVzdPCeGhU1LaU8PDDkcOqkffNvd06Rq8THBbguqKVuRbG6smLWyY3us2BSqBjjGp46Fvu+l/LSqpe5KbyycDpzkeR4yTeCsbY1ORDkOhhFzYx9tPuGoepiusucO4D1W+EGc/lt3UPh7GP45sAPD4OD0IruylQBp0Jtyt/aMHq6G8qAqZVDq8moCt/hKsLH30044lKJbGYocnkMnC31W2ua
 WRYOJGu+
 bQmYFHd/6z/g4oIozCVQHgcr/rul0l/fuUnrG8RjX7AoP3k1dKdAAjnIOJGj5wYtpfkWX5+Hn9zuRQLvWLtOEPsP36VhK5WTA5nOTJVLeMpT2zWz7VH/tTeiY3kCgSsjFueIwr1Lo8Zds1B9JTaSF01IP/L7VnWD4F8IhSUKyGmYTNa10wZ0fz6fhNk2Jo8D0E0pP7Lzab6wQAB1iBLJBcGFmc5CEirSaRt/0ZdgKX1CyAl2N1l1WEobjT/LIj0YUCahJcNm1q4hG6BP0DXNLWXTJ5DaEe7DPiNh8UJIstdRkDBzlve2PzZXjuaBG9eT6aNv4/uqdNOXPrmV1QH/B74zogeTf8t4I6iBl+TjHBEjg5tmdV5BRrWK9I+foF9BBf9wnN0f/ceSYleDIomgLlHLhIj5/uhjJp2rlAu0QDI7X911NyUM5eFXOeSNXW7Z+gKGVLb1mruSznLWa4MbWIOnbUoRJpBKNuE4z+/Q5kaHJOW/QsbVBYjXpHlkRevIBHyMzfe/zTKUeiGMp0CK/g+gTNL4v5W/RK+LpEOgRcXDquyA1YygAueCPYMshJuE3wVpfUuUDV7JRT/WQ2lb6vAFlk4o8/DWZ8WMINUJEYbgfzOTNFOc0kGdRVPWEAvQsC/X+CprwLnirbuzoP+EEIIE7I9u6k1y6+MIcRCDKK583EDgJzj2mG8IZYO1lheNixpS6V5AT4Qbebu+fSkRTpZLrM1GCZaeCAsNzkW+fA3ueAFo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


hugetlb_vmdelete_list() uses trylock to acquire VMA locks during truncate
operations. As per the original design in commit 40549ba8f8e0 ("hugetlb:
use new vma_lock for pmd sharing synchronization"), if the trylock fails
or the VMA has no lock, it should skip that VMA. Any remaining mapped
pages are handled by remove_inode_hugepages() which is called after
hugetlb_vmdelete_list() and uses proper lock ordering to guarantee
unmapping success.

Currently, when hugetlb_vma_trylock_write() returns success (1) for VMAs
without shareable locks, the code proceeds to call unmap_hugepage_range().
This causes assertion failures in huge_pmd_unshare() → hugetlb_vma_assert_locked()
because no lock is actually held:

  WARNING: CPU: 1 PID: 6594 Comm: syz.0.28 Not tainted
  Call Trace:
   hugetlb_vma_assert_locked+0x1dd/0x250
   huge_pmd_unshare+0x2c8/0x540
   __unmap_hugepage_range+0x6e3/0x1aa0
   unmap_hugepage_range+0x32e/0x410
   hugetlb_vmdelete_list+0x189/0x1f0

Fix by explicitly skipping VMAs without shareable locks after trylock
succeeds, consistent with the original design where such VMAs are
deferred to remove_inode_hugepages() for proper handling.

Reported-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=f26d7c75c26ec19790e7
Fixes: 40549ba8f8e0 ("hugetlb: use new vma_lock for pmd sharing synchronization")
Tested-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 fs/hugetlbfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 9e0625167517..9ba98cab3388 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -487,7 +487,8 @@ hugetlb_vmdelete_list(struct rb_root_cached *root, pgoff_t start, pgoff_t end,
 
 		if (!hugetlb_vma_trylock_write(vma))
 			continue;
-
+		if (!__vma_shareable_lock(vma))
+			continue;
 		v_start = vma_offset_start(vma, start);
 		v_end = vma_offset_end(vma, end);
 
-- 
2.43.0


