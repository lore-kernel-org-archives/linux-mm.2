Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9333C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 10:06:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3D1F6B0005; Mon, 29 Jun 2026 06:06:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EEAD6B0088; Mon, 29 Jun 2026 06:06:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7D46B008A; Mon, 29 Jun 2026 06:06:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5A6EF6B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:06:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C8B774063B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:06:35 +0000 (UTC)
X-FDA: 84932520750.30.B781392
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf11.hostedemail.com (Postfix) with ESMTP id 905C24000B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:06:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782727593;
	b=x9/nhS3qJLIuPRxW7Gj2ZpqAFew2Sw13kZCivFqAyCDBb8iuDJlUqH/AYaZYK74KDNXjft
	gAj1nz8Z+5V37wv6K63GcTVIeFIQiq6mlKBPiM9XHlnZsArPF71SxcY7cjsL8Sp1L6wb42
	sU6fXCibMzjQLSzOwgF63hEKhY2J7G0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782727593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ufpz38PZ89vEi6JfZ4d7JjNoyyhbY1Q4z8DW9fL/CXE=;
	b=de2SfNQEBImrtqpg2xQDlp1buOMujLIjokkd7AAvTN9te+2zd/usraIv89VLQNbbmNWH9y
	Q4qlKaF16mwQ4TZxZ8XKFMo0OictxS/moXTT1E6V6CCI1w508kERkBmAluRObTEP78UCx2
	DndD1xwAqzkzADJUx2UHkf5Hut8LfZA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
X-UUID: 2f2bceb473a211f1aa26b74ffac11d73-20260629
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_TXT
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:a4170e7c-60d6-477a-ab9a-3ae1869c716a,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:a4170e7c-60d6-477a-ab9a-3ae1869c716a,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:2a7575b6c648292453f8b8c6b6c0db8b,BulkI
	D:260625170616GCMKOUR7,BulkQuantity:1,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|136|841|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,
	File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO
	,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2f2bceb473a211f1aa26b74ffac11d73-20260629
