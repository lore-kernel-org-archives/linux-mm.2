Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D75D1C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 21:38:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E9E36B0088; Thu,  3 Sep 2026 17:38:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 699D56B008A; Thu,  3 Sep 2026 17:38:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 561606B008C; Thu,  3 Sep 2026 17:38:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 115746B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 17:38:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C6F04066C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 21:38:00 +0000 (UTC)
X-FDA: 85173763920.19.4ED636E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 61D4D8000B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 21:37:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B8KxvLlq;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788471478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VXfExNiCEICkaycvhoRHapQKaCEaUNeca5cgqczZcwY=;
	b=eL9SNv9sHOa6XoyB0jos1vKNJVKsKgaZohwbJ0N5FJJQacS8fMdactTuOh/fPsxVdiqQsm
	b44Qxu+AyYpbeC2TN5x3QIa3jbWNfsHWvjUUjkbK/W9aGClHZzOKrrvYeZoqSux+8xCy/L
	+FbB+3F5XgXxGAcYKYPiTynd3I6QRJU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788471478;
	b=CYdY4awzCPCUgEYxj9kMLMKAAdd2KN+5/Uj3ByvRw9yMxclZ01LQKB8SxxkuhtYFwisWUy
	jebd1N/TzI+CcVTr3ASdlxfxr2vyW/lZsWjWw2QjVU+nVhhtbLKBjN1mrH6heDTM0t1tVs
	DH+sGim3L4rLozWlTDEB1iu55W4G4gg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B8KxvLlq;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F3FE43DEC
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 21:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1378F1F00A3D
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 21:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788471477;
	bh=VXfExNiCEICkaycvhoRHapQKaCEaUNeca5cgqczZcwY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=B8KxvLlqeoNTdlLVRctwOTiqZO2iTCY6hKK7smhp2VTh5CS9cFt5WUfrHzCZJINGR
	 Rj8MoI/qzEIT1vxt5v6EO7GgPFnVci7CY8txWSNaL8VMwrBN/tZlXH3ZN70HOt+H4z
	 yUMr2SfcDHrHzLqhG26wwYNSRgzDF9XV/Gce3MiWcgt/YV8Q00JottqWIQNmtFzQo8
	 QTKaNHv/MXLsUU5uQt/7b0rEzptspm1vGPZJK7BwAWyRM3Q8HkF3n4lpbAYTDsM1kp
	 UDGURBj3h4Q9kj/pU1bguMlJ9se8KlJeepJKxN9jn4H9tej0qpmH4bTk5pblm4s+li
	 UaKV25MZt3NLA==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92e99ef0902so27917185a.2
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 14:37:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwaE6na2aWsxRuq7O2TVCoE+sckEvD4TRLLuMWuKfpwNNdLzdS4/hAKAJrGa2I6W2ypwpQ9LqtG1Q==@kvack.org
X-Gm-Message-State: AFuF++kZTNFc1Zcq4HlI3tdkV5wis4yCaBrv0UIXtatpQP8PCaU3V8QK
	PaQWD5UX19lSzNNoXY5Bsnxj9kNZLoglVgiO2UGjJerOBcBO/TdKah4tPAyDyvBh+VqcFCEjbK6
	IfIYEjfxKvwAZbgx7jtFalAQsJuNI3dQ=
X-Received: by 2002:a05:620a:43ef:b0:939:7aa2:8268 with SMTP id
 af79cd13be357-93980435391mr140170785a.29.1788471476428; Thu, 03 Sep 2026
 14:37:56 -0700 (PDT)
MIME-Version: 1.0
References: <apcVhWzEwkwHYjB1@KASONG-MC4> <20260901220430.79810-1-baohua@kernel.org>
 <SJ1PR11MB61051CC2791B67C97BEB2D4B8CB72@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <CAGsJ_4yRJnr4xXdokVHu85b7XPe0p6rZ+Lzv4sE_gCWdOF4YAw@mail.gmail.com> <SJ1PR11MB610566E5520AFF142D8C45168CB62@SJ1PR11MB6105.namprd11.prod.outlook.com>
In-Reply-To: <SJ1PR11MB610566E5520AFF142D8C45168CB62@SJ1PR11MB6105.namprd11.prod.outlook.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 4 Sep 2026 05:37:45 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zSP7tKuaFHXH98dKKniGjauy7RSEDPnDR-ppCkVXhsqw@mail.gmail.com>
X-Gm-Features: AcwNN1XTaRurTpdI6Qpk2m15sLshhyfTOeFG76mwFcGFZVZgAtw6J9Lp1lqozEw
Message-ID: <CAGsJ_4zSP7tKuaFHXH98dKKniGjauy7RSEDPnDR-ppCkVXhsqw@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/mglru: dynamically protect readahead fault folios
 under refault pressure
To: "Ababneh, Ehab" <ehab.ababneh@intel.com>
Cc: "ryncsn@gmail.com" <ryncsn@gmail.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "kasong@tencent.com" <kasong@tencent.com>, 
	"lance.yang@linux.dev" <lance.yang@linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"qi.zheng@linux.dev" <qi.zheng@linux.dev>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"weixugc@google.com" <weixugc@google.com>, "yuanchu@google.com" <yuanchu@google.com>, 
	"yuzhao@google.com" <yuzhao@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hhzhbtfmbf4wzwxn5hyxy5zmxu9eqju3
