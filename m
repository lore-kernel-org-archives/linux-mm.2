Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8057CD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 15:15:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 526E46B0093; Fri,  5 Jun 2026 11:15:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B01B6B0095; Fri,  5 Jun 2026 11:15:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 218A16B0096; Fri,  5 Jun 2026 11:15:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F0E406B0093
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:15:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A8BCF401AE
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:15:43 +0000 (UTC)
X-FDA: 84846208566.16.79D4D9B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id E482F40007
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:15:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OC2UtzHD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of tamird@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tamird@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780672541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=75Qlg4fk3oODyHBzCwgS9w0a+hSPmlXa3ywbw1l5d/o=;
	b=MIZNUIT9uwwNYEqzEjNMLMZiUZspgryz6Ero8elJxyC5HufDXqUJ/zJqoPDI1jQYOfNH6Y
	5g+1jBGpHS65Xo5U/yYItOyRafsV8BRfwf/adcEBijQ+6eJziOwNRtxvoCt/CQdyl60hiq
	KVSEEwYx60yMTKCu8GP9vG+8FYeLdbY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OC2UtzHD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of tamird@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tamird@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780672541;
	b=kPzXxmogiJgRbL2J4hWNWpk5Tp5SzSsf6AI6jDuNCsTBvC++1XTM5LhOYJWfAStUS2AF4v
	LbngQybBQskPHu3TNB/ouERiYnaWaZIdxsKXadBotXKMBU0+3JnCze7ayjBtWgyOOucoE5
	e1gGKUnFI/r45Bz8S/M0yO/lHiw6ysc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 72033601FE;
	Fri,  5 Jun 2026 15:15:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0CA1F0089A;
	Fri,  5 Jun 2026 15:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780672541;
	bh=75Qlg4fk3oODyHBzCwgS9w0a+hSPmlXa3ywbw1l5d/o=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=OC2UtzHDzAUOKyaiu6ce4D2hjONJyP8OAgQ6RtM83JvvrcFaq3duFsvzW/gQvS/3z
	 yttvgRI74u8uHD9qAPteT/9Shyqyai76W6VQgZnqwS1r4VJGyOLXokOL1dI83rDsi+
	 Ug/jfMH9F08bcQu+TERrmP5YmCoMrPq35f6nogk8fgBRKrM31n2oNpOXO1VwPSJ+ML
	 goiLBHjnGHH3BwVX+dPQTv/8aReQbdKgzJjJqAV+MNaYpm6kN1IlW0vMSnmOOJoXte
	 wGKH0H3qTqb6c2qDiDQhTUEpK4hMlVTh20hA/wORccCdWa/iv06LvrIJeWg9X1DWFL
	 7vhknbVj43Ceg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 06/11] rust: xarray: add `find_next` and
 `find_next_mut`
From: Tamir Duberstein <tamird@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Tamir Duberstein <tamird@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Daniel Gomez <da.gomez@kernel.org>, 
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
In-Reply-To: <20260604-xarray-entry-send-v4-6-965f6028790e@kernel.org>
References: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
 <20260604-xarray-entry-send-v4-6-965f6028790e@kernel.org>
Date: Fri, 05 Jun 2026 11:15:13 -0400
Message-Id: <178067251353.96312.9527123475656114033.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=739; i=tamird@kernel.org;
 h=from:subject:message-id; bh=4Gas6D2Ieqxv+wUNf8Y+VGE9tCZEU+wVvtnj47a3isI=;
 b=owGbwMvMwCV2wYdPVfy60HTG02pJDFlKL4SUZrq4d2zbfUSo35u9T3zbtc8y1+f+eGIrqfNh/
 aacL5FGHRNZGMS4GCzFFFkSRQ/tTU+9vUc2891xmDmsTCBDpEUaGICAhYEvNzGv1EjHSM9U21DP
 0EjHQMeYgYtTAKb6exwjw5sblYxX9swJDdOqZbQMjz4/xV7pR6Pqtk2aDM9eM/VwuDAy7DD7KGN
 U+aEoQae0lfF4vGqd2JFtIvw1ltMtmIWOPNjGDgA=
