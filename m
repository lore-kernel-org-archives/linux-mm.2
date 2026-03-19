Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D97831088E5C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 01:16:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44E726B0395; Wed, 18 Mar 2026 21:16:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FF826B0396; Wed, 18 Mar 2026 21:16:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 315696B0397; Wed, 18 Mar 2026 21:16:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1F9596B0395
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 21:16:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C60257E24
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:16:53 +0000 (UTC)
X-FDA: 84561048306.29.2178AE5
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 770CB1C0005
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:16:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jLA4iOg8;
	spf=pass (imf21.hostedemail.com: domain of jiakaipeanut@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=jiakaipeanut@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773883011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fOyNAfdXOZQ8mWPpvExHvJg2Th3vS8Y7SLQAX1Z7Xbg=;
	b=SdYa6gyJhCjb622JNqz2nmZLuHFJzOjQp5tZLdUX3D7ic3K7eGV92aAY7UkkV/HFuJT9G3
	rqzdQ4/INFyc3RhPTIHpw4NbiEoOJagq+zwy+AElDcQEWoiXtXtKxuX+LgohJnEByrh+47
	ijC7g4MO/or0EUrAQ89TlC1NEZgYHs4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jLA4iOg8;
	spf=pass (imf21.hostedemail.com: domain of jiakaipeanut@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=jiakaipeanut@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773883011; a=rsa-sha256;
	cv=none;
	b=63W1izMTfTb/dAYO6jvV0IG/GnJ8zalQnejSyOyXo7TTkjgwNQtzsJefPt8Jl5MEiLw/e3
	l8N/c1irQ4/F/0KmR4wcCi7e8aQiTi4PDa0oOavE4gQmg7H+R1JzlDPw/qjpGcJyFiubSj
	aA4LPFgN/I13R3tQOP1J1kzMQIgU2mc=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c742882d2a4so229377a12.0
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773883010; x=1774487810; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fOyNAfdXOZQ8mWPpvExHvJg2Th3vS8Y7SLQAX1Z7Xbg=;
        b=jLA4iOg8LBI/uFOIhR7oC1kTTLFG+62vkB2hS46TGr6YoiZp5mGMbZXyH3Q3tUa6Cu
         oz/PEU6rjEuhlNWrGxVEjMvka+gC0hWH6DYVFFyNVn1E9EszIJgazvpht1pb3VFnf3li
         23SQsI3bbWKuTzSh9++YiNWyUc8IQtdVaVz90wxGz0vtTg1BrLczuoZS1JOjki0Fvvs/
         9xGhcbyYENKDkMoF/QXq+6IOxU9MHro0uOyfIg5Wd1Qtopv42PHhs8WCp4c2pQElCgOY
         qltBbPI14nK2Ty2eKK5eVcERY5PTrIgbNAn6Z/v6b9QwnlcH9ULn5gHjRLpgkXwTOA6i
         7vCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773883010; x=1774487810;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fOyNAfdXOZQ8mWPpvExHvJg2Th3vS8Y7SLQAX1Z7Xbg=;
        b=hFDTciIRuOM3CD3jPshjonixHAv7YdADwhClx2cYVzQyTsTBNcgH2a9r8Gd2lTDyLy
         scWDF5KCDyItNApMwhLqBoh01Akr0fpqb1YONa4gcuqWx0dQafvPvTLrPlv6JOyILfGS
         GNgU4Tf8baLmZk4gYA17WRtj3TdPtkjIO3cHWhXXPrPbJOVMyUS9JgHAfU7MU+VksnUf
         H5UnTLQm3bOvlzZYKT/kjPRPBwb6DgF6CgpXe1L7lhU6oO5aQnY35EHiLhJjetWok9Ol
         toUV8j1X2BV54t+SNYPAAMO+W6aodoNvuHfbUuPQq6RxTi2lZ6L5Ve1XiVAsVAsjPJMo
         a2Hw==
X-Forwarded-Encrypted: i=1; AJvYcCWwNTBR6+Gqd2tEK+yHZerfoxKjsV3KOO3mkIJKmu85rHsreruGrn0ns8sPU4v41ZEIo9l/lkC0DA==@kvack.org
X-Gm-Message-State: AOJu0Yx1uFp+MteMNirmY0I39XF6jqzGzZO2S6qUNBdsYmnQPgEIMBeg
	4D6Vtfa5E7IetkcFT+G0cioVuiIsiTKAzcwvVZjLuYTN2952zTZwadfy
X-Gm-Gg: ATEYQzwbIL3U2WzcUP4juPPNpV0BiPA7jWZD90R7mnFU0Y7YcmGJX8BO1ZHSzmQaqYl
	XedG4dKpYah17xTEc0k4UfY+GscZQGpd535S+QZxP+FWCm4fKIphS5clZe4X9D4R7ivc3jStCpW
	wT0N3RLjraGyGeQYYVKLXYlD8Vb44ilXen2vt9UqDdIMbDAJ4eqNzOylWewL7HgPK+wPjdkfCtn
	7Im+Hn8ZFHX3NIE6rlBJOuiCZFCF0uKR319EPZc84C0MU6INqygEOiCWRFGMoNGiK5+eWGMXZuY
	/VQRwiaHDv70I/+PucF9RpnlqyNNf0NHSXaNsMn+tA7c7tFA3tItxxQTxCBcuYFWF0y+CHPjk7h
	NXhL77Z62VnHq/DSdCJD8qK+zC4r9c5YeLmwdyaacJxmhQxFC60AO2+lxtQn3Mur/6BcUtZuDsj
	w9dBFf6oG9kybEWzSVg6o3KFvYUs3TgVoP6mZjSHk2fcEd
X-Received: by 2002:a05:6a20:430a:b0:398:a1ca:7a26 with SMTP id adf61e73a8af0-39b9a063b23mr4777703637.62.1773883010269;
        Wed, 18 Mar 2026 18:16:50 -0700 (PDT)
Received: from localhost.localdomain ([210.73.43.101])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a6b52e67csm3837330b3a.2.2026.03.18.18.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 18:16:49 -0700 (PDT)
From: Jiakai Xu <jiakaipeanut@gmail.com>
X-Google-Original-From: Jiakai Xu <jiakaiPeanut@gmail.com>
To: ljs@kernel.org
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	harry.yoo@oracle.com,
	jannh@google.com,
	jiakaipeanut@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	riel@surriel.com,
	sashal@kernel.org,
	vbabka@kernel.org
Subject: Re: [BUG] WARNING in unlink_anon_vmas()
Date: Thu, 19 Mar 2026 09:16:33 +0800
Message-Id: <20260319011633.1874-1-jiakaiPeanut@gmail.com>
X-Mailer: git-send-email 2.35.1.windows.2
In-Reply-To: <390a3cfa-661d-495e-88ad-eeebf4bc39f7@lucifer.local>
References: <390a3cfa-661d-495e-88ad-eeebf4bc39f7@lucifer.local>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 770CB1C0005
X-Stat-Signature: dyat3696ro1s1xt7zikkssqnhnrqd9kz
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773883011-376484
X-HE-Meta: U2FsdGVkX1/GnC7VPamZyDTSe4BKgA43gUDSmSs9KeaBgbMD46mmA5VapobRQZRS5lX4Kzd1NYsIrnj83dEbPz0J42dyinn3d/aUI+AdXVnH5u1M5pNnjeHfz0RQHIgV4FlA/IloCv7gFheC0FaSRyxtm2vyNC/oMzpufb1lDO99FRjd+XSlvuIA2iDbX0nEQPdJjrth6EtH7Ctr8TLajVv5tfyMaitTDrFX32f3CrIcAFhqkmB53th4M0+JdKrcSJBUCytjvhP6EhY9DqgIrusM+WGrkq/p4lCwFVfH0saHugYRKop8PFKL7IQ5OM59FSb4U89ZP1bJ5ULMf1hXUaLvIhOXYdrVBq/q6MhR5CmjuByh64NZZYkwRmZHVRasniSYFegzExsYj8EHXfM6hgHZ+r89KqRy20Sk3oyf3ITzGlGFfLtNR8ha12WGyXUq4NyGZt/ANiIm9cBJOKghJnTCq2mmmBDMiwCZEhPy/7HlGTB6VsE8C0fwQsR18GCKUR0T8f5IH21eyyPEjgcMhOEn6AEDC4NF93mX0CbntJLyIxS0jdf/rQAfvGORji5szJJ5SOlHp2vZG3K0x0jl3QE6o2uwSdxV1PH7jxIdQ5YgOzLjwnwQWMbqW3Qaq4UUO8WvhevJlDf+2Dm1kb8FcpyktNBIY0w1q1Ut7ZGQf35WD0IZJB0199LZrCbcoAqe1qBNTAOc7LHiNbpK2nUcfke7Zb6HwhEHDUldMl4UZIAWDQvuioqsEPBuAAUWCTq2RZSuy2UO61DZG6l38XehtjlD75kSBfsZhmgMXeuGtHNYf00/5dhdoebAD8g+RtIzYSaiSBvcFBl2w5PhjnMB7F8fSqRW3+tpES2Co8pnO44Yii78tLoQjzYYOgxIWtpLzKDj9Gx/7GriAdT0gbL1EU1WoFT8FKpP0g5uJVBMadETeSjd5yjBJWad4hSHcX1ssSUrIjiewgR4MbwtcHB
 nxxpGi1L
 XXFIg93k6AVsVGm8a9v7NNaBZ68KalEs9yZNi9rN+/OczTf4s5h19VZVOTY+YbPbnVfbew3DRuCXCRViZUvPlXjdCqNQiRbwkmw5c3zxKkI8jJKJdSsMKThToXDIcPPeAGDMbO66lht0YTEp4JQcElzuF9FFsjugEtjNrSSMF61gjZN6IoUeIq9FW8D0D+/67GWAeXhRpCHh0BFKvwG3On937Pd75U9xRHy1ITd88/infPlV83Dx0KmhD/2AZULJ0m48zfb0VmH4UJA3T1qcvyq7xRqIrL5+TnknGXh+uLEGaXHAP1BYlZW4/4wXQSRh5XOQUt9POFwCN7m9VYawYYbfinN/qxbZmdPQ5IiOxdsv4DFTY5lpQ3ZSH6UQ3r2vaKt83+oVyiQ3t1rzIsK8g6idAqCpXESvMDIrqvRoX4DXkRtYPhwZJSSZUjCuULV0EspPyTcC5sf9Lz5DHoLX0ho9v7GGkS+8awei8xwG0f8PHAM7NSxLBgL3jBoAAJzd5cbm4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Fix at=0D
> https://lore.kernel.org/linux-mm/20260318122632.63404-1-ljs@kernel.org/=0D
=0D
Thank you for the quick investigation and fix.=0D
=0D
> =0D
> We like to turn things around quick in mm ;)=0D
> =0D
> Could you check to make sure that fixes the issue? If so could you reply =
to=0D
> that email with:=0D
> =0D
> Tested-by: Jiakai Xu <jiakaipeanut@gmail.com>=0D
=0D
I tested the patch on my setup with the reproducer that originally=0D
triggered the WARNING in unlink_anon_vmas(), and the issue no longer=0D
reproduces.=0D
=0D
Best regards,=0D
Jiakai=

