Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE2A5606A326
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 17:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PGQzzcz9
Received: by kanga.kvack.org (Postfix)
	id C25E66B05E1; Tue, 27 Oct 2026 13:02:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFD6E6B0853; Tue, 27 Oct 2026 13:02:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3A476B0855; Tue, 27 Oct 2026 13:02:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D4446B05E1
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:02:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2F020160ACF
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:02:41 +0000 (UTC)
X-FDA: 85369025322.27.82C20DB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 92B94120008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:02:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PGQzzcz9;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793120559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lz4BcpRRjlIy52XX1xait5NxJ+nHBcl/ZG0w9aFAbtA=;
	b=xMrNBWOB1GCD2LQyfBLxGor3qiUQ63S78vCJa7fejGebbbae7bsYe92OO0WJCJ7vmFgDxn
	UebRWYfCHSlQn1TjJfQA0ysNvBU779VE52xoOS1KGbj/DWQlNu8wElgmnGF5V7iZMck4M+
	X+s1Ot7d09xSE8DoAxVxqeI763mVLRk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793120559;
	b=ki7zQ49L8kOPybJmpSzwX9xINIaukeFvj6Svf3cKeYZanRH6YAu1bu14GnJUTw8tHwOrWV
	5zyKrryBGFI6rKtOEHUFYXF37GIG2oR9eOFuQ5mZpXwW2/zoUFCBKNo4CqjmEttUen6HrW
	8cOcmG8uylCLwirzjYzu1SuMelkZ4GI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PGQzzcz9;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D07026021A;
	Tue, 27 Oct 2026 17:02:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF001F01825;
	Tue, 27 Oct 2026 17:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793120558;
	bh=lz4BcpRRjlIy52XX1xait5NxJ+nHBcl/ZG0w9aFAbtA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PGQzzcz92VDG+hGERDEbtM42qWOa9VrK7DIf7K9SCeXW97YY4peyXBI4up7EhqbXV
	 KlgVEcArAOm4kGLsInP9NvklxuAfceyRq5oQ1nBRDes94GCP3QSHQKr+CjJzGcMSHW
	 SVItdcq1fM/b2Ra8/GmVrZCZjv7GX4YCDO+jQEhPoSokm5mDTkB7E9ltcngSia2SJC
	 p08W7pDUUh7QmG+fpmj4HS8x6+eRK9bZflBASVCHTzd+vBLC4YlOF5zbsqw4EaOcZU
	 n5oybu2SHoVCoiFiyZkCC8EZNGimLCVLxu5dTyqE6NH0erZiY7jMd7IM1bFkAWdYqq
	 oTOelA4zT3wtg==
Date: Tue, 27 Oct 2026 17:02:30 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Kees Cook <kees@kernel.org>, Jeff Xu <jeffxu@chromium.org>, 
	Andrey Vagin <avagin@gmail.com>, Alexander Mikhalitsyn <alexander@mihalicyn.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	linux-mm@kvack.org, linux-hardening@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 3/3] selftests/mseal_system_mappings: Test vdso unmap and
 remap
Message-ID: <auDY6bpeuPZ-jc-_@gremlin>
References: <cover.1793094611.git.chris@chrisdown.name>
 <621847973ba2ec49d0a58e0261da35a9f3a97eda.1793094611.git.chris@chrisdown.name>
 <auC7_5XYr31fimvL@gremlin>
 <auDUAN9xAQRQhnCo@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auDUAN9xAQRQhnCo@chrisdown.name>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 92B94120008
X-Stat-Signature: ipgqfgm31xwkczs5cks3wg3ydkxq63b5
X-Rspam-User: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793120559-794221
X-HE-Meta: U2FsdGVkX19Lj9RuKFNODFqaNz7yK966wCvPW8xOIv6EHYn8+SuM7VpTh4CPCzqqpOm58dG9nHsqzCyQF7IRoAr5RBNHteWadvWBVFAyLcMD/THn4JdmHBJVUOuhERM1tq2zvaNZnXoTItgCvyCuJ77ZjXlVr64EBqZR0drlUhSxg1pUbNh4DuehsqLPIBQEjMKAGXgP0VjUa1jTNsfXVcvfqhjlpWHQhm6ArP1eYfCwkUlXdoWTOJq9b2wsJAkaJ4y7678ZSa38AizVkwQRnfU3dtnJc0/JSpEtZtnMkznzcxGl/BiguyDxwcoo4HalTi2y41SrL5kIHPd3+rv42raOK73qJVYFqD6VrbXi2aBoUKP409TDm6icuzN6BZHN3avLyPfvwEA5uYlzAzc5WzBUaqS82vjVwpaH5aAxK+PE5VK4fUsD+gP0yN2q57qa6x7Q6YnvJIqwjgZexdpRqaAKaTWkMNI6GmbgVp4cOAYCfwo3c4wFlCP+rD6N7DqhihSq9of3/zZ5/M+iPl9tA7Ds8cLZ+33K8Yk3E65NEn59DhLiJix2hUivC3pDZI6FKvJVZMJyO8SVGa2ZqZEngZ5VKNsER4oM1T6zyk9D+7xwm8SBrlRW3yCTb36GWWfQuyFG4VHvoxIuf3aWvH2zY9TUdIMy3aReE3cLF762Z128d0odgYLcAd1KzokG2KJ0Q4VuzufWisFGJj1GyE8I3wz0ranGCT+Uizl8sWcsvrkRNlIWlQaPP6mAkJCs5B1q/IhNLW9USVXfcW4PvLlZuzktwLnqwiiWPvSt2MJPpt5h/hUBGUK435tCACcE4/Uu9bMNAjEk51ayTuHRHI7useZkHugm3PqSkjwPRsx6UXrxbc9p7mPfKVJ2O0YaO5Ktihmfd2HKYOZBU3kVbQ/ZgMKSR4OTkWnKNQmRIxSZih94t2q7qNfh27fE2IEfBfAvF5bEIFnPFTORNnOrKkd
 a2xUK6CF
 weU7FzoTmeQMwIBQpX5Lvp6sgRpQ0MtR4V+HjHFqoC/HWfXlWUkbnBcXFXkulM1Z1/lftgI9CRcQOqPEnE+3m5kEvxdJA0osd/2Xe+O9ukpSuueA5BzYteyk1Vn54vh7RE20rxItA1dMdil/XRvV3SQYHqwQiKOq3V8056dxdIJi6Xv+SRKcROcj9kyLpVxEZJbT/UmTrsYSAxGIoQViGTrE+hg0uX2WFa5GQ4hIICea94SWJNLczQ3J2ApX/pONjFtlJFS/VB88JICMYGMqVmHAdwxyfpG8K5U3BNSv0fFwqyhA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 12:40:32AM +0800, Chris Down wrote:
> Lorenzo Stoakes (ARM) writes:
> > Sorry, in mm we require commit messages. Even for tests :)
>
> Sure thing, I'll add one.
>
> > On Tue, Oct 27, 2026 at 07:43:25PM +0800, Chris Down wrote:
> > > Signed-off-by: Chris Down <chris@chrisdown.name>
> > > ---
> > >  .../mseal_system_mappings/sysmap_is_sealed.c  | 92 +++++++++++++++++++
> > >  1 file changed, 92 insertions(+)
> > >
> > > diff --git a/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c b/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c
> > > index ea75ad537620..83b4fadfbfe7 100644
> > > --- a/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c
> > > +++ b/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c
> >
> > Why on earth does 'mseal_system_mappings' have its own directory...??
> >
> > Ugh I don't know how I let this stuff go on the original series :/
> >
> > Please, for the love of all that's sacred, move these tests over to
> > tools/selftests/mm/. This is an mm feature, for our sins...
> >
> > You can do the move as a prerequisite patch in the series.
>
> Will do, I'll make the move the first patch.
>
> > (And, again, I really do insist on your change doing some cleanup here as
> > well rather than extending this stuff.)
>
> Yep, see my reply to 1/3.
>
> > > @@ -10,6 +10,7 @@
> > >  #include <unistd.h>
> > >  #include <string.h>
> > >  #include <stdbool.h>
> > > +#include <sys/mman.h>
> > >  #include <sys/utsname.h>
> > >  #include <zlib.h>
> > >
> > > @@ -232,4 +233,95 @@ TEST_F(basic, check_sealed)
> > >  	EXPECT_EQ(expected, sealed);
> > >  };
> > >
> > > +static bool find_vdso(unsigned long *start, unsigned long *end)
> > > +{
> > > +	char line[MAX_LINE_LEN];
> > > +	bool found = false;
> > > +	FILE *maps;
> > > +
> > > +	maps = fopen("/proc/self/maps", "r");
> > > +	if (!maps)
> > > +		return false;
> > > +
> > > +	while (fgets(line, sizeof(line), maps)) {
> > > +		if (strstr(line, "[vdso]") &&
> > > +		    sscanf(line, "%lx-%lx", start, end) == 2) {
> > > +			found = true;
> > > +			break;
> > > +		}
> > > +	}
> > > +
> > > +	fclose(maps);
> > > +	return found;
> > > +}
> >
> > There's shared code for this kind of thing, please don't duplicate a
> > /proc/self/maps thing if unnecessary. Also there's a nicer ioctl interface for
> > all this.
> >
> > See vm_utils.[ch].
>
> Oh thank you! I will use that.
>
> > I mean arguably this is an mremap test that belongs with mremap? I guess
> > debatable...
>
> Hmm, I'd lean towards keeping it with the sysmap test, since it's really
> testing that the seal is enforced on these mappings rather than anything
> about mremap() itself, but I don't feel strongly if you insist, just let me
> know.

Actually let's keep them together :) It's always a bit blurry...

>
> > This all just seems like work that should have been done in the past when this
> > feature was proposed, and doesn't depend on your changes at all AFAICT? Maybe I
> > missed it though.
> >
> > Valuable in itself, but probably worth sending separately as a result? Otherwise
> > it's a little disconnected from the actual change you're making.
>
> Yeah, it doesn't depend on it. I can send it separately on top of the move
> if you like, I just don't like touching things without tests where possible.

Well that's a good instinct for sure :)

I mean alternatively you could send as patch 1 and explicitly say you're
providing a tested foundation for the other changes.

>
> Thanks for the review!

No worries!

--
Cheers, Lorenzo

