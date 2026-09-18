Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2761CC982D9
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 09:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89ADD6B009F; Fri, 18 Sep 2026 05:11:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84B446B00A0; Fri, 18 Sep 2026 05:11:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69E186B00A1; Fri, 18 Sep 2026 05:11:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4672C6B009F
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:11:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BB7211C2CAA
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:11:29 +0000 (UTC)
X-FDA: 85226314698.26.09FA38E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1010340004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:11:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=STANK877;
	spf=pass (imf01.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789722688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eS5LuPDHoj1TWToJqflXDh6Kd9akzSM+PIMju1UQTtY=;
	b=6BPf4xUkFRJAvE/1CHBlJuKS7ajWuIwq0SFLesFZGhK3nCaT633gXWiP6FuBrUyqmVeb2l
	zVBIGqSS4dKo8vu+wM49Lq7iWckreJxoawCXDIwNmIpAMfOTycj9JqDriBWDTOS+cjW5Ul
	I2lF0sOlxAYhb6WKn9CRXAzrJHGFaDk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789722688;
	b=k9SmtCdfeZjLHV6OU6Zq35gQE7rmJ6erIiaZxkATwRywvlQwIWz2RvyboIzwHEyQJyVOwU
	8SIoC0tU8Jp91HGuPb/MxoCvxxbtPiBCe7no6ifxm9FJm3rkrlMEsjtXomzpYwVBALOu5R
	ySvQcRXbPVTZQImt6IcveZtKco6uprU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=STANK877;
	spf=pass (imf01.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B1DB3168F;
	Fri, 18 Sep 2026 02:11:23 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B8BFE3F882;
	Fri, 18 Sep 2026 02:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789722687; bh=QDovF6IY2cXmjqmBfXW5bRuHL6UkjR3u0TxhkLEgnqU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=STANK877C1Whm2O8uccdlWMmaOMh9bKuHYoKP58NSc/v7I4sfca5KNJ7pPa7+g4Z/
	 GvzUC7/afJIhuBHqmNSLGtCWjBlIvQp1+TJoItEH7D5WBx+CObtdJvHVkSaFVIrJCg
	 hkgR4zLf55tW80Ea1Y0VCqda2FfoXf6FIPYylEDs=
Date: Fri, 18 Sep 2026 10:11:22 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH 2/3] Documentation: kmemleak: fix stale statements about
 scanning
Message-ID: <aq0AOiEyi635ARKm@arm.com>
References: <20260917-b4-kmemleak-doc-v1-0-84fde6d1f749@debian.org>
 <20260917-b4-kmemleak-doc-v1-2-84fde6d1f749@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-b4-kmemleak-doc-v1-2-84fde6d1f749@debian.org>
X-Stat-Signature: ap1964nymtw3a1hext9x5wscjhuu4jb4
X-Rspam-User: 
X-Rspamd-Queue-Id: 1010340004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789722687-838711
X-HE-Meta: U2FsdGVkX19c4waMEo57OpeIQaxh/GBWoXRr6/DxZj+RtzoXt04ANT3UtrMeweDfj0wwCL/I9rq9psm5raiFm+Nx9gTrDSDjQpsuOo6leYMwQMwb3iHCT0ZmVEohnR/ROsur77Taw+R6O+az3ZjX9ubnkCuQ2Dj3TklnDTtK6L5oR/SzBNyGB45SERvX7fNrRbwf/nMiTDCw0hdHrjI9tSdAIFppmOIOoazp1uUA7AidvuulkS22O5WtuwU8HCADkvyV3GHKOkp0siG4D7LaGS2LgjviVTHHlzxMl9l2njskHSBhczTabsoNXO1OAG+ErNT/W/bIBbYr7NwlMuFd08pDv2ombHwbQNwed9E9swZ+9q8ZecTugsk41NC69fP2LqMlxiUJID6o37pVq+ME0pCcwU1VwG9xpwPtnWs6WqwJrW11n8hIb/6yHIPMFz9b/Gb6tkh3QPeqCf7R2KBOKJ5Ea0OU9rV3KxGhnIioKpeKyFBHLvhf2lD6yh4hkIYBOQ0fdr37yfiC3+yUEs5d54gzYcPgtcyjEop1Wf+UkECnsoI+1t74RTZHviuIW3/kLPJhq7Ad8dbn5gAp7vGN5QnAdPsm7J3+F0+hHNgIsWQT5X8f3wr9Miag3V7IV8GJVtu5VHCUCQrFlsrz1v9Kt4DYB8NaDblUFAZkhtdm3esLLm1OVJIF9Dq7cImO9a4+C4sCgTBXomIOB661H9AWCy3PZdLD8S7oPbHdYj+MU7jfWOcQds3mDWfjolcEqlw5/ibNwDtkJBnFJi66NUPgMljzpREKs2dnekgDXJDD4Km8secdOk1JtUlqxrE/84J3CXXMM0BGFps9cV2RYvUJUre8fPpppxj4dETN7huIN1nvq3/qrPq4BxjfoDW2yY6ZWVx5CsbOzU89O5SHkscK5Pgz2cnxDlt/u+qIDL9IwUTlHdBHvIP74+AJ0yXOXhLzkoLU+iY4wyhD1rdYLgb
 /MEpOklZ
 AQl2Q4bV7ZiGUUKBwH4zhPJZImm3a/spSrLCPHd0KlFDlQ0keuU60iBVxa99J1zzfeuBfGHtLHgvaPb/8tobnW9DvkkjvkXNhVgayTtaytyMnoBu0x0I+eGHIuhxWK5ZTRnJyxg99tbcspvtSgMSzZISERjL9ggn7ZHhT53nBl5TN8TWdJj9R9iykKY5MX4Yu8u3G775pDMKG+TU2KTuY5ZAYM7IWOAjr6j8XnC4QmuqIBBYIoRfiygmUV0X+LyFnUrvDYU+ZUwMSF66BQkiOit0+mvp4Py6vExi2wQ9wgOwO+8CNkW2YurFhrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 06:47:36AM -0700, Breno Leitao wrote:
> Three statements in the "false positives/negatives" and "Limitations"
> sections have never matched the code:
> 
>  - task stack scanning is on by default (kmemleak_stack_scan = 1), as
>    the parameter list earlier in the same document already states;
> 
>  - MSECS_MIN_AGE has been 5000, not 1000, since the initial commit;
> 
>  - scanning is done by a periodic kthread. Reading the debugfs file
>    only lists what the last scan found; kmemleak_open() calls
>    seq_open() and never scans.
> 
> Fixes: 04f70336c80c ("kmemleak: Add documentation on the memory leak detector")
> Fixes: e0a2a1601bec ("kmemleak: Enable task stacks scanning by default")
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

