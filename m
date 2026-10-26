Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7330F606A322
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 15:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=krmv0XT6;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=SRMCjd4a;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=HLZOSbie;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=i8OyxSiO
Received: by kanga.kvack.org (Postfix)
	id 880C76B05BA; Mon, 26 Oct 2026 11:49:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80A5A6B05BB; Mon, 26 Oct 2026 11:49:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FA746B05BC; Mon, 26 Oct 2026 11:49:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 481856B05BA
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:49:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C828C14079F
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:49:03 +0000 (UTC)
X-FDA: 85365210966.24.0E0870B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7B85640008
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:49:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=krmv0XT6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SRMCjd4a;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HLZOSbie;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=i8OyxSiO;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793029741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KlF69bY/nHZrbLTGbrUEwXS/fyT5+90IouYwTF+tbKY=;
	b=sse75USXyIAOM++Mrv9QwwGEDRlfiCHcup2vrQcbrj4kKk6Quxls25WP4cKpUFvxSLYKzf
	w5NHjzOIOHsXVdzJ3e8IL2s40ZkuCLGd/Gkx6GgQ12QnLt2Yf0z8SGjUbWhd8HRgeFFzr3
	H1WUtjIAlG0mdnyNC7b2qCG5raNcByI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793029741;
	b=guLx9HT+Q+BsnV4UvLJ5rG12+6HoCfnB6JttFR+z5VccQhjRmsu9Lw341BMdius82NAish
	jhGkHEwwXlKAiljK6aVmh9o9HIYMEDxC1n0roX8LoKk5ANlk5trep4q9Jpatr9+wpjA3dl
	x7htlvHJzPcP6zxDBhlKUs5s2DnC0P8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=krmv0XT6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SRMCjd4a;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HLZOSbie;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=i8OyxSiO;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E01AE2227B;
	Mon, 26 Oct 2026 15:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793029740; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KlF69bY/nHZrbLTGbrUEwXS/fyT5+90IouYwTF+tbKY=;
	b=krmv0XT6wBZeSaSckvD2LLgRpMbhqBlmxXMtsiX1U7wAZKxmhDV0khHauaRPR0vNgbCAJo
	Rn/fuxNbdcNezMAW6lTsiAh3blGGuUzgSm0+IHRDIQYKeoAEXpHdWDMpmLZ6gcRObeSBhs
	QjWyuaCgs4p9elzs10hc37c10xAiiNA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793029740;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KlF69bY/nHZrbLTGbrUEwXS/fyT5+90IouYwTF+tbKY=;
	b=SRMCjd4aLgS6Y2HNS0yfrFrkDLWRRyTIsW0oIluh7yhwN9JqJp+MptlFj2jLMuiSBq1TqV
	smjLzLcwalHdUvCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793029738; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KlF69bY/nHZrbLTGbrUEwXS/fyT5+90IouYwTF+tbKY=;
	b=HLZOSbie8dHXdZ6uOMN60r1MBKv30Rz41SKSY5q+GRTzSRDhOHbK5wpgpB06zRgyNV11rt
	8UiKSogqQ7g8SrM/XZnNKNgKk/V8g1uyk1nSEYDIIvyMo2J+upYyqGT2GTC2Q8+QXYg/l/
	aYXyl5SbG9FD/yY32CnQT8xv0vH/Gkk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793029738;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KlF69bY/nHZrbLTGbrUEwXS/fyT5+90IouYwTF+tbKY=;
	b=i8OyxSiOdnmseqEyYZtum+5yGSziChO5J/OdLd2C5pKlJYqPXydnxgt3Mn7tKPkgMuTj32
	getWLnpB0miLjdBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B604B13408;
	Mon, 26 Oct 2026 15:48:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FLKQJGp232oqDQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 26 Oct 2026 15:48:58 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3FDFEA1419; Mon, 26 Oct 2026 16:48:58 +0100 (CET)
Date: Mon, 26 Oct 2026 16:48:58 +0100
From: Jan Kara <jack@suse.cz>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Hungyu Lin <dennylin0707@gmail.com>, willy@infradead.org, jack@suse.cz, 
	hughd@google.com, baolin.wang@linux.alibaba.com, akpm@linux-foundation.org, 
	dave.hansen@linux.intel.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] shmem: do not extend i_size when no data was copied
Message-ID: <xmp7ni65vbinfj4j2baisrhp6xzro3asbepuq7xp3mvx6maptn@r4dnoj63uw4t>
References: <20261025164619.89992-1-dennylin0707@gmail.com>
 <at9xXRhD2xZhszEj@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <at9xXRhD2xZhszEj@thinkstation>
