Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 799E5606A324
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 13:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=baI+UOMl;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=7pHTPEqS;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=baI+UOMl;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=7pHTPEqS
Received: by kanga.kvack.org (Postfix)
	id 4F28C6B05B1; Mon, 26 Oct 2026 09:34:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CA436B05B6; Mon, 26 Oct 2026 09:34:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E0236B05B7; Mon, 26 Oct 2026 09:34:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0E72F6B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:34:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 527F41207C2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:34:51 +0000 (UTC)
X-FDA: 85364872782.07.EEECFCA
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2A7A81C0006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:34:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=baI+UOMl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7pHTPEqS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=baI+UOMl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7pHTPEqS;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793021689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4UlIvTTjkwmlBrzOjLPzKgJbLMN24EsBnbSBGjdQ+TE=;
	b=cEb4cblI4Q/b36ZC+o87KDHzpRBC0trojQWPwtzAISXwdfGKThYegfPOqVHfQnIKu+agW5
	Bn16onrxlNp11BGL2psOYw0eCyo7Cwyle6Sfi5FB0pRJX3NF0/e8RNJpkJOIIi3+tV7eqY
	WxEzrtbYCOgoVlQKvPU/FZPUUCWYsKM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=baI+UOMl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7pHTPEqS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=baI+UOMl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7pHTPEqS;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793021689;
	b=zrPJNTvo2qbIYXQVEoITIjcakTYEKUhBvv3INr2JIiAMntbzKImeH31GdTSi3BXEoNVZT2
	28P2bQvDqt/Y4NbXDDgHzg4Jld0ZHdqysQ0DPOZiYMERTTccMTKKWiNZBpzYDWsr9z60lV
	oia6E2MJuSoD8gf0A2CZSmsjXwHaBfU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B845E1F7A1;
	Mon, 26 Oct 2026 13:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793021687; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4UlIvTTjkwmlBrzOjLPzKgJbLMN24EsBnbSBGjdQ+TE=;
	b=baI+UOMlKVAy3SWCcAr98EiYZLZvmrWlccCTf02DOWVOrnJX/ISyma56FnRwTFbfuCon6h
	lx/tzrp4GMc1zXOWaDywKiyMLCCR7zodJecV0Zdvx82R9Dp0z4l82nnID/cBxa+Pz+Uq+c
	QMOerZp32U/ZYvdRD6F9awM2TMH6IuE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793021687;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4UlIvTTjkwmlBrzOjLPzKgJbLMN24EsBnbSBGjdQ+TE=;
	b=7pHTPEqSTCXYGCNfP9M5J0/15pUqHHP0l/X4U8Nb4FAiZSRQLT/xF1CGaS5QDMbQNLb2u3
	QKVaoBXGziMD4sBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793021687; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4UlIvTTjkwmlBrzOjLPzKgJbLMN24EsBnbSBGjdQ+TE=;
	b=baI+UOMlKVAy3SWCcAr98EiYZLZvmrWlccCTf02DOWVOrnJX/ISyma56FnRwTFbfuCon6h
	lx/tzrp4GMc1zXOWaDywKiyMLCCR7zodJecV0Zdvx82R9Dp0z4l82nnID/cBxa+Pz+Uq+c
	QMOerZp32U/ZYvdRD6F9awM2TMH6IuE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793021687;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4UlIvTTjkwmlBrzOjLPzKgJbLMN24EsBnbSBGjdQ+TE=;
	b=7pHTPEqSTCXYGCNfP9M5J0/15pUqHHP0l/X4U8Nb4FAiZSRQLT/xF1CGaS5QDMbQNLb2u3
	QKVaoBXGziMD4sBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8B7D3134EA;
	Mon, 26 Oct 2026 13:34:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id G4pgF/dW32pJfQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 26 Oct 2026 13:34:47 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0753BA1419; Mon, 26 Oct 2026 14:34:43 +0100 (CET)
Date: Mon, 26 Oct 2026 14:34:42 +0100
From: Jan Kara <jack@suse.cz>
To: Saleh Mammadof <salehmammadof@gmail.com>
Cc: linux-mm@kvack.org, jack@suse.cz, hch@lst.de, dhowells@redhat.com, 
	linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: Re: filemap_invalidate_inode() - losing -EBUSY from
 invalidate_inode_pages2_range?
