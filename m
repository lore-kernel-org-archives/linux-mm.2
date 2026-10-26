Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEF1F606A320
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 15:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=shutemov.name header.i=@shutemov.name header.a=rsa-sha256 header.s=fm1 header.b=W+D+hRJd;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=yna/zWeB
Received: by kanga.kvack.org (Postfix)
	id D6F576B05C0; Mon, 26 Oct 2026 11:55:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D46BC6B05C1; Mon, 26 Oct 2026 11:55:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBDE26B05C2; Mon, 26 Oct 2026 11:55:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 814DC6B05C0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:55:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EF3CF806B8
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:55:35 +0000 (UTC)
X-FDA: 85365227430.30.BD87A50
Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	by imf09.hostedemail.com (Postfix) with ESMTP id D6CB614000A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:55:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="W +D+hRJ";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="yna/zWeB";
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793030133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gwsaXezjQkHlotcamhKkbr7xlpj223QdzbPDUGHbv60=;
	b=voPgmzoT+qO8tWV1LXwE+mnUtwv5zCFuHsIWeLMMpXnuJUiZHGtiuj1Zwni5Kp6VX9VWm7
	crJLVtcRE59Y+Re2oK5QCYYEJpPMMtirL8lz2exViYNlZPEX/SHlwqlqBoL21fl7zff8I0
	6qUw9amjuj8cHx/Iy450ouwavxXQF0Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="W +D+hRJ";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="yna/zWeB";
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793030133;
	b=aUMnlIb4hiKAnKL/hH2zmDBFeNQUou2gmUZybsTJq8l5/y7Na9JbdRVAHT20kp7RCTfo/7
	G9gZO99sYBxoECej913+KVeqi2YYc0/bO+qqleF9dVkTOs2FKjZ63IONxMGucyOfJRlj61
	t6+iW0US+iI7URGEYNmLCRV14NtX1iI=
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailflow.phl.internal (Postfix) with ESMTP id 5FA3D13802AD
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:55:33 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Mon, 26 Oct 2026 11:55:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1793030131; x=
	1793037331; bh=gwsaXezjQkHlotcamhKkbr7xlpj223QdzbPDUGHbv60=; b=W
	+D+hRJdFMYpMlx3Fd2AMqmbxbtAw2y13mHvqkoQZTzqo+8gJLMS8fuQnevLJ7Y5Z
	t6YOApdnFVCRiNf+AomNhvz5SacOv/Qx/3cmCA14pcGV/c2nONeYp504hTUcPJ2X
	OgXSM7oCtcNpnoFiDEV8/4x5dj9Cpgi5+ZEYsGaLznmKEmkLgWOKPtlCmJDnnl/l
	aSD7AOy+vMDV9rHpFbmu9RjFjiRN7Voxtd7VgBjwtZ/ITG4/9cSFKS/vQqpWwtJh
	uQk9gjiZqjihjJEVuR6xoQTd3yhrovVouJpZUfiKJLNrNkXbuT6DLJGHLh8ATWV7
	7P7sor5/plg4S5in5u2FQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1793030131; x=1793037331; bh=gwsaXezjQkHlotcamhKkbr7xlpj223QdzbP
	DUGHbv60=; b=yna/zWeBlX+TfC73yH6+vZpijUWYtS9CWkRy4pO0UhGcsVEJ1Lf
	lQ4cf+a4v1H6a6uw45aH4uuTxyxMXhDh0rax8IqONb6HSTGfOvDtr3rixn1h6waD
	xHSBhMksSDSRG9kGkjYNBWB1Qcbb0hJH/LzavdjkmCvWhoqLfzRnk6kXJwHmBTt+
	5qDyPSTtds9P9ZEWgRw6/etRFfsIZxq7LS9KRngEzT3147Drtcq4kVzdFFxBzL0c
	CDNA3ZT4f8C5AX6u7LW5vzbFeLw3dTdikqxuXxjfnZxIHdRiVKmUhvXEw0RlZtG0
	aCgRqinhQeNltYV5xxmXsL7kqpOnqHviOfg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793030131; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:ycfR1fRwng/vzuIswVSdUISh3SLFYpE9dvIhdvboLhrU7vf
	Xg3dkYWowDDMo2LcfLOBtzQ+UREWJOu+g1OqR7bENbjfEMH4lY8mjX5Rj7y16jl9
	LVfy6GzopLEpTjG71EeZD6Kwszu+6fWG8VA879tINDlvlcHECNDJvEvFRljA7nVp
	euQcqBLWdoKUYEdzUEbC9RQw67ZEzLXZcDEJPIKX/qMUX4gGPNYgjoH6ygoNdxRI
	ycZMmslbHpI+wosUNdP0RAcGut27hkgi5prpjj7XGltirprjrxK3rafo/gLm9T5X
	5VcThQ9+6zZn/E70nM0sqYD3D34uSq7ojfH0KzA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:EDgvaTUJlaS/UoKv7LEg4UiURKcq+3R47PQSNS/IiC4=:XSAakn5RcOVFPexf8/wrEz3tPUgSykAlyFSmQjGytzM=;
