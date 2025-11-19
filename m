Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9405CF3181
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 09:06:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 207C76B000D; Wed, 19 Nov 2025 04:06:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B9D76B0011; Wed, 19 Nov 2025 04:06:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CF9F6B002F; Wed, 19 Nov 2025 04:06:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA2A36B000D
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 04:06:55 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1BB7212F4B0
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:06:53 +0000 (UTC)
X-FDA: 84126776706.08.E232222
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5ACA814000A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:06:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OtVFxRZI;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763543211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JsiPaTWbXVm+hJPZX1mjjfHpZhuhf6P102Pvq4sIFws=;
	b=Qu4HgJNMc48rWBgOzEym6V9fsXK8igYaVF2vuaDVNNFaAELF7hhVfKGF8fl8tkAukabQXo
	nqADn8tI/dxwwOveWZQSODV+JUxcOK5Fdpv+EPGMGWtfpoRbRBcVh64Rsy7za2MmTHeId/
	+yBFTx5SmnBk7VqX26XeAWHzSu3pQV8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763543211; a=rsa-sha256;
	cv=none;
	b=DdgCPqyZpJurR9H+6Us14FqqvA7jzSV9FJlFTuHV05+Mpq75jB/E13MexW8bH1XpEiOMKd
	JG0TmdZ12Ou2UHZogJDG3dNyT2erR9XgjmmtvUTUd43Xl7olXGrRwum2M1Jl+bV0iUzBHC
	7uheO+1T4B/OZblzg240iHxjRBOVpwo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OtVFxRZI;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 114974435D;
	Wed, 19 Nov 2025 09:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB818C19422;
	Wed, 19 Nov 2025 09:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763543209;
	bh=9VkQQVp1GUJZvklIUdL6yF9pgR7bsQTx3z4kO9z5dMw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OtVFxRZIeWCKgm/wX8Mh4xSUKUsDu7TC61ZcbwB7p755P/p8D1UbOzn887vZKWsiT
	 LT8Hkl3H3DdI8TLAeKktrX3yWPQQeQzoD5az9ce9h9AJFO474lVbcQaSZN4cdtnOd8
	 qMzgerN86Kq5LjGLmF8Xvx0kt31CQR/SNyrzETsVCfIlrjxK/jwXc0n9+UEq8FW+87
	 frsGoVcUKPI4zE7zMA2vs5hS+GVhuQnNfj1tCMielj1RrXvfjcbkBaPmp99gNYG86X
	 g8w2OOyBsEud9UYPSoka4/54CHPtP2JqM1W+W7dvk4+P26CuXNiNahahWDLbiZIptV
	 UKv7ewASeZOgA==
Message-ID: <9b18ee75-bf06-46d7-96f3-395cb159217b@kernel.org>
Date: Wed, 19 Nov 2025 10:06:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/9] mm: add atomic VMA flags and set VM_MAYBE_GUARD as
 such
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
References: <cover.1763460113.git.lorenzo.stoakes@oracle.com>
 <97e57abed09f2663077ed7a36fb8206e243171a9.1763460113.git.lorenzo.stoakes@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <97e57abed09f2663077ed7a36fb8206e243171a9.1763460113.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5ACA814000A
X-Stat-Signature: f8bt6aw9j589ja6617ijuorfkfrxihha
X-Rspam-User: 
X-HE-Tag: 1763543211-833944
X-HE-Meta: U2FsdGVkX1+g9Q1lCxfBYC4DU1ApHCdXt5nxvSvucVprnS5rmvQcTjpdp8ceaJzynqW6xOqVDN9lacjbSlAiFPOgNGb666taF7qM/86kuHhNLqjNdLGojtQuIsbq0h8ZoziwhclhkzN0G5+exOE0LuQ0w4osetmDHvJDIs2qpLgklrphqiktf/3KMGTVeqEY3M+bGSLXKjoPwGj2MuJB4XsCbwiNkM3hKESeZNilUFd7RXFhpIohaz/llEMyMvZ4euWLTh9eG/cu1qWYR9c1U8efFGxt2wA2uKxPxZiwqgCCkK3QmSVdONJLsGPfGLqj7fvofvOoa7YEYXgbUVmegUc/2/wppxEcnvBmupMnG5z0bEp3mOWJAa5j8tXdqU2p8ntuQp3d8XknHmgP1Vamgid+iYz6+JWHOaddqjpS+S7G7QehjEzM7GmMYyFzaif/R1TSFUJzmmR9Jbxr/4oKkNCAY4kp0V14GVvTkErgF8TazoO41lQa/GdC4QoqRimHRk1vTJYSm5He2IZqi43VRSfbsEx69CrkhUdjuicNjKIfT1YhHyZrGplK8y8e1zfgcJgCmjy3cYJh97UTKYsRDaxxFT3fVRRDKsuRRJ1hojPmejZlbgkQmmVSVHBf7/7gmBaBS449KVe6Bln8WPO0iy4RPmTVH+cD3hGD0vtC6nIG3J2FfZElvXRWrG7kdEAqWC5kU9LwH7m5+sg1foDZAnkku0J0eD13Dyuq4KQ/Yyr5abZUG3KDMbiBjfILQzDcgZpfK7h4HeSVDamN2U6ghYmI3RGUHfApPg2ZoBHvPqKxluDS1Mu2xek22Uw48z0l9cLBFenmLkPlvB4iiYYBEp7iVTaQpW5Y91V51eU5dxQVwbuq/DP6+/iB027B1KT4Yt4s1RdhMhET/enlo+u63AunJALAgAMwG3CCqEaUCvEsnbj+wg4/Lq7YIFwvQ2R0kM0vS6nDNmM+WNaJD8I
 AW+a+SUN
 C396hD6oSGWHocSrG4sFeTjMtXtBU2dHghVgI/eJngsqQfxuVtWjsNpM6FvLCBJbc5eFYbnWhCXHlF6ky93wv35Yidzn/RJ5U0XaDNH4AOGT/mDyxkIk03l0y+me5tYs7e/hsyglJ6xIqAnSK1D3BxfPHmScbSzcjD+z76G7ARjWi5Gd9Npk5oGYJU4ZQudRYPErWG2etF5zFebFoILgbkVioZIR4CqfyRL9xUMIo3YaLMtsDFbKjPA3ESZG43jzaWhh2YJflHgsKdzFSLtSmaBPWJ7kovT57wftlddL2RQgSP7Kjzvao7/07wS75Xsb8gtnx1GbQqVtmgndO/dY/1oYBVmTmp5SlGNO3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.11.25 11:17, Lorenzo Stoakes wrote:
> This patch adds the ability to atomically set VMA flags with only the mmap
> read/VMA read lock held.
> 
> As this could be hugely problematic for VMA flags in general given that
> all other accesses are non-atomic and serialised by the mmap/VMA locks, we
> implement this with a strict allow-list - that is, only designated flags
> are allowed to do this.
> 
> We make VM_MAYBE_GUARD one of these flags.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> ---

IIUC all other flag modifications need a write lock, so this should just 
work.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

