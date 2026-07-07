Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD304C44500
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 08:10:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C7796B00A2; Tue,  7 Jul 2026 04:10:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9789B6B00A6; Tue,  7 Jul 2026 04:10:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 866B66B00AA; Tue,  7 Jul 2026 04:10:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6138E6B00A2
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:10:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E6A0D1A0399
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:10:22 +0000 (UTC)
X-FDA: 84961258284.21.6FF4302
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf29.hostedemail.com (Postfix) with ESMTP id B1334120006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:10:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Mr2sA5O2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783411821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JoijE4uJCyq2j4khlPNuxF9JMy8fYGszG7NSw2HhBR4=;
	b=wxazKjiNDnJRByQwpoDlnxWqbzttOgCHr7VGQ6J1FMUzKs2lGYsJWNOohybzMb2aS8hTx5
	8CMaq02plQveVhKaO8AJs3w/vYc0ON9vqBl7Q1avUEeGz0DBZ14HVIXp6xvBz2OXALOjgT
	rOslwBXfWpJLxZw0DEc8AC7vlA1MwfU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Mr2sA5O2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783411821;
	b=HPiH0pt8t1bwz6YtY2sqw3OjyW3VGlPJWaEau0BQCj46GVLlDbL+ynExdfpKhkYrgjk34B
	KHALOOqU0vlI3cmytPzr2jRpBDcYLMGuYsEd2MEOv2horGHXmtmKdQAYBcYVZbFFIv5HCK
	PhH9QTquf/ZHqmpjlYmSdUZfxru/NuY=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783411814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JoijE4uJCyq2j4khlPNuxF9JMy8fYGszG7NSw2HhBR4=;
	b=Mr2sA5O2fwOZH+tdJVJbtFshcbUt3g6menEXK/k6fjP66J6bIxXN/uaF0WmGzyaLj2b2VW
	cY7kl73i6uSScBXlAmniWx4i6iDgVdgQJxt9MsQIpFlyQva0MSuZ1QtqGe3FGadARI53GI
	anr7Vxi7SJDpzawCZrnJt5t0V6M76zg=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [RFC PATCH 0/6] mm/hugetlb: Dynamic, NUMA-aware HugePage Cache &
 Free Page Reporting
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <9624988a-366e-4884-9408-3f3b88c27290@kernel.org>
Date: Tue, 7 Jul 2026 16:09:35 +0800
Cc: Sourav Panda <souravpanda@google.com>,
 osalvador@suse.de,
 akpm@linux-foundation.org,
 ljs@kernel.org,
 liam@infradead.org,
 vbabka@kernel.org,
 rppt@kernel.org,
 surenb@google.com,
 mhocko@suse.com,
 mst@redhat.com,
 mhklinux@outlook.com,
 fvdl@google.com,
 gthelen@google.com,
 mike.kravetz@oracle.com,
 pasha.tatashin@soleen.com,
 rientjes@google.com,
 riel@surriel.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 linux-doc@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <48E0B0E2-4CE2-40B5-A7C3-9DEEF9F49C41@linux.dev>
References: <20260707064235.1386552-1-souravpanda@google.com>
 <9624988a-366e-4884-9408-3f3b88c27290@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B1334120006
