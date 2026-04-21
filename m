Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09D05F8924D
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 10:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FC606B008A; Tue, 21 Apr 2026 06:25:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D9CE6B008C; Tue, 21 Apr 2026 06:25:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 310626B0092; Tue, 21 Apr 2026 06:25:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21DF06B008A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:25:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3EDDBDB85
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:25:00 +0000 (UTC)
X-FDA: 84682179960.29.5706475
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 23F03140003
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:24:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HCemAdsh;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776767099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VXZpyDtX9d/kueOfhaeSDpVbnDg1k8zMD8iFb/+pE9U=;
	b=Dbsnst2obGibTxnMC46/zmrKLgd9dpNczRMwdSQbqa5WWSIlAY0HgM6r8eW9R+JzMzvSuL
	Nzt86+FAj4IPPuBPfz0Fp/qpNSBqJ2DgWKyZy1Udzix/AsCQHsXkJKcHoJR+xGXHhDnfN/
	3QhbDSwa0x6WzEjK5VWtKTJJneQvZUQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HCemAdsh;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776767099; a=rsa-sha256;
	cv=none;
	b=gxPHrA6m1HzQAtvK0yn1/KZmsvgkZMH4oE1caFqsg2T81JSZoPsnVMYzN6jZQS/DqqAasB
	79NKLaZIDmlS72zF6gGb6Q0C1OebkVhUsWGsCKIRFIyaePerWpE0ryUSGjiBZF7x7XNQky
	oOqnqz/ziWh4Xl67/a2k+gF0+CV+0bw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B9B7B43E3B;
	Tue, 21 Apr 2026 10:24:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5223FC2BCB0;
	Tue, 21 Apr 2026 10:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776767097;
	bh=firh9QIDguLTG6wgrGZbOOkBiLIhh3fjZnBwKL1kIv0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HCemAdshi4KHRisPS/RvA4gQfws3j/RpyxXKUV0Yegibkt/idynoXy6hFSxswaKj4
	 yIPog4pFxpsumS1Dzkt0wk2UNZa2ovd/UR1Lta1s4Hedl9r3tkfTF41yQbgCqmU0DZ
	 BGeA3mT3tF8ULSg2K01WZXOvDNheI+LpdNFt76wb5SEezuZck8GApCkjA9i5gxuNkV
	 Txlk3Yu9CkOA0rBQPV1OWF5pzbXtA2abcQYSE3FbOx+aJP4Q619/M6hlqrYxA78/t2
	 PqaRG6eFDhwal6MZKLRSf4F8WNAMknUFX7PgbzwdyLlndysLpFhheB+hn/2TTgwdaU
	 LTqt+RVzihJ5A==
Date: Tue, 21 Apr 2026 13:24:51 +0300
From: Mike Rapoport <rppt@kernel.org>
To: luca.boccassi@gmail.com
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com,
	pasha.tatashin@soleen.com, pratyush@kernel.org, brauner@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 1/6] liveupdate: reject
 LIVEUPDATE_IOCTL_CREATE_SESSION with invalid name length
Message-ID: <aedQc4djj8VvL9xv@kernel.org>
References: <20260420141741.2688371-1-luca.boccassi@gmail.com>
 <20260420141741.2688371-2-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420141741.2688371-2-luca.boccassi@gmail.com>
