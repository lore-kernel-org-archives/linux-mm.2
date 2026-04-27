Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD06EFF8850
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 03:50:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF3046B0005; Sun, 26 Apr 2026 23:50:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACB1F6B0088; Sun, 26 Apr 2026 23:50:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A089A6B008A; Sun, 26 Apr 2026 23:50:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8FAE96B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 23:50:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 297C81603E6
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 03:50:47 +0000 (UTC)
X-FDA: 84702959334.26.5A18E13
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4BB85A0002
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 03:50:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=aAOLkdyl;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777261845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HzrlL1xMoGIlWpBRK048Z/aCnKO9gCFVK9rCjdEvcmI=;
	b=72yQ4lBmddgE/gtZdf3jgaEvIyD2Xkl3BYLFwZeZTvMTG1xlY59zuXAbBfN3ZnSjD7Fj6C
	cbO67J1S8+I3UVh13gw697z3DlLRtR5mtDpdzHV/EaUMV+9AFDT2K308aSNXgRqhksPiDd
	RaSl1VhY9mUU7bGWM8eLPyKYIqsE7wA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777261845; a=rsa-sha256;
	cv=none;
	b=n3mxOLzbkjNhY0Xa9rmgt0erpr/t+R5R/RtNmN/JBtdb/5iIx/hh0CDDxbfV2GDTVro6A9
	7QfMyVA3EwwsE/ooSrvd8QMJ+FZ/KHbImjxfgCvriJw6nS6NVKF3v6/6LhItOs/PBMCo8M
	dS6Xw1akacKBKdPEbo5SNUlWBJBxuew=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=aAOLkdyl;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 95D8D1684;
	Sun, 26 Apr 2026 20:50:38 -0700 (PDT)
Received: from [10.164.148.37] (MacBook-Pro.blr.arm.com [10.164.148.37])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C438E3F763;
	Sun, 26 Apr 2026 20:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777261844; bh=zkxFhlZxuv8BWG3mAtIzF1LABWxJnsl71a2G+oo7Zxc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aAOLkdylAOs7Gx/pumsYaXDaFDsWQDPbx2TdX4oJAkjfwD+s/6Jpa+fLZYDcw68uR
	 3JuZJqe3PM8qoQ4triJ0mxt0kW+Vjh0p8LlkdSIMhJ3Ey2SqNlW4725ckmevNH3Ifb
	 XKXQ8oCjBmkldnOry7jn9ShllEB7nnhRoGiwKgCc=
Message-ID: <e9e3f1f1-44bf-457a-ab1c-37a772ab8444@arm.com>
Date: Mon, 27 Apr 2026 09:20:32 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] mm: skip KASAN tagging for page-allocated page
 tables
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: arnd@arndb.de, kees@kernel.org, mingo@redhat.com, peterz@infradead.org,
 juri.lelli@redhat.com, vincent.guittot@linaro.org,
 akpm@linux-foundation.org, david@kernel.org, urezki@gmail.com,
 dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, tglx@kernel.org, usama.anjum@arm.com,
 mathieu.desnoyers@efficios.com, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Ryan Roberts <ryan.roberts@arm.com>
References: <20260424130157.3163009-1-dev.jain@arm.com>
 <20260424130157.3163009-4-dev.jain@arm.com> <aeurLGC4ohFU9Xtn@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <aeurLGC4ohFU9Xtn@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4BB85A0002
