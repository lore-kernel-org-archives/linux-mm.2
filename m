Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CAE2C79F87
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 12:31:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD14B6B013B; Mon,  5 Jan 2026 07:31:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA9446B013E; Mon,  5 Jan 2026 07:31:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD6066B013F; Mon,  5 Jan 2026 07:31:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AE2306B013B
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 07:31:01 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4A0BD1A2541
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:31:01 +0000 (UTC)
X-FDA: 84297844722.29.F888D10
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id 50E44100013
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:30:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O0T4Ylai;
	spf=pass (imf05.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767616259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zCWMOYN02QpBDQ3to6O345gp9Yx6Y45Zca158HmgYQU=;
	b=QV3wwKhfA5+S3qF7uphqQFB7rwrG43VJYKx72/fB+H6/u7MWe/Nb/ZYAwbwr7tHToXrZjo
	Logg1oPbdDuG5gnqW7oLYkb07ksk7LhqJ2aStRkgkUSAv/exp29d13RvDsp0Zsc3YGmijx
	exiADoxWiPebpE8WKiKcq6jhf4vWfAs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O0T4Ylai;
	spf=pass (imf05.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767616259; a=rsa-sha256;
	cv=none;
	b=3lk0yzKuSh4U+ItrAp1Kkos/R8T8dhShxU5WDp6omUtKJPdEUq7mu1kkJbApm0b5bAe+JJ
	LyZCSdHeIlXq9yuuHhdUrOgZuH1LBInrnlEUoMIuLcTBiuhJvX0qUk++cvyN51JQXidvD8
	xwWaoo30o219sIlWmx8QuzroT138YRE=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-34c21417781so14771476a91.3
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 04:30:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767616258; x=1768221058; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zCWMOYN02QpBDQ3to6O345gp9Yx6Y45Zca158HmgYQU=;
        b=O0T4Ylai+V0DWP8wUWHLDdbLxhqAXI6JCzHn5zsSlB5kf7x2etdF1bJaId4F4OBfsh
         MC8FA/suLkvIIE2G44YPrH3GnkWozmf7mrSYkSnKF/RFjK2eIvUkuXht0Dm1Ig37w1av
         p4czjUHzIk+l0qKzmJUtZ+h9bOqzg74vG68gxVc5yQpeNUS6bcRnh5f6HsoK8iZJXkB7
         6gbi76yozLUoT1xQK8BwHj8H1Mpnu/wot0iakhVFm4+RNQf7FThW1pq3Bl4wV8qlFFpd
         zASjB7kWW3JNYzMlEMVBn7niJRpJ319zmty6nzIpB3LIIUK24YweGvJwT0Yh4B4RCQPg
         4CQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767616258; x=1768221058;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zCWMOYN02QpBDQ3to6O345gp9Yx6Y45Zca158HmgYQU=;
        b=UQB45deLEH2SYOqjyjVUHf40J3d5/3e77FY8sOlPiF2+f0vxZJhRWdNfxEr1sT5VmS
         F62YmAW2KEM1Qd8p5wLxqTjWA+wvV/NZhHTZxcUnGBWDNi6LbjvUkmhbrNd4lvYaH1Z2
         rZk/zCBMXWQC6FYx5bsh+z440PGyjW6z9oiFBw/JqNupT+gKO4NVV55R1IWOzdmSQ4Rw
         ZmaTG2LyBdqtHvw8FfxRoHDWjm3iU/iqBFUW8cQv784s8IoPj9nMM+FRKxh0tnVLkc5b
         9hc0V5w81MlvYx6vRtM/axQIUibf7YPfrOei58CpG1RtzSpqEEk7UnQr6agUQVJO2RVU
         WT3A==
X-Forwarded-Encrypted: i=1; AJvYcCWGpvwSh+fyyftZLp53qlvPjM/pbdV3zVU3utIsy9BQwtSxZBS0WMat4FLQL1N/6i8OuUtYjWB+Ww==@kvack.org
X-Gm-Message-State: AOJu0YwcKMgM91TgxfNlE22/FSlaviuZc/gruOryf2mKE+lSxtRfCNpZ
	qdTcPjzC9mtjSBNFu15Bsm5jCxu8ji5Qv3r0NR/5FII9O9iB0Fsww9Xafddhq4jy
X-Gm-Gg: AY/fxX6yXBiDpToAjCoRkn05/kJrExRTGvFIFVRy3uOwoS1XUjFF0QcyfYNDOSgbYQF
	574bZTE40tkz140bnrWfm2NQ7uIYdfijGB9zDWAAjZapclxmqXORuOSM6u3OYceDGAWLSREfTPg
	B9kRd6wI0oQCI0/s3HL1fe62Rg8oIcEwp36U5ac7Gkv5F33APN6nFcljXqoiBRWFbUREBNLkIzM
	w++Sfxqjg+BG//1rA/f2InNJKWQH5QAjJhf6F0XPEfYmpRuqKrzVz446adv7R/zbJyYzT4oS5Ui
	lohaA7aiqTK+/g3gT2NwFq4d7meKmFC2LCrPCFviZEFMvHEpLK7NRXXdOdA2Py4kyfu6ofDkii4
	v6zANpJ9f+lkBIrF/zXGu9JMHFcBzIHfgFhpgaeTtgqwYqciUigH/0/jBWq4gmfo5l9aWQiksNP
	YVyKJMA1Ug8PPHRf9kRTT/8q8=
X-Google-Smtp-Source: AGHT+IFEx4eFq/GPPm0MzR5yjXwkMy832NpHYKUtp+HdxJhx6g05jsnDashjdiYnKLGufDJ09ME82g==
X-Received: by 2002:a17:90b:5245:b0:349:19a8:e00e with SMTP id 98e67ed59e1d1-34e921bc767mr39321331a91.31.1767616257915;
        Mon, 05 Jan 2026 04:30:57 -0800 (PST)
Received: from localhost.localdomain ([121.232.80.251])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f450e68fesm2722273a91.4.2026.01.05.04.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 04:30:57 -0800 (PST)
Date: Mon, 5 Jan 2026 20:30:46 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com, 
	baohua@kernel.org, richard.weiyang@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>, akpm@linux-foundation.org, 
	david@kernel.org
Subject: Re: [PATCH v3 5/6] mm: khugepaged: skip lazy-free folios at scanning
Message-ID: <tpowqsrlxwx6hu5ljry54wpt5lverarqeincc3jufrqhfjmwwy@uzs6q6gecubd>
References: <20260104054112.4541-1-yanglincheng@kylinos.cn>
 <20260104054112.4541-6-yanglincheng@kylinos.cn>
 <9c82ffaa-5f62-4110-80cc-00f0c46e90fb@linux.dev>
 <3lbptab7e2nhqilwnoccq6kxks2r55j3ffqtslt62o2qtgulk5@w4mwglb2kd75>
 <d3fd4546-3161-4d58-b018-31aca53b6b04@linux.dev>
 <CACZaFFNJO+-yZdDPdN-5rQLuJvT5cp2pbtqV13FHo9PeqtxARg@mail.gmail.com>
 <cf094519-82e1-4f11-b670-dacf89da22ef@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cf094519-82e1-4f11-b670-dacf89da22ef@linux.dev>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 50E44100013
X-Stat-Signature: sh7g5xtu1796ehmfoh7b8q9h9c9h6p8d
X-Rspam-User: 
X-HE-Tag: 1767616259-12501
X-HE-Meta: U2FsdGVkX1/WCgHdn+VVTOM1I9DzEfcJIIcCutzLGWGVIPRDxcWssCofiAKksunNkRTR18KO3AlkhkOV2LuiOf5i8LRzYBo7plRGL+aw0pcQiurCszqdFvp9S8Y6dXOgskbtcY/tj1LkadaPQapO/BvrysXhjIp45gxPjFUGv1JD6dGGVoPTFYnIe5iPLzem3FzXPnYJV7SjohMa6mBn08asbCX7HJ1GLzptoca9t0NvZ8mCO80ZVYJvSmkirsW3/1rPxX2eRNAEOSY3FnoJsIGv+3xehXXfIy+Y8StkvYbOFQg3jD4Xf3lQqlWprvrLh1qcUVSRlmTuPxKdVdyJfDBmhEJYCTq3FsHqVkA149WT/QEwmcwZ1Of8Oxovvw3yqq1Q2MqizojwAbBQsoKeeAmf63S8a/GPgjdVw0mz2zBVl7aV2DF2oENl2kJfA1V53OMZnjg+d5Y/36n68WDAhX/L663kqu39bD6Zl8qDyh25/TMeNa8dVW/9bSupF7nsPv8oE7URMqRAk9oYxVsME3NRy3piZVO9Mgk/fyAY7fpnhCyHiogTZfisLxTg6/o6GuppfaNfU6a9yl9EV4iJ1xaATbG+5r4XubwOblGZ0KZsrTUlTJJm92Td63C6XZm2KGBLEydHEwxmWfiYF2xMUaf6v36g0vUVkFcySn55jSBiA6kUfFaPIQjDuA9K6kMSaetwxRKl32oCnTZTRPineRsQpfuyVgd2SSVdbXYfrsLLqlpaUra7+Lz5JK3iIB9rW52Kxss23xvloNogu2Rj4aMdzsNhCy4gCWLh64FMa18aT37ofSex0OAOJEhkukopv+xvYUjbsPv6y1KT6CwbOpTsT7f+2pQKpkToTS/wMV6JnDVK6lLYHgTKYqRgm9HB9yzUCV4Ym1SJNy8Iqm6MNpyWEPxvk7Ca+Cp9abvDwdFgIaHRoAaHHB9RD6LbwN3s07rAAW3cshr+b+JuOWE
 zyo3/meE
 y2GHES+R1Ep1CpGLexOwDt9Wzsq2c/ox7MUEEGER4QrKa1qRNnJHfCwHx5liPuUmjC+TXl7qKY1O0RRgDOlTk5DCaRZmpD2EOK6YGMaX+Ub1w7SFFs/tYnZi5DwmFLPwMMAHc0gmRluuVmFMYBiE1j0VtF5AmTsTtyAvHwnLSTrN89ZCc12i6HRbxNnPV8wqsUsIjdJ2cUZfBvNHY+8tk0Zvva1KqnTM+NrhbpG3EtIP0kcMo4DrUfbiIItkm5z6g1m/9FRIef2UDhbJniojJOikFkkvMzMVS2S1IbjYNSf0pudD2EnOWYH5BLV+5AmJvMTPyUqmUlPmRJuaV4z2qRjXyyfIpEIsxo6OWY95Vwhz3h8rU6Ao6Jd4pcxzxsi74GxAt8tjX687By1JD3dsoQ18SW3aWiv9PxD3p22pw2H90jHLG+4trneWyUv3DGdcjxvaRtJUt/IC7bv2QsON8McK7RADsU+x+20RLy5Kcr5HxU8caO1huYpcj89LQB6PH1EmV0p/9DFKLNDm7DFtfmzvGlw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 11:35:58AM +0800, Lance Yang wrote:
>
>
> On 2026/1/5 11:12, Vernon Yang wrote:
> > On Mon, Jan 5, 2026 at 10:51 AM Lance Yang <lance.yang@linux.dev> wrote:
> > >
> > > On 2026/1/5 09:48, Vernon Yang wrote:
> > > > On Sun, Jan 04, 2026 at 08:10:17PM +0800, Lance Yang wrote:
> > > > >
> > > > >
> > > > > On 2026/1/4 13:41, Vernon Yang wrote:
> > > > > > For example, create three task: hot1 -> cold -> hot2. After all three
> > > > > > task are created, each allocate memory 128MB. the hot1/hot2 task
> > > > > > continuously access 128 MB memory, while the cold task only accesses
> > > > > > its memory briefly andthen call madvise(MADV_FREE). However, khugepaged
> > > > > > still prioritizes scanning the cold task and only scans the hot2 task
> > > > > > after completing the scan of the cold task.
> > > > > >
> > > > > > So if the user has explicitly informed us via MADV_FREE that this memory
> > > > > > will be freed, it is appropriate for khugepaged to skip it only, thereby
> > > > > > avoiding unnecessary scan and collapse operations to reducing CPU
> > > > > > wastage.
> > > > > >
> > > > > > Here are the performance test results:
> > > > > > (Throughput bigger is better, other smaller is better)
> > > > > >
> > > > > > Testing on x86_64 machine:
> > > > > >
> > > > > > | task hot2           | without patch | with patch    |  delta  |
> > > > > > |---------------------|---------------|---------------|---------|
> > > > > > | total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
> > > > > > | cycles per access   |  4.96         |  2.21         | -55.44% |
> > > > > > | Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
> > > > > > | dTLB-load-misses    |  284814532    |  69597236     | -75.56% |
> > > > > >
> > > > > > Testing on qemu-system-x86_64 -enable-kvm:
> > > > > >
> > > > > > | task hot2           | without patch | with patch    |  delta  |
> > > > > > |---------------------|---------------|---------------|---------|
> > > > > > | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
> > > > > > | cycles per access   |  7.29         |  2.07         | -71.60% |
> > > > > > | Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
> > > > > > | dTLB-load-misses    |  241600871    |  3216108      | -98.67% |
> > > > > >
> > > > > > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > > > > > ---
> > > > > >     include/trace/events/huge_memory.h | 1 +
> > > > > >     mm/khugepaged.c                    | 6 ++++++
> > > > > >     2 files changed, 7 insertions(+)
> > > > > >
> > > > > > diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> > > > > > index 01225dd27ad5..e99d5f71f2a4 100644
> > > > > > --- a/include/trace/events/huge_memory.h
> > > > > > +++ b/include/trace/events/huge_memory.h
> > > > > > @@ -25,6 +25,7 @@
> > > > > >      EM( SCAN_PAGE_LRU,              "page_not_in_lru")              \
> > > > > >      EM( SCAN_PAGE_LOCK,             "page_locked")                  \
> > > > > >      EM( SCAN_PAGE_ANON,             "page_not_anon")                \
> > > > > > +   EM( SCAN_PAGE_LAZYFREE,         "page_lazyfree")                \
> > > > > >      EM( SCAN_PAGE_COMPOUND,         "page_compound")                \
> > > > > >      EM( SCAN_ANY_PROCESS,           "no_process_for_page")          \
> > > > > >      EM( SCAN_VMA_NULL,              "vma_null")                     \
> > > > > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > > > > index 30786c706c4a..1ca034a5f653 100644
> > > > > > --- a/mm/khugepaged.c
> > > > > > +++ b/mm/khugepaged.c
> > > > > > @@ -45,6 +45,7 @@ enum scan_result {
> > > > > >      SCAN_PAGE_LRU,
> > > > > >      SCAN_PAGE_LOCK,
> > > > > >      SCAN_PAGE_ANON,
> > > > > > +   SCAN_PAGE_LAZYFREE,
> > > > > >      SCAN_PAGE_COMPOUND,
> > > > > >      SCAN_ANY_PROCESS,
> > > > > >      SCAN_VMA_NULL,
> > > > > > @@ -1337,6 +1338,11 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
> > > > > >              }
> > > > > >              folio = page_folio(page);
> > > > > > +           if (folio_is_lazyfree(folio)) {
> > > > > > +                   result = SCAN_PAGE_LAZYFREE;
> > > > > > +                   goto out_unmap;
> > > > > > +           }
> > > > >
> > > > > That's a bit tricky ... I don't think we need to handle MADV_FREE pages
> > > > > differently :)
> > > > >
> > > > > MADV_FREE pages are likely cold memory, but what if there are just
> > > > > a few MADV_FREE pages in a hot memory region? Skipping the entire
> > > > > region would be unfortunate ...
> > > >
> > > > If there are hot in lazyfree folios, the folio will be set as non-lazyfree
> > > > in the memory reclaim path, it is not skipped in the next scan in the
> > > > khugepaged.
> > > >
> > > > shrink_folio_list()
> > > >     try_to_unmap()
> > > >       folio_set_swapbacked()
> > > >
> > > > If there are no hot in lazyfree folios, continuing the collapse would
> > > > waste CPU and require a long wait (khugepaged_scan_sleep_millisecs).
> > > > Additionally, due to collapse hugepage become non-lazyfree, preventing
> > > > the rapid release of lazyfree folios in the memory reclaim path.
> > > >
> > > > So skipping lazy-free folios make sense here for us.
> > > >
> > > > If I missed something, please let me know, thank!
> > >
> > > I'm not saying lazyfree pages become hot :)
> > >
> > > If a PMD region has mostly hot pages but just a few lazyfree
> > > pages, we would skip the entire region. Those hot pages won't
> > > be collapsed.
> >
> > Same above, the lazyfree folios will be set as non-lazyfree
>
> Nop ...
>
> > in the memory reclaim path, it is not skipped in the next scan,
> > the PMD region will collapse :)
>
> Let me be more specific:
>
> Assume we have a PMD region (512 pages):
> - Pages 0-499: hot pages (frequently accessed, NOT lazyfree)
> - Pages 500-511: lazyfree pages (MADV_FREE'd and clean)
>
> This patch skips the entire region when it hits page 500. So pages
> 0-499 can't be collapsed, even though they are hot.
>
> I'm NOT saying lazyfree pages themselves become hot ;)
>
> As I mentioned earlier, even if we skip these pages now, after they
> are reclaimed they become pte_none. Then khugepaged will try to
> collapse them anyway (based on khugepaged_max_ptes_none). So
> skipping them just delays things, it does not really change the
> final result ...

I got it. Thank you for explain.
I refine the code, it can resolve this issue, as follows:

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 30786c706c4a..afea2e12394e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -45,6 +45,7 @@ enum scan_result {
 	SCAN_PAGE_LRU,
 	SCAN_PAGE_LOCK,
 	SCAN_PAGE_ANON,
+	SCAN_PAGE_LAZYFREE,
 	SCAN_PAGE_COMPOUND,
 	SCAN_ANY_PROCESS,
 	SCAN_VMA_NULL,
@@ -1256,6 +1257,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 	pte_t *pte, *_pte;
 	int result = SCAN_FAIL, referenced = 0;
 	int none_or_zero = 0, shared = 0;
+	int lazyfree = 0;
 	struct page *page = NULL;
 	struct folio *folio = NULL;
 	unsigned long addr;
@@ -1337,6 +1339,21 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 		}
 		folio = page_folio(page);

+		if (cc->is_khugepaged && !pte_dirty(pteval) &&
+		    folio_is_lazyfree(folio)) {
+			++lazyfree;
+
+			/*
+			 * Due to the lazyfree-folios is reclaimed become
+			 * pte_none, make sure it doesn't continue to be
+			 * collapsed when skip ahead.
+			 */
+			if ((lazyfree + none_or_zero) > khugepaged_max_ptes_none) {
+				result = SCAN_PAGE_LAZYFREE;
+				goto out_unmap;
+			}
+		}
+
 		if (!folio_test_anon(folio)) {
 			result = SCAN_PAGE_ANON;
 			goto out_unmap;


If it has anything bug or better idea, please let me know, thanks!
If no, I will send it in the next version.

--
Thanks,
Vernon

