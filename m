Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76376C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 01:37:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E1976B0005; Mon, 13 Jul 2026 21:37:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B98C6B0088; Mon, 13 Jul 2026 21:37:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F7EE6B008A; Mon, 13 Jul 2026 21:37:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E97076B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:37:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6A6451C019B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:37:47 +0000 (UTC)
X-FDA: 84985670574.19.2E0929A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8F2F720006
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:37:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XbAhT8+4;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783993065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8F4yLfOsobdGYOIb2H1K41rpcgqSprPnX1ok5IsSzP4=;
	b=GO+uPWKWZEIrkiEbw2zRaKVLKjEVPR1rOtPEUYHFO2N/Zc4h3jKSoAgfLAPWcG32lgv4up
	5bSwR/0Un+wIYkO/HgWpHsd/hV38qgWKTCiQ7NhN6afpHpeBtSmq/HzbCXmYV4li841w20
	7drzW4W7CNVM5v7pogy99eJw90JtjDc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XbAhT8+4;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783993065;
	b=yAstyIIiteSxvaisLmxFbNxpUbTaFVfwiojnK7gqdtgdWfEcAf7WiuTOlT8EQsmk3s+otY
	UWI/2m8ug9SSHrkWbPdMmTe0zRZXVTqjPRseiYKMy0ruFH33wX0inLKRLsCKVbBaslDVcz
	d3xAi3OHFcNXKYRiZ43/vYK5OkFZvBQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CEA1443C0B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:37:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55161F0155C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783993064;
	bh=8F4yLfOsobdGYOIb2H1K41rpcgqSprPnX1ok5IsSzP4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=XbAhT8+4QoWiaUOO26oWk5Dt4pMcZyvfQEulP7D7EJRnIIAUGHrZSx1dQ0kOyms8A
	 G/RwKMfm7Jn/gCxYBNJXBv2/bByTAQNPrvHqrrlBvs+CZ9rkD0w7ZlB2AfuSinK+vl
	 jdtzM6KZWpYHgXTGy+JqeLJZg0SV6/6JILiIhEo94C4o6L3Hb2Wzm/DUu1hbyBDPaS
	 dedK2zJy5xVMHUIThVmu9v8l9jheXr4R/smDJSu1kpTTt7GkXpGoAxTi/ksVP9B2LR
	 lA5GXBBRJNf+tOUrCq9w+FlejZuVZYDUAQlGFsJtrSpSVcf5YaUeB2dsrtcM4eejNW
	 BpMN9i9lEP/iA==
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92e5cb052edso38833885a.2
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 18:37:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rr3M2BhUetd4aQX/E9XjOpJsvwSwcWyY6GlZogoG+6V5j/nVvt0Bdio0DZ6ucq23kjJXRYdGb75Gg==@kvack.org
X-Gm-Message-State: AOJu0YzbbhMBcHkVxs2rfccgo+npd6t9yAJi6qdUsb0wFVhmtn7r9a0y
	OuwVn2Hh+v+YrB+3gKYMWqcNSC1yK/zFcRUBBqBshRZCpCF1/5kFaGBKOyY3+hLWGzKpcqnWPNd
	wxDOnmdX9c3sO0080e9ABgqIwcEqSF/c=
X-Received: by 2002:a05:620a:3199:b0:92e:c118:189b with SMTP id
 af79cd13be357-92ef2c57098mr1245176785a.78.1783993064030; Mon, 13 Jul 2026
 18:37:44 -0700 (PDT)
MIME-Version: 1.0
References: <202607140924549782dUh3YBPmy8g1NDMK2zIW@zte.com.cn> <20260714092815120Wv-CFDlLKtsTmda--97Qw@zte.com.cn>
In-Reply-To: <20260714092815120Wv-CFDlLKtsTmda--97Qw@zte.com.cn>
From: Barry Song <baohua@kernel.org>
Date: Tue, 14 Jul 2026 09:37:32 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zJ0o3_RhaTuyY+Y0scwgJ1DO-6wyFb0ZRcQE8g_y-CmQ@mail.gmail.com>
X-Gm-Features: AVVi8Cey7rtolW8W2elC5gEK55rim07-0x7pNrAV3u22ybA2jlwV0Kubqs0HO9Y
Message-ID: <CAGsJ_4zJ0o3_RhaTuyY+Y0scwgJ1DO-6wyFb0ZRcQE8g_y-CmQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] mm/mm_slot.h: add comments for mm_slot_lookup/insert
To: xu.xin16@zte.com.cn
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, lance.yang@linux.dev, 
	usama.arif@linux.dev, chengming.zhou@linux.dev, qi.zheng@linux.dev, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, wang.yaxin@zte.com.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pmezxsec5jkb1cwfq58xxj8ks9p4ok5a
