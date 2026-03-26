Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68308109E549
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 05:04:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCAE86B0088; Thu, 26 Mar 2026 01:04:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA24D6B0089; Thu, 26 Mar 2026 01:04:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A907C6B008C; Thu, 26 Mar 2026 01:04:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 947EE6B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 01:04:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 370AC1B8A55
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:04:46 +0000 (UTC)
X-FDA: 84587024172.18.0F7A771
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id 38362140002
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:04:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WqzZ69fn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774501484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NXNdAqi8gZqHB3vcVcWFzOrvRP4vFeU52TPthonPB9I=;
	b=VTGUApvzJEg7Gda26FtYQlEd08PhwqHJKPutsT8Lo+ZbLedp6+8biWtyRwdWFRk+g5VXEl
	snK0WX3jtvs39Cqb0d8FotSAyifkQxRCDzm67Pm2gJhN8expIu3Jau5bl/ZicJLMJ90Akm
	yC7xh4q3S/X2FijtPGY1XeDjM1RRC+A=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774501484; a=rsa-sha256;
	cv=pass;
	b=ZjTPtGPJ4SdcTyM6Hc1KxazHqC+3P1F+/enmGufRyrMa13H3UiqD3XxRQisZN79yeR/+Hz
	4JIMq00evDL1yx+JPOKOEvstDLhLosRYNX3tXFmQJYgGpVab2pCtDQFElXdvcrsczR0wu7
	ach3pQx5h6E1TpjRYJVtOZIca/CBk1Q=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WqzZ69fn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-50b2d6f9d00so5966971cf.2
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 22:04:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774501483; cv=none;
        d=google.com; s=arc-20240605;
        b=hGwUdw+Ugqz8Htpwudyh2N4MG3VN5ODEW3dXITLmVAY9oa4D5AIzTjyFCpQ0pBEKkJ
         mOEFRCm15gsqhY6Jpp5uT2BhCfo+2wMGXpPswhM23ADatpWi4ND9GmTMYga9SpdEg4C4
         BvrcO3lpAOtC3kyRdGKJBWPY4bUiVp3dtxX8OWMP5LGddGEcfU1erzE5XZLZBEy6Kf3J
         td+Eb7rm50qzK/jBCpu3bfF9w7sDj4gR5g8wr2Z8v3ez454UvM/4iKe3NfZKMkOcTqFo
         RogL5Hhf0UcGvvdXzXW40Dbp2zohRUBfkY/lVFfPKwQd0iTG11SA5w6gqYD1sYDdyBMY
         Ob+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NXNdAqi8gZqHB3vcVcWFzOrvRP4vFeU52TPthonPB9I=;
        fh=yEgmZbl0cmogH+AXRNZ5hgtJDln9y7qT0nkcXTZi7Nk=;
        b=aYdRd64DsT13AtJhd2FDRT9Co0ADyrl+kThAURo887bZ9Obb6AKDTEUVzX7u5uWKKl
         zbbLiMJRcQetfeLD8zHRffJUGs2DKPnuEqF8DT+WUKZt/b0hmkMMSVC1teq+XIPHSSgN
         vrC22F0ZnVx8N3rV71yHYcJ+Dp0MzwHXS1X14OdCvsFUxcjiVmR++BBsrkFzTthUvSnj
         bV9std6oT+NiWZzEyqo0M+p5MIm0HlH6NE/S/5Sx9EkLbb0mGH5EIRn403+LO5+4E8n0
         WXfxGQOWp3FKGCYEDuCt+kVgggnaD5x/Z2WSVnrh055eYXEO6eMqthCSuwlyGM/UdSTU
         1OzQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774501483; x=1775106283; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NXNdAqi8gZqHB3vcVcWFzOrvRP4vFeU52TPthonPB9I=;
        b=WqzZ69fn3LZpV16h4LWdoJvxTU9cjrpOQzyUn7FQ0MNsZFGvRDw2NLUprcq34eshJ8
         S8Uv48QVjNQqI66hXXivsOQzyEPmTaCb0ILJYmIRL/nQBTQpOd4EOx1G3r7B9Da5qnlV
         yENcDQX9DlNLmBjYBJyp9sxNs1aantXmfKw+gsfsTRaSRA80h7v8oysInFULbS60Y740
         Lf/a7ONZExWj9O8EPw+xY35iSofJ6vf4NiAh3wsTR6MU3JkT0QALT6M/qr/8u7/fkhKj
         nLePitLl8YnHNNwnPM7qzvPb1E3dtoa2emMVHX77U2AFjzlN6wCPwqD00Idp7xB17UDa
         S1HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774501483; x=1775106283;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NXNdAqi8gZqHB3vcVcWFzOrvRP4vFeU52TPthonPB9I=;
        b=P62GcU5UqucTJRlPeS2+7H8p2zbQdf+FZpBCOchS0/VsfS+vasc6nfSTmf54gIR2zm
         tyfcT/bnk7UK24T60GsAMGpQgu/7TU7DG5cKo1Uw3C4z7GQ/JZUCMPrH0nH+4bmbhiLL
         W1EsDU0op1n2GzpL4nO5qmzERAjuph0lPUulojGCfCJOaDrfP+Yl5rCEm+9HYhhjrOjI
         ogRgJLAs95QDZshpc6EpH8yBpNMSIvLVQ8q/LgUMrXHNT53A6eGu/JGjP/TYWC7GRplv
         Xr/aQl+Jgdmhe97Fzqiu9DuQ1bV+ykPH+El6vcBhZd/cIhj1mWy8STJCKjU0FFmY87vM
         TjrA==
