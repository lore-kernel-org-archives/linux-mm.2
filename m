Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD638C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 20:10:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFB7D6B018D; Tue, 18 Aug 2026 16:10:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EFC46B06A8; Tue, 18 Aug 2026 16:10:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7B36B06A9; Tue, 18 Aug 2026 16:10:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2CFA96B018D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:10:45 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AC282801BC
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 20:10:44 +0000 (UTC)
X-FDA: 85115483208.08.4A17C01
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf02.hostedemail.com (Postfix) with ESMTP id DE18880008
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 20:10:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="OQsHpu I";
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787083843;
	b=WtDI+Df5O/jg44lEmot927FhJni3Da0UnOCYYVeXhOGFmetQcLnV7GxKyrHmI3F9pvhX7H
	hqDqK2xgHUYem6Y6Vc64CQY0w96PTyQVZTQTnI4EzK8Sulgl5dEg7j3tZ9bAO13sx1jXmC
	GSq23lX3+COfwLUEj4t7+7SFyzgtVBU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="OQsHpu I";
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787083843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=woT1zsi14to1BWM9P1WvMv8qVMYsV1szojyD7lMbyCc=;
	b=IbB1NUZrGOe5C5I0Fb/EteELfaHswtw+91g36VKcYiKHfiVzcVW4jTH9muI1NqYnUhJjMr
	GadqpBl/LaVYHh1jfx9TorPj5TwpBE+sOv84dfm+r28RclRqHdPu71gzI0ZDEz49yCJAJj
	fvt024AFOeWUmKNGwxvPwu38GMhHDPE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=woT1zsi14to1BWM9P1WvMv8qVMYsV1szojyD7lMbyCc=; b=OQsHpu
	ItmETeHPBNCexRGovGmSiK/1fEe9+feHxvUwum1vDTb3CfY+mvvrEAKC/LZb4I/e31JQabE4pAaDF
	S0kdmZIMNZK3/4VsuxvzcdelOKLKBLDZeCADpZ2dmDCGJNdNh840FUZO+GEOtz6Z9GNl8EdMNpsVL
	idS1l/7HJSth11v7TVneHNO9TsAzorxwdVSV+GOD9YZnGvZEF0RMoTzb6YbhkpgWTv5evnZsoac2+
	ff9fINsIRrjiChTD8wo21iXUFag7kAEZdG2uYL8gT41oDNPzUbaEno1Hb/RtC8HFQXeItIQtBVqm1
	vkW6ZUY+u+2Gl9kyKxyXPyuxyiOA==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wwQ35-00000001X80-2pgq;
	Tue, 18 Aug 2026 20:04:39 +0000
Message-ID: <edcebef940c262a83421666de67e8a07ca93e85d.camel@surriel.com>
Subject: Re: [RFC PATCH 01/57] mm: add pte_folio()
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Kiryl Shutsemau
	 <kirill@shutemov.name>, akpm@linux-foundation.org, ljs@kernel.org, 
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, 
	hughd@google.com, lance.yang@linux.dev, liam@infradead.org,
 mhocko@suse.com, 	rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org,
 surenb@google.com, 	usama.arif@linux.dev, vbabka@kernel.org,
 ziy@nvidia.com, usama.anjum@arm.com, 	agordeev@linux.ibm.com,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kas@kernel.org, jannh@google.com, 
	willy@infradead.org, pfalcato@suse.de, rostedt@goodmis.org,
 mhiramat@kernel.org, 	linux-trace-kernel@vger.kernel.org,
 bpf@vger.kernel.org
