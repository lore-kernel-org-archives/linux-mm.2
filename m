Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E885BCA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 20:53:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69A0F6B002B; Tue, 19 Aug 2025 16:53:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D39C6B002E; Tue, 19 Aug 2025 16:53:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49BA86B002B; Tue, 19 Aug 2025 16:53:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 368686B0029
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 16:53:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CAC3F140227
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 20:53:23 +0000 (UTC)
X-FDA: 83794707486.13.C46910E
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	by imf15.hostedemail.com (Postfix) with ESMTP id D2487A0011
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 20:53:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zzg8fiTr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of andrewjballance@gmail.com designates 209.85.167.181 as permitted sender) smtp.mailfrom=andrewjballance@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755636801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cccifdKxwgVIxGkwbmtQ1TWALCMGZnlgxiuGwopgW2o=;
	b=xUsHl7/Ce7Mware8YAyPedbzW8NAikHC5QpE26TiyfvlzSjUeqA9rw5OQ+xXxcD4Q4C1Bh
	qDzPbCxJfaJdV3l0oIGXMGm1A0oBniU0PVeaqb1GA7sW7NWbu4RR8kdtpuCsUk4dVdw+qq
	vi0lwAxiUvM7FVrlnjsbqLGdx4EMIHM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zzg8fiTr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of andrewjballance@gmail.com designates 209.85.167.181 as permitted sender) smtp.mailfrom=andrewjballance@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755636801; a=rsa-sha256;
	cv=none;
	b=czJeYCBAx5hHQtIhGqFTWN0EDKKUZzUcgW0eCKvE1g04f1OhY+OjhljhPOgz0yJP8WS2f7
	lfNVQOXU8VZAx81HBhLc9W9NBDof6cnyll/VY5xshDl9Il26QfH4BrUmWOXOivqTPuMdWe
	sxjGD1IrIfen1GH+mrZxoPMfVbCoJCA=
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-435de801abeso2123711b6e.3
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755636801; x=1756241601; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cccifdKxwgVIxGkwbmtQ1TWALCMGZnlgxiuGwopgW2o=;
        b=Zzg8fiTr5VRgDHsoynZIaDfir8kSZWtOtffekw/3VHtqX80qnnuD1HOJE1zdP8X1Ob
         Qc9w0DBBPPJ1o7IDHzZDeEa41rW6hnrDc4WsXj3ryh04OzNnK9rlEHld1WnP7jEQiP1l
         DJCejUCYluOumN/HNYMHi8i83R/gksPgfKaUtBHdF9i6rf9Qys7gIPlGcchSG8rFjQYf
         v5JV6p2SDTbb1DJVwTdKmXHgtBSxvOoxM5cea62QGmPFLgrqICObfiuSnFLKyyDeIxiJ
         RBkMCw4ceWrHvERbFejQdC+cE9AMSAS6884XlXr0wHPuFMJDHqd+pTETXPmtFnYjbvhx
         i7Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755636801; x=1756241601;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cccifdKxwgVIxGkwbmtQ1TWALCMGZnlgxiuGwopgW2o=;
        b=wQzI0xpDLTDWnJVYzbtUcXpbMhNt/VmR7g1LmqnvXBysOSJFydMsh44Np4Wwhtonny
         ufJUIVDfj2DnkGsbZkWzB3NrEi4Xp7+aoK7afnrSWRO91neZ3bT9rlhxTTNrfqzc7z6v
         fHckKweHkF9yVcRwK9aFG55NV1H5hkfse8FM0poLoDJKRpW6sbqWEHztO3WRm+KWZ0K/
         4tfBQpHLUHe9irSYqwiE9e1EJBjxShsAVnDtsEAmubGuJTSy/vOA6gw25Tly1qo5Je4S
         niG2v2a4gjv7l9BhZVyiItmao08VaPvC16CYBQCUkJtLPa8nqLyD2QDtjNSZdI1leR9i
         YP5w==
X-Forwarded-Encrypted: i=1; AJvYcCXXYFGa8965JKJwTVYzePTA7OpT2Q+5wu1L6jvELxNLbi0vpDesyVP5UZnacDQmTGzmsEA3UrIdwA==@kvack.org
X-Gm-Message-State: AOJu0YySCBVWmsICiIx+PfQU6NKsZ2DikT29YbT+fd79zPnwma+4okw6
	aey749ujUsTJ88kpLBeYgLBZxcCso0wSErd8lRTND9kyuTvZuaU0K+Ka
