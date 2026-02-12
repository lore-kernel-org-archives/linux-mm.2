Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7423EE36AC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 17:23:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 224FE6B0088; Thu, 12 Feb 2026 12:23:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D2676B0089; Thu, 12 Feb 2026 12:23:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DF8A6B008A; Thu, 12 Feb 2026 12:23:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ED9D96B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:23:46 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 825221A0276
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:23:46 +0000 (UTC)
X-FDA: 84436476852.15.53B04DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id C3F94100005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:23:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J1jfRton;
	spf=pass (imf14.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770917024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=so4QGrJOcY7JuWr3cPaTVDLZ62UF9pT/A5r7PuP9lGE=;
	b=gwFpt+NUP1mW7paijqgkLK9X1cScHPJ6KdcVij1FZC0cqHFZV75DWkWPPWYoEiu66D5bFo
	hdd+aiZUeXDjBWogkGRXLRbBa5L0Z96COJJ8sixwDzuPrLOGYar+93zNzwX74pCbDmSQjX
	B30+t+F9IWCiUqmRfCnQJp/Owba88M8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J1jfRton;
	spf=pass (imf14.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770917024; a=rsa-sha256;
	cv=none;
	b=vNgB/ClsFL3mi/+ftctbaGjSbnVAAhi0M/rPYNgI/DUb60rv8sj0X8FPts7NY15sQ41ez9
	hPrkFp1WigRwTT4Iq/IlMUVSOtCLz4KyLmndJVR7rw9cbTduwGPstTGMGz0iSXRqh0XfEo
	/IoPfU2W5QmY+uZm9hgYsHXZ7Z+SCJM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C63B3444FC;
	Thu, 12 Feb 2026 17:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5109EC4CEF7;
	Thu, 12 Feb 2026 17:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770917023;
	bh=so4QGrJOcY7JuWr3cPaTVDLZ62UF9pT/A5r7PuP9lGE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=J1jfRtonQwBnquYFfzu5ltBwES3ulkbPUHEzJr3NS9bM/5ujnYx2dHiY5ClUTTrwz
	 TxmEErZT4EpfFh8es7SLaolgKnOY3+Khe6QdldXbDuRznz/nxlsdPL+gd4HdpEOabD
	 wYU8Rr2ux0yKbiX3RJHSU67TF/TI9d2TAm2AjTaEiDoKZo2NIt7xsrxHVRJBB2nXGC
	 q12bKAPrmLpSQZATzq43PHoTZ7lZabJxmJy6HVH2zVwM0EWFrOMV39Uxm7NcstzZmh
	 fpWp28cmSZQ+TUn8DfmIDgh3ju70sHzNonuv/5QvInrFJqZVGBmXv4MPQLjr20Bt60
	 dW6kOVdhg65Ug==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Boqun Feng <boqun@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary
 Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Will
 Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Mark
 Rutland <mark.rutland@arm.com>, linux-mm@kvack.org,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rust: page: add byte-wise atomic memory copy methods
In-Reply-To: <87ikc1ubuy.fsf@kernel.org>
References: <20260212-page-volatile-io-v2-1-a36cb97d15c2@kernel.org>
 <W3U8SrC8rs4Ivq5fjTvV2BD2K5BO4RxRg8tyWuntERIaS_RqDgtfBq5y0zcnazWgNJyT5ECvutnzV9d2UPDzOw==@protonmail.internalid>
 <aY4CuCtBfkWZne0d@tardis.local> <87ikc1ubuy.fsf@kernel.org>
Date: Thu, 12 Feb 2026 18:23:36 +0100
Message-ID: <87ecmpub8n.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C3F94100005
X-Stat-Signature: 8mxxgqrendh7kiq3z9nnucmshjte3759
X-Rspam-User: 
X-HE-Tag: 1770917024-155077
X-HE-Meta: U2FsdGVkX19pshZP/K8ydY7NDzJu6QBZxzU5ZtTzs5EqB/uU9C7IfMzCxWi/MrztD0cHLxswfHQprezmiLjbZRq9eK5zFjKrse4pF2OSXjET3bJsSrQZWYAoawiO8CN17R7YbWDdU7EGjbaiHabUrHmUIwU67h1gmjEka+SMZ3NfO6vi/J7tIwB6iLPAir9m64RMCcp53PAg7i2TM8oT+F96iqcOkCORvYUTf7W1kgYjMHLihvbKkrE5bSc6H9w4M8XgcOuiy/rj8temLI/larNVwnqWG0SBPI742zaflG1w9LvmCHX7uUEZ7E46As8dWK1H4l7lv2hw0mBmuu/20eJHGIInOMDC5I2x8Vi5e728JycOSwOU59uUKRAgkpsq0aG8rbhKOuzzyGygIYml+6mHuG9izJr7n3KEq4H/0R8Vft82ycQNb4dfIwJOEqIhAT4exg/wSXouSpMnLbCOF8Sn0hd1QUavSP6ovHzz/N/qOA3mRGAV5lVP8ZGXWAuugxFnJ4Fce1+2emTTZSYz16A63yfesSQBoOFu9ZUS4LWyR2legPM9BoLtSWlWIMrhaXaXueNFKkBxUYHISAy0FRIjClcQ9zF5zGhMmu6tKgaMkduSj7M4bkG4Msmx7qzq+zaCKRN5gYKWARlb/+FGXovvh50WIDwrxMxpNVzRAgagDtni/e6Lq0jjZnSwIsS0ZKHCCAoUBLv7Nvp9A3eZa2dU7gcKOsNlZCMqbOkRsbJwuPyAB11JUhuoE41rRFW8xehQm/XWL9DzsnK/Oajc6BZrhXyn/OyjaCmhPmLJuBbRTQSSqw2Vj7Iv39vLY7oFOSYfQGAVmiKVFJM8vZhCHJ/mW7jeh7HKffUa3wsKnnqmDIZiOFXlSJu80W/xqQIXB3tj5xKO2OqejJVYaY0v5MBIi+89S+EKbFZjBX8CXfTVPQ/DA6uo0X5EuIPcKrGYHbKe3sYP57fpscdx0JZ
 NeexljmX
 IEE8gMafWBUHEF+pY3mb+e5YPcX5vd2vKuKnhS3MC18fwfAlebmTb1Edp6NDCqlYLaHbQSyv5Qks6unNm/mnqXPavUEstjmIxgz/MgUCYG4EVi/QZwiisL1Q0WVWm0zEW3slFasGdKXvei3Nvb/X+tAiBq/CcbeWmU5TGbpXFn50vXiYZyXkDdSyYJfaddk+oPsbJhRo12WOPA8LSJGuYMfEtC7c+qnEd3kR48xaUWEdk+XyZYtSOuQql2ad27QEHGuVKcKsJjGhjuobafwVaUJOdu4kIszULAXGmYc5JSqJ6l+0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andreas Hindborg <a.hindborg@kernel.org> writes:

> "Boqun Feng" <boqun@kernel.org> writes:
>
>> On Thu, Feb 12, 2026 at 03:51:24PM +0100, Andreas Hindborg wrote:
>>> When copying data from buffers that are mapped to user space, it is
>>> impossible to guarantee absence of concurrent memory operations on those
>>> buffers. Copying data to/from `Page` from/to these buffers would be
>>> undefined behavior if no special considerations are made.
>>>
>>> Add methods on `Page` to read and write the contents using byte-wise atomic
>>> operations.
>>>
>>
>> Thank you, but in this patch we still have "the given IO memory" and use
>> memcpy_{from,to}io() as the implementation, is that intended?
>
> No that is a mistake. Please pretend it is regular `memcpy`. I'll send
> v3 soon.

Sorry, pretend it is `kernel::sync::atomic_per_byte_memcpy` ofc.


Best regards,
Andreas Hindborg




