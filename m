Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF6C7C54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 04:26:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C16476B008C; Fri, 31 Jul 2026 00:26:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA0726B0092; Fri, 31 Jul 2026 00:26:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A67536B0093; Fri, 31 Jul 2026 00:26:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 78A356B008C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 00:26:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E48D312031B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 04:26:04 +0000 (UTC)
X-FDA: 85047784248.07.DFAAC08
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf08.hostedemail.com (Postfix) with ESMTP id 48C0016000B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 04:26:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=u1Qx5jfi;
	spf=pass (imf08.hostedemail.com: domain of rientjes@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785471963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=e0nCztGoa/l/2+RwH5pDYsChhQlyQ+c1/cRmoRb5QTQ=;
	b=A4To5T5a2/gUaqy4T5XxOYqttT/bf4N2zadvfFHlYVhDyJtaTOCKvD9d40sHJ/9NVqTHDl
	v/0Q1Nyfoo5R41Vw70ujJtMse2lhZGFUePzayO/KHfL6qJJ7OBG5U5sABm+47eI0NHJFTC
	funK5XuhmziJ8xhtLbY7xu424GX+cvM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=u1Qx5jfi;
	spf=pass (imf08.hostedemail.com: domain of rientjes@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785471963;
	b=4f61EuSBHnch7vhPESmediwt9g6NKFwE66pmCCZRkb2wvv+RuVUYDKGH8vVOUvhBORxxih
	s/nFTupo1m/gFo2FrXyLS2wiDgJKM9A6XeX+zIAaeqd1vnoAJjHwWHjCW9bzOE417ct7YE
	iX7TA8XfbXqfDbpmLzEbOZsbblyZFdY=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cede6375caso58415ad.0
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 21:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785471962; x=1786076762; darn=kvack.org;
        h=content-type:mime-version:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=e0nCztGoa/l/2+RwH5pDYsChhQlyQ+c1/cRmoRb5QTQ=;
        b=u1Qx5jfiouzi8YeIsEJSVkS5kCiD8O9fuBQIeJBrNO69y6gKm0ndJPkMEx1lvSf5EI
         bOajAin/KbSj3OUliZSBIZQ0VKJCUDL9gUdbZ10QNkoOY3Z3qmD8dUE0QyJPbGgefYMo
         ppV++5smX0YapsDwrGG1moT4RFkq71KwAOONxaiSvdha597rMZaeQqHRQMO5vuD05kkF
         3k3rYTQ1fArVJC71DWLQZ3bA+M789G+92E1FCJJ4cIpyunx1bAnsGjGEshfAszYeWLqG
         fmFV7ueFt7QuRENvlruhOGdcy9c2JZSZJDgRBwGrP+tUCr3fcaWvTaHSpKHCg/LCkS1o
         mrQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785471962; x=1786076762;
        h=content-type:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=e0nCztGoa/l/2+RwH5pDYsChhQlyQ+c1/cRmoRb5QTQ=;
        b=PsSzSn+Y1he7puqrt4z0/V1jayAs4AwUDtpUBgcufd0TKRTtCpfHuppFqY+xKA76Op
         ErjgtF7M7waJaXSVK12QDdnAWDiYor5BjXiMFfczOH9KKYqSJx1NdHFPGZa1KrB+66pB
         QMkpK7Sq3qWoWtNrhNkt79o6OhqfvxC9OJmFSMMRWHCpE4Rbyy+/rnh4HPIpJxkzU5GW
         3y9HyHOZ4W6LUH+l/k/nY/HTjOI2OiF5AXRZT/zVjBVu3XI/9MlnvXl1i1H11OKJ2z7n
         4KAdPbxI1Iw0dU0NV5zAsKSz8vT56kyFf7WYUUCdTjYnIvPS5g7S/HZED8lyAsAJ+E2b
         p8YQ==
X-Forwarded-Encrypted: i=1; AHgh+RrX6nGzBuW3EdZjNNP44uPM2ym3tTcdLMgQqp7JHTztWZsKzL488NKJTSBG70y2nWjyX5llPMGTHA==@kvack.org
X-Gm-Message-State: AOJu0YxLR3Ju+GEmoOoB6O7/hUQJshVf+dhvcpWjdIihVH8nAM7TUBWU
	SeyVxToJieOOnvmBnfoIdJiTaFAHpYwK+ngPlVRf3G2IaoI5HCajq8ZITYlmN4jYLw==
X-Gm-Gg: AR+sD12oN4oIUubx14HghEHntgU9tA9cE3jMHZrMwejEhdCbjqYAHzNmsm42jD3QoCP
	RjONxntAdlVbm27VMAiFPdzJeMgR4VniqCFzDh33ojeNbb0nQjfPSCcHaifptshjbYn5HikTNN/
	t+pAb09uaPDMlFXpskGLL4TPYSWzd7loSqUPh9R6ub3Ha3Tnqlo6coOxtdN9qu9GyRgaojFRVB4
	Y3ozdJaCx/vYnF85snMiyLmSm0fUK94qGhLHyfc3goKEvaGVFqByTYx9mK5UT2irKmvKldT2VG2
	jbNItaMXwycpKZFb3lP2tuIpyH0GLJ5guznfardWCKhcj9pg752GOtwAOC2vsmJrSblLwW3HDSx
	U+KzD8XdUUk8cBTvn8UhbyHcSHOvJsth0UGb3mSrj5jZWps2rfYHUA4Pvc/bmdgcsSJ4Aq0Gp5W
	nxfY4oHnUbVa+DjGhuJhSVFxnjD30d0DnHuR4tZGO0qjeaWvn1/f9yZeu+K81uNI57RR5Nyg5pn
	wHn4kIvtGfqm76ceQ5Ve1IgqDCgDHEpXUcltxjIaF529AFzIkVFpEqbejNbw1mWHrIhfCtMe1vU
	oTLpmXTc62EQQpQ=
X-Received: by 2002:a17:903:1aed:b0:2c0:defb:557e with SMTP id d9443c01a7336-2d046daf95fmr1948225ad.1.1785471961564;
        Thu, 30 Jul 2026 21:26:01 -0700 (PDT)
Received: from [2a00:79e0:2eb4:9:a061:9e19:11a8:45b6] ([2a00:79e0:2eb4:9:a061:9e19:11a8:45b6])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84ed5deb8c8sm194275b3a.47.2026.07.30.21.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 21:26:01 -0700 (PDT)
Date: Thu, 30 Jul 2026 21:26:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@kernel.org>, Christoph Lameter <cl@gentwo.org>
cc: Vlastimil Babka <vbabka@kernel.org>, 
    Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: [patch 0/3] lib: add synthetic MM benchmarks
Message-ID: <d6787a7f-3213-2b2c-2de5-af3b02daa21f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Queue-Id: 48C0016000B
X-Rspamd-Server: rspam01
X-Stat-Signature: n8a5mtt9kt5ysnbxgjiqwjahjqiotjre
X-HE-Tag: 1785471963-85779
X-HE-Meta: U2FsdGVkX1+OaHt1MgHtBjVVT1IwiACJzOu9f3v+PKsX0ZyTku+7EHUJaMM+VxH1Lfmc1rYLsi0EvjYgJxc1qgk15AeoyGXEbrC3Xsg6lX1ahz8+wUxD7fbRN4pDYcCgCplxCVy2PTWyqpEFBTJ7MsZm5tE7eYCWMRzaDm/zVj0uNXAtMv36PSjFxyo5B8BqPyb/aW2xdLicqlxqm9uo1G/esDvujmfaRtmCR7DTBuFUb7XKuwsZwA9FWC5UBsmOESo72bwK6U2KCXu7MmtBN6zyJmiaRgjcTCmNfJjKsQPLyX9SpDIVx9i8GY0wnqbeXSN7Xb53qMeJUPTFzK5snPHdlQKNdMltoUvhUZewlbHFId5vJnI7QAXnKHa2H1ES48mZEoO8YZFck0aVK7a6H5nMeDhftdDaez77MPjdv5Tow0oIiX+Azk8E+hlc3TnewUHr5ja385hItBMa5VJQwpDzRKnJowyHT3ZkpKq+HkTC32IJV4sFRlM+U/KPpccT//DF9U9oqB8dEVR+0VkovUVP4n95vDAL67KrknMofZ1bz3Y+/a6sVzx7yGgdt3/CDkcgCtOv23Gspd4zhr/HWDDOmYyCP/O/eUFvhoK8wfU8R/tTg7a20GPIDjhBYkxAE3hFd1Fw+tAtW8A8wO8smUdgbE3cqkJVUOhdZPaH5wjVbzgQHOHMA6/Z9rAFYbk9KU/0ej1/9tGxPoC96eergi1ON119r5fvppGYG2msLIZBfnnhkTyu0tj7gGCqDkBDXkGB3TU2WMZIAp/YgnM7BmwYSnn98q9QlwdOgJL0vlvKLRSZOyVw9M5qGcCKbmr9IuwNGCdEzZgQnu0OHrdSNsFxQ/HBTqpXSEv4c9wpmHe8ReZjTajJXRQa/JPSVKYzekOJPxkoJLiiN3EVNWM5Nl+i0+eXFkeRTdN+RtcFqlFV5+/QLp+FvrOLShum9PekWMtEVO7mtIhSn+bxJwO
 SxZNL8Si
 nZgh14Eu6MxB/lIjBauUnJLlH2yvaYbDtSnZcRPQNPc6Zwbru7JU7WADoX2teP/XY9lT6uqgvMqERgo7OBqFbQ2CRIYfJne3eRuUmKJFjFn6McPZE7jLkZovDGv03x1MjZD98e+6EVntsQbP1TGJPF3kqx7VfaB763qVS+LdxExsLet11GfSp7zNyoET1UhI0hxTUiKLuag9YEuEHFMVhGB5VEsfxt1GSESR43BDXA8DDd7imfNie5msIaBv3BV9b2jnn2vX7jSUbKiAsZ3VTUr3Me0Fqd8PdR3NXbtRij2qqkzdtHJ0DvDpdm0BVPjaZ6aF6uGC8e4YUSmykAJON9k7Y9+HUo4sCbOB+lepHxdcF5ZyZ/Y9sbiOVjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A blast to the past :)

We've been carrying these synthetic benchmarks in our kernel tree since 
2009 because they've been helpful to identify regressions in hot paths, as 
well as quantifying any improvements that have been made for new changes.  
Hopefully they can be useful to others as well.

The synthetic benchmarks are run by loading the module at runtime.  The 
modprobe will fail intentionally so that the module gets insta-unloaded.  
The test results are emitted to the kernel log.

Proposed with permission from Christoph.
---
 lib/Kconfig.debug    |  30 ++++
 lib/Makefile         |   3 +
 lib/test_pagealloc.c | 337 ++++++++++++++++++++++++++++++++++++++
 lib/test_slab.c      | 375 +++++++++++++++++++++++++++++++++++++++++++
 lib/test_vmstat.c    |  95 +++++++++++
 5 files changed, 840 insertions(+)
 create mode 100644 lib/test_pagealloc.c
 create mode 100644 lib/test_slab.c
 create mode 100644 lib/test_vmstat.c

