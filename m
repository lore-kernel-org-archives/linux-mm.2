Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 124CFC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 19:36:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3D036B00A6; Tue, 30 Jun 2026 15:36:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DED1F6B00A8; Tue, 30 Jun 2026 15:36:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D04786B00AB; Tue, 30 Jun 2026 15:36:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A2FC26B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:36:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2C07912061F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:36:18 +0000 (UTC)
X-FDA: 84937585236.05.457EA4A
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7DDAFA0002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:36:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=cDIB8Hdr;
	spf=pass (imf25.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782848176;
	b=TP8hnat47nOJuzB8vMyG0GwaGIEkeK89+c2YmJSS3MP0tAFlxTp3KSrgFl69FfgpJ4G4TO
	03FqbEW1gTKrFZDjsuiNtFW9yWvEhXxC6mtZ+K28hx4NuDFLd3v4eYLgGKSsjoaG+kdGrA
	Qc5v9pE1Cdr84uk//JWl/lJCeedT3iA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782848176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yPCrY1FcI3FpRnGc5ZKuI5vFumDsIEQAM9UCUyL0JHM=;
	b=Z4JBbWlg9sOsrZyRi9RPPWxTrUlpllf4OcYCM1jcYfeD8uX6yi52EW4W08JswxceRr1EPw
	NvXTTQe86hHPXjqrc47lCRqlPzZvUHOaYrM4Bn3L6OKFDoT/JY+lUMWXgUGsnd4CcmJ7eS
	8kaAfcBjoJ9OIByqIS2FbXXFN6k0PWs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=cDIB8Hdr;
	spf=pass (imf25.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net ED75041596
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1782848175; bh=yPCrY1FcI3FpRnGc5ZKuI5vFumDsIEQAM9UCUyL0JHM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=cDIB8HdrQQO0PnAQrr/CcS5aY1q1hcRwSwGYArUPiB8hYF71oZUORebnSB8sa49hW
	 u2ePanYOpizDPfSjM0ogctLfxGGRJKlqGrrCosXoq4T4k/dA9BAfwZZFEYYY8LGjmQ
	 n84eVkBksILKrf2NAwrB3adKDEXXI1KsI1BWCs/fcxBe7nJZExha/ZPMmrHee2knwP
	 EqRq+U/5l+s764TFix2MY88hcoMXFx+pGYEzr6eptSn9fIVjziNReylaS33tGkIy3R
	 RIK4EcEIeRNmI80bjL58BsMHZAdLCUml3gWIbJfV88Trh2GFt0DPhpaOcanlpnuUJ7
	 ebG660lInR1SQ==
Received: from localhost (unknown [IPv6:2601:280:4600:27b::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id ED75041596;
	Tue, 30 Jun 2026 19:36:14 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, skhan@linuxfoundation.org, sj@kernel.org, Zenghui Yu
 <zenghui.yu@linux.dev>
Subject: Re: [PATCH v2] docs: pagemap: fix flags location, member name and
 sample code
In-Reply-To: <20260626162710.25844-1-zenghui.yu@linux.dev>
References: <20260626162710.25844-1-zenghui.yu@linux.dev>
Date: Tue, 30 Jun 2026 13:36:14 -0600
Message-ID: <871pdnstw1.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7DDAFA0002
X-Stat-Signature: 5wfk657qnw4mokg95mpj7sp3i4uk9rhq
X-HE-Tag: 1782848176-983518
X-HE-Meta: U2FsdGVkX18ZVCgfwHEXvFG39tL4SzOdwNPYJHjKI0q7Vc8W4/jb2mJCHnPDRGOI31aqVEJiy8S66TtwLU7hH+xlJe2nh4tePlnMQYXzxO1PgGmiPSMRTohqJvRHoj31jot+FoVCU/Bq+MAX7dYFW0+V5NlDv8wkg+Yl1ySLKspmTCGgSZhtglCxt8P9mqzLgcdEbJP7JIryeDX8v8IWebHRBwMfeKTKT3DvM8E+vB7GhACAy2uv26sXis3XBrb0tcFmBHLoY81IadGcb8OVhmpcooSs0KEjApAHZJfh3kFkDInktNYoQAN094njMNjXpWr11ElDfOMqhVxNvcxQ5DPJXXhvaAQ7Q03Lvaqu7/bsxeTKS47ZlWfbeI9Jz4M3iH9E7U/F8BTUXAHkbWg1Ts1ASr75911C0nB2CHSckragH7cAj0ghFZ0L3maVh+56U15VuNRrYpOOeShon9KXfSCx6fqtX41DLUORqyFntS3PYmzQhfapEjDeTg5/5OVjcfeIyAGtPymsUWBnsNDA/VPZ7DPW/UXh1bGhyAwJgBcqE78Q3qcsNI7WwQm68cn6pZGwZlfU+EkB30KGUJluEp2sHHw8IRv/vDMtNxb4E0AP7zDl6lmbOupAnHD1uIpofO18NXiOTeGHgKbDFzkrEuhh3VquJvIjYxwloumrhtmmzfHH5eitSvRloTDwz9QBDphnP2Tg2QMBLChtQE4iS8mFGacf1/t3cpStDkBKMqphaWcf7fq+wy1+Wghmw/UTYKuPYszT7BipXgbjM4o4ltO0Bab1MKp/YtjzibPyUsjYpiH2O5DOxsRKgaxf8jVoPqzsb29zy3sqcvMF04vijh2O+6ERq0FmTpQ2M1Sfx8kthNmHg36UYl2LE1GYK+Xi9HOqulgO3EZSF9KJpCIJXnbORctzh/4FtPsHadN+vaIYTUJsTm3egd5iuqM1CLNjJJmMP+msIONYZY/uBgW
 M4jZSCoT
 vgBWYtXnsQ7+il5gKmQ8+55Szr+FeXebg45J/0vEMknPNu2XdO4KwnK7d7lpgoGhGqxesaL+sVOLjOrm0ML7wVHwsqMzdhQ7sSabmMx7hrfx5B9STTiqKRPLfmTxbp6rh90Ng2siayBkuX986X10NHvUkadBpGfhZZoL0CMRhvnoYIVyUokWmNuOQwduzOXi8g+6RZjXyf87c46qiItjGm2PnhuvtYWrFoi7p42DEeSla/eW0KvahnygzFEfBrU/pasvNj4Ji6BlJMF9m7Df8ip/5kRf3oicAU/Ld6NfzSxn16DzbpUWse2dOwm8kUDDrzKGnn1i/6Qc8qOtJ549s+pUPCLdBVOX2UE0/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Zenghui Yu <zenghui.yu@linux.dev> writes:

> The userland visible page flags (KPF_*) were initially moved to
> include/linux/kernel-page-flags.h in commit 1a9b5b7fe0c5 ("mm: export
> stable page flags"), and later moved to
> include/uapi/linux/kernel-page-flags.h in commit 607ca46e97a1 ("UAPI:
> (Scripted) Disintegrate include/linux").  Update the doc to reflect the
> current location of these flags.
>
> The member @walk_end of struct pm_scan_arg {} was wrongly written as
> "end_walk".
>
> The first sample code of the PAGEMAP_SCAN ioctl wrongly used the
> PM_SCAN_CHECK_WPASYNC flag twice, instead of the PM_SCAN_WP_MATCHING flag.
> The second one included the wrong category in the required mask -
> PAGE_IS_FILE should be used instead of PAGE_IS_SWAPPED as per the
> intention.
>
> Fix them all together.
>
> Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>
> ---
>
> * From v1 [1]:
>   - drop PAGE_IS_SWAPPED in .category_mask (David)
>   - fix typo in commit message (David)
>   - didn't collect SeongJae's R-b (as the content has changed anyway) but
>     thank you for that!
>
> [1] https://lore.kernel.org/20260625174447.24292-1-zenghui.yu@linux.dev
>
>  Documentation/admin-guide/mm/pagemap.rst | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Applied, thanks.

jon

