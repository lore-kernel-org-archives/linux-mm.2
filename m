Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BFF0CAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 14:16:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A627C8E0013; Tue,  9 Sep 2025 10:16:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A12988E0003; Tue,  9 Sep 2025 10:16:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 928B48E0013; Tue,  9 Sep 2025 10:16:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7F20A8E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:16:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4BB0B1A0566
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:16:54 +0000 (UTC)
X-FDA: 83869913148.19.6672840
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4583B80015
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:16:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I0ObQKur;
	spf=pass (imf30.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757427412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TBPCbx1t1DtRFy/Qmvoz+7PpnPwODyvsfSiVPNyKvTQ=;
	b=wyg/kkywV7PEl1p9zAS8N7SOS99Dx00zd9YtiZh95HFgEKBZ0TVl21Ghm9SeNFvddpNGvJ
	HNdfgO40bWmGRnOsxgDziKfkXkJbdztqB/XxcUa5F9asLKVnkXGj9aMHiCoYUA/qswRctt
	/N2xNLySLB+jArErPZVuxc13fdpaVtU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I0ObQKur;
	spf=pass (imf30.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757427412; a=rsa-sha256;
	cv=none;
	b=sjIzaSoMCnmeOzhuRoNytsWApnMLGIqGq8eMZP5EBpKsoU2AlkFSCayl/cIsz0GT1yhP+0
	I8fCLFGnYgmX6E0JXkqfc6Fz0CvETUyFHGcbV4v4Gl1JkA7ACZgC4LYktukdkzeko28ICN
	qEd3/v1aa4fMOol/MpLBNhC3nXCPzUc=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-24c8ef94e5dso46008225ad.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 07:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757427411; x=1758032211; darn=kvack.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TBPCbx1t1DtRFy/Qmvoz+7PpnPwODyvsfSiVPNyKvTQ=;
        b=I0ObQKurqIaDtxLwhDLZ1+lS8NUduBuVDgbSkzNG2sBFUakpm6VJ0w7Fob3tf8Shx4
         QMcmjdAmLOQJNGQqNNA4juPlaXsoM41AwyQSOuQkY64g0R9xhcxiBPVHCuQBuTOutjTJ
         zGkaWmADQ6VupEMWN9i4EHQMm9yCIwCrwEhCW+jtcli0/HUv7XKA4+QUAqodk5FUOVh5
         SfVUro/4EhEZhSmkp8ZYQbR4ifWbIIJhFeQAa4F2SEA2ddMBKM1CcZLxAyAjQd10fCIr
         9FfJZK3DwJrtS2nXeSGi2Q4cgDZYdkXMULx8IX/IJvO3VqRkfesoRX3GRwVI/J/6CNmd
         q5cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757427411; x=1758032211;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TBPCbx1t1DtRFy/Qmvoz+7PpnPwODyvsfSiVPNyKvTQ=;
        b=PszvzveYGQUZfXKMNWKXJnpGeufF+aB6nu5NGZdV8ZegM7qhV7C0m0g1IRYCMSdmjX
         wOEWwSaf97ZvMtU0dRS50Ga/ZQttwgPtA0vID4R1SGtaVbmritwjjO4HK+wO2Et+iyfr
         7Vv0A+4DlM62wL6sha7rtbAZVPikcu7BePQMFFmz+tHUgIGGW1WoXY68DA7R/ZmPhXPj
         TBZrlmbt3OW2n2Iy8/ZmmjF5Q2/j/65/EPDbFDAiey2dtAS6XDbYcLU1hFSlVWJiCXR4
         EVqeH6/1Eq3okWI5FddOAN5k+CI6BuLdQPxFNgfy5Xx78Mg3hTqlhdljss8OjIBR56p0
         LSKw==
X-Forwarded-Encrypted: i=1; AJvYcCWzT59aVRkd/Tfn2HxNwKYxsTBR74FNdhY/B8gRR7XUo19uwQz637SUcON+o/AVf/cNXp6i/zW45w==@kvack.org
X-Gm-Message-State: AOJu0YzKAOMqY/Ww2eVjf8Ir67MEa55OjIVBXVzDk4jT1KVbw0tZ+pdg
	9gpDCnR0JMAL3WhFwJIXNNPVaRSsQGFzb9lQjYmota9Yif6QiciztqsvUMLkuEWA4iU=
X-Gm-Gg: ASbGncszYU5RAYMSAvGBuD1uoaek4jhwZ7DEY+q26pehuSVRiaW0I1wF7gDpipIE3mU
	5cZFUIIO8Zha/s4jhxIKyTb8FB6Ts5qqP6fi/i6GKLMo/1yaHck3TB4Zs41AC4A2b/LWzw60CjP
	H8Bj917xCD8myF7zCcP21INMTRt/09pBL3y08rcAlEnjXPmiqheK25rNU9KHLvtUZT95P9ClecF
	Gw4nIeCeodDBIm6HOGFRpuxxMr7qGG6PRXmGdeuO30aeJzXxZs9UvxFPHpCFxY6Fz20q9z/kfx/
	npaKBkM9TDE+68DLy2v8T2AOlC/eOHzaw3JMwV7T8w9c6xBIVF0KNOJFmZ9AVlZ1qYtfD0AP+32
	7rj+Tw1ebzv2+iVLikQctJrMG/vjau87QvTCdbWQYsoL+hjBhTHg=
X-Google-Smtp-Source: AGHT+IEnAyzLMxqnxsLrvjbSykcpJDqbEB5tk3wlxNjto04xhv0xpGQJTdUpv/FS+YKjD89GTMMNpQ==
X-Received: by 2002:a17:902:f70f:b0:24d:34:b9e7 with SMTP id d9443c01a7336-24d0034be6cmr205718095ad.29.1757427410945;
        Tue, 09 Sep 2025 07:16:50 -0700 (PDT)
Received: from smtpclient.apple ([39.144.103.165])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24c9c2b12f9sm171757705ad.101.2025.09.09.07.16.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Sep 2025 07:16:50 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH] mm: shmem: fix too little space for tmpfs only fallback
 4KB
From: Vernon Yang <vernon2gm@gmail.com>
In-Reply-To: <20250908162220.480d7014cc6c6ad2e14748c5@linux-foundation.org>
Date: Tue, 9 Sep 2025 22:16:34 +0800
Cc: Vernon Yang <vernon2gm@gmail.com>,
 hughd@google.com,
 baolin.wang@linux.alibaba.com,
 da.gomez@samsung.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
Content-Transfer-Encoding: 7bit
Message-Id: <441CA7B5-4D1C-4334-AC1A-2CDA87530478@gmail.com>
References: <20250908123128.900254-1-vernon2gm@gmail.com>
 <20250908162220.480d7014cc6c6ad2e14748c5@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.3826.700.81)
