Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5824C982CC
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 06:18:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4C636B009E; Sat, 19 Sep 2026 02:18:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFD756B00A0; Sat, 19 Sep 2026 02:18:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C136D6B00A1; Sat, 19 Sep 2026 02:18:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0BE96B009E
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 02:18:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B22FF801D6
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 06:18:21 +0000 (UTC)
X-FDA: 85229507202.25.48F943A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id D4E77140008
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 06:18:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WhQhl6ID;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789798699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MuYukX5INqydoTMDALYUszoXPjgDgYIO774EajtmC10=;
	b=jWw4QAuF9sDnvccMun3QzDRwLCNBvcIIIWCwcMEjZMZT5Y2RMxC1ywFhhYTdZxSTseUU9f
	D198uQmMxQ+osp2gvOFcIKsVlUXB0onlTu0W4+/p1CI+GOnmLwzDCxTTCzWgVbXBz5rqVL
	9Jh87T0HK7U51wp03rhJxBolu/Y7pu8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WhQhl6ID;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789798699;
	b=ZNwiO5L28A9TMylr78VohQ6dtEZLXBto2dBCmUOW/5K8Eb22GqWxgQo7ATGux73AUfeq1c
	VkS3b2lhTXQk8W8C6odnXBlmiz+CWJhmzZZSpst6+xLSQlnJm+FoLb9hX9YTD1lBZ6m1Bc
	AMTlcy0P0TdosKdZDdyx6ngSLWyqeto=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4C87C60534
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 06:18:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0A81F0089F
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 06:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789798698;
	bh=MuYukX5INqydoTMDALYUszoXPjgDgYIO774EajtmC10=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WhQhl6IDBrdZE5rCZ5I8JzPYQPTtXz0KhEMoVEFaHjSWw1j1eTuG3pFY4ceQydwXs
	 WHsAl2/Ke4skSl95+T7DCRU0VoQb5zbC31q1cuzLdV0VFccNyeXp9fa+d3owCUPRfB
	 KoFRg2Iy10GntefKp9jh+zzd9hVQURaB74Uk7C0it1QK7ATtUbe8OhWp+kbzJNpwTX
	 KKZCSvN0IGaCxEd9qDdJp6wN0NQZXgLCYk53b6Z5q3g0JwIx6bfQzSXs9kpgZPcBW6
	 qB6wuUlm3+jFpokvyR6ZS6E9XyA0MgFia9RgVNA/B/yOOYFboRiLWwBJpnU1VsWAjQ
	 y/tF+h5Hsq9Zw==
Received: by mail-qk2-f43.google.com with SMTP id af79cd13be357-93910cc46c4so126895985a.2
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 23:18:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxO+cP6x5TgpPVvnm8zUpPFxuYidRtmAn2DopWnHzUHbCK/kTDMkonQjb83221XchdkBKET1Qacwg==@kvack.org
X-Gm-Message-State: AFuF++neAWuVV8CC3jw19Y6UmIt3h/R0TIaQ0YLD3e/r8FQQcIsVifo3
	QlVPGhB2WRhYGKG3LkyP+4qW1iCwwpL8zC9u8q0eIGmmXWnGUhN35L/tsazjvay7kj9Da6vQR0g
	0qK5fSmDfxE8Jwt46VWYv2cAEesf8DGI=
X-Received: by 2002:a05:620a:3910:b0:93a:c102:1123 with SMTP id
 af79cd13be357-93bf554adc1mr27973185a.15.1789798698170; Fri, 18 Sep 2026
 23:18:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260918165642.1014988-1-ekffu200098@gmail.com>
