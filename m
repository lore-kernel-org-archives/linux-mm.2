Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 581E3CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 09:59:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B67508E000C; Tue, 16 Sep 2025 05:59:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3E538E0001; Tue, 16 Sep 2025 05:59:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7BA88E000C; Tue, 16 Sep 2025 05:59:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 97B2D8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:59:03 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 54CAD872DA
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:59:03 +0000 (UTC)
X-FDA: 83894664966.27.D31B145
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7E21D100009
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:59:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=T5Fz+w7H;
	spf=pass (imf05.hostedemail.com: domain of glider@google.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758016741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ihmf+x196EH8nuZxldOMUKvsTYF5JZyh/dMEPXLM1AA=;
	b=bDF/LDX/9ZLdvzmeimce2vm52VyCWrRKkOhPqqTpH42GP9U8lhNw+WxRvB6g7/mvyGmoSz
	OPcCPSz8YDwMwIFuZOOJQFIJhdbEFwn69Ftap50IOA+HCT51Fp7VrooUyroqB4fQkZOKnO
	gzRFPOOmM9fYb9nARwClGgpaAaNwt7Y=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=T5Fz+w7H;
	spf=pass (imf05.hostedemail.com: domain of glider@google.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758016741; a=rsa-sha256;
	cv=none;
	b=HilFsN9DR3soPdrTa8UCj9/Vrg9bi37jEojnykV+BL3Oq87dmEYgnOQc1LNOj/C8C5qfOO
	c0tEEwRX7OBTv0f9CnqkH1uKSef9aepxuZhJBg9GumseLOCmfWkWW1rkUvm8XeFKQyOZwf
	kTapkK+7OEMRtPxs9EHbNs8oH7OFxjk=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-77623a63dc5so14752286d6.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 02:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758016740; x=1758621540; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ihmf+x196EH8nuZxldOMUKvsTYF5JZyh/dMEPXLM1AA=;
        b=T5Fz+w7HLFZiyiE8vhWx1q9kfusjQupwZsJM2Z6YiKsBLdbnX7PLhix2FROz7FRFfI
         YS6PSfxo0Yyz1NUMAPF+FwrxsPNZbUzJMpG+tc/se6zDAFVsYHiQt27kOnUgAxHDWSSM
         C9a3+y6sMaF8FpdPM6CIDHHiTt2CkVpoduSJzUtkHTNIt5XR3P2jg89kkG35+UqquXDG
         QJsLv61jjDdxZlJO1+W5VLGsFuh6tjW2nWFgopG2fZKSIGcIcKoMrex5bk9vGdXHTlz0
         rcFJqmSLOtV/7U/uJkvJtBsS45r0mdCYzf2zH7FMdCZRUY8wQhi1aTYI6OCucfE6NjUt
         GaXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758016740; x=1758621540;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ihmf+x196EH8nuZxldOMUKvsTYF5JZyh/dMEPXLM1AA=;
        b=TRFuWxOTbBLcMqge0cySZRv7+PlMn3jNXyFcFX4ITMu0SrviKxCal2dFUdsPBTJ1IZ
         Q1m0aNtFWG/Qg4eYdggINRDWKELBJwiiy9mbO4P6xewpILiweG2sAQZ9jjqbRAn7i2d+
         JAz42qOiwjBwXcCcMTU8/QgKWDSj5sEUaxM6QuLpJOMBfDlcOGuRxoc3oofEzsA1gWL8
         MO1ovsmLdifjy2eLFAI2e7GpYHQ4PAici+TZZCqejV9kPZpWL9lzZchaxThMyFAYSNLa
         x6Ehu1zUup/IeREZqaYnNPJi1cfD3CVUlM7VUcOwbyCmwjLk+1Yc5vOpsF4+Dq23jr2A
         RjZg==
X-Forwarded-Encrypted: i=1; AJvYcCUWSQKds9eeZtL97zP5ihEvUydC+Qx55WaxbBHqy5bSwvBM63QOEDPfTSi0spnDKGpo+ihf60qsJg==@kvack.org
X-Gm-Message-State: AOJu0Yy3LcfHlHgCVnrhyJWpiMPI038T7h7Xl3jxPHmvy678cv6X6pDb
	UoVrXkNyFw5g+xpVx5YDEajpFiDYJAkjlFfSM8QFQBaMzBicpPNe9J8bzqhMqE+g4HtKKDhZSqq
	LsIZFaAst15a6PMD3Ymjt1suI/DAy/sxuYr3+nI+z
X-Gm-Gg: ASbGnct6luRQeN6Ky5nGuOghBpsvdyO9JAjU6X6Enq23iT/WKyD60oKjyjYVBSESi9w
	V5kpb/yrbDa630wVLCqd/CR4rbOJ8OKPCSwinqyRB0curiwvFEtEQp9gGFXkwREVxQ12UMWFOw6
	gm3uTnDBgTkHgcwHZqKiGi79WKpmxw5+1HkVMbdnF83zqz3y9FCawe/sJyzdxAB68RSSggvlQiR
	vVqLRNY3nJ2AMjrw90hhbSC0K+N0QOL0S3Aeov+nLd4
X-Google-Smtp-Source: AGHT+IFwGoXQKXa3T3Q3VSrPol5k75GVxiDe8CoLpO3guc9BwwyrOEWBkMhzdh4JyC+tSurxuiqJK5Hw+XiDhw5FhJ4=
X-Received: by 2002:ad4:5e8e:0:b0:723:e1c6:8d7 with SMTP id
 6a1803df08f44-767c5aebad5mr178831206d6.64.1758016740321; Tue, 16 Sep 2025
 02:59:00 -0700 (PDT)
MIME-Version: 1.0
References: <20250916090109.91132-1-ethan.w.s.graham@gmail.com> <20250916090109.91132-3-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250916090109.91132-3-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 16 Sep 2025 11:58:23 +0200
X-Gm-Features: AS18NWDFgZtzDhBG5IKRN3iWsXFMSPZcawD_BvUUYRoHSVWInp6fN2JP63m3d4s
Message-ID: <CAG_fn=U8Y=WNTNnP35uwQqxmFOnOV7ptdG0i1VjsaYUe3wfRuw@mail.gmail.com>
Subject: Re: [PATCH v1 02/10] kfuzztest: add user-facing API and data structures
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
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7E21D100009
X-Stat-Signature: 9o6ky6ttmr64typ8fyd4ruxotob8byt3
X-HE-Tag: 1758016741-151131
X-HE-Meta: U2FsdGVkX1/58bqr2BFycrGoY058OZ4MNonx3CdNVimHwo8HWm0hv57et3rv+rC/GDyi/4WsUAiXpMXXsW3ZP02AWYf27gMKCaMqebcEAA+9NHUhJAZLjqyH9HSbB1yA5yhh0pPzG9SobjxXyKcpd2wt1QpS484K7mSCjXP1x20QDehMV8WfrX2J1mCOtG4QZwvkNImWgbvRk3p3armNvSECHjHD31UNhSdqYwpaRMJRzH/ftFW4gxX0WOgbyqEdWK8jaLOuSnR84EZ9fCPzgvuq/MoQKYGOapuyoZBUVDPA3QICdRgMN22T4W2IHxJpE0A+fyQTsD8d9Qbfn3cNFOO0sJEP0N/GwSrTJsTOsJQx1mbahTl9sDTF2BzpWqojAIL6m57QjqqvyR9QcfxeemfWBPDTgnPfHkCP371Wdca6vjI7M+XHZ18penEVWg2ZIytd39Q7FGyfwwM/dgM3zDcaeOTx2CKVscznysG1sY23c967V5Bq1OVyqfVxG4qoZwK9TWQGOcAhsX/0niZa+3qxbcVDCpIDlmu3T0F3BAV1+2ssxsAk/G+L7/xT8dRynffiBhQ9Ez0qXNYonLI2ZSRy9Ri4N+b7kjiMYNFCz+AW2t0ZM6Iedcyi6Lhp6WNstDPX2vjjquJbK8U67UOslQG/xmglue2TTypSI6ryw/RalUAesnfNqM5Q4ayEMzSLytYDjSGT5X+J678oEr9PC46ikQFRbHdFtLggFKJsQHEb1g/zUuWnUk9JjcN56GZ1PDwAlyfgIA/wVdHPQK7rTfvAWaeOMPZcefziJ7YiP0dlbAJyj039Ro6NMXOvrgic52xsFTBxXP/JObX2u+OGbKJQfrTsgF/KFBgv61F0XrYeM6ptWYWc7VrHtZhJlmF50AbtjnPP/+d8IFEL9+b/Nv3+FbhUDzExXDfhkwzN+1SbdAQK0OoqeqNvQgTxelfQ/gKYMy6PnJ3VSp2RyvK
 xUIPIzq4
 kvrcXBdFn2kPjCk0RKeW14+ZzW/3JICqiwLKY/fQMHIHu1mzfgFQD1iFTC6p/KOR8Tl8d+WbxrVF0Bg29Ix06Guz51Qzs7CSoCypQY4ajxnISTwljWCz4H2qZvw1BxxXQRTVj+2HCTDn9Z9ptJEr1lxH2Z1CdFamMzAnYjFTr+sSj3fdhRdn7RRIPkni9yUtyXJt5pOTh94yEvNbAOKTQmnnkOP32E2DiDk+6zjBqRVh6p5BGtUHja16aXTEF1rsZKgM/LiCilXNe8d8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +
> +/**
> + * struct reloc_entry - a single pointer to be patched in an input
> + *
> + * @region_id: The index of the region in the `reloc_region_array` that
> + *     contains the pointer.
> + * @region_offset: The start offset of the pointer inside of the region.
> + * @value: contains the index of the pointee region, or KFUZZTEST_REGIONID_NULL
> + *     if the pointer is NULL.
> + */
> +struct reloc_entry {
> +       uint32_t region_id;
> +       uint32_t region_offset;
> +       uint32_t value;
> +};
> +
> +/**
> + * struct reloc_entry - array of relocations required by an input

Should be `struct reloc_table`.

> + *
> + * @num_entries: the number of pointer relocations.
> + * @padding_size: the number of padded bytes between the last relocation in
> + *     entries, and the start of the payload data. This should be at least
> + *     8 bytes, as it is used for poisoning.
> + * @entries: array of relocations.
> + */
> +struct reloc_table {
> +       uint32_t num_entries;
> +       uint32_t padding_size;
> +       struct reloc_entry entries[];
> +};

> +
> +/**
> + * KFUZZTEST_EXPECT_EQ - constrain a field to be equal to a value
> + *
> + * @arg_type: name of the input structure, without the leading "struct ".
> + * @field: some field that is comparable
> + * @val: a value of the same type as @arg_type.@field
> + */
> +#define KFUZZTEST_EXPECT_EQ(arg_type, field, val)      \
> +       __KFUZZTEST_DEFINE_CONSTRAINT(arg_type, field, val, 0x0, EXPECT_EQ, arg->field == val);

Nit: you don't need a semicolon here (also in similar cases below).


> +/**
> + * KFUZZTEST_EXPECT_GE - constrain a field to be greater than or equal to a value
> + *
> + * @arg_type: name of the input structure, without the leading "struct ".
> + * @field: some field that is comparable.
> + * @val: a value of the same type as @arg_type.@field.
> + */
> +#define KFUZZTEST_EXPECT_GE(arg_type, field, val)      \
> +       __KFUZZTEST_DEFINE_CONSTRAINT(arg_type, field, val, 0x0, EXPECT_GE, arg->field >= val);
> +
> +/**
> + * KFUZZTEST_EXPECT_GE - constrain a pointer field to be non-NULL

This should be KFUZZTEST_EXPECT_NOT_NULL.

> + *
> + * @arg_type: name of the input structure, without the leading "struct ".
> + * @field: some field that is comparable.
> + * @val: a value of the same type as @arg_type.@field.

Make sure to fix the parameters as well.

