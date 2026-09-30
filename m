Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAAA7CA5FAC
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 12:39:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2CCE6B0098; Wed, 30 Sep 2026 08:39:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A03FC6B0099; Wed, 30 Sep 2026 08:39:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 919E56B009B; Wed, 30 Sep 2026 08:39:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A3286B0098
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:39:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0570080798
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:39:53 +0000 (UTC)
X-FDA: 85270385466.01.FC24F3C
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1292C1C000A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:39:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OcSie0ea;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of aliceryhl@google.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790771991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=puIJOSdAjxGqRiaiV8MmV9MmKvzEIue4jK9dygO9uOI=;
	b=Z7n9AXywz8pauuYxqBNN0bQXtQiBsEybaJs2KdnSkdveIRO9JqO6EnH9eU7TRd7GKmiIaP
	xbzV7c4uOJ5QDjkTxBLWIBkYEarFx7uaFCLklm2vvzxomQpZOZPO6vGKtg8UfW29Mu0v6x
	MLg2D+bI+vRVrBnUi+6GNZuUDwbinIg=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OcSie0ea;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of aliceryhl@google.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790771991;
	b=maTN/fAvv726H32ukdhjOwASethpXpG4naVZ8bSZ/quihUliUh7Z99TCguf4zHRLDwJxNF
	NuPmxM7p1Zy6lji1qAhKCeukrKZ1d6c4KGPPcrEjN9Y68BV0DeFzFmJvDc9aHwjDGfGN1U
	dBphBFYW0NF7XZJyL1dTkvMljqd4Gb4=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d8239so43159275e9.0
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 05:39:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790771989; cv=none;
        d=google.com; s=arc-20260327;
        b=OTkMSnfLbyxHfUUYLZv4hdFM5SixfTfrwVIQCEzVsUIJI9Vs8RqAsvG9HDWMgfj8b1
         3wsK/l8sEOMd0E97kpMZDKYEXkcLH7DZwjRzj9Qg504xTm+/7LmLELWzWaEAdpspu/DN
         XZnysPrAQy0ikrYDptAbaJTfWNQK4xCcH6NAHpQgwoCKz6IX9BbHR480Ti/g8aIWHmGs
         QNZ4SOkk6OyYYBq5gBAxePoPQtmcETRWO3IrLh1W2ElIz6N9fOEWtni2g+QME+rC97L3
         IOkiaVgg5l68RbMCcKB6tu+SXeosUmnljIwVy2GKwygzRuMesT0AhAQ0XEnu0KqPJMGp
         2GqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=puIJOSdAjxGqRiaiV8MmV9MmKvzEIue4jK9dygO9uOI=;
        fh=CWkCIIUoCMmbn5s4tzKdbG1Nnrz+DdPB3BdKmEia7Ts=;
        b=ZY8oqI6JUZOkns0QgR+l84Fw93i6xtYCslN0EE6ONwfhin0CiOS9BZ3kEzDj6rRZt5
         aGUjZfqBlUA8/UajSmBssiKOfgvbyHXgYMcLPrI/0/M7co0ozM4c3+tdXpGxvFTL3UoX
         KGFQcHKA/y/GSIDRU7b3zEMNbS1lwznxydvlPgvpss+jrhI0X1QVXSofsC9cAbz+fZ6d
         hbh4iUH9rjDS0LTtjGBz8qOcopoY/Dsm8LNDHFm7vHcMbyvkAGPNJf/m3HuVS67RE0h+
         KYjexODvcRo+jVkGoCYt5HktLu/LwFGr5PmwLkRlfRduvMB2Oo+sxMuwDMs+7fwr94n5
         B3ag==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790771989; x=1791376789; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=puIJOSdAjxGqRiaiV8MmV9MmKvzEIue4jK9dygO9uOI=;
        b=OcSie0eaKAvOcd5vniTzocyvQe1Z0+Ca6GiH+vlIT/tHueqA4nEPvP7Vw6HI6wQDLE
         5jFJBaQquyJkHbELcKsbPM93zswDCFQ5o3rIDj3myNYoUkFY7uB2yGTpK9IWOoAiOCBj
         LTOcAxoPz6MXxuY3QsJOjmmVA0iOjqnQ7krYaJt8rx+Yg4KrF6rqYF82Fu/N+sVHmAa9
         SCNDYS0w/L8nrg9t0pH5FFIxwrR72hN615Po2TEpumwBsSYVzhJ13me8+nRhpJxXrbhG
         fAmCkxNThpwbBGjFXaRxPzeO4go5gjaAxJsqkpp0yW7AcpH02v+mDUfFZ3mgCkKJSITz
         ZWrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790771989; x=1791376789;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=puIJOSdAjxGqRiaiV8MmV9MmKvzEIue4jK9dygO9uOI=;
        b=FQytmThon84UUcnsA+JbVeLvC7Q9RU7pYSpmPYxWcUIiaIET1TowmK/dOdxvFP/0l+
         aLoYi+eK/6Vc0nHWVHXtuijX+6YVKb+TH1yTn76yTHJgYP1gJsNk2e4rnZd2PtrK9o2L
         4DnmM7J7gKU4ylh5lHqRwq44aDxXH2cD4o5ng+KOqitJ5yzLeSkh6G5wSsQpdhbat6yO
         jnNYzbZjg94cASPaHfQneHBKn/+pdqtaSnBIYsQL4gmmfWGe6iJWOausA+DYlkzfhMNi
         +fgk00KNAfjbormFzhxdi610J/95VOQifWwujoXKCWqtoIidyoVt/+VeVW2/XiaFwneu
         Hwhg==
