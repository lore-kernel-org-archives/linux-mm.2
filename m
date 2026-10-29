Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2913606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 21:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qwd9mADS
Received: by kanga.kvack.org (Postfix)
	id C68946B00EF; Thu, 29 Oct 2026 17:49:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1A326B05B1; Thu, 29 Oct 2026 17:49:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE1726B05B2; Thu, 29 Oct 2026 17:49:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 85A946B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:49:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7DF45A0574
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:49:39 +0000 (UTC)
X-FDA: 85377006078.19.D693ABA
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id 915651A000D
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:49:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=qwd9mADS;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793310577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4LvPUtuyu2GhVduPqIuGkGvQXkCV6OpKfaG8/4pXsnI=;
	b=tW0EP3/UfCeFIHB2rAmtup93ArK92+NHP0LsvLfKQyl2Cau13m8toCNWfzA0pIltwktLAa
	Ug72rvxjLG+KDaQrToDnzU4uy6pu7dgW8x5qZ1cRqXaaDyqzkJcDti6MRn6SlEj8EAUJx3
	nkaWsQWy4/I/o6h3bsn0fc6kffLUoqA=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=qwd9mADS;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793310577;
	b=ypRkiRbK8owqeGWjUOTOb8ybbPj/gKuhyXoK6OfeGoBADIBDwYrvUaqu1EoAiv8WBdcag3
	wVcX7xdGLjrm2azGyluXfHix1vnjVDlLFWtQ27QSqieY8QLH0t9PuFKy+2H0aB4H6GAhD/
	W56vdtb7Sd9NWKGHUgc9Pn4JDVw/kcA=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2e831e86ebfso499045ad.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:49:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793310576; cv=none;
        d=google.com; s=arc-20260327;
        b=ka8g6t1N/3uUSAqbgByIWnTi5yjd3hessl7ODMfNO1ydnbu+dKu1konkU0GBgsp1r1
         O47++Hf4iFXkzcmZzNEOv7sHSXYLvHdEqBAorEVa+E0yjZE6U5Dcdf9OpWlN3KS+dmpm
         YOhkKk0wODI3DVtwDxWEf3s9j3Jgy5ZdwAmMLvcppakPI43buVazCE+ukfa7RUVXqmkm
         JKXvAJhlRY/0L3PKcTDvHjPoygs2LGg86gA4MxTJlnlMXyajyvQXtnBYeqtboZI4g36O
         M0CPrAOG82X9yITwR94sVrSkQa2mptLMfr7W/BPMnF1Zp3UG5JkyUAWLShUXdvT2eYeF
         3gmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4LvPUtuyu2GhVduPqIuGkGvQXkCV6OpKfaG8/4pXsnI=;
        fh=+4QPVHxzsvmbzygIxbinhvxvVBpPbPvJIYinbBdO4b8=;
        b=KYb4+JCTEHtXhmqBYOBeKxN4GaEDlzCySnrG7XFJ4s5+TzZpufHYrOETVqht1ig5y6
         XMXBSxL5sk4aCmu3gzkkoXTu4dXAdMk69yKvyg0HCf8l31sCL4aKoTuFfx+kkZELZ5s1
         9kxq2o5HBO3CO0w8h+lM479b2lrVpDzwEcPaaUdmhoE6RM3dALSH2lGgiF8YYewKfi19
         +Dq09JMgUshpbSA2P2t/jHm5h06dedBMYgXQfKa9L4p5jdT699/Y4JDXb3y+WZ/l358i
         CSTHl6wQugpIs28NJEnIoQ0iMbJJDfMSMfw977Z4sMlCvfQ1xGYtxhxEp5onFnBGusc+
         Z2UQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793310576; x=1793915376; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4LvPUtuyu2GhVduPqIuGkGvQXkCV6OpKfaG8/4pXsnI=;
        b=qwd9mADSSVCrWz/2C4bwEQFq0Rc/A6SH4HMXOjpv5kwYodQ0feewN1JD5oulE9DSPf
         dcKMBLWgTB9p8XZYcKopN1qnXQmt+0Q6RLfDWBOLddLmW9vNYC33sgHoEjMwFFOIKPAv
         zb7Sn8tMCoLYrSshja6U3veVNDWaGTYeA6W62JIpjLIuakGpVXwtQMwHyTX3S1mncvvW
         w9J5WndDlA0oYiLLjbWg9ezaLNnTAKjjBef/21W1QtRlLOEbfrIwMw4xEZ4GNGGYaGng
         QKYTH4pvRFMTSpqdpfBfNlK3aSk3veqwKWvaR/6naBQHq4LaLSnTL374fMAaQ85NHYbH
         K/ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793310576; x=1793915376;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4LvPUtuyu2GhVduPqIuGkGvQXkCV6OpKfaG8/4pXsnI=;
        b=XD7m/W/ABSsnfAY1QEy73barqtS2O9KzphLkE+3RQVnSyGSVMYFB0/HcBRWJ6pwM20
         Uds5gDXoXw+nuMtoNHCCs069C5Tw0NYeOnVCe9dZOL6hKgxS0spSk/vuulrZ4xCBoA4b
         ytiShbnCI+4Arxr6F3Rai64yHMvoZ7zXmAI8HJzLhlSTGCnq1VkSCZq+N+DKPH72Cpi8
         Sy0hIrPsI+oPc1aOgd38QMckG6XLrDQf7CCWoiermIFzMm2YfV9/0Th0XahM5TKP4dbW
         VJNfIWqf93mOvSWNftJvLSElBo5TTcusRF/+u6mPVA4eA3zW7Abjzr9LdpVGGd8lQi00
         pSLA==
