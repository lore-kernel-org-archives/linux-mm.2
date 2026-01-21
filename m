Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11C57C44502
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 09:56:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F9BB6B0005; Wed, 21 Jan 2026 04:56:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A7346B0088; Wed, 21 Jan 2026 04:56:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D40F6B0089; Wed, 21 Jan 2026 04:56:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4ED846B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 04:56:20 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E3EE413BF2E
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:56:19 +0000 (UTC)
X-FDA: 84355515678.27.170D6FD
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf20.hostedemail.com (Postfix) with ESMTP id 24E811C0002
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:56:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IEO2JQYn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3wKJwaQkKCBs1C935IP8C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3wKJwaQkKCBs1C935IP8C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768989378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r4Vdmpp6SDCxVlxf20l2O/7vEQ7zWkGtSlAUCfaFALE=;
	b=Fidyd8+Hgs2KY9YlO4qnFTk9Pxnyy5hwQOxYSLCPN7mRygaCmey2WTuc1upt/yu72Mb3Xx
	5NV/UROY0R1//WTH+dPM9szEe6k70EUERCxHHUZXhvBQJ5Y8m4iB4jpjelL73b/0cgDmlB
	vTLV3U9z/Oov48P/dVCHF0OIewq/sBY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768989378; a=rsa-sha256;
	cv=none;
	b=Ebtlf63EPr8jzGnLLKAUb7HwikjaMCYb/AjBVNQDg8r8TtUlk8zLgF9WIZlVBo+xNrD0Hx
	lQJqVB0ODpxDyt9spNsz5p50QtJ33lOBSage7IrpmUE8ZDusZ2lbTyaM7CLT2VfHuhYecb
	TQKMu5W8iajcGPPCm6EJFxBfDLkyW2k=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IEO2JQYn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3wKJwaQkKCBs1C935IP8C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3wKJwaQkKCBs1C935IP8C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--aliceryhl.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-430fd96b2f5so6063953f8f.3
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 01:56:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768989376; x=1769594176; darn=kvack.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r4Vdmpp6SDCxVlxf20l2O/7vEQ7zWkGtSlAUCfaFALE=;
        b=IEO2JQYnbbUxhNkFY5DFFyTnH8RpTaD6bKhd8IdlBtCDhre2GPo4vRex412msLfgax
         Kc0QSu0+StiWK4gpE2gqcJL+RXfOhnVP45+5sbp1jnToD1BLs/bAOmWhQ2mPFiL9VWsM
         wkBcZjhrDY8771L0Pioi2u/MVCeNb2Ym6tILuL9iToI62cc+ZiVFSBiXhA2fK06w3p/u
         Ubu7e9WrQWhnDFeGecGTGMYRgmgzUj5ghbn2/L+C9cBdk0f0wugbOqK0WaM3kqEOhn9I
         uoM/AYvea/Vw4AKHjlmVlUCOGxflxre9a906Zf1X+ZBJoYEBGyQMSWUhzc9KPjLEU55n
         SOaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768989376; x=1769594176;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r4Vdmpp6SDCxVlxf20l2O/7vEQ7zWkGtSlAUCfaFALE=;
        b=VWxM83i8NmbXmKbxk5GJyJ0IA7CtdF1RG2TkGQ/PhNeS8DgsIQ06vR/hR/1Lgk61Qk
         JZjrhsNm9tqyIq8TS0+hJseQcaCujyrwwi5rJRfxRLdaro+O6paLmz3VU6POeV+WYBIT
         UjXHlALzhl03ChW0MTKqg00qXVg4iT/Y8+9cw/ZnS2RUW89/S3PGD2jaVoTsxUf+WQKu
         s4KkI613ZYle1YoIv2TB3mSu4c6dN7NDXxmN5YxENCwfOji5kJ0aANSj2gRP7J+8sLCm
         FQCBFOdZp8/ZwK1tOW5Tla4hyNXLRg25xV/FisKw+DZ1NIzF2RMOTfEef8Y3CEaBf3nx
         zumQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0AJJB5yr3YTvBIOUoVZOBcZNLH6YSeXy2UQUKma8sm4OXYhldinTijKM0ihT6Xt+MANeicsOMyw==@kvack.org
X-Gm-Message-State: AOJu0YyqCtPCMoPfX3itEz4l+hcf/YpnpHBx7TWDjuVR5u5VXYYBJFz6
	/wqZCyCPdiyCTk/Q+aZ5dcUlqZ2W7idPqyjBs93MOLoimaqheoCEOv8/AKwTFXsa4IHWIYhSWOS
	G1NSG6+NSs316gyYyVQ==
X-Received: from wrbfu17.prod.google.com ([2002:a05:6000:25f1:b0:432:84f6:8d9a])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:186f:b0:432:7d2a:2be4 with SMTP id ffacd0b85a97d-4358ff6fb27mr7340210f8f.60.1768989376449;
 Wed, 21 Jan 2026 01:56:16 -0800 (PST)