X-Forwarded-Encrypted: i=1; AKwUvBw2iFXJYYGQVlDisKDTNACjPYQSPM+fiIPtQuNUAwCWel8rCVKsN6so699lSXed5CzQM7Se5qfZ1A==@kvack.org
X-Gm-Message-State: AFuF++lncdbCSPyf8VTEUFFW7ddB6DZVR8XdroiXchlyouOrkIyNSa1Q
	yi/bX5B+yGZs8ja2+84zzDD2oXHHoH6cTkIowvXe8EycqgCouLqJO2yzZWaXGogr1oDnuwPry9H
	rxI4yPviSlJAzkxSSL+z8FIo0BM3l8hslOoiAlXaR
X-Gm-Gg: AYBFou1kgZDIqMtrwMqWpFCZWPvVDkuSu4BVneWc+4gkIIrfBkGCMQZsRArYJbkF9q3
	kGiR3boeRPHCY8myk69w5k1YGYcAfYcBqmwGujRm2wI1Q00fywb1//Mwlj3IJpoBbHsO5owV5oU
	WRq3diQesODqOrgXVJB8u9JawZ8p7bOe4flIzCRiZYzXC+D/+v509JVu2nWm5a4YTDDhkZofgbt
	uOCc8YUp3FijMeCDcoUZNZA3Jg5s18jJtOOjDJc+Vxd380jrpiVu4azimwmiAIGjgR2PDluQxtA
	z1RmFTIKBkz9Pa95zLJX34Zoq94SzYl/Vsyo1K03MaTbR1QYky/nl9gV8MlWsMe1vgq6WVgt1BM
	x/Jz4jFFx8eZgrZearCVoY93GTENKopjYRhHDwDroZuHZwDcv0Boe4HbBKYVkQaE=
X-Received: by 2002:a05:600c:45d3:b0:4a0:317:1996 with SMTP id
 5b1f17b1804b1-4a01affb6e0mr19906585e9.27.1790771988560; Wed, 30 Sep 2026
 05:39:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260930123645.302318-1-ojeda@kernel.org>
