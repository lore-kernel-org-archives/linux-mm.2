Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98409FD9E0A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 21:22:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBB7F6B01F0; Thu, 26 Feb 2026 16:22:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B68FC6B0209; Thu, 26 Feb 2026 16:22:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6BB46B0255; Thu, 26 Feb 2026 16:22:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8FFA66B01F0
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:22:15 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 429D0160232
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:22:15 +0000 (UTC)
X-FDA: 84487881030.07.D64FA53
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id EFE75A0011
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:22:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772140933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ePX7B57+99lriMffUyBNaGW/GrNI7oq+UA3S5TDmNfk=;
	b=CPdAC1az8CjfYfa86RUE1fxckEAolYDyhgM0GU8fZnduSSLSNc80V2z1Om+Lv9PoySquc1
	MSEwwGb2czvkLhNdhox6IbqgceqeiVS6o8cLFi5elY2yyN2nzwyEw9VmASCRDsJ/EYOiKT
	H+HXZRjTZf4kxUXrXzK2gjXrg4TyBRw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772140933; a=rsa-sha256;
	cv=none;
	b=78xNHASqYAp+zSWeaYvWsbya99xlVX7zTCDfr5adrm/tr4KLm2fZRCX7Sr8orkecSwtS+o
	VZK7SqoMYgO/+MMANY+pDCURxcbd8r7EXjpVWew76V6QTiSnXCwuauvOVgHcxeGH9+mzo7
	1oHV07Q7hja6hH9o1Op4P5lyCeLGzuI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6E4A24E2DB;
	Thu, 26 Feb 2026 21:22:11 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 25AC63EA62;
	Thu, 26 Feb 2026 21:22:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CH6xBYC5oGlMRAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 26 Feb 2026 21:22:08 +0000
Date: Thu, 26 Feb 2026 21:22:06 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Kalesh Singh <kaleshsingh@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Anthony Yznaga <anthony.yznaga@oracle.com>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	andreyknvl@gmail.com, arnd@arndb.de, bp@alien8.de, brauner@kernel.org, 
	bsegall@google.com, corbet@lwn.net, dave.hansen@linux.intel.com, 
	dietmar.eggemann@arm.com, ebiederm@xmission.com, hpa@zytor.com, jakub.wartak@mailbox.org, 
	jannh@google.com, juri.lelli@redhat.com, khalid@kernel.org, 
	liam.howlett@oracle.com, linyongting@bytedance.com, lorenzo.stoakes@oracle.com, 
	luto@kernel.org, markhemm@googlemail.com, maz@kernel.org, mhiramat@kernel.org, 
	mgorman@suse.de, mhocko@suse.com, mingo@redhat.com, muchun.song@linux.dev, 
	neilb@suse.de, osalvador@suse.de, pcc@google.com, peterz@infradead.org, 
	rostedt@goodmis.org, rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com, 
	tglx@linutronix.de, vasily.averin@linux.dev, vbabka@suse.cz, 
	vincent.guittot@linaro.org, viro@zeniv.linux.org.uk, vschneid@redhat.com, 
	willy@infradead.org, x86@kernel.org, xhao@linux.alibaba.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, 
	Isaac Manjarres <isaacmanjarres@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	android-mm <android-mm@google.com>
