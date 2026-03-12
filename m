Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EC05105A594
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 12:51:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDDF16B00A0; Thu, 12 Mar 2026 08:51:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBF5D6B00A3; Thu, 12 Mar 2026 08:51:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC1F76B00A4; Thu, 12 Mar 2026 08:51:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CAD1B6B00A0
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:51:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 79D6A88CCF
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:51:25 +0000 (UTC)
X-FDA: 84537396930.09.ACDBCA5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id A268E18000D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:51:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zccl76K2;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773319883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RTRCsZAFFJSRLJa1K6H6chohv5V8uIDxYWOa3L9QHs0=;
	b=IUhweOiEtwPBw8dN0AL72DVZhxvrqWsLTspo2o2BSk3ZBgov3nksfMfAzU1nFiyd7HbAKd
	7W6hJkMIvftatLP0RnEBYwRoNnBOXPf5IRrV8bgQCxEjbIOWfufutvB9+hvPpTgNN9aSfo
	cNaD06J0irSlIK5TveBwbC8lCGeT5uY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zccl76K2;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773319883; a=rsa-sha256;
	cv=none;
	b=YXawAZA635wBTGAZCzFYffeOlZOL2xPXzvEe68SzkvPoPGzzMbJkTDNVH8CL8cMUyb7Yjs
	z8h5CjGfhsW7DMrKhhIbSLKqzVCKAzCcWsMrcHUi+GGK4tDHiKIXElLElnPaT450SqYikk
	9WFkfa17o4FGSbcOBxHhQv3ZdsotkWk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C7C8143434;
	Thu, 12 Mar 2026 12:51:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09DDC4CEF7;
	Thu, 12 Mar 2026 12:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773319882;
	bh=1kpMZraSaSMBgHci+UWZJQCGccw/Ih5urfcrHjXWRuo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Zccl76K23ZyjOTqBoRuG3h640FWnMaYDV4YXH6pFpe8fOT1jSDLWMEzuUmYOir+ic
	 B+atD0jT7wx4HOMNfkvQmgdtgrUzl776vQhDd8MAJOkpUmo2pLQZYusbS6lqptRJG2
	 6o4xAmYmITc+e8ku774J8YwlBWsWG83O9LqhJlaf6t47Gfewydo34zibHjXoM79Tjz
	 EWzZsE5aNBvRWUzwVBkVoFpZ/UIemoy/UHwvGzsly8K0py61/DH1WjW2LBM3u/+Lue
	 IiTXkuftqxocsLKfplXBeYu8/+O6aY5xRsoFGNwpmeHEHOLRzR6ATRB9oJ0HJjOygx
	 RKEM5XpZk9fRQ==
Message-ID: <48274386-34b7-4a4e-b924-918b8813a281@kernel.org>
Date: Thu, 12 Mar 2026 13:51:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/13] selftests/mm: fix double increment in linked
 list cleanup in compaction_test
To: Sayali Patil <sayalip@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>,
 Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org
References: <cover.1773305677.git.sayalip@linux.ibm.com>
 <27390ade4251d1f7f6b846bd5836fa79dbf285df.1773305678.git.sayalip@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <27390ade4251d1f7f6b846bd5836fa79dbf285df.1773305678.git.sayalip@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A268E18000D
X-Rspamd-Server: rspam08
X-Stat-Signature: 6irnofurt4qjor3zx54z87sgih8b5jpi
X-HE-Tag: 1773319883-128340
X-HE-Meta: U2FsdGVkX19Ru76ZLZwFDbBk0dVuc5k4goMZ5GTMLJDmHCetyh4GCBcwVZeoGtBRioZz+PX2MnRfQCFZfdBrBsJ9Q57lNW1/I+bI4EAr7Y/KUsGsbnxfGt+iHWRr0DE5jOs0iGNBC4qtxXen22U2o82NIWU8eTb7bqz/e8DXwGq7JWdqQa7mEONeb0b2eOaIA57bywLtf6kvZGu4IOu3QT/raSv9r82sCVsG79HFa6ishikaSrow9Gq5dAzapv5h8oCmRbVEvIA3PJtWKvehu4CBXqQE15WUtCJeVYUjXXuGzEpNr2y17+66Te9iswdZR9KU/WJpGqxp2vJX/vafEGI68KL6MTfxMonjOl5RdVuZthrrX9LXjWntbgT8ZKXIMpl49kyX2rOEtLXEejFYUGkqu3objyvYbQTla2VkvT/iNrmAEIN9ftNh9QM01enJjfideQ71qxyAt7e40lmP5DizNp0F8JB1W99OT+cCUQEV+p09UxJaIqcObbwqqf8HUw3acxTbGJCH10QvZ6uJxQCO1ocdGdAOFfFGeOEoPvcr7PJHZnlrOHQxhcl3wDH4L0SnM1Hlc6/H+apg/Yhu7LUMzteguyq6iP2zQ9g2ZeK6kDEKf3vUc4psRg7NSLNPEUT8GDjqiunqP3iYQW0xyhIP5l4U8NceQtP5CG3xaLHgvz/uwQQwLlfkAWTPGpcDPnH7+QEltaLGA2GNMREHnbTm5XhXSUJXUpyHylG31CWP5TXq/YuXsi+s4cIl4ddrZXSTKCviGJJwOCdaAimilxDv6P5EkfEhUFGqnChaa7s7fJepX39MufM0H+4AmiJPbiuukllSVzfSN4U9+YTm6XdD0feDD+XCSaIV98tF8qcXae4M4ppOtB6Br5xSp8JeBltiEsfqE+a5FUflqQagZiYHBItSr0ktpgE2hDYCZEcllcIespr7XJEEShArCJ8iGmtJ6E8mD9gXzE2Omtu
 c6ICBH7Q
 tBF0AfwUxDG81I3MnkI+kS/hliuMmZJkq0cFiM761zAW5gdNopzvwYTuCMR2IBtNCmNBa7Ltpemf9ZA6RyLNCnBiXwJtdxvVuqkXUxujzm935THi7i7hIg3RtVdy/HN+GSt8H0QUsitWb6tNK3Eans5XM2qErNK43gxv/YRLGj19nXYoAMxknvvwRiUw9gVe8RgnJMqE3hUpFWsZaGN0aftFjo3ExpWDSCqKwnRsVXnznkBHAyWMHeywq3cFS1VKnx+f8yLKc0NSPoUErABRH4gdqdWBU+vfJQTj/upVZB5F4LVR98kHyNVqMBIdXEnF8vMkDQYRWp3T45+gwy5BBn2Vlm8VpUJDHTHUzysEBIBpBQ4oZLhCc4410DxLv/fajGhcZYSza2pA/Im1Sj5AoA5LQjfUmp1DUitQkonh+rBLsKYWIy2bXkauL3psnLG6R8isv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/12/26 13:25, Sayali Patil wrote:
> The cleanup loop of allocated memory currently uses:
> 
>     for (entry = list; entry != NULL; entry = entry->next) {
>         munmap(entry->map, MAP_SIZE);
>         if (!entry->next)
>             break;
>         entry = entry->next;
>     }
> 
> The inner entry = entry->next causes the loop to skip every
> other node, resulting in only half of the mapped regions being
> unmapped.
> 
> Remove the redundant increment to ensure every entry is visited
> and unmapped during cleanup.
> 
> Fixes: bd67d5c15cc1 ("Test compaction of mlocked memory")
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

