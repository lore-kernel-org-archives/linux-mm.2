Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 630CEC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:11:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52E8C6B0095; Tue, 21 Jul 2026 10:11:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 505EE6B0096; Tue, 21 Jul 2026 10:11:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 445E76B0098; Tue, 21 Jul 2026 10:11:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1AFEB6B0095
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:11:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 870751A018C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:11:39 +0000 (UTC)
X-FDA: 85012971918.24.0976680
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id D4FEF140009
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:11:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=y5dYi+mx;
	spf=pass (imf26.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784643098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rpFqOx+TsMaVwS/8DdMCOrSKpISWlzOMZL2nv+19d8M=;
	b=YPrDVF03ga9baLCnr/24gQozzKTq38xrV0bDe07ovoRDtN+RCb2/RbysEOTXlznycirKB3
	S4uH2G+t+aFpIFaFpFRazVQTEfdFDH2cljq+XeM5/FsYlAjsWAdpRIPx5x7JdRYGb+k5DR
	OjCjbNrWFFyELm/qmMflsuW4gPtN1MA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=y5dYi+mx;
	spf=pass (imf26.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784643098;
	b=mCGAK9Mbox6fBwkBwdhjiYakDooc2DY0wsT8ZXdthQsRPCqeaa2JOzUMQMtAXktzpX9K5q
	BgvhCMN8Z+s71Jv2U6/YMSlXp1li2GRp1Jy0q/I9/1gR7lVtZRwP0xNecYcuqdfGk6pqOH
	NHlfPugyUGowugNyhxi45llfnLKQsv8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 36FB7600D8;
	Tue, 21 Jul 2026 14:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739671F000E9;
	Tue, 21 Jul 2026 14:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784643096;
	bh=rpFqOx+TsMaVwS/8DdMCOrSKpISWlzOMZL2nv+19d8M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=y5dYi+mxTGv0in5N0FFAm5BWI1Yg1//GcmBDVLzKLfm3BDzh105Ightc2rdtZ1ydz
	 JdY/GvONP/ucNnh6OU7HwQqVQltBaru2IZxfF/pOcilqhJ7aJ+2ZnLUxcumOt5j0Qv
	 O0ymlsgR/93f+HDqrg6FAbn6HE04xo4up1/9thx0=
Date: Tue, 21 Jul 2026 16:11:27 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Qi Xi <xiqi2@huawei.com>
Cc: stable@vger.kernel.org, Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Miaohe Lin <linmiaohe@huawei.com>, Sasha Levin <sashal@kernel.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, sunnanyong@huawei.com,
	wangkefeng.wang@huawei.com
Subject: Re: [PATCH 6.6.y] mm/memory-failure: fix missing ->mf_stats count
 when hugetlb folio already poisoned
Message-ID: <2026072119-facial-encircle-f1c8@gregkh>
References: <20260721121956.124887-1-xiqi2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721121956.124887-1-xiqi2@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D4FEF140009
X-Stat-Signature: 6pau69k49ek5ee1gtna16j7zfkk6eq54
X-HE-Tag: 1784643097-762531
X-HE-Meta: U2FsdGVkX1+yZ1g/5FF0mFE8Gw7b3LsvCNNeR7rEV+gyAyZPierXfarmssQPlayva6XgYJ9PX9sIb+HRE+WwViNykZfFoTqKJBbbdD/ewXiJwlv2lX1TDNHfErV/711cbMiQs5/ZpR/g9344L++b5Z8CnTsW5hGtObq+CWdeFS44RSf5mIbpOnMD3/vlYSxJzBbbSqbUkqN0oin+02KIi4/ck/v+ccXo5h5xgyi1ahBwJPsGnnFVDQZ41bvTqUbOT1VTfF1dA81hyw3AmG5k2/DZY7OHZzyZJmUyA9kHHscfuNOoDpaHCc5j83lZsjrQD72snzedCxgbZfnOrgSLGtDI3N1LOe9x/TOtPvi80/zk+0CqFpFJgM2VK2GtiTmq5exzqORl58uq05aisO0+FkMD/KZIyE7Zmun7JH2xYjk5z6z0VDRbtPAwIoQTITdZA9rrTfpYi6fJhmqb971CYgNsX7xIm7HZTMNdExLfSBEF/i3176imlljfjZsd+h73kaT87v6BmcauFZYhtaqqh++AYlG1uyspwe/wHUuDB5vDfZjRin8sund2Z8BbMrusA8U4/qsvr2qAYa+gUICsG22jwhwN0/OZe0JVKty1yLc6ajcG1ZI1FKrBnLT3vfCr55MOnNu4ZSv5N5ADZ1SPM+Ii9HCy+llJ2A7eoyGugUnUDN8XnKt09lY2PNPwQ5XaK8ZKzvkErRePztkIqf6XWNKEgsBYbjh2daKbJNSJDCYeRUhblthC2Q3wObQtw1MwKoSU5WaX0Z2g2Aik61XnsJU5bgZ3igBeBTBDQZnA34sGh9RExVhUtXaYazLSR7UBUljKoNyN7m08wi92RWUb7xgYEjsjgDbqlABKGJmyJ1NfxXjiUlvaLk8CyztF3jqtNmxdYemgNLS8vUksTvYvHA0K9F/KjlayxvJUViQ/rje2M2fJnZbMkr9F/paYTgB1MRXkPEcZbEeY0AL1ZtF
 eX5aHj+w
 u9IxF89qk0ItTweFTXW3XBq+sTLTi09q451ckrhcUHB5dc3ARDXORWQump5is8n6QGxxN+4EwE7ji4wB6IK0dDG7giLPgZLeN9JWIl4jdLiubP/RuC6Fc+7V8z5ChyAEeiIVlkFRnnJ4+4BwEG2384GyrMwjyHdvMlqvQkLmVKJo7Hl1jZbiR1QVtrKxVq4jTeABfROWMLIjbQahiAG8uxc4xA6phOBD/41pkNb8E3acdNfDFNmoC0lhbAWwN4eGX6MrRJVu5FgPUCwIuBqXtpz8n1m8XEjg4YfU+kpdQsKFslyt1FYKmTGrjK2hM+DNuDpYTcjgc9w4MN9vZWwCzteKWXKEIy3EmbpelPwCll+YfKUaPsWN3xooZ4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 08:19:56PM +0800, Qi Xi wrote:
> [ Upstream commit a148a2040191b12b45b82cb29c281cb3036baf90 ]

That is not what this commit is :(


