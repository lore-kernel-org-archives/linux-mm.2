Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08919C5CFCF
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 14:52:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBCAF6B0093; Tue, 11 Aug 2026 10:52:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6DC96B0095; Tue, 11 Aug 2026 10:52:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5CE36B0098; Tue, 11 Aug 2026 10:52:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 95B266B0093
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:52:06 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1C71BA04B2
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:52:06 +0000 (UTC)
X-FDA: 85089278652.04.1538832
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2BC6618000F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:52:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=V8GSuDwq;
	spf=pass (imf06.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786459924;
	b=enttoymaLSN7560Z1RA+S6GaRkya8YBqE7X9eAAbuMXdBNq58nG6o0QvIJvgHmMm4I4dwi
	1oKB/Ff3nSGEUJ6P0JFxwQlCF079kdLKlyaENS87aB30AOY6zbB2rhAzSeaDP+W6Oo5vCD
	J0moy0mE21GXIe1BbJlVUktO7VFrYIY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=V8GSuDwq;
	spf=pass (imf06.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786459924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xDhehgrrAOSRIdcwgmYMsgv1I5rPT085cxMqoCOwSbU=;
	b=IJE7OyZcY77ALzn2loopMjBAp0Ml1rnHEMdTdq3DT3eoBc+4ORn5B0PbSEO64gqioW9e0r
	elMENPvrhwoJd5LaDIaXLshwitkjuwtXHnkXCvmJra295BKnqVA+X1E474tcrHXiro/ex0
	RuGtc0092zkIdSqxBX0PlvcaFHZ3J+4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xDhehgrrAOSRIdcwgmYMsgv1I5rPT085cxMqoCOwSbU=; b=V8GSuDwqveAqI2bqQieqG7EtHg
	eEEnasEdiZliXbP7agGL3h0BTexorRppTEp1vvgcYKNWcQPKxAE+aj6r2kqxu5qt/dCIkReEDkGfk
	Mv39k2CrHgvirJviGuUmpI0rl5In8PV6s/MzvXA6w407ZEF8rImshyHYqTLstwADLO15oulaVOYpa
	k/2Al6fKhV2KN5Y9uc3ST9gqZoUbA7TVvF12pppLqhZxWWIgV8niqXkX3KZ33dryOP8retFs8ljAi
	lD12KJ6b9+T+lsWTYBB9iUdCmdJ1ZXHmnk8KqQEI7u/mrZLS3tcxSF9fzosVw2ITsHnrk/QfPc4Es
	IfcuYK0Q==;
Received: from [96.67.55.146]
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wtnp0-000000001Gy-1SI4;
	Tue, 11 Aug 2026 10:51:18 -0400
Message-ID: <b04cad808d5dc2a799c363b43a18e9cab18005f5.camel@surriel.com>
Subject: Re: [PATCH v5] kexec: keep the next kernel off hardware-poisoned
 pages
From: Rik van Riel <riel@surriel.com>
To: Kiryl Shutsemau <kas@kernel.org>, Mike Rapoport <rppt@kernel.org>
Cc: Breno Leitao <leitao@debian.org>, Andrew Morton
 <akpm@linux-foundation.org>,  David Hildenbrand	 <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"	 <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan	
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Baoquan He	
 <baoquan.he@linux.dev>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi	 <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, 	kexec@lists.infradead.org, rmikey@meta.com,
 kernel-team@meta.com
Date: Tue, 11 Aug 2026 10:51:18 -0400
In-Reply-To: <ansuaOyItxGTBlTl@thinkstation>
References: <20260810-kexec_posioned-v5-1-95e1b5e2e656@debian.org>
	 <ann9Kcesyb4T9Z8b@kernel.org> <anr59P1ZCAuHxv6x@gmail.com>
	 <anskyrEVUlnTVEgF@kernel.org> <ansuaOyItxGTBlTl@thinkstation>
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
X-Rspamd-Queue-Id: 2BC6618000F
X-Stat-Signature: xjup5aazfrf5haarzj6ci1kj91j6fnac
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786459923-985105
X-HE-Meta: U2FsdGVkX19/b5rhtVcNiJ6mv9CTvWxNfL0CNTkfAq4EKlaCBf0bV0jOUyJqzwizsMLzxPOxrPhRW0pY43Q2HHZRG4OD7bOAhKs1q4ezYVl/TehiSzORzItCI/9LrqSaT+HtmshVVlyEiIQWMgBGFi2jNbfIupa9PA+9v2Na2z01JR5gl6uoLX//VV+qzB8T4B11NaN7uSBM1cUq+plYeoazIpJenwE+2TnOtL4MEAsG0WDwysU6U9CinVJ8CwVmggYuTyB4f0EVQL5OFxAXr3JQH5fiUOJcxAnkqSpKwmtb8IBp/Gs2v5Q5qP9pUAmd8zBcq35ue3NTkjwl6FfEJMJVXGEuwNpcIrc0zUa3E6CvN/m31MX1lJuaeC1zbQyQz+ZqOOoBzfWMD74s3Y43a4tCevxUTDuh5cYdoSKcL28z8RkVVn65PK7a45va8InhQMUUvBbMHi9qSqrHba6WTcpeH2/fkJIHYsrm59owa8svP+Sk87ZvNMwqmKiC7CQpCvrAXi+9MlS06sO6wznBH1TEAJRmp8BsMzv2LeXGRw2KI+SPVrK3mn3PzaH5tsVYsMVa4snmA3dUxO0os7KdHOGeU6GekWGSP5WpaPQmRUKJS8+YdKRfGSGRIWCoiV/PuNnpcDAp15S9iV3oWe5g0bkKwyCWA8vu/Gye/vOAacLs3U1RpIqTVbR2ybK6CPSjBVV8sbza2s3fcoHiVm3773iMPaqbyXKcYEf/E3jdKWN3uWJteWy0dKbrmhb55LrV0sPSRxzvpFJF9xZj3/BB7+g8lV+PWFs44VjY5tX8q/ChQPfukunV2U5D2ojwXqV7jxSi8/v5Uq624GRWnqg81ll5hgHbqGwQarkD9ZrO4+UCLQvh0t08x6Jq80qsXeNPsJHdq3pUDb3JelbnM96KLqbw1bM1eGTF/ry20QjNhUHfZ718FOGpFwHGVdKNgy/aWyitjElFyr95K0BiZKc
 m5VN5gXf
 tH6kPKVFNKt4DhzJ5m6ZApO4bB+cWfCUZjefWL+SsxFUmNoIofJiVxqjsXWCJwsfz1G02gYz0zA2pP2L3idiK+6e5CEgD6RGF8Zhn5elH6VgUYeC7QJZB9rjCOYa7B75xr0LxWxHrqgVy021Vyhih/NSBZyUtvseiK3amU43ttw7JfcMk59DPhqE0ZIG3zE/+gZ9vdpLhiGQXbY1nOhnLjGxTYTGPZH9onJf6HVqZHb0cza3ZLXVWNqXjDsfzCR+y4PNMn4bhwGH/OESPTLDK/kLSdd6sdTfwNBHsxi548A7GSR8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-08-11 at 15:21 +0100, Kiryl Shutsemau wrote:
> On Tue, Aug 11, 2026 at 04:34:02PM +0300, Mike Rapoport wrote:
> > On Tue, Aug 11, 2026 at 04:17:41AM -0700, Breno Leitao wrote:
> > > > >=20
> > > But I honestly don't have a strong opinion here, though, happy to
> > > batch
> > > it if you prefer. Would this one look better?:
> > >=20
> > > 	if (!(pfn % MAX_ORDER_NR_PAGES))
> > > 		cond_resched();
> >=20
> > Can't say I know the magic number here, but I think it's better to
> > batch.
>=20
> Hm. I thought cond_resched() deal with this internally, no?
>=20
> We call it in pretty tight loops, like clear_contig_highpages() or
> copy_folio_from_user().
>=20
> I think adding external batching might be a bad move.
>=20
cond_resched() should be really cheap, indeed.

It gets compiled out completely with PREEMPT_LAZY
or PREEMPT_FULL.

--=20
All Rights Reversed.

