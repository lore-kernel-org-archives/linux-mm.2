Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E88FDCE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 15:47:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25A898E001B; Mon, 17 Nov 2025 10:47:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 232818E0002; Mon, 17 Nov 2025 10:47:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 147F08E001B; Mon, 17 Nov 2025 10:47:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F28BE8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:47:58 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 831A4B6D4A
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:47:58 +0000 (UTC)
X-FDA: 84120529836.07.441F552
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1C2E440007
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:47:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FY8475jq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=abiWHsnZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FY8475jq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=abiWHsnZ;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763394476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N1bp/RkXrWe4ZJfoDRda0he69lBlM2TcxU/1fFjH1cM=;
	b=fGIRt77kHrjd0FNFonPk9JnqRnjFU4uNMvXn2uPeCLsHOogTHQW9We92M9JB6gxDbP1gA2
	IEW3U4yM6purl+g/gwjapkWp9zPdnA17fVF5sq4+d1SGy+J5r5xEh53alFxPLbKaHmQUKZ
	MMy/9wr44LUfh3+FUqN9iIN26qqDcBQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763394476; a=rsa-sha256;
	cv=none;
	b=0blBkbA/P+kg+7r3g/v7lLTW/6g+JeUdIhjeQUfHjWh2YjvK6svlarqM6OG3eNrB6Iozq1
	2kRvU+23VhEdPNZKuZEZ9MSAqU+QgsEGQisXw7cKTIlnYTQiubq5QVoGO/mZHJzFcFdvFZ
	HaEdKSRh+KudMPPnLkEkEWMksy/8OjU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FY8475jq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=abiWHsnZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FY8475jq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=abiWHsnZ;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 039771F44F;
	Mon, 17 Nov 2025 15:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763394474; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N1bp/RkXrWe4ZJfoDRda0he69lBlM2TcxU/1fFjH1cM=;
	b=FY8475jqqlxhUjXAagYUzQHZineSTP8SgL138INUdue5TSFHANZA0uqGLnc0pFAVsT7kUc
	ILQmmRDrVMxclvSUVUFNj9YSOskygLBJon1EeFVUv6DE1Li3Zk67W9AXS0hvRfLepGks7o
	ZS0+p0Zb0sEypLDQ3/Y0nvlVlpGIigE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763394474;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N1bp/RkXrWe4ZJfoDRda0he69lBlM2TcxU/1fFjH1cM=;
	b=abiWHsnZgGoX21R3aJEgW3ceIO9ffw7DdSsafJ+5+Yb+a897vWj3DVvdle11Dy+quB/oNt
	NUdlshBSSoEA5HAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763394474; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N1bp/RkXrWe4ZJfoDRda0he69lBlM2TcxU/1fFjH1cM=;
	b=FY8475jqqlxhUjXAagYUzQHZineSTP8SgL138INUdue5TSFHANZA0uqGLnc0pFAVsT7kUc
	ILQmmRDrVMxclvSUVUFNj9YSOskygLBJon1EeFVUv6DE1Li3Zk67W9AXS0hvRfLepGks7o
	ZS0+p0Zb0sEypLDQ3/Y0nvlVlpGIigE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763394474;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N1bp/RkXrWe4ZJfoDRda0he69lBlM2TcxU/1fFjH1cM=;
	b=abiWHsnZgGoX21R3aJEgW3ceIO9ffw7DdSsafJ+5+Yb+a897vWj3DVvdle11Dy+quB/oNt
	NUdlshBSSoEA5HAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 426E63EA61;
	Mon, 17 Nov 2025 15:47:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7wTVDKlDG2lufAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 17 Nov 2025 15:47:53 +0000
Date: Mon, 17 Nov 2025 15:47:51 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: propagate VM_SOFTDIRTY on merge
Message-ID: <hrnnpvhpio6eb27w6xnqpdlyrlivu4xfbghagousys44a5dvgp@urmlfv7dyiqv>
References: <cover.1763142412.git.lorenzo.stoakes@oracle.com>
 <addc338c8b33aea3c31202180448ea32ef37956b.1763142412.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <addc338c8b33aea3c31202180448ea32ef37956b.1763142412.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Action: no action
