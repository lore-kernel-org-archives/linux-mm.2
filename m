Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2564EC88E73
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 21:18:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B88E76B0088; Mon, 14 Sep 2026 17:18:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3B7E6B008C; Mon, 14 Sep 2026 17:18:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A50B26B0092; Mon, 14 Sep 2026 17:18:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8746F6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:18:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C3578A4AA0
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 21:18:11 +0000 (UTC)
X-FDA: 85213630782.05.B495FA1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id F1D2C40003
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 21:18:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZZ7Tj1gd;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789420690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7zG9u9TuXc8+YswrK4qwj5egTXD+ot8bDs8IYn66F54=;
	b=bjg4avBqrbZvPqUpHcEYEZsE1kzZ9QPeRYSNuV35RQfuSiGXQWgbknNWEmeInvVAfAgJzI
	11yFMDn722aWv5OVOWM5zlGkf4dtOQuDCgKJTshHN1tfMPulYvpXMiTXslBaGk/qqJtDcD
	vTOfomAPoA+tsKJQ6723zXyRzrt7YMA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789420690;
	b=8FVqkQXuc6Z5PYb1sZRMbBlWdQxjDIs1RHoOzBHAUh4WgSe3oceAEb12Op02znZ3/dxEHv
	+E4aG1VmYs5xZsUWlai9yYpopSvBYM3DbEO4ixZf8j9yyMNQpavIyqq6SIl7jZCw0Nin5P
	LEUMcHWQtOwQdq/87qwj7jlfvPWBJBQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZZ7Tj1gd;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D0BC660267
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 21:18:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848DE1F0089C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 21:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789420688;
	bh=7zG9u9TuXc8+YswrK4qwj5egTXD+ot8bDs8IYn66F54=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ZZ7Tj1gdm9SrxtbdCgk6ReL1sdwtzsWMEvNxd9JCUG8Ji0Xcb/d9zdJemIX2O1AQQ
	 AApQXGEXAoK0K2/iGycyA6NWVVBmbSXfGidRiu2aXny/LyxoW/ab5sc+eCxPFQPugl
	 p6+49opeEPqFbfeU+vC9Y200X42XE/AQz3orkztqZyKH+uURIehFRT/X9AC5v6+qXo
	 OOB5ixVvwxLCNLpSCu538j4bxX0rBY0XjwUNyfGqrWrAJ3IbZxoJmnZxV5gsuOY1lX
	 vujTwy4HdqWUEeFqEnezZCi+5izLM2Tu2FxmyY+2Vu4YaNOfjWJYVdrfHzpVHiVD/U
	 iOXghlqady6OA==
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93910cadeb7so329276985a.0
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:18:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzeZtCCTYE8TrPMZnLTvIDzmBjOJiq0lEk+WQfsMmMIc0YvaF3UPib4ydus3nhJCF/MXKI6LSX7pg==@kvack.org
X-Gm-Message-State: AFuF++kCfRLtd/CmVc2rX2uTfAFgseHLS2eRC4cpIwu5xevaxZsSIkLh
	K3i4FT+/cpP+WzWQ8JZAhR8UYAJOB9SP7O+2kVAevuVz1p+YP96+3pM8OQXvor3UHb0McHc2FkZ
	TDcWlLZx5ho76/oAKZG++FksxCTVdGVE=
X-Received: by 2002:a05:620a:4885:b0:939:5f4d:67b0 with SMTP id
 af79cd13be357-93a29766649mr728782085a.8.1789420687917; Mon, 14 Sep 2026
 14:18:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260914122950.3283997-1-usama.arif@linux.dev> <20260914122950.3283997-2-usama.arif@linux.dev>
In-Reply-To: <20260914122950.3283997-2-usama.arif@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Tue, 15 Sep 2026 05:17:56 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x54z4afiLwNwgs2u0RP1WEBbCgtFQpszqi5q_pkydeUg@mail.gmail.com>
X-Gm-Features: AcwNN1XhiKWzoaffDJcnpMgvSmrkdNy-g5DUkTJv57ChGKG-Ex_IRrRos-wQ8IU
Message-ID: <CAGsJ_4x54z4afiLwNwgs2u0RP1WEBbCgtFQpszqi5q_pkydeUg@mail.gmail.com>
Subject: Re: [RESEND v7 01/29] mm: rename pmd_to_softleaf_folio() to pmd_softleaf_to_folio()
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, chrisl@kernel.org, 
	kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org, 
	ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>, willy@infradead.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, 
	shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, dev.jain@arm.com, 
	baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, 
	Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev, linux-kernel@vger.kernel.org, 
	nphamcs@gmail.com, shikemeng@huaweicloud.com, yosry@kernel.org, 
	qi.zheng@linux.dev, luizcap@redhat.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F1D2C40003
