Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B980C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 14:09:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B60F6B009B; Wed, 15 Jul 2026 10:09:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88DE76B009E; Wed, 15 Jul 2026 10:09:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77F706B009F; Wed, 15 Jul 2026 10:09:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40D5C6B009B
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:09:25 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C2FA6A010E
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:09:24 +0000 (UTC)
X-FDA: 84991193448.29.C08CA28
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf01.hostedemail.com (Postfix) with ESMTP id C20934000A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:09:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=S1THguRb;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=aliceryhl@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784124562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1mcx5kizqsJiWKU3Assktv3idKETuJ14oVMLxFKExzM=;
	b=jth7u/aLaRc+XPIXjhfLFV++Rr3Soz4Ba7W7hx0NAPIRZwGP4QuFvISXATduJTmtFpf7Jc
	Fzlq4qm7deAB/ucOEY7DMIIz67MyMthcJ/14mUwavbSLm1k00IuV6rVGj5eJRNRMQD66xU
	qC8XN8sOxYWTmo69wCZSvoJVokMFF2M=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=S1THguRb;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=aliceryhl@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784124562;
	b=rhQUGRG4lQT+3YWc+Tcu/Z7CCrKxRB1C+JkJocmBTrT6Xg4mE3pbyMcaAdniGIyHCVXztX
	kEhu3Zv8yIDMMYGm/+oasT9sUxgiAUOC9s6pnQQk8m2WLvBogIaxM3m4NEVn83m0LymDd9
	TBQVisCnJadVX+8c+SaWGn6eg28YgG0=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-493c19bad03so49173145e9.2
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 07:09:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784124561; cv=none;
        d=google.com; s=arc-20260327;
        b=AOFhpmo2jrShsOFNghHoMEYIqdmSGa4jKR0q79PNvQdE3ls/U2J01a5Xmc6FIxRKsu
         qozw48L94r8sxD24wMvT18XOicg45OGtrYyTAZ9b3YSf4i7K+N6NO58eCexN5ADCgNJM
         irMF34KKjFwEkBd5t6YQz+bsi8tfWpNoA+KN4lRZVz++89gy9xrT9+UNEZAtNGYYLFaD
         WmIQisv+OUUjzBEQJpT0Vucufp42TOT8q75jGNYXVdIR9cWinShQuWWIDIEF7jSxmmdd
         n1w47j2tqxuXJb5jVpIOBZxbdGy0svCUfPeZSDAk6YYFz+eQt0CTxW/9CDkzntsNK/Nv
         9JJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1mcx5kizqsJiWKU3Assktv3idKETuJ14oVMLxFKExzM=;
        fh=mMzmvVlMUI0yilVQzpdBOL4OX5OL67CPx70b6GRc/2E=;
        b=Gnn0SG1BJW/jvdPn43bLUUMhk597XN0Ej6ZPHfYNwoH5EX1d7t2F80AsKciHcFVSmR
         nlgc0j/DJISlXMpqtj4Wx8wdhZMWHOjX3SBcnWZ4qf+rIi987fOePoUQZMs1HRsruULy
         JzCa7R5BZJipkiSr28jlnbLCmlU9OjvOyEpLXEwfb/04TcYpuDii4dBeaTVcaJQl+DgO
         FmiP12kzyVVlZ312J2oBIvglQ9vZSDPUGuxN4lZSf+97UnuYYZYVAQxyBY8IVevtdDp2
         Igj8VsltktVxZig7Yd5Tt9y7xasmqHxnboJQp4ky+x3FmLkfTYdUNwG+YMs0PUXQWifz
         hrWA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784124561; x=1784729361; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1mcx5kizqsJiWKU3Assktv3idKETuJ14oVMLxFKExzM=;
        b=S1THguRbcECw5XEolkN3SrD8QVSrdcerjRaWcIqdsdu/FZ9h6snPiCsN8DMXxRnVw2
         YSq35Cbiaqli8iA21tAVnIqcEsiYpVWkCMHLi3b9zb2IYVhHpmqoNkNQ/iLAMvvKl2qN
         G1zLTM7EPgAJmbQwQB3W8Z6ewNzCNIYLOzOR4B263P+B1yLPOmwkN+34eKVqLbFOHJK+
         ukOYzYWcpmL1ceJz9GxSPCfki7sFDqKPm6MQyUZKXufOqnSWKqch8ey9pkSr0d5CYtvY
         JuNzXkccZ94KukslJ8op5ZPNitojtg/P4wKMaO6zU6xUcExXOP4DzVeehC0KneVb0K68
         qHeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784124561; x=1784729361;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1mcx5kizqsJiWKU3Assktv3idKETuJ14oVMLxFKExzM=;
        b=NvB5H1L6MedeLrKVeiTiJKolXtPQaQEvIkebAkgiktiNUW8sVF87coL0WGQbFG58dY
         E0w0x1b1edV8vxbFDoCqy7MZl/WHnGRnNbPJWbvDxIp9Jo/FioP8CEsmRCwz0VmsIAZ5
         0DE5pO41BGoH2DdegQTEYRb3+QjXNjojkS+0CaP49wEsbNcS/6FJ95ZWWdpymzh8G+3E
         RuIZagaTy7SVuvjp1wmcCBF/OuhAhLe8I5aUZYxBcMDBzAgAHxBZ9W+BDpNhIQh6xFAB
         xqrdI8sZx05E9/MhcYjPMoW3NHYXsoUST/0M5icLBXPeFtUBAPzCUIxp9XkfyOk8qAvu
         MmSw==
