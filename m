Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 818CECA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 10:44:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE7188E0016; Fri,  5 Sep 2025 06:44:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBEDF8E000D; Fri,  5 Sep 2025 06:44:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFB888E0016; Fri,  5 Sep 2025 06:44:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD9BF8E000D
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 06:44:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 678C2140655
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:44:26 +0000 (UTC)
X-FDA: 83854862532.21.7815F2B
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8DA65C0016
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:44:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LRk5EhU6;
	spf=pass (imf10.hostedemail.com: domain of glider@google.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757069063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tJ18ogS6OfuTP1EQiRfSY6yIXK3vsX3youWzsSBm03k=;
	b=IUsoSD4w609A3iJdP1G4eumf0eJxpzh/qRfF55p3j0iKuLong4NEA7+Pbs3Vvc92CunHly
	GAbAiHd9zsl2r6BYaK5XMpco0O35iVq5TYJLlJaj9w0t8QAG27s1CCbLPhyidZoIwE7x5J
	6dyMSp7W8HoAF0Bg2qwlwk0R0ttoc/U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757069063; a=rsa-sha256;
	cv=none;
	b=gOQvKklN/GhJH0TwxJQuzZWmBiQQ07bOrC+4yTET35SpQh8uI78Ptjz1Z/J327ASmiOkym
	v+OX3dzwkyJHymx33J4MdM3lTM89gpfFv0So81pBGVdIkYIJWbGUkPuYk5GKuWYU8XzyQS
	cdVwiK16INnIhIbD79uOhKlYuFDjiig=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LRk5EhU6;
	spf=pass (imf10.hostedemail.com: domain of glider@google.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-722d5d8fa11so16561836d6.3
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 03:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757069062; x=1757673862; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tJ18ogS6OfuTP1EQiRfSY6yIXK3vsX3youWzsSBm03k=;
        b=LRk5EhU62fWGABlQbgU+jtJHzqfxgfdvYIXIxV/nM5v+K+kSejCpnEJlY0yiF1QegZ
         91s9DU9ILvyVleHGjbv591RFqWa159gGkvl4/rHV9NnYEI3FvXpeagTFsR2jUGYitcW3
         elXip5e4heafuuQYTAdWxbLUo+x25BYBcKFk9Cwf+RPWUIfpuw2mxlx3YlVk/w4z4K2w
         bkUBQDDKoHWad+sSl/16XI0bYBsC8lXfY0dxu8yEWymR19PnAFrb1NATUeeYnvuaPXUJ
         GQTKYMX9hI78Xsx4Zyf0siKZ/rZfHcUIbxAGfcMHBmZt4aSTdpmkCxxxnseengAHzut6
         9fPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757069062; x=1757673862;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tJ18ogS6OfuTP1EQiRfSY6yIXK3vsX3youWzsSBm03k=;
        b=Gt2aFnPziEysOO2cZVbob1fCnbKjgMlDM1T210ppGL3A5VFkkj/KshCUGjpAWeZjcc
         2VNu8Vb6vl/R+k4N2b7i3HMCiRTDq7eUk3R5kT0vL6bJmPRoRGupNDHDvMDpMjeBbrSz
         7otVZgj6+waxWcZ2fU8deGivbjBZVWGrvF1sIwD9nVDzFgJa5ajMtUhTKGwRaV7Ntpy/
         WgZE/iA2n6lMxDWZerLmaxiGASQIyn3hgHpqwfQc1H3SbgZB9rpTMDpy6ez6wJDcc3yY
         e+sJNacdlS2udegQPSStSk68GRZc85wX3b4e/OWtxU+fXuD8jVNMt9vN12W2Hrf1YLFx
         rV2A==
X-Forwarded-Encrypted: i=1; AJvYcCWnPvZgmc/4QoCrQpefX5CjtiNKlYVAVrrWmGSV2n2w3q+CTvKgklOb+pVpK4PIfgQyFNFFk13Org==@kvack.org
X-Gm-Message-State: AOJu0Yz5U2qkP8gQ6FDPYbWFc2KQ44YR9VldlJLDCFIkcj3X3VD+0OMQ
	osOXJGGYlazb8ZQkjOjzdcr8O2WIMcTkflTb0A7gUI0sZ1AoWn8sU8JmcoH+E0xW4mS/lHO+stF
	Nai9tzrRFvcwdp+qYHPXFnB5Av19zFrTmCgGNw0UN
X-Gm-Gg: ASbGncvzrx/SOX7xwBcvK8I8/96eCkGatCCxGR054z2wjdyfKJoEnX1+MjkUZEO4Yd1
	H/9aY+yGJvdR3QDC4xCs97ZcBOTiIXKHl5zM6S1MShImDFkQVQrOlxWoteRw+nAVPAFGx4MrtVY
	yT9od5p54xB9hkPjwrArffCXbs9szNGEGiZzsicx6meYok9vGR5u6NmTfhpLwzgWDZk3T2dMkWO
	Kc/GeTXYN6c5/5Y/28k3E1LMPvGUnx3o4RJO8FtOHe4LMpUntRbiAtZ6FBw7XWX2g==
X-Google-Smtp-Source: AGHT+IFgnVn5YPd7nt++mcxJYKI5s6CE63gp8oAepp7Bb2RS8fbxpyACzBXy7jLF8rTFHvYVBXrZq9tFnSqmoPRojvg=
X-Received: by 2002:a05:6214:23c7:b0:70b:a189:a571 with SMTP id
 6a1803df08f44-70fac7a01cdmr71754206d6.25.1757069062247; Fri, 05 Sep 2025
 03:44:22 -0700 (PDT)
MIME-Version: 1.0
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com> <20250901164212.460229-5-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250901164212.460229-5-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 5 Sep 2025 12:43:45 +0200
X-Gm-Features: Ac12FXwrVWcwse0FO0oj90oXgii4UalASzAKNOgq4n0I9KmYMeRdWc12CPAmKB4
Message-ID: <CAG_fn=VXxaGd4QC0jHzwFg88HuaOFV4K+_tdzrhqW+UoTk-L6Q@mail.gmail.com>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8DA65C0016
X-Stat-Signature: zntgzhzp8o9679fzz6mqaqhqoq3b4tks
X-Rspam-User: 
X-HE-Tag: 1757069063-797626
X-HE-Meta: U2FsdGVkX191ZV9D0/2p8L+4YsMvCrUJAM2nLch5uTSPsPvGAohzTsgqonV2q90bp1PnoZd2j67ShB8rHYsABsktiij2yUYb0rq6mL0mCXCbLMBSI2v458oGOp38lm+3fFwZ0G1Rb0UxA7HS//mj4wzsTi/Wre4w6JYYfwnxPbs8zkuf11zZ/3x3o3ooZFTguJoSxfifdx1v+FDLKqCWTQ6hty+ppkMMs9NuxuZcqFz085/7U6MPrAoueNu4BlBdMH8PNoi22bosR2iufRv6ofsZ49CY7MXBTNt3ujuOuj7KKHczKG5HJbLqniR2PX0S1mKX0jSlAov/7pOCMmTpvKvxVrOBKYE+xICfLY13Bpp+KQsOujA9/19nOy0CLThlU/H+btuP7w7ItTHlfAG1cD/brTwW4yjH2qHrBxrSTLFVlbWagMw9sNQj2Sm+UwHhb6M/OjFxgKVPeOf++9oSYCRiTMV7AhJJhbyuo6w8/i2Z1472Rm8fPBmboHp6OROtcSIaaaIrc+GI666r+mjIEGcPUM4gtKX1X2Wt8cxUZQA3oAu+lxiTBhWEYk7aT5L3mNYMHbSwxs+PL8PoSMejM0OmwM/+PJRloAlcD/vyJv7oeRFfeYjXBlpkscPx6TP9L70Dicmej6ozXeh8eaMiWFWfMbHZY4bFwjfyxn2eLqI1wdnsCIyNir5QyN3hmYFDZuJtkMCWUJZUQmUP0JqkS+nsc62+najP9JzXUtWi06j9EHIph9LSEmarp87y5lOgHOImslyzJrdq7rwF4FNNcFKG/mMVV8Krr5oKWCIyN4pkjkbpbcToz8rQZUL8ySESjfznDnh2BJK7P+9ZohfHEIfIHgy2GnfAYRJAWp7I4W3dSEFTkN/XP2K+nLONV08ZHDN5VGqVowVEVCqrAdZGaNhGmwPM4FXBNV+twInD2d181QAg9KGRrfkMRtCa89A1QEGdh/Se1JJ2JF7Gdf+
 Ftvjgkor
 FSpoJWa+VP+aqK6cUsGadSSabZqNdv/Sl41njwKPQA2e4/EFmmPL6tYy+ODRVXRwrvGam40TTJAF8FgiEqmbZe8lr7wdTLOKBobo1W905SK0o4fl4PMfk2x7VLb//7gNMTDIB6Y7lFvW/SlMlO9pPOqWMvQBBhlR6pbuWc2P8BkzaFz+gubBfMeiZpmpQrA2S2tdTnWuJ6G1IxLkJ2Xp+P+DYb3Wbcdw4GnSIGRd91Zc2JvbjophiqIaye/WyZiQXcIXpDrIEJallyY8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +static int invoke_kfuzztest_target(const char *target_name, const char *data, size_t data_size)
> +{
> +       ssize_t bytes_written;
> +       char buf[256];

I think malloc() is better here.

> +       int ret;
> +       int fd;
> +
> +       ret = snprintf(buf, sizeof(buf), "/sys/kernel/debug/kfuzztest/%s/input", target_name);
> +       if (ret < 0)
> +               return ret;

Please also check that the file name wasn't truncated (ret >= sizeof(buf)).

> +
> +       fd = openat(AT_FDCWD, buf, O_WRONLY, 0);
> +       if (fd < 0)
> +               return fd;
> +
> +       bytes_written = write(fd, (void *)data, data_size);

Not casting data to void * should be just as fine.


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
> +               printf("tokenization failed: %s\n", strerror(-err));

Please use fprintf(stderr) for errors.


> +static int refill(struct rand_stream *rs)
> +{
> +       size_t ret = fread(rs->buffer, sizeof(char), rs->buffer_size, rs->source);
> +       rs->buffer_pos = 0;
> +       if (ret != rs->buffer_size)
> +               return -1;
> +       return 0;

Note that ret may be less than rs->buffer_size if there's an EOF.
Keeping in mind the possibility to pass files on disk to the tool, you
should probably handle EOF here (e.g. introduce another variable for
the actual data size).

