Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75E5EC87FC9
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 11:11:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 065916B0089; Mon, 28 Jul 2025 07:11:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 016496B008A; Mon, 28 Jul 2025 07:11:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E471B6B008C; Mon, 28 Jul 2025 07:11:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D56A96B0089
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 07:11:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 679651118F2
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 11:11:09 +0000 (UTC)
X-FDA: 83713406658.21.A532151
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	by imf13.hostedemail.com (Postfix) with ESMTP id 47D2C20006
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 11:11:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ak0t4WTl;
	spf=pass (imf13.hostedemail.com: domain of andrewjballance@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=andrewjballance@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753701067; a=rsa-sha256;
	cv=none;
	b=sdQHsLE84y7YNh7j0Hp9gGH1aHSMYB5O0mIc1c53shv9QPcXxY3m5Y0aQ2/FEUD727ryAH
	KRll1yFrEnB91dJClIyx4FuoDE9Daa/1Ey2//7ntyB3+UDwnBchYq7F4juH5nW4vM6b7ZV
	Blj6i9n63JDdcM7ZYHoi4DhyCpYAXeY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ak0t4WTl;
	spf=pass (imf13.hostedemail.com: domain of andrewjballance@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=andrewjballance@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753701067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YelJq5+KqwjZ5s+zSqyZgpj7s0sgr+POM2J5j33U9x0=;
	b=I/p/BsZeKBYjQlfWDNOEMszLV6cRUy4Yjrf5PwyDMkldMyNYHPTFYkCwAhokF0VGXKlPMP
	sPOxZWYFNEwLOEMMasOjsXyJg8QatlwGw+WF0A8TR6q82rgmPsX0yC6R81TWzXFXfS+kPs
	JjWtZjrwwFpbGx78CWyY3ntc+Onsuk8=
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-72c47631b4cso2892367a34.1
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 04:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753701066; x=1754305866; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YelJq5+KqwjZ5s+zSqyZgpj7s0sgr+POM2J5j33U9x0=;
        b=ak0t4WTluGK8VRFbCas3G0qr2nKQXQ2iM8yaVsV1yh6EeConv7ovzqGbv3uqLMj8OV
         x5qg/pSe7ahuK1fQ/8d1fG7Y4q/ubIe5li2g/JfesHEaSScgAo4s8+6wcP+QGabq9Zac
         RqyxWPC1EKzB9Vh6z7sKYWD5FXG2guew4EVdURnpSI0g6VE5uheNf2Y7BmXOzIBifsZW
         uPe9QgyHxbYl8QJMzcEq6Q2nnVak4C7h7gY67oyug9qEAa+87KBsVNXiUKQwJZWckE1P
         EgJy9hpO7XzziqkGu/Atns5b1MQVc2Q7gEo7fgG828l9tRAdRzWvvwwjewQHcSSIbkmd
         EPhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753701066; x=1754305866;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YelJq5+KqwjZ5s+zSqyZgpj7s0sgr+POM2J5j33U9x0=;
        b=afvC/Uc4Dm9jJ5GgSfhz9FE5RnIgc6iJYjNrAZdT0GHXAwTVNQgA7YA9/QLJYMLQqw
         5hATAh1lJjwldPnoN0PuyZGSvQ25eWc5eecTyyc6tkFGlgrFdS0/jhHQOH4qLqRB5SGQ
         y8gFtTZSIPpLDKaFALkw4pqeMwhm7nmCN5h6b90RXobVHD/chbl+beM1J5tMsiPmItzq
         zN49RyI5EXFsqDXg3NCNfJM2kbpIEo2ElaXPPzb4VgTKx5dVqAbA2s8soYpWFZvkGZ4w
         VdELpDGXeLuKNPq6bG8eQRg9iinsb0JbHLs0/iPNMxF0db4pZFZ6G5ri8Zh1+0BG+R6k
         Bo3g==
X-Forwarded-Encrypted: i=1; AJvYcCWYHKuFn/XcGEwLULQzePJwGnlWQM5RLePbM6Bg0Hob/a4HCksbKYsm+n0LRoB/DZAszglbtbYwVg==@kvack.org
X-Gm-Message-State: AOJu0YwpWrejGVoYEPYlpF+nzNRttUoHzz4sYB+Eju0UFBBKfNQQO8so
	QJzs0w9fCoVA0cwexEG1tIp7UNMmnFzYeO6tKN7BPvMTT82bheRKY//4
X-Gm-Gg: ASbGncs4gBDeJhFBVtcxGlY/uH0c56Ptu/eqnxXcvMVT9UKo5ktjGEh4bxCVgn1xpOR
	kjeFKhOiWwSMSo/rlrR/HVZz6vyoa3AdgUVDPErUFoF7oq3+Y3GXhnVfogcTNA0UmbigUpAYsUw
	TlNLxyG0UOVRYYw3CAHRq63N+THVN6CgVR5ENv+pCm4AfUT0Gm2HX/tCz/tlN8NdIDI5qD2PLw4
	xxUHgXtzdSRldDRpUUMjDjA4FI5GVK5Ab8z8S/Jc/KdCYA7zOm8ARo1pI+re53J87oAtqv2jbxj
	hEAhQoGVdQgQSlCs+PzcuFYASa8v+eIag+4XUWL5HBZFhmf2BUJsKMbcUU3CWY4opngAHIEqJWY
	6TbfmEIMMOxyWl4mfh6KMPAyhKgSLF88Fwb9pr7L7ooLou0xNI9yponmfs7ZNzCoIudwLaBiNDb
	xiNld0
X-Google-Smtp-Source: AGHT+IE0MGdMlJEMmoauyyGL5IGwz1RfJolQSIkKm13B128tgDOr9GHPwxPr5ZGTrFtGLyQRiODJSw==
X-Received: by 2002:a05:6830:4d92:20b0:72b:8fd3:e2dc with SMTP id 46e09a7af769-7413dcd7b58mr5857781a34.21.1753701065943;
        Mon, 28 Jul 2025 04:11:05 -0700 (PDT)
Received: from [192.168.86.39] (c-73-76-29-249.hsd1.tx.comcast.net. [73.76.29.249])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-741481c5c92sm1027355a34.30.2025.07.28.04.11.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jul 2025 04:11:05 -0700 (PDT)
Message-ID: <a4b93eb0-9742-4f24-86d9-486ce87fbed8@gmail.com>
Date: Mon, 28 Jul 2025 06:11:00 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] rust: maple_tree: add MapleTree::lock() and load()
To: Alice Ryhl <aliceryhl@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Miguel Ojeda <ojeda@kernel.org>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-kernel@vger.kernel.org,
 maple-tree@lists.infradead.org, rust-for-linux@vger.kernel.org,
 linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>
References: <20250726-maple-tree-v1-0-27a3da7cb8e5@google.com>
 <20250726-maple-tree-v1-2-27a3da7cb8e5@google.com>
Content-Language: en-US
From: Andrew Ballance <andrewjballance@gmail.com>
In-Reply-To: <20250726-maple-tree-v1-2-27a3da7cb8e5@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 47D2C20006
X-Stat-Signature: haaqhmwtidc3qwhopy7w9sracu7rm118
X-HE-Tag: 1753701067-557303
X-HE-Meta: U2FsdGVkX19DnlPrY1oNzX/EtTqws/By5DOeqIFIsseMCKgzHHhFxzrlq1Uz4ubQ+/ZG1b9xCbl4UbCOgqFQ0H8aq6zg+zVrWMBnBDfI8y6oy0yAnA4NFMCktwguoU2e1tBOJ+qEmCJxAbpKlNJQq5vTPwEeQHtBpsVJJwweq5ie56PbVP2T5lJhocubJmLhtXzXI2uhb1Lsh9PyEFrtyviF+9dpKgEpsh/5Osmw2hziWhm8v8lA3pMP9j/cWuNZuQfGNJeEm36+D11uDmqGQRtbwQrzyCDtwVnOwTiapvwLI/y686lGv//f5579TmFZrU9uaHuh8Mz6DPpQK+aIaw0jo7TSh19FOuaYMSnSog3Y8T1oGXh7ooSRwmT9Qudu0pnnNMnsk6EK/BZRnzGE18HZe7mS8aFgabNTAffFavz/TXxKYnz2YjmJYoyCb4Wn8i8t9dk59LT8bR8kuRmRsiwozVB7Rd0BWtQF/r3+IZXWIRJEWuvx1wOCw3Xpa0ueDFM+IOrkFfUIu/h44QEOQXPs+603VmKVHlvJbTScFnAqcdqdpeQrKHP5but0sLJfThXocd9+7GULi+6NQU1dCyfkrks5cI2KHvedviZqE62MNaUHOdc/eUXcJfb7j+C75wau/OrKdHVygfPfUAi/pHCgLPbL3IhoJAz1YMU+leQIxwwO5zmo18yVKBWT8UPaMMpQIj5B4Y0ol40O6NrbbIPsagoz0Ur8bgwkU9I6BuxgnY0jAL2YFwHvvTc1EKOQTziZPr1+c+n5kiMjG88royFiQgyna3REb7psFe8TFWEYrsP/Qnvj1PWdDz+oZnMh91M/7L4P86JzJ0nxNz14JzNjc1XI2LHWcZzwmV14DWMcPuoRdWMEgW/mdPjgcJdW1ZYE7fIj9IEPsFY5l5ekvl7CZtD9cGnSKZreLz3y8DO9WxESheeIZ38rG83RGNgv7mWShT8mVD0Y5RAPtWe
 hEabOt03
 6JG0xnH2xUnDRI0cRRwTY2IyC12uPVYJ0BCC6TMFZON6p9q5yQjgZk7BpjOfRkJUOHYyJ/7liPkfVff8inlQUVCNd0MhLSvcvBrJ0Nc0TTlJ9PXCfmcLfGV4Cs8wxkTg1oiwGXPVM2PH49lNfWfI164HP13JGPqz4GlGtYOEpXT6WWEIxtOYIYERa3MjNndxnflEVW6kjYvnEQ3DFgQG7koMLh9g7mXxDFjnsCdQsbXc0IxecP6r8O3n7b279XXg/bYTWHN5MJ4FhUHLtE/gjkg3rQWAfmMpnxnDPd1fKvonyS5AwgxCFFFQHwXQlnhoeMQMUD5+SarfbeGu3MDusSy/QdYvjRGYFOBOLnzVyhnBOTirzRwn1FpMz3mMa19jJvc9ePRCsYg0ZPNoBfXi8LT324qdyhnfoEHv7S6jSaiwx9YzZ7MMEJvWvsTsCD0vX/Is4oSZemoTMcf1divvIPN/i3kmAD7MJz7CYu4eNOovRW2wMD/8znxgoDDlgfEo+suyrgIbaVkkRP+7CIW5z6jPIQr6buzBs+jzg7gLn6vCDMlL0aC0M5ITuQhCbJf2QnKkMIPwHsQaD6sCvmd+98qnwR4GUegK1qTMf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/26/25 8:23 AM, Alice Ryhl wrote:
> To load a value, one must be careful to hold the lock while accessing
> it. To enable this, we add a lock() method so that you can perform
> operations on the value before the spinlock is released.
> 
> Co-developed-by: Andrew Ballance <andrewjballance@gmail.com>
> Signed-off-by: Andrew Ballance <andrewjballance@gmail.com>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

I have a couple of nits, but overall looks good to me.

> ---
>   rust/kernel/maple_tree.rs | 94 +++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 94 insertions(+)
> 
> diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
> index 0f26c173eedc7c79bb8e2b56fe85e8a266b3ae0c..c7ef504a9c78065b3d5752b4f5337fb6277182d1 100644
> --- a/rust/kernel/maple_tree.rs
> +++ b/rust/kernel/maple_tree.rs
> @@ -206,6 +206,23 @@ pub fn erase(&self, index: usize) -> Option<T> {
>           unsafe { T::try_from_foreign(ret) }
>       }
>   
> +    /// Lock the internal spinlock.

probably should add #[must_use] here.

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
> +        let lock = unsafe { &raw mut (*self.tree.get()).__bindgen_anon_1.ma_lock };
> +        lock.cast()

This cast seems unneeded. lock should already be a *mut spinlock_t.

> +    }
> +
>       /// Free all `T` instances in this tree.
>       ///
>       /// # Safety
> @@ -248,6 +265,83 @@ fn drop(mut self: Pin<&mut Self>) {
>       }
>   }
>   
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
> +
> +impl<'tree, T: ForeignOwnable> MapleLock<'tree, T> {
> +    /// Load the value at the given index.
> +    ///
> +    /// # Examples
> +    ///
> +    /// Read the value while holding the spinlock.
> +    ///
> +    /// ```
> +    /// use kernel::maple_tree::{MapleTree, InsertErrorKind};
> +    ///
> +    /// let tree = KBox::pin_init(MapleTree::<KBox<i32>>::new(), GFP_KERNEL)?;
> +    ///
> +    /// let ten = KBox::new(10, GFP_KERNEL)?;
> +    /// let twenty = KBox::new(20, GFP_KERNEL)?;
> +    /// tree.insert(100, ten, GFP_KERNEL)?;
> +    /// tree.insert(200, twenty, GFP_KERNEL)?;
> +    ///
> +    /// let mut lock = tree.lock();
> +    /// assert_eq!(lock.load(100), Some(&mut 10));
> +    /// assert_eq!(lock.load(200), Some(&mut 20));
> +    /// assert_eq!(lock.load(300), None);
> +    /// # Ok::<_, Error>(())
> +    /// ```
> +    ///
> +    /// Increment refcount while holding spinlock and read afterwards.
> +    ///
> +    /// ```
> +    /// use kernel::maple_tree::{MapleTree, InsertErrorKind};
> +    /// use kernel::sync::Arc;
> +    ///
> +    /// let tree = KBox::pin_init(MapleTree::<Arc<i32>>::new(), GFP_KERNEL)?;
> +    ///
> +    /// let ten = Arc::new(10, GFP_KERNEL)?;
> +    /// let twenty = Arc::new(20, GFP_KERNEL)?;
> +    /// tree.insert(100, ten, GFP_KERNEL)?;
> +    /// tree.insert(200, twenty, GFP_KERNEL)?;
> +    ///
> +    /// // Briefly take the lock to increment the refcount.
> +    /// let value = Arc::from(tree.lock().load(100).unwrap());
> +    ///
> +    /// // At this point, another thread might remove the value.
> +    /// tree.erase(100);
> +    ///
> +    /// // But we can still access it because we took a refcount.
> +    /// assert_eq!(*value, 10);
> +    /// # Ok::<_, Error>(())
> +    /// ```
> +    #[inline]
> +    pub fn load(&mut self, index: usize) -> Option<T::BorrowedMut<'_>> {
> +        // SAFETY: `self.tree` contains a valid maple tree.
> +        let ret = unsafe { bindings::mtree_load(self.0.tree.get(), index) };
> +        if ret.is_null() {
> +            return None;
> +        }
> +
> +        // SAFETY: If the pointer is not null, then it references a valid instance of `T`. It is
> +        // safe to borrow the instance mutably because the signature of this function enforces that
> +        // the mutable borrow is not used after the spinlock is dropped.
> +        Some(unsafe { T::borrow_mut(ret) })
> +    }
> +}
> +
>   /// Error type for failure to insert a new value.
>   pub struct InsertError<T> {
>       /// The value that could not be inserted.
> 

with or without those fixes, for the entire series,
Reviewed-by: Andrew Ballance <andrewjballance@gmail.com>

Also, if you need one, I would be happy to be a co-maintainer of the
rust maple tree bindings.

Best Regards,
Andrew Ballance




