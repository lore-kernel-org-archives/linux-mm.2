Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77A1CF43683
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 09:52:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA2106B00CD; Fri, 17 Apr 2026 05:52:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C790C6B00CF; Fri, 17 Apr 2026 05:52:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8F956B00D0; Fri, 17 Apr 2026 05:52:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A639B6B00CD
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 05:52:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4655113BB4C
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:52:43 +0000 (UTC)
X-FDA: 84667583406.26.D270102
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8D3AD180002
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:52:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RcSHu6Wq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776419561; a=rsa-sha256;
	cv=none;
	b=LXoNeGFn+kDw7HXXls2XTDHCADKcHh50yvoksgCPmMoYOqJFKcO0nM+BRm/s+txDlaPEq0
	xpF6WXvUgbOP6cguMrA5kYx+cgeafxMa+UDdWJB/+UxCR1AEiMONkTbm8fIHVh5Vs2FYY0
	zwcUO0LXzH/XocaWj2vIRyVLtk+8WhI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RcSHu6Wq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776419561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YzAmKfJ0lEJCZVu/5sGn/kCGUMojIgqdajX4f/xhCN8=;
	b=O6jACtQg9+ORE7rZ4E7/iByq3BkOq8KcYTG1QQeoHz5c5KTc8VfnZmFJDxVefODecyCkA/
	jOaaZV+0DzpCYYZZCZ93NFxJaG7z1Re5PFcX8wZpwi7P5Lv/nFVkcthD8pDJVw6EgpRD4f
	TMvQMmDfeqV6dS6/Q/EHRFZrnFkxcIY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F292860138;
	Fri, 17 Apr 2026 09:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C7FC19425;
	Fri, 17 Apr 2026 09:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776419560;
	bh=S1dWoomNg7jU2+LlZH898XUljhPwIL130Eucg4xZC/E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RcSHu6Wqh7GfxjLFP0/VIaIK8sPxC/5pSCoKoTaO1OtdwBEtK1Rq8iC6lJY7+G7UF
	 yMu4MaTe9Ss4SDyRA3OHEB+KaZqikGhh5oxqUOiBH1jQrLQMSxbSJ6vzSQwnJgxpT5
	 I+wbHAXPf7kGvnpQP1ILZmxclCFkuuSkv5YwYRnNGlyDeiWKYeHTIxstt7q5iSkmqC
	 OZcIw8o1oBZX3pQkmZTqi7o3AR4r9OIiNSi+93CC7iajjuuLH59XJxSsgQK7nlEsWI
	 BZL3BYJeFjlr+G4LXHYg9G0MG3Le9UXWQ+nVkoHvJbhyLZS9MqhA5Na73kIHh+SE2K
	 IwdyUEsgi0PDQ==
Message-ID: <ec6aaf0e-90c4-44e6-97db-041bff8644e3@kernel.org>
Date: Fri, 17 Apr 2026 11:52:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: shmem: always support large folios for internal
 shmem mount
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 hughd@google.com
Cc: willy@infradead.org, ziy@nvidia.com, ljs@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <26f954be62348591e720c4e8b7a9099b74dc1d6d.1776331555.git.baolin.wang@linux.alibaba.com>
 <1b3c0401-6d10-4a28-97c8-8e3858d8dc3d@kernel.org>
 <015de194-99b9-4f9e-8c89-d35807c6fd08@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <015de194-99b9-4f9e-8c89-d35807c6fd08@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8D3AD180002
