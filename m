Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1EB7CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 23:45:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AF3E6B0088; Thu, 18 Jun 2026 19:45:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8602A6B008A; Thu, 18 Jun 2026 19:45:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74F0F6B008C; Thu, 18 Jun 2026 19:45:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4BA636B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 19:45:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B1D9DA02C3
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 23:45:36 +0000 (UTC)
X-FDA: 84894667872.09.88ED798
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 56B3F120005
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 23:45:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IM191oSk;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781826334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k/ke6HOl3OE3dNIblWk+FOFXX4RMRBNYeioQFC3stHc=;
	b=prqJ4T2Cdj9AYT6+xLL933X11FSrIZ/RWtc8N942lS2ep2OhzbGhBN8XKc4iV19hQ0zZPg
	3J2AQartqaIu/ScMxwlvQ8nglx33to4OCVWQ0ggWD+BByQj56+iblsykYwYvul//aDiaj+
	KlWSWeNdE29fqs5BTw1si2n8Yjb/33o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781826334;
	b=RQ8Plj3vI4x6uV5KIy4bXUeBtdODGtjEabpA8UmuObG3VD0UXB9afUoTxgOohYebAKt2IF
	Rnp1AalgrLtXy2oY4eCm4CuGk9O+pOutimiL4chfO/1DHSr3y1fM8zqAGMo5JY5pxFG6xO
	yDCxFflwu3M1nG/DDMDvZjZxVAGXlRE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IM191oSk;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781826333;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k/ke6HOl3OE3dNIblWk+FOFXX4RMRBNYeioQFC3stHc=;
	b=IM191oSk42Plvyaa9PrrO24UhtmyK5z7FwO6wuTfdtGK9n6vMu4GxRWTpzuBJmfZIVSmVe
	uwg01tUn4vSFjlYPw0OAihcKrG6vIPDG9NSjTEs2jhzCvTyQZ5g0sCeVsM5KHgA6P5AAcB
	K3F4KyvXiOE0K1ArAbnEv4X/a6PVVsI=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-316-F4t5QEGcMX27BK5GtIHR8Q-1; Thu, 18 Jun 2026 19:45:32 -0400
X-MC-Unique: F4t5QEGcMX27BK5GtIHR8Q-1
X-Mimecast-MFC-AGG-ID: F4t5QEGcMX27BK5GtIHR8Q_1781826329
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-396aa7e1369so6268451fa.3
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 16:45:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781826329; x=1782431129;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k/ke6HOl3OE3dNIblWk+FOFXX4RMRBNYeioQFC3stHc=;
        b=gXbCke2Zja+xuzJEoviHZ1Qu2CQTIjpv4dTH7UZC29KwJqwps1geZUqOvjnHPY9XfG
         I526tIFaTAIkKonCCluebdAqOhcJKssOaGYKydlBoRQcgQN2cK+95/BFqMaZTxq3nO+r
         p7KsI4ltJvH0avH3OB2K7IRHFeCOg0MfajjpWxGlE/JbesNQCqrYl4hylY8Xs8sWq8DU
         fKPUT9GcEP/+XBn+XaMB8FNW4d8MNEaZURjfE3cCNO8yYvyie5b1D0RIURj760rYC4Ny
         mjzp9X3X+lsVcTOB16ZLJOb6DoFGJdl/9VcmoCoBCiL4qSjGW3pK4bEslAv7CjIjpzu/
         r9zA==
X-Forwarded-Encrypted: i=1; AFNElJ9+RkBDj6yWSPjXVUvF9kNLDB22p/98ofuo9of4DSxq8hZmajMpJzFzUnwu72KATHWqhEubqQnf/w==@kvack.org
X-Gm-Message-State: AOJu0YxhEH2+fI42dsW3Bzzg9SwP7yhkdS72BTgvmPmGPV33thedvU0V
	kar3+vzqfokMeYeDe8E2EfI1VYHIgxJZvd5DGoyQCz5MyNIIYbjgYEEJZNq4ITAXItZTU90wDMA
	BBjGnoEvCYowWrjXIg6dJPPRqzgwuYAKD9SC5nB4VkABd8hULlSdkdX7lAfyuP7aVpPp+yxaxp0
	go9cszEO1ipEq/RTAdatGJTKLANVo=
