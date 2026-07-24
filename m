Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5DF1C531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 09:52:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5C516B007B; Fri, 24 Jul 2026 05:52:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A33DC6B0088; Fri, 24 Jul 2026 05:52:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 971726B008A; Fri, 24 Jul 2026 05:52:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6678F6B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 05:52:00 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BDBDCA0FC0
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 09:51:59 +0000 (UTC)
X-FDA: 85023203958.28.26A5E52
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf29.hostedemail.com (Postfix) with ESMTP id E9F49120007
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 09:51:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Bx+1MQ/8";
	spf=pass (imf29.hostedemail.com: domain of mahad.ibrahim.dev@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=mahad.ibrahim.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784886717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3iYJh8X4zydZm5lth8crx9Gn9ZUVYixAi1/OUo5y+Tc=;
	b=TGtok8ADh2urblS2c58pLXcdV/n5Jw20n0MOl36bQ6/GbGIFK5sVFsWjEJxOnClUVbsvaF
	4U86vizWqYPLTCafJXC4NHIFANNOf+iyW5K/oy8qdZpzI0WEAJuWuyBFq6l+KrifFKb88Z
	GUq3gl24gSjcgkgW+P233Jbl3QSKjl8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784886717;
	b=V6mA/Xqw6kCd5WxjVtVgv8YYUy2bd63QUCP9eF+6vCaI16TqrlS9lVMtX/8nMnNfg1gJlQ
	PmN/rwwxWgrsSqejTKnKF6oo/ixnRnaM0glPYvaRGnnL9+1AJtDujOwSSNjt3WMOGj9oh0
	6gHidxeg9bS/iR8WcWcEaYjsPVjZKfc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Bx+1MQ/8";
	spf=pass (imf29.hostedemail.com: domain of mahad.ibrahim.dev@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=mahad.ibrahim.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-47c2b362ee2so235314f8f.1
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 02:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784886716; x=1785491516; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=3iYJh8X4zydZm5lth8crx9Gn9ZUVYixAi1/OUo5y+Tc=;
        b=Bx+1MQ/8Fkd7v+NV1883Z3h1zsIDkP/oonNDc3P0cDvc6R1PZPa8mm4xzidMxddKut
         ulbE2D78qwDtM74kOJuhcVDOrz1uby6vidtH1kv4CaWEUH5xZ6cmMUDzkEO+wCs301XQ
         Gt44XbaLPTkPKNvfegwf638eOAnq3MnF+ZqgmfVQb+AeGeM8uvr9IdCtfkH81Qp93d8B
         V/sS4VEId6mB5QHycxUc9f6j5V/JRoSwYb79CluMhh9WKRxOP9R+RMY1Giw0mRRJ2Cyp
         iKGV6eo7U2fri7nfW+eRCQUrJIKX1slI6txEbR3+duGJBsc7IFsOSAE/NaPwmc4wxLkh
         S33g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784886716; x=1785491516;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3iYJh8X4zydZm5lth8crx9Gn9ZUVYixAi1/OUo5y+Tc=;
        b=e6WUq+A2VMBv8M+UlB7bEJqSwFe4dkWU7CXw1qLlVORne0Ypa0zX1I469lc87uwSwp
         t1rVWT3qxc+uhx8/nibgaa5xytENBmRCjEN9genfSIS0gfHelMQPVup7t8KrwdT2Wjdi
         MxOOzZWLbHnEYPmqL9FnrsDBhLsIAx0X3Jid3UIvpgZGstP3ZB7ZVps3aiPRyY6GKGnD
         YrDXAe4sx9bMTPZC/dyicBq6+2Wk04hUwSZftSKoDT8/369ixycs4uWsrMvw8YkhRGvK
         59PO1YhGFD77ytKJJyL1N3s/9SYwibMBC1pNTanLeMdnZGseW6K0iw6oicTus6csF6uC
         ntVA==
X-Forwarded-Encrypted: i=1; AHgh+RqeeB4GwZcpOpUg6hm5ZCSHpTKwvUckE6rUomwBl/UJD8w4I/Qg3S9pcyrgbjLayS6e6vuFfRjDPg==@kvack.org
X-Gm-Message-State: AOJu0YwqdgSWhd66PHMtkRhfqc/AZ3c7iKBZCOLoNw1f3y+dTYgMalFs
	ag3KXpLCnnvATMo59ncby32wvzkUVAbAfj+cqIp5tY+C8MSC2T0AHi8m
X-Gm-Gg: AR+sD12fRrtKQOJvWLKHrlK5AWIbte0pR9CblfV15lFoeuYZxgV+rAypTHVaf3nrWAM
	ypu8Jl+hFBrho5JI8cR/gjsHROZ3cAZbR0Dw8eJ8AXNFp3EZRI45THqXoOJAljdvYWTPNZn45R/
	ZV7Ue/ZS65DJeIisrbXV2H+KIihhVs4fNmSgm4siYdmhVN5Eyshq3jzEw2y9LT6uEsHDKa7mMsc
	nIL+Sipig+aUARAIHqwd2i2XDZQyAZIZbt06zSomzBrPf0CDTEVsxeYJQtNNSKRqMLBvN42aRx7
	nPlm2atDEeKHyhQh732yeCdRn6duUHlL7SWB9mdF+nctYEe0d+Sk2Jp2p1RiTtmWE0IL7j2jiJS
	TgSn72F4Hmyto/kAr1wzEUzbmWkRFXDK8p4YU/SMxGA0P6UXBrpUIN8wJ6NdtAepkZOGqVtJE3x
	zNfjGhNnw6
X-Received: by 2002:a5d:5d0f:0:b0:47e:81aa:3822 with SMTP id ffacd0b85a97d-47f8d760694mr8193784f8f.42.1784886716194;
        Fri, 24 Jul 2026 02:51:56 -0700 (PDT)
Received: from localhost ([72.255.58.127])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85b9a60asm23320630f8f.3.2026.07.24.02.51.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2026 02:51:55 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 24 Jul 2026 09:51:52 +0000
Message-Id: <DK6PJ7XQ7N5A.13FN4A33JJOA9@gmail.com>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Greg Kroah-Hartman"
 <gregkh@linuxfoundation.org>, "Mike Rapoport" <rppt@kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lkdtm: use kmalloc() instead of __get_free_page
From: "Mahad Ibrahim" <mahad.ibrahim.dev@gmail.com>
To: "Kees Cook" <kees@kernel.org>, "Mahad Ibrahim"
 <mahad.ibrahim.dev@gmail.com>
X-Mailer: aerc 0.21.0
References: <20260722230246.2869-1-mahad.ibrahim.dev@gmail.com>
 <DK5HY1IKXNC5.36QEPX9H8SUHB@gmail.com> <202607222046.D287828@keescook>
In-Reply-To: <202607222046.D287828@keescook>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E9F49120007
X-Stat-Signature: 6fthpbosa67ayws8unqqcbzrc4gg1ykt
X-HE-Tag: 1784886717-56919
X-HE-Meta: U2FsdGVkX1/30aqlHXhi1JhT1iJIndHcl430+4PcyBjHLQaKAHmgZNVdvUq8DAXX+eAHl80oUqVFaN/MKykwKc+Y+EH874R2pnOgWCm+QTh9QDMqkhbU8rnen4vOkOi6x7XIO4JsY2+lQOTIWNQJ8bdX30YPd32jDE1J331bw2VkvsOZ5jxkroCDbL3lTjReX9mb38F0c7YbJxtJZJ/5tY15+4qbviPbU4g+tXd3zqXjGH0yYob1th5wHwWnmFfK8eKZqvKqpbHttm2WaKh3rIN8t0I0At1flRonD0WVNYvAVRRxglrt/rpOb/9b+CkXEy+ZOqEALyDBgRk1zqtZm7myjWaMWbnlxkthD+7j0pfDO/naVZRJukC8BzVTcynAjJXnw5fDhbCFNr0Ebe1qymk9Q/BgMbhB9500CLtKrQb1S3/Q1Tb/hPGqwXikkbVj6h3Odg9822lHe5Un2ul5+jy1hcuWzLr7aocIb2A/tPKKKL6el9+LYNUDE8q81lZZ76Og0nl+x7o2lwCl/RDYLN5HYilK0XBNJt4pv2W4O/6gPCIeET0iSC59CQo3LkDCoEs7Ui9oskh5r6KHgVOJTYJp5FgvhD3U6FcXsoXElQibxlGykYmwSkK77+Nh2TIgtbUY5gN02wLif4KRx9EDgH/fVP8Sr1DJnUdEZ65u+EDPgi+3ve88MrwGTmscj084FGuXJbgWXQWDjgx6ISpU7mP2ARqKIoVFL3L+wvRFp7adEO0GY2R2yj2S0XrjOplkLXv+mWWHQxycm6h1Hn36vO5lxzFRu9tfLYsR0nKIniffVTm1pOfDn52xlDy+nhGRwL1RBkpxHp3vRE3VbP8nJ8wTdSqCG2Pj/tvnkkXEUyh0GqgWWV1w+YvFTWTo0KXcI/yv1A2KWZeA+bCndIU/jExoCI7hWoEoipu5Bixk2XGiK3CmLoYn3W4IPTiJRcx7Mz6mCHzYTConKyEjIR8
 C83qJKmU
 90CfLYE9pZM5NuMGyzi9yEs5Q9wYZbren2zMCH3zzN70BpsAbSR5U7j3CK2X+OUfQqR57i4NBtiTpOKlfCqC4MeG3UDKv/oUXmBC8P4S1wsJkLVglIth+qvBYlv/XoniwFKnX6gZhaNVvNCTuGG9mUTFE9+Angai3QpiAXvrOnf6jCncPAPdj/dcB1tyjhuS/7V8rAv40txRdzZdj+gc0ERlWuQWXL8GdT87fT32j/Lc14LE37QC244AwcFSHFhOBFokc/vEn9nMAU0O/9hVQVVGwK2Zjs8YYZ0usAYsuSxRQZFo8Y61AzlZdsbxdOtXOI5SX6/HGg7OEMFnkobFnD5NzRdkO6zRTkaUyfPhEpek1N4sVYPtCt4NiRoWrzIIuevToJyB935731e357krNa/zFMb4d6KC7f6SZPXB7Ue4LSRj/z1gXtjxUX41eo5ZYRXDe20SrgNthHLtF/0pH4a+ZQ0k8CouYlI1ECNUlribhiFI9tlQgIE4QLbq5zNMU5Xc5GbwmeV/EoQevTityRr8FNkSFaUcT7sxMCH2j4LyNonznCyhwtDXiXNzxRR7VUYK1bFKf9v0Y1TbcvBXLTKupyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Kees,

Your tree would be better.

There are no dependencies, nor is drivers/misc/lkdtm/ in Mike's gfp-to-kmal=
loc branches, so there would be nothing to conflict with.

Thank you,
Mahad Ibrahim

