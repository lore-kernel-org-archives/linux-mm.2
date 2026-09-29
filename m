Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DE48CA5FAD
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 18:40:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FC156B008C; Tue, 29 Sep 2026 14:40:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D41F6B0092; Tue, 29 Sep 2026 14:40:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EAAE6B0093; Tue, 29 Sep 2026 14:40:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 211736B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:40:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B6A90A05B2
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 18:40:34 +0000 (UTC)
X-FDA: 85267665588.20.21CEB4C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1E1A6180011
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 18:40:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=atsFqP6x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790707233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yDA+pcL7IQYIQQjtqHB088yezWAUg1S+dUpzwe1IcXE=;
	b=FXmm16kRkNwY698nthdC3tA0X2OdypICYWbZHR2xp7ot4tmLeMWi9AGMs4CsPBv71HkcIF
	eZDuCTIsvYWTuEJBe8RbnTL7rUYmOPw1JOjRoH6EElSlMVKwCIKb2PC0izQWBCHJ1IJNrd
	o/sODy8xhuXvHhWIuQrhx5vbwbET8tQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=atsFqP6x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790707233;
	b=qvuB3hCjItKJ7Nvu95Zuvdu8r70kXRoQGtx5n7VCCBFXby1Q6eALpqzZaXc8UjtKXr8KdR
	40MwknoIUutbxyJFj77OgnxFu7W9r7W2TbIPCLkJvr2n2Jlqs8Fp4DoDzUGfEqRlpZSnEi
	gFM9a7OF/ZqgvTHZORmBGV16l4oWHac=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BA08409F5;
	Tue, 29 Sep 2026 18:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA7B1F000FF;
	Tue, 29 Sep 2026 18:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790707232;
	bh=yDA+pcL7IQYIQQjtqHB088yezWAUg1S+dUpzwe1IcXE=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To;
	b=atsFqP6xdrngdjq/FqsLK5lxp5gYUSMSDrKWFJXXMcabyxDn+FSFmeK/E4zfjwlAJ
	 zOjhQ+UigNp5RblAtNIJs+Z/dwwEdt1A4Ky40K45Y8sP+MdyeTH0hsRwPrXm0co5MT
	 4/f5Gj/L9e3IVLtxh9YVYJDZs4/UHw9HL1Y+MCeeD4yaXDTPHHNWNEqLcygzwtEoLD
	 VjfoyWEbfDQliIH3ulLZuRVJtSFJpJQ4df2gGQRhGSSC4UstvZ28htfaPod2zYULg0
	 iASas7W75GDszMGgNadKO6AcYVRGy4bTpQqPCVjCJVhs/QMkQAtqCnxAAPuZXmBxQ8
	 xFOxALfiFcuTA==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 29 Sep 2026 20:40:25 +0200
Message-Id: <DLS0QEPJKOPZ.1MX607W2OQ0RI@kernel.org>
Subject: Re: [PATCH v3 09/11] rust: device: expose dma_coherent()
Cc: <sunke@kylinos.cn>, "Miguel Ojeda" <ojeda@kernel.org>, "Boqun Feng"
 <boqun@kernel.org>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>, "Daniel
 Almeida" <daniel.almeida@collabora.com>, "Tamir Duberstein"
 <tamird@kernel.org>, "Alexandre Courbot" <acourbot@nvidia.com>,
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, "Lorenzo Stoakes"
 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Lyude Paul"
 <lyude@redhat.com>, "David Airlie" <airlied@gmail.com>, "Simona Vetter"
 <simona@ffwll.ch>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, "Sami Tolvanen"
 <samitolvanen@google.com>, <rust-for-linux@vger.kernel.org>,
 <linux-mm@kvack.org>, <dri-devel@lists.freedesktop.org>,
 <driver-core@lists.linux.dev>, "Alvin Sun" <alvin.sun@linux.dev>
To: "Ke Sun via B4 Relay" <devnull+sunke.kylinos.cn@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20260929-tyr-ioctls-v3-0-26955fb111d5@kylinos.cn>
 <20260929-tyr-ioctls-v3-9-26955fb111d5@kylinos.cn>