X-Rspamd-Queue-Id: 61D4D8000B
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788471478-104150
X-HE-Meta: U2FsdGVkX1/9kijePilcjgGxy52a5Q8ey/YENxMZyOPphzkw3bHkzEtNtqLylt3fjtKlH+b6G+FhizhoZvUgSIW02RYdRW2JwwyS6yRVYRxBA9FsadVMQdFSvOcTel0F+BOULQU0pyVCM/A/vSI6RA3tJNJ6tKjkmyYLC8yg2wzNtEqHY5GMXYdBYtzeq3+tnSdrDer4s8x4asZHVNjT1X8HSfVRvpK2Yy0gpCF8F1/kZPT7hsnKdBJpEu2XhiC78s6bPWMJctNpz1kyaD9PSM6ukigCBXIP3L+cxvLFrNeO+ACQZPAIutaUg7diJDzRDICDKJlqNsrfpGMrU6fu7LBqb7JwuO2lqNi8e46L3M7KK3TW9eTyMmJ/Eym7IcGoIIHqHBDgoylrXb1RkCY4l7AcuCdI0RKTxgsHfrSVYncLpdnLTHhuxqyrb9E+jF0QEWHYjM4R6JLK0jk80twgbbH6ieMrt4DWyq+HZvmwkbHZG6bIW7X025c5UpXh7YmMfIYjwGbnayvPgHtG4OubhEY28g1m2cBhAgPtD722vx2BBR2y2mHkQtI/mQAIoVtVU6M/iWHhMPhfDnO78zHT0kNdPspuhwgzW1PdbOlqGHGlyffT8iwjJ24SfSEGI8sRor0sax0CX5DUH9TnilKrW4H+Nanv8qGlOM7GjuzkSTq/g7L1kM481KgIHmHEb4kzKkZLS/ZeS24uEPSW7a29GtEJKAB7sSS0i4ax2Q/pw0NhIGWrCeqahJPN519QMMx9bCMyV/Yg/iIGbzgEw4Y4dglfzmJzbX+h/sWooYHsqiDyPO8lEphG91Wvz9PmVdLMeUPKVvBqV+ZVeFRVuQx2EZ2VlI5ZPAUqjSawAEaV8Er5aD67SflQs1g4N0YKVTjRTXJirJVBVodMY6pbzdkFVwxSMcHEUq/UCA87AijmbR+haXcGwFnCRMpXEyfjrp9Fgpu4nDOsOgT4LC03zfc
 p0iEqN0v
 9rGTmvl1coNoLz14vcinQUbWNBDsDZDa14GU2OUGKYvXfmmayZqrpOiQsDg5XxZvKTw/VI1m/weLaLVM0qne7zFmtL0AkD33nJUYIXfcVyvnLFv6J9FFT1qtyOgGzm+9CwqAc4neLY/eV8v415PD+ntZAbt66cBIKHKklwEG/nLIasvBmUTKZifhGT+yK9UaGucf3a1ClA2JHjJFVtJ5hKCEKcFBWm/3O6PxZ9WgbPVNEzpEWsA4np1LdscNdzi2HTtNQ+hlohY7hiWg/MlG43rTGOEFhgrPk9z5FqCsnsqpdRdgl6UXned93imZq8OjcSxwLxXex6y8JXk6LuY0vCXXjxxtdrsQLsORHaa+ztO2gv1QV0iVIpQmXtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 4, 2026 at 3:46=E2=80=AFAM Ababneh, Ehab <ehab.ababneh@intel.co=
m> wrote:
[...]
> > > > I guess we could instead try to mitigate the cases where some
> > > > workloads are negatively affected while preserving the original
> > > > intention. Does the fix below address both of your cases, or is Eha=
b's case
> > actually different from Kairui's?
> > > > (The kernel-build test on my machine looks quite positive. It not
> > > > only preserves the original optimization, but even provides further
> > > > gains.)
> > > >
> > >
> > > I agree that reverting the commit that caused the regression is not
> > > the optimal path. I expect there are many workloads and scenarios tha=
t
> > > benefit from the behavior introduced by that commit, so reverting it
> > > could unnecessarily regress those workloads.
> > >
> > > I will run the Cassandra benchmark with Kairui's MGLRU-FG patches to
> > > see whether they address the issue I am seeing. I will send the
> > > results when they are ready.
> > >
> >
> > Thanks very much, Ehab. Could you please also run my proposed quick fix=
:
> >
> > https://lore.kernel.org/linux-mm/20260901220430.79810-1-
> > baohua@kernel.org/
> >
>
> Hi Barry,
>
> Thanks for sending the suggested fix. I tested it with the Cassandra benc=
hmark,
> and the results look promising. Across the runs, throughput was approxima=
tely
> 49.4K to 50.3K ops/s, averaging about 50.0K ops/s, while the 99th-percent=
ile
> latency remained around 7.0 to 7.1 ms. This represents an improvement ove=
r
> the baseline of approximately 43.98K ops/s and 9.025 ms p99 latency.
>

I am happy to see it is much better, but it still doesn't seem as good
as it was at the very beginning?

- with commit 6cbdd9726fb5 ("mm/mglru: use folio_mark_accessed to
  replace folio_set_active"):
  p99 ~9.2-9.5 ms, throughput ~41.8k-43.6k op/s
- with revert of commit 6cbdd9726fb5 ("mm/mglru: use folio_mark_accessed to
  replace folio_set_active"):
  p99 ~5.5-5.6 ms, throughput ~51.9k-53.1k op/s
- with this fix: p99 ~5.8 ms, throughput ~51.9k-52.7k op/s

> The underlying idea in both solutions is very similar: A credit-based
> system protects file folios when readahead proves useful. In my version,
> I further tuned credit accounting and used per-CPU batching to
> reduce atomic contention on multicore systems.
>

Your benchmark seems quite likely to access readahead folios.
Let me dig into your patch a bit deeper and see if we can find
a combination of the two approaches.
BTW, does Kairui's MGLRU-FG bring your benchmark back to the
performance you had at the very beginning?

Best Regards
Barry

