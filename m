Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24A55C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 11:06:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80CF96B00A0; Wed, 23 Jul 2025 07:06:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E3856B00B2; Wed, 23 Jul 2025 07:06:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D2EA6B00B3; Wed, 23 Jul 2025 07:06:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5B3496B00B2
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:06:13 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0BF6BA65B
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 11:06:12 +0000 (UTC)
X-FDA: 83695250184.24.B0C8D2D
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf17.hostedemail.com (Postfix) with ESMTP id 054BE40003
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 11:06:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OpIAfwx2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753268771; a=rsa-sha256;
	cv=none;
	b=VWowLFEeXgOmX38yEdPJJ055qoQlQAh/3RFVnggTy+al3h/j1qUSv6oV2Vmeky7e4gQp72
	H3F8XtIaGBPbB9i+RQF9r76TCuf5mVVyeaGxQ2WqthhB/PXDI2R1UnaT8hOh1UhOP+TiEg
	OcJ/aRIte5IVHzkO7ZXDKIq+6R/RYU4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OpIAfwx2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753268771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2gggYC9jdzO8cIJk00SwXWq1Yluv2kBVse1A4jgDLjE=;
	b=NBk/2zr2R2i4OWftoyKuWbWqoH9q6dmb8e4mU4yPPasVonuFZoq7GuVjMu8GgT3MnX65JI
	bDwQWckY5dT7/ql0SE+zcTW8DEgGb2x+hqpseCld9dih/O2SQl/XWDiORC4qIJEptHi2hO
	Do061cmQLuTPOPmHOOg0oQIz7r769hk=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-74b27c1481bso4099969b3a.2
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 04:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753268770; x=1753873570; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2gggYC9jdzO8cIJk00SwXWq1Yluv2kBVse1A4jgDLjE=;
        b=OpIAfwx2t9nRsocWxIt3cPZLD3ChcPQQypfp6YHfDCGUMwizsR1r47Ujy9lHjKNQlS
         4IryrMbD3nJVTFJTvj/J6Ybr7dJNUoBzGN38jzJETkv4hQ5KH98ryU92e1aOEaXgdWxo
         GPuCCzYpJ5unP6oiqz84J6epDl3Ijr/RS8sdsHWdTvR6qrERZFuXsfas2HrbXaXzGKUE
         yOr2vXxMBQtregoGENwQe7aZJN7zBv/P6XwGNMrQxMGzhESjC+KsvVShB02Wqkapak9W
         opMC+GUHdpis3iPXxlJbtB+KYaPyf/qw1wqHjJ1AMqRVlwBPSQ1BZ/06L/tpYfe/2Wff
         z5jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753268770; x=1753873570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2gggYC9jdzO8cIJk00SwXWq1Yluv2kBVse1A4jgDLjE=;
        b=CHp64RpjTvekXz0ODXlpnmaiASUKLgUkKV8WqsqOP9r42TROlu3b8ujRb7AJVibENe
         z7fWmbLI7C3fu0cMzCSE4kWeRluDY9cdwNmyBugwS92fBvoNGv7eqnsBk0LnsLDbPxM7
         zfgnfjfeObrigS6JQzw9CU4rCuBBXHekcDzdoMr1jiI8H8TpPrezsbrb7UBn9ul7MpwF
         4uLlj3IpAyCD54ovcBqcVXiZ4/xvXjL3ud+PafsiQ9gjs+360ilPteDJfOP6/5bFG42A
         QBm9RCKq5jDunFDHPetwLKBuBddWjgeoGlOMKSetHEPK9MMFF0iVoTG40p/r05SY8fLb
         fjUg==
X-Forwarded-Encrypted: i=1; AJvYcCXavTQjvEZaWXy2Nes0um1XOqsDPpWrdfo9CqwG2LBPavvur8v+zwJVezSqsFes0EMJ2PG28FxRIA==@kvack.org
X-Gm-Message-State: AOJu0Yx9E7wF4yUV+Iz7lXvvdvZoGh0adfzbuSYs/vZPNr7+nPdzBQit
	OmE+iNorUaqIJ+DFuewUo6YejZG2wLsoYGDv/C41YV9i66oA7v4uRXjv
