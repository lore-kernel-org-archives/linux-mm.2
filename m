Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D82D6CA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 07:51:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A7C48E0007; Thu,  4 Sep 2025 03:51:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27FD38E0002; Thu,  4 Sep 2025 03:51:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BC298E0007; Thu,  4 Sep 2025 03:51:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0BAA98E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 03:51:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A57175C2D9
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 07:51:57 +0000 (UTC)
X-FDA: 83850799074.12.D4F4E7B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id D6EAF140003
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 07:51:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dCfOKTW5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756972316; a=rsa-sha256;
	cv=none;
	b=as7nYulUH//aKgqUhUP25zJSi5UH9io7PaYUUskEQrytrML5wrZgvNG/G3KMzYu0H/vl+O
	Kq6eWKUP2cMi6wYEOd21DlVfpdwWTWcT0rIszlg9qt/yXan4z4oDAymERn0w2xA4bilrnp
	10rx5JFdKqWhxiTEIs6EO/RxQx8gZZ0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dCfOKTW5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756972316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LeIvzZVxBDGvPFwISXv5rpIJ8ywPIJ1UY9bkrlehq0k=;
	b=DG5ZY1WYI6wv2JINeRwaSN5ZYgTNwLst2gNcT9El8r5V9AKr7mgy8Di3j9EmoecnMGf6fw
	4mmvtx42tAG9087COEbvolM75sUsn418BG0KPa7cVZN1XUPL8JZz02L2Ev20GSvUrjskji
	JOAmP24iZyxm+l4iMD8L4svgr1vaMso=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B02E43AA2;
	Thu,  4 Sep 2025 07:51:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3835BC4CEF0;
	Thu,  4 Sep 2025 07:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756972314;
	bh=rE0KWJrKeJt22T4AYZywb92G0O/oP+xSleFmSknemCA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dCfOKTW5QmsGiI7lfLidL4A7U/TqtlUK8B/Z+xXpeK+xOv/o1wrjKImlBIm7qoqyp
	 vWrVbcvDgLaQtrmSWW9QnceFY+vaWOifv+eJybBINP9rST+hO74eb4Hh1G6Wt2hT2x
	 oYH7Xt4OZmWo0rLzgu7qils5+FxRsbp4e+uUQ+8jKyYxWZeWCUnNCkDNyYWUdjqt7g
	 bJ8p8EcEjqpIpV+HifHSHDE67CtJhrDcNFsZZRE5m7jVHfjhWAlsDpevdqJdKUJbMq
	 3I219i+m22wZU7OsFAA2EZ6VaPOVZSpZ+B3A1yVRyCh2uk7Et7rKEY6W+5qJAvvCe4
	 y76jW/0hht3XQ==
Date: Thu, 4 Sep 2025 10:51:41 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/18] mm/ksw: add /proc/kstackwatch interface
Message-ID: <aLlFDQkWBF0N7xmk@kernel.org>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
 <20250904002126.1514566-4-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904002126.1514566-4-wangjinchao600@gmail.com>
X-Rspamd-Queue-Id: D6EAF140003
X-Stat-Signature: oqcf3g9c85d4msfrbccrdu64r1q84tnu
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756972315-451177
X-HE-Meta: U2FsdGVkX1/X3coPfwiiamHqa2afUFj/HHnbIByYfXfIhkkhcFbiQB5FtscXIfgknUc01VkyptlWAgds1rOvbVP7AkQwUz3G173liQaFmASBhl3mrTA3+bYDSr9b2M28/5NhKnDnFji6mF5BtBnDz/zT5SqDutM/7yYQudkNVBdX5eZ22j/Ek8humDJdn0LMmD9VqKGTRa6tzhNcQf4/RIDijocn4FAA9+gzcF+ogw6ie2ms4NxOnsL7jAn0nSev9ATU1TPTYqKVfQyrwG+VM0CGkzGGUzFcDgRwZ0tvoGNPkry8OD/XuWw0Ig2Mmi325r8eNLtBbDbLDESPXkb15JSKv7EKqvDecKALfGbrTLY9H/WOhJvvAIB0k4iA/uYkDk/ad+uShSrRMomhev+tFcqFVYGPVdGo8b/mHDs09hyNeDU96skj/+RbONhVyTO1A90F6ropKnEYNs3QaESIoCwr7ViTv0M2JtdasuQoNHwfQovzXhUzR0v1s8mDGIVW9Z7OAxF8GVrZbFbBpDvN4p/sDonVHENybbSUeRXtrj5ubn6rVZ3dtWYH3Ovdm2b6BR281sQyfQFhUzGWhmznVvW7iRZKaAgJcbYGBYBbNEdtJj4/YuwA7P9C6q4tBDMGx+ZBGcylmbKBarmSQGSJ2jcnLt7luMuvmK3ssuVCdvF6Dis11GDgV5cQ4Q0RpzfGOoKajc+MuaafkmsSQwP6iEwUgSP4y/2RcK/gItDO4/QTH9OlfhZadA8R4H/Kf35VKHhxa1lgXbmGmKRONZn42B0sAA0BLJtdZnu9gpE5kmEopgXvBsHoC/rbg6xavYgjuFAnZMfFXgtXESIg0aSiFSXusrRiJ46m0AOcg7QXp9LwP1s2Mzs3gHjSz0ebnbN5PHgOJWL0u4YFycKo5zjJidcRYuMOuaxf3eZEJ7oGCCdma4iJkhpFBcDJDlugspKdw8t3Wx0A84dystCgXP0
 hTBiNAbQ
 Er4HzlyqSXVYTLdldH+Bik3OevQBNZ2phk3DIJwwGKa9VgtBlWUyLYK2KELdtebBD+tSMBjW6ast/MPgtEJc+cIiuESLAs/EA8qWBwoPAvXopTNIfCJlpArteKPUYOzJR3EObp2125XC1WWoFM5U58QkdDxFy/qo75V6F5s3NlWwL54+Wmdgz0cY3dp5ATvMWq9Hsq9Ev96QOV9fc/8LobPqAQ6Dm3Qq/Zvmswl9zEFlua12N6wO3SdTZzodtntsUruJmZQ8fjoYiX/RJ9HRp9/j7E61dYRgxzkBFiyFZGGGyp4fYkM8o5N4bBguF50G1r9/+Rn1h3yGCAQiHhaUCRgv+TOZkcjHbDPt7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 08:21:00AM +0800, Jinchao Wang wrote:
