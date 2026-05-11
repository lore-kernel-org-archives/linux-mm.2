Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB34ECD4842
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 11:53:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3731B6B00AD; Mon, 11 May 2026 07:53:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FC5B6B00AE; Mon, 11 May 2026 07:53:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EFC46B00B1; Mon, 11 May 2026 07:53:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0ADF96B00AD
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:53:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A4E0E406F8
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:53:16 +0000 (UTC)
X-FDA: 84754978392.30.B34B33C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 186A2A000B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:53:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d6of8An4;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778500395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fA83Q2DaPneL5epts3/p93QFzKyzKFKpGeKnTELT3B4=;
	b=KuQY/QBJbYCaK31D2cNMkhIzvZdKd6aO4DUEnRIFsRrMeu+NAD+FUMLFAJb/aysty80J3x
	NIKCvTk5uKbIXc6fRt2Av5R8tqC/BgqSRQhWzPBQCV+Ow6BG9Fkvqu+MkDXYnoHyYhVod7
	7Z03Y4YNGV0vlc2oGz70LgFSEvWmn3Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778500395; a=rsa-sha256;
	cv=none;
	b=15UZiwTTrLUqwggAjZ9OHfPXaXRJLZhDvVBJHNTA3614PGHkyDPmBQht19UQVZPtVgbHIP
	dqBUqv9vI2RB+QucmP96xk0WiXZNm/zjb7i6hSiiE3b4XjiA2F9P9ttI791EgYKq/cJ35M
	H7gYbC/vI8tt1WsgbsJ28HbYqXw/GmY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d6of8An4;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D2DD60120;
	Mon, 11 May 2026 11:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83047C2BCB0;
	Mon, 11 May 2026 11:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778500394;
	bh=2/hzSY+sORkQ419Yp9gOXgQACkcvdIiFkmQSB5IY/FU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d6of8An4tXOdeGGXsrQSL2fEmWbuR7PSZSU/JW0UIluhc21Jb+j4Cb9ZYZROG9o1d
	 yAoXXjQF7stp9bdT6X+t7SsrdWLex5dYJO9nCn6HyxH0tPUlndngbEYC8D0CevyvNW
	 BBtK19ydbFfX03vmJ/MX/zHz4PddrkM0x5kZpbSlWhft99m1aCv48oLnAB8OzbyxG0
	 XmND8kYIZpK+wMKNh53fLSdeZ86227bKjkuGtF1SDtYnAd24Z1a8FDPC3tAvmx8mqz
	 OsAwE9MyjYt0d6NA9mhCpKPO9ROmMkA4HHYf+YDJhgiF587RxU2aS5HFXW5RQszvOR
	 slW+U/BLW4+og==
Date: Mon, 11 May 2026 14:53:07 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/12] kho: add data argument to radix walk callback
Message-ID: <agHDI-NdI_AhslBJ@kernel.org>
References: <20260429133928.850721-1-pratyush@kernel.org>
 <20260429133928.850721-6-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429133928.850721-6-pratyush@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 186A2A000B
X-Rspam-User: 
X-Stat-Signature: 9bi9enchwiadc7km7ochg5rd9x3cci4j
X-HE-Tag: 1778500394-855293
X-HE-Meta: U2FsdGVkX19iTk+ZR2BDzuEpujUIFKMjGVBQ5pZJ3JW6mmwesBDmKcL60ZYXEAwI50yr0BNlYx20VLDWXuK6NdgcvWWUBG2+IfWuCv/qkIL7H3V78OrsxB+/F8OWEjckbDVMXf8tEGA3iIItPmIkCt60aftjdFCNXurk8jqc2wU4HeO2SYsmzewp5TPbrm+vYPqNKjNojYq83/g14FpX7mdho817SppIW9FUfimaYlpNZbcQwWHWRcBIvngkHz3b9uzGq86/BXxFMCHrdIbumLEEBXdtiM1HGXzO5CmfPSkPxrV3f8N6VRvAIRk3LZsfmyj/Fk/XWVMXGhWxeoL1XnM0/izemTC+XkmL0jCiq0GDo2PVaFyjKOBTX0Fp3lJRhksdm0Hx0ZwUtJkidWyYodwmX9j2FKxLIMHdUfT5+E37BKGj4XhxRgPJLUHuUKWW7sQwJvaFQm1b6ytBmRZWCA2rdDUiTmF7XEIOzkqapqGmdnHC3u96pn7jREr+lw0BA1IBQz7b/Q79pqm0dJPjvMWHGjhAiOei3rXKScFvTvtBPRXcm6IOI6lfDQahme87oUI79GlbNi091ePQShGhWuPopbYQedwC8ZCCJEaLnw5UY2w2VPMJu//CUXeyyG5MIMu1GWFhp3DyOlBqyc8lb1ajMgjcQUsPnZBYO2gNwqDQ7CsOSyts8Qt3qihzemXk43llU485HzsekFfy9OudjS+70DUl9ORU43HILBi8QFX0wBVICCIWw9iAbll21qTM1HKZAoyxrwPXL7OAgX7UK7Mbrb1n+HKvz9OeKF1ka/jiK3w9taXrlsaixrQ4XQmH9IEMnBAtpWussB5LrUiI66l+o5icCmdi/DAFWODgP6DW/l9Y66OPF6dfHsoUHvi8n1o4NAyhJqVFb6YpzhFrxd53TC5rZ6/pX7H4YkfKzu2Qh2YL7l7JwbrCE1XYsK05OVPoAIEbz4Kge5WF2xL
 7G/0TcYk
 YjokM6fqxnylNePG+hVL8l50D/GhwuIDmUwrOo/4pdD2i09AzQS9qRfPgWujjPAGt/XPheZsbzVBF/2t8hi1nLObZoUOG7gWIrHx4hUDNdywyR0s72HC3eKQ7SZ8g8zsLYOcSGz+6xV1qdSSAJlXYpn9MS1oR8yiu9/ESgBarYFU8BPYhE8dhaMyiz9Vy2mCmKP5mS2OlYJVoC0KQVNMfvRFt9SZAo3r3wGVZDIyWvYPlHW2L0os0gCi1jUjJrXmDSA4xpV7SkBcNPbZr7b3LXN6itA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 03:39:07PM +0200, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> Add an opaque data pointer argument to kho_radix_walk_cb_t. This can be
> used for callers to pass extra information to the callback.

Nit:  ^by IMHO
 
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  include/linux/kho_radix_tree.h     |  8 ++++----
>  kernel/liveupdate/kexec_handover.c | 24 +++++++++++++-----------
>  2 files changed, 17 insertions(+), 15 deletions(-)
> 

-- 
Sincerely yours,
Mike.

