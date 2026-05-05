Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21535FF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 04:21:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56C346B0088; Tue,  5 May 2026 00:21:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51CAD6B008A; Tue,  5 May 2026 00:21:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 459AE6B008C; Tue,  5 May 2026 00:21:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 34D5E6B0088
	for <linux-mm@kvack.org>; Tue,  5 May 2026 00:21:50 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B66DC1C0EDE
	for <linux-mm@kvack.org>; Tue,  5 May 2026 04:21:49 +0000 (UTC)
X-FDA: 84732067938.19.A8CDD30
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id C7F81180002
	for <linux-mm@kvack.org>; Tue,  5 May 2026 04:21:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=akixSGZJ;
	spf=pass (imf16.hostedemail.com: domain of m32285159@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=m32285159@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777954907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/f5lulraV7xC48G0DAyHOKHBvu8TWDJIATOrngU6KJM=;
	b=Jxa0e12YjuETcz4R9QRcgca/9WLajeal9j8hMebyzqG0z0+UTEs26tTn/ZLhODJKT6mXOr
	IILwa4JmQSfmieJTq34GiwDNZJhVqCUn8TiJXpmDbXwjatCHeY4JOOudDejAwur9PAWYAx
	08RrNP5uN1mwS6rip6Jzsl6XwLVxVpw=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=akixSGZJ;
	spf=pass (imf16.hostedemail.com: domain of m32285159@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=m32285159@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777954907; a=rsa-sha256;
	cv=pass;
	b=QJseyR+d+Vbgo9goN8ZIoiU6Q6pg9PJcnB1j7iMKKqh3M8uNc5EDd9XU+GL70LnNBQN5tZ
	ULfyZ8CqLGehQqgNZ2cqPNeANXS8Y3xRfEQIsXx0bRpgqIkhBYFfLfPv/ae/7843zT9/oF
	IYq76l5u9jmScdXmN6rC+5yyqLFpmh0=
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-7bd65714dcaso37392117b3.3
        for <linux-mm@kvack.org>; Mon, 04 May 2026 21:21:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777954907; cv=none;
        d=google.com; s=arc-20240605;
        b=NPkw25FepRiJCLZoNAhbpM58/SbLrT3VbaZZD/TfSTkIiCeOuE1im1P5YxG6xx6QA5
         ZIsZUktE1WFsRK/pVpdb3G00OGmfbVnQKXW4fUcevbX84wM4QYfluFe+3SgS5fgp/j0/
         eKB6UeIKd8HKF6VstUrmosP5AQWDJG37UkxgCrkyyq3bX8s/4KUIXFeh+wZ52wsqHMs8
         pi80wFDEnFc+efzxk2F+XP+h7nEvOQV0+4VE3E/KGp2uhK5jyLV1fASmqt3D4YC+IydB
         VN5f+VQp2JN6UDLsXMtw6bXq4OhgqIM+FnXUxKRc9Ovw/7wSb4BFkfWkvDxEYC/8gdCA
         YIJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=/f5lulraV7xC48G0DAyHOKHBvu8TWDJIATOrngU6KJM=;
        fh=qmm0Jqs6/mad6Gwad4chpSi+BdjpwHoka3P7Lo7KN40=;
        b=K6vCzydl15a2j+LOyLaHKdjZmtF/ThulnZyv902kqa9XmPGdsD08ShCSa+NQlfA5UJ
         +iZLLDliDFolQMRAbvbgnvXLB6t++G/c5HgeoVogsAIaPu5DFTB8quPNFeoAmfCO7A14
         UCKGzlq9f+umiSYXhTbTFsCx3YhfjAb+rktcvEM7lYlpxPcp4kvRKxvqSSYavUXoc6Q5
         HvnB0dgOD9wLRb8XOTNM4jdQSafcmAqbT4XAuVFa9OMTlgtva8ovpPIO/XyDi46tL1im
         ytAdsAciXEDFoFd2bRBy5LNxmh3Vs0/dgmFZQhRSt3WULCpssrBg5ST5EXLMuHEHOvAZ
         IKQg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777954907; x=1778559707; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/f5lulraV7xC48G0DAyHOKHBvu8TWDJIATOrngU6KJM=;
        b=akixSGZJvVD6IPYoP9VchOn0Xud9omr1IzZkqMkrFy8xcgKUV//B1kBviITUecFF53
         fbJuLQ/50iNJxdTjfnZyzA2OBc4MlFOHCzFgeFBhxX/ZaPsJl+y6J0rT0CXAfmYAGcF3
         MpLLPaQ08duxQ0Lxe99mqy0uRCaGGXdTG8XmzC70ln2SOVTTStUR7R8N6K9aStXVocaa
         qYQkhu7i+ND0qGaI1N7gy3FDe0JZo/elBPr8skYEew69ieoQXfERobenvr65mrMmg2D2
         z06MTwWXYcBjLnENd+8ONCxfTlRqnke+CjvOuYkaJvAQq0bhwv742uWYt8qFqMm6jGZ/
         8IAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777954907; x=1778559707;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/f5lulraV7xC48G0DAyHOKHBvu8TWDJIATOrngU6KJM=;
        b=AgesklKL0omYWU4sSJx8oshV2STdhQauqauUC4GwdSyIO6vanB6Ozhrftd5fvF2MsD
         OFgT7xwljxwfiYq74jKx+aeGivkLmYteMNV8y0g/73yW6x53or7hNRmkGQ+3XIvzDv1L
         43D0UrTVmWrD2zD5cNtA0uIe6u3jEZuNVZeuUlsLZTH84a2v9zSx0f6TenL4zBGkZxNg
         41YcSq2xHX8nvqGrrPcePvDkl4a3YbsVoSfE5WDeXeyoVH6jTUGxaunrNnc69e8ZgSoR
         IoPgt1Jr6HuT5ZbYNLPlTS9ytHk/Sc3V82/mnTDvxBL58j2wAbYTzY5Tf91E5xysLBOC
         XW4g==
X-Forwarded-Encrypted: i=1; AFNElJ/DTbm1ZLyiPIvJs1pjqfpVIzkWBgYZQ/0IVi15BCLdJisq5+y4R10VKtlheeDOz+lDftCBjHA1rQ==@kvack.org
X-Gm-Message-State: AOJu0YxWaeBVK1TNGjDelPFeNVRy5K3Wuh7LJXx6zokMt5uNu1iDF4Fj
	XZbDSnNcr4IIG6vMaQ6Msr5NY1nwKwCrzcEnZnagq5PBL1Ey3ns9dCKI1gSFhPdEhOhcHN1wpSB
	WhFgG88EBiPaqQbBipiwmvq1TG40OCBA=
X-Gm-Gg: AeBDieuEm8Cnk8x/RkJeOjd/lAQYxCmhpdaxr3CjrS8+q1JIe7G1yFoKQKE2oEkojQ0
	RcA3CSnLghCZ9OcFfX+yITwR7zrzAOOV7UZpaHfB10X3pFgj6TQRQSRtBhB2mwHafhmCoVjwLDh
	zJJVBA3oZcByEJbY329J77nUbDnJedUtIezG0DZIHlCZRM4VyP+Hlur2GxfUbR6AQ3mn66lfJMl
	DwU7V+R9eexGAM7YKe1xoPtd6MrOJX6XfVg+zQzIeLN/4jjLC6fD4/zXMv+Yxe9OSNB6xMi25Pq
	YWZvAvupGpkp0FE=
X-Received: by 2002:a05:690c:6b12:b0:7bd:8d1b:b2d8 with SMTP id
 00721157ae682-7bd8d1be0dfmr75951097b3.10.1777954906760; Mon, 04 May 2026
 21:21:46 -0700 (PDT)
MIME-Version: 1.0
From: Maxwell Doose <m32285159@gmail.com>
Date: Mon, 4 May 2026 23:21:35 -0500
X-Gm-Features: AVHnY4K7poSLJ7x-CFSUa99RI4iZU5fyiKRWJaKq5Hf2hsvBnVXiaWn0pBCGM_4
Message-ID: <CAKqfh0HqJoFRPrgvQG84iFt-0-vQd0fz3x6EPhzTgikss+XiWg@mail.gmail.com>
Subject: [RFC] Precarious macro in tools/include/linux/string.h
To: rppt@kernel.org, richard.weiyang@gmail.com
Cc: linux-gpio@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, 
	linux-mm@kvack.org, Lucas Poupeau <lucasp.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C7F81180002
X-Stat-Signature: px5su4j1anxzn8qndmaawsodowz6113s
X-HE-Tag: 1777954907-516947
X-HE-Meta: U2FsdGVkX1+HTbEJTdGdD0z3e+CU++8+phh9ARkGkN+IGNvCc5rxvqBrAr8FuKn9g8Gw4kPLQL/9WNWspew1KCMf3ODvB+/vDvwfVn5CPZw4TZzvKSJ682oIT7rNNdy4KwHVGIgvnAsKr/yXeX1AynsGdwhiKQALu3/HMKaY1Sae4WHj6xsWeZs8Ca2km4haD/5KBcRDq1Ujrybxg9YbHOzXhWVAF0dI0lcaCkthxe1rzbDsq4C7tn+VpURyV2X8KGbSoXSGWsTpqYoYn/ZTjBwVudmltzV/p7Wz577UR9dgOcHisNnDaTeRi5mGH8o+BP7aQgmLB8rspV8kUBPRl8mxVp1L5CQE0l+enuRPWygGsuOkQKh5eEFL1nFpV0/iBfPN8apjoNHINJ2vr3f1Aq/ENHLfBuo9VQJqqXRkA0O+FdcRKoTgVtR4+Rb7Uox210xI5GPnNOV+7HhNIXB0eQaf2IBTHHviLLfMQH1ItTNWOjLGTnM6cpMP4ESIQGdhUd8xQtCA98cFcNzG8lZq0yVsrJfb/Jah2j984aW3M1LVKpwg0P5XaJkUyLRC0vzogygn6Ld3KWQrwO9Rs7euy3XAMeM3DmfjiCiockVrpnfDK/TDtQBKqkltRUx8HUYQj1QO9LivNZWA3fckQamTtwUYn/w1F6/CqpL4/pghLm3yvS2VnSO+ViFkXk0oCXpDSTv3J3M2KPzumv1SlvgUQCmlgyxa1xGW73rWkZ2bNT2oe8K7IdXNNFWP+a21/VDWtp5juEUZsuj8ndrEZM61iWixVi3OqpvupaeN0eMGW6+65cOXtgu61yir1wXYk4rBkqQZKsYzue7l75IxZkJhE91zcZ1042KzUpQHU8T94YWpiffd+5myvJ3dhmLtGfppl8T1IIcVoIt1a3QzqgINPrRbW2FhF+clUwUneslXeP9RjItCeb+lKOW3xE168huBl9cd8OoVeWwnniplQJU
 +57WUWHg
 9KDwSUFXLrB2ZcJTx3GgWkglo7fWsYHfARTxd1NKSmsH+yHzxSnFjHw5UVsixkxrRJnpKV4644gTuXP3GZ6VqbG+Nf8ubo35dsjYc9djN3CCwSqXZeSQv20vovJStyfbayGF3jFx3kW0JgJMHwVh7DRLDsmmdm2NdruxZxAUOlWuMFNIjdRMKlhtWF8d1fan5WTxNxHK2vF5H7Ba9ilhlSuWRIMSRnCW+3QXo2Yi9ow4UrCzoowdiLzsW63QZMQj/VS6qreLk4+GKKPUCSOCPVfWax/rhkBx27X5tumyrtLPJ1OJNaYTVv8blgKujHYpg1RveAkR4loD9PtGfXIvGAF7V3M1ii+2y9wLMs/xCrObPh9/kGSM5PV5+wASA9p6oDxmm4AwvQViBym7NDwqG7nlMyzTDMlPn8PnRouxPgml4azKrDev3SdZcVl5ukxpaRMnioCI5ly5/lds6MvSpgwQBt2Wlce0tZxKmJF2nJ0bUtt1mjD1QAW8y4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Wei and Mike,

I was recently helping a new contributor with their patch replacing
strcpy() with strscpy() in tools/gpio. After some research I put a
hold on that and realized that strscpy was defined as strcpy, which is
extremely precarious and goes against the ideas the kernel has been
fighting for for years, and I traced that change back to commit
9e3d665 authored by Wei and merged by Mike. I'm currently working with
said contributor to get this alias removed and the proper function
definition added, just wanted to give you a heads up.

Are there any tools or dependencies that rely on strscpy() being
aliased to strcpy() before we replace it with the real definition?

best regards,
max