In-Reply-To: <20260929-tyr-ioctls-v3-9-26955fb111d5@kylinos.cn>
X-Stat-Signature: d6hsgtz1j8budypr3g33hqhn654aftun
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1E1A6180011
X-HE-Tag: 1790707232-363744
X-HE-Meta: U2FsdGVkX1/q5e6BG9bP37SMpfOYps+AeBRYmjHKX7DPlCp48kv4x6Egom84+iJZlFNr4a3850ziv5JaMCtq6BN6C+9zK58ZLrtt7gT1oYBS1Uv33HHzdvWVz+Dugtj5g3XuhN7m2G5PV0cNcX8Oas0aZPnKdm7cuLMl4iQBHfH6xcGVbi8M9MbYqmiKBlosa+b/l8ZzOajz5evU4ZX8Cw6H485SDqOd/Jop9BRbedmV5IaOud/Zt9vBvw/tly72ds7ycBsVCYgIxzuoWzmYKwrSZDp5VrlSHjBC8iQychTa23AMKEJ++TQ0EE80p71p/jPUXXc1eXeK8nVI3YadmHKYl5EpcL6M2+iPcSny4TJ7vt10u2rWI3SY/hANUrZH9k2T+b2IpIuEaL7hykr2rstNq5znYx4alPM8pjPGVsC7ssXnPgKncn/viIZ6ZgF1kjVQaECp/Ue7KLkyexHozY73IRkAmTWVX4fFVTl9hPhxtU5SCfP5m1rgur6NBSnrwCxoj9GTZa3hLWvrEbaKvsrJT5raifoHEqZfTUoEZEQYON/n1bhgSxdn7U0BH6ODCJdg8q1r48KWltuTDW9eODGZsHaj8Hb1sm9wFPIiE1E/UX13ugtqY3JREVRe3/3fhuByxS1BeQ2UjMycx0DQnOb1XzOWWmR+1gToA63/OhuO/tdF5NVAVReTaJlhh1LM6N6Ombdw5cnZR6a93e+ygYYtR0DJmEtb4Bbr+EcGVX2Uv/U+UDrzCOsq0lSblWqLQgeKUuKSbv2zCa3ykYE+B7zRMPYgYAh+vhzcHC/Q9Ouf01Jt6o2bivLCpB2iItrliEluhScVD8sXSucTc6voriRrZJfQAobFf1u4fglfFf4KNeg3iFPCdMmHB65gtlTDQJGQDohZpCoUyDSHh/FJvvh2IYp7BknXoBcIFIZ7586vTZB+44sybsUObrkkIRzcBFnZlCJP3oLetaI82Qk
 PPruVCyO
 zrzHqY/zDZ07GDo6BHt9Xtyg+nSjiHWKG5QYowsqVJg/wynYKD3XcF4dZxkpJ7YqhxwzeZMfnfWjc3zjkOuQrJooTEOemwzq9IBze+SonTWnfHGf4mLCd95rcv79zJbHQhLIcEDlQwfoZwV9V3nfbzYUXiBDJMX3hXdOEYy0jMpvsi1lP3+gWw0mVQAl4DFQC2IaTfIc/wFih1xSP2E1nJ8vecAAt9or67SZ63tH1cWFMCxqr5mn9rF5ZtUHMfpT4IPqcVweQxcnoN0LufDW8oVnlkVYaglpW4/lz1egsPRXOFt26hwAgP0sLQlKELaykpd5Rwt03kHSRu4HhMdZ3+j/Rg0dr2mtfLwi9RuaUCLW+lfIk6J8Zb14CYl9caa0I/cDZu8NtHNTLF1N0Nwe1SwXq6bByhmWVYacmYlHICnnK2pK6qoGPr6QAmr2WumroanvdhOfMTMUmd+s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Sep 29, 2026 at 4:15 AM CEST, Ke Sun via B4 Relay wrote:
> Add a thin accessor on Device<Bound> that wraps device_get_dma_attr()
> and returns true only for DEV_DMA_COHERENT. The other attribute values
> (unset, non-coherent) are treated as non-coherent.

Why not return a transparent wrapper around enum dev_dma_attr so we have al=
l
cases covered?

