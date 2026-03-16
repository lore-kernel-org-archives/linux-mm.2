Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5954F4645F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 12:14:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6FBA6B0250; Mon, 16 Mar 2026 08:14:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF3406B0252; Mon, 16 Mar 2026 08:14:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A29C06B0253; Mon, 16 Mar 2026 08:14:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 90D326B0250
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 08:14:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 487A2B61AE
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:14:17 +0000 (UTC)
X-FDA: 84551818554.26.04C569E
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7652420002
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:14:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aw1wXuoY;
	spf=pass (imf03.hostedemail.com: domain of 3FfS3aQkKCDIOZWQSfmVZUccUZS.QcaZWbil-aaYjOQY.cfU@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3FfS3aQkKCDIOZWQSfmVZUccUZS.QcaZWbil-aaYjOQY.cfU@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773663255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7q2+A+kkZoyV3rsZQKFhC6jq2dbqO9RaZzFL/EKyo0=;
	b=wY3Ygodyvy5IRwJc9DZIjW/fi8Co2aYteiWNKKmLMreukazEFI8b9a0Ziu78r4qihrpqhg
	5MSkEneDNdGSerkuq4uwsv0T8vUoiNKSoZZ8Xx00yk+5b4/Dfvo+inh8Jp3bqn1X0x32xW
	ESbznk0cZaPnIONK2Lkl8wtGLsuzvUg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aw1wXuoY;
	spf=pass (imf03.hostedemail.com: domain of 3FfS3aQkKCDIOZWQSfmVZUccUZS.QcaZWbil-aaYjOQY.cfU@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3FfS3aQkKCDIOZWQSfmVZUccUZS.QcaZWbil-aaYjOQY.cfU@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773663255; a=rsa-sha256;
	cv=none;
	b=19RnvC79Og//lwtvWRNN9dWjvo9bpeX5eMnHZSGkrtz8nG8hS6hH0FK0RfBIKyNbUe9Bsa
	bcSuNs+bknMETaQHH560lFpXVAfS4K7w1k6XRHsG0KVvh3lty+6BzsKYHBrgQpEsg1xMm5
	Wzgd9V02g4bUfjyqvVubJDZkrfSW/7U=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4853b5b0fafso56343395e9.3
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 05:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773663254; x=1774268054; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M7q2+A+kkZoyV3rsZQKFhC6jq2dbqO9RaZzFL/EKyo0=;
        b=aw1wXuoYZD0zG+9RAbNTJWTr0fpA5W8a+Qtw7Emuv5qQ/ykKV27A7ZDCtsU+lwJ+0P
         0fLTtIYCshqNRuY22wMIlgbu97HZxmBMJEYwE6uP9A34Zhw9CEj9e5YpmV9mEgRJfUrY
         pMuUEMTXdC8FOm/Fm7HAFmQZhWoLxsCgD8dTPVfyTBx2BQOIzI/2KQvUO8igBYC1yuFc
         /AP185bWT94zHWPJBobCXIb5RImbfWAMtFXvnedGYuv8dvuvHQclznR7xlyaP+jqPr3o
         XfA2+9YWXBjJvtxToqI7hT8ukIrh4jmg+iZGigyzhRkXcG4ioPxQ1Vo4bSUMHYA2N+cr
         9i/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773663254; x=1774268054;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M7q2+A+kkZoyV3rsZQKFhC6jq2dbqO9RaZzFL/EKyo0=;
        b=KYMZ7RrWAgvWgrMA1l+6oELoq+yeBFDVN8Te0PjBofJxWmZoPHO0Z3DR61F5At6K0x
         EoB0bBTTGpSzKVEFsLqWVAgIB5u4lm20mOmYKDcjspU5lawvX9sG/Gksif/r719nQYjm
         FCT9rLLPgeGJTWMzoKRQCrmFgH2uKzQVC9G59Y892DxjrumgYU0jv3Qs47cDpXudMYGq
         jE1iwciMcMPkIcCiN2qGry2rAIWJP6KxoWu2xUJEdDuDexr2J+/4WTsxIq2AnyOWqo7b
         AF45sISNJfQ2FgRyUd8cHVk1vS4iz9gI5FlQln9YIyUn+0yCSj7dbljzxjUaG2M+aHEs
         vvqA==
X-Forwarded-Encrypted: i=1; AJvYcCX+vQV2xOMtB5AcXSfOirsr10m4v4qV6zGH1fn5trjrnN7Zjrh2mxeoeMMksHwInv7L+gcTohjL+g==@kvack.org
X-Gm-Message-State: AOJu0Yx86IeBRkU/XRX4JQ+XRoCBzdsIb1iEnawaiF7qQue6fa2kld3Y
	dC4dYuXCyK/YdZqU9VipkqD0DpoRZPB5Y0DtneB7Vh9dOzsmymHW6qa1g1k9mtMJH6w2v1W+pHw
	qJscIQ50pL6pXCGTEVg==
X-Received: from wrs7.prod.google.com ([2002:a05:6000:647:b0:439:f5a6:f90f])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:45d5:b0:485:3ff1:d5c3 with SMTP id 5b1f17b1804b1-485566cfa3cmr204531455e9.5.1773663253523;
 Mon, 16 Mar 2026 05:14:13 -0700 (PDT)
Date: Mon, 16 Mar 2026 12:14:12 +0000
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-28-de9a7af4b469@kernel.org>
Mime-Version: 1.0
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org> <20260216-rnull-v6-19-rc5-send-v1-28-de9a7af4b469@kernel.org>
Message-ID: <abf0FHWkQzbnOtqD@google.com>
Subject: Re: [PATCH 28/79] block: rnull: add partial I/O support for bad blocks
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
X-Rspamd-Queue-Id: 7652420002
X-Rspamd-Server: rspam07
X-Stat-Signature: nf1m414r8t1npik3binarirbx5kwahif
X-Rspam-User: 
X-HE-Tag: 1773663255-831926
X-HE-Meta: U2FsdGVkX194Yz6WBUWgpEZd3NOcASyY2UTTHvBeYmutd2Uo0UwJ6ftRCSl+pNAr23a28il/V3ekhv39mXwdpu+UB8HiiSffRwBEvbl+H+qekqcIDlczekq5ll806cQAwmQOW4rNLjTVTu5VO0zN5BsB4daRslaQNyUY6fk9UeiT+CHzLV0rhz/BacsrREmhe+jz7NysZMJs8wY9yyNkKYprcyb8m6wdtzp/FOxdFcsVvNFD9erMNsuwMwKWo7NFV79TfRJtW5frOWU6WSRSJTI/sxn//iJ4fl+mg4tRZbkONquqEsgaefosbIQcX7qd3DMWzp/Du7oSTvOhSe6td+mA+sdvVnYgfoTILzcY5YLvDKkq+79L3EHmf5oektURSnsCIxBCeE0Vl1ptW53uaV9l8bX4JLXtpfSf2KkFUJOnhTrX7fh0iqcxciqp3Fxmxj1Y5qOy2xPAXq6UlLZCY1gJIhy7+O4zZi8Jsu9pzQFBiBFpDmuw+o3esrO0Am2+47LHHfvPgXZj3oDzdu7ZUxycsXwEn4xwu0kkpmk0WdyEXwR5pS6+Q6cr3ZJaA9694NJ1+99AjlNcmUY8AlqahBwMTbx0fxHPqqP633jlYguOXiYEEtZV1mLcKfTQUwJ0x25Zk/VpKR1KkOJ3NYSTSfs5xVplhMf3BA9TgwDmL6+mxzmf8a4R1YOYcRwS6u/PLuFhw5LLDbwFYrHEG2CMVgtiylwEvZSz7kkM8nZui5PjUvZPGXnQnJutIm4HIa7BYUG87ypdOO7XV37bfSmqg5T3NUl+ibu1KgXJvXB8vIpVy0XEOG/fT471tRhJI84YOGvlvvGp9vPT0AgMI4cHECfe7ke883Rp2a65XoMB3nK+BfPXtkJDfG5L/7lw4H3pURQM8gTm/f5mYbdRjKPFK7aw86K9ewJgXZfPdL6PdReusF/8PAPN5vCSz87ZeRyZI4H4TCXobY7AAmWGSa8
 3C9WsB9I
 Rv/GLBe3qgVOytJKetV6THGmFg8MJOfPDRRAbh4XgAYZxXmP04YZT+kPUyju3A43fKOSqj+OdG0h/IP0YyHwB1tSwhohxzocSYdIhoXE+s0p15kynJ6GG/qDSI67sQUQIb/KYuEBSELw0D1VF6oLGtfS/rySjqW4JCIZT/ci6J3bC6oyBZXqFOH4Vje2D7mPPrQRAzfD+haVYg8AXHcOPJ3vnRBBI+AfZiO3ZeOUoYBy4gBPXWxWewKEmrJ0w6eM73lplbkr0IDZngb/ys4pLcBrjx1sN0emlRgpGH9iaNu2RGyeOstypG2Fi+qVcLDknbtQxgsu4LJ9woZDlEk4qfRN49Nwh+w1jewppIJbnu7aY1CTx00dhSlBEaSYQNXXIsRdQZrGAR6/yGOHy0chUZfGD8xji5b7XbvT5Ft3P46k46zodAVPKAchLASCe8FLRYv/lZ07G8HLA7r+HPnmdUm2dHYEL3VvtOySYa/RZsyu8g15puXlTyHgldS6NNjNP4tQPpibmONHUgaT3EROegGFdNo2cEgyZbUOMN6oifCacMD6GzsgmfFMlrdO8fii1uTolwuIf/XcHo8Wm6TJKvp/s0VxGb/8nZjsgcKPxRhjjJWIBoSF4XTjkNANILKPsT24PFCyH0SdOQoJ+G0XUKRwkwge+d8ekVXkHOD+m9RwMD0BFaU0M6nidkU8CK2qiWXqEmwJHUdu4RvJaLSRzSu19c8wCt8eiBZqk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 12:35:15AM +0100, Andreas Hindborg wrote:
> Add bad_blocks_partial_io configuration option that allows partial I/O
> completion when encountering bad blocks, rather than failing the entire
> request.
> 
> When enabled, requests are truncated to stop before the first bad block
> range, allowing the valid portion to be processed successfully. This
> improves compatibility with applications that can handle partial
> reads/writes.
> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

> -#[vtable]
> -impl configfs::AttributeOperations<13> for DeviceConfig {
> -    type Data = DeviceConfig;
> -
> -    fn show(this: &DeviceConfig, page: &mut [u8; PAGE_SIZE]) -> Result<usize> {
> -        let mut writer = kernel::str::Formatter::new(page);
> -
> -        if this.data.lock().bad_blocks_once {
> -            writer.write_str("1\n")?;
> -        } else {
> -            writer.write_str("0\n")?;
> -        }
> -
> -        Ok(writer.bytes_written())
> -    }
> -
> -    fn store(this: &DeviceConfig, page: &[u8]) -> Result {
> -        if this.data.lock().powered {
> -            return Err(EBUSY);
> -        }
> -
> -        this.data.lock().bad_blocks_once = kstrtobool_bytes(page)?;
> -
> -        Ok(())
> -    }
> -}
> +configfs_simple_bool_field!(DeviceConfig, 13, bad_blocks_once);

Squash this into previous patch.

> +fn is_power_of_two<T>(value: T) -> bool
> +where
> +    T: core::ops::Sub<T, Output = T>,
> +    T: core::ops::BitAnd<Output = T>,
> +    T: core::cmp::PartialOrd<T>,
> +    T: Copy,
> +    T: From<u8>,
> +{
> +    (value > 0u8.into()) && (value & (value - 1u8.into())) == 0u8.into()
> +}

This is in the standard library.

> +fn align_down<T>(value: T, to: T) -> T
> +where
> +    T: core::ops::Sub<T, Output = T>,
> +    T: core::ops::Not<Output = T>,
> +    T: core::ops::BitAnd<Output = T>,
> +    T: core::cmp::PartialOrd<T>,
> +    T: Copy,
> +    T: From<u8>,
> +{
> +    debug_assert!(is_power_of_two(to));
> +    value & !(to - 1u8.into())
> +}

Overlap with:
https://lore.kernel.org/rust-for-linux/20260221020952.412352-22-jhubbard@nvidia.com/

Alice

