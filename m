Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B9A9606A332
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 23:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=korg header.b=dL1pZOXq
Received: by kanga.kvack.org (Postfix)
	id 5D0FB6B05B2; Fri, 13 Nov 2026 18:10:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57AB56B05B3; Fri, 13 Nov 2026 18:10:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4910C6B05B4; Fri, 13 Nov 2026 18:10:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 25B606B05B2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:10:08 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A7E251C35A4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:10:07 +0000 (UTC)
X-FDA: 85431640854.27.41AE47F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id D8919C0003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:10:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=korg header.b=dL1pZOXq;
	spf=pass (imf28.hostedemail.com: domain of roman.gushchin@linux.dev designates 172.105.4.254 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794611406;
	b=MM3SRPXaqT9Ill0EMYdXSLu5XtbQyJUUEMnAwQmT2/Ep2FEy1fljf8zKtPmJ/D9jp6zVQo
	eLW6k0GfEEggpre5c57uzg+jw4C6XzRtrUg054RZIGECuQveSMkDCiHQZSi0QFVnYuNjAn
	OSLwqDHxP/UYByRPv9P7bq2xyJ12ibg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=korg header.b=dL1pZOXq;
	spf=pass (imf28.hostedemail.com: domain of roman.gushchin@linux.dev designates 172.105.4.254 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794611406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yXeMiIlzLQ0R7siTBRkfiZ7NvU2B6iTFcdfu0ymlIxA=;
	b=xich32reHxVzUVwnrTakX2Hv+NKH+JZrlH4lEouAqbUFo/ILFjSq20A86hSu/EmYm/qbk6
	ajg4v2c3Egl9+d+5EOS79j5Mn4dbQ8fUBUmuKQ9yQmTsYqsW9zZlb9fijwkNc14fHQJ/td
	4eHZJ8fp7d48nvQ4txuFeUAKzTGX0ug=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B42C6181D;
	Fri, 13 Nov 2026 23:10:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909961F000C4;
	Fri, 13 Nov 2026 23:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=korg;
	t=1794611405; bh=yXeMiIlzLQ0R7siTBRkfiZ7NvU2B6iTFcdfu0ymlIxA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=dL1pZOXqRkUI/AQR14f8O1vveyz1yyus6WljBOIDKiTMaE0pDdB4sJEle17ZXshJY
	 uK20eK/lv7QdNDBWVgn/t22tu2dzGFW6aPCMQN5F9c8iZKeVkU9sXmtnZ48VQYjViY
	 JCWKfbso5n3lcZdES6ZPHZQ8+92phKQ5CIPKL2zA=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
  sashiko-reviews@lists.linux.dev,  David Hildenbrand <david@kernel.org>,
  "Liam R. Howlett" <liam@infradead.org>,  Vlastimil Babka
 <vbabka@kernel.org>,  Mike Rapoport <rppt@kernel.org>,  Suren Baghdasaryan
 <surenb@google.com>,  Michal Hocko <mhocko@suse.com>,  David Rientjes
 <rientjes@google.com>,  Shakeel Butt <shakeel.butt@linux.dev>,  Andrew
 Morton <akpm@linux-foundation.org>,  Jann Horn <jannh@google.com>,  Pedro
 Falcato <pfalcato@suse.de>,  Matthew Wilcox <willy@infradead.org>,  Jan
 Kara <jack@suse.cz>,  Nhat Pham <nphamcs@gmail.com>,  Johannes Weiner
 <hannes@cmpxchg.org>,  Zi Yan <ziy@nvidia.com>,  Matthew Brost
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
In-Reply-To: <avdveCV9uW1zwXXd@gremlin>
References: <avYJ-CxBEpdO1Wmu@gremlin>
	<816E22E2-C7DD-4DD1-AAC9-F51F4D1ED71C@linux.dev>
	<avdveCV9uW1zwXXd@gremlin>
User-Agent: mu4e 1.12.12; emacs 31.1
Date: Fri, 13 Nov 2026 15:10:03 -0800
Message-ID: <87jymg5nw4.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D8919C0003
X-Stat-Signature: xzmsopuftu4xh7ywqub6e6j575z1y5c8
X-Rspam-User: 
X-HE-Tag: 1794611405-590769
X-HE-Meta: U2FsdGVkX18gGW1j7r2H9qDPRxyqAapmh1KEgU+T0nGUx9GlMSLF2VvpxUPslcyA7LvJ+4G3HqSpW8v1vvEqocBRMCzTrYiym1EIZYsOujkVr5k+xf9Ar9CnGRUMUvoUuw0MICMvFWoOsu8T97+RQ4yoU4GA87L10OCJn0sX1Of3sotWJK7XSPeL2GzZYpgqIvbFBurzQ7qFloV6uq+xgnqqg9xtPO4RRmvMaIIn7zwsW+Z48tfZKB5jOx656nTG7S65Os/qeUicAFWPIOQVr9woW4B3zfvQPiUy+47xRzlOzsOavlD9JmJYweT6Voj/gpEAfvqBQj92ccUxoTVA99unuaG+4AgSIFuaG2guW0iKCUGDtBzLVudxL0AB0wgCWPkWga1pXiTQD9AAThuMjn0++eoISsyrEjQ601J5HkbIC3YWfqjoCVjwH91SgSj/F71PVcdF3IPTmrjrN0nXHAj2nnXjxYxCC1Nbrsisc0Na3ggMMAJwunVN6gk0Y4vMawLUSvmjVeKEOSRcnelUBnQ2x5Vse8hIvcIBRJfy5rdF5d1gangAruapdWczI6Eut0499UNytkXeLCHL4AFjREjoFYi49XaRY2UslKr+kM7fOzj2mmOivR81baAxJ887XnnpNoFXvithaXvIPrUqwbs8D+BgHaA1TvqLfADhvoiOUAHQiBGN9676VTG/GuViSEq+rCk18B0EhfWbjh+Ws/xdO0VoIysotcNDsg5oUYfYczP9hJ0LLQ0XhLg8dbtKWQ+PIar7xseDykFIvAn6dwoUeZt+c4tpIRStvQENxvn4jrXNh4sKV7JHzDWThDI7oT9Pf3x6iovmDCM/7+7QC1LEpDnjP+um0OwqJy3O4Fguy9fFNT2xOFIvJTGfxaWjy57e5Hlok6kA6C6SGqabUuBHnlvuKxeqS9iqXwZWphb9UIRSMPgMjY0C1qWE8tsVLvxKC1xEzFeo7pULfa5
 hFlP5BbR
 +62k3MA7k0RBqkI5bNVpVXT9Za9AeYfMXPyx/tbgidQIOpdYoLv/1zTcmWK13Z5X3stWBulbX9/qLsVxLmc7ELD1VXFt5GjBhgG69l1JvMoMsX1xALK1iiZsKhmnAEWoFFSR22ih/J7Y4oS6nHkwH/MVqYySFdXS6ONZiUZhkjjXKqRbtkFI/cL7sqPCmWUkH0Is1Q8zZFZISPqKwV2VrV8hmbgbH8Vm1WepplURdgjkCnZ9ZeG5h8GzpfN3UxpbAKDiq5OwOXtjKOgZkk0eF6T0nQ+l1HlsssGpOF4IOeXutTCFQJXndnx+ZLFi/zeYMdYFdlZbuBhFZ6UpZxwByrnVNgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"Lorenzo Stoakes (ARM)" <ljs@kernel.org> writes:

> On Thu, Nov 12, 2026 at 02:53:44PM -0800, Roman Gushchin wrote:
>> > On Nov 12, 2026, at 11:03=E2=80=AFAM, Lorenzo Stoakes (ARM) <ljs@kerne=
l.org> wrote:
>> >
>> > =EF=BB=BF+cc Roman
>> >
>> > Roman - see below - I was under the impression mm was not supposed to =
receive
>> > 'unrelated to this patch but' reports? Did something change?
>>
>> Yes, sashiko started reporting pre-existing bugs again, but in a better =
way:
>> strictly once (per bug)
>> only for the first non-rfc version
>> somewhat related to the proposed patch
>> not more than 1-2 per patch
>> not exposing security-sensitive stuff this way
>>
>> Obviously the goal here it to increase the chances for the problem to be=
 fixed.
>> It=E2=80=99s global, not mm-specific.
>
> (Sorry only just saw this!)
>
> Ah, I thought it was an mm opt-out.
>
> In general they're spawning a lot of AI sloppers to go off and send ever
> more fixes and causing ever longer days for us, it's quite a noticeable
> impact unfortunately.
>
> And often they're duplicative of already-sent fixes so you can see the
> conundrum with this :)
>
> So ideally we'd like a way to embargo these or have a maintainers-only vi=
ew
> of them etc. so we can figure out a way of reasonably getting to valid
> cases.

Disabled for mm. Maintainers-only view is available in the database.

Thanks

