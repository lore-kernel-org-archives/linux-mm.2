Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A8F7606A31F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 15:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=biQIL2Ig
Received: by kanga.kvack.org (Postfix)
	id BDE776B05BC; Sun, 15 Nov 2026 10:16:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8F2D6B05BD; Sun, 15 Nov 2026 10:16:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A81DA6B05BE; Sun, 15 Nov 2026 10:16:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 810B36B05BC
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 10:16:31 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 105861C413C
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:16:31 +0000 (UTC)
X-FDA: 85437704982.10.1E73263
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf27.hostedemail.com (Postfix) with ESMTP id C308B40006
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:16:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=biQIL2Ig;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794755788;
	b=N7FDXDWemE58sY/rDHl3osTR08GTOTWMwsWU7CRpcMp23Omakn0dD+jntzrE+hCwFBqlTN
	+KuXj5fJnjEKgCfgBkCxAbaqyMyiqsqbYxjdKN75vJp9Tba4x/DQMa8G5uwXZ5oAeXz/ad
	J6Sgs/mKxIbtUd1uC2lqlGveNmfKkUA=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794755788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/kbMdsPfYVgyvUvoYxJogO+QNz+rfnD0XbM+npE/rd4=;
	b=QScjF57r0+IlCImhK8qzwvQX4LvWL8FrKhAbs0RpKyP7z5dMhZuQ4hU1uWCbWmKc3xnYHn
	YgatFX8IKZFYL5iIXrJBdR8xa6GgXFQ5gaOk4nSvXh/TeCSZr32vteWXYQ046DHHpRrgW8
	Q60JkgUkeSeixHuoyXJV3UyY3i/epds=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=biQIL2Ig;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8b9c51097e2so1125469b3a.1
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 07:16:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794755787; cv=none;
        d=google.com; s=arc-20260327;
        b=QxmuU11mIoKI+oXtk55luwtqfk3OQC+dxJCvyJFmKMnxJh0LSd6VM45VW92q1gN7m0
         EjgQDr1XCuIZw2BMswrxzbnNfGPNU+FJZ71XfZoLGupWgv3QSbdkic2MHJmLPL1mdkd5
         zVJfRton9LlkZhPUvROKvH5z1SCHKTHH26H8nNbtIvJyzIVNz8x09yB/1RSvVfZhBBSn
         Uq4HttoPLJdzn00B3BI6UlYlvhL+VoLccW7dkZczBTJ7pcElxct9oFnQjJWrcgh9LhVu
         ZLD1oQ72ktVJqZwd7Y4mBTtlDHDQi12S/T/TMnJ/EoR0zjCd74Vm1F2baMdrx2jWEgKC
         sZeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/kbMdsPfYVgyvUvoYxJogO+QNz+rfnD0XbM+npE/rd4=;
        fh=v6JHIzaO47VIY7ZqbAdIUUZbxe1UUm6CB6kG7n62JJI=;
        b=J3M8lgZgBcHZwNeHreb5Tn0jsaRj7TktQ7zQhU5JyTLkHd/jyPfE6pIHem9UR0Dzeq
         0VsUkkOQw5fYnvs67NbTgUZNGHLaAOtCmkj8ES973OEDNDUpLzavD+prnTKtnBNGBAWo
         3PuUXFJeDwxV+FK9z4bX2NMvccQO+WYJLjaxTpvcW3A62apO/NVWPClJ2yGiil3g7Wmo
         WroRDRRuYCDgWSvE32Tlros1UVF+peOgZc3yZkU8nhSmoQYIPJVOEYChyY4UhXwYN00A
         xzjLoEWa5jkaWJJrfzqvQYDtaarJSj40uWBcYog1i49x/+aYyn6+1IdQnjgc9uFTDeAc
         51Hw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794755787; x=1795360587; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/kbMdsPfYVgyvUvoYxJogO+QNz+rfnD0XbM+npE/rd4=;
        b=biQIL2Ig6kiB8776ra+D+uiKqL1ANYxCtcaCB/NZTySeaPoKpOmn5w07b0T5/vJyZs
         VVIf5a03kzRqiR2JJkTqmLeL9w7zqJePjymU7FuHZKpIUsjiNxvP7CS4EVN2SYSYNtWm
         sShm2AVVxWfQBA07qyMohvOfYMK9a5ybjr8dAuaE8SCpEm/3VqfZ4Dor6LAsrkjtvPso
         X8d/aJzqwjszl6OoLLbvBSuHN8pfINIDzlJrLmOnJo82tkPQaYdtzCTXeOOIMgOzxOI8
         AjhMqyf2QpSXCVxzWHVcm6W2dFVOIIqI422NWrLcrYznaYucXj3l5DDKRiiDosbrsOhf
         eexQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794755787; x=1795360587;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/kbMdsPfYVgyvUvoYxJogO+QNz+rfnD0XbM+npE/rd4=;
        b=ph9Dbb89KW489IuHhGfJvqD8thsx9RYDR81FtAjqlOKNuN5Zxgy0YlG8tIp4xBECE4
         wPioxEeKfnXVh2ldgIv+aSE2hiwpo38Ra+JcRpbXofnjIStL3ElIQ2jaIGL4vD1itPJ3
         MTv0TafPKgwwxbHsAUOZp6AFl74Is8mJix5MESA5NkLq3FzLDu3An3Tit02SZli0e6b4
         jaQICvY0mxNiLKF8hFrShoHBa/2Wu0VNE0RlgY4OqBDybmmHvK8AlhoCe+s+YCxmgARw
         JCTH2/tk3tgYEMNzIiPEnZH39HlHndRM2A11ISQwJKIdMqx+cn5xIyiQ5URR1WxFXTqu
         JQVw==
