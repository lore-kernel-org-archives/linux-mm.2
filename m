Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 497F9606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 15:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Jc7qrJTX
Received: by kanga.kvack.org (Postfix)
	id 6D8D36B0B95; Fri, 23 Oct 2026 11:51:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 682656B0B96; Fri, 23 Oct 2026 11:51:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54A9A6B0B97; Fri, 23 Oct 2026 11:51:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 283CC6B0B95
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:51:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A296F140157
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:51:45 +0000 (UTC)
X-FDA: 85354331370.12.24182CC
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf05.hostedemail.com (Postfix) with ESMTP id A7773100008
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:51:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Jc7qrJTX;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792770703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SHhiHhKM/Y0ThxDxV4gz8y+nbHryua5zu4b8nmjksY4=;
	b=scJM1qQGV4GamNWAXFW3T5PBo8FjG04mVaWUZy21vTg0L35Z0lcx2TNEMMSSeQzoZN02zC
	EEv9Yf3BBixj3DGtWyqad8loKXRqqfi5wkYlfphE5SADeI831Jv1+6zxAPUn0lc+XOMoqQ
	bZrkElZo7Xg3+H72A9fVrPHpbM2B+ZE=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Jc7qrJTX;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792770703;
	b=r5o51x7L510mDzO0/1czR/39Pw6ceJP+IyLwNoy9500LDmrMNBsiEOddzkkBVYIIJZMlg+
	XWtLhWBiXxzX0FE+rpAQpr3en33SISZxsyFMdxnh000ZBc5fe95bpbkRvX4YPMc9+BjYOm
	HR20F3hdkfHwvLpUNk56JtzM81u03i8=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8a070755c8cso530461b3a.0
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 08:51:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792770702; cv=none;
        d=google.com; s=arc-20260327;
        b=atVJnr9gjTvOekFG+tQbAzOgEZ1Wpwt+PXv8ZhPVnNzZ+er/pX8ba4q9YAYqltZjqG
         lvKCK4sOP+SFbl0aztaBnZFNHFm1mJr0XSOiucstTAtUPIvSZLW6QiXAxtlclD6ZiIN4
         EX6hZTlg8jz7RvZe5NVSuMKLCzF89pMIkj4+wP7F+yZtTsFYT0WaGDCn4H8pjJDa0pJl
         UsAKcOxGHZiiFx6KjmMJTvFFb5C36L9WNHwzgGgstbp9vwWJOYZAtUFi6ilF4XLt1f9B
         UlCHQaCjQEiT5ES3mZrC7ss3+LlkfTezVmvBWLG//37PMlgvqUdW6vL+u69V/yezZyQz
         d6bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SHhiHhKM/Y0ThxDxV4gz8y+nbHryua5zu4b8nmjksY4=;
        fh=4hyn7+Nwvlh1y55RgOxFUot7IR2P5TOA18LW+lXmd58=;
        b=Ym9HDAcfnEU6hblHcjJY1gVUM/5sh0hbzJKIfeA0dqIbf8Wccn/5miwE5aCXEiklzZ
         lIW+yHmSo6zVxvTzxMeitKT9ti9uxjKhINWQh7V/1H+TjWxj1j61Z2+X2r0SMKWmqRb+
         DLZIXb02TNL+DjFTemCIUFukWB4KsjB+XsC1q0Qfd0EK6CypBnz1gf5FhkygJVjmX3en
         7mYnHb+r+lSIjd/rmgZm1tooSk9Mo/9o0zEBQM62DoGoNEj4WF6IUp+l64lPLzB3E/Yj
         4QwZYK07viLyI3pAseVDnGKgjd7T5pem2m/UQJF+BUA2zcB+8nWxgXM+1dh849Yvt9gD
         9xFQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792770702; x=1793375502; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SHhiHhKM/Y0ThxDxV4gz8y+nbHryua5zu4b8nmjksY4=;
        b=Jc7qrJTX2hPlXtdW4ki16wNJ7hIXjexRfCo9UrUou6sLZ56AcLkiEuB76/4KXyAJuF
         5bEDred4xYSFIqNImP8VhzFS1GPE0wN6KpgB+oukNfTzQHyWthJ/GuQLk9r2ziYzgZtO
         dxc0eTUCfArYwj/DJoCj86NYb+/Bbas0GDlvvMQ9Z7xg+6D9T4FCUnF/FXrrYkRBvp+D
         4LbXTqZDmuZOrWwtd0LIin2oITXRJ97Cs4SxvM6HaxaaVrOvDkLn93aTMfM8IX31a8/0
         3HQTwFmp7K/Yzp9tCHKO7pzUfi35tXu2GMSR1JPAaD3Ibuls+DMpRxvsPqJQR83fcTEa
         3K3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792770702; x=1793375502;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SHhiHhKM/Y0ThxDxV4gz8y+nbHryua5zu4b8nmjksY4=;
        b=YOt6kd1Tg99JmsNSqVqogji1XemBdZSuYvmDnPCQ7nr7KYFIIF6MEalsD7zwYgOyXP
         bsw3RxsHV+ndSwYGs5yXD9AdPym/d7SiDOj2na87EjBcVVmsKt5Q+JVkAIIGpNXcQkIn
         SJsPOuOjfzGxTv9TAndE7nPJhM/A4QbtxwnO/V6zTdaxBGqg2gbx7MZ8O174EVb2+9CC
         AUaEQMhL3TqfHOvMESEWY0am1FnFuyNy62xBL01T/R5o337sXki6eSTjanSe/xbVPh2W
         ngS/iIa4iRzPVJLf6zITaM9hawybYMeQxg8ivLU8M45CirMyfeCA3Mw7NbS1jpN+g+ft
         7W+A==
