Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D01BDC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 00:14:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD5186B008C; Tue,  1 Sep 2026 20:14:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B86386B0092; Tue,  1 Sep 2026 20:14:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9BDB6B0096; Tue,  1 Sep 2026 20:14:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 822CF6B008C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:14:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 00A1B8059A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:14:31 +0000 (UTC)
X-FDA: 85166900784.10.6B86780
Received: from sender4-op-o11.zoho.com (sender4-op-o11.zoho.com [136.143.188.11])
	by imf21.hostedemail.com (Postfix) with ESMTP id D94E71C0008
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:14:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=hDRPL60R;
	spf=pass (imf21.hostedemail.com: domain of deborah.brouwer@collabora.com designates 136.143.188.11 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788308070;
	b=fXD+rgZi82wsrBsnBT+NFRgoCGkNpXWU3a1RO/RU+ghcwg1xt3+D7P/iepKNgwWgRcSkNk
	+0tewNlSVvEqz2mArX93q7PrOkRu5PXgEL9M1dT/iZ1bRUBxO1oLh8emeYy1aCcfpZevDZ
	8R1Jaq2yBhc5mXPHv7L7k2lRCvlue0I=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=hDRPL60R;
	spf=pass (imf21.hostedemail.com: domain of deborah.brouwer@collabora.com designates 136.143.188.11 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788308070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9v9K7xAFlRpojhSRY8CZl+bL11FYUJs3WgBmJ4SVq6A=;
	b=u/BjY4me1AvPXqS2r9EiIforW4oHUK8thm5FvEw6OgyK2VtZ/QGNtoIVO4TxOEzyEQv7z1
	mvWzEQcQpZ0vRW8zjEweU6uIrCxLP7lvc4K2QtLD/I/TT0BQt7GYhStlZfdFeV3swVG3z2
	SOUC31hTCKNi1nZNuiHehXnbUYaTLNA=
ARC-Seal: i=1; a=rsa-sha256; t=1788308059; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Sud1lIN0877KOQr2c4mj7GP84xRNZJf2RvgvS6jdjTcZXgaKFt8oMqfFXMDs0IpBVrgqhqOgSVY27KaRpKHuDt6JrfcAM+lWogZNaln0RMlSQwXCylZP+6VwMhzmLL3qhPz0K/tF67tIBZWIyg+jr9hfg8lWaxwoXMvMNWBg7Tg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1788308059; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=9v9K7xAFlRpojhSRY8CZl+bL11FYUJs3WgBmJ4SVq6A=; 
	b=EkDloI2yC25Mr8Hpq1WUQaqYBERoRZa3yN9vaWASDogZY5OmpqqwT+e6axzTXGGPEHsPXEmMP9xXI/LT/IY7XIsHWMjqnAi9X3+V5igxoaOpGIz5oBNAY9QLgp1ATcKUfyCGI+8RiTV9EL3sYScoS8PHVXReasbbIwdxJ2BbLNE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass header.from=<deborah.brouwer@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1788308059;
	s=zohomail; d=collabora.com; i=deborah.brouwer@collabora.com;
	h=Date:Date:From:From:To:To:Cc:Cc:Subject:Subject:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:Message-Id:Reply-To;
	bh=9v9K7xAFlRpojhSRY8CZl+bL11FYUJs3WgBmJ4SVq6A=;
	b=hDRPL60R407Og0rshUwaKg4xQlSMKK0NIlBlrIjuMCP+Ea9rjisMeis1Byk91wAr
	BgASNV/zMDnwJN8JgvlOeTwnfSCP7FwxOgLz/MBRQddVYirwuBNyP1MiIdlRwlFE8Zb
	G0RUGNOICvI2KidCTmglHvjqPcdKkaSWGx22Ce8U=
Received: by mx.zohomail.com with SMTPS id 1788308056394418.9753833639205;
	Tue, 1 Sep 2026 17:14:16 -0700 (PDT)
Date: Tue, 1 Sep 2026 17:14:14 -0700
From: Deborah Brouwer <deborah.brouwer@collabora.com>
To: Ke Sun <sunke@kylinos.cn>
Cc: rust-for-linux@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lyude Paul <lyude@redhat.com>, David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, dri-devel@lists.freedesktop.org,
	Alvin Sun <alvin.sun@linux.dev>
Subject: Re: [PATCH 0/9] drm/tyr: add VM and BO ioctl support
Message-ID: <apdqVvvsWvzfNmiL@um790>
References: <20260902-tyr-ioctls-v1-0-e0fdbf8bd108@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260902-tyr-ioctls-v1-0-e0fdbf8bd108@kylinos.cn>
X-Zoho-Virus-Status: 1
X-Zoho-AV-Stamp: zmail-av-0.2.13.1.5.4/288.303.58
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D94E71C0008
X-Stat-Signature: fte16uhfzigqmskadc5pr8tdbf6n9yhr
X-HE-Tag: 1788308069-407642
X-HE-Meta: U2FsdGVkX1861CF8WXVDXMmF85zElWVq3AyJA/Nn++NjA3yBY65AWWBfPiY8ZG1lnLYSU4DV/3EPw6uF8h0udX34STGmLD4l/uT4Y3HQl+ymWJf1C7c2wVrZek4ggNAVicZajHlMSOpe2nvPkw8B2P2Ngcc9BPR3S5aL8umIMHehUF+fQNBuiDOzRrJitJ8jdlG0EmQDbA/C4BkAtWC78BxpbWevPcm5q7sOWWnX87aClY6YIwZS7NYbp1BnqLnNX3uJs0oqY08m4hG3yOKTPtEUSg2qOj1xPKaIxHluWQcLMwodnTmEfnVpnCesXk3BppD4Tcez6wDhYrjrkpRpGCm/TLhamQkyDmh+axy8C3c0wuUqyndPlEhOUJaCTQZqqIAWFYoYvQPop1HBuQBh/NpEqNB7KDR0oF6sVB23AUnt1KwQJvRyp5i0FHe0ovhJzgOoof4r9ymNd8sQYs5MNrbt1FKcSA+7TGMGlJ1KbVZ/B5B/XuuCF9QfJ+7iiwYqy1cPE9Ke2CJ9N3TlvHZC8rtOLa9lFMdNQrE6GfB8MQUW+GOUFmHGE1m2yYW56aXQYs8ck/urWN0iQxBBXcyHwm0pRkZm5s3UH/KlX+RBgglWdhMKbJDzgzbHB4jLK+UVri44qRsbddG5FOJzFT+py7kSJxw3oQ2t+Ka0NYjit1knB4NBDH6dxV3oHon52vvG1v1DqTR8TeVC9BX87JmBfgnr9RMGf5HE/cACewq9WN/W9tIIHjuWy8CEs+RpymgQNSBitAzqdZZg8Q8WcVzJNPuZJrSldI+fISO0duChDmpcJ09IWQ1sZP4XON/3wsIiIu/095fInL6u4sEUP2+YHe4QD1CqRkNskmSKvA6ITiWAGqWXy2S8lluxgch4sJTWEx9xRGw1vUcJ7cAE6jLsoc/sK3tmIG3KKU4TOEpqq4gE5nHPrk/Mz1/A7/Mlz0mEzC+fEgb1kHGk8R4jx5P
 wzU9Wgl8
 n2PG+k+0z5E1stbPOUDfrTu+zP2uMeHpe2o6vpJ3yqZePy/sZ0FEmA88vTyiOFgRHjC9zKaEKRU9B7V0Rpa42a65OR7cHOIO6gAd4lmPLO1zW3DiXwfqse0MPCjpIry10X5cCwVXoXVG+UYRm6skwM6j5yxljXF7FSeeIhHpbw3FsDMmoxnTE9XEciAuPccQ+vJSwt05rhcbm/nXose9Ov2tq2xzb1l9xFXIt4VuWJ/deaq8WecXiwgf01+7837cAzgf91JqCTMB95GX1EiEtXFmjiUTeZ30ucrZwxhdMal2ibZ4zwuiCvlFXFqG4sBjkZu3od3lSDpyGbRlDI6KQfOc/GL2alrOi1nl145An8X7V+BwGj89f5cT4CFusHT9Ejd8/exCoRF8xfHEArQdjAzCyhIxlXe/g0A8Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 12:08:59AM +0800, Ke Sun wrote:
> Add the VM and BO ioctls to the Tyr driver, aligning its userspace
> interface with panthor. The series is based on Danilo's `drm-file`
> series on `drm-rust-next`, and uses the existing IdPool and xarray
> abstractions for per-file VM management.
> 
> The panthor IGT tests pass on an RK3588S device.

Hi Alvin,

Thanks for sending this series, I am still reviewing it but this is what I
noticed today:

1. Do we still need a separate pool module, since this is just for VmPool,
could we put it in vm.rs?

2. We might have a problem matching panthor’s 32 VMs per file, since the
minimum capacity of IdPool is MAX_INLINE_LEN. But maybe it will be ok to
extend this to 64 VMs per file. But then when we drop the vm pool we
better not rely on that PANTHOR_MAX_VMS_PER_FILE constant.

3. Also, I am not sure, but do we need to call vm.kill() when we drop the
vm_pool? Does it depend on the vms being activated? And if they have been
activated, should this go in Vm::drop() instead? 

4. Could you use dev_err! instead of pr_err! please, we tried to convert
over to that in the booting series.

5. We should be able to compile each patch in your series separately (to
help with future bisecting) so use the annotation #[expect(dead_code)] for
patches early in the series and then remove it in patches later in the
series when you actually use the code.

6. It would be nice if you could give a link to a repo where you have
applied all the prerequisite series and fixed conflicts. Could you still
update the branch from:
https://gitlab.freedesktop.org/panfrost/linux/-/merge_requests/64

Thanks,
Deborah

> 
> Signed-off-by: Ke Sun <sunke@kylinos.cn>
> ---
> Alvin Sun (9):
>       rust: sizes: add SZ_4G constant
>       rust: mm: add `task_size` helper
>       rust: sync: arc: relax `ForeignOwnable` for `Arc<T>`
>       drm/tyr: add per-file VM pool
>       drm/tyr: add user and MCU VM specifications
>       drm/tyr: add BO creation and lookup helpers
>       drm/tyr: refactor new_dummy_object to use new_object
>       drm/tyr: add VM-related ioctls
>       drm/tyr: add BO-related ioctls
> 
>  drivers/gpu/drm/tyr/driver.rs   |  14 +-
>  drivers/gpu/drm/tyr/file.rs     | 394 ++++++++++++++++++++++++++++++++++++++--
>  drivers/gpu/drm/tyr/fw.rs       |   8 +-
>  drivers/gpu/drm/tyr/gem.rs      |  41 ++++-
>  drivers/gpu/drm/tyr/pool.rs     | 102 +++++++++++
>  drivers/gpu/drm/tyr/tyr.rs      |   1 +
>  drivers/gpu/drm/tyr/vm.rs       | 158 +++++++++++++++-
>  rust/bindings/bindings_helper.h |   1 +
>  rust/kernel/mm.rs               |   7 +
>  rust/kernel/sizes.rs            |  12 ++
>  rust/kernel/sync/arc.rs         |  12 +-
>  11 files changed, 714 insertions(+), 36 deletions(-)
> ---
> base-commit: 0b0aa9dcf17b6cffa9e325ff641e843b20d40c31
> change-id: 20260901-tyr-ioctls-f10ef0dcbfa6
> 
> Best regards,
> -- 
> Ke Sun <sunke@kylinos.cn>
> 

