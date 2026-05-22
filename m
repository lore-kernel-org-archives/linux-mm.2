Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A15FBCD5BB1
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 11:36:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFD006B0093; Fri, 22 May 2026 07:36:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E86DC6B0095; Fri, 22 May 2026 07:36:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4ED26B0096; Fri, 22 May 2026 07:36:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BFBE16B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:36:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 739B2161974
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:36:23 +0000 (UTC)
X-FDA: 84794852646.07.8A2955F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 92D901C0008
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:36:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I736jzmp;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779449781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g8NTFZReW6+pnL+BBAgqUWhP1zVotFDzFRoonAZZ/5c=;
	b=mDxl62sbpivgkUDHOrozfrEcMRwgaIcLSQOqgoDa9MXtBDNJd9CAwFmIvi5CMHh6xaxZtC
	O8f+ioN1CGbCrFWonHYW8mamvZqNmvU56xtxvfsVcD1q/hwp1gsQFJWfP0teY7Sp+yfUmD
	cLvJTOmeXS/DuDN3D+Km5Fcna9YDAEs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779449781; a=rsa-sha256;
	cv=none;
	b=nG0xW4I5Vl7TeckgjmeATc0IAfCxCZFy8icV2wsgKzTSE3ga9iSOOfzsWMSqIO8K7s7NKK
	IUkffXytREADPjO4I5oDKPzKUNySxL+G41yWkYxfvyQEMJKSYL8xo21wVTeTxLNJu2ytCd
	C96bDZy2K4qLkKnXmgrT6iHPnbkCkZs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I736jzmp;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7ABA9443DD
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D33B1F01560
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779449780;
	bh=g8NTFZReW6+pnL+BBAgqUWhP1zVotFDzFRoonAZZ/5c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=I736jzmpdUFs1CgqiT+FU477PVKUWFgkcv1eF0+ndIjltbxJyF5/eme2zBqIh1uLp
	 T7nYz9I1tdm1gR10+HODfTJCxlF4RDKWWu3b/XAJyUUPLMn5ELgGr/gkZLJT9VdkgH
	 Cd8B3fpW4T3Y2pex9d2piQuCHGs0KVu1HPUXGNNFYLOQYfN2rh5CERFGp+P3kCPuRb
	 RLiCNToTv6FCHBYSsnJRI7WIFUoLLjk0j5DEZukSvxbryWmc6JKM1uii35jwZgLCy5
	 d0/57meAX54tzc4jyc1mW/qeXOChYBqEVRT9F+E74x8gE6J9yHyaWwBTSHjS3iQX4s
	 ymoznme3YJgPw==
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-90d042fa745so1256142985a.1
        for <linux-mm@kvack.org>; Fri, 22 May 2026 04:36:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+A4Wgr8AH90rzU06GtZAVTbpg39NKgN7hIGmocwxB/Ph9rN0p26BKzJ/q/MTu6ebo0lSYFSxREsg==@kvack.org
X-Gm-Message-State: AOJu0YzT3BcQSLKm623LeXsuDiSrQ9AT4aTdcMwU28k/v7KkJjiw06SC
	YGvEtCDxIfjhXf71f+d29NgbKbVb7XcdlLINOD1TIly1AeEAEb+ZkTFtDc9x7NIpEJkw1S/AA/f
	lmcBDt0vlxG0sq6wA3RzKwbCzGEmfoLo=
X-Received: by 2002:a05:620a:c47:b0:8f0:7516:daaf with SMTP id
 af79cd13be357-914b498eb40mr492267085a.48.1779449779766; Fri, 22 May 2026
 04:36:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260518123238.56344-1-ranxiaokai627@163.com> <20260518123238.56344-3-ranxiaokai627@163.com>
In-Reply-To: <20260518123238.56344-3-ranxiaokai627@163.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 22 May 2026 19:36:07 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wgEVys0gG5GnrugFB7yYBWpz_3V7Ue-T2AeAub2h3nTA@mail.gmail.com>
X-Gm-Features: AVHnY4JK3euuYHGOodjpBgCqB4VdrtaUcDst_FTZLxxqf6iueHUetgxNbhUrKGU
Message-ID: <CAGsJ_4wgEVys0gG5GnrugFB7yYBWpz_3V7Ue-T2AeAub2h3nTA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] mm: shmem: refactor thpsize_shmem_enabled_show()
 with helper arrays
