Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF8B5EA8542
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 03:51:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDD2F6B0088; Sun,  8 Mar 2026 23:51:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8B116B0089; Sun,  8 Mar 2026 23:51:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C62C86B008A; Sun,  8 Mar 2026 23:51:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4BE56B0088
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 23:51:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3F5E7140CE1
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 03:51:19 +0000 (UTC)
X-FDA: 84525149478.11.E733CD2
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf15.hostedemail.com (Postfix) with ESMTP id 40584A0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 03:51:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XI1nlywN;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773028277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DXxR93eN4nOXJ2hkzZIdpEw2+mXW+oYXzBW7KM1qKYE=;
	b=qi5M12Qh9sHt/pF/YOhCbD0WdKcfqi+6hDQcYg0CRBWKv27CmuHm5WMZ4DVofFC5/V9xQo
	/7I/SuGXqAEFAyhw9YDsP5cQUYO+jxQ2t5qeXczpWeZCcmylZD3Im+lYJzg6YIxY4+ONWJ
	GeYl/GWPnRQ0hrOLmgPs3Z9WC1aedsM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773028277; a=rsa-sha256;
	cv=pass;
	b=YyK9NdHYbdzVOc9cEIVMQwg/Kra+wwuFBVqy2nRSd4L9MtuSpxBVD1PQ0RYqVsg/emyu1b
	Bhh84rxZl0wKz0yvaiFGDFvxAHFQZrbTKQ+2rCzIZ+PrAZ9x832uw015/rNBs56qCkPfNG
	KPg09g32rsZnB0nmt+VspKaJ6DPqpWA=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XI1nlywN;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b9358bc9c50so1224892266b.1
        for <linux-mm@kvack.org>; Sun, 08 Mar 2026 20:51:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773028275; cv=none;
        d=google.com; s=arc-20240605;
        b=KJ+/GTdaOrc5gVHtbztKFutnNJR2d33dz/1OFCL76IS1Za/6mnro23kZJtAzprC/ql
         HqTf6dfNQ8G+IoSBHpebwsBG04XSZPkcgwRqHs5JAqzNp+gbguzwFQXYwTyYtv0QAUhT
         btE7l+9YlUYSfmuqja28k8fIkyKVcz/hnzo3KQjCqVD6LHUxrCyULx2AfrRGH57ctaDf
         eR1SehAm939wK9EZ/b0tT9bXBEJIdKP+ex86LIpkp8axrCcGVO/tLD2qmM1jiroCaFOh
         9ONqxkZl/E2l1pTBG4XfckoBeyzffBOVKUCNVhkqB95GABE6yn1cc4tM+AQWQlAsu7hk
         4JYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DXxR93eN4nOXJ2hkzZIdpEw2+mXW+oYXzBW7KM1qKYE=;
        fh=4c/Wd/9qbmcSFHl/zBfkwHXiE/kZAYAU/GUynmTkbQQ=;
        b=eU9Kg0K2tcNx3qXB/fT+U1mJHMxXe3p/OdOCmGYctm5R8+cF3xHJN9INEmf3AGHJvY
         5OV+uNnXh2qajN7NNTv6fYjsVwDBov5htfdyvVTbIqOxCIZ+STS5u7ODRIMM7257zA9t
         CQeRoOX5DqpiO+3xI6i2X4x1C4378DZPVa2WYYVXxsJGOeiaSWQmFhHdN3NJWO0i7/Vj
         bvlfnPhWQUwLy0QX1kuUJMau2dB/v+65mX98BfCCf0CcfZCpqXYC6BfudsoHLH+io0Qj
         L9UzibNQduzSTbMaN9iLAHwWUbfGbecyEPNSWJxqIFXvRHSwwK5EjfXUahAhZpu8v51p
         xIBw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773028275; x=1773633075; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DXxR93eN4nOXJ2hkzZIdpEw2+mXW+oYXzBW7KM1qKYE=;
        b=XI1nlywNSw1rTg91+ZFnqd2zp5xTH8uYsg/YVGPHYZ1vkGiqMRXnaz50vTck0YLs/u
         Kpv2gzJL0dC6SVukXOPQiZaLocR8XsJDJITFePSjDpehZ1C7Sxps6hNR8UxAryjBuC7X
         ghC86u5O3Mn+yP9kI10jhuZKZxO97rdJ9ALI6cXNbU4WreK2oqpGsWOXGxN0YpEj+rDx
         fvLWKOfNGUjZ4nrLd86ToWbr5gYKUtoaGGmFOcpeWCCnZfhdceBh6Z011P2Ol6Or+B2Y
         OK5ME/JfJOUU6hsJII5B+bb1r0U+92F1z85y1FKTEsb5Uj8wwc7G6tTrWX2mGtCO4KjW
         rTfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773028275; x=1773633075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DXxR93eN4nOXJ2hkzZIdpEw2+mXW+oYXzBW7KM1qKYE=;
        b=JIb6rhrX/t8jPyDGcW7DPS2chGwpYU0bbMBqXcyDXBjuYpPSphrIjbeS3nrWHqL4H4
         VktmWJBg6zbU/XEcgHzLAdnAx6daUkJtMLTqC0hxt8j2pJSMq0ShHiqqK26Cbonm270G
         n5Fi5uB1WqTLMw1E0SLknP5XdYgl/697j+qgV+q44KWwIGNk51NciwoIkF1hFVGORu5D
         1R1miNOk213SxfJVlNWk+hDmzDQyBatkFB01HQ6isVADHrhEqFp/XbWZyMzWFFh2mQLV
         fWto/zhMnwy1H0Jp+gsvpeGqu+QfKDlCKmCgHEOsKJM4f/B1yZ0o+sEZRp35IFz4J57k
         ZwSA==
