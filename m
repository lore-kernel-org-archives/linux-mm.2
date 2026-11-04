Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94ABA606A332
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AAQeB94N
Received: by kanga.kvack.org (Postfix)
	id B22786B05B7; Wed,  4 Nov 2026 08:26:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFAB16B05B8; Wed,  4 Nov 2026 08:26:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A38946B05B9; Wed,  4 Nov 2026 08:26:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8182B6B05B7
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:26:37 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0E4A21C40C3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:26:37 +0000 (UTC)
X-FDA: 85397511234.08.718CFAA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 747FD180008
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:26:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AAQeB94N;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793798795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pvQk7gkgjyECtllSEXxMYHx9i1xSAVAK6APJPPvCqm0=;
	b=s9q97fsJNegGWhQbv6DLl2lK5lDG4+IJaseJ54T5LUW94AYhAkHTamE19pokb4DAxONlvz
	T2N2gwYfpvmZqZXDuhY1YDj5k/wVG5gL8b7zFBFBVo9rjDlbm6ch5F70hgS4Qq+He3Li9T
	tWfbrXKKuzW72SKL6cjfDkYL7ejGRe0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793798795;
	b=t1yNbMJUN7NB543hv9Hx2QrNyXwWL4MKC5owzdxBNa0py13bK9qAM1Er+it6Z3rAUg0QCn
	jm8sz6m9n14HDqlZOjuS4OAG6jDhij12fBFHose4mpzTXJG2gisw3DAib0HKf0vPfftJhl
	tWSBWTUfOOnBFXchJeRtNmjZHzjUG+U=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AAQeB94N;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 92EDB40356;
	Wed,  4 Nov 2026 13:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9C61F000C1;
	Wed,  4 Nov 2026 13:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793798794;
	bh=pvQk7gkgjyECtllSEXxMYHx9i1xSAVAK6APJPPvCqm0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=AAQeB94NpsdVxdbYF50v7JrxTJ1MLmAG6T5ILf5+I7BHKtmTQeMeLUsVdV9aAKJVb
	 F8aobQ2oDHgTUEkO+hLUrZO2Fs6BLUEX9y/S/oqQY7sF61wAP95BBkBCz+S2kZIm7M
	 2qygBxvGCen/9kY8WP5FXnqVn2NYpENQNyoFzj6xasHx04ktg3N7JTbponsO+FBA8O
	 MTq59fCOT+AWqw7PxNNGuzK5yvxfXmIt6oNkjBUWq3LDHFJtB9aJHmvFZQAf7pBYf5
	 Ai+VKaIUMG/mOwbCQu68+3iEQ7bkX8G/U0l1OHYMA92ntsVjriWAeYkIvkV0ZemmzI
	 mqKBfJJ0rQ/1g==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-kselftest@vger.kernel.org,
  linux-mm@kvack.org,  Alexander Graf <graf@amazon.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Baolin Wang <baolin.wang@linux.alibaba.com>,
  Christian Brauner <brauner@kernel.org>,  David Hildenbrand
 <david@kernel.org>,  Hugh Dickins <hughd@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  "Liam R. Howlett" <liam@infradead.org>,  Lorenzo
 Stoakes <ljs@kernel.org>,  Michal Hocko <mhocko@suse.com>,  Mike Rapoport
 <rppt@kernel.org>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  Randy Dunlap <rdunlap@infradead.org>,
  Samiullah Khawaja <skhawaja@google.com>,  Shuah Khan
 <skhan@linuxfoundation.org>,  Suren Baghdasaryan <surenb@google.com>,
  Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v3 02/10] selftests: liveupdate: Add tests for preserve
 and retrieve user argument
In-Reply-To: <20261103010216.3447716-3-dmatlack@google.com> (David Matlack's
	message of "Tue, 3 Nov 2026 01:02:08 +0000")
References: <20261103010216.3447716-1-dmatlack@google.com>
	<20261103010216.3447716-3-dmatlack@google.com>