X-User: duanchenghao@kylinos.cn
Received: from localhost [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1146902853; Mon, 29 Jun 2026 18:06:23 +0800
Date: Mon, 29 Jun 2026 18:06:21 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, pasha.tatashin@soleen.com,
	linux-kernel@vger.kernel.org, rppt@kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	jianghaoran@kylinos.cn
Subject: Re: [PATCH v1 1/2] eventfd: luo: luo support for preserving eventfd
Message-ID: <20260629100621.GA215869@chenghao-pc>
References: <20260625054946.73445-1-duanchenghao@kylinos.cn>
 <20260625054946.73445-2-duanchenghao@kylinos.cn>
 <2vxzfr2bkn0j.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2vxzfr2bkn0j.fsf@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 905C24000B
X-Stat-Signature: qud9g8egrkn4fxnzopm4i45c8qthaee3
X-HE-Tag: 1782727592-943123
X-HE-Meta: U2FsdGVkX1+e6AeK+j2Eyt2ToYVlGKz0arwLneJNSGdjzq1oi5euB+V2WWFwyyLqDuhn1ITpve76VygsWs0t4AmQrCojs+PWnuOw9LSk2cM446VPkddAciJ9TkHNVbKuq2PgF34B94ZkKc3US6gH2ikBVWejjoUuIk9HAEhYNOoR/xXGU7Jlfilf/J4orCLHWkcj7W38iov7dWLEKzwxZbjmw6RQ1lel35rdaBppNxiYzQtXKCwZSHQhXY58fOqc/uJL3GXUMRHLcXXVyh4JV9b3BCN1mwn4ePuhVq9j5Val5IALk+kHZWihLklwKcJImJHJXR+CQLoLvK02nYMd7kGzzknAxcXFOItAZ8Z5awUh+cVI0LQ76TlwjOuf0U5ZpLoej/rHtYZk+m1U1/TBQClxNzMb/OCFbQU33E6tLk0WVYJ5Dt6p59znAi4Os1ZDL++DBo0geTJNNEiUqfoolbVVmfjIYL1mdN1186ms3VcU5aCg6QDs1DG5XDNd+FR1uRFk4ewgT5ed3ad5vAhNzga2IOmcl1Lw0yVoWJ27UPOzQcaCVxGbGzLDfG1D2lzR0l49mvRxJBlPSccPSNMFLLDaCTq3k/s5mdRYwBaB5whEb+T6OFJxhKYrXpLjvqHTUPnT4rthV11+UbVEBTijPNRkkH0zXM1niA4JakLyDp0qAspqk78vHmVQzg9SfYiN2Ixy9mwU6XBmvMR98i8gkh4CAAtS5sNm189oHPjRLlX4SwLPq7PvWQDiUjKjwSjPpmSG8OdLiwUBtGGmT5NO2QQ8SLwWTHpI6UhwStADGpLO5Lt97wK46JxTRy83RLk0YdoALOgRxHRC/Vlzd0uNgPgClR0GVm20xyNVZQZtyjkGEiCPQgx2+ez9lcUS4NHR9jAjGFfFNUeje+rTlPjv/yp+07WM2ID7nnkKGPTjnzZK/a3nzxsLaE8Kh5DRQCCvzFGu+lrtzKdg4EJnS+p
 /b7yEfVr
 NMrrL4GIggPbxGRrdFjtq7T5AZgb/tGzxa7ujjrtNrSKJUvvV6pHI9YdQWFP4Czob3lGkg8cysw3tTf6NydnWbVCUgTp6oeoS64e57oM2smPvVPCu7jZFMzcckQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 11:06:04AM +0200, Pratyush Yadav wrote:
> On Thu, Jun 25 2026, Chenghao Duan wrote:
> 
> > This patch adds support for preserving eventfd file descriptors across
> > kexec live updates using the Live Update Orchestrator (LUO) framework.
> > Userspace applications using eventfd for event notification can now
> > maintain their state across kernel updates.
> >
> > Preserved State:
> > The following properties of the eventfd are preserved across kexec:
> > - Counter Value: The current 64-bit counter value, including any pending
> >   events that have been signaled but not yet consumed by readers.
> > - File Flags: The creation flags (EFD_SEMAPHORE, EFD_CLOEXEC, EFD_NONBLOCK)
> >   are preserved.
> >
> > Non-Preserved State:
> > - File Descriptor Number: The eventfd will be assigned a new fd number
> >   in the target process after restore.
> > - Wait Queue State: Any processes blocked on read() operations will be
> >   woken up and need to re-establish their blocking state.
> > - All other internal state is reset to default.
> >
> > Changes:
> > - fs/eventfd.c: Add eventfd_luo_get_state() to safely read eventfd state
> >   (count and flags), and eventfd_create() helper function.
> > - fs/eventfd_luo.c: New file implementing LUO file operations:
> >   preserve, freeze, unpreserve, retrieve, and finish callbacks.
> > - include/linux/eventfd.h: Export new functions.
> > - include/linux/kho/abi/eventfd.h: Define the ABI contract with
> >   eventfd_luo_ser structure for serialization.
> 
> Why do you need to preserve this? Why don't you create a fresh one after
> kexec? You just preserve the counter, which looks pretty much useless.
> You can just as well open a new eventfd after kexec and set the counter
> value if you care about it.

Thank you very much for your review and suggestions.

My original plan was to integrate KVM with eventfd. Eventfd serves as a
critical notification mechanism between guest and host, and it is widely
adopted in various scenarios such as networking, file systems, and
interrupt handling.

At present, however, I have only implemented the preserve and retrieve
logic for eventfd, and the integration with KVM has not yet been
completed.

I have a question and would greatly appreciate your help with it.
I have been closely following upstream developments for the liveupdate
feature. As I understand it, liveupdate is primarily targeted at cloud
virtual machine scenarios. The upstream community has completed the
core framework for liveupdate and memfd, and ongoing discussions are
focused on state preservation and restoration for VFIO and IOMMU.

I would like to clarify the following points regarding upstream’s
overall roadmap for the liveupdate feature:
1. What is the complete upstream plan for liveupdate?
2. What will the final deliverables look like once fully implemented?
3. Will any new kernel internal interfaces or dedicated userspace tools
be introduced?
4.  Does the upstream community maintain an official TODO list tracking
outstanding work items for liveupdate?

> 
> [...]
> 
> -- 
> Regards,
> Pratyush Yadav

