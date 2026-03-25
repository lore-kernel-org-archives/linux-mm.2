Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65118109C058
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 19:04:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAD5F6B0089; Wed, 25 Mar 2026 15:04:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C370E6B008A; Wed, 25 Mar 2026 15:04:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B25986B008C; Wed, 25 Mar 2026 15:04:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A2E136B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:04:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 60E068CA37
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:04:13 +0000 (UTC)
X-FDA: 84585510786.14.B1E3C34
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 946E98001C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:04:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VBzg5kNs;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774465451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tv3m/1EpBsibpn2UDc0A01yOJc+jRQyhQxycLP3YItw=;
	b=IFTRs3cBW/zOgB7RBGnxEwA+8BRw+U7uxfsnidMVoAAkU8coTTrn28CVAX1YgNK1jPw3p1
	0u+qSb7O0gyeVdRu3Z0JE+0OL1mEgR2LSPTiYjihJ2ZagePbb7sZCNFDfmJOajMKy8PYwF
	P4DyvHRnZKafWSzeNSHkRUoqivA/JWU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VBzg5kNs;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774465451; a=rsa-sha256;
	cv=none;
	b=HeT/S6TVhe/t0IrxQiuCJUFnrhnJe1pwV3ayZ1SzSlkMu6ufnys+cE+s3R7p7QLYLMfphc
	NW46nshsgqR310bDo+wtvDtzPgmkOD9GcMf0tL0c61TgPGEZnRfoE+t8aOUhrpxjipWmwL
	eXgSF/BgrXWOgNNJ3mENauiKu6zzVOo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9173643E52;
	Wed, 25 Mar 2026 19:04:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B290C4CEF7;
	Wed, 25 Mar 2026 19:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774465450;
	bh=b+yfwYFWWh7bzRUgdC/0UEZd2wvaPtOdTYtpQXSH5KE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VBzg5kNsxY53DVtBF8KfGNvooQiOQtjZYhNvRfkQ5UCf0Er+rOSxk5a03U1Nr22nz
	 Y++UgEa+a24WKfx7+HPiExVrMZe0DddxEedDmKXxMVjZ8FcRcdkYYD1KIWlVUKW/lp
	 VdPkzjcvQ1OEF2uZGOkg6HkC6hb4RpDvO4AMNun2MEw8P+nOWMNDgqe7L2vfL5pEYM
	 pCoKbk9P1J3p9acrvqeScrO7pv0fKTkzafw1TYs3Qs1N1imxE1dUPq60pBT/yf1bAI
	 1sYWuIJgijiFc12YUiTjDi6Dozu5UVBJLiMBLWKcXih0+/S+k5reI3TR2M6tpfpcXj
	 glauCY/c5W2Bw==
Date: Wed, 25 Mar 2026 19:04:05 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vernon Yang <vernon2gm@gmail.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Wei Yang <richard.weiyang@gmail.com>, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH mm-new v8 2/4] mm: khugepaged: refine scan progress number
Message-ID: <65853d35-718f-4899-b4e2-e0d339e57e5a@lucifer.local>
References: <hbftflvdmnranprul4zkq3d2iymqm7ta2a7fwiphggsmt36gt7@bihvv5jg2ko5>
 <8a5277e0-d70e-4849-9763-ed90e350a118@kernel.org>
 <CACZaFFPfx=y5Fy+nwT8o8TA=W0QBfOvTqbJnhVPn8B95SFxijg@mail.gmail.com>
 <22dccc17-787c-448e-a571-23c7a9afeaff@lucifer.local>
 <20260325080930.a205fca9e7e61c4a793f5228@linux-foundation.org>
 <3cf94628-3c6a-43ed-9fc1-29bd5a911497@kernel.org>
 <8d2e809c-e4c8-4d35-a2ae-62777b6dfbcc@lucifer.local>
 <0437ad42-612e-461f-906d-6757eb19a8de@kernel.org>
 <CACZaFFMb_1u7ckb5+7=wWApOx-u5kBxx-+2Y1Cjd1Qad4kgHRg@mail.gmail.com>
 <20260325115932.d2841f29f318454709fd4f21@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325115932.d2841f29f318454709fd4f21@linux-foundation.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 946E98001C
