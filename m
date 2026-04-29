Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E9E8FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 14:27:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94A566B0099; Wed, 29 Apr 2026 10:27:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FB586B009D; Wed, 29 Apr 2026 10:27:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 811326B009F; Wed, 29 Apr 2026 10:27:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 72F586B0099
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:27:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 084BCC10F2
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:27:44 +0000 (UTC)
X-FDA: 84711822048.10.964569F
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf26.hostedemail.com (Postfix) with ESMTP id 14FC9140009
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:27:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y4Q3urOh;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of luca.boccassi@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777472862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=urfi6N/NcYnik0gp5xxDi2Nhfk8E7h+SxSQ7FJ8O9t4=;
	b=3wMB2JZ74C7vHbOnQIq8856jEkc6SgLyNVYtM9nOrAdJvVQvGJ7ZFCMy5sWdySZZgUJ/6M
	rXH2ycgX3+jmV3Oe9NjK6ggFuxrn7VDzxbrDds9WAQZZOBI8U71o8MP/EzcU7DZUz1Pr22
	Ip3/yCYisQa0o7gxJl8S2o2jAgQLn9s=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777472862; a=rsa-sha256;
	cv=pass;
	b=Tui4ci9GLStqi0XbPzR5udNVULu9PIHP++LqmrX9VldiAwjskZwV87qhRYqunOYytDPcYI
	zfSVdVFLVlEChOwAJQYxnaBTMvYuZcE4d4nEGVVg2uLOmW5yy2MHB1rqzLIoFYJt9oVZWU
	GZzon5IRxCGRowvebH/OylOPk9bx+jM=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y4Q3urOh;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of luca.boccassi@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-651c7ddf514so11807616d50.1
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 07:27:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777472861; cv=none;
        d=google.com; s=arc-20240605;
        b=SrExeolW/LFlL99mW81j4O+K1j73Z6bt1eWHTQVN1+sa42KJh/6QzWDWkcskbPa1FT
         xyl+k7ocIrl1qDX7wsCthgHrZp0neVxqAxatSu9TV9ra6Ux9zULVRjvvbKJozkz4Tn9b
         Z7X7Ri/eg6tvGFUxA1gQEtEOslwfBo3uuZQTrEns7OSHygwnARi1bMYfUJWXKVcRjBpf
         ApNb6K94mULFf9qtkwVV19F4GItJO/vJJ9aJrC/XBySEjc6HYKoA0fEixKp9lbKa1tFm
         P1V8GjeZjz6gbxtArjNH95zdlE/JDM4VHyRLHaAOgTwCRnRBHKNT2MCkGi+EtFUYi8Pi
         vteA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=urfi6N/NcYnik0gp5xxDi2Nhfk8E7h+SxSQ7FJ8O9t4=;
        fh=64xrWwj7+5iogxzR4+DFZQpw9Oh+hj+aO1JKT5GtlCQ=;
        b=F1L+kTTXMonxq/z+KNHeu+PUH6izm/4kw9n8BRmvg4pZhc5Iijbk7dhsTFebFZf0sC
         rVxtMikhdJ8y2UA1dWN/4T6imkwRD+D+dsDDiXi06m/TmUaXN5ObRMYSWGRdduYVqTsw
         vQrqq5fwwqPDaZOdmJ0Gt2c7IyEZ2q5Bw3nmotiMrSW+F6qnaCkXRGf3LnG3Ej0wUft2
         stL7GVljA1TGVfKfn4WVFhHCVNuJNYk74Z8zJCRc48uvieBG5UaEbdCAt4ZboHs370cp
         ADiEx8UfhmK9Pm2P0K65k5RU1vXJKIQvoEWFxHPX8iX2g1tbHE8rbXx7vQOKwSyHVMf5
         zOxA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777472861; x=1778077661; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=urfi6N/NcYnik0gp5xxDi2Nhfk8E7h+SxSQ7FJ8O9t4=;
        b=Y4Q3urOhnfgwUB77VEc/pbpXhG042GHaGVBPF1W/0L2LI7OFcV+qvHM8D7KM3rRQly
         Q5jJ5/r/argLZaEHp/0rgbMDpoI9u3k/gjYxHGpTdtYRGPDOuj5DGcBDjUZiJLmuehM3
         LWc6+aq3KBHwxj2pudHqUyOGmAhR7lVGbLoznZi8Mf4HKYdew2h2lfLBlPLFUsPrpF1p
         6ePBvNYOp1JeCigNwY9f/s/bN5Kot7LqpGqT09yzwJUm0Fqr0a8EbS1Ob5im2PNcxnbb
         gQMPmZAWd63q50Z/JYVQcEoSRP0lcDrWXS5Lih70i8UtOLou/1zRnZKorHn+ftCE8rVj
         CBnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777472861; x=1778077661;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=urfi6N/NcYnik0gp5xxDi2Nhfk8E7h+SxSQ7FJ8O9t4=;
        b=Yiub5SGhykyyfKaQRN/jctmu8OI3ybw//BAeWrG2S7jUSyZXX7wbXOBG3rrRpS87bS
         ynjiJ98Cy1TCIWYIaEvWc9+u1RU12tFsdYhG8AUZbIR4xgXCy7mS/Mnpu8+4ZIKTpr8J
         n4bxuTbNSJ1zbNPpC9PbyMr5UO7Y5XS3JKK4nqMwJxjfftfRHq+i4h1UxZDQOUQ00Y8N
         IoRYt4/BKVmf0VyAH4t2UA3jixuMyA5z9JIU47vwyoiB4hNFVBq3tRysNtpovbK33zO9
         eYqUluta26872agqEYzNXgjQnsB0kDaQ19FN6VuhlmK6yfIA5CMJezy13NzyLfcxKUzw
         FsYQ==
