Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39C83D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 13:55:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EAA66B0032; Mon,  1 Dec 2025 08:55:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C2726B0062; Mon,  1 Dec 2025 08:55:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FF5D6B0089; Mon,  1 Dec 2025 08:55:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2EDB86B0032
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:55:47 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CC5691401DC
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 13:55:44 +0000 (UTC)
X-FDA: 84171050208.17.216E740
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id BAB02C000A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 13:55:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764597343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=baU9/n+LrBDjcf9DRbRBhKxANrzSd/ospO1ov+46ACs=;
	b=tpZ5TTvr85l0xEeyIR8QfYjrmaQj6x5tkSfnm5iHnPv3aZfEMRaxS+KMo8P4XA2uI7+34P
	8v4XbLQL9dbFg3OjlSTNuKFLnx327EtcSIi2qhLRX9H1fp1t+lXP6cL0BDp6lCv62T/VRx
	NT+iF3mDbBaE5Pmh2JLb9ytlDae6jig=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764597343; a=rsa-sha256;
	cv=none;
	b=shfKilV7TFk0xtkoP0nRoiq5DV2xtYXmspSO+SNO0s51zGRkfLII1oaKLXofYxMwWmsXmq
	SpCQNNAEzfUlf88Bd0vzvOZn+SfwdkdFtmgkoErYUf6MVhofzTSYmbSc09+Rpl9ftJSwKu
	EFsv+jwT0WJ5UOvK3wu0KqhYcz7MJmo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 461BF153B;
	Mon,  1 Dec 2025 05:55:34 -0800 (PST)
Received: from [10.57.88.78] (unknown [10.57.88.78])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 97B653F73B;
	Mon,  1 Dec 2025 05:55:37 -0800 (PST)
Message-ID: <cfce9ad9-c518-44c7-a602-8ce7c3fffb2b@arm.com>
Date: Mon, 1 Dec 2025 13:55:34 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] io: add io_pgtable abstraction
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Will Deacon <will@kernel.org>,
 Daniel Almeida <daniel.almeida@collabora.com>,
 Boris Brezillon <boris.brezillon@collabora.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Asahi Lina <lina+kernel@asahilina.net>, linux-kernel@vger.kernel.org,
 rust-for-linux@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org
References: <20251112-io-pgtable-v3-1-b00c2e6b951a@google.com>
 <12d99a54-e111-4877-b8cd-cb1e58cd6d30@arm.com> <aSmVQDMXqwc8ctDf@google.com>
 <c8229530-ab87-4b51-8f2b-6199a01095b3@arm.com> <aS1m4DawouC1utSj@google.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <aS1m4DawouC1utSj@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BAB02C000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: gkpsr9c8scmiw3yt5jpujksp9657u6pg
X-HE-Tag: 1764597342-924623
X-HE-Meta: U2FsdGVkX1/9fKAtMtbrtBseNOaeRgkamgYMsRAzlesH+CLUBUfrXueM4FTbykGokCvriHyDEWZMbvrh7Ugrj5cOonB6lMNPattBHxgZmcoE4xpZ9YceQlcYMfLu94tD7qxEKa7ya3bTtk3JwmX1HfHf5e/cNZrKP4r1nL4Y7g17oadOxV9AXTeeHohHGO3+14zzJ4Mr9Ht4Hh5yRmLywOxE8TL1xHMOK/w6fQyc/K2M5R/TAyVDHHfAW+Tg/7ue5i8/Y6jW2fak413aRRbBka4c6otmv7ryYG/cQ9U7EMe9nSvRGiozaZ3+Qm2rMm2buM7y72yFTItUOvjWjtY99Ww0ZY0FqcTSv4SVL7BaCnLeHWPWoL5oFA0UKAbVIA2/a2o8C53TfbKX5R5mLd6gT66z/4kBjWKLwiAVySXWBIFlsKoIogvtsVaDy7mM9EKiv8unHCoV5B45SZxZHnkrH7ELMcoKg/gc4QtN1H74lnVl8kJno9TZHgktfKeTfHi0fdGFv2RN6TUfhWVo8DXofiBoE3ln3sYjsDEJoxcpVhSG0kqs19R5TJznUxeIaBXQNv7dFyMOhhZdejkBKDer8uEI5M7vwQGE5yWOIdbstomYsJ6+uvs4uj2kvYhW/VLLm19VofLY7yrZuNK/FBfHQuHViYLaNUkif8RyAGIW2KT9bWJppftYzlMPa4cQZ61gmPL+08kV1XqhuclIl6VeNKtx2XMvmfxjYeQyeMG2hugj67gG6rxIfRWk1jWbpHZGWADqE8cqvtgEvmNpGKHi8Q+5a+v3zjQXVP21LSzS/QNYfs82T+e/6Tm5kMjjPRXzokeiIpu7LZKRrBlN0qzk2I9mJot9Z4t3irnCa9oISXJapApW3G3xsE8n6IL7cmfQNzXMrwUmNdANroyhbk1avFEwehGwY7zK4m3m/17gqt9YpAqzqnVtOhjR9129ko/hSrS1iny+HfY2x9PJOzA
 NeCexnYW
 ajW8fO3Bgb3kUSe3hwGCA/A7431EQYy3Z5/GciaIygW8pQZA1v9uuRNo9pdkEFJQ+/YQIWSv/qiwJyYEYatkJcb1/A2tyseXfUm0nhmER6hfj1rs6wpvaqcd3ZkLUvMsJT4U/8SPtR/qB9bjqUSFmDBeDLtbr95mV4k2QhmImfVAiIi5SGRqE0TSqF2EHJE1KaLlgFOBamES06yxl5EkPKvowmv6evRQxyVaORUbxJl/5TFrjnHMibIPvOLHPAG2XRyVjIRlQwMfLtHc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-01 9:58 am, Alice Ryhl wrote:
[...]
>>> We need a different signature if it's possible to have mapped != 0 when
>>> returning an error.
>>
>> Aha, thanks for clarifying - indeed this is not the common "value or error"
>> case, it is two (almost) orthogonal return values. However if we're not
>> permitting callers to try to do anything clever with -EEXIST then it might
>> make sense to just embed the inevitable cleanup-on-failure boilerplate here
>> anyway (even if we still leave retry-on-partial-success to the caller).
> 
> Is the only possible error -EEXIST? I could encode that in the API if
> that is the case.

No, I was just calling out -EEXIST as the only error where I imagine a 
caller *might* want to continue without cleaning up a partial mapping, 
if for instance they were playing clever tricks like a background 
mapping of a large buffer while already allowing other threads to 
eagerly demand-page bits of it, so the "main" mapping thread just 
adjusts and restarts to skip over already-present pages. Other errors 
are still possible, but generally represent terminal failure conditions 
at the caller's level too - in practice things like -EINVAL and -ENOMEM 
are likely to happen before any mappings can be made, but io-pgtable 
doesn't guarantee any particular behaviour here, so a well-behaved 
caller should still generally handle cleaning up after an error (at 
least if they intend to keep trying to use the pagetable beyond that point).

Cheers,
Robin.

