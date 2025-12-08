Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 687C3D3B7F3
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 18:46:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C0546B0006; Mon,  8 Dec 2025 13:46:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59B746B0007; Mon,  8 Dec 2025 13:46:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B05C6B0008; Mon,  8 Dec 2025 13:46:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 397686B0006
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 13:46:17 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A834688731
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 18:46:16 +0000 (UTC)
X-FDA: 84197183952.06.D95B7B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 006891C0012
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 18:46:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QAZSSSEy;
	spf=pass (imf18.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765219575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=ym/KXcutbN4CWF1BXQvC4iCR1aeHbJ3BMmQHERrFEcg=;
	b=yn2lix086tH370eDuYD5UF9B2jCroFetXXzKymaq9Q8qICnMSy+Ws7PLI9iMxFncSX4Q7t
	dH8kvIFEl8628z1h/0zu1UdIisz3mEKCFmie4LPXtLrvdIZGjzvgLIKJGaixhs+3VfSQaU
	fqmD3CZOJxh+7k4JtJMZ57GnqZ5zEus=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765219575; a=rsa-sha256;
	cv=none;
	b=Hhk3BcyX31HkAQiRKMsKsBV5e9/xMOJ4bQ+Nx8/cvANBFnbibpXLJlWR3lxf4WmlZC0xjb
	St8x502ZgXbjNUbb0fq937v2jdU/gdMokXeojq5irwxM74pMi6RuiB9ZiI4Cwf8lJHFuLZ
	syIyMMfyk5MwtK08PhZSNAh/vgIWMw4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QAZSSSEy;
	spf=pass (imf18.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 84E7540350;
	Mon,  8 Dec 2025 18:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4776AC4CEF1;
	Mon,  8 Dec 2025 18:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765219573;
	bh=3PhigGiQFETOlEHjQ8QT8DJmfkGFZGk3iQKzOfzK5wI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QAZSSSEywd62tybihpGXHEc5BTr5P5KMW18ZpX9fg9Opk/w1lIm9s+dt0FIfL/sMM
	 ZWTBsXPQlyDp1GDTI+8pNs1rrLK7i/0XwddVkiFIVHGlAqChDwrtRt+ENJCvHqCR1I
	 75y3K1c1+lQ3ropH2ISWwQcPFDUE5DfAIlO+jabzcUCOdHPQ5E9sFweI5I39jMgujA
	 ocDbnXzenQum78iXyVmvBR2MsJ9h7B0JSwHnd5RUJ25bb72jo/7mxgLYoi6fiDXZF8
	 9RaK2Vyqs4akzGgRZJ0qbg5L8byF+rE0d5W7AIr+mJgh2Qx9DA6ErqlTAKGnkn0AfB
	 lxDTnsJdnrTFw==
Date: Mon, 08 Dec 2025 08:46:12 -1000
Message-ID: <b0cb1cd3fe26bd0f79bafd0f6aa3249e@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Guopeng Zhang <zhangguopeng@kylinos.cn>
Cc: hannes@cmpxchg.org, shuah@kernel.org, roman.gushchin@linux.dev,
 lance.yang@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 mkoutny@suse.com, linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/3] selftests: cgroup: Enhance robustness with
 polling helpers
In-Reply-To: <20251203115631.947908-1-zhangguopeng@kylinos.cn>
References: <20251203115631.947908-1-zhangguopeng@kylinos.cn>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 006891C0012
X-Stat-Signature: xcuc8hexsr5ui96eg44oiso4mdiqob4u
X-Rspam-User: 
X-HE-Tag: 1765219574-205101
X-HE-Meta: U2FsdGVkX1+KEf659XnzzWW6W5eKe41uiANKoRlRuzvJjpZhStKOpyYNCmfxaCWB/eHVppxjALOgyvYU/uQzfYlIhXrCNyRQJjimwMaEceU3LHFl7dDpRtbgeF6pwT3S4pG01shcAKRXZaZ5OXVTZijlCw81HPayD60qX97z05EjiWUTHbTppAM/DMnJf8l6LGh5zNUfHdUadrNWEaBQhvYimKYYtNyNr2gMd2udmpuJIBPvEqvqM3qbJutIAq9rqZZWNYCBlbdWrFUztx8htkZ2HGea/3+OXznCTJKmmUz+B0gWY1sHUcuuBPY+erqIIZ+vKF1Cobip5njCuduSh0nvl5HTA1SXjAHsfCnOXXO/KKLcOJx9xATG58T25vPvygVnV76GNAGo01xkMC5PyUUVXLPxHIYisDAXtNJr3YVBNHZCIzPehNdQJHYO+zDNYAa/t4lI5PS2UQ43fxsXjwEbozuUWosr9KiA/CZbg4x0I9Xff5gTCiD7NoO7Fii/0rsWheIfN2oLmuHn88FjnB+3qoBfz/ZpecazXEHzNJ542V386SkyU4F8vwYrNdZhjqExeL0NxRfdMG71W/TmU0RfRSj7I80jR1UJ1S/SR7SSTi3eXSZ7K7Pjt3m+NHFuH8u1ohJNNUkTLcEIJS4nwQrlHKnD9ERXkHWPBVBXxKXsaqCmqvjJY79Bc0i2AJjllDD5pYan7xeW6e4A+f25x325GXdVi8vVxx8aCKxMkFgMmwk19MsO7nAAKTEhlcBDKfvWdLoW7RHXbPku3KOZKNaLwpU8pUIcSs7KkO7J+uEy/b9+as3cCg/JA66IBBQoK2l+c+MvgjYiRSWMIAAH+L7vMt69FWWiFClTU9b0ae0CLYZpDqiyR3bAf9ZxMMXRYxW3URXLyiLdkz8btpucp8YuUggxecClblJLThvk+HpzESiGkyxGqIFuzoUBkxtPssM6NMpgEXqBpoqY7VK
 wgxxiH1Y
 lZINnvroIV2yVTl9cRRgUoy09qG/efo1/B7+VAgDYGd0Zog0jpqtDNBKraGKZKaJvoIvY8wT/xAADlD/VGYQJuMsl2UyPraLtQzGu72yWcdXWzTptNrMoNpXq7HS7f/UkPT8Oc36nb9RQjsClLxK2Wpcryl5397d/9WeXbpK5TVVdIgG+pjZsc8txm/9qLj0VczfU54gGWYDFTe4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Guopeng Zhang (3):
>   selftests: cgroup: Add cg_read_key_long_poll() to poll a cgroup key
>     with retries
>   selftests: cgroup: make test_memcg_sock robust against delayed sock
>     stats
>   selftests: cgroup: Replace sleep with cg_read_key_long_poll() for
>     waiting on nr_dying_descendants

Applied 1-3 to cgroup/for-6.20.

Thanks.
--
tejun