X-Rspamd-Server: rspam12
X-Stat-Signature: 6shb8dwxmtxhh7xy7q8ejmothq3q6tra
X-Rspam-User: 
X-HE-Tag: 1776419561-946103
X-HE-Meta: U2FsdGVkX1+qtrDGA9VZOI7W4kQia/nAnRfaI+vL2pwLvJaARiIYsx2Ga6K7570QpaNo3y98obHb3N41Fz5DdvKn1I4ILDcmmzlBW/jk0ShJWMw4uTurbYLsGcOYOv3G3Jvwgc3VKwaEL24trMg93Epde7s+OyuHxyZIZb/gUBhxRJxGw2o/+idzNG7HQgXWmjeyMJZt53BPEBSg9tI5rRfh5cqeV6lQd9of4yls4s6+GIHxTVwDv/nNlgnRyczAwv0z0KYnjVXUgVG8fBEKFnk2CYCcaPPZiP4cUtuiQ30wabTnChKfY/pOz1v/YArX8IZzj+/2/JjdzMTbnXWz6Bl/ftVcOmoMMFVYtG7DNarloeTeqQ9BPwA9c0XG/3zbsr44PmQOdARDVckOhWQWhgkLLMt0xbD1HtZXe0oQy2E253MHughckzcFvYX8rZkZL4+Eo1tHPGO8Itgl/oFS1gLwSWr0NtUJvs52nSHwaCIQiDLFIxs6zLRa7LMyzSOUsfxbo4ieERoB8L/ftGOSFyWF7o6wpNUgH4wdlyy0n8YFg+l4NiS6f7Tysz1Vv0TkiQeMFfMX2VS7FinOIZ9Sxd3K8G858bwYBmufC2SdKlkmwMWFbZk2Jbmd7JrucH3XZBGJyCCEZhJoFaE2RLiZtUB7r7coKCWtKhg/N/4776s5LWTI/tAdAFyPV0tO40E0goVWcgVKhqV4DDFsqIZOM1nrGcl3RhbUD3/OaHR2KQVh3izRE6m98falnZUG4cwp+4XvetmPVKKzife18nzwnX5++sjs19gppzmDOsee7WRs4Xl+4DhrKauJ1wJdVB9Jwv8KNNmIZhoWoyfWZCA+JnmkDcwQIU6hQ5aUca/S0+7zbFHpnWtcp4hfQOESY6WqFqL1ZGh0oY5giVlTtDaPGHM6Fg+b2/2Gw8fLw2mgKkICWuPHKaPgV+TjBM3+51k+DEpGjbaeUBFwWDA6+oQ
 oMOXuGnu
 no+gqK3u84eZBVlunnKZPl9mC+cGdlaDJTBZiurgO5aoBslTyU+CX5zfnXca82j1y/XIvEIDUiATkiLUEPYM1CmIfv1Vjr06YliI0HDAtflQjbIuMA+E3ROFudao+xQRAGa1KAB5hoTAsv1Hc2KS4phMi3rA6fwsv07XQsOzzoAJH9xO4oMrcKMLkJCUjQKO1YJHTtajOPNEUWBsWrVhHawvnwIqauNQPp09y6o8AvP6kp/aINGFS4Up8w23MD0smavBP1S5fXV168I/t4pLPZ4PBJ2wbw3KjLuuki/5vbru3n89Gg4UNcGqsmY0lwVb71p64plqdDg9wfek=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/17/26 11:27, Baolin Wang wrote:
> 
> 
> On 4/17/26 5:21 PM, David Hildenbrand (Arm) wrote:
>> On 4/17/26 05:25, Baolin Wang wrote:
>>> Currently, when shmem mounts are initialized, they only use 'sbinfo-
>>> >huge' to
>>> determine whether the shmem mount supports large folios. However, for
>>> anonymous
>>> shmem, whether it supports large folios can be dynamically configured
>>> via sysfs
>>> interfaces, so setting or not setting mapping_set_large_folios()
>>> during initialization
>>> cannot accurately reflect whether anonymous shmem actually supports
>>> large folios,
>>> which has already caused some confusion[1].
>>>
>>> As discussed with David[2], for anonymous shmem we can treat it as
>>> always potentially
>>> having large folios. Therefore, always support large folios for the
>>> internal shmem
>>> mount (e.g., anonymous shmem), and which large order allocations are
>>> allowed can be
>>> configured dynamically via the 'shmem_enabled' interfaces.
>>>
>>> [1] https://lore.kernel.org/all/
>>> ec927492-4577-4192-8fad-85eb1bb43121@linux.alibaba.com/
>>> [2] https://lore.kernel.org/
>>> all/875dc63b-0cd2-49e5-8b0d-3fb062789813@kernel.org/
>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> ---
>>> Changes from v2:
>>>   - Always support large folios for internal shmem mount, per David.
>>> Changes from v1:
>>>   - Update the comments and commit message, per Lance.
>>> ---
>>>   mm/shmem.c | 13 +++++++++++--
>>>   1 file changed, 11 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>> index 4ecefe02881d..769ef37b1ea9 100644
>>> --- a/mm/shmem.c
>>> +++ b/mm/shmem.c
>>> @@ -3088,8 +3088,17 @@ static struct inode *__shmem_get_inode(struct
>>> mnt_idmap *idmap,
>>>       if (sbinfo->noswap)
>>>           mapping_set_unevictable(inode->i_mapping);
>>>   -    /* Don't consider 'deny' for emergencies and 'force' for
>>> testing */
>>> -    if (sbinfo->huge)
>>> +    /*
>>> +     * Always support large folios for the internal shmem mount (e.g.,
>>> +     * anonymous shmem), and which large order allocations are allowed
>>> +     * can be configured dynamically via the 'shmem_enabled'
>>> interfaces.
>>> +     *
>>> +     * For tmpfs, honour the 'huge=' mount option to determine whether
>>> +     * large folios are supported.
>>> +     *
>>> +     * Note: don't consider 'deny' for emergencies and 'force' for
>>> testing.
>>> +     */
>>> +    if (sbinfo->huge || (sb->s_flags & SB_KERNMOUNT))
>>>           mapping_set_large_folios(inode->i_mapping);
>>
>> Two questions from a non-fs person about the semantics here:
>>
>> a) Can sbinfo->huge be triggered later, for example, through a remount
>> (staring at shmem_reconfigure())
> 
> For tmpfs, yes.

So, we could pass this check here, not setting
mapping_set_large_folios(), but later someone toggles it and we missed
to set mapping_set_large_folios()?

Or would we always go through another __shmem_get_inode() after a remount?

-- 
Cheers,

David

