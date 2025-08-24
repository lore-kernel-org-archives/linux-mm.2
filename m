Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C475CA0EEB
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 13:29:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E1C18E000A; Sun, 24 Aug 2025 09:29:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B9708E0001; Sun, 24 Aug 2025 09:29:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CEDD8E000A; Sun, 24 Aug 2025 09:29:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1D00D8E0001
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 09:29:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 983CD1CF791
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 13:29:15 +0000 (UTC)
X-FDA: 83811732270.26.BB6B539
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0F0EF14000F
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 13:29:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h3J5NmeT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756042154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Za5HcBGWgH59fgpcQngk4nJcZ1D4Mmel47j+ShPVRrM=;
	b=V+VNmroBFSalFJg4sToMVWGfOt+wjlg0/hDZwCiPx8tbGPBbKFSHP/jjhrCmoZPvZhuF9q
	SL8qCGZxc9/Jt9Yc02YTBGZqZxGRUlia+tBOnAN2Mviy2ttiOZxNzwL7DEn/SnbmJCl7Mj
	HidRAbtFGrjANuaMHybgMbcrsg4ZYEA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h3J5NmeT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756042154; a=rsa-sha256;
	cv=none;
	b=AmJ9FHnNkQaLhZmrz1ah6RbNstJ2zg6ATPVlEpUBGbPh4s4ux3YnHxDdGpvbHkjDWV0lsM
	HtVV2qW6hreHKMjcwSIXvhGcb9vE7oJeSbe3MgeLNXsnYLvmsNZEFHNF/Oo8fK4O2Uy+xv
	Xvitc3ljBEo/FiMbwGI5Zo3JEpNGAEc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 70CC1601DF;
	Sun, 24 Aug 2025 13:29:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5B3C4CEEB;
	Sun, 24 Aug 2025 13:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756042153;
	bh=Za5HcBGWgH59fgpcQngk4nJcZ1D4Mmel47j+ShPVRrM=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=h3J5NmeTAgHwCvms9IKXJOPBaphM0ZJfFYo2OtkdNt4eiIPFT1UGwn3I6sGWkvUot
	 xnQ9o6aEaaAyXbViHVnhBSgYxvinB7TMlMRQxKdnTSkLnMmRoHmWoan6S9nLbIJdJi
	 md6kzFhajZgKW608fuoeGZu6ljwvOBgQ3mRL/tnb9TbgDEkzb+EI6qJfMIv7w9jeit
	 bbyrxtgpboSj0alrAYNkiwHW0VBsPDu82Wc9W+mEzTPSTA24KmNb7qIWNgLG93YvAc
	 EnItGxPiMPtC5eglRnYW0UwTT9O7n6Gu3MQ+5MKUohFmd5DOEX6HvCAVolIdwpJM1K
	 zuIm0SPA+QuSA==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 24 Aug 2025 15:29:07 +0200
Message-Id: <DCAOZLKAFK8Y.43MJ1XPUJ1OG@kernel.org>
Subject: Re: [PATCH] rust: alloc: add missing trait item MIN_ALIGN to
 Cmalloc
Cc: <lorenzo.stoakes@oracle.com>, <vbabka@suse.cz>,
 <Liam.Howlett@oracle.com>, <urezki@gmail.com>, <ojeda@kernel.org>,
 <alex.gaynor@gmail.com>, <boqun.feng@gmail.com>, <gary@garyguo.net>,
 <bjorn3_gh@protonmail.com>, <lossin@kernel.org>, <a.hindborg@kernel.org>,
 <tmgross@umich.edu>, <rust-for-linux@vger.kernel.org>,
 <linux-mm@kvack.org>, "Miguel Ojeda" <miguel.ojeda.sandonis@gmail.com>
To: "Alice Ryhl" <aliceryhl@google.com>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20250824120656.208978-1-dakr@kernel.org>
 <CAH5fLgjkqcyzoZD7PP2i4g4r2uqpdbDKVW5hLfm6c9ysbxkPuw@mail.gmail.com>
 <DCAOH44U57K3.2CVDYWF8MJBWL@kernel.org>
 <DCAOREAIJOR9.2N5JW0SC9YT93@kernel.org>