X-Developer-Key: i=tamird@kernel.org; a=openpgp;
 fpr=5A6714204D41EC844C50273C19D6FF6092365380
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E482F40007
X-Stat-Signature: otehqwx5c84frhyoyqyuarm7cbc6ywcr
X-Rspam-User: 
X-HE-Tag: 1780672541-22546
X-HE-Meta: U2FsdGVkX19iQM+HDmI8qL2l0B+rr+QYtbBPsoMnnIqmKRk+a8KpV1CCZG1zb28nfFQiVce7shSbIm+bo2omKLc/bzFuqiYgvJ8/xOAN+s3qsjFOM1Jlicb7RWw+642gVgwssUvmtvyZ6aJ4OkwM2QKPwEBcV/ZghUGYlY/b0z8z/ziL3qYy6NDS34TDGy0D6mpe1Q1PguDr9fJR94Yo8Vm+95sT9H4va7Z2gltFMwOmGWOsS6tgIl7qO0JuXBQKlfH+ax1WGLppI662SS6ZPzj0AJUe+a9oD3x9pGp7pykzL2OOiVPyUVtZt1/kbEN9z/uF9SSdkvih7WCdQ0LL5px1nwvGyNNHZlZfDTruFugJFTFqXlRCsHkFbwU6x1PpgmB98MBVUl9xWYjE/scJsfdd3e2A5eXuUgF/KI57yONSn/OObOyWdiICvdV9sx+dlCSsyJFT/XYw/amyiB7WMbyzTLg9uTXHwJHmxZ4KZc3n5ypPDa/ZRpr1hdItyUtSnLwj+bNHD/m5vzFpitG+8Gjuq6Slff2Hpn/gUNrrKnaJY6cJzrXJ0d47ggWUClzVyXHyH0qyl8aWMtzem814Cj6Ftr0ptNZV1sRJQYDg5clLa8toChh3j1f+ihknzR0aBc0pENtGuSmOrxCZ0DsEWonM31SZG+7Uos/5/wAxSUc3TbOcIyWC5MwdN5TngHvq6bSB8VAH/uboMchw3874FrHvywozZgliZCOv8qMh7N18SUBJMIystbarTsB2jbmq+tvZprv5owE8XY1ckWk6NDlSqn3Io8RgwIvRjnKfYh/nqztSDN64HkPAdty5fEgMNR1KipeKgbPh6uu/rodlA8vJMZM/aCAFl9FHJy9TYU6VYRaWqWsWyg91G1eZlBbM7VzYgRKaWP+SjN33EvaKLo9cRvIGDAUDuTJkRYymXXzbijziPEcp8/7r8hKTaiMJQElV4Ltmuumhx8m8b9v
 zWJC83bj
 eXIzAD/cqiOcYFd0WZCD8IDSFpxxfg0Dx8icXR91EQhRBZT8E50oSy10NL29LZnyLGbCu3FWjzh4JAuwz/xTa05bj5q1S7VLdmZrENWLMTglPx9YXOpQ1PrhnStoqyEDpV883glEbnW0KZy8JYM17yJ3aJue+tZy8II/3ehaLIPLLUSiXkcsDKNY2ELx6zjmejIT7nCwRFi8EUpEfOa75GZFCVgtiLfZGAa9iWF1jR33JYr/5JaRhZzYBA8kIo4uXazNXUK7Me1KMI+QM+Z3l4BFkKi6qkijaaqaR/a9/LM7ZxHQ5CVpEx7t7pA1waWBJbhgdBBwteTmgZcZgyG37fs2dGKRLhywBxFFpBrR1XLbeD5/pow23r32YD6AbqE1ex1xU2nA2ISwof88odlGzcI7opKD9CGir/FsTYQnIjDjSN/s9Q/nFjvnyTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 04 Jun 2026 21:58:12 +0200, Andreas Hindborg <a.hindborg@kernel.org> wrote:
> Add methods to find the next element in an XArray starting from a
> given index. The methods return a tuple containing the index where the
> element was found and a reference to the element.
> 
> The implementation uses the XArray state API via `xas_find` to avoid taking
> the rcu lock as an exclusive lock is already held by `Guard`.

The previous patch re-hosts existing XArray methods on XArrayState, but
this patch and subsequent ones are choosing to grow the XArray API
rather than promote XArrayState to a proper abstraction that users
should prefer. Are you sure that's the right choice?

-- 
Tamir Duberstein <tamird@kernel.org>

