Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CD98C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:19:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB9FF6B026E; Thu, 13 Aug 2026 06:19:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A921C6B0270; Thu, 13 Aug 2026 06:19:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CE586B0271; Thu, 13 Aug 2026 06:19:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 703A96B026E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:19:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 09C491205BC
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:19:49 +0000 (UTC)
X-FDA: 85095850098.08.33F1155
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf19.hostedemail.com (Postfix) with ESMTP id 612441A000D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:19:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=wWHO0cgq;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf19.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786616387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qdAeuLqcTg0r3BctkPvFE7yUe+SHFHuPonXE6/RBmLw=;
	b=OlHdDe7+O/DOW5u+UDiu3RZnzrpZAg11rEKqg+Xw1cXrWLtnSZOHvFqAoxoh5u9Q9geiFT
	y4/ZmEIyKy1KKS4CyFexRaIkyUTA7Llc6dRNhMHyofDTmlTBj5F2PN2ZOAOr2UhYfZK5/e
	/J/CHMQfXlamIz6Xxn8hq+OocLCqqmA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=wWHO0cgq;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf19.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786616387;
	b=O++MGDxvIKEWJ7kjzAGKno08WyI0GqCQzWpstmk5ZDHw7OtS+jMmksQYNPoShv0PxlkOup
	6vq5AFk7ioFFhyAitVsAJ0c33Ndl4azR1DE+B5YIHhG82rED9p/OJz9LTKhCbQNJllejJW
	+4Fy4M30uwAcgWBiBoKUnHAr7YeStpc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qdAeuLqcTg0r3BctkPvFE7yUe+SHFHuPonXE6/RBmLw=; b=wWHO0cgqWKxsqqTEf9XD1q7ptH
	W0ilpGHM5+3y5MzIcVSHDLVUdi1zLN+UQFT2Q1tvKSwGvP7dSYtkYRPkH8NmAwMSx39duVmwpLU5M
	3mo6PEPYeY2Jb1MrizS3YAgerjBQR6o/4TL+7k/Ne1OnEYQHyTFGaCDGklBCRkGG3ZNtVKDjWJfLd
	NU0lPT3m+/kKNQrnqpkd4ic0S77aCV2KRW9nNCV8Ksf1HUxfAl73S2CzvmFZprw8Sx0lVUeR6A+1T
	IgUifsVYwD0HO1zBMe/H4zuY353uS3RmrG/SVjDWYfKTXUoSHvma015fSllLmIn6/TQ3dDu31RF+F
	mE5zfNjA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wuSX4-0052dW-3D;
	Thu, 13 Aug 2026 10:19:31 +0000
Date: Thu, 13 Aug 2026 03:19:26 -0700
From: Breno Leitao <leitao@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: SJ Park <sj@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-riscv@lists.infradead.org, kernel-team@meta.com, 
	Andrew Morton <akpm@linux-foundation.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, david@kernel.org
Subject: Re: [PATCH v2] tools/mm: add hwpoison-panic tool
Message-ID: <an2Yr4n6ahggXKo1@gmail.com>
References: <20260803-memory_failure_rewrite_test-v2-1-ed020ce42129@debian.org>
 <be68a841-a326-4826-8e02-5148736dd356@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be68a841-a326-4826-8e02-5148736dd356@huawei.com>
