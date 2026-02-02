Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0A72E7DF16
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 17:57:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 100C16B00D2; Mon,  2 Feb 2026 12:57:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E2CA6B00D3; Mon,  2 Feb 2026 12:57:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 002106B00D4; Mon,  2 Feb 2026 12:57:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E926E6B00D2
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:57:17 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C10DBD3927
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:57:17 +0000 (UTC)
X-FDA: 84400273314.18.45DCDBB
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf18.hostedemail.com (Postfix) with ESMTP id D55BD1C000B
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:57:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770055036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FtZB+bO8VdLXVKILaOckwkb476zlQXp8KnGXmpqHRVU=;
	b=5iu4hD23NMD3idOhy1NQFUZuiG82+YWrd9Nz6LH5jdgyEhcs6T/wO8Xcrrf4XsRUgKtUg/
	V44mlXhu2f3YA1V9kqBctJb/HJyEdRcZafQJEplPQOn2SQj/kVjUa0GPl8FLi7zXZHuhAQ
	sk5lZ0ELmXH0+zgbjsxCs+QVvQlR0h8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770055036; a=rsa-sha256;
	cv=none;
	b=Co+88qFwa13KHb2Lf7ZxDlVn5oH5eTFz1k9TR4IPOLylm6ark4o0iWyRHP2wEDjTfK2qP8
	3UM3oI6vNHyxp7Xba6w31dxv2txo8ZGtLtYDY+qqlmOHrZa7OmYPsaM90hNnpM2drhKjRQ
	PIGFyCSXmc4zVig6dqqkSfDjGDdniao=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f4Z6z3Hl0zJ467h;
	Tue,  3 Feb 2026 01:56:27 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 8880240539;
	Tue,  3 Feb 2026 01:57:13 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 2 Feb
 2026 17:57:12 +0000
Date: Mon, 2 Feb 2026 17:57:11 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Gregory Price <gourry@gourry.net>
CC: <linux-mm@kvack.org>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<kernel-team@meta.com>, <dave@stgolabs.net>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>, <dan.j.williams@intel.com>, <willy@infradead.org>,
	<jack@suse.cz>, <terry.bowman@amd.com>, <john@jagalactic.com>
Subject: Re: [PATCH 6/9] cxl/core/region: move dax region device logic into
 dax_region.c
Message-ID: <20260202175711.000021d4@huawei.com>
In-Reply-To: <20260129210442.3951412-7-gourry@gourry.net>
References: <20260129210442.3951412-1-gourry@gourry.net>
	<20260129210442.3951412-7-gourry@gourry.net>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100009.china.huawei.com (7.191.174.83) To
 dubpeml500005.china.huawei.com (7.214.145.207)
X-Rspamd-Queue-Id: D55BD1C000B
X-Stat-Signature: m7zdmgage4489nfn4xxjpa8o4x9nx4kj
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770055035-365358
X-HE-Meta: U2FsdGVkX18rD+XKDVMA0lCsEyzOkiTmgjTDvfp6cKdHDAqaAmNV3ru/hFPqpY9tThwcufWaqGIAt/o77fQTk+Fk9EMpZD6EZ9jlqazQmvQYW61Q7PSYAmetZ/jW1PXzroMVEbQwZiYR5tUwUDzyJDdEV+ezfdmmpePPs2B5ia8DbSY+Mxpju5UJsNzM7P+NOcbNe+5N3FBG2spnDANWJiefy6qiNSkk1FCEqdOE1KqZHIdaFECv0fUI6eNSBKhYLamadxbGGb96fTpzrcr9txkj0ZrLy3YsfIqNi6SochtJG9ENyndFrN0Dj3oqxYr79LJjWbhORshK0R6jEMSxQhWsdvwtFzsFPvJ2elBeDj0if7BkC+RPMO0oOIz2GaJLyWlpkIYbJDJRtQtZ4cYoBaGKaHsw8MaG0LDoLjbcl3qU4gNjjIFGrAYgdROyU1ZjRaPxHsLTb6xAe6b+j3d4lVueMVWPAbiWxd0vdKllxRfqZQtW4LjfnTElK+t/E9CyM7Zpt83JsXUdQ9VHPQKnyPGHrCRbqyd9zcdKGjsoJGzMP/fSzlSR4ZWlRPRoQA/BKFcHFOtpB1Qr59tWlddd283LSjBhwESdnqjTxJTIuZy1w8vlxGib42odt3djSnwu/58WLV/eJLT4KT0rjf8o1aQykX3TazYN3k7ST1VLTT7wsPIS551WfA1TPIuyyLpJ9uV5oHXPtPKC5wdZD73Gf0/KTPOCUlL3CQfWZ4x983vAX//SvIIU44t9Fk4xsZ9tCBS06RvjbtBN9BwhvIwAHJHhySx0GSkYSDKWqE6uhJ3jEDyOpIK4n7JS8hFTqEyLfP4F0OXBa59ZQs4TofJasTT9Iz1Rblf/m5DnLNaRGgtZyjKqm48fYooGvrZEX+cJcrJm3sQqYixEBlrje9/fQ20GQXZhzTsFC6DEc9gkEB9XVF0WISgo58B+wPokKZtwroGZgV/1mPuwlFWVslQ
 gUb3Ojdq
 xIL/PcGKPYB7mlw+Ul2o3rIft1AXDMBAGC9Fl5tvtC0I+98wZltBs1W4YillC57T2oN/8f51bH83cMXBy5kUcmaJuHrFLFzJhxKiLbV5rs0Ug0AaB3BGAOf2hMQCddZovN9ghfUIr8HHfHFbqJy7rX7BvXw/Bcr8pNZxsGmzGN+y4SOR9Fl3ZnTvI6lNRhzO5+Wpr5wzuf4he/Tp0ULQPuxHfiQw2XJd1YFyfcXvH3qP/396HdSLmmi+hZspF6RaM1av/OEuBFVile+3mwYTYexKmJQHSZFGy25U9j7/ypyhIXOhZO2pt6yVpBeKRtnEd30Naxhll/GGM21/x+E8WXu55H44OkQCKF+6Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 29 Jan 2026 16:04:39 -0500
Gregory Price <gourry@gourry.net> wrote:

> Move the CXL DAX region device infrastructure from region.c into a
> new dax_region.c file.

Likewise. Why?

> 
> No functional changes.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>



