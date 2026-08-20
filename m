Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABFC5C5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 08:40:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A8E46B0092; Thu, 20 Aug 2026 04:40:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 633A66B0095; Thu, 20 Aug 2026 04:40:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5495C6B0098; Thu, 20 Aug 2026 04:40:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C46F6B0092
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 04:40:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 057FBC023D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:40:46 +0000 (UTC)
X-FDA: 85121002134.02.3A7F0A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 71E8C80007
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:40:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o001WMFQ;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787215245;
	b=BjoXnEQ0Lnq+D3zW9sWSNfR8l8BWS9RIAkyLZ87NqkIu3iD/dvLiYoGnCW0xiRxpAwPl6l
	8XZMzKCEvkaFHPyqolXNvvDaoRExNv8igbbOXYbinYCpJCg+hy30haLiQPDpsp4eLz8de6
	GpUAlKXYmbcZpkNY4Bb5MEneWfz3KV8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o001WMFQ;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787215245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ThRyJw++CdeyaPAZ2X9cTT8FFhEZ6Jw+cGR708aO0eI=;
	b=oe4ENIMJLf3Sgsi35yoN5ytYycaETdtDjmjLCgtY7iK6AsBXTkaAiYtizbMKunAhiNAVhl
	y6w3arG9msJD54bOEUY7Uw62ne+xOApBLL2Lt0cZCl8HGC+swOX/EGbEP+Udv/f5zVfk8U
	I8FRzJ6sasyhHLvpEBv+oMVQ2rcL0SE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B777260AA9;
	Thu, 20 Aug 2026 08:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293471F000E9;
	Thu, 20 Aug 2026 08:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787215244;
	bh=ThRyJw++CdeyaPAZ2X9cTT8FFhEZ6Jw+cGR708aO0eI=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=o001WMFQBfLGgBMtD907Bv3sgzzEwmkjG+ldB5Uyp6ne0krELB1HfLELHJ4ZJYgKH
	 kCyGodfbkUNIt2v/U9+rZlpB9Vm6dwshS1nLAVU1znEw3dCKwJqVzt+G/oVqJdSonw
	 7mOkI63H3UUsm2HpWlKHyMzYWB6JlJ7u6VF6xZDYe+QA+aaOaoCYjrwcrCT50jk3vV
	 uWKeMECX78WdrRILdpQAG3c8yiBE5Y4yVA7ZxmWHXe6SzzowF+WylaTWnmXWT5lGqg
	 8igMWXaQ2uPNOcEafc26i4jbQltVUKDuD6QjFOT3yKdUlhqALYB58X+cj/ilGK3EFJ
	 YS9Wol9kX4C4g==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 00/19] selftests/mm: improve khugepaged coverage
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
 nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
 dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, 
 liam@infradead.org, mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, 
 shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
 vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, 
 agordeev@linux.ibm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kas@kernel.org
In-Reply-To: <20260815015901.1236937-1-kirill@shutemov.name>
References: <20260815015901.1236937-1-kirill@shutemov.name>
Date: Thu, 20 Aug 2026 11:40:35 +0300
Message-Id: <178721523515.2799959.13983972214223576467.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 71E8C80007
X-Rspam-User: 
X-Stat-Signature: 7k3bemgwr5df9k1rccnu77bdn4kqkhyu
X-Rspamd-Server: rspam06
X-HE-Tag: 1787215245-961288
X-HE-Meta: U2FsdGVkX19K/ZILawekShx8uf6fLtJ9P8osubbzxoYWSXxBf5fyBIrO4TJOJu2Jv0jNOzw5WKFJGSfvg29qSuevp2nAjuTVq4Qwivu17XQ46AV5h18n2WQl/dVOqqTiq974Tim19c+BnBTIwR7RuwDmZrwRZBOzVgRxPpR1S96REdNexe5mR+EBR7TVQVqtQzw9HgEo/2se0vzLziojaAFe4Gv18KwL9ibG1rVaAnMIMf+1UoaggfmqxZTrueBP9iMQfihX59uuajTMeoAB4sdn+kSNwW13fjwwT8i5dF3eAOTHjZZ1ngMUS9Vc+ylS2e4HoEmWBCQw7hETh0Hz0j8G6tyDNAhyWcXFMoF2vO6+sxfNA8xC8LH/5/tUdFVM1t1rDteiztgG91JG55mfs8ZCi7hBKjFDdCMozwbAyCcdj9xJkLf6zHtb+7qGHWEYpuPl0JD1lLpr7zfwwxUrnX9yZ0gwaAFm8hq43Ym/ykmiLKgxX/MrocSk/DUKdCFu6si7QsN8sTVmZQatiNHQoO0081uvOvdZT+zW1xMxMj7DOMx5K3B2u4VNClk/GKCv+rfBwWM2xhA+v4hlRZIpmWMKIfxYUBvbQUmCzK9XhdD8RFvK/WoXQJEFSu+XoYjPNye/Y4wE+BHtqpHkq9Wmjk5p0ypOVAeihjG9zbOVW5U8cP2bnJcgs5jR555RZ55k1dCOAJukHQYXEQyp8tsjfz9xeLMJTZaux42QeDg7SMyT07L6vCA6AvMdfs6eRGqDwfxJCYHFwlCzPh1mkOENYautMsLlVa4smnbABoVqOTJKsJCJ8Y2xZgNDdh89lq8voqpTFywfeQSjH1Lx2ipYdoaPGXG0qYZcFFqnEHVop5wr9Ylnbueodh6SxM3IhuHp3N2ZJnkRf7VQap8+0+FyOxWYal+QUpzLsVr/Dm/gdgA9f/NbDqquXTGn+FJW5v8MO680M0YdyYeTnNiIWrO
 +ZzuWN1q
 4iEoJ6gggMlOUA9fkGN7bUWwnRQzlwu0KP58HmdjrzwRsqElk/b8+V2KHvb1WTFRj7ef/Ypda2kqLFFN13nUgpPB6MXRy1oRSkTRqsWFp4mRPRn2mOzidCZ8TgLIJ7XqdUpMQakHAuJRZ7vXzAANxjviHp+DrLwwmFm4KxlC1ncycANOD6kZ4ZaMSwQXikwE3KbQiCPygzZkF3c13UEs1bkOf2bzRUnFKO2R6n7wJhlO3DqK1ZU48VXEI1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kiryl,

> 
>  - The changelogs are rewritten throughout (Mike Rapoport).
 
Sorry for being PITA, but I can't say I'm happy with the result.

I commented of several commit messages and some of the comments, but I
despaired at some point.

My ask for the next revision, please, please, read the text as if you
were a reviewer or presuming it's a future you that reads it.

-- 
Sincerely yours,
Mike.