X-Stat-Signature: 4ky7otpb3ye6yqjho1jt1xfmga3fizjb
X-Rspamd-Queue-Id: 23F03140003
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776767098-177202
X-HE-Meta: U2FsdGVkX1/Ri+aWH10hD4UIMQOACrX/kvHcpASUYe6weITNS3829l2f3yMDBOmzz56qtk/GltocbjzxTtFCCqc7HuDpJTEl1YdgOqfSf/oG5bVVRFeY0kUThOgw1kiav1t7q+1mOxxClCwR0Pknktw3MD5Q3DNGJClNV71YqdFlamNwZ/EyoyR1y75/1BS/mAoQi4SG3bzM0G2jNF8b7BszXmd6hcCCB3I5geQIaGhl4hN7fDaIISAXBUQk0/AS6CuUNLPuS9gQFWIIyTAiNAw6HK7FlpGqGK5o4rRiPkZmf2Ro4wphJe3U7qGTxaYQAZaPcmZexxYr+UGZUE+X931dwdMWqKlYcZwXosaZSUjVznEpxDkrV5bMDfNyggGh7JcSVmpevM3uVvxjyxLWzqBqGTqVBZlfwMKdnO3fFbSewbszHxX6T3gpqEBc/wSGUbkpwzNfWfdaJbBhmBVN7WUUpMbgZKlFtoAW4mYyG5Vjg/wYJcapI676nkGDBjwcIQHhRqK+tm1tiBVpAx3Wp/Nwe9bK0EgM5FbHo9/mtzlaxdRUbSg60V4/XI4GBqjRlpCJFHUwh8CyQINnBtYN16NV5QuhcvZ5maBuC4njtNiaI2Kies605EVoBDTHEGlAFWu40yeiZBGIIoRZROODSYMbMESTBDw4jz8dGCytEcLadzWPTzk7CDLI5jqdyo+KRMnrEmo54uiWUpmUFpHSTdTlSncmJEZG+zooxJ3r1bBq2bTYnkCD8pqibxG8DfXIzX1Tr9FyEiF/Hx87b5/AEkWEbFAJ42/p3E5i7SyNObLmd8BdqQ4aj7Nlpln8bOpzSsP4/+BX4JOK4l2r+mBS0FVZ+uUcIVvyzwxQmbnNyVtt5cbHSml/pU1FS+PC5iO4p2+Gd2KlmgH/OqAh6mnBvACWzIt/i3V8U7iyda/gjYRerFXJMF4GjkWHs7fVBr2HnaeOK5TaFLRSc8ra0wO
 pt36lQna
 x6qHAHctnoQq64U9auF27eodkMMlyx2QPwy7E/FtttZ89jiRoQq0mMm+wa7XMo3nsjbsKqHML8SWZ2xwppuGtLIvFvAwOAEYBdWOTw02jD2JQ8QXdmCyeQ6MidnlAp7fUWL0g5RClgSusWCfIvaqBJknbXXOamxCX1Edpii3vvGVsUVNH/El9QrVF88EOVPPbKbiP62ldes8hmon2mxPEfve4oLFdoVdjM1NOWePqaKEf7F1VQG7wYLSM/c3DAlebt09FqI9BbHCIxlQngLFKQWsLFDI9TDX8x3QnWS3s9I/Ft/0ekzoR30yodKwj7ZVYxZQHcldg95jsv1ZH5rTP4iAftBdHO+w0ZtRMa/aVAU4Wec+bx3squmY5MwlXoqE6PZwlQVGXFZ67r3qtXxPAQk1sHjFtxnDZdRx+uK1SAVM2LUo7j4XIW3uJIxsx7qCJ4H18hr748rJV6X2DeubiR6ZVX1Eoe51e0gmd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 03:15:09PM +0100, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <luca.boccassi@gmail.com>
> 
> A session name must not be an empty string, and must not exceed the
> maximum size define in the uapi header, including null termination.
> 
> Fixes: 0153094d03df ("liveupdate: luo_session: add sessions support")
> 
> Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  kernel/liveupdate/luo_session.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
> index 25ae704d7787..5e316a4c5d71 100644
> --- a/kernel/liveupdate/luo_session.c
> +++ b/kernel/liveupdate/luo_session.c
> @@ -382,9 +382,13 @@ static int luo_session_getfile(struct luo_session *session, struct file **filep)
>  
>  int luo_session_create(const char *name, struct file **filep)
>  {
> +	size_t len = strnlen(name, LIVEUPDATE_SESSION_NAME_LENGTH);
>  	struct luo_session *session;
>  	int err;
>  
> +	if (len == 0 || len > LIVEUPDATE_SESSION_NAME_LENGTH - 1)
> +		return -EINVAL;
> +
>  	session = luo_session_alloc(name);
>  	if (IS_ERR(session))
>  		return PTR_ERR(session);
> -- 
> 2.47.3
> 

-- 
Sincerely yours,
Mike.

