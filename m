Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB235C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 12:45:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC64B6B00B9; Tue, 25 Aug 2026 08:45:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C77AC6B00BB; Tue, 25 Aug 2026 08:45:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B90BF6B00C2; Tue, 25 Aug 2026 08:45:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 98A826B00B9
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:45:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0CCE01C1989
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:45:54 +0000 (UTC)
X-FDA: 85139763828.02.0D7459D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 722BF40005
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:45:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FrQeZFxF;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787661952;
	b=dQYU8iOgB0v6LtSZaIHc1s+JonFFByyTPl4MakPnIRjAk5Gc5rn827l7sxkv23Z4YVJKGA
	/x5RNr7tlwUU41fsJV40lMkhc5nIK/JHVcVAKt0BNo5/Bhhe2xAdRbY2lIjkOR7l0x+Xbt
	sTa4hY5IjoRkRF91Jb45v0HBJJ2UBm8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FrQeZFxF;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787661952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HmU7Nx1JQE3YxPhX+v6TAS2KEkW3fAfvmpp1LlgfD+k=;
	b=4lpd7Am6hjqw1SZy4fgoGFy1hpB3rYZfWOpHl4lJBTTNniESTmjhABfEjx7+kWqQ1LrS+R
	TuqEj1ShEfBLp6IWt7lg6gGyEMpFSyIiTroPtXPqaz/vuVB+SHIJpTyczmDiaME3Z8gRyo
	HgHMLpffznOJzwBAKBCwEtrF8eQfyUw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EBB42601E0;
	Tue, 25 Aug 2026 12:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D541F00A3A;
	Tue, 25 Aug 2026 12:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787661951;
	bh=HmU7Nx1JQE3YxPhX+v6TAS2KEkW3fAfvmpp1LlgfD+k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FrQeZFxFXeX4LKudQJw20QTFvQnO22SmMG56FnrB8ggAxqyHNYAmRrDt/U5lQp2o9
	 xD+k7xpnj2S8whkR1WdLH0svZP3kuSymzo+wTdxkJc/2n5edsDZ5cJRohfzF9iw6G4
	 IkjJvlB4YOLDHmNGUWqU3rgH+dNXpRpHT6EUpBjyobO/kfK7IeYn7Uf2JWjaJjcjN5
	 Qc73mVM2KUtXpsULAKT8QcnDJ34cwDJ1dV+0phk/lTP3asmXoYQy99p/E4oyP0gCJ0
	 M4RarS4afzXUSN02FSIwBh6pLVN/oJZjZX8rm0QttrMbjnMn/gRxqKT9d+neMslcNs
	 ujeukwwwcgftA==
Date: Tue, 25 Aug 2026 13:45:40 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, Hugh Dickins <hughd@google.com>, 
	Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, 
	Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Shuah Khan <skhan@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] userfaultfd: collapse VM_UFFD_{MISSING,WP,MINOR,RWP}
 into single VM_UFFD
Message-ID: <ao2OYvbEIOfwBuoD@gremlin>
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
 <20260823-uffd-vm-flags-v1-v1-6-3086981b33cf@kernel.org>
 <ao16VxNvaYzlt2WG@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao16VxNvaYzlt2WG@gremlin>
X-Rspamd-Queue-Id: 722BF40005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: p4akmpcn4dcf3wfe8ajff7fatrn5ekgd
X-HE-Tag: 1787661952-216970
X-HE-Meta: U2FsdGVkX19xadGvAX9LABmVY8vjFsNzvWDNMXN8BVogIQS4mneRb+cEELpDdFwDE/JcXqCUOT3zCIccM9JH5ZA5TkUlRfzaxYtPtSjUzY0XVW2LMc49RTl4ibuk38oPrYTi3GHeOp80TOCiU6JpZfIIbW/jn5cvgPR5fDWexeOrbftrLXKaX/zRNkKRNw+HBwvrFuGY5rj0Dl4iDuFr+HuX2QG9yl157CPLXwGGJwxMJeDiuhny+B93BsphByBmCtZLmZRGQXq3niEZrk2pqo4ugKCN+nu2YVdWUxqn5zdRCM6KKWlIK5swH4nJnyGqjcj0srtbhsd7aKPz+Whvs9YR+/bMXhleePXR/npVdPDdCPwJnz5/LQi41Om9euV85lgJ8vXXy5HJ7Fa0p4znUP94Fs4IUip/HOvHmpPtbuAbGoXAtcPybTURaUPv4k4LPQRB+Uth6+EijHYAsDB/fHXJ8WibweoYD1RhFS3MacP/KF16mpMfxwYWXSEXe/5sp/rQgDYzBju932M6oIYD2z6VWeWwJ6M2Kmu8OKAAz5M2eRUlbFki08IYVriLMPVvw3PAmcRIVFzHthl1Tr78+W5wQRzC1VY9k4wR4E+G/JtUyQXEcaqhmpNFjhLVDLe9lQzOwYzB+ttUmBqT2v2Os4O8X+nhMx1pOaKsoNT0ZJazh3GbUv3l8n9EybArBY0TrrFK8MSI/SdDZ7K8S2KZBXojr4HiyNgDG1AKyp6h/A398QZWsWo8jzwg+V9ju2DO7Ti+vrgpg6czwLIEJbhjD1lGUvg79gHlErvvqcYjsn0ZYIKPNmq9QAva3Ih/FFI0ZIWxvx83NlJt4aAxLt7H1tXlANaZf7eryowTbcnh7Khizgz7bn/+M5GwBRbDxAXvSDImePR+AyvaS+t4HyyM6saM7glBY5UdBz4xz0xrEA2fxrB9TNLkZp6kSJ2f46lzYSx+ZgMmP59B11kV3Wx
 gUEzYmIw
 LmAAUJW4MtvsQB29F23buTSiHYhEkm18eDvOzFkoRFoUpE9/tc9cavFeWXFhkBaZ91eVKBDdiSEXXTnQ5EsULhVqYdbxNhv0MX+y0puFPsnie4856IAFKoKuyMnuwDfWEEvXmoHoNE5RYeKvNKLC+eLbrEaaXM4dkm6e46tNR+2HxvD04Zct224Xl/x9Q3QZ3iK2J98+pLPXtSBPTQlKllrPMa50sLdoRpxaXBF77NBjIiy/s52rM6j/IGzRsB8vMXBuT7BUBXFGU16Z8+AiO4iXa7mSrY0VxSrAmDCCdTSJOsTQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 01:44:23PM +0100, Lorenzo Stoakes (ARM) wrote:
> Isn't this patch then a bisection hazard where the previous one makes the flags

Ignore this one, I realised I was wrong and forgot to delete :)

--
Cheers, Lorenzo

