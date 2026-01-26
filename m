Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03AF1D13C0D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 13:47:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6741A6B0088; Mon, 26 Jan 2026 08:47:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 648716B008A; Mon, 26 Jan 2026 08:47:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54AC26B008C; Mon, 26 Jan 2026 08:47:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 40A006B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 08:47:22 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CAECBBB2A7
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 13:47:21 +0000 (UTC)
X-FDA: 84374241882.05.57693CA
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf12.hostedemail.com (Postfix) with ESMTP id 11C8C40002
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 13:47:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=PTW8Tqhg
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769435240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aa1DMzjW5ihMgg92YYEEvi+hVWZtO1QQ1kl6+AaoZvQ=;
	b=V1WkDgRbxsSTtgC/P/GHpgHqnvL122Y6M8kh1huZSDUUzp6+phf9V5Max0TC/f8IdZtN4i
	0TY+bnMeriDqeLiR02E2SYPLbrWRaiQNk04/6uTGFbIgdz0gAqvnPttzGtK3uMe3ky81OT
	pp398QN+/7ZdXvpIEOgiataeO9U3D4A=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=PTW8Tqhg;
	spf=none (imf12.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769435240; a=rsa-sha256;
	cv=none;
	b=eLqCWF549yP9Adts+jdxIlTsl3J+ntYM862c7yIsH9F9VjGbCSFkqYoNzvTcD4vQF3trpM
	1+WZbSMysw+zJ0kMgwmvV5uyXeUOkqsDMececSE7XNbAyJp/EKyf90JG7IMcMg0oSqevBq
	oFH2sPkKP8kULRrwYAgrCs8w7JhZnLY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aa1DMzjW5ihMgg92YYEEvi+hVWZtO1QQ1kl6+AaoZvQ=; b=PTW8TqhgFvvUWcRC3HJM028fcP
	M7Vxisjv/gGMNmxFO/SLOgwXfepfwBg8TfKn2bhZf1AVDlJkcvSDMbJLwOpj10bTWKE3kluom+K+N
	/L0DHiSRwa7TItLibUQbsjIgw5OQ5QBdu/vN9mLeWAu9Bt2yyDrmdLewyCBzHo1Q9fkJfSQdJfOka
	MCN20eKZFSUeIVHI1U2iyeA/KMrVnyztbocEcxEPWBtKFAZcXb76eg90AIrS+9ZSs2PscROltDqCp
	YsKRS5aiepm+1WZlSQvL1/1oDp0bVAyFumjQytrDAxjxZyw7mUrB54GxuaxhmlLkyF1ke7ddLpjHE
	Ynk/aOxg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vkMvr-00GDT2-Op; Mon, 26 Jan 2026 13:47:08 +0000
Date: Mon, 26 Jan 2026 05:47:02 -0800
From: Breno Leitao <leitao@debian.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org, usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com, 
	riel@surriel.com, kernel-team@meta.com, SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v4] kho: kexec-metadata: track previous kernel chain
Message-ID: <aXdwObCI5z6qbuwE@gmail.com>
References: <20260121-kho-v4-1-5c8fe77b6804@debian.org>
 <aXdTEzsm88JKu9zY@gmail.com>
 <2vxzikcoa4g1.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzikcoa4g1.fsf@kernel.org>
