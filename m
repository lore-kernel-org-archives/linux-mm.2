Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 217B6CE7B1E
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:19:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81F138E0035; Fri, 14 Nov 2025 10:19:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F6DC8E0002; Fri, 14 Nov 2025 10:19:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70C5B8E0035; Fri, 14 Nov 2025 10:19:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5B5FA8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:19:15 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 26B1A88CC2
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:19:15 +0000 (UTC)
X-FDA: 84109571070.20.1C5DA17
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id 37D0B80010
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:19:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KatCNx+n;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763133553; a=rsa-sha256;
	cv=none;
	b=kESvUnwiyKDI5UY9RxSPnVMw2N0OjlzbzVa5439Rel7oVHM/akydQzLcVTsG2WDy1QqxC7
	+7cUN/SSvr2QyXS7ZP1pE+WmLTW5br09NMwwBZnN0Sb82jgiuizKXZ1LhyI/C/2rOEkJch
	YRGj84ab3ofNXUxqBIONyamV4BFzZZw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KatCNx+n;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763133553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vTq8gM0Sr0ljKbDKqif3iDj3cyPF1WfC60KmGWiymxw=;
	b=IhEMCTEUEBTpBtbvVDbnlZ15lB/fw6HFy3k4cW6kLFoHQ27YY+rXGHYL6jK1SNDtfTagYM
	la46fEtUi0tkSYi7EbxjowWDL7U1NAY7zoiITUr7NKID8yDSfJ0MzuT3RFLKWfnCo9GP70
	6cUcSkDhU+GXyoLEI7KwvXLyWNDXjpk=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64074f01a6eso3700935a12.2
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 07:19:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763133551; x=1763738351; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vTq8gM0Sr0ljKbDKqif3iDj3cyPF1WfC60KmGWiymxw=;
        b=KatCNx+nTdNpVahDipG8E4xRQw9v/9h1WyJdbOTEZYCze4yDz9s16HmdSwvp9HdClf
         JT68wRH5h4VRBajRVkBBFU3k2LhpFNxq4EjnPNKqCNW9MmzCfsPECBa7m+BactUzRBPS
         CefIfZCn2GEhEBeBuKCmZA61yPAxUKIXemGyhmi3Oo4EcUyAQjrk4eyl7YaYj9y7LVUk
         3EW+9Kc0H6J49CR+gDvOBUpB2MC6OyI0LzJfsXlC+IWjIm22lqRY4kYPjWgcSYE8r8mM
         4tjkHSymyOjXza5xtn6mbNS1vG70Pp3H4dkOnBWdBoOt+N2+ozE51b7Bh74kJYJ076fp
         FyyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763133551; x=1763738351;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vTq8gM0Sr0ljKbDKqif3iDj3cyPF1WfC60KmGWiymxw=;
        b=h2xl230CBACE3uARlXsBB9h6dRTjM05YtmEwKQ9GOsuxu06TpLl+wwvMYcb8Gsgjkh
         78XzX82IIIRjYF8Nj5wbYwtK9yE5q8JzodldUb65IrQfW7k1WxsP46tuMIbUEAwmmNm7
         tlsjpZVfvHSfboZKA5OR6Jl7jHRF8XPFrGsPxLJsd0vLN95T0KbBs8CUic4usqp2+1LJ
         KpX31ca33ainxV7E9J2MgtM/FF2KFpLTAlKXf7XavDxsavK5Kz2pzi/Yrw85ddNRTQpg
         k0fFMlj5M/WR1ITdGbtmnoZGKHPskF0of9fWqJyCDTJVTMgWng6i2MhfKBY0t6m0dsZv
         KNtg==
X-Gm-Message-State: AOJu0Yy0e7gUBpto4VwZWRCKuDqG/hlHzaRGYphPZSNqGb/7LvGhkw86
	DQczGh9CszaF/isi4/PAxhAAmrsPbYKAKZMIhox6oesBoPZyMhvANJiE4g6htV0ewq8nErZ1jj9
	xTd17UpShktMSicc6bkKaBLlkiTf5L+k=
