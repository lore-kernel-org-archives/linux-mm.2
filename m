Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2900CDE03C
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 08:50:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C3308E000D; Fri, 14 Nov 2025 03:50:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59ABE8E0002; Fri, 14 Nov 2025 03:50:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48A0C8E000D; Fri, 14 Nov 2025 03:50:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3733D8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:50:49 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 109D087C2A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:50:49 +0000 (UTC)
X-FDA: 84108592218.24.937BC8F
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf20.hostedemail.com (Postfix) with ESMTP id 470CC1C0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:50:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SVkwwBlW;
	spf=pass (imf20.hostedemail.com: domain of peng8420.li@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=peng8420.li@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763110247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5iqlkhn1lw6zbavFQq2qrzo4NEBEKZJ3FEyeS/ztizs=;
	b=mx5yq1nuPCQqpStQjeRoTPT8sBsWvFZrsZuSvA1UkVmsXlrZJR2QK9c4TmbU7Eor2RqNN8
	JR1f8kPR4MWtbPiHZ/yzJk9uMlOpz7AYTo1rIBmEoHohBEfrehXYexLR9rPvNiPyUStQkT
	NNa2Dduk83KNUES6gz5subtt6wqnGBs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763110247; a=rsa-sha256;
	cv=none;
	b=IVY0llaKDG+kM16jDAhbN9wq2lShJyT8CiZQ3N1EjOWAsnKf1jtHLn3LPq3uPq3StmHQy+
	WpVi1/nsDJMlPDA3r5/QTg0Rp7A1Evxw/10qE/FCsCrGGQQRwMBetgaWenf+XsPNCTOsxK
	agIbwbjjMJwxBVj3scXIdG4G+J1cmCo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SVkwwBlW;
	spf=pass (imf20.hostedemail.com: domain of peng8420.li@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=peng8420.li@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2957850c63bso17932885ad.0
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 00:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763110246; x=1763715046; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5iqlkhn1lw6zbavFQq2qrzo4NEBEKZJ3FEyeS/ztizs=;
        b=SVkwwBlWsUTP4AtCMI4xY7O/wU4l4Bpd7t0yxRWtNQhSUvx+TVvJ7OUOvR9JS4Mh2b
         CM55PIgZruXy8hyRFvz8kjjq/mR168k3u70P3rA9GgZO3hiagJtXpWDvI5US0vl9hS0F
         59YhZSLEpInHub5Zk0hZvPnWXha0fKW3LQyz3iwNr8YBcYIQ3RWJulu9U/LuNanfYMTx
         ZCVK3T9OpxTu7o+a8zQveF67EbO+NdYupiTpaT1Ry5br9+lbCCLbZSr4XOTfgqaYNUOt
         zVrsOWDFjA3ablxCrxcV4jDARtLVC5rBSqTx1qZcolkizqwaJCu88BEx2djYxTHpbIYU
         SxLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763110246; x=1763715046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5iqlkhn1lw6zbavFQq2qrzo4NEBEKZJ3FEyeS/ztizs=;
        b=vS5c0MH4luVdJ4GZ05mKxlilw/EEROL7nzkw0njrTGULjGqvsZI8oPaoeDwmiHHuf1
         tGos/AIAz6e3X2g5DO3S5DME70fhdKiWhZe09Agq4IfIiRPBz+0tHkfe4ZvXobr6T/MF
         SGm8Qq4MNUG3ssQ6XTDwEMWdEXCbGByr62KtAq+aLeHvwLf/OqnzKtJA/8saNkZNvmoK
         UWSlbhmIQn7nNdZOulRKYNVDvQmPGuTaz2aici/A5SzAloapeQ856FBiO7QhbKgwFYYo
         6X8J6yTubGZGvzs1+NWjQVYWiyDvuzHw2+3V/gOIDQOom2Z5YWzaHU6WtRLx6alpysmx
         4aFA==
X-Gm-Message-State: AOJu0YyffVqfC0uxEr2WEy80l7AMJHB2YBgYG8NLW7rtI8QakKK95/TI
	2d5jDpfLdRde2SVL1F8puM2iZ8MJW/XVWXf8nN/dChm7UO0qz+j/dchE5ywcsea8WFFxmQ==
X-Gm-Gg: ASbGncvAZJ0gDagDYyhGc365babEMVawRLq3f1pP+mxuu5h/uRtpJi9FpffhiKBfS3s
	UBlT9OAWWogrGFuZZldZdDnsX6U5a9+JxvC3BddRg/FbLrmCACgXwi4mtXiAkklstGYGPlMVkEK
	SpRk0C4YWgRICzOZ0J6iW6VvTGg6hbhkv7b3ezn9TOJJat+DKsFtpVnNFY+5WJuKbPBHX4pkcO4
	HhI3eyeZOsvuIwFaZnm2cG7xNARZTIPUSKnPzFrs4Fosld43p5AMahn1UOFP+3O+ks+F+XV18sZ
	hX2cYKGrqiI719o5djWF2om/NCCw36rJABUgfnkgWp1Nvxyt1/rSu08nOxT5h/NPEHrT0Zr2nLY
	w7qfUWY0J2uBdi69iCAk8+X0rbJ7co8Sp/sjiMfw67zors1oQmwruw9LFefvIthBzrPrCvtfKlg
	w=
X-Google-Smtp-Source: AGHT+IEoTb2nBTEj517lc6DIrCLOTCTDzfoLccKyXuEPJE74/I6sGmnlo4wGjvdHF5T53dtdhOD0Jg==
X-Received: by 2002:a17:903:2a86:b0:282:2c52:508e with SMTP id d9443c01a7336-29867eea832mr29818035ad.8.1763110245849;
        Fri, 14 Nov 2025 00:50:45 -0800 (PST)
Received: from gmail.com ([117.147.72.154])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b924aedb73sm4459368b3a.12.2025.11.14.00.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 00:50:45 -0800 (PST)
From: peng8420.li@gmail.com
To: linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: david@redhat.com,
	osalvador@suse.de,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	linux-kernel@vger.kernel.org,
	dan.j.williams@intel.com,
	"peng8420.li" <peng8420.li@gmail.com>
Subject: [PATCH 2/2] Fix the name of the source file for the "FOLL_WRITE" macro copy
Date: Fri, 14 Nov 2025 16:50:38 +0800
Message-ID: <20251114085038.191031-2-peng8420.li@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251114085038.191031-1-peng8420.li@gmail.com>
References: <20251114085038.191031-1-peng8420.li@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 470CC1C0005
X-Stat-Signature: 8rbup9upn7gum7ibdi8ptcimefs55dxi
X-HE-Tag: 1763110247-323411
X-HE-Meta: U2FsdGVkX1/zoR6XjHgBzIWdrfJjj2UHKawb2Xa4eoU9CZJI33wKA4hgc8NX0GDKZHfmI6flb67zmQysWl7glHBy89EEgKTVG7SJdYM1fEO8ImAOHlSDJphg4oGChk1FcqUd8fW0q8HC28xz9VkvYC8r/7dymne+jEi8tcAd+1S+zbYxWPRAY6C+vyFr8BIR8s0EibrR6P9fn2X0vYW8LsZ4E/Lo6V/rOnXGk/FGn0kcXMmTTSVAtL/x/kJqS5jvLbW5goexp0ZK210K80KpD9UwWSuFTGWOuGhi6GCZUu8e7B/Nsdl7B3Cfxr0e6mu3fYocv+X/F2junX+U9jzxC/KuD90QQrzDh5G/aVPUZP311IpLgFJi0baEFiB5PRqECkkJJcnoHh/q8hrGtzduRsj7OZSRavxlow9ZWRrBvGHS0beEwl/HKB514wrNImEaqxxDWb9iMp2iyZRr/D933OOC0A2NPyy6zswd/PxxSiDoze6/Ko29avcbhY6FazrDDxzee3fhFr+mTCtr1FYewvqmcIcCWdau9FYWQnn6aJQAE0Z+OmHznoU4TYUtArgG7oR6GZcuLNRthWQMhKpCW4jq5W0NhTXtWajZVj2/o8aJOcK8RqWxzHnPAKF79PHbns4zvGhHd/uCB1Yor2gNv/CXDiqsgXTVe96vcZZvkgadUgR6TjvwbFB77lC1R0zOwRvW/B/6BVlj3Vkp+PB6o7xa5o8+6CGZ0yjoEmPp5EHO9iesFg29mN70a36gdLXssMmmq6AF/x1CuCwY3PvV2LkNxpq//D4ZHFu6xBAbRmCYE/8oCa+RZDZY9KALXgk9zy+Y2pmTlong+AMBwc8lnplAgbGAO0uXgjFqFV7juU7Z6gxTDJB9zhoDHWUN/QSgJ38ISUt+mQSfrNc3bg5fGak0ASV+Cuw6K7vwZRZNWKsweZ67kEsENQNbclrvubzBlId/t0jBn/W+OrReZOy
 8ZGvsF29
 gm5KhcswXJHH0kV+ZqACpW7GxpHsFERRqewrJF9Rs+OE8LQRB3kjfPIyTZaxaPQ30CW4coe73AH7I9vl5IvPwhT+t/AsX+jnP4PKiV7c6ZZDJXdy+pPNr4rwOJiYMy6OpabFzyvE0V86AQwarfGTzJj6dxJDsCzDAARDiZIls5OjQmmOPsMae0sWo5LYRQ4a/kNwhy7KtJ10kynzVEcA0EanGGZc+sM262bG/Xpi2Q6q+ijWRYDeTGmJWt4M82j2AxFo/pXOuplDqMYQqePinLsHis+fqo+Mw5ruHhhx6dVhsrD1661GoKdT3v+Xxl6TCO26qQCxRm8nxiCrdFgZZalK2NmQLRVuGCTFk1pYGXtDPHMzfypyK0HECy9/Hz+wpftLCzvqcTXBNfKM0aAuqqh6FotcU5gjjYrhIv/cPEq+QbffFM/K3/waClpP8Rn/yEYkYJ2PHvVKIIF8rU6A1KTlp92w691yCvBL8VfYOiLoNUkzr8KuM+wXr6f+h3wlvqxhcuzvNz3LTNxDl/j0/fwwtKiQ0SckMZqx/GEe3D5eyke8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "peng8420.li" <peng8420.li@gmail.com>

The 'FOLL_RITE' of the copied source is located in mm_types. h of mm, not mm. h, so fix it.

Signed-off-by: peng8420.li <peng8420.li@gmail.com>
---
 tools/testing/selftests/mm/gup_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/gup_test.c b/tools/testing/selftests/mm/gup_test.c
index 75f7134d529d..9cdcd10d3f6a 100644
--- a/tools/testing/selftests/mm/gup_test.c
+++ b/tools/testing/selftests/mm/gup_test.c
@@ -17,7 +17,7 @@
 
 #define MB (1UL << 20)
 
-/* Just the flags we need, copied from mm.h: */
+/* Just the flags we need, copied from mm_types.h: */
 #define FOLL_WRITE	0x01	/* check pte is writable */
 
 #define GUP_TEST_FILE "/sys/kernel/debug/gup_test"
-- 
2.43.0


