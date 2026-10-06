Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15875CA5FFC
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 15:24:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 087B96B008C; Tue,  6 Oct 2026 11:24:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05F036B0093; Tue,  6 Oct 2026 11:24:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8F6B6B0095; Tue,  6 Oct 2026 11:24:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BF16A6B008C
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 11:24:25 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 507F5A0174
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 15:24:25 +0000 (UTC)
X-FDA: 85292572890.25.1009496
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5E55B18000B
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 15:24:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aestrcC6;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of zokeefe@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=zokeefe@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791300263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xKfrb75oS59MnIyX9O05wmuY1ztKhtvaueLPjqfZHjY=;
	b=3dQRHHmmpLUSIdsh4317fWh5E6qnMB++n5TOtctN53w6yFedLJ1rNX/PWwLzOIytFA3oKY
	uZ7XkAPsbmPADZbfV5JBkXt0MpF24cIdmlOHk7dianZqterTFw33iU2cE9voRS/vug22jC
	TSU0LsSjrzf1H4YQ47DfJSbztO7y4hg=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aestrcC6;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of zokeefe@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=zokeefe@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791300263;
	b=psBVXQ7ioPSeip3gAUWMzlSBjsoLHbwr3LdELDwp8y7UEshriHsHpFNBRUDrYwVhWPZmhX
	VMtI0QRcmy4rZiJBbd1hQs4wUPMww8t9XiyjgBMTlRAFhNHWv5WlfzMt4oM7tqMTrFLYj1
	at4qFvXKFfSnEOK3LlcyJBjgnW63f5k=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2e2e4ef20beso70495ad.0
        for <linux-mm@kvack.org>; Tue, 06 Oct 2026 08:24:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791300262; cv=none;
        d=google.com; s=arc-20260327;
        b=MmBi8g3bLJvMqJq2cw2FVzZAFx288oTX96gYISsN7X6oY26MFqiivS42w4b1fA8l1Z
         zaECsswH7ZdMQYrl3QAi6sty6Ewz/8a/QeYIOEps4xKFQ99BH2pKEyTGGf7Vuc+XCqOv
         jSZNFPJk+dC0k4+E5dqF36bZCnqz6K+N9W/LEhOUEyScdL3QbW4Y1vniYizKtNgnfcOr
         y3p8gH3B3HQ7OaYD1BDZBy5RVZgGzJeHmL2zvHKRbeP0t7witBonisNmvnpMN3jIKwC+
         SkNNNtxJkrtg3R9A8njvH2Uti2DHXgw8RBoFgXPbxHDknUZtajnp97kWBNnqOlN5vfpX
         FOEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xKfrb75oS59MnIyX9O05wmuY1ztKhtvaueLPjqfZHjY=;
        fh=Y0DWWI665pQdWad5iU6KGRVeT9MTfgWq98cWa9ZjJ3w=;
        b=klZBilFK5Pti8yIugIZWzifbzBJH9ZIF45rSXTzO0icPtagXV/nQhmtnDBYue2jkCf
         R1OHq7YaS5g0C7xWDXrEEQEPGIVj2EVL6BvnXrdIwQZizovqFUvSywCAMqYgdWThTQOg
         BeyAQ6erI1O7q5PkXfOzbOfOTdB2yoOztYy7MMprwqX4Ce1RxKASxs0F1ZfSLrS2TYj4
         8HQJpGAO3zBPAuM8mV/4aau+zI60geI/AjahHQcE3QHJYO/g3lzkApPadocwHaKE8W52
         QEO1+C2SMsUiEXhdNI3pI4a6IzwV0jrVoRrbpFXgpWZ5jJQdIOu1DR+o3S1V9Vovqahj
         UhVw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791300262; x=1791905062; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xKfrb75oS59MnIyX9O05wmuY1ztKhtvaueLPjqfZHjY=;
        b=aestrcC6mCiU+9hpuhiWdKxKs/wuOm+gRE8skFYuLHgX2SsGuHg+NUf7J2McQzK+rb
         KvpiB5osuwlLh+IehLpZ+f9OMdjnvzuVYxO2ButL4foUlec26L2wqCXBfIeJCfuaoYVC
         PulhKAZZvObN+8/cHjPBPEJ690VABYTAHUS6F9CuYZ1W6F3qW9Fk4rDEP4aG/p2w047Y
         DJzuDM3F4pGgiUbW+Q3ymHYXAp0zyct2mThBkK8UNf2Wz28kSLFZolgO8o6LV/YmWzrJ
         BKApGuM2lSSkokMOVNsEQ+zGDFg+Cft2yzwh9PcsuOWXT+ajLLhCJAmf12stlrqt1mbs
         q/YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791300262; x=1791905062;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xKfrb75oS59MnIyX9O05wmuY1ztKhtvaueLPjqfZHjY=;
        b=JKY3F6NcbsZLD7SELk6c1dfeU2PoWQyHshNEpuxC+yKHBXjDQuvEMvGiURp98L/6j4
         5bBa4psU9PV9uKEKnlggADZwqWbNX079lN6aE/f6OTQ+dqQaiFY7/pp2OfH4pAhttcfd
         r50jhMERu3DZMjSa+MWwpP55NSWFAGxSGm/FF0U5kAEtyqrqSSQhFcOa49JaLezQ19FH
         QnKTvqHHYYqk2e/LpmJpir5l6086H5Fq5gvx4bL4obtWf11RwGc535SlIWRyspfr2I++
         xqW/Ds0NpxZZTha1YcZfeRMF+FnANM7QMLVY7NEK+z7zRhiQ+NOqKKm/u+Zw3UIZ5OLP
         UW2A==
