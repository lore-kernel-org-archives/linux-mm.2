Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE52BF46445
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 10:30:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42FC76B0180; Mon, 16 Mar 2026 06:30:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 403976B0182; Mon, 16 Mar 2026 06:30:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 309886B0184; Mon, 16 Mar 2026 06:30:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1DA8A6B0180
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:30:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C2C81160199
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:30:20 +0000 (UTC)
X-FDA: 84551556600.27.D93DF9B
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id 025FAA0004
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:30:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pQwP2WBb;
	spf=pass (imf25.hostedemail.com: domain of 3udu3aQkKCKQEPMGIVcLPKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3udu3aQkKCKQEPMGIVcLPKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773657019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=94lhIbTPxgV+K8KYN274qmP1kh/M3SwTueiM469hswI=;
	b=hE2meLmbAUviNMGezdn56tplz04RADah9uKrUQkgDB61cc5pD6ATBVQD+CvaVcDrJ0NULo
	twIamlUKCB55iimIYbPUxw98HLKknUP6zB9CsVMk5i9+cgLa1dH2zu5UYs3fEJkPcZBpkx
	fizkdUg+VktQ8Vq7DIKfirv/XRmEdM0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773657019; a=rsa-sha256;
	cv=none;
	b=SCPpmz6T5vDK5jXi8iaNAiNz5HZxzVprJznYo0IYViRnJUzJoACiweNbClB0SdvUmp9LmD
	vPQZ+f/+fDdNu0Phml9GtzPNMLbgXxuMvcPW4bC6h7MQdCrhekOLoLH4lyLV+2omYGKRHU
	0ESpUVFauFDPYMlhiuOntnXTkB1QJhw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pQwP2WBb;
	spf=pass (imf25.hostedemail.com: domain of 3udu3aQkKCKQEPMGIVcLPKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3udu3aQkKCKQEPMGIVcLPKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48531e8ae62so34514815e9.3
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773657017; x=1774261817; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=94lhIbTPxgV+K8KYN274qmP1kh/M3SwTueiM469hswI=;
        b=pQwP2WBbKOL/2Q/tOtjWHlSSS3NK1o2pAs80LZGZOg+H2GwlTMPCjea2d7lO7eSYKN
         Xva+pjAU/6KezIPizFwoJ1l1J0up5ZDYjGCAR1qOsTJG2Tac+4TpIAlbuHT43efUvyVI
         GSBbruKQZGgKsiHUg3rIAUpUQe7shMnnRsxOecmmN+1N+h9SJNWle/pjkPHBhaOgMot4
         5QdnooIV7eR7F+1Vyr/NwysD0P7SwjOcV2xaCskA6HFXV3moj+mf1743+HMmDeCf677Y
         JRpkOjJ+ZnDGUUF9i0pHGSk5QPwQnfyhqirnTDFWWsfWQi2WZHV/y+j/spGvxiGAilzT
         /wjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773657017; x=1774261817;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=94lhIbTPxgV+K8KYN274qmP1kh/M3SwTueiM469hswI=;
        b=XiN8BqJNKYzE6eKIZOrnfNAd+zCon3UCiYsTrnLYf7u6PmR2sTPDOsyb1qXXBSzQ/y
         QnMEXGfiltauu2kZY4B3X4kd4g++IEZLOx07Av2tpL3s4Sn4+usKB8ZkKjwjhyP8AAPN
         MlAfxfSIcPWqDaOEagmw8NjojktvScyQHVyF41l4Tnb8sNxivWg0fx6Ub8Ta5x+HaGQU
         FiM/6ICCohdPm8hOlIpNuIMjz6Eu9HeIN6awCfh4SERB4vKKCZQqlOqVUtfDayvB9Moi
         fE/xsfgHv+1aGso5BPMdb+9ByJurXQrcFkqXUG5V9KDXOT1lZuDrLUo/fTAJt9vNGIaC
         mR/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVfAwzQNKzpyyYNa5NANPM32uRCBMcBEH5wbRtL0XI59+UjjKb/eyvQkET3jjSStdd8c/JR7Ypyew==@kvack.org
X-Gm-Message-State: AOJu0YwiEEy+ZFrEupPlsMxNyo/csjQ/Ct/w/HjeLTIJystql/Wnk9n5
	mZM7EMibn77BM87bEg97nG2Z+vmNV4ja2bVu5e2D4A76w7YSg53v7JD/LYvlF4BhEPOAK1EuqJ6
	ewvFTMjIdPDbs1xNz4A==
X-Received: from wmej7.prod.google.com ([2002:a05:600c:42c7:b0:485:3ddc:f26b])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1f8d:b0:485:4278:24fb with SMTP id 5b1f17b1804b1-48556711dfcmr208483425e9.32.1773657017048;
 Mon, 16 Mar 2026 03:30:17 -0700 (PDT)
Date: Mon, 16 Mar 2026 10:30:16 +0000
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-10-de9a7af4b469@kernel.org>
Mime-Version: 1.0
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org> <20260216-rnull-v6-19-rc5-send-v1-10-de9a7af4b469@kernel.org>
Message-ID: <abfbuJVbPtIEyweC@google.com>
Subject: Re: [PATCH 10/79] block: rust: add `command` getter to `Request`
From: Alice Ryhl <aliceryhl@google.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
	Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Lyude Paul <lyude@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, John Stultz <jstultz@google.com>, 
	Stephen Boyd <sboyd@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-block@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Stat-Signature: h4s95jsf5kjye5gaphckfhk8e5r685ne
X-Rspamd-Queue-Id: 025FAA0004
X-Rspamd-Server: rspam03
X-HE-Tag: 1773657018-666751
X-HE-Meta: U2FsdGVkX1/KSexrwVsgwWZQgTzl2lOApJ7NNMYwvglT7Cdk5lAZOMotNw4NSGwob1abDrbHS4Q6EIcFBLRTOqzy6Uw+zlmgfM9wZbzwi7MItrDj40wzL/agGgYJocTd+hOKC8AE6+4NNWrJhqbJ5HtK/HIqXbrRQ3hFdrMdT+KF3mIpogxUzWLaOOXNb2IROFlxYb9FsAPGhiiCWFaa16/KLO8XgmfNey8+GNKocmL7sMQ2TvNFodKyD9UqNMXCOk5zint/yMZ1OuCV00ZT/I22M08y/YVIpznXkKepS64V0oDBTG9DrP1AIU3IC0HM0H6FyxnbUk3IN+lTbmxTEsLQWt5mrLKiyQZygpgfF8UzP6SfOeAMulVsLcS1SAh6pPFxFYrkb56liqaTgzBGF5GyO9pqJLfTQCPqXu01uHBP3TB4QEhxzSk967rrmDgMFD14fkyCp0VQoUk9zommxbHhvZhjJ3/AyVaHMeqfpk2Vq8cBaZlHnXx2NvVXg/vMtlOC+8bSBob47Bl+bs/e/O6RKct/S0mWDuzGmLLhzkrzuhmoRcKIYfvM+UPIehjK8oljrV32w5EXXBfjnzclQfA2xBrviBmPt7zOf78K+qi02C5S9+7VOnYHoVaaHGuA8r9g9QI5xtB5POO8HmkH30USKl0V685fsH3QEUBOHlxjHdlIgmfxp3cGzc5Sv4gLBexBWbAQ5tMQtYMN5wMRrLdBA9k+RSLeFP9y6Sulk8DmA2XrLfbwHie8itpFX5BCLm9XacTHGqalQmC0K7k7exPEn0tttrMkXSLKRBGekjUQ75g+eyBNIDxKRAr/h46hx/3KPlAGzdGJOpkbIYq0X5mtYsxjDj0ZaisJZU4q6D84ZigwrzRF7DFg92Oq/RBgFek/vq8U4S8CLBEbIJUhMzwvoyCTPcF4W5OOHn3c4fz3U/QWKGbUaOW/eBv3nJGVU/PII5MY4mreb6jWytc
 3HDQyO4s
 Y/7kqymNf4cvVQz7Nh6m7H/Pyr3oY4lGJISSPLzJVFGxsFqtcMO3QAqU/vz8Hrna5VuZdGjVDX2a6O4v0NpVLDjzYzpV1nSypEwfMw/ev1/uDfA+xzVzP1AmqFWEngAQ8YXiqUt0kdLI26Km83jl3gD/z5MAZ0XIbP9F4DjGyKt4pIzdVK+QDuKhNv7J1XQcDaTdvHoi96mrUX/ecOkxOHfScA012QgdUsPh7nU686u355Y1jHHmDGnIxGzdgE5SpNyi8Bfk4eycml5Af2qrx2Gawi+Cesz1DSi594XVzqFOdMVzxgjuU3qhRunyo/x4IRxwhrlbuN5XQQRJf9LqIXCWS2xbv3VgLZzSqHlbimox+YUknfuuSe2nsHXO04DsL7ur5JG4GP94ATp9SAHOtdUfZJ2LhzkA419SBEjNcx6qEr43GLRK/66V3I+2BDtJujyjyEkgDNtnGM+vzvzzx/F7sPOt619dcKuJ97Cq/Nuvcm8TZPcvbyGhbZdjTwx2IPjkfzhlDaOYX1cWcLjg303kfxZmnDrmV0pyqxugEN7I0DaMWJ7p9BATKZFA5TPHP1/sNjTGLKXxLPc5i4G6g5Hc1RoWHGKbdlKPWIUaKyfthG+PCV4Kfxnwd96JiwDtHVLEp/Lr42W24yUR7eA9l5xwFou7HBpml7t+DDTPLZQ+0pXYdXKoXheKj+HfSuFCYNEBe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 12:34:57AM +0100, Andreas Hindborg wrote:
> Add a method to extract the command operation code from a request. The
> command is obtained by masking the lower bits of `cmd_flags` as defined by
> `REQ_OP_BITS`. This allows Rust block drivers to determine the type of
> operation being requested.
> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

With the nit below fixed:
Reviewed-by: Alice Ryhl <aliceryhl@google.com>

>  rust/kernel/block/mq/request.rs | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
> index b49197a0c66d7..0dd329ae93dfc 100644
> --- a/rust/kernel/block/mq/request.rs
> +++ b/rust/kernel/block/mq/request.rs
> @@ -78,6 +78,12 @@ pub(crate) unsafe fn aref_from_raw(ptr: *mut bindings::request) -> ARef<Self> {
>          unsafe { ARef::from_raw(NonNull::new_unchecked(ptr.cast())) }
>      }
>  
> +    /// Get the command identifier for the request
> +    pub fn command(&self) -> u32 {
> +        // SAFETY: By C API contract and type invariant, `cmd_flags` is valid for read
> +        unsafe { (*self.0.get()).cmd_flags & ((1 << bindings::REQ_OP_BITS) - 1) }

Nit: scope of unsafe

	unsafe { (*self.0.get()).cmd_flags } & ((1 << bindings::REQ_OP_BITS) - 1)