X-ME-Sender: <xms:8XffalhyFqZKXsAjcdIBmlCBfLeeJ1dX1nJj6hCwJVYth1NlswSOOQ>
    <xme:8XffakLdbrJKzM4ADy4kgffLHuxzoNnmj1l5eCvjKauUgMJhajEGwsLryNgCRWk0M
    aVY00JBUuFR2rCF0JyQPSS26kug7J0VpzC22XobYUfV22lM7spBXOAp>
X-ME-Received: <xmr:8XffamwKr5w_ykyjt0CE5dwR160epvaRodUlS8Csm5Z7QQ6lGAuPQhzQz2I>
X-ME-Proxy-Cause: dmFkZTEF7EYutanou3ZZN7Aj7xG19q/4w7NFN6S68aRyR0PLTX/e/LvcDG5UTf9uwfTbbp
    Ey64ehGpmBhIUVubBkWTS0IW3Bw5/2GFpDXtmN2WfdQhZt2dZ3IWvFfzrrMFLJ6nbzLgZI
    OBEfIjaY/oIzb1ehpTT49sLAWtlBh8EfIhzg/NFxn0kaW1tEE1IM0N+pveIAmY0dipbBbo
    QTPKLqn6muiyhUM58Ams6E+prY9p1fIVnHLELmwpWEtfvjhamITLyN7ACKMd81Z2ZPqRxf
    6wKOUAIL6S+2u3h7GPhN5XLvduzq7J1NUIWZVSX+y2gTiGurd1dF8cJSscTs5knV75Z8ie
    vDeWaEZiqbkk4jmKqNYAW5HTT6B7CVGtU1fYUG4vK8fbSeg3NVXLeAzy2HkkXSN23JPz0q
    fhBz1ftZ2hk4t0iWWIQHTsXbF91ngKVC3M3QItNY9t3VNelJ7+qqym0ByCrXOme32148SV
    Fq3dr0HSSdqVNyiU25AA+pCudxPJ7UuGu/SenIq5nDEc2UEcurF1Yj7yNr4pee7yYPiCQ0
    fe7ATZakfTdRUMPI3QU++2K8bkeuT9JvmLCTWipQyloGTFrQI9CGhx5q9aEwpLDcElXRK+
    smbckVXSRx1WDXYLNDaBL6xtomPu7i7KJn6dHG0jMUb2NBLQMvTKxedgfgEA
X-ME-Proxy: <xmx:8Xffao9JsL9gujocvrZa6VvrTBfWPyvYIuur8J_m3AnQjYlr2_TCBQ>
    <xmx:8nffaswgqLP-6wnfjYX3Uwp_JmN0Rn5WfuLaC7gS-1zBKVMyW7nPqg>
    <xmx:8nffaquNXeNS3W0s7E5AnKdC4wC03Y1RDTYHOvuC_wmvzrQ7MZ4T2g>
    <xmx:8nffauwh6uAS1bz9-78fVqvw_ldz8c2hU_22bEVTMoGDqOF6QDwXxQ>
    <xmx:83ffaqJDSYndWmXpRMH-MUu6NbxSCMXP2-tX224XWLdl-26ucf_4Qwc2>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 26 Oct 2026 11:55:28 -0400 (EDT)
Date: Mon, 26 Oct 2026 15:55:28 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Lukas Czerner <lczerner@redhat.com>, 
	Carlos Maiolino <cmaiolino@redhat.com>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Stevens <stevensd@chromium.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, William Kucharski <william.kucharski@oracle.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Eva Kurchatova <eva.kurchatova@virtuozzo.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH 05/16] hugetlbfs: enforce F_SEAL_EXEC in setattr
