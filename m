Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C061610F9943
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 14:50:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8A226B0005; Wed,  8 Apr 2026 10:50:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3AF46B0089; Wed,  8 Apr 2026 10:50:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A29E86B008A; Wed,  8 Apr 2026 10:50:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F01C6B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:50:51 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0717C1601A9
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:50:51 +0000 (UTC)
X-FDA: 84635675502.10.1E90497
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf09.hostedemail.com (Postfix) with ESMTP id E340C140007
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:50:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tBolfhvS;
	spf=pass (imf09.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775659849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W3zLPSnA2jybGrUshfBzEtPtsKkQvdwmaZieVb78/es=;
	b=qlu2SvUffBX3EJJxXOqt14zqwb3MMjjUx6ojRFe/P6i1WJPr7S8Lzm51E0dCuKTjQjqizs
	8Dx/z+jE2y/fogdadpHMMo4kZBuaZVQAJR1rgcWf38wNJ/M3Ljud20VcxSouZk23VYGRlD
	5ahoGhkseFmeMLX+MQBI9R96NREQD24=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tBolfhvS;
	spf=pass (imf09.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775659849; a=rsa-sha256;
	cv=pass;
	b=4E2HkCmWFrvl46n9xe4UUZBwzw5ZLgjrz+xjR+Md5ifi0K+5tgIy0ptQynhDKfrQOnyhrY
	SC4Km+Ysz/+TEvWM90PKtZ38MRGdfj0wBqZW7FXYpRkBjt5j5LgnKwJsXOqOa/fBF0DgZY
	H8dfhiUgajCtCB9h52OgcwLr/rDXRB4=
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5a2c3dfb4a1so7315839e87.2
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 07:50:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775659847; cv=none;
        d=google.com; s=arc-20240605;
        b=kMVejmGdKO1fH+YheX84Swnu2QqY8zaGD/2Swx/mFHLogxhMPyu2uphJPck7xG6Q2l
         bBbGcvlIK5ec20OlD6phIEPQ0Btz3IagRfEiRDKsdTjJ5Ic8/DoxtXbTVTNLJtcVJETN
         yq8JQFinDNpI16rwBZ/dj+GlIiEdQtmE0m1ya0WCcd/m6mB7BAQITAMhVkdD1CWFyYHO
         oFGJwWT65KF7uY2bv9ksXjy+sMRfRV6UJ4StFTavumdixwJ7fh2z04G2K0VcLrTIR6ww
         s4eMPNOG21K/788Um6yOclC//KnDIQcHLAtUS8WEsRc82SimyfSVF3ogPkKcdkmYPE13
         BH7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=W3zLPSnA2jybGrUshfBzEtPtsKkQvdwmaZieVb78/es=;
        fh=Xwn/JcNc5z161iJ9mAEQFK5bcFfjeLG8NfseGFv9pyQ=;
        b=btYfKpeVemJ6kmZh0M0BvLMXpohRvHh+IEjLQcUGbPJskM+44QYCGiy2LVKHWWN8Ig
         A3LkS6ndXb+EqOWuHmAMqzFtXlqWDLyyVWhTy671ixuQ8uI/fQt4vPQ60QCCs752n1Rz
         G/DFKWI4dgvzVtEkr77ke+rf0qyCm6PFZAfFyX9LKEvf3TZRCjLN2UrtZPdek17J70nD
         f613Nu0ATwKkhecGcICG9wKrqACJLkjOv/gQWUeTs1NeIBh1ElKAqYEs9qn+cWT35O97
         eYHPO1zH2AwVs16/bRbxrEcIFP+Il0f595SHJc7lMpYLagWNfYsbPglJ3Z42NbV2YwOU
         CPhw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775659847; x=1776264647; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W3zLPSnA2jybGrUshfBzEtPtsKkQvdwmaZieVb78/es=;
        b=tBolfhvSrrQf03lKtv+KqqZLAMtdiLm7W7EStmYta7Stan4UWY1px694lJEJB7Xxiz
         Dwllw6cS0StMtdZyRqvYNXf14S9glavlLcN4tzva7a2UVmUtAcbQ7zglxDfQqRZMuduZ
         rFcISA2iiQ8Irb7voaiT8wj3nyH//ddXySEFtvim8r6b3b3OIpaUm8aOiTCzPXaKJEOA
         wEAf6lGxyaPDH8gOWjNQejeViCFTlErlAPYhxSPckh6YyWcOLNteblJ9IncpYgH6W3g2
         +d0oatk3oHQk7iY3rhAt465BTQvlbrTvS3BbM6qchQ492yxwtHK5fNSQEJwKy4UfZRce
         G20A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775659847; x=1776264647;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W3zLPSnA2jybGrUshfBzEtPtsKkQvdwmaZieVb78/es=;
        b=RlzsDkay/YYqaYGANZ9dHGwCTkUHAKGEWF7um5klNXdtxBMmPISMhA4X8YkW+Y6+31
         Ty134L++oTMP+JiLPhlf1EIPOmAy8AMfQTgREgDl1ul6ia4eIg+TKuLW1raAgAHJXDtb
         2GNL42s2rUVBGoEPQnB5XCe2/do6zeaSfG4/668wl0J1U4zH4q4TDftiJUZVMkmcpFZ/
         QdEE8J6gj45MSslpgMhQ6V+/v/OXxJmpL3K5NABr+GIhSjuNAOMhNhW3M6vw6owoxX0y
         UPZ0OcL8NHdFyWpHFk4EYLdcGuPO9f5IbG5nw2Ua15MfSRlh1OhB+3InSOxomnS7H7uu
         +A5w==
X-Forwarded-Encrypted: i=1; AJvYcCWqKHW2SLRNBArbjuYUNghNRTmoPly+DvxI9b4oghuhseDYzy36apRJjep0HzPPWZuB0AWb6OQqpw==@kvack.org
X-Gm-Message-State: AOJu0YzOPF86CmG8CbCclSX4YfKYtueWtKufr2laQBFeEauI74ICEvFE
	SUNNvhACcTS4BgbzpAu4R57UE7Rjotev61qUpISsR4qSQ7WPMMXD/zSKvlGDH+IH8CHh1xQ7V/L
	tipXeHuUZmxTl6ay2xQeiFXMb0EUqMbY=
X-Gm-Gg: AeBDiesyU9hXvHadlYFe++bvL0MeI0Fet+rdroj+j7GR9Njc5nEP1T7gQvTd4bp+2Xb
	J7ZxaI35p5haPCqDbqJp3LOM/dW6z6qOtg/0OHBcVmDNtDqGcF4hSlwI07IBpJzY2Jdq0LiArhs
	bY6Wk8SJCdqMVR4KcX6HILx3OTSyNnGvp46MUBFKzo/ALkxkRQcJ/sqBqPCbG37SYh0whn30cVz
	k2dOFM7HFVIcABqZEXy+qAVJi42lMTOOqoI6yc4kNKptrbMx7rRUjD8Mta4R0EjOkwSRJiduisQ
	01+hMnM=
X-Received: by 2002:a05:6512:3093:b0:5a3:cd17:8d91 with SMTP id
 2adb3069b0e04-5a3cd178e57mr8886199e87.45.1775659846617; Wed, 08 Apr 2026
 07:50:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260407110002.204755-1-wujianyue000@gmail.com>
 <adUTC-7iyOAUlhR7@cmpxchg.org> <adWxonmfjvcwXMg8@MiWiFi-R3L-srv>
 <CAGsJ_4yNZiRpgyTbooJEkkefVxgWOywkcVd2BeY5Dq2wuicNNA@mail.gmail.com> <adXCKGN_9jFgLqI6@MiWiFi-R3L-srv>
In-Reply-To: <adXCKGN_9jFgLqI6@MiWiFi-R3L-srv>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Wed, 8 Apr 2026 22:50:34 +0800
X-Gm-Features: AQROBzDdHVFO-LoWCx8R_4n1axnc8vzBtrWSoX6GivkgZt_m9m_jRCKfrJN9dAg
Message-ID: <CAJxJ_jhq6yWu9HQsptwZ=Nx9PSXyo_MORyz1BhPCfh-TzNA28w@mail.gmail.com>
Subject: Re: [PATCH] mm: move folio LRU helpers out of swap
To: Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	david@kernel.org, mhocko@suse.com, zhengqi.arch@bytedance.com, 
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: E340C140007
X-Stat-Signature: 6i3gojxr7yzxoixi6x8s7e6w5ooka9wh
X-Rspamd-Server: rspam06
X-HE-Tag: 1775659848-60853
X-HE-Meta: U2FsdGVkX198c5BTlCHgn5qWhVnXwWWR/VyWHHcKx5aAbdarivmvVWNLZkOrqTxorz4ZnWgBkSUWRykHimzQLpVTJSlO3SKNRe+DCeh8LTUvW5YMjXCJtMDxRdsbSIlp/4Mfaw52/xUuEQg6BvxDhCRJC2olswTpfVkCzOYlRcgaIk8e53j2+YCDQEcn73EuSqXvyq2oX32f/howck2JrBwYlg8TXT4zOYIJP41GKhrfHuHYCpnEjkSuqbvvdH9m4Nh56BGMOb5JqxkXffNMJLeCaMbR8bOr7lgF4M2Bl3iSC9l7XMAlDfSLg7smCqEQzHJHwhTfRPWlgZsES99ynCr+cBLoEUD2TLlxoXxsb+ZZOTp90GtF4Pfyz5ZRY8x3kp+/ebxU09eIIWdq7Nm2uRi24hq7I1OXa2F3yhX18yriT3yAAzc2VzmumPUYAXSA83O2sLCBuhEG16lfSD08ZntENRvdNu1IqKF8SfisHwhYAjSn0qdt8gHZfU0X3r70xPCpeG+jM1PXvv+ZjP8qyARtuTmc56yIvgAVuAykvyVEqmHYw3nwQRX73pNnVXkueJGkRtgnXj/kb+vf9qeNrOi/suARSg4/6nxPdCysS8/m4QZkFQ75FAu786rnNm5d2E7rmM/Q2ytJe3I7l3GGWNPs9hqkah21k/WqEkLYVw3HQCNlVCYF+nFJt2btwOHlw+G43QNt5wqTv+JcXzkpCvDcQPSuUxHdD4QAJxvTQjRdMocfXWvc3MOBW7fgXATbaUd1YCF6uh1ribei6GzRSZjhtwAddvRqlpLoxHPkPH1j/JtSHbDLN5QyyKm4Ujls41i4DVGPOSoEuOrCzFEw+2U/7HS70oqd7n+k+nlc4XumKtoqzh96EqTl9jQeG0pvjvrlma2140tER0miOhFoCPj8jD8FQA5GDGpjIVuiongtUnhq+j2nWj0NmbTVs2i9An6wRydxbUXtkaqUOb0
 yyhQfTPJ
 7Tq41f//3XhrUEC3UVXzCxKypBfuJovk4Iqjcy2dxzIyxQtVaBMcUoAstBcUkHVvqFt3W+d2p8sM5iCg0fTdU30O5Uo2jG6Oo0LzU8u+gSCHGUIsN4bwnSwF+f/G2J/rGM4aukAFn06OPe72GPCg0M1tw0wrXSQ58fPzEnqv7Jsdftw0ed4CajNzgTW2MN7+d31QeUj3HVBr+8kLeQXNePCGCZB0OcGUS8zeG8lnoy5wPHE6hQGoXSngvn5FA+dGh6wfNLqtBCaNt7svXoKYGim1Uu+9g49Iwt6MdvidLFcbzW7msNONIp01lBjPDcD0gevX7gB5VzverbSO2ijo18i5Rwy8guHPx3PA3tCFNtkjHGVDH+VaG0vZ7R6iBtube4ZWyfT1u2WIy33euXZES4rIAK8b1qzUC7tDIHbJhvDO8yxNqs7Ij9W63NzjIOK7uzLvE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 08, 2026 at 10:49:12AM +0800, Baoquan He wrote:
> On 04/08/26 at 10:20am, Barry Song wrote:
> > On Wed, Apr 8, 2026 at 9:39=E2=80=AFAM Baoquan He <bhe@redhat.com> wrot=
e:
> > >
> > > On 04/07/26 at 10:22am, Johannes Weiner wrote:
> > > > On Tue, Apr 07, 2026 at 07:00:02PM +0800, Jianyue Wu wrote:
> > > > > All allocated folios are added into lru lists for later reclaim w=
hether
> > > > > they are file or anonymous folios. However those folio lru operat=
ion codes
> > > > > are put in mm/swap.c which is not so appropriate. Because swap co=
de is
> > > > > only for anonymous folios.
> > > >
> > > > Ironically, the only thing that doesn't fit in this file is the swa=
p
> > > > stuff. The page_cluster & sysctl should be static in swap_state.c.
> > > >
> > > > The rest seems thematically relatively clean - infrastructure for
> > > > managing folio lifetime. swap.c is not the best name for it, but sh=
ort
> > > > of finding a very clear improvement I'd just leave it alone.
> > >
> > > Can't agree more. We should move page_cluster & sysctl and swap_setup=
()
> > > to mm/swap_state.c, and rename mm/swap.c to mm/folio_lru.c or somethi=
ng
> > > like that.
> >
> > Another issue is that many MM-internal items are placed in the
> > top-level include/linux/swap.h, which is supposed to be used by
> > code outside the MM subsystem as well.
> >
> > For example, the following are actually MM-internal:
> >
> > extern int vm_swappiness;
> > swap_setup();
> > workingset_*();
> > try_to_free_pages();
> > zone_reclaimable_pages();
> > lruvec_lru_size();
> > try_to_free_mem_cgroup_pages();
> > ...
>
> Ah, indeed. Seems we have been putting generic code related to reclaim in=
to
> swap.h|.c due to historic reason. From discussion, I think the below
> three things are doable.
>
> 1) move page_cluster & sysctl and swap_setup() into mm/swap_state.c
> because page_cluster is only used in mm/swap_state.c as Johannes
> suggestd. And swap_setup() may need be renamed too?
>
> 2) rename mm/swap.c to mm/folio_lru.c or something like that to reflect
> its real content;
>
> 3) Just Barry pointed out, move generic code related to reclaim out of
> include/linux/swap.h  e.g move into mm/internal.h if they are only
> called inside mm/ folder,
>
> Thanks
> Baoquan
>

Thank you all for the hint and the summary.

This direction looks reasonable to me. I'll start with moving page_cluster
and the related sysctl into mm/swap_state.c, and see how swap_setup()
should be adjusted accordingly.

For the other parts, especially the header cleanup, I'll take a closer look
and follow up with patches.

Best regards,
Jianyue Wu