X-Forwarded-Encrypted: i=1; AHgh+Rq2ZyJXyFBTo+xruGojIcfipaqDFYlDqB/40zjoidkxchMydVkQnNxzdLdSOwTmFDv2BqFYGcg8MA==@kvack.org
X-Gm-Message-State: AOJu0Yyv1tkJY9FxYn9oRpB9UGdRhTV9/KGQBPBICK+Yb1ewfKOBIwvT
	q1KaN4xPxnr9bPiFlAhmDRV7Z6F6jull/8E0hB6bzz9zZDvyFLRkNXvgcu5ERE8MMCoqlSywY7M
	AyQI/cVvXilb8U35WsOlO+pD8R3ONHP1Gi4h9tYIm
X-Gm-Gg: AfdE7ck5WbCiLpK71PSoiZSOFL+7xJLABvp1xIaQmhGYeP5td4tGbRR3cXDRolMLXg0
	rYPKsGUJapMWJKPe/eRhDJKU7Yig7mohxYICId+REqLId/NwkPTgK6UW1iLc88+LyBbE3kMIzyU
	DKow1tA1GbRWbRve0Dxm2hL+vvjbiXqJxtt0/7EoB19PWo44XGZjX5BKKm3oM/686ZVAKieePig
	klXXGBizc6Kjpp9Gugy7Myl4b8hjNogQ2E9NO+0O10qq70XKfv3SoufJKXxTHfR0Daru7/1ViET
	gA0tYpJrUH/ZPv2oFLkMAxI5HZE=
X-Received: by 2002:a05:600d:8443:10b0:495:404b:85eb with SMTP id
 5b1f17b1804b1-495404b8636mr4530305e9.26.1784124560869; Wed, 15 Jul 2026
 07:09:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260605133541.22569-1-boqun@kernel.org> <20260605133541.22569-5-boqun@kernel.org>
In-Reply-To: <20260605133541.22569-5-boqun@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Wed, 15 Jul 2026 16:09:08 +0200
X-Gm-Features: AUfX_myXsOMxqzySIL_c6wjy_KTMgParE-LvwcdXFSkdOBkOsDSHqrVd6QhTOvc
Message-ID: <CAH5fLggHxeDMm1ygYEGPpjCdfRD8nEsgN31WMvjX3mMPs5p5yg@mail.gmail.com>
Subject: Re: [PATCH 2/3] rust: maple_tree: Add load_rcu()
To: Boqun Feng <boqun@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	rcu@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Andrew Ballance <andrewjballance@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Frederic Weisbecker <frederic@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
	Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	Philipp Stanner <phasta@kernel.org>, Lyude Paul <lyude@redhat.com>, 
	Daniel Almeida <daniel.almeida@collabora.com>, =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C20934000A