X-Spam-Score: -12.80
X-Spam-Level: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7B85640008
X-Stat-Signature: njju8me66b7zmdfz5tathhcwxyx4q3wb
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793029741-498384
X-HE-Meta: U2FsdGVkX1/7Uol/8uFKOtYnWA399LnEYR5FEP5+58GtyOWtRBjP8XDj9jD5kNz/f+UA54QAYRqrDpohMV4aOapS+x7QMBt1FAZgTPyw04jGNsSabJX0YU4nK8laZGLf8Nz9bicTvhHfma4wllttLjFUlg+cw/70QlEexGS8Nc882Yq3ODpSB1MTu/JpYtqgYjg1ct+ofznZJoexzxh61AXx7GKvW1KyPvQpYcZ0sSrPezWO+8QnJncp3gPGCAn1JjvpxQU9KpXf49AXftcTKaRFjAcuqOjmDUpyaqTchKkzGA/PSvETUxBDx0zqJVSBV8Mzs1R2ay7Cb6k/ifCQFzPQCPdzig5nKdF0LtPjxrqsC6KQR46mSe1j12inzG1KfYTJnqfsWSeRMFluA0nvaClPMSKvmy7/KI3cerrwM57jLGxz9Gkur8WtIYzLo0F1ycLeF6WTV8yeTAGZpyKOvq9VWzLw3O7WwkB/7u+IPjWX3obOM3hY4V65+OQ690/gTpm6BEp4u8ZDxaXtgMqSUSNED1Dn1BoD0PS8THNcSkdssqP+s0Bq56kqw7krd7SOsjbkA5rdrBwdPt1KE/TmjmzvJJIeaJn2Psu7I8iDFkyd0MX28CFkyU7R2HVsM5UbCl90ZB7dO1iPYuDqUKIdvv4fqOoFnen0JFD5AW6F3LcovZd8Fvz5h9MzRGl2ySJUXSxEw4a3YS+kdLhVeQvYjj7320OXMADjI20t/FwEV4FML9nUoewBq35jWEtWHBrZB1rPM/a5VgLY2PcTddYMqlW14p4y58dUPa1duzUyC1kD04WsY0GnrbmyZxYry/tipKIwEEQ6RQmeQCW2rpXlmLVVDhiv4AZ2nuRUxD6Zvy8GzSh4jiuC0X8EXiDuw68HaMV2aPdlN8B0Q/6cK9simxacgRc2kqEJrOFoySU2p/0BdnSqaEFnVwad35fFe9ZjHDVq4g4bEysOjdosWlC
 swmCxHe+
 o5BSP//ftSDJ3Prv6g6nWjglABXn4qXLn4V1jNwZMeLeqmwBIkDS4A2VyABMRu4jojbrUIwQJTRYeUnfETR6eBol3eIVN+Ee6SV5PCa7Fg+sDxj6xH2YzLTy2XFdzVhN/agyouZUVRveVHJltPYiePQxpnb6PhWzgX4SIkfD5r0FsgtfYYDt+aQmCTTExdVCPQZJr/+0YMA/SL2i6KdrFcnZWxCIJy/Uvwz1kxK8LnrmgeBi0ONZS3T+9vBLXdWV102Kkb8xoYvvW2Vj9mrDXahNfYHm/V+1vR+vbHeCjMho/pi4ZZQdYhitKz1Yt64dupFEw4z5AiA0UGxZ1g1ejUPXdcsjgKQq5BK9QbiKH7zF8eNfj8DqhhPhNPp0Ca8Q/tjHA7KSFC+EkygQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 26-10-26 15:34:08, Kiryl Shutsemau wrote:
> On Sun, Oct 25, 2026 at 04:46:19PM +0000, Hungyu Lin wrote:
> > shmem_write_end() advances i_size to pos + copied even when copied is
> > zero. A buffered write past EOF can therefore extend a tmpfs file
> > without writing any data.
> 
> + willy, jack, fsdevel.
> 
> This doesn't seem to be tmpfs-specific, right? I see the same with ext4.
> 
> simple_write_end() and generic_write_end() check pos + copied the same
> way, so filesystems that use them through generic_perform_write() are
> affected too.
> 
> It makes me think maybe generic_perform_write() is the right place to
> fix it. Hm?

Well, that would be nice. But how'd you like to do that? i_size update is
the responsibility of ->write_end and we have to call ->write_end if copied
== 0 so that is undoes what ->write_begin has prepared.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

