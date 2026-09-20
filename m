Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF226C982D8
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 21:36:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D52746B00C7; Sun, 20 Sep 2026 17:36:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D03E86B00DD; Sun, 20 Sep 2026 17:36:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C19A96B00DF; Sun, 20 Sep 2026 17:36:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A00F66B00C7
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 17:36:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 25BBDA04DD
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 21:36:25 +0000 (UTC)
X-FDA: 85235449530.04.6700D7A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4586DA0004
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 21:36:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h71QUjGJ;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789940183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ysO1eS/gbFmXaGSAYXx6cmDf67S5mq3GFCVWQ+iEO0=;
	b=S50OJz6iJ7SlQV8zaF9FTrCLvkmuVKbstTL8ZBlKcyL/BrpssDHruoDBGKSZh4B4BQV7zn
	57TZB1rzhOhpOIrthjHD0sJKIwe6kWtiy7/YjXjspPl96Rm4AyZPFIjHNxEyzaV5n62wH0
	bmc62vZsreJNEz55rH5G4mtB6qusq2c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h71QUjGJ;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789940183;
	b=qetV95zIqjo5R3n/f0plm4yF1noguy2N4YJBAaptdNbUmrUOUHxDkT9DKJDkAdPcSva527
	hBDfgEqWiGYphQjvVt1ZHvQ+9RnGPgitQVirUbvKG1AwU+iyzJJU2as2osqKblOUpbGcAz
	JFn3D3Ia1MBUMuAJksVIsq70rHeiU9w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D5FE43D8F
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 21:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9251F008A4
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 21:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789940182;
	bh=1ysO1eS/gbFmXaGSAYXx6cmDf67S5mq3GFCVWQ+iEO0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=h71QUjGJIWCd3yVn9woISzLbm0JrVjoMvEw/0rpLkb0mWYrzICHVvkRajGg1EB8zx
	 siqf0aCbKtGaNLpCfLSL39srXVvI8mO+482+PAlOUx2bkOjnOIuWkY6SUxDyk1eQt0
	 oNmNnjHgBnsDrEBu7nRxlIvXu/y7FJNzn37Ag1pI87MqHYUibBWxsdNl6+llY3Jzze
	 exe22yi+4fvS9qTiRjh594C8C5Y28VO+ZaFOHsX9BN093HyRcWsRAqHStPBrQVPUQq
	 GnvYxzF1bwgWwNTBsF3FQMEAVffL3W5lPBTaZOrPPS69TyOvAG7z5Re2lKhMYZ66Qb
	 joOiYgIf4hglQ==
Received: by mail-qk2-f43.google.com with SMTP id af79cd13be357-93910ad20d4so285967485a.3
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 14:36:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxCMOYwQlCW2n07h/BFbqKdvenzlXzU6FH1PI3RzuqhVFMg1ZVC8jTtRH/XuB9ZolZqV2QKHZ8Daw==@kvack.org
X-Gm-Message-State: AFuF++laomXIMS/BKQEVtayktNK0T2Bm5gpvBYlXkyQrEtC89BaLBPg0
	mEURWjuLeYhckSJTsYhAhEb6ENNaV5Y7wOf166LNdjAR2/9eqGW/iJ2DDtDfsektHqGvcdZYuwO
	x32T7kIhIv85ZYgaMf3mnjhqADIVWe68=
X-Received: by 2002:a05:620a:d8e:b0:939:112:d526 with SMTP id
 af79cd13be357-93bf556607bmr808731585a.18.1789940181413; Sun, 20 Sep 2026
 14:36:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260720-batch-tlb-flush-v5-0-db943a0d0d6b@icloud.com>
 <20260720-batch-tlb-flush-v5-1-db943a0d0d6b@icloud.com> <CAGsJ_4x7W3Tgr_VNY+RLK_pXnFdehGGbjaVH29JsYipXGf7Z9g@mail.gmail.com>
 <20260920143816.39827-1-zippermonkey@icloud.com>
In-Reply-To: <20260920143816.39827-1-zippermonkey@icloud.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 21 Sep 2026 05:36:10 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yGGAcS90dRLfpUNWGdPhR-foAXM19b84nCtvkvcRstSA@mail.gmail.com>
X-Gm-Features: AcwNN1Vs88-26THz2KPr3veJEo5PNRtGISRfbbm2vSV-eb78W8hJfEeBnDC_28s
Message-ID: <CAGsJ_4yGGAcS90dRLfpUNWGdPhR-foAXM19b84nCtvkvcRstSA@mail.gmail.com>
Subject: Re: [PATCH v5 1/5] mm/vmscan: introduce folio_activate_locked() helper
To: Zhang Peng <zippermonkey@icloud.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Kairui Song <kasong@tencent.com>, 
	Zhang Peng <bruzzhang@tencent.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 9gw9upj8m5bmnnqzhkgz3rf4kow3xqui
