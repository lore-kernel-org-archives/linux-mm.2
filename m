Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8687CD3427
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:26:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D9816B0092; Mon, 11 May 2026 04:26:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B0636B0096; Mon, 11 May 2026 04:26:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ED746B0098; Mon, 11 May 2026 04:26:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C0F36B0092
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:26:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ACF864065C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:26:05 +0000 (UTC)
X-FDA: 84754456290.12.AD337D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id D6B6F1A0002
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:26:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ax0unyIU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778487963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UoWbMaKHcDxh+XzNuNSm9GkUGpdBl+ZFHaoLi4t7TLg=;
	b=NaL7TqP6fG6nl0qHJ7vb+AQQ+AnEB/8jr3lQuTfWrRt70JB2S2vlRoU7K4OjOWIhwlvbTb
	E8Csw0sph698J1Zacb/R7kL5OwyfRmDypIQnmgFrOe9BiEE+jqazs8Mae1lNM23kFpQ3Uo
	zkYpwwNGqdmMG9OFqBVvL2c7U4jn+sY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778487964; a=rsa-sha256;
	cv=none;
	b=qYFfw5amMzWQiE9jq/6Afmb8DhigiH2OUJpchG9QryxqCRMqWCGJmbDxzwJEjvNilzNANh
	yqgMm6CwvIXTJqdScwFJeUuIcJk5832hadJRd6hF3cVNSFMBibHw44i+l9WI2e2eLK+jYx
	2zcO8ogZ8qe3mniDhbU8Qd8vjvnc0tw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ax0unyIU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B3C943FC5;
	Mon, 11 May 2026 08:26:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF52C2BCB0;
	Mon, 11 May 2026 08:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778487962;
	bh=ZDQHQLuS8vxCZNeF0Ws0yf2AAH+PPN2lndIWRaleKbs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ax0unyIUwrRzYEOomZasRiJU217mNdPoVVP6q2CixVpusu8IPhKniQZT2CEAT/z+M
	 SWAy+Umhg0c1hWX3gJMlz9454TLUzRX0WiwB8HILKVnZ8EsmBuLf+ViQ7DqniWvBga
	 65X+KXKS16KECvfckRJ00w3cDpj96sfOEXO4fm63pGnZZi6WdK44Jwz+Ib5et5PxwA
	 b00scRHQkOKDxPJ8NEKoWXN15+guBJHOxHkD04qgmk6LYZUgRzWcCRUCevdUG0Yc2Q
	 trw9OIXC3R8sC0Tzp/viOilsoWGB5CjWgr1zseYTuzll14N4EieIaEodivYsjZ7mYS
	 clipQTrv++wRQ==
Date: Mon, 11 May 2026 11:25:51 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
	Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 42/54] selftests/mm: hugetlb-soft-online: add setup of
 HugeTLB pages
Message-ID: <agGSj9-IJXVNJOI6@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-43-rppt@kernel.org>
 <55538154-c46a-4504-a976-ce66e2555534@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55538154-c46a-4504-a976-ce66e2555534@arm.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D6B6F1A0002
X-Stat-Signature: sax1kph84jdzp578padey4jsxwsneqig
X-Rspam-User: 
X-HE-Tag: 1778487963-149922
X-HE-Meta: U2FsdGVkX1+Uy+/FqpIX6+nh9G4ggJ0zDBG0B9JYYMiIE20K/rmEqNkkpRenQZ5NNlxXnRMThVcDCBQJVp/+hI0ajQJ2niBX741fn7nfT5Fe3jzB5lu517ar575gilfbt2e/fMNxDa/P7W2PnbNIemlG1L0Etx/eSffPEEdhREsz+MVz2RnKO+insa5HUvwAli1lxMoqoFyqMZDdZWULhYiZNBDuGaY5QnkBCCiY5by84pc2KkdCJoYCcHYk8i5mJWgRsBJ03dOhvn+6NEFYTKrIxz0jKvTgNLj1y+z/J2bu4Zn9Z08VOKpo6qohne/jnTmn5ILmkFTr2OAZxnqC7r+szoUACjMJsTShQSO+HXh07k+bAJx5Loj6O18YIl1XgtNtyjxRPvxKSVOdcHd6xxq2ow/5wkR46jteMxCDQb81rushjt49q175lMn5f1nWDPz8ZzSKGpn3GSwc2uJLZXNq5xzoPXwgzFi6BdLeLOIQZQJ8mgUi6A+bk43ar5h/1jcbexLKqHfxGts2iRAJASi3oDPVix2MaWjR470dNIk3gJcoRlGfJ3xqVGY1lSMe+wm2TYqrr2kEZz7/TcaAWhJjwlm4j4B9Wckb8lmdQRzOwe/Lfg0BLmmKt/shJ24OR6AEkaY9dt19fZJ7jcOC/2nrt8my5LoqyRio54Rpe8MqBpPUIVdBa37CZ3Nq0w/iB+O+qecfFwUiTu9dzR0gtNfWb8p0EnUBqS5GwZfAiRs/mQu18pyl4vKLY/xXpQ6Knh1zMnpouQNDfH/k/rTd01Jnj+bfNdUkBHrpH2+/jwi68gBPLjY6mRkcyjEtt+ngTxCdjr68L8wwZ8MQ7iLC5HDqzE07DHcuSpjZZ3DNSJ8D8MOeJx+a5ruq3hCMFUbXyVsuayZZrC7LKpp+NdPGIu4dphPjqQBjPqgNPLukkFB/2djhBbCdroThH0eykL66RmjHOo0FQ+cQEpvZfBz
 wTHtAc/y
 mLnIsSEf93TmMlPEWeKFSINJsx6ffGKBojLACcqt9boTuHNSK41kExiE7JXJElxb/j8hhNsCfszjfBF3UgpfS8BBZFNW+IE7SiM8IUXVmS02b+OFG5zGoGSDz8vZj7uKDyTiD2/vs2mSjUYXAO6wWyMhge64dvP7s4L3OW3xXJY1ad5RuWA7K/gTqJNisWylysi42KaZrNz8hakpikunXFFdm+24R9XhH0bsIiAR/sZ8f63Y1WND47uz9f4eFus6kQqTb3DNb1rKIcnqZBWW+6J9B46jp6SOnVX7oG8HB3eYaVcOC485d5pdpnvYyU5Cha8KwWvcumCRYJd8eB+iLmMyrIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sarthak,

On Tue, May 05, 2026 at 12:45:52PM +0530, Sarthak Sharma wrote:
> Hi Mike!
> 
> On 4/29/26 2:12 AM, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > hugetlb-soft-online test uses open coded access to /proc to determine
> > availability of huge pages and fails if there are no enough free huget
> > pages..
> > 
> > Replace open coded access to /proc with hugepage helpers and add setup
> > of HugeTLB pages to the test and make sure that the original settings
> > are restored on the test exit.
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> The test is hugetlb-soft-offline, so let's change the commit title and
> commit message to say "offine" instead of "online".

Good catch :)
 
> I have run the test before and after applying the patch. Before the
> patch, it failed with an mmap error when hugepages were not
> preallocated. After applying the patch, the test correctly allocates the
> required hugepages and the test passes.
> 
> Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

-- 
Sincerely yours,
Mike.

