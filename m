Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93F75CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 14:07:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBDA98E0002; Wed,  3 Sep 2025 10:07:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6F228E0001; Wed,  3 Sep 2025 10:07:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5D048E0002; Wed,  3 Sep 2025 10:07:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 91E4E8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:07:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 43EC2119BCE
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 14:07:50 +0000 (UTC)
X-FDA: 83848117500.04.E24BF86
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf15.hostedemail.com (Postfix) with ESMTP id 64D61A0017
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 14:07:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=t1gTxbwy;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of glider@google.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756908468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5K9EI/c+PZFvJEHF5Aa1VFvLskC+dFsbaSIMq7wWgXc=;
	b=H7aWeJWqpufUffK5JQY7JdqMZXFcam9pT1ilzT/Kxo/SCClSOaME4mDn5OvIHwGn1MtZkO
	o1Mu+Qi1Xp9C/Ipa6UMWpbazQDSzbKb25JbwcYt2mMxDeTonS52ZgPgy8w5LCqsxwREBkt
	3bcfaVK2bR7wGdAfqnRjSgWk7gm8t8w=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=t1gTxbwy;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of glider@google.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756908468; a=rsa-sha256;
	cv=none;
	b=5UqbHEDZ40l3LTJCAyyHPNgElP4+IG9/Ve5mTSu/MZ8FjPj+tYwbAkOmfCct0aDkOLreCp
	sFcnrr/wj5BGRtV4+JWluB6kSZD8Ka7K/Emt5UNBhLCuBFcKGDCtxcjdKMRRtqCbRaMrOS
	XaBJxWZSABIavNuJdg8rMzfFJz2lszc=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b4755f37c3eso5714464a12.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 07:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756908467; x=1757513267; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5K9EI/c+PZFvJEHF5Aa1VFvLskC+dFsbaSIMq7wWgXc=;
        b=t1gTxbwyTTteEx0sPmymEVVkuCPO9cQOyASWl3F8F4hkIk4ZUCN2Y6fjzm0VgdDXKU
         vw2yntcqhFuT/TtrsvrfQ8K5v3INCA+ScTBAn4zXHSFDr0LO5+npKV93w3DXuyNl5vbt
         A/wd0vHg14+MBimQdcEjl3IIZZSZMr/g/tS42kB72avbWbzw8bPgh6k3xE6+qn9RV9U2
         DVVwATrU3RSF6k4VWpisKzO7IxfG6Ovst6QzNhfzYBqI2L8bKJD+pxww8S9LwbknMbjw
         BTG4IkKpdo4eLmeGcfbsOeEWbvxZ33y2dAh6K+WS73NKH0OIK1/PIPVSdqohvFnmRold
         90hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756908467; x=1757513267;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5K9EI/c+PZFvJEHF5Aa1VFvLskC+dFsbaSIMq7wWgXc=;
        b=qDMtP+iXDuFwfxSrEe0A3Hsn5nj+PTQBRtj/dUvPkIRIOyKJYVU5m9IXb0B/+ACxGY
         so/4DIzvPvbD6n1KE9I8FdynoDWimbskmu1IdULbR7AXC+pbukhvWcazktDzqScOKdzG
         4YTpaEffih3+KPbAM3eTILlWLg3kSe9Bg7IXf0n+caZrFWWpCJYpUrXClmAPATUmyygO
         V7TEsN4KWrpsaCDXnkhP+dg0isZjWyi16FQ71ANuBmky6ZVIC+xckMj7XCCWSpTv5EOt
         6nLEWMNvUkb0TzChh7tmULAnwKU4g6u2RTkOtQt54PlTM3bqG3afw6L563Tb1I8p4jPf
         wMHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXevo8uXYm9V3zD+Vovd/QbZLbbDZgUTmiXjNEniDjX8326HQMYMINFy6e0+K8ElyPvlo8i8/LzPw==@kvack.org
X-Gm-Message-State: AOJu0Yzlr6xHrUK5gU8Nqf+7lvpKp4/FidRWf+2F9Zrs7cZEqNZrcUYT
	FcVM1DXSNdVL1Wf6RLWLEeIKt793ktQe7sjMqDKzA9uQ2189uldZ6uwEOGMS0NBVBIY9JMchAAr
	LDQ2709KD0xOTBtUQ/ANTFjOjAD3xufOXpUtTVp03
