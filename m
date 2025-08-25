Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 124ABCA0EED
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 00:04:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDE006B0092; Sun, 24 Aug 2025 20:04:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8EEF6B0093; Sun, 24 Aug 2025 20:04:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA5166B0095; Sun, 24 Aug 2025 20:04:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BB5C86B0092
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 20:04:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 80DF3B7C6D
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 00:04:42 +0000 (UTC)
X-FDA: 83813333604.27.66E6B70
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf21.hostedemail.com (Postfix) with ESMTP id E59C51C0006
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 00:04:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jkRx1u6W;
	spf=pass (imf21.hostedemail.com: domain of ramsonpetros006@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=ramsonpetros006@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756080281;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vtGll6+zndhKXIeObjmr1nBAsXHtf0JgNgfznIpa1hc=;
	b=hlhJvpiIic6dsLK6BmWPvzMqLCr49fHVFCUiluQz6p2qbLlY5xNQ/2Ea2602ztmg/zxXHp
	yfEa5IaR8A8/Qzkm+fsqoK8bClrcmiwLHOYA+KrV1yZzBT8MAiMzOwM7GmgPcHQjXsCGjs
	fWlu8fCR4Kd00p9v69ebMogf2FbJFy8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756080281; a=rsa-sha256;
	cv=none;
	b=i0H49t8NUkLOnaVRrxFGWU0Lge4S+g8u4z/yzS2QF41/iGzUyOi9Tzo/36gT2GyE1qVW+R
	ybXrGOdNCpqzLJxowqzYw9zcap0yHbmdiy1ThOzSg8catSUWnuQfFwes5kkfZAuIZt7sQZ
	F/BE8zeCvTSFK/7Xf2ip2Utp+tAqToc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jkRx1u6W;
	spf=pass (imf21.hostedemail.com: domain of ramsonpetros006@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=ramsonpetros006@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45b4d892175so17509665e9.2
        for <linux-mm@kvack.org>; Sun, 24 Aug 2025 17:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756080279; x=1756685079; darn=kvack.org;
        h=date:subject:reply-to:to:from:mime-version:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vtGll6+zndhKXIeObjmr1nBAsXHtf0JgNgfznIpa1hc=;
        b=jkRx1u6WG7MSIcWLKpk/ZL/gRT3XKDL2/i9VgiSd+MSXbAZh64Pr6qHx8Yr6/5fBiv
         /XEHiC3abv5WCnUGCLN+Kp/9pq1PWQpvFeWQVoF/ORJXHxBjbSZy4Rv67wb/EJv3EhAk
         H5XUk405/l+EDLuAcfE+gYHt3vMZVtUcccUpzT/kFDSbduklPfcEWeNvuo6MJO6oXFxe
         870S0ZtaYl9gDP8esinUn3JqJrTY4jRuaJxQnnY1+wgclHc5xmlMab8QrRar3uor9xAO
         GEBwAOCOZTbob7a1v7AxOLv8qUppaHz6mCxMihj5PWjcH1CipbCPFsr/7o+dpuzxj/nj
         jDtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756080279; x=1756685079;
        h=date:subject:reply-to:to:from:mime-version:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vtGll6+zndhKXIeObjmr1nBAsXHtf0JgNgfznIpa1hc=;
        b=iSK4CXr6aK9ssTTqPFvkCudI17QyziyYqRq0slpX3/lExmxvNRCB4XzAcvCcv8Zzy0
         Lzn5BnbT2yTIpY09ZVjraoT+tvPnLvmg1EnEmRS8XyddTboGTvh1G5Uy/NU0/sLxuRzI
         zqiCfRwKGPS43yRWMxuHyT/wxvBe7nTcFjV27/TuHrS41Q3bc/9r8u9/t2DUuDzbm0D8
         FudaAH2xFjQgYHeTNrrD0vR4onAjV55kSeUwi65DdRIysA31guQkST3hvVKYCiEc902P
         2oegqCsq30grkKSko6VsMdRhctsuWzjFdTbPLIriFDvi5+cYIeHE37mGVRqyDyE4jwAW
         XBSg==
X-Gm-Message-State: AOJu0YzYHq7mCRVc4e3pDS5/fCyr0MemVfr0A/YS4eMbSuX2eIrEKOcw
	5dLKPpZnRz0l5zveF8I/1FYPg2DNO1dX1uS4u3vKxXbrwAUkxKMcsXfv+84mscv4
X-Gm-Gg: ASbGnctZYkAM2KmhTHjTH+oFCcf8t2GQbRWPOuR7/r0uGPTRjKmdD9jFJOdyJ9gV2uS
	LH4S8ahesMn5AAyvLa+1RJk+okx7DDjlYuYjqgwQEyQV7eP5FGkqIaRwtolSCEw7VUc+6E58jwu
	7XTrM2qtxag5Qbx3mr02UfrcbaujTHbxcD4VTHLPsKYSVI4xi8gggdpU0y6judt7OuI1vI9XV+8
	i4mHKfAo3azWuNwmMUtN36PVy4Qxh6rM/wPCTEAKwfcOdhgpRjYj3rQNncb6ff7cY2tkW8VJdIz
	s1L90AHWv2gCsoF6qhsjuvdBDbNKbccduJoORs9d8S0z7ErXij+ZtaSIrR/FwYbNQMP4SsYqDCK
	bumiZvS7ZKmcoY+URg+UzRL5L9NEu7/nfxhVgRKZKDJpunI1uLbMhMUsztlBgj6CZoXq4OuU0FX
	UWpe3XGg==
X-Google-Smtp-Source: AGHT+IHvfcay25Z4epGB+BRoODVWMOn1Dav9p2OFZWOw0R9bRQRdjb2NXkGS66mE8HLIrXrieJKr+Q==
X-Received: by 2002:a05:600c:1d1e:b0:458:ba04:fe6d with SMTP id 5b1f17b1804b1-45b517a069emr64198675e9.14.1756080279127;
        Sun, 24 Aug 2025 17:04:39 -0700 (PDT)
Received: from [192.168.0.200] ([105.113.116.69])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b506bdd9csm79741785e9.3.2025.08.24.17.04.36
        for <linux-mm@kvack.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Sun, 24 Aug 2025 17:04:38 -0700 (PDT)
Message-Id: <UM31KU1L-BNY0-VEOZ-43ZR-KNZK6SZKMU0T@gmail.com>
Mime-Version: 1.0
From: Retired Colonel John Marshall Bill <ramsonpetros006@gmail.com>
To: "linux-mm" <linux-mm@kvack.org>
Reply-To: johnmarshallbill@outlook.com
Subject: Urgent Attention
Date: Mon, 25 Aug 2025 01:04:35 +0100
X-Bounce-Tracking-Info: <bGludXgtbW0JCQlsaW51eC1tbUBrdmFjay5vcmcJVXJnZW50IEF0dGVudGlvbgk4MzM4CQk1OTkJYm91bmNlCW5vCW5v>
Content-type: multipart/alternative; Boundary="--=BOUNDARY_82514_IMWJ_UDHK_EBEL_LWIN"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E59C51C0006
X-Stat-Signature: j3efbu3wt7htbicpjgph7omdm8qxzrt8
X-Rspam-User: 
X-HE-Tag: 1756080280-314504
X-HE-Meta: U2FsdGVkX1+/n+Iu8x5x2XS5eVwrVVGfFLtCHOD0xy0OVmPiDwv1jL/7+Cf8BfRVTkWR5nY3ZOKbIdv+gzSftCFCaidIqsXetYfTFenVfly5fNQsuffg7TjNCvdhopMP3w7/S2IJCSVUiC9zOvFOr2SEnXHysRaI6jwCSN3NuZHARFS+ENIQsDFnPzpM9bR3ljgJScAsGERBffFXjDKfZsIZuPq8ov+e7hQm8qpl1Q336LGwjEr7WROptx/X6gp7wNz5NzQl5oaCLmkCJG3S5dGC2uNwnGrhgRcPK356cW81GKNytKUvafAkHS9gkTKYHcBY6swY9/csaMo4zvINO6FQHekA+F2vj48rBbN8/1CdXylB/ssZyiGbiLOz+Ed/qhUteZmVNpAolnoL78o0TzqsjC71EIAb1SW9d9ZyuG1R2VGEwKEO6Q9HkWgVTqk4/2HlbXHAYkwrpi1pEhAU1/5zicsWOSfy5rryfwLnZ/aF6XxsjpEcvV0exhMSgFNhL+90AqcZXTp8G9UEtkOak4RiWKvW1xyNMvPUkWaKvZPwJnARzm+eahtlLcPAqI6fMH0UxGNz+GJxVCLPG6pSwZ/Fcjp2Xw9Sw9fFaEDzJPo4tGrsvYlbSqpBFwErSJ7aO58JKfVMqoIKb5IV4mFAViy3G4HSVdicIzoB5zJX4XqHE/BL2gaFlRvGQtnEQ4XE/cT4KEUcmb4TV/LHgZoSXG61uKGR2JupgES8NHf3dySqe9pPGQ6f1KS0mZM3K5of8vctVVtZEBXa5TkMFfsiFI+wF1ecEhecL8nztXuS9gLWhJOzhK/OVM5M7KnZpLWYQ0nhh+VhH5BC/T7qOl1V50YuVH/KLjiP1umqcy7YYEfxL5O//igFPwIhGbZQG4FbTS5Jbj5j+OkBYe8dierXBtLZlN4qKWXDxqTyxYp3I1PYvJoM/J24imduvk2wQsR5lxEPaEVjOn5/wAU32sj
 8j1/BhSK
 kef+PlHpf5FBhpnQOFJHgBRCutErvjZU6sxtVsBmRQZZf7U4pN8g34j/mtSoKKdIuDP99r87vB0VB7iRy7ptE7JOTcTvl1NijZrKEVlnQ10FzzvNho4iwNobAVskUMUcm0MN9l9MkyV2CPVzFAI4CG5FQVe129YR2yygntIinBKdcHEEm4NIgUi/Raj/zFgiMlBAmQ+2BzDMgpsHFcfHZp2UNws6kVXXoghmE+zbJMUnZVoaNqZTuVLkXAMmKhIfnLt18oFx49EFqgX7W4oLyn3xplA==
X-Bogosity: Unsure, tests=bogofilter, spamicity=0.455221, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

----=BOUNDARY_82514_IMWJ_UDHK_EBEL_LWIN
Content-type: text/plain; charset=iso-8859-1; format=flowed
Content-transfer-encoding: quoted-printable

Good day to you,

Have you received my proposal? Are you willing and ready to work with me? P=
lease confirm your readiness if you are willing and ready to work with me t=
o enable me to let you in on the next line of action=2E

I wait for your earliest response=2E

Best Regards,

John Marshall Bill

----=BOUNDARY_82514_IMWJ_UDHK_EBEL_LWIN
Content-type: text/html; charset=iso-8859-1
Content-transfer-encoding: quoted-printable

<html>
<head>
<title>HTML Message</title>
<meta name=3Dgenerator content=3DAdvanced HTML parser v2>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
</head>
<body>
<table border=3D"0" width=3D"100%" cellspacing=3D"0" cellpadding=3D"0">
<tr>
<td>
<font face=3D'Segoe UI' size=3D'2'>Good day to you,<br><br>Have you receive=
d my proposal? Are you willing and ready to work with me? Please confirm yo=
ur readiness if you are willing and ready to work with me to enable me to l=
et you in on the next line of action=2E<br><br>I wait for your earliest res=
ponse=2E<br><br>Best Regards,<br><br>John Marshall Bill<br></font>
</td>
</tr>
</table>
</body>
</html>


----=BOUNDARY_82514_IMWJ_UDHK_EBEL_LWIN--



