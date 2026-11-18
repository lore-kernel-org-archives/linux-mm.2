Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D2C360A2606
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 16:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZVhHrd/s
Received: by kanga.kvack.org (Postfix)
	id 90C1F6B05B3; Wed, 18 Nov 2026 11:23:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E59A6B05B7; Wed, 18 Nov 2026 11:23:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D4166B05B9; Wed, 18 Nov 2026 11:23:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5193B6B05B3
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:23:40 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E3AB4807ED
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:23:39 +0000 (UTC)
X-FDA: 85448760558.01.3F950AF
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf02.hostedemail.com (Postfix) with ESMTP id F0EAD80004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:23:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="ZVhHrd/s";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795019018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZZL6VyLlbXFZof6UXR0IX4gvKyFon/J77+MT2G4Z9M0=;
	b=oTWIixZeN3IFOQCnJWcJkMg0uQPymRwKxI3t8g3zZb90RSG2q+6i3aRPqPSq4aYU9MXiIH
	I7Hr17TkKaEM28XFjhaRkW2RenWGjgMEKYvkktusbkF9Y8wAW+6woWVqiosnYvnhT/x9Rr
	hPmI3/XP9D6IOJo0wdrMhiPU9hB7lW4=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="ZVhHrd/s";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795019018;
	b=iR571B972edKIQoHmgQvWpkC97N8Jh3Y+DYkfkwKvSPxYb8+VRN9GkOScVxTQ4BzDl3kMR
	+Vr2d2PMDgl2MC8OKzGH3pNztK5GWmUpCk1ZJEM+9mTlvVZJEqc2H8c6v8uW6c1eCTDjKi
	938D4U2Kaiz+FJJIgum95DlK72i7224=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4b467581b98so14498705e9.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:23:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795019016; cv=none;
        d=google.com; s=arc-20260327;
        b=b0NmmZj6sHB2BuNsYvSYVVxkJ6LQbhYvL+KF4SVnRjxDChJ1JsNHWGyILUaEvKo+qN
         vnZ5g+4Sr2JvgSZfRSGJihq5zJs86Qx1ix92ZaFWh4SdKoiTj9/MC6k9Hwmgz5lapKqw
         4E9BTm5DfuLlvLRdIH/BSWODHgFITZZspoyFRMqBRUTsKvNen8A+wGbklEFAHns5sxm/
         L+XsjOYFDeYyHpRX/vAHXrAZ1IIQfONLPemZMCApMKzrcFo1F4qzXs0y3Mf7yE0ZNOr7
         qlaYdzYxYg+nIOUAoZkVWWduMo1Ma1XlMX9sHlkLm5xaggjKqz6t8u9jooRpETVGLXoe
         SBcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZZL6VyLlbXFZof6UXR0IX4gvKyFon/J77+MT2G4Z9M0=;
        fh=Rp7sJe7AtUGXifLYUbIip4qfTda60SDLQEt3KOT21Xk=;
        b=ewawfEkGq6CAAzvjM9M0HJ0MpqnWx1oxvHnyQETiUCpWyvi5dXReFBFLLkwTIgpp1G
         TGJBz6miaWtHbCTiP1q5L2SXIcrN+Sd7/hqadaqylTihFAIyvtYb2w8vhHubCP0rWdc8
         tZN1UFPAUPZ8Y0bRKAdN6/xXMmxxYyTCujTSb8/5YYDgs++aKfu2khAkspDZsWocb0bh
         NezEdOkrqrfWkZV+vEgFolKvrOBrymjaaQWvsBYkjHER/e3jtbpD0xd2LYOZ562rX9Bk
         Fcr/W+J3sn9s7kwaNXiBbLoF2Qbopqnj0Jb8zRAKxb8D0+WuUBZrpJvdAOonlHCYmu6L
         UgJw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795019016; x=1795623816; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZZL6VyLlbXFZof6UXR0IX4gvKyFon/J77+MT2G4Z9M0=;
        b=ZVhHrd/sW42jACxMUqmfCGhENQqmwpg/yloBreF2w/D6fxmhQh8Ka/9ut7X7EU0fvO
         gDIz1ryv+C5tPNJmDBZw/SvFwl3tXJYf2XtGWD4sz/zCBM88sS80JOmDwOiAFN1IBcBw
         F0fLlz3qTuFYMtF0mqcvwcM5xL9z8PZv70W3U+ZPqenA6WwGQMM+dML5KP87FfYBt5ms
         rD9LDOu2+Pr0r2qq6akywGBi3+1jFjCacqCtwU41pgcDGzQPo7aKYEq7rRKm5gbPSadC
         SeuEoyJ1es2lZekI1NBMoj7yT/dSw1ybkEMYc8etmtZBHDVFwtXbFIWUWvcwSlA5aRC+
         8vdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795019016; x=1795623816;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZZL6VyLlbXFZof6UXR0IX4gvKyFon/J77+MT2G4Z9M0=;
        b=TBuPT22kofmqKH7tNYFvznUZ7mOUmiHcw03pC4h38EGTsnjy5E2hb057XsqDICEYGM
         sf8rru5BpTKoJ51PVRJGzS6Pbei9gKAPyUtWMEgb9axnqgEm7EOg2ah4GDgiKtJDgly/
         DQmZreY7ab1ZVruFqQgnVWwZuOTCRtogW7Ot8fqu6prHBDJMbVbPO3MjxA6TR8JO3beQ
         Bj7UaTmSDNp4RBZnGwOIECfTad0yyU3sAhcwXXEnRmVVVQPbIl4FDh4xGXMOEXsHVfAN
         pI7tveUDe0e7BBx5IyI0vI8+w1N7v0dgGMpGaPf6OlS1L7c7gwFQf/vO3Nqdh0YEkgCo
         sk7w==
