Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5622ECD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 11:51:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EC2E6B0088; Tue,  9 Jun 2026 07:51:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99D116B008A; Tue,  9 Jun 2026 07:51:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88BC66B0092; Tue,  9 Jun 2026 07:51:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7498E6B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:51:33 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2297414051E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:51:33 +0000 (UTC)
X-FDA: 84860209266.13.7E25D37
Received: from mail-qv1-f67.google.com (mail-qv1-f67.google.com [209.85.219.67])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5A97BC000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:51:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PmhmjceJ;
	spf=pass (imf28.hostedemail.com: domain of coregee2000@gmail.com designates 209.85.219.67 as permitted sender) smtp.mailfrom=coregee2000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781005891;
	b=kXvAFlRDakNFvN5fQJy1ItjXwVqEgtWKmo7l5zwPS903ADY4xkixmr7I7woBi7ejh17yh+
	fSi3K+wDj2RpRPhZtzsCU9UL2fComkWV5n/XhZiu09v7KDGVzJj9Gs4v3j2wI9LWulYuWA
	GUnakVhIDhQejGy//mC1FwvynDy0lW4=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PmhmjceJ;
	spf=pass (imf28.hostedemail.com: domain of coregee2000@gmail.com designates 209.85.219.67 as permitted sender) smtp.mailfrom=coregee2000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781005891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6wuFDmL803A+ra9Y/Q94lDmXPf/TPRYuK8QjEv51vX8=;
	b=sIc+fazBGX50Szcd/ZR6+9j8vPR+gK7JTVll98LjKAHpD8W/ix9sce4Vaj/SzFdAoOq1AT
	kLzIFybgX9U8bNFrTw/SNSuHCM20HMC1lTHxPuhWOwxy9vCJN2yyfonR5VCylrTJr5N/jZ
	yXFC/fvQqWnrExJbO206cB1uQDGeSKc=
Received: by mail-qv1-f67.google.com with SMTP id 6a1803df08f44-8ce9d444173so66408766d6.2
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 04:51:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781005890; cv=none;
        d=google.com; s=arc-20240605;
        b=bgZQerg2EL0reJobZKkMqMpVqPolQ+Y8RX026NMNKCxiCkb1T8LpmXejpHqzapiQIO
         HIbrKXoLMf+EStrg4In9qXtMbeeEtS9+RBY+ialihhuEYm87Nv9N5RM/+BFaW3DffORt
         BsMgw81LQPdJFJVaiw7SsdT02MBfzhW9B6e3kYfVsNK7co+FVtAHZ0tDU3CCCCvyNaWv
         4EUWP6AmNTdfYLuwGXISnYYcWktk59ATtx5azk0/M5KFFIaDkj0bx5d/KYxaDxMp2WcM
         mt2FdqssoOIqynvNlHxtxKxFGpQCfl41iZfO04Knvt6VUcimd5AmaFSACRFSU1A7rGcc
         DIig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=6wuFDmL803A+ra9Y/Q94lDmXPf/TPRYuK8QjEv51vX8=;
        fh=0uH/GqqFUim+poec6B9hrHVK6GVfwvkbCrxnccAkL/c=;
        b=FF3ANQJsWU41JnDdCB7Xfh3cxZBnIBZFqjXrPtFn63xlvQ64M/PBNXF2DRMRFc/rRo
         7iXU+zY0Q3DH2PP7cyfIno+w4ZnmIH5dVAyfnyN0QeiRrQkS+UhuB9lYd13NmuiOSyvV
         pkIfAv6YWNYrpiTroHhuWXGF2YjFM3WbhArfahkg+7beoyiqs1nBoFy8jsAkSD4iPN0I
         N/1J8yPBK7NGiNigY7chrnT3an+tCw5t8AG5bDYkKNYVDvMiE9LPIqLk9cGLASyftLdS
         u2sOZzSHTImm3deTqPJUBtZ9+xIk4X5nicEdlyDSxZDCSO8byFaCxpUR7iz0D0ifnF38
         OwrQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781005890; x=1781610690; darn=kvack.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6wuFDmL803A+ra9Y/Q94lDmXPf/TPRYuK8QjEv51vX8=;
        b=PmhmjceJHaPATLzPtLBI5ZBQZ1ycerP14b6phhaO9kgy4dRxwrnJ8ioPSlsDMhAeYg
         GG2g7FRqnqeG+GMz/yK54n0iUMxfdTTkzG/rU3uGmWkwIBu0hzE69aN3t0KDGLDI9fwj
         CoGUD/oG9DelDIwmza6DPy83FDg61rFFHnYaWKCdLJO4/degsZCsUPVgQHagJRrfvf/v
         MtXkIWEKy7KMdGUGvSoQtl0SsAzs7zvvdtSzH7oS2Hx7y0r0fR+tKhvBX9Q4YGwb//qg
         GiAwkPB0RclY+7LA3205z2G04xOy5Jta7OFg0Hh+8F6bLFt2dkD0WYnTa3Pc5P68VOte
         Ht1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781005890; x=1781610690;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6wuFDmL803A+ra9Y/Q94lDmXPf/TPRYuK8QjEv51vX8=;
        b=BEijhWJQ3P6N2Ehjs7u4FT1ejGYdMzr8f5qwMZIHDy9CeWydXw2d+vzH8ERlTRqwZ+
         TKeb98brOfNttQlSQSKoHa1S2sx8yTVbe/YUNolsLUjYKclVnJwkhvyipuFkCL45zm2Q
         WNPG2dSTirv88pF7BBQHEp1PYWpegW2BaxNNBvg7OKfEGL5CPt0hTGt2Xn4jrV0T06Vp
         clyb2NXydccNwjKrtZ1n/DgkvxundEjm/863MxAnQU9GKboSjSt/gLKiueYvWYmUTwVU
         LmXPye2t401DYtedVbRMitTNpJnX35uM/UGguGkQlnEaLq0B7Cm5xAbr+vnwUw4JJIuN
         nv6Q==
