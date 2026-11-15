Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C75FA606A31F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 21:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VH06rsBq
Received: by kanga.kvack.org (Postfix)
	id E6BDA6B05B2; Sun, 15 Nov 2026 16:42:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E43AF6B05B3; Sun, 15 Nov 2026 16:42:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5AE66B05B4; Sun, 15 Nov 2026 16:42:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A635C6B05B2
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:42:32 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0AE5E80505
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:42:30 +0000 (UTC)
X-FDA: 85438677660.15.E924977
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 50A7B180005
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:42:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VH06rsBq;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794778948;
	b=QEelE35WNgQXocArbHvw+cJnlKwID21KIFmBju0WsrRQodbE1c/RImhk34TZJBdbV3MPQu
	IN3rgPZFZmMOSO3nfyH0mS/55bueEbtsuDatC1gVsMVaCE6OdBisoomx+82fkjA6aj4npZ
	Lsq9l+dGlNmJnLcS20DdK0+wjmszvoE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VH06rsBq;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794778948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t0D1RubYmGsNEhaSdDTnNXY/ONXMzZn2GmBi+6KjjSU=;
	b=H8V+/tZyO0yqJeTqXg7PEi49/ADSHMlVorJgo1XN+Z/wm1Iqestdc6VtX6fn1aRwFm7ofP
	JRs971r48Sh+ZdGytRLjQNGC+a1oS+ppoHpr/YZwnkabUdfmexQvqsvb1uo2jLLvJgaESe
	R91uPadwTdURqc5SybfA+gXCoiD2uTA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 74DE243835;
	Sun, 15 Nov 2026 21:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31DB81F000C4;
	Sun, 15 Nov 2026 21:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794778947;
	bh=t0D1RubYmGsNEhaSdDTnNXY/ONXMzZn2GmBi+6KjjSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VH06rsBqiZHRMiVAjPZ/Z2nxFxK0WsMQgsV5i9o52Gk+n5ZDg7zx7EFB2HRFrmYtx
	 SFMSQXXjIbWIRLhk4vZakW2oS0Cegc60Kp2JqtITQXMyHbAFeQVAr1w/6QaJAaYhqu
	 heKKjKF7foFZft+ffXxCpx7W7FU76X+PRbwDOnN4oYKb6Ybji2cGt+fy+3vKVD9rF8
	 bN0pS6iTL8JTFuh7e97siS9kV/3hVrvEtaW7WV6SJlrXVnCOH1bsJBH5hRYQXeyOoq
	 ebQMVKfIch6yFRaAb0nvhWa/xOvtIsCf+TvqGq01Q/9zx+dJOB1D5FaLHAt0OawE1w
	 WLKBIkWbB5ixA==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 16/27] mm/damon/sysfs: support REPORT_MADE type probe filter setup
Date: Sun, 15 Nov 2026 13:42:18 -0800
Message-ID: <20261115214220.103983-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-215848@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yfptjmff75fsni5k4kqdxb6d784y8kgz
X-Rspamd-Queue-Id: 50A7B180005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794778948-539511
X-HE-Meta: U2FsdGVkX1+pfnDrzGeKF0j3kfqT4hen////epsmkrw7doIzVvKteRaoGQBYeEVH3W/t+Sw9GDFVlJln0Xzm6KihKa8d7hdkfXIEImAUutZR5Te1RDxWOUp8etGDsmqxQjDaQdavbZz3a9VcKScJhbHEIitaQzEPPnKTDf9rxNl0urV+T0Y8TtiWdq8XmoixyxCyAFgOd61Rio1hloWQiuTAAd5vn3by43WYAVZY+HHbjZx8dPqvMhOytGL19IPLyE5WcL2ZIRXzJfGIsLlKq0XDgv3AskNFxcJuMXaBeddPMAqG5cx2h/AqHitskF8uJ6osLIUwGiirYxd4vCGozdNo/hCiADFiohMxSc3wrsmTtGxxGSTlJSRe1BF94csCJjkJBN/u9bM9/hE52Ygq9EBOFi7e/NW5CJXtOCLwaCUfBrqsC7NHySt9OIZdPRSfGEUB2m8AaA2cMzUPWqxd2h2fvje/pUgU5R0NVDB2ccOO4vfcUdmxzPDGn/33oCvuHq7JD+syEmlzDvuP5+CH51yDXM7bbpoHdytKz/EDWtpDdm/67lSo/9zLdP9ETX9i0PBXJfiGFIImCnIurOAMJTJeoPqFzceJt/f9VF6bpuEFdWOikvzfK41Eja5dVDld23eufS2I1o6HwNICEe0pUA3RIcQNZBCuDOu9KqwG6IlJNGXEZ+JDjnxYe5nOTS4bxsV/GQ4B3YBpPasxC5FJhhP0F6R/rMzppgPpR0p115TW8gn8A8mYlQYtGeEKZHYIm65xshxMTIlWfOaZ58o802eqt1i4pCrPYmOR20b01iiP0Q9xtZyLrQAHqXVoOEtP3SK0JCp7evBnxj1OYRWLQBA7dNm8tsHZjMo5EQXhYEDh5+qZ99OXkTLwDb9e79CBwhq+CN5YwQ22alFlUIThU9ZuQmu/iuB0fLYpS6FH5EER3l2QR01pX1kbm1dLGW+hI++jVG4MA1YGE9wVaHq
 Sjze0bKy
 yLahV2k8tI6/bIMUZUgZjCrXdJVVD4v6AIK3NTqRXPDuceqkLbYCQXk399ucEG/nOfjw8ce2V9IqYAtFOc8Av4o4/uwEKXfPAHk8gWWJXhGEmdpXLa4cQVh00JWU6Qm0Bzx/5H87j3jlJXKqr0lt6VbtrTecYrrpqqSfZRp8NVEjje+cr/eodb8MdgdJHLUz3n41GOA/QROAKfKZjWnROpQPD5P1TjC6bIv51uve/l9L31dO1czupLggnzyE5bHu33E2QHlbay/RmTxf6j8UiaCgxWGQx7sW4kgx+dpQuDJYUdsW6J2CdHt4TYw2aBdcZ4JgWOtxXaA+SCwfTHTw7IappXZF2q+9j3m1q1+LHHhDP2OK6Y4y316jHYrditn27lAQq06xZoeDV3bGbo2vPCZz5HQZQKkvhfcBM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 15 Nov 2026 20:41:12 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 2 potential
