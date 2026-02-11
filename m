Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02977EB596D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 07:31:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 205AF6B0005; Wed, 11 Feb 2026 02:31:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B3D76B0089; Wed, 11 Feb 2026 02:31:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 095EA6B008A; Wed, 11 Feb 2026 02:31:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ED41A6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 02:31:52 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 83A941602A2
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 07:31:52 +0000 (UTC)
X-FDA: 84431356464.13.3A7D204
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0713F1A000A
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 07:31:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FnVgslpE;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770795111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9EHT5RPp8vQoPFq66jLsuzFX8usAoEHMFqqYHfAXIy4=;
	b=R509yH3a69SCpBQ9lG2WvOPNPwIW6Km6k7momGYyXguQpKoP93Qu4o58SrknbcwjgMZSW3
	3hljyan+ONjZIw0XvXk8Mnwz9Xwi4uVb5Uuvq5rSf+zgZJ3zoM9xBU/Bdmr1hMJsEbK7Et
	c4h/FSLGzA2gHHTvF6Wb96uXCqr2JG0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FnVgslpE;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770795111; a=rsa-sha256;
	cv=none;
	b=Uism8vo3ZFDOf3boLCOf9K/q/PDyvAc8LN8hovUPTmu5N12V38JPN2W/XguTPDpUYJVtgo
	tui2CQlpqMsJzSog2YnKoJ5ZGf9bLRq+AuqohZapX42Uam9oc/LrslBB6xB9F+8u+0y0kh
	s4cJrmG+I2LCNc2DaEz91MuhDZdwC/k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 672E160018;
	Wed, 11 Feb 2026 07:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4CDC4CEF7;
	Wed, 11 Feb 2026 07:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770795110;
	bh=9EHT5RPp8vQoPFq66jLsuzFX8usAoEHMFqqYHfAXIy4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=FnVgslpEPhRjjL6RYtTQNqCbKEATWjN0B8ICj90sRkoMPaEMjdXjHqZQSplCR2nYZ
	 7j6U0AqNPfbsy/y5RX1Y0v9JGIQbfKe3ppRjAqnEGUeDNlp8LBCi+JmBLhTTvxZbh3
	 3crroFO0FA0B4DR9Sh91iY8ME4aaJX1CpAkDgDdICILPEtgpvbmAeK+qXTxiJy7s2P
	 3AhTAdCa/5g9wY/hdD7FrMSRdhDVTxyK27KVaNC1UjdLacfrZRrOxdPovVXumUIl+y
	 VZ7rx/o172F6CiYvhwXMfHJgco2SqF09Oc1gcI/klsb07SDCJyDbWbF3XXZr1XS1BA
	 d2ynYI+qAetcg==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Tamir Duberstein <tamird@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn?= Roy
 Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Alice
 Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Danilo
 Krummrich <dakr@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Christoph
 Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman
 Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 03/12] rust: xarray: add `contains_index` method
In-Reply-To: <CAJ-ks9mF5x5mAUcfN6dWN-NWoaE=j-8h0y_F5AM2Pnfn8RcV6g@mail.gmail.com>
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-3-f777c65b8ae2@kernel.org>
 <CAJ-ks9mF5x5mAUcfN6dWN-NWoaE=j-8h0y_F5AM2Pnfn8RcV6g@mail.gmail.com>
