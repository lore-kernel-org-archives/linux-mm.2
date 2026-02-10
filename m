Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 527E9EB26EA
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 16:45:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9F5B6B008C; Tue, 10 Feb 2026 11:45:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7D816B0092; Tue, 10 Feb 2026 11:45:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC7C76B0093; Tue, 10 Feb 2026 11:45:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9C1276B008C
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 11:45:29 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4B8061B36DF
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:45:29 +0000 (UTC)
X-FDA: 84429122778.13.43F5FC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8547D4000F
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:45:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j90n3GiS;
	spf=pass (imf11.hostedemail.com: domain of da.gomez@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=da.gomez@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770741927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2areGx85V5cqOZaKUUpQq/ycvJ0CckIPn5Kh+tg57uw=;
	b=Ds7/YBYzKAWorUHFV1tXjruWNoFZuOD8Xz5exggGbY+NFEncXfRwxsD1/ckIMn9Z3wy5uQ
	2C99lXjvRhx2BtJr+PiMsq/8ZLXxoQjkk5t35U/vgHZ5MOTnmBDx8wledUDjvyG6PXbVxx
	FXESL2w7c8/2gu80AovpHfLcIFXxbaI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770741927; a=rsa-sha256;
	cv=none;
	b=Aix7rFqEMftP40hokCJy4kcgMB1dsi5csU0w7b34xgkvFndNrUHOTShZIJFI4luGMaBy3Y
	iWCxFNxNj9XFhYsoK7dfdiD6mtVWNd0cdNuAIJCOC3GL3r2D9HB7tpxwMwg50hn4KUxm5M
	BTiZRyj4LU3vUPlUUdOuSmhUerpnmk4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j90n3GiS;
	spf=pass (imf11.hostedemail.com: domain of da.gomez@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=da.gomez@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C2374062D;
	Tue, 10 Feb 2026 16:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B3EC2BCF4;
	Tue, 10 Feb 2026 16:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770741926;
	bh=z6X85SYM9Ks0D7DNZwibsEE5BEUD7xuH5Tdn2cTjgtk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j90n3GiSWKPdDxGXUVbFfKf9EITsQEjJCxQRSZiCqI00qhYrfpi4zqSfKh0ftNrOb
	 2nYUv8VuKTrCeP90jwgd+SXMrIHrI7JWD7eaDdmJ9TaPgVVW6/bPNLlVBU9tBoJ5KA
	 2A3eL2lC2dLQmT/XUJFQky+tWNE4irQTei+O6Or2mqpGBYuvBZBwatlPCQGEkSwRlP
	 lYCVqHWsf5e0lvgh4uEaZ5uXQfPF6Ka5u5xA+UybrqpQokKU0JPvOQxDgF15wtaWZY
	 gqx/d8FWvF16fc6FLVUVRW+LA68yGglb4ErwPCB8gMNgqF7dMbM6ULSX86WwhCTc4e
	 30yfgCpshWLWA==
Date: Tue, 10 Feb 2026 17:45:20 +0100
From: Daniel Gomez <da.gomez@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v3 02/12] rust: xarray: add debug format for `StoreError`
Message-ID: <aYr-gyQN_AaIJkSH@macos>
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-2-f777c65b8ae2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209-xarray-entry-send-v3-2-f777c65b8ae2@kernel.org>
X-Rspamd-Queue-Id: 8547D4000F
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ggi1waqms6ofyd5kng1ds1sz4dbodhtw
X-HE-Tag: 1770741927-877393
X-HE-Meta: U2FsdGVkX18obPkmwILciMuSWm+Q2yKFY7hyLQqY9o9ZzYoUh+NCE7e5a5db9+Mjc6X1n5C9x99WQHY0kSXTKy9bvtrLhsTeYZqImF12/IMt7pF2ovbKEzTQ8qF/a5Y7wIrMToB9r0pQIdQzcgubMyMLhCCbIeMZE98i85o8ES3RHnFsoJbxwdkMkC/pIs0GMxKHF3ZUelrEL/Mkg5xDEsHdCmSOQ5qt4NP3wq8OSzApVdrY0Gyo9FR+sHRj2pl2cLHjP6sX4GK0CFuMgWkWDPJTk8YJ43OuSzneyUWqWIxtasDa2/W7axDb4otolwgoc76l4PuNDYmJcyY0+tVriRLLvUiho/SyBYlEKaJRBzpmM0dliy9dmuYCPtFdq/rTmqMklOe5sHUHcWPPwuTn7W+STf5YDtVIrEF0FvB62AW6lVuzknxB3S2mJxorf3FX1/Ml5Tx4x+nuCZUEXZMHMa3boxksik950Se8Mf11x0WliET/owd7HzZd7zYDYsLpScnFFUWwv90VeORtvz4XR5Riy1CFgobjGtsBzR7/A5CTi3nQEOVPZtSkSfiiySwT8EkAD6i/bcqnoBS6B9XnusybKUdiJbAKIoUDhcQZodKj3AXXgTt8jlVWlmZ3RGizD1H5oY9IqAuh0EGZwTCysbL/Wi7SxWXVAgi2kRfEM8HoH+24sqJiKI7ILvcY1J6crHmqXd8Qwn8B6W00NwMLhpbU2VdiNLZGlu+dhT0dvzFTZGpOJ09glShsud06zSQwYX+C/ilyLx08fyWAftYbDnlJBc8Fha6QgsNn3jNhA6Au7n4fkTnJ4lW8KYVCLk8DwWl0KQm+U6XIgmgCu1jnzgiSN5+3QJZeIxoKONgjWuQVBBwsM/cBXJYId4hMgHNxbDNtIs2GkB5jdIGCH1emNRjy71bUGK3uGc0V/zvZ5EgDIorO+YdPCW/B+6O4uETnqw5bDXz1QekAM41nLsg
 ERWCPXtd
 qWH9BcrVEnRYQMvGUEWEP/NmfRa7wfr3b7FCSgGCEZEJ0JSf4voaxqL6XwBphNAmv7/J8OzByC9IHxI8PnDUsErviiDFyuhBzHFoUqwuTlJl8tAvcYpnIKaNzhNhuuxyGU7MIOdvqBe/2VoaOeBfDIgCM7Xol+I7n1syHspHzA8wXUKD1imNTNzW6ADMy5Lifl9KTeOYWMwu2MJnlB++dLec1wDKn0vE++wF+SDc1tx2JMdDkR97OOiSMTW2T0VrZKrPAQAMOMmYOTS3soNtquC3lhwRGtsVofqQgH41LudgqJN6LwJx5T+nlKW2zSjGMXVCJz3p37X+vPXJD++iMdU3skHjBnvN1Od9N5dSsg/v8Q4CB3+S6DUeKrglLNK4FUwKzMEDnFfqC4bVmp6MUIHUkoJUSSpTjg13vvbktYTRyIc46MP/pYUtNLVBO0F5iM5/MRaM9F3oukf0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-09 15:38, Andreas Hindborg wrote:
> Add a `Debug` implementation for `StoreError<T>` to enable better error
> reporting and debugging. The implementation only displays the `error`
> field and omits the `value` field, as `T` may not implement `Debug`.
> 
> Reviewed-by: Gary Guo <gary@garyguo.net>
> Acked-by: Tamir Duberstein <tamird@gmail.com>
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> ---
>  rust/kernel/xarray.rs | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
> index 88625c9abf4ef..d9762c6bef19c 100644
> --- a/rust/kernel/xarray.rs
> +++ b/rust/kernel/xarray.rs
> @@ -193,6 +193,14 @@ pub struct StoreError<T> {
>      pub value: T,
>  }
>  
> +impl<T> core::fmt::Debug for StoreError<T> {
> +    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
> +        f.debug_struct("StoreError")
> +            .field("error", &self.error)
> +            .finish()
> +    }
> +}
> +

Is there any best practice for when to include use core::fmt::*, so you can
avoid being verbose here?

I see other cases like this, but I couldn't find anything in the code
guidelines.

Reviewed-by: Daniel Gomez <da.gomez@samsung.com>

