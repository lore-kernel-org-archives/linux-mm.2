Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64C1DCD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 19:54:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFB7B6B0092; Thu, 28 May 2026 15:54:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CABE86B0095; Thu, 28 May 2026 15:54:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE9F96B0096; Thu, 28 May 2026 15:54:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A3E316B0092
	for <linux-mm@kvack.org>; Thu, 28 May 2026 15:54:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D5CE140925
	for <linux-mm@kvack.org>; Thu, 28 May 2026 19:54:06 +0000 (UTC)
X-FDA: 84817879692.07.A85CB1E
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7421014000A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 19:54:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nRXWT4Hc;
	spf=pass (imf09.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779998044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+YVYuHV31+YDueuv90j7QJ3IHdmFzFimV+6UaJiJI8=;
	b=DPLve5teFKIEBXkt06aygh3BTKVT1mllhpM+M0VmYCpPzgzaYFRf/HhKsh6l4I8GbWVTSm
	vliYT7J6O+vTvF964GM9Licn5DMXAEiqeJ2KhGqyafFaghpP61LKUO6/YvhgDtOva5sDIV
	hjkpKDLcjDgd4vOcJwFMGkjZ0JJgZ+Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779998044; a=rsa-sha256;
	cv=none;
	b=WG9795ySL0KZQZXruZce4m87Fir2G7lwJTccuTjcDiWqwnY256thk6Pj49Dz3ptwJL4cIG
	InNqgO3M0oPht8zyz2PQbd/BYKPlZxD40LxhwPn6w6VUUi30Z1xAdXMtSXTFId1NL+GRJi
	NI2GMhZMpVUvA16iSXFG88oB6//IEP4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nRXWT4Hc;
	spf=pass (imf09.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-36b95eb4bb4so451885a91.3
        for <linux-mm@kvack.org>; Thu, 28 May 2026 12:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779998043; x=1780602843; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=r+YVYuHV31+YDueuv90j7QJ3IHdmFzFimV+6UaJiJI8=;
        b=nRXWT4Hc17/WOvLFuHChDqGxvvPqenoLWW5hRAbfnvlfhrA1YJj55uOnboo5sMf47Z
         dLOj6DrLyycDq3KKuUKELLDPkQuJkiaEShSN/OU4Az2vLDhTw53WQme3qFpHHmcD6dwM
         nBDQOEU9NBNMjuEUFBI8e5rXtRxqqebNa2aLGu/10m6LCwPHWYv5jGS6tcHOy1LFDACa
         9SX0DsCZP4+jgp3wIEawmy7n+xTDG1TvOeK0z6p+UwqAA/Ar5xnUsqgWcgbfVlMawKHR
         Q+yQX8JtuEG0mNhcb0UJM98hK3yTdj+rZvPOYic99U+8JYFFBruZMKpWtMysrBlUw15D
         zt1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779998043; x=1780602843;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r+YVYuHV31+YDueuv90j7QJ3IHdmFzFimV+6UaJiJI8=;
        b=r9gh6sCkhTxJ1IOu4ZWg7j+foI5qluhlASKgiokPNNCTfABqwOfkmcYlCqhqJj8kLf
         /DPj5PxYG6UimjXJJpRhW6BBdX5qkRRMPLq3AM4jvUDDOxZFVahhXxNogT77PNsitmlU
         7St4ye5wTRbHenCUbfI/sJ8Dzy2ySAhWR4K2ryWwuy7Z7nI4IyEQYeuFdCU1tcXjJy0B
         r+7rbmC6rz9GmQBTfhlPhYAgLxE3U/l959XiRDSGBozY8bOV1O8XQrpwR9fcSnIrVFsi
         C0iFymVysYVA45L54G2o16YaJWInbxYdhs1BBusV90FrfET9bpFXqHKdYfmNyRwiMizM
         gmjA==
X-Forwarded-Encrypted: i=1; AFNElJ+z73O2J5cs77OeAHbtle5A/iEkD1icOS8wahrwktAjknaAIXcOgr3VyEOFML239nsF6tXwIjm0rg==@kvack.org
X-Gm-Message-State: AOJu0YyTbcQbly+d9BUuwnYET5s9gkY5TWh5xkexNfsOp5yv9xjhn47N
	71xXq1q5P4MD5PWpPXb4YB3r2QqA6l1EV03jxDqf4+2OTm1i1uCKKIyv
X-Gm-Gg: Acq92OGgMj1Svjoiib8GyaqtG2yqcuLxfDGcovvrivZyzvIkRB/ncrrwBnp0oIsqFas
	F0dPkrqpPabpMsC0vT69xhoBJdIcb6tcw6eci5krJG3K+eemgGrvr6kxOK1CCQvCJUUwJYOAn2k
	VVpBSDYbUsPgQYiHJnW5AtnIxPgajVjSNfvMUAYfeTdObKfKlVLQKBTPnovyfoN7NsYYfppJJb4
	/6vdynOd6xL1E0ik+R+Dlf7yV4Kv61ATznqSEWMPA/b8vIP9O1/x4nYcUOJLz7JsOfZlBvdsjJA
	fQ2UuejnDG2SLG/ZrC4veVg4Ils9QSCn9pWRJ6mvgq2+vt0zXxs1KJpamqLAy0DFKKzYl4rPjRW
	XpWN5det64zeVtQMmnHQMN+CPguW/EWX3a5gdY76bkPubyusnMOUnVxsHG+rG4/WCT/oRAZ/Ux6
	Kt515UkAFY5Bbr/auOnTGwAyQ75rMLGj4104s8O2PT/1i+HDGoMTKxQYpXdZDbydra6BOguYWbT
	/s/
X-Received: by 2002:a17:90b:2682:b0:36b:ba9b:7efb with SMTP id 98e67ed59e1d1-36bbcc14892mr34605a91.5.1779998042998;
        Thu, 28 May 2026 12:54:02 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36bb616d646sm398548a91.11.2026.05.28.12.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 12:54:02 -0700 (PDT)
Date: Thu, 28 May 2026 12:53:59 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Liam.Howlett@oracle.com, david@kernel.org, jgg@ziepe.ca, corbet@lwn.net,
	leon@kernel.org, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org,
	shuah@kernel.org, skhan@linuxfoundation.org, surenb@google.com,
	vbabka@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 0/3] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
Message-ID: <ahidV_iSq3E-FtMI@skinsburskii>
References: <177928604779.589431.14703161356676674288.stgit@skinsburskii>
 <20260521163309.c5cc5d3f6cf16bac212cf90b@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260521163309.c5cc5d3f6cf16bac212cf90b@linux-foundation.org>
X-Rspamd-Server: rspam11
X-Stat-Signature: kbiyufaoz6i74n1qbxsqydbo6mjqkyg4
X-Rspamd-Queue-Id: 7421014000A
X-Rspam-User: 
X-HE-Tag: 1779998044-512007
X-HE-Meta: U2FsdGVkX1/lCKKBEl+9lgJEKLjffYOLoi9ujghPNu7q45UVP3kJ1mmZassUMQe208gkO/Vpfa0qhR8zefsLmoY0xr6N+Z6pE+G90xGNESuzk6sZ8nptbmRVVNYFIHbAYOwJs1ajYitCn5T9/lnQuSwT21b6bOXiZNeA/ilg55md1elQgY5m4kcqaHY01KfxR+HbnWHPP9SL8/J5lEwcR4mKbD83Kf+cazbfiuqnRk/V38SfaW1dMvAZueM+vzYggCqh2XurSgWyA3qgJOVUqmsYPl13/Pbl+uFVIvWFF/3w12KX/GsD4U4KQJ8tSlrf4X1JJVR7c8pWnjLQAomoBlcCWniqXJ5N4jUrEzTzfhRQMDy5hFK74gfSiaCtxE8dwloaJ9vJ0Cl8X+WsYWKJ6n5yI2r3p0G6EnNuuZAssJaPRiPU9ORdokja2tHAR02DFvtMVNQMrwtwz9zWSDz96Q7HoXXF7gyCzLI/kfYy/9Mr8DO+/HUZ3jEhYY5zYPOrrPGwBrYBvkl1WHqSd4asR4sa70D+V1P3pJFAVo9tu0cdtDURgkBJg3KcR+ZEtLbkrSPiz5yu+AWcYraSiZvETof94l9wVBfim0AXIANoT1BTGrPUSdX/n7gmAHYxzsgyoQsnba0rW/cSo+tp/ZX9kwLzozQBGpfFqZ0Rnnk5RJ11hUDingsp5SjklPaNNXb4KDkxgTbual7hiqv7KMKH/GAIBDqpEsSU1odIbTJ39KZKaUI/eqQMgdmr/Ma6KcZG8BxKDV4RvU68E4QZC74x/h1+4BDvIaW5tNpW2aJDFhWR0qFZUo1ivtnyxALQuBCON5gFZHRGfnDREI3FAo77sIBml5BqS0f6JSxv1OpFMKAXrSKJeKlWkVsIa30BUGm4cg0dLuRS16XQoIgqbkjsmxE7foVbDw9xRH6QTfeJhN3Wf189pJc6ssM52LgpKgCfRe1yxk31Z8etcoN4XnB
 SxnX1nCU
 hJ75mrAH2X2TGmaTnMQFCElc8QsjtRS0pz2j0htORV6hDk0j6Mv+4a0hD7uQf19/IaSi5XyxJRFmDftlwWh0J+9o7aTZaJWV4tPWqIQzRaeUw/M9/ZbcBwX3WIOfDAld2uDTxSGSjfHl+1FAJ13Z0d9SCUpbiyNJYmW/mcPIhAetgcYm9lNiBdIIkhUEDQ+V26ZdoQq2S58adi725qnQ34Z1153SNSQpwtCXOrElnHv0QZ00ZrRON1jpwiPsIcjVMFHu9G7W4FZ8Wiizu0eSL8G+ooRCLHOYrGsb3iNYHC5Juw0vX8l6ln+LHHvuaVUF7G+k0RCVmlWIrM38sMBDZtxWkeYb+jlO2M2IaH5ijTME0fPBT213tIezouCVORPbHM7LPYLuuOSCDh9hZAbpWPT4+RaTpaO7BuTXPcJzGtDVV6CJq1FLGZPWRNghczY7SrG79M5rJCofB+H35EwzD75rrvWVREKmxJyprm1zjn7BkNkC8zkwkSZj4qB9E7Zbz6WJbBSPP66fz65hdpxCszcF97VKBSsRIKVu+/yR0AUn32Vobc2Hf9WA014QSvbqUNLndPRpWzJwReKKMt8G9oZtxXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 04:33:09PM -0700, Andrew Morton wrote:
> On Wed, 20 May 2026 07:09:19 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> 
> > This series extends the HMM framework to support userfaultfd-backed memory
> > by allowing the mmap read lock to be dropped during hmm_range_fault().
> > 
> > Some page fault handlers — most notably userfaultfd — require the mmap lock
> > to be released so that userspace can resolve the fault. The current HMM
> > interface never sets FAULT_FLAG_ALLOW_RETRY, making it impossible to fault
> > in pages from userfaultfd-registered regions.
> > 
> > This series follows the established int *locked pattern from
> > get_user_pages_remote() in mm/gup.c. A new entry point,
> > hmm_range_fault_unlockable(), accepts an int *locked parameter. When the
> > mmap lock is dropped during fault resolution (VM_FAULT_RETRY or
> > VM_FAULT_COMPLETED), the function returns 0 with *locked = 0, signalling
> > the caller to restart its walk. The existing hmm_range_fault() is
> > refactored into a thin wrapper that passes NULL, preserving current
> > behavior for all existing callers.
> > 
> > Faulting hugetlb pages on the unlockable path is not supported because
> > walk_hugetlb_range() unconditionally holds and releases
> > hugetlb_vma_lock_read across the callback; if the mmap lock is dropped
> > inside the callback, the VMA may be freed before the walk framework's
> > unlock. Hugetlb pages already present in page tables are handled normally.
> > Possible approaches to lift this limitation are documented in
> > Documentation/mm/hmm.rst.
> 
> Thanks.  AI review identified one possible issue, possibly a duplicate
> from the v2 series?
> 
> 	https://sashiko.dev/#/patchset/177928604779.589431.14703161356676674288.stgit@skinsburskii
> 
> I'll take no action at this stage, shall await reviewer input.  Please
> poke me in a week or so if nothing has happened.
> 

Hi Andrew,

A gentle reminder as requested: do you think this change could be taken into
the mm tree?
It's beneficial not only for the MSHV driver, but can be used for
post-copy live migration of GPU states in future.

Thanks,
Stanislav

> Which is quite possible - things seem rather hectic at this time and
> we're almost at -rc5!

