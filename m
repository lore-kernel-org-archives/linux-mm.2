Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB4BCD41143
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:02:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4C116B0089; Thu, 15 Jan 2026 04:02:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEDD76B008A; Thu, 15 Jan 2026 04:02:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF06E6B008C; Thu, 15 Jan 2026 04:02:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AEBBB6B0089
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:02:50 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3BE41140266
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:02:50 +0000 (UTC)
X-FDA: 84333608100.17.0E54911
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 89FA98000E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:02:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fgJ7Z2Xl;
	spf=pass (imf30.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768467768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8UUzNRa0WXUQwhfX/5RRPZVP0ivXwSr7fQNbn3Gg4g0=;
	b=eBIn7WGMRQ03D0TFypAd9SXKdtv+OhnfoFtq0ml8gbjJJPByEMIoWscGZFdCIQu3NMoJI8
	ILSaXrNOn37l4r3+e79Uit3kyccSwQ08AwjDNBveF2rj0X6hh0dudzRojwk5lLsc/I6i5b
	VhVgR7dJF25J6eXnozxUYtSVm6YeRDU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768467768; a=rsa-sha256;
	cv=none;
	b=YVcww0XenjScwI7bO/JK5n2e/oO3M+aZB7R4BSQoc13hcfrqA0OxJifz1XAwgZQ48iyDXB
	YbY3YMdCORSfWKslKjKQnrQ1kXQZfCKoZdgXPIbybJC1UbGYD4iBq+Tt9peD3yDjD+xURl
	6OaMoHvd3zwDJ8hX8hW/pppFmo1QMr8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fgJ7Z2Xl;
	spf=pass (imf30.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9BFBB4191C;
	Thu, 15 Jan 2026 09:02:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199EEC116D0;
	Thu, 15 Jan 2026 09:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768467767;
	bh=DrUlgAreRjMLVp7ZtlPiPfu7LA5dkOhKlrNbuz3KAdc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=fgJ7Z2XlqAEcp8dWpgnsTRv3MgBc47pmJeBopSoKgoZTjNjNzMe26Vc5tNXHzCOzo
	 GJgG2XHGWTNvUvRK1S74RWgVebCzuHtB/iz69IJHCQedcNE0NIVU7utMuabHZPkA92
	 qRYi4tovpuqrxkCiaIVaIF5CakRERK8RM0dmVrvF01swtY86unWmmXr1bvLU+7pCCb
	 ZQM3PSgQiUw6Qs6odqoHTAn54XFiEXku9TjgWI3AVhZRk/t1SkyXB+FTkQaKOKQebv
	 LWiKtrKJjPXUeTCK4ietsJqOhnHYTo1pHDCdBEZOLXSjCA1SLUqqPL75yvffhcXF+E
	 vqZWVqqY0J13g==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: rust-for-linux@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>
Cc: linux-kernel@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>, 
 Gary Guo <gary@garyguo.net>, Andrew Morton <akpm@linux-foundation.org>, 
 Matthew Wilcox <willy@infradead.org>, Tamir Duberstein <tamird@gmail.com>, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20260105-define-rust-helper-v2-27-51da5f454a67@google.com>
References: <20260105-define-rust-helper-v2-0-51da5f454a67@google.com>
 <20260105-define-rust-helper-v2-27-51da5f454a67@google.com>
Subject: Re: [PATCH v2 27/27] rust: xarray: add __rust_helper to helpers
Message-Id: <176846772738.752326.14630458466153959186.b4-ty@kernel.org>
Date: Thu, 15 Jan 2026 10:02:07 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 89FA98000E
X-Rspam-User: 
X-Stat-Signature: wjc1xahdnjg99z5fnkocgnhfswddtgmz
X-HE-Tag: 1768467768-986851
X-HE-Meta: U2FsdGVkX1/fgdIGgw0QqnH2b61ajccPJ1pRsipT+b42+/qwQtcBSuIk1W4WsQx12nEcpRghV3HAbfDwZSxTiGMO2/GvzPJrQQ7/GPQ1wtmFez05WS3ZHUM3zRyVjbt+DW5gRboDNu3psDGaFqawZewMkrMycclF3qcHWo5vEjXeBId5vciqXqk5Wk/VR8tcpXWcOZ9HRuJezOrr+S3A2btYM3bS/7PCs7C3g+PvgTse8CfPQmeMiwtp3dCggMQZFzW5PCDxJWsLc2w/1nigNW75d2rA6vm2HkH6T4gtSBNwcStCaROfw330iU8HpCl7Ur9bQNZ38luYRgC08P2Vh06yXW1qyzxzH1P9fSX541ABEAVh/eHd0VF4bBdMMlTg5g2c6Qepn4Ee6/jAQjN6GjVyR3KzNtoQp2SFVAkd3R7A+J8ATiUnu0ESTJr4MigYaIEG142t0PBBLN6xm80OzUeKZfeosEjKYAqdl9lqGvi3uGDdxblxgIQiXAd1mc9oalZZcbT9OH5Yst0AkxWPghhHlqy5U+RPD7oRj8KFCgphJcWHIn3o3Vm3OAt97kcRq8owuMAu8TM4a0TkqmnFkVahx8Ut4mVii0jJOf0vlm6oQnTJC/CDiUaw2TBOVSWTJO5Ujkg7FrWFu/FN+2q58W6JFLhzOt8MFiFz3I9e+N7QosndT/DYSYcKa5TqpxTquF3WOOtPV9bqaNpM6B+c1bahw8TO7VUr5XqWxcenK0onBdijDsew/yhP52NAAhXEcSdPaGUj34Uv7KsTE0KLK4AI2gnJ0svSJFkKcsV9oTT9oDlF0ui8pS5yWLgvxUzaVaDfgxnPb4U23VtA/50I899pWK1fA88/ExLzLLhZEFnayv6xTZDgIfeFxxUXop8smak2d79TF/XYhb/lwX1tW+R7NlkqqEKlR6cpt+C0hPQDi3XWm/ejVxFrBrNHgO141fCFon9MRH8DDDyQb0x
 1N2fCdX7
 1a2cswpsVF/ZHGd69SMRqAYUwiGgNWTM02gW2feZy69T4xV9KJE3O9izFz+Q/bE+HHZxAdXKiVJClKX4nUmcthfKoB/BRtFEB/KKptJayqSeDQI0Gbv8Qx+GSgplAZzdgZK0A1wQ0uLknr/gqx3hWHfpmt4QuoXP99qeCyf/nK4nSRHJW1dbVAOMJw5uIcwJvUtU6z6Lrq14lvV9k/3uyxSsV0aKA5cvyFBGjRnS0yvFxT9hF5668KYMyAdbhZDXUZFbj9hSBv+Kg2CGb921EvrEEKvZFtYg2sRpkABUD60UeZJBliUMbZJwdluGjrF7zzvHx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, 05 Jan 2026 12:42:40 +0000, Alice Ryhl wrote:
> This is needed to inline these helpers into Rust code.
> 
> 

Applied, thanks!

[27/27] rust: xarray: add __rust_helper to helpers
        commit: c455f19bbe6104debd980bb15515faf716bd81b8

Best regards,
-- 
Andreas Hindborg <a.hindborg@kernel.org>



