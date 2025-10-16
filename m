Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75DA3CCD185
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 01:35:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD53A8E0048; Wed, 15 Oct 2025 21:35:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAC828E0008; Wed, 15 Oct 2025 21:35:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE8EE8E0048; Wed, 15 Oct 2025 21:35:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ACD498E0008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 21:35:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 75CF9140175
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:35:11 +0000 (UTC)
X-FDA: 84002259222.12.A672F22
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7B81E40013
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:35:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a4yjl6eF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760578509; a=rsa-sha256;
	cv=none;
	b=UWAymJObJgDYDjF4lxbadaZ/+3/3bVw1UotksHmKXkZw6Llb4q5W2bMcexAxvQTSFaiv8i
	/ctgk/Ar/azJByPuwCw/sdT6kHSkjj5UHaP4ZmGecYBkXiHU3b2uCwE7OOeNaT7loDleu4
	Ga7Yuuqqqlv832r7+v3WeYwRKeqyUmc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a4yjl6eF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760578509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+vBg3Y1zxNpjkdnEiOoJfBMyN6G20oAzPjCMdvNJIro=;
	b=mneIRxOV/fvdjTsTdMQN953IFXf8BzMLA3BBz9e8Q1vymHg518VNi16JKOpFgs0REryAF4
	/MMiORO2jwyIuiy8nWmX6CmZmzkjV3ZeuFShlr4qs83/aTee/gn9jDwhB5ztHY9HJROXrj
	b8cz2mttEUUEcyHx7Ux7Cy6i6g8ho/M=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-88ec598fa11so31717185a.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760578508; x=1761183308; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+vBg3Y1zxNpjkdnEiOoJfBMyN6G20oAzPjCMdvNJIro=;
        b=a4yjl6eFxufgM+uZabMqyiqwGdaSbkseCxukuaBrXojR6adNNoW7bNxEbA4TyHDbhN
         yBQf3bQxFEcCzBbos7fb8MLgQjrdpgX+amyE27A8g/wWPMZqcpjO4JwxqalU/XJpGkgY
         eVynrK0Xr62LnyNC1xnJnin43qPJ0avK2Ve39GUEICjfexRprDx2hZTxPm08aBnK9ZI/
         GWuePCL79KdQ16OKa0EE8Z3fDraCnzrs3LtYgI2fZObF5O7XBconesGZdUOweBr4IdOo
         UmrgukW4TlXm+SgbEfi/Yakexd3bMildOz4p/3L1kjZ3N0zbagw4pa7oNEAXsEFg3wdR
         cmcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760578508; x=1761183308;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+vBg3Y1zxNpjkdnEiOoJfBMyN6G20oAzPjCMdvNJIro=;
        b=tUUINQ14hBGgxvXCZZvyYdaO+/mftT+21R4fYoFJqD/5xNjMITSrpHGIaHnKBd5xs2
         TyHAevyIMZBLOcfLqzGobDJH0cohEd2qG7rJiNc3p1qLX40o5eoiGnPMRzYgyYwIev11
         6De/RHpp1ecJ8ks1CousN+KIhVcjEAUODA2P89slFpsQWgkwRu1p1MtsM3ePawSG3teV
         hZO2ktEh4CuIeoIFOWtkywJamjMOx3bKYO/mNsJUtv5KIRY4nAl4nhJiY1g5MaOwcy0K
         88NCPitW5uuqFTSVfhzg2iDUwh6Rxh7VC1rdznbRhUvJI4OqLApB8VS/TzrLEtnTMJRr
         lQKw==
X-Forwarded-Encrypted: i=1; AJvYcCUtuZo8eRUGk4dHehU0UNb5CfpuZAEEMjwbUqMR1ht5UfSSqx7woKI1cNG93+rLjucuUI5yXhNsDA==@kvack.org
X-Gm-Message-State: AOJu0Yylr6EJo19ObCB7OiU/hQR8dMy63Ios4ohHKf0PkbCgqWA+199d
	QQ0x4RpCp/xJtOJNQ8IfHMFNC24EdbKuQ1auqf2D5hJSWWWTxolXf0e8Fce2BhrTm8wxz6QwHUD
	vxQXXuAqNLzf+mB86sMVSdlXYc3Foejw=
X-Gm-Gg: ASbGncteFfI6BlP0s9pc0nbV0DWKndbU6iPniTyfvVHDd06ZgGHffgxJa/l5izCduQV
	9gzea/8g8S+M0Zgh4Uy08m11bNg4QgU5IV0vlC4N3GPmoZvHuxlzz4NIJSzpc4vOuyfnlwzvtix
	tHMKRbdWnSqicVfCJaX1spMC0FWu3aE+XWFP2h6wILt5LcomKjwwsuwfLbBf5ZDvHKueucA1tQP
	29MWBkotDRzWX47uB/KmNdcvGnb49J0vhXWru1BOfxf7eRtTWEVDmMC++XtIc9A5UMgDXBmCybi
	mjdOiSFWbQESl337coUtnVDTqEs=
X-Google-Smtp-Source: AGHT+IGZQlzyd00Bybs749UILue/xw+of4IdvRDz8OCpC01WcdDsurB8YspX85nlu9pwuR+NOemlvO1c2t26ShDne4w=
X-Received: by 2002:a05:620a:4447:b0:826:29a3:ca14 with SMTP id
 af79cd13be357-88f0ec9632cmr343756185a.3.1760578508435; Wed, 15 Oct 2025
 18:35:08 -0700 (PDT)