Message-ID: <o5sj6bswd6arkusrxj5w5ww3jwk5hz7ktzxvdik72h7c4uen5i@fnwkmk6hvuf5>
References: <CAKu0nJUGwnmuuT6fBz0phH=1Nyi6BguH2PHvs9+hDnrc_X0zWw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKu0nJUGwnmuuT6fBz0phH=1Nyi6BguH2PHvs9+hDnrc_X0zWw@mail.gmail.com>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -12.01
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2A7A81C0006
X-Stat-Signature: x59h6fphxgwum38oxateooeuxjpkq3bw
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793021688-603355
X-HE-Meta: U2FsdGVkX19vtIhpOdcm5cT0AIqRsWU3OoapQYEV02iAnhAzMhza5tJG4DouyvHBxiGRONdW2RGw28K0Z5k5dHcS+rKuGDPZ0iJcA+VZKRxHqo4NpHbzLXGWZ0GEo4y9hJFsRVxkaKzjgeI0J4fZYVrti6CfiyqKkgOSL+iIkaXVfo/3FF0c7qqc6v5xZBRtbrZBMgr5FcSCZ4EPSHR8h6hJIj/sYXtFqUHT7QRfyr+LlZkClPOCXKtJBix5UENWSUlWIP9AkE1bRY++BHAGC+px4ATP+8pacctD3Xx5LPxPDHfm9MjU4KtVnEYEv2FjBtFSlEEs54v2Qhi7RCY2fwLpgcuiKJMYgk4oyiuVVcolfSFGLUGziBicJCjn9/2noUOyIQxtvsdE8oycOjT4mkLqDHlbKccDL9HmvIPsMK221GsuUpKNjIk1LiWbX5dK5xdXjvJ/0f5NlvQhID0aX639cbwY4XRYaDHRgeSPxTbyaPRf1TB6he+mKe6hwOmHkf6ytWRKYDXglvBrE2DbT4bUxjnNwx2HrvdKvXJTxufwzK0mmaCZWw9/sijurdSgdf6RwwnRcNIicKpx6NqBDyOaJWWg9cVl5JPmmeKVMAcw4PZkxOYVzkCK/0m+jTJl9jinJTae03CVtybywmHhUFySUDjen0uSeayO3p3PcFZ1oZnCTVPPoh8y9HaOlUECVZAZi5LNsdlMToetWVDswapDXSmgHoX5QG9veI2uAcpSryFPZMSxAHK2HcEpB/CUVkUaR7NLogoQBEc7WcqhCcnHG/iRbgI9u7HGofGNo+QcjZjyfIDgDXe8/chjVX8/h3PfYYTr4l2EIZ+c3ppLEZiYGE/ZgK5Sv7GnDA9HLfHq5ufaP7t77eiaEEV5YL/Xq9RcPEdI0GhyQ3oQd+ct1pVM756JvHiZc1DaXfL6vRm2RG8qgmrklz7LhgFVX7KM/R/DnN2CGpB0UW4kQ+u
 Y1jFlJ9b
 yrKBCq+5dkGgsAocqmf9NtCDw8IlIDkf8Q0hfF+R/c5FlghE8kLWDoYKcUldl6pQw5f2dhGzjpK/UbM1smY+qo2SBJogcFqmz+8pV7zizNhsDbmhqClArNxLbI2BsYT7zJOa7vssyohD0KbJMj0mKHmNzgz581NRMtJLdxpaKoonSui8hwVUvBxlWlqVGuJsBuDIkurkBjmR3Cj4i4hVujfOj2umvz2pzxBHicBemCnElsbum8mXyB7/28setS18OHkg3iB/Q8TUbK4vqrMhgHArDJoiDGEd7LC4CT3rTZ2AW5tcRYcg2zIOKwHw4FcRDfBFGxq20+naOy+pkPObzDBh9AXiqxE6GGyhEZ2O6KtlofDcYAxCUTlSBlncsVTu+W/vBaoij4cKbxWZeY8M3ClbS6bCdobWLBoRpJ7GLieGZe1KWSir1nuTPBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi!

On Sun 25-10-26 02:27:13, Saleh Mammadof wrote:
> Been going through mm/filemap.c lately and something caught my eye in
> filemap_invalidate_inode(). It calls filemap_fdatawrite_range() (or
> the wbc variant) and then invalidate_inode_pages2_range(), but doesn't
> seem to check either return value directly - just falls through to
> filemap_check_errors() at the end.
> 
> The thing is, invalidate_inode_pages2_range() can return -EBUSY if a
> folio won't evict (release_folio failing, launder_folio erroring out,
> folio going dirty again mid-invalidation, etc), and filemap_check_errors()
> only looks at AS_ENOSPC/AS_EIO on the mapping. So that -EBUSY just...
> disappears?

Yes. Whether it matters or not depends on the caller I guess so you should
discuss with the users of filemap_invalidate_inode() what they'd like the
function to do. Adding btrfs people into the loop.

								Honza

> If I'm reading this right it could matter for callers that actually
> branch on the return value - btrfs reflink bails out on a negative
> return when clearing the destination cache, cifs sets
> CIFS_INO_INVALID_MAPPING again on failure, that kind of thing. If they
> get back 0 when a folio was actually left behind, they'd think the
> invalidation fully succeeded.
> 
> Could be I'm missing some other path that catches this, genuinely not
> sure. Haven't tried to reproduce it, just going off reading the code.
> Let me know if I'm off base here.
> 
> Saleh
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

