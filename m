Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5174D606A338
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 23:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jwwZoRZh
Received: by kanga.kvack.org (Postfix)
	id 37EE46B00EF; Fri, 13 Nov 2026 18:08:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32D816B05B2; Fri, 13 Nov 2026 18:08:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 220EF6B05B3; Fri, 13 Nov 2026 18:08:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EAB6F6B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:08:10 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6E3CB1602FA
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:08:10 +0000 (UTC)
X-FDA: 85431635940.03.9B0F3EA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id B620D100002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:08:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jwwZoRZh;
	spf=pass (imf14.hostedemail.com: domain of roman@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=roman@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794611288;
	b=Oy5gStJxz/k5hEQBfa6ed9vuzXjxq4hOHCWVbHVgBAbODC2qgbNvUrmepvUJDctZa1kkAh
	DVza4VfSF3tVJyiW4VTYMUfBh/4NiocN7kZbdgnSsCCKljBWD7FHwQzlx0nSXxvHssA8so
	jMPDuAx+mWo38JrkaHGUfOpDU5mbr70=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jwwZoRZh;
	spf=pass (imf14.hostedemail.com: domain of roman@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=roman@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794611288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=06kAyjF7TnFu0sIXC7RFGZg/0iQXbcsoCMf4v8Qle6Y=;
	b=rP861KQXb15LDy0L0US+VETDnFu/rBllizjFfpGsjcwDuoPqRUzVwWgIZIX3GZp0v4/Dmh
	O61AWhsfMTMznNI7MP67XcEceCwdg5BmUoqdLJ/Ltkk1LJGgND1nrdFJWStuRTSiPeLO2X
	7IrJ4jrkyFTnbT3VR59Hc/QvORZbOKA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CDB3A601E2;
	Fri, 13 Nov 2026 23:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7A31F000C4;
	Fri, 13 Nov 2026 23:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794611287;
	bh=06kAyjF7TnFu0sIXC7RFGZg/0iQXbcsoCMf4v8Qle6Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=jwwZoRZhF5nsQFRrPE0EJgk/oVPJnNV37PiBSxtlxmq1EraKTGVX8YQFPbPx32BEj
	 qRjZDNql0Gyx6L5oSfZ2t/y/npMKeK7EOPQrZXqXPFmFL9J9kfL+Nc6xRihmxm/Inp
	 GFAGaNWwtXejLmIbTNPUcmKVR/IvmgfSB810L4xixkTaPn8Wdljnrk9x23adoKTZAi
	 bJ0BUFmhW9NRKyIn1n/r7lpGnSfgHh+0I4xZa4/nmjXWIBe6FWeCo2IaYs4jd272ex
	 LOvYp4f0obUUhpXCOT7rCG34YbJsPuZ0pyQIG+NATAiQJLzZj/wCyqzY+5ArVyjmek
	 fF8q9SkPBJ5dQ==
From: Roman Gushchin <roman@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,  Roman Gushchin
 <roman.gushchin@linux.dev>,  sashiko-reviews@lists.linux.dev,  David
 Hildenbrand <david@kernel.org>,  "Liam R. Howlett" <liam@infradead.org>,
  Vlastimil Babka <vbabka@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko <mhocko@suse.com>,
  David Rientjes <rientjes@google.com>,  Shakeel Butt
 <shakeel.butt@linux.dev>,  Andrew Morton <akpm@linux-foundation.org>,
  Jann Horn <jannh@google.com>,  Pedro Falcato <pfalcato@suse.de>,  Matthew
 Wilcox <willy@infradead.org>,  Jan Kara <jack@suse.cz>,  Nhat Pham
 <nphamcs@gmail.com>,  Johannes Weiner <hannes@cmpxchg.org>,  Matthew Brost
 <matthew.brost@intel.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>,
  Byungchul Park <byungchul@sk.com>,  Gregory Price <gourry@gourry.net>,
  Ying Huang <ying.huang@linux.alibaba.com>,  Alistair Popple
 <apopple@nvidia.com>,  Usama Arif <usama.arif@linux.dev>,  Kairui Song
 <kasong@tencent.com>,  Balbir Singh <balbirs@nvidia.com>,  =?utf-8?B?SsOp?=
 =?utf-8?B?csO0bWU=?= Glisse
 <jglisse@redhat.com>,  Kiryl Shutsemau <kas@kernel.org>,  Yu-cheng Yu
 <yu-cheng.yu@intel.com>,  Dave Hansen <dave.hansen@linux.intel.com>,
  Dennis Zhou <dennis@kernel.org>,  Tejun Heo <tj@kernel.org>,  Christoph
 Lameter <cl@gentwo.org>,  Peng Fan <peng.fan@nxp.com>,  Josef Bacik
 <jbacik@fb.com>,  Chris Mason <mason@kernel.org>,  linux-mm@kvack.org,
  Borislav Petkov <bp@alien8.de>,  Mark Brown <broonie@kernel.org>,  Dennis
 Zhou <dennisszhou@gmail.com>,  Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH 10/13] mm/migrate_device: refuse to migrate shadow stacks
In-Reply-To: <F185BA4F-F26B-48EF-AB3C-848D72FA630D@nvidia.com>
References: <avYJ-CxBEpdO1Wmu@gremlin>
	<816E22E2-C7DD-4DD1-AAC9-F51F4D1ED71C@linux.dev>
	<avdveCV9uW1zwXXd@gremlin>
	<F185BA4F-F26B-48EF-AB3C-848D72FA630D@nvidia.com>
User-Agent: mu4e 1.12.12; emacs 31.1
Date: Fri, 13 Nov 2026 15:08:05 -0800
Message-ID: <87y0aw5nze.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fxe7f3gscgbxuret1koo383xwrmt9z18
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B620D100002
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794611288-294059
X-HE-Meta: U2FsdGVkX18cUNlHYY2Hinaj2zLdWF9z4YdS/nkjETbToy77aZb3yGLHonMUN2B/cz3ZWVuINGGoymIr+vY9wojCimEf2c4+BWwDQBO296I8NJ9f2WJLRSvdCJXjYV9zJTHlc+yEIB3Fe31D2LMEE2RcfKBCREZ26GwjDqgeDRU4V6t4fHwynm5jzwDf6BFKTfRDXxrTQZA9Iud+Ci7tSlVfpRPibwDestP9rmJM4HJ+VnJ0+Es2cqTa4+N2a3iVObGSh2yPUSsY0btey5hFfaUl2kIALyJYXO6ajcWiNlQAbziBLkc2477RZGp/+VXeqThKWpiopod/jDVz678vTPEHJ/MUwJo4/hByTD4MkKa6R+nE2ZKLZU+hdPG1/txndO4r6V4jik221E8Sqk6kc/++zI+oybtIMC6u6MiScKtdiKuQg9jThyjru6VHAgzvv1yJu+GN9zq+kGCv++SOFR7MSeETYS78iUjoCONZt6rXdGDMcxirnTcAc+dFqa07LbhIZ2BOmYMGcCorzHPYqD4I+JBp4nD8KPKNBIpM8Jqw3OTE9IjZ463NsK0ZFZDxNPuHGy8uLtxnMhYvO9dXMy1FthEo7OxyW9EozsnIikCxHs/brG/AeYp74ZOV3rUxgKYh3cVe3TK2fg+u2iKgUdMg41unKRSwQ7Pu08+nWVNPT3cbPVzITsQYD+NjjihWQX6wlNfcjUHCug7rbvaygpsdeGr2LFmwMOLd6rz0kE/J9uxvgtTsguPmWxnnYFBljlm8lQT6QmP83ux9Ynx/UgmuBwAMUcM0iDed/iO8gnInxD4Ijj6g0qPXVxWMUJqWN/saTW+mPLlUa9tIZkr1iT09O3Mv2R7T2UHpI8Yhn8OJpGtWSGZ1af1S8lgh9kWhZ80SO645ZL/gtgZS4JzWKzFpIZ3QQONnAOXQMt7DxlISg2LRgwXa5h0xg5omndt8dt//cjPEtTgL6NshNZM
 TcSaIsVB
 0cm9olfYppxVv4i3CQ3Vx+wMKwU+cE8gd8EFeT11eXGw8QyEYpPvxvjhqkgN/CO93KhrriKp2sz+yIGMS6WrHICKDFxWUf90T4+3cCXfBb2PU+Qa06wuk4p7NVxt42r+EbGUKREMwAWZJkBjbG72uXiMWPda51bN+zUOKDBTF4Qx0xSnYQN4Z2beKLV6kUZG8a+GFX9WQNLNbYu2aiOGFMqwuYO5PMDrwqJN87DdYnj75jGYAK7wZgPy7SuUhPgVgLBQbDvvrQjdyExVw94rRNDmzrsuFjm43YQBG5n0AdeEMnB4/hyT2midwnA+WAvgzelDYpi1wXDPoeqNg3wOoZwbcFQOuwyX8ObpNbYAcRMECNNDQi0TAyYZJ9KDbJqpji9Pu1pTGV6VUt6A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Zi Yan <ziy@nvidia.com> writes:

> On 13 Nov 2026, at 15:17, Lorenzo Stoakes (ARM) wrote:
>
>> On Thu, Nov 12, 2026 at 02:53:44PM -0800, Roman Gushchin wrote:
>>>> On Nov 12, 2026, at 11:03=E2=80=AFAM, Lorenzo Stoakes (ARM) <ljs@kerne=
l.org> wrote:
>>>>
>>>> =EF=BB=BF+cc Roman
>>>>
>>>> Roman - see below - I was under the impression mm was not supposed to =
receive
>>>> 'unrelated to this patch but' reports? Did something change?
>>>
>>> Yes, sashiko started reporting pre-existing bugs again, but in a better=
 way:
>>> strictly once (per bug)
>>> only for the first non-rfc version
>>> somewhat related to the proposed patch
>>> not more than 1-2 per patch
>>> not exposing security-sensitive stuff this way
>>>
>>> Obviously the goal here it to increase the chances for the problem to b=
e fixed.
>>> It=E2=80=99s global, not mm-specific.
>>
>> (Sorry only just saw this!)
>>
>> Ah, I thought it was an mm opt-out.
>>
>> In general they're spawning a lot of AI sloppers to go off and send ever
>> more fixes and causing ever longer days for us, it's quite a noticeable
>> impact unfortunately.
>>
>> And often they're duplicative of already-sent fixes so you can see the
>> conundrum with this :)
>
> I wonder if there is a plan to make Sashiko identify duplicated fixes
> and send an email to point out the existing patches. So maintainers do
> not need to do that manually.

There is no plan, but I like this idea. Let me think how to implement it
better.

Thanks!