X-Forwarded-Encrypted: i=1; AJvYcCVcA7yNYqR5sv/kkJM0o3KPDyp2e3X2qif2wnZujLN8gddTCpUCwPzrpYTaKFRJ+WROZbAhpqQogQ==@kvack.org
X-Gm-Message-State: AOJu0YwkRQ3bsFF6qS1WKMsetvwVqAc/x2b69VyarE5GfgXTnmFncL32
	fA95L/wjrEZUKbz5C9Q9YAYB0yven2As1iqKMFt6GSbm4ZppgNi70vnmP+aN8wjxDNtqLHArbZG
	hRrmqKghQzZi/+Fs+/GkPrULhAPs2kDo=
X-Gm-Gg: ATEYQzz5bFjyKU9mOcEgQgfrMn/fIIQkFcYr8fiAho5cFqiPQ1vZE0+tqleG05tRG73
	RnYXjgMKkumJx4yVWQ43/OvscHs6EtrTNAcPTTyaYeO7Bg40D783ao6c7VbluzadEXu+MrkjNjv
	fd7TxS0D+z+4cHTYnWEmoPuEuFhQEfAsL/bufKNY2TA4XwAOeDTlXhM02zjff2Qf+HT30V5lIef
	KVSI/QDAogd+eAG0QvIjXij+FA76g2sdNmNmGRkT9vh/geK7GkEnt3vZBvOOYU/qIx9cc/8pFNP
	OdAootMQs+32wjeCicEhudX0TT9iLbzWU5u84Uhzji9awqpXv88YO/2Fmw2PbRMSZ4ujHNEK7A=
	=
X-Received: by 2002:a05:622a:204:b0:50b:28b9:b0a1 with SMTP id
 d75a77b69052e-50b80e0bfa3mr81303561cf.45.1774501482941; Wed, 25 Mar 2026
 22:04:42 -0700 (PDT)
