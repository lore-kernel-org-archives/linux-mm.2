Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BB9ECC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 11:18:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBF186B0088; Tue, 13 Oct 2026 07:18:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D70606B008A; Tue, 13 Oct 2026 07:18:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C381D6B008C; Tue, 13 Oct 2026 07:18:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9AC076B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 07:18:46 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA4601A0B01
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:18:45 +0000 (UTC)
X-FDA: 85317355410.27.7CAAFF4
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id EE2E6120003
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:18:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=blclt0PI;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791890323;
	b=X+DiF2aI5jXkVl3ttkClevzv21NCC6ZXSFI+foBG1SMqMnyTTXWe+dDJ9nkAjJwusqzNyj
	DGD2vq4SC6vo2jj2VRIXGOee4yjE9eWVw9lmPnSEdD1iEypOiqLh5OX1jjeDtRfYNPFG0I
	J5PA2GSU4VXHdB7BMsflA2HzED7eP2I=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=blclt0PI;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791890323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=02lGd8mbATmejUO3KQVY/K9npSJMZS97UeoTBHaxfAg=;
	b=7YMPZU1QG1YuycR6kk9TCPZl75zLavgNfW+eatgOyqFCraaLwiqGDXQMU30BiLLIzIYNi9
	aVeyorqf6bXso2+7gkTzepYqLGLTponIWu/t7sk+x7+o5Ytix2n2Il748+gzUevlaWdf8D
	0s469Z5+PG/Qd935IKz2KtN607KWXec=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5337c7b9937so706221cf.0
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 04:18:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791890323; cv=none;
        d=google.com; s=arc-20260327;
        b=kRVKk2clyjku/hNsmcMRJwFrZspzEQ5+XDVQz80XobpV2ntNzm2DFjCiTu8gwHEPmE
         qY2z3DJzhIHCxojXAD6m7NlYd9NVRDIoahX/fngSWmL2Xvzn4DzvBKxTxcW0R3WFj/f0
         7LIcPZ/sErjsssDmmpzDX+iCGJa19av7cgjHgNuMTme4Y6iaUnq4ejo9K1mWTdDEX/F0
         28hbjhqiPH+8hDEhZ/RzBbhqaL3gd4jBHpgzVMq9E2AbXlsDKeKZr4TDJ5y1LLG6St4X
         XgeCunQ/UBWbTaRJkRR/p74d21cC/vfcEyZkIh8r4fkU6/crIENGd6wC2HlZjxZz2hLL
         OfCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=02lGd8mbATmejUO3KQVY/K9npSJMZS97UeoTBHaxfAg=;
        fh=0gQ84ojOU9sTt/0KaKQnVEUo2Fqfro7ZSsjYOo4qkxs=;
        b=LLBjx9M2L9A0Nz9GsAsfkAZeOpGRgRK0vPNXYv8NV+VJqXMMRYeYziGZl09HxXz/6F
         8ycv86MR9/mb9MJRmE3wcjYxfDLLoap6s3mQiFxwzryfmfrxC4xuk0maDjfWZSXqBWCH
         hg2lqOfovO0ez38ccwAMIzH+c7Kb63qWHQjZTxt+dERJabWFmtDAsoSonEjoQYaPXvzH
         pMshyWU/g1+iigNuaD6ZcyDoejoJlrgsW6ugCPlwRZ9Tv41yQwuSza/R6zjayBlWaEEF
         R8AE6PDHhggOPMO7lSEPRRRUzBHFPZ6PsLswt4+O4lVQx06Cdn4Mrm5cUjPdb3dv8iSj
         OSJg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791890323; x=1792495123; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=02lGd8mbATmejUO3KQVY/K9npSJMZS97UeoTBHaxfAg=;
        b=blclt0PIefbRM333GY23nAKEa7Hi4Ouf9YoCKe+1Xlw4SCkNw8UpvUOOFWc3fD2KrF
         VSS3Fr6zLx4MbHHVcbMlfc9r91PdXT/Nv4y1Hf80x9RAtqIVCMsqdcjD++4BPJQNlPa5
         wNGuRg+tOeT0H0rLKYlcE1PLiLtt1V5a9VliTFY0e4KWs6/13j1H/GgEQCZP0UoXnwea
         rZChBFHz4qxLXhd3hNjfmflXYq9CYRETf+bQbEumlhcOAw9ANMIEZHDMmi6bLmn0+6RM
         uSlj/TCxRBrljNIO+vYTQb2unrJjkEyoAoDAAySfNtislzh2dyNeoRq7zaXIL6iMOd1m
         i7Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791890323; x=1792495123;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=02lGd8mbATmejUO3KQVY/K9npSJMZS97UeoTBHaxfAg=;
        b=uXg7E0ukt5A852XfC/AOEGjdQZC33F6jSwpY90DUN1baZXB/coTjU4Jy+jLT/2Pa3Z
         c7Qlah2j9Q9tcNSatl8yCmoa/wuEeqaSJ0HpgLfPjFj+jcq0pS6MLKTM4rql96qYVp+V
         K7whpCfvKUlQKzG+j7UXOUwTrnqoi0cKaGJjsne7ATy4TPUkujkTi+vZRebDe5N3Zduz
         M8msM1gBtI98CaZBblaSUqrLcegiW2zWIepjvdh6VkM80VqZdB1+SPgOZpDANvWkZckK
         qoeKrk00ajZNCfth6kleRHRTIr+M/b9bNJyjv8AeNjn27Jn/zbzbrdfcXr0LXVBc2Urd
         9XIA==
