Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82011CEE350
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 19:28:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C88E16B00A3; Tue, 18 Nov 2025 14:28:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C60506B00A4; Tue, 18 Nov 2025 14:28:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4E916B00A5; Tue, 18 Nov 2025 14:28:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A24B96B00A3
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 14:28:51 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 68D931401D8
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 19:28:51 +0000 (UTC)
X-FDA: 84124715262.18.0ADB5ED
Received: from mout.web.de (mout.web.de [212.227.15.4])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5BE311C000F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 19:28:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=JBPZi0m3;
	dmarc=pass (policy=quarantine) header.from=web.de;
	spf=pass (imf18.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.15.4 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763494129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lB0ZWgw/k2CwhgjF2FjWThV8arfjMFhP8yVqg8kCNw0=;
	b=RSJzFAdOXwyQ2yh7QHdh74vChNQrFCmjrkMNr6o76RLK2S2lLdPH1nqNu1GyiSnhNK+4af
	eOSbHhrU2EfBqP44NChpZImxKPM79rrOqcgv8qiGDXwgZu4yw5ZE7oTFxunzgKSnAeMXA9
	oyCUWbrYn/OSaQgxUvZwVWCMSM7e09A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763494129; a=rsa-sha256;
	cv=none;
	b=PvKy/t9JMdTSWHSrRna3z1fm2791qnbPFimxotf+jlFiYc+JU/6c0hpTiJ4w1lp8/rpVxQ
	cAYY8WN/qyiyxOu59ANmzj33mXV5LvmGW1UxsIdo55qel7vs6ThzLw4WvJnG6RkV9Wueug
	rmWbwoH5Yg3SCkJz6QddSnKMl0e65EE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=JBPZi0m3;
	dmarc=pass (policy=quarantine) header.from=web.de;
	spf=pass (imf18.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.15.4 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1763494104; x=1764098904; i=markus.elfring@web.de;
	bh=lB0ZWgw/k2CwhgjF2FjWThV8arfjMFhP8yVqg8kCNw0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=JBPZi0m3nhkjh6oNF40kVvPHHN5SUPhaxNg/rxAac+w1SF1AjGbfbcNOEqpum9/r
	 as2BXgh6VwiLfSFMqnT5RhnE6oYvj1jk4OwvVTUee+d8VNWXxzVSHOe1f5OTfMiVy
	 LNj1+bZv0JF9Dmwk187AAnH5r8XpU3nZdXSz7Nh7c96wETtP72qE4xQMdloJxceaJ
	 azhB/aCM408143Ip8l7e1AcF81vusQ/+dk91qSStA55CEifFJRzg7TPxPBUACGZCk
	 RY+S30FENHCtJ34hch2f6l/eLsnX/3jhULDnRbhFjCwnTaSvBieDe1hooLmVrm/Rr
	 C0IHkez6GOvnYFv5hg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.234]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1N6Jxd-1wEY6L2RuD-00ruGB; Tue, 18
 Nov 2025 20:28:24 +0100
Message-ID: <ff020eec-7928-452b-850a-b9ca72ef89b2@web.de>
Date: Tue, 18 Nov 2025 20:28:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm/zswap: use %pe to print PTR_ERR() values
To: Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org
Cc: Sahil Chandna <chandna.sahil@gmail.com>,
 LKML <linux-kernel@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 David Hildenbrand <david@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan
 <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Wei Xu <weixugc@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>,
 Yuanchu Xie <yuanchu@google.com>
References: <555cdbea3a51898e4c84fdc0f444dae0c2e20f24.1763227530.git.chandna.sahil@gmail.com>
 <c5f92735-0e2b-48e7-9181-04bc058c0bde@web.de>
 <aRyMs5JrQDxmQHJN@casper.infradead.org>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <aRyMs5JrQDxmQHJN@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:FCwOijBzavl2+Ci0vtgq4EJLK0DqDWPS6YCx46TJKIDMF5/SBKG
 kpTNKt2n8eOUHKPtZXXhZbwRNKuSVs+w2nSmSbLEPw7SDbAcSNiKee05uw3ybdhBn3uKrNt
 c2yNqwEeGMTVof+r5YcdfiUnfWF4jKekXYw/sdkJKUT6BswRdSk57ekz2NO0cyr0jzdwB1v
 83WDwuYSstKm+VOcWAvpw==
UI-OutboundReport: notjunk:1;M01:P0:eOTzlCgqan8=;y6Sisx22z8f1lbaBG1mgGAUX19+
 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
X-Stat-Signature: i4osd678qkgbkdm3yhh7ahmoqqtanpbj
X-Rspam-User: 
X-Rspamd-Queue-Id: 5BE311C000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1763494129-796908
X-HE-Meta: U2FsdGVkX1+WIjQJODgQSxTK0RrgORuz1OJx6TIaFvaaxPb2bHIwul0oId3bOpQkIMdb5aK60Lz7BccyiYf1k+kCukkbPzahoaN+ztuPXyRZ2tk9jiVawFCaDQhYZlbtF36CQCVHzjbafq6S0Qct5pP/ZUovl7pvUtfjAnIXiZGd/3DeTf71jdoK8oAQGhhrl5PtjqREHusuE+TVQH7Pj3rGbglTsgqftBKDzc1IzkHuEJPyC0pn2OsowCC3rB2gh6PlUSgawfGtLyTz9BgVGU5Sd8pF1oPkY1wb7j6dJaERfow/jWzWXcD7dq3pnB/R7oTdZrP3HlgOjhv5SxSfUU5ndsxTh7N6vHLs1IXyYNpnN+TaCCSLomCgRJ5WNvMF5YBU0o1NAZ7troBgJM4eByJXO6Bd6LW33pfjD8TjH5BRynL/2Y0/J1Siqo/xJArFDuObfFcomcQ9PME4cGIksmTAUe7qh372ns4n8rkjnCglrmWbXhYYi3AIXNJhPvNSMA7b+bIVeS6du6CLjUwPX4ilBY2Fkl/24unyWYVBQ5P5KsXTa26qrZa4pb36y6T68eQzbnTMjQ8Jkxj8Ys3Qh11s6hXXLj0o2w1DevXJ0j2Bbeule5lsFDfLK9oEprOoVpOshknO3Q2qiZ/yx03cV3cfFgmffbYeXYqOF+cJ0WvlIzoUOi9gqOT4s6PnwFG3M9kXn6tnsRPrM3GXJhiiIguTkMRI1dzmn4ogH2PjzgaYaxsmOb7EbjP80O9+SOZKhS5L2YI96rDQPnESOMyytVn6FWyaJX6THXQ36T9Hi31EPSPB5Qn9qxaaec1u++bWrFY5dehlwxtH2s2HlSDgAoQBCcu1FaF4hUEkLfO0k/jKAp31LmcmzxCBUhxQangaw/RB9lS+2W67hyXLjlI5h/DIDTxPBMqNzNMg4QTiitql4w30nG8SOmBlU3T7Dnt7j9/+/DxYGQPM2wvaN0m
 DSIKU9a7
 vOSpl0WwI9DKP+AZ1GShxuFMYZ7FF5Jr70mmhYeiy7gEOlyo3bIHKiQsKmuGeHvc4rvEZ9E57ftOmZ10NYu/SkP16oQ6W81vUbJUBqe++LLXMcgyBra1NN3gbGeyhOc32bJ6g
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>> +++ b/mm/zswap.c
>>> @@ -749,8 +749,8 @@ static int zswap_cpu_comp_prepare(unsigned int cpu=
, struct hlist_node *node)
>>> =20
>>>  	acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(=
cpu));
>>>  	if (IS_ERR(acomp)) {
>> =E2=80=A6
>>> +		pr_err("could not alloc crypto acomp %s : %pe\n",
>>> +				pool->tfm_name, acomp);
>>>  		ret =3D PTR_ERR(acomp);
>> =E2=80=A6
>>
>> Would you like to reduce the indentation for the passed parameters?
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/Documentation/process/coding-style.rst?h=3Dv6.18-rc6#n110
>=20
> That is the exact opposite of what this suggestion is intended to say.

I wonder about the interpretation of the provided information in such a di=
rection.


> Sahil, you should ignore any suggestion made to you by Markus.

Do you try to distract from reminders according to a known information sou=
rce here?

Regards,
Markus

