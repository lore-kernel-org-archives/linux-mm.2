Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08236606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 18:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bi6m6niT
Received: by kanga.kvack.org (Postfix)
	id 29CDE6B00EF; Sun, 15 Nov 2026 13:07:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24DE76B05B0; Sun, 15 Nov 2026 13:07:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13F206B05B1; Sun, 15 Nov 2026 13:07:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0DD06B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 13:07:44 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 689A0A8563
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 18:07:44 +0000 (UTC)
X-FDA: 85438136448.03.CA9DAE3
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id 72C8940003
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 18:07:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bi6m6niT;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794766062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ODZ8mXroBKAV6W1gDkxOYZgQxrPGMytztzvd6zo+XoI=;
	b=KQVYzkEYxG7/TkJtkVRZEyQ4FwmE0GpyKRjlB7NGXn6c+rKZUhTpBsQpCNjIcDR/G1f5n7
	hITezVaCz483adAxslM1wKYp/meovX78HO2nIYLPB0+BIewNnEJnIV2hPCnFtsPACUhFf6
	rhmsA62KXX0uelgDB4vbzbtSJOZeFqs=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794766062;
	b=RFui+ao7q4xN9LIlfL5oI90pezQt0z4sG8hhvOqA5VnZHYwN0Prc9aVfJtWn5B7CKS0Xtj
	sgJG9qrnsXyhShjkaQ0ET+KBVdDE8UxJsAg+cAuW3NR8fAT69MpN+MJh8xqdFk13bQTfIG
	8+hzSS3qD75d54kWD9zM8n/106Z2fk0=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bi6m6niT;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c50d3ac6b51so61629366b.1
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 10:07:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794766061; cv=none;
        d=google.com; s=arc-20260327;
        b=RRYQcN/+4vrdljcekDeb3c3jyOf12HmpKmZ4lcKfX1fpZP1sPk2XXBFGIst1rZ0WAR
         kFg1Ju4YZNt0tt8odPuPglERlltmhKS2Ry26LqPrX0NfdJ5WlXTphj16hvC0iTkbX2LE
         TDeFk2YQY89dS5ckWu0YKKJvj63c27loRQwCNUwm4Q6NmbNB6a4DzstYoEQFEDROsSjy
         GazWWzTTE9rkjMz0tw1Y3VbEKH3xB9MBBqKXRA2dDeSzQTZX7XluNPfSZ+UOZ37uZkkW
         v5+sOBbEl6J8I5T2oBdZV2TfxOIHiOd0mlXFq1UVVr8HW3HwYOZCe0ArUE65+fAYCZlv
         +oGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ODZ8mXroBKAV6W1gDkxOYZgQxrPGMytztzvd6zo+XoI=;
        fh=xTV/cI3eG5A2a6Ng4ydOnEQ516jTzB+PUnCMlrPCWLg=;
        b=VT9e5xHDxVraCAghKptg9LG/r/9HdxCrFOLbRLs0onkPQsI0MU642QaNVOu2M+O94W
         fKdkBf3tQc6BdvzEKLK0ga2Q6CyeV94Z7ruaXIRKlqKoCj/eqsoaCirFLjtixT7o78ac
         e90vZ/7qquBjkIOX7nbBGo8zCMwv6G73Ymrn+PkT1IRJ8ySVCsFCUtPAn1TBeBM6Jce7
         bBE/dMR8zKd+qyp2539+0cekjI7CM7TiwGXUuCMTGl0uLFwAPWZZbxd1653nLngMyq3V
         QjxnezqJfUzHutlXITW5PX7LkpCy8Y/4fOFw8Yt9ap6UHLGHTId1SwM2rGnFcTHfK2gQ
         Pkbg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794766061; x=1795370861; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ODZ8mXroBKAV6W1gDkxOYZgQxrPGMytztzvd6zo+XoI=;
        b=bi6m6niTOXYuOZWHgFm+RQIP2ANqzfJtdL3MrZsE3GYOgNE2O+slyKf/4tnwZTBcq3
         lGCI3metQBWWSi1sD98YR68Rh+NIbhZLsm4K12vbriNyxZ/HUV886buRNFHBH+aBdnDq
         fdTBo5J8rvy+8RNslAMr7dC1KP0YTmSeQ5pvKaLpkMvHK1tHFSCoO8wqUuxYH8WfiTYk
         Tv9N26ayA9cKbY+zvtYrYtmobKegPzyjKDALGabwRbktvBnXybR5Odw5EQJU2H2RPvJY
         YkskAeca+UO4qNujpRsSgy5VSSTfVjWWmvo7dR04tqtD4kbS78FO8ELHp4kS0wzaX+RN
         5LVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794766061; x=1795370861;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ODZ8mXroBKAV6W1gDkxOYZgQxrPGMytztzvd6zo+XoI=;
        b=wivZfyC6gfMvFnh0/KiL/JoFyGA60cKQ2Tezk2/OcQtZshvNShQgOeJZaXRFVibGDa
         yUaV46ph2WmJhk07Go3TYSwM1cOGkhW9bGc8+okEEcdcoIlNGvbZsK45sXDeBzsuLkiO
         FEGNWE5TsXAqrUoruZxdk+guJecqXMgXfCUpL/kZap09/fk12OEb0ZauVMbRRrrLmnIX
         aeJ1h4pKWsrpf6XbvwK9lDX8fFPUgS5ZGsflx2uwVMJp3xV6+37v3GcVJFaBDVr9PMUB
         ++e2RPyPxvPYRy8ss9X9gYPpGRtKkC7UUCEdVTsgjDcl1pE+PSPY0LNv2L7BHdiNle2l
         H6pg==
