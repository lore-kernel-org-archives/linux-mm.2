Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC31BE92FDE
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 21:16:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DD6D6B0088; Mon, 29 Dec 2025 16:16:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BEE06B0089; Mon, 29 Dec 2025 16:16:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C0836B008A; Mon, 29 Dec 2025 16:16:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D7D46B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 16:16:43 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8BAEA1408BF
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 21:16:42 +0000 (UTC)
X-FDA: 84273767844.09.B3AB3E4
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	by imf12.hostedemail.com (Postfix) with ESMTP id 515894000E
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 21:16:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmx.de header.s=s31663417 header.b=PT49dsBh;
	spf=pass (imf12.hostedemail.com: domain of markus.stockhausen@gmx.de designates 212.227.17.20 as permitted sender) smtp.mailfrom=markus.stockhausen@gmx.de;
	dmarc=pass (policy=quarantine) header.from=gmx.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767043000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hA5Ebdh2bxPaB9VaXe8HSKyeMAoLjA1IFwXQHSWBN/w=;
	b=kkLhESVmrF6WAQ9Bvz+mpQQulFIrm8oXYBTaCy727gmvm9L3vsG1ABipJsu1WtuGIqUJAT
	ONRyqtPDs/X3iQXRUembtFB7fPQAWkS+MCa3JEW9mSOzOkk1Km+/XuicTD3pMzcpta3BHq
	GAxx3DtGkPm0xoL2yyzoqMUccR1IjEE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767043000; a=rsa-sha256;
	cv=none;
	b=ymUZZ1hhll1kx5JokkrWnXkXn7guvNlDQuahTtaPZFwgLV1gcIRK3Yw38F6svBU8+S4AK7
	KLoOVu6yc+xLg+SepfVDmg8gBdVN2hdJfU4c+teB7qfwuPiHejfyDxjxsIu/WoCK1PWNcP
	Mz6029Yl0vCVTc7DHCfFqEpgpbmwXqc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmx.de header.s=s31663417 header.b=PT49dsBh;
	spf=pass (imf12.hostedemail.com: domain of markus.stockhausen@gmx.de designates 212.227.17.20 as permitted sender) smtp.mailfrom=markus.stockhausen@gmx.de;
	dmarc=pass (policy=quarantine) header.from=gmx.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1767042974; x=1767647774;
	i=markus.stockhausen@gmx.de;
	bh=hA5Ebdh2bxPaB9VaXe8HSKyeMAoLjA1IFwXQHSWBN/w=;
	h=X-UI-Sender-Class:From:To:Cc:References:In-Reply-To:Subject:Date:
	 Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=PT49dsBh0JsCv2ofnUjThxJ347KEcZjVspaVQRuvaLvoyp+aPCZSY/54svie8wsc
	 0KxVbBATUadSyvBZ0cl+JNgrJzCfzp7qM2gNuICc/DZzk+M54IWTG/kw6cffGqSEw
	 cD7zy3BCvhbTKxK5q1pm8z8gSxQVG4DYvEX1L3ksU7SvfyAQZjWV8wp6eDI/4FO1a
	 Q55wEZf8QJ/Jwwgv/JJUbtnQMjZuXmaigWqt4y6oXgc1cTTn8bvVoICCURdXE/FYZ
	 icdb2TG7f5GthMTqjE0F0vkiGE7RAMB9K6lCuPJw89LkfN0s6/v9G+LJC8HM4gtww
	 DYm/tIm7dCigZP/oOA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from colnote55 ([94.31.93.28]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1McpNy-1w8q4K0hSE-00fDg6; Mon, 29
 Dec 2025 22:16:14 +0100
From: <markus.stockhausen@gmx.de>
To: "'Mike Rapoport'" <rppt@kernel.org>
Cc: <tglx@linutronix.de>,
	<linux-mm@kvack.org>,
	<linux-mips@vger.kernel.org>,
	<jelonek.jonas@gmail.com>,
	"'Chris Packham'" <Chris.Packham@alliedtelesis.co.nz>,
	<hauke@hauke-m.de>
References: <007d01dc78f2$1ca4bf90$55ee3eb0$@gmx.de> <aVLX9yLmIBPzI0MQ@kernel.org>
In-Reply-To: <aVLX9yLmIBPzI0MQ@kernel.org>
Subject: AW: HIGHMEM freeing patch breaks Realtek RTL930x builds
Date: Mon, 29 Dec 2025 22:16:12 +0100
Message-ID: <003f01dc7908$5d0266d0$17073470$@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFaCkT/QJ6/mAqkcN3Pcnid9AcWCwK/dj1Ktif7s6A=
Content-Language: de
X-Provags-ID: V03:K1:aQIefrBEo7EkLSPFHf1py9vRW77vEn+X79eSyO7pjhuV6EneUCK
 KReikuPrqvWoWunse7F22+kUqzaz8RKU0ISqPJBobrKeAdoi+FRzND7hkJVqdqvr9468KhI
 nUhSGeFX1gwwO9UffKAM9a6eer4/0uBktqf8hS/B01LOkZSwMJv4ZyV5w0SC9eZfhpM8q0U
 zC/Pos3cd8sNygXwVYlAw==
UI-OutboundReport: notjunk:1;M01:P0:YHCoBRlO2Fw=;7xKUjZXrDsYA0NpgpFX8dVwrMK3
 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
 4ZQvF/fFfOQ4OLSsc=
X-Stat-Signature: b3y8ttpswtmw84toohk4ed986a6xzje9
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 515894000E
X-Rspam-User: 
X-HE-Tag: 1767043000-452953
X-HE-Meta: U2FsdGVkX1/3D0uLV8+aNGfV22+x+0YgJcMkZ9GpaE67c8EzcS+k25Gc6q++yz2V+74X4ZcpZoE3639atqE7xXlXt/K0djnJUnRMMND/BADkC7Jdesa1W70gMFnPl5x4XxybmNwywj1A49KlIf2eW9cAVgE7fxNRjr9K+5Tdomue7pvUvqslTMfwYJ1lFkm8eI7tzIIvD/oFUnenomd/FqiugDYptHY48dsKwm2sb/jTkVSoJtn5fXgFxUYG7ajzb082/2qk4jfII+AcMk8F/oVO8c2CSe9FJISia5DSDPwQu/LtlYeA0HstRLU2uieFgQkipeo7eWs2rzLblqIA30xkmN13bYO37ITu+yvAKapClyqzzH9TCKmGToMQ241KFQyM8LMh4R12eOquAq2vzBroj3jmKpjm9+/Vb2yzNhqY5lmHT2aCnE7IhOEdzHA5PFn0rtKcLi1z9ou9NOlbYkTejagXS0OI++WkoV1R/nrA5xpWuTylm41OWWHkOd4j+CwGsk4rrCliYsah6SOkmFagjIYlnSU3DUz7OmrOhNnwCqinGaMp2Keg59cw1fFNRPQrJOrgaofuu+5TQ60L6R9ZXQCJeIZ6dvac4st3zMsSQ4dkJ9sjKaa+nSROE39zVjNuJQ9kyL1TJCz9zcjeuqtbX71aTN280Jda72PWIFjLQ22hQnIZeEsvN247hyxjR4TuTvXX/f7qJnfcozOYunron9eoDHjtPCmbNNDH5Gu0WbGbT8kp0C9nfQCTfnSgAwxKnBKq/YABHqCS4IzBA6nbXTNIIF8rlNiA0/7HJeqsp0syL5RlArpygLpPeqXWPopTbMshkJL8/S4F5AEtJOLgQxyQ7BOZeSIyEgz1dEGbcacRa7/StSo/m67g8jGiLqZPy8Vh9iPYBeCu4a9qpFmcdgwDk+ly7KU7YQ4OJpKCdWBOvHN+IgsHzEBAvvy3T5G836KTfiwvzLvQbz1
 lHZNUeTi
 6ii3zql9PIS2a2ASbziptMtu/8sD0aOIgdQSCyLENB4lJf3E+tKJ8B9xL4IkpIoV4JFU0Q2KKw5Ay911qzZrWdKQDa38uvzvcyjVFOa7BZ13YwwdcMSuX2dr+b9LTtW2WSGJilVxuagMhfbRj7pjX4jKJZZYANni9BcYMoCUSyzMS8WM1rn31T8S7L3RmM3DDqVPibsy5xqBSzY8h3H7+wARKRuQJBALGqSDv2znSFSQriaKMdjbdYmdPHzyrhnVOQh8tPU7mehoaKk1jA3EKZrfiik7ZoU0Ri1aVZgcnZ86aQpD4CKy6XXs5DBU98h+PFJM6NmushCY+IxJM6Vp3e916kvl9VKoTmmSvWRiyw3xRnr12Lr5skRvU+SLZcdKHjX/G6ch0atSVbwE1raoj5KZewV1Rb1UdoLK8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

> The successful boot disables highmem:
> [    0.332305] Memory: 495640K/524288K available (8188K kernel code, 647=
K
rwdata, 1504K rodata, 9620K init, 244K bss, 27528K reserved, 0K
cma-reserved, 0K highmem)
>
> And the failing boot actually enables it:
> [    0.332285] Memory: 495640K/524288K available (8188K kernel code, 647=
K
rwdata, 1504K rodata, 9620K init, 244K bss, 27528K reserved, 0K
cma-reserved, 262144K highmem)
>
> so I believe that the partial revert should help.

Interesting find. That is strange. On 6.12 (where everything=20
works) the 256MB highmem are detected properly.

[    0.242252] Memory: 493784K/524288K available (8373K kernel code, 725K
rwdata, 1820K rodata, 10896K init, 248K bss, 29384K reserved, 0K
cma-reserved, 262144K highmem)

Additionally I identified some spooky highmem=20
initialization in vendors SDK prom.c. We never
used that before. I added bootlog+code snippet=20
to the github issue [1].

Just to be sure. Do you expect highmem to be still
detected/advertised with 6.15+? If yes I will bisect=20
where the highmem detection breaks prior to the=20
"suspicous" commit.

Markus

[1] https://github.com/openwrt/openwrt/issues/21323



