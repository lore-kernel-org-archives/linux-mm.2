Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A98ACAC597
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 02:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 649E88E0005; Mon, 15 Sep 2025 22:14:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 621638E0001; Mon, 15 Sep 2025 22:14:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55E0F8E0005; Mon, 15 Sep 2025 22:14:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 426098E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 22:14:55 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CF4D7115DC5
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 02:14:54 +0000 (UTC)
X-FDA: 83893495308.22.6E07D90
Received: from relay.hostedemail.com (unirelay03 [10.200.18.66])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2C3EC2000C
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 02:14:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757988893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mx/zo9diUemrWkYL1MF07u5H7GX+A2bBUipecaXpVmM=;
	b=stwTkjeLDsj/YUY66uMOIwM2c64kBzq774tE/1Jgmd3mliSWONKUSyLBFHLqb7ZZIbd3nb
	3ebSj7ui8dkWPXyTyJ5vL9xWqGSUdAWRe9UfA29TgQ6OFLKophh6wAL8K1leEBT1+LCC+F
	ZmzCHdUNpyW036XDNiSspjkSq83VN8Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757988893; a=rsa-sha256;
	cv=none;
	b=Fy1KC0aAG+0wbBGp+jGh5lgapo0LvwpheTdveEhHksuJse94DyJaukWm5B9vrqO9zFkPGA
	ky1uwZrC4P627K5Ov2BUtLVbbOZUoEweOsT/CRQAUZc6+vlB2c9V2Tk1F5bFEdr9yqxt6n
	4SdYt2hI21ykR8DPU5fEHzn9DbTuGxM=
Received: from omf16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DDB32BA978;
	Tue, 16 Sep 2025 02:14:51 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf16.hostedemail.com (Postfix) with ESMTPA id AF5EA2000D;
	Tue, 16 Sep 2025 02:14:48 +0000 (UTC)
Message-ID: <8d7be334af3944f990b56c80a70b7691763c3af8.camel@perches.com>
Subject: Re: [PATCH v2 1/3] mm/ksm: Fix incorrect KSM counter handling in
 mm_struct during fork
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, Donet Tom
	 <donettom@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>, Ritesh Harjani
 <ritesh.list@gmail.com>,  Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou
 <chengming.zhou@linux.dev>, Wei Yang	 <richard.weiyang@gmail.com>, Aboorva
 Devarajan <aboorvad@linux.ibm.com>, 	linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Giorgi Tchankvetadze	
 <giorgitchankvetadze1997@gmail.com>, stable@vger.kernel.org
Date: Mon, 15 Sep 2025 19:14:47 -0700
In-Reply-To: <20250915164248.788601c4dc614913081ec7d7@linux-foundation.org>
References: <cover.1757946863.git.donettom@linux.ibm.com>
		<4044e7623953d9f4c240d0308cf0b2fe769ee553.1757946863.git.donettom@linux.ibm.com>
	 <20250915164248.788601c4dc614913081ec7d7@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/i3wGdkIngDc5k8Zy9mtT9x0Jsae1TNBU=
