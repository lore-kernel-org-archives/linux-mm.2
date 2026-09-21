Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67761C982FA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 23:27:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 719016B00A7; Mon, 21 Sep 2026 19:27:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C9EC6B00A9; Mon, 21 Sep 2026 19:27:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DFEF6B00AA; Mon, 21 Sep 2026 19:27:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 387A76B00A7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:27:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BC9FCA59AD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 23:27:08 +0000 (UTC)
X-FDA: 85239357336.01.521414E
Received: from mail-wm1-f99.google.com (mail-wm1-f99.google.com [209.85.128.99])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0AE7B40009
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 23:27:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=everpuredata.com header.s=google header.b=ZvwyW7lm;
	dmarc=pass (policy=reject) header.from=everpuredata.com;
	spf=pass (imf07.hostedemail.com: domain of tmenninger@everpuredata.com designates 209.85.128.99 as permitted sender) smtp.mailfrom=tmenninger@everpuredata.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790033226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=va/vFiItRvpug1hTbx6eo1iSM5BSyMyaF3MlvXV7MJM=;
	b=F4aIfRS9Eqt8QchrV2rRGJVY9kEoqp1WaUtpgdyYOwGM5vry3WP72kXCdT6LZhvkuXjplX
	L077yNnlGC4vX9tHxZjHOhGrms9a7DnLiWP86QEG22su4DMgJbfYD5qBdVFSufC0Zr6xEm
	bDXgcitXZ0R+D9QC+8ybksMpf4EW3C4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790033226;
	b=EEFbKoiNKvf9T7xs7CA7bXhvVcpr7xNDDgqBdEkrx50779N4zmW5ymgGOUc13AEOrhQl/A
	HpymBEXbn9zjDJj2U7sxbGFM+gHEhov3bAAPD0yC+r5hQ7AFwb6wKhHssS0lAJakzwghBt
	Msdx0+OlRNfFcwCTOfX7Cau7eHNhQdk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=everpuredata.com header.s=google header.b=ZvwyW7lm;
	dmarc=pass (policy=reject) header.from=everpuredata.com;
	spf=pass (imf07.hostedemail.com: domain of tmenninger@everpuredata.com designates 209.85.128.99 as permitted sender) smtp.mailfrom=tmenninger@everpuredata.com
Received: by mail-wm1-f99.google.com with SMTP id 5b1f17b1804b1-49d0b98d6d0so17879695e9.0
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=everpuredata.com; s=google; t=1790033224; x=1790638024; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=va/vFiItRvpug1hTbx6eo1iSM5BSyMyaF3MlvXV7MJM=;
        b=ZvwyW7lmuxgJ1/i9jcSi0eE2ILVZKNeucp4iKVlA2ne8TXV7Ff0SI38F4gxaLEVKyu
         1ANoGqzjTOdjtv4lZHitB1IEQVddw9aO63vcetuiOlc/Nmxf3tBGObwVSUGXjP7jaAIn
         IJEa5rhBZDr5d9UcbZwKnOCluUI7hMLkaNqzYQ8CxZIebx1NPJaw5TmIzIgBci+EZBcN
         CgVp7qmMhITT6b8rqebdg2+/3cH1KyMKga0rkV1AvyKL+y8Dj37Nq8iN2/txWjl8sgCX
         HNqPZAWYwLIVop5Nv70s3/JQS+hXU9SC/uftXu+nGisDXRuRmz3kTfZ2O2Sx8WH+cj49
         cGEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790033224; x=1790638024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=va/vFiItRvpug1hTbx6eo1iSM5BSyMyaF3MlvXV7MJM=;
        b=hWIvxabTudcgWRy3pHukKQVvatZs5UPrlffawIMhw0CV5LP5m4pyYYZCiyWy4ed2uJ
         wk+0fztO7rhxc4OdP8qgVFlF3sJrMLG7hBFkCpmOE+voRW2Ygy03+YKo+6atHnGYw84J
         9vvtLIqi5WBM318aRsNo7tUi0STKllDjHCrLb1alTy2UfqYqG4zKPFKAUN9mAJZKX0F/
         qwaveRKOQqQ1rHon5jgRlpnzk8PtmtCHEP03/6He8Gfse+Bg43MLfeJDug5LIEXNIeC+
         1DNVWzWh0SbqVQAynJnFuaRC//WP/e/sjFoGa55Sv2fBvZND98OTj5yz8lo/aX0Q+lUp
         yc2w==
