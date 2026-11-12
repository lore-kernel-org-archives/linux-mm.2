Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E752606A8AF
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 10:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=tWCN2rWX;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=cniGN0eP;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=oJZZLYyR;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=WZ4QAStE
Received: by kanga.kvack.org (Postfix)
	id 72C296B05B3; Thu, 12 Nov 2026 05:36:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704646B05B4; Thu, 12 Nov 2026 05:36:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6198A6B05B5; Thu, 12 Nov 2026 05:36:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 430826B05B3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:36:33 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 37055C02DB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:36:32 +0000 (UTC)
X-FDA: 85426113024.20.03DD813
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3CF3240003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:36:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tWCN2rWX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cniGN0eP;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oJZZLYyR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WZ4QAStE;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794479790;
	b=JDnURk7MLKeFypZKHDvS0GI+BEVOsB9ddDl0JdX57sOQ9B0jvcn58YD1p3fwlO82VHfiKO
	EZeFHZosxNj9Ejd3SCnH7F3Ntm3oLTQsEmxGe7qlvu/r5qCzJJJDAsRCEDbCwl6m5XdjzG
	EvgVgCYjz25b9kZ2pW0Ls7COB9eefzg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tWCN2rWX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cniGN0eP;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oJZZLYyR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WZ4QAStE;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794479790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D/2XQ7ncDhSBVFrS9AI6XolCxT4hxWA0EjuRpadrVdI=;
	b=6en9a2LCNTsUiizAWWkxkqEznVHYaC2rQU0sQVWscU2z+bJUyK7guDYRREMKzmcH/Fbln7
	0MOG9/WYhduCFixuApClDGVQOiiam7ojlCYEchp+MhXqdVO4oNzf+nZ2WlZabaFfxk2mTW
	jRtlBj6HF08ceLaeKLZt/7T4dDY1CBU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E8A2B21C76;
	Thu, 12 Nov 2026 10:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794479789; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D/2XQ7ncDhSBVFrS9AI6XolCxT4hxWA0EjuRpadrVdI=;
	b=tWCN2rWXg6Jc6hML+rU1RIt5XKgQfxl/g2XI1/mgon8qIZaTHQApi/R37OJvUSL2YIwSWJ
	16Ls8dPn6SQQx396r9SMIBmN656Why4nSIsO2Dcq5G6y0m3/02Yj1ROSPOqMc1mMWvjRsJ
	8LfzySu4Sl+wVI0a3B5QG7HF/ukk69k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794479789;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D/2XQ7ncDhSBVFrS9AI6XolCxT4hxWA0EjuRpadrVdI=;
	b=cniGN0ePsb+osUWCEq4BYyPuGoEI0GqMu9zJGCzrEAu9QLPtmlLdnKToVaebgW2JhLIRrR
	bH8bWuPkJYtZPJDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794479788; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D/2XQ7ncDhSBVFrS9AI6XolCxT4hxWA0EjuRpadrVdI=;
	b=oJZZLYyReIEzYwEkcLWh37+a9w0I2bGWD+4SpK6Fd/dGf5c7UI2wgD41ZaTW3+pOqSSVmv
	0Az5uLlUnr/634XcJUi8FuCsxMEeIbZ9XcivKpNA9RgvyGFxhbb+4NCK7hWRstDj4BVXSE
	BgP34lMlYx+Q7jdSjaiFVkWYOFe17FI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794479788;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D/2XQ7ncDhSBVFrS9AI6XolCxT4hxWA0EjuRpadrVdI=;
	b=WZ4QAStES6ug3df4SVOPu4DwhaWzYh48R4ZUAH1bXsNAkS0mb58af8mNPw/rsrmay+0MDN
	0pcMrcxVawTBV3AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CC9B413432;
	Thu, 12 Nov 2026 10:36:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id evncKKuW9WqpTQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 12 Nov 2026 10:36:27 +0000
Date: Thu, 12 Nov 2026 10:36:26 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3] mm/memory: refuse to map page cache folios that are
 not uptodate
