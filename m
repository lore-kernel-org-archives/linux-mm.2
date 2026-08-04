Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF79FC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 16:19:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C01506B0095; Tue,  4 Aug 2026 12:19:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAA3F6B009D; Tue,  4 Aug 2026 12:19:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A71EF6B009F; Tue,  4 Aug 2026 12:19:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8135E6B0095
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:19:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7BB0CA0241
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:19:31 +0000 (UTC)
X-FDA: 85064097342.05.3712651
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf16.hostedemail.com (Postfix) with ESMTP id B4BC518000C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:19:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=sHtfao+P;
	spf=pass (imf16.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785860369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E95ReJy9DE9GiIJH0l+XVPQUMS7fnh6eJltHCKDpl+U=;
	b=CWwrtUW7c5tfM0PfUSA9GRgU0MY75nyPIvw0uASkC1k16XzIa2YwB4HZ5e0R+EKrxtGk8Q
	usUEfZqizhqB/PZzcosjX3pYe3BZXGHZgMqNAS6EAeoP2DGXSURQFOqEwQNeWvo2L7Eksz
	5bwFFYRUc+bldFNo0ida9tLE1MSzqlo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785860369;
	b=s+U3BJ6vQgf0ygZ5YUne09IHDGRrVmjdtvlogbHYlVMGI8HbbGfn49edScogg8QVSqgxzJ
	DtRrORsC9UKVoyloAkuDbZCFV2WZaZK3M/xxG7FGA7/ep3/f55MbVJPgQv7opEQJXDXpSc
	LNNxCBRTQYHOuVH20bTtt1JgxAeYagc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=sHtfao+P;
	spf=pass (imf16.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1785860368;
	bh=E95ReJy9DE9GiIJH0l+XVPQUMS7fnh6eJltHCKDpl+U=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=sHtfao+PlU9mdbJDyFXTTnhzclUtn67IfHvtbkzcR7yPuktwdDdUkvM8gE9gtKzk0
	 6OXCWy5Zu5lbkxQOuMb5sE0mAR7d2cLL89M9F3GEEjNGqIt5BWuBoVYQr+WrlzRTiJ
	 V/pySj3LduZjB5Yp2N5ezaq7qyzlSC1Yekr2Pfyc=
Received: by gentwo.org (Postfix, from userid 1003)
	id 928C7408CE; Tue, 04 Aug 2026 09:19:28 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 90FD040287;
	Tue, 04 Aug 2026 09:19:28 -0700 (PDT)
Date: Tue, 4 Aug 2026 09:19:28 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
    Mark Rutland <mark.rutland@arm.com>, 
    Yang Shi <yang@os.amperecomputing.com>, 
    Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org, tj@kernel.org, 
    urezki@gmail.com, catalin.marinas@arm.com, will@kernel.org, 
    akpm@linux-foundation.org, hca@linux.ibm.com, gor@linux.ibm.com, 
    agordeev@linux.ibm.com, linux-mm@kvack.org, 
    linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
    Linus Torvalds <torvalds@linux-foundation.org>, 
    Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
In-Reply-To: <anHuLy52o5S9Nlwp@lucifer>
Message-ID: <63ea8156-a109-b2a2-6d35-1c17ad7f1a9d@gentwo.org>
References: <20260715180455.515692-1-yang@os.amperecomputing.com> <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com> <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com> <amCPBrdltFSE_fEf@J2N7QTR9R3> <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
 <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org> <anHuLy52o5S9Nlwp@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B4BC518000C
X-Rspam-User: 
X-Stat-Signature: fymqzfc7rm33tatrfjjf86e8wyock318
X-HE-Tag: 1785860369-452747
X-HE-Meta: U2FsdGVkX19gsLHuCs+Me1W52CfJoLTj/v1yGGgqyy4m/+gjeJsS0M7VW9L/ddZdEhfjaxq7qHAw66grnmVfbE4c4mFF/ocxj5GbIG4CalSw9Z2QXFgWaXbN84KsBD2gZ+Xrp/clxyAPgF+gdETGqNULMy2mqoOU5FDBBYTQFs7PAFIgM/KTUMAK+Sliw9EHWE9udu0cHLBcuACOOJ3+T17Namqto+1Ptjt6gjYeePLB4mFWG1DDkh9nBv0gEhUvGs0/BE9hQJgaTbannIdGjDePAMkzgXIecwrCyNWD8/1XqxH0fQV3wTchGIGl1O5Gu8Sv3xoTvs0wlWShDOXEGMAycpzSdE3cZF7lduovFdXecQm1G40RFPKkp7PCtMf61Mmd3dR2K+8VU3py/kPSEviHstvKMwpCIK5FgVHHme/HocM2FiG5Zb7ipJp7FhgN+qdwYCEluw0a5zj59TFPcGKGSlJan+rpq4pUWzvTH+AFVHeR0HJLpv0sePW4Pkh74qdj4zBzHbRN4ZS2O/eDegt6CtCAsE0gSWGrDCtn66qJOUAigEE/0q6jOeqQMzmGNtsskgrdQToiooP0qn6NFH684bs4u60ujCPpf45Vc+KT2lIXwfDNNdGW0r8CkXuKG0uRH2Pr7m1+QeSpUE+B8HPZvyow4XRGmu7vYfdZLljf0GfZEkzsAppTd2Gp63yboip0WgUxD1fO8IQMoHoVkrXV+2cejVKg6ydndWhGJGAwlawwBxiKimcjpefsFrZ+CkRPmyi8jo7ZdS1ObNGlVQKCqeAmPVzjeBShDAz4vLldcvyW2V0BfIfZC7bxhqxCxfOFLUsmL5OtKsYkcLco8m8/8DIsO1Vl/koHlZLq8DT+nPgSZJ+VC/6fw3nYyTrUm1nTdyeXbOEPOlCweXqZ6a2z3TrCiYeDm2kYwMV8EdtuqhtyHnHu6k/oe+8SFqx9w3uEpHVZgR7fJdfrxLy
 K5qD+uei
 zgk58DyyMEfMR8fxwzFWhEHCjAvoyi0wMB8k6StJ+RSnLXUJj0NeU3fh9wxnnx10YO6g9vcNpkz7Tz6UZWJewzGrGIC1H2g307FljTOn31ufmZ7NH8qyE3XbmEBR8dov2nGKxQvwFtqxUwwa3V4/IlF7plm03oHmV4hn6oKK8ZFrWHgBq/f8FW2DQBD451N1iMw8NRn25Ubw3KP+ECbb/HFectbl6xi6lEL/8pkBVLFsK5O7pRXaDHFGptHtvNTkDWzr3qARff0e70qBL5g3laSzRSJfJRNcF8FErSm8rUrcy6TCF8sHXLhv32nnYClecOK28PXnzGtrvToCZk6HqU5D8gA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 4 Aug 2026, Lorenzo Stoakes (ARM) wrote:

> Since this work seems to be very much arm64-focused, perhaps it's therefore
> worth looking at an alterative solution that's specific to the arch, like the
> one suggested by Mark ([1])?
>
> [0]:https://lore.kernel.org/all/CAHk-=wire3dzhHx=KiL_f5Rj0=1u9ustsa33QoR-F9-v-NU9Ng@mail.gmail.com/
> [1]:https://lore.kernel.org/linux-arm-kernel/al_DpFJFcmVhxpvW@J2N7QTR9R3/

Mark's solution does replace the preempt_enable/disable sections with a
rather hacky restart logic. It relies on a long preemable and postscript
to each per cpu operations.

 It does not remove the code entirely like the proposed patchset here and
cannot produce the same compact code as x86.



