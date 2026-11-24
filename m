Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C1A5606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k5Sl4Vx3
Received: by kanga.kvack.org (Postfix)
	id 265ED6B06DB; Tue, 24 Nov 2026 08:29:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23DA26B06DD; Tue, 24 Nov 2026 08:29:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1542B6B06DE; Tue, 24 Nov 2026 08:29:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E92B76B06DB
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:28:59 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 78208A8728
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:28:58 +0000 (UTC)
X-FDA: 85470093156.27.0E79665
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id EA9D340007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:28:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k5Sl4Vx3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795526937;
	b=A9gdARplj3vqFIkKF/eVKsi9Y0zAl6+2oQcnTrOtp1x/E6LL9ZuwRmY2x7IkAdxSkgBNVW
	Zr3qlgTOsRbvscptMLbVFWi2AWh7IYh2q5C9IYqI43LAbUYtMTlWo9Ek+R98BJDG3QnXf6
	q+mmaRFZkTxBkXxmZIUr6HBUzdrQfTc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795526937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=ppSLLPWvpI6KxcEisNMO2tcR+grD4AsFIEJZhPBbdo8=;
	b=VmJ614lLqHi72vIVRNuU+UTpdBNPyISGE7X76Z9t13tG3DtLsLBa+q+V5aGID8tdQrSsDM
	wWXwV7p+HVZqtuNY1btYp1W7eOSYFOAlkplwpYL7P3FNWjiMG5I4PFI/4F27XVT7BmAjLh
	Zl5rSBSOMHhDZRU6lTbNT0fYSG5I4iU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k5Sl4Vx3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A866C6182A;
	Tue, 24 Nov 2026 13:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA64F1F000D3;
	Tue, 24 Nov 2026 13:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795526935;
	bh=ppSLLPWvpI6KxcEisNMO2tcR+grD4AsFIEJZhPBbdo8=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=k5Sl4Vx3VWy0N+lpOv2sBl0aGk/HDmUvQC+w3HCjNp0ahUW8AH3gUUdtEBLzQWUY3
	 mwyN/EtC+3N+6cIA5hEa09slVNFGiFGhx3f3VBNbRuM6FH2GGRvqwfgZdqKQGe3lBm
	 qF+WPEyb0K83/aS5BKAF6eRRsNywj8pM9u/6TD+IZh85JLSFGQQjmzPmqaLw8Ec1SN
	 wPskPb6m7LxhaSCAEbB+38zCfWNStdb0ZA/3STzCfI92Qcpj4MvMuOhYecqu9UQy/y
	 YPRAMEqlpfXFLDL4ynKnrLab3BZ97RURdwNlV8v0r+KI/oougiUSzi8Wb7REVrQGUo
	 OwqkmNlFnr9aA==
Date: Tue, 24 Nov 2026 13:28:46 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Eliav Farber <farbere@amazon.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/5] mm, uio: huge PFN mappings for /dev/mem and UIO
Message-ID: <awWPTMvlt34wPyux@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124131510.38745-1-farbere@amazon.com>
X-Stat-Signature: 4isjky3jxomdnqjnrfp9mnwuc7i13g7t
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: EA9D340007
X-Rspamd-Server: rspam03
X-HE-Tag: 1795526936-643061
X-HE-Meta: U2FsdGVkX18Zduzu3sY48bncGgyX6mgtG2HB4PTaD4rg2GvY2BU5OlZbRZCiKtiYSW+skAVDy4qmrap3osWoAULqWGNUJRdo9cG5Lc4r7ejsKX6ojqdH8rq4laiTvMkQEDE8IclimGIypNXM6Dy5fokDQ/EbOo5IPM9j9Eb+MMjqIkHIXU72x8ldXGQGPd4euS5rLA9n/l6/X9vEQxGkE07gSWM/IZn1tdM4thNu7gcrYm+AA2OJDJY9jVInvqI+JxB944tTryKwgXTL3WUeSsClw2sRwbr+2RfyRpVr8x18oKVD7+QzQ0O4zYvhYUw1xH48xqYgI+Kzb1lx73X34c+1ZulljvjOa4VA5rcK40jqptQcaC8CaNstAfs2aYNg2aejOMZp3tnfoU7TZ/F48JiWbSaND8HkxgWtjEfuCgKYo6Nww3tzcLauxV6yn4oHFn+ACxM89Eodol3Fvy+MctVvhDsiBXOY0qWmVX6QwDH7URO5TFnK2guAkqmUgOC8D2DAuisZumA47G6hIXr7Y5N9jxyoKyfoEcJ2IuHwW79FWyvSf2Mq/agcBRhE7E0wAAYNpUoSAXI5OlqOm9p/66Bj4NBa6PjtMnlguX3npBGjF4fnahLqIkT4JeGUE8FyuEb+AjZOkMdL8CfGtPXAo3a3AyDZq2HURNHslSQ6Pai8FE/yrmAu7Hd9x8dgxe99+DJV1Gl8D6wBzVX6lBpLuDAbr2WZWD+HnJpB8wyKP4dS/vRCSRLoIfkOiAE08OUTq7Am88OYcz8gun01rp1aAp3JMvHrtb1KNgQNgez30CAfvNngIbpFlr7IPflBYH8F6K5WGRwZBoNQfq3G/LFMmZ3FLiDeTIx/Syc3+AVClfKiZWbzZDcdxi1Pcrp+adF8xUWzB6LHzLs1hASeb/xyoyyOJS5KjAnxj/oN+gdpCSVWi/Qg5HtuDVglV4cg/Z9aUjXh6NMGh88vOTIO/1F
 ZVEywKlj
 iWHYntd6YcxDdAPCr0ELtqtwWzYlD6uMsptD/LzcIWTMfbHk828ojxXw80To2qlP4zHIDqv+fCU+U+57uTFZk4NZy7ZFJ/tGBoNUISZ5T+N5F95Mn8OOi6asl62tCImbLQQ3YwajSOTSmPCtuWbWvb2Fy2MK2HpAwJAgh/T+VrhOL8ed/wS6l7vXXlHQ3tMi2Yx2Kyq5VwPLPDP+UdJpOkfmUNN2yPnDMiIQrWldANK4o5EXqKJ2B1mv7Y9rkUxBw8F8ehGlRNufcX38kRJ04vv7jhhHquTMfHmKbvlkhVRUgBBjg6l7tbeCFEEGeC3PG0TWtnW3bETwHmAzw3n1C8BoQSp17RRofjjRFaggGNjqSe6wGfc/GFTyWCsNcsPO5TsEl4ShM6cEicV+Qvmvfa7XeXIFMYyagHDgJNBS9DxJ8enQuR8adKkR4FIQaZGtm9i0XMUwd2pEiqeDh2wgbhrBKSEZl4f1EKMOKbykm9VbqybYWplAo+bTMMzr8FX0K0Gvu7p8W/Uv8TbA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

What on earth are you doing, Eliav?

There was outstanding review on v2, you replied to it with what looks like an
AI-generated response [0], then instantly sent this respin out?...!

Don't send respins unless it is ENTIRELY CLEAR that the feedback is addressed,
and that goes double if a maintainer is CLEARLY not happy with your responses,
as is patently obvious in this case.

I am inclined to consider your patches as bug reports only moving forwards,
honestly. Maybe David has more patience than me on this :)

--
Cheers, Lorenzo

[0]:https://lore.kernel.org/all/BY3PR18MB4722314909E880B1D77EED62C6442@BY3PR18MB4722.namprd18.prod.outlook.com/