X-Forwarded-Encrypted: i=1; AKwUvBzmW622vt3xbrne79dbveOS2PpsB1YcUv8ZKHEuGoFiv/vdYHuNGe28jDCiznqavO09tr6pfZK8KA==@kvack.org
X-Gm-Message-State: AFq9FYK7zYlm6oAlNUhoMM9Jlk2aFRKtoqhV6zRAH2q6K7WmDIrUh/Ct
	YXCQstGVDAXA+uccJCIsXSfe8F6q+WpoVse7yYBZguDiQnJdpI/otomLxldcjmhD3fSJSfHnxSx
	4nM4iihEJjYVRwCTbsE4pY+6dZS0pq40=
X-Gm-Gg: AYBFou29ttsOBz1JqPq0gTllIem8NNOhtnXXga9jwQfHnkM04uMeXRcwngKWYnjWr1X
	9sFg81McoLDW/syqgqTKbGsG6+y6e8pwvSKcdn1L7Q3aF2GFXrjtgdDVxr9HayXF0CT95a/pnIP
	pZ4HegKj/4nHNVMrfF3eViWbAhdrGU0lzW5HU0BQ/i2Hs/YxVDp69HguFQKoAUq86yb1cCjbPAY
	SQgS2zDyD6q/f+tnaoQoIqhSHCkc3cwCm75VKs/ieCfCwHHt1+pVkLiOWRoBoBOxDl0qHuXA2Ur
	TtwhfGAepaOWV8zk1pl5SJw/Pl17nQSwKL7QMOmY1u1lBGe0o4BPkZAc4r7GO7GEnmSOM12VJP2
	wE14E4XjPG6snnzqSGEmQfPpOZ9EyDTCg9pPtxeAsVtdKjl21ujxH75Bud4FRuSxXw2mNfw==
X-Received: by 2002:a05:6a20:244a:b0:3e2:7c10:d48c with SMTP id
 adf61e73a8af0-3e3691fbd33mr2349848637.17.1792770702261; Fri, 23 Oct 2026
 08:51:42 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261015080157.269079-1-hui.zhu@linux.dev> <CAMgjq7C+EXJBdLUh-JxLGkZHb6wiuvLsq85V7ph6+gPND6mq2g@mail.gmail.com>
 <94afeb74-44cc-4e02-97dc-961309a12364@linux.dev>
