Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A114660A2608
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 03:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GjourxuO
Received: by kanga.kvack.org (Postfix)
	id A48126B095D; Tue, 27 Oct 2026 23:05:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1FA76B095F; Tue, 27 Oct 2026 23:05:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9351D6B0960; Tue, 27 Oct 2026 23:05:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 69C856B095D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 23:05:15 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 61487C0ACB
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:05:14 +0000 (UTC)
X-FDA: 85370543748.06.9E59227
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7DE3E140003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:05:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=GjourxuO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793156712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pBUxUaSh5knHQq0/77HgNSwW96o+3LO65RsiQyZl3LE=;
	b=zEtC5/RO3YLAqqRSetKfiH1VX16btz9+w5EZ/cGTtH+Xwi+4YVilgmE9EzT0PfL/inQnlq
	2XqG5+Cy4UbBSboZ+RBQbgBZpFm+ZsHI++DvVFX+L+4eGPkNR+HYS6zq1By0+kfYjANnJr
	HvTos3eJk/fovDhjnlv+d620Aqm6I9o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=GjourxuO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793156712;
	b=6csQPzT20Ki7VF4j3DnCAd8sNfKc8AmKH7QY3ffydM67FFFSL4BIcSK1dudB72Dn/qYj7H
	LQwmod9QAlY0hOauub+vWhJtTxkU0qJeuIL4/L4bbb4Y2BJxsvxkC2dlVmqI/IpjCTk13x
	Vj93Ri+A09ls06yHTg3REyWbKyoxTrk=
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-15ea896ddc8so724396c88.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793156711; x=1793761511; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pBUxUaSh5knHQq0/77HgNSwW96o+3LO65RsiQyZl3LE=;
        b=GjourxuOLv9NtSfTJ/iqRIHHaT7xY2xVLOKKIo+V8Alua5dSknMmah3jBCa3ZaNZdh
         86PNlislFf/lMBezJ3ezMBjfQrZkSYSoODkKcxzOQa+czcDLSITt//t5ms1MIbaCCoIy
         iuSKpGXfCnt5WACroMx//QoOeAsVT/CtlfUxTYGY8TktrfSaj5ztZvLg75Ssfbv2wua4
         5OY+aNNRj49DLTggYQdwKM530NEbc2ag9OMX6dsJZ6zzoQHpNdKqhtUoRlGJfZ8wDXKC
         Ji2jCF0WRzk2zajWi6YrBlcE6i/T8It3XJkCeGArTpdqAm/ZlL3PvvvZbvKYzciiHWVv
         1IKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793156711; x=1793761511;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pBUxUaSh5knHQq0/77HgNSwW96o+3LO65RsiQyZl3LE=;
        b=RvaaDvXPqjM450X5M2sWab6rhqJ/uD1a80H6posWlowcQGvL+tPjnW6UnnHzrEzv2q
         7Ha3xK6hHvIG6w4fmTpEYDKn/y1yqkoBChl28FmA5enBLsY44H6D6rahntPXFSBJJBz3
         vSCH0HFZ1iTc/juAR5Snv5p3nOieUU8JYAdmUfv8+L3pesLfBDpmm3EMvudeIzp6CzqP
         GeW6Lg/sJuXrD41dhekIc0IiBBwn8o8Bj9fLKQnphmTd6+fV+i8r6zlcGyHj5YVntQyG
         20g20VFENk8z6pHXI+pfixxsrOadt2pmm/LqhWq2E757s4xP1q6JptWb5IMxh1ho4xgE
         5HwQ==
X-Forwarded-Encrypted: i=1; AKwUvBwWPVvNwPj2grwwHneTlVuooo5h6h2wxgaMiNVR9kfFFZ4KX24AQcgYXrbazKYmucdcIYCL4RZy0g==@kvack.org
X-Gm-Message-State: AFq9FYLFuoNmiZ6e8/naqdlF7ccbJ1rBwLWqRJaoz1pOBOZG1ntQAATk
	/VTjgniBT7w41I8Qu1VukY1/A67yFqeHGEnUl1wTu4rBYuw9pwkF+TFM
