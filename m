Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF56ECA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 04:39:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1012C6B020F; Wed, 27 Aug 2025 00:39:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08A6D6B0246; Wed, 27 Aug 2025 00:39:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6D0F6B0249; Wed, 27 Aug 2025 00:39:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D0E926B020F
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 00:39:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 399A1C0463
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:39:20 +0000 (UTC)
X-FDA: 83821283280.24.DF70E31
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2A3FF40005
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:39:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=gAad78ok;
	spf=pass (imf01.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756269558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w+7fBvxT47NeKRh9CQXlGiFXV2435SxFc2o8eLwIHQI=;
	b=b5nmHDTGSp2mROHU5A/K8AlU+qsF36reOt7dwgMfZ6HwEsuKkdw8IxiIjns4Zu4rbEZt7q
	tPP4sM/e+wEHZGL04ntCScx9ujSJsReSMTxI9z0jg6o7LRzRLiuokPSLMpITaYQDGvMKYC
	W8OrDek6ugJiDq3hziVLBV9LdQzkye4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=gAad78ok;
	spf=pass (imf01.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756269558; a=rsa-sha256;
	cv=none;
	b=JJyObdFQlioH/tkF6Ii6pTfcDmLtN9WOAWh9ERRyAkHnBx7eDUBz7eGua1CwuMdByfvhZ1
	Ush+TjwePL3Qs3FOdSCk0AKiYYnv0Mv9tzMTOn2IMReS6E6POUbFimJnygfr7QeNMTjEaC
	a7atHR94n+yyzI3vOIrYAXSOI+Fqb3E=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-afcb7acfde3so938397866b.3
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 21:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756269556; x=1756874356; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w+7fBvxT47NeKRh9CQXlGiFXV2435SxFc2o8eLwIHQI=;
        b=gAad78okc2OH6lQs5cWyAJHZaYay3o6ju4kCQnMqDP7kqIFXiTVq3XXDziiqGWXDtK
         D9gmJLvpsoljPoX36JmPncKgLmyL1RDHHLWxosZO3fnux0OJC9FyyWP6EtvKkHnJR35U
         qnzy7AofRzIJ4hNWdhldGS9ByPTaEu5DKzS4e5noi44F7EwvtdZKfXrIiK1FE3gHjo28
         r6qzIxvZ1Ps2+Hzxg+JQp60AE2kBVNbYC/YrgY2of+RcnjXVtIOcgHE8IGUVFPiFtKQS
         /YZIq+LgN4ornRe6QgpkEPnRJT4ESm61Y2314tcqkhsR/y8u6KcDOvVscNzgjlc9jQXC
         oAuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756269556; x=1756874356;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w+7fBvxT47NeKRh9CQXlGiFXV2435SxFc2o8eLwIHQI=;
        b=hDE3MEfbV5MHbejl3AAclOB/nnXLZqeKPK8IY0rkcslDUGy80cJ207shyGbKDED+qM
         ExH9+ExoSMDsoNlMMWqdgIMnHp0VPVxN3KuD59sKR86tAtlD/iWAWFH7MWu4fNgTwxcn
         IbtkXaNtsOKUqoLllK4bk9ugcDl+DSH0QIfZrwu7DOzm/akCoM5qwhPpCIXYVyfyyh0t
         ThdCNi7eKs2f6lhcwQ3ksKhUKBMUWEfVN4Ah3OEi7l2ieqhb/x++RVk1NxMkxGcqDoLQ
         N5TkiYokP3ieVMTb3CMqA3Sd84UmiRIkRkLN/NlgZCQpqi9P8bsTj24ckXcXdGqurcdE
         AjGg==
X-Forwarded-Encrypted: i=1; AJvYcCVSewqWeFBoO6vEPRvhGb2Z37RJD+zbKP0yLg1BGkROdt0inYsnOrLS3OAPqaGm1wEkaclT3ppeWg==@kvack.org
X-Gm-Message-State: AOJu0YwetR3Fyb8HDkUWWSGXWk8h1Ccgih2gph5W3V1VdCmICevcUUm/
	yh5spaG1W7l1HdyD+Yc1QA34wqpkS9W+Fi/6ZlklV0VnBbbnzTbX5ixj3mDTODyKctY/xgV/o3p
	lesCf71UvbXoqZh7P5eybKLp71AiNNg10dYy4LQ2+SA==
X-Gm-Gg: ASbGnctrZmWNvRfIs4Y2h4OFa84lZwjdREvFQWvTg+wjJrOOaa4B6IXsLBcfBkHBz8E
	LIM3qPVHAYcaOy+/SxJ/1oTfiV1SiKqfYB8P9fYmcZV97JcrT1ViGy3ZNa6L2Dnxfcy4pPfcuZy
	NW3dznyl5DYZ44lBV/D8DhSnUIpvEVDbF9EZ3YCZjr6yIvhU01Ti3IlbxE251I7CQSzQI8N6DUG
	hnzpbSkc61jMiy8nZvDzVtcm7Q8Ab0K6Bg=
X-Google-Smtp-Source: AGHT+IE97GlDZp4rNLGJI6ZTg+hYR1b7CnMyx+z2FCJCMuiNi1PioDVA62DCq6B/1u63gklsj5nH3/G9ncmoy9kc7Zo=
X-Received: by 2002:a17:907:2d13:b0:afe:808b:5c95 with SMTP id
 a640c23a62f3a-afe808b8a84mr881326866b.40.1756269556468; Tue, 26 Aug 2025
 21:39:16 -0700 (PDT)
MIME-Version: 1.0
References: <20250826231626.218675-1-max.kellermann@ionos.com> <20250826185515.7fbe1821713195b170ac1b31@linux-foundation.org>
In-Reply-To: <20250826185515.7fbe1821713195b170ac1b31@linux-foundation.org>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 27 Aug 2025 06:39:05 +0200
X-Gm-Features: Ac12FXzpY-u6yuFQv7iqdAnYP_mskk-96iN3wzKzIr8xkcAak2TmC4qnsdFa8e0
Message-ID: <CAKPOu+9wz9g0VuYDPiNDYdaGG-gdK86h1gGSCmVPsC2a5f-GPA@mail.gmail.com>
Subject: Re: [PATCH 1/2] huge_mm.h: is_huge_zero_folio(NULL) should return false
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, 
	bhe@redhat.com, chrisl@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2A3FF40005
X-Stat-Signature: ac3pyb3ywwk11jag7kpr4c4j3pkiku61
X-Rspam-User: 
X-HE-Tag: 1756269557-369633
X-HE-Meta: U2FsdGVkX18WI+JhAMw6V2pUIZVbP3sLe3HTR8MW14t4i2bWYoxuOFaeDSLgp0Ho4oru+xLj270ZVqj5Fu2TX0ierJ3rVMwY29CPB/DgB8yAO1mU4XM8DqPL6FJfSy789/U6jirczm5QNFSI83vW0U96wSjv6ERv5c0/EGAJBeeAitM8Xs2qp+0vU7Z43SYba1DLAL8PxxejT5Wfg5sVKzg4pf+lqNx8xAF+04dkA6hJvuAzKSKB17uFBkUkTh01gqDMtLnmoh5qPVbhpsaLuejZ8/FhiMOQq2jxuE9DvWvbf4FuShtaRG/4RI2rUS3VtCwnciAz3ypaFF/WQ6RMnYmbBEcrrg4gQJFR8xJqwFrzwNXi66YTKr1DtvbvWvuirVJgWaeW9bIDmt839I/pLklo2XOczaoW4J2tMpLrdVE4kUT2zwnRS/Lu0vZOoHYKFVEIVKnn2X8Lp7KBheDzGiqwudXLdpn780Wrhi3qSykHZefa0Tqw6d6sZSw9oUSCdNCLYAw8yhKn0qfVsZwJBPROZJeyHTwSxqvQ1+g/Am1MQIc9NsfnifnijxaYEXCfdT+BzC4lhwIggP/beM909zml37KoZsyvTVJvoqm/uHEmkj9RCzZHgK2ZSFbvdHVUi7bIKWlJlBpRlO6/XxzIthFN7a3W8qYwCNmQiOAGjmOebgtEYjxa3BQ1+cSCRaL150fYk60eIuIPz95OcoG0VoDg1S6hO231rKXJTdGtw3XRFX4AeBY+dxLhgIZQOdWnxizyVXVSBVF7TQ8U0QvKdkL9CdDPCZy2PLBsRFkScUaaCSSrwEmaJHNej301GeF1tTThggXQspAFkDPCXXCnkAi09RUOcA1K9Gph1gY8laPUKzNSzLkFIaVs5YiZCR3G1VyPepud5kPAnzU8n16CntwuI3T01Zof45+PpCjKaaGts5pvdvJMPPGKx5Z5GrrWNJ52xNKh3TlvUsG1LxU
 uRdOcH/A
 FFasmGUDskX34D5QxSGK3evngPL4dXgTM3t3787R3iuBNJvWNGajEF8wJZk7cKO3LImLJ8byYjb+RNVeR4p8ZULDwTkaHrtBZajHRBaTr4BZfjRoIe1YlrnlOvPo/ZLK51VoJhpNioZuSZam8l6X8XvGkxc/y48c4P9DmTQYhbwbgSlGRyn1zNidMLQK//Xt76evU+qzd+XgWMNpQMjh9KIqdqw1KwbW1qv5ugex+VAbZoq+AeY9RSY709QwHELKp816HohThPsd8ObksHRQGTnZmCs0wocc5170VjUtd/oKmWjs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 3:55=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
> Isn't it a bug to call is_huge_zero_folio() before the huge_zero_folio
> has been created?

I have no idea, but folios_put_refs() calls it and I don't see why it
shouldn't be allowed to do that. What else should folios_put_refs()
do?

(Thanks Zi Yan, I'll send v2 with your suggestions.)

