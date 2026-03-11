Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CCA01125807
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 13:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C3AA6B0089; Wed, 11 Mar 2026 09:23:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 877726B008A; Wed, 11 Mar 2026 09:23:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71C2C6B008C; Wed, 11 Mar 2026 09:23:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D0D86B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:23:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CCD62140178
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:23:47 +0000 (UTC)
X-FDA: 84533849694.15.A9B3C10
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id CB7A540007
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:23:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.221.179 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773235425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=34DR94e/1PAvLLEaib58vFA4GW0m5SGe6jvxchEhMek=;
	b=HnJd8Oqqxt7scmh/gA5K2CF81xylHTZliLM7Tekq8h2CwA+woHdDHQvezEYvLTw5Zvcmve
	BlkSmRJwbsK0l+DA7L4K+NRwUV9b63FZ5DiSz8SWDCePUeGIs+JBpzaVbWKwNhQzc8c1Wo
	zOwqanJVGmwvgYDYnuR/Y5epKWffs7A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773235425; a=rsa-sha256;
	cv=none;
	b=kzYiNndlNWqH2xsqDpDcINRxizbW9XUNdDVZmzxavUk4aZDUtRH5uynVkhNb36imCpUS/A
	gCgge4zqfPFQqxOc2+drLwVv1zJieN4LUWErf8e4/9UNNtkouTXx2Ro6o798134u/uW5sy
	nVnhiGtKooBvWup6iU1i0HXzGJbkjd0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.221.179 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com;
	dmarc=none
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-56b18f05f49so2424291e0c.1
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 06:23:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773235425; x=1773840225;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=34DR94e/1PAvLLEaib58vFA4GW0m5SGe6jvxchEhMek=;
        b=wwLXsy9T7zdwXP7zmTje6N/wLofY/OtfVZ3QVchESZbZBHmbyg5HFFBWzV1TnwGNY5
         mRdNQjvGxauOdMyayS8GknZNWLLKmjvPQIFfLhd3A0V8FECCef8IXqXSQfqjXZ0lT6Qn
         ht4LGAP+WL8EMB27NXDKgK9iUm0ntapxTqtj/SqAD1EQ0GnKxIhHAkHmPLW5HxWOm+vQ
         /ro8hPJogNGX4rwqjzZWJI1qRHGc5RrYnrrEUA//9PhoYpurbXFKT4DDKnQzjRYlDMM2
         ieKcGVtDR1xsZSdo3MQUN15RDWiIH1DcAlKgN1novAUIE6ntDgHUqJS7yneyXuDzzWKX
         D6PA==
X-Forwarded-Encrypted: i=1; AJvYcCULp420a8i7XYS7wdvMT+MuP8bdfgFln0LsYpzBVlyfB17hHxdKXC8xXxRFPBY2ZfOVf/Vz2itO+Q==@kvack.org
X-Gm-Message-State: AOJu0YyV9gAbpCDj54A2Z2D+Ru9krsnwFpzI20fX5Tq+ZhNcI0oo1LE3
	RdlWAC1Qpi8ZUfR36h98HHA9J6pYr5Ve9hMAiaaeJb30m03zHY8KqeHT/rdevHDLRkM=
X-Gm-Gg: ATEYQzxACmV1vFOYOcq/+/TnKBq0wShLHcJMxV3WEeszqvSKlMf0x2yiyhkcH1HIkfS
	RQrxLk1bRtOIGg1nK8e+FBvyRbBbRvBas27LpxA6fzhmvId3Ucd0cW4P54Zn4U4Brenytim0yzD
	amtMwIsVOMOG5hUnxvMUQtPhDivIU7bI/5EZOl7xCV175kbHQWmWXor0YtLwoitzXliy6xeibOx
	lBzNctdm0uuLyjeCIOMiNyPY96x0qmmegB1R0FrGpZ0Hx70SYV4pBgFPAJivZ9aocuSTwrUzHA2
	BR/KB3RcHMcx6Wt7PUqovTsGEl34XEaec5g+mONNknlrblmOYY7wJsfW5Ar26XUwTjOUZa4Mhb9
	gYo0bDHtxHLHCBVeNfNPB6NtoqdGY7znXShPWCQMekLytysut/FQIUlPAsaKYDqr9TihvTrE8xN
	R0GAOT4zxCJ86N9zM0rd8k/zyPZoypovxHe7Sx2CWt2KLGm/HIFpEKXMZQQnRAGgGlbCYJ328=
X-Received: by 2002:a05:6102:390f:b0:5ff:c6b2:efde with SMTP id ada2fe7eead31-601debd1f15mr939890137.6.1773235424824;
        Wed, 11 Mar 2026 06:23:44 -0700 (PDT)
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com. [209.85.217.45])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-94ecff71462sm536025241.14.2026.03.11.06.23.42
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 06:23:43 -0700 (PDT)
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-5fff774800cso3501138137.0
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 06:23:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXt0JFbZbfXTdrXjpySOmxbiao2S+uKwuZDeYZuLgBDoywfIRP5CxU77Ppr02tYpcUBeHPhl8YGgw==@kvack.org
X-Received: by 2002:a05:6122:1d05:b0:55b:7494:177b with SMTP id
 71dfb90a1353d-56b4752d806mr922396e0c.10.1773234967338; Wed, 11 Mar 2026
 06:16:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de> <20260310-b4-is_err_or_null-v1-36-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-36-bd63b656022d@avm.de>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 11 Mar 2026 14:15:56 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXQ8Q4jvkgFRJYhghz2BZRDC-9Mk6DbXxuaOc6C9DFHZQ@mail.gmail.com>
