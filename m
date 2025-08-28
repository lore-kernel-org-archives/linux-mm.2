Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D61FC8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 08:34:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7508E8E000B; Thu, 28 Aug 2025 04:34:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 728448E0006; Thu, 28 Aug 2025 04:34:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63DC48E000B; Thu, 28 Aug 2025 04:34:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 528948E0006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 04:34:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 025CB1DED38
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:34:19 +0000 (UTC)
X-FDA: 83825504280.19.09C15C6
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1B2E9180011
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:34:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LitlQByo;
	spf=pass (imf24.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756370058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oaxt8xPDHaX5/SStMCV3uDYTkxCNq1ZcKZPr2oUXvcU=;
	b=ONedO/7oXqXmdHEtGgnOor4c+W+wF16p44JPii0clVVXTxHGV0qvtKHXQ7VYfhu/l0K94x
	307mJxeO1UdTY0bZzqdDmcJX9SP8UPjXoeMoHhu3O/5xTWR9qY5vXbKVsGqWN+A36wNXVS
	S3tmkLYUiFppkPfr3Qam8b5UHHZfYNY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LitlQByo;
	spf=pass (imf24.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756370058; a=rsa-sha256;
	cv=none;
	b=CRa3H1+b35+T0XFDbAyeou0lrGY7uuyKYbLsfFY8LNyumBbU/QDhBeghIjA33MHCuPmBQQ
	VxQuIv22gfIW3MZpdAkWL+i4fjsHeY9tuBD2N4cV8bSWmt/zXt9cLuww/Hmg/qIoTbUf4I
	rTBP4Q+Fk+rJ3dr71o7C2cqq37EHCyU=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45a1b05a59fso4789865e9.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 01:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756370056; x=1756974856; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oaxt8xPDHaX5/SStMCV3uDYTkxCNq1ZcKZPr2oUXvcU=;
        b=LitlQByo9hDh/t/QfBy27mr85g+Z+zmHK+4PqSIDVIkzMfc2XmIWTtdZD/aSlr4To0
         ZG1A6X5Hsz4ZYSKR7mHnYArJGw5XvQxiNvi/yNwnGUrEww/oIoR7ACDotLLr+I5PlJwS
         3kaxnLI0/mFu+bQy1JIDvJHanUsaTg8j196g4/hKaTmVRdxZMQKeAZLylgvZehOWgOoO
         PI1MFXlcAGx9w0djS/HAzyGDy3/q8LMRoWSFxQyoTS2+kQNk6DwAMN+0Wc4XPzv3n3IM
         lUctOzfAqwnxeVz9YnMU1LyZ3RtAwonr/6phvLLu/SQr5xvGZfHj6QAEXtEDJmyLoZCb
         4l/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756370056; x=1756974856;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oaxt8xPDHaX5/SStMCV3uDYTkxCNq1ZcKZPr2oUXvcU=;
        b=hXL5b4kWxvF/Yix2I08Ur5RMauLZEy0ZVtoSAhdmJV3LY1jyqCmFpHyuvnQ6UH7goD
         FGPTL0DYAVoKN5Uet470/3KU1XDNyB1j4di6Ex/1c9sN/MjNnhMga4ecRX57CP1uJM4i
         26Xv0IOccOePgx6c/w8//Iri+tbgPW0NUUoP/RVmPq4LsSe3AaVq92EToNgP3278VZ7c
         NBxEpEBNGZJiCVr7LsRggf+6mbjXfWZsIrul4CenQSDcxqNAo9y36cC2Y3uTyStqmhKI
         LjfRAsfxns2uhmyJJP7nEdMu3I7UjzE7ER+pZm1rQwdBo89gnW7/OrTG5fNwwYKwlZKE
         CyTA==
X-Forwarded-Encrypted: i=1; AJvYcCVS3UfOsHVX2NEhPbIk3BATODm2/BdNfvEf3kmEJLKKGr4PPZt9V2KeryiKh30Pl4dEtOE3gXNQXg==@kvack.org
X-Gm-Message-State: AOJu0Yxkr53jbc86kEgbm5a/+PdyKpIWBOz6/dWhgvT23squc4Lp0y6E
	KVxaL6xM63EJabKkB2SisCmBzqkGz5tB8DEnTHb4QpgjWXB+4PB+b8Ni
X-Gm-Gg: ASbGncsNB9eJN0zzKML2nfr+D2rKLdpa4B9K1PIk4SOOWMlLirQ5X13VroTqVz1UnCw
	BwZdurGAOjqFL6W9FL0JvVmg0Qc76jHmLISNUvuvrC0+Qq7VdlVKJ1bDq7rKKCQWk483ElxASrP
	FlAH3uWlazlPZneSqfBXVRgKXMVogtjwYFr75chbjuxobutmE67NwrrVC1xnxef2W0zdoerG27f
	KO4RweYFh5k3OGsXJYeh+WYFGEkKVTw1KQTpI3tPZlzv3gzEKz3JHvRnFfMkWZVtsbJ78AFjNK9
	errZPMVjLWPqkPJSUa6oewbgvzfEXAfgS9N1OZXmlFZV4S66c1K/1+YTWKZ2doMkGwrVsUnohFS
	R1Vu+6sKFGGcy7xaIRorvCZMRu04juohD1XeO55g=
X-Google-Smtp-Source: AGHT+IE8QcGUDVFs6NWKw2kIqg9iEDJihZMckPcyK8Pf8fgxG94pUXuPZd5F+LMY9SACdjfkiZje1Q==
X-Received: by 2002:a05:600c:35c9:b0:459:d821:a45b with SMTP id 5b1f17b1804b1-45b5179e76dmr193622635e9.9.1756370056080;
        Thu, 28 Aug 2025 01:34:16 -0700 (PDT)
Received: from devbig569.cln6.facebook.com ([2a03:2880:31ff:48::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7bfb13a0sm10975985e9.9.2025.08.28.01.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 01:34:15 -0700 (PDT)
Date: Thu, 28 Aug 2025 01:34:13 -0700
From: Yueyang Pan <pyyjason@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org,
	kernel-team@meta.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] mm/show_mem: Add trylock while printing alloc info
Message-ID: <aLAUhXeRVWzLCNNd@devbig569.cln6.facebook.com>
References: <cover.1756318426.git.pyyjason@gmail.com>
 <7e2bc96faab1a338829e549246189ad96e6c866b.1756318426.git.pyyjason@gmail.com>
 <20250827150619.4e468e68988f224f9f9bea6f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827150619.4e468e68988f224f9f9bea6f@linux-foundation.org>
X-Rspamd-Queue-Id: 1B2E9180011
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 6p6jck8i4imonueoh9geqaiqzufr6gzi
X-HE-Tag: 1756370057-408011
X-HE-Meta: U2FsdGVkX1/1ox3gNLoR2Dlkev2cZN/0TbBW/XwebOc3hypxWC/cAw3JNH3fgW8VpSrLyqTo60Ynq0SOxYx0fzsunWcLLHTnaG63eytGo+fv3NaN06fofFsjF1YJup7qRVe5zE/xHZTfmuQEgB+4iJ3N4dz4lXPIhQ8IaKi1mNiTpVKcGQs+TroqTDOvIBVKe6VpVO8JeQfsAr0OQsePEjQzFH4rh1N9uMJpfgGdN/3NKb8O/rAqdqzefXBrEVQ2KgYzgZDzz2N21TVZJTeSddjDImkjtChdPwzod8d6PvaFc3qeuV7A66kMlILcA4dUXtn66Q9bvb+7D5rsmsYwjUJPj01c+QpYz7DfM/wZzdB7lHlyxX4ejjPfCc4w42GVF6dwJ+YQfrEedq3h7LWbVWWc89ZzUNfWyTG3Yn4BifJtX6qJrG2fEq9cwwOwI/0Ktg097fIsNS+ZOShCv+2VWgyQ8bNO/clRzHTGG921GFBkSSKj+z/rwk+EnSHZ6wUiYjHKXY6TLw9Wlfy1SlFRzfP52VzVEVIK/gkKpwByH+DrWPzAd8RFLuWWR5/LWkiK4FOI6ZUL2jXxrFz3t+bVDo7IOi7taEpr29mm0KiQjyFKlJEmXsP3oyNHvbRH/5a4D1DnPyUnV+Ra/Z/M0oWjI7XucuE2563n5SI6Jhfn4MN2BKCpdA2MOj9jpRo38+xqOT+iiY1HQWEtJis1YZs62X73NbHnrISOugb9B884De9b8hqiHJ8gcUG7Rpto6Iwb21GEjNmhWUTPx/dJzduMnX9NVaUrdx9f2GQBdV14OgBti480zL57GMuh4R4PXdt15/lewLV7MhyMFRRnWqfGslNFlpAvfWNdi3AARXsRQ+9U4lkdURUQnGZcbPOeXkYiju81+rjGMA+7TbrlwoZAaQWIOowqI4PZFcGIDozjDNzjf2maU3uWRou+Fu0iKn9Yobk0YYxsMbIrAorJ6tZ
 nm4GgoT2
 Fi/ZpLycImoJ7zB5YTexMI5bzzwFbOEz5TPwdhyiX+DUuoqVaOx6LVenTevXDs3iTgkKi++hrFERr9yMT4oTUWNDfJGgMk9Kib9QqXxWaCwwRUIiBOJQhujWG52aZNHC4yDJP00/B0ZeRYyeTGsQlG/pqY4ZjzcoKWH4ExjOMrLSLIYcDCUDumV+F/oRhVcM4dTlHcNdvNED86OMjpR3/fJ0A+4j7Z2Ujsp/b+1DOb6Pr3FXUpAePwx2FJEyjabEtds6tBB07x/4BaeG14M0ceBjG3yf/dJ+2VBt8UWTcsrSv+vxbzYn6wHr9p44lKd6+9DPxHYiS+3ZgXrpQh9uGSvtS/LWZQaBD4ciuE+snaJU1eOBpK9TKkEOa9eP7nr7/WJy/rlvc1/46qNGHfFc9EhOlgYqxsbpyVzrezNnROgn1su++7ibPdxu1xZm/Fwl5hxjuw9MUfYkK6p7mOMfEH15ZGT8lRwjtXXo6nwKEmbn1tH753Pu+a+TmW8kziugNEiFn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 03:06:19PM -0700, Andrew Morton wrote:
> On Wed, 27 Aug 2025 11:34:23 -0700 Yueyang Pan <pyyjason@gmail.com> wrote:
> 
> > In production, show_mem() can be called concurrently from two
> > different entities, for example one from oom_kill_process()
> > another from __alloc_pages_slowpath from another kthread. This
> > patch adds a mutex and invokes trylock before printing out the
> > kernel alloc info in show_mem(). This way two alloc info won't
> > interleave with each other, which then makes parsing easier.
> > 
> 
> Fair enough, I guess.
> 
> > --- a/mm/show_mem.c
> > +++ b/mm/show_mem.c
> > @@ -23,6 +23,8 @@ EXPORT_SYMBOL(_totalram_pages);
> >  unsigned long totalreserve_pages __read_mostly;
> >  unsigned long totalcma_pages __read_mostly;
> >  
> > +static DEFINE_MUTEX(mem_alloc_profiling_mutex);
> 
> It would be a bit neater to make this local to __show_mem() - it didn't
> need file scope.

Thanks for your feedback, Andrew. I will move it the next version.

> 
> Also, mutex_unlock() isn't to be used from interrupt context, so
> problem.
> 
> Something like atomic cmpxchg or test_and_set_bit could be used and
> wouldn't involve mutex_unlock()'s wakeup logic, which isn't needed
> here.

I was not aware of interrupt context before. I will change to test-and-set 
lock in the next version.

> 
> >  static inline void show_node(struct zone *zone)
> >  {
> >  	if (IS_ENABLED(CONFIG_NUMA))
> > @@ -419,7 +421,7 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
> >  	printk("%lu pages hwpoisoned\n", atomic_long_read(&num_poisoned_pages));
> >  #endif
> >  #ifdef CONFIG_MEM_ALLOC_PROFILING
> > -	if (mem_alloc_profiling_enabled()) {
> > +	if (mem_alloc_profiling_enabled() && mutex_trylock(&mem_alloc_profiling_mutex)) {
> >  		struct codetag_bytes tags[10];
> >  		size_t i, nr;
> >  
> > @@ -445,6 +447,7 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
> >  						  ct->lineno, ct->function);
> >  			}
> >  		}
> > +		mutex_unlock(&mem_alloc_profiling_mutex);
> >  	}
> 
> If we're going to suppress the usual output then how about we let
> people know this happened, rather than silently dropping it?
> 
> pr_notice("memory allocation output suppressed due to show_mem() contention\n")
> 
> or something like that?

For this point, I am sort of on Shakeel's side. Probably I won't call 
it suppressed as two concurrent printers is actually sharing this 
global information.

Thanks,
Pan

