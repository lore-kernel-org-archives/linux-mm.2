Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD5CE606A32A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 01:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BOjEfvAw
Received: by kanga.kvack.org (Postfix)
	id B86366B05DD; Sat, 21 Nov 2026 20:22:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5D6C6B05DE; Sat, 21 Nov 2026 20:22:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9C0F6B05DF; Sat, 21 Nov 2026 20:22:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CC7F6B05DD
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:22:37 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 089971C3DB4
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:22:37 +0000 (UTC)
X-FDA: 85461005154.25.7AA897A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7A4511C0005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:22:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BOjEfvAw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795310555;
	b=3v21pmYrXeCK1PBzbQjut/WjN4VVi4YTJ85Y/+uRo8LdITmNaZdlAgGRAYlgRFxaluuUEx
	B5qUNOYxreTAUGizvqvyql1gkoLQb88sx6n2H6+JSSIxowBQcib4eAnCZJtKY2d3vXY/Ij
	r6rqaHug1eqemOtmFyt6r40+uUcbTuk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795310555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zE8gT4dthHqcTUv77ew8bDqnQXZvGmO379GEAq+aYmM=;
	b=VAgMArQALRlJTnQ9wSRH+iiZDqL11WYO5tV5/t25jCkuhcSVZCl989YIgu4ZZmU6lNDj1T
	GJ4a1CXsNKTblKTnMZDfn59cQ/KTwJQ49BV+qIOQVx6Z3kmuj9l3ZdFimTA0K9PLRk6A8K
	cih0YPGa9t4ByxvgmOHLi/taOVsbGo8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BOjEfvAw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0791D6129B;
	Sun, 22 Nov 2026 01:22:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BFF31F000C4;
	Sun, 22 Nov 2026 01:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310554;
	bh=zE8gT4dthHqcTUv77ew8bDqnQXZvGmO379GEAq+aYmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BOjEfvAwidbckoqjR4wNrgB9CbuljWYbNZOEhAFhqfQ4NZayeIpUIJzYmE29QtyEE
	 6tUxCfwpDQJ/uMb6T24gDoLrh3q3I6oNui1kvs4kx4SOQzEhVy0iDeRGqQo4Q1m5Fx
	 bsSu/X+eX+G2/aE57Ofwxjt1+ouyLaYjhdahM9ds6Mf+JaUVYz+Rb7tQj8f3O3pLTq
	 G8TWLbT3sBC35XU2vlD4nCJ9ERR2OwIYJV18BZoZGuYRwB//xd0N4pvlcjTxbeF7m9
	 DPxA2bZWE+dFcJ5DYsJbVG8TiodDTrShUt7xleVmTU5lh20SvmBGrRzAJ4IkQ77tGX
	 +pAVZa5vTkvgg==
From: SJ Park <sj@kernel.org>
To: Yifan Feng <evanfengff@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/damon/core: do not overwrite wmarks.activated in damos_commit()
Date: Sat, 21 Nov 2026 17:22:21 -0800
Message-ID: <20261122012222.148520-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122002930.98401-1-evanfengff@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7A4511C0005
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: 7hs7a7sg7jhtnyk9iswu3bp5zsu67pgg
X-HE-Tag: 1795310555-879036
X-HE-Meta: U2FsdGVkX189quY/f9HV6Ewbgx5SOyn/jROW8h4GBzdy6qETTb4t6ykNhjAOGZMSJQXl4NQJ7gWA65DZzV0H9zx98Pe7V+KVbkjbkpNpufYpb13I5+IH109hd//9OmvPHJ9uucptCLgk8v+6ZgAs9iDYuW7XkRCWU/OoashvYZxxbw8sZ15D7f9EInRsDx+flm/O0Wi0qnjrnOtdx+SgMeN4b81gfJNa1ku8gMFivbKslSdre8CWORJEPZcV80KUWiPJ0ia2RnM7S8jSqmtDFI+o/w4XlZk4mN9Rf5QnB1EUgGNRzQh7EkZdqpqi5qNMWeddt7+ouW03ysAY1hA+Tx+VqJxyGBqKTctc2RDXePU+mqezghhC3/k7j1+lijUQ3z7/QmsYgLmJH9TUxuVrCDaxaN8MmrkxpUEiL7Do9VE/cRCu1hLBJDK/Akj/s+2wLXpaZzoKEcAsaEV2wkJEt03MTwx4kBKe9/BnKGPiQu5gu2ZacV6F+OwHq2dtfH5fvQAe+MwKJnGpcMe2X+ybCkynUO0j4cuYsiUxdQA/p/h6kjSvQocoRQGLm4ACBVeCWPvklYXmdP59r6FhJde/DEsPuhsc8pVlHLO2HwvPWDNafnfU0t5Ah49zYLqfW53AqG4YpmphocGCsds+OWjQE9q8p4DB1djTL12gKAheIDo2O5PoN4iitbCVulfiTGlRv2v1nEgAa4qdelAVEXk9wfYTnlafgRYg8qDmdrqc7mRXqrRp2MVPBccwraszscFQvyBjVHd5xgLufeh33XNX6fG7G3nAnDdURaYec1NKQHYk7BUGgYlDF+0OrTBeLKpu65/RhWzO999JI1aPRChemRykW2exK4t4FdOJCEIL/okJ/lRLxrh2qJpS785IU8tAuvz4YxJ8lT3+TaysmD65be+zvn6aY/T0KqMt8zYLrVU0QrtmiQQYTcpk7YdxSbjEMf494MdD11CiN/cS1OP
 7PU2nWwB
 k/AbfOlltiDh3YrF1MRd4bq+mwqq7XjY2w7gdz4av5vs/f3RJv5F63tyTL4u2PH2pnJY7ypx6QtWZybBA6Mjctpq54N2VBnl8bzgO+1f0IDaO15yVVUjwpaOsueVD26O0fKiYkP57QrnaAZAA8iCiFE+Si/1Y7OoiYud9l+JHk9i7Pur+ASxz5bjq9DBv9vr/28P7UVYmVfsuuc/4LD8+44YgotOAuQW5jRL3VUP9H+N5lmCLlGZYucygV8ZT72rAXsx6P0vqQdb3i7FFir5+XpH7FDdyCiZwWGU9bZpJcEtOJ6BuUmTlI7nYTuWbCJ322ll6czaqFLFsHIB2NpjezIPooHKhO4TB/DTQhecNjEL7Pt/bTKQXmT8fXqetkCLH84g/sDIvV2CNdn3YDiZC8H2dlnfBaodq8I5bG55eUU4cUoas6KbtegfTGXqEsp1yVkxT+PXjcJUnV48jEfmeNMzvI6QAiNECqCW4zqm2UuguqeHt6XT7WLVWbSYJBmqI5CLY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 21 Nov 2026 16:29:30 -0800 Yifan Feng <evanfengff@gmail.com> wrote:

> damos_commit() copies the whole wmarks struct from the source scheme,
> including the private 'activated' field.  The source scheme is a new
> one, so the field is always true there.
> 
> As a result, a commit turns on a scheme that the watermarks turned off.
> If the metric is between mid and high at that time, the scheme keeps
> running, though it should stay off until the metric goes below mid.
> DAMON_RECLAIM and DAMON_LRU_SORT use the same path for commit_inputs.
> 
> Save 'activated' before the copy and restore it after.

Thank you for finding the issue and sharing this patch.

> Do not restore
> it for DAMOS_WMARK_NONE, because nothing sets it again in that case and
> the scheme would stay off.

Is this really necessary?  If not, I'd prefer restoring it always for
simplicity.


Thanks,
SJ

[...]

