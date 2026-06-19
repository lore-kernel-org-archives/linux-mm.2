Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF4D3CD98F6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 23:46:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 991246B0005; Fri, 19 Jun 2026 19:46:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 942566B008A; Fri, 19 Jun 2026 19:46:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 858386B008C; Fri, 19 Jun 2026 19:46:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 63D256B0005
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:46:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C0FFBA0604
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 23:46:31 +0000 (UTC)
X-FDA: 84898298982.15.741B4C1
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id EB0F2140008
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 23:46:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lk70CKam;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781912790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/XIgL7MJMVO+5GxTwo0sxuf0mtf2khWAl88EGtPeN5E=;
	b=tpdhKtGabugccdQhla2h0UjfwXMaVs8icEXb8yArGP7dbTjZ1p99r4J3tkdvyKJwaW7m2z
	OolRgES1mtqswN4WvQ0VN9ky1wxDmYxB/bZGTPNqa8cMOdFifO+X8AxCHRlrFCQbXbCj3G
	T9UM7nrpfDNj3TWBFDPEfjqWx9SSjFo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781912790;
	b=UDzIB234Y5AlRZzmwuqKYDCWqK5di2Qok3nF8LchbZ1OKr5FE5I6xAd45vxXd/nLB7h3RG
	TZ7Tqf9baQAqG1hJXi5eUS0SW6l0pcKeOvXOntDCum2Abt8eOWHeCvgv9gumA0qLz4ANvQ
	Fs9Xzkr71ia+GGi4vn2yDVOOcfjWYjM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lk70CKam;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-46066e640easo1583768f8f.1
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 16:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781912788; x=1782517588; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/XIgL7MJMVO+5GxTwo0sxuf0mtf2khWAl88EGtPeN5E=;
        b=Lk70CKaml2Nfw1GZQ7VTFW3ugtwFdqfYNqCtgLxLJgxyz8GZ2CaJuXZmGCdVfNfrv6
         UmXoVlcFclms6G1pasiXmzyTwycNhqNoN+dXa+9JrpAyUFznXPEC/JDWeYWqzhjiYTuW
         G6yRrLqFSQVGtO62kciyDCDivjNHYwbZKeRO+oqRlI6bUGXWCkDnp88i5vtdxECLAmUX
         TD4reGViW+K8/86D9+p/b6GST/oHc0/ioFSm/y2ewUxjwt4FGy0lt0pd+2Pm3Gn+BFXI
         979TfV9KDoK9PLxGmonAaAd9vgQv7uHBEG+f0yVUkaBKjjswOtXyo61e7J/tLsPd3ZV1
         UmCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781912788; x=1782517588;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/XIgL7MJMVO+5GxTwo0sxuf0mtf2khWAl88EGtPeN5E=;
        b=DXoIS7jMirQ1TYLoN32vkcb0DI17ZtI41dd9MqIz6w+P1w8GYcRLU2GAkWWa8GGv8w
         K63bC6OkI/OsR+vFT5QjSGpYNkxh49w+jU2/A65vjGLa01LN6A/Y87qIOujVmuZNxIgs
         9+HaR51i/VlyBtr2mZ7qkO4U/sUcf3e+gwCG/7h/TcP6n5LUAGy+CMyQkhNvSoigS2uf
         gVyVrHArcpPKIAzfAZrKbfS3BEBl9fdEI7E30GyAAW9zU6ka9IvWyQgCf0j9a9+PeoFO
         vqTY5RJSwtugvUfoXBUBmro4G7NHJQtKTc2awZkAT8HhuMcUcOOr3qXjPFkfVICIytTg
         nfRA==
X-Forwarded-Encrypted: i=1; AFNElJ/0Ww4tqcAncKyHkgBCLr9FWCdj+HjYCySyIIKoSH34MlruqLMhbeN3NpFDUFfy9nWS3zm3T1Q4VA==@kvack.org
X-Gm-Message-State: AOJu0YznxARvnnIw4zW9fvZB+E9ACXg6LfRhYCXoafZx0jMU5OmKLQgf
	ByNyZYcLxc2Bv7oyZLeFEG/d/+6yx3CkY4y3A45jxAhhprKckvWSDGrG
X-Gm-Gg: AfdE7ckzAqzjWBaGZgjTlefVwztZCpfd9r48lXu/EJBKbDGKbbCqsIU5BdelT41SGP4
	HXohkGm0kJGsLVgY+TG+K2av7LGcOykw0bn+xDlvoO/l5P6sHq8VKZqeN1GQqlvfTlIcHFWmj62
	EN7ELw2c5yIpnCBWjhTcX+WxrO+Jhx/A5eks0qc9d1OJ14e/PQaBZjI4wreaaw62rkmpzbTd6CZ
	lX9OZ24WSit87XCO4wA96iECeWOgoWpNo20sWXii5yjZ+eroklR/2po3V+gt20Qq0o5V26Oh/jT
	jrHo/v5uEJkZBZbwMEnUeQw3mawzS+sSdUZRCebRelE5z0SnUVhMv0C//REnBPi/SLrnF1AhJtJ
	J/OJA9eNM/1QHoh9JSDlw46HKbsBVhaG6Tudspz1ZTbVscuLbibk2384WXcY2G6t1slejRF5Ndg
	D1CgkXhclKhvQ=
