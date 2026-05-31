Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31005CD6E57
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 22:07:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A6626B018C; Sun, 31 May 2026 18:07:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5574D6B018D; Sun, 31 May 2026 18:07:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 446226B018E; Sun, 31 May 2026 18:07:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2DEB06B018C
	for <linux-mm@kvack.org>; Sun, 31 May 2026 18:07:03 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B054CC2116
	for <linux-mm@kvack.org>; Sun, 31 May 2026 22:07:02 +0000 (UTC)
X-FDA: 84829101084.27.518F774
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id C3EAC20004
	for <linux-mm@kvack.org>; Sun, 31 May 2026 22:07:00 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i8eVXc85;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780265220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bWpbo+onXY2RgAbHff+MdZFIr7ggk0Ugp4qR+DwwCn4=;
	b=BckXdhup+lm1W/O4DwOZjOgLeqlGpLv9U7j697LBcViz1TXzVEUnMC2ULm7OXuykyzSjtM
	JbPtZbPRKYoTmDa+YYSnxcMbCos0OSMqV8gqvfa5oP6NxPVoArPOtNkpwW+pG7JG4S+qaY
	Bxz/1OzfRbd5rDEvwUO7LSQvkvlL8sY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i8eVXc85;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780265220; a=rsa-sha256;
	cv=none;
	b=pssB55r+gGgmAXj6FSbwUpmtTOY9RN8tJK+SU+j0GD5xE5enCsho0spDTDm3O4eke+vmsS
	DbJbgE/LMkyo2lpWPQJJu65R3Xv6si42etzyXJOKKd9QN1ea4yQyqq202YKQjfLOlm1Gqv
	Ci7FzfA/T/FZ4fexjVaAFNqFE9nZxEc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BA22A443B9
	for <linux-mm@kvack.org>; Sun, 31 May 2026 22:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C901F0089A
	for <linux-mm@kvack.org>; Sun, 31 May 2026 22:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780265219;
	bh=bWpbo+onXY2RgAbHff+MdZFIr7ggk0Ugp4qR+DwwCn4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=i8eVXc85ceWfNmuk4SDTvQXBiNlT+tnPJDME3bVQkeMcKD4f6u9QbAVQqf81uI4wV
	 itcDVRFMkTIxOzFvlwLvAqwU/0BIVlaVe3yxVCPY2o2XgIMx/mUacMpMeMhNHSB0jv
	 qpB/Zy5ozD/ADizmHvaZYO3o3DG8SmEjFF30DxFJ6XaNDZj7Muj3Xei3waHSXgKKkP
	 v2i8vev8Xd8tyBW47lw35kpbv4v4f+Juwx6X0X1ZRFoKjB0wQ0EJFK07UFb76reMAT
	 +Eud+j+iuwh5g5DyQKpJB3j4y5OX1/UtrvFDy7HdcUsEfxj4i9zP94ZD9T8Q4iXJUj
	 MhWXGUU3VIQoA==
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-91550eceb4cso76971585a.1
        for <linux-mm@kvack.org>; Sun, 31 May 2026 15:06:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+BprQl5kBQMzT9vd+oE0A21gr9DPKlDC8jyUV+sueayJpvdZcp0VCLJ9lw4KaO0Rw5wUDY7jY5SQ==@kvack.org
X-Gm-Message-State: AOJu0YzA4c/xmZMIw7a43x8Pv/8fGOaWhN8H1bRFiJp7lQkdq+V/O5g/
	UpQGgXWJePBvo5PpsgSG9wEhjfIVxRooHNISNDe984pNFzQXU5y++tBG8kr4gDk4J+T2RuD+920
	XvOPb/X7HVaGcia7BaQ0eN2u0TTKxiLE=
X-Received: by 2002:a05:620a:6088:b0:914:babf:9f3e with SMTP id
 af79cd13be357-9153d987c78mr1328136185a.25.1780265219063; Sun, 31 May 2026
 15:06:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260531-ch-swap-series-plus-folio-lru-cleanup-v2-0-1b9a4ac255b4@gmail.com>
 <20260531-ch-swap-series-plus-folio-lru-cleanup-v2-1-1b9a4ac255b4@gmail.com>
