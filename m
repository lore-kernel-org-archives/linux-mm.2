Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D4FCC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 11:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E513A6B0088; Fri, 28 Aug 2026 07:34:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E01BE6B008A; Fri, 28 Aug 2026 07:34:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF0CE6B008C; Fri, 28 Aug 2026 07:34:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B4AD56B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 07:34:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2C6AA8033A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:34:22 +0000 (UTC)
X-FDA: 85150469964.27.4C9BEFA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id A03131A0007
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:34:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UBtjaPyC;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787916860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aVAmrlglLE77rRk7z1dV/xgJ7zMGLtYyUqx4wOkAvv4=;
	b=GSETxG+SFjZIEMJ/ix8Q4FTwa/KN3uWP9yoNWM/PSdSaTug9NnuyF73miANOM3/c+v72Oz
	YrrhLneS9ehAw7W7xgSeorJH73lDJ6IDLGUM1+x5HMp2VtFoinYoUmwLEeMTMYOv/IVRd8
	xK99Nu0IpR2fL3AuMP1st54QasIaTVc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787916860;
	b=gD1IGoy47r+hGh+gqNNrjX6tqWEkw6dj//f0R9En99TqKIe1HytCuiaP6xfhipt2KbaIcC
	pibtXktHs+LzN8u2aliqp0zO8QHAFlVYgHBBIIRM24ZyyyhA9GcxZn9NiIZyPUl8rt5tIg
	oLAfMyAkw5S5Jyt/zmkcNpKhg0ZCD1Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UBtjaPyC;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C476542A64;
	Fri, 28 Aug 2026 11:34:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B471F000E9;
	Fri, 28 Aug 2026 11:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787916859;
	bh=aVAmrlglLE77rRk7z1dV/xgJ7zMGLtYyUqx4wOkAvv4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=UBtjaPyC5KeW+gRQBhw5XwdfblRwrGYqGEff0ZFdw1mAb+xpFJKdWc5hTLPYMUnfo
	 8k0BsfLlIL0reJtam3yuDJK8wlEEyHjaK4vm+joZLkGYzPIdoSrBDOHz4haIiVlba6
	 n4nygRX+HUzxV6NWI865wpSnA5yC3B+ss38UZcYwAMRuObidA+R6LvY9eazer2bS5s
	 42020SsDPrSuuZ8o+SVYPfef0ewklnT+9G24YKTNPKsqs+45Gw8GUDwtx/NOTMO3pL
	 Fw+w2b7t/jEzvGDzrqtR42g0yzBgQl5Wh2c4+z7riprHig42aFQ7gFGhdkADfSfvnZ
	 ieY6fAMkK/Iuw==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Tamir Duberstein <tamird@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Tamir Duberstein <tamird@kernel.org>, Boqun
 Feng <boqun@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Harry
 Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, Daniel Gomez
 <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 07/11] rust: xarray: add entry API
In-Reply-To: <87mrua74c6.fsf@kernel.org>
References: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
 <20260604-xarray-entry-send-v4-7-965f6028790e@kernel.org>
 <178067251358.96312.14084909265600226392.b4-review@b4>
 <87mrua74c6.fsf@kernel.org>
