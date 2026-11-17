Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE408606A330
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 04:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cgneAeOE
Received: by kanga.kvack.org (Postfix)
	id EB4D36B00EF; Mon, 16 Nov 2026 23:43:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3E7E6B05B0; Mon, 16 Nov 2026 23:43:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D06E46B05B1; Mon, 16 Nov 2026 23:43:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A2CFE6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:43:56 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 29647C0221
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:43:56 +0000 (UTC)
X-FDA: 85443368472.15.9504D6E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4355740002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:43:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cgneAeOE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794890634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Aq/4bQWK6agJBagPkXF8CgZGH0YPmPBsGkYRYivAkc8=;
	b=b8ATcmPEDp9tHqAtG1Ug8y+Pv3UXwlfHdxoJ0114lZaP/2IkLG/7qjwv0sAv5PfJtfwt4p
	MievqkYKQo9dxLEnBw8OmXb3EGMeUxyCY5hevZVC66y0LmjVY7bWu7fnM7nnIWoU2cJg1P
	4v/c1N9svYFCSzRUgHph1CD4dKJHhU4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cgneAeOE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794890634;
	b=UOaHqBXu+9WUAgmHppksjnAFBlszDN/ylA41/JDnrT/XyidK2iNJUm0ZJ6LEgZ918QFgT/
	4BzpODITywJLrCjY/4SSubggb8D28q8qaCYjs3/Id4bMyepZvq9I4SpeAvml23pbmI3Bmx
	iUHjLfbzGQkAJ1QgeM1rxjLOZE2Gb0s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AA36845A8C
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899501F000C9
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794890632;
	bh=Aq/4bQWK6agJBagPkXF8CgZGH0YPmPBsGkYRYivAkc8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cgneAeOEwTgh4tPllkMNymY1UAI0lM9AFpi95plKa/ue4yIBg6G69n7KzyHwf+sQb
	 f9vwV4WQoehgE8IL+KpJqH7w/saD1mzuDDVDSuCgrVD0O4DOsd5oxf9i0AO3PR7orl
	 sPTroggbYonyrZdq7Jan/i9LyN3jP4JVO2W9JgP+yYJSAqa/g9xJl0PqKDfXmZMGWV
	 iPiNpHEvhlY5i0xPNOmNPQRa3TQo5veEYT3yfAam5a0COaeKe3N2ZnnvmVcbEDmA1Y
	 ZO9vB6YenC4BufHxPIUFsGOawIsvJ1THGFD4FJCRkQJa81UWRP0n5XRNL/cdbpeZpA
	 T2IvMxN+smeyA==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-9497a167a6aso58942085a.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:43:52 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFiubbShNajLBs2FoNc3oj09nCwYj1xi4zW4ztChJRFGq4sl8ubiH7N/AkoIxbZT4LXun8tXxVYyg==@kvack.org
X-Gm-Message-State: APuU4Z9B4VadurcPHUFIhRA8PECR/sICNHYYYyV8MjM8ufHIk0bO6PeW
	v+jPw9umHKMP7gNQrMioLgUZa4UV1exNfiWIIDAcrhfs15m4Mmk/dGZtQ9LvOaynTAmK2LC2E6Q
	UiTTzBcLRBUYq/xFiuBOlSXBjybAyvrI=
X-Received: by 2002:a05:620a:2915:b0:949:70c5:c0ce with SMTP id
 af79cd13be357-9498b8ec2dcmr265533485a.19.1794890631760; Mon, 16 Nov 2026
 20:43:51 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <179488434239.3564555.16227252580122398690@icloud.com>
