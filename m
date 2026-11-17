Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0ED4606A323
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 12:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C8lhV+Z6
Received: by kanga.kvack.org (Postfix)
	id 03D4D6B05C6; Tue, 17 Nov 2026 07:21:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F305C6B05C7; Tue, 17 Nov 2026 07:21:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E450C6B05C9; Tue, 17 Nov 2026 07:21:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CAC1B6B05C6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:21:48 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B56280447
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:21:48 +0000 (UTC)
X-FDA: 85444522296.16.5A87DD3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id BDB5840004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:21:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C8lhV+Z6;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794918106;
	b=IWULciMKm9EFXMq1c7FTTHHGuy5tlIjVe+bJZYxxBKAfFGUpkdNzVJwptkkHHoJ36gbxHn
	9+8ePz3+zeJgKM+1AQOrIljq4y6MnDkXRyNUgjwxiaclEXKJsyD1cF1iqAtVO2HFs2ZS7Y
	SwDy+C4kaixbAzXtWJB8D/r+53BgSvU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C8lhV+Z6;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794918106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GttENf4AQLKGgaT2xtnMonfh7k3XNqVVFPtXzQMChjU=;
	b=B/GQ4xtuStcYK0dm4E3RUUpG8+qzhVyl8mek9oCq3KgHaB/fRNExlU6U5iteFD1TNSUUZA
	sml37K+RtgkR7ZCIsS5axPgkArXFyiqsF+APcm1YEq8oKrBFqoKFeHrTq5O7ctUFAEJTr4
	HU4PeiiZ7WuJ4qrXo5xYIr2GGiqxaiI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E4E6743692;
	Tue, 17 Nov 2026 12:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023021F000C9;
	Tue, 17 Nov 2026 12:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794918105;
	bh=GttENf4AQLKGgaT2xtnMonfh7k3XNqVVFPtXzQMChjU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C8lhV+Z6SJ8XgHd/J2EKI1U6pcb4wnoZF8dID2gB43wsYDa8pyqcBqXoFMBN0xEPN
	 iDxWYqie8JE0pWF2f1kyXnCQ6L5jOHuyZy6Tob4n2/xEewU+wXTHgFe8AXq06KvIs5
	 DaKLlL4gqZ6+qRwK1mKZ/oot5DCjLn7s3MFzjm1k/2LnjoEDqxFy9MeMqgtd9sG1U4
	 fQ+kCnZ+V0Jbj9XU6dxdgPvt0chSQtjPt0YC28YBiFO312AJ3WmUWkDdu9jidpWQkp
	 kL1OZE7zrbXx1g+ZVCa5SBXHy/BmdjHWUII37KVWw/6mK+HD8vNfHhCkVxfVbbv1A4
	 ZC6mh0URIBSIg==
