Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D21DDC87FC9
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 11:52:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E8526B0088; Mon, 28 Jul 2025 07:52:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 398D06B0089; Mon, 28 Jul 2025 07:52:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AEA36B008A; Mon, 28 Jul 2025 07:52:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1B3536B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 07:52:17 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A1CE71D9427
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 11:52:16 +0000 (UTC)
X-FDA: 83713510272.28.D909756
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id DD57040010
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 11:52:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="P/MfShGk";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753703535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uPeW/9KRIBCXSWEOXmRN1ZvMW98LTf503eXFcr9wZ5M=;
	b=eBdR6qMnADX0f07YbzaplCZLKESPUUB9+pzFtQOLIwUWRlxMSp26e18yu4U8ZKNb7dw/Fs
	deCf8xTDOUu7ZTzeKaYZsDbNDzQxpr/iNaNniWn9nqTx+d2XSwOaDAexxVOERaCHRwoKUR
	OtmXLQIYleDSotioMobmzJwecTnJL6U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753703535; a=rsa-sha256;
	cv=none;
	b=8DPQC4jQkBDkKlAlW9kzBSXyETi6O0KGzfYEM28DT1SOgpAE/hFPhaaNwN2PD/IeNwVL25
	Ixuhjqo3zOXWTcm6cr5nFk4NV03EkGydR1oRhY1/bTIUkg/ArfCJcLxZScshW6+J/Bk8Xc
	IOkmMBHp+yR7Xh1SqJarrAggOO8h/Zk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="P/MfShGk";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 921CE43414;
	Mon, 28 Jul 2025 11:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5882DC4CEE7;
	Mon, 28 Jul 2025 11:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753703533;
	bh=y5EA5t0+m7pAfOk/7curMHBYuu3le3VLD2NQ96Z2RYs=;
	h=Date:Cc:To:From:Subject:References:In-Reply-To:From;
	b=P/MfShGka+mtLOvxdyWbJu1ISKnFOjol18r7iE1Gt4gb6CFkoqL+c3IzJGKAMLBci
	 2e9JfkW42YRiEpGWG7s0YcrDz8Cwe3+Vvhas0xQzek7bx5FFF/obr8xSR4Z8o/IW0z
	 OX738bXooQHzT8vrVutBX4N2ayv6iiSqWCDXc7+qf+N1eKumj2O3ebrKQi1OOOPRNc
	 CNDT8WRqtPc+pehKL5zzCgrg1F1zgbt2S+PD1M5EzP60HTJs2RZoR0wpVqKNwziRby
	 B5odFtZrG0Zl+olijbxTxDsMit4xYMrAXn5FkKwrbO3tbfRFlISZWWvvcxNqLJiMbC
	 fClkRXN45RkKA==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 28 Jul 2025 13:52:08 +0200
Message-Id: <DBNO0N1TDAGI.2OEWH6Y60JNYZ@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Miguel Ojeda" <ojeda@kernel.org>, "Andrew Ballance"
 <andrewjballance@gmail.com>, "Boqun Feng" <boqun.feng@gmail.com>, "Gary
 Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Trevor Gross" <tmgross@umich.edu>,
 <linux-kernel@vger.kernel.org>, <maple-tree@lists.infradead.org>,
 <rust-for-linux@vger.kernel.org>, <linux-mm@kvack.org>
To: "Alice Ryhl" <aliceryhl@google.com>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH 2/3] rust: maple_tree: add MapleTree::lock() and load()
References: <20250726-maple-tree-v1-0-27a3da7cb8e5@google.com>
 <20250726-maple-tree-v1-2-27a3da7cb8e5@google.com>
