Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D08CC61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 07:58:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BD8C6B0092; Wed, 26 Aug 2026 03:58:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86E7C6B0098; Wed, 26 Aug 2026 03:58:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 736356B009D; Wed, 26 Aug 2026 03:58:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46AF96B0092
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 03:58:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C135F402B8
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:58:01 +0000 (UTC)
X-FDA: 85142667162.12.FE7F90A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3EA14160006
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:58:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i4XP55Rr;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787731080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hmpj9TgfHr39DOeJCr3cPmBxSCLXnUOZroFpMszuCEo=;
	b=lzom80AokBBvIMlFQM3FyXC2Sda91QKHC0D6Gz3Ubz//aXmz2kjBnFZ35/cntroJhO2lVT
	WZ25lu7lRbI4s29Q0butWy7Pv8ScrFRhermkWBubyfBmf7hfYSJn+/p3mIihk26Hcw+AqF
	RBCb02qZnpGs03O+KQOIuocBzr3D3JU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787731080;
	b=ZUr8F1dhgWkGUnevfX6xRSC5Cyh0DatWaqgzpZ2ixHsRWyXX6yxSwbavNbTk7gJ/p3+3V5
	0T35uN1Nsy+tD572KNvB5s4wsbAfrIGEJbnkrPDCW/DdixBQZKF7pbwVfuqNjVpm67TS83
	UptcDPZVBN8BUPju1BSGlA+2TRshQsk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i4XP55Rr;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BA713600C4;
	Wed, 26 Aug 2026 07:57:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E561C1F00A3A;
	Wed, 26 Aug 2026 07:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787731079;
	bh=hmpj9TgfHr39DOeJCr3cPmBxSCLXnUOZroFpMszuCEo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i4XP55Rr+Zq1oMAbamvhLn2jYWDSAxn48TNZaZEz5P3ZKmIE1IX7khswMhbPdSWE+
	 uhI8Lv6erPUMa+ScYtxq0ZO4sXD9PNTlGvcI6S47IlegKuJymUVmtxe7c9Hn8YD9wR
	 Gg8zF+BV8xqN77G8FsZAiWg26oBPAZMlrEughbpdYMmjwbipEp0G94Z9HbSASuiyE3
	 4OjEZc4s1zcx/aHozv6IR/Us1jec+P35irhJA7po2XoY65iUm/nchU+0Dxtx8V4wEl
	 Jktjq1UDtKjFJQxG10lml1FZscJMDI9z/PjfVNiJcoQg7Io0TL+QuNMsy2ImoTOXtq
	 KP71dWh/Adj2Q==
Date: Wed, 26 Aug 2026 08:57:51 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Daehyeon Ko <4ncienth@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	"David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, 
	Stanislav Fomichev <sdf@fomichev.me>, James Bottomley <James.Bottomley@hansenpartnership.com>, 
	Hagen Paul Pfeifer <hagen@jauu.net>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/secretmem: properly account locked pages
Message-ID: <ao6b7b9AIUPWRTkJ@gremlin>
References: <20260822-secretmem-accounting-v2-1-fe445a7c6eb1@kernel.org>
 <20260826013948.1325213-1-4ncienth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826013948.1325213-1-4ncienth@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3EA14160006
