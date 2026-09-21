Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D4A2C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 07:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 671DC6B00B7; Mon, 21 Sep 2026 03:00:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 622EC6B00D9; Mon, 21 Sep 2026 03:00:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 511736B00DB; Mon, 21 Sep 2026 03:00:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2DB5E6B00B7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:00:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ACDE51605DB
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:00:23 +0000 (UTC)
X-FDA: 85236870726.01.5C8C0A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id CBBEE20003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:00:21 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LLVW2EBf;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789974021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gHlvbb647JYtKJVobp9L+WY+i2D3HiyuRdvv6kDImw0=;
	b=CEjavznB4y2NCyratcU/LTsHRaAghDLl3mfVaFaKkhK2ycHGXz2uqFRq9IwxG89DFLKL/4
	QwnGsxHDbKs0SkrluWTbWOv56SgDK2Xtlpz7Bkb26JoQe0V0GRfeefRr98GtgqgdvvUl+Z
	wIXJVbumbBMqU/lFyg/3sIYJm5nWrpY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LLVW2EBf;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789974021;
	b=5zak2ZJASWz0zRwEUliFhGsa2j2xer6cW+LNjY1mnlUa+oDMZydNX++Lfa+nshwO28h5F3
	iYkwrY0Lxhh3PzCv34EE1/NFw57LiZ89GHDhfd0DDXYUJX5YxeUdQhknMn0M5UrX4KW624
	v5piIRjOGvSE1p6SNwT3rAdJYKO6vCU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CE9F8448DF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10BF1F0089F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789974020;
	bh=gHlvbb647JYtKJVobp9L+WY+i2D3HiyuRdvv6kDImw0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=LLVW2EBfsLFXZgiNXk7HC98NkM+VwO00JhtmGfImdK507iki8Y6OysdNppSsmDdnY
	 7sxUkdlR4mrEc0q484yRBO0IttUM6bX6F1qiMgY7iaGfQN0apb4xg1UNLLIt/hFH+9
	 hnKBvFvwoNzq75cKGSWMNY3rTlpyzvduCY8wTr1X/qgwL+i3HD6iwYn+ip+KutTRCC
	 M5E86/zKfV4xim5w6IflhmON1qM9TsaCZbgHcSWuZfPJ9ngR/VYFPzWjbryP9h8N5J
	 Bja5WfzrsgT4c7/RMuEP99MyQKxjBqhM+fOUYWTctURV9bMYwa0z9hM2CI0gtR4h+5
	 bVuMbTohk18Og==
Received: by mail-vs2-f42.google.com with SMTP id 71dfb90a1353d-5c67e4d8d8aso1799996e0c.1
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 00:00:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwxK8TM8ybgRyskYS8NGhy9KgpOby27+szHP6pwkOqCGsYTlSsxijjUTvq636enaH5K0uWpGCCjbw==@kvack.org
X-Gm-Message-State: AFuF++ntlQYWoow2yQLPMDyk5dHqydGPC15KnuQVJx++Ecomw0GqqRkT
	HrjA7ibbHxhwwrUK1+t+rbSyEiYRfBTlzmpvTQX38coSQFw1VkUiV4dy5lJde0v6epOOz/46wUe
	dNWPZ82qJWuiT0zU2e/xC/XNrs1iVycY=
X-Received: by 2002:a05:6122:4896:b0:5c9:a60c:273d with SMTP id
 71dfb90a1353d-5c9b59eaf2bmr4648530e0c.21.1789974019896; Mon, 21 Sep 2026
 00:00:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260920132519.3369946-1-ridong.chen@linux.dev>
 <CAGsJ_4zCADpQDqVj=BFipOztctBMBhw9Wcj+FLVcj-d8e=0bow@mail.gmail.com> <2e878fe2-473e-4dc1-a669-7e2e37894d6e@linux.dev>
