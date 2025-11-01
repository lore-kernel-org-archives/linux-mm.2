Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC6FBCCF9F0
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 03:42:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D2248E006A; Fri, 31 Oct 2025 23:42:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A9318E0068; Fri, 31 Oct 2025 23:42:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BD758E006A; Fri, 31 Oct 2025 23:42:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 062928E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 23:42:03 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8AC0E1606A0
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 03:42:02 +0000 (UTC)
X-FDA: 84060639684.23.9C62281
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf17.hostedemail.com (Postfix) with ESMTP id 96D2D4000D
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 03:42:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LYAZ56ZY;
	spf=pass (imf17.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761968520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p6DxzGsF0ReGwbytjfaFauugox95ZUf7zrl7UO1KLmU=;
	b=j9da8E7QQ/qcRgnMu7NCmiapdlvb9Ap2FZF1b8T2+nN4rmM5ywF7jUw05J+km0SyfRi2yW
	NMrM19daOX9G6f9mfgVPJXajG0DFuX8rTWQ98dMmxkezkKuZ2NHZGRAkKwlJAeNsYalZv0
	YvKK/AMrM48OuZ5o/a0L4t8hNrZg79M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LYAZ56ZY;
	spf=pass (imf17.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761968520; a=rsa-sha256;
	cv=none;
	b=hnRxYPCeN1Sd9dciPiwkwzkY8aocpe/sSajVuaZwUowUfjhjH25vmdxdFG/EfGK0BecX8I
	W48HHan9tujcFvyi5Je7/KYX3wtV4fDimfWTN6NPDfKEQNzNosKMYz2wGfx2DUN+C1JUiU
	HQiCMMsLPwgAmLWNYKDyAVlyZ4lUSbE=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-33d7589774fso3743843a91.0
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 20:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761968519; x=1762573319; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p6DxzGsF0ReGwbytjfaFauugox95ZUf7zrl7UO1KLmU=;
        b=LYAZ56ZYUlapYpbVevyzBrBeyNHDJ4wwC2Dhgw0JDQZ8xZcD1qyrHRdUaDsd/9aW0w
         nEnsCPu9TT0Cgw+kXFHMZvn8/jHUaI2Ek5frTS13R6UqOsW3fp053eACOLqJlehqjREU
         LxVMTdwyH/P3okKr2hIWOkrpNsQ5a8zHt9lOQEsKW3JDUboQJe+vpIrqI8Em6PIwE0Rh
         kntsDpFSrjlspQeISf6x9384A8wOc1xdwUNaBis6lRKIYBeIukDj268z89XmUUVGkRLY
         giEdR4Re1OyLP0Jcch3a2lvU4Z5gSvlhMQTOWNqLImGsrPCX+X4XArfr7T6hFB8rtQb5
         hJkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761968519; x=1762573319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p6DxzGsF0ReGwbytjfaFauugox95ZUf7zrl7UO1KLmU=;
        b=wH1HPWe1thB8b35rjcXqxgZo3/IaY2Q8h+CL83Nvn+1svCmuc5pMo6YTwsXhWD8bWv
         TICrV/rU5ffojOa15ync5HmhWLtR/7NtXkrYMLwqabdV/10nyHn2rNar/98DHi9HARoc
         KRgXoXxUnWYAHKX+b8ji0zolEqNqlrYEFMlUz7YrA5IquExxoss70qsPD4TVtiA8mvof
         MQtwdLXASyYUzpGE2ZL8gocdExUhlFJ6aJt6+Vo04rVycwqsXLaFFdYIARWohRNMmc1H
         l+buH+/x7VfxQ1c3JQsgMWmFsL4FbjohMwt8LuVuU41SmAz7QK4q1Ku4fdJCUe9VolDA
         CHbA==
X-Forwarded-Encrypted: i=1; AJvYcCUf2DhIzA54+mFPFVH9C9CsAhaEPYt9RT3jAd0KganBDDqhSYiOO/+5U2PtCAdZ8ePIjIjkZNvQ+A==@kvack.org
X-Gm-Message-State: AOJu0YxVQoFBQ6FQlc8O053PQA2lwAjboNmFRGowe3TzwvGIVLCwHGeU
	FDtKyWQV++z4BX8gHzNCGuVIulOqQiS5GRaGBa96IFYgCVkB+CH29Or5
X-Gm-Gg: ASbGncuL8Lgfutpdl6893OuHSYqXlD3U5XVs1geypqeD3nhx/fbiVDyGXMxpWEm16zK
	IQWHVr/KR727oqhQ0LCfoVASq6w2nG7Hz3HJhfdNYLGsTmhyh/3xVrrgRjHSX6AsTnpVGHKrKO1
	eeIt/FjdeJ2sr8Z72lCXXPTWeqLZ81CGV+kULojBQAfFyFdx86VvhDQnFUeUkIDWPPeHadFncmn
	sL92usqlmnz/jSoeoieMuaYysWy4JIDSCiEWrvYw0XzG/3sh2y6w8n3RRvPdWHkJDFt2132simj
	b4EvfKdoNPBLA5pNNwB6qQleqICGN2PfXvb5k+O9NYQyhvywQ8RAYKBH/8EYRX/Vki5UGBZ3Mo7
	A/WIGTpq2f2sO9Jt4Sqpsm09pv9xRPdd0Y2BVixQmYObsbQtoHitclrNYnKmMGn9fKSc11rCaBa
	ze1WJYaFGUr3j3oYhAh4GX/VfsgK9smtg=
X-Google-Smtp-Source: AGHT+IFTKC+45FAGjBsfJbS2jWqy7zIBFJxN0wNU7A4TaUwJWYWu38/fpztwMnb4h9wTzf56Tf+jgw==
X-Received: by 2002:a17:90b:1d47:b0:31e:cc6b:320f with SMTP id 98e67ed59e1d1-34082fc4ebamr6861404a91.5.1761968519146;
        Fri, 31 Oct 2025 20:41:59 -0700 (PDT)
Received: from localhost.localdomain ([124.156.216.125])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-340bae47beasm652975a91.3.2025.10.31.20.41.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 31 Oct 2025 20:41:58 -0700 (PDT)
From: Lance Yang <ioworker0@gmail.com>
To: bagasdotme@gmail.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	alexs@kernel.org,
	arnd@arndb.de,
	christophe.jaillet@wanadoo.fr,
	corbet@lwn.net,
	david@redhat.com,
	dzm91@hust.edu.cn,
	gregkh@linuxfoundation.org,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	rppt@kernel.org,
	si.yanteng@linux.dev,
	surenb@google.com,
	vbabka@suse.cz,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] Documentation: treewide: Replace marc.info links with lore
Date: Sat,  1 Nov 2025 11:41:44 +0800
Message-ID: <20251101034145.31515-1-ioworker0@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251031043358.23709-1-bagasdotme@gmail.com>
References: <20251031043358.23709-1-bagasdotme@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 96D2D4000D
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: termfh5811jfk8t6g9wrjc4tft3szx6w
X-HE-Tag: 1761968520-800194
X-HE-Meta: U2FsdGVkX1/XpH+Ro4ziyM47zv4BZbHHF3ejxG+0z3s5D3Wud2FEuIZbDEBvf/hxYQgyHZuSTwoeotGKIqMrr7IeDHpR31pDaiqXguqPnPqId6JIMlflG30u+a6OMgrZZDv40xiLkI2Zowc3/cj1ZVaxTd+oGoTkh0AxRW8fTBSeYI5GSqgBCqO//LbCbpAzN8BtaPqAtY0KvjkxxCAuvu8VkbSolwRxRZBkVy0IEUjQXQiGplw2YIa/aPPTqjsizwjTPo3mI1xaSsAV1k+rjl1OYTr6j/q9SwirYcfvdTFDG6fQM5R9atsvbYAAS5huIetdsHCcys2BiSyyM78eOew1aX3G5hDXC6Ovosa6nmAbRtb4oI4i+G9nEO/TWa2jereKJubZCfUaPzE1LrVsfOG1tyjy6k97QcBjdONlUIJKvUJXAwlxEbsSWCLE8gDp3IL8sIYDoeVb80kVKwALtAN5ZYDwIWOLF+bVChTzbA1ZyQHqf6E62hLDLmgiqiuUwlq+xrqflZ1gkKa2PAVRsE3F4OTUkvIzM5CWWaYPGpjATqp2NfgXJIBOYUmeQV7L34JG0wxDWLZRAJrGfoH7kpvifxg8hsLmJtDuCktyRi3KLsuUjd0Mf4xzKea2Cv6M6qWN/FZSaOOyWoNqj9C2+F6aCt8eaPFRjXfoEgk/TQ4auCFtT2Kmak/t0NLvro5WNuoAocZFon17uyurVT/0E17rkO7QRaFq9jmPvpLOsKAvBwgWJS0DnR4VFZvcWfs0w8qwyVmqqtO2jdrfAGgWxDYlj0AJ2WdkFcljCqqQJQaMmtZddg0bWIiq0ePXcfT4apH7ffnf5YUTrub+gR6AttyCbSHXbSSEVrRhXdeTa4qLibWz+bgd6cS9yniJLlPm0RQKQFAkyLPOzdOOyS/tVWnij/I/LtHN8r5+YwJTsyYlEBBxnrkopQgy//W/extr6Ey8wcP4m8Y3V/Gd7eP
 V7qSnaLq
 Zy41whfaTGkXe/0tn6oP+Uc+CNGcRi7xyuDhmgMKR0lgVEdh5bTPbcV7hZ8815ocbggQmKpUTDuZeNNKjJmqrsH7eRBZPy6lVrVEFEkcdA7MjyHgFcwBAeGFm7UOJuopBL0O0odamgjX7kKxxVMxAkEo51Et5KNUSmwdkqT1ONPd6jNr7eXZcHJgW5S9RBFa5uN7345f8Z01RoGigNR23ZdjguOKWF9HsAea+6086NhYz3EkVu2uA/X1xoMSUC/ui3Q/AHtThRq505/S4j1zrCJ9HVeDAU3btn58e66v6fh8lOzvlULO31Xfhtqj1JeTRehJsGzsLAMfWIIEoLZMAMR+NhozjXmx0JQ9CDzzhxOigK2x+q2G++OwDEbUP6eDxKILEvNMJgiaGaoZNVFDMgNe0v3KqMlUqTJizg2H8DkXO7stQbzjDM42LzUeozvOBKf32609gXeMGJmI1unnSWSFwgXKgsEOJ7A92IyWioOANEabYTWCYmZY3FkTtBQ1N8+IIkuJ7z0fNPq6cULLBtj0ogIVc7Jpn3T0oiGsb/xyb+vHvKcWXSN94Y2jBMVd+2j5Gmq7yhn7xH3Ho9ZbcfSZmllZSkRIkhc4etzAj9vaQCjawXoWOnKpiQquck7UUJuuQ6PXGlpV+GtYRcmdgLb4J0vKGiLsv1yXfwq2k5o5Cw35jJAUK/SwzmQ6Iv1S498UCZPIperMHvoiQsLxKvbniupxat6nvsbkPmbwJDHiVGSQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>


On Fri, 31 Oct 2025 11:33:56 +0700, Bagas Sanjaya wrote:
> In the past, people would link to third-party mailing list archives
> (like marc.info) for any kernel-related discussions. Now that there
> is lore archive under kernel.org infrastructure, replace these marc
> links
> 
> Note that the only remaining marc link is "Re: Memory mapping on Cirrus
> EP9315" [1] since that thread is not available at lore [2].
> 
> [1]: https://marc.info/?l=linux-arm-kernel&m=110061245502000&w=2
> [2]: https://lore.kernel.org/linux-arm-kernel/?q=b%3A%22Re%3A+Memory+mapping+on+Cirrus+EP9315%22
> 
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---

Thanks! Feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

>  Documentation/driver-api/usb/writing_musb_glue_layer.rst | 2 +-
>  Documentation/mm/active_mm.rst                           | 2 +-
>  Documentation/translations/zh_CN/mm/active_mm.rst        | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/driver-api/usb/writing_musb_glue_layer.rst b/Documentation/driver-api/usb/writing_musb_glue_layer.rst
> index 0bb96ecdf527b4..b748b9fb1965af 100644
> --- a/Documentation/driver-api/usb/writing_musb_glue_layer.rst
> +++ b/Documentation/driver-api/usb/writing_musb_glue_layer.rst
> @@ -709,7 +709,7 @@ Resources
>  
>  USB Home Page: https://www.usb.org
>  
> -linux-usb Mailing List Archives: https://marc.info/?l=linux-usb
> +linux-usb Mailing List Archives: https://lore.kernel.org/linux-usb
>  
>  USB On-the-Go Basics:
>  https://www.maximintegrated.com/app-notes/index.mvp/id/1822
> diff --git a/Documentation/mm/active_mm.rst b/Documentation/mm/active_mm.rst
> index d096fc091e2330..60d819d7d0435a 100644
> --- a/Documentation/mm/active_mm.rst
> +++ b/Documentation/mm/active_mm.rst
> @@ -92,4 +92,4 @@ helpers, which abstract this config option.
>   and register state is separate, the alpha PALcode joins the two, and you
>   need to switch both together).
>  
> - (From http://marc.info/?l=linux-kernel&m=93337278602211&w=2)
> + (From https://lore.kernel.org/lkml/Pine.LNX.4.10.9907301410280.752-100000@penguin.transmeta.com/)
> diff --git a/Documentation/translations/zh_CN/mm/active_mm.rst b/Documentation/translations/zh_CN/mm/active_mm.rst
> index b3352668c4c850..9496a0bb7d0705 100644
> --- a/Documentation/translations/zh_CN/mm/active_mm.rst
> +++ b/Documentation/translations/zh_CN/mm/active_mm.rst
> @@ -87,4 +87,4 @@ Active MM
>   最丑陋的之一--不像其他架构的MM和寄存器状态是分开的，alpha的PALcode将两者
>   连接起来，你需要同时切换两者）。
>  
> - (文档来源 http://marc.info/?l=linux-kernel&m=93337278602211&w=2)
> + (文档来源 https://lore.kernel.org/lkml/Pine.LNX.4.10.9907301410280.752-100000@penguin.transmeta.com/)
> 
> base-commit: e5e7ca66a7fc6b8073c30a048e1157b88d427980

