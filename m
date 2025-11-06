Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 065CECCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 11:31:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 341E38E0009; Thu,  6 Nov 2025 06:31:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 319958E0002; Thu,  6 Nov 2025 06:31:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2085A8E0009; Thu,  6 Nov 2025 06:31:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0AA178E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 06:31:36 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C0D1D16067D
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:31:35 +0000 (UTC)
X-FDA: 84079966950.07.7322410
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 46CDD160014
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:31:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=T19Bon72;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Nu3Zu33L;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c95dtUBL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="YMA+i/c+";
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762428693; a=rsa-sha256;
	cv=none;
	b=OaQMoWaVNginarhdbW3WxZaonyCjTYilPVHhLzOBRRpnr3+Yxbx0FpQ2Z+ltb5ZKGf6Tkt
	zEQBR1UlsIXigxfrg/u6KNTfn/B89B029RCi5lm1x8O4e4NteNiKW6QSEHmjmWkbZUFYHF
	gMDOGnYIyERS2vS6q5ZVIeSTt5Qm2wM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=T19Bon72;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Nu3Zu33L;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c95dtUBL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="YMA+i/c+";
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762428693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rGCMXNn5dL3lRX/ozHN/9Eb+iB/lKfzKevPd+jVbI/Q=;
	b=bW7xDXxBcaP1iKHg3Q+6e9AJfmhk0qxdE89GaoB6Dh5M/OLk4eRnf/6Cw6lp0R+lojkgad
	eETsdADvpHK5ciNAhfVjNhnwHWXLsK9FYB8/7v2fgPdt7r1Rxh+Aj0RygJ5+RtwGbWr4yj
	J4GFfyMsNPwB9qCLms/a4v/tHkr+zlA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8904A21179;
	Thu,  6 Nov 2025 11:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762428691; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rGCMXNn5dL3lRX/ozHN/9Eb+iB/lKfzKevPd+jVbI/Q=;
	b=T19Bon72ASkc8aIdSH+lxvP0PeGezhpeqa+dQ+VxmwtgiscQRB5TP0O83Kb6gkkSHPTPSb
	LyafLEvV9gakB38DclI2QetDQd62IkvnCrJAeFEmWoQFaXP+jOwxVG5sqEahPNFXYaiFps
	T/Hc3eAyRBcg6RHsF0jRHl8W+kz1Uhc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762428691;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rGCMXNn5dL3lRX/ozHN/9Eb+iB/lKfzKevPd+jVbI/Q=;
	b=Nu3Zu33LMtE90itQ6TCmD+OiKIP5ClZO02UPB2MFyVkKqy3x+1RLDUOkEo+VjtUpdTzhUx
	yjaKYUHHrbfY6dDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762428690; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rGCMXNn5dL3lRX/ozHN/9Eb+iB/lKfzKevPd+jVbI/Q=;
	b=c95dtUBL5MxaNGu8M93yW94h8wI76yZKYkdazUNJ6NEonc29aNISAtccXpGktxspCcoIEn
	a0ba87QhuuSdA6xbqXTz/B8vH9VQa71EtoCN/bEJoFUEJMcwnYj8PCjtlThUIto9TWkrgO
	7hmEMbdzgfeoAXDqBRgbutRg6B1nutU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762428690;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rGCMXNn5dL3lRX/ozHN/9Eb+iB/lKfzKevPd+jVbI/Q=;
	b=YMA+i/c+Sf6pm7a1ytKMafhTEPEbwzt5P8pl/XBWo+jECCDWXykamUk0gncJnXUEL73Mqo
	XA/jZvH3juSePmAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5AF5B139A9;
	Thu,  6 Nov 2025 11:31:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id S23WFRKHDGmQEgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 06 Nov 2025 11:31:30 +0000
Message-ID: <c68fe71a-d46b-4fe0-a2ce-57f443a43499@suse.cz>
Date: Thu, 6 Nov 2025 12:31:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] mm: add atomic VMA flags, use VM_MAYBE_GUARD as
 such
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Andrei Vagin <avagin@gmail.com>
References: <cover.1762422915.git.lorenzo.stoakes@oracle.com>
 <94935cf140e3279c234b39e0d976c4718c547c73.1762422915.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <94935cf140e3279c234b39e0d976c4718c547c73.1762422915.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 46CDD160014