X-Gm-Gg: AYBFou1XG5DxK79R54OMZlPpNDiL8hdUygHQge/YFob8eXpOJGlu/2n4hRvPNsaLBYk
	UkngqnWxE1+wIf281w7sQOhDBOhM3szxOPCqRFBnvgiOJh591UAG4jfbrHk5IGVamCFBgiHMOeH
	o0LGVN9ck0vQuKZxahXxfuuVsgC3ShO+LdGx0JYoVzNXx1ls+APxSS/TqhStCIYOhCX5Kyk7AHo
	6f4c346x30F7rcKbmeJULeaF3EqV4mpRMDqc7yvoAL7cRTMRy5ZCCVkJm7kTaqLipfRjnstHrAb
	QvwjAK8afG8IEmcVNg29Xp54LbhQxG4wAlmVcM/+/brOPsSb8fiKmBRrKPuHkWN1RPHWe2vKFdQ
	+sMO16IexlCbcY+kp2nd45qho/I8+Yx3N17pG0cIIYOd2A1XxwVfewsBpPIKJwG5LLOvW9Fkucj
	Yz0jlQI2AKLLcL4Av3pk23O/wD5F+iHgJqq7Sx596kyfuUFcIYWFD/LRG4hRNzETWJQOdwBrqfX
	33cGoP5NyNgBT3UNd/WGw77Igme+hXarq2Nbn0/06ZN6l6RNAKbJyd/ulZXuer6+NXv54GQH1pV
	h69KxmuqLXakvIfx8VNegIWcCAwhoAsB6KetWBu2iA==
X-Received: by 2002:a05:7022:b0c8:b0:195:9228:50a0 with SMTP id a92af1059eb24-1a6d0b62961mr1266643c88.42.1793156710801;
        Tue, 27 Oct 2026 20:05:10 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1a75a37093esm1150734c88.3.2026.10.27.20.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 20:05:10 -0700 (PDT)
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kanchanapsridhar2026@gmail.com,
	linux-kernel@vger.kernel.org
Cc: rientjes@google.com,
	willy@infradead.org,
	senozhatsky@chromium.org