X-Forwarded-Encrypted: i=1; AKwUvBzFVpHw2NuMSMWx52/nYxzfUfuy9MONGIexHnaK6ZaLfaekvHIYZA2lHvgC3YFCmBmMgQ1bHmptUA==@kvack.org
X-Gm-Message-State: AFq9FYLvU1bPJnQdUHisPnvlqLTvQLwpWk8j+124VH2eMPDQoFaOPaSu
	JWLpLYnPz5l7HF67klTT9Cs7J03sDM0p9IWISibPFS0lUh1j6oSewkaqxYF7nfYYfZv4rvWpgSq
	VIeLV5fkVomdhPThJChLvp81HI5eeU7koxDbYVbio
X-Gm-Gg: AYBFou1Qip5idm81wz/S/KenfLgU5byKsZLIJ/uUwCM/Xbt9eaK4pZfaSqjFjud3QZs
	rcWA7f3CZocjSVTBJ4zs1LZXiAe8/EKKTSENMkMMY5w2JeyGQXYeiBKGEkOeSb51sv25BnO98Ma
	nvO9cd9KlBRjE+s9evKU+VCAH6RR6oFAMIGk1vnclv7z4ASX639dzJ+BqKzECQEZBWjzdmLMRtK
	jnsLkKhyyjtBsEhDKI+qnp6VuuRHS9Sy2xgfIqvwN8jtFqoMVXxahrcBhUNlGZVyMImvXC8b0tP
	ocpF0Z6/jHB7PQc0PDqfRLm3/6L/TapZpZ3x7wgqtqAUam/AoTLMYET/
X-Received: by 2002:a05:622a:4cc:b0:52f:8389:29e0 with SMTP id
 d75a77b69052e-535b2910266mr48102151cf.0.1791890322506; Tue, 13 Oct 2026
 04:18:42 -0700 (PDT)
MIME-Version: 1.0
References: <20261009063619.112313-1-hao.ge@linux.dev> <20261009063619.112313-2-hao.ge@linux.dev>
In-Reply-To: <20261009063619.112313-2-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 13 Oct 2026 15:18:29 +0400
X-Gm-Features: AclHuK-qvcUVrSOqAHUBuFhMyipfniAtX1mtGlvajg8JTqSPRj6kAwYVpLqLul8
Message-ID: <CAJuCfpG4Zq6zRyvXkf40XcsiMSvS78Za28zY2xcaAh=kXpuD8Q@mail.gmail.com>
Subject: Re: [RFC PATCH 1/4] mm/kmsan: undo the shadow mapping when the origin
 mapping fails
