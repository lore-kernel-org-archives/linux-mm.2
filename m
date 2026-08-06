Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 644E5C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 11:17:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75E556B009D; Thu,  6 Aug 2026 07:17:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70F7D6B009E; Thu,  6 Aug 2026 07:17:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DA846B009F; Thu,  6 Aug 2026 07:17:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D9796B009D
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:17:31 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9EF321C13BE
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 11:17:30 +0000 (UTC)
X-FDA: 85070593860.18.961E18D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id D851240009
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 11:17:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Y/8XaT26";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786015048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jZ7iIHed9BBWOwcyjpWS52bmyhKiKTYNkTDaV0MhgEM=;
	b=7WOj7p4cRaKS1WlvJbh7FWPgXMxyOJGuhnz/ptLhd8GrHh/gpr8RQjZI+U0ngkmM0D9wGy
	D2Djrq9LOZPFXC+ssMrZdb14mXvelBda7lrky2ivo9TNTw5WLG5iJfO4ruMltAE2i/CTi6
	gOHp/8IA8Si8RxVOCWSPhfo7S3Ejtlg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Y/8XaT26";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786015048;
	b=nDB6ef92Iesa6HluRk1i/TmxFHLb3yhYhq2H04MtkXHINg/4ZQ3QKRBBGNA1Nw8PlzVxFS
	urzxgHzaqizGLT75r1vCvw6Qxwz5Ci5ocgmz2sIvRqTnsB2IyPnS0QYsOV8pIJ48lOE/yJ
	QyzdDpAJaup3HhALTjCSUmqinLNnJxo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 65B0260A6F;
	Thu,  6 Aug 2026 11:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573D91F000E9;
	Thu,  6 Aug 2026 11:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786015048;
	bh=jZ7iIHed9BBWOwcyjpWS52bmyhKiKTYNkTDaV0MhgEM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Y/8XaT26pjFocUr48dqjGQbX8TwuwKG6ojsCwrJOua3YiCN5pPkkjL1Ox2JBxU92z
	 z3LUIy1ANNPbOUH46OP2E6iN0SFbLv5NJO1PMFJ8TD9L3Gg9mWiXo/+Rqo3DoDV6dK
	 eAcIu303KQiybmxr7EFNXwR/lXPc376E3M2zHyx2cGSwwCphpyALfbhrGPCU8BB6ZO
	 m87Zr90tnodrZGgUnsxlLJ4mlnzu/LJM/7mSgx1+01Wt86uGZPvXlyenXGzj0OsY7O
	 QSPlVDAKiOJDtVx2Pv3nugLDyI3K3XXPWDrciuJCzb2h14Th61V5LGTeNMz41zim1M
	 cGJwuGRcPJFqQ==
Message-ID: <9adb6304-a25e-4658-8fc7-e3a16c7d34f0@kernel.org>
Date: Thu, 6 Aug 2026 13:17:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 00/16] Page Alloc Hogger
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Juan Yescas <jyescas@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>,
 android-mm@google.com, fvdl@google.com, tkjos@google.com,
 minchan@google.com, dskiba@google.com
References: <20260806011048.517229-1-jyescas@google.com>
 <anRRLwa3N5bVCHET@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <anRRLwa3N5bVCHET@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D851240009
X-Stat-Signature: rz87no3fjpr3zg73niw3kfeczkiwdcgc
X-Rspam-User: 
X-HE-Tag: 1786015048-35566
X-HE-Meta: U2FsdGVkX18+K3BmfzroUDTJ1DRl/YEMYMCgGoxSdargVhk7l8htVNrvcXRT9bk6R36qP8432xp8ZKKhMTJYrz+kvkNhONE9LKs8PJn95hNcbizZWxgWUJn5XJqEw135Vh7lSbxQ8PQuXYDPH7bq7YYDdFrbCsZVVOfaqTnDewHb5uH+XWO6C1qGi0QsnGxJFPqACEw0KEbK7l1gIzssJ/ljKhWlob5EomhelsIoYweWqCYsacvJ0MryelnljO5IaFXQ5FS0SO/mf1u5PYybxhfcBL+rep+qXXj5DkzpxbnYob9uUd4Ku+Ce4Q3bETWdaOt6yTlpUlStIHn7oD0sa0/EQZQsJl7NQMs/8reONRVDxj+o5jXwYglXrsjjWtRgLnQCnlcNfclqeeD9ULDhluJV/Cwf57ObNOjRLEUcVfSiFnwrIifQRr4AX5zHXX8Z8m9fbfVY6sBZYKqNNv7a4IIZMaDnogsTek5JmlO5gPgiy7NKtV8GVEGMBVKY46MPB6WZMT5Mfj5yzg17eFi/ciCa3/Z6lv9nnjMBcR28v7d+OQfFmZhla091dqK50xmBJA+fn0hMatrNl/AZ0b2WzCzrDhyISqq7LCnKOi/ugkFDLYqP7uEbTyQ9g4FxxL5nagqTfWBcSwp3i1v41aC7le+31lAsYz6Yt+xqXIPONnlYXx50FEtThvNBcGMDPWK94ikK06fPI+Y08juGcniBpJNxLJdKyChhY1acpMpjKUOfeeit2Au6Mg1pvN372cs6rFQKF2DBX+l8W6hvwYwvBVUDi8CGpZe1zp++BtBi/q8k0aoK480YueA0oQYUGJhLFDaDGneTcSR5liLMC1F+du8QSEXmFgn92kQosDl9sIriqwS5d0AWH5i/AmfAKV8ZU2LjAgXhz/4igh3+pnp+IxX5CDif+4q8HMK+dpcAfpdEry29ACM1RcQVrY/WeGOHgqGxTADcD2y/WqfeW18
 gJI0BDC0
 Ctiz4IepRH+FWolkGuA7OeRLwgJWG7niWwcd3FORcxWVUJgZ3JcCi1sTbDhhH8sXJ5zYLzC66/D7+I+S9pAWfRSZGcFyvFUdPjU1EKXpvX18HrjzdDxSNiIyjdWtQyVZ0/UHs1fTdMfq92jJI+kGaGTxaNuzaTMgB2NJeNRCaEZ33X8LwaNBa15/+PDDMcw++a9JMkYQBpvrHTo51ncemOuJ8ygrmmFz4Xgfk3Dm1pWVtNB5SRKViY3SEvYMhgZuTdN76U5xXzJklybK8GlJWPQcCk61j/cXlPamzo8VjRAidRgxkTVLsYdQIk5g45Y3Ihm0tkkwN7J2xo8GHruOVk+buSsr1Cf+2GE4jCZwwMl0oBnE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 11:48, Lorenzo Stoakes (ARM) wrote:
> Hi Juan,
> 
> While I think there's possibly value in people not re-implemented their own
> allocation injector, I don't think there's value in having this be part of
> core-mm.
> 
> I really don't want this to form part of any contract or to be blessed in
> any way by core mm as it exposes internal implementation details and I
> really want to avoid adding extra maintainer workload here.
> 
> I'd suggest keeping it as an out-of-tree module as David proposed
> previously ([0]).
> 
> Alternatively, keeping it as part of tooling (e.g. in tools/testing) could
> also work.
Yes, I would prefer if all MM-related testing modules actually go somewhere in
tools/testing.

I commented on that recently when finding some of them in lib (and we also have
another GUP one at least in mm). Stuff that doesn't ultimately need to be there
should just be somewhere else.

-- 
Cheers,

David

