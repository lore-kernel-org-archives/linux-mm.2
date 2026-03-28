Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A874110F3DED
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 17:30:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBDC96B008C; Sat, 28 Mar 2026 13:30:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6EC86B009E; Sat, 28 Mar 2026 13:30:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAB966B009F; Sat, 28 Mar 2026 13:30:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C8D1C6B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 13:30:50 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6D8C31393BD
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:30:50 +0000 (UTC)
X-FDA: 84596161860.28.FAF0D31
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7FAF44000D
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:30:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mBBzlKkE;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774719048; a=rsa-sha256;
	cv=none;
	b=gIIw62MuFFppZ0QOl/p32LkmqqYtdkQd96gXRf+cDYznx9jLd0909680VLLsmePGIgfxdR
	6x+QufO/AZkFaYV8HRhBtRmHuCPhz5iMH3wfEnI3ISQx1VHnipV930J29Cu6Qes5IFMLhh
	IDKBzCB4amP+CsiRHrnEK6PTpuol/Ps=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774719048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U6wpH0E/1pqdSBKibo+awwee7+Dq2N19KcOYS5YYS6Q=;
	b=WofZ8PyjdDQmEFsCwNT7RBIlSF3pbcFZikDwhTvzNyybTpctdl3nfSidpv3A6n5g6RLckt
	vsF2Lqz9T7OqSVovz5CSe+gvsnhqo6xaor0gf1utytrtQHWqlQ7C2DhVqBbkMSMfNU1OMT
	wVK1EvKWHc1MKTlMuRa87bV6sYByZFY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mBBzlKkE;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8297e0b27e5so1709542b3a.1
        for <linux-mm@kvack.org>; Sat, 28 Mar 2026 10:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774719047; x=1775323847; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=U6wpH0E/1pqdSBKibo+awwee7+Dq2N19KcOYS5YYS6Q=;
        b=mBBzlKkE8Je+XZ1FRnyFGiHwfiZFTMSjJWsN+5wQ2GKaa7Aui+PLBYydyGFXP7QT4t
         0a77V0h4Wzv6wgKHb3zEdIz7KHRzNPF91KF3d/JQ4McV3yOuUqQ+VrsJ14eXj3HErvsc
         AjRXoqCi/WNvFkfCfSnWGX1/dflYBVLmVLR5ccpCS4sBR5B/cL+PuZMbhqriFoUdNaIz
         gvMLqqHhyOTAUkBfn7dktRFldaB/d35zzXrR/EhDTblTNlZDrAIyhDfpi4YL3+kQgVOz
         8geQ914sz8JdwBeg0xxFJ2TMeV1WELsKR6hgPgX1AiFkcPaiD24Z/xaV39y4bUJa/iAQ
         +7dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774719047; x=1775323847;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U6wpH0E/1pqdSBKibo+awwee7+Dq2N19KcOYS5YYS6Q=;
        b=BeTsuHgrcYzghoRDDUyWJKtUQy3haQlzfF1DoIrgIYO3nBb4xRs/UZiuqrJzjIeFzd
         OPl/4ZIKRiJ+kbN1XidZtEUSZzpI+VmF16oeXxoH3CwSfBC7K4G/KndfXD4smqUMOsHO
         Eq7MR6UeFci6z51Eu332p01G8SXhyN05PJCS7KaL01xVyuxxSd7oZqCR+FYWeTTNgvlK
         +AQDNTFfX9NBAVRzKLA4hASHKmT0NX3FAh7z7CL+V1FcSR75DK2QMx4TwtGEnfXb8NV1
         yYNHxfOx+ewfJjaaYWq2u2jRqq9H4CbXoKUxn6qNfmE8p8RQ7BHqKUcNgWqz6v67DiCm
         RGxw==
X-Gm-Message-State: AOJu0Yx9kemPqKvV+TbARJgsEft+OA5lU4ucYJT1o7VscDfODUXYmu5Y
	HyQWEJ9vf0IyilU1D24xcFs13Boi3oPYT19dk9GXW9qq4bWpzBun5Sj2o7D97LbPgUeXuw==