X-Rspamd-Server: rspam04
X-Stat-Signature: 5kyz5poj6mn1aehjdtafmzk1wtq16q3u
X-HE-Tag: 1777261845-250877
X-HE-Meta: U2FsdGVkX18h+iZMym9LxUfDgYk/akgn7gC/To3jgvU4PGg5bKLpFpo25oLMbWQeFO6d5cktu4GUGO4hTzeaawJf60KWoGOfSvSEbsAw6QZ4xceZ+DUFYpg7Zzk7VYeSyPskdOKV/WLvyhv/TEdvW7D9yXr4LFmqXvtBgDYtRz4HBhrMZy4VZQl1nEvPMhLv43v0cKhhkfPCJcGyzWLDHPTS9+CtU57O8nqXV5GWF0cay0OOVZJGiskJD2hivkRQNKBo36DNMG12UsbDkn1/KqscEZtWXwgZEzOjSugI2xJPpuj+uh0NrHvvf6ueHZ91SqvBJyW+5t0UH4+ZmdlZ08QcXvjbwnKcOcgtI+0x6ZoIDHTk0bFcQHG/l2iVrpmgh0g0YPg1dWhSZzq6pjKRWhCfgqOdI1rnaZoxRthAKtG9imhZ0IfsBrYNfnmPwSB+H1/SQ7Hyw7o3X0y2My9ZpjZz8cJpp/Y3GGtYLuTrWbZAxO7Tpgm/kqlOzE81KAFOrIpa8GB2B2aZ4HLzaagye5nOJfJRc5fLf5u8AYfxO4MgFuCgmAu+EwVakIJITfcfDZDC3N5Y2iA0EFG9MBt3gdeS0CRGVN0C+OJxn6/APVojc5/m8j5/0q6XLh0rwXVSH91HMwB6WErnhqwe05ILp7OtHgf90/ahGV/edROhTl7UMRD6s1b57br+1zeJb7uBGzyWUhPXdXnPC+WDHVbi502VEK9utprzeTt7MXbpgBuq4ngy4XjMjqrAbCPw24o9urH+keKMSMDntRdFm8XdFZTGemuxZ8J3Txn+Y1Gi2huJa50q99/3rzAmpFf50jjxdqDAsZblSunukNEtMRQKUtCkn61I2qZ9cnAk2snAqLTn3R2xaPH9YmD4ZlRuWNaWJwv+voB4N0s3jsNCPhBYUYzJu61sF6lBjUE3QzUJR+fjE+QYZV9uFoQSNkDJA9D3agk/apd4bI7lIbItGVN
 nMc3omv7
 DDo7PjK/j1siO2FF7BAWEq73KexuGYwgLc/mVzCBqS2i854OfBNH8EHVN+CfzsLlcMUdhzNaS/jdxLxydHpYQ1tkxzKQ6/JufBDEo3rBUR7xZACQS1XujVP9/9aZM0C7MkHjiTe54jBKistkQHBK8t3u/RxvTZeDfZ/9cDIKP5O7IG607dut0Mh4Qp2A06yHF7RqKtQ3iBwm0+evUOqPtAenKREYDj/Hu0tldX79sjmBLlEFdUuJLx5GvycI/3uNKPArhkxB7eGUnm3GZA40dpS0In3xX96+0YsMtU+V9KTrnl6K4TGO0hzUlxETmF5Yxcbcg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 24/04/26 11:11 pm, Catalin Marinas wrote:
> On Fri, Apr 24, 2026 at 06:31:57PM +0530, Dev Jain wrote:
>> From: Muhammad Usama Anjum <usama.anjum@arm.com>
>>
>> Page tables are always accessed via the linear mapping with a match-all
>> tag, so HW-tag KASAN never checks them. For page-allocated tables (PTEs
>> and PGDs etc), avoid the tag setup and poisoning overhead by using
>> __GFP_SKIP_KASAN. SLUB-backed page tables are unchanged for now. (They
>> aren't widely used and require more SLUB related skip logic. Leave it
>> later.)
>>
>> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> Your signed-off-by is missing. You must add it if you are reposting
> someone else's patches.

Okay I read submitting-patches properly and didn't know we should
add SOB even if we are sending it as it is ...

"Any further SoBs (Signed-off-by:'s) following the author's SoB are from
people handling and transporting the patch, but were not involved in its
development. SoB chains should reflect the **real** route a patch took
as it was propagated to the maintainers and ultimately to Linus, with
the first SoB entry signalling primary authorship of a single author."

So I'll re-order the tags as

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>

> 
> Also I only got cc'ed on patch 3. You should normally cc all people on
> all patches. Maybe you could skip this if the patches are some
> independent cleanups but even so, I'd still cc all the others at least
> on the cover letter.

Oops didn't realize my script was not taking a union of the result of
get_maintainer on each patch. I'll fix that.
> 


