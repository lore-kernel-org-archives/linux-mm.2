Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81224CA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 09:47:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84A6A6B0088; Tue,  6 Oct 2026 05:47:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FC506B008C; Tue,  6 Oct 2026 05:47:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EA736B0092; Tue,  6 Oct 2026 05:47:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4AA466B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:47:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CDD5CC0185
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:47:37 +0000 (UTC)
X-FDA: 85291724154.11.F9B0172
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf29.hostedemail.com (Postfix) with ESMTP id DA3A8120009
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:47:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MNdz5s46;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791280055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CmmO8ScL+eeMfrapWdr48bCTojDCYx9YeRYZOdtKmKE=;
	b=vfz71LWPmqS2i18E7gaw7cTtjft3l7UIpKMkul4jH3NzqDn/XBJTaP2OR6fQqS7vMe1VRs
	LrFBpk5A/N8mGyQ6VLYn88V53dbOfSiXT4PRRNcTnPBIwMB0C8L2LtfBT4gQEmLuQfRTAJ
	FaApv69i690OMNWBxTP16ECcbeFIaf8=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MNdz5s46;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791280055;
	b=agEjEiyILBlkPyzseiZLDUOk4DKm0yzDdW9wqqF37BaD2NPglinelCsCukcsBAefKqAbNJ
	MinETvXEiBm3afz5eQV7KvF2lj4dTW7qB7pi30rOkDBJG2xdrSxNCG/JHchoF8aVRhSEI1
	4i9i5tY49B4A9Ew5DeA9HJPeozlYLOc=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49ff680331aso26648685e9.3
        for <linux-mm@kvack.org>; Tue, 06 Oct 2026 02:47:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791280054; cv=none;
        d=google.com; s=arc-20260327;
        b=nMZRvjAFtU3lSkPnlMS7WleAZGiMz691SfpH113ULedIOHmzcsm5CeHRfo7ku0IHzL
         ECGpJhI+NNmqz9eIsZ68uxgIU+olDQp+HfiAKa4Fwf2UqK+oHTmhPXJkcfsfdgc6UKDB
         bl8X32TXWX8X99fayIU++SZ4Lhs/a+IkJ0j3X3IrcGaW/2vmp2vltysdg/ktcMYrwoFL
         k2tutDAM7qfYYwvo99fW+nXL/PLkUYoLjR3JoLOYnLu91VXWlCWsJLCcVAusMWx+fwJ7
         Ps+r18s2OuHg8eoFvbKekWFKSL0oUklexNqzpKDR8UjVNGBye3ai3soIMmJFnA4IHeRY
         YaEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CmmO8ScL+eeMfrapWdr48bCTojDCYx9YeRYZOdtKmKE=;
        fh=SldPSq9EOO9FbsOXpAjLQLEH+3IP4V3Mj/pXGPC6ZRw=;
        b=l6m9HCNKV/k1ygpExb54/Vn6r18mK7s5c/5e+kWkduTEe0Va4jyRAs5R7ucLnu4a8G
         m0BzDcdURYz7gTfnFzWY8nVZWx3km/KX76V7xYIuhWHnk+UqdiPjadrVBlS44spgoXjH
         hEFbnnwEQr+2eTnzuAzkhmLUSRP9UkdDhwKtrKBYU+vjjjFuynE3LVrGGKCfMcPmGy7Y
         bEN3TksED/SQ8Do0neIaXs4YbXmrviCW6l3EaDI13qdW4XM5JaZKpVGSIXRGl494PWp6
         NbvB6+l2qEydPQSAkkB0BclRn7Q4VxczQX2IEB9vV+JF02tq6v1do7bxYdjcObDv9w7Z
         ThSQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791280054; x=1791884854; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CmmO8ScL+eeMfrapWdr48bCTojDCYx9YeRYZOdtKmKE=;
        b=MNdz5s462nR08uZspZiVr2eZ3oITmhpigAHPUT1fHzxIywBsb8mXG4PDa4xkaw9vat
         Av5T/WMi3EneFPG98+ErILGDmyl+ln5ZdHYfeCmnqOh0DEubvPUCh/h5FMsxVEkOQFyo
         12ZRTYaymxQGVXrupet0VW0zGGm45yDf6FPro9gEw2LoojuOAYmhRE3X0A9m4s4mZZu6
         TXCO4K+bK4Vx3HO4rVhxUbWl8sW6/HayCGZmlpJPihPnE4I6swV0unxQSB9BVAn+NJDf
         M2D75umA8NlBflTBmSRnN20y1cV7T+DnOBk0cYc0fDovlxL7boSeeK4ijBjSQQ5IHigB
         n3tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791280054; x=1791884854;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CmmO8ScL+eeMfrapWdr48bCTojDCYx9YeRYZOdtKmKE=;
        b=QJ7LpcE6d+csFc7L7kgw1/LzbJl/RolcbUvPiLmUHG5wIZNDa9ss3NND1ndELIzKng
         lxsDB6isv38/f6v6ZqG9oVDXLkL/C9aKf6mXF3MIw9qy92taFstlJjiyLwaEJZXTcuLn
         IG8RpdUUkFxkOc6pUpyKXCPUjceJzFdjF+sxGgUJ+ScUy4w3Ha8jIOnYlbI4e1sBWfCd
         /HOuaDSB32y6w1sPLKkh1oxvxsblMW/uebkki1mhbRzNzv4hhmnzZQyHkMniYjW2THi+
         crczefMrhwPJyu9+BCqtXmtn+aF1uW0HOMFDES2TuHfCd/sBloyoxHtxaoFdaVL3etcn
         JY0A==
