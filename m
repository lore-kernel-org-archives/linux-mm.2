Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B625EFD375C
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 18:46:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E61B16B0088; Wed, 25 Feb 2026 13:46:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0FF26B0089; Wed, 25 Feb 2026 13:46:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE82B6B008A; Wed, 25 Feb 2026 13:46:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BDA176B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:46:51 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 722EAC267A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:46:51 +0000 (UTC)
X-FDA: 84483860622.25.CC16F76
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf11.hostedemail.com (Postfix) with ESMTP id A311C40006
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:46:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=atU1bpdR;
	spf=pass (imf11.hostedemail.com: domain of avagin@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=avagin@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772045209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0N6PIEQkF9K4Mf3+vZgb/e0cIuHyJAzBkOn2Am3gQxw=;
	b=lkH+Xz1BE4aNKEoQI0LL61Vnatbgn3V5zVS0aQOpx0PS1OX5jh4GXKFee8S8rCOO+rjTf1
	wq70/vOeJa++ZUnFZ5aVs0GSePzSiu50qGbUI4uHidpaeuSsEMxYClOUx6ND9QkUCTPjcP
	SuVjuHbdktXdhA/OiyCozH/jHhiM8pI=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=atU1bpdR;
	spf=pass (imf11.hostedemail.com: domain of avagin@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=avagin@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772045209; a=rsa-sha256;
	cv=pass;
	b=Dy5ouUjUr4hNnwu2DhItaGOVqubREl/dAzfmuMc+6Af+tWS6SxhKufnhi0aIcYEb7fgPQf
	BTNUsmb27ihS2aFNAvcRrRh+j1zOVKKKKVAux1TcWiacnj3FVjPL1HGwkwd4oWOXipoAEw
	EIo9TXo3BOzATWJOyiPgRNHhd712WFc=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5069a785ed2so43071cf.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 10:46:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772045209; cv=none;
        d=google.com; s=arc-20240605;
        b=bBZf18A04TuXP2dC+vYQ+MJ5eJzaURDeL8nOovmNLJj5sW482SmLfhvMbJQ5L5yREg
         g1jNBH26t5m+cF1FTFU1JTBjsrF3iso7UrMCg7KZ2OlrLWqNufuDZphUedAKUuTHznl8
         sdcULdWE/cDx7xkeOh0jc2wBPDNEenkfjTG2iZojdWmA17JWxHbsvC09ghDXN+7AIWAs
         K9tfWQaa8CFffPPOi6bMFLCU1mlr5cWtTqsGIbjVMrgYHBzWvoVD/MEGOPU6N85lw6Oh
         FjkZGZsuzq0VIWSL8OPpEJ702BMrIwRmTsYLuLKKn128c0JKE+vOcxiyVWZn4zvZoSsf
         X4nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0N6PIEQkF9K4Mf3+vZgb/e0cIuHyJAzBkOn2Am3gQxw=;
        fh=2BdXNH3uLdVqkyH3NInuhc9+p+3jEsabbB9yxsZaK80=;
        b=BahWmKbq+17RerwrziI8E0GgsrFVQ1z8NXuL6ASrG2oIwb1zNaoR0E/Hxr73oiXheA
         ZlOffGPnyjyctr+KGOcP4z6mXkiipF0O1ENXyMDKlLvy+ByrwOOBhI6PvSDSqhKqN6dT
         s/g2P8ZQDUBv4OuL7oJI/X6ZycaKm5xpUfrk55BCEq+HQH+Os4a5LiiVUoD+LLbs3OhI
         z2gx2UQUVtFsfEdXRsdI1k8+4bjJQ96lg1G3C5s8hUWum85kghmUfov29GRta/hd/7W6
         FpJ7GGBVwMyJjkgKy8dvF3PjPSoVFNXU5i7b9xMzQdxaq5UINCSmSobCXNbB1yXP2Hl9
         YcEA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772045209; x=1772650009; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0N6PIEQkF9K4Mf3+vZgb/e0cIuHyJAzBkOn2Am3gQxw=;
        b=atU1bpdRxoW+U0L/R1N3HnZBCHXw2/vDnOzkMhtVOdfPnsJ3amCXTryws2nRgjwIqE
         QtHVujpdg0X7zCEtQAqENHNO1KI5sQfINJIrnuJiUWkIWCvTi4qwpJSLNGIl2ImSqZM1
         F8hT+zI/WKDxrFEN2cQwlHF7Jdt1/u8mAfLKCDwn+rGppelxkd5CWyORc6uf5xch0cq/
         l/7HFIIEkdInQIwaKCl7wbpgC0a0S+ZvNbjNxfPZsq+XkYd+pdWNr5EE6aXSAeQjM6sS
         vpkVtoKv1oM3o7spVZ5YyUwlKPTlw/FTKasXCXKVl8ZCR3HH8FAj/aPQZ1xReihJDRPv
         qO7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772045209; x=1772650009;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0N6PIEQkF9K4Mf3+vZgb/e0cIuHyJAzBkOn2Am3gQxw=;
        b=AUOTzSUNnfbmc2E7nYIoM1AIBsL88u3CeGts16LRppAnCWUOSiE4CmqKC//pymutKZ
         onGP4a8Y/YAj7eJOqJUyUQn31djuES06Vwdfvay+1C2TnF9BYyrqU+UyDdOS0f1n4ZpI
         VmX54+Z6shKvEhjTYuZoXCUJlj14zEwnXpKrgtb71yx6uXCDMUZxcuEldeIK2VXDD2Dq
         YCoaTCTP8RZvtJ8HN3AhTJqNvGwt81qPhhJCjoFspHF0JkURJb6zN18iDv8I1yRBY0Cl
         M8WJfr5hIJJpoQgvzE2fEbdYiVswxoCIeVu/81B5h9rcEX1YbWDtL08Cdew0V+t8NboP
         5nDA==
X-Forwarded-Encrypted: i=1; AJvYcCWQgf7Yfajaz3NiAb//6bh2q3EBMoA78UbuRsBL+tw3a218tJewy4pVEBNaXWhGUFHdwAjlCrL36A==@kvack.org
X-Gm-Message-State: AOJu0YzWE2CvYxfIMJF7FIrUe6ROBh6it2IJQqhEKeyCDX3gQJaZqFnL
	bXL8TU7aK3lAJGOKQyFrggQhUtsn+R/dIdDkReFFFoFNtRBQPMwLXZZUHD6dAKiE6xVMCUU7xvo
	Rqe6G6fTY1i+2yEx6PsiqWfVr2Md6yjsukTWiCV/v
X-Gm-Gg: ATEYQzxSd35lceWkizCm4oLOyn74hwebj6ST7M2rFvzP0kSXMH7VBZZ/QmOPwIeR9Kx
	YeJRlf/wV0Y5HQfu9tiMXMHZ4PJzSGB/gOc1QanosqedVIMkB7OceOabAtk2aG9D1+O0kKYHF13
	ruzr8jApG1HciLNFjvIqnlFXoAgrGF8Q4Nh6ScqKVvbpS5pelLcpTEf+2VZKpd+aVQqMIUwFRw9
	dd3Vw2Asu+6XOsCIRbCMCj8cIQlKz3eWaLgUzKKvHnMbG4VDF1D6bt2QHxQCrtLQ1ATAGbtz8Jt
	OxaeJcuVF1Be6GC+ay4HZNgkoNDlApjpLl9X6w==
X-Received: by 2002:ac8:58c4:0:b0:506:a1b1:422d with SMTP id
 d75a77b69052e-507441e2f1dmr647121cf.14.1772045208089; Wed, 25 Feb 2026
 10:46:48 -0800 (PST)
MIME-Version: 1.0
References: <20260225133229.550302-1-ptikhomirov@virtuozzo.com> <20260225133229.550302-3-ptikhomirov@virtuozzo.com>
In-Reply-To: <20260225133229.550302-3-ptikhomirov@virtuozzo.com>
From: Andrei Vagin <avagin@google.com>
Date: Wed, 25 Feb 2026 10:46:35 -0800
X-Gm-Features: AaiRm50yP7U5Mblj8nExlDPbtbQY6Smjt4Ct49GvH3x6Zklgi4smtXG6r6gKV_U
Message-ID: <CAEWA0a5s5fvERdrk1mUAqo+VYimGty9=BU1DEmPHDugLcgPevQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] pid: check init is created first after idr alloc
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Christian Brauner <brauner@kernel.org>, Shuah Khan <shuah@kernel.org>, Kees Cook <kees@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Jan Kara <jack@suse.cz>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, 
	Kirill Tkhai <tkhai@ya.ru>, Alexander Mikhalitsyn <alexander@mihalicyn.com>, Adrian Reber <areber@redhat.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ucu6m4g5tig3ijru6imhkz71wp1x3r3f
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: A311C40006
X-HE-Tag: 1772045209-563598
X-HE-Meta: U2FsdGVkX1/9c5bpVffW4+bKuUrErbGkhuV5M0GAy3RktbvUbEEy0bPR6LC7XQC2Svp+FsUMT9l6AFAbvjcvRtwzU5VpAkFbdJMznoildPn2nIrmGvUY2c5zoQpxzOAYw5AT4Ak40UdMzMbsYdCfGSn48dpSSJxzwcJpqZWIm/eETb1E3ANSPIfoEM7j71OGe7YbfDAfEohUs5hSEyqwJ3rp6ohufJXNF193jwUy3i3hHmsIL0Yc4eN803k0U+R0aV0zodIuSzxbYghxiehtn3nI1IxB3W9DzvWWroh3w6JnhtZy/LYYvWwur4inMrHzWR1QzIlputRjP81s1mMOPMMtmHBE31lufLygonHtEXj0pAfHhmiEYfjLbFh2V1/yLUR7gM2zLNMezC8n+seSnIenRTujY1zqk2/fewkja0y/R7lEc6wa/CGv5ithmWWe1QQiTeHPlA0Ucf3SPPlq72My7OrlnJkg5KHJU+YxObXHMnNJ1QMJ2UE2Alyru6UNhLExGrZWyrbDmWdoVXM1ZmiOi6PKmNnsyULzVR/Z5pFJ4HUp0zZObWr4l8YoH9pueQXaPCrign3s/bitKpb4IxJKR0iR1Prlyy8zGsv3sRy6trbDkBA/7lT51i32gGChSISYaN3Y9VW+HRsM3DQtsy0k7pC7zfQBc+oAOkz7dcxSqysiM9rVqUc2XsAT8YyEdRcomPKCcYtaRtz9V/iPSRwvZOon+K5jKH2MjdPau5Ree8O8WQC2QmgoTZ6z6+Bx1bqYDU3mSQuBQS9r7dtlv1skRBaA+TXyt5hCbRbIc1Xy00hCsM34rc3PX7As3qVwNpS3YSmvFtRtd52GkGs6d9LrAIqB3phX5Dt0qfnpf96Fn+B5qDQuDS2kQn0dpp5pMAQGQDiuG9NaFFg/Yy33VMiFfLrWy6nvGgCYmrOrfmq9VJo4VwnLo1gBgSybwus9op1bmB0kyhM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 5:33=E2=80=AFAM Pavel Tikhomirov
<ptikhomirov@virtuozzo.com> wrote:
>
> This moves the condition (tid !=3D 1 && !tmp->child_reaper) to after idr
> alloc, so it not only covers that first process in pid namespace has pid
> 1 in case of clone3(set_tid) requesting wrong pid, but also if idr
> itself gives wrong pid for some reason.
>
> This could've been the case before this patch, when creating first
> process the alloc_pid()->pidfs_add_pid() code path fails, so that the
> idr->idr_next is non zero anymore and next process calling to
> alloc_pid(), will get 2 as a pid from idr_alloc_cyclic(). Though thanks
> to PIDNS_ADDING logic, free_pid() disables further pid allocation in
> this case and it does not lead to any real problem.
>
> Note: This is also a preparation for the next patch in the series, which
> will introduce an ability of creating init from the task different to
> the task which had created the pid namespace. Needed to make sure that
> init is always first, even in this new case.
>
> Suggested-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

Acked-by: Andrei Vagin <avagin@google.com>

Thanks,
Andrei

