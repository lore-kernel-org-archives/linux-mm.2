Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A63D5CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 23:38:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D3658E0042; Wed, 20 Aug 2025 19:38:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45D998E002F; Wed, 20 Aug 2025 19:38:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34CB18E0042; Wed, 20 Aug 2025 19:38:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F3D48E002F
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 19:38:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BE1FF11518D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 23:38:50 +0000 (UTC)
X-FDA: 83798753220.05.4C4D89A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 209351C0006
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 23:38:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BZxPOTpZ;
	spf=pass (imf21.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755733129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B1QI0d/X2nmM0c4RXcGM6+vtG9qug63oq7wZyf+dYxc=;
	b=d9F3+7WEmTwiRZExEH0pqSLfATosqbSBp8O4+/rXtms146BUtwUcUG1NP3lFn0ER7zkt4W
	tSI1A7bS5hLnax/qIALLNlq0HN1hqhi+aLdG1yHrNgqcR26EBAYyJOOwQZVflfELTtEZTt
	jY3YT17SY5ZVwwWcLHMolSmA2pPDLxk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BZxPOTpZ;
	spf=pass (imf21.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755733129; a=rsa-sha256;
	cv=none;
	b=4EJwqL3bMH400O89D7vMAJpOthtEATvyP1A7x90wzTHE3TtvxJSJNIp2g8TMkYq/XJSBDp
	G9/K2cPGDA3oe6JJN/UKZ5/pNmH9lGGQHnHJcjXA8Gw8403lnN9fspknE1FTTRuvYyxLWf
	sqP1a1f2I5z9U9kvVakSsobG8wAnypY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 459D961444;
	Wed, 20 Aug 2025 23:38:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9F2C4CEE7;
	Wed, 20 Aug 2025 23:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755733128;
	bh=XjKLPIJpPl8XNfbf0L8f2m+lNzBLHaWsnTNgo9GwnVE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BZxPOTpZJxvSFocTM9w9CIuObkM0bYYsWS2CYPaNUfIdG/Nd4Wl83e2ZR0kkxFnTi
	 c7uydLc9kmaKJEjtXr7XDmtoyQvgvdq85Cg/1+JJLBrmrQpkYApdgUq/zYXKwlqIt3
	 IDtxr17v74sWirsYaxBQD/Mn3mPcR4G6sTd5YStRpcTDEM96R7n8hEtKmePi49Wm+6
	 niLG1HW6pYuMQpjdprMHzF349b6YN1QTUdWZtEBYpIFLQHQL5xxLw1jLBZ2wFzyz8+
	 DuKKYLT/OglbAp6R0R4yVFQb1BOTyNBlGjkQ9pQVdCsJ7Wou2EhhHhjoFEE0tzKFh4
	 QyOkYh4V8KykA==
Message-ID: <e2bb7c12-235c-4b2b-823a-363d22c6a13e@kernel.org>
Date: Thu, 21 Aug 2025 01:38:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] rust: mm: update ARef and AlwaysRefCounted imports
 from sync::aref
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alice Ryhl <aliceryhl@google.com>,
 Shankari Anand <shankari.ak0208@gmail.com>, Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>, linux-mm@kvack.org,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Trevor Gross <tmgross@umich.edu>
References: <20250716091158.812860-1-shankari.ak0208@gmail.com>
 <CAH5fLgiUfZG4e0k6ajkkKo+iaidWHu4dTRfBbgm4Y_CQPGLHpg@mail.gmail.com>
 <20250820162518.7dd218ef331618bea11e9c2b@linux-foundation.org>
From: Danilo Krummrich <dakr@kernel.org>
Content-Language: en-US
In-Reply-To: <20250820162518.7dd218ef331618bea11e9c2b@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5uinauktt56z11jnef661oa9bprm71cq
X-Rspam-User: 
X-Rspamd-Queue-Id: 209351C0006
X-Rspamd-Server: rspam01
X-HE-Tag: 1755733129-632432
X-HE-Meta: U2FsdGVkX1+k3x3YvMd99Jf1YBeEuNPbrqopgfaDSdGE4G89vL/xzlAkFnalD8c921g5ARfTozquFzQMHoLKEilopBEPJVaM5Mvh1ZC98EcuTJBJaeSA16Q6potAToNX9NP6bdMqjoBzhC/31WCDTV8LkSDFQXtOu4XSiIXxVBE87qtj4aC3h+vusALtVoElBIRJcKFnWTO7IxuFdeZItXdmWBgtrLyJpgaO2ndQG0nEXacQIC673Y70BcIB70R7GdgzognVYl3h0f8XZnEeC80ZE8uIGiCRlCF00R3vLHgAgMGd8IAzTGXnVoEl0Zbw/P7fdq0H9tleFAaGzK7JgAigmJuyDglZAWvxVK7nVYPwtEg8rtaznOncqB544qtT8s0H5LIDYSgPlaxxGCd2b6tYQd4HojhV3Nxs0SoesDd/vpBz4NqBCFIgwFdeYhnPTIUZQHvo+b4Nc5uYt67htCvUs0Qx19/DfWn/fmuvN1Jm+2wdiHQxFeGgL7+N8Vfx8NIOj0VeVKkZy2asVJ1BTKyBlVA8UYRpVzpO6WaUmHD3qXJ7hcXgg2QEFC/XvOW4bsH3x4VPoTz8Lg4JrKG+CkcIe+r5ypjbdIeVThN3/NmDFW4tyewouM7v/TbN9YnPErjMVECqhiZGcUW/Tq45MM5hbAWcrwR3akiv5Ncdi/z/rw7rihAAncmJdTBGGLoetj8mm2IFaaSwA13rS69b1KuP70ajkEb1CXq2KSf8VQADSdHT9kaZSM9JB4lTufApqWkqBJdg2tWbPLbjVJ1pPSB0pWa42TLSkCi8d7+lKEXmFKRaT2MKtQZy9Me9s/T+duZQZMrkufpAKOSw9hS1jKKpdQzAtPz8kVVBt4DAiMr7VomvwCQsmly3PN9VaRAljeWTDZI9aNs47TdZ5mcxz2Jk1uqooA+OBUONwtR33bQuCDl/kQLLV/nMWp5g8Sy2fvj230vOZv+iVYq53je
 01D7eCgO
 3KTBo/m62C7dmCHb1I/lZ9G5ydwhmG/LsJUsrYUQ/ytdLQ+e5VRP8ACh3Tc4QaHnW73HhsiRCpHXPx/+Rf03j99GN7f8il/ojkIBY/S4XujwuLmFj86Hhtu0XkR7Un2RYldAVKAvjDW78xt6P+G0vHZmOAnXNoy/VVwdO51sefhju1X3WxL/Yi4fPosGv5REj+BvOrJ5NZSWSsUBkYNgW4mJro1TaJ91hD/QlxQtNBc+NpzDMOevURWU88y0xDSR86AI3D6aiYaaAKtR8f8Co9EX4QJjLnhfDFeNge2OxXcLg++8pb9U2o7kMetgFbmGSGRLdJekzWS03BJYOKou85prcLAIvM/xX8sRIglI2wwRKwbnMy3RKSTQ9Mzz08JFOqquLqTSqjO94f1i/IUosalIds18C3ap8SGoYCdgaHXD8BK73ED/odLGp8brpP5cD6xS1GsLlkLdq/mlLcYm+Vuj92fBuhrQjvdNg3YQdvurlfm3t8PXgjnAu6YrjIdnRjLwZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/21/25 1:25 AM, Andrew Morton wrote:
> On Fri, 15 Aug 2025 15:51:31 +0200 Alice Ryhl <aliceryhl@google.com> wrote:
> 
>> On Wed, Jul 16, 2025 at 11:16 AM Shankari Anand
>> <shankari.ak0208@gmail.com> wrote:
>>>
>>> Update call sites in the mm subsystem to import `ARef` and
>>> `AlwaysRefCounted` from `sync::aref` instead of `types`.
>>>
>>> This aligns with the ongoing effort to move `ARef` and
>>> `AlwaysRefCounted` to sync.
>>>
>>> Suggested-by: Benno Lossin <lossin@kernel.org>
>>> Link: https://github.com/Rust-for-Linux/linux/issues/1173
>>> Signed-off-by: Shankari Anand <shankari.ak0208@gmail.com>
>>
>> Andrew, would you be able to pick up this patch? Thanks!
> 
> I prefer not to grab a single patch from the middle of a series, so
> please add
> 
> 	Acked-by: Andrew Morton <akpm@linux-foundation.org>
> 
> and merge this alongside the remainder of that series, thanks.

This patch was sent standalone. The reason for the "3/7" suffix is that the
author wasn't aware that this should be avoided for independent patches.

It was previously part of a treewide series, where the treewide changes have
been decided to do in multiple cycles instead, such that each subsystem can pick
up the corresponding patches.

