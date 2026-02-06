Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F47FE9129F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 04:31:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DC586B0096; Thu,  5 Feb 2026 23:31:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76A036B0098; Thu,  5 Feb 2026 23:31:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 622576B0099; Thu,  5 Feb 2026 23:31:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5425F6B0096
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 23:31:58 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1EC621C6B9
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:31:58 +0000 (UTC)
X-FDA: 84412759116.08.29904F9
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id 28CA2C0006
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:31:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=CCKR1WeQ;
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770352316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TvxtH1ZKMMdKhnVfUvoSmUSKImbjL0zsj7oE27BYgzY=;
	b=fAewOc56Q9pv1RjGzIwqIVolVu3Kn8ENkJlavJ4IBbp9Oi0VvZ29zOWz0BZ4/AJ13O1r8M
	Jn+wU2sSvEogsoNxWM9rrAION/7PclltnD1hrHSt8z1Zoq2Xn3KDZ359W4xoIlHJ8Ar+uB
	0QPZkGZE9MF+iztoncFEs8PiBJfwkSI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=CCKR1WeQ;
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770352316; a=rsa-sha256;
	cv=none;
	b=XbOj6Lq3kcq9/ebn1h+Iep3Iy2/CmDdcjw+kXP9WJeQDdRe8KIyS1RHh3QBw4K3lrHjrqO
	ZzJSd5H5TPLtszF/SMnNbN6MWdxTH2zwAhlAKgytdEnz2EiDvq9p9QEm1223zVw8CUZNY/
	Nu/dwPXc5dhbgrVm3nqxtxbxubtckHI=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a0d67f1877so1744225ad.2
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 20:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1770352315; x=1770957115; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TvxtH1ZKMMdKhnVfUvoSmUSKImbjL0zsj7oE27BYgzY=;
        b=CCKR1WeQXrBFFkFmKc1MQh/QDNp8bMzzNBewtgXU5rt+AiAw0AOyQ4dMrfgn/jVDIX
         vOoAiTSoBoodTiaYkqunXMJDnCsMJPLlMh9kWW68Mi2+obA3335JdATaRpNoOlR9XnSq
         M1BustyRgq7u/2FdwvuydDgFlhSI1l8QbCDvo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770352315; x=1770957115;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TvxtH1ZKMMdKhnVfUvoSmUSKImbjL0zsj7oE27BYgzY=;
        b=oG6Vio8CaykhjNmMxUWIIkss385eKyQ2a9lfwShLzgCUzo5Xl1qk90LR2k3e9ZD8nR
         peXEcIXzpRwqO9OlWch3HyzK97L2VJiuZw3t3eQfmxkYZmcmjQVd2Y959wlPr4S7cCRN
         AT00khLA9MIAikArrXUC4jBvfCUfK22f+T86PpUvBJCYt+sDxnmDtshn8sq7800oqL2g
         MWXYyJH9UY9vjeYwEWpl1gk+nvKGZzqLTN2zSYjkIPXUgo0QVkgpzI/K3AsC/Z2XWPxu
         jukibogn5HK7AVhTRTDRG8+3ZID9HWwmp/sa/4F+U4tMxfuHJM8by9w0grCV1pZm0/T/
         /Oxw==
X-Forwarded-Encrypted: i=1; AJvYcCW4UCXSrYq+DZY1nky0sr/3XMEOvNDMoshqpb3UK4PcpTQMHbtbqrYbRWC8cTPtzlxHvKls12bRiQ==@kvack.org
X-Gm-Message-State: AOJu0YyCFoViKvj0QLRYKdkK4oEeW9DeNNay3/ePhiRd5i1kr2IE32jj
	JXN/ZBLA3whICSRjZipghwcK2eWoHiZ++7CpH5UbeEn69BGZ5FA/NjeMbzBjsHsNlA==
X-Gm-Gg: AZuq6aJ1SJhgeACAPrOtNsbXETNbmQfso44RdTuGAO1VJzdOEAmRlRH3RAa7DlsuXSZ
	MFvljMS2d7vFi8a/rNrk5AahCs5u6Sg3L8d8zDy9+NbuCoWX7Efo24BkQ629iiDgISFJmhWZ5sW
	e56gJWyodsJDxDwSzOQwr5/M57SFaJ+lGgQ5ZU/PsZuZ+EEz9Y/3YclaqUpY+C+nOsZ88QyiclS
	yqKY0kyHFsb3JuT8hri6EhgBff8Y9AucrrneIScLiRWgbll7F6lMrL1LEdEqkwCPty9Okd3pdIQ
	i9+/5+N9mMGRfU/qCRAO+TAEzMEiDl+zvqJ3uzaXIAyj6uyzrVbULkUazq+aOaCm3Hiq76jHOCh
	7kkFOnxp2lZxMXhDfnOIAKyWBPlGXDxXKT2vWckbKbg905GjEZiLPuzCDu3LPLdHdBfsDWy7A6j
	Xzs+Abq2QzzeqIPkggqjMiMG0PKSNLNUaSvVqb4uITNXjTxFbrCmI=
X-Received: by 2002:a17:902:ea0c:b0:295:4936:d1e9 with SMTP id d9443c01a7336-2a9516f505emr21682055ad.36.1770352315009;
        Thu, 05 Feb 2026 20:31:55 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:7c0a:732a:f36b:6acc])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6dcb542c36sm919684a12.16.2026.02.05.20.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 20:31:54 -0800 (PST)