X-Gm-Gg: AfdE7ckinWYNXi1KWBlTCl/W5rkk6h0xkxmdbtPHWk7xVCbOJyhLpTyvEypwjFZWVqM
	M8gCQPeAz8Zddpo3U4beYiop2MHQyJCQ5Z9mENzzaxilZGdaPC872t+VoKTsMdjn7keeWRLPeFe
	khp3AW9cyESR0Tp3N72n/IyatskupdbHVj9dakjyuH9M53wfpWuigV1VZ69BvDnod/BQ==
X-Received: by 2002:a2e:ab05:0:b0:399:8ca1:4f57 with SMTP id 38308e7fff4ca-3998ca154cfmr1210181fa.19.1781826329231;
        Thu, 18 Jun 2026 16:45:29 -0700 (PDT)
X-Received: by 2002:a2e:ab05:0:b0:399:8ca1:4f57 with SMTP id
 38308e7fff4ca-3998ca154cfmr1210071fa.19.1781826328815; Thu, 18 Jun 2026
 16:45:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260618221720.71768-1-baohua@kernel.org>
In-Reply-To: <20260618221720.71768-1-baohua@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Thu, 18 Jun 2026 17:46:25 -0600
X-Gm-Features: AVVi8CfpXlcniHEW8BHYP2v8fq8jq9aiq3d00nA4k097K2N3k2xspa-uon6fngg
Message-ID: <CAA1CXcABVASpEiK-NksA6sfZm0yssiFO0VS7KKELd5kzOONjbg@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: Avoiding split large folios if swap has no space
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Nanzhe Zhao <zhaonanzhe@xiaomi.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Q7bqYIHb324YXGUZXwAPGNDQHFCkqLO1tQU9ZxLX630_1781826329
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 56B3F120005
X-Rspam-User: 
X-Stat-Signature: pwmejuubfxg7b9t7g5eoss8idxed8bgr
X-HE-Tag: 1781826334-993295
X-HE-Meta: U2FsdGVkX19TBKXIeYbRqXdK2u1N9nJYG8XLI6FXq4ynGfSX7YnMstKEE55LC8MpHJ3JECfgso0hasgaVczVR/5mLCt0djRrR6CTbAAVK3orDEcKXxAlT2xOVjxluxvUbfev61QlN6bzxuiDMLJzDgdAg3xJbBgmabEGFIViZnBRjMdo3qIeZADLrwPeglC+vGA6N5Om8ViqVFSGOyJX56vO/Ly+uuHsELhGWuKmSvht9nyqwoP5HJ3lx5Ec0xv2VKZAEU/Nscoc+HQePlOXdkNRmBKDInCfLjJB3JB8o04iNuytYyWiaMVBQaaOMnU0Sh6VIFL4D2tzdULOv4tYRAUpEyWGA8oByVSydB0Yp+Bz6MIZLweTa+OSacINdkuinNz9HR9WD+mae+htZZ861AGUc1cabajPRWH9EMyDcHNxBBVomVPAj6YbVqApUYnMQw9j3fdvGRJtQRgT9vWcJqfEbgps7V5apl0TEtb+Z9+0Bhq1O2J1dW7G8HwU5xYiQCrdImWiyrmOMztUaw+UP0oL4fuZoeZCI7GyhCkcJZVKyD9TdORhxC65oZhTLLF7H7mmDzHV1THIZ7OlOVDguB0pZOWctkt2mzZtFs+crYWcI5ahygwb+OvK3oac0JB/bR8UIc9B3SrLJKGo7ADkAsll1kuhacLGd55SpGU6TZqYbjPd1AhPEVR9RR4yI7O4O3bbbYHkFKFfqNo/WEu+fk/fhw4AR1GQGlCip7USARxpFY9zpD5rBVV0Ex4EM2PiG+LMy/ZHmQqmYqGiuF7mhqKBDV8jNbjLDuJz4fj7M0a/fp9eNMQvuZ/MfpPh5IOPEzpvecjPtXH/9d79nMRN0O7vhvCriEWm8GFGSCBteMCqOVvIv9GhIASipukjjlibP9mqff2/i97JpoxVSoQJfLMhEZyz6jzSFIrBpTZI5ziCDNoEABtmW6ql0qHDDxSWtMFBbyAxmcC3L8ZYV+B
 Pold0xi0
 eFinJF16xr4qSjpCjFGM7V8TPmhbkclvAc6F7rCCq1cVm7TVyRUleMVmF5VIgBsxsQO13mRxmu8+hw1+ZDbypECEWnwk+tJ9sLQgYoR2KeyZOt6Qzvb8VeM+ekl9I7UCLA83xxwiJR1FWVeoceMNg9pgyLzlXlCn0iEN6Om173CJeyfIXH3ngJZgwvp4Xiwwrz60b4ATF7LNlbYdf11eFTdJ9aL90H8ChWBXTYiBgMRy0p+jmbphyc0yAmlCTB6T/51doffRVzy29WKGN6zB/uucDHFWdCkots7OJ119iATKS8jGkKse9HF/6m6qUkwhrpLjOSbRqbw9iqMYs9uRcWHESZkAT36hQ8YktNK2l3etELSWIzOf4DnBVuy7BsGM7Pe677tvq3rtmZUR4OKb93bfPjjwihMivJb2p1LtzrdZEeL26UCexzrHpPCwfPVfGsrIulZFtBZ/0KpI2lo7zQJ1OZOJ8gip46p5oOuLNgXB27mA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 4:17=E2=80=AFPM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> When swap is disabled or exhausted, swap slot allocation