X-Debian-User: leitao
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 11C8C40002
X-Stat-Signature: nbd4hgwfxjtzgng89ytdxnnrxk95hrdx
X-Rspam-User: 
X-HE-Tag: 1769435239-723989
X-HE-Meta: U2FsdGVkX18ifOsnGc0Ddt8mMuEJbNEIzakhgKTlkY3Hi5J/cmc4r3F66+NE3Q1P8i7O3vzVAVZaWpJ3Jx6or5sehMR6giPTl6vdGlvUejxkpZKGnGqmvu86+DFufB6k0jcDAnszg9I7EyLNVy202IliXyDpciIB3y9v5ZcESSA09eoS4t6mlwzm9o2uNFFNvBdW5xXrF4CbEdl+Gyaos3VWBe4Osqtf6Qc6YrsYh8YMBIAUrI9XNqq/Wd++eEITb64nVhBaed8G2jfavKKwuTU8xUUnTKZlO7BaBVoeOfvhw3IOGqouZCkGW88RaA7Vqs2ta+nr7bJv+3q2zcCPYVOokMxDqlviYfxeCFPN5/mPoa2CYITAGdQ9oHLAJk2jVrzj8vBpa88tdXcRizjrGWjcDPCweIRLN/htsl+XvW2ZMx6uLAq5WRK2RJohnUPw+mPAZ6K9LGkq93ZMzo/dmNJKXcqT6p0HrEltVtEjjHX2ejufgExF/IO9dAoMAWnNp7y5Dw7eEx9SzSP8zjotDoxV8Ozbe9YCC1F/PD0YPPDAhGfv0HGHrUdAgyf3jYtB/3OSs5fZm03Pe8FfVk54QsS84KQzH48JM5gfvh9lk/YWhH+6uQcR/wWHg5d4tXVJu5akxBYteVdaNRur1aKQrKT+sVtBpjXutrUceNKP3Th/lsk/j9KkW0iOicMZSpTy1wR9g8xb5NMTdK8IjGPUDmkO30kLU8K/EHeB2/D7xFooyGqXKfC7bwboMI0DYPfB6HHtpXGdgsY4nEEi53Pz5xp9wB2PjQ0Fe8pKxPW2zOc6rn0cjwQg0Z8aWHnOXCVPKvaJHCQ62C0DdMo+oTPPaF+eZybHJo3rGL8bYdoc1lO1EYa3ur/iLltubZ9FrGao8AsHeBxWtF0o7i1vahTJwvw7P9JS5n96qEkU2gN4EoblSfOZimA6FSMzEen6KCcty7lDNF1wKh61IirxTqI
 IaYsbQzG
 jqQwnbePwxfoURxmosQ+qvIAsYOQK17od+/Fo3MXmVz5fDUxYX2NtS5hJXok8c4GcojF+ITZFh7/Uq/lFsRLd0heu9UojaQ3LVB2mjwK/SbLsDr+XzSQshX90L3JrUIsdJ1uB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 02:28:30PM +0100, Pratyush Yadav wrote:
> > On Wed, Jan 21, 2026 at 06:50:38AM -0800, Breno Leitao wrote:
> >> +static __init int kho_populate_kexec_metadata(void)
> >> +{
> >> +	struct kho_kexec_metadata *metadata;
> >> +	int err;
> >> +
> >> +	metadata = kho_alloc_preserve(sizeof(*metadata));
> >> +	if (IS_ERR(metadata))
> >> +		return PTR_ERR(metadata);
> >> +
> >> +	strscpy(metadata->previous_release, init_uts_ns.name.release,
> >> +		sizeof(metadata->previous_release));
> >> +	/* kho_in.kexec_count is set to 0 on cold boot */
> >> +	metadata->kexec_count = kho_in.kexec_count + 1;
> >> +
> >> +	err = kho_add_subtree(KHO_METADATA_NODE_NAME, metadata);
> >
> > There is a hidden bug in here when CONFIG_KEXEC_HANDOVER_DEBUGFS is set.
> 
> Good catch!
> 
> >
> > kho_add_subtree() expects a fdt as the second argument, and we are
> > passing a pure C struct. That works fine, except for debugfs, which
> > does:
> >
> >  1. kho_add_subtree() calls kho_debugfs_fdt_add()
> >  2. kho_debugfs_fdt_add() calls __kho_debugfs_fdt_add()
> >  3. __kho_debugfs_fdt_add() executes fdt_totalsize(fdt)
> >
> > The fdt_totalsize() macro reads bytes 4-7 of the input as a big-endian u32, and
> > this will hit struct kho_kexec_metadata, given I am passing a C struct instead
> > of a FDT.
> >
> >   struct kho_kexec_metadata {
> >       char previous_release[__NEW_UTS_LEN + 1];  // 65 bytes
> >       u32 kexec_count;
> >   } __packed;
> >
> > Bytes 4-7 would be characters from previous_release (e.g., "0-rc" from
> > "6.19.0-rc4..."). Interpreted as big-endian u32, this gives a garbage size
> > value.
> >
> > The alternatives I see here are:
> >
> >  1) Come back to FDT instead of plain C struct, similarly to the previous
> >     version [1]
> >  2) Created some helpers to treat C struct fields specially just for this
> >     feature, and we can do it later if we have more users.
> >  3) Move this kexec_metadata to work on top of LUO (similarly to memfd), but
> >     that would be an unnecessary dependency just to have this kexec_metadata.
> >
> > That said, for the next version, I am coming back to to FDT.
> 
> Please, no. Don't go back to it just for the sake of this bug.
> 
> I think KHO's assumption that the subtree will always point to an FDT is
> broken, and we should fix that. I think KHO should expose the blob of
> serialized data and let userspace figure out what the format is and how
> to decode it.
> 
> To do that, we would need to update kho_add_subtree() to take a size
> parameter from callers, and pass that down to debugfs code. I count 3
> callers of kho_add_subtree() - memblock, LUO, and test_kho. I think all
> 3 should be fairly easy to update, but I am happy to help out if you
> need.

Sure, let me hack and see what I can get here.

Thanks for the direction,
--breno

