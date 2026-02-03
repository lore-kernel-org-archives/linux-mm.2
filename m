Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FBFFE8305B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 07:32:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F20D6B008C; Tue,  3 Feb 2026 02:32:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DD8D6B0095; Tue,  3 Feb 2026 02:32:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FA166B008C; Tue,  3 Feb 2026 02:32:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1CEBF6B008C
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:32:23 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C4ECD58B11
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 07:32:22 +0000 (UTC)
X-FDA: 84402327324.10.F168BE1
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	by imf27.hostedemail.com (Postfix) with ESMTP id 088FC4000C
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 07:32:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b="rhK/m23P";
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf27.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.33 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770103940; a=rsa-sha256;
	cv=none;
	b=mns5s/UQkaEQ1oOf8IFl5mJOICcZgK8xkGwvfXq72gxls5Yt3h61Se6nl9GtX9wjHeQeZf
	fjWZmgKxLtI/qWNaUm9NJzqKUI0sbsjFAS+BEVBy1eHrFURU8F+tA8qcqBjkdvea8C5DQN
	XUu6WidlYmjw/JFo/UFItE7zEl5BDi8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b="rhK/m23P";
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf27.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.33 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770103940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GEM5n02Ulac7TkOC/loRAoXQMHBkMvS2O9ly7ncfHrg=;
	b=iFl99E0VxLRGXGC4FXdCjoMR+VAr/QPvqB4eAhKT6UTqREZducm9JW0IzkG2TCuPTk9LE0
	0+2QnqORb99Kzzw5/TuH3+UijG5QWkGcijntcyrdl2/jVmgROOZio7f+kmCSsbLoCx2wFy
	zXe5zJkfNWbwiNwOoz4BQ76L2uk87Zo=
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260203073216epoutp03ff9b34b4dd20e9a6465132fa1d40cd5b~QrCbkZzqb1873518735epoutp03Y
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 07:32:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260203073216epoutp03ff9b34b4dd20e9a6465132fa1d40cd5b~QrCbkZzqb1873518735epoutp03Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1770103936;
	bh=GEM5n02Ulac7TkOC/loRAoXQMHBkMvS2O9ly7ncfHrg=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=rhK/m23PowM1nvJnnEqBrXM3kQfiI18uUCyb+2P1FnGCPmCJFxa4sFzr34TmiaV+E
	 F9peggOOQ34fnfe21sNA1Sw74VYQ5YqrqbOKciB7ISroW0vIWbRTGDGK1nkafOqua5
	 rPCKQ8WFpIMT1soqaBoneQRTL/57hluean9KPWzs=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260203073216epcas5p10e212c450887dfeb2d262b56ad02c9e2~QrCbDxKYE1157711577epcas5p1Z;
	Tue,  3 Feb 2026 07:32:16 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.90]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4f4wDG6Lxzz6B9mD; Tue,  3 Feb
	2026 07:32:14 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260203073214epcas5p27d7fabd36d5f2751902539f0c5618805~QrCZPje9k2053520535epcas5p2V;
	Tue,  3 Feb 2026 07:32:14 +0000 (GMT)
Received: from [107.111.86.57] (unknown [107.111.86.57]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260203073210epsmtip1d1b85e69ec1468536e5beea7c27bbf70~QrCVdv_iT2822828228epsmtip1w;
	Tue,  3 Feb 2026 07:32:09 +0000 (GMT)
Message-ID: <1d750771-84cf-4af5-bda8-4feef110276e@samsung.com>
Date: Tue, 3 Feb 2026 13:02:08 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/6] xfs: tag folios with AG number during buffered
 write via iomap attach hook
Content-Language: en-US
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com, david@fromorbit.com,
	amir73il@gmail.com, axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com,
	dave@stgolabs.net, cem@kernel.org, wangyufei@vivo.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, gost.dev@samsung.com, anuj20.g@samsung.com,
	vishak.g@samsung.com, joshi.k@samsung.com
