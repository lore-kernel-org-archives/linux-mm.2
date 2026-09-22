Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CE3FC982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 15:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E8E06B009F; Tue, 22 Sep 2026 11:43:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 399C96B00B0; Tue, 22 Sep 2026 11:43:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2881E6B00B1; Tue, 22 Sep 2026 11:43:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0950D6B009F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:43:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 967E31404FE
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:43:40 +0000 (UTC)
X-FDA: 85241818200.19.54E61D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id A583D180003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:43:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cTmg7Cc0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790091818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qdq6bVtlrkkiQi4IDEjon7IDDJY8jFCGab3SsYEo73k=;
	b=AtedO2ikKlo1ypQdph1JWUxx146KaOkt0GhBLgavsVXDE3s9gPT+wodRrcaDfA2uWS0H7X
	DDQrrfVvYCMv0pEe+nA4uNewS3nxYZ56+/S+MSp3ox1QiaEIuJGpqE2yl6XGK2zYmsNgCX
	yymfjKaoiTDdrUJ86tThFHoa8lD17q4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cTmg7Cc0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790091818;
	b=n6FJKzxfmCTNO9Qx28dZrv7ARLDJsFSmVdYzrla20cb/Znkj/O5KPQQsSxePd68ek+Ep0d
	YkpQ7r0z35cjgFVqj9ZlGUoVSScIRUtaDP3p2opiTr4wKhCJMhlL+ve1247zNwgNHVbSZE
	H9W6ROX1DeHCTHm0zUNFtjOQXIXy+7A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 98B4444A06
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746951F00921
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790091817;
	bh=qdq6bVtlrkkiQi4IDEjon7IDDJY8jFCGab3SsYEo73k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cTmg7Cc0+6HxSo1jMfkeoa+5FPL4PXaP/ncU52vkdZZbFAZmD7oWRRwEmCZzshPq0
	 Uc+BiLrTNPohDmaQcZuCSagXyfrhBbnrjOmMzn3GNSO33NiGG2lkv4fforhEKEY1mX
	 HUSs++fVKrqmFwDhUCLqx0h3KNzpGVWlh7Mxk8w79ljkQtwMY99Ukk0LSfRK6ZVixq
	 tiGw0tiw59YRq2IoQmfNGovI1M9UHITJp5B52ZLQ/IuwxLyFwCZtIZJMihLrTB6G0C
	 Vshr3muH/z8gjrH5nILPSMeATYdoQTMTsimyv+a4UMBUCUOMCj4zZWinrFYFhWQWJU
	 Vnr6PtfDcChEA==
Received: by mail-yx2-f42.google.com with SMTP id 956f58d0204a3-672c2880f58so1264609d50.3
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:43:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwjxH+G1ugSfDhNeJiOnKUHQFv2v+eovl4G9+k4zYOuMv9pqN9FTTBoqOh305m0DHA1XQppDk00vw==@kvack.org
X-Gm-Message-State: AFuF++nq/fRFw05trxOIQR/31Qx/hIAMyARHd8yUCXHKqUNchRRfzZxa
	78QoEVfQoAWw47aM0C9wz8wObHMOt0c/8zYP5IayBV6evlCmcTLYo37KYbSFD0GIzxjexGgTxz5
	Mie9NjkSdg71B8/qrx5FJyuLalqNLxTSuzEbEGCtrsA==
X-Received: by 2002:a05:690e:1301:b0:672:9b54:d7c1 with SMTP id
 956f58d0204a3-6729b54d93dmr3865124d50.96.1790091816612; Tue, 22 Sep 2026
 08:43:36 -0700 (PDT)
MIME-Version: 1.0
References: <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F> <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
 <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
 <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com> <arKbXe1Qe-FDCTMM@gourry-fedora-PF4VCD3F>
