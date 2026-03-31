Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DB6C1061B26
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 11:00:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 988076B0098; Tue, 31 Mar 2026 07:00:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9119F6B0099; Tue, 31 Mar 2026 07:00:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84F9E6B009B; Tue, 31 Mar 2026 07:00:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7627C6B0098
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:00:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0EF7B5CD58
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:00:46 +0000 (UTC)
X-FDA: 84606065292.06.3CB45EE
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2FB662000E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:00:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=i6VLUgQA
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=i6VLUgQA;
	spf=none (imf13.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774954844; a=rsa-sha256;
	cv=none;
	b=QEuILAhTVVQozwVlamk4eH/kqPW/cBWodbhFHuZeZK9wGudo0ke9/zdUPCXSlzvxDSdxFH
	pLB2F382eQbXe8KtzqyOLe52knNPD9s2I5UV6+DbpLK5zaEcWy0zgE4hxKQkYLRvKL7Rkd
	KGuPE41KuN3K+626ksMeixyaVB+75eo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774954844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ej999Lltj3psDX+lSQBFgt+N0EJ87JUHiVq66s1ytUM=;
	b=ccdYkRlDcVyRt4X89LW/AJEUkdCeBWfi0jxfP76dLaiBj5M2JF+i/LPf1Jm/GcHuzqZFU+
	fDURUkgZAqMqvYj5lwuV6fRVaNfde0fVqDd6uQt7pwceg8NDqUCg7tuxB2egbeGKdhfCXp
	QPtUEp30U7Y/1gazOeZ8KmM23IsJFCs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=ej999Lltj3psDX+lSQBFgt+N0EJ87JUHiVq66s1ytUM=; b=i6VLUgQA/T0U4Tb0sHMae0huaZ
	DcHpw+WDe4WKFSLgNEx6/iYQ5QKrY1wYAc7PlcqpMNjdjsX5kn8EhzI7DZ0OZUaysRpoSAFqhIgwD
	ZngqZaFcB9zZvKGWzZn3GGTclUY2J2wp9RJ5g93XeBOWbiLlhU99/9uRk9PUGld31uog+4fpMj3TB
	S13iCPBlXulv0Jr8k4gmNRWXzbt7KLO2ZXDaITx4kyLJqidYNoRngbqtzlQg3sI7y3TQqkR3h5TYe
	OSsgZm0bFPTvqARhR13J3SjMdiOxt5owZOLQjxlHl4YBYrIg2GGNrIts692bLvq8uVwTnaWP2Lcez
	GuNN27hg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w7Wpt-002Ab1-2Z;
	Tue, 31 Mar 2026 11:00:40 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 31 Mar 2026 04:00:18 -0700
Subject: [PATCH v2 3/3] Documentation: document
 panic_on_unrecoverable_memory_failure sysctl
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260331-ecc_panic-v2-3-9e40d0f64f7a@debian.org>
References: <20260331-ecc_panic-v2-0-9e40d0f64f7a@debian.org>
In-Reply-To: <20260331-ecc_panic-v2-0-9e40d0f64f7a@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=2203; i=leitao@debian.org;
 h=from:subject:message-id; bh=qiZP3pMkiWVhwKRsjcSJIBXS5tm3G3sL6gwl8SO35OI=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpy6lInoiOsKvmqn6zqDWvDEROH5pmoV+ihKV/y
 MR1/drgwtKJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCacupSAAKCRA1o5Of/Hh3
 bRPXD/0eaeyWiE1Kspzsio63y3xZCajlbk7YAuNAZscwsWBzwt/us5mtJR+/U1FW9IxJ1aIde12
 23iTxJZeNecTeF/tpBu/brJ4fm9HrKL/ws2a8q6s1OXwFtSPbQq6JIJmCwr2xvMZ6XUTrfJLpFm
 vBsH7/XV2NTRcgLS/lXd4yl3bqP6HcseRaUk2RPCUeUXUJ89Bdlpaa7VEc31qag+j573OQxpaYE
 cBjddR29bMmm7RUsd/JbrOlPaXioD2as5uj8vRsSQmDgxs34e7PZIqqvp4mYbZdShzIQW+KRqo8
 iiKbtOM12ujLYlr/580y80C3Z/sxy5VsN7pciBU9ajWSFhX4C0Ze5OldxRp309jzSnucUWDFTE+
 ppp4Ru2UjQFJdG4p8hycOZfFswIC7pR40Y2Q7FIrYj8VwOTiZfhPqhWccG8KwMyhExQnseAzc6o
 VmekuFk2Pk5n3JD2I1844DzPag8gx/qFCgVNNoEcet0tEyEXKkxoJwQ5i9ZDhvBfamuAByEnX2T
 uIWhrsBnE65GsSRmMuQNZFfn3/4a+cEba31Lf8Fxpqc4a1Jz5y8XDE/QRYD/nJtpgUpNtk7YqSJ
 CI/uq8Ssj2NFj8Dz+HbkLS17Y/Rv10yfgpd754oyf0iafvr/gd/kLFIscbcjbY1HNwO48OfO369
 kvLCJzvXVXOq2wQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2FB662000E
X-Stat-Signature: 3ztsfpqu9yzio7bw3yji8wbdk1wxx7th
X-Rspam-User: 
X-HE-Tag: 1774954843-444346
X-HE-Meta: U2FsdGVkX19XUDSKq+HJJvSfmuJsO0If/SHcms91fSlOEoOJ6UWO23h3cgb7EJYjQYGkJ0qoUtGyqyoJ9KFGgzm+JKUjjBorMOBxELMlk+uFavhRQ44FLX5MlWmmeaLIyyRjAkPFtR+FmqrOI3EJ4b1lWzMwF0HRN26vHq5tWEkYTcg73vdu1Dq7/x8qw20fylW2iAeTaH7by8KBsZ4tGAFWGzuYXqll/2y68t3kke24RrYZMrcB6MpP+efhwtfJTk8JDY5jm5X0493nagbQ6TuyJ0CGuNosJrnZYP9C3lx6v1Zl/fApE3OuXAPhyqDw/u+SgjMvOQD73WtNrHV6Xs4G9s3rgN5P6FKsbcszW3kOFlkdv1HBhkff7otxTkgsjqOwlum215uQdrJlsbfdxnK9ELLX1nNWtpZKeWeuX9E7utV6pc88C5QgTl22cnowS6g0ExvzYGZp1x6/CcTghQUeK9k6aBSLriUq5MQTRa6N3DR4n7gwejQIWvGZMTh0KnkfAu69M3Zk9kBVrto3ZsI2oIK4JcyVvZ28s2sUHd+krQteULfQXrGNtgluXiVkagX6JQAyuemk6kfyh2k1OEbVVn2Pprvdd51v6xK0iR81IoD51QICjo0dGh8DhZ2Z3DnEiZ7yHtsaQowiEmM2/YAB5aIJUAF5PyQktNNOLAhYQGPKmmvL2Lhyr01T8+gJjctEHXy+yyA6BWoDt7tLy2gZ+VCcNRfruetXPJSzuy093Gt/uyEL2s6i9hTrI5p0zWp/Bk56mmLWpqETbmBdOzi6FlsUheakP0KnS01EaW9Y6O7n5pubeZXKl3IDqipq9sTOw237RfFQ6Nz7hOwu7nAXIzQSn5T4asiMi9h9Qo4XaLafzlMe9T3ALnRt42r3c4Q/GaaSvpgpkzOG41xeGNHoJRS37t/WupK9XkeicEM3NZp+x0bjBF3jefYaOFVEzo1lKrgBKTkpDiaYZBU
 4LLhq6XZ
 rbCYCXdnjDEqzsj6am8TStSKXrTgKnmBTPENDYT8jrS/pkXGK60mSpjsS6OX/CJ4sRX8xsDoN6hgPhM73v80R6Mc1ZETpy3bE93Zq64IUh9s6tRTfo4yTx5T2MTOkXdmIF0tIcvLvY+YniOlSwXrEczne9x0ZaOc7f69e/AcddhCpv2/moZuebg69Aver2Llh+nCmlULEhSEu2hmFFR2CiNTvqaw2T/hAzwf+Mgzdt6cJlzX85GZgTMdWDrpxN48YuKnpePI4s8w/7gs0SMDUytBJGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document the new vm.panic_on_unrecoverable_memory_failure sysctl in the
admin guide, following the same format as panic_on_unrecovered_nmi.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 Documentation/admin-guide/sysctl/vm.rst | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 97e12359775c..a811f503bca6 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -67,6 +67,7 @@ Currently, these files are in /proc/sys/vm:
 - page-cluster
 - page_lock_unfairness
 - panic_on_oom
+- panic_on_unrecoverable_memory_failure
 - percpu_pagelist_high_fraction
 - stat_interval
 - stat_refresh
@@ -925,6 +926,32 @@ panic_on_oom=2+kdump gives you very strong tool to investigate
 why oom happens. You can get snapshot.
 
 
+panic_on_unrecoverable_memory_failure
+======================================
+
+When a hardware memory error (e.g. multi-bit ECC) hits an in-use kernel
+page that cannot be recovered by the memory failure handler, the default
+behaviour is to ignore the error and continue operation.  This is
+dangerous because the corrupted data remains accessible to the kernel,
+risking silent data corruption or a delayed crash when the poisoned
+memory is next accessed.
+
+Pages that reach this path include slab objects (dentry cache, inode
+cache, etc.), page tables, kernel stacks, and other kernel allocations
+that lack the reverse mapping needed to isolate all references.
+
+For many environments it is preferable to panic immediately with a clean
+crash dump that captures the original error context, rather than to
+continue and face a random crash later whose cause is difficult to
+diagnose.
+
+= =====================================================================
+0 Try to continue operation (default).
+1 Panic immediately.  If the ``panic`` sysctl is also non-zero then the
+  machine will be rebooted.
+= =====================================================================
+
+
 percpu_pagelist_high_fraction
 =============================
 

-- 
2.52.0