Date: Tue, 18 Aug 2026 16:04:39 -0400
In-Reply-To: <c05f7bfb-c84b-4c36-8091-5ec7721a658b@kernel.org>
References: <20260816224609.308019-1-kirill@shutemov.name>
	 <20260816224609.308019-2-kirill@shutemov.name>
	 <905d08d102e56a026a5ad69573c507d2d9becc37.camel@surriel.com>
	 <c05f7bfb-c84b-4c36-8091-5ec7721a658b@kernel.org>
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
X-Rspamd-Queue-Id: DE18880008
X-Rspam-User: 
X-Stat-Signature: zd1tt4acjhdao3qekkqyjmozhretibqf
X-Rspamd-Server: rspam06
X-HE-Tag: 1787083842-225088
X-HE-Meta: U2FsdGVkX18n81U/hz3WujmOUKKXS6IGtTqD189Z8VMILt8gIELftJ1/fqDjS2xlMAA0+UdayHzVPzQGqobkvY1Sw7zxz3GtLtFG1SibS4JvrO3/UWsTSZyXR31xgMyyjAM7X5EUUPWCs4XutC2IYxPY9UfQGp5gDqra+3Prnx2lO4cNd9JoLd5LQq3RrDVq/Kl+qFxI2ihS7x/fAU+DdFQtHcy1feW+4/2hKIP3uecLqPVRJtOYi8MoTOiAgZ+A9mHRfWQrkKWiMz3RpoCxaOqoGY1vnDlCvMm/FIlYz7iwgEpPAzJHHp7/JC4tDvDm/ONQk4sug2yhH47FOMtMTygZnRCNJONgCR0eCG3MwCcFWwUeajzUqlrjl2b7+5bERiZ3YgVUaIYboRxPw2S9bMjiWdthV0xA4kiQIt4cIkEWzTNc30C+SwbUc1kRs/6BZsMFBtl5uMW3up5/Vsuy8aWQUmCEVPJh787isQ5somBBYUYpgBvKwaUyfWvve6WiKxkAyAhO7S2CzTsZZ7xdzO9Ag5HARmt9nuHR/F3rf/nSz42CMzpTEMm+z+I9OHLUJcvV7oKuASH3qwR/MMAmYvNXlJqszzDQkdU7hWDByDNrP7wzo0ZZs4nlEA3BNGBCpLhPkLP4q5QHqW1PDmtNnmswKGBF8tOuB7p6dBMkm9XYH2OYdGH//VaCwHI0Wn/8msAWIK0/EPBiNFsZNDdzrEwLgeMlPRpnWQT/Oij88QawVUs/CugC0rIwB9v/2w74ab62AntAbjLsbGC2YcdptM321pSSZw3fRayT12vSo+bZvLBDQo9Pcr7dYuBRmP7K4J4K5DnEzfY5kly/yo0/QWu1hWb96xbMDUPTGdYL0au3Saz2dUijrrUVxL9h1qG6PzNUX1c+6QJtPe37WQoWxjIBE1H1O6/EVlWUUIrBHj6BLGh7W4kYBlrb8UHQt9l+KsOd5EBWHTblT+X2g8L
 NveJhL0P
 l+vWj3rW0UghzYlwq52b8bret16IAr00I7ah2IyJg4/pGjs01rsFwHfrPIgRCHaTuQwfdeyl6aS+3CX8mwJGZozJmTOK+UZTxYH9kNaWfsVwAUkNz1LqaKBDmpJrCBgyzgaWk9Tx/8FtgHep9Ivo2dyKSBkVANo0f/9csf3eiRnl5qEGHpDRhqWGSNEkXwhCjKwUE0eVqzD+74GUMoSW0cLjKUmzL/7guu+GN5DufbvjXtnCIvilgJP0VHMXKS23fy14N+aM7n3gidRNjJwwpWV/cdR6Ksat/pD5reclMVMsGspsj4LPRA5AJjMvgDqGB83/QLsE94+5gCO20tBlT0/XwqN6ibl0qIj8L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-08-18 at 20:13 +0200, David Hildenbrand (Arm) wrote:
> On 8/18/26 18:38, Rik van Riel wrote:
> > On Sun, 2026-08-16 at 23:45 +0100, Kiryl Shutsemau wrote:
> > > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > >=20
> > > Callers that want the folio behind a present PTE spell it out as
> > > page_folio(pte_page(pte)).
> > >=20
> > > Add pte_folio() as the folio companion to pte_page(), and convert
> > > the
> > > callers in fs/proc/task_mmu.c and mm/hugetlb.c.
> > >=20
> > > Preparation for the anonymous collapse engine, which reads the
> > > folio
> > > behind a PTE in several places.
> > >=20
> > > Assisted-by: Claude-Code:claude-opus-5
> > > Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> >=20
> > Oh nice, this could clean up some things in the
> > get_user_pages code too, when we get around to
> > tech debt there.
>=20
> We really need the page in GUP code ...

Ugh, indeed. COW can create "holes" in the middle of
a large folio, so even __access_remote_vm() will
continue to need pages.

I guess we'll continue to look up both page and
folio in that code, then :/

--=20
All Rights Reversed.

