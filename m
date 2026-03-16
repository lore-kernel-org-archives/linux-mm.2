Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B833F53D80
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 17:38:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 485596B032F; Mon, 16 Mar 2026 13:38:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4333A6B0330; Mon, 16 Mar 2026 13:38:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3356D6B0331; Mon, 16 Mar 2026 13:38:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1FF526B032F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:38:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B46F5C1834
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:38:45 +0000 (UTC)
X-FDA: 84552636210.18.29E92C5
Received: from mail-oa1-f74.google.com (mail-oa1-f74.google.com [209.85.160.74])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0E6C5140004
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:38:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GYQqJ+Va;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3IkC4aQYKCNc3O39BG9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--avagin.bounces.google.com designates 209.85.160.74 as permitted sender) smtp.mailfrom=3IkC4aQYKCNc3O39BG9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--avagin.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773682724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mVyENlZI52oMTiLm5o12STurvmC1TDldb84Az1JZAKY=;
	b=zZutJraPuIme181x4Ys/IvBQDrKCQS3p5SgwW5Ihs3rIBojWoi8K2uMnTY9jVl5vy9L1PN
	H1CQqX40T9iV5TjqgAipkPIAoWGdx31wDnVz6SvTqg+S43fPGnknTGZ3K7r9md/+yyWLgi
	wmBaTw90TzcxN37gsRCqIHOHQJV4jKM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GYQqJ+Va;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3IkC4aQYKCNc3O39BG9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--avagin.bounces.google.com designates 209.85.160.74 as permitted sender) smtp.mailfrom=3IkC4aQYKCNc3O39BG9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--avagin.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773682724; a=rsa-sha256;
	cv=none;
	b=XC/2kNKLtO6vzobrjdhtZN5g7LN4udMaaxyx6dIN7rOd4EJBzpNi63+OnVZsGBw/RVj41n
	KUkz3I3Jqffc+x3jlFZ+XZ0EHgmuZSKIOvrBFFNdORabOmJ7hohRPQcWsH/624xDKbmVRM
	RI6WYEXYhhMaVWDX+rUNTHHHnZZbL6E=
Received: by mail-oa1-f74.google.com with SMTP id 586e51a60fabf-415e1ea16b4so60128323fac.1
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773682723; x=1774287523; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mVyENlZI52oMTiLm5o12STurvmC1TDldb84Az1JZAKY=;
        b=GYQqJ+VaxhuCAGHis8G3SFeeZe3FVyiB0aQpySody1VbQt3E30Jf1hL2eNXE+tlLI3
         Wt7G1E6z12qnOpyVweA1kW2UObl/Hha1y4HNBs5gOHqPR87M4MT90UP8Vp/zioazD63x
         7cqicXNnnn+Gb1++yadRooQVKw4oYUFDeW8Hl8BEh1XNlPiAEAwmXt+FnpoyFKh1RHIY
         dhktaywkTEYn/10874QvY+swNj3OB4hzDI93UWUWpADj3jCpUwfwuQt79N/oFE80PAbx
         W1WU4PysrVXzC994Rdk8Y6p9LHFHaxNTydULCnKZ+DsM1KP+yrBtv4F/GfdL7/B6gABC
         hLsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773682723; x=1774287523;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mVyENlZI52oMTiLm5o12STurvmC1TDldb84Az1JZAKY=;
        b=ZmG1HIShkcY41ZPJetR+B6Mgj3BkuTOk8Q/xaJW0gHa2dXM2i5LUH2YOGE7l/ucZfo
         G/BZ2pxwnjsxvKXEBAdAnV2o006ogg9cGttpUtBloDFsTinYLLmqVC8IbV6+ajzbxpKc
         NZ0pkMvLXMPOVVs5WhH/k5+MVn2pcNeKtrPr/V5nGO8dXnhI3+GmbVxHgwav+CNnaQXX
         GUCul0eEAJSlTrpYDDqSjd8YcqsDGWc472AUPjvKMrm20uBYn4z13bV2r+3QS3zjLxCL
         goqa+7MQMpQXSKWlw1opvv8OCJNVkObK5VUJbYY0TQy8v5+o+FjHAW+DznKWb/VJAv7o
         TQdA==
X-Gm-Message-State: AOJu0YwFsdxQZ3zuGiXlxmuRIYGYroRDTx8Xvyc7lRAYR88eEmmYn61T
	968gv+QIxmJWUcyhsbNRSEMmK2+AYR/A013ePbGuBrwomMCN8kovSrZRCav9oT8+uyuIlQ5lKn6
	OBqXbfQ==
