Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C2D8D711CC
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 00:03:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74C8A6B0089; Thu, 18 Dec 2025 19:03:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F6E16B008A; Thu, 18 Dec 2025 19:03:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F9876B008C; Thu, 18 Dec 2025 19:03:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4DC7A6B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:03:51 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DD4D21A03A5
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:03:50 +0000 (UTC)
X-FDA: 84234272220.01.95A830A
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0169B14000F
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:03:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IhBEihe1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of elver@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766102629; a=rsa-sha256;
	cv=none;
	b=Un1Y4Nj4rGGoOF3UMq7j/xXiKcsoBqog8Leub0M0avGmtAGXGwkHXGo4oy+G2YMnrjBEBt
	FWi5i0bX6gskIVbGNLzOaMUu2TMRaGT7XVqeASThZ8bUbM34vjsTAvXGeEUop5E7+AkfWI
	vEPN7AeXodSGhWHzOAYDxu4L8TtE67g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IhBEihe1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of elver@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766102629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J1OfIMpVDk62sfqPnD60EDcy2G+mtS7t2qT60UIugPU=;
	b=6+a0aiau3RKm9qZhIDExq8gATBHoyk2jR4p51pHren0hgVPMf6Br30oQ15UN6PELe1htK/
	ivG2cwNOsrNtpo3QUfDACW/K9JM1qAl658helfbhFbGb6GYYwpK/jKWYP62br7c7FCaUd6
	AVRp1PpdFMbeaV0o8wNPyvpsYZdEiiQ=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2a0d5c365ceso14536555ad.3
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 16:03:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766102628; x=1766707428; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=J1OfIMpVDk62sfqPnD60EDcy2G+mtS7t2qT60UIugPU=;
        b=IhBEihe17CTB+iLenxhf+M62ac3Repxf9SR4Q/KXRn6nrsAZGhccwC6pu9z/8VqH9N
         O+33CKoyWvcPQOUk8BjDsd5XlUGaIBicwUrWlW8el3t0CCTGmwXNvz0pT6uFW5M4gr1o
         4B2r2wvgE7iHG7pTXVvSCOAfEX7i3EmxJS5O4OVl7IGOSfPY2D3yF5I3BrWJXgU8VsFO
         vtqDMCSm1zkWNs3U/x3mZ5F60UHdDxRRQPFeup0enmh9WasGVFirR2zVq0uQ/radGsIz
         gefRoZpY4kOQYFRduSOv7LGZYI1jc5lU5cZ0hFKCqbwovLX87TXtbx61IXRcFlbUS4rB
         Yy0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766102628; x=1766707428;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J1OfIMpVDk62sfqPnD60EDcy2G+mtS7t2qT60UIugPU=;
        b=sfpXA4Grl40drdtThhEDtYlhNuwMxUcn9Yd2j9qbtZLYTNbyg55LJrMMF+l1jT4ryr
         W+WV7zxQL4O+qGyMpzZCTKSo8G/Y9zpLnBiY4cFPLt1O2LAXYijNasOEldlM8YCWtla/
         MEXKciZJO9khgoxHI08uiHu9zZIO9fs7QB59YPKHwaMD5BCZuiCVKlvoNdT1So3OyDV2
         pACdaUl3Uq/VQ3cGJv6bUzTgPnxMpfSagDCm14lbYNY5RWLrWERrw1fJTS9Rpj0xQQmk
         xxexEDhzYdGwS7ho3UaVa6veZ/soepJGQG3Bl5n0FI01MnVkTvAixAZJFOaWRmXqQC+O
         9/Pw==
X-Forwarded-Encrypted: i=1; AJvYcCVUHcoA/lIaTHH9I7Rbp10fstEdp5EmUGK+EZSgSl7CBo+uJg9Jg3ILhuvMaDXe3w87JHS6+4PMYQ==@kvack.org
X-Gm-Message-State: AOJu0YxpNZ789CX4/6KBMpE4BORw30YwCInexSjucD6wKzLgQdVgk2uV
	GMHudsOKchLUfgPvNdkK+JMCO99+Z5O5tzXgmneOS1yVInyXexJRgfQrwT9TB/0PyaIsjDI3yBy
	qXLTlHeM1DLqQD/QYEte8wDFsaTLEj5fagslm1umM
X-Gm-Gg: AY/fxX7B2hO5V5Gz7j7UoX5sML9cDdYILQLpL/8gp5GGc0GBg56wQEGu06kCKissBMn
	W2hNpm0Gy4pYArXK74VkXMovAWc1GEDzWTBrPlM8WP7KxA/S4NILOBqpgg7Ls036MdLHVuY8qn7
	rgPrsYQk3YIEy/lNGYoFvLTRLXL9yddBB4wMmz21b7wh5cPptRy95DldTgsjVeO9C39TkSDo7b1
	hC2cx+W1woSRbqmC05RRFRWb91Ny/LKFeuqiisRrFjlvTHV0lFFQf6aUGyUb3wNxD2hJQ7xgGXQ
	sMxni+tINAF8j7Gv3bDs45rhGeA=
X-Google-Smtp-Source: AGHT+IFO8edNObswh3g/cWBIHqoDV1kxgvRHStv3yHScBSQstJAUv8VeYX2OBsNr/qdV1agwyLKHNocDDaFcF+jZhDk=
X-Received: by 2002:a05:7022:7e04:b0:11b:b882:3ed5 with SMTP id
 a92af1059eb24-121722eb273mr1139356c88.37.1766102627520; Thu, 18 Dec 2025
 16:03:47 -0800 (PST)