Date: Fri, 6 Feb 2026 13:31:50 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [stable-6.6.y] mm: khugepaged refuses to freeze
Message-ID: <h3bbxn4omwe2jv32vyjou34me73x5nwg6ai57goqo2qlntq73y@ra75spa3tlzr>
References: <gp3foqukne5ukrssvx64svhcpogmrskyyzjatofstfrl3vplrk@onxbnxdjrswu>
 <3d0f189b-faab-4452-b9cc-8f4e7a15025f@linux.alibaba.com>
 <jujsgu5ed3srhetch2pbpdrt4tnf2alodrk4nfo7idxmhsq772@lirvj7ftvxgv>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <jujsgu5ed3srhetch2pbpdrt4tnf2alodrk4nfo7idxmhsq772@lirvj7ftvxgv>
X-Stat-Signature: e46uon3gzztnqs4kqaog1irx93hbuu9u
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 28CA2C0006
X-HE-Tag: 1770352315-64166
X-HE-Meta: U2FsdGVkX1/sAa6rahXkzI1gCAWMAQlC5gnlrTvXe5cT1U54rJoIOdSWIx8hmhEz60m2O+gyLAhwIJc1Rib9wF3W5XYgABGeDNEQWvXYvtQPEh++vU79jqi3Sq286vxD6o9VA9knY3o9kV+lAM/49JkS7qpB9YAUBSsUJPYBBUyisGyo/5+JEXieSz3+bxeoGBFEG4Yw6W0rBgxRpXPsjBGeYg+FNdO1IQVFxIov6ApJ84Cnzy3hArV926GH1KtUi82HaT9hQNQxDKt5lQUnWXuzgZceFBgLpuvRGVMDwiLnvL/Ypttmq7Pi/vZF/9Xtutdo+3veJrWW3q4GR67PFGH6aNdwT+bxpwHZq6RI3t2/SD2d2Dve8HHRrK58JtSPaVrury6opOBwXqSENibhOC3ySZwkrFNjaP39ssmJivDfF/nKkP3vYrMPkOe1iulp8xUqAc03AzMN+jkY4oOpBOwdEgvcD56Fqq+FeguquK9wtZxKk8kz8X1S9MZRZsVBFeSa7trinGxpAWd8m/TDgvUqw/M/OCLN1MIAHtdZjffWCuGLULsE300h0+DtaCOsxTWYWkd9NgQMG17hIXyJ+ZSPaMslebdUZMLPNzj4nIK41rtOnzQEeizi1bYAZAUm+3OgNncfAVw7EvQ/1z/p6jXnId0NQv4i6U78wt2Wa3a/bLy8hzdmIL6pXdyV3nrffJRwZbWzaMvWgE9qLXZAiiPfcwIY0cCbfejNHSS1yzugBBBZ/1HrHWtwwsMe4ynrkwSbDyJAvTE6FN/I/U2/TqVPGpOx7smLD6PpFeGOn2bJNNRM5MxPU7BDqAljOPp73+H+hyVxwymC+1WVTyncAq7sLjcl/wZAGMqcQyP3h0qvDlDi9WlEe3epq7MVU291b4uH12ct+hJu1YBprlEo/9rz7pD9WRqjsVV5sSsdBRg9lIVCEUjLwhBmNscCOAHbQopsCj7xX/dMcexT4mP
 XxcLeLeu
 Qgb/UEGkx66hRQDS/PccqoiF8X7m+maCinJoQuqCNMRalSWRWdNotv7DsZ/vCrxmNKMSonkBazU3BHcZX0imAJpgPdQU1B2VXVs8RY/C1M8yvZCohJf6lS3jyN5wsowClMypt0sfqXG68ALeqG350XPmwK08bNY7HoWaJfqiRlKSjMKzfoCaMy1i5GXZb2pvi8Ei3jtE7hLockkHWkpaEnTMwbxZxqPdxc6GW6AfNtpN6a+I2f3Hxz0ePPjy08d8LH6BwbjF89tKLZWVqiA3ciFESlMPx/Nfa/t4gMmOHRzg0OtXeXivqWiLD9G3VVCkl0VdUzYR1GBIxz9Tw6urAcsPfinnHXmXP3L8msynQR7ZVo+eUv71rIPD3EU1H8Lm3pCwTcNgoP0/g+StNYDpM5NCWzOSzonUOSV+u3/GkrY8EpWw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/02/06 12:38), Sergey Senozhatsky wrote:
[..]
> > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > index eff9e3061925..fa6a018b20a8 100644
> > > --- a/mm/khugepaged.c
> > > +++ b/mm/khugepaged.c
> > > @@ -1894,6 +1894,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> > >   		xas_set(&xas, index);
> > >   		folio = xas_load(&xas);
> > > +		if (try_to_freeze())
> > > +			goto xa_unlocked;
> > > +
> > >   		VM_BUG_ON(index != xas.xa_index);
> > >   		if (is_shmem) {
> > >   			if (!folio) {
> > 
> > Your analysis is reasonable. When the system is freezing, khugepaged is
> > still trying to swap-in shmem to collapse, which prevents the system from
> > entering suspend state. However, it’s not only shmem that will swap in,
> > collapsing anonymous folios may also trigger swap-in operations.
> 
> Right, I thought about it but wasn't sure.  Could the inner loop (e.g.
> collapse_file() in this particular case) loop long enough to fail suspend
> w/o ever giving the outer loop (khugepaged_do_scan()) a chance to freeze?

For inner loops I wondered if cond_resched() could be an indicator of
where try_to_freeze() should be placed.  Those cond_resched() calls
are there for a reason, after all.   E.g. something like:

---

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index fa6a018b20a8..cee08466a069 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2431,6 +2431,9 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 		unsigned long hstart, hend;
 
 		cond_resched();
+		if (try_to_freeze())
+			break;
+
 		if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
 			progress++;
 			break;
@@ -2453,6 +2456,9 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 			bool mmap_locked = true;
 
 			cond_resched();
+			if (try_to_freeze())
+				goto breakouterloop;
+
 			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
 				goto breakouterloop;
 

