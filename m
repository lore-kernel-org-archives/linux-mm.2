Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04BE1109E550
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 05:34:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EE6F6B0089; Thu, 26 Mar 2026 01:34:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69E9F6B008C; Thu, 26 Mar 2026 01:34:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DC7A6B0092; Thu, 26 Mar 2026 01:34:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F1686B0089
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 01:34:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0BDA71A0BC7
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:34:57 +0000 (UTC)
X-FDA: 84587100234.23.AC16A28
Received: from sphereful.davidgow.net (sphereful.davidgow.net [203.29.242.92])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6530340008
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:34:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=davidgow.net header.s=201606 header.b=kdO9GYCT;
	dkim=pass header.d=davidgow.net header.s=201606 header.b=ldcLAgFv;
	spf=pass (imf11.hostedemail.com: domain of david@davidgow.net designates 203.29.242.92 as permitted sender) smtp.mailfrom=david@davidgow.net;
	dmarc=pass (policy=none) header.from=davidgow.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774503295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GAsmk2Bxir/aEOlCq/1mI6TxB8tMf98VYj7NlGYlXuE=;
	b=iEV0Q4Jb+AIU79329fqIpIIwIdpHN0sp2bcVLbNj/LjDswNDBAUQY827KJsXIuTYfd9UdD
	gASW6aPIzlHI/S+u9UVoBK3g76uPFHeojqcajf8auLLp1g/m68R+QHbfN7yOW6f6/o1/Aw
	gNxQ6ICTp39q9iAStzh+nO7nxy7h7UM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774503295; a=rsa-sha256;
	cv=none;
	b=MKndyjWvWmYH+T7+vgYgs41e02EXd9EVbHbuppwZ/vcmFV6xPe8WfjDMb9A8KSsSq5Ivbc
	PyfEgMHETfTmldyoYAoJbA9rCgQEYAmON78BRCdbChNpexUcvctVwsuJzPm5woo15MwuIu
	mU3zsC87X3s3ZlRHCPocWg+9Nf1yiEg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=davidgow.net header.s=201606 header.b=kdO9GYCT;
	dkim=pass header.d=davidgow.net header.s=201606 header.b=ldcLAgFv;
	spf=pass (imf11.hostedemail.com: domain of david@davidgow.net designates 203.29.242.92 as permitted sender) smtp.mailfrom=david@davidgow.net;
	dmarc=pass (policy=none) header.from=davidgow.net
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=davidgow.net;
	s=201606; t=1774503289;
	bh=n9xjHtpRhSH9ix3QmcQLv0kr4+Yq4N4rwcbqb/HE28g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kdO9GYCTmR/URnRV278niTXYWYSXlloFdxpmJG8gn+mzQJ7eY5xi8q93YDEvCakkw
	 LGVrgmiyUELbV+OfC+WEmqWEKQw1bjtzew5Jid7cHmWYouv1JG1fFeteMpc3dGPk6B
	 QKqp0QmVrwx4oOBKQOiny4JIQnP/rh1I/gmFxW+i+IKhgHE/FmU/9BS6rBWcPRG6E5
	 dgSuNkdvdG7Ybg/N1WOILtkTGpbgvlZQ6ITJR83HqI6OiDUtNDUrT5ewtoVOa5wEN/
	 KCBlugYfO+Hh9n3EsEdOj8dBV+5lzUzzmwTzok6zrZx8Bp5FX6pOI+QvMkLznKh7jm
	 /nIwhHed2lBB9zQtvfRukEWlBFCfntqDJ2iLfjOWS3XSmC1tT2HjV8JNBBlfkUgnNk
	 cwCu1eqH8DTTyTeKLYr9n7uvG4B3eNEV+MB13iIM/mt/xGleF3TxpAgj+TBFXTmSs/
	 +BQpILA8QLWcMg5xEY1/ZQyuDT0XZK+BEA84GkybYKQa+vaCGbeEfEKELvLq1JPznm
	 URT+YCI/mkIVA0DyBDpAjmdEUFvvFeJBfBspTXAlFjIF8uWcER1vSK0xmShQtVgiDW
	 7avkG2qQk7uQdUOBlf6VFAV5r3cqzZXjtXtF6vejKHpdbZPtjasY+Dpcm16rk8uhyv
	 1eYf9uGMl+tZIdmT0XZ6jWYo=
