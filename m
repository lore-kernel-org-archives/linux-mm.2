Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 424CA606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 02:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dTxCTJHy
Received: by kanga.kvack.org (Postfix)
	id 0998C6B00EF; Mon,  2 Nov 2026 21:19:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06EBC6B05B1; Mon,  2 Nov 2026 21:19:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7C606B05B2; Mon,  2 Nov 2026 21:19:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B1F396B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:19:49 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9A53A1C27F8
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:19:48 +0000 (UTC)
X-FDA: 85392202056.01.F48E484
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf18.hostedemail.com (Postfix) with ESMTP id A7D121C0002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:19:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dTxCTJHy;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793672386;
	b=grJ6ubEZko5Facv1PjdG9lBEZ1KCe6YMcj9ao6U/KXNyjIBeqIjCizkGA/5MoYfdfAmn5N
	foj6pN81pFwP9c7bjNm8zWQXm4Yw+/Xh6nXa59Cm6AcICVGTtUIKhvXrQDcn66S037ya7z
	UIkWJqS6nE9Q74aOcLZubty7jBo44ds=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dTxCTJHy;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793672386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y+VShWs9tikJp7nMg5yS2OguM1pTvxjDCYk36G2aajc=;
	b=BfovJ/hleh+o4LOVglFENrKfPBsoKcJQj2VL5msDQcN9p2euEd11LIjSENbx3Gsq2FXsds
	LxINJveNYEQImlo8NDylgDdWV1xQGlc0FAz5cVrA8NkI0OFjSomMbWTKnfbl+FAt4luzwF
	TzRelBB5Y8+Yn+Yr5+qFZhB9zR9c9SM=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a549cd7fd2so1785245e9.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 18:19:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793672385; cv=none;
        d=google.com; s=arc-20260327;
        b=NHA1Ma1Lm0V7nPxFrwkF4pI0fzVHIJJpqvV2pwDZM1NYqkUz5x6MUTiLksu13lAIE4
         Knw84B3B4Wcaaql9LHjfxM4ROg+0ocCRwcLLyhLm/kk8dm6G/bb9M6xkoGmbDnHDrpKX
         +ahMzxyiJCfQfpEQWAo4kLOkdHcfWc3hgEHMG1Tfk8++xzOah/pC/IuFcOW8fLJpdfbm
         Blhh13Uzc1DqF33d0tcJI+ads14pBLplcqS5nrqQ+XnxsYXaItuPZOG//iMyRCsGYI9F
         JC274y1U872D3SWnQLMrY0wyALI8mMFQ62qjwImv4NvWUtyGE0TKVDRCUYwaPhWvrq0u
         0LOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Y+VShWs9tikJp7nMg5yS2OguM1pTvxjDCYk36G2aajc=;
        fh=h6SAAI678RDDXD2Xu2Ad4bzgY/ojx+B9oRcuefaw1rI=;
        b=AR6OpUFRlX3nxIw9e4aQUuMtSjtVeAw/6VoXzegAyFcn3fAJq+4saCQr5diqDlJPXi
         It8vrjXBJDFYNO4fkqAQ1EIXng06evFgqySM09Cop9vzhp37na24SjUcUbsxnVLPC+qr
         t4jlRC3wlCWb6JMsFWSwI2ZortJIwjeqcmKKK2t7QlUIxyjCApdUrTETc6QUivWgnnMb
         7kRnk4sjr07KARfV4OMlw2TaztRHw3aiX+/dhRM/CulxsHAoUvbm4GxZfuhAwU1UEbzN
         kda24g95TKncYD7sIsx9YRXxj8xvn1yLYz2NIFTuGM6IpDfPtpnMVN4VPMpOg1Vk2EVX
         0B4w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793672385; x=1794277185; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Y+VShWs9tikJp7nMg5yS2OguM1pTvxjDCYk36G2aajc=;
        b=dTxCTJHy0InpYiqGIpf7U1HEgzCqvraV3R+oyUxHZLc2s/oiucDn12eCzGlLEQzege
         DyPJlNyFBBwSdzdiqGt2n+JIKYR35tCw5zcIVtg3BLoLnXTGGiPd/rcNNeG8Imhf3oAc
         Ful3swZR1k3jexiQYnDwYKexNsRXQUZFDUjEssFWQ4exzqzbUz+rua3WAcgzY9RVynYc
         gGU3q5s6AKsfminDOQxf/Tf3tsJVyC/4kaMcvFe2x0my4QUD9X8kpdKZ9Y7v/72bbZ0F
         psOyry8Y6Zj8/kRzfi5yARwGZHwDC3OCkjlsWAJyvuBDt5dXyajP1BhuBDzClIeSlA3Z
         Bm1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793672385; x=1794277185;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y+VShWs9tikJp7nMg5yS2OguM1pTvxjDCYk36G2aajc=;
        b=wf97fitJzYlVoS842h/dYxoiQg/UIWnzvzdiIczwWqYCIcZ+LGqbTtbHfQVfZWzeiP
         USUrFXMQn0rG85iIluZ53VnaIf/ikpp/Q+WwN59wdNM7zkNVKOPf6kgRBIiJ2bqzni8D
         3Vmn2lnkR+d1IFwNTyxCCGKSsHLYL+4OTwz0g/2w8RPEhmMd1ze6aMh+kFXXpsh+zdav
         yOFt1ZsqLDMXso6IBFeNn9vYb5nAXcjup9n89hgv70j41TkEYTkr3uOPCXDKgPEqtQy/
         5NUadtmzD4v6KMT8J13IfRG14eJvpcCQZlbzgmvLhmapFunE8fnMa4yQpCAIGRQmlKiE
         lR3g==
