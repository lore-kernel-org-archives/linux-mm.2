Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9B37606A8A6
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 18:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X0vd4Ds2
Received: by kanga.kvack.org (Postfix)
	id F35016B05B1; Wed, 11 Nov 2026 13:54:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0C226B05B2; Wed, 11 Nov 2026 13:54:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E22156B05B3; Wed, 11 Nov 2026 13:54:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE96F6B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:54:00 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D1B65A7F19
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:53:57 +0000 (UTC)
X-FDA: 85423737714.05.53479B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4505E1C0009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:53:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X0vd4Ds2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794423236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+5n1VoXqaGtyr2AYAd3HrKxaDIwkNj4GWqnIam41N0U=;
	b=B6oC+NUW1y51w/4Rwpu9+plRsu1AzmkKisvpazb19yy3ixbDHymY0esoDEDAXjkEAbUIdx
	Hf7OAjs1H25GuIpO1N0sQzZG7osEcbgpsVnqE1CNvjSbOTvTc3JtckJ8Sl0a9RmklteV/q
	ImyI0tEEhoCv56A+y1ULUd7INIpfc5M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794423236;
	b=zQjlPc6A2U2SJNe9cHSRElqueIWFqD03HNzQT9HNAFm8GIAc+D0viTRmpqbb7X+R9tvFlN
	UXtCIFEWDjftizPQ62+8+swyrG63uThiLbWw0CDmDISP4g9+fignA2h0C4MRd1Fr1TvSWQ
	sywYCvoW+7EZnbqEI17eUX5OEJTgRqY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X0vd4Ds2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C77276350E;
	Wed, 11 Nov 2026 18:53:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9700B1F00A06;
	Wed, 11 Nov 2026 18:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794423235;
	bh=+5n1VoXqaGtyr2AYAd3HrKxaDIwkNj4GWqnIam41N0U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X0vd4Ds2ttFc1KZuSjD/KbzjkMEx7L2o6Kd1wX5ida9swtkXa0xSt666pNbbQeM8Z
	 xQIW1QRIiqrsFABQxrUFj1k2xiGwV7gqqYc57CANRAxCrBuQTst6+aWo5TTQhzwZNt
	 at3dNhbfeDgocuOCIMvoNJLEKUNeIGVmhT04Gr5E+uppy2SWXEDmThX1j+Cxq45MuR
	 SbdA8xtTxyjKpum9y4AhIPNvIJy+TvuMQqTS3D4HVw5dYfCXsqqIcR+wZUaZw2UUPq
	 ZIU9/IihDSQEQdcY+/Nl/VPc+sLsLpFVJO+tm/sFwzJcbovN8eRM4qVtbx7y7mFCGZ
	 wCA9RGzWsZbVQ==
Date: Wed, 11 Nov 2026 19:53:47 +0100
From: Christian Brauner <brauner@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, 
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Miklos Szeredi <miklos@szeredi.hu>, Amit Shah <amit@kernel.org>, Jan Kara <jack@suse.cz>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Bernd Schubert <bschubert@ddn.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, linux-fsdevel@vger.kernel.org, 
	fuse-devel@lists.linux.dev, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/4] virtio_console: copy pipe buffers in splice_write()
Message-ID: <20261111-stumpf-montag-miterleben-c4e2feac8090@brauner>
References: <20261110145241.536019-1-kas@kernel.org>
 <20261110145241.536019-2-kas@kernel.org>
 <avNuQqLf9CG9dSsE@casper.infradead.org>
 <20261111-heimreisen-ungeziefer-empfunden-a892571f2c07@brauner>
 <20261111-thunfisch-wirbt-waldrand-822275b2d3b1@brauner>
 <CAHk-=wjPY=kfgnmtx4COEQjD5UzKx9m2-=KLGAZP4d=RKEH+pg@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wjPY=kfgnmtx4COEQjD5UzKx9m2-=KLGAZP4d=RKEH+pg@mail.gmail.com>
