Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFDE8C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 10:32:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EEB16B00DE; Mon,  6 Jul 2026 06:32:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79EF86B00E2; Mon,  6 Jul 2026 06:32:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 690C16B00E5; Mon,  6 Jul 2026 06:32:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D7666B00DE
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:32:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 79C4A1203AD
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:32:26 +0000 (UTC)
X-FDA: 84957987492.30.671A7F9
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf31.hostedemail.com (Postfix) with ESMTP id 76BD62000A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:32:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	spf=pass (imf31.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783333943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xk5wxqTuf74JthGrzb89MV+AWMZD8baKOQ5zRdHdzoQ=;
	b=AIDrcMYTVavMA9O2dAJXf12OxWE3iKaeRgBb1BoevBN1S620GKM81SgM7fChSqKhK+5qTw
	FuKxU/a7SlTZSIeD2tps9HRnlcDHds7UmT96Cfzej3i1V7uFyIoiSIE8EttQMMi/IrzhH9
	tfYJqPdrWKgM6Q2ZEi+eKoYcPGm9K3s=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783333943;
	b=bxRRL7RonKUtJmT6njXfEyMfjlBLhYgj7Epo9iz9UJUtU+bpNkBndPCtfbx9k3g/6UyjYR
	vUIWF1LLyTuq9QL5XZ7S11KKwkx+mzhfYaP3X+W7EpeWCFgstQDvAOc4SF7gvSIqlqRYvH
	KmRUjVruYO18G4oZ/F02RSsz3oNEVWg=
X-UUID: f559448a792511f1aa26b74ffac11d73-20260706
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
X-CID-O-INFO: VERSION:1.3.12,REQID:3b99b28f-9c22-4c81-99c5-564192bb4652,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:20
X-CID-INFO: VERSION:1.3.12,REQID:3b99b28f-9c22-4c81-99c5-564192bb4652,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:20
X-CID-META: VersionHash:e7bac3a,CLOUDID:a5810aaf9e41aedb88353a90b9405af6,BulkI
	D:260706172852M3XCK1II,BulkQuantity:1,Recheck:0,SF:10|64|66|78|80|81|82|83
	|102|127|841|850|865|898,TC:nil,Content:-10|0|15|50,EDM:-3,IP:-2,URL:0,Fil
	e:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DK
	R:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f559448a792511f1aa26b74ffac11d73-20260706
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1786583648; Mon, 06 Jul 2026 18:32:16 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
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
Subject: Re: [PATCH v9 1/5] selftests/mm: move pkey selftest helpers to pkey_util.c
Date: Mon,  6 Jul 2026 18:31:43 +0800
Message-Id: <20260706103143.3638104-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <436863f8-5840-4c3f-82ec-c55b46fb9969@kernel.org>
References: <436863f8-5840-4c3f-82ec-c55b46fb9969@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 76BD62000A
X-Stat-Signature: d5ojabrfc4yabu6sem9wd5hpx8dbbiuc
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783333942-801378
X-HE-Meta: U2FsdGVkX1+92A89Dc43833IwWH44Kshz1MM75cmvyVOZMUKsd20tCofsfQKS5+cU3Pgtp6XbTGtiuTe6CwrUwgyjSCzwStxfEJ/obnpKtMEMsNoXoBU8vqTSgsHvecTQe/LgaeONqZKOUcryuYJIx33UMNMpORzi3L6i0IQgy7jOw/pXaw/uEMgBwrcGheBpHBjfM5QZxCfNrfKwpkiTJSPgB+HNpSvTcBuqDzZ9522Hj2s86/K2UiMLljz3K/yjnO7VvYzFkS99P3affCkqX/xSKtZyp7NbVP5DxEObpyjNVYR5gAfWfsdrHL4TT8xIM57b1GZUbr80S/V9iF38x3CjPa/A+8hu/Ad1NM2K8ZC5C2VG0jEEtkHcIDKF3uAnfQy4IktC++xT8QX6Qj2hHaMwBX9oVIfLupSyI1LkRaGdajQ1ICgxbv7mQU+rVyGHJzGC2FhBmLQWCzPLg5C+bBHzp5ykPMJ4t5YgFqkCL8CXw3WVboZDVKYeXBGRdKvvq4roHowyN3eNZiF7w6yysxIjJCClDVZkFhoW3DEcdcr3kQREJdWz7RwAL5FbGhVg5rR5+85tm/KhN3jcN4LY9oGgi9rCtmsa258GYaKy3ShRXgQgXqAqFtRx2ekat7Mw0aReRdsEzrUWuNIWpC/UWNrN8dkEMkIAGgdAXvygdKCOp9sj2hGFSebjT2o00gmR82GqH5bEgg5KrL6ielsW+UzNBvspU/FEH7vhDYaTvLp5nu52jV0yA6WG3lhR8u5CKDaXGh1tKyjMChhJh898gkhD/mrT0nZDHFeRHVJ+WEk4w65T3CFhkMBn/NWKBVdbQA83IURRP4IF0dKkv7A9aAo7xawiAfKnH1PgJpOsocw03aYthVmZD+KkkTxsSHkrVC3S9MIKYa0FwPMIwZ6Nx1kRSfni5czjV/+uSJP66r6qK4VZx1G9jOGWz7WhzTepnOsvc6Xfrc1Lu0tUS+
 WCzK4Gfr
 cAHtwT5BcAlisM6+fNJWC3tQcLpffKaVuIP3U+lX3zqsFmTGesgGmez5cxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

> > diff --git a/tools/testing/selftests/mm/pkey_util.c b/tools/testing/selftests/mm/pkey_util.c
> > index 255b332f7a08..fbef3cd45447 100644
> > --- a/tools/testing/selftests/mm/pkey_util.c
> > +++ b/tools/testing/selftests/mm/pkey_util.c
> > @@ -2,9 +2,99 @@
> >  #define __SANE_USERSPACE_TYPES__
> >  #include <sys/syscall.h>
> >  #include <unistd.h>
> > +#include <fcntl.h>
> > +#include <stdio.h>
> > +#include <string.h>
> >  
> >  #include "pkey-helpers.h"
> >  
> > +int iteration_nr = 1;
> > +int test_nr;
> > +int dprint_in_signal;
> > +
> > +#if CONTROL_TRACING > 0
> 
> Who sets that CONTROL_TRACING? And if it's nobody, why are we dragging this along?

Thanks a lot for your comment.

CONTROL_TRACING is disabled by default. It can be enabled at build time
with -DCONTROL_TRACING=1 to capture extra debug info via ftrace for pkey
failure debugging. This patch just moves the tracing and abort-hook code
to the shared pkey_util.c, fully retaining the original opt-in debug logic.
This is based on my understanding of the existing code design, are
there any corner cases I overlooked?

Best regards,
Hongfu