X-Forwarded-Encrypted: i=1; AKwUvBz03NcEEduAMWPBaengazjmh0083g3Q/6a4Z/Gns62RnZuZa2m2CNcqPozn8W1XeGkM9EHhUbTUcA==@kvack.org
X-Gm-Message-State: AFq9FYI3GAVby5PsIafL5jjpTU370V8eciBWydXl1v/45hcpva89xpG5
	6BiZ1rSzlNkprr6clszQKH5RpXlHzhGVYNLCNo8KMHOzgzBvJQiEp6pa/v0QDv57nIvFmxPXKTB
	wEIt8XVouIxVnewSIaXp6Dl4gl21mDs0=
X-Gm-Gg: AYBFou2IaNROtDKGh3JBykYJSHIIsKFFR0iCcVxKcU0m8DQGOA2XvnrvmOlp5WWZLlJ
	Xi156NL4bjIjs+OQIjcYnUsO08o7/5fXueqln2N8yRuv70m/T5qpMBY2S2tTjbxWYb523uoKQ2I
	vtuxGuxKCU9Sst8478t618Vs7P7jGwcJyr9qsDwDtf1ffGGNOrxlwDfxDwCw8Eca1MACN5spHgc
	ZkRoBfIhr4cgNB1WAYEH8NOxDpUvBUVvoVKjXT2RJT4GpMsvBg6wwkVArH4E6R2jUzvgDcExBqy
	Ivla+/RSZMdAkNNhBF4W6+DMwsAYRpnfiLYqKU+nMiTaYzw1OKFaienv5v0A2isWJPP7y4dX5uu
	SODFQFT1lo8NzTLf65kxeDoU/qz1Bau1oX7uBkLhJlQcP5pIKyzLO7V8KlIno0hMo4pAxqzWJ5C
	EI0Vq6et+NrfQx7QnuarE48actvK3/nL68Og==
X-Received: by 2002:a17:90a:c2d0:b0:3ae:533e:7e3c with SMTP id
 98e67ed59e1d1-3ae8981bf57mr183023a91.35.1793310576388; Thu, 29 Oct 2026
 14:49:36 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261029212551.56964-1-jolsa@kernel.org> <20261029212551.56964-2-jolsa@kernel.org>
