Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7FC3CDB466
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 00:52:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51DA16B0088; Mon, 22 Jun 2026 20:52:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CE976B008A; Mon, 22 Jun 2026 20:52:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BE4B6B008C; Mon, 22 Jun 2026 20:52:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 129976B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 20:52:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7E08CA032B
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:52:41 +0000 (UTC)
X-FDA: 84909352122.24.CAD28A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8DEBD1C0003
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:52:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lRtWoNXC;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782175959;
	b=mM4HZEww6SQl6PK8Io5UH/tX1RnzNL6E4FN5HgGMsigs/EDQa04mxQcI3mDBsbSp6uu2MP
	yWRCYMkyOQGThqHWlmQM/2UVxQ+M+TqmS0kKiFDIip5qPBjXg308TQKaE5iR3Su6EFd4in
	y/7lJBa825592F8d/CTOL6TI2tfptls=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782175959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z9NU2d/AcUsyLIc4r85Vm98eINz8OnEvuXHfSGmJnhs=;
	b=qsQ9QCRqljIIEzOPN0gI6jhNdXjO9nh1SWZFoFkBwqxj6gS3H67Uu509Sx+kWlo90Zokpd
	zMgMyxw4I4k9dM+H2wNcd+mVbRbFMmR1GDTdJ2XAo+4QW1/9v1U6lhh0R7Zt4kygoZ8I/m
	KJsBbnBLY6nMljAdzWtU9eU9Vkw7KKQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lRtWoNXC;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 82DA8443E0
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616DE1F00A3D
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782175958;
	bh=z9NU2d/AcUsyLIc4r85Vm98eINz8OnEvuXHfSGmJnhs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=lRtWoNXCIytgEluIjO82n8UAvN0wGygNtnEAvttR/hSiswMqQjp7pwPjcfPjs8xKo
	 wZluQt8KBgZIDPPc6IXP5auCsO5Ej64SGxGl6kqKcB+aEjmwA7XD6fw+6h1f9Ou19u
	 ioT+S6MCc8yhiqZ3AglqJjqS/5I4vzrknWzn68Kpp5LGHZg08ODMzOiMdtM3bWKMWu
	 W2uSKluaBt/t/hdC5n69HFJgv8TkuwxAp7Faygkfje4N7PjFo5P3PgZzH5uhwcvXry
	 2sHY3yySvOpSMHNRx4y9xsNGtyhZN5My60XfOijkybAFeTM3PrDh+0EQ1loQyLQljY
	 k1A5LMCCX/tfA==
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-9203654905eso292884385a.0
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 17:52:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/63xC/fBp59ItNrx/mFYk+MinqBK6c4MEsz395aqfJx47MH7UzFCu+q8W3UB9Kvz1E4dF9P1+bAA==@kvack.org
X-Gm-Message-State: AOJu0YwWUTW8YUyk+7I17E59TdrLX6+z9CXZSe+PAWDVkAn87w1lnF8H
	Ob/JOnCerQoRO6q78Jc9oQ2pyiLhBnjUF+NnZVaCzcr1QAiLhE8H4RDhuSgCo5+f6IhRlSlzeCF
	nGBm4YxQuPeTxXODfiaF4osILexusQKc=
X-Received: by 2002:a05:620a:44d1:b0:915:d5cd:8ce3 with SMTP id
 af79cd13be357-921d104344cmr1820893685a.14.1782175957810; Mon, 22 Jun 2026
 17:52:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260616031309.3036234-1-haowenchao22@gmail.com> <20260616031309.3036234-4-haowenchao22@gmail.com>
In-Reply-To: <20260616031309.3036234-4-haowenchao22@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 23 Jun 2026 08:52:26 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w8EFJocq_uYbV=V3VPgNFuhG3vOSzFB7YWVfeJ_KjMJA@mail.gmail.com>
X-Gm-Features: AVVi8Ccyb0-O0obHy_K2mWq1b9g9RLDiu7ddoTH5LXGVpd8yDFRcLyt6ewRJwyo
Message-ID: <CAGsJ_4w8EFJocq_uYbV=V3VPgNFuhG3vOSzFB7YWVfeJ_KjMJA@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] mm/zsmalloc: drop class lock before freeing zspage
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Nhat Pham <nphamcs@gmail.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Xueyuan Chen <xueyuan.chen21@gmail.com>, 
	Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7mycaz5now6jop9h4dfrgfqr5rpsq913