X-Forwarded-Encrypted: i=1; AJvYcCUOJn+Pug2D7m9EaMiplDJ0WHc65u8iXSusTSi8wrpe1430ZlN8ehHZ4SsEjhZh2GCNA69PeBovBQ==@kvack.org
X-Gm-Message-State: AOJu0YyVHKvddtfqONigFM/4deJcrboYbeIQO9nc9p+mfaF3JNgJoaPe
	vJgSRnW6Mq/RwIJdi2Wl/lxV938r9iFS6ls0askfPFbjuajOLUFAm7SlNb5qEIljiqLxLAaWZo8
	Rxx/CtK/eOOL5ObN0XmiHusVw6mZchko=
X-Gm-Gg: ATEYQzxa5bveRqFthxDBNjcHCdMm0XyxbJpawTuTve59L8BOD6VzN6Se1ka5WK45QpO
	3m17kJNeK/PTGlh7HtBNRSV5Vyk7KcPLucUEJkXBJfAzDtE+grEFpFJzivxVrRvhplKpua+QiKf
	Gak7A7rmj2n0B90w1S9bHEzKY+LxNojmqgavigTOP82HipQneg1K81bmLgPTtcQPX3pNvCVid09
	ppGEs+x8Uv7XCrMIU3jjxfDlXVc5Q5evjvUmr265osEP1t1ts0l+oAkCzR3WCeNg7qYFMPZv5Mx
	g+qf4c5R6uQYI3YdZaG1ARcyck1ryh2MyiIof7A=
X-Received: by 2002:a17:907:869e:b0:b96:eb74:3152 with SMTP id
 a640c23a62f3a-b96eb745f74mr151253166b.22.1773028275014; Sun, 08 Mar 2026
 20:51:15 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1772797581.git.zhuhui@kylinos.cn> <02f5912caa6c427705bf8da43497801caf3b102f.1772797581.git.zhuhui@kylinos.cn>
 <aarcCC/FgqtxEZFj@yjaykim-PowerEdge-T330>
