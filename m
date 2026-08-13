Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40B73C5AC67
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 08:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36D8F6B03F2; Thu, 13 Aug 2026 04:12:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3450E6B03F3; Thu, 13 Aug 2026 04:12:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 281BD6B03F4; Thu, 13 Aug 2026 04:12:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0543F6B03F2
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:12:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DCE631A05AE
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:12:26 +0000 (UTC)
X-FDA: 85095529092.07.7FC6814
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id B2045120003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:12:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=EhEZb991;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786608745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kB3DfN1MCxQMYcltpesY/usFBKfe+aUASD4/bfF/Nbs=;
	b=2TjZDxhPtKoKKX8rnBuFrEUzyzqDPopX7jVFchjlTFWMWGGqbpWSjeLFCPExLqXWPO06jE
	RxG7O4zJpjwE+KDJ8h5MyiztIl16we8Ioaqh59pdLCjVFy+2dtSDOfdt0QjfrhmlSUniQw
	pAI9/C/GfxpudDf0riChfTOmVGbRvrY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=EhEZb991;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786608745;
	b=WRrDoY3vS/Klqlhyhpr+uu9Q7KSO7KX7CICXfaVRK1XrEad0IDqdZA6ABvL3GTS4V9smoY
	lPK86Tx+Gv3gpFj7kUUllWtzMIou9os8Yz7TACnBMfS6sj08I2Icb4aIdR4kMVW5aMq/NE
	nX/Weg4G9GoqxXY22Pd6criIMsUQlZw=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4954dff6536so13248105e9.0
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786608743; x=1787213543; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kB3DfN1MCxQMYcltpesY/usFBKfe+aUASD4/bfF/Nbs=;
        b=EhEZb991APlMxS4jOqma1gIAPhltCCyWwin1K2nMpjRGgYyHSJS6k/KLl3we/gIo37
         L1h4IfWhKRoXeSnSd/RD0Jp574c+8Gn4Ipemmxi07WtTylBI9hXRDSPUsRYXYpiW4ZSf
         qM4le9ZicRDrCbI22w8do6WJCpY38M+Agq4Gzak4hlpAQstZziA26N59XCfjqrLnoxHD
         RTD7iQH4P/l7ynGdHS3VeoZu2LlAxoEfiKs6g1QIzsx6tgGoMJpKrrqxWCAH1Wkj3gFL
         ZEM06IYXOyxccdWlctDp7Gy6ANmVjLFyXlkDKn5j1Zq0s8N10Dln3/Eyi61am3p+PA2/
         AjcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786608743; x=1787213543;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kB3DfN1MCxQMYcltpesY/usFBKfe+aUASD4/bfF/Nbs=;
        b=oYLXOExF0IBTolnMWUfb+Sq0+cluqaiaQXiOy10aoNIMshZIMONykJVEXIHm8FlwCR
         ZDFk47QVGM90acBaH8tblcgKlQd8/dtvRrCspQT14Gf90PQUcj00I4cjkpU29Ti9qL+O
         PFy5qk62XFSr9UY51npN5I8m8CDljANjDWIkYZZPJ/ejgiQ6n9bqOAcHgNej9iKB04Zy
         jIrH0D9eTCSWiHCvgrK9a9eaHKJeTFErZnQ9iSTHLAhWK0T/DYfZScWa+n4ZQG8rJ6Nk
         RHSfo/3seOLOCy7sz7v0+I5gbZyrxkS9KJpD3h4d/tfOtghzIjKr7jCU0I4dJkRSkuwB
         jNgw==
X-Forwarded-Encrypted: i=1; AHgh+Rp7ST5edY+eHCA/cnDDHV/cjeLxeLzCvQCFfW042yxdUBiccmBYcLYfYe8cdXioPnLT9b/R23FHBQ==@kvack.org
X-Gm-Message-State: AOJu0YyYjI7Y4Shp5Fm6O50Zm5fAbzlrlbpiOWq0L+wiFrY5+RS7cIr0
	CPwYtIBdpIC9Wi5Ux2PTjG9t5cJ0aTGaS/k41FqtOICa5FTSxi1UDrHpTwqLZ2v7ovA=
X-Gm-Gg: AR+sD121aEsq6xtohqDv03NdjVDZn3BnP+tO0xOdFctcNQtqDzk+Pm+yvS+r+9gRBeh
	DpLvmb0kXiYNiTNrhTGr6NYec17ZP348Shm68h7HrPneuHs/eCTySJplvVWDHRDUgMzzQa9qo7g
	0I+OR4SQTWzsJ7M5eUnXBHBBw/Y4lIMbcNI7dCGPQ1ZnW4z8JTHBB0/Ysueeyd2OKGBfLxa/CkU
	bAl7HjG+iGMfE/CowmQALPsZQmhwDg+f7JxzTShG+CqUYoktAe4RLiQsRvchmUQ/xtfP7lF1UIo
	A9T9Nu5UCnmWhZfZsTV956+4IZMYs9fgNUAmCJ3YimeUnZPmjy17hG4qZm/Iuwt8toZWm9Ty0nx
	oCinzlY3c8FIm5C34vKC4NJjOFUyU8ZL9ackbIRtPf/JpqRXEbwA/3SwHiPIrvcQLZI7CjM61ZN
	xbKs8QQYXywTBdVEanIICagVpH9ctAwjeyWG/E5kz/xe1ZqPFOgF6mNh4+B2XjiFXIy2hzRDc=
