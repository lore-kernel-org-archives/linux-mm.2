Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16800D58B00
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 12:34:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 239D06B0005; Mon, 23 Mar 2026 08:34:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EA6B6B0088; Mon, 23 Mar 2026 08:34:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DA396B0089; Mon, 23 Mar 2026 08:34:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EDCBC6B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:34:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 839DB8CC48
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:34:38 +0000 (UTC)
X-FDA: 84577271436.15.BFFE2DD
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id 324EC140003
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:34:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VzyQgwbA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HxvqmIAn;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VzyQgwbA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HxvqmIAn;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774269276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZdNNH7au6ltF/SZ+K1zWQ6GN3VdtssM1QzfSfydjals=;
	b=cdkk+xKi8cR6fgolcAU+wBjfAL+sfdEiBPesGwoX/nst6bqjGkBcrXQgavCuOxbNNmyh15
	gGCWnCbclCmBmxvA+2Laqf5PuULys7selaNIs27oJd/kQl9HTHetNXunviQAw7PXzebdhg
	l5pZgRyE7hIKFaTvtQv8wlk7fuR01dw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774269276; a=rsa-sha256;
	cv=none;
	b=5S1ycDTb45FKcWmvxf6pvUnecv8e9JoN3vHB4py8aXqrWF+vw4miiRfVqaG7xQaFBqBD//
	EiR41exjYxMwQpmDvpuh/U6vtxXVhaNa+5EVjz/KTQ5r3lEk6ACbJLedWGmFPN/L3Th7lN
	1S6NdeptrRI2nl04GME+sywuTI3sSB0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VzyQgwbA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HxvqmIAn;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VzyQgwbA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HxvqmIAn;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 794A64D236;
	Mon, 23 Mar 2026 12:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774269274; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZdNNH7au6ltF/SZ+K1zWQ6GN3VdtssM1QzfSfydjals=;
	b=VzyQgwbAjpuWBPOpi3+vXrt1HKUbmXOyYucXWQJgt3kPZUCtRIDi5V2+75UvOmS54jPvsl
	sNr23y2ZQoF/X14UARjnpLHxyJnHMH5gW8m83KD6mbqNpF1ABmPGl2VzkZoZNUeshjxiQU
	Y7bdYK7ujwideYFz4xyDCS0AmoUr7O8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774269274;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZdNNH7au6ltF/SZ+K1zWQ6GN3VdtssM1QzfSfydjals=;
	b=HxvqmIAnhLrq7RRuHwdg29yPSvEbLtigopB8cD3C3gwsLHRz0MlAEtkNrpgZSHbPNOjyWq
	B0uw+IU2XoObTxDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774269274; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZdNNH7au6ltF/SZ+K1zWQ6GN3VdtssM1QzfSfydjals=;
	b=VzyQgwbAjpuWBPOpi3+vXrt1HKUbmXOyYucXWQJgt3kPZUCtRIDi5V2+75UvOmS54jPvsl
	sNr23y2ZQoF/X14UARjnpLHxyJnHMH5gW8m83KD6mbqNpF1ABmPGl2VzkZoZNUeshjxiQU
	Y7bdYK7ujwideYFz4xyDCS0AmoUr7O8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774269274;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZdNNH7au6ltF/SZ+K1zWQ6GN3VdtssM1QzfSfydjals=;
	b=HxvqmIAnhLrq7RRuHwdg29yPSvEbLtigopB8cD3C3gwsLHRz0MlAEtkNrpgZSHbPNOjyWq
	B0uw+IU2XoObTxDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4171A43896;
	Mon, 23 Mar 2026 12:34:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mLWPDFkzwWmjJAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 23 Mar 2026 12:34:33 +0000
Date: Mon, 23 Mar 2026 12:34:31 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] mm/huge_memory: refactor zap_huge_pmd()
Message-ID: <j6hsn4mxnzoukebcdggu6ojkyaj54joohocbbkrzksm47km7ni@zzp7aurwmto7>
References: <cover.1773924928.git.ljs@kernel.org>
 <20260319200917.ce345a369d035050b6329ac5@linux-foundation.org>
 <87tsu9kgv3.fsf@linux.dev>
 <20260320203311.715ed75bcd84c18d24894324@linux-foundation.org>
 <20260321171530.8b3e8207f89d5a7384b9f01f@linux-foundation.org>
 <5cd57c69-7193-422f-b6b5-75bb5234e5f3@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5cd57c69-7193-422f-b6b5-75bb5234e5f3@lucifer.local>