X-Received: from ilbed12.prod.google.com ([2002:a05:6e02:480c:b0:4f7:2844:7b8a])
 (user=avagin job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:2909:b0:662:fbd6:1849
 with SMTP id 006d021491bc7-67bda98cb6dmr8942754eaf.4.1773682722483; Mon, 16
 Mar 2026 10:38:42 -0700 (PDT)
Date: Mon, 16 Mar 2026 17:38:28 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260316173829.1126728-1-avagin@google.com>
Subject: [PATCH] userfaultfd: fix lock leak in mfill_get_vma()
From: Andrei Vagin <avagin@google.com>
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrei Vagin <avagin@google.com>, syzbot+cf5ad2009a9bae03cb23@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0E6C5140004
X-Stat-Signature: 5wboiid5zm7d8dj34xxba8s9yw86wnff
X-Rspam-User: 
X-HE-Tag: 1773682723-559643
X-HE-Meta: U2FsdGVkX18E5p687FGkDcbdLHQ9PPgG18hP2ONeuQdxlW7iU2uxeV0P1uJPQUc0VnsDi3r7tB9uklzUZW5amcX5CEKYZ/9FrChhQP5KJr/bjNpxtHaQ6vGXr0D2ArzyrrklEuA3kTCMJPJaSPkctFaKOxKPB/Tsi7SydD8uu8WwVe2ykYughxQ8xhW5fJMfUaFF52RZhD9PloscFRaL3C6GHgq964gzZdLkN5znYT4Z17n9rYVn0GBJ/DdqEFdlhB6WOqjbkIL7e0nDNJhNkKeqg5/elVwO/gDyD1H1EyH0vi/KD8VHdEBZI/barggdzkragHnzC8ZWcNz9onkMZx/ZkPtaovM4wm1bI7UD0PpGzUKJjdedxkx2GbuHb4Ju4cF+JLvnnXH6GF+EdCFhCUkdwEhK2DUZqcSumJun06yn8qS2BW2n7FkpCJoEdTAP69q0ka/bm98USNZ9LGDzmsnqtdQBwKRQ+qUcL+HjKS2JbAwmYZtSd3OyhKRAKmV9t1nJ+uJGSrm6XMtV+hJxS2tvfvvDYjQUJgXixKutIFAz3GyurunT9RRrzJ7KOza1VUyKb+mFEctfjUeVG3wpxNhrGL7RyVcxx91MIQEvzpcq28sYylODRNxpPlEkO7FChWed1XqFPaFnSNrlJYvnIhYdpNGXQ7+VSTlSatCD3TUl/t31shMne3fHrz92Ir5JKLSQ8TUAF75cYUSvjZzldwyAt4uI3CD2HjKncoBZdyJdCVz65ClnWNFU0pLUSPikTrtcwnPZvJh70u06KK/4QvTSXb144DBCr2P2cqpqdDid+1Wy7AdgAAzexaBdjWVuKV/9PrFW9YVGmkPDUeGbqSSceDwYAutowEn2nsjsN9U2JR+rv8Coqx3i2kn0IWrspPHkRlpD7RgHZxbbOAts3WTupFeQ8JAcqMhbhXAHsD5t7UpPCpgg5CzXf4oDYUj78Z0IIBcA6j4Xs7owGl6
 nQa7f+4o
 DapeiYhx80HwlXVGAJsSPGafLC5796eW3xzC2sY9oOWCP/rYxSdieaBKGAtdEgEzl7iVlI8eVgguVAtJZ73Q9h32brAjPpN1y1CfII2nTxDgD6g1hB3d8zrRkhRDKIgnGiiYuHq46Ow/HnmNDl0QqF6t/cw+pSXE/qGcjogj8ll92w5pbzh9jfgIW8xr6kHJVKp58cgMpvFjV50mtH54kXaff5ruq9Q/7W/1HMDOWoqjbINvmeppqEWuaBrg5RE7Mt60vL84433yK30MxpqUGF2FATi0gIGrcNq6ix3gM3Fjg31gtvdy76yyjlsyDZQ7EG3hNBghbRgDR8zqMHu724WLpw0dXbZvxg9Y/dCvaoBAK/VqX2n3MK22CMVwWGM9MusoTu7BJaXggP6vGmrjjrvB+f5v9Ul0fbUD8qYbQqNZSCoTh2nqK9UwwUrCvjrkCZgmnkS7axCa41RrTJcqOINyvvjRg5zaSRL9VKmay3jsTokz6r6gKUrS4lqOtlyIpIy3f8ne7QVHZTHmWGVuaUu8eYUapkYWA78mii1T6dMpDSD3TLhVR3lBmNucDy9LM8/A6dIn+0H1pC5Br51/pGbg8G8kGDkauyV8ORtPchol6JV+LjPuDFsvirFPmNa1rPdWDLYg1bQSgBbfrPmZPlDl5HRPNY1RL3I+Zqtk6/NrPa1f8tOP3qlU/dxMrPDrajmwwKNjXHZ+isugsk5CWJ2QQg7WfUP8X6iMVOu0b78Hux7XzbFWb43akgKxHIkqlES2ufOWsKVq/F5+0VbikIPZiNkMfILg+jXJBU3dbD6NDtUoJkSAVyAca9DL7h/HdS+z0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In mfill_get_vma(), both the per-VMA lock (via uffd_mfill_lock()) and
the map_changing_lock are acquired. However, state->vma was only
assigned at the very end of the function. If any validation checks
failed after lock acquisition but before this assignment, the function
would jump to the out_unlock label and call mfill_put_vma(state).

Since mfill_put_vma() only performs cleanup if state->vma is non-NULL,
these error paths would leak both the per-VMA lock and the
map_changing_lock.

Fixes: akpm:userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy.patch
Reported-by: syzbot+cf5ad2009a9bae03cb23@syzkaller.appspotmail.com
Signed-off-by: Andrei Vagin <avagin@google.com>
---
 mm/userfaultfd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 9ffc80d0a51b..04f9e21fecf1 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -224,6 +224,7 @@ static int mfill_get_vma(struct mfill_state *state)
 	 * request the user to retry later
 	 */
 	down_read(&ctx->map_changing_lock);
+	state->vma = dst_vma;
 	err = -EAGAIN;
 	if (atomic_read(&ctx->mmap_changing))
 		goto out_unlock;
@@ -246,7 +247,7 @@ static int mfill_get_vma(struct mfill_state *state)
 		goto out_unlock;
 
 	if (is_vm_hugetlb_page(dst_vma))
-		goto out;
+		return 0;
 
 	ops = vma_uffd_ops(dst_vma);
 	if (!ops)
@@ -256,8 +257,6 @@ static int mfill_get_vma(struct mfill_state *state)
 	    !ops->get_folio_noalloc)
 		goto out_unlock;
 
-out:
-	state->vma = dst_vma;
 	return 0;
 
 out_unlock:
-- 
2.53.0.851.ga537e3e6e9-goog