Date: Wed, 04 Nov 2026 14:26:29 +0100
Message-ID: <2vxzzevok9ru.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam06
X-Stat-Signature: xdy9kn8yih6835efqinym75u9p5tkjrx
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 747FD180008
X-Rspam-User: 
X-HE-Tag: 1793798795-812610
X-HE-Meta: U2FsdGVkX18ESUMSwkAEqoCEMq5vrdjDwiub3svDTzWN8b20RLjyfr7vux+AC+jTWk5ARH+DJ69gutrrhvP7veIzTicPGPwXRxsEy0j7Ixjoxg+8DdLiDycfJ1jLZvy8bWleOk4bNt/pEgWd8ME5Kj+QfL7hFYPOSgNUFKWP22Y8ZQuZzp2kJIJF2jj+kod7ve0WYBoq+yJBtF378LUlZZN/QTX2AROIVkwymMrgeL6nV5OS1p7sey0faA7fOEZnxX/r+IVx8M6aDBL/cqBfH7jxLRYVPSAlXInOXrygWbB3nqgvklm5qnz11o1v8RUEw7IIFd2/567QfNnbaNd7RGOm26FMk0RIBA5QzrCyImYgp7xnTqXObO9a6gShhxv3gidpb9HuxMTa89SyK56E1j7o21rr13Vcswt7wIrTJ7xwR67LF86IQTrak3670dwrINyxEMtpl5SDr3gduxqpWwBShScVygfG9mZs3hsopmeOKucM6Qi0MKua3EguTRR9hgu8hLgoKJLFSdU0CfYgaVDyj8ooFWB+66JOrNgdRMk8mbIGkd9aZdwsG0He1Cv0XE2k1S0t4VyKQATJVtnswUGNO0mdsyzKM8ZK7OJP299eX5ObobRMKtlCvpIsI/uVKjtuz+hkEx99RJiHensImJBs3d0sDzEQ6uxQCWOrP7M8OUQCw7faP0D5DJZkXJgq/rqd7LAhTuv34cObwuzsAOSpssLp6w88vdMXKUhDwNIGvC9bB1fFemz6pRxFFjCehops2ei2J4TTyj375ZhHsHMjQEfG7XHUVMf/XO1gDWwdoDM0ssDttmjJCUca5vaGPyC9Xzy2SahfDghtw4Wt8T2GTxlvpb/J4kN8ArQZ1ZySQVSytQ9oeRFUL2TqtxB670Po+A6RLFPtK0RruLzDuz1H477lW1sVxvwpm95FlaRQeYNp2VsBtI5nmsF/2qViJK9dlRIQ/l6ecolBXxe
 et+KlXqS
 avLqCTHNuf5tVRUZlEm7j7323Cs2mJuUHsYrtPc9CHD/8kgpya4LUutSBw9YHmJANOuHfrxModpF2f2DM9aoQ6gY86iJRk+LKPdBv2BpoP3sdS8Vu/CdMPH0/9Je4uGPDGlXcf8E0RE3I49mST89fnzRyce88401sAXqG3WbamEoFH8BKxybWOAJwhD+yA0TXx4SBw9C2Pq3rJPLyOjtDm8YMhcNYvP4Ye6NeFoyl1nLeEf255mLJUJzYL2efqkdtcyh7kWm5sRycxYsZQmUWerHBmu1D7RFRN4SmWlkamUoXSv8I12ZTLWGIGkqGxFXkWF7vnr0G44eSfRGCS/X0msDkxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03 2026, David Matlack wrote:

> From: Pasha Tatashin <pasha.tatashin@soleen.com>
>
> Verify the user argument support in LIVEUPDATE_SESSION_PRESERVE_FD and
> LIVEUPDATE_SESSION_RETRIEVE_FD. Add luo_session_preserve_fd_arg() and
> luo_session_retrieve_fd_arg() helpers to libliveupdate so tests can pass
> a handler-specific argument.
>
> Add a preserve_memfd_with_arg test case to verify that memfd
> preservation rejects a non-zero argument with -EOPNOTSUPP, accepts an
> explicit zero argument, and remains compatible with callers passing the
> legacy struct size up to the token field.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

