Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A965606A332
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 05:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DY52BRJq
Received: by kanga.kvack.org (Postfix)
	id 5C2816B0669; Fri, 13 Nov 2026 00:17:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5730D6B0665; Fri, 13 Nov 2026 00:17:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43B6A6B066D; Fri, 13 Nov 2026 00:17:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 167956B0665
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:17:23 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9AED51A01AF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:17:22 +0000 (UTC)
X-FDA: 85428937524.23.51C6DF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 046DE140007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:17:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DY52BRJq;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794547041;
	b=B9NaHok/TKUUVrs5UmOdjQmfQpM08FPAVRpFKp8EG728uL1ctO4XvuCLStDBtO/F9m8Z6T
	y++6ARw8lSihdcbRcdqBTWYzeKOmRpv6p5pdGWWFccXFep6PUSn24ijV1805kHgb6frvwU
	WmNbct3PwQ4BFNF4DCilZNFRLFEuiSw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DY52BRJq;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794547041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=O0KFYW6GQeuL89YBqW1qiLu+Kr/wUVvd+oaMVAmTWFA=;
	b=4kOw0u6g6y+6hYgGZ6mvr8qDBhVmG7619+f6ZOMd44ZzN2oldd6GiDdiI8K8aSwQVJyAmK
	d+Ck2CUwOZ2Kt5NVM1mJWbnqv2rIrH4GC+h4uvCgFb7n9BSmOpiQLeNpLdoSsrwLxxYcJb
	Yj9Pp6mJolxvMSEAjKVx+SyHFd/bbRs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C818541691;
	Fri, 13 Nov 2026 05:17:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603121F000C4;
	Fri, 13 Nov 2026 05:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794547039;
	bh=O0KFYW6GQeuL89YBqW1qiLu+Kr/wUVvd+oaMVAmTWFA=;
	h=From:To:Cc:Subject:Date;
	b=DY52BRJqtabD4Q+zldmRe3wCwGrf8R6w8sFAQKSmpKROsaMSzyoGsVSUAHcAJWXM8
	 bmsqZgCqc0rnuMdF+sr8bPknfcoMOqd4upTCiSZEjG7lYB5dc+YvBLnin78hTXsS4Y
	 2b0d41jVaGi05Qo65rhPyHd3VdzOcMgf/fMDcCjOg8x2iruEXncA0sAz1U7x+XS8sn
	 pUrDZFx+NdXueHdq+hFgkNVB1/QwqD1KIQWeaijAmGVA98TI/LX4Kxtph2JG/a8+SD
	 KcLQDBIAbhnj36SiS0n01TKZG+3qC+tngakpUaHcQJURT5AtP8PBapfA4tvvtMRM/B
	 zDttYkoi8uYhg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/4] mm/damon: add lru-active probe filter type
Date: Thu, 12 Nov 2026 21:17:06 -0800
Message-ID: <20261113051711.89274-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 046DE140007
X-Stat-Signature: cp9ea1cmbnazo4wk43mqrhsyc4hreoxa
X-Rspam-User: 
X-HE-Tag: 1794547040-733860
X-HE-Meta: U2FsdGVkX19eupgAqcsOqnUOtiLUoXs/B3FGRsDKkTpnMseFN7iakUyKAlMwYKlXHUUxe6DKbIRep1I4pLc5WBh/+GpVZfC6e4GP/xwiAOaMkIi5tM4ZH2JPdlKfu6sWl4NZlKNoeNEjNgOFqFgie1SoLx2BN4G+fG5yNC0T6F0+dkMShTpVGhi5vyV4ERIT67xXcjPxUaUiugqsXELX4j8hxt+rOCAOx4InyYwL8r/HQnhW285P3+o0O6OgEy+ZBSSM6tsUPE62KUWQUhM2R9SyX7NUj8PG/Dfdy4BbiwAJrRn09nLonrt+/Mf3fPbX0H/ucSosg77OkUYL0OSXoEFVN4gCRoSQ/iLfoS6vuR/JMh9UmvMQ5LJv7GZEZlTmpk0fow/NfUWVvvrhd4seTiFVSSGYQDgzIXU3AQquu+Mfvzm5q3gLRt1PfF1yccytLjUKw1YDKl9qwW3Be5J2Uf62geieLGF6g4xrMquVDQU6s65BNRcgSAo2kUui+jsDTaeriK9usRdetBdfeu7ncTiNXRNukJoFkqBnsXEw4TyiPsOPIL4DjFs7pUCcPAKFw1t5mDrmDW0m6+ESx4IJBAvfTs5djuXoHuUlBbOFxQ/hmfceKZwwSb5iI8HREKc3euyE3sxJ6FE92fmoGl+hSh/RitFZNqVJl4EEzhKFudT8yFFCKEZ+vfAMAVQ33583+YoHmjRjPY8JCIeLLs9wn4d/bFVwstmX0cN6RzycsZ23axEs+4iPUj8AzPM9vJBw8RLa8NdVmRtJUJzLOU4exMyG2X1bOmCml/z/JU16VOQ2MMrRfkBg+1Tn/FThsMtJ7xGcvY7UVqyECrKGv+0ltdfwo9Lpl5PvyCXyuR1jZLN0Tyf9F2y2Yi6xlC9WFheAD0N7jVXO60uf41rqJQ6OyW8K9Wh6ErCA+ei2Aqf+gDtTNvEXhHMYTKwS9qlPCPaFJWnYQBHwihtJvdBQVi8
 QYqu9Kll
 tEFf/OxESxtAjYhfGVImJwLwq8jlpUPYD1Te1zLfp5Z1PgJzwjy2RczKPtgHumjxalo4cc63/A/XDOi/D+EuMv2AaPUIdLTjKw9FvQqE2CKhZYXbPmo0AqojvRCWvyxIrtKjNU9ggg7ufeq3HU/jopr5C5pR/6vcTIFwIBjorGlp9R2nxLuN9qgbWTztV4Le6NN1IL6Renyt4498Bqj3G/8aYxyIQ4Pnra5wF8e8DakYDFCe8CNm2avt1yG9m1mmjavh2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The LRU-activeness of folios is useful information for understanding and
