Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 188BBD2D108
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 14:10:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 643DF6B0005; Tue, 13 Jan 2026 09:10:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F13F6B0089; Tue, 13 Jan 2026 09:10:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F0736B0093; Tue, 13 Jan 2026 09:10:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3BF176B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:10:29 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DDCDEC04DF
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:10:28 +0000 (UTC)
X-FDA: 84327125736.23.CE09704
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf05.hostedemail.com (Postfix) with ESMTP id D098E100007
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:10:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=PGI8b+UB;
	spf=pass (imf05.hostedemail.com: domain of "prvs=9473463a0e=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=9473463a0e=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768313427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JAuKhkCrAHpF94tqXXlAdNjuzgLDHJZz0Y/lLs95e8g=;
	b=p6PUQE/PkDjNH3F7DiJJlWGS3Bpk7hfkk3Bvws4ssupBx3GvQQMv21+XxBWwUtayffYrqo
	j8lZ7HZVffmHQwa34yHxYKRGf8/xeMB1ykPM61PUnbifoTl31m2dU3kCsls0xLjSQHQ7iq
	cKM3teup7axQ9LnOILX82CvK6Xki3Xk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=PGI8b+UB;
	spf=pass (imf05.hostedemail.com: domain of "prvs=9473463a0e=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=9473463a0e=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768313427; a=rsa-sha256;
	cv=none;
	b=37A20Yn5AuSlvR07I7W6CbV+HNuwtdSS9AmsDogXsGr/oM08NpO83cEyv7ycRF2h8SZn5j
	0Yj0e/P9i/yUryxaNc2P+KAQLF/SbNj473dMl+dSa9t0PFZfLJRvVscZdTukSZY32eYrtt
	c0MOZnvL/o9qFrJ8/O9ad41In+LICSA=
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 60DCArKX1832210;
	Tue, 13 Jan 2026 06:09:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=JAuKhkCrAHpF94tqXXlAdNjuzgLDHJZz0Y/lLs95e8g=; b=PGI8b+UBtizs
	1dhAPX0qbs4Uc6SNgynZq370y0kqx20f/msyHogB0OatdczXL1xCX6zkdfpl4okV
	X0WhWjrwNaBXNc0mahO6rChgXtLS5sbatRPTTJWaxcByREJvDEi52Cv+x7ajDH50
	/EAowJ7XGdKMoIo3s1mbR125/xh+dPfuhw5ZevoY4CUGCcQ3rPsGJAgaInMEKj9F
	kwNfLF1nsyJfR2FS4l/BPo6u0mfU487v7iGjb3fXh+O+i5YunXMKOXL7RNMsftPn
	5stTVV/lb0MsX8J+XRCZIYzUycOyA0HeWvQxHnWZN355vCCf7qtqlteND00a63OC
	ZUEevcKp2g==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 4bnagnd7qu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 13 Jan 2026 06:09:44 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Tue, 13 Jan 2026 14:09:40 +0000
From: Chris Mason <clm@meta.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
CC: Chris Mason <clm@meta.com>, <jasonmiu@google.com>, <graf@amazon.com>,
        <rppt@kernel.org>, <dmatlack@google.com>, <rientjes@google.com>,
        <corbet@lwn.net>, <rdunlap@infradead.org>,
        <ilpo.jarvinen@linux.intel.com>, <kanie@linux.alibaba.com>,
        <ojeda@kernel.org>, <aliceryhl@google.com>, <masahiroy@kernel.org>,
        <akpm@linux-foundation.org>, <tj@kernel.org>, <yoann.congal@smile.fr>,
        <mmaurer@google.com>, <roman.gushchin@linux.dev>,
        <chenridong@huawei.com>, <axboe@kernel.dk>, <mark.rutland@arm.com>,
        <jannh@google.com>, <vincent.guittot@linaro.org>, <hannes@cmpxchg.org>,
        <dan.j.williams@intel.com>, <david@redhat.com>,
        <joel.granados@kernel.org>, <rostedt@goodmis.org>,
        <anna.schumaker@oracle.com>, <song@kernel.org>, <linux@weissschuh.net>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-mm@kvack.org>, <gregkh@linuxfoundation.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
        <rafael@kernel.org>, <dakr@kernel.org>,
        <bartosz.golaszewski@linaro.org>, <cw00.choi@samsung.com>,
        <myungjoo.ham@samsung.com>, <yesanishhere@gmail.com>,
        <Jonathan.Cameron@huawei.com>, <quic_zijuhu@quicinc.com>,
        <aleksander.lobakin@intel.com>, <ira.weiny@intel.com>,
        <andriy.shevchenko@linux.intel.com>, <leon@kernel.org>,
        <lukas@wunner.de>, <bhelgaas@google.com>, <wagi@kernel.org>,
        <djeffery@redhat.com>, <stuart.w.hayes@gmail.com>, <ptyadav@amazon.de>,
        <lennart@poettering.net>, <brauner@kernel.org>,
        <linux-api@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <saeedm@nvidia.com>, <ajayachandra@nvidia.com>, <jgg@nvidia.com>,
        <parav@nvidia.com>, <leonro@nvidia.com>, <witu@nvidia.com>,
        <hughd@google.com>, <skhawaja@google.com>, <chrisl@kernel.org>
Subject: Re: [PATCH v8 14/18] mm: memfd_luo: allow preserving memfd
Date: Tue, 13 Jan 2026 06:09:23 -0800
Message-ID: <20260113140927.1074142-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251125165850.3389713-15-pasha.tatashin@soleen.com>
References:
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c085:208::7cb7]
X-Proofpoint-GUID: s1CCR8UZO73_rjnu6xSP054ZxjCtViBV
X-Proofpoint-ORIG-GUID: s1CCR8UZO73_rjnu6xSP054ZxjCtViBV
X-Authority-Analysis: v=2.4 cv=Q7LfIo2a c=1 sm=1 tr=0 ts=69665228 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7ipKWUHlAAAA:8
 a=m6o-FXAq6gqIrf99m5QA:9 a=gpc5p9EgBqZVLdJeV_V1:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDExOSBTYWx0ZWRfX5CNvvrAwyW4k
 6EJSeAG0c5Q8z/80YV/NCKjAgvqtiRw50RPHu1phI8kbtyoXdGOgv54X5julOdiLcAEzOg5KQS6
 RvxQd20x9ZD0l2C/HYop8b4WFgcvXUck2DzwvWD/phFzvC9L9eNVrPP0q4WNMy9z8xEisOuJ+kN
 hxtk0eQG7jhUVSm/31U9ZAYzwxclEpfPSwCpn5D0v9ehyVT4vTsy95GsohsdPZ17v0emPCFN9td
 TJopv5yHAcfD8mF5H9fn1sHqTOse9mbVi+41BVtWkoV4Wuh/PmVG0gCfi3hkfgrApCvH3lQph6y
 BPD81K3pD1tMd8f+PJrOFBsCCnQ76RtFjQ0tKs5YdGY9YFL0RwiF90/2JAocm6dRdIh6/wR6y/m
 J3MEQTMiRubinot5H/QcGHq0e5VbLOhUxmj04I28+SQr9rkNx5twsKT2dPvA3M5cz6zJj9bDn09
 pAo2hmSM3zMQdfaQwmA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_03,2026-01-09_02,2025-10-01_01
X-Stat-Signature: odn4imwe5ox5ngq6xjwczfet1d7t3kfk
X-Rspam-User: 
X-Rspamd-Queue-Id: D098E100007
X-Rspamd-Server: rspam08
X-HE-Tag: 1768313426-363601
X-HE-Meta: U2FsdGVkX1+jokxMx1E46IEaw/RZpFmBVtuPnEHFReaEt+iQlvI0xctjHYT1Wy/IwmYxLDjEISamflbywWDZu2bIgmRE7mdwOd4I/2oK0m1iysZR+1NiwacI9j5Ljh+vljQWRvgfm2Jh0ndnktDqi+s133ahhKoXerSMc/EioQgzL5YGogr75ByIw1X6lIySbuDnQDpbSD/dBwZzJ76apPqsoSvjpmg/3rBJaCkzFt9TOvPpb9hEf23QJmLOB36vbSy8RHWcvVPw1ZbNQmYv+a2jzN212VghNDeWckpkNaxtUP12H+YbtM9TWO/jjeg9wy3GKJrkC4SirzoY2fo2fdbQ1/mh2YNQ5arA46FrOGNVOVPI8xliiRBA5oaAT9ipPRFph8lKf4h1ovsR2+DHgebZP+SXZ8MwviRzuhs/kJHzvhcTARS4O9zf9gb6F525gvaG5ds+8xHdXVL/4+iqGib2halgMADAluAPMHc9biPATB8OyJoqnWLKq8t3DJuAKSf73Q5mkv8XIek6jwsPwARRtpNo83igrWRzEmj2Bdm31a3107djHN4C9R6P6+Stbcspdex3mDHz/HiC5DtiPAvlHKGw0P+2lr7W6Y/5ob4MjNldNsVMa9RxV4CPBvSNiyc9VW7ROdHbLRq2iDEhH6RnhC48FKh+uGTxiwLry8hIOntXUBJeyyXkp4DAIvHN8ZZz15xF2JQXlqYcOAfDnA93hafRgnwBwtmQi3ctHLkAD51oHWhb3qnCv55NxBJJ7qfi3C7iT1O45noMgutP3ZeFtKltqx18YjD8c9iwDJFK9XygFK5N1gA9XUt5bEa5j2HjxQ+R7ZzDBGWpA5k4USWuAEBOEf8xyXsKVnCfuyrvDBcdy9Z07sbSGBzBmPLlzJQsdTcWhVEc8lo4skVfJOA5rFn6TrmE+5e5sRV5SnM15nAOXQxMvneBiwbYCxdA+QmdcoZIiXt45xgn/lv
 A7usG8yF
 1Iwqf2lk7pbnxz+fRFL+xu07VVHNG27XhdMzHWd/7JmAuBkDrMxRpTePAQhGTdxA2eCaz7rdeDLJaT4oZEILtnplCY5TkRPPnRXnk3IsBdprDHk+yOPwTo1hZtq+4SZUmoTv4fe/azXvbPLeXcp1j9pS0xd/MKketUsPayA/E77o/wvmzOoyzIjObX/qGTyoBc5K6dzkf4bgdhRB5HW9kjHa7ipgnvi2SjxuxLrxeFPd/v/pyxbuD5IOvdxX8xVlys4WtPbk1rchmyQnTU20/dHeRcFsAfO2/cxPRdq/rb0ySlKlkLTH9Qdas/UmVn0vY+kCP4iPRuJWDzlBbqV4tHhGPVfqpzonT+zrZzpSdsDJb6HbbhYuMXexKvpYujZhyv8n0w04wg3gzBB12V0N467RzSd6keK7IyuYh5ZSHaNSXNW+ZzlxOuGo8kokP05Tth4dooEoYFLqa6lhDvehG6rU0EWa/X6wjPs5GsP8pBfxR2EGtg6nHUbUuqtSvYFji74uv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Nov 2025 11:58:44 -0500 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:

Hi everyone,

I'm running the v6.19 mm commits through patch review automation, and this
commit was flagged.  I don't know this code well, but it looks like it
might be a real bug.

[AI review output below]

> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> new file mode 100644
> index 0000000000000..4f6ba63b43105
> --- /dev/null
> +++ b/mm/memfd_luo.c

[ ... ]

> +static int memfd_luo_retrieve_folios(struct file *file,
> +				     struct memfd_luo_folio_ser *folios_ser,
> +				     u64 nr_folios)
> +{
> +	struct inode *inode = file_inode(file);
> +	struct address_space *mapping = inode->i_mapping;
> +	struct folio *folio;
> +	int err = -EIO;
> +	long i;
> +
> +	for (i = 0; i < nr_folios; i++) {

[ ... ]

> +		err = shmem_add_to_page_cache(folio, mapping, index, NULL,
> +					      mapping_gfp_mask(mapping));
> +		if (err) {
> +			pr_err("shmem: failed to add to page cache folio index %ld: %d\n",
> +			       i, err);
> +			goto unlock_folio;
> +		}
> +
> +		if (flags & MEMFD_LUO_FOLIO_UPTODATE)
> +			folio_mark_uptodate(folio);
> +		if (flags & MEMFD_LUO_FOLIO_DIRTY)
> +			folio_mark_dirty(folio);
> +
> +		err = shmem_inode_acct_blocks(inode, 1);
> +		if (err) {
> +			pr_err("shmem: failed to account folio index %ld: %d\n",
> +			       i, err);
> +			goto unlock_folio;
> +		}

When shmem_inode_acct_blocks() fails here, the folio has already been
added to the page cache by shmem_add_to_page_cache(). Should the folio be
removed from the page cache before going to unlock_folio?

Looking at shmem_alloc_and_add_folio() in mm/shmem.c, when
shmem_inode_acct_blocks() fails after the folio has been added, it calls
filemap_remove_folio() to remove it:

    error = shmem_inode_acct_blocks(inode, pages);
    if (error) {
        ...
        if (error) {
            filemap_remove_folio(folio);
            goto unlock;
        }
    }

Without this, the folio remains in the page cache (counted in
mapping->nrpages) but info->alloced is not incremented (since
shmem_recalc_inode is not called). This could cause shmem accounting
inconsistency.