X-Forwarded-Encrypted: i=1; AKwUvBz34oC77ebdC/ieAc28wQiS8fn3wOZZ9pj0WlKt0+YGp5VJ3nPFVtEIMHPdlpD6dN4mDzbPQoTzMg==@kvack.org
X-Gm-Message-State: AFq9FYJk2PkpYaiPBtD2WV8t0qJer2YMr5x9JeJsyniZHiox53Gp4ei0
	a83+zK+L/XXT2N31bHoKwY6/iBtXnBQzuHw9Km0Ido/doQs9xnSK+oscIYAkq8NF+j4DRRUWqYd
	MOosnYQvGm7prWD68udLKRn8wa+GuVUA=
X-Gm-Gg: AYBFou0hWvmirbRSSxVw8DP/KbGLFZDfuc8HwIUcnLZpHISXFzIjiDpKcaqbYdM2iSs
	WC58dDJd1S+0GQzGyNgav3vRF1Xjv0mZr/Ikm5Ixwxjkko4SfhFEVJ4MUjVqoY1c5XOtJd8TkEA
	X1r2B8emLu7s/kJl1YjcFWdarGhCltEWdTAoVQaeNCOIncQYWk8Igkxvp60jqLWDnFpNs5ahYM7
	V1AZghka3LWrHGonnFkg11q/3GWdcm9iP/ErYENLZ637V54K380GXWG13YTfObAuGgXs2TiPw1R
	pptecbq+7jVEdG9PyBsTVcfkG8vfmHlL4h/MEILRhXiyS1i3Z7dCadL1dqpIb0u1YZ5DO/xh/9m
	raa4FxP13hVBz3MGI7KpMxEjNtT5uQTpw+y/lYuL1dj+cTwN54StW+JhQQJgtRMPan1twT1kyDx
	CE7PEXlc7GtZXEbdsN
X-Received: by 2002:a05:600c:8116:b0:4a0:20b4:ba93 with SMTP id
 5b1f17b1804b1-4ac17e10724mr272739855e9.16.1793672384680; Mon, 02 Nov 2026
 18:19:44 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022220203.91911-1-baohua@kernel.org> <20261022220203.91911-7-baohua@kernel.org>
