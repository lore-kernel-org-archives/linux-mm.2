Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36F5ECA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 06:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71DEA8E000D; Mon,  8 Sep 2025 02:03:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CE518E0001; Mon,  8 Sep 2025 02:03:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E3F28E000D; Mon,  8 Sep 2025 02:03:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4A5D58E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 02:03:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1501BC45C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 06:03:16 +0000 (UTC)
X-FDA: 83865040392.05.9ACB399
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf04.hostedemail.com (Postfix) with ESMTP id 18E7740003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 06:03:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IN79HQh0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757311395; a=rsa-sha256;
	cv=none;
	b=hXA4/v+eNk43xRa2fdBf/Nh2REFKhsYa4ZMfldm+potexwg7v0D4LDg3ReTQn61Lc+y6YQ
	qbKf7t51CYhScijHhvm5gvTWhHC6xkb15EmrHw5xTBlV3nyi7kucDJixOkdXRW0m+YCsHZ
	Uxpbu4kQQvzGicYXMEACxjyDfpYS59Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IN79HQh0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757311395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZNWdSFuO4znuntXPxqyseJzzxpqp1vGgxisD3Po8ZRc=;
	b=5cva1Xm6AKovEOX4WPPgeLHfbDHdUyb/2C+MLjHehJyVghn6dSol5MXiSQ5TBFM2q3qj9f
	QNseTVA2v0RptKHjOZuULJlxinZXAmReDVSCfn1ZHQde+hUcCCG99x3ETNqgiT1JwOZVKf
	DsqaM1Z8xAkDEvxDKH5wIhZqRhJSu4A=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b482fd89b0eso3523075a12.2
        for <linux-mm@kvack.org>; Sun, 07 Sep 2025 23:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757311394; x=1757916194; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZNWdSFuO4znuntXPxqyseJzzxpqp1vGgxisD3Po8ZRc=;
        b=IN79HQh03XhF0fCxJbIOnhCllAJskAtyigFnhokbU06Rb7gzAxiDqaibKkswHBL1iV
         wb4LzJyGi2+NrtSY0QkP98peCBj6xCIkvZwUzOlymQBWzrL0E806YgFScdaSUrcNpPsK
         U+Onl+8d4raCCOUHJjDSM1a/+2c4fv09uTyqjgIugQNm3//r0XLdJrfLmplt3cGRvw19
         IHeeVD2kAyy5qgr5PQKUzhP8d+N3+Se4/PabzO4SHjJy0piTsShci2gCNn9bN1AGvHgT
         FteDR9e+QzZ9fWKB6sMVtJF36nYGvDvGuOTpBfmsodxQVUUWaLkdBFl0PMrVoYP9qcPk
         1zbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757311394; x=1757916194;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZNWdSFuO4znuntXPxqyseJzzxpqp1vGgxisD3Po8ZRc=;
        b=Kws4VI2SEjiE8i1HMDWHU8JgAfslNAxdgMKkDk1ZjnIE2S870V7vmMzf1j4drH3uNg
         1GcKi6uRQ42gJvF+qrbuECrZC5WNYPQ1/f/w2hau674ZBSsnz549oBHUpCWIT/+rEkA5
         HQFVQAdGvR2hYFUYvVm47uranDGtWuvhVpVB6DOHSZLNomb9LpFaqQn+wP6/AgSta11i
         C1NaPrympHkxhdSkDXV+rLrrOa4uHnPzluqBciPvv5abRDXV5niF5MzA5o31wP7spw6X
         UJbGaiIhWYnoPsS4BiyOx5EYY5uHq5PhAVIlz2FVN5K4vSyJ2Rojmntp9kqflrJEfoUB
         t6mw==
X-Forwarded-Encrypted: i=1; AJvYcCXPYhPTz9zHLAfZFszXNCNHsDkU1SiOBVEoPtrWyzKIogGW9aIdtewaRzga3NxLOxu+OQDdH42y9Q==@kvack.org
X-Gm-Message-State: AOJu0YxdnhLoEWwrwzD4HDCl0XI0X1A/XF8HddW4pfSQiYjM4SYWewz5
	ZCKSOYlo0Yot/OwqVYxBi5jE1KRean2VPWVK9jC72mEP9QRSxDjAkLUo
X-Gm-Gg: ASbGncvYYjjfC9EWQUPwiQ3lGwy13xmMh5tJQqHDQ6Ki6J52cLRHRIZ0sKHAACBpaE+
	zzBJ5uXJZLRzXUtaNY3GyVpcKFTQ16RY7TyasMY4DMaE30RPBsyoR2BHtbUqt/BDfO2/sG8eNpN
	gyb5Pm0AnYKedEycvm9Z3GmRH3bRqJZ6SMA4tDzJeoyPlN2Bhb89anJkZCOBO1cUpsVk/wj7zEc
	6AK81j1YsAbpacZi0lYonW1kZB3XXgE7wvGoRIUBHG/pg5bGGQyKxGIDHyVnjJMJtpWYbrjfosD
	xj1nabE3bS+24IoyQIZe0tVAPg0j16vqJMqQ6p+/y9y2BeSYpiHpvLnyARjD1X/FUIhGFhBAWbs
	qukQ0QpgXsWQTOsm+9/mPXemn3HWxzo5QegDo2Q==