From: Kundan Kumar <kundan.kumar@samsung.com>
In-Reply-To: <20260129224002.GF7712@frogsfrogsfrogs>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260203073214epcas5p27d7fabd36d5f2751902539f0c5618805
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260116101256epcas5p2d6125a6bcad78c33f737fdc3484aca79
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
	<CGME20260116101256epcas5p2d6125a6bcad78c33f737fdc3484aca79@epcas5p2.samsung.com>
	<20260116100818.7576-5-kundan.kumar@samsung.com>
	<20260129004745.GC7712@frogsfrogsfrogs>
	<20260129224002.GF7712@frogsfrogsfrogs>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 088FC4000C
X-Stat-Signature: 6yqdf11yk4jfcwroxja7zugyxw1ug9w5
X-HE-Tag: 1770103939-560420
X-HE-Meta: U2FsdGVkX1+zZQMOS1OTcnKjqPbq+5I/xZRafFFO2OKKRI7PceEg1/0tUi6OrDof0pjRvwhH5Y6bNI4YiwQHwvnPj9df09m4wBU+9u94dqi4arA7GTSENH6E+mnKcIajA5h7ypvExLhE9McPyhyzPfK7TWLyOlRFimKB+EqPRuvuJf2TCd70Mai+w/RUjS7wmZl4Rt3NORoCxNeVfJJ7CwM6RnO/gf/Bh7fnwOMAsdLsqFDdjcDcwaX+DeEsnOFeWw/HD303rW4rObTy8V8imx0xmwdW21pxWOK1fWY3NlgeumqHr3K3lbZ0foeYOHpUiK7n0YlB6ap8sF9M2icCnjv9eNvxQP+dEo1s3T3fbTQxKsdJ67cdBycXVUseo+RLzMJG3k+sdL2i4v2/1m+eLOupjCjN/wttKsRSFMJys8rWdxIzkItS8fFpXqJ6brbuq4o7UpHvGu+CHBC+C47yA0X6NkMKgdNJfckgtqKJ9WD//kQub8/a93N/64FTh/ULpyDQhFQP0/91mW1+8WmpBL3FeP5I4vWJSKVkgKNWI9a/m20NR69/4fdD2azs6EmJ9viVxKU482RXDGRk6HvLq4sGUj9Dopz2gHQ0ZNUezMzAvty4aN+BBuzqxk4geuW9cwEvPSqqVb1wx/NVlq/FQZU7pvoDhQCq38xncK5ts7xSG5UyY4m1Mq5Hds5yotyXLJ4NaH1sjPrC0Oik3t6wHccdCmeX188q5PpflBwsfeK0YC4E1ahZfPMlbmelz9XIpCnOnXcsI83cCOfOpjGEyLDma5/WDVLbQJMK/BQLUYFHx8Q1bW1wgX/cPMaY+GYUSQGb22v4zghoo5KydYgn27glajs2F6uhimLJt3qFgbGD+vr3H6BUaths6bWAdsnacI7ZZr1GxwNTTRHA+2KKaWYS40MHlG3k6tOH4aDTiwJQFUibmeZu63GGfjOsER2Uc9MtB5RgbJu53GBdwUS
 sAsmvFLO
 nm6aHUZJZ02UTt7jyIzbDsQNL+Hl6x9K4/KBjfxyHjHBvi41Ze+YiH/s89h+ouWJpaWJhswONSStYWlCHdnCktegO35Vb0NkpS6g6iUgZqvWYb2OD4HZYbIsOeAPJskL3liKN8IH7emlvdu4UWNmgSIaP/yI6xnzPOdrZJns70ztud2Eoqf8eVavSl3ebOsrgjhDkKPUS6XrFJZs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>
> Also, what happens if this is a realtime file?  For pre-rtgroups
> filesystems there is no group number to use; and for rtgroups you have
> to use xfs_rtb_to_rgno.  The i_ag_dirty_bitmap and the m_ag_wb array
> will be the wrong size if rgcount != agcount; and also you probably
> don't want to have in the same per-group writeback list two inodes with
> folios having the same group number but writing to two different devices
> (data vs. rt).
> 
> --D
> 

For this series I’ll explicitly exclude realtime inodes from AG routing
(skip tagging / fall back to normal writeback). Rtgroup-aware routing 
would need a separate rg-domain (separate worker array/queues sized by
rgcount) as follow-up work.