In-Reply-To: <arKbXe1Qe-FDCTMM@gourry-fedora-PF4VCD3F>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 22 Sep 2026 05:43:24 -1000
X-Gmail-Original-Message-ID: <CACePvbWW4avTV2WB6iRU+LN5zqkMTg3UhBrq41R0iw91-7Ni0g@mail.gmail.com>
X-Gm-Features: AcwNN1WZ0XbjHIE5x89rohnZw7rb7RJygKYMLdbeXm0v4OERizBpCrDBDyGcRdY
Message-ID: <CACePvbWW4avTV2WB6iRU+LN5zqkMTg3UhBrq41R0iw91-7Ni0g@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Gregory Price <gourry@gourry.net>
Cc: Rik van Riel <riel@surriel.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5x5g3qmhyya8xhbxj6se83cpht1w9hkm
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A583D180003
X-HE-Tag: 1790091818-599858
X-HE-Meta: U2FsdGVkX1+2978aTPcY8GM00m7Saj4qJevHlt4Ygv5TGhhk1EzH9SzqjT5aVTuTazVlyGqM+VAh+xRkTJYu8UBG6zljRgZPfs1hcjh9X5mCG/Pw88M8Kg/+4tJUe1qme9Hk5l5Cs48Whk74YKeenqfNyg4LWNiLqZIUR1eoy4QN3CZHJf7+TgMT/+ZCm+qJvHtvq6QXSjdMnx5pIBAyyJZg7SONiOh9yMLlj6OcwaUgEUZzHu47IiMdpyhTKdAxR/oqBHbtrMgSNn9ciFqhUQSNLDJon7+y+ErBpa/0GsOo3hr6J1swowsetRPNsOucfqZhS9JCGzq8rW9xIhI/m9D3YZHAGjSj/0ynP3JTpvatQZfPnx9zYrTlU8hbXMMUbM9Izg/Yy0TXha8L5PMXri/KFvKDsKzPLM/tRWLDl9zOQ71e97Bo5NvcaquxuKnxqRyCmP9nr9r7DHlbQ//CKM8cGsPWJSbA1JDHHkhySRRdNlr7NckDOSeGogAYddekmcXgTS4AA+TPrQF8q3glZJd0nnCmy7vJ2QpvE7v5XClgaP0nqPiXxjUftUdOYQei8q3Kyh1JJJL/amJBM0Q+/iLrx5WccgTVNKg0P3ccyd+CTTePpTcumxXYfJq45PGbS76CL9ZX3AvQlqoAAlFxOQn9whzV83grA3nNiAyDzK5XlKJdE3zTpn7Ix4yYNQrLo7t2Rfo3mqW7lSlYiFSpEfWVzdm4rp5gaw5STBFkmqn3jLbP/IQTZLG0efrT4w4tsvv16vBE0nBZWVCiBWlM0KcpAWfw9QWVPoOJ2JB5WQIFZgRYdnqcHv8uJ03vKaQUqnMqPqe43MO7Lxov6AeYRdmpUAdns2g6sJKWAhKE0C8mgZwOltUlgnrR2zZ2pBNGeSVal+LbzNy+6Lv+eppSVKbtgl3ekaHuDmm4VtrJuM/5dFyc/bSp1SrcwH412cGVvKsFQZYDDfn+coIXgTJ
 BIac1b74
 pleDB98XusOv0Nb10v2Umg8hcGnynZRYWprEa42qc7x1ihyf+q6zDj7+mffwf+aj0O52C2CuE6rvlUpOuuuvAISDZcfzcRNJ3gQXlVmo2+RLlGYeTfBxeKZqixWfZm3bAiXbGn9gAJZiLV2pNcCWA87dTTWCr6BgsPTu0OeEUzBArosprcwbs46IKU7DXyLfGbCqLgFAR/fI79AwnubREcidK8kroKr5rexPylJgv7U7usqQIvVAFETmjcfe61smaHTbJLPYyepdT48D9uk1RdRgjLFV74Pg+PKeR25OOoVbVihY7hkQBrNn9tYvJ/taG2jWwZ4C6oxxkT2d9b89JZsaaU7KlqbTmERaYvSuq4TpqaoDWJltfufXBA9L0+F/mHQ1EFwe/gsWAgWm1i6GydmMCTkSfxDQBWXTfh11BTgGZh7eYqexOX6yrv1yspMIuhX17GvlzK2HRolwAUNx85IgABg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 5:20=E2=80=AFAM Gregory Price <gourry@gourry.net> w=
rote:
>
> On Tue, Sep 22, 2026 at 03:32:44AM -1000, Chris Li wrote:
> > > Right now it has 64GB of memory.
> >
> > That is exactly my point. You are running 1/8 =3D 12.5% system ram.
> >
>
> Chris you are missing the point
>
> Zswap:           8812236 kB
> Zswapped:       24927876 kB

I am well aware of the point. The 7%-10% data I provided is before
compression. After compression, the real saving is about 1.5% - 2%.

>
> To support this, you'd need to know you were going to get a 3:1
> compression ratio and allocate 24GB of storage (24GB of swap slots).
>
> An hour from now he might run a workload that's 4:1 compressible and
> there would be 32GB zswapped - but if he'd only allocated 24GB of swap
> he'd be limited to 24GB arbitrarily.
>
> On a 1.5 TB server, that number is oppressive.  It's 192GB of
> potentially dead storage space.  At 1 million servers that up to 183
> Petabytes of pointless provisioned flash if you know that most of the
> memory is zswappable.
>
> You're focused on the wrong problem.

You are not listening. The boundary was set due to feedback from the
application SLO. Those are real deployments not imaginary usage.
Please respect the user.

Chris