MIME-Version: 1.0
References: <bf40a20cd93b6c21f10db95657928fdae185e843.1774438978.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <bf40a20cd93b6c21f10db95657928fdae185e843.1774438978.git.baolin.wang@linux.alibaba.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 26 Mar 2026 13:04:31 +0800
X-Gm-Features: AQROBzD5-fyVXx6FhxasuX11GkG5ohrgg-o9DOJ5V-xnCF8ZHhi76mmqPfSKwXM
Message-ID: <CAGsJ_4x4-hURgpH4ctpUG41bpeyrMYWrVNvyZLYheunNqrgY1Q@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: vmscan: fix dirty folios throttling on cgroup v1
 for MGLRU
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	kasong@tencent.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 38362140002
X-Stat-Signature: i88exnfhnbeqnt6rudnp1kswhxjiupf8
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774501484-461361
X-HE-Meta: U2FsdGVkX1+RkVQF++AthggZlDLxtlRCSv6AW3Wam7Vz9JtKrZsSDE6G63Rhu1T7ldX1k9Vf2XkdFaceWMlQ0uUehNQWev8T0NqTVr+ZaPFh9htXd9jAVohsIwvfieHPRpSQVEAkd4iTj+b0rtkb/5ZvYc18vL/repbn7dG9Je4XCwhyubFejADD96Cpmwf5+yYl6ggTJTiQqY2MhTEYzDpS8WViSkPXacTUeqSEPbk6ZKcLW8T4BRaZuxFXWKMW2Cp96aOLwB1Xj/1aNzALIEUbjiJxbDFS8QlTaXTz6cLL7VrjoP2kBfgbclxdyZ/7gCOTXofL32EQ3HeZ96dKuMhJQWicc/5KmVau31kdUmIpllcZQy/Rtcx8xg6FQ2648H3/fIotTWW4A6PNU/HR6bLOJ9Hy2KhKbB1+JMlCmbbdck9p3KJHED3UHRghG+TWTIZhw3g+V0pzW2BspB7wUzoOxsfGCXvUN9uvBE3+ueoAcILbbpg5bla+T/zLFlT84o363IBCsIHFfreKThaFtVjh3yH+TaJ4fvl34kpCpeA2sn1vak2l9sicKiqk8OheyIM90R9HCUuLG6se8KzItHVzlJ6FTBHpXWr3U+U/Pp80mzQHj7/He/IyCbdnnMthLCq/xRWo6PbCeClF7Ivqbm9ko7hiGRGk+WxzF9HGtHHll12JHfez7SQe5bcf66ieXVwXmapTRh1dpwRuw6tABVCj3WVAf9chO4jSYl8YBFgElrjDwQM4DZqrKwcZa8CkpY3/CdD2P+5p01EgASb0i+skVpNqMILt6WEBXPffh+FdBB6qSWrnbv2vTa7k2Zus5Q/abVGMJqzhTbHvRPU+0oCjfQjK0GoNBbT3t4WKnbcnm3x5HviJvebBpv1sVQYc0Ni56IZ5kf6DtiEaSqlrIwMxCGWX259pjrcCBF/zIs1gknz5zaZMrF5rWq15tZKFc5cBjjChjXmexCrey+d
 1QAnuvyy
 GN1Qo6zfA+vVJe3hPQb/s8txin8tHWiw8XOqz1D+WVfOhHaOIJ5QmI69CQccLfbqLdssMGBoCAI7/eWBJyR8CRVGmbeQBw87JQx/ShKHnqvMPkAy+ii72jBZWzQN7jUUJCqxN09WbyulF5qFFogchh8QF/U9fe0pMdzNWA0dozq5C/PV+nkgGQynNDPO98G9dQ0yNSsO3xpuARMdI+HwVvf0Gq0XqAP4gO3adIZPGRPUR9KVETzcuuKMBEs+SYum0Nc2N7XLwp+tl79oDoBK+d5IE5yfLpQeixDVlJfH186dKFruTVr0W1cfIGWu9M5HYV81FXGxcGtWoVyDa8KwKlrWNb7Xodllyv3ubhiA0iPYg0MLhu1M5+fLhEeQp4UPp6Qw1Qr5zFiyscRWKSnvFnaxNFIKiuUaHMI/RTMAXQzSnxumaHJPQyOvLL8iUZu7jLEfi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 7:51=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> The balance_dirty_pages() won't do the dirty folios throttling on cgroupv=
1.
> See commit 9badce000e2c ("cgroup, writeback: don't enable cgroup writebac=
k
> on traditional hierarchies").
>
> Moreover, after commit 6b0dfabb3555 ("fs: Remove aops->writepage"), we no
> longer attempt to write back filesystem folios through reclaim.
>
> On large memory systems, the flusher may not be able to write back quickl=
y
> enough. Consequently, MGLRU will encounter many folios that are already
> under writeback. Since we cannot reclaim these dirty folios, the system
> may run out of memory and trigger the OOM killer.
>
> Hence, for cgroup v1, let's throttle reclaim after waking up the flusher,
> which is similar to commit 81a70c21d917 ("mm/cgroup/reclaim: fix dirty
> pages throttling on cgroup v1"), to avoid unnecessary OOM.
>
> The following test program can easily reproduce the OOM issue. With this =
patch
> applied, the test passes successfully.
>
> $mkdir /sys/fs/cgroup/memory/test
> $echo 256M > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
> $echo $$ > /sys/fs/cgroup/memory/test/cgroup.procs
> $dd if=3D/dev/zero of=3D/mnt/data.bin bs=3D1M count=3D800
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

LGTM,

Reviewed-by: Barry Song <baohua@kernel.org>

Maybe we can extract a common inline helper to avoid the copy-paste duplica=
tion.

> ---
>  mm/vmscan.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 33287ba4a500..a9648269fae8 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5036,9 +5036,20 @@ static bool try_to_shrink_lruvec(struct lruvec *lr=
uvec, struct scan_control *sc)
>          * If too many file cache in the coldest generation can't be evic=
ted
>          * due to being dirty, wake up the flusher.
>          */
> -       if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty =3D=3D sc->nr.=
file_taken)
> +       if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty =3D=3D sc->nr.=
file_taken) {
> +               struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
> +
>                 wakeup_flusher_threads(WB_REASON_VMSCAN);
>
> +               /*
> +                * For cgroupv1 dirty throttling is achieved by waking up
> +                * the kernel flusher here and later waiting on folios
> +                * which are in writeback to finish (see shrink_folio_lis=
t()).
> +                */
> +               if (!writeback_throttling_sane(sc))
> +                       reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK=
);
> +       }
> +
>         /* whether this lruvec should be rotated */
>         return nr_to_scan < 0;
>  }
> --
> 2.47.3
>

