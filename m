Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD9ABC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 19:53:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8521D6B008A; Fri, 28 Aug 2026 15:53:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8295E6B008C; Fri, 28 Aug 2026 15:53:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7181C6B0092; Fri, 28 Aug 2026 15:53:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D8916B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 15:53:25 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DA52840575
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 19:53:24 +0000 (UTC)
X-FDA: 85151727528.25.EA2EF80
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf05.hostedemail.com (Postfix) with ESMTP id 38521100007
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 19:53:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="b+OSsk c";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787946803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IxzjcPz5+SNhCmE1JOyZebKxthNf1zJTzmh1W0Xwp6Y=;
	b=cvZTkgsAVPjlPc8qBWTJQ6i8mZwomTkNE4om4kjpggy7GaxaC1URb+ixeZkLThJiWiRvv9
	Zlv/BANx4fSySSc4BXlaGR+F1bA9kZ1Y6OHs5tdBwekSDXFiuiq8SeuadXyZpt6nKRdxG5
	/oPJd0S4EWzWEhOKUn6btqZf+NSoThI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="b+OSsk c";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787946803;
	b=kit8c0Kdm7bQsq0L3rfQQTY9NE3WzorwAL7a8gXtKc/c1p7vU5xLYBFSE0VXYTwouDozXN
	ry/uE8H14Q523sI+rSZmYZ8pjweI3Sa6o7DT2GqiYjAXr+BjiepWmn/GNmdGMRSrzOup5b
	Ia3YneYEJmTg8wDIbnBz7oIZ9l1p7is=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=IxzjcPz5+SNhCmE1JOyZebKxthNf1zJTzmh1W0Xwp6Y=; b=b+OSsk
	cW1Wu2OXiYmbZV0SF03y5tVK+iNBQUtluCoD6iGuWcYt9V+9rPCGi6/yAs53XcTy53sHgCeg/HL5m
	9uHO5D+QGW+l9RgAqw/jdPCSs77WsWWcJVzdbJUDU2+vgUifO3QGwlXpFd/bOEskHt05AfnDtXaGy
	aqd6ZbBRAKWBuqmH+hCVzyUlKYLu6VaTXK8YHSzMK8BWNtYu1o3x1Ia6ZZn0fco9WWCb+l6SM29zm
	e2b/eb6fG4UCiC9N1zA6TAeniXZpUFxT47jeqwi0+5HxBfgCZPHV4EbSOTrWKPLOyC2F9faYYciHl
	B2Ss8rhcfhHFr5XR6PMlRFumJeyw==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1x02dP-000000095oa-2jkc;
	Fri, 28 Aug 2026 19:53:07 +0000
Message-ID: <17f79998b5f328c6e79820b613b2194dd3e104e6.camel@surriel.com>
Subject: Re: [PATCH] memcg: clear FLUSHING_CACHED_CHARGE on cpu offline
From: Rik van Riel <riel@surriel.com>
To: Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton
	 <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, 
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, Roman
 Gushchin	 <roman.gushchin@linux.dev>, Meta kernel team
 <kernel-team@meta.com>, 	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>