X-Forwarded-Encrypted: i=1; AL+hErE0nV75whVgonTi3GgckOEKzE4IDA5Zi0eIHVIDoFV3z7drc/wT9ejnQRsIMYVHnVbC6aPgjrvITA==@kvack.org
X-Gm-Message-State: APuU4Z8GG1zOGwxGLKnmIeH+zpHtcWkSJfCaDeRldp+OZMF2ZD2PpIul
	pV+FJ1DqoSchQKei2rxGb/uVr30ZlYcb/elyck8ieJXE4jGqRjp0qMUAhCiddG6mBIXxbUPAMN2
	scLSZPMNo+z/uYPooXGWiU/ZOFC8skco=
X-Gm-Gg: AYBFou0D22I0lWZIafsBo/YhnW7p58u3tfj5Nc6hHezit48YZnhsWdoliodjWsvRL9s
	XpSUKMZ6Mqu2Hn+KbKGcTyPG8i4ckqNa/0QlGZOxBpM7ih/sD9Hc3bD26MzBK723bYa5y4d8Dx8
	3boFUEsfDswVoo1ONGhPQLAdxy+z/AlnuEa1C+I+ilT0AjhpAbfatVYA2UU1xVnNzPnM6J6eSr9
	ADht4plTU5WmL/MHny7+HYJx71UwkfZwTXBv8pgOpsO0UZbqQlLsZoQBw+rvtFVKc/YwusCsDCg
	n7wqD3QG7zMDi+QGJrv9Rxoa3l1r+KoMR8b+AV43gkb3eoG6xYe+YxzIgocqXqO34pYFkMFdvEh
	ggYDsesRBbc5bXQsBF8oj1qCZOVDw3rDHCo4x5ZJ8t3flFn1tPEoOuoA3pOtP3cNy9PcPsFX/Oc
	Pd390M4dk600PIaS8N6draNnVbb+hWpTxcr/Wc9Xbxd2FufhDksLolPto=
X-Received: by 2002:a05:600c:524a:b0:4a1:cd83:b23e with SMTP id
 5b1f17b1804b1-4bb7d57f5ccmr65127875e9.0.1795019016429; Wed, 18 Nov 2026
 08:23:36 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261117-unused-sym-mm-v2-0-2f845e94dd50@amd.com> <20261117-unused-sym-mm-v2-3-2f845e94dd50@amd.com>
