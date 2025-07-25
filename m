Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C986C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 19:34:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC9CF6B008A; Fri, 25 Jul 2025 15:34:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA1986B008C; Fri, 25 Jul 2025 15:34:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB7176B0092; Fri, 25 Jul 2025 15:34:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BFCED6B008A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:34:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 68C40160906
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 19:34:29 +0000 (UTC)
X-FDA: 83703788658.15.42D128D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3D900C0004
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 19:34:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DBQeTZm1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3mATE9kj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DBQeTZm1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3mATE9kj;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753472067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S8zF3UsrGFMPKubG6ZqWnuxzmTuTcmmFNvDMxw8EafA=;
	b=hfrS+wFy78YmYVm231j7CGKxRrjkXH0BBVtXRpJKDG8RBe3PO4x4hsun33em6zkuiq6+qv
	1Ip6Y7laKQ0oJxI7qECobf4BqC3BycluqzAxSu1s0Hd4/cVa+zkKHa8xnINcm9QF+vs8RT
	JnkV8OeNyM5SgEF/Z06f+roW2gtd0+k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753472067; a=rsa-sha256;
	cv=none;
	b=m1UHdBKTmKb65yLhg75HKcbm6a7kgIyWfrg/OCR6v6CVOR63GpUOntfpOFO/ckISJePSjZ
	uTi/cYTUNr1OUYZI1HVqhV+M7m+qFfO/hCUOtWsiuCKUqHOI0ILP4SMH8cFPT6bTKg9nlj
	kr9QnXrtxmuJV0+UlwPh56S/Ij/02Hc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DBQeTZm1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3mATE9kj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DBQeTZm1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3mATE9kj;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9E4211F387;
	Fri, 25 Jul 2025 19:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753472065; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S8zF3UsrGFMPKubG6ZqWnuxzmTuTcmmFNvDMxw8EafA=;
	b=DBQeTZm1Vo0+SYvB87M7V0lMbobs+BnRZ5v+sDIOJWom5QKKetOoEqhVU6PHr27fhp/4os
	Tb8El594TwmzQx6s9oV9QNp5hs44C0cJKR+nipTK9FE8rIpcFdZ92lCx4kdKcVMEb1PmA5
	IZAWCQGGKAJHFHdegHD5kxb2/5Oq/r4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753472065;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S8zF3UsrGFMPKubG6ZqWnuxzmTuTcmmFNvDMxw8EafA=;
	b=3mATE9kjfC1lgrzVxqPD6uXTII2kjCFimtM6LlKa0xaa1A9uDwQoyrBzMiypdF/CD9WyOP
	eDP/mINzScSgN2Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753472065; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S8zF3UsrGFMPKubG6ZqWnuxzmTuTcmmFNvDMxw8EafA=;
	b=DBQeTZm1Vo0+SYvB87M7V0lMbobs+BnRZ5v+sDIOJWom5QKKetOoEqhVU6PHr27fhp/4os
	Tb8El594TwmzQx6s9oV9QNp5hs44C0cJKR+nipTK9FE8rIpcFdZ92lCx4kdKcVMEb1PmA5
	IZAWCQGGKAJHFHdegHD5kxb2/5Oq/r4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753472065;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S8zF3UsrGFMPKubG6ZqWnuxzmTuTcmmFNvDMxw8EafA=;
	b=3mATE9kjfC1lgrzVxqPD6uXTII2kjCFimtM6LlKa0xaa1A9uDwQoyrBzMiypdF/CD9WyOP
	eDP/mINzScSgN2Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E57E4134E8;
	Fri, 25 Jul 2025 19:34:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8plJNEDcg2izKwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 25 Jul 2025 19:34:24 +0000
Date: Fri, 25 Jul 2025 20:34:23 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, David Hildenbrand <david@redhat.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Jeff Xu <jeffxu@chromium.org>, Kees Cook <kees@kernel.org>
Subject: Re: [PATCH v4 4/5] mm/mseal: simplify and rename VMA gap check
Message-ID: <ybt4kjtepxaqy4d4ki6z2fzfa3t6mk4tzxe3nqtgoqnr5apipw@a2p55pe5ue2p>
References: <cover.1753431105.git.lorenzo.stoakes@oracle.com>
 <dd50984eff1e242b5f7f0f070a3360ef760e06b8.1753431105.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd50984eff1e242b5f7f0f070a3360ef760e06b8.1753431105.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Queue-Id: 3D900C0004
