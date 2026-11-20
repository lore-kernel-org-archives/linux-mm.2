Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88349606A332
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 13:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UpVSaYgS
Received: by kanga.kvack.org (Postfix)
	id BB7D56B05BD; Fri, 20 Nov 2026 08:42:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B68336B05BE; Fri, 20 Nov 2026 08:42:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA4F16B05BF; Fri, 20 Nov 2026 08:42:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 823696B05BD
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:42:58 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 078DB120EF8
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:42:58 +0000 (UTC)
X-FDA: 85455613236.03.12E8F4D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 68AD3120006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:42:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UpVSaYgS;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795182176;
	b=fR8RH56M2pgn8KzisD9Aog16Rk0rWlZM8/+4iCkvYChGtAboYCOr5Je+ZjU2xBzxtRdz4B
	8xUhVm3vhDMm9LhM7Al4eouuzYLuMPyk3PKcj+o08Uio1EGYlVm48iyVan3DZlN/fzJyOA
	vOsV23S2zM2y7/5n2JCQqsmH8WRgF7M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795182176;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DelEkWRb0otuJ3Owk/bNvAUD48qPFcVpkVG0GdkPIyw=;
	b=qZcaNY8PY1NMdZueJpP/6E/ZOuZkfmWpOwaeenNhs0RIRFCV8vEvQMd6k97EU8mMyGmQL3
	WCXq8cdgt8vUQQ+/taybE9FVQ5VpqrFBgfXZIoIowdNwCa/pXZ4/IUBWgs+OQBSF1V63TL
	Kjwx7U5cmloCQSCzazs9pD/2KEdkSQE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UpVSaYgS;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0456162639;
	Fri, 20 Nov 2026 13:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0AF1F000C6;
	Fri, 20 Nov 2026 13:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795182175;
	bh=DelEkWRb0otuJ3Owk/bNvAUD48qPFcVpkVG0GdkPIyw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UpVSaYgSj1NtOF2npDd65U4IopbZzT3Hi6ZIqgFnGLCDO3Gz9D3X8hsrvlFN8b2vq
	 Ht3A6P/uyAEZs8Xl2usjLVUEolwygAOoserrISqQ57UvsNrrASNEs1wl7gTUDQC4c/
	 DPxaVbvyQSJwSuh/HjbvZ/7NShlFe6KHXux7nsFTAMK75rsqBcpMx1DC5ed/pykgWO
	 ZCqvnrCBcXk880Wo334MC2BZzmu0cma+pnffkE6hZrX3G6gcxkp0nHpcjlcH00NDm5
	 Xh+qzrinP/3wLbNonh0+OrQxLQ9uTdJZu04q8LTvKY/o9X7PWHu3K/nDowL1c2Hxao
	 gM6AxXrB+3Ssw==
Message-ID: <sashiko-outbox-225261@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] drm/i915/gem: Skip writeback of shmem folios with extra
 references
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?S2lyeWwgU2h1dHNlbWF1IChNZXRhKQ==?= <kas@kernel.org>, "Jani
 Nikula" <jani.nikula@linux.intel.com>, "Joonas Lahtinen" <joonas.lahtinen@linux.intel.com>, "Rodrigo
 Vivi" <rodrigo.vivi@intel.com>, "Tvrtko Ursulin" <tursulin@ursulin.net>
Cc: "David Airlie" <airlied@gmail.com>, "Simona Vetter" <simona@ffwll.ch>, "Andi
 Shyti" <andi.shyti@linux.intel.com>, "David Hildenbrand" <david@kernel.org>, "Hugh
 Dickins" <hughd@google.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, kernel-team@meta.com
