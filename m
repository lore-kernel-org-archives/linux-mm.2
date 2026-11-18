Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9E8C606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DijxmAwD
Received: by kanga.kvack.org (Postfix)
	id A1D596B05C2; Wed, 18 Nov 2026 09:58:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F57F6B05C3; Wed, 18 Nov 2026 09:58:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E3FF6B05C4; Wed, 18 Nov 2026 09:58:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 652E06B05C2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:58:20 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E90131C41F9
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:58:19 +0000 (UTC)
X-FDA: 85448545518.25.8C699E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2AFD7C000A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:58:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DijxmAwD;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795013898;
	b=6aBmXT2N0BlrFDH/3H38PwnmF6RJU/jElZbTYUODKSK3Wo7+oFGJBXIZ/gXCq4cRcmaCmo
	xURayAKDhyDPEwtNqfyUrtPubdFpjkwg6etueDIBmMjQbMYtClFrHHOdSeO+ULMYUzZ+Er
	lA7vtUt+Z+Nyjr+DG+rlUyPq/YyHXFw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DijxmAwD;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795013898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PJCnB2NDWiV3ObQfPaZFnBjIW1Yxsi5C6UDhp71aKIY=;
	b=Fi6sVghQhfJvHWOh8JSJhlF/JaN/UhN3topaiFz+gHN/8ZUh7LC9t814r6JNyBMbOitNJY
	HqqVXi7yAeKjr/wwaZD87EYZavPS925eqradEfyNLWkzCSaZgzQmlgTNEqyAKN1YMElvTT
	IqMOt0JQqSlSp27jl74u/MmI4byqGZI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6EA4A4616C;
	Wed, 18 Nov 2026 14:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4096D1F000C6;
	Wed, 18 Nov 2026 14:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795013897;
	bh=PJCnB2NDWiV3ObQfPaZFnBjIW1Yxsi5C6UDhp71aKIY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DijxmAwDbTa4L2Ply7caGjZo5P0/KZEG25tVtp7gfTyyxy4pkIsZr+RuhaTgWEr27
	 yU+/Fs8hacMRumXJ13cbUwfvoJd1nzStWTWKoc+aY28QMmPlhHokIuYj9TL9DpyW61
	 uRqamPRt7si3+j7WBBLXmbxC4MXNCgnEhyT+EbgTqAszhilZ7w69B96XPhpF04/GL5
	 bnBYtWWwSyz27qRE9GcI7Z6bZpi/kp0SC9M9WkXJPyqNJQuZPf/U8k9kL+BwCzNo8y
	 aw30ShH/ITAduc7ZirgqnDRvFzHZk40JaYT+djBuxNJTW1VAyGmph7ANwOOCiOqbCy
	 u1y7kdnm7XFcA==
Message-ID: <f30cda1f-3f7f-4e58-b5eb-5db77c0f82ee@kernel.org>
Date: Wed, 18 Nov 2026 15:58:11 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm/memory: remove the mkwrite argument from
 __vm_insert_mixed()
To: Sang-Heon Jeon <ekffu200098@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 "Jose A . Perez de Azpillaga" <azpijr@gmail.com>,
 "Liam R. Howlett" <liam@infradead.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
References: <20261002160535.661399-1-ekffu200098@gmail.com>
 <20261002160535.661399-3-ekffu200098@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261002160535.661399-3-ekffu200098@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ciaj6fxxadx4isi9mox4i4nkm17t5abc
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2AFD7C000A
X-HE-Tag: 1795013898-871353
X-HE-Meta: U2FsdGVkX19+oFRQTTdG9bCr/di0XKTC7O26Y+9uWc3bkN5awNv4FEYi4Qxau/YyD3Cw/4CSVpWjfMYyUad+YPv/6VUWRf842nTwm4pGCPu2lRG4geMzXd3RphgciTPHVmAzl5dwALpez/hV9erLl/Ucnp/TYJqrq96QYWJL/fmsE9GqGMEDlRRLoj8Gtt6RpvULgXOpPA0k/bn0GyuiUoUeyxQpjEaz554hgqlN/S/FZsWrJ6ixYzZRpSVP3fTBaAij+psuVk/NSqMABxyFK963wh+/8JD3tzSiB2f5sL8hZMo72lKb9LuvNHlmd+FTB02da5WZ2FrjEaJDyvsGpzEH7gGKTfMCmUfl3unkOICpQtevfq4VIkcjOUjeIHIa8J+aPbHY4JzNcTHOCaeg/w8gqgiNAU6K9LnzRuZA6v6zxk+BNwqtAIyY2CjabTundkM+1AD1waCt0zrSrP0RYrT5I+vq57+IUytd0F5IkvxgELb0d1pkjcP4OCkxarKrWsgAyMeNHFUJQ7B3WaicMoDIRtQtNuRRIROebNYQ2aR4roFbogJy5ZjgaBjePBI+Y1dB9hyfnUd7uJqT37ApZzYZKG5Q06Vi6CtYH39szN0GhtP43TisAi6keheTyTqNj+VXBLDSuVWMFmyeNNJBDwzZyCyKBQFcrWV/1LAPKGFN45P1v7EJmSqW4cTUK0EkOlssWw++gUK0Ys8LcQiHuuIu/rKqjXC3tuOPEzQRc6euO03ZeEvSaxzcGPxDyvOOyHfqmPZhVoML0UCCe2WYA3YAEUJTbIeCjF/m3TcApOwCrjnuiaMz3/E/psANEpBJNptYC69hxKZhv1TKxg0aP/Q7WLcqe0DYsyzH27OLkJPmcH9Q0tMbvOjnKzYsXN2GHeP26NyctnVbYH2S3bmbPOlRrBe+d4jGbp0Y4hTPWolIytlpK1x8NSmIoY4DMyZ3FABh/iT1tBkBE1l16lh
 bsSj6fIg
 swtcXvbX8lho6nUv0waxoYay3gSBsYdyDZavIxbwOR8LDidVRnOYTseozvLP8Ee++L9uTa04a/BopxdM/J+4ZpJJhTAj04L7vfd92SAA4Ic51wiEEe8CDE+Vt1s/0wDrT/DrXQj/TbHkyQCasY3vzm+MUZxZ6FRJuoIiOLE8vtlpl+vvRlmfsH8SS8IiL44upGqm/6aeEKYWgQpbAK/pwPpR9iyDiVFNNoiXbSdlUUMbBeUOBi4aiLglRStXl7xI0ZzyzmV4RHry4+q9KCKzwCVZj/X0Al1G0uzge81o5uYWVZJgM7VStBp6PXiDmMOKxKgpp75SKJrYp5s/Phi9kNQ1xxk4YCcRb4/bS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/2/26 18:05, Sang-Heon Jeon wrote:
> __vm_insert_mixed() is only called from vmf_insert_mixed() with
> mkwrite == false, so mkwrite is also always false in vm_mixed_ok()
> and insert_pfn().
> 
> So remove the argument and the unreachable code in insert_pfn().
> 
> No functional change.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

