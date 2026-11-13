Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB56C606A8B8
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 19:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h5pWTRhJ
Received: by kanga.kvack.org (Postfix)
	id DF39E6B05D6; Fri, 13 Nov 2026 14:48:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCABE6B05DB; Fri, 13 Nov 2026 14:48:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D08556B05DE; Fri, 13 Nov 2026 14:48:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1B996B05D6
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:48:05 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 45F7F14024F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:48:05 +0000 (UTC)
X-FDA: 85431131730.03.241D4F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id B71261C0005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:48:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h5pWTRhJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794599283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KPVgxbMcaQt+PxgzMn7lDpFwudV/imA9OGBWE3yEdS4=;
	b=zsqWhrtkZYjKGZ+JLgl8W5dZpyPiWQw8cz7W2lZH84bVHpcvIfy+qm1M8C7947vJRDQwNd
	trGy74hb5FiHCQg8Ujzt7OrvRR9SmHDKSeoiPK7AxcE4qaBI1Gc04BtC4Q1sbM38c46Ezn
	OJPZ6Z2GqqP2eCw1iJGX9IX1VbM54xE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h5pWTRhJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794599283;
	b=lcOeCCWbgJQXaQv8DiJQv2MSTUlWnVYHs8IXZ33zdcPViR41BTkBKUoXOJr87uPOkSzc0u
	yRoowHlPQvQhk4NIX+atStKYUR0g9qVHGGoiRcye/1gaXqfABDMVIo6swbQS+59bv4hxWS
	YuUAD9K4j4j/OyKZfqkXeyopvB6eu94=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E7D3C614AE;
	Fri, 13 Nov 2026 19:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B1A1F000C4;
	Fri, 13 Nov 2026 19:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794599282;
	bh=KPVgxbMcaQt+PxgzMn7lDpFwudV/imA9OGBWE3yEdS4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=h5pWTRhJEjQTLAprJHZOSC5NCgwHLbPaK02HqqrXWW3c95280FCOYgOE35TKVEFeQ
	 hZ/dOceFvH6/Bb+F/nKQhKtPE3qn1ZlE9HC55FXE/2i0lNIOfZ6uEUfgckmeMzjhb8
	 tofzngjW7MIXc4YQwn8ue1kqKMXA+wluy5Jz75fhtEw+DXg/+9Xk6uvhZtr4RTBSYf
	 UN6qbFKxUNQWR9Wl0QKtRoe/X8nBc/FquCGQPstpndCwJJDWh7kphbxSP/HcgcK8JM
	 NfOXb73jn9c8Lsb8z8JFxNybrcBD4VYw2ICbvdb5B5PbZd9Uo2qbjNJxyoauA22dyK
	 Gnq/XVVO3akXA==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: =?utf-8?B?5pyd5YCJ5rC05biM?= <mizuk1@mzk1.dev>, "Liam R. Howlett"
 <liam@infradead.org>, Alice
 Ryhl <aliceryhl@google.com>, Anna-Maria
 Behnsen <anna-maria@linutronix.de>, Benno Lossin <lossin@kernel.org>,
 =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron <bjorn3_gh@protonmail.com>, Boqun Feng <boqun@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>, FUJITA Tomonori
 <fujita.tomonori@gmail.com>, Frederic Weisbecker <frederic@kernel.org>,
 Gary Guo <gary@garyguo.net>, Jens Axboe <axboe@kernel.dk>, John
 Stultz <jstultz@google.com>, Lorenzo Stoakes <ljs@kernel.org>, Lyude
 Paul <lyude@redhat.com>, Miguel Ojeda <ojeda@kernel.org>, Stephen Boyd
 <sboyd@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Trevor Gross
 <tmgross@umich.edu>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v2 83/83] block: rnull: add zone offline and readonly
 configfs files
In-Reply-To: <3246e50d-2489-4a79-8a72-550bd90fbd90@mzk1.dev>
References: <20260609-rnull-v6-19-rc5-send-v2-0-82c7404542e2@kernel.org>
 <20260609-rnull-v6-19-rc5-send-v2-83-82c7404542e2@kernel.org>
 <xQnB2LuMsjEqP6I_00brV-s6btUZeSUsphCHwn_VvMlpxQiBhyrwDmHAKc-Av6sQbqdw0h8HassEoWDSbVQxxw==@protonmail.internalid>
 <3246e50d-2489-4a79-8a72-550bd90fbd90@mzk1.dev>