Date: Tue, 17 Nov 2026 12:21:28 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Jeff Xu <jeffxu@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Marco Elver <elver@google.com>, 
	Boris Brezillon <boris.brezillon@collabora.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Chia-I Wu <olvaffe@gmail.com>, Dev Jain <dev.jain@arm.com>, 
	Evgenii Stepanov <eugenis@google.com>, Ian Rickards <ian.rickards@arm.com>, 
	Jann Horn <jannh@google.com>, Jeff Vander Stoep <jeffv@google.com>, 
	Jeff Xu <jeffxu@google.com>, Kees Cook <kees@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Peter Collingbourne <peter@pcc.me.uk>, =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Tomasz Figa <tfiga@chromium.org>, Will Deacon <will@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Miklos Szeredi <miklos@szeredi.hu>, Baoquan He <baoquan.he@linux.dev>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Allison Henderson <achender@kernel.org>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, linux-mm@kvack.org, 
	kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev, kexec@lists.infradead.org, 
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 5/7] mm: kasan: skip KASAN for GFP_HIGHUSER
Message-ID: <avxFYRBid_VUp6vo@gremlin>
References: <20261116230627.3537051-1-jeffxu@chromium.org>
 <20261116230627.3537051-6-jeffxu@chromium.org>
 <avwp1ZpVudiT1Gux@gremlin>
 <85ce1f24-8b49-4cd3-a9f7-02d1be69708e@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85ce1f24-8b49-4cd3-a9f7-02d1be69708e@kernel.org>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BDB5840004
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: ha9rwsnmxca8obf55atgfg71h9ics3f3
X-Rspam-User: 
X-HE-Tag: 1794918106-285151
X-HE-Meta: U2FsdGVkX1/06AnNuqbTU4an+lMpxkbsomSpwmkwsAP4Bbw0JuKrnYtrWbLHv0hIF8iyf9V2tBr/z6v4Em4NuawWJiraC42lZN93NvXf9xRb5U77F0aJ1CQhDYmkol69RHwZPs5L/NZyn6VdYFSQkM6U8TT+VykIJg2lsFM90C5aH6d/IOZndB4SuAuTa56WhjJq1UtTdr7GBTYd2Wjup5m3R+S/289e6Y3N9zFHq1+y2jbRii9dkhwkSMdw0kNzV4ewL09r68xv5dGTwW9hCDt9Pmc/DHZlGvQNML1QXhLO+8Zrqo6x3E73sRwnHPdBUGZ6gVJj/YEAiypy6t69xuICbbb27Kjbi6NU1rWkVUls8zlmyU755B3xqcsctNo4pJCSJ2KiHXMgvcdVo42gWZaxPwL0JdZ7Tu4d0TaAl1EHOvX6QalqCxt7oyQn2dAT9hWOsAddEZguChTS8sKAN9uG7QZnywJbR2ghCGlZ2jw+NUvSEnWuuExRyOMe5Y686hs+qAZAN5kFL/qJgtj/tWqWa4MPdBsglwjnZ6j8m6dn4iiF7nOKv6XkQiutlKkM8wWRpmlea0BAORPB0spUULJrHhntSwdZYAAt3gPHpzzjR3b13vcDWF4iaouIcjTMhwArd5CncGLWynAHLhLRBrAJRHIxIbccwv0dda4Wx5EGfLV+E1YOpDyPZdmHHHbLqEkuz4yf58edHywBA+nQyoK2WoQ6nvm+22S+3x8aoXCFeoRXZw8ptWN5ZSi4eq8Q3TiMk1Yb3dW4yL7V+ywev/Th7aFJH4b1J+lBzltT7ql0kI9oMWxjXyK+tvlm1c4A0ye9ZBlcb3oWaj1Wye9Ima/uSTtH+GR9ncFCjHKSdTzJarnAv4TwQDNH2ScGnc2FYRDtM7KVaGPu0CXtIumusi9WR3xx5EpHVJMARDLQBzLSjPoMg17tusvusuH8ticRBIpOhS1pbAnu2I32GtF
 TqzwiqXS
 1VM6HVJpIgTOJekRCdlLlcqm81StOo1uGyHtTpTLc6iX2sASju8vk0lEONd/l8nPiv8OFbDgWPKmyY4uvrZtO7Al6XEwWT6eb+c/v2SwF0rUtnR26oY9pQl7UR89hCL1OVHShh4o1+MMrCfgS4wqkMSqFovK/DESU2B6mq+dVSiLXPNc6A9n/+McIcHLW4NXK76BDn6M5Oh/H30NxLqh6hkiCB42IjHQj6Aj/pTJMkX/xaeG53liDvHCUxczEpsRNuRXaUm5t+7kyUyXsC7ocZp88b8ZnNbA/0JTB9BXZrJyYI9agfr0ZcZ0bIDln9C8+FoLKkBgCsr2a9IWIb/RlAbnQUNXysn0nhAqDizRsS1hCG52/5zhej1+FlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 01:06:54PM +0100, David Hildenbrand (Arm) wrote:
> On 11/17/26 11:21, Lorenzo Stoakes (ARM) wrote:
> > This commit message is just inscrutable. It's like reading Finnegan's Wake :)
> > LLMs are obscenely terrible at this stuff unfortunately.
>
> I truly wonder how some can decide to submit something like that with their name
> under it :)

Have you seen mseal? ;)

--
Cheers, Lorenzo