X-Stat-Signature: 53pjoea1fr5pw1cpxhdgxmch18d3yabn
X-Rspam-User: 
X-HE-Tag: 1774465451-676318
X-HE-Meta: U2FsdGVkX19HTeypjXirP9Ftq+Tk8wMGxE1MnS4AodhXgzWWsQudMEadkciLLNY338gAeh5QkD9Qw7mGVmHr5A1tOQ1ZEgboFrnxIX6P5AUpuPyho5V043ZsGXWXtJ9Ce71dV3bHXHOi9rUyidvGJUOA0YhlFkJiE6GotFRV5kxHoABV0Q3sDVJJBZ/lb2UEJGxujIw/xDB2yRBAB4BFFsi85WKOXDLEGbefumiMAW0j11tHfWPTFaQcMHjBAQY31awMjhFHRbbvJz5qzVTNJvQ/pr6XtrYXVKb1SAMbItzdOhCsFFp4Wmn46djZbCyX3lZeon3VO3KPTWwAMHEUgTG5vxz5YdISXeWewql2RYodaHGZi0eUVDzkiq4+9rbrnKqXla2NdFK8/7vJkLZWJUGoMabDI6VCisTsHjxMpYqCjgNMzl4GF9PgxFz29wpPhEBInUZe4JeFkJKveFnaFTY5yrV2oQc5AFyBNOFxx9CCQnpTTCl9w9m5DtXyti1V2uFe802JY644WUjIrOVCNNllyMh4TCNy/tRwFJqlZeSYXn/kHVbwCwMlwEy0zjbvbN43Kau8owhF85x1+BQi723Ai9Wx+eGcC+ikj1mZCN1amCoYw9u95zMO0fXFvNuJMIhKu7oOCX/KOapopI3GGNvKsksRGVz9cHkINxD+Fr1kJ1Hg3GbBmFRB6o7QBgitF95UMdbCI+vP58df9mbrcVZ3ZUfG83pWLYs2HXsS7NOcajEk8NMNDwfww83UrfhECxGksMC9jnnLCVwx6zug1oqbiwLt6xxxk82heZz1w052OOS0ceoqIqyH3e+6T9aqYQnv3Psk9f76FbGilUOQUPd3u2hjLIftswkRcImV9mcQz+xl7PAS/Xw8UNG2Jdgjuhv1szheG2wakzMVspeSYEt1kxEcA+Pk0pooqWG4VQyU2zUeDTF/NsacBuKQTuc+uDskazPFjqUMEXn4N+Q
 DHTMiG6T
 ahEg/dFsGkK08imT9r3yUEO3FhDHhpBaUj0Ba0i9/Nrp93YTPyrpI3vTJ8dn2DVRkzq1HpDAOQMcaiDHYsFE5dc+TvO6rfvHwM31W6oVrD8N3uvjkZTcEd+9oTTV7a8FuptFTugqztyWMOiEzB/OPY5heOjuwQpJr/wkshBvusUg+SHlXykPTAg3uUYNYRfWOTphV92zLSXUJFMbC8XyCoQ4Er/WZp24bHw9I2eFUvhMUqRXSEDNoUjRFsvFuiZOOH+Zlk7WQezA4GcMRYZCSvmiVZlBIlMZjcFKi42JAAKE/sDMFcLWbt0IeAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 11:59:32AM -0700, Andrew Morton wrote:
> On Thu, 26 Mar 2026 01:00:23 +0800 Vernon Yang <vernon2gm@gmail.com> wrote:
>
> > Although this patchset is already in the mm-stable branch, if we want to
> > resend V9 version, I'd be happy to do so. Please let me know. Thanks!
>
> Depends on what changed in v9.  If it's a major change then I expect
> I'd drop this series from mm-stable and we restart the clock on the
> integration and review of this work.
>
> If it's a minor touchup then a standalone patch against mm-stable would
> be fine, or just leave things as-is and prepare that change after
> 7.1-rc1.

I think he means just resending this for the sake of reviewability or
whatnot?  Anyway if it's for my sake it's fine there's no need, it's
already in mm-stable and I don't want to make a fuss, I'll just try to
structure review more efficiently in future so I don't end up with BOTH a
backlog AND a random-walk of what I actually review :)

Thanks, Lorenzo