X-Forwarded-Encrypted: i=1; AKwUvBzTiu/A7VY0p6dcYRVpWCk30LD11M74YiCbj8Dge8BY2kmmmGMVQck8HNsxcT75XM2wkZy/mL5mXg==@kvack.org
X-Gm-Message-State: AFq9FYKl8FAqBpTgSxrYDSsfHQaiEu/K1kAPRKgGLQbTJUE7ccxsE14u
	fz2AsongI3Ws9mmQeRGI4OfZGPXkoxgRpliffVCp31nSkoIa7q4ztbOhuzpKCEQAi5wIAKQrKIM
	5XS6j34i2aOuG8QhbJr2SzSlq2jwORgQzgaSbWV14
X-Gm-Gg: AYBFou2XJLvVHT3B5qk6IDE+Stxhk1VZchp/nQZlD7SXz0MwlxO/ESqVn2PHJH/3GSI
	3C9l4wQjF1HglGfkj9ESUym2fz9Dyb5bgVfZfOAJ8yvYBteBU5/Cs607/oFKYZjSbgfWQspRlmy
	belbnO2Bebagx/wwznwOJZVDKsEuM/Kc2nN+O6oI/51fRbXHBbXjS2V2cv5Z/Qfk72g0oi5hnvX
	544+qzo8ijNQk8u1B2yAp3ExqZicr01pFQ+ZR4bPWo0ps3vg/Y3Q3WFXI2NEefL4Q8wvUQjSVn+
	TGay0i/foUWZ3YcbmSKBmgI3ynuPhukx93yzMfX8fLbmn79lgjtySbsaeZaLVzFZREU=
X-Received: by 2002:a17:903:18a:b0:2d5:db38:8010 with SMTP id
 d9443c01a7336-2e5cd1ef5cfmr4407125ad.15.1791300261524; Tue, 06 Oct 2026
 08:24:21 -0700 (PDT)
