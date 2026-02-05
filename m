Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 701A6EC1EAC
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 12:30:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B65466B0089; Thu,  5 Feb 2026 07:30:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B198F6B0093; Thu,  5 Feb 2026 07:30:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1BDA6B0096; Thu,  5 Feb 2026 07:30:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9423A6B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:30:31 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6AE891B23D4
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:30:31 +0000 (UTC)
X-FDA: 84410336262.30.D9389F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 82E08100003
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:30:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AWATdtov;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770294629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xm8HvlCxTISOM3kPM31NPNMNiRs6iDL5cLojLp4YVi0=;
	b=FambPYTsP+RCEGfOysXfXVZWNNvV9Zlw4XGJm/rDaxoZtet0n0s60H3O7fWnonEQAL4auF
	ByHs6vhtJKQUfWQ5SXSGfq6NueCEmTU6URyTeDIsYR3D7POUTGOXA7EZoJieSi0h8D5mhE
	6uESxFcbfnv8MhFoahGQkbhGbVr1TLM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770294629; a=rsa-sha256;
	cv=none;
	b=67S50rjEs5VVWXtL9sxuVxCVfWBBC/4rp/KrwqZBq9d1SbqZE0capTTwWOnZ4VWRC4nc71
	lMO6ykPmdVsREYZ1ANd+tvTyUrQQxjhnmBcjMHdMGBIhQPF75TwiaOVmJ5r3IDhViP2WHs
	VBAkkRsEwJ7yvngFtuKoNE6PbRAhCrs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AWATdtov;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 48CA144040;
	Thu,  5 Feb 2026 12:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91751C4CEF7;
	Thu,  5 Feb 2026 12:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770294628;
	bh=EUjrqUElz39b9RlRe31B42r5RJjIr/DT+Ha0YYAKyLc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AWATdtov5ZholbCjxHvW2fpBJAf2p7z8HUzh8MClO8klWQkNP/uD5laPQi73YR+k9
	 wYXQPHRBC+3QY+qW+Hguv+po0sfVFNnFUT7rLCJ8+Vi1iUEri9eRk5qV93BWjDlpR0
	 rFnRSAJyVaQuxwfA/znvOAvlmnZHJh9+PPqxEH5fwhNoQV3T3Df6Iu5WYTBsJvV9df
	 3Ey+dIvGyu0qQDC3teeiXhNmqrtEt3VMYsHZ2XUIjOijc6dLcFl1DCLNCDGSKVxCAW
	 BoWI6E+Y9xij6JXsdX98UmqooknvDAfneBLPne1gsiLc8kRZj/o9kXIcd44B5VQssQ
	 iU6Ij9tPlH1Bw==
Message-ID: <ba5cb90a-cd4f-496e-a665-cc323ec598ab@kernel.org>
Date: Thu, 5 Feb 2026 13:30:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] mm: export zap_page_range_single and list_lru_add/del
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Alice Ryhl <aliceryhl@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Carlos Llamas <cmllamas@google.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 Andrew Morton <akpm@linux-foundation.org>, Dave Chinner
 <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>, kernel-team@android.com,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-mm@kvack.org,
 rust-for-linux@vger.kernel.org
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-3-dfc947c35d35@google.com>
 <02801464-f4cb-4e38-8269-f8b9cf0a5965@lucifer.local>
 <21d90844-1cb1-46ab-a2bb-62f2478b7dfb@kernel.org>
 <aYSFyH-1kkW92M2N@google.com>
 <e7247f3e-8a88-4b46-91ba-cb73cce1346a@lucifer.local>
 <8856c839-1a94-4e4d-9ded-d3b1627cd2cc@kernel.org>
 <aYSKyr7StGpGKNqW@google.com>
 <4c399644-97d3-40a3-a596-e4c93b713bdd@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <4c399644-97d3-40a3-a596-e4c93b713bdd@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 82E08100003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: gdu7qtm5y746c5wdciucz36qx3w1dg47