X-Gm-Gg: ASbGncsK+Mgeul6R2p1E8fhWlzufgPf3YOhVfd61WMkALbWI7+h/McAAD7X10rrmfOQ
	OM7bY1CHf4EtxHwCvOofFkq9Kkh1OoIE5EIFo3V0CRG+JLk17nU7sNQPlplL55Q35H2fofUqmCl
	WJrTtml5LmcSfTgyFxKap/hTd/0J8+QeCB4eLGxO0cqhaMd5dLyycgHTTz6wqJpmCOPy70pFDC8
	b+T/zqNcUV61+8oeYMnb0qD7+W1a2MSLME8cALOlbNed5eB6mtoO66XXZfnRmtYUUA1/FE2CIeK
	TpG22FEDhawQoObpUktMupw7OJzykQUD
X-Google-Smtp-Source: AGHT+IEudofkKMhkHwKl9gbfdjMpL/6C9s9MIhrHTEp1YeDgjqNJ326ZP82OVuO/bFPMwLmRrZ/AhDXolotLIo/n/50=
X-Received: by 2002:a17:906:6a0d:b0:b53:e871:f0ea with SMTP id
 a640c23a62f3a-b7367bd9261mr358803266b.56.1763133550733; Fri, 14 Nov 2025
 07:19:10 -0800 (PST)
MIME-Version: 1.0
References: <20251110-revert-78524b05f1a3-v1-1-88313f2b9b20@tencent.com>
In-Reply-To: <20251110-revert-78524b05f1a3-v1-1-88313f2b9b20@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 14 Nov 2025 23:18:34 +0800
X-Gm-Features: AWmQ_bm69zgMxXusRC5P6W5ccXe1vWsyUwTC33BkNeOlyt-WgJRGbcWoOq46v78
Message-ID: <CAMgjq7Ak2QJ_A-LKOEQkHs_o9VAmjXodAvnmSbNmTGphWZr+WA@mail.gmail.com>
Subject: Re: [PATCH] Revert "mm, swap: avoid redundant swap device pinning"
To: Andrew Morton <akpm@linux-foundation.org>, kasong@tencent.com
Cc: linux-mm@kvack.org, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Youngjun Park <youngjun.park@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 37D0B80010
X-Stat-Signature: idm99jwo9zyh9othecd1r53edfibif84
X-Rspam-User: 
X-HE-Tag: 1763133553-240485
X-HE-Meta: U2FsdGVkX1/+Ag6Tdr6pSMD21Hgk7+7IAk+ko6gu5N2Cigi8HC6WeialRB6JO7X54WtN1RmRneFQOPHbHxZw6BLM+zsXHS5BvqVUR8Qtk3Lzf4UgbliAvKiXQzxyyxRCdOSPuoqcV+YKvmCT+IY4VHRAEvm7IT8O6tsxsVDbkHBO5CaDL/PUrNnUT9PGHnqTQWR7jYlQoSUui1ChI+dMCnTimMtuxQgnK0bUeS6XnqJ0wxtGoekAUols3NCZN4SHTfQP5PJiYX5E9NyzNAWf2jgEbAEUZcs9qleBhtk/m8ZnpnayxXHur9N5cHjUGvR1GjVuJtb4a8PqdRqiux4ev+XNZDacWK7gpIWRV5B6/CprJFqbWHLj9vlCitb8UlikymdWp4F0qZaUTYbhAON9+UmLNi2l6F1Td0AQ/CiZlNrG4paj5V7iNwfAVE2DlVHyoVM30Ak2+eFx3vkvaFPtWrO4NrSXW3syf+lMNIx/X2/E6frveKIN+PwPbECk+2gkqzYsNI8Ohk+2mOX7iI1wLvmxCrWuwG0vAbrT2Cvf8G0T43NMm34Y+0hsFjB0nu1TJ6Cz/8k/8xp4mjkzfcSm+XxBrAq22zaFHAghyRzk528nf7rcQI3eSA/RU4kntqGEaweq1QvNmgFhSE1KRslDF8g38Vy5wovxyGHO2KnQFPSVumL+SX+bDk1mWSQOp/+mJHLof4mRYGh9d3lJ34f3gd8MVi7RzmMpExiISSb31OfcubeTKV0EaPSZ2Igvaka6Jbz+f4l96Zv2PGi3w9jYdIP9rcOweKg8up46slQpZ9Cn6bu5Sa6MkmjUpHve8o1gRbnFrGiaB3uxWLNsspVc5HVwCsJ+PsHPXowgiPlQicdSQ28rzsm4g3L9L6KPy4AIstWITlmZ5x5rfeqyVxMOcvVw3tZwX7iTiqIshbAaUy95XbesIA8ELJRdlswpex2slq8ZgKgfENydvXSkv/X
 j15ULPff
 kQiwUG9z2aa8z6STY1YQswSzkq3zoFHhSgH8XYm20vjFiyrJ7wNRkD/SUPbiX2w179j3tmpQ52EDLpQK4cl53szvmNmSGF6SJ7hyj6lKNR9X8vtOaRSfnQ36o2dRreQAkOvEMaNRP4N06+poIfkE19w6ARE18G49/kWtT9iOB2Ej91UqM+fWPfMKP9eXMBk8SgW4g/lC+MkPBlHuVG9oNmIb4o7Du6tYH+V9jmmBGbhW0mWby20NuNqOG4F1n82ml8SjspcJjy7Fhz/3LDwSHxmFSxHHDPgZr23gnyhISUCadLFEXSalnobbC6HbqXLWXir1XcLirKkee2NMJeCgVwqByx5EVFV0cD8g677VWOZF6Q6iurHG0G+I0AjSnmv4BvCXQ0TMzSWFLAvRpbgJeHkoZ09UDPHe7P8jmTNR9+s6rkjaWy7omaMylhvzv5fUAx6kZu0HJORGgaowRmB9Vd1p11YA3FHP0tthN7/QY3lUncdo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 2:06=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> This reverts commit 78524b05f1a3e16a5d00cc9c6259c41a9d6003ce.
