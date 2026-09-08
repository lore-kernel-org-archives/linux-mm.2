Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B5EBC79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 720B06B009F; Tue,  8 Sep 2026 05:56:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D3AE6B00A0; Tue,  8 Sep 2026 05:56:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C33A6B00A1; Tue,  8 Sep 2026 05:56:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 388546B009F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:56:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9E1A3804A9
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:56:47 +0000 (UTC)
X-FDA: 85190140854.02.A0CEAA0
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf06.hostedemail.com (Postfix) with ESMTP id D399218000C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:56:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788861403;
	b=R8LKpypldVXKJtwUZppwuUFslmWO0Oo8eCQAmVuNsDlSBO0wVNACZd7dnGk3R/vLykCq0w
	DiB+h+m3icrZuMi7FCFMtN2VGG7Ope7SjzADQzDzBz+0YQFgi08xA5wEhowHtK1t+0/Ir5
	PYcrYPJY6lzpG2725qjQwY7uhNwsP88=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788861403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0/Brum9tOQKlUroYTtIHPsdanzwwvTW802hWdMpXWs8=;
	b=Z39F5qW5WYoZjyYUzizEjgz9XA2Dono/KWOc8Ly90NgsmrnFssGWwCjMMvthFyp77l5961
	UAV/QnqJs4LKsKScYtHWQnopgKBXhUwJ8fHrlcaRj/EY+1Xe2ebWrXCRtT50ChScQYMa6w
	3n4j7qVxcIwon9KDI+ryPeMudkgxeso=
X-UUID: 921928feab6b11f19a56ed5b684f684d-20260908
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:4716adfa-6f8e-4ef5-8821-d7ce7aaad837,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:0f4028235c6ff823b644fee21e638421,BulkI
	D:nil,BulkQuantity:0,SF:80|81|82|83|102|850|865|898,TC:nil,Content:0|15|50
	|99,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:
	0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 921928feab6b11f19a56ed5b684f684d-20260908
X-User: liuqiqi@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <liuqiqi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 990608029; Tue, 08 Sep 2026 17:56:32 +0800
From: Qiqi Liu <liuqiqi@kylinos.cn>
To: Gregory Price <gourry@gourry.net>
Cc: Qiqi Liu <liuqiqi@kylinos.cn>,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: page_alloc: add trace_mm_page_alloc to bulk allocation path
Date: Tue,  8 Sep 2026 17:56:26 +0800
Message-Id: <20260908095626.339906-1-liuqiqi@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <ap7Pbm70m0pw_NqM@gourry-fedora-PF4VCD3F>
References: <20260907120949.418450-1-liuqiqi@kylinos.cn> <ap7Pbm70m0pw_NqM@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D399218000C
X-Stat-Signature: eytrbax8sjpxzb3gc6cynozyya76baub
X-HE-Tag: 1788861402-368219
X-HE-Meta: U2FsdGVkX1+T0mEbSR+YqKMUxXYuXYXz7tl/Mgy3Fo3KjyzAovrvB4Hr2sBbgwgoksK1AHmSme1b1RkPIQ00W0irdUiju9NCjVailM2PNHyXw5b05ZzD52pHkR2ANzfSB9Hef466fWjF3M5CIb9vTiAYSeYAiP12CP7AnL0m8fOCk70DHFODvOojroHTXQLOzXV2oEqgpYpCUgqbAskVVamqtrpVdyxwvEoA9xOec9nqx61ANzVMPm0t8K32rBgtc6UD36729g3wt6grECdw94/IgXb4UIBSrA8diWI7ghQdymv7Wa9U5KLKRXfCtRq2lOMF2/0cPUcla0yfwo8KdrIoS3St+tKvCkV1RigW7CH4zvytPAlf/181QmDrJUuq1k1xko+8zwWojJ7eURPBSmwvAO7XTNLXgE3X8xjKqxNnAPgSygKFFXL4FvrwkJ2xM7Vk1zkOasDUCOdCfYYnBJslIhPSTv0wYxgeSc3gsUJYBTUzd9RSuDPWEUGRL2GCstq5fVzXSdaUftW3Pyl2mLbWN90dTcf8Gghx5kxVFmQaIfh/ai2HZfy9ZxE7PzgpDVirktJjtcOsOvJxdpFCwOgwSp1RdLxI4AIBoxC3M7hysgrqwV2tmxrvSpyusgBtAFzOazH7zHfksAlZcA6Ig72lZW5nMkenF8nx4P+e5w+7v7lLC2SV0oO0zoA5Q4xPOIlsUZXC50CnsWW65N9GBc5xg6o4aaJusrRsXc43DVldyPs+1ARrUMg5gU7DiKZnq7apIKAAFL0GHZ8jZMZhZ9rDS+Bzy4Yhrt+FTmIuiS/GjcnC5Qrjp8Y3Xwo2Vhn+1XnHf1VmiZjxTOiBexT+Iji/uypuChBDm/5szMaDFBPE57G9zjs4R2+6pZL3P3FJNMIDlyICz3k2fQbhGVCp7YmxUPsn4JFKKVW+kM/F/28B74nfaWkCZx0ee9+CRulmJLNRWM0JTN0QCLf/NXr
 JXcA6KzD
 XUCtnuhahpeGj43Bd0H50P/UQJcJqYoqbCSWdZwNth+jT/hQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 10:53:19AM -0400, Gregory Price wrote:
> Sashiko asked whether we're also missing kmsan hook here as well:
> 
> 	kmsan_alloc_page(page, 0, gfp);
> 
> Might be worth a quick look and just adding both in one go.
> 
> ~Gregory

Hi Gregory,

Thanks for the suggestion and for taking the time to review this patch.

I've added both trace_mm_page_alloc() and kmsan_alloc_page() in v3 to
ensure the bulk path matches the standard allocation path.

Best regards,
Qiqi Liu

