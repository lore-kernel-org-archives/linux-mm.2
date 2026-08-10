Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 831E6C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 23:07:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38FEE6B008A; Mon, 10 Aug 2026 19:07:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 341976B008C; Mon, 10 Aug 2026 19:07:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 231146B0092; Mon, 10 Aug 2026 19:07:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E86816B008A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 19:07:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 754DD1C09BB
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:07:06 +0000 (UTC)
X-FDA: 85086897252.11.A03924A
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8C52114000B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:07:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kZAb2xt5;
	spf=pass (imf23.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786403224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GCABb60aL4urD95dRbCNuIxeP5OzqUhSPXtLS3hYxHA=;
	b=Go4dYJoLOiatKUWNBxE4qaBSyzTmRjk7YXWYDYqXm0mG7p6WW42P84wQNCPKvZ+UCh4G/Y
	32INd8t7rOlypXLYclmssWktnUesWKQMkpPLeak3EVFXpavoOENigIp5HPFdpLfnaU7S9o
	NPbfxZAPspLFIhfnvnLJravow8SZE6U=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786403224;
	b=QCPskDTxa0lZ+F3zX9mVqQDcyzCqFuuqmFSGi3xekJ0ZrCEGRuPGRBiQm2u6jWQwaEUggx
	2+RLIRqur5ILWroVP0Nt/LvdemK9wmtHx4OsPSeWtsaSQkNbSyf0c8Sb0cZbcq8JuHDnZD
	J0jOZn5EY/N/j5RbJnMO8KkkqAUyjbU=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kZAb2xt5;
	spf=pass (imf23.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5b0129cf6ffso3323e87.0
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:07:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786403223; cv=none;
        d=google.com; s=arc-20260327;
        b=c7uhTLfsvobEtzBJGXCyrUTfsvtiJGUvkyDgkxJ73uTEtqEXSkWN7ziX2PQjPSnyBv
         RWWHXxnhZP7Ozh7YF1PfdRMinMtHWMvnNZX5cUbgPlh34Ubb1bHaxTA2E/rVDwuM55J3
         vt7QER/slNMJXwsgSxSRa627uwR4HsbDm8mMm2yyx3NPBuqHScb5GhtVeV0FKFxEdb+b
         bCiiqzCT8hg72LeDZkcae0/78s1dQmVBOcg5FMdgd7GttzKrEfBEyQCMYnD8121rFAEh
         UOK4u2Mba7GSRdv7oiEqKYGTx9bZBfmmnv3b7aA5hZMcKsW7ddo10ssOXkILc02a3OTA
         mrbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GCABb60aL4urD95dRbCNuIxeP5OzqUhSPXtLS3hYxHA=;
        fh=0YFYAdqULYwj6poxrlTgNquT2YyurXg75pblcz+zazU=;
        b=Mz1FMj6yVm8Vb51Bj2xlHJr3idd9BHF7pKWj7CrTB/6mXtO0NxCtJx5oIp+3KRrsLR
         vdhKUhgmhyy/0xHyQB9pU1afWkdB1E3xDCEjMW6ddGWjW4pLEW0PhLpeZEkGali+XyKi
         k6p1000dTE/k8Y8gjEv8fyrklGIzOJud+42Etbt72b/OmBYag0++oQXvZ96gA458zZxm
         0Ri1akLG9nkummEOtoSyBvSPgbbZVVvCocm6GSXoe1qFfYg+jRdz2XF7GsWMIG7VnoFB
         qqZzrX5vOw5vDc1np3UHMYaeXSsLS2AkVi01gId67CcYIAVP2Tz//wyxSIVOvYUCArRk
         9coQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786403223; x=1787008023; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GCABb60aL4urD95dRbCNuIxeP5OzqUhSPXtLS3hYxHA=;
        b=kZAb2xt5kc/YEdTzc5IpDLUhstQPYtKHC9rPmR1gXxaYxyr13jzkgXeOrq7aiiXdim
         lx1CIYdlUdnfCOVScRVm6affdEGvYmoKvqI/p1V9ZUli4jjB+kNJI4U4fk5zxDTh9Ayy
         dXCWS+FguLgu/I8CmybMgCdhZ/mpsp2pmhB4rI1JNBQ15hPPYMnHxrrSnO1E9+mHfbrF
         HC7XoOIMTbhMz9nXlK9qRE+hXYpZvhUhLVZFu3l2kG8cE7nrl/t1pU1EVZqt26kZZplU
         dsq+0rMTEpGaRTA5Ny90w1BJl1NC9oD+4Xq6tFjYpXfKNvbgiEJnXHOPayoCLHuOGCZN
         Z8jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786403223; x=1787008023;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GCABb60aL4urD95dRbCNuIxeP5OzqUhSPXtLS3hYxHA=;
        b=EM2vDEAh3gAGAri+R0e2igCd5bfTz96RwxxSmFBZe+bXngiOqKlvcTFsFp0VA/MWzD
         cbF9/qAUZRyE2Q+nPodOFhRKFVvi6ZQBBfXi3wfGQgJsxct/VsnDaUuRBr2kWwieVRqG
         Qt0OO54uG5IQ8t+5yA7J84oMfrdDla7y7Ls7KgiAI2GRXPHzEahRh+d6oTjfM3cn5phZ
         LHdHFllRcw5dxwikImRdTdmjdOOrSjpzpkxyg3PXNGBoE9DCg2Qxg1BxBn6+6K7vRSxN
         /pqKytGQgDwOXHEMKWXP3Sh2/Rc0xRul+zMeMYTo8viBPcpxTFopVpvnWkyAAMHAaKvB
         VLYw==
X-Forwarded-Encrypted: i=1; AHgh+Rr41SHu42Y36KBvwSh7UkwdPV1T+sgqzK8honbmDUgwGt4TovW5pGK49Fv2UBFUTx02Kk+l+CSy/g==@kvack.org
X-Gm-Message-State: AOJu0Yzz/gixE6FyOr0my9aWU2mi3Nbic+YeSOC8TWJfoRTDLxmXJRqO
	HcJ3zx1lIaS870FH8vjndXHCNUA5FrlE+td2sDJLk8tMtZiwmx2OHaJUbd37VvG7T6l5Z+Jiei7
	KN6NUPvBJxqy72NoKrRFkH1iO0TnzPxCJeaGBgOWm
X-Gm-Gg: AR+sD13WtRyTpb3XbvuYIdwT6XFukf1nYH4CdkatgzjPcoz49xEcwBbOwIvSncnGR05
	K3zjiI/92S5erAca0lGNfwZuDMhuHvFfoKRbmVLotbEcnT6s5d9WBt0FzlGJiKBUwJ67NbE0W1q
	+BYeOiamokduT7FRG5MOcWpP8AKekyEr8oUEdiatkk61ChWSVSFz2F9IlkBoQszUtwlYgk2v6Ax
	/HXbECSTmgMzVvLt7lD9+8RDDe95HzQOu0XUs8KQFlM/uTtpLhH6dSDfBIKZsQH0DFCtWIDZYC4
	k2X/vzq92AmQ/qIN/Ng39YuZjoZx7eeurkeVdl/Ok8fU6rXG0WV+MxOAMDLdlqqOhQVZC/C22Nd
	QEXO9usZFLGRh7uLqS8Z/NZLRDRBXj2I=
X-Received: by 2002:a05:6512:618a:b0:5a8:6646:d7b4 with SMTP id
 2adb3069b0e04-5b447434806mr46919e87.1.1786403222424; Mon, 10 Aug 2026
 16:07:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260809043250.2917406-1-souravpanda@google.com>
 <E2FFA328-21B3-4E3D-8CB9-5638B4CB545B@linux.dev> <CANruzcSySUn_gLEh9kxwvatSCn4hizcy6v2BkcMe0Jb=HoUOSw@mail.gmail.com>
 <60440F8D-5EE8-4254-9057-5FAD09B5D1FF@linux.dev> <CANruzcQ_1533umf4ym-t5EVm_WX5rrYtCbCqaTdvNr6EgOYR=w@mail.gmail.com>
 <20260810153628.c4049163bd92b5ce3d3d7d99@linux-foundation.org>
In-Reply-To: <20260810153628.c4049163bd92b5ce3d3d7d99@linux-foundation.org>
From: Sourav Panda <souravpanda@google.com>
Date: Mon, 10 Aug 2026 16:06:50 -0700
X-Gm-Features: AUfX_myDq6n4u6rsvlkV0GKG6wH0E41msu6vkHUr7hfoZ3RxBG0OnnkjQn3L2rs
Message-ID: <CANruzcQWLgnptOMbqDPeRDwW9qd-Z3WCyba1GVnss28se8W2=w@mail.gmail.com>
Subject: Re: [PATCH v5] mm/hugetlb_cma: Fix null nodemask dereference in hugetlb_cma_alloc_frozen_folio
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>, osalvador@suse.de, usama.arif@linux.dev, 
	shakeel.butt@linux.dev, wangkefeng.wang@huawei.com, anshuman.khandual@arm.com, 
	david@kernel.org, surenb@google.com, fvdl@google.com, gthelen@google.com, 
	hannes@cmpxchg.org, riel@surriel.com, sj@kernel.org, vbabka@suse.cz, 
	mhocko@suse.com, bjackman@google.com, zi.yan@sent.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8C52114000B
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: jn3nnca84oz3fp5dcpshiekbq8ns6cgb
X-HE-Tag: 1786403224-623826
X-HE-Meta: U2FsdGVkX1/6nzp7bJFzKfZPkDo0cnB7pWfT/bHTEuovzVu+l/4xXnSsrI3LiYBVzO6w0dB04s4P/F++nxtHhGmHqdcWwYXVSB+ospGL1Ghh84fl42k4YhXR18tiZA9L3Sv3qEzgFvlYXI2WCQKkqpijdsTTSr0EjcZT7AoiZFq/Cp2ipcGCCHmnNtB9G05z5nV8j5Eoe21YX7EaRZdXdJe8/1kI4DLXRnmwmiif+afglvNsHaHXg7csbDV4OqlMQVI4nblghFsQT/xkbQkU0vOU1UbD2rM+umXsghkWWRU+Vb27K+X6dAMtEYKKjHhTOreshLP3HxIKms211aNJtrxLUohzkEOtqFY71VqWsm0KrJYaw+Rlv3xg0RWpnBENQYnZ9ys8A096xZMEUD9guGDwfvWkRj3qHpNm+PKnK5+f+CenIIhY+J/11FI0hLdWatoaGU1rW5wH2b6or+yerXWmp+TGMQIT8Bo6356FUvTMqXD4OUZmWtZRWN5oxKSQSv2KjP7SWWVISxbeu8/aOpxCEW5tCbg7vvphFWGN3jz+CSlBRSvQBDphFZyiKIZHfC7Yx9Qi1v3sPLjuy5OjHU2JJY2ZJgSjtLltxdU8d6H8ZpxVApRY5/bC+en/vtl3fUQ9OqLfnIUp3LA9aoPUU11tDrkwSIeCKjZQcwcPQOo9vbkTORuq55G424VsbT8pjwOqkhgkJKfwF+O4A2n3xZc4fp3bU/eT7rRAHr6PfhKvKX6jYCIFZJBfvHdnNae4OcGN1d36ALTXkY4gEYz1NoVyvdFuP6XFX+ACY503X7fUI+Nt91zVfAsprA/esv+8x6vYBCSBE00J0/udIRBc30ryeS3ky2u0S93CJVj/9vo7VGJSnuAxT3125Y34qLxKoIxJCmc4pteWAS9ooam5NNMbOahyC2wMDABXVR9pMnV0UEIx3HhHOeJyZHCl6qk//sLC1DWMswB72B4DdVw
 3sGO0rHo
 QE6XdzAltzyFihWA6x5Qk0AOcQmIh352jddBKOJQizzDPK6mMbJ0Zjs4farxScmijmFxS/e2uujKkffMhsniJKRi9F8XCREByvkbt1x5hccNT0zy1B/gGhlQMBuAHEti42G3DdCR4x5YYwdDO47OYjAnz+8QWOMhrH7pPjUFMVD0qGMyenxBol98oOp5pibfpNW8a8cKpm9yXhwHNOPRoJIMTsKfm0FG/fxrlByPOaZNGdOkW433/gkA8P9Xxs4zqnw62hqNseubbA3TzHgr6OZ2EAI6ZBE6bWn163iCzUv0D999iB8wINtUr0LVDzTxQBJiEPwGDypRZ1Vmbq549q0zzliYwwklbXC4q5FD+fkRSWw52U+M1/ZrCPJSyPC9yIXJf/9Ut/Xoq2aAjhyc3ZMkybgcMeJ6gvCMHXNv7Zbgo644=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 3:36=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Sun, 9 Aug 2026 23:39:22 -0700 Sourav Panda <souravpanda@google.com> w=
rote:
>
> > > That way, we can remove the 'if (!page)' check here.
> >
> > Sure thing! Thanks! I shall send this tomorrow noon (PST) since I am
> > OOO starting Thursday.
>
> Sashiko said a thing - I don't think it reported this against previous
> iterations:
>         https://sashiko.dev/#/patchset/20260726072935.3513996-1-souravpan=
da@google.com
>

Thanks Andrew!

Got the same response when I ran v6 against internal Shashiko. Sending v6 n=
ow.

> I'll add this v4->v5 update to mm-hotfixes-unstable, assuming it gets
> us a bit closer to the final version.
>
> --- a/mm/hugetlb_cma.c~mm-hugetlb_cma-fix-null-nodemask-dereference-in-hu=
getlb_cma_alloc_frozen_folio-v5
> +++ a/mm/hugetlb_cma.c
> @@ -3,6 +3,7 @@
>  #include <linux/mm.h>
>  #include <linux/cma.h>
>  #include <linux/compiler.h>
> +#include <linux/cpuset.h>
>  #include <linux/mm_inline.h>
>
>  #include <asm/page.h>
> @@ -30,12 +31,21 @@ struct folio *hugetlb_cma_alloc_frozen_f
>         int node;
>         struct folio *folio;
>         struct page *page =3D NULL;
> +       nodemask_t local_node_mask;
>
>         if (!hugetlb_cma_size)
>                 return NULL;
>
> -       if (!nodemask)
> -               nodemask =3D &node_states[N_MEMORY];
> +       if (!nodemask) {
> +               unsigned int cpuset_mems_cookie;
> +
> +               do {
> +                       cpuset_mems_cookie =3D read_mems_allowed_begin();
> +                       local_node_mask =3D cpuset_current_mems_allowed;
> +               } while (read_mems_allowed_retry(cpuset_mems_cookie));
> +
> +               nodemask =3D &local_node_mask;
> +       }
>
>         if (hugetlb_cma[nid] && node_isset(nid, *nodemask))
>                 page =3D cma_alloc_frozen_compound(hugetlb_cma[nid], orde=
r);
> _
>

