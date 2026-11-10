Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4E59606A881
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mi6pzJbm
Received: by kanga.kvack.org (Postfix)
	id B08676B05B1; Tue, 10 Nov 2026 15:33:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADFCD6B05B8; Tue, 10 Nov 2026 15:33:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F5CF6B05B9; Tue, 10 Nov 2026 15:33:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A9A86B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:33:38 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC3FB140AA7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:33:37 +0000 (UTC)
X-FDA: 85420360074.21.1BFCDE8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 30B7F100003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:33:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mi6pzJbm;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794342816;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/8ocYQBe3YFFmUUoCd3DPsEeCobQ/m4s1lpafYEhyRg=;
	b=KP2V3ing7Q23avT+Jh2eSNgI/Q85WJBjknGRK2IwZFWWqSciJWbnVZKAqq6Mqu5dsKqk5j
	yNHo9OSs5Q/WNvx6edudMy7zw9LNr9jGAT9WYVvduLk0L69r2drhZ3yq3SJRZzqRNiJthM
	tPd4Y0P3wA0UUVXj2qifusDeF51os0A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794342816;
	b=RLAQ7iUFLCOgHQWtTOfkKleKQgRfa4Ae/bt0UsxLflGyOLz8BzguulA6pTpST8TE6H1Rlx
	M2h6Q3cXLclAmLeYYYp0k4FExLztq8GF8yCDgsMyxJvN9JZEDyQgXzTeB9vJBZFH0fkKIp
	hfzEl3J5pzsJc3hN6/m4B7/8d2v9oVI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mi6pzJbm;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 524EF474E7;
	Tue, 10 Nov 2026 20:33:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9FAE1F0089F;
	Tue, 10 Nov 2026 20:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794342815;
	bh=/8ocYQBe3YFFmUUoCd3DPsEeCobQ/m4s1lpafYEhyRg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Mi6pzJbmGbk+Y7lwP1y+fgu4twMGHVAMHHT1GHNSzeJCGFPvQY06WGUh0F8gG2d9B
	 /46tdmMsmHUyjAa5hnJT820kJxQZpxX3Op1/JyjtNwjI1DdQs62lE+2EBrNXcaitWH
	 voiG/bXJV3FyiQ3xLYvqu8YrDTYvbmT6E3mNzNYEfh1ZGZyOJPFQ5SN3KXspVAvYbe
	 C8VwynMbJH3tkME+dSdl17rZ1/txeiLoBCXe9GCVQQ6+b7Q/MFDHi+WSvNvKCLJfOW
	 EvgMKyHovR3fJ2W47FvmVHz8977Xi3TqMnyedOdXiIFANjpHXT33kCvtB1UL1Epsw/
	 PIkgit8f9BXUg==
Message-ID: <sashiko-outbox-207712@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 1/6] docs: security: Describe the Kernel
 Assurance Plane design
Reply-To: sashiko-reviews@lists.linux.dev
To: "HARIHARA SUDHAN. R" <harisudhan@armoriq.io>, linux-security-module@vger.kernel.org, "Paul
 Moore" <paul@paul-moore.com>, "Kees Cook" <kees@kernel.org>, "James Morris" <jmorris@namei.org>, "Serge
 E . Hallyn" <serge@hallyn.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Jonathan Corbet" <corbet@lwn.net>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Peter Zijlstra" <peterz@infradead.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Steven Rostedt" <rostedt@goodmis.org>, "Liam R
 . Howlett" <liam@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "David Hildenbrand" <david@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Mel Gorman" <mgorman@suse.de>, "Suren
 Baghdasaryan" <surenb@google.com>, "Ben Segall" <bsegall@google.com>, "Dietmar
 Eggemann" <dietmar.eggemann@arm.com>, "Juri Lelli" <juri.lelli@redhat.com>, "K
 Prateek Nayak" <kprateek.nayak@amd.com>, "Valentin Schneider" <vschneid@redhat.com>, "Vincent
 Guittot" <vincent.guittot@linaro.org>, "Shuah Khan" <skhan@linuxfoundation.org>, "Ketan
 Bhardwaj" <ketan@armoriq.io>, bpf@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261110202246.274-2-harisudhan@armoriq.io>
References: <20261110202246.274-1-harisudhan@armoriq.io>
 <20261110202246.274-2-harisudhan@armoriq.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 20:33:30 +0000
