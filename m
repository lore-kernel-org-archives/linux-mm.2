Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2908606A33D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 19:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=b8wcirio
Received: by kanga.kvack.org (Postfix)
	id 130D56B05B4; Tue, 10 Nov 2026 14:19:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 109BA6B05B5; Tue, 10 Nov 2026 14:19:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0462C6B05B6; Tue, 10 Nov 2026 14:19:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E07336B05B4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:19:42 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 813211C4099
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:19:42 +0000 (UTC)
X-FDA: 85420173804.26.EA0B45D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 39D28A0003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:19:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=b8wcirio;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf25.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794338381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lgBsX/4ajBlOSJuEQTW3U4syAbk3rWHkGnOmGP2zj/M=;
	b=Q4nZUrOPPWzmeFuUWA3yqNfyJITknAIjnuq7OsndRtXjVd2klx7an7aP/dd6gOIJBHkc7q
	jYQUNQthFVpOyuHFdiy9Fcuijo26hTJJWiaTW7F0JdHBe3iZ6SeIWvsINDwI/yTC+gajCS
	e2fWsY+MGKoz5CW236n8WSaLwxhq2lM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=b8wcirio;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf25.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794338381;
	b=PRr+ZviGu9nxvxtkn1sHHdPu7Gk8h9JOBVsLSH9FK6DLd60jE8GX6rxZiwe+6k3uWlIHea
	PAn9d0hdo9qr6xcGOn/IGY4DX/FB9YvSTxzuxrlI+ZUUo7FRKa6pf4Dc7uoKGltVeRR3/m
	AuTttdT6rxNUEYsag+izgpcGvwSMYqg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lgBsX/4ajBlOSJuEQTW3U4syAbk3rWHkGnOmGP2zj/M=; b=b8wcirioktk1V+I6cLxgnytfHt
	s+1gNzt+oNaj/8v1dB/y2ooHBs+sOIEHLV1guXHLK59Y0ipc+WH3YGXTdpmoCXAVaPIlKaFOebP9x
	Q5IjU/RAw03kchBuA4YhIuHn67fv4DvrG7GM8mSEoFF6gG8Ec3W2gJu2wrjCdEdxI6RsFxbL/xc8a
	rV8WT7MV79m+BKLbPEao/T/+olEtQaSWrcoxh4kWVD6r5loEe6lhcQZCaufTxfC9qjGpluQcQn8/D
	cRSHrQc9aTr9kcCKqogmnDRYf/CTOej2gLRp010jpVxxjtaJOi3Fc/5efWuKRC+T0KSc9Jq8nypQT
	BOKCuF3A==;
Received: from willy by casper.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xQrNT-00000000PMy-0Ax1;
	Tue, 10 Nov 2026 19:19:31 +0000
Date: Tue, 10 Nov 2026 19:19:30 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Miklos Szeredi <miklos@szeredi.hu>, Amit Shah <amit@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>, Bernd Schubert <bschubert@ddn.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev, virtualization@lists.linux.dev,
	netdev@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/4] virtio_console: copy pipe buffers in splice_write()
Message-ID: <avNuQqLf9CG9dSsE@casper.infradead.org>
References: <20261110145241.536019-1-kas@kernel.org>
 <20261110145241.536019-2-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110145241.536019-2-kas@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 39D28A0003
X-Stat-Signature: yw5gmnah9ukdjcbmrfkizkk8rsbjz8hw
X-Rspam-User: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794338380-952302
X-HE-Meta: U2FsdGVkX1+2EmPHskNXHr6QCFzR9Fds68VqFAbNpkyRIelv+7An773SwNmFVl83VWrPDrIr9lLTfHkPVxgCRGwLq560WyPTWlte01EFTgTkB8mrfr/MQXzJoWKHJHNLfyox3GwYatW3O5Y5Xv3Dk3SBlRg2wuntevihwsKYwF2h6h5f3KUfAvrsEKTlU2ymwWaIeXjXXKmnOXWdlNgIK8aE2/oUHExBC9KaUKHYfD5oAobGzansIQADzX6ilD7mpMa7dW1BNksBTG0iZYJHrgnO0++e3GWGmPoWYb6kE1BicA0TTek46XoyFIXwMaKfH8fUWcXPD/hpWl9yx7EKukJV/2m087ghv5K40VYzxMRhC/o0qznMuBNRQeQstjDI7ZiNcdp6DYVlJRWVX3kwqvKaByfxKDDq6/fUOrryMezthU4hM0EVPXcLzBcKBYlEFtB/vfpADoGRdE10USVfixIr3u6P5BB8SeKBX0s6yhU3NOF9a2bps0oEU4O/Czx/RG3UYwR4kCbLhF/f7UPRp1Gs62GCar5yu7ZFRjD11PseqHS9cD/ldK9fmTVRD9WvdgDD59opeDZWpaLhoa9i/6z14xSC1+3TLB/rOUPcPmQW+7uVTvin2rg5oZYWnGRi+Js4Ijz0I7Hk6VgDE/PZy3bzQOIuHHn4DHSVj2cR11FWjCC70fKlHGLq86DU0u64v1GkNMjyQyiyIUc1yZ3BIpB9HolBXXuvnxO08MMHNmlrLYnrCvWpRT+i6pjTZRszzCce4NwEnrsfwWrZcN2CnvNS0yw608z/KHjNCtFYFyn64K4TUp0wKB/PqMtiBJvbW6LmTwsnrNtThooaGUZ/UUY7YCALUAWh9bk2OAC5T1McjETVUPXqgE9GCfohjQZZ9aGiGq7w80jEGT7MLZu+fA0BVMaJ37CjkhWpEzVvGAd11w34IbBEM+Zk2db885fHDhqO9rsTfgyw+6rPenc
 U7HxCO2G
 s+5rnjkyoohHy3AnUf6I5i+JIelkEgwo5zR5lZv6n0D1oDCHBXDgKp+5V/fSQRpyysKJlWskg55oua1lQKH2wuvg62HCZBSDueAKuicRJG7l8tCyocZlFaR0Gm16D4lPLTvYB9oIYRFIIF0TR/f/qDBA9qZo/6J7FxJwPSs2H3PFKrs6aH3dsPOvnrxf2GRjNWr35xhYiGsEDqzHZ2r2cemrOKO1p0Q9HqYTN6aRMjo80sDHnUgTFiJ20oV4g6J4zsMau6Us/vq0vSRT1HYD2xnL2eDUND3DmDAQQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 02:52:36PM +0000, Kiryl Shutsemau (Meta) wrote:
> +	page = alloc_page(GFP_KERNEL);
> +	if (!page)
> +		return -ENOMEM;
>  
> +	offset = sd->pos & ~PAGE_MASK;
>  
> +	len = sd->len;
> +	if (len + offset > PAGE_SIZE)
> +		len = PAGE_SIZE - offset;
>  
> +	src = kmap_local_page(buf->page);
> +	memcpy(page_address(page) + offset, src + buf->offset, len);
> +	kunmap_local(src);

	memcpy_from_page(page_address(page) + offset, buf->page, buf->offset,
			len);

> +	sg_set_page(&sgl->sg[sgl->n], page, len, offset);
>  	sgl->n++;
>  	sgl->len += len;
>  
>  	return len;
>  }

