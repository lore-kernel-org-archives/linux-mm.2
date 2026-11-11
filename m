Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E0BD606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 08:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fezZkqDt
Received: by kanga.kvack.org (Postfix)
	id 4C4EB6B05C6; Wed, 11 Nov 2026 03:02:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49C656B05C7; Wed, 11 Nov 2026 03:02:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DA006B05C8; Wed, 11 Nov 2026 03:02:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F82B6B05C6
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:02:07 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE7A11C296C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:02:06 +0000 (UTC)
X-FDA: 85422095052.26.894B5C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id D749440008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:02:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fezZkqDt;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794384125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f6+y24whpH+hV93WgbRlCkAQ6VCngTGf04ZhyeKYHk4=;
	b=1gS9FuPXt13qv/kenAHPGzOQ7GkFS7SGadLGWJFMe32u/Qa3MXEa2UsiZ7s6ispmVHMYfy
	/JJAe13FvA/CODl3hRsCHOjKa0c2L5qObwWoSpXELQdFVh/1ulvfL9yiYQdbeIAIDQd4mo
	06QPi/jhWCl3yoFBU31Qf5EICkD8Ae4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794384125;
	b=FxflhzHMnDRtSf87Z27dR6deMFPsvkeR7QOyXVco8xZqlSK1T8T+LYrynPymGLOJp2neZS
	VWfH3/8KZyORgSHTSvUppdrFCDC6VPTZ0tUXZJx4LE7PDexAddOCtJxUUYYK7LjES7Nx78
	DxoSS35p1prY++vLD396EXRhESbqAPk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fezZkqDt;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 36BE743B9B;
	Wed, 11 Nov 2026 08:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DCF51F00A05;
	Wed, 11 Nov 2026 08:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794384124;
	bh=f6+y24whpH+hV93WgbRlCkAQ6VCngTGf04ZhyeKYHk4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fezZkqDt2Ro3khEnWhMt/GATI5BVig9WvxFs7pQybENqnVWImejcpv3TgMb2SoSHJ
	 /OczfiG3b6yRgOUJE4Ou/hOU2AjYjDKRrdeTtb2AosJui97o7MUoNHYPn3TRmldSmu
	 AUMFgjGY9Txgo7WZsi7g37votETc4ZOCeHoiGxEoSawV8UgM6tWFG/TbSU8UhUJE+x
	 EztKk1BNmstojVYvJqKtiYn70fORnPGd6ApBH7aMz37Ym18ow3S8BaPueTqGmlr4GO
	 lV18bKnevvzGpnZQ/bu9SmIxlhr2iMUddA4FM0BNKdErzkV3QNCMJqDeC9Y5hVHjRF
	 y7IJ6AotOxAFQ==
Message-ID: <6b06e57f-421a-4eb2-b6b0-96ff2dc6537a@kernel.org>
Date: Wed, 11 Nov 2026 09:01:57 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm: remove unused folio refcount helpers
To: Shivank Garg <shivankg@amd.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261111-unused-sym-core-v2-0-3edc7fb8581f@amd.com>
 <20261111-unused-sym-core-v2-2-3edc7fb8581f@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261111-unused-sym-core-v2-2-3edc7fb8581f@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D749440008
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: m7fzqg6ny35d4d1wz6x1hi7emc6afnwj
X-Rspam-User: 
X-HE-Tag: 1794384124-863379
X-HE-Meta: U2FsdGVkX19r5bNk1D8EsBz8N92lQQxPR6344LF45kQCcuOAWAlQygF0RB4cc0LbOVtQuMr5KfB7LZ2I6PUwdlUzsnidjc8TdSJYOgGFPyFlczNA5wAK0sxiVpbO5kAN4fkARB76d+3zOE0LdlOP3u8quruRcPXfwL4EvvwGNFzQxgGhYDZBfGlXW+jOplgOCphzaBS2Do9IBTSKKRy3cpYnwYw1tuPrUM4CWjyz13hJmbfrj5E594ZqxXzh/jO+v2CroCc9i29IdolNlRVH1eSV2hWsbKQ42sdFLtS4NodYtlBRO04wIvDQ7yMbpCrGVDR60j4aJuRCVDAkWteryjWEaBlrHLODAO47WzwoICA8us+679UfHJfBDTTqRFGlReVoOFa6mnNp9htdCBuaOUg95nd7jmA5soQvAwG/1jsFigX4odxTTvl92yFf/NikmHUcbGmDTwbPfj4dGPwTgob5Kp2/vtDHLJM2EO4hKrT9VRJ961MTrvKIw87aOIVdzqnQ78xgUs1Yl2EWGB2LjQUjg1VpD4Z+6Res+qrAQfBtbn5tdkOYaGmz9GE/2oTBkJ64iMqRhuHLwmwX5k0XpBnQzMZeyiEL5oZL9TkEguwkbrKHJjrn5Yz4rxmpoec2l5PNd4wmJP7STJKpRtz9W8qWV7LGAm3wE65RkFk7lyBKgLVg/JzV2D6+wQc2egwqG1z6juL5uuBPlcqyBeyCu2hPfaveHRA74hgmXrJIazfoRl5TGXjcGe72T0EIkJtP0g/P9LnK/hO5BsdwFbSx6q4oVYajBCOwRC0TbtzJgGvDxCgIqUv8FM5jOUAf0VXBehvtOgKg/QQAH9/v2vPPxjcnWzF80P5EPVLNNurk/kl4KPdYFXIYa2bpLbJbiK7ij7/IrxkgKVjBAncs5QAkR0NbRrUO94yyk+DULJcTLC1FUyfpgXlMof3UVjk2XmVLlCAatY+hf/+KgpIfC2p
 hKp32ZoS
 RXzctSqBNU/pVbhYjnQdnaWc8DNiB2ESvBJhuHz02fJupbn7yScAAPlcAUV3csInY3leEIuv49ST115QsxWYkBW32ZPglLclFt5X7hVg+nWzZj1DW3kKWsKsFN8OWmRHa1qPm+eelxFaF6v4VGwYhr1kawOeh9A/1MQQ7e5pa+NqYozPScPf6zh3DjF25lWdzL5FJTmQpG6IEZ1nL6xRJUGjYtnJMAgxxbQyKkFMDh183rX5RVyD3C2TsZAkAK06UgVywZv/J2yzTHnktuHrJv5mZZzNuj0cpsxsxJGkg+vGyTC10chM4/QBBHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 04:34, Shivank Garg wrote:
> folio_ref_inc_return(), folio_ref_dec_and_test() and folio_ref_dec_return()
> have had no callers since they were added in commit c24016ac3a62 ("mm: Add
> folio reference count functions"). The last folio_ref_sub_return() user
> was removed in commit 38607c62b34b ("fs/dax: properly refcount fs dax
> pages").
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

