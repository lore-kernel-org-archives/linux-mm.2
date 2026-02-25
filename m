Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2783FD45E4
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 19:52:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDA166B0088; Wed, 25 Feb 2026 14:52:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C842A6B0089; Wed, 25 Feb 2026 14:52:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B62876B008A; Wed, 25 Feb 2026 14:52:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A28E66B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:52:30 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 19B7B1406BB
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:52:30 +0000 (UTC)
X-FDA: 84484026060.19.C3B9F3F
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0E74A1A000E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:52:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=k6nyyLGt;
	spf=pass (imf19.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772049148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GOCqpqP4xulPNkLV+0mavDjGZp2jPKuE2l1wLsJLWlw=;
	b=3wZ1yxShNhXieBcutiz68HwUmUyEdaYF1zkn91zVkXR5cXrgpdFScsq4xoH86WuTDDBzBM
	vhzfde/0R5NB0Xr/EuluE5KD4mbTnYAKjLY6+m/ViZ8vAwZro4zsUtUbfWfNdmTL45Czv6
	tOxIyGTgbF8nvEOalEEzX7v6RbEqLjE=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=k6nyyLGt;
	spf=pass (imf19.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772049148; a=rsa-sha256;
	cv=pass;
	b=0SKT5FdDBUPXSayDeMg6J+9/+GCj4O8QNP8ys8cjFR7IQ+8O9S5oXoJ/bcB3MTqalww825
	osOm5dpwYZguHc3sD/BZBWSI/KCWUQImQfnbes7Z+XsK6YpiDThANGTaqHn+JBXixJAB6A
	/DHxtejX+10LKyWJbVZkilKxumWjvs0=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48318d08ec2so11065e9.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:52:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772049146; cv=none;
        d=google.com; s=arc-20240605;
        b=XqLPzTNENVXPy3eAUANj0NNpryk7KYIDHKuG73bPNmIp/tBX8uod56RnbsX6m40/q2
         l4NIX/1CwRaABimPDJwlrWgsWyLbkY3WUQSGGp4lm4f9qniyNGAsL1VNy2b8Z02n44vp
         xZLtKth4CloWgkoue0ddQ+zlTkVVlKr6nR6/gjiNXnyRY/KwHemXqtu4Y3lLTqYQX+JH
         d7Qet8OCH1cXtKJW6Mz+CbBINOTO2++2e0INmLcHw+VqTDvlNgu1MXjt2jTI0s7jeSYm
         LACPQmv3boPKoPvu6I9B6G993as2uI9SzBhrSWiNyLb8lHcE46c/aVVIHcTH4s5hlTKD
         4gAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GOCqpqP4xulPNkLV+0mavDjGZp2jPKuE2l1wLsJLWlw=;
        fh=WLAO3i8Hb83lY3sx3dag7j/ZIqctBf32b86ISXGInn0=;
        b=WHkot9Yq5BPVTezhGy5DX50WioJgq/0vXsTPiwQ8/wavcRqZIjl7a3xnkWRYbFG9Ys
         kLlDIGdu5sIlR/a/IOi/gHiJBpHmhMdY3Sh5c28rXSydMT9rLWHAOCCEnY86GnLxGf0n
         7H71ioDYKM21IVCPwHJhpFPDxjsYbZd0S0YFhqVneqx8dFQyYBIi+OVrXOyxl1AQj7nk
         hls17RZbMrD8GoWNLn3UPTso6EkVIHonVumBUIMMhkreHla8GbO5tPAiUHVgnDVF3juE
         /Cel2Jhrc2pMLo2xhlIByToXN/f2Ehmt7MvIys1k76PiPYo62R+Hi1Q89B8q6kzmzyrG
         jusQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772049146; x=1772653946; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GOCqpqP4xulPNkLV+0mavDjGZp2jPKuE2l1wLsJLWlw=;
        b=k6nyyLGtPgKsSkG4xJIl2XUACUZZ9VfSMiO8/KRdPMV/DwnH9d5EB3fjzxhsmPq38u
         h8mDSxivSBA7Fe+GxG+a29hhxmxWL0F6xZY+QaNjoJklddLDDPwx7GE//OWU7ZZz0xGW
         R2S6a34gqEz/qcwbgqjLVpRpCToWdKUy4BbLEQr4CLnQbVXjMOExXg04FzDCGgXPcT1P
         AI278WtzMN84gru8QPsSPiX6k6yQArcN3SGcCAw6ON60Py24+P1TdA3zN8/k1yPq10W3
         NPfVnF2Y6zdWrIikemPPqevMXr/bGpcm9lQsaW+y9u0k93JCyjvHZcBIrG/dYUHJBrhu
         jr0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772049146; x=1772653946;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GOCqpqP4xulPNkLV+0mavDjGZp2jPKuE2l1wLsJLWlw=;
        b=q55r0pVNxwb4fUvptRtsvTUx05hQw3+oRQOYh9HOSk+DuuO4DpPsqURG1u25pK2NNQ
         UPyM8zHv3TVVPFIIlvdvm3QfsMotE55GBkcLQqsENVJ2MNRvygeZEVxU19RgkvNLn+HW
         LkTPQWxjIGQ1eCpoOvjyyGR+O0CZwPodVL2lqY/sRRg4OtaXF+C5kOHYMXp5B8xnPWNV
         Kh4jV7Vvl0+sdUS712ADNa+cDKNXtjQX6HXEjagGT7T9kCyxBbw4MDdFrIPkgslTOiaD
         o+2voAHduofoPjOx4GWmP8ice/q2kbxEuJ6srdkGGAbNRgZTrrQZ5AAsfAHc3bfy1QVQ
         zyNw==
X-Forwarded-Encrypted: i=1; AJvYcCV+D0GcHWBbd979q+WNmSXABn5djP29w8WHhp/o1ZiJZ7ucWDSbJ1jZ1FtZXCHAkt1famUQM1uXEg==@kvack.org
X-Gm-Message-State: AOJu0YwFqicjydmyHwRZ0KYVXNzw4anxG+QG31EXqDtWx3c/KQ3QkjWr
	kE4/dw1odjeqfKgVuCFByIEXztekacDAodifMu7Y1UBcZpfQRAjgx7v6v0o8q0o6Ti8zCRRFDDi
	cLH94lqtAoumUqhbCUVvwv0hLss5boLcqkZuAIQk1
X-Gm-Gg: ATEYQzyPsjzh3O4AnO/PMliYRkpaYg8vqnyiFhIG2lD7atf9dAS8xOiU2lOw7sVTbKA
	kbYY2s+6mMLrGO6VEnfvB2Z9PFVZCY/6vWscRfPW1OQU4itq2ETP5DpUH2RlRGziDIetrQV/p4R
	cdiP76QqpVlb3EyZ60wtPfx4XKHzVLubVqhG0vIXbeUYH5Yww5DdhG//bFR6ymBx9sqPrd+Nyw6
	hvpjlUiLQwZE5ASRwkSZXo1KwCL3ggVvKKopHxmydzzMjOZgCWxwf3ysx9gNE/tNXnJcOqUm2mr
	+6EOiiT7oUIuC3mXEZAwCdnDcRHjtNUILznc+1CUHQK3iqYyPxBYRLJzZAGs6C2UMwcYPg==
X-Received: by 2002:a05:600c:5702:b0:477:95a8:3805 with SMTP id
 5b1f17b1804b1-483c31cfb56mr70235e9.15.1772049146264; Wed, 25 Feb 2026
 11:52:26 -0800 (PST)
MIME-Version: 1.0
References: <20260225-dma-buf-heaps-as-modules-v1-0-2109225a090d@kernel.org> <20260225-dma-buf-heaps-as-modules-v1-4-2109225a090d@kernel.org>
In-Reply-To: <20260225-dma-buf-heaps-as-modules-v1-4-2109225a090d@kernel.org>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Wed, 25 Feb 2026 11:52:13 -0800
X-Gm-Features: AaiRm517LrodfDPDmk8aF233zMemSo71i-_zn9eOj5ImN-lsr29tVaebY-ntsoQ
Message-ID: <CABdmKX1piZByQvx0sYbO4R=f1rdZKmYS5R0EcChBv22cAUvCUQ@mail.gmail.com>
Subject: Re: [PATCH 4/7] mm: cma: Export dma_contiguous_default_area
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E74A1A000E
X-Rspamd-Server: rspam02
X-Stat-Signature: dny8c4w64yybsr9rg6y37hqoxri4ft1c
X-HE-Tag: 1772049147-689583
X-HE-Meta: U2FsdGVkX1+qf51hJnEDON3APiUd8C3PmWH6zJy26T9FsZ0sKXn4zMgA69WWeFUAHgGYOyvZ1zxfb8oLdBg4TyrWY01pC4ePzCYJUW3FOfafZo3wsV1WsrIYfHW23IJHxK2Yq7EXCFZXJaZRnlQeqs+Xt53pKwvgFZM2HU5vqdoZYB3yD3rHIwqvOUMcs6MVlJ8TokMsDAxtpXfjceCvM/aidh238LHeM2y6wcNi8KOxVKSEW/e/DmwWC6ETCzsl/OTnzowJXM5aN9RZV1tLFjgkFW+eJxqEafROdcDGSwcmK5DDsU/MZQwl+9eLj5k+2VMxoeqDAIEwDC9UDVMjVZDGUtOMLLOWbaYlcT9MVvZRsHAkYSJG8E5QCjzGDT72syBkSZEr3PE0qdO9jNQN1R4AqJALTomcbCyb4BGRl7FTmAQNtF7FEW8EMED+SitMSvuy2YWUrKwIHehAT+ChBkQfk00UlcNua1dYeLqL+yUUCQEsDmz4mvcL1/knJkTQJMbgj4HW15FKAEaxXVlt//dxun8BtOARN8c0QyWO3Xw83OW0QRsfWbe7cRwQzqnK53HbhTfXriy7rPeemyKMCh3waaB4xqnmJugNeb7Ic23heh8ewPR5qGBm5A/v5dS1HZ3IbUVARRFvNSurxsuLxgrqlTq+DsjoGkiZ0I1WEQvX6v2X6ntUCoEn+rbGApofImnrD+d2E5SDB2y/UPR8+FH2tW0Xly+WIr/gL0uIARWd9FgXqIxbgHQZKgQavFz5OalIXQFZEkpfwnZWJHKYKyBTfQmewjLVFkUpB3kH/S57qxK4+es9k6CaEsiTbRoe9Axgt+ShjVVFV1w0C+gep6vcnP/kVyXxJzmPnPHXqGzrSDMOftqkNCMS07bLK8bnaG6Twc+prbO6NpuhbpMmyyNTyw1UWizqHXkBVnmd7jbLHHZ44ppMZWBbXo2lyoPuKIdYuBqbmVpIkI3MmP2
 HsnJW2fQ
 ziGnJa9tD7kp79tcyHK2LvFDkmQO1PHHbT0IESChS7xlDK2f66lRW3t3PCDodimvZEUOYeUB45/HNZQD/K9qD9dEy4WRNFu5ABgS0cCEJtt8qGniCSNSAHySIYd3s76UE6y9bDr13xoBI1zMaPjQ1ao8feWt8HHFp1xXzJAiHnHiE2TmSrV6wS+D4aKfn7G4JFt8Him+WzZVqj/pbwR5kU/PESGLVSR3kPNK37+FZ/U/y2zyWyHJrBSoUHcYux42z1vuOsxO3QVCasoRMpujZ7gsso2p2Sqvjb2XXA7UIpxpIzxOZxitL0JPg6dd9fvyPRf1dSgjI63D/qTNhAG+lcR8qdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 8:42=E2=80=AFAM Maxime Ripard <mripard@kernel.org> =
wrote:
>
> The CMA dma-buf heap uses the dev_get_cma_area() inline function that
> would either return the content of device.cma_area or the content of
> dma_contiguous_default_area.
>
> The latter holds a pointer to the default CMA region, and is stored in a
> public variable. However, that variable isn't exported which prevents to
> use dev_get_cma_area() in modules.
>
> Since we want to turn the CMA heap into a module, let's export
> dma_contiguous_default_area to allow modules to use dev_get_cma_area().
>
> Signed-off-by: Maxime Ripard <mripard@kernel.org>

Reviewed-by: T.J. Mercier <tjmercier@google.com>

