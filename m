Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 000D1CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 15:06:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62370940007; Fri, 19 Sep 2025 11:06:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FA618E0019; Fri, 19 Sep 2025 11:06:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5383F940007; Fri, 19 Sep 2025 11:06:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 40CE98E0019
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 11:06:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EBFE8160721
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 15:06:12 +0000 (UTC)
X-FDA: 83906325384.21.33503B6
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5033514000E
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 15:06:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Hh6Ypu2l;
	spf=pass (imf23.hostedemail.com: domain of glider@google.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758294371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X2StnNKxKVl/rGS0fAgoxWZPalUwZSRkr2jKpUk0esc=;
	b=K6qtu/sOQYOFGnFqBHTFg70BQ5Nt8rZ2cQQu/kYoUB6tTcFYVEluBOZo1o7vdosshuhM7F
	m58IiOfqQ5/x9JoBpmIC+ZFfwTn/8kg6UYbRt1IW8Cz4owfUOkoAZcqeXpBpuJn1WTOO+/
	1DoOKt08M6UhAXNjaoaMm7icmZbrETs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Hh6Ypu2l;
	spf=pass (imf23.hostedemail.com: domain of glider@google.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758294371; a=rsa-sha256;
	cv=none;
	b=WIP7uVNovCI+M1BwwlaERAsII8rIw37KRaBRCUhBufrqVjfy1A/+IJbMlJXxeV40WjhNWX
	qZ6nDYlQlWBzLpx+dARHBEo1cBxafA9/2dmKxH/fdaNIpYl/iA318WktEohmUKrb4CnnjA
	CGMzldKTi510InFi89tAE3cTGPMrquc=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-796fe71deecso14802946d6.1
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 08:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758294370; x=1758899170; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X2StnNKxKVl/rGS0fAgoxWZPalUwZSRkr2jKpUk0esc=;
        b=Hh6Ypu2lba2SvsIdusyIAiaIIlMbwd0xeOtt6/0DBgu9ljdRqVE1o/4pajwvFGPZXy
         eQ67TAX7wNbvIg1aBoKUL0XzwKxpw7qwfFNanbJpnnECL/4+qPWYzaCSA+p0dCiVczag
         dDV3JQs0vEZomsc0r29vBGANeCKO/aGGFY6i9+m/W37JVCvN2dUb8oySICuhuzD9dPZb
         9XbHLgwh+EygmzPRXtmkFutNSjUKrdRLjVHYwgvbXe/Chf4Xccc9Mk05AKb4BgTzLPir
         9PcpbdJpCzKQ8oECSrFtwCZ2Or+EKecBLBq8LFTyTohwJthLvqdhmZFrJ/YzSc4Fqcme
         iYkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758294370; x=1758899170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X2StnNKxKVl/rGS0fAgoxWZPalUwZSRkr2jKpUk0esc=;
        b=qr0t/Cp1fycHZYCeAGoSDgR0Nq/Tuc6zfuoLaG9XBnWXGhhyP0X8AzJnYIUajixs70
         fwRUpoe7KxAHEz6gR0njLAgq6/h/NWyB6hE7ancwFUTSUmigivo2dLWlW3zK9UlH+iDW
         1ZsOQNDGConYKZQnL3gpmQmScgDXB4DvxPR3vM123/1au6NJKpCFu45cwXfIrbeAxYkJ
         CxPoZn3ZCfBVQStxuhSJYj4JywoCtOaaDv1Eiy9GlJLYnCqwLLIPSlEbmlUsPIcxSEgE
         a9YobsaCi1+C6pOx69Z7GmAc3uTXXDpbdGP/h+U1rIDhdDOPcHWXUYOStDpnfwiuSyzY
         7sFQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLJcE5q9q8VAEqVVYSa9QskxlhN6IcNJmMfo4oDRjBbwpqfnZxOjex7YWovfXEEmzbZHwaf6AlpQ==@kvack.org
X-Gm-Message-State: AOJu0Yy9sPh5JhFEBfc/Y/lOXc45SdJxrq7EmKLmy362ka1VFGH4O2s6
	cTHN63GqPRXNJy45OItiwwvpnU05kCHNC8pu090wF+WY6Mt4Ra4DCl8eWYpi55hP1kj1wxDXjE+
	Smb++tTl5iD1g2SzmCk23kjezWrWV/DkEXl/2YlCO
X-Gm-Gg: ASbGnctu/tCrq0QaYa3Nu4SjAJFmwL/NJ//mjusWD0gZsF7jh5yD1z7OfOWNtzYC+1D
	WYR0NkjtKHgrUwViDiD55Y3un6mbLc+KEVwVWnq0wNu3gAP2tKCd8Kb5YYZUs2R5hgu7lRfrHgJ
	ZOspOf/7KOUfNAYIHkKo7H3TmyGcJwIYc8TcQaiTntOYkS94qafhXLuV9RTcXRBUmy1egxRtDZ5
	GQ3YioF3vLC1J+jFEp6kbJRdh2Mzpn5d/9NOw==
X-Google-Smtp-Source: AGHT+IHfnOEj1gMhyVykBwx/odq4LWyP4tOsK2JQ1CQRm3BPJztFNuuL5zFmF2mdOG0LX/4UQZju33b9dOCcFbl89Gs=
X-Received: by 2002:a05:6214:2aa6:b0:787:68a5:51f4 with SMTP id
 6a1803df08f44-799139ccbe6mr37966906d6.26.1758294369549; Fri, 19 Sep 2025
 08:06:09 -0700 (PDT)
MIME-Version: 1.0
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com> <20250919145750.3448393-4-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250919145750.3448393-4-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 19 Sep 2025 17:05:32 +0200
X-Gm-Features: AS18NWBlYb6i59Bt1eV3KacTLjZoCQjcTTUaAaIGM2IX6otsVz3ln6Zi77bGuIg
Message-ID: <CAG_fn=Xd07FvCp-tU_kSyjeJS-4gruaO1x5iowrQQ7zkv2cLeQ@mail.gmail.com>
Subject: Re: [PATCH v2 03/10] kfuzztest: implement core module and input processing
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, andy@kernel.org, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com, 
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, shuah@kernel.org, 
	sj@kernel.org, tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5033514000E
X-Stat-Signature: jbrpx6xrziskjony84n3zugyczuxqpw1
X-HE-Tag: 1758294371-491353
X-HE-Meta: U2FsdGVkX1+yebVNaS3jbf0C3a+gmDRAy5QufWXRHsFAcRKIy1/B2oZVRKqZ2q8tf1QpiIFfsQOONpb+6qWItf5rxGNEXYUDHlSPSvx79O/ihaZ8CuQxxyMRHSvIyLcSyrq3JNHhl1Gcjmp3E4pMuu5yh+QRMQtQ8dAUETAHrfG2xLuPhkO7ph6bLaW/sypLShxjrR6Mb0zpTVTFI8dtAoHC/zMBRuLk5tVPuhCudUZbCqTXBIa/DNtJ8hL+TFv7X2uBDfpfsK//Tn2xzjo2qCcta9Raw5bfb4fXMUD3sfvrnpHwjChcBceb3zmZBvxNa9sWlrs/1uBow0nPn3Qtwt5WRXjS0ceVyPRTgNrsW3VrLKDB8JoTb0HGl5TEVPPZklciv2GsEjwbDDEp/MhodV2MQATmQb18Y4UMc9bVRU8+ucFdxRy2Ot/A1tSCFlQ7nupJ1gyhpFCgbXtgYFD1HZshJ1Ih1r0T+lhE/1sO51tKkgS4l6OUT5/8NmJBdPdpqgcEGXq56y+lUX6modMOLOzyDjBGfjU5dBzbYEYl+LnjZKr4/Z+Q74Si8LXXOr+s133RuwHk19EyFKb7HLOQURUZ81FV8i6OKVKU1gssQ4OjcRkleEy0l2eOnY3OySLC/gjyq+OJTzPR3+Fvj7Qq9hpJJ4BPbXF+Dtm8b0sd1pcEDyf6B9f3jQUaaSCY42JedbYdyVfPEX1oAkb4870aQiAlOOjsFsEft4Pzp1tcdiVIOu80vOJQ0jJPrdW4BU+CskgoDtEx/aUa2UPZO4AOvuk2Tamb21buDNqJ6vh3q79l0V0kyV2/gFryuQQAVkxD3boahlOPiSeIrloMsa5AwLy2U/K+IF3slrBbDlRVVeiMo5ahr9/Jyz2f+2KnHGtRZaSILVOfN11zB8zraUkvdfKH++kKSaPtpUvXp4PYp+3gr+uVBfShdftup2iC4o0FrUnF5dlMkXoSiyJKA10
 nPYErRPL
 JjNARX2wlQxvCMuo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 4:58=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmai=
l.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> Add the core runtime implementation for KFuzzTest. This includes the
> module initialization, and the logic for receiving and processing
> user-provided inputs through debugfs.
>
> On module load, the framework discovers all test targets by iterating
> over the .kfuzztest_target section, creating a corresponding debugfs
> directory with a write-only 'input' file for each of them.
>
> Writing to an 'input' file triggers the main fuzzing sequence:
> 1. The serialized input is copied from userspace into a kernel buffer.
> 2. The buffer is parsed to validate the region array and relocation
>    table.
> 3. Pointers are patched based on the relocation entries, and in KASAN
>    builds the inter-region padding is poisoned.
> 4. The resulting struct is passed to the user-defined test logic.
>
> Signed-off-by: Ethan Graham <ethangraham@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>