X-Forwarded-Encrypted: i=1; AL+hErHdPhMAhMpZFBhtMAb8R6xjNfpP4EeyuZy1ZcHYs46nkQ5ivjIO/QFmZFAS03wA4SgIj4LFpn4Yww==@kvack.org
X-Gm-Message-State: APuU4Z9+oww7dbgyn5rRHz8lgS2cQOnlSKb+oBxAD6KEeJjrz4QmiJxJ
	vUFGJuUDasbEqo3pr2MIFEB3yov8A5QWz1XUV5BeKUTbYup3J/aziDxNjE76XGAzZtFFPfhIncK
	tSZRkGPn3Wi0gaca+QyiQkbUtuNcIEzc=
X-Gm-Gg: AYBFou2W6AiRmntR3sHSDAFHw3XqJO8u0ipAD0HDbmBN/7+jcuhBjFv+dMgA9TATlV1
	0m5qVnesO0DFCjradmIwcoRrNpURlWxvGvOxCe+pAuFmdN1IWNeNCr0kt+61rvBGTTeJLhoLDbB
	QyOwBSqxyLX2niFqy1QArIAunk/sAS1V85XhFBCE0yts7qIrbAszQngN+1HVsuR9kzqwnuK1gGn
	MJ20xhb1Y/3fll+1hV1NQ5ThRTFq4pBEW3UCzcsq5i6JHg7t4t+sGiT4p+c8YrCrr17tldiupP/
	nmw316jsR4tMX4IGzkze0nssHz77yAJYtr0Owy59CohM4GASvwMgAsT3FVKZV2wofWRFV7QDM78
	oGI+xHtqbqpFsqgLvpMINdkih80xrbJYuDlsp2C2f4aWlq+hfRmTVx1ZhxRnuSFDdURALJA==
X-Received: by 2002:a05:6a00:1821:b0:8a0:7140:7fbb with SMTP id
 d2e1a72fcca58-8beb7d1a49amr7332511b3a.51.1794755787247; Sun, 15 Nov 2026
 07:16:27 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261114200803.23129-1-baohua@kernel.org> <20261114200803.23129-10-baohua@kernel.org>
In-Reply-To: <20261114200803.23129-10-baohua@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 15 Nov 2026 23:15:48 +0800
X-Gm-Features: AclHuK8XlLpyFj9N4Jv-bPNR15WiG3Gcs5zf45ZlS61R4q4PyKBnJPk7NkVtd_c
Message-ID: <CAMgjq7A1dWJ6DoF6+CxfjysxjzAChWrdk=z_JvtLMyFWdoYTyw@mail.gmail.com>
Subject: Re: [PATCH v9 09/16] mm/mglru: Avoid placing rejected folios below
 populated gen
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, 
	hui.zhu@linux.dev, kunwu.chan@gmail.com, liam@infradead.org, 
	lianux.mm@gmail.com, linux-kernel@vger.kernel.org, liuxiang.277@bytedance.com, 
	lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, 
	ridong.chen@linux.dev, rppt@kernel.org, shakeel.butt@linux.dev, 
	surenb@google.com, wangzicheng@honor.com, weixugc@google.com, 
	yuanchu@google.com, zhangbo56@xiaomi.com, zhuhui@kylinos.cn, 
	sidchintamaneni@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C308B40006
