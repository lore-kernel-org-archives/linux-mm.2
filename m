Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28AD0C79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 03:50:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35CAB6B0092; Wed,  9 Sep 2026 23:50:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30D9E6B0096; Wed,  9 Sep 2026 23:50:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 223C36B0098; Wed,  9 Sep 2026 23:50:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F3F716B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 23:50:28 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 485BD803B0
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:50:28 +0000 (UTC)
X-FDA: 85196475336.04.1EDE042
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 87E5B40009
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:50:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Jr2kXP2b;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789012226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FFDeRkMdJrtTBEuOUYj1R+PSncWxAsrSSczDwcmPw7Y=;
	b=hf673584c0LZvZtua/0ULdFqU3Jhf39VkC1MBcI4mwKUmU23x6KOd1sH5f26UdoKqx+pz2
	94Sls6q8wZx5dkAyeygxieX+J/qX0XH2w0WlwQ1VknTtm4/zjdeRy/68Tycgk0puwWec4h
	xldFR4EAChlCh8fL1HwI4QRfy6Gw5QY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789012226;
	b=d1aUBYpfnbrfP+YHkdWhFrlzp5toHlxR1h7APtJcByUw4NF/bD8yLsjuCfO+8OQg7Oal0V
	bBDAMGmUXpB1lIblk6TTNWT0l6yE3SddMh1YchQYhmm/xOKi6jKBqYqAmzu8CLPsvSdSw0
	b6GBTh25aeviBKgIs8mZOHOCn2tohUA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Jr2kXP2b;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CC831600CB;
	Thu, 10 Sep 2026 03:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FEFA1F000FF;
	Thu, 10 Sep 2026 03:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789012225;
	bh=FFDeRkMdJrtTBEuOUYj1R+PSncWxAsrSSczDwcmPw7Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Jr2kXP2b6c6JgOXQemT93dXI+H0UX4QrM/Rn5jtkVFcSsyLyKgE0JjmTNnlvjcIlr
	 r9APSb9SYZ8VhAypYkSfgEXkdcWwHOI9YgTPlKlPTdXX8b2BeknzDM3OEWQN7JvzaK
	 iPGEniZlHWHYr7Mwo14u3oGGZBgHpypdeVSiHYWY=
Date: Wed, 9 Sep 2026 20:50:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jinmeng Zhou <jinmengzhou22@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Wupeng Ma <mawupeng1@huawei.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Jinmeng Zhou
 <zhoujinmeng@bytedance.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb: fix subpool minimum reservation rollback
Message-Id: <20260909205024.01f813f93a3307099a0a3b5d@linux-foundation.org>
In-Reply-To: <20260907132055.26696-1-zhoujinmeng@bytedance.com>
References: <20260907132055.26696-1-zhoujinmeng@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 87E5B40009
X-Stat-Signature: xwb55jdaypht4f5mpdp1tcyhmr755kc6
X-HE-Tag: 1789012226-218535
X-HE-Meta: U2FsdGVkX1/aJw1P6l9/1WDrLYa5+0S3DAF5OxzEcSTNLOH/nFDTlU0sZMQw/Mgp/Wx13gkFTXa/pAZsIFpJee4G78hMSSa2PzTQ5sfdVsUXGmJAS0pY9SQbxeoW+z/+XDhuUHmTxW1YRnp88eQCy0gh+2K3P7aL3deFIG0fqPBLPSN24UAcihCsh2Jhui7gV/D9yNOwsd7uQAGxjC1b3PCUK2GpIfPKDgGewLRxnmBP0K0VPAWy2equ6jWBrxnSxWvnSYoVluCA/8cFFqiihoUxq2gc/3mFqZV0/IDuEkIz1+5bEXY5A6YlduIeV5MfSq5ZfLwv6IKdx5VUvwu0AsjSfwABh0GDjRj9m9QjklBtZ1QpyzO4un1ciFQKS3ZIQUGOS8CuKTt/p8zI9qIAyudt49anM/C31cZoneXOqszjCExm1H1co2Zgqs4sjCAcR5+USVwwc85/3dJImm/wvSGcwCec04zOoeTi8+/HTBgbfmvQWgdy8kQm8RUPdUMf+aj9rOiDXOo8rGsSeXk0Zj+S2zLSJmM9tcfCpEzvZOLNsc4Fk4sV+2y/qNxayJiy6Tb3ApKl4TChkP3AlYz7VkbwAv6Ztn35GhGhVY2vnNSKMjpX0fv1DbNHJivtGV0wKn0+u9QUH2YwJEhp3l6OVKnPDASsUpkyU1q1pyReThViWcnJvGDSKfPDdcvN+fouubMdrTlhNPP7Qh2bIcY513Q2T6L5zwBrAzKoRdhwvp0DsrsecrmDWDZcpPJQ+eCPmkbRt0Ziz8KF9va55Jgg4rYY/Nqg4k9amVmoCPmxtDPw8NAXTclg3TqpTe9WXZRegLO00mo7heXr6TilSymCspw2EVSCHbWtQyIcs3aZsbGlLBuy14+XcZA0aR1jXNSPcaL8/1jw03yxXeIqT3MgOveWA2lSxjF5ieh4fEfNIbtjNMLu/fSGZdn10+S+LWX7NpoVxkbZKRrdCfewmO/
 f8I55MwQ
 pNxQSil2uD9JcRK7JbxB+Q+4wCWVoJ/M/1i5fUvWiglomcE4MhLG1wyHN3IHa2vlfj6ZiE+ITmcLGjbJ1GEzuH/ZQGlPA2PLYNDSDI7aSwTO5XC9dwHYc0m8XsLsewh23kkpQak+cXkKGfmZbTER5PitfZFpIJAJsSknEsgGP+FHKioC7uA7uCRff7XZ3Ql+Xgy2q4ZWkJLhqXQVQC1wOZuwqumgqUtnu64z1pUa3BqiJnvbEevDAmk6pumboZjVNKkerLQav4oM0w/sWfrCETADGaOI8grrSOlO76L8qAVbUzUGfaOsT3lZx/L1cRN+FtiPbEQie2gqWCyLIokor+nmMDcExp31Pvzsb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  7 Sep 2026 21:20:55 +0800 Jinmeng Zhou <jinmengzhou22@gmail.com> wrote:

> When a reservation request is partially covered by a subpool minimum and
> the remaining global reservation fails, the error path first calls
> hugepage_subpool_put_pages() for the subpool-backed portion. It removes the
> failed global portion from used_hpages only afterwards.
> 
> hugepage_subpool_put_pages() uses used_hpages to decide whether rsv_hpages
> should be restored. Since used_hpages still includes the global portion, it
> can remain at or above min_hpages and prevent that restoration. It then
> reports the subpool reservation as releasable, causing
> hugetlb_acct_memory() to incorrectly decrement h->resv_huge_pages.
> 
> This was reproduced with four 2 MB huge pages and a hugetlbfs mount with
> size=10M,min_size=8M. After a successful three-page reservation, a two-page
> reservation which needed one subpool page and one global page failed with
> -ENOMEM. HugePages_Rsvd incorrectly dropped from four to three even though
> the subpool minimum was still four pages.

Thanks for making a test case.  Perhaps this one could be enshrined in
a selftests/

> Roll back the failed global portion from used_hpages first, so that
> hugepage_subpool_put_pages() evaluates the minimum reservation against the
> current usage and returns the correct global adjustment.

OK, I'll queue this for testing and review.

AI review might have found a couple of issues in the nearby code:

	https://sashiko.dev/#/patchset/20260907132055.26696-1-zhoujinmeng@bytedance.com

