Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1EEACD5BDF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 12:07:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 441B68E0007; Thu, 13 Nov 2025 07:07:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 419A58E0002; Thu, 13 Nov 2025 07:07:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 356948E0007; Thu, 13 Nov 2025 07:07:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 21E998E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:07:40 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B38FE13BF05
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:07:39 +0000 (UTC)
X-FDA: 84105459438.29.EF910DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id E25A54000F
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:07:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NQYyO0ey;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763035658; a=rsa-sha256;
	cv=none;
	b=MrgZ+1hYfZA8cB2ZES78e5firpyu5+cojN1vdbSPX3oya9CkQKENWtyp4S49cOFZGX4T9E
	XdYn7MVCDm7hnP07HvcSZvc496vpBlJ5Iy5hRZ0CK8rzU6bzDN3MMnpXphcp3521fjIGsx
	3+qkq2lfqKw1LW3V7JjD9WjEJ1T2DQo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NQYyO0ey;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763035658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DGLWvjS9QDmMBMFO2593FObu/DeeRq99DHOGcQoHK4w=;
	b=x3sj+snzKHykAZao94Vt5STYXiT85CwBXWz2Wv80A3/GTHQGgUXFjqdwrdvw89vxVnKOs/
	ScFFCBRUqQdTLczbESAZIZPp5a50jtAbMPgYmWBpyYeINmdoUm5oHsbVbQD7CiszZDmqwo
	UFvTQQ8Bp/ggj1LhpGffz5adsAa0HOM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A95464463D;
	Thu, 13 Nov 2025 12:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76980C4CEF5;
	Thu, 13 Nov 2025 12:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763035656;
	bh=vzK+e/EERdiP7f4QpvpjeauHoZUwHHPjc798dHm05QE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NQYyO0eyge9WGW2PKiUyuk73zZNfAKP/4yF22e+iiE4+ZoATBpS39Y9dSy2zdmsiE
	 5Al/pFilhBVSHupdRPoEgD7+yr3QfGDxOVhAV13hBA3SIx51DW5L21QdZBLjuJNGLF
	 Cf+k4Oc+D3yp4Uc0OM9b/cnX2BgbM5DRCBQV3LTA/m1dzn3sKBbXdNgk0x7zmf8qjJ
	 RiO4Xi7c9KsGYXWD+J28jnr1E15IwCizP4Go15vpDP3OtmmbVdtQuuhduY76yMCHRi
	 /tHEDf6lp2icY4aJO1D9P1udVnJPj7rn1ND7/QFKA3WvWT1yb1fmMa7OZ3zTG8BUXE
	 BX7Mh9TSvB/IA==
Message-ID: <dd1da795-d37a-47d2-87f5-50853ba43519@kernel.org>
Date: Thu, 13 Nov 2025 13:07:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: fix override of entry in
 remove_migration_pmd
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Balbir Singh <balbirs@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org, Andrew Morton <akpm@linux-foundation.org>,
 Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20251113051352.1753714-1-balbirs@nvidia.com>
 <ed523668-92a3-4eaa-a999-4fb7a43e197d@lucifer.local>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <ed523668-92a3-4eaa-a999-4fb7a43e197d@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E25A54000F
