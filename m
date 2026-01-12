Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 634C2C9EC6F
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 11:00:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2FF36B0089; Mon, 12 Jan 2026 06:00:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDDC16B008A; Mon, 12 Jan 2026 06:00:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADCF66B008C; Mon, 12 Jan 2026 06:00:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 99B166B0089
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 06:00:01 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3F26C1A09CB
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:00:01 +0000 (UTC)
X-FDA: 84323017002.26.392A889
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4F5FF20004
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:59:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Lb+bUyRY;
	spf=pass (imf03.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768215599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=O8v3ZFPlFHD+erU8fwas9WJ8RphRIQqixRtXNSEarC0=;
	b=H8XnrtN7rR8j6MVreicbPzYkdsmSiQcu8mA8AEEXj42M21QLCKCVvj1xaknbsBxARdfrFh
	f2jarp+9lk6Hx9oX/S6NrPNTNjwfR5qFK2l91A9+I9rhf9x71sZFSjkZ7sNvrCJzngVGX4
	7yjIjgMnlUT0JHfiExpeUZ3CeC0HJ3w=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Lb+bUyRY;
	spf=pass (imf03.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768215599; a=rsa-sha256;
	cv=none;
	b=kQrmYeKHyhGO5wjuvbpA2JJNvZ8x3humVVmoXDWDfyAEui1O2BYg80C2n21Y/rYx2tfFth
	JsqQ2X4Iqr1vOswUVCgAJQHYpO5ZkkkcgC+e7AiemgCFKJXoKQCKXHKACC9CwiLBVOTMYu
	6yl9wHMuNfBlTzTozzXeTU3hfcp1BTU=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-81f5381d168so707827b3a.2
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 02:59:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768215598; x=1768820398; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=O8v3ZFPlFHD+erU8fwas9WJ8RphRIQqixRtXNSEarC0=;
        b=Lb+bUyRYMFZFdoAUZ6BjDKwt8xFxnrCFhOafQXDN5vNOC6oLkFvIjsnvjRHYTM67oJ
         TY1NRe6dfRfBL5GAHYWWa9cAu3KnoxZ7XOHF7/E5fJRl9X7JVoCqWylFlHAdIoLWZ6EF
         tkH5KsU4vT7issGAvzybUhbzYuHkxLKCRc62z5YuIuExo8S2in49+//WuAi96bAAxlam
         dZO+pGaoCioE6z23ek6n5hj5s+2HB35bK0i9XS7g5Wx1nSl7vgXCwaHZAvgrSeYyn2dO
         1rJ4aUqerkbIGceKCDp2lwMYW0AmnssiJlfImI9RP8ZElvX/CthiGrKMUBdSE1J4Ec4L
         arig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768215598; x=1768820398;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O8v3ZFPlFHD+erU8fwas9WJ8RphRIQqixRtXNSEarC0=;
        b=Aj9lBbvlg6ePnJcDOEh7izKECp8GRSCa87GEsoeW9jVHtstCDts4fJ1kGbiIt8bR59
         sNBluMvHNq5OcZeNJVuRCaY7ppXorBzx6Nt6a2B9Y6tNLWpJNgtFghIEntId7XqGExTu
         edfBnaP/0ed7hgxoHGRBgsTbHAMN02DoRLFCgdQbcQ3YJNEhQ50y8iQGvyzxX9fCsNKk
         +jTaCp84lrRhFYLi3NNsAwlsW9VqYCvespI9fGFNQnET3IKFY77aZc21TE/Fn8YX+uyo
         gJTKK5C6dmrvBULasOy2AD/LDveY5C4YDYOOrUgRqFBrtXEDHovigUG0gi1u/kKkIJlv
         2OEw==
X-Forwarded-Encrypted: i=1; AJvYcCUZm8bKxgGL4+BWHtCHpI0ZIbgi88nVS355QJ2JH3aKWWc1H9Z81mwhJ5CSggn/E/HoINr+pXSNrg==@kvack.org
X-Gm-Message-State: AOJu0YzvjxwT+SdzAOMl24y2chdvnXahQinyrWhDToc34lHPU6pwkB5z
	b4YfUGUn6X8W7EXoSkwGvsaVSxqdTu/d/JzJJM9/qeMlVI+LAq9lwur3
X-Gm-Gg: AY/fxX6G671GetbG87Nr+3tC+UyQFYA9THRizMZmLohjx/VJmkyWHky7xO27jXuqRw/
	cNkQeiKZiOKh14S6Et43Vz81zvW3DnMyal6cTGXr8CXDEW6Ii2YH4hjipN80asjJxRcKh0ASbf5
	NuUFimREjnGMmL/2ustgewge5KabqAliDIsy+UhYBI4jXpqYRQF1msooAHK8K821l3nrS5PagVa
	p947bzmcPhrOHFxKtNPFnHA4XfnLXiWGNucCKuSoUVJmJxBqjd8jG8jpjOqPR1jo5ElpYhDDxpK
	e3SyB0Ht0MdPZisB1sc1PWhm/Jw7my/uYSY7HfrCcxq7sE8bJQVVkMn1mvd/kumMs0iiz4FdCEs
	CxjbsoqW8X8B9mwkT2X1Rak7yavd4pKZrPNyUfZsvN2gDHtgRqbJCtPPSOzOn1K2rUIeLHgTkPb
	fWPRDw4/vTPGa6W+bvEg==
X-Google-Smtp-Source: AGHT+IEP5kSeYYmwGfFonUyyW9zLOpNC9v+vDt7YZ56itmuMgjPEQr08pJH7cKhR3GA4FZD8JTwgsA==
X-Received: by 2002:a05:6a00:1f0b:b0:81f:2472:5e6 with SMTP id d2e1a72fcca58-81f24720ee2mr5849833b3a.21.1768215598059;
        Mon, 12 Jan 2026 02:59:58 -0800 (PST)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81df6b3bd16sm9137422b3a.25.2026.01.12.02.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 02:59:57 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id A1E83420A81F; Mon, 12 Jan 2026 17:59:54 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Joe Perches <joe@perches.com>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Dwaipayan Ray <dwaipayanray1@gmail.com>,
	Andy Whitcroft <apw@canonical.com>
Subject: [PATCH mm-hotfixes] MAINTAINERS: Remove inactive checkpatch maintainers
Date: Mon, 12 Jan 2026 17:59:33 +0700
Message-ID: <20260112105932.21064-2-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2005; i=bagasdotme@gmail.com; s=Zp7juWIhw0R1; h=from:subject; bh=1RCH6UUmIi9OxJwJ2yHsbB/jXjXUShQzAgpNpPWSzwg=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDJkpl5eFFk5TEz7l21/i5uB3stm8revbzWa1j54Hsv/0P dnw58aPjlIWBjEuBlkxRZZJiXxNp3cZiVxoX+sIM4eVCWQIAxenAExkeRkjw+SyXTmbJb8/+tR+ adXLT9ZVKq3O/WoJ95YnxC8+cn1ZlBYjQ/ed+g0ZaWZ+799ITd5l+f/br9TNfs/nWDsVnxUTWWt eyQ0A
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3zzcr3eotxz381hi7cd9so3u76yrfky9
X-Rspamd-Queue-Id: 4F5FF20004
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768215599-280319
X-HE-Meta: U2FsdGVkX1+Vegu75PuxExYa/W9G0OYq4RMEWl6yfkeohlD5bxwpZxGRBSDR9tjghy7EBmeSqW8Sg7qlggV4fd/exZIyIp7fiwfaVaiOoS7+ZLscRB5jjzytapY8P0mmxlEMY4HBQ0PpjzNvOcY+rD64VxM+A0aPY3MCkjTIrJzu9p9Sf2aql0epQjBC9EZcyUljfg6ZTcB0LszAQ/MpC5Co5pkaljY0YCpaLk470zqoEfKiu5H3m/lSzg6AFZ+zW/K94MffJ9hZeqqCKY4mZiII4ROFU6pKwpsvJC0TV+knj9dBSEPdLhSp96XIhBMGgg8+Gn582EH/Yv69WQ1hUSVBeJyXIX4YYplZ9vMXArXineatNSxlPSyKctFaA7QxHKi1uO5ovI0RkdZTiq0kO4H33hjp08ts9DiNkt5pUrJBle7kURcX9re4DDO7yMnNg73V1pB/dMY+ewcPZx/wnCWDBGgRnHljVHEcGDO7D9e6aKdSdF6LnYFjycsaZf2dNb7ML9xANiHKt7yNbvo8qs0QRTkwFHerCo7DMP/h8x4wDQP1q+eelqhisoGYE8213WxGzC6F4Js9H6ijiBK//YaAp7G1cY6pqeeqQq4PbmHj9tZMZs8HS9hgWOCi2otKmDIYywYK+growHs6hqtG3WDOHqMhnaxmqIB6KXP+Bg2boPuCZYtS99wCb9gsbXxfoh9Dfa8lVDz/Yxj1XKVljnQn4pmd1MqimO5xhvNEFzbs+mbLTnbgTqnkhvvHSHUtVNNhXkWRvsOVYiQphus1FD1k+uhwnkbxMgpRUuI6pQjiqpd+taH0YGUoB0sCybfAVlYcMo25BZ4UAgJYX1gHP5v5QqqLcHr4FpvZs4LmpsFVsAdLalhMUwBVY/EOZ4I4Ly0Q/cP8P3ueLO2Ukhx6vJSAaUkjoFcL8PmGapzM+wNDSI2VXAz4VWrFRko1xNOiXzdYE1rOOyiQIGGuDJP
 v+kf1IrD
 yEOaJnr5JnD+w9QYMhmxGmcCq3wCrwo84/Zilkrc27HcPIgHhQ67qgDNckBL4QeBGnukdDcxTusxiWXknJi9fA7+FRtPBDViQwA20tW46lCP7qEvBru777IAFJ3F50+3oTXgs6N0wrpbdbmpZFJ//bUMQnBNNiCKaCYJPJr7ZNMKawCWpbYcjclXceCnejWlI38+lFndeD5P3f0XBE5PcbcZ2858q4rl9mq+uYvpPM9D9+qcDk90fK03/vGotNmNQL9ty0tsABINrZXpqAKa9hiccTbOqpCwVUlwKOH1rtvHod8gmoH8w/38L3wB7MQXyfdpLB3HqD7enE5uql2l9H2EcBuBNH9p+ARml5eh3fH16K/YXr5mcrOS2CRlG6oxriyrVE2xqdxxFJoNIsqbLmC6wXb/y4jTOYKe7Hg05CIqatNjX5tEeOV5Ckkv3LLj1SB64RIh477RR0EJD0pm8yYb0k6f18WvbIc8RgreReV4Jc1ajpz3t1kJu2U5fungi2OUnWOGtxb6KFryz6YTN3PXgzvqblLXfrYapQkiW+HLBSca2JZ2YStHHCpgHdIdSyXRUo+3EPdI4F+mMSzrjvlUs80LtiML3kQgSRh+pLoGnoXSUL4lU0TL18FbwMXmiDs/3yHNcVvloxvyWO8Yc3eu0kHcUYPrTq5iTaenW+QOnQymQyxfS44v0ykNbDf1W9y2uKqIaQHlNFevY3/MtLFM2Q3IzH2eufE3kfEXVmac1BpVBOJrbIDY/fCypPBYSfCiy81aeR1eg8BgSg5dzSuxnKpuOWmjZFk2im1R8OjkmUmIl35zbN6AqHnhE1R/ZVgvA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both Dwaipayan Ray ([1]) and Andy Whitcroft ([2]) had not made any
checkpatch reviews since 2022. Move them to CREDITS.

Link: https://lore.kernel.org/r/CABJPP5CjgkOf9=uv4cqjaiOgN6iiXAy7k_RZkhTXPT_vs+Ke4g@mail.gmail.com/ [1]
Link: https://lore.kernel.org/r/CAO=4fJPTiNKvru=+qAasMZYUmsGQe+OBH4A2Dd1v-NFdQ8f-Qw@mail.gmail.com/ [2]
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>

 CREDITS     | 8 ++++++++
 MAINTAINERS | 3 ---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/CREDITS b/CREDITS
index ca75f110edb6f8..f3441ead4c9fa3 100644
--- a/CREDITS
+++ b/CREDITS
@@ -3349,6 +3349,10 @@ N: Anil Ravindranath
 E: anil_ravindranath@pmc-sierra.com
 D: PMC-Sierra MaxRAID driver
 
+N: Dwaipayan Ray
+E: dwaipayanray1@gmail.com
+D: checkpatch.pl maintainer
+
 N: Eric S. Raymond
 E: esr@thyrsus.com
 W: http://www.tuxedo.org/~esr/
@@ -4277,6 +4281,10 @@ S: 820 4th St. N.
 S: Fargo, North Dakota 58122
 S: USA
 
+N: Andy Whitcroft
+E: apw@canonical.com
+D: checkpatch.pl maintainer
+
 N: Steven Whitehouse
 E: steve@chygwyn.com
 W: http://www.chygwyn.com/~steve
diff --git a/MAINTAINERS b/MAINTAINERS
index 765ad2daa21831..e0c464cfda48f9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5869,15 +5869,12 @@ F:	Documentation/hwmon/powerz.rst
 F:	drivers/hwmon/powerz.c
 
 CHECKPATCH
-M:	Andy Whitcroft <apw@canonical.com>
 M:	Joe Perches <joe@perches.com>
-R:	Dwaipayan Ray <dwaipayanray1@gmail.com>
 R:	Lukas Bulwahn <lukas.bulwahn@gmail.com>
 S:	Maintained
 F:	scripts/checkpatch.pl
 
 CHECKPATCH DOCUMENTATION
-M:	Dwaipayan Ray <dwaipayanray1@gmail.com>
 M:	Lukas Bulwahn <lukas.bulwahn@gmail.com>
 R:	Joe Perches <joe@perches.com>
 S:	Maintained

base-commit: b60810ff0e0dd6cd8704fb7e495ef38cb8bc050d
-- 
An old man doll... just what I always wanted! - Clara


