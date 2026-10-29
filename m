Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCBDF606A329
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 13:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MmZFJDiu
Received: by kanga.kvack.org (Postfix)
	id EEA6C6B05B6; Thu, 29 Oct 2026 09:15:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9BE46B05B7; Thu, 29 Oct 2026 09:15:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB39F6B05B8; Thu, 29 Oct 2026 09:15:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC6DF6B05B6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:15:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 49609A7E33
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:15:48 +0000 (UTC)
X-FDA: 85375711176.28.EDD5F70
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id A277A100011
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:15:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MmZFJDiu;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793279746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lqh2h9OdAhEsv8R7JgV92DMgdxSdmNya/U3mKn63VeQ=;
	b=44RGKhUOwmymP56OrD9cwZfBMhj4lWWOBpl1UVbmRDHu8+utJH0ZCaoJMKTsQB+FN2iiXT
	B57bLB58uJhAXkx30DRMTNYuiQLI7XsqFh7zosLQznCEP0emtXp+wZqsHSaxWTkqFaK6ga
	lPSAlLBvFiaye7pURjja8pimpb5yYDE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793279746;
	b=7EdE1nbpc8QUN3UAdMShv7lrv/5akV81uTgREKnGm57IOc3MYk+CiMiUjWmEBZp7uNIktT
	gbE/eFJkbbDsO7Zp5kPcEM/346BYh6YPZ0Ze0vDETEQPGhISdb2spG5oyXq3nlL1A9gFc3
	SMSnl80HZe3WlfuNajQfOmGpA8rnEa4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MmZFJDiu;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DF0D6600D1;
	Thu, 29 Oct 2026 13:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98C01F01825;
	Thu, 29 Oct 2026 13:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793279745;
	bh=lqh2h9OdAhEsv8R7JgV92DMgdxSdmNya/U3mKn63VeQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=MmZFJDiu5p0O+/D6H9EcM1bWgs2P1sLao6pof6JMiCUbkuDuhoUnWvIYq6wdOTfbm
	 BpcdU9h8weFSI7YLOAuJPhsKw4Gi4YRQO5cUZN10fGi7ReIbYh9hagBT+jrYElX2YH
	 +ih3xGMrA3kLoEpG35T95VY9VY8CZ9PitTQpY1G0Ri8tbgIY4OEyb5lujXrodMB0ht
	 9mq4mqJBN5iSIEzqMYOWBi7auC6ctfTuZZc8lG2Ic63rca7gBPiLKOXjhv0fOpMgDy
	 ZaqKgfNBg3F6hiO66BQ6fFngZ+rT7A9j651kIkx8sefoDuBSSHj73PbusVG/D+GcyR
	 U4/gnsox7yWQw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Alexander Viro
 <viro@zeniv.linux.org.uk>,  Christian Brauner <brauner@kernel.org>,  Jan
 Kara <jack@suse.cz>,  "Matthew Wilcox (Oracle)" <willy@infradead.org>,
  Hugh Dickins <hughd@google.com>,  Baolin Wang
 <baolin.wang@linux.alibaba.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  David Hildenbrand <david@kernel.org>,  Zi
 Yan <ziy@nvidia.com>,  "Liam R. Howlett" <liam@infradead.org>,  Nico Pache
 <nico.pache@linux.dev>,  Ryan Roberts <ryan.roberts@arm.com>,  Dev Jain
 <dev.jain@arm.com>,  Barry Song <baohua@kernel.org>,  Lance Yang
 <lance.yang@linux.dev>,  Usama Arif <usama.arif@linux.dev>,  Kiryl
 Shutsemau <kas@kernel.org>,  Mike Rapoport <rppt@kernel.org>,  Matthew
 Brost <matthew.brost@intel.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>,
  Byungchul Park <byungchul@sk.com>,  Gregory Price <gourry@gourry.net>,
  Ying Huang <ying.huang@linux.alibaba.com>,  Alistair Popple
 <apopple@nvidia.com>,  Kairui Song <kasong@tencent.com>,  Qi Zheng
 <qi.zheng@linux.dev>,  Shakeel Butt <shakeel.butt@linux.dev>,  Axel
 Rasmussen <axelrasmussen@google.com>,  Yuanchu Xie <yuanchu@google.com>,
  Wei Xu <weixugc@google.com>,  Baoquan He <baoquan.he@linux.dev>,
  Johannes Weiner <hannes@cmpxchg.org>,  Michal Hocko <mhocko@kernel.org>,
  Lorenzo Stoakes <ljs@kernel.org>,  linux-fsdevel@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  kexec@lists.infradead.org