X-Stat-Signature: jm1dybbfpw5hw3nzz1fugcsf47u7idp7
X-Rspam-User: 
X-Rspamd-Queue-Id: 1C2E440007
X-Rspamd-Server: rspam10
X-HE-Tag: 1763394475-996258
X-HE-Meta: U2FsdGVkX18VLej6wql1jdfo0yETlrEU6jSaFBJEnB37gyYk807Jb2dQcbY1EzTkZQthSC5EImNywS0NkBwJaKBhtMiuFeCaucbt0vhIk3k2xefIrypkmmkkD/gtkE/4K5BoQDirvexQTPi/8Bv/tFxR9p0NbFUxLifldJ9WVmvaNHa/1DxQB6VhwSCnU+sBBMno8lvuL+kul8bjuGddy0VqG0DeIDgEPjC+ttlUllMcITe8PneZkSLQsFrfoZ6CXxi6PFyMiFsGHYiTwUQWkLqaVU9FMSZFfRC8gFRHE8vuqozFX1ewR7iS8fFI4aAeZ/X7mMgUMvQOOZJCzCJajt4JWOAcxBpXw0LORf//0dM9ls9MMF4oF0takmESut+yK8d541eHF89JN3BFxmOSFwHKPjxIbXWPn7Duay/eKlCK+KuhCP1D5nH+wvlEC5y+Bth6tpvh/NfwoprXOLlJ7FE0h06PJoMXEYvv7D4Xg/8+8ez7FCjHsCKn/I1wmE69q4qBG0NnoA1bm2zwrKNoYLNgbu4W7bwVczaHNVd4fEcWbW1jrbg6aA6/z3GL5OnfWdpKHAjr9pVv74fRyfPIefke1U+XTLnwWT5lxiQ0ZnN8nXK4xReP1a44esgeVjbM8Q9hSkrvyPUaoqj3b+i1fGn84E6x2nLzRpkkLq2C7FkCie09cTuzc8dSVJTvn6ms5+MUtwgbGZC/MMgfDScXJhTk4qyOL6VzMwKbfDijZp2/D+C+YSrx8YlrTWcVV9pmQ2ZHaxrEz7H53APramUN5KjtJlqEX9AVttrGmKiZL+Tn2nm2XFZmuOloMC2ic7BBOx1H483q79mrIAkfQycx8QMeDBJ+VMx8U1taTXGB+I9JVD2PP+bFSlQc3pYdYNIvc9aq4XrnXgXzrK43fetFokej5eH/eCshoCsFC6A6VoNgOsXvHSXLba3AR+xzbWI4Z+lchLX6EdGkD5nGDHM
 iBjeogAt
 e68wyP3R9tvDoRaRFe3E3heVYFfYkvOk1BWYrY4i42FMORoEbbu5Qj5bXXcxYcmxMPNHByj+pvj3VHCrL24CgJ+R68Gv927kIFEQ8o34PHcKBJ27Ij1M3uFHUKCBjPRASY7GnZc0vb8rAvPkh0t8scw8RC37M5vwghcRNwkxQ1Z8HnzZvCOMIaWFStemvFs8vw3tkzcgj97s/ei0GQ4ewNBXmuQ1ouyCy49lIs+QQBwpl/Q5tNeZRjt22R1HS+Iqup7xeZm4m4mFvJ+fZSi8SOGRhSMBBKI+9p14CX3pK9+UMDDwS9Tb6laidV/pAR2vl6Cmb7ha+m+ba0e5l6j1YAnDfUDHFHOckUmxLtkzfhZxVpRT6wDgNJCNTfA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 05:53:18PM +0000, Lorenzo Stoakes wrote:
> Currently we set VM_SOFTDIRTY when a new mapping is set up (whether by
> establishing a new VMA, or via merge) as implemented in __mmap_complete()
> and do_brk_flags().
> 
> However, when performing a merge of existing mappings such as when
> performing mprotect(), we may lose the VM_SOFTDIRTY flag.

Does it make sense to backport this to stable? A more minimal version, that is.

> 
> This is because currently we simply ignore VM_SOFTDIRTY for the purposes of
> merge, so one VMA may possess the flag and another not, and whichever
> happens to be the target VMA will be the one upon which the merge is
> performed which may or may not have VM_SOFTDIRTY set.
> 
> Now we have the concept of 'sticky' VMA flags, let's make VM_SOFTDIRTY one
> which solves this issue.
> 
> Additionally update VMA userland tests to propagate changes.
> 
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

