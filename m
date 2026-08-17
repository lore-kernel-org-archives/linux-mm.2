Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84BA4C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 02:52:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58E736B0385; Sun, 16 Aug 2026 22:52:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53E656B0386; Sun, 16 Aug 2026 22:52:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 454E96B0389; Sun, 16 Aug 2026 22:52:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1EE256B0385
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:52:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7D84C40672
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 02:52:00 +0000 (UTC)
X-FDA: 85109236800.17.5EE8FA0
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6AA7C20003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 02:51:57 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	spf=pass (imf31.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786935118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DG7jvyN4yQ09VtnD0SMCMFuTSpCJepXj1RyMlY9C2vA=;
	b=Sf5B/CcbB8kd7CjNeXvTFqPJQ8PVSLq/kIwnfxfN7MwZh629gQ/ZwyXF4bbxuaDGUzneI0
	aetzD0WZJDXIQR+CmttZjdi15oRhtzmD+iG1H6UDRgvBFZHc5YBShg1K42kZPJC9ETM3A9
	bno12zLEVsIkQheLfTE8j+8PsoWgRxM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786935118;
	b=qE+gAda8tNRIjw6qrJL6UkN8lvmGYgP370Sg1aA20xHwOr9PwhGppcnw6peouSLAOcj6PS
	kIHZ1n9Xn4yQX67tnHliJ1RO1fv6DKLH1i+gl9rE51E/UazWBeqS0GYZjhfvZkKqKF8ZHq
	WMvbSWdJDa3qwSDTAsyIpwoaCLEAPMk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn;
	dmarc=none
X-UUID: 9745b16299e611f19a56ed5b684f684d-20260817
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:8a4b23c4-8c59-4b38-9c88-39599c3a48bf,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:373428cd7313b842758528a80ea0ef58,BulkI
	D:nil,BulkQuantity:0,SF:80|81|82|83|102|136|850|865|898,TC:nil,Content:0|1
	5|50,EDM:-3|-100,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:
	0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9745b16299e611f19a56ed5b684f684d-20260817
X-User: duanchenghao@kylinos.cn
Received: from localhost [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 159149812; Mon, 17 Aug 2026 10:51:48 +0800
Date: Mon, 17 Aug 2026 10:51:46 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: pasha.tatashin@soleen.com, rppt@kernel.org, graf@amazon.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kexec@lists.infradead.org, jianghaoran@kylinos.cn
Subject: Re: [PATCH] liveupdate: use scoped_guard for mutex in session
 operations
Message-ID: <20260817025146.GA133735@chenghao-pc>
References: <20260814095506.631274-1-duanchenghao@kylinos.cn>
 <2vxzzeyo23ol.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2vxzzeyo23ol.fsf@kernel.org>
X-Rspam-User: 
X-Stat-Signature: epniypjfwndyxih487fp5k3bs9939esy
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6AA7C20003
X-HE-Tag: 1786935117-680939
X-HE-Meta: U2FsdGVkX1+RFq8OewLLlTN5oozAMslFQ11qzvZ8uox72MH4gi21qf4I8dDclsuAN8N8ruUI/gmg+jWx0GLfpK61Ln04CyCdXfAXnJwFPuXstOoHNBKSNz4zBoXNbIMUOQLhIFJQHHmzAlN8DU/1ScAjQhgwXHeLZT0FxAvjgniDSybAlGn1gGc89Jg2dnQvxGU0R2yUpWyOvAcaZ8mpBPgpOTu39cM/fr3WfJsiJhCtu5gFSGba3oX/aY6kExAmCf/d/+25CaiRRRBEajXKHjiIHtop4+xmaiA1+j+3j8CSG25ihudiOJD1mb0k3dXoMX5/ruJdzYJKMgP4yqav+fdJeOF4gdMawhJNE/iJdjwVmqRj36wV3By92S4ImKkuxXJ66/e+yZ20/BZ5M7ss3nnR3EpajU57joM3TTCRPUMRnQAjNCLDfOxV+LwKgQWpbv6Y2mASw2GWMSW4Ky5gFnllomQ4J8+Xnb3afJDuqYLbA+Cc6jUzFTIEJRcVpQS+s+6gZXL7R+zOVgYNXzRYcJMA51VO/HDjWW/C9dEcoUpucMK4uvAnT9tS6DlV3A1jnzBiY+rATpphacNe+4XWUlITLSMM5u3mir6x1ggVMh88Gh0EN88fifsJnqu0eMlt6pHIlgyfiXA41EaBkTm1e8hY6r8ebrrPT8mO1ffuSYFKnVHbWhIgwIvqKEamsUfejlR6uPa70OR+APivRojHYyr/CHsW/qBbBAAIaRAa027qD7DK7rYgjIn/TpNc0+8BeWGvfLL14N2hEcuVIlsYAYTYt7ehR0x5qZuHWFhnvolgHfd5rd5Y9VW7l3sf/vho3evfRJilMwxtCKOx6UNP7EUm/M/tNB8vmlq/fYIprjpPHwF+eCU+NGU/5PEvBiT6ELS0u3IZmRCYSiIEj0DwKOqTjDENjxjy0bsy2s58mEBHaYz8vFIeSMWKXlsvEx6qQyXIGHCiuuCwbljM3ce
 wxjN6gWV
 KY7sVMpPVE+bw/V8105EyYmqNZmXZnxpUFOXiWtTdkagG2NJBdDYvBY7OvxxAZXgS5OQqFg2IE+XJj4uE62QveFzpqTI+Q3LeARVqvq/aQUso2rGcsIXT0fpE8Kye77U8w+0/7DdOCxN5tpw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 04:10:34PM +0200, Pratyush Yadav wrote:
> On Fri, Aug 14 2026, Chenghao Duan wrote:
> 
> > Replace manually paired mutex_lock/unlock with scoped_guard to align
> > with the coding style of the rest of the codebase and simplify locking
> > paths.
> 
> No. This is done explicitly because we don't want to mix gotos with the
> automatic cleanup-style locking. I don't think we should change this.
> 

Thank you for the clarification. I understand your concern about mixing
`goto`-based error handling with automatic cleanup-style locking.

I was wondering if these particular cases might still be suitable for
using `scoped_guard()`. The patch only changes two manually paired mutex
lock/unlock instances, and in both cases, the guard scope is limited to
the operation that requires the mutex. The lock is released before the
subsequent error-handling logic is executed, so the `goto` paths do not
cross the scope of the guard.

We could also use an explicit `scoped_guard { ... }` scope to make the
lifetime of the guard more obvious and easier to review.

Of course, I may be missing some broader considerations. If there are
other reasons why these cases should retain the explicit lock/unlock
pattern, I would be happy to follow your guidance.

Regards,
Chenghao

> [...]
> 
> -- 
> Regards,
> Pratyush Yadav

