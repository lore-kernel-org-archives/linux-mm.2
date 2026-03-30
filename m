Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B5FC1061B29
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 23:43:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDE6E6B0092; Mon, 30 Mar 2026 19:43:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB5F86B0095; Mon, 30 Mar 2026 19:43:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF3816B0096; Mon, 30 Mar 2026 19:43:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AD3426B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:43:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6367FC2BC6
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 23:43:42 +0000 (UTC)
X-FDA: 84604359084.03.FF07F65
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 02358140002
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 23:43:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V32nZ1nX;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774914221; a=rsa-sha256;
	cv=none;
	b=t7jBSGLnej1qamTF6ao51+csadrL6jcRxZvUi7ZC1nZb8E3hr8Df3rtc8OjwmBDK/mgURE
	nBvpmxEPK8lR25dOlzDyO+THjEnEbJu9LkPGECAXzz3H3jUGnikwN+1tDXullIdtEu3pCE
	Ja9BhWgpVJUfEXA1fHypjsakd7yneEE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774914221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kyfzloiKg94cMBZTS4zvCrW6r/jVIhEPdzMmjVIpyP8=;
	b=waRBENtE8qt/kxeqOuy02y8YE0PpuI/q2+4UDkb98iQu0NJvEtjidD2UhOCYd8kTc1AmUd
	FnhkbvhVDuWp+vllRFee+/q6/wWvrDKDCJgrjb2bca6+myHBU53dKAJA1XS4JelI80eTOt
	MYG19sjcJj2TPP03GoKNNZHHZKy5db8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V32nZ1nX;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 64B856001A;
	Mon, 30 Mar 2026 23:43:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E38DC4CEF7;
	Mon, 30 Mar 2026 23:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774914220;
	bh=BkHehICuOkyvWnfYUgcSXkuf4Vg4IEC4jTYJCRzvy0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V32nZ1nX6h4IaF7f3ZViBed93BgbvpTgBNJvuAs+n3L7ZREOKatCKze34ek3ihNwV
	 UMn7VIT7lgZJ9dyl3PYn05JdY4q0jGkJQ+5/uslu0u9GzdibSkeQA9zqQd5IIKr9Y2
	 RDnUdS4R1a64dnRWzkSF0OfOaSbHvMztPmG0uVjAPc0+46j7+EREcxL1dACdczCq+v
	 ymZSvakC8FjfNpU/WOt7N8uLQ8Qc1NEshs9hjLjQCam+/6o/6wC/P3C898GTg54gAK
	 Q+Q/XPxmdhjP2fnNYzRN0EY0UCKFZc5C26+tOaiAOdU7sdD3hRy9N72f02B5omcjVg
	 Nk2xBRQigJ3ZA==