> may fail during swapout, causing large folios to be split
> into small folios. The splitting is reasonable when we
> truly fail to obtain contiguous swap slots, but it is
> pointless in the no-space case.

Hi Barry,

Are we sure splitting is pointless?  Since b1f202060afe ("mm: remap
unused subpages to shared zeropage when splitting isolated thp") a
split can lead to memory reclaim.

I've been far removed from the reclaim code for quite some time but im
assuming in this case we can actually reclaim some unused memory which
might be beneficial if there is memory pressure. However there are
some discussions on whether we should further guard this zeropage
remapping behavior [1].

[1] - https://lore.kernel.org/lkml/20260609114619.144416-1-npache@redhat.co=
m/

Cheers,
-- Nico

>
> A simple way to reproduce this is to invoke MADV_PAGEOUT on
> a system with mTHP enabled but without swap configured.
>
>  #define SIZE (16 * 1024 * 1024)
>  int main(void)
>  {
>          char *buf =3D mmap(NULL, SIZE, PROT_READ | PROT_WRITE,
>                     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>          memset(buf, 1, SIZE);
>          madvise(buf, SIZE, MADV_PAGEOUT);
>          munmap(buf, SIZE);
>          return 0;
>  }
>
> With 16KB mTHP enabled, we observe:
> ~ # cat /sys/kernel/mm/transparent_hugepage/hugepages-16kB/stats/split
> 1024
>
> This patch checks swap space before splitting. If there is
> no available space, it skips splitting. After the patch, we
> observe:
> ~ # cat /sys/kernel/mm/transparent_hugepage/hugepages-16kB/stats/split
> 0
>
> Reported-by: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Liam R. Howlett <liam@infradead.org>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Kairui Song <kasong@tencent.com>
> Cc: Qi Zheng <qi.zheng@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: Yuanchu Xie <yuanchu@google.com>
> Cc: Wei Xu <weixugc@google.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 299b5d9e8836..33f84a5fe7ee 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -339,8 +339,7 @@ static bool can_demote(int nid, struct scan_control *=
sc,
>         return !nodes_empty(allowed_mask);
>  }
>
> -static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
> -                                         int nid,
> +static inline bool __can_reclaim_anon_pages(struct mem_cgroup *memcg,
>                                           struct scan_control *sc)
>  {
>         if (memcg =3D=3D NULL) {
> @@ -356,6 +355,16 @@ static inline bool can_reclaim_anon_pages(struct mem=
_cgroup *memcg,
>                         return true;
>         }
>
> +       return false;
> +}
> +
> +static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
> +                                         int nid,
> +                                         struct scan_control *sc)
> +{
> +       if (__can_reclaim_anon_pages(memcg, sc))
> +               return true;
> +
>         /*
>          * The page can not be swapped.
>          *
> @@ -1280,6 +1289,8 @@ static unsigned int shrink_folio_list(struct list_h=
ead *folio_list,
>
>                                 if (!folio_test_large(folio))
>                                         goto activate_locked_split;
> +                               if (!__can_reclaim_anon_pages(memcg, sc))
> +                                       goto activate_locked_split;
>                                 /* Fallback to swap normal pages */
>                                 if (split_folio_to_list(folio, folio_list=
))
>                                         goto activate_locked;
> --
> 2.39.3 (Apple Git-146)
>