Subject: Re: [PATCH v3 00/22] Add support for shared PTEs across processes
Message-ID: <5tdailzxoywzzunbwhtlk4yjfmzunntniqtudkb52q6hib74ql@oq4mi226dedv>
References: <20250820010415.699353-1-anthony.yznaga@oracle.com>
 <CAC_TJvcaJdEzK8n9BK0qgEXdzjzXtbA_Zk-ybfmG8kjNExVCzw@mail.gmail.com>
 <b82a5ac3-33e9-4cbf-892a-f0c7f6fe0c20@kernel.org>
 <CAC_TJvdgvyjyJsU4v6W+3tHKx_2e8UMJU3RT2HKLSngcC+yH3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAC_TJvdgvyjyJsU4v6W+3tHKx_2e8UMJU3RT2HKLSngcC+yH3Q@mail.gmail.com>
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EFE75A0011
X-Stat-Signature: be96gst3teywx5j71kc57treq4t4spph
X-Rspam-User: 
X-HE-Tag: 1772140932-501949
X-HE-Meta: U2FsdGVkX195EvRxq27ftsstRG8kzP7t6JXRjg6pl9Lkv7+rYV66vjAn7OvySqU/us4rbFWADVAjCkC4cmkPZULlrq73rzi/SUBF+aUIeJ7Mf24HEOJS/G4Le/5ph2m20CXB/x5EsnilsivSI3mfg1MD57omhoDqkTy0GHQwNOVRASHnPTV5bpX7CjY+jth760UysV1wTdPJIeDwF86ouda3n0Id0pkZzqj/HRzs/pAtu0sYGM0MhKXzRI2iHgeeAk64xO7Q4S4PnYvQZptjRtg2dkboRRpdPXZ3shBB2Xce5CdgHJ0hgrjJHHWDrtywldGXODz85+Mc++xvUl8zcSadYiEH8c1fcHFDwueLMOxoWgGbNWIddtJDtZzClcBa4tVIe+8mj6XJD+PnChfYAS0y+1TZIF3uTbzbyhE3/D6mQVau0jpAKeiIa1rAF4NPtSe82/7JIHLcq0Xj5dyIT4tc8ytXldr5op/BnAODEp4w5BfTu6Qk+40BOU2J4Z1Kjo+aiiz6ThkRVuWtHT9r9MdZ1EYC7oUdzZcolsIjDqaT/lIBDg9bxCF9oQI+SYLStevzAf7ZnQwNK92vvdcm8OkXfQmtLtPc5ZqKU40RcWeQbb+jnwVI02aGuFRlQ/pn8wdru09Ok/Kw7oHyWvVQNtLaPdkuJJ+ecAPlHSZb/72phyzsyE0R0rcuab4FUFngsop+trXCCodOR+myFPe14kSw4S144rnu5Pkh1HELbis3kvQA6WiWqTRcVRfBKJ1yP8SAQ0oP9py/xl3wjxNrlYuvOvIgOqXNit3YNyx8K/2upEfHLprCVYjEtjoinLmQt98vBGnBwWjPOAdjda5MeEspmOJNXOARnrgGKQKKL6tsGLEV2PQP9OHJyQ2693WMHv3ueo3i1rWyE6ez0AFxsWULouC5rJSV1U9aJUNNU0+eRMH5Zs0ORMuCOrn//n76z+ojKhwHUXwgxri4o+r
 0DuUmfNZ
 Io4FcW+51wlM+WCzphPv6nqQtefUxshhXxNmz9KUL9pz1hFYiHhsZRMOy2JcNjnRJAtKFQq4I5/P8//W3kY7f5FCMbaUPx2YgEQZYPrB2znjBOYyYBeuHrDct5n7dEYB7VWNY9ODCpOST8szlzT/eV+6Qa1MgwFM+SXiqgoTgKB3/dcaezBO5mRmWtbRmp6t+KClYNLxCliZ8ccNqaeTV0rxuqWk3WyXKNGYkhWDSFVPaksut74M4g3KnIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 03:06:10PM -0800, Kalesh Singh wrote:
> On Tue, Feb 24, 2026 at 1:40 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > > I believe that managing a pseudo-filesystem (msharefs) and mapping via
> > > ioctl during process creation could introduce overhead that impacts
> > > app startup latency. Ideally, child apps shouldn't be aware of this
> > > sharing or need to manage the pseudo-filesystem on their end.
> > All process must be aware of these special semantics.
> >
> > I'd assume that fork() would simply replicate mshare region into the
> > fork'ed child process. So from that point of view, it's "transparent" as
> > in "no special mshare() handling required after fork".
> 
> Hi David,
> 
> That's agood  point. If fork() simply replicates the mshare region, it
> does achieve transparency in terms of setup.
> 
> I am still concerned about transparency in terms of observability.
> Applications and sometimes inspect their own mappings (from
> /proc/self/maps) to locate specific code or data regions for various
> anti-tamper and obfuscation techniques. [2] If those mappings suddenly
> point to an msharefs pseudo-file instead of the expected shared
> library backing, it may break user-space assumptions and cause
> compatibility issues.

I'm not worried about transparency because this is not supposed to be
transparent. This is not supposed to be used by most core system software.
This is supposed to help replace hugetlb page table sharing.

Transparent page table sharing has other constraints. I like the idea, in
theory, but there are a number of constraints that make the idea unfeasible
for now. There are a couple of problems we need to solve first:

1) Every spot where we modify PTEs needs to be assessed and use different
helpers (that can un-cow page tables). Every pte_offset_map_lock() can now
feasibly fail for OOM reasons (and that also needs to be assessed).

2) Various bits of PTE modification/unmapping now needs special care wrt TLB
invalidation. The kernel needs to be aware of how the page tables are shared.
I don't think the current rmap data structures are well suited to this kind
of stuff (perhaps with Lorenzo's WIP anon rmap rework we'll get something
better). Basically every spot that goes "modify PTE, flush TLB for mm" now
needs to go "modify PTE, for every mm that maps this page table, flush $mm"
(if you're thinking that COW will save us, it technically won't, or shouldn't,
because of stuff like try_to_unmap_one() that is used in reclaim).

3) Reclaim loses even more information as now N processes share the same A
bits. I don't know what effects this can cause. It would require
experimentation. Perhaps something like "if page table is shared, value
pte_young more". I don't know if this can work as a bandaid, but it's not
ideal.

4) It's not known whether page table COW fork() is a real win in most cases,
or all cases. Would want measurement.

5) It becomes even harder to estimate RSS and PSS for each process.

For these reasons (and more, certainly), I don't think working mshare() into
a transparent, all-great thing that fits the zygote model can work. It has been
discussed at length how to pull off certain hard bits like TLB invalidation and
locking for mshare, and with mshare we have the advantage of not needing to
support every feature ever (tailoring it more to the big database users of
hugetlb). And we'll still need to adapt certain bits of arch code just to get
it to work efficiently.

This said, if you want to discuss pulling this off, I'm all ears and it could
be perhaps a fun discussion (too late for LSF, I guess), but I don't think
it's workeable into the current mshare efforts. And, believe me, I would love
a unified feature here :)

-- 
Pedro

