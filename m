Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57166F8DFDF
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 08:28:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82BDC6B00AC; Fri, 17 Apr 2026 04:28:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DC896B00AD; Fri, 17 Apr 2026 04:28:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F28B6B00AE; Fri, 17 Apr 2026 04:28:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C6836B00AC
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 04:28:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EC38C140A80
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 08:28:47 +0000 (UTC)
X-FDA: 84667371894.18.1239C98
Received: from mail-244106.protonmail.ch (mail-244106.protonmail.ch [109.224.244.106])
	by imf02.hostedemail.com (Postfix) with ESMTP id ABA6D80002
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 08:28:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=onurozkan.dev header.s=protonmail header.b="rhB/r6K5";
	spf=pass (imf02.hostedemail.com: domain of work@onurozkan.dev designates 109.224.244.106 as permitted sender) smtp.mailfrom=work@onurozkan.dev;
	dmarc=pass (policy=quarantine) header.from=onurozkan.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776414526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6U6RVFHLNaJmCg6toI8EFNRRK4p1gxZbu5ehs5QIA8s=;
	b=pgjl9WtjZ75PBrqElWEqRXbN6I4G3EY54Vm/p/ybOYyiXF4kD+6HDv/frKDTt1TorrOMcq
	imMu3/3s++4qU3WwlJY9F2b/Ved5Brm2mUCxa7EFP4VTG9oC1620k9ZyjEPuvsPWAyJ0Nq
	SLK6N5UuAEWm1HRKJTfH5S471G+EUaY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776414526; a=rsa-sha256;
	cv=none;
	b=YIooBNEThMSHMr0SPtaHUh5qs/sg4uegxl72sT9Ign8vdclrwEp3FPl10ZZhyVGR863DWZ
	KV93/zK9zPmqT0JH3KULRmp+oJV5NwEjD5f7YmWjT5Inmca4DfFd6kGkAQ35BGkN0wDBKn
	gizwr2nHHA3TxOvEFdT7B+FaeD8B1WQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=onurozkan.dev header.s=protonmail header.b="rhB/r6K5";
	spf=pass (imf02.hostedemail.com: domain of work@onurozkan.dev designates 109.224.244.106 as permitted sender) smtp.mailfrom=work@onurozkan.dev;
	dmarc=pass (policy=quarantine) header.from=onurozkan.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=onurozkan.dev;
	s=protonmail; t=1776414521; x=1776673721;
	bh=6U6RVFHLNaJmCg6toI8EFNRRK4p1gxZbu5ehs5QIA8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=rhB/r6K5iKRpCNj7AXXEfY30mmQhyHRRblD1m1+CiVL1V0VPbgfT/b/fv0vsoOHTt
	 FiwR/BP03vaThgocf1u9vUFChqK+0e01imRKqFmoRf0zbiNZbb4JNvRqpEGrBVBkd5
	 WGyjPiXPuO8e6AYFlaZudnwo7jLeTtrWYC4w0wywUI5stP6Eeac471JAhwyjcS2a1F
	 xMJQ6KKixOv/tU3JqvQXR6sqk+87+rwcFqx/w5PiN1Iq4vK7LIfapumMmRbDLK9elA
	 wT+8avt7+xfsHaBCh/ZwFeoRhCTCxHj7LLdgwv0mEcq2HqtV6WbpGrLG7+ZKARmg28
	 9JhKoewDEfqFQ==