X-Rspamd-Queue-Id: 8F2F720006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783993065-201965
X-HE-Meta: U2FsdGVkX1/Y+Yg5jWqvMLpoGmJkWlLG7TXUXSuAswT6kKhIJI0RFtOka0HIL6gz7a49KYnTjTHT/SQ/gfCzaSmYSU4OYYYXSynmicg8waD9WVjfrhK/p0uyyCR6JCpVyfoyTarwb7kKKOIWzTvR8bhR2vj1EVnTsQvA3Gp7BGUgAlbbXaP16uTdp/HaQiO9bbaeIV9jgq2p1nuHolWxV+u16wXXU+3yPjYQ/IYmvJPXpHGHJEOPAVYAAvVtgMQFVRca8AL8apTbzCWghQwJpc11ltn21UNqywXIcLKYIaGuLAE5J5e4/wzpd7V23uxDs7hOsaGpuoByLxRoo2qncJZ0zXlQ+TzTTVWFGEyq1m5A4KIV9B7GXVJ21dtEZRnJGlAeZk5vrLAbX2YXAfNO+qj0RhU2iwfg1i9zEJdi6uh9cp9ljAecBCCgqQBJX42ijjwoodC15mnPKNkvGnuRHsf+boSoYEG1MZe+DykSEFOFEe2dBP6Zmb6WyJlEfv9pKsZfF1TwCHdEn/Tp0iGkDRIVosQpdGuYXkJViz1jlyucHAO4DWkQHS+OHxpg6g2No0Hp+QI4uUq1zobX44G5uLprJ2UHYsv4VVQ0V6JjZFz6g5Zkk2pa1XOeE+/qJqwUxMGPN0NtIlUUTomooTl4snrWG+6cPLQ2ggqu/x08cWPl0kuK/Y0IYfvBu9+Dk+oUGYQakdCjiIPdmt02/9MHiLujDLxZvtkLLZDg6XOOf3QCz6wih5+SaYzDi6c7FCqpdqffiKW0QZUcYduHVyqVP6wAvHCKXtBzUsS0xcl8KFy/0P7SnD5XlCMLF2lH+fv54fN2QiEA9ET8rMkmnOwz6rFjPN3v+eLb7E0ycadPd45o+LY05AWvha4mrnsobdYEKNGuJFz528NN4sp4RXU43PTnoOTNKI8YTU5IYz7j1a/xpZ5C5E+Yat7KkWmGPl4dQJCxGNtIOxt66I78v/G
 fyNIGYnC
 Y8z4dZmbf/R7yvQoX6kbFNsflx+Gt9hPy3eKJFPluM1o9uqcy1jzhNMCIviiHXuKnJ5gyu6/C+wgSVu99o5quUv7qhXY8hTSkP/2lqXJ7IISwRkZ1mIf76ZiDcc0EL15X5dnu3btRhxBL1ZDgxhi27IO8ZrUhdBF85CFoXciy1T2+I0m05kwBzulr594kemLerRvxouy9cJVbUGfjQVqb3EV7iLXCmz8xjmBTGCND+PIW/n3zfDG3ONP/ypNT3TXSXfrHpmTgcADKi+9pPttttdNl+Y9SCGXRQITDIQr8aVl4E69eFN8XKeG61uFY3hZL/vodLzEUXddhw6vHrD/am1Odaj0M+q1JxtsOL1f2pvaZmIXYgClz+0JpHEZ+77zcN3kNo+CeaT5iCfjubwM9xqwEVf7cx9cTuiNh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 9:28=E2=80=AFAM <xu.xin16@zte.com.cn> wrote:
>
> From: xu xin <xu.xin16@zte.com.cn>
>
> mm_slot_lookup() and mm_slot_insert() are the only helpers in
> this header that are implemented as macros rather than static inline
> functions. This may look inconsistent without explanation.
>
> Explain they must be macros because hash_for_each_possible()
> needs the table as an array (for sizeof), not a pointer.
>
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>

Thanks!

Reviewed-by: Barry Song <baohua@kernel.org>

