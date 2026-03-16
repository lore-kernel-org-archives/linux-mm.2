Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AA28F4644A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 10:54:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7EB16B019C; Mon, 16 Mar 2026 06:54:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5FFC6B019E; Mon, 16 Mar 2026 06:54:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6C4B6B019F; Mon, 16 Mar 2026 06:54:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B11D46B019C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:54:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7838456081
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:54:37 +0000 (UTC)
X-FDA: 84551617794.19.5EC3D81
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf04.hostedemail.com (Postfix) with ESMTP id B8EC84000C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:54:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="NJC1eS/t";
	spf=pass (imf04.hostedemail.com: domain of 3aeG3aQkKCGA8JGACPWFJEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--aliceryhl.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3aeG3aQkKCGA8JGACPWFJEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773658475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q/+9kuHNGmF6mJHiC+r6rqWEh7NXnQhAjyYAhKBwFD4=;
	b=XwqzM9TMtQhhUYWsmeeXjajcGYNL6FYaWulv3XEeXYcZcQftCHeJv0Ga39CYvQkoZ54NRX
	2nd15HLr7ROxa/TRWPsSWnmAcwsCqJoP6pd63ad3ZndA7dVW5n5+ZMNVK68k7nUgbCd3EY
	mGZKnACN/5Jn6AeuStIxUVTyt5549og=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="NJC1eS/t";
	spf=pass (imf04.hostedemail.com: domain of 3aeG3aQkKCGA8JGACPWFJEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--aliceryhl.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3aeG3aQkKCGA8JGACPWFJEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773658475; a=rsa-sha256;
	cv=none;
	b=IzEDwV7Om8YHpA1esMNgfnkV4i0uNgpK87RJfJGJr5H/hrmHsYG5PtAydNaPaSYIg33h+1
	Pk44Olt6eT08aLVsRTZtxD07gH2KexE2n9qVMWoBHJG63I/jy9edapaTgHEUdwtAoloUXQ
	DBGnwCz92Yi3lBBtX++BcD7rANZ+zWw=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-439cbc5fd75so2837391f8f.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773658474; x=1774263274; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=q/+9kuHNGmF6mJHiC+r6rqWEh7NXnQhAjyYAhKBwFD4=;
        b=NJC1eS/tiJ1dyf5LEqSL6cmCMHGPdQsv085wlyBfTZl80u9GKCKdotI2RMIP+JogXB
         84gAgUhFMsVuYD/to7lSysZojwOguggOe4EUenLjz/MVT9ty2AZo4yDKp8vsZubAwzL1
         j5mgVlHJrcn7OQGvGDcA2zv4aasYyL8rVLt+PWUmJSE/Z2Ss25RXNp56JWysb/O7kyYn
         HDwssasLc+WzD95mTKvfkLoTYr4vRzh86p7+m3a0jTt2VGWFcCpycUFs57Ig8tlq5/vG
         hK9WCGuz9KK32EN0TE1dGxCHrOTEu+/EfZl6ZoDh2SFl8grDIjhEwBxyFrxN/Hw+cNqB
         XtEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773658474; x=1774263274;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q/+9kuHNGmF6mJHiC+r6rqWEh7NXnQhAjyYAhKBwFD4=;
        b=nH6KQi0b7Q6XYb8uha19JWYL05qiKLyXnPdenfC6LB6/8nOTo7pTWZg7fqHVb7NfYJ
         25MN5UT3A5t7k6CCJ8GVRbbQk9V8atXFy9Uhm8kXVsPxh30qlnYDZW8Jdcyil54fWIlE
         ObPPC3EVXoBXZ7d9AjJlXXbxWzzWgubEktO7uVV2VTdPnpRiZTHTUil3Z5Pb7ybSQxxk
         7r6no+YlSkgZd/P4T0KGk1TxD+Eu+kg0PqJHloOF0BfYQmeGz8IzShzf/m9hn5HYJo+C
         Tj/IcYQYiK+KZzsKNhK5TbAm63mAQ3gyGWt3EA4Dka/mARh4rKy6xnjsYkz8rSSrUFx4
         hu1w==
X-Forwarded-Encrypted: i=1; AJvYcCXmgVmvmGwYwuz0i8mJsVMafNAt0cExHJvPzsAtC4xLy2hLofYg/YVjdijh2Re+wUrVmm4e/xenaA==@kvack.org
X-Gm-Message-State: AOJu0YxrPDvmlFnP6txxgyKUwc4jniHr8Y36C8F2JePeBx4eaWdr7ivr
	to0zGgnNh2HSOcb903BuMTE9kopZRtd5UQ0VORmnaXnv3/httrb51k+jNMn1kqldPA+9y3e1KHL
	bXpHemqz8I711r23Hmg==
X-Received: from wrbee14.prod.google.com ([2002:a05:6000:210e:b0:43a:397:db8a])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:adf:fd4f:0:b0:43b:3bed:154b with SMTP id ffacd0b85a97d-43b3bed1827mr7373388f8f.40.1773658473980;
 Mon, 16 Mar 2026 03:54:33 -0700 (PDT)
Date: Mon, 16 Mar 2026 10:54:32 +0000
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-22-de9a7af4b469@kernel.org>
Mime-Version: 1.0
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org> <20260216-rnull-v6-19-rc5-send-v1-22-de9a7af4b469@kernel.org>
Message-ID: <abfhaH_aOBHijWGe@google.com>
Subject: Re: [PATCH 22/79] block: rnull: add no_sched module parameter and
 configfs attribute
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
X-Rspamd-Queue-Id: B8EC84000C
X-Stat-Signature: 6xgchutn64g3m5pq5koq7x46tyizrwfz
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773658475-582215
X-HE-Meta: U2FsdGVkX18q6Q7WlXzR2aX7Oqz1O9iUtgdvbBb5KRiC/BEIV2yczW11X8POa6HKsQaNvteRDmVQi+CH9X+oo7EHCscMQAWgkKuZKBv6ANGhIjkjS5AjXOsN6u/moH56CVUet/QzkNLSRq9yB6h+7upLkgl95yoteM3O9MsyV76v1r0QNq2+J1M80GJOp2tT2/H4+ktkaogxvPfRTn13bixzdE+QrTmd37qojaY9h5JZ4oWMEDzkte0+ky/Z54KQuCdAmNfxXNegZamr5RVp6qruvNW7xj7lD0JcElx6xoCSBPL1swxj5vvFUpyR7OLWEaXysO6o7ih5rW8mjPv+M4AqyupqZOSIfBWAi/s//5tc+p0snfOAw5Nw+0gm3gH6nFLHlXbpY2k/ZzIMY9s0ivEb6XdBGrOZBD0MUTIrc5d3wQriaXn9E2/ItHxgVyjnjxmsd6E599iM8irPf+wz1WASwrCtdkoBX7iAqtceo60bnj67TkHs8KQJWGpLzb2xf7utjPBmXcy3/nUpHVzXFTWvqOuVvddr6iwLWvUwTsLtilBaUawjju+kEtiaxpmsmdCq7L7tl/IMmaIs19wir4tFohfSdiNEOk/6e+RcmwH1+YFQmXbGWk2AkItPPml2rGbbT/oGB3+fvqjgu9UkgajSV8geYm9IbFqNsp7yiK3/mO7YVMANqnYyuINNkoY8AL/xKfZm1SA5RKOIgIGAp9qiOIbmW9uhpf88e+Tj916SvyOfM0lSy/mIQt2NgIRGzyv9QM1ZATEEvWpn29/QWnD5+0BzAn+YiBCML0nugycbvF2OUXVhJSEcR+M8WkCU0TYsFSe385QehcA59tXnsMBi7P6zKDRwAhJnoHi/nVz+xWCweIUoDJnunv73doevLZVjmaZoCN1JYo4XdJnKkQOFyrs+wkKk6iYZGdf/X/6s587R/RdKb8AKw6CAdTR4Q8VH6d4G8ktFOvDb7r3
 C0WKAavz
 JKvOCpAwsh+6Eek9Zg+erQtPoac0KNnwEwDmLyvyuFkfMFGOjoImjfsfnT5jgOytlLz2+DRYNhG4Q87s13XV533xLQfWx83DdR6zu4ORa+399EAuhtXlPxNvqOPT7wjj4oVsEoUawHvicaWGIjj34iq5WflsDM3XGeWOOxr0AcsEqBDFGskkeZUGXdYc55WW7CtHcFiYB2C0+yKr68lmwM3tfcmkeBvOZEKd97W8WxRbAebwgzuIIBD6nPjGsnk/aF96Gkx3tTeYRNyGPDPCVXM/1w1VZtguw7dk2fkmg+Qc4A6sMkX6aRrGzN4f3mZglq5JovkNxzt0aRsLMFFOezBEPJzzMZbU0iKCJlafmGZ2EBAh3/Dm+NPGf/3OWXK1FCg/ETjnotXObxKCqJpRWjz8mTFCRtcFeGfaCjZgDf22+ocwTy7WUuHRiZ8j1FDc/k8q9Bp7nDbqktCVMEk7tRLL1qDl2DcUbTJMhmct68JmSZgJ2plVMJfmnfxAkb9GYtsUMP0kKpB4rgwqE0t5UYsmdlAdN6ztp6rOg/yTL3HLcaj6/I5GVuP9+C/JV0voMjxodsWvaK9GNTafLWCcuIf276iGXOEMGJWMylndYlqfOln8kbwlDfMVtIy9FYWgvnDjnFwaBbSAj1ng1jfkKKcbza+hAg9IBIYaHg+bK66gI43awlE9t9pj3deE6dSNJhGIsDJxqvV0B/NFoEL7Z5w0mcGeOYQIvi3MHOiAevRbq7xycwPzOlzjuK65cu07Zhe5h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 12:35:09AM +0100, Andreas Hindborg wrote:
> Add support for disabling the default IO scheduler by adding:
> - no_sched module parameter to control scheduler selection at device
>   creation.
> - no_sched configfs attribute (ID 11) for runtime configuration.
> - Use of NO_DEFAULT_SCHEDULER flag when no_sched is enabled.
> 
> This allows bypassing the default 'mq-deadline' scheduler and using 'none'
> instead, which can improve performance for certain workloads. The flag
> selection logic is updated to use compound assignment operators for better
> readability.
> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

> +#[vtable]
> +impl configfs::AttributeOperations<11> for DeviceConfig {
> +    type Data = DeviceConfig;
> +
> +    fn show(this: &DeviceConfig, page: &mut [u8; PAGE_SIZE]) -> Result<usize> {
> +        let mut writer = kernel::str::Formatter::new(page);
> +
> +        if this.data.lock().no_sched {
> +            writer.write_str("1\n")?;
> +        } else {
> +            writer.write_str("0\n")?;
> +        }
> +
> +        Ok(writer.bytes_written())
> +    }
> +
> +    fn store(this: &DeviceConfig, page: &[u8]) -> Result {
> +        if this.data.lock().powered {
> +            return Err(EBUSY);
> +        }
> +
> +        this.data.lock().no_sched = kstrtobool_bytes(page)?;
> +
> +        Ok(())
> +    }

Not using your fancy macro. Also, TOCTOU.

Alice

