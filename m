Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09174CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 07:17:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0059E6B008A; Wed, 24 Jun 2026 03:17:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1EE46B008C; Wed, 24 Jun 2026 03:17:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E34DE6B0092; Wed, 24 Jun 2026 03:17:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB06D6B008A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 03:17:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3F1138CCF9
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:17:09 +0000 (UTC)
X-FDA: 84913949778.23.7B547F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 52BB3C0003
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:17:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZSL5zgpA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782285427;
	b=4ZRR845gZmImfxVcJiBxq8KJozP2OZvDN/arQY5JTOS/cLAczbz9Q14Bo64uTMnXFlk2GC
	7n0h+mU00AyJjAxvGC9RvK4bbhedPwQZ99mrcwnApoN0JMeqadyCTTo0jhfHWTL0aDw3Z+
	kDQqUSd9lGxBZskOBYlHDmySdItWpOk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782285427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nkvfc0shWTHRBbTpqz2aEybCkdd21mCYCpgogRH31qo=;
	b=g4WBiUoABbNwLE+ZXjhAT4h8COde1T/RADSmd/zUaOxNbNbMt0mGD7h3szn3yJHQ85uLyp
	rv4Juz4xhmkCzbVQR8mF62h/hSb3meEXZ9rhYFawMdIOpOTjYOFoaoPeOkmZ7tsOM1taCw
	gLqEhL/aJZhgo1xxgLUygJa31Yu+Kng=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZSL5zgpA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E03742E07;
	Wed, 24 Jun 2026 07:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB38A1F000E9;
	Wed, 24 Jun 2026 07:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782285426;
	bh=nkvfc0shWTHRBbTpqz2aEybCkdd21mCYCpgogRH31qo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZSL5zgpABdy/SCBs0SMuDgdVIIa4Bj7cnYmGnTRyBTqsK5Li/h0gPKFmAC1xtgJIX
	 mhfoP63gsV+kEFyF4O3umQU1zQn6THUKNBk4uhE9g9CS3ncF+ADTY8r6nBv1yH0Awd
	 7a51MEhxXi3XhtbB50itdf0Fm4M76XPXl3KnmA5YY0sxITBzrpu6+jMyR3tqOAVmrP
	 7dJ9OOW/dcWTsqX71cQjuJ0Kw3fhFWejO/CpD1TfPM1VvJ05xf48ju9W4Bc/U44ua4
	 CIyQ2jYkkneYjQj29XiA7rpWallzHTWZLpHzh2YOOdx38U9+K9bTYxB22Ty1Xf0Ie7
	 /JQJl4FL3YYcw==
Message-ID: <8f56b160-11b7-48ec-9354-ecd08c2c1fca@kernel.org>
Date: Wed, 24 Jun 2026 09:17:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmstat: avoid taking zone lock in /proc/buddyinfo
 reads
To: Imran Khan <imran.f.khan@oracle.com>, akpm@linux-foundation.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260604134245.1580287-1-imran.f.khan@oracle.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260604134245.1580287-1-imran.f.khan@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 52BB3C0003
X-Rspam-User: 
X-Stat-Signature: 1dm8s5awsz1o1oidp49d718t85phn9o4
X-HE-Tag: 1782285427-946806
X-HE-Meta: U2FsdGVkX19UzkuU3cdPjihJQxJAnQWgNk9zAvIa9SROhzZ8lp8vQJvrUwY1+C5VfKMqV5UaY7UpjYiVjWddt6OAnn+Xg8NMhdgFy71wRGx/2dhNBB1F2RhLJmboRd8EwK9lltyzAgf69tatB+CKuL2Icg6iCqeH1SjMmaYAKMWu7Bi094OEqpN7foEO349SbtkVvARunXUsxqJ/CCK2+PDaD7D/JZo+MGQuCrXCG7cMGAff6DuMNZhfLRBEt4KNTj6XBRMuEnFB3F/6vOSvO1mCEunXaElNxgMNA5fGAZM78/0gYRDdecGmxDhBgf9AJJo1lF0F9rBOf+rIee8Ou9FQ+MXXBQY8aG1hyYiBN4z6I9/50mZ7t+hiVkgv5lguC4GBqGQGZ/9p4YE9dbGrSxFLrhv9osF8kQR0S4twEWBXjcJBZ5ScyNYtFFGpIQ55EuA7TZqJgwvevt2z0yjGyv3Qe5qT4H70BHYG75zr6rWdeBRQ0pZMzS2TCaVeNEANXoUXvjqmlqrlj7YNmVkSuz7SHO6nn5S8dqpV4NC7kvGmxV6ahugHDETjbrFh5M7KDJ2C02CiL7FaOGhMhtXxw5jIug0Tugwl2FE2wDdNf81M2NknkGMkwthXh2+ZDUh7VnD/QSV0Ik7vZrekgi6Fy9ImsHQMqyKYHIuukQ1/YHwFVy2BwQGvxVla43CAZKMdHNdj/rkRYibk2qKmglf0vWdWt7SR+M9JYkxuNum8CGV5uL/dw6LxE/NjVx7WRMmMBKwiryesltS6oSIKgFOistIujRut6Rg7ruwuS+a+xcBmdl/N/fVsJbcSV/DRrwbP3EQuz30qeX/MhQ0rWNaVmAVPiU1eRC3EQusEN9ZpkHu2IqMTaYHlximWkvzXWP2Yc03dDOJ6UxqwLMK+xXI2GfloOQR2kzdb62pf62MxPmflw5HyQ4d4gudD3gW5P4zzJ+6+lEskC9Vix9HZAzj
 so2FU6DX
 FQ3l5PbhqMglHqhGh3Kt3Zs920lsSsZlnemFiHSOgWHNf7FYo+4h3SEo19bosOxiOKSGDb1UqDRAWMpyqDB0wEWUkQ4/miKzXFMKNjU2PQ7GiM1vVsNF9kq79MCuyPw13RqdRQjGd/xBUC+94C9gcoDI3Ahg5rR+3D7zjXkZU4JLpO+vn60h3lUnChNmXkUzET5+rNdD2dqL89bAoGwIltp3w9QkkhQHkvzIZdnqC1Qvf06KPccyuB99JspANoKDl/h+m6Zc8+b3WYb+CnDqHSGp3UIAmheQd0YgHQWdAH6sMrE6OYBbNVGCciA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/4/26 15:42, Imran Khan wrote:
> frag_show_print() just reads zone->free_area[order].nr_free, so
> it can safely do this without needing the zone->lock.
> 
> Pass nolock=true from frag_show(), so that walk_zones_in_node()
> can skip the zone->lock acquisition.
> 
> Signed-off-by: Imran Khan <imran.f.khan@oracle.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