In-Reply-To: <94afeb74-44cc-4e02-97dc-961309a12364@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 23 Oct 2026 23:51:01 +0800
X-Gm-Features: AclHuK_-O6edOwhNZ9Fh0WLzPGUakbHyGCUsqDJICDWCabdqPF8tTv3nvnZMfJ4
Message-ID: <CAMgjq7By+mAje-QbZv9UVLosaafjR-NNbm6m_egq+26jBiuMjQ@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v7] mm/vmscan: throttle MGLRU eviction when
 isolated folios pile up
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A7773100008
X-Rspam-User: 
X-Stat-Signature: ejh7qf4h46kouu5caypr6zjnrc6dy3a1
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792770703-135528
X-HE-Meta: U2FsdGVkX18U/lP/JFmRgIiUQ6XfLuQsCKfczfJnTWYvNM4sYpDvQx9aRpul58odqpwPTcW1Ij+R5cLvMkHsdvVlJeFuA+ewgS4r7BLP3u+JzhHy+df0aKgro/AoR+UPF0CPopofYRuZ0TD0lXARgoI59xE37GOsB6RdHqBtNwX3rem2GM20nkzq77XzFUtp+4pCYzwaS59O+dxoHHmsTDwZBpb53xaumd2SnJztOuxNPUII9PaQ/dCW3X48Oe8NAVxfg9nBj7Q5O8ZzptLCcQD5d8EvF2GTHMMNNnF+5PT5Kx7cafr2vVgiWHe8+CMSUyisGXKphNmgkCJj/R/0M8i36K7y55W9Xb7Ml2DIMTvl154rMB8QBg4+gNsyzAWHt25uiHJkJvoAa3xNkbvhOsqY+eKaA4ma4j0R0a8cjSRSHPmnmQgexd2kXlY9gE6kc572uXeWripW66V90qxv6c0Pvea7vxPj0ieCvh/uwFBBxUnUYcHJfc5KuG9bo0jhI/sON3kLqSosp8IFUt1mX+7gojraVghrEAJfcs0Qa2sv2J7h77yHOnKKqpmZbS8KvzJj1eLswKH0ye1qbon99Y1fjQY6IOs/b9Fu5Y7NiIR55gpHxwrMNnKVQUsCg0rlNVCLqbktH+6JAK7ujVjRXT+iiJ/q4WHcKBdP+cSt2Y6MDGG9/zxaUlapESNSkHw0HdMlH/U46Swu9pUsXvozAvoSwG1pgwj6d25tCBL43Gabrxe75po8Jdw2mjRyx7UcGSbYazu274J5OgxU8x8vNstD0McAJXIWdaEQxiqGOu1MQgmZRf3TxZ/LAQUPLX8WYCRF/AopYKh5D/qooULPLyA1z7rDhCuw8MQWw7RgqgiSDytZkuSw0dHs8JRGDx16xABpf65yvB9hr+7/YudsoWVx2Lb9ihLY4BmWeYqhhYfwQp27YFM+qO/2YdCYDHqdGvZCeQ/mokvRpEWNu7G
 7YXfvMFi
 X+6Y1UvzC9Wji4X/zUqQ3odbUF3rsj1L7Dp3KaBi/YQQZOzZMqfvklWR917iEjGSjphsEOHf01UAn7JHFF9STFDTTZq/lmjaj5CBxTXOXAzmQu5TZcj7URNhCzjl4oSLWBodLsiXOP9X04eHgx9hXf06YAb6pungZZ8P0dDW9ax5niqbA3ghqaX2LOvORy5bTTTBgkn/KKdK4nUwratpYoQZY3P+Eq5Nt3M38qA14r6/hZai5pT5QGvFfVngLAZ49WWkHh065BnHkCE9H+uWrZ9+W61yeJDqE9P7hSJxQADOObNmI36PTflPEY6IE2dGu/7rnx0rWE6W+W8PWLBHdpXSFlrqedxsfyw0FjWeOzWxjwLRA/3V5SxAEQ7s7cApOUBUu63jC+SzFBUMQTuu7DUVcgr5tNFWVg5RIBc50VUinaCM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 5:29=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> wrote:
> 2026/10/17 02:07, Kairui Song:
> > On Thu, Oct 15, 2026 at 4:02=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> wro=
te:

...