X-Gm-Gg: ATEYQzx4KVQRMtImyvaEtHMFWYKYcvLepD8SsiJckQfoYqfgoqbGB3wG5zAcFTHcfXS
	9f/d+nbcfMf/BOlrLQiOef5pKOz83QGl0V9hSPGFl/l0P6atnsxJyUyaXvD+g014mUwDj7bcoVJ
	GabbyskH9arOMu4cDsDK8ayLFN/sRq4v9N6E4+Erh8QOTj3UrNsZ/jGbe5IsPlaGdigj38HsTY6
	8ooNeXhejx2IKWnSpsXMrQn51BKO3lRnB8GfViQkkghKmoRTXEfurvYKvr7qzoyVDnfbHpXHtmE
	cu/0jtbDt9ygXXLDf6sH21BMp+lx1kC7hGuMTqpoL5e92tQjDE7HyAL/OxQwB7+sv7xU8S1SECZ
	GPe8KNEWIPR/Mif3mfAAvGtKtrS0Y6/x1et9DhAOHBrqn7O5nbDAE3IVCkHPsC1km6Wg+7hf3Xt
	W3j6vh+fGFiv3WB3tMBfivTslIEIQ6tl3j4PoZfhCq3uxqRNE6JCEbYwwXAP8=
X-Received: by 2002:a05:6a00:1c91:b0:82a:ea3:c172 with SMTP id d2e1a72fcca58-82c960a3070mr6069835b3a.46.1774719046762;
        Sat, 28 Mar 2026 10:30:46 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82ca85ef1bfsm2388218b3a.44.2026.03.28.10.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2026 10:30:45 -0700 (PDT)
Date: Sun, 29 Mar 2026 01:30:38 +0800
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Eric Naim <dnaim@cachyos.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	David Stevens <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] mm/mglru: improve reclaim loop and dirty folio
 handling
Message-ID: <acgNCzRDVmSbXrOE@KASONG-MC4>
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
 <7ab8edd7-381f-4db2-9560-b58718669208@cachyos.org>
 <CAMgjq7CuEYAzZFmS2T7N6je6VHffVkH1hh64YUuShFBnrJJvqA@mail.gmail.com>
 <85b4be3c-09a3-4a28-924d-71a20db3fd62@cachyos.org>
 <CAMgjq7AQeP8maeMWNun=60oyq_KDu18MwXfGEyK4bwj_k92NgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7AQeP8maeMWNun=60oyq_KDu18MwXfGEyK4bwj_k92NgQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7FAF44000D
X-Stat-Signature: 9edhrq8b5c7cm5pen5qn5qm3px53u8md
X-HE-Tag: 1774719048-133072
X-HE-Meta: U2FsdGVkX19ws1EDgQqAEVfd5H9cUyAoiXIUoWIR1kc1wQdZjV1P1LI+BNMFu81bhNpqRVr+Qd4uB7yq7N9CWHBhn/2KlrbzQ1QqVvT4Xy9Kx7pLc+byW9uBalmw1wqFTPLr02BSzSmC3YkKrLicwxf+SaIaZNKvH4cN5jW9N+wVdPF7osQAVTAiqUE0PteoQ4TMdp3nrWhkJyNoBOyGJKX3JqfyVpCeYG7I8XR45n4U9hgVaccLP83Vc1ZAlKXs+mM6Z64MdyL+PqPQYCstlzApjk7b7w69/KHxNMXPpd3RW3V0xyDxdlv/7nf8uP9LjJgz9ikutBafcX7BfL6KBDPxB1uPidSHFkDLmFG49n6ZFFmUzTPuYjoe8s/pSq1gGT5bO5qunDu2uhIThFLK0fzyuiG+c5/pq9gqUJj9unbFWMoIYT6W2Al65lZ3/AorWiYacVbbJ/ZJhsBXZtm5VoiasfaOS/MtmHB2iBq5F3X0dHE8qaH6XBwE5ju/aH9cTnMWxEfsWOWfF1MCHpXO9fKtxZZN99nrLB6hNnBR/YB43TvQncZZ3IaaSLRV6tLTn0kog/hrNriyIGplXCWL88/tejHnSWuh9GT3AQrPnVrZgyWnfnqgPiW9EJ6b8xA2cM6YoAfjyqyS6Uy76L4C/iDCix1m75k6FtCTLIgYrVfGuUN77aBbbzWvjLLCqjiBogNyVTpby2lLg216GrFAOaFoAW9xRDzJQjKYb0/zveKUUinVm41raxuWh3x+QL4piRFZTEWtwxoFqooBuUfqYAmeEcahU9oqnDKHOWtdCs3ZVyCduEbKnuS3amb89gRRqQU+WtRT2gKIEIHpAON/688AB8/NIy75+FtDSYlNtAEoZfHOBaxg1X1Wzoyw9nSpYw0nPeIV7yn0PQHVhXZJFItiX4NaemEtC5Gn/QH6IlSk+2zubLK1Oa09QkIGzIdlllgdyim3kVH0MhgU217
 xdXrkfjI
 GF+ZLbz2bEwEUTY211psx2Suuip5sLsh4RSqtiLU9FudJ3lGBuKwGCUObPLHIIRmtlC5zDmIHsdLyxDs0jFbLAAGbykL4ZFFfKYrXO0HUvsEZqoNGxiXsIumwYgpXXAp0AedsjCiJye+Z8pU6loFj/tM/wq0XJlF+jfz0oEcDy+CZaRQQzTfhttO9d0Ajqm4Avgfnbv241JPfGLTDz0/cV5Nmq9L+Q4GaAv6LqlNivfVCNlRn0Lwwh0OB1pmLZY8epY9nHZ+JtHyrg35xncedGgU0/rklrMKQKi8GOvULWiawLcmoBAikAfx5TEZsueBYK4mUDNWjRLVLq0hKdvEWta3QO0SKIS1r1WbVPYDVcRUFMNcbgCQJwEG6Y6LlIFq1W0XDyFM3cY8iCYb8MuTy8wCICz6c7bKTOo4agoLkx6iu0V1oRz7kAufVEkr+YIorXyS1Bkf+C7eY+02AHLiKUJW2ka41Q+Y+S0lRzMKn0alBHLESrXA6molfNQs9YptAodm+lQu54pCEcVdlUeUnsHHHJFXIKhSsJKxHaW1W3Oc/XeZaGF21oMFPxBPHixLYGYRQxd231683cNxwvDDcTp0ceA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 05:47:41PM +0800, Kairui Song wrote:
> On Wed, Mar 25, 2026 at 5:27 PM Eric Naim <dnaim@cachyos.org> wrote:
> >
> > On 3/25/26 1:47 PM, Kairui Song wrote:
> > > On Wed, Mar 25, 2026 at 1:04 PM Eric Naim <dnaim@cachyos.org> wrote:
> > >>
> > >> Hi Kairui,
> > >>
> > >> On 3/18/26 3:08 AM, Kairui Song via B4 Relay wrote:
> > >>> This series cleans up and slightly improves MGLRU's reclaim loop and
> > >>> dirty flush logic. As a result, we can see an up to ~50% reduce of file
> > >>> faults and 30% increase in MongoDB throughput with YCSB and no swap
> > >>> involved, other common benchmarks have no regression, and LOC is
> > >>> reduced, with less unexpected OOM in our production environment.
> > >>>
> > >
> > > ...
> > >
> > >>
> > >> I applied this patch set to 7.0-rc5 and noticed the system locking up when performing the below test.
> > >>
> > >> fallocate -l 5G 5G
> > >> while true; do tail /dev/zero; done
> > >> while true; do time cat 5G > /dev/null; sleep $(($(cat /sys/kernel/mm/lru_gen/min_ttl_ms)/1000+1)); done
> > >>
> > >> After reading [1], I suspect that this was because the system was using zram as swap, and yes if zram is disabled then the lock up does not occur.
> > >
> > > Hi Eric,
> > >
> > > Thanks for the report, I was about to send V2 but noticing your report
> > > I'll try to reproduce your issue first.
> > >
> > > So far I didn't notice any regression, is this an issue caused by this
> > > patch or is it an existing issue? I don't have any context about how
> > > you are doing the test. BTW the calculation in patch "mm/mglru:
> > > restructure the reclaim loop" needs to have a lowest bar
> > > "max(nr_to_scan, SWAP_CLUSTER_MAX)" for small machines, not sure if
> > > related but will add to V2.
> > >
> >
> > As of writing this, I got some new information that makes this a bit more confusing. The kernel that doesn't have the issue was patched with [1] as a means of protecting the working set (similar to lru_gen_min_ttl_ms).
> >
> > So this time on an unpatched kernel, the system still freezes but quickly recovers itself after about 2 seconds. With this patchset applied, the system freezes but it doesn't quickly recover (if at all).
> >
> > Curiously, I had the user test again but this time with lru_gen_min_ttl_ms = 100. With this set, the system doesn't freeze at all with or without this patchset.
> 
> Ah thanks, that makes sense now, the downstream patch you mentioned
> limits the reclaim of file pages to avoid thrashing, and your test
> cases exhaust the memory on purpose which forces the kernel to reclaim
> all reclaimable folios including page cache.
> 
> A thrashing page cache causes desktop hangs easily, using TTL is an
> effective way to avoid thrashing and trigger OOM early. That's why the
> problem is gone with lru_gen_min_ttl_ms = 100 or le9.
> 
> > > And about the test you posted:
> > > while true; do tail /dev/zero; done
> > >
> > > I believe this will just consume all memory with zero pages and then
> > > get OOM killed, that's exactly what the test is meant to do. By lockup
> > > I'm not sure you mean since you mentioned OOM kill. The system
> > > actually hung or the desktop is dead?
> >
> > The system actually hung. They needed a hard reset to recover the system. (pure speculation: given a few minutes the system would likely recover itself as this seems to be a common scenario)
> 
> Yeah I believe so.
> 
> Thrashing prevention is why MGLRU's TTL is introduced, so I do suggest
> using that. It can be further improved too.
> 
> Will keep that in mind and try to make some test cases to cover your
> case too and make some adjustments.
> 
> BTW how does the kernel behave with MGLRU disabled for your case?