To: ranxiaokai627@163.com
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, akpm@linux-foundation.org, 
	leitao@debian.org, ljs@kernel.org, ziy@nvidia.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	lance.yang@linux.dev, david@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 92D901C0008
X-Stat-Signature: c6k5599dnjiu8gbatxha9nk8pp36764t
X-Rspamd-Server: rspam06
X-HE-Tag: 1779449781-79860
X-HE-Meta: U2FsdGVkX195oLGAwyRPIxKjzmg3ERsfiLl4+X9wFpLiSSRlCUF7aKNwdWTVtTBJ7vW0gAGg6mcoW+3k8r24h9nRzEG0eEabdb8fTSSOjWpVWGp+dC9nrPbCHcIJoL7Ijbu0M4EQkPr7nB84e8a+lJ+xdxVCQVR/M79b0rxLeGFmxEAvW7KxWtc1pC+MQ0xtLZ5muqnVjLC8VbdKII8+gRFBn0n9qoF5pO24tLk1Va1KCsWawXIEG0BGzwzpYAO+JejUmHED82qktMFK4PlUzv6tNHWq0UkaQDw0TEwwjVTo44TB12DwSyLc5aNNHahcra4WWSskzwjwWiWHfslPbup+08g+7o+j46qAPNxg9DCdg1xPgUX9sivXw3Pb2aRJIF6n4gobJhULxunvubTshSrnoV3mrp9SsEmDGj8zMiE+4KMrp8eu3yoK7MfUqvsaPE0FUsNTuV8GNll+mV4YrT6SLu1eNzFg93rAwl/G1VNt8m1Ci64xg6DVLuwqJfkhcbexUpCw9bmk4YdLkLMhzEX68Ox+LN5UZKNt06Z10lonW9xvkcBDTAiXZpHAseKhl93xicHzgyTnsgEzw/64UDm1hQ40Z8dQw/TJYNumJm3QfWHfP3LdG4lyLWx4CX3aahcP18iR261NAqKK+C5pkX4VMzCqBTxIAKeCayiaBEcbSQxmVCl4LaP7PyTJjpCLl/bPugT6DQ/ysUAGcNkek7mZm791QEm8kQuob0OwCu4y4uIq1v9/fej8y0YZahcq6uMG59oGfitrZY8Czyj0mYJYx9LUK181drza6JU8Q0twTRH73kmHiXhcl/yRRzOBxeIztCeswfi/g0SeixsAhapn0RCC5FrKyJEo6K9PkRmmVj/ADKHhWwFY+zODePvzBwbhC/6qOdIai2pIuY9llm85tM+w7K95UYnRvKGzTqPYx6ykfZkHqiy+/Y6Lqa2gz5kFqYWNEDmrd3g7Mws
 trMg3UXA
 32Jtnz6o8F47C0vVgQPRToo/zQLvTyR9lT3UwtBty3fNlL7u3kTH7uFv+ssjdl3i5CxBBAlOnA+ElGf1YIN91FYxBjchBQ4SqEuIjKobSBmTDkCXBF+SN+a02Ko2fWo5GF/Lc+ZnknVgHPOarF/fQkjC3YI4jXmfeuS4/uXRrTfWmQD82RmY1nMd4hyF5+jQ2ZuCLJYIlmPZOKA2lvS+0v+Ge5oc53RAwCsxapzvx1vVNNFYtZHUTniiKFDw9LT3o3F0pvRbIx77LrFzESXqbe4CouVM44PPV5E2L2bVXOapbek+MhfBKIbt+5EWLVGlEHG0eFbKeaSzXunJ/EQrNHdq5Ue/30HK03wogokL7BVUZOx9A9xPN4R28deBaagKGhmpvkWTAw8B98KyLFFbM+h144zQ0L8JGgTsQCVPcpWXTMmzRa0NIf1LK6r8yC4/31xzIMXVdRyGuUEtK7b0eK+SMIKTEYxonR0fNjeUC6nNs+gQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 8:33=E2=80=AFPM <ranxiaokai627@163.com> wrote:
>
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>
> Replace the hardcoded if/else chain of test_bit() calls and string
> literals in thpsize_shmem_enabled_show() with a loop over
> huge_shmem_orders_by_mode[] and huge_shmem_enabled_mode_strings[] arrays.
>
> This makes thpsize_shmem_enabled_show() consistent with
> thpsize_shmem_enabled_store() and eliminates duplicated mode name strings=
.
>
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Breno Leitao <leitao@debian.org>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Barry Song <baohua@kernel.org>

