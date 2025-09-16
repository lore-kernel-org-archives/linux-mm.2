Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9789CAC59B
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 13:43:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 378D38E0008; Tue, 16 Sep 2025 09:43:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 350978E0001; Tue, 16 Sep 2025 09:43:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 266828E0008; Tue, 16 Sep 2025 09:43:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 131F48E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:43:37 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 97D0F1401CE
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 13:43:36 +0000 (UTC)
X-FDA: 83895230832.14.BBA5586
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id B98E920009
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 13:43:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ztTm6n9v;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of glider@google.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758030214; a=rsa-sha256;
	cv=none;
	b=Auvc0vEYBmZoGURFJiQxG44Dx6hh4fQwZf6+yC8AsYvctud1i/Mzt6NCXl6CCtnS5qoVNc
	Sg1XS3hNtt64IuW1kO/+XFo5YLMTvki82u+G88HeXB2jR+cpuWY9pHn9gQ5hMhyZmCPRPL
	o0UY2PlHTDL1i5GDtkslElPOi6TN1Kk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ztTm6n9v;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of glider@google.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758030214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WFMguP23bZIISRu8P8L8i4YMMkZ2fq1VcnZsxEVckmk=;
	b=1c8X/9Tl02jaQu7D7AhxoCHOWuPPRxus3xf+LNn+WbNvbNN8KqBYOTbREpn2WGnXDmn7a8
	pHYEeFeZ64Y8B6Gqm0+EaMs1brH8MwcYj0v+rjYJRdMU8ZQxROsA5JV6irr76qPI4cPxNV
	7zqp07SiSVsNDLXvJL+dkyHpgDVKpDw=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-78cce797cc2so7338116d6.2
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 06:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758030214; x=1758635014; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WFMguP23bZIISRu8P8L8i4YMMkZ2fq1VcnZsxEVckmk=;
        b=ztTm6n9v4KcH1XIN9awCvkr2FFtw9rwCBZ/w+3hDvYLzeGU/l/VqeAJeELKCj9XtTH
         OM9FwxDCUELfzCgigG0JM3JsVL/pKYtXexE1Ln97MEauhCs5D0zwsKwZyHrWlor966m8
         N1CQil+0tRnsXFBM54ac26rBCAH/Pn+U4V53wXwjh7dQlrMeho4hVN0X6LRJ05wwFnxq
         69wCdzYQvjfVEdeNv8uGhZSE+Dy1aqlrsD3WroDzAFw6+qPKehY9+sCXo/PbIHSbCZ24
         eMRQx8j7wTDKHJas2V3P6LFNlu2qRHpZUhE8tOoik2JVyMKiygHCAGxKaK0f4AirtE9A
         4axA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758030214; x=1758635014;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WFMguP23bZIISRu8P8L8i4YMMkZ2fq1VcnZsxEVckmk=;
        b=rxSUzEbdUK0gR/wFhrbMMw5vSDZqOmjHy6a3Qhp2gZSTUMaKJrwyep1iUsMmu4gwWD
         l5ntzG2+2XtTUfnssC6SfGVK2c/qGQkVtyVcsYTJCBg/AikVYEw6cgMNMdXTeBWsIFLN
         eqnj/SlrcNEtSYA2fwcVN6/2GyjXjZZPvL2Z7WQ5QCCPeS4XD0Qw9umE0Huy04xtm5AJ
         A4C7HtzcbNaZisvNPkEmvOpeiGe+E/BFKJIN6YJhKvipS66xF6D1CMj7z06TvveBFZd9
         fDY7c5cnPvBagRg8mDFElxIWUcm7R5HE5U6EyVEPFwXdhE5NwroTpG4P280HQJ5g5Wgr
         i+zQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZZJ0HX+r/9DJ3hbrKSYRMzR916DQljdlsjelYuXc7xWST6TOl10YwXBpZnYhUwD7pXxLhsL+aBw==@kvack.org
X-Gm-Message-State: AOJu0Yzd6SGVAUvC5UygV6JurXSBlnYLooQ9x/Q7ZxTB0Aa71LaF94KQ
	QL7dSpiW5auGvpZZy3b8gJCAuzdJ3FMFkKt5cUAhR3E+IY9O5YX+5+H77QZ6rlAknayUFKApDBc
	g4LtUWxRRWRAJbjJ01sE5lMmNtMV2Na6sVGWive/3
