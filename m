Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0936606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 01:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YDZbyLBc
Received: by kanga.kvack.org (Postfix)
	id B8AAA6B05B0; Tue, 17 Nov 2026 20:01:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3C1F6B05B1; Tue, 17 Nov 2026 20:01:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2AA56B05B3; Tue, 17 Nov 2026 20:01:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 81FC96B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:01:22 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07992C0603
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:01:22 +0000 (UTC)
X-FDA: 85446436404.13.A4E3FFD
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf27.hostedemail.com (Postfix) with ESMTP id 16F2E4000F
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:01:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=YDZbyLBc;
	spf=pass (imf27.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794963680;
	b=Tmd29s1Hi0rsD6lCU0Mu4QBWR9nlpdLopzpSIaWFmVVfQRrnSPP5Hf5hfuWoVN58dYDos2
	R83J4FXf4MJFYAMwaei726VyJZ88Ajkif+jPZ8rtI5OfmMS7zk58VFdNt+sQj1NynUW4Ed
	wrYdoWGDFahZO6kLJ/Ix28po2SQu8+k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=YDZbyLBc;
	spf=pass (imf27.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794963680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m8/kejje43/iSzUQBqp60HPt96dBU49CmzQKrHbpHKA=;
	b=fBMhdIz9Yc/BNIA5zLf4V74ZEALcN7xZxswlc7N4HF0QbD29DG3K+eVz+EK+tysIpUSqCm
	M8VQA/5y2sjPQuM0exqQuAoRtut8zas1XNiXphpt3ezwgg7u4Nm6/PMfm9rLVOiuDFbDLC
	kKH9WbXP24rbYox2DFzNZm4/R2Gi//Y=
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-1b1cc08166bso2260c88.3
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:01:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794963679; x=1795568479; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=m8/kejje43/iSzUQBqp60HPt96dBU49CmzQKrHbpHKA=;
        b=YDZbyLBcbqXXXSpMx1lyIqtYwaEawvHciK9YKom5aTbSCiL1Ef94/ql9OBBYpDyeHF
         OjlhjNlSa0MMd31Od2EX3lf0eEqpmLvCzyuvYn3s6Hd+WJrpmUdwgRCF4/kpOdXHI9ED
         sndbR7T3hFkvwU/EC9PN2e3bqbgP2ge4vzNFqMUGW2f7EWeN6eE/Ug+nb/gPbgBo/r0h
         9BUTlUAY+0I/m/OA3yzFkC7WpM8If0EHZwBqmTtF5nZG6qqQQzH7+SGSpn1CcsEkTzPu
         WBG8otDbyATWZdHBYZ6Xfii5WmBm2EL43YkDlXnlhFjalpyWKrjaXovllGvwaqg1+URu
         EBaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794963679; x=1795568479;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m8/kejje43/iSzUQBqp60HPt96dBU49CmzQKrHbpHKA=;
        b=v76uvdPy+DtocMt++hJM/DZCms+gXwLPBNPm8DYqQVSxyNNwb0qzhUPhWWVZ0qsa0d
         bzz3E40hwJctSeyP8DiuPTGYQQjI2MjOEtO0QgaoU/xYoPmqGTv7m0lUNSa4sGJN6yYo
         C/JWbnF7RifH2s3ZY1vBoj8fzHzIddPbxnwh5xGaczdKTOo2BFMyrPsPmTLgH7ZxXOid
         TiDYQhbCQuet2hFVMTpGM1QVE+97U+M35AKVGpikNqyVQnXO26BupHH+BFlqeoG21pQP
         QQfIdezYTZsgNeNBOQOA8vd45up7xAUIWgF8CyQkkLrlCGgpLpf7Qayb9SqemU/e1UEH
         /FBw==
X-Forwarded-Encrypted: i=1; AL+hErHE9m9YCO19+cL3Bxb39nR3d7MN15LPsm7h5zugljtqpe8MSeX5Wt2nIpFvaggZXGePBwg1/AZrmw==@kvack.org
X-Gm-Message-State: APuU4Z+7WTZJoPodDF1+vnu4EqTp1w2l0UVPn2cLlT0LmlOSbXm29SUa
	rp8Fb9hy23rH4atInySQYjy6wScPCtI0fuv6p3o5FSGFKYlcqHrpkG6a
X-Gm-Gg: AYBFou1D3y6j7+Hldq7W7utgrF/dm4nryIZdILAGcO3fuGaOxfVCM41fCh90IP89cni
	BiMoj/8G2cxyXTeSLgGP9NQFL4AoaIAorNDa8OnvOE6HYYOBLOip6nu5YjJGLz+mmgnEEQJGCUe
	GnIV93+gzuaUh5t9tRbkQ5tiO7GW2LJa5IG1FXYeQ5Wwzqg/sj+xEVpdLI5OowKL5f17LBoJoWN
	T0TGkWdoFDpkMjzn2cZFl8VRJ7sjOmBPokaE3CANR1TNtc9OXv+3QxzbQmLzBY7tPN4cIlpzVg5
	74AyE3aSyNHPnj6oRudvewxnXnGYxorj+QVPThhF05yx4W9JwHbjI98K6OgHsKZNFh/qb1SGFWa
	325vfBgIEeF4EucZgUh7x5sNxZhYpyGHzrTrKofk9RR+/fIqHQlxZCNBbC2q7PMBxuyO6DQyouN
	LnTWu/GrJe5Zmmy+BUXEy1SKV9EyepCxtY37i5BeUBLCKmTl1I8wnw3J3lLONwYbd+UDS1iXE7W
	p7Nz9rDeKWT2Da3R/fE0bWfhKebwi17ZtnOjPR8FSKd1wxiUafFMj8GvfwyxQGH6ydg2O5T0FKI
	WEHDAQC32bedZoPwcOlH7i0Wc3jA7rXUjr4zyJWmaHrPTp7xi3xy50sWqxOLe1QFZao=
X-Received: by 2002:a05:7022:ea8b:b0:1b3:a881:a67b with SMTP id a92af1059eb24-1b543b7ba68mr1691999c88.1.1794963678164;
        Tue, 17 Nov 2026 17:01:18 -0800 (PST)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5447da7e0sm2636759c88.9.2026.11.17.17.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 17:01:17 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction
 budget-aware
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: Chris Wiseman <chriswiseman@google.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, 
 Xueyuan Chen <xueyuan.chen21@gmail.com>, 
 Xueyuan Chen <xueyuan.chen@vivo.com>, Barry Song <baohua@kernel.org>, 
 Yosry Ahmed <yosry.ahmed@linux.dev>, Brian Geffon <bgeffon@google.com>, 
 Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <18e8fc17375582a2.3137322e32332e3235332e313736.2a6db6.0000sendgmr@google.com>
References: <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com>
 <anXJ-5_vO7-toSe1@google.com>
 <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
 <auKqt6b4AxCLziIH@google.com> <aufPMirl4cD7tz0X@google.com>
 <18e4542967ebdd10.3137322e32332e3235332e313736.1dfc41.0000sendgmr@google.com>
 <CAKEwX=MV_xEUvz91pz6uc4qXWnWOUDtXZ2zASdNVOBHBLeA60w@mail.gmail.com>
 <18e4ebf806e937ec.3137322e32332e3235332e313736.1bf52a.0000sendgmr@google.com>
 <CAKEwX=PFdgEbba+H3fEnJFDnfkxCTsvuHEb4numVwJRaiMgwKQ@mail.gmail.com>
 <179384102494.19062.12740032892044628762.b4-reply@b4>
 <auwOBaRtM9p_Wxfx@google.com>
 <18e529a5ab0738f7.3137322e32332e3235332e313736.873cb.0000sendgmr@google.com>
 <CAKEwX=OUt4=wqDLiPvYuiTnkpuZYnszkuNQScNR93hHhVPRRGA@mail.gmail.com>
 <CAO9r8zMMGem-LTJQseT5xSSBjfr3UX2gzG_ftpw6+KF8m9v5yw@mail.gmail.com>
 <CAO9r8zOY1E7gCYnJZAfKvyHcbj8e2WVuXMqsaPGPsKR4-9itsg@mail.gmail.com>
 <18e53459a8013078.3137322e32332e3235332e313736.12c7b6.0000sendgmr@google.com>
 <avVVRYkIAQnLC_Yu@google.com>
 <18e8fb5c1c4d127f.3137322e32332e3235332e313736.289d37.0000sendgmr@google.com>
 <CAO9r8zOtL4t5pwQOE=SAWeg=k2TkhtNXgV6CJJGNTwuTebKpBQ@mail.gmail.com>
 <18e8fc17375582a2.3137322e32332e3235332e313736.2a6db6.0000sendgmr@google.com>
Date: Wed, 18 Nov 2026 09:01:11 +0800
Message-Id: <179496367147.1128372.9610535275148675145.b4-reply@b4>
X-Mailer: b4 0.16.0
X-Stat-Signature: jjp1drkd6z7a7t6dbkkbs3iy9sad9soj
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 16F2E4000F
X-HE-Tag: 1794963679-618017
X-HE-Meta: U2FsdGVkX1+jG7N4o3KnB2N9Vbb5g2/dwlmsdwrGmoEOQYDQn4MtYZZ5f91SwUldvUXDwnoArr+QgVyEgDj7QOpCnNH55RLxYBKibO56XgMPL5JmmOamV/hnz+0zJpzfJuNZPZ0bcFdIGZCPi/JgtAt9NDK4F5A/MpC65AjjiEcMFPT24RRzcCUvvGUSOIyOdPL3ZuwWyI26fGkLX158i2bWruB2ekcas/oREFEIlTQ+jtb/fao7lxU4gC3w+q/WfXM3DtkhC4kAPqG1tvMfUwBaZG+i1kRQGjHHp32U0ATsD/LsI2a80wqGWMqbdh55hDjduKcQfazU9X8jttJCMA9rSZxW2U2zPcOeeSEjAValTe5hSzHMMLZ2GFZ3aYXUtl8vvmtLIfGX3Oj3BhkKuPECQZK5CafNTSZsQ0cQg1UXenWiiqVGyx33gBuUerFK2zxPU2Jy3YFeOX9N/fJkZBB/UnR+hd9nKQth2+Mv8mlBhWjgn8sWVUqEmGl0N63JS+P3j8pjIfQujUYu45L9PfmZysW2dfkdOAPdLiSyd40aTGjF4Zr9kg3UQpVqCI1aFicqhyMBST5Zn9kiwdwktvHecUPetXjyYHO712/XPX2Gz3FI3jELlqevKh69t2GBilR1b1NObF1IofxEbC/Qu3HdXCxk9NX0rNVLxGFZhxCCz72VeXeqORGB/dkwHR+QVm6bwMSdkPMG+Xwm36yBTleJXlNXQMbAwCzSm0JmzUKSPM56Bw+OHEF7fbUbGt7HmyLfanA8HHlAeSiqnW8ICOEmhq3tYMs9fSvsjliMgWZnKuI+b7xHYs3O3oI8yNSjLPg4fCUMdDIZv4A9hwkBYltdMUoHyNkWdbxPedaUF6Xdt9VhS0oa/fVjJ9HMRcs5Kv61IIhWHuza9mC+SRogoVsTEBxK90iKYltqAoFEarERNiyDYLUeLIY2u0+LB2ja1xqWVs8McRQuec08zmh
 dDw2aLAZ
 CT8l/Oy155YFZaO1pVHQUANQVUdmMeqiPd6ljTDPOwx9YxCU5wF3in62wVlDlZv6ipy2++sfB1eO/U0hE+dCSNCUuz+7VPgRmY+xqDX8RaKjIhXMdiFVMzwwMSET3+KdfbRey42ZTOwulPVqmpp49ZnOrVfXxfkoyqMeGd41D108c0SjLgV7UCc8zMBExT6IoJrGTZKPR4FvshUIqhasmyp00tKOkHXJ5ECCxVynegCUQvQ7ZvuBgURGXcYVyZBkozDJsXGj1PkJ5NMPBetIyWwqaTLLF0JzAUqrGYU9IwStQ3jhkB5CqazE5e8lFR+e1lO6IfJCbDIAmj7T2TOlVwXz2q2pWvO6B5gXySfh6JP1oNxRDH5ft6AolR2eFHEjYW0m3D/wB+XrWjkj8qnJh5jyMkAVCdBSw7oTaLW56FJXBlozLMhnmP61dutMpr9WZeKQ23/zO78DcN2tPB0jF8H12ilmCzW/4n66Vz83cjYFBOVXiYli0tAFL0Zx5lMKO42E395Jsk90+snUBgHsu4WhXskt4mSmCoCzV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-18 00:27 +0000, Chris Wiseman wrote:
> On Tue, Nov 17, 2026 at 4:23 PM Yosry Ahmed <yosry@kernel.org> wrote:
> >
> > I would rather drop it right away, but I am fine if you don't wanna
> > bother with zswap.
> 
> Works for me - dropping it outright is way cleaner than adding a
> Kconfig knob nobody wants to maintain.
> 
> Nhat / Johannes / Sergey - good with a 2-patch series that just removes
> the zsmalloc shrinker and adds the unlocked zs_can_compact() pre-check
> for manual zram compaction?  If Xueyuan doesn't grab it I'm happy to
> post it.
> 
> 
:) Thanks, Chris. Feel free to take over the series.


