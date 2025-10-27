Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADC66CCF9E9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 03:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 969E280011; Sun, 26 Oct 2025 23:25:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91A588000A; Sun, 26 Oct 2025 23:25:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 857CC80011; Sun, 26 Oct 2025 23:25:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 720D78000A
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 23:25:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0E52148A56
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 03:25:44 +0000 (UTC)
X-FDA: 84042454608.19.829FA6F
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf19.hostedemail.com (Postfix) with ESMTP id E64AB1A0007
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 03:25:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=w+5ZrUs5;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761535542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/jozjS1vRHTv6C7q6QJDKxw+pz3Pe2g0a97QFylnV28=;
	b=3akwXDAeKz3gXqrF+wknixmjLcUD4OEFoiD0wJKg4u9kurO8EkGqjtUxoGrP4tgacr3usx
	XkBHh6UwqAZzizuY0EKLl7igNvvC7JJftQPyNTwK2sbRjpSTlCGK3FJfCKMnlAUTJkM3D6
	eRCnrPu4OJ3WtTi/LSqbYwgW8fyauZM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761535542; a=rsa-sha256;
	cv=none;
	b=nT85x3OM8VGYW2yRtZQYt0J6dKMj4/BFKVGnP2074XpKI2XIAP6A4g93rHIjmWyR3X7cwF
	31gVTNe5EpwkxvYk/lN+HkK+WkNLBxVcBxJdi2LfsxGs6xd9IXozYQOlwLzvXKwpcHPlBp
	WvVNjaN0io5SnuNDSXbKm/UaxMFx4n8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=w+5ZrUs5;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761535537; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=/jozjS1vRHTv6C7q6QJDKxw+pz3Pe2g0a97QFylnV28=;
	b=w+5ZrUs5XBtvRzoCTc38h2giQy7ZUGSpSglhAhKifMUJR3H9ARJ27QLoVjPcVLI98xaacW7m7bbvz9HLXW4Do5LY1IUP3/kDKjE4F5dM3ZNkckTa5h1SOfXm8uU4P3SKoKI/JerTHEs1qkjghApUB+F78ghspnE0hHYnKjr7lgw=
Received: from 30.74.144.189(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wr-v7UX_1761535533 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 27 Oct 2025 11:25:34 +0800
Message-ID: <ad974920-658a-4909-8160-c54f7ac9403a@linux.alibaba.com>
Date: Mon, 27 Oct 2025 11:25:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 mm-new 07/15] khugepaged: generalize
 collapse_huge_page for mTHP collapse
To: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org
Cc: david@redhat.com, ziy@nvidia.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
 corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
 baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
 wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 yang@os.amperecomputing.com, kas@kernel.org, aarcange@redhat.com,
 raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
 tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
 cl@gentwo.org, jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-8-npache@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20251022183717.70829-8-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: m1n57kq4knijtirwiq1q7czfs34adput
X-Rspam-User: 
X-Rspamd-Queue-Id: E64AB1A0007
X-HE-Tag: 1761535540-770607
X-HE-Meta: U2FsdGVkX19P309xp/cnbY+gHzu3ebgEnUzpQglwEjouae7BETp+9iwqrZFCeIwHb/1T/Ybd3MEkUr5iJnfKTfSF0Av7rXferhqInhRrxK/WbzTk5dTbc2KWi92n+3BZlHlygWDAoBJ5lEq6u3sTeGGcxgtAUP2HzAQ1kzELJF8n/YToH0Sagum7Mw/HI8etXKyU+e+uWn8zFXeNSlZo/f+MsT6SxvdI1dZzGHvHvaHhCWxwfksn09u25L1R67YLHze/tDcryOM1m0i3X+okRCY2f/lw+cI4nOWGO36zLXPB5mA3tOu7DC+raxAOqHXaFunaX+Oaus207c+N9DcdeKSstPQtFs4V4A9GlbWvsAfZLUB1TTElWSpBHoQeJ2GWVheFIB+/V3LOQsiWj9A5TpQWnV4ywuppJN6zFq77Ka51FJpx5p5o4qHgaGRrjuHfyi51MiKwf9Zlb83uEnIHvis5AqIuJUN8uWgMRbHej9UgjkCVNPCLtPSJY4cBBBI17TBP5FtxslhZpuOq349t8rCAp+cjjNFAR5StMJpZIXUENGa7ijXd4prOn4Eio8Vbi02hU4J/bkYrcxxMKt2v2H638oQJsIYp0eMtOLdbPiskEkMutTUnxuL9m/Dyp6pXaOH3EgsJmqIPVBCvAQsFZFBE/v6fdJCeg2DKmrvvv4N9Fcz872mDlIDJT6W9TxaYGiW7A32gfjWkcl9UexgoeWDB0yWVM7MTV1JHPadDWPAivfYN7uYpVBDpLgd5USzWL8a1TsX4yEbGcsmlavSesTqgDTuXviBO5TfvmFvCkOzjzcN7Da2x4OGAlUPy2vpKk5g0C71SN/XQ2ZSkTiSK6fKtNpRP2SDR1BrEnlxd/ilDZ2ZWxzvqG/WvxazNE8Th6X3W7IkouFKBkyfEW7wRRe+Zs0V89wK81DeKwZS2YXBhuQG4IyKMTZ+Q6wOmjQ+hFrbwjoaHzXVvJQrdyrM
 XF+0JKLP
 zRHUx7Bp63nNLhGv+nblo40xMPCs1Dq1dqDfH+D9RMs2/cCQIqklv+rsDaXc1fDh6VVBrmVdbuFWWgBKdEafhCZDNctWa9EvHub5R3Ys5nONI9bdpLpt+S58szF2tyqAzdrTgUGy0n5ZzM4Jg8aMvcaICP33YO7AGO4JBxcIme58pBBaTXNvh42U4+5rowC+qKTrCH79uR8ZTY2rzTApmVbSout4oN2Sv9TrQyihhWP4l/xRySJllPcPpzuVKxfPuEb1Xelu/M7C2fqCvVah83xk/cE9Ggax70RvqI+Mnj8u8nfq/FJsiw7NsbcCZXzDwaGrdt6uWq8LNTOFMz9Us8/x5Ln/YJa59r1JnQna6iEk5wLPgmFl1UySSrGUza7SCiStI27LA249EdgtR8VCX8WeNTFwBqbRDnInoCB0a8GGpfiH0lQ+unUSkUH+qtoHvl2zyh3KUkxzn8jHfKMFjUdLHeEJkXtRaOs6H72Ioz8pWgX4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/23 02:37, Nico Pache wrote:
> Pass an order and offset to collapse_huge_page to support collapsing anon
> memory to arbitrary orders within a PMD. order indicates what mTHP size we
> are attempting to collapse to, and offset indicates were in the PMD to
> start the collapse attempt.
> 
> For non-PMD collapse we must leave the anon VMA write locked until after
> we collapse the mTHP-- in the PMD case all the pages are isolated, but in
> the mTHP case this is not true, and we must keep the lock to prevent
> changes to the VMA from occurring.
> 
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---

LGTM. And passed my mTHP collapse testing cases. So:
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>

