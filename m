Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D52FC61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 18:53:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 722786B0088; Fri, 28 Aug 2026 14:53:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D36A6B008A; Fri, 28 Aug 2026 14:53:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EA136B008C; Fri, 28 Aug 2026 14:53:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 36BED6B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:53:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C2D16160538
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:53:39 +0000 (UTC)
X-FDA: 85151576958.29.B77F49F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1B5EA120006
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:53:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Z0hlIj1m;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787943218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B9mdNfhFcUO2gJ0ktoY/zaGQbPahFjeEg5bz/X1VOZA=;
	b=OZ4JeAJkDnqJtxMh5FsHb2JHg3eXutxw/ZvGJvGEHaCxtSzC1O/vG0xHNiti8sj3RpKt3y
	jcDqtPIcyNuL+BabkaS/V/TfS4z+dtM3T6V6/jjMrhpKW/j9OmmNSBT/pqKDGA3x/gslBU
	W9IPxgi1O1BKTHDUNLcROSb8VXrhu+0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Z0hlIj1m;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787943218;
	b=2/B7ov0luwmt89PcY8o0p/kYKRl9IRX8OpjfvIfzu1y0N1RAJ38ATCsJ0Qb+BIUtPoeM0i
	Xi+Grox6VPhfU/n3MAQS4QLMsTXW2yQ+VFFTR8uwAkNeqvXlsK/0ccOBo5q2KGMsDPuy1K
	Q+uvn8BBxi1cmH0pcJpS7ScBJbhOrcI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6931260052;
	Fri, 28 Aug 2026 18:53:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA4F1F000E9;
	Fri, 28 Aug 2026 18:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787943217;
	bh=B9mdNfhFcUO2gJ0ktoY/zaGQbPahFjeEg5bz/X1VOZA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Z0hlIj1mp6THUJEgNkV5IGHjWaaFGD20ZZqph4GrZV16OoVYRFjB42P09sbRzr6tC
	 mGilmF6zeByyib7ZNL7MlsbQ7Ib2e7S8pM6l2c6XPq+rprEpRwNg72OqVKKEE5qSS9
	 g536fmH75N3r0a608t+GaPafLgU3nv8hP28sIFbE=
Date: Fri, 28 Aug 2026 11:53:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 Tejun Heo <tj@kernel.org>, =?ISO-8859-1?Q?"Michal_Koutn=FD"?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] selftests/cgroup: fixes for test_zswap on single
 core VM
Message-Id: <20260828115336.6ef439268af56dce797d2aba@linux-foundation.org>
In-Reply-To: <20260828033741.2184560-1-wfelipe@google.com>
References: <20260828033741.2184560-1-wfelipe@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ciixk6ynszn8qitniaa5nzb81apf38r6
X-Rspamd-Queue-Id: 1B5EA120006
X-HE-Tag: 1787943217-397312
X-HE-Meta: U2FsdGVkX19+vI+uZVnDFmxODPppiCGmafxATz4fLPSNNh5c2dlhLGgvrQBzRJmKb4DLD0wnnDsouPo1zbyMJjrBFN3Excy3yCfLey/l8T7tH0gRl0k6hPhfG1jdCNeANpqLsOEr2kbWw8rDhpHo2KhLQzpkwk5aVMrMFmerBzDmpbch3uQ30Q6sPDe3p6FVmXsAIr+3NmCRLVAhZu1ZYkH96m5pwWTJgx67OwStQ/bkU1cfjBT9zzQiCo4tIFNo5MopV7u8iLKAjA5VLXZSxIeS41J/5HRi/qO0kJhsokFfuYSdG+3MlynDbrDHI2/8B/RpIk3VV7iAnjyLscwBDtFf8yN4IkxivjP9cIW5PLYDk7RUoVRy90aWJTOzo3jhCEpHfEsiJOwvREDhhd9JHEowG5EfSvVUXW+hLJRhWlq2FJpDGQ6sg87xOMvXnuoU0sBK6FKQoitgJhXuOB0ROfg6h2X4Qqbr8fehQ+KZ7n/MeDjeZScf3vy1YSP/svIsrzgEyEpwJj2jMNzGoTGwmBocPuC0Kor9kkJyhWLCyQ0jPEmado3TlhYKvXng31CSA+2gibDlRywW32FNGKUHuG4vzvewW9juuuCAEg1JuM1QD34+zlhdfnGwvhbXHbUf8LM7gmk5u7Qnr58NWwu/hTiFllsSCII5SJizERk9VsuiSHRUfdavnCp3PI2j0QRbO+jiIbcRZMkfKnq6V/q/zvCZ/9bAdzlZMVIGSaa51Gpr9iQXBN4DK2Gqu5yLCiPC1fPo19iCbffxlMEL0R6jzaGxWSeHJwvWbp5haBMToOLnpj1BGghVz6TSFBkCLd7e+LcjtS91MURXLlKdfRbPNvalErlPhNsqfkbX7BhNCfiJex7VVuYkjWxlBQwyxtkg+Apx9HtjlEVVbpkdhWf5w7JKdLrh7r94MNqRDfuYzjFO53V3S2JhTo8bcYldZ3g7PnVD/enONy6ehPhf4Lo
 QZSTb4NA
 mD9b/178urnFzY7KX3m8ibe8V59TI8ihbLZh4V8v0mgKthgq0L/dPvgHuETI4LKvGFhYw271WoxmOlb8rxhFB/RQniEuC/e1suNtH6N6sb/PMc5cDDIIePD8w4Y2ImWLfNe34PgwipxYke+sXRGNpQhh4nGI65pR0sW60LpmiosxGzHaeed3SZ5uRIuvpAERizOskaBkMYrXePktMfGvZ3ECp2ylkv2ejlAu3SObTih+0rBwG4ZQzZBG8fdHjEjQXbJF0pFzlbXVBNYHl0KJXQi8s72IC+/TUH+gHZO6VE95uJs5kahHpVKaNrusCsiktkfkGBiqkPzdkXplOdJgUzeeclezgHa5ey4wArN8beiufpIdNL33tNgsbbRRrB5NOjCIa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 03:37:30 +0000 Wilson Felipe Pereira <wfelipe@google.com> wrote:

> This series fixes two test failures in test_zswap observed when running on
> a single-core VM (-smp 1) with 4GB of RAM.

Thanks, let me queue this for test and additional review.

There might be an issue on 32-bit:
	https://sashiko.dev/#/patchset/20260828033741.2184560-1-wfelipe@google.com

