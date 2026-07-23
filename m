Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABD5FC4452B
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 03:52:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14E8E6B009D; Wed, 22 Jul 2026 23:52:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 128CB6B009F; Wed, 22 Jul 2026 23:52:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE2826B00A0; Wed, 22 Jul 2026 23:52:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B5EEF6B009D
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:52:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0FD85C03DD
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:52:42 +0000 (UTC)
X-FDA: 85018669764.23.2AD051A
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf16.hostedemail.com (Postfix) with ESMTP id 359B2180004
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:52:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ibUZObfi;
	spf=pass (imf16.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784778760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JnOvPtms1RLQR9UWnggpXMwfANAdvGkfvfRA3Dni8Io=;
	b=7Fc0Xc89y/FLLni2Uu15WMFSmpSd9jRHdbWn9MfgIwKxaXPK3VNH0iLIVVCaVl5/V929Em
	6p2KLDOJDmpQIXyddrcD+tmwYlm1lBnl2MYtVHcYthW5Yz1oWP4mqPsRCEQKifcN7sIgcO
	9VxUXDswDiaTSUvmPGFjk25XjPPh3jo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ibUZObfi;
	spf=pass (imf16.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784778760;
	b=atkOIG6Ne5fUvDty6u22CAt8REtvqycQrVh8paxUaLasPSiUW1lCR0Ck8o1lTOhi4JF0Ig
	afP4KzuZpNYKX3w+7/PnU0Z/bIVdjFSrEwIOO+nODyAFRcZ/QThEcP4YpJq2OFPAIUS0GS
	r7UNwsXqTnok8BKronNGdsKNx2zkIYw=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cf50c6f235so2840035ad.0
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784778759; x=1785383559; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=JnOvPtms1RLQR9UWnggpXMwfANAdvGkfvfRA3Dni8Io=;
        b=ibUZObfirzuRSlYEQNEXQDFJa2s5jyrXhREAuS8HrRUDNan7ThUJFKqK+Wa4o15rkG
         CwipOLBthfiYD3ODtly+Lh5CE7brCDHpab28rR6ON7/YKkLtw7XvlvZUWi71WYKtcPv2
         36Dzfnp4Lvfm2UQut5ro5+M4jihiDW1+6IkzLkda9YHVnBeQS9yRA1jiMSFkOmlAM7Mw
         45mB8F+BI47n3SZoasA/QT3+cSorUtXkTc3EJppEOhIgLR9O51aH14njSrLGodKZJUf4
         KJgRqi74Tl+EROLLFV/CcL85FhuPfZfaMagC3KzSEsEPpHlCEAq3ayfmxwK08q2ygshd
         ZI5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784778759; x=1785383559;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JnOvPtms1RLQR9UWnggpXMwfANAdvGkfvfRA3Dni8Io=;
        b=fsAOr3CUK5O55DPUjGLXmGmh0RIBTOF7ZMath7TouEviusPDqa7yxSH3u0W3g2hl/o
         yVZIAIyCzSMIlTEa7dxOZP4+OaKuleBMqfx+3i8Hn9ajjZULPL1kGSXT/KFK27wxNGVJ
         vccf0TGaPkctbewfdQhhvo7m+A5OOGhQYjye2kHchVl/CbtODYPC1hUlQ7M2zhz992sw
         UVsoyeZ3AoqFNrkxlDUCtqFFfaam7sN0pO5eUQbTwnx8N5wGqTaxcftaILTC5LK1L7Gm
         oOxtTKNSnivnfIpOz5S0/B1/tZ1Zte3BEU6zYhziq9z5lGZNS/KmtpvtOuUjBBiqexdj
         fSNg==
X-Forwarded-Encrypted: i=1; AHgh+Rp6OliRvd4bmHknwnXpzGIXh9OJcrzKWNOF6Uf/VL7PD95iz8rANps+FMyUbizH8R9rrlWg22nISQ==@kvack.org
X-Gm-Message-State: AOJu0YyfkH6LKtxbVzywK1JYWf/RXpR415MtN1JSOsSzLCjsDODL6LtC
	9rLFPc0oOvkfEA6s7OdgK7aI7AXRCNs4o6/RVB0DfSnWzfnRtk3fr2+O
X-Gm-Gg: AR+sD12rJTO1OH8HoRoqNHRnOCiwQxQQd/pBoWsbfbjD9UTKmtMEHd1Xd33Es1lrE4a
	u0p0B47O43gcQnVLv10wmPh6sD6HUOC6GgvybLQx93YqCRIjtIA2o0bRyZ793CnLKZG9FfsnyXl
	T6kE+VA0mh5Fjo0+er6konKjDdLf5i2Z0DWOIhoUE/0ICrXc8/jFZGj6JycO79oV17+eEKG74N9
	Z3f5ErRT3zAWDPEQWbGm/sGm2/Sr5Bq0SeURLslqC6hdvclxVLA1bbvxGSP28nSYsd9nZ4rYLCB
	0p6jTUf+CUjn/vcfh3F60PaQxDSvYGlKjYJ1QgrOhqkYJ4rwd+xSm+RhXPuO2hSKBuLjljmWeP2
	pxxWSMY9PcSl4q3zb9bQgQs61L9G5f2AMchsKpeeIJIx0PAO7bHb1oNSEK0T/gSaSQQRo2gebu9
	NPJ6E9fg==
X-Received: by 2002:a05:6a21:2d4b:b0:3aa:c964:3c27 with SMTP id adf61e73a8af0-3c44b1c86a1mr1373005637.46.1784778759161;
        Wed, 22 Jul 2026 20:52:39 -0700 (PDT)
Received: from [127.0.0.2] ([98.35.8.117])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d12f267fdsm11497359c88.0.2026.07.22.20.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 20:52:38 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 04/21] binfmt_misc: normalize the per-exec
 invocation flags
From: Farid Zakaria <farid.m.zakaria@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 linux-fsdevel@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me
In-Reply-To: <20260721-work-bpf-binfmt_misc-ptinterp-v2-4-e57866e4ae0f@kernel.org>
References: <20260721-work-bpf-binfmt_misc-ptinterp-v2-0-e57866e4ae0f@kernel.org>
 <20260721-work-bpf-binfmt_misc-ptinterp-v2-4-e57866e4ae0f@kernel.org>
Date: Wed, 22 Jul 2026 20:52:07 -0700
Message-Id: <178477872731.254289.6997696289699732480.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 359B2180004
X-Stat-Signature: aoak9rbfd3usiifc6sn91yiq94qnsp46
X-HE-Tag: 1784778760-781120
X-HE-Meta: U2FsdGVkX1/Uj8Y5xBFsDQI5XqUWr0l7wkGHA01fKX4YOuyLAdmpjSzOWxUC2DrEP3eyWHYPjW+D8VeTMW0+8CeSeazkQ+xWx8nU4V8nVRngbKtKMSLYpjAul+9N9BEonaX9pMnKadLnAUPCwkx5SnEUSi7pgO3qP7UEGE0VtW3NsslRCqRgiO8Y5NPv4CXkEMEdAcA9UwCxoaNEluyeqHrGgPlRFXEyUWQE0rT+dnqausiVeFC6cX2n3XSnlJTvSYsZB+VsxDZ7JqU3OgIR+R1YYzURBh5j4lW490CXI80qYA/gW2p27cj0xCpirJRkSWj/6eAqnM4Oi5CIN9z2YqxuZK8TVfXCckXONW+cO2aXtQMUBAMnpFGBiLdbeoaeEquzK5FpBSwYYTSVtvIqW4IQwJxrRUbfoN6FcOyfGndpgFK6RQpAHTZDOpIATcwEY/PdsIpD9ZvIiZKjDt/a4d/ULBcY8h3Yi0LD+eZrRo1l9Y7QZpAc5breBiABv+iGLXpm5V0ERloSeuajjr2jVC9wXd4V/eZej+yKqIake9n6teZG8jNgRVauO2MSRH+UQzh6bVHK4NEJ9TgOnyvKaSQsL2owWY3XvpMJ3wKnSETCqrfoueln6FGq3zg6QjtiAYAds6lSfYWWmfCANMbki8yWZeYe82HhTyx2C630beiZmWvEhiTjr3AMH5YkyPWmKF7+sXU/QZRQKqxTMqQN21r7gF2r7Wg9UkSSSV/KezFPFphJg4yvUckWXTHqxVb6XA+LHeZeqnDiS1zU3T1imB8H8cfay7gc9ctmXLQ5HbXF66j0qI3XR1laj08tb7U6zG6iFjnoWpTq+s2iaHbIipxuhoq8Cr53a3hNmJwjBLE6yfUh4Hzff/PuFb8VBOCWo2Kf+kch3+Es9XHaXn1U4uJVZp0lPMYaSVCM9/OQvygHoZXwxh4vt3yl3oJ72XzAt/koFHS2b+3u16j/Bh2
 m5n9ScTK
 ldKMMK9xGRiSw1+zKDHAXkA1eNPzPMW+UXQ/uy9IphVLwqU4Po53y1fAIH1vjs3j1ROHC6c3Y0ioVZD2FULcwtRlr11Md3qi6SugUcIcLvol5cgiKWDj5AYrKLW17p0QPjv/OcSrbUrC/YxuZ+Hl+MRlPhHR4+1837zlb4imJuXXdrfCoR0NnjJtJdXkOTMRcPOOetckMiGX5Xx4Nxezqe6JJlMq3CBtemSHpWsfaEVgugPX+VLAwjlaVu8AkQY62XXE+ehP7JsA2WGlcTgdrDNx68hy1v/0okKwhuJoXu1G4FSlwZEeSq+KW+N5zZdS6HBGeBSufGMobNU0XSAM/mE5+g60FToEaMRyvMeMfd/FpRWzLjc47jNLmZOY9kwdidilcU9TPKBT9C9k7IhbVlAg7t1bwIjKwnOKAhjTlOk2mzbEZzPn2Ske0A/JlAnLeiptwLEZ47dRLTY+auAQhYrcxaLu5BXMlLANjQ0Hzwotvq9W1jzADhzDFBFptdKHUdTF5bERH4rFApiSZXATgH+ZPmsS8Omh7Cd7ur1neyMbnVtQcqH5ADefyQqWpqzLE+TWt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Jul 2026 16:13:46 +0200, Christian Brauner <brauner@kernel.org> wrote:
> A static entry fixes its invocation flags at registration. A 'B' entry's
> load program picks them per exec. Since load_misc_binary() branches on
> which kind of entry matched and then applies the two flag sets side by
> side every flag is handled twice and each new one has to be added to
> both arms.
> 
> Translate the 'B' flags into the entry flags they mirror and let the
> dispatch act on a single set of flags. The boolean the two arms
> communicated 'P' can be removed.
> 
> [...]

Reviewed-by: Farid Zakaria <farid.m.zakaria@gmail.com>

-- 
Farid Zakaria <farid.m.zakaria@gmail.com>

