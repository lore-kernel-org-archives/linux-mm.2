Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17F8D105F7AF
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 14:39:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C8F26B0088; Fri, 13 Mar 2026 10:39:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 376236B0089; Fri, 13 Mar 2026 10:39:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 257E86B008A; Fri, 13 Mar 2026 10:39:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1272A6B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 10:39:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A507E1A01E4
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 14:39:34 +0000 (UTC)
X-FDA: 84541298268.17.CFAF455
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9BBD214000F
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 14:39:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=WJPVNx3K;
	spf=pass (imf09.hostedemail.com: domain of r@hev.cc designates 209.85.128.178 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773412772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sJJ6qRXJASQg0fWEF1LqLZ2QXuC8vC3iSXfNlIz0VPs=;
	b=oE/G2TOciVqrYDkPvbm/2SL5KztRGNthF8BIOMNX/PijfVG8IFR1iGeA0A5FwW94Hsnu4c
	NlA9691kQgcnR1/Tg+3AnoTr6lK2HYwKsUsOKLNUhtrbtMsqzMR5CQaX9ydlAYcc+Dll9K
	x6aIQhzs4ewwQCALUIpYPZH8wyRRxX4=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=WJPVNx3K;
	spf=pass (imf09.hostedemail.com: domain of r@hev.cc designates 209.85.128.178 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773412772; a=rsa-sha256;
	cv=pass;
	b=UqCRJLY1pFp9rRhd8zGnXGbCa2VBUMuKjvdKhX6/H3eyjj2IODkZibGbo3B8/6kgUw8JFI
	bMgNMrW2NMQ+Sl23MpGu3bdrJ59SQ/7PWSmrxAfD7XXfY1cTDpZs4DPwCkQDizG9Vuu43y
	AG7mGCbJyxcQK2jJhig1ECFAAWXGWoc=
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-7986e538decso19564997b3.1
        for <linux-mm@kvack.org>; Fri, 13 Mar 2026 07:39:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773412771; cv=none;
        d=google.com; s=arc-20240605;
        b=JJwI7pM0uDpBOzGfEVisk1PcxElZakFKMsYXtd7nk+LcIonZWZiqTXSE3yMK3EVFfY
         ZPlXzgkyRmVZ8A7sMa4aoS8rc3aVoyDSABwaJ9TyISParPJIHO4mmkb8yeIAN4iYYeo4
         HNh//+1I/uQhS/ll+mUrO9X4Ko2Ur0xXWcm/IOxJEH3kUah1OSr9F0uLskgHVcEeI9Aq
         5PuOEV4YxrEi0vkvdMQbE7ggDU2y8l+KRIPHDZDbjAS/xwp9luWpKowr8gFsY2BvS0BN
         qjblx6UbDxZj10Bvem8DxAkrXR0ZjZAvPd5iBKmWBNGtkV+Onm2FlDrV6N/T0UMvjIGh
         UJiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sJJ6qRXJASQg0fWEF1LqLZ2QXuC8vC3iSXfNlIz0VPs=;
        fh=3VsZzTYFknK4t3chFVCGUEgJ1NqlebFobIhcIVHTyrA=;
        b=UgTKWhWyjOhehRy/2Lz1P5/yT6Eg32x0SvLvW/ybodDwFP4zMq0ApADSVJuj9qbp8U
         8I9IkTHqPANNrbsjfcJUDRp9iCCWrD3snPji+ES+cxt3rldMFujSwcWqPXQt0EyzkbIc
         X2QkUpta3+2eDtNG2zcErPebbMgY4Ia6mpaRS4px18fVyQeD0oaDl/yFkE0f0D33oz4q
         LRt++5U6BNikk5zHtRLtfLwzVubv+YjW1HwrpHrVlPHTlayD+Y0ZJZkbu1PoIvHVbQuT
         adxrfFRK+vOskpu/UW11+YjxQdW2IhJ5xmKlqL9uEZajI8luxmQzfsKz5QiefvooYLX/
         7OPA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20230601.gappssmtp.com; s=20230601; t=1773412771; x=1774017571; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sJJ6qRXJASQg0fWEF1LqLZ2QXuC8vC3iSXfNlIz0VPs=;
        b=WJPVNx3KZ2SUVtRyHdQB+lcJHLk078UQEdgJuYvd87g48nCDXlNcsM1ri5tEUXf1f8
         mI3VOgihBrn1XEmITFv3wrF52aT+c3jRNgcnJ315GU6tbdBjRU+2QET2Y+Cf/zScT/lQ
         UK3C8xuSG8l5IlOFk++dw1bZIAp8OX2fiN2fwfCmBX1024j8jVs7zxQ97u+ehQB+oXJo
         ZYXkS67yP8hwkhRICk32vCkP0QN2zcF+YqzRxhIhErwWp6XaTWRrDVsfDzLYREpRp6wn
         yMUViH+GfPK++xr2LV1vR9/r6/c7LeyO+9hnVv46lbLSS9VsE1oL7QrzL2s/1LHvZzjs
         njwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773412771; x=1774017571;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sJJ6qRXJASQg0fWEF1LqLZ2QXuC8vC3iSXfNlIz0VPs=;
        b=WfkHYy08QQQKjAPNVjWrqg7xucu8H8RmXR2ocq3ocKSgO483h1KPIDEdrJIOPC4L85
         pduuZZ8Wozu/gSyE1oTbj+pATy15Ex1R+/JlYDmfda+JkFNfTOnEgW5pVuZAYPGtAt/X
         MLCeCcFjLNrIyFlfcoCMXtrvj3mTu5DC7sHebxvu6JcN4T5w0lcpgSGotWLGR3IYNXdM
         SW6+kNK7sDTBBCgFqu2Ojvc6L/Iyykn4uceEG3M4qXtxYuwnIRDlyF1GdqFg1DFtelpF
         FC29KllcyU/sYKIj8hqxyLj9QVHUJLVC1AvE4/QGVEpCu4snYN8kCOzoKzxZ/xjfA1lQ
         dmMQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4/F4DL/RHCZ2eYO44w3UA8mlHXA5m82SVj/ssJvz0AxBZX3vM/5c7SVKPJjk2w1Wkz302TFkoXg==@kvack.org
X-Gm-Message-State: AOJu0YxPlf3KUzjbuKkC7XRAakFME3VV7smEF12EuwPL4clDOEheynnY
	b8tKwc+ubkYdA+YTRpNkgYgWEJ0CqnxN3al64iUfTOjl9NIpOhEqPL4qUetuxedgEV7tj+aY4m1
	rj7+KhSwwTX4mn/R1YaLtRzoBvhJ7VyWWcxAjVb9Mtg==
X-Gm-Gg: ATEYQzxu3sysuW+rHzhsKkTBeWF2D+A1TqHbRXyKfL36OQI3cODfxWFCZ+E+i6z+pYC
	x8qjBpaPcCtKh3i4YJtXLxWZDHZ8oNf0G9JLm40yFTcoqRcUekGwdsPp1T0iZ8fvoGg00K38HZ5
	iFT4ckT7ExphZmR39Y9AUnHEXwX5bZ8/3dktWdYE/SxwxMQgjDWMarZGvnpH3wbHiZz8jhJpPl5
	y/pKFYXI3LqEMnK461UkxSXf57Wu2EvpeAuJjuEoa/XY4mYwf7rI910Srcy49/JMnZgPmdJzdKr
	EUrQezRa5QFgWtZ+eASCm2bxSujwKql30sHupH9I0Q==
X-Received: by 2002:a05:690c:306:b0:78f:9801:7606 with SMTP id
 00721157ae682-79a1c186f23mr38827757b3.34.1773412771512; Fri, 13 Mar 2026
 07:39:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260310031138.509730-1-r@hev.cc> <349671d5-f5aa-48a2-9bba-00aef167b836@linux.alibaba.com>
In-Reply-To: <349671d5-f5aa-48a2-9bba-00aef167b836@linux.alibaba.com>
From: hev <r@hev.cc>
Date: Fri, 13 Mar 2026 22:39:19 +0800
X-Gm-Features: AaiRm52VWGkrpgV6kr1pOmEvbPempDQO61pMP0KiWiSuLBaXj1WE2q1TEU_x85I
Message-ID: <CAHirt9g_PfEM+PzVrpsZwch44_6oeGQ4_abvYMAtjM3eNg5CHQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] binfmt_elf: Align eligible read-only PT_LOAD
 segments to PMD_SIZE for THP
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Dev Jain <dev.jain@arm.com>, Jan Kara <jack@suse.cz>, 
	Kees Cook <kees@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Matthew Wilcox <willy@infradead.org>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Zi Yan <ziy@nvidia.com>, usama.arif@linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 9BBD214000F
X-Rspamd-Server: rspam08
X-Stat-Signature: ytb5chf6kdqhwtyiuz998jx8t81hbfbw
X-HE-Tag: 1773412772-259726
X-HE-Meta: U2FsdGVkX1/D7T42EYE194UUt+uuGxEVU/hE+XWtz5yEu+q8YpwpDHzgVZ6NWmUrs68EmkYJq8X/xjSt9mJ3+6WVt4M4bn1H49N/Xt9FFmsM0VXZKuRmcqoSPboGGmUqJveO5GWb/FC903bHLNi+cheUAgaS70n9EHpzNoPQ9OsL+qdMu4pcUVleI4X4z4kyJ1M7OqiDHuJYNwynls/HMpKBQ63w05QN/Y/km2JSFP+r4PRmP8VgHaN6BfFSDmu6xTxLx65P+Sv7fnmmHaXMWgItuqI17YnfYN0qPdqshXWr2XxdBMDfWcTJijXKKvRUgsngL4Uke/Oc8C/zlY8wCOPxEHyWcraGMPYcWIHegWSUVJex+zaxo/nzhf6rCYS2Y2fEDNem0W9oj5t0Zws6OWgoZpkb+MSFH5PkHHpW2zmFCdfFC8Tu15YoC8I4zjFRvStMQ6W8EyNmbQax0UMeqAKYP16mHqnqRCggT20W0uMnNHftCKkUwppzjDDb+NGfNpK/4UyBkDQhWsN594s7fqnpDB2FAnB66UAx03wHY+ztgcxBp3phJQ0ggZ+XvAnUiVwlT1Za/kAdY62GXJq0pQy7pac327rAEUUxNShCpbFrwcmZknX952iZlsXEJBTUzCcjQLrY0YTDe+OnMEtVoEtd19kpcMyiAQv3NXUvx/zN/83oCDJBSFK456DHL1ph7DKZcWUwQaYoBZHVpNee8x67pzCW0fJElm+cTH0nIpfB6NnIYyGOCwY4EejMnCcTG9J8Z8C3+Q2w99vrzIfdqatmkj0H9oIagLkkkr02I3COG0qbkQcG1hPk2K2+zafuH3pi/mr1NeYn/zQa7PyCCljF/Lc99+3Gn5ij7ETixcHkXFqV3lZ0UqPJqkaRR/r9aV3vPanLL4bEOVyOeEmmsccFIcgR/qzwtdfvedccKZzb7QdD7NZ9D8C37340FMn/2KyuH0DAcs8eARxcgK2
 ayqfqKoK
 eBoO2bvr5A/JWTbpSgwaExXnnbcRbxBRrIzdDRK0HmSswf5cyOxI1uLU3dBI6mz+iLS4QWno0GcvC0f4nnkgjPTwq+2f8s6Y4DN4l8FBKa6Lt7IEVAJSqYHunDK2XAliKmjzJSQlewTxL8DiSOvYLMZ9MNf0IckyzkkNgE2D3Fgr9LkHysw/qBPoXRpIbXzDdE+OHZaxYVdl3/VTkaOumKlftDB8QP8SDtuLajD32LEkfi6yz/J3GXDI0pU5Hi+ZiSpm0NiBEq8VjnKp/32H538OQa5RpVc02MIni65N+x/TNrFFm02PiXTyR9DpH8zQMibLEG84L8at19YSbI+vbV9t2OQtDmRvCKMUyViX/81Lw6vdIO9+xfG0BeQasWSuwj0oOHBKWIVylQzo/9i6IK3a1Mfj/dDY46klyIREcXsWqrFVHG6sLc2d4OA9WsZND5eO+L4GwiG+LAkhg/iT00AvFyunIzCF038ieYZ2Y1XktYlI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 4:41=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> CC Usama
>
> Usama posted a similar patchset[1], and I think using exec_folio_order()
> for exec-segment alignment is reasonable. In your case, you can override
> exec_folio_order() to return a PMD=E2=80=91sized order.
>
> [1]
> https://lore.kernel.org/all/20260310145406.3073394-1-usama.arif@linux.dev=
/

Thanks for the pointer!

Cheers,
Rui

