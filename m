Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB5B6F45A1E
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 04:43:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F6CF6B0089; Sat, 11 Apr 2026 00:43:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A8AA6B008A; Sat, 11 Apr 2026 00:43:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED97C6B0092; Sat, 11 Apr 2026 00:43:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D8E9A6B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 00:43:15 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 84519B9235
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 04:43:15 +0000 (UTC)
X-FDA: 84645030750.06.B40EAFC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id B4B0316000A
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 04:43:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=STkwmySK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775882593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6PJGYSix7bHPbiZa43f5H5Hv0XXiK/GgmjCJI47M2pI=;
	b=PHgiXijiZRkRntGv7R25tUPpU9f+LPxg3q450BBp4o5Zk4y0wFW09dM9fXGKd8DEaK+joO
	8SvQFKTYy/BV3pFv2sMR/wivVROe/R8F6mG2otRgVhWcEj6XX3aXtbgZJUN4nJjVLjxfd1
	M40gORE1/2CGWYo/+LCOiDe9I7ng0Mw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775882593; a=rsa-sha256;
	cv=none;
	b=mxUklWzGv/nx5z6uCL4yon53e9xe3IZ6NlyHDkc/PTiAFkSTbHcuW6Z8ECOrDvKF20Tkfj
	2YWbKDUALP8SPfAu+na3tdw6NosNofj+BELaalCwkJWgqMWlXmpp9PvwEnBxxT8ll3zrjy
	+oP9B8QtMnCOJXUprad27wHdmLo5bww=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=STkwmySK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CFB576015B
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 04:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E30C2BCF7
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 04:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775882592;
	bh=MFwF6FqK2VnTkZeL3ROTR5tHQRdGP1jWQe6irXJD5c0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=STkwmySKFIplUkFeio+4ujcKsVpHoQOAAHUvH1zJRUKiAVYqi+fskSgpWIoCRZD0a
	 jKOsCKcnOte5gyZbO2nuqNFgXDGzBJQ2dEQVktoupWpzo02FhKLztsjzqWCyWMG3+s
	 XUiZAVHd71bxcpMMf5OXCLe41qvsB/csAE6kz8zUCUd4WMoWv0Q8nzIha2tPqmV0GH
	 auPFZprxmL794Kl6rDyUoQx17VmM1U6sahTI6J+JnjlKV6xcet/N/5rsSzdYAY5e63
	 zhzP3eRICmtPaCWK91gJQv4sO8TPrsLYpMSegHr0XUBv9m5nuBLoqMpX0EJkcpQgmO
	 jOpxHX6XEQ1WQ==
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8a56ca653ceso33123196d6.2
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:43:12 -0700 (PDT)
X-Gm-Message-State: AOJu0YyB3lMZfIZxMO5sQ6vQf9AATB00ipyfv9AB6KrmE2l5xUXTZ7Yn
	c2739+TKp0lkteACFfngsweWWWtqM7sqFlY0m2zYA2DxRg/hB9Z9a82ufvwKeAPFh+68uf4c6AY
	DH35FDlyXeyKpNKLH0fGGdz4Y1dUWdYQ=
X-Received: by 2002:a05:6214:3101:b0:89f:2ae0:3a02 with SMTP id
 6a1803df08f44-8ac8617f375mr77592216d6.19.1775882591624; Fri, 10 Apr 2026
 21:43:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260407-mglru-reclaim-v4-0-98cf3dc69519@tencent.com> <20260407-mglru-reclaim-v4-12-98cf3dc69519@tencent.com>
