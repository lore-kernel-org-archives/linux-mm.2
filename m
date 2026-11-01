Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E85C606A327
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 17:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kRZ/G8e4
Received: by kanga.kvack.org (Postfix)
	id A47BB6B05B2; Sun,  1 Nov 2026 12:03:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D1BA6B05B3; Sun,  1 Nov 2026 12:03:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C03E6B05B4; Sun,  1 Nov 2026 12:03:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 677536B05B2
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:03:44 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D6FE8160A6D
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:03:43 +0000 (UTC)
X-FDA: 85387171926.24.9A5CAD2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2F00E180012
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:03:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kRZ/G8e4";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793552622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0bVBCo8jJc6AJMoyYP1WZHYEekFaCa4NsYZA8oZ2ur4=;
	b=nDCGIRJJa5Xd18/NCsqlyuxp5SteLMhP7Or6/IRVPknKP8I18emfiVSj2FvuKBQPa5Sc7u
	rhvfKVTcaH8i4Y5TKWGruveePZ/DRuqDKBV7/ZKxmeBWMz7hJrrYapqLZDkRt3O9JwzlLJ
	MJr23xfmPyXXESIh5PpLS981apEXkRI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kRZ/G8e4";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793552622;
	b=75oftKyXwIdxf5r/ICTz9pRdf36NtKIY8SNFx5SnsCAXP5tNo/o2AFW0UlqFK6s9hlvx9f
	1fhFf0dvQgIntxmE7Iawqkyo3I2wFbuWz9kp5p7J+lx140l4cDRNuWKfBwxICZOnF7JMoH
	rRPOJ1JIKZeN10txa75/2FnN6A9otHk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F62160052;
	Sun,  1 Nov 2026 17:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C95D1F000C1;
	Sun,  1 Nov 2026 17:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793552621;
	bh=0bVBCo8jJc6AJMoyYP1WZHYEekFaCa4NsYZA8oZ2ur4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kRZ/G8e4qQH/g/ZCaXnqR3qVQQUAjnJzwLJKJzios0BnWdldjeE8R6vt6/30bglNu
	 T0zVL/GBKJqj91hiXsumxr/p1NogtrUlNUbamVLxYZvBGmbkEL0BkBaS1N2QwSsY0D
	 0oz4bfbcBrACvSX5nRoRvGApir96Y2LBGr+uMZZ+YK9ulNj0zF1m32qYaEax2yldfo
	 0tLwGVPECc8D7YCC+VhL4hKRTtRFzTSKnme0DlSE+oYOF1wrNhtFmdEW2n11QdCHS6
	 5VpPEi9gn5bcZDPtWgDFvlDWGpM/ngZM8U2L3mw0Xox99D4wqTfWfYtyq+Rix1/i67
	 LpYajbj0g5tWg==
Date: Sun, 1 Nov 2026 17:03:37 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] MAINTAINERS: add Johannes as the page allocator
 co-maintainer
Message-ID: <audw0QKojvZU8J7e@minisforum>
References: <20261101-maint-page_alloc-update-v1-0-27e8c246b13d@kernel.org>
 <20261101-maint-page_alloc-update-v1-1-27e8c246b13d@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261101-maint-page_alloc-update-v1-1-27e8c246b13d@kernel.org>
X-Rspamd-Queue-Id: 2F00E180012
X-Stat-Signature: r9x8s1igg1533g9ttc8j8suptoarrbt8
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793552622-550568
X-HE-Meta: U2FsdGVkX18oC+7sxiSXShYOCvCkL2FjbJ52RnkSpHi/8BntdXAfMb0MfE2mK6Yx0+d7Mo55DXYa+VX/Suno+lCQjjyxOQ0uEcKAx4OrvFkFxwJcx+QbY5LgdjRywM0ZB9ymJn5O2hasIxMgNCKFVGtWA4sYtfYM7dBjXn3yg7FxK6byuoAv1zOPjpG7Y9d7M+NXCwUsn03m7EKLGvsYSsOPRvzTngTfzSpglsILaHahuiBdKX+oHzPyNKXBPZxxg5OECleU5+ZqJ8B0kREnbmZeqBVgvprVb3qZ/8hhlfX3/VTu/rHkjTDqagNaYVelGLzwZM6Wq30seBCAo2K5xPHBXgZtKdSa/OKw/9mJ8iPR+RyzeMyesJhpKdHphVKXjTmT4MRFR5zaZxOgBAnHvG5BQtFlpPwuTXVZI1ZHRfHJuCaMilDwUblSC3k3P4dd372ycFTZeYLTykS8qsxzUD0xESUReCeve/TilvzmHcF4HcslmhCovdAI608IBB+QXqOuLG42PAvcFaLEENnVpczCL30ZmkjVCvXDYqD2mP6j+Pdau048l4pvqPxEHvcc0ZEtvDtNJ31tMekYI4pqpHROwhvEG3m2TbKIYOGo9mzThLcpRR6j0jKkXSC3p5k5Lxk2s1H0flAZyiTLvseUjlgSo9c6xFpJCeEAQAYEr/NWKVw0JIkBbumt93SL3d7TPbIjIppOeh1+VQA2QbqyaSOED1TnClXU1Fxcz53xr93eWmCy4VcMTuSgfZznlb69kLUY4HPKnN1D16k/CFkM6E32IMEvyAXXrnPN7/pJoqSqgwiYOavRXeDBHhHnKbPy7fFUBGw/tqSqKsqfQq5+LANquQTa/SUPN4KVHYl3rKIPrZYtBz/NRHf4cHjxFWqkA7sLZC4FadiQMMv/YN4RphbyKQWgFvmyq9VpAhSxWFMyyg2a5w06htcHuf7YOW+Nlsu0BCupYqaQtfRMRmq
 k6R34tiO
 1DQU67pGLsIG3xQEtaMk1VZoIf5nNbrypxXLq95YJl4w5Bt3rpXG6SDCl06qPS6G1ZZaC+Yitrpy9ZfG8g0Q/ycy/iYQtFbfdBWmtX2q2A7nRIPxJvOxLAhJTp96xSljJzDpOkQnvcpeg4tXkrLt1XfqMGM/gRkHXAq3USA3JMg+7DkTODr+buJx5DQcdkX6GMdCkzYbIzVoxmTG+kbcxV6ld4Hh7mPBLuE58DMXNTDaGZlEXHKlpkqo2gKCcD7TmXlFnGhSqECt7jSWxTYtOOTCqBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 01, 2026 at 05:34:48PM +0100, Vlastimil Babka (SUSE) wrote:
> Johannes is a long-time expert and reviewer for the page allocator and
> has agreed to step up to a co-maintainer role, so do that. Thanks!
> 
> Additionally, page allocator is joining the MM transition, following the
> MM core updates from David [1].
> 
> Patches will be collected in the mm/page_alloc git tree and integrated
> via the mm/linux integration tree. To signify the change from Andrew's
> mm tree, remove Andrew as M: - get_maintainers will continue CCing him
> on most patches via the catch-all MM entry. David prefers not being
> added for mail volume reasons.
> 
> [1] https://lore.kernel.org/all/20261030-maintainers-v1-7-97278f8a5f54@kernel.org/
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Acked-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

