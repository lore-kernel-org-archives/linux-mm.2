Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3241DF45A12
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 00:34:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91B116B0089; Fri, 10 Apr 2026 20:34:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CB606B008A; Fri, 10 Apr 2026 20:34:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B9D46B0092; Fri, 10 Apr 2026 20:34:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 661D56B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 20:34:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1530B160671
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 00:34:32 +0000 (UTC)
X-FDA: 84644403984.10.4813A78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 16A44C000D
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 00:34:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XZJ2Bd8q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775867670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xIEz4rF1j8JpIYdjyvbkQ+33mKAMpyIpO5NlOVfqQRU=;
	b=dxQKZuAwpCRoR5pjGh2vNO4/Rio+iwgsgCBXARPVoKmZ1HKLnycCIHimS9gxxNkePgfFP7
	nTZPMFUUJNV7a36UAhdnZFBDDUDzE84BkMXdJT8G5WodqOUe2KFO8Kps/qNxHKUGbRsU5Y
	6vm/pCjSEGidvMJ9v+fDvrsyMCQnHXQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775867670; a=rsa-sha256;
	cv=none;
	b=cJV1q3rUIxjMAnNUi2HNslrs0Opp4uvWCH2TQGRjhAIDV8iVjD9grx0lW5jmhsADp8r1ov
	JUXRni8+bCIV4Jn0CKrKWlxf0aouXXWvScK7LfwAzOVnAiIEyJhQ7fCyc7Daft0UaJH78z
	+PQ/cI5IDh89vTeAXT4VbTvEpSAhkvo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XZJ2Bd8q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BE5424455F
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 00:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D6BAC2BCB9
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 00:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775867668;
	bh=aMaxyM9DAkGN7TpTqVyxxpJ5lbyTiW9bNKnlaUTAsTs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=XZJ2Bd8qPVI/y4dtDVyzxHXr4b74Krm2kIeqXFmeYQ0x9f+MDyPYrhhvX/rxuedkd
	 P0s7bR97+bmq/SY6BLSikkAJVcKnbm+W0wc0qm6LvLXLBZtpwvAs+J6+w5BFoSvY8U
	 /cfBc2KBEQqt6ECghoA88vEsJuzvvUbuzz1mrao1LVVBSvoMzMX4I71fqmCGx3UnKO
	 2vOybVglzMIRNrBFmJh5TcpLFc0GTGSvrMfWg/dN855HPiFm1DElKhr9GSOJt3UCRa
	 dMHLV9rIxQ9CpHsaXJXBZ/Cf5EMAAfNhM2r1ZpbAVEbdxk6nuORGCQ88VOg0gzRHDc
	 fuozjg0AIk6Ug==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8d68f702851so415173185a.0
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:34:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXXPcynstxGALbeoABUOqj/fBwwfoJTWYS9rh50eHyB+zspxIDIXyczKLNikmeP0XiSCHG7gu3JkA==@kvack.org
X-Gm-Message-State: AOJu0YyWTSavz8TWOm3cHqppxKAzslx5SjcD/HmyRvgxMsACKV0FCUBM
	T7EXnYU0B6f9OimfDBt7nJTYGl0kKAAUtId07RJW9BxNcUgtDMgtalOZXM1Uko/KqAimGzuBPx+
	8Jzm8OdOUyF3WIrStYin8d7IMeW1hDjs=
X-Received: by 2002:a05:620a:4688:b0:8da:dc5d:acf5 with SMTP id
 af79cd13be357-8ddcd022c95mr752874885a.12.1775867667820; Fri, 10 Apr 2026
 17:34:27 -0700 (PDT)