In-Reply-To: <2e878fe2-473e-4dc1-a669-7e2e37894d6e@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Mon, 21 Sep 2026 15:00:07 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yrR1Wn7NjOFVcWdD+_WEEu7AY6LdsKTZDxx0VR3EzQ+g@mail.gmail.com>
X-Gm-Features: AcwNN1XrdEZ1E-aaP9IeNffRJ6dC3Vjq8bbURZBcSwpV0urbD42mxWoj6_IQ61Y
Message-ID: <CAGsJ_4yrR1Wn7NjOFVcWdD+_WEEu7AY6LdsKTZDxx0VR3EzQ+g@mail.gmail.com>
Subject: Re: [PATCH mm-new v2] mm: vmscan: put rotation-missed folios at the
 LRU tail
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: i6euin7us6fz3msio37jkcjdnisay3hi
X-Rspamd-Queue-Id: CBBEE20003
X-Rspamd-Server: rspam07
X-HE-Tag: 1789974021-646034
X-HE-Meta: U2FsdGVkX1944q7JYTqj7WM6hLHQ6Rv6MO7lSQWS+GJMAWunZmEUgj8aJQ21LN0yUL9Vx5uw4g65m71S13uMkq1QUa8qSs24zHaHDO1Vqd5WkS7mFTyizXCeuaOBi20TuupysA0fmbI8QEQU5d3zmllBHxHdAmtGvEYWbtb12KLEnwCOGqWRRh30EOJdafnXCsRvaHt/bSKJP/yFLX7tX5ocdCOmdMadNgxtvHJBsOVaamc64PhZYy9jVSDyQfz1WC2MEpu9SGKEGDLvj1W0UgSMDu88WO4typ2bBab9p4fI+BdWO1nJInrQyxcfBymfHMK8JrakBfEwZ5qNcIULRtvK6RyEtgKuTt4KsV3QrEzSezyGze29syI4llxtuwJ2MhXA1lNCJdrrpBBfUEPYPuD4HhDjVwynpmvjdFHBmi6uuGRrxk3M3lElNOMLM9LjDPe9pvPAIH2ip8i/K1wJN5aKSNVKbgHapReRJKWyDpaEOqCDqkNkJ/JQ2GASRmg0TnhE5rCimkhkDCejobJMG6F6665rqG7Tejz7Q0zWnv80mJROnw10DKkBrCj6HHa1d5+ffmySITo23JTUM6IVjHSryPrNfl3SxN/7lx0Y/3zm/QSDFuuXYO02ISKKyHpx5HTpHg/Kwgu9CBdBNxjYLJuh98QZoiZzVBj/I3hKvrMFIn4C0a6ELl59iaIJJKoEbdmRTcA7b2oP0ybLLryoyh2a8JWC6x/aIMnHzFCZTEUX1BqG2yFsJ3GXyAkW8ablVewSIto2H7wNCaETylE35zVT0JH7qD+ftqxQN3AkoBFBtKK+UibZ28x4rhL5W39ezMT1gWcgjSxFRVnG1SsQNy47BpjjK5mrM8koVFVUcBMiCDZA69fR3K0vM78lHHH98C7f2Lk7HcRR0p5NJZwaAdn4Q0L5vDlvImAQTo6Am13RC7Wqw7FlnKoKsop83wjUSrw0YmpppE3AKzJxVfF
 DpPPFT+u
 127+zUObMSbwD/on4aPThN2flzpwOngRBJEPtGNfhlk3QcfSSizgx0Tq/EMmIy+yhsnEDVXbT33fz7XI/h0A3a6g3Nia8kZ1WGO9RVwKGFrUldnAIjBT742OXguiAevkt6cyeAEJqu2yeQemXAisnVxWB1aVX70efRdmBmQgaXlJAVjWUBuoLIA6q266JOe5uK28WSu6+PQJ8m7MJvBYRrnsByT5UNQDROBhdwCYoR/wjKHaratyiG1NyNBnav9LZhgkvUP0rP+fv40sLrVNxP8W6sBdnmBU009fX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 2:05=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
[...]
> 3. In move_folios_to_lru, we drop the extra reference and move the folio =
back to
> the lruvec.
>
> ```
> ...
>                 if (unlikely(folio_put_testzero(folio))) {
>                         __folio_clear_lru_flags(folio);
> ...
>                 }
>
[...]

> Therefore, I believe it should be 'folio_ref_count(folio) =3D=3D
> folio_expected_ref_count(folio)', not 'folio_ref_count(folio) =3D=3D
> folio_expected_ref_count(folio) + 1'.
>

Yes, you're right. I missed the `folio_put_testzero()` above.
Sorry for the noise.

Best Regards
Barry

