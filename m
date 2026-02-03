Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1A52E83054
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 05:35:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D10126B0005; Tue,  3 Feb 2026 00:35:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C932C6B0088; Tue,  3 Feb 2026 00:35:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9F3D6B0089; Tue,  3 Feb 2026 00:35:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A8A326B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 00:35:24 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9CE9B1A03C8
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 05:35:23 +0000 (UTC)
X-FDA: 84402032526.24.A29F8CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 17613120007
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 05:35:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LWth5Gk5;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770096922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5CPz5z8sPUu4vMpPpg11o2GarQiwcKRvB4st5k544V0=;
	b=WCNWetNYvVemhe19y/4hvn/E8AOeA518lmKdJ5qEm9i3iKHJo12NCAALMQDr88MsYUN4BS
	MFCr5JfRb3qsYslI4KPQp+udsd/HI6YYWxx4bYopwb4msAOFCs6Md1C3DIXc03SSdEvOml
	5TzdkoZ4T/PNxY6fY6lWoEvXEBtUpOw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LWth5Gk5;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770096922; a=rsa-sha256;
	cv=none;
	b=taOKeeDhjzztU3rdaVDXoe5huyuQZCjeavao8wNGlo/BYPnD1i4OwecELhjWthtmRwg/Qn
	FNwgYXJrUIBW/VtkulriaGoKrhifnF9T3weOBb4PwESzPhGVzbaC7l+QR31rycrTdHSU23
	VJYq4qUr0LVLftPb8V7Mz/AfWD0P6TA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D944600AA;
	Tue,  3 Feb 2026 05:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B863C116D0;
	Tue,  3 Feb 2026 05:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770096921;
	bh=4rPxl6OOP6sNccgj3vhJcnJxxzSSyqrvjl9HaMBD1j4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWth5Gk5KeVbwGf/muRDw7eEJYlaNSwLqCCCb9ECwm26tdnENHiCzbn/wdbr0wbgE
	 yvmYQd/MuUkz1CFM05NPGBc46/uN/NQjGiXonOkYxwhZT1CbpUNOCti1dyVXGeimXT
	 UwZvMVmmuDjfrbCAdutZ3vuouBvU9z66vJosrMVQ/SsFoCsbFl2KQPQAlnghrnmFkk
	 bPLIbxewq8VlpQRrKcyUeC7Fu27fDBngZFJYAlEMpk3+N13D7Cg4gWGyL2i9TE8rKo
	 eToeSk+qJqrmq3VlZs7nInxGA1jixZuMu+esioGY5/4h/AtPvXA0TUrNCVFJixlyBy
	 6ahifE5tTCQ/g==
