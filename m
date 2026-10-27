Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89B13606A326
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 08:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iWuW0cKX
Received: by kanga.kvack.org (Postfix)
	id 778CA6B0621; Tue, 27 Oct 2026 04:34:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74FC56B0623; Tue, 27 Oct 2026 04:34:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68D8E6B0624; Tue, 27 Oct 2026 04:34:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 466F16B0621
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:34:46 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C145B120977
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:34:45 +0000 (UTC)
X-FDA: 85367745330.10.5035D58
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 28F28140002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:34:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iWuW0cKX;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793090084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sLWwjFGLdeBcwQnsfAwPrniEyWPhxDR91tX0J66L3So=;
	b=QUcZHOzZ35du9CEdVAp6MpprR/NbGiu1wIy9mGXL8aMe6j6km1XSuzyGWSvKb+tT1DYCqO
	1LsLwnewSKefkdjgwfg28AGPDeTNgJ51RYeCum0OXkr+YdXDrgkLSeVZJkT7jVmux/tX+f
	BwVRXSli7oipgKCceMNuU4xbX/+EQTg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iWuW0cKX;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793090084;
	b=vv+TwoY71TtfkSmFVd87uuZyEZrY9Jf9MGYmSlEFgW+K7e0fdCmKIK0HXPNiwV5JVaf1VX
	TufcjeXJowIoVzMN5prvKhpniHl0wLuw1gDCXfBBdMzTAEixi/W9YmdHSfo/icA1psJmCG
	FwrC3Nnwqnh2FoyV/on75bhb3AE82bI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A7B6E60200;
	Tue, 27 Oct 2026 08:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E991F031E0;
	Tue, 27 Oct 2026 08:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793090083;
	bh=sLWwjFGLdeBcwQnsfAwPrniEyWPhxDR91tX0J66L3So=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iWuW0cKXZmOQUEKA0DdsDmfISDp1HM6uNFA+OrpXEcF1EfYioInZMwtCGOdIF6qDm
	 2ZJ7hmlvVwY29S+AV1kR2VrjT+NwB2ZbC1AGDlkpP2Hu/2XGjUub9o0KZuUZDz5VN4
	 bOte2srwXvvDRkGWNqVEe92HB+0tNldbI+P4GIJuv4VQMS0wSNfDwWXFal2dIx1Orl
	 x0U8n1DndRrHYe5G6CxVSQBViEGL8i3o1uTW+8MPPqwsNJuV9WICe+0BuaGqEMXpZg
	 kfBddp5j6xO6B/b+7gSc8oOeq7qp1H1svOR4/Jz18QEn9IZjEbWW07ds8YSYkIyOJf
	 ixT5ifEbW3KDg==
Date: Tue, 27 Oct 2026 08:34:36 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Davidlohr Bueso <dave@stgolabs.net>, SJ Park <sj@kernel.org>, 
	Kees Cook <kees@kernel.org>, Colin Cross <ccross@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 0/4] mm: avoid losing atomic VMA flags
Message-ID: <auBh08P6GPQEHPCh@gremlin>
References: <20261023-fix-vma-atomic-v1-0-8ff4fae1fc85@kernel.org>
 <179306587687.1925990.13855179558376532702.b4-reply@b4>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179306587687.1925990.13855179558376532702.b4-reply@b4>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 28F28140002
X-Stat-Signature: uek4bcwu4djtfp37a57aaucndp9xtkss
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793090084-308914
X-HE-Meta: U2FsdGVkX19GZIxuc09iZb2U8x/68efY1qwW/cKThdrW3g+lwnAoazGv7D1PDo1NdGks4WfWLRhEM1brKovExPm/Gm7+iHHTUQY9ZL5IsJw3YRSAWWUEIG/bwC8B3sbzOuqOOGPgh0OD6RD/WTaIuM2m2zfaptpmm1X+IyuY9Ddg4VDueJbXjszJtQjRjIVWcOUJ5zsD/2i4w9dq0D+TqVbGFFftXQQMLcWiO1PmQsX+1GupJO3l4a6b1zTmgkSYkkTjw/ntAO8+LOUQ1D2YzoubIV3Fz3r38bO8vyLyVx2uGQIO+77qboi/TFWjNedzUK2Hoyz4d+RocGLAqn2KNmwbqRF8498Fgx+uvueLaGo3Aiv9bw0gSbOCvWrhP8crA+oDDy/q5M1XXjEZZ2nguvQNi1vSckq2E3juYcZjbt7cZhObLrQ2l5/th7Db8HDov24VmbX3I0r6JlJvXerafR4BsVVatV23sFrIRT8sPFS7kCEk7q79LRyAhF21txpMfcnZ2iXc1sXVKUCpbO1TZ07ryyzAKOmTVHUIxOc3R1Q/D6Y+d/KPJBEziiBfLoGh4zcBL4QdIadUOg9HC6gpZmP3PZ0ZSRMHY2EDgWmgQCwKpvRHxueT2dYUPO8voTpXPD4FCVomuxlZWuMygIhG1eXQ5x5djErS1pjxKUWU9i7hLpY/HLrAc/PtVVjfG0ch24RmnW9ivd+PP/y72f97NH6Ez57UGtdwJWl5NYY1bi/kgEXqGuIazv+za7l6knB2/i+QKuAtqtnZSWZBuHE3MnOHhmyukI5JkHt2ZXBhpp9pZj4YrTL2/UaBa3pVTe/qSFE2oExVZfdVH2XfmnBlnf/+56y/r6M74UtGhh2M4+uv34+Iv6eDioMVQenxSF211xrqzIU+FHVSl7/Y6sB1gshh4ry5oNxvXojIVrgmDAN3hz4YjVizTpt0XeItMIBDL94cvj6DeQasCyGde51
 xQ4e6ut+
 OHn1Hx8R3BhUOLM+M/+XVa4YaoMr/waQHkxtLrdHXgatTInFpdOKPIeJs5OfYBE+7amU9C/QqFcfMfx5MRbxZX/VTs6g5UEfZ+CVUjqwbTCoY9qAzUEBPDpJejc8Ds9YHYKiG3+v9O8CUDGkylYBpqd3ZIKqGVNqMDgnf1tsp3+nlBeTHm0XeN37a9yf72V66AvdjzZ+GGIOW9b/9O/NL9ClaCBrlAUhbvn52mYVCmLswWtsjWznuavYpXsiB0vVayZuxfJkWEvyNqTvWmi4bxVj5uEwL5JnstolCFQUkokfjJtJZ0ADZP4DWrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 09:51:16PM -0400, Gregory Price (Meta) wrote:
> You too get to be the unwilling participant in my schlopptesting
> experiment - but the good news is there's no issues and you win
> tags and free self/unit tests.

Uh oh...

>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>

Thanks :)

>
> Might be worth taking the VMA unit test below.
> Selftests... maybe the non-race uffd one.

Lazy-lorenzo, but could you submit your test schloppen as a 2 patch series? I am
behind on test-writing given the surge of fixes...

Thanks!

--
Cheers, Lorenzo