Subject: [PATCH v2 0/8] Batched zswap_store() framework with compression batching
Date: Tue, 27 Oct 2026 20:04:55 -0700
Message-Id: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7DE3E140003
X-Stat-Signature: sz5cwrs1iebn9d7kk1f5ch46bxmz35xw
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793156712-329705
X-HE-Meta: U2FsdGVkX1/wZzlSRKfP8KEVNNfUjnK0LvHHgXCSJObneUFLgWpYJNpXe0pYrZHyGNGerJXSB4NHtcNOq/CPFvdlR4+K7tEXAuaXM74VuBtJz1GNEuMN0ex3QyDahtT9MmdzrFQHuMMKTdFTuN8+0yGexzQXMjHmq1aAwG/JKllNGM8pSeAzHPE4gm3bvBZ/cV53/U1qROUw8NSa3rV4yfKmWFEZwH16OjihdC02WmrvnyiffHzGHyvBLGeKvS3HJVL+D8Xw0VrRB81PSdggCpJW5svgob19ICRovTXlLWXIoVeKAPxqyhClatfQMqfqXkub38ydrFEVtyy1YCo20SAwa6L938pfUpJADdU9wLjngIHjtTQnwspCUjwDissQuxkQlkyxT0sB9iY0ZdwtxBtGFL0G/Cun/PvsDQ2tujTfpJdniu9SxexRjQGe0TZoDdW15s/07VZNV9he8IGt8ArudRWot8ev3uLadnXc0hcabJ1In9N28xOSSGUZ4iPQcT9/1mZ4wXRh4ygv/zerH5mIRzSGOEZvKIP3schaSJUEBvAV2N1dCmHJ6jzur2rKLCAeFl0kU+qblP1OG7z5cTrbs92T9/9m7qVE7XFdBDCn1VeFfJtpmcV/ghd1SZSVwvCur5wV+zE0nLRFCDaw/7qr3bZE9pO3EBhQ2JOcGiyO9tdc+1BDJavGdEvUJud5s5biLqc5Z2TT6C65Fk8fIK+ksalvg4+1xwOSttLXoKFpfBOg2KvvL36CK+Ea9fjHas34FFev+DYl21/b+UFQOSYVIg/JmJfAa2uG2gYMzKDAwqmkszN2xkIXcYrgXVMLhjURVuyFLf2dA/D5G57xxt1jcyeuzK6QkgQzSfUORak6koS94ethMad/7+2+SbLOvQpfO/ut48ED36Z0nKX15KO3GwYZGzm2rBvqVJrotfYPHXoNimCYVVorVbG1H3qIbenMfv5pmq1Q+duDrIZ
 YHvAvLrt
 4hu1TZEEi/J/SdneDWvAoj6Vuox4OWnjxfXxp8f0EelpbxrfYmVLoTeam1gGkL0EJyhrSMNr8iMUob2oNCBiEFmQjZ91MkcAB2vJN41hecPTfg0B0qUp3hIseWheyjYz3CL976eQI/1+LrZsSvc3a+nnaZ7lO/Z/AU02T5JWfKGVSvAAPQVe0SVEotJk7j9XrMfoXSQ0OmUNAeliZmKNoTiyPRu/xPySFR1BClUyUwy9tjUeoj0ABWh8OKwyO/1PJKuu45KdkQU/tyUNkMdinyOvj34fKqUxrAKQzSMPEN2Xq0VUz1yHmF24M/elUnljeUp0KDI5irMpmhDRrszvuDgj918nkpSgRBh9weIeav1F/rSB9wWYfdDPXkywvw2/q7TxZdjwgdhNfiHwum0TnS6oCJ+IAuirRovMV2HLtn2xN6ItY0w8/bgajtGOtvbvcsPELCN/veSBERVgUZmPxYBa+nGzHMH2OcX+PQX9cp5SSpONq8iXWpHXo9nXLTCDqCCWdaBOz6w7B1R5owSLFHehDB7uufE7nmVmBWI0GkPUTdrLRk7RA+hw1XSMu6dHD6cdSZgAWH/4uVM1qoC7NfrgfCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


v2: Batched zswap_store() framework with compression batching
=============================================================

This series is a spin-off of "v14: zswap compression batching with optimized
iaa_crypto driver" [1], and focuses on the generic crypto_acomp and zswap
compression batching enablers. Resuming work on this series following a gap
since v14 (January 2026). Please note that my email address and affiliation have
changed from kanchana.p.sridhar@intel.com to kanchanapsridhar2026@gmail.com. I
have retained the original Intel sign-offs on prior patches for historical
attribution while signing off v2 of this series with my current address.

The main focus of v2 was to establish a reliable and accurate performance
measurement methodology, that addressed the problems with variation in v1. This
is accomplished and used to validate v2, by reducing usemem to 2 processes and
enabling PMD THP. As the data shows, we get exactly the same "2048kB-zswpout"
counts in the baseline and with this series.

To summarize the main contribution of this patch series: Batching is introduced
in zswap_store() of large folios: we carve out a large folio into batches of
ZSWAP_MAX_BATCH_SIZE (8 pages) for software compressors, and store each
batch. Moving the fundamental operations that need to be happen to store a page
to now work at the granularity of a batch offers opportunities to optimize them
from these perspectives:

1) Utilize existing kernel API that minimize obtaining locks for bulk
   operations, e.g. kmem_cache_alloc_bulk()/kmem_cache_free_bulk().

2) We keep the working set for each of the core store functionalities
   (alloc/initialize zswap entries, compress pages, store pages in zsmalloc,
   pool/objcg reference increments, objcg charging) to be focused on a
   batch, thereby minimizing cache evictions and benefiting from cache
   locality.

