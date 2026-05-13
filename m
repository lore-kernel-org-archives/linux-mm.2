Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2A71CD4F35
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 11:19:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F1266B0005; Wed, 13 May 2026 07:19:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C8AF6B008C; Wed, 13 May 2026 07:19:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DE666B0093; Wed, 13 May 2026 07:19:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1BCD36B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:19:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB2468D718
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:19:40 +0000 (UTC)
X-FDA: 84762151320.08.79AB1C0
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf24.hostedemail.com (Postfix) with ESMTP id 091C9180004
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:19:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	spf=pass (imf24.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778671178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xhsKwyaffAlNXAld/bOX6rTbS/z4wWI/Xsba3XgRays=;
	b=6u2YhFt3awGpTh3WOb/ny+KUJPJsOMg80yonVQRZfUN11rgL4zvFlnMN93Py47zo7b/ROp
	oF1ywVFiqhGo8WCME77rIQIVPsVDKbI20mGzciO5d0C7YoDwKVsS9mkjJv6SYfbao9iB9u
	ylb0ccWtsxzHeaUPPuGDunCbg4app/c=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778671178; a=rsa-sha256;
	cv=none;
	b=4gJhFxCR8LxuOz9KCYTZcI2o3uBfoy6Isi87KiHYQq/h34Ld+VzUPOzEUgItzM/UmNXk1D
	15dD34QPgDQNoDo7M0JRwt6+DQQiQNv6G61XxrKBIBtz41iPFhdZDR8R4Jan6nkfQQdtQO
	5iMRJU32gR/APU+D16HSkrwF20OQtoY=
X-UUID: 999f8e7a4ebd11f1aa26b74ffac11d73-20260513
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:1a7550de-465c-4d02-9b00-f384ec28b4e9,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:1a7550de-465c-4d02-9b00-f384ec28b4e9,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:10036077922ecd3bcab7faee5bb3e2cd,BulkI
	D:260513180600PLGD15QJ,BulkQuantity:6,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|817|841|850|898,TC:nil,Content:-10|-8|-5|14|50,EDM:-3,IP:-2,UR
	L:0,File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SP
	R:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 999f8e7a4ebd11f1aa26b74ffac11d73-20260513
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1006308994; Wed, 13 May 2026 19:19:25 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	dev.jain@arm.com,
	liam@infradead.org,
	lihongfu@kylinos.cn,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org
Subject: Re: [PATCH v2] selftests/mm: Fix incorrect mmap() error handling with NULL instead of MAP_FAILED
Date: Wed, 13 May 2026 19:20:00 +0800
Message-Id: <20260513112000.825625-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <agRX7BXxuv-VWqN4@lucifer>
References: <agRX7BXxuv-VWqN4@lucifer>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7ipbo8bbuww5ydwaccadkbzb6165aqx8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 091C9180004
X-Rspam-User: 
X-HE-Tag: 1778671177-22937
X-HE-Meta: U2FsdGVkX1+GeVnRveYALkHM52HXscvXCqhhLdkPKXba4fKNpKR0kWOmTQPCaIkazg05i8GUWNLBcV/9qngyB8nMpKlienuPf3NXGh114Hgh9OJzajZi0OzqUdnNUm/5qXS6tmWJLAS+uUedwNME2QE3al520iouTIcq21u5X5xNXBIc90vajUn+SfHGMq3m91BB7Pg5ca+jHBbsMLbpG/iA3usPFcR57wiMeEZABDXkZXRnKsdQt8o+oNuZy0/PqdcQYg5PG2wacGeM1a4FBaPWjYVTJ9j4nFh7zK4y+bQl0ymeb69992Pars8ZamULPysueA6rktGauPUglRabHQCdPqjqYSfbGADv1haDHWNzGTuKF7Didyd08yOeZI9NQpUZCT9oPgW2Go6U7yL/OwmmZIMYF0SSgNj14el8MqH/aMdlnn2cfQZZhh1b0ClPdhaB8jS+e4hZAFwpH4nJh+9urmyf6UMH0G6CsslvIYwVYSCtgzzA7mgtpCDqP5KaCSENXNmfjK0YOLTgHmFZEhJQQrvPwgKIMHpatWr+rAymlwj2LcepdXF2NwnwdqP1QNJASd+Q2wZ1+CVRc9y7DdMGdqdcLcY24ktasDC9MtzOi6UYDoXSjowts/w0MNlg7AycdWWQUa7Kzr3QxaP6qwqj6eqFSPb124NlHGG6gM6u9UE5x4552UNhrOD6YdhSedwhpE/11odLv4I/mtPmLjegwWXWm4kr8pwCs4M18/TNYxrveDpkZseIN73MicHoM91dv9vORmCq5KeR/3iw5SE5VdKsFIZb2ktS8eG5nqEfyx5jLbmTZmxyHYrb+9Pi7mi59BTO9IIfw05BLSNcxcL/6oFMTBUJ27AAs8pitdhgDc0uN5aGpMiHyWK6IIf2sJNMoQgN16fXMAwZIIRIbnSBM+qDnwCumAGYFGz8VAzHF37LFYxtFc23fB/2ZlLtymM3A/NkKOfP7asVJWZ
 5rSVkS24
 M14b0R13dbbzvoGgvRYN2tqOJ3oxB+clfTp6fqlBRGueUrD8FEM5ziyymnYDKtfHLAR+kFaX81JwryH/OREvs124kC/aDeiGbKa1kHZ8kzbUF5jSo0fG9+fQM+pPXscIJ5rTcnE0arcIespA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > mmap() returns MAP_FAILED, which is defined as (void *)-1, on error,
> > not NULL.  Several selftests incorrectly check the return value of
> > mmap() using !ptr or ptr == NULL, which would erroneously treat
> > MAP_FAILED as a valid pointer since MAP_FAILED is non-zero and
> > non-NULL.  This can lead to segfaults when mmap() actually fails
> > under memory pressure.
> >
> > Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> > Reviewed-by: Dev Jain <dev.jain@arm.com>
> 
> You forgot my tag :)
> 
> Also, please do not send a respin right away if you can, multiple revisions in
> one day can be tricky to deal with.
> 
> As per David's points - please update the commit message to reflect the fact
> you've added a missing assert too and replace the (void *)-1 with MAP_FAILED.

Thanks for the reminder. I will avoid sending a quick respin within the
same day, and I'll update the commit message to mention the added assert
check, and replace (void *)-1 with MAP_FAILED in the next version.

