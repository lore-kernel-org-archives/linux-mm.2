Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49C5D60A2605
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 09:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eHfpfDzH
Received: by kanga.kvack.org (Postfix)
	id 6D7596B00EF; Fri, 20 Nov 2026 04:42:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AEDC6B05B0; Fri, 20 Nov 2026 04:42:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59D5A6B05B1; Fri, 20 Nov 2026 04:42:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 355F96B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:42:12 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A4C76A0E71
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:42:11 +0000 (UTC)
X-FDA: 85455006462.22.2B722C9
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf05.hostedemail.com (Postfix) with ESMTP id BB58F100003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:42:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=eHfpfDzH;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795167729;
	b=SMV9gqg1KFmPAlEq5p1/PGNoywPdUfljYD5+OCtY4vsvtsGL2nBqozDqLuzq0MCz03Ah1T
	yWcRIdNd2GF/JnM6Jb43aOaKvjS44cOrPg/hUUv+CgQo3a0TY42+lk5W0gIGnZqBjoqLwC
	rHPT91ps43AqjwGwLzuLjbKmav+hP+8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795167729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nJLDjnNZ35RdFcdsO967xBDkpagvrglUg9dZPRYG/C8=;
	b=CkNRzOIHp+qNoH7Z6ui/cXg4jUIpqRvUib0YqeFeyIX71FTKFJlshXy+Jr4phm+eyn5+C3
	9EGKAy9jJf0rIggbAjR/cVx/CPmiO+D21PrOmAbLcgkSyBKCTVt3U57Bk6beKwUbiuGDB8
	/0vXg8VjNKtDQ0acEvZEEAlQTHzTBZc=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=eHfpfDzH;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4bb68c197c7so7853615e9.1
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:42:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795167728; cv=none;
        d=google.com; s=arc-20260327;
        b=RNMu4NEInzcTaQQkwAvmvdnCud0W6SnFI4JFXCtoGEDdsjfmdH7g6cYjL71b4o5SgM
         1jeACQXOkg4K6KCMEgH5NEoXukQ2gTPpvcsCr42k/OtnrVciC/c2ZbZAieT+uipVUgwP
         iOWKprPxCbFsNhC4Ri2Okg8j8NR0qZlwVCfgmM9AbOdc89ddO0rg880ZJolSqTJlV3Yj
         UicFv+j+1PIMWubWp6lqCormUFOdRJSRSBgDxdGVMSuHg9PsEvF8nNrw3CZxhEouCtT/
         Gx5AEYg5lf5Jk5qws5tzDh6tXl5dHtsSi+p0BItcITDw0NooUmSFMMZulZeRP4FUrsIS
         ouEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nJLDjnNZ35RdFcdsO967xBDkpagvrglUg9dZPRYG/C8=;
        fh=01xpVHe4kda/rS6+PGv7HHxY0OOMMTM3Wu/tKcvhHys=;
        b=W0Lu0w/aNs35XBKReb/PFBfCRov3gSCBb1EUO60k7RH+DVVvD5Bw33rMljtsmtWdph
         QFMYrxqnab6j5/XCWhL/VoLeREaGw3BTGehW7ubpMpM2U4CZnz2E3Y1WAU+UXNDgHZuD
         phwxEDPyLFXwyFS90WR1RTh66SK4TJqiqxBZm6pvqPKAs8aPzSJM9b5QYWA+404Nqc0k
         KLaYYLnXT5MsBdtf79SVobaKjxrWXY9LOClxFl00jgQ9GpB+6WwUXMoTzIAuZvb6YIZ0
         NpsuSe3TqIe2DVYXomCckjdvM7NdyJMrVfJrXIUxfivBUOH+WxJiNWUMHCP6G+0dG0c3
         7p7g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795167728; x=1795772528; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nJLDjnNZ35RdFcdsO967xBDkpagvrglUg9dZPRYG/C8=;
        b=eHfpfDzHdWW6GPCDsHF02pK6azphtJV6LRLtLDjX8T040mU3X6b2JlaW//3ZlhvSTE
         +07C28LQUm+PDiraKTc3o2F/MjDdRrCJqxzXwPBtgzOyG6d/a5Z4PFV/VmwfdklkOND0
         Rg2SBMB34Axt/g3uYxJ13Us7wL4bPjtFvgRhlDp1kUpxmFMu+5W8J8aY6/jjb2V2JJfQ
         ENKSR0GaXdBRu/t4LE+oryYslKAjwkbD/gDTy5LE8ZjdqbAa8X+DOZjssgshKwNvUY1e
         urylOyWANdaL68scKTEzsLU/mxOkc7doYn0NT/ckc/MA1ZQsbJ8GQa8To4qNlhLw4DT4
         0bcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795167728; x=1795772528;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nJLDjnNZ35RdFcdsO967xBDkpagvrglUg9dZPRYG/C8=;
        b=2XhFNHMCtF2ULMh0/lpIm0tqMKB5SBrfLnU6J323zalJQfq0mYU1ipMIHqdt7SO4cW
         F2EtoXliOgAtn77YgJ+GDdpom1IQ5pZtwo0Aee2VHAEZ5hHOR1LmD1SxtadXgKr8a1NP
         aHwuEmfxOw38V+cPPmRUKnW1qVpEApJOGa6iXayEtZ8tMRJCNor41poYXH02ReGtIdgF
         AvfrtmM1M+EuXvUjW0xQSyqvjY2fCxlqw2QCvJm9YWS5Mr/yIUevrpSFE3+x1j3YVM3t
         I2FkxF/PRXXBYKaQEVhZo/Xuy4is/RBiFc8+lCW8zVVmoHPCHCcy9yr6eQ++JoRoTMzL
         OtHQ==