>
> While reviewing recent leaf entry changes, I noticed that commit
> 78524b05f1a3 ("mm, swap: avoid redundant swap device pinning") isn't
> correct. It's true that most all callers of __read_swap_cache_async are
> already holding a swap entry reference, so the repeated swap device
> pinning isn't needed on the same swap device, but it is possible that
> VMA readahead (swap_vma_readahead()) may encounter swap entries from a
> different swap device when there are multiple swap devices, and call
> __read_swap_cache_async without holding a reference to that swap device.
>
> So it is possible to cause a UAF if swapoff of device A raced with
> swapin on device B, and VMA readahead tries to read swap entries from
> device A. It's not easy to trigger but in theory possible to cause real
> issues. And besides, that commit made swap more vulnerable to issues
> like corrupted page tables.
>
> Just revert it. __read_swap_cache_async isn't that sensitive to
> performance after all, as it's mostly used for SSD/HDD swap devices with
> readahead. SYNCHRONOUS_IO devices may fallback onto it for swap count >
> 1 entries, but very soon we will have a new helper and routine for
> such devices, so they will never touch this helper or have redundant
> swap device reference overhead.
>

Hi Andrew, I saw you have merged a later UAF fix I posted:
https://lore.kernel.org/linux-mm/20251111-swap-fix-vma-uaf-v1-1-41c660e5856=
2@tencent.com/

So this patch is no longer needed, and should be dropped from
mm-unstable and mm-new.

Can you help drop this? I'm doing a rebase for the swap table and
noticed this patch is still there.

