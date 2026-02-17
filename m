Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5499EE68147
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 17:19:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 728076B0088; Tue, 17 Feb 2026 12:19:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D59D6B0089; Tue, 17 Feb 2026 12:19:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D7E56B008A; Tue, 17 Feb 2026 12:19:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A8BC6B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:19:26 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0078F57BB6
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 17:19:25 +0000 (UTC)
X-FDA: 84454609932.03.9A9B84F
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4A454180004
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 17:19:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=hGQrADKP;
	dmarc=pass (policy=reject) header.from=gentwo.org;
	spf=pass (imf24.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771348764; a=rsa-sha256;
	cv=none;
	b=kU8PCIJ24pATYGvv5arfY9pDaWPWI4wP8MG5KKrJqjydVbStjt+XKmqRRDtnVNsUEHDDU3
	bBDbO0hMlmm5h8aaL94m7/amtGYKjJUBAIGJcBZ4CXLbclIZIVbECQwcr3GfanrptDm8OJ
	EG4/lxE3BC/gATQV+lRi3ZNjlV/hnH0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=hGQrADKP;
	dmarc=pass (policy=reject) header.from=gentwo.org;
	spf=pass (imf24.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771348764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iqvkO3d8pf0lSaPpz0YdQ9T5Ii+HCmRk3sj5lrZM12U=;
	b=U0aGTX8ME8e1S4YpTHGToaVS+MPw0FaB5+MZaGSa19JtTleKYz+vazJ/4eKoYW9xnu5ni2
	MyF5CjAOsOVCmkrdQ4EBrTkrqvcCYTc47KQTbQy6p7MO6zKWWaUjy9dI5MHE15gtwGaqNY
	9E1fnUQuxbeeybzQuf1ds7AILLSRQCI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1771348762;
	bh=iqvkO3d8pf0lSaPpz0YdQ9T5Ii+HCmRk3sj5lrZM12U=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=hGQrADKPIWiFzGofJtFWS3VD5op+SkWvFrgCBSDM+4x5bKFMAQhgHNu0wLhcjJOmX
	 9jnRpyJsGTG4PRoPWefEqa83g90G+mruAP4ug2OFNsx8KG4mvqy9Yu4dbOgwi1jMkY
	 SmLxDxlkInH2D4cYmRmr3SYdqMlAdkkVSpPJYNWw=
Received: by gentwo.org (Postfix, from userid 1003)
	id E70FD401B2; Tue, 17 Feb 2026 09:19:22 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id E5831400C8;
	Tue, 17 Feb 2026 09:19:22 -0800 (PST)
Date: Tue, 17 Feb 2026 09:19:22 -0800 (PST)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Dev Jain <dev.jain@arm.com>
cc: Will Deacon <will@kernel.org>, Jisheng Zhang <jszhang@kernel.org>, 
    Catalin Marinas <catalin.marinas@arm.com>, Dennis Zhou <dennis@kernel.org>, 
    Tejun Heo <tj@kernel.org>, linux-arm-kernel@lists.infradead.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org, maz@kernel.org
Subject: Re: [PATCH] arm64: remove HAVE_CMPXCHG_LOCAL
In-Reply-To: <89606308-3c03-4dcf-a89d-479258b710e4@arm.com>
Message-ID: <6d30176d-9673-287e-4658-a5e9e6e5d649@gentwo.org>
References: <20260215033944.16374-1-jszhang@kernel.org> <aZL46z1UZkQlF3Dd@willie-the-truck> <89606308-3c03-4dcf-a89d-479258b710e4@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: cugu69jyonrbw84fxtsurhbtfd9m1n3e
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4A454180004
X-HE-Tag: 1771348764-77045
X-HE-Meta: U2FsdGVkX1/FKqqTDAY1AJ3AayZsSB/AjfmRTCeI8rpuHNvpb+f5sM8e1oHThQwNs9YfXshNwpSQVvp8gzDOEB91f8jYlupAu/mYcP6hZZuU2AWcwx3RDq/ZKUSjsSo/iw0U8xFtiPZp/q3hNypVdv2opzDchjmFzviUKMkGhn7Mpw04DdzFzEI+O40hUSwXhyHvaX34RGfyXFqVw9zK6VOK1TFTXGzJpjzdJ4quoOe0cn3YNI43FovmADsokinDy0k8iy77b8m1X3hXTsTRnNeFT/jMG2smfvZpi1guMjdwReUcuxtjkLOrtpCFZQGDq/Yz+owKz8AM6oJpM3hkuJqOs5zHzV8ylqOgVSwO3uZPLRy6hnMQNIktQpKpTuF2aCfcrt1L7xTEck3OSBjXWtwYN2ArpyOdy3xYO6cI6cmA30F/ce5M4815suqcJs510gEJE56YqimEL9f5wL9oXXVgsrchc3tOD/zY+qG4ao2gf2HTlohKRTrYeYSHA/d0ZkhKXyCh8L98GdIWQ2zqq+ywk4wU8cAGJvH2G4O0t+vwxyFO28UULCgLdKTr7e3Jmt4BdAiOKgbQ5nJ6ViEOWNufJzBIpu1EzpROIUGmkN2CVgqtD3ShGMtPCH2WkJ3RTRwI5WSISGFms4Ginq6dFt/ttsFlvvSISxVgGnCYh6+zQP1a4eet2vxh3H9X3uLIdFPDhCuTFEqgiURYGZnYKG7ET8sQ5llBel3z5xB0MisfLv+zgXJ7MqtpAk2IR7YBnt8C2+Pjt04E1NkxxWEewnsfZswOil1iWi47V2GCnsd5HInNkpfEyRwEHT4Gll8ENCtqNYBU1cLPrU8KT8tNIixF1xnc2IggM5M9PT4Xl/tB3IGRTC4SrExo9zpGuQ+8x2EGYhd934jDKYtoI4N8YwXwuHFpB3bAu25UKmlYMQsrRa6QrDA1kb1wRsSNyxh6JqJZs70vw22ngf7xcTs
 hQFupc0q
 R2zW6xBdMKolydsf0j6JSzT+Z9627KR22fDOE6psRyUFj6l2P9wTL9iFQuuixudWMCLgwoDy+bkL3d2jorejnOic/oXr63Vin2GTqP8rbA4hCkEukGBDCZS6hQZ0D8h3cLYqdqusb1D2Rad07iz6JRjx5mijXx2XSIe/7gEU7NgnLqrbU2zzjEVeuWVGOlPpWPDUNmQmGY0meuW0i+W3HIAc6V/IhrJh11nghCaDngUPiEkqt/2f4YjlNLeieJ+Bu4BR3d31eHLHwT3B5apbA/8f5KAySDpFr2b1X68XXi3hjC2k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 16 Feb 2026, Dev Jain wrote:

> By coincidence, Yang Shi has been discussing the this_cpu_* overhead
> at [2].


Yang Shi is on vacation but we have a patchset that removes
preempt_enable/disable from this_cpu operations on ARM64.

The performance of cmpxchg varies by platform in use and with the kernel
config. The measurements that I did 2 years ago indicated that the cmpxchg
use with Ampere processors did not cause a regression.

Note that distro kernels often do not enable PREEMPT_FULL and therefore
preempt_disable/enable overhead is not incurred in production systems.

PREEMPT_VOLUNTARY does not use preemption for this_cpu ops.