X-Forwarded-Encrypted: i=1; AL+hErEBWbRGaJHf2tcGeRdCJWKV32742Z8hP5wQb5sIh6atND6SSgqopFe3cdJunGk0T2sdJt+06tJRuA==@kvack.org
X-Gm-Message-State: APuU4Z8FWyKhTpd6KYRYaCHlLkcC0SwmMrRH9YS0WwlZRCGhy7pfNopN
	0k9rQld5Eer/FqA7wM8q5fGowdBkA+onRQhcxqr6Bfd+8vwHLbs++5rsMjNq16lc2YTrEiIfE8O
	4wh6ArMq+SkiLKnPvHbFxB9NXxRNCogc=
X-Gm-Gg: AYBFou0qxHJsc0J/HngUGwLgkoLBhBfI3xdVzADD+vei421n+gXCW6x/OeDVGfhtQSS
	CHczoRBVp/PEd/rT985xUUofXPD8dWghbU6Dx8+vJdcOYWCuT3FL61Z6CbhBJ1iVAPorzlkdBlX
	c53hSXdwXnjwfZ8IZwjaWa1HXUhkeBb6dcRpw/jOIQG530PBINC912A8VfIZm7c4lg1FhO4FFZt
	AvnzwxNnshSA2WfynLPph9lsabEAFjiU7pg/yb0MEzdvKwZwLeu1N6FuJBGQUEqE2BSanKe7rdc
	3c73EcElihdDxavycMYHSAK1DGsCmoDD3YivjJLh1DUYdHYB2fpGlHLlBXWjJaCJS8GPxh0+9zM
	1wuRzCR/V/C+ls4nXkNB7sYTB9jnbtX/mLEZciIPhb+ENue+jxu1seMTrDAtDN68Q6wdj1g==
X-Received: by 2002:a17:907:da5:b0:c41:1781:a2af with SMTP id
 a640c23a62f3a-c507bc6aeddmr962657866b.9.1794766060702; Sun, 15 Nov 2026
 10:07:40 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <sashiko-outbox-215014@kernel.org> <20261114214438.70148-1-baohua@kernel.org>
In-Reply-To: <20261114214438.70148-1-baohua@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 16 Nov 2026 02:07:04 +0800
X-Gm-Features: AclHuK9wWwrM_zlQLCnEvdTqRJqqg87qbS7IMoX4RX9t0fL0_GRNtM-b0gYZBYM
Message-ID: <CAMgjq7DiH1SJCR0DMwf=16cxXO2PZcjSuD41sO7_2hOcXuPUQQ@mail.gmail.com>
Subject: Re: [PATCH v9 11/16] mm/mglru: Run aging when one type is drained
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: sashiko-bot@kernel.org, akpm@linux-foundation.org, 
	axelrasmussen@google.com, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, 
	hannes@cmpxchg.org, hui.zhu@linux.dev, kunwu.chan@gmail.com, 
	liam@infradead.org, lianux.mm@gmail.com, linux-mm@kvack.org, 
	liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org, 
	mhocko@suse.com, qi.zheng@linux.dev, ridong.chen@linux.dev, rppt@kernel.org, 
	sashiko-reviews@lists.linux.dev, shakeel.butt@linux.dev, 
	sidchintamaneni@gmail.com, surenb@google.com, wangzicheng@honor.com, 
	weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, 
	zhuhui@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 37er7g3skid33yegp7n4on9rgutarqwb
