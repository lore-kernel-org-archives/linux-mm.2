Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04AEBC55174
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 23:38:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA77D6B007B; Sun,  2 Aug 2026 19:38:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7F136B0088; Sun,  2 Aug 2026 19:38:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B20956B008A; Sun,  2 Aug 2026 19:38:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 802D86B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:38:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 01E5BA0564
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 23:38:20 +0000 (UTC)
X-FDA: 85057945602.30.B4F0D88
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf18.hostedemail.com (Postfix) with ESMTP id 19CA81C0008
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 23:38:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rBpuTS34;
	spf=pass (imf18.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785713899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wVC6ZNErkENuKY2q+iSkfidbrSUBAoqUgOYVFs+1qAw=;
	b=OJsZHn86pW/PKm0usKbeFtgfOJycMqHX1J9/KClREJsgpoWOV6JMuccG1AyKy+E5+h82po
	DkbBNguWkdFC+HJRsydaSCNYL81rcgVhr287LxGutXo2jIA4OhV48MDaINTE9bl3PQIDqv
	Fh1cviDTlWm2RmMJGyqCNgc3piUcS4s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785713899;
	b=8VvM5X3VhkD5bX8U1Jy3kdtony4XSz+5H8VWHs5RoCKWNnXKyd2EgO1EXrTNnxpJxRGV1u
	5VqL+HG2wGJwCf9/+FUJsuQO+5ER1gMEC755Tr93c6AhoSL9PQP3zXB+6e8/k0bPOV7ttG
	hQiMjyeiKh8Hcn9dmlLlxIXTuArHBU8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rBpuTS34;
	spf=pass (imf18.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2cacf197759so40531265ad.2
        for <linux-mm@kvack.org>; Sun, 02 Aug 2026 16:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785713898; x=1786318698; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=wVC6ZNErkENuKY2q+iSkfidbrSUBAoqUgOYVFs+1qAw=;
        b=rBpuTS342SL/L0Rji81QEGSnyNAeWcYZjnYUZEns+jQALsbEqPTrJV8xQZf0koZWd5
         A0LbJqpH/o//q2TVTxO+JzQnif3CQ0j/LTaL+a2loGRgEVxXZMb6KHEpV4gACGAGa6UN
         nfOLDnD+6qCcINm5ZebF/3+PserCUjUrYxfCH65eyyfRTuYOyLOJP+Qp10QadJe1V8qp
         f+bLgGZvi3V9SL6fs8iZOSljbD1SgQExi0g4Y715qtaoDXm+ZbVeQnhdPYUgkblLTfD2
         plBniQwwj3n4J4D0GnX3+PJO6v6rWg/u+JZyRz7Gs1ktmFurPlZNxxt21b49KdRliSle
         VmKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785713898; x=1786318698;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wVC6ZNErkENuKY2q+iSkfidbrSUBAoqUgOYVFs+1qAw=;
        b=K6XNWH2FWQsULJXy3kC6ob+cfvPNB99sxcNj+cJ225sx1g0m0qZXkZEOmV3TA29TKs
         d1d1p85Dn50CfxjIkLtAbMOKaY9SMRgkaV9yD9qvl5tJ+EtgVy4aN6TYCNazrFB0irqg
         PWfT7HpHCnGqxy0UUmWCczQ3N/51HbfPxdXdtR2jrGQdWJKJX9fPX1eK5Xbhy81YBxhn
         go1R1Uzhgu5jKDqI6nFnv+P5GOgUEe2MZCpI8qbqf/jfXL2gHpGEwU1g/8w0RNZ4Ib1v
         6A7OS8FrNNsJWMwQxDh4jIx/fU2IkqDOcJdSXJKf2cpK3LD+W88EbTGRdPLsqTl4aEOs
         f+RQ==
X-Forwarded-Encrypted: i=1; AHgh+RrZdYqFHsJ4IVxq/wpOX1jzqAIbUCZbRY5kxO73/CVg992pvqIaaMu1SI/BlpcazmncSGD1eEzJwQ==@kvack.org
X-Gm-Message-State: AOJu0YwjFNfsEMsxSoLRcvgGfDaoh/4s5n8JF9C8n4nkge81hpryteSl
	2DibdG0nGt6xBvLlA1MUSiS4SRrMai1rH38d9vKCiZqk2cSRwbBmPCE5
X-Gm-Gg: AR+sD13e4O+tNdvIHixUKJngg0uD2gAg6hAEc7i4dC1WWtpgDZjB3XSQ/4TRA7iZzDO
	c06gkFxSpzXsASK9xxmLIDmur79z1HZfbLy1IVANVPEK7IbbM7RRXfDd0D/YC3QRhXEMKYeozOJ
	ukZruQ6GdYPFxaM/cx/K0pWuYyk/q4GAveg7xUja3n3+pBFnOxMp5+l0ycr/ng2ippsTrRI3oa4
	kt0Hz1oPoIoi8OtJ1ODKdLEsLEkuhOX94HtFLaXlvO3dFTh3b3+4y84xoyH97Cqks7ss97TzihW
	+XysxIelDnae7XB7gWS0wU+2kbDBxnLD9SgqiMH6BsLhvVGaNSMTVGt2c5JqggcsY7LQOv7vYUo
	pkH+lK1sd5pVmuFmThJdzMyz/0ArNgvbPe1zNurk/WiD8s+CRjs0F70Zr3AuxnJIVmMKwKbyVSx
	7v4CCZBi4QULBRTgMWuY5KLlAHNjjyyqyWHf/I9U4IOgVAbyUzUbuvjSLjFH6S5XtOxA==
X-Received: by 2002:a05:6a21:6b0f:b0:39c:126c:93b5 with SMTP id adf61e73a8af0-3c92a5d6d28mr7873983637.21.1785713897970;
        Sun, 02 Aug 2026 16:38:17 -0700 (PDT)
Received: from [127.0.0.2] ([73.222.46.22])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13fab4e44bcsm35070094c88.12.2026.08.02.16.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 16:38:17 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/9] binfmt_misc: let a register string create an entry
 disabled
From: Farid Zakaria <farid.m.zakaria@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
 bpf@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
 Farid Zakaria <farid.m.zakaria@gmail.com>, 
 Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, 
 jannh@google.com, mail@johnericson.me
In-Reply-To: <20260730-work-binfmt_misc-preopen-v1-1-4a0b0da71f16@kernel.org>
References: <20260730-work-binfmt_misc-preopen-v1-0-4a0b0da71f16@kernel.org>
 <20260730-work-binfmt_misc-preopen-v1-1-4a0b0da71f16@kernel.org>
Date: Sun, 02 Aug 2026 16:37:58 -0700
Message-Id: <178571387898.1880415.17662890925792360904.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 19CA81C0008
X-Stat-Signature: e3owsbic7xq5xss88xeejrzo1nqfwdnn
X-Rspam-User: 
X-HE-Tag: 1785713898-712936
X-HE-Meta: U2FsdGVkX19/6Yi73YH+g+yELlpi30qHBEuA2E+sDx/76VhWEcl3LkMANnjhH+PKNgP0jXZIPrg3jWqC3GyN422v7yHPnzN4kfqSn+p2PJZVrpxiCIaszOrQgCRCNFa8gMDb4vwAo2+bHF9fUlnDGUP4DvqCEda3P0me2S9qQp4XgKtHf5v3QHHduHtsiPcwXm519ZZ9feNefaBLX6wdcuT7NcXUANk6hNoJ8WOdRBt3tHfyGlMnrJz1808awuvTgVBEBaLA0btHUfvKMISpoa0sLi0WKqLVl6O0boORfzxGarWeKpY2P3l5KqeUks29AQu9keUPgC7stF9tz84YhQnUPINY6qGXtXjLEmgK+PUeXhxkmmpA217iUNzzlMyBZwNRfSrn14ODZ33PHCkB8VM7jWsGAosazx4JMif1wmHCA5bAv1s6mG69zcMmxdxKQGghyqBHwzoKO89CdYrlTxf/5Cl647xFwmvgTn8xNMP7a+IFYZResfofABQ91vLr/ZHysQIh/oe1x50rIbRARhWH4WtpBOJZyf85iWd/K0QrjcPeHIbmEpQVLN544i47xzbtS2/eIIpM9ABGLVF/svXnXBnbClSGYATqm9a9ZhbUhO0aJZzzEk/S1wYU1FT0fe1aH7+Utcqg4u0JtatiPgYZLg0Jn86LHGoVGM0FXap0sTU/gWFdf6JNVsxBIIVDoUbJ4VGwzqtp+sgaiLXjLXJop5EbAMHFrnTjTa6rDSquElQDAOhuAGVUDhKBB0s06CmX49SIbmv0kh9/hNt/P8iGnsamOSoI88oKNLQORw1HzJX1FXNPWNIjqcDKXmag1duLfJJLi0kqWGA+DpR6Wru05RuKLBihJDutw0qp8EG3xajuDIeEOT8zGzmZIPHm1cr5jY094Ho3KHHFGzPqF1WIy42TCNsSwSa2rual2fqIKKY/cgOACRALTOi0qBJcD/Fmbeuwl/iFenbL8c5
 tmnFsi+L
 9kUYYv1Y07FDWT+mDloBRhvNcr34ns/QGsVbo0x8lI7QH+wv/yJxLxhrz166zm2YXaUucNfl9OVjHlk9zrhebQ6Y63eyugy1XF4uFyENPlkaF0k+J2wvNmalKCnwUj9K7Q9tre1yZPKR+i1BsC+DGkTV6NzLr4BKg1UmvHnSMotl5WI3qZ/z0iExNnNGMYtBTCzio2Qg30Wi+U2Lk5ndkmYgAntyAP0+p09kBiOVpTebfDsocXeMD2YWKS2qQxMJUMfGd6+rkbeO7hLMZPW0wEqY5sywKQMMa2a3zhfJ8N67p+jOmkuzBTLDuHRq3iCvEAlwsPVmAF5WXJBG+/SYucWJlWRIr6xzK//HZSOuGgUaUz8uTiei9H3Vt0ibdFcrG3xNiW4PgYJM9hjnPa/kdyV/YQMCqeinQULzA6fRjdv5RSsKxX0GY+63+LtskVq8VUk/vBBaSpMl+42gcIBPnWII9tH3Sfc+wRNUqj5pW6pSbr65tSV0fjwH1jJDYjofh/X0dhRMeAS6B78jlsIhfG6l+OnzSVKfrGNFV2Ucr2I8N2mCtK4JzHJLQ3ZGuHqZR4OYCLtIQLgNWpVXIlGp5MnrJyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Jul 2026 15:34:03 +0200, Christian Brauner <brauner@kernel.org> wrote:
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index 707f8a14f8a6..ca7840b01a2b 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -75,6 +86,7 @@ static const struct binfmt_misc_flag misc_flags[] = {
>  	{ 'F', MISC_FMT_OPEN_FILE,	0,			"open interpreter file now"	},
>  	{ 'T', MISC_FMT_TRANSPARENT,	MISC_FMT_OPEN_BINARY,	"transparent"			},
>  	{ 'L', MISC_FMT_LOADER,		0,			"loader substitution"		},
> +	{ 'D', MISC_FMT_DISABLED,	0,			"register disabled"		},

AI brought up an interesting point that this now changes the set of
valid delimiters which you might want to call out in the commit message.

For instance 'DnameDMD0DmagicDDinterpD' was allowed before.
It might be a very obscure feature to pick a delimiter because
https://docs.kernel.org/admin-guide/binfmt-misc.html does not even
mention it beyond 'where you can choose the : upon your needs'.

-- 
Farid Zakaria <farid.m.zakaria@gmail.com>

