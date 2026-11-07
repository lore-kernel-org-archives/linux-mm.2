Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9442606A32C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 19:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R7xKMfQW
Received: by kanga.kvack.org (Postfix)
	id DFB576B05B7; Sat,  7 Nov 2026 14:41:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7D626B05BE; Sat,  7 Nov 2026 14:41:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C450F6B05BF; Sat,  7 Nov 2026 14:41:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96F036B05B7
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 14:41:31 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1BC4EA7F83
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:41:31 +0000 (UTC)
X-FDA: 85409342382.06.6C56E89
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 465D71C0006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:41:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R7xKMfQW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794080489;
	b=1MGbXENE9RTpp+fKo4WA5SQRv6qVHlT2mLnrkNiU0ef8R+SfAFlkQtHA+NJhPK89uPZif4
	1PsULLfdA3v8TyWvYblPr8gN3JedsDZ3hkSAztumIkgacqCG9VOgPjXnWluTBZxW3Qgevc
	wiFRZKlLJVl5uIhzIF74RyIV1czIfPg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794080489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qrayV5HgmTcSMMMhveHmxbWzQ03GCDulO+jtmHjEwSs=;
	b=GRK6sUcmrTcr4L71AvPMJOepcg1yVZnHytC6Rh+iG87SQs7URU5ZxWEwUQn7DHOz8ASEcd
	Fg1xqVUc2cbzVwYBWV9pcNqADXi1N23OS5G6ju0OI4lfZG1cQZNEjR53yJ6ysK3kJfFJPt
	PMJxsOhoqAK2yH0TM1wMZJEstifGxuk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R7xKMfQW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6733842E49;
	Sat,  7 Nov 2026 19:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4C31F0089F;
	Sat,  7 Nov 2026 19:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794080488;
	bh=qrayV5HgmTcSMMMhveHmxbWzQ03GCDulO+jtmHjEwSs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=R7xKMfQWAmEBP+7jr8m/rTZ0qcf3cHfKaGgUQmL4AL+Jj4Q2KlaWLJPKn2wxc/iKK
	 w9lZQcb/W0uS33hvwpHeyja1a1AQGSExELOIHIA+c/XPHnmuVxQ56RTUbkNWaePdN+
	 SB78P3uixsTGMMZNrngsUP4hm6/kMzANIxudL81PFPRxkj4MztpEE7T1Kn7dxsTZmz
	 PhkVPpKh/5AYLInaD/Ev+Y+vUawgIT+MO67PN3fHo5eAvvaSeA2gbcEXbMlKgwbKUS
	 MozNuMr9XlaQ1OoA7p69wSmY1N6ilueUU+3XjSJknb7Y7qum6Wb/FLvYPYvJ3s1Wzf
	 Ll0jmq/T6D4tw==
Message-ID: <a2ec6814-d3d3-425a-b379-f99b219aa55e@kernel.org>
Date: Sat, 7 Nov 2026 20:41:20 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory_hotplug: don't offline a hwpoisoned page still
 in the page cache
To: Mani Tofigh <mt4022@columbia.edu>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Vlastimil Babka <vbabka@kernel.org>, Gregory Price <gourry@gourry.net>,
 linux-mm@kvack.org, linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 tz2294@columbia.edu, stable@vger.kernel.org
References: <20261101-memhp-hwpoison-pagecache-v1-1-ed8785ca44eb@columbia.edu>
 <1b6a6d13-8a01-414b-9bbe-cd194af1f539@kernel.org>
 <a002901b-715a-4adc-bdcb-7a6fcda67711@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <a002901b-715a-4adc-bdcb-7a6fcda67711@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 465D71C0006
