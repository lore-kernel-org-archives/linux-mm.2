Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84D6A606A336
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 16:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H+o0zQKe
Received: by kanga.kvack.org (Postfix)
	id 65E0D6B00EF; Sat, 14 Nov 2026 11:17:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E6F26B05B0; Sat, 14 Nov 2026 11:17:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 487346B05B1; Sat, 14 Nov 2026 11:17:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DFE26B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:17:45 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 896F5A7F45
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 16:17:44 +0000 (UTC)
X-FDA: 85434230448.09.D47CA7A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id AED8D14000A
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 16:17:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H+o0zQKe;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794673062;
	b=T7u95Ch6omVXO/0yFhnmx367EAQLBACDgjTUiyUAXIucXQBdAbPoaEfVhCrZ6z3tNlrcXx
	D0uwcOUT9go66PuDhF73abxp2TJh1I+jgD0G2/cpzvk4wtBAONSWiROfeLouWEak15BXEP
	LAU/vL+Bn7hJutAIMM8rPj6dcgUXYJc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H+o0zQKe;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794673062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LG93qKhG+N0YzkKVt1kZxr2I4R5vNgIJxzUIUOArJxg=;
	b=TtujUdOJ8OutVRuK96VprPjvgukwOLkTuohjdF0BloJtZv1zmXJBOBVprB6vT7QeNcd90k
	qsoHMQUsp6vdoOEjJvDAgiof1DEbOluMDDqIkqZkT4F7uI0xPGXdABlMriiseTj7QCswgA
	+x6sj6SRhKkbXIZx7PZmu9IB53NjmWc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 99C91400CE;
	Sat, 14 Nov 2026 16:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4631F000C5;
	Sat, 14 Nov 2026 16:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794673061;
	bh=LG93qKhG+N0YzkKVt1kZxr2I4R5vNgIJxzUIUOArJxg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=H+o0zQKevrxN2RqI7ZiEvtvyYAmczSPPRUty+Me1GnOITblIdxrCfOPY1BtO+Qb3x
	 FwLY8mphgY8Y8Tey96xcy7xmmtpXOpSJOR4lt1PbvUsFAyVyaHoYa4Z6kmpTrPhzmf
	 Yejfri/UxWoUkzbk/4Pt0DpyHJuCVKE3oantMWAJ84BpkYO5csTlSFqjDF6REMmZSF
	 pnbnVPelq5lrwhWx/avtuYaYXGpa/zk3XdGOysdZ5Nta1VFwSNJn3XmafKfjboFLxC
	 Jamcx1VKWKOIZskFqsMxw0wgW7UcWmBsHxQWNmLb5E6/qRT/S50HIogXBoVDTkksUu
	 hGy8wtvaqIfwg==
Message-ID: <beb98f9c-c6fb-4bf6-962a-46f542a19c53@kernel.org>
Date: Sat, 14 Nov 2026 17:17:27 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] mm,drm/i915,powerpc/spufs: vm_ops->access related
 fixes
To: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Chris Wilson <chris@chris-wilson.co.uk>,
 Matthew Auld <matthew.auld@intel.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>, Rik van Riel <riel@redhat.com>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linuxppc-dev@lists.ozlabs.org, Chris Mason <mason@kernel.org>,
 stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
