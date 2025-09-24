Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B920ACAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 18:39:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A7ED8E000A; Wed, 24 Sep 2025 14:39:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07F678E0001; Wed, 24 Sep 2025 14:39:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F03958E000A; Wed, 24 Sep 2025 14:39:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF9AC8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 14:39:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 64EEA55DAD
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 18:39:58 +0000 (UTC)
X-FDA: 83925008076.19.52E4E51
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id 833D1C000C
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 18:39:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F3FwoBwH;
	spf=pass (imf22.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758739196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ST5MIPZNh+rk0Xdo2MPGLb53Npr23yQ+YE/sn+TsaZQ=;
	b=UxtM4nOhC/6dadrMIEli15A4yxanSl6UlMXM16Lq7qADDi4lArbi406XBKLn3QfeU9moNS
	nVi7rIIAKdoK4umIu8sp2NDmO/1JOC+ef7+bT5z+Cf8MOEf1vgyh15Pcfq3Hu/PcRBJrhN
	0T8CJa9BcNoTXQ8Pz8Zh07lt5ZpZCBM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758739196; a=rsa-sha256;
	cv=none;
	b=4MO72RJyus7uAIi4kROq3HQc111cFCPUTPOl9XHVVid39x6wm/JSQ7PTpDorXODibamjD1
	ObIwwuE6BXIDPPiUGi+Kc9tWTada8G+X7fYLxYmDZim8fW0GhZR7LJwqi1+SDwTPEH2i3r
	jcdH0+YpWFIfXKyroTsExFKeu64m1l0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F3FwoBwH;
	spf=pass (imf22.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-5838680e242so73177137.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758739195; x=1759343995; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ST5MIPZNh+rk0Xdo2MPGLb53Npr23yQ+YE/sn+TsaZQ=;
        b=F3FwoBwH8fhg2foAheQM4jiS/ng4QZMt58KJI4B4aCJZeAPxnDXG9NhHtjfxvSUtMk
         EYUkO5dWJUZH8owhPlDljqgRERTeJJfFrk0DQMzZfveHI3E7OfdwyhmBG8BTGpIjeB8V
         R3hGBtz7q2kkTEh4dVRMwtSfw3nUwqGRe8YEGqwx1B3btCidN+5t6XZ/1fWAvsaY9mh/
         XZglCcxUkPFAmhZgDhOt5vnfKCOrBHrgG8cNXUtseyPf3h1pLj3NyoSqJiAsPEnujsPc
         tVLeAf62QD3/9jsPM3kDO7srtyEO6u2g7wgK9qiB6p8z12eqS51DKH42MewyVzCp0bHH
         xPEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758739195; x=1759343995;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ST5MIPZNh+rk0Xdo2MPGLb53Npr23yQ+YE/sn+TsaZQ=;
        b=UbDgS6Sf/1OaC49p46okc3BdMb9Q8yGlJgtFlrnOMoDmSbqTTxmCZNoDro5hg/B24i
         pm7XuGLo+d9S1poAoPdUs2cXGdf8Sw913xQPB0VozDom3296WiUk+UDGwEFDQd2lN/8T
         YHB8z/p+iFqhTdw04524iFQx+rtYiKsG3BGE9hgJBCuFxFZj6p/l+JmVLnoSCQv30WcA
         qDoAQofrhNROuWwapwMVlCyZt0NwO2siIL+u519QgpIn+QOVT/FutgZ4EGQ4ZnzhlJLt
         ZN7Dd2k2bWVxU3i5IfcFgoQ1zDwB7yQ0i0oDKJxkop4ZwqYbPX9aIy/teByxP9yDC4Gj
         FPpg==
X-Forwarded-Encrypted: i=1; AJvYcCUC8uDr1oqnnEdIRHfvWPlW/0mkf4nVTrqvEAknerZUImLCnq6+2Zy697v6iLl2FtLUW2jNn7UzVQ==@kvack.org
X-Gm-Message-State: AOJu0YyL4mlHEh4FGll1gMuHFW3qQ5hkf/B2D4pPVRPM+JDpKbOdtlur
	0f/FMBdpxTCz4TgLgXsfSbzlecuPmjreWyjb550n5594OGHXcdWkyGX/eUSq/3imYfcJsSnIjnq
	zcorNCLQ60fimohgiUOrVFHYR7ICHygQ=
X-Gm-Gg: ASbGnct10O0+mLHwq51xnM3Lp0ManmKWkMvcVklSpTMs+z2KR+H1GVyP7VH8iuBE+a9
	sofw3RV1KD3x7i6Vn+2SvAQBiAo/S5jyKqcAeVhNNNNP1oJlVFQ86uTzfA2fgKcGK3jebALMlEo
	big8TEIixPSwG2F1dQ56UXImI0uAgSmcXE6AeBmiIVFvlhgUHWwnEDscTjjfLDibW6xE+2JISNY
	UssMNxw0/v1jh4tccISCPyNtlT9MJ7hk4zA0pqt7cxgnOKyJQ==
X-Google-Smtp-Source: AGHT+IFKQvu7KK7l/LdyC6yvPgiOYdOAsqsd81zbe9e62XVFhzH2deCxnYNW5eJ9DEvQFVudwuvTGiufcXziCwsP/r0=
X-Received: by 2002:a05:6102:161e:b0:533:ff66:698c with SMTP id
 ada2fe7eead31-5acc4a1ef0fmr489265137.2.1758739195537; Wed, 24 Sep 2025
 11:39:55 -0700 (PDT)
MIME-Version: 1.0
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com> <78127855-104f-46e2-e5d2-52c622243b08@gentwo.org>
In-Reply-To: <78127855-104f-46e2-e5d2-52c622243b08@gentwo.org>
From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Wed, 24 Sep 2025 11:39:44 -0700
X-Gm-Features: AS18NWCWklyrjJnbHl1kScwWNFAGeo0abQkt5rG3TPvdr87PEwYrqpVB-8wXyvA
Message-ID: <CAM_iQpU2QucTR7+6TwE9yKb+QZg5u_=r9O_tMfsn7Ss7kJbd9A@mail.gmail.com>
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture support
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com, 
	Cong Wang <cwang@multikernel.io>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Changyuan Lyu <changyuanl@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 833D1C000C
X-Stat-Signature: fn8mqabj5bat9w4xegye7b596pnezngh
X-Rspam-User: 
X-HE-Tag: 1758739196-620254
X-HE-Meta: U2FsdGVkX1/RZJPg/VoeMul6IRufG6gFiZMxBmpt6IHZEcSLWga38THcdL+H8EvR95vR/LZwgKV5UA4Om/twocySyd9HaJ9WYJWZJJ8aSwnkgDMUZxKNzFWjxdd0oLmZqOEd/MyfRyQrAXlE2xRbmOI8CVbIz9+JO42b/JVv4dN/B/s8kuV/lcddMf712AUbIufXxXClsO9oOn4mpwQoBoPgQzCPIBy1thFxvAxAO1o+AgcdXVH0U2PmJcihoKtcFQH6WUcyJa2eBsFLyHIO3JndrdvpP5xEIH9azuY3j62DroaYkrkKzkazSWmXQaLbDidTSJZhy2n7Zbl9H6A/aYQOUmxZkZB1D55tfAKI1wDqu7Jdo+0ucPAe3rzo+NiC+7JtgtdpsgGBVIahp552OPI8PVYuCP6P4uRQ7h6YOHIEObig9uXchMweDKSBZY106xGZLRtHz1MmsG/NbzBhje178UXv2MsvJ4368R6NMgfjSIYQ5tH5yYBrTqnu8eWDKl4NhEtv2Y24aAo9Z82AvOTn5/Diu34itfptXoxaqwsXOPMKPQZaG0DGSg29wQYlWBN4d7IApsN8AvViMavCDq4Ei+V76WQSAapKMaZAq6mFzwa3FiskeCwm9yeSU0OY5QVtVY2mFC7DWaf+OhNRBJSJpsRN/fZ+5qGIpJGtmmuLZf8I2LyW5QbDuZ/0YUNKfV3ddHLKPjkrFtEiBwQIR5A/y9CyCuaZQ4qFd1SvZZN/yc9x9bZeFdpoI5H9JpON8eB2RgDhCMBSF5cXgiYH0gALCtLKcDrb+D1E8l7leNavwrxWrq9B1LiMOiqGCC929AHup/5n5+oNrZb5eOFRyB3+D9emK8DUudkgjvNi35RvV0KrMfsLYBvVaCXOEJtFVSvIszz3xDiLR9e+/zV402D5i0c3rHVu4UqmnTXjRWY3ort/+5CYwVLzmdleVeCJM+PPDZakWUZ9uYXiS6+
 vIGsdKds
 jfDGxSc6+S72JK3i/I5dtozuMdHtr7UMGhgRISd1XhnK4xGooPkG265MfWe2FwtZcOYVKnKMys+Mqs6c5Kw8eBEsrTirxpAt/saA14ecROuhklCv4dIV5qtIiLOFthEJg7elvjtvsxCHN92VJ9M83jsPH6Yd7clZk6042DDLZYJM8LG/80ZIkOmoekdaErAacqXurjabpjK+G//INU0VlftWGWFkYvbG1nxW1rMqNmt2Y67M89BgEZwusCcCYH0TASGoOoX3HkwTZdUUwUwp8N9RamuAsicr+nNR5CD/0vbmoCKQCSxXb/FFuCSd1AZvTrNyD5VHO1nUDTlRF+OqP/xiwg+CZfwpPO24x/Yyya+pqVhwwaD/7EOUjtOu8RX/6MKnWcGeKEwIx4PLLt+w9fTZ3GewQmINPDUzX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 10:51=E2=80=AFAM Christoph Lameter (Ampere)
<cl@gentwo.org> wrote:
> AFAICT various contemporary Android deployments do the multiple kernel
> approach in one way or another already for security purposes and for
> specialized controllers. However, the multi kernel approaches are often
> depending on specialized and dedicated hardware. It may be difficult to
> support with a generic approach developed here.

You are right, the multikernel concept is indeed pretty old, the BarrelFish
OS was invented in around 2009. Jailhouse was released 12 years ago.
There are tons of papers in this area too.

Dual-kernel systems, whether using virtualization or firmware, are indeed
common at least for automotives today. This is a solid justification of its
usefulness and real-world practice.

As you stated, it should not depend on any firmware or specialized
hardware, hence I am making this effort here. Let's join the effort, instea=
d
of inventing things in isolation. This is why I not only open the source co=
de
but also open the roadmap and invite the whole communication for
collaboration.

Regards,
Cong Wang

