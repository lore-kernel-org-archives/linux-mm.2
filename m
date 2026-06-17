Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAE9DCD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 13:19:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9EB66B008C; Wed, 17 Jun 2026 09:19:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A780B6B0092; Wed, 17 Jun 2026 09:19:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98C486B0093; Wed, 17 Jun 2026 09:19:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DB446B008C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:19:02 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D946F1403FD
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:19:01 +0000 (UTC)
X-FDA: 84889460082.04.1CC5804
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf31.hostedemail.com (Postfix) with ESMTP id C76D120004
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:18:59 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="DqdDcC/T";
	spf=pass (imf31.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781702339;
	b=6E7RQtjdAAtRmDTYaxcK7CJIOj1gStu0VC3S3X6QHTDWuTcJWJhAvxOWJWH01w6veoTk6J
	Wyudp6cSQgx/eS2oqZKco1jlIsdfXmcxcCFNDVoE7TAOdbCq9ImwCRQmltDDXMT8lEDKRw
	TOE55Si6Ywn8tdznora2G6u2edONYkg=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="DqdDcC/T";
	spf=pass (imf31.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781702339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TXAYl00t3pBUlh7QAs2TCcfP6P29I/Yz3jzTX2aYa7Y=;
	b=gQLEB28eIKI7bJ/8TbVJ5r7eDu1+jM+3hUl3h/lVRcJy45nX2UDYUKGHdywy8fh75Bs30v
	EeA+wsIITVC74ka9aNw/RsKFgShMrqTruvoLfMFNJKNOPzCvX/4a1o9djGw+iGG54DrM2H
	9Nj5dKNQtNg0DxhP6kOZgO0mn+os4H0=
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1363fe80fe8so8205930c88.0
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:18:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781702338; cv=none;
        d=google.com; s=arc-20240605;
        b=c/IoGieFD5pQVXcWc8J2NAFc28dWZUjIVycggFfevTWn9gZzUyraT0hFAtv+aPQ6oG
         ZYVbp0prBhHFJCn/90d8fWNP1EXPd0r1+mokz4WMhSj7IQmVCC03TrUJ2JCghfN/R7GS
         rrr/1ThhjP/OlCPC6V9cCMVdq5OHWGBFbrUyrkSq7fUHuYr/IUCOsfatObS1fxEsn6xa
         BrCvRa/7dl1nJRmSWQhSAgz53mY0TU2Yqz+nZ7s0nmdCRc9RRYq/jZQYObzW9jF21bMn
         GPZzf5qmuvLY0TCVAjxXWpGO4fYKLvCXpqm7kLoAXGadLO2JLQkAW+99JfjcZADQx5QT
         T6dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=TXAYl00t3pBUlh7QAs2TCcfP6P29I/Yz3jzTX2aYa7Y=;
        fh=lKsLqRPoHN4GBRDLEqG77ACjdbwFlw/vJcbSfxqHmjU=;
        b=kU0yUbOXyzlluvY3uqXDxy+lu2BjCLeRq2MK/ArEJBcLPa4+dpucFoIsjxdaAjrNbY
         z8ErKmaJ2DcIDlcbSwOsJwfV4e/W5UNqleTTOlLPR+c/km+AQV+9CAmmt32p8qr4ADvK
         ie6bHUlHinMBI1Y1WgrqNlk6Z0B1DgdA5e1+E5bS/KkKrJJxwVu+UAoWUzdxlwnawyfo
         yvctOOLzOC2miYfd8FG4EaUMU4p358lb+WiHX0IHw8N5UEb11RnYm/g88RlRpslDtZeC
         UvR2Ih2+Yy+isj0mCimUev0d40oGQ3/OR0plTtf34zEUgxkVNNM+0NugJx3e0FMtyxse
         MZSQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781702338; x=1782307138; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=TXAYl00t3pBUlh7QAs2TCcfP6P29I/Yz3jzTX2aYa7Y=;
        b=DqdDcC/TeHmEdtas1egyjitrS2cN0PGhhXvRguLTeSJnqMV0jXrkNdSRi90lOC8S0+
         aAAbcY8wA20yWoodLoli3DN2Xh0Fb+jKoK66kmupaARGahQPxNZDGfxn4sOcktCzkL5J
         IqBRgPFdcZuuVaXxVeJvU0nixQ6kheGLKvzSmPl5ItSj2fySrQkAmAZXYKI8qfVJYlXc
         f6th99iQxdAToef0mOFHw20ZQPRoeg96tnCgTxnBLgnmZtVGUYe640RhTagfBfLvd5oj
         iWhmlCYILTTqiCKpz1/61TFuhNEYrIvAzJPGB2WkHZsVQU1qa15gxsnAgE+opwDpeDwY
         FBnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781702338; x=1782307138;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TXAYl00t3pBUlh7QAs2TCcfP6P29I/Yz3jzTX2aYa7Y=;
        b=ld1fpgKelZCVmkO2ouH4f0VtdETYzN1yrVxMQNtj8pBOqrLHFYgG0uTygpyCCLny3Q
         M9YjwZAQOAxZlqTXZ5yPUKkA8u/TsQ6KcJ1OT+cCcY2s969LoTLYh1VwCPSxO73Gjtdb
         nYoIi++QmvYIpv+46sTXgq3Y8j3vqtMF4ydY4WRhj+vn1wHfwsRvvQzf3zPQFCVwytm1
         JNWc1eNLGWSPKL+OXxCaxiQk8JmvmPtnkLafsHJPqxqSXYGImhONltFMQ9liT2Go5Baf
         Q+9tE0n/Gr02c/lCuRQJuADwr1fzjAdP+QUe1/14KgsjSjLfyJ400xaIsGrBENXvAUD+
         ZQiA==
X-Forwarded-Encrypted: i=1; AFNElJ904iN+EXVYlsLPkwOYr+teHaL6z4posOFV1hKd8bMpkVPnUvrYxCd1NkoRWaX5ZKNhYzxAPwN9TQ==@kvack.org
X-Gm-Message-State: AOJu0YwKDr/2bX1InLzhxxX5ir1TmnsFgWt/hoE4t8YFZPMVLRbw+VRm
	bME6+AZJ27CTJpkcSy+SupiXdFFhyhWZEnmsvoq9YhqnIbja/PzRRICUg/byyTOoFbkJY99F81q
	SPxH7PJPfc7KwgdDEFhjkab68kgthmys5GTGPety9
X-Gm-Gg: Acq92OFJdWEJpBJBy3FoJiYLgcekiQH10ifescDDfHW4ZA//ngWP9t7Uiw2ekSc2TIW
	DzWASE9meb/S1b+s8oGXI1wFSRw52/V1QLtIW9Rt79i/yfKFWv+DJCXEL1NAB44ljksd9K9ZBNT
	bSW8r5avcNND8/pUAcCwyTQSf2zX6xcvqaEqXnTfhZRSFA7lRrHVrtSys2BzbGlHvIyeDyyzBhu
	pQ6dqxIjDNeBCsS9n8kibgK1/zPohmzDPgqGupv8mh17UvdSN+hI+rGrNYh4KFDVl88QrjtBJ0i
	zyxxkfiSbQ6y7LbeaHyTO9O2E2qBVVlsYfpELVI=
X-Received: by 2002:a05:7022:f8c:b0:138:916:5179 with SMTP id
 a92af1059eb24-1398f676bd6mr1477937c88.14.1781702337644; Wed, 17 Jun 2026
 06:18:57 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 17 Jun 2026 06:18:56 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 17 Jun 2026 06:18:56 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260602-memory-failure-mf-delayed-fix-v4-4-a5bc7db5a9b2@google.com>
References: <20260602-memory-failure-mf-delayed-fix-v4-0-a5bc7db5a9b2@google.com>
 <20260602-memory-failure-mf-delayed-fix-v4-4-a5bc7db5a9b2@google.com>
MIME-Version: 1.0
Date: Wed, 17 Jun 2026 06:18:56 -0700
X-Gm-Features: AVVi8CeEQPoqGj6Tm5lqS6hWOuYsOw4ghr_S2X43a6pbnMXpEzjcnbUm6R99GZE
Message-ID: <CAEvNRgE-karT5BYOCePr2mM2hu2AgQ39qhVN6hk=NK+XWcvAJA@mail.gmail.com>
Subject: Re: [PATCH v4 4/7] mm: memory_failure: Generalize extra_pins handling
 to all MF_DELAYED cases
To: Lisa Wang <wyihan@google.com>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: rientjes@google.com, seanjc@google.com, vannapurve@google.com, 
	michael.roth@amd.com, jiaqiyan@google.com, tabba@google.com, 
	dave.hansen@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C76D120004
X-Stat-Signature: hue4bf376zze4qgee8dex8syqn9zh9mw
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781702339-340821
X-HE-Meta: U2FsdGVkX1+7gjVSZwL5FKc5vypFfYVq/wl+8Tb+fRTa1dItMI0UeeAcZR/ezW1HA9mehVMR8J15b9zmLLcdvoEmLInJ8oMwl9/76UMC9OUDN5WZNQO1DIIis+PQtt2784ZAPy8LcBhq7src9jaKiXcoviMqtA9X7fH9JhgPTIV5F8Od4Em55oNgTW+Qk0+UI67VHk9ZP+eYEYDvVqbTiZ0YGS3ZQOptayCd84mjh6whQLK0OWE5wtdW1xwqVi8gCpKvgaRA1AY1tAExu4Ljerq4lOxMRvS/zOFCXE9eaWQRdiK1hOwQ+paoSVMLAQmPxeaDQpHXjTiSYxqBfCwl3vZX2Rs05ErgtKB5fXqnfOQrYixkrKZ4ZNPRedHtC+yTrnRDtnvA4D1L74m2gWPg0iRz5WmpfJRXGvrd/MMyRa3kObLarHvnsdjMAyrcHs4ozRcTJxf3AxwqbjvufGE9Houc+qi2HhrfNZ+nYaaoBOt/RhwEzpbGxgq7gs9SP2MKBdrePTw/Tm6zHJ2VrRsA48/ZT3Lk9uQM35qgl44Wm3HGJ9qoxgAWUQpcg4e6qlK4ClZ80hNrcKnIM7JWleF9qhZkZ14WvBaZ0FgAIg9JWz+s/PcknVcVhjmzFXUk2eZNq2jRW+sM3y4g7c+0DLeT5ADNFVXRSyCkREN3jjZba0rB47qYmnYMNrpFbExyYy/kzaBot1/qjK7qDF8hJ3OGGwGOGZ6NzJrRghagb8/xjuK1eAADA4qrs0YnYbBmetk2aV+CVSOBNqFYX+Ypq1G0phPHTiIQQTzus4bNTNAMxwDgI9CeiXWj+mV80VnxsKpCq1t8LaM+mNxsj3YxlYhcqTPIT+6jkie+0ceXEjBzjU3nFvrDJ1CL8oRXhFYKyG4WOi0zECbbLvvq0wTIg+CCBAiJHo+qNZmJfQaZDkhNjisMFIbOb8oKvN0vN7axMnb8NlQZuBrZ75RWqcAbsa/
 9PqcK82C
 Rr0KhFAII5JKAdp4wg4HURW1kTrJi0+oLndLctApxwpPXLcqECNVLxJFAzuK+E8SoxbiaGjlUWkRI+UPezKTbttza86r7vTojviIpMK/VFmcURjzRxj8E2nd+oXtbKTrOnqHCtDVz2KuElT00jCxMmhSZz8ZLs92z83cUUUBwCQz1CmL8MnXO1wAIza5nSYruiVoD57j6TdxcGt42GdCT52DrJRKzAwM9yJK/NZTNJ0Gpa/NzOcUyf95egqisMXOsVC8hOrnSmnVmyY+wXZTicyX9S7174N3i8Ir4wm210EIVGoasBu9G6kBuvWnHl2pG/kDtXyfpMdApNygtaG0S0DplpeSL+iyjECqZied/LPAzxnrLmNuyQkiC/9tWPWDhFCmlQUzoNirW932fHfXcWctgZvCbkiCxejwwfSxk1D56RDHiZrXOFDMp/io7gF0Xs1im
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lisa Wang <wyihan@google.com> writes:

>
> [...snip...]
>
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 3aff0c981fcd..dcc56bedcb28 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1052,18 +1052,14 @@ static int me_pagecache_clean(struct page_state *ps, struct page *p)
>  		goto out;
>  	}
>
> -	/*
> -	 * The shmem page is kept in page cache instead of truncating
> -	 * so is expected to have an extra refcount after error-handling.
> -	 */
> -	extra_pins = shmem_mapping(mapping);
> -
>  	/*
>  	 * Truncation is a bit tricky. Enable it per file system for now.
>  	 *
>  	 * Open: to take i_rwsem or not for this? Right now we don't.
>  	 */
>  	ret = truncate_error_folio(folio, page_to_pfn(p), mapping);
> +
> +	extra_pins = ret == MF_DELAYED;
>  	if (has_extra_refcount(ps, p, extra_pins))
>  		ret = MF_FAILED;
>

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

