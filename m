Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27F43C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 22:37:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F4A06B0088; Wed, 29 Jul 2026 18:37:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CA146B008A; Wed, 29 Jul 2026 18:37:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 906F36B008C; Wed, 29 Jul 2026 18:37:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 663206B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 18:37:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C3F08807E5
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 22:36:59 +0000 (UTC)
X-FDA: 85043275758.01.FD58FA8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id E82C9160003
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 22:36:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n309x0qX;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785364618;
	b=jJrzHsyVgSRzNwstAz1b6Z+Kyh+GgMn13FQk0Vj8vlE+bSyUAos2Og+lVDOBihEwoW+OOS
	jSPv8Tx8jDdxmUy21aC2niqsZL+gUX3dq+E2YmFzLfBW8nHm2vV/vMfHHaqEO0BJ2Npex5
	vJ2iuUh5dEBBvViA2LknL/oncgtqvOs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n309x0qX;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785364618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NQOzhzyTBRr6vM28sNhapOXnSw13bcaivRKi2ECdEW0=;
	b=4yzXk+zzmlK8yihTBpVFyn3aL+C9ARcO5zRF4SM0vLxzRX5sF5w/96xBvWkdck6SQWKF1A
	pAGV6pToiBg005ykfSNthYX9b6a5yCRZUgJGsu+u0GrvzQ2lhasM1EAjl8dJ2xZCwA2jUG
	cP8aABe8qCo7907q5pBLuuO4PBYgVOA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 82308600AB
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 22:36:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC1C1F00A3D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 22:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785364617;
	bh=NQOzhzyTBRr6vM28sNhapOXnSw13bcaivRKi2ECdEW0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=n309x0qXXvGmXtPqgyPomgSQzrQbC6F3qDyAhLBOc6rKPshzVRDgAW3Rg14qr0aa8
	 6OPK9eXqxb2YooJexTtGOHT0CceckwsbquVyrp+GMYUx3LannyrlkLc6CwSm1V6xK6
	 4GbyW2+C/PwPKZ1op8OJyW+35h9ek3/zZXg2BLAKW8xq7ywwV90Vf/IcHT/bxeOB/8
	 CYDrxODpNp5zZBTnG5tBLnfPr0tLiZSMmYO320/0qrRbtzllVlGHH9K4IyG85Zfgr8
	 g2lcM3lX8mupcZFcbj0CPjK4ehDWX7mHV85w4xah5kEzwoCqgxzzq+QBQji9LP7STZ
	 s2EKmW8gOqU3g==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-92e65e18969so15312985a.1
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 15:36:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rrox3B6ek3bNbKoIJ2EF2ugga4WV1cri6u656+oSSUB/ytBz0auBJ4ZKl3gm/IUJFpFowuOYY3GZQ==@kvack.org
X-Gm-Message-State: AOJu0YwTRkxyiGj4gEtXa/fVZV1XgowW2Jz8vERvcCgGJq2Pwz9UE1Z+
	sw6LB/vG9zYZd+TncBlZ0RUol4znINaUolBSFfEr3ZnD3XSeS+rJdKwjPf35npGrqtqo/2HdnpD
	QBI+qdroY3YxYo9VpiebdpDNpjI501h8=
X-Received: by 2002:a05:620a:25ce:b0:91e:df9f:7804 with SMTP id
 af79cd13be357-93485d1207dmr22814685a.38.1785364616535; Wed, 29 Jul 2026
 15:36:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAGsJ_4w17+jKWJKkq9fdEyu6CtBtMpH-Sb4XPwdDUfqSkpkQyw@mail.gmail.com>
 <20260728122719.3688430-1-wangzicheng@honor.com>
In-Reply-To: <20260728122719.3688430-1-wangzicheng@honor.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 30 Jul 2026 06:36:44 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zEWQZnq+vBSVjKn+OB_VpYt9ghj3JKcZB_x=oL=zsQtw@mail.gmail.com>
X-Gm-Features: AUfX_mycAnF9uFus4_0bY6nSuEvlrbKRcvzBN7kfktF95aFVM2UxBa_IPz2UuB0
Message-ID: <CAGsJ_4zEWQZnq+vBSVjKn+OB_VpYt9ghj3JKcZB_x=oL=zsQtw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 4/5] mm: mglru: run aging when pages are severely
 imbalanced across gens
