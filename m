Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDDD7FC72A9
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 16:18:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 334F26B00A9; Sun, 22 Mar 2026 12:18:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E5726B00AA; Sun, 22 Mar 2026 12:18:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 222736B00B1; Sun, 22 Mar 2026 12:18:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0F4276B00A9
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 12:18:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 99CE2C26D6
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 16:18:55 +0000 (UTC)
X-FDA: 84574207830.23.27F0611
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id E08ADC000C
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 16:18:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="fLv/fglc";
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774196334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XbGgdAUD36VbkTI/d8NS+jT1HFTeOWKO8Rd1frjT90s=;
	b=Q/e8WrGd9FI22YpWKxcoF1TD1VEhvBm0afEpDizBTaOaBzAjX6Byr0YjU4ZbfvLw9VcjAs
	s3LcRSyySlhrue1Gc4vK9urG4sIs95fO1H8VY7WnoMaiqP5ffJAfDOCtgpUZ7Jgr7l9tRH
	r7qLukfmd0/cR8EfEes/7qIjqjTr5Zs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="fLv/fglc";
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774196334; a=rsa-sha256;
	cv=none;
	b=V+2WsR54zbPhI9j5iuOcjdj+/t/Sl2lJL+aqTiovfB6sPyTbO4bI73QBatD64Nm0DuRY5f
	G0D6se1p1qFQTGEQlr3Yhrn+eXeCJdgrDds2kL2efAweHhSZnR9zJXbGBRMfmohSZVCROv
	t6MOIo3tpNjL/MXEZBi8ofwyXMwFmOA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E45DF40537;
	Sun, 22 Mar 2026 16:18:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A1AC19424;
	Sun, 22 Mar 2026 16:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774196332;
	bh=pP5uNcSCgG45MH4/HYNrgZLlyFOBkKviWCQd4I+JIkE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fLv/fglctIByfcRHnORg/XrxwdIv0B/kVJnimOKezsybG+/3MrwU937EbpZ3tijLv
	 AyMmCWWqOc7/dvDj0XN/Vg4lom/rQRMQ4xBMhtNDWNcW5MFQOHmBLPk8yClDDSL1K+
	 X/2WfOlQJvR5TRZuCJizMs3MfxHsnT5HlmX87yaQ=
Date: Sun, 22 Mar 2026 09:18:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Wang <liwang@redhat.com>
Cc: yosry@kernel.org, yosryahmed@google.com, nphamcs@gmail.com,
 hannes@cmpxchg.org, mhocko@kernel.org, mkoutny@suse.com,
 muchun.song@linux.dev, tj@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, longman@redhat.com,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v4 0/7] selftests/cgroup: improve zswap tests robustness
 and support large page sizes
Message-Id: <20260322091851.e965d3a2f0d6af5bd985407f@linux-foundation.org>
In-Reply-To: <20260322061038.156146-1-liwang@redhat.com>
References: <20260322061038.156146-1-liwang@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E08ADC000C
X-Rspamd-Server: rspam08
X-Stat-Signature: ac5mx8qaeomd6mhmiutd74ww5pjyqa8a
X-HE-Tag: 1774196333-166394
X-HE-Meta: U2FsdGVkX18O6n2d9MnaMh7Ga6go+ocdD8jpHTgqfbCJ+5dWXVh3OBXrMlIm+5Yd7rPptMyD/HwxJMYAN+gmfd97X5KAlUmIL504IziqAez/fZQZih9SQ8bsVsJ9afkOaIt19+Sz7z2CBU/S6N94NiIAo+osYyuKQTEfBPuGm1QP4lO57Wb/9oTSSrTvZjKVZUxoj1G2YZxB4++1BIMHEkJ7CUJj77pb6rAVEdjhwN5gnWFV7XDwMHxuYydNdhKZWIBI3nq3YbWlAPKHDfaARMg7KtfDv2xCFVL/9HBwyf68j32HtseYUpBhf0QBDIagf8CJldbR5BXR+5i/tUclT5HEszdw9dGMwPeLQvY7kBea8b0+qIFFFXIxYZdiBUGTfcRL+n4ul27MxN7hlsMzJyu1F8gShayPjqDocJVMquQ3qjPnRmslrpR8r95L2Xha9JudLGydKX5+gM8zAr+mdYKzv4giQ1UXy6AsW1k5q61+v5usy9z0J0ScJylBE0pizKHizLytDGYWzf+eWTNNxQ/R4n/aYxOOBC26agz/aNoXPDiFvkS8QX+8m8LPxgHAd1omT2MYND6mZqjkFh9sTJTmXci1SfJzQZeJ2I7R2MsItTNp22gGGW05IUEfd4VYCqpFPn/8mcVsDJBycT8oPCO8SFwDWCyB7AmVvm/Wl4FjqY3rNiUvWbd7ezUP5AUjqt3putNNLrE4hjpjR2z1nzVUIZiq7a/L59xQ9UGa4iHdYQohmcm0Pd6PAyQmAZ59WdTJ1r5tzT+iTig/rlDNVrwNOPgyRKazMvC0yBUSiN7aVGux6md9jnyTcZHt25UDOH54anyq/VSmM6h02j+dDa1m+OrH+09l9xha0jhJgfsWzNcwCIjBiWeLXZ3uBeepXFYSxYMMfOZSiYt/Vvn0hQJeOBVT7NEH7LPtKML9daP8cJ3Wej+VklMw1XEekcVnlo0pRRhO4ezh8o6/2Sk
 gJf66TjT
 3spyWToIHoqYXIZdDvo8w+xRsuJuMUjeV8hR8Dgpb1QOgeuqpsVkvn49cVdVoUXWi819AzipMPQBng4iu2yy1AOhhSaQgpLEl5httQgmg9rtHCjvZJPDjp1JQ0OQgfyKSoDNqjRmUkxYd2RmGpUQb/BL1o3Kzj73mQ9onxt1QUT7saNiwmHMRo+5V4jIWd8xsUUYZjhX1yMT/fYWIMRD95p5y7tPMtGLz/93aaisA74+4cb73wCwn5UFUNZJyK6MI4utoXU57rdCNpeDDWTh+Jutihc2yaKQIKelwe1cyNQxLm9hf82v8jwmiCt1BlhUUQQp7NBe7hMknmKpu1YQIrYsBt6rc6q7oAXUSAnxP+/3C7pFtWKqkOkv0KDnzWcslNO0E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 22 Mar 2026 14:10:31 +0800 Li Wang <liwang@redhat.com> wrote:

> This patchset aims to fix various spurious failures and improve the overall
> robustness of the cgroup zswap selftests.

AI review has questions:
	https://sashiko.dev/#/patchset/20260322061038.156146-1-liwang@redhat.com