Date: Fri, 28 Aug 2026 15:53:07 -0400
In-Reply-To: <20260828192419.3057939-1-shakeel.butt@linux.dev>
References: <20260828192419.3057939-1-shakeel.butt@linux.dev>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
MIME-Version: 1.0
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 38521100007
X-Stat-Signature: myctuska1yewhn38zc3k9mzay6kk66yz
X-Rspam-User: 
X-HE-Tag: 1787946803-338836
X-HE-Meta: U2FsdGVkX1823zOUoS9QioEMsQjya2oy4c9VzHElMeHR+qLPKDWlVqGRgsl6naR+fKht8uLOwOge+GH/6pPQ6enhs0ydiQqfiGG2DxbNs9JEAXoFm6HSrpjm9fDav1J2ISMh5enbd8afgrIRELhnSlMIWQ85u6PGeFAwXfqxYdxNk+i1AWvnv/x63RkJ20ibFDYSma3HBURPrD6UHQngSYHOwTyz2L40K1Ramh5ArYyrlmUyN/d3qGZguaY0PpRKy4aQES151kyHW/LnJeoxkhzdqbyghOdpfACIAETfHlGE85y8GJ8UUIPM8LbImSL6si2G6Klma1CXr97TYZ246QL3kwBLUhOch7wMz1RXI6rDg0kcf9O0nH1jB+dEjSp4MvzKb9ydS0oRzKJky7wbxoWWK04q8dTRqQBb2pfwMZ+YywTHVh8/W7HcAuiRWpgwGRsqNwQTzXupvI1olSNs6vpT10LfkL6K7IFWGeJZBIlfP9P9NRq2tvsIIRtKdlNvGVandUhG/kC3+9/6i1ObcnykOTO6bMLKjxl+rWa26K4nGS7ghAYzSDgC8ISZECfU/4DeWBelDgIK/1Ren8eN0kBoa1jWV8esRiBrDm25CyhZ8tbZZTonuabK3+6J77UKHsWz3rv2tKBLsh+JDUTTnCbHpUa1DQYg9DOao240vFeFrEAbDFGUZXkoWTKBefFqEWpFFwhukUvqOIh7UfDkOfEQxvg3SdG53Vl2NTBl3PEtwQwCoJzHca8vRwLIVfE53BFAXgPnCOLUiW1OxMrQDICcziSB3E6ll9QFcQNDgDWDtWeoITKytvJ4fA8m5cWYvkTIoXJUlujc1MJ8HZ8B7GptU7D9hw72Yp7jHegOimXLukaXT4geEyslalUPitWHC2eDpBzmXwEbNRvhWd7h+/ciTeaYK6ctAXjohDZrJrElKIEVYYBNx/LAdVk6iFqEh3C+BNGdu1ZU0dzwwGe
 UVUyjg5O
 5o+sS0GoVdvqPOduu0dOwjduGNCbd3UFo6+mvS+v+m3+N8gm5mc44qqt1Ps651C2QkKuy26KHP6rH8W1rLnjfryQ4fedeN05w7aBOcGFgkXTVUbPb5HO0levJ7FQNEBqMIi+FX0fDj7xIDqZdW4KhEqoPn+13NfN+IH031cZYqpO2TK//2YMdvgPOZTEvZU2E5aIzxsog32FqISQF511dq+lpwI/JGodrMS5E7PLO2C0po10dHV5Prkms+1idPWuRGwiu1VDHsJ2SpHdVzSyowEdhu3Ns9DSTIz8gdC26zzpki6SXsKLFg5/0ClX+JiyBxFj1zLfnMB1pcmrxoQ9Z8B/IACTMTYYALXY9PetztPuEzbOTIP5+BLaQz1SIPUSNCFT5goMRmnE+t41ItrQl1rX4MmPFw1HSPCtXY2sxO5mhRzCQfDyyMNVxwim7KG/MyjuY9DMVV3BUrp+UcsINdfIv65OrNFE8js63rqoaT4ChTcI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-08-28 at 12:24 -0700, Shakeel Butt wrote:
> Sashiko [1] reported that memcg_hotplug_cpu_dead() drains the stocks
> of the CPU which went away but leaves FLUSHING_CACHED_CHARGE alone.
>=20
> The flag can be set at that point: drain_all_stock() may have claimed
> the stock and queued the drain work shortly before the CPU went down.
> workqueue_offline_cpu() unbinds the per-cpu workers, so such a
> pending
> work item is executed by an unbound worker on some other CPU, where
> drain_local_memcg_stock() operates on this_cpu_ptr() and thus drains
> and clears the flag of that other CPU instead.=C2=A0 Nothing clears the
> flag
> of the dead CPU, so drain_all_stock() would skip its stock forever
> once
> the CPU comes back online.
>=20
> Clear the flag of both stocks after draining them.
>=20
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link:
> https://sashiko.dev/#/patchset/20260828135036.7d44361f%40fangorn=C2=A0[1]
> ---
>=20
Funny, my AI came up with the same solution, and
I just asked it to do a safety analysis on it.

It was quite thorough.

Reviewed-by: Rik van Riel <riel@surriel.com>


--=20
All Rights Reversed.