MIME-Version: 1.0
References: <arZ5-VB0xkq-dJzG@pedro-suse.tail5790ac.ts.net>
In-Reply-To: <arZ5-VB0xkq-dJzG@pedro-suse.tail5790ac.ts.net>
From: "Zach O'Keefe" <zokeefe@google.com>
Date: Tue, 6 Oct 2026 08:23:44 -0700
X-Gm-Features: AclHuK_bdchmJ-KzjymtXgx5p_ZHCKZlLKAtdi_g2a4OL9tv8fgrVcG_DkfkKtY
Message-ID: <CAAa6QmRt+4w9U_R8B5s+uOmS3DsFhc5JfucGcgz7D96pNDrwGA@mail.gmail.com>
Subject: Re: THP placement BoF at LPC 2026
To: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5E55B18000B
X-Stat-Signature: h1sc3i33k3hq4biwypd4jioohyg88761
X-HE-Tag: 1791300263-809425
X-HE-Meta: U2FsdGVkX1/do6SLkTxmXngvOXOqwWXjG+4BRrd3bnpOEFlCXMSNrBEjjjtRlU2406ctPeufusxQ2t/MvrtzYe+0GF8jpFDMWO4+7OPbv/y5YGmqfYtOCwiIssZQC7J60LqdIF4c+/DhQheL69QmNzmiAvP9S9wTG+w6e+1lJhqrpJHYE15M+OBURsoq9tp4CiGF4jAYa5QtvA7OprGwwwMxehy2oTGNlsw76ClY0oFZA1B6jQ0dtlQsrMtz0LXu4QLmksrw2EBcL/2q/1/SsNBpIzMdxmbP8X3Q2R2HZ65T6pOCd4iR/83Durf0C9AOwUk3HUcSZkMGJ9eWpqShbgZbXpbd0NrgIfpLC3S24/wQoM4XQkf1lfl5lQQHyJVsljGeTsvcUFVbpqWMyN6cF+MFNfC7IaVf5Pwa6PMqRcMwVX+c8CyOoja6UqjYFodO4JoxE2uXAkBhpL+nuU9hsrTuZnOm9k+4FICg1CIpgkdBWBfaJ3ZXzcy8d6tr6waPUuNXKwEN2dCelW4oFymJWqFTK+Bb/tJjdMf3MJcjcjlOm04JNiGR5otY7NTm2eDA/VH0M4DibV/nk3+Ihv9ugSdIoz4vhm6iqakN9yMUagITSdvJphjvpPGLX/Z6NEHyjsNeutwaca8Jj9xc5bD3vQH1Qp1grm+AVkCut/bZ8ABNz5x2DZM/lDDt7BE/BJn94epzW1zFbnagVPN+XvHRCNg5773SmS7SS8G2MjJF/giLVHM8aORVfVUcmuc4sHOruYeKTz4dsJa+imC8KdGNabXDxcxg+Gyi4fSXIKl90nzAaJFw1vKM75UDjSe1g5C9JIGm8u4pwAO/Xydykgn1/pd7m0ftSyq6b6k4hi089u7wY3b6EizIu2uoki3RZmVK+3+k8W0cdIBTjQS3TjEgmNeJJVXP9TZKKJ1HSWdCWPMKxw+9jv1ohBHxL/gUs8myFdFS7fV8V2aRtbKCHSJ
 hWEcaIxV
 kmlTD0eFMXaVumk/B8hTx9socZhK+1fkgmxDPhNdy1Zp0V911QinB/6WANSO+RT85wMFgp4eQj/C0FuGIHpw/jflcGJyaBYsf6il0wkZoackMIsiczrTsIENELBy+lBzBXFdv9N9Qrybf9ufnV6acgPvPAR4BeLY6CK6uRRi6bMwbT8HoqyzRtRBBeuc/sz4NN7T/oMCwUh3D/015ScNOFwao2xPIafZ7HTsn8aqpCOkbR9cTWdPAQ8hFxhW/iL4/5lIGsKNWpdZGnZOTVpD0SE2usgFskwfzbQgoyCovXU/q6NbqG5qb0kFgRZ6fCqVzwq84
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 6:57=E2=80=AFAM Pedro Falcato <pfalcato@suse.de> wr=
ote:
>
> Hi folks,
>
> we will be holding a BoF about all things THP (but more focused on fixing
> placement/not-automagic-THP issues) at Plumbers 2026.
>
> Session link: https://lpc.events/event/20/contributions/2452/
>
> The point of the session is to build upon the latest THP discussion at LS=
FMM,
> and build upon the latest problems that have been raised over the last fe=
w
> month, to get somewhere meaningful.
>
> I added a bunch of probably relevant people - it would be great to see yo=
u
> there! and anyone else that may want to join of course :)

Thanks Pedro.

It seems there were some AV issues, so remote attendees couldn't see
or hear the talk.

Perhaps someone who attended in-person would be so kind as to
summarize the discussion here, so we can continue the conversation?

Thanks,
Zach

> --
> Pedro
>

