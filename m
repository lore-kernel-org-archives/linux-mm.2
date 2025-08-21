Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA2BCCA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 14:32:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E0136B000A; Thu, 21 Aug 2025 10:32:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B7B96B000C; Thu, 21 Aug 2025 10:32:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F4936B000D; Thu, 21 Aug 2025 10:32:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 027F36B000A
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:32:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AAD431A043B
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:32:47 +0000 (UTC)
X-FDA: 83801005974.19.4AD882C
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf02.hostedemail.com (Postfix) with ESMTP id 12DD980015
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:32:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LC7F2tmG;
	spf=pass (imf02.hostedemail.com: domain of dakr@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755786766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lt/7OW4Wkxdu2HOD2pSmNfQC+quFLTa8XcJH2OMogZY=;
	b=itQtdvpJVACSDhsnBfVk0Px4cfyXpAf1ZrWmtByu+JEn6PUhy5JUD4NDL+qrxuLAyJmGPn
	qgSkEqQ2u3mGqCt6i17w02FCFOSiJXSPYyYp8+CZKxuoSL21NHBro7ruMz7KX7Xu+g8jfg
	I/EMExZBBhkbNxsmEpmsw07ROfUoYCU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LC7F2tmG;
	spf=pass (imf02.hostedemail.com: domain of dakr@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755786766; a=rsa-sha256;
	cv=none;
	b=TYpCCVsMayPsQkdbwVNUIvf9bJT/h0ENeU2n5uWgRHvGUxq618rnzA/QGIRYayG3inW8AF
	QezEpf4k/foBXoD8Yx6KwmSND9RtswtRX43T7Ir1ithsAz4W4bayx6oWN7F214JKUwK9uE
	TLA1mnqBVH/G51dzEuUFz+qgmVZDecg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 4C508A5847E;
	Thu, 21 Aug 2025 14:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E21C4CEEB;
	Thu, 21 Aug 2025 14:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755786765;
	bh=OcH92vAjTX0+vo5BSHLDcFy1Wdx4BKrILtb6alAg2ws=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=LC7F2tmGYn/sJkAKGyEaQ5akRdZS8hmzcoB1z+V8Vy3Jduel7MgAM8YiuTjwxVA5c
	 UL5w/1VDFi2AKRlgnhbg6yCU3QjbhkyBLyr1SnkWut2usA3FoKIBHZZoELQdeyIbDf
	 x/9x1HboPymNqvzNvkLb5wZ/Dof8lPnv9+9orc+CuKq2PJya+0wDaxS+viBn0vzZm4
	 ZtGTBTVbg4EF3m8LhVwTNnb2YebjfTtfV4WguUOHJ0IADl/6VQ7moTcSb3Sqx4oN4Y
	 QTOpO4MYs6ikMQcxsc9F032OYRrRZi+OBJl1gs3JcKQmhPyMB66pW9Pf89C/0QhJij
	 lpkKytxdldIcw==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 21 Aug 2025 16:32:39 +0200
Message-Id: <DC86GM7VK8PH.QYLPP2SLYM3M@kernel.org>
Subject: Re: [PATCH v2] rust: zpool: add abstraction for zpool drivers
Cc: <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 "Uladzislau Rezki" <urezki@gmail.com>, "Alice Ryhl" <aliceryhl@google.com>,
 "Vlastimil Babka" <vbabka@suse.cz>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 "Miguel Ojeda" <ojeda@kernel.org>, "Alex Gaynor" <alex.gaynor@gmail.com>,
 "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>, "Bjorn
 Roy Baron" <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>,
 "Andreas Hindborg" <a.hindborg@kernel.org>, "Trevor Gross"
 <tmgross@umich.edu>, "Johannes Weiner" <hannes@cmpxchg.org>, "Yosry Ahmed"
 <yosry.ahmed@linux.dev>, "Nhat Pham" <nphamcs@gmail.com>,
 <linux-mm@kvack.org>
To: "Vitaly Wool" <vitaly.wool@konsulko.se>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20250821111718.512936-1-vitaly.wool@konsulko.se>
 <DC83A2M3G8EH.12FRM3C05ABCR@kernel.org>
 <DC83WSYHY3K1.1D3XEES0BIKGS@kernel.org>
 <27139676-8470-4067-b259-f01022751bbc@konsulko.se>
In-Reply-To: <27139676-8470-4067-b259-f01022751bbc@konsulko.se>
X-Stat-Signature: 65he7k8srqxjgjzuhztfhxz69ejebrcg
X-Rspam-User: 
X-Rspamd-Queue-Id: 12DD980015
X-Rspamd-Server: rspam01
X-HE-Tag: 1755786765-224780
X-HE-Meta: U2FsdGVkX18L+oRIe7st2uoM2hLJ5YSAk/4xumkqNORjJwj/cvbqz+UxlBmcUdVwjMNGKGE6Pc8QI6eI21PUkrhUUt+4KOuLR0B844yJ0MoQwm2Bbv5f4dOs/K2uyc5AzwtU+hMw5ONUyCK2rsVQn3AHwqwpQyW0oPj98N7qRHB7WtlpTRYg69rJIwWmh0tb91dVq4tVJEjumJ39jg5t+KebxZTazdSULSbcY/qUqHFoQIF6Wx/xtrqQr14ZuNACKdPLogPBmyGm6FfqgXeCIW75iHiT/tG5fihRgyWtjI8pjzKa7RHk2X+HdxpeCZMnqAfyTwSe/YgxaQFz9Ykxpgrzk2wk4P7C4f0ccv6v1EmwMS0vlemDB4aL6JYgAFLPlyslEr9Gu0IVLlpuD3/sG18mn9fztEEBCEiHyXOf0cnX2A0fWehMRLQjLEA7dQ54T558bjm6sWfNaN/CdQ4AvKvgYV4qo/kv2Wqpf/PP2mI8yWfaTsgEphK3EwXUQu1l5q8DYrXLEkZVJ6Zwb4AA80q9YAlT8A+VF9IZ9kumfQmDgSx/5d5HfDg3MOEzJnM1b8W6PkCy5pDIDNm5bYZbqFN+XMms8ejplNVh9uhksOMMTSXfvQYmu4x81TvQ/Y2b640fb4F449JSWqHpZ7mS3oZbuIN8hmgCcXnNxz79qVObC3MHjmvgWfC2gafBboxmnqjw5MEjkH+p23WwUEHGx2kiq/1SIJjchNxrjtZRuk3PGkEzyGx9B3SXNOY6kkfRhYt3V2Rnml7rqJcoP6adl3MVDoaKsq4YHakr7qNsZgZkkxjK5ic9QOTeKBkZWghomu12fREnUFKvCx7mLfL0u6w/kUqS4OKfNC/G8tTWSM8OZSn3cU9AHiAgIFQ9HfDwRZRCVsvF93n61S7acPO8cJ0AlSFjUVadNkpdj5SP/wFViHRAhHTpPJ2kVcOx9SFUl6B9JP0heb8K76Pw9+e
 8DvddHe0
 yDkRVZi3oOGjqvzbICS5/9SKa7YYB2gDR4pXkFkRbaXOE1V4NJ8VuPROQhNN/NeYXC2pWV7MPaHaEbRlg0CS4fdfy9ytKa8dgjqhrxhMM+d9tmxvIHIZZDYmnf6m3PIn5qB93vnjzCMtuunMQ7Cjos86kXKL1OrcXHiO8S+jXmEE7nUzPo2T/wIo+GQCiAo4xGjH65dV0o/1gp4vPg3RCdwmdYL9fpSUwKgkUu6kMqaV0h/Mtd9HshnAS4vY/1UUGh8KnTae+rVfwgGrm2XO42TUla9dBHEYAEoQZAY0aNdYOpX9fClqHB+lTg302A07HqJCsyaaOilL1xPJSGQijXAqc0zBczoLoOLmt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 21, 2025 at 4:15 PM CEST, Vitaly Wool wrote:
>
>
> On 8/21/25 14:32, Danilo Krummrich wrote:
>> On Thu Aug 21, 2025 at 2:03 PM CEST, Danilo Krummrich wrote:
>>> On Thu Aug 21, 2025 at 1:17 PM CEST, Vitaly Wool wrote:
>>>> +    /// preferred NUMA node `nid`. If the allocation is successful, a=
n opaque handle is returned.
>>>> +    fn malloc(
>>>> +        pool: <Self::Pool as ForeignOwnable>::BorrowedMut<'_>,
>>>> +        size: usize,
>>>> +        gfp: Flags,
>>>> +        nid: NumaNode,
>>>> +    ) -> Result<usize>;
>>>
>>> I still think we need a proper type representation of a zpool handle th=
at
>>> guarantees validity and manages its lifetime.
>>>
>>> For instance, what prevents a caller from calling write() with a random=
 handle?
>>>
>>> Looking at zsmalloc(), if I call write() with a random number, I will m=
ost
>>> likely oops the kernel. This is not acceptable for safe APIs.
>>>
>>> Alternatively, all those trait functions have to be unsafe, which would=
 be very
>>> unfortunate.
>>=20
>> I just noticed that I confused something here. :)
>>=20
>> So, for the backend driver this trait is obviously fine, since you have =
to implement
>> the C ops -- sorry for the confusion.
>>=20
>> However, you still have to mark all functions except alloc() and total_p=
ages()
>> as unsafe and document and justify the corresponding safety requirements=
.
>
> How is destroy() different from alloc() in terms of safety? I believe=20
> it's only free, read_{begin|end}, write that should be marked as unsafe.

destroy() should be fine.

