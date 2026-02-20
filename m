Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6CA5C531FF
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 10:35:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F7916B0088; Fri, 20 Feb 2026 05:35:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07A386B0089; Fri, 20 Feb 2026 05:35:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E94306B008A; Fri, 20 Feb 2026 05:35:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D428C6B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 05:35:17 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 857B91B622C
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 10:35:17 +0000 (UTC)
X-FDA: 84464477874.11.E803D7F
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf13.hostedemail.com (Postfix) with ESMTP id B69F820005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 10:35:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PlBxqdGp;
	spf=pass (imf13.hostedemail.com: domain of 34TiYaQkKCAgitqkmz6ptowwotm.kwutqv25-uus3iks.wzo@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=34TiYaQkKCAgitqkmz6ptowwotm.kwutqv25-uus3iks.wzo@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771583715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SuBBZbTgNeFNGP2KTDBOL9VXYwpq19RWtpTtqUl4jLA=;
	b=stn3ti0CFUZ0sA/A0rhM9HWEbae5wK2ntzq+zksohDS9wRJpXX0n1+NNC2ZXfo51jxs9hk
	vsyCecHzRWXm2PJRX9pN5zpQurUf9bbfuaPNMgFLNxZhJiJa5Q8MW+vmN/t8nYuOoItCsL
	++O2zlZr+os5iiGkDW3QqCs0BKSuDIQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PlBxqdGp;
	spf=pass (imf13.hostedemail.com: domain of 34TiYaQkKCAgitqkmz6ptowwotm.kwutqv25-uus3iks.wzo@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=34TiYaQkKCAgitqkmz6ptowwotm.kwutqv25-uus3iks.wzo@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771583715; a=rsa-sha256;
	cv=none;
	b=HmBpSv7izhEbO5AWRbeVphEMN1vpbwHsxhcvaBPL8RM5Vo89q03IlFnpkXlaQViDOJTMaw
	IKA2U1ZP5MqFNdZ0nSK6gCkyTeGJvsTlrIgHV4LYHQZbBSQlQG8NsOLtM3Asjae+tVupEq
	E5Ju23Siz13j3wUZ6qOeRc4HLeXhdEs=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4836ff58111so21044705e9.1
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 02:35:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771583714; x=1772188514; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SuBBZbTgNeFNGP2KTDBOL9VXYwpq19RWtpTtqUl4jLA=;
        b=PlBxqdGpa5GiV4VFRqJlhknjIt5RuJpa4pDp9IHgI2Vi22c82H80xDES77JdxtEfWk
         Xl8V5on2HE1XwJQmja5FsEVnrCzB12TnOjy3ZdPCtQrGCBOEoqV6V6q81xpDTNgZzJXT
         Exmza06TSwXIrXZDBsQQtPWvgesudBXb9Hb9ULDecdApaeQmJCWxhPnqqq20i3WB3vkP
         moXDENx+IRUORQQuahWBDTKQ1Rrmg+qtgmKlmNQ62yULyOnnRf+npL4qAchbiGUCsjH7
         vyoql4lLVWcV3TtLdYisxbIoahl7qyub+aTKErjFrc0Hw5lRLRuHQntRVZWr3iCSxfmk
         Z/XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771583714; x=1772188514;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SuBBZbTgNeFNGP2KTDBOL9VXYwpq19RWtpTtqUl4jLA=;
        b=bPzzTyKE56ZCyh2RmFncs3QNkHxO6992iBf+sHUCyFLrivTv+i7Uw8N7CO7Fax5tBU
         KBCUsBCsBBDL3xQXZzM+sQyWRBnv+aG5ZMLmxu7oc74ftxpvyy0SZjOYF7esBxOPTcpI
         b3aG+P69OSOnnJ6Wcp5b93M0CJIFej/0ofDKyQgw5V0NobsNca7CTZyRUSkAbBxe1rg8
         GFSOqMHNIBe/HJ0YDUkbuyPfhT4uC+EG1MJSCfgwL3N8X2F+IjKa1kK+nkRGhCoZfIh8
         hdnC7zke/gfPTDgvL/0Jt0xQMZrHdgf2aSi/peNEGnfMr3W21FlvqzUl1PCZRJTFPEfO
         C5wQ==
X-Forwarded-Encrypted: i=1; AJvYcCWskenp97Gf0YZnNMtTm2F5mN89UpWi850xdP+p2dAcHfZKQOTKvxh+viyq1gjqNLWYJGMY8S3iuA==@kvack.org
X-Gm-Message-State: AOJu0Yw/ZJr1n53N7tJWs4+YcE45BDGJBG0AZFUAS9CjMPThTzhy/WkF
	q34EVycGztMTJsiZNc99/r8VYnkxEtUr+BZP7kpgOtTdtBXEByj3Xaks83GlLOi7V9XZOH18HOl
	eumHuVBuWaUPjFHSr8w==
X-Received: from wmbdr17.prod.google.com ([2002:a05:600c:6091:b0:480:4a03:7b73])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b26:b0:465:a51d:d4 with SMTP id 5b1f17b1804b1-48398a47222mr123364405e9.6.1771583713704;
 Fri, 20 Feb 2026 02:35:13 -0800 (PST)
Date: Fri, 20 Feb 2026 10:35:12 +0000
In-Reply-To: <20260220-unique-ref-v15-1-893ed86b06cc@kernel.org>
Mime-Version: 1.0
References: <20260220-unique-ref-v15-0-893ed86b06cc@kernel.org> <20260220-unique-ref-v15-1-893ed86b06cc@kernel.org>
Message-ID: <aZg44EmMWKK-z5KP@google.com>
Subject: Re: [PATCH v15 1/9] rust: types: Add Ownable/Owned types
From: Alice Ryhl <aliceryhl@google.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman <david.m.ertman@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	Serge Hallyn <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Igor Korotin <igor.korotin.linux@gmail.com>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
	Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	"Krzysztof =?utf-8?Q?Wilczy=C5=84ski?=" <kwilczynski@kernel.org>, Boqun Feng <boqun@kernel.org>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org, 
	linux-pci@vger.kernel.org, Asahi Lina <lina+kernel@asahilina.net>, 
	Oliver Mangold <oliver.mangold@pm.me>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B69F820005
X-Stat-Signature: dmrybiog6ixg9jbmsmtjc35j7wec9km6
X-Rspam-User: 
X-HE-Tag: 1771583715-49240
X-HE-Meta: U2FsdGVkX19eaLjyavnWo3gcgZwmZdfxH/SCUJ/X+hnCr4I6nMJuYlnMshXYEK0cOuXLP2FD+DVSyBSabYVUiWKnuk9ARJQf9jaLcxXl+vUb34Lj5BBZJW2lBCUkfUejm34MZd64X30g1RrK57kkv+PYY9bElVtatOOtu6QD06gUBBVsecwKNMf/tPChM4wCbuS9bgFCQ9Gp2fbLaGdRp01KgfP69zNvSlk97KyQB7RLg4asFI0+lL7Z/ppU5fpv82LlUK1PuuwW1TxLXeoTFWzfsHfKLh6urCTRWhGl1g79rNoJPMyAEg6198pYA9WnQbzQZrbVN9tgQM3X38E0tKEx5emIIVLrJvk4Tz6ofF/LUBlIplf7zOJG7kfss1IFrmKcVedhL4vlopY+SVGSlOFDj51yJHHGZ/OILToN8hwXdcZfB4+7uoZ/8U4obgG/sWx6eoZ2zxIS/7T4JmT+A5bPOJr4bywt2OWAAxySdxVydw03/dDArOGrCELc+kVYuR/9xuecDif4blkET7he68lHrBbP+jZygAMaXu8Tt/6AwGDOmj9ogS61Gfv80TcPKOTwX+HWafUKnK9eYHF4eGJz37aV71kDU4p9M5Bqw8PjelEkY71PIpH6H6mxTnjq4WZKQ9Ji2lqYrhvDy0CpuCluhRORrPcS6qD4zj+ZwZjUfNsnA+Ce1dXzdKb3Cp6M4VPQXtwkwunFkmB+srx0L1AzmlNi+WpgaZyc41QnUuSGOxZGkoHaUDZSLrB00oeBn/tbpja/Mz8AqKHEDL8mxs6T2kSIk+oXXhEgsB3vQnUd6sMTiq5qGJi+qkMDftafecSQbtnlOW4so3xst0qUTs0RJJi7/zhMQS12wB0T3Yg3q8QJ3gUspnnKj5BRdO47Uq7GdroSAbEWeRWG67ANOLVWv2Upf1UsD+1s09/0d+ke90lrAS/oFvVTELFWf9hWttSJRG1YQPEmybIeHtt
 ckk+5Glu
 ycsd1aKimbXvtrHyuq/9fpG5a+gX752scyin1O4QqTJn/3C4C7k+M26ihoqTgCqW0Xa+g8LxGk7ERrHn7WNUArLbmwFPsioDnRepkbPDkQuHsGyOXftgttE0nfC4D22WsuGUpJSEwo/YPNgN9HcmMNDe+BBBFMd26y2z5F7HS4Svnawfhn0Dyfz0nvASNR8MuWucTrV/h3i26vizflATU6CJ81S1WMMwF67sxyzrjgN8pmmWYqvTFlG2ivJBLEGAeBms9Hh49DqiHR0LmRDpjSH+Vqus8AdJSzCQ4wiBsqu5dOzWq0BOwkZ5exMzfzAadGh2aniSmiFfrlyI0zK31KekB40Gpozh+8M0f0FsecMFWbTlRiYUjixLI+26JVC0ZUqiS51GPOkVVAKVEZZd2BvxeUR7sUNIW/T+krByGrolfyvr0d08KHhqH1vBSZiAAeT1M+VjTKa56dv5mZVCnbmahYq1Bffj4xDa8syz13zLuAtZWn3Z46RL2ceJOIwRhlfWbgFhjxRT++aMsnjlYGKvN9Pqg/VP1E1ts953vUkN4fjAQSYzeUkOjIbNMk8ixdzhtDOWos2dR2cDfdA5/KIZDrYUeTooMRL+KTYu/7UAMFSywccNtZggZMWOBFysHvBd27KF/kKU+1gYCEb5nEReJHb2MYN7mCTxJqjnFArGCTB1SgpkTdLslzf3UVH6iuT4IMr+pU5cZnALHhrbM+vv6WtmkQa8qb2Dd9vnFwLNQaCok4ENuG+PNz+G+88zOxcB59cPCYNVThrWcwigbZXcN30Q0UJHErCmYFuXfxLKNBuvujItKab1JGH2RugF1DuqBiOgVldDZmik+8zwKUHrwi6dTrKIn19Ik+Ypnf9rVxnjQFlAs8HVgXjQKogYrFMSt4WS57FaaYBDdA94tQZ/gNHLUyjUk/lxe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 10:51:10AM +0100, Andreas Hindborg wrote:
> From: Asahi Lina <lina+kernel@asahilina.net>
> 
> By analogy to `AlwaysRefCounted` and `ARef`, an `Ownable` type is a
> (typically C FFI) type that *may* be owned by Rust, but need not be. Unlike
> `AlwaysRefCounted`, this mechanism expects the reference to be unique
> within Rust, and does not allow cloning.
> 
> Conceptually, this is similar to a `KBox<T>`, except that it delegates
> resource management to the `T` instead of using a generic allocator.
> 
> [ om:
>   - Split code into separate file and `pub use` it from types.rs.
>   - Make from_raw() and into_raw() public.
>   - Remove OwnableMut, and make DerefMut dependent on Unpin instead.
>   - Usage example/doctest for Ownable/Owned.
>   - Fixes to documentation and commit message.
> ]
> 
> Link: https://lore.kernel.org/all/20250202-rust-page-v1-1-e3170d7fe55e@asahilina.net/
> Signed-off-by: Asahi Lina <lina+kernel@asahilina.net>
> Co-developed-by: Oliver Mangold <oliver.mangold@pm.me>
> Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
> Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
> Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
> [ Andreas: Updated documentation, examples, and formatting ]
> Reviewed-by: Gary Guo <gary@garyguo.net>
> Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

> +///         let result = NonNull::new(KBox::into_raw(result))
> +///             .expect("Raw pointer to newly allocation KBox is null, this should never happen.");

KBox should probably have an into_raw_nonnull().

> +///    let foo = Foo::new().expect("Failed to allocate a Foo. This shouldn't happen");
> +///    assert!(*FOO_ALLOC_COUNT.lock() == 1);

Use ? here.

> +/// }
> +/// // `foo` is out of scope now, so we expect no live allocations.
> +/// assert!(*FOO_ALLOC_COUNT.lock() == 0);
> +/// ```
> +pub unsafe trait Ownable {
> +    /// Releases the object.
> +    ///
> +    /// # Safety
> +    ///
> +    /// Callers must ensure that:
> +    /// - `this` points to a valid `Self`.
> +    /// - `*this` is no longer used after this call.
> +    unsafe fn release(this: NonNull<Self>);

Honestly, not using it after this call may be too strong. I can imagine
wanting a value where I have both an ARef<_> and Owned<_> reference to
something similar to the existing Arc<_>/ListArc<_> pattern, and in that
case the value may in fact be accessed after this call if you still have
an ARef<_>.

If you modify Owned<_> invariants and Owned::from_raw() safety
requirements along the lines of what I say below, then this could just
say that the caller must have permission to call this function. The
concrete implementer can specify what that means more directly, but here
all it means is that a prior call to Owned::from_raw() promised to give
you permission to call it.

> +/// A mutable reference to an owned `T`.
> +///
> +/// The [`Ownable`] is automatically freed or released when an instance of [`Owned`] is
> +/// dropped.
> +///
> +/// # Invariants
> +///
> +/// - The [`Owned<T>`] has exclusive access to the instance of `T`.
> +/// - The instance of `T` will stay alive at least as long as the [`Owned<T>`] is alive.
> +pub struct Owned<T: Ownable> {
> +    ptr: NonNull<T>,
> +}

I think some more direct and less fuzzy invariants would be:

- This `Owned<T>` holds permissions to call `T::release()` on the value once.
- Until `T::release()` is called, this `Owned<T>` may perform mutable access on the `T`.
- The `T` value is pinned.

> +    /// Get a pinned mutable reference to the data owned by this `Owned<T>`.
> +    pub fn as_pin_mut(&mut self) -> Pin<&mut T> {
> +        // SAFETY: The type invariants guarantee that the object is valid, and that we can safely
> +        // return a mutable reference to it.
> +        let unpinned = unsafe { self.ptr.as_mut() };
> +
> +        // SAFETY: We never hand out unpinned mutable references to the data in
> +        // `Self`, unless the contained type is `Unpin`.
> +        unsafe { Pin::new_unchecked(unpinned) }

I'd prefer if "pinned" was a type invariant, rather than make an
argument about what kind of APIs exist.

> +impl<T: Ownable + Unpin> DerefMut for Owned<T> {
> +    fn deref_mut(&mut self) -> &mut Self::Target {
> +        // SAFETY: The type invariants guarantee that the object is valid, and that we can safely
> +        // return a mutable reference to it.
> +        unsafe { self.ptr.as_mut() }

Surely this safety comment should say something about pinning.

Alice

