Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00D34C5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 03:26:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3B796B013F; Mon, 17 Aug 2026 23:26:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEC676B0141; Mon, 17 Aug 2026 23:26:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB4266B0140; Mon, 17 Aug 2026 23:26:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A7106B0139
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 23:26:49 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 11A28140A58
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:26:49 +0000 (UTC)
X-FDA: 85112953338.18.91460C8
Received: from mta1.migadu.com (out-113.mta1.migadu.com [95.215.58.113])
	by imf17.hostedemail.com (Postfix) with ESMTP id A0E6A40005
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:26:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WkLkdP02;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.113 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787023607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EKEnWk4DvIf134y7xynqDH3no2IBhxVaxS/jANfdf9A=;
	b=F/Xfn9DwVRMuvFUMj8nqXrcqWnJdfpQBKkf/2GlOtWUf3/H9zVmM22fUo/lBL+EC2tLWcV
	6rRW96nT804zLjDd0qOqHIJWtbJJbSRdhkcwN8AmpoGuAzpElHoY4pIqkLtThEH0QQUJnV
	JKsV7F/NWWIirtwJ0tw58uJ9L10PI28=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WkLkdP02;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.113 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787023607;
	b=7pTxmOpyEfTWsz4Q6Xa55cFW6HCxsPw/ZfzSyFyQYXfOkWc6LP/GPYCxc/Ca8imc+LV06P
	6UGkPIJw+HoUum/ngf02UMHaLfji/YLvC7V5T5aTQT7ACmOjw6bEmAWG/9gkiTQtVVVNEt
	DNcyhurLSvsdtq97o5+0aznnpF4FBj8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=EKEnWk4DvIf134y7xynqDH3no2IBhxVaxS/jANfdf9A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787023603; v=1; x=1787628403;
 b=WkLkdP02YxyYRVDre4vNyIUPDyCFr2M/zXKgmX1jZIw1xNGar3y+9QrRJCIcre20jQQY7n3z
 pQtWo/fmK9nsK5/PFjO9BAZ5G7IctiRWN0YTzPafD3FSdbrRFkYFwjqM4wf1Wv3nQ4KFGNDUaEu
 m4IES8jYo2NWOCUzZkp3nsgY=
X-Envelope-To: linux-mm@kvack.org
Received: from smtpclient.apple (114.251.196.106)
	by mta12.migadu.com with ESMTPS id b1cba1aab682bf34;
	Tue, 18 Aug 2026 03:26:33 +0000
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 1/1] mm/hugetlb: do not dissolve gigantic pages without
 runtime support
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260817162039.1511838-1-xialonglong2025@163.com>
Date: Tue, 18 Aug 2026 11:26:19 +0800
Cc: osalvador@suse.de,
 akpm@linux-foundation.org,
 david@kernel.org,
 mike.kravetz@oracle.com,
 mhocko@suse.com,
 linmiaohe@huawei.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Longlong Xia <xialonglong@kylinos.cn>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B299B9C7-9592-4197-98A8-A49B1FFB3EAA@linux.dev>
References: <20260817162039.1511838-1-xialonglong2025@163.com>
To: Longlong Xia <xialonglong2025@163.com>
X-Mailer: Apple Mail (2.3864.600.51.1.1)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A0E6A40005
X-Stat-Signature: wjx6nziyedgsdmuj7gfzajn7goddfqxa
X-Rspam-User: 
X-HE-Tag: 1787023605-463740
X-HE-Meta: U2FsdGVkX1/dQbumusckwvZxcKPaH8viM3wzem8DlW2ALNdrmDVFFrXUb+fcdMw7lRsAiy3k+VXIUfYKBwmTZtQUQLN5z124xfHXk5vgTLrvw0tBb07/IC2oE0leNR+YOxpWz3H6CUqxoMlCJFtB3ufC34YU3zwX/1S6BlU/o4hj0aA9HAxxnGmki7mRfcrOgaOXF7fHq5fD0bd4JFD4pyoDQxxMC+CwWtncsRfvjtyODC8c6HEy1ChRRBXAqR6c6tStyNZhdNhZVDg96XrS5Q7N+6j846GrTDmH0nZ2AXedoFO6xXl2RYvMCiBI44C51OCIWzdEag6UZvixI3YRvAhCdvMigZ4iyk+UuxHeqkmmbEL052ckdZu6dli3YEyDy/LPbFQmo30OshuB6U1iXGUyhreukhRChWBb503kmfhIYKMrO/L61GeR7Z55WYJAn6zwhhuw0Lg+N+CDMoPcUX9X8Bk4XosGZuIUob4XsS3xceeIv1304FDPH4KzhDXQxy6IUrFw5L1NEzGlYTLWThKhwJRDM7bqLLYa9VHZ+4Qrc9bG3mo+0qETJ/2CVHY2PfBnmmw0N5nx6i0ydH646RG/S6LioaruP/pztxNZG2ekUHqdpuhUlf37No4e0NjVPP0wfG6/fIPrC6jx1CxWjpqHfjrfSLIczevHisXRF0GZ1RWFPOR2NUXI9bg3m+2o3FtuOCwonbANZyW+XxHcLjxep6Aenp+M1gNqUuRe8r6UP5GP9uz7IUp1+yT8Db9+NwcCMhYiorMbUmNE6tnC+OCOaLuyX3lLg0APHtKwF7JUhKny6RAIQ8Z2Dowr8sQUDFu2nUlZXtN5+I1nRc/lk0/6WITwnAqtqH8vzgeqyiOVHBXtj5bml8cwFKn7IoZjR3a9GoOI+R6mBvU2ODZwJCbtCtlBnkfZgDi5ydmeiJPsl1U6+qnkExKdlpoA3m2EbeHAbZXycjk8GaQLUI1
 NYXLHSnx
 ah5/oz3RQJehDRDtqCWgbY0sXCm5gJvdqWHy+O29ozcjoKBB/zVgpLMOIjgFF5MXH+zdlt3FUm0pIsNHh5BNxFKc5ADpOdrzMngWCX9FY13fA3kAsOylT1el5QDzQdT7h1doUhuC4ZVjvhHga9JJK1dGtEODkyywLLHU/PJSgLJpXbJsAaJzvdDj/IlGdJtd4JCxTMK2xBQRHHJsWRjD3Jlo3j6oPRaVmrIL77Kd8NIq/ClzmB3UTIIsS/xnktjR6pltYycJmW7a9JRwI02Nv54c9kwNKAiHn708rqCvnfYxdwKgWYf7tA6r/bJ5VjR+tjXvLosbkEq8K+I7Z5IFE//xMcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 18, 2026, at 00:20, Longlong Xia <xialonglong2025@163.com> =
wrote:
>=20
> From: Longlong Xia <xialonglong@kylinos.cn>
>=20
> dissolve_free_hugetlb_folio() doesn't check =
hstate_is_gigantic_no_runtime(h)
> though remove_hugetlb_folio()/update_and_free_hugetlb_folio() silently
> bail for such folios, so it frees a still-listed folio and, on vmemmap
> restore failure, the add_hugetlb_folio() rollback corrupts the free
> list.
>=20
> Link: =
https://sashiko.dev/#/patchset/20260814083027.1419487-1-xialonglong2025@16=
3.com
> Fixes: 6eb4e88a6d27 ("hugetlb: create remove_hugetlb_page() to =
separate functionality")
> Assisted-by: Codex:gpt-5.6-sol
> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