X-Forwarded-Encrypted: i=1; AKwUvBz77yazoVSm6WnjbZ+MHpMGgB4IzJvbGO1iBXpf1zwkcoIYThSgQM1NTmPM9tkigq7NzCcZChHzRw==@kvack.org
X-Gm-Message-State: AFuF++lyXdbgsgOuR2Ec/G85rloyf1XR12yaON57y45mm/nqwmj6LxCa
	yNn/FZf1lWTQC/4okbehNywQYgqSMzVKEs9IvnWD/NAeKNdljugz21JRqwFJMwIWUUeKb+VaTok
	JsRMRwK+WWglp72zT08cHK1WPHK/URpsd/25B
X-Gm-Gg: AYBFou1lQUdk8mAoVIJ+0rSqssdx415EvuY2C+j+Z+6vMS+uBPsaaWtwkzf4xeHO1fH
	3pR8FtfykUMhPqBFvdtDVt9U4Y9aPscqiIPR/mSAYGvABkGBpXR6/S1E7YrRUpm1I8R46FGXCm/
	pT4qqs4ssQojO0Yntu1X0MBDckb328JyF8hBVrvpkt4pVUH4ePP9oR6vnojvrCzvbZeHT/nYP30
	akPi/w8DySPsaaTey/2iFCUnLftWgPtBjAePJaGyWX4sX24kLmJznhp3oQAXoS8Tkfbf0ygbdVW
	Oa8l6DTlv1H0KSMJP3SuCH0Coro7lv0+sctkZlHpZIELOKq+aQVrU1VYW58k9YL4MpWjpYbonGj
	lhd+edMfS3LxfT/icqeFqgStAdUiNTjXvIQT2AsI=
X-Received: by 2002:a05:600c:a085:b0:49d:25b0:cc60 with SMTP id 5b1f17b1804b1-49fc5747f7bmr184458765e9.29.1790033224386;
        Mon, 21 Sep 2026 16:27:04 -0700 (PDT)
Received: from c14-smtp-2023.dev.purestorage.com ([208.88.158.129])
        by smtp-relay.gmail.com with ESMTPS id 5b1f17b1804b1-49fd8a7d9dcsm4178095e9.6.2026.09.21.16.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 16:27:04 -0700 (PDT)
X-Relaying-Domain: everpuredata.com
Received: from irdv-tmenninger.dev.purestorage.com (irdv-tmenninger.dev.purestorage.com [10.32.149.15])
	by c14-smtp-2023.dev.purestorage.com (Postfix) with ESMTPS id A366F3417FF;
	Mon, 21 Sep 2026 16:27:02 -0700 (PDT)
From: Tim Menninger <tmenninger@everpuredata.com>
To: Harry Yoo <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-mm@kvack.org,
	Chuck Lever <cel@kernel.org>,
	linux-nfs@vger.kernel.org,
	Jon Curley <jcurley@everpuredata.com>,
	Eric Badger <ebadger@everpuredata.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [SLUB] nfs_page cmpxchg_double_fail and perf lock perturbation on dual-socket NFS/RDMA
