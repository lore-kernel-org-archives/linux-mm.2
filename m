Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C562E7544F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 17:38:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F07C6B0095; Wed, 24 Dec 2025 12:38:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D1F66B0096; Wed, 24 Dec 2025 12:38:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FF046B0098; Wed, 24 Dec 2025 12:38:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E9516B0095
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 12:38:19 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E7176140466
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 17:38:18 +0000 (UTC)
X-FDA: 84255073476.23.61A1B8A
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf20.hostedemail.com (Postfix) with ESMTP id 81E131C0004
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 17:38:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=c8vQ3CTC;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf20.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766597897; a=rsa-sha256;
	cv=none;
	b=2kovyXeAfWBhSnrYfYdEL7yoBendf7N02CIZCoB5Nbn9V0xUnV0m8Yui3mvNMBscnFCY+N
	9P0Hhs8TUtaZo9z+3iTHnY40yWMdmEQR2h/bzprh+x/UCxe+Df6bZc6or2Nn8dU73uaCjV
	k2itcNblOUxhm7Jo4R5f6DX3E5FWL8U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=c8vQ3CTC;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf20.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766597897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sQZAwN4AVCXzeoFBEIWA+9sJPievKhexVVJ1vPyzRO8=;
	b=zYDsvMTbvSjCS6SLV6hfGRimq3aL1YfzzSjq743ZLfC1R37nrZHn4lDmW9WFDwaqZMVH5G
	ZDqqyTTDJ0UUSPrYs0LjNRXIkltqy6uaiShWfmEfsNt/+pBQK6MZBvsdt6Qejc9jHnIdRb
	McfPnDlpz9zm3OXc0NuGlo9EjkeGsqc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1766597896;
	bh=sQZAwN4AVCXzeoFBEIWA+9sJPievKhexVVJ1vPyzRO8=;
	h=From:To:Cc:Subject:Date:From;
	b=c8vQ3CTCCOG9T8fENTWH5OfDQW7B+OH93Oh05ML3f5rmcECRacpkmsgyeJSCc/JVQ
	 yX37RojCtwQK+5YsNdyOeHtmx7ZhS+Jbd+qmkvBwoBtynMwEgB5zwFdiMsxhwjRzPl
	 nLtVALg8euVckWSgiWUjYqVDy4xcusn+WDFCZlNBz0AUAdILDnt7LyPTieKDCfUfSu
	 EC4err4xMA+WG9QnfINO3NO5GhBSQdpgEjYTp4T5f9Oudg4wpxE+H0x2SkTS/wZlw9
	 7bn3H12kecBtvdZQTbvyY6sthhmlNkENZbLHgkowrh185BPv4Gk7+UwZIN/N5dtcuZ
	 NrOOjbefaEOAA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4dbzcS5h6hzfKt;
	Wed, 24 Dec 2025 12:38:16 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mark Brown <broonie@kernel.org>,
	linux-mm@kvack.org
Subject: [PATCH 0/1] Hierarchical percpu counters preparation
Date: Wed, 24 Dec 2025 12:38:09 -0500
Message-Id: <20251224173810.648699-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 81E131C0004
X-Stat-Signature: 4tf6oi1kpq3j1mbbxcot4spap5dgos4s
X-Rspam-User: 
X-HE-Tag: 1766597897-587081
X-HE-Meta: U2FsdGVkX1+H7EgIT1dicXlz6ylj1ZASaUXTE6qQ+Mky2qi9Qhs+41yJF6VJkQdAbOwnapDuYvKGs8K5PZpr2eyFjPOlXkYj1Av2ecr3ttHFPCN7On1ZHlToaBm29O57yImt6qAN9YYK3dp0V71g1jxuXfFsFUwpA7I0eMVxQvHjq7d7MEw31YEIyIPTRiRmCO38JTlra96kJPEJUis5x30/0HhwMCVTlmLZjftgPPmeXoIIBo/eyB1x+eJN49FScAReq/KqRrrjWgWh4Ld05f943ImEjGOtpHpX0mRm7QKMWGt8EBoVtNbjYBOjAgQ67JFRDVYlIC/kORIKjGMFNBBjf5/7AOH+kAKGDVQhrW2qxkDk3joTSjDVhrbcXEfP1oDCvmPwvacgyYDTopa0CtEIlp8xHO919wEmJO63mT0LllztxxBJ8jHBPN9GMWMx/jsj1yP9L2/gzBI2hKxocxeVsvvbReknlNhAuJxXZeNwUycL66vHsfQM/QBY9ALmHvSqraaV7+Saa3XwZ6nlFCKHdvjn2ONszBbEolAWRtapePlEdwixSZEzpUnn72p5OqewOmq/2nu+1jAx4uTgXABQLzYxk42ZkHPt6blSe4BXtT6eWNDNbwk/yWShnUK7NLqciY779YUFB9NNolQcEuHD8+kECiQq0fkZbKcGSOoqGPoQmFxFdll7vlBydzCy+nGYJKW5HAjaWHZA3IJwcmJid0wtoGkoGX7vdFQzEBtiq/deNVf7FUhR+wkDv6pZ6nLxtaNOAAjoJL2Fac6RR58aWstHYOZXxEUXBlJIW5Gfu0/dy67Lf7NduKCx3/1OaT3dsmnym/7PiXguux1ZJZm/iqJ2q12WsMUKl/TvBVLiM6Fn94i1E2fGY0FNSnuZcdb61dubvq5D8+qaWepbmOyS5XJBOS4g0WLKuEabs+If/8cF0YiFZT28+twD4Q6klH9WUs9FaqE4+rkU1yX
 Dcnhflp1
 A11ZLkDWdukvXFgmpDZ7e47SY/AiUXZiDHlbs5xR471OPs+yVTBV84mbGrw9v5OGudgcJpc8NK3oXEYc/I92abkshpUTiOCrSe8KYVP0Oav+YGW+2Sq/kfrg86lwkruzTqAw2SR0tLz4OtCM6rTNAvymV8NlnbW+hK+rub/sPyvnjB/pvpx3QiyaXysVpd0rx1nvf54FtEIhk+30YoDfii+q+/S7FPuTCVczw2dFYjdTRvIbjgcFbojRplK3P4FsoeHgX4NybQ/X1VUNVG2tRvAGttX2lyp1nTd8uJ1dElsuiWLTqHwBG2VnCbi2Tt8OhK503ZEssQkM//Ew/yttZ3wvwNJ2QddE6+90BvkkJHt9LqJAi+7iDBJdIqQ4h/ET+zCbVlXVEFJ18ujo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

This patch is a preparation step for HPCC, for the OOM killer
improvements. I suspect that this patch is useful on its own, because it
really makes no sense to sum up accounting statistics of use_mm within
kernel threads which are only temporarily using those mm.

Thanks,

Mathieu

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-mm@kvack.org

Mathieu Desnoyers (1):
  tsacct: Skip all kernel threads

 kernel/tsacct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.39.5

