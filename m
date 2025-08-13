Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C8B4C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 11:05:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA28190005A; Wed, 13 Aug 2025 07:05:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5380900044; Wed, 13 Aug 2025 07:05:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9906990005A; Wed, 13 Aug 2025 07:05:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 85F93900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 07:05:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21F62117087
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 11:05:35 +0000 (UTC)
X-FDA: 83771453430.02.8D2D54E
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	by imf09.hostedemail.com (Postfix) with ESMTP id 33FFE140004
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 11:05:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P7MMjwUe;
	spf=pass (imf09.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.42 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755083133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VAU+zceNWMs0ZEPv7KyAXNBpYbdpha+WzKllqlveQak=;
	b=cg4IX1ypt3cLgLmAo0gf9G+VmmlG/VbrT7NlEN03oC12YS3Refdkw6m0srL/JZONkVo4Ow
	D4P/U13Y5iAUctNKA2Bik1zRzyjZJQTwHyR7WkwriVL3xG9EJjhU7/tlZ7A8w0psOkhDs1
	JXGrcfvldqiD/7WMiMT+N1CJ4s2cb74=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P7MMjwUe;
	spf=pass (imf09.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.42 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755083133; a=rsa-sha256;
	cv=none;
	b=o4hh3Ny7QdQVIgghJajzNWgVj6Za8cvgx0sncu5hnNWKPkvPy+GDLtcHgHhbnbfmw4prQa
	Gu0c+FCY44CymgClBxhRmnDhjBLmlDGNba6jRX7bim0Il3ev0molvFkCtVNWmcpqLbtI5y
	cAYloYSeCB+TTHGGuJ4QA7S65AUO7HU=
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-88bbfe763ecso1401987241.3
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 04:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755083132; x=1755687932; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VAU+zceNWMs0ZEPv7KyAXNBpYbdpha+WzKllqlveQak=;
        b=P7MMjwUekDE3FQFMe7md+YV5/MqSAohglMeQ5g1VQVvu7Un0M0D8q7b/gNy8H8VHhN
         BKHH0Nwpq7U80zeHnIJSnrb5Gfcc/Co6Yob6rSQpzPlw7JquNSG0y+2QLfZ1Q3/OITVM
         TulOhFdQ/2+36HuLBYtx7GRIWJPslxNarFhZt0P0xTf/3sD8cQHoCLLxa7zMTJEWjXRA
         4O3tei1bsiwSQR2RLCu8dKtXOosAr5EgrC3n7DJnDjm0QCUmDHbLWSrfs8wUWLkng+W2
         nONEhYT2mOuLGCumKTMO+YOnnhbQ7BENbA8tx12zn12nqAS753bPjuHmSR6CsmuftNpr
         qJiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755083132; x=1755687932;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VAU+zceNWMs0ZEPv7KyAXNBpYbdpha+WzKllqlveQak=;
        b=BlPiDWGKh8z/2jcbQTevPwL+i4u6FxkHreg0u5lTPyKk9ugP9cHlhQKQUd3K4a6pko
         BCjSugefPa/gSGeeH0zpvIH/l9p4m0xuaOrqFdAsAIznrx9upDyJqzU/Kk6ii1cj8zrq
         cLkktg5dSCOw7MetiuECah4aHma4MyJjHtko/yzx/mYElAha5jrMxOe1GtYbQQBebH9W
         uuyQ26VlnNwlGJyBGfcDR8blrNZ9g0maPsSLUvlpbZD9nnre1EDiLZrdbFYqfVvV6bi5
         GyQYKsD7H8VLK7ZM9Hf3e89enFrvoo2p2/qW9DC7G/B2bmmnM3YFKd242JhFyxtSOBWj
         aehw==
X-Forwarded-Encrypted: i=1; AJvYcCWNQcTdDD6lJ6wrpAGczv+D/TBBpxwbGcfjIDrPrgGoXQng/HlA5YZw6QBgWDnBfWz5dzj44DLXgA==@kvack.org
X-Gm-Message-State: AOJu0YzxXOiPlU81LKCt37Kc+f6PVz7jrKho88B6wpPmV4CN7CYFm7mn
	WZdIHSBauPUhIvrcEwrgM9qMGjkA4qTbmfmHMTFdvrKC2yb0gWQWu2GumOk1T5jh5xGPuSV/0oB
	lQhb9Glzkmn9cvyoUDX+K3BIf9PFDXRc=
X-Gm-Gg: ASbGncuMHglwZDecicShJvpcG3d90vBf0hXhkB613pGePY6iu4z2XomXY/tNcig1JK9
	DDwyGc1QPOT3XbrREPWs0ZJJmJVAQuSbaH9kbOtG/f+l0w8j1UeEUTK6IaE77p4YdOFh0ys2/Nd
	DuIas9BORuisuEIu4AnssN1Xy+CBAaYGnlWhFqD/uwOSZ8r0/QOICYStkRNgdadRH47GMXtsixV
	atVeGA=
X-Google-Smtp-Source: AGHT+IFPxhkXOxrLIsxMwcvQ7cx+/7YRdzp55QCPl28lvedTXAyfIC3Z7h91nGDbZFD4Pb5+wy+uQsqY1MuUcTusfak=
X-Received: by 2002:a05:6122:21ab:b0:537:3faf:9b43 with SMTP id
 71dfb90a1353d-53b0b64762bmr691742e0c.12.1755083132012; Wed, 13 Aug 2025
 04:05:32 -0700 (PDT)
MIME-Version: 1.0
References: <20250812-swap-scan-list-v3-0-6d73504d267b@kernel.org> <20250812-swap-scan-list-v3-2-6d73504d267b@kernel.org>
In-Reply-To: <20250812-swap-scan-list-v3-2-6d73504d267b@kernel.org>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 13 Aug 2025 19:05:20 +0800
X-Gm-Features: Ac12FXyVj18wyuBxiQGXPtGH3nYyv9ueaTOPrGF318nRrxEi_35SMElTGl7ouKw
Message-ID: <CAGsJ_4y6NpwggLsmDJuSHNn8EM6Vq3_tS66+iN7PoPgOY7ZhzQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] mm: swap.h: Remove deleted field from comments
To: Chris Li <chrisl@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 55ad58yikdmh9uiw9t5g7sgkxj59yynx
X-Rspam-User: 
X-Rspamd-Queue-Id: 33FFE140004
X-Rspamd-Server: rspam01
X-HE-Tag: 1755083132-697199
X-HE-Meta: U2FsdGVkX1+8Vgm+xDvpyGVwXc5wbNynDBgMRuGLSEWYREXZZcn5/H7Bf3S95CeHxM1YeU2mdlx4J8XvI2nVjd6KlwBkhC8IUUTBSo1z6ShPYe9LjV6dwJ0fIlD/e173zJLoh96sd7rmW7HEHuubOgcNsVEbocBkuNwckCPtlZDVIu/5hA5+v20nVlWrC1/yXdT77UvYI+BwHtQ5DCWPTWLjEVrmTLXLT6GC5OdUDn0+wJgBYQOSELErKyA8wXk/2eR4hpQeYF1NV6wlWdO/Hza4jf+I5CT3ZWlVoH3FvVsZ3qxnafk1HvmYtrAVWs1kXR7HKUErYmFRlc8DTCtMyesNopqF7Rr3ScTv+EpbD3UTLiIRpMRv8kiZq3zZSV4EuqhKtaGQStI3+0B/NtJ10JFaQSEHeNGVBk2kCyQOf+MfgbMEwDhB0vDNW19/neujQVn/HLC3cW2aHDnSuC0cUVtbYt2NAqTd8WXpeRags7fn7latOPHx7oXvipp6pcNMcBt4NMDf5ziUCasPb1+OtghTLrSOPGaY2DN7CtcpTtuqRQAVxKI+FSPYK3nqbNMH2sOAqZnYI9V864oJCYfdTNwgSh9broDlVzdRobYr7yQkHLcJloJqvwSerdV5VAW4VteUc9K/f46OLCy2tB96VRoe1damYcitscEKWPY2gVwyFXmd+DpFkPHHwMSEKDrQgmSBv0x/4SLLNr3bqWIpwFQBLHOauzK7USTjUBZSQaKX4bGjwq2R9r508JNj6/YvoKfvDJoiBbIwi3MFNxaZLx8jXlZyAH15GnoosG/HepM4YYevsCfxrTcGz2qt6dgF0r5eqkKCFGq1Qv9PePpn1hv5TlcgY7CExibFbVgelq6e5Eicv/kR7gXxLShTWVIBDsqtowj1Ntq9SB5g0mmXMIEnot81pk7NfZ6hVKD6UrooSIMbRwQiLFCE9fEa5QtUUJJ0G3RyeptJ4+97TEX
 1jGo25yh
 f5ROFYXuldnta8t3wzF9jsJvyaoAo8pQuUnji7Ya9IEgvTQGrUS4vL0yRsgu92ec/8JjRIiJenrFHzJT6d59ppnHMqWTaThPc6Xr9ffbZA0uqEdE1MuNsobGo7PtZ5Zphtul34x7roNq70sXQidM6XqMUxZ/Eec8xEA0XsGbv/lzqI/p+9+7tnWW9cekfLj7gouKjimM7QI4aRCit4k93f1xME3/Y9P6xpvh5A21SGS/1xMCL5Y4IMI8GZ+Kxv4TUS1B1TZ+mM6loetJwv539WCZ15i7Ug2BK3G78x4hlDivlqUAnpQOap90oi7EEO6kM94XaI+KDTsHR9N0IG31FDDl1rED2HY2MvP3bvyN6O0rHPc3Bup8mNYJkwQjKM7kT0/ne
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 3:11=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> The comment for struct swap_info_struct.lock incorrectly mentions fields
> that have already been deleted from the structure.
>
> Updates the comments to accurately reflect the current struct
> swap_info_struct.
>
> There is no functional change.
>
> Signed-off-by: Chris Li <chrisl@kernel.org>

Reviewed-by: Barry Song <baohua@kernel.org>

Thanks
Barry