In-Reply-To: <20260407-mglru-reclaim-v4-12-98cf3dc69519@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 11 Apr 2026 12:43:00 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zpNLtx6rFFF7fG83TKZ2PpX3JyevZw0KJOL0=cv-ke1g@mail.gmail.com>
X-Gm-Features: AQROBzBtIciFHI5MXM5Zz8v0SNR883svaLPBfwVN2nmcbC_CFW0afgYxPbKwYqI
Message-ID: <CAGsJ_4zpNLtx6rFFF7fG83TKZ2PpX3JyevZw0KJOL0=cv-ke1g@mail.gmail.com>
Subject: Re: [PATCH v4 12/14] mm/vmscan: remove sc->file_taken
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, David Stevens <stevensd@google.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B4B0316000A
X-Stat-Signature: b4b6hrnyczmkn3h5nxykxhh5wtsj7xog
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775882593-754581
X-HE-Meta: U2FsdGVkX19+86k2pN//A2yL3DlPpS/tlvozYtDVWjiiCG/RBEQ89tVKWw4e2bWpldpK26VYWHefLLJUgOohGOI0Axx9j0iVyPQyexJI60ze3m1cy3Yxhc+tB4D8959lh0zvS8VnAjipKejZV2CQLA+TX1Q7/Ynf+mHAduZB6l4AXtTDKKVQYdOU/yv8cr/HXfL+lmJMonsJZcAoUmaC4AD+ml9EHZkrXVRpYgKUV1b1h1f0t35I624BGqnfJkViNlVUgTqr61SDtgxIexnzv9yhC/svG3B13gLizBN0mP0uwkZqCe3Do9vB8NVYu4mBrMIyyWjeUKY+990O8heI4p1N7OQJrfQosHuvGRfFoT3Qaridel2iRjHQbCA3irGh6X3Y/wbGjLqj5lOLYFhEOIDqBQHBPV4YLShu4V9a/BXwVovBNhHDWXUburw2EqGbP+m5v3umJYpEEkcR5HokqlbCyItyTZWLtahCxP5w9K6/wmaSeSL+9fIE4fWgUkrm0vaHWEOv2ucdvrSRQei1L69g/fT9JGBsyfbQjxCut+Su8ya2mjwwxI5ww/xUfPfdkyLg5SBmEpKWt3MINm1tUwhHl7Cagnbaekj0dE+2PK3pro7MdYL8IE0J5TqKOH9+F61RkLhXAS8trlpfkGglC3DXN512fUa2ZAqQBto48yWrwWBSZ4MOBU+aPRaQKMd4yfEkejahnfT5BCQKRRWLt7gUyhJAda6oAKYWL9ZaHxDLGBeuiIVNvviEqKfpzdubMy/4hARZsVmiiA9nBDv9qqE5pClA2CfUZ18KZG8xM/jzJux6799KgSc1/OM9CqUOVaAlPJLwlmGJep3VQygbk8LFlDPmWxhx63c6DXT1FlR/d7HsJDu2d+PaLnx7XQEx55h+Hp7wdaBKAEXn89fRbEZu0T9OSYvK5+2vue6PYgXg1noyYKPMGmpwJxdAt+jtMn11JJYGU7Bb/CzUb9z
 8AfeBR4m
 4M0F2q1p8bS9loeDkgfm82NGlsjV7d6SdLi6jGRRWN/ZOruBzcruuBTtKJS1HfGAoVr6fyVbjdueT5K33QLBzCvmZ7MFb3Gywrv53ROYfJ7o51EpACvopCbvat1kNPG3DvcnMQPn8sDfrsuDmwcqOfzWwkHUeD2cagHDVO3lNeNNymTbeb3cbQ7iYj/JVu264Tsd/aE5qwMlUfC7L5VLgpxPzUNYeDL6fiaMXf44vSY25VjQ2bN9Oug8a9yFbeEPGs2yRZ3VdrxAwILYd76r9tluVQ6M6ZNWvIyVndHERhgWdFztlXYvv8dmYXhefVYcG90KOIEUNVIMeNdN0v695VhiXQxrgIgToqD4OMoSebb1rda0fpWkziZJT5Y8cGD7KOuyshpG6IDqlFyZtbPGzzTdy2wNcL0+niW2nRZKceY9qNEddhTt2EJtXgy0PMpsa0+EWQkH69+2hPw5NtZlkRzWQ4J2P7G2hvFFSjvA46kLsuCNQ3a95ow66+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 7, 2026 at 8:04=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> No one is using it now, just remove it.
>
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Can we squash this into patch 10/14, where the user of
file_taken is removed?
The same applies to patch 13 as well :-)

> ---
>  mm/vmscan.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 73b1aeb6c292..79e8a8e6555c 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -173,7 +173,6 @@ struct scan_control {
>                 unsigned int congested;
>                 unsigned int writeback;
>                 unsigned int immediate;
> -               unsigned int file_taken;
>                 unsigned int taken;
>         } nr;
>
> @@ -2040,8 +2039,6 @@ static unsigned long shrink_inactive_list(unsigned =
long nr_to_scan,
>         sc->nr.writeback +=3D stat.nr_writeback;
>         sc->nr.immediate +=3D stat.nr_immediate;
>         sc->nr.taken +=3D nr_taken;
> -       if (file)
> -               sc->nr.file_taken +=3D nr_taken;
>
>         trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
>                         nr_scanned, nr_reclaimed, &stat, sc->priority, fi=
le);
>
> --
> 2.53.0
>
>