optimizing the system.  DAMOS ops filter therefore supports filtering
memory based on the information.  Using it, the information can be
extracted in the folio granularity.  It is precise but expensive.  DAMON
probe filter is the complementary way for getting the information in
region granularity with much cheaper cost.  DAMON filter does not
support LRU-activeness based filtering, though.  Add the support.

Define new DAMON filter type, DAMON_FILTER_TYPE_ACTIVE, on core API
(patch 1).  Add support for it on both vaddr and paddr operation set
(patch 2).  Extend DAMON filter sysfs ABI to let users configure DAMON
filters of the type using a new keyword, "active" (patch 3).  Finally,
update the DAMON design document to explain the new type (patch 4).

Test
====

Confirmed the functionality like below.

First, start masim [1] to generate a ~476 MiB hot memory region.

    $ ./masim.py run --config_file ./configs/stairs-500mb.cfg --repeat 10

Second, start DAMON to monitor data access and active memory ratio of
each region using DAMON user-space tool (damo) [2].

    $ sudo ./damo start --target_pid $(pidof masim) \
            --probe --probe_prep set_pgidle \
                --probe_filter allow pgidle_unset \
            --probe --probe_filter allow active \
            --probe_weight 1 0

Show the monitoring results.

    $ sudo ./damo report attrs
    heatmap: 00008[...]82222222222222222222222222222222222222222222222257777789999998888888874444445[...]8
    # min/max temperatures: -1,580,000,000, 100,002,000, column size: 62.841 MiB
    probes
    - prep: set_pgidle, filter: allow pgidle_unset (weight: 1)
    - allow active (weight: 0)
    intervals: sample 5 ms aggr 100 ms (max probe hits 20)
    #   size         address       age           probe_hits
    0   253.047 MiB  85.984 TiB    15.800 s      0 0
    1   4.000 KiB    127.984 TiB   15.400 s      0 20
    2   120.000 KiB  127.984 TiB   15.300 s      0 0
    3   1.450 GiB    127.407 TiB   11.300 s      0 0
    4   498.738 MiB  127.409 TiB   11.200 s      0 0
    5   500.273 MiB  127.409 TiB   11.100 s      0 0
    6   502.055 MiB  127.409 TiB   10.900 s      0 0
    7   461.926 MiB  127.411 TiB   6.500 s       0 0
    8   351.754 MiB  127.410 TiB   1.600 s       0 0
    9   497.930 MiB  127.411 TiB   0 ns          1 0
    10  8.000 KiB    127.984 TiB   0 ns          6 0
    11  476.340 MiB  127.410 TiB   1 s           20 0
    memory bw estimate: 0 B per second
    total size: 4.909 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

The second (idx 1) 4 KiB memory region is not accessed for 15 seconds
and the page for the region is on an active LRU list.  The last 476.340
MiB memory region is accessed for each sample for the last one second as
expected.  And nearly all pages of the region are not on an active LRU
list.

[1] https://github.com/sjp38/masim
[2] https://github.com/damonitor/damo

Changes from RFC
- RFC: https://lore.kernel.org/20261108191615.113362-1-sj@kernel.org
- Add test results on the cover letter.
- Rebase to the latest mm-new.
- Drop RFC tag.

The test section and the changelog can be removed from the final commit
message.

SJ Park (4):
  mm/damon/api: define DAMON_FILTER_TYPE_ACTIVE
  mm/damon/ops-common: implement DAMON_FILTER_TYPE_ACTIVE operation
  mm/damon/sysfs: support LRU-activeness based DAMON filter setup
  Docs/mm/damon/design: update for DAMON_FILTER_TYPE_ACTIVE

 Documentation/mm/damon/design.rst | 1 +
 include/linux/damon.h             | 2 ++
 mm/damon/ops-common.c             | 7 +++++++
 mm/damon/sysfs.c                  | 4 ++++
 4 files changed, 14 insertions(+)


base-commit: e055da336413b651d1e23d438bb5430f9350d3f8
-- 
2.47.3

