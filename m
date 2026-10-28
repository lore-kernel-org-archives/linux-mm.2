Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18774606A320
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ppjq6uci
Received: by kanga.kvack.org (Postfix)
	id 433776B05B3; Wed, 28 Oct 2026 04:37:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E3546B05B4; Wed, 28 Oct 2026 04:37:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D3B86B05B5; Wed, 28 Oct 2026 04:37:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 055D06B05B3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:37:51 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 83FDB140BEC
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:37:51 +0000 (UTC)
X-FDA: 85371381942.21.453F789
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id D06F0C0005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:37:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ppjq6uci;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793176669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1wbs7cHydDEQXXO5KItG+AMA3doDxVoVAxLbCzDRe70=;
	b=Hjm7a9SqP7B7UtrQT6LCeBENFACI1tb4R49QrqxI4b6Sn5nwDQBFJEDTFh0DLpdTBGXQux
	WUMNtLqamcjURJMl0QStAIAaUHRqSjx9Rf/EyQK5BIIGsbdvem39kEdzTckIDgMpmWRh0e
	7ocN7txfgxfvcI3dn4EF6vemgBxK6N4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ppjq6uci;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793176669;
	b=WvXL96IHGYvl2Bu7GjvYKLCBK7SgKK4iSaygOqqgtm4ngtbcSMtoDoNzL2/QDXNfD7T7t9
	o+HDBOJ3syZPsDgWZiZB8bwC3/K7NBBt2+pwNmPCEkv7ujLJmsrcnyrdHaNsXYfTWstn1A
	8OWQCwLMNp+dGIZe2Df8OqIz4JtQoSA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A829A600DA;
	Wed, 28 Oct 2026 08:37:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCC61F01825;
	Wed, 28 Oct 2026 08:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793176668;
	bh=1wbs7cHydDEQXXO5KItG+AMA3doDxVoVAxLbCzDRe70=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ppjq6ucixIquylI1RXa0glpRlIx0VRokubeu3+Rd9Zd3zOXS9VnLl/cf7El20ued2
	 LHGK6Xk9IQaRqA1ZpE5lW55bE8uTquQAGIOd9nbpx+msITLI5rBfXXBi6zLH41Zeqc
	 PQVQTbbhTl+Xu3JKPXDUPG5SFtltCsZNT5zDz5R5fMPIh9kI/s6nMR6wCLH/WBSttZ
	 Jd5uHYmnCRco+nGQQ0WjggVO4uKe9cQrI20/3HnGRX8jkvjhI3JLTfX7mJMkM07Cdu
	 F2b+fzMNBq2vYgLkkqQ8IJadCUPcQEYgH5F/oqVQGjN5I00CKnmk+1zKvUPVkVo3LC
	 m4OYLuMKXTIMQ==
Message-ID: <5e980194-d892-4b68-80fe-612c910c29d7@kernel.org>
Date: Wed, 28 Oct 2026 09:37:39 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/8] mm: fix allocator races with memory hotplug
To: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, kernel-team@meta.com,
 akpm@linux-foundation.org, mhocko@suse.com, rientjes@google.com,
 shakeel.butt@linux.dev, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, muchun.song@linux.dev, osalvador@suse.de,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, brendan.jackman@linux.dev, hannes@cmpxchg.org,
 ziy@nvidia.com, bigeasy@linutronix.de, clrkwllms@kernel.org,
 mgorman@techsingularity.net, anshuman.khandual@arm.com,
 Bessel.Wang@huawei.com, jiang.liu@huawei.com
