Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A63F606EE9E
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 14:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YL0mHBdN
Received: by kanga.kvack.org (Postfix)
	id 201046B05B6; Wed,  4 Nov 2026 09:12:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B0F36B05BB; Wed,  4 Nov 2026 09:12:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CAB86B05BC; Wed,  4 Nov 2026 09:12:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E70ED6B05B6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:12:35 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8D078C06F9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:12:35 +0000 (UTC)
X-FDA: 85397627070.18.5AA03D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id DA01612000D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:12:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YL0mHBdN;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793801554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=onQfzVmJC7HohmP0cLeGwtdRODbHCJknVIWGqjziqDY=;
	b=TXW6i5Y+M2KyUv+ii8TAbembqVNK9xhRhYjFGlx7akIV6dV3VhYEKccT1Q0CBkEiaAFIWf
	x9PVPIn5JhMZf7Jm3azjffhHuA1tK1PWanSPuKLOP2Jm1fpK1byKfZxV+G1YHIIgqxyW+c
	hLHJwjc9M7/5dy2HMpK5wdLyL+hnm/8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YL0mHBdN;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793801554;
	b=NO1hIxrzW6yKLZXe5fLHnPnY53GWpst9fEUKUP2MT4FiZsmPjy/JhNpjdv0+muV13RN4UO
	wk1w2QawSnQEnUZdAiZKApHtr+cRDJozvG4m9WH0ZNDGKU16PIyUWCIwSiio1cS7iG7SF9
	6MHtIu9H3mF/6+5skQT7heFlwfN8slE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CA6943A73;
	Wed,  4 Nov 2026 14:12:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432C31F0093A;
	Wed,  4 Nov 2026 14:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793801552;
	bh=onQfzVmJC7HohmP0cLeGwtdRODbHCJknVIWGqjziqDY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=YL0mHBdNDiunlG8rrAEkkTaGCj1hrgX75U4z1Ml7hTgNdeY1G7/Lqev+aLVQR+Qpn
	 TdKK4Vzx6TtBRwXZ0bt3OeqzYSVcAzAuv0DOqjLJZibnLWMQIU/66PYdTMkEiIBUUg
	 oj0qzD5GM57Kb7BUN+tcdPhyVuRQ5maPjgC4q1aYirAW4HGo5HdtYvdCLd2VdgR5bZ
	 xrKT2Zx3kw/mDTMaP3mQK8OQ527/ncS5Cy74zMQDkUzrend2XgDr7ldd3EqnS2iipS
	 eCkX7zd4zq9sxqWgYQwz2VRR/vrIFIjwhVNMy7fdS2JG63WulEzNoe96K2ooNFMRV5
	 mw0Ektf6TZZCQ==
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
Subject: Re: [PATCH v3 03/10] liveupdate: Allow file handlers to mark
 retrieve failures as retryable
In-Reply-To: <20261103010216.3447716-4-dmatlack@google.com> (David Matlack's
	message of "Tue, 3 Nov 2026 01:02:09 +0000")
References: <20261103010216.3447716-1-dmatlack@google.com>
	<20261103010216.3447716-4-dmatlack@google.com>
Date: Wed, 04 Nov 2026 15:12:26 +0100
Message-ID: <2vxzv76ck7n9.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: cxrsi4oedfweu46grrt45ogatmafb4e1
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: DA01612000D
X-HE-Tag: 1793801553-631071
X-HE-Meta: U2FsdGVkX18yrQy064cp1NG9OBQCoa7k8sqeXQE2oT3zEtVNRIL3mhpADZIbFY1UHBFrYZhY2XfD/uNvaLIv2jLUiiv2ib8kYAzIlWF6XhIC7jF88mvjeYBeQjg4yQDPPjuyF/Irq60CASlQsDSJ22iX6dH7YhYbhV0a33W9xg1jx7K9SNpLIuAxsh++se1qXuuqEiPV3btF6Dw1kd0bg1qV9tUHR5STZ3BYPfBGPKz1HT/7XNQ5CEFnd86X1ZXODPZuHjqSBe2VMiwgIWQCMA703DSqRQG4Wv2aM/B6/yDceRc6vIe8JtQGXSYZfAORWHvd7n6uSdmZmtDZF4uRbsO/tXLbrY5jrjjXeAV+BkrjgXZy+qjm/ajI0dO59kMZM1o3mCTfJKvvazXeEC5VQYuvV7IdwbCC4vkLULqKV7f5Mv/Tiz35ecajcsxwZyOYbKnR5RKDu4xUl1YuIKYJuNz6xbqRgkg6ZXsdjopMA5s+un9zfF+GJvPb5jYerECUBAjQfiphZ98qIhvisL/5nfMESrzPCVPTOqEuaUpjE4DE3NQbA3Norgp1PUrCU4hwZtGPpi9FeHnF15O4XDZgmNkpWKPF/byj1Eqxb9lii/qTtu3WuUF7xc0CvMe+EjfIUckcFRjbzPnYEYcIjiqPyGx4x6QFkeVGbGZOaCATJFix28g9qpHyOjQv4UUK+B7mgx3DWQOdJMbtAbZJ3qZmirmTUe1VhNIsPgVCynWpXKAGQLq9JxemHeKeDNGKyUi+vqSChK0Lmu1/j/ePM1ikavu6DuFY2bLAvc0owXEXgW0aN3VzCCevi65BqH0xwBOW/kYL4/ZK44ltBafrTNwu1rhZ86gIJQ99ofVJzKYrsi3txwWZopbj4k4hUGVpFhU2WriqCZOR5DmiyFS/Rk4BVC0v4SvMxx/dQ+BQB6VMVltBK0Jdw2TYDsgysCb8Wq1iXAKkKugL32ozJ2kDRjK
 vIusatgK
 WFNnRYH2/JNUZW5TTV22noFoueajR3Khxkb6vW56dJAUtdvlMBXhUFM3cutA1QHvhfNKiX4fuZqrtIFn2iSFcS1InKuyfAj0D+tFZ4YxWLWL+XB5pmrlf6hQg4lYX6F46vgUgzH7aZQKuPdMJL0Ea+d8KS3o8c+tMp0xNvsyOQ3tO4fsZIX1c1+XVwgO59KQo87hNphOFMhGru/WOkbyZBeePAc4hLqNuaSWK3ushLA39g0iWef0+HwDL3xi8J+A35ozv0jbjF4dJIOn3+EHjahDUomwdmwWKQouVUb7E87o2Unc=
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
> When luo_retrieve_file() invokes a handler's .retrieve() callback and it
> returns an error, LUO currently records the error in
> luo_file->retrieve_status and blocks any subsequent retrieve attempts.
> This is necessary when the handler has already partially consumed or
> freed the preserved KHO state.
>
> However, with user arguments passed to .retrieve(), a handler may fail
> early while validating caller-supplied parameters (such as a missing
> argument, an invalid or read-only target file descriptor, or a non-empty
> target file) before touching any preserved KHO state. In such cases,
> userspace should be able to fix the argument and retry
> LIVEUPDATE_SESSION_RETRIEVE_FD, and if the file is never retrieved,
> .finish() must still run to release the preserved KHO state.
>
> Add a retryable output flag to struct liveupdate_file_op_args. When a
> handler sets args->retryable = true on error, luo_retrieve_file() leaves
> luo_file->retrieve_status at 0 so the retrieve operation can be retried
> and .finish() will still clean up the unconsumed preserved state if the
> session is finished without retrieving the file.

Should we give some sort of signal to userspace whether the error is
retriable or not? How would it know it can or should try again?

>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
[...]

-- 
Regards,
Pratyush Yadav

