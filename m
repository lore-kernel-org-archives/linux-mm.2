Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDD89C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 08:56:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B9ED6B008A; Tue,  8 Sep 2026 04:56:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96AA86B008C; Tue,  8 Sep 2026 04:56:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 859736B0092; Tue,  8 Sep 2026 04:56:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 595E26B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 04:56:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D9F83A04B7
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:56:31 +0000 (UTC)
X-FDA: 85189988982.02.5E9A5CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3C89840004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:56:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hQ79rwIb;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788857790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7GtzElf9EKxZso4ToovIvNR7XDQENlazd7Q/RdkJzdo=;
	b=BQf3zH6t3Rzyx0f5WZwoo+QN8/gxxGVK51DLZBRxvQ8iynjV2G9UUfMAWZ89y4Ex0zxmvJ
	UcBE/Ynd15Memldmzk1bZZLUrlhUTSmL0leYba9bGiRcCvJ23yAVQStBDqBVH4L5n1c8b8
	3qLBDwcS81HYlzXmfihORTDJW/7wEzA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hQ79rwIb;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788857790;
	b=sUxkhYjyKw0zznaO+rw3GlxrQOS8kEeZYAovG/B6w8gSeElliyyYz4pcdZQu9lP17zdDGc
	QmBSE9mbjHS7oKwn63/zPRsbt0dfB1jTN9yWwqKA8/Ga0pd//+5vjxn2KE6JpMzDfeNF4l
	Db/EAJavPxGIX/ZYFgfeUCG2R1FbSVU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 67A7543698;
	Tue,  8 Sep 2026 08:56:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050E91F00A3A;
	Tue,  8 Sep 2026 08:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788857789;
	bh=7GtzElf9EKxZso4ToovIvNR7XDQENlazd7Q/RdkJzdo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hQ79rwIbEigj2HF6YhUhvrVFLJQeX0d2CLSQ363xGAnSZG2MkP+aC/cHWxuxjEigT
	 Q9iKlYIucsWreXv/r0AS/DJao72+AhIM4G4qUqH3eICYNbwVtWIk4f8PxitVXtpKGu
	 bQDXJT6FWnwWbGoUpuJU2jtftDZrQZUMM9CBy9SMtVmtkPrRmZw9B3tv9063UbazD2
	 3o8ai0gV0j06rkFLJInDR37/FfUAx5ohLnkb3QqIXt7ISK9IaAd7pRr6sHFGUgBe2v
	 Chk6IuG/lChHjaK5tYzvDsc0Nv1SDd3plshDkUuSuKk2kX/09RUfnf8/bWmcYikXNP
	 NWR2zFpjg6ZTg==
Date: Tue, 8 Sep 2026 09:56:22 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 6/6] tools/testing/selftests/mm: add
 MAP_PRIVATE-/dev/zero merge tests
Message-ID: <ap_LyUQNjxyytDue@gremlin>
References: <20260902-map-private-dev-zero-v1-0-a578c730cec7@kernel.org>
 <20260902-map-private-dev-zero-v1-6-a578c730cec7@kernel.org>
 <42c1b1be-d176-45fd-b467-464b5b87e116@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42c1b1be-d176-45fd-b467-464b5b87e116@kernel.org>
