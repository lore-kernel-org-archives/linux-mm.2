Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D26FCA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 12:34:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B91D2900248; Fri, 15 Aug 2025 08:34:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3BB78E01EC; Fri, 15 Aug 2025 08:34:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A03A5900248; Fri, 15 Aug 2025 08:34:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8EE6B8E01EC
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:34:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 410D81D8B2B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 12:34:07 +0000 (UTC)
X-FDA: 83778934134.17.C5B26D5
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1CE8E40006
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 12:34:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pftKXj6j;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="Wo/Zp3I5";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0b6K2XDb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1QhShcHr;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755261245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XbKW3m79yzVvWd4c4oeFxoOPejDr9ro0zvoA9q/+lL0=;
	b=h6Sp3pt7tkaGXkWJ/O8Tuu5JyUpCX9co3ws0XxHjKw+jA84kjR+f3JhrLDrD6fXTdfP82b
	YesrZVY8j1b5u9g01N2OBtC9lIb8vfpvI9YCKTEa9o1W88dsGtbxElTZU5l55raNc4sbML
	Qw5l1WCS+tpd/h27a2BzlX0woNAsieQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pftKXj6j;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="Wo/Zp3I5";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0b6K2XDb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1QhShcHr;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755261245; a=rsa-sha256;
	cv=none;
	b=CB/7kRhsCIxI+s1C7qOxjBqpFsnwqOwuKwZrqIswnVAS3R8bBDwGEij9BL2ok+1quG0VTX
	t5p9Pc+JedOLyzlktM62f5FZKoS05qirsc9cHnd0xbGIEWuKzfZO01V6hu/uKAWrlpBD9H
	tkRIfoRqxSCLLZYqCJS+kVrfFW32JUY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 545001F83E;
	Fri, 15 Aug 2025 12:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755261243; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XbKW3m79yzVvWd4c4oeFxoOPejDr9ro0zvoA9q/+lL0=;
	b=pftKXj6j6PflFjz2In7gvs+RV0Y8qhkGDb6PZ4y7+rzDZrIxXULvojkcqqPh8iwTzEdno0
	t0fkPgA4nkv5qshCOFXPS9L0fwIG+maJ0tAJBrbr3S2Fouy4camlszFTG8rqjB6VERTg6t
	eqGTGeGjoHhl7T695DNEWBJPIjZrprU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755261243;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XbKW3m79yzVvWd4c4oeFxoOPejDr9ro0zvoA9q/+lL0=;
	b=Wo/Zp3I5Sgxy1iMwvGxmiNjWV9Gfgb6MOxL/pPJ9FiTS5D6rmJmYExVUZXvuvJxD/7saaQ
	liN2MD3wVE3KiIAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755261241; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XbKW3m79yzVvWd4c4oeFxoOPejDr9ro0zvoA9q/+lL0=;
	b=0b6K2XDbFirJwyeNjzVe/NtQ2QWdZPG8fwGIo/40zzhCHxFLewXI2GmrpQfPPlaPRO54Ys
	SsiLlTw4OF4g/UkdjoBKbpkZFQGD3NH7KhlvTRQIr51CNqQw5PXa34XFkOasU8H9PD7Hok
	AFfK1Mf76dM/RaMkfPi2uB/OYlr99ns=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755261241;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XbKW3m79yzVvWd4c4oeFxoOPejDr9ro0zvoA9q/+lL0=;
	b=1QhShcHrjb+96XnMqazaYYsnkahj8edGVGHZGhwGL0Iu59wGl7xBM3cbXktVrJpRhaELXf
	B/zOwfneMk60jfDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A137F13876;
	Fri, 15 Aug 2025 12:34:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id R7KUIzgpn2hMYwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 15 Aug 2025 12:34:00 +0000
Date: Fri, 15 Aug 2025 13:34:02 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Matthew Wilcox <willy@infradead.org>, Sidhartha Kumar <sidhartha.kumar@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] testing/radix-tree/maple: hack around kfree_rcu not
 existing
Message-ID: <fcbr3lvd2aa6m4cjl666ksbf5px25htnh5slahj4pk2id54ygn@llqqfn5urq52>
References: <20250814064927.27345-1-lorenzo.stoakes@oracle.com>
 <kq3y4okddkjpl3yk3ginadnynysukiuxx3wlxk63yhudeuidcc@pu5gysfsrgrb>
 <20250814180217.da2ab57d5b940b52aa45b238@linux-foundation.org>
 <wh2wvfa5zt5zoztq3eqvjhicgsf3ywcmr6sto2zynkjlpjqj2b@bt7cdc4f7u3j>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wh2wvfa5zt5zoztq3eqvjhicgsf3ywcmr6sto2zynkjlpjqj2b@bt7cdc4f7u3j>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1CE8E40006