X-Forwarded-Encrypted: i=1; AFNElJ+lV2MZMSP7o+oupUYH2Hg/iwaJe6Yd9adSuf4yd17W/RHOc+5EYzxnNQKYT/1dPKXbUAjBL/auMA==@kvack.org
X-Gm-Message-State: AOJu0YwWO6MU9nTV9H0xSdF7aWZwmYbwc+OY05hivD+Cvkk/9bmF6+i5
	woQFDS3TNVrBCrMQrxxaTpi2jwGFn++ia7QdZ1nTqLjlJh6v11qFRfQtfH7pAcJLRApL38psH8d
	ZpaspHrGD9wpbdw7MfuJpnh2hJQJcWe0=
X-Gm-Gg: Acq92OFN30m5SY3ZBYbzSf/Wsn3nPuH+9maDJw5gYZk5eCAghcNKXh3Ft1Z4jeO+rH3
	xU/Xys+YNXCBlfFRLQiRw0FJW1+wAqlPa4QS4luBS3uXO0200fqP2PobGxHHGDHQ0iXQ/k/KR4e
	gJ7W9RQO1rkrJRsRIH2BHxAa/jkEea0cxHHP0QDwUpYgdN3I/SFSt1vLwa6SyvHcuoWF0kiT5Jt
	KOtVxOF7QHbRZdpkfsi+iU8DPbZL+h88gHJr8Be3XPDpEadhd5CNK2aH6pURe7RUjhGXb+KF8bO
	1hxYPKytp6mz/af/eA==
X-Received: by 2002:a05:6214:3da0:b0:8ce:7cd0:1431 with SMTP id
 6a1803df08f44-8cee61392bemr357886826d6.36.1781005890152; Tue, 09 Jun 2026
 04:51:30 -0700 (PDT)
MIME-Version: 1.0
From: Longxing Li <coregee2000@gmail.com>
Date: Tue, 9 Jun 2026 19:51:19 +0800
X-Gm-Features: AVVi8CefuB0RtwgsY-u9Qxkb12bEVZSdtKlTt6cAWxda7hYHRJ2jlRbWiD2FsIs
Message-ID: <CAHPqNmyHRwhi7uZN5WP8h8w3peAy-y4ZTmN4pb-OaS2RbdkD3A@mail.gmail.com>
Subject: [Kernel Bug] INFO: task hung in zswap_decompress
To: syzkaller@googlegroups.com, hannes@cmpxchg.org, yosry@kernel.org, 
	Nhat Pham <nphamcs@gmail.com>, chengming.zhou@linux.dev, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5A97BC000A
