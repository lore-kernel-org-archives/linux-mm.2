Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19885FE51FE
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 11:42:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55D9B6B008A; Fri, 24 Apr 2026 07:42:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5084F6B0092; Fri, 24 Apr 2026 07:42:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F6D06B0093; Fri, 24 Apr 2026 07:42:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D0966B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:42:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DE3991C001A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:42:21 +0000 (UTC)
X-FDA: 84693261282.12.C1A7E2E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4BE871C0002
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:42:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kgu550Dk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777030940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tZKPR//23lfAsoiQUaKgV+4UP22jeYkcw+uzX5CkTWY=;
	b=gp4U+ykF/oWR6aMuNIQGZHuXbNP3mDk7emfbl5gfcBGalxv8dTvBNHQHG7XT9jUBFyg4SD
	cs7nrgxkOP1Iap3JxOq+reNoiRMk94HZ1QNi2pxnidcSlg/s61tXyvegwknRrmebWwroWn
	enTrjePHCrUbrpGCXmaivTHjaeO9EOk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kgu550Dk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777030940; a=rsa-sha256;
	cv=none;
	b=ANxlqqHDTGDQGQThNTApjYDsFVZ8NHatXLS2jvSf1AmvOxSdkjI+w+O3SPyup1Ju7pMe0A
	gUXsTWdEOp9goBGIzG6RHubqcxm5kX3Cjzss/5aCrlUaDVdy6Ar9/+DX9Hp2wkVIS2JIE9
	mCqv8uX/REBA1KoViQ+T513r6zKojdo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 59C964391B;
	Fri, 24 Apr 2026 11:42:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BEA8C2BCB2;
	Fri, 24 Apr 2026 11:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777030939;
	bh=tZKPR//23lfAsoiQUaKgV+4UP22jeYkcw+uzX5CkTWY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Kgu550DkK0b83LfyXC1QrLfhE2FbAOqLtlQMYk3DkK7gO4khSFcFbSKOeiSYgAmIo
	 rDFH4Ls19dcBs1eG2h/hrd9hynMntVd8izHKIfT0EXeFBbiWxu8O+8AbrI/jMPRuT2
	 BVxVj2ymMo/J41SYAs3dMAQ/mm5tVWWscicTSrqj7nKvaIK3+uDglaFvPYRihrQYXv
	 Jiu73jNOhtiBzJHZAfMy6DiwyNMhpMXZp2Q6aRn9kmk2tMV/cxG1/u9izW4Z4jVbCm
	 wHE+UmhoxAVxDmyevAUgG/O/hM34WLG2+RpUgvg82f9rQwYaAmagEyRAje11JSmEkH
	 QV21uAC/FU4dw==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Alvin Sun <alvin.sun@linux.dev>, Miguel Ojeda <ojeda@kernel.org>, Boqun
 Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6r?=
 =?utf-8?Q?n?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Alice Ryhl
 <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Danilo Krummrich
 <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Tamir Duberstein <tamird@kernel.org>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Onur =?utf-8?Q?=C3=96zkan?= <work@onurozkan.dev>, Alvin
 Sun
 <alvin.sun@linux.dev>
Subject: Re: [PATCH 4/4] rust: xarray: Add Guard::find() helper
In-Reply-To: <20260417-tyr-ioctls-deps-v1-4-41c6e9bb061c@linux.dev>
References: <20260417-tyr-ioctls-deps-v1-0-41c6e9bb061c@linux.dev>
 <1TcoEoC6DnctfKo9mZsuxSJtZ02ujRRd7O0Jxu62xR0JPeJcq2hB7XD1qBbjleyTBRMWf-uy0HLh7lWkYXbaMw==@protonmail.internalid>
 <20260417-tyr-ioctls-deps-v1-4-41c6e9bb061c@linux.dev>
Date: Fri, 24 Apr 2026 13:42:06 +0200
Message-ID: <87se8kh9f5.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4BE871C0002
X-Stat-Signature: 71qjhimsf88ak6wnk13rsegxx7igoox9
X-HE-Tag: 1777030940-492918
X-HE-Meta: U2FsdGVkX18YarSxCFWG43yFO91AVvYeqV6QRSSkP/Sh/7GpVMKgTC7JhboiB7yeBjpq4wFmo2OkFl+OPLNrVxI3PXRzD1dtKSAZTplO3FpDLdaJGES0L1C8iBxeJcDWc4O2W5YSmCm995Mlnq8WR5FpTpJrM6u8hz0RkNfUDzPFba1zB4os7PNpf2/jaxn6yD2MWqwrKEulO6lwgYYn6OzlIU2F/BG+BUWCi65tSmO9pHQ98TetgGJJq3ISwNnBXI+aYOYuQh7Qc1tku9xYeAJWMKahJM0rJXzg7eBaTIs9E9wUSNqwcYzGkXHS13WsRYxACTsJQVnrU/c6wyCM6V1ffCoaoeQf50JLEiiJR/tHlSVyJXRt0HihHoD8GdIKU6eYC1ra791wE49RNca8JOy7ORpcbFSOgYNZU9JMUyoRaSFNKbeW9nz+iDV8CaO42d5LqGO4lKb5rB9Dei7OUzotDXaaj3ziL+Sp+ZpD/4LFhek8E/t6ZOIHzC7dNGLJh6i9xqJcqRIheoAcytVSur1cvQNAtwKkelqFwvl5/2/+kQmFPUcMoYU0OsvMgNnAyiJbyQrs8Ha81W0oHFI+4hsP/GeUBYaRZhnKP+2ebYdTRVjEgfZivePNCtP4Kg5g76XV1nJRQFO2VWdiVEM82xZFVtjGy+GQQRxWsDPGcmM4jFyzkWbKSizdzBvxiD0t9/9v5rWNAjxsdCsPTdrUagHGo6p7AELdYVQIG9nHbasCJyRua75lGz+6azDkO2Dx9wJgqaT1T21aTV61vPM0i3D6f3GSV79vzl++uYM/vGWbF+5qK4VU3PMCjxcW36gVMMYe4QiTYmhYXNW+LDtlbT2HjS1kvKGb72cPF4htYipSh5FE9p4SWjsLamDP2ADK/Ou0fqLKS7QcUU5PgDiPaNUZ6Zj6l2GdOhZM5O3oMTNVr/LlPgQKp8Uo6DwHQDjk4BHRYpCfwra7zs854rY
 RD+HHBuG
 2vFY75qz8X6jEhFQATifl5oheEpKjvoppDbbQx0Lg0w/dR3E/hUUwBJ/hoJZnC66E8dmquIVrOOwQTD88VD80fzjGrLhiaTRNFb1o/DT/ouZmNmwbwL5KYtT62msEUfcQYLaoNsf+hAT3GM2ZQXLOjuPP5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Alvin Sun" <alvin.sun@linux.dev> writes:

> Add a helper to find the first present entry in the XArray.
>
> Returns the index of the first present entry, or None if the array
> is empty.
>
> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>

I submitted a similar patch a while back as part of the dependencies for
rust null block [1]. Could you check if you could use this patch for
your use case?

Best regards,
Andreas Hindborg


[1] https://lore.kernel.org/all/20260209-xarray-entry-send-v3-7-f777c65b8ae2@kernel.org/