X-Rspamd-Queue-Id: 4586DA0004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789940183-677525
X-HE-Meta: U2FsdGVkX19nHsCthaIRy+puJfO0Qd2ZdTkFvVw1Kwl/JbQEVf2WfPdBDSHinFidJoW7A42+F4A98V7VszGXgaWJH7nD05gP+RWdoyUGLkV9AiwjMHEbHzqOMwtDJY82NhGVvBZ0t4wPePP2qp0Ow64ZhcotMF1bJJEru4NuCGVdpyZrG/td1mvNi6friBh0Z60x7UTRVJIdjLxeJJgE19OryKDZ0T1Yp0BS4n5KX686UHXgHsNPYEwOcHie3p52H0w0/wX6MLBrB8pOWo+EAmLbiEdqmHR0gwpS32miotIg0FfGvfjv3MupjiQ2d/MCjP4ph0iWsxLKLtiZKAfAdJ0OvwJMeqQPyeu23aozzaVoEFgxjcipuCdGzuaWAHqd276SrUgl+oQagSPmeCHzVcwqlWFoIZQcfEXPlpFGC1cvNyfe4hKtRwLj/OotnLfMLF3/dHTOvVXkA8x9t3dwEjGKjO/kDYyUnuZ/iwjGCs0Ajg9fC0iuL4CsJ0LzyBVsvsE6C1eaQsduyJi65WC8oVTKMC+inMuBAkDR2I3VwBger/zdUALgsLkJZZ0jTEPcROURiwjVCU5KDD1GTBcdlYm1gc06dW2vtiiG4P81fpXRI7qniHjFl9Dl3tTLgwME9deqmhrcwtSRczphplSL8lxyzgIz6yLMXPLocOEu9J8OHCyefCgSG//kAWFdWkwaNDM287y1D6yFsjVSt2vnGGrQ3f3jrVsAPOEl6Ryv81lsi28FYL7k2UKkrCRaRbo48TMhoGsr/K+WDLsJHpsVbRl4O9eM/sgQA2NzqiJTdbc3WiljMY6q5JifF296+W3PfKVtecOJTDqMMpjDlx33yOiQQQruaq0Zub/g9ShPvfyQVOCh4E2VGFl7bEjDV6+h70Gh+3Oei0ZncY5vc0yJ0bvuTLacewdAvpEeJ+ASuKpskraUGmX7HrkUMGxKCXx8Ap1daSLkvtTKto9UiJ5
 8JvOKuIW
 VW85KkyIX8IqQUgyuCGxKNeKgQYKjPpTRouUZi7YNb4lJoQSCc/IyHQpXzXLzDuN7qoFIbWyjjrMytTdyXhAt3sJRLaBQK1XDzOXmm6Ih2TpKOUiG4Mj73RbhwIzDrpoP0t2uY/2qqPE+G/Rp3S4AyXc07iD1mWRoV+hWmxEsZZ8H+iBRpufG9w0KbL8u63W7frsWPa/8n0H0nCS0G6kjCf/qC1VujFFyey4odugGfiz5daSgOyQJJSAr2jxLVLlal+/jJxlEkeUATaLkVpyqklrJHVcRp3d52epN76KFjClUS/lk46MhMjo0xDVX/ZS3boDVqmWAYjz8Qesq6JCyGrvDR5wnkpNmuvUvEsyBkouDHUolkGvZsMPCvM4V9/bWq1y3jI371cLXjBshm3A41InKmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 20, 2026 at 10:38=E2=80=AFPM Zhang Peng <zippermonkey@icloud.co=
m> wrote:
[...]
>
> I've split the series accordingly. The four cleanup patches, with the
> explicit-outcome rework you asked for in 2/5 and 3/5, are posted on
> their own as:
>
>   [PATCH 0/4] mm/vmscan: refactor shrink_folio_list()
>   https://lore.kernel.org/all/20260920-vmscan-refactor-v1-0-ec04d71cb761@=
tencent.com/
>
> No functional change intended there. I'll repost the TLB batching on
> top once that has settled.

Hi Zhang Peng,

I am happy to review your `shrink_folio_list()` refactoring series, but
I really don't think it should be split up, as the refactoring is
closely tied to your final patch, "batch dirty TLBI".

Without the last patch, the refactoring doesn't really stand on its own.
So I'd prefer you to keep all five patches together as a single patchset.

Best Regards
Barry

