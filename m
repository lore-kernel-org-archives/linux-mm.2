Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A148606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 02:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZiSCJRwh
Received: by kanga.kvack.org (Postfix)
	id 4596C6B05C8; Mon, 23 Nov 2026 21:46:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 430B76B05C9; Mon, 23 Nov 2026 21:46:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 348256B05CA; Mon, 23 Nov 2026 21:46:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F0D916B05C8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 21:46:11 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3F49DC08D7
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:46:11 +0000 (UTC)
X-FDA: 85468473342.09.2FEBFBF
Received: from mta1.migadu.com (out-81.mta1.migadu.com [95.215.58.81])
	by imf22.hostedemail.com (Postfix) with ESMTP id B9013C0008
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:46:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZiSCJRwh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.81 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795488369;
	b=5X26ul/VZxCCffGInyRzOS1/rLvV00LCp3E7v0wZ/N1D4A9jX4uKh53n/Q9XMy1ArQl6kj
	O3/HLvfllr4JHi/8QQOeQe3vHjjMQaJqFQtwEzTbdht9L2vmwS6DlN5EQMVHwvpAVg4vOZ
	jk1UXlKUHWW4k91Rrm0g6nmuOZfw4n4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795488369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kIjgqnAMxUJVZUYFKpZcA6Fzrzt75uPnZ5rkJJUeTcY=;
	b=QodTe0GE3BW3r7fPLPJuggGFEgbVNJtdpXe9rf3NE4if/yQmmebaPbdk0U7zVDb5JHC4dz
	EbaCf7zjRlvprQw1d3VgmEOGjuDPYzr7s0Wg49t3BhYjw/J+PcYELqCFDFUGdEI0YvpYo2
	JkhDZm9PE41upALAS+oZHfmPbYN0OCM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZiSCJRwh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.81 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=msJI9NHi4PrS8E7yp9ivWhqzbD6z18uYwbGmXJXPkgc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795488364; v=1; x=1796093164;
 b=ZiSCJRwhnVSheIp7v0YyljMzaLadnEVPeAlbfjCZMRNuXliqUAT0X5N+UI3f58BEHFWI/vtN
 Ct0fIG1FHvqs63vrJEINF2aF6i8jXLHb25duq8k3uthutjavRt2G2TOTGcVrEDw+LVpoa/KzKf4
 vfxNbDBJw5XTWkWmGfeSvRuY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id b74d0136862a6145;
	Tue, 24 Nov 2026 02:46:04 +0000
X-Mizu-Trace-ID: b74d0136862a6145
X-Migadu-Flow: FLOW_OUT
Date: Tue, 24 Nov 2026 10:45:53 +0800
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev,
	donettom@linux.ibm.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 3/3] selftests/mm: verify ksm_zero_pages is not
 inherited on fork
