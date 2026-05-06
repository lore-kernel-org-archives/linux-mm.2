Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC2DDCD343B
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 14:19:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E96E46B0005; Wed,  6 May 2026 10:19:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E477C6B0088; Wed,  6 May 2026 10:19:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D37066B008C; Wed,  6 May 2026 10:19:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BEE2E6B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 10:19:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 69545120272
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:19:03 +0000 (UTC)
X-FDA: 84737201766.05.F0ACB47
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf23.hostedemail.com (Postfix) with ESMTP id A1FC8140003
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:19:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=J0+CPLXT;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf23.hostedemail.com: domain of cascardo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=cascardo@igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778077141; a=rsa-sha256;
	cv=none;
	b=YiE/KiE5rUwDf1izaBBmiwLRPFYpNGpGIGRPcPbMctv1AP4gjJSyZs0mClox8bFL84O5RB
	8eyIAs5v/ZRg9ZLDRgSOujzg2MedD/aQmraTqmUDeXttOgxJYKaitC5NKBkrprtdzqATbh
	EleL8l00+fP9pwfqERPkOzPvO5r54wE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=J0+CPLXT;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf23.hostedemail.com: domain of cascardo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=cascardo@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778077141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nRaOz1lcNpsbT5rGgL5au+0YmvtZKsbg6EsSvRJK3wo=;
	b=OWJ97QhX48vbn8w8w+UHhQkpzKNZ/jCGTrbMSeshZ4AoGPkURByrJM3voAtmYmMaRaMUpx
	KN9fmsPjkGZRDzcBi6oyjRxNFtw26AKChYGtgjEGknYefxUrBmkobjfeFyI+iSMm0Lu7AB
	TgPi78uOmpoTSlX4KURhS7VU6ivKifM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nRaOz1lcNpsbT5rGgL5au+0YmvtZKsbg6EsSvRJK3wo=; b=J0+CPLXTtNQdpaIr6HVLL0e8Xl
	ERcF86Asw953dAX+lVYLW1no599f6dj17G6vx9xuNZy/XTr0AazOstdZ66BHYXBKoOiTrZsL5NBJB
	JKhxDu1tl/uZ1zzifPOyL+mRbBp6aHbi1syE5IrdaXrYSuFBxTodHrIZ0JjPWzh1/yEt/a4R/tp+D
	nNkNKzlwDHAcls/hefSAy7HJ3YENkstDkGe6Ch/fhAuKvDfol9x5V1I3oM753Ojypz3KX5gFhzb52
	2dh7b9pu63gswb1OlPLJnVe//JdR0494s4hqRICH5sGbmdcSChgE9t4wrnwGYm1toQwKBkWs9XHUz
	XfaqdaKw==;
Received: from 179-125-92-238-dinamico.pombonet.net.br ([179.125.92.238] helo=quatroqueijos.cascardo.eti.br)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wKd59-006vns-Jr; Wed, 06 May 2026 16:18:35 +0200
Date: Wed, 6 May 2026 11:18:26 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <natalie.vock@gmx.de>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, dri-devel@lists.freedesktop.org,
	kernel-dev@igalia.com
Subject: Re: [PATCH 0/2] cgroup/dmem: introduce a peak file
Message-ID: <aftNsqrv2sGPOPHX@quatroqueijos.cascardo.eti.br>
References: <20260506-dmem_peak-v1-0-8d803eb3449c@igalia.com>
 <aftB-cc5EhDXxCGA@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aftB-cc5EhDXxCGA@localhost.localdomain>
