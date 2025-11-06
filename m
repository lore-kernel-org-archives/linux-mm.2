Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5B65CCFA03
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 10:01:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18B928E0005; Thu,  6 Nov 2025 05:01:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13C578E0002; Thu,  6 Nov 2025 05:01:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07A138E0005; Thu,  6 Nov 2025 05:01:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA8BD8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 05:01:27 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A5C691405FF
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:01:27 +0000 (UTC)
X-FDA: 84079739814.03.C78DD74
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id CF35510000B
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:01:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fEAu6+aR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762423286; a=rsa-sha256;
	cv=none;
	b=2toQ5oEyaTN5vTJuumdwVcwzzeqWWy/e9V3DsCdZSa0J2jv/wNAyU1SknVVIbn9//bQuD9
	Sdmj0hWpaP7CIv2QEuZArD4UzM4b3Bu3qGKWz7m35To+CCiTuy2dxtcOkrueA4E6wSK5bk
	McRmSj3FlF9z0nnttWmTWKyqWPbTF8w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fEAu6+aR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762423286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ABVEq91omMCJpiOnnbqwx8uwJrXLQfYh1mlH14Rg/3M=;
	b=3HMXYJW3B++f25PdP9w7UHg7GCYiD3KnVoy0IlXC5TMzV0MdnaI061s9dsDkN3cdA0A4X7
	/AUkHZKlRCLZ9hcf8+BTaoEvFHzpRB26CvTgYpvpoBf7aGUOaLtZHECBU1tOJIoOCxdky+
	muRYfcjn/4BqybqScl5JYH1xj1qEydk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C833B41929;
	Thu,  6 Nov 2025 10:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53586C4AF09;
	Thu,  6 Nov 2025 10:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762423284;
	bh=iesv8rC4QL3CIngwo4NyosSS6ta4t5WL2Exyy3yA59w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fEAu6+aRo3d5d8m/ufEdiQ9WpLry8x99RB9cJihQTwfgbp2i5L3HqpCsuP9B9mRK1
	 zTOKLwgeHpWHHE0BD36pWhDu7aktyGUsbedSntOskcbGOuW3pUqFaVXj6zSCAgraZ/
	 ZJ+qJGLf9SRH9rgph2nn7KV8fzB03B2ZG0RSOmFUSWO05RMmIYXI4oPP9QcxNU/SSx
	 UO+09a3UNwkW7dXkZ7+3hmsWWCiYVzRym8aK1kGnzIQW6M+1M6/oUPFbtavKwmKyiP
	 ++sOVeS+c3yKZLlOCl8CTRcwPyoHrtTPA7xLizpV+AI/LpNiQgSfm1fdAAsqHv6dAr
	 B4AVLpt7gsNfA==
Message-ID: <5c7c607e-079e-4650-be8d-6a1210730b57@kernel.org>
Date: Thu, 6 Nov 2025 11:01:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] hugetlb: add memory-hotplug notifier to only allocate for
 online nodes
To: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "open list:HUGETLB SUBSYSTEM" <linux-mm@kvack.org>,
 open list <linux-kernel@vger.kernel.org>
