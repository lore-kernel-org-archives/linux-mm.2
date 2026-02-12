Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C200EDF045
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 06:32:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C6FF6B008C; Thu, 12 Feb 2026 01:32:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 974736B0093; Thu, 12 Feb 2026 01:32:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84C6E6B0095; Thu, 12 Feb 2026 01:32:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7378D6B008C
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:32:34 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 170688C19C
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:32:34 +0000 (UTC)
X-FDA: 84434835828.21.95CBC32
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3CD8DC000D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:32:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=bSsPL9s7;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.169 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770877952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=novXMj47xCzM4XI7bDHxRF2G9R5eBxqnzIiSrqKp/Gc=;
	b=SAe8haJS6EGWq9X6xjWqrke9hm3UQyu99nNBWv/bpSsOIipQFKxGcrM1zoOKAY6ZXbVVCN
	FsLPvP/B7TvdwCoLd5Xq6oJI/8YjjrNBMP1hgzSgV7nHPoSGv/D5Q0+XBL2ZGhLMbcUDYv
	QUWPaAk5MIwJpG2VZmVaDCT6xCjwNLM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770877952; a=rsa-sha256;
	cv=none;
	b=73pFirAf7i8QWqwry/9YO6bh+ZW4AF06DvIFhTWPkAabL+FDfqi4J+gyYDkH118rYUqZ3D
	/ET+8oV4V0x3a6AymqBBbIaGxRStkRcS5RSHKFWpae9L+RrI+F2nnc3kbnGq11u+p9ZIV7
	H0EbIjP0ajJfzUZHDrck5khKOarl7Qc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=bSsPL9s7;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.169 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-c6e2a8db928so235198a12.1
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 22:32:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1770877951; x=1771482751; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=novXMj47xCzM4XI7bDHxRF2G9R5eBxqnzIiSrqKp/Gc=;
        b=bSsPL9s7YGHY0a84wRRg7hDjyR04gbJNX5Xh7dJJC06B9lyRGZSLEtbGwMYaB89HzF
         jeYgqrGjG0ybrZLc1/KMlh8MutXN5w5nEuO9/z80mPp8enOixeMMkm8pfxp5zENRuyp8
         flr/A66MxCH1XLc5ozqpFFNJbB9Rxs2/FhgJE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770877951; x=1771482751;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=novXMj47xCzM4XI7bDHxRF2G9R5eBxqnzIiSrqKp/Gc=;
        b=X1OdKjtTl/v5m24bggr7J+vYU3pG+1hxg9/jd4KHXhGgW4jknq1RrlDOvpfam2Q/nZ
         s5JW6YuVo7bUQ9/us1qNINNPAoKFNAFDiAa7WNZUg0DpQAnyEvxPXKIy0hZghtRK9tHe
         4dALuWrl3q51NgLd5IGBgnVzeUes4CGgUu3OSku7cllrxMcJ+7dAVlDCTwfy7j4KPKea
         ppfc6TLTcM//9RS2hbxiKjDVeEz64lagm/ew8VdDWbRBjP1ip8xdr6KCRepO96l2wi8W
         GsFul6YKhKu60CHLf0o07MuU+R5MIVsq8d+NQPnlmViMyzTVBCCcAiGBA6Of2Ympp0o3
         5IWQ==
X-Forwarded-Encrypted: i=1; AJvYcCUf9/gJNPWxi0A8y8RCRVapzoQXrEr5LVAPkVWNuRU14qI8uE9vqnwASZetJexez5ApJJCLlgDE5w==@kvack.org
X-Gm-Message-State: AOJu0Yx3V42ZHkmPnYD0lnOC+zkverzAUcg9HuhI0G4+vSSogZ2NFTtK
	xpiti145E81CeHSfA9xzcleI07gwFlxsb8tJsTR56WMO4gVLG1UCSOmQdhe4Y+BbGA==
X-Gm-Gg: AZuq6aLjc4saKnafMMJ8hmISrcFIVNh2hzKQB8sSejlyHNb6bYd7D8IjdnIpksCtf40
	s9FapT0cFF3jkIWlHEr1ROvmVoONDv14Wn+YQBrqdYal1CL6OFXY+lldDF00ct6yLgU8NmMLoaQ
	349OX7tHPxKAx87RxRyBMssDehw14+rFyaismSIyx8bcmEJ6uX9caMdQOf5LCb56kSUYXosI4iX
	pulaio2rq+3Je5brjQ1KAsuIj7FCTChkAS4paExaMdz0Ur1a9vBXhZrboJQDlV/af+GNba6KBa0
	3BSaL+2X4InXpQwjtYQceJDEpX9ImdvY4VCCqKgL4JqJCromjdFcYCITgtthYHBTZi1kroNlVp6
	9BUb4gWLQpWcb10dKpbvBYKwxW10NDeUATHcsDjk0DrvuI3ajbfkinecuC6rLqRekDBMu1QT0Cb
	e2/6y5gTKr8fNq53vDmzV6LYRAI5QYQjheAzkCWwU+gaBZYRb/1rFHdpVdPQj5qw==
X-Received: by 2002:a17:90a:ec8d:b0:32e:a5ae:d00 with SMTP id 98e67ed59e1d1-3568f3252cbmr1929002a91.13.1770877950917;
        Wed, 11 Feb 2026 22:32:30 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:725d:f34:4b56:7316])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35662f6bbe9sm8028461a91.12.2026.02.11.22.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 22:32:29 -0800 (PST)
