Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E25F606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QC8ZDgAO
Received: by kanga.kvack.org (Postfix)
	id 876A06B05B6; Sun, 15 Nov 2026 15:41:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8272B6B05B8; Sun, 15 Nov 2026 15:41:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73D466B05B9; Sun, 15 Nov 2026 15:41:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 51F496B05B6
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:41:27 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CAD7D1A0826
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:41:26 +0000 (UTC)
X-FDA: 85438523772.01.C4D3089
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2D6E520007
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:41:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QC8ZDgAO;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794775285;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=31PK8ejQi8OkMxNdvjJcNS0+QCT6SvYzZcKuJxbk+N0=;
	b=t8QoZtejP47TNg/ws0sYglPCCMWYqwcHGwaGuihbHeab4GZXo2K9pvzPpbZbCR7rdbfr/l
	RTFOOZwaoqX1flXlpF84tpzWcJmqh5GkF5G1Wqcq3BZ2Tthc1ufOXEDIkR5eLjJwp6Snga
	fxlwIvlaH2GJdxUpTX8vE0iaeiAJlcs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794775285;
	b=XJwL6kX9eD6ByVSeyn9xNpCLY+RnfauN9ulfNR0248mtHdDZ8gHf5hAIBOtLsQUV3h3R8/
	Fh/A3yYjvcrGRY5AGqZ1zYKkMrsUsTOqNj/QQKbERvajb0ejO6LvJdINmZGPhsJlKIec79
	dw1Ku26gmi24R27hVJm7QEpRcZaSvr8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QC8ZDgAO;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7038244831;
	Sun, 15 Nov 2026 20:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A0E1F000C4;
	Sun, 15 Nov 2026 20:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794775284;
	bh=31PK8ejQi8OkMxNdvjJcNS0+QCT6SvYzZcKuJxbk+N0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QC8ZDgAOAz/goD9F04hw0cJMzG4vhfIXnkMQU3fY2LwoClwGP8zFbjSxQx0sSJm8Y
	 8gmKsPCp4eI0Nw0F51WVqnIKG5DTr4rE+O7AWpQE2gcvcNeqsuwtzsX0SKXeB9zxAm
	 IohSyxPw1H920YflUmB3oPQH7fMD0/eMG6YOIyfwISSaN8tA+U0tUhiUGW+nEi3KiM
	 gTo0hsQD55MS3Fy0VlvtDDOLZsPTzQlSEpLybbgaAAEIFwH+j9Bp129rvm4pKIXHPs
	 2uOJRtgCbqsdii+m5vJlt5dVZR1f0LzaWB/RvfJgiazK0knymfJVzTykPOQA+TIZDh
	 d95R7NSBYb7PA==
Message-ID: <sashiko-outbox-215849@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 02/27] mm/damon/core: implement data attribute
 report queue
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261115202849.99134-3-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
 <20261115202849.99134-3-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 20:41:23 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2D6E520007
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 8bzngoywoz7m6qnsq8ar99rkqfxuzk78
X-Rspam-User: 
X-HE-Tag: 1794775285-765778
X-HE-Meta: U2FsdGVkX1/x/lwSKxXey8jwJ9hjz77nhaBVgseTEvoEK0YiS3DnDP/YOCMc1fgMrrEMhQBc8BUL9Ld6LK0dysurDxL1QKadGQGrqiypKQ+gCdmcC7KnGpawlvDisimrPboZ2abaYUWrjnu1MC2AgbqRsO7USWNmtsgJPYwMd6dBxoXOgDAiVfgt4EG+8UBsXeph6XI51yTr5ImzSwPjGaXEFtQOdTAvEnRusD5/AiE+YFU/59nIdHsXOordzOZdn9qvghs0gs6U5T6UPfl62llCPDG5f4P0nAHLw12hEErz90AicVK9VwFHOIKkh1903R6mD7yDHmpDBkmLTWUc1h6lTFjkb/9MBqQ6P2lbPIGTmBpYUoB/V80n31yNoTLI/EDjUtYnhAQEl/yXE5Rac4v6GOTvIT2w1m8+8cjSdnK6jMR2VoS3WR9Mur/4MWjOB5/PYigr0SzN/Axs+qQPopu2H0+ezXk5DHZ8Cd0STAIjnWWNVxRmJNhpP0bDy7XT/cQAZ0PQEPjUEkQ9NygUH3vz/ReBlTB9rzVbQvWDt2C8F274cymFROLubHsazvHNVjzPgczk//CfMtTe1SYYunDKTsitoHFohu+MBy7LYQFoNaxEdWIz8jWS3YwiKjfBHzTmM+SY3FVWyiV5H8Au7s2vDwVu8JJmiSGgCwkUVK2zltnODbnUBDt5VU6W15GO1XpmKGCYQ7nyjhqQTx/zBy+M5tnk1sjUwaq28CeBgZQVqPUUHQTM62S/Rqua6gAi9DYx0keL8anBfpaw6GOw41ZEvOalFnr0bJGJdyksVmZg/CvMhi2ndCGZu5gY9+XN+yN9j+MBikQhs2oCAKian+39ObFYGlCe07kWEtRgTjRpbNQWB8E8eYnRUu4bwTgID8TsHqSWCN1IsAXyTj7IWpiiLyMj9tLRu3BzaqG0iEuqbmvjDoJTWMu6vimytBW22TBIBb7PXE6uN9bVMfG
 dCMOv9yB
 /je18C/T2o6u+scGzCWX+v/AQrDWjbnTX3YCH3eyj2KRPmb+Cm5ZwxHGzCZpdjVW8WCjltoNVJ9grYSbq2zdoWYsrY2UWwAnCms5RY5ZBQpUPaaqM8WiMuK2Azcb1gSRzA3aTsFAruCP1fTXj1m/WWaS03T/csPFoBlTmQfNZtK3WIXY38BC48WkhGRgmPU6kVvw54NAcN3ZmzeZ62Cg+szHXC9wiE8mNaxUz2q/HOerUX+7Qzbz0ICMWUC4urpxLclECPrzuyLT+gsejJRzR/sUWElNospz0kCeL3Vwwf4mK0RpKorgK0jX9ucyL1CEUVmjT5OoTHxzrnoyeVHWXc+KjWGDzef3Mf60PoQDPy5indC70fQ/856pzYkPaLeU3znBJIXt/EMFN/zRicsQhhM3mW83nsONVPzf66O6l+cSV0xtMX3Ha6LIv4jvXssBpVKlRQt7FmFoFgSZfHLiiAQ53RxlxYkp8zDTXQzYtO+xYN0mLVFrFyWrc1TP1xw3xL0S5gK1AwvfIK+f979C0DA+pqAZgGXrvQfgS948iMVIk8HPO8utE+4Lk5jUfca2j+yV4MmsdWjrSRhrSIliShHoKfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] mm/damon: damon_init() leaks damon_region_cache on queue
  alloc failure