3) Along the lines of (1), the main zswap_compress() batching routine obtains
   the comp_ctx mutex lock once per batch, and releases it after it has
   processed all pages in that batch.

4) Any zswap store functionality that works on a batch can potentially be
   optimized via bulk-processing/parallelized as a next step, to further improve
   performance.

Performance data: usemem with 56% over-commit:
==============================================
Validation was done with mm-unstable as of 10-25-2026 (Baseline) and with this
patch series. To minimize variation in the data, I made these changes to my
performance measurement methodology:

1) Reduced the number of usemem processes to 2. Each process tried to allocate
   2400M, in a 3G cgroup memory.high budget, effectively accomplishing a 56.25%
   over-commit.

2) Increased the runtime of the workload to ~9 minutes by enabling PMD THP,
   i.e., 2048kB mTHP folios.

3) The use of PMD THP forces zswap_store()/zswap_compress() latency to be in the
   critical path, and thus enables very reliable measurements with bpftrace.

4) I used lhist() instead of hist() in bpftrace to gather latencies at a finer
   level of granularity and accuracy.

Testing was done on a Chromebook with a QEMU "vng" VM running in Crostini.
    
Chromebook Diagnostics reports:
  Intel(R) Core(TM) Ultra 5 115U (10 CPUs, 4.200GHz)
  RAM: 16GB

vng setup:
         Memory: 7G
           Swap: 3G
    Pinned CPUs: 2 (E-Cores: 2,3)

zswap compressor:
  ZSTD

mTHP enabled:
  2048kB (PMD THP)

I used the help of an LLM to write the bpftrace data post-processing scripts
that generate latency percentiles.

