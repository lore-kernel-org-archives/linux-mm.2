Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E951F4485A
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 13:29:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED33C6B00B4; Fri, 10 Apr 2026 09:29:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5C3C6B00B6; Fri, 10 Apr 2026 09:29:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4B336B00B8; Fri, 10 Apr 2026 09:29:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BEA536B00B4
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:29:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 662731B81AE
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:29:25 +0000 (UTC)
X-FDA: 84642727890.12.2F8F82A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0DC5F4000A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:29:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lz3e7crt;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775827763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DqL1GrdEAJcl9acbfnmWZiJ733NBeYHp8APhAnCH1ek=;
	b=m0vqRrYmb1mFb0WswiJE/Vy8f6C5pL2UWUPBNUC+u9Sa3CPEnPk0Jlw4EJU0BJCN2f8b9d
	1CCy/ilCCvRoJ6h+HOb6KcJnfqS93+ViTmBk1+cM1fU45KJ6GROvF88afig8wGbhoilQ2C
	Yxd09EOh8N1LVupQdVazgGalHE1w6iU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lz3e7crt;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775827763; a=rsa-sha256;
	cv=none;
	b=QrLOLlQHHhY/D9cUwf50BjBaVtAeGLh9OkGOUQaMWobT3tNCLZTcU/CGwHsOXHhtzoAy0r
	1vUw2D4dSiU020slKNa8XTnS/cDsmupJJmXMOSynRk+VEB6Oz/jv4I6ZEZ+kC/AwaSyKMt
	+28r17sYG1Rrf3c2TIZoEhFHId7c5LQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D8F7940728;
	Fri, 10 Apr 2026 13:29:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347F1C19421;
	Fri, 10 Apr 2026 13:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775827761;
	bh=BGTVhOVa+Fdq7E52HiKwBfIFKgu77QwjCb2aXOQf+Ws=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lz3e7crtUJ7MuP6SM2Vx3dNuc7GOeW4ksMX1JVpBZY0vOH3PfyBr/8ho2CDhwu9nm
	 ojGoibQSGNm8/3W2av8EBOabOBZdX0DPf4dmTgWp1beeYIK03Q/pUKcx0LYuE11fgu
	 kDGFZ4Bof7AAQUUtXjLoycQKPFY3ZLvSDzMQxRnPLUut0+TUHENXf3DDwAB2hCgoEq
	 SSUT00TR1RUZyfzZJWbdBuYu+iV0qRuXh7YXt1RQnlyHMxa6tjvVTbPeDwRWKMdi3+
	 nmAPqnMaJzMcITQMPPShhTDjBJUaP5AZhvJYbXHmUed3/UJ1XC/SFkAQA/rCp7K/Cl
	 +M3elzl8XckDg==
Message-ID: <40f31e5a-7161-4b17-af03-52b3a28a113e@kernel.org>
Date: Fri, 10 Apr 2026 15:29:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/4] mm: improve large folio readahead and alignment
 for exec memory
Content-Language: en-US
To: Lorenzo Stoakes <ljs@kernel.org>, Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 willy@infradead.org, ryan.roberts@arm.com, linux-mm@kvack.org, r@hev.cc,
 jack@suse.cz, ajd@linux.ibm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, brauner@kernel.org, catalin.marinas@arm.com,
 dev.jain@arm.com, kees@kernel.org, kevin.brodsky@arm.com,
 lance.yang@linux.dev, Liam.Howlett@oracle.com,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, mhocko@suse.com, npache@redhat.com,
 pasha.tatashin@soleen.com, rmclure@linux.ibm.com, rppt@kernel.org,
 surenb@google.com, Al Viro <viro@zeniv.linux.org.uk>, ziy@nvidia.com,
 hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
 leitao@debian.org, kernel-team@meta.com
References: <20260402181326.3107102-1-usama.arif@linux.dev>
 <803a0c15-0a6a-4c00-b6b3-eaae56d5fc15@linux.dev> <adjkCOiLgZ_-zovg@lucifer>
 <adjllNan2vgBNBHJ@lucifer> <5f99b289-629c-47c4-bef0-966d6678a2a8@linux.dev>
 <adjrKwgiZwXR9epk@lucifer>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <adjrKwgiZwXR9epk@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0DC5F4000A
