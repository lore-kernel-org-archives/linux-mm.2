Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B89BF9D0D2
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 14:02:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 287696B0088; Tue, 14 Apr 2026 10:02:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25EF26B008A; Tue, 14 Apr 2026 10:02:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A1F46B0092; Tue, 14 Apr 2026 10:02:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 098426B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:02:55 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 80AF5594BE
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:02:54 +0000 (UTC)
X-FDA: 84657327468.29.4B75A2A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id B91BDC0016
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:02:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nMGh5aJ9;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776175372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4AqPy0AMwjqvqg+exYoaCnTjV/qg8szmXavLM1Vzh9U=;
	b=2R2BT8AnxH3FhVa/8usDsba+6WWrRK6GCh1qjCadpmvgIdA0qGYHpk8YlJna5FL6fSQula
	h6HwxOzz7plP4wUU6AnHq7wZS+bqm2ELuqN38v3xQPafjMlUQsI0BunDk4BMNo6oxGrgxr
	8mQZp2klCTJ2usO34em/+tKboj5oZ34=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776175372; a=rsa-sha256;
	cv=none;
	b=Pp4LLIwLSqyYAr7mKX5Ydsr96wB4rK9ISqcHQnYVR05qPzFsfe9DHogzKLjdJ19tR32zsY
	zz0na/P8csiFVFpJWyryb7dklkTpJLLeK8VerHortLg446STqR00FixBlsNQ7haUNOAWng
	8elIKLsF6onsxOQ84SaCLQBvRdEyXdA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nMGh5aJ9;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EB6E260018;
	Tue, 14 Apr 2026 14:02:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C38C2BCB0;
	Tue, 14 Apr 2026 14:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776175371;
	bh=x7XJtLqXh17ZcImOlaVLyo5LTdL3i1fbBepv/qg5ZPk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nMGh5aJ9U11ND7fOu9C/bNwMLWIVbpAAaBVR/PGX4KZH7Fta8xBVgm9YdoX7tW+AH
	 Smw23T2oFCr6Pk/Ad1UGEdyCfJKCbmJOba+z7+onL+UJzEvsZ1YeQe3KOn6J8cl1gv
	 nGYMXhtpHtG06H000JrCqAvF55rTzyOZCwwyeUzIUnDrnfuG4s+p8Wd2XOzUMKuPWs
	 TiTmdGrikAJd58xtG99dwzYxNH0FHBPVTHMS7BKclCHeSl3lS+i6K/VH9rwloDbi8R
	 0I0GrIkHf2RQTohrjoPmULxhO4xT26PXX7syMEQMd5X7ohRx4/zVFjDha96OtAq6X4
	 JH9ahcyxcN3lA==
Date: Tue, 14 Apr 2026 17:02:45 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] MAINTAINERS: update KHO and LIVE UPDATE entries
Message-ID: <ad5JBQ-hxej1FNl3@kernel.org>
References: <20260414121752.1912847-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260414121752.1912847-1-pratyush@kernel.org>
X-Rspamd-Queue-Id: B91BDC0016
X-Stat-Signature: zzor99z7oqjgbfiy6fjptyxr8a1n8biu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776175372-257686
X-HE-Meta: U2FsdGVkX198bx+Bn5+Z7dhK5zzpaqZOWZ0AmGeiFwJxoTbFU0B4s81u8i6ALqJzVHYGxqNAbBFX0K/dOn7MspTNCH5rIU3sjEZ2Fcz2iujRokdzaf7lPqauBFdhPeDA43sPwqjcbVUyu+jLU1iEoGm19+mMAEhVt4CIHSo/NT/+TNvsnPY2rciYkNwQlnr3qemhT6zGgWvEIrsWEVgncK0zKCaJ+XqoO4/6EII7atPzgze3Px8ipJpJgBFlstUwRiMXKJov6jjlm7I8n/lbjPiR8ovwHlyjscB2Jy6PSiA1P0XEATraiQhQJDgdx55+UrvWsOARi6ANUopRyTImoHPBvg0ayujahqiQEpNnCfUS27jwAqskTHFYA1khHA2MPlBAdXYMdSp4Ie8UlgIj77cA1dZwmCz1o06kmf3uBePRpps9akMGgbUqmMC9ixJUV963r0FxFWj/KBpmiASTSnNdizxFezItVcjOa2EnUfujZI+xBziOSBJMxJVtL4kD/kCUPSdB+H8cyiQsjlVViTZjRiv5drFIgKMYd3YKSENNGTzPq7h6b+rJMI6uD/MThoRVPMTQp1Qo9stZ7ydo1PiKxum4pdQh5kQWcMcnatovk6N6QYeICLVihvzz7+CX/ZH15tginRXLzIn+6vrVgV0WJanNFti6PgWMDnFj1Cj/4dkibhT23Ve9wDysAJHe0d4ceQ+4Q58UZMToZxuy7smOHfmw4vBlbrRX8Qkch4bD4JizXsR10htPgMAu1qHEOGR/APGtAA+L/k3RYxnzFhX5ssnlvztRRWlKV/ZvtldHz2hHq5joIl6ob5fkBQKY4K6E4RiPtemfHbYyKql0yLJZ/dCjupNPYFCBeBLChvpqcF5j+fJukiXxx+9Hw/GBOv7ODzq8zrL8E1tCOeiYCjXBWrSYndnZ1boR2GsOuNNcrXi/oxRF94LYHvhctBvSBQDxciMqp0ajcpUMip4
 hWcsZxvw
 N93wQ9Vxgv7tkDn7qa7cIqqqoSN2koOhUYGlmVlyqOwwneT4HlRD9yRAkUh/uFOen0pakS7KZBsmZcNWge+lzM+u8qvpzRp/mgNRLFtR5vvVvMczxtF71fAk1IphCr/gzDa/GynzhJrf2/QxCx9HjJhz6iAeMb6h+RX7z+egMe7itV55IFC4dXZjgxz31UKXjGi0oa64ipeMBoAEhHLlIROes0iDH15M5cg+RQVmCA/EmjakvJZ0YRdpAukHp0a0GCqza7GRgS/JnfRanZ7ZoWImFbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 12:17:17PM +0000, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> Hi,
> 
> This series contains some updates for the Kexec Handover (KHO) and Live
> update entries. Patch 1 updates the maintainers list and adds the
> liveupdate tree. Patches 2 and 3 clean up stale files in the list.
> 
> Regards,
> Pratyush Yadav
> 
> Pratyush Yadav (Google) (3):
>   MAINTAINERS: update KHO and LIVE UPDATE maintainers
>   MAINTAINERS: drop include/linux/kho/abi/ from KHO
>   MAINTAINERS: drop include/linux/liveupdate from LIVE UPDATE
> 
>  CREDITS     |  4 ++++
>  MAINTAINERS | 10 +++++-----
>  2 files changed, 9 insertions(+), 5 deletions(-)

For the series

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