Hi all,

I tested it multiple times on my Fedora, comparing MGLRU to classic LRU
(using v2 of this series also also includes some minor improvements).

I modified the reproduce a bit just to test the OOM behavior:

- Running following command in console A:
fallocate -l 5G 5G
while true; do time cat 5G > /dev/null; done

- Then run following command in console B:
while true; do tail /dev/zero; done

The console A output is below:

With MGLRU disabled:
...
real    0m4.925s user    0m0.016s sys     0m4.904s # Under pressure
real    0m5.544s user    0m0.015s sys     0m5.521s
real    0m5.444s user    0m0.012s sys     0m5.425s
real    0m7.607s user    0m0.016s sys     0m7.561s
real    0m7.268s user    0m0.017s sys     0m7.240s
real    0m6.686s user    0m0.016s sys     0m6.656s
real    0m9.919s user    0m0.014s sys     0m9.831s # <- OOM in B triggers
real    0m4.559s user    0m0.012s sys     0m4.539s
real    0m1.381s user    0m0.009s sys     0m1.362s
real    0m11.816s user    0m0.010s sys     0m11.795s
real    0m6.797s user    0m0.021s sys     0m6.753s
real    0m0.944s user    0m0.013s sys     0m0.931s # <- OOM kill in B ends
real    0m0.285s user    0m0.013s sys     0m0.272s

MGLRU enabled, before this series:
...
real    0m0.355s user    0m0.009s sys     0m0.346s # Under pressure
real    0m0.352s user    0m0.008s sys     0m0.344s
real    0m0.549s user    0m0.014s sys     0m0.535s
real    0m0.628s user    0m0.009s sys     0m0.619s
real    0m0.651s user    0m0.009s sys     0m0.642s
real    0m5.294s user    0m0.010s sys     0m5.280s # <- OOM in B triggers
real    0m1.041s user    0m0.014s sys     0m1.026s
real    0m0.837s user    0m0.011s sys     0m0.826s
real    0m2.450s user    0m0.013s sys     0m2.435s
real    0m2.499s user    0m0.012s sys     0m2.485s
real    0m1.857s user    0m0.015s sys     0m1.841s
real    0m0.512s user    0m0.015s sys     0m0.497s
real    0m0.418s user    0m0.011s sys     0m0.407s # <- OOM kill in B ends
real    0m0.282s user    0m0.010s sys     0m0.272s

MGLRU enabled, after this series:
...
real    0m0.280s user    0m0.015s sys     0m0.265s # Under pressure
real    0m0.283s user    0m0.010s sys     0m0.273s
real    0m0.278s user    0m0.012s sys     0m0.266s
real    0m0.315s user    0m0.018s sys     0m0.297s
real    0m0.679s user    0m0.014s sys     0m0.663s
real    0m0.716s user    0m0.011s sys     0m0.705s
real    0m0.657s user    0m0.009s sys     0m0.648s
real    0m6.615s user    0m0.007s sys     0m6.453s # <- OOM in B triggers
real    0m1.244s user    0m0.018s sys     0m1.226s
real    0m1.290s user    0m0.014s sys     0m1.276s
real    0m1.119s user    0m0.011s sys     0m1.108s
real    0m0.882s user    0m0.010s sys     0m0.872s
real    0m0.855s user    0m0.007s sys     0m0.848s
real    0m0.933s user    0m0.005s sys     0m0.928s
real    0m0.833s user    0m0.009s sys     0m0.823s
real    0m0.279s user    0m0.012s sys     0m0.267s # <- OOM killed in B
real    0m0.273s user    0m0.010s sys     0m0.263s

It seems with MGLRU enabled, both performance and OOM jitter
seem better.

As for this series, it now has no significant effect or slightly
changed the jitter pattern, which I can't say is better or worse.
The peak latency seems slightly higher, but the system seems to
recover faster. Or maybe that's just noise.

The OOM behavior is not really perfect in any case, but with
MGLRU's TTL enabled, I got confirmation that the jitter is
gone completely (only a few frames).