In-Reply-To: <20250726-maple-tree-v1-2-27a3da7cb8e5@google.com>
X-Stat-Signature: z7jbjnat4z6b1nqnis68gz7kbr8s7fqp
X-Rspamd-Queue-Id: DD57040010
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753703534-357849
X-HE-Meta: U2FsdGVkX1/N8qCsvr6UohA4ZRNA8sOTGd3URxCjoqf5E+6zytn0u6WTtFHu9w7T7r+l9QFfsPCIdn8uGb46mraBvVsPxyIkRS/Bf6+LORhyFZQ+LpRYCWoah9ToyhwDT3PFTfKvLAJz2KLM2UEEiRk/RrZR4X7sMeLhMbFZGWLAHCqrjt/Tr7VPYvc8Go/3y5hhcFjcCFRRtKBqdRTcu47S2Ohx3Z2/tAboy3h21M+rq9H7IAdFJ8WCS13MPbkAqX4xay2IjHjVbtMfffRksIBJiXWCFAxe/iF4fPl+TYtA+4WAevi+hUHF7KE0I3mD+oFe+sKT0KU3fXiVaa8B6BlJCBXKy53bV2WPzn+M3BN8ShYKDOP2QdHawvUoZCE2ti92RxXw2DR8EJT30FhgmsuFt3R1aueSBfeFMmCun7g4UECTzE9D/pKzUmgbyxeB4tCbAcmg0pR8lr70ig9buUy0AOEKI/Bs7PmjtsUnhJ0MGAMod05c1QUA3p7yAPfbmvwqFA8RXHVtfgvncCaR6y33h2ez59W2ZfpeNAaurMH1bSjSDOhbTTWGSKOtN5Ht+BAPBCzHjcWM5aOZWQHLlcuWFJalCVrn1FqCSryxepEj5OuHmnci7I2F8BV14By4mE99xvAcFODjz2echxOggUPcRHb2Gy3bm8htt+yBEgpGyuGEYV1x0/quqCziBS/SBOQj8OXZknD6HZ8wIL+fuo/xf5MpWRKYnjMjWLU+sp3Hw3PX+3+6Q380rZOd89BhrMpY5iPPJx3+wjqRGq5pkMgkQdJeajxmSJAfC08DjIpm7vJgVt40QlO/M9OyDrVrj33qaKrMUoNFmDi3PMS4yM15iumn092Ji6mVKyKt7B0XpxVJoZOra8QAkslHxJRHzJSIxhsVk2ZWd4xUF1wPTNMWoRqh8eR2WuTTGFvsAJ3QBvdcQ7qzlIs9rkiZnZnA77MqofCmpI81o5Figej
 846vkprn
 jQKmYNnsmVNcQBBdGmrpdE2glNV6BjMqxlsiNBzcO8fN2qbhXkIPeLLm9dknjl6kLbFAvBzOm/8MONpn2qOpSOWET6jbZOaNinnj1wELRCr7Pw7Y86EKibg8HA+35izxYehrmlyP+iV4HAJi0Q0FxIdpjqEuVWhzYET3GCOt8FcTHrPS7zFQB/IAR5O0/ZxA6rKNEBJ9RrlQBct3TRHnMZP45RIapVrcvtE11wRJOIO0YudmYAyMzxpzKcFyiph7rfSfw3wqSwHNmph6UunNUL7VBE+9iRWCFGFWACyiC5dmbW3klPBEZ2HRZKrRzAmetRiQIrYGyPZVIZ2x93qVpVLDrR9wtwV0l2OLjMEo1eM4LOeg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Jul 26, 2025 at 3:23 PM CEST, Alice Ryhl wrote:
> diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
> index 0f26c173eedc7c79bb8e2b56fe85e8a266b3ae0c..c7ef504a9c78065b3d5752b4f=
5337fb6277182d1 100644
> --- a/rust/kernel/maple_tree.rs
> +++ b/rust/kernel/maple_tree.rs
> @@ -206,6 +206,23 @@ pub fn erase(&self, index: usize) -> Option<T> {
>          unsafe { T::try_from_foreign(ret) }
>      }
> =20
> +    /// Lock the internal spinlock.
> +    #[inline]
> +    pub fn lock(&self) -> MapleLock<'_, T> {
> +        // SAFETY: It's safe to lock the spinlock in a maple tree.
> +        unsafe { bindings::spin_lock(self.ma_lock()) };
> +
> +        // INVARIANT: We just took the spinlock.
> +        MapleLock(self)
> +    }
> +
> +    #[inline]
> +    fn ma_lock(&self) -> *mut bindings::spinlock_t {
> +        // SAFETY: This pointer offset operation stays in-bounds.
> +        let lock =3D unsafe { &raw mut (*self.tree.get()).__bindgen_anon=
_1.ma_lock };
> +        lock.cast()
> +    }
> +
>      /// Free all `T` instances in this tree.
>      ///
>      /// # Safety
> @@ -248,6 +265,83 @@ fn drop(mut self: Pin<&mut Self>) {
>      }
>  }
> =20
> +/// A reference to a [`MapleTree`] that owns the inner lock.
> +///
> +/// # Invariants
> +///
> +/// This guard owns the inner spinlock.
> +pub struct MapleLock<'tree, T: ForeignOwnable>(&'tree MapleTree<T>);
> +
> +impl<'tree, T: ForeignOwnable> Drop for MapleLock<'tree, T> {
> +    #[inline]
> +    fn drop(&mut self) {
> +        // SAFETY: By the type invariants, we hold this spinlock.
> +        unsafe { bindings::spin_unlock(self.0.ma_lock()) };
> +    }
> +}

I think in the future we also want to give users access to the mas_*() func=
tion
familiy.

I assume, MaState would represent a struct ma_state, but also carry a Maple=
Lock
guard. And then the mas_*() functions would be methods of MaState?

In case we want to allow to release and re-acquire the lock for the same
MaState, we could probably use type states.

I wonder if this (at least partially) makes sense to have from the get-go, =
since
it could already be used to implement things like MapleTree::free_all_entri=
es()
based on it.

