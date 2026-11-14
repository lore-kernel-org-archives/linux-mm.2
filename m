Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64FC4606A335
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 00:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WjUSNxfM
Received: by kanga.kvack.org (Postfix)
	id 45CB86B05B6; Fri, 13 Nov 2026 19:44:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F60C6B05B8; Fri, 13 Nov 2026 19:44:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 333156B05B9; Fri, 13 Nov 2026 19:44:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 181906B05B6
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:44:16 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 990B7A031A
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 00:44:15 +0000 (UTC)
X-FDA: 85431878070.05.71A0C6B
Received: from mta0.migadu.com (out-243.mta0.migadu.com [91.218.175.243])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7E37880002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 00:44:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WjUSNxfM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.243 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794617054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0xtAECFW3pXMdSq0lQxsNOUtdAywWPfdRsyXX2fdCbI=;
	b=AjESoOV7CEJjynAPz//PtXUpHLWpIq7ilXg9/Y6q0OeGfU+htya1TAKfNMgUQuTYvP1zWa
	nJ9XLB08xQr92bDaQ94YpNUIFtXLvDZGtkOEZrU9T5Ex9lPurVcF7EhxdZzoIQ9rY9sdfE
	NJZsRybUSlg6EJPPUqpM+bizVRscNEo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WjUSNxfM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.243 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794617054;
	b=fYoIQafX+bS6YlcnQaVuTmU2u92OJ58PKUKZj7pgfMiM76N9uwMjOGcSA5WQ5yEuz/PQVX
	jgOAD7oLeFk5xpj0tGmLOwfOxrrHCkYM8u6+FSLQBW5N2Bxt7l28maY26bT4VeE8J4t1DU
	BkbfH+saQRqqt6eOEwpBtpcdGpzS6KU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0xtAECFW3pXMdSq0lQxsNOUtdAywWPfdRsyXX2fdCbI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794617049; v=1; x=1795221849;
 b=WjUSNxfMy0hDfRyJzKb819Vr/dago8ZhjlqIKxCsU5Eh/iEOn0k+mzOYY5mGr8iMuoO0hh+Z
 K6oMia537VmqhKgK7nb3poZfl/2UCcThfNEtH191QPCFb2+U6W2hubc0GOWNCIPNBpfdwHU3AG3
 l3v7d6oflc98U/ClmRZcbGjo=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 5500ac1b1da158ed;
	Sat, 14 Nov 2026 00:44:07 +0000
X-Mizu-Trace-ID: 5500ac1b1da158ed
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH 00/15] mm/hugetlb: various fixes
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <835c18d0-bee3-41e8-aa46-05dc7c1ebc64@kernel.org>
Date: Sat, 14 Nov 2026 08:43:44 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Mel Gorman <mgorman@suse.de>,
 Andy Whitcroft <apw@canonical.com>,
 Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>,
 Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Dave Airlie <airlied@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Peter Xu <peterx@redhat.com>,
 Breno Leitao <leitao@debian.org>,
 Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Arnd Bergmann <arnd@arndb.de>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Gerd Hoffmann <kraxel@redhat.com>,
 linux-doc@vger.kernel.org,
 linux-arch@vger.kernel.org,
 linux-s390@vger.kernel.org,
 luojiajun <luojiajun3@huawei.com>,
 Josef Bacik <josef@toxicpanda.com>,
 stable@kernel.org,
 Chris Mason <mason@kernel.org>,
 Daehyeon Ko <4ncienth@gmail.com>,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <6EDE76EC-0CD2-4C34-BD06-234E21C7BDEF@linux.dev>
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
 <835c18d0-bee3-41e8-aa46-05dc7c1ebc64@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7E37880002
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: mpbmgwe7yftyadpzut36n17pjogghokw
X-HE-Tag: 1794617053-242445
X-HE-Meta: U2FsdGVkX1+f7gqcYQp3Zk0RrLNE339hBu7KGXe6pTtBk4JInFkul03IEE3/WoQzxBf7k424BngGvHVUvS0fa0pwiqNzh2IMLv5r/C0EtlwJaSstrX2eKhijFqqo3N+oJQsbBlLsMSLztLo0yLHmBPhv1635/SrJ18obS8HEkMlC3mJcrn/VqrxNOOsUon73YCG5wT1+x7MrZvfwo4CYhe2/C1Iz+cFbrM7N0Hy7YV0hUgmbkC9nGET+l/KAe7qrgCeSYACTH1Ly/cDbzRy7CWq/t9JwU260sCmI/OcVb8duIvSZXSfw/DnYeRmqX0/IEczAnhn2sXeox1frodEeKf/2hwYQk4KM0pirZpwx06ucNU2C9k4xxjuEiU3cIiKGfiPFrcO9LsZd1/YyvyUW8qxukfKtGrZjkXjPwwvwfWIB4nfew/zpcVvlc7lbZK2TYwn+cutiUsl8v4DeMo+YwwNLJlgVo5yZ0kmI7SfvhFEavtIKAOKu1LyVF2htLRmqri+lirm8OVUf12SVSO+NejI4BWU+B83TOSbXqWMghuPTPbinAFAvozse8XLvGPoMnmzj/KmfgzJ9tnewoq401gConTJFfVIXETHJWatdxnAfhSMfUZvkZmwONsL9TO07igdzsjG0T5QIgyXfhnTOtEzSc8/AXHhQ+yJiF+n+sI6RS6niuQx2H0KM9HoHOFXIudzHh5OWteaveHgTMU+CoZtYsyFJT+P0oep0MD9z1LDFZM0wfQ1wZ4oeeqVn/8xk475fK/11c3U16BQEWjoSFvSfbaOmhcIa8A9UfRe+5Ryn3w46K2SFlISsc1sPBpmKQff04nN+0UwJJKhmGT9+03We46Do48lrkCwM0WCCgC8xnyfWUKHF4+dj2RKDr54DG994wQ+0d/cMjQC/rX50Q6+71gjsqacunSrFzT2AfPDqyJ+25BKMujPmYraCbs6u9hInikL8HyfBjRCJ0NG
 gFEQmG41
 yBRxwcdr9MXrdCXD79xnTaUDP/mYlPyYUG6NzPbCL/WPjpOr3cwHSS75fM34PEFPozcjKW2VoEOmvbPDBx8A/0ZoGC5/wNeTkUDpyAwoPXIAdh9ftIgc6mKlQ3Ur9tlSf9SGb+SQ5CK8im1ddNsNAuZyaMYGqkt8SRH3AJleq8PwxfKNXY+pXtu95y63kCOElkpJMzleemed37scRA2tC9yjzhvUXTfkYeb6IsjH8mAgiVJmG86pS1Tj5arO2A2W/tMc+uiyVTTkuZHlRf6MzQ7ZRfFX5ZH65m1D8kOYygIt0N5nNfOUVmz9zxlYod4Qe7qqRMm6IqGkE7TS7jQAEN2dMXPSGid+ZurP2XURmyQ5QN04oZmvMF3vWF8xJkZxYRpiyvZats/cMJxs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 14, 2026, at 04:22, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 10/28/26 21:13, David Hildenbrand (Arm) wrote:
>> These fixes almost finished me.
>=20
> Muchun, Oscar, should I respin with an un-rfc of patch #14?

Sure, please.

Thanks,
Muchun

>=20
> --=20
> Cheers,
>=20
> David


