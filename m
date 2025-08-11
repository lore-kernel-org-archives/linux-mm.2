Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC0CC87FDB
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 10:58:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D11A8E0039; Mon, 11 Aug 2025 06:58:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A8EA8E000A; Mon, 11 Aug 2025 06:58:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BEAD8E0039; Mon, 11 Aug 2025 06:58:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 084438E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:58:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ACE87134975
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:58:44 +0000 (UTC)
X-FDA: 83764178568.21.AEB855C
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf21.hostedemail.com (Postfix) with ESMTP id 996EE1C0006
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:58:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=J+hQ61B6;
	spf=pass (imf21.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754909922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2eDfsoEqJXD8CkPjgI5wPgXdl/c/jHhszq1yFHNlj5s=;
	b=qXRkc7pLVz8xAktYBfU+U3xJwlXC+j2RkHceKlDkKjYKCx3xKbElto9RhXYzHfQU8iVofQ
	PChkKFO8oHA7N7cxgkRQ2jYqiR/Flco3I8tyKdOnuHkN3QL2PRnMX16VGYwWzC29oQffTV
	lJi2xeG3b4yLcD/Jo8FIoOnYN1E7ndk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=J+hQ61B6;
	spf=pass (imf21.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754909922; a=rsa-sha256;
	cv=none;
	b=LDRD5aOxLD8jxL2dsw205rpTcJFRlQigaVbAr2f9vNp0JPY1ONAeogUaa3w6j4ugI17V1h
	lFRwaCyOpcfWYl4LHrNqnRk7SRbE9yqM0a2DwMhZKNEN9utJ1Q9wT2Btlc6NM+o5waKYfg
	Hk2nVmVq0vUdjESruB+IDtnbB7pg/vY=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-458c063baeaso23373465e9.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 03:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1754909921; x=1755514721; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2eDfsoEqJXD8CkPjgI5wPgXdl/c/jHhszq1yFHNlj5s=;
        b=J+hQ61B6GFGTj0lgZ2ZRkq9ZFm8rtCDTiD32X38RAjatfgHwVN1oyNhdnv+HRFbVDh
         THvGRLGdTQN9fBlLUapnSIIDUDb5KZ9RI5FTFOPKSFPjHbHrkT1l8Gp2P3qD0lGoQZrv
         c6sjknnkt+81kVIok4pT7upaToEGyiOnMQ0vrYAXh1k1FcNv9sLlqexZueg2dFtWYy9P
         qt4RNyfzzS0/kPoh85IsFxgZVra+1dLklKIKXJx0k+oyXSEhUWG/RUdDTly3aq8Yy0OE
         AUWDgOXhzxxEF44Gynu0nBiGEWQDRF4P8HEaDByBhk+Q6NcdcpUwfmEvxX/ioAnEXHzU
         AOuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754909921; x=1755514721;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2eDfsoEqJXD8CkPjgI5wPgXdl/c/jHhszq1yFHNlj5s=;
        b=AX/wniABk/RIpby62KgUyp8Heevk9pyjxlr5QDrJgIOLzT1ow6WR0sb64Ba5rlZpat
         4g8KtXucHfI9x8NEc+N8bcqD4zikf3E/RFUJWc0BP+koLgWDCUIpy0aIyJdLfvydLz/E
         wrCyWUAlCaGlu5cGTFh9jLqUOMjI5vbJwyKDnUb88+nifTIDj5HivEQ6HzSSUPkDLAxK
         LNiJNdsKdZo2FIPoOe1MV/Uy/tKNWXJAXEaAk6n4DVx/UnegcFSEwEg7PC5v7MC5TfCO
         woo09k/OnHRZ9xhtcZy91SrIAyVKymTKjglWyDIvRDG2MEPugO0tBFfyRjqyoKSuxD1F
         NNdA==
X-Forwarded-Encrypted: i=1; AJvYcCX7MbOLM7xNRP619g6koXZdrQehA+/o5MxOvOMTQ4+QvMD/rpiiUi2iZCsePhqdG4dpnNAMjWIvPw==@kvack.org
X-Gm-Message-State: AOJu0Yw7FOvOV8YyOis0/dgZJgXdiyaMDO+tZhRGu+/YSjBvrHPhE7Nn
	64vN7zT1M1Hgj+fFnCO1hPykF+YhUymjSYYySWPZ5l2t8BBO8uPiFosQNvU9VNd+lpA=
X-Gm-Gg: ASbGnctKsIvyG5zh7jMc6fup3bhOBegKrVxsGWXYyjfeL6pG96UbABvSYmhA2UTmIg7
	d0FYj4T3BbecxoG+/STkyfB+u1Bxf4qBHPPJ93/o8yhoJpuueORpVfxX5BJm6Zi6vRFxxeEpYvN
	1rtKvA0WE/Edj+rerkHzbFhseTixIUYrwnU55pLpO07+XPEWPiFGq5CwFWBKRoZaC49vpi8u5/n
	VSY35dD44Kvd9Qs9UoMLvUHzebQb0OWjLuWEsO0Uv1rSOcMPHBKFx3k2XVz5QQ0YEKN7WG0mAzd
	I8a1TL9ibYAu4cv0rskAYU/jWQ8IixAFaezOUM3E5EXK8cXDqnb98PQRrT/OGs7zTjeep+hY3S4
	Rj3qHFbHJuoJYv4tp8fHQdc1cNAZKSP3x
X-Google-Smtp-Source: AGHT+IFbmWJMYJQaNs4CcNQms0cyi9FBgsOYAQyUhMd4iBen9JAGKCb/WkfFa3wB/d3Zu4x8mcv7UA==
X-Received: by 2002:a05:600c:5254:b0:456:13d8:d141 with SMTP id 5b1f17b1804b1-459f4f282damr96805005e9.27.1754909920821;
        Mon, 11 Aug 2025 03:58:40 -0700 (PDT)
Received: from localhost (109-81-30-31.rct.o2.cz. [109.81.30.31])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c48105csm40496846f8f.64.2025.08.11.03.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 03:58:40 -0700 (PDT)
Date: Mon, 11 Aug 2025 12:58:39 +0200
From: Michal Hocko <mhocko@suse.com>
To: Zihuan Zhang <zhangzihuan@kylinos.cn>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	len brown <len.brown@intel.com>, pavel machek <pavel@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Nico Pache <npache@redhat.com>, xu xin <xu.xin16@zte.com.cn>,
	wangfushuai <wangfushuai@baidu.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jeff Layton <jlayton@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Adrian Ratiu <adrian.ratiu@collabora.com>, linux-pm@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/9] freezer: Introduce freeze priority model to
 address process dependency issues
Message-ID: <aJnM32xKq0FOWBzw@tiehlicka>
References: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
 <aJSpTpB9_jijiO6m@tiehlicka>
 <4c46250f-eb0f-4e12-8951-89431c195b46@kylinos.cn>
 <aJWglTo1xpXXEqEM@tiehlicka>
 <ba9c23c4-cd95-4dba-9359-61565195d7be@kylinos.cn>
 <aJW8NLPxGOOkyCfB@tiehlicka>
 <09df0911-9421-40af-8296-de1383be1c58@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <09df0911-9421-40af-8296-de1383be1c58@kylinos.cn>
X-Stat-Signature: g5t5iceyghf7z75zi1jjsd8an4mi6awi
X-Rspam-User: 
X-Rspamd-Queue-Id: 996EE1C0006
X-Rspamd-Server: rspam01
X-HE-Tag: 1754909922-497431
X-HE-Meta: U2FsdGVkX18Qtg0yUf9EBia0NMklCQf1L4ssGNRvH702M2LKR1YBl+QXDNxRO8f0oZa9P1U0286gGdcFjqEvAt8jtg8oavGZ2ENrgbR/CdWhknHc282WoyaR0rbgPxvGKb3DnJ9Oz0DymDVABEQu+DFOA9Et3+WUZyGfUHuAhiGB5+QBMRw/PeFLGe3FpxGXzo2Z0tdX1qrMyGOKF1nd1LNDpY7UAMVj65Wm34P1xqjQ1pU6FgRNHpt4BiQeE3Hobq+cJPzJLS0R8Mt+Vj2OflbSosIKOll4nYxLeHdOZoUnDmpMvL0i+EFJZxPqZPFd9r8VJ0d/6nxwkUvSSj2FJNovGX/84CKuGwOa4NIEVG9WXevcHFFGEb7mKPTjd05+tby9ufOOIohfM9VGfDXnKqaB7IBWQzkDsS8srF2QbgO0YSKfBCRx0mm0iORuhS8369Lgq4rLTi3nuj3PkCQ6E7uZt8cMWTln4h2hFRbVB3Fx+ZtjGLEo/d9QBVMsEnPdy/eYI2okQjrA3+0EdZcyvOPtAHzH4tLOZeGHCLP6I7cgVP0j2AWHjJnx0iYg8hBW+eCfA1yGXGMCEe1z+V7f/MCjHtDn6kiesjjrvPVCmO7UR/Sgrf3rXJ9owHCMAKFNkMtmrjmBGmeqsiwkzjLHzC7SLFWrcrodmJyNa4+9twvTr6WGtvkvhgymlR6e7zM9a94GjQeizs0V+9WqYV7YUiX19x0e3Is3rTw4AlV5Aj4uKXoowDz4N5/gP7TNGkShzaMozo2E3R2CFK9V18FL6tnNZzWlPSWAD3+Qe11grGfaLUwQuc0Zv/w0WJVdQMXjO3eyLt2kpVRbm8ZPoTWnLomPvnIN9s9831mW/6qamyayriZ0WCSF5Wg4bTxS0xF19OsXInuPeNwly14TSUBYf7/BTQjUzJ0wAJycj5J9YCoE3f6udlZfOvB9cQHoWK63UNfe4ZwEkPMCCUfA+pU
 yuI5t47i
 h/6+bY/gh5mE7MUXKt5XX2WhtPR6AZl/Xyc4tN6qXCw1PuZCbR5lMvjnTMRq50+XllhHSI81TLmwrB0SjYgA5rFrDaMvqv+4DyGwahyf4s46841l1/Yh0WHNcHNoAFx0EUSR1k4EbTfQfIyUbK9zJsJAmfabVmx/iEt7amsvs03AQE2df3Nh3ylA4mGL93HNIgOzs+ZNtzttoDFds7HUN8q2J+Dd9IVC7ndOI37B7DaeXc4X+cyBMutaMPwytH+MkYcUPPljAVaN3KBt6Ju6cpaxkDR4L738coH/zE1r25Xe+nq75PQ5wvKmGmCgSVKjXX77d/H2WrF73lqdw48Tylit1Ag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 11-08-25 17:13:43, Zihuan Zhang wrote:
> 
> 在 2025/8/8 16:58, Michal Hocko 写道:
[...]
> > Also the interface seems to be really coarse grained and it can easily
> > turn out insufficient for other usecases while it is not entirely clear
> > to me how this could be extended for those.
>  We recognize that the current interface is relatively coarse-grained and
> may not be sufficient for all scenarios. The present implementation is a
> basic version.
> 
> Our plan is to introduce a classification-based mechanism that assigns
> different freeze priorities according to process categories. For example,
> filesystem and graphics-related processes will be given higher default
> freeze priority, as they are critical in the freezing workflow. This
> classification approach helps target important processes more precisely.
> 
> However, this requires further testing and refinement before full
> deployment. We believe this incremental, category-based design will make the
> mechanism more effective and adaptable over time while keeping it
> manageable.

Unless there is a clear path for a more extendable interface then
introducing this one is a no-go. We do not want to grow different ways
to establish freezing policies.

But much more fundamentally. So far I haven't really seen any argument
why different priorities help with the underlying problem other than the
timing might be slightly different if you change the order of freezing.
This to me sounds like the proposed scheme mostly works around the
problem you are seeing and as such is not a really good candidate to be
merged as a long term solution. Not to mention with a user API that
needs to be maintained for ever.

So NAK from me on the interface.

> > I believe it would be more useful to find sources of those freezer
> > blockers and try to address those. Making more blocked tasks
> > __set_task_frozen compatible sounds like a general improvement in
> > itself.
> 
> we have already identified some causes of D-state tasks, many of which are
> related to the filesystem. On some systems, certain processes frequently
> execute ext4_sync_file, and under contention this can lead to D-state tasks.

Please work with maintainers of those subsystems to find proper
solutions.

-- 
Michal Hocko
SUSE Labs