- [Low] mm/damon: missing static qualifier on damon_report_queue in
  core.c
- [Low] mm/damon: struct damon_report_queue comment documents head not
  nr_reports
--

commit 10a61bc9bab6e48534e4a8552380aecaccbee97a
Author: SJ Park <sj@kernel.org>

mm/damon/core: implement data attribute report queue

This commit adds an internal damon_report_queue structure, allocates its
buffer for up to 1,000 reports in damon_init(), and checks that buffer in
damon_initialized().

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 0a056949604f9..3f87a7eec442e 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2334,6 +2334,25 @@ int damos_walk(struct damon_ctx *ctx, struct damos=
_walk_control *control)
>  	return 0;
>  }
> =20
> +/*
> + * struct damon_report_queue - &struct damon_report queue.
> + *
> + * @lock:	Represent if this queue is being used by someone.
> + * @head:	Head of the queue.
> + * @tail:	Tail of the queue.
> + * @size:	Size of the queue.
> + * @reports:	Array of &struct damon_report.
> + */
> +struct damon_report_queue {
> +	atomic_t lock;
> +	unsigned int tail;
> +	unsigned int size;
> +	unsigned int nr_reports;
> +	struct damon_report *reports;
> +};

[Severity: Low]
The comment above struct damon_report_queue documents @head, whereas the
struct defines nr_reports instead.

> +
> +struct damon_report_queue damon_report_queue;

[Severity: Low]
Should damon_report_queue be marked static?  struct damon_report_queue is
private to mm/damon/core.c, so leaving damon_report_queue non-static
exports it into the global namespace and triggers sparse and W=3D1 missing
variable declaration warnings.

> +
>  /*
>   * Reset the aggregated monitoring results ('nr_accesses' of each region=
).
>   */
> @@ -4308,7 +4327,7 @@ void damon_update_region_access_rate(struct damon_r=
egion *r, bool accessed)
>   */
>  bool damon_initialized(void)
>  {
> -	return damon_region_cache !=3D NULL;
> +	return damon_region_cache && damon_report_queue.reports;
>  }
> =20
>  static int __init damon_init(void)
> @@ -4319,6 +4338,14 @@ static int __init damon_init(void)
>  		return -ENOMEM;
>  	}
> =20
> +	damon_report_queue.size =3D 1000;
> +	damon_report_queue.reports =3D kmalloc_objs(*damon_report_queue.reports,
> +			1000, GFP_KERNEL);
> +	if (!damon_report_queue.reports) {
> +		pr_err("report queue alloc fail\n");
> +		return -ENOMEM;
> +	}

[Severity: Medium]
Does this error path leak damon_region_cache when kmalloc_objs() fails?
Destroying damon_region_cache and resetting it (along with
damon_report_queue.size) before returning -ENOMEM would avoid leaking the
slab cache and leaving partially initialized state.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115202849.9913=
4-1-sj@kernel.org?part=3D2

