Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BBCAC5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 17:26:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B496A6B008C; Fri, 21 Aug 2026 13:26:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B217F6B009D; Fri, 21 Aug 2026 13:26:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5D846B009F; Fri, 21 Aug 2026 13:26:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 81FB66B008C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 13:26:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A0B82160182
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:26:35 +0000 (UTC)
X-FDA: 85125955950.09.E39A0CC
Received: from outbound.ms.icloud.com (ms-2001f-snip4-11.eps.apple.com [57.103.73.191])
	by imf31.hostedemail.com (Postfix) with ESMTP id A396520002
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:26:33 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=me.com header.s=1a1hai header.b=GzemNFnq;
	spf=pass (imf31.hostedemail.com: domain of ferran.duarri@me.com designates 57.103.73.191 as permitted sender) smtp.mailfrom=ferran.duarri@me.com;
	dmarc=pass (policy=quarantine) header.from=me.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787333193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=77gzmaol/r/c1jeJwxUuB/8aqkNE9WTFawaT71tB6Ns=;
	b=20BbTLsX7csZ3AerGjEx6zVrg3P12U9dxm5AHX4o+FY5wFZC8faIHdXxL52c9sUvGzm1OH
	tWI9fz8CWEPSdTCnX32PSnHeWSd7Opy6HTz2XkM9Cdy7kIjUhYy4dokIUwvLaZ4DyWYQw5
	+QY1+F2rNbObdK1lLMCyYVXVQCekWnY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787333193;
	b=PQ4eTIOTG3x5fK5LmksN1W85NwwqG+v+78gJjP0RHrA4dHIWkPUHJbJdTVtVNIggEp0k3l
	ggO5iOeKsOQTqyGRUCxt731b5FYE+08a4akQ/o27IaP+jUJBlOxjElFhxEM6ZRS33csZwP
	WmwVqQvzn8KRWBo8LvyrRTCoXcxJUPg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=me.com header.s=1a1hai header.b=GzemNFnq;
	spf=pass (imf31.hostedemail.com: domain of ferran.duarri@me.com designates 57.103.73.191 as permitted sender) smtp.mailfrom=ferran.duarri@me.com;
	dmarc=pass (policy=quarantine) header.from=me.com
Received: from outbound.ms.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-3a-20-percent-2 (Postfix) with ESMTPS id 72E1C180022D;
	Fri, 21 Aug 2026 17:26:30 +0000 (UTC)
X-ICL-RepId: 01a0255c-22f0-73b3-b759-cc10303bc6cd
X-ICL-Out-Info: HUtFAUMHWwJACUgATUQeDx5WFlZNRAJCTQhABkMAWBxBDkkdXwVaEhVdRVUIRRlTHhccRgxFGVswVB0dDlgGEhZdRV4IGQhdHRkKUFAGWxIYXBRcUFgeRhJWDV0JGQZBXlAbXwJCDxwTVhUTHUMZDysISgRDB0UCXgslEwlTVl8VFxtcABcGWxQERAFdBV0CSAtJAloFXQBDF00LXABbCl0IVVUIRRlTHhccRgxFGVswVB0dDlgGDFBNAUMICgJRHFYNVw==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=me.com; s=1a1hai; t=1787333192; x=1789925192; bh=77gzmaol/r/c1jeJwxUuB/8aqkNE9WTFawaT71tB6Ns=; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=GzemNFnq/C7odG3+x9acJ60eLFEmL32IKFwmcSpHpGf94tecR0qWxhWZUTxiXbrmmAcZX5Mck7+qKyhkkUfP/5Yp5j/rfxzjvzK58oFik7jvoe9UeThHM4Gf0QQuvQPGUxf6iL7pKpjLUd1FT6OdTOIcIj3h0ZpqIyOjtFAXiIrnDV6XS2Xv0BiZS2PlkuhpOJcix5Ioz4OIcaNxIjDiRI3ciRLXZOZEiXtkAd7viQqHJ/u9s+62rzawmiOAS1iiNcDlcW6Iy3IMz0sGJVOMwyviTAcpA1gPCOthNUQB+gQrJZmrBDxwJS13Ib2rDR2o4SOCztH24E8GHCTqnUIbMw==
Received: from ncore (unknown [17.156.208.39])
	by p00-icloudmta-asmtp-us-west-3a-20-percent-2 (Postfix) with ESMTPSA id 9B842180088F;
	Fri, 21 Aug 2026 17:26:27 +0000 (UTC)
