Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5118C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 12:05:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 963956B00FB; Tue, 30 Jun 2026 08:05:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 914366B00FC; Tue, 30 Jun 2026 08:05:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 804AC6B00FD; Tue, 30 Jun 2026 08:05:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 442166B00FB
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:05:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CBA321A0481
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:05:42 +0000 (UTC)
X-FDA: 84936449724.15.0310AA4
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id 721A8A0009
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:05:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ssb8Laqy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CXix7dh7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iC+oWmZD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="vhif/LMX";
	spf=pass (imf25.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782821140;
	b=XONYpZ+a3sBTw4HYlGlFIv5rYYsESLD1bstdxPBGKrMb8LKaorGlthxfLgn91hxHr0DizQ
	smUnuuPjHHZISRMMTlsYfef1Fz5S6xtaDr/2JMsxQqt7X+qVckC2TQSDXea7bs9Z3Hoi7/
	nSyXdjog5usPSe5y6hAYMOT0u82p7rg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782821140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r6qeYl5QdWsqI+hopgAOLmohwbxl23aNjL7MQDQYJm8=;
	b=2PxCCCuakBagEWGHXi69gcr57urTjgBfY82j34xCED0R48d5HiQY4dACdNqjNAVpFfYoz2
	o+Rd5uMQeIFuQliObZdUjIB17PNT0zutsQx92RyS4Ij4O/7INmPx0jVY9Sey6130IjDzIt
	WdGDPwTUXZme6a+qx+GLx99ODsiV2f4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ssb8Laqy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CXix7dh7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iC+oWmZD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="vhif/LMX";
	spf=pass (imf25.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D1CA571A01;
	Tue, 30 Jun 2026 12:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782821138; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r6qeYl5QdWsqI+hopgAOLmohwbxl23aNjL7MQDQYJm8=;
	b=Ssb8Laqy/DH8yJevDGsofF+FkMfbKxppLq3zzL75AnwBUMgmCassqeJSC1bur4Fx+9Cxc0
	vXBHz9v0ZQjnk7JYEyBLTeaOLPQzSs91ArHwCimaJnoPWpwb6GJ1VX1UhkCKrNjo18HdBD
	vzT8fg8Y4fkT6/jDoI3dJQv6hREKqrU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782821138;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r6qeYl5QdWsqI+hopgAOLmohwbxl23aNjL7MQDQYJm8=;
	b=CXix7dh7ivvnopTgFv7snhSI+17JyWsMEa/40afS4xKzqU8JjKa0E3QlYlZUbCk4R2Lbv9
	ajtbXLcaLohjaeDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782821136; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r6qeYl5QdWsqI+hopgAOLmohwbxl23aNjL7MQDQYJm8=;
	b=iC+oWmZDdRvrKhlZfLlXoMQm++41AY+51Zp5mProfKqDC4jq+3rxYTBmngb6VdF2obC2uc
	t16k/ixaIAi414I3UZcm/9Cd2gEwxfTtpQ+eyq7HKkw9sNfYRWZeUiTGNn/uX5RWn7MVzZ
	n/np9tq5k02gUBIz9QSJG9xf/yVC1K0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782821136;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r6qeYl5QdWsqI+hopgAOLmohwbxl23aNjL7MQDQYJm8=;
	b=vhif/LMXhIUzPz8RC4A6mfbNxF3PA9ZSv1E7t6ibGANjjwoebxfAdYAb0dblMSkCE/ENsk
	rtv2iEbDZFHDwuCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BED06779A8;
	Tue, 30 Jun 2026 12:05:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fzGMLhCxQ2qkbgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 30 Jun 2026 12:05:36 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A1B67A10B7; Tue, 30 Jun 2026 14:05:33 +0200 (CEST)
Date: Tue, 30 Jun 2026 14:05:33 +0200
From: Jan Kara <jack@suse.cz>
To: Zhen Yan <yanzhen20011121@163.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mm: fix mapping_seek_hole_data() overflow on last page
Message-ID: <tikbuxxazkmz5obcf6llp342vn7bi5tlgbbnuliw4jlwndj63e@jkp5g5oj6ug7>
References: <20260629164932.b91930b0497e8446a2a549d2@linux-foundation.org>
 <20260630031226.3141360-1-yanzhen20011121@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630031226.3141360-1-yanzhen20011121@163.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 721A8A0009
X-Stat-Signature: x8zgfyy9zy4ttm9x1cc3ppsad9oiknzb
X-HE-Tag: 1782821140-962582
X-HE-Meta: U2FsdGVkX1/67TV51csQa7rW4j/UU8r48d3knaaDA/119RC6qGMSCe2Ap2hBR2hc047o0T8xhS11FpDCpoDclIvzIu4F5J7clmRPHwvv9c2qb4AnH4hj+hOTzCf9KnHK+zZDlhL3qhvPWA2Jjc4WiQavXixtqlNZZglB22szGIooylLo/jjfmi9qJ78kzdqAwGWxg8ltl+xm5nn1MEoaZpWgHW2b4x7w0EIyPV/33ORAK03wNR00+xy73n97wD6CpS5aA4pmZPcKy+CqgjbrkX6elw+Sw/oNiBaL1VOsNCjiWVL567KvByA1yieTaAsMUkdsTu36Ld5d7s4hrOEl1yp0XTx4oHGI/l9+zRn8InTsPmsaqI03A2KxQh24aRjqFPz2UuZcPQjJiGfyXUoCBLUxwxuCi6UKLfkg6aCt7S8ECrZYmQ/E58R/GTwNGJnfyO3cb6GXaO2ario9552prznStoQvbjjrmmkY8Te0vnu0JvYF5JWJb0cpdwul2fZy5I5GioNNaHoxuvurEJ28T6a0r558nUaz41MwFeDNdt+ADOWEuJT9OlUGnRYmaok7lAgJoCCRlis8rVhpiyLFYZZ2irJinMlXkjo5p7T8dhBh6/iCsnV88Ed0EmifeqTsaktP9Xmb98/t8CVyTcRPROGWVfJ2ipeRjUZgIJu6V+EFtNF4RXPl2VW5JbM933q6aVan1AEJlRTzDBKS641cXjRJ+dLhEE41KVxIW8qHlJMamgbFxuLBq5mzEQy/iegDXyY48Xww2+7TY6rPh8Inuzf2OCmzy1gg8I9+1NmqKjVygOqTY9ezqFe1iOcEHoTCkq/AhAiwUMuAJIpd7Q0CHfH6rqIivU3Qlk/t+uBpQ3qrcSYHA/5gZh2pBAim3I4DYTTRAU1r0CBdtU6b4xsmdLI/QsubfZ9pdtnWaSQ3RL1iIy6R16uzhovAUbjoQBXWeqnQRhpVAXqQ9cLrtsi
 Fr7S07t8
 0e3F98DQYuLkOZp9zuQJAwVENX22EBCU8XwdWw1ar5PfsnC834H8yMZ2l7jhBt1oruMnjTWa/ZeVby/vWIrDq9uwITta3sVJDQRpxigOtvH5YaCRm0hrO5z8t8isv1v4Opw3ayKhDX7S1hZSNgi5qfYXOa02KUCsd7XV6/IPyjWxJRSkLV6OfZx+xmpe4W7NmgiDx299uc3vc0ecoIc2cqjJUHnzjzZJYwZ/IWGamLxoh33h52DBP3Cnz7UZw5QxK5hlZmEedcqAP3e0dddv+3D6wPYkweG4Ga2rv9t48hdMvco4vnFcWU7I57JG4Fi/0KiE9SRPMaS7EEz9HF1xe0dfExnc0Qxg2c/ADpsASCvxXyd1B35FfW46+oUO2/ujynpS8RfcC0QSj7uhbyBCDUVx4Qi/wb5AhbvwH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 30-06-26 11:12:26, Zhen Yan wrote:
> A local unprivileged process can create a shmem/tmpfs file with
> i_size == LLONG_MAX using memfd_create() and fallocate().  If the last
> page is present in the page cache, lseek(SEEK_HOLE) on that page
> returns 0x8000000000000000 as a successful offset, which is LLONG_MIN
> when stored in loff_t.
> 
> The same file has readable data at the last byte, but SEEK_DATA from
> that offset returns ENXIO.
> 
> The overflow is in mapping_seek_hole_data():
> 
>   pos = round_up((u64)pos + 1, seek_size);
> 
> For the final page below LLONG_MAX, the next page boundary is
> 0x8000000000000000, which is then used as a signed file offset.
> 
> This violates the lseek() ABI for shmem/tmpfs: a successful seek
> returns a negative offset, and SEEK_DATA can miss readable data at EOF.
> Hole-aware copy, backup, and sparse-file scanners may skip the last
> cached byte range.
> 
> Keep mapping_seek_hole_data() inside its documented [start, end)
> search range by clamping the rounded-up position to end before passing
> it to folio_seek_hole_data().
> 
> Signed-off-by: Zhen Yan <yanzhen20011121@163.com>
> ---
>  mm/filemap.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 5af62e6abca5..22a1534ec8b3 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3234,6 +3234,8 @@ loff_t mapping_seek_hole_data(struct address_space *mapping, loff_t start,
> 
>  		seek_size = seek_folio_size(&xas, folio);
>  		pos = round_up((u64)pos + 1, seek_size);
> +		if (pos > end)
> +			pos = end;

So I agree with your analysis of the problem but I'm not sure how this is
supposed to fix it. If pos was offset of the last folio - that is
LLONG_MAX - PAGE_SIZE + 1, then round_up() ends at LLONG_MAX + 1, which
readily overflows to LLONG_MIN (pos is loff_t). So pos > end will not be
true and nothing changes. Am I missing something? So I think you rather
need the condition to check for something like pos < 0. Or maybe use
check_add_overflow() to make the overflow checking more explicit.

								Honza


>  		start = folio_seek_hole_data(&xas, mapping, folio, start, pos,
>  				seek_data);
>  		if (start < pos)
> --
> 2.25.1
> 
> Sorry, my previous email may have been lost due to network
> filtering issues.  Resending the revised patch with the
> requested changes (tabs preserved, CCs added, signoff added).
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

