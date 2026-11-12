Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 661D2606A323
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 05:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i5nfBbpb
Received: by kanga.kvack.org (Postfix)
	id 945C86B05B9; Thu, 12 Nov 2026 00:01:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91E246B05BA; Thu, 12 Nov 2026 00:01:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76FAF6B05BB; Thu, 12 Nov 2026 00:01:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 465A06B05B9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:01:12 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B4D81140141
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:01:08 +0000 (UTC)
X-FDA: 85425267816.24.45F29A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id DB288140008
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:01:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i5nfBbpb;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794459667;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jcZ7x1zM+wLnMggYQ7g6vUZ5Zu0U6ywlPhVdWyX162w=;
	b=E3/j9VfPFQG6yI3IDyJuUVZ6bbVX9LeEfepNnrjNGayAYhvuFvl9w90CCVi8A5BqPTvPpz
	uFiiOUwuzllfNEBCeZJhewp1FjOD3h21sy6UbFRusrZm95n5MSoeRsBzB+9FcW6A4gIhwQ
	IOOLzfVnRXjBGx5/83rs7dGo2CHZ7cg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794459667;
	b=1hSq9zx5/sM09rt89wJbCOuxjqnErgx9CY6RdcaSkkuaYo/4P1ro3m1OnICwfw+oOZ0fy4
	9Wm63XqaAHyXnzqznNEh2ojLdMkvYdPm7quxP5OTqdrHWzYZUrvlL7y7Z7DJ4B3ZgjupyH
	CBIk7zpmGSgO7O2Knjr5FI+fR9CI4h8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i5nfBbpb;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 60EBA6375E;
	Thu, 12 Nov 2026 05:01:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48D81F00A05;
	Thu, 12 Nov 2026 05:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794459666;
	bh=jcZ7x1zM+wLnMggYQ7g6vUZ5Zu0U6ywlPhVdWyX162w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i5nfBbpbunkaLyn1y31f5aIgw0LzBViJlIoCOuTY6AnTQcnFh43YwxE2UOkJgn8U8
	 TqXFR9jcTFRouozGKnvjTaaiUvDEOF6HzmINyTY3rToqaRA/cIlQ3FsSvoHUmrtRTX
	 YUzJC/yl05MXrEpSmky/urybnuR89JUIB08slM3D8fZcmrPwvH9jekHPM6eQ1zmGSl
	 7tGK8Q5lMfBrQCluoh55+SVb/a8MBG3oaUZR3QGg0LMx2Zt2iMO7vsSJW5k0SlKLoD
	 Tg755esCoJod1V7+fDJrXqdpTFv8Rg4OYJY3WDqbsczKZxU/KDjwHGcv/O2TELG27i
	 kQ4bJt+9sRikA==
Message-ID: <sashiko-outbox-210418@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 10/16] mm/mglru: Run aging when pages are rare
 outside the youngest gen
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmFycnkgU29uZyAoWGlhb21pKQ==?= <baohua@kernel.org>, akpm@linux-foundation.org
Cc: axelrasmussen@google.com, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, liam@infradead.org, lianux.mm@gmail.com, linux-mm@kvack.org, liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, ridong.chen@linux.dev, rppt@kernel.org, ryncsn@gmail.com, shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, zhuhui@kylinos.cn, sidchintamaneni@gmail.com
In-Reply-To: <20261111232603.9934-11-baohua@kernel.org>
References: <20261111232603.9934-1-baohua@kernel.org>
 <20261111232603.9934-11-baohua@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 05:01:04 +0000
