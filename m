Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7722EC61DD3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 00:06:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 739E26B0088; Thu,  3 Sep 2026 20:06:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C3AB6B008A; Thu,  3 Sep 2026 20:06:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58A396B008C; Thu,  3 Sep 2026 20:06:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 302526B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 20:06:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B248580664
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 00:06:12 +0000 (UTC)
X-FDA: 85174137384.23.D48067E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1C1B1100008
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 00:06:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iQqz0yLp;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788480371;
	b=LnvxbJy7f/F8wv2uVeXWdI0ODn4CqnI9Zba0YnXUUm9A7izce9nb2yEZfvn7ggZEYTU208
	E9EWMM54rNxgLMJ7P+VhvcefO/bpECOmtnF957pjxjwOE5dAPoUNrYZtSBPBdUf+NYto4v
	PwgBzPvhmyme86kilU3YBvoL8bgUxVs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788480371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DAqrTyyalVk6hMFOjupnL/nVpoH8Trr74L0HK5s083E=;
	b=uV4pJWRXVNyDZTJL+J53OQUcrLLYRScTEavDkVstYDefuSM7y4bJgIzCuRgYsT3Uu1f9mf
	FgiZLpw4qIgDcQbdJvL8Tl57T2Z7He6GvPn9GnDxE3r+o/8kasSAt8KjRab82AByLIezDe
	JwP4Vp+TRK9qB10yJJ/3Oc8gohDd77Y=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iQqz0yLp;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A35E160234;
	Fri,  4 Sep 2026 00:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DF11F000E9;
	Fri,  4 Sep 2026 00:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788480370;
	bh=DAqrTyyalVk6hMFOjupnL/nVpoH8Trr74L0HK5s083E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iQqz0yLp5Iu0SyAe6Lwf9Z1TOLbYKepCy0S830iqWpadqZXJ8QnO/GlV7ad9XdbiJ
	 8gEm8nODDu2z3oVS8ALswbSprcwlDWiAHNw0HtojITt3VnhfHg74lLCdcC+K6LfIHk
	 7HIhiBh1ffjdOmou20h265ublqJ/VH+wiSarVBu624w//QlMWhDp9XrWyo+OOmGBSo
	 iXLABn5O+mkG4tijSioUtLqzGWMlWWeYCCxo8YzBTJnWq27UJmE8USCsF+Tr8Jr30h
	 LHoxXQ0VEqIihNI8cBgsWoBrU84SDIqG0NhYB6cUorInaiJv3F616B7P63Lcy9KGMU
	 7MaA5gpQEy3ag==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/memory: fix hugetlb_zap_begin() call in zap_vma_range_batched()
Date: Thu,  3 Sep 2026 17:06:00 -0700
Message-ID: <20260904000602.24574-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260904000028.149656-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1C1B1100008
X-Stat-Signature: 4y6n5879ozohruweraceeds9a4qtykwh
X-HE-Tag: 1788480370-494827
X-HE-Meta: U2FsdGVkX1//6PSDCXcX3jrBJq8TU/CxmFBbV3WtESTCnNYTyPKyH1e/ntlUDiFQXPuIW71Fi12bUrTuETem5k503IWGoqa5Oqbf3LJ6m2Rps0miekf5MP9L8GaSW3w/YNrJJ65bTF3RLU00iE5BE3rG9/9NxQphNjmzhO6n+L/o2hYqu4b1QtO9pCATRhpbnCHrHuqwiwQjSuZJBqNJMJAqxuGI11k3Pmt8PUqz9yfqRwdhDvnAREZjgnZr7aiGzocMU86QHs3DRNxbugM3JJwS0YEC5akIvnWIy4+awpaX2oCBHkIYl1GUHOVimEaGJs/0ZQvh0GnehD/jDikQu4jUGzfRLC/tMQvov21/ormVDFPKvuC6eakb44NxJqXMFI/bvL3Jzd2R6i9qFOIcuWrXLlvINvnsuvJ6UsRtBVAWLtPg44QbkeHqC+PFb69Gy7ImBy4u6qCewmpYBPoUFgcMo4WDLVbC6sozphUkhzhzp8dmLK9VhjfWI9bB/riMOATa7UZssN8+WEgHJ9HukFhi01UAH4Ezs6BRwzIg9DGBJ5DSksjYkxV+rWyDZ8cZLUIpODVdOQ0u6XB/yBcE5X+j/AmMDFQuiEVl32daapH25ikYXJacQWvE3PNhO4tY7BOUimEp9DnoWKtJ987vfgXlGYdSEeEo/63peh0JnYREPGnMbeGkkcaPKyJpgAVIOMQXafcMGy9fhuV5W6w+u7Hvdu9U4XmS7jpWeuO0htd3BkmuTBmOaNnT7/gUDsh2RxO18HEK8pW4sg2D5L5LEM7DBEaqNiNdNCJNrqeYHQi7rlek+xGzRZjMsomkwRHZ7NtZVHqUgQEg3pO0ELunc9d1+NxX4aLTM7YspjinkukI3E7SgMbZzy22Dy9kb+SbopSg01PlcQKLzserbs9NuDLtZXdMzoLkTbqJ843qas30B0gl9F68Bjgs7yx/1srLjsLAPsV5qntLfNug68t
 4k9U/UR8
 Syr4jcIcMz0S99UGQlBi4Ht+nx09rpIlYyNYBB9+xKaf19lfGYTLqJ1PN1z9GJRD0mAOzBYPNeB93NAnZ+/fEc8SIcFzVHyazAf2xNTZSn3l6pdo8XM/lQJw7bLFT5kzs3C2COrS+A6raLHnA7ieYLrzeM+9rs9WZhS2iM7/n8d47PG40LUlw2fmTn7Hbk5FBKKS+wMejZ+hUcpZBaAOu5Y3Tc90yhDpKTy+g4ZPklSbU2s/AGut1N8v55x72WYm6UJERviXNCkUfa3wjRr3oGmivh/UxBnD2j1Ld9RVmG5WommPxRqQwj2B/TA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  3 Sep 2026 17:00:26 -0700 SJ Park <sj@kernel.org> wrote:

> Commit f1fc44daf618 ("mm/hugetlb: don't lock private resv_map during
> final unmap")

FYI, this commit is in only mm-new.

> added zap_details parameter to hugetlb_zap_begin().  But
> the hugetlb_zap_begin() call in zap_vma_range_batched() is not updated.
> As a result, build fails as below.  Fix it.
> 
>   CC      mm/memory.o
> .../mm/memory.c: In function ‘zap_vma_range_batched’:
> .../mm/memory.c:2308:9: error: too few arguments to function ‘hugetlb_zap_begin’
>  2308 |         hugetlb_zap_begin(vma, &range.start, &range.end);
>       |         ^~~~~~~~~~~~~~~~~
> In file included from .../mm/memory.c:48:
> .../include/linux/hugetlb.h:253:20: note: declared here
>   253 | static inline void hugetlb_zap_begin(struct vm_area_struct *vma,
>       |                    ^~~~~~~~~~~~~~~~~
> 
> /* TODO: move below to commentary */

Oops, somehow my tool didn't process this...  Sorry for noise.


Thanks,
SJ

[...]