X-Stat-Signature: j7pbr75aqb5xprz4jtmkafay71tdm5sh
X-Rspam-User: 
X-HE-Tag: 1762428693-529087
X-HE-Meta: U2FsdGVkX1+JuKornUjceSnA3gpw1uNCEKgrfLnTsifaCP2OeNeCBLFwccIVVBvnQrz4qaCRet2GIZHdZS4sSitt38N/y4J8ZbEKohmJGvfusOIYX0qxr4yt7HIU+mDPXb4PGhRTJTNU7MWeuvrGTmkuIzjpYxbMMa+yr5GJ9KUX1el0tb7FF/Uo826zcb1QaZhb9UcNhsx6xAKjf0sChPIkcIqy0wMYFHUXsvpo4TYFgBs2UBhSoPpenb2l+etQR1iJHwjJHEeD6O3OTHb8NqPxQzwqkAvyLw82VEalHWzb/LXm9bYXNTGopwHJzQ3JLCcLPMMpMcAj1g/j89fuCgMD7imtSPnzrPGlrHte3L8a4iVVaas/OXZuUptZK9fxV/BdgjjbYoRWcXtDT9wmxCgueZmfun8xEpKDn/XYcxK+aLm4gukXbEryc2AekSIHv7QhR+WMZp8Jxuogxrb3jkiTse8RK9EfdxRargxaP1ZNU6jO9SHh9/3ytfCCvUM7MyqA0XVtN9oDGsXqORfxaLbQSEhsGLa68gKTx6plBPpocPYwl/dO0vm4Emy2LyfJf8T+OLExqwbihDp4NUbRT/RBM0defrU7uw97tsgHSJ/Ml4oeMoDxKUTOJ3OvIOQM7m0cZrvn2R50CrFMjkIkFc+PTXdonskx8HelDLo0Ygg+R+76L1P5/SiLCBTvf9Hh4MjEHxRiDVvNZzh+c6BhsMDCzYdV3c4rCFWIhAw+sT69lMWOmn/KMQ9XPiMJRt7R+u1NcgT1PRpfr33qAPJbBAfuRP8sYnFe5cC5M8ofBWTrId5VZ2+mFVJ2tZlC8qNnlUInb+jYLpUWQEhIzbi/mUk0Ri6fZ8h53MQeKF8mwnxQL8BbQIVOrTRWss1CguWkIftrlX8W3NaPk6VEhkvw6Rlom+q2IAQmR6kiIKeKUbObXn06lUsS6RFJd9MYDBS7hTYS7PAh1cWvlX/GHA1
 31NEiFFq
 9cPMwPxflwDjlhPtNVgtQZU6JviJQxFtTiZjPZmy0g594XOYvX3r5HOKAvJZyECNT9ZXjxu0nc6xEaunFdbMEOE3kZ3mKpqZHn3/b4pdZOSTBP2jS1eak/mYolsWG/xUhXhvnn6TRYzGG4ZkAwHGyhyK6/RfC+x+Jk2ECdHEcHG5iRmDAnLyryQlHszD6vT3wGPyWNxEQNtdxI+239I8QaNguMd9YNF7ueYg7Av+/e2O8Qv0MqJp+iGHmrzcSmmhKyFUbyesStHr/Fg6/UjsbZhIuB5n5NImaFyEKnPN2fd6IgcUY88VFLhewy7oahdllJCq/BsEsmdhR/rqiCUsfFjy5da0ZWX9xZ+SjNG31Caab1Dg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/6/25 11:46, Lorenzo Stoakes wrote:
> This patch adds the ability to atomically set VMA flags with only the mmap
> read/VMA read lock held.
> 
> As this could be hugely problematic for VMA flags in general given that all
> other accesses are non-atomic and serialised by the mmap/VMA locks, we
> implement this with a strict allow-list - that is, only designated flags
> are allowed to do this.
> 
> We make VM_MAYBE_GUARD one of these flags, and then set it under the mmap
> read flag upon guard region installation.
> 
> The places where this flag is used currently and matter are:
> 
> * VMA merge - performed under mmap/VMA write lock, therefore excluding
>   racing writes.
> 
> * /proc/$pid/smaps - can race the write, however this isn't meaningful as
>   the flag write is performed at the point of the guard region being
>   established, and thus an smaps reader can't reasonably expect to avoid
>   races. Due to atomicity, a reader will observe either the flag being set
>   or not. Therefore consistency will be maintained.
> 
> In all other cases the flag being set is irrelevant and atomicity
> guarantees other flags will be read correctly.

Could we maybe also spell out that we rely on the read mmap/VMA lock to
exclude with writers that have write lock and then use non-atomic updates to
update completely different flags than VM_MAYBE_GUARD? Those non-atomic
updates could cause RMW races when only our side uses an atomic update, but
the trick is that the read lock excludes with the write lock.

> We additionally update madvise_guard_install() to ensure that
> anon_vma_prepare() is set for anonymous VMAs to maintain consistency with
> the assumption that any anonymous VMA with page tables will have an
> anon_vma set, and any with an anon_vma unset will not have page tables
> established.

Could we more obviously say that we did anon_vma_prepare() unconditionally
before this patch to trigger the page table copying in fork, but it's not
needed anymore because fork now checks also VM_MAYBE_GUARD that we're
setting here. Maybe it would be even more obvious to move that
vma_needs_copy() hunk from previous patch to this one, but doesn't matter
that much.

Also we could mention that this patch alone will prevent merging of VMAs in
some situations, but that's addressed next. I don't think it's such a bisect
hazard to need reordering or combining changes, just mention perhaps.

> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Otherwise LGTM.

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>