Received: by sphereful.davidgow.net (Postfix, from userid 119)
	id E495E1E8333; Thu, 26 Mar 2026 13:34:49 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=davidgow.net;
	s=201606; t=1774503287;
	bh=n9xjHtpRhSH9ix3QmcQLv0kr4+Yq4N4rwcbqb/HE28g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ldcLAgFv276uo5NW6LPy7yICCVgujhSzmWWh6jq+0as7zdXji4UzHT6jmt4Pz/+33
	 S3izhb/lP9G6bwJL2/2H1qTs2LUaVuCj/ABRbszrZp4q62JjEXq55nTfRp2SvLuI9R
	 fm906bBysocD7LOT3MwsI7/Yswz4Tiu7PEgJoKZ1suCr2uP3hzygBpq9Y/uHrCvnlV
	 hL320KohBE1/nJw3XzMRLlA2C6A8q7IH7kiC+wl1eGgKbZUpqeffPGP1oYo0M96OJC
	 b7+eOTWzv4JyqwtBOF8ElsXU3R7ytXb6QQaJ6JxxljEQwj2nIYkCAf94e9nYx5u4JE
	 4903DdFW1gSuzq8xO+jxBKsA7ZEGlu1on8XW++IES/3QjXnfMvh/tT99aAmzDk70mK
	 Q12zsoXnahHRQZEKsNXsV7IS8i6e64DETF7+FG/6LFPOLnJzdxuyTYZMWVs6YLIIDG
	 aFSeffc9zYPYLL5KHnYpKyLYtJTLbeBA1SbKt6JO1LkMj8NOUC7hfwUzjxN/oHDv2z
	 3/L5hJqEG8WzvGUCwLtLeVT2cCVUWYkRhKzxdIUzYLENGP4vUxvX5aCNKe1wTm38eG
	 Uoepqbm42xqept2Sy0Ah2AWCkqIRpUM2alnyL+hUrW0AW3Nejd9c4XWG434jAvhFQB
	 SI3cbpjzbw15rKzFZT3TjCdA=
Received: from [IPV6:2001:8003:8824:9e00:6d16:7ef9:c827:387c] (unknown [IPv6:2001:8003:8824:9e00:6d16:7ef9:c827:387c])
	by sphereful.davidgow.net (Postfix) with ESMTPSA id DC56A1E737C;
	Thu, 26 Mar 2026 13:34:46 +0800 (AWST)
Message-ID: <e6bcf016-4739-4ba4-a46c-c0416c07400f@davidgow.net>
Date: Thu, 26 Mar 2026 13:34:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
To: Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Nicolas Schier <nsc@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 Russell King <linux@armlinux.org.uk>, Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, aliceryhl@google.com
Cc: linux-um@lists.infradead.org, llvm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
 a.hindborg@kernel.org, acourbot@nvidia.com, akpm@linux-foundation.org,
 bjorn3_gh@protonmail.com, boqun.feng@gmail.com, dakr@kernel.org,
 gary@garyguo.net, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lossin@kernel.org, mark.rutland@arm.com, mmaurer@google.com,
 nicolas.schier@linux.dev, peterz@infradead.org,
 rust-for-linux@vger.kernel.org, tmgross@umich.edu, urezki@gmail.com,
 will@kernel.org
References: <20260203-inline-helpers-v2-0-beb8547a03c9@google.com>
 <20260322192159.88138-1-ojeda@kernel.org>
