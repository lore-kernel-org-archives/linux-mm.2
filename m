Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED16CF532C0
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 01:28:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6275A6B0005; Mon, 23 Mar 2026 21:28:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FE896B008C; Mon, 23 Mar 2026 21:28:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53C006B0092; Mon, 23 Mar 2026 21:28:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 468546B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:28:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07F7013C51E
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:28:36 +0000 (UTC)
X-FDA: 84579221832.04.2FD7115
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 641E880004
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:28:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mc96LTuH;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774315714; a=rsa-sha256;
	cv=none;
	b=DFZ7f3F8J9eaoy6S6Cjbb/JZrprAHCtCOX4cBMIW1vTGvsgsJ9pJpohliwE0GWRQv6MgTH
	wqd/b8S6KVBGekiWt6+T0JT+Hu3AmVFTExH2fKNihSdDQfxPAbm2zIuv8GUFVweJDhE2IS
	F99tDNfqp+++7cdgnQphkBm4/gFOqhk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774315714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g7Mqu+nsO5MMPVsVYRyYXaVBJoND2XEj4Ohf+4MuoCY=;
	b=lgyoKoEE9bGjzF/3D8e0UYaM2ZmvYVF/evAnj0z16aI0RjC29ImTVIIZALlvhM7h+2ytxZ
	k5ytrMq6RzKjwehta6Kqy87YTQfvRLP35Hz9qprtkXEldLySnisi11QSM+u4g7Gwk9LXnZ
	r0Qtt6/ceYALeWXWIbq/Ksc8l4Zvbhk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mc96LTuH;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8142B437D3
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44BFEC4CEF7;
	Tue, 24 Mar 2026 01:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774315713;
	bh=rmjcFzeTy23pBs/opFIoZZhcY+XCN0OAd5iut4rJ2ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mc96LTuHlsNKdGSIeYbll12sBTSwkK16fnoWSUETZKIphfSwLztwKzwDJ+u8YVf5C
	 CsW357BBv0ftsypLLLD7Pz80UqXSHdhMPeDuVSlbUuYUCrKBTQhUfkalCdMlZLmYpT
	 A8dj7LJ2+9OLtI9TUIH5kcU1MX/Q/TfhHMtj+YSGeLtFnGnEAJgA6hma7zQ/0bjrSF
	 WOoOIAqpXjnEuFhCImriGM3r4I+t5HhRFPvjKkizeBE07AVgreAAGwUDfe4Vmyq5kk
	 5CGVrQ9cDTlOHPijwz3jyqh3C0v2CBttUQT/9/TEoSxzEiFIydgMXBjdZzKvuPphdZ
	 C6SIbJSY3q8Gw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v5 07/10] selftests/damon/_damon_sysfs: support pause file staging
