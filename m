Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EAA4606A337
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 04:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=UcSQVPsb
Received: by kanga.kvack.org (Postfix)
	id 1ADE66B05B0; Sun, 25 Oct 2026 00:04:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 186396B05B1; Sun, 25 Oct 2026 00:04:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 073BB6B05B2; Sun, 25 Oct 2026 00:04:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF01D6B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 00:04:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5021D1A0533
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 04:04:04 +0000 (UTC)
X-FDA: 85359805608.07.37017A4
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id 79A2B160003
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 04:04:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UcSQVPsb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792901042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gId09eW4/Psy0JauoROKgf712hQDkeOhkjrKn0dSNTQ=;
	b=4tLK1R9xDus/PkX1xVi9fBsrRNsY+Q7bsPbXX4gHJVio4G1YKMkjybxUwn4zwd4RhvhcCJ
	EihDbuLWAS22UJuKl2BW7FkvxjIXnbd2G/9vyghV0zaV1vspUmuozwka8QYqKYSjmtxvCW
	DXusdT8u4LMpOnxqfQ7LzydBy5243pU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UcSQVPsb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792901042;
	b=z2ghKdep6mQENj5rz/5AhNAP2/RDU+1kn0vB5UUIsyP3kOU9emmmzGp+SrrM3+VdM6/CpL
	hIgsruwCfDwMLdQnDYi2M4ctR2qM2cdVW9XYVum6D1cm561QEOLwPp+HuB0DrNtJA0OeCq
	BmzKxU3QmudZbJG9lbbx5UDnzBk+PNQ=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3aded3c6103so362120a91.0
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 21:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792901041; x=1793505841; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:from
         :subject:cc:to:message-id:date:content-type:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gId09eW4/Psy0JauoROKgf712hQDkeOhkjrKn0dSNTQ=;
        b=UcSQVPsb6suQVj/QaoIzBA6uoAwFSrVGoNew8wJ9mMD003IQ4vTL8d4HYfb+4+/4Cq
         XanZ+UxJI7qkDAb4C+Zv4xrEVP6iJnE268V3DDGTu5xpnzRTnTZ1Ryj32IgV/Qi7SJ3t
         nimurpJXp/7OgJz9ib6WkrJcU4aNqht+vNIeFNVuRuaCdDIEcN7TsacqV+NIbfK66yrx
         +6xUFdwuwMDw2gAE8snRYwO5ccaDoHVXj1f9JLLz64AJJUr3Tut6QIzb+HDEy3R2CMLu
         v1ucYXUblEdow9nxboMNQwVTEK9kl73xKnrJGuRi6pCkdJ+fSU+7+aN6I6vuHdySGov6
         g2jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792901041; x=1793505841;
        h=mime-version:content-transfer-encoding:references:in-reply-to:from
         :subject:cc:to:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gId09eW4/Psy0JauoROKgf712hQDkeOhkjrKn0dSNTQ=;
        b=REvciEFkG4pAycNHtvcxhaMWsdQ9AGRsF5Ba4i/CbDsczaYDw01zcSqnRA6ldofnch
         fmlSUB8AXu99v1L6kOVnusXFxmSYPsyyiD+4zjXumDasyXuvq+zARBmUIXUDNk7UK4/l
         m1R8wSx5m4g7MAlmrd7trWhSIOmjXOpjKoV97yAaVoXyDrZqdHmj82S7++Ah//QvHm61
         DXAcYNXGbRZX89ajl/X6x2ol1udA2XcGsx0k3xebdGczXVot/bxSdMYtzOaNvtyMvHT/
         1P5QljMbVGIG7rXsu2AYV4h2Kzez1Kz5zt6FnDlOat+e+6Qe3wH0zaFcxgnHRwKyXBFP
         dkGQ==
X-Forwarded-Encrypted: i=1; AKwUvBy7ltY2/8jxYMpPBPAtRfDvt3c+YZWwcsP/aWbTwTQiTvkIWsQLarIkV8m8VhhCA7V2rGu+QTpiJw==@kvack.org
X-Gm-Message-State: AFq9FYKWGNatXLgpkfM8Aqdug6lMJDzgCr3sZeCb3rOrOc2+9jqa9NPT
	rz8DkM9HENqS8ulpGgSwTE0bhxZtjoudfuuVmC8A7dcXQZ31nGw7FRHU