Content-Language: fr
From: David Gow <david@davidgow.net>
In-Reply-To: <20260322192159.88138-1-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6530340008
X-Stat-Signature: cgpsommqp7iw6dm8um9gpjb4zipxmabe
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774503294-731554
X-HE-Meta: U2FsdGVkX1/CQw2Cbe/ew6cDPKxgj164y9KaPjNUtbDD2BMzUe+fX4qMvxVqhSEOL1Dc2zDFKUmeNV9iI+Db+Px1Hc7sNoxRtcO3ShOzsHMER3TMRl8nZWdGN4TJQQECHfz94bB0iCQAEGUQBPXgt2OI2ON9FXxuO1MU2UFQSGdp1/tG42rOguSKxsMnkmVQRWs1Oya7KrO0A0odKFeVqSWUu5EszUoVrUS2s3pJZlw5PRb818KcaBIOu9gd7f6aZUou8sS2rxLnKP+02U4fy8DT6d/NYl/ahNV9lNCi0fHyYtVqUE/GMMaN18TQ403qfjMcisC6QHh11YDvCexv9kkRdXchDd1DWkabROqbFHluQeNjaMcTc6QyRyv8SwzP+D4/yXYxHVgIc9+/fKdt7+mMUQy48sGzGb9/5Gz4QhbTrKA/3tYilL9/ltwJTTNh/viczMUs9oLMqD9ZeoopWZURrBerzHhkIrZG6XFLntPOSWUevWiIs+YlcO7v4S9AyZCRG3LAH9gQahFu34xsgsHhYli4PDWzQM5mSHr3KGodYRndNYXfvWjUQTNtLaWPYZJVUM5GlUgJCeIJsi40SmpRQwgeY7hHlU/o59tjMonxVYLJwjotbSwpZG5HWRdF1hgwrAZzoBL6yMnUiySXNAm6INIIvt4QT0n4Ysht03vL+Rbdpq1oe7diqyQD8jPiSUMb75AJaMNqbwgYlLqw4FQvXC8JnNzzLHCex7FYpB/+xaTS5l7W+1Ffr2HkQ1Lvu28/soop5P1Gm5Of/l2Fh5D1FkI7dH4Lcl4R1fe2l2fYkT+7JXrZDKUUSY6fjCirJzeIDzblRrrjBFfKkrn08NZ9T2vrYZ2er5CKgmukhFIh4rXcgGUUfh9m0Uya/P2FdvSFN70W9Ylz0NGPVY0ARLgXcyFQMjzThfGnXqWiSTlZdf4WIyMF50VyN8spzEvF782emKvecHElsWg7jDt
 BAY9eb/l
 PTJTyoHKzKExjT1k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le 23/03/2026 à 3:21 AM, Miguel Ojeda a écrit :
> On Tue, 03 Feb 2026 11:34:07 +0000 Alice Ryhl <aliceryhl@google.com> wrote:
>>
>> To get rid of these helper symbols, provide functionality to inline
>> helpers into Rust using llvm-link. This option complements full LTO, by
>> being much cheaper and avoiding incompatibility with BTF.
> 
> I have been testing this. I think we can go ahead with it, with a few
> notes.
> 
> I will reply to a couple other bindings in separate emails to avoid
> spamming people too much.
> 
>    - I will mark the Kconfig option as "(EXPERIMENTAL)", since that is
>      what the commit message says and it allows us to be a bit
>      conservative.
> 
> 
>    - Clang passes `-Werror=unused-command-line-argument`, which means
>      under arm (i.e. 32-bit) we get:
> 
>        clang: error: argument unused during compilation: '-U arm' [-Werror,-Wunused-command-line-argument]
> 
>      And under UML I see:
> 
>        clang: error: argument unused during compilation: '-I ./arch/um/include/shared' [-Werror,-Wunused-command-line-argument]
>        clang: error: argument unused during compilation: '-I ./arch/x86/um/shared' [-Werror,-Wunused-command-line-argument]
>        clang: error: argument unused during compilation: '-I ./arch/um/include/shared/skas' [-Werror,-Wunused-command-line-argument]
> 
>      So we would need e.g. `-Wno-unused-command-line-argument` there
>      close to the `-Wno-override-module` one, unless Kbuild or
>      ClangBuiltLinux thinks it is important to keep it for this case.
> 
>      On the other hand, regardless of whether we fix this (and another
>      issue in a separate email found thanks to the UML build), we could
>      instead add `depends on` listing explicitly the architectures where
>      this is going to be actually tested. That way maintainers can decide
>      whether they want to support it when they are ready. Thoughts?
> 
>      Cc'ing Nathan, Nicolas, Nick, Bill, Justin, David, UML, ARM.
I'm quite happy personally to just have 
-Wno-unused-command-line-argument here, given that it otherwise is 
working pretty well on UML and 32-bit UML.

That being said, I expect it won't get a lot of testing (regardless of 
architecture) while it's hidden behind CONFIG_EXPERT.

Cheers,
-- David