X-Stat-Signature: x5f6m6uy4q5bmxhco4g4omxyuhfopbtc
X-Rspam-User: 
X-HE-Tag: 1755261244-971475
X-HE-Meta: U2FsdGVkX18ncNVBV+GD9+Oxs7HuwEde3dwCU1oAhux1pvqrtBsVrQYgJUsv2xIGGz+SwSmfIGHDfOW0b5SDx5yAKDAN1g8pMtb+JASq6gfYcpj97MVnG4026gSBSYGtlpb+qsdmFELWrD7e8MsxMju0nej7KQ2a5Wxq8bFniAj960xjYtK61n2VuFry4adMRw5FhHbBX/oGEDpekGO96osP8ud8bJhlS/vHwKMclfh3cm+rMdJsuAbClMT5n/1tCo/fFacBU1eA4W9CHsON59QoEXuonXOYQYocakYSjhZ1mGqhg0tCDX8cOBOzvBN07B5GwkxDGDFvqXXcRpPw+EVmFolZ7Z+kkQUyDBW9wG0har/ricgaKVQjH0YuNgJNgBROQBD5yVec1Ufl1md8G1P5FSQ8Z+3ppkMOAHb7ISl5m3Bdg25gIBn/nsyC9LpBMa2oHrM5IOx2b7Brggm51u7pWckKXKnxZmL029C33FoDphOENiSqpw4FdzWDTMoL/k2jV/dAmPJ+j8CkcvEyVCC+nRuph9f8SLz3TrZzBp3ptu7MoMRUCn7v8TLgNFRU95fPxpxkjXv0lk/cTkPDr0pExP5U4UMvNDM13PPHAXUnD+gxvml8JSSzLLAAkOohpvuFummJ0Nowz8nTsnVlgmf5S2FHWPdXAxK+1XmGrxhWBuuOSlkcz7+OgmDwNNyhN5HO+u35rfO7w6zk22qlQoBTRACY4OtPrO+HgwjageSdIlarpATfkiqzVVYA9oj5oPmy7G73BR6kxAyt9g+WwYxJQXHZf2qkvWxo/jDLxYuwi9sw5voq1LGnBkp1NMYvf0iVBD1VPhvTZ+zlCSTQ1k7hjPZafH6hpEOmhuwgz7KAmzjcCVPuuJCCjewOt5OaMG00O7N+zSYLbfQaiLtnpG9d1uM+Mr8Sik+nzbPwkIF/JB9so44UihCywt/gzOoIBtAuMDo3CkNdTGSX+Pi
 d+WfNms+
 UWjqqtnP0QXMRdZwCwHOoW16Xod6fCopQWetJURI3UCVKw4ZZElR7M13vLJubUc1JOrCVsJ/TJ6Dul0UJVqSl8y5Drcn/w4tyxKXLw9PzvTy5/QMybFk1lcWAyjPF+2p+C/dNnNeRfcv5vD6gSLeM2xQIuDNxx2zfNtRbUEO/YWlozcDcZ9ykjFgiEwcl55Yez+xjKVBofbV/bClTfORkwRDKqN/PTBqBCH/YWbiUFGApI2ANyhiyOExVYWOAZmAE5/qCE6TTCEOCTAX+jqfvlmr7veRKN7AqcqCDE68UA6MADUwQ9e+u0B7O2ZnYGPfNTTxvJUVX6Lew78X4zA2t0f21fJmq6ZXXnu4Sa9Vlexpb3XAQjttWdbqgJrpStZ+qRMHCp4jDeoBz1JANoaNjnYQBwPrc/ZdCOvo++lyDaDzee/1gA6z68SycFw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 10:09:15PM -0400, Liam R. Howlett wrote:
> * Andrew Morton <akpm@linux-foundation.org> [250814 21:02]:
> > On Thu, 14 Aug 2025 13:40:03 +0100 Pedro Falcato <pfalcato@suse.de> wrote:
> > 
> > > On Thu, Aug 14, 2025 at 07:49:27AM +0100, Lorenzo Stoakes wrote:
> > > > From: Pedro Falcato <pfalcato@suse.de>
> > > > 
> > > > liburcu doesn't have kfree_rcu (or anything similar). Despite that, we can
> > > > hack around it in a trivial fashion, by adding a wrapper.
> > > > 
> > > > This wrapper only works for maple_nodes, and not anything else (due to us
> > > > not being able to know rcu_head offsets in any way), and thus we take
> > > > advantage of the type checking to avoid future silent breakage.
> > > > 
> > > > This fixes the build for the VMA userland tests.
> > > > 
> > > > Additionally remove the existing implementation in maple.c, and have
> > > > maple.c include the maple-shared.c header.
> > > > 
> > > > Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> > > > Tested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> > > > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > > ---
> > > > 
> > > > Andrew - please attribute this as Pedro's patch (Pedro - please mail to
> > > > confirm), as this is simply an updated version of [0], pulled out to fix the
> > > > VMA tests which remain broken.
> > > >
> > > 
> > > ACK, this is fine. The future of the series is still unclear, so if this fixes
> > > the build then all good from my end :)
> > 
> > Well, can we have this as a standalone thing, rather than as a
> > modification to a patch whose future is uncertain?
> > 
> > Then we can just drop "testing/radix-tree/maple: hack around kfree_rcu
> > not existing", yes?
> > 
> > Some expansion of "fixes the build for the VMA userland tests" would be
> > helpful.
> 
> Ah, this is somewhat messy.
> 
> Pedro removed unnecessary rcu calls with the newer slab reality as you
> can directly call kfree instead of specifying the kmem_cache.
> 
> But the patch is partially already in Vlastimil's sheaves work and we'd
> like his work to go through his branch, so the future of this particular
> patch is a bit messy.
> 
> Maybe we should just drop the related patches that caused the issue from
> the mm-new branch?  That way we don't need a fix at all.
> 
> And when Vlastimil is around, we can get him to pick up the set
> including the fix.
> 
> Doing things this way will allow Vlastimil the avoid conflicts on
> rebase, and restore the userspace testing in mm-new.
> 
> Does that make sense to everyone?
>

I agree. This sounds sensible. I don't think it makes much sense to let the
patchset rot in mm-new.

-- 
Pedro