From: SeongJae Park <sj@kernel.org>
To: gutierrez.asier@huawei-partners.com
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 4/4] documentation/mm/damon: Documentation for the dynamic_hugepages module
Date: Mon,  2 Feb 2026 21:34:45 -0800
Message-ID: <20260203053446.68919-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202145650.1795854-5-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 17613120007
X-Stat-Signature: bagh1am3tn9jrk4qq7wricdysiogu6pw
X-Rspam-User: 
X-HE-Tag: 1770096921-62134
X-HE-Meta: U2FsdGVkX19ubmV6pNt8Ijb82kuEtGCMSyRYNNuYpIl5kYU71SZW+BkjSTIjHT5QzVLfq1jhrTtLgwq0F6p0VygAdsypPZoBNDImfLOOwzQuZBeh66OiSAL0L/ydAHaIIl/24AutU1AjL0nxGrFxT+IdOjfgvQiZtqUmOB9EDfG7ItZ+kF1+NL7ij7agXzWzdcJtwjaimjxD9U6xoZ3TkIH4SOFJw6p/L0NdqUsh9umfC2eTpUw3qoKvAl9LQzsoHkivhoQNcsN7B20xQ/5L/mkArD0hgijLSZa20nIiWquQd7RU66zNtnYWOGYJ/aH2WJZ8JC/Y74MykUt5IG95+3Jjyt9ySOlPKLIyYrWDrh7TGqswe534bhH93bdAuixZ9UQoRa0ETiAci4YHMBlUvdP1tgn4jH+bNWBFCmROw9x9Wy9deS6t343AwqnfB0VXERuFFSBipheresqu//CYDH6Ev1zNpYlJLUufZ6ISflhJIbMa1dyTEuGvDvJcivvkL/+gVPmYyCbNTKFLQ15UQYW2faAGsK1afFy1BjNipBgGKs96Zy2vYFfs3rkVtI+TwNu/GCqX53Vyx5t6cmdZqonawlSGMuUOZ1FWQU+yVIb6zsH+1qh4kWHfyD4zN7nN8MlUMj6bjTNHoCRRDl26DnZh6CI7SUuT2gXT3vyHXCoZCqsgJCLHs+Z407ChQjIvbb3v2oWj6TaEi+T4v7FcUIrUM+jMaj7Ty6GOHeAY/cwpYtRvbYEsWOLGZXATeCJyZ0rMR7aRq2YU+Oga0/vCO7QUnrXX1P7pRN+SBaiDLcWvTVWQY9WfkSxk+hVCTgEnEUXyj8VXhuShzTcK8DSFTlBUjn5efBD1/eug+GC3reuRGHf/S5KVLQibUchFr/Mc/yKYB7vRZv4h3FsjDRXW6lsxXs4DbODea8p+q3C1wXGDIuUJvh7tQEAncPUBB/XGx+NbOtN5E3OugfuL9Nr
 tqpyplHf
 oJ1YsYhPmuuJFZROLi6RXmcggeFTbogfKlfEbyEy0ZNnPgoziDrsB+ILOmbv8ioxopT1pj/AH5/veLeACK+7SgQfSAf7BROD2nX2cwiefvTjfHHx/0iaoqCjc8e+Dn4JyoEwSvAV4ie4KEuM5HGrQsrwKq3cUqEtHg+hBxyuUNHQG4AeZl3k4y9k/Le9YyNctxVy7vEdR6F3wzAeAqqWhjPriWCHszUsnMQx/j7+QderYSy/+7X4v7G0+CdngNB78nIdQtHGcNK/OkLg3cIA9NHhFmuwJO6J4zXmdUh69ZRjtohg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's use "Docs/admin-guide/mm/damon:" as the prefix of the commit subject.

On Mon, 2 Feb 2026 14:56:49 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> Documentation for dynamic_hugepage DAMON module.
> 
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> Co-developed-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
> ---
>  .../mm/damon/dynamic_hugepages.rst (new)      | 173 ++++++++++++++++++
>  1 file changed, 173 insertions(+)
> 
> diff --git a/Documentation/admin-guide/mm/damon/dynamic_hugepages.rst b/Documentation/admin-guide/mm/damon/dynamic_hugepages.rst
> new file mode 100644
> index 000000000000..a6afb0910661
> --- /dev/null
> +++ b/Documentation/admin-guide/mm/damon/dynamic_hugepages.rst
[...]
> +How It Works?
> +=============
> +
> +DAMON_HOT_HUGEPAGE spawns a new kthread which will monitor the applications in
> +the system. The monitor thread will calculate the moving average of the sum of
> +utimes of all the threads for all the processes. Then, pick the top three and
> +launch a damon process to monitor the hot regions in those tasks.
> +
> +Since we don't know the minaccess number in advance, we set it to 90 initially,

minaccess number -> optimum value of the min_nr_accesses value ?

[...]
> +Example
> +=======
> +Below runtime example commands make DAMON_HOT_HUGEPAGE to find memory regions in
> +the 3 most active tasks. It also asks DAMON_HOT_HUGEPAGE to do nothing if the
> +system's free memory rate is more than 50%, but start the real works if it
> +becomes lower than 40%.
> +
> +    # cd /sys/module/damon_dynamic_hotpages/parameters/
> +    # echo 10 > quota_ms
> +    # echo 1000 > quota_reset_interval_ms
> +    # echo 500 > wmarks_high
> +    # echo 400 > wmarks_mid
> +    # echo 200 > wmarks_low
> +    # echo Y > enabled
> \ No newline at end of file

Please generously give a new line ;)

My high line comments including name of the module, the expected use case of
the watermarks also apply above.  Same to my comment on the third patch of this
series,  I will do more detailed review of this patch again on the next
version, since I presume the high level idea discussion is the main goal of
this series.  Correct me if I'm wrong.


Thanks,
SJ

[...]

