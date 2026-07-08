Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE137C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 07:48:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D424F6B009D; Wed,  8 Jul 2026 03:48:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D19816B009F; Wed,  8 Jul 2026 03:48:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C56A16B00A0; Wed,  8 Jul 2026 03:48:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9EEC76B009D
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:48:15 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2B43340335
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:48:15 +0000 (UTC)
X-FDA: 84964831350.12.AE182CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7A880A0007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:48:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LjJlrrq2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783496893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3OevjrqXdRJOTrMJtKKzkDBmycrF0jmHB4LMFtbouHE=;
	b=vPaUWqQsJMqNjiwz73r9Tw7M7wwWV9vzTTS4id5/EBezGlUk1vSpCicxQYczbT+GQRoDzn
	AgiGS1jaPUxBqc/4/Li3GoGBTVvvXCvX/srTVMjj2Y8nHTycbN7V0ZG5V4IVIngwyfVojR
	Xgt3NlBJ/wCZzp3Bucjyz5ktMjZCCy4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LjJlrrq2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783496893;
	b=Xjw31KKdi+K6M09vMGrxvKrlobI6ZEYBrJ6ssvC1h6lurubwAMECL0gzBXpp296KvxJ1nr
	r8ClW7koJMYsme3ASJeM+j3N9AOLo2tdv4bqfjUzNu7Wi2n5qego6xwOR5EpYWX4vQaijb
	8T98Ej/e3d7Rgd0rGhDKLEtYfr3KC2M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9732D43A38;
	Wed,  8 Jul 2026 07:48:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58581F000E9;
	Wed,  8 Jul 2026 07:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783496892;
	bh=3OevjrqXdRJOTrMJtKKzkDBmycrF0jmHB4LMFtbouHE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LjJlrrq2oFTukn2i1pCUeSiArZM+6hQwNFxPYuh/g4jt66M47+7zhAhVufrXJTXvk
	 AYGtWhiMJP8oNmL8n8nXqUgv6HcBAi0TGS6ok7M3saBtRWkgpxKgGjhPam/vaNydxr
	 CHIJLBeX77gHZsupfpi6opKk03yZQ8eKPbuUn4pn3WL92SCHv2VSxiLF0NCmigi5ro
	 CFqHb+DMeL6sc73iLwtBHsA/jRtqZvbJdwhlvt3z+168bJLs0cz+8ixPo3/IuOv3rN
	 HiBlWecG0OBlYEX9SIrBUR4iWn573796Y/jk1BCDlj+rRRWhUoXoRKebDzZQ0UpIvm
	 MK4PX9aO5dTzQ==
Date: Wed, 8 Jul 2026 08:47:51 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Cc: Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Eugen Hristev <ehristev@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, Frederic Weisbecker <frederic@kernel.org>, 
	John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, Kees Cook <kees@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Petr Mladek <pmladek@suse.com>, John Ogness <john.ogness@linutronix.de>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Bjorn Andersson <andersson@kernel.org>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Saravana Kannan <saravanak@kernel.org>, 
	workflows@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-arm-msm@vger.kernel.org, 
	linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 11/26] mm/swapfile: Annotate static information into
 meminspect
Message-ID: <ak4AgXqMnkn8rVGE@lucifer>
References: <20260708-meminspect-v3-v3-0-7aa5a0a74d5c@oss.qualcomm.com>
 <20260708-meminspect-v3-v3-11-7aa5a0a74d5c@oss.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708-meminspect-v3-v3-11-7aa5a0a74d5c@oss.qualcomm.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7A880A0007