From: Ferran Duarri <ferran.duarri@me.com>
To: Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Barry Song <baohua@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: thp: default defrag mode to defer+madvise
Date: Fri, 21 Aug 2026 19:26:21 +0200
Message-ID: <20260821172623.581708-1-ferran.duarri@me.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aoh_40ku6lQMOUQb@gremlin>
References: <20260820190825.221308-1-ferran.duarri@me.com> <aoh_40ku6lQMOUQb@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Info-Out: v=2.4 cv=F+Jat6hN c=1 sm=1 tr=0 ts=6a888a47
 cx=c_apl:c_pps:t_out a=kRaGL2Q7qLiahLf3O6OaIA==:117
 a=kRaGL2Q7qLiahLf3O6OaIA==:17 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10
 a=x7bEGLp0ZPQA:10 a=B9nqV3Rn1-QA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=g8YYSf5RqXWwD0xS8LYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: nKQ66M0MKXXuxxR1TlJNVpdEZT7ssZbu
X-Proofpoint-GUID: nKQ66M0MKXXuxxR1TlJNVpdEZT7ssZbu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIxMDEzNyBTYWx0ZWRfX4EWNakC1IInY
 ItM9sOO1CMgN9CLT94f8szncpefW0SE4IzP+VgEIAORhjf/9ukvGfZerjOBWPxuggBxQzmJA6O2
 lYTAMp9zje2p4RLhVSe2J8bqXiXV9FbuYGDUuTclR+MHSEk4vaWRDKrEoUmyttCxWcym+AhBaRc
 Ht4N4LkOHbHsJy6bdji1XWHw5rblA+rxCWDk1UyHEwzSQqVdmcHVdYAJ1TnypdyDEedXZ9F9SbD
 NiM0WpGWZnMHsEBdp4TwyeK7KhIvYSHemY7IsworFpY4CTVUwiwXG73Peq9lujISAl7CNjwDA6w
 gYfjbyNrOOOwF4ilhIqQvkcUmeO2a0ErC4c6VTGCnRKPt+QEYcwo/fs+ihhufs=
X-JNJ: AAAAAAAB493Y7MFGOpHMCHxoPqDz1FBOaHZWTC4tPqgKr2lrKBuxB+0rqFJtl5OzuJLenvpxdtmOX5Vq94GQC8sGXq+TPZnIyNBcWFVCwiCRD0AVhTgnRIu399oSf38+q2qzbLR8AFqJenrgGa7hwiZT3nNvTci6apf7MTzCiaw/EJa3bhLvZOb55iqf7jcwtRJ6TYW2tuDjoPkXyx961AvWBNBhTG3jk5XdzYHRkY8SNCywxEevMvpz2/kH8LHFzJtwr2L12gwBVV8SpCMMeWIbQw04SmXfex4A4K8oUvCyDc+PTijXJBE+ru/VqPNrVPrqW8g4nKq4LGpRyCCs+ff5NidKfgzjSTpr2DWHs9RIuibRhAK/Qyug6p6+wwIBaGmjI7INEAjw4TLHgHDWxfViPU8ePOMrCfP/xiDBI22knYQyfJogAG1336+WfU7YWELq+db4OO/4tmlVvLS1H0EWfvtIPM7ZRdxr8ch3yziKEW9QlG7KYbl3WyCBKY1Ilcgo/AGTEED6TjMnYJ5QrxPxEjV+/finflEpVGYtJUleH4xHri4a+yvBD2CaDASV22YjlRnZAklarLfHEhc0jOdSbBS50roBZA58PvgcyXlcjWI5iuwh7w68BT7dPE40FcLeCUGQrelxlFQRispqR8MuvQAu9C+CmLZWbkXnmeFI8CSVTW8DmPUA2Ttj0m+UlsgEUy7ZW5Z59VOAiZpny9FgFRZQ/p6NmKJadgXYK9llEzXOs+7xQO18rbjkXD25C2L8QZ2qNwlG0MLMYnDdJ4fYeyi68/AkCFryiSAVO+3ausGQ5C9C/aBvAm1262LvjQaZSBbjN8xJT1UiuQOFcca0LT9LqRwxGkv2TUZVW//9S/gWuoD2K2XVoNIf9LwuuhN8H38oIDF7PRtr5lSYwRTYVpcASexUzAYCGZT+7r8Csx9TeIhuyLidIf3sfF9AV5y62xvGxhXwpYeKeHE22ps
 T0UKwct4
 nul7kvBdYl29uDwSFsgQKg3ABH1kAacWbsR9eL6swhl/NrAlTxcmK9dHvAQ7Hr2+STsw69v5XPdVMGvobm7fqsXCzfb4FInF8E4lYwnNsRy+/X8L8JyBlDOGdYHaLh4UunFUnov+wwsLmQiggqueMVKc0ZXvZPLxX8AA5ITI8KbgALjcG6oStCBHxrjgxSmpJzI6vbk/dVvntkvr63LaZ/pbUZiCevr7gvbxOh/mbgwBmA2Ou4NZeCmwtZ71z59U03HWul9RTm7bgIVLM17UjdF6rUvd0pf7fRw==