> > Hmm, I know this could be noise but it looks like a regression?
> >
> >>       mm_vmscan_throttled  0               0 (all runs)
> >>       nr_isolated peak     0               0
> >>
> >>     (*) the aggregate is dominated by a preload-end residency lottery
> >>     (which shards' datasets happen to stay hot) and swings by up to 26=
%
> >>     between runs of the SAME kernel; with 4 runs per kernel the
> >>     difference between the means is within that noise (Welch t=3D1.95,
> >>     p~0.11). The throttle never fired in any patched run (the tracepoi=
nt
> >>     covers preload as well), so both kernels execute the same reclaim
> >>     path here, and the kernel-side counters agree across all 8 runs:
> >>     steal/scan 0.59-0.63, swap-ins =3D=3D refaults, zero OOM. These ru=
ns
> >>     document the no-impact side: the check is dormant unless isolation
> >>     actually piles up.
> >>
> >> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> > Hi Hui
> >
> > Looks like a good idea in general.
> >> ---
> >> Changelog:
> >> v7:
> >> Patch 1 was merged into mm-unstable, so this is resent as a single
> >> patch.
> >> According to the comments of Sashiko, Return instead of waiting when t=
he
> >> lruvec has no evictable folios at all: allowed =3D=3D 0 previously con=
flated
> >> "all empty" with "all over-isolated" and stalled even kswapd for 20ms.
> >> Move the v6 cover-letter test data into the commit message.
> >> v6:
> >> According to the comments of Barry, add real-world workload tests:
> >> a CI-style kernel build (repeated "make -j20 vmlinux") inside a
> >> memory-limited cgroup with its object tree on dm-delay-backed storage,
> >> measured at three pressure levels (1024/1536/2048MB), plus redis-based
> >> cache service runs (single instance and 8 shards sharing one cgroup)
> >> as no-impact data points. New and updated test scripts are in the
> >> gist. Rebased onto the latest mm-stable; patch 2 is adapted to the
> >> current isolate_folios() type-selection context (is_single_type_
> >> reclaim()), with no semantic change. Re-run the tests and update the
> >> test logs.
> >> v5:
> >> According to the comments of Kairun and feedback from the test scripts=
,
> >> make the throttle check per lruvec (new nr_isolated counter) and skip
> >> empty types in the allowed mask.
> >> v4:
> >> According to the commens of Baolin and Barry, rework patch 2:
> >> drop the throttle_is_throttled() helper extracted
> >> from shrink_inactive_list() and leave the legacy path untouched.
> >> The new MGLRU-only throttle_evictable_types() only sleeps when all
> >> evictable types are over-isolated - v3 throttled as soon as any of
> >> them was, which unnecessarily blocked the reclaim of the other type
> >> and passes the mask of the remaining types to isolate_folios(),
> >> which restricts both its initial choice and its fallback, so that
> >> isolation never lands on a throttled type.  The v3 gate did not
> >> constrain the type actually isolated, so the fallback could still
> >> pick the over-isolated one.
> >> Re-run the tests and update the test log.
> >> v3:
> >> According to the commens of Baolin, remove the redundant nr_isolated
> >> check before restoring the NR_ISOLATED_* counters in evict_folios().
> >> rename the extracted helper to throttle_is_throttled() to avoid
> >> confusion with the existing wake_throttle_isolated() naming space.
> >> Use for_each_evictable_type() in the MGLRU throttle to check each
> >> evictable type's isolation instead of only the type returned by
> >> get_type_to_scan(), since isolate_folios() may fall back to the
> >> other type.
> >> Re-run the tests and update the test log.
> >> v2:
> >> According to the commens of Kairun, Rebased on mm-unstable.
> >> Split into two patches; patch 2 is new and adds the
> >> too_many_isolated() throttling to the MGLRU eviction path, which v1
> >> did not cover.
> >> Add test infomations.
> >>
> >>   include/linux/mmzone.h |   2 +
> >>   mm/vmscan.c            | 184 +++++++++++++++++++++++++++++++++++++--=
--
> >>   2 files changed, 172 insertions(+), 14 deletions(-)
> >>
> >> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> >> index 3b96d6c7123b..7759a53326ba 100644
> >> --- a/include/linux/mmzone.h
> >> +++ b/include/linux/mmzone.h
> >> @@ -564,6 +564,8 @@ struct lru_gen_folio {
> >>          /* can be modified without holding the LRU lock */
> >>          atomic_long_t evicted[NR_HIST_GENS][ANON_AND_FILE][MAX_NR_TIE=
RS];
> >>          atomic_long_t refaulted[NR_HIST_GENS][ANON_AND_FILE][MAX_NR_T=
IERS];
> >> +       /* the number of folios isolated from this lruvec and being re=
claimed */
> >> +       atomic_long_t nr_isolated[ANON_AND_FILE];
> >>          /* whether the multi-gen LRU is enabled */
> >>          bool enabled;
> >>          /* the memcg generation this lru_gen_folio belongs to */
> >> diff --git a/mm/vmscan.c b/mm/vmscan.c
> >> index daa7e37c2236..36887117d76a 100644
> >> --- a/mm/vmscan.c
> >> +++ b/mm/vmscan.c
> >> @@ -4332,25 +4332,34 @@ static void set_initial_priority(struct pglist=
_data *pgdat, struct scan_control
> >>          sc->priority =3D clamp(priority, DEF_PRIORITY / 2, DEF_PRIORI=
TY);
> >>   }
> >>
> >> -static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int=
 swappiness)
> >> +static unsigned long lruvec_type_evictable_size(struct lruvec *lruvec=
, int type)
> >>   {
> >> -       int gen, type, zone;
> >> +       int gen, zone;
> >>          unsigned long seq, total =3D 0;
> >>          struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> >>          DEFINE_MAX_SEQ(lruvec);
> >>          DEFINE_MIN_SEQ(lruvec);
> >>
> >> -       for_each_evictable_type(type, swappiness) {
> >> -               for (seq =3D min_seq[type]; seq <=3D max_seq; seq++) {
> >> -                       gen =3D lru_gen_from_seq(seq);
> >> -                       for (zone =3D 0; zone < MAX_NR_ZONES; zone++)
> >> -                               total +=3D max(READ_ONCE(lrugen->nr_pa=
ges[gen][type][zone]), 0L);
> >> -               }
> >> +       for (seq =3D min_seq[type]; seq <=3D max_seq; seq++) {
> >> +               gen =3D lru_gen_from_seq(seq);
> >> +               for (zone =3D 0; zone < MAX_NR_ZONES; zone++)
> >> +                       total +=3D max(READ_ONCE(lrugen->nr_pages[gen]=
[type][zone]), 0L);
> >>          }
> >>
> >>          return total;
> >>   }
> >>
> >> +static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int=
 swappiness)
> >> +{
> >> +       unsigned long total =3D 0;
> >> +       int type;
> >> +
> >> +       for_each_evictable_type(type, swappiness)
> >> +               total +=3D lruvec_type_evictable_size(lruvec, type);
> >> +
> >> +       return total;
> >> +}
> >> +
> > The helper split looks clean; it could be a stand alone commit I think.
> >
> >>   static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_con=
trol *sc)
> >>   {
> >>          unsigned long total;
> >> @@ -5012,16 +5021,142 @@ static inline bool is_single_type_reclaim(int=
 swappiness)
> >>                 swappiness =3D=3D SWAPPINESS_ANON_ONLY;
> >>   }
> >>
> >> +/*
> >> + * The MGLRU counterpart to too_many_isolated().
> >> + *
> >> + * too_many_isolated() compares node-wide isolated counts against
> >> + * node-wide inactive sizes. It predates per-memcg LRU lists, which
> >> + * moved isolation to per-lruvec granularity. MGLRU reclaimers conten=
d
> >> + * per lruvec, so this check is per lruvec as well, and isolation in
> >> + * one memcg does not throttle reclaim in another.
> >> + *
> >> + * The legacy threshold, the size of the inactive list, is not usable
> >> + * here either: in MGLRU the inactive counters are only a compatibili=
ty
> >> + * shim - they jump around when swap runs out or a memcg hits its swa=
p
> >> + * limit, and proactive aging can inflate them. Compare against the
> >> + * total number of evictable pages of the type divided by MIN_NR_GENS=
,
> >> + * approximating the size of one generation - the same unit the
> >> + * original MGLRU aging heuristics used.
> >> + */
> >> +static bool lru_gen_too_many_isolated(struct lruvec *lruvec, int type=
,
> >> +                                     struct scan_control *sc)
> >> +{
> >> +       unsigned long isolated, evictable;
> >> +
> >> +       if (current_is_kswapd())
> >> +               return false;
> >> +
> >> +       if (!writeback_throttling_sane(sc))
> >> +               return false;
> >> +
> >> +       isolated =3D atomic_long_read(&lruvec->lrugen.nr_isolated[type=
]);
> >> +       evictable =3D lruvec_type_evictable_size(lruvec, type);
> >> +
> >> +       /*
> >> +        * GFP_NOIO/GFP_NOFS callers are allowed to isolate more pages=
, so
> >> +        * they won't be blocked by normal direct-reclaimers, forming =
a
> >> +        * circular deadlock.
> >> +        */
> >> +       if (gfp_has_io_fs(sc->gfp_mask))
> >> +               evictable >>=3D 3;
> >> +
> >> +       return isolated > evictable / MIN_NR_GENS;
> >> +}
> > The magic number of >>=3D3 looks a bit odd, others are fine to me.
> >
> >> +
> >> +/*
> >> + * Unlike the legacy path, where the LRU list to isolate from is know=
n
> >> + * before isolation, isolate_folios() picks the type from the refault
> >> + * feedback and may fall back to the other one. Therefore, instead of
> >> + * throttling on a single type, collect the evictable types that do n=
ot
> >> + * have too many isolated folios, and only sleep when all of them do.
> >> + *
> >> + * Returns the mask of the types isolate_folios() may isolate from, o=
r
> >> + * 0 if reclaim should stop. Also sets @fatal to tell the caller that
> >> + * the task received a fatal signal while waiting.
> >> + */
> >> +static unsigned int throttle_evictable_types(struct lruvec *lruvec,
> >> +                                            int swappiness,
> >> +                                            struct scan_control *sc,
> >> +                                            bool *fatal)
> >> +{
> >> +       unsigned int allowed;
> >> +       bool stalled =3D false;
> >> +       bool has_evictable;
> >> +       struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
> >> +       int i;
> >> +
> >> +       *fatal =3D false;
> >> +
> >> +       for (;;) {
> >> +               allowed =3D 0;
> >> +               has_evictable =3D false;
> >> +               for_each_evictable_type(i, swappiness) {
> >> +                       /*
> >> +                        * A type with no evictable folios has nothing=
 to
> >> +                        * isolate. Don't allow it, otherwise reclaim =
can be
> >> +                        * redirected to it and spin making no progres=
s, e.g.
> >> +                        * when the only type with folios is over-isol=
ated.
> >> +                        */
> >> +                       if (!lruvec_type_evictable_size(lruvec, i))
> >> +                               continue;
> >> +
> >> +                       has_evictable =3D true;
> >> +
> >> +                       if (!lru_gen_too_many_isolated(lruvec, i, sc))
> >> +                               allowed |=3D BIT(i);
> >> +               }
> >> +
> >> +               /*
> >> +                * Nothing evictable at all is not over-isolation. Sto=
p
> >> +                * reclaim instead of waiting, so that nobody - includ=
ing
> >> +                * kswapd, which is exempt from the check below - stal=
ls on
> >> +                * an empty lruvec.
> >> +                */
> >> +               if (!has_evictable)
> >> +                       return 0;
> >> +
> >> +               if (allowed) {
> >> +                       /* Wake up reclaimers waiting on the isolation=
 to go down. */
> >> +                       wake_throttle_isolated(pgdat);
> >> +                       return allowed;
> > This seems counterintuitive: we reach here because a reclaimer is
> > starting, and we wake up even more reclaimer?
> >
> >> +               }
> >> +
> >> +               /*
> >> +                * All evictable types are over-isolated. Like the leg=
acy
> >> +                * path, wait once for concurrent reclaimers to put th=
eir
> >> +                * isolated folios back; give up if that makes no prog=
ress.
> >> +                */
> >> +               if (stalled)
> >> +                       return 0;
> >> +
> >> +               stalled =3D true;
> >> +               reclaim_throttle(pgdat, VMSCAN_THROTTLE_ISOLATED);
> >> +
> >> +               /* We are about to die and free our memory. Return now=
. */
> >> +               if (fatal_signal_pending(current)) {
> >> +                       *fatal =3D true;
> >> +                       return 0;
> >> +               }
> >> +       }
> >> +}
> >> +
> > Hmm... this part looks a bit too complex, see below.
> >
> >>   static int isolate_folios(unsigned long nr_to_scan, struct lruvec *l=
ruvec,
> >>                            struct scan_control *sc, int swappiness,
> >> -                         struct list_head *list, int *isolated,
> >> -                         int *isolate_type, int *isolate_scanned)
> >> +                         unsigned int allowed, struct list_head *list=
,
> >> +                         int *isolated, int *isolate_type, int *isola=
te_scanned)
> >>   {
> >>          bool type_fallback_allowed =3D !is_single_type_reclaim(swappi=
ness);
> >>          int type =3D get_type_to_scan(lruvec, swappiness);
> >>          int total_scanned =3D 0, scanned, tier;
> >>          bool tried =3D false;
> >>
> >> +       /*
> >> +        * The preferred type may have been excluded by
> >> +        * throttle_evictable_types(); start from the other one.
> >> +        */
> >> +       if (!(allowed & BIT(type)))
> >> +               type =3D !type;
> >> +
> >>   retry:
> >>          tier =3D get_tier_idx(lruvec, type);
> >>          scanned =3D scan_folios(nr_to_scan, lruvec, sc,
> >> @@ -5036,9 +5171,11 @@ static int isolate_folios(unsigned long nr_to_s=
can, struct lruvec *lruvec,
> >>
> >>          /*
> >>           * We are running out of the current reclaim type. Fall back =
to
> >> -        * the other type if allowed.
> >> +        * the other type if allowed. Only fall back to a type that is
> >> +        * not throttled.
> >>           */
> >> -       if (!scanned && !tried && type_fallback_allowed) {
> >> +       if (!scanned && !tried && type_fallback_allowed &&
> >> +           (allowed & BIT(!type))) {
> >>                  type =3D !type;
> >>                  tried =3D true;
> >>                  type_fallback_allowed =3D false;
> >> @@ -5072,18 +5209,36 @@ static int evict_folios(unsigned long nr_to_sc=
an, struct lruvec *lruvec,
> >>          bool skip_retry =3D false;
> >>          struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> >>          struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
> >> +       unsigned int allowed;
> >> +       bool fatal;
> >> +
> >> +       allowed =3D throttle_evictable_types(lruvec, swappiness, sc, &=
fatal);
> >> +       if (!allowed) {
> >> +               /*
> >> +                * We are about to die and free our memory. Like the l=
egacy
> >> +                * path, pretend some pages were reclaimed so reclaim
> >> +                * unwinds quickly instead of looping back into the
> >> +                * throttle.
> >> +                */
> >> +               if (fatal)
> >> +                       sc->nr_reclaimed +=3D SWAP_CLUSTER_MAX;
> > And reporting a fake nr_reclaimed looks a bad thing to do in the first =
place.
> >
> > It seems a lot of trouble is caused by the design of the reclaim loop,
> > so will it work better if we calculate the number & type to reclaim
> > first like CLRU?
> >
> > There is a demonstration from Barry:
> > https://git.kernel.org/pub/scm/linux/kernel/git/baohua/linux.git/log/?h=
=3Dkairui_scanbalance_0.3
> >
> > And instead of throttle at the reclaim loop, balance the scan budge
> > based on (size - isolation) number, and throttle a while LRU simply
> > when the total isolated number is larger than total size /
> > MIN_NR_GENS.
> >
> > Just an idea for reference, seems could help get rid of a lot of comple=
x logic.
>
> Hi Kairui,
>
> Thanks for the pointer. I had a rough look at kairui_scanbalance_0.3 and
> I am quite interested in it.
>
> I think that branch still needs an over-isolation guard. The scan budget
> answers "which type and how much", but it is computed once per
> try_to_shrink_lruvec() and does not see what other reclaimers are
> holding. Each reclaimer's in-flight isolation is bounded by the batch
> size rather than by the budget, so N reclaimers entering together all
> see the same state and all proceed.

Yeah, exactly.

> On the other hand, that branch would also make the guard much simpler
> and clearer. Since evict_folios() already takes the type from its
> caller, the allowed mask, the type rewrite and the fallback restriction
> in isolate_folios() all go away, and the throttle reduces to a single
> check on the totals in the shrink loop, which is basically the second
> half of what you suggested.
>
> So I would like to ask what the development plan for this branch is,
> and whether you think it is worth moving the MGLRU too_many_isolated()
> work over to it.

Thanks for looking into that!

I think the isolation protection is definitely needed; really
appreciate your work!

However, many things are currently happening in parallel for MGLRU.
Will the code be cleaner if worked on based on that branch? And
MGLRU's budge will be more similiar with CLRU, so I hope maybe it can
even be unified with CLRU for this isolation protection, just with a
different gating (size / MIN_NR_GEN vs size of inactive), will be much
lower LOC.