X-Gm-Gg: ASbGncu05hovd/13ajkDnxx1H4N6MhmRRQwnQDhdhxLqb1Iqgg4YcXtFQE9SjYlTNeV
	/QfV6RST3sigoCqbSPFl5ynYH5MtbgYa8+5v8InSS8fh7eV19Ngs87ihoA1wCz0yEPkVVZH/Qa9
	kyHJkqn0s2HtM9z7gQn8Yst3ICCH+baTH9UuO7f/bEnasUhBPtMZ/t3bofi5mO/rU7/JHGIjrs2
	W6IA6EuPrqaJVi0cDDfhLY003nJ0UaAUZ8m6U8cME6rl93S84gaElJE8tnHreDAPHY6mf++bjWR
	tX2g1R/fql1RNxbAJpStkBF7/uobbWBRzVHm6QoWCIlg7YubmtCabNu6mbYeF9RKkUE3Whs/1jD
	gShnadaLoq/zEZb04ocGezJFLtKB5ZT4jwAQI32vWWLs8OeUF/mE=
X-Google-Smtp-Source: AGHT+IHDaD0SAIqDCHFQ5hg5e0ciI8y4TK/NnpJ9dwzw6/StwdgG/gRPzHcyj8m3t2GJUnEUQYB+Ng==
X-Received: by 2002:a05:6a20:748a:b0:239:d43:481c with SMTP id adf61e73a8af0-23d49141c0bmr4231501637.37.1753268769719;
        Wed, 23 Jul 2025 04:06:09 -0700 (PDT)
Received: from localhost.localdomain ([114.247.113.178])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b3f2fe8dc32sm8771650a12.23.2025.07.23.04.06.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 23 Jul 2025 04:06:09 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
To: ziy@nvidia.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	brauner@kernel.org,
	broonie@kernel.org,
	david@redhat.com,
	gkwang@linx-info.com,
	jannh@google.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	p1ucky0923@gmail.com,
	ryncsn@gmail.com,
	shuah@kernel.org,
	sj@kernel.org,
	vbabka@suse.cz,
	zijing.zhang@proton.me
