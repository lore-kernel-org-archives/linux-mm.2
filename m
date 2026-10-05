Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC292CA5FE2
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 05:28:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1BA96B008C; Mon,  5 Oct 2026 01:28:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCCC16B0092; Mon,  5 Oct 2026 01:28:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE29C6B0093; Mon,  5 Oct 2026 01:28:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0736B008C
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 01:28:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 058ED8012A
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 05:28:30 +0000 (UTC)
X-FDA: 85287442380.02.4DA3F40
Received: from mta0.migadu.com (out-157.mta0.migadu.com [91.218.175.157])
	by imf24.hostedemail.com (Postfix) with ESMTP id AD8C6180007
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 05:28:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qhxLdF5N;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.157 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791178108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F+0dPVzfBxh+oprxfRUWdjxqMTVY7qCbZHSLVifdQEw=;
	b=Oze6v1ZH8ZSoSRIs1xUTaaaa71f4jCKEunh6FdGlHcdK1xVo70IwViAwxpwawc+vMtPDuZ
	D5fwgDJfYX7vt+C10EGCYmGvEMCApp1VcieGRITzUDkkZCvnlpLsvVWX6F2+jpMCJVHI96
	dMrOr50mio6Fcgb57AUJ36QQ8SNHbc0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qhxLdF5N;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.157 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791178108;
	b=TxfFYW4+0OWURm/15WaAPFs0wfCdIxIkH3EwXB2IHSNi/ZxobSgE2DowGye7Hyn4lxFYHU
	0OHMUchyuBe/XS5VZBM4TEZDtYsjzKO34GL+Eq3hkzSIBubZQoQG7pIuvaYnP4H38p0QbN
	KmvIZyYxUYf7nWcMl959ZL1rEgsNkEw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=yv2ydgbE99zjgLs891Kb2Etny/Z8MADPirm+ePJIz/8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791178106; v=1; x=1791782906;
 b=qhxLdF5NYuwcYaBkPpgMJ/IxMdhG8av3kckH6MRMTTFUiFwmfHygFqvAhLRHxXTJrj8tSiah
 Vt6XgrTeAEfHOtdus3xCd351ny1Yltq8uEI/AREoymPOYkdoPgWPm1g87AjVNDQ1ns4P+3IUhT1
 /jpkOgDuYQtC1IoYLtCVyuEo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id af17c5ddab4b483b;
	Mon, 05 Oct 2026 05:28:26 +0000
X-Mizu-Trace-ID: af17c5ddab4b483b
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2 1/2] MAINTAINERS: cover all hugetlb headers under
 HUGETLB SUBSYSTEM
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261003060029.2152489-1-lienze@kylinos.cn>
Date: Mon, 5 Oct 2026 07:28:14 +0200
Cc: osalvador@suse.de,
 david@kernel.org,
 akpm@linux-foundation.org,
 sj@kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 enze.li@gmx.com,
 Joe Perches <joe@perches.com>
Content-Transfer-Encoding: 7bit
Message-Id: <051798AB-A30D-4EF3-8B7D-DC235177BA00@linux.dev>
References: <20261003060029.2152489-1-lienze@kylinos.cn>
To: Enze Li <lienze@kylinos.cn>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Stat-Signature: f7ewxi5bg3h3dgxpyfjof8hb4wt934jf
X-Rspamd-Queue-Id: AD8C6180007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1791178107-769647
X-HE-Meta: U2FsdGVkX18N+ani8olhDbcA2XPxlT8a8K+fniEqzAM13X+BrLTHZpgwaGf417FFketXUkxmWAFX3v0i6Zdb/xWwJ5lRly1NnBsBspa9doCde/3EKrtUMaIzNIO+LG48GemmifX0Lkgt9kqr4Bw1j/Q8ZR0QLpSXqyUkwEGEb2YnoK7KMWzBwFFGz5rU1GrETaR7GKh24IdpOQKs49BEBfhd5EKTY27Ok3/eqD8JdEbyyyqfJKbhRfnK/MGJFgvJGNhfEOQy3Sxmh5t+fG6dpBA4p96/CdcVM7RWf7yzCQ0TVufAofaBB/yTamN5KGuOhJfluwgwhQqD90ltVwjPqCpldYwUCeCh2NKwSDse8ilLR85BH1iGhi1SwhodHG8Xi5hdzPpI3GjsJSa2up3haHwreGRfLMiVtZ52PpB3do8E7ObeDidmAV8LI0ObkjPnPxjy61mv8NectTlzczzCy6u4mil32k4ap0gP/CI7+H7xN67dKjv5jLrGF/wtXe9VvE9GPz7wxu+htAMd4hjIBwdzyE/dBbyeE5BC9WfD9J1tltXXNAOfhDEZyImoGox7coEI6NgofU2VBM4lNN5KdXGynp0VS80lGnQ3kd4d2XKLjVrDutF6uFgv/6Qi94Gjm5BsttZEle4hwk/fOe0w1CnCQCQnXmCvTpEQdgHc5DSB9MM+7PYB2o2rsyUFN4FkjR6nZCHmr0OfRNY0zao8wf66vs55AD7ujfyakiaSrDURhgEp+XypmTAo0jExv5xLfafT9UzkqSXA0jej1SshDM8+QZJ2Q16OJhkmZ9+FjZ4lEX92PR5r+80PJZlBRlGvL83ZhddFGyfqlMR6qROiQLDYLmFswIA40OSWpUW5bHWpGQkGvKW7RW+WKMbiPpd4lNdgFEN2orM8hh+zXf6KbYBlX3sZRi4zEHkJfCJVyfIgKS7b5WCwQqV9w2CJQFp4GdTHH7njhtD9wnihKJS
 4A04g6oD
 QN827/przHg2VZ2N3L1IOfx69M2fnjSj6QsEqpg/CUt62PYs1QkOSxtePRLbss0sM+oOVe1XIOWtZjLVUh/G2I+/q6k19C6+eKBF5xXqOCAaxK6OWFf8xfVSpOxANMUXFmJgpgBiGQVG9VSu3np8oQvPP7v4albUYjtAAK0Qg3ltIVuztO4sRae62AgJT151Pj9NNI6GadeSrb3DcsXYc96ejjeFQ8JYA3Dl5icgoxLeSxsBwufteSb4QPbrsBB15Wj6CWZKeXU2bh9YH2J+s/EMTkdnndktCJWI8tZqwO9m0D7QcPnhblbbM2rS+F8nC95m5yeuOWVDNvzwfD5wSL8BCShtweR7Y6bMlSzBt1hB0ZOA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 3, 2026, at 08:00, Enze Li <lienze@kylinos.cn> wrote:
> 
> The HUGETLB SUBSYSTEM F: entries list include/linux/hugetlb.h
> explicitly, but other hugetlb headers are not covered, so
> get_maintainer.pl does not attribute them to the hugetlb maintainers.
> 
> Enumerating headers by hand is also fragile: any header not listed (such
> as hugetlb_cgroup.h) falls outside the subsystem.  Joe Perches suggested
> using a glob F: entry, which covers all current and future hugetlb
> headers in one line and avoids the gap.
> 
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Enze Li <lienze@kylinos.cn>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


