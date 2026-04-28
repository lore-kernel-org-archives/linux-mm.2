Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F37D1FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 04:19:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44DC06B0088; Tue, 28 Apr 2026 00:19:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FD1C6B008A; Tue, 28 Apr 2026 00:19:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ED006B008C; Tue, 28 Apr 2026 00:19:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 190BC6B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 00:19:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A97F51203E9
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:19:27 +0000 (UTC)
X-FDA: 84706660374.07.7A90A28
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id C17C4140002
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:19:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b0cNj+B7;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777349965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l36jYQw3S9CkWOT8rarl+Hm3YzW2q+d0hCE8MXuOd2s=;
	b=faPqZjesY7ncb8jB0KxQgZqHND1v1kGx3L+QZi+jXeYwKCZEGDYfv3QElwjpHdmY9kQksF
	eofDQw72BafpMTrN/Df7Ur+GP3JqfTwUouXw76baFR4HMo6yM6gNQGB4+xfshHvIo1h6/q
	kFZD+r2ZUolI1E72SM/3lyis6/zqpuY=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b0cNj+B7;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777349965; a=rsa-sha256;
	cv=pass;
	b=6Yy/gHWKGb9Z7gfI8EhAE19MAo8CvAQ2R11zyjARNacwqJOFami8AkWW5XoXMq5JhZuHZg
	pn3q1IOoZ9x8Jj8oFcQ1tZp2oWdvqK31flJyl0c1RTHh9sSHbluWclbdal/SHlwmQUGODx
	g92QVm+3DBIK0LehF8yBRo+C7s1RBOU=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-66ba9dfe83bso13580429a12.3
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:19:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777349964; cv=none;
        d=google.com; s=arc-20240605;
        b=GaQEHHd9WKFtGJPXCPf6mb2qmZXZjk6QSg9PoxOJdjb8wO4N/BHsjBpqDcgITcMam7
         zEjuDd/vMmgklwwkXUrC7D/A+C/ByhGeGqPlMSmalEv3EPe+0jHeVRlAUmoDxEfb/+GQ
         KIju1tRyGQln0T2N/wf6n8FNXpm1aPPRYqamX6ZOU28BYWF+/3cTxczSRbuHg8A0FxpQ
         y9ICzN7T/nhWXOuLdYtxBKXjBm9bMbr99qZTjMqnC/ZmHHoBFUHJZY/KHKpNh1nFH7+W
         Y8VkhR8jn1jNxaBpW28lgGLTgZOz64UFYD8h+JmX467EBdYB8ub3qe5BmXJ8Nb5l0hvU
         2kyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=l36jYQw3S9CkWOT8rarl+Hm3YzW2q+d0hCE8MXuOd2s=;
        fh=2dzZiTRFaf83jKmLLFo9MuPzS8cmGzF2TZjvZGGMNmM=;
        b=Qw6XOHdvYy4ykp7PUNQ4p7+//UtgQDbJdzk974/becGIxqrTjIqFi3LgY3KD/MeZzC
         q+yy02d3OHSV6UK3aYOdr92yVivt7flH2wVMJKx5KO+QBaLaXsQAuZEcte1Yy0r2zhk1
         F7zPEx+UP97vRfTcvpTg4Pa0hr1vD1xuCnDtZkUm587ZF75mQ8XoZVARRAB/k7c1rvGh
         46TWJkmgWtbzLxuYsfaaMMlRtS1/JTSsrvjj2/Fjqp/OBi82oUj1LkuOrVqxMa2RuNyM
         O9+wgwpktXqXwRyjKxYeRST8544jarGMQOSuK7xCGrhdqELW5Qn7gvpyDhsZzuWg0pZj
         ZaZQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777349964; x=1777954764; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=l36jYQw3S9CkWOT8rarl+Hm3YzW2q+d0hCE8MXuOd2s=;
        b=b0cNj+B7UAcpeFDvdSbzU/RdmMmVnut/xTYHnMRxwY7It10bkJDArExlbOBSeEY9tu
         ch9q7+fPzHe/k4N5t0vvWpJtlKFavx0J57aKrsYtwxPHmx9TNAQpi0KHHz1xvaE/vHQn
         Hv3MZ+vVUiWPGSzq/HMdje+I74Z6O9otka30wG5p583Fm5+cQSLOvf/3hY12rQ7qEINp
         a2+Z932u0UBORRqdlj6M9quamdfqFJPWxhPDMDDPp1T5tQI0A5xt00IMQObqUpIA2hIZ
         7FRFSSsnO70adS5xEooHwleUk4C/Ew/FPzRq1NXIZHTA5H9+qRP4rXh9kX2M0Y6HDTaP
         dbQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777349964; x=1777954764;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l36jYQw3S9CkWOT8rarl+Hm3YzW2q+d0hCE8MXuOd2s=;
        b=Gn70Z+HHEee6rq+EsjMz9eakarRhE1Fq9+Zh/kniJTD6W4ucPf+NDuG+sy24n0L9XQ
         EAagLrhpFTaPSM0mhSC1grJxFIkdiPVL5tEWiVpmy+9P5u/Q2k4W2tAn8MHeUfiyJ3lg
         EpvnGjEp2Njz73g+9vTkC5HfXzQ8q9tvdNRggDYGerKVv6fWbKLoW0zkvly+UpM4sA19
         D346ier7sWszRXWUYjtHxCLeVhM/J8DkOMacm80NAEyOWA+yPxf6thEgoGpx6PkQsDGY
         irp1VJaehDyDZp8v8V4ProHPDgSnLWr74ujoRIJ2tvVr0DjFBe0H285WP9XEQHMIrML2
         Eu9w==
