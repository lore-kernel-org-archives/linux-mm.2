Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EFF7FD45E4
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 19:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB6E46B0088; Wed, 25 Feb 2026 14:34:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E613A6B0089; Wed, 25 Feb 2026 14:34:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D39F36B008A; Wed, 25 Feb 2026 14:34:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C110A6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:34:59 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6C88613B80B
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:34:59 +0000 (UTC)
X-FDA: 84483981918.27.E5BB879
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5E75840004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:34:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LORfMFoy;
	spf=pass (imf01.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772048097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JcGfZZLTy1EfxpUAiB3PslYr4DWldds2kTYxvCknlIw=;
	b=E97n2VYIl1GLKXQlZ2cU/VhuBeFdmeAANqhTVzaA5YkTcM7fhBK0mODH4aErtQwibR5CBu
	R6ocCXKQYwP49K5wYOe2tGVWtMKzmq5SNtd2m2k3dVFdQ55G3sbmzOsqkLQ2BNP63arnxg
	CHHiENyjlfbWjuCdF3EIlD577alO6oU=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LORfMFoy;
	spf=pass (imf01.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772048097; a=rsa-sha256;
	cv=pass;
	b=DH+Q6d6a/fWrSGa0IbvAjrRPjDdrKeopQMMHZzOSKaWrUBHZGIOsr+/gJpij911K1X0XKw
	L7ADa6LPnSzm/8BgKtFcH6o3lmsQQUKP7y3xUQPJTCmuyGYvxmKnxAG4mvGv6ZVKn4nsmv
	eIEn4eP3a8+TnHJoP1sjLqk+vfOnlu4=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-48373ad38d2so14345e9.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:34:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772048096; cv=none;
        d=google.com; s=arc-20240605;
        b=JP+mI6cXWt5TeAuzGqWV1W8meEhv4AEGOzO3g3YVqdZNqwjtz4ZG0FTykS4f44VbsJ
         5ss+8QjoaB51WcZRlLMxoAG97Jku7vtLaNvqf1PxOLNdtkBhxtQUrLzU8xygfkYlmgpS
         RFj9rrxm8PeH58J4pklfhIshM+xj/pUCjtLzWgj/w6SPIMxpAzIn+juDNaZPussjn8j5
         B/2S20xBbwOzSZWm3uFWA3QGsh4t+BpFHw26si6uqxcIa8TMJOQHH98+mTjQkvsObzRp
         VBrWuscuFCobmW/LZ8m4P1eQzp6Bney+BAkJGerYScvWxkkbRtc6NCXXZhQJCG1QyJ9W
         y9oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JcGfZZLTy1EfxpUAiB3PslYr4DWldds2kTYxvCknlIw=;
        fh=mhCD2Xv41wZqas+xiF9hT76WEQpR1zFdWw7nPZ314Tc=;
        b=CK7i71ouTGio7b6TkOtX/aFzHFoxUGGPOYhcnKLBP934/hQ+/P3F7FOXTRUddRg8Cq
         N0n4ZbOmRY53dKpzNzwgHort10chGoX0kp4Ln1jBRDLNIIdfOSaUCF84GdSYVGsOl+w8
         XvMEiEvrMTwUqqflFGVsAo037Pk3MuPFA38XpXITzrskWbledS3kvGd4mb1gGei6Pgul
         yrc0SvPW+2UoaJYJHfZSLA9rtVmvUCobrjHOq2BgQ+RBtPiihjeBF0O/n40j9iolZrWK
         zIBw+q3ZZlxTGh16518Yp+bSYZOUomrLtBC760xG6UOH6v6WzYu8s8X/MtJsk8PYvQHi
         nTbw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772048096; x=1772652896; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JcGfZZLTy1EfxpUAiB3PslYr4DWldds2kTYxvCknlIw=;
        b=LORfMFoyeLO4cvzzFamMxbGX0lbME7XwZDFnVLIJs18pqSrb/TCZ6SpkRzPqYHc7jk
         MpduJIKTri6DzWbs9FcU1cKSOYq2vhSU84G7xcE+/zuxcgx06lVTHOq9fWReBnD71Xdi
         w2AbPkOVREH6F4LkmuNPwoqnrlwWt2/DrcfGqLkIMv1UGmCb34zMr/Mz3OABxfetd/wH
         stYGCBxMES8btTaT6XU14cs3ulyEfaJRaF3LZF/Jmyszm7QHywAocUMBP/QbxWvkc38N
         dS+6GtXkk2fX93y5QD0vsYhoNBJGe+HP0pX63QYfR2v6ZaN2aPemOpkFz3FD2gyAqsoF
         CkIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772048096; x=1772652896;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JcGfZZLTy1EfxpUAiB3PslYr4DWldds2kTYxvCknlIw=;
        b=f4+IGly8lRuRshTwXig0W4vGFHJumi9Qfka3u2DlL+0O5knDSVoAl72ffTOHk5YWdB
         5kxLNVVGu99hImDr5OvI9Fz6ogHt1KDflPM39evbUjzWjbx+a3/1l0TOoJMdjf/8/zbn
         SuCjo/UkAw0sBysBt1yn5K2NHVthnz9K9n4h0rKEx+m0xjFQkhkCchL9I50WQ6KThcBv
         3HHF6VbYSWFuxz+B63LhoKwGGQmQjFVZepiSv5n4xPXi/mP/WBzF0yUgMU3uqVyq94py
         AlaHUg3OsLL4uVFrMBRWstPn/ZgYYLdaJ90vgOfMFFdgvT5VQIW7wTEoaIfPAmavU1ct
         Wi2Q==
X-Forwarded-Encrypted: i=1; AJvYcCVhc+2sMyvkM5c3nwJyqYwPd3huNOQ1vZqYPdlUbahCmky7+PBy3mUNW/4XcBHAsnphEC6AzvZXGw==@kvack.org
X-Gm-Message-State: AOJu0YxKc5YR4mCWqlyw1R7yhynfrXeFkMvK8oPTc5lFVvHT+b0xkYdz
	Eq8T+mNRFmsGoYs9fsiL6CX6SHf0+dJdECPKeWAMBY5oyqSrUk0sYffuOtiBDx3QZ0QRwf2/3je
	8N9gDgXJSLBojNxvxs8mZ71sM/1ZJuYHLzrIGFKIa
X-Gm-Gg: ATEYQzxvwlpxnX4XxamfcISLA3Yp9JhAutkeSOS4ZvKM0vX8YjETeHRJVKh4u2Z87l6
	wwjLfHkT8sIZlYku25CCFzNWfCm7Di4kO15bO9ArZtK4WwCcCO3tOlS8S6uXjf/CiFrCw40bILe
	b00U8axQAZgbyafAwJWDvDA6uSBLwIc5QbPHpo3ggq051gpB69B5Ur++CLJswNNJYYTcTlydLEu
	TE96RdO8hjPFIN0hY9I85CMFxxRQ1MwjUNXbW/hKCH1E648WeL3rsSyn+qQEdYB3307E/lvBUKw
	q3EGOLw7QiqyLcHuCUO0QBUQOUyeHeSDoGw6zaEasDg4OrMZibzYSFNN4CGf/Wg9IORLxQ==
X-Received: by 2002:a05:600c:628e:b0:480:274f:843d with SMTP id
 5b1f17b1804b1-483c31b00d9mr66475e9.16.1772048095548; Wed, 25 Feb 2026
 11:34:55 -0800 (PST)
MIME-Version: 1.0
References: <20260225-dma-buf-heaps-as-modules-v1-0-2109225a090d@kernel.org> <20260225-dma-buf-heaps-as-modules-v1-3-2109225a090d@kernel.org>
In-Reply-To: <20260225-dma-buf-heaps-as-modules-v1-3-2109225a090d@kernel.org>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Wed, 25 Feb 2026 11:34:43 -0800
X-Gm-Features: AaiRm50gu1dpca-LBzWZRd4gNx9rYHRkdAZSms4Y4Ytlet4IdIIADCtT7UW67vY
Message-ID: <CABdmKX0hGSSbRFwni+Mzq9KbpxwCHzAFPc70RZVv1GmFW92fzg@mail.gmail.com>
Subject: Re: [PATCH 3/7] mm: cma: Export cma_get_name
To: Maxime Ripard <mripard@kernel.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pcccedtwskymomzwtgr7jpy1sr85c9je
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E75840004
X-HE-Tag: 1772048097-561819
X-HE-Meta: U2FsdGVkX1+EA4H9Hwh7t1RXCZlX85oVoL3/s3rHyhdfqh/yOK8aMrkR0CU4sgpbILFVPuk2D+bvVl6jgycM5IMlZbimsZ27ul8H8NKqKfWw/xVMPIhLtbR7efGkOBRTIMcpioCuYeqn38tFnwzQsoKl96HToHf+q6fASKHYA+u+rCmUU5RXhVjXNj5cDcwUTZDN0P84LIe3f0CNdSydzL39zHT0tw/vBzON+mDRQKc/LV7E99H+K4gcGDlAlRcb4EXNGG0dkFIXLldyHU+M82Qj+HLEcBOhQn+k62Xi+lqPfgMo71GeOPJH4PGuqYmkRpoz+5mqPVh/SGVv4sFyGiMf8+ZI7/8wnf2h8fVruxLWyl+vC0grWEwDj0RgAHiFOQ2SU1CKqcBuRwfBdL9GJ0X97lkl7jpqG7s3p5eS4opD0oFfVNpGvtS0Kqo9lZI6PLSvVhjFN+RG51VmDkD8pcg7KrLbIXfnxK5os5cOQl5MFVvGqc/h2H4FQUOghZOhMSWRXeWh7IHad3UVE2qL9CNQ1tGJFDhzrAdbVLRsVTRiPwpAGkxVZPSC4ckGGzlatKxDctvKuahrb6euBfLaxRy7j9H0JsQG8Ciwr931lBRXT47YKaQZoZ60KcftM/0gwpeypWR4QYwPIqIDLxia+nIO3RrTID5N2RNvoiwv70gRVjLATAbyYBmSI33feP/Yw+g0ZTgi6nmTjjJpL1wxeuIF1Z+SGrt4aaGgF6tanUp1oAgMylxMJeF8hmjFJLlQV59vY3OYbKz1QNGlwtoeCyj5mxRlLeUm4q6bplB09WNubyt35lllGJpL90t/j8gGdNkyhNxLxpbcKn/2Mni6mPT6Y+nLhBQ++r+Wix2Hh46/cvjDlcCO5FNk3u71xy2QSYYH5W93YGuppfYidJzAyOsxIxhS5blNfrmj1MIWRPAcwmd3ZAsEHuuWDRp6o25AA1wzQ13Voxlt+23NSf/
 naIKP6FT
 ePt7mfqhAV09BAng+AvkcXb/1lYIMeBu+p4KLZe2n5sDyDBknNwZ90B/RBT4cdmPB4ZMjoH8ojTqALHtJ7KnYbrO73NTamkCBRPKvL6hMXLRcBHDRPop1LK3B+R8ozTybWZso67NT2cMGDWrSZd4wfRhqnl5dIMbr/GmaX6itvqDTDo6rToby0gOp6xb7OoXTZYMpPSzvSjoqVSBlQ/JOevUl/XbA9eAb6lwWAGPBoXQ6xC6fR/syII0BPs7Q7WAD2RhWMu/YFv2x8UyZH+0lc0Siq+B8vS2qqyVnROZVcqDj5RbtZZqES64cYfPpmunGmYVl6az405OMhOk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 8:42=E2=80=AFAM Maxime Ripard <mripard@kernel.org> =
wrote:
>
> The CMA dma-buf heap uses the cma_get_name() function to get the name of
> the heap instance it's going to create.
>
> However, this function is not exported. Since we want to turn the CMA
> heap into a module, let's export it.
>
> Signed-off-by: Maxime Ripard <mripard@kernel.org>

Reviewed-by: T.J. Mercier <tjmercier@google.com>