To: Zicheng Wang <wangzicheng@honor.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	david@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, ljs@kernel.org, kasong@tencent.com, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	linux-kernel@vger.kernel.org, lyugaofei@xiaomi.com, stevensd@chromium.org, 
	linkunli@honor.com, tao.wangtao@honor.com, zhangji1@honor.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rqm9yhdp8i34cg5hamz8qdisnj9rcne8
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E82C9160003
X-Rspam-User: 
X-HE-Tag: 1785364617-829834
X-HE-Meta: U2FsdGVkX18hQl/ZioaW18qoL2vuZlpE/F/J+7+Ftcv7OcM/66unNsQ6eDDFnkT+9Ycxc0DWBNKBEIYKeOazNz2hQ/ZfrsBCYr15CizeFl3qz0ROGr7UrSoznc5rXmHuu3Oqwc8AcO+2Hsiaqqebj2cmbVXC2ESNftZ7lJJFROVZ7UlekoxvlCoWQBQ24NDDrEnnnMMGD0WIKKOQLAwHQQX4E/CfPwfwSg/gAP3DV1yuIMQnFM3D+c3Oqj+JplLIpTUV3VMa2QbEB22lAzxYZnZKSovrkVBuQrIO4t1/gGX7Rvoiw1s+De94Xrq69waE3q5+dmdvCzM/SGpdhRr6QvB9bKbEZu0swnl8AOk0HVGVcb+UxtSCidd/Zja4i4gq/Z9hxD+myOt/AjVYzyU783ECYPeVsK4rjf1ATQnCPnqIRd864cM6n9eXnK9PgQLV6FiLlRDyXse/tC+rA0YrIIObUPRBkjZStOvFM2cO/jW14quw2dIvaKAV6vzUkvI2LQaXWi6R5oVxBs1fp72U5EoKcsUkxm4D/ptUBVfE3z8mj7A8et2gh8jNVrB5bnFnGqv5j1t5GsLaVVb0Bx/ylw+4I1vsduKZ9ZxPig2eU+dPABQAJyODBhE7XX91xuhtwgKZNj064URZeoxWIsjvNOCsini65Qi5Kz3GHS91Wdd6q2hDeW2F8WCvMGV5giC6mUmTjlAUaIJPyPMFWPI1Lt2eaH8b7jzUanybbGUHeLvbCRDkZDoohE2JS68WQ+N3Fgo5ZxzNGtMkWJ4E4Mx882UUR/Qcmh3+uPykvHI1R5dhTlN6QVmoWl5VgXp/4Z1QxHsMpsqKOleZjOQ6jRB7sbsWYeFvbZ/kYEmF5nP/kLTGooCT7GT7G434OSJTptzQiOk4eHg4jKAMTfKIlFX+JmIfMiNFm5qAPAErX/T3kYhGjmKR05Zs4c14uNDtrJy4t+CH6wSQAC6uv3P3D3b
 u/uAPkAy
 2D+jpcLouhjN3FnDXEDSB+WSAvJ2h+AWEWQBhWR5GMcz3+CrB7W2C3/BePuOnO2FxVldiw3TDDBd7hsskZvDdMfUACy8h00Q2W0x0T9ajQ7pWia2zMBBdtB72UJvEWRJvPDTVvC7WddaMmG9//NdWjOcj+A4Vyv8EVmmZoDpycEyCGQqs8vHxPVKbnyS1cpsTUy4z5Qz+iaQWHd3ETpumc8ljTmsz2d118gbpVDcQJvpK8rdwDYz0MVjztryHgHnvrTp6hkRuuQOBUWLlrokhDXhxfI02ILL0sh6p9UtfPGm5/jwPzrriUN8myC3/8FDmxcY7VUpV4yf6KtDUrGoE3+5m4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 8:27=E2=80=AFPM Zicheng Wang <wangzicheng@honor.com=
> wrote:
>
> Hi Barry,
>
> > The original code is a bit odd, as it compares a single young
> > generation and a single old generation against the total, rather than
> > comparing all young generations with all old generations.
> >
> > By comparing all young generations against all old generations, we no
> > longer depend on the exact value of MIN_NR_GENS. The idea is to
> > emulate inactive_is_low().
>
> Makes sense, the inactive_is_low() framing fits.
>
> One gap: inactive_is_low()'s ratio is dynamic calculated.
> int_sqrt(10*1024) =3D 101 (ages only when inactive drops below ~1%),
> while patch 4/5's fixed 4 ages once old falls under 20% of young.
> It seems there will be considerable cost on big memcgs, or should
> the ratio scale with size?
>
> Looking forward to the perf data.

I don't have access to a machine with 1 TB of memory=E2=80=94or even
more than 20 GB=E2=80=94to test this. But I think your comment makes
sense. We shouldn't let a machine with a huge amount of memory
in a single lruvec age too aggressively.
So maybe something like this:

diff --git a/mm/vmscan.c b/mm/vmscan.c
index ed35c502923d..a6768b9ec8d6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4968,6 +4968,7 @@ static bool lru_gen_imbalanced(struct lruvec
*lruvec, int type,
 {
        struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
        unsigned long young =3D 0, old =3D 0, seq;
+       unsigned long old_ratio, gb;

        /*
         * reclaim is forced to a single type in those cases, so there is
@@ -4989,7 +4990,16 @@ static bool lru_gen_imbalanced(struct lruvec
*lruvec, int type,
                else
                        old +=3D size;
        }
-       return young > old * 4;
+
+       /*
+        * Copied from the active/inactive LRU heuristic, but uses a higher
+        * old_ratio so fewer folios remain in the old generations, avoidin=
g
+        * overly aggressive aging.
+        */
+       gb =3D (young + old) >> (30 - PAGE_SHIFT);
+       old_ratio =3D gb ? int_sqrt(10 * gb) : 1;
+       old <<=3D 2;
+       return young > old * old_ratio;
 }

Best Regards
Barry