In-Reply-To: <20261119134243.3745282-1-kas@kernel.org>
References: <20261119134243.3745282-1-kas@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 13:42:53 +0000
X-Rspam-User:
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 68AD3120006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: dnr59j8fnin5kxgpcug95jc6j6tkb6qy
X-HE-Tag: 1795182176-790769
X-HE-Meta: U2FsdGVkX1+246xmIuuIiqUJBAItfv4mJ+MBALxuAYlwPSSKximYoyo3DRuJKo704/x397/MXwZ1T2mWJnAAQgYScQEAGiHGEKuQYKHU7WHIXKJtPjNddXxcCTrtck7/sba6KRXTj7MOWgraKAHgf/kOWxewtIPGhTxeRdLLn4c//HBoLqWJl1MBkkCD/xdX6a9xwADhxgo3nBA/LjGSFOq1Vj7gq3OnNDC/UwIXjKCNIL02DX9pMaO5p26R0I3iXrsfOH79bShztCEvdZHxPSFqx8doG3pH0xAD1PSrbOoznRNTMEpt8p+CwzUUQT+zanYqSOiX/zbpX2FNAL/a5El1DeXCFhiqAm1WK8QhuetxBDIk70nmdEijBilQDzgxVdkCK6pdUviyl4943EWQV436STYGnV4ZWuNiGiME/PWGYgBaEKiDKjTCJrq93oMZC/5w1FwmvvX4kad74YDalzQ90/mUroDjdSaRzH6OWFGBkHtpZfk+Hts/+Jfpx36SEGRN8PT5YM85bMOBf70L5a0n69LefftdBm5i4pMBeln5EE3EjMQe/5G3tdvykVrNdhgdwLfWvTgv7o6Ga0h1pKSWrVPzAK17Qy6IZtCpqaFWFfDFz2Zkg6wRMKrFDskTNYtRLdwtlD6dAcEv+b1ByXM6qC+hzbACitiCYfKr0v63IdZ+ubzvSmpsl8GrC4cwiwu+zOs8gJEZAoqQRfoOMeuKn111zn81KFgxCueNdLcGshFT4AS2JKhVo/64eC48Qen0iK055yx8N1SNTB+hrAEMNm8R+Y2pn0ErprHwGr+rjFd5avf5L8mJ2DllQIku2pxoewaPBLoJMnIgYpKGwPFUu9nL7othMdBuFe3ZhjbWsm3nRnJ8+69xFuXEMr9NMpjP5AloWp0ycFR8WyNZiMQI1wRq5nlBo0OjZSliuE+i9Gh774OcJ6Psf1IoXV1JRLIiMtqdy6jOsGIhrRg
 Qm7xpWTr
 wmMlhKKfwXXt8F2lyGT1+DSrGAWjN1vMSGLvai5FJgnprzyNnpL6QpqOdAajU2UaEPBY8NSG5YdehFcZCRDMzvhE7uxxiwKFknm8Vjs6vD7MPmKWzmfZ4Xs3Z3MrsyRWpL+Z//W4E6n353vHL3b9eoAZcsczvA4f59X3+gfjX5634V2EJp8Y9cFbrD5eV/teQmNj3nq5RatKnO5Ixv0RolHIFJZ2EoxHi979JaQ3w3EyB823/b81br5Q+FRCQRToJtcO535rkhGeC5vYdt6E+KzDLhk5L3IHA7FeyOOdlYhO24HZLZNf9UUPkxklDJRd6jNmUxiQfVDxvzT8CBnKfchh6XX3gzuWaRcZTNepbWQa0IPbvfRpsSIlDjSy4n5nJpDsZO3LbdmW4ZlOLsO3dzvkKGhvz2xmC9oZlxYHjXPfNcf0A8gGv5YZ4NqewintRzIk8XoyCqLl1xRCUquAfTMZ6TCzdhKtP118Gpvd+1qR+KcjFvJxWVQ1oSRjMykC841dw9ZboCufHfgHbeXuF6ZWrWqkEIRe5D4cseHkmhzV/6dfNmu48z0GHjd41IhdIzeOn8HUNqwnlu+KoDppID9R8wF0A7JXmDYu6N6U8mz9a0wlK06P5df92+9ae/YzQwgyeQPjojDa7hKtUCzwTY6xTauCXAnbAgCkycR77creom/aT27ox813x4GxwSnjHq7jSnFelOPGwqPEWfhGtvwZeRuUKR1rHzynuzZk47LHB/wsCs5Hp+4wDqQ3ZvJaT8uMkCx0fGiHxNRcPgcODJ27V7RPTfiwAdBwmc8EmCntmfoWJWYVPUFE7BWeKKyic2Uoz+eW1dociMV1cL0cosv8s6ozXYAjgZ46B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] drm/i915/gem: missing folio_unlock() after redirty in
  __shmem_writeback()
- [High] drm/i915/gem: invalid dirty-tag writeback helpers in
  __shmem_writeback()
--

commit eee676ed22d7c6fdff448f68a9e29b819f5d0c1e
Author: Kiryl Shutsemau (Meta) <kas@kernel.org>

drm/i915/gem: Skip writeback of shmem folios with extra references

This commit skips shmem writeback in __shmem_writeback() for folios that
carry references beyond the page cache and writeback_iter(), avoiding
writeback while an unmapped PMD may still have pending stores through a
stale TLB entry.

> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c b/drivers/gpu/drm/=
i915/gem/i915_gem_shmem.c
> index bf9e7480f0f54..748772c358acd 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> @@ -316,9 +316,15 @@ void __shmem_writeback(size_t size, struct address_s=
pace *mapping)
>  	 * leaving only CPU mmapings around) and add those folios to the LRU
>  	 * instead of invoking writeback so they are aged and paged out
>  	 * as normal.
> +	 *
> +	 * The same goes for a folio with references beyond the page cache
> +	 * and writeback_iter(). A folio that was just unmapped can still be
> +	 * written through a stale TLB entry until the unmapping side flushes
> +	 * the TLB and drops its reference. pageout() checks the same.
>  	 */
>  	while ((folio =3D writeback_iter(mapping, &wbc, folio, &error))) {
> -		if (folio_mapped(folio))
> +		if (folio_mapped(folio) ||
> +		    folio_ref_count(folio) !=3D 1 + folio_nr_pages(folio))
>  			folio_redirty_for_writepage(&wbc, folio);
>  		else
>  			error =3D shmem_write_folio(folio);

[Severity: High]
Does skipping writeback here leave the folio locked?

writeback_iter() returns the folio locked via writeback_get_folio(), and
neither folio_redirty_for_writepage() nor the next writeback_iter() call
unlocks it.  Routing unmapped folios with extra references into the
folio_redirty_for_writepage() branch without calling folio_unlock() leaves
PG_locked set permanently, deadlocking later faults, reclaim or truncation
on that folio.

[Severity: High]
Can writeback_iter() and folio_redirty_for_writepage() be used on a shmem
mapping?

writeback_get_folio() looks up folios by PAGECACHE_TAG_DIRTY, but
shmem_aops uses noop_dirty_folio, which sets PG_dirty without tagging
mapping->i_pages.  As a result, writeback_iter() never finds dirty shmem
folios, and calling folio_redirty_for_writepage() on a shmem folio reaches
__folio_mark_dirty(), which triggers:

mm/page-writeback.c:__folio_mark_dirty() {
	...
	/*
	 * Shmem writeback relies on swap, and swap writeback is LRU based,
	 * not using the dirty mark.
	 */
	VM_WARN_ON_ONCE(folio_test_swapcache(folio) || shmem_mapping(mapping));
	...
}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119134243.3745=
282-1-kas@kernel.org?part=3D1