> issues to consider:
> - [High] mm/damon: out-of-bounds and uninitialized access in
>   damon_report_exist()
> - [Medium] mm/damon: uninitialized report_type in damon_commit_filters()
> --
> 
> commit 6058e18a855d5b73c171dc4b94eb6031f06fdc63
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/sysfs: support REPORT_MADE type probe filter setup
> 
> This commit adds "report_made" to the DAMON sysfs probe filter type list
> and copies the filter's report_type when setting up probe filters.
> 
> > diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> > index ca971cf1dcf6d..1c171af4590a8 100644
> > --- a/mm/damon/sysfs.c
> > +++ b/mm/damon/sysfs.c
> > @@ -1016,6 +1016,10 @@ damon_sysfs_filter_type_names[] = {
> >  		.type = DAMON_FILTER_TYPE_ACTIVE,
> >  		.name = "active",
> >  	},
> > +	{
> > +		.type = DAMON_FILTER_TYPE_REPORT_MADE,
> > +		.name = "report_made",
> > +	},
> >  };
> >  
> >  static ssize_t type_show(struct kobject *kobj,
> 
> [Severity: High]
> Can enabling DAMON_FILTER_TYPE_REPORT_MADE filters cause uninitialized and
> out-of-bounds accesses on queue->reports[]?
> 
> In damon_submit_report(), each report is stored at queue->reports[tail] and
> then queue->tail is incremented, so queue->tail points to the next slot to
> write rather than the most recent entry:
> 
> mm/damon/core.c:damon_submit_report() {
>     ...
> 	tail = queue->tail;
> 	if (tail == queue->size)
> 		tail = 0;
> 	queue->reports[tail] = *report;
> 	queue->tail++;
>     ...
> }
> 
> When damon_pa_filter_match() calls damon_report_exist() for a report_made
> filter, the loop reads queue->reports[idx] starting at idx = queue->tail
> before decrementing idx:
> 
> mm/damon/core.c:damon_report_exist() {
>     ...
> 	idx = queue->tail;
> 	for (nr_read = 0; nr_read < queue->nr_reports; nr_read++) {
> 		report = &queue->reports[idx];
> 		if (idx)
> 			idx--;
> 		else
> 			idx = queue->size - 1;
>     ...
> }
> 
> While queue->nr_reports < queue->size, the first iteration reads the
> unwritten slot at queue->reports[queue->tail] and the loop stops before
> checking queue->reports[0].  Once queue->tail reaches queue->size,
> damon_report_exist() reads out of bounds at queue->reports[queue->size],
> and the next damon_submit_report() wraps only the local tail variable
> before incrementing queue->tail past queue->size, causing subsequent
> submissions and lookups to write and read out of bounds on the heap.

Yes, I will fix submit_report() and report_exist() in earlier patches.

> 
> > @@ -2336,6 +2340,8 @@ static int damon_sysfs_set_filters(struct damon_probe *probe,
> >  		} else if (filter->type == DAMON_FILTER_TYPE_HUGEPAGE_SIZE) {
> >  			filter->range_min = sys_filter->range_min;
> >  			filter->range_max = sys_filter->range_max;
> > +		} else if (filter->type == DAMON_FILTER_TYPE_REPORT_MADE) {
> > +			filter->report_type = sys_filter->report_type;
> >  		}
> >  		damon_add_filter(probe, filter);
> >  	}
> 
> [Severity: Medium]
> Does committing a new DAMON_FILTER_TYPE_REPORT_MADE filter to a running
> context leave new_filter->report_type uninitialized?
> 
> When damon_sysfs_commit_input() commits the context built here via
> damon_commit_ctx() -> __damon_commit_ctx() -> damon_commit_probes() ->
> damon_commit_filters(), newly added filters are allocated with
> damon_new_filter(), which does not initialize the union in struct
> damon_filter, and the switch in damon_commit_filters() does not handle
> DAMON_FILTER_TYPE_REPORT_MADE:
> 
> mm/damon/core.c:damon_commit_filters() {
>     ...
> 		new_filter = damon_new_filter(src_filter->type,
> 				src_filter->matching, src_filter->allow);
> 		if (!new_filter)
> 			return -ENOMEM;
> 		switch (src_filter->type) {
> 		case DAMON_FILTER_TYPE_MEMCG:
> 			new_filter->memcg_id = src_filter->memcg_id;
> 			break;
> 		case DAMON_FILTER_TYPE_HUGEPAGE_SIZE:
> 			...
> 		default:
> 			break;
> 		}
>     ...
> }
> 
> As a result, damon_pa_filter_match() passes uninitialized slab memory in
> new_filter->report_type to damon_report_exist().

Yes, I will fix this in the earlier patch.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261115202849.99134-1-sj@kernel.org?part=16
> 


Thanks,
SJ