X-Forwarded-Encrypted: i=1; AFNElJ+vnT9QzPb2wKoyxesT76+Ps27JWd5ATdLL+6/DZWAYKH75/4bBzfpw6gkmgbBCwWgnTu/ZKtfqVg==@kvack.org
X-Gm-Message-State: AOJu0YycvR9w5FuzTGrabHx2kzZRuniDnJ3MG7n3cTxUQHsJo7Ezfr26
	YnRaZSAyapU5ZPCBzUwRduQaNMmLbnNxE6V9c7ZuVbylDzN0+ThSh3AVAOryJYPbeHCypI/QCzR
	v3F8DujxlkFc0H+a0cZcmw3fSh370tPU=
X-Gm-Gg: AeBDieusT3Vw60e0Ke+1Ng5wbR6akrTRKq3DkcqgeE7103LgKyz1+GtrN6+WCDze4Go
	TH08jlKA9z6UehCRoqHcupnomJxeuNZrWQViyt2q2Ew2C3Dp58J4f/nqh42mQamDC1zyUEMisS4
	tnHwaYsBrXijgE2y2pYPEmnVGE0pUkh0FY5lmjo+Qn4ZPMlGqfjKPZJcDS1MpY6nzmv4vkEycFS
	ZXONYImcUylDhgAf1KbFsOgHkwOdDEFEzZo0qiYctmpbQ2nkhRQuki7ZPNl+jma0BaHkTwVKx/C
	qbfqd7fuJxyg7wNurq+sQHn3ju+fhoapgzPCYriGBa/7NJUHML4G
X-Received: by 2002:a05:690e:d58:b0:657:4633:b67e with SMTP id
 956f58d0204a3-65bfb71052bmr3498954d50.46.1777472860977; Wed, 29 Apr 2026
 07:27:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260423234753.3873095-1-luca.boccassi@gmail.com>
 <20260423234753.3873095-2-luca.boccassi@gmail.com> <2vxza4ul4zez.fsf@kernel.org>
In-Reply-To: <2vxza4ul4zez.fsf@kernel.org>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Wed, 29 Apr 2026 15:27:27 +0100
X-Gm-Features: AVHnY4KDQcGvvdIXjoWZ1u9FJ9qEcoYuCaptNj3DGjOjhzukA6OesM9rXYf4ACw
Message-ID: <CAMw=ZnRY=XyQjvTeFwQ6JaVz-f-YVVvcyix4-tCEVjx0whMsPw@mail.gmail.com>
Subject: Re: [PATCH v10 1/4] liveupdate: reject LIVEUPDATE_IOCTL_CREATE_SESSION
 with invalid name length
To: Pratyush Yadav <pratyush@kernel.org>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, rppt@kernel.org, 
	pasha.tatashin@soleen.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 14FC9140009
