Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89267C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 17:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E71DB6B008C; Fri,  7 Aug 2026 13:28:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFB1E6B0092; Fri,  7 Aug 2026 13:28:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE9B46B0093; Fri,  7 Aug 2026 13:28:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A128F6B008C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 13:28:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1C73B120128
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:28:42 +0000 (UTC)
X-FDA: 85075158084.06.9C8975C
Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7B0A220013
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:28:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ughP2etH;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.175 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786123720;
	b=wgk+TBHDoVtz9CEVZQ1SH9zjZiddjYZkecph3JbSzq6UJeSq8QkcuIuZocFX74bVVZLlas
	hzbrQmiPGK6DcZcDXYABT7f2l0oSIygeyA92EUoqgnOTKkBMa7z7phluKHnAkZEfvAijK8
	5Rp+A8damWZ34vpk1ihpLUMDkeb8xvc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ughP2etH;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.175 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786123720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=os/PRrPbacuorvD7qAfSrgmy4CupVw/uh8x9t7DjSaI=;
	b=5UiPJ96xV2RqQpWRINll1eNmKdL5p8S+hcEM98FGST5WiP+WR16O95G/ER2ZCAppPHwPeb
	mGfuLg5CwQaR7rwR+dJCqUJOlmaFTxkhspNBiSd22sc3UW7X+ILIMLgo+L7TdeKBHiw6P+
	QW4jZWaeUUMfg0a7mwpILokvnLiOgqI=
Date: Fri, 7 Aug 2026 10:28:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786123715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=os/PRrPbacuorvD7qAfSrgmy4CupVw/uh8x9t7DjSaI=;
	b=ughP2etH1jfO2YCuUwJ+EDaLB5Zll21Cf4meMuH3AX4mSCqhajNRmbc1Jajyeb/kfQZWiC
	91mGj+2/jTt0aErwcrvnfYXlbFJC4bC1u/Ka6mNI817P1ddiI/TPHVS5SpH3kdPC6F4niK
	HCfDMnFO+ZHnCSYAHUgaXuM3nrkw5cQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Audra Mitchell <audra@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>, david@kernel.org, jocolema@redhat.com, 
	raquini@redhat.com, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix unbounded loop within try_charge_memcg
Message-ID: <anYUNIKwXnTIx0fl@linux.dev>
References: <20260806151004.1825320-1-audra@redhat.com>
 <anWSHc04JJBJ1VbS@tiehlicka>
 <anX8VgySSw5OR_Sb@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anX8VgySSw5OR_Sb@fedora>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7B0A220013