X-Rspam-User: 
X-Stat-Signature: 9nyws5x81xc9nutk8yt7eo64c4ch4n35
X-Rspamd-Queue-Id: 324EC140003
X-Rspamd-Server: rspam03
X-HE-Tag: 1774269275-328435
X-HE-Meta: U2FsdGVkX1/ddUiQgQxPDOs9hbNLznseQP5D3OBWt60IQJH1FsNs2epTqfhdFiNhjrTwvvSrDhuCPKzt5iJAEGq8rleElEMQaLUyn9CY3hLoAL5gHlZ2yQig+tJUORpCztOk0hLYdcTnvm5VcWnoe1PQkYjWjSYpe0sWuHQmTLweb6gCtwzgntEI0bB2bkl7sGjzzOmbXy2Ey13q14p9IPKP/08/AcnRo+9HHnBgTCq5Esy/ntq45bFlVBbeIYbHAEfF1gJDKvNApB5ArCTmln1ng9lBDdkB14AY+X5Afw3MvhLDNPlklX5yZZq3ZstGCLrvf+WK/WX+pjb8/Kd6UtQaQgfuV+kv8pbCbYvBEsWqpDg2JPsXUK42fRbG60DIKufgqlppAO2AC2lmU3o6UWv6wzP3BPnDGfM6geSQF4X1lrtcB6zYXCOpo6AMZz1NmI2ynqwgAHXkfoooY3SSBVjzRr57f2gjcwo9ff/93+2omYKKkVvKxzAkK9MTJrapd+vlgvB5y1ZJJMMCoJ62PvAhxZvOpGCnLbHDI48FcuFOK2HS3REKhGm9HqSdALPV8TIKXrKDGIW20UJw95AIJr9afX0vBQzO24jHJrpmP5YRrq63c4keojba95kJm27q5IypVPDD6ZnDt8SN/otzrcEzdQEg9dPShcEyEg4ClCVSf8uvu3N2p++Ep8o8TwQbZN3Xj7Y59MsbhGLPwx2C45eR5ZpUfGtGXfmxJgqGnOzZieqXr6ZUTKGRQCtC20IiN21x0Bu+uNHnVu+/ZeXB+hz3XJNKvB6vudJ0CnO426TQMKy6rbUfPEiXt7RrmuLVqwoc2+sYmLrqeroFXVGydAZzZqdPLfbN8W3ox9p4XtHdHshoMANAM9qKv8I1QH/r6VZ/AWLmoQYsHyD2b4dBOjgrdxPXzMs04YPKL8ZzStgaM+FhrRDkaciBM69JzBH60lWFAq1qU8kQFAvLraR
 I6/EDqdK
 hbDhjuJxzGBw70/fA689KsWdoj5yGfkFEZ362NcCGMYjfnYDHzfJLvKmcxDmt046ZaoDo/RaxSsvheRDW6k5SU6QCW5FmkUoIrX0GOB8oTAS9Vtk85TCo9cAiigr2aFMFOYzQQs+iMJNZcvxfmEZCzzv+EZiEJ6eZDpGTKwGqSIpYEJY5y8+5JSHihoowm890H4v0UY0LOxAlmUXZirukoyY98OtGCi34Cm7ntwemE/e1IdPKUFEGV72fcbaYK/Bi267Gzyv30vrJfnJZa/M5KJlr2sbzNlRFUPqjG4pn++oGRImk7VT8Gjx/IKFM4qlR0jML+PaIpTeiTKsYM5JbGhHQ/iIggxkaECEst5ea/LLHkmUuQ4sOCz3YmQzllnJHbRjJnaBzepiynbEQLS2+PFWcXhKCMpWAbvMX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 11:31:29AM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Sat, Mar 21, 2026 at 05:15:30PM -0700, Andrew Morton wrote:
> > On Fri, 20 Mar 2026 20:33:11 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > > A lot of patchsets are "failed to apply".  What is Sashiko trying to
> > > apply MM patches to?  It would take some smarts to apply the v2
> > > patchset when v1 is presently in mm.git?
> >
> > ?
> >
> > The way things are going at present, I'm just not going to apply a
> 
> 50% noise vs. signal?... maybe wait until we're in the 9x'%s?
> 
> > series which Sashiko "failed to apply".  And that's cool, I'll just
> > wait for a version which Sashiko was able to apply.  And then not
> > apply unless all Sashiko questions are resolved or convincingly refuted.
> 
> Andrew, for crying out loud. Please don't do this.
> 
> 2 of the 3 series I respan on Friday, working a 13 hour day to do so, don't
> apply to Sashiko, but do apply to the mm tree.
> 
> I haven't the _faintest clue_ how we are supposed to factor a 3rd party
> experimental website applying or not applying series into our work??
> 
> And 'not apply unless all Sashiko questions are resolved or convincingly
> refuted.' is seriously concerning.

FWIW I wholeheartedly agree. I don't understand how we don't require proper
M: or R: reviews on patches before merging, but now out of the blue require
the magic AI LLM thingy to review it before it's merged.

Like, sure, sashiko can be useful, and is better than nothing. But unless
sashiko is better than the maintainers, it should be kept as optional.

Seriously, I can't wrap my head around the difference in treatment in
"human maintainers, experts in the code, aren't required to review a patch"
vs "make the fscking AI happy or it's not going anywhere". It's almost
insulting.

-- 
Pedro