In-Reply-To: <DCAOREAIJOR9.2N5JW0SC9YT93@kernel.org>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0F0EF14000F
X-Stat-Signature: swi1sbnea9iwj6fjxsziim9ahpqnomjz
X-Rspam-User: 
X-HE-Tag: 1756042153-363371
X-HE-Meta: U2FsdGVkX1/lsYyG8unyhrCnZwowaFz7j0fMXYXyYpo1tTYzwW8Lfk0uCo0oXPLgS9zoFZ2F0D2ON3Ak2hmfKSVAtjUsY9lOFixoDARzpgDWyMcLVm+THZFgexpCtYaGtFnie+mwneIPhIi6NA6+1/S4QulQNy3QChrPX5uii4w6y6udSuhAjVe/mfvJ4Cm0985U/JeznratCyHfW3TyBzDbqrQw9Ol8+c/BNFNB+MrM0ntuFp2p5JPoF79h9vfUuvoZSecAwbv9KluDPLIbOoaUR+7UErrE9x4g7qepSkqo8gc1fSMH0j9HYLTtg55lGR0GN7hYEj5tXtSTqe1HblbZBtuesbGKXD8mInCrEJwpLoRKhTCxwx6tSyjg4OQnFSTMYyxsDLhypIWHSw8wznVZjv0DjBbhYknrkI5OSQjMk3AUhT1lflVTJtx/AieNKIEYw7MqEPL8DXBYwSByc13AHqn5m0DJF1+Fm/sYLDZPkZxiFCu1acvRpLq889TWpxDtP5fjlNXcAGPYuM6OfRVxiewq5QqnY1czgU6fRpImnXL6x/vOw8wpc+aq1R4W9eBhaiXQ0kLSkZ3VKLfFH6FmGoEwevlszEJ6X4YIWtdd0pamEhGiAPuXkaaMkZxPYaHs5OWrGLrPj7EOpGBgC5wfeZ5laXRDYoKdK3VcukolMaGZMhgIJdbLNw1KZY+nAS6c7X6zrqUhAtTIjoCpWDgOftT/Nq07u2Ysvk691XtMixSXVSIDENRCvP0/35mjaV1q2FFq0rxti10R5RSxcSt3qathTC9K95/6Fog6vd7DKP2oG2HjSTItQHCPgYw7NWSAFDcB0mvKwovwHMixNLrR6UaoSMOG375jsI6CjOyir4KWQVVql7tbSPCWip1SqAEokoLqCvhN2Luk2ZVUQKbWMilfGJsiD/zUii6uxB6kpZD/cgL/UUBx2OURJ+z+08sQwlUYPbebInJzJ2H
 3RVWlW+C
 nmPCwyBOVkJbFDlaCEP1zANbG4pQIVWl7Afk9604kJpKPys3rRXqrIpAobCbLSex+9JvfUEtenr2wo+Us2c4yEb2WCrkj+j9tgyW7GQpRpFa7++lrn3jJyrYFeR68eETKSKQIQRDXz7IkONXxW8sFw0RN0mXmYgRc4mqxAHjCY7kFIRsHR1pDDV5ATFHIcXV6zaQyDpcIaVokLhkB+xlIy3hMjZn8GA+CF0FaaT4StzjkmVqkAByv8/MO8DXGT7dsYnwy1Z+LSSw8lyLFkfzhmfxzqjKII4yhWMt2UJm5BVb+3vprPWzSqYPNRrQlGnNJZ10PZVqAxs7sNWW+O2nx4vrU0qsrzQ/nLDjtazrYZEKIUXtvsoG3YwQbBDcoTpN6usH2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Aug 24, 2025 at 3:18 PM CEST, Danilo Krummrich wrote:
> In the end, just another argument for getting rid of allocator_test.rs. :=
)

Actually, I think it's better to just do it:

Miguel, mind if I just apply [1] and [2]? (Just recognizing, probably this =
was
your intention anyways?)

[1] https://lore.kernel.org/rust-for-linux/20250726180750.2735836-1-ojeda@k=
ernel.org/
[2] https://lore.kernel.org/rust-for-linux/20250816211900.2731720-1-ojeda@k=
ernel.org/