X-Gm-Gg: ASbGncs1ZrgO/B/+gobVyzESsQoQNi6A4LKpCiN/ujgA7I61S3yPTA6WPjkbwCScqxg
	w/O4onEcmfbwBLAoltL5udNZk6wne2TCc9Z0RIWajqFcLQCECOanozUO1Fcs4OcsxxDBvy7+aJC
	39OAytAnjHom90Km3nCMcXdJTpVBbrCXBA+GF75t/bB0fPwS7LUVoUpnLe39NZHIHwtV+lMsoOB
	8js1RQWUXPtg2qYU5qpjIvPeeedFYx87TUb+mb4HssciwAy5cgniuKzz5j6KvDw08ZEXf3WgSIA
	gXIWZRw4oywpsdWMbMRkmoviwtfnfnWQUka1kUxGBG3CZE0zczRxzpQL0fbuchNIwyd+Qt5ISeB
	dBTDdGweKLpZAseOkPwPaNMD5a8TTf79olUsV/I4S+f/wmsPiD3eXyqVq1v1aSx2getu/Nw==
X-Google-Smtp-Source: AGHT+IFQLVe/eYDYQgpfKh6ZkPeTyExiDauVdsWHpI+hmDZYMy7Hx6bM1cNBtQ69VAPnx0ro0riEjw==
X-Received: by 2002:a05:6808:190a:b0:40c:7996:73e3 with SMTP id 5614622812f47-437720d8318mr245421b6e.28.1755636800587;
        Tue, 19 Aug 2025 13:53:20 -0700 (PDT)
Received: from [192.168.86.39] (c-73-76-29-249.hsd1.tx.comcast.net. [73.76.29.249])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-435ed0fd6b5sm2480745b6e.5.2025.08.19.13.53.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 13:53:20 -0700 (PDT)
Message-ID: <0d4bd6c7-4611-4b7a-bc07-8b18336e74ab@gmail.com>
Date: Tue, 19 Aug 2025 15:53:15 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] rust: maple_tree: add MAINTAINERS entry
To: Alice Ryhl <aliceryhl@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Miguel Ojeda <ojeda@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
 rust-for-linux@vger.kernel.org, linux-mm@kvack.org
References: <20250819-maple-tree-v2-0-229b48657bab@google.com>
 <20250819-maple-tree-v2-5-229b48657bab@google.com>