X-Gm-Message-State: AOJu0YzpTO3jUYoZW+PXq4h3mmY+eu5t9CWoJmZJH+07dtnCIQFGUfj6
	5NBA0RFf6k7SKeMeXUs0PfVQUk13sN5Hj9IkFK6qSsGQQ3RDSo/nZU1tsJrZ+WBAhX37VFvs9Am
	n5dRvyW28exKm3pcPo9+xD9keDAohVLg=
X-Gm-Gg: AeBDievUxEaaybPwoGxAUPp0eHzF3HemeIpYOav8PsWTz/ud70tZ/cwdFWidVVQJ6mL
	pHo8XzVBouTbFMObs7fmc2qVNXtozFiOqalQP7FAo2eU2MYIsFftQOIkZHp5S529xrJJXSmZj+H
	1NaeLOHDppcUo2bKx23iIBbYuXHrbOsgUsep9ZMvuXMXPlHL0FsF8EBFJAmXP/tucIGl5SFJOwA
	usYy//drVNIBRxXE11ghCUhgGzXpWm3NR5f7K7iMSEz99fSBAAcqF7TikKpGWf/Aazrg0UyEPsG
	rQ+8QUlnDO6+j98H4Ny8ppLDl0BZ3wl79IUE53Sk3ajX8X+yPOg=
X-Received: by 2002:a05:6402:538a:b0:66b:f0b3:42a7 with SMTP id
 4fb4d7f45d1cf-679bb08feefmr562449a12.24.1777349963792; Mon, 27 Apr 2026
 21:19:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com> <20260428-mglru-reclaim-v7-6-02fabb92dc43@tencent.com>
In-Reply-To: <20260428-mglru-reclaim-v7-6-02fabb92dc43@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 28 Apr 2026 12:18:47 +0800
X-Gm-Features: AVHnY4I4WsEgLyjFriMugbyRqjoujv4Dxa6irB0iKozpBliSb26LmXECEOcLC2c
Message-ID: <CAMgjq7DF8qtQSXe9P6PaFZanRpWSZtxx9_sF3R0FrVcyEayn5g@mail.gmail.com>
Subject: Re: [PATCH v7 06/15] mm/mglru: avoid reclaim type fall back when
 isolation makes no progress
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	David Stevens <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
	Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
	Qi Zheng <qi.zheng@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C17C4140002
