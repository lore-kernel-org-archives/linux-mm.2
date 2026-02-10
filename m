Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7C71EB26E9
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 16:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 110DE6B0005; Tue, 10 Feb 2026 11:48:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DB666B0099; Tue, 10 Feb 2026 11:48:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 008546B009B; Tue, 10 Feb 2026 11:48:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E40326B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 11:48:25 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 96F7B56E72
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:48:25 +0000 (UTC)
X-FDA: 84429130170.21.23A2D40
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id DF99580005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:48:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=duEGMgzn;
	spf=pass (imf30.hostedemail.com: domain of da.gomez@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=da.gomez@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770742103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ua1UcmKFbhVp1CPFm5SMB9gDeU0/Sg4jgMpR45JaAjw=;
	b=Epa830tU7oaqxJTvChU1gdx3GWbR+WNlxafeO5EU0iJEdUViRCLKGQuyNuI1dEr1RkvX5Y
	VBTldsLa3zCjKlmTiIGrn4SbOm/zJ1N8d1TLZEFJ5TxB4EJjFF9VOqBeLtp6sJCcis+jh6
	nxZ4VdGfg7GI5rY9i0G5/HMNUGxfHjE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=duEGMgzn;
	spf=pass (imf30.hostedemail.com: domain of da.gomez@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=da.gomez@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770742103; a=rsa-sha256;
	cv=none;
	b=iAH37n9dfFs792Pkaq7+WTjvu5UsqAZ5rl+/fY1xdcmzqyHDRwcrVWm5fZCsyL0au2NzQF
	LUH9nJ5CYm9h06CsYxgHB0Uz+meLxfmChyh3ifNdLv3Wls0Tk46rvqRE+yT/0Uvos+U2KH
	fSIASUIFA6Jc04v3XDnNR4QKLRSfG8U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D00460130;
	Tue, 10 Feb 2026 16:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098CAC116C6;
	Tue, 10 Feb 2026 16:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770742103;
	bh=dbU65BlIpoty7iANfnMUj5LC3wQ9NypEMYFqKBMtFNM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=duEGMgznopIsNjn7WQGLrZdYtLHW88WzN9tTcIXtOsQON/YFK27PpTV4y/PMxcmPV
	 vyC0sd9d09b5lzjdooeuwg3IDXZxdOe70puulAmC9peMETXOLWlBOg8Vpzzzyg0HSo
	 WWaMMuhuJWnneGxOzGa5mcSKKzIW0/RZcepXWobvi4VVKKqMGiBPKoKYYiHeZseXIt
	 471PwB+TaYtKdfQgBYFsNYYfx1MLUEOUKfdbT0fmyspmoJcG/hmFbzZPqipuCfUzs0
	 a4cBvqzRQjEoAXUj4am/BRTzfrIqcQ/TGsoRbJef/jjauCcrpafiGesOelQIjlJSru
	 5VrvrVKJNpEpw==
Date: Tue, 10 Feb 2026 17:48:18 +0100
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
Subject: Re: [PATCH v3 04/12] rust: xarray: add `XArrayState`
Message-ID: <aYtcdGk8zcwaHfsd@macos>
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-4-f777c65b8ae2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209-xarray-entry-send-v3-4-f777c65b8ae2@kernel.org>
X-Stat-Signature: 1mywe9a6hwwrbpi7un71g7cmg9tjanpd
X-Rspamd-Queue-Id: DF99580005
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770742103-540935
X-HE-Meta: U2FsdGVkX1/w7DemXSSHhmTT47+5ExStTDDU4yb6k5XQFdLIuXajT6IGDITj/At1CiXuqHYIEQz9WsiejQTUGU6e8cwxn6E7m/L5GGY+UzXO6WB1mYt1Q8xTW/y4yChfP9UAUJmBRkqqYTCxzA2WHHxTWain0EN8yQjm2tRYAhRiMGcoMK1vBbKIi3OrwoPwqjCTqmlyrlBi/JsaCE8Em+HnPxdFReX5awpGdPcHjfZGucf9kC/re2Tk4dBzi5izPElXAZ9ytXuxp1Dh8WzgXy22j7a0Na/n5A76xPo56Q4e8XrGCNYaQibNcDW+kovz/Kb0mFdXxjaqjhNgEYaw+QrZHkEyMYBOT5h/XKDcIl6MflSznxynOUKgJHy2nft2SQ4HAHf7ojACqpJrkHu87A5bitWWHS0atK7U4G1881uQbVzJQLDxUzrj8qpj3yJDOmpP80n1+N3Sh+AdFdsdo/xgjhMfK8j8FlXAJZYCqo4+lDynGdN+JKSz6BCepzYwj35hDWc0VDDMbs8BULazsSysCRgWTQ5WqfUGBGnOYdcyjr45FnBwFioPBcbr3Us6joPddnc92Ag1H7evU4Gl0GEDqnNkGbr4iSDr3waLyVilKCsxPH+oRRkiu3WnNfF8/ijxr0Ej4Xn21ZRM5zDak1BJHPiwkM7O45hXnMSFlGGkNyOrXCam/zclx40ENlbk/axxfII0DnJtfhU+59lNSRBEs4miuWQb6OkQk3zdGK1knab08JmrEkWcHzv6ZZBVOhVu1Vt1mbk3N7mK7DBQwQUIIaj/S+KZi1+9mi/TvOhl/hl/ofeoyHVJme8w0ETTRGnIj+K094ejfpSXAVdaeZOVxIyUAc+kGO/LMI75F+XN1plhllV1L1egnBOCx0czx7sbzQZM7lnUNoE/MHptXjf/0dT8Ek1j4ai90npB6vDtrtmwyDL299dgeBFDiYJJV/nEpU4dzWcWwEjDBYY
 6Xd5M2vT
 6MlE6O9DBnjWqvrU7VdMfXje+tDltubAg29KwkCZVwFSfs8RgSOPvJvPf1bxSLjp5pQJn05Cjim2ZVaDpThdI+mHTUvlvW39VpYvPFItU0nK+aK+3J3AyjzxRHG/lvPnmwCrZ4TijgYnAVJzVcbHNeKhgRXCSKndZCTkCIyEklZLA41gOtYQJciRLFTAcxWbCGG5El3cd3RXYvl3LqXdDUbu33Zqo5rz/oOWlMp7XAR5M6PA7zc6kgHtcN6bolOIOxNnF8x3V7aNfFds9/DJd2tcBFHUa8LdAGHvgke2ygw6FuuCs41rU8mj4DeQsmlEoZkwMnPJHxoEoTW80JqZJP/O9ag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-09 15:38, Andreas Hindborg wrote:
> Add `XArrayState` as internal state for XArray iteration and entry
> operations. This struct wraps the C `xa_state` structure and holds a
> reference to a `Guard` to ensure exclusive access to the XArray for the
> lifetime of the state object.
> 
> The `XAS_RESTART` constant is also exposed through the bindings helper
> to properly initialize the `xa_node` field.
> 
> The struct and its constructor are marked with `#[expect(dead_code)]` as
> there are no users yet. We will remove this annotation in a later patch.

It makes sense to me to merge patch 4 and 5 to avoid this.

> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> ---
>  rust/bindings/bindings_helper.h |  1 +
>  rust/kernel/xarray.rs           | 41 ++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 41 insertions(+), 1 deletion(-)
> 
> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
> index a067038b4b422..58605c32e8102 100644
> --- a/rust/bindings/bindings_helper.h
> +++ b/rust/bindings/bindings_helper.h
...
> @@ -319,6 +322,42 @@ pub fn store(
...
> +impl<'a, 'b, T: ForeignOwnable> XArrayState<'a, 'b, T> {
> +    #[expect(dead_code)]
> +    fn new(access: &'b Guard<'a, T>, index: usize) -> Self {
> +        let ptr = access.xa.xa.get();
> +        // INVARIANT: We initialize `self.state` to a valid value below.
> +        Self {
> +            _access: PhantomData,
> +            state: bindings::xa_state {
> +                xa: ptr,
> +                xa_index: index,
> +                xa_shift: 0,
> +                xa_sibs: 0,
> +                xa_offset: 0,

To match C XArray __XA_STATE() we should also pass shift and sibs. Even if the
only use case we have currently is setting these to 0 (XA_STATE()).