X-Gm-Message-State: APuU4Z8KodJsWr5uUF+K/zSahHqAngJLrr2AwaOxK15ZlaXvktaNeFIJ
	F/yvGOUsLbWqvM7jiK1PDHWhDYFbRZ2Hzwt/pIZYyBA61oR/xWn7coFG4Z9VXo8kr03uE8f7H0o
	U0TQd7c0OAfmjGRkg3unwasAsdJOMdK8=
X-Gm-Gg: AYBFou03UX+kaWFDkhbleGpeVsr1eFm+314iMBRIqOa1Dy3HnfxIfKOER7O7v6HUWyS
	LSR+8a/c7x7nihhcPHZqx9oD3cwP3UFjRDd/YTifMN9SEaDoLoAthp7e6Bex/DcarXGnqL22I/A
	k4gNNWSpambNwl1wHir6g1zbLmTnbpoFVL1BsUmsPpbW9r264v2JJ/M+gM+JwDcOKmwa0OJte/r
	lzJ8AlizTX8iD1tG1zpRrsZx9dZk1c5Yebu2VlFoTx6HEIt1HeYzxvWGpeBgSVvpTA2WiHMcrXG
	DHY7rwlGQ8jsQ2iL6XbWi7oZjj8YH5jZQoATYmTS1hhojdcMaE4jiT637ftn0gCCKRDHMDTs5Lh
	nxSLm05BFnOPUCyV4m6GXqZv3C9txt2Vo50NTHomj2B0=
X-Received: by 2002:a05:600c:1d1d:b0:4bb:73ad:c1f0 with SMTP id
 5b1f17b1804b1-4bb88812b0cmr58328185e9.23.1795167727989; Fri, 20 Nov 2026
 01:42:07 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-16-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-16-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 17:41:54 +0800