In-Reply-To: <aarcCC/FgqtxEZFj@yjaykim-PowerEdge-T330>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 9 Mar 2026 11:50:38 +0800
X-Gm-Features: AaiRm529TRePdDRmPljpwx8wsAi2YL4m6M7ZbZaYukeWzn1e0tgDUiwVAUb-7ck
Message-ID: <CAMgjq7B3uka8GQtHeJXu7nyCVhTFAcJ2y1EWFTQe3rjVRkqCSw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/swap: fix missing locks in swap_reclaim_work()
To: Hui Zhu <hui.zhu@linux.dev>, YoungJun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pr6uja4w9ss4cr6cxwt7nsrtpagpt7pk
X-Rspam-User: 
X-Rspamd-Queue-Id: 40584A0005
X-Rspamd-Server: rspam12
X-HE-Tag: 1773028277-609364
X-HE-Meta: U2FsdGVkX19C0DT3n67SFyK5BLwcXslGd3XKYT5ExxNaEwZUIMJADzSZvc6rwXlwameJ+xiBVhFhZfrAAcWKMx8YaAWBjCuqxRSnvr7EY5ApHsfwXU4flha1DvmV3/H8Fr+3EnKYxsHQUjGpW4Tv5CqKm2ou4PlX5NrZhFrBHSe9hr3l+461lZLc4lmhnZn6k2HLKvy9mXrYCLLJbiyPeDBSCkcWN4jxu0YCrsLB6t/qjo7vd/yV5HwcTbxGsyJDr6Xlax/FHgbTUyWeorsBpOpnSSRuTmcIhRvwXNaAtHb7N3wTyH/JffQtLClYpk/ZT5Cg2Jc7r5LXqpGqhzbWMXo/AMiIDGxWONrMmHKf6WgKhff0vJ0H2eqZ6ZIJLohDsxVifqP6S6tysMuF7znHV4pPmOf1Zmn6uRjPeoYBlaug16tORrGuiN4gq1q/NtiPImjXcbxdycG68+hFViSA3yopVfZb7k95zeknjTJVc8YswTnZzO2AxeZp/VUdPWuxb2hxy2QqB1/n3aQAUbmUVz0zHUmeFK5WPkl77pDFvluZJenvnua3rRR+6KBnJib9sa7qLvQ7jHHayELZsebnXd4XhGyzbTQSoOW7oN3jzcOZIigz6etoiKvjKY1XlDdiO7Oyd/EBJyGQQqMoS/AZhS37s4Xr33GcI62XSS6n3zVMoByUt2ZZMpW6C9ose5BGu63Kn3dZgH6/QupD0hGq9FaZEIBZoGYoPqrjVjPGhpZYoldfT5LzIHo25z4W5ZkkFeqzggmjt4JT/+FbW3LhSkCTCj4PkYe60IWkyTNQu6e5Ylc/zC/bcmE3EPFu3RKXX6yYKzXjA54j8eOBozdbPAhP/NiipJKKUP+GDnZFf9vwCtJgYt8axRmGOPsmlR7zQhsnVoa+ysyp5gaHgSmUOQAweqSGEOo6OneAdntLqRgV13LMt+9wx67U1p5SS8jAVTKYOo+DYEdMsjekB6R
 3JoIHKdh
 XRGB4Goi8gc8GRX72LQWI0TL5NGcvgws9enqO+q1tKZ47KwwzFHfwaL7/riaXZH7wh3hz3EaLfdccnnYLuENmSNOGJz0lOnVEBwTJjoN1nIPRLGyWrjla3iXwxXtuJ0AE8g92DD+WEOWsaSdb7+wG+URnJDD/4O4Zsl13AuVPhSrLluUSwdJlNNzpRrpZvRUYeYVT6eNI+XnezhzMsc7i/UKd3nAcdQnJUm3k3Pmo47fInh2vpcKr4bgJ9HJq0oJ4t/KiEDajJXldPZf7ptFTkn+pvDra/lPQfGpub4UbsrFm/Ku7Welc/2n+sqIo1xTlwB2JkGSjkOaBrWDbRiTzA5Ts1384PbTmQc6lSDUf1Pm62pgw7mn8vpMeU9QpqYDwjM7TmOfOQjptb9ApxnzpJhsp3t01xrW2vMESCdSCo/KoY+ILGk7zX5Cbw5sGlAjJyQje0uBNbQxT9tB2bwWzXkLPEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 6, 2026 at 9:58=E2=80=AFPM YoungJun Park <youngjun.park@lge.com=
> wrote:
>
> On Fri, Mar 06, 2026 at 07:50:36PM +0800, Hui Zhu wrote:
> > From: Hui Zhu <zhuhui@kylinos.cn>
>
> Hello Hui Zhu! :)
> >
> > swap_cluster_alloc_table() assumes that the caller holds the following
> > locks:
> > ci->lock
> > percpu_swap_cluster.lock
> > si->global_cluster_lock (required for non-SWP_SOLIDSTATE devices)
> >
> > There are five call paths leading to swap_cluster_alloc_table():
> > swap_alloc_hibernation_slot->cluster_alloc_swap_entry
> > ->alloc_swap_scan_list->isolate_lock_cluster->swap_cluster_alloc_table
> >
> > swap_alloc_slow->cluster_alloc_swap_entry->alloc_swap_scan_list
> > ->isolate_lock_cluster->swap_cluster_alloc_table
> >
> > swap_alloc_hibernation_slot->cluster_alloc_swap_entry
> > ->swap_reclaim_full_clusters->isolate_lock_cluster
> > ->swap_cluster_alloc_table
> >
> > swap_alloc_slow->cluster_alloc_swap_entry->swap_reclaim_full_clusters
> > ->isolate_lock_cluster->swap_cluster_alloc_table
> >
> > swap_reclaim_work->swap_reclaim_full_clusters->isolate_lock_cluster
> > ->swap_cluster_alloc_table
>
> Can isolate_lock_cluster() actually invoke swap_cluster_alloc_table()
> on a full cluster? My understanding is that full clusters already have
> a swap_table allocated, and swap_cluster_alloc_table() is only called
> for free clusters that need a new allocation. If isolate_lock_cluster()
> checks !cluster_table_is_alloced() before calling swap_cluster_alloc_tabl=
e(),
> wouldn't the full-cluster reclaim path skip that allocation entirely?

Hi all, thanks for the patch and review. That's correct, I don't think
a full cluster will need allocation.

Maybe we can add a VM_WARN to check if `list =3D=3D si->free_cluster` when
cluster_table_is_alloced is true? Just in case and make things easier
to understand.

BTW there is already a comment in swap_cluster_alloc_table: "Only
cluster isolation from the allocator does table allocation." That
comment can be extended if that's not detailed enough.

