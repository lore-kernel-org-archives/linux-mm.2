Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6310C55160
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 13:07:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8D0D6B008A; Thu, 30 Jul 2026 09:07:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3E406B008C; Thu, 30 Jul 2026 09:07:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2D6C6B0092; Thu, 30 Jul 2026 09:07:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 503816B008A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:07:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 73F5A40154
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:07:06 +0000 (UTC)
X-FDA: 85045468452.08.3B218E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 982C640002
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:07:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eaaC2kCz;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785416824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=65J9qMpM5zpfwuBByrCM49o/mlX9umE20iAK+xW9lbo=;
	b=Ka5ML0Lpm3rsLjCXlQpeHBhmLt452U+2sFqLAb/N9XLoYnfYPYRARFOIqvVJa5HeVZ4QZ2
	w/0eHG5I5q8BOcXFkGBobW3EXXXL+JisGh0B7u7tZ3wt9ZEA/4YU3Q/fNoKW6eV2raPLJG
	b4uXwibthBa341vIpJMqHXnKu7yWl4I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eaaC2kCz;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785416824;
	b=3wKP4LUC4u4bFRgSq2vkntM87YIuxkvRMdCFvJXPt/XwDAyf/Kcp3NWvltEaK7WQocAdtT
	mRIl/STdi06GQI/E/VRZpXsdVsZt7Cz/EutvdCtZ3ONgxXiBzAmZ/bR6TA3sKwCoZT2jwy
	0avkSf4iwhpG4aa+HNXvKyP9O4q1IK0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B0934404AA;
	Thu, 30 Jul 2026 13:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BAB1F000E9;
	Thu, 30 Jul 2026 13:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785416823;
	bh=65J9qMpM5zpfwuBByrCM49o/mlX9umE20iAK+xW9lbo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eaaC2kCz6ssFAZ99ZNek0I3JHC185BNyzr5CO3G1TPQfycwOC6k3XfVpIGU+G/cLg
	 TVP/HkX2Qxhn3CB0OlWyEmvtdWQWTfiaTMZiILg3ufr0AEQF5NlYHUYmoazUQyr/L7
	 fDSE38wVCX1k/cIZUa/zzgHSkyxXsiNMW1/rXJkf8GcsTmV4lgCK0RRh15LCtYdc5M
	 iqUnoN7sZVjWOd5cFrD3xTBBdAPc95/qhjspeuOqpAX9YxKfgP/ZuW4pYZygkaiziX
	 mpwZkEYHuVDblSu7nscuiccTFTfyOxaEtROZDIfdblHsxts6z6y+IDGRkMKMZJNzMZ
	 2tvw9UGLSEkDA==
Message-ID: <7f60a20f-7293-489b-8539-847fa1b96789@kernel.org>
Date: Thu, 30 Jul 2026 15:07:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: use proper PTE accessor in move_ptes()
To: Alexander Gordeev <agordeev@linux.ibm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Pu Lehui <pulehui@huawei.com>
References: <20260720141633.501799-1-agordeev@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260720141633.501799-1-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 982C640002
X-Rspamd-Server: rspam01
X-Stat-Signature: d9zxckt6h8hd1om9kqn93wpkcaaijzs4
X-HE-Tag: 1785416824-567829
X-HE-Meta: U2FsdGVkX1/lY56mc6MZTjTdtWNSJpLA1goqi2CsTxDvM2iBHw1mm9jsS5zkroZet28MhoSiMPycEJ+4dWq24fzB3+oqlIJvptAegFonNaBMucTWjZbfgIrKuSR3p9B9w3oKEsbX4RroyaUexKZoDNsZw72+8g8owD8OEVCAjNyLv9vVK+IWGLpji9fFHBu7tJjZRDLMwr3W+DeEqVoyXqCrGeSbJq/uOJEC8U6BqxjhzjdWitn+/zcMW8getrKS+wTgRiD9M7WfhG8dQMYb7jNph+NfXuon+P9CsrHUSj/NPzicCFL7FG76N7JgZ2HpeUMrISbgPGFBz0PayX7ojLhQl7A3xlhH9mZZz2dQv0ZSocGNuiuSg8gLwsz7PICICSmTbDvuZosmfbo0F0KjlaThMXJrDpyixhkme8CZnpucUYXKcA3NO8bqmyOjIIXp0PM4J6waTtO200amxP+uNcFFiyktJaTFYZPxzqfVGdk1/GqOE6zIHpIDTiBPJw0wA3ZooPfok0ODXeVBm+fjMaP200NCdQG8JP/UsDBf0RuqeXNxbbJKRqEpuDm3gENEb/HJCgKWaG4/2AA+DyPHEbpj4IOEMPashMZsmeIE6lJ7C8h7kSMZXFSefjsf677BPVS0KGnsKg4AUOZwOYQoCZz7XiP1sHwkhUGDSDDpHWa8oGGyhTMp0DtseAR/83TDVBpSwz840tVp42UDBQz08o8El7KKMnCIOB8tPqRU4OSU6TBh1cPjRzmzvprQK9AhLFEFxHcg23jMVajHbWyrsNIPgTd6fcS+DwfgKipueL8aOXXdXN4nVth9O4DxuJrvREQQO21hyp6AayFAYhqmO121ctKQz+VzFxyqOPS3JlVaNJuwrHMtEWvplJYFPPJybtvqtYrC2j/eloE+YupUxvMXOayb1qFQ2VfubhwCsboM4e78kHGJEifWJrgurC0ajWRaSJnaUsrSn52e+vQ
 1OCnvmZF
 KgcccqeVRqwOdt8SOuUfpkQqOa24Ul9pIOgzfG2yBOsn8YW59iE9CwEogCb/x3jCCKOYH3jDQtPX2V7C3081vJUbLTj7bbrTu9Ng2ff/AWOZUAalPlZ6AYmDl7gcH0KQT+FGxl/3yulKAQJKacZ0cTXyZyJ4g6+eMxw15Zrd88UvWBG/KsVBb10IllOEGmV59VGkpOuQs/R34YJ+8lo7gYZ2crRwYHq265TtsyWnYOv4y69rplmqxxsBfHmo76p4nzowCQUGRqLrh2fudhBi01Nf8swJMzvTPpg492YVV5NEZImQSlFEmnpVK8tt2VdkAdZ4+/13hTAK/wpMgo/AzaFBL4qlHaYi7cyn+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/20/26 16:16, Alexander Gordeev wrote:
> Follow the pattern established by commit c33c794828f2
> ("mm: ptep_get() conversion") and use the proper PTE
> accessor instead of a direct pointer dereference.
> 
> Fixes: b36b701bbcd9 ("mm: expose abnormal new_pte during move_ptes")
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> ---
>  mm/mremap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 0dfe3de39ccc..e99b19a9850b 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -264,7 +264,7 @@ static int move_ptes(struct pagetable_move_control *pmc,
>  
>  	for (; old_addr < old_end; old_ptep += nr_ptes, old_addr += nr_ptes * PAGE_SIZE,
>  		new_ptep += nr_ptes, new_addr += nr_ptes * PAGE_SIZE) {
> -		VM_WARN_ON_ONCE(!pte_none(*new_ptep));
> +		VM_WARN_ON_ONCE(!pte_none(ptep_get(new_ptep)));
>  
>  		nr_ptes = 1;
>  		max_nr_ptes = (old_end - old_addr) >> PAGE_SHIFT;

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