X-Rspamd-Queue-Id: 8DEBD1C0003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782175959-114703
X-HE-Meta: U2FsdGVkX1/0Ka2XIamggK/P6mepomTyMihoYr+ZfeNKeYSA8PCzzmouuWHMguFMn+xVOBtOaVBjCaHto8Z/O5z3d77nTuxO+tpQzY8larneQibn6xmOUYr+vu2L0NcPZeKuMHruHSgwrHJzHr/VEAYtW0V5aiFD6HHW/jzpE6QqfvPNK6VX3VX4qhWVSlLcJ9mVuWgCWsxn4pEH89I4IPe3l2kwfNalS7zkyogIIcE5voK5U5zECzKTgNFFXAE+juM6l1Jf91xfkzLDwlzuKRa4SIxt0HE0MJUE9DivuJ5tXdJ1k7Kt39f5bn3C6OatYwbyjhg3da/7nNnabvy5TLt7CYPfLQzVPoVeKeMe/L9sRqcPRejdNU+qTipnZ61qwy/STscQ0FE2ThmtoBXWfARMB2ArFr2xnek3Wtc+p96PFQFtrauTCRojnYA4tCsyoGfNV9PMObMszRWM9Kgxy+8C/iEXO8wGXoIU9w1VQyWGcwCQaXQDDe5Psb9Zy8mekJL1JMwwAf91ahO2oenlogIoxmu64heOFOLe5Mwg1gYgWT+mWYZzbElzDBik0xwivusSpeJSaOL9SeqwSFhQeD1i4ESewtruP5ZihsaiyTDdBmD0ONzadIwxNlWQVH0JqESlqETNJvyPqDim8I/F5hOUG6TFuMTEafyAgJA3lfCdTZrECmvzO64EHG5Aj1jayKx3EpbJJkGl+LKCpIHcDc/Kdi7/wuTSA5Kd6z1O7Nv8EAy7kxwW6ERDiqhEBjjOIF4I4eqNZYVdPupIBmP9kScNSk/WLRmGUPvBpBuiz+Tn9Ks80TeLBlltz90Y5YjLb5CyoxlvXqdeprkdBUqNaKIWymL8Ovh6RpGSJhiucUOk//PD1OQ9YLYJ3wkX1PyxYXZJTjpZZTJUD+/7jZb0QT63AMcVYK6D0T3dDMKqbXP+9aNMGqMslCXZ+yhoXMX+RIwfYidGrNc7c3DmCvL
 EP1R+Sl5
 04sdGwt5Tj3hbF2BaVeIZZTCGKWVcN/BceIR/gDRyTMafetzNhRgMVQZl7o4GZx6kzpTOYWJ50w2nq/kUdtlVC40yAr/7i78iwJwpL5K+CyPdZNpaGX+IeL7e1dVTaoLQvDYXVpwyHs5ZPglJyTUoumSQcaaIOq0AQL8cjm+0R6vzsY/G4YbkGm642+Qv7p491szNdlDaY8Q0ukuui0XMgJjitaGOnHLQHZYYRn1KT0drZL5YnlGk2vcxQgxfhh/paBRHgJVY+VT/OWJnWWaX/vglLOG4h1yLmrGO7qD4jlAo2uhpF086e8LmCp3CdVtCKu7v+qURNcdPjBE2ZqPgG/NcO+2tMKWHXS3oPz4bHnJ2yhV5ex0+0HJVOcw0CpO0XlIYdhZ0EHflPnF7mRLea2YyJMBMapw8U2ZUvoK93DvB1e0FavQQZvKa8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 11:13=E2=80=AFAM Wenchao Hao <haowenchao22@gmail.co=
m> wrote:
>
> From: Xueyuan Chen <xueyuan.chen21@gmail.com>
>
> Currently in zs_free(), the class->lock is held until the zspage is
> completely freed and the counters are updated. However, freeing pages
> back to the buddy allocator requires acquiring the zone lock.
>
> Under heavy memory pressure, zone lock contention can be severe. When
> this happens, the CPU holding the class->lock will stall waiting for
> the zone lock, thereby blocking all other CPUs attempting to acquire
> the same class->lock.
>
> This patch shrinks the critical section of the class->lock to reduce
> lock contention. By moving the actual page freeing process outside the
> class->lock, we can improve the concurrency performance of zs_free().
>
> Testing on the RADXA O6 platform shows that with 12 CPUs concurrently
> performing zs_free() operations, the execution time is reduced by 20%.
>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>

Reviewed-by: Barry Song <baohua@kernel.org>

