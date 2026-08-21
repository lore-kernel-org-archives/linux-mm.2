Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B7DAC5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:32:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CE606B009D; Fri, 21 Aug 2026 15:32:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A54E6B009F; Fri, 21 Aug 2026 15:32:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BBF06B00B1; Fri, 21 Aug 2026 15:32:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F41916B009D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:32:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 84CDBC025D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:32:26 +0000 (UTC)
X-FDA: 85126273092.20.5F4E67F
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id 69C7620002
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:32:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=crusoe.ai header.s=google header.b=GILVEdzZ;
	spf=pass (imf03.hostedemail.com: domain of saravanand@crusoe.ai designates 209.85.216.51 as permitted sender) smtp.mailfrom=saravanand@crusoe.ai;
	dmarc=pass (policy=quarantine) header.from=crusoe.ai
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787340744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5JVluRt9hjfEs62IfBbnf51ozgw6/oMZ0suZWtwoxGY=;
	b=ocLOh/ivfH2hdqvJr8uadtTiFQt0QrtSqBM8YQ9lzuJACPJoYff8sM1Ei0cDNfisgfG+5L
	XPFF8kbq2HxVJIyQMr/o3MR+BISu/5yPr3lpMh8b779gWhrUGi+l5ZlLsfcBndNdoeSNRy
	exqXvMuZR1UbfrYtlTtRr4BjUTFZepM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787340744;
	b=BRtYICg+K9gfj/x7/9ttLsqSES1wpvNEFnT2cVp9CD05FH/1PwwdeeTdkQ7S+XLBNjNxB5
	8QpdUbYBKof9Q4ONZHz3c0T82toAoTqFngLhDRPtbW5UXES/NQ44PVRzTKiKV+qx3ClX04
	4gBAFRiN8DqeK/Ul8UFln4/qdXij1Ok=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=crusoe.ai header.s=google header.b=GILVEdzZ;
	spf=pass (imf03.hostedemail.com: domain of saravanand@crusoe.ai designates 209.85.216.51 as permitted sender) smtp.mailfrom=saravanand@crusoe.ai;
	dmarc=pass (policy=quarantine) header.from=crusoe.ai
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-383cb94f742so1510331a91.3
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 12:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=crusoe.ai; s=google; t=1787340743; x=1787945543; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5JVluRt9hjfEs62IfBbnf51ozgw6/oMZ0suZWtwoxGY=;
        b=GILVEdzZeLVBpyLzd4ST8pZxn+4cZNJB54h9leD5UEFjaZyEEwWvhjjcnaWYUQvjcf
         ys4N8HgrcFn/+Yci2+3aiz30EPjWWzIl7F0AqhmjzfsDuZYP8G4zJ/UmYSzgYWjb9BES
         fXJFMBskrvrK+Vas47kFNy8jYSbB5gL/L0CnS87SoaRDIJ7B7eekDHRuxlrbv5nfx+cg
         O6MUOUoBW97x2u9FzJ0gEQKAN4hCGQk39vj/EG/SWGVJTityW8LIsStt4HkxYlAu29yW
         FamWuA9BQwhVWygLh7snUOTK8OArUk8tjBCdnJCqY949tv43zqu30nCtvECUbMtnZf8v
         AO/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787340743; x=1787945543;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5JVluRt9hjfEs62IfBbnf51ozgw6/oMZ0suZWtwoxGY=;
        b=boCXoY8Y8D7djxHvz4OfWJ/XLchsMkVEGpVxX0bzLnRw/f5AO4zqTW6BT56+Fq5EHR
         U+SPJnR4fQhmtPfHrRcggSBrH/wTWyiaTHzp4mbt8tCdPVcb855JfIKdO76gBaLNTjQu
         HskjOCCzP4oPjrqX1fUrLVLKXxwhm4UMWUm9Bx9sIQR2TYgO+QQAZK5knRUSRvJJ2CFD
         2g5oynGqHYgh8yIb+tVVm166ZMbqQqOiUD8TGRMdkz+kllOOjMjoPTUWFsvbyF/r5dIo
         h2piP2W+jn9aeCYR7C89p5j1EBaArscGfbAk0HCc8JzhV4RbDWXXmOt9S2xhKDSwyHsH
         q2Rg==