X-Rspamd-Queue-Id: 72C8940003
X-Rspam-User: 
X-HE-Tag: 1794766062-577025
X-HE-Meta: U2FsdGVkX19iCIacXGv4kNpfs9hQhYLM34SNRGxHfNpDjBmAfAaq88SLiRITzhvHBwjCqkCAXOORZzwSO68PkpnmwyDpnjSUfWZuXq6noTWSl/rZDGHmX0asg6VdATk5p7cJSAHEA6mbBaEGjiVbn2vCsKPag01q/A3ZRkfXw+IF8/hJMoHj3UMpNOSjOTqrkjqKFCghmmNEmZM1eoMesXJaHtHKJQl9kvFmT3KZXOOKT22FjmnbnrxL40zqwD4O67aV/lpY6LPGrQr8ZcoziC8Sfzafo4fcWsrGtlrFP9p+ngq3qLfpyhhl+HgueRT9u+K3msEJLsimszfFuBP45oyCEvpL/CJ1HP/fkKTe9QFtzg4gOFHfSW79WKozefnSIkZM1B8V4uVdAqzOUbq2XMssHpPdlrzVf11IUvYqY8nAmPuL3LZr+kmE4n3PK1zBGEsoTT29SHSMlHuZLYEAMOjSobJTjLyqXBdv87PpkZzOcO6N4QfyFLMv2DoBIpQ8d8VSKnp8V10W8OehSXfLSaR8SN39a13MQWPKOP2XnMRIv4V+vCvtPl8nCqTz6Nv8loTC24rTOoJizn0MkLvSk5l86tEfqQNW78BWhXxCOS92ONRsdiU921wdFOk6tul9lTb+M/kdCn7lnz6u/79x9UBnYW8DDqvKViicdZhqZUY1hEkxj67N5TrjRVi5eLiRguoaNqM5EJQ5LWdnfpKPiFsxkLPllNuuLvhlhQqkXZqVOLKnUB713uda4fkhhBfhRX96Vhitt5sn/0ezFP61xM7D6880HIpjH7W8tnv8CFCB6nwoKNy9WuZdjzTHRKGRqcmydY9mUE9YP9vG6IY6h1sHN7ab3dWkyNB7U2vnUIcc/6aat4IJb5GE5B1Xr5JZspCFdzhAVOn7n8NpTCWkuBG//ArxWSM9HAu8VvQo2wJ7pxfajT1iw2c579DLcaQuLD6WmAjGApa87u8Y3iJ
 fhBs9VJH
 QOjxrDsd2VEa7CCBYGznBrQsdqYSRoQ+rcpvdotItFbr7vvckYbm1l2avxss4D53r/u0ZJp6Akru8l72EWu/IfODa59Pu+x6Zrr8qbwlC6/JipFhgch+sPoDNo+jYuFxs8zOfggIcsmAB14Jb+u6MhgKQciazqw5RXGuXpX3+Bw/VyKbqYIlLMETPTR09TQz+XFTL0BhcVqe/uBU5cuCndEhRO/rvP+ELS/RFgG9TZtU5BjAwFrIi7f7ilZUFjUKSQUyanX3tVXVZebHHr0DTt19FkswGCwbfEpC4MZy02lkxuwwUiDR81aaTfDrv8rKk7ebdXOV0IOIFPq4c2izBWA068T7TEQNWtQhUzdxrseaL4d53sIZa2xeZYDkjwbnzI2ed+UM2cF6/Ki7aaCOSW458gRqNfwWgzJ9Ol/Pms70b3jPS4wtrHNQoCzysURl2OBWzqBazur2ZqNsXkypDvwypnhA4YCJpfIrurcQXC0QTbVNbfhRIEypQcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 5:44=E2=80=AFAM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> On Sun, Nov 15, 2026 at 4:50=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
> >
> > Thank you for your contribution! Sashiko AI review found 2 potential
> > issues to consider:
> > - [Medium] mm/mglru: scan_folios() scans seq below min_seq at
> >   DEF_PRIORITY
>
> I guess reparenting could be a corner case where it's difficult to
> properly preserve the cold/hot ordering.

I think we don't need to care about hotness for reparenting, MGLRU's
reparent just forcefully squashes the old gen into the parent's gen,
and most likely in the wrong window order, the hotness info is already
severely skewed; there's no way to cover that until we run the aging.
In fact I think we should patch reparent instead, maybe later,
squashing everything into the oldest generation seems a more
reasonable solution for reparenting?

And if the child's old generation was squashed into an out-of-window
generation, these out-of-window cold folios will get evicted much
later than the hot folios. In that case we even somehow "fixed" that
by this patch :P, as long there is no leak, I think it's hard to
define what is the right behavior.