References: <20261112-access_shite-v1-0-988a5c470db2@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261112-access_shite-v1-0-988a5c470db2@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: m5camxqourjtsoxq3t9rid9caopnb47w
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AED8D14000A
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794673062-394415
X-HE-Meta: U2FsdGVkX19o4gACbLb+X6VwT2r6PGAsdwc3Z9Jb5OJBWVTq4QTgpK6tRdYLWbn+6e2rALBJJbDadnNTppzK3dg/65xLxHKSI/VR+ZBP4Xx0G0RFdHX5RXZtGYIZ1//AA2qjAmtVar2riWjBYwLN0QlzIwjan37tScKrezuQ+p5NgU651jkqMK5j3q5s1+kapao3A1wxmvfYcts3zjr5xirq+axjkXOaR1z7T4hTCMV4Qdj2cayvUvl66uJ3G9ARwdJ0wLzuTqOiJa3JMpWF6DhxYetO1O4iF/owSY6SZX9BfyW6HxjJoUAeVEX0uFI1ONHsKh5XgTpvLSzN2rrCvefHd8FBcJ+QhuHPc9xTi+TSKLOh1vRJIA462tuq8TKqQzCDAYI+RULOeA772mfnebVT4bB6IXoFFNSnFDBY4vYJduLYGyo+BpVgblIxaEu6zd8azWZRH5iruMGf6eqImbzAw+iNUsdPWI3r0BYn5CMGGDr8omNhp8luoEsFDlenXWX+1HkeJgpDgMVzrP4mXfk4xvh0fJb2FeJxvthj/k8NGhVgXu6bp2dPkYlVu4gkfhjuwROmbDUHmwkQ0zXtwelR+CB5arzCImKY5iBUOc6ldrjxGCgllH0nMZTc45+BmXqyRWo2eWXg9PgbaPmxsA/P8PrggN4+6UHMXJcPnUe4I51BHSoWZFgtJ2x6cm59Km/97vR9mWP0xes0FlZKiWe5PaA5Gfti/J5B2QMrXXPbq2kJaDtjKLJxurkhNecjy48UYHzWTIznrW87GjmWycHGsR5UD9caBPmlKtB2sv4xau9ScLS+T780ebhe4M7+/SrdfyvNtMQz6Tf7hyONOLD81aX9lTmo/NjAkt6k10Uq8KbyO5amcSDY+Baez+uwMk3dpi+4eDzKq9NPdGJxApi2seqGE0ruLZufJWvbJ3b06lCk+mOo2ZxTaiSItgv3aPvOHLIqAoGHZ4oMqne
 cZOEZpNO
 h8zEUl/4mAfHlJumfMcKhV9D79++ynxLWRRCZIISMt2UOC/3pVKQro/0MQXdo1YQexS3yvYykVfDkO2rjhoQRcW8fAhOplfE/kqYi8Go12hB2bmTv0LNrRRyrIqoePOBxsCRXSVQKkbW4uox2ecw4GMEdkZ1wN+f6G3IMzI7+YitZ748PINth4gxO48ecjh2COQXjIiw0WwedxvUMW+qOZPwJjER+85xDQjXGAiq6PDob6kuzzE5IBY3lALFjWsKZ4jnFYW7f70IcYFMxNbRr3AHkzHEZ0Ngj8R9udMOrX3BWDMSdGrMSwWdkpCvkf5ITefUPnR49l0SlOzDMDb4IqVj2lFhgZYFVa6uUiLNCYe1fwArMXpMbtBTLMblmCtGBwH+LBfby26Svvg8nFngn3zpyqcpNXl3dW1j5kdPblFEmgyuJoxobZhmhyX+VzIdWsufT1Z36+egdAIgojIIWEN2dpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 23:08, David Hildenbrand (Arm) wrote:
> While working on vm_ops->access related fixes in core code for FOLL_ANON
> and VMA access permission + size handling, I stumbled over two driver
> issues. Also, I have to update one selftest that specifies PROT_WRITE
> but actually wants read-access.
> 
> Fixing it all in this series, because it's all intertwined.
> 
> In patch #5 we break a debugging use case for older ROCm versions, where
> the amdgpu driver hacked around it by exploiting broken access checks in
> core-mm.
> 
> Tested as good as I can with selftests. I cannot really test the
> i915 and powerpc/spufs stuff on real hardware.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> Chris Mason (1):
>       mm: do not call vm_ops->access with FOLL_ANON
> 
> David Hildenbrand (Arm) (4):
>       drm/i915: consider vm_pgoff in vm_access()
>       drm/i915/selftests: request read access for mmap access tests
>       powerpc/spufs: consider vm_pgoff in spufs_mem_mmap_access()
>       mm: check permissions and bounds for vm_ops->access
> 
>  arch/powerpc/platforms/cell/spufs/file.c           |  3 ++-
>  drivers/gpu/drm/i915/gem/i915_gem_mman.c           |  4 +++-
>  drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c |  3 ++-
>  mm/memory.c                                        | 28 ++++++++++++++++++++--
>  4 files changed, 33 insertions(+), 5 deletions(-)
> 

We get some test failures regarding error handling: e.g.,
https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_178442v1/shard-glk6/igt@gem_mmap_offset@oob-read.html

It's all about error handling.

Before the correct handling in patch #5, we would pass a size that exceeds the
actual VMA to vm_access(), and that one would return -EIO.

In the test above 8 bytes whereby the VMA only allowed for 4 more bytes.

Now we properly handle that in core code and get a partial read completion on
the 4 bytes.

I think the test should be fixed to expect a partial read completion.

We won't hack around this in core-mm.

-- 
Cheers,

David

