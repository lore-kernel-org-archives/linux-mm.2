Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86BD1CD1297
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 10:30:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF8338E0016; Tue, 11 Nov 2025 05:30:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA8DC8E0002; Tue, 11 Nov 2025 05:30:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A97CF8E0016; Tue, 11 Nov 2025 05:30:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 927B98E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 05:30:06 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 600B0C04DB
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 10:30:06 +0000 (UTC)
X-FDA: 84097956012.15.6A8FDDA
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf21.hostedemail.com (Postfix) with ESMTP id 98A291C0010
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 10:30:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=NUvWuq76;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu;
	spf=pass (imf21.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.180 as permitted sender) smtp.mailfrom=miklos@szeredi.hu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762857004; a=rsa-sha256;
	cv=none;
	b=UBY2+mCQnUT56i5RsNlDnuqCPWhNNJ2PVNAGwoWFk3zFIKDTIjkr4e2Z6FhGVVDmHAS4yd
	IZPrOgkbvx0EmocNMQlH+Non7CBEA0X9ZSJbSxHvPQyhr+qRetm1hqPoY2HiaW6QgKUDv7
	yy5ry4p7IJfUvPF2pL2N+FOAhw2WWoI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=NUvWuq76;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu;
	spf=pass (imf21.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.180 as permitted sender) smtp.mailfrom=miklos@szeredi.hu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762857004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ErpvLu+msmOQH+DLoUzEraHYQEPe7HwAu5dxR8qbtAo=;
	b=DdDtYT4wEdRtv5GYH0BcXjGY0+aKCgnjYaZ/5jKaRX3f8LhnOTBLWgiVbFTFZA9qa8b7WW
	e2cDkAIsUBr2N+vv4/AaHlCGQwLkV5v4NioPRDFhjRWJFe74bD5PIPm3wrbc0rvb32SFhU
	PTgdvbd0BkS2ERz5vhkLZDnjTkkWgmM=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4ed946ed3cdso32229321cf.3
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 02:30:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1762857004; x=1763461804; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ErpvLu+msmOQH+DLoUzEraHYQEPe7HwAu5dxR8qbtAo=;
        b=NUvWuq760ai2VM+lRdUeFNFpq9jjacGVE4jVJ5ZPIw/4QyIpsRneUL985M1Rm0ATmo
         LPPcXIEXN/qsOtvRaL53/Y51kn5XLejUz30CGJpPHYq5rXu/4xp0IIPzfkyOxlvvVoyw
         z86pHktL1YJyWVniJdryfS+8F9Tkl4cxyfnVA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762857004; x=1763461804;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ErpvLu+msmOQH+DLoUzEraHYQEPe7HwAu5dxR8qbtAo=;
        b=NoOSXKMuVdb+f76xDwT6DkVTUAHiM5Q1gMIN5Gi77KTPnY7+9N2ssKF9xKrxmo5Sle
         1mQZBlabJxGA/JavzKWgvzrhIZ6B8Jv8rXOuZSvpa2hBbIXUDQvanUK5A6x7g4VOovYh
         FIsTHB5PQa3ZVx7xcPatqistuQOm1e6hyFuZRGoUFa6rE9i2Z02Pl1+Pl/3cDxeGq9xa
         xyemHwgRX7Z9dIgCfA2D+6KHRnz2dghL70k2gERJbYCI7NlkeHqBWsCtnX9LqtkgDWtg
         O/uASc/rSDAb9iw8s/IO/aGP3yo02tK0a+UykvvhsTFhXc2qWnVD2E2yHhoeqaOh44hL
         NFlA==
X-Forwarded-Encrypted: i=1; AJvYcCUv71g8bPrglPXMavidYvkU5g6YBushxcaaIjEIzS1jEGTZLCeMMhnHfKddQadZu5cVLHkLdAfutg==@kvack.org
X-Gm-Message-State: AOJu0YwcU664Z1Z806w3sqCRk/KxlE63uEq+/lwl180ltGQeaPa8D8Qa
	HD52+0rxGZmm+skZ7/tibVkf7RQ3bRlCXGgkzk2PXAvREOizGzT5s3X9rFgzA+ncWkK1RiydON2
	cpWT2ShE1JVu7Mj3e3wvGwfpAHj/jw9xxHn7Dof+5fQ==
X-Gm-Gg: ASbGncsYij8SXGCnpEgezXQjTUPPBkzZPa0jNM4DzDI2tbSbe3wXkfHStKK4DcpTw+8
	PIsvfSkAYdSfv/+0Lmk6qUCtrX7EpbHYP5mI/ImlqFAcwc61Z/1/8tI9S8RjeBeEcTaS0+kLJNg
	UyDGNNsjE6P1MAwpVEQrb9s9t4uT+EfLsoA5n8qjRPIJv+wFvoOLLGxHAYxbWd0Ch/QsCjs2ABj
	GijL0gjcVGTA6n6JmSLF+/lhEi/H75Voi793gCRxXJaYrcM/N7JE+fgocrTffJL2ab/+g==
