Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D915E606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 03:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TI2FvUGU
Received: by kanga.kvack.org (Postfix)
	id 00CE66B05B0; Sat, 21 Nov 2026 22:06:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F26A06B05B4; Sat, 21 Nov 2026 22:06:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E68426B05B0; Sat, 21 Nov 2026 22:06:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE9E36B05B0
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 22:06:09 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4F20A1A0617
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 03:06:09 +0000 (UTC)
X-FDA: 85461266058.12.6E07BA4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9374540006
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 03:06:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TI2FvUGU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795316767;
	b=2+dM+Ybyl6SaBVnzNW9ZHGgB3lchIUxhjv2N0tAtuQLvMfhQPk+vnGNahXB6U//J+S8Jov
	pGfTCd2v9ZVlvpKcNDZbTH/MgKiRUOUu9QRCaJtfJYVTQJ5C+rEZbC3tSE9lZR4mCjGa0d
	+idk7aHlrz/o2nJa77ZOfOAUmeNKQMw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795316767;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NVAS9KHVVx7KKEAfptYdXsaJtTR+wxwklb2kT4/kGZ8=;
	b=Z6c349MDW2VBgeaHW4omO8hDChI8Me+RO8gTBskbYLtbJaWikE39xsY/m87l89f9yL+yrP
	wZ42LIdBBr0jnkUsQVRpH3ZCbOejG51P0rOZWJ4PgzEidkLH/AExafpxUJR2MLCoIItb9V
	AGo9ZjP95KmjA5Xevw3KAmPKMA+J+oM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TI2FvUGU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 99C7841828;
	Sun, 22 Nov 2026 03:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813161F000C4;
	Sun, 22 Nov 2026 03:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795316766;
	bh=NVAS9KHVVx7KKEAfptYdXsaJtTR+wxwklb2kT4/kGZ8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TI2FvUGUqlt4ig6pfRpWCL9OLTTGyCAMMEk6GzJXLhT0FJfYjeJHbC+AdtqVhkT1q
	 obzYhpOwTYYuhp3jYDldmz6Ja2WwoOT17nbppx5XGkuaU/jRkUAI6mE2DZnx/drw1H
	 g8OTU7wsUy77BqE6Fhh7cJlJ1HjZ0W9QEtLwilsle1Anovo/vA1MuO9JRTLfelICVa
	 vjKngjX++I16D8kRY4CKSfYPquqmZ32eue69IMktkw5v3ufRu2xQDXMMQkXCkIa4oX
	 yXD903ypSNVrnXqHy/Sdf71nO3gsZczpEdFpbs0MF80sUp/bQVXhVLZ6N2oEokFbnX
	 +dnUwmL8ETWhg==
Message-ID: <sashiko-outbox-227658@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 3/7] mm, fs: handle memory.high overage in buffered
 reads and writes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shakeel Butt" <shakeel.butt@linux.dev>, "Tejun Heo" <tj@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>
Cc: "Johannes Weiner" <hannes@cmpxchg.org>, "Michal Koutny" <mkoutny@suse.com>, "Christian
 Brauner" <brauner@kernel.org>, "Michal Hocko" <mhocko@kernel.org>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Muchun Song" <muchun.song@linux.dev>, "Jan
 Kara" <jack@suse.cz>, "Matthew Wilcox" <willy@infradead.org>, "David
 Hildenbrand" <david@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Zi
 Yan" <ziy@nvidia.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Nico
 Pache" <nico.pache@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Meta kernel team" <kernel-team@meta.com>, linux-mm@kvack.org, dsterba@suse.cz
In-Reply-To: <20261122024737.2741569-4-shakeel.butt@linux.dev>
References: <20261122024737.2741569-1-shakeel.butt@linux.dev>
 <20261122024737.2741569-4-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 03:06:05 +0000