In-Reply-To: <20261117-unused-sym-mm-v2-3-2f845e94dd50@amd.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 18 Nov 2026 08:23:24 -0800
X-Gm-Features: Aa3M54o1d3r4VOyC2nXueP0BXfHMpFVW1L51WNF9Ut6r4bdATy19jLSCJyr3yhE
Message-ID: <CAKEwX=N5v3Kyarttmxfe9TRh-mf44hx2kqam0eFzg1KYQcaEgQ@mail.gmail.com>
Subject: Re: [PATCH mm-new v2 3/5] mm/swap: remove unused folio_to_swp_tb()
To: Shivank Garg <shivankg@amd.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: F0EAD80004
X-Rspam-User: 
X-Stat-Signature: tyjwzkepyg98d3xwymjs4rp9wzu7yyx8
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795019017-474493
X-HE-Meta: U2FsdGVkX1/yiqPDMGUTndeV0MEQZ0v1ZtI1t5LAmLPr9fpHGPmtDQcbD8P/F0IhWnds9fIzMDUMhYQCT3CCTJacKdUVUJ75jwLR+Ah2G9+m7E+nKlDrtTbq69L4yPv79Ws0bx2FHaOHU3/SnWKgEcSgFqe9khTrhb1jLFuWqFjAomi7/LxGM3sp1FbMK4nhsMlNDdqQTdJ/EEFLe/Ks4Bje9hJljymR3IbZon6evTDuZ+mSzPRlOU5KSoxcqsx+D3tuOsJiJFaeNPG5wc4qkk5Jx10xUpFRVVynKIIIe8qohTnwUuv3SAUqUWRebK3G480PDm4cccgBNfQBKngMt+bwaSSLVvzJBwy8w7WuqaP12697Is7Eldq5jNszgfYWBBT9LFCGvBf+PnM/ohUzb77UuG4AeRyoopiRZ7I4tG/BZu5k7dg1wa7OKiTQZDdxwz64KnrmsUa8fKugos7xBod4KyIHNNspK+lZAWxvCF5wBF7ELAebtbWKFocym7Fzt3ZNFYnT0tSYpGy8xT1TMuEL9FaS54pU03EvQad7dZ0tduascRmJEIdjSdLmuzTnkFhJANYBrhENuO4QP2mD0fZtC6uj4Vfz6/3GLwoLYELIkDBXtI2BB6Y2lHej/p3NGA1Wi9WHZchYQw8lPX0/Rt0KDvjajyWYRAy2sHNvoWJIz/glNQWAgKrZM36CfG5e4O7+PQhahNoptbof4UX4gK7IZznEx4v5NorZYhzyhuonj97Eu/ZcteXfPUq/qRq8gAsa1IIxrz3J8OtJ06SJJcPWlkq+vF3z3rg5nf8nRAVvDovv3uQlReRJVlJNgKK/OLefCvuKcUWrK/Rpa9oOxnOyPPGxab8pdAl+xeyOn1s9clF64bG3p2IT3ri/3va6Kt8lw+aCKasy3Rx3EoWgnUA05oPwA90q7/dutAP8gPjEYvuuzC+pFd/4WURtfhkFRAWNxpb03g8e/qXidyX
 m8zLxrM/
 gd6gxVPUolazWIupdRhPfSdux4JqbS3JlfDHbwuFFMozqluHGx1XlEZsVTH0thxBIEH9ULBNoEVc9LYET4IFGViWGPBm3ailxuTtV4RhoOKJH7DtdnsWhXwiJDM+lmP31Y0RjO2SFptADxfygT4zl3Oml2hJMAvbtojxCvATg2Cd3ugTkvU1WGBv559ApQ1VZQmkM0CYdSpHaGSPeDruDA7XzbI/txd+PiFQAHU5dvuoQXbplnEb0YKzcJKUoFWvdV1jrmiruhkAykPctwuHq0EgSFLnA7P3QYExnRUjK8w723nNkQNt8jZdwFnb7Q41FloqRmMIBr+3nVa2feH+yiZQh9GZCyFnPwVNu6hP03AARyQ2mxcZzCyntvtqZlkK2nTgAJqk3hj7Svwboa2Ry7nnjRz5DHZkdfduQkADUdv4STW0WeADSnw443uijJjEA9CwvSPB6t7po4nujOwIlsC314EBFlC1DWozU4zDa2x7YhMyIZ2W+N+HlpVrOEbh92RfVVlE/SaoOqf0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 11:17=E2=80=AFPM Shivank Garg <shivankg@amd.com> wr=
ote:
>
> Its last users were removed in commit 0d6af9bcf383 ("mm, swap: use the
> swap table to track the swap count").
>
> Signed-off-by: Shivank Garg <shivankg@amd.com>

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