Date: Wed, 11 Feb 2026 08:31:39 +0100
Message-ID: <87ikc3viqs.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 0713F1A000A
X-Rspamd-Server: rspam07
X-Stat-Signature: km6ntin9o78xdf5rrs9qcxuuyzubs8qj
X-HE-Tag: 1770795110-751880
X-HE-Meta: U2FsdGVkX19RfZ2/kKZpmJWE7ZdbOr1N/Bk9pWg1HWeYg+/vO9+b1Lnwkk21kypakHXiq6TtTouVloDCthtnrTmgnNoCGW9INPIRfhl3ayNjb8Ej8dcITaFMm4XhI9QfpY4LnKMRHbDtgQ0b1fRkidnRRxNQcc+oeAt21ArqG1YndKpWn+SVaV3YsF4wTlUk4Cp/e9VJdlVNtlnRva7//D2qQQONi5z2UP2KmzspNiWm2VP7cdm6RhKB1ZeAjcQFHxaz5VSeUJ6usA3RdcacSi/jK+MQT3KzgB9F17k72YfHRNznkfJaLdfKrl1WLlSLn1PNZyvZSXeknF0JqH1zp0QRHqMICXXx1r+tODjp/z4XNec3aO3hMYil4qGacwwknOBo0WNE9Es/4Ok/8kR18TUWTSSJ0FRH/ORfGfGMkO+gfes+Lc9nBXD/JHjRun4uOb2WvVZ7dWPu/cuUw/xqC9XUUMk+VOXgRmgD+UosNfFzXz5nqKOinNpMwgdWCJxfE8M7zTltHd49+zEVASZdr3NvyA2+jONaLxXw9KbE1EEohddhkQUUYjPijHB3yRJN9CD+w5EoqBbmObKVHVaFdz9gk8FdKshmTy9ion3M6pRuo8Lg8RQioRcfZXFijD0SHfHr3CkmfuZuNa1F3G9mPILJB/gKOSVR2Bo2jH0CvGgk+7R1xVlNEJTrKgfVrBT4DFmNu+1/N5EsYv8PDM0wQLHJI8vIdKPNB9TGl23N6AUWVy8QDy80CVgklmxNzd1P3tevGvOm7WoCgz1cMH2dLvdlJS3wXBJYhcHKk9DEVINQZn0c9fgf1Z8jMc8GfNm/GYbCHIjBCfFCsBUcuWNLAmyWv4iQ+s1M6n701lwdrm2kCB97fz9Wa3GVHHFOFikuV3yPnmK1H09TBi2xdcpknc/kean7tC6B4PG3GAbWPRdCe1m2LhkIgEjA26h8QFQtN+jAAQxg2TzhRWHRhsN
 pMGvmR2V
 Fcy3csV8AdxMJilICl0MyDA6C0DMe5hF1v5Xi2kR/xI5gfe2ir1oXNCJXTTCXQ/QFwXl62JNFhIOM1HgJ4d4LXS7AFmkhAxPO6On4tqH/jiIFu0oESFSX06dayxcoMKo2nt+gfuw531YmeT3/EIJtfNAbftBwyCViMC27oxjcu8IHkHgopyGIZcY0prVhwmZWMhYLQnSZhglRrF6VWBUzjWoEgiV1fZMmj3bBHThwEgdppbFnfWKTh3SrgvQN/VRHw+Z52ii5vBtFV+EaRg8/+CkNUYj9bfuruCvFAp0PJeMYY8VgcEHweugrwJEvP2kynxZevbH7eMaYIyywxlDXfGouH4W62m+F6OJNYohwIndpY4QLpz7D4glsLEXlrSXKjsrVP5irgwk3c82r4QzZ/yrtccXEHYDcyfUkQDs7Lon5S80LTCxuE4nXW04WP+afaLtWChCfnF3044f5F9ArT6FXLNg4rdNAg5cmZhH7WkhGJRhEuuwjxBlhYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tamir Duberstein <tamird@gmail.com> writes:

> On Mon, Feb 9, 2026 at 6:38=E2=80=AFAM Andreas Hindborg <a.hindborg@kerne=
l.org> wrote:
>>
>> Add a convenience method `contains_index` to check whether an element
>> exists at a given index in the XArray. This method provides a more
>> ergonomic API compared to calling `get` and checking for `Some`.
>>
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>
> As I said in v1 I'm -1 on this change. As gregkh would say: it's hard
> to review a new API without seeing its user.

I already gave you the user inline [1] and if you wish you can also see
it in a downstream tree [2]. Gary already explained why this is required
with the current implementation of the borrow checker [3].

Best regards,
Andreas Hindborg

[1] https://lore.kernel.org/r/87344gh2pk.fsf@t14s.mail-host-address-is-not-=
set
[2] https://github.com/metaspace/linux/blob/aa43a6ecb68a785a90e167609aa57c5=
a0860d123/drivers/block/rnull/disk_storage.rs#L218
[3] https://lore.kernel.org/r/DFK801ZCI1GD.34GWJ10JZBBBF@garyguo.net


