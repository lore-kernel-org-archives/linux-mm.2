Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26C8B606A337
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 21:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=fqxpl+kR
Received: by kanga.kvack.org (Postfix)
	id 502416B05B0; Tue, 10 Nov 2026 16:27:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B28C6B05B1; Tue, 10 Nov 2026 16:27:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C8586B05B2; Tue, 10 Nov 2026 16:27:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 226F86B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:27:14 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DF22CC0120
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:27:12 +0000 (UTC)
X-FDA: 85420495104.08.53137D7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id DEDFF4000A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:27:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fqxpl+kR;
	spf=pass (imf27.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794346031;
	b=AYDkT/1D5yGILErp1A/dqlQ15G4JLPer7pUwo5wVy2yWbFQZUkXi2gzWzr5mm5tlZltwR3
	Xl6yMuFbnzTFq+gL1gtknPSisMksLaM1I2xsckI4eaxa86HOpJm6PHbSnUM76ZFB03o5BF
	0va62O5snX9w5WjnXr8uJA1lbyZgXfQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fqxpl+kR;
	spf=pass (imf27.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794346031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5lRnygMPL37LT/U1h1GwWLM1wiQJoQWWISQxj/piPRc=;
	b=daIHgUc1lxomRYH/YGFxAaBJR84qyPx3/yO5neGjz3cvYcOgBOqy9TjimWZOs2v0x/CjVy
	VxmT0MBVMPiFIbtTblANFynr1X58kjGI0sYa686mOApBN6yvcBKvKKZs8ONBdblLg6VTad
	2zTJgfKk6jy/yfxQ1K0OQ5vEH7TIziw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B9A161477;
	Tue, 10 Nov 2026 13:27:06 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CD1F63F673;
	Tue, 10 Nov 2026 13:27:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794346029; bh=sxcPfql1N3xVcqWU8TH8w94Ji0cp6OS4jMxTRUR6E18=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fqxpl+kRaKkn+omwmLFy08Y6NXzhACs9nkKnj+Q8sJnDL6tsD3ekN7gX8l5qIWazX
	 W5YsZ046yWWnKh9+uEB7RzolyEq05SZrLjdpziAXUpV8fS2MvNyORawcRBocGduaIZ
	 ZOc1UTurMRsYhCgJW5pcfmrTtadb6szzQzh/CG4U=
Date: Tue, 10 Nov 2026 21:27:05 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Rik van Riel <riel@surriel.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yuan-Hao Hsu <aa9736195201@gmail.com>
Subject: Re: [PATCH v3 5/6] mm: gup: introduce gup_unshared_pages()
Message-ID: <avOMKWJe3wwNb2sW@e129823.arm.com>
References: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
 <20261109-refactor_gup_fast-v3-5-2aaef02df0e1@arm.com>
 <7627c0d90188b581e7740bf8d17c8dd07b460f89.camel@surriel.com>
 <avLqwIWHa5CAbHO2@e129823.arm.com>
 <aa227fea-d22b-4c0f-bd11-bf9ec36b0767@kernel.org>
 <699499e46ace0875fd0f32052399e665c8209ea9.camel@surriel.com>
 <avN8WISVUF7u4bXl@e129823.arm.com>
 <5db7a358c293393a93984ac3c3cc58e810edd75a.camel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5db7a358c293393a93984ac3c3cc58e810edd75a.camel@surriel.com>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DEDFF4000A
X-Stat-Signature: ge9mxaogx4sa9hwjfnt5sypofomygd39
X-Rspam-User: 
X-HE-Tag: 1794346030-913591
X-HE-Meta: U2FsdGVkX19i1AJ28IvNI8K+x8AgjMo6qznqs3ZvVwXvkH1gvnXb14R6QB//nWhA+Ncx59wPmKeGUXZfJIp7WPY4sUs4Kw+0oRIoGBDGiOF4Of2/uaVKcqDJ0VB3dSBtttJDnExGGYYBNUpMUu3YxS2aBgQslqBB9tE7Sl3co+GnRRZkQUmULIojtCRX6CK7Q5NYphWOOkLmQEBJFbQofQCjsEbK/m3Uz1/gLS7gKiQt3HgX9F96Nx4SNJLYfETly4fpGrZ0Tjc+0aoRVEKRLC8VZkowd3Kqzwuvf3FZpT2524PQRIdOqGwZtuA5c5B1FW65+lE6UC0i38rufLr2Jm+aVvtgO37Ck30t+lYuKpNFPhqYhsGRLS3RffzXoTkf9Tu3jj2pwjZMloDwnNhfDTpBiVfYVRfsuZtGkgCu13rFn+xx6HSGGnnVjpgZhi0czDhp0/k7WRtsJfnaYMRcVpcbEi6EcICx43vGCKYwwaGFFw8AnwHduPTWBrW10Ku1y6it3rd2noHh826sYOgw72414+BLHozRiK/dlGk7Cd4ogC7bxyH8IgAVkWyBP5GxZYgKnq5IczbL6s48WTsmTv10yKXCIjkOjhsjTCdcaTrI7IwhNwTIHLkgASbf5vqVU97XqsMChX93RGUeJEsagrKArxdDylKF3RvvdhJwb17AO2lCj/xaCqs4JhhZyscppVO+UK3+4EAz9bUCJk3aRJz7bBhCSLuJI/7SQqwcrWthu3y1R37Sb1JvG3QBM7cNbU4p6Gt1c8FvPvdlNjfQZXzbng6aFxHTdAfmNdDtnMR9CUadBiFZcfrVsMUJqW/Blz0XMVzb5Q9WeV1gqu3A78WCzsGLea4zNfqHGfvgr4qdr/MYg2hsXyzgd+JL9nSQ62rwpajSYWZw0Y3cRKKIVb12vbpAQUpKsQi+8yuG93k+XQdBBd/vEqvZr4x0DYPZtXGzTEwtNfNAknZP4Je
 n0DStYa2
 YKFVjGMAN7vU9PkflB4DDSfSq/Vvzff25A4l/Y02eypgfQg7XCD/HkJaeG9rn8n3ACnJx/c2XXebcWdblxUYNZLmSiQkQsYgWz3CrulNNpHrKCEyfnySQ7yfd9aPu100E+THLt3B2q4s1EVqOGNQwjqD1tXH6vjdXZOtCeTAq4VP5+AGqOldPIlRX49HakH97pV0oKF402Z5nPwOI1oDGlnWSDu3+zBTH48yzYWDiW/Y4kXlRjydMM5a0ATuG0UwpzCD02GyFbR4V21Kvw2PqhRLEgSM+SyWlyDiE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 03:23:15PM -0500, Rik van Riel wrote:
> On Tue, 2026-11-10 at 20:19 +0000, Yeoreum Yun wrote:
> > On Tue, Nov 10, 2026 at 02:21:18PM -0500, Rik van Riel wrote:
> > > On Tue, 2026-11-10 at 14:04 +0100, David Hildenbrand (Arm) wrote:
> > > > 
> > > > So it's all about "number of pages that don't need unsharing".
> > > > 
> > > gup_no_unshare_len() ?
> > > 
> > > a little awkward sounding, but it describes
> > > what it's doing?
> > 
> > Hmm, Wouldn't this name be semantically much the same as keeping
> > the existing gup_unshared_page(), since both essentially convey that
> > no unsharing is required from GUP's perspective?
> 
> The function measures how many pages in
> this current interval do not need to be
> unshared.
> 
> I'm happy with any name, though.
> 
> I would really like to just see this
> code go in, so I can post my two
> GUP series on top, first the batching
> for the GUP-slow path, and then the
> series that allows access_remote_vm()
> and friends to work under the per-VMA
> lock.

@David, If you don't have any strong comments for original name
-- gup_unshared_page(), May I post next version with resolving other
comments so that Rik's series be posted soon?

Otherewise, gup_skip_unshare_pages() works for me.
-- 
Sincerely,
Yeoreum Yun