X-Stat-Signature: 618pzhyi94nfn3kdckqrik7f5fg95mba
X-Rspam-User: 
X-Rspamd-Queue-Id: 4583B80015
X-Rspamd-Server: rspam04
X-HE-Tag: 1757427412-130824
X-HE-Meta: U2FsdGVkX1+T7QK2Zq1FN72QwyoJkDv8hg2/pVRvcXwUwtvbS1aiBxgBDRMagAPP+W6wec1JMYqHMmE9a52/HddgvuuCnuT7w0nKMx83CduRTzxRP+ExXEtddzCOdL9UYzpS4l7aDJEEEBqB01rYLTU/2/FfllikxAucqguktKn6JrSzOvsz/Ahn80HbNTMrV/emyNT5hwXB5TRemkMQWkmCqxS4btKqCWAlQybiwYA/Y/h0J0WT7XHhJZI1UeyNv1LQQIv4I60aA63I7Z6B1eZxIblaEWxDlmflhJdpr8lO6mdjHtYbtcaNWNLY8SW3NPVe9WQx1ze46TV8CKZMactBW/8LHTuFQ1n9JGnr1ifxsOZIaIZlsVcclzrSnbQnQylc0XL8D/lZa7q5ByRcc8P+hGQc4iAAKgGdZ9F7C+idbVS7LouD372ZWXJAg2+sdZyX+htPORXmyXIxNtPOAtQBj4sIvg6QvrG+8Rq3gCxmV58TBaWcaPaiXiH6VbAjcmweS6N2AvUaVDZkGh4b44wVwRfNJppuA12Juea1INf/35AGPjlyCyhAuuBk10sqYaQT1lYlNOTKrjneCIyIVXUaqcCgy9sUrCh8mLXjanur5uyDhUGa9KblW2SpYDe32g2CatGtgE/jihbX1MsBWzksZZU72eSdEJ66RB+vdwa8cxMHl1/o+WoNAVHzCznoXosBVPIsxqfM9MfZAEQzVEG4nyo6AyCZ2AS9B+luhUfurcF6e6KJSYyXJYwADdkRt5QPMXQEkP/3l6F+5Tb+0sn6UnaEzhbO0TcPdCteEyDFqD1SDuKuQJzPNHwrJTA2o4gJhd/6nARbVjZnA0whx+uAzaM2f3EYg/hkkqL4MFy1w/qfcTbRuA1El6AlOjcubPrEtewMvfZupYxjnKoICcH52dHRMPPLM8XMfVUY/VfmyGJ1v0PoFAj48cNnu0vzlYoV089FuTFkBEGv7aQ
 P6ImdEbq
 A2Q5Yu0uj0kg2yhEgyBlM5TdLt0K3GiHUYLyjOi6BdCk8SotLZG0LtDnAe6eWYIVx4LxIwJ6xem+1WfG4T6KjS3/CpXUftIqXGuuJ/Q/P4dtHpB+vuLKJLzpd1ZYvhK8JSIkuDvhUWjVmT7UXvcTjUNnLoKT7kg2+bYZBHdERVFZKemoVEWiotZ9CzDVXBEH+9EwBRHOS6RhdhXzh1BaroemymcBYP+BZW+6auTWrKJjqDAdr83a43wq4TCi6sGMA+wB8arzCs2gHJ+SsmSp5LHs1lI7DXN9TNSUBuesNAMjxydtxvQ05JQnpk4KWDZPbHDfHyIlNhcGxlMAN12eva90WyPUBJTh4C+msi+SF2nMQmhnsEJz27WHfBwidBgLmuuLrB3TwoYOv6pqa+N8ygw2Jq4uWdjG+HLYDuuzyOrU+Gk+KdRuisj98M0oDFmIcg5B2IG+2W4zUtXsZ3NWFLgGdg3HLff0aL7sZjRLzsulIvZIH7WmEs2FcaxrJuEIuXxeLo8uJlv3jFGB10Qe5Y06npw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 9, 2025, at 07:22, Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> On Mon,  8 Sep 2025 20:31:28 +0800 Vernon Yang <vernon2gm@gmail.com> wrote:
> 
>> From: Vernon Yang <yanglincheng@kylinos.cn>
>> 
>> When the system memory is sufficient, allocating memory is always
>> successful, but when tmpfs size is low (e.g. 1MB), it falls back
>> directly from 2MB to 4KB, and other small granularity (8KB ~ 1024KB)
>> will not be tried.
>> 
>> Therefore add check whether the remaining space of tmpfs is sufficient
>> for allocation. If there is too little space left, try smaller large
>> folio.
> 
> Thanks.
> 
> What are the effects of this change?  I'm assuming it's an
> *improvement*, rather than a fix for some misbehavior?
> 

When we use tmpfs and the tmpfs space is getting smaller and smaller 
(e.g. less than 2MB), it can still allocate 8KB~1MB large folio.

Thank you for your feedback.

