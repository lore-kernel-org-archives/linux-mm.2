Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68CF6CCF9EB
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 04:34:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F2748E006D; Fri, 31 Oct 2025 00:34:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CA3B8E0045; Fri, 31 Oct 2025 00:34:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B8A48E006D; Fri, 31 Oct 2025 00:34:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2A2478E0045
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 00:34:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B2A9888247
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 04:34:09 +0000 (UTC)
X-FDA: 84057142218.12.165BBC9
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf11.hostedemail.com (Postfix) with ESMTP id C703040003
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 04:34:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E7HsQp5I;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761885247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8oE9JQNdIr2S6AC34eXeEphVmop0Si1yVhh0HmwvbZ4=;
	b=6OIpZXFcW+mhnygc0gPHx9+IN+kGvaMb99QJgLnHlIJ1QuB+ktTlENn5XinGO8eJVuvD7g
	mGy2BDdEgZWfvQUzFB38HTekPNpf6882nsXx8334+2eyrJIQNTYnUkW+xGfAsU/5l1jY6I
	juQypMSyoPm59kim2qAf5lau2pgD1rY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761885247; a=rsa-sha256;
	cv=none;
	b=0XshUcpw+KAhui8ByO+7v0Wdtp3NPoi4UOL+WnR+5tgjYNpvpzj2RkbRsEz0OfttKkmU59
	5iBNhtA3B85nXE3R0yeiq5Adg1sp+G0gHDv3CIPWAWyrG8H1dvWvLXEgHNpmIdwg923gNa
	X0rhslMbAtV8kYn6NZPQysYCIgPlEV8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E7HsQp5I;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-782e93932ffso1830831b3a.3
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 21:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761885247; x=1762490047; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8oE9JQNdIr2S6AC34eXeEphVmop0Si1yVhh0HmwvbZ4=;
        b=E7HsQp5Iuazsdm2lMoV6QdnFr3s5xvdBJuZy/ryEw/mSY7pkvCPLAmqiGLA6pN5OQ/
         ROcOf3Zbag2H3RsvDjs8XSCu0WfM2lif4LlFkrPcokC/OodSWZb1pE81w2tIY3de1ucI
         MA+Xna1GGCaPcVb0nB7DxcfJcR7zgcN6zcq53HprhnU3bpfaLL0bVW4A1x+ViXp7v3It
         HS3r10tcWs86CIxe2pPykD/rzP8tx3U/8Iio7GzY4OFA7d61ddLlTY81SbxjTLnq85Bt
         ZNXejr+F3khdCMHgdckCd1Rfse5kR+B9SuTBoIFPR8qL1RsnhZrZLPsyee33Br0bP3nx
         FmsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761885247; x=1762490047;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8oE9JQNdIr2S6AC34eXeEphVmop0Si1yVhh0HmwvbZ4=;
        b=nfT32InKg6mLb9S4fjnEP0hCb9xgwKa4WHpz0LVhQVQl/vrkv2iOZXLdc9uNc5BFw2
         C8uwIP5y1pzt83IJOtjCUsB2FHTY3yAVKj7ZTGQGn+5DbAYPUk/X/lnHhK7Jeo1pG6ep
         45rrgk7le4omk7Rs7aX9RuSL5G52+NifY99AItTB6DNj6jw9IkaLE5Y4HTcIH/kTvPaJ
         qNN6/FR4u0kO41Y6l3ftXuHqBz3uIwbCiwOGNRKBbpX4TWVPZ2d6FhK8yjVKmyZ2cZrD
         Z+lBLDxbJNHLFdnyDJUabEyIpRUTUuYxsLvI39xulMaD04Ux9VK2gy0ZMvpR/CNZG0JA
         1WbA==
X-Forwarded-Encrypted: i=1; AJvYcCVpBIdfgahAZ6pA7uFlYQuVMnBHJcwFkYXFesNeLx3kOmCzv3JiIYvw2Z4iE7jHVBeNby/4SerLFg==@kvack.org
X-Gm-Message-State: AOJu0Yye6ix1XMkFtWcf0BI6CVITem93e8DQH37HEnnybtHW8IPV5MyP
	EjEksV/BeLEbv/RWBQ0R/fhZNG+qB5BJfLjZGp+RBH86y7nRrt1prXVm