X-Stat-Signature: bfrftqhhsppe8igqsx9ge6rebz3ptety
X-Rspamd-Queue-Id: 30B7F100003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794342816-991780
X-HE-Meta: U2FsdGVkX18DvYrdI/lWPqX9apy0P+ybh21gXKke4RkZ9Oqo2FKFt4JdDeQ7Rc+1VzRdzAdCCdOqJCx7ws2HI6rMgBzcHFAKAhcO87l7NcfxMEH7xqT0eUrRw6zicsPds3xSFqB8aHewcn5bwoD1jHCxwjsrCmo9JNXYVRmI9mWoQU34DIKqvEDxsm2/K0LNwZ5ApBdC1eQgakFwTMyJi2qOzlHzz+C/OkqSqmxdwZHFFFsjIrjpQTcd0rrvRYHhT1WrJ9adq44FqvW4N4EgzXIDcv2jwIiFRWNwj8e/X04cRheRimoyR7UW60q4mIoTQ5speZ9LddIwl5j6qmsbvlIRDagOJ6hQqbtGPfO8Qf8cEivU8daYXLTywYMvCusIioPS8WaFdOMMJ1qRq/qgFzY8t7PFgWOOkzBj4JpAknrVzq/VKBiiqK2dWVmy0pp9l8oc6O6VvJubhpT4jQ2rcvbVPJQFEeGEhoMOpo5uc4YPFoZ2RRLJ7ojUE1gmGBMR9Z45jagniwBVretmrQl0XWjGDNY+rl0QHLzu7TUK+NOTaf1tx25zZTN3HjsiA7ihcl3vLj9cvx0D4mTKGPanP7V1b6LqiJ7aylLxT6qlN7XVVbHMRsrbkvUA57tgYdvFKu6tjAZkNTCIH0qLE2WmbIq9CliyYs47l7AWckgGg5xUqtVZdOgOj7FBlsHi5A63Stmeca/7JTPDxrHku37wrSDFZV3pWp3peT/+gHa8cK24aGt7DszJMtPd7V/G7H6RXnCQXZWSP3RnuyC/DHnCn+3GHmDXS29jt5jbahku3fqyJdNKW/ZbyJLqUeFL8wKJ1HyrP23d2RT+umF0HPWDabKT8mVRXVCp7574FBfjPB/2PzjuZ6QTW6YFFgK4VvhBXk/Q1dlO3WgnxE3RRa95ELALYQlzsj9/dSWZVku5mWN3cl+QM+HNeQEvztarRw/VK1VGRF7885BE8EJHFO2
 LJ1NY4Jc
 FntyPDslxeubllGBKZFlULdjD/i70zWf9bVzPQBV2pOvlylAM8rmtc38KWstNx4FxFG7/RJ0/7RhKrbCTVMkcHPKYPu3YDYQZ3hs4h/L4dwjIpGo3GKSP8mXMleINpl/GiRJjPjTXeq/kJtSDaZls4qL7sFDYoN5c18fWoh3JdVQ4dNx/aXsJcVvF4m2xJgxlfQ9ZHQyIuX8IxuKJzkjlcaz03j+Je6rGPXM412AtOn66GsdvTIpm9llJnMHLRvZYn9UexWLD1MgTTGRMHSieQxPGJOhmuEAosfYZvcvOOSYwYxsfZrnEShYwuHWuGhDLdh+RkX5Ir0w+4Ff0aqCbSr4qU/3ZVPkkUCEAcd+wCBe7rTwK1G3sM8vF8lwZx6ggtv+KybYBAQEatGejDNvlEpvQsn/neixalXc1IFusOuAhdB4zi5nV4I8FhVQi+lFiE+ThXbhipDoGkzU7eFhN/hK1Lk7hGJxHTvGJSaxGD1eQe1NOPTOC1zMjrEEy/ydDA9R0P4QKfw+xX7dAH9vycIneY8Z5zAG/gJINFb7m0fce5oy4N0aoOenrSLUHpDYA8yyz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] docs: security: kap: contradictory epoch semantics for bound
  tasks
--

commit 77da64268c0c9921ecf4f2c4a0222c86b4687cb2
Author: HARIHARA SUDHAN. R <harisudhan@armoriq.io>

docs: security: Describe the Kernel Assurance Plane design

This commit adds security documentation and securityfs ABI documentation
describing the Kernel Assurance Plane (KAP) design, Intent Lineage Groups,
and control plane files.

> diff --git a/Documentation/security/kap.rst b/Documentation/security/kap.=
rst
> new file mode 100644
> index 0000000000000..e002a081c6607
> --- /dev/null
> +++ b/Documentation/security/kap.rst

[ ... ]

> +O1 finishes its first stage. The controller advances O1 to a new authori=
ty
> +generation that is narrower: no package cache, no network. It writes the=
 new
> +authority and a higher epoch to O1's igroup. O2's igroup is untouched.
> +
> +From its next check, an already running O1 worker is held to the new aut=
hority.
> +It cannot reach the cache or the network even though it could a moment a=
go, it
> +was not asked to drop anything, it was not restarted, and O2 is unaffect=
ed. If
> +instead the controller revokes O1, the next O1 check fails closed.

[ ... ]

> +``epoch``
> +  Monotonic authority generation. Installing a higher epoch fails every =
task
> +  still bound to an older one closed from its next check.

[Severity: Low]
Does advancing an igroup's authority_epoch hold already-bound tasks to the
new authority, or does it cause them to fail every check closed?

The motivating example above states that writing a new authority and a
higher epoch to O1's igroup holds an already-running O1 worker to the
narrower authority, whereas the epoch definition here and the
kap.authority_epoch entry in Documentation/ABI/testing/securityfs-kap say
that installing a higher epoch causes tasks bound to an older epoch to
fail KAP checks closed.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110202246.274-=
1-harisudhan@armoriq.io?part=3D1