X-Rspamd-Server: rspam12
X-Stat-Signature: quthpccgoyf1je4m115f18j8hut8s8k6
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794080489-153732
X-HE-Meta: U2FsdGVkX18HgDHGNy7ZLOUUn4eFvPmp49cHfGVojAA45YbjtijFPVwvFJJU75gSTNt9HtPgzizMTT10Eci8YBTFPk9p0AJjThz8KXfdDG5jFc/QoFXMbPbbpylilAftaw9LgxUuJh6OF5nl0G9lgTjOtbJGW1b8T/yabJs8AT6Yb0TscM/UTuirKDjlQbBzqCsCPuis9CtdlymGcCXMPcMzLZBnZXlfwBnl4QEmAMMBiTFuTfx+dwA/LKA9figC0NWaSBoJJ3lgTSOXES/YAUvZT+I9jKn8pBKNBmZDvFxKw2iAZxZ3H7XeSxm7MTH4TgMJptDsRGgIgvlQJo56kafblHbsyI1eqHFUDiIVzvYGHeJqum6MqFNItXkWpsOhuOxHdTVowWv4cCfvBIrvtuDm7g6tvx4aonDfP8q306qTllaODq7Qr1jh1+NJnrVxNAMmt8q3Y3noJhYy4NMKNGCtZghDfIXDN+V8267sGAwuhHU2bBbD4pSGXTLsoGNPqsPiKIc5pL83BzmVR2HQqwlChZ9BSj/UVCpClavMlZz/XoVwyg1tyfVRy0m4GRepMAyJintMYe+otWbAOD0Wa7XMsHU89c38KPTgGCqvm0/0/X4APg2f0KBNayVhlhd+fKuDRE+pLvuLy2a50iB2homGLoIrlWUg0dgYC9U+BRR30DthXc552cqpX1R0RB8HUw/jfyMeLVs+B9f7DqIn/DD+FtSrTIvpCAD+uhpYfb+GcCOynoXxjzaM8Ru2bYvO+8XHpdBW3qLJWX3oEWF3fWGh6GB4ixh4qaGFHh+sOBt8WLytuE/iMpaOPAcmBX822669CFVx9sMS1qYk+ev3X5bR+9VuTmuEAF+7YcSrKQTRUpRGdYtG0ydyg9u1sw+CDc0fY86QkpRS4ajdrI1z5gZQhGCcDsPQwDavEeW0UfIjO1BUqrdWY6sjGSAuZv1foCjRot5hqNU5qwb8+a3
 v+ArpSmZ
 SmvMyOhxySHHEWzbdfTHN97KThuDPBE5i90A2LRVTmtWGJmIZyhD2eoa3SIdVq9l1KVS0ojYCXw5CBPLIBFVUlVkJqKmfroeBG0BeallR7u5ZGjM7S9aPbKDLNvYGCNyvA27vBijl2LhczhJnpTqMVZtvSp1oMd/IvvXO5uCZVtbcLO1TBDlwr4x8Nq9q7X3wmPeRYhmE8wCE81Z+O90I6gBisAQVnkBhHQK+tqEcRhNGHk4HLsoGIn9K8zihk2oywuSF8gOINA+uykejpo0fXX3S4eeHsfXpe4TsQRCqGujWXSq4aR1ok79ZCmnRrwxEVhyb2zxCjLc9MEbcVqzrzqXbuaWJpjFitq51lIavyjsPqz/VJEF3tZe6Ra9tEqqHicYGXcV05MmdbDIpeYgt9NhTJ6CzISpA2SfkX0Uy1r4U4Y/AGhINkV1akGnnprgdlK2SdK24nudaNZ+XIZAnJ4wSf6b1Y5483+4m4/j6b67KL6AWUH7n0fMxoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 20:59, Mani Tofigh wrote:
> On 11/2/26 1:56 AM, David Hildenbrand (Arm) wrote:
>>
>> What if we still have the page pinned somehow? (vmscplice etc).
>>
>> Wouldn't it be better to make sure that poisoning code holds exactly one
>> reference (whoever set hwpoison) and check here that the refcount is 1 ?
>>
>> Pagecache references would turn it > 1.
> 
> 
> Yes right, a pin isn't covered (neither before nor with this patch).
> 
> I don't think refcount == 1 can replace the mapping check though. In the
> race from the changelog memory_failure() has set PG_hwpoison but is 
> still waiting in get_hwpoison_page(), so it doesn't hold its reference 
> yet, and a clean page-cache folio then has just the one reference from 
> the page cache. memory_failure() also doesn't take a reference on the 
> kernel pages it ignores, and a poisoned page that gets freed later sits 
> at 0.

So the right fix is to fix that then.

We'd need to sync memory_failure() with memory offlining, correct?

-- 
Cheers,

David