X-Rspam-User: 
X-Stat-Signature: pxkyqep4jz3toe9hecehperr1br4d47q
X-HE-Tag: 1781005891-926292
X-HE-Meta: U2FsdGVkX1/6+TMz8RzXFb6LAUhz+APN2+PcRn7G/DwMmp+fNbRrfL79ByKKirkI5TNdcpKAuEe8clYQIvjnYbMFp5YNrGS4y5czHwYn1wCpAYohWJw93OpSdttqECRDoQnni7nOiWIMvcJyO5AmSszCVGjWeb4V8+jYDDdNRqUjts3t/G9AqZQPLGff1kAkWBDWMIDL24D4qevDaLy0I+HId102msZ6dV+e166NHYnuyBqxQJoRvreRalW79vxImTcht9WkLHmJV03+vx0VucKfchtDk5HY2RUsTyLfcame0WRATSTNwXribfb3GRjE5hSWA8Uk6zMQ+myHybbWO5S6KTFvCN6C2cs20tSRBtgQNM917HGGhCwh1dULOSSvNBb9Vxgan7Lx9Vi5wbdCa2NBIYtsuQD/A9jZD6nf2xmUN9LwworpMjwPEPr+e2JTxSpMrhNhgIv8Y/ONwHLieRq23sWsZ4hOL+nxjYNCEtCksYmYUvAerx+TGj6G0x9nqbSJ3o6XZLez0sDIxRumNUd1l9kS31enGZeiszi4K1qA3sx6B4kIfPFZRlPVmPyAg1trDkHJA3w42icT6OoMnLPQ98yomKnVmJVEDnT5R9u+cCBLXc1QxaD8OtrdgrQzVHr5Z1L7zZUziEBlbkVyCFFma4piyuualdXNd1xikIFzCCQ0twHJ1D/P8LIA6yBaC0zXGHk3GiF7BYuubNkqqGS6ycE8bfEJQ8MZPHiN2xfb5VkYrSaKOc3LHqCJOEmHf0F+jWAGm/LM23Vltk4as980+JQD3iU+xGC/zf7zWk8sc224M77/x2zpQkch17ATYEf0fxpZuIcw/btxx1wbaAv4LaXBJxku2vpf6Tv7uuWBITH2IcTWhPuEfXSM3fri/3bo/ygSs/bWJNWCw8iUZn+R78btQ9MKj7R8PrzCdSzJ0cRGnUmalfKQTBHKYNUoKHf6vJwZryBkHz7TLhm
 2znKPhP5
 TzcWwqy/wswBQbANdqU9q4j5A+lQutGlX+InHS68NzNlYFeSvusoQa72DCF2J7lt2NpVk2ejrbVmWXFwH3Pn7E2JW5DPZQXxp4gtOtAW8+MUSbGI9I4l5W2W1zFLeB8aXsUAUWt6SdgM84/HISSITkWPRtcNx/DcPMH8kF93klLQorubdWIr47u80Eh11B3e/wC8djrL+3QnqtevU7egQcmHKtgDH97pEdG4xrZFqqUqyZQx4Wq50vQ9YaCdmkWpS302yMumKIK2YfTgHnTY1LxMgv95kwQgqsAT6MHAbLFI7XwgiFb8uMn/P82ojdsWcfi0LZKzKb1tlgpAUg7N2BOwnBmYXvvg0I8zO793i5VNpsHP63ER8AIBqsEOuOlM2dw4T6WthTggZDNzBIVjCO2QMHnJ+EWwj98lFI2ewnM8h4vP0+B7kZf2033/tL0q75phpkF83JwL4UC+ZCQXONRwNQBzvbs7rNVeQQnoyeygO99gx7DkL+L8HpJjOTRi133md27ZY8/spITmbdL96P/jsvp1sjlTaABbdt5cm5kFgeNMXmZdkwvDEZVxAB9DTc13T0FlxLW6FwPprX1Wif4LfqI4o021SxmHXr1Ct5sB8fnM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dear Linux kernel developers and maintainers,

We would like to report a new kernel bug found by our tool. INFO: task
hung in zswap_decompress. Details are as follows.

Kernel commit: v7.0.6
Kernel config: see attachment
report: see attachment

We are currently analyzing the root cause and  working on a
reproducible PoC. We will provide further updates in this thread as
soon as we have more information.

Best regards,
Longxing Li

==================================================================
https://drive.google.com/file/d/1Bx2unEf-QntjVi8g6Zw7QNO6OP4cjGO_/view?usp=drive_link

https://drive.google.com/file/d/16xzUrwOvwE67cnMPH3AhhNRWq6hr26Qj/view?usp=drive_link

