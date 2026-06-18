Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 982B1CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 12:26:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F9ED6B0088; Thu, 18 Jun 2026 08:26:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AA9F6B008A; Thu, 18 Jun 2026 08:26:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 499A86B0096; Thu, 18 Jun 2026 08:26:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 12D396B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:26:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3BBEE1A070D
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:01:04 +0000 (UTC)
X-FDA: 84892590048.30.6200E74
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3EACD14000B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:01:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=codethink.co.uk header.s=imap5-20230908 header.b=wtnf436f;
	spf=pass (imf26.hostedemail.com: domain of ben.dooks@codethink.co.uk designates 78.40.148.171 as permitted sender) smtp.mailfrom=ben.dooks@codethink.co.uk;
	dmarc=pass (policy=reject) header.from=codethink.co.uk
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781776862;
	b=aEGU4kTOJ19/vRnVUOMk6anaEYF8+UL8In7kcvAHK0oRNznsk/sqd1MkOZLEUS5SWxsv2a
	ZXQMvrw6FEtDsn0GSqGRoYVhyWx+428giQaXoHxDANH3QqoQAmMi8jWRhAmaXBYSkMcQKj
	4Yi6NGCqzcLcd4vH7aiaS08pOjqQp/U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=codethink.co.uk header.s=imap5-20230908 header.b=wtnf436f;
	spf=pass (imf26.hostedemail.com: domain of ben.dooks@codethink.co.uk designates 78.40.148.171 as permitted sender) smtp.mailfrom=ben.dooks@codethink.co.uk;
	dmarc=pass (policy=reject) header.from=codethink.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781776862;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cUIDQGjQbraB7GWk21Atx3vElnBKtXw52ZBnFB0BMCc=;
	b=bMlBxBGoy4BHRNPqEZZj41XIoR2TPt6i0w9B22piE9qOvnZBQ5tEVg1TuKHB0Bx1163TUk
	RMDI62IWoK+gbP9xnqwBeHuZ5GMybKO0SxUXBdto5O/SUbk3GfbSYQ5PbwiouWC+ip8/HY
	VOCzgNOprsCPhyzp0jHae3CT9WQ7Vhk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=codethink.co.uk; s=imap5-20230908; h=Sender:Content-Transfer-Encoding:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
	Reply-To; bh=cUIDQGjQbraB7GWk21Atx3vElnBKtXw52ZBnFB0BMCc=; b=wtnf436f4Sn7RMsa
	sB2CPLQkFjFuPiHJXcrTRnRPrdBNjLdXJKJzM5XgfAiV4rJvSXXG1qJT5JKC+s8pM8y1caTanvZt1
	8yvt0KyMuBETtZFZfC6+vwC3EHkK9DlD/ntkFa9ZeKxIaPSWEq+hG0boWvNa4bkYyTJp+izQ0eOgv
	58662RQ1hJ1+bn8SFPINfHqp6WxjmetKl7O123XLLnN2WKaQoOTwY4puyoY7rXJ1qfPe1FCxWmhFF
	GlW74o7R2KghPdgluqRXbm9HXbyspRAtXsUr4Dxx2ua9PJ1bNTp4Z42ZH+MXCvaMOLTYsMczIDeDY
	kieBlQ9lIyrMU2uEFQ==;
Received: from [63.135.74.212] (helo=[192.168.1.241])
	by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1wa9YI-00FGcb-G7; Thu, 18 Jun 2026 11:00:50 +0100
Message-ID: <8d529389-41ac-4d44-ab70-15b52047c3e3@codethink.co.uk>
Date: Thu, 18 Jun 2026 11:00:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: include <linux/vmstat.h> for
 vm_numa_stat_key
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260617132726.1086576-1-ben.dooks@codethink.co.uk>
 <B35448B6-4958-4FF0-8AB6-5464C2D6C50F@nvidia.com>
