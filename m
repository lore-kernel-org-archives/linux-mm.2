Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C40B0C61DD6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 06:03:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6423D6B0088; Sat, 29 Aug 2026 02:03:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F3DA6B008A; Sat, 29 Aug 2026 02:03:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BB6B6B008C; Sat, 29 Aug 2026 02:03:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2B9406B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 02:03:15 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8825BA0667
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 06:03:14 +0000 (UTC)
X-FDA: 85153264308.15.9126B40
Received: from mta1.migadu.com (out-226.mta1.migadu.com [95.215.58.226])
	by imf22.hostedemail.com (Postfix) with ESMTP id 67CFAC0005
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 06:03:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aLUZrHCU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.226 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787983392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2nKCYiczBAJCMBpYsFd6MDe1rc665HSV7YcItXfElLA=;
	b=RCTVQhJTUn9SD2oQQx1CkJXJ4pqn4pMugPr/La4o30X7NKP/75Twu/JNzgU4J5reVyp1ZK
	z/EpY+M9h7hfFSzlNafdTuysfjpRgpAn8XonZ1e27Og8rcCDsRW6mOj6vOWiq2x0jujvWA
	0Cgo/Lmz38eH0Hlq8iGopHTlk1XDT+E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aLUZrHCU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.226 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787983392;
	b=OVf6yPRyZtRMyg0sZtEr3TbRjBkIxsSBfQqupcytz3+VeN+bxUyIXgtS2Aki8jLnZ2rjk4
	LIOOgz9racopN6cRMjU/x3MrajLpsb7i543BiRzK4Iqtf+6+Ndz8oUNlYuvYWZDnmnWp8n
	MB7mZdOloGz+CQQI8ryDwzIIsKOG5as=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TzTNMbh9vjF8g7nb8drIq5LNaabOjqGsc0jttZOZZ50=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787983390; v=1; x=1788588190;
 b=aLUZrHCUcClmRiKCC15GA4UXblh0K4Oc3AUW25W8ggb96S17qQgaUUpywKkK2rOGR//wL4Ul
 pNEpjkIgsudnkJoi9BsSj6Knz0oqqYqat6E39wI/afBui3SEiCy9kL/TNzfoimImX1SvmFV489K
 CmukqBtc00jfSSDMuSIoIb3g=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4a4045ff180f087c;
	Sat, 29 Aug 2026 06:03:09 +0000
X-Mizu-Trace-ID: 4a4045ff180f087c
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: jthoughton@google.com
Cc: kas@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	usama.arif@linux.dev,
	shy828301@gmail.com,
	zokeefe@google.com,
	hughd@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] mm/khugepaged: Don't collapse uffd-minor-registered VMAs
