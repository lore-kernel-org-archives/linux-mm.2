Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ADA2D66B86
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 18:38:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D4A76B009E; Wed, 17 Dec 2025 13:37:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AC3E6B009F; Wed, 17 Dec 2025 13:37:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ABA16B00A0; Wed, 17 Dec 2025 13:37:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 663756B009E
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:37:59 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E3A73BD2B0
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 18:37:58 +0000 (UTC)
X-FDA: 84229822236.28.5BB83A8
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf16.hostedemail.com (Postfix) with ESMTP id 167E018000A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 18:37:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UQ7N7tsD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765996677; a=rsa-sha256;
	cv=none;
	b=bXRIOXt4g39RMBXkRZIEeGRR4F1XvdsfQ3OMJktyd1yZuvIXAFOsvRd3OlYsk9SF3LvrWV
	Bjrn/8SFovZHP1KHiBWrIDw2uPi16yjwKRjZUBE/5lh4/Nt+dpRHzRmoX5XZEVhWIVLtgY
	Bru8UuG28/XCziNPFhQlYNPka4wQG/A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UQ7N7tsD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765996677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AioCGMCzu+3FGnShM1UgSocq31p5Xng6wkNeuTF3RrY=;
	b=ogHUrSuGmWI8IgRYBZLDZXAP0tndJCOfjWW/EJPnSqpfZGcdQ4v5u2iWqAc93+avujNn86
	vSs6PlOkwKfdYm/cQmwdIL/EEzIcy9nONdzXQg8S/HfjTLk4vL2e9MICvD2iquArpHuRzk
	M8o/Lazb+m/TWpp9tynbVAdEYkPIqww=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b7697e8b01aso1095857466b.2
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 10:37:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765996675; x=1766601475; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AioCGMCzu+3FGnShM1UgSocq31p5Xng6wkNeuTF3RrY=;
        b=UQ7N7tsDuCT1xgWX/LtuGztqh7lQEqFtcf8iDvHTCfga10nWaEgxvbTMuofXaeDsSe
         dte9bXskPNDcBckPkjISTJIQ4cz/yqPQQa7rIWNNZWcPq3licIxKrL910ywo8j3uQ0Ju
         eGnv7rQTbhQdKbsvTmFCRxnMV0/YBI+qezVO/SGNVrb/MUx34vcy1j2JdNLzV1ic0YkG
         uJrm2CCQUnhbN3mSR/d5sE8DlfwN/McfAgAmp/vB/GPdZGt4DGsvYjsxgoEvY9EYPKup
         ZHqUKcUTPBJouM5oe0gyGExtkBslvdQQfI82w/mS0QSbnRBLHIYyi3AZu07QU0oyZHTu
         qbZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765996675; x=1766601475;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AioCGMCzu+3FGnShM1UgSocq31p5Xng6wkNeuTF3RrY=;
        b=TwYPPk9hb2Lqz6Km8MXC22AzrSbENtH2DqAPpAElO2PibPB/YUaJTTMMx3WbActSWP
         /73e6YWgWO1w1Eof8sVRy9LdRBLV2rhMPQ6TdexnwVl/eYj1AUyWnnrExd2WeZ8Y9yth
         OKI1l32QYuUqHWEZdAoIow5X+Mw58lSYlfNnA+shJAyK4qU8a9HzHFWi0VPB65VffCRt
         +SOAaT0EfteeQPvYqrzRJhYF6bCrlCUfbS7S6MW+hu5P7kiiGBso0e1vtlBwU7i9u5lv
         UM74C07XW+aVt11wDg65gSfCedm235t69uZBlZmcHAnZeeEcNQeoak/YGBxqGenywAP0
         TTlA==
X-Gm-Message-State: AOJu0YyOzDHTmkuWBhiFV4i8lnBFPz9NAvFKTYsEz5rzFn1Qxp5JolCt
	TUkA53yDE27jQHvWw9u6jUMM+H1zWFW80u/I22liQm102nZIKDmFJ/FJO4p3XGzdy1QRadJOvt/
	AohmKBpX5bOX8zAH35TcUE7EZ017wjsU=
X-Gm-Gg: AY/fxX633st5saHuR3D3Wk+ZPSI6XH8b75Ru6gMSAlQeAibrWI7mpDDH5UY4o8rc7K3
	XbdnACjNvqDd7j6/j1G//aptNElz8HlRfFaJsGENXmVyIDG4lEUAI8914yathM3SMzub4Iy4fuJ
	s/gtaxdpJeVWmN3jjF7g5jxnQDPh+pdCJ8tF5AxBPegm/keykIr9QuyK4sz6zkzyCuNaub8uRB4
	5nCroqT1dnoEbXMRCh7sbZwG7Bh+KS5zP6jPLDznwIHtecf1H79jJTSzlOTlGSSvVae9B8cMBjQ
	8VbVt+9/C/ktXc4A8SIOAhjv06o=