X-Gm-Gg: ASbGncusNqTmb6hX+K3xcHw7eZlFzba8/6E99B4or1quOLvJdFxpMPvlUByAFys4J4R
	eVjOhPKSQbvwXmM49XvUkkwWqsFy32xEy432ugkM52ROeK2F7cftelGg1ZHfIFFHqKn3xmA2T8/
	QA9FOhCyqxUALPhV3CicDSOYTQjP3ZG5kOMZ/wqGntcZSiL3g5PZmNHzG7MWIHWfM3Skr81/a9/
	nn83TB67UQ/A6XhIWCnZz3Z8fR9kR3PoUNbFiRaoKht+w5PVFFLZg==
X-Google-Smtp-Source: AGHT+IFuhXZJrFj9HYn4+7oas4LyVhrv+Mi5Jn59BmW6xsC0VtOu4EqtvC/C0bP5fykXZiH8qLFls+MaLNs5naVgZ74=
X-Received: by 2002:a17:90b:2888:b0:327:ad83:6ce6 with SMTP id
 98e67ed59e1d1-328156bab71mr18212350a91.21.1756908466847; Wed, 03 Sep 2025
 07:07:46 -0700 (PDT)
MIME-Version: 1.0
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com> <20250901164212.460229-5-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250901164212.460229-5-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 3 Sep 2025 16:07:09 +0200
X-Gm-Features: Ac12FXz0U-3N7wPl6bYh7KGL8GiZ-rYE3Roev_WD4ikilRDTuvPr9ZMXra7VBOo
Message-ID: <CAG_fn=XxRoZJtxKJrLGTTV42H7gDMFEaQZiYQ+nFgmhexzgW9Q@mail.gmail.com>
Subject: Re: [PATCH v2 RFC 4/7] tools: add kfuzztest-bridge utility
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, brendan.higgins@linux.dev, 
	davidgow@google.com, dvyukov@google.com, jannh@google.com, elver@google.com, 
	rmoar@google.com, shuah@kernel.org, tarasmadan@google.com, 
	kasan-dev@googlegroups.com, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, dhowells@redhat.com, 
	lukas@wunner.de, ignat@cloudflare.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 64D61A0017
X-Stat-Signature: agmra1oyjotuhisohy9sc7h48zymdx95
X-Rspam-User: 
X-HE-Tag: 1756908468-559808
X-HE-Meta: U2FsdGVkX1+clLSksXWehZrkpfj40KZnTkoEQ4RxY3pBDtlAxotEYTNF/jsrb7HP3plkOK73HSgFkr837jdECCtq0CLVwzWs/1oPIIi4kEPOW+uz3631BnwvYoNp02kjov5cBkkioA7W4qdLDduXFRWVRgeXcZYdo0hmZIRqfK6pOHWmj6KAngC8AZ8VG7Jm7A7KetFOWEAuj/PbPT0Tg4fim847uKzTTOxS0NWwo6MYA/TxdfuXUwody2yQdlco05yaGV2wlWpC2ISD16eNN9B+MYZiSW7yhmHPHMMANdLcksTqMVUoeGBmbD2rfueHPEWkw0u8j8wY1FVXO8fqm2vP5rCp7G+civT5V7CRCCZa5uSQxfVsedzBb/UgxcZmX/abn69bL6yO8ztwLappRMsTGYdkP/sdX+SjLTIcQvGBpFyQl9jGxukQv9YlN8zfwWAMbFh1PQOKqFIRz8ThVzBekqLQY3qU4x6KZzS0PgCAafxU7Mb+5Jq1t85hfZSuIpFYFAD+IpwY9W8J9ReTpEgZygvcwdV/yNmOhJw7qjDxg5Lp6O+BXsdpnT7Xq4MRROCYnM4m4kPho4IYfmODuKmu3Z9cApehXnEoodTS3cRzQKFkSExMj36uS1dqbKpoikQ93QRV0RUs5RFKYWSjiAgi1KUE9arWhsRNpi2ZQ6A4187tE/Y0/U7UDF+mauabBD+XRjcjvRfA8gYvIkrUV1OSLsuTOtnm6zJKSI8JkM2GS/kqRad/wXYjGYYveM4rUIrkDeMNguofTL8jIgkAmTtwRHlhxTMdkX4PyUMXiTGx7JbkVY+ioqpzLAgLONlMN3GQx42KuTMUMWKQj5GMCuGA67CdvXSp1FrlRkROLIs3f99JBE4v5jyymRf8Z3sKjrNP5QaeLVg8+x2KZjdZUCWVIrV2nzmonxxnplRQU6bk36dVoPV15l8g/lKiJesRCiBavyrDpYBjhnryWgh
 xFH7SZbp
 Q2sfEOuPhRdcT8wYcd9z34ggsH11RqDU8AhLrjjWd8E5+vQ9c3kHennFwEDGXI2N15vlqMa1OF4niE1y/Nrt5MhCNJ/tGGPUmIgFaIIcfB6edBxU0xuAF1NP6vgvvSsGMG9LK2Ce5Gc6Yyuy6+eIHMPV7C218hsZT654HsO6MGhonY7d5s509P2MJQ8/K4WXBkBZGGWmRGAmVnfRiFGgTHZT0nYHTrfFr4oZ55z1Di4uUY07/KiSrSOnsN4roMCeQZhCG0e0i4nPPNlo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +       fd = openat(AT_FDCWD, buf, O_WRONLY, 0);
