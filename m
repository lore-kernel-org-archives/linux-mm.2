Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC98DC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 03:25:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA4B86B009D; Mon,  6 Jul 2026 23:25:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A55E46B009E; Mon,  6 Jul 2026 23:25:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91DE46B009F; Mon,  6 Jul 2026 23:25:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6B33F6B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 23:25:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D35BCC1890
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:25:37 +0000 (UTC)
X-FDA: 84960540714.14.86F8B2A
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3492680002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:25:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783394735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hmzj5urN+XHzKrUzmziWSFUmQWWgp4kQZ8TdMtvwnAs=;
	b=QOXRGYMx1dlQIQ4bPnjbMQVSwU8pp7z6SUSlXoxrL1cKmt5WFjfIcSdTQcIYBAC5SIyL91
	UtwHp0s4T8mQAyFUdejivhso+x/7h9ci7YCFCWIYFNuD05/3008VFG/5JL/Pp0FYi5iNlJ
	DwuIVmTU8LPCl32rSB3FnMApKk43eAo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783394735;
	b=aE9zl0TvWupmEcT3Ui2+kCNHzB1rW/oaZjBpuYb0HgEGWtfRILI6Bv0aVxpxaenCGtoCYl
	7UppMspTZIQZCDB6L+MAeOV2sG40Yxh41t6ZapKa53OMM0O+RNLKSqjAlmCX//viMjUPLM
	BCpyQT/PNEvRLil4VZ3BXoYwxgnvxlE=
X-UUID: 7edffda679b311f1aa26b74ffac11d73-20260707
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:de2c9d99-1ad0-48d0-a199-11bd1859cbc1,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:de2c9d99-1ad0-48d0-a199-11bd1859cbc1,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:8f47211fc9ae32c51164c1a04e61ee7a,BulkI
	D:260707072851LA5JZ863,BulkQuantity:1,Recheck:0,SF:10|64|66|78|80|81|82|83
	|102|127|136|841|850|865|898,TC:nil,Content:-10|0|15|50,EDM:-3,IP:-2,URL:0
	,File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:N
	O,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7edffda679b311f1aa26b74ffac11d73-20260707
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 647136457; Tue, 07 Jul 2026 11:25:25 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	hongfu.li@linux.dev,
	jhubbard@nvidia.com,
	joey.gouly@arm.com,
	keith.lucas@oracle.com,
	kevin.brodsky@arm.com,
	liam@infradead.org,
	lihongfu@kylinos.cn,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shuah@kernel.org,
	surenb@google.com,
	usama.anjum@collabora.com,
	vbabka@kernel.org,
	yury.khrustalev@arm.com,
	zwisler@google.com
Subject: Re: [PATCH v10 0/6] selftests/mm: refactor pkey helpers and fix mmap error handling
Date: Tue,  7 Jul 2026 11:25:06 +0800
Message-Id: <20260707032506.4155410-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260706162841.b34d9bc1ba1aaa4be4f6254e@linux-foundation.org>
References: <20260706162841.b34d9bc1ba1aaa4be4f6254e@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3492680002
X-Stat-Signature: ha485b4q4i4pn5ns4zcpdz3yrzjs1ayd
X-HE-Tag: 1783394733-828070
X-HE-Meta: U2FsdGVkX1+aZ+Bs3bzuAm+IPOTuYMZNK+wkO7PSh2zqX6u6ymnByC0K+rRSQrMDElTSP/4C/KxaaZBImaREQKVksFndKR+diJpte/ykz6+fV65ffwofhleaFj7+i9nq8jHWEk7KLKTeenrCsrveJdDwJb+ld52Pcw2KbPssIpigyutqrAcP8oaAHo4O6WcFqmj5Cs4JutYIJLi3OsvA8M7Bh5m5oOJcK7mnUCnFQfCTgSFujiwTRqZimDipJIWQLUHIHFmW0z9gpqaJ710VxR4ysOWh59XlXGd0PbppKvsFQBJxjStp15fJAbuGrNccg/gV5OlZIS/9zEhXZmGgA739OJchlw3IG13KpYiMN4JIao3tcGjtGJyNM+LQRhlIY3E0yuoawAD+jmQ4vtEkFjgddk37sw9NmqIWIIoyn/oe4ljZ3Stp8xCN+IlT7lf6l7jMzkAoE306sHXqID/BD2Z93BzCZ2AviAL4l/BWD1sa728SJPt9DrOk625LlHi+XfuGSJdNHH2lgpIMSYANQqwKYk53s0ZQ2xJ4Ni3vsx1RUdg2S+YvfdK1zsivL4/zDtHtIz1xai+nwKF7Wnhp3Kw3zYTm+iaIdmOuI0cf8VMajLa2+cypmZAq9zqYLOD8dV85EkpeYyazRGdzzW3MHW1OPpQhSRYbeZg4QL8H7zxXpMtpIKzB2oSDROWdeoFVlaAsUiPnTBlTXvkupMEtp8MgA2W6JWsITBkw/jsirIDhyzAFd9G2dmj4vJYyF7AJj/sSKUwotpFSrz4gvlS9p5FhQUKnd9ir2x3I5v4eDAzcbKj67Uf0rHC6XTlXmCKazaLcWzXYXfScB2JbhgEmqdh0ziafZ3YJBEEjPmlyIQ0mSmYmhdV0T8Mog3w8itYi7YQyDXO+rQ08ZCigU77UL6/2B3X8y+iLvECKo5/Ce+sT3sE5b7y+D0DOpjVtBZKivRKbzMonkX6c+GQAPkS
 8Y4FWtTf
 7HMyV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

> > The main changes in this series are to refactor shared tracing and assertion
> > helpers into a common file, unify both pkey selftests on pkey_assert() and
> > per-test tracing for consistent diagnostics, and add missing mmap() return
> > checks with MAP_FAILED used throughout for readability and consistency.
> 
> Thanks, I've updated mm.git to this version.
> 
> > v10:
> > - Add patch 6/6 to fix a pre-existing cleartid race: remove unused
> >   settid/cleartid clone flags and wait for the clone child to exit in
> >   the sigsegv test.
> 
> Below is how v10 altered mm.git.  As you mentioned, this is all from
> the addition of [patch 6/6].
> 
> btw, I thought the official way to wait for a child thread to exit is
> pthread_join()?  Why is that sched_yield() loop used?

Thanks a lot for your question.

As I understand it, the primary reason is pthread_create automatically
enables rseq on all threads, which corrupts the isolated pkey signal
handling kernel context this selftest is designed to exercise. We use
raw clone_raw explicitly to avoid rseq interference as noted in the
code comment.

Besides, pthread_join cannot work here. Since the thread is created via
raw clone instead of pthread_create, it is not tracked by libpthread at
all, so invoking pthread_join with its TID will return EINVAL.

Best regards,
Hongfu

