Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9BF9C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 08:13:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D604C6B0096; Mon, 24 Aug 2026 04:13:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D37BA6B0099; Mon, 24 Aug 2026 04:13:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4DAC6B009D; Mon, 24 Aug 2026 04:13:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A3BD66B0096
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 04:13:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 327AAA36E9
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:13:10 +0000 (UTC)
X-FDA: 85135447740.02.E30E61C
Received: from mta1.migadu.com (out-8.mta1.migadu.com [95.215.58.8])
	by imf24.hostedemail.com (Postfix) with ESMTP id B28AE180009
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:13:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D64uBYFF;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.8 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787559188;
	b=kjsnQ5sDvlbAsnvObrprMLScu1oF6LSDxwI73YRsF9yyCZI+Ci9FCzOhK9X3z2AXGbypBU
	DiYXWY4Wxbrpl2TMTg5g+PznIdP77Om7+jqzsZ+45iq4mTLlBz53V9BVkwbB8AOFxLYqMn
	c2yFSE9NUAygjWlBPSMHd1lKrwCsCHw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D64uBYFF;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.8 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787559188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IVeVPbKL49TCH2itDpGWCx8+AacsU4ms6FDLHw/oas4=;
	b=M2xHG/xr1eX/uRxQin4yYii+jFHDMSPdnFQtHe5CDIdk9LjkH+eV3bi0BI+FkMs84+utvV
	UZRVDC55s65FyW7kqsTxKBVRO1PhgTxedfRmmpxzh1zjqDvcyeWzXEyaGVnGGdisV2rl8B
	Oh0DK9Ua6jbxBGdK65EYJWk0p279oqA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IVeVPbKL49TCH2itDpGWCx8+AacsU4ms6FDLHw/oas4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787559183; v=1; x=1788163983;
 b=D64uBYFFU4XpP33tb6/GlRXBwpFZIcWCQ7zIRVvZktmyso8yaditLPs0T7sN4ptGVpE/Nggo
 94WDo1o9YUOk45Ug7pJmUy/icIkUEiRMYAXQD5WVCEiFoElhQoyefrc6hOy8rGCTf18+6+ZNRah
 4AveuR10o5CcXfabOHBqNqcs=
X-Envelope-To: linux-mm@kvack.org
Received: from smtpclient.apple (114.251.196.97)
	by mta12.migadu.com with ESMTPS id 03a5a03ad4541403;
	Mon, 24 Aug 2026 08:13:02 +0000
X-Mizu-Trace-ID: 03a5a03ad4541403
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 5/6] userfaultfd: decouple fault reason from VMA flags
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260823-uffd-vm-flags-v1-v1-5-3086981b33cf@kernel.org>
Date: Mon, 24 Aug 2026 16:12:41 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>,
 Hugh Dickins <hughd@google.com>,
 Jann Horn <jannh@google.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>,
 Jonathan Corbet <corbet@lwn.net>,
 Lance Yang <lance.yang@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Michal Hocko <mhocko@suse.com>,
 Nico Pache <nico.pache@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 Pedro Falcato <pfalcato@suse.de>,
 Peter Xu <peterx@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Steven Rostedt <rostedt@goodmis.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>,
 linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <CB35D894-1B3B-4D48-BCEF-38BB091F65FF@linux.dev>
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
 <20260823-uffd-vm-flags-v1-v1-5-3086981b33cf@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
X-Mailer: Apple Mail (2.3864.600.51.1.1)
X-Rspamd-Queue-Id: B28AE180009
X-Rspam-User: 
X-Stat-Signature: snim5eeu5e3zd4mjko8kqzhw7debnhrc
X-Rspamd-Server: rspam06
X-HE-Tag: 1787559184-244625
X-HE-Meta: U2FsdGVkX1/uSZ3Nc7Li8WIQJ4XiYzzJ6xIfCaiAjecCHA14SnOte704u/lVi7m68Z9YnA22hGo4b8jpMi2KZ7OzjC/oEijrRZ1jUq+TODF0nmoSuHxxaPlocraa8fvHZFfkTjMW2t4OEWDUidS1xkZ1G8Fm7mRlFWpICrKbGtSBrSEhmSrKiSatogr/2DK9AWalYpie6xi3+amlo1hFIAswKkm0L+WthpQWrhFKpnIoXUdpxuZ9o0/6OJnkb1e1lVd5SPm6bvtWm6vDV6fWeOXmJpTMbnczfO4PRUQjHdJsGc3giREHF1SKMVkYJ4BsEm6bt+fD2Nt9zK45whBC9HAtMjjwp4lXPY1vTBIsLv3H65bhiVSZ29bz/Jwb027ZRS3Vz6x3OkwMcNOU3MrMHmhBk5WW0B5R0UniFr8muLxSxVQg1BmK25AYgy8zwfklWwbA1fyyyJrEyS7JgMCInmAjk4dkSjBPhP2ud79l2mlqTUJ7ZhIgu9p9p+wnrJ6uYv+gzkOaUcmbpb7Yo11/V6Hmt4kqp7NuLvQYqG2AkZOFSHCQxbqP0qdIn083i4AI3tMNjTP8eJYADQMK3Co9X/C8vRTlM/AylQalzUafZbLhbOjBRpLZKDDxBXedM1hWwTzAsto+T+KKKSgOd4VrJ6zge8UM7QTtP+aznI0ogfbhYPmg/wlVTgcnU4pHsqfxlOYflCdCSNGKYtSq8otbrr1CuTX9+RFdkSgsFgdOrXCn0OA+fPzkMairV0gIZfrG860yHFeTNxPshvEXcm6Y1fJpU7ZgEwa9yF8H4tEcv1fnrtEpXofPWnaFPqpoSrDhrF1YOi2s6Wy/7d/DiTddt1NQMcg54/iMCXR+6IbAOnXia0S/9a3CJGHcgHbX38sWz7hktI1Vxmm/EWYl5iqzauRKwwpWv0GTBY1B6hg1tdRrEkuZ2o3OlMwd7yYMkTiMdOr1vgcFu3Uqc8LRIJg
 wanRF35u
 0PnvlGD5+GoV5Tfky/8vXyB4AYghOUoKJXVwfjoQPuVZTJeshBx80iBk/3k39/UvpnY3VXwh79oqDYFZbtNft3B1D4x62X0gVrN8Ok7G6CqwsHu7FoNCdlL/LG7E1Erb92WuFbA+eWD8AMlHv7qoTscbFFvuwBLPoHxo7scnHMC7GiBHfoS9ce6gCTwMrnsA63QlkxAmW7oRoyvxW7YQaTUPCD9i/GnUFABP28hHVPWCHuHxq91Or3brhB0zgFPrZpe06VWZrrnPqzZaNrv7cALr9CBdpy8DVmKVI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 23, 2026, at 20:17, Mike Rapoport (Microsoft) <rppt@kernel.org> =
wrote:
>=20
> Introduce enum uffd_reason to define reasons for user faults rather =
than
> overload VM_UFFD_* VMA flags for that.
>=20
> Using a dedicated enum makes the code clearer and decoupling the fault
> reason from VMA flags clears the way for moving the uffd mode bits out
> of VMA namespace.
>=20
> No functional change.
>=20
> Assisted-by: copilot:claude-opus-4.6
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev> # for HugeTLB.

Thanks.