Date: Mon, 21 Sep 2026 23:27:02 +0000
Message-Id: <20260921232702.486161-1-tmenninger@everpuredata.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <arFNKeseUHBvdRCA@thinkstation>
References: <arFNKeseUHBvdRCA@thinkstation>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0AE7B40009
X-Stat-Signature: pp4ykskrgzazbdyppsq5q73yiex9zmbk
X-HE-Tag: 1790033225-643454
X-HE-Meta: U2FsdGVkX1+E8lpQ+tuoi73RKt5KMS0ZJQw02VGOkBv+T0K5NBE11gioRF29d35hQjdGd5GzaGnN54crLyRCeHApuPgh5Bk3Cveog2CorghfC8A69ypnKVeXYbaxU2jBX/ZpFrR2DBkVquJWOGTxei3nVU6solTiFc3NJYaylPYJJPGScvvU0BRxWV4qPWFbH78aN6a8AO0ddoZDzb+JtN7tqABy1NtIIamG10zRgpIdyRsRLCNh6Ads1aonMVLCAaJ2OWBmFrSFdKoDhbSt45l4mMq/KKTOloyf+744271m869N+WrN04mqoNRWdnlbO6dWZ+dlcPuD0Sz7aYfluqV9zd+9uno7jfJM99ydNOoiWWBfp3WfMq4hsF7NaCAwbfYS/NTk0l7O/r4B6+Dl20AmTuM9B4JIexJvBpm8BbkcxfRiVEFrdJzGeELj/vnacVuy5tPLv8qKN9NlQlQBbK6BI21vOgmjl2vEOLFleoul6hD14j+ysyA0ZRAsCB7k7idAjBmcnRjoMIBwJT8KItNane5stSszyKRJDnYi3xvwNyq12TAfCY1nWj++RjJCsWS+Nt/VaqmefBLt/Cl7Ky6f+//+BIeSf+BKGAzziVBacuHFMt+1ALy5CornWj6L67jgK0wfBHTQux5JxRdYcveRyoWQNgzXel0ULu2uBqOrlobsEDL1VydTFT/fEer+++nCapFVodOFYeMzuE6ZEmpCUAWQfPJYd42PZzc1Hv3Ni5M6l/E8NRVNHyl9jDwEvFi0WnykJQtW1+3JHBpqXJf9qRBosxh3XFelHd9fjxf8BdL3R8OrNFxSckeHGQqNnwtk7Tsj/P2Fj+hxM2iDiObaZ4mVkLb35UJvgB0yKH0MZg+AdeURHy8IdUkBfszjH8b83hinyMVYbeoxDve5RAPvjeDCFUQOnt/dOiSV1/t+/1xRzlQjNZC3iriNUFPhGao9uCKbPlNMG3LUzZL
 rOYb5l7e
 pet0O6FsLL2SmJL+An2iEgvmFoaxeYPHEdpu9xGkYKNCIeUNmRaN5hiYiKJFjyABLpfB5WskYzpDPQQLjrq4O+hQ752z8eLJCc2SR/pD+s7kGfes3d61VLz7fHlNbvLfTs5SUNVBXpMJxj+cheq/foCoTyvrJhlVrlGeJtzbea2fO0hMTvHSjPQnamPv5vq+Gp1sRjMEyNc33yNvtxLmHyk4GErUv7oV3l4egW5MAoaAK3yERUeafp/nsmC0SgjGvBvl9qYyryeJmuTuG8FtskmEcXKkdNC768AGQQ4tGkoySdAKfBLIElVf6OhkCoEOXyvB+fbBCs99kw2aLl8YGhIhxQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Did any of that change with slab_nomerge?

No. The large change in the SLUB counters still reproduced with
slab_nomerge when using perf lock record. For example:

                         uninstrumented       perf lock record
    unpinned/node0
      free_fastpath          75,366,487          646,378,908
      free_slowpath          41,594,255          259,704,037

    node0/node0
      free_fastpath         119,705,541          440,896,371
      free_slowpath               6,344            6,679,339

    unpinned/balanced
      free_fastpath          59,404,047          384,715,890
      free_slowpath          60,602,379          324,936,304

> ... unless perf lock was writing data to an NFS filesystem?

It was not. The perf data file was on the local root filesystem:

    $ df -T linux-mm/
    Filesystem                        Type
    /dev/mapper/ubuntu--vg-ubuntu--lv ext4

> You can use the BPF version of perf lock to check lock contention like
> below. (it only work with 'contention' subcommand.)
>
> $ sudo perf lock con -ab sleep 10
>
> or
>
> $ sudo perf lock con -ab -E 5 sleep 10

I reran the three placement cases using the BPF version, aggregating
by lock address:

    sudo perf lock con -abl -E 5 -- sleep 10

I ran only perf lock and mpstat concurrently.

The BPF version is substantially less disruptive. Comparing adjacent
10-second uninstrumented and instrumented windows:

                         uninstrumented       BPF perf lock

    unpinned/node0
      throughput            45.5 GB/s             43-44 GB/s
      free_fastpath          76,217,260        118,511,381
      free_slowpath          39,962,005         22,717,811
      cmpxchg_double_fail         9,299              9,587
      system idle               22.74%             10.61%

    node0/node0
      throughput            46.5 GB/s             46.5 GB/s
      free_fastpath         119,739,790        148,686,356
      free_slowpath               5,686              8,791
      cmpxchg_double_fail         1,483              3,170
      system idle               83.33%             82.42%

    unpinned/balanced
      throughput            46.5 GB/s             46.5 GB/s
      free_fastpath          59,341,738         92,824,030
      free_slowpath          60,000,396         60,658,896
      cmpxchg_double_fail         1,742             23,772
      system idle               68.27%             50.03%

The per-lock-address BPF results are also quite different from the
perf lock record results:

    unpinned/node0:
      contended    total wait    avg wait     address
      8,345,025     12.27 min     88.23 us    ff3ad60e50e85100

    node0/node0:
      contended    total wait    avg wait     address
      6,461,976     30.70 sec      4.75 us    ff3ad58ecf36ac80

    unpinned/balanced:
      contended    total wait    avg wait     address
      6,592,568      6.50 min     59.18 us    ff3ad60e50e85100
        143,397    666.98 ms       4.65 us    ff3ad58ecf36ac80

perf identifies these as kmem_cache_node spinlocks.