X-Forwarded-Encrypted: i=1; AKwUvBygVjJa6t/OEcZvn2oL8roZ+hrOViP6u/Z+QdMZ+PM7g2ShXYEN9sObnlpYfVUNjyiREC765eHQnw==@kvack.org
X-Gm-Message-State: AFuF++kuimcuD47r5+ewNp8UF9iAsR8I2ECWMaJ/A9+VVEV+w2SokvMJ
	9kpI/i+77LjP1rKjjCzTOOyQeTgRxqFvCf7RO4AZMGzj1/w5RkplnBNj1vqCzHgrc7rOwrFUdce
	VWsrZ+HPsffkUcjXu4o/G1/x8twACqoQ=
X-Gm-Gg: AYBFou30yLN4Oqu5XX4saz9aN7DipB0gi94biROl1pqdOe68FEts+zZwMnfgVcIdm6l
	oDiCHPArVa3DqKqObHy0SHQ4YGmn5AZ5LaJBpwpj7Tp/wapfBousWg3E9YFqX/SnShME5NPG4ei
	jMyMETs++p9Mr9EDWAoPhLH8/TqTGNTewNydJIYNLbx40/es/ZOGipnKQ+ldWBZU/hNkCG+XxQV
	n13yu+9wn0h07+yRT5IOFN5PGEgEX8ry50Z0tAH0AmJN4phXJHTmvDhYhXc4lMzSUfhAc9mtJYA
	6AkZ/pkP5ytXel8sMlrrNRhaJvAmaE1wpp2txcWlxhoZYgm3EtjPuSjUHmMavpia4D1DSvnEIUw
	jAcauA8YmEg==
X-Received: by 2002:a05:600c:5883:b0:4a0:12d7:4c88 with SMTP id
 5b1f17b1804b1-4a168101d97mr118976795e9.30.1791280054184; Tue, 06 Oct 2026
 02:47:34 -0700 (PDT)
MIME-Version: 1.0
References: <20261006002307.2669023-1-usama.arif@linux.dev> <20261006002307.2669023-2-usama.arif@linux.dev>
In-Reply-To: <20261006002307.2669023-2-usama.arif@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 6 Oct 2026 11:47:21 +0200
X-Gm-Features: AclHuK-gPua9uIItL7R1xoKxAEDDoC5tNOgy6aNtMtneqHY4TcEmx3Ke8MvnYho
Message-ID: <CAKEwX=O=QNWUCTn9kcCwu9V3pTrSwTj8SMCMS6Z-8fwhGjrkdA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: zswap: use separate compression and decompression requests
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, chengming.zhou@linux.dev, dsterba@suse.com, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	terrelln@fb.com, yosry@kernel.org, riel@surriel.com, shakeel.butt@linux.dev, 
	alex@ghiti.fr, senozhatsky@chromium.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DA3A8120009