X-Gm-Gg: ASbGncvPsKliX9E+ddBFvytg1JvCaI/ZIycaQyvsHL3RDpOGcOuu/wh+KDWbwtYiojf
	vidb/3j6EpZIl2UsiJZzDUYanIv4Uj0WEMZct0fqBkunzYq3La5sGtQoVXir0ZPEiJpIvzCXVLg
	JiC8WO0nG5WNomXXKzegCuPVHbLNY/19A64RC0dM9huYq2+rEC5IfM1Z3VCuPSOGsNNGrryMIU9
	xKXyfhvXpJKLFAqICr37GfPX6LTcCpzYAbI8WfVWe+6
X-Google-Smtp-Source: AGHT+IFhDI3DiXQjQ2M/pDauu4pj8WaE92jep/q+QEEg6eNCMk/WVoS5e7N/U3EzJP+zE2T6dly3yK42LO8dPZ3MnPk=
X-Received: by 2002:a05:6214:2624:b0:71c:53c0:5674 with SMTP id
 6a1803df08f44-767bb3b5cc7mr189377726d6.7.1758030212716; Tue, 16 Sep 2025
 06:43:32 -0700 (PDT)
MIME-Version: 1.0
References: <20250916090109.91132-1-ethan.w.s.graham@gmail.com> <20250916090109.91132-5-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250916090109.91132-5-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 16 Sep 2025 15:42:55 +0200
X-Gm-Features: AS18NWDFPFWnjGnn0Ya31_ptvZRyrk4s5Sg6fkIlAJtVA6vYI3uU8Zv2xeIdCLw
Message-ID: <CAG_fn=UJsV1ibxSf6D+QU4ds1mHUG77NWJ5TR3sVs3f696RgiA@mail.gmail.com>
Subject: Re: [PATCH v1 04/10] tools: add kfuzztest-bridge utility
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, andy@kernel.org, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com, 
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, shuah@kernel.org, 
	tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B98E920009
X-Stat-Signature: cd9b668ikwpge918wyxwmfuwp3n4z4ip
X-Rspam-User: 
X-HE-Tag: 1758030214-440061
X-HE-Meta: U2FsdGVkX1/CpZbsMYQIW3jHudBdMKn7MSgDKzbTIJkOqcTHC6Z7bV0yCI9I4zVY4Y15tfgvyon7nxQF4F0e+kT07c5zkJ4Xk0ao1Om0h7lR6Dlqi1n0kx84c/+YIVP0YTL28tudE3SDPBaeeTQlD/1dRSzIbRyM36DaEMLF884HPOusdpGr5g0pNfm2mcLpTbvxg3pt9MlsXka9OZVRu5JWdB5PCEL70LJwXTT0/sOOloAOh1+UloWFRExkZkX6UfdDeRsa+qV82nG5rMyfYU/r0B5CvofWyegjOgZScU/e70lDktQoXBpcn98nDGIW5Pt9tbu0kwwSEW5TEzWYxOCENW0zykwWpClr+G/7U3t5NIi/+uti2s9uOLuCl2R5drBwzi668rc9P7ZfsReTBKQtaVgjLqpCM5uL87tHgvcJ+7qywRk2xy7yb+GIwiRH8Wv92UJmvtrSRegwmW3M93IU/2Vxqk9dlRTIdw+oRobWh0FW3oOLJaO0FLaPMezXk9ARmKPARThLsQHSWA4eF7SdvsDeJUblsxINeZzR5S7l5p1mIv0w/+8PjCilRyQbJGVS52lsNY35OH5UJNEaoqETXGPRgJsB+kUe4rrpYUN2TdSELO8jTG3GtuvThxmUBjt6fr0FV/DQtEBST/9zzS6IvADlHcTWtHRusWHVaQhRRl8LwlEoBjGdw8Ixh7wDXkjY/wUs6lRuSfDF41rQQtuTtIgSvbbshQ0Ke4GVNNOrV2TXPIlFqWhPZ3XRCjjWUDjKgvREbPNeFH0RvtE49zMr9xXru6k1/dGujGRjg1nYC7TQNiS2l4wHoKKYfpqz2yyjQ8pOUaZIGuiECGIOVq9lzR+4h/WNyTAjjchzrzaxpNUe4P+SQzNIxg0+yD/Kf8PApRRz2fqHYDNbHk0wzf62Y+yxd5beRMnJXp6Mo06Zjd0JlP1ea5an6iGT033Zt1MMkO42j+NgP0PWZNF
 BFitz7Pn
 qMQufU6O5bUA3CRKZmB6gyRbj+b1kcAXnA9DGjL/GSTnh9xREvQkqKpk9K/boUCRii2wa/PaqoFYGexyPF1iwRV5uRvg+vKDIJpJHQucZDj/SQizn4HuqDMEyZLI3PXG+uozJKcs4Ho/S+WiePsPa81XSeLotpAdA2lVoNdYx1rP2Z5HAuzzb+1Sizv49V9XR4ZxKKGV7r2phRQ55TrG+mvIRE4v7F6QM2s6hvFVo33r7ynSscniD8VWFIdMGaFdRWVycvHsykADX1rA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> ---