X-Stat-Signature: ntbhcwishdme9x6rakm3bz5knt6oyjun
X-Rspam-User: 
X-HE-Tag: 1783496893-72870
X-HE-Meta: U2FsdGVkX18A7Ha1rhB00D9+VjlRn5fQjBEe0mYd+OjFNGLr22ebQQrsGe9bgOf6+waX5OpOzJT/jrZStU99W/ACFKZipOPHD1DY4av8g6ScdQzKeR6r8O9MKJaRCYsh6qOxZSgI3C+0BMiQDdpeAc8O98wmLeUXwT4X2HG3BQato+P9frUjT/YCLzL47MW7Zt8fPCxj0DDBFIAdClOBl880qzIWw7ODjz31H4W5MxvFxrzFjCtofbPQ30hMOhLl7upLWyVCXPO+oFYfXJOqRwh0hdZ4LIyFQMojLz3jn0RQCbtVO+oYE6pke93LRUhO7XAb9vm8sLXcoUGd+o56Nj4sJtYnnNU5EGmWHaaEabHgeamUfNtiLv5Hr4N9+CEawSuXyx55nkOf7GrDF3m1aaOnEEyEwW3sURXx8AR9h2f98YYNOn32fHmNQJJIzUkJ/2gabL+gFCHQIYL2akS+0t42KagzoG6QazpJz5lJfj3FWmCHuScGmlw1ZvtEM5G7MRO+auteXohGOTOnb/P00e3+vR4MErH4qBN3zUKTrlDUakNIPkunXLOISLP0jd1PWUp6DWbJ49cKWHjFsVfqA/Vap/RtKviObPphKsr7fZRbS6rdbsFPxHo+dzUMJm2pCO8zJVEKFIELBbgFLgIa9ud33KveOqeJVuILSGGex/GXXHIOdhl1bETchwe1YJJGfMkf84LBbkY0a4GGJkJswdooKhYLKXGJnTZTh64hZigBTZe9BCwtNn8rzAtyoznrIEL/KDrnmr3nEksN3V6B8xrXto9pXnxAejpmr8COSJncL7jf4DsBrnlLzqt3NS2Mw/WryasbMpqsWFTOw5EYuy9V67S/B4b6ukKDwmJz9ECd+lgT59lkBYLxFSlWy9CdQ71cvcEAqbvED0WR2dq7CqCBG8oeng3v90kkYGHErZKRK52GAnGsV5Ufi6YwSKHmLIKG4Cr8lwu97TFEe/T
 8fWO1tWc
 S3s3WYpD71Ru+VcbI+U+Xd60Xg1p4XFlpZxY7xI5+Dd00xQuH2flfCHILU+mcFZYW1Dz4Om/3mdrE6XqmXeuWJQ3p/d8R32RK77Xo1Qxm1lzFCk6AiYn+L/gGYxT6atmuf5gbIXbSK787wzAHHQrfl5toZ8CJdFwv47DdcNgIP1wyj5Vw7Nx8u5eucsyCDodP/0B6JzTPJW80Ql0np+P60wPtQ6pVWA3gKViYlbkZBLm5BF/He8MSvTSa6vuzvetoxWKQ7KxZNgWloMWYizbqItVx5HUmSmI2CrumgeBpUJpd4/JbE8ReVWMURnYxgYZlPVOstVWwk49ObUOFwx3BT4KUXaNpEqNb4yZumAbu8Eodn/YnAHYMUkJsFwh24qOagTOusYUFb7ySawdPWXZos7QJ/TD4Owe7T2Wl6j2sFGV93/5LqhJSTaYbbvzHJp8xnaMZOLTiywHiwUFvGY3aNDTbPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 11:01:50AM +0530, Mukesh Ojha wrote:
> From: Eugen Hristev <ehristev@kernel.org>
>
> Annotate vital static information into inspection table:
>  - nr_swapfiles
>
> Information on these variables is stored in a dedicated meminspect
> section.
>
> Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
> Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
> ---
>  mm/swapfile.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index a602e5820513..d480727e4987 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -42,6 +42,7 @@
>  #include <linux/suspend.h>
>  #include <linux/zswap.h>
>  #include <linux/plist.h>
> +#include <linux/meminspect.h>
>
>  #include <asm/tlbflush.h>
>  #include <linux/leafops.h>
> @@ -65,6 +66,7 @@ static void move_cluster(struct swap_info_struct *si,
>   */
>  static DEFINE_SPINLOCK(swap_lock);
>  static unsigned int nr_swapfiles;
> +MEMINSPECT_SIMPLE_ENTRY(nr_swapfiles);

Now the EXPORT_SYMBOL_GPL() is an EXPORT_SYMBOL() in effect no?

>  atomic_long_t nr_swap_pages;
>  /*
>   * Some modules use swappable objects and may try to swap them out under
>
> --
> 2.53.0
>