X-Rspamd-Server: rspam12
X-Stat-Signature: jrqr1jesbcryedzq3eyrypnbskmi9kkw
X-Rspam-User:
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794755788-221917
X-HE-Meta: U2FsdGVkX18N7ay87Rjlq/kPShaM0Y8+k5CjbYFekrRizOj804CvH62NrLDZ/ycNsEysg3dOFp6YndDyOLeJlPcHK/IbeTJsvzWcpL7zB2gvGIWb7l6HW3K4nJRf3GvaHFWfRn23LA3hW+s/9JD8Ola4XfaDav7hoqgAqo7A1wCaUxg2gfT6Amda/4SJq4Su2i4MFw3RPzTkT4enmowBkX3bmR17Ltc1LgBMdnZ8/rUafsDzWCW7XsycLIIP9y3TkxvGHpL75uZQKH+ZNJWltXvos4uU0UWPe/Fbs/RVFgcemPetwprhDXY5bJ/jXq0qipQ7+NWo/A3+Aii1bVnZ5ZjvjLd27HLSE7xO7lBzS6Z01B84aWhX83FhG8zUYb9mUFVJwFprv0JpiFi+43/uvvHUSnrcVBbRS32EW52wg3EgfP5sbfO/J6aHSzEu5rbp50cwr4xhdCQK49607Xex11AmW7dE2Bm6Woj1qYEbNPRhZ8/kzv58wePxh6yzIk6+J5p1fDidTwRcc5JcPY6fwA/MWfF/jc+kWS8ndfkf57VTi7X92Zb8qs6V0UZdX3/uXNJjOQUpBUklKnTICvKnsS6pkjrXeBip4QG/CduL5IJt+AEuTjFeSGATr2wngTRP/gYwAxnfQuo5SObwddgefa8xj5p2m5TDPi0b9NYJtMJWzPbCPkltsWxW9vU37/rYtnfSqPiINCnawJ59TLhzPIjXw5cDg+tX8oiEhZ8OGM26/6J/s/vo2acLJ5X3ym9MM1JaNQYzd+o5tNpTMHg9M9pceTlToP8g99lMA6mDsEmtVIFzgvJkoGzQcoieTgFkXnBxFfnK4ql39ioW/QhuB9hm3My5CpdXvSJfQxDB/euNBKU51lvh0PwSow8w/axx81nV93TNWTWsXnjGsonBMHVmQpsSuiDEVqfgdgz0bqQ5MCj+ns28g11oL1daUZDWUz/R3h7E6fVufZ6SWTl
 UaBldVZN
 UFldBtai9fTI3XNDg0hTzuYMFRTlnjyjQ1QInsP4OyGYitzLqZ4YBbvzZqAiAgQck41xyicTpTMoLKdFKYgcDdCIrO84tSxpeItXuKCKQHWa77HQmyZ5uLmGCUA5/ktVDk/enSxpKaRHbEi/n7IhL6wAhYV5iyWKbTeYI1ymzbaEK+Wh4GqUQdJ3W2pNU4L5vTZ4z0kDeRecHu7dcvlPtqg3EjXzo1bvjhc1rOpWFh+qsJCjOfFmOazpjQwI3fiqKrJ8mNXKF9SGYOM5ArlVZiIZR8C8MFD6GoIFgXLSDlnIfyv/53vVWo0ePjfK7aEvrfZ2+hAWh9TCPZLhuJ8Ar6RpCxF/nXsIcl67ropYsl5IdkmIFihU12ROBrEnqATLsmitcJ19+LS5iQ6rlIpkDKfsUTca9UYXIIfHFD5k3+14O4+nugVs9PqbvXEeGTHMyOo5gUipNP/nXjqacHEqz//wsm6GTXTwD63M6Kn9POc9nYPgXhgAa3/qQPjrE/1Nhdb8ZKH4g0D1XBfYsQmHROHII6bb93VhgtgkjH6mGoIEWH3PYJT8TIwnnH6GH3EYWdSa7aJ68TG8J/6JQLa2vDXj8vDrX0MFCMndFub8qNExcZLl9friqEn8sAzHAkeuSp5D/F1j5T4JW8o6HfEosgUKkViUmAs32aGkeD6xzLE8PZNzajVwFtlRuzlsWu52wVv0c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 4:08=E2=80=AFAM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> We used to scan only the oldest generation in scan_folios(). In