> v3:

Please change the version number to something like "RFC v3" (here and
in other patches)


> +
> +static int invoke_one(const char *input_fmt, const char *fuzz_target, const char *input_filepath)
> +{
> +       struct ast_node *ast_prog;
> +       struct byte_buffer *bb;
> +       struct rand_stream *rs;
> +       struct token **tokens;
> +       size_t num_tokens;
> +       size_t num_bytes;
> +       int err;
> +
> +       err = tokenize(input_fmt, &tokens, &num_tokens);
> +       if (err) {
> +               fprintf(stderr, "tokenization failed: %s\n", strerror(-err));
> +               return err;
> +       }

You should be freeing `tokens` somewhere.

> +
> +       err = parse(tokens, num_tokens, &ast_prog);
> +       if (err) {
> +               fprintf(stderr, "parsing failed: %s\n", strerror(-err));
> +               return err;
> +       }
> +
> +       rs = new_rand_stream(input_filepath, 1024);

You need to bail out here if `rs` is NULL, otherwise encode() will crash.

> +       err = encode(ast_prog, rs, &num_bytes, &bb);

`ast_prog` also needs to be freed at the end of this function.

> +int main(int argc, char *argv[])
> +{
> +       if (argc != 4) {
> +               printf("Usage: %s <input-description> <fuzz-target-name> <input-file>\n", argv[0]);
> +               printf("For more detailed information see /Documentation/dev-tools/kfuzztest.rst\n");

This should be Documentation/dev-tools/kfuzztest.rst without the leading slash.

> +static int read_minalign(struct encoder_ctx *ctx)
> +{
> +       const char *minalign_file = "/sys/kernel/debug/kfuzztest/_config/minalign";
> +       char buffer[64 + 1];
> +       int count = 0;
> +       int ret = 0;
> +
> +       FILE *f = fopen(minalign_file, "r");
> +       if (!f)
> +               return -ENOENT;
> +
> +       while (fread(&buffer[count++], 1, 1, f) == 1)
> +               ;

What's the point of this loop, why can't you read sizeof(buffer)-1
bytes instead?
(note that the loop also does not validate the buffer size when reading).

> +       buffer[count] = '\0';
> +
> +       /*
> +        * atoi returns 0 on error. Since we expect a strictly positive
> +        * minalign value on all architectures, a return value of 0 represents
> +        * a failure.
> +        */
> +       ret = atoi(buffer);
> +       if (!ret) {
> +               fclose(f);
> +               return -EINVAL;
> +       }
> +       ctx->minalign = atoi(buffer);

Why are you calling atoi() twice?


> +       ret = malloc(sizeof(*ret));
> +       if (!ret)
> +               return -ENOMEM;
> +       ret->type = NODE_LENGTH;
> +       ret->data.length.length_of = strndup(len->data.identifier.start, len->data.identifier.length);

This strndup() call may fail.


> +       if (!consume(p, TOKEN_RBRACE, "expected '}'") || !consume(p, TOKEN_SEMICOLON, "expected ';'")) {
> +               err = -EINVAL;
> +               goto fail;
> +       }
> +
> +       ret->type = NODE_REGION;
> +       *node_ret = ret;
> +       return 0;
> +
> +fail:

parse_type() may allocate strings using strndup(), which also need to
be cleaned up here.

