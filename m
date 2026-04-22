Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B7DFFA1FC7
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 15:54:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E21C6B0088; Wed, 22 Apr 2026 11:54:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BA146B008C; Wed, 22 Apr 2026 11:54:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F7076B0092; Wed, 22 Apr 2026 11:54:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 702F16B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 11:54:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0F52E1B70F1
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 15:54:15 +0000 (UTC)
X-FDA: 84686638470.16.F8CBFBF
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8D97680011
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 15:54:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TbHGnsgz;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776873253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MNSFjB5scCIoduSEowvVTvq40a5owQCVbC+es3+xqtc=;
	b=HRqJxp5LigU8ykQ5bpEQNh9OaXKWE5nV27sMuV9vSz+BkvoRiUMRSMyBWc7jPFUG5hyTci
	rXLKIp9H8rB2b3Bhaef1VpL93jxnnPTAb9cKdJCElyIZWadAe0UNSZzp4vDpZmgoHa934F
	0+9Tw36pGMz5JiLB5kdCPMay9z9V5AY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776873253; a=rsa-sha256;
	cv=none;
	b=jgrgx7ZlB9PeC9sSv0EYXGDtGpRyOG5INDgDRdRHKdmbElAOVDFVVhmCyfgh7xSMIOLehB
	8vuJKVIqgLRLvQVKEKDTsHYFLIxtZhrqVLsOlVW1f2ffJuWJW7keOFL4oOcVwWfaGX/sxg
	zYET5bzOfs4vvSAoUStBSp234nusWlI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TbHGnsgz;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 22 Apr 2026 08:54:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776873249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MNSFjB5scCIoduSEowvVTvq40a5owQCVbC+es3+xqtc=;
	b=TbHGnsgz4p/jZjpNe6F0BBXy57w0Nk0cSY+BQuwiWwjJG/PLr2GOdU2l7UQe1AJdxQXVnB
	POvEsUH+T22cL7uij8iDLevqfu6ddNozYM2c/HnGCbzjO+UTdgyMVoI2bRH5C4b6jsZZYV
	gPcMqHyxmRgSplWg2AGT2ceTaWfXYsw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Zw Tang <shicenci@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [BUG] WARNING in workingset_activation triggered by KVM page
 fault path on Linux 7.0.0-08391-g1d51b370a0f8
Message-ID: <aejuZb1sDlsKVc3M@linux.dev>
References: <CAPHJ_VJGTsRDc7_Kv0oDObuDX2pJ0evcAvH-mnD_RYMX536+mw@mail.gmail.com>
 <e48748ff-0fcd-4561-9958-124dd853e70a@kernel.org>
 <PS1PPF7E1D7501FEA2B54606827E0DE1805AB2D2@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
 <CAPHJ_VKsVzyYzZ5ZnBkNbYLEMXDYL5x+7jfyUxhcwT1j4zPXOw@mail.gmail.com>
 <CAPHJ_V+L92DxzEB=4+Tj+C8MNBW7LM35xWYXAoLhHqU5p2nxfg@mail.gmail.com>
 <177d0a41-5267-41f3-bc77-415b756ea4bb@kernel.org>
 <aejGuMRQjeEEH-V3@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aejGuMRQjeEEH-V3@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8D97680011