Message-ID: <at93S_z8-MF6UnE2@thinkstation>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-5-703206d5fa0c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026-fixes_shmem-v1-5-703206d5fa0c@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D6CB614000A
X-Stat-Signature: tkpnkhdr6akwzdz1z1uex5u5dzo3ecm7
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793030133-956237
X-HE-Meta: U2FsdGVkX18636J0T/fGrUW8J1Nnjw2zp5ToRnQJa0UF5BwilR+OjRSSSz8jWNO92b9sWF3IMjlI/VQqaHQq3bkhM5ZvVzOXR9S5pBsGhbI7/pXFtRBACkSVUoDnNzG/nlb8weO36Rm0e/7XvZNN65MFKdZjlXS9SpmqoqSzjA0h/XiNvz80VRYj9xF1V2ruIzsr6+sIoV/rsNEAo5YYk87hYAvzV/cWd0UC0T/otIrg1hVA0CQfshcislzE/PF3MryxP7UM5Mee9v1MITJNBf7LDvrsSjig5124INQ4/YAVv9ysUUNJi3lfMFWwUGCwygTODtmNbrHG5O55AI/9q5RighrXRAWP7wuXWD59QbxuQwysG4+jo0HSDsv7/Dsdd2iiAaPE+tdDmPj2GJPtiMAE7uxH38RU4UitVuK3qKsREXc1JmdXaE2azX4Na3yTc0NT2LMD2Cc9HlevkrSZ4/uX6d1jdcx6C3wAy8gCuXLS2KpeyFTRvDdHdSMu83BISZIPJejtDkuu5yVJhiTS6XfxAxxdyulkhnyAuR3w1k5S8xmHvshwYIW0y9pmI3WuOlrEy6CvesdkpR1J6f2/+pNr5w9jWDSOcqGa8Awa81/btc8tD8dnkvgYb4YndHBSPa8RnbyLGnqNWMaIaAvLsH/WkLQStqwruD4zFGMBvxlHpdGzaOq5+BzSmMxpVwF8Ddqc1/Xx1vtr0rPXoTAwib7CxCyMSk28KDDFqmvmU6Ji1AjRXodvCSeTTADmZHhow+oGIoDt+L42rIN8BEaRg4wd5m+MBm61Km++NVYuWGmp5/cBy3+p/NRpUmtWdsa7DSej89YXs48C9hYIXGRS+MXZLNIY/vBsxMe58WcV+OTnJIyAUoSZ800Jj0VWwKWTAR57f5xk05MP7AAjUoW09ynZ7DHFGG3vRXXOw3TRWApwvRe7b40gs6e6L+qP11ZKXB2/FaJYZ1kWMlSOK8v
 mqtbr+/t
 dnm/LzzelWMAudD/qQ8TlTFTFpecJ/CXVOEziWouHe67gb47PWL72eDu3C1BGcSIE7jYiX1H/wheNJKPpN1AxFUTVizj/cj6QRYnroCYVmQb0oOpfw3Bryq2+jGb1OBaUb+TmiQ5XeI4/qeBUW42LGl1xKckxx95XcvtbxpUVhvSVFsqcmO0UazRdVbARSDTSrYQlIY5GRebMw4XQWgNVM2Fv0MNkky1wfZl7EZ6mK0o/TQpTz6iAMhNTQBO1SzuWcJLLOIoGX+FXnu6r47cXZM8qfyKhf5i1Z7059N1WDuS1BmqyZmAxnWkj5GRqWlzmWt82Ollds9gZx1MoCyWyqGEOZTTV1DOILV+1Rgfn4J8D4dFQ7h2wqa/jsWInwjK6QaaNhOtky5dzh2owD1NuQ4uM8KStEREobf3fuWYCLkxMoZW2++kC7RB+z7GsIsIUZemuQ31rf4wCgRIQu7PbX6kojmoN8NcCJg4d3VgwRw8FahIGJ/YiE6xKAyS7rvMLtHjtCI8cv/1nzY7OpzPklVSguR2KLEfttKdFBQkeMYRWNCQC4gidBxJnSiSXqjdmbS9VPv9MKQrEhVFGP6lQHUBBHEHjdtzkYjU31p+pbpgIQhhOP0gdOROWXGWEdVbStJTOa8Pq7D4v1Ts7CAhldx1eXQ5wvFh1K5K9+FoU529A4Re6TotczuxhkIgExfSXQonOQ2KyIcxZxxDcDop55N3tI2hW6sQ5K3OvQaCG9nGjA7InKxtD49Y/G6TP5Tl92sWUCShpiuqbBqsAW8lyN+bjuFJUS2EUg8ssLyGV11quD8o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 10:40:38AM +0100, David Hildenbrand (Arm) wrote:
> From: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
> 
> F_SEAL_EXEC is enforced by shmem_setattr(), but hugetlbfs_setattr() does
> not check it. As a result, fchmod() can change the execute bits of a
> sealed hugetlbfs memfd.
> 
> Use memfd_check_seals_mode() in hugetlbfs_setattr() to reject changes
> to execute bits when F_SEAL_EXEC is set.
> 
> This also fixes the memfd_test hugetlbfs SEAL-EXEC subtest, where
> fchmod() incorrectly succeeded after applying F_SEAL_EXEC.
> 
> LLM assistance was used to reuse the helper and revise the description.
> 
> Fixes: 6fd7353829ca ("mm/memfd: add F_SEAL_EXEC")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
> Link: https://patch.msgid.link/20260629180247.2343229-1-eva.kurchatova@virtuozzo.com
> [ david: use common helper; fixup Fixes: ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

