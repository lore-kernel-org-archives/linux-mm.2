Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4B1AFF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 05:32:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD4C86B0088; Tue, 28 Apr 2026 01:32:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C84DB6B008A; Tue, 28 Apr 2026 01:32:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9A936B008C; Tue, 28 Apr 2026 01:32:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A73426B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:32:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ABC8FC1A73
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:32:27 +0000 (UTC)
X-FDA: 84706844334.03.DB25A2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id E800812000F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:32:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y32+BYhp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777354346; a=rsa-sha256;
	cv=none;
	b=6+c3zGztDbkmNJPu7cbhuzowxco1/dt0GN9y4A25mMeFdsAmTxO4avRUHKSFjwswgvZA3L
	J90Tz4eWzpTdyRlQOfyb6C3BvpbMHsk/Pq51nylxbf6kJPKf7KF2I8mx0Hju4qJzn0ZZNN
	YFK7OeKLlOiU+6R6Z5Ed5N7E3cs7DWo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y32+BYhp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777354346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kJcYF3d4ByNazZ5C3G1/MwnassoXu+gZ3iu++UL6/PQ=;
	b=hl5dF0NqlEdNL+MnK4D16GrjSFqzQ5IdEHWy36qoiwUFOZQ+EjmQZtorJvLUxcpUb77T9O
	FgKifAklN3zp3oTcwPYujKgCoNLvXBt17zq1m7kgHdtYVZNlcy3gtPDHQyzOZ0vxJVF0hQ
	96KvI+9AE9PQrGJnE+q6/M3SD2J07FI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 725CE40B6D;
	Tue, 28 Apr 2026 05:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726BCC2BCAF;
	Tue, 28 Apr 2026 05:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777354344;
	bh=HXD3NULaiKxP74Y+lFSieag6CvNY1MZpZgOjWe+R1wI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y32+BYhpLkxAHA/bcgUTxiieuu1PslsbFU/zMUGy8nYTLlt9Q+6I/aWw3gMqC7B5F
	 ycCTxavHvZSv6DdBlLhahS5KZLrp3/OE6UwdxJEzIecc7w1CqsWZJL91T7yycgCkV8
	 VcSyCH0G52eeV8a/EZrTsGYU7lJJPnf/7vKsDDnaiDTEZ4qaul+xQuW8LZ69qVZpeC
	 4S/lS1HdjtPO5yOeE034coqTBFlpmBicZlq1OKjj4BaiEYNo1jMpqyd28oWSEImC/O
	 vuA6RnMCpEaomMVvK1fzP3uNSvEt6nGmKl0MZUzmydiNZcW52zm8iTJLMsORgF+MFc
	 QlfCYsUDeRWOQ==
Date: Tue, 28 Apr 2026 07:32:13 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 31/53] selftests/mm: gup_longterm: add setup of
 HugeTLB pages
Message-ID: <afBGXcA-BeH_KUWN@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-32-rppt@kernel.org>
 <0d52f348-5f4c-4480-b854-6b73ca5ae294@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d52f348-5f4c-4480-b854-6b73ca5ae294@redhat.com>