X-Forwarded-Encrypted: i=1; AHgh+RrorQQspqdsSGiJeoZvdDErAY90sV8llajwgtaU9Fe0Z3n40PuxxeZoZyz5omCohvJsfscnYR4rZw==@kvack.org
X-Gm-Message-State: AFuF++mqJbzSoD27wOucFs3FdLl9Y/YvRWrb5gJILsQleywzUxMVxa0C
	a57aOwCzZTBt423L6+Gg+FRVUv/RH0hfWwiOO6PevjSXe1P0vIVCpYmYqL5t267jna4=
X-Gm-Gg: AR+sD10Y4Z1t2U8ibayFZsNOybIsCTQg93KxG6pS+hW5GALVWdMGvdZHnBOXsZEaTE1
	XAcEIa9u9aoMmIcBvdhox9ZTGWxUu2M4VVBxffLewMQpHLkHMAmAyJbUmxnHEV3AtNVk0bdB4f/
	Ww646M/rtCRgCl9eX6FZG1wbMCaJaaJMf2gks5i+LcnXUZwHbDRHN9ftAglMjBhv64nLSnCLJmV
	krt8OYYV0V+PCGg6/zlx7Yz87aOMxhSLnuQCZ2/M7e6OULTgdId89xCGjXxD8shHAy0XFWb+VUI
	+TZQ0BADdH3X70CAM2bh1+kEp2sM/Mg87ogTS2mPsV1OPfYSEN5IN2es6jKnx0b8MwowpQg44fg
	Kj5HFLfB8u8GemlvDiMQPrShmrKGrXEB11qKxzAc8A4Xo+LDZBCON4yz+4+u0BbnEUduyNNXsla
	bpNU/AZsWCHW6gcyCF+WSE6FbxkByKmo50tu3yMJZnCThmvN9R7/2UjTV7nfq/dAPrjVdHFHcTM
	GSTkpkJOigSQiUZvsYOiqmVoxC+Ca7syg==
X-Received: by 2002:a17:90b:5886:b0:395:4de4:92c7 with SMTP id 98e67ed59e1d1-395dee7d5f6mr1692967a91.3.1787340743073;
        Fri, 21 Aug 2026 12:32:23 -0700 (PDT)
