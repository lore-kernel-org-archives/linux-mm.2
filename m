Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A744CA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 11:37:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6386E8E00CD; Tue, 26 Aug 2025 07:37:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 610218E00A8; Tue, 26 Aug 2025 07:37:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54CD68E00CD; Tue, 26 Aug 2025 07:37:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 400E78E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:37:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ED132848A9
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 11:37:31 +0000 (UTC)
X-FDA: 83818708302.02.771DCF8
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf01.hostedemail.com (Postfix) with ESMTP id 401694000F
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 11:37:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I8fCMfel;
	spf=pass (imf01.hostedemail.com: domain of dakr@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756208250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V4hDPhoraW+pHFPrYZsNyQVKUzQ4qbupmiUoYDy47dQ=;
	b=2oHQMUxHUIuJbuwoUGf+HZHBeRRlVF405px0R7DBq2Ab4jGrT3VmckqrD9HVBAjfctspSB
	nE2y++11B4QwmGhaxG09+VnOURo2yXFfrO1Kd0HSaljQjRQw0eqzxCF0NtX4y/nXK7Mhpi
	KQ3tUR1e4L3QLrkFgP2JtkXjcO2x9sM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I8fCMfel;
	spf=pass (imf01.hostedemail.com: domain of dakr@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756208250; a=rsa-sha256;
	cv=none;
	b=Ga/jSb0hmO9NAR9Y9zmBgPHnqhoHVG4FAwt+1jQwu7KFx7Pai2QUC4JHWsVTCmTWMoWGkP
	J+Qs69666Nfn6nYcE3+PaWgokZkcK/X7Ct0zdTqwocg+2bLwFy6Yd7HpMc8FGrJgDBxfZ/
	jq4WF4QeQjtzWrRM9F6pn3wjcD6lQHg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 24E4B5C49B2;
	Tue, 26 Aug 2025 11:37:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E71C4CEF4;
	Tue, 26 Aug 2025 11:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756208248;
	bh=vhWjhyKOSmj/KSb4vVuq3nWGsNJx3May1+qso60gS6s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=I8fCMfelHs9mSQNbu4YTz9BqD96m9DiXDcbKvk7FTw9tQfzL9C0S2WSqEkz4a2PWd
	 mt9YODmsey6WwpBL19wz6uXG52cRDDh7iAl7jfup7oWYAETN35SiNa51evaRbGzBGA
	 T8NbZC+yDDlVQ7NYi6ybEo6qFjiRT9kGUep3g7Osj5DL0XrlDGrS1yJy7xtUpYeRhH
	 Vtuk+fW45WPtxweHlWV50b3eZ/y+5JJaQ/xi+d6SbqUbVy2IzAWoUrzgftvyTXsBUH
	 adeJc58LogdlkKGJjXSlXZ9G9hjguNwWvP8guQ9tH+DhYE0OwmXn1FtkAtUzkGPYuO
	 StSPKIVP+gh6w==
Message-ID: <9179276d-275a-49fd-8697-82283fea4bfb@kernel.org>
Date: Tue, 26 Aug 2025 13:37:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/2] rust: zpool: add abstraction for zpool drivers
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.se>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, Uladzislau Rezki <urezki@gmail.com>,
 Alice Ryhl <aliceryhl@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Miguel Ojeda
 <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 Bjorn Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin
 <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Trevor Gross <tmgross@umich.edu>, Johannes Weiner <hannes@cmpxchg.org>,
 Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
 linux-mm@kvack.org
References: <20250823130420.867133-1-vitaly.wool@konsulko.se>
 <CANiq72kQv9nJYyiuHvTdaJs2SvZ_bFAnexoEBgjb0CDzPjBTYQ@mail.gmail.com>
From: Danilo Krummrich <dakr@kernel.org>
Content-Language: en-US
In-Reply-To: <CANiq72kQv9nJYyiuHvTdaJs2SvZ_bFAnexoEBgjb0CDzPjBTYQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 401694000F
X-Rspam-User: 
X-Stat-Signature: p1hyky7tiswd8py9gxfca6gb167paamn
X-Rspamd-Server: rspam09
X-HE-Tag: 1756208250-391300
X-HE-Meta: U2FsdGVkX1+kH5truitBAPJDwuF0+j913ATdY8l6FMOkADID+VRcshvyC84ScWLLHsxAG6w65pqYuue6K5ytYhoTL6SQRy4cFw5s2CfuBMpA959nkr7XRpSTj2WKdIHuHZx3eaRekkrq9WVO4nLZ99bbhkaTpNPsGJBFfzWjFCHJd8Lru9gbhYaRFzAm15FWpv1EOii590ICpLLlK5/1LUnwxuu8n7IczqnjzrJM4G45MslXPkSDhR4APtutW+1h4pFQL2dg7BYcW2vwimJdU5jhZTRbxzC/ZrLq2cGTf8X74vHNqecIZDx5A6oEaxmQmmIREy8ncMVZloYVEQ0+DiGJygE0tG5dCwThoWDhEP1/TFv27hALZTGKi64fuvpfQULFp4MoagdVL+cV/95Go0Vdjb3tiAgHNwIAjeyJ/k3eFKTlWwFh652QzEsg4ZCnBU14b+oSIHGLiy3O49N+X7FnU0ofkARn7PQuNKmymh8iGfcZpWZJiVz0wtIiNxkv2sRZHDXUFsL23Tqiczfda7QX2J3NR67+aLSAMGIBLb6F/KkXRdySqGwJzo0gWTQvsmpAhjwvALFNmQTqdDNSYXpweyb7Zlb7ygxevLT9VZf5Ye7cS+mS7sOv70fY2alUMriSoY6oB0GnrBU1yGnJgKWRQUZRK3j/wSScP+Fi+7KRTNmq43sWgKwTt+t3e9VxPJoAwUSGDkx8k98P0yI20lhI/dL2GKlNzWPobP33NhanFRjwWLUJbg9Xy6m5N2ESL/OzyyxMSj2FS/we/2P2uMNfHR9o204lRKL4696lHE8IIcWZ8iP12hYhrYuCeUIsP5Q5SnXdIxJVwQeR+VsAU3y2lKnfA8cPwWTz+csoegnR95KV4TsUrq2idevGfLt5SoQCs/Uprgu1cBYC4E8baLGU0M8xT1M/fAZyjgim8d6T/8NzOhRwuMqOWuIdYd7JREv//7KHjpY0vbrxfkW
 HPxTtS1c
 HtS8482bvahBoZmUAoCHVZWh+oz0S/kxi6gawMHjEa8U0SrJmYdisbwz6tqJYe4qpYj67uOEyVuQDg9W82qJtbz+/j7+lJOp/CA5V/CZJJFrdNQsZDE8ae8uL4Zv3Gb12dNR6CtnyNf83XueaRsVY3HBFgePOGFotzZ9WUvErU+Wbp+zxZkobW0I1BotfiZFsrz2usTeM3mtwZQ+NV3DmBnKfkhnIlqW5cLWeunpXy9kEaeBlHkmUORmd249SI9ap4waVVX1pakiEpJIQhNrbPpIiaENcD1xkd09yIvYSRxTQXP7wCRsdZ37FerjTAyGy8dcBuJb9zIKbc0JBgwPVD6AJWUV9YcR7j4DU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/26/25 12:43 PM, Miguel Ojeda wrote:
> On Sat, Aug 23, 2025 at 3:04 PM Vitaly Wool <vitaly.wool@konsulko.se> wrote:
>>
>> This patch provides the interface to use Zpool in Rust kernel code,
>> thus enabling Rust implementations of Zpool allocators for Zswap.
> 
> In v1 the usual use case question was asked -- could we get some more
> details in the cover letter or ideally in the patch itself?
> 
>>   bindings/bindings_helper.h |    1
>>   helpers/helpers.c          |    1
>>   helpers/zpool.c            |    6 +
>>   kernel/alloc.rs            |    5
>>   kernel/lib.rs              |    2
>>   kernel/zpool.rs            |  338 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> 
> Should a `MAINTAINERS` change be added? Was maintenance in general discussed?

@Alice: I assume this should go under the Rust MM entry?