In-Reply-To: <20261022220203.91911-7-baohua@kernel.org>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Tue, 3 Nov 2026 10:19:33 +0800
X-Gm-Features: AclHuK-ZlSNHc_gQBqv7Q2pLdZDrXfbMg8uPwnBYk9q76TXijqjYSSVYy3bN8qk
Message-ID: <CAN_Opa9s7C_DSQcgh-r_UVkZUigN1fmaimPQpBJDg07FwiCn6w@mail.gmail.com>
Subject: Re: [RFC PATCH v5 06/14] mm/mglru: return for unavailable anon
 reclaim earlier
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, hui.zhu@linux.dev, 
	axelrasmussen@google.com, baolin.wang@linux.alibaba.com, david@kernel.org, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, ryncsn@gmail.com, 
	shakeel.butt@linux.dev, weixugc@google.com, yuanchu@google.com, 
	zhuhui@kylinos.cn, baoquan.he@linux.dev, liuxiang.277@bytedance.com, 
	wangzicheng@honor.com, lianux.mm@gmail.com, kasong@tencent.com, 
	liam@infradead.org, surenb@google.com, mhocko@suse.com, rppt@kernel.org, 
	zhangbo56@xiaomi.com, lyugaofei@xiaomi.com, ridong.chen@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 61xdyshbpp4idyxzaijqzwefmnqxj9r3
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A7D121C0002
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793672386-223229
X-HE-Meta: U2FsdGVkX1+J0g8Oy5G+9IUBPy0E6fGGh5fhYb9pT5J5gr1BHAxOR5J30xnvEiRqmBFDbVr/TyS0rbuWkbiPV+GG7K5p3zVEYZAEyg+eC0HpBS7ef4oTDT1FG+pTzuvZs4augaajECDC3lRtMoReq219oxkez5OoSZ3h7BQoN3y5e+I2vmttCuQcf+pVp6Ji97buST2zSyDZLAVPU1zwOsexq79Ybmqlc9GXteh2e2MXLAr33TgHbk8dbuM3ZbZ4IQtroMKsW5BLKv0MLungq5fJGQTw2ApwwL3tTnaMTeNkF/kGyzc++7M6kEmliL1GQbl9ROgboR1jhUF5lMT2jjCXULWU80gMKAc6jLoMgaGLCOO8HUKerGr/TQWjXwdO9/8aQAx8Yvr6hPZ1Jkbg4MrwRmdJVaX3fYeoTOnLgeZ4TrlziaNky3LGXy/P+Mu8DTzV4HRwd2FnH49Q/g3zkX4+AWfmkXTz2BuAaxHCJ0/gg+a1qelutn+yZ713l6EZIfvrTrLEnEuXFLXw9CAU19Jibvlr0lTndH7xDZvZMiO/iU82vEDgyJBAGMkn8QRGbcCmdn1U5tAXVm4juaGZ0+e2tpClMrmnsehGTgdbhKhESf4PBb/CFdfXetYTJu7pGkyhmWNETRnSf7V5LH2RKlRh08kt4Re3kmWUbxDzZ72QaNxtgDxRQDOrtq8Xe+vSsHCmOALRdXPZybDK7wJHo1RRQ+dolqI20gd29cXENA9EMrTS3By8uDLXlaFYIGsACzXHmajmC5+Lrw7Ik9CJDO6yJDLT3X7vd1ZO4WZdTskE8ocLcFODEBsvb4QVHDfnTaHiuQQ6kdwYUM5ZW0Gf5eYKYiZYYqEcEgi9mpp1z3xN3UHrYculriqM/RuYj3QajY/srwIj0gxH4w55jrNRjCgoe5C76NwtOPLpD9Ewe97iq6JcQO5Yf4aTQoljBIt2oAHHtLoHzuF+ItNquMO
 W1sm7YTb
 qidkVkYI8pfqBv0DcHg44EmZlA8G25c7Fa95B0NZMe6lDEmzczBhQzCjCRo7bAzBrfJfAZyBgmtnhxVP/71mvKnx3TllCp1QE1NoYGPz1aDBFHyixzTaUu/lKmKq0ms+K6zSiOtzZCaKRTJ57Uo6digdpC3/vzKpzrtfE4jPQu3va7XsMT76ZGjTUZullL+X9dupe/UO11Ji+npPkNeME4JX3mMdasqCDdzFvaKvEoCOqdSKeCAssX3+dQWOQxZcZQI1Aqapvpr4RPfmqFEhspP7QoB0O4lF2DqRmmby3q4Jma5nyPSY+Mazvxti3sVBQvIeHca9KsZmGGF0SERMJC0zWjrF1Dwwekh+N0ivEgpo+bNjoIogw9Dp33Ua/Alp6EsRL9vajeLtFIZvLBHY/KDPPUJDB6x9E80pTOPMINKH8vrIJnS3veJ7mki4EtZ0Dx+ahrqRw3Q+4DkMycR4zUnHIWmeWJgqjplf3hU71Mvz3XyaMEhZ7TlGppmWELUAoI1w9LCvIEqBoudDLdVccBzyQtzRrFS9Mhj0b5d3J4tsyYJk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 6:02=E2=80=AFAM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> No feature change, just shuffle some code, prepare for later commits.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 27 +++++++++++++--------------