X-Google-Smtp-Source: AGHT+IG1vPc79jE1NxMTWUcAkMOFXJ1dO7xwNLHncVzXeQGMi6M4ZcaWG7wZ9Wn4xgn8RqaQcm4UKxcrnMz8XFw/71I=
X-Received: by 2002:ac8:7d8b:0:b0:4ed:b378:145d with SMTP id
 d75a77b69052e-4edb3781c5fmr87056701cf.45.1762857003684; Tue, 11 Nov 2025
 02:30:03 -0800 (PST)
MIME-Version: 1.0
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk> <20251111065520.2847791-4-viro@zeniv.linux.org.uk>
In-Reply-To: <20251111065520.2847791-4-viro@zeniv.linux.org.uk>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 11 Nov 2025 11:29:52 +0100
X-Gm-Features: AWmQ_bnbS5BGnOdlDcNli2J3_mWe2QdNv2AalQvWZZg8jjhCbQzLKZqYiVdFPQQ
Message-ID: <CAJfpegv5eZK=70GEdbofg8u-CKS7gL6Ur5PD86Ay4h3Z8D986A@mail.gmail.com>
Subject: Re: [PATCH v3 03/50] new helper: simple_remove_by_name()
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, raven@themaw.net, neil@brown.name, 
	a.hindborg@kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, kees@kernel.org, rostedt@goodmis.org, 
	gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, paul@paul-moore.com, 
	casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 98A291C0010
X-Stat-Signature: pn8qe5e37ntj3c8w85t7hmkyn3iwcccr
X-Rspam-User: 
X-HE-Tag: 1762857004-568493
X-HE-Meta: U2FsdGVkX19dsdQq725Rkhp+cMy6xBdzjbvfVtL2CziWaBcQvBCn56X19TC7LQlh+7muw9EmdhDAR6LkaClvCCmSVgE0nIeK36VxzTZFV+mTGcg5pXq3ykatOP0z4LCgMSkIRGLDiHYEpT+HWnJEIk6y9gx47RaT2Hg6wd/lmuDkl+avyq3pZp9x6/PGF6QtA/1Vhu/Rbt5OBO3XzClUtni+cJAeE60AGIX3+aEWAW9uSF5iS1kX3pgbOidFEr0GVgC3CXmGKJTYnMRekBBkjSPYptC2RcsNzMorggtSSyn3WsZL3g40yS6vWBSdJUn6IljDintcjJ3HNO+1SHZjoemjPzkU1w/FPRuVYqHHiotaifvYptomp/2MDR1pdu+HL14kKPX2sBoiYGJxtgAcvM5VwIfJ02ya2MEEGoy40o+RZQp/SgPVIwGOr3Xaj9gdsllOlybkHhvyMHngayovp0otBEUrud92TOBte5dadZcSsnQD7YsOR/4NPk+iC0N9t8qg31db0IPZJclvDA7s7tJkC4SNNyLwU6wA2ehuTRZkyiQEJdlLZJCH+GaVIWeu8QLdWB/P2loQi1pWPTRC4mf6DD/3QMo9liH5AUqY4ctt65EjvT+z89Gblql1UoCGrOycbnSeNkCtjVK9QHuJMch6sP2a2TTlB9kqR8ydZZmHc+gS9D9q1+dZdPSij2jw8c1/wLMrsnyKrc8GyyKxRaZPT5ea1WYS/tW07CSHTmvRMRQpevLCrAGBpdpi7sVZwTB0nXdRW37njzIdjSJpKOwfPYPenSfrMhR3AtNeQ4UxzsIy+6O43zf1FUunQbUo64XQxXT7VKpkX2h1iPUWLuwGJ3M5JlAOgwd0Cei6jQQb8K9Ek/OmBifoSOsKMF/HC1P4mK+8UTpMf/pmlYXxVaVyxYlh8RIGQNwnWwEM+ntLYZ8bTlUZTcUssVHfMNmj7hS6sI01I4jShuzUlkM
 uxiGLag4
 nhh2z8Ie4Lvaziask+PIxfv5FjcUBm/j+dnrRAHySZ3RNMYykcbYKskK6AeJSYf1loU/VE0EeijwFPceHCAmqLMHBcxlhXNOcKa5yOkyWBbdbBOWekgsVAnvbrndYycvFGwr/8mUTsNNuMGjCav3R4wep1YK8TXh7M//s7qPAZjwZn167T78Tpe01xyvwz4GVyhyEGwY+qxhHnG68WOvKA5o3cFn7ZWfsryZNKc+SpKZ0nRGhMnGuYpr/Z6NxG1wVWSxn4gnCAbPjfAwPi7AJHzCt8KqfObgI4tA6+m0DHuDCFXsbg7QdfteGiYZh6BpwkbpdsiMwBYTzD3A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Nov 2025 at 07:55, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> simple_recursive_removal(), but instead of victim dentry it takes
> parent + name.
>
> Used to be open-coded in fs/fuse/control.c, but there's no need to expose
> the guts of that thing there and there are other potential users, so
> let's lift it into libfs...
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: Miklos Szeredi <mszeredi@redhat.com>

