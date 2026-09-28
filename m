Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46667C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 05:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 460A96B0092; Mon, 28 Sep 2026 01:24:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4118E6B0093; Mon, 28 Sep 2026 01:24:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 300656B0095; Mon, 28 Sep 2026 01:24:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0B7D6B0092
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:24:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE0D6140B2D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:24:09 +0000 (UTC)
X-FDA: 85262029818.09.27C985B
Received: from mail-qv2-f43.google.com (mail-qv2-f43.google.com [74.125.230.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id 15BC280002
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:24:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jMugrRef;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.171 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790573048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=FSUAgom6ClfwbocQ8Hvkd64BKo/2JRKTu5CIvXmRMWI=;
	b=GLu+BIZi2uSHPm6US0vnJxH8RfuXwkTk/I2DN3/gy0/3HBg41jkBnYu7hU+08xvyBQG0m4
	WS2CxGPFO8nheZGzw3PF4nDY0NRXhH0wQTvbOf5FuApQ/F4hP2hRj8SR4j67nXdWjopIt0
	JwWg+GMpZukJ62SO5OfxsDPm5EdUejI=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jMugrRef;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.171 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790573048;
	b=ED28kJF+LU71WprxFzcJmF0YllUYS1HcILdL+NfoIhP+lQ6PaMXyNgGSsfC8n+JlzJdWgK
	ZYBj5gFhUScOAs6LQ/JG5H4HpYhrFy2DctoQ+nWG+SABZhBgPIDYY463EaMuVhkp15ylVe
	QRROi9URLl+RTyr9xpVlRBNnijQ4uSs=
Received: by mail-qv2-f43.google.com with SMTP id 6a1803df08f44-9142a19ebedso32926226d6.3
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 22:24:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790573047; cv=none;
        d=google.com; s=arc-20260327;
        b=AHfZPk0eFfhBI8lvJmmjMEcaA9cyxecAG7Sbj85IwkW0thn7FdY8EETFXu3eqLzQxD
         7Vmmjdl3CwFJ2bx5fHM3xbIk06iz4YMesUHxFauh6WA/hqIfbvWq1u3+gHhuixERdJ9J
         zouuhpTxOLYBMQWT0jCCtJ2DlZSSjJQ2/kiDwEZNBaOVFSwwxWJNEInQUl5QgLnVVtru
         vhGRWhmMC+wIMPmP2guD9Z5VogGNNgbmRoV+WGwJ+ibOSnBReqRmKgae6R64tKLgEnTB
         u5SIi0UTXdjswMOF6Jd1VqOxge6UNYgff4D3T9ysGTNtJSbiSZcJ/xSEjJs8zV8Lsog1
         VGvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:in-reply-to:from
         :dkim-signature;
        bh=FSUAgom6ClfwbocQ8Hvkd64BKo/2JRKTu5CIvXmRMWI=;
        fh=asbGWqRitwnx1yBKABVI1zLcImLTbCaNbN6tD86jy7A=;
        b=BCk0cNwbmERd1eIbspD0T2tTSuZSTGMLVH6yAWK8xAGgkFKQtQ2uIAaf2BqGmHYvXQ
         n4dSl3NQWrTVhEcKVOv/n9OVDYltigHA3fkkDGlheMo9iHoM0CwKjzV5E642QroPY/Ly
         EYKQpmFh3alBSi3rfCKrSjkI+Ngb8gQCVKzORB1etBKBGZkNvqmdrcvTMfYhqszlTP4e
         fP5iZ84gsICX91ZaTF/LYNuh+2YH33NDW4q4lCZuNs+tsFvVoKlWge7TiXCU73c4Wh6V
         xfHSpoIa2hFfbSQDIxxqzgJWkG2LOfo+qVRTPMYnpbCaKLjcv8vtWQtx5tSpeNsJ0yrn
         Iz1Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790573047; x=1791177847; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FSUAgom6ClfwbocQ8Hvkd64BKo/2JRKTu5CIvXmRMWI=;
        b=jMugrRefJ7MOj7iADha/hNwQFaLz9nrguKSc2dNs0ZtdKwTlYBXyx1xi8Ws90PvOw5
         tYhdifT9HXonW3Wr/rrbCxK9CT78HSWk74GU6BQleo6Sz2wQJsUJT0sm8F1ADg6EbrFc
         w7J6OJsIiyemVQkVN2Gtdl06o4YMEBNTlpWIrp0uvM7AZ3FvmC60HPuhIDIv9eHek/4t
         YsTbp3jEENE75XGa9K3QSgF19YP2WJpVVEHxxkp4LTQpJC31IxC5BiWd030xpXiXrr+q
         VU6VhrBR+CYcQY7J2+6eHk6KPv32w7TXVNWQxkRDofR/YFvHkybQ44olT2TItUDL0W6r
         /JWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790573047; x=1791177847;
        h=content-type:cc:to:subject:message-id:date:mime-version:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=FSUAgom6ClfwbocQ8Hvkd64BKo/2JRKTu5CIvXmRMWI=;
        b=ZjAGgvPvUoki96lhJuhCULT1t8OtwLj1QyYqsgVrlbzPQP85qyqnQXBhUn1N2pcoj4
         Vl80Fs3sOTnQB3ngIz3hMMfBHV2isdCblPKE6j8U5bDPNSmLUUa/T4OA4ODQWbFDDHZ0
         YE34uxHC75mUrS/DJBRCwYiennJkkOiXiAZfvXMb5xPqZLffH+jLAuXiapqDFWf2DkfY
         zwZgmDL62I/8xe4lHM/BiC7JTb8N1buJ8SIj8FLe0iz+SWAp+by5EQ6c0q45IOgtzzTQ
         v2/TpamI2qq8WCeAUPtrzukee96ooHAeV3ovc2rToa7G/jzKjj45Kv1esi+L5R/Kw9wG
         GKOg==
X-Forwarded-Encrypted: i=1; AKwUvBzyS+NV+aC9L8imad6s8ahw1YBSD5lHpbEoEmogNKN43I7Wsqgssot5qHJzfskXNMZmnAMzXTollg==@kvack.org
X-Gm-Message-State: AFq9FYJTZKc0rSAbcALSdfLukohn1cxHED1nhQpDq3X2koQ/ZLGa4dGL
	0GDbe4mBCwllWb1rOBDfbSPtoqfgobB3GjRVN49SjjIGzrpI/GRp942ogqQ8VByc9wjUlgtrfNL
	TjgzVPFRFDsajHtsyJX20jNlxwScYRAFerGApmLSf
X-Gm-Gg: AYBFou2eBzE5/UWWS/JQq3jzIf8LlAFOtyTuGflwcyx9bzdqJgchtImRkggOsUHDzw+
	UHWayDbOKI+Ja6LArIwGlnKKcV4c1GJBHyNp9H5nGCLURvQmbMaanXynk0MXaMFsRL+0jeHOcVn
	ZR32lGmQfTL9BMG7LSBOwxD9zVZ//C58fvC/Cf2IsaMcHgEbuxFDksngNQ26YvFxtPvlKzFEly+
	73IO9iagOtwBYnYcC8pl1kC8uaObzDl5jVvprMoEloA9gNViqtPqQ11MlkC5ioBEtSsYEkZcfEM
	pveV8o/CtNEg134IqrFyKzCoD314FIp92GDgwKq7ba96HdQ2pri4/XbBrOdA6RYT9qTNSaEE6fT
	iYnBvJ/n5PQ==
X-Received: by 2002:a05:6214:5345:b0:910:3453:505d with SMTP id
 6a1803df08f44-9142f8f69a4mr164488216d6.31.1790573046662; Sun, 27 Sep 2026
 22:24:06 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 27 Sep 2026 22:24:05 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 27 Sep 2026 22:24:05 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260907132055.26696-1-zhoujinmeng@bytedance.com> (message from
 Jinmeng Zhou on Mon,  7 Sep 2026 21:20:55 +0800)
MIME-Version: 1.0
Date: Sun, 27 Sep 2026 22:24:05 -0700
X-Gm-Features: AclHuK8WOXn4uKOxOQYa2ZuB88hz03DSLUKDlBeo924q-8b9bdy1WbZFMN4BZbY
Message-ID: <CAEvNRgEvbCB_y23odHurRnhA7Fxo5oWYwrFyMy9+r6fFSCRw1Q@mail.gmail.com>
Subject: Re: [PATCH] mm/hugetlb: fix subpool minimum reservation rollback
To: Jinmeng Zhou <jinmengzhou22@gmail.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org, 
	akpm@linux-foundation.org, mawupeng1@huawei.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, zhoujinmeng@bytedance.com, 
	stable@vger.kernel.org, Karl Mehltretter <kmehltretter@gmail.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ghkdarkzrufktwjrt8xmti6eqqx89jga
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 15BC280002
X-HE-Tag: 1790573047-978775
X-HE-Meta: U2FsdGVkX19z1uXpd+praiUwEwGaNzUpypDFkIr633AKRz7GQIfXbrJT//wWTszVsfuegYWwlAMmk43VXZrpavgO4lnV/1Bj9+bcBqa2NA4h8r3JnnFK9n5RuHVhYe+fQou2rEKPeBdtXikbWFVxV9RcQe/GvrSwHUj+gDYxAcKuI+g32KWWYASg4UEM+wT0wxQ0XutWTgoreaJGrZiLfXUdtFC/9e4S/fkG4ICUq4NUHoXD2G+7FdnzLj3b7o8iJZg3ZbO3YjIDBZusgl7DAnWSMsMWrzit4j69coedk62EIa48pIxYeObpi5xZmwtYjVLMOKHCwVv+NXQvHr3/hZmZru8k2JhyIHB/WzPP5zIeGsPk+EzH/o7BuJTWBrWxW/LsxJxiJCfuhi+g8KJ7OewDtICGwobtSl9JPqdwPYF4JJz3hfWbYzJ13YB7FU43ywiXI+E6wijsnLuTClXVIIdCSbjaCkF2kdJEdGONsrAVffFVc9zgrZ25lhHhnsIVLMXNrUId5Ig2lH/TSkYJ+tkvIG9TeIrythTlWaclemJilvuhzJOm/u7yt+PbaQh3BqUyY2hkJbLrjvF81yzasgO2gCu7bqqpF6M8kmn9FDL9C0KWPR8CM0Kz41D4E4f/BKiYI1qnoJJxtuhxosLANLGZBOdGYQMXkkzHtyStsRli+TnBtqf9Tbi+HtavxJ/GHPbsx4NGAXQJ0q1jtk+SMTCXl+td7EsSzu3303oMmz60zx/o9EiwaNM9aSuotLtW1lcwoFN6K1QBcdv8LA3RgGACvHHEojkVxCyv8UYpPuvYfbghrQZfSibSmxX9dFJJxvgiCUW3c+lKEwiHXw++RRlh7IxeMC5nnV8rogrRGf3hcwE0w75DMJ3NdtmwaxAlfAoybmveIIj0dqaJD8bQ+ONrnwSDpGp1OZZTOtGrUha8pwTkjnpBlsQwiUV2NsHNr2kmm+OwhBrjslMKb40
 m6qi9T41
 +9w96QAgXCqTMMoXpYGCzxZ++xYt+UHSXeisOSdHpRn1l91wrwS+yuGCddgJxhkH0wzmQp5CzuNm1h9s4uQ2EYkZ8nxPDKUOfmPzoNLzaXHEn2L293A83uPTQ7E3OeVhYs0EFw6Ieuvmgq/x/+7N2mRamwW4drJSQ8oyXW3Z8rNY7J+KnicyaPb9n8bA6mB28jIIqFy+LXKBUke3yMuz8ZI7IXQLmLfw+DaerzRn074ZSUNC6TM3qF79SZCl3fFfvIymlKB8c35UubVaSUOhVK7A1/ndlB4Ya7dPwjON3JvawEAevviesbWl1bbqCVL7j8Ab5SVrh50B+vik4HCtngeLfOuHhxCIL+7FyV70UUmWOpJ1LOHvqD9AnaXtYLG5qgFFKSwGVSUTy2z7RIp5RZ6rvGo5Q0TCPrv+qhy6TuOMv9yicS7Mj77RBIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jinmeng Zhou <jinmengzhou22@gmail.com> writes:

> When a reservation request is partially covered by a subpool minimum and
> the remaining global reservation fails, the error path first calls
> hugepage_subpool_put_pages() for the subpool-backed portion. It removes the
> failed global portion from used_hpages only afterwards.
>
> hugepage_subpool_put_pages() uses used_hpages to decide whether rsv_hpages
> should be restored. Since used_hpages still includes the global portion, it
> can remain at or above min_hpages and prevent that restoration. It then
> reports the subpool reservation as releasable, causing
> hugetlb_acct_memory() to incorrectly decrement h->resv_huge_pages.
>
> This was reproduced with four 2 MB huge pages and a hugetlbfs mount with
> size=10M,min_size=8M. After a successful three-page reservation, a two-page
> reservation which needed one subpool page and one global page failed with
> -ENOMEM. HugePages_Rsvd incorrectly dropped from four to three even though
> the subpool minimum was still four pages.
>
> Roll back the failed global portion from used_hpages first, so that
> hugepage_subpool_put_pages() evaluates the minimum reservation against the
> current usage and returns the correct global adjustment.
>
> Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jinmeng Zhou <zhoujinmeng@bytedance.com>
> ---
>  mm/hugetlb.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 785772845795..3e3cda181e72 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6808,15 +6808,6 @@ long hugetlb_reserve_pages(struct inode *inode,
>
>  out_put_pages:
>  	spool_resv = chg - gbl_reserve;
> -	if (spool_resv) {
> -		/* put sub pool's reservation back, chg - gbl_reserve */
> -		gbl_resv = hugepage_subpool_put_pages(spool, spool_resv);
> -		/*
> -		 * subpool's reserved pages can not be put back due to race,
> -		 * return to hstate.
> -		 */
> -		hugetlb_acct_memory(h, -gbl_resv);
> -	}
>  	/* Restore used_hpages for pages that failed global reservation */
>  	if (gbl_reserve && spool) {
>  		unsigned long flags;
> @@ -6826,6 +6817,15 @@ long hugetlb_reserve_pages(struct inode *inode,
>  			spool->used_hpages -= gbl_reserve;
>  		unlock_or_release_subpool(spool, flags);
>  	}
> +	if (spool_resv) {
> +		/* put sub pool's reservation back, chg - gbl_reserve */
> +		gbl_resv = hugepage_subpool_put_pages(spool, spool_resv);
> +		/*
> +		 * subpool's reserved pages can not be put back due to race,
> +		 * return to hstate.
> +		 */
> +		hugetlb_acct_memory(h, -gbl_resv);
> +	}
>  out_uncharge_cgroup:
>  	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
>  					    chg * pages_per_huge_page(h), h_cg);

This fixes out_put_pages in hugetlb_reserve_pages() on a mount that
specifies both min_size and max_size, and does not introduce any further
bugs AFAICT.

Tested-by: Ackerley Tng <ackerleytng@google.com>

Further details at [1].

[1] https://lore.kernel.org/all/CAEvNRgHQLifmcD1NO6cd7EVcCiQb6gJgNUo4HkFhZAvzuwMq0w@mail.gmail.com/