X-Stat-Signature: rjwcpa7poni17irxdmkqyj94thapo7af
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3C89840004
X-Rspam-User: 
X-HE-Tag: 1788857790-452190
X-HE-Meta: U2FsdGVkX18JSZRoV+KS1XXH7lYng5CEyH2GfaMxQo0V/WfBet4hKH1GhbAI/CVdnodVcfhpuxUqQzLx1LjjIzWuHnURXSndeKjgx8krTloCWnp+5FiKf1rztGijccueAKOn9GSX2cTCpJ/LqV8WP+Qvu1cAWipUaeFm0FNlWfQVpOXAo50FKfYYRucgaqONxKKIG7z1xibFQkqxgdcFnUZyXcsHX7WCg9DM6pgYZP4UgogFp0NjiPTgH3usYd9GLXKUulFHBTYkJUIMg6VR0YbALbeXB/IvRu+7wWFTYaI021x8b5daUOneWVBb7itVit+aeseJ4S330LllHZfu2hZWiwD97bImNeCqhX3fshyfyUjcoKxN0ZbWk5/FwY3V5Vz0Ki4CNhklyqyLC2ocRgTmhfIhcheAXhZq8NpRVyoOWwIqY78NlyxrStAI39MtjTGq+ua56+PUptm8nUKkOos4GukZG8PjsD5pThrRinFyrRlM/kMV0ZcT9+PtUPssXe8rZPpmqbqkm3TdozXN+1SLbxstQizXjW1cnWkPsnc/guBeNqA71I+RPM5VJI/VInCAA7r35ZfYWQOVgJJyFieQE+dDvfr43/IqQP0XqsDyPzPHP6N5db1W9OBtbX2QhKbXB7Tmhs1DCTRtgFOu59yMQQTRplgXmwnwEXMYRB7D/p3Arxfm+X02BK8x89GOOQCF32CMuIoce0EfrVna0vRk4ecQSCy3/8TF1kpxl+026uo0FugrOvhOvXPDn5tbmZSp69/rVT8vlxucptmUgOG2f7PDZsylOA2avFZKX/myT+OGrUNa4lPNMPbjQAWbkyntlAHqxwKwdKBf1tmPtVn7JI5HrP2k3sPe+vH2oOwnPVnY+zYF9mfl09lVj/eGbNPs4oAzDV0kfP356+OUM3wPcAAbwuw8EGPosFABTBrH5VlkuspuBrfgiDvkcCNTDGKWA3xabV9ffaPdtsT
 gdtTZblN
 +aVoPoWtlQQVQdPkobpnd8Jn+Q8OimL8lL+u6hf5mZ8n1hkX5Gyu/AmhmyKX5QlX/td54dCG3mRM0UJJxcjtZ/S1D6m6yntmY4I/gp4NP27KXIZf6F6soGbniZyblluGAXyHYbeTrtOSvAhfwhc0fmsO//ZRY+9K+uHAWHAXC9OXLrFxTD+IwZVaPZXs3NlNJI1YH6qo6s0ZszjAsDr46mvwWOLXlt1CH7YKp/DRse+vX7WjI5gl4gnpCMnGR2VAydfvA/1xmnix1S7mjN6merCopwMUMq48Av3Zuaq25eHCFtdnnP6M+5Z1eK7LY46TNZ8hvvQYqmbEb17U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 07:08:48PM +0200, David Hildenbrand (Arm) wrote:
> On 9/2/26 20:00, Lorenzo Stoakes (ARM) wrote:
> > Assert that MAP_PRIVATE-mapped /dev/zero mappings behave like they are
> > anonymous.
> >
> > We test both unfaulted and faulted/unfaulted merges - each with the regions
> > having page offset of 0, which would not merge if the mappings were treated
> > as if they were file-backed.
> >
> > With the recent change that makes them behave as pure anonymous mappings,
> > the merges should succeed as their page offsets are equal to their
> > anonymous page offsets.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  tools/testing/selftests/mm/merge.c | 104 +++++++++++++++++++++++++++++++++++++
> >  1 file changed, 104 insertions(+)
> >
> > diff --git a/tools/testing/selftests/mm/merge.c b/tools/testing/selftests/mm/merge.c
> > index 52b8727b6628..7c528d470404 100644
> > --- a/tools/testing/selftests/mm/merge.c
> > +++ b/tools/testing/selftests/mm/merge.c
> > @@ -1362,6 +1362,110 @@ TEST_F(merge, anon_and_page_offset_mismatch_memfd)
> >  	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 5 * page_size);
> >  }
> >
> > +TEST_F(merge, merge_map_private_dev_zero_unfaulted)
> > +{
> > +	struct procmap_fd *procmap = &self->procmap;
> > +	unsigned int page_size = self->page_size;
> > +	char *carveout = self->carveout;
> > +	char *ptr, *ptr2;
> > +	int fd_zero;
> > +
> > +	if (access("/dev/zero", F_OK))
> > +		SKIP(return, "No /dev/zero.");
> > +	fd_zero = open("/dev/zero", O_RDWR);
> > +	ASSERT_NE(fd_zero, -1);
> > +
> > +	/*
> > +	 * Map two MAP_PRIVATE-/dev/zero VMAs next to one another with offset 0
> > +	 * each.
> > +	 *
> > +	 * With these being made truly anonymous upon mapping, they will
> > +	 * merge. If they were file-backed VMAs the page offsets would prevent
> > +	 * merge:
>
> Nit: "the" merge? You're the native speaker, so I don't know if what you have is
> just correct :)

You're right ;) native speakers are not immune from messing up grammar, as my
copy editor will tell you :P

Will fix up on respin.

>
> > +	 *
> > +	 * |-----||------|    |-------------|
> > +	 * | ptr || ptr2 | -> |     ptr     |
> > +	 * |-----||------|    |-------------|
> > +	 */
> > +	ptr = mmap(carveout, 5 * page_size, PROT_READ | PROT_WRITE,
> > +		   MAP_FIXED | MAP_PRIVATE, fd_zero, 0);
> > +	if (ptr == MAP_FAILED) {
> > +		close(fd_zero);
> > +		ASSERT_TRUE(false);
> > +	}
> > +	ptr2 = mmap(&carveout[5 * page_size], 5 * page_size,
> > +		   PROT_READ | PROT_WRITE, MAP_FIXED | MAP_PRIVATE, fd_zero, 0);
> > +	if (ptr2 == MAP_FAILED) {
> > +		close(fd_zero);
>
> Is the close() really required before the ASSERT?  After all, you're also not
> munmap'ing, so I wonder to which degree we have to clean up.
>
> So maybe this could just become a
>
> 	ASSERT_NE(ptr2, MAP_FAILED);
>
> Same for ptr above.
>
> You could likely also do
>
> ptr = mmap()
> ptr2 = mmap()
> close(fd_zero);
>
> ASSERT_NE(ptr, MAP_FAILED);
> ASSERT_NE(ptr2, MAP_FAILED);

Yeah that's easiest I think! Will fixup on respin.

>
> > +		ASSERT_TRUE(false);
> > +	}
> > +	close(fd_zero);
> > +
> > +	/* Assert that they merged. */
> > +	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
> > +	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
> > +	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 10 * page_size);
> > +}
> > +
> > +TEST_F(merge, merge_map_private_dev_zero_faulted_unfaulted)
> > +{
> > +	struct procmap_fd *procmap = &self->procmap;
> > +	unsigned int page_size = self->page_size;
> > +	char *carveout = self->carveout;
> > +	char *ptr, *ptr2;
> > +	int fd_zero;
> > +
> > +	if (access("/dev/zero", F_OK))
> > +		SKIP(return, "No /dev/zero.");
> > +	fd_zero = open("/dev/zero", O_RDWR);
> > +	ASSERT_NE(fd_zero, -1);
> > +
> > +	/*
> > +	 * Map a MAP_PRIVATE mapping of /dev/zero with page offset 0, then fault
> > +	 * it in:
> > +	 *
> > +	 * |-------------------------------|
> > +	 * |           faulted             |
> > +	 * |-------------------------------|
> > +	 */
> > +	ptr = mmap(carveout, 15 * page_size, PROT_READ | PROT_WRITE,
> > +		   MAP_FIXED | MAP_PRIVATE, fd_zero, 0);
> > +	if (ptr == MAP_FAILED) {
> > +		close(fd_zero);
> > +		ASSERT_TRUE(false);
>
> Same question regarding cleanup requirements. The ASSERT_TRUE(false) looks a bit
> odd.

Yeah it does. This case is trickier as you then do a memset(), so maybe just
live with the 'leaked' fd in this case (the tests fail so it aborts the run at
that point anyway and tears down).

Fixed and will send respin!

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