Message-ID: <awT6Yc/rFuyp2r13@dgvxl46587.localhost.localdomain>
References: <20261123034136.209410-1-xu.xin@linux.dev>
 <20261123034548.237302-1-xu.xin@linux.dev>
 <16d172a9-bf5c-4a69-93d1-b48cd53b67b2@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16d172a9-bf5c-4a69-93d1-b48cd53b67b2@kernel.org>
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: B9013C0008
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: di8mk7tpthf3mtb1k4jpscaaaxsjhkk7
X-HE-Tag: 1795488367-446753
X-HE-Meta: U2FsdGVkX1+9DpU+FaeUKMya/omVzXVCQ/QcnK75APe0ok6U6d4v0sfWN8epVFXyGXFnx2PMccz3dQ09zJqxYbhF9hio05VZ8I5VaQv3o0Yfuh+40PQUwsHOXMy4AzzxONOTcrwvgrc6qzKU/8734YPFfHqT64kSdhMlSXvcaa7VLTeXK9+45SkywX8Jl5nY4vb+HHmkbiQ/bTVbKL8sVwdiEBsxkLTrGNc9bHpPp4K6NTPI+PtLeMZegiAiTv7iBoABhsn7ZTkPGIUK9/JN89sOHq3mVOSN9YYugi982C2CYoXL8Z6n9yGH1dr9A7S78wzv+ksM6ZjQ7V5arpD0cDQtx/OKS/GZdTLnyZVpmpuBT6Lcyh27XhIXfBAA5h3Zr9WL0zM+KzF4nVmEIyQNEgPhvpRAmvWx94wZAb6f/PYGpDL1avYsWfDuo8PGDN7EluneLWaaXvA5OF0FWxVgXxHp/oLauoE+agg5mT8oON24vYbqY71GSpmZJeWqn8FdtV3os7f9CZZXl7EHG3nBhDnXeWqx3DUDsUabzato2c/eDip/RbGwrIuJFC55gnGvVed6vZ1ByBqLFXmcGDZVnLlVI/1hdra68lM+SX5Kdwp/1yNIga8Oc0hA39sl4HGsvS7LCbvntMVo3BxmGtxO6omNIYKcBZGZ1ZaQUjVMPJXNlDYjyQoUKxSkD4ZoLoux8gsM+8SM1NHEO1PVFqZXGqlT8DWkeFQ1REPWlxqNT2gA4fjwJeZO+I/XSu05yb6/hdoz2KSsf+qjbwEoPds1XBh6VfyBwNTtplfQMhL2T13P5pBHJt6azsbNukV1Ax6WUMkeezCTbFbZcIhXfvlNGS2xZSdKnzyEV3CbEMynja8KkDQX2xkeQijAH8lBD0OXu6J4c5FNpiXkYKR/BqD4/WMIc2B14CYT11q2bf//ASDd0Hino+HkILg0MRpfO/J+IydjV0hx6PpNVO7w8cW
 O7bXToOD
 q/muMe425dgfPL57gBApznB/v2R/LiuRB/HtpK8rb59RuQXRpSXjID6hPhKKl7WNYAM9Fbc4QUUDlb4tVxVoji8cC2jHjWspCFRE32oDD38rrDvnwGYkRaVHs7SPe13V0kJRlt8M2PqPQ7Fefl/OWbN3UsbFUIt4uzOYiUzD94nCbnEZ1xmc5b2ri+F00gUvFDcxK1mBkqI93FQMcY8rpCinF0RtswjiuHo5SuiFevcloLItIuf4GXY6JJAQjZzTAXuqFf5oTrW/Ew5N2KRIOVJgoVgVtPzkidWfpgCs+fd6MhoV+Iyk7a5GsOlrlByatTYnmZYn++LhR3vKUzPPm3UxGa6NXG5KDPfM6o13Kksj3r6K50uc7+8I78BncHLElwiUe3uwjQp0zWbWyklCyIo6pi59Bt3maU9qne/Umka1AawPFudco51FKyHZEG4zULXoVUyf1dCow94kDTAn0eh0dYKL/doIefiX1rIMZGzaEw6A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 05:49:30PM +0100, David Hildenbrand (Arm) wrote:
> On 11/23/26 04:45, Xu Xin (vivo) wrote:
> > Extend test_fork_ksm_merging_page_count() to enable use_zero_pages and
> > merge zero pages alongside non-zero pages before fork(), verifying that>
> neither ksm_merging_pages nor ksm_zero_pages is inherited by the child.
> > 
> > Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
> > ---
> >  .../selftests/mm/ksm_functional_tests.c       | 44 +++++++++++++++----
> >  1 file changed, 35 insertions(+), 9 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
> > index b871d5656688..0e128c579d5c 100644
> > --- a/tools/testing/selftests/mm/ksm_functional_tests.c
> > +++ b/tools/testing/selftests/mm/ksm_functional_tests.c
> > @@ -655,45 +655,71 @@ static void test_prot_none(void)
> >  	munmap(map, size);
> >  }
> >  
> > -static void test_fork_ksm_merging_page_count(void)
> > +static void test_fork_ksm_statistic_count(void)
> 
> "statistic_count" sounds odd. did you mean "statistics" or "counters". Below you
> use "stats".

Yes, I meant "counters" (my phrasing was inaccurate). I will rename it to
test_fork_ksm_counters() in v4.

> >  	}
> >  
> > -	ksft_test_result_pass("ksm_merging_pages is not inherited after fork\n");
> > -
> > +	ksft_test_result_pass("ksm_merging_pages and ksm_zero_pages are reset after fork\n");
> > +unmap_zero:
> > +	munmap(zero_map, size);
> >  unmap:
> >  	ksm_stop();
> >  	munmap(map, size);
> 
> This ordering is odd.
> 
> Why stop in between?
> 
> Also, I suggest using a single label, like:
> 
> char *zero_map = MAP_FAILED, *map = MAP_FAILED;
> 

Agreed, the ordering was just kept from the original code and looks odd.
I will unify this into a single cleanup label in v4, unmapping both
regions cleanly before calling ksm_stop().

> ...
> 
> if (zero_map != MAP_FAILED)
> 	munmap(zero_map, size);
> if (map != MAP_FAILED)
> 	munmap(map, size);
> 
> -- 
> Cheers,
> 
> David