X-Stat-Signature: 9yt3pgxqw1cifnxfjxkfdrzsam4q8xh8
X-Rspam-User: 
X-Rspamd-Queue-Id: A1FC8140003
X-Rspamd-Server: rspam07
X-HE-Tag: 1778077140-337824
X-HE-Meta: U2FsdGVkX19i0DR0p9+/XbGpN8rHY2Hh4sP3lvU6kINxxFIizTvmymwgTwkNnclhPIfSfGyHdp4yFQypyb06M+X9ssV7egJB3f7Xq8n6pxWXGJmyfiEH/KKmGskutMIzOMxbyhr3ULdITiTPBMkdPT1fO8NdUAJN+1XLMLIpDDl+Wn1OA1VMf1UnxOKNMSbXlcl84IV3C22h/wUbIZF3V18aUD3Vn3bhtGAezAkvuzwrH13DZiqYEGwamx4LVXU59/Uyn+sRsrTu79qGRrMGeSD61l+1EqcfPhQVlr9ZHrHmj1RxmsODmMthpEi+B8eb4UvdgdAYfv3uk/Fvm9Mp+HzjbpI18hurmL9wm2uQZ13xJ85STwa+HttZUQXUnJg+itPb9GwLBxQ8nsy3GmWizIOlsVEnoExhcVIIQdxrE27pkG5WUXm7qM+xkk43QFVfXMey1nJuS0GvIxOyxS9H4OJ2FmqSB+/y/Hhf1Nc5Nuo2KDz8z4aZWIxbBvuQm7Pjkq+UbU08tU/IWImMTE+6wsLF+zDh64XVQlr+u3OMUuGdKzEIhrvdaiP0VgzYyCvg1Cx0MHeVAIW6MTT9yyxanx7jC5rbEMXI6Swtnu+VCeAf/HZHqJ7koHVzyi5ZGs9E+NeKWxynnIoYQtavUtYCi6B+Sj4dxFQ9qevZndRo+VCFXUoeW9Y0fThJqEdUbgDbgy+kID8cgIPRDItoTQrEQmBLlhhD/t8mXMzsqhz4DtAy2N2kS/t7wugYOqhv1sur4xxkm7IvOiElphdFgOzpAdwSgmTW9IRhPI7HhyNqXaU7u7avJHD8JeLpZseKMj/G5pULHPijvU0XMrK3xrfIPbK8cCVguMA9Aq9g3Dbq1NJLjIRBZyaAk+XkRTs6hZFx3BOEUPZ24EItq2mrgAYXxTUtINhYE4msEIUkNSyNOG+wmx1TC/jIH7AuXLrbgf7qN4C2kb7mGfuIhl7ubv6
 30lUNDSI
 EEuaHaKOUWYM3zjtSfIW5CESVrK36uXDrWtwUjYf/RujFhvsqpKk78Id2LbodlBJlsn9IdyOs4sjDCic6W/6ATMNYjj6a2rOTGYUyUf1gBKp5tZRhP0yO/MlX6Ndtl9NA7Brp/Mg8LuONCsW1CJmgquHhpGqBR9IpPmWo/lfpclxSMuefNtycbdy5Rc5oJfSxx0LAGzND71gOJlxFYhhnlwQ9Z7ilREOG/MeLX0KWT0MMheCfpZQ9pl0D6Yn0Ey7n87IE3icw63EVzYMJbS03uoag8zg4HOFwOZioxvXgYRPg+ex6p7tnrQFyVv/9paIHMzFVe11iJScQCVoRMDMpQ9QJmfv8UvlbOu+k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 06, 2026 at 03:53:59PM +0200, Michal Koutný wrote:
> Hello Thadeu.
> 
> On Wed, May 06, 2026 at 08:58:23AM -0300, Thadeu Lima de Souza Cascardo <cascardo@igalia.com> wrote:
> > Just like we have memory.peak, introduce a dmem.peak, which uses the
> > page_counter support for that.
> > 
> > It can be written to in order to reset the peak, but different from
> > memory.peak, which expects any write, dmem.peak expects the region name to
> > be written to it. That region peak is the one that is reset.
> > 
> > That requires ofp_peak to carry a pointer to the pool that was reset.
> 
> (It'd be nicer to have generic data in that generic structure, at least
> some void *priv. But see below.)
> 

I used void *, at first, but as the only current use is for the pool and as
mixing different uses may lead to misuse, I thought it would be safer to
use the type directly. This has been pointed out before for other members
of cgroup_file_ctx. See [1].

> > Writing a different region name will reset the different region and make
> > the original region peak get back to its non-reset value.
> 
> I'm slightly confused by this fds x pool matricity when there's only
> a single slot in cgroup_file_ctx::cgroup_of_peak.
> 
> The intended use case is that users should maintain one fd per pool and
> not mix it up?
> This stanza would better fit to cgroup-v2.rst proper than the commit
> message. Or make it simpler and start with non-resettable peak file
> (like memory.peak had started too) and see how it fares. WDYT?
> 

That is also due to the limitation that each file descriptor has a single
linked list under cgroup_file_ctx::cgroup_of_peak. To allow for all the
pools to be reset at once, we would need one list per file descriptor.

But, on the other hand, as you pointed out, this leads to the flexibility
of being able to reset only one pool, while leaving the others as is.
Whereas, if one needs to reset all pools, they can use one file descriptor
per region.

I started with a non-resettable peak file, but as memory.peak can be reset,
I added that feature too. If we want to merge a non-resettable support
ealier and need to take longer to discuss how to work on the resettable
support given the above, I can resubmit. But I guess we can see if we can
reach an agreement sonner rather than later.

Thanks.
Cascardo.

> 
> Thanks,
> Michal

[1] https://lore.kernel.org/all/CAHk-=wgiYkECT=hZRKj8ZwfBPw2Uz=gpOGBGd4ny0KYhSsjC0w@mail.gmail.com/