>  1 file changed, 13 insertions(+), 14 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index d3caed8aa789..0930bee5906e 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5215,20 +5215,6 @@ static long get_nr_to_scan(struct lruvec *lruvec, =
struct scan_control *sc,
>                            struct mem_cgroup *memcg, int swappiness)
>  {
>         unsigned long nr_to_scan, evictable, sizes[ANON_AND_FILE];
> -       struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
> -
> -       /*
> -        * Proactive reclaim initiated by userspace for anonymous memory =
only.
> -        * SWAPPINESS_ANON_ONLY is set only on the proactive reclaim path=
, so
> -        * warn if it shows up elsewhere. When anon cannot be reclaimed (=
e.g.
> -        * no swap), return 0 to skip the scan entirely, avoiding useless=
 scan
> -        * work when there is nothing eligible to reclaim.
> -        */
> -       if (swappiness =3D=3D SWAPPINESS_ANON_ONLY) {
> -               WARN_ON_ONCE(!sc->proactive);
> -               if (!can_reclaim_anon_pages(memcg, pgdat->node_id, sc))
> -                       return 0;
> -       }
>
>         lruvec_evictable_size(lruvec, swappiness, sizes);
>         evictable =3D sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
> @@ -5285,6 +5271,19 @@ static bool try_to_shrink_lruvec(struct lruvec *lr=
uvec, struct scan_control *sc)
>         int swappiness =3D get_swappiness(lruvec, sc);
>         struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
>
> +       /*
> +        * Proactive reclaim initiated by userspace for anonymous memory =
only.
> +        * SWAPPINESS_ANON_ONLY is set only on the proactive reclaim path=
, so
> +        * warn if it shows up elsewhere. When anon cannot be reclaimed (=
e.g.
> +        * no swap), return 0 to skip the scan entirely, avoiding useless=
 scan
> +        * work when there is nothing eligible to reclaim.
> +        */
> +       if (swappiness =3D=3D SWAPPINESS_ANON_ONLY) {
> +               WARN_ON_ONCE(!sc->proactive);
> +               if (!can_reclaim_anon_pages(memcg, lruvec_pgdat(lruvec)->=
node_id, sc))
> +                       return false;
> +       }
> +
>         nr_to_scan =3D get_nr_to_scan(lruvec, sc, memcg, swappiness);
>         while (nr_to_scan > 0) {
>                 int delta;
> --
> 2.34.1
>

Pure code movement. Identical check, same result, earlier return.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

