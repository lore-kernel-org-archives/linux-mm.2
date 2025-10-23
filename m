Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23C9DCCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 20:56:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BF828E0012; Thu, 23 Oct 2025 16:56:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 796DF8E0002; Thu, 23 Oct 2025 16:56:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D3B78E0012; Thu, 23 Oct 2025 16:56:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5A30A8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:56:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2BE5B13C23A
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 20:56:48 +0000 (UTC)
X-FDA: 84030588096.28.F9BBD4C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id B183310000C
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 20:56:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WA2jRvTN;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761253006; a=rsa-sha256;
	cv=none;
	b=lT16gQ0QjZVrQVHRvv2xwZEsg7yofaO/NcSW6FY3fEGLDbzlDusnLIiViL6un8lMGjjPEt
	EiQMac8bmO0Ias6Anr8fjW59m1CqtFuuRm06O7VErC+Xag/dqGJzePC8562Qv8JTErpaBr
	JEso8h8Hy3rTAmunMngoj9Y6HKYOWsY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WA2jRvTN;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761253006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oxQ2job5mlItSZlTQWRzQAXT927Szdl2DDDXhAhg9jo=;
	b=Ns3YJSHnmmqJ1Q5XVcmmecOdVJ52Ta0JiDGloxMtXO/D+AtSCUTRCfXyxsBuRW+9c5urLi
	WY6JR4QRMrJKWmZEFEbW7KYbOfMVJkt26MQud/GD30bc92sAaHsr+f8qcEO1UsINMxleB+
	RoRlYmQ5Mfd3AnPRj0i6L3r3pkmf5zw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C2E44611D2;
	Thu, 23 Oct 2025 20:56:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC457C4CEE7;
	Thu, 23 Oct 2025 20:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761253005;
	bh=5xFDg5dV3Epc9fNs6C4u+qbcFy3cR4rqvZ/TDFw19JI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WA2jRvTNVXhYF2sqTdUzvcRexXVGZOrqy9HS26PolLf2B1UwhdHbxe2zqsQwzhZLk
	 bQk/8YO1Vi4UUK8GfsMdiiqJMIfzRIGxe2a+XTeyefQ7XQZg3AEZMTflztcj/0xptQ
	 nvOlbfef51ri/UG4OhO1137SbjsCpj/EIgTYUjrc=
Date: Thu, 23 Oct 2025 13:56:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>,
 Matthew Wilcox <willy@infradead.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, Harry Yoo
 <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt
 <shakeel.butt@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCHv2 2/2] mm/truncate: Unmap large folio on split failure
Message-Id: <20251023135644.f955b3aa4b4df23f621087c4@linux-foundation.org>
In-Reply-To: <20251023093251.54146-3-kirill@shutemov.name>
References: <20251023093251.54146-1-kirill@shutemov.name>
	<20251023093251.54146-3-kirill@shutemov.name>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fecru5ayqqxcie17gi6xp8jk3rgf64zg
X-Rspamd-Queue-Id: B183310000C
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761253006-960846
X-HE-Meta: U2FsdGVkX19lBNJCLqe7ZSL5410+GrDrPkiKlNXJ4QS6j2iVgzGhRMj4u+Q1+7C0udC+s+5E9uazETb59oc9dXSpb3YwzOEHCaS3uWA/kL1J4HTeyxnHDB+3FFPFkDGDSFBJiH9RQLsuxSgScktIk//rskG8+2pD4wa46pyuajGx4Xs8gvJq16u3lPYL+n67RuJgZB2mZKue/TZjZBwAfncwotGQaX1Ca6/nuy5c9qZ7/suaruL0OTQe1lEQ8+MrCBWg3rPSlkfGeYpgPOir/4y/Our+YLq5f4jvpnUSXLtpCdosrDxH7sjsNoDLfyxgU8Qg1YMJxIOS+rNQ1NdcT2ABVJevTJPGZGT+DB3fnEGjZRMiqtcaKGWMdxcTy/FA4sBJnYKVT4OROXvTmSB5q6FhSEtlh6L7pee0/ZHLIG59YEi3WlKVjsfE/L+GnqoaCr3T8ZAXPTgAbUswYpQd43sMnbT0CNn6qvxKUDOIRffzTRf1Va3WZdhdW5zU+sMXWUy3y3rcjnnxNMxQm15JF5n7Tt841+2YaHGrtnoIL1H2RAjBZjVuUdfRC29C7W8lP2y9dW6hsv8nfcAOJOFi/42542CxiFyGYUjWdmTZMwivslmiQB1qKFBDuupbi75OjGAx88nhm6hf9tC3qZnzA8wT8xo2JtsFK7e/J35z10nzY4I41JSegEAn6/DLH9HsGrU/Xnbu6BtUjXdgfIN95fZEUL4L0s3W7VkHFjhhxsjqcR+e6VHckKujuzH9tIIczGCiDHPv38p7IUb3Q3kQP9R4+vNhcKBvTw4k7b1avmEQrBeNxxPdG58u66uicuCHiWAVV5+rbMLEyF295aoZpgscoIgK+SuPgL+epHeIiWj/snxkAya/aZ5jn7ptYixlLxGLZfbvlQvtPCc3f1L7cG69jctPslc4kQiEepQndOgR1gmRXzixjMQNICpBuT7Y+ob3/c10olO0Ev3lu4h
 VnA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Oct 2025 10:32:51 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:

> Accesses within VMA, but beyond i_size rounded up to PAGE_SIZE are
> supposed to generate SIGBUS.
> 
> This behavior might not be respected on truncation.
> 
> During truncation, the kernel splits a large folio in order to reclaim
> memory. As a side effect, it unmaps the folio and destroys PMD mappings
> of the folio. The folio will be refaulted as PTEs and SIGBUS semantics
> are preserved.
> 
> However, if the split fails, PMD mappings are preserved and the user
> will not receive SIGBUS on any accesses within the PMD.
> 
> Unmap the folio on split failure. It will lead to refault as PTEs and
> preserve SIGBUS semantics.

This conflicts significantly with mm-hotfixes's
https://lore.kernel.org/all/20251017013630.139907-1-ziy@nvidia.com/T/#u,
whcih is cc:stable.

What do do here?

