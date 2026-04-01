Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ED0010FCAEA
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 21:33:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C4CC6B0088; Wed,  1 Apr 2026 17:33:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94F0D6B0089; Wed,  1 Apr 2026 17:33:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8164B6B008A; Wed,  1 Apr 2026 17:33:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6C7C76B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:33:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0827F140139
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:33:05 +0000 (UTC)
X-FDA: 84611287530.10.E388269
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1C3FDC0007
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:33:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pSW9QwXT;
	spf=pass (imf28.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775079183; a=rsa-sha256;
	cv=none;
	b=eT2G9GDa5yxRD+XIvTaosNrwBWHEl0nxlUsjZ8usgwsZolE8VaMdg4PdEtu7W+DrITBHGs
	tB2ZSjr5V02BEVXIbhdo7vEJKJ47jtLxCwN2EJrHJ4mzcl+q0z0ZN1L7qPvGMmrR7ZCsBD
	4PyRVo44ElfqdqonoXhkJ65+tnp10hw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775079183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KVW1XnpwUtqL8EJAcpHlp3FQWpCKwFLG4TFpns8IsO8=;
	b=nS+G3lNsjYaJRa2l412FZ0fKhYZa1ns9kAwcTqTCIxxRqZx6zTpmRFsyZzFXDhGcqljUqH
	Al8oJE9v2zhY/HutioFm2YKysv0L4jcSdNg2JqGOM+B3rq7kCUd6sy0VXqxYsRczWR8OJN
	9POU9xHSsquOsWZP7Tb7U+2kNjsVRR8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pSW9QwXT;
	spf=pass (imf28.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48374014a77so1822325e9.3
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 14:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775079181; x=1775683981; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KVW1XnpwUtqL8EJAcpHlp3FQWpCKwFLG4TFpns8IsO8=;
        b=pSW9QwXTbeBS0xCzVdq/9wrrcOfzUIPV0UQCqfXizieqnmv3AD//I0JS1D6bQCON9T
         DYE1sHYMqpelVeJI8DLeT5wmiucphsNSPwKLFykTaJfMbz4Y8MLGxVFuJyX/ITGBgDa5
         FK64Ccvmbp3kAsgtg4b7pAYtXhpTx8EcrN/g37eA7Y3S2O69LQ/SKhwuywph/iDmir6z
         wMDMEmmZzpupIRmoRaObPswSjanw722au5TKqSG5U/9W8b3TCoftr+cqZeO1SBuxXAnL
         /RDZOeBM2YvtZ2MbxtFK9ddditPkjg9wy2FgAQNY/VbzelCgROp7d3U/eJYeNhEB+6Lr
         oZaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775079181; x=1775683981;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KVW1XnpwUtqL8EJAcpHlp3FQWpCKwFLG4TFpns8IsO8=;
        b=MBNNEdzH5huJYxS60QW79V+5tlvzNu0C9qDDzJIKCAiC8vBVho3EMNZNsP3nmrKn9y
         kpMHu6Jt23adgTU4JuQx29emJXEDNE/o3uvf2dDm17lvFwbApzKl/jPXFjFP2BkTNBdB
         hPQ0SEKLoj/Fsn7d7n5S0JY/iegg35q1zirXHx1QKSrwO2YhH+HjGbKlp0HZTMPA8NB/
         CRsizTFouAFggllDk57kVTK2IOfC2pOLhQyiEsFBthou0FPYH5PhBU10+ZjmdmezB/ar
         Q/Z6voLWMoe3N0cmde3/u97nPKVfPK/Jk21XinpAhPvT96dRAWRdMyI61F8Lc40X6OJf
         bzJA==
X-Forwarded-Encrypted: i=1; AJvYcCW+xDfLgezNRfj379ohz7EouxarIm2VVpx05q3FH+JQpyX0uiD1o5VuMk+FKrLuL22K9x4aNPNN3A==@kvack.org
X-Gm-Message-State: AOJu0YwzCNMvSDaKhPdL5wAjzfUu5d/qMb1f0pPgEp0qUoyJD1ZZqxe3
	5y57V+N34z2Lsteclv7JzxxMhiDos3fAF+cZ7uRF1Yq5SL5XhkuhvCv5
X-Gm-Gg: ATEYQzzrnQwTcPqrgLNjaejb0aOQr3hFgkjNSb4ivf5Qp6zPRpO3I9jSU7u0oqUB3c/
	EhmyCjHTm8OakjfwHlvgcS/Xz0Kt91RJdgggX+sea+OoAsCnPTm97uAi4cuoFcB1RT2hUn1lOQS
	I1DC9p+9w4NVfKxjgUJ5k4M5cVmPkCNS3/edCN/TUAl9KcJSNNYdQj8rx0gnaEGkNGpcYUbWJdj
	qUSe7YfJJfZBU3S+i70Bl+1zkkTD1eKQu6d7ksrEoefN1tlwWJaXWcZilZyE3MIK1bq8AFt+HO4
	g2npwbIApqUsLHVDpSzZg6X2sBKXn7onOC1Z2Xz0REKs8zA0qSslAV5RicsxwGiBukumZwXQBWd
	FCInQiHgaX7qeRB4uorbCB80niG+0OW24yf7ZmTc5ehsIuhHFhhwjGid0x2+H1ZLpodpLV5f0Z+
	8ysKi+2B7/GKvIq3sf6zdi2GC5PxlC3Y61VUaH8icVK7MmT+bB2H/STsfANHPBbEUKIQnkXwQ=
X-Received: by 2002:a05:600c:1f12:b0:487:2439:6266 with SMTP id 5b1f17b1804b1-4888b7b3c3fmr13053015e9.30.1775079181143;
        Wed, 01 Apr 2026 14:33:01 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4887adadf4fsm51766325e9.11.2026.04.01.14.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 14:33:00 -0700 (PDT)
Date: Wed, 1 Apr 2026 22:32:59 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] execve: block Emacs binaries
Message-ID: <20260401223259.31d61af9@pumpkin>
In-Reply-To: <CAGudoHEN+NMizX3yF8bDsm6+y0-jyFb5-fFogHWs3=F4MaHOPA@mail.gmail.com>
References: <20260401131226.4011156-1-mjguzik@gmail.com>
	<mxbttfswskgpmgakwz5cja4u3gzroonkqcqf4yggybtfolp5hd@qt7762avy5qf>
	<CAGudoHEN+NMizX3yF8bDsm6+y0-jyFb5-fFogHWs3=F4MaHOPA@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1C3FDC0007
X-Stat-Signature: s8ehj7wqdhrkc9e1k95cyp4ut3inqicx
X-HE-Tag: 1775079182-361602
X-HE-Meta: U2FsdGVkX19vc5Bu8IKa0ziZAodS9Z2dGRBk1HU2iVKiQIJdFq/EhvmS2y2Ba7qtUYp+daAMinw01MqyIv+UKgkU4SArFUB55T5fAqWbqn72qFiQUtL14LXXhsf1dyS7yd4BF5elPsne0GsEl/9p8DjE5CbHMG5IPLIV85lKEMIdDPPpYEVonn4NZu4hBxlPvjne4sx2U6yGqsJORZzTBvWyFFhvymMWk+aNcIx1b9E20H9me7sSFCfKEMVL84tcSt/uXghX63J6KrJJvB/6XlJ9Z9OqBPALtiJNf/VII8/L/rgugfsq1/gMo4w+SYmgkq6DNWTBu6Vm1hmIlSb9vCiJS+oEzCdBO6tS75YkD369ptwfayvqocvvmwjSkgW0kHNyY44HIffzlvgCzV6CcXAvGGHhbOYupTfnG7jpwkKWGbGqpjd1PZf5PJ+uMYws/K9vUb5WB+pwj0OjRV3mQClWpqINrZlfIhCh05q1nFGwe8wjgxbfavLHcZWv4vevDL/wcmirGv+yPJObxewSr5+Eh4MM8ReY0+nKBvjJVSDMC1ADFmXl8uLrvmDTG+W2prxoZK5ZpeGFNLCaz5dq5yRoS8CO2qK6++z6UooX1GnGa9pPva+/wYEdEiimsPKRNa4K/4RIpwZJcOLxx/QxAYgjzL/ii4Cp2t801Bw69fRoVdo+AlkIMzNSkdZnH/M/E29Yh6q/KTeLGYE5yWCW9p/gqm+dLmmAmAaoaqEYXnEbEbVV/6LzlorzguOZAIT9JhLqbntchSxtsdIJ2varSPtcBHUSnFWmR9/ksCkhAPbuGA2AG5BFQY0OcgRNKL8s+3r8H+MoMCo3u5qYEfoav76dxX6SeSx8rAmu783W1xKKOTVDVV1o5vwcsHtzk+5s4AJDLZMqvN0T/F7da+Kmrroml5EDbr4BPw3F2K3wsKuiYE1ML81Y/+krFhgoAYgmFqfYJrxBhnjjsRKeu/o
 V2DVUmUS
 y0pxPswRRkkIXv3vF+CxKvgsIHJtfAv0Tfv2sMS5tX+Z5w3+9glRIA9wHzqQP2rKb8DeOO3OJyc7DNqZZ0Hhyx7fzE8QZzG6FPBA/WSjMf+ig5CyOAgYjdZNmrkJvOtp1u8ht9aCrnQEctZqD/N4+66gsfHdoRDNynC7b4p8QH3A8afBs1cZOfGeKhnQTt5W6DIli5TwBeZMbYmhPoe+vAZLjrKmLs32HsMeui8mKGFX/5Q62pw2PVAUN5OO0sHROYS0nNP+/gqB3aXVnT6LPHk96GEjzJnACF7CNFXtt6ui9riM0gNaxtioTC9nT4aKTrEjgHDJutEcFJTNtasw0TLCcERkNPn94RZ1WbPmykKeToltqTG5RfNBW8saHK5YEIF0tmTXkub4NayKhD2a3Y4KENaCVV6adozMknPWGxXNDMV0KoMr0rVjOyHIInA1hwpWY6DVxhmBvjytbfbBSI5MBsLgxbeaHaPvHOM0RjpzpndNPTgCNhPXsYqMvgbwPEpFVld94Tp0YXkxYlKJL7Cvo8J9yTiN9Lwlq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 1 Apr 2026 21:24:54 +0200
Mateusz Guzik <mjguzik@gmail.com> wrote:

> On Wed, Apr 1, 2026 at 8:37=E2=80=AFPM Pedro Falcato <pfalcato@suse.de> w=
rote:
> > Can you block vim too? We only use ed(1) and GNU nano in this house.
> > =20
>=20
> I heard nano is a company-issued editor at Suse.
>=20
> If I wanted to mess with Red Hat I would block mcedit.
>=20

You are all wimps.

Try editing files in a small 'miniroot' for an embedded system.
If you are really lucky you've got a shell that supports ## and %%.

	David

