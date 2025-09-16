Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB87BCAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 07:15:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1955E8E0008; Tue, 16 Sep 2025 03:15:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 146728E0001; Tue, 16 Sep 2025 03:15:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 035098E0008; Tue, 16 Sep 2025 03:15:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E13318E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:15:28 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 82B101DF71C
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 07:15:28 +0000 (UTC)
X-FDA: 83894252736.02.7284006
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	by imf15.hostedemail.com (Postfix) with ESMTP id 87A59A0012
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 07:15:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b=gzCEr1zr;
	spf=pass (imf15.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.143.35 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758006923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bXxgqdEdSOzYOwQL2w5UISvG0TGek76RcB1QClzkCaE=;
	b=nGuRnvE69g/bmecFiQsXTHKnhXIbI8izA1EhOEGSfehQJi5TfWRiuGClcJCzma7J66YgxF
	0VbA+/pTfYTOGJyzTqJlVYmqksn+kCUryIFQ/fal4crXhGiUIzRoXI6u3G3/odeeocsyrl
	9uHUCsmvVMEO2J7Qt+d9mdBNSnXXJ6s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758006923; a=rsa-sha256;
	cv=none;
	b=qmIRNXy5wotn7I6U91gel6dlY8yUTtdH1J2iA/5DImoHjF4RRtnBW3bgQdkDJ7K8ULw/e9
	Nu3nk4zdq684TAMbb/4dc+bWzqs4t8OCfcXMGpki3TxfrlkVF+7vIsY888clpTAdEBbfxl
	Yd9fmUxehK3aCNpqooopYsJ16+mNEHE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b=gzCEr1zr;
	spf=pass (imf15.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.143.35 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
Received: from pps.filterd (m0134423.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58G6r2OR028366;
	Tue, 16 Sep 2025 07:14:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps0720; bh=bXxgqdEdSOzYOwQL2w5UISvG0T
	Gek76RcB1QClzkCaE=; b=gzCEr1zrEMw5QI4COvPhj9vnEAdw8clFMy0uUvpy+T
	LDc8ZLjsAVUmtceIeVN+zJo/fqj4P8qMCObtEcq9YhowTfiSiziEGx2oonZEDsEO
	gp/TqzMa/Q4Z3eqG1Vrm3zfKL7cb1vAQ0hL+AYUTnpwZ0Q6SSdvR/t8CrE2n84yo
	1wFUKjP4OcHjs5RBXHKZSd7vTk8xIbFfM/BAgvR9SBs2u6rywcKllWP0rNSbKAm0
	ELnhL6N6mDA/1fRZ4Q/8sgcQYCzDj3sLIvQ9QHZtYRmq0Wvg0tqNpoK7bRJIsCl1
	uzFc6PajWs9xu5ZGsgUO7VdFWbCCMuQNs+cnP1vkIPLQ==
Received: from p1lg14879.it.hpe.com (p1lg14879.it.hpe.com [16.230.97.200])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 49730x84ps-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 07:14:28 +0000 (GMT)
Received: from p1lg14885.dc01.its.hpecorp.net (unknown [10.119.18.236])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by p1lg14879.it.hpe.com (Postfix) with ESMTPS id 0FD0B130D0;
	Tue, 16 Sep 2025 07:14:27 +0000 (UTC)
Received: from HPE-5CG20646DK.localdomain (unknown [16.231.227.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by p1lg14885.dc01.its.hpecorp.net (Postfix) with ESMTPS id 9B2B980898D;
	Tue, 16 Sep 2025 07:14:21 +0000 (UTC)
Date: Tue, 16 Sep 2025 02:14:17 -0500
From: Kyle Meyer <kyle.meyer@hpe.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: corbet@lwn.net, david@redhat.com, linmiaohe@huawei.com, shuah@kernel.org,
        tony.luck@intel.com, jane.chu@oracle.com, jiaqiyan@google.com,
        Liam.Howlett@oracle.com, bp@alien8.de, hannes@cmpxchg.org,
        jack@suse.cz, joel.granados@kernel.org, laoar.shao@gmail.com,
        lorenzo.stoakes@oracle.com, mclapinski@google.com, mhocko@suse.com,
        nao.horiguchi@gmail.com, osalvador@suse.de, rafael.j.wysocki@intel.com,
        rppt@kernel.org, russ.anderson@hpe.com, shawn.fan@intel.com,
        surenb@google.com, vbabka@suse.cz, linux-acpi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
Message-ID: <aMkOCmGBhZKhKPrI@hpe.com>
References: <aMiu_Uku6Y5ZbuhM@hpe.com>
 <20250915201618.7d9d294a6b22e0f71540884b@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915201618.7d9d294a6b22e0f71540884b@linux-foundation.org>
X-Authority-Analysis: v=2.4 cv=KaTSsRYD c=1 sm=1 tr=0 ts=68c90e54 cx=c_pps
 a=5jkVtQsCUlC8zk5UhkBgHg==:117 a=5jkVtQsCUlC8zk5UhkBgHg==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=MvuuwTCpAAAA:8 a=QyXUC8HyAAAA:8
 a=_fVqCaFjEFPFEyr0NywA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: aDOt515-H__Hl3R9V07wPh5jXDwBK7cM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDA2NSBTYWx0ZWRfXxAY3BPV9SJA6
 yOok/WQpFEjJYGXprFhNvjR/MSlEPJF8gQD+4iCExdPx/MUr0x833mkvOuHKlTeKIBoAjRLyExx
 T1D3ZDzlDFNSXfVciL1ZS43a5lWeWLSl+Qm5BBGhojcd3MR3tK4dnjyM1r+8nfdur5U22Z1nWnp
 BOqPtmAezj/CPAQTwQOht+sjD82CQtE5HH8kUuszEVLtcQuoNZwYgjGbEZRSx7ud5T+cs9Ajrlo
 Zdr3sFE7xNwfT0kvHltnSQk86vhd+J9mFAIfo4GXZKolTeRqPTORud7OzdD9Ryn2qLB7uc5993r
 egpIJ+gjBaKykyay/cEipeEu8sl4ZXGHcWsvQBz4WPsQmGWyLsNUcS7ntdTgf3z+JbhL/mpeyzc
 Et4+cJQw
X-Proofpoint-ORIG-GUID: aDOt515-H__Hl3R9V07wPh5jXDwBK7cM
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 phishscore=0 impostorscore=0 clxscore=1015
 spamscore=0 adultscore=0 suspectscore=0 malwarescore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509160065
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 87A59A0012
X-Stat-Signature: 9b5joucnyutw76xsqcszfe8p34uu1yz7
X-Rspam-User: 
X-HE-Tag: 1758006923-378493
X-HE-Meta: U2FsdGVkX18Ac8dAhf/qSxRGh/D+qNkQfNl3YLNmAhCYooDvUW1YyYBs9LFBqX0rUpYgGKXA5mlIgbo8pvnZvIy8X1SIIBJQiaJB0kpwOmMe3rjmBAC8GGBRe8aEf7V4t5/PPJrQvvIIJFmOMN1WTOXnJXtdgJY8TcznRJYHokgpGm1/g3ZrE1rZG9HOUNpHCFzpVPry82sd0RY3ipYBBymAkspwwq8IlPqBJxUE6W9zosOFQeUnPgwWj8g6D2r4f6auFJrJ4F/YJq7tG2hPo25FhEgFlUxl3EII8OIS2gL1gZV/D4LvDVMs+geWBHQK0yZhjzJfQI3tRpwCQ82KaL29gOO/uzgzyW+rc7R/i3ysoLjbyB07H9wW0wvw+txhAlBVPIWtt0i/qIEZYuxtxWr7cdEhljaugbLVj+LJvl4rVhiTT9MYyrk3/l3lk351y9LBpVxx0WpSkJTQt+/0bBwuuB+YkNhYKdeFLMCqM4V7jmAv7XdtTfEAQ1hCV8tdQ8x57x0ef2C+92Yh8eYJzsTwqm33tmlB6IRR0kpLa3qS8SH06WDs7+xgsuRjTtIuDju+7tatTBhU7498PlH7Q/RmyQFSAtvrWiRyr6T+VsTjxE3f28LF2eVzrqLV+Q/c+HLwz9+coT5rweizdbC/Q+6+/wfDVQjxGmHYItwWIu7HaSuA7097+x7WI4+KNaGiW21uba7vD6BAAiWlLuN5bO0ndpO0j019jtbhP6D7+Z9p6pL5k+MXE/UNYyeTFXOHEYjjIuFtDGmJAUqTQVVfeMopnR5cCzD/m4gt2MFiSbM9KoKR52ChKMji5/LFBqs64rqYP6GECdoDBjxId6PbGRceWMS2h7TIpz52idRZ9++IlgDepRy5hoc1lmid7len3lNx8woAQ2lZaMBtx0lpt4zwjjoJX5sbbfrKrkKvreUmVyXnq5ZxEahp3a11+LL7ebMputpPaWSP7l8o7ts
 VdujlI7D
 vMY+BkCvl0tf0JsZIrSt1mwpoX53zjfuh45QqxGlv0xlaaYqOFNRMRfbxo9dYbxYQ5Ow/zc3BsgUF9smdHzTmOwurH5g1S3ICZR2lRCCJwb0Ax9913c8CHdrPnXP0DauXsJM8v+IVgENMtJe7DUE4DvmxirlB6N4XYrCtTmxfnhvHd0AAV0Dc8hhD4qar1VXlGqfzxfEkraEZ7y2aVifXAfkcdgqag/uBi+6k3DrzQ9/BobbG1TSlKuqerWuR8xiM7Kya60XqrFwBl5j8XmJ5Lmwgb8zryuk7jMw/RCDBVynT5J4nMPpdPzuceGZ9TjwSbQxuvoeoiNG1qeYFwzxk2BtL5jpZP8I1vPgs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 08:16:18PM -0700, Andrew Morton wrote:
> On Mon, 15 Sep 2025 19:27:41 -0500 Kyle Meyer <kyle.meyer@hpe.com> wrote:
> 
> > Soft offlining a HugeTLB page reduces the HugeTLB page pool.
> > 
> > Commit 56374430c5dfc ("mm/memory-failure: userspace controls soft-offlining pages")
> > introduced the following sysctl interface to control soft offline:
> > 
> > /proc/sys/vm/enable_soft_offline
> > 
> > The interface does not distinguish between page types:
> > 
> >     0 - Soft offline is disabled
> >     1 - Soft offline is enabled
> > 
> > Convert enable_soft_offline to a bitmask and support disabling soft
> > offline for HugeTLB pages:
> > 
> > Bits:
> > 
> >     0 - Enable soft offline
> >     1 - Disable soft offline for HugeTLB pages
> > 
> > Supported values:
> > 
> >     0 - Soft offline is disabled
> >     1 - Soft offline is enabled
> >     3 - Soft offline is enabled (disabled for HugeTLB pages)
> > 
> > Existing behavior is preserved.
> 
> um, why?  What benefit does this patch provide to our users? 
> Use-cases, before-and-after scenarios, etc?

Thank you for the feedback.

Some BIOS suppress ("cloak") corrected memory errors until a threshold
is reached. Once that threshold is reached, BIOS reports a CPER with the
"error threshold exceeded" bit set via GHES and the corresponding page is
soft offlined.

BIOS does not know the page type of the corresponding page. If the
corresponding page happens to be a HugeTLB page, it will be dissolved,
permanently reducing the HugeTLB page pool. This can be problematic for
workloads that depend on a fixed number of HugeTLB pages.

Currently, soft offline must be disabled to prevent HugeTLB pages from
being soft offlined.

This patch provides a middle ground. Soft offline can be disabled for
HugeTLB pages while remaining enabled for non-HugeTLB pages, preserving
the benefits of soft offline without the risk of BIOS soft offlining
HugeTLB pages.

> > Update documentation and HugeTLB soft offline self tests.
> > 
> > Reported-by: Shawn Fan <shawn.fan@intel.com>
> 
> Interesting.  What did Shawn report? (Closes:!).

Tony or Shawn, could you please point me to the original report? Thanks!

> > Suggested-by: Tony Luck <tony.luck@intel.com>
> > Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
> >
> > ...
> >
> >  .../ABI/testing/sysfs-memory-page-offline     |  3 ++
> >  Documentation/admin-guide/sysctl/vm.rst       | 28 ++++++++++++++++---
> >  mm/memory-failure.c                           | 17 +++++++++--
> >  .../selftests/mm/hugetlb-soft-offline.c       | 19 ++++++++++---
> >  4 files changed, 56 insertions(+), 11 deletions(-)
> 
> I'll add it because testing, but please do explain why I added it?

Thanks,
Kyle Meyer

