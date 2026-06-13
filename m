Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DE8ECD98CF
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 00:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EAEB6B008C; Fri, 12 Jun 2026 20:25:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09B676B0092; Fri, 12 Jun 2026 20:25:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF1FB6B0093; Fri, 12 Jun 2026 20:25:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DE73D6B008C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 20:25:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A5667C164E
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 00:25:00 +0000 (UTC)
X-FDA: 84872994360.21.079BF52
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 12A0AA000E
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 00:24:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aeecCDUw;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781310299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g36ifAWvVcoRnQwNzxH3gcX2JTQx7FVxpm6Ec+LHXJg=;
	b=SLjSYix6TtC8OQo5k49mXG/of2fm1YYApYvW64phjelUwP15CDLMXESzBb69hPSbRDT5YX
	FvOpyOWx685qCEG56dWpn66FmMBgfbflOSDmvOnG17sTYlFkCQeTHl1LYs220J1e6aRYZ9
	bTdK1pL+7chp+qj8UfEU/dqBHQfzjIE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aeecCDUw;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781310299;
	b=nlykXCY4Kd/1uAEb8QJQhEUxuhaQS9KQToEwjFcZCodB+HA2JEU8gsgENy4IMDj0BUdVhE
	fp6LkLDwfMBqnimXW/pJ+T9I26Z8sJxmCsGleRGXaH2WlCh5a/epP9XTke3VRe4eEFygsE
	RC0P7lzv6ZXHDyKk/ULmVYkmI/+D6II=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 36E7D416C2;
	Sat, 13 Jun 2026 00:24:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7363B1F000E9;
	Sat, 13 Jun 2026 00:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781310298;
	bh=g36ifAWvVcoRnQwNzxH3gcX2JTQx7FVxpm6Ec+LHXJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aeecCDUwbfQNwMk80FtAtPzPFcAtB0+3uiU5Za1ZcJMlYSfN6Ql18ZnEbxeHl0Jzc
	 GBXtn+pMLW5zfZ/+meJrXwbavUAToCVEnQgWOr2SQjhQ4iE1tfypjGzs98CP3e4Xep
	 hQes68b/sxqY4ObPQyVvopDtEpcMPItdP9jOQPeIIW9kUFdlBTMfFKvbg1AbSmxGR9
	 E2hnpC01iTZbd4oLW5RQQR1/SpvcSoey1rIXDneu9ftmv4asWXcdxwPrWMgsO8tRde
	 lbcg1jHFi+qvhWTKps167RT7hMc2DFHPdTBV2ZieRA1+bl+q/avnqEI3C+pjNGC32b
	 Nmv9KhCSDaVag==
From: SeongJae Park <sj@kernel.org>
To: Huang Shijie <huangsj@hygon.cn>
Cc: SeongJae Park <sj@kernel.org>,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	zhongyuan@hygon.cn,
	fangbaoshun@hygon.cn,
	yingzhiwei@hygon.cn,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH] mm: use mapping_mapped to simplify the code
Date: Fri, 12 Jun 2026 17:24:55 -0700
Message-ID: <20260613002455.1327-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260612073032.33228-1-huangsj@hygon.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 12A0AA000E
X-Stat-Signature: wt6rwukncpid94h5ygujx3h6b3bzge3f
X-Rspam-User: 
X-HE-Tag: 1781310298-653721
X-HE-Meta: U2FsdGVkX19DlNJJxRG3/HRNrOaNz0IpbqZ0CXllOOnmJD9mmT+21H8rDm6CVDgLw/q6a+jD66pTS1oo9LF1ccVMSuumGmTqxsgVdLC3s8a5Oc9iLutnS9U6gUCeuvrU3kZZY6aWYGjGEhtWWeKpnN8D87Skm5DgcBSK+bmvfycV/V/SzRh3DcTIx50+XOHb4s3XVqUi9faUu7JoE/j2+ZflrrL9yS+TBIWTHTd2qaIZbWfMIZq8gq8am8lkv0NfkuqeRc66T2AVudrqTOgQkr8RMcglOvZ7rv+bYlygFyJBNxDCEi4GIU0TE/n4jM0gsvGnfTdBG4dtkFnbnF914VcJqe6sMxAiHelwaK6fdPlt39EH39smdin6iMr4e9p4KoPEoHsmz2ISUEnhfDKqYUM4StQE+CLawjC+SB7iJdJwZm39tK2ZQ9POkYl8n3fOX3/GkU7fOrThktN/SaohjTpgVnRSZ7tDzAskiWzVgch5jc+OEJ/L/J7yOpcTQQUDmQQVStCEn0QacfqZjcSBJb8rBJJHyTSwrVlNZpVXziDyVi18jxPa1tUQehgdWJ5APekQkGMMHtpG9ekhxr+VKLv05jfbzmxvmQ1Gs4iFAO4oBOwwsQyOfLFfPq9kHJYXpQTPpzEVR2O9/j2x2SA+GP/y0zAkONPYcYpTkeC75lqszbpqxm7hRixaDPEAAUsF4x0SJWvysvRoSooAzkw0Cd4RAlkjgWLD6OTBnlS9UxhaT6Ag24jd+jI1tU/bl2lE/mAv59BhgQUHzTHyr3tUxq56VDOz2YktPNBoyGpdQ/A3brXbxjtye8TDuF3olFDsvn5OWZsh1WYzGz4IjUH8kJcXL877UqAGB0cZ3/kcoEiiWQWvV6yZpJh8H9IInPiHE4kRD+pIZOpq3X97S/lxg4A8ccIleS4zwoOyw4fXwhQ3B7z/mFxTQDxJaqu93sy7h7VWAKPkZSGqCEzpaEu
 T7V9n6y2
 iKLOZrmHA+SOG8tDKQx4DyUVkAMcT+lOCmhP5Ug6N8GLe30+juzvDATzPuYbeDGx1ok6IiWI2itOhlHqbqbVHjfdb6noxfTvB9SO/efpvZHmm3dVGVpZIiU3QuQzvi8dtfnVLWnzRsfq3xFqa/2lXiUeysFGyplvFh5seTLXHqgKAeiOOcFGU9a4G111A2hPw1gfz9Gw59w6xxUFYkv+kGRzFFjWAKuTEfjGxcpGNYQEnJPoYOhN9kZxFK/RlYNJb4Sby16VJeWJ+7AOu9lIGzxD4m8kGG4fQx5Lo4XKpEAX7VwXlQl76r5WHZmfC5D2oVw2f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Jun 2026 15:30:32 +0800 Huang Shijie <huangsj@hygon.cn> wrote:

> Use mapping_mapped() to simplify the code, make
> the code tidy and clean.

Indeed the changed code looks much better, thank you!

> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> Signed-off-by: Huang Shijie <huangsj@hygon.cn>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