X-Stat-Signature: nmfx6fathh3sxzqe5ayz1u13cpe9yy3c
X-Rspam-User: 
X-HE-Tag: 1789420689-335133
X-HE-Meta: U2FsdGVkX18cc8PreLopdlt+LMNpmy3eooU2kdp9QGp87/f7ueagGXg+yP2cqBe6TzT7bIIOANhc2GCbdBkZAJ/2SE4f0EZhGFdQAA8MpvYIJaIBTqUGBbRZ6zfPw+pRD5V6IBLfTCGInA94nm0rZgC3SIpXvI/8mvlXw+gXqDyb9jrcd0DVZHUzaT4gM9tKvN9odJpst5rEzXqT1U0Bz5MLUc9MO/7XVI4cLBUN/EmTTzOIU37imH59A0u7mBpoD+/LKDhRlWfpFdOs+exA9JjQ/ItL6JMo15mukGKdyo7qK52VOJn1CcbE46gaQL1CeEW0VzDxB6IIioIu1t0WIhEkHamPjDrD86IYiNANA0/R1PuKOzSgPbwCh83weaN6XLNpRblbnykKyLyKQwpj0+vNRAd/S/mj/cgnOuCrNNcXyIDA3tznq6i+P0eoRX8BFku5S0YLcLvlKIwKzXy1Ed4CKPueEhQ28HwhdU5efpxL/jQTjPwgAMVkj47toYPYC70hzuU2K7tyQibsHfMs7laTIHo7UMnoSz8wNX+rYCGzMRfUTiFRGGeioxhq9N7XwniDY9RiEMmE1iuVvkaex1dJUpHg3lkTkLercSZqNIQFu0IUJodw1nSx6+hgDyQoWZYofF/BJyvMVr58bROrSDp/BHELUji24vFoevTszYadXfpdIe5sI9Qb8RwfxfEIetcu/U9qBSeepO6HBER3/xt73V2YD7Mcy/k3KZjcudejnJqkzfShZn3AzT834Ap5/IMb0Cz7363Mip+HLHH3kFtwnuj8mt2W/0jxwAez/2CLtf8hc5Cm8f4ybN2A/UVl6lTDcvgd7WRk/J0kcWl5VFnjs9T99M0Dz6T97CAn+pLXAkNhoWIykqseY6m5z38vZm9BcYlD6HkqTObh6yjXySWkg6q3ZmwhuVjwrUu1PI2yr/9yqwbLhsZXXG4m9ozM4QMMegRtv1DqI0PGzBt
 b3rQBeAi
 S4MwJtL7Ts/UmOeCS0rtaS54JWqQ6XYR6Zd4dsiLg5deke9s24IgTkZJfA6BGveEMaifVjQaPEwhckMxBF/XYZ7zAncI0P6gxTAcSm7wubab5NHC3MzE78HJ3VtTI7QkNfjFWiTMbZ/Cbz1+xjVcB9AVTTWhMaPJeZZ7ZRzUMPtNHsci3cG/ptEs/Cd0QghFRFZs2ZFIS3RlC1NgC4aQBPaXLjk6io88mxM2E/XNbxblPDxsbB7agfMomGeS8H1cpZ0voyTr82X+iGAoUQSr7atXxXQOyzUJ2ZLzuOak7JJvNMV/22GBrrCatSzIs2CYPo4Bunv30+u8Ip0uuFsJ61ukz82LrNmfY8KRNaFIWG9n2J50Bwx6J5gg2lTiJ9JKAhm5mNvkafB+W5luK6AiF6lnXjzR35djfJLGJxeRNPRpI+HF9ulZXD6sPUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 8:30=E2=80=AFPM Usama Arif <usama.arif@linux.dev> w=
rote:
>
> pmd_to_softleaf_folio() reads as if it converted a PMD into a folio. What
> it does is decode the softleaf entry stored in the PMD and return the
> folio that entry references - the direction softleaf_to_folio() already
> spells out.
>
> No functional change intended.
>
> Suggested-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

LGMT,
Reviewed-by: Barry Song <baohua@kernel.org>