X-Google-Smtp-Source: AGHT+IHp0KvwC4ECNsDnpuyGsqS0cTxDlLfHv2n63H6QlEbih431328SFx4WM+lJthF54qJZJELsd2g47lENzEK18lg=
X-Received: by 2002:a17:906:1ba1:b0:b80:3a1:e3b5 with SMTP id
 a640c23a62f3a-b8003a1e8e8mr346431866b.49.1765996675193; Wed, 17 Dec 2025
 10:37:55 -0800 (PST)
MIME-Version: 1.0
References: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
 <20251205-swap-table-p2-v4-11-cb7e28a26a40@tencent.com> <aUKSgf31kQ+vfbmZ@MiWiFi-R3L-srv>
In-Reply-To: <aUKSgf31kQ+vfbmZ@MiWiFi-R3L-srv>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 18 Dec 2025 02:37:18 +0800
X-Gm-Features: AQt7F2r7-rIPcxtw4F6wS7NAnwq9RzBJ8__z-EbDy0ffq5nH_3_vwHrpmx4kkkU
Message-ID: <CAMgjq7B85Pv_1XUspypCr3=QaQfkGdJaL+ERvtQ5yQtiQLqRqw@mail.gmail.com>
Subject: Re: [PATCH v4 11/19] mm, swap: split locked entry duplicating into a
 standalone helper
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 167E018000A
X-Stat-Signature: c8sf6js4rfeqd1zdy8p87ttex16ojcey
X-HE-Tag: 1765996676-46606
X-HE-Meta: U2FsdGVkX181vPnad1ntkJLTCmMnUbc/vxg0ppMNEuSxrTvKH9GrBIqse15w3Jy3MLAP2odriFwM4K+Mkl5Jj2Zlb5LGVmOxdBDneWeRv5c5Rg612EP3quycaok0YnG8XWSSXNzpPEsy6cpEPT330GJB3L6TGlljjoa0+duegqwlY12RMK0ISYvlg87nZvnsxjMgnChwPx4bzAOocFiuD2U+zDbL6bbgcceykQg2W3BN+MKOI7sibLpTKgt4dUjgqUPR7dK7BspO0g87UWRI4QwEl2s1n+h+t0uVK3ipjfYGmCYDMPdrTwwGGcSZg8AY1jBjVpBGBexPub1tdu26ywLecEfZqgNvycUDX+mveMwxoc5HSqPDiMdtTwm9yizNhv5NlTiw8syLt9EJIHHGOvvBQB972dfPhgm/r9OxX+UNB6/gbpoSHI6qGNaZGa+7FoLdtN1ykSFadnhuQf/0fB1uvTBoMRTAxVrwkbG/EMXY6yjcodMvuuzv2VxU/1R9/OOOs4iof+OqueL+BuRC64r0vMu7HRVrPandf6vkO/ydt1ldQWjJM1G6PY/fMWLUFS+coN5+1ONiaaUe/mand6PkNryme0iFjGgzTdMRHJuaBOHBPsbzdbd6vc4kmHu+ykqzWCHhpk4T76obbhTNntvIN1ZpsvJ9KxANg58bU4KmRk+NXggKDsckA2hkA4WNZJG7ijf2xv8Btx3QsJNiFC4D3nYZYln/5t1bK0gNjRPijhWu9IzkYKqrO6rB81xHfMXzte6advRxgYmWL0FxZgQZcwE4R2PUxy1WquhNz7ordL6MBrNg0U4S2MPNObpvl0c4nWDLxKLvQsAtY16K3n+Dq6uLzA/hdqJLQid86gs736c+LTD7nxWkLVjxU0I2sEtyA4fe7DVrkbZ2KJ9Wf1BGbM3PliUxdHniV89lpapInjI3lu5zygRudUU+AR6Z+Yu+zkW7LrQuaI+NgJT
 GXQuM7xS
 w75n7Y8mkZKNEm4BMEeZVD0R44w77ek3Bd/ECdTTzu7c+PncsroOUEpc2Is7GO5VQ5KGwbViAjT6heQ4Ai5U6dhrj+k9m2lsGqVhxy1iTXmgIHHpOxxq6P0OldxDLvej4pOe7XzalKtU96eIr4Z7I17zLWiWdw/VsN5UDpiX74pQPZVl0gDxWNFSo5m8OiIE7a5VqK7bJa6xHNKX28r/79pBjKDtjB8ztuGggMGH5MB5krOpTQakaMnEIqGrHsYaZz6o/nJPionIf2r/9Xqv93L39CtHoYzRolILNZulC+6oL0ykgnII5gw+PaXHUR2x+7FI/Tn72n3koSv9NkkPoIY8jVHYkY5NtRBnSHAkHzP1Y8aQVuIZwTBZ+X8B3TmjtLMHuCmfZpYTEXNKwu4lY//4a+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 7:22=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
>
> On 12/05/25 at 03:29am, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > No feature change, split the common logic into a stand alone helper to
>                                                    ~~~~~~~~~~~
>                                                     standalone, typo?
> > be reused later.
>
> In phase 2, I saw the newly added swap_dup_entries() is only called by
> __swap_duplicate(). The 'reused later' means?
>

Ah you are right, this patch belongs to phase 3 I think, I can drop it
for now, it's just a code rearrangement. Thanks!