Date: Mon, 23 Mar 2026 18:28:24 -0700
Message-ID: <20260324012825.46899-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260323231538.84452-8-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 641E880004
X-Stat-Signature: s7zxxpg1gmjpphd1ic41xy9s7ktycd3q
X-HE-Tag: 1774315714-837346
X-HE-Meta: U2FsdGVkX19t6V7SurunGsxvD2YQ9YY0nfIMJFV04mEAhpXNr8CfhVDkLyzAyoWluHj1tEX+ugEVJoUvh9l/OAV/52h5rHBxskK+VBlH4qOJ2mLAN6rJq+cHYQD+yEAnh15NTyHk6sdvCBiHKhbsbZfdV70agrAqMYIU0HYSGvgr8VLCee6fYOqeluIyNeqjKNrIueQrygY1yRy3WXw37/TY8c3O3D6h38UHCEe/xG+AtzWnaw454EwEu80UqAJtmxJOO46fnAYPjkjzt30zmpqy/F2c0CEtrl/nkZGbwmFTOljB3myulwnLf9Ac/GEaEhBXKBtJioTyxWhH4ooms4Yk1Vle/FwnuwARZBzjc7n2JRcrTjECiVpIqS43WIUU/rY4cT3kKTsJzGufGW/wkSP1lAGKrWVL96+fmi1UFRFguca9/DpTrIxNo8GHJ+1H39yVmK1CyVfSYgwQCCYTxmy8EzHfClVSDng1YnwMwAYdExfiLskJ1r85qW121NMWFQaxh7BSuhQpXJd1Dk7+46nPsJPURCbqvPFatY37l48TXKfvjllu25F3lxoFmoD3zcVmt7oarVjWg8Awur9egN3Z6VZT4Y5/Pf6Ocb8s4Xlt+aU/DfcuTbCC3rfB09fxHTIBLrLNVsiKY/0IUXLuiX3TR4gjqj/kwApajDZPNrCYjeKeyyDmTHdEEEuKkmSlfG28tp6FOOqX6gGKDxHUAHpHOfcDYjCQ0mF+w+UP6gHHxNTlFJfEqv05zGvvbYaaOhFBBwuthzYG/+fRjwS/B3XBsqDhJVot7c8+cLNmM3/m8aZQkPFVVmT/hvjVyM1QGjzG9eTTw6xigqcjgz0VQ3Hz2lWpnEPJBGxT2vqh2TRzBcX6bT8Ftvz7z8KIsrrP1SqeCRwrK5NNeAIJI6QXXjfdeO8TwCb8euRhBicdvOC8iFfHKBhfv/XjNCfkBtMJrTNOXg3/OQLT5Z261Ak
 s9hg2iR0
 pIfIF1OALMatTsol50ldRDIEVyh6Uwi/fw0+sUCcqVLBqCOHMcAUfh3n+fBNOHkWnMMSfamf34IkEVpRoVnWxS7YreX1gYi+e1w8rzsXDf73AARuUQ/TqmiHlVr4Q0APUP8IMj077iANXp63KwqW6eQuO9R/6ekYhTXniEBiOLWkDkJOCRfvgVru27KfA2H1XM29VhAslBM1OEpB5wiJYfDGWz5Z+1szd6nChJhInq5blzyi3Wx8GYvQZvsQr93xld29V+PsuaCKJmKDvf+hRHPcCPvPmtRVvozKivA9Fze0iPALhX3dXRGdnWGRLG7v19XKxg/Ny3GGBWY1Phol94C/L8Hk+RsRd8hnoAlOuNcPiZ+Lpyy8IFEb8dafE+PkVm7yIfYX3zbti22Za1m3QVhll5SRmaNlD0jOTVq5ekm8067Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260323231538.84452-8-sj@kernel.org
# start of sashiko.dev inline review
commit d9ca6c4a33fc4d613982730edda6f4b67ae30a67
Author: SeongJae Park <sj@kernel.org>
selftests/damon/_damon_sysfs: support pause file staging

This commit adds support for the newly added pause file to the DAMON
test-purpose sysfs interface control Python module.

> diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
> --- a/tools/testing/selftests/damon/_damon_sysfs.py
> +++ b/tools/testing/selftests/damon/_damon_sysfs.py
[ ... ]
>  class DamonCtx:
>      targets = None
>      schemes = None
>      kdamond = None
> +    pause = None
>      idx = None
>  
>      def __init__(self, ops='paddr', monitoring_attrs=DamonAttrs(), targets=[],
> -            schemes=[]):
> +            schemes=[], pause=False):

This isn't a bug introduced by this patch, but since the function signature
is being modified here, is it a good time to address the mutable default
arguments?

In Python, default arguments are evaluated exactly once at function
definition time. This means any instances of DamonCtx created without
explicitly providing targets, schemes, or monitoring_attrs will share
the same list structures and DamonAttrs instance in memory.

For example, self.monitoring_attrs.context = self overwrites the context
attribute of the shared DamonAttrs object for all default contexts.

Would it be better to change these defaults to None and instantiate them
within the method body to avoid unexpected state sharing across instances?

>          self.ops = ops
>          self.monitoring_attrs = monitoring_attrs
>          self.monitoring_attrs.context = self

# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260323231538.84452-8-sj@kernel.org
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260323231538.84452-8-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

