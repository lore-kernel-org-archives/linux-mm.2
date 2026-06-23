Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59C7DCDB471
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 17:55:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 530086B008A; Tue, 23 Jun 2026 13:55:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E1026B008C; Tue, 23 Jun 2026 13:55:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D1EC6B0092; Tue, 23 Jun 2026 13:55:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F1046B008A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:55:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7DEF2405CB
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 17:55:46 +0000 (UTC)
X-FDA: 84911930292.29.D369DC0
Received: from mail-244107.protonmail.ch (mail-244107.protonmail.ch [109.224.244.107])
	by imf26.hostedemail.com (Postfix) with ESMTP id C1C7D140002
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 17:55:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=onurozkan.dev header.s=protonmail header.b="SaENjC/C";
	dmarc=pass (policy=quarantine) header.from=onurozkan.dev;
	spf=pass (imf26.hostedemail.com: domain of work@onurozkan.dev designates 109.224.244.107 as permitted sender) smtp.mailfrom=work@onurozkan.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782237344;
	b=X6dFi9NOIo7f+9nPtU0b6si6GnRqvoBJXMrxwFgncVD23YdyEJOcXefhDmzO2to5H9pDYP
	urYHsDwTQ7Y50bUNyCx7X2NHpbqu7ii8ODhHY8ZqQFRptbJpYlaANSnk0+7FeDUiLJFgN9
	amSg+zsR2Ov1P47kkwxQt6vhFDCPh1E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782237344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3anUjfUqAfKXRz52ChpQC6zD/lO83bxGXry/MLwNSO4=;
	b=di8Z+s8YD/rlGcEe7kQB7cLx3jD+6Q2jxtoPAYT+RIr68RdSnlhZKbHoBaeoidVhL1A9Iw
	muPddcwJXpQO7eOL4Mqo8+OwBVQLtIDx1zNEeXUXdwANgvTXKLE8mXd8ZOFxJ47Z7fjpUO
	8NiZ7TcmtaqLI6KzX1SbpHkRubuvcI0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=onurozkan.dev header.s=protonmail header.b="SaENjC/C";
	dmarc=pass (policy=quarantine) header.from=onurozkan.dev;
	spf=pass (imf26.hostedemail.com: domain of work@onurozkan.dev designates 109.224.244.107 as permitted sender) smtp.mailfrom=work@onurozkan.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=onurozkan.dev;
	s=protonmail; t=1782237341; x=1782496541;
	bh=3anUjfUqAfKXRz52ChpQC6zD/lO83bxGXry/MLwNSO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=SaENjC/CMfJZ7aHHoNXuyYXWirhvR5ckMqH4I14+a2qrFUk93bDnMCqeErFBQUP0v
	 PxAWcf5MDaK/h1+PD7Xztk8DHBmAJYuQzUbbofQh31Vb4K0rPbNtP+Zj5Ti0PaEz8l
	 y7CEtR0ABhnvuBrjq3wJCkhsDkXd88Kz77ci8Kb9M/DzKOTlJnxdVVucC3zmG0+KJo
	 xF912ecuCseGcuSm2pLKB+3MqPL1t5fQg6fwfBm0AgiTbsz/L7KnDM+K/Mc8yoO1Cu
	 m/g4LsTaCYFIk2IHmf42GmBOu40VhyMkU9d5U+5iUSwTb8XcKR+78rOM4IGjygJn3N
	 vwMFoIeCYeWDQ==
X-Pm-Submission-Id: 4glCQr5V5Bz1DDKr
From: =?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dave Ertman <david.m.ertman@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Viresh Kumar <vireshk@kernel.org>,
	Nishanth Menon <nm@ti.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Igor Korotin <igor.korotin@linux.dev>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	linux-kernel@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-pci@vger.kernel.org,
	driver-core@lists.linux.dev
