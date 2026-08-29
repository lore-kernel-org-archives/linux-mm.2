Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C4E4C61DBE
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 04:15:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6E5D6B0088; Sat, 29 Aug 2026 00:15:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1F836B008A; Sat, 29 Aug 2026 00:15:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0DFF6B008C; Sat, 29 Aug 2026 00:15:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7BD4E6B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 00:15:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DE4E3C0605
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 04:15:47 +0000 (UTC)
X-FDA: 85152993534.21.CC65C82
Received: from mta0.migadu.com (out-166.mta0.migadu.com [91.218.175.166])
	by imf19.hostedemail.com (Postfix) with ESMTP id BBDA71A0006
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 04:15:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GKoI+sHb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.166 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787976946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z0w3SaLw7s46A0Jvxhn6veGxRY0w6Tg/WrdmOoP9G6E=;
	b=cjc11uenW2TqfSzWSKN0vBDGeOPE1rCgYYPs7l8DBLXgmKBsCp5lQr31+7fYIFqwc6WMpb
	W/B74NASf0b+w1yn8lfWmLSIiW6N6qaGSu3jmBc3OU0/STBRfaQvJAYpRG4rqFoKjNJP8d
	ibzaK4tiDtYnAN+N0UC9Uh0UNk76RUI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GKoI+sHb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.166 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787976946;
	b=az6gtDf943Rkl3rw4VIw60zfh+Bk3//FRcOxJJJsg68KHInbxBZsAznMFP21TPwwi/z+Nr
	6ubewij/Qn280BdlaKKip2brBS2tOJ0rGtwPwX8HdeY+naqmB+RtKqJt5QaD8UJqrG3gVc
	7MRb/NUWfDrZZ/c1ETIav6Yu/1lPDls=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=crIh8UEj7UTYgK4YPrj5yXsDBpaEjutnGpyw2Nwfjms=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787976942; v=1; x=1788581742;
 b=GKoI+sHbB6L1d3xkzA9kgBl33Bw9biVuN1R8OjyBeFa+Cr0+Jml+bx2I/aFvEZbr4e1KY7tU
 YmMwQ5S/SFnEIsz2TP4AUPgilGaYzh0vT5A7H8kRYPYw5qOpbDM53HyvuYH30NRa3PZvD0h4PzE
 BtTK/bugy7Ejr/5Q/gRkbCaU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b8a438c168cc2223;
	Sat, 29 Aug 2026 04:15:32 +0000
X-Mizu-Trace-ID: b8a438c168cc2223
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: kas@kernel.org,
	jthoughton@google.com
