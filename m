Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0393CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 08:44:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC11F8E000A; Thu, 23 Oct 2025 04:44:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C71588E0002; Thu, 23 Oct 2025 04:44:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B391A8E000A; Thu, 23 Oct 2025 04:44:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 985468E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 04:44:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 203E0160A7F
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 08:44:51 +0000 (UTC)
X-FDA: 84028743582.04.B6F6646
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id CE52B140002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 08:44:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=k6mnvdMx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EXhO1lOU;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="ruW/HzMQ";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/Z7/KBwY";
	spf=pass (imf26.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761209089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uT++X15nR02aN95TsJbUkl1xeZRDQ6iRqUBMrz4vKM0=;
	b=xDsgcWQZqdLkAPba3uSKTPVyNuVkiEZuSP0kKEpTGn9ogPq/xdWfLHp+SUMH93mi6smxyC
	LRzf22W4Eas5aoUIpGRh4n3QtsSc0UMEinxdLILrVb5bO4h4n/Oxwhgx2I89y+EezrVHZM
	YnseekpHQ2ZWBpbMtFP4+oeoNm5l7Rk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=k6mnvdMx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EXhO1lOU;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="ruW/HzMQ";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/Z7/KBwY";
	spf=pass (imf26.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761209089; a=rsa-sha256;
	cv=none;
	b=hijP8h33AegAo060zNSd4Xv5jQuMZxgZWUFZ5lhr3zAhXqeJDMhKqi5WVFS05i55bIkrDK
	zdS664ZgzfbmZYcRHMDLktyg58pqoKlVNc4q9vq/iic0svLvzvIK165Gsn1jFljuxq0wH8
	4JtZlxrSPgvNvHa/wt+OR78dTSEtq7Y=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9B9691F750;
	Thu, 23 Oct 2025 08:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761209082; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uT++X15nR02aN95TsJbUkl1xeZRDQ6iRqUBMrz4vKM0=;
	b=k6mnvdMxOOpSPNL5d2igOGf95Zo+FrXzFx+SdSmGphG+ZFzpd7WoJd0t7wSiq6uGgzzaib
	2RS6jcTkrBE92rra2+lLDAPXeti6l0f2JC1lX3OWZHpALMR4MvykmNvGU93fcQqeJ7cd76
	vUDd+XLiizeNFG3q0FPqiJqFppDy+a0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761209082;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uT++X15nR02aN95TsJbUkl1xeZRDQ6iRqUBMrz4vKM0=;
	b=EXhO1lOUUuQqZySuP3Sw8w+L8D1JUVHgTaNZ0BYilxnYXBf107whjOnl85sLulm9H32B2T
	XzhJmc1lXOv0y7Dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761209078; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uT++X15nR02aN95TsJbUkl1xeZRDQ6iRqUBMrz4vKM0=;
	b=ruW/HzMQZkLDzw9pPT9qqsgQ0l7ce1+1ZbobIqtCys0ORZcwxiPtXlWRt+qmWhfYSA2/ZJ
	zal2xGJmEwKqxFVE5MS/6yG0/txhoZiFetZx8kukJC6lu40r9XguMB67JzdwxUi1nAWJuZ
	EBtVK9GjJCJgcJVauxDyEq6BJ65mROU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761209078;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uT++X15nR02aN95TsJbUkl1xeZRDQ6iRqUBMrz4vKM0=;
	b=/Z7/KBwYMiXRHJ6O62WTvJZr2cvlPQQC19KsgBcotqbmmsRxEzzGPTZl1eTKfPtYeZOtH/
	Zs0dyQyvMc5H0ADQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A9F61136CF;
	Thu, 23 Oct 2025 08:44:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fiJAJvPq+WhuFQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 23 Oct 2025 08:44:35 +0000
Date: Thu, 23 Oct 2025 09:44:34 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	David Hildenbrand <david@redhat.com>
Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>, 
	Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, baohua@kernel.org, 
	willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com, 
	usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, kas@kernel.org, aarcange@redhat.com, 
	raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com, 
	tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, 
	jglisse@google.com, surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com, 
	richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, 
	jannh@google.com, Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH v12 mm-new 15/15] Documentation: mm: update the admin
 guide for mTHP collapse
Message-ID: <c62m3tyr6co7jqdrwhtp7exnewhogxtife7g6yh4gve7gqecz6@b5xpocyvifxp>
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-16-npache@redhat.com>
 <bba40f08-1b87-6b57-0e10-6e96e4d7bde6@gentwo.org>
 <ed0887eb-6124-44ab-9d1f-1e87e9640e14@redhat.com>
 <666ee834-396d-4a7c-be89-96c58b5c2ea8@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <666ee834-396d-4a7c-be89-96c58b5c2ea8@lucifer.local>
X-Stat-Signature: zaay1m3jawerdjjtjahoijxmtgepiqof
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CE52B140002
X-HE-Tag: 1761209088-551105
X-HE-Meta: U2FsdGVkX1+V/NcBSdTJJQ0PKzw/Qt45OtR3wd4KKUynRpZPNbKrKF13pP4iEJeVzPn48HJImYfBjt1DyFMd9THIebmOqGIbouFrZ2HVC0xoCi9BsFQ+JI37kjcTEdi72gj5GQeAoOc2idsF5/V4Yo/9jT0vZfW3NtupoSxU8L9G4D8iVMPHmJfxT3su+EpyxQoOMQJ2eFC1Bpehy5e9HfL7CEYs1WlGqjCucjHnY+Ej2HMheMX/yvwAsxgMhevOdBoxjsT+XxoAOsBLrcnTBMfmsGwbVvNzXOInFh4JBUM++iRCO7E61Cv1ici8Om9WbEEvSIw4SAsPCWBcyw0i8FepK4uA9+QyfXZhp5MTdEyMjHfbgqv5UnmgaL16GF4hW3PNomAMaVqANiJTWOkRF+43ButHCtd4xZlWrbQoLS8ouq3LWY/tT1t4XIf7f/uMv3aBtkKQrGUDTw3iA5un0ZyWMBz/F3LUR8nDPW93Ki1MxKKwG1BsXX4q+k9BdLUPYqcr2tzJz7nxcpbPO2Y0JFOxJ3LuTCvqLVN/GvWNiucNzcRa6VaEoUUsDnU9W/h5GaYCjXNMfox7Z34TWW7PYfsfhUhRXm1ohyOlpja5WB5pKNlUwsjkpQZJzRIODivJ5pPBRaUDPF14nT2ZWicIsdNyfqeUJFuR0/dP83fUTxkOO+qIZ5ezhmJGazZ4to9muObxLF42WjXAdkJLSrYr7XYMNKiFiMVtcaXl0grn2R9bGzHJHOjbVgiQ0ndOWpN5E7reTrULbIzSROKsNMBTRR5i+k1wNWVh+wW02M4R+9A/L3ViEj1GApPWdNiHhr4XS/sdvLG1Ds9MalPAh5zA3xSLVw98IRN5Tyy1+xSclxYX/xexi11HGV2E7E8NC2eLHTonrsY7RKiiqncJVLflq/z5XmN9WMweyvFN302HiJ3nJfehun1HVOTXlGa+Hl2l2bMbsLUGmaNKOMrwKmQ
 /5dbhqC6
 yd0WWPrcMITxXpj7ZHhMhA05fuj4TCqMt7UziIAUDw8O5J8iShPMRbzhzRWR6+vWizGCTkpYbT0BqzwatCFxV+I2T6VRsOEhw5ZuPhfzo8MEQ8Q6MDZvR5MyJNLPgo3Ker4nzcW8aa7FKsiSgWLNzh7jUW3oJ0WTbUNiTrHWUGbg1Hu5Gx41QhRxvi6uvexRrxMZAcCUDMilBmPsoqacJYAeB/G3lvFYK/1by+uiL8ZVM7DUiU4bgd/5FqxJlMKTO6yrbVczKRW+kGRbQolXSTIH0+bM4YtlPNb7ugci/dGzUo7ZNpmXmys5AbhZgDUTyvikjKJT+oqx2u9XDbmv8Xv7arjb5Y6GTxLVBxDxqSboLWIrZu4/Z6hKZEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 09:00:10AM +0100, Lorenzo Stoakes wrote:
> On Wed, Oct 22, 2025 at 10:22:08PM +0200, David Hildenbrand wrote:
> > On 22.10.25 21:52, Christoph Lameter (Ampere) wrote:
> > > On Wed, 22 Oct 2025, Nico Pache wrote:
> > >
> > > > Currently, madvise_collapse only supports collapsing to PMD-sized THPs +
> > > > and does not attempt mTHP collapses. +
> > >
> > > madvise collapse is frequently used as far as I can tell from the THP
> > > loads being tested. Could we support madvise collapse for mTHP?
> >
> > The big question is still how user space can communicate the desired order,
> > and how we can not break existing users.
>

Do we want to let userspace communicate order? It seems like an extremely
specific thing to do. A more simple&sane semantic could be something like:
"MADV_COLLAPSE collapses a given [addr, addr+len] range into the highest
order THP it can/thinks it should.". The implementation details of PMD or
contpte or <...> are lost by the time we get to userspace.

The man page itself is pretty vaguely written to allow us to do whatever
we want. It sounds to me that allowing userspace to create arbitrary order
mTHPs would be another pandora's box we shouldn't get into.

> Yes, and let's go one step at a time, this series still needs careful scrutiny
> and we need to ensure the _fundamentals_ are in place for khugepaged before we
> get into MADV_COLLAPSE :)
>
> >
> > So I guess there will definitely be some support to trigger collapse to mTHP
> > in the future, the big question is through which interface. So it will
> > happen after this series.
> 
> Yes.
> 
> >
> > Maybe through process_madvise() where we have an additional parameter, I
> > think that was what people discussed in the past.
> 
> I wouldn't absolutely love us doing that, given it is a general parameter so
> would seem applicable to any madvise() option and could lead to confusion, also
> process_madvise() was originally for cross-process madvise vector operations.

For what it's worth, it would probably not be too hard to devise a generic
separation there between "generic flags" and "behavior-specific flags".
And then stuff the desired THP order into MADV_COLLAPSE-specific flags.

> 
> I expanded this to make it applicable to the current process (and introduced
> PIDFD_SELF to make that more sane), and SJ has optimised it across vector
> operations (thanks SJ! :), but in general - it seems very weird to have
> madvise() provide an operation that process_madvise() providse another version
> of that has an extra parameter.
> 
> As usual we've painted ourselves into a corner with an API... :)

But yes, I agree it would feel weird.

> 
> Perhaps we'll to accept the process_madvise() compromise and add
> MADV_COLLAPSE_MHTP that only works with it or something.
> 
> Of course adding a new syscall isn't impossible... madvise2() not very appealing
> however...

It is my impression that process_madvise() is already madvise2(), but
poorly named.

> 
> TL;DR I guess we'll deal with that when we come to it :)

Amen :)

-- 
Pedro

