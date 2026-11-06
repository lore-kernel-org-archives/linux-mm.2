Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6CAD606A330
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 18:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DRVIXeTF
Received: by kanga.kvack.org (Postfix)
	id B44506B05B2; Fri,  6 Nov 2026 13:52:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1B7D6B05B3; Fri,  6 Nov 2026 13:52:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A341B6B05B5; Fri,  6 Nov 2026 13:52:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E3C56B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:52:23 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 069381C2098
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:52:23 +0000 (UTC)
X-FDA: 85405589766.15.D6172D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5C82118000D
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:52:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DRVIXeTF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793991141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NFADw0Cbc62uc2AMQXbBE+aAZ5zUXNcwZalJhnl+qq4=;
	b=vz06qk1TW9c4HqHW0TWbkbG3sxMPNPWqVfH2vVT9tuaMzGDavOrfGN4fbgPfGq1gT7h3Mo
	ZTWHL81EFqWqwSx2WM3kd4s1b2RS303L9LkhV2faamNpoEXmfTAVhoRP7Pln4i9H1cu67t
	lCZBZCqxVt3nlun3zVXEk6qgY8s7xTA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DRVIXeTF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793991141;
	b=efaxGJ6kA0q81CckA6l9+gVmK4l7v5PqUaM6CCZkDWEi2+fLqPy8wzG4JaIvu1bhJ5W46K
	L4X6YEqQambn7jD4mMhvSB2F0ClA/SgKBP7oiNWBAjAzg8s0tp493rbCPUx4MkRdh39v20
	UcV+eOjHvdsFOGOzY/Ihqn0cQ2a4xnc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C528860145;
	Fri,  6 Nov 2026 18:52:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C271F0089F;
	Fri,  6 Nov 2026 18:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793991140;
	bh=NFADw0Cbc62uc2AMQXbBE+aAZ5zUXNcwZalJhnl+qq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DRVIXeTF1sT749plPS8cLEdj0DViZpbNU9EH4dHRWnD6jW9nmx2I2vNXjpgXhOnHW
	 mdFfo56+VtHixkXs07dTROaLypcyVCfRiARhtw57PsjMjffDKVWfSHOrvOysPhwGyU
	 HpHmnOZCC8V0gXXDUKMbrkDluQAaIgS6gbZTSQ/Gf6PMgZk+XW5VLqR3Q1q/Q/wZ4V
	 DCD4IHa4ufOx0lTzESttfe99OzJ29goHvkomprNqBrIjvPT729NVKyF4kooApV2KqE
	 XxQ2KXKkLQAjxx56YNrb2x/zk+ciOh2mCOKw1QgJh3YuCNWgES89z1lyDCcBJ3YtaP
	 sJ0+bmYk08GSg==
From: Sasha Levin <sashal@kernel.org>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: add CONFIG_DEBUG_FS to the config fragment
Date: Fri,  6 Nov 2026 13:52:18 -0500
Message-ID: <20261106185218.1766376-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <179397467526.9397.17872200045070830000.b4-ty@b4>
References: <20261105171801.2189772-1-sashal@kernel.org> <179397467526.9397.17872200045070830000.b4-ty@b4>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5C82118000D
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 9kq8zibnpbz6uhwzu1d4e1zus8egx5f4
X-HE-Tag: 1793991141-153019
X-HE-Meta: U2FsdGVkX1/l7sGyWAvy+A7dc48wKKGnb4YIjl/EkC45Hbk6abE+dp0V5yWj63m/Ji+C3lyhRWbLM51jxc/o8W0NC9j0PpmBfxsBDLH0NMh7mvF+1YKUngnRVX4h74XeigiWilE0nH769Q+yxn8AhGNx6l3ePUvnSwuSgVAblrXTat7mxSO1sl5d7XziNwVmF2QSoZqGF3toRaK8SnuH/I2HxgP1bBMi+b694yuuQnkcdd/WlGWh13LTuBhz2pJOpqtsPt7TJeFPQiKVCPLm1U4+POvCu2KlYHPQuKnyOIS4gD/4NxL3tzeNQtnl9nOQHnihVGQSfDBw7QDGWvy8ZBYxFQpTjAs2aMboecT6344VVoKPxdAL0NlqZTMUW8cLsLw35v+UZNdTINne1NXCJ3FP8YcFwS7cxJP0vdnGrHCEiQcOo68mc2ynVUY5RZ7w7PFcYiwoWZorYre4qvVtsx1CfQe/qdaeFlUYikbOU7+QPOo/b/FJviQSwkpj1JTn5MD6iLB9CTmwKjBJJVJeI9gtEElFPWQ0SKUjyRL2VIsyQPG5JUWWfcunkKHBd7qvsjP5sSRetzjfk2lNUe4C1OoJMt6szaVpfJ1VsSEMDJX3tT2GqBEB4YKxOgc9x4GmbNdNCVNNzf2emiObe9PrY+Pthda6sa1OvIyvfspOvUPuHxduikAFaukye1SWJO4HRG/F+GfDJDjpYmEI/bc5yyTfp5GpCgYXG6yx84WRO0xcQbJQhEfTE010qp/OFbmka4kbGIraZqL3T+SCdmEb4TaOCP2T1Hc257HynzE6r6xMmQyIBUK18TLHmkgHZ5FaWagp+OQhXoLJVSUQTJj9YMTDv1LWTte7+dznPBpVHR1pHZUvrPDmDHP5EphwwjMYEiOFsSX2/OogkQrr1f8gx1arxdaQ2p3iVKM8IpmnoNgQanuFUxymM8U2vmagRwGQsfdKZOPeI0oiPAFW/WE
 ak1Hc7uN
 YkGbHvGtvqIjoEYgVvMarIUVQO18IiqWWbjnpGQFBSq6jb+rWs8/IzX6Wj0Un+VOnhllDmBJLteqbWjTs/QTlaBvRJMwNUzafaxhIq+NGrAy9r6Pn9s8mDUeWY5nET8GsdTHm5BPN3GKhp2NaER+uuqt0o6BofTGcI0f7aoRvxm/znXts7Vl455GWrWmkbRGjKBXGUuBtMXeC8s5MKV4fvkCXjc8lKU0dfJ1NuynxbC9f6QXLncrZps0fpz6oA6jd9xCH6WEC6jl0FlTdMezY1TO2iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 06 Nov 2026 15:17:55 +0100, David Hildenbrand wrote:
>[1/1] selftests/mm: add CONFIG_DEBUG_FS to the config fragment
>      https://git.kernel.org/mm/core/c/31ea5515

Thanks! It looks like this one landed on both thp-7.5.misc and
core-7.5.misc:

  31ea5515bf59 ("selftests/mm: add CONFIG_DEBUG_FS to the config fragment")
  194b63198811 ("selftests/mm: add CONFIG_DEBUG_FS to the config fragment")

Was the thp-7.5.misc one meant to be the split_huge_page_test skip patch?

  https://lore.kernel.org/all/20261105030242.1241448-1-sashal@kernel.org/

--
Thanks,
Sasha

