Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ECB6CDB466
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 01:40:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0FF76B0088; Sun, 21 Jun 2026 21:40:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E72B16B008A; Sun, 21 Jun 2026 21:40:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D149A6B008C; Sun, 21 Jun 2026 21:40:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A13C76B0088
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 21:40:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A18591C551C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 01:40:00 +0000 (UTC)
X-FDA: 84905842560.01.691889B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id ABBB4160007
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 01:39:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OlsUkLk+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782092398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rx0mLq1GyG1gPfhWohtRuJsYSfIXcRSpekf/XOMayPE=;
	b=AzClLwhwo20fKKAAdS9KvvdpyEJixWoRhB7D8imCBjlTzA3mRV92JjexUeahskd3svAUw9
	zPa1xpe16gsp/0uRFhAzstQdOwkewI5BCAvrbJCOy0Ub1DvDyp5e4waXQkRqjmyykbuA6l
	9K49uJTXiRWJ3a71ytJOTTHjkx+2/mE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OlsUkLk+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782092398;
	b=10VIETn7qiVgsV5RxLeoM3emi9h1FHiPCuaf2EXlmfscvHawIRtUcd0pWgSscG/QXZBDEF
	eDLAyB0q21J2K5pOztpbDEW+9psXRjuGKe/xQX/XMCo/YdfCpvqueoTUcosivorMF8/zsW
	6Mkefvr0DTjgg6GAUCZ11ypIEBNIKTU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C0453444F1
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 01:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8E61F01558
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 01:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782092397;
	bh=rx0mLq1GyG1gPfhWohtRuJsYSfIXcRSpekf/XOMayPE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OlsUkLk+fc+Hyi466MxqhAa76hkwJ4T//hd3BpWmTUg6W5S0jHxOeGmV0bgnRjxnr
	 3hvhy8UdUVXlb7vmQqRNukPibA0KXst8GHmyw6U7CBmHzTKGbrJqhkJppbDPWy0mis
	 4PamqWbf350aTkTN1Ja1g7E/wAUT9DMGIZ7z90cS2jHHI8I245cYsgfDj9f74JtGpI
	 qrGV7fwgAFGkOUOXiVA8zZmt/p+yG2GeFBWUWvvIB0QrjO4cAJvtf1k0Q2hgTb7LDL
	 HleXs2k4vJxl2eh6XD7Irnd66poVyDB4GRK3dRwFzSGDSlbrUXb4xOXSF9p4muDTbx
	 1aqFRQBuhboKA==
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-9157b94a07aso402075585a.0
        for <linux-mm@kvack.org>; Sun, 21 Jun 2026 18:39:57 -0700 (PDT)
X-Gm-Message-State: AOJu0YwuNZKZoblPa9QXTmOBz8FWolDOVFpvXZar8wC6x16zp3Hp/eoY
	rffd7dw4If6HIInLdlYsU1S9tsivBFGH46yYTMM0OLZzdhEXlEX4941Y+fMmx92w3ZwJ59HVJPT
	2XzRD5VpK7s3fK49CnxrHa9g8Tg1GkP8=
X-Received: by 2002:a05:620a:29c6:b0:914:7e9a:2716 with SMTP id
 af79cd13be357-920d46198e3mr1850079885a.38.1782092396983; Sun, 21 Jun 2026
 18:39:56 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1781843449.git.ritesh.list@gmail.com> <e519e98f51be2d310367e39df0935da79001e535.1781843449.git.ritesh.list@gmail.com>