Cc: skhan@linuxfoundation.org, david.hunter.linux@gmail.com
References: <20251106085645.13607-1-swarajgaikwad1925@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251106085645.13607-1-swarajgaikwad1925@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CF35510000B
X-Stat-Signature: mm81twfjxejzia3nbkoqancnm1zwgtb9
X-HE-Tag: 1762423285-186043
X-HE-Meta: U2FsdGVkX18mMxUe8Y/YChyPDigV2CsTMvjRds1vyLp4ClsciZ+zbpHWriwxHGFv9NGoTmIhanxpy1kijlma52FqT//eue4HXpBZacIC2SUzUkaffD1L2OIIGkbNJkp7l/L8l6B902snWvKLWq9GEjF4oqlH/t8/TR/VWZPPJGqrCswEVZ6juoI7hRXHqtdSP9DYiPJieWu1EbqUGaOzvwKjrRz2huxxh2AbTVWj2S5WJEy0+ARsoeAK6j0vsg/NcnSSKeVWE9Qpn7AF4GG6lnGzFmC/bWS4E0Nf3Qvqmt5bf/Hn1gJkQw+SAPv9ti9aTbGe4ILumlCtYOqagFOdgcwVRjBdw7UNbjr+lgX74S9UwcV5nFduMgfwkOMMB5hqeM06Q3mjVd3Z/JVFjsGXdAygVFR0xCAMl+h/m4OKpZ0mCDv62oHleOymAjpqAnObSgKPv/l7b0Dy0vObzOFYk+IiGU5jEl1IV7+pLGnRwbZ/GlSDPvj6sbsR5g575KwD7yBPVZ7BMLovzQsZzGVLenzXEx/YoRw1PW5M9vf6e9syBef2Ja5HhOPYu65tuBzI0sLin/TRIH2fTxv+8eI7SEJ6OaTqlc1gGdxq8ypFIUCzO85Tgqtmv14MFey/qZB/5606FlbeCfR0dTn/MY1+r6jcj+czKeaqmJN460NPjlgQibS8HOLHK5TEn3q4gc+AiSH6iv2mVEXnwMg2A5DtN1bnP97KrXY4i7qbsKMsmcS6OGv1nOs9zqKv3DwwmjgNpWTI3pyJk46Qp+wDWajwxTA1bQk8d12iEIJHKCk7BsIawRds0d+YZIcvpJLg8ZVkXpzX/EsAqS8jSZ7kx/l/+z/SqVszHU+xDBcr+37yZTlSenCBt6POo28+Svwf0y2cKxlCFLLIGIrdTcq5eLtaTIh3Ksju2Op7WyabMggmmNoMPCjsXbBloXDwg4orfoaBcUHd+oQqZejFBVoVGJM
 kH2wvlHv
 va5mROWnW9cRo9biSxpk1jY7hCQpl2QarImTmQWi1qz7uozIh0zahOrpT38ZBa8SX1AMBbI3x5c/X6HMhoqFzPNtgCCucwY4PPZ27Z5sHmL+A1mLwT+JtOiu4duVTPX9Las9GrfN+mOHQRHjYIsdX0IIljc+m9JwzUHCA2aIHQiusw95aHaeJJ5AYFvSVQoWMccBanxbyr60Vg4YKydGUxMciO8V4pdVrAJ98oPpWjdUheUvYT7wRv2pBjl7d6T2f4wdruUcfYqWby4Y5zV3CfGGompKel7sh94Qfz9i4u42hnblUd2TyFLCA/l0aHY6HRiw6dcp37BUMpl5A2AIkBWjGwyjNkPRJuyo8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.11.25 09:56, Swaraj Gaikwad wrote:
> This patch is a RFC on a proposed change to the hugetlb cgroup subsystem’s
> css allocation function.
> 
> The existing hugetlb_cgroup_css_alloc() uses for_each_node() to allocate
> nodeinfo for all nodes, including those which are not online yet
> (or never will be). This can waste considerable memory on large-node systems.
> The documentation already lists this as a TODO.

We're talking about the

kzalloc_node(sizeof(struct hugetlb_cgroup_per_node), GFP_KERNEL, node_to_alloc);

$ pahole mm/hugetlb_cgroup.o

struct hugetlb_cgroup_per_node {
         long unsigned int          usage[2];             /*     0    16 */

         /* size: 16, cachelines: 1, members: 1 */
         /* last cacheline: 16 bytes */
};

16 bytes on x86_64. So nobody should care here.

Of course, it depends on HUGE_MAX_HSTATE.

IIRC only HUGE_MAX_HSTATE goes crazy on that with effectively 15 entries.

15*8 ~128 bytes.

So with 1024 nodes we would be allocating 128 KiB.


And given that this is for each cgroup (right?) I assume it can add up.

> 
> Proposed Change:
>      Introduce a memory hotplug notifier that listens for MEM_ONLINE
>      events. When a node becomes online, we call the same allocation function
>      but insted of for_each_node(),using for_each_online_node(). This means
>      memory is only allocated for nodes which are online, thus reducing waste.

We have a NODE_ADDING_FIRST_MEMORY now, I'd assume that is more suitable?

> 
> Feedback Requested:
>      - Where in the codebase (which file or section) is it most appropriate to
>        implement and register the memory hotplug notifier for this subsystem?

I'd assume you would have to register in hugetlb_cgroup_css_alloc() and
free in hugetlb_cgroup_css_free().

>      - Are there best practices or patterns for handling the notifier lifecycle,
>        especially for unregistering during cgroup or subsystem teardown?

Not that I can think of some :)

>      - What are the standard methods or tools to test memory hotplug scenarios
>        for cgroups? Are there ways to reliably trigger node online/offline events
>        in a development environment?

You can use QEMU to hotplug memory (pc-dimm device) to a CPU+memory-less node and
to then remove it again. If you disable automatic memory onlining, you should be able to
trigger this multiple times without any issues.

>      - Are there existing test cases or utilities in the kernel tree that would help
>        to verify correct behavior of this change?

Don't think so.

>      - Any suggestions for implementation improvements or cleaner API usage?

I'd assume you'd want to look into NODE_ADDING_FIRST_MEMORY.

-- 
Cheers

David