X-Received: by 2002:a05:600c:358b:b0:499:60bf:c6f7 with SMTP id 5b1f17b1804b1-499821c2ffdmr44445965e9.13.1786608743142;
        Thu, 13 Aug 2026 01:12:23 -0700 (PDT)
Received: from localhost (109-81-29-60.rct.o2.cz. [109.81.29.60])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49981b58700sm42254295e9.9.2026.08.13.01.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 01:12:22 -0700 (PDT)
Date: Thu, 13 Aug 2026 10:12:21 +0200
From: Michal Hocko <mhocko@suse.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm/oom_kill: dump top 5 memory consumers by RSS in
 OOM report
Message-ID: <an18ZbYWit7oiwHl@tiehlicka>
References: <20260811062924.4123014-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811062924.4123014-1-ye.liu@linux.dev>
X-Rspam-User: 
X-Stat-Signature: 6zns1qhrq4pi3rbadhtcpiqy9dq3t3fr
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B2045120003
X-HE-Tag: 1786608744-4549
X-HE-Meta: U2FsdGVkX1/rW0evPriHZG3gN0Kue4YUJZ+U8LiCxIqKbTI6r9mOCuSpHMXauo4YmGV2SLcxtxCxyIXAi4fGUGFEI1pJnKtmV2/OCjxM55/pF5J6YB6bTMwCcoiyfVrJq0JOkdgjx3vBr8vW2Qf1L+xlvpovTPx7FWlBHVbuiyZ/LuVTOXuBZOKHcCiifO1DC/FczVqyzaizdFLfTEYqhxGLEjggdZn8Bb26ulB+Q9rRWVB8Tcr548lI/n6Rnq71FqgXHvG93c4tsWAnz4wCrZgj/i/lfJ7hSOBz9M/2sgVtB0zY1SXJpedXcI80bcsEldtHbZCb1JrdihyKvUF0+RTm0dKMXZvW5+wlA/d0Qu+satPIQox7vNrZTzvoYODxUhk9vXHEnyVOePaD6Xje7SJOWnH9D6G6aYxTBrESXM8lQofrjFmXZkwoDXQwY7D9qYSJw7vA/VNgaqrqfG0wEXFB/ERLiBmdVcWPThB84y7Wu2RjyQqrr9iB6X5ZDRxQ5NwPGGZqObzfF+kLOnpwsQi+3cYCHl4XXEahcKcsPCo+Bx5mm7YpZYM2wH+4JiYsQPzqVIdy4PDKDiC3fVCSDAWo/mw/bz8ajuzGeDBYnJj07Ngej7Hh4zwiP63qkR0A+xvk9i593pH0xJHVBVDwi6zaQuPl22fK8CPAanTK1Jjwg8aqSAOgeAV1Nf9E3uFi33/CZ01u7+wN9UOZCJk4nuZMxrIBZAyC3jhHQHimMr7hWp8+7qcZTF6xr8k6ppjUnT3VEH4GETCNbKSWgEMI+Z6pzLSqDfJao6J0+VaEE0XB7Fenyk5LyvL07k14BWSbV9V5HwSGNIgNJUhm773wwx1peFR+nVAJSfGyu2tCPP6613ng4nFBE6gfoVPY7FaF9p9DKuUo6RuMSClBVS02KGVtBgVkIA70KBzARp/+OT2AW1V8sR4dMoOgyZKrKVEj/iIr1yeda+dskoqSjec
 EGFQY6aC
 /vtxm4j5wMfuq0tod1B0SG8RKXWg3fDSZTkTed/cemXyZ3fohWWwAN4CB72ddrA9ixdO0BliXOGOi1oQxv00AT987bnSZJs6D3fFLKSlEmRSWjpE7MoKV074WEUG+CQPaU75MQgvlPCRGFZczjfaKwK0vN4cQ/Sn8BXr6coNuChiooObbLU9wlHjp34WdeTEKp8YUSI8A9hyxNaiLf+OKGLM0nsi99NtCGIJH8sKCuNFf9FZygzh0f8nzuzdbE7RNRg12ELe3lMCez6mREuzknE1ZJ89ZlzEy3YC3vm2be7644JaqghpqmCY6q5rS5/qO+Jr9JTqj5CaVCeU82KTSlCK5a+FDkCBYXoSKf8mN3l2p/ereeNIxm1vXvmr8yK8MLl5tQR0C5CP2LsyOj9Ul0ywLfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 11-08-26 14:29:24, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> When the OOM killer triggers, dump_tasks() prints every task's memory
> state but in no particular order.  On systems with hundreds of
> processes, identifying the heaviest memory consumers requires manual
> log post-processing.

Yes, but why is that a problem? It should be a pretty easy script, no?
-- 
Michal Hocko
SUSE Labs