> evict_folios(), we checked whether
> lru_gen_folio_seq(lruvec, folio, false) =3D=3D min_seq[type]. If so, the
> folio was marked active and moved to younger generations.
>
> This was itself buggy, as folios in generation min_seq[type] - 1
> would not be marked active by folio_set_active(), potentially causing
> a cold/hot inversion.
>
> Besides this issue, the old approach also differs from the current
> behavior, where we can scan fewer than two generations.
> Now that we can scan younger generations, including the youngest
> generation, this no longer prevents rejected folios from being placed
> in a generation below or at the populated generation. Such rejected
> folios would then be scanned again and again, resulting in extremely
> low `pg_steal/pg_scan` ratios. For example:
>   pgsteal_file: 2312605
>   pgscan_file:  36465693
>   reclamation efficiency: 6.34%
>
> We pass `scanned_seq` to `move_folios_to_lru()` and make sure we either
> promote the folio or place it in the youngest generation when the
> populated generation is already the youngest one.
> Also, folio_set_active() is no longer needed.
>
> With this change, the results become:
>   pgsteal_file: 2683815
>   pgscan_file:  4224244
>   reclamation efficiency: 63.53%

That's a really nice improvement! And I have seen the rejected folio
got inserted to wrong gen many times, this will help to fix that too.
>
> The sys time for building the kernel also decreased from 4m30.532s to
> 3m50.188s while swappiness=3D=3D1.
>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> ---
>  include/linux/mm_inline.h | 22 +++++++++++++++++++++-
>  mm/vmscan.c               | 24 ++++++++++++------------
>  2 files changed, 33 insertions(+), 13 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index ab69b9930893..f6f4bc9a704f 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -332,7 +332,8 @@ static inline unsigned long lru_gen_folio_seq(const s=
truct lruvec *lruvec,
>         return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen=
->min_seq[type]));
>  }
>
> -static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio=
 *folio, bool reclaiming)
> +static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct fol=
io *folio,
> +               unsigned long scanned_seq, bool reclaiming)

A little nitpick: I think the code will be cleaner if we use "long
min_seq" and get rid of __lru_gen_add_folio, caller of
lru_gen_add_folio just use -1 as min_seq if they don't have a specific
gen limitation, but we can just leave this as it is now to avoid more
chore update of this one.

...

> @@ -4991,7 +4995,7 @@ static int evict_folios(unsigned long nr_to_scan, s=
truct lruvec *lruvec,
>
>         tier =3D get_tier_idx(lruvec, type);
>         scanned =3D scan_folios(nr_to_scan, lruvec, sc,
> -                             type, tier, &list, &isolated);
> +                             type, tier, &list, &isolated, &scanned_seq)=
;
>         nr_isolated =3D isolated;
>         if (nr_isolated)
>                 __mod_node_page_state(pgdat, NR_ISOLATED_ANON + type,
> @@ -5017,8 +5021,6 @@ static int evict_folios(unsigned long nr_to_scan, s=
truct lruvec *lruvec,
>                         type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
>
>         list_for_each_entry_safe_reverse(folio, next, &list, lru) {
> -               DEFINE_MIN_SEQ(lruvec);
> -
>                 /* move_folios_to_lru() culls unevictable folios via foli=
o_putback_lru() */
>                 if (!folio_evictable(folio))
>                         continue;
> @@ -5037,11 +5039,9 @@ static int evict_folios(unsigned long nr_to_scan, =
struct lruvec *lruvec,
>                  * so this effectively promotes them by at least one gene=
ration.
>                  */
>                 folio_set_lru_refs(folio, 0);
> -               if (lru_gen_folio_seq(lruvec, folio, false) =3D=3D min_se=
q[type])
> -                       folio_set_active(folio);

Nice, this part is causing trouble indeed.

>         }
>
> -       move_folios_to_lru(&list, false);
> +       move_folios_to_lru(&list, scanned_seq, false);
>
>         walk =3D current->reclaim_state->mm_walk;
>         if (walk && walk->batched) {
> --
> 2.39.3 (Apple Git-146)
>

Thanks! Looks good to me.

Reviewed-by: Kairui Song <kasong@tencent.com>