X-Gm-Gg: ASbGncsBUbhGCpsGpPKEidhTA7TcL9l1jhGDFhMR4PXp9b1AJOUC+CAzuwgIRP1FMuw
	lyRh/hBK1qNqXQ0ewkd0QYyH5xpcP4EBeyy3J2mGvkWrci26oU3aP2n8YuKypwbqHNHXKcWZ213
	4Z2OXDgt7PLhLVRRNqUtqaoUrbB3yRxlYGX9y/aYaLiCeOQiOINA7GpH3nZOSvjNucn2VVG9yzw
	8/Jg9xqWp7JLZMoR+Wi/gGiQmADkOyAAJHRDPaJDLMPpcSvV9PqZ/5T6nXa7qJosfXac4QqsJ9v
	FthHZxarQir8xlhbheQCBwHuI+bltp9Nag9Mw0/wNw5Om9ZC5Hx7fuU+fMhKJVr89ANPQ96K2W3
	QZf6DY1Os0CHBdxBgP2LGKx+fShLqwxrAuGUuyRJvxytkYK04AoZhLTWF0LptnE4Va7bqUywsii
	PDpknZjxWL4/Q=
X-Google-Smtp-Source: AGHT+IFcwgVexeB6wDVdvipHJTWCcrQS3UvBXAtf/Vakf7r8dXNqGnnrZhcup7mg4kDFjYS+86zxzQ==
X-Received: by 2002:a05:6a00:92a4:b0:7a2:7157:6d95 with SMTP id d2e1a72fcca58-7a777952b44mr2476269b3a.14.1761885246480;
        Thu, 30 Oct 2025 21:34:06 -0700 (PDT)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a7d8d77930sm584989b3a.17.2025.10.30.21.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 21:34:05 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id F026E4209E4A; Fri, 31 Oct 2025 11:34:03 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Alex Shi <alexs@kernel.org>,
	Yanteng Si <si.yanteng@linux.dev>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] Documentation: treewide: Replace marc.info links with lore
Date: Fri, 31 Oct 2025 11:33:56 +0700
Message-ID: <20251031043358.23709-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2729; i=bagasdotme@gmail.com; h=from:subject; bh=Bpl9bS/WVMWM/ICcHkLvzN+RyuexkmOEFpCdccFpZHQ=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDJks1rZT02e6zayOFOtpuJjgkzZHMcOq/a96wr4t7hntb tKXriZ1lLIwiHExyIopskxK5Gs6vctI5EL7WkeYOaxMIEMYuDgFYCLhKYwMb7YIGGWvdzjbN/uF 9OfT+X35U619r/Q23E0VnNz2Z+VCoIrj24vv6qVO/1y9XfPF3amrmCWU5cu/typvCX936UBl/Do OAA==
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C703040003
X-Rspamd-Server: rspam02
X-Stat-Signature: 7ufrc6ugnaibmxj6xzkn4zzkxij9mjg9
X-HE-Tag: 1761885247-564129
X-HE-Meta: U2FsdGVkX18HGI+Oo05Z6auHE+AyOPo9sfP+2oomy9t9TAb7ivnrght4seK8UXG3Qa/gB1XwFPpo6tfsg3aAv364APqKNLTWG0ElxYeetlaKBmmpb0qgghQWST4iINVi9EsXsg6hvXeTs02h2M47al6loJGnrDGM3+i/RUvtfkigVtZKhuSu6NEGmkUcCUD8RGbSzJ5vQc5EtNL2VmWd6nYnlsVZaaArf2hWB7eq72H5oHxCbNqLIH5UiaUbGe73hcxylQ+w9AMIVRGkX4/DBQmE5mLYkxUjE/K8IIcsdvn8jQibzio2f5vYtvIwiMP1YLPzlG88Q0lxkiIBPKrD+5QplX5KlZqa5ZaP6wqRsKoTtRNLcnrmsqL1Ya4Oy94TlfMPRw1EDApaMeUiyF5XyjxW5DbgR1t4JnX9cBaxnCghcKbzJyJxW/+rSOEbZ5m7SKsGx5GAPj3axdTGvYRlGdoWLR3FOdog7+RJkLnJqLWYwj4XcILiaf3gXusoF2eMAPFuQkRYeLFrLVs07tKXJFIh7ImW1MNtD3mLAMfXdxT8NjmrX0dQJCnuNZ4tdj5eJKPUY6Q0A+wT5xjNiJaa9M0/keQTezxLGV0f6Qs73uN49i7Egh2T2prvoBFVofsHRxlEWW6yjrwh3H1nIhzSncF+MCsPKaFC2j/2h2jQLDiI/JPVoopNyJIvPr1JhA5YmFVDw/Be8DNauAUNf2jPZ78JyYKxPBo5LkDVYPtqbT8Y+qqQGGjQECVLuulEykL1W2zNUIcCrWL45CioatGSWvXtUwsMTjoSDO0W58K9i4nzPFGNShCoVQqRnG0/A9ML02Sid7VYTERRdn8CMRxD7AAdoLxJvPmIMSf759hvlIl1I0x6kmv4xOQFLcV7z0KrVDp07jXIp9O0xaAeq3mj601RzEr5Bvg3/1qYLoKhUFN0d0Ih1zMYKC/XkpBvgmv+ZB26uGEip9cdp0uKh5n
 MOkOEiZZ
 ZlQ6kWAjXF8Mg5OHYa4UndxOKDp4qAP3DSePqdgq/qmZvqull2yHFy3yWca2aTZkwdbw6qZqIi7SCPJk67O0V4fH4OaMghlJ2twD/JXXGbe+/EsA35qtJttB9pbek6IqLaijCeoLdOxNl5LHrSzgqTWNUnYb7ukyuKpkkzo4lXLPxscpRYplJ31KTXhbwfndXmeXp9yPcB9abld3a7reKq/6ON9CyhxQEcwVLVnEzzSMclvPbzDa6EGrTtZeUYvBV/XbpXmJqSDeVia+cXC72smHSxVCT7Ayd5tpDUvJUYCL18dSJX1ophNiD4VbiSoVlj9jpnjgo/yqlSnKMUrAnFhWmK6RF3ivNZKPr26eW4hsOFsiSoxcgMHt9OeoLVhBDe4/Hbt+DUalM0EBY4LttNR1Nx8STdSXi3sQkipFi0U94yYXvOuZI23tSm0b6nZiKeAdcVSyVtPVRnOpkKlOeH8QnCUM+WF+Up4eud6FqnXj1jztfnFVvrJkWjvjZj7AqVrcDDOUh+RxR48zyzzz/WVeJPSoUBl3bnHniAJvvIIo2WROeIpAI+bX2U0MyBbt+1zYpVQr+LYxqL4Qsa5d/b0jA/k3d8YeMyfVXwxmCVRaJV57c5uDy9GfszUiqGrWGKnMqNQFmrhisKcvBWJZVh8t8FKJ+NFIsPZU6VeN0RTYQcgcjP0TGQd3B1geuDm0WL/xSxMcEOerAgbOdxhqPKelVHgQwP1sgN0961C4fP+UJMZ8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the past, people would link to third-party mailing list archives