Date: Fri, 13 Nov 2026 20:47:48 +0100
Message-ID: <87qzgov7h7.fsf@t14s.mail-host-address-is-not-set>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B71261C0005
X-Stat-Signature: udjgsu79ip3mp4cgzac537c8yu968mce
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794599283-257979
X-HE-Meta: U2FsdGVkX1/ibNWcUKhVlvVM0Eu5TTCuhOqpCwFYEeN4LI5Tb9zrlIKbGahnHCcblsjvRaqxLhalRx3lY1nqlfK4x4QQD7zGJDkfa7ovBz1TmfeSME2xxQrTgqdwPp+aou5tz9ZpulUmG/UAkPyks1xLjinCrc5r5f1kEt6YsMNCvnr36lU65xnaYD2j+pqgktl7BOi1qBiCvx2zWR6VNGASCTUX5bXyvMa995igZd59MCrIHpZOayApgW5xEZK9ELMifQ8PIozTATk7A4qZdbNaw3aVGSFhJeY3wJruI2FKeRa6VyUzOBidV3NNgOd9pDMjQ9o+K5JGtJDrCHPNc6i8JTzFhrmE9MbdYCwppoN9up1a6u9NZ06kdQdOY2Cw2nAv+2DrOaRl+SE+guAlmOUeKQOOf21Dadsu37DVMQRHVXyvkg8eAX6ytIAcVlm3TUJi2997JhlFequpkzHJKomg4NBxp5Pez4TaKXzc6IYFNCdh7OEUZ1Gwpio15goNEJXKY9dcYt1pWTvAa45vhdr/ePTr9WTqpJYqE/9EAaODPRHlVn78Vf/sZMdsiDF1Uzjb3qPCUQwlsjfcsUH7/985SCB23zEfHttGzBk9et/brLaV6wThKvJnh9yugkrGdcm2+DjI7wS7SvhhehsWP9oTZgKO+mPsVXDTlaN/80feRc+dDokMGhUj7SZusVKPWxMf6iQdbHRiCIglivbcp4h7JJVxqMWa01KXrdtEIkEU3H+rUL8fYzUHKAx1KPmbCLkiiVBuGwLZyWnFyRfORPrMjXXk79S+Yc1P22POF6gSOXaCEfyxgyJxqZSzWrIX+8I/O9T2+90N/gEEDzz1IwzFza9vfH8zqoCKLKcGXYrcRO3cuy+dtb/CRqZ7UrfGocd0pt0euzMijbmEODES7WNfQsFtHosfp0zyQlN2RzP1FUnu57MQCz0UHO6IzOvNl3htZ46+hyMnmT+Yl70
 C+2x/5qN
 IvA1Hic61vQ0Oj9R7K8U4zZElONy3tPG67W20BfKC/SAtt3W49YhusZIVDDvHCG8BwQ4dkHTfw6vHh+egCKXr/QcCO/LWRfC3DC7yZuyKvfaWbkLwn3JkOB4w2Ol+HnwFAPlPS7d32XRdYtbcM8YxxIxJpslw++HvazG0zm9YkZICVsBcGyovchSMlYRNNPg143LP8HeHi/W8UBhaQ0IvCuXhEGlWMN5HtEJQS0DQJ8HAoCQsmE8e+GJYCFZJhA+xSsT10vpkj30w3TdtQakIIxVUP0Fb0FNKnS/3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

=E6=9C=9D=E5=80=89=E6=B0=B4=E5=B8=8C <mizuk1@mzk1.dev> writes:

> On 2026/6/10 03:09, Andreas Hindborg wrote:
>> +        let mut cache_guard =3D tree_guard.cache_tree.lock();
>> +        let mut disk_guard =3D tree_guard.cache_tree.lock();
>
> This takes cache_tree twice; the second one should be disk_tree.

Thanks! I think I need better testing for the discard feature...

Best regards,
Andreas Hindborg



