Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87E13C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 13:27:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 648656B00A9; Tue, 30 Jun 2026 09:27:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61FFE6B00AB; Tue, 30 Jun 2026 09:27:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 536AE6B00AC; Tue, 30 Jun 2026 09:27:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 189AB6B00A9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:27:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A07D8C1D1D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:27:29 +0000 (UTC)
X-FDA: 84936655818.21.E505DCE
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4656814000C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:27:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=s7KgrTfb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=p9Hqkt+E;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=s7KgrTfb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=p9Hqkt+E;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782826047;
	b=yb3CCjG6Wfy8tO/YhcDT4lKf6ZblrUtcgUkyHnibnaLXeXOKBtRQb2AewcNwB6WXqd7LMb
	aNG3tog1ZAVMdRB+oYdneDMQfFinlFJCmtPhseKq/dz7//ug1/U3FXN4C6V32XVuSYhsuf
	nJhEQ+S4HBM4ivh96YITDYgKqlFJlzs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782826047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4EohyzSqi61XNm9HTErvonNu/Vfwe4QH4QFsyqiBSeg=;
	b=2qeq2hggL2MoRtQ2TahU+bYLZR/0y0g7eKxiWvB75r0IiLXgWRPg5OsCM/Nmt3boIDRIz4
	ZUCZo6tkdYWOGJ72/UNSlBAY7A0LDP5p/20HHwuIHwe/FDabHK/QOGj/VaG1UoMJkXPTch
	/veNfucIkxcY1cV+FTgElqlNSXzhe6M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=s7KgrTfb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=p9Hqkt+E;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=s7KgrTfb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=p9Hqkt+E;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B891675DEE;
	Tue, 30 Jun 2026 13:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782826045; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4EohyzSqi61XNm9HTErvonNu/Vfwe4QH4QFsyqiBSeg=;
	b=s7KgrTfb1lBuC2JTCht2qO194h+5f9v4Vld4r4855ctAu3XCjYe1M3GqLtlimJaYtM2t5s
	haw+QzH/gRSlxC01p7tf3rT1Yh+7ErqGOiQo/vbORjPKfkBazNIbShgO+z1zn9XY/nyCla
	oCKI/uMYhqeNXXyjzHXdzQoX6IMz3Dk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782826045;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4EohyzSqi61XNm9HTErvonNu/Vfwe4QH4QFsyqiBSeg=;
	b=p9Hqkt+E/w/gUzXuhwFZgO/ysZQSrBOBn6Cg6gHT7Xeg6Ii8k1sszcVjj7p6gGPftP+sK9
	skv4w+kP5F9adCDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782826045; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4EohyzSqi61XNm9HTErvonNu/Vfwe4QH4QFsyqiBSeg=;
	b=s7KgrTfb1lBuC2JTCht2qO194h+5f9v4Vld4r4855ctAu3XCjYe1M3GqLtlimJaYtM2t5s
	haw+QzH/gRSlxC01p7tf3rT1Yh+7ErqGOiQo/vbORjPKfkBazNIbShgO+z1zn9XY/nyCla
	oCKI/uMYhqeNXXyjzHXdzQoX6IMz3Dk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782826045;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4EohyzSqi61XNm9HTErvonNu/Vfwe4QH4QFsyqiBSeg=;
	b=p9Hqkt+E/w/gUzXuhwFZgO/ysZQSrBOBn6Cg6gHT7Xeg6Ii8k1sszcVjj7p6gGPftP+sK9
	skv4w+kP5F9adCDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AD6CB779A8;
	Tue, 30 Jun 2026 13:27:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iT1OKj3EQ2pFQgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 30 Jun 2026 13:27:25 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3F97DA10B7; Tue, 30 Jun 2026 15:27:25 +0200 (CEST)
Date: Tue, 30 Jun 2026 15:27:25 +0200
From: Jan Kara <jack@suse.cz>
To: Zhen Yan <yanzhen20011121@163.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2] mm: fix mapping_seek_hole_data() overflow on last page
Message-ID: <hhrt7iy4rgv33wxghhhwryiw3jjgorvmbw4tvxenhmin7z52z2@njm2bn273f26>
References: <tikbuxxazkmz5obcf6llp342vn7bi5tlgbbnuliw4jlwndj63e@jkp5g5oj6ug7>
 <20260630125047.703170-1-yanzhen20011121@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630125047.703170-1-yanzhen20011121@163.com>