(like marc.info) for any kernel-related discussions. Now that there
is lore archive under kernel.org infrastructure, replace these marc
links

Note that the only remaining marc link is "Re: Memory mapping on Cirrus
EP9315" [1] since that thread is not available at lore [2].

[1]: https://marc.info/?l=linux-arm-kernel&m=110061245502000&w=2
[2]: https://lore.kernel.org/linux-arm-kernel/?q=b%3A%22Re%3A+Memory+mapping+on+Cirrus+EP9315%22

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/driver-api/usb/writing_musb_glue_layer.rst | 2 +-
 Documentation/mm/active_mm.rst                           | 2 +-
 Documentation/translations/zh_CN/mm/active_mm.rst        | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/driver-api/usb/writing_musb_glue_layer.rst b/Documentation/driver-api/usb/writing_musb_glue_layer.rst
index 0bb96ecdf527b4..b748b9fb1965af 100644
--- a/Documentation/driver-api/usb/writing_musb_glue_layer.rst
+++ b/Documentation/driver-api/usb/writing_musb_glue_layer.rst
@@ -709,7 +709,7 @@ Resources
 
 USB Home Page: https://www.usb.org
 
-linux-usb Mailing List Archives: https://marc.info/?l=linux-usb
+linux-usb Mailing List Archives: https://lore.kernel.org/linux-usb
 
 USB On-the-Go Basics:
 https://www.maximintegrated.com/app-notes/index.mvp/id/1822
diff --git a/Documentation/mm/active_mm.rst b/Documentation/mm/active_mm.rst
index d096fc091e2330..60d819d7d0435a 100644
--- a/Documentation/mm/active_mm.rst
+++ b/Documentation/mm/active_mm.rst
@@ -92,4 +92,4 @@ helpers, which abstract this config option.
  and register state is separate, the alpha PALcode joins the two, and you
  need to switch both together).
 
- (From http://marc.info/?l=linux-kernel&m=93337278602211&w=2)
+ (From https://lore.kernel.org/lkml/Pine.LNX.4.10.9907301410280.752-100000@penguin.transmeta.com/)
diff --git a/Documentation/translations/zh_CN/mm/active_mm.rst b/Documentation/translations/zh_CN/mm/active_mm.rst
index b3352668c4c850..9496a0bb7d0705 100644
--- a/Documentation/translations/zh_CN/mm/active_mm.rst
+++ b/Documentation/translations/zh_CN/mm/active_mm.rst
@@ -87,4 +87,4 @@ Active MM
  最丑陋的之一--不像其他架构的MM和寄存器状态是分开的，alpha的PALcode将两者
  连接起来，你需要同时切换两者）。
 
- (文档来源 http://marc.info/?l=linux-kernel&m=93337278602211&w=2)
+ (文档来源 https://lore.kernel.org/lkml/Pine.LNX.4.10.9907301410280.752-100000@penguin.transmeta.com/)

base-commit: e5e7ca66a7fc6b8073c30a048e1157b88d427980
-- 
An old man doll... just what I always wanted! - Clara