X-Stat-Signature: guhrr7q8cfkw966uqp9t4f77iojmfi1f
X-Rspam-User: 
X-HE-Tag: 1777472861-168019
X-HE-Meta: U2FsdGVkX18SmpY/sy3fp5MTOhQ9PxFcHPRtuVkrcDc5D7R3FRPm/Ere9Tn9u0bcEdyh01blQ9RpswDsuvBE0gn1S2YAuqUbPksySFCoHaHN/R+fRQPXTpveVFw2CFJZ9z5caHqGbpH8hiykQ/JFNh+8zxv/Bu1bp4vTywn1H9hc07yDHqp1bXBfzhKnMPuDtv9GMlK0W65VP0cIGxVpiRmBnuHUvqJM3D5867sjAJOMpHLo9jPntXMtVuGmhEvDjVp1IBHGmGSHCN41X8vpCgJzES9FyTUcdXvINXvwiFYJV0lAc/YDGsFM/IRcgLJYKt4nv1E1mDoHx1jLioHd5gs+PCuxJGC6Whf3INMpbvPKA21S/ZYGavK6FmfgkluxV6dhbNsDxHQIPbivSW2KTf16Y6uxJS5OVv+ZZb4C7upt9KjJcSfFUdIQEJVy4aTkhPQFsXABnoncKVqGARoe3Ne+ADkMVKdx9WpraMUmGDTgbQptYOVQXcKv11Cn5ytGKrynbvhl2GJU9GKetwnarE6zqQNf1IIV75i7Iv3En4/kL/yRSM0xV0IWGkaCOZLBIKjZRNSOsgu7WHM8zEA/Lrrgt3XwxkeogzXULq2Q3/7n85NVWN7F0gtpwzO6wlbliktIJJRTkFk2lUP0pmj6uY751evP4q4OsCZe3bxwspmZB11DMA/6PZIx5Lv7GYD22fSXA7dKfCaeCHd3M9tpi/U8i8yR7UDivHTwlQX3tMPFukpSOh0D3AnNxx2o9DMNn1qkfhUR1+aSvpSArCE5nVqDNtuLrDchpF3tVTjCqYle/BrCV9BifK2PKjuvK7rq/2qo5pnyvWjymZ9ppGse9QzQhRNlO39w3/JqJw3CY4y076lUz1xrUehF87Ca9wh9SIezNVMGe+dkAmYAfvV6FF4WGbpaefnMojWq1nccVLSPbx+8UMYkuhYdpjMqv9AKyQAWLCEZsgwNG0qfR08
 n73Kh37F
 uWm1S4et0gEiJPacJ+G3vWKVku/f7HFV/9bj20VSSTNXOTSTsSPXBlqS0uTw6ZomD2kmsj7vwJ/6TmsZx/j7Za3yw9qB1GPGgi2WWU88YjBIx1kjHYsEp2OfMP5VcouxNnwnbEdq8k6NDtNGTMdDO0W2nff37GmfTDBXG9bC2uuuUPQfK6Ixx8KmB3uqzxOMQmS9dNNF8Yqb1Pno4ZO5Ix+E5/E5wDR1ptG5X39bFVc6wIN73rFk7NIM/koLJdXuF6HNk7KSFRQ0mnWbzK4YBSqPhNHHs8NPYOqg0Fs6jOQeSHYLzQFyqYfWSs2l5VppqiCkoJFDjiiUG85X1lhACfMJ+kiDeYkRgztWN3oKQiSigkq1vkuwS/vTfwfabWKgQGTXxrPVWs6TpilSPQ31KT/9mRNFQcrIOEvicsO73kSjm+Hmj3xPu9x/E0EOnkpBBV38tetd28ufgFC83jRXnlZn2DpL7wgM6LjjPsQcnrtMwQ1OBByAhdT3fYyZjlv3Y1DKy9SpMsP6oZ2qrensHhcNjoYuGO/3R8hhFNkYLeInMaW8/3O+qEg43r8ESUd1/cpCXSTdCLgZShZM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Apr 2026 at 15:24, Pratyush Yadav <pratyush@kernel.org> wrote:
>
> On Fri, Apr 24 2026, luca.boccassi@gmail.com wrote:
>
> > From: Luca Boccassi <luca.boccassi@gmail.com>
> >
> > A session name must not be an empty string, and must not exceed the
> > maximum size define in the uapi header, including null termination.
> >
> > Fixes: 0153094d03df ("liveupdate: luo_session: add sessions support")
> >
> > Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> > Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
>
> Cc: stable?

Yeah that would be good, can it be added when merging please?

