Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FA61F46455
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 11:57:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E33A96B020E; Mon, 16 Mar 2026 07:57:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDDCC6B0213; Mon, 16 Mar 2026 07:57:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1DC56B0246; Mon, 16 Mar 2026 07:57:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BFC5C6B020E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:57:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5754E1B6EDB
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:57:31 +0000 (UTC)
X-FDA: 84551776302.08.7D8D4CF
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id 90CB2C0008
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:57:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=G6kllRCA;
	spf=pass (imf28.hostedemail.com: domain of 3J_C3aQkKCDwYjgacpwfjemmejc.amkjglsv-kkitYai.mpe@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3J_C3aQkKCDwYjgacpwfjemmejc.amkjglsv-kkitYai.mpe@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773662249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h1fcoRP59CGw48vJfNa9YQqD0Rlv5rHRkuoFgchM3ME=;
	b=v2WD60teKHT1WIl0URAzTBC0744rpilk6gpINLHCp3826H3eqjLkSzzQfsXp5CQIq7/wVE
	coKr2ArCJnOT6cMnBz6j/GzMMn8vKnUqW10oXMxyG4nhinoSUUUjy5janrqBTM3w7lPe7T
	BI3NqoO5Z5ygXwV/1/UYM/LW9CFyyog=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773662249; a=rsa-sha256;
	cv=none;
	b=o05suVoF2RQ/GKI5rZZQaGd3Sge4P83XR4FI/VyNe60p9r9cGBy6HTaK1unUndcYXvsVjj
	UcEuAqLAa378gg82iMIA3dQAjFhUj8KtuivsX/FYtba5QtsFgYrnY083m35sUsQQucQQTn
	Khc3jY8pS67r/Wnr3FQJfaDgXvz8RNY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=G6kllRCA;
	spf=pass (imf28.hostedemail.com: domain of 3J_C3aQkKCDwYjgacpwfjemmejc.amkjglsv-kkitYai.mpe@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3J_C3aQkKCDwYjgacpwfjemmejc.amkjglsv-kkitYai.mpe@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-485397788b3so42195735e9.2
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 04:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773662248; x=1774267048; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=h1fcoRP59CGw48vJfNa9YQqD0Rlv5rHRkuoFgchM3ME=;
        b=G6kllRCAykxxdleKY4UMqbIEo6Wei59hVyg6NenBvCPbpEzgMexglZLDUFdnxQ0NKR
         aiqmWkD8fNmPcgAeenFZABOiPtespSWnde5sJdIbq6x7euNd/hN+jfKse5QMA/LKsR3u
         5++qnYKDoqsBwOddk5FXPHLjfixlu8a4rFTx/k0fZLiuTK0dqwfMLpsTsuprvblH6V5F
         W8hnM1ONBRcvAjAliUTPimTnoJ1+pnreckbbRcs9ozgLDJvzRWRZUXPQ8THj99yGdv23
         d8tZj0kS/vP5z19IyHD9gna7cumIlJkUXuVXI25RMiLp6Q6jm6Pg6ARheDTbLFsJEHWK
         zvLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773662248; x=1774267048;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h1fcoRP59CGw48vJfNa9YQqD0Rlv5rHRkuoFgchM3ME=;
        b=oFd2JdH/EXOCUzMiFHuFfd6vSF3/FZe74n5d6+RI5Y6eA1Hnk5CNd57grziaKy1tuJ
         N5D5s/vZcoz+d5xO5x5aFSu5Y4NC8913OUVZ9+zJjrzkTY/zZ/a9g0nKpHtYCm7LiMGv
         HPvtLZZqPi/I4yS10OSKsDInHh13v52yTnZZB4xw+nQ70CPLzVzuGt4+9iytSYqQsrqO
         6E44/Ys2/RRY/3vBeDKLi+juZ/DvH2fOAmJxhf37RRkXfzl6ujbWEmlRhnOkF4ADUHVL
         fUby7Yn6eJ7z7LUldFBvXAViGm69P4A0j7/U9L3jv8Yk4KZX7Wd/QLzpKOtEyU6cDtmZ
         EUkg==
X-Forwarded-Encrypted: i=1; AJvYcCWlzlcD2DvtWj2nQbMi2bllPfpjm8Mz4gJqvorwvydkhs5sPxCdEYIqRxZ478padAgMId9ZOIPytA==@kvack.org
X-Gm-Message-State: AOJu0YzGp4Too/K0TaViwP/UpSsUrmfz9yObanseWxVnURM5Air5xKPj
	ISiRE7jH4sillG59XKjAWHUyAD2S+hAWJhRzQAyZPkyHL6Ghg7CcCWb5iVyoT6EbV3EFn5O3QXb
	F3oSDEGgykyTrEzZOkg==
X-Received: from wmbeu8.prod.google.com ([2002:a05:600c:81c8:b0:485:4f26:fe69])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1395:b0:485:2fc5:3a5 with SMTP id 5b1f17b1804b1-48556709d85mr206811255e9.26.1773662247858;
 Mon, 16 Mar 2026 04:57:27 -0700 (PDT)
Date: Mon, 16 Mar 2026 11:57:26 +0000
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-25-de9a7af4b469@kernel.org>
Mime-Version: 1.0
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org> <20260216-rnull-v6-19-rc5-send-v1-25-de9a7af4b469@kernel.org>
Message-ID: <abfwJrDEHoaINFwH@google.com>
Subject: Re: [PATCH 25/79] block: rust: mq: add Request::end() method for
 custom status codes
From: Alice Ryhl <aliceryhl@google.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
	Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Lyude Paul <lyude@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, John Stultz <jstultz@google.com>, 
	Stephen Boyd <sboyd@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-block@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Stat-Signature: 6499mathppxzius8k3i5udx3mperibqa
X-Rspamd-Queue-Id: 90CB2C0008
X-Rspamd-Server: rspam03
X-HE-Tag: 1773662249-223715
X-HE-Meta: U2FsdGVkX1/BC2qOtQIaslWwxt5a0TShnoPK96z2qTXgXFgs6nAYg32oco1voqrkWTleiQjfsA20XFrTjWpBT16IWLSp/cjzc9PGzyTsDBmLtgA24LOQ8Nq60zgt9lG74igu/IL2sdMIVGbWxku2CKxIoivGIgTPi0/6chjsP3IqKvrTxcapoHJcFntEvBez/PlXMs5W2/HnOpaXQprXa2B1crC8E4iS/szNHyLMPpOysT10uB6jMimIn/4lSSdea0RYkcLw7vVEbHK1OSmUp3eckqLWk3Tl65xcuN62o/aLR4NiF9NWQ5vF7H8xvc4OJo1NDEf+ccuP8hKoe/wtBEuAP9zYsbuNSl3YRnMm230BMIyOLmDHQ6PB4QN5lV/TkgC9sqNlztdr5u4G4FvPJ9fEu5WHwuvPtC7VGCuHZBQC4Auhrp+13/GYpB9dNMYD2JScOgJtj4KhGTy1mSgugN/NftROJApQm+pBz28fW7hY6+Ty/6w8i1SsW1l302DFND7rZ+SF7u4I0mG3r+KIKeoB0cB8R7ZcF+7uOdbtufVoIlejUp+1RATsz/GSrvFDvmxLppym1V2ZiEH56EOupXU1c6VUybCxygnOuyHJfReEXrZ5Cu3FSMhsGYqo/jeLPx6dzYvm3RKMXDboOyzewaG7IZH4H6VuEPWkUgooiv0bbxe3MnIhK5xSHBYTenRcLThcUiNyIDsq3z8mZS0TVyl/0hTp8rOvmoLX9CnFNJwzADVw7C5wxbAaGGSh19vMcWflVMHCNfurii47KNk04hy6DXmgALOXuABFrAjwMj1Y+k9Hwlr3XAY9/+lP3u7FW9YoPfgQCiyHBSe2lHjZcmm09aYb9enbDO74kffhh5ArochhFl8UvEJixf/HOEfs/kqFgf7KLP8Y4kfroME6QRlU8W5niN3cyrfKXZR7QSbi2fJMjE8n8L4zZt3/TIkcS7DRKzvDuJVygZ8XLy8
 rvzNd/es
 1/i5WBslTUbrW0aF1I9qrIwvIFzeZQKQs/4vQvGz/I5ANjjcA9505Jf3eeTH6rt+mVyFif8EZ23O0hE+tY8m6WA/Kn+4avPOdfFCKAh3S3ri0dPMktYqv0FOTzu6FGEBPKl8hajsCW0StGBMmAKBNb4mV0L0bo8cNGwJXHU+jX+ZGmOu6ilju+IBK0XHgKQSoRBvOR0r5mKqrxXoixgONSD3sxVi0oCcov4Rr55HumFUImwpxXvJ4W60fQPY+QwbC/t5nnEPbFGuBLnI5yy4MROIRi6i+1c22SMmd3jzaVCkXibSqM+lGhR4v+kr3WXdwo1BN+X9TG1rkDdfiNdmMizFarCMqw5qePjcMoNYPLoVwC8swH0pLcnTZzm3cM7MIvuArui5tjz9a2Fp4OD+BHIW4NKafUp5Vj32zgjiYEJwgJBBTWn4Zffm/CNKUB3ixlrHarwbXyhIUaRvfFq/Ue4t6EJhrQHN9ONaqLxE/93fbFjTFDVOHyGShKZyu1TmSiSn2ipubj4sDSBA7GYnVWpW4oZCp2IyAwgXLw6bmTns88cp3govKfg+oatNJuXgaE2bezq4Ea/YeGhTp0i5SnLXqlHlC/nTt7vryYBAuSNh0/QSE4fCMZ3SDvIlc2t8ZUyKQ2CzmZk/CFEf+CDyaUN1+w/TofGfqyBXtzCSaSENwLeymBd/4XQYsMMttg0siBNsg2TLigM1xrSE1CdCjSFx0Uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 12:35:12AM +0100, Andreas Hindborg wrote:
> Add end() method to Request that accepts a custom status code parameter,
> refactoring end_ok() to use it with BLK_STS_OK.
> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