Date: Wed, 21 Jan 2026 09:56:15 +0000
In-Reply-To: <tal36hph2g5azjk33h564bllr2n6bz2xhdw4vcvizkhptedfuq@56chjersnkfe>
Mime-Version: 1.0
References: <20260118-mas-next-doc-v1-1-827d9f4924ce@google.com> <tal36hph2g5azjk33h564bllr2n6bz2xhdw4vcvizkhptedfuq@56chjersnkfe>
Message-ID: <aXCiv9vOrMTbiJtb@google.com>
Subject: Re: [PATCH] maple_tree: update mas_next[_range] docs
From: Alice Ryhl <aliceryhl@google.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrew Ballance <andrewjballance@gmail.com>, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: btraia5sej44isf8ye8cz7nar56g8uqx
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 24E811C0002
X-Rspam-User: 
X-HE-Tag: 1768989377-763811
X-HE-Meta: U2FsdGVkX18wyCkSmxSmPgDbc4yK6cIkRYPQsE3CsK4LcoLucfkp1+j7E+Xy7VQTgtW0U3Jtl+6pdEn9A2MvSqV6RCu9iIB/gTLEmtPqxT8EoA1KeLF5jYy73IN1RsoK9UlELEwdnNVqWTQVsQ+oYFcr4L3v+/8ku7kOzbiuHcb5ULhJ68gff12ct3rhDhQY/pX1kA10PyGtMjsRQMPu8+rHe6EwEPhemWJnuFiQqEJ2h/v6V+Caw1RPp5qD1eBNnmdTjpCdmxC6+Pn7fe4inENkFGgkIqNaoXT6TnHCWZQWgQaRW2DCx3lymBmwU7Gb6P1VhGB7WANHW6waZSaOsPhiKct6JXiUhGPBfyfIDQUs0rf6y3PoESsq3VkHxsdKhAdROsIj1omuETDYFT3vqibxJvHdSrBekRMg4xwls470lUvpC4EPkUnrju8t2ZrC8nLdkjg4d7Lop+AOTNUhIu/bcHsYtHSqvNUMh6CGYDGcLOX/1ggG3HZJ8EMnbHR7RXlcZ+Y/IaPcoNy3sY2zaWPTgbltFT3u0e0T5evN7hbhxAoNMXJPYnFtljG3bTSlLm/hcBfNHuiuM0VXI11pHYCim458v0CIgxn1CsXCQEQq2cPjtoNq9vrGb/HEGeYzDUC800FTZ+h5BKjPoIwfE1JhCEi2gCp6SmurDe9I2Exp5yNgtgilBCZidJSPPXm7u+MCBdijjGZC49Z+CPQ6SztiWExPIjLYyL2J207WsDt/uf6bQ0QijB7rGl6bEyOp8CXzTvJOXjF0d+y/IHxc5ndEkelMy4X45XckIjSBLdP7nujae2X4Nu2ggpODXpGZ7v1GHmItepe3+z6Fh4/GF/jNVNZ3FprkIEy69zHpUiwUy6nPPErLEm1afFPOrUf+4t/GccrmjE+WHNyXTmyi6AAObN/NK6AgH1gx2EAd5Jtyfni2nnTYKFVV0gJ9L0OcCnJ68YHC8LCwI8Mmpac
 j8arXCdc
 Rp0q2ENvdnKP8M1LW9zBKGCYjnRJbNXKCCOS+lxgARs3BWGrUj+2Vr/8Zjsm3We2yE9G7X2plQIFmrIxiMOIl67OVXPCTzuMHrtcwkTE6BgxRh3inGyN99g5t3/vE9PtcFSpz6P5SS1beW+B42moOJTXU68ihrhUEUWUPXG8dwJ9FGaSkos3mAaRyGRCl0PFTDbtuuFcB7RzFfXMvGvD9fcFXe5rVFPhXrXZjOW1E70n4fzcknyLMbYPGbKiJWMI/IcMQbBlEmZAkK73H/q5GAyTak2asHnnRy+55HfjxuroGKUKr1uIQYoFSUfO9zBPtDCzyCPPM7K5VdnmpVeQk7tgFaCuEXxqsScVEmcX8nC5w+NfonK03zRUotTPXplUwhuHmFriDz+58BaSbuHbWSxVTLZBQru+0mceALYXqLOrWHaN6kuQmDExa6hcSdYIpagqWmGYOkOFAWJTg9pHSalU3yEVb0703eTWh5ivRdv5FJgS0tEKzQ0ARH1yXOxYn2Nn6R4o0/lsOjEO61CbfQ5GmaYNyQ7lYbwgh72URBSiJw39j10ZsImJqnAYx1laRumJ0haGmam9m6yiZgpruWxBWN6Qm2aFdjK/zgD4mYK6Dene7ny9PIGYEzpqvBcoB54kRY8EQ3GVDZZw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 12:54:47PM -0500, Liam R. Howlett wrote:
> * Alice Ryhl <aliceryhl@google.com> [260118 06:00]:
> > If you read the docs, it sounds like the difference between these
> > functions is whether mas->index and mas->last are updated. However, if
> > you read the implementation, you will instead find that the difference
> > is whether NULL entries are skipped.
> 
> This is not the intent.
> 
> mas_ should return special values including the XA_ZERO_ENTRY.
> 
> mas_next() should get the next non-NULL value.
> 
> mas_next_range() should advance the maple state to the next range,
> regardless of what is in the range (NULL, special, or a regular entry).
> 
> Both should update the mas->index and mas->last values, if it moves
> (ie, no error state is encountered).

I guess I'm a bit confused about the difference between XA_ZERO_ENTRY
and returning NULL. Isn't the case where we return NULL when a slot has
been reserved but not inserted yet?

Like the docs, you use "get" vs "advance" wording here, but I don't
think there's any difference behavior-wise? Is one intended?

Alice

