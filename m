Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 301E1F01825
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 10:27:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 964B26B0005; Fri,  6 Mar 2026 05:27:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912006B0089; Fri,  6 Mar 2026 05:27:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F3A36B008C; Fri,  6 Mar 2026 05:27:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6DE086B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 05:27:13 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 15B6B1404FD
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:27:13 +0000 (UTC)
X-FDA: 84515260746.03.E97A4DC
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf30.hostedemail.com (Postfix) with ESMTP id 47F0880007
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:27:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=jjomhTxU
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772792831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iydKHV9b8DDclbM7C79GoisWwPtgGu4Ax9AsDL9olKo=;
	b=LMFiZaW57bbkFt33YXqmg0RHabMPZEE/iamX8Lcj7oIRrljZirpCEl3coigEnyUd0Yk6j1
	TaPeTuif7qvQvdP+CyD0d1uGrQYFTQ+vKVaGD0lQPV/hb1ROsf4WMWv43k54Ot3PWfijcX
	1c8/A+iDhSrIfSXt/VAIbLZ47P0jBdI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=jjomhTxU;
	spf=none (imf30.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772792831; a=rsa-sha256;
	cv=none;
	b=viibqtavSU9x7oqB/1XuWP09whO489zTN3d+jEPmVDKzMvScktOZwE/ZrGA4wGAlRT6amY
	p4N2SnfJ8fDfNZUS2mzVwEGl9KvGIo4R/OrmResHpNVdBTSoVd+tnAQaawLQKNlgppQeAl
	isN9nC/wQzSxGS0Amw9czdaXMO2pJ2I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iydKHV9b8DDclbM7C79GoisWwPtgGu4Ax9AsDL9olKo=; b=jjomhTxUqjuzCOHM3x5X82GUr1
	lll7DgHYwCewM9SP3LEGlCITTMkQSte1C5KucPOC6KTMSMAT5sXEBPZVuswWiGPMHCt8E7WhTPUqK
	jOpMTVOpjTufGLAaRVSM7RXZTgFl4cn8tg3YU848PpbJBGw5F0e2a9WZTbaHoYJi8Wqqb8RwJOI92
	dKKhNz7v61rW0ECQTq1BMTLdZnaIKBpC062FKm+oQunslZJ1tvtcvhXkhutuezDCyQPSOwCSKByJn
	zNzlam+a5ESFeVaz7Nnldu2uWYLUb/kt46i3eae9hvukbWW20FqVGIHmaKxD0LTbbQ7HbupB08sZQ
	CKl7Fz3A==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vySOL-00HR16-LC; Fri, 06 Mar 2026 10:26:45 +0000
Date: Fri, 6 Mar 2026 02:26:38 -0800
From: Breno Leitao <leitao@debian.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: Re: [PATCH v2 0/3] mm: thp: reduce unnecessary
 start_stop_khugepaged() calls
Message-ID: <aaqrrfWjC5IKWKsw@gmail.com>
References: <20260305-thp_logs-v2-0-96b3ad795894@debian.org>
 <3d3ee8ee-2aa1-4351-9965-c9ed5b858c96@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d3ee8ee-2aa1-4351-9965-c9ed5b858c96@linux.alibaba.com>
X-Debian-User: leitao
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 47F0880007
X-Stat-Signature: k1ymfwyjjcmijiq7oesnyttcctguka6a
X-Rspam-User: 
X-HE-Tag: 1772792831-636589
X-HE-Meta: U2FsdGVkX18jvw994PlxjOn0FTlocg04+OhJeFioAoUKMZH9y0FVrrySpACHAjGiImWlDJExgQq7wM9ADZKTL9gPh5DsqqcZibruTMl3YBg8g8D1GybxC/fCfYSBvnwUjU1QduAjEDPCfPuR3nPWoMJBuNlCdswh+0n1GNUgXtiNynGEeyF8OnFf2YeW76bJGW/NBO8tqh4stikOfTRsT0EyKewu0hHZvil+9T/FsQN5ZbyQ+HcRppAAB5LAo3vfMTnKsbLy9YoRKmNW5oSX7dTmVbWuxp9S9B5OGgR8Q0xnzu7GFVq7Qd4DctBTGQXR1Hy+sxEHKjLHI22s6gJGl+VKIPbNFp1//DIODE/Ye/adJT0heOVdadz1i57nasJu/1izh+daCwetSIz8wxMkkSSuDK/pEEfot0ngc4D+lJBHGYf1Tg2M44/18h7KagUoSkx9SoIC9O/vU38q3nycjrqr2WtnUSGucKh2KvIHUtBTVNztth+b6ajMofqRZAKC7koQ0Gl80dNKawZrQ0PB+a073yMjvKj3HKKL38ABQ41zKBrY7b/71OeXeS6yvOiK6YGjorJtd/q0aoQTra3HD4cmr3wLrlm3i6ZQVLHgKlWBS+9CTThr1XNmQXW0ZUsZeHF1lvHv1BpL7PdjYcwHsIfh1AwK4YF4vYnlIxpxvSpoGjJlqaRX8bw0yrJSfLaNOabTzAePZZEBNzNaQqSw2Sfdc934Cf7LlyMBu97Qas4xYG1sv67BNDqs3tzUPBOxxlRW01s6zzW/CHQ7JPzdSNbBkaLPkKo32zW0qu2D5tKcNjd4i2kZ7Sdq/fBRtwlsKH4QVlSeaR1kh6El5Nqo+QxzPBLof0XPESEETJnu29GmQ1aRnDJgwJScTzx1cEfArmf2CRxVD0ndGjBtn1zXImeulHbEx570G2vpVGb5Gqzo7yyzvON7BaEWYVrgWpC//jerf3fPP6fodK0FMom
 Eb+owCZ+
 cEws4Arht7K6MEK2RITbZoIF0xM73SKP4S8iQTk8D5+RYvj8VBd24+SDW8eu3+vHbqiq2m0U7/mm6TBCC527P/mhwKklSsywbD6wJtWSBRGYdAIqjR8RY4J96jh3fw6ABrYYRQXyvKW6dhYwGxb+plmuJk1wjbr3M5P7x1Wf+HbNU+c/XefNx9JvqqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 02:14:31PM +0800, Baolin Wang wrote:
> 
> 
> On 3/5/26 10:04 PM, Breno Leitao wrote:
> > Writing to /sys/kernel/mm/transparent_hugepage/enabled causes
> > start_stop_khugepaged() called independent of any change.
> > start_stop_khugepaged() SPAMs the printk ring buffer overflow with the
> > exact same message, even when nothing changes.
> > 
> > For instance, if you have a custom vm.min_free_kbytes, just touching
> > /sys/kernel/mm/transparent_hugepage/enabled causes a printk message.
> > Example:
> > 
> >        # sysctl -w vm.min_free_kbytes=112382
> >        # for i in $(seq 100); do echo never > /sys/kernel/mm/transparent_hugepage/enabled ; done
> > 
> > and you have 100 WARN messages like the following, which is pretty dull:
> > 
> >        khugepaged: min_free_kbytes is not updated to 112381 because user defined value 112382 is preferred
> > 
> > A similar message shows up when setting thp to "always":
> > 
> >        # for i in $(seq 100); do
> >        #       echo 1024 > /proc/sys/vm/min_free_kbytes
> >        #       echo always > /sys/kernel/mm/transparent_hugepage/enabled
> >        # done
> > 
> > And then, we have 100 messages like:
> > 
> >        khugepaged: raising min_free_kbytes from 1024 to 67584 to help transparent hugepage allocations
> > 
> > This is more common when you have a configuration management system that
> > writes the THP configuration without an extra read, assuming that
> > nothing will happen if there is no change in the configuration, but it
> > prints these annoying messages.
> > 
> > For instance, at Meta's fleet, ~10K servers were producing 3.5M of
> > these messages per day.
> > 
> > Fix this by making the sysfs _store helpers a no-op if there is no state
> > change.
> > 
> > This version is heavily based on Lorezo's suggestion on V1.
> 
> Thanks for doing this. And you should also consider the shmem parts:
> shmem_enabled_store() and thpsize_shmem_enabled_store(), both of which will
> also call start_stop_khugepaged().
> 
> That means you can also generate lots of messages with the following script.
> 
> # for i in $(seq 100); do
> #       echo 1024 > /proc/sys/vm/min_free_kbytes
> #       echo always > /sys/kernel/mm/transparent_hugepage/shmem_enabled
> # done

Thanks for the input, I will include it in the fixes also.


--breno