X-Google-Smtp-Source: AGHT+IGaMF5Ba8B6t4H2vzMTPALt55ZTJj/NUECpMhpJBlfxz2OnagbMjg7YIyiTxu2dTK5kF1UxJg==
X-Received: by 2002:a17:902:e541:b0:24c:9c29:c9d1 with SMTP id d9443c01a7336-2517493a09dmr107170825ad.59.1757311393773;
        Sun, 07 Sep 2025 23:03:13 -0700 (PDT)
Received: from localhost ([103.121.208.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24b11833ac7sm166868285ad.55.2025.09.07.23.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Sep 2025 23:03:13 -0700 (PDT)
Date: Mon, 8 Sep 2025 14:03:11 +0800
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
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
Message-ID: <aL5xnxEO0NP5VlpL@mdev>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
 <20250904002126.1514566-4-wangjinchao600@gmail.com>
 <aLlFDQkWBF0N7xmk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aLlFDQkWBF0N7xmk@kernel.org>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 18E7740003
X-Stat-Signature: b9eay9s34ku5ydkwfmbd4y5mgpg6e76s
X-HE-Tag: 1757311394-744222
X-HE-Meta: U2FsdGVkX19CnDLrspdjyZcN8xS6n9Mc3XihvCfnhA7IL9oZ8cXCce1AF2v+c1ft15FSS2RR+/tYIcsabOLQ4610rfKbPNq6z+xANBcyUbEw/DdCtYcW6TDrD5n6sNTjIdzFOKxGjl7Te4xI5pGwg7Z3ZoPq3i/bbtXVq2V0Sh668n6hBpYHZSu9aa6WJxyI//323t/J7YdQ8e8WUnjic84rSWeSQuiRE6YE1mk4wZu4CPpgCogs0TtA2cWlSHPDbRN8EwAW0TvIoyiWSK0YkTe7DBu7Bbz5Y+mwqF5N810QrLcPXm8+9EKZvDWNjqs1SlCCdmUZvd3THLhnea8EdqmIldNbuEMLtCzeF64ZCr09/OJQrH+KLTOB8Ycz7aTJAVLKinzy783dZg0p9LCtmobh2SJU2F+k7ly4XTBkhM/RteymY3XhJ+K1rYUpMUu18KRXvLRjS+M8Iiyi9LZrr6QtawjvVh+iPwNMndFv6x8XtA60WsY/xSatvDI6BmQe92grwW6EoV0xwK4hEJc8nFB5ZAmqCMBRn79+0AkkQskxrxZd68/gFLDSyFsGinvgq1zMkfzNRiTRAovHjU2VW/W5zwcmlMkJwmrj9RH2vlG/VqZ2eiX8V9HY8fy5Zr6GdOh/hfHzT7nHjqo2WLV6/lvYCD5rprVLhf3C6Ok/ZIS6dNEk0j2QEsSF1Jv7G0YLa3zmHYJKVtwrGl2wlio0LRgM5jR8oJa+tv45+lWyRC6ryXIjvvligvWjl7iX7FZ+TWcuQ514zD30h2i9DvyOEI/3ttzJuOTHKEWKLODDyVvgnX6fx0DMYPW76gt5hN7VWL3jcnvFmqq9PhGo1ObbpqhWr+AjGVk0RRro/0zfXfV8B2t2ROe+y+kkGTd1f6LI9Kcu3rja2dXrsa3ZcnaWCtfHCylW8WqTgr5TITGPabMRVobZ51Jlbv7LkbH30vVzxBLzRwbXFmPryNkgJ52
 B6+xLSQH
 kLcFf1EgrBn8Yp3kLpGXiit6s4blFbxIZ9JlbaE+SeD+10IkMbIcuibyyFtPvNX3z2FqNFjFV1IOQ2ek7eZubtFFmogDI7Ro27necdF/mUcP9KVuxrCBpO8fpUg/RnbXxRS1PVTWnAvefqUG15m8dJVql8tN1T1xG29lhVrJlSUOv3W9CS025t4ZCcKhubfN1sxRGwsk1QsWay0JouEEStwIAjb5FYsjFAfH++TxCcblcSfp/E9Q4a1tBWb/7OjuVWhU8judyGUjXhUgJnw24ith4bERXlufRKNSHtctCkgtOdG0TbLBQgqbdzaTXW2H40HZ83SOgQuGLqRdOOKviW4oaWj9nDNvK+fmW90piNbmFme1ZEaeXvBtJJNIIHTZTJfyyAFgyVrF5hbZpM1vlZMgXPkO9NUWhXP4xKPjiz3hXXJtV6m49RwBtfiOK2Pn/fntAvYOD6X3DLQexfRkAM40DLLAEmk8XTAT7YWOyjf+l2tY05FtaW0VVu0Uus9G1svpvVMGhYCwNNnDSvBBQykmuz04cYa1WI2n0z4kaleH3sw1AowHvaJ1npaahb4mQMQH7SGLAEM7KDzvztlxZ8OsN8NLPIPNW5AjKDpBMvznUOFEoLNIzBGuU1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 10:51:41AM +0300, Mike Rapoport wrote:
> On Thu, Sep 04, 2025 at 08:21:00AM +0800, Jinchao Wang wrote:
> > Provide the /proc/kstackwatch file to read or update the KSW configuration.
> > Writing a valid config string starts watching; empty input stops watching.
> > Invalid input stops watching and reports an error.
> > 
> > Allocate a ksw_config struct on module init and free it on exit.
> > Manage watching state with ksw_start_watching() and ksw_stop_watching().
> > 
> > Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
> > ---
> >  mm/kstackwatch/kernel.c | 140 ++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 140 insertions(+)
> > 
> > diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
> > index 4a6dc49449fe..95ade95abde1 100644
> > --- a/mm/kstackwatch/kernel.c
> > +++ b/mm/kstackwatch/kernel.c
> > @@ -1,7 +1,10 @@
> >  // SPDX-License-Identifier: GPL-2.0
> >  #include <linux/kstrtox.h>
> >  #include <linux/module.h>
> > +#include <linux/proc_fs.h>
> > +#include <linux/seq_file.h>
> >  #include <linux/string.h>
> > +#include <linux/uaccess.h>
> >  
> >  #include "kstackwatch.h"
> >  
> > @@ -9,6 +12,29 @@ MODULE_AUTHOR("Jinchao Wang");
> >  MODULE_DESCRIPTION("Kernel Stack Watch");
> >  MODULE_LICENSE("GPL");
> >  
> > +struct ksw_config *ksw_config;
> 
> Does a global ksw_config imply that this is a singleton?
Yes, it is.
> What happens when there are several "echo .. > /proc/kstackwatch"?
> And even more interesting what happens if they are parallel?
I did not consider this deeply enough.
I will address it properly in the next series.
Thank you for pointing it out.
> 
> > +bool watching_active;
> > +
> > +bool panic_on_catch;
> > +module_param(panic_on_catch, bool, 0644);
> > +MODULE_PARM_DESC(panic_on_catch,
> > +		 "Trigger a kernel panic immediately on corruption catch");
> > +
> > +static int ksw_start_watching(void)
> > +{
> > +	watching_active = true;
> > +
> > +	pr_info("KSW: start watching %s\n", ksw_config->config_str);
> > +	return 0;
> > +}
> > +
> > +static void ksw_stop_watching(void)
> > +{
> > +	watching_active = false;
> > +
> > +	pr_info("KSW: stop watching %s\n", ksw_config->config_str);
> 
> This module is overly verbose. Do you really need all the printks?
You’re right — many of these printks are for early debugging and not
needed for production. I will remove or downgrade them to pr_debug() in
the next version.

For critical paths, I’ll ensure only actionable or WARN-level messages
remain.

Appreciate the push for cleaner logging.
> 
> > +}
> 
> ...
> 
> >  static int __init kstackwatch_init(void)
> >  {
> > +	ksw_config = kmalloc(sizeof(*ksw_config), GFP_KERNEL);
> > +	if (!ksw_config)
> > +		return -ENOMEM;
> > +
> > +	/* Create proc interface */
> > +	if (!proc_create("kstackwatch", 0644, NULL, &kstackwatch_proc_ops)) {
> 
> ksw_config must be freed here
> 
> > +		pr_err("KSW: create proc kstackwatch fail");
> > +		return -ENOMEM;
> > +	}
> > +
> >  	pr_info("KSW: module loaded\n");
> >  	pr_info("KSW: usage:\n");
> >  	pr_info("KSW: echo 'function+ip_offset[+depth] [local_var_offset:local_var_len]' > /proc/kstackwatch\n");
> > @@ -85,6 +217,14 @@ static int __init kstackwatch_init(void)
> >  
> >  static void __exit kstackwatch_exit(void)
> >  {
> > +	/* Cleanup active watching */
> > +	if (watching_active)
> > +		ksw_stop_watching();
> > +
> > +	/* Remove proc interface */
> > +	remove_proc_entry("kstackwatch", NULL);
> > +	kfree(ksw_config);
> > +
> >  	pr_info("KSW: Module unloaded\n");
> >  }
> >  
> > -- 
> > 2.43.0
> > 
> 
> -- 
> Sincerely yours,
> Mike.