vm-scalability/usemem setup:

  cgroup memory.high: 3G
  2 usemem processes, each allocates 2400M anonymous memory, reads the
  Silesia dataset [2] from a pre-fork-allocated buffer into the 2400M,
  writes to each unsigned long in the 2400M, sleeps for 10 sec, then
  frees the memory and exits.

    usemem -w --read-silesia -O -b 1 -s 10 -n 2 2400M

 usemem metrics are reported from a single run after starting the QEMU VM.
 Further, I have tabulated the bpftrace p50/p95/p99 latencies with these labels:

 "zswap_store_higher_order":
    zswap_store() of PMD folios.

 "zswap_store_order_0":
    zswap_store() of order-0 folios.

 "zswap_batch_compress_per_page":
    zswap_compress() per-page latency of store batches generated from PMD
    folios.

 "zswap_single_compress_per_page":
    zswap_compress() per-page latency of order-0 folios.

 
 ----------------------------------------------------------------------------
 usemem                       Baseline      zswap        zswap   Change with
 PMD THP                   mm-unstable      store     compress      compress
                            10-25-2026   batching     batching      batching
                                        (patch 6)    (patch 8)          %
 ----------------------------------------------------------------------------
 usemem process 1                6,353      7,240        7,428
  Throughput (KB/s)

 usemem process 2                6,352      7,236        7,422   
  Throughput (KB/s)

 Average Throughput (KB/s)       6,353      7,238        7,425        17%
 ----------------------------------------------------------------------------
 usemem process 1              484,580    308,903      257,230
  Time to free memory (usecs)

 usemem process 2              518,928    438,585      446,958 
  Time to free memory (usecs)

 Average Time to               501,754    373,744      352,094       -30%
  Free Memory (usecs)
 -------------------------------------------------------------------------------

 -------------------------------------------------------------------------------
 usemem                          Baseline        zswap        zswap       Change
 PMD THP                      mm-unstable        store     compress         with
 BPFTRACE                      10-25-2026     batching     batching     compress
                                             (patch 6)    (patch 8)     batching
                                                                            (ns)
 -------------------------------------------------------------------------------
 zswap_batch_compress_per_page (ns):            
                         p50                                 40,086        1,569
                         p95                                 54,689      -64,505
                         p99                                 83,248      -88,488
 -------------------------------------------------------------------------------
 zswap_single_compress_per_page (ns):
                         p50       38,517       38,352       36,650       -1,867
                         p95      119,194      121,174      133,678       14,484
                         p99      171,736      158,601      169,010       -2,726
 -------------------------------------------------------------------------------
 zswap_store_higher_order (ns):
                         p50   21,012,222   21,322,885   20,176,667     -835,556
                         p95   25,643,500   26,204,375   24,485,000   -1,158,500
                         p99   28,567,400   38,577,750   26,158,000   -2,409,400
 -------------------------------------------------------------------------------
 zswap_store_order_0 (ns):
                         p50       37,601       36,994       37,568          -33
                         p95      123,731      137,034      128,366        4,635
                         p99      159,965      169,282      175,618       15,653
 -------------------------------------------------------------------------------
 vmstat summary:
 -------------------------------------------------------------------------------
 zswpin                         1,104,226      993,412    1,091,146       
 zswpout                        1,688,181    1,582,664    1,669,671       
 2048kB-alloc                       2,500        2,505        2,500   
 2048kB-zswpout                     1,535        1,535        1,535   
 2048kB-swpout-fallback               927          929          875     
 -------------------------------------------------------------------------------

 Detailed vmstat & zswap stats after workload finishes:
 ======================================================

 ------------------------------------------------------
 usemem                          Baseline        zswap
 PMD THP                      mm-unstable     compress
                               10-25-2026     batching
                                             (patch 8)
                                                      
 ------------------------------------------------------
 vmstat:
 ------------------------------------------------------
 pswpin                               0              0
 pswpout                              0              0
 thp_swpout                           0              0
 thp_swpout_fallback                927            875
 swpin_zero                           0              0
 swpout_zero                          0              0
 zswpin                       1,104,226      1,091,146
 zswpout                      1,688,181      1,669,671
 zswpwb                               0              0
 nrswpin                              0              0
 nrswpout                             0              0
 pgmajfault                     173,554        173,774
 nr_free_pages                1,753,879      1,755,195
 nr_free_pages_blocks         1,651,712      1,667,072
 2048kB-alloc                     2,500          2,500
 2048kB-zswpout                   1,535          1,535
 2048kB-swpout                        0              0
 2048kB-swpout-fallback             927            875
 2048kB-swpin                         0              0
 memory.current                 352,256        499,712
 memory.swap.current                  0              0
 ------------------------------------------------------
 zswap stats:                                         
 ------------------------------------------------------
 pool_limit_hit                       0              0
 written_back_pages                   0              0
 reject_alloc_fail                    0              0
 reject_kmemcache_fail                0              0
 reject_reclaim_fail                  0              0
 reject_compress_fail                 0              0
 reject_compress_poor                 0              0
 decompress_fail                      0              0
 stored_incompressible_pages          0              0
 stored_pages                         0              0
 pool_total_size                      0              0
 ------------------------------------------------------

Conclusions based on the data:
==============================

 zswap compress batching improves on both, zswap_store() latency and
 zswap_compress() latency wrt the baseline, pretty consistently; except for p50
 batch compress latency which can be optimized further in subsequent
 patches. The batching framework established in this series allows us to make
 locking and bulk-processing improvements in each stage of zswap_store(). One of
 the ideas that has been showing very promising results is to replace zsmalloc
 with SLUB compressed caches and will be submitted separately. This is expected
 to resolve the p50 batch compress latency issue since it will be directly
 optimizing zswap_update_entries().
 
 The speedup with zswap store batching of large folios has a propelling effect
 on other parts of mm, especially, by enabling large folios to be swapped out
 without splitting, as the data shows. This enables other mm components that are
 optimized for large folios, such as munmap(), folio refcounts/mapcounts
 updates, PTE invalidation upon freeing memory, zswap_invalidate(); which
 benefit from xarray offsets/range continuity. As a result, subsequent large
 folio swapouts are more likely to find contiguous swap slots, there are fewer
 large folio splits during reclaim and the cycle continues. As the data
 demonstrates, this directly contributes to more memory over-commit
 opportunity.