Subject: 
Date: Wed, 23 Jul 2025 19:05:59 +0800
Message-Id: <20250723110559.32219-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <1C468AC6-C55B-41A3-9335-65B03EF65B83@nvidia.com>
References: <1C468AC6-C55B-41A3-9335-65B03EF65B83@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 054BE40003
X-Stat-Signature: c6g3ip87ywagxs5x76e46wsamboyg76g
X-Rspam-User: 
X-HE-Tag: 1753268770-14742
X-HE-Meta: U2FsdGVkX18bQj229laO8j9E1wxg4ApL92U38fnBmAj/rP3MlBdw0z9c5Aohp7upy0tifvm4p88tj4oIrQK99266rFQzA9XjVubnuI8JYL9kf82xNYDlUawxaHGQDQ6mOaTzC7y1svfa1YJEbvcFwEVB2c378dmHwVDiNUDA0CBWY0AmOvZg/cnZ+0Z58Uag8/H6WqOfpGNbIxwA9TahvjM3v4sXhEep9dSmzTjwWlP/iFOGDzyo5sVuiN2iUcnmLCzFchXnZqbxFl4TLZP8jpiEsjzBuCg/CtVXMbl1FPmZbgwxC7Tm6ECtnK3dTnge/Fqvo8wUQP2VnWgNWge+vy+GdbfNOkwFJm7GIXpjWnoshnlYskTEdN2Osot2mERNEgJSK9A/jXHIaivNNUhCawqWkLwJ4yAhB0Sq8nbTKMQ+NZsVs235D2dKOdvM6yzwlkS49IlE6y3p2RuVmVgEQNGpZ8LzfjqkBFJyste3ZYo3WSHeSWM+ISCXjgRVF3K3+Snim06ofvULP2Ft9VS0CZizE/BSu4tfpCJbGGNmj2skr1HUZjllap+xQ87uGXgLeajEYEVXqZhRfDRXs/ijIrrgqbFTnMCLmEVfPJHGRqT2swe6ZpApJWasYRConoXyMsVoFBAHdbFRSCu8gHxJF5QZbDPOJCKZwKjSpxZJ7HWNFDNfaLzR0VGUpS520PiaPykkw4Q38cKwm4dR9xPSFY3ux0U/MHOWc7Mbcvf/+0sPBIr/e7YbZ7QljzAgJCQw/CMS56vS1GrUoWYcneP5tJmi4FoR5GfJUP6MrKBqtT/83US05SvrDvXIV8BiygI00c8HSbVqtYDwZl6H0Fx38Wa0o6MhJDBDrXMtjLtOb79gdHbNDAEWBvYiExmgQu7ZsotXdgnuVV6MnTFWl8jQdlWi3zX3rU1yJI2XaPYhw0cKjZMkVaKrLZypP5vH9XmsGFJ3fdcUDUxkRQpF5Kd
 yiWMomQr
 2Ct/hJ6wc5CjnxgFDpzGsTK5PUl3XClzg4UbElU3XGH49JLwbp+rzKKu+5vE+kgi3CdKFvF2ShWvIvogzHzMkaANv4GN+xzAFZJeKw64JG3txKfiatS9tH2kTwqFfpH8fT7fnFSaIEropGkydbc+I2e7kR3gM973n7zno91kGIW96VRqSE664wNbhj/iXGj90Ft9SqfR6v9jCO9GF+6QdCxt9LytuRphCzfxUywIve0zFaBCu8wQqmi40yNZBSBRsn06C3OZbMTYCXmie7bJI8RAK8ZgFY8CBBK1sXnypEFF9U56jPcZDS4F1o8hhT2pHATnLMkpc5igPRhIA3sv9D4qFAtKlG5W38hR/X2M8rdhBeRskdBwGMOuwQobolYmMuKvdLCSS0lMVpCM4Rhr/8BX0WLDIgrpIkpGUvRMyoiH25LlWmKtgClCYSxmZj6D0e2N1TnsNbGb9VyTSZhSXAMX1oDZrxXNQtlnioPTHoJxPsyCmzfu/E/+IEilfW92Ao/D8tdgouj8e8eizz4xe7y9D/c6vrZzTI4ypMtGjhzxoLrz7xs7EDwIMJs4iypA7tfgiY+5HWHIwTxqeGiU9rO5tsWu+rOSbpkgc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: wang lian <lianux.mm@gmail.com>

Subject: Re: [PATCH v6] selftests/mm: add process_madvise() tests


> Here an invalid address range is provided, since pid is checked before
> address ranges are checked.

> BTW, the size of iovec array cannot be bigger than IOV_MAX. It might be
> worth testing as well, if you want to.

> With default_huge_page_size() -> read_pmd_pagesize() fix, feel free to
> add:
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Tested-by: Zi Yan <ziy@nvidia.com>

> I am able to compile and run the test on arm64. Thanks.

> Best Regards,
> Yan, Zi


Hi Zi,
Thanks a lot for your review and the valuable feedback! The issues you've pointed out are very helpful.

Regarding the logic where the PID is checked before the address ranges, 
that was an oversight on my part and I will fix it. 
I'll also add the test case for the iovec array size against IOV_MAX as you suggested.

And thank you for adding your Reviewed-by and Tested-by tags when i fix this.

I plan to collect all the review comments, revise the patches, and send out a new version 
with your tags included in the next 2-3 days.

Thanks again!



Best Regards,
Wang Lian