X-Stat-Signature: kotfeqoeypmqywcmwwp3ucz1exuyp734
X-Rspam-User: 
X-Rspamd-Queue-Id: E800812000F
X-Rspamd-Server: rspam07
X-HE-Tag: 1777354345-175642
X-HE-Meta: U2FsdGVkX191RLPMpdlQ5y4uhN159AO2myQDaFJQLDb+obj74KIwgMEcUe7x5aMeY0JH6Drqt8znRmm7pYVX4SOhqq08ixDGCTF1DyWfr4+bPkn200z8DZDYdxY83VyfQiE9FMapoqN2UjndP2aaGGqG6WtDLyVkVcrT4LxQrt58AboH/dcbzxHHaBXjS9viQJJFVn9JtdEn62+C+86M2LZAT2xqUK67iIBn9jZQyI31o7Ir+onClWXjlCUiTSIag3QgfCL5sXollx9T5VQFZhZESmYVcFXtnev8LIcfS9jAqBD57wOzaPwe5Fo7Zf+yzTNFsk71kL8bZct7sZt9IqWf4hc/ug392NTIGrU+rR4eq4vqQsRUNCawA3p+FSMulIzvrc+fj2uQPg8LGGnaa6PMRjUmEzYRf/xBmQ1HC0nQICZvYto+RSwDl9cTOTPnTF71kDdLXpc75+bjzS/7x1fMGZaAOI7yckT6F4uUYA1L5ugSKVcU8/Ho7I7Z0qifEpPLwesdXsOENy7XqSMmo2Abr6EA+5cU4/x7Ai/kqUbdneReS2r7WYqwlQy6RzO9Puy+nx0Y2yDhfTK+skOc+v9OXd5ozqJbJb38q7zfQoP2xKNNBof03DbIzopyIqCUTja5bGZR4JWhmNTiy28Kn5iwuaXKsEp1ospE9OStNt0eM7eJGf6r5zm0MPXDPRTGObEeDYm6lAXNrrFNAIgGSL2GImOzDPnDy8B1zAjeDChMgagwSlPiqnZn69aKro+YykIYhRt5V8vGRsFpYe1/GxUMr41NjxGfCj+QzFbGW1hq8yKLwfJBa3DrJ8fCy1qDCbC2h7gsVDdio69MWzcdSY7CN1ZBMMX2QWwriiN5bmAaiUhB7madGdY6wzhB788avO8YsM0xF79I+X5lAPKu5jQHjXxOFiZu9ctQzCw2F23dXwyWcqmQTlvh66CfgukuWR8f2/Ld9DeCQDXZzmk
 DMyM5ukN
 XxRWcSbCiwY6vIHhGIRBbjoXR7yYexoRDAM/r4w4bl0dEdw63vOjLyP0zoNRB6ZLE4r6Su8QcIsJzoYpEkb/Red8PJ6vlSKvElxqzAgkHGL+Zu+UrA0iU6zWyxr/VSCN/V4z/G+UKpc+GK6Hkl+krbVIVv0OHt3hmVE8kgh7qPAglTOiCWPgEqMTJfhgnaAVZ+vkw0QIVbMDhpnUibli0gZfT54K60UbYM/oJUk/dzmTUOpAHXHXSO8g6pZAZsO9CTOTxQArYWlTjqIFkLKgyghHuVpOHt9hGu30HrFHzk+D2VzqsmhgsSUDCEpPTaf6VzikiUNC6id3eVbk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 04:10:23PM -0400, Luiz Capitulino wrote:
> On 2026-04-18 06:55, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > gup_longterm tests skips HugeTLB tests if there are no free huge pages
> > prepared by a wrapper script.
> > 
> > Add setup of HugeTLB pages to the test and make sure that the original
> > settings are restored on the test exit.
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >   tools/testing/selftests/mm/gup_longterm.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/selftests/mm/gup_longterm.c b/tools/testing/selftests/mm/gup_longterm.c
> > index ab4eaf4feb7c..6e1de12bf28c 100644
> > --- a/tools/testing/selftests/mm/gup_longterm.c
> > +++ b/tools/testing/selftests/mm/gup_longterm.c
> > @@ -510,7 +510,7 @@ int main(int argc, char **argv)
> >   	int i;
> >   	pagesize = getpagesize();
> > -	nr_hugetlbsizes = detect_hugetlb_page_sizes(hugetlbsizes,
> > +	nr_hugetlbsizes = hugetlb_setup(2, hugetlbsizes,
> >   						    ARRAY_SIZE(hugetlbsizes));
> 
> Are we missing a call to hugetlb_save_settings()?i

Yes, we are :)

> If yes, should we do it in hugetlb_setup()?

Yep, will add it there.
 
> >   	ksft_print_header();
> 

-- 
Sincerely yours,
Mike.

