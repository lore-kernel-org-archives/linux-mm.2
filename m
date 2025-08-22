Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A254CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 18:02:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6DE38E00C8; Fri, 22 Aug 2025 14:02:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A17B48E009D; Fri, 22 Aug 2025 14:02:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9063A8E00C8; Fri, 22 Aug 2025 14:02:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7A5DA8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 14:02:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3D40D140285
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 18:02:38 +0000 (UTC)
X-FDA: 83805163596.22.E874735
Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	by imf22.hostedemail.com (Postfix) with ESMTP id 43B0DC0006
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 18:02:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=jIHiaXUZ;
	spf=pass (imf22.hostedemail.com: domain of bvanassche@acm.org designates 199.89.3.7 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755885756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lOWWilxxOW7+2VFeqILToF3FfKlMIiqdFUMj7Kr1eMs=;
	b=AWN734GWjw+qM/WaejwteiimvSn+QgF43OiHqRSR2sEt7gTtMcX4N/kuzVZlKVoJkxMmCy
	0VanXOgzBm0TzZ1brzdu2+vKI5X3Tk4m4Op/ClRQokA5unbvnJp6asPTovt8oPG5gqdIT7
	Rw3wygqFPZW4nITiE6GH9TNqSpcUSRc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755885756; a=rsa-sha256;
	cv=none;
	b=RkUOtKVsEiSbkb+luoROawkSf3exmz+WUCyBRLM53jlDxGfGqkzsl2oAun/7DSyPRS4Yqe
	pKiYRQfrbqI3U9Tf3JQ4wQM9xASIxgpkVIbcH0GA9XVYL06wZ+QERNMZ+/seEVRo7ZVsyT
	JnpmhG2ZushrUUtBm7rNBK/GPrCNVQk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=jIHiaXUZ;
	spf=pass (imf22.hostedemail.com: domain of bvanassche@acm.org designates 199.89.3.7 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c7p1l0sq5zm0jvk;
	Fri, 22 Aug 2025 18:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755885747; x=1758477748; bh=lOWWilxxOW7+2VFeqILToF3F
	fKlMIiqdFUMj7Kr1eMs=; b=jIHiaXUZ4a593YVAmQUji/OXI8ZOHuy4KoDqdDsN
	58VfzQCide0+H5Soq0lOaHim7utGBp85yd4TVec/He8eSJaEr0S2QMbIL/R/v50G
	REy9REjBcUkTJuBw3HHmfYoLlR1WNAs0/AuKPOafAhc+qcEkQgAYy7xjbaBw1u1g
	U/z1nX2JBLXLQyO/89G55vSyN53ByvfYmVd1rVmU9cGfu9CmFM1RmYCGRPWih361
	3SEND/VGUpbDsbMpeaiIGxU559aePIaIJvP6dzsdyNy+XOIvcQerQoCWbkkZ0+iv
	zE2zZ/+N2HfKRFU0le6ozhjHgt3LcQW5vt0XTPzWIir5yw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TWskR_z3NWFT; Fri, 22 Aug 2025 18:02:27 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c7p0l0k1mzm1756;
	Fri, 22 Aug 2025 18:01:41 +0000 (UTC)
Message-ID: <58816f2c-d4a7-4ec0-a48e-66a876ea1168@acm.org>
Date: Fri, 22 Aug 2025 11:01:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 29/35] scsi: core: drop nth_page() usage within SG
 entry
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Doug Gilbert <dgilbert@interlog.com>, Alexander Potapenko
 <glider@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org,
 Zi Yan <ziy@nvidia.com>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-30-david@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250821200701.1329277-30-david@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 43B0DC0006
X-Stat-Signature: fqrrxjep5bkf9chb9r6qo1chhtgw4xt7
X-Rspam-User: 
X-HE-Tag: 1755885756-825239
X-HE-Meta: U2FsdGVkX183brgZdHQR40BYjpSmefhsKBp4ON3sjk6T0Y83F4MSAjtLCaqVkRE3l6Hm0hCqh9osbqTJGEMGPEknNujFsR0vZwtMZ/LQfhvt5q+lM65fkiU2c086YQ2HAppRX1U8UEzR+wd622gHYo6bW0VTnKJ1YKMCmgJmfTlVw+E3F/9pTp9ypWU5k7gBPH7xkiLD2JX0p290itI84a+vlnhsXi2nvH0oG0UjeAm86+lLgT5VMiyhP+WOrAMcvDwaVkFG+GasYTIx8kx/ni9Z6NOdsFzgNbgJO8gQdmLKs3YlaKl9CX/uUsqj90rpozqYEWAzc6Z1ubsaJtk6avtlBPL7hP7aMPUKPgfDgP/J4HwtOH/2dPiiwcL7Z9b4+7X6cnUB+lwgtr99N2hELsW4fmM9QvF/Li06QPSB28rvCSCb4rkoKNvpOew/AA+e77bcsTUY362Fac6sotJox7bA2V5/Q7YQkxup5EN12BpfavxVVEAXvT6o7QdlymuMx/iu44+2Atmm90OG0TljuGFb2XFCQmPjbcLMehaWRs6tGYP4prId+q0EeHP14jpQiTRvUNQ/p+rHukdjP5pRpkmWO631c2UCWs+cKGV4cD416il0Q426dIVmN2FpNZwCIURcfRePOrpIKQ9ZXVxWBq5a46ssEB2J3g9erGo57piEFjWPDH4KDaNpJS4qesF2c4U3GHgmxNTpsZs90V2nVa59tOqR7I0UaTpyl0M2+onhermF7evNldhuP9d0nZjpH+OgrDOfom20lwBz3yxzo96Np8BfvUfXTiZa8i1gEe89wecwtMKBwJgJ8g3wa3IiYGkEMO48UHYeHx+V5mkGn2RBI81jlxsNqTrvIltz6CephnAQZYCt/bfmAnb+fHYdfY/2SvzXHVeG2cdmApZ6VQfR3JbsBVm/P/m7EWw1UXGXcEOxZHdxtrwztmgBu+KHx4auXPAeLY01t1EIBOK
 KSAt2i8d
 GfHrg0o3RiVrKkCBdleOYaVqFEYD8VD1UDA4tufAkUr3cVaVn8ntSDN9UJ82btegwd13qGDlG0Sw8e3OWKVob7nGLscKE6pwG5f98JtxMxQGR6nakt25ootMFpgy55Ymg0nsZJ91Z5wIty9+5ED7wnouyIkD4MyuJvIfjMbxvP4+m7KTeTLv4unN/MmZxGOVt4sQdzgL1KGlL/5tvCAZZh9rxgMfev2mzAq31bpoD4YyZkYtURVa6fbKrAqgEKx/UiK/fnDRY4O543/mGC02bmvZgD8ySnCB4gDM1WmlQ+ifrQC5WVPzMf5prju6EaHDeBSawORJi6i2otV+O+uDmW+YfhW7TGNlhbjNnSZDaEclNmSQZtXOe3Ib8Ee6t8j9neapm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/21/25 1:06 PM, David Hildenbrand wrote:
> It's no longer required to use nth_page() when iterating pages within a
> single SG entry, so let's drop the nth_page() usage.
Usually the SCSI core and the SG I/O driver are updated separately.
Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

