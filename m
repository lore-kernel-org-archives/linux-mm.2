Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 602DBF41805
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 15:08:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6168B6B0005; Mon,  9 Mar 2026 11:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D8276B0088; Mon,  9 Mar 2026 11:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E2DE6B0089; Mon,  9 Mar 2026 11:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3D7686B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:08:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CCB0416024D
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:08:09 +0000 (UTC)
X-FDA: 84526855098.13.D475B7B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1F272140009
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:08:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LaeYYRkY;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773068888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HIyblTcTCK0uZPcwGzldd12E/Bsn5L9DN0VPrRm/rfg=;
	b=IT8BFM4TsFqjBoJzn8sFpi6bVcPB5tRAqEx+KLhsTjzQAocUJplufhX9+guB+ZTtDYsVzw
	dJJ33RjphWavtmZ3Y6XNh9q4+tum3t1e4on7fTXMy7ZYsdwDQsdDn8DNonro4ZhYFJj4v1
	lnFMS2T/sFSHv+ZvNDO3u6VIgc+pEQ8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LaeYYRkY;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773068888; a=rsa-sha256;
	cv=none;
	b=CdlS5UANPyl/lsQ0oCa3KQHgcraMlLMPcbtWIoUXPObT1jeUa8Sgf8pi4UZbITWOMWXUk0
	oAteGg6DHhKclrgIbc6ny5xJwBK3s0G6ob2P8P0CIojWMb/P+F+Iwc6RAcVHfCBgOl4kUF
	goaz1d2XGPAe8x3A8Zclrpq16UJri1E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8329760054;
	Mon,  9 Mar 2026 15:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4762C2BC86;
	Mon,  9 Mar 2026 15:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773068887;
	bh=65GSxxooaBqszDjKBnb0vU9DG3G6+qZJ6mCafUsf7R0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LaeYYRkYa9q+TNllAPbXuuj70SMvm16G8E5XC/95eepCWcxJpjEDl5XBrbSBoyyoL
	 zdy1G/VjWK/6nX8w+2+NDj5H5WwvQgRIscDUFcwpJjGtJyCpMq6jWIKoApr8+baIKu
	 F9vv4/uGLj+VP8Fqkr6Y5HiH98/3QjvTK4qDjvinOLd/1nqKfDDDfD5vdeSVtUZxEL
	 uApOQbCXNw2JLNJ5y6iY8lZQSN7q3Zhz2MJAaxINXWmNbbuYSFmlQIQ54HHOGkAAKS
	 zFWyGb8U92HlS3dtFLkefFQzfl0XTf547taI9QWlX/hE4vdVNTTPzhK7Sixc7TE133
	 3lcRlM17NcPSg==
Message-ID: <19fdac31-0d2e-4662-b3a4-02555d8e4221@kernel.org>
Date: Mon, 9 Mar 2026 16:07:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/4] mm: move vma_(kernel|mmu)_pagesize() out of
 hugetlb.c
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Dan Williams <dan.j.williams@intel.com>
References: <20260306101600.57355-1-david@kernel.org>
 <4rzf46kw6hq3b5ivv7cvgyza4yfrvk2shrncytobabxef644nm@wzu2bw63co37>
 <371cf0f7-4b30-4d8c-99e7-ae0543f8be23@lucifer.local>
 <5eae6c52-c3f9-407e-8fb8-01a950b282bf@kernel.org>
 <9172a09f-f014-4a76-b813-8f0c79fbe2f4@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <9172a09f-f014-4a76-b813-8f0c79fbe2f4@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1F272140009