Date: Thu, 12 Feb 2026 15:32:25 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] mm: khugepaged: make scan loops suspend aware
Message-ID: <jftqdosilzfkd4ku6pjuevkvuwmhlqtua62jwsmmgdfcseitb4@gopt2xzqhyrk>
References: <20260211031512.261127-1-senozhatsky@chromium.org>
 <104bc764-5a20-4ac2-95a8-b31f41255766@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <104bc764-5a20-4ac2-95a8-b31f41255766@kernel.org>
X-Rspamd-Queue-Id: 3CD8DC000D
X-Stat-Signature: ura14miijzfrbor4897re4dfoefbfpur
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770877951-524322
X-HE-Meta: U2FsdGVkX19QJ4R6IMZ7kZf+593wi4NyRAlhKgIRRWq40uxoL4l5cavNi6bAlXpEF+lYFsPSUb44wUvoNxTkag8j7w6LlstVveWpnyIzL0gHcNmJURZWG35saGYHtbZJ/+dDkUCFRKtZ8fUXzipM2elfVSnOgpcBaHGUmtm0lPQ3MLZgq/52qQ8mHpu1e4YxWCjZMXPtmXXfUeHUo5qC77meydsITlLmV+lM66DTqxxv5St3UiN3vgryo0MkFoUsK8uxkkyZfqGLxhj6jTo6Q177F9HhesGbt6+NxWGtAk++VuZLk24PA55jFq16YshR2diYVPafLKbT4FwlYJyVi1Y2BDmvkrextHUU7PJDXtQLM0n2aN9Vfc0RDz4qzmfq375pm4CgJQT301SuA3nA68JyFEBuiBVx/yYoS0Okv87E8Gqa+rgU9jirVCK+YeBDWq92KqGwsdNLqq26HqWMGzuuC6wI/00jd4+Imw8ZpE+qMZI7+N/RNGnAOxd7iH5IqdFp97VR9vsfurbcj7IrTfDxmHsY1+ZpYXVz/nDQ9d1m9NcH6UozWdgT2e1dpGqyAduTL3AvjLFPpTdEqv20U9CZ2dpCFtu061wVYwh5xkXvVsOSyYsdKfmB10aV9WXKh0tuyNsQKSyU2Ky/xeWJoJmBqEFhSPzyMqjYIHRI+Q7W7UZtNucP4iUFPw/zRjrotGygxm8AfGvw6uGsYPuezDWqEhwOWMeE1FJT5mX6wmhnbB42QgBzzMQZn1B3fjaMuHIwX/5s7BxFR6AT6uKUJzWrsxGHBeQuYLSi1sZRCihZSIqkUlKiByvZRyGqVV6og0yqyoBNsL8GAqScAGhmjEf3CZlSlWmpu82ax9ZJKtJPsxtJbBl1StKdyjUOJ7Lc7h5H/HXceFPnOgnpKrbtRodcnn1s3Kfu5AWerRRgAf1MkxtThhsqwen1KVz/7Pw/VwaXY2mLwBMUz2PNEdC
 8esmsgB2
 gWHgiYelyiB8qvGLtpDOgNfFfmGAcKzms0OrfiYqa5lWLVGN+b5E26rEip5WE15jluIG5E8keVr9LA/Na3rJh8fFlJZsADRF0uKq8TFAVOlhYHZy+rnkp89BK/qPvG4VX1P0vi9jW8v2E7ZjmJszJ8Am2eam0KiTpUwBPrIK8qDFHNAdHpvLhgp6aDddBvYg95SVISQQBWUvN7AKDiNZRU+B97uLWbx2bU3k9EyQbsOrOjk9OJ/m3jp7gVxFmSrX4QypcBHoZcev7ReUqkKrC1W5uyhdBo0aLu1eQBms3XJuENaLvEe+B1gutyOIHwoJl6vaaEa1Fp68YlAwifXF2KgQoYhR75Ftl7ix0MTmS3E23Upc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/02/11 10:50), David Hildenbrand (Arm) wrote:
> On 2/11/26 04:15, Sergey Senozhatsky wrote:
> > A number of khugepaaged's loops, e.g. khugepaged_scan_mm_slot(),
> > are time unbound, which can become problematic during system
> > suspend:
> > 
> > PM: suspend entry (s2idle)
> > Filesystems sync: 0.003 seconds
> > Freezing user space processes
> > Freezing user space processes completed (elapsed 0.003 seconds)
> > OOM killer disabled.
> > Freezing remaining freezable tasks
> > Freezing remaining freezable tasks failed after 20.004 seconds (1 tasks refusing to freeze, wq_busy=0):
> > task:khugepaged      state:D stack:0     pid:1345  ppid:2      flags:0x00004000
> > Call Trace:
> >   <TASK>
> >   schedule+0x523/0x16a0
> >   schedule_timeout+0x23b/0x6e0
> >   io_schedule_timeout+0x3f/0x80
> >   wait_for_completion_io_timeout+0xe4/0x170
> >   submit_bio_wait+0x79/0xc0
> >   swap_readpage+0x150/0x2d0
> >   swap_cluster_readahead+0x3be/0x750
> >   shmem_swapin+0xa7/0x100
> >   shmem_swapin_folio+0xcd/0x2e0
> >   shmem_get_folio+0x237/0x580
> >   collapse_file+0x247/0x1280
> >   hpage_collapse_scan_file+0x26e/0x380
> >   khugepaged+0x43b/0x810
> >   kthread+0xfb/0x120
> >   </TASK>
> > 
> > Make hpage_collapse_test_exit_or_disable() suspend aware so
> > that khugepaaged's scan loops can terminate in a timely manner
> > and let system enter the sleep state.
> > 
> 
> Do we want a Fixes: tag, and maybe backport this to stable kernels?

I can Cc stable, but I don't know about Fixes - we are adding something
that was never there, not fixing a regression.