Received: from MBP-Saravanan-D.civet-hops.ts.net ([67.208.231.220])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14186183c0esm471436c88.12.2026.08.21.12.32.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 21 Aug 2026 12:32:22 -0700 (PDT)
From: Saravanan D <saravanand@crusoe.ai>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Saravanan D <saravanand@crusoe.ai>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Peter Xu <peterx@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: allow huge pfnmaps regardless of THP mode
Date: Fri, 21 Aug 2026 12:32:20 -0700
Message-ID: <20260821193220.91799-1-saravanand@crusoe.ai>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aogCjEc9uyMjFP6S@gremlin>
References: <20260821070520.25759-1-saravanand@crusoe.ai> <aogCjEc9uyMjFP6S@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: oe38sz3tmx37u16o8io735kiatptdffr
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 69C7620002
X-HE-Tag: 1787340744-554666
X-HE-Meta: U2FsdGVkX18UMveT5Fjm4axga7otNLkr/YHrKk9fd1JBS6Upv5DCdEVNRbkOYtLav1ECLqUugcr6EvLb7n6rAYgzkYgncMBmeqWWksRIW0WUwDNWzjX08sKh5gXnhZHt1+s8bbbJj9EwKY1EDjH645M7GGYxQX5B60XpvjlvKquJ6vgqk0zAZdKqNOmMOxexYY010UJNPstePyYGgPKnTT2HCW/ZSLVo0AjljizsUis4Qp1Gm8yzdMCpW+7m6UdVScW9sZB/OTT1mhYl5IrK/tRlBfFdtCZ0oVLdq+iSj5l87ilZTVxwxjiE+avf8y0LnQj54OTU1N1l4/rUD2VfDiaLdfr7TmLadlSl8xEpIxi2cWQQnt4L1rsbFItZQlTSVwzGZIP3jRnc0FCDiDpyqTomvmbWXL0vjBdHXniT3h+f66xMrPUWpkRJ0KQfmcRkELJLOOs+7w9qzYxQO81ahFDLY2ULvNVz7iCLXdgFG+nm6UbmxYNb2B7Ofs8Wqu4IQt6YxsaD961gYNcg77eaCy1ICUeSYUO3sVXM8DE95aDQoyoDiOcQSZfVzYvhPThLgCkWBR3dWfNuZBoOFwNO5TADFliE9jU7/2m2l63HA5+jPbthDBRS48gQYD57PkFa/CIl8olH9Y44WBWC/kVAlgtyH4BZXP5L1JI//g++U0UhMOQX5UoyXn0WDUdg1+8XncKYmA/5WfUbcJYwGMj/tH2vMEoK6tiDu+4jNDzlu1ne75tJ9fc1OjSM7n4orNUFNJO/2nY17nGr6PTYV4/SlvZ2+yCzSEJgLUcLFPPUhAG7YjV/IMMgavbJxCofEwB2Iy9unHgmTw0lHtkP9r7uOjusimhNcyvdggjmUWeVjDy/MDkHRIsKs5CvF9f0oAH0N5aI6LDXcrwX8RBmfUELMC80qcgitzqK5Etbg00jMX/BsN84noENIN75NdscW9xCXAfbY7aUsIBEFjgt9aD
 KDeYulvu
 ezqTZhKQyhHfVXpmnWHyigI8/drztmYpx2+Z3Si/NH9kX6FdW2OFlodQPfEf6q1KwRuRDHHGeuvn9hrls7mboMwYdwM6rUhcBIG0RhNBO6SSPYATAvpOK11dF57NHyxNnXDUZqF67ne87OA1MANA/vOEQRQOvk7EYQX8Cog3iGSA/uxOORjK/hwZ+Ye5sobk0p8ElpiPxILwM/Fdkg9RunSHQFmoGBrq0GoQcaVqCbCw6CY0Bc9GzK2Alsw4Ld84z4qKOGAVdOO4EyrgUGPEcrKaZdmxBjtQv37l+o7isc/2nQfRPu4IwEzrrQe6M67xLjj1mV5Av6IbD/DtVII2xR5sNS5vuB8L9aWp1lV42bIkFAnt5QCefzFP/fw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 09:03:15AM +0100, Lorenzo Stoakes (ARM) wrote:
> In any case if you'd taken 5 minutes to search the mailing list you'd see
> this was:
>
> a. Already submitted (so your patch reads like plagiarism).
> b. Already rejected in favour of me doing an actually sensible solution.
>
> https://lore.kernel.org/linux-mm/anL-NZkNMSSxN0YN@lucifer/

Apologies and please disregard my patch. I had not
searched the list before sending and was unaware of Cédric's patch
and your rework. Mine came from an independent observation of slow
VM boot times on Ubuntu based hosts running cloud-hypervisor with H100
GPUs. The patch was prepared with AI assistance and should have
carried an Assisted-by tag. All of my future submissions will.

I backported the diff you attached in your earlier response to
a 6.17 based kernel and ran it on a HGX host with four H100 GPUs,
each exposing a 128 GiB BAR1, with cloud-hypervisor. THP
mode was the Ubuntu default - madvise in all runs.

                       VFIO_IOMMU_MAP_DMA       4 GPU VM boot
                       per 128 GiB BAR
  6.17 unpatched             20.7s                   97s
  6.17 + your diff            0.4s                   17s

Each BAR mapped with 128 PUD faults. Your approach will definitely
improve VM boot times in our production. Very grateful for your
contribution.

Thanks,
Saravanan D.

