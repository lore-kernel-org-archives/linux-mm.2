Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C8D0606A330
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 17:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SQNMkXz/
Received: by kanga.kvack.org (Postfix)
	id 816BC6B05B0; Fri, 13 Nov 2026 12:12:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EE5B6B05B1; Fri, 13 Nov 2026 12:12:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 704B86B05B7; Fri, 13 Nov 2026 12:12:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 416556B05B0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:12:01 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B1EB3120171
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:12:00 +0000 (UTC)
X-FDA: 85430738400.08.46353AF
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id C2F57C0006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:11:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="SQNMkXz/";
	spf=pass (imf28.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794589918;
	b=JSmIuITi5pekoNLLE0QSCjrGU0lBV3O3kEKEKj6IyMNUbH9V1CNMqybHHsb8yfZdOJKPll
	aJ0PlBUBEDtXh9Cse4T+9l4C0eqwG7Kw+Gb/tZGJNyCc3jRIF5jmdPCWCChveQyMX4BDVm
	LFSy+Lyt+nhTLHVRFUsOsAJCrii/G80=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="SQNMkXz/";
	spf=pass (imf28.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794589918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V4LsAq7DB5D+COJ4bQL/G858UvTmKQbRXPHjpExqCZg=;
	b=pEtjdz3qavGJ0LtPxASo6nCiTwUnjfesCAV/n22EmlgqSyNQDosGbsa++4HuMGBmuZ7D49
	Jd4agICjSFUdeeqLLcWj05tRXxZ7MtfaFuWwCn9ab2jxK8IIKVtAXvvpEj8EoA2WvYlNnq
	kvme4w4OmIQeG/daah/ojP1XfnNGZPw=
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-36eb1cb7aabso1557811eec.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:11:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794589917; cv=none;
        d=google.com; s=arc-20260327;
        b=iWRFRKwf6fz43F0QUkahO9n8F9B8btanQbQBN5Yll6j6nQ62f21RXhqwLz0sT/4teG
         +G/s8n6G2dSUl9zfxunx2A8MHHtUBpraZqhWkVEh6DbaDsM0Vtm/x57r98DlL6pHorLV
         l2/fRxCrwwL9pdDxtmMnkFw4L2SBodrtfdHJGpGqDWf7isaITcBuAZYf7Bq4VGtL4buL
         bMHYXJ7Fp+MhugeKwMom8hAtXVjPUUcyp0a/MBT6gUjywgfVpVfN9j/5xf2ynTS9glgJ
         fnm811O6R55+ahpFlzohk/3zhxSf++6Uq82zMGSHH54Ez5RWI0uc6ZWbzjs6ZiMvQV9E
         Z3VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=V4LsAq7DB5D+COJ4bQL/G858UvTmKQbRXPHjpExqCZg=;
        fh=ihpSvighiKBVYbHJoQjxgKfaUump2/y1ExQiNqH9bQc=;
        b=NqP2JldcvIr80RGQbfPF3CHlL1ckzuPgGTqqiAXXaanWv7jBEllDNs8Zy7haA50Zc0
         PNZtSYYwyjDuV24XAucaYjXZ0/a18FFG2O9s4ZpOW+6ECOwJhdpd8xBfWOuS1rf+v8Ym
         Sb/6/WlETTlcSiR0+gfkXQGKDLTNBnAgq0XP7phxTZlvtZfb7md1JpEzXryCsTrUkpSE
         pNM2GBFMQiwYUu9Oz+0LyJLgGge1Xc6qnjTXr5yCqy7uQhMJuG9Lv+kZ7b8RE8ugprlD
         5eD7rTZ4fmtwt8qXS+t5p1xu5uS5AXDFdn/c+zZYASpmyf1RQhmrPQQuCy8SvCjIbh+s
         8JqQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794589917; x=1795194717; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=V4LsAq7DB5D+COJ4bQL/G858UvTmKQbRXPHjpExqCZg=;
        b=SQNMkXz/Sj8Nlax9mQ3dD3pTVexrie+Ek7tGLj9wiiyXY0SKaIKsApd7s6y5uswkyF
         uBP6rnD3hG7NddcR/uWArXKWyfD+931LrOJXdw7AOq2YpLmGkkWSzlmEJp8tkHr6SyDR
         blnsoUtWl0zuDgGLCBI9I+8q7ICRVpcZX2/iyuf0ao4a7iVfPkqz7RF5d+By4RP2uDxq
         nuU8mcr5l5QkPJf67i+9P8hPO9AoP0TUkhUp2PeraPsHPNnpPTvo6LnKemIEhRXMZALA
         lHUqTVUrfCenaDNJ+Y/eTN756UE+w2oWZ/1IOj1oGQO6bhHflIKaVscQYOA1MusVozVc
         HsLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794589917; x=1795194717;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V4LsAq7DB5D+COJ4bQL/G858UvTmKQbRXPHjpExqCZg=;
        b=uT72Cc9X3W4ledqYJBdBai7TU+pQd0kYWrP1Mt8Wx0/tBXLBg1Lj2CEWNym0h4wu4b
         FCWyTc1qi13AlC2VOPSEWxXjQRkZqnFZnqOHIOO8sWJtF0URbtYwvKkAM4HkKLXA+XNY
         r4POGIr6RDb9+FSU3jELrGfKRkWuZsG0Hjn915zQIQcUJjG69pYHSalCQWLhKApQRQY5
         W/UlOI5x8dKXQwMAvPIanNW482VV6Eut+IDBfBFOVxIG+4prLt559FWVk7IeFNwg3DZR
         V9QUMIai7WR2PRQheLSc00RrVhkRj8lIvUTNF3uEXnubeyn/fjPasSSH+NKwQupn49QU
         yNeQ==
X-Forwarded-Encrypted: i=1; AL+hErFYFlVKN8x5hierHHvtRfVuE0oH3HkI0TImxgK1FZ2PQZAwJoBxSHoswOVYInLBCfzxHgoiiVJUVA==@kvack.org
X-Gm-Message-State: APuU4Z9G4vzEBq77P4pMXCHO+7gzJ0GbOiqDvgt+XpcAkVydhrd0NbPU
	9EzmDr9EVLURWk/afSSMNdTCQ5bQd0mjcylyGokKQbiBdz0hRMDs1ypisA8bT5yIHOlFV+A5VPl
	KyimlJqLdvqGLiiPb40PD36tM/mRhXkI=
X-Gm-Gg: AYBFou0d5Xhn/dTO2WgiMnmJhAd0SznVMhStHtpsnVZFxknT3il/4kOg6nIPgvNSZ+C
	ZmEAJ4Z9/Y94dwKUNk1uDhmG2xjwnhPHV+oovaR/qIKLcPuAB84oId1MhGBJngcQCyG0fZHj2sY
	fJWYr9wXLgLK6Aono4pIV1SPjRHQ+Ih9fZOvLSBDBDY8ZHVrc/wHVijZ9X1xp98Kf/47dZtHSzN
	I1CLPP3EnnSSvra7omJJ1OsXbLPCqpOBvE/SvUbD4k3VJx88tW3/HgVXhTvoGbQcqYe6aVLTYtn
	wCcpUp24vbvhJRAhBHH0Et3LqXRBy2662q+rxDFW3jrSBAVs43G+dnzQvGDG0fNQlZTswVbvqGh
	7/EHZeGw0aob+cMhj5BIBcEdm0IvYWsVrjfXAp77JPluCEAkyhdTa79ydM3F9aJYtrRw=
X-Received: by 2002:a05:693c:88db:20b0:36a:1e9e:ae61 with SMTP id
 5a478bee46e88-379684ae78cmr2588635eec.38.1794589917373; Fri, 13 Nov 2026
 09:11:57 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261112214738.3002458-1-joshua.hahnjy@gmail.com> <ba5dd85a-20a3-4f76-a929-4fc2df8fecf0@kernel.org>
In-Reply-To: <ba5dd85a-20a3-4f76-a929-4fc2df8fecf0@kernel.org>
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Date: Fri, 13 Nov 2026 09:11:45 -0800
X-Gm-Features: AclHuK9fy_F2qf_MxokR_kjguv7xtRDWNK8DAsF7IEyYQ9lXs95btzddWkzOKuY
Message-ID: <CAN+CAwNsqWpPoag_XE6bxbrfi6m71xw1NS_wc3h_ShZjNspSjg@mail.gmail.com>
Subject: Re: [PATCH v3] mm/page_alloc: only skip kswapd nodes below their
 kswapd watermark
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Gregory Price <gourry@gourry.net>, 
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	"Jose A . Perez de Azpillaga" <azpijr@gmail.com>, Daniel Hodges <hodgesd@meta.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C2F57C0006
X-Stat-Signature: nfpfoxgbj8db5ebakkrcodwicdiocuq7
X-Rspam-User: 
X-HE-Tag: 1794589918-989052
X-HE-Meta: U2FsdGVkX1/OaQwurWGOBXy6BgYQ9n2sV8hqTc4op0FEIJQoMI4AFy6lx7xB0eOPqrui/c/5PGL1wAZCbXWiJsCIm2THDgjQWhx1Hiw7PVGwpii7JgAHLX4oszpbeDrODaPRFtqMwM05ziIAfMoKQU83KFFouClMkp9La9xuFD+86A8x7T3/qCbS3QgeZF/uVtAZAZPuaGCCSCPVf9QMQncWLbHcC5ZZAY0Ufh+itmp0eKdBF6+GKoz1VeOUko2jrmEA5xVLzxBNY/ds8axLT821CT77eaOYubRGnf9Y7sfUFmj66Q+Dh1RbuNNrj6Z4dlTaTbS8y+F/gLJeeku89eoIPEc+uqGszpaZqFwdDA/LE9pJWPFlfvT1XMRgCWjDD2XXclDOKPCYGpPRxoDNxBOac/PCmEuZYKTaBsf8SlTVX5bjPbthiOillX5msyCSKyVrXw48ltaU2T6Qb6YcMxbB2BoqLGlk1xhwGB/lh97oDFuvck/WH19NFUYZJtxhve5IYqa1MzstGQ+c2RkUHBJejk6zsbg70UVdx/kxqqbZxgqn8nzj5oga644zHNg0vl/lJzqBumSDfpCreXBKL68fx01R2Qx46souAbI533VMAym2jTsTwnAZs2Shtkr+T2P50xx00E6FNzNKQXn8G/hERgM61NtYq3G5BAFpDR+xt9Jhx431F8rB4v8VF/axs9jpFW1dTu9WOaZxk/amVTcwXNA7IY3wguFYrpCPS311Irrj9uSMpZgSvXLuLktwjNvL11EPNI9YaekuQvHCB1BhB5Bjxr5y6GMnN8Bq6Q5mw58a/6fiMjf9VAEHDozk8hUPdD5RyMuTSp8pDCMfvwxSbZ9HHX2CooRz/ZuC86e4whLyADRv2s4nxYeXpKdL3lNzgHozbGp38AbNjgvGWUrrE3qSYDlVr7bPsa7Tg8CtBcO7Lj2q6XDhrKXaycUi1MbEYECCn1iqwrY5dyY
 sQ0xs5bK
 PNfE4OmIWmn5O31/eNbuGYHtgatu2ySPJUMafhT+RBrHoGI8CYQVk6ZkFq0oreLjshQG1VThv1f2uQwPLX1b1kDuqT6XDFWJC2EJyCTpwDRMo7YHPO2uvKY5IXAPGx2MDXOXzI6stVVnjQSMnImz+LhpDIxtF7ZGV+PShZ4CCF4cAEpWSyiNZlYn50irVoe7hdzb6Vg5PB93oipp2UdfX3h1RUfMAZv0Tv1cp5wE3rF603IipXcQ5DUSJrqGo2Ze2NJWt0cELVLB2FiKCH4CVWCmrpezptt1AbrMihs3DKdLhU8JeUvmRcrSliUGvx41VdSMqnrFIKvlvJYey6Wb7Uyh/2FI0QISyau1agCAEKSmHUpQZhxaV0Of0HpDhaKmRPaP4EwARxnB8s7PMFBclHCzOfG9xHXru29cv7WOKeu2cwxISrji3h0wAwPiBLcRDkBSAHA6N8hWafevDMyCujDKWBfn/Br6o1f/8TXgqkiRTzv0Kp0/QvgIPoQB0Dc3kQxYK/iN5g7HSsBT45YnpPyxNGYiuBLL1+0JKLc0pJVyhzoVD+73oz2mUFHQQKcE1s5786iHjHxzypwyDHxuEP5eYSEiXa2+B3eRARj8POfsoBC6s1s5lkl86i5Qzj3lvWONfb8FXJsEAVcqFFuI2BB9QW1Fffauj1oE/XoTa8wg7G/gfqyNiBxPIg/9Kdb8YLME1pZwMcWoLJS5L1jEMvO/SzC/iV0ZWcJzi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 1:18=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> On 11/12/26 22:47, Joshua Hahn wrote:
> > Commit 19c5fb83f2a4 ("mm: page_alloc: avoid kswapd thrashing due to
> > NUMA restrictions") makes get_page_from_freelist() skip any node with
> > kswapd running to avoid piling on already-pressured nodes.
> >
> > This assumes that kswapd was woken to create free space, although kswap=
d
> > can be woken up for other reasons, like higher order allocation
> > failures. Thus, fragmented nodes with failed high order allocations wil=
l
> > always wake up kswapd and direct order-0 allocations to the fallback
> > path, even when there is free space.
> >
> > This behavior was observed on 2-NUMA Meta production workloads where
> > faults would pile on already pressured remote nodes while stranding
> > memory on the relatively empty local node, causing unnecessary pressure=
.
> >
> > Only skip nodes with kswapd running if the node is under the relevant
> > low-memory watermark.
> >
> > On a 2-NUMA VM with a 60G node0 and a 20G node1, with THP enabled=3Dalw=
ays
> > and defrag=3Ddefer, I ran a process that prefers allocating on node0.
> > With a fragmented node0:
> > - Before the patch, 66% of faults were served from node0
> > - After the patch, 100% of faults were served from node0
> >
> > Fixes: 19c5fb83f2a4 ("mm: page_alloc: avoid kswapd thrashing due to NUM=
A restrictions")
> > Suggested-by: Daniel Hodges <hodgesd@meta.com>
> > Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> > Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
> > Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > Acked-by: Gregory Price (Meta) <gourry@gourry.net>
> > Acked-by: Zi Yan <ziy@nvidia.com>
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > ---
> > v2 --> v3:
> > - Shortening cover letter, suggested by Gregory and Johannes
> > - Collect signatures
> >
> > v1 --> v2:
> > - Added a Fixes tag and separated this from the other cleanup patches
> > - Check zone_watermark_fast with no flag to match the call in
> >   pgdat_balanced().
> > - Calculates mark outside the zone_watermark_fast check to match the
> >   style for the other zone checks.
> > - Wordsmithing commit message to explain the unaddressed gap.
> > - Yes, this is ugly. I have another series to clean this code up but
> >   I wanted this to be a feature-minimal patch so that it could be
> >   easily backported. Things will be much prettier once those are landed=
.
>
> Easily backported, but there's no Cc stable. So I'm adding it as it seems
> useful enough for LTS kernels. But at the same time not urgent for rcX ho=
tfix.

Ah sorry about that Vlastimil, yes, there should be a Cc stable. Thank
you for your help!
Joshua

> Applied to page_alloc/for-next, thanks.

: -)