X-Received: by 2002:adf:ebc5:0:b0:461:a15f:6df4 with SMTP id ffacd0b85a97d-46509f4d2e1mr8175738f8f.35.1781912788219;
        Fri, 19 Jun 2026 16:46:28 -0700 (PDT)
Received: from user ([104.28.163.163])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-466667882f7sm2868027f8f.21.2026.06.19.16.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 16:46:27 -0700 (PDT)
From: yahia <yahia.a.abdrabou@gmail.com>
To: sj@kernel.org
Cc: akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	yahia ahmed <yahia.a.abdrabou@gmail.com>
Subject: [PATCH 0/2] mm/damon/reclaim: fix initalization and parameter issues
Date: Sat, 20 Jun 2026 02:46:04 +0300
Message-ID: <20260619234606.221163-1-yahia.a.abdrabou@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EB0F2140008
X-Stat-Signature: hmzf7dxi18h1nhej5rhmdmgwk9rp1amq
X-HE-Tag: 1781912789-747602
X-HE-Meta: U2FsdGVkX1/hmbYCmFNwahdID+joCfZ0nEMTUSU9w+VUkmhq2SjJ1+91D8kABAwzNfgMjkAYpzByaLJBLwq0KFiDES/NutmjJ/w25vuoJ2m8h+ArHGokx78Up5jka0jpB+fRC3/aGurKCNB33rdEkxl72d/r4b1br/JXopCNwYIWVG3Oq9YpzFsXAb9anfAcJXUqF8WAGNQKAigG5mHIiwwwoY0DWPuPJWygNt9pK4koZdJr/ml3OdSIqUVyK/4rjLIbyRTKqQEROceG+yBo2rTz8C3i8ReTQq9PYcqLGHWLx9DuFjPwZNRxTsxj0lf4Gb3wEWtL+KN81tCp370bBSUt6nt2paHBW8NgrceXcmdoMed48gWtNZj27I94XnsQPUBFlcWl7FhEtEdPtNkV1EJJlDeKdEVQ+WQ5T60zt4vzGRyO8qCMiK9kvag2Ry85WgYDVeNmYMoDiWRwXDYkhvD8M1ymkoww4R4Cu2ELYwQdMcxeWnRPaVEeUxhR/x/jGj/CCo3oXP6dQsTr4OF2zItqM9TPiQKKnKIGAxuZNncRpIZLsfV8BaMYs/E843wP8gw1gtCs9gI8AKi9q5usZz0aS+UD3UziMcSPSzxWGxPQlWsB57mDSAxalcJreVmVI79MYiGPAE9BVugT4seXMEEGn2vyvHwFZrAV4LI0mfgUJt+5RfZWboeFg6UOEHFTdPVoRIo7+jHw5YZhu6Zrq2BMnLsd16cJ5sZ/UFuWpFEX/Kcf80WpjssjBon/U2IJFMmmwpS5jDKnCDNC9sfUyrgne0TRici+Gp0I0jYoNovfbcSRB5SRVGz0j+Ea1Mwx3NvDTUgOt4vFqDovLUiWMmPuAXFfRyb5IdqNwmZt7cUpc6z/oCm7TYviCzReRztBHpbmkcJ/zVJUG/90G1Dy4l6IQc4y9SQ2kssUuIfaX0Gyik1znikPU0oXTENn1eA+bQvfl9mZdPRJN6qkaVR
 He0M3Ig7
 Ksce2st3o24TY76e71yTxGleOnjdOBBpKO7YCrOYrfd8MY/4XikH1U9Y60XfZwh+qlf9PPeJ1rRE9ZC3Vuk4bRHRIy3DNoVxsrXcDhDxZJccbrMg5sU/HEpwD4ze2H54tHgfe/WdLOSx8MH+aZUF16Pguz4KDhVEPIHqnAk/jG0ZuHRkYNzICpMFzzwY/6XbaOeiTQ0obruXdL9ztajSN29fpmiaHMSjQyb8nBpwiiZw67CYiKCq1Hi36z5mHXMJ/x8iCrTiNCSzwW1A2BkZGXijIU5usBClp/ZDxldVNE5zBAMK5Uwr56ozm3cFxitwzu+JbM/HwvOZIRiq8cHqsE/TnbBJqCSG5D0cpNbbnBoFco49ol13vic+H1oWAxQSzWcFXl/TGL2lFWzQVCO0vywMV9Vbszqb3k496pTHHkshzPB80jHw2BkCbw0dH3DMS9OPICtj7hWzF4W71T/qcz9hJGw9LUM6o6uNhqZBMMknoCOqM5IZrC7RKqAkJ1ftd2K3sjIodN1vq7Ro=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: yahia ahmed <yahia.a.abdrabou@gmail.com>

This patch series addresses a potential memory
leak in the damon_reclain_init() function and a
premature destruction of ctx if there was no error
in the damon_reclaim_parameters() function

yahia (2):
  mm/damon/reclaim: fix destruction of ctx
  mm/damon/reclaim: fix potential memory leak

 mm/damon/reclaim.c | 7 +++++++
 1 file changed, 7 insertions(+)

-- 
2.54.0