X-Stat-Signature: tunertjqyc5m4dacz9pu9uikus4jpeik
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753472066-88625
X-HE-Meta: U2FsdGVkX18NH+B3gVY5wnUsXf6wOsbDqW3rPCnWF7FUIZzopvWcZ8T0E1FkyA10Efh6ydUew1ti0HP1MDflkpUMnfT8A0ccZVij7+1rtfcEhVTeeWzDeiZFhiAWZiYs/adMWf3gbueMWnXayP5Wq2HQyLup3gahB8D7B555xYR2dmOypGUMsHm4wF7uCANLV38Liui1LhLl87WomY+EE4FNUhmn4yXmvkvJqPwZMzTwoUNcH0pXiyN+SGY9OopUFuow9YTc7nA8LpGOBi1Pu2RwRA3UxsFo3HyisTgyEHWL21qUHmpWWfn18DlcmlqoMXeBmuMpJZphVHhPhodkSNCoeJuhx0986cN44GCc9BZ24Xt9zOrMDvpVoFj118c5hv4LFdgYTkT58wICt2Anxtnma6eyTBmqHGHgqBgs84TnzNbT2+QYEz0bHfn6hf4A6bXFNpUmkePh0T+kMqlBtLeHsezjuMhgRtVPlY90B+RS0HWIPa5afGe2GOxhQPVNcxWcrdIYv2dp7gQjNTe1RdQRHM+sa27mvrAfdLqY3Op5V2Mda0hcwmqLGHLdGd2O3aOZF9IqDHMEqfMYNqIGDmkSaqHXEmQZPzrZFS4BKc2VbJyFEtfc+lDTKCZc4V1YLCzcrZdywWbXN6ELrEfZQ5CWab2bEdIjgKLVa9/SRfgXMG6d6KjwvkXjZoOUdOtvYMJ5CW9GNM7ViCjWSoiNmZv10p3GIupIcNDZdUorK+p7TJ+M6SizYSIwW2lpyOmaiR6HguP4vHd9mJFhOLZAuE1JSd9bbw1EzZDTwdwnwfSE+UKwSBtKkJpVoqkiIADHOtthC6+/LjpMFpPEygFlUoO8E2T074500dsvgUNPl+gynvusZfcM7ZBY5n5G6NIubj8oXT2JOIJ9L/iOESBc+smGAoVNNk9Lim5HSt/xJQJ1M8wFN9Yy7q2pK7/bqBJa+hA955tpPEpIt4d8hS9
 lJcH558l
 HkTVB3waxxLu0XGAmrTbqghRxbKqxBEUpolJ4f+7BTZUReNfcIQrHnnG0bm/HzBL3nvnrm9ETD6FeK6oGVErJEqk8lLIod7t7I4FWHu5ALpfFtbWKto81zkx2Dkdva7SRHBVGKrGFPUK4GsOWHgkZoVvH6W/QnliRgl2+10y/VZ1eD/i0Iic2kNi0vBJAD7ylnhb7ZOIxiwBR7AYbDSLUH20O4ebly5kXCrcbHgoQ4bLYgTCWCegNLf07ZGtxt7+Xu8wIiHX+GWaCSbxwHQcMa96C8QwmHuWsFtasikPxAxjdhIJ/kwuPg8R0fy6KhRbYjjodVu/+Vn1aA+tIXcExNJTP7dXOOwYMIMN6LS9BlAQ2+2uI+0RBMSggBw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 09:29:44AM +0100, Lorenzo Stoakes wrote:
> The check_mm_seal() function is doing something general - checking whether
> a range contains only VMAs (or rather that it does NOT contain any
> unmapped regions).
> 
> So rename this function to range_contains_unmapped().
> 
> Additionally simplify the logic, we are simply checking whether the last
> vma->vm_end has either a VMA starting after it or ends before the end
> parameter.
> 
> This check is rather dubious, so it is sensible to keep it local to
> mm/mseal.c as at a later stage it may be removed, and we don't want any
> other mm code to perform such a check.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Acked-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