To: Hao Ge <hao.ge@linux.dev>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Shrikanth Hegde <sshegde@linux.ibm.com>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Uladzislau Rezki <urezki@gmail.com>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EE2E6120003
X-Rspam-User: 
X-Stat-Signature: rqnjkagx31noutfdmqrae6dn963r384i
X-HE-Tag: 1791890323-908288
X-HE-Meta: U2FsdGVkX1+qxrEAPMZW0Sh28UU459WGB6wgeGGI+PprpK+Mh7ZEdV15jYgnP+vhWBCPw7glJD/G3pP+Y35uxJE1aXvcLvRQplKjHcwPBKSTKcWTOKCg8wSzD1h0ExaSqKwimvTmxxooqFcu1RYCF7RnzLs2qBLP+WJRCpDKjLm6Q06dZYsn4VjspHpt1dTH+R/IpXM4g01GJygf+NC90+AD4m9h51EIqojLyLdQlh2JwYbzYtLOkHNzaiIVZ3YVFZfnWWCgtmyOKaIrNZFY7mpecZYHzgczFvQqFYoLEIstCV/jGaRrdHd/W4eIBqBFy+eXbSZOTIIEiEmlqSjFgiP8QGh9O9366vDsPP+md9l3e8T1bQkJz64kTjX+yK5qTW65o7SnwyEi2pA8JI3lbBHan9A0Fxwzt8uo825UggMCdt9p711Oao7yACT1WZ1myZGJzoz6ygjl6m/clHNL60PGruOUn8c7rPTGbHpvDQCK6xq9Dhjlrq1f43wFQJkYgPrX5TynH95qbh8p7Rbmej7WwOTC1TYYj64df0+xmFhzPQzxNG5zKQj/YD20bMVum+LmM03wFrAGRrF3vPEPtRn0s5VxzSuOsS659nYk17/+UiMyYIdbyX5LOZeIKAW9tOUNMEAdM91q64j2ZPNaEEkhiGVVZ24uZOBZIysiAroKLUfpHojlh0H0u7u+7hYqv+AwH2GJhHKrsV32nGhABTrMi+OmCA6BHDGpmcQvk0rxqGpmLV7sI9TzNR5Irf5OLg8XUxWYEmihBbERY3MW2NwUZ3fWdJjeaqe/7GhCXU1xhuuklfg8bbLTfenpAKXwHFM21HpjC2e7/ITPRDQ8/89gs1triLXVw7uPZvXhk0eRm2kIeb+2qfCAXl8SZB0A2O2bBUH1MXlXQJrHJK9ZHX1JB+HuJDfrmPCA7LM1JQSwrr6w0nrVkm3Gwwoal0y8K0L4Af+OPgGL+B9mn90
 rBHtdhrg
 ez18JFP+GOveMGD6QjJpXwe+l66CHmD/GexWtvic4HuwVzcxea+FCiA65bnrecEdNmEXeiR66czjgemXnBwK+sE5T4DKHdhKzgzNSOUTZoQivObOvTnDrpWLHK3lCUxwI5Zgk3PSzGgsmaRYdFgq3oZFLO6aVcBE2khwYjn7Gr+txD7nS3YqdVyDZjNWtFD1i3IEOAaB4RZW32jfMtymg6D7LQ/1r6sL/LVoWR6WuqQMqw9KkKGlLdgrzBkRZ31HNYC820MWvjljOQQKV2sf6mfGW0tdJ4ddKq8abg0aHqe+3NOe7RaoV/Ovkiu22UNFFczFljqu9ooXvZzfvc8oijrCz4cuF+HlwCBtBzUovrB2hXyI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 9, 2026 at 10:35=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> kmsan_vmap_pages_range_noflush() first maps the shadow pages and then
> the origin pages. If the second mapping fails, the first one is left
> mapped, and the callers do not roll it back. The next vmap of the
> same metadata range hits the stale PTEs again and BUG()s on the huge
> mapping path, or gets -EBUSY with a WARN_ON() on the small page one.
>
> Undo the shadow mapping on that error path, the same way
> kmsan_ioremap_page_range() cleans up after a partial failure.
> __vunmap_range_noflush() only clears the PTEs; nothing has touched
> the shadow mapping, so no TLB flush is needed.
>
> Fixes: 47ebd0310e89 ("mm: kmsan: handle alloc failures in kmsan_vmap_page=
s_range_noflush()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hao Ge <hao.ge@linux.dev>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


> ---
>  mm/kmsan/shadow.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
> index 0c88d89bf0d6..2166086d3dc3 100644
> --- a/mm/kmsan/shadow.c
> +++ b/mm/kmsan/shadow.c
> @@ -258,6 +258,10 @@ int kmsan_vmap_pages_range_noflush(unsigned long sta=
rt, unsigned long end,
>                                             o_pages, page_shift);
>         kmsan_leave_runtime();
>         if (mapped) {
> +               /* Undo the shadow mapping set up above. */
> +               kmsan_enter_runtime();
> +               __vunmap_range_noflush(shadow_start, shadow_end);
> +               kmsan_leave_runtime();
>                 err =3D mapped;
>                 goto ret;
>         }
> --
> 2.25.1
>