X-Debian-User: leitao
X-Stat-Signature: srcpxa1xxiqzoosw81mbwrzt6hdcdwjb
X-Rspamd-Queue-Id: 612441A000D
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786616387-455816
X-HE-Meta: U2FsdGVkX1/qY8BbqyA3Pyobmx2ql9MWCiN33utQjHnw3un5WyKqthfTfUDNZL9fTONf3LGkLsTlPmmCSHGdJxY/qj4M97/Y3R6euWyWo36jVVryLlH+k7cO7kYV7Rk6Me4W0gBUUrOBEI/MEb+/agrOVwzMh3ZKj+1KcJ/PogDbSR158AuEYj9tuewDo8P6pIywOVB5Z3NRA8bdSv7fxGs4lFvhDx8eYibrTTJsTomuYvYWWOuW3gm5po9RRYuOECbR7ik4j/ao/GxhMXSpvj8l2orkfAc3/tVhfIPOJXntgk0krQpmthj99HOtTqAPtHcodcVB2zuIrzW/kZAkPxL55Rxwnzy7u54jbmAPPsw6HEH+idEhNbXrwFGnXsElhaQxqGn4A0zOX1/B4CkKwzzQ9rTH9LCsVqT8gXECn0kI0Vb/5x5pkd/3pM9c7w8TZYl0SdJ3mYhb+DdiTS+ZcKSdV9lQkmV7c38GbFMAhXMrswA7bVdNQr+buSdHBzWxd6uq577SNPmivvvrtbNoMrA2S/VSMqFKABC1zihtjxVqC14rnCIX4vB6u7yhKVEaPm2EEyHBUD6rXUe62yoLlt8IVwVRlETUFyAQId4H4ugmR4wZZORuprDnADUlEv39MkGr6/IKnTw7RUU5yB2j5eXXszcc3QSdtzKtdgJ9y+UP9WnkBkQ1vdUHKTFjBI+b0z3YFpio1RmDwNE3TYOpbQTzEvbJUkm+fFUsAwkGcbNgaGw9QWICxbcQi1ct9B/U6ovl4LdPFLKXkO+A92bjhTp1wU/F1PWZGw8piXU5TVTzlNsVYTvJi7JZUwcCTUw9gDJZv8H5c4b1boqU/c4Ca0m4ccqSnhWsgsk/nOJmSh4DrRtUGCseARawDT7bILLIvzXWb9k1yQzgDKp4eraNQTNdC5Lo6x57xjlnc1DcoeyZerNdBj4O3FChWQrc548BacTHmsGlPpIzA+ExTAN
 BfVQotPI
 MPIO9kfN2vyx64oMeO/dHyPZqpWLVPCeFXSgSQ5twYakSLSTE2WfDywTdzDyKnLHLBJNaIduoesPEQR8Uii/qt0Wee1Iw2TdtAzurIOE/LZgMPc9SoOPKkf9tWdxkEQsdLMRSx/95FxWYfr7qN/ywHZgKnA2o2kDDMuHhYNC+5qga1EjVRedAk65Djs1ztPRMtdI+w8DVcpOxkNuHlfU8EMHTkfugwU0dITcfl7zh52t1M9D0WfWORRvrJH/uZzqlx1DzH+5eBsmIs7+S0T81ujE10k78QKbLQMGdEkkwE4fY+mXxYXzxk9l60U7R1RZutwGy8bo1XHUppFU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Miaohe,

First of all, thanks for looking at this one.

On Thu, Aug 13, 2026 at 03:32:34PM +0800, Miaohe Lin wrote:
> On 2026/8/3 19:31, Breno Leitao wrote:
> > +static int pick_kpageflags_phys_addr(uint64_t want, uint64_t *phys_addr)
> > +{
> > +	uint64_t pfn = (16UL << 20) / page_size;
> 
> Could we use SZ_16M macro here?

Sure, for that I will include ../../include/linux/sizes.h in the next
version.

> > +/* hard_offline_page() injects with MF_SW_SIMULATED, so unpoison is allowed. */
> > +static void unpoison_pfn(uint64_t pfn)
> > +{
> > +	char path[PATH_MAX], buf[32];
> > +	const char *debugfs;
> > +	int fd, len;
> > +
> > +	debugfs = debugfs__mount();
> 
> I might be miss something but I can't find the implementation of debugfs__mount.

It is an ugly macro declared in tools/lib/api/fs/fs.h:

        #define FS(name)                                \
                const char *name##__mountpoint(void);   \
                const char *name##__mount(void);        \
                bool name##__configured(void);

And then:
        FS(debugfs)

> > +	if (access(INJECT_PATH, W_OK))
> > +		fatal("%s not present (no MEMORY_HOTPLUG?)\n", INJECT_PATH);
> 
> MEMORY_HOTPLUG?

lol. it should be MEMORY_FAILURE

I will get these points fixed and respin.
--breno