Content-Language: en-US
From: Andrew Ballance <andrewjballance@gmail.com>
In-Reply-To: <20250819-maple-tree-v2-5-229b48657bab@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D2487A0011
X-Stat-Signature: 3rzkzyoq6u1qi4z6kom6t65adyhas69t
X-Rspam-User: 
X-HE-Tag: 1755636801-194793
X-HE-Meta: U2FsdGVkX19nd46Vutnrv2TqCee4+4WDagUua+oZDa8qriguf7WtiPsvbmpLJ9/anj3oXtNXveynU8gjhYiDTbU1UxVIu0QUFEqVjX8x9ksQTtyYKd18VtmydUwzMuUyLSQ9q35ZY83bTSP/ll13XR+P207G+sH8KUxgC7tbdFFLUhWM4AmJjAiEnbEZ8293u39p4UaRg6gzLB5RSCxohk8uTokwXvifQqTKrvv36aG2uyccRy5aDHy7GCV+DXCHGCL4YqMApI+LnrN7w3pI2kbnN0hB/FjP6a3YqxkXFAKtPPTik5yJA4YvVfOXh3JD1pxOJvOUEtvPfEQUuvTPJQw3n4h8jAOZ9yjBciuM500GwwK7ntORresq9AceHlwB47eeodSzUcd8xs2VHaDg8pzI9KwgaGmn8akC4oLczOWzMOBHgZnjPXQu1FCl5BJqKMwAjMM0redNZYXFSq3M/eGNNRcC80gVXNfRkGA1Xi/tyNMd+2F71EEA7H7sovgP7vzHEhne5N6R8JSN9HA4GKelCg+8GCYBmGArk1D+m62CnS6+zVhvA1txhZWe92CI2vKfO6dqLEySBNihdc1LEfonx052F7aFI2dH5wadMY+IBlfTInTqwnkKKCuvqQIdWO8xbIaSl7eZ4UrVIwxuVUYIwD9o3BOnqf2I2fz+05bIr2//l3t6jUMX1zl0p1kzT33fwKLzdSlpp6QsNy1y7JcrsZv15O2Dxe+dlL3ogp8e52ltttKF155DA/NDEm0mdjkBHZ1cEmCAzZB4vkJvxsKrVupp9mAIl+yYYyoTFob7c4k81gN3RS3QpJ0ReHtQMs5ZaW6nCT3UiO381ug70VkAlxADBO4iE2nNa6nxF//MhX5un/exL06D3GUQQzYieW9rN4FDZSIpXXtt1OEFeLyDFO7Zob/Z8ihBzAglAeOBi9KGOC+dHy+u75BPnkm7uWQKGls5NZYzXZOcDHy
 JdOs3KnH
 KtilkHZrxeGLbzmzuzisnjNuUQ1BKkwmnVdw7Imq4US8/3LVMjRWgbQl5fX7rwB1bIjSKrnqjq6E3wXYsxHa5m3CoqeIP7D0p/l2cxpQf15Zi6o2m4jzM2s22T1otpEzU07MXi9BbaGJBXGeDLU0r09j19TtbgtwOXu8C3zc4aaGHRlmTTqxGr3hDYXIed+9PTObPRfChC6AvpIzcdFLhvytBbuYxrZvysUAPG8bbAjpgWmLjwim6pfZ4xpWneAOl380O0EBPd1he7+wNswmeUGBCYu2E+6RnGl6f8rTuTrajkVjdfpH9eDUB15txSi+gqZRrDCJywtDiO8i77JqJS/R/ljeE81DdPWD9YP0SwpUYiHAIPbJJuyAvxuBV1lol96ooRCfxgbqATUGX68xangKwtDUgNModFuPIlt6C+RCTxFK95i4ynRkigZVncRbZ42aMkxAKbobUcoBYLPQ8KPYGmC4Nxd+bUrhuC520wSYupPCw/awUSgmc3QJe2MhxV16aZAZgcUhZ0iHAX05NN8O3WijI50sXb0wnYFsMpUVx3AjMQ0HmyNNFF/Emyk11fm2uHKe4ODst7yifwC98+Yc6mBEsqEjc9o6BTrO41XxdgeF8PyvqiL/j4zBl/LcvdYMeQr3i7pBZgUhZYQYzTYdp3NZ6vcFTWT2PI844/hYAsFe235PJTYHqgHU3LNEA8JFyN5rRC4SDBmzsVWWcZ0P58oZHo6C4xZF1kOEeH3B6ht+AGA+4VkOyvFhHNa6omZ6CReTV+ZDELVw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/19/25 5:34 AM, Alice Ryhl wrote:
> Similar to and just below the existing MAPLE TREE entry.
> 
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> Liam: I'm not sure what you prefer for the MAINTAINERS entry, so let me
> know if you want anything changed. There are also a few other options,
> for example, I could just add the files under the existing MAPLE TREE
> entry? The get_maintainers script should still send any relevant patches
> my way because they also match the RUST entry that has a wildcard on the
> rust/ directory.
> 
> Which tree does maple tree patches usually land through?
> 
> Andrew Ballance: You mentioned being interested in being listed here as
> well?

Yes, please add me as a maintainer.

In regards to the discussion about the maintainers entry,
personally I would prefer that the entries for the rust and
c were separate, just like the version in this patch.

> ---
>   MAINTAINERS | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 26053163fe5aed2fc4b4e39d47062c93b873ac13..4a52d884e36eafe1c819227207123c51caf02ee5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14674,6 +14674,16 @@ F:	lib/test_maple_tree.c
>   F:	tools/testing/radix-tree/maple.c
>   F:	tools/testing/shared/linux/maple_tree.h
>   
> +MAPLE TREE [RUST]
> +M:	Liam R. Howlett <Liam.Howlett@oracle.com>
> +M:	Alice Ryhl <aliceryhl@google.com>
> +L:	maple-tree@lists.infradead.org
> +L:	linux-mm@kvack.org
> +L:	rust-for-linux@vger.kernel.org
> +S:	Supported
> +F:	rust/helpers/maple_tree.c
> +F:	rust/kernel/maple_tree.rs
> +
>   MARDUK (CREATOR CI40) DEVICE TREE SUPPORT
>   M:	Rahul Bedarkar <rahulbedarkar89@gmail.com>
>   L:	linux-mips@vger.kernel.org
> 

Best Regards,
Andrew Ballance


