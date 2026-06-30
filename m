Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF1DEC43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 14:49:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6D236B00FE; Tue, 30 Jun 2026 10:49:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D44576B0100; Tue, 30 Jun 2026 10:49:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5BA86B0101; Tue, 30 Jun 2026 10:49:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 874776B00FE
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:49:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 004821C7002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:49:41 +0000 (UTC)
X-FDA: 84936862962.01.9BA51F5
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0F1BC10000B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:49:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HA7CnM9P;
	spf=pass (imf05.hostedemail.com: domain of kerneljasonxing@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=kerneljasonxing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782830980;
	b=Oth+M4GpwBQlSdTuapsS4f/jdDEOQ/zEEcg/ZPhVtnur5FvBUX0l6CtOXkgTwcUNnyMQI3
	NFdAjJnNVebcnAXE4e7eHdqtB9GUwl4ElOUoNt5+Xuqr/wxBi61Mr3UAxWIRP/XyCVUzWQ
	tkEcXOK+3+dTvtd9XGTwRDb/tpi9kbI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782830980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BAHFXtMiFS3SQCPXfcc6nAkzBIK1JQ7gQg2BRXU7Bfc=;
	b=Eamb3oXp/V2zZB0EsN4ujg0TSNhbOqT/CKC/tFKUx5MyOLxvZIi1mtj5ebQEHABhNAilT4
	kSa5fpHr1nqfj7R5WgI5XON4HgAGdSYXJLvs7wbz7Plh8AW29Y7scaP1yknazHuLsSxNQt
	1dkFrmzsshc8gQRetpO7lrSKltbi9jY=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HA7CnM9P;
	spf=pass (imf05.hostedemail.com: domain of kerneljasonxing@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=kerneljasonxing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-3996c9eeebeso38251511fa.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:49:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782830978; cv=none;
        d=google.com; s=arc-20260327;
        b=BNx44oQKzMxEKpkU+ify9usDswMRpt/+QLoMES4+vddqswdiPHeMh2LacpajgymjWR
         wdvJwtIRoc5sy9BlL1dNcg1oaz8Hheb+a2WHiE/D/weZvYHAxH5vapdQMdQHG2LaZhXy
         5hyqQaVRG7qwFgnAMNpxEEwE1vYdrXViJFBQv7ek9dTF5rXS+dJlXr2UQP3ADshgkI1O
         qZ/6PTT+hlIQe7tGkyX32A49Q224E3yRLkMMYVTphrNnYqZvMxnsd8CVoXFUExU0lVpy
         +wIEFa8KsOVxMqXJHpr7M+4d6i0ue1VtySHLrVTKW41dVQYeWATf5zgD+C6eG2aBl/Jg
         0rGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BAHFXtMiFS3SQCPXfcc6nAkzBIK1JQ7gQg2BRXU7Bfc=;
        fh=bjfkw2CWtFxoUjQeVvNClAWRhngodCaCGb08EyB9ehU=;
        b=ZUyofqpvl5tuJXBjTu4OTGJmX1uqbxHUKMFTjvXGf8lhhfO5JBS1/5Pi/nMpGsgbzH
         wkXbybVYhrmi27f+zWLVqOrIubKcZXZSpWNnQe32R40c1yhmV6AM73ztVMWdLAAsk4mT
         DkRO+vUuRYQNjGhMaTF60Pm3XSOL0BrPQGOJ+3cNp6oti8/NJghJMMLwIUpvL0OMtB+i
         85k/4Kc/AFu1HhtaCbe2r/iMuwVDdqFzpPW5Zk7oD/UDh5NMz1wgsKD3b2Qs4LfT1RKl
         ZlRcVfTxcZANqmvuq2qg0dpb/vhotQZHxXx3ABQY+69bQNq7PGhrud8vTjy/+X436JcE
         lcZg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782830978; x=1783435778; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BAHFXtMiFS3SQCPXfcc6nAkzBIK1JQ7gQg2BRXU7Bfc=;
        b=HA7CnM9Pq6mdatTQTd7WjXkTSxpH7f98JkoNaoCOu0wlaD9mhEqMG3s2m+ydVELtuF
         uD2z3UGAj8IIuMjvF0/bXguJfVTM4kq1BqZr9cdnqbCfSOebFM3hdFv3TFSAwLlmpTbX
         bBtUceZWHTobj295II4jiXe2DLu2DBlXKBSTamtYgV9IPsrBiFf8HEICbJifj3m855hK
         wKdWJBiZ/bDPrK6xbopJZt/oA2Amnh9eDBR9cyjOja5v2MAlXnFuaEp3FBd6G5tiS5ga
         m3kFQCXeqEm5ZbKO0Ni0IlVX3h4flxEVgyjfkAARB/16dXh/Y56jY2VF2I+PpDCP7R0j
         ozXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782830978; x=1783435778;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BAHFXtMiFS3SQCPXfcc6nAkzBIK1JQ7gQg2BRXU7Bfc=;
        b=FF7fgZIYyYT5IjlMl7Ynp/z9K5F9BgfSrQ2ZfJ5zKXOFNpmswvgrqMIXvWYl3xxSuK
         a1Gx1TGrn6Cpy0JG+8PoJwplAmRH5IoGZy0i/vhOsl+7IIhvA45LU8YBzOawhSckC3hI
         frAsnJl4WIwXSNLaZven2+ltlp9mNbkc2Ya41KQvvi05+fHAkco40NVGQfsTFhRmw9Vu
         EtuYIWTXQJVSj5btNmExEE62NLdHD4R9CCUuI4TgKV4TOI20oqofD6gBDMZXAGoM9U+X
         Yg6NESbZHLIrXGmqi8RIN27bTE7HEnd4lwa0hlL/eP9mUieDLYrtTT4kASm1aetiPGK6
         39Yw==
X-Forwarded-Encrypted: i=1; AHgh+Roq0JbNkTJvgf0aJa7X0pT2EUpE96qL8a5kdXIrlgFyO4JqgwHA1aA68qAw/JqvoOHQi8QHkWqKrA==@kvack.org
X-Gm-Message-State: AOJu0YzwI1J0SK7qe+rXYkWpV1Zg2aEcWGJcVXvFq1gZjaGP6APrIOpv
	D5eFs0Xo2CwXtOzoboo+DQd+U3jo+Rsvwbx7CuKE3p3M7WDNWBL9pUK269U2kDc96LnI8oklVOD
	WgvTcQNi1j0NYWSytzruZA8XTp2tp6cM=
X-Gm-Gg: AfdE7clxtInFS/FTyJ2X9qVZvdsMmYRTsQgcD4OVQZtUTe/HAjFoaU9HQ/ocKIGhqmd
	HVME/CMcgGVe83XHN7+byc7299t4yPVmDYrw3WBSmBBtrEyOHA/OraZW9u+Srk6j/xc0DHCnQ84
	r4NUEi5RhRJA/wRiT5X8Y0oTsf3UIKwWuzg99DJbpwifa6k0eBRv7TMQHb3cfztsRlYKaCIPydL
	BJvQRX67Fw6TZa+lYD2UoWmUZG3BZlo4LwdQ/0/yo8vhwRPk2spPDv/ZA4dsSTCTupJBA9GnX+P
	YQxp1M5Bv7ZFuhC3xmHFuxcUxWtxRISmZuOQJB0GnuUnQzJlchdFlcwOL6mmqzzj3wgY6BKK80V
	t4jxg158qjTSCmnqufI9G
X-Received: by 2002:a05:6512:640e:b0:5ae:b6cf:2869 with SMTP id
 2adb3069b0e04-5aebdb9485emr981524e87.23.1782830977995; Tue, 30 Jun 2026
 07:49:37 -0700 (PDT)
MIME-Version: 1.0
References: <aj5KJEIsTl6IK0nX@gmail.com>
In-Reply-To: <aj5KJEIsTl6IK0nX@gmail.com>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Tue, 30 Jun 2026 22:49:00 +0800
X-Gm-Features: AVVi8CeNolHc0bWFWi94se6V_El3cArCALeJfgf0e7sVp8JXgJSa3XDzBUrtcNM
Message-ID: <CAL+tcoA6=_paEdqWaY7-VHdBeAxEFeMCfTECAEGv3C6ZqFUNSw@mail.gmail.com>
Subject: Re: [ANNOUNCEMENT] LPC 2026: System Monitoring and Observability Microconference
To: Breno Leitao <leitao@debian.org>
Cc: linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kernel-team@meta.com, 
	linux-mm@kvack.org, iipeace5@gmail.com, gavinguo@igalia.com, 
	linux@jordanrome.com, amscanne@meta.com, sj@kernel.org, gpiccoli@igalia.com, 
	Daniel Gomez <da.gomez@kernel.org>, mfo@igalia.com, platform-driver-x86@vger.kernel.org, 
	acpica-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: s5ff8q4xq5ox7gi565omdrsmd1c5xqgt
X-Rspam-User: 
X-Rspamd-Queue-Id: 0F1BC10000B
X-Rspamd-Server: rspam02
X-HE-Tag: 1782830979-481880
X-HE-Meta: U2FsdGVkX19S8IB3FG0t6SVGoT8u73BSVvl1ZXt5t7Vx8/HiHbbJ8/aEyY9DA4q/eyz94nrQ0LgOgAXuEkuy22icvhElHLRWlDsM1mwNMABPxCI0fB/zrhUsTGDt8QRLPmda4AcsE4E7sljqjtfA8PRKmPxFlCkN9nrDO+S+cRJdZ9t4/WqgILcl+OvwK5ivXza4WXd+iMPWXxWXjKYN6FPtfgv6Z7mipBuvJ6Y4CjcvN4eUFvASWQbqx7mPvprcl6gYHMmqT1KGz7onWkXOxuLbidqa9D0NlmMVyEPbQugGBod9JmyGjfJesJTBbfR/UleffjM1QROmkIx1AA2K9kVyOAOAkbPHoWsvXYP03fC+ieUM2AMZeyTjrBf6YQZVPTavO23d02wN7wLKvu7jldIMNnWmwb4Sm/ZEW43yrQKyk+sMQyk13CCKPTfXMw6XjBQ7NmwyGv14FilsgOjr3kwxyQp7vaM2fh4YmCyFFaobWBKkwKEn6Mq0lyxs8SE9N7ylJmEg3vtU3VWHm0sypOKgGNdHvl3jZN97N4ABDhPYAoqj/hTUz/sjY4WeBxFJdkoJKHIxqUo+GH722PC2NixlnLny9fveAbdiA94x65PVrFVwq6RyItTiiIDy8rU8jPCoLnxMyOGvzl6HeZyi8vAQh9cxm1Eq8tBedDBJKVJ2wJ9QbaWolJhkgHRpU7S2+UcN/NwGmSRbbi1H/bCS3aNtw6z6JuXgadUvbRkCEU1S9yGDmkq1oPvr7LCWHY/hH+lJwYiPSdY0H2J8qyILtcZOgW9LzO71v0kWSgiGf4/ZcIQqjNV7A08z4yTTPgt4cYbGJPSf9MYN6UE8D77uYbl9QtrKxhPU5hGl/Yagi+eZTfLbacpOlVqZWDNwxp2mLTB98e/8IcYDbpcLSv25j3zSip9ccdpSMC7yfFKiAN734WvA3iwrqYr4cDRykDPDbv1+ZF/l8MwXZFpjk/b
 mekIe3+g
 8WLAOHbprqHcr7YFEFZROOFi9un/Jc99lO9rZKETeJJogXGRT5eT/VZFmhimHtl5vy1uxWhN2fw6xUJ7dTdjc98RKA1cx51g48p+iclRhqbd/7Psf98NYXZKmQ7e0OHT9XbFv9SmW2aF36QVTbO9jhVzZFHua0vp+IV51LcKXLNrWgFlMbRGQSJea2i/6pfi8stI0vH1qcpErOQCf9QCjXvDIFm39ul72I8tScOxmAqfZLuRF2UhhS7mRUNAdRF3WqRRMzM3pVtmtY241pgloJEbWgocvRTLQr9LwwcD3ARlGT94cogw7z5aI3YaQQRjbHnw/BXKMUK+LE2kyDlrauwK2iColFa7vFN4l3klD4g5IsVFiVPsKXXVcQxJqaU96n6IOPd3SLthSqofUq96PFvxqxdzHkRoXTJ1MQm5BW7ZZvpI6gIDCDe8EjBEW4PwxKncuwkCGt2hiBsnl4n6lfIRxI7gWMVYOIoIU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 5:56=E2=80=AFPM Breno Leitao <leitao@debian.org> wr=
ote:
>
> We are pleased to announce the Call for Proposals (CFP) for another
> edition of  System Monitoring and Observability Microconference, this
> time at the 2026 Linux Plumbers Conference (LPC), taking place in
> Prague, Czechia, from Oct 5-7, 2026.
>
>   https://lpc.events/event/20/sessions/262/
>
> This microconference provides a valuable forum for key engineering areas
> such as:
>
>    - Kernel Health and Runtime Monitoring
>    - Hardware Integration and Error Detection
>    - Correlation of Issues (crashes, stalls, bugs)
>    - Virtualization Stack Monitoring
>    - Memory Management Monitoring and Observability
>    - Anomaly Detection Algorithms for System Behavior
>    - Automated Analysis, Remediation and post mortem analyzes
>
> The purpose of each talk is to share challenges and discuss potential
> improvements. Sessions will last 20 to 30 minutes and aim to encourage
> brainstorming and open dialogue about ongoing issues rather than
> delivering immediate solutions.
>
> The conference acts as both a knowledge-sharing platform and a strategic
> venue for guiding the future of kernel technologies to better meet the
> demands of large-scale infrastructure.
>
> We invite you to submit your proposals here:
>         https://lpc.events/event/20/abstracts/
>
> Please select track "Linux System Monitoring and Observability MC"

A kind reminder: at the bottom of the page [1], please click the
'Submit new abstract' button so that you will be able to quickly
submit a new proposal. (Admittedly, it's a bit easy to miss the entry
especially for the newcomers)

If you have any questions/suggestions/problems, please do not hesitate
to contact Breno or me.

Again, proposals are greatly appreciated :)

[1]: https://lpc.events/event/20/abstracts/

Thanks,
Jason