X-Stat-Signature: km7kfadd3ggfoox78kqwcon8pgn6o4kj
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775827762-547926
X-HE-Meta: U2FsdGVkX18ou6JOU7fCLzVbcIvBRY+/KjDKmye4auUpXekg2kWF/ochrqRwHbCnLRWzVwFafClKEshMrUwfVXMD508Y6IIkWAHe+Lk3kRvKZEkNEkUjWTinfqxy6Pm2BYj0pzoAOTpCCJsVIh8OA4XJtHRHbVl5vGMukDk+LWvt2Dgk2LlK6lmHrrLAe0XFVzzLUJnx6bYubuIFgG+rMdrs1VU6S6/31+pBCDRMBS6beXmCaPsoqVWJLxTAyvNnNe+C8exQGU9OkJEpY1WWb1xiRMtXLySVOzc3FjqMafGTvgX7CbP6gS8ymCwhK79TIL9dWTBKkMe42mH3B4FnfStNQu++Unv49bYnA6aubbLsQRHG0eFQVO2T3u6D+OjhlOApM8FcR/VcPRkhQrkqAn3KBP5nBFg3I3jTLeeXfpyu5PpHKdao2w+I79hfufd4/hYo5rNvpGS1+pUi9kLkoCr+tiuKskG7r92+aDwjDdNngr1vz+acDG7SIiTFaiKYetnfCCxa9u5uTV6ry2jApGtz+6uBnWjh4ZesYTDy8HzkQYtNk3hyoYIiR2cQ1UX+689n4+3MBUEdmN6rrUZU8ceFyu1vCS6wENK9WFYEfuqNvBvHDWe0onmi/PlMZ6pwYRTujHRVLSEPhCBMVzj5N/GrzsIShxQjBlTSEyIXDAdnv/mzk/53/s9FJ3gurSon5+Gr9qhroqaqrcU8lVPeXMTjkTNNsgRU1yNmoelRC+AsbX/lNdylmINpd1yD71rav1A6t+09wxwE/BWTe8t8V7Pb4KoKNi9WoThRMElrN3I40SSeX0RqgrkYpmLUasEbwtlDcOsHkWnYtJow18M1GEIEZjq0Ikjw4ofM+JtwbZ29XdQb6V9EEFun/8+dogmSM/YMI5yYZdIPc1mfzfj7iib7d7RElD1MjFd4yEUav1qXnWIc8EVxngXCLRNeJQ8MWzyTdYzc02vSQIl87a+
 X5E7+cvo
 8H21MNRr13a1305+mIGzZefM4viN3DIJRmG5VPTmtLFXf8dmObgYUf14ABmVUV1cdgy7QJdPZXnyDFws71d9zz+ZpYOisLiggx4A8C0pLAxIb59+lEKFQfkAMSezqxkwPWy+iRtKrVFoyeZNqc/HV9R0z+kX3UIFggKfVGqzdHaKf0WFqiZ47IqjCvy4iQBHDKOcWmRNOUfCjExU3NZAPxbmYQj+1mWRnSjvemeNftKhXGeQD9wCV2OPLhj77cbHjGv5f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/10/26 14:24, Lorenzo Stoakes wrote:
> On Fri, Apr 10, 2026 at 01:19:08PM +0100, Usama Arif wrote:
>> >> Thanks, Lorenzo
>> >
>> > (Note that we're in a 'quiet period' from here until -rc1 of next cycle and
>> > won't be taking anything new until then. We plan to do this from around rc5 or
>> > rc6 of each cycle in future).
>>
>> Thanks! Just wanted to check, as I am always confused about this. Is it ok
>> to send patches for review for next release at this time? So that they
>> are in a good state when rc1 comes. I wanted to send PMD swap entries
>> for review after I am finished testing, but I want them for review for
>> next release.
> 
> I think different people have different views on that :)
> 
> I mean it's debateable whether having a glut of new material on day one of -rc1
> is preferable to having a bunch come in that might or might not get lost along
> the way :)
> 
> I personally feel it'd be better to send during the cycle window rather than
> before but I suspect others disagree with that!
> 
> So from your point of view, feel free to do what you like, but maybe David +
> others would want to chime in with their opinions?

For me the more important part of the quiet period is that patches can't be
merged, so there's less urgency to review them immediately. So I think it's
fine to still send patches, but not having expectations about quick
response, as people might be taking time off.

On the other hand it would be better if new series could mature in this
quiet period, so there would be less work after rc1. But the key to making
that possible I think is to feel less urgency/being overwhelmed also in the
non-quiet period (rc1-rc5/6). Then it's should be less necessary to take
time off during the quiet period. So hopefully we'll get there through
involving more reviewers, and by having more submaintainers agency.

Vlastimil