MIME-Version: 1.0
References: <20251016004613.514-1-richard.weiyang@gmail.com> <20251016004613.514-2-richard.weiyang@gmail.com>
In-Reply-To: <20251016004613.514-2-richard.weiyang@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 16 Oct 2025 14:34:57 +1300
X-Gm-Features: AS18NWAvja7C25aayp6r5f_efQsXabc68gTyUDCoCXBkMsLLdRug3F01lhUOy-Q
Message-ID: <CAGsJ_4zFwEbn0Z17ZhM151ruDrSpdWJr_QHXB138aYaGO2eTdw@mail.gmail.com>
Subject: Re: [Patch v2 1/2] mm/huge_memory: cache folio attribute in __split_unmapped_folio()
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	lance.yang@linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7B81E40013
X-Stat-Signature: ub1rxuiwe9aikgiwu3uf5gare86a6jtj
X-HE-Tag: 1760578509-760500
X-HE-Meta: U2FsdGVkX19z9vMNxXtKSuWgluTrOwxoImJgNM/mBPLtVf7DIdHpJWXZT+uqadgRTJa2RXiEyH6NHhxb6y+Ej9KGFnehVNZzTFuzVI/f6fVxXRtiv1TDdQd1Y5YfgGpaXnRJNTzuOQafezO72m8+p3VzvZI+w0mEnq7ciaSdQVeFvQ/qNjnLJXKH0Vx6w5MevsEJBaZ1CD3UMtDMLqM3GuSBB8P8czN3yL0Po2i9GBS3KZ1beDf4SqcUhftZ5TYshNbbTcjfnaGXRzezI/lL9Ty4vAJ2ATQP06h8vr5wRTaGjVOyS8N+I5Mgp5KOZQOS0s37m13E6WjLrH+uzJJfB3XxYxN49oaqj9/XCZ6+m++jgFE8PqqU3pj5WGpnIxzkESamKSsHTDKswHjmWMO6eiCEjzqbFR3kEGVfsxqdo2QQO4eOHRiatISVQJys4+UnzRf8i3JEDmlqAcWU7heaOeHSR9mvImuHNHPabspnr+6mtXMC5W8hKHyNGWu9K1bcqoDr9JzjszrAVOaVOLyhmdS51W+UbPhNn958SMpTYfzrHM0KXB8TfOD6306pJ+XImiOjJQac/iwQSVnKmAP8MlDIZZK+B/tw15Z5vq5/Or3kFXl3vWr9kh8m/LdBbH3prk0XF7Pij4clt59lkUBtn8rHJ6tX/oN1g8PL6PKHTF9Qc2Yu7TghXOaoM9YCMq4L7YIdvselvAObKvV+7pOu7K/iN9yJXK3PZ66LFknXi7vGrEo4sd49b6Xo4xorgpr+iFaofDWbjlqAUkJnwuXSjYwZXVcLuh+MJOKTwOYVce115I79dt3Mb1R/vELks/Tr9sOyQfHeAG4i3asseMa05oyjjXduoPXOtxpwgEK09OSvgiP07dF3j8Q04G8PKwZAMQKIA68OsJEInyX57U8X+Ygez+ksuhPZ6G4tBeXWRIfGGDWI7vxKaqAKDF0LAB+kVo0847thQMenbcnj002
 pjBjn029
 XqaKsLQ3fusFhwOows0MMpnYXPRrPcCVytplDmf4RAVIlDRRe68ovezWDshQdrkU97C7CWLzUN0mVJN9VW4I15f61+nvnwySqIZDuLSLS5yFUCodVGrOeKuoCZjvgYXfQf0F1diTSl/9R+L7/ZTgo0LQTD/+nKNaZPAP5T9Kqpsgoaspv7NXM1u2Gj02xcsY17oZ/IGA5LngtST5fxTSXUzPVW789c8JxocXl6n3IbELjg+xnRi8mkkXKCIgVtQuK1JMnh9atOFcb1NCdaueJiOiwt1o+WGTHdr6EtqPMJ6yrtMYsrn6IS6iIzDS5Xnkgjc6hAqq/pak4I2KR0HAlYYmSbTLxzrBBZ3AXb9YwgfOfiBB6u0QFJxxlrNKGxyhOn072SP7xOmGGXl0jfSf4Y0oKlXTg4BMa4kY9pRyCNPollOO+ipaPApaxV8He+pi1waBixKvCNW3xVRtC5TwXcS1kDEQ2xFpZOE4v/j/DjVaj8O+iuR2VGbOyIuqq9HbGYl295A1OB3lHc2QRVYuvJsokKNQVI1fj0EiQ8e3KfmdIGFM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 2:24=E2=80=AFPM Wei Yang <richard.weiyang@gmail.com=
> wrote:
>
> During the execution of __split_unmapped_folio(), the folio's anon/!anon
> attribute is invariant (not expected to change).
>
> Therefore, it is safe and more efficient to retrieve this attribute once
> at the start and reuse it throughout the function.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: wang lian <lianux.mm@gmail.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