In-Reply-To: <e519e98f51be2d310367e39df0935da79001e535.1781843449.git.ritesh.list@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 22 Jun 2026 09:39:44 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y++uh_4Dqso-fafywFCAvTLd-JSRJ8RZ6HvNLDkaLUJA@mail.gmail.com>
X-Gm-Features: AVVi8CfWnOC73cLiX1qD7RC8Yb8ND5XGWQFATC1PtKwV9KhKnymRT10brK4O9Ng
Message-ID: <CAGsJ_4y++uh_4Dqso-fafywFCAvTLd-JSRJ8RZ6HvNLDkaLUJA@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] mm, swap: make SWAPFILE_CLUSTER runtime
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: linux-mm@kvack.org, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <chleroy@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	David Hildenbrand <david@kernel.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, Sayali Patil <sayalip@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5i3cx9icqj8c7kcp34zw9dunc3dmzgw3
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ABBB4160007
X-Rspam-User: 
X-HE-Tag: 1782092398-681115
X-HE-Meta: U2FsdGVkX19qt2ESO6w8Vcd1Vlt5Qb3VnQ0ZAxc2+MRygtFiGjkH0luuq61uZNpS5MTINwg7UY1cz5FsIGQV+RMrNx+bsg5dVFVFfkPI9uX8DYoV6vjC8i1ewDH1rZ3GqfXJZHg2h/mUDkrU1qlYE0Bcy5Fp/cA6TF7Jf61lSZMw9ki4WV4RAdfnD/qUp/mot8x2lyNoxHafz0tWSVyAWj0F1bnh0u/8qlCO5RHeAmTjILx6LKhbXCh/Z63wtj0wWbGI2QbLd8gNmYvVpca/qfrwM0/44H9S5Oq6H6fOyzrMNLBHf9FXhL/XC1tLpo3XXHhOy9PoUs5HBhN+ng3PkwsNErch4t9RaXbzvyMntltQkFr07i4syF05MYtGhiqDzvST+IBJcUXNDrl9f+CE5E98qjglbkeIfIOXKDZT6TMLMOhjwh0CE/Apf+51NIKTq9WLq6XkQqJZxm+LkXlww67myFg1HILW/gEdLAJOGF7/xIhR2wnp+AWm+cTRmT3F10gqxRNjyf5r6SccoEonpjNXWvjR4xw3f8U189Fk3HWXH5FzlwUYTAXepvbx0eK7C5qCnYWtd6G6zRwVMjOljLias/Aba+PSjHNoFH0Br5y2Baf2HNbwkD6FN1ldm4SNPQWscy9Z1E7u0tLYlffzzK/0VirssmqQl3LRP1JowSwZ3kQ61/i9vzOygauEauhEXZtWauokackN0SYAioMDAaMZnmDF/xuzhowSfdxujXS9gCX+XtUZLJRxIVthJqMU9tQal2INAv9UBuCtkVJ8RF274bmummcI7BZKhv/WEeSJTIsyaUGU5V7SATW8ZIJugQdJzCiZwUMPkvPZpEu08EykQwOoIAa4SRkxAk00GhAsqHMJvhr4wh2p2IPTSPvnE69bs3CsnNfWzWEUetauB7NLM/JQlQhIFGkukLftcaoh0HA2o/4/NXfvSikRpORr7cHaFO3UoyWoGNjx9i8
 qxSBEnA6
 OPCOk7tJr+VMGQj9n0LggHf3GswLyQAqhGBAMgeijHnYgXQdRuVso5aKzk68BHByCxWsOJjs8e48pjXd1yahw/lI8WjtwJSnazT7KMBuoyrFh5qB3XZUdYlfgUZHnEJoYFNfqwazY5N7Ga7fqylyDpqIJWBlzfcFVfiAMZ3C1sSSkkMV2lhWy6RrhMY5iYDkWN1kORrx58yEzAV9ezoeRC+88jdmofbjbAjUaegx3B7g+Rueot9twQiLD/4AgFIrcLbA8NMQU+FgKU3Ddd7V5aTcJ1DwwYzKB2od6JtSJmztIE8Ukci3p5IJFldIUy2lynHGV7A+LpnOBna4LaiGdB09NcwubDsfLKdHWj1+AegoW/hBVx5eAB/WGcsWhrD7l68DJYF6gpeqQfXDILW/6DGSMVA7mGmq1SJbxQ0Qo+WkzHUvUv6DeaRJCXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 12:41=E2=80=AFPM Ritesh Harjani (IBM)
<ritesh.list@gmail.com> wrote:
>
> On PowerPC Book3S64, MMU is selected at runtime, so macros like
> PMD_SHIFT are effectively runtime variables in the Book3S64 code. THP

Not an expert on Book3S64=E2=80=94could you explain the runtime variables i=
n
more detail? Does enabling THP_SWAP on PowerPC cause any build issues?

> swap code uses these macros to size some of its array data structures
> based on PMD_ORDER e.g. SWAPFILE_CLUSTER macro is used for this very
> purpose.
> Hence this patch makes the users of SWAPFILE_CLUSTER to use this macro va=
lue at
> runtime and also modifies swap_table and swap_memcg_table which were earl=
ier
> using this macro for defining the number of table entries.
>
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> ---
>  mm/swap_table.h |  6 ++----
>  mm/swapfile.c   | 17 ++++++++++++-----
>  2 files changed, 14 insertions(+), 9 deletions(-)
>
> diff --git a/mm/swap_table.h b/mm/swap_table.h
> index e6613e62f8d0..90e2a7852300 100644
> --- a/mm/swap_table.h
> +++ b/mm/swap_table.h
> @@ -8,16 +8,14 @@
>
>  /* A typical flat array in each cluster as swap table */
>  struct swap_table {
> -       atomic_long_t entries[SWAPFILE_CLUSTER];
> +       DECLARE_FLEX_ARRAY(atomic_long_t, entries);
>  };
>
>  /* For storing memcg private id */
>  struct swap_memcg_table {
> -       unsigned short id[SWAPFILE_CLUSTER];
> +       DECLARE_FLEX_ARRAY(unsigned short, id);
>  };
>
> -#define SWP_TABLE_USE_PAGE (sizeof(struct swap_table) =3D=3D PAGE_SIZE)
> -
>  /*
>   * A swap table entry represents the status of a swap slot on a swap
>   * (physical or virtual) device. The swap table in each cluster is a
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 78b49b0658ad..4bf11c5b87eb 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -129,6 +129,8 @@ static DEFINE_PER_CPU(struct percpu_swap_cluster, per=
cpu_swap_cluster) =3D {
>         .lock =3D INIT_LOCAL_LOCK(),
>  };
>
> +static bool swap_table_use_page __ro_after_init;

Does a static key help here?

Best Regards
Barry