In-Reply-To: <20261029212551.56964-2-jolsa@kernel.org>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Thu, 29 Oct 2026 14:49:22 -0700
X-Gm-Features: AclHuK_5bx_yu4DhThJ8Z6lvpTGvlgJql7An9DPk8XTshDlWp4Rvot3r6HrMVDA
Message-ID: <CAEf4BzbUQpQcdpCJ0o2g0YkaR_Lwe9EOXdj8Fth0UUpAs-LR6w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/8] bpf: Add __srcptr kfunc argument suffix
To: Jiri Olsa <jolsa@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, Federico Di Pierro <nierro92@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 915651A000D
X-Stat-Signature: wmiixhm56fc15wwq84qmftbt51pxu6t8
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793310577-687172
X-HE-Meta: U2FsdGVkX1+MH3UsjAGVgy68UVWRs/8KtIwaMD214qgRCOYinSMPLa/V5IG8naVBTlMYYQvTU+485NgM4OHabzvOPteaKgbeTN1EZyZ5A7aCOkEEXZ8CK3a91xoIIGHkbel8vX27L31H5wawMqPB7yvbJee9l/yASbecOClh9f5d32fyx8nBmfBim69KX0zPG+fmiDYkmApFEmOvVJdl74xZdJYMXV6cp60wQyJwtARgUTT6krvTJZMEJ3gwEgi+KUleJDvEgGRCKklW8i9bC6ikX76j6jauSt/BgWpfiCQ+NSfS9BVP+UhhgsvnvTHJ+9HRSIrvqfYiAY5THzm4B57gLiMW3tFSphcijAE4+pkESOAi3N8BEEIrh4PGVG5DtEZTydfUNorW6qwp5VBECU7ycprT4ssbl0vNloYAAwermA1p7FzA/LgB2Xt1I5vfsdcKSdc1yz5iX4VLbIfEyfITeGEGVGexnNF536jqRVsEoV3P4ZjayzbN2aWje3oexejpoGXV9LvE7aCcNqdu8YrQ6HJuhpig2LUOvl1VZ/IQWMFqXPFpzblq9CssdnBf5wnMAHle/g2T7V5hou5a39lByg8TP83LVA2FTWdi9KVS2W0EBv66TP/BqU0ToJ8FyBhoDRQ8H5AZU/g41LjabVZAbpcaFzmyzg4Y42ByXWQo9fyABH/1Op+6F9wJTlD7TRvdfPNl28TL1noCxle4Y1SUhHn5mg8S2vjUMZ0dYrZTJ5FNHIi+3DKumfoYsV2nXb2MW2DJeE35ygfZJrPfgBgCNa4Wa5yw+kUkO2MgHTsAugDiDwEH+9B2htRKEjX0gCAPUhOZiKRjqliXqqOe5r35ERK5X9bJP+dZGT3Qy956bJbtxba/mNhQvbaeaSb5vTmib9q8jCCJKeQfZcoDt2TD+dEwjKuCNlpbxwEtMxompR9LoKseskDHoFaqcL99ETytSNg19+IAcO1g/HY
 /yjqBmFM
 VyPcoGbIk6t5B5NNn1slLE7cR2y4J9BrDwi+9s8dVjLWI7lCM7MqFXAfo7UXoeG/K8PFnzpMzozhCnNyHo4/33JUiCxhFo6Z4bbpI90Bc8y5Vlqe2Sg93gKRIIJQpZfxUw8TvDIKN+Be3Nco0OtjT/aQhUQCgjTDBcxbzMrZCIyUT5lsjrccUq7j9OmcEdAYaZqkx/SLu43ySXsM909dWkWAhjzeRhFDoQfndL7QLvWpIT5UpMoPD/eqZHCFT87LslanmeRpLvtvXI0xIbWT40lvkalnu1JKZmai5ETzRslRsxmO0BtXdq4FI1gZCaW+ecZcdAj01BVfEFq+hOmzX/qpFS3vEfYdXtQWGdXMN9mIXB06cxb0lhLJ6IZBEIyzznX4P0ggma3Aug1QjNGJrr2sbwqn/Ro5XzfmGjpTGMk3ZKOiwbSIozdSyhQ8zdjlnK5+W0m34BE9IrH8fgPN1q9cgdxUB5CZJfybeKHPsDlqbskMMwWCM/SFBJkF7xBCrPZZZNYlxyJmzgmWvesbW7eD25CyjUXcMTmNv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 2:26=E2=80=AFPM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Generic sized pointer arguments are treated as writable memory. This
> prevents kfuncs that only read from a source buffer from accepting
> read-only BPF memory, such as const data.
>
> Adding __srcptr to mark pointers the kfunc only reads.

why can't we infer read-only from constness of a pointer? what's the
advantage of __srcptr (which, honestly, says absolutely nothing,
"__readonly" or "__ro" would probably make more sense if we have to go
with suffix)

>
> The get_kfunc_arg_type change sets the initial memory access mode
> and the resolve_func_arg_type preserves the suffix=E2=80=99s access mode
> when it converts a BTF pointer classification into a memory argument.
>
> Assisted-by: Codex:GPT-6
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  Documentation/bpf/kfuncs.rst | 24 ++++++++++++++++++++++++
>  kernel/bpf/verifier.c        | 20 +++++++++++++++++---
>  2 files changed, 41 insertions(+), 3 deletions(-)
>

[...]