[1]: https://patchwork.kernel.org/project/linux-mm/cover/20260125033537.334628-1-kanchana.p.sridhar@intel.com/
[2]: https://wanos.co/assets/silesia.tar


Changes since v1:
=================
1) Rebased to mm-unstable as of 10-25-2026, commit a2abad0d7f45.

2) Addressed Herbert's comments on checking for the req->unit_size being equal
   to the req->slen to identify singleton acomp_reqs and to quickly
   short-circuit with setting the dst SG list length instead of going through
   the request chaining flow. Further, the most common code path is the very
   first check, with the short-circuit, in crypto_acomp_compress().
   
3) Addressed Yosry's comments wrt:
   - struct zswap_entry "length" field build-time assertion to have sufficient
     bit-fields for the architecture's PAGE_SIZE.
   - Use kmem_cache_alloc() instead of kmem_cache_alloc_node() in
     zswap_entry_cache_alloc().

4) Established a reliable and accurate performance validation methodology, based
   on Yosry's comments.

5) Refactored the sub-components of zswap_store_pages() where each routine
   processes a batch. The new zswap_account_stores() gets refs, updates
   statistics and charges cgroup for the batch, rather than for a page at a
   time. zswap_store_pages() is more readable and maintainable. This batching
   framework can be immediately useful for implementing more ideas such as SLUB
   bulk allocation of compressed data, reclaiming a batch of folios from
   shrink_folio_list(), etc.


Changes since [1]:
==================
1) Better cacheline placement of struct zswap_pool and struct zswap_entry
   members for temporal memory access efficiency in zswap store/load hot paths,
   while minimizing holes.

2) Refactored the core compression batching functionality to a separate
   __zswap_compress() function, which is called by zswap_compress(), as per
   Nhat's and Yosry's comments. Hopefully this helps explain the outer "store
   batching" zswap_compress() vis-a-vis the inner "compress batching"
   __zswap_compress() distinction.

3) The acomp_ctx is locked once and is passed to the routine that compresses a
   batch, per the algorithm's batch-size. Similarly, the folio's node id and
   writeback_enabled status are computed once and passed to the routines that
   implement the different store functionalities, to save latency by avoid
   localized recomputes of information that doesn't change.

4) Moved the folio node id being stored in zswap_entry to a separate patch, per
   Yosry's comment.

5) Addressed the kunmap_local() issue flagged by Jixin He in the
   IS_ERR_VALUE(handle) error path
   (https://patchwork.kernel.org/comment/27095925) - thanks!

6) Moved comments inline, per Yosry's suggestions.


Thanks,
Kanchana



Kanchana P. Sridhar (8):
  crypto: acomp - Define a unit_size in struct acomp_req to enable
    batching. mm: zswap: Set the unit size for zswap to PAGE_SIZE.
  crypto: acomp - Add bit to indicate segmentation support.
  crypto: acomp - Add trivial segmentation wrapper.
  crypto: acomp - Add API to get a compression algorithm's batch-size.
  mm: zswap: Store the folio's node id in the zswap_entry.
  mm: zswap: Store large folios in batches.
  mm: zswap: Batched zswap_compress() for storing large folios in
    batches.
  mm: zswap: Refactor and optimize zswap_store_pages() batch operations.

 crypto/acompress.c                  |  53 ++-
 include/crypto/acompress.h          |  64 ++-
 include/crypto/algapi.h             |   5 +
 include/crypto/internal/acompress.h |  10 +-
 include/linux/crypto.h              |   5 +-
 mm/zswap.c                          | 635 ++++++++++++++++++++--------
 6 files changed, 592 insertions(+), 180 deletions(-)

-- 
2.39.5