In-Reply-To: <20260531-ch-swap-series-plus-folio-lru-cleanup-v2-1-1b9a4ac255b4@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 1 Jun 2026 06:06:48 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y8UWWwCSZ86rQnW9wgPMRg2Eo2e+6jw3kWPVZf7zgx7w@mail.gmail.com>
X-Gm-Features: AVHnY4IcwrH9q5MqvQZpnGTumTTfEh7-vuq772K7moKOUadkNNIf4GwtrTpBG-8
Message-ID: <CAGsJ_4y8UWWwCSZ86rQnW9wgPMRg2Eo2e+6jw3kWPVZf7zgx7w@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] mm/swap: colocate page-cluster sysctl with swap readahead
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: f1ncmw5mbrs6cniff6zyykawdnabg4y3
X-Rspamd-Queue-Id: C3EAC20004
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780265220-13568
X-HE-Meta: U2FsdGVkX1+wWvdy6wBF/UI74mVJOEjXibhhP3HysYmZsFp2f+oecQT1YxCw1CZy80OwWTYMg/nL6HyhmbSzH/xBGSeneLM1UvXdxyU2OdCPcY1pOpvomfIZIPArqjSBzzprQtlbT8tm9xNfyz/r6sIjyzyi0yXaYxInJA4aixGhnniVhWK/jB1gW2Srgwp/s1fUFnk8XUgXU3aTjeca0tcbgyWpKrKcUL0NHHtPoI3/GIzhOWDTtahri425wL+RNZbJVrZ6zxBd9269GdvsOxNC39hmjWjPZNY0/97hJjKKA9k6bvl3KFRCVPwl49afeKz2lGN3cBExRgXJ9es01AIfKWfUk8QgnZnTLOyd/I1LZuAyU4zq1E9/iTHFI1Dr0WKc3w8FKC/TBhd96XElAtztRz4M1lDeYuU1g8pUHSemyexeXk69SQclJnxc/YIJc0pi2HqgRRcXuehYiEEbEY+FpJcPu8+bnXSGAfl+PR7c0wLrOpGIQRBt2/fY6eUZWhZ7Tzfr9euFmgZWf0CbKuN4EUvPTsCKM/6DeLcNRmu3PYgCjQ8BAIMKyzyeUI40OPFmIrw3Tw3KRBhZs1D4ZfELDC1vKXMiysYYGeBkYWpCg9iix3pS4TZJz3fT+mSZ0qsQftfr+IHVVfMeG9EKKdqJGEjv46/CURsBDN5RiafNATQvM5y4xEebX3PFVd/HkPGYULz3mCLidpg4mLzyy7AQz71fJZ/8OlF9LPAxPt0tiXuAUWd9DUIgqPnYj3C6tDZ0SojP2yTSTgO6VOuPGwt4HPy41wK0cakDzPcpQ0zUVhF/i6bhLtM3I4rc9BKprPjaz2ylx0cOzhl0Y6dxcMlaEGrhOBs8U8RfjNgEnRIrL28+1KrDAvmSOIAEq3iHejWOiMYLCBnGZleTAAFFoAA7q27GwquSB8kv+R2k5REQNPk41aDWTK1Ce13pC/Y2Cuo+YOB3QHwIx+jpNQF
 FyPN5sA2
 0OxDWPNALlWoHskB+brg00/Haw2+w4vRitVraUVtnE63qdEfQg7Dol8A0+3S3TZLd8icskoMLS4sXcVRx9btZYRZQ0sT+QBTlUk3peTeQ8m0HLsyy5irnAohv1sj8x9Ru8+gXCiSwWVd0nCxRsGFEIbsM9Vgkj4X5Ba1ts7d+J4qg2kcv4iU+Sd3gtD502etQFe2ydrnhZB1JHcwSst0Wqam6svKxoPLL6LPnoaFy/dELh7W+C6qgAl5CBbhCCfjoxf86icEBnEenQgGrAV+oNLRY2dDZJQ6GQe3mJqAoPeN62tgGy2ttdkYjb13muGfKqdzvdHuYpjSdisI2vpjJAkv2Zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 31, 2026 at 5:50=E2=80=AFPM Jianyue Wu <wujianyue000@gmail.com>=
 wrote:
>
> page_cluster and the vm.page-cluster sysctl are only used by swap-in
> readahead in swap_state.c. Move them out of swap.c together with
> swap_readahead_setup(), and make page_cluster static to that file.
>
> Rename swap_setup() while moving it as well. The helper is internal to
> MM and now only sets up swap readahead defaults and its sysctl hook, so
> the more specific name matches its reduced scope.
>
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
> ---
>  include/linux/swap.h |  2 +-
>  mm/swap.c            | 36 ------------------------------------
>  mm/swap.h            |  2 --
>  mm/swap_state.c      | 37 +++++++++++++++++++++++++++++++++++++
>  mm/vmscan.c          |  2 +-
>  5 files changed, 39 insertions(+), 40 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 636d94108166..c36f72877e8b 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -345,7 +345,7 @@ extern void lru_add_drain_cpu_zone(struct zone *zone)=
;
>  extern void lru_add_drain_all(void);
>  void folio_deactivate(struct folio *folio);
>  void folio_mark_lazyfree(struct folio *folio);
> -extern void swap_setup(void);
> +extern void swap_readahead_setup(void);

Can we move this to mm/swap.h?