X-Gm-Features: AaiRm52J84H77ROK64ZWWtJfaiCpnFeKyoSRmPbi-NC8CN6Ju1TJEFxJU9gZQQ8
Message-ID: <CAMuHMdXQ8Q4jvkgFRJYhghz2BZRDC-9Mk6DbXxuaOc6C9DFHZQ@mail.gmail.com>
Subject: Re: [PATCH 36/61] arch/sh: Prefer IS_ERR_OR_NULL over manual NULL check
To: Philipp Hahn <phahn-oss@avm.de>
Cc: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com, 
	bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr, 
	dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
	gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-clk@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-gpio@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org, 
	linux-media@vger.kernel.org, linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
	linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	samba-technical@lists.samba.org, sched-ext@lists.linux.dev, 
	target-devel@vger.kernel.org, tipc-discussion@lists.sourceforge.net, 
	v9fs@lists.linux.dev, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: yye1hd16reozxydzhuzrkkc7puk67wci
X-Rspam-User: 
X-Rspamd-Queue-Id: CB7A540007
X-Rspamd-Server: rspam12
X-HE-Tag: 1773235425-530073
X-HE-Meta: U2FsdGVkX182F9L9M0g9lULr8iXEgs7RyTBuj8aWe4qI8mmHl664PE0eUMtPbknk+zELsqzGzwclyNJH2H6/KK2Ep6iyHCJ4PX2O6WlkGzfOQFV9yyLEnPASAdKhzCJEe6wAeaEzY2woRIme0G3SBa6N1hMHY/7e0BR3pNv8obWLrvv/P9rkMNsPMfLHumzKn077QbQ3UPsKOea0UnqXJPqpJSslbtsWznGaQAji0K5yZuxiSTDRCfAFgH5hxUpqzdNzBW16pu27ilcqz+uZUh0Gr1umngxUW+y9kE1MRJobZwxqWJH7oxYeksJQgD8iwWr4My+FbAOjH4vfhlPsx5RPqb9SjtR1wjFO88L+0KPWirqYC5/h3PJ46kYM+22P/gqACJD63lsBelXwdI4HMqFOCXIKD/1Pl8EFaf21dRc0mYHwntjTiUonYzMA1nyn8poi+Dgpw+Z0WxIZQON5oYFohEDNXwn1scfZeyAKc45hW6/W3jav79EAUCKXQldGbgFYVhk4BhknaGc35qPvo9wRR8ustckxaOyEwwgVz7CwVjwN/7z67s3hKRFeCVrHHzUjl4tY6meG8ZCa5wnTbCEfX/L2HA0b9VUJ3LOfzx3/IDw+n4yJ4tHe9JK8TVZNNtYu62DbRYdO9uNt6yXuIV1tJwQm0Qeuok902lIb/KHAYclfdyBbGutPhUYlFnDCdRWdoc0vvw2i2uT2GI8/XnbjF5gkPAGpepA+w2FN06J+iy5eQGU7ztZeEr677bRVyQ50M5pOAiUnpqvPpV+QswC54y53PC8UuZNu5KX45eYsfsIQfW7bmv8WCgRNlWiMghs94ERigCeCgvBTunuCYLcaVgHWG8pRFOVmck+0ri/jqWs5h/gzq4kDMl9DWrF36lL0feTRpwKWYFjXZaLCP6FwyTvKjFKwO9xVsZibEbskQ0DEw9NcpJTetDLBx3Nnliz3vMXdRiTDcY4Kgiw
 U+MR3jce
 TOjRPKFNSpyRiCOiLFX75GgrhfaoH7heqDEd1pdFiwU14MqmEeU5FyZypIgib1ZzSxzaWVXSdlKAQxvWyZsIHCiF+8HS7xALsd3+dx9n5Dxl3UVkPvplNJ8BFEnxTstJbqmXLnLYmEOSTls0VjMBNd/J7HspyQuLaFj/4xamxXmXxa2QrMow3P7q9xkbmaM3Ut4itjUR9vbDWcoF6ENJD3l2JOieS3BVQzzh1PfI11Nbht3eA4ubfqSJ9j/BDU8fuhTQ9mugZ+zyJkett1kjRGDpBossFxHb/JmpTEOZHbW4taaG1a/U5tteFSemU1WUxZmNJMWHGfUdSEjnxURED0LFOKxDRDEoRlUf5c8B9Yq8WuBx5lt9DakEvmOH9sbBh97vka8WBYhCGXhwmyksrGsNjewFoWE5767AOrVHpbnX+0Xe+n30L7zWD98OpLjGoFWkgtkVEg+VYzBO9vCZoEg35zNR2egtU0bzMEkzAGY4ROt6Dk4Hxu9b2k+5TtihusOcW5cv0q0s3qUZXHw79tvNyx26mwJs4yzSK90MZ3G54TTFBWttdcthalbfkaaZAXUWJbdwryHGH46THGsZQ/DPOGhOZNVbGk3pZl1LGu3cjTcfrYyB9BerzpMl+APPyBF8YafwJh3tb0JpMEblLJv9YWToBBS+DX/whydvhablb792fUpULWD/3UUXxo1LawQvZ4oMuilDgtoBDOUT4QaqwoahNIh/Axdasvphfz5noHeE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 10 Mar 2026 at 12:56, Philipp Hahn <phahn-oss@avm.de> wrote:
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
>
> Change generated with coccinelle.
>
> To: Yoshinori Sato <ysato@users.sourceforge.jp>
> To: Rich Felker <dalias@libc.org>
> To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> Cc: linux-sh@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

