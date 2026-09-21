Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BD1BC982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 15:17:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F8996B00AB; Mon, 21 Sep 2026 11:17:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D0B96B00B2; Mon, 21 Sep 2026 11:17:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BF3A6B00BF; Mon, 21 Sep 2026 11:17:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B6CD6B00AB
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:17:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B9BCA1C1C85
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:17:30 +0000 (UTC)
X-FDA: 85238123460.09.F9335FB
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf22.hostedemail.com (Postfix) with ESMTP id 08188C0005
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:17:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="jfCP2I U";
	spf=pass (imf22.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790003849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W2+G+uyaywvTjosHHXQQCOH8WG7Itl4tMszraMzJ8Ss=;
	b=HiNT6e38IakTUTGYklDDCeG+hnK9MmYHYa8kU5eZ7eyL+931bK9lS+ba4mT6Dme3TBU9a8
	9mk9YLGFIFGS4nfd4/Nl0mS8CEldvei9xjyRYoQ9WkbwozTkr3tz/PtlpnSvu7bTm+4naf
	5YEmRvNWVlQmi92Reb6eIHHIVPMz7UE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="jfCP2I U";
	spf=pass (imf22.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790003849;
	b=ZJqqhOKHA+RDO7JR/3ebmtwm8J3drFaPdfZdI62eh/t1ZC60/SqeqaZxzKUoVkC9Wxtj/I
	veNbcQAIuTzV0ghAOWSS7XCzT30/ZldDMDCSd4bUcGpis9NhhSYT/7UL5WHSGKkS+fH54R
	hT67JErpmjZHbarEsae1XOTwOj4bWp0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=W2+G+uyaywvTjosHHXQQCOH8WG7Itl4tMszraMzJ8Ss=; b=jfCP2I
	UNOb0CUFjSlH8xD3YQYIQR9UCBcVQgmXPkbNVSQ11bZTMujdHnzgiP2EhpeDGg/7r0zlt3EAt/VOF
	3DzTuKZJZE3rga59XuztNvS/rLI0vmGbwMEck5RHyf/80WN2O25yCkSTDFNdY8MORT9yZbuewnZbs
	vSyP/zWbNgOuplhVnp6oHvh1NfE6hMIk6RaDfsW4CKOLnjfZ2rrOeqhecunTfKhGhxn12Xrn67Ggk
	XhQRHbfgoaFGhcIYiOrWmJ53RRRnZoQ0ZDOiHHH9ZHTgoYbiR5+GKXICfJwLZ5s7qSM01f2SOudih
	imoBUxxwNDeXpHLIG7/Es1+ge+Uw==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1x8fkX-0000000D3NB-3H4d;
	Mon, 21 Sep 2026 15:16:09 +0000
Message-ID: <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
Subject: Re: Path forward for Virtualized Swap?
From: Rik van Riel <riel@surriel.com>
To: Chris Li <chrisl@kernel.org>, Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Baoquan He <baoquan.he@linux.dev>,
  Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>, Michal
 Hocko <mhocko@kernel.org>,  Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
 David Hildenbrand	 <david@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Kemeng Shi	 <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>,
 YoungJun Park	 <youngjun.park@lge.com>, Chengming Zhou
 <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)"	 <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)"
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 =?UTF-8?Q?Baghdasaryan=EF=BF=BC?=	 <surenb@google.com>, Qi Zheng
 <qi.zheng@linux.dev>, Axel Rasmussen	 <axelrasmussen@google.com>, Yuanchu
 Xie <yuanchu@google.com>, Wei Xu	 <weixugc@google.com>, Wenchao Hao
 <haowenchao22@gmail.com>, Jonathan Corbet	 <corbet@lwn.net>, Hugh Dickins
 <hughd@google.com>, Baolin Wang	 <baolin.wang@linux.alibaba.com>, Tejun Heo
 <tj@kernel.org>, Michal =?ISO-8859-1?Q?Koutn=FD?=	 <mkoutny@suse.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan	 <kunwu.chan@linux.dev>,
 Meta kernel team <kernel-team@meta.com>, Linux Memory Management List	
 <linux-mm@kvack.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, 	linux-doc@vger.kernel.org, "open
 list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <ryncsn@gmail.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>
Date: Mon, 21 Sep 2026 11:16:09 -0400
In-Reply-To: <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
References: 
	<CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
	 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org>
	 <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
	 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
	 <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
	 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F>
	 <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
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
X-Rspam-User: 
X-Stat-Signature: rnboqjykb5c4bsbty1xg7wmagc8hga47
X-Rspamd-Queue-Id: 08188C0005
X-Rspamd-Server: rspam07
X-HE-Tag: 1790003848-162948
X-HE-Meta: U2FsdGVkX18wiPIWeoQ9l+kUHK+TrFcF2EgwN5rOLlYHdy+LhoXmwti/A2uzK+Na8n6F2Si58ndXH9xWfLEkmQmAMYBk+igew/t2e+aXg6RemVV4HaDHTR7uOA+ugjRd7JF5V934knLnfLe62SmfNCWFaDn910Gr4BocFlOrIDWTOCOk1WzE7iQBi2Zq/DH8rNLo4JM0ZstSLLpKgYaERYlGyznPpRiR0Cz3rlKth982tlswcWTOJBAws8BDC+h7Z0hwcEOwVd9dUwHTq5l2JeXrIxdb7Vn7SjIMXoLy+X2cfmpTZCx1S7uK3rYs7w4wq0p/S/2OHB36sRPoZHma55/8m76VYrGi/n5Oi6+JL9BcG5xptQo9a6gz/0YmcDHupGJKatQqAX+4Id8c5ZuJ/vwNG8RTgiZFqs3K0zOQh/7nB9n2NXMx0Tbjq2A4Vf5HgkfOHE2/XUROUaeWT74+Lo3MD15+R1FWEn3EeK2d11nY148A+oBRKWL1Ci4/z+jflfdAeBCUDui27GYEHdKTke3pxJ56i+s8q8au8ZPQSK9ODz1odaEotzKz+x2RXvaQ002HkvbqrNNjXlYpcu+0iKB4YOnDr4bhogt9AWvpKeCcOOgvuD5x4gW/aIdrqReXMg9NCdXM9uFgYC6u9Mvikmu+/tbw0ZZPJjKeFXl89njUJo0Y8bFwMBHWoGWEjMG4S1xGj1rrOwO6/mbtgYdwsUqTDsMdRkAVj2qNTPT+ocBsPB/JxE6r4OI/2a2QZSewGJouRjm4Y6TwOsv6kqvA9F1OqezrTJ5C6ajKB7vZhsmbxFRWSha5bYFq8ldeSvapDDN65dXmZ/e1CDCMOVBkBMQA5pVb5PwGKMIV4mWhywWFo7X19TtoETf8mIhVK230h3tKvbmidWUeV5CIeYu6e1YIvRSJpe2Zqdg6u7fzbo/huoQN5TtMpi2SkRLc2ZMCBzZL+mgLaWrUjhgoOVs
 PmFbG5s+
 A8Usbbj1d/Jh5F/NCFQo46wXoATmrYOB9H7a2zDTYELo/eKhIXoTR0GIHJifIuuqCF1Gu71Vdll/ZGH7rHcBhCuwdnJHa6oQJuqcxhzN0hmNDX7PuCDRCxmcs2XVQsDFytYHVVn5jGMDpqDkIGqL/DROJImIczLqyRg+/EqD3go7V9U74O/lRe1h4QYSbLF/QD6WrlKM0vWyIX5ysLj5qSVsW2RQTaN6cMT9q3mjQijx/xrsAkLRgN1/WkB92GM6/Vuz+31c0ZxsLTI0Db+QZDZcMl8mxqE2JzT6o/BJR1Rcg8F8BIb/n9hEK+8PC4uZn5quKB8hVLazLs5wdeN0TkaCCMhE7r1vLWkkPr9d5+7PfNKoyb1Iy9gjYtGgaruVb+VcxVsOvXMt+aMNVV/2zucqIvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 2026-09-20 at 23:43 -1000, Chris Li wrote:
>=20
> I am sorry, that is not actual user usage. You need to start from an
> actual usage case: I have a workload X, only want to give limit Y for
> the cgroup jobs but with Z SLO requirement. That kind of actual usage
> requirement.

Limiting how much anonymous memory can be zswapped
does not guarantee an SLO, though.

We have seen plenty of examples in practice of
workloads that have swap DISABLED, and are still
thrashing, because part of the working set of
that program is in the page cache, and that still
gets evicted.

The way you can guarantee the workload is not
thrashing is to limit the total (anon + file
cache) address space of the program to within
some size.

Anything else is not a guarantee.

What is it you are actually asking for?

--=20
All Rights Reversed.