X-Rspam-User: 
X-Stat-Signature: k354ddjm4zpq7wdm4riudwpm5rky6b8p
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A396520002
X-HE-Tag: 1787333193-87047
X-HE-Meta: U2FsdGVkX1+/DLYs1qvGC2CEeonZiWKxlRNTRUXhui1OliWUvr4Qj3hEGyryeP87YuEpiogzT/5ytzu9BQ8eBnFvFhGeURfpqjP1gsk9rX6JK2O/mxSC7itsjzJeSpySibkfmWQDwgpJLzva/bsVACMAGlzXnofgD2E2MJGi7wrQIR1Zwk1tBtQ0NnybaB4CXL9Pbz0pXPeGaamPrg29uq1PJ1RyHXYzn/pICnKuabFipYXFKh1eyCzoHoAZdbtcZnn36BTXAGjbBIR+sd4xUqxt34BzvCeikgMBgmlkTaRZtrLUgstZ3L9tuqMn2UnHruJsuMThJrVk9AkBYaAK2GQwgBs3rNYc9e7aGdrkN7SloD5ZoFQzrBPxbWfkuAXUsTYHDBZEw8wiDBGoTAey48Nu93XLIIlzee9Sc9mYoXtmZX7pKs7rzbGqfjF/79PBZUwwenZ7BUMHZ7C6PXqj5CTm1xuwyC2xir/I6CFTJ4iLNLpRPXiuQ2s1/oieJqtATHgZMGcWXN+/0QrRhezCn2J6WoqwOOaMjWnDnDrXP181ghL6mmrnSYMSot6ddSsXM0TTWvTvIP9eW2i+fCoI+R1LUUMczNK6ArUHwsOFKw8db8lfhfz9SkL/UWkKC6sMS8eZ3inZEvBgPvV3Z4Z4xZGC28lf+PDFJ2kKsimExkyOXspAoB/rQWOh8Jx/Qv4M//k5YTy7DrNsu5xJ8vlaaR25/HQh2Jj+mZt+Sn9vmlHW77k8/LJwWKJuNaGisnnfgubjKwXwO5RjrVJim4Z2hxdFVbKHaDY3y9LrA4AkUDonqb2zsU6K21EwE5GYRSEj/QiydB6rORP846cIAXtr+nVL13cc4OE7g5os9NbyxnJUKShgUFUxGlNab5sHSgEP2hMQshc4OSThG58QA4+Z0x1MCGv1f9z0dfKpbPcrcufomK1a4foTfismrDLagF4pQMFaPls6tb9KMXk7WHF
 iMalC48X
 a9uhMsdbOvtMlcK0Djeuwa+eueYTnYLYryAPisMhqtMNkxynTwAfoPAUi8VSR9rUbjhzHPplIvzpgUQp9kBmXkYeKl1NasEai57zWPpEENLUapbUx5Cff6Wv/Ra7XMBKhLSoHzPHWGXbsHMpw4pTt/lxghG6iwdr8dhEFsSCCD2PZgIhAc+hHJZQRCc3SWFUs6fcJABnuwYN+lPIlTtdyGFUUNymaArohr7ot9/iNWqrS3ekZLKg6+0ilC2fgw5KtwFm/jhGx3Pe2jY4USFidFmgGsW9P07NHLs9e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lorenzo, we crossed. Yours was 18:53, my withdrawal 19:10, so this isn't me
arguing back at it.

You're right, and so is David. These are patches I run on my own
workstation, they aren't settled yet, and I started posting them to put some
order on the pile. Wrong way round, and I can see that now.

On the process bit I should've got there myself. Coding assistant on the
changelog and on this thread, which generated-content.rst covers, and no
Assisted-by tag when there should have been one. Next ones will have it.
Reading both links now.

Patch is dead anyway, I had vma_thp_gfp_mask() backwards. That's in the
other mail.

Cheers,
Ferran

