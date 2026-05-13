Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B805CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 08:25:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CFED6B008C; Wed, 13 May 2026 04:25:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7807B6B0092; Wed, 13 May 2026 04:25:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 695D26B0093; Wed, 13 May 2026 04:25:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 586F96B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:25:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 005621A0813
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:25:18 +0000 (UTC)
X-FDA: 84761711958.11.D3411D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7490380007
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:25:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fqn1PthN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778660717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CLD48dusxWCJfDzdS6HunkRJyZnZflRZ8b1F0quLtJQ=;
	b=RtWTjJgG2ox3V0zxrmsDqkR+mGdHiJjNPmx9R+3XP9EJM1wEvfEGqjI2kRmmgvzX2WsDP4
	hmKpg9gIqZlw4eGvJWwU57g6kAaO+AF6VvNu0eLQsCBb4bWAJfpsys2o1WDk0Ab387qODL
	zgNr7EBtUE7sB+1yoGcY+/Olb7ZyyBU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778660717; a=rsa-sha256;
	cv=none;
	b=s8P6jFsjEhfGJLkaXSFDDlEF57QRghqOxb00vK61IQhJ64VKKZac2wobhx3DxXMiiwmEHi
	kiT0ZuAILAzJ06Oua9Y7lkNeaOZ3cDS+gedcmzZbG3+E7yaGRqNVWTK0pcaNCqkiKS6/a1
	csmas/a6vz7TSpxCbjC0s23jkljkHuM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fqn1PthN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D38C560120;
	Wed, 13 May 2026 08:25:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55645C2BCC6;
	Wed, 13 May 2026 08:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778660716;
	bh=JSyy9ALiCyMEqHUgm72Z1pM1H2TspwwKOZNdcFHkpVA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fqn1PthNCmouQJxTKvEkqa49e9kMbx8ZjW0DPMaVRTHt2es57a1NHg6656ytE5Y7M
	 xfUlnTMPy3688CrHiRphacB3UnSw9Rd/FFODhWJWzedH7CbU3U9Kx833Ld2RVdf9cz
	 JdAeNf76qFa7sPqWzmlBaws5HFKZo1gM4GubR9WymUl3LEN7C5mcyiBNUsMGjw4hA1
	 GbwjDlLVEhbLhwkh418o7kDYLkTBR6AI/kuS00EOtagwohqpURrG5qoZtSTvi6IeMj
	 ssn43wPTrIaX3m/jITvdiN9ItwGAmcWM05JGrRhGJtPzNxgJnEQzdD/eROcidXtsHf
	 biRtcHBE0X85A==
Date: Wed, 13 May 2026 11:25:05 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 1/8] sparc/mm: remove register_page_bootmem_info()
Message-ID: <agQ1YS0TJciWts_V@kernel.org>
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
 <20260511-bootmem_info_prep-v1-1-3fb0be6fc688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511-bootmem_info_prep-v1-1-3fb0be6fc688@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 7490380007
X-Rspamd-Server: rspam04
X-Stat-Signature: x4w8xfqdosiqw986xbwtqokzyrq9omh8
X-HE-Tag: 1778660717-330990
X-HE-Meta: U2FsdGVkX1+J7I1adgpcM9OPt6j623tVbSSVjTi3JIBrOFzG7oggjcVHmoGcdwjsmf2BOYiTO2TSgpaiMz6EIde9ylUT9DhXNlK505wVaxQ5LELW0Yef7xL9Mwr935RpBL10r5vxUxhBqf1eItIkT4inclDMXKAC96SShKfBR8+o8j1ES49lqWJA3M45/jrOHBJ50goO1cHE5gBXz92W9asDn6Jg+6q8XJSshwBlf/vzwg4JIc/OkV8eXnqLr88I1JamunTzJB2mb/BkUjs/QEOgQaAPtor2FBOtW1zVN3u9mJtqL0styx8hnasKUgVLo7JRD3pxMN/Co8hqzVhwNvfq7XljZwVt3dg77y3r1hqGtdbReGuvXUTVXuOYfixh8ez4KQD1yoTN/Wm3nLrif4NrKeOWf+2KvTB3cKEpn1NMwOfH6cv01PJzGu8uCDLgun7RXt3c71exQiOI58yYxo0rxburQFL/4tWVFNsEaNFV2tMQGY7AkaxzDf2YoVQYv3V7waG1z5AkSA3bedzMutUGtxKpC+5pWVAG3WkKLFV1oWD54yBVTjGkc8dgmoEfhs1zPxAjKebyoib6ac5ei/JnXPlBR3s26kN67+c68w6rY7WWmQLTRwz7ivS8WD4Ob4HmCBL2LORcmOxIWr4I+Xph1tD6QhdjavzU6WDWKAocbX1aZOVW4TXuAYX14CxZDZwuD/bNProsAYc8NV3sY2y5Sr/y123ZsOc2b8RfMjbAV77ZHd3EHJFNKhNgV7wkBkQkPCdeNZUapWy2nafzlgC2ZcdQLUdXjrBytmQWGWKKc1mhe3qn406GahL0/c/yl/aldRs24vbccryMJWyog232eo5BOphjaJ2vPB2FyT4jjQFRqLp1yflZvOJ9M21bzkN715hBxQFqYxbhvb5wIQNegJ/hxYIoaxMHYql+ccX3NxXtexKFb6lu2Fg4+ol4AqOwU0ztcxgaHUzxnCn
 V4gaA+v0
 8NQ63fb2Phl/83tKKb4dvammT9L5glsMy2kTEvMUoM60Zbkbgpvcn+b4kP6FJkKLzcwRdHDhMWgcpKVHXaoN9AfGq1cOhO4bWH5dDqgdFcDhZDVl7Kxkc/IyWrUgMgVEG0ftGwOAlQfyxN7c/K/nz3u6I+PVKw7grMX1c3x9dy3siZjab6pf9ejqqkhR7RLx38ezWiG75iZ1BBT4Sc28YKxebvUUhjZkAeSaCAP2u2KHu9lIytoYTwTstR+GoWRsGdJ0sW55Cc8ow3BFdaYFXEvdq7Mtql43sYffu2HDgX/SEB99+gTsgm+HIIr0Ef/pj5ScGIJE9wwg5nZs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 04:05:29PM +0200, David Hildenbrand (Arm) wrote:
> sparc does not select CONFIG_HAVE_BOOTMEM_INFO_NODE, therefore,
> register_page_bootmem_info_node() is a nop.
> 
> Let's just get rid of register_page_bootmem_info().
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  arch/sparc/mm/init_64.c | 20 --------------------
>  1 file changed, 20 deletions(-)

-- 
Sincerely yours,
Mike.