References: <20261021023940.1940971-1-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261021023940.1940971-1-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D06F0C0005
X-Stat-Signature: n7meqajsn946ecxbphjphfohnr8q1e8r
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793176669-357116
X-HE-Meta: U2FsdGVkX19o6QJZuU+rL5SB2cQ90Y80toI042bEiTgyXeMK82wIrExZgVK2f/ogMCfSvlV+zwMB/kkLnfNlqrTMALo48pRefBphmlN7MjPkbAlAmOlA5ThYFmXL2+hABZWnjOVkxQSp0DujwEnOTiwAPE4Z5S9phQDHY7zHNfyfz66WXs9aK8cHIbjwzzIMF/OArQJnIkQUfxkVJrUfND2HyL4wYOT5xERej+1ObyF4/1Kb4Ov9thZPDhX8Snwh8LI9uwKnsTiytfGmV+HkhZcrVnofo+93ba9eEDO3amkxOoAThVFMqHxUGesA038Qofp1+g+D4yRAiOwuti9Bexj7sNUaYl4RT8J6X/RZW/lDTGxS1xWfJT/p/IgPM5MUxxJXzzNDlOBNnF/QNPvxZjLU5NpELFhdJMXEzQmkTDF0Uvu/fn/WdsHycq/ooVDMwTz5+w01K9rCppuVmds38yYkZen88RPJgzZ8/8WWfu7ADqUlJ8VGlCd5y6n+zYLxbbz5rRfwfa6aR3WYOAy020Qz6LXt+T/5+XmV68N7NAfsoyzs/QA/IHu0isi1tWHhqRI0jvfifmgSVZrq4eKpmYn0ygeP5PWAZ61ocW9nJX+HAVF3KFn/96P6KC925GfXF6vbCaRPwPsbpaXatrqWzEGti5kpSu7CgxMIX8TUALU0DMVBlgbg0CDPmXW+9N2RLFu/hb8cezFUap0rIbM5gThonVYyi+cWiqM1+uVU2HQCGynUd4G+5BYlQC/V6pVMnwCp8Ix1ojlYhZ0aA3iuwE9GhimjQW5eYN7ThfHboeBkq9lxwvuV38SYniVjlfjOzPktCpc6gE81vOZ8CfDpXI+f2h13LWEfgQcnKuyeA/hACzl1l9H3SD7E7MYFl6NTNO0oTHvnkH835b8KKbSNTRVojv5N1QbPHYKGj8FNvpAS1LqBDToDqWxLmWA1szozYdq3ekiCmIrBAQyJNwu
 9qOEHV69
 /011Kw8QRa1TVI2xgkm03yY86hcrKob1Ue25zGWdrnGSw3cDp+n0XGZluXjT+i3YMhb6oAGAmdmOFaBvBX4SiXKLWZ9yCZc+wD5oe2VItxHLxWhndDE7GWoXP7gCuvZEPc196CfqvObau0Ldt6aPybl6KdWcZgA2Vmd7CqVRk0c4dSfhSmigdN1RoEcWFxg2TuKYGq98qwxC/M0r7GLbd3WnMX3maRhVJrs521RT0DZzYs0zLJBwXYSAppn2FpAj1xeLpV8FiZcHLDhUXWUp/uD6m6GLmiGTQCcredJM3qpnFSEU1fJBCF22JnakQ0dkT/pOqumvTHWp4GPY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/21/26 04:39, Gregory Price (Meta) wrote:
> Eight fixes for allocator paths that can act on state another CPU is
> updating: zonelists rebuilt by memory hotplug, and the pagesets of a
> zone that offlining empties.
> 
> I've packaged these together because they're all related to hotplug.
> 
> *** Backport note - Patches 5-7 build on patch 1: without it, their
>     retry is compiled out when CONFIG_MEMORY_HOTREMOVE=n.
> 
> Most of these race conditions stem from zonelists being re-ordered
> in-place at runtime during hotplug.  The result is a mixture of failed
> allocations, NULL dereferences, incorrect placement (GFP_KERNEL in
> ZONE_MOVABLE), node misplacement, or incorrectly allowing hugetlb /
> contig allocations on a node/zone otherwise not eligible.
> 
> Most of these are incredibly narrow race conditions, but since the most
> likely impacted machines are VMs with memory hotplug, the narrow
> condition can more easily occur when a vCPU takes a long interrupt / VM
> exit of some kind.  I've made all of these race conditions
> deterministics with a kprobe reproduction module described below.

What's the status of this? "memory hotplug" caught my attention, but then then
is all page_alloc material :)

-- 
Cheers,

David

