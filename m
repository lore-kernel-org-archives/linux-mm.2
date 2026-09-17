Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F166C982D6
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 14:37:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DD516B0099; Thu, 17 Sep 2026 10:37:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B6226B009B; Thu, 17 Sep 2026 10:37:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F2616B009D; Thu, 17 Sep 2026 10:37:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DF056B0099
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:37:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 54BACA53B5
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:37:17 +0000 (UTC)
X-FDA: 85223506914.12.F61FC7F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id C007F100003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:37:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KJuPtYUr;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789655835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1YrFDyne4Mw/5P6NtQygUYrYZ/7F2ZHeKeQK62aWTkU=;
	b=kuoRsa2/mZga50fwtnhUogqDMJxj/qUNeXXE0iePlxj2M13ndWLiiZ7x9CLGrMtB7nEZuZ
	iIQECast8IVXdXRZLlFUlJk09B74iTqrUWB7XRznig3vGd6LwW5n170sb/Ymmh24RT/Kp+
	ECkNlHDn18ue6KehJENy2kLxKBJMybc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789655835;
	b=LbWJqlcuB+mztxC0KUZ6oVOXUYGqv6Co+wAzSuPOxdg/57WQ2lUV1XGKFI/HFLZx5f7niO
	ycYiC7s8nF85EJSpr18UHrX0IRllHWxU6qXA99EJs7PINZoevOhu+nXKkWlnOHDr5RqeTp
	v+r+nsEuP0Gh5Ti69LzGhuy5tnhebFA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KJuPtYUr;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4642560211;
	Thu, 17 Sep 2026 14:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469181F000FF;
	Thu, 17 Sep 2026 14:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789655835;
	bh=1YrFDyne4Mw/5P6NtQygUYrYZ/7F2ZHeKeQK62aWTkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KJuPtYUrTYQGek3CmOas+vaeay56yXNJlPharuTziS0HuGlv9+bFj/ng4L9Gqzw6X
	 hbpaKm3VOtxa0FgbVaXIOP9wrqWNNOD5jxtUSdiCMlJ23GDiLKRUqDAB2K7ezJoG7Q
	 vSrwhA5gdOE2jvEuvVmcoXyGNO3SMivVMty3JoUNg4CSOH2RxmA/og+GLIRfI/WeY9
	 L3R58YHYfK0xLMYcRKW43nU/p7Atc8VcsmEP0qpenjTPt5XTS4eySByP+xz7CsjRMv
	 Gpndqtq8HYdEZuExkh0B23Pv24u9Ne3OCLxV5/ApNZ89mpRUte/JZyyYP1sMQUC7x9
	 Ur9U5xfQ7qZhQ==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 00/10] mm/damon: improve readability, clarity and test coverage
Date: Thu, 17 Sep 2026 07:37:06 -0700
Message-ID: <20260917143707.91700-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260917142210.90829-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C007F100003
X-Stat-Signature: 1bpx3iswsyp15z7td7dzf65za65mcqfo
X-Rspam-User: 
X-HE-Tag: 1789655835-130405
X-HE-Meta: U2FsdGVkX18o08xYQHUg+C5UGw68DOG0DdwOlUY0J8xxjmJy8AqgEyLrip7Iv4cd78otMSLO+3NTOduYEJcFJO7S98Y8BsNxiU5ulRMfCWZSFLIsLXxHq36ZEFxCDXRtjUMExZ+XLDLsgMPsQ69GCNcujrt3IGVBUytpHOlM0pg93clP/RCSMArsqvhX9ID50R/tYp+IdMmYlFijHtmRCk6EcXu1doB43u8cS/QHb8b1oWe0thhQED5YkHZVARrRboGD654Z5exUx0REyCrJIcCv14IBnqZfONKUCbrjQzti/772fUmg+mwiYgvX57G+N3QeyAPEO6KcOyzDRtn2UtaWy/UVgCf7IxWeg3xZirKZIv4Cn2g4hJEka1zieH7XkVWTb8Fq/b7/XvI2YFWkr56GZ21nuWLHOoFCTnBmuLE7E6USzFcdLafujlypYQtRF4IqzDi02pCcGouS4yIfXe9Tz/UBzumMOonQrcvdcXPCOyVqODN1kMN5w3s44Es3u4atTCq+uYzqnxnvOHS7MKI3wcTzAY2xFg6LWFhgyl4tUQjP90OJNfKZ/0yBY2ePxZ8F6LPwvsi0t0fyp55w2If8YhLvQ5i+EpdAFiHRwipjtnN8GisAD/0oYxN+CaHJ/AP+JGpvqlDBxcqEAoOqBv7k+OJTQakwaq/7mWzc6Kdzjo0L0kuYWOjZTc5wJxw+rVZsqoYPPr2VHUcyFy3d21bIaf6VWlb4AI/wFq3BNWEh2CwSQH81SNy2+0hOIqNn9i9EY+zNRY9rLz0wzjl7MhJPWQIQCoHXyqhM3fwUY1RwkZ6qvewo5FGKTmKMdssi/ERzRtZX3gKs393Ml6w2c1mgBC+odltth6hW3jXvXWDSKBU8svhjD70Qto4qvlW3uPWYbHhmQGgY6+fpd9VFS8aJkNo4kMiar9kEz/tK8EH+y6G0HCTg/5pt4DxDXim/7FtcSSeZJpnTontRx1j
 pDvr+R/g
 /wzuVdcLi64+ZYaQurA2BQRM0d/lTBpeRNlXqOQ0KNiI12WlDYn6bJyoMwecxLhi4Clrhd9y5QWFrIKkAtpoCR5+x351HxljcAAjCjgHxOPorAsm1wGaIrA2luMbz7pywjw/Yo4W41V8fdDSt4uW88KJ0G//4qAMjo1da/RLjkwSahAlv/hpyHn2LzVeVYntzbUH+t+lDAO0cgcW23I3D9uEEXyKPH0Q2biq8jPZdEFsbg6E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 17 Sep 2026 07:21:58 -0700 SJ Park <sj@kernel.org> wrote:

> Yet another batch of miscellaneous DAMON minor improvements.  Mostly
> focused on readability and clarity of code and document, and unit/self
> test coverage.  No user-visible behavioral change is intended.

Sashiko found no blocker for this series.  Sashiko send its findings to damon@
mailing list [1], and I reply those if anything needs to be clarified.  Please
refer to those for details.

[1] https://lore.kernel.org/damon/


Thanks,
SJ