X-Stat-Signature: qd1feconpp56gb1a56s37g5mbmiuq9xe
X-Rspam-User: 
X-HE-Tag: 1783411819-513040
X-HE-Meta: U2FsdGVkX1+8oOkNuqHMVdaG7gUhfSoGmtb2/nq6yAQ1fD8OVHCnOJQeFqKHcesqEzLL0wuYvo0FiaXVarnwKp7GawJG5WcPg6cAO/2bNVRFd7vzKFBJYGjgSjEeipRLXb4Pt97HxS5pgKXaxZxHXLe+6zYi0Q+r1csj34R+A/OTIZVRs+4jtVLS6Dj8puJTL1eQ6sIxGVFkbpzvikL8j6wnYEGy2sm8EJIqUXQUsU6SegG5JNm6V+8DzXncRNvn3mOZzxHi28uK3i3Qn/fZxp5IHiPnzuF0aGMEeHFthMC7E/rNIYx0sSXoKwnA9ZcxdMuKdcrNXraV8pRUxkZWoORIKz2Bs6Bb62HicAvrsUbhAIVv2TYRLJ5BqlFdupmIVkfPbCu4IWJSLVKo+4keI39P6S3KLehgnIcSPXg9Jq6SVO3xP4RaIlPVN8HIXhqSvSyc4w2cXX8Amy1g+8bTd/BEA5nipsi9slKyF3uojcbHuq1uexGumV6+Q50UvQwuodsiK6MdDcxP/oJ/YZiebFk1lW3YAPJIn2dHyxjpwkbd6qi7JkXQ94RXxAiadhAerdTQox/+LzW+V8c39JYSIu9szHB+/7TLp/d8PYDoOk63wIzho0nVulo1ipSx3R+htcIBSDEinv/rmKZkamuJ9PG/aXnL8s+NLKjs5rKjVeBHQlWuB8ib2xresqEE4KpEvUEAaU1hkjZq4ZIKdhM/EIaDuQckUZ3exXxZnt9m9CknT4KpVMSxULVJC3c47iJX4Izjyg3HYr0368IzkNgUMazvyL4DG8lumHe2sOYMNjAvpem3+YjJEFJOlCTU6rJ7yTy0KBlCL/yJartOQMUPa26WyvzxFu+HwXVN5DxxmAnVzaw9s2BIm2BSDWvKzzyO4RUuNdSO7oLlfWq1e6QZdYE/AZLvSKnWd6zUVUf5jmdQkj0n5Q1fFyqEHaTyX23vCdHZ5bf73jiPAt2lDA/
 wY4abvJc
 vfpMKahfZ5UMVUYjJyaetzKUh2kMhH4eB7v5AyrdMQl7ItnBqXAAcTv4sYIhDkKNEfo8pHAhck2e1tE6b0W2nExJqguVhxGBw1JLLunmyJSVA6Q2APShGlGapKlVcxfBhvpclVplfbdM1pHsTD1WAB6mMybJQETpyQctd7EMztWmXtQN7x/gi7MxAaV9/R40GdSg5P5MJfVL+SqeCHSXit5/YdZF3UFDmBWET2kjijTMLHIeKr+7TkRqfmnuK09Oh9L+V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 7, 2026, at 15:29, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 7/7/26 08:42, Sourav Panda wrote:
>> Overview
>> This patch series introduces a dynamic, NUMA-aware HugePage Cache,
>> backed by a kernel shrinker to safely return memory under pressure, =
and
>> integrates it with Free Page Reporting (virtio-balloon) for HugeTLB,
>> specifically targeting gigantic (1GB) hugepages. The goal is to solve
>> the tradeoff between allocation latency and memory
>> fungibility in virtualized and heterogeneous cloud environments.
>=20
> Hi,
>=20
> in general, we consider hugetlb nowadays to be mostly in feature =
freeze, as we
> realized a while ago that adding more special casing on top of =
something too
> special for all of MM is only going to hurt us more in the long run.
>=20
> We want to have less special casing and less special sauce, not more.
>=20
> Now, there is nothing wrong in making hugetlb be less special, by =
making it use
> more of core infrastructure etc.

+1

HugeTLB is already complex today, and the last thing we want is to =
compound
this complexity by piling more features on top of it. I fully share your =
view
that we should avoid going down this direction.

Thanks,
Muchun

>=20
> But optimizing for surplus hugetlb pages by teaching hugetlb about new =
caches
> and its custom free-page-reporting support rather looks like the wrong =
direction
> for me?
>=20
> --=20
> Cheers,
>=20
> David