In-Reply-To: <179488434239.3564555.16227252580122398690@icloud.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 17 Nov 2026 12:43:39 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wzsCm_BBh3B5s5K=c07bRk72kacU5vbzCbn_U-AvSWEg@mail.gmail.com>
X-Gm-Features: AclHuK_rtoz70VnA_M4UGikPk3EP06ruH5kDNTs15rnzs6z6G8d8BBzyRtDcXG8
Message-ID: <CAGsJ_4wzsCm_BBh3B5s5K=c07bRk72kacU5vbzCbn_U-AvSWEg@mail.gmail.com>
Subject: Re: [PATCH] mm/vmscan: respect can_reclaim_anon_pages() in MGLRU get_swappiness()
To: Muhammad Haris Awan <m.harisawan@icloud.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4355740002
X-Stat-Signature: nz7gtdi8gzpiq9fsk66xp6ujk8zd7aks
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794890634-186092
X-HE-Meta: U2FsdGVkX18S0zQ2Uk0SAHuklegN+XNfjnrcj+TWiYq5QZMs8sMFLIk7cpudcTXtnrHMN/nnF8LDTq3Cmtw3eoe0E5Bh3XeR8n0KY5mvpPlZn2jDuVL+R+k27RiwhIvezos0/Fou5fMwLbqRcO3DcVNwOSIlQ5/fc9geeoAfSWHf20w6i9HpVAAsUYQXGWdxrCgtINdAm0p+4MeQQh2lQIskh+RMJwwqKSqT11QwXigB07RkoYFFYo2a0onie4o2p2jSrZPwJ5eOhZtA88vHLs1BErTB/6fQaDMfFMDKU3PalRko9E+NjQYlhPn2fqtnYqqdAuo87afJ8bJKNvWTWu5BXWXxGcCyYi2o2YgM6wksZXWCLFDAWmZTm258qnsIdIC8XKSLAhfIVoIAKJUe/Lodmimu0Hp6Sxa3wEVyEt3+/pXjpxHqh2TkvONRQXdTOS/OrYB2q9LuJkcydPrOM+aKp8sUGM7TWHfTlkBPmfL0l6tJwxfp5Mi6ov82AbIwtugV+T4a+d/dCqi5dMrxds33J0PoA7b5mnMrEmMzRKtewcNUBhUi/O5bdjCZL8XAee/4zmVsiR6G34fA8Z6dFhf7Y3KY1/M30iqC4Hikg7G9JA46LDNOMNBaY2Nc22mbdu1SujQ6ceHJEpaq/8lbm2OcSQYM8UR2iFNMcb81FaIkwhKxQFuls+5ouTzEfgWGLqoV6hx7BNknl72f0MLQXE71zf8SzfgxeMLK05OoO4YcX/WUCVjMkWs6q01G9ksuPUdJb8OmEglfCO6w5flgfkYgxfl9BrFPJiGRkbKvoM2pf7ieWvuUA4g8zkBNNhfISjyQL+PZY4/LU6XKesO7VvdTsoGfqIFlTjesHPQQn9yX6ido8DFKCO9vFl1zI0JdcmzHdsEIoapPHIZ1hmCBPryXHbysVArxrvLBjrpaRNT720JpX2kiRiPoLvtmMy9DXDjzzkZgYvR1GIc6Zmw
 pBQd2opA
 MrqvaIkhT02MqTEf8sAZ9Nr0ZJ5DgU5fGptyA86fe+G1xc0D04VSfQYYLRqXgdYVFPhYbAiCpjBUk6exLj3D4pu7uWAdF6vILXOoclS2DIWUSbKy6tnuqaKTT7kSyZfzsTYham+aTRAxf/O8MPNSnB5Yr1/xganPJ6GvqnerNixQl+DrEgd+5v//p9V6uiNNB9q1XHFWbcGKguEM4LBlthX+p9vZL03b5AhnWaFFofgsZGESzdGhgcFnPQSYv1hfWAqWH4QWKI76uLady7culKMsMkCf9Xu3p0VWfgjoVfTFiABo1kXxVuObIFo57Adx8ggbz4OgTThcpCO6N9++l73Fxx+TdcLBsVDZ2frnqOwx+E3Oir9cTquLmFjc7Fj2xKY1lXYIk7ITuQ2cpIsvy9HbV6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 10:59=E2=80=AFAM Muhammad Haris Awan
<m.harisawan@icloud.com> wrote:
>
> Under GFP_NOIO reclaim, reclaimers cannot add anonymous folios to the
> swapcache and can only reclaim anon folios that are already in the
> swapcache (or demotable). Traditional LRU avoids scanning anon when
> swapcache < (anon_pages >> 6) via reclaimable_anon_is_low(), but MGLRU
> explicitly skipped this check because get_swappiness() did not consult
> can_reclaim_anon_pages().
>
> Call can_reclaim_anon_pages() from get_swappiness() and remove the
> lru_gen_enabled() bypass from reclaimable_anon_is_low(). When anon
> pages are not reclaimable (e.g., GFP_NOIO with low swapcache and no
> demotion target), get_swappiness() now returns 0, restricting MGLRU
> eviction, aging, and fallback isolation to LRU_GEN_FILE only.
>
> Signed-off-by: Muhammad Haris Awan <m.harisawan@icloud.com>
> ---
>  mm/vmscan.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 6a1af9b92..f5fa67985 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -379,13 +379,6 @@ static inline bool reclaimable_anon_is_low(struct me=
m_cgroup *memcg,
>         if (!sc || (sc->gfp_mask & __GFP_IO))
>                 return false;
>
> -       /*
> -        * FIXME: MGLRU doesn't fully respect can_reclaim_anon_pages() fo=
r the
> -        * scanning type, so only apply this to the traditional LRU for n=
ow.
> -        */
> -       if (lru_gen_enabled())
> -               return false;
> -
>         if (memcg) {
>                 struct lruvec *lruvec =3D mem_cgroup_lruvec(memcg, pgdat)=
;
>
> @@ -2893,6 +2886,9 @@ static int get_swappiness(struct lruvec *lruvec, st=
ruct scan_control *sc)
>         if (!sc->may_swap)
>                 return 0;
>
> +       if (!can_reclaim_anon_pages(memcg, pgdat->node_id, sc))
> +               return 0;
> +

Thanks, but we've already discussed this in [1][2].

This approach is incorrect, as it leads to hot/cold inversion.

Xiang's approach [1][2] avoids this issue, but the code is somewhat
confusing, as it effectively uses two swappiness values: one for
eviction and the other for aging.

We've been working on a clearer solution in patchset [3].

[1] https://lore.kernel.org/linux-mm/20261010141057.599595-1-liuxiang.277@b=
ytedance.com/
[2] https://lore.kernel.org/linux-mm/179248830836.1744016.84242178112866169=
19.noio-mglru-rfc-v2@bytedance.com/
[3] https://lore.kernel.org/linux-mm/20261114200803.23129-17-baohua@kernel.=
org/

Thanks,
Barry

