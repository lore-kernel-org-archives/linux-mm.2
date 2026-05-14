Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7142CD4F21
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 00:24:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 335596B0088; Wed, 13 May 2026 20:24:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BF7D6B008A; Wed, 13 May 2026 20:24:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D46C6B008C; Wed, 13 May 2026 20:24:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0814E6B0088
	for <linux-mm@kvack.org>; Wed, 13 May 2026 20:24:36 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8770C404DF
	for <linux-mm@kvack.org>; Thu, 14 May 2026 00:24:35 +0000 (UTC)
X-FDA: 84764129310.25.D3BE5E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id E033740010
	for <linux-mm@kvack.org>; Thu, 14 May 2026 00:24:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N6C93zl6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778718274; a=rsa-sha256;
	cv=none;
	b=iIjYaUT1MJlgzWnvEqac5P5dl3x9UvCPUOxxq4w9Y8Z1sA7T06ruwcyWCCTXtXbjjDXO4I
	V3v38ZojqCX+mPjkrLAdjBjZHTb4mv4Pa5CNYPOTtj/c2WYUE0dy1Jya9ZFpjpAGrp5K1o
	2rObx5cSwiMCDSemcSFTQdkGN2fyJBg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N6C93zl6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778718274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LFCBqIGcHBdYvh7yPmbQPn43oQeHek+X7uZzaNHFYhU=;
	b=EPmKT37rBRjhisg0uFkoIck4jyaH7UpjezAgkljJpuOOqbIOwpflKxXAmRByjgQtwpP3V8
	5i7mn4r1du/+wQJ6Ak3FuT4Ec0wpE/ZbkGPVLJTDw5xYbgelPahOZN//+qi0Ip2vsCsnhh
	uC6IiwTKcJMN9OeVQjxf/Dd9YB0tZeo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C8A7B40970;
	Thu, 14 May 2026 00:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F22C19425;
	Thu, 14 May 2026 00:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778718272;
	bh=GuwH8SuNkBn3b79VVOFgHKygVFlNrgnZIWfPoIXm2G0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N6C93zl66aDMFOp217stHkjyTmPmsWTgXKQbb8rfHdBk7DyEUb50JAXGKvxu9Ckpr
	 OQuvyXojqXkxByUAoI9lsfNQcRnr6xFFuDnwMLmoyhjjQbk0SYBw9uBK8YcfzulVSc
	 2HtvtZSuMw3eMFADEP5SBVFPZK51uHXCE+APcIbUKA4NcbJMymXfaxpUxIsbG/BM1e
	 SN1Js/uj8ykDaeCd/TP3IWUG0NDavrr6kihPHMkOmR1tIhNjYwlEgLdsamwD3dSyH6
	 TGBVCI0X7FuRAGLOadLVGXyAk+ezGg8P7EZSSEq1ZGtkcGTp9b5ydOnxCqRV6LpEGr
	 e8WLif9+eZszg==
From: SeongJae Park <sj@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ye Liu <liuye@kylinos.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] tools/mm/page-types: Fix typo in madvise() error message
Date: Wed, 13 May 2026 17:23:25 -0700
Message-ID: <20260514002330.148085-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260513022120.58033-2-ye.liu@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qwi5e4a6813y6ujxyjgpejdazk33c1c5
X-Rspam-User: 
X-Rspamd-Queue-Id: E033740010
X-Rspamd-Server: rspam07
X-HE-Tag: 1778718273-584537
X-HE-Meta: U2FsdGVkX19bsCy8DdWSsnyQ9YTEg7Rh0CVWvIqyhfZGtthFDvAdXB+oqMsE75O04ll6ZYP0gXavW3D/Z89mZSpyAY/8yIrCnIOXOTqBz2HRrUY7TF+7hJyBdmdWdit+UXkFXK4MLKNs/Cb0ucXCA/uy0U3k5idOU4+cwBVgkwkUE54g7OsOTa6SjlwSCFDqwh6DcPWbVn80yxcrNl6jblb4j9rt01FDW5oX6l+5r8wJGeG1Vt9VRGIBpak8Ve/JvfpiUWHWupfBTxK5xoFBs4bwVBYDXG1nooY8Y5qfBBBtJ/IUObG5HhIcPCOEaf1c0mdyZtZ0s8t1LkejmL6B2QqkSweLfjuUdddJ6h9cbu42ZicQkZFfJGaBOM6iMom9kGOprEZx+iH+sww34hy/ai66yJdwEi9uzogBT1Kj+DkM/KiQc/RD8en6sBlpNXcEi8Em5koa2uZpiZ6UazRiqELXLZabiiA0heCfHcwvKNuDiC633r10WBo9xC0FhL8ojr2UZFT2WILLA/YEhW1Xs5ydzGrrmB6dFwcx/vKtZa/wOT6KEULCY8E7GegxKlC0LWrpmFrzTIL+MAwQAzrJkb974zyYeqyix2aPR7PnkUEUH6fSst4dftMA615lGyNMB/tZtWuVQmqTMZrUhLsdILS7mPqYeo9R+qRx8MLNl+dx+yOmAlhT5my7a8wdNJYhfC7lH+8Q9PuFhXItynISzhPZBDMLRAB/lV8m204orj3KWmvmeBOf7XukmU2sdkkjmc/NqhsJepVNvanBnRvqY37v1+0sSK+CDrFQiNu8aPxLSFweVeRNc68lQBQaLqv6v+w+gtRAtv0H52pdkP3CEBU+nm+T9V0Ja0B0UZ/vhRocknVm4cVDLDk2oS6qPiM+KNGBRTcnO2O08zxEQ5RZanw/V5cgntod5KzWeNeBwB73TIKPgkqb6v0WcdpIFHhHi5ln05PTd6ywiAdCMz5
 XVGoFFDf
 paN9DgCr8H5Nz33zrO7B9gJhMCkPx6QJsat9EcI3Xb8fRbp+yX0G7jAz9oz4xqvpBSOmUPsdZ46osaZRS5SNMnFPVgcsrOlw4BZo1aT9ME5E/5DZS0GLBSD8H9VmiLNYmK9wUcAITMNl3MlMKis1cUxhHNkF/W6CfBoewlm8UobwQ5LDYdHFRuGq11gh6sDasjZayYhjUrJNP/EMIVupZ3vDgK6puJijM2wrqMPoHgbzbVwFWl4zZKVuMwz7gJ8fpRcu+52WFkHx7SwM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 May 2026 10:21:16 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> From: Ye Liu <liuye@kylinos.cn>
> 
> Two error messages incorrectly spelled the madvise() function name as
> "madvice". Fix the typo in both occurrences.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

