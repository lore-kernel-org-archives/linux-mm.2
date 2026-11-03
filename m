Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A001606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 19:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eCs7Dm6F
Received: by kanga.kvack.org (Postfix)
	id 311CF6B00EF; Tue,  3 Nov 2026 14:57:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CC686B05B1; Tue,  3 Nov 2026 14:57:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E2666B05B2; Tue,  3 Nov 2026 14:57:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF7BD6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:57:42 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 431B21204C6
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:57:42 +0000 (UTC)
X-FDA: 85394867964.25.367259D
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4316E120008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:57:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=eCs7Dm6F;
	spf=pass (imf29.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793735860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+KvUAdd82A2FrfHcfd34zVZTNXZ/zNcTHH3fL0iHdhE=;
	b=TQtmQS0hO2W2VeYJjBuCEpsxwk4YjUWh6zua+xRWUHPfglVV5NA732/VfW54AxKeNXJlQ2
	yu/YPTmcyE3kR1NnSs4/CnqgBMNzFZvwb9LrUPIPaj3dsM1c76n5laSdUnon/Pkgp+50Dw
	tcZ3+nYq/Uvmdz3BF7zu/jmLqSiOo4s=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=eCs7Dm6F;
	spf=pass (imf29.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793735860;
	b=xonIqQicFHNeDVimP494Zc67+0Up58vHgabzXbTRHu9UapAWpuSc3XzUt7TG13XKHC05Y3
	jjkXcTt4N3XXKokNgFPMt6XU5BTVenR6yUcI+XBGNXd8nb4c++s1BZbZ3Q0QICCDjsraUE
	s2tcj4C5qWvH7ZxPhkG43JhFtSnI9nY=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a60f9474c4so46105145e9.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 11:57:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793735859; cv=none;
        d=google.com; s=arc-20260327;
        b=Zf7Sa2KYHUxtcFnz+EY4AnkZAJAyUM9VXm2OAlu7Zse22h8NkwB0hCpOm/yy49Cgtb
         AOfhm5zr1v+uiRW7QU0AMUd3/fEvIklFek8XDF7BlDiGeSZYJa7ME5d396+odMUBhH0Y
         lNVapm3hpyyp5NYIZ496ELoUuZZWv7EQR1mwGTjakCl9ovPo+lvi9QdQGcHy5RrJzSub
         zHRlW90nAmQAXl4TWu/YZLatc3uwU3mGHhuhPDK5AB1kWR5xe7EadeW7umkCJ8YgThjW
         KuXHT9sT6+yhYTO4pmrUeB9Un2YSxacb0yjsrBxfn/bOfrutI2zI0vpXu/YKCayiIk8V
         UP3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+KvUAdd82A2FrfHcfd34zVZTNXZ/zNcTHH3fL0iHdhE=;
        fh=jBqJL7uLgh9FmT/UnRKDG5r57OIHwvz5VC6ay9c6LT0=;
        b=F3DOOtPlkA5Cac0VHVJ8ILG+qI+oQBmPo8yTRYlclhlTUQSgvTX9Kq+Ubk5BrBsyxI
         EgxRqYrWwEAemlZCELTroxi2UzsNBQ/qTeGiadfD/DsYT+Nl30WPNAxqkesgKy3ayu/+
         64nfJHa/irQN9cjcGCWVvA5sqzmgSmnJzqzZHPF4Y9x9q5lAZe1RsiZcsyOEtM9O3nLj
         Ch34HCCRBc5mxksOCbBmaLFvbecw/xIPHsqCRHiJHutQHkm/U1SVHXdUy4HhWjSs+6/G
         LkFFgjUm/NGozWb0vit+yGcZBM4+RFGtt/WHQ8D1biluLtu1Ilo9D05X6dixS9HeAWGa
         Gdew==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793735859; x=1794340659; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+KvUAdd82A2FrfHcfd34zVZTNXZ/zNcTHH3fL0iHdhE=;
        b=eCs7Dm6FEaqYwjJQb10mcNlpqBg3vkr757ImPeZeZa2CSwQjDcTHdxZX42+fWDV0Yr
         OJ4lRbcGiPngVxN4gWfdd2vQEN/heN3DtPAVSrwbO+kqH1IBSPDHBfllfeQHMfxZ80Xc
         3MH0a/RHFTqHN8yPLEFqCq8SerTAX7VecjO4GIO3vtVPRRbcMsQCbaRDY7eTuZhSYWmS
         EcSySqvJIvKHht1I6hrgnYuZ+mh1X/xIXWxKlFaiJ7hAdX3V3o0stuZi3uAv9R2/ETCV
         ZUEqsLTXFebhDvH/ihIgDfetQx95aMbtxfKsa23NRORPDLAO0W60dkhsdB/NkI2EDA2R
         AfBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793735859; x=1794340659;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+KvUAdd82A2FrfHcfd34zVZTNXZ/zNcTHH3fL0iHdhE=;
        b=0JrgJsiQ9HP7xSOQOK2i5vQ9qRBwcUtuRMuSb92wV/9RCqhsUrt7mEYXUinuVLNmsa
         JFhNJRlQYMFHJdbjsuuzVyXBoKxa1s+eBM+T2NVqAF2BcSbFXxomfYFMdrln4Klm62LP
         8lkV13ahVWSRshDMg4IyWGGbGORJgv/FKgoaX3GxBGspnYhGAS6+wdNsge/2lhupg6XF
         6RfpTMgJ4wnnbmQDh+vndc/AlkVCK2JOxf/xM3P5LlN5JKwX3DvXT0TyXcm0vMNohQmG
         uUXdtJkWPjXXG9SF714HtwvT5lxC3rtN/m+N8ESAJwX5tjUBoV/+r8HlpU23/gtFTRSr
         ZRpA==
X-Forwarded-Encrypted: i=1; AKwUvBwsgj3Q5APfudps20Q/L1K/a3sYpDotflC1DXvqbrj+gc1TgKUIO7Yxb4PpvHDgEtCp4qaM+9wxcw==@kvack.org
X-Gm-Message-State: APuU4Z92C79FlPnnrRNntIcdU/O5BpD26P3J/KT4NL4fbn050WNZ9uAU
	6p1P/Z3ISLnOo0j7MbA070P5BzSkfCisOCfkmRm2H06DHE04nOVTwJa6BzrrixPkh0PI568EgTj
	m5ap69fDrrmY5XVDX09Ip/yi3GUqV5xQ=
X-Gm-Gg: AYBFou07vx36FjlCuKor+uj6oIHAOZbEVE4nNRQ4YchnREXC0GXKmxRiM8N2Pn8HQOs
	wJ/QSpt6wNy3jhan7UZHxdiO9fUKDyTDS8tRNvxBxeILf0ZZ69O3NlZqZ2gF16Vnw/MDfLk/bv+
	sWnwOi2pNjUY18iJrDkvTF12iEU/oNj2G8D8PaCQzEtEadtp0XnsTXy8SRnq1DrT3dTcTJd0x54
	uMYI9WYR04fNrGuy7vi9IQc1GZZsevqxVEvRx4L1omoedQ66VZzi+W9Z3zvcbuVU4RZAmg5wxPb
	MB84jkxg1fcgHtd0RZ1XdJzVwVq7+9nJOPWDosjfnQfXTbKEFqrRXeffoq3b6unVOEt3LiQ5qFh
	z0EenMPGw1/4solhRdswvpXgeZ7DZzIDiwFMxaicY+RI9nZz55UU2YTIQxRc0ae6fTwBsctGptw
	0FNJFfD0s5Yo9oLHV80w==
X-Received: by 2002:a05:600c:8b54:b0:4a1:fa21:fd90 with SMTP id
 5b1f17b1804b1-4ac16bc547dmr344461405e9.9.1793735858729; Tue, 03 Nov 2026
 11:57:38 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261031070515.3042848-2-thnkslprpt@gmail.com>
In-Reply-To: <20261031070515.3042848-2-thnkslprpt@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 3 Nov 2026 11:57:25 -0800
X-Gm-Features: AclHuK_JytKkKfU5M6CJRcikf8vCv1-AjVOSiBNPYKxP4EvAaHLb1svGn_IQLNI
Message-ID: <CAJnrk1aJ32nWqoSLYBOhh6zhM51BMk5sCJGpZBOtNGj4A0iRUQ@mail.gmail.com>
Subject: Re: [PATCH] mm/page-writeback: avoid unnecessary strictlimit
 background wakeups
To: Avi Weiss <thnkslprpt@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	fuse-devel <fuse-devel@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: moosze75xt6yahjtrbz6arexwajb33yf
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 4316E120008
X-HE-Tag: 1793735860-330678
X-HE-Meta: U2FsdGVkX18TwK+q2X71OmbKk/kQu95JFS/YdZJaOzVkEyBCc8LpkTT1gQvdy/DuihbM2bpE1Nl/aFhKyWID0xE9y/MQ94ubO1diGAkrKsMuc3tfda+/NztGVPdAxBJ20RMoykTCkbr3xdPbmIXFuSFUW33iFNfkBR0dzarMbimsv8OodsUOrZ0rkN/2he5zp2MmXVUh7B5uB/amPbJUFdhgokKi2l05tdCTOJI3k+bwAVVkIZsOo+8magCh/06yqJb/WmPScIZWrcpaBlPjbmynmiwXFMsSc/sKspCm9VNkvd3b6T+5t3ccvZl5vu6jkUClW4lDu5zotHiPhfJvzWo7V1lSrDZkS4gr5ROyfD+HAFOkQ4SsZtofFLSAqQ/RtyS9LSb6HGzm62jTNnAcko3ZiXcuNFTYSoG0mSHY9zBcIZ0wYj0MinTh6cViMuoz3fCEcQbsQATmwPjBM7tkr2Nr/CRSoPmZmAtizf+kMu6OwofRv2nauCLgnAobCfP8CnvH+UgVwXiNmIAK3+FVfT+ysw9nCzPGtTK2aI5TOxuBKcGhUGeLIuC08r0dzUiCu+AtmMJUYVQGEOcuo+lmX1BYSnAXxncwKRguqk6vmvcYuf3N1liJGtL5hbTTCv2/Vph/xoGtW+daivFAUUEXQBvknDFhVKXKqpTpsx3ikNJfqCdU2pjWb/cuI4yHhVlS2QamVFCCmcy3mDNxbIBqz7po79JKzWhC0FJ7F2t31RtvMviBKZv4f8FNDv0imBXD6Q+hX+x+le/Cuo82YJJFcyu/S05GZiOeM94Gk1vfvP1PjVze/HHEhXO10hr5POJbEq5/NJWuXlqM8imdT8vkPePvQ6KPBuKgyqbOgCdOrVt1sc2K7IsrMtDuzVCJ9BcJqkjZ0KOOqkCrbZqWmjKgUbbUNTeqEX+1BS5a/1bIk2zFuUhh2Ve2lRBDfI5hlJOZn5yIflhqcYBK589MEpT
 FDghwajD
 B06T/d/UGkclKFcqQgRL1aqOw+E0QhoJpAFVmEXFXIbtUevjRKUHt2yVMuF+MJmNKk0JpEJ3sBHqhXIT2cU/ub8qDLTFSl1wI8UtjcApZLN0xrnhVk0XsBxSWr4lEMl8y9ZRUkixUKviYNimLz4iNjN51aENm4x4bs8yKKyuFSbwVmgZKxHQRDvK2Rbmy6QZG/NkNhALweHnj75sT50u4DEpmeNg0yjkjiv1Iji0UD2uUAD+i2kx+yAv3hquSNBougzlUNEQ4+AVewOCtlPuvTh2/2Kpue1gvGXdJmSL9vgnVooMZJG69sPNqMPARDj+aPoZkJLn/iabuRkJAW+PxuPtwnx9+WZLsoSDjKSEOfsDIP/ufEi9ywS1Dau6ft+FJPF6rsd3GvxTx+vbic6Xi9DVfgMpuSI7UOVWV0b8MFssM7QE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 31, 2026 at 12:05=E2=80=AFAM Avi Weiss <thnkslprpt@gmail.com> w=
rote:
>
> balance_dirty_pages() includes pages under writeback in
> gdtc->wb_dirty when checking the per-wb background threshold for
> strictlimit BDIs. However, wb_over_bg_thresh() only considers
> reclaimable dirty pages when deciding whether to start more
> background writeback.
>
> This can repeatedly wake the background worker even when there are
> too few dirty pages to write. In a 15-second FUSE writeback test,
> background wakeup requests dropped from 2657 to 682 (74% drop),
> while writeback_start events remained nearly unchanged at 99 and 98.
>
> Check wb_over_bg_thresh() before starting background writeback through
> the strictlimit condition. Leave the global background threshold
> check and the wakeup required for dirty throttling unchanged.
>
> Fixes: 0437906841d0 ("mm: start background writeback based on per-wb thre=
shold for strictlimit BDIs")
> Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
> ---
>  mm/page-writeback.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 499a35473e4f..cb0c58715b93 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -1826,7 +1826,8 @@ static int balance_dirty_pages(struct bdi_writeback=
 *wb,
>
>                 if (!writeback_in_progress(wb) &&
>                     (nr_dirty > gdtc->bg_thresh ||
> -                    (strictlimit && gdtc->wb_dirty > gdtc->wb_bg_thresh)=
))
> +                    (strictlimit && gdtc->wb_dirty > gdtc->wb_bg_thresh =
&&
> +                     wb_over_bg_thresh(wb))))
>                         wb_start_background_writeback(wb);
>

Thanks for the fix. It looks right to me. I think an alternative way
would be to save the wb_reclaimable value computed in
wb_dirty_limits() in struct dirty_throttle_control and just check if
"gdtc->wb_reclaimable > gdtc->wb_bg_thresh" which avoids the extra
wb_over_bg_thresh() calculations (but is slightly less precise for the
memcg case), but I don't think it matters much either way.

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>

Thanks,
Joanne

