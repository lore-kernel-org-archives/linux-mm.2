Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9542606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 15:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sunScaNE
Received: by kanga.kvack.org (Postfix)
	id A02B76B05B1; Sun, 15 Nov 2026 10:53:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B3CC6B05B2; Sun, 15 Nov 2026 10:53:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A5216B05B3; Sun, 15 Nov 2026 10:53:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 613A06B05B1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 10:53:30 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6BC70407CC
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:53:28 +0000 (UTC)
X-FDA: 85437798096.21.492854F
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf31.hostedemail.com (Postfix) with ESMTP id 694FE20003
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:53:26 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=sunScaNE;
	spf=pass (imf31.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794758006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B1npfqAT/e9nSAN2JlboNXLFbR8cB/EnEe7k+tEqTAo=;
	b=OgWAwjPrCjyGmUoLwwc/m/1LV+0hn5zkefJoC9n6xZ9FCFQDZ5lZAXIZyuWWBFG2R5Q7GR
	VNitIXnr8XovHoZzZofbi/FoTCm2b6P5yAVC2h9vuekFSgmMPxsYc+N3CmJLqd4UvLKlrN
	2CY8E3q/30arbyB12zifwVcUOcnAblM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794758006;
	b=IZylE/3rQmwnCnJTXi3er5yWapctI4Wi7QW+BQVM3oudhiH2lI6GnnLWSfIIf43ffRyfw0
	C+G4CCMqdLIiL378snVyjP/w39xpejTF9s7iSgZ2Q1Cngbmcm5XfokomQsDh9GQij+as8h
	3Ya+Rp0S+NPt1t2Si9NX/14W5l0wckA=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=sunScaNE;
	spf=pass (imf31.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8a052aff9e9so2652736b3a.0
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 07:53:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794758005; cv=none;
        d=google.com; s=arc-20260327;
        b=fI/el7v8ROEV3C3PP9I1o3wvbPUE/tBShCXAIq6wvlVjnEzuIasFwWiQ6x+K0Z1627
         juW6RELYKuCF5BDwbbizLzhJC4YK7nGeKBW+1H5bKzrvhsXDvmRsYmMxNtvMqnJlMf6B
         uHdYWM0y2MoSr5/OOVeBvno1gXFghKC+4MDHPyIz0Vl23AhBQ0q3LNQnizkt976jywkb
         qcO/gZ0ckda0Nynne1nB9rWHxVg6aDrlD8G/DdV8s3D4LFVeHyt3CZaMKcZmc6hnFi5w
         UekdveyeGa//wyZuPsYfTtM9GnytqhkAiQclC0JO33niWLZoGQEq+QTZb0M7L6BpP3TO
         9+jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=B1npfqAT/e9nSAN2JlboNXLFbR8cB/EnEe7k+tEqTAo=;
        fh=1URPuoaz4Ewouz5BpgiABfZSlY6m7j/SVQmuK608fPo=;
        b=re3dqq/6mriG4NUb3qM8wLtT/9KV+1WMUb0OiiyUSi41UjA0WUG1JZSuNvdk+pHFU+
         /L6Ndy9h+UOmxTOuqNsI0EiIYGIWiOBRDQQf+MdlY2E7+XGPgsb9FHQsuYlH/IGl8nCW
         tkioQ7HAFFXP6Hes9tWW6TH6qAD+YWb25Y5PuMzK8f75aM7iTUlPaaAUIxKZ/gM6lATp
         7NY8JiLo7YXmI77ZJW2boU+1II7I4PnemDaPN3+QiBE6EsOGOBaOKSgdONah2h5q42YW
         KsHVFQ8ldJODEb2tnflsZqFy6Tl3OgtBlUx9RPxOEyxSLRlpefCLWbC4fX6F8+s9bJlk
         f4Qg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794758005; x=1795362805; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=B1npfqAT/e9nSAN2JlboNXLFbR8cB/EnEe7k+tEqTAo=;
        b=sunScaNEm5mu0OfBMwMeVAmd+8Cnp/+6+0MIosk9xwR0oN3Sp0C7U04yhACzohwSVW
         Z13VyWlXhuTh4laDRBzFwrq+KlV4iEsQmp1HGb9Yj+rmYtkXtv6IsFIJBPW5N2Ge1sDH
         mj5vF+S/u6qswBVoe7Jq6VWJauxAnKUaiwWVlTSqJfxo3O7GCNHBzUVTSEXIKzEmYWZM
         s0QDQw5zFeUBVbcEsAOZjrWuILqEseDZuuHcnDXinNOgJRwmSE6+q/mcm/hlklAsxtMh
         nG829acuRx4GhAiPyEmRdZLTVE+YjFv70w4rXAvNS/hG7LSkvc3egjZjxaX15sd0sJi3
         SpZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794758005; x=1795362805;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B1npfqAT/e9nSAN2JlboNXLFbR8cB/EnEe7k+tEqTAo=;
        b=1dYXjde4VWsdm263RhJkdaoQKUWrhkdixUZXVV2wZyz39DJtrvpV6gmTpgcdcf+v/g
         A6mF3VzzwO6AeiY5iEviKtNNdOspy6NsKUoTLVVtm1egz6NHRINMn8ufi4wHcM38NWNU
         2yFaegoLF0PDcC47ac1V7d5wiz9ki1UXmXYZoXk1i3IBsuj3TYRPJV9EZENCvwsBJ8+M
         n+FgTPJIL4WdsWX0c+GpDdIJnvt5TUFYbtkb03jk+NnnMJ5Sl2pt99DlHkG7oCQwyYHF
         Ysk31qxwhNBbUZ0XlJWBS/RWjdhjv2OrwEVUwnSmh0dWoO27Awjq65YsySk7qCJm7T4j
         32zg==
X-Forwarded-Encrypted: i=1; AL+hErHqeDfhTyQDJg/SO58XQ0FXA8pHtwaqBcApGif4V7KE8N8Xo76nzin4y/m+uzlHuk8qaSAh6HwiFw==@kvack.org
X-Gm-Message-State: APuU4Z9hdLIDj0hkNBbPQQx8Ae/T2NuEhYZQF06/+bzKWCEu9FeQ2erS
	f35arjP+Y0iQXzDjTZ3OBrDbPkXELI9zpz0zuieF84iy7JXabPSgHYi21sHxemFJy4ebQ2INb2n
	Oczonax7OfvKQPKgxKu1MPBtvkFq+1+M=
X-Gm-Gg: AYBFou2YmW9nL9Iufm1lwiF6hqnU/f32dYDEmmooeD+M9kZdRLzlo5m2+S8BtpXXooy
	/+p0rbSScuyGvfe6Cnr7pNXLc1hiclqlPPlQtgFb0EmlCRY5AXE6nJGWdz7uueSYBvOzNBIcGnU
	1LLY8eA1FSUbPU4Wyks5sm0CLmEDQ59y2SgY2Bx9qDWQjsvdZ0Vj7saUrkWlA9cLbniiIyVIm7U
	cm59YMbM+M7YZ51yDiAwISgqEU0SZ+IILdpozlDNfuZ4ZW1/EHSHoV/WDE1fDzFk9r24281dbqI
	uE+AQcSZhsZzTD0V5hNGPvexk794GR/hCd/YvOnnOMfVum42LQB4rkkfMG/BRWtSQevSvzsqK1X
	uSfPtki5ZmQo+hqJPGPu2qDBj0jwIdN6flyi92XSY2Bjm6enqs6/c/JdxTsTOPE/X7a1weQ==
X-Received: by 2002:a05:6a00:bc8c:b0:89f:ed19:f093 with SMTP id
 d2e1a72fcca58-8beb69751d7mr7240080b3a.34.1794758005062; Sun, 15 Nov 2026
 07:53:25 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261114200803.23129-1-baohua@kernel.org> <20261114200803.23129-14-baohua@kernel.org>
In-Reply-To: <20261114200803.23129-14-baohua@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 15 Nov 2026 23:52:44 +0800
X-Gm-Features: AclHuK8Ub0sHjLEQvw3iGeIyjjo2EqcMqfHwipzzThFvw96dHCFYFu_0EpLJ-sU
Message-ID: <CAMgjq7Az+_q6=fBRH61_O1R+dcDci4k1g+wE17Q+Nv-36eFDSw@mail.gmail.com>
Subject: Re: [PATCH v9 13/16] mm/mglru: Reduce LRU lock contention by
 shrinking folio batches in inc_min_seq
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
X-Stat-Signature: x4tsym7akmyxneyswjtrc7uzc8fw9xd6
X-Rspamd-Queue-Id: 694FE20003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794758006-809529
X-HE-Meta: U2FsdGVkX1+8r5lMUsqGcCgfH4QXsuKMmK8CGburCvO80tXuMvCVozA9AyUlJENnaKQx6voM9rhcc1zkT/2XyWVpkx08SN0FCKUiP0HtN1s2QpPeP9gyrjPOO/nnnwNc04YebM/Ye0tCw9bpsyOK+IUpDVFjGfoh6VqBsQCtLMXr2FfhAXAna8a//sy/vluW9JxSVL1OBmv/5DKM7s0rqmjGzEK6+MOVDztWXe4UwO94BjwPG5bKlV2W+d2UQsVw+3nnVIYBT8JB6ZBqMdCo4xELH0GzY6poCtxl3fuzYOUyQN4bz6nDqBQVfdoPUn7nUZuuRV8AYEfm2mBuVo9mPz3srTxXR8f2FDKeX+sX7WGyvIT8ugo8y5A49b4MWzKM/g9U+dK+3gnl8Sf+Kf9bgz3VgR12oVcS7rM3jOA6Ur50wHhadrmrBpd/ElEulUXQMQxdIdcnSS4KvL0obCdpiYNU71OWZNw5t+baWkQuRcN/R3/srZsp70KBAtFtxIMSdD/AA/eYvR0Y18c/YspGzlSr6a4IcCsGjyBYid2sr+5AUBcuEetXW8ExiJaoplbpqhppe5HMABnvnKZN5FUrioWlyfMfgoRC8pQAnt4H244beCrNWSclVoWhuMgYCpjcmEPK8FVDipZ1A8aIZ9xcrQRMg6r+vF4P6DqYw2oR2me6NNuLtiv4VAwIkJUiajKJQy6x9MpGyAjteZcYYDeo5IK5orKbIUHmbJLFJ8w1D/01CslAQOCtGYuoNkEM6aX51DRgg2GpYpvXZxdbf3l5V6dUMXjcwWSBHg6RieTK09aIPYg5MVBLmDsm0c4WkynXAZPM7XUpL7hR88UIrnKOITI/TCex3HL9H6klFArjLlpqb5XYIVzcro7ztfv+fxCa6KolVApjh7FTzO5ICaY7SpkBhP6BY/qNoD6rYcVrFO0h2I2J32A0B/8C+jFN/mJvmkP2HooTJOllTdRzkRU
 MoKVfHOO
 ccXZEzS5w8NZ+VuSwDFGraIIbj51o5PFpqHprtd+fMrjtjviYnKZVUnwWlqNMA1R29s3Y6xiCB6FuNDg+G2M71nyT/rp4xVHIeSpY9jbCGOZDaCXtmTyz3exWoK3nOMdY8h5ZVEJr+8dgC/N3nN06aT1fLC//a/f748MH1HTP7/Jho+/MHyYmrbTyQfutcHGs6m4kBqUpoX5Qin5yglLvBSARJlCPJeRZSh8/sTK/UxNdN1BWPBKLTvoefb8RN/M62bwZp0kRxqYGMC5sj0hVasAK5R6vsf5qp3YZxLtDv+B7PfLrkPjTCPXaNSWfqT3+l0quzqVlI0TvtMOB4EfrHJqAlgfaGJ8wD3SxSFo1XR5FbilB5Jl/FS9TBmbzG05Djp3G2UgGGH4jVxSE6pm13IYaIzrdWZlRf2AO2xshTTWxVjTM8+6+KEN0xFMTatbtiTKfaFiDVop33/EfvSkrJFmKgStVTDnuxhZwef+T4ENdSV2wWktN4RISP82DkBnjGqs4n8BkP+fsri4LWwZvj55xPgxnKeCjpqhk//w8ZNWUia4xR0JoJ/vYfzxstRC27i5k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 4:09=E2=80=AFAM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> Reduce the number of folios moved from the oldest generation to the
> second-oldest generation in each batch. This shortens the time the
> lruvec lock is held, allowing concurrent LRU operations to make
> progress and significantly reducing LRU lock contention.
>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c9e22a5cbb51..6cb905162cba 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3914,7 +3914,7 @@ static inline void flush_lru_batch(struct list_head=
 *head, struct list_head **ba
>  static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>  {
>         int zone;
> -       int remaining =3D MAX_LRU_BATCH;
> +       int remaining =3D MIN_LRU_BATCH;
>         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
>         int hist =3D lru_hist_from_seq(lrugen->min_seq[type]);
>         int new_gen, old_gen =3D lru_gen_from_seq(lrugen->min_seq[type]);
> --
> 2.39.3 (Apple Git-146)

Reviewed-by: Kairui Song <kasong@tencent.com>