X-Stat-Signature: p9khg9k9qnefeu77g3jwxb9ihyt1hnuy
X-Rspam-User:
X-Rspamd-Queue-Id: 9374540006
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795316767-850335
X-HE-Meta: U2FsdGVkX1+WmUD7zG2Qnq5kQ2dxT7NJE1AGztmIxsAYirm0nbMTOTuohIoD3y2uhL0iEN/mdbtmoA0+iTPK9l161iMum8qNU4A44D+HzRlbDQBvMCff+dSKQyB3HxrZ1eQrBEobc4cidivyO+yCbqaATiGkbuHsn4k7RQ4PncYA3AXdxe2lV/bBro6T7AxA9W4Ry5n48KufS10zyeidRbfPenKzRnfNhsI0144iHE3ol1zSxE2wpLS3jltBmeNGU3szJWHG4CjVshZT3/ux44pW/BE3yfayX1b+CZXTLxt+y5f7I146JVzsdbIzw11uywlXoKtWNCkcmaoHMq7yFZoOLaq4+RRXFqpebH9QFsRi2RT3SCH9qCFNcGnpIqMcBAUMqQICVEd16vC7uunBu7ZQGkkFNBgAMGPhIjiLRRWK+XmXHDSrKTp5wgybk2zH6bIOEPI5svoRv47NhxV2vP+Lw7E8K1aV2465nFqN9bFQJ/8lo3O5OK79QsRwqAIMxHHL8LUAg2kdAKeqsLufr2P9pcVHeWLR/hWOaAhjV7i3tOnPL4VMbg+ZH0H2cCoZWH1IAY1ppA/k/wTj8ePglg40TrmMlKL9FkMgl300uvn12OXCQOklSUS6Vd/emdJebWf/cNObK7kA+4oBby5Jyhkg3N7Hf9DfZwPJgyn8CC6IlHrId82mKTyRVXORKENGbPJVTVR0TRe7xDwObVaItYiUdHG1FqAknQK6YkVzM7GkE0voe8g83sX1qm18ifsjjlZFL0Kxhhi58oBvnclRCJodR7TY1O/ZRtfx6hJP7gfUlFdmSVYmAGcl2MOhFywkBgBfTLCxsQoe81YIewzvQJKqRudlKeF/eDfwDZZczsNuUvvoWQpmO35iXj0PRinF5LFFDXE3g/sb1c3qwvZElWlvdYYRWsdKG9Q68KzMemXXbJ2VSom5pSzHhU+0ebDUHrwAbLeLhPSdLQweApS
 y4gLg4XL
 B4d200ibkJcixUMVIFWYzbg6iQ/grPQ49aQrseR9UtY18kNeNcDd5/vGDXC8Iwefy11YHGdkwQtixOEfzTFLEv+NA56RgqXV49fvJ0MpTuwockyrmg6l7AnKAwdCGQHAC3XjuG1C8Qov4fOz4y+wZ0vmIBCJClSucMhmxGCQjRCvmm/SzQ2PLZskQxZBRHyH4aVPGIxfZJRY2zhXL+WF3bUaZlMw0Na3wMEhC75RTLnvu7RNIPExuYDfYaLeh83B8UdFW9c+87KFDC0MKVF/aAiOshJ9vy9qz9e1ni8auysXqzX99PyoYkkhcQ61Qvbn7HJiGELBWchHzZEUhrCAz8zCjT4Z7+iDJzZPwWTyd5CmtTWw0vVEKSOc2LX5+u82D63Z2C51vqh2T7K5+iTk6hb+wddoSt85R0am/SgXqHrAaIsliwML0G9ESbugMPbwrQyfZKrtPYIw4YvO40IMLcasIgijFcWjygnRgI3R5CIrXQPLVKQJRGmsYg8b3vwfX0DqTY+k0Uhqv7/hozhp/HTl/FasSEEEk1KWI0Z6W9JiAH2UMaNgoADmua/KQz/ybjjCGyEFDdseB8MEmokX0sIHMoHfsPpSQOFGrOqwRM6Rh3bfp6OpyeRP9iC0Yy60wnUScQVq8XZbjZTauUfsewCYX8nGxWJiaghIDE8JKwdg3xjduuf8v8d10pm6BC/mJEg85fML2LVN8tQFFWFupBgMmnxsO+L8FA3hWdLYiajtqSOkxLgUvm4e7vfbUVb9Jw9150tSa0ncjVBa36pvSagfy/KuNU/UDS5KG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] mm/filemap: read corruption in filemap_read() if i_size grows
  during throttling