X-Stat-Signature: dgsb93j8yaks96wschi7t57886rgjzh9
X-Rspamd-Queue-Id: 4656814000C
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782826047-301641
X-HE-Meta: U2FsdGVkX1+uyUF8RU5w4pe2ChDqCvcPTMRcr2/1CvyDQviVXUiEmU+xXpCi9wc5GCKI/OBhwZ0/zQlQgB6WVvovSTks0HlcIEzekWWjKCvzl1yK920/K6jykrSEdWHxy7BQHg2ft8ALQxv3TjWpJaRbn8lRj8jWKpQm2TMBj2ZqkeTqby9ImzQGHz7Pq/RKD3/hZqaEUefhj7z1JBL7SiP5icHgmsdXnYWcHHXtmrJiKUfAbOVuyCwQuhhp+tkyYELX9En5M98kqxHfRklhX7pqKyoFzQyytPHi9em7cpvXuKk5TcRvrBOiMbzbB97qs+5sZZjp41FTyFiYOXZkvXMJsc9d906RSdn8l+c2bIGdFAjs6wd57z1ittD5c3PWG3Hhl6UNmzFm5I64jURoZXgPPm/5dWp87O2IDzEZ+T67O+ag2J8Km9JvdRuxM7ijP0dqLpYxzJKxTszscLuAqZF3F3R8F6rAb2fnlu5RoHhuAMCS1rg9oRNXkjeBjthx1WC5fqwd1fO1MsJQdOVbij/virykXOtduCxXfySHMuKa2qU0K2CXjBqJ8WdKqa2c0epX4Io3dChV7nfn7miF4Kc/oCqAmA7iMgBG/rFETfD9XQ/bba2f6o6/7Fv6sQ9I0LexedrEKLiTpgxBuuUHoYBZDGLAt/QrCtHXBXwlUOtEHROnbeNXxnUlr6EC1o1HAoVZQVjHzzgx3WiShdEnr+0qjdsO7BYXUXGaoD7wGDlxjRtsrR3IjFea6iHIk5hJqlEmJMTE1mPiwYcwIft9zkn1xs2fQmTHKBCNawdv2rKf62p1JoX9nvkpa29l3o42SiUMSPNTGATZNIt7Eg3pocb11ESPeu7tn9AVjRneKpynzxd6tfm5+hL2tFPvcCu+zv0pH2kLzG1MxeVbbQPyLDdvX+sNnlvMsU7qhJCvsftISKcwTjJR2YoYP9+qFVG8sKkJT3TLnmyWFBwNzpv
 +kb0uzPq
 +nK/vq2fnHfYSiGGfuITHd0A/ASIokYizd6MSns9UnaMO7qyNCD66MjhrV5fUA5bfXF1SaHarkEg2Q1xKlXPHddxOp4WtIk73N4Nxb2o0kMaJrWdprpMCcNGcZiuXGGrE2F0NEJ9vy37Fz5M+60hNxlkgAIYAaATPHQ5wJKwU8ReleUzNbU9KWZqktOZ6DZqxxrCKZ8GFnODOKWNVDM0/4k2LB8BfWhh8ZX/hcokXBT9Oew4j2Dsw6wEUIBXvCIR1dZ4EWwmo7H8CHyXZclVobgQsBJ9J/NfM4CVParv8VjY9o60VeKh+3WLfdPXQ2AzLo7xG5mtck516G6XkOJb5bIwosKtlIIcqK8owhUhCbCRR0e0wZhZed5M1IAcHDfhbhDfJc2Md8wdlGlNZ2XXAekQNgQx3hianiHIi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 30-06-26 20:50:47, Zhen Yan wrote:
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
> When assigned to the loff_t pos, this overflows to LLONG_MIN, so
> a subsequent "pos > end" comparison does not catch it.
> 
> Keep mapping_seek_hole_data() inside its documented [start, end)
> search range: compute round_up() into a u64 variable and compare
> against (u64)end so the overflow is detected, then clamp pos to
> end when the rounded-up value goes past the search limit.
> 
> Signed-off-by: Zhen Yan <yanzhen20011121@163.com>

Thanks for the patch! It looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

One small comment below:

> ---
>  mm/filemap.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

The explanation you've added to the bottom of the email really belongs
<here>.

								Honza

> diff --git a/mm/filemap.c b/mm/filemap.c
> index 5af62e6abca5..b78fd88f2638 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3225,6 +3225,7 @@ loff_t mapping_seek_hole_data(struct address_space *mapping, loff_t start,
>  	while ((folio = find_get_entry(&xas, max, XA_PRESENT))) {
>  		loff_t pos = (u64)xas.xa_index << PAGE_SHIFT;
>  		size_t seek_size;
> +		u64 next;
> 
>  		if (start < pos) {
>  			if (!seek_data)
> @@ -3233,7 +3234,11 @@ loff_t mapping_seek_hole_data(struct address_space *mapping, loff_t start,
>  		}
> 
>  		seek_size = seek_folio_size(&xas, folio);
> -		pos = round_up((u64)pos + 1, seek_size);
> +		next = round_up((u64)pos + 1, seek_size);
> +		if (next > (u64)end)
> +			pos = end;
> +		else
> +			pos = next;
>  		start = folio_seek_hole_data(&xas, mapping, folio, start, pos,
>  				seek_data);
>  		if (start < pos)
> --
> 2.25.1
> 
> Sorry about the previous patch -- the `pos > end` check was wrong
> because round_up() overflows loff_t to LLONG_MIN, making the
> signed comparison ineffective.  Thanks to Jan Kara for pointing
> this out.  This v2 uses a u64 intermediate variable so the
> overflow is correctly detected.
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