From: SeongJae Park <sj@kernel.org>
To: gutierrez.asier@huawei-partners.com
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: (sashiko review) [PATCH v1 1/1] mm/damon: support MADV_COLLAPSE via DAMOS_COLLAPSE scheme action
Date: Mon, 30 Mar 2026 16:43:37 -0700
Message-ID: <20260330234337.4456-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330145758.2115502-1-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 02358140002
X-Stat-Signature: t1u3gsw3nerz9z9m3gmstsgncrqfpy7t
X-HE-Tag: 1774914220-113994
X-HE-Meta: U2FsdGVkX181F255cRQMahrt5Rghk+j4WECwwYGyuZXCPSg612qr77uXD3ZoC4xl8YbqdieqNjYAvjz7wFIF4gOGh039MB+Pyzy9p44Mq826MyEJOj5y6ftP5IxEUiMmEY9UEvp6VfdFE6VOpjiBDzYCVYGuFJIJ+qSmxAxzy6lcTABRa7ra/RHGcnKyzsNAKLKAPuBjinDvbEqs3UV85bWOjBM6yo0WNvlBZ0kwkLDQgbARIIcJteHv12/7esdKEREfIhcH66XN+t9R4+yXcLBkJGlxW6/9kOQiRLLiU+RHWC8tORukyprFmLo1DP6Flqj4Nd53e5xGV6W6ws6OAYUUcyQlwvoiAauulc43CAh+JkiOdA34Kuyep5riXCPlkkujl7iJNkp1fj32b9Hx+D9srwBoXeKgSJHpRGjijlXtXS3PqPwr/ME8VNHlf62Q03tYKhVkF/+/VwsJr/P01Aw1hEKsqB6Txt/xxLPDOpc62MNLQCT3zfT+RMeoE+Is20AZuGoNOo2quGRDFVwYmvlGKiHnb8KPZUzLCkt9mVXyiJlhBkNZxFqJUnFB+p7cXcVUwJFzqEBukIpijdvc3Jnnc0VmMtennCX9qMcH7o30kU5jYDRJPgZs+4zpvmgkBbGWAMAUZP+96B9HmllS8JYnoYppjHGW+GNlIrIN+78vuMyn/ZhlzySo+7laVmLhKA5THPiceoVsEgQKDiF3BJvMy8FofRda/NcVD/235TYbG7RAAsS66jxhHstHCc+ag/up84ycaBhIKJd2PmPqT+CjWNTOG3xfd+i3Occxd6L3AxzUCCkidAP2caVV5X43zobA0jextH5vSSmLtd8ejIz9QVoC9AbEEYlXj8vBdHEf3tP1iFUFFqT5SHYge/Cp55/DX4Yn/1jaD8UdU+BJO2soBvuFHhREozs7i3T78dLsmhr4BT9fyOJHbDCy+k3PKkJCVBPfE89TIhUHURq
 oYLt6zkG
 MF3JS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260330145758.2115502-1-gutierrez.asier@huawei-partners.com
# start of sashiko.dev inline review
commit cd78854e55ee90102333f0331c58417c16e8d798
Author: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

mm/damon: support MADV_COLLAPSE via DAMOS_COLLAPSE scheme action

This commit introduces the DAMOS_COLLAPSE action to DAMON. It allows DAMON
to synchronously collapse memory regions into huge pages by leveraging the
existing MADV_COLLAPSE mechanism.

Link: https://lore.kernel.org/damon/20260313000816.79933-1-sj@kernel.org/

[ ... ]

> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index b069dbc7e3d2..dd5f2d7027ac 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -903,6 +903,9 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
>  	case DAMOS_NOHUGEPAGE:
>  		madv_action = MADV_NOHUGEPAGE;
>  		break;
> +	case DAMOS_COLLAPSE:
> +		madv_action = MADV_COLLAPSE;

Could exposing MADV_COLLAPSE to automated continuous execution via DAMOS
trigger a pre-existing use-after-free in the core madvise logic?

In madvise_collapse(), the lock_dropped boolean tracks whether the lock is
currently dropped and tells madvise_walk_vmas() if the lock was ever dropped.

If collapse_single_pmd() drops the mmap lock, *lock_dropped is set to true.
On the next loop iteration, madvise_collapse() re-acquires the lock,
validates the VMA, and resets *lock_dropped = false to avoid double-locking.
If a subsequent iteration does not drop the lock, the function returns to
madvise_walk_vmas() with lock_dropped set to false.

Because madvise_walk_vmas() sees false, it assumes the lock was continuously
held and the original VMA pointer is still safe. However, another thread
could have freed the original VMA while the lock was temporarily dropped,
leading to a use-after-free when madvise_walk_vmas() dereferences
vma->vm_end.

While this flaw pre-dates this patch, does introducing DAMOS_COLLAPSE expose
it to continuous background execution by kdamond, making the race condition
much more likely to occur in practice?

> +		break;
>  	case DAMOS_MIGRATE_HOT:
>  	case DAMOS_MIGRATE_COLD:


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260330145758.2115502-1-gutierrez.asier@huawei-partners.com
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260330145758.2115502-1-gutierrez.asier@huawei-partners.com
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

