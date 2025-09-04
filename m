Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53A71CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 08:54:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 991786B000D; Thu,  4 Sep 2025 04:54:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9426C6B000E; Thu,  4 Sep 2025 04:54:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8315E6B0010; Thu,  4 Sep 2025 04:54:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6B2806B000D
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 04:54:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9EB1C1A0A81
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 08:54:13 +0000 (UTC)
X-FDA: 83850955986.07.FC8DBFE
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf09.hostedemail.com (Postfix) with ESMTP id C2CFB140006
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 08:54:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3Ssz+FR6;
	spf=pass (imf09.hostedemail.com: domain of glider@google.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756976051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9VicjXT4pdNAgXdUSH6UsBDRLh+o/JYSTnI74S8PEYQ=;
	b=yPUELKoZsoBN0bkosOF8XwznIbJy7LTvSy+cqSTJJLPnc9V26qZhfz474vFlDgMQBPqIna
	NkWACLhvQt7ZV+9sDmeERGSfbVNs0oJwqKQm9FlLs2Var8W4QMVzdBbGPs5/TLQ7vNHSD6
	JFv+3myLz0hs1N+oABd/beJcq8suH0w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3Ssz+FR6;
	spf=pass (imf09.hostedemail.com: domain of glider@google.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756976051; a=rsa-sha256;
	cv=none;
	b=HDFle/mMDZH85ubBdAVtNakzsFFJYt6xGZg0zppe0W+UtGNMaD8qunVjRoQfmVdkBaiGMY
	pCd1TOlxIT9Gndsz2JZ7qWS8ryZMm4NkU4Hy5zxvNZM7VdYueZMSEe/ORkpTwiMkB+vOae
	wGyV0ws6DPA5zUws1fkbcImsGwpCto8=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-7220d7dea27so6086426d6.1
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 01:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756976051; x=1757580851; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9VicjXT4pdNAgXdUSH6UsBDRLh+o/JYSTnI74S8PEYQ=;
        b=3Ssz+FR6onoQWjyUdBzU0xBLWypd9JubdDpDwf/meQw/kKedeio7vA4OR/uFIp1vNk
         p+x2YeHlBhKY+kzxyFf9zBbbir8LkZo0ysNPBWr6I3ml+zbmRfMrtlWudSJbwsTqqfd0
         Ec9G+OR3kpL+enCKa8RO0v0Ts4pceMEkcoU0dlrIyHGWzkDAeMDAvyEfu12AE0E4krtm
         3WFtNzenvwPHUziCQJH3JU7HCYvepxftUZvvcaK1obMdpvDYDCnk0mt4eDWCHh0qxUMQ
         QXxbQojfdNaZKL69Yre7Awe2KnbABTJwTlbLovCJHjz6YIBGtmyJD3K1wGZ/jkTiIfJp
         kYaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756976051; x=1757580851;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9VicjXT4pdNAgXdUSH6UsBDRLh+o/JYSTnI74S8PEYQ=;
        b=vGMv9Z5bDADKjgIN8HvIxBGtN3pgZAxifC7+lUi/dVDw6t1d5XrrugRqEcCm5xQ/UY
         U3pFwrNJUiKCW5gYLeDEJ4Coy4Ph22ua1e6wcqvHhH7gXb4fBiVkG5Hrq9yoaFjpXwN4
         gb9spuriERcyDQ9NTKoMNPFzzviTnG5WzWcoCBeOgtkwPl5OO/WIJYi0PX1QF4BGhS4u
         9iObqYC/oNpI9XZDom5Hbe8ncHgHGo4/1pxTqptd70JrvcTpl/MKq6cwfTOK3JPygL+F
         /o3CslI7qP/qtXi1BZH1ZX0TA8C/UGxi2mOUWfe3GqPA2VGvHI98A9epvr+whiVoUOF4
         2Tjg==
X-Forwarded-Encrypted: i=1; AJvYcCUZheDJhC8K4DJA/ibcTdX8NpQqL65SIMrmevy+vMdtBvmIKnfn9c5bvh0nVCt9YkGnA81Hni/x9w==@kvack.org
X-Gm-Message-State: AOJu0YzFeqV+93CWIQcNOrShvc55TPpSclhNzV27lrnlZlaAq7T4FU4g
	2O8Mzd5nbGoVyo3/eIFA3Ww9yZhmER62YbspCvisT8+HQ9FrByXlx14S68tw/SwqN7x7Q5kMxvB
	kspGxIfim+ER2aQxgQPC9+wbsav7SUwDKsSFHO+9T
X-Gm-Gg: ASbGncv09UMSkSg9qPKp9YlkPbFt+uDcibMr4zryUu0WPAtiseHw+DSsCgPU4P8BSk6
	0/25BG4NFL5VM37rOMpt85jbQPKhoX+9wpANiaOH7CoLioct+ktEyotVLzVkf0zAA1vt8uLfex2
	A+kT2kuXENWBFVaMzsOIFnRC5GArkWdjPZmSRGft9QHgKKK5Cwf/ZHilyQ+5sTPGXvve72to7vk
	7UZXPPeyAj4jU1CXVp3OOWmm03Txl5kZ3Hhx45nDfY=
X-Google-Smtp-Source: AGHT+IGe+3QGfd9IKV2sPPBcSKIkB+warv0bCWnhX474CyKZjMxan/mTdhVbYwwEQVkV0lnKX5ceY3UjV6CSO+x3hLI=
X-Received: by 2002:a05:6214:19eb:b0:723:255a:9168 with SMTP id
 6a1803df08f44-7232569d525mr82498246d6.4.1756976050489; Thu, 04 Sep 2025
 01:54:10 -0700 (PDT)
MIME-Version: 1.0
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com> <20250901164212.460229-6-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250901164212.460229-6-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 4 Sep 2025 10:53:32 +0200
X-Gm-Features: Ac12FXzGXGcfd1LWU7AL2P0uHHVI9Cjfbatglasugt3XjpaIrqiLrO1UVJEntQs
Message-ID: <CAG_fn=VBbSqb07-pbbEw7F=SP5_t74Re7ki0+ZS=mBm2S9BehA@mail.gmail.com>
Subject: Re: [PATCH v2 RFC 5/7] kfuzztest: add ReST documentation
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, brendan.higgins@linux.dev, 
	davidgow@google.com, dvyukov@google.com, jannh@google.com, elver@google.com, 
	rmoar@google.com, shuah@kernel.org, tarasmadan@google.com, 
	kasan-dev@googlegroups.com, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, dhowells@redhat.com, 
	lukas@wunner.de, ignat@cloudflare.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8syj6xez9i1zxooq1am7zbptawb6fnzc
X-Rspam-User: 
X-Rspamd-Queue-Id: C2CFB140006
X-Rspamd-Server: rspam01
X-HE-Tag: 1756976051-547140
X-HE-Meta: U2FsdGVkX19x1NCInc5jFZEXTYBD6P0gGu7+StkgM1rqLqpas4kiw0QGZ1UFSrB19wE5TUBBUkPoVs7GLOjk48eELw/977RzynYt0oOM/snd0JHcch99jbxdjkIrtzqOYOFc9VL2CHAta2tmUX/ThUiiNrtAr4WdmRLSJtmcAxPlnFr04KEo3pqHqBw6pL+1LNEx9CzXwOaMb6PJXmeJSFBx99Gzs6Z/N7sCY0N6b3dWfRbj1abaHX11GtIBfVuwlrUGjUJiY2NXpU6QnwVGC37vVkpJleevrdJ5GwoRnN8NiiRCQF09L3jUl4rHtqxqeWnjdxgpUxnKBv4O8Kc0DMBtbetD4Gtbf/j6eE27YODokko2UmG7BLGZYhwCyG8HwKMXIn1TC/13t4dzKOA8No9zcToaQxHs6Hwz+k0HZSpu28hMfCRXFx7l01pKzr2mFzhwPeYfpBFD8QC9ODrfMLzSipuOvR2aLSwHVfZzi504T/gyawxxlKb5wsjvoL1H6CG1PeKbPBAcMQM0h3OiEYIUS0oHzrf3MdudYCSt3WHqUoJ7fFf8p33Mrm+p4aGXh4qyYJkBVio3Ltby2eMvayZkU2/txWQCIuOg+Z9kfPxAWCzeOI3chNTUM1Wu14+y5nY523kkgMhFEQHVUguxPSavT1bHvfAm6p6sL3V5ghPvH04GIX1MsK2UJT0cHdgPRA1sI9lA4CNG8gZz/L16Vf5Pb1osOYOJtsUzq/zqgnmSvdtENPO9k4UA1ZTeEZSQ/gT8l6A64IQzuBBVzzXRzQZ502bSiBEC3a/+0fGX+HSNqlARLYc1ttVm4vkGFN+8tPNGenQrT8g/TdGe2zuxT10Khij2S0RlGce2fBZpKSTfBDDnD2Y2uwl47WG1MFiJli93svyQuT60jlZon7rVlpKLxdwQ11is7EbY9fYMlTt8+JOeFDiSfc8Sn6ILnMLafZkrJSNcxvaOb36rmOa
 XAAikoVC
 rERp8DrLN1IqgCCcnftRrOfdiM7K4vnjriZ7P6gmO4RO/ed7yfqI6v9eKMiTGy8jbXDBh/HYZ1N3nqkcHZD9pxm/5RGLOb1Q/GFtRRYQzdbAKwGaweDekcaBmptSwTyTjNWq0Q4iR53zaw/ybwlKimyRvmTo9Yk2/X9ua3Z7BgK4rQ5RCQd8f+1Py7oCSkWr/l8vUFLugqrWNyCdjia35oDqnnQhgHK/HWmeqNQKGTrk0jiNZH0BiDUu8LK3iaJkbMcz3p43Jl/wryJWFPHyWCE+2ww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 6:43=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmail=
.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> Add Documentation/dev-tools/kfuzztest.rst and reference it in the
> dev-tools index.
>
> Signed-off-by: Ethan Graham <ethangraham@google.com>
Acked-by: Alexander Potapenko <glider@google.com>

Some nits below.

> +Macros ``FUZZ_TEST``, `KFUZZTEST_EXPECT_*`` and ``KFUZZTEST_ANNOTATE_*``=
 embed

Nit: missing second backtick before KFUZZTEST_EXPECT_


> +Input Format
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +KFuzzTest targets receive their inputs from userspace via a write to a d=
edicated
> +debugfs ``/sys/kernel/debug/kfuzztest/<test-name>/input``.

Nit: "debugfs file"?

> +- Padding and Poisoning: The space between the end of one region's data =
and the
> +  beginning of the next must be sufficient for padding. In KASAN builds,
> +  KFuzzTest poisons this unused padding, allowing for precise detection =
of
> +  out-of-bounds memory accesses between adjacent buffers. This padding s=
hould
> +  be at least ``KFUZZTEST_POISON_SIZE`` bytes as defined in
> +  `include/linux/kfuzztest.h``.

Nit: missing leading backtick.

> +
> +KFuzzTest Bridge Tool
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +The kfuzztest-bridge program is a userspace utility that encodes a rando=
m byte

Nit: do we need backticks around kfuzztest-bridge?

> +This tool is intended to be simple, both in usage and implementation. It=
s
> +structure and DSL are sufficient for simpler use-cases. For more advance=
d
> +coverage-guided fuzzing it is recommended to use syzkaller which impleme=
nts
> +deeper support for KFuzzTest targets.

Nit: please add a link to syzkaller.

> +
> +The textual format is a human-readable representation of the region-base=
d binary
> +format used by KFuzzTest. It is described by the following grammar:
> +
> +.. code-block:: text
> +
> +       schema     ::=3D region ( ";" region )* [";"]
> +       region     ::=3D identifier "{" type+ "}"

Don't types need to be separated with spaces?

> +       type       ::=3D primitive | pointer | array | length | string
> +       primitive  ::=3D "u8" | "u16" | "u32" | "u64"
> +       pointer    ::=3D "ptr" "[" identifier "]"
> +       array      ::=3D "arr" "[" primitive "," integer "]"
> +       length     ::=3D "len" "[" identifier "," primitive "]"
> +       string     ::=3D "str" "[" integer "]"
> +       identifier ::=3D [a-zA-Z_][a-zA-Z1-9_]*
> +       integer    ::=3D [0-9]+
> +
> +Pointers must reference a named region. To fuzz a raw buffer, the buffer=
 must be

Maybe insert a paragraph break between these two sentences?

> +.. code-block:: text
> +
> +       my_struct { ptr[buf] len[buf, u64] }; buf { arr[u8, n] };
> +
> +Where ``n`` is some integer value defining the size of the byte array in=
side of

s/Where/, where/ ?