X-Rspam-User: 
X-Stat-Signature: 3bgd4ixsjhb8xh1k76irsne4mst46wrq
X-HE-Tag: 1777349965-107031
X-HE-Meta: U2FsdGVkX19jqdOXvceAH0nb5CoQuMwJHo/+qRb/QShkRaOcp1u1JKdPqtzVw0b6nS74mM5wK3LKuq41jb1aUXMK4GhMyXo7X6p1QKPIACrz86IWqK/NMEbagQruOWT5r4NLXt3tU1YS3QlZewt2LK4atTnkzkkwCSStZKjPX8oTk6E78JVb9Hp/C7E2WSj+JzydXHzB1yMe1Vem/iExu3Exkgc3LgaEEt2elJLKxKjiO/C3BQzljlsIfUB4Izh4AQkkuZ3Fg9ZPZvhPZZg1EknZ9zlTDZev8KvgugtIxfqhCTMpzSejSRRKanakrUURRBya3lEMbwb7tGkaHboJNCygtG+lFPVlBl2sjgEGezzBfrWCtotL7uB6NamcZIB++CZWckxhd/lLa3MBTFG51zTQa+XNQWe3LQgGpFlAKpR77hP5i/8a/crvGfOnf0XvhIAKS/iNqJl4dz4fxTdiDnNnnNNRYePAKAbwHw/TVGDW4YUXlMopzfkVepVCPOhvv9Y0Oke5tZiqFu+pPQJwkM/LqvaYstEv2Lcq89/OZH4EJw1BVQxoR+x1D8wmU7msnAFTQ7CT/X0bZxfi7VfSt79z+Q+UHDGrUavon1hCek+XijLhL8yHl1qMzx2mH7843VaI8IiBMiwDdDJKcI2hP8bPuXI6T6KgwwJcwWBlR+p3xZOrb3dkFWDqWG/uT1yUYxK9Ls9aW822CZxSjbJPxvLxBuo2SLNTFYEr6opnhKWfK7rP8P+lP1Mpb0WCcAum/FfKxN9VdtrsktLLGeIcL7qCTKIiCeJ6sirqgOzTwWlMSkEWPjt0aEdpLfrWm2ex7bUQ0kGVzHDZ2AFrr8ZuN74nOA5cXenFx+f7sw9QD4SbEDazehN0RFJN+gL5BfddW47Dml1t8Tl3wq33VRtgC/gI505uvm7xSrSWxPJN1B16lCdFiNNldEEFWNlLHxAH4YebfWUtQQdmd2NIUai
 FPSIk2zp
 XC/vz9FCRvV+1MQ955d8RII1YVXu0wiPk9n0DGcSfJU52lfQp1mQgZJouUcokrEJ69NGd+rrBKLvVnF3Zta6S6M6D2fdxzeuCucnL09XUCrWUUmfnA8pIhCaOXz3mSFhzT6mP8DI99w9CIkmdPfho7lAm66khPlCgZfDriDsvxRC8C0SzhQKdm3wUE9k87eWHKHh5UVq5Bvo5K/VVHoUZVUP9bkb2O7aXYB7asMGMsGDJdmM2VHaMsOCoVd19KPiRrHqDEj249QjUcgYCkT2EouAf3N0QrryOcEKVfiLMGj8Htp4AdJaOeoEJmH48z2gp77u7Rqm3dv4NOv5dqrEeb5wgdD84yVDWRxgT1/pm1brSZyb6tvn/Xs7SMeSxgvGbqI+nCJq/D44AuClUG/u57ly/mqP/Upy3OgEl5Egeqx5DIrKM5ihIOQHo6AmH9qXV8aqNxN2KSNBLg7/R1QBnyvCtbriHLufzhjre1oErJFzD818iccBLd6l2xNpiWFR+iC29tcy+Nx/B00c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding sashiko review, which I think is just false positives, just
to make things clear:

> commit dd4c6bd11860d1bc69ef77e9f0d457abec425fc6
> Author: Barry Song (Xiaomi) <baohua@kernel.org>
> mm/mglru: avoid reclaim type fall back when isolation makes no progress
> This commit modifies isolate_folios() to only fallback to the alternate LRU
> type if no folios were scanned. This prevents falling back when folios are
> scanned but none are isolated.
> Link: https://lore.kernel.org/linux-mm/CAGsJ_4zjdOYEtuO6gNjABm7NDxW0skzBFNRNee-k2D6VwsYEQA@mail.gmail.com/ [1]
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 43c0f22f15d5..304d5a4704ec 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4817,8 +4817,13 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
> >  *isolate_scanned = scanned;
> >  break;
> >  }
> > -
> > - type = !type;
> > + /*
> > + * If scanned > 0 and isolated == 0, avoid falling back to the
> > + * other type, as this type remains sufficient. Falling back
> > + * too readily can disrupt the positive_ctrl_err() bias.
> > + */
> > + if (!scanned)
> > + type = !type;
> >  }
> >
> >  return total_scanned;
> Could skipping this fallback cause a livelock when folios are evictable but
> un-isolatable?

No. The total scan budget in try_to_shrink_lruvec() bounds the loop and scanned
folios are moved to newer gen. And we used to skip it here just fine, this
commit just restored that behavior.

> For example, in constrained direct reclaim like GFP_NOIO, isolate_folio()
> can early-reject anonymous folios due to missing __GFP_IO and return false.
> When scan_folios() places these rejected folios into a temporary list and
> splices them back at the head of the oldest generation's list, this code
> path will see scanned > 0 but isolated == 0.
> Because the fallback is skipped, isolate_folios() scans the exact same LRU
> type on the next iteration. It encounters the identical un-isolatable
> folios at the head of the list, skips them again, and returns 0 isolated
> folios.
> When try_to_shrink_lruvec() decrements nr_to_scan and retries, no memory
> has been reclaimed, so the MGLRU statistics are unchanged.
> get_type_to_scan() will then select the exact same blocked LRU type again.
> Will this starve the alternate LRU type and potentially trigger premature
> OOMs?

No. Folios stuck in a non-reclaimable state (GFP_NOIO anon, writeback-waiting
file, etc.) is a pre-existing concern orthogonal to this change, and it also
applies to the fallback type

Falling back to another type is still done if we ran out of gens (scan
consumes cold gen). In following commit the writeback throttling we just
introduced improves the folio stuck in non-reclaimable state issue but
not related to this commit.

> I note this behavior is addressed later in the patch series by commit
> 8992ac501e543b77bf0d5e24175632b6eba8086c, which removes the redundant swap
> constraint check. That allows the folios to be isolated and promoted, emptying
> the oldest generation so scanned can become 0. However, does this patch
> introduce an intermediate bisection regression for the LRU fallback mechanism?

No, as said above, that's not related.

