Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05AA6CD343F
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 03:07:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 729896B0092; Tue, 12 May 2026 23:07:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D9686B0093; Tue, 12 May 2026 23:07:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F00D6B0095; Tue, 12 May 2026 23:07:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4DD436B0092
	for <linux-mm@kvack.org>; Tue, 12 May 2026 23:07:11 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F31B81206AC
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:07:10 +0000 (UTC)
X-FDA: 84760910220.25.EEF84DB
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id 40C3C40002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:07:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g1O25Pyj;
	spf=pass (imf12.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778641629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=mr8B54nCUqKe73fttlmYFbpBv8yytDHMFbs5Gt5TGns=;
	b=JuKx9Rxkxq9rd6ilBG8gH4InonnRS0fVf3Nz8ErHYCf0N77XiDq65ho8rUIN1SMXg7zdtp
	nPp2VV9MRJxXuq2GoI/Ue+OPV3h0cHqPuxDCzdxw36RYbxdhyRKglWgC/+ngUZweiyn756
	5n1I4S+JvnY8fzulGme9QTiUCYCRgbk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778641629; a=rsa-sha256;
	cv=none;
	b=DFEFiD2krYBjAHT9+JRp5oRyVAvnG+piGs7pfDStjZlAs/RrcSTnKz0hqlCH86ya6ddHRf
	LfxMzWfPzr66zIvxs2yjAeI68cAm4QTIEISqf8GaiGhMpvifzEE8Ou2OoUu34BPipEuL+V
	CNHwwE0leC2mLquD366EEr6j6v+birg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g1O25Pyj;
	spf=pass (imf12.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-c82471904fcso2721065a12.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 20:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778641628; x=1779246428; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mr8B54nCUqKe73fttlmYFbpBv8yytDHMFbs5Gt5TGns=;
        b=g1O25PyjixheMax/EA79h0PjV0Ch5BRIlHXBVNrZOc4rTObKiP9iz/ioqGRc1G4c2T
         XQFucCAEeWwh8JuEPAKjeFrWylFJKZFX/eGMKdHUEqYY5OhrTL+j3pIcfGE/R9nuHfZi
         SU8TnqHpX/FiFEgGABp446SmQ8BIrQQ3whd5RYp0NoZY33B/TGPCywYm7ZSgJ6ukb+vb
         vNGqPx2JhUhq5JXpbqQHm4/KIrK8humXf+UlwnJrLMn+AzAk49N4IArYfWMOEYEdDuyU
         qnZETd4JfaE9PMWQRwcqPv2ZivyIfPOPYqvzGOKRxLECTaSHEooCUHRlaihfH5v8QPmI
         cE+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778641628; x=1779246428;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mr8B54nCUqKe73fttlmYFbpBv8yytDHMFbs5Gt5TGns=;
        b=aY/uZ7kq2olXOxEyP9XV7eFMtLYj8f4CcKi94zUqUzjmfeR/LyrIvNrYKUxaMYHvob
         S6RwxWquwKf8V6YoCEF/hByqBBxLTNF4ZhL/FwNODq/668aP/uIKtRnl3j4T4CEnm8/A
         aLlxyBuY2W1XrIQ/5mFhTTNOL4IDvrPC4wo9Azb9Q7m/1DAJ8omnpjU8/4UsUr04amtQ
         +M4eeW5fMTn2n9Bx/RP2HsPRKRh1ZItJbBboZVRiU0rklAaWBydsSv8+R1Ksj8boOPDk
         mqJDdb03fMwRJdgRbUyFC950hZLpaId4s/4Y2pROoFcHd01hE1t+hGh6B/4RJgCtmdXk
         mi6g==
X-Forwarded-Encrypted: i=1; AFNElJ87PzefhsqbtRgtt2KiQ6D6myCHSxSRW5UFWHQGCkhZ+v/boJcU1YsHVg0D23UKym1P6pVg7l8vxg==@kvack.org
X-Gm-Message-State: AOJu0YzF1jyn785JWmOlSxOUFCe05gl30Rl35VgbHDHz7wBohwXZbzKh
	dGy69OqKhqGw3mH7dL6Luc17kp2q1KUKvw+9RBZxnTt53zYu/D7Q+MVQ
X-Gm-Gg: Acq92OHzVFJhpqsMkRR/OfrPws+5f7BArLcBnrbqjoVJkpTSGFhTs3P5X7OK6KMHPQi
	XzCEfUiNV+bNPuNNfrLa+20DxBwSP6oyfAxqh8UHL0dwhtjxtxI5vEmpf3KmaSFjCqp493qo6Sv
	bBG9WBiUiQZjstA8rKSeSGuoZuni7aRJAgpfdxi6zLRKALW0L/A0HMbn3l8ol9tKL4+4VPMweO1
	WKdNe6FRHwkdfcp5nN9TiUh6eip8HRNkGpz2zw8BjRbD3VozMiehCIaqPuZKijQrtiTrGsAlIgg
	md2AVFViAuzF5gjlmpE4hLcTeB2Yh7It2CHW7QeddLUKiGA/dhcWE1eX+Eo2nvDzORzvQjF58Ec
	q3t4+/j/oimpkhT7A9c05FnbFI5aaLeTeVM+DQ0tLWZXuHxoRGJwRXYj9KzVwJHnh9dB6B8hj5N
	CCmAl2KqQZ7gs1QUSaGShOhq0upl1N/2tI
X-Received: by 2002:a05:6a00:4146:b0:82a:17b8:1474 with SMTP id d2e1a72fcca58-83f03e92ea5mr1356854b3a.1.1778641627973;
        Tue, 12 May 2026 20:07:07 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-839685a3187sm25369465b3a.60.2026.05.12.20.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 20:07:07 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Jeff Layton <jlayton@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, Chuck Lever <chuck.lever@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-mm@kvack.org, Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH v7 3/3] mm: kick writeback flusher for IOCB_DONTCACHE with targeted dirty tracking
In-Reply-To: <20260511-dontcache-v7-3-2848ddce8090@kernel.org>
Date: Wed, 13 May 2026 08:31:23 +0530
Message-ID: <y0hoqags.ritesh.list@gmail.com>
References: <20260511-dontcache-v7-0-2848ddce8090@kernel.org> <20260511-dontcache-v7-3-2848ddce8090@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 40C3C40002
X-Rspam-User: 
X-Stat-Signature: 9ex7fukjpnequoh8bfmrt336m8r96f86
X-HE-Tag: 1778641629-218531
X-HE-Meta: U2FsdGVkX19r1IX6f2EM2Qp7TPsPRiE2wjt/7TWgRZl3zkREZmZUEK5eTSEmXhcFlF7d3dBQN+l63l/5pauvguy/11U20g+tMCv/ayEgyP2QLIUuMsMPq/YjvQMM6DRa7xF9mxWDW2S5EZA7STAMhf0hLMhwcuMjwOcij/K4anm8n3Afo3w7NF6QvNA9HdJFSX1FMOs5b5zzPI6N5OvZOIXxTU8mdCpwLPRBj7fPmxcEKrzuT8GcgXHYFpw86nJAFJjTdgwrYj73WcBMUkQ4559n6U1BKn+sPEAVsoNCBep28rjUOeCTzrJfJ0IVvUY8uQAQRi3HEZXhICXgmhI50J+NusncYp/kO/S1WRHPwgTE1tEjrGnp7QioKDGDgkhlYSU7dCVTLUWSmLgTR2u52BAbKRwE7tKmwoPWimga8toGClbEmkEVQGeWCpLBTcvJlbgGWqq400O9aZdg/hb3tBQO+JeRWAVw3Fbw84afK2q+Iwh464S7jf75EmApy5hM+DVFZkVMLmlEa/st7V/xgoX6ct0NuA3nVmirTcLBqGJ6AMBtVd3+RalwhPXs6dzf7fWiOc1HTcsEiejLT9Yy9DaQ81LJfRRFLnh3eaViyDiOtsifaXB+crCQE/UmhKydky0/N4nWKH6H85pbR1QPWMU+dsUlsEERAHhKIqQHWy5WiNzFRbfJcBlT4An8OBmp6P5HMRGnKrAouhyL6b+hJY942iOTXHTZKbPwmj0qldxYtMhQgpf/A8ezJoRbPTjT3yFOaLgTy3D4rh0SxId+KZV5Slwjah5+1aZJY44rxoCEQPc2Wv1KYiKN/vGBCbsmU/DBI6+kVDpI1VqVvkHfmS4HVyIGomVEEjUHYDnwYTaN2TZ2LgKhFsYOzN1X41GDDfDN6nYn9TvZN4rV335j5Y70BGxpg7F3AVgRXIpfOneK3HB/JC/KHWv6OT7iq0LtXquC8VBXFuIhvhijdsy
 mj1Xc211
 txa2KIJlB5XsEaivrGHxvhxx7FuyFDoHRdqr9P0Umm1yu3/1KUTzGyOyyFivWHH4MYZ1MDVO2ampfbPsc8vuGSRfSwbuUCiZ/vV5TVCmJRMW4mUF5To8TOevFhGnuYcSILDyWt7MkG6hx1jb/4m69Lcm3onPr/UlcJInyB2uA9DTDnOgTdq586o5u3tBGvQgwxmMqxY57IqPhH3GaLt32AkC1y0+5zeUtnUUSpcAdL8pGei6E+cD/1Qsw6ABulT1poAM6NiCY4D7Hj++hfXc98CKfmARzpf3ghiykCQBJTIrBlFZ/0eNLGAMSXNWcwMAr7ahdeS87ZgfAZcRExKcaTP/0KMrvlRYdn8Kx0Cp0PjGOFps6+Uc9/bsmL1U1JcAa/Dg/El36yqktqmnTpWuRy3iu8g75pSZQY6e6YUmZ+pyT3XeBKLqXIwxj/l6vLMHv5sunK148/RSVHP3jovPo6Jn/8yxBmI5VWvt9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jeff Layton <jlayton@kernel.org> writes:

> dontcache-bench results (same host, T6F_SKL_1920GBF, 251 GiB RAM,
> xfs on NVMe, fio io_uring):
>
> Buffered and direct I/O paths are unaffected by this patchset. All
> improvements are confined to the dontcache path:
>
> Single-stream throughput (MB/s):
>                         Before    After    Change
>   seq-write/dontcache      298      897    +201%
>   rand-write/dontcache     131      236     +80%
>
> Tail latency improvements (seq-write/dontcache):
>   p99:    135,266 us  ->  23,986 us   (-82%)
>   p99.9: 8,925,479 us ->  28,443 us   (-99.7%)
>
> Multi-writer (4 jobs, sequential write):
>                                 Before    After    Change
>   dontcache aggregate (MB/s)     2,529    4,532     +79%
>   dontcache p99 (us)             8,553    1,002     -88%
>   dontcache p99.9 (us)         109,314    1,057     -99%
>
>   Dontcache multi-writer throughput now matches buffered (4,532 vs
>   4,616 MB/s).
>
> 32-file write (Axboe test):
>                                 Before    After    Change
>   dontcache aggregate (MB/s)     1,548    3,499    +126%
>   dontcache p99 (us)            10,170      602     -94%
>   Peak dirty pages (MB)          1,837      213     -88%
>
>   Dontcache now reaches 81% of buffered throughput (was 35%).
>
> Competing writers (dontcache vs buffered, separate files):
>                                 Before    After
>   buffered writer                  868      433 MB/s
>   dontcache writer                 415      433 MB/s
>   Aggregate                      1,284      866 MB/s
>
>   Previously the buffered writer starved the dontcache writer 2:1.
>   With per-bdi_writeback tracking, both writers now receive equal
>   bandwidth. The aggregate matches the buffered-vs-buffered baseline
>   (863 MB/s), indicating fair sharing regardless of I/O mode.
>
>   The dontcache writer's p99.9 latency collapsed from 119 ms to
>   33 ms (-73%), eliminating the severe periodic stalls seen in the
>   baseline. Both writers now share identical latency profiles,
>   matching the buffered-vs-buffered pattern.
>
> The per-bdi_writeback dirty tracking dramatically reduces peak dirty
> pages in dontcache workloads, with the 32-file test dropping from
> 1.8 GB to 213 MB. Dontcache sequential write throughput triples and
> multi-writer throughput reaches parity with buffered I/O, with tail
> latencies collapsing by 1-2 orders of magnitude.
>
Thanks for also considering multiple request for performance numbers
into account, this indeed is a nice improvement overall to
RWF_DONTCACHE.

With Christian simplification - the patch looks good to me.
So, please feel free to add:

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>