X-Gm-Features: Aa3M54oYjUSUM675Gm3euCp0JmfduimCijFMBt2l5Ov01ZX35R428bhh5tZMXzI
Message-ID: <CAN_Opa-+nb0vxQ+HsENCG2fEEMZoxG9Sy_DBC4CLkWjNLzDWKw@mail.gmail.com>
Subject: Re: [PATCH v5 16/17] mm/mglru: make folio_inc_lru_refs lruvec lockless
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BB58F100003
X-Rspam-User:
X-Stat-Signature: ygxi48ae3r3sn997gx5ooozp1kc3psf8
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795167729-356339
X-HE-Meta: U2FsdGVkX19hbkUb/5MyesoP2Q8bdCdYr2rXRxg0npHwpOnRzcN7FrcMVZuHkFL7eEUYOHRquiAVjaBUjDBspNezIzKbhFZb6IO1DysmtpYKQVp1dRpC//xpR15reK+e66NweJj+ybrLcpwN282431Xdq85mhB+SRp4qXTdmwsBb/hDj2/LvLXL+UdfayY+oR7KJzeY1rE5DNOAh8yOn0zysmorJalCzSCD7LWg3hTpTKA1WTZVAk1XagDa0IFY8gUeRpnGclpAW64dPgJDudjt702unWxPeShe3cr2iaxcGi+XgTub/E+Cwjp4ROXZy0N5jnsfGaVYzBk0B9GUPcp/P2uVF4TjP/RzQ3CV4NhvEEoR7WeP07US5ROZlWzJtkizZX8vTVO/2a9Frhh5lDoJBvlZDX6m49vkQRtMKrgVDF0xhbGY+xixu95CVRtZJw9moO3GFF1mfvJGYOQnPGsIMgr7h+ps97l9ZcRLVBlL8hYyjZWE10OzUpgCJkl9QP+UvIpJ/ERWLWmoiE4nsY2KoV6l9xjtEO5DodrVueTU7Efx4Why+W5odA8cEWDergevN/yiaRNII2gIjL+gul7xoz2sx+8uKmasr6Y4gzv2kF/LHAuFRUwh6bixUrc1heXP6dbAFzU/qK1ENmG23UdvDNsga3nPxYR6WFRR8F94rL6VrIy7JAswZ9DSQqUhVHkCyCjfn7zl5GveCGaZo69RZVMgJYSZ1+BYG8S5ybDboorPiEtJ0vP5cbo2yY+e64ANPuigw6cEtGBSPrO9nfjAfnYtOofZ6W/nkvWysdje7sPLpYic/yks6QNZrTfUXTB1ghLNF4t02G5k5dP2IMALTP+Vq/SU9iq2dJaLhUCF8i6NhZpsZMR2fLIrzH1v1Ow/ym5hCgTl0XZ+IT5wjzT3Py4M+vchLUzXOoYdO9gikZdPMfSLENZppYtMV9Lj5ByQiMjjsL58Sl5TsccZ
 x7iVWVAo
 SPnnUdeMgSXWq35pi5lmwiVL3n97+xhmOs3aljMSvwlp31UuL0pCitiOufmkz/I5VLmtX5LrcQXkotl6vHZGXE0+nhnNDXyF7YwmhgA2mmBAqlOmWiKRspoWay3T7rSWDcyOdbtHY800UFIdxBFx0qgyYyeSbe+CL1et5Jlni9tVteWdhupMJgpRD791DAEVcGYWBuq4eNO7Y0IbHdbCg14v8JFWFwVdCD3qfl9jKu7SPzEO47zXgHt4jInglLgJBDE/Rz8cCYPdTS4FGX0AYbYx9cZ6UagZIMbiA6STvdrs8Iqyu23KEWOn785jtvrBIQMj6Ivw7AoSXKEOdOwvU1rfpHb9szfABNZwFTUaNrWIS8cWeqk4lTiSKs8GlSKurNQAhlD+nwPcy4kFTlscfz6IvwTx+x7ad3UdDRrsibOOKXw8R6sPZa1jqLIs2jztjHOhuwjVA/s8Jm4YkQBlR3aaRWDHS6gV9CvXkX3dOH570o1xXXeBK/ycUNQDg8tQK6ckzuaNzkZXyv6x71ypwpH7/uyAwgWwZmJOQ04rm4GFoGPNA8V8FxGluTqL0zqW3sI5Ig5FwEj/QAgFPA9SRZWyqd+UC18Gd87IqW9kwZmCYlwIdz4cy9vPiPXZKhQTsn4uWMVZWUmzUJ+Zktzg0ANuXhiLDBIHxUset2SP0JvDXpwMo8mJpsrY7dR8y7m0USC0r92UNQrCHCcFG1FmLHMVykguPnvvTsm/XCCq+HZNR1v9RC90Bc3wZfaFTBWH8bvtK6EZm7SAGhOwaOpi5b2VXSoxksJWBsONL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 5:04=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> The lruvec spinlock in folio_inc_lru_refs was only taken to keep