X-Stat-Signature: tfh6i91hb3j167bnyyhueh78wqgdogek
X-Rspamd-Queue-Id: DB288140008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794459666-242455
X-HE-Meta: U2FsdGVkX1+OAnX8TSf+8mNFXby51j6ubnA49fkWqxTh7R3UPNVOYiAC9zzxBl41fQ5gY33QTy8Jl+8cpjc0DkTexsCUM6aOBzgzh5G/Sxmb5ATd9vir5zA5zdDuhguRfE0Ge9dmjFe9UbqRXcAAeAW5tbIeFxoy/yR+2X6A7PG8BYF0sgmyB2EarHx2UU7OkB+vCRpyGMNHUzf79QNLYkKB7QhhOqlgTNpBggd1vKs6SGUhcISGyia6Q7+uqGLpF/SLOEgGk8TmIqCpEgpmYIJ/Nny+obQ8vH3x5WJlqri6Sb+WPkPQHLN0av72E8CF1G27dGV7a/8TeyWSkXDZlFvD4K8/6Cf0OEXxgVd6r9gdyC1otse/R1u1BwKWYRBuAW37hLeAvK549g3djLfuUCTaW1TU8TOKg+mYG2nIo/S0QY+5TalV3PecCttLFLny5DwZCQfKnM8QMv9oLp0SmIswj9Gx9k4bdXh0ZVVFe/1OT4URr+3+5TpyNaHDJWWIz78Dt3TKnQdtKTKD1OZ93pID5d5IbGBv0hNkAjYYBcog/95vJGjtUxn+AAT+TF7H67X3w8iaKLdeI+0/yKp211DkCtZ3ijvF3mNwSveGcJzXrnkkQQuqKlzwIpIQsOhAdiUVlw+kwfyGHccHVAjjwqED3soipnTDtV8OP7zRh837HrkAoDeuDS8c8OBRCi+r9JnNoZBspUucANsViHz3SVx5FUj6ESedYczgSaLChxy06nSs+nnwcNPPZO8UyAT4u3fHaATo1XL46iSOPo6Y8wgrdiyeLCKfTZUJT1NzmAmEjTLq0h/ykTHf2D12LMIDDiyTRZxGNGa0yLYto8Kk++4JMQyF62H5y+rw8G5R/T4jQJwjON3lv00zbzOBPv1qX07tR5ET27AfUR0LFNXFwi80ockw5sjGekVIHMBY05dElAcz/oCHyiM2L9PN4WJ/OMNWDLObagJEXQnUSQj
 2ZfoDBwW
 X3fx4zrRXJ9iORpKGSezyaX0utrsAVELDkdFQXa4uC7BKJTIb7YkjJZ1Vjjlu5UBCePqVDXsCG/DgQJWLh5cT5Q8+7CPQZz8+R6WgkFvQb6x2BvJZaq7hcfI9MzuNILdVDM0uN68Mi4U9/P5D3R1Jw4+G9ITrNNGCK/oEaRrtvYsy5jnBqAfpIq3bHnL3uZXzM4It+keNMn8YJhOx1e9XHQY0QdM3KPfjFvAbnjn7/5ZoSp73/TUf5eQbGBKFc8JvkBLfH+YrNFt8RQTKf+ZiKuIJNdL5zbYBW0/CyUUwddxVMhwiCFaFTURJZZio1f6TV5PrJyxaWNSjqLzQ62xM+OmN/LhPDsSNxEiNVqIvofBtWi8+N5uwTePXnAED0rAqB25kO8iLDThf+Wvguia0C29y3q/zDLatqJiNMc9VjAYR9B+JcdSZtMLoauKT2EsRpDPJt18jKWU3t3W3gvipERg1eWFBwMsna0b/UY53+/jl0lsCzQIb50pzbUDT2+1xJtymSwu5FFD77wiE+L2A/6Wc5RoU7brXR0b3cTOWRbI4qGTdSS7ws3TEGsLJA/h6lA698n5mcr7LgRslAMYqUczEsRucGVj9BSv4wB5lFA0sOi8zjjLtzPW69Rp+u8ugJJ9LXbolSF+PKrhpBqVloa8urGuzqPpCSHx6Xgxzv0MTE3dNOu9AA+RHUU0d2RZY+BZ/SmszVdN7eQT30ZZhyfgag0e6REkmhlmt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] mm/mglru: single-word handle used in commit Author and
  Signed-off-by trailer
--

commit e3df19968a61ac9c4f39eb92e538d862f157c5ad
Author: lyugaofei <lyugaofei@xiaomi.com>

> mm/mglru: Run aging when pages are rare outside the youngest gen
>
> Run aging when the total number of pages outside the youngest
> generation across both types falls below 1/MAX_NR_GENS of the number
> of pages in the youngest generation. For extreme swappiness values
> such as 1 and 200, also consider the balance of the corresponding
> type.
>
> This improves reclaim efficiency, especially at extreme swappiness
> values, while reducing system time.
>
> To avoid the overhead of aging, we only allow imbalance-based aging
> when the reclaim priority is low enough that we might reclaim the
> youngest generation.
>
> Signed-off-by: lyugaofei <lyugaofei@xiaomi.com>
> Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>

[Severity: High]
The Author header and the first Signed-off-by trailer use the single-word
handle "lyugaofei" instead of a full real human name, which does not meet
the Developer's Certificate of Origin requirements in
Documentation/process/submitting-patches.rst.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111232603.9934=
-1-baohua@kernel.org?part=3D10

