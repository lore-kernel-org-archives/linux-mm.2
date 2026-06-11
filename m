Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 012CACD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 12:32:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11B3E6B0005; Thu, 11 Jun 2026 08:32:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CC8A6B0088; Thu, 11 Jun 2026 08:32:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 008F26B008C; Thu, 11 Jun 2026 08:32:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E80CB6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 08:32:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7AA06A05B8
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:32:56 +0000 (UTC)
X-FDA: 84867571152.01.3112142
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id DF6A21A0009
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:32:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ePztP8aQ;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781181174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vpDuoAAfa3pi6DaCEs/tUqazlgd1kzXI4h/l0xgipiI=;
	b=EFiBMp9TusXnvzR8pvpT4vWU0V8sKj4giNhZ+nUQouHKR0OPd6W85XyMuUF2ufxLaFOu7s
	/Yj8DS4F6jiryxCvwU0pulcufB9QKmET3eEDk6E22lMQR5c0GbbEzGGeIugHZ7uHOX2mvv
	VJaF8JJyONHX4TnFuYwNi2dCbFuIM60=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ePztP8aQ;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781181174;
	b=5PXOPTuzbJNTkCYeMJYEZcTUBsOrNsqTrukzPyQcLo3RjX8qs2fpsSomMAunhDZdtoTxHo
	f0hIX5qjJUq1AXxh27ZxjkQtWfPNUy3ufXfYA50l1dkbBZbpmEkfNBnYXc/ZXOsbATXNaY
	HhJXZklp3tew2cdROvsGe2JCYX7E4qI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 776F66001D;
	Thu, 11 Jun 2026 12:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76BE1F00893;
	Thu, 11 Jun 2026 12:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781181174;
	bh=vpDuoAAfa3pi6DaCEs/tUqazlgd1kzXI4h/l0xgipiI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=ePztP8aQhD2iLU3urqNcWGSwX3LpkF6rDc5L4zwTynmBf8maf3O1jDhc9T2Hl6aCQ
	 wJeqvdwRwOGR1nRwV5rCfkNQUnOeheZh/5zLWxpMKjDuM8IcRl6sQdY30vmH3jJJaq
	 2tNn3QQoBPdmZdBsrngGJQnz+4XGzEZZzRV9Q3oKpd4qY7DivuReOLF5iYF4ML3aJI
	 e1ZzDmsZ9ywQ1rvhNd5bTcWFLky8KneWSf3DS/2r2C5i46O6n1/hHV9cmT4wqQ6F8f
	 /ENsCgKF8rVTRl2lJEFm3wKeDFZI9hZKV4vbY3U3TaUWYbcwM/wQjtE3ZjeAK/Bj2T
	 HOE619OPLA9Uw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Mike Rapoport
 <rppt@kernel.org>,  Pratyush Yadav <pratyush@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org
Subject: Re: [PATCH] mm/memfd_luo: validate serialized_data before conversion
In-Reply-To: <c2478f79207b10a13282d917c961261d17b86a15.1781173768.git.tarunsahu@google.com>
	(Tarun Sahu's message of "Thu, 11 Jun 2026 10:30:03 +0000")
References: <c2478f79207b10a13282d917c961261d17b86a15.1781173768.git.tarunsahu@google.com>
Date: Thu, 11 Jun 2026 14:32:51 +0200
Message-ID: <2vxzv7bpqmto.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DF6A21A0009
X-Stat-Signature: f71awnwu9sgzjg1376rsx3nappuoexa8
X-Rspam-User: 
X-HE-Tag: 1781181174-348236
X-HE-Meta: U2FsdGVkX19dRs/CkU7u8AadpZ0M1PfdHCgxJizmGjwx93NY1KRTTyNa2PaOJp+jaddXVKbLY93/1TCiMJUNOufmp5rCtyqTlvwbbUMaUPBK4UvS95gktyXagucDb4bFGQNLky4Gwhxzs+yNTS3FZ7NrqwkctoCdm4TVGKmvapOSxVwR60sPQ9TbVee5Vs3nRmEQiuPEKGh/NfUe2UphYr3ZvxYNHlbYQce1lU1ZuWl7xNL2sOiXdSaGxD6wWHKzvE+fH9JHgts4jnIFU2JnReH0IGjVc1BdxrNHJza/PS7Gr2s8LN938XhQthYfaJGV44l+PlMkSK94oSk6gD2MtTz7qJKACRg3bo/35EslK7JVkirTz5AvZtg2ey+IjvUzxNxxVfC3jjY9j1BuoMyRhlKKv8YbEevWyowsynZHmPaLpxw5bBfgabpQZoPfCsk3/AEl7Z7UxC4EbyA4TrLe/xa2NBtN+lyCrvgYr31eYr2zQIpGfttctsbWSlsJvWU2kde9KbYTbw8NEA8Tu3PyfVj3wrc7EAJUBkMsfiWCsm/bXeSRArbIFSUxd5mcwv+455eJGwx7xMhpZbRCnjmWKxQ81XXxZCLjr5bXer0i1doEEuEeSsE7JYRi/aA0+2spXBRSSc4V7No9U55AM4P8S1L5+rYx9UVTfI2+pFjsTpvXHBrMFD9FW3rcwMZGL/xp4TPjBgVEv2tH0s0L/dk1M369qDlSwxCyScHDTP02OM8E9KMrbl5LDHYxEULj48YWvKUTHtbNq9XXLPVRKa3wbgDvjI5G+5LTCp9GmXD/fZ0Pr3beyDbgg5xwJpTmkHc//yn6te0nTfDuNwGD7tc2HypD5TEtdWwydkJ+fUo9YGDUg2XqRUa/lLct6ppriFdXI7U4fe4KVEjQXS+C4mRdGMbfMJEg0NaUDOSqwQVeMXohXc0jFGecIR7zWcMlEg3S4zAQoLECWmxfamaVP56
 UVdMXkE8
 dnUQZ3AlBFHmobbWtRo5Hy59ywa8NMriBih0fXiFaXreW5HxzD5c+w4Sm7eVHNXy3B7Xfntb3t05fhYWYVLRIrdxnZgApEZyPuP+4IbF14VbBGckFsY0Q8Y+bqp2zvM5mvXeqBsSwf6THigeXy1KW7bKD3a7MHBlnZTEbfbKkbDBs4VyWmHy2YazV/Ghqi/hJpg8MiafrnF3XXEU3xA8sGMtZPdk3MXKdjQ9uH1ZZ2gRMZZY+0QtG+i5HDAv0jKCspWsM2Ed+j9LUlajhzoneanm/ViDj60RJOPy8PA1CLD74YJG/igZMHs5HporgXl0abi9yLO45P0vvVMM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11 2026, Tarun Sahu wrote:

> In memfd_luo_finish() and memfd_luo_retrieve(), phys_to_virt() was called
> on args->serialized_data before checking if the physical address is valid.
> Since physical address 0 does not map to virtual NULL (due to direct

Nit: this is only true on ARM64. On x86 physical address of 0 maps to
NULL.

Other than this,

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

> mapping offsets), the subsequent check 'if (!ser)' was ineffective at
> catching a missing serialized_data, leading to unsafe dereferences later.
>
> Validate that args->serialized_data is non-zero before calling
> phys_to_virt().
>
> Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
[...]

-- 
Regards,
Pratyush Yadav