MIME-Version: 1.0
References: <20260410-batch-tlb-flush-v3-0-ff0b9d3a351a@icloud.com> <20260410-batch-tlb-flush-v3-5-ff0b9d3a351a@icloud.com>
In-Reply-To: <20260410-batch-tlb-flush-v3-5-ff0b9d3a351a@icloud.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 11 Apr 2026 08:34:16 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wqFhVALC-AxFo2v7yanTL+tsL0OCVYv_gRwdh8ds+7YQ@mail.gmail.com>
X-Gm-Features: AQROBzC5fBeIxMPrjkqKy2brcpvcoT6Fd58zwoWklkcj-YVyph3-AAt7Y71TUu0
Message-ID: <CAGsJ_4wqFhVALC-AxFo2v7yanTL+tsL0OCVYv_gRwdh8ds+7YQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] mm/vmscan: flush TLB for every 31 folios evictions
To: Zhang Peng <zippermonkey@icloud.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>, Zhang Peng <bruzzhang@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 16A44C000D
X-Stat-Signature: fe44j51ew391aqqocruojyurtwomfd3p
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775867669-534836
X-HE-Meta: U2FsdGVkX19jWZbePxL97FRyIMYwhjQItxV1uHoRBzwMxqFzXWKFQKW1j5aSqp6AU0gDVgGBRnL/dtr85l/CcrNMcA6RWMe05hW+jDfvIK+Xpfm6hpSLkeQbMe/c8xaZIGsxUEAbK5Hlal7cl41r38lv0cwEszuejeYlnPVvXDKXyS1npV86k4Whmcpy/bo7Xyto+fMTl2BAdRVa8i56LWi/YtUMSTam97As+VG61ip3qnEwtAAA/YuMXTeh2FA2lh0YbEg+WlR58vN6kiAXYAoN9yiJeBzukp3MPZ8ty7LfSlBl6dqX119zoPHix5bYMArfohqEKI/ua/j+DSRqHPEHkn67uzazHV2JEEZbenYfKBa/lDzKjTcPkdZ4DvymiLkrg80tg0X0gHHmR/AiNxCQuq8XyDGWLlgBz6naqh8Q6KZ+gmMvw1Lbg8MRzUwoSJ27dHvzxArTKvqojMjh0JEou1VmU7YuHjBHiRZhA7lTNTK/rpMFKtJjSPgFu+de0tcz07hwuUK2/EoQ9zj2LqMRRSH+Z6cTSxvlsBd0/kdBL95taXhAx31pWQj19z2KoOcKHVBBYSKKWdx73Z8SrYBx8WImsBxjPoV+Ej01n6VkCC9105y5UsLfJWMNu5WpsBhxxI8nmoh3Z+T8+gmPGKEZ5bx5AbN8QubXzY/hlMu/M+iVEQxewpjSVtK9xxuY2AxOfXSfK1KvU1XqQie5R6NDFUNJOJKYorhAuTapG1Dhs1QRVVEcRF4+9MCkw33L9Srmf6KI2tzD8off+84RGa3rtyMUMFLxxHNjmx9BFow+npOkyr8Wcbw1/ttlAesLSKP5cesuzSyQ7eiz4kXB5EUzp17nhaqCglqdpCWTn0GW3GgB48vPg5K+A4g34bWFVkZ1CsXp8fmvyouSPVBdRo77jjaXkk/9qD3wYVBymfsi7o7URPGoSgYo3MkFQCbCN7nId75IGV1Z13A+pQu
 YEjxQFIa
 GhX8S/v+isWwc6/TfGvrBv23QrXAmzvynZiG+CPCXeUNtR51kgGBaBeHHUSFfbautxzeTQQoA48DuWmm0KBVsWfC5hjgAkUYuerpyokJpLL5Go1wCbMo3WWO7bIFPSkRDYxX9YN6o6I/CjIo2y91Pr7p1/EzmdyRR0YSq+oNu3gmB2W+qB0JgA5+gtx64sVxgFyoOyESco3FdidrSpyo49dh5HyaEPy/7NdVHHFHQX9FaK2z9NZe7DFxjHT+YTFB25XjuK0T9GeLi93nRQFAHhC1iEGIIfErroRnDFW91DkStTOLHNfkvzZ52ajM8jQvCIh9xG6b5FSMsoqE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 8:48=E2=80=AFPM Zhang Peng <zippermonkey@icloud.com=
> wrote:
>
> From: Zhang Peng <bruzzhang@tencent.com>
>
> Currently we flush TLB for every dirty folio, which is a bottleneck for
> systems with many cores as this causes heavy IPI usage.
>
> So instead, batch the folios, and flush once for every 31 folios (one
> folio_batch). These folios will be held in a folio_batch releasing their
> lock, then when folio_batch is full, do following steps:
>
> - For each folio: lock - check still evictable (writeback, mapped,
>   dma_pinned)
>   - If no longer evictable, put back to LRU
> - Flush TLB once for the batch
> - Pageout the folios
>
> Suggested-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Zhang Peng <bruzzhang@tencent.com>

This sounds like a pretty good idea, but let=E2=80=99s revisit it
after you clean up 1=E2=80=934.

Best Regards
Barry

