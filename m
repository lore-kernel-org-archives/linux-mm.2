Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C777CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 13:24:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EC8B6B000D; Wed, 10 Sep 2025 09:24:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59DB96B000E; Wed, 10 Sep 2025 09:24:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B3838E0001; Wed, 10 Sep 2025 09:24:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3A7F16B000D
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:24:05 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C3764C08FB
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:24:04 +0000 (UTC)
X-FDA: 83873408808.24.810E446
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6D61020009
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:24:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EN3GVk71;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=aUhO4heT;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EN3GVk71;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=aUhO4heT;
	spf=pass (imf13.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757510642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UEVkkQ23Tqz5PvZ8ZMjLfQM9v76jgOVMVSW9/pqQol0=;
	b=IWNXhi1/ua2dBVF9eptQujO92Pxi+OrUB93G9aA5WUFsFfqKtCjKDYq8AJG8xO/BwGiaqO
	AWZXq6pyTi4zSyPa4/wQ5k/6nvprgpBY3oevRfd4qxeKFevlfqTpphLSnPJaBPPApN0oX4
	C1qo9a+cU6EtwK5xU2oWAsYIGy6aw6U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EN3GVk71;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=aUhO4heT;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EN3GVk71;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=aUhO4heT;
	spf=pass (imf13.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757510642; a=rsa-sha256;
	cv=none;
	b=OaAAuls+acBkjTkvdZ3ClhmuS3MrENKP5vNKeLx1xB8uvI7GnLDFbsjjb9lP8Zz9zqNjco
	nKep2VcgVprritErV0LgC0zsQQ0eGCe/NK3+0OA/j4/W8gs+4eqWwOrYDKgbrsHXZMAcuS
	m0ScuDM1JFLtuAAzON/RRbWQ2VLs19o=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6BF84207D8;
	Wed, 10 Sep 2025 13:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757510639; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UEVkkQ23Tqz5PvZ8ZMjLfQM9v76jgOVMVSW9/pqQol0=;
	b=EN3GVk717n+XCv5zPhcnnCg4H2xglDNEbba7tQxDxb/Re52c8H+m409AaCY97Z4jdaq9Xt
	w62tbVAyAWv19i3ikyBi1VPwuosqLAJAAYl4F2815G1LTQc3VcisOI1Wz5EsJtWsNHXVmG
	l6ERSLXqsacaTEtQjKBXO0oGOb0be6k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757510639;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UEVkkQ23Tqz5PvZ8ZMjLfQM9v76jgOVMVSW9/pqQol0=;
	b=aUhO4heTLGa5w1Rrd9iYA2BECWWexmMcuvHvRJdpjDH+OiJG04YF9KZekpV2fe443cnnTc
	t+AIaPrU+pMCFmDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757510639; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UEVkkQ23Tqz5PvZ8ZMjLfQM9v76jgOVMVSW9/pqQol0=;
	b=EN3GVk717n+XCv5zPhcnnCg4H2xglDNEbba7tQxDxb/Re52c8H+m409AaCY97Z4jdaq9Xt
	w62tbVAyAWv19i3ikyBi1VPwuosqLAJAAYl4F2815G1LTQc3VcisOI1Wz5EsJtWsNHXVmG
	l6ERSLXqsacaTEtQjKBXO0oGOb0be6k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757510639;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UEVkkQ23Tqz5PvZ8ZMjLfQM9v76jgOVMVSW9/pqQol0=;
	b=aUhO4heTLGa5w1Rrd9iYA2BECWWexmMcuvHvRJdpjDH+OiJG04YF9KZekpV2fe443cnnTc
	t+AIaPrU+pMCFmDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4531813301;
	Wed, 10 Sep 2025 13:23:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tLSnDe57wWggDgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 10 Sep 2025 13:23:58 +0000
Date: Wed, 10 Sep 2025 14:23:48 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Charan Teja Kalla <quic_charante@quicinc.com>, shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org, 
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v1 6/9] mm: Change dup_mmap() recovery
Message-ID: <fkfi4zldsecyio6xnd6blou27me4nno3v3tnsaxz6xlt63yy2z@nxl7izptm6yx>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
 <20250909190945.1030905-7-Liam.Howlett@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909190945.1030905-7-Liam.Howlett@oracle.com>
X-Rspamd-Action: no action
X-Stat-Signature: yh7dy3yjdf8ngqe97u1n9akgg6baus7f
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D61020009
X-Rspamd-Server: rspam04
X-HE-Tag: 1757510642-732999
X-HE-Meta: U2FsdGVkX18bzMFjCzzd9gKQt87UZC86vn4aEKTxYygetsHMl16LJ337tSHCH5QtcJX8Btbj5WO6PEItwg6AekiISx//TDYLWb/hKwBGbacVR0DB7qkBpvNNm6II2SxEIP5sDS/mljBh+g23xOVuggVdnKufOhYfXAPFOl1oZ8sZqy3GHDda1EZE/Pw4PuXS4XACi31AaU/7AmekIeQPW45CErzL8PWzGNTJsCen9qx6HFV9R7ogS0v9Yyx5EO9mAf1GZkI/YggkeIz860ycGhZHwzMOT27VpckvEP99rY8MC9OmVuHmyeWsoC+yDlXczyDTFi3m06XVW9JqMgKy7nlrLzW+OUpCPhJoIvWGmQvT4Sd3FTJCeN+tohr5BNr9COhbzHEXALbPTl1tcID+aS5+vhzXjxK9dyTu6o4A7GPiaSDS8eQvBvFBtOraRoI8WjURrGJGqHxX1a5u8HaJHMuiXNkmPxxquM3Js8yW6/RfDKKyi2Xn9S0izoceGhyScuiFUE9VM4hDi1yg7aBGBXK4W/zJ0M73Fd+SmnTPOekl/S6Xyty6Oy6yXkLrNjHkWWXzV25EN4Gj28eS6LoAwnhP3JaBS+udznXE7ZMYO0alva5vIas05V+f9YT83kMvM1j9+NHccLuh+3JVwtPixNPErJ8WzSDaHrzyAUByS2u0qeastvN4aeyt271wALIu6z4M51bAZC2Xa+D+j4H60Kn89n6WC6r5S7c2PcflejEPILfudV1+zezXYHvDogRR3lmwZFON/hD2zhenIszNrmkWBY2PJLlxhfG/QJQfv5crVHoZB/oHcTZ1aylbW0rIVB500viYnz0bEQ1puLc1ugJ5QEQmSX7LRhhv3S1lRBGEK16QIPJ4CuNG/TJEIwBJGRzb0OFO6oeICW6CPm5W6SbKsw3fWfW0YDR92ZdXvuB70bp39gqR46N/4geRMVgdfUUekd5dP/LcKGlonhB
 fnGeLklk
 vG7ZK5utCaImDkLi1tiVuFtJxYMFtd+EWSWB5OpiHL/3bylQFT/WHoXYVn4DDmQOTheJZPZZPJ51jPT6pMpmkMChVbfl/0vllPvfBhxoPAPx5a5QRfdAw4w55F3Yq6hNLQuQgv8JT4jwLUTlpm43hKYrCwFRsEMsbUHpksvYC1lWvyI89afaei8DeqPGbBzwmEE47c9OxznaWPIWYC8NxRb/EeO8lS1sfNMJ/uhQe+tCTHQpOK0FaJ2ELOAl455sjcuttrbWitT3msVvXyAxzB7SU5GXNkGC2/v0xSSKul1RDzDjl5fbQ2LLMS+lDz6P4gzESAd7Vz8YkXT0mZEhfU36BRDUQLqWofFTXrNFdEkJPkxuFKDqspOY71Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 03:09:42PM -0400, Liam R. Howlett wrote:
> When the dup_mmap() fails during the vma duplication or setup, don't
> write the XA_ZERO entry in the vma tree.  Instead, destroy the tree and
> free the new resources, leaving an empty vma tree.
> 
> Using XA_ZERO introduced races where the vma could be found between
> dup_mmap() dropping all locks and exit_mmap() taking the locks.  The
> race can occur because the mm can be reached through the other trees
> via successfully copied vmas and other methods such as the swapoff code.
> 
> XA_ZERO was marking the location to stop vma removal and pagetable
> freeing.  The newly created arguments to the unmap_vmas() and
> free_pgtables() serve this function.
> 
> Replacing the XA_ZERO entry use with the new argument list also means
> the checks for xa_is_zero() are no longer necessary so these are also
> removed.
> 
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