Cc: lance.yang@linux.dev,
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
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: Don't collapse uffd-minor-registered VMAs
Date: Sat, 29 Aug 2026 12:15:23 +0800
Message-Id: <20260829041523.43008-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <apGHG9LJtDpe2kdG@thinkstation>
References: <apGHG9LJtDpe2kdG@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BBDA71A0006
X-Stat-Signature: 9daowg35j69n9nuw97ng3idadtciz3as
X-Rspam-User: 
X-HE-Tag: 1787976945-943352
X-HE-Meta: U2FsdGVkX19AvCQ0GU4tvJpC16Sbw12+bHKbmh7uFW7jb2+5b6qfVReyZiFnnvjTe6Qfu3yldj40Zz7bCd1djPuFZEBv3JMEQu+ZFYLqaRImBTvRm/5rXTvS9yRoJpDnXMM/DRcP1EjiyJIWnIcLsb8l9ePY/GyGo7pCK71Qvf3KX02gTASdLsgbiXp2peObkjmrBV+Jp1ZPB3ETkBARQsTmRpnoreY+a6q1wF5iLguxdT3j7QUjcH4Zk0BwzvDv7OehRXpycKGqCSYXLai2UBO6F/4uosAJGihmMoQZ68q+R7ivWz+ZYpgNUgZM6QMQ6uS7rJz/LGuY4H2FLDl0ZWvN6af1a7rfE6N9+giogmip/gAx5C0Xjr23IuvjmFmHnTD+1/NdnXnAOOvvetCbdntI2IvBQzYhWmIbRzd/FONTB54wScQ8M2bVwOgB0O1yroZ+TWsjgOrscca63Bqm63R2AYM4hg8fW8C2wYHb6iGrvQ1X13n7s0FrFnWJ5KvABVQge1gERjK3cNNy1TjOhLNAEQvT80Yww3DMVCW4AuIylitYrmRMnMCgXA8YhvIfprTJft4syMxqrC/Lus4aUErEVntS2CDGpuAm39GEh1/WvNTgNbAxT7i/qsM+vCZfwDNptoOpvthwWboSAvz65fbjgMtwSody0XQFtYKV8jR0EftlyxQ8CdBo9K7Lc9OXUkLcxTAObOSElNilTsUNcKUd29zX3osAhoQvB025rN6w5GHKrGm/TdFE75rUzTK69IghtCMnrNxe22sEpWT4oY0cLnszfwIzp9FObRBlHYIitifRin1so46SkVAodhPoDAQ5ioUGmgc42esHkefWS30kk7s+dDFovhjN/p8zdnQ8S/0laO3wraj9fwr0/f8v8HDr2ZfhFsO+aZAXgzH26Ps59if/041XJR/CWyFsOWUjwAfMUHsxy0Hsc7HuyUhZmDLJO9nrJ7F5mPCrBOr
 2Klwojh5
 4ZfO0QEx0pX1oiSLTBhkP8tEhW+d7Zz+Wh/gQX9qdYBT+dfIgCrdNVPY7rX+UCrIlCxoX0lfOXC0CExB2eRzqZO7PChr/YwS+OtagYGN2b4686WpXELiHU6j25POPJU/o0CT25t/afRJ6qz2CchVmIRaJsI5XTeEP/1QuzK6AaQhy7S8iHcDlxA+/8LJa8u9JEFl+PwG7o6v4FF0N9Xt7HDZJeISfwIi+0xPBiCkkK+xHCLo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Aug 28, 2026 at 02:07:07PM +0100, Kiryl Shutsemau wrote:
>On Fri, Aug 28, 2026 at 05:47:03PM +0800, Lance Yang wrote:
>> 
>> On Fri, Aug 28, 2026 at 12:50:04AM +0000, James Houghton wrote:
>> >Userfaultfd minor faults provides userspace with the ability to manually
>> >install PTEs with UFFDIO_CONTINUE. Right now, khugepaged collapse can
>> >map holes in the VMA when a naturally-aligned THP is present without
>> >explicit action from userspace.
>> >
>> >This is a problem, as it bypasses userfaultfd minor faults that
>> >userspace is expecting to handle.
>> 
>> One basic question first. Should MADV_COLLAPSE refuse to collapse a
>> UFFD-minor-registered VMA, regardless of whether all PTEs are present?
>
>I think the line is not between MADV_COLLAPSE vs khugepaged, it is if
>vma->vm_mm is current->mm or not.
>
>In other words, we might want to allow collapse if workload itself asks
>for it, but not for khugepaged or *external* process_madvise(MADV_COLLAPSE).
>is_khugepaged is not the right proxy.

Right, IIUC, we have two options so far:

A) Conservatively reject collapse for any UFFD-minor-registered VMA, as
   this patch does.

B) Allow collapse when the workload itself asks for it, but reject
   khugepaged and external process_madvise(MADV_COLLAPSE).

Maybe there is a third option as well. Would be good to hear more thoughts
on the expected semantics, especially from the maintainers, before
deciding what the check should look like.

@James, thanks for spinning v2 so quickly :) Please don't send another
revision until we settle the expected semantics here. Hope you don't mind
giving us a little time to sort this out :D

Cheers, Lance