In-Reply-To: <20260930123645.302318-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Wed, 30 Sep 2026 14:39:36 +0200
X-Gm-Features: AclHuK-nnHolXXuoRh47s39oDXL_U03hT_173aRcXTb3_dZm8vbu2krhGYddJ6c
Message-ID: <CAH5fLgi067ZcHT-F641tMZ-2cUN_7judeK_YTTrmX=OLqsNtnw@mail.gmail.com>
Subject: Re: [PATCH] rust: bindings: fix VM_MAYSHARE blocklist entry
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org, Boqun Feng <boqun@kernel.org>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rz8eyo33zuw8dxet5rae3abjm3pknyge
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1292C1C000A
X-HE-Tag: 1790771990-565835
X-HE-Meta: U2FsdGVkX198bfgNY/HTYRUdE7fm9eh+CpS64kaO2QOQIsqz5g/5v/G5dzoWOOWGdaIQk7020fDN59SUabBk5QvgHDtfBIN3Zbd6h6ufxJlRFjkyNXao3kY3Gk9Dq6i2kQeaQwuEfrg9IN9+wI40nQTVEYHQDoMeBo5Ym4lyL2phoE14Dj5FAc0k+BhOXHAevh+dmgsOwbY6vkb3qW0rRgGXFJXHWN2ruMPeN1bPWQ1AIY2EovX4Xwho9hSTLd/DGspu/FKgAZQW1y74zhUmXpVmpBOsfgqtE+CgRABXvIb5+1/okI9j6aMBBwRwBaTUcp//BWeDIMgpsi/lEtjnUnHbqrwBUTRtuDv28vhvX1mSCw8ndzz7c/yR9sFC24+Ey7tFJlJ90Lq7fnlDYXvPHG+wBmlwVsjz7k0N5Gr/b9ABqrYrGNMjC87ugZ1Pghg6kee7Rl/h48JkXFRjV6InSJjI5GZCL1I1LJ752NM9tvitxVVdvq1HrTj+ytOYknkHAEfgrHcaw3W6lGQaX/MZd3cG8r/bUrDaZj0UF817z3vvxe0NZ1al5RzQfmS6nc7CbMfJwtlaDkQwnyQeoWVtNik9jqgQQKyHArvZYB+Qa6Vk+bdjwjbUifiYAN1GcgHVDusz+Z24ZRVCFzN4abPGERfuxR5J4lnhdlQjtKLPDBz05ThLcbqb65u72fFmAc7u+Hb2jbvFO0CdIIWMUYIYurNAHJ/eCGnM9TlbJyjH3r8RBvstcxA9E+t9nOdZ6Pbet+rGeVpFArErlPM3P10r0TTvUrMb3jeAck/H/x6mXnDM84+d0soxcrLJh04onnNGz7lLTWNoM6sNYdUrhZA/NVvKhtFtCSzJDCewYKjXMRM/tsiLD+QFU28xMtYTBw8Yij3v8Paw9wgT9uq4yxl+qzzcfBRaymZ4GHliTHZ4EDXpKdI3u4fSO6t0hglwcAFLgIrTyBxkXdzN1SibMLk
 Ggf+F/Ec
 aBWf+Pi9fyB00COrw81O8x7k/sBzOWi9fl7J7hsxU/x/S4DgJNm2eYHv7D9CLfZ6gWyA/MkMJ7hz4i5TLbKLDqx2+Mb05JKSF/AbxZ0DxfTO/kzopQPDo8cVYJJTyAG7G0O3tgHNOexIY7ya2jFf0u50ri7A5L07aFnqRkcJY8rY413qXEtGvFi+48ntsDTcIxR5MPqpe+rm74DAOwCUDWSoXWlbTD5j856DpkAvWV2lq+DUZQw1bbDYeQoC0wDJa0jqbW0Lubwc9nLGg7JWHYaTupGr0DWLGPvGG0ggfWhDlF9w0qOWTh9RaFU62AX5XfR49npj4+sQyz1E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 2:37=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") added constant helpe=
rs
> for the VMA flags and blocklist entries to suppress their direct bindings=
.
> However, it listed VM_MAYEXEC twice and omitted VM_MAYSHARE.
>
> Thus fix it.
>
> Fixes: 2b6a3f061f11 ("mm: declare VMA flags by bit")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

