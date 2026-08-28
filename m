Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24198C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 03:37:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9E976B0095; Thu, 27 Aug 2026 23:37:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E50676B0096; Thu, 27 Aug 2026 23:37:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3EE86B0098; Thu, 27 Aug 2026 23:37:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AA81B6B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:37:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2E620A037C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:37:48 +0000 (UTC)
X-FDA: 85149269016.27.3BC0730
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf22.hostedemail.com (Postfix) with ESMTP id 77A0AC0005
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:37:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Pn5PVbB2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3iAKRagcKCC0fONURYNPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--wfelipe.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3iAKRagcKCC0fONURYNPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--wfelipe.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787888266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bBeMGceDtS7wvXAGGzR5dbY5boET7zUUnip9K7sfHCc=;
	b=JBSvlI4vuauZlD5XF4+oOggZDpsScbra1JVakgzxZYgE+pRVDw9Ug4CG/I9FCC1y1IJgOB
	PAZfgmUMi11r3qaGWTWy5q2bKD+BvgsB+A6VN5AG81jfBK5ul9sQXezMPSUZSjdU5+bVrl
	/2aiJG0f4jCjp8NjKkJm2CNzHvmEdac=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Pn5PVbB2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3iAKRagcKCC0fONURYNPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--wfelipe.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3iAKRagcKCC0fONURYNPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--wfelipe.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787888266;
	b=EjVBDh1r6aBuQ/TF8ESsoiy51GuP/yn5VurUiSdb2Xl4yqOcb3X/X9Vrmkz9mppUreiT3h
	yfwqMUhUqjSp9oqIPkgtOWzpoFAvK9TV03Q/ZKWv3W8luMsEzb8bYv6OUpaKrpzGH6k7MB
	jEmE9WBKpCmyqsgIqUpBavCXTCMUdwc=
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc1cdfb337eso983556a12.0
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 20:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787888265; x=1788493065; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=bBeMGceDtS7wvXAGGzR5dbY5boET7zUUnip9K7sfHCc=;
        b=Pn5PVbB2l0VNqP2Eb4/uwcItYiLSseclUTN4eEf8yok1joFXQ8SlTLTJGY0W22G6z0
         ZpndiS4zqVpGVJaMQ3ejHLU8QHjsGV61XNVpmothvQ/dlb7W3J7iMDjX0ndYVXmI/xoz
         T48/rArRBd6+6upgwaLbPvapQM3WQ35HhcmRXeYI7I7xHGDqdT1Z/jzN+tI0DeZu7Vco
         /3p5ueQORT+iB/l+uk6BZCM0yC1RR54jhFJFdNYUBopzV6y8Vii9Sl3ibQEWrdFDsgp7
         7yq4N+11wESYbZ4A+vV07vuyjQFGvOzdn01XtBTh1HqWYEBW+ZY7/MDmR6rFy3h8xolK
         E8TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787888265; x=1788493065;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bBeMGceDtS7wvXAGGzR5dbY5boET7zUUnip9K7sfHCc=;
        b=X5yvvNNVipj0+neA6goBlze68+8yx4VxmCessC1cBVwN/ShvOQZ8b8fSTZpV5Q74+B
         f1O1c4TDK6/7V5l+Wkdvfb0Vp0Bm1kPc3Tp3WCranaP/XHtZ3BHcojZurQcyr+SGNCnG
         +oprYS8sSUNvyND9JvWw3EyifZiKubnBe1SOk/FvlOCiIwTzgc1UeVg7JNbS249RtTO2
         gRwTJBAzb8sTH98bma0CRyOofhywnjK2SNVjW4Rb04nwZpGmfFRo2/mH1EfFfKK1pTvX
         HJMAtI6fU7vPje5OhoYzAXnW5aAtKhk9TOdISktxi/sIM9o/bmf24+1hF26+NGLor76M
         94/Q==
X-Gm-Message-State: AFuF++nsL+VP2DCWDYc1nZonCdaEJc0Xwsx77CwQnUN3PAECy1brgWDD
	1mTjTdg7RPzy+0SV0O4X7C9EcqhzcwUgshySoW71cQhNyidKcR7YuDlF7a5UbPArGdh8ZPKmAj/
	ipdtBmMDdeQ==
X-Received: from pld16.prod.google.com ([2002:a17:903:3550:b0:2ca:ceab:34a3])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:9cc:b0:2d3:716e:e2ae
 with SMTP id d9443c01a7336-2d74dc5f3f5mr61909945ad.6.1787888264856; Thu, 27
 Aug 2026 20:37:44 -0700 (PDT)