MIME-Version: 1.0
References: <20251218015849.1414609-1-yuanlinyu@honor.com> <20251218015849.1414609-4-yuanlinyu@honor.com>
 <20251218155821.92454cbb7117c27c1b914ce0@linux-foundation.org>
In-Reply-To: <20251218155821.92454cbb7117c27c1b914ce0@linux-foundation.org>
From: Marco Elver <elver@google.com>
Date: Fri, 19 Dec 2025 01:03:11 +0100
X-Gm-Features: AQt7F2qIdd3MXH1-hSjhv0OOTjwhSC0HJne1GRIX5sYTttEXnEWfzHwYmrFE2mE
Message-ID: <CANpmjNP1tMwdOUTNEqqTmWR2Ki8yDQ+H13iSHxzLkomj-WComQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] kfence: allow change number of object by early parameter
To: Andrew Morton <akpm@linux-foundation.org>
Cc: yuan linyu <yuanlinyu@honor.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 0169B14000F
X-Stat-Signature: 8y1gweexgb5zjg1hfwyxjrcak3oua6qj
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766102628-751010
X-HE-Meta: U2FsdGVkX18P9wBFiEN+MAFeM43i0MYnm3c/nmn0LZkSFlfis4RwsmrVs8DrZol+Tw0ozfBFUj5xjjl0Mz6P9rylBIOfPvp53imKCFfgwXp32zZy4JMqYnKBGevljrKy3N29PVbJ3fPlBGyM2r1UiDL5w6ZlA3G22OvxrJ6YTYGXfj0ymaeEssiQ/2aPmknnwdsR/DLxMi5jePmw3jtfTmO5XnePiljVrnz3laArbLVDMUkAB/XPTdI6whszUUOirtIrik1nD0laPxmqOy+gwPMfEX2z+iyEBpFEYBh/hu5NEve2vyetbUQwjbdMxiVJJ59d9U9RH/VB3E0YwuLMfdGQKNmMJDOHGKRT+GaOXCBHal3iEHnV+vVoueJhKeF5sDozoAidVh7Z0oH1t9odN+V7ZAO6vOWV1vMLdbyxeNPpLk9hO/NqBv7E8n4k+jAQz/u0aMON9STlm5n7EJyQZu61Evg3x6LxwCIBpJllZ/QI+g5TgRNwTNw7t2HWDbp51JOnFwLEz7Kic6V78/q/WS6TeudsO5fRwflUsiO7glEdGSOBKk/96MdbwXR0CFtSW+jhaCu6+nePxdk3ds73+yRuQdCykt+aZIrJrMzwmjEH6LhR+Ll9fsVLIVKRqQlxnJmNlWrg4e3KuWRkS7Kz/3SS1ZanZ6th6nG50/oRckEemCqMin2QtCQhPyVviQgy/oi0fRPyWkDq/NpO23HEtfB9rYPNp9k/nmpxcGbaGRgxri3rijtYG2P31V53ffmROyVlHOXQ1ZidUNYWkiqNN3ZYNrA9zZY9azFiqg+fLpCRHB69RCGFmy45+NY+guRvNFZkdb46tRRC0Yy15LR2A0s3qqm3IucF2q1H4q+76YTynpMUJ9epxPXJTkwvcCKChH/JTTgYuDMKRVXUbOL3uSDWNS+381H3GaUiKSahjFh5Gs0EC1lkDwtN0esOmGck0Iqsjfh/D2webza0xC+
 a8/ckrA8
 O5unsEZAeXPcjc1txbhG9fApytYKwxIzL+V+iG5xHzzn7hr2Yv0E1lH85Je/XxJHTkcYYuRREVPYXij0WLmvx4EWysKXtle5l0QB8EXnTzl+MpCwyYuYOWKS3OKRTzz9rw3pkvjS48VUQVod3MG05A6rJLXRoP3VBXgBpeGOxvBDSwzJhGq+oVA7D14CNepE76VLEPPiw4QUJprygZSP4z31b1gpZX8pjUSMKzSQu3+Ioa1w/Mo+LPxU9pYs1LHp+SpPoAzoWbUhN/2auoQlsYT+xV6ZypnRxHQBwuuLIrUDcL02Z/QWxZs5fBivOA8HiRb0TERor0mCYtUwLRFTGTgAImmPsleHwvJMuKui/aw+gGiw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Dec 2025 at 00:58, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Thu, 18 Dec 2025 09:58:49 +0800 yuan linyu <yuanlinyu@honor.com> wrote:
>
> > when want to change the kfence pool size, currently it is not easy and
> > need to compile kernel.
> >
> > Add an early boot parameter kfence.num_objects to allow change kfence
> > objects number and allow increate total pool to provide high failure
> > rate.
> >
> > ...
> >
> >  include/linux/kfence.h  |   5 +-
> >  mm/kfence/core.c        | 122 +++++++++++++++++++++++++++++-----------
> >  mm/kfence/kfence.h      |   4 +-
> >  mm/kfence/kfence_test.c |   2 +-
>
> Can you please add some documentation in Documentation/dev-tools/kfence.rst?
>
> Also, this should be described in
> Documentation/admin-guide/kernel-parameters.txt.  That file doesn't
> mention kfence at all, which might be an oversight.
>
> Meanwhile, I'll queue these patches in mm.git's mm-nonmm-unstable
> branch for some testing.  I'll await reviewer input before proceeding
> further.  Thanks.

Note, there was an v2 sent 5 hours after this v1, which I had
commented on here:
https://lore.kernel.org/all/aUPB18Xeh1BhF9GS@elver.google.com/

Thanks,
-- Marco

