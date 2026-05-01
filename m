Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4BB5FF885A
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 08:35:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C7D56B0088; Fri,  1 May 2026 04:35:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 051A46B008A; Fri,  1 May 2026 04:35:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5BF06B008C; Fri,  1 May 2026 04:35:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D087E6B0088
	for <linux-mm@kvack.org>; Fri,  1 May 2026 04:35:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8F6871202DD
	for <linux-mm@kvack.org>; Fri,  1 May 2026 08:35:54 +0000 (UTC)
X-FDA: 84718193028.01.2AEBF4F
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8CC9D180009
	for <linux-mm@kvack.org>; Fri,  1 May 2026 08:35:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cOLsC5I5;
	spf=pass (imf24.hostedemail.com: domain of li.wang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=li.wang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777624552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v76T1y5va9Nj+ALtFUiTGiUgpJr8tBYSU1F3DLUEPrU=;
	b=y0RgVQX9ilsh5i9tRzIuu6bw5OMUfcs8OCLlB5htKj6Aao0jbJIpxbOmLlVI9e+pobNpci
	vyYa7CqUaTJUUwaQCU8sf/KP8h/pXuEk5BwfZuXA51gPGBg0qBozbu0tMgHlwh+8C5tMw7
	q4xhZBxvkufelROIDEX69OjRaGOBFMQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777624552; a=rsa-sha256;
	cv=none;
	b=KvRixXi3zcVicKg0sxdkAbhcT+Al+Hfwo/4lMbBnej3EKapNYt9CPctqXw9VdyfutKz19o
	7OIFSRYr3c9ZxqNSyuf9L7lv6SWnrXcrxDhgeXFOOh2e4uTGs4e3fpJZ98bQ2lkf2zFRFV
	arMx0zXb9i35PfmtJhegaEdXUNk2fSI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cOLsC5I5;
	spf=pass (imf24.hostedemail.com: domain of li.wang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=li.wang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 1 May 2026 16:35:32 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777624550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v76T1y5va9Nj+ALtFUiTGiUgpJr8tBYSU1F3DLUEPrU=;
	b=cOLsC5I5OnSiJOFt5iIIxQqmHoWj8Fug/SFJ9IuJMkWgJuU5+a9hOgaExupQkhK+hqkMj4
	wpVUvaUcFtb+LEj84r3l2Dy7motcEs2u2VGW0IuhFklTIbkbQXP0Aqu1ReNPw68f3kkobr
	tCpQD7co4uPD6HIYN0oBM3eBrndmRdk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Li Wang <li.wang@linux.dev>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
	Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 05/54] selftests/mm: run_vmtests.sh: don't gate THP
 and KSM tests on HAVE_HUGEPAGES
Message-ID: <afRl1Ja9ytVD3nUh@linux.dev>
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-6-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428204240.1924129-6-rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8CC9D180009
X-Stat-Signature: fnzrbkawucf5gacjicd7k89ef6f1tzca
X-Rspam-User: 
X-HE-Tag: 1777624552-867246
X-HE-Meta: U2FsdGVkX1+S4LGWLwa7fVQ+EWLa8dB4C6XwojEZRjheCSzZ2tWVtphF35H/5E/sohDgtMB5XUA2SSPKwUaL7rgy/EKaCHpvmkmu3YPwCXb7UKPl9G3VdwwGUfRI+Hin0ANHfuLPxNONaIjwEbVTHym0rBYU/0Ny4Ud0uFZV56EkygokXZXTjl9im58m+xQl/9Q4r2v6gIpe/48gr5aKdC+LwwMGJx8W7yzDJKY+QfHgU504XBllznYTWD769BoLu8keSFxK3a1Tetz/AJsjWhTDuQ2cPaJ0fdbAnit0k77U8SWiJxXx+xYMPuHIwPQBSQ6SU07zTf7kxhwK29l0zz6O5qeJfBYOJjmL3oe7m4A11clEl/ujaRqtQGH5iu6o4eE+StyVHxlMqghr5oHZZYJBfRzu3M+xOEJNEeqUZoUwRaw+YH9UzxY6vwE8IlnRHGbrFRCeOot26t9ETpC3z0pGq0CNqbTfzB417vqQHIntcuHkVDF66ObvaY0Z5J0c1B23b30NEz/t6BnKbsx+3VR/kwT8FQ5h3aq6gDQq9DLWQZOvtp6UO8bge5RNhexp6eLya3AUvoeQumvnVmlXCCSbNejUPOw+WxXcI2D6g1P04eb8KYwToDY0qav0ff5HEzppCk+bU/+f0p17sv0yi526ICOAXYhe1UxFTmXe1EZseG2NxcCyjS/O7fm2pY3eSkIvUqbXOvYn0DT6Ohd8ccL8r32d9gFqn71V30u+wictRgs+k37B2OQl3YKpEdU2QuFC+9TLxX2eAgrZQjyASheZTgbJAWe0nogaa4sfLX125KBoRcIqAlTkSOtC8L3ABG9eH+wvDjtVNDE9WZ2Kbu+8UF5Rsno9Cu70qhI3K7/rEvjtOse14urv1NGFSLiBDKB2MokorwjIEuZKlgE5i/mq3T3WqmWOScOnBPxjZAQfcqT2ahbBysNILOCk/5FktW65eOgYWe4/WfycW2E
 q+TIaDnx
 fFi3SbPimBtQptrtAYsIGrQZLETdl9yM3C7i+TE0flSRIUcToUtNnTLzrCryyEm69kr10+m1pcJqX3lsnXVspfrjpYlbCDkT2gq57pUbDZ++t2MG+JLZxeOCH6QRzDIJAlqgaRFFolazX5un0OtTrutLGAp93p65IinYQEnoNZapEMnQ/2OTmYxKpdyEavD5gtLCNoTE5NQNXOfq6VjrAoXqpHrcovRKiNZRbFdjjSBHJlXDt/PqarGYMWoUr2eAMFIMjSHHuQyuXSySVbWVXeScvwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mike Rapoport wrote:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> HAVE_HUGEPAGES indicates availability of free HugeTLB pages. It should not
> be used to gate KSM test that merges transparent huge pages or
> split_huge_page_test.
> 
> Remove check for HAVE_HUGEPAGES when running these tests.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Tested-by: Li Wang <li.wang@linux.dev>
Reviewed-by: Li Wang <li.wang@linux.dev>

-- 
Regards,
Li Wang