> Provide the /proc/kstackwatch file to read or update the KSW configuration.
> Writing a valid config string starts watching; empty input stops watching.
> Invalid input stops watching and reports an error.
> 
> Allocate a ksw_config struct on module init and free it on exit.
> Manage watching state with ksw_start_watching() and ksw_stop_watching().
> 
> Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
> ---
>  mm/kstackwatch/kernel.c | 140 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 140 insertions(+)
> 
> diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
> index 4a6dc49449fe..95ade95abde1 100644
> --- a/mm/kstackwatch/kernel.c
> +++ b/mm/kstackwatch/kernel.c
> @@ -1,7 +1,10 @@
>  // SPDX-License-Identifier: GPL-2.0
>  #include <linux/kstrtox.h>
>  #include <linux/module.h>
> +#include <linux/proc_fs.h>
> +#include <linux/seq_file.h>
>  #include <linux/string.h>
> +#include <linux/uaccess.h>
>  
>  #include "kstackwatch.h"
>  
> @@ -9,6 +12,29 @@ MODULE_AUTHOR("Jinchao Wang");
>  MODULE_DESCRIPTION("Kernel Stack Watch");
>  MODULE_LICENSE("GPL");
>  
> +struct ksw_config *ksw_config;

Does a global ksw_config imply that this is a singleton?
What happens when there are several "echo .. > /proc/kstackwatch"?
And even more interesting what happens if they are parallel?

> +bool watching_active;
> +
> +bool panic_on_catch;
> +module_param(panic_on_catch, bool, 0644);
> +MODULE_PARM_DESC(panic_on_catch,
> +		 "Trigger a kernel panic immediately on corruption catch");
> +
> +static int ksw_start_watching(void)
> +{
> +	watching_active = true;
> +
> +	pr_info("KSW: start watching %s\n", ksw_config->config_str);
> +	return 0;
> +}
> +
> +static void ksw_stop_watching(void)
> +{
> +	watching_active = false;
> +
> +	pr_info("KSW: stop watching %s\n", ksw_config->config_str);

This module is overly verbose. Do you really need all the printks?

> +}

...

>  static int __init kstackwatch_init(void)
>  {
> +	ksw_config = kmalloc(sizeof(*ksw_config), GFP_KERNEL);
> +	if (!ksw_config)
> +		return -ENOMEM;
> +
> +	/* Create proc interface */
> +	if (!proc_create("kstackwatch", 0644, NULL, &kstackwatch_proc_ops)) {

ksw_config must be freed here

> +		pr_err("KSW: create proc kstackwatch fail");
> +		return -ENOMEM;
> +	}
> +
>  	pr_info("KSW: module loaded\n");
>  	pr_info("KSW: usage:\n");
>  	pr_info("KSW: echo 'function+ip_offset[+depth] [local_var_offset:local_var_len]' > /proc/kstackwatch\n");
> @@ -85,6 +217,14 @@ static int __init kstackwatch_init(void)
>  
>  static void __exit kstackwatch_exit(void)
>  {
> +	/* Cleanup active watching */
> +	if (watching_active)
> +		ksw_stop_watching();
> +
> +	/* Remove proc interface */
> +	remove_proc_entry("kstackwatch", NULL);
> +	kfree(ksw_config);
> +
>  	pr_info("KSW: Module unloaded\n");
>  }
>  
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