X-Gm-Gg: AYBFou235KUREkHpRRBwkmLlXLw/LqyBnEi7xnp+0oUw8RVTHGrPxHXhfFIac+9FXQv
	m7OugET5S5SguGm7JZ3zsvDAMYTtqrmclMty6w+IxO5guWoa796fmAjn7BFlN7HZY/ZPqCV/QAo
	nLFeXbllIKyFzy92AAmg5q3D1U9VB4NqyZubsNUfkb1AZprY+bOUDU8QeouIMOgqppmM/2sIXVv
	0VQIkj3llbzd8maKiLK6gpkKePju3gB6jhmPjeRiVJtYUZjFuUhBp5+Ad/3vKfGebizRJGzZVYy
	jWIKhRXfpcPXFFdKqBwftunpelXHZZbdB45l7gbLj+xN1SNg7rEclfDpScmHszfD1dMHS+Xs+SF
	OAJxYUKrE36vt9NYCh4pbNj7wJoKL/SxytBzWK7IXYKxxNKUdMsa/Q7A2K9eHIeCbhQPqS0B9jE
	eBKZ65fkvOkVixnWE7YL5R1dtWKdGKskhUtO/v4juG7iq1VHuiIOcDRU2zct/10vF14O+4Amm85
	O9LZxdpLz2nSLLwyTNv4mR3RpiawROIkGR2mIDmzM34jXA7s8xxV7ObHwLd23DlA0z+H5pJYjwV
	n4Z59TySfXfnXe40tbcniF7TrqhlMcvmUwbLi6EUxVHhX7TW6//ZVbkyzSSH
X-Received: by 2002:a17:90b:4b05:b0:3ac:86a0:5764 with SMTP id 98e67ed59e1d1-3adeb197eafmr2849652a91.64.1792901041321;
        Sat, 24 Oct 2026 21:04:01 -0700 (PDT)
Received: from localhost ([153.61.198.240])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adebb1e37esm2940351a91.4.2026.10.24.21.04.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Oct 2026 21:04:00 -0700 (PDT)
Content-Type: text/plain; charset=UTF-8
Date: Sun, 25 Oct 2026 04:04:00 +0000
Message-Id: <DMDMDJ9IQ9DC.2I7GCTCJYZ68B@gmail.com>
To: "zhen.ni" <zhen.ni@easystack.cn>, <daniel@iogearbox.net>,
 <andrii@kernel.org>, <eddyz87@gmail.com>, <memxor@gmail.com>,
 <martin.lau@linux.dev>, <song@kernel.org>, <yonghong.song@linux.dev>,
 <jolsa@kernel.org>, <emil@etsalapatis.com>, <ihor.solodrai@linux.dev>,
 <akpm@linux-foundation.org>, <vbabka@kernel.org>, <surenb@google.com>,
 <mhocko@suse.com>, <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>,
 <ziy@nvidia.com>, <shuah@kernel.org>