Content-Language: en-GB
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
In-Reply-To: <B35448B6-4958-4FF0-8AB6-5464C2D6C50F@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3EACD14000B
X-Stat-Signature: xkadk947rwqqihaibnkqaes7crcc34hb
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781776862-448685
X-HE-Meta: U2FsdGVkX1/obCs7LQv//Dmg4TIKn33Ujmpagv0MrbGeTN76ixGmXT76LzyWGWkKjuQGfKeQR6CfWifKQtvOqWCyTKGYXQSZ7v1qdPvm9y62B9w1uDg/ref2W9Q0/ZFWbJEFeT0pIhqKcWlXTkBy0EyOE+MlMccO1C8vY/SSsyu6IQXuzlg5I95MdlRKcVE4RpIFU6ASV+Z5BVnLFzmNAfTkNEDl75JZQPDtaNR+azD0OkXaSkcX5daZZhHeCUqLc2cfJGZGqPV94QRAqbxwQia1DNwkMrULyXSUCqBXnXnIEzd1IjNLSt44xT8C1Q9RsdHxOv75qXXc3+nlpkANj4LOborsAu8AXcpeNN+CbrhF67Yn/y6P2nNzXl54JQGtMkws4OR/2s984C80/inYehK6J279wOhcFFYYxfm6+vi7QQ6PSNAN03P77R4DHBSs/1QTeM1x4mlCfn77IQNpf6pet90npJBbTvvPkJeNTz61utSU2ehvirGo+Y/FtvdH3WlBCcBuKhJwBPKumTbuzXgXciNCn+SjoW7OUWaW/glI8pQCoev5bM4NCFas16GDvS/yqSdP4dWXE0dH8sz78IBXsql9C/tL5BB6cigPbFmwZiWP0izK8P691Ke5oRmV8dLHLQBO56OhLPvLC7yXkzfPpzbKE/KlT14fzCVeTSAEZcs4d5on6ipaT1YKciZOskZIGwTNJgqoGAqsBTUlPxQ1HRF3Iqy6wEZo1X4xTezRdhlg5+YWCvaRX8bS9efsWyxmPmSwOETyUhsosOUoJBxwcbhYztZa74/crxaZkOZzQty85CtJDqpltbxDTI5aZfbD9/H66xlAf+dkYj1cagW3jrEtxZR//4V5/SdaJpX5dTpxdKDSUsRjJwL4QKfagXldoNs3OBy7TIxHsO2Do9LZQGXGVKjMMtknQvlJMbjXQtt3O27UaN5JJnSt/sp89PmcIU2hhkSfHlrjho6
 nnZKpnr9
 3fON9L+MwwlxoiE9pG91K8EbFqSBLvPGy5E9zQOJxJeXTlNj2HBL7mN7r6uKPJKe/kK4WNArT48SpcKY7nrAkPLB95gahAdH+9jufUJZkVmXl0NdVs/WlmN9SToG40zzvfB/vWSBj2+UKrfFzxOx6kwqAmF1yn/Mc68it+sd3qrOs6NrGEF4oJ1WA9N3R29haZtGXgZrxZ2tOZSgiEwnFoiTNeVG2oYLr/a8udmcrDnjurl8ONv5v1fyHLPyp30VmcfJQqUIDLEnJRkkOkHkYMSTXLPaHjlnr3TB/4P/dIDlZPDuaK7QGYk+MQm4eZnc+PCM6UaF6eGy7WxvD82S65+R9NFbk8sAKkHPDCMa688WbLqecCVCYG3H4yVrbzeVJ8fY4Q6UnZoZnp5zwjSoh0FDJQ8KIHE+eFJ3PaP4sEhdnppYVW5G/CXT934YqG+2Qm1nbOIg5QvTnzUGsKAsfgm4/693IkNNIEVP5GBQz5N6dQT1W2zvQsGlqIYDKeA2urHBM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/06/2026 16:47, Zi Yan wrote:
> On 17 Jun 2026, at 9:27, Ben Dooks wrote:
> 
>> The vm_numa_stat_key is declared in <linux/vmstat.h> but this is
>> currently not included in mm/page_alloc.c so include it to fix
>> the following sparse warning:
>>
>> mm/page_alloc.c:165:1: warning: symbol 'vm_numa_stat_key' was not declared. Should it be static?
>>
>> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
>> ---
>>   mm/page_alloc.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
> vmstat.h is already included at line 37[1].
> 
> I wonder why sparse complains and why adding a duplicated one below fixes
> it.

Thanks for catching this, it turns out this warning is coming from the
riscv64 build and I re-ran the arm64 thinking this had been fixed. The
issue is actually riscv64 does not default CONFIG_NUMA which then does
not define the 'vm_numa_stat_key' but mm/page_alloc.c creates in anyway.

Will re-test by guarding 'vm_numa_stat_key' with CONFIG_NUMA

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius

https://www.codethink.co.uk/privacy.html