X-Stat-Signature: ctqzenyctn3xit9pc78ct78qjt44pizz
X-HE-Tag: 1787731080-677393
X-HE-Meta: U2FsdGVkX1/N2vxEesG6B1OYmsC2/Ib3ivcxlImvbD8yvR7XUkfPm+f9jODZgZN2bTZFFawIUpfmxPYrjwbwdbGU/iyHnm1vDly9QzApJN6ASojnaV3R7d5hd689q+qaJN7QRItszF9fl5aN3r+1aCc5c8FKhciDCv11cojcyY2LpvdzOHBmquiVn39i77QlleskIlWlFVpSa2UAVZVb2WdfwTSgiNC8e0xQfs32BL1NmO3NrcVZDQ2+DVTZJjL+WXoCqyK4I8TMhED1T1nm9XVowgvqkkmJIoBprBcMguBhxJyUiCd7EaEcOOXWVpK0wQanu0rcUCjMwx9RDZJj2BJcX8lpR7/XXPnzywwNycN89rKM/5GBeXPzCKOvzIy6kdh9Iez4Y+aOuQ8kw5rHCCsvlDdJj68C7GIBvS8+Zn6K9f8MsXF3Xzbb6MfHUZ3UaBm0oeidB6Uq4fyJcPzg9oI9GerZ3e7DXjoRyqEUjhe7IEaqda2uX/G72KotDUcVYw1j9ouDiO4utDP0ZoVtIlwypY2ZpjpSRayXdJPqpuB9iNACGPVSA0fOJngBbAelf1a+HBAQ8Cgroepy/30KwoGTraoX4Dt9IMCfSJn0dKcubopHZXB8vEpHAMvKcTJ9iHj9DwT30j+P37MMhmY7qWi9lLxxUhm2gUsSrP1pWrdRw5xKlg1KczgFfbDdd2y0QzHKY+PtNRr4yPLDAGkz5l2Dk6cQ21YThh+uEfrgGR7RR/FhJgVZacZ/sGO1u1AqFQN20Qn1HQ4+sTCqc8G8ZTYe1WhE2cTmYPlLRxV/nYVgPtj3GZlyq1B3/1hBZKj8vTVFiiRR/F7RYZCQTPMi4vwWf9UNm/WyuPyGbVp7fvZ7an9dUKHMJN2bl6ZhIU3KuaprWnwdW02sAIOKd8diCZyYmbY8bAIPjSZ25TZUYhJwRNNgngej744jeFNbU4qFmodUxve1U+qv9YKRG0W
 lRF6EENb
 asYrE56gedjbZ/aIRK+lhcnyv22D+ETaTEZmTqhQNenf/pk9W3sDtmeMGvUUjKv3O2iWtNJH/VR1ApHg4Tkg8VVbFwL/PMQxui9/UsiugOiJdwwOKEm+r8YNupNWCRjozl7gyeLmUzR12g2TdWnOFEKQeq8HS5WW0pVB8sI9eDzWSzHT5oIrBkhenmvzg1JaxCKMzbg0ZCco6SaU1bI+KKm/hPD71JcR6AzEwQJDHtVwo+gXy0JKKCzAgaHI+mzUKn0LF1vW7+Nu0FYui94Y/KagrZer/Ih9FG8fKey/nsIwj9d09DK1yT7dUfZU6E+YEdjhwN10T/m/7s7AmbTcyt5aoAsDAErHVAhrS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 10:39:48AM +0900, Daehyeon Ko wrote:
> Hi Lorenzo,
>
> I tested the exact v2 from this Message-ID on its stated base with an x86_64
> KASAN kernel. The supplied memfd_secret selftest passed 6/6 in three boots,
> and my accounting-boundary suite also passed in three boots. I saw no
> patch-attributable KASAN report, warning, Oops, or panic.
>
> A v1/v2 differential also confirms that v2 fixes the CAP_IPC_LOCK creator
> delegation issue Mike identified:
>
>   v1: CAP_DELEGATION creator_cap_ipc_lock=1 receiver_uid=2001 receiver_pages=2
>   v2: CAP_DELEGATION creator_cap_ipc_lock=1 receiver_uid=2001 receiver_pages=1
>
> I have one policy question before adding Tested-by. With a one-page soft and
> hard RLIMIT_MEMLOCK, a non-root task whose only effective and permitted
> capability was CAP_IPC_LOCK produced this on v2:
>
>   CAP_ONLY uid=2002 cap_ipc_lock=1 mlock_two_pages=1 faulted_pages=1 raise_hard_rc=-1 raise_hard_errno=1
>
> Thus ordinary mlock() of two pages succeeded, while only one secretmem page
> could be faulted. Raising the hard limit failed with EPERM because that
> requires CAP_SYS_RESOURCE. Is this divergence from ordinary mlock() the
> intended consequence of removing the CAP_IPC_LOCK exemption for secretmem?

I'm not quite sure what you're getting at here, as stated in the patch
CAP_IPC_LOCK does not bypass this limit for secretmem because the scope of
the folios is greater than the process so a process-level capability isn't
suited to bypass it.

Also a typical use case of secretmem is privileged process establishes,
then passes fd to less-privileged user. So it's relatively unique in this
respect and therefore it is not enforced.

The idea is that those with CAP_IPC_LOCK could raise the limits as needed
should they wish to bypass.

>
> I saw the planned selftest split and cleanup in the follow-up discussion. I
> will retest the revised patch before adding Tested-by.

Thanks!

>
> Thanks,
> Daehyeon

--
Cheers, Lorenzo

