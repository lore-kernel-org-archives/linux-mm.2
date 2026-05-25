Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7949DCD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 16:26:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6979E6B0093; Mon, 25 May 2026 12:26:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 648426B0095; Mon, 25 May 2026 12:26:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 585206B0099; Mon, 25 May 2026 12:26:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 48F156B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:26:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E1A2214016F
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:26:16 +0000 (UTC)
X-FDA: 84806469552.29.1A73981
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 459CB4000D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:26:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mjko0xfl;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779726375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BukyjJ4n0b1AMw2DENX11/eFZaQYpsl8U4gKYqCB1I4=;
	b=2fV5LnC/8X7iEHsbt7cr8DbJqaHvV4v6JESo0ayCTPEwPZTLSvI2c9k0JMjR7PY/GFCpd6
	i1j9vWu8TTOR3OPRzPRwHw5CUfKSQj3LQyanSRVBojFipmXLEMAnlrZA+MHu5kAc1E97GN
	bLXgJM8kJfMAvOQunVRYObq+lgkTBQw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mjko0xfl;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779726375; a=rsa-sha256;
	cv=none;
	b=1H6RnnIqMn48W1qvkGp5hSnHar+pD9RqQAOIgdSjeUAwRduvz6guZTLHxY+5AhQA0NfCRj
	hwQJ3cH03Buh0sbDYp99XqIDQTsFH/TkLu/eSeQH18I7iAEgSB2HpnLqmjxr1dD7xq6Spe
	4FQn+XlJL4gcnX96qXIk1jbhh5mBeUc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C471A6008A;
	Mon, 25 May 2026 16:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4A81F000E9;
	Mon, 25 May 2026 16:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779726374;
	bh=BukyjJ4n0b1AMw2DENX11/eFZaQYpsl8U4gKYqCB1I4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=mjko0xfl53oi4XNYCKyMqV0lC7OCOPRG43ZpXvFlmbb2GmQu1zBeQ3vvxrEkDHRx+
	 /DzBIbN4OZP4tqdPfpytw0kVz30WHHlK/zLwudEJf/6KzUPMbTuER54DKBiXs4IJHF
	 NLjTPsyHuQyZOsnvbbf72IvYe15m2t32gREaXodAq/PMbvbSOxdR4jRG67EvLFg3LK
	 uCfAmoKHT3v4n3sPCkbNlVHBof0XAPnuRwVATI02X3is7RlSrnA5xUP6XJPnw+tnNi
	 khTSaV/4iGbuge5+xYy0CBtpT4wIOlu6wcMOqT3rOdL4vQTOso4lcX3V7Ew1HX2iRQ
	 9XloEc9VWjomQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org,  rppt@kernel.org,  shuah@kernel.org,
  akpm@linux-foundation.org,  linux-mm@kvack.org,
  skhan@linuxfoundation.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  corbet@lwn.net,  dmatlack@google.com,
  kexec@lists.infradead.org,  pratyush@kernel.org,  skhawaja@google.com,
  graf@amazon.com
Subject: Re: [PATCH v2 02/10] liveupdate: Extract luo_file_deserialize_one
 helper
In-Reply-To: <20260514222628.931312-3-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Thu, 14 May 2026 22:26:20 +0000")
References: <20260514222628.931312-1-pasha.tatashin@soleen.com>
	<20260514222628.931312-3-pasha.tatashin@soleen.com>
Date: Mon, 25 May 2026 18:26:10 +0200
Message-ID: <2vxz33zf78wt.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: oyah9g7gouiqu3guym6hy3gj96fwhifg
X-Rspamd-Queue-Id: 459CB4000D
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779726375-96254
X-HE-Meta: U2FsdGVkX1+gGl2J4RtuFze4y/nx2x36yOoZDz+WYlrRLIZ3TDBvrRgl2T9rODIz531/aeQBQ/eDrN3/WsW7O7XMn22qh9q/djRiID82KtwwRcno73TExY5CN4/mwy5m8r8U3Rvw/LNE5JhPLSqDc4ESZ1+sRykNQpcI54Rxe66/7Ure/p6iYt9rB4Zube42ZPvwArciRv3Qh3KAAukeeJU5BQc7toIspYSJLtgoBMMBFp6pvxgYQVZBRS8oI4rSZU9tt5Wj+J/ki82/W+d5+HCjyEioIsxOmu7vXgegoe2y+oEV+oFZe2vELGORaUFKRtJ1Osuoiz9ubfglm2OrGFPg/7M8erCA2KyJS2XjzQbaw3uHKf0rmOgtqIPv4Mk5hwAnhhfaNjVl6fVPlW3UHkelAqS9IOdr4CVA1nirtibgoTdvB7IktZtK4Rv5eO2K45AR3xqraXC6FzzOMHH+cPKLeDsdNy06SPvBYIXUk2YKYl7J8gawckHrweAEMDo+k438p6FifiVt3s2vRJwD4HGSw4Wcz5Q/HKPCTFG1uv7x4W5cm6cWWGaLR/f+C/11uqjgMPlq+nGzS8bskS8tQ1i+xym1UhZB6/UEr2sUTxzymKikQSOQvvNjsaHFhSX2zORlPiQimw8HwNSTvpAqp+0R3lJ+L9HtteAuN2CDVzyFuUJH3Jl3iqqSmLaowKU6uuW4zYWfLqqNUnj1uJUN4f+FMH9yoDf39g7pDCcEwNGG0NgeaEBPxv+p7bwN6JsGm364d98d21kVMByu9yFJdkuFqLynijLJjyHhrhcQT82EFctws1/1nGMZUsKG5VGandH5a1Iwm9KrPiorBebwJJXTaMlC0KlS2s2NxBUXb2DjyrqnTTiAuB8VScatDJtDWJr6BBOr0Xyugx/PNwE0UD+bAHBlDZUavXAMTOcKulpiCQqMXkCcoaocmn0QH38cOiS7S9vRZu4qFXXvFba
 TUG9MFiC
 GvXMA/rcgOhwC5iF87Nzgrodnc9dRzPUjzjSSmMhLSXpADPKdGMU2oytYE34LNieV4ne349jywa1328qltgQ+rFnGiITl6BrI7/8EKnsIBIx/Wp+fJ5ww8u6UPeLiFsIndxTMlTyD2IKdtCNdEoKRAajxLURWaMoVMhk9Ttv9d2irozCKCyt0ytHoZunuOEX7Y3BeFqm2mtwhoLsV/T3lZjKcd77gkOZxSu2GDjJtyFJ9OJHmHeVQ1iSn1deL1iVDFmQE60UaYl8rsM8tb5no9KUp5PB90HLpdRblcA4YU/mJ8OQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14 2026, Pasha Tatashin wrote:

> Extract the logic for deserializing single entries for files into
> separate helper functions. In preparation to a linked-block
> serialization for files.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

-- 
Regards,
Pratyush Yadav