X-HE-Meta: U2FsdGVkX1/IiBxbokcBHqtrQxfWaIRW4VWdsUC4FwYwqm/5zOBA2s+BAamLDGjQe/aFn7eBn854xpZKTPl8Wiqn/QcEF1vW1Uw9OEf52Pq+BOiart5k8W/VWobc0YHPYAPa4IVrDZmy3fHGH3BpBjcbEdEWDGQmJjOtMGIzrjc3tILATrQm7nwc1uKHx+JcqgAznSoxX7cKwV7EPr2tidUMIg8gL8JbTGaEds0GlD1ZHzRpVayCEXOIeQkyC/QDmBqTc62s1mLNjBkegG/SNdySVqPcY1LGTpuF+NTwpqDHAcGbgn9UhoIgfN0RwdJYa8T1wPf1L17l0gkGKTV/OizrBdeJxMW/eLt/a54CB26/tlJXQ5NQ2g==
X-Stat-Signature: igx396pe9dmf1s33sa9rh78tnb4q9if3
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C3EC2000C
X-HE-Tag-Orig: 1757988888-560775
X-Rspamd-Server: rspam04
X-HE-Tag: 1757988893-779529
X-HE-Meta: U2FsdGVkX18HOzAt6PViIEzssJupBSshoYTVcgaQ16Wm7ZQNuPbMDk06K6bDD6IxUB8NJQjl2kunkyidNls70MIzybxrK39DJqrkijdVYxe2H7ey/W5DNgI111SC2T93/0BlLRID0oOlnBe3pldalhTOecs6XfuP/Ina1MzKRn43UbL4ZNMp9RHDYLYRFXStj8IJ47RlTq8sdLweP3S1WZJAUdnD2CWaUMwXh7V3ahwNw6Z0k+3e/8JbT7ElVxWXLVwj0aCBmKxPczF7QicukLWvxnbbPn4OmTFwA636W+aoDuJjBMARawKBYdmxokWmeYu65gPpi4c7sYNz7Io3XDBH1+WVIRfHlhaHrdcJf0AMsBhEkYXGvmKeGUVxPP13plvYKuW9qA0z7a1KWNYpNaZtZo9bA4jtKBUgYcKZ4IGCtD36mrTxflTfjk5jxFOPqCT23aETQdXnN0ax9W/B0BGmvnVxCNjmfDDj7DSpCY6taRXrIRGQ4FmFwvz2WDgCkO52idAv3XfJ5mjIM2Jo4eChtino+UPVIPTMgbs4NAiklwVTTjXiD35/c5irSGQyCB8VdFMqZYU+Rx9pHfEttO1xwoLP4XxRX2cQ84skZrHA2kVxJI3+I7+nSHMCVRyQXUjo+ozFIsJVD2aniOQyEtnpSyzq0Y0ilpXw98KoOosruqo54Isewty7gy9/ctfxEdFvP3rWUKqfhGjYbURfIWTIlX0fmQHP87H6ppzERUDJY9XnlWyofNl+kwQx2xPRzoMeFbnwN9Wy7KCft7BgBpAwiR90ngMXhiltVdyTW+D+xP7+zGLg8lVVLq5WZY8PmCSRNghOdMM/5cz0b257CWYFgPg2cL6ZwjAQomQOtam+qIwl0G9lF32QdHcFGT3PJhrOftaY84hqIwWuIDaTEGHsaA2diRk5NBdnlo2qet88orSL7LfQye3zeAggILOOBgK494mDYgRuqLG/3DH
 /6lVFoMo
 hRfZQmilxQRlE/OLhwIivcQtIInsLpudJCxS1z4mRM3dgbpEtIhWGqNN5o4QYmdFJamoNMPnVHIp7VRWiYOo964fX65zdUs9UAmDAgsQKxm74iRt87+OAQaQ6o7XR6SfPpHN8QPKkxnQzqHI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2025-09-15 at 16:42 -0700, Andrew Morton wrote:
> On Mon, 15 Sep 2025 20:33:04 +0530 Donet Tom <donettom@linux.ibm.com> wro=
te:
[]
> > Fixes: 7609385337a4 ("ksm: count ksm merging pages for each process")
>=20
> Linux-v5.19
>=20
> > Fixes: cb4df4cae4f2 ("ksm: count allocated ksm rmap_items for each proc=
ess")
>=20
> Linux-v6.1
>=20
> > Fixes: e2942062e01d ("ksm: count all zero pages placed by KSM")
>=20
> Linux-v6.10
>=20
> > cc: stable@vger.kernel.org # v6.6
>=20
> So how was Linux-v6.6 arrived at?
[]
> (Cc Joe.  Should checkpatch say something about this)?

Probably not. Parsing variants of versions seems, umm, difficult.

