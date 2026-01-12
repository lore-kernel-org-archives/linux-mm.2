Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A872FD25050
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 08:47:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 050C16B0088; Mon, 12 Jan 2026 03:47:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 002C36B0089; Mon, 12 Jan 2026 03:47:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E22876B008A; Mon, 12 Jan 2026 03:47:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CF5DF6B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 03:47:33 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7A07F1ACF15
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 08:47:33 +0000 (UTC)
X-FDA: 84322683186.23.3B8142A
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id C1466C0006
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 08:47:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LC6cekx1;
	spf=pass (imf22.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768207651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hklsKrrHIgsoCmky375DsGUrVmni2mBT3d93lWnbdtU=;
	b=RaXbWUG9ST1N3fOWZUbJRmH6QaRs7JX5bwjyK8pKAJSl3CcEV4yUN/9Foq4b3gjQE3YzuL
	DXPv9ZChiXR7UZ6KZLRrscuGL08NrBOxa9rP7+2MZTgN3xKGFfrTlblqcGhkQHKTNuIzNT
	HxljyHDSWqzzOzqbuQlz8wbSCTqnjaM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LC6cekx1;
	spf=pass (imf22.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768207651; a=rsa-sha256;
	cv=none;
	b=10I6U6yRUZP+X1uwzoIhQtwtKae3PDNAOPOKG/NQJjHOeVgLKhp5bRjPWclPZOV/EfVHUX
	kbWZBe/TBJ03kXhjLvNdxCBhV95+DocCAk0ecMX/wGFpz6jwOQDb0J04t1pD28ylNygLou
	03lE6O41DvHkXJGEgBzvHzaW6Qb+kWg=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a102494058so21833465ad.0
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 00:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768207650; x=1768812450; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hklsKrrHIgsoCmky375DsGUrVmni2mBT3d93lWnbdtU=;
        b=LC6cekx1FfOJ67wUNjArmrDxb5mtBhldsFnMCD6F/M4/DZsSEeRq9CR9oiJxeY6o/h
         q2mg19wrNvlCHV0H0JEjIyIsCOCfoEsSFNcjXVAlDNH2+15QIjS2ucoXL4Adt41iRRMO
         ODJawz62g/J2xRrgjWocIHHyalk9nAgeZw02LnarlvecuMz+e/dxYD2ZjqPU8gOUsqR8
         +kby5Y2JoSbOauqW5fT0nUcazIUDt49U0U0VUbGK7xKIZ3sUxCXStoN+QThMpAdhnNIE
         HWKIEZhDDwTsGDF8z6Np/pYO0Z4fEvSaCPztfDS+ODupzPGxFeh0FLvN6pvo8RteSwkM
         pqmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768207650; x=1768812450;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hklsKrrHIgsoCmky375DsGUrVmni2mBT3d93lWnbdtU=;
        b=tJCBR/Cth9P2iZDvtC/ubvKPYX8cCgoJ61g/Ccr1v/Pj55+jQdM7bCKXuVKKn4KsPQ
         lQAAaGLip0iaAHAFuGdSgbOh6+i07mvjBdhawFCs7tSV0omnpDP8eLA/BGUCc/I6PIAb
         nMH8DcXtrYbAlSpMZuA6ZvhfSMSzlpoTzBY5yFQ/GBrmMLe/sjEdbccM6f37ohkA1RCv
         MDprEE1QMpznNEPhOdUENBcXnRNsQbdlBVKyfy9MrE6HodwCJ0En6YqaDF8KfKRkVdkI
         uGyMsvaldVQVezgYa97j55THPvMCUxmMj9Zc1737zqloW6AHP6FVMtcACKyb2L8wo8P4
         BdUA==
X-Gm-Message-State: AOJu0YwLr6hGUt7roPRqXLy9jkUfIyiQwDbTcFxhneIR4m9t4iA23ZZ2
	+OjS9ae0VB2Np0Qgag6bMz+EGp4r+QOx3cBMZaPEQeFY/NcKAPBLkb/j
X-Gm-Gg: AY/fxX6zGmZ3prbOCk3sLA5J4vvoB47NlzTOv/qfc0LDmoGgQGJ/SFskUNNvFh0WBBl
	TDgDGmFG1jr/WUM37VDwFP655yhCg4r8+St0O2r4pAtsnXz5Jd2+AWtONarn+ptb1TJezhFdqcB
	dlwUczI1F3teX1VDlT7SzQGLI+o0g4ODEHeuIjnV4K25HuM91oLN5qJquNryNRFXdisMWoqqPT8
	qP6FnpOMljCgfFDUIYhC4/QImp9/EGwDhRoAAJluKxgnW7aiAsKe9SBrQJoCUyaplTSFu2gPo6L
	gO2IWqDyu4UGf6BWBhjKpScrTpFEQc4qx3sDLNgBNLbp2ZATjor2Q+7CXm1PK1dTriME6GyjqGK
	tHzq5wonsw6X+8E/O6sZQ9Uu0/Zz7a681vi4HUuoVs6zsrRdYP79naXQv66p0WlSLoo3VOYTJHe
	Y8c5wKnIPquNr9QHEEejyRP31OHIGU2q3AoXI4qEhnxBsC0/Tegnk8UUCdxrq0hqLie48=
X-Google-Smtp-Source: AGHT+IFnYxNSqiGxNAqd32y+etQrz589zxynwCAGgapm31trBYhiWdXuubNT5Yto2ExOwPbTaMgHlg==
X-Received: by 2002:a17:903:11d0:b0:29f:1b1f:784 with SMTP id d9443c01a7336-2a3e39828f1mr207992795ad.4.1768207650502;
        Mon, 12 Jan 2026 00:47:30 -0800 (PST)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:7751:dfe4:62a3:f9d2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c48e8esm53450075ad.37.2026.01.12.00.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 00:47:29 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: akpm@linux-foundation.org,
	urezki@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+d8d4c31d40f868eaea30@syzkaller.appspotmail.com
Subject: [PATCH] mm/vmalloc: prevent RCU stalls in kasan_release_vmalloc_node
Date: Mon, 12 Jan 2026 14:17:23 +0530
Message-ID: <20260112084723.622910-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: aebwa9be9aac9o9rst8itjqaro7b6e3q
X-Rspam-User: 
X-Rspamd-Queue-Id: C1466C0006
X-Rspamd-Server: rspam08
X-HE-Tag: 1768207651-591755
X-HE-Meta: U2FsdGVkX1+rW97CURnbQ0bPfltVyR1U3b8xwz5iQnsVj1oK43J+R2yLJwqbBINXSViuNeb4XhozMqmaNDmhihpJmNSKL6mk9i+YCvMysxYwa6GINwHTexBBNFWf5zsxPxdumoPFDsbGyOevogV8A+uqp1gBI8UB/90qLb7D1ZZUyUTpMQIhCMVrIN3nu5qduiT69GrpEFAoBUENdkd0jCVp2sLBaIxnePwiAByWFrEwD/beV6UG0UQ3O9TrzWjz/LKGmutJCKaC9+Ttjnf13hW4ympwPbHQqmbnumOXQltIlMBt7GTzMc2tArgSHQeTcE3h+jkrffo3oWOCnqxa/K7YcDZZJDrLXwE6oAtYGWhGptMFgsJTnTdboL1+Fn+jFtexeLvTRx/VTbysozklu8WIRkLv+88QpIOhtCI5lB1bqKz2szxZ2T5/HhgdPH0NLiBgZ0Pq8l6n9ovgRnalAtMQTkVRdqG2NNh6cZhVAkBXg36ou3MsKOPr1sxbzxmejiyFjm8PyOux8Rg3VbrYQJSf5LTuj2ZC8zWi9c9LJZRdUVUBDqSymaHehX1zhorcV0ENyxpiGXbDic92NwoGCJhbZLgMJ3Kuz+2RTOTTySEE1795I+se2KczUAJGYF9Gb2vl2cUMzbOl3XCAMv6FBczaPJLLkK3dfV5w2H8/JefIxxM1bK1dGyHUn2iiFzb7VsZ+UdNZx8V7oWkamPP965/7IwEX8z8SwJ1aqA9YEhlSkun5mb02SZaDGSuehgR/uAt175kQr9IOx+P0ggYbNzpN0QCrTrPWZSYAKBcMpM+Qy8Ijtz3HJ8NzyVBExL7PFWcKO746HtWb0noZ2Qs6ClBUaPdOtQEDwgsIqKPxG2rcdOvjHLWm7QVUSN0TI4wRtCAdd4ha+Old2WBcw5JBwyWnmMRYV5xUv9Ag2Xcn+YIpbHzWAK037RnBNPQQGBek2bkTLmZNNjWpLoUGUHB
 wkPZY8+M
 JAl5K3N/wLFpoFLMJ3W5K9taE0SfqvfmplqqmTZiWzE3UqNWhqEbyvnUC+Ko8opkWcp1AdUUR+aL2YXmasJu2I7pKGGFMdVDFv48WtrIPZ+HUjpwASiUlcWaAOnNAOSqlnd20QjiJlifQGcf+B3vZi7Zl+S8yr4DS+rnYro8Pl+woSVUH1IS4ib/LCuR8drZUYIu6kZ9kAMlOkaQ00vRBoE7DvNaARENoIuwq307QDjsBBHfVjvvCEHKvkTseWnLjJZI3ZumadY4AFt/y9iUdMy6zrPzvcpxfox8t8wQZsKUVQx1GWRoHBfw3xVpHujHdQEItJCmg8+lbMkSEPrTr0yiyu2jslmtLvJbZDK/GyeeTjjho2OaVsKX0CZ8Pix9heiOulOK9SuYxx5MyAEfkBcE4tFN4ahuKFASzHtWjct1NXvZU16HygqNJ4jZ1wGrSh8QWi1S4PF99S8euxlXCYYz24ngcikIhPobq6pHBqSTuChg7Mdvpt4CVZxtBWgRt9sJbIfW/hq37BqAUQWQG2NeYwR3wYNTE/eCcrMsakIFTyo9NRQb1KYq2VAfepO13orfAcAAZtgcW+fL5jYqKpYMgh1BTryMJ3XD45Ah3YBRYb4Xe1zQuE6YrNwmlOmKs2b87ZYMYJ2XEIZ9HFsyaus1yJt+NwtI7oAFbyAKW5hFnjyRdXq94u6kd+O9pFZZ0ZFQw2LBpK3MCqyc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_PAGE_OWNER is enabled, freeing KASAN shadow pages during
vmalloc cleanup triggers expensive stack unwinding that acquires RCU
read locks. Processing a large purge_list without rescheduling can
cause the task to hold CPU for extended periods (10+ seconds), leading
to RCU stalls and potential OOM conditions.

The issue manifests in purge_vmap_node() -> kasan_release_vmalloc_node()
where iterating through hundreds or thousands of vmap_area entries and
freeing their associated shadow pages causes:

  rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
  rcu: Tasks blocked on level-0 rcu_node (CPUs 0-1): P6229/1:b..l
  ...
  task:kworker/0:17 state:R running task stack:28840 pid:6229
  ...
  kasan_release_vmalloc_node+0x1ba/0xad0 mm/vmalloc.c:2299
  purge_vmap_node+0x1ba/0xad0 mm/vmalloc.c:2299

Each call to kasan_release_vmalloc() can free many pages, and with
page_owner tracking, each free triggers save_stack() which performs
stack unwinding under RCU read lock. Without yielding, this creates
an unbounded RCU critical section.

Add periodic cond_resched() calls within the loop to allow:
- RCU grace periods to complete
- Other tasks to run
- Scheduler to preempt when needed

The fix uses need_resched() for immediate response under load, with
a batch count of 32 as a guaranteed upper bound to prevent worst-case
stalls even under light load.

Reported-by: syzbot+d8d4c31d40f868eaea30@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d8d4c31d40f868eaea30
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 mm/vmalloc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 41dd01e8430c..a9161007cf02 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2273,6 +2273,7 @@ kasan_release_vmalloc_node(struct vmap_node *vn)
 {
 	struct vmap_area *va;
 	unsigned long start, end;
+	unsigned int batch_count = 0;
 
 	start = list_first_entry(&vn->purge_list, struct vmap_area, list)->va_start;
 	end = list_last_entry(&vn->purge_list, struct vmap_area, list)->va_end;
@@ -2282,6 +2283,11 @@ kasan_release_vmalloc_node(struct vmap_node *vn)
 			kasan_release_vmalloc(va->va_start, va->va_end,
 				va->va_start, va->va_end,
 				KASAN_VMALLOC_PAGE_RANGE);
+
+			if (need_resched() || (++batch_count >= 32)) {
+				cond_resched();
+				batch_count = 0;
+			}
 	}
 
 	kasan_release_vmalloc(start, end, start, end, KASAN_VMALLOC_TLB_FLUSH);
-- 
2.43.0