X-Pm-Submission-Id: 4fxp1f0llnz2Sccq
From: =?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>
To: Alvin Sun <alvin.sun@linux.dev>
Cc: Miguel Ojeda <ojeda@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Tamir Duberstein <tamird@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 4/4] rust: xarray: Add Guard::find() helper
Date: Fri, 17 Apr 2026 11:28:35 +0300
Message-ID: <20260417082836.29530-1-work@onurozkan.dev>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260417-tyr-ioctls-deps-v1-4-41c6e9bb061c@linux.dev>
References: <20260417-tyr-ioctls-deps-v1-0-41c6e9bb061c@linux.dev> <20260417-tyr-ioctls-deps-v1-4-41c6e9bb061c@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: ABA6D80002
X-Rspamd-Server: rspam07
X-Stat-Signature: ue55btpkeqox1mbnz3wonwiioad53ibw
X-Rspam-User: 
X-HE-Tag: 1776414525-571446
X-HE-Meta: U2FsdGVkX1+Mq/W/gkHnwLD9T/NNmkVXHOI9BUgAOKGXidPo/nlcC4ivzePj8XzmGX1OJlBlT9PToflQACUxG1++pHKvOsDbpBLgKPRVeMujqMFhRb2BXTiWg7QWQ+XqoUWP4Cfb/Cw7J2u0JMhlLAsgIQul0wYYKXCV6rlWJObzJ4YWjzZy+VR3kUxck642Z7BM6XwLU3vZTkm7eoswu/3tMM31PVJ/H/Rhz8ESsFglSEjPfos3j3KxvBIWHMP84QWdhIh7Hqd5xQBpkpu3DGZncfFbAylPa2+Os4h7jt2eDEOwHu1nEq0h45Q3Pd7mGBSE2FCbcRcjcYsXd40DR6zsj+2VJyEaiJYJDDkUVI4XSh6/jBlXkACXBy13uwU0E+Cl58l9kKtHhRGyiPsKryhPZyPftA7lko1vSqFQJ0VIIoFHYpJoSe6GIJqMGONKbtYefIK3C0BTjCJIwKUsD5AnqCSx5mZtq7LolDN1d4IoSCJ2/J77x62bYGjl/8yzRqLS41T3PqpuelfiGN++ZSj0MrcaQoVSdYvTqAt3zr8DQKDvhim9KRt2IobrETADbNqS7KS3a5YP1U6c+jWYBIF7sjtnLV3Uc1CN8kmtjG9mrFvkuluemPOp78yjZvfLfAn4i5fLOIJ2c5xW1uaaxygJTqOOboDpr/mJEydiDLH1PG9y65y6kD+3N3wkoVCDZsGEzv8ATjAalQwym+9eTWnLRD62upNgZym0L7coDoLB+DkSsa+cunirBphSib8IKqfs0HYgs/OlIZWyoNkjuMRrVFuMj4vgGr3L6qvpB/HNtbZEeMNVGU+bBqo3P+Dtl+3Cdz2vyATfzOwT6PMmFtaY8xAsR6exDQtDEJGSjjCQin1uVGiBOY7I+XEtvBuTgBsX27mCkL/pyGPLvkuQwS66Ya9wBYhZV/irraGdhsRPLB8TJ+durE7JY30D6SEBIHRC2yoCV3mX9OUO81r
 KblMIub+
 +1yTvY7qizjlBDV/z2dJ9eZ4GwWN/17Q/p6oyAC2fugRXUVMKdHstRllKt/HTqG8uJUzGH3NqaF6zZ2JyMe/EGe8GH0BvzNJLK/x8DEBIJpWlr6H7T4ieyl3xULqxkzOFRE4r+irzJRIRE6IFuV0NLe0SjVt24qrBfp8+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Apr 2026 09:05:54 +0800=0D
Alvin Sun <alvin.sun@linux.dev> wrote:=0D
=0D
> Add a helper to find the first present entry in the XArray.=0D
> =0D
> Returns the index of the first present entry, or None if the array=0D
> is empty.=0D
> =0D
> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>=0D
> ---=0D
>  rust/kernel/xarray.rs | 22 ++++++++++++++++++++++=0D
>  1 file changed, 22 insertions(+)=0D
> =0D
> diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs=0D
> index 235fda0e394ba..e43129d032d9d 100644=0D
> --- a/rust/kernel/xarray.rs=0D
> +++ b/rust/kernel/xarray.rs=0D
> @@ -217,6 +217,28 @@ pub fn remove(&mut self, index: usize) -> Option<T> =
{=0D
>          unsafe { T::try_from_foreign(ptr) }=0D
>      }=0D
>  =0D
> +    /// Finds the first present entry.=0D
> +    ///=0D
> +    /// Returns the index of the first present entry, or `None` if the a=
rray is empty.=0D
> +    pub fn find(&mut self) -> Option<usize> {=0D
> +        let mut index =3D 0usize;=0D
=0D
Nit: I don't know if this verbosity can ever be useful, it can simply be `=
=3D 0`;=0D
=0D
> +        // SAFETY: `self.xa.xa` is always valid by the type invariant, a=
nd we hold the lock.=0D
> +        let ptr =3D unsafe {=0D
> +            bindings::xa_find(=0D
> +                self.xa.xa.get(),=0D
> +                &mut index,=0D
> +                usize::MAX,=0D
> +                bindings::XA_PRESENT,=0D
> +            )=0D
> +        };=0D
> +=0D
> +        if ptr.is_null() {=0D
> +            None=0D
> +        } else {=0D
> +            Some(index)=0D
> +        }=0D
=0D
This can be written with the `then_some` chain e.g., !ptr.is_null().then_so=
me(..=0D
.) but I don't know if it ever makes it more readable or simpler. I guess i=
t's=0D
up to preference.=0D
=0D
-Onur=0D
=0D
> +    }=0D
> +=0D
>      /// Stores an element at the given index.=0D
>      ///=0D
>      /// May drop the lock if needed to allocate memory, and then reacqui=
re it afterwards.=0D
> =0D
> -- =0D
> 2.43.0=0D
> =0D