In-Reply-To: <20260918165642.1014988-1-ekffu200098@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 19 Sep 2026 14:18:06 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zgZrFXih-+r4-p99rqXS2WLrGK8STkiOQnDANrTP5JXg@mail.gmail.com>
X-Gm-Features: AcwNN1V_qWtR56zqhRr4dQ7q2dZ6CDwICSFPFUz3g3qe-hpoDFs2u36SIAE_S8Y
Message-ID: <CAGsJ_4zgZrFXih-+r4-p99rqXS2WLrGK8STkiOQnDANrTP5JXg@mail.gmail.com>
Subject: Re: [PATCH] mm/swapops: remove unused is_hwpoison_entry()
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Baoquan He <baoquan.he@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D4E77140008
X-Stat-Signature: yk5u3rt8ayc3y6euanu8cad1mburjwq9
X-Rspam-User: 
X-HE-Tag: 1789798699-214832
X-HE-Meta: U2FsdGVkX1/hYrecWNiKQSwHPrUEjhlbfzxH2GFNQoSVFM9hDRXxkGbJD7DI3AoRjikD8bGyl3phwKHqqupG0EKfJxKDMyj67FBlUfXD1CIH/+8of2kPtAxQmI+27Q7iHtC9y4nVUf7v6/cTJ27cQ1LyI/dTqadcPWNtCD9UaQRVERH6gMiG0Fifx285aKS9mubX6/WIsmdCzyB2FkJa0M3elDpuOZJqSbRsLKHEtGf4+ABsOzNWMFsZnY9d/RF1EC385n+u0L8touiTEfL01bffdsRXVD7tbliaWPVG/FbaGMSdl/XLfYhPXwg9wOpJEcasqQRkAxzfhmCyTHZR3lCKZGiloJn28MdbPqTi4igYYp4u+iGVcP0nAeNSZDhqMMS3dfknQLhD5UP2+J/7spN7vC4Iub4mHzqij8I75WOHkLqSAnOTyusTcS+cAbgV5Xr7ztg72+FT8ZE4K0+45adMy9osuVZbXxukVwBhZ1qo0B3Uu4H6QT4ITqZRPDlbg4+ZexPGyZTF9NCTLwp1HZ/Zcv/DHSWRjpkC82QfNw4U0JenZjz0ORwQs4Ttl0dIsD/yULJmIES/D2ADXYls10PFv25xpC3oCfV+IA5/of9k0TiPAHLu4HlA9Rh11ufVa6rW4myApKUBBfGy/hWKuf0twDuyRtcd4dZ9K7Ar81d0xW4eE1q5Rdizo6eaLxkS1jwc6vIqrAPbjkqY9mb3D0NO/B/LYB3Ui+EukZKoZRcv2wjHGx4vN82mEwC6n2psqRt8P11hVLHDR41aVhMn9oXM36OFwPh4hHgetPc04k1NoXNj250Y08sOv+usAe07ON0Cr5Ln02eVSN84rVQxXbCEiGwliAPvwbVkjh51GOfz9NWr6KuWDhkLD9TBZ/tRPRNqsJL2PigubGKpxtvViM1lMPaDlg+T5lUooZTNXAtjcN1DaCpyO2dZNF9zSnCwt8bdSVauflOnNs8Te0/
 RBph5pgJ
 PGXvNWFrgfx/MF1OkbBP87LmEj7a38AjQjvOX6TXzmAIzukm8TFktOZSeUNKmQb+/BKW0wuXjlnA+iPx79J8qA1J8S0jjtvzw8KbqL2M+7Te+5B8eIYCroRYUEEN7Kn5hvbougt+0kHNyc4GoTWktFd0ZfWGtLycaHNMC3f/EQyF6sZQXRk76lWVsisas5qIvlE+wRHIN6fZJki4214IXSfkNhK9DfDNBk5+2M5XsbxRTe+bhwFLWrLM2dPkVmT4Nq6vcjuSqtBaxId4S88Xj+yf//mhBj/pmE9DMvadskhnMSVcGMiTkHng2EzchJfyI7p/yLQ3+nIrVrowTBTtS2tF9os04mnqNpa9VICybvybTW+cMdtbxoMZ5DA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 19, 2026 at 12:56=E2=80=AFAM Sang-Heon Jeon <ekffu200098@gmail.=
com> wrote:
>
> Since commit 93976a20345b ("mm: eliminate further swapops predicates"),
> is_hwpoison_entry() has no callers.
>
> So remove it.
>
> No functional change.
>
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---

LGTM,

Reviewed-by: Barry Song <baohua@kernel.org>

