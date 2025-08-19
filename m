Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E258CA0EE9
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 06:27:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1CC48E0017; Tue, 19 Aug 2025 02:27:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F5328E0006; Tue, 19 Aug 2025 02:27:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90A3E8E0017; Tue, 19 Aug 2025 02:27:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7E7988E0006
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 02:27:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 064251167F2
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:27:23 +0000 (UTC)
X-FDA: 83792525166.11.020C947
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 77015180007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:27:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RkgfDrNm;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755584841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QrgJ3gDgaSoay+QXVPHGnYh/356QkDUpL8vZ6vdd4EU=;
	b=FJN+l28zOM/g0BLGJqR9JpA9BUvQKDPF2Y/lhFz4JieA+0o2xAEoIYxEajlvtYzKlZAKtq
	NlUVpvHw7hEmmCsBJpYs3ZHKNXLQcPJ47HEs7rQYS1iR9iat7Z0LGh47JEsCsEd75fe2wB
	DDXyn1y7IlSdDTZs5M1ayA2W1L/CgPs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755584841; a=rsa-sha256;
	cv=none;
	b=3c0/GrnKzKTQGlfl5mopSRPhJiOy8GkpgbEV10snila0icu5yheePr0rCLjItBxHgQD0nu
	pfS1aR8LRcZDNV6JR7LGpmF+Be8lya2reh/kW/EF08rLU0QzBQPCfZWlmdl6XbAS0qOEx4
	dL84nWw5HTpBCT92mUf86XDGrhl4Ih8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RkgfDrNm;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 839DA613AE;
	Tue, 19 Aug 2025 06:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EEE6C4CEF4;
	Tue, 19 Aug 2025 06:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755584839;
	bh=tGUbKm3vG28QqoO03TcU7moMB1ToJqITXHRyu+HZ6Jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RkgfDrNmCI5m5MQ8CJzeZ08WPXo/5gPhRPxCM+K7lrqDUFlxakHVjU2jRvxoaIlxj
	 ZExmMnzJfog0a4Pkl1WfvE96ZftRxMHFKNLI/cDiyvobWob5qku54Pe9946T5dftxJ
	 r/EBAfF0YP7b3gBrIHYKx0W9/IqukyCV9esHSUKwataXfHqbcESRuYAHxEcIMCZFsT
	 uQhAhavZtZ3DfVtcFM5WmRD/M3uvfk0g6pDxS/+IhNZR75FhI5iDqSYxEdSMfOoajV
	 gczSa97Kdw0UYRebLnLMEP51gh3KVH+Kwqs0pSCYOb1oCwQiTAMhu6wb+0kHtAqqMN
	 dThBD1Mpp6r3w==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Quanmin Yan <yanquanmin1@huawei.com>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [RFC PATCH -next 05/16] mm/damon/paddr: support addr_unit for MIGRATE_{HOT,COLD}
Date: Mon, 18 Aug 2025 23:27:17 -0700
Message-Id: <20250819062717.40168-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250819062116.39593-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 77015180007
X-Stat-Signature: jhtwjmwebcr4tch3neuhafkoyxt6hytb
X-HE-Tag: 1755584841-551600
X-HE-Meta: U2FsdGVkX18t+CLzvYTkknBwlBUvtEYmltZ52s6LV3UtX/pkUSGFpEDyNe8esyOZRg5bF/zE1j2QBlHyRzU6681a4jl8Z3S780KhXTAAaj4FOMmLDYCmVhcNndiM3N7mTl+ZkP05kYrKikpcw5s1ZzFV7OjEiMeUk/bl1CMXQLE5mmIEjp6z7ZDpQc67fWz+PPpKsmBvHMg94dWPLJNZ4ICc7U3OWu6EXqbTgHL+CSwI8QSFxYaZyjejc4ZG01KWY8D8G4ZiiMasq0flc3gaADBHQqcrYnlBuqPC5JO2PMyZ0jyPnQ6b8tgUTLw5YIiCxGjeupoXco6C/EMmZFgnMlEYom6Aj4xcgBXJ4tta/+zdN5qcaJELeyY7Ij28yQ9CwsZTo/9POKyDrxhlsyW7OmRkPKIzwPve6OYnhss2sddTIE5+ZGRayf251ukUDNkg8UtVl/Yjnx4xutKxLRrIG8A+N8rZOTwi3d2JybU31F5hWt5TQGmDo97aCbNU6kh6h7Qi+TDVicY4+XGNMOVhPhXZ/k6IjmsalTFkry5DCU51NdFG/HA2QhFoE5Ffbt0lAg0mh2f248gCj9RYhm64rfdsSA4bxtWkrU0j+0AJe/2kep86QNH5ou47wwz8ingH2LFZ+IuJuisQzKFrKeKs2iX0JwpLoCSqfiKtHIqk5LMxJsHm4PhkLdELafEKfz29dQCTHTCyx9EbLsz+di2noT/bbmyyXBJp0adUSQ9d5Z6uDKjcWKVc/xkk9KUW0Fjm/WAbCAf2RW70dRDnIIL2IgtecIQ1Il4Y5tlmwUPwLSD4h22tpJ4mnwDsZreTji4UAnRurfhL1DRWjoTvtPEu9RVXW3EW5U4cpGEmGiiJ0ZCtHlu+mW9DX4nR9dD/+ldwxcOXNkb69PDAZ+r+BhUK3aGxrz3LGKY8l0bTURPAgO0MnonB8/wsyjA1A3TefnPLtkvvoz8KnfEgQa+v/EO
 Ehq3XaUO
 zZWHY1bINnBCX4U6bXChjNzUIve97Hh0rM28AQaisl3jW8xQaCcfGqKwYCvOC6vfyqB66ff3dIoq+tc3NNaOi+Rwtttc4OcBwc9Sdm4r56NZ1jQUPFEQNBL2xh0lSMPqS7BIZ5pzmpW/dCd7si0AF5ojhwNV6e0BOjJv/1v55vAAyoU7sv8PADHINTI+dWo4C/wOFNu1H1+hJ47d2YQkdcCVDkgFXhRr0e9LBLwBJvuE94/wztIY92dDwTL0aESrybvabF0Z/8WP93AfzZqWAlYfTtxbWbG9tJGfhU1QCFFFQYUo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 Aug 2025 23:21:16 -0700 SeongJae Park <sj@kernel.org> wrote:

> Hi Quanmin,
> 
> On Wed, 13 Aug 2025 13:06:55 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
> 
> > From: SeongJae Park <sj@kernel.org>
> > 
> > Add support of addr_unit for DAMOS_MIGRATE_HOT and DAMOS_MIGRATE_COLD
> > action handling from the DAMOS operation implementation for the physical
> > address space.
> 
> As I suggested on another reply[1], please squash attaching patch to this one
> when you post next version of this series.
> 
> [1] https://lore.kernel.org/0001-mm-damon-paddr-set-DAMOS_PAGEOUT-stat-in-core-addres.patch

Sorry for the above wrong link.  Plese use
https://lore.kernel.org/20250813170806.6251-1-sj@kernel.org instead.


Thanks,
SJ

[...]

