Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 577C0CD8C81
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 15:15:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8F2A6B008C; Fri,  5 Jun 2026 11:15:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3FD96B0092; Fri,  5 Jun 2026 11:15:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7C226B0093; Fri,  5 Jun 2026 11:15:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 969BF6B008C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:15:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 194C71201AA
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:15:41 +0000 (UTC)
X-FDA: 84846208482.27.7B6B55F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 57F0F140013
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:15:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hNFGN8bG;
	spf=pass (imf26.hostedemail.com: domain of tamird@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tamird@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780672539;
	b=SJe6iDl6tWSyGVvkAkUHQYIZn0cO3KfwK30LXGKdmuVkCCUr9rD14qr5IIr/h0GSIrh+87
	qRqb8fCRY1C9wulJRLJYlAcBaenUnKUfCS17+WpZ5yZoAGhmWEdkCy2gHZdWPvydC1fbsv
	L2b/SJPR9Ho1ySyBx5Eke6Ow+7lBX34=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hNFGN8bG;
	spf=pass (imf26.hostedemail.com: domain of tamird@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tamird@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780672539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m28nkewcyqgL6abQPpmwBZHkP7XmcVeR2cfNbPfRcgw=;
	b=jyJ0z9lyMOhDH2VAw5ssQb6dSHSX1ChckjDKw2jlRF3odwokkEpsvJ2AKa8dN5FR8PYgIB
	EjX+nMioXJUMUNYzFiXf6sDtb6n7g36r0WtSDdnIi3c7qMInDFEV/owwPH2YeFIdxHyHdV
	23S4kGDGMWOPGpTrTEzo3GU79Xkqdq4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E3D2F601FD;
	Fri,  5 Jun 2026 15:15:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C231F00893;
	Fri,  5 Jun 2026 15:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780672538;
	bh=m28nkewcyqgL6abQPpmwBZHkP7XmcVeR2cfNbPfRcgw=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=hNFGN8bGicL+Ge/BV8PW2aaLc2p07OPtI1bbcmI+TVtAMz0k1xFNz0XRSScPYJIFP
	 oZ5rX+zDkFrKXCgb8TM0uDvCDCC9Y3N9jDWiahC9nK6UNizXSieKNJ0uPgn9UVKL2d
	 jNq9bV5sJc6BM2CCJwO805IUbofdeQDjFAnA8KB5DHV5hCFVRzoUS6LLkvF54iAkbW
	 Rtel3vI82cAiXr6wLDvoLTIofxBBVWijw3OAvqStKAA8juLq1b/rn4CLKVUAWk+Bvs
	 P6KXKdj82hLwuYfPrRtKzD9yHjWX363uOAJ7JGa4gDtJ4JF6T2bmR34n0V428NZk5M
	 wUo2e/dRghljg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 05/11] rust: xarray: simplify `Guard::load`
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
In-Reply-To: <20260604-xarray-entry-send-v4-5-965f6028790e@kernel.org>
References: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
 <20260604-xarray-entry-send-v4-5-965f6028790e@kernel.org>
Date: Fri, 05 Jun 2026 11:15:13 -0400
Message-Id: <178067251349.96312.11784247103754750756.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1015; i=tamird@kernel.org;
 h=from:subject:message-id; bh=EkC6+9W3siIvte4lZvaojy+iXrYIEK6ZDWqpH/zTx4w=;
 b=owGbwMvMwCV2wYdPVfy60HTG02pJDFlKL4TiTDqWeV4xvOvlulvqnhNL+cyYr9IRj3z+lkU01
 SqlqzJ3TGRhEONisBRTZEkUPbQ3PfX2HtnMd8dh5rAygQyRFmlgAAIWBr7cxLxSIx0jPVNtQz1D
 Ix0DHWMGLk4BmOpZMxkZ9jRWZZoFnFRku2PovOvSs7kOeStPNwcJ1d3LO6suX7qhj+GvaGrozpg
 dwRPWz3VieRLPu7Tdbs916YCahusH7jppnM9lBAA=
X-Developer-Key: i=tamird@kernel.org; a=openpgp;
 fpr=5A6714204D41EC844C50273C19D6FF6092365380
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 57F0F140013
X-Rspam-User: 
X-Stat-Signature: 4m4ohn75ke9t5517cxwjij8jh7fao6d1
X-HE-Tag: 1780672539-777887
X-HE-Meta: U2FsdGVkX19h++Dfo3cQLZ51+0pm/wytWmTUCZn/6TAJ4IF7AD2sdYn8hicaDef/DCGIydHHjsl0SsI6imaLW9WKt6tmG/oKZRSKvBJfNrcpePI4rOlmQMHFDVms2qbJpUcXHGOdaCp7K7Te/FJB3SzgbGdumP70bKxEYh6m6RRHddyfkzVO7UjSTCn2d0Rp+rx2OYQgPVDjnIFiRa3Z4lpeVHFXQx5tQqImnNF2NQ+Q59T5fT+DphdRuRJkZNSj7nOVqXCk+t0e66ueYl5jtTbs7yYl4LhKY6eScUaZZUzqZehAsCWO060a+fkrrn24Whr31wMNSTiCqydbzRzoDBBz/xGmm8halmVpiqTNRQrsyrcG0AXpcwwr4eiloy7uJ5IEqx2aGA36kSE6jHAHY2mc4n19oGSzcZvqEhvWA6WKAHVX2u6GgscR4/oDLwfozhDvMaQYoXnl1mCklacEWbsgxZGT/O/gR6/GEeBCeNcj/9a9lYFa4GYWxOcn9GaP4tEgUriDwO0el+65pM7c7wpNGtY0YRO14AMzi4R27x6EyA8vaCkkTEgnz/dvDngdJ8X48FmNlKwCjBTsUE9ABgqSDsDllaU9PjaCII0CcHc8101B3eKz18s8oHQ3nSf39vJZHHeQyeLHdLnQ/IpXC5ph21iTsKCOClolNn11EJC4/b2vag4syOfOBhrFV1UqkgsUAovdTXmn56MqEJ/96oFIhj01Z/CkCxGLGEZNCTTw19W0p/FVYbJAnZEqw1H3uAQgShjZ6h3/f+UEi3U9cr/PoXHC3a7D/eLsJz67z45gZynXZ/CGnJfB2uQFISYgctDDSr+3yzYXdI18TdE28QGdwoPHxMQr8oCvuZNLVUKYE5nkTcj2mSms1QKhmQNgtT+e2zIip9oZiDVUiiTDyBLUMMitaUjaUGU9Vi2J5QOnEmcj0Y9x0LbP1Yn5+8Eq5W6wCO8ScWIQOPoZ/xC
 7yrbQ/cT
 VT8PbXjBLX/bNz5uhG48GId329ZrxA9ahPwnPsxKf9ylJckvNGn5TT+3JeoZxxS5pTfVWlxCApysODfzYX29jF5leEk1hstjOyhIixph7wkoQVR4+mP3PDBqEFgoZG3EDSgbP+eUbV/XXus0swt8QsChLX9uIFMA+cbvrsqIyom35mIvHRGmNxvQne7tQ4mbBVFQYcp9CF0kSFj1pTjrRsLlT/VPoIFe8mdxB87Nt1OA/oJJKPp2HualkQXp4incWn9IHX4Vt/jpuhSZUXHAJlVEZBbDeoFBygRb5+xGja5z6WXVNeHMSre5m8IZdCIq1wOxf5Wt6MPAq0ykFKrotxQemKr6jQVpeHL6OOgepKh3gob8VrYDunAoiS/yighVktv3fXTUbJqJmE/g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 04 Jun 2026 21:58:11 +0200, Andreas Hindborg <a.hindborg@kernel.org> wrote:
> Simplify the implementation by removing the closure-based API from
> `Guard::load` in favor of returning `Option<NonNull<c_void>>` directly.

This is simpler, but the closure-based API was here for a reason (to
avoid passing around untyped pointers). This patch is estabilishing the
style for subsequent patches, but doesn't honestly describe that it is
doing so.

>
>
> diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
> index 05e6dc1ffe69..7da57c778669 100644
> --- a/rust/kernel/xarray.rs
> +++ b/rust/kernel/xarray.rs
> @@ -212,28 +212,23 @@ fn from(value: StoreError<T>) -> Self {
> [ ... skip 26 lines ... ]
> -        self.load(index, |ptr| {
> -            // SAFETY: `ptr` came from `T::into_foreign`.
> -            unsafe { T::borrow_mut(ptr.as_ptr()) }
> -        })
> +        let ptr = self.load(index)?;
> +

Inconsistent whitespace.

-- 
Tamir Duberstein <tamird@kernel.org>

