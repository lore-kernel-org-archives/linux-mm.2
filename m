Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1910CCAC5B9
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 17:27:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 223828E0016; Mon, 29 Sep 2025 13:27:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FB428E0002; Mon, 29 Sep 2025 13:27:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 138838E0016; Mon, 29 Sep 2025 13:27:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F2B098E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 13:27:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C13A213AFAC
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 17:27:29 +0000 (UTC)
X-FDA: 83942969418.21.7B6229A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 25E202000C
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 17:27:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K97J425c;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759166848; a=rsa-sha256;
	cv=none;
	b=2VbvhU8jjmuBcx7Uy7c5qdFVYduSNMuAgS3C32FqrzrXF8ZXuVnkGqR0nULSNf9gIPBzvz
	Fe5dCgj9ivI2igTv7bAWjpptpssqAeAV1ipTWgtVMQ6o4SildyGTzniDTpONSdKn2pf3Mq
	xqkLjbonO5ef4TCrgFGKA60e21hghy0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K97J425c;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759166848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zyoRxjQ45g5hWswl83gM0bWW6PfytciJLy2e3VwJH14=;
	b=Qh3IYiSBpJK4wS5/Vr7sz9gJRvdRIR0PUenkRxA2oZh+8veJwfikpCf3NOfKB+iyI/m4Wb
	oc1XKdnUMfj2xEYG7iEjYbzk1sAcFs0gvSs7992ZPvuMK3ut2Fqo4oB6+VsA2CQGj9CleV
	pO3vdMEvyOxnY0vxzTwjele/hxr+bts=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 94182435BA;
	Mon, 29 Sep 2025 17:27:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F70C4CEF4;
	Mon, 29 Sep 2025 17:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759166846;
	bh=xZx6R7dFweaok8lUi1K5smoZfZMEh6mwF0ylBiXnklI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K97J425cVsFjCFh1Q8tmEELHYGOHWnTCj/bu9zQ233PfivIJxVPevSyB6e8VYUMzS
	 N1+VU7lnaoIrqJRfnxJweMR2GK9U0/PUC/eS8P8y/z4enU4HUmv+izHrwm5O5iMAZt
	 zH67euXt2quG1eZG903nfE8s3Vd2Ek5Q0qowifkwYJbn+oDjaRL3AVH6He47mXGcHY
	 dInbVrGPGMq1LU84tcrkULofi8qbw2pOhd44T54sbkuYRLdNxnx2zvd90ORxxGThfT
	 O7ke91CytHn3hSWrXBsP3nmfFjKWmSehEDIzwpGJqrNu0KFbGTNNzZiOn3oSAhNAn0
	 qn13KCfRzVTIg==
From: SeongJae Park <sj@kernel.org>
To: Sidharth Seela <sidharthseela@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	nphamcs@gmail.com,
	hannes@cmpxchg.org,
	nathan@kernel.org,
	shuah@kernel.org,
	morbo@google.com,
	justinstitt@google.com,
	nick.desaulniers+lkml@gmail.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	david.hunter.linux@gmail.com
Subject: Re: [PATCH v1] selftests: cachestat: Fix warning on declaration under label
Date: Mon, 29 Sep 2025 10:27:24 -0700
Message-Id: <20250929172724.75108-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250929115405.25695-2-sidharthseela@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 25E202000C
X-Stat-Signature: nkr1xifw454aj96qgxocytthgs1kemdh
X-Rspam-User: 
X-HE-Tag: 1759166847-136973
X-HE-Meta: U2FsdGVkX18c3ubo1TVWr7ERgTZku650MORCWJHpagQMt2dn/hjO8iPR1aJ70apwM1XAg+IVnSI2XaZyR/L/yIL0DZGs9xyOlSh3btgoat0aCwT9dqqycQUKDajoGhkVaab84cPqPZqFmIgqSVG4nHesqZwSbX2bBMd+ikYaqpInI37Ey5xtW2b8tfxFP7HQbdMRmwHqt0Pmyj07chzUT2cTeFRmkO0JCc6+sZpNLfTgFtoPkbrO67Peav19dwplSpWY2CmBAQn8nZ9qsp3xEFIADL3F/uXxFNSFn1qUH+z/Z57KoqYRX5hYrDSp1n/o6NC5274Bqvn5B58JeIetGRywJ4T86DuTXMtOI1aA2U6pL4WzUMWJS7tnTVO4StUcJduT8cY0KXzHJhYDXIekiLKlChR1Vfopm9dCQqGBUIIS502uY/lr+uDNEohlVd9A1kroOpnhUbE2snQtkJsbofbmj5H76lHnRqqxBnN+x3L8mcqwpQ8/T/yRMaX4op8Y1CknnUTaoY/VIPcwuxj4U+Yf330feadaUTl0NjsGdajHqCH9a+voyA0gdre1fIwh0T7Wa4jOH/+niXUzgNtazabSH38DSTyBfNcaZYP4b3RikElliM/Tw1wzNNOygTtGwZxhQpeT6B/HH5AY30VbSbL2kRIqxLT1/3RcFZ5mB/rG0TzRZmNg76ypEXT+CGZ4EhwWM8KEryFx0/Ni92ssxvdu6SYGUIHrzftPbg1LqTj8mVHufo42g3WQgtLrr+rkuoCKrXHubS6zFYRIcIv8V6VuzZqrCd+InfstiMnnsGwDwZXwPMqdVf1xXZMcYWqJYVAGokT/ERvTPUTZwLcKWBJ4AyC8sNJRZ4e5q2wofiAq2zb3cmN84pe/smYj6hAGgr3EHIQhjbgLr1bIf5GY4NcZM74IJaoJAMSSLEy8dzHWBG/Ljl7JgHd/gqNET2TpjUGYbTr+90UoMWI0+ge
 2YA+JIBE
 W6RLlulqKSb5Nv8BQ6rgvo8f9xBXYJuVGDCulsn6NhwtuVmBDKTOTaB04vA0zl9DljMBVP3i4QGMuVVXy94boNcr6JkRDKOX7SEA0hhaL3sbVStgt2b6DCPem6b9IZv6y15nOL0HRXjTESvV9oagfcJfX8CcAsC0t+ph8s10TMyR+GG7sX7xrYAG7oRC+4d1xsdqu8y9W2ND+amxBjfivfqlWOB2UGy2Be+h26WhIqA1ALtHqvUWSojvrt5Tdcy9WA2hzgB3hvwvCN477wfNxPgw7zv+p0x4abYB+3OjynVQRNRIOM9Mos8uIrN/ggSL38vjBDd+tBhDWqiE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Sep 2025 17:24:06 +0530 Sidharth Seela <sidharthseela@gmail.com> wrote:

> Fix warning caused from declaration under a case label. The proper way
> is to declare variable at the beginning of the function. The warning
> came from running clang using LLVM=1; and is as follows:
> --
> -test_cachestat.c:260:3: warning: label followed by a declaration is a C23 extension [-Wc23-extensions]
>   260 |                 char *map = mmap(NULL, filesize, PROT_READ | PROT_WRITE,
>       |
> 
> Signed-off-by: Sidharth Seela <sidharthseela@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