X-Stat-Signature: 66dyto1epppf1nzi3ijdkindrqt857jh
X-Rspam-User: 
X-HE-Tag: 1786123718-940640
X-HE-Meta: U2FsdGVkX1/P5n8k6ASoDpHPgxoP7i+3kjJsaVVQtwqc5dvzPNF/xg8DOb5w12VrNQbGljvnza6ge+32jAg37ry0PMqnSb2kKiiuDXNxnvjc9yEmriMItzRhYYukxM1HXBkFSNVxSZcqyQ92LdcPxj+e3ib1RSo+3AfjyhjUQR/EKSMK554oNGKMlbPF2Hm/kwtjopqwjCsAzYfmPU4SMH6r2nqvW55D6Bzu/tQvIgwDr4FfTdJcs5IabyswRvYZiubGbXXkAI6pX/qOCN0kntBZiP0eFygNpd862t30zHcHZfbMe051+bP5VX9QIGUaCMFz9IquV+jSgruTggKWx1+d1BYgWi4MbwM008l9h3bR7phBj755Jv0KUNThD4kSavnF97Dg2YjwhzflcRZ3Or5NbybpRf5W053dlpzjoHpSk6Ysj4WkOmicOC4quLQ23FXNiMD34QtEMG0zcfxXSgtgogeufTLH1QVT1c2kcln4/Ixgwv23XLJifIYmjReQ4WpIixIUrLPE5aQTsXdSBL9yAz+2EzTbGMN3+kr1tk1grz+eHA0pT1+dJzW4uR/JEqL5n+bPQa3CSbO9E7XatNlFcIN1AzEBteizq/+O5uO+UHk73T74Ff5wWHAdpRrpDk/Td98yv0aG5o3GFt7DZP/TMeQNDqnjQybjG/SU3nU91yBq5y8tGdd5XsdxW2opIzGWIjZVFxC+r+RBPB8+JppPvAym/8Hd9BgOmMaFAcyFnqilyxjUo/LtRyxFsCVLTYXjsJrfsdYbYrCjA7bs8E5JSkkPXBVgrXOOVwoRCO3BFeU4rapgdB0qsmJYkNZrijN81jJGA9AqV0ml2Xm9tDvxNFT4Zkv8dJ3Td1f2hTIsyTzhCfrVU3RTzgSRIzZ000kb15dJFwLRws3a3L9LHIbQAIqrAS9NcKYQgyKiawkVf2KqU9NMo+jRnpnFNvzAZGjgerkrtzwe8HHzcpS
 jFRWZ85M
 Gfk875w7Xeg7mFLsko3GHhOaqzvmcrdXwkZgf6K7cpzwM20+0M3PuLBaIvJP5lRIymNneT7VV2lFEeC5ByyPYlfhIHZj7rLhLyMd4TNmHyya3j7iZzNi2r+7paZ0BLOjCYZrwmzEvS3HlfZqTrCs6VdV/Kfucs0A/vP8o5gNAwzBVek18mQ2IshmjhCpgxrwPLu7mU6o1t5C6h/JRVfScPlpmx/27t04MUzYVgMtBjTamSPwCjfxRF819O484GOc/w7he
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 11:40:06AM -0400, Audra Mitchell wrote:
> On Fri, Aug 07, 2026 at 10:06:53AM +0200, Michal Hocko wrote:
> > On Thu 06-08-26 11:10:03, Audra Mitchell wrote:
> > > Originally nr_retries was actually nr_oom_retries and we used it to track (and
> > > limit) the number of times we entered the mem_cgroup_oom path and then attempted
> > > a retry. The purpose of nr_retries counter changed with the introduction of
> > > 9b1306192d33 ("mm: memcontrol: retry reclaim for oom-disabled and __GFP_NOFAIL
> > > charges") so that the oom-disabled and __GFP_NOFAIL charges would also continue
> > > to retry within the desired nr_retries threshold. Later d977aa939fca
> > > ("mm, memcg: unify reclaim retry limits with page allocator") changed the
> > > nr_retries counter from 5 to 16.
> > > 
> > > As the function has evolved we now have multiple paths that have a goto retry
> > > path and we have lost the original purpose of the nr_retries counter, allowing
> > > us to take a goto retry path an unbounded number of times.
> > > 
> > > Fix the unbounded retries by nesting the code in a loop and decrementing the
> > > nr_retries counter correctly.
> > 
> > Are you trying to fix a theoretical problem spotted by the code review
> > or is there any actual problem that you are trying to fix?
> 
> We have had some customer complaints that performance has slowed to a crawl when
> the cgroup memory limit has come close to the maximum limit. In those cases, we
> have noticed that each process is spending a large amount of time in the direct
> reclaim path acquiring just enough memory for their specific allocation, thus
> by-passing the oom condition yet degrading the system's overall performance.
> In the global case, direct reclaim is bounded by DEF_PRIORITY, however, a cgroup
> will go through the try_charge_memcg path which will call
> try_to_free_mem_cgroup_pages->do_try_to_free_pages each time it does a retry (16
> times). If we bound the loop in try_charge_memcg, the worst case is 16*12 passes
> attempting to reclaim. This patch is meant to address the unbound case, limiting
> the loops to 16 attempts at following the direct reclaim path. An argument could
> be made to reduce nr_retries as well, but given that the nr_retries has been set
> to 16 for sometime, it seemed unlikely such a change would be considered.
> 

Generally we keep the kernel oom-killer very conservative and let the userspace
system-oomd react and trigger the kill (unless there is an obvious bug and/or does
not require to add one more heuristic in the reclaim+oom path).

Anyways was systemd-oomd and psi enabled on the user system?

