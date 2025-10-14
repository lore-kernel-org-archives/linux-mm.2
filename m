Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2D45CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 11:25:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CD3D8E00E7; Tue, 14 Oct 2025 07:25:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 257498E000D; Tue, 14 Oct 2025 07:25:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1464F8E00E7; Tue, 14 Oct 2025 07:25:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F0D208E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:25:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8CDCB16089D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:25:55 +0000 (UTC)
X-FDA: 83996490270.27.C3A0BDB
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id B883D180005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:25:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A2rTqJXJ;
	spf=pass (imf24.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760441153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XVuiIrau97qjpcYS/102JQpRxXMYJ1qlunE5ky/iKeQ=;
	b=4BWmxVXwqKf+mlNAuYLnU4Mtvj/oP2KF8YYL+WEbeJsEVLuKGnyx9ljlQ9Dp+EQbNumuSU
	9HL3NiXq7XGNxblMxMtYLpXRSUJUme4uLGsNh2IAhetJtGPen5uTzVsbvxJXSMmOsyKrdr
	cAWMi0+1HuqfJ7hp80lLQ8hUk9n0uuk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A2rTqJXJ;
	spf=pass (imf24.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760441153; a=rsa-sha256;
	cv=none;
	b=GyDqVeyKj3nBbkBGBaN5xKrKk68j3FTfaY+/qpTbR9FPm7KGGRrAVcS19Ppa7dahXxJOBv
	Jm0cba3K9jVcqWm7BkY7EpSyrhgczuIo/mEw6YRjlAd9rQz7irsTWRHGOyl+Et1vhRvNG5
	gdJ+Z2GdxFqWe1ItCp0/BK2ubAER/zo=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-780fe73e339so48476597b3.1
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760441153; x=1761045953; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XVuiIrau97qjpcYS/102JQpRxXMYJ1qlunE5ky/iKeQ=;
        b=A2rTqJXJBdg3wuTc3Wu2ZJSXw88aDfcPCx7BU/gBNlGCf/jgGHQhYfABg0oL/QhvOy
         5VJJMklFPRp0B4/1I/toT+KwPrq30/Lk0wG1d7YHnmtwQgyyG6SH9Nlpc+glAKuCWgdT
         wl6KbkHwDNFyzrwKFs0qmzRsTaOEtIvVjEiMPFTwZ91CUsbh/RGbWdlpFnC0zVUdnIPz
         DaLvX4NBGKBF+DZmYvrelaS2mn2uLovxna1VW0zBAeYS2UW33IAPpdS+N3FAnzRA+QL1
         cg9RysTj0avsvpBjooE9ZwwqUnbHVzYzkmaB17MM9lGV9NGxmoxR8+H4zCHiXakKEMRh
         0gyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760441153; x=1761045953;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XVuiIrau97qjpcYS/102JQpRxXMYJ1qlunE5ky/iKeQ=;
        b=ZDYVHakf8c5ffOfm3dLZkVOxm4kAhAywTOtEE6axmO/nSIc5Yt//+Tr7HMGFLte9wO
         CUyUv9TRrvdM1sLoBSmoXLsEfhwc2PhfQa+aBsIBuW9REvkq8xsLq3Iw+MJ/AQtAhdkC
         9hHPz7xKeMMl6T+84A14ss+L2Vn/YQ1sGEgZZi2Dx2fZ0p2GTx99y4dBZkO7gV4OxFg/
         e0CRcVCLXva7c8OUaWVgSFatWjFWISBMYdXydFDhhhHfUM+28FRdOAG5DAp0+nbcWWH/
         wvuYuEWth5ZrcVlE0xgj3qAKTUHjeuoBqaMFTP1Xd9WhhRbIXv8rZSkE4Lv4O0N6Vdwl
         GcGA==
X-Gm-Message-State: AOJu0YwMMfvlHXHGtCm4XW1dEsoFND01TyLAM0/5vi5YtRegjlWR/ct7
	qL8EkNmruz0+R0wEPJMyGm4bWlhsB70i70rw2EsWJa3FirPn1Ci6umrSu3LqW0UU6/5YD/3ViJC
	4ksUONiVhVp3gOwlAznZys1FqJ85no3Y=
X-Gm-Gg: ASbGncu7HC/eyCwv7wkH/+uWyE0FCN2eArpNT43SdnJ92yHTwCVsNmSSNgL8Jh5Fytj
	EsDlp0jTlPjHsiMTkIstlZ7u+bCZC2MkhihbWVdIGrj0eScZgLWE2XyTwxfbGH4/d4kAabiuwYG
	DiNb+cyaBIjq2kY8MXt21kijtOg5zPTQr1jqoqu6gOpiujUekuWKesmbc5WBVq7JlIHkUNkiomq
	BoH8QCG9wmTwyGJ9RMAm0mc0TS/duaMsyalC3j+g8YyZ4bQQIzQLonTSly02Y67OQSgml3qYpf6
	v+iG42T5OY13v+UUvDyneJmwIA==
X-Google-Smtp-Source: AGHT+IG/TDprzS6OG3Gn0DVpuSUmx9MXD7CS5+6MCCRpdRxXQxD8wLaVu7wXm7e/LRg2/prxvED50OPG2W6DCb8Dt9U=
X-Received: by 2002:a05:690e:1555:20b0:63c:f5a6:f30a with SMTP id
 956f58d0204a3-63cf5a70840mr10000269d50.33.1760441152685; Tue, 14 Oct 2025
 04:25:52 -0700 (PDT)
MIME-Version: 1.0
References: <20251014112256.18793-1-kartikey406@gmail.com>
In-Reply-To: <20251014112256.18793-1-kartikey406@gmail.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Tue, 14 Oct 2025 16:55:41 +0530
X-Gm-Features: AS18NWCx4hH1KxgcNMUNXomJCt-IsbF6ux9Dw_tk-C4GO0AWePvGcEHUjSQcr-U
Message-ID: <CADhLXY4WPxzvzuiZPJmhS-9xMqRZ_qf7ZcFf5MXPgXbgB3_Xzg@mail.gmail.com>
Subject: Re: [PATCH v7] hugetlbfs: move lock assertions after early returns in huge_pmd_unshare()
To: muchun.song@linux.dev, osalvador@suse.de, david@redhat.com, 
	akpm@linux-foundation.org, broonie@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B883D180005
X-Stat-Signature: sg3hfc5crxfux8m6ubryrod143uo77ux
X-Rspam-User: 
X-HE-Tag: 1760441153-545609
X-HE-Meta: U2FsdGVkX19xk5p7mHnlPSErQjJ9BbKnMj18Tatnks+uLs3iT3C/Ueeix0QoNENrwRIrY7lZ/UKhxnu799CaTAhUPKIVAuMjDT1IVp8CI5s0Qh5Dqb9VSEIO5xD/uzt5g+uLDT7bK8i6z4pheS2+mjaYlRceO0LcSPkAeHxqJaFLavyTgagjCuxYFJDV9PpMqa+gYIWFfKFUxi0kfCoCIasbcNCMLdGA6fa8Z8cTZslNUZ1Cl13IIZGqQXxxhsHgc3Fr27nu+4H2UGE8yu6tQ+X5OkVwOLJVLol+FmCTrnQLgTr4X1nI5UZGy+oKHL3f42fwoiopmnrLsX/36oAUSCedfF/JBcnrX7XTqe4/7FEGkXoewFzklVSdVBUo9AD/xy5zMbUi3ievWKc/kVCvXGpgSfybtXnaH6NmI2iXWB3hKKMQr7MLBILK2/9Bnn/IBNDub/L/W1FOMpln4e7upSAFccsx9BuSgeN57HlpiTr0kPspxd57V8amPpT+QlGlendhM1nk2j8EhuIQT2aTUBGI030Oje0OvygDoKwEZoh54hXAp5nlk4WribbbDHZ1pY0E2V71UrJ4Vou0t0wLlv6yow5DdwB5153oIuydJUEadkFFroM8XQEeJ+NWU9uj5Y1O2muqJxP0OViTx9wxzasGk9yE0qVZCeZW7vgyHal0XaQpNgk/NpR4+Sf9sBogKas+E66BjxBcQ/TjN+0ypYNNJHiSD4zwNTa5EuVpLs6/9pMwAywfOhXclaOwNw4qQEBwPB9kkweyzWRSfVAvjL0pHYVvHwCJxUSJmHYcy5piJSnpdOSQv7E1lNvS/S+snXd1izvtvecQp3N0xE36YNkPDuVFBMlCi73bUP/m/ziCx/NiOZsply3eJ57Q2Fveuvf54wHYMNIBLegxjheqcUzdAGXeLUyXGMQt80ZvHkTTwggz4PDYwA4vmk+ZquyqRyP8PL7Cwd9jG2K18Yy
 4Qb4/m01
 1c4fc/KjElBUoPlVGsDTp1z9NsvPse5Khi5XN4sUV43U9udf6cvQsmUUMcHvZpBRgtthj7GD8uOWrzzVVnXLEcRBSOl9hKgM+uQyu2YfCbhLLsDLzrgi6JjUwGSKNit+MhObytOVZoncgKN6yplYLNrDgRRWMCGbl+ejk14Jfiwra11y0/9qkEfh063ck6/3rKVKsaqp6q3xcjNbQFeHkrxNO1oQDZW85fmAyKVo99KRv+Kn/CHMguQ+GnK7l/2h5aQagA7Iw72U2Cyjl7RCFyh6ageAgG27QkFVLsQSimighHvxakNLnvVe5eBlWaHcrHvIwqS1qPgDqxnw0LLr8ph1AV/ElIePzpT7N7cNrOBpzeKv95avBjbhntSgb008gkuT6QiwOa2zo733JgMdbsr6iKH/Lk4RQPv0UdjfYQbLZLc1gPEuenzsURdGzG0OrZxK5cE84lBBfRVgk5R5uqM2HtG7AE79DmP771VG4Aw46Dbzu/RlT/6YDswfUjAVNFe+83/NyLbSs/Fc9CUXyLnmy/a1tSU6cIXMJ8S1r1hrFKCQqLBwuKLAxhA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Please disregard this patch