Date: Fri, 28 Aug 2026 03:37:30 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260828033741.2184560-1-wfelipe@google.com>
Subject: [PATCH v4 0/2] selftests/cgroup: fixes for test_zswap on single core VM
From: Wilson Felipe Pereira <wfelipe@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Wilson Felipe Pereira <wfelipe@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: chsnrni6bjesstjr7pzctigcm747ajct
X-Rspamd-Queue-Id: 77A0AC0005
X-HE-Tag: 1787888266-996121
X-HE-Meta: U2FsdGVkX19CKO4Z4fnwoQTQz4zR59xnrNKV8NTfVmmzICTxBTYgZ2IUqtE0KYTVgBQ/34tzYgTZ39IV1rWnAeU2sER4ZV3/Reg8qcncuvlrZhdtrIeYnNl4lz7VT8zim9bGnUDgs39nWjIGaAN1MPuO0g1R27boQd1cRL2jeu2mhjPY2D16p82rlLcDAaWzQ5sUWEWZTHLQWW2+SQG+MbO0mcJKx7i0GVZLsBudMw2Gul/oVqayE6rRLEqhDjVvY6dqae4HHPKbfADP2tg2qiA66u2eitrB+YexJ5gtrrZf/fJXKfSAGe9DjerXD2EMPTLARmGx1Q5ILCcQSDb9QIzCIRpUz9Z+Wk41x3e9ssZEeCX6LFIAk/Q4E6g2UQ9Glrto5ZzCVFuFWUzBnqi8yo98FrMkT/NzYwe6CWKxtCtBtadisqJ9OTtZlqzgk/rQ/vvT3/Q8JApBNctGbxZ1/6t5Km5+RftIjD4tDNEjLx8PBABbGKyV997VLEW1XH7M/lMLHeSyOhgnL+jq03z69dx5Eaieu4n/WcIvDusKol7LeH75EazjZlmH0HVxY0Q8tDRzstgLJHo9TPG/ioRLxe6pJAjCr1YQuniOlNd6XhQEYcmRS458sb+cTklrt1qPezltMUFjaM+GdiJ/7CCjO7ghv235McD8QS28MDyd6ZmSTsqqe7bh1o+tVllloYC/8npPma6tivU8v9idMs5qCvUuJt8YbC6YfvWLwv14j5vvgEfBGnSiWvubwgskpJH9dGOA1/Nl4unkhUBjXX2NZ4pMYt2uK0qOEfcZJxOxAvywUBhDQpckXzO6EI77Cny6Rt3H1NmMzSXM1/h8TOvIaHvftdGNNuUWsZPLOQ3f1cpfmFAfoCQlO5+1K7NgZwn+joKS4/bSJaOegolKuJWnY8GXhuz7MeEPl8RoNUyCBRQE3s4xiaZFF7ymDQd2XxTmr8Ql24fv6t+kae/wwOy
 PFkA0Co7
 SfZ9VpfUJ9FG4+IP3QNShtSthsO7Upb+dgHm/Caqe4FhFure61QAhch3bbkJzOPkq3Nu0I8Mn7yayKtYwLxHQfZ5USaGe58S20RqnzKmhfv4esU60iBbjRVHc4rokNSlTB19XAtLeVz5ely8NEUin4G9A7eNNedARoYCxH9X0GJbe7cPMM9e3v5ODU3g87dFzt7jBek32Sh50Dy6P2yA47TQfhYRZRcDbAvOhJfFseslQ8FOkat2dvAy/U2/nXRmOYF+di043TVvjJWPjcQMP503NrMsEdyTj7bveAut7dlJ82ISvbhnGGbGfjxBxYnjF3hYmhi43WkeNNLxdsMH0GUQUCLc2fEyucUrmRhW6ol7iiisfoDBNlNIcdPNfM4f/iwmUkhmfIdV0FPq05qI5nKx93hoJiQfXDjAIueYa3tX2ivECHE6ixaa+benIQ+L8DtsFWs47Z8UX+Ip4zS1dAXn2HhjdV6ZaPLfS3L+/baToGbLPWCCyjzHf0s10XdG7gkKnSdcXWILU/4X1QVSZ8de8G9acY8s3q/9Ogcl3uA04LaOY1abJ1SrFAbG79o4iQEPGWmBrdKxmMKZkkhATkMYyPnUr4IoP+QPiPXxQM02oO+WjPfHaUdwt65F1AyTqz9Oc3NAl/43/D9BcC2cKMu7K1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series fixes two test failures in test_zswap observed when running on
a single-core VM (-smp 1) with 4GB of RAM.

Patch 1 addresses a race condition in test_zswap_writeback() where
waitpid() returns before the exiting child process is switched away by the
kernel, causing an immediate write of "+memory" to cgroup.subtree_control
to fail with -EBUSY. We fix this by waiting for cgroup.events to report
"populated 0".

Patch 2 fixes an implicit unsigned conversion bug in test_no_kmem_bypass()
where small negative timing differences between debugfs stored_pages and
cgroup zswapped bytes caused the comparison to falsely fail due to
unsigned promotion.

v3 -> v4:
- Patch 2: Use `long long` for `delta` and `max_delta` to avoid integer
  overflow on 32-bit platforms (Andrew Morton, Sashiko).

v2 -> v3:
- Patch 1: Collect Acked-by from Michal Koutn=C3=BD.
- Patch 2: Explicitly cast stored_pages to (long) in delta calculation and
  inline the return comparison (Michal Koutn=C3=BD).

v1 -> v2:
- Patch 1: Replace EBUSY retry loop with cg_read_strcmp_wait() waiting for
  cgroup.events "populated 0" (Michal Koutn=C3=BD).
- Patch 1: Clarify task lifecycle in commit description (Yosry Ahmed).
- Patch 2: Remove abs() and declare delta/zswapped as signed longs with a
  signed threshold comparison (Michal Koutn=C3=BD).
- Patch 2: Add Fixes tag (Michal Koutn=C3=BD).

v3: https://lore.kernel.org/all/20260827034807.2822234-1-wfelipe@google.com=
/
v2: https://lore.kernel.org/all/20260824033533.2147900-1-wfelipe@google.com=
/
v1: https://lore.kernel.org/all/20260804042053.56940-1-wfelipe@google.com/

Wilson Felipe Pereira (2):
  selftests/cgroup: test_zswap: wait for cgroup to unpopulate in
    test_zswap_writeback
  selftests/cgroup: test_zswap: fix implicit unsigned promotion bug in
    test_no_kmem_bypass

 tools/testing/selftests/cgroup/test_zswap.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--

