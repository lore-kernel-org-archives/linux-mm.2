Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B3A7CD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 15:15:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DC386B0005; Fri,  5 Jun 2026 11:15:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B4396B0088; Fri,  5 Jun 2026 11:15:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CA3B6B008C; Fri,  5 Jun 2026 11:15:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0DA736B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:15:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 88BF98BD55
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:15:36 +0000 (UTC)
X-FDA: 84846208272.15.089A96D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 90BD82001A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:15:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A/LST3rA";
	spf=pass (imf03.hostedemail.com: domain of tamird@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tamird@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780672534;
	b=8cGlyFZ7VKM1ZhKtHlUXS/0b1+dmxfPk8zsZ8Frr0GwziuNcLtKDwLng+cenEWoZ8dX6E9
	WSfQ26QRMiW8wKoVTZeZ4bmQ4HEA7wlT1WUSseWTVKg+T8AhdxRku2D75ZYPOlA0uS6a0s
	I/5ja8Jo5YiMokr+zgyguXvzYZFMesM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A/LST3rA";
	spf=pass (imf03.hostedemail.com: domain of tamird@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tamird@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780672534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9hu0o0fyp20w7TIliLFLcpValiU7Db1HDsBy9VVEPVw=;
	b=z6MSIQ3rpv6MOoh5Oj09LbTExbkh+MTsFZ12JcKm5J5wQYuqYnnauPvtN+D1dlVkrP9r7l
	jCMceHBeoy4SFhgDqIN3Do8TE/JlvAN/2DK2IJtCHrZmPB0gj2Dp2hTN3HCPTK/JlCCdmu
	QVy+dr4leY9qKDZUFfg7PNDe93FRN+A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D3DF3600AF;
	Fri,  5 Jun 2026 15:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3272D1F00893;
	Fri,  5 Jun 2026 15:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780672533;
	bh=9hu0o0fyp20w7TIliLFLcpValiU7Db1HDsBy9VVEPVw=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=A/LST3rA7KUIeIGHI7O0N0Vc2oaxbsiSW365Mn4PUJcOqTIzqXelzxVwOmTi0o8Gj
	 GMXiLWcRyvvZ+szm4vFJzhJRccjP4ueMyMrE3DyIUwGtIWDhWW+L+xvwb3O9iZ7bdt
	 o0fCIrMXxKTH03I5eJ5UC9eXb5i984raH2/lEsMOamSQFC/A8oITq/p3m45JTs36cs
	 mEbMlxpPO3oJlycNgfurvnWHLyS3ROcECYHb6Rlfst24KRau2cZwwiDBnYvjcKfqXj
	 GvQeI5BAlHxHb9u1AvgSusnjvKJoUL3j45/7j7rKdjzVZLyTitg1EcEyaZh4pIy3zT
	 OKSNuuaTO5GWg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 02/11] rust: xarray: add debug format for
 `StoreError`
From: Tamir Duberstein <tamird@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Tamir Duberstein <tamird@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Daniel Gomez <da.gomez@kernel.org>, 
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Daniel Gomez <da.gomez@samsung.com>
In-Reply-To: <20260604-xarray-entry-send-v4-2-965f6028790e@kernel.org>
References: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
 <20260604-xarray-entry-send-v4-2-965f6028790e@kernel.org>
Date: Fri, 05 Jun 2026 11:15:13 -0400
Message-Id: <178067251341.96312.1551479010624701516.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=713; i=tamird@kernel.org;
 h=from:subject:message-id; bh=efjpmt0tSacNlIg1827ocaHBfa/q3Wj5XMD4Vq67/s0=;
 b=owGbwMvMwCV2wYdPVfy60HTG02pJDFlKL9hfvjU39bJQLn/Rb/T6YMm+rbucQmx00qZoGeyXP
 3rg4Ma7HRNZGMS4GCzFFFkSRQ/tTU+9vUc2891xmDmsTCBDpEUaGICAhYEvNzGv1EjHSM9U21DP
 0EjHQMeYgYtTAK56FSPD9j2Ga3TW/xQ1+2PscvVO44GYA6HFfTy+v4sDPwj/2i7Vw/CHZ7HNDzU
 2z61/DOVW6b6p9Vj8c6bi7o1bpi+8dvDdrdzprAA=
X-Developer-Key: i=tamird@kernel.org; a=openpgp;
 fpr=5A6714204D41EC844C50273C19D6FF6092365380
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 90BD82001A
X-Rspam-User: 
X-Stat-Signature: 7ebm1yn7r9eux6k3k3odx644khzuk1hz
X-HE-Tag: 1780672534-586233
X-HE-Meta: U2FsdGVkX1/hjPxa01QQMAlGgmEetP881m9c+YKb4hBrfLCcPaLdcY2xVmCsCLjWiqI+n5GZux/MiojjrDN6tehyxIXGYP37GbsdK51t+LAnYvNgweXKeV05UuoCNArVL6hmcj17W1VrFdAeBvcrifX6fdQ4vBwEAdEjYsCBsNnNeLJl08nhk6vYhr0OxlARSmPM+M22a7oaKMr+A2Hjv8fyLcb4kSw9O1wAdDX6TiL0gp7quiIIzvIbdxtFKXLxd8PQqTwgv+aEo3SLLko50O98b4VyNYjCSjWN/RSoPT8+3WGvmRoNOjkq7eVmmVxuayfKfI3Sf/8cL87iC8Zt960tZkoPduF0g88TAwDtwXwcLfQGRPIzlFTEE8vs8mQrNo/m93rOGOYPN8rxaN2V+L+tKZBJ5anBUsFYSNDdIlRFQB6xZziBxqWgRfzwmRyXx6SSIfCSlL+141yr6dcRpME1EmBs0kWrG7U9yEMwP5kOKgG36+zXbSqzTepkT/dM1tgr9X6EPmrXkgh4k4TGANlSqgVsp3ZIjhrCbdwdX1VhfITTyfJOcKbXvilyQSIHFQ0cW2Q+dyzf2rcvmB10pOItbHO3HZTucF0jiHVEh7gF4NFSz+O6yFmgPV+Jj5Oji95jO9KENZdBGAQ8aw69YSE48V4YxggwoU2NZwe1eEFG0zFQlOgdoEu6ZCkyJJt+rct/kLmUOqGvNuKWtGJg1gP+6HwHF+mUTtefBBLeJ1oCQwwpbaCp0vQXxr/OJ85WmoOXAm89HMk5e4b43BdVJ/XN0zA2djFLYocFwF4581Sg4x72PXbkEVrw/eGH3Hu+blNLl87n77GL6zTFW4hHblPZquaUNkfDtuLpEn6dwGJfTyKFHNbOLNKll3D2RgPKWKAroWRuLIepqzKRgVh6F+2sEqrFnR1NI949lM52MhJ2UeT6tFZLyMXiV3fvCjiz0my+9UXekBjZrN4PVNP
 L9ybMLZ0
 bzhji9Mj6YYyr3gh5qQLZ8lY1Arytug7Saf01LCLubyTon6qPJ1hbkfje9FiikuBE55hwLnZnwfT2X5zmpitlcvb5Mzn2IQ0rL7Y+TzPiXK1OcLCpFUhui2haCf/rohEAgXrYjJq4uCMgCQG+UKo2aMc+X77mfkQUzZot87sYnqhc3RHamoVXDcpknf2r6RdzV7mlkzQymr8ek+V1jBgaUYFuxJGr7d6ZOAOAVYRoSuLvB0UA+e625atwgK3s4zH3DBrzRiV2+VEIOhyKatNMwPmIIJkNMjLCswnbQj1QUyRDFGcXVQvtQOV/uj1zW8Nzbsvc5P/0K0CoRcdTReqOvA4ZY3ItkCLh3nIvfWLQAkml6b8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 04 Jun 2026 21:58:08 +0200, Andreas Hindborg <a.hindborg@kernel.org> wrote:
> diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
> index b80fb7a262d0..d54942aeb201 100644
> --- a/rust/kernel/xarray.rs
> +++ b/rust/kernel/xarray.rs
> @@ -193,6 +193,14 @@ pub struct StoreError<T> {
>      pub value: T,
>  }
>  
> +impl<T> kernel::fmt::Debug for StoreError<T> {
> +    fn fmt(&self, f: &mut kernel::fmt::Formatter<'_>) -> kernel::fmt::Result {
> +        f.debug_struct("StoreError")
> +            .field("error", &self.error)
> +            .finish()
> +    }
> +}
> +

Maybe an import of `kernel::fmt` at the top would be cleaner.

-- 
Tamir Duberstein <tamird@kernel.org>