Date: Fri, 28 Aug 2026 13:33:56 +0200
Message-ID: <874ige1ntn.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: qk9tereiujgb53w1ziy1guukcp6bmy5k
X-Rspamd-Queue-Id: A03131A0007
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787916860-450197
X-HE-Meta: U2FsdGVkX1+/U/6yNLMQYbYE7Vk0U2ou2mkVzvaOPUB7m9KSFhIY/OFYaR7AlKYQxqpzUGKcDl9STd5n+OPLsuO3IRwY/tByXr4XB+/YxF1pRyUdeDfsoMzK2z7r6VNkNBpDs7KRhay6gcVh8K06iz+OeQSwtBbDdrKGJ/ZJtDu5y1kAh+I1CM1eF5LGdMW0rog7zJBQbLo9YlXx7UzfrTtpYNYvV6HNYPAhir02tZgJtKV6YwuZNN7ugnoWn37cdtqxPNIBzHI2OpdQxuzxFTIGoAPZD81dqtgdWY0qGGM0fpdZ8YACyERdpoEY9GvrhpJRd0WOt3OIQ8w8WYUlFn0kfqwmkIpKaR0RMuzjh/vOGfmBxiN8G7iQfzECADmho4dhAOivapwNlUxautsZwSGQLcxk+P3M32ZR2XwNB8usDXwnmj8v0q1G+8ui8dKK1wafMk0EfVoacG63l/K3EMQ1LvDGQtzq7PfT+ss3jViwl9P6Px8cuwplImssxfIP42nhZqNTPoz76QDgf0Ny4lXRFs/f2lqyD/aiOfJUtotuV599X1HKp//dU44YW0M2Y7TXjVsSt3QPn83orOZ+TuR/XlqueG232cKJQXW/hxiFDYPGmShL9ZjCeE6NqTqERx+OR7qugqdTUGGq9JGGcQpJcILQ6RA9toYXTogmbjG5kaPiYdo9binY06tzfk5oepymcsNQ2+LjZK+cPTOdJ7oWDoHehFjLe/8nJZ0rlYB+m7b3HWFoswaUHssCg0jxgQbD669EWbA99Dp8pk7To8H8lwnKVsTkPrF/0bXlqbmcyDvJrqBtddqEqxPwd+CrJByzjGyEkxAh3mQmbfwqfK4xL+m/H8LUr+jxgwch7smSLpmmEtl/BqpP2w7fvTzBaM9usLBVr5ZhKzwr3toqDlZhP/BcVuKqg+7sl6I8u2Rbu7xb5EcGiKhfR55/WLID3yegufGvrngtVJt0Egt
 jl2Vr/LE
 xPCMtZ63s1oeiNC0ORjXZ4Rn1ErifnjoEq34izayy3x7AetJ2o2FXzDYCxEJr1DvnND4zyEbhT6GVxTwwe0IaWaSLGuYEfk19j78hUS6e4HXSsOymnY2y7RNx5TCkmZZkSzlO+g9xaeQ9sgW1wM+20/45Xu7HPJLFchZ9sCYgLFOcuJFPbC93Vznfk0wvI/70Vmf3QMXu2aJUHXO3P+rvsydvJRIgd2LactuBHY1l8tbeyn/iEvt4GjywMLGCvLWOK5L8PGP2XulPZR7UA/an4w94A1bMkrSJSZnwB4p0Q9OlDAcZx/zNZ7oGIraU7tc1rdYyAmQOgTyKVA2Ahx6DLnWFHdsGazoLKUWp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andreas Hindborg <a.hindborg@kernel.org> writes:

> Tamir Duberstein <tamird@kernel.org> writes:
>
>> On Thu, 04 Jun 2026 21:58:13 +0200, Andreas Hindborg <a.hindborg@kernel.org> wrote:
>>> Add an Entry API for XArray that provides ergonomic access to array
>>> slots that may be vacant or occupied. The API follows the pattern of
>>> Rust's standard library HashMap entry API, allowing efficient
>>> conditional insertion and modification of entries.
>>
>> There's a lot more API here than this lets on.
>> `find_next_entry{,_circular}`, `Entry::is_occupied`, `into_guard`,
>> `insert{,_entry}` (do we need both?), `index`, `OccupiedEntry::swap`,
>> `Deref{,Mut}`.
>
> I can amend the commit message to enumerate the added methods.

Looking over this again, I was pondering on removing `insert` in favor
of `insert_entry`, but I decided the duplication is OK. From the caller
perspective, code will be cleaner to read for simple insert operations
with the `insert` method. But complex query/replace operations can be
completed more efficient with the entry API by avoiding multiple tree
walks.

Similarly for `is_occupied`, code at call sites will be easier to read
when using this method.

Best regards,
Andreas Hindborg