Date: Sat, 29 Aug 2026 14:03:04 +0800
Message-Id: <20260829060304.51549-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260829041523.43008-1-lance.yang@linux.dev>
References: <20260829041523.43008-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6m9494315r6h9ctyd9dayrwhntdoe1zb
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 67CFAC0005
X-Rspam-User: 
X-HE-Tag: 1787983392-660024
X-HE-Meta: U2FsdGVkX19eRUfiuMf+MUuwtAZRsGJwFYmy71wxlhjqks3ir8Nrsa4w6qwoL6UteuR0f/P/xeeA/8ahGGD9S5B4cimxdJz/zZ1SRoAJIJL/DmjtE9O7gP7HqwoydL8SiWqeWi5fRYBEUocrcDbC+84/UNt6gjwHdcGDBguAG7dCqnYUI/BBiq/+puEOcMmeuidj9LPfNAzpleOo5z1cOdbmninsB3h7WllHBz/MdpLeoIy22an/4Tn5tUPW+l4eCZT4aRxes/AK3LDR97849G0ZQhgGVyJ8vLE9vGa9w7DHDN6QRl9FEVschPai3g2KEy6PvM2HRESyfJT6/cWpUj1fyoomH87p0Ft9fA7g8AIPVYMYgo0CZ9RzuZbPDtjbpZAxABofzrIDatWGwGiWDzvPkoZyj/i3qCIkPh2lcoHmp49URXOAUfK3x+OStg7xcCka3Zh45go+Cs8/imKZeJRdMnfMEYH1fuBqBRYwsZTLFowgl3oQNfT4lWkBPFrVrqwdZTt6sr8eJkmY2ffLWpOIqqzMeH5clywxsVa+LKQHm8RLOczjKn+j45YlBle6p3QiniFL01H4nfgE6NwQWbd9xO0M9RhZiZE8veFNS2I5NgWMEjBqK66YTUlZHq0Cj7YgnMEqOI+TbM0nU92eVTFe++9CBRZVCNBWAYPyrEykPwJTwOuGQdsCA3rSa2eTWTtj1hPVYJ0lOJpkKzXjYYMrNqO/cYr7BmH/9DXAD//aNwIFFM0ISe3jDFCd1ILvJHDt9+JbdiJQ7KEpnzcq9JBw0Li1oS18StmZQKZyARAO4K1+n7PFxR6pZT6+v2W4oJ6+BvYm22KsU+M0GbhQa6ZsGAFGz8aB8oBKD6y1xoiBIX8XKxup443A2hSEXeKysb721wFW6VkqQxFTM6BGIZbDsOfG9D+hsDmsBcA93WnlJNne9JyQ6poOEibA+RhGgOXsw17u4CAXFSBciMh
 7m6pzxbc
 XkP1PBXcNkeiXrqhHqmpv41kWC5jfVzVOYLxHgzcG0wVbHO74zB4MyNfZtb8QbKMGZy3xok+LHFnFBEH82LLbLe0YX6mzlxbGY6ONOOp9kIhMlkcH6NRH05H2+pBUPajydF1QbG+PgQ8akmZlUZuIDnky77atnYL0mYquKPHj8v/yrZEBqZHcJKf6yLvw0LQIeajJGUND/TFIz165HbiC1JNuLcJWoG+yFWVPE6rhq6I24tE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Sat, Aug 29, 2026 at 12:15:23PM +0800, Lance Yang wrote:
>
>On Fri, Aug 28, 2026 at 02:07:07PM +0100, Kiryl Shutsemau wrote:
>>On Fri, Aug 28, 2026 at 05:47:03PM +0800, Lance Yang wrote:
>>> 
>>> On Fri, Aug 28, 2026 at 12:50:04AM +0000, James Houghton wrote:
>>> >Userfaultfd minor faults provides userspace with the ability to manually
>>> >install PTEs with UFFDIO_CONTINUE. Right now, khugepaged collapse can
>>> >map holes in the VMA when a naturally-aligned THP is present without
>>> >explicit action from userspace.
>>> >
>>> >This is a problem, as it bypasses userfaultfd minor faults that
>>> >userspace is expecting to handle.
>>> 
>>> One basic question first. Should MADV_COLLAPSE refuse to collapse a
>>> UFFD-minor-registered VMA, regardless of whether all PTEs are present?
>>
>>I think the line is not between MADV_COLLAPSE vs khugepaged, it is if
>>vma->vm_mm is current->mm or not.
>>
>>In other words, we might want to allow collapse if workload itself asks
>>for it, but not for khugepaged or *external* process_madvise(MADV_COLLAPSE).
>>is_khugepaged is not the right proxy.
>
>Right, IIUC, we have two options so far:
>
>A) Conservatively reject collapse for any UFFD-minor-registered VMA, as
>   this patch does.
>
>B) Allow collapse when the workload itself asks for it, but reject
>   khugepaged and external process_madvise(MADV_COLLAPSE).

One more correction to option B above. Background khugepaged already
passes install_pmd=false and cannot trigger the problem, so the
distinction is only between the workload's own madvise(MADV_COLLAPSE)
and external process_madvise(MADV_COLLAPSE) :)

Actually:

A) Reject MADV_COLLAPSE for any UFFD-minor-registered VMA.

B) Allow MADV_COLLAPSE when the workload itself asks for it, but reject
   external process_madvise(MADV_COLLAPSE).

>
>Maybe there is a third option as well. Would be good to hear more thoughts
>on the expected semantics, especially from the maintainers, before
>deciding what the check should look like.
>
>@James, thanks for spinning v2 so quickly :) Please don't send another
>revision until we settle the expected semantics here. Hope you don't mind
>giving us a little time to sort this out :D
>
>Cheers, Lance
>