--

commit 0c9715c2d32c8a6aa3086d8505b1f86c7ebcf8cb
Author: Shakeel Butt <shakeel.butt@linux.dev>

mm, fs: handle memory.high overage in buffered reads and writes

This commit adds memory.high throttling hooks to buffered read and write
copy loops so overage is handled outside the memcg charge path.

> diff --git a/mm/filemap.c b/mm/filemap.c
> index dc0ceaa58a0f7..b0cefe71c1fdd 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c

[ ... ]

> @@ -2913,6 +2914,28 @@ ssize_t filemap_read(struct kiocb *iocb, struct io=
v_iter *iter,
>  				error =3D -EFAULT;
>  				break;
>  			}
> +
> +			/*
> +			 * A large read can charge a lot, for the page cache and
> +			 * for faulting in the buffer. Handle memory.high
> +			 * overage after each folio, as a batch of large folios
> +			 * can be big. Keep the batch, or reclaim could free
> +			 * folios not copied yet and they would be read again.
> +			 * The file may change meanwhile, so check its size and
> +			 * mappings again. Reads into kernel buffers skip this:
> +			 * their callers may hold other locks.
> +			 */
> +			if (user_backed_iter(iter) &&
> +			    !(iocb->ki_flags & (IOCB_NOWAIT | IOCB_WAITQ)) &&
> +			    mem_cgroup_over_high_pending()) {
> +				mem_cgroup_handle_over_high(high_gfp);
> +				isize =3D i_size_read(inode);
> +				if (iocb->ki_pos >=3D isize)
> +					break;
> +				end_offset =3D min_t(loff_t, isize,
> +						   iocb->ki_pos + iter->count);
> +				writably_mapped =3D mapping_writably_mapped(mapping);
> +			}
>  		}

[Severity: High]
Can refreshing isize and end_offset here corrupt the read buffer if
i_size grows while the reader is throttled?

filemap_get_pages() does not clamp the batch to i_size, so fbatch can
already hold uptodate folios past the initial end_offset (for example,
from a concurrent append that marked fbatch.folios[i + 1] uptodate
before calling i_size_write(), or after fallocate(FALLOC_FL_KEEP_SIZE)):

mm/filemap.c:filemap_read() {
    ...
		for (i =3D 0; i < folio_batch_count(&fbatch); i++) {
			struct folio *folio =3D fbatch.folios[i];
			size_t fsize =3D folio_size(folio);
			size_t offset =3D iocb->ki_pos & (fsize - 1);
			size_t bytes =3D min_t(loff_t, end_offset - iocb->ki_pos,
					     fsize - offset);
			size_t copied;

			if (end_offset < folio_pos(folio))
				break;
    ...
}

When end_offset lies inside fbatch.folios[i], iteration i copies only up
to end_offset (offset + copied < fsize), leaving iocb->ki_pos inside
fbatch.folios[i].  Normally the next iteration immediately breaks out of
the loop because end_offset < folio_pos(fbatch.folios[i + 1]).

If mem_cgroup_handle_over_high() runs at the end of iteration i and a
concurrent writer extends i_size past folio_pos(fbatch.folios[i + 1]),
end_offset is raised past folio_pos(fbatch.folios[i + 1]).  The loop
then advances to fbatch.folios[i + 1] while iocb->ki_pos still points
into fbatch.folios[i], skipping the rest of fbatch.folios[i] and copying
from fbatch.folios[i + 1] at the wrong file offset.

Breaking out of the fbatch loop when offset + copied < fsize (or before
re-evaluating a larger end_offset) would keep iocb->ki_pos aligned with
the current folio.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122024737.2741=
569-1-shakeel.butt@linux.dev?part=3D3

