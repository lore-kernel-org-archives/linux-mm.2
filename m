Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66A12FF60FF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 11:00:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 877DF6B0096; Tue, 31 Mar 2026 07:00:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73DB16B0098; Tue, 31 Mar 2026 07:00:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 652A26B0099; Tue, 31 Mar 2026 07:00:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F1476B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:00:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0506E8CFBA
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:00:41 +0000 (UTC)
X-FDA: 84606065124.22.F9AE1D6
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf10.hostedemail.com (Postfix) with ESMTP id D765DC001B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:00:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=qoNGz+Kk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774954840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rVyhTawyidgAJFXlFpU1kNzGw6yToxZt3Y3vvzuWrVQ=;
	b=6t7Cs7vP7DjGSZzCv+xiRf0oXOtqsiRX8jD4C3buccmS5qlIZNcLODWo/8B3wgoBB4dgoc
	Jmu1Bieu0U1qCCvkp6AdoWgJhbqhoBTtEjF7RaMqFzE9L5jcRRCJJhPUlMno3Zzpk+o1Yz
	NNxijvZurVZb91F9wIwjZaKLHBOdBi8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774954840; a=rsa-sha256;
	cv=none;
	b=y1FCwR3rcZyblzsvnhsOn7xee0kxqSHLWS5Lxs/g+kwoTiir9OjmsR81Dbt8etNedjNfgC
	wOwbzspRtboD7W7rLpH44mmr1NyqdjcnLO1Na0AzR6XQRm2H9Axt7Unqpd3wqIrQ1IZCE4
	08bLKr/ycfN5qXfZZbn+wZPYajHSAJ0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=qoNGz+Kk;
	spf=none (imf10.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=rVyhTawyidgAJFXlFpU1kNzGw6yToxZt3Y3vvzuWrVQ=; b=qoNGz+KkXkQW3BqbH2rQVP+plM
	Lpy5EaphkrsicKHvP+14QwCjtVBz1wPZunwR2OX+0/rP2uk8iOcampfze+kP4Mb+/aUGPAnSjoksO
	MzUDlxkSo9HIie7ra43H8/uYRDQvaR0VtclN+d2KAqiTCPrXEYURGg6ez+pPKtrnEka9o5J6OphI5
	Iy3vEZhaph0BjibtZ56hp4XQcLcbOy35KCFr2l4BJ69fbXC3y7KI0HHYlQWjzJ8SptDDf1bFi9yfQ
	43kCbKQM8ZaIFcqIfiwEqDbFcsBhkVUXou4AL+SjFPopnT9fomZAGgo4pJ2AFklTIpvdQ6LZ//e77
	WRk7DrlQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w7Wpp-002Aat-1L;
	Tue, 31 Mar 2026 11:00:36 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 31 Mar 2026 04:00:17 -0700
Subject: [PATCH v2 2/3] mm/memory-failure: add
 panic_on_unrecoverable_memory_failure sysctl
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260331-ecc_panic-v2-2-9e40d0f64f7a@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1836; i=leitao@debian.org;
 h=from:subject:message-id; bh=yzGP/Cy1yyj6AMionGm0ecG3Z37VsQOIJST1oCRcuAA=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpy6lIqDJQvSdPLFq2MknuEvV7NkwbvksSPwQSQ
 7SDWBXqpaeJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCacupSAAKCRA1o5Of/Hh3
 bWzVD/wMEOFVeqAHE2Bo40HWmg1QMcTSipGvQHqL38jYHHqnOqXtg5Hj7d3c+YppJwEfs0QjFTA
 EcOibEYB573vJ1emMullT6EaX+vids8do9+A4DuxmM/Tvv6ijRy5LYi35aKp1E8u3Dp3aOQuvoW
 kJKb12RaZLu3QzrmfvyXWGQSFP+yyjqxpW56GzyAga0q/iWDywpxA8yxCUzfUT7ObsYejpLmdVl
 Zw7muxBxdc4ig0qzVFu8p4mPOfsjCrqoJrlK57xk84RVll65KvBMJvDR5ndDHQTrwfOarJpzGbx
 rQPN3ZJ3GS2nSsv66y/w8Gz+pGEPh8Inv9lvMwhcaLfWXSEUwCQ/4DGwUysY/3LRtMCenFpMiU0
 hTY1DleA0RfkpEfaGyy7Fi1ILFm8Uwk8zMZ1KIAbvEzVA8Ba2QJQjxaTbQn17AC4Y90cZHidbPv
 3i7I+kAGBQSP6hXw3gFEEMIvkWfWoKZZZY/47jWOKZuTH9qfu2Tr7iBNeIrlg33KH+hJ5owL6cl
 u/VjzANF38CSAb2yQdUlyRDJnYgcyQkmaXWO8Yb1uH6K6b7z4b0qebJ6DHqNV83wCMJWxwq5Pyv
 IijdlEzmEFbyPDxpsR5cOdIiLRELA/8gfu2HSHramLNlpPqUt4hshRqaSdwJNw0IfaaAD0c4vtH
 Z3/+zy2gRZBkGkw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam12
X-Stat-Signature: hjbx9dge3zs9zyze6nfy6t6erydfdxhc
X-Rspamd-Queue-Id: D765DC001B
X-Rspam-User: 
X-HE-Tag: 1774954839-720389
X-HE-Meta: U2FsdGVkX1+4WmNDpSq6DGVUklu2gVTaLFAjxTTrzaEbYauGD/xjsGHfwsb62RG89+7HYZvwQig5RsdEDPRbTh+Cbbxmg/YPQbAlj9bwF4Kz1ght1CTEu3j7b3IuLmvqzBycpKMeFB4b73wqpJd3sW/dbq4+/J5njNoDE33U5VBEzicnGbJYO2krPqBcjEBDpiAwXTZwYKkpasHQr8zHG6IFnddt3EqkhJjruhf2b4yFWEZrMF3leZJ6FM9jCN01xdhGoNujsWMLhIMzPq7jRdKt+xCv3BSj2i99lMff0V3Br1Vuad1ZrAJ4S7UKC3Se16fitIeHtX4MJZbsEkdIbxgAUVLu8inUTCH+doQC6mY/2Rvki3STiUZeyzfao2HnNRgzIVpDf8C27kLk4ET5oC2+9rjYJ6sC3yFNdSVFR2LjlrNvlzS57IUl/Su9pBPJ9IGxHSpjj2LThaG2yJU/WuXlP1FeXKcvdl+MPEv1ySvLyXA/7ALx0vaPuAPlFUK/U9VHPb6Aw8J9jJiKxC/5jRNBX8l0VyiLXok2yOkUK6eVBLfCJ68SDc1nlwnyBgEJhFN1dm6AZI9PwL80qVA18oHghbMcTcD5FlV7sFwZOIzA9P80j2MhO3L570tFFoXYehUkoHeljPe2gUW+mxqHSfgFYkF34WsTvCfEgS/1h5CYyYK2+3sFr8Takni6vxBPJgRbAdM2ppxXa+IsCv/mnFmmctiMMOSCF4WKecQGaWbllL03bdRZmYfPVcUE4Nik76milkQ4JfeNRTWGiy3+NPpe4S5je5F9ysaz8NUxd8MeAOt5i0AvQX9daYOQ7yQrhxxDlU+Pd5cOPLe+cS0iKubI3xZ2d2wvdTi5H5oOiJ9YkWBsscX8xg6E7fBfvstYdByrLrHN9RqD0X6eC9m9yWsRgEQau7i5yaEMCNgwWtKqjxYBly//1pS3vvvZgyzE7/XPbsesdzAJzdCiSo7
 xyhYd434
 EkUJXnpiQOxeONoJZ+Y1bE1cS9M1hYrs+8Ex25z6yZssdRLIfy8m0iLUycYp1DPO88lhsK5z2xhAq1GximP9p1v2BROCMl+sG3JlWdZcH/6XxK7HPGx6binoIUuWyQnmCSIul6fqxu8uQSPzU1qJX9NlXwcWEBE/SP67z/oe9mZ544tCCvOC4Va2y61IV5CHVbVCTeqQa0RKN29EXkK+nES9Rdr8agsJVCGgszrD1CvTtsuR8bNbD0otiqzBqCUpnNGboY6f8PfD2KadkeqAHycT4Hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a sysctl that allows the system to panic when an unrecoverable
memory failure is detected. This covers kernel pages, high-order
kernel pages, and unknown page types that cannot be recovered.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/memory-failure.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 6ff80e01b91a..d0d911c54ff1 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -74,6 +74,8 @@ static int sysctl_memory_failure_recovery __read_mostly = 1;
 
 static int sysctl_enable_soft_offline __read_mostly = 1;
 
+static int sysctl_panic_on_unrecoverable_mf __read_mostly;
+
 atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
 static bool hw_memory_failure __read_mostly = false;
@@ -155,6 +157,15 @@ static const struct ctl_table memory_failure_table[] = {
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
+	},
+	{
+		.procname	= "panic_on_unrecoverable_memory_failure",
+		.data		= &sysctl_panic_on_unrecoverable_mf,
+		.maxlen		= sizeof(sysctl_panic_on_unrecoverable_mf),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
 	}
 };
 
@@ -1298,6 +1309,11 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
 	pr_err("%#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);
 
+	if (sysctl_panic_on_unrecoverable_mf && result == MF_IGNORED &&
+	    (type == MF_MSG_KERNEL || type == MF_MSG_KERNEL_HIGH_ORDER ||
+	     type == MF_MSG_UNKNOWN))
+		panic("Memory failure: %#lx: unrecoverable page", pfn);
+
 	return (result == MF_RECOVERED || result == MF_DELAYED) ? 0 : -EBUSY;
 }
 

-- 
2.52.0


