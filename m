Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8FF2606A334
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 01:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=aMSuIjFe
Received: by kanga.kvack.org (Postfix)
	id 19A406B0B4B; Wed, 25 Nov 2026 20:49:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 172116B0B4D; Wed, 25 Nov 2026 20:49:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 088E36B0B4E; Wed, 25 Nov 2026 20:49:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E15676B0B4B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 20:49:25 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 709FEA8E31
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 01:49:25 +0000 (UTC)
X-FDA: 85475587890.20.E311E3B
Received: from mta0.migadu.com (out-138.mta0.migadu.com [91.218.175.138])
	by imf20.hostedemail.com (Postfix) with ESMTP id 260D61C0004
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 01:49:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aMSuIjFe;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.138 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795657763;
	b=QoFXwcf1WRfPLU+/DcUJY0QMwlG43xL2XqOA5ZC0AMZ1jd8quz7Kg2k0fnpAjm0qMqPQzh
	uJQdXgssrBjvHZxsVep+7PQJQj+DyEgRIhKs9POumVujdmISxsrtfoxYGUgKojNq74KxDZ
	QDM8ZfzEdDsGqE2EFbGHrwYHhC6HTSs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795657763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fUm7OIYCLKHdOAGzUrU+yCvxeSMK1SFSB33JMsVoO2I=;
	b=WsLo5Gv3nAHrs5jy9hFVsTaOo3MnAufF6nCIICUHmNWcK5BKXx1Tb/XQbiqs4dEYeKfjuE
	uJHLhJCE3ZXUkxvHl/Tw67HLWSHXI5NScD27VgmMjN/XX/q2XC5AbA21JJU/BSejhXG8bx
	hGH67PESnPqppPI74WLuwusegyxKHjI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aMSuIjFe;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.138 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=fUm7OIYCLKHdOAGzUrU+yCvxeSMK1SFSB33JMsVoO2I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795657761; v=1; x=1796262561;
 b=aMSuIjFeh4f2FLL/56THyfcFowmeUkUx6P1VIJ9B27LIOUqpYyLg05kO8UgS0XxuWrQ0uLEe
 wHWaqRd8lLt2/u/GNijK1dZxKrb/xvt8HOZniac+RmYZKWpY2f4sUmH1GxWBA2c6mJu37g9n7mJ
 KKfvFBq4raildqYZVdjfTA88=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ce709ea24b407893;
	Thu, 26 Nov 2026 01:49:21 +0000
X-Mizu-Trace-ID: ce709ea24b407893
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH 01/21] mm/hugetlb: charge the copy made at fork to the
 parent
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261125-hugetlb_fixes_2-v1-1-db27fd2f71a8@kernel.org>
Date: Thu, 26 Nov 2026 09:48:52 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Jinmeng Zhou <jinmengzhou22@gmail.com>,
 Hongfu Li <lihongfu@kylinos.cn>,
 Andrea Arcangeli <aarcange@redhat.com>,
 Mike Kravetz <mike.kravetz@oracle.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Dave Airlie <airlied@redhat.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Gerd Hoffmann <kraxel@redhat.com>,
 Mike Rapoport <rppt@kernel.org>,
 Mel Gorman <mel@csn.ul.ie>,
 Dave McCracken <dave.mccracken@oracle.com>,
 Andy Whitcroft <apw@shadowen.org>,
 Adam Litke <agl@us.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Rik van Riel <riel@surriel.com>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>,
 Lance Yang <lance.yang@linux.dev>,
 James Houghton <jthoughton@google.com>,
 Yang Shi <shy828301@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>,
 Gregory Price <gourry@gourry.net>,
 Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Byungchul Park <byungchul@sk.com>,
 Alistair Popple <apopple@nvidia.com>,
 Wanpeng Li <liwanp@linux.vnet.ibm.com>,
 Andi Kleen <ak@linux.intel.com>,
 Kenneth W Chen <kenneth.w.chen@intel.com>,
 Hugh Dickins <hugh@veritas.com>,
 Michal Hocko <mhocko@suse.com>,
 David Rientjes <rientjes@google.com>,
 Joern Engel <joern@logfs.org>,
 Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Michal Hocko <mhocko@suse.cz>,
 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
 "Kirill A. Shutemov" <kirill@shutemov.name>,
 Sasha Levin <sasha.levin@oracle.com>,
 Guillaume Morin <guillaume@morinfr.org>,
 Wanpeng Li <liwp.linux@gmail.com>,
 linux-mm@kvack.org,
 Jason Gunthorpe <jgg@ziepe.ca>,
 linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 Andrew Morton <akpm@osdl.org>,
 linux-doc@vger.kernel.org,
 Chris Mason <mason@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7774BE16-BDD8-41BF-9FE7-E383F333B4E1@linux.dev>
References: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
 <20261125-hugetlb_fixes_2-v1-1-db27fd2f71a8@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 260D61C0004