X-Stat-Signature: tfbt46n9kkiu5yxi3ajnhx5hg3i9sycw
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784124562-961857
X-HE-Meta: U2FsdGVkX19SYS1KUPY6AdM+4QS4gdP54dwXADl2UjCUg9rHrez4wYyFH6mSMLQl036i9YyET85fnE6jp6IKo1ByDfXo5JgWW09gM/9+ij0b/wzRAcDwjVs0mLj/c6fjNQlj6UtODo8AY/iQ7kc5kmRBbimqRmEJRqXQhbI5cUM2XazvgWER5bhKsYFK13OWiPUrt8htHVQj+xjRsWBjR/8D5uG65l1c+3xZUYGanFBqx5UNES1GYw1F7C7pFtxdUiGOr2WoOoPpMO3+TZaBEVPvXj0YEdjiI0GPUiImHHvAMQT3zqkenlkuHH+cqE/Ia9pmXJV0ld3FROLKe1Vp+LXFdDTOe/k+UenjCUiBMVMP9bbi72mhznpdR8g2yVIp6iAklb4U9ZkX53+c8xxJrin/3tWFoAQH5elIQetW4ZeTDpTk687FhhNUSa+3x6uPN/ieoIwr/dfMeEnKuyPG8EJ2EUyyFCo766INx6n8Gdv+jqEPCpLh24SiY3PbVO28Wjxy30FlUBsumni8R+UnzHmqluH62iDlMWe55nsemSrjZrnVvrlLSUsRp0oDfJ8dEGV2IRPaufCcP2jd2lHEg7fcTtdW/cgwpFhPECGPQP8EkH1ZR+HK0A+z7WHZ2Q4WgHQuuoilbZo09O0npcJqsSlBUJO1+7yIHfTyxrjmVLxnZCPqVKE3P6h1GF302LmNkZDKNsxb8TQ/imbIpP6kDwlg++XPLbLzvZ7MkxZpy99ZRexZiYC8TiHAfhCRJ8XvCQkU57xhoVw5dl3q044THUewDhWV7saSP+gStslCkbOWAJr+p4M36f6NNa1IFqEiyJeuBVDcMyVGiLcaioOd/gXg2QvsCVEqFYOXCSek3GAY8vFW8MSzlR3wA/7OZVZ7NYX6prqBVDXrySZ/bwzzaMVEUtSFu26d6k3krQML5YaghMiIdNyWERsgWcik28V5WcTC1nUxv8dh0sGLGP0
 UIpCnXEk
 pZ8YWqmK+IZfDT6v1Sv4F6iV0Tw6QgozRzYdYYYqAbYsDCCNsdn1fB0aYQh6vEPUTYf9NNydAkE98uOSTTcJFhA4cbVs0uDbPfTboeUkdbuDwihDgBo4y+WNr9ERKpVrpT2wL4NK3afZQLm3WXrNg/vTIaCKU6KleSOxz0Z1hH3e9Kx3EcUY0YtJ28vud1NMfXcYDaZNE4W1uUUYbpra3DoImcCnI376oQNcq01qv8LrxqEDblGBDlMZBhVhu+R+JdfHaeRaNXbyDHF5giziKX7xp/ebb+Y8DpH1P9I9M1V8e1BShxrqQJwCpkZ60V60FE6Ho9bRaGbKG3xY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 5, 2026 at 3:35=E2=80=AFPM Boqun Feng <boqun@kernel.org> wrote:
>
> From: Alice Ryhl <aliceryhl@google.com>
>
> Now that we have a concept of rcu-safe containers, we may add a
> load_rcu() method to MapleTree that does not take the spinlock.
>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
>  rust/kernel/maple_tree.rs | 52 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
>
> diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
> index 265d6396a78a..1499191b8935 100644
> --- a/rust/kernel/maple_tree.rs
> +++ b/rust/kernel/maple_tree.rs
> @@ -16,6 +16,10 @@
>      alloc::Flags,
>      error::to_result,
>      prelude::*,
> +    sync::rcu::{
> +        self,
> +        ForeignOwnableRcu, //
> +    },
>      types::{ForeignOwnable, Opaque},
>  };
>
> @@ -233,6 +237,54 @@ pub fn erase(&self, index: usize) -> Option<T> {
>          unsafe { T::try_from_foreign(ret) }
>      }
>
> +    /// Load the value at the given index with rcu.
> +    ///
> +    /// # Examples
> +    ///
> +    /// Read the value under an rcu read lock. Even if the value is remo=
ved, it remains accessible
> +    /// for one rcu grace period.
> +    ///
> +    /// ```ignore
> +    /// use kernel::{
> +    ///     maple_tree::MapleTree,
> +    ///     sync::rcu::{self, RcuBox},
> +    /// };
> +    ///
> +    /// let tree =3D KBox::pin_init(MapleTree::<RcuBox<i32>>::new(), GFP=
_KERNEL)?;
> +    ///
> +    /// let ten =3D RcuBox::new(10, GFP_KERNEL)?;
> +    /// tree.insert(100, ten, GFP_KERNEL)?;
> +    ///
> +    /// let rcu_read_lock =3D rcu::Guard::new();
> +    /// let ten =3D tree.load_rcu(100, &rcu_read_lock);
> +    /// assert_eq!(ten, Some(&10));
> +    ///
> +    /// // Even if the value gets removed, we may continue to access it =
for one rcu grace period.
> +    /// tree.erase(100);
> +    /// assert_eq!(ten, Some(&10));
> +    /// # Ok::<_, Error>(())
> +    /// ```
> +    #[inline]
> +    pub fn load_rcu<'rcu>(
> +        &self,
> +        index: usize,
> +        _rcu: &'rcu rcu::Guard,
> +    ) -> Option<T::RcuBorrowed<'rcu>>
> +    where
> +        T: ForeignOwnableRcu,
> +    {
> +        // SAFETY: `self.tree` contains a valid maple tree.
> +        let ret =3D unsafe { bindings::mtree_load(self.tree.get(), index=
) };

I think this is only legal if MT_FLAGS_USE_RCU is set on the tree. :(

Alice

