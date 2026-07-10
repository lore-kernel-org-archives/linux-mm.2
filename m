Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BF71C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 18:07:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 015A86B0093; Fri, 10 Jul 2026 14:07:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F07F06B0095; Fri, 10 Jul 2026 14:07:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF82C6B0096; Fri, 10 Jul 2026 14:07:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B33FA6B0093
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:07:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 338E84053E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:07:30 +0000 (UTC)
X-FDA: 84973649460.23.FF40990
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5B2651C0002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:07:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WGvYT5k6;
	spf=pass (imf20.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783706848;
	b=rxqjtfR7y+7R1P9bh6qDU5jnFGmp1WLLK0swwvcgsP+wp4bNbWIfj4J3N7QRerzuDF+xYk
	uzItEU/Gc6c3GwEvkT83tJxmrnsAFt0dZN73yEVOIrHraXvdv0BIuH0Vaihvdsho7e3flZ
	DZCfUWJ77wnnMcyUurdYyiCoy9CqeRc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WGvYT5k6;
	spf=pass (imf20.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783706848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vK1yycrFvPnOHneU0oNi6DrjeWKqgXkTtqXMvxDGhZQ=;
	b=nCoNp/b9vBJxKHFSqfMr9uPWrEbnVkshm9ik9JRH9f4/C/JPfqtnAnIZW04fdsFnyUz68P
	c8pYCCMP9HIcX11MPxod96kU/DC9HYsOfst78zqbqfDGFyyRREtc2cHVDlUxRjUOAjlHpl
	3woZMlo9cCU9C5N/SaNZJlYiuJdRY2Q=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ccdb73f0e1so10771105ad.3
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783706847; x=1784311647; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vK1yycrFvPnOHneU0oNi6DrjeWKqgXkTtqXMvxDGhZQ=;
        b=WGvYT5k6znt7T8ytsmb1C5XoF3xoaIqGmqMbVO7VcXWxxYOthbVrBcV7ekpmfUs6yQ
         baFVxXSrEM5nBdElqUMPhSmHEDhCNOOPMRezPnBvT3lWe3TcqTLYHPlXZoqlIzTyj/aB
         9ijoMb2rojDDnFcmu20OQ2mDA8Q9Zhnt255UL49GC2RWFh5rQ4iQonNkzkiu8F69y2bV
         4taKLIVMs9CjepEA7Zg8CVSdPy01y8hRdqhj96oa+rn/btU/C29Q39VG0GP/qqNVETqM
         QpItRaFEWc5g1NFWajg8/uqZnX/5WQa8v6Pw/SLo+hUJHCD4XZby5bJ7kpZoQk6weg8G
         fdcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783706847; x=1784311647;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vK1yycrFvPnOHneU0oNi6DrjeWKqgXkTtqXMvxDGhZQ=;
        b=q9CyIY4MCtXtUS0lMAH68CI98wquq6rIXWTLxxpj3AB0g3n3AiZET6ow60AVC1Sww4
         B5LrQRwW9T1gSgnix770IDRz4hiUtl7OozCd9GKUeBttrB4fC3niutWZKLPGQ41lM23x
         /89QrsfVaPemPwW8aO36nX4CwrKckXPq2GVunQ8fOLgC6HrFeQfGWyrz3WKgg1YInfGk
         bJioF2GK6t1GN980tDz86IrwnxNjLLJsLDpmc563xQG7jIxmKqIf4xLJMHkqzTcB+MmO
         vD2l0ZNwZYxGo0sub4uNhDLnAY6EWQRiMCrN7nLnrteCswp/keFoh035da8vg8L8p+i0
         FsvA==
X-Forwarded-Encrypted: i=1; AHgh+RrvIcgIz8/T9TWGfnu6oqDULy8FivP5KOgF2eA5lQKRcCQZGI9ch9iJP0P/kBhxwHi+FDz6Yc+tzA==@kvack.org
X-Gm-Message-State: AOJu0YwFfzwYFfD10XAYOwiDnFQe8xljlJROpxWAS21S2urMhIljaTZ5
	7HWI8/8G0KS5VSItxUiowRFLk2oY1yWHLrfhoxBq/8PZdioZHXfDcBSi
X-Gm-Gg: AfdE7cmialhDspY8Ke0Jvk5wUDR/Z0kcxq+n2AXH8J7T+INxzcSkEfS2C3yIGUrhKnk
	I4HIqLnsuSVyEtXPbVtBAsRpyNeE+SBvU4Nkg3dcCFQSc1m8S0diMlGH322mbf/J8UB25oUfL1R
	by9nz2wyrYwiNSW4qG/x3udq2J2x+nIeg9gM8VOkVjIlC1kz9yJBmKsB1TzykOdXi0C6GUJ2hiv
	HnIVj65LxpkM7sZhbXRzNv4VIZjWvjO9EtbkBsyklREKIFFgveV6hIJOLFQBrWDfGAeg+/ODYJR
	XQIB80ND+rVnkmIVltR2ObCPwYgbsrDruDUylB2XVm/b1zYuf47hXcy/hRD2cmpDmENUc3pQLZm
	oS6fdFRpxy6JQmOnhMvF6KO3cUIH2IW6G/gDWQcUtTufiHhfYhy5nCQR44ff3OjO3+GbfsumYvp
	dAEiJsEJ3Wa/0YbOIGJ+nDLpEeLWXcg5J6S+VLb6B840GfVSEIM56zJ+0=
X-Received: by 2002:a17:903:2a88:b0:2c9:d8c6:1db8 with SMTP id d9443c01a7336-2ce9f284e45mr2337085ad.28.1783706847144;
        Fri, 10 Jul 2026 11:07:27 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bf74cbsm63356135ad.18.2026.07.10.11.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 11:07:26 -0700 (PDT)
Date: Fri, 10 Jul 2026 11:07:23 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
	corbet@lwn.net, dakr@kernel.org, david@kernel.org,
	decui@microsoft.com, haiyangz@microsoft.com, kees@kernel.org,
	kys@microsoft.com, leon@kernel.org, liam@infradead.org,
	lizhi.hou@amd.com, ljs@kernel.org, longli@microsoft.com,
	lyude@redhat.com, maarten.lankhorst@linux.intel.com,
	mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
	nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
	rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
	skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
	vbabka@kernel.org, wei.liu@kernel.org,
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v7 2/8] mm/hmm: add hmm_range_fault_unlocked_timeout()
 for mmap lock-drop support
Message-ID: <alE028DsCGeUwNh6@skinsburskii>
References: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
 <178345362182.660027.12809852179204464964.stgit@skinsburskii>
 <20260710162749.GP118978@ziepe.ca>
 <20260710164743.GX118978@ziepe.ca>
 <alElv0EKjLQXMNK8@skinsburskii>
 <20260710180312.GD1803712@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710180312.GD1803712@ziepe.ca>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5B2651C0002
X-Stat-Signature: 4wt9sjyqre7xfge4jt5aqwkdtp46o7o5
X-HE-Tag: 1783706848-512615
X-HE-Meta: U2FsdGVkX19rsDDtMLUZ8FQnr264hvAnzEGltk2x/MFZeCQ/tSmw5p1ucP7hrPQg2TlHbcY0st9qj23Z0z/L9KmYhZAPhEjo9ga6G+14PohLE3nrBeRDkWi3NoyKFDPkke1ybchcDe/qyxkurDaTwj/JmwwBd9Fcj7OznuE5oZ5GUCN/IPTCkxf6dwQR+XSS2iqTqsExc72GH6ODiCCOY9c2eGcxbC/5tQI0VVBTFJn8J4Amc+S6pXBDcIT1I2GRjua33H9HAa7TpenoFnTdxCc6dI7oq92E9VbuVRH09T4R5Uk7Hxjqp4Xg0kkIbkGF+J6X+l/hloLMJV0q3F7YLgRomdUbor8r3CWG/t6YwKhXma2OMe9xjwvP/9Xxq9s5N2Wz0ebKvlQ9hlC852wn6HqrJQxyzEt251S2Bs7C48TjVCvnoc4BVgKjrXWqi2suEOGzNoknNDV4t5KtAJWqnUdHXj5rKzGxqT9cdnPAfIHeYqeQGPmYiIlKYTZwZtgQ+RJAqNiSro8mboVS348KZjn3gnjQt878iVsk6H8zFcXy8QHtgpGbYS2arBpztFcfhmNx9Ik92rNbIn47WC5Z9Lc83Hw845pIUFiVTEFOrdYYcHoSDACFftW1i7QGs+/GpSfxIlqHGdDankroMpAkdIYvvr5XSJPIaU8wQ509/l6SOfIyT266TDknLibGsK94L4galQcMphd7zaEXq+I0qHFGTPwfc6VZis6L1fr+NcRBpQrnbshu+LA1DtCK6LqiUlxoYoVLlFaPn6Q0rzqMvxC6LsTdhAFkoDN95XN05ED9Qv9jj+zgpUGu+6zT1sY3o02v/vC7f2AgxviE9gXyvldljRdgPZDW7lVRQ+epx5o3+ixDo3eX1RTx8i+c/irO02+hl8SpXf1jEikQ3BRj7g+WTkxtT16LrFA5uu1buesLyOkusxMn+KFr7NYTAA080oYVib6fh0jLaJQfKSX
 oOS0T1Sj
 7w/iT1xD1kd2LgYxjE6r6klY4FwUlyK2LzfUGbRnnzGGEX6MHqSm6igESgJqFzvW3RSpLoTTRiTH/p1ak00teM11+mN3zpJSkQzZ10PYLvlu7Hab5uW04V8AyARy+MTjrMv3zXiq8AGN8VrdVO+iB7a3W5+HQqMfcPTY60NXQDkrX2JvEwHpddLmDiG/7sjNqL0wMyfZwTjwiWuwUZqDdhBASoso/PB2GR4PMF0fhvXJxHchiCgGQDxEgauhPkxRQ424mebXiZMlBJNlACmgrz3qPL0koibQCskgAoVlMpEGMrFJS4GP0ympgpQTW95kpi1GnWckTtHhjNH+9KNCTgy4tBE9E9WQyCrWpZ74/RfjeVKmwmt8VbI5VJ+f5FF/WDV7bmo+7Xm4uE37/81zvpQJVr6LBZxBSaGtPdh6kEOWj41smW8M1sRL5GPTetBKi/ot/xYxBhP9bZEAiMvsrpF7rlpoRoaFyayC832z9mVoe+iGbvhlYvmF7cNOkdJN6k3LDae0p2boNcIPFyjQfVqvTuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 03:03:12PM -0300, Jason Gunthorpe wrote:
> On Fri, Jul 10, 2026 at 10:02:55AM -0700, Stanislav Kinsburskii wrote:
> > The main customer for this new feature I have in mind is the MSHV driver
> > which backs VMs memory with HMM, requires userfaultfd support for
> > post-copy live migration and fast restore and it doesn't timeout.
> > 
> > I agree, that this current timeout value used by the other callers might
> > not be enough to repopulate the mappings with userfaultfd, but there
> > drivers would get -EFAULT for uderfaultfd-backed mappings without this
> > change anyway, so getting -EBUSY with the change instead doesn't look
> > like a significant change to the behaviour from my POV.
> 
> It sounds like it won't be reliable either then.
> 
> > > So, maybe the deadline should be resetting after every handled fault?
> > > ie the timeout really is only about the mmu notifier and we don't
> > > count the time spent handling faults or walking?
> >
> > The timeout was inherited from existing HMM users rather than introduced
> > as a new HMM policy. Some GPU drivers use HMM_RANGE_DEFAULT_TIMEOUT as a
> > budget for the whole range population operation, including HMM retries
> > and subsequent driver mapping work.
> 
> Yes, because we always had a timeout around the notifier because that
> scheme can sort of live lock. The timeout was to protect that only, ie
> limit the number of notifier retries.
> 
> Expanding the timeout to be outside what is bounded by the notifier
> retry is not right, and heavy stuff like mapping should be done after
> the hmm side succeeds and the notifiers concluded so they can rely on
> normal locking instead.
> 
> This is why I'm suggesting to reset the deadline as hmm makes forward
> progress, we really only want to bound the notifier retry loop not
> anything else.
> 

Sure, I'll modify accordingly.

Thanks,
Stanislav

> Jason