X-HE-Tag: 1770294629-736393
X-HE-Meta: U2FsdGVkX1/qgjoQwg4ArCX8uzN1GjVwa0sy4NoVuGqBK0DehStCIMTOV6TAP/czqNIY106FLEq1BLOuBFge8CxUEdxeRb5oUWC4ZaZlkxXQkWzT4/83wBaOLrKd57umiNjWEA+4i6Y0rXVqViYQsAg+cY2HCJkMswasJc1vdAunY+hV+CZNWF/QM7Wa06pa7dGTaJqT6dEwKg79eBHenCuwOMaIwbK/0KMuyK3QdvovuwlsAk7nnyU7Dbq4TLykQ6w3e9YcK1KQ7TWw2LLskWexlzLN0zUP3z4LJ2bjREe26FBoj7V4GNIdUb8UM0M6lj10Og445AAg1sRxaH7bNg+1On1PuIdWe0V6cOh3RetqK5y1UJQQd+kxddBF7s1105/v2B88QMSDKEDPuMtaEQ2iNDXH5i5hdrf7eLY5XhiHWWOn1AelymYltof+Kck4dpShkMfxNEcZzHZCnlcneKoJ2zB+TV6KIa+9IkDrCmT/A0jE2D8Jah3k6Dit7g44lr8X01ovMl1VplVCuGjzxHfqYrC76LhPD3Ic/tvyOYXLyHYpcpT9GTBCKZ2v1o3ay/H1xW4HQdqOA+EdMPO+ysUIzB066Jsv1IR1ZZbDNJZESaxHO+7kG1SQVOd0wqplc7jngzfY1He6m75TtIBr0DDGMopK0Wfu7N+meb1SJ9GMAlRPBLMgVj20T5h55CVKLZTC48ezNDpNMf/8B5ziZmcs9bSTiCHmFXGXT9sYQ1Wk3cQPNPKVRfNYN/hbecY1XoS4s1eArCTMvthmTcE48lXTohtF4GGL2P95iQrHHuKUrRWvvhPUlLY38px8uRRAvrjYYqxD9Tqc01M4u5vu72bHEOnAQhqDv3uQn8s0978ofxV45DyslFRxy0JQ9986EzWGMfnONO284lwBvQt9zuJSgLtT34OHxlgxn42hTWuOUTHD3mU+4iXg8lQCP12GxntoGnAkANL1tbnAiMT
 y3Lmnza1
 9g4VtAo00sCl86iA4Y1kKKeohg5VVHKPE+2mgcFJ6oVriIxQIlNqETDpoWLycqvnvSAP+/WEk87qe+oGWpm989LCEfpqPdMqOhxAVHIsAk5A2aBS8lfQVcB3QHUc1ZYOO5HJQkIkswhPc/Sv4Fp8NEAYzAM3mRvMTEUrmZC1pNCorb8qcBmjGvcWJP0x3iw+1U98HNdmNnFLIbjHvMExfwCJ6cabZYaQvxZzAjPhs7f/9jkHaGpC3I0DcpRqcVfmL6lvxym2zr1c9QbJxV3Mnx0+49Puez51RG+pCHUSNCBM9moGlIlqdfKuKXJX2WAof/kbBlHMPidusxZwuWJ+oSYmOQJn/uyQHkGD+ytwqLwMG1EBW3tgtPWlUNT3t039sU8kY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 13:24, Lorenzo Stoakes wrote:
> On Thu, Feb 05, 2026 at 12:19:22PM +0000, Alice Ryhl wrote:
>> On Thu, Feb 05, 2026 at 01:13:57PM +0100, David Hildenbrand (arm) wrote:
>>>
>>> Could Rust just use zap_vma_ptes() or does it want to zap things in VMAs
>>> that are not VM_PFNMAP?
>>
>> The VMA is VM_MIXEDMAP, not VM_PFNMAP.
> 
> OK this smells like David's cleanup could extend it to allow for
> VM_MIXEDMAP :) then we solve the export problem.

My thinking ... and while at it, gonna remove these functions to make 
them a bit more ... consistent in naming.

-- 
Cheers,

David

