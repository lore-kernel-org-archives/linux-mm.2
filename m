Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFF2DE6689E
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 07:24:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C31D6B0088; Sat, 20 Dec 2025 02:24:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 046216B0089; Sat, 20 Dec 2025 02:24:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E95F86B008A; Sat, 20 Dec 2025 02:24:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D5A586B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 02:24:03 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3FC9388D24
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 07:24:03 +0000 (UTC)
X-FDA: 84239010366.13.6DC0839
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id A762D40002
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 07:24:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lhPC2Ke3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766215441; a=rsa-sha256;
	cv=none;
	b=Km1NCyvoApj085M659OZjq9oIcaKjkR2MdftA/UBlWk8zTbdBZYE4nnvcXwAQ1NmbECn0S
	XL1CC354Bvv4O0uXu9bytrtmnYX5AfsK8dy0IOZZ7lxroZYazX8+RFPo/lJLzglKQYaLif
	Ci2nr7haI4Lxx40WVq3bqVWFaqr5oUk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lhPC2Ke3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766215441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qC2GZc6fPRMPuHMU4nKQ39f9ERb6ZZWz/yPspT0TEHA=;
	b=U4p5Dz/QoMI9fGGiC2qnfYMGXB1vN5b8szB191U33A8b+wSoc+TB+FAgcsYPGAizfYPfRl
	knSO4JOrz0dMb0LOtvn8r4OPgIYvEO9GJCiTr4fxW5OtiL3RuSUVkGbJWcjeKonYRTSgpB
	pmgxpox8lQrXTVFGhQxKDw2tQEt+A5I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0ADBF60008;
	Sat, 20 Dec 2025 07:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F63C4CEF5;
	Sat, 20 Dec 2025 07:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766215440;
	bh=HeVhro2dhwu32V4Eqnb8kNIV9QmwemotY9SDP9Bhafc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lhPC2Ke3KflCNf12hPQXvwkTWnWJP+UwYphS36IiagYhdO9i/csvJksZG00B0XTzY
	 /0pdQvELAjwOHS4DPvUziRA3G9sBKL02gGaRKx37Xj2vcRgQbIvJVvrSTT3deY1M+k
	 uRa7eRNbFEKCilRFFpY/ANeWZ3ltJrP9OKhyije4ZfebM6DQKUIkzaVXMxvZCrnFuL
	 lBQQsCJLHLT67AqhYSjKn7TDRNVGyzY0lqStPYXxaFk9+fldXVtBRLnZiexpfJOsRg
	 wGZccUZ4Ym1f3rMCGJlYuq7yZPMfbujcJ3hcJ82XX28KpclqhNXqX9OycooT0A7ADO
	 ClIfqAcCwQoUA==
Date: Sat, 20 Dec 2025 09:23:52 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v2] mm: clarify GFP_ATOMIC/GFP_NOWAIT doc-comment
Message-ID: <aUZPCFLIeAgdkioq@kernel.org>
References: <20251219-b4-gfp_atomic-comment-v2-1-4c4ce274c2b6@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219-b4-gfp_atomic-comment-v2-1-4c4ce274c2b6@google.com>
X-Rspamd-Queue-Id: A762D40002
X-Rspamd-Server: rspam03
X-Stat-Signature: cof7k3wqyufio8q86dcpra87ipmgspyu
X-Rspam-User: 
X-HE-Tag: 1766215441-187661
X-HE-Meta: U2FsdGVkX18oEU4vD3M5LDxMda1jnG9jq0grR8sHantjg5tpyhUgXT72DrDwPI5tnVRXfU4Czt0yzDYDks/MX1eEuhNW7Ml1XoQ95jxANKoWq63hk/1w0bKl8JS2wAVW1yFgR+fOBxOYS5n3PUR2JD20Gm5sjl9fYJaaHmp5md6zUJmxpgxkyvTynEvgs2BOO9aAAZBV9dw7iGGOTvgWc6Z4VRW59/xxrieSD5WF8I/VD/7w2e575C6hqbuKMJi7vUzvRX1lBoYJVqR7Nfe13zEv4IDtOSntuK0tj9cGUwh4qSj4VYyUa4pY4t6vXHW/05OcCRVMnZU3y8omVMD5Fwc3RkXQ4syCq7J8OoRcbdk6E1XxzN1+fFEFMdYUzNEDf3r8nNA/OOPngDw91Co8eM6gvmugNixUTkvaJrHATP+SMlAklKXUz8PkDORBH3GLr49lHQPbJku1NjfpfsuVV0Q65Vr+K54ScG1Q7q9M+rjD5fJ7wj8BdNqWDVHZiAIObeHLqLDIOnkuiT4Em0pnzkOqwwo06j5ecOn9uTmXiRdA8Tig47nzk6egmbQ4yKrarsmGZQsvkCMYv4w1xRgBp2XHw1Lf8lDC4Shva9DteZvs+wHEn0IUbmAVN0VgaaP3yBXuqudgs3HV3z/UnUJibWxtoCfPJ2CSfTlFCPKfvD/T3Ein4QfLC0xQYOkOiDLRQ5LtQlhDoQO2sCpNQ7ots0aFR3z+sOd9dfZXjfOyY7g52eO7V58ZlUk3wzRKVeA+lN/9tDhIG9NDDdjhtdk1p0rwRIuIcmqlhulWdXTo+HRMCoxS/6jTKoDmKpYt0rU2w7rGXcmbAkLQp11lLOCqYt6qgKLK5pOFKis6mK0oMTD2fJ5ZSv0zaJJb93xS14Ia2hIFFgg0UZJcBP+UqQAIk14yqtSmh6yhA6htpKMKlya93tYWkp+csJ1S9ANMNqolRs8w9nbA6wTQ6lBgVMQ
 Uy8Z6n0Z
 xLd/bMfq5+ApW+EZkMFN515bBlTD52Zu2AdhikkKMabjtlmcyEazXchOkm9GpbwpmLWACmPQygEdDEwf/ThJbL9+csDPsVpiEpaVOYKFC80xSCbD8OgC0W9D5ek6OzPdi+MdGjFROHyznzUIOkc5JS/VyAG/SGePYqX4WpCr9RbalqOnLiEfMiyyFOs2hMntvYUT44pbmDARPBI9DWHn20/5nRVUZIlrdIvDLRM9q1H/4jsqAebgn2t3aaoLJTWFowOc57uyl+kqN7KTTbG1D4EwF+5fFrxvuit1APBbsICFoA7z9XreDFbMLuvRUAmjDcH9V8HbI3JKDYXj7sWziN71hWjUTJxPp63cR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 11:32:18AM +0000, Brendan Jackman wrote:
> The current description of contexts where it's invalid to make
> GFP_ATOMIC and GFP_NOWAIT calls is rather vague.
> 
> Replace this with a direct description of the actual contexts of concern
> and refer to the RT docs where this is explained more discursively.
> 
> While rejigging this prose, also move the documentation of GFP_NOWAIT to
> the GFP_NOWAIT section.
> 
> Link: https://lore.kernel.org/all/d912480a-5229-4efe-9336-b31acded30f5@suse.cz/
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> Changes in v2:
> - Specified section in docs reference
> - Link to v1: https://lore.kernel.org/all/DF0J58HOVLL4.2E16Q87D2UXRW@google.com/
> ---
>  include/linux/gfp_types.h | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

-- 
Sincerely yours,
Mike.