X-Rspamd-Server: rspam07
X-Stat-Signature: rt7ch69oynn788ztresys4h8d9y63k18
X-Rspam-User: 
X-HE-Tag: 1776873251-387406
X-HE-Meta: U2FsdGVkX1/65Jf/wo/VxgAsX5zdeku+3FAlRpsrej8vWOYjy00PD0v3Ff6ZCsG0+dwpnBesY0v3UjeqgM/qld1i1r5u5GvrvZq+xAwkyn6gw6Vof5yjCWNnKjjejjXEHlrAs2z+59B+GPQxhRUNtHkWsHhcMFAuhVmmWWpyyiGhVFMQ9sx9WB0+ZCXb5ATWOqZxH/KCttlah1cMeTrEGQN2IHEjOG3/BcFufxCDDHTEq7yJuazWYt0bSTlIoW0jLq7DPQghlthkl6gaSqH+ZEprphoL2MU4WWyaYTcBqpLUpsxwRRviRI0mcbN1SAxR2MRlM2IhkI1tADC3D+VOQ+HLoKE45bkiDJrhj0/QPqdL5pyjtMdhdjFVtdToXrKdeT6wURNHzn8aMbCBd9NfgC4suDXG9zGeYtqZYZJVM2yiWsfolPRCAoEEtcoxcXdC/DRKoZ0FkejV9jAvJ2hhM0l9Hhg+t3qO1AsPZP5CaQKbAGcg+yxNYo4yriZUoWielfHRLw8DRB32qAZMZerf/KG3xf0wL/8adU+4mcCYPNH0jsxUnmON7tk6LyqBk01t++0l2M9sYNagDmuFhHhIBO+BL8O2L1frUC3YUDoON2tvp7KY988JjEFwKYgvv8mhNsJd3OG4bHYrJsLpWp+2JfASINm/SROJPVzUKAUi0YLNiG3rE/9zLmka8qTZDSS0mG56y3lTEzLRVwSc4ARvME77vh2oFHI/pJX95mXwpc4aUI7nNTkgP4bd9Uzm7KdE6tz+LJzvm2bA0v8JqinE497Vkm1NWCUARyF2tnniO30dBFQf2uWkdYJw1Yq2kvXoQZAqWZP+eIHnIady3flTq3HbcGyjj0YKOzyJbtRlChlNhywVD7TFwbHUWLF5zVlF+N4gWct3ltCPOipq1HgB5mOcDRObTo30Yw9OCgRzO3H8nyu2PUIyhhyIYxGeXJXnW6VKy9g7wqTkB+AJc9r
 VAQrwdSI
 mcEXjrXrqNWIBq0V4M5Ci1T6Np4UW74FLzxWK6YxL7rYmZPiExmhogp97huuFU6oxxqGNfP7RvmCOADkTUpSv4i8W1oS4E8+ZeYwTgQ6YdSyOZZST1YRLCe0SylEsGrWzs08+XJUVJBPbJvSEdVZmNbPqpad4J8ssjzk/xD1g2VL0fCjkv4QexPSjwfETXnEaGx14rD72EMkX8Nh66ua1DbCQMJ6RbIN9e/rUFZJBO3hYYzGCvwAeCCcBM0SnFZvtpocUU1Ajv+rTNbPxu79Z4SJADHkIigWKTis/I0A3TLAlb9VRgzeoDOcW5EkzYhtgnk8pp54LHi35zmM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 06:01:44AM -0700, Sean Christopherson wrote:
> On Wed, Apr 22, 2026, David Hildenbrand (Arm) wrote:
> > On 4/22/26 04:06, Zw Tang wrote:
> > > Hi David,
> > > 
> > > Thanks for pointing this out.
> > > 
> > > You are right. The commit id I sent was incorrect. I mistakenly used the
> > > git describe-style suffix g1d51b370a0f8, but the actual git commit is:
> > > 
> > > 1d51b370a0f8f642f4fc84c795fbedac0fcdbbd2
> > > 
> > > The short commit id is:
> > > 
> > > 1d51b370a0f8
> > > 
> > > Sorry for the confusion.
> > > 
> > > I am also re-checking whether the kernel image was built from a clean tree
> > > and whether there were any local modifications when the crash was reproduced,
> > > so that the reported source line numbers match the exact build.
> > 
> > Okay, on that tree include/linux/memcontrol.h:381 points at
> > 
> > 	lockdep_assert_once(rcu_read_lock_held() ||
> > 	lockdep_is_held(&cgroup_mutex));
> > 
> > lockdep_is_held() would not trigger a warning like that IIRC, but
> > 
> > lockdep_assert_once() does
> > 
> > 	do { WARN_ON_ONCE(debug_locks && !(cond)); } while (0)
> > 
> > 
> > So likely we are calling obj_cgroup_memcg() without the RCU read lock held?
> > 
> > 
> > kvm_release_page_clean()->kvm_set_page_accessed()->mark_page_accessed()->folio_mark_accessed()->workingset_activation()
> > 
> > ... grabs the RCU lock, though, before calling
> > 
> > 	rcu_read_lock();
> > 	workingset_age_nonresident(folio_lruvec(folio), folio_nr_pages(folio));
> > 	rcu_read_unlock();
> 
> No?  Since commit 906c38ff52e9 ("memcg: workingset: remove folio_memcg_rcu usage"),
> I see:
> 
> void workingset_activation(struct folio *folio)
> {
> 	/*
> 	 * Filter non-memcg pages here, e.g. unmap can call
> 	 * mark_page_accessed() on VDSO pages.
> 	 */
> 	if (mem_cgroup_disabled() || folio_memcg_charged(folio))
> 		workingset_age_nonresident(folio_lruvec(folio), folio_nr_pages(folio));
> }
> 
> But for the life of me, I can't figure out how obj_cgroup_memcg() is being reached,
> and I haven't been able to reproduce the splat to add instrumentation (though I
> haven't tried very hard).

folio_lruvec() -> folio_memcg() -> obj_cgroup_memcg() if folio_memcg_kmem()

How is the given folio (page) is allocated?