X-Stat-Signature: 8bggpedexgwrn1s6qn1f3c5mm5m8exiy
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4505E1C0009
X-HE-Tag: 1794423236-862946
X-HE-Meta: U2FsdGVkX1+g6/0NXWWpLVJ9MTXCZdmcAuRc4CKeamzrvFa1A6XHmtuQqq8RtvxRqTSZebRHNCCLn93+XYKA21m4Do0ahXQFbpbw6Ig3B/jRvbmU5RpOFYJu+88cImHzagtLTT9hINrYSViUk8iGX2zQyZF7UwQevHHs4bDF37/mg1CsgilwmYPBfmui76+KyIR8Z60aLYliT1hG0fPyi3m7DIHsfSwvqInxFmba2xwE4UCaU5p6FghYuemIBLnDbTIWIiZEOE99xEt1EdEtpaiSzoy2Cs0j5iq7ua0LUjKKYjN3qDdJ/sOD6j9dW3myOG6mxiAFbuX3cxjSfOSfCoE7Vu9MENLd01M5JwZWWhZ837tY/oDeI+/UGvqfoxmvGK+CErP0LL0RGB/0raS/epJrB0aj6bmaZOpJgPM1Cb/Vl0RBmsjsgh47geM/gUrgSyMPTNM+xszButOnNS796OJAsS5YLfBoqWtdpeSnK6WImnp+WRM64yJprSXBryKzS/wKefJmZXMoyN4OLXeEVUeG6aMSiotU8tDv7XWVgSMGOZO6W3T7RupUbqBILlZoj+EKytsOouG8StdnFKxzZ/axEanll/mFvQJwewkCLqV6pmwSCc3cXY58OpCBbKtMj/75YcjIFewWdyIbSoanApvrrqMSq8Izeow/rU1M5dN52lsvLIcF91/6W17JVUJLrp+UtU04TiOTX7WunsiknThxbuTZ5s/M9kmJuGh46ZvH/uIPC5Kgl0FnoBqIGs7VI1rqEea1/EbmHpa0FVOi0ySNchtKHUrD0gt9PxwiVZ4iBO7GHe96atW6W+YwFqK0ycIPFq/PDzOFG5vuRmHxles22ca9XnzmPaAwxiny7e0mwhRlAO5iLYQ441+G2sS5eQX7vPnxFmS/1wu04tmRLadNP1mn37yL5kh8e8iyHbeMiEpGcupMhOmxz75KOWZ86aUip1FJV3hkmnVGp7n
 9HPeKNN1
 xC3RGGxXpujRLltzChr4G2RQYajG40WSIDBO4SBBavaj+S5+s4QJ/PBn+O8bbgjG/oupu43TtO51Kw8FHnPRVlPB6euEIZm/dsmu52vKyv/v/ttEAn9+PMf+YQOvQaVfbGuoDkDHFgmAqs2Fhft2SlVxP2oHbCzbQhpiXuKOlwpD48noNVoBvDIMq2iRAept/0xbbpG0t0c7NNUVVf/M7G3JndcegcRwM1cFOFtbLQgKlq7niC/qwP3WnTlTqBLR4wxIVixxb65V221hfyXEpHFFIxBgFEoCF9/d8OowK1ZEDESVbOYfzEKXs52pc/PgLgdegwTB/8vw3aUksS7L8+dTkO9IR1xkiS5hjYjUcEmVOaE8KyTJqmF9+Cw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 08:43:53AM -0800, Linus Torvalds wrote:
> On Wed, 11 Nov 2026 at 05:42, Christian Brauner <brauner@kernel.org> wrote:
> >
> > So the fix below is what we've done before for pipes and I think it's
> > the right thing to do here too. I put the following on vfs.fixes:
> 
> Please no.
> 
> > -       src = kmap_local_page(buf->page);
> > -       memcpy(page_address(page) + offset, src + buf->offset, len);
> > -       kunmap_local(src);
> 
> This boils down to one memcpy.
> 
> HIGHMEM is dead. Nobody sane uses it. It *will* go away. It's already
> effectively never ever used.
> 
> There are some broken 32-bit arm setups that use it, and legacy museum
> 32-bit x86.
> 
> Don't make one memcpy() that can be inlined become this garbage:
> 
> > +       /* The buffer can span several pages of a compound page. */
> > +       kv.iov_base = page_address(page) + offset;
> > +       kv.iov_len = len;
> > +       iov_iter_kvec(&to, ITER_DEST, &kv, 1, len);
> > +       if (copy_page_to_iter(buf->page, buf->offset, len, &to) != len) {
> > +               __free_page(page);
> > +               return -EFAULT;
> > +       }
> 
> just because of broken shit that nobody has ever complained about or ever hit.

If that's the official new stance than I'm very happy.

I went by what we have historically done and very recent history still
has us fixing HIGHMEM shit.

So if this is an official thing that we can now say: "Fuck it, we don't
care about HIGHMEM and will ignore bugs because". Then why can't we just
completely kill it for say v7.5?