X-Rspam-User:
X-Stat-Signature: 5b9oaxb31aqc6e4j434cuqn8k84wi1rj
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795657762-369896
X-HE-Meta: U2FsdGVkX1/MVLK5oM26co9hCVtPH8VgsESh698lhRO6HvRyZm3wk4GEgWrOUTnoz9iaej9gXEuZ8FFnFmn9UxgZuNgUSU+yQPRAuWFzD3t6j1gX9BD7WteA4QcKGLjTeqFmqpH/sixJ4lgThRzoUUPuobyCoGcjLAbsVqE3a13J+gULTFXJTRPpQpMyD4U95Mws1VXkwjXZuUk0GvbJa0m7LWEba/yM/7QE/56ar4Qv15dWwgIkDwpqYdpSSa8tMT68eNzezCcQszc7+1ROthJYod/rcoHEpAjG/Kj3tIhhovNJt9MUh9iymXrj3HJT6oKgV9x2MXb7TUSJnDmNzn+b5Qzt5Sxxl/9j98p3Cu5EW+vbkwuckNRAqJj+oxGLi4xY1gZG5d02KBcA0OPkNfzKv+YRSqlwB8fQjvs5YsZHY2Qx6nHFjHp5anmiOSMT4rv1koJxW0V/nfO2rKaiWjjO4NxOgHd4sJGlji9fJVNmSWYg6rewvONc3nYwQyLFYve6FjxR6BzmM93rc5bPidzxNer1YvXWMgRn6UtBerAvISp/G+zSGMm+7TrB1E3Iom3m3o0bGXem9tY1vulv/7n1XN/dxgAFCKyFJyIV+hxit246wUXXq5cavTQOKrqzW9P7wZjxCPxYf0MfgGdvyX/dSb/M+RWqsDpXX4uO0dSS7B6LRdbMOZw+478i9jxKGMI+TtQ0MOUb5OP4hQGa6Z2B4s+YYbO2WzdQZlhIX4OYe2qzCmbpqVvHirnjRjV7z6Oet5DsDgarFbd/MAITMsjFlhCze61vlsAjMmCGpqcRVW/5Hc29e515yj36zCZe8qryMestsBa+ujuASQNlTGUM8pfgAlwYca5E8ufxSRu33miNhLgz0vZAQKwyS062cvRlDxIkUlzFruj5P352YMsgkuHWIoWBvd1AFmZH9k/UTgRy8kpGINHD7qkIR0TFYd7mvklQ+G+bNeth6YH
 kk9HfW5+
 qp/O+9yu7aKfilsUx99FFCiqECNEFOxXhbMDvBVu64xG7BRU+PQaIlqr7m+u5fi0h4g4SYJOQRMSamw9ZInxuXwPBYO1AYeD/kn8pPAaDwm1k8MgvmlEEBGsoB7U1iU7mD7tUCulk2KRXZkMFs5G13HFv5uTjgpVOe8n5oOk7YKYzt7WRnZDOWcITe45De0AT7t/smXNZEk7/xNDckDXjlZgCjvRqgvt+mvhK65qiSsZkVteh4GDG8hwHI+IdyLqzkrlw5j7UbnLjjuIZ64TCk7L0LCHgCBu96MSBu2qpm0ZGG1FLpRn+0FSS4/eQ1Wwer4yvVQk7YeXDK5GddKpMpVVs7I0uR3mCMcucL0ZxsHefebsdip1VNdUfRhtzXh8/WzD3PBHzoCaAF3qwgnAbiloijKWIg+yFNpB/RbBmu7Qmmd1haLG+ApwDmvYyFPVA2hNRQiBVqzLFDZDlkeZqgcEc90U5obyQeo63D+jDwGENyFhtmp7a+5WqQOwuoPHNR3UkhH2H2j5BXA4agLJZQNCPfFp+f7oPNM3Pr0ARK3ebRf+GjAW0w0Brjids5AD2QXx1VFQEUWv9xevyPTArpRPerjOJgRWeIRvCejGxS9agm6448IsDsR6NYaXIeY+eiUTS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 26, 2026, at 06:32, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> When copying page tables during fork(), the child is not yet assigned =
to
> the right memcg. When copying possibly pinned anon hugetlb folios, we
> must charge them to the parent's memcg, otherwise we can end up
> allocating more hugetlb folios than allowed.
>=20
> Let's fix it by charging the copy to the parent's mm, like we do when
> copying small folios in copy_present_page(), introducing a new helper
> function alloc_hugetlb_folio_for_fork().
>=20
> This is a hotfix for v7.4.
>=20
> Fixes: c2deb1356d82 ("mm/hugetlb: charge folios to the target mm's =
memcg")
> Reported-by: Chris Mason <mason@kernel.org>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Muchun Song (ByteDance) <muchun.song@linux.dev>

Thanks.