> concurrent aging from corrupting the size counters.  This is no
> longer needed: the per-generation counters are atomic, and the
> active/inactive ABI counters are updated per folio and linearized by
> the CAS on the folio flags, so concurrent aging can no longer corrupt
> them.  The same argument is what lets folio_reset_lru_refs() update
> the counters without the lruvec lock.
>
> Use folio_lruvec_live_get()/folio_lruvec_live_put() to hold the RCU
> read lock around the lruvec lookup, and drop the spinlock entirely.
>
> Without the lock, aging can advance max_seq while a promotion is in
> flight.  Generations are indexed by seq % MAX_NR_GENS, so the folio
> flags can return to the value read earlier and the cmpxchg succeeds
> with a target gen computed from a stale max_seq.  Recheck max_seq after
> a gen-changing cmpxchg: if it moved, account the committed update and
> retry with LRU_REF_FORCE, which promotes the folio to the newest gen.
> The retry may count the access twice, which is acceptable and avoids
> folio_activate(), whose LRU lock causes latency jitter.  smp_rmb()
> orders the flags read, including the one returned by a failed
> cmpxchg(), before the max_seq read.
>
> Also simplify the post-CAS accounting guards: gen is only assigned
> non-negative values after the old_gen < 0 early exit, so gen !=3D old_gen
> implies gen >=3D 0, and lru_gen_update_size() needs no explicit guard.
> The active/inactive ABI update keeps its gen >=3D 0 check because an
> off-LRU folio has no lruvec to update.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h | 10 +++++-----
>  include/linux/mmzone.h    |  3 ++-
>  mm/vmscan.c               | 51 +++++++++++++++++++++++++++++------------=
------
>  3 files changed, 39 insertions(+), 25 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 77f514143266..2c6cbd0df686 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -317,10 +317,9 @@ static inline bool lru_gen_is_old(struct lruvec *lru=
vec, int type, int gen)
>                gen =3D=3D lru_gen_from_seq(min_seq + 1);
>  }
>
> -static inline void lru_gen_update_size(struct lruvec *lruvec, struct fol=
io *folio,
> -                                      int old_gen, int new_gen)
> +static inline void lru_gen_update_size(struct lruvec *lruvec, int type,
> +                                      struct folio *folio, int old_gen, =
int new_gen)
>  {
> -       int type =3D folio_is_file_lru(folio);
>         int zone =3D folio_zonenum(folio);
>         int delta =3D folio_nr_pages(folio);
>         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> @@ -399,7 +398,7 @@ static inline bool __lru_gen_add_folio(struct lruvec =
*lruvec, struct folio *foli
>         /* use the refs from the atomic snapshot to avoid raced update */
>         refs =3D lru_get_refs_flags(flags);
>
> -       lru_gen_update_size(lruvec, folio, -1, gen);
> +       lru_gen_update_size(lruvec, type, folio, -1, gen);
>         if (lru_refs_is_active(refs))
>                 lru +=3D LRU_ACTIVE;
>         __update_lru_size(lruvec, lru, zone, delta);
> @@ -429,6 +428,7 @@ static inline bool lru_gen_del_folio(struct lruvec *l=
ruvec, struct folio *folio,
>         unsigned long flags;
>         unsigned int refs;
>         int gen;
> +       int type =3D folio_is_file_lru(folio);
>         int zone =3D folio_zonenum(folio);
>         int delta =3D folio_nr_pages(folio);
>         enum lru_list lru =3D folio_is_file_lru(folio) * LRU_INACTIVE_FIL=
E;
> @@ -452,7 +452,7 @@ static inline bool lru_gen_del_folio(struct lruvec *l=
ruvec, struct folio *folio,
>         if (!reclaiming && ((max_seq - gen) % MAX_NR_GENS) < MIN_NR_GENS)
>                 folio_set_active(folio);
>
> -       lru_gen_update_size(lruvec, folio, gen, -1);
> +       lru_gen_update_size(lruvec, type, folio, gen, -1);
>         if (lru_refs_is_active(refs))
>                 lru +=3D LRU_ACTIVE;
>         __update_lru_size(lruvec, lru, zone, -delta);
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 2680e15b6de9..235fb04f8d78 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -540,9 +540,10 @@ enum lruvec_flags {
>  #define LRU_TIER_MIN           0U
>  #define LRU_TIER_MAX           (MAX_NR_TIERS - 1)
>
> -/* Access source flags for folio_inc_lru_refs() */
> +/* Flags for folio_inc_lru_refs() */
>  #define LRU_REF_MAPPED         0x1U
>  #define LRU_REF_EXEC           0x2U
> +#define LRU_REF_FORCE          0x4U
>
>  #define LRU_REFS_REFERENCED    0x1
>  #define LRU_REFS_WORKINGSET    0x2
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 78a1b4de7076..4576a7a369e3 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -876,37 +876,35 @@ void folio_inc_lru_refs(struct folio *folio, unsign=
ed int flags)
>         long nr_pages =3D folio_nr_pages(folio);
>         struct lru_gen_folio *lrugen;
>         struct lruvec *lruvec =3D NULL;
> +       bool aged =3D false;
>
> +retry:
>         old_flags =3D READ_ONCE(*folio_flags(folio, 0));
>         do {
>                 new_flags =3D old_flags;
>                 old_gen =3D lru_get_gen_flags(old_flags);
>                 old_refs =3D lru_get_refs_flags(old_flags);
> -               file =3D folio_flags_is_file_lru(&old_flags);
>                 refs =3D old_refs + 1;
>                 gen =3D old_gen;
> +               file =3D folio_flags_is_file_lru(&old_flags);
>                 if (old_gen < 0)
>                         goto out;
> -               /*
> -                * Lock the lruvec if the folio is on-list. We are alread=
y
> -                * doing lazy promotion so in theory we don't need this,
> -                * but for now, concurrent aging would still corrupt the
> -                * size counters.  This is a temporary limitation and
> -                * will be lifted very soon, so the lock here is not a
> -                * performance concern.
> -                */
>                 if (!lruvec) {
> -                       lruvec =3D lruvec_live_lock_irq(folio_lruvec(foli=
o));
> +                       lruvec =3D folio_lruvec_live_get(folio);
>                         lrugen =3D &lruvec->lrugen;
>                 }
> +               /*
> +                * Read the flags before max_seq, paired with the store o=
f a
> +                * gen, which samples max_seq first.
> +                */
> +               smp_rmb();
>                 max_seq =3D READ_ONCE(lrugen->max_seq);
>                 max_gen =3D lru_gen_from_seq(max_seq);
>                 if (old_gen =3D=3D max_gen)
>                         goto out;
> -
> -               if (flags & (LRU_REF_MAPPED | LRU_REF_EXEC)) {
> -                       /* Promote second page table access or executable=
 */
> -                       if (refs > LRU_REFS_REFERENCED || flags & LRU_REF=
_EXEC)
> +               if (flags & (LRU_REF_MAPPED | LRU_REF_EXEC | LRU_REF_FORC=
E)) {
> +                       if (lru_refs_is_workingset(refs) ||
> +                           flags & (LRU_REF_EXEC | LRU_REF_FORCE))
>                                 gen =3D max_gen;
>                         /* First access only defers eviction of an old ge=
neration */
>                         else if (lru_gen_is_old(lruvec, file, old_gen))
> @@ -931,9 +929,19 @@ void folio_inc_lru_refs(struct folio *folio, unsigne=
d int flags)
>                         break;
>         } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
>
> -       if (gen !=3D old_gen)
> -               lru_gen_update_size(lruvec, folio, old_gen, gen);
> -       if (lru_refs_is_active(old_refs) !=3D lru_refs_is_active(refs) &&=
 old_gen >=3D 0) {
> +       if (gen !=3D old_gen) {
> +               /*
> +                * Gen-index reuse can fool cmpxchg(). Retry locklessly, =
accepting
> +                * an extra reference to avoid folio_activate() latency.
> +                */
> +               if (unlikely(READ_ONCE(lrugen->max_seq) !=3D max_seq)) {
> +                       flags =3D LRU_REF_FORCE;
> +                       aged =3D true;
> +               }
> +               lru_gen_update_size(lruvec, file, folio, old_gen, gen);
> +       }
> +
> +       if (lru_refs_is_active(old_refs) !=3D lru_refs_is_active(refs) &&=
 gen >=3D 0) {
>                 enum lru_list lru =3D file * LRU_INACTIVE_FILE;
>
>                 __update_lru_size(lruvec, lru + lru_refs_is_active(old_re=
fs),
> @@ -941,8 +949,12 @@ void folio_inc_lru_refs(struct folio *folio, unsigne=
d int flags)
>                 __update_lru_size(lruvec, lru + lru_refs_is_active(refs),
>                                   folio_zonenum(folio), nr_pages);

Could this leave the parent's local active count too high?
Isolation can debit the child's active count after the refs
2 -> 3 CAS. If CSS_DYING is set before the stats update, the credit
can go to the parent. On SMP, reparenting can clamp the child's
negative local count to zero.

Thanks,
Kunwu

>         }
> +       if (aged) {
> +               aged =3D false;
> +               goto retry;
> +       }
>         if (lruvec)
> -               lruvec_unlock_irq(lruvec);
> +               folio_lruvec_live_put(lruvec);
>  }
>
>  /*
> @@ -3517,12 +3529,13 @@ static int __folio_inc_gen(struct lruvec *lruvec,=
 struct folio *folio,
>  /* protect pages selected by the tier PID controller */
>  static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio, int=
 old_gen)
>  {
> +       int type =3D folio_is_file_lru(folio);
>         int new_gen;
>         bool gen_increased;
>
>         new_gen =3D __folio_inc_gen(lruvec, folio, old_gen, &gen_increase=
d);
>         if (gen_increased)
> -               lru_gen_update_size(lruvec, folio, old_gen, new_gen);
> +               lru_gen_update_size(lruvec, type, folio, old_gen, new_gen=
);
>
>         return new_gen;
>  }
>
> --
> 2.56.1
>
>

