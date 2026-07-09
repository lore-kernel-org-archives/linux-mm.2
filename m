Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 373E2C44506
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 08:16:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 877A96B0093; Thu,  9 Jul 2026 04:16:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84EFA6B0095; Thu,  9 Jul 2026 04:16:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 718206B0096; Thu,  9 Jul 2026 04:16:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 42E806B0093
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 04:16:20 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CE177120445
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:16:19 +0000 (UTC)
X-FDA: 84968530878.04.F1A1597
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf15.hostedemail.com (Postfix) with ESMTP id C987FA000B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:16:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ep9G5l0k;
	spf=pass (imf15.hostedemail.com: domain of pmladek@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=pmladek@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783584978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z+CFlNGgVOBUKoyPjKhrOhvumBe76lgJlilpAZoLH+g=;
	b=sQqkT7/F/fqrquB1xj3C4kv5RHYw4W72Qn8PZG9e27bAfDm5oe/oWuJ7NYs9jgIn/OCGzw
	AOvWmYpY1NaxN8GsHHwAfJp7tir24nK+CN+vKKVSJLj47G8lyBBm1CD3l779fcnJPoouqM
	2rSnSF+WtS5OYyC6op6rSYHSWS2X5Yg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ep9G5l0k;
	spf=pass (imf15.hostedemail.com: domain of pmladek@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=pmladek@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783584978;
	b=U//jqJSUC8GHAv4IBQcZb8j6C0VjRyviKEQuC9m0RxJ3aCZeBfdmQFKf9Lg3nw524d8w6y
	DTbQzNGhJIyWhcmsHZsB+Z2C9kmi+RSrF3EvzB2fEVVBee6AELq3BVtXW74v26iqCQsDSL
	gKliG9+9wMwDAd5t3//WM/rro9cwdTk=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-493ba701891so11180125e9.3
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 01:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783584976; x=1784189776; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=z+CFlNGgVOBUKoyPjKhrOhvumBe76lgJlilpAZoLH+g=;
        b=ep9G5l0kkEFIJQTNSgWH8SU5WLLmX977ouOGGB5ZKfkRWaUnQwQApgQXeNd9TiTTGY
         4trCB/6xTk5g/5g0SMPtG7dmc6AgKDTOHKKnLDgYEIKQpPi/3+htN3RYyAAmCULqHaRe
         cVvavcP/3jsxWyALkJlI7USm9LDplfQRMV1MJ3cYTjGKKz/J6YXg6+W1dsJxFg5qSwLh
         U03OfCvIKGKMwl2xc7/djO63gSkK2zBkYX1mJkK6hOTKQrlJGN6dQpEmlwVwNPf0fb6Y
         47Ha2XUvI08wNH+77pTGR05eGr8Tg3BWn6iAns4ZJGzKLSCpYfgav4+K7KYqXAz26rvO
         Ovbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783584976; x=1784189776;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z+CFlNGgVOBUKoyPjKhrOhvumBe76lgJlilpAZoLH+g=;
        b=U5PVLjmVM9FVeW7z/GjwqmK9kG41j4yZMxKYiuxQam9ZyXqgRYMoHyfFF0PGkhXIyW
         R/fr8S4nLe4eRWXDL/kvvz+50Xsrx/lUFnu/JIUVnzKJfhrKQPcvyp14LvfydoaZ4r39
         pEfQJKMZNyIc510W75PV7f9z77jNp3CoC8KUsI3nDHHZKGpBoAzyM+FDsIz4lssSeVz4
         oQCXWrtiVBsVinu3V9EPXnPI5IVyb52QpOlp8DFOgTNpzr/S8SCMcwxPFQLrnyw4hbL1
         5rSOCEysA2WDYBt/1rV199AGvgVBleyvNHVgImCNJ2VrRMClq5Ao3CwjUeqcGBrH1xjg
         zHZw==
X-Forwarded-Encrypted: i=1; AHgh+RrNjje+G0DKpLPwDreNbfDiiVsLODaqkP+Snr/71++pN755IVzIFyAGUiHsGnJPxQ3E8f6kK+CmTQ==@kvack.org
X-Gm-Message-State: AOJu0YxtpEZWkPstkh9PaOxMeSQjogSFz1yPUXPGDgIBkG4JVvHdhEZN
	3ccgxilEbqAdj6gvij4AvJKUGb8O3QbD1b4RCqeE89fnJkM01TI6JShQ8+uQYHDiuoA=
X-Gm-Gg: AfdE7cmYOdICZJjg/9YdUpnudu6q9P9CpDqBOqEfCbsGU5TONvaR+XMXWILd3x5s6eI
	q4pquKG+8CaEbI5WyCNrA+4SmSnHTt1PW5Bw7772IjCieksrrwQUdCoufwdHbukbw7s6IlrYv5V
	rbiSb7gjTg8XaixVOJqh0v7WhsEoA2rFis1mz5yiLCVOMdMDP5By/Lh5iZbmEpOWHZwu+NSAnPa
	sRVcNAq9atpXMhU57hbxLkQ24KeLJHKjhlFl0kjD2K4V6xb3JCSrlL+MtTFMkN2llqZ0Yeid+Fn
	7edQZzDztu/NL5NtMnYP5A0Z3zQLkLsojXCJA6IUzsb7l23QCvndjvOOgofdJURakKotGwQS1gi
	cMcrCEkRzPs3MQv6nhSlw6YLKn52HrNaGVl2lCQjcX3OH2V7rlB94/eHcHt/UIOE6DM4klyGt5W
	bFbnL1dROiXD9ZG30=
X-Received: by 2002:a05:600c:1d1e:b0:492:7084:32af with SMTP id 5b1f17b1804b1-493e68bf03amr56205565e9.23.1783584976164;
        Thu, 09 Jul 2026 01:16:16 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493ee2bcac0sm20177645e9.0.2026.07.09.01.16.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 01:16:15 -0700 (PDT)
Date: Thu, 9 Jul 2026 10:16:12 +0200
From: Petr Mladek <pmladek@suse.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Eugen Hristev <ehristev@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>,
	Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	John Ogness <john.ogness@linutronix.de>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>, workflows@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v3 21/26] printk: Register information into meminspect
Message-ID: <ak9YzK_Puejpg_du@pathway.suse.cz>
References: <20260708-meminspect-v3-v3-0-7aa5a0a74d5c@oss.qualcomm.com>
 <20260708-meminspect-v3-v3-21-7aa5a0a74d5c@oss.qualcomm.com>
 <ak4Cr5GEMdo8xWqu@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak4Cr5GEMdo8xWqu@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C987FA000B
X-Stat-Signature: 5fduoz9k188fx4q88nhc9shyqybhszfe
X-HE-Tag: 1783584977-442583
X-HE-Meta: U2FsdGVkX1+SgavzyUeXhqaYve7oJpaQqbZW7LKyddlA3RTqD22BFnYITTDM/p4CyIehTqkazSaaEy0Kab5Iyd4h1Qg4RQH9jDEs3QqzTqzDsVVBlBZVYYq6dVYFkDvVUZK1TbpTcSJ5PPYOC2Q7OwAuao5cosITUZaLGlLvTKQz0tPfHNYGIM+ltACumPRQiVVlSsHVOSdbQBIIq3mdwMfuGLb8dmBNuyXYPmJirqdaigwylfQx8kKQWcLAq+Hsnq0IJgWePsi1KJBfmSut9UB3PQC2+Mr1SeHCZT51cDp6gn6+XHvxb3K1iZgfOGkkRcot1WBkvIpsh6Ky6nFzcbt3BOmHEHXgB+MfFj8dFCQefGN/HPdTDowtTacquDw99v059uing7XU3AQp21nI+qYfA21H1GBcr9XFlFmSKInashL/6rRI/VexU/h2mTjyPdJODGRGdEpG+YQPlNYLeX4VOb49EqzqnYA/Ws956YBDOb0CXEJgjcwFW1ElJqb3W95wWUE3xjmhGaudNmiVbCKx7FRNdreJJzSKS2IhnIhnQkCu4VAbGx8rTQozgcS19d5KJTTf6syxPWfxXeu0Ie8FjOnNT8II2dr7ftFjUj/qKsEIOSS16Y2/ikM9NizI+65rpT8rAqnNQQpcdSiK+fWdaG4cWJJ0FztcuzWXLdipoXfJHB4WC3hJdjYjjKePON7lT/C9gJ6VqjDqhsp2cN1l2ETb2lH3W/QLvRTLn8SVZqjTk1ka3gCihE13Xn0Yl70CK3wgqSV03Y6KWxhxMhDapyhHXOl7w/gs5XfOy943yv67Ng8RzGyG4prZEh+nLmSWomyFnPtzkb+ZU8ahKDybAtEZeLKCg6AmWskJrtKMEa66Gywbfm+n4DCSWpm/iyS60wPj5WoJkAKxf6jtaZWguOJclGd5nXu7La64XmQA1yPBB597WnTiSMsZdQXFIDM130E2BlTtuJdQ6SH
 n36DZd4c
 Wr4PpI6j7k/fS4fMUGCE3VVam+jSH0LJrpVcFwEb0f9lFbG3MSInobfK+BUq/QfgF31YP94cH3pBqY+M8nLMVgrY08WdT53rgE9Wb/3IPUQv/phfXE8YvbUwAvsnq8rtoTLtP8Hu639ukGoky7y1GW7fK05vM8DFxyS5dRdkvUsWa0XGfQ7gzBg7bD9ayaDlLQTyR+fr+hFEkMxusunpTIFVBZ4RfzYIy49SM6JMaz/L+VzGdLUXEyiuOXTqyv9+3vSnVMQYKWsPhPLfWFnz9eHK8/u1xaRmT2RwS8Sw8ag9ylOa/B5XHTHkdNuZDvWh1VdF/oUgjzsqoyNiy4qlAa04h2WhSexKboaO2nyiv4CA7nzTff6hyJhijRsVkaUHK945r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 2026-07-08 08:59:26, Lorenzo Stoakes wrote:
> On Wed, Jul 08, 2026 at 11:02:00AM +0530, Mukesh Ojha wrote:
> > Annotate vital static, dynamic information into meminspect for debugging
> >
> > Static:
> >  - prb_descs
> >  - prb_infos
> >  - prb
> >  - prb_data
> >  - clear_seq
> >  - printk_rb_static
> >  - printk_rb_dynamic
> >
> > Dynamic:
> >  - new_descs
> >  - new_infos
> >  - new_log_buf
> >
> > --- a/kernel/printk/printk.c
> > +++ b/kernel/printk/printk.c
> > @@ -49,6 +49,7 @@
> >  #include <linux/sched/debug.h>
> >  #include <linux/sched/task_stack.h>
> >  #include <linux/panic.h>
> > +#include <linux/meminspect.h>
> >
> >  #include <linux/uaccess.h>
> >  #include <asm/sections.h>
> > @@ -518,10 +519,17 @@ static u32 log_buf_len = __LOG_BUF_LEN;
> >  #endif
> >  _DEFINE_PRINTKRB(printk_rb_static, CONFIG_LOG_BUF_SHIFT - PRB_AVGBITS,
> >  		 PRB_AVGBITS, &__log_buf[0]);
> > +MEMINSPECT_NAMED_ENTRY(prb_descs, _printk_rb_static_descs);
> > +MEMINSPECT_NAMED_ENTRY(prb_infos, _printk_rb_static_infos);
> > +MEMINSPECT_NAMED_ENTRY(prb_data, __log_buf);
> > +MEMINSPECT_SIMPLE_ENTRY(printk_rb_static);
> >
> >  static struct printk_ringbuffer printk_rb_dynamic;
> > +MEMINSPECT_SIMPLE_ENTRY(printk_rb_dynamic);
> >
> >  struct printk_ringbuffer *prb = &printk_rb_static;
> > +MEMINSPECT_SIMPLE_ENTRY(prb);
> > +MEMINSPECT_SIMPLE_ENTRY(clear_seq);
> >
> >  /*
> >   * We cannot access per-CPU data (e.g. per-CPU flush irq_work) before
> > @@ -1238,6 +1246,10 @@ void __init setup_log_buf(int early)
> >
> >  	local_irq_restore(flags);
> >
> > +	meminspect_lock_register_va(new_log_buf, new_log_buf_len);
> > +	meminspect_lock_register_va(new_descs, new_descs_size);
> > +	meminspect_lock_register_va(new_infos, new_infos_size);
> > +
> >  	/*
> >  	 * Copy any remaining messages that might have appeared from
> >  	 * NMI context after copying but before switching to the
> 
> Overall exposing live dynamic printk information to drivers seems unwise, but
> not quite as insane as some of the other stuff thus exposed...

I agree that we should be careful with exporting symbols.

Well, if I get it correctly then at least the printk-related symbols
are already exported a similar way using vmcore_info.h API,
see log_buf_vmcoreinfo_setup().

Best Regards,
Petr

