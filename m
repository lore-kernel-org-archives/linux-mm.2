Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71E16CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 12:10:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EF2F6B0093; Fri, 22 May 2026 08:10:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C6636B0095; Fri, 22 May 2026 08:10:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DC966B0096; Fri, 22 May 2026 08:10:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6417D6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:10:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 168D01A03DB
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:10:42 +0000 (UTC)
X-FDA: 84794939124.03.2DFD6F9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 197C8180011
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:10:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nsKSUe8D;
	spf=pass (imf16.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779451840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NR5c/BN2lwPx/oAjlXegkB235/Z6AMW08ocTQkK3kw8=;
	b=vLpin0B2wwTl+Ey27gFULbdEz45EdMy1wYVjDOnHYo3iL5NksNEicfnQ1eEsDTl00lQHzY
	JXvfCe5+tybsVl5kpD72oueqGfIx556mphnRJAYgH0D+49sTPOSf5PUbs4vLLu3n03V046
	2A4yGXvaQfY+gcOikYevc6Gf9wY5G4I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779451840; a=rsa-sha256;
	cv=none;
	b=RzE1trxEit1aDuQ3BM/jQv4yyI6NABCmI7DlAEHbby+OprcKrkOS7/n4JQTFPWpefXzVoR
	E/JgyJD/PRzXa7U9G/cmYztHdwlJBVelG9i1adBaD4eSDmEcuUSgaVFyuHhDAev7py/rXf
	8Jfip/cUR8KIbX/n22gjCuZfDbfaEiI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nsKSUe8D;
	spf=pass (imf16.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6647460213;
	Fri, 22 May 2026 12:10:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522361F00A3E;
	Fri, 22 May 2026 12:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779451839;
	bh=NR5c/BN2lwPx/oAjlXegkB235/Z6AMW08ocTQkK3kw8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nsKSUe8Deqf4KLp+pobydEE07ri4yQa3QjqBuY0vbDOVmYkHFI3ejrB5QwCngnGO/
	 xANmB/898jQB/q8lbs+gosnxfj8wjJqRP6ifmS+O6SHIq4Py698coczjJuDMjlr6ru
	 YjL0/ieQBXU4X5v50nO/vlqNsHXd1/BZ/P45OuzjTakd6M3ZncVHpg0+h1WSnNnlJ9
	 pwhuSpFkV6Ajd+88Bg2GVOaXvgzC/hUhQtWIjlotcpJx+kWwoWtEqqZhmo8NljqPil
	 QQYEYpX7/jAhA8kigzkaOR59dLB6WpwRfbVqg4zM8a4BjI5tOERXAyowhHHGT6YTCV
	 ieOr/XSatScLw==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id A94A7F40084;
	Fri, 22 May 2026 08:10:37 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 22 May 2026 08:10:37 -0400
X-ME-Sender: <xms:vUcQami1ac1Lg7Qpvf0Ujze5X0DdHgNsg72Q9oqXnK1BKqT_TcNcDg>
    <xme:vUcQasTAupFh2MK3sVKaoKAoe1drNlhnmKweU0gpZrtIyJe0WZutYDm_BsrQTZgoJ
    RBvDGCDY6wjqRXs_YQ2gXEmqd5C3BI_27WgVVuKUrK4ralsr2B_Aw>
X-ME-Received: <xmr:vUcQagt7sKbSf478QF2eSuUuNwy0lVTbHZ166dVPenw62tL9VpBSrx0UQW4NsA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduhedtudefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtugfgjgesthekre
    dttddtjeenucfhrhhomhepmfhirhihlhcuufhhuhhtshgvmhgruhcuoehkrghssehkvghr
    nhgvlhdrohhrgheqnecuggftrfgrthhtvghrnhepveevhfffudejteegvdfgkeegffekue
    evleffheevffeuieetkeeghfdvfedugffgnecuffhomhgrihhnpehsrghshhhikhhordgu
    vghvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkh
    hirhhilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdei
    heehqddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmoh
    hvrdhnrghmvgdpnhgspghrtghpthhtohepgeeipdhmohguvgepshhmthhpohhuthdprhgt
    phhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghkphhmsehlih
    hnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehpvghtvghrgiesrhgv
    ughhrghtrdgtohhmpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheplhhjsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhurhgvnhgssehg
    ohhoghhlvgdrtghomhdprhgtphhtthhopehvsggrsghkrgeskhgvrhhnvghlrdhorhhgpd
    hrtghpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphht
    thhopeiiihihsehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:vUcQau9hm0GwuY39ZrjlrgkaYdCqoNhMctWm0WgszFqQQRArjUF6qQ>
    <xmx:vUcQakb7kciiGLvWjQzbRON6CKiOVScgFTEf0EDwrKLazvXaqLG5GQ>
    <xmx:vUcQalPzySujPLU77__OXF71qZzTTGLxfJpUHN5aXI2NAonqdlvMHw>
    <xmx:vUcQakRmnaclem5MoQxsskVcuzjPMVffL2YWT3cBa5GjwEGnjmncJA>
    <xmx:vUcQao_ocMnXt-A5IpnMgQcuLBUflqRzMX_5D8FgFwZxNs1oKVWQaPJP>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 May 2026 08:10:36 -0400 (EDT)
Date: Fri, 22 May 2026 13:10:35 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, peterx@redhat.com, david@kernel.org, 
	ljs@kernel.org, surenb@google.com, vbabka@kernel.org, Liam.Howlett@oracle.com, 
	ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org, seanjc@google.com, 
	pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com, sj@kernel.org, 
	usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 13/14] selftests/mm: add userfaultfd RWP tests
Message-ID: <ahBDW5Ef5Z1ZafJT@thinkstation>
References: <cover.1778254670.git.kas@kernel.org>
 <e097db49bd0ada5f3c22f9c98c548c3b8ca24ba7.1778254670.git.kas@kernel.org>
 <agQU2c2b3VqpYRdi@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <agQU2c2b3VqpYRdi@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 197C8180011
X-Stat-Signature: uojjnzecb7gaq4hwf981o8613nnfazh1
X-Rspamd-Server: rspam06
X-HE-Tag: 1779451839-922531
X-HE-Meta: U2FsdGVkX18iL+uG0enpYHNAJfrWsKT7klEWUH3jtDJCAxoOr4uIcnD0rkv48015J5bG6iwvI38p0dQ/clVwMaRYyefp2XzAM8LLSNr7tmFvfSQPfRgeTlHxrcmeQRv7Z6toC1sijmL2MWXC63l3MkszRvHeWSL9S2lmywHrQ8k9mXcPCSCJ9Byk99PVo/KZQe5tq5sICxS/LFKY3/1S0Tp0Prr6Vn7Agl9d9KMVZtiDSKUXt3aTwfd2RZEETyPfks2q9DYAVwYmt/vcf0Md6GJP1x01IbXLopHZ7EtWdiEwriFyKILKZgzYI/CHQ1x/djTt9AFG8QpaVEWMl+h9ZmoQNUv9whH3L26r9KCFKm31f+erCRytSgZAGZPf0Q7Nel+/nntUOV8B5sn3FM7zeAbZn7fP5PAu1M+T4nJL4MtQUD9bVu/aHcx9z3DeKH4gN15kBw3iPaP63TyPJB8QrsYO11u2f3lXqqhKG7yzbL+sp/p00nBPQhXC6sARhYA7NsmhBATNKQTjDOawehkzKws4HyE8CCDPJpnkLdmY98f7g8vJXtP6epXSNKyRGNfMCXTj5odX6gyAUb0F72inIsITRjKg+2EYmmpRGEephDA1xqpvtn9nJa7q72Kp5ioANrd/3SSpMAlspUqgSKa4vEIuakh5wqMe3kXDII0o0qcQNtekVRykrAmYvLNU9XMRRGYq7Xpl/VwT4ekLGEREYcRhghqPyrUcma9e4LnBhx8rYRqqs273vel0oUwPp29nTpb+vsXx4iNMSybZtISN/CeEwogT49ipDTxc02uJ4RS02xMgxZgwJLFV1TFFRDPLH6rNXAwdms+traK4U/gAJkaA4kEXE3Z+m4sdirBbtWt+/7EkqrYXqjs6qduu1oDz2wkkCmN+iadODajJARn9r5NZ8pH+rMZ47z/psFCnilsCdRYhPg37dd2Zzn+vjc0pMkhSTcXeWaz5ThzPAZJ
 pFPLSuVH
 mPhYfXDZf7UUMKytltoBv8NerufvWv3r3WNq9McSpRUG3LJuS4jPfWQrI+5KzPi6EJNZxqQZA0kNDxpdcNo0Q4JRF7fSPXLhjSVL56pgcJR71WUfRVgWC/kMhllHwcfdwpQ1+MDk2c2T/BilDW7tx4QSome5u3tdnXi0ycOU3jKfaHnjS/2aPU3NSffOkUfUn32yPYMVYwaZHLU3c3YFoMVovEfti3aOXgXnYM8/PKNVdMhEjcQzVJGBn3X1940ZRZCwKfo09liovXq0agVJug66aEM98mfKR38V7kx/FyiZRZ6OlDB5EpfR7qngj0+LOwQgoFHOuqBg6+GurW3YBwBWc8u+9FOgGR4oXUa2RMgv0u0lUCCSbO0EZkUKSB6YuaCgr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 09:06:17AM +0300, Mike Rapoport wrote:
> On Fri, May 08, 2026 at 04:55:25PM +0100, Kiryl Shutsemau (Meta) wrote:
> > Coverage for UFFDIO_REGISTER_MODE_RWP and UFFDIO_RWPROTECT:
> > 
> >   rwp-async          async mode — touch pages, verify permissions are
> >                      auto-restored without a message
> >   rwp-sync           sync mode — access blocks, handler resolves via
> >                      UFFDIO_RWPROTECT
> >   rwp-pagemap        PAGEMAP_SCAN reports still-cold pages via
> >                      inverted PAGE_IS_ACCESSED
> >   rwp-mprotect       RWP survives mprotect(PROT_NONE) ->
> >                      mprotect(PROT_READ|PROT_WRITE) round-trip
> >   rwp-gup            GUP walks through a protnone RWP PTE (pipe
> >                      write/read drives the GUP path)
> >   rwp-async-toggle   UFFDIO_SET_MODE flips between sync and async
> >                      without re-registering
> >   rwp-close          closing the uffd restores page permissions
> >   rwp-fork           RWP survives fork() with EVENT_FORK; child's
> >                      PTEs keep the uffd bit
> >   rwp-fork-pin       RWP survives fork() on an RO-longterm-pinned
> >                      anon page (forces copy_present_page()); child
> >                      read auto-resolves and clears the bit, proving
> >                      PAGE_NONE was in place
> >   rwp-wp-exclusive   register with MODE_WP|MODE_RWP returns -EINVAL
> > 
> > All tests run against anon, shmem, shmem-private, hugetlb, and
> > hugetlb-private memory, except rwp-fork-pin which is anon-only —
> > copy_present_page() is the private-anon pinned-exclusive fork path.
> > 
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > Assisted-by: Claude:claude-opus-4-6
> > ---
> >  tools/testing/selftests/mm/uffd-unit-tests.c | 774 +++++++++++++++++++
> >  1 file changed, 774 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
> > index 6f5e404a446c..a35fb677e4cc 100644
> > --- a/tools/testing/selftests/mm/uffd-unit-tests.c
> > +++ b/tools/testing/selftests/mm/uffd-unit-tests.c
> > @@ -7,6 +7,7 @@
> >  
> >  #include "uffd-common.h"
> >  
> > +#include <linux/fs.h>
> >  #include "../../../../mm/gup_test.h"
> >  
> >  #ifdef __NR_userfaultfd
> > @@ -167,6 +168,23 @@ static int test_uffd_api(bool use_dev)
> >  		goto out;
> >  	}
> >  
> > +	/* Verify returned fd-level ioctls bitmask */
> > +	{
> > +		uint64_t expected_ioctls =
> 
> can be const uint64_t and declared at the top of the function to avoid
> extra indentation here.

Ack.

> > +	/*
> > +	 * PAGE_IS_ACCESSED is set once the uffd-wp bit has been cleared
> > +	 * (access happened, or the user resolved). Invert it to select
> > +	 * still-protected (cold) pages.
> > +	 */
> > +	memset(&pm_arg, 0, sizeof(pm_arg));
> > +	pm_arg.size = sizeof(pm_arg);
> > +	pm_arg.start = (uint64_t)gopts->area_dst;
> > +	pm_arg.end = (uint64_t)gopts->area_dst + nr_pages * page_size;
> > +	pm_arg.vec = (uint64_t)regions;
> > +	pm_arg.vec_len = 16;
> 
> ARRAY_SIZE(regions)?

Ack.

> > +	memset(&pm_arg, 0, sizeof(pm_arg));
> > +	pm_arg.size = sizeof(pm_arg);
> > +	pm_arg.start = (uint64_t)gopts->area_dst;
> > +	pm_arg.end = (uint64_t)gopts->area_dst + nr_pages * page_size;
> > +	pm_arg.vec = (uint64_t)regions;
> > +	pm_arg.vec_len = 16;
> 
> ARRAY_SIZE(regions)?

Ack.

> > +	pm_arg.category_mask = PAGE_IS_ACCESSED;
> > +	pm_arg.category_inverted = PAGE_IS_ACCESSED;
> > +	pm_arg.return_mask = PAGE_IS_ACCESSED;
> > +
> > +	ret = ioctl(pagemap_fd, PAGEMAP_SCAN, &pm_arg);
> > +	close(pagemap_fd);
> > +
> > +	if (ret < 0) {
> > +		uffd_test_fail("PAGEMAP_SCAN failed: %s", strerror(errno));
> > +		return;
> > +	}
> > +	if (ret != 0) {
> > +		uffd_test_fail("expected no cold pages after mprotect()+touch, got %ld regions",
> > +			       ret);
> > +		return;
> > +	}
> > +
> > +	uffd_test_pass();
> > +}
> > +
> > +/*
> > + * Test that GUP resolves through protnone PTEs (async mode).
> > + * RW-protect pages, then use a pipe to exercise GUP on the RW-protected
> > + * memory. write() from RW-protected pages triggers GUP which must fault
> > + * through the protnone PTE.
> > + */
> > +static void uffd_rwp_gup_test(uffd_global_test_opts_t *gopts,
> > +				     uffd_test_args_t *args)
> > +{
> > +	unsigned long page_size = gopts->page_size;
> > +	char *buf;
> > +	int pipefd[2];
> > +
> > +	buf = malloc(page_size);
> > +	if (!buf)
> > +		err("malloc");
> > +
> > +	/* Populate first page with known content */
> > +	memset(gopts->area_dst, 0xCD, page_size);
> > +
> > +	if (uffd_register_rwp(gopts->uffd, gopts->area_dst, page_size))
> > +		err("register failure");
> > +
> > +	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst, page_size, true);
> > +
> > +	if (pipe(pipefd))
> > +		err("pipe");
> > +
> > +	/*
> > +	 * write() from the RW-protected page into the pipe. This triggers
> > +	 * GUP on the protnone PTE; in async mode the kernel auto-restores
> > +	 * permissions and GUP succeeds. One byte is enough to exercise
> > +	 * the GUP path and avoids any concern about pipe buffer sizing on
> > +	 * large-page archs.
> > +	 */
> > +	if (write(pipefd[1], gopts->area_dst, 1) != 1) {
> > +		uffd_test_fail("write from RW-protected page failed: %s",
> > +			       strerror(errno));
> > +		goto out;
> > +	}
> 
> Sashiko (https://sashiko.dev/#/patchset/cover.1778254670.git.kas%40kernel.org?part=13):
> 
> 	Could this write() implementation be bypassing the intended test
> 	logic?
> 	... the write() call here will trigger standard hardware page
> 	faults during copy_from_user() rather than the intended
> 	get_user_pages() code path.
> 
> It also suggests to use vmsplice().

That's fair. I will look into using vmsplice().

> > +
> > +	if (read(pipefd[0], buf, 1) != 1) {
> > +		uffd_test_fail("read from pipe failed");
> > +		goto out;
> > +	}
> > +
> > +	if (buf[0] != (char)0xCD) {
> > +		uffd_test_fail("content mismatch: got 0x%02x, expected 0xCD",
> > +			       (unsigned char)buf[0]);
> > +		goto out;
> > +	}
> > +
> > +	uffd_test_pass();
> > +out:
> > +	close(pipefd[0]);
> > +	close(pipefd[1]);
> > +	free(buf);
> > +}
> > +
> > +/*
> > + * Test runtime toggle between async and sync modes.
> > + * Start in async mode (detection), flip to sync (eviction), verify faults
> > + * block, resolve them, flip back to async.
> > + */
> > +static void uffd_rwp_async_toggle_test(uffd_global_test_opts_t *gopts,
> > +					      uffd_test_args_t *args)
> > +{
> > +	unsigned long nr_pages = gopts->nr_pages;
> > +	unsigned long page_size = gopts->page_size;
> > +	struct uffd_args uargs = { };
> > +	pthread_t uffd_mon;
> > +	bool started = false;
> > +	char c = '\0';
> > +	unsigned long p;
> > +
> > +	uargs.gopts = gopts;
> > +	uargs.handle_fault = uffd_handle_rwp_fault;
> > +
> > +	/* Populate */
> > +	for (p = 0; p < nr_pages; p++)
> > +		memset(gopts->area_dst + p * page_size, p % 255 + 1, page_size);
> > +
> > +	if (uffd_register_rwp(gopts->uffd, gopts->area_dst,
> > +			  nr_pages * page_size))
> > +		err("register failure");
> > +
> > +	/* Phase 1: async detection — RW-protect, access first half */
> > +	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
> > +			 nr_pages * page_size, true);
> > +
> > +	for (p = 0; p < nr_pages / 2; p++) {
> > +		volatile char *page = gopts->area_dst + p * page_size;
> > +		(void)*page;  /* auto-resolves in async mode */
> > +	}
> > +
> > +	/* Phase 2: flip to sync for eviction */
> > +	set_async_mode(gopts->uffd, false);
> > +
> > +	/* Start handler — will receive faults for cold pages */
> > +	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &uargs))
> > +		err("uffd_poll_thread create");
> > +	started = true;
> > +
> > +	/* Access second half (cold pages) — should trigger sync faults */
> > +	for (p = nr_pages / 2; p < nr_pages; p++) {
> > +		unsigned char *page = (unsigned char *)gopts->area_dst +
> > +				      p * page_size;
> > +		if (page[0] != (p % 255 + 1)) {
> > +			uffd_test_fail("page %lu content mismatch", p);
> > +			goto out;
> > +		}
> > +	}
> > +
> > +	/*
> > +	 * Stop the handler before reading minor_faults: the last fault
> > +	 * resolution rwprotect_range()s before incrementing the counter,
> > +	 * so the main thread can race ahead of the increment. Stopping
> > +	 * here also makes Phase 3 a clean async-only test -- with the
> > +	 * handler still running it would silently resolve any sync fault
> > +	 * the kernel erroneously delivers, masking a regression.
> > +	 */
> > +	if (write(gopts->pipefd[1], &c, sizeof(c)) != sizeof(c))
> > +		err("pipe write");
> > +	if (pthread_join(uffd_mon, NULL))
> > +		err("join() failed");
> > +	started = false;
> 
> I think 'started' is misleading, would "running_sync_test" better?
> 
> > +
> > +	if (uargs.minor_faults == 0) {
> > +		uffd_test_fail("expected sync faults, got 0");
> > +		goto out;
> > +	}
> 
> And it seems here we can just return and then started is not needed at
> all.

Yep.


-- 
  Kiryl Shutsemau / Kirill A. Shutemov