X-Stat-Signature: 6ex8nppriwp56prq3iqwx93kqe6qakxu
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773068887-404571
X-HE-Meta: U2FsdGVkX1+uv+eG+3YSE3TMR/6s9r7PU6gBvWXzQvbmRBw3S9Uf+hiv5YlnEhEAlQYa6ZKb3VDafgZhYqsD/eSJnKrtRGPiIGulo4kn5ly1ClfwqXcqqSrJGi2n18SDu5A9oHNiMGAG/U26cAUu8XkDrC7eZR88u8PPRdFwf9u3xO9TqeM3HAYb23BKR90L5VIHU+8ir8BWaU4Bn+/z7FBZvMARrLWsQwTq6DWqGwk9laaUdfIROwPjdE2mLuwZWpu0LaE57btkpMqEUCHb93Z1bq0ulstkeOpEoMYbPQ0+f5VnEYehKIg5wAD6lNAvaYmTGiExBDO6nqxylS1PJH6I/jWDZ9fGdNeMH+h1WP6+wuMbPYkGS2vnvTBBbmeK33DW+m8SOeNvQ9sibV6rNfHeM7l0GxmUwxgqS8hHRLxRSNaYOYT8kp+bfXJeAK0FI2/cJXL7oeZV/ch0ZeMX8Wp63OWHAO5sj7Kmp0SxwHGWXlNgyA7HRQwWEEvtVouhOhbdkWI0c3ODzevmYWgXzWxek7Yc6LAFi33eZIN9XGTiJkVGy3OnNBfaCBJGnpBcykXv72kKqvg/3daaJWYgJ94UITIJEkvogNrEPqU+8pup63BrkmtDik6lQ3+j9N0MFUcUaA4BOLHH0rQzOzMbPgejJYHK/Q4r1Bj2Xzyr/9pwe9os61nwQx7nO9vsTd/MjrMz912TUZeiK7FpNqQ8z+TXahINfFPiEYO9+qzASkihiY40eWyIOztECrH0TbhFhGV7LGg7QjI4UtZ3omOVS6wU/CX+PjmmEKocnxqCRMzFTglu/0b61etgaR5HlIJAlTfEtcQogLCwq5PVFPL3UVxTVIax05ODSev2UJaeCcKSPBGhCHy1rIx+zKAoxLMc//JsdLZ76cPN3bGPlpL6zljynWeiTCFciMT4Yr0QA2/KmebyFJM3tgEdFdwu/ex2NXO8jJ5IQcas0FH0SnH
 fUvi4NTD
 2UTQPfd4wva+ooGDqdsepBwyXxAS42oFwwQOxURaYr8sWVjLDyOCXeis6l6oS0Fr6CdomGZSW2NP2UxG+JZuGT5Ei3sJ6pzI9bMDBC9BX7V7jaLYMaUSjIXE22t/6RaD5FB2+DIO1qPSp6UsGRNldOOwHR69afjhBJn6aVCCHkXsnMUTrvcKCv1JcymVQ9eAwKyh1i2/I08XP41xhHCTKM3Bh5OBzwA8cx9Uc4EKWw5C7ghNY+DOYSWze6N2ZT1JrTBsyn/3sgz1aHBzQp7RaLfYBeq+hquysc7Na69/11PU3A1C2NKGjEPyR3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/9/26 14:42, Lorenzo Stoakes (Oracle) wrote:
> On Fri, Mar 06, 2026 at 02:12:50PM +0100, David Hildenbrand (Arm) wrote:
>> On 3/6/26 12:19, Lorenzo Stoakes (Oracle) wrote:
>>>
>>> Yeah I noticed this also :>) Assumed it was a new way of doing things somehow?
>>> :P
>>
>> "--cc-cover" is apparently not the git default on my new machine.
>>
>> "See, I CCed you, I totally did not try to sneak something in. Oh, I
>> messed up my tooling, stupid me ...". :)
> 
> ;)
> 
> Wasn't aware of that option actually, handy!

On my old setup I had a script that would, in addition, also CC anybody
CC'ed on individual patches on the cover letter. Was quite useful for
larger series where you don't want to spam people with unrelated patches.

Still have to set that back up.

-- 
Cheers,

David