X-Rspamd-Server: rspam07
X-Stat-Signature: 6qdcrbdmafhgm3orqgeewtegfq67jigy
X-Rspam-User: 
X-HE-Tag: 1763035657-709327
X-HE-Meta: U2FsdGVkX185/7uzvAkRsA/ThwiRhNnw5/xg8rjxuxgq9EG2ij4ud1pGqcZ0lrKVAQPspO84MLokrj7KhLSbtClZpbIlpgz+h9K7Eiuw0bdJpH/BbnXT//g1cYekTiDJ0JJ+GIR1HjuQXs5otaWtNYIdLQFQ5QOQIOZ99GEXJX9j65fYPO2JRbwtp204KRiLpTdDkeH+9bpoXQWnYJH7jH2HYXzHgDqp8kdEoXSA4WdvyQ0wMpjtWdz6e4NEz4lcZ6GPbfag4GpUIbVDgJypfvInn0A7xRj0BJWeKDzkaz6jUc2Ygt6UFf5o6dXlhsFH4U2mvmtStlWBOGuNn7ChqIKCFVab2pnrrnTrfn8gYz0vedDZFmPaklTovxSyrkKFi52QP7udZ6fSIX9Rcn48bBYPNzi4PkZ4jbGh5dJ6yteAYhAMrOzqiR3IUs9SNaVkBfvCwSOUWWpBr7o993ju3reWPY+MchqdK4lQlwvYrG/eRXSJk/UhXBX+OsadRAZ/C5xbyNPsBMAsXFSw8uJJ6tLPIZPlTorUjh/6tAtBx+BQvTK/0+V4i/MF/HhLoQj669e1b1V/Z/GJfyzIFw4nldgnPXH0h/vZiAhw5cM0gPVBDTAQRzyL/pn6yk6h2RQ3u4j7wV/Ck19aeLLwHadmDk7ieZYhGkxF6hgkAM6S62bGpLtVFzWCE3Eq84QvBsfUetrbHmbUrOoze7e97z1Us/dEKHoWuZ1uz93sCCBoz1gJiE8kNxrs9y3+MpYLMfdJWW37BnAhblCXpelQ5i+3BPEEOFaioybz2dwMMAiKow0s8//mMRrPfbWVhx1jpDwtCg9/JseJNLRvjx+VWQMqygVbTYTdEqUBq1NQIZj6xTG6hXqi8kYrYsDKM9veO0VmEqw56ru1n7lKzCXePg2yza+n1iou+ETGyzvZHK9rpsEXniDrRvbN3ZlyuFp9fj6QiGtTEbJTe/r0ouY1ujc
 o9TpZ1jh
 M3s7apjHA/vLI9mbo04bFJYI6heAFfHbH27G5BtxOLiykaZVJtY8woucXSnngL1CX/631lc0Xd1JXIO3n0nE+VH7l5Z3r0iwGwJLoe7f3PiZFsD3hQriRZwkLF3ayOHtbn+IN4cj8vuVnJKVC1RLOcyP7UqJ96opoagdcCHk7ygPnkxAZqhGANuAsXkixsWDj1i7HVw0evSTnsLEsIwCRGddfHU47NPmjLAX4iPZ3uO3Nx1O5KPLzXOWevEPhFNJw85uGkNKBca85Xx7LNQnYKQ1233cmLP8WRad/iA6S7MKEUHsYW6mR7yBuInjCWZyEsQZRT3TUrfgWcRmqAhYBLbRSkoKQYcAJXykJQZZc3c3GBqqB8FH15sUJDWeFWscTRP9FazJPToUQ4dcPRdIpe7MCP5FI9P4Mql2/0pq4gohkF5pwdHvwtIAqgEWtL1ZuvqdLUvopQCnl1VhUxfStn4itAkpBOZlcdnm4+BUd7+9iq/VFXLo5kmqhgWWoDU2OngnBJhsbPuOaWtaBSypb1kv8aR63enZQE0OGkQzXIwLUyavrFqf/XH8Q23/P4BR4FTas56Fk2E9HtO/yTTLQNhAb2o0bF7hnePns4khTI+uu036ScdpOSme3HJKNGnScR1di5PFnbiU3NPgpc0B129/2p1vsRxe3Licr4NGVTtKxa4E5imdIdrfU9lndzq9XrD5QYpx9Eio5Z2wGoEJT2yBMm4eMj7aQhLMTLTEzlVoEalRLRhPkYqiRpRceWmkrgtPCgUn9lClkvk9b/jm/zM1+wGOA3Ba9vP/4w7so2hDL18g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.11.25 12:56, Lorenzo Stoakes wrote:
> On Thu, Nov 13, 2025 at 04:13:52PM +1100, Balbir Singh wrote:
>> The softleaf changes exposed a BUG in remove_rmap_pmd() where the
>> migration entry was being overridden when the folio is device private.
>>
>> Use scope local entry for creating the device private pmde. Make the
>> pmde writable if the migration entry is writable by moving the check
>> softleaf_is_migration_write() prior to creating the device private entry.
>>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>> Cc: Rakie Kim <rakie.kim@sk.com>
>> Cc: Byungchul Park <byungchul@sk.com>
>> Cc: Gregory Price <gourry@gourry.net>
>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>> Cc: Alistair Popple <apopple@nvidia.com>
>> Cc: Oscar Salvador <osalvador@suse.de>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>> Cc: Nico Pache <npache@redhat.com>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: Barry Song <baohua@kernel.org>
>> Cc: Lyude Paul <lyude@redhat.com>
>> Cc: Danilo Krummrich <dakr@kernel.org>
>> Cc: David Airlie <airlied@gmail.com>
>> Cc: Simona Vetter <simona@ffwll.ch>
>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>> Cc: Mika Penttilä <mpenttil@redhat.com>
>> Cc: Matthew Brost <matthew.brost@intel.com>
>> Cc: Francois Dugast <francois.dugast@intel.com>
>>
>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> 
> THe logic LGTM but we don't want to have a bisect hazard here by having the bug
> introduced earlier then resolved here.

Exactly.

-- 
Cheers

David