Message-ID: <avWWjD-SRRfgAWiS@pedro-suse.tail5790ac.ts.net>
References: <20261111182445.656620-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111182445.656620-1-kas@kernel.org>
X-Spam-Level: 
X-Spam-Score: -13.30
X-Stat-Signature: 7dapg59sqiiknehgw5djnotnztqotqmb
X-Rspamd-Queue-Id: 3CF3240003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794479790-136768
X-HE-Meta: U2FsdGVkX1+C0cj63XkGRhlcqelyYYeONx6g9D0V7ATM3D4PyeOLMbSd2J9deEK4ogiIx5MGSw7FL/bXqQCBfZMtGY/+K8Yb3aRbX3n2vYiYmCwznIlLe+LK+dWlWmW4HR5CdGew1QaDM+MtPzQV6ACRo8uRcipRNOFh+MCw/AZI/aQLqujN9xej1UoJyq+VnjxOqtmotcw32b5LXokdHJdy0HxdjB2caYlhMJwVasjx1/ezyzMqIuVjuG0c6Z1HMxH4d7vPYkv6piseQ8CMYvSSGGCbH3JFNGe2Hf0r26xT5iuQ8kVmU9X3QASxYlpyGKf3qg/48I5jVYzfGcrWDgX/I90/clPAaARH5iSvusaN61yj+Kgl4OdX+SoSBDbcnASmcfIWhpUkLpF0lu1vH9YJy0+CcpXz6LD2N7SNGdjDSOT5+nonIs7Xbz7jGKgvz87fJEtOS02y/U9ToPfJD25+Fu17YEFQ4iRMua7aS3JSp0nNLLJxi3zC107eI91S3E3xnSjZMHB5cog/5JqrOBHhI2i4gftodWf6CqerH9JrcIP/dUFYnrC26zVbugsngaoqAOn+iLJdLP0tp8QMUj+5nLMc2eVn0F3esb+20EMX9LT8EOJs7uEt5QS0tXAis7oUHh1zSk2kg7DjPOc75OsMptiCJsfV9yaI//Mo9udTYbWR11/5rHZ68JGu6L2c4QRSpeAe7czRtKoy+lSdLc9qGSSSWAYwmGREWgkLHThEwYo6CozaxrLw1tcSMpfNSP1Z39V4ya6Pv63M/MSBxXv9li8RCiy1mYZtwiEuD8DJuWrNYNp6IAHqPbdAUuETGiEyf7Q72uzPzqEGBQ9LDuVTUONagvgS0jdqH5ndaP+Hki7XPNVdkswd0FLGjXrDsHMd19vuQB1LDbdLkRSYLQ1PsuDu4AHwgk64zY7JDfHNYjghwC7wfjk7kusYoQmGLnvR5TFZwo3IwuH6c7v
 7+WYEa8T
 ly593G0LnO4ifUCZ4sAs0yH9eDJ78v2ScnwldesQI6raD5OzV2uH4K5V+O33V/5waCCM4tnFo4lG6yomF+BxdEGLafvPdgqef/SWJ4qf//xiAYrYBTu3JMyOywwbSdQxkc0tla/Q0VpZCLXMglf3jidwa/TVEzjrasCJp2LFmaLa6vAYV82ksT9L0mmScLncMaTMIRNMijOrS2uE5SBc+FtCHGPL/gp2BUjwWgnwrLNQaJAeDtO8brr61qtS76vIejPsCJFnOK2nSifOmhV7jIp647IkWxJqb4UQp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 06:24:43PM +0000, Kiryl Shutsemau (Meta) wrote:
> A page cache folio that is not uptodate holds data that was never read
> in or cleared. shmem fallocate(2), for one, adds such folios and clears
> them only on first use. Mapping one hands userspace whatever the memory
> held before.
> 
> Each path that maps page cache checks for this itself: fault-around in
> next_uptodate_folio(), a fault in filemap_fault() or shmem_get_folio().
> Nothing in the mapping code does, so a caller that misses the check
> leaks stale memory silently. MADV_COLLAPSE did exactly that with
> fallocated shmem THPs until recently.
> 
> Warn and refuse the mapping in __do_fault() and do_set_pmd().
> 
> __do_fault() checks the folio ->fault() returned while it is still
> locked. For CoW, that is the page cache folio that do_cow_fault()
> copies from. do_set_pmd() covers MADV_COLLAPSE, which maps without a
> fault.
> 
> do_shared_fault() then unlocks the folio for ->page_mkwrite(). A
> filesystem that clears PG_uptodate on a folio in the page cache is
> buggy, so that window gets no check of its own.
> 
> The fault gets SIGBUS, as for a folio that fails to read in.
> MADV_COLLAPSE fails and leaves the range to be faulted in.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
 

-- 
Pedro