Cc: <bpf@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/7] mm/page_owner: add bpf_iter and kfuncs
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
In-Reply-To: <7f9a9da5-1250-4be3-bfa2-70e4b6051197@easystack.cn>
References: <20261021112437.1799213-1-zhen.ni@easystack.cn> <DMAURQCKK6CG.10CZ7MFXGJO3V@gmail.com> <d39db4fb-e511-440e-9065-72c34a1a295a@easystack.cn> <DMCCBEPCIWH0.2JEDKE64WPJRQ@gmail.com> <06925440-8df8-4f2e-aea0-ede1a98435fa@easystack.cn> <DMDAZW82I9LT.3FNX2WI80GNE2@gmail.com> <7f9a9da5-1250-4be3-bfa2-70e4b6051197@easystack.cn>
X-Mailer: mkdraft (claude review draft; edit before sending)
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 79A2B160003
X-Stat-Signature: a548xmeuh7iqatfjdpq3hsjghfth5dfr
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792901042-315473
X-HE-Meta: U2FsdGVkX1/dcRRAvuTNtFSUmKrVaYb3Rjr4gJqjMP/1uHiS/GC8lONTvIiDfupYqCB9Ip0zKwzv8Le8GYhwFT00YF/2DGP0BTw3vmHIqul//m2s4QkiTEbJgEGhHNQ9kff5zGooRuEQf4H+ttuKo8uv35lTRGISeuSkHHSp8vepLgtnK5k0AthwjlL0QU/JNYzjBOIuHPqHRcHqS0kMjwQKJ7dcjO0sRkF/RXScQ8Yna+zQBIEzOeleuV4YuoL0hqzUUxU2Z71HNcQa2QxEUHQ+nlzSGCQdgZXJlk9O06/sFbKkEQwm15ok/xVkpBZr8oPmJnP4cPRNnMtYRuJTRv7/k3K+yxcPUoO9KEYMYCkE2yJKfSsbxBGEZwjWio9NBtAqJdmf6nCozHJ00WFA7MzjaVC2RlYcLqka5acYq64X3zfbOz+tu/3dS8lD1MiLOLrdoXi8I3SoQ2yyiBhppg/UVXyIXxE8NiwEQRSe7jqXyYCcAom/f5sHdZ3W0x0dxm+lHQkXSlWVjMtkXnkCNSTugs4gbNwdSzaggx5BWrYq7b+tq9yRTEqs5Ct4uF+kYH6C9zGYiSVeQugfw6jt7dk1y8HuBN4VWNoGBLHBamJKO5nf1FSyzUMR5UyKJ224CMaMuKGgQ3Sz2Jd/KHchaBaYQAj1amaqno5/Z2P/dcZU9F4xCYusUzxf91TVybnj62ywOyUbSWlJR0pHqx7CppkhyDofVG/R3mjlWrggvEJer5tBjkVoS1//xMw83WHXG6Um8kTSL+GCpNnXk4nMswPwsb3Pq1BQz7zlxi/Yr+TDon3+KSfC83ckvMMnlhQqC3GqXbNpN7cqeLTCwTXHbM5yMi0wkG3THHjrZJOKt84V0tyW2Z8uEMGzvl1EkSZdb4P0jmuRYtxSttv/xcUtMKB2Ejcx9mY5EyT5NZwix72RunFssKOjjX8jtOVnc0CyUG5CNs6ffSjmHIKhu6U
 Qy/xoo+p
 DT+tSfhukP8zZ2wvqQoufk/9FDmtul70je2tds4aVlqfmis0i2ReApQ7HBdv/4GCywzbWXKrz7puq9MiwdiYwcJuFTjkb5Sa4kpUHaF2PQDp/fFpfsR9oengpjgApFgz34cfyDFE3DDYQUyoUjlFm4JMw5U2Enm2LdXEWaopIjL9ju6G57QCHwz6+1B5GYZCu2jTMjbpw/NJWc49/dicV/gPQhCuSo/jkZjzCuFky91NKI0lnGprJvXGktL/gjOfMZDVsGWfkw2nUXu6rTAIO2+snXhWcwCdq7h4J2YonrgqHM9IS2scCG72sCJxNe0H2Zt5XzzMAhCVtWNZ+Dt4BNtlcuDTf7Xg7v2b8reipxthVi1De+aB5uCTrIX3N1oGMyJFeripQCFrVrTyxxGFbwDoSdgm1/y+HWs2PqlC6npa9D4hcakzXWEbenJsNIPy6Jfp8m9XUdtwoUuTVzBDnDhCOgk+ToOG+H3G4rar6EgbcIiAcDMEVbSpXu+lk2lx9RmhYoSOnz3UkLnKx8Q5jiwlQKNa4db2ruFd6iWs2CQMM0C8I5KpNZcXlV2YweZSISzL5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 24, 2026 at 07:16 PM zhen.ni <zhen.ni@easystack.cn> wrote:
> Feasibility isn't in question. The question is whether we want every
> prog writer to reinvent this traversal plumbing, or let the kernel do
> what iterators are designed for.

What the prog and user space can do on their own stays out of
the kernel. The reason for the nack is the same as before.

I'm done with this thread and all of your future patches.
It's auto NACK for all of them. Pls carry it forward,
so no one in the kernel community wastes time on this anymore.

pw-bot: cr