> +       if (fd < 0)
> +               return fd;
> +
> +       bytes_written = write(fd, (void *)data, data_size);

We need a check for bytes_written == data_size here.
There's no way we can use a while-loop to ensure everything was
written (because the debugfs handler expects us to write the whole
packet at once), but at least a sanity check won't hurt.

> +       err = tokenize(input_fmt, &tokens, &num_tokens);
> +       if (err) {
> +               printf("tokenization failed: %s\n", strerror(-err));
> +               return err;
> +       }

I would probably make tokenization part of parse(), but that's up to you.

> +
> +       err = parse(tokens, num_tokens, &ast_prog);
> +       if (err) {
> +               printf("parsing failed: %s\n", strerror(-err));
> +               return err;
> +       }
> +
> +       rs = new_rand_stream(input_filepath, 1024);

You probably need to destroy this stream after use, like you destroy the buffer.
Same for the tokens.

> +
> +int append_bytes(struct byte_buffer *buf, const char *bytes, size_t num_bytes)
> +{
> +       size_t req_size;
> +       size_t new_size;
> +       char *new_ptr;
> +
> +       req_size = buf->num_bytes + num_bytes;
> +       new_size = buf->alloc_size;
> +
> +       while (req_size > new_size)
> +               new_size *= 2;
> +       if (new_size != buf->alloc_size) {
> +               new_ptr = realloc(buf->buffer, new_size);
> +               if (!buf->buffer)

You should be checking for !new_ptr here.

> +
> +static bool is_alpha(char c)
> +{
> +       return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z');
> +}
> +
> +static bool is_whitespace(char c)
> +{
> +       switch (c) {
> +       case ' ':
> +       case '\r':
> +       case '\t':
> +       case '\n':
> +               return true;
> +       default:
> +               return false;
> +       }
> +}
> +
> +static void skip_whitespace(struct lexer *l)
> +{
> +       for (;;) {
> +               if (is_whitespace(peek(l))) {
> +                       advance(l);
> +               } else {
> +                       return;
> +               }
> +       }
> +}

while (is_whitespace(peek(l))) {
    advance(l);
}

> --- /dev/null
> +++ b/tools/kfuzztest-bridge/input_parser.c
> @@ -0,0 +1,373 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Parser for KFuzzTest textual input format

Some description of the format would be useful here.

> + *
> + * Copyright 2025 Google LLC
> + */
> +#include <asm-generic/errno-base.h>
> +#include <stdio.h>
> +#include <string.h>
> +
> +#include "input_lexer.h"
> +#include "input_parser.h"
> +
> +#define MAX(a, b) ((a) > (b) ? (a) : (b))
> +
> +static struct token *peek(struct parser *p)
> +{
> +       return p->tokens[p->curr_token];
> +}
> +
> +static struct token *advance(struct parser *p)
> +{
> +       struct token *tok = peek(p);
> +       p->curr_token++;
> +       return tok;
> +}

It would be nice to check for p->token_count here.

> +       region->num_members = 0;
> +       while (!match(p, TOKEN_RBRACE)) {
> +               err = parse_type(p, &node);
> +               if (err)
> +                       goto fail;
> +               region->members = realloc(region->members, ++region->num_members * sizeof(struct ast_node *));

Missing a NULL check here.