X-Stat-Signature: mzir9x8fibsdnpq8fsmeoxcun4xp9opy
X-HE-Tag: 1791280055-928533
X-HE-Meta: U2FsdGVkX1+/juRAOyn31IRGle91INgyunEBwpqBI953MQ5KnY9Ev55Hv5K0KOf1B1qyn1YGsdnb09Q+uVCapxubbKuSUdcR2PllSV3NasKmztxd4yOTI7gLMNqNg0Q3HrTN1SfiXCh6SMErYrofUFqAOVE/kTpMiEX+yUBlx6733OrV6Mh2DgDqd4CxgsNu8fz6iNWNBn2uJkgt8PUIkDCwFMg9m0cw2hR3ym1AtTvdpFZAf3zpGT2/67p8wxGM8tlUD5PM2HWYpFVyeaCBe99ZEG3oxk7reLIy7eEl7pL6IsJjn03YHbeSO8dIjACK5ULGfsKV4mN4yG544b5YVdP+Ck88DWtwEZMciUkcxiX9fBCOADc56aw4I3ZL2xqQdJKXxNar1VVz1oe5qwYgnwbWjc6T2o3CjVYoeKKCVU3YuLzk6VL/NMyIZWYvQd7BdF3Knel9CiR6cbTkCbJng9dz2DVwsSjXRfTS0w6kzCNq90MSpMV8eZJY4kp5kUJrBALI3Nzf3cXyKIilvl7psP2WwSvmuLrdT2Upxi1MSNRXQrfJ2pdhUs0ZzkMdGcE+7U2JakMPeI2jfocIM5LKXdsHBeGVmYzerFNcbOdBYkXQGV/ql8p1E2v8yXfSL7cRCtAVHKLVnqaymE1kDXEwL2k9oKyBxi0dDyZuYFHW9HONtDs1wMC2F2EirkutGZ1rGjCee/hQ7iYdmCYcDvS5KaRYbsM2pRm0uppeqkq6lqeELdYHH+sV1wsNWj622DnUbHqqXgIEb7czC8fzds+1KKZA5RvaD8kEOwyWsS1Ethbnj0afETcH9DMpJPwc6vJI7bw/8ooy2xNa0UApYznge7r1vWkTP7kBhv7yuQ4Ni//eEFCka2okBe0mKLZXxrc/ivlFZXenYw3QmJWXlpR+E5N1NwyNdwYBjCCUvEDlAqyl+VkUmbKAPN1RwDxXaj1IwsF442KDeJ8EFtRD+k4
 4N34n/S4
 WqyOrHrJuxBl6lIGRssgl3lBke5QwA1ao6qXnhPhihce+6GS9s4DRSkQ5M8d8vLdGuBYCZILJq+GwwL/K5tmXlSYFuMNrZWho6u+FDpzGJOGAmPtCauJ3OW/uDtZIggMgGd4GPJ5NpC5OsKKvkkLBq8qDMoZ5rurI5oDI8HhJ2KUS1iNenI/ewrS8n8iXoH+8ctM+FoOPT++5JZkeEXabG8T0D2rz08/YM+lvt8vaT+mwf6qbUrI6gPRTbt6iEmSLBkvB/ohAjaDwfWV5ivDx0vI7NPBSoaYIOrxfCXPTN4WVhBLppOnqeT4VUpTiZyDAayFp6224797mocaslemEC+xbBx5H8r9p+4cQzMpdADGnIGalBWbTQYGVT48f3GekdEJLIBApHKdw3ln2onaGLHeUD4D0NQNwPdvMHM7FdN6UvJFtN9Lvn4rXNuY523ZSf4nwGHgobGWHHl0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 6, 2026 at 2:23=E2=80=AFAM Usama Arif <usama.arif@linux.dev> wr=
ote:
>
> Stores and loads serialize on the same per-CPU acomp request and mutex.
> A low-priority store can be preempted as soon as the compressor drops
> its stream lock, while it still holds the mutex. A higher-priority load
> on that CPU then waits until the store runs again, which can take a
> long time when other tasks are runnable.
>
> Give compression and decompression their own request, completion wait
> and mutex. Since commit e2c3b6b21c77f ("mm: zswap: use SG list
> decompression APIs from zsmalloc"), the per-CPU buffer is only used for
> compression. The two requests can share the per-CPU transform: no
> in-tree implementation modifies transform state while (de)compressing,
> and shared codec state has its own locking. Loads can still wait for
> each other on the decompression mutex, and stores still serialize on
> the compression mutex.
>
> This follows the proposal from Sergey Senozhatsky for the same split
> for zram [1].

Thanks, zram peeps :P

>
> [1] https://lore.kernel.org/all/20261005122036.718976-10-senozhatsky@chro=
mium.org/
>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Code mostly LGTM. Just one question:

[...]

> -        * If there was an error in allocating @acomp_ctx->req, it
> -        * would be set to NULL.
> -        */
> -       if (acomp_ctx->req)
> -               acomp_request_free(acomp_ctx->req);
> -
> -       acomp_ctx->req =3D NULL;
> +       acomp_request_free(acomp_ctx->comp.req);
> +       acomp_ctx->comp.req =3D NULL;
> +       acomp_request_free(acomp_ctx->decomp.req);
> +       acomp_ctx->decomp.req =3D NULL;

Hmm do we not have to null check here anymore? Does
acomp_request_free() handle NULL itself too?

For instance, taking the code blob below:

> -       /* acomp_request_alloc() returns NULL in case of an error. */
> -       acomp_ctx->req =3D acomp_request_alloc(acomp_ctx->acomp);
> -       if (!acomp_ctx->req) {
> +       if (zswap_acomp_req_init(&acomp_ctx->comp, acomp_ctx->acomp) ||
> +           zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp)) {
>                 pr_err("could not alloc crypto acomp_request %s\n",
>                        pool->tfm_name);

Here, we can success with the comp's req but fail with the decomp's req, ri=
ght?

