Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24AD2CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 19:18:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5089C6B0005; Tue, 19 May 2026 15:18:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 492156B0088; Tue, 19 May 2026 15:18:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 380C76B008A; Tue, 19 May 2026 15:18:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 22B496B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:18:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB89C1409A8
	for <linux-mm@kvack.org>; Tue, 19 May 2026 19:18:16 +0000 (UTC)
X-FDA: 84785130192.07.E71E86E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id CFCF0A000C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 19:18:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hdI4EKQ4;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779218295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QWGJVJRpu4bAqcHcaPSNlUoHbdF/hYBtRhQYqpbtMuY=;
	b=tFa0aAv4mlzj9CI2ZYWb+0D/wgPljJglY066zX683NeBDq29K0PKPf0iEGk7oo+Cos3yTe
	LTqOIitlMrPVbqbWk8ew2/lGvWzpzeX0167/iM0TdpbZIaTlAc9V2hB3Z6TE8waPCy3ynd
	My2+HM7jDl8B2aUAwih9KwE4GRyt62E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hdI4EKQ4;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779218295; a=rsa-sha256;
	cv=none;
	b=ivbk9HFCGxwI9DztO3KtspjqDJCrpVk0lRrOrLEl+glWpJu5P62I91C4fYq8v69tPRD71+
	g/PrPGVqW4Jrv51Fis8pZlJsBhiFClTcdcOdSrKLFgapgLyEy2hMcuBkTl9pWgAR3FnShP
	/xlQfXJZVCeJLon777iohcqKfipekzs=
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BC77E431CA;
	Tue, 19 May 2026 19:18:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA191F000E9;
	Tue, 19 May 2026 19:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779218293;
	bh=QWGJVJRpu4bAqcHcaPSNlUoHbdF/hYBtRhQYqpbtMuY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=hdI4EKQ4d12U2VWBzrKOU4ml1ekB0uzdYY8FaH9Xz35aZEIxRs7cmT0w9FawD6rs5
	 EoOy2FQeKMu3tN+QumMxF13K7sr6+bNrcXX1PtjpBsHdKjB2FFs5CBzZFiSNdjEkB+
	 QynTH1LRtv7r5awMlZmrBkIhLKE5wUv9Ev7xll6E=
Date: Tue, 19 May 2026 12:18:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Vineet Agarwal <agarwal.vineet2006@gmail.com>, david@kernel.org,
 ljs@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: check file initialization writes in
 split_huge_page_test
Message-Id: <20260519121813.4b188b21f7280d6e1d9a55e1@linux-foundation.org>
In-Reply-To: <20260519025141.lguv7mrtvqgqpltc@master>
References: <20260512074924.27721-1-agarwal.vineet2006@gmail.com>
	<20260515092211.qkmaxcofxwfdexld@master>
	<20260518163553.447a45c54a3d419b9bb916ca@linux-foundation.org>
	<20260519025141.lguv7mrtvqgqpltc@master>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CFCF0A000C
X-Stat-Signature: 5jx61yfrr19i7dxbienhefri67rk5y4o
X-HE-Tag: 1779218294-529739
X-HE-Meta: U2FsdGVkX1+GhG7AWsIWqhnapL5vTGM63t5MsNxH4Kd2GQW2r0bFblFp8HAKgtrTT4RJsXNxxrIiWiYzdKgiXhsxyvfK4zJ1roH3o4+kmqsaThSLjSr32pa4q7QSJZMveXbJvYbjVApMgBIaTakexEJKiqLpec9QKvXlMJWYKo46t/ChbXLcwEpozjOvDCpLcCAr6gBOKVmZVtBmbSRE7Huh3bpXfSPM9xXLuk6PAYxcg0AKLonPmNHX0q4jZFQEuG4Uv8yKLE2zOXKJtCxb5o/AvqpPtz4ZKnLzITBJtixx41UuUc4J9vn6Z9c9mgeT/Z3sTUAavBSY6OIQ37to59HRKAwLNdkQsJeZi11U88YwleqepndOEFcLhHHoVFPKqFOsi408xeGXSFjZ7kfe9R/ogKyWFMfcJyhzMTGm6psWxL/kXVMo8suAOrQgEHheTxV8Qr+oOhQx4U3w8/oV+cjlh1SCbSJ3NPvxbeNExbNwkM7IsGJA9t+GzJzTsgwhlAeBDOLQhM2UOlOoA8RgBSDIUZ8g/kjCNlZhI+0ojkPaFNO8lVZYA60hkd5A5yke3Q6sP7zwGTmGp66JukvkzX1jI7FBSa190ePpTT3Ee/aAI/Ndcv5iPLkVu5t78FNs68ZNRVuTLqdYd73CE7iKqkcjvIU+5vTBUXN6wAycKclV9FSdLDhWc0kJqdGeu/3k6xqZp0R1W0fUDlfJGFo6vuFG73BWf4neRP1G8/9bQ2Lj/aL51EM/XdTxQNk1+QpgH3TPpgR3Eqf7ncZRJ1N+eDpfSyUGNS/hOEGZHLr3RyrBZ3brSo3HWr5G/SoCSmeoyQPHf69auLR0TnMDQXzeB28o3Fp75tFCmHjT8fkPt6pcnKGC3mSmpFCjEWdfk1HIHLE+Gqi3AOUQ2jmiGmUKIlChIO3XMr2s4zEJs7hB5PPf6xfsoQ0i0qvXj34Uyr4mGGWUc1yGyW0XrhdQiUz
 OBcMMCtE
 kOQIEJvcxUJX3K1itNWRzYqYZbt6IeaJ+RVDt3heTw1TGeQ31Fa5o7V2Zt5W86iRBrhyqqJ8DOTztz5VMlkW/b12ScaVzvgf9h7382+ZfU+uzMRNSIHEpWbHNYNtnwBfeS9JeCV3exaC6EA0xuWZEjqUHrupWlOxipebpcqfREM6Ncz+k7m9z+j1TnZV4RURSe8MlrzczrR2abwx/zPyxo+khI36T3tMYmfeAmF3wgYyTS+KsgtSHEGcZURtW7+BzMTUjnm8vhRvl8U0+a9nYeWih9yUxWGcL3/k6YJJzNGyOZUpCgYCihYXq/G3gRdgwAPgT5g9T+5sV36dkA4VGfXlBzX489ykLzuxj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 May 2026 02:51:41 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:

> >Not understanding - cab you please describe more completely?
> >
> 
> I mean do this below.
> 
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index 460fa1f606fd..f30402ece608 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -469,7 +469,7 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
>         }
>         if (write(*fd, "3", 1) != 1) {
>                 ksft_perror("write to drop_caches");
> -               goto err_out_unlink;
> +               goto err_out_close;
>         }
>         close(*fd);
> 
> On error writing this fd, /proc/sys/vm/drop_caches, we forget to close it.

Oh, OK, that's a buglet.  Please send a formal fix sometime?