Subject: Re: [PATCH v17 08/10] rust: aref: update formatting of use statements
Date: Tue, 23 Jun 2026 20:55:29 +0300
Message-ID: <20260623175531.85421-1-work@onurozkan.dev>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260604-unique-ref-v17-8-7b4c3d2930b9@kernel.org>
References: <20260604-unique-ref-v17-0-7b4c3d2930b9@kernel.org> <20260604-unique-ref-v17-8-7b4c3d2930b9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C1C7D140002
X-Stat-Signature: rqiujb48d1ndwqjfr6qb4xpxsd5a4fqt
X-HE-Tag: 1782237344-534539
X-HE-Meta: U2FsdGVkX1+9CMZn1AkVIS6j1GolqRuns7rEpv9upRVI7tlDgEZREhjxKfASV9JGGl/L3i5KxKhuXLxgJZ8WPR29ox1fn0PEXajE8z5U+xSWRNhFNVsVGR+q0rhhmVm8E0+NLtp5fFVrRWMuR2a5BryCuLqK7oyhB1tSBp6jGa4gmN1hFe70SwBI4YoDmg37zmn09WurmzKOYEWCt3vNc2a4T/nPdyRFNmBxO6S/wL/jZ6oRvPXhYjVUQnIo9b5XdWCFBjS9vvQI+a7rMT6eu/yn5HG1rntG5QW/5DRmqXKrlJYXdI1JDTMy83fwWhLchnNmHcyOkYh/ni/B9FOujBSPF0nVLtMjUNrHZ5pTaRTTvGwLNdjM+GxXdy7lCijseNz7u3PJI27PbwRZv/cNbntCDJVPnbE5e/Lt9MP73WXEAVOGjhLhE0xZjaG8nVLG6H1CElufXvHoSk6g0Edzo+IWR8gI/JdMszgn7rM7xK/l25CSRkJUrmWuhSyJ+2eAmEBZ3jF9pebf/RkZ90iX3c51MfpaWlRyRkSz0iflMK4SivA+NITCK0r5XlbFdrYeIFvvvsLGYnYDmcH4eMLVrZkTT+nWABpXnS5/VfqsMUUi+jZBGAFCCs00HW7ptQ+r+VAsXRGYvpCM32DYSoQTSM3R445H8FzLraWuNZELdm9XLKcORkXAfTSR4vUTeqpBQsnkHEz8BLvk4h7Iph6PPOCdwuMS06eqsxai2mYBhnDAh4fC5XIXMSHzH0QJSQItQeX+hrpAgaWN2Zjlgr6cnDKb77NuSZPvtjVNgnduTfx5dMmLJwiekhJjfCoXv0CeEFIJQhALudVRUuIqCfDwQxzBapXTgs6Dn+XfueGMclf6XKdpiqWZgXkJKF7dzu3Hi9RWAtu1afELF7HCWY15ZMYXy39QOBc2R5GefTKUFjx5RQDpJ6pbuhV9GBBCvzl/lSniKcpbjEtRPATzT1/
 Gc/1xc0A
 N13mSGe5PBx8SM/kiGpkKzYr1UOl64hLzc+2RSDTmQS/vwF2J174i40+eboy6LfzAFs1FyueQMOfSI4+OyiZIixp+/gOG0bKbjtHS2nBqL9Vb5BoB8ohGkZ09gKn7ij+Rz+5NiA3FfB5bxjOlVQnWOBLCqqV01fft4756uZvs2TWFEjVZ8N4LLN4z4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 04 Jun 2026 22:11:20 +0200=0D
Andreas Hindborg <a.hindborg@kernel.org> wrote:=0D
=0D
> Update formatting if use statements in preparation for next commit.=0D
=0D
I guess you meant "formatting use statements"? Also, why not doing this in=
=0D
the next commit directly?=0D
=0D
Onur=0D
=0D
> =0D
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>=0D
> ---=0D
>  rust/kernel/sync/aref.rs | 7 ++++++-=0D
>  1 file changed, 6 insertions(+), 1 deletion(-)=0D
> =0D
> diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs=0D
> index 7491382bcf29..818c84fa923a 100644=0D
> --- a/rust/kernel/sync/aref.rs=0D
> +++ b/rust/kernel/sync/aref.rs=0D
> @@ -17,7 +17,12 @@=0D
>  //! [`Arc`]: crate::sync::Arc=0D
>  //! [`Arc<T>`]: crate::sync::Arc=0D
>  =0D
> -use core::{marker::PhantomData, mem::ManuallyDrop, ops::Deref, ptr::NonN=
ull};=0D
> +use core::{=0D
> +    marker::PhantomData,=0D
> +    mem::ManuallyDrop,=0D
> +    ops::Deref,=0D
> +    ptr::NonNull, //=0D
> +};=0D
>  =0D
>  /// Types that are internally reference counted.=0D
>  ///=0D
> =0D
> -- =0D
> 2.51.2=0D
> =0D
> =0D

