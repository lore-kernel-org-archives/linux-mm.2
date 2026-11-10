Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8C9160A3833
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 01:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=USauXDqR
Received: by kanga.kvack.org (Postfix)
	id 068F56B05B2; Mon,  9 Nov 2026 20:22:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F11446B05B3; Mon,  9 Nov 2026 20:22:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4E0B6B05B4; Mon,  9 Nov 2026 20:22:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BA5216B05B2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 20:22:04 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3AF29120876
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:22:04 +0000 (UTC)
X-FDA: 85417458168.27.197E96E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8FBFCC0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:22:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=USauXDqR;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794273722;
	b=NMZMXPDnhRdoGFnMGfcp9hyifSucA6PkEiAYqMaCF4xqMMmD3/dwi4Ph/Pax4EkXNoEa5Q
	X8Vn3Q+xw3FNTCEXfrHrOMyNw8Y2FMhTlL5xSEd/LSB5Veo1M+NHAAwVGdEN07vhewbvG4
	BKAD8EOrlDe8DzbRnvtv10gIiRiFXhU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=USauXDqR;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794273722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9/SKGdkxbgIiUz/Bq2IrDh4GfzV8R3UclkpDZ2NwnbU=;
	b=jhxjyyJpgKz0hEZM87b+VTQfxQiysuT/oqjT31YV9pXr5t8uXalYyKUh7TuxMpiW3eLgWV
	rIGIQ1rgKcN2W0ObbJR6IbhsrAfrskpINml/VyeiRG8CjrsVPoNzP+kmN5kuCz16z0MYmJ
	JnGiWTgV41VyJsW1zHMipdzrwylsTKo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C23D343DE5;
	Tue, 10 Nov 2026 01:22:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089801F008A5;
	Tue, 10 Nov 2026 01:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794273721;
	bh=9/SKGdkxbgIiUz/Bq2IrDh4GfzV8R3UclkpDZ2NwnbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=USauXDqRMW03uS6JCc3QT/ocT/r3OhDXNget2Z08FBv6F3PZ2dycsP0hbSNyaq5aj
	 H5siAMvhp8zy0GuwUzuzoqymZLqHhxCfEmf8qbx/W4lb6uGoI+vGYhDq0k7GwoHVeo
	 NZ2fQmm7mDNo4/5AdlgFeGVxZ3aPMRFTZQD2lHEQXY0I7q1WD9NiLgJoN0ylp+kVxV
	 QfTkSvZxWyAmSJJa0vzpwWSG/u+pudtbg6NOaXC0VeHShpy1aKbhVMOdroZJpCKslM
	 J0huJHeOXXAm/nb5UhUQQuVbiCd7ZDjzBUQ1lr2RRIo4zCZIyz0KrGLNmVIBrdt+o/
	 TUmxCxTpKuUYw==
From: SJ Park <sj@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	Ridong Chen <ridong.chen@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MAINTAINERS: MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU) update
Date: Mon,  9 Nov 2026 17:21:53 -0800
Message-ID: <20261110012153.106603-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9mreo8cr7c3omnedgceyexm31b69hmhu
X-Rspamd-Queue-Id: 8FBFCC0005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794273722-365086
X-HE-Meta: U2FsdGVkX18OQWXyv0zzU4OL5DUru511yCUR7V01Q7xo9stejHIYWKDOU+ami+QNK0hlSFeYjlQ+gHjEII9hoEBgt5SuJn1tpGWU+774Oq7+2GCs8me9j7bzuKOMWBV1stK13Rpooj6331RbGURkY5UqiUewondSM/+GqFpYvRMN+qvZBsl48omNFH9M3/t6YjdvhSl543XnNDcyt6rUhkhWw1U1XwDkwxv6mQ1+EdY9X10uDxF4TFM4NO41JQnlXA+7jjuY+x+Q1B+hoBYisaeivMr4H7uoJ78SBoq/aI2P4LRpc/UIT2X8MM5h5XGQ0EJdhU/Uz2YgkLyZUcq+d7TPAO84ojwo3wpHlZegFst4+2/9ZglntGUip2zSc5DJ9sU26RwFv73bD+QooPJLBkfvzk0D4N4mdyLOz5ylmjEpVULzSniYD8GVo68W+tCzc99fumZFrkyO1w22g9wHDmq7G2QKKyAyEaIOnXCyb5Rj/P5UH9Y5gO+Ak+cOKTuerqib++Ve/benNFQCnsffZwuD4uNiIE4SnGleaKVc6k3JZvmCb0pMG8Gdq0BW0YNL1NkN/O+wnF31AnQm2H3Yr5FWXF50GVBWpdwOSoEt+S/k9AZUeviqaxjB2JWfL9mWLRoGfUGDA6JT4SDMumQ0gBUJwewVQDJCXoNhBWpA5/fAa1PwSfPRPackjQjTAIW0wTstVE5erXip2IX8x5UDQVkJUIBwWNdWWoD/SSdCu6VzDeTtTUJcskZIMpGs8lqAxpkSDrKj79feQzspy6MtCfIiP9xiBgn49YQEk/U4VbZ0p5AQSnkAb3r19UFnjYn4iIod/qWHsHLxs9AIxy65pn8t14YProlR2N7sgfXaCce14ml/6apMDVTx1VdoaXUpwI6t2vYzSB7ycEb1AXbS44h1AoYKtDQE7o9BBmtRSvx++etL6Z1bzDew39Sqz/bzRB+qisjx6ZrvNgDmZ1C
 koyMBCJi
 9ieTNA7bfDG3m523d7BGApKx6AdJZeQdD0fbnlWTIUI5XgQ7fkjs12ZsWZ65E7tTeawshS4i1pIHSXNiluwYhF2aqoXgw8oczapHnRO6k6WU/lK5SJghVwkeBU+PgwI8Hbh7qBaOcqqI9kJjsxax6tXtQI2B+A5PBilLlaegmW4V12WqWc3Uq5C/3ghCcVIhqAx+RNjfkNloUfjsM/RWaZ6c28knxRAub7K6AtKh0CikGLss=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 09 Nov 2026 19:31:53 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> MGLRU is currently the only MM component without a dedicated component
> maintainer. Fortunately, Kairui and Barry have been actively
> contributing to MGLRU and have volunteered to take on more responsibility
> by officially taking care of it.
> 
> Given that Kairui is already an established MM component maintainer in
> a related MM component (SWAP), add him as an MGLRU maintainer right away.
> 
> For Barry, the idea is to transition him towards a component maintainer
> role over the coming months, starting by moving him to the top of the
> reviewer list.

Congrats and thanks for stepping up, Kairui and Barry!

> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