Subject: Re: [PATCH 1/3] mm/memfd_luo: don't use memfd_pin_folios()
In-Reply-To: <auKJXHWnNMzju7cv@google.com> (Pasha Tatashin's message of "Wed,
	28 Oct 2026 20:01:59 -0400")
References: <20261027173031.763213-1-pratyush@kernel.org>
	<20261027173031.763213-2-pratyush@kernel.org>
	<179321872100.1775665.6881420026761127422.b4-review@b4>
	<2vxz4ie5o2ak.fsf@kernel.org> <auKJXHWnNMzju7cv@google.com>
Date: Thu, 29 Oct 2026 14:15:38 +0100
Message-ID: <2vxzv76kmyv9.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A277A100011
X-Stat-Signature: ydw173yeo68xpw8mjggex8yyfuoiea9f
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793279746-583199
X-HE-Meta: U2FsdGVkX1/8OMLlePjcaaOROLbGTKUrBYNqam5s1f1xFcxrWs9dwyv/Hg1ZBncL+HLVCPvRfGGuuwhSIaDtwRkblnqUspwNEBjGvJh9qA/HKDViWZH/OCQ9kqKAYkTI1dZneCfg6gLL6n9nwpvf/08XpjdV5HdqDwWZk66X2sBOZ/BW4Rl+0EOmbCcfn5x0EUYaDB0YOQji+i7P//FrUXH3f1LX0sSvypW+9kyuAXSn3ELty8asYbA3lmUr2u32B6mIDqkRAhD4zuVjte0ltZcbHq1XLoe/t4gB6tp8tR/u3ak+hppuQMrhBcTb3jiJoqYurqZ4cxebxU48AJ3Bjh8sO4scVz6efAsMc719Cs2MCRPZUHfnWeWyurEq2hFGGqyWSi6Osq6L3vH2H/vI1+zGuJk5YbolbSEjDAwfwYgSohEPMlQmFEJ14tenBXc26Q0JSNNbqQ8oc1KmxqIqfxRNN9N43ARdjOFQyKUFrNm4ottJlHC0H7YXLrRI9M2q99TZk8DjrV+SbM/jF9tquKA1L74SVx/KFpD0e2nXfirI5WmUlh+mLZq3pnSLkPDYfOqHxEK8VrgTed926vp+GvwmZga00O1wwAQ001FXf0Guz3VgfdfPcZIcotU7+XED/yD8RYvk8MK8QBD3cgLrvzT1kUsNODtwHIhni/8jsJe9tk3B3PX25QUF2m5ErNZwG2e7HESaECRS0WX9EuzjrCjCnzytTYKVpSUoIbljtP7xthS6QCc0hhcewHyCy6h95LD3ORsFgXmQ6JKUH1uoXg4ME7k/ZwJUC/WyaPPTs912lCDmHGsOA8Gy9Be/2jS6sJwdKDaRNaIUtUpk+ctzGNOmW1ynaybaauP3EekaiuvQVeNvYxN1/CMrHm2IUBy9zb3mOTCkyF2C+jsaFUtwv/dJgSMKIoZANTlmArhDIuZRrnUL/QjzNKPNYG0uIYfVNwjKzxaObefSRH/V109
 Zoi+POl1
 9VoRXMx3p3zRh+7SPJbwxbIcMIUoLH71slIxBqriNxvQo4R5Y5VHUg1+DFApAzD84juPojo2Xr36RAvH9cvWEVLg1ZBH6gH90wkm+mvCvjgHnKki1uFuw1mAeMJGyjv6R3vmkbN0939LLt2Hs2P9PUW56NfED1PoFxdexUr0YKYSmi357NK2Er3V+B8yVBGXQ2zsqkd2ZYIRywD3/GRKK+1B35AbeGlJBfeiGhmEs9GQgWTKFPqpREQ1bW7vWn79rrdVSBO/zndhLcETWIktkn6JFa8OBSsKnLjFk0l4oTx3aDr37pixq3pL8a7PliFS7Rp6M/Q8Rymvrljf/vmQDLNFGPHHgdFvtHsgO6RvQCSPVt/nbjucnNUhkhulgwvfucjxmPAe9sQb8dkojCt/cA+7XJYM+dHLjpIH3OcqC1C2pEamJ40jZ5PgtEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28 2026, Pasha Tatashin wrote:

> On 10-29 00:04, Pratyush Yadav wrote:
>> > Nit:
>> >
>> > I would suggest adding another helper, memfd_luo_get_folio(inode, index, 
>> > &folio), that wraps:
>> >
>> > - shmem_get_folio()
>> > - The !folio_is_longterm_pinnable() migration retry loop logic
>> >
>> > I think this would make the final code a bit more manageable.
>> 
>> Sounds good, will do.
>> 
>> >
>> > Other than that the patch looks alright, feel free to add
>> > Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>> > Once the nit is addressed.
>> 
>> Thanks!
>> 
>> I think the MM side might take some time to gather reviews so I will
>> send this out as part of a liveupdate-only series. This patch is useful
>> on its own anyway.
>
> Sounds good. Could you also consider adding a patch to that live 
> update-only series to extend the memfd freeze from retrieve to finish()? 
> That would close another gap that does not affect us yet, but will once 
> other session fds depend on the memfd mapping.
>
> See:
> https://lore.kernel.org/r/20261022225035.377445-8-dmatlack@google.com

Hmm, right. That's a useful fix. I think I'll do that in a separate
series, since it can go independently.

-- 
Regards,
Pratyush Yadav

