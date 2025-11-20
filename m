Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78626CF8859
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 13:41:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D451A6B007B; Thu, 20 Nov 2025 08:41:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF5956B0088; Thu, 20 Nov 2025 08:41:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0B216B008C; Thu, 20 Nov 2025 08:41:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A96BA6B007B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:41:30 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5E3DB12CAAF
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:41:30 +0000 (UTC)
X-FDA: 84131097540.03.9316057
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf04.hostedemail.com (Postfix) with ESMTP id 858FA40004
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:41:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MRYO20LC;
	spf=pass (imf04.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763646088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iiUwXuDwPsPo8P/JiH7Rc6iuaehlzYW3mvFReb61JcA=;
	b=M51Gvgv6YaYcDicHqZm8ZBe5/GJYUZAKPwOp9ykL6JTYOvm9TS1JGL7rwuwd/jalPuPuhD
	NX/t5mZqnITJlh8uvK2SvpuUQXMmFQcIUCqOlGTFj+UFWvfOnXiph1DL8DbPp+6KZlE5VL
	yOVnDJc4uPk6djOgF4M6GEjMAthtSkY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MRYO20LC;
	spf=pass (imf04.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763646088; a=rsa-sha256;
	cv=none;
	b=EXmZLRzQ0qeT0JbYF1wPwDTWJMQiREDQTywJH/TGhXX2LLv52kFJp8uCNopmp+3D2CobHe
	NoN4BggaDnBuUmF2FkskV5czpmkHMYGBYMwgageRFHjNeAhArsd9F/PEyoW56xhFkUTn+f
	2kfp7tcg5LDMhjBd70zyZyOtMAYd0q4=
Message-ID: <fa71b2bf-e08e-4991-a821-51c6f40e9a90@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763646086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iiUwXuDwPsPo8P/JiH7Rc6iuaehlzYW3mvFReb61JcA=;
	b=MRYO20LC5Fn8ysYUK9k9irRH7GumJAbF7J9zObagPMYZVTcIKzaUpwAffATPRR0rSEby4B
	ohC0GJrFXrjXJIGTa6kWudW9h2GgghJHUJxrANhQg/E1dpccoCFh0uDl0mIVpojt7IGyP/
	6ZoSQQZNHbd7kPNULpfCrJ+wb9McQQk=
Date: Thu, 20 Nov 2025 21:41:15 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 19/26] mm: swap: prevent lruvec release in swap module
To: Harry Yoo <harry.yoo@oracle.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <c8b190b1b4f2690f12dee0e334e4c0b3f94ad260.1761658311.git.zhengqi.arch@bytedance.com>
 <aR7k8oFb_uZYj5bj@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aR7k8oFb_uZYj5bj@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 858FA40004
X-Stat-Signature: cgbir416gt1fs5pu8prunfycmchsaxp4
X-Rspam-User: 
X-HE-Tag: 1763646088-653893
X-HE-Meta: U2FsdGVkX1/iGHe16YUbsrrYeRw/U5eSnxFTb2n18pW1M4VX1ZhIshuz3TCdP2MtoiOTVb4xuG3QffpOYrgHAMLPXH7pmhLG2iOUfuSWIwCnzHkgIDEpiWSrgttPzB+lzBSt+F4qLsfKR0iHeOSD/GfON1Vpf0lJI4SKv/FK6kda6dUWker0GryZdnuOdAicRIl7pCsoMkSrvN4ybBtZ6BpImb+IDMIH7OrFPxiaCM6dNCuNz274r1grRfkmnk3ylqUbnHUP6Skrixp3nS4sxFV3oxR3xiE3Y2PYXDmGk5Fy7z8EFZzEU0RyAooH4sTCJ7JxooFKYIkmjqAO1FiZXRYz2R1DULy8vVsF8WfzMJfyhQPGh8JokVaSMnLvEmgK9q9/rZ0uRA0QXvZkruHR8uN2NCM+CkWRfbnEGjSO+ufFxpq/QEnPF6hlHn5FFuYqrOL9G2iaS2Bmp9QgPW/i9inG9A/BIBYYhScAcex+LjnDnNmKG/OjIBbd1mM8Nz/nocsRkifIwfxdi77XYm+F35XR6aLoy87MRctXYEJtsGox+mu5xDDLqrLrbcxlOIztYtFdwBGZCCzz7a5bF+FygfmXjRT2DriJthT1Q01x4CCrUp3be2N18vIBHDfR2fNLrOb5s1Uq1GzDGablKIdm6Ws9LHl7j7gHh01vRvPK0r2/awTAJlXkBqN6EYBMFkVsjcFmAmmYv4WAXIFdz/R59brcn0jKFR9iJ3xnqr6Hfzdnyzos5Zi9hhPGhHjK2EwfKKNUdHRwDWVDojIu3ZZxnNXtd5l+CTUW8dxdL40V/mrGYfs/u0vj4wqR7zTHdcE3jt6+5hgfiu2X+oe2wLONbISfUfC3ulWEsvkfb+sjCnMITAlqbF5EmZuh2BH2d7Q/n8sXaUCSrALRXovRx+ASDUeZduHl+QJogF9REryu6A/DLdegT8nFEGE+DbjqWrosq9pN+HdjrRr+6nJdKpX
 +TjorYoi
 HLqsHkogpM4dlRBB6AVeWtmLpgJ+iZK3rsJo4VTNDGgELttjM4vUxjNqjZWFIoHoPT+SkKu9M0hl+D4bKS+D009vZ6ggn1vJs0fFfQS6uvomMli9CQuJ8MsUsy6Zks4cwZT+qr4URcGyZ9jTbTyOvpf+E2x2DTYt26utUt/pO7veAuB9nWIddEDDjqOnFETTIneSUZdZx+EXUYLzeT8PY36rDmJEu2sN7BXHOY2LJi6PMb2uc7CLV/9BP8k4DBPjWDRgB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/20/25 5:52 PM, Harry Yoo wrote:
> On Tue, Oct 28, 2025 at 09:58:32PM +0800, Qi Zheng wrote:
>> From: Muchun Song <songmuchun@bytedance.com>
>>
>> In the near future, a folio will no longer pin its corresponding
>> memory cgroup. So an lruvec returned by folio_lruvec() could be
>> released without the rcu read lock or a reference to its memory
>> cgroup.
>>
>> In the current patch, the rcu read lock is employed to safeguard
>> against the release of the lruvec in lru_note_cost_refault() and
>> lru_activate().
> 
> nit: the above paragraph looks incorrect.

Right, will fix it in the version.

> 
>> This serves as a preparatory measure for the reparenting of the
>> LRU pages.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
> 
> Looks good to me,
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Thanks!

> 


