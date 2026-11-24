Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61B74606A68E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 10:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dPWKFZ5L
Received: by kanga.kvack.org (Postfix)
	id F31966B066D; Tue, 24 Nov 2026 05:15:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBB5A6B066F; Tue, 24 Nov 2026 05:15:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D82BC6B0670; Tue, 24 Nov 2026 05:15:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AFD846B066D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 05:15:21 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 12CC1C0A0A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:15:20 +0000 (UTC)
X-FDA: 85469605200.17.C20296A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 671DD14000B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:15:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dPWKFZ5L;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795515318;
	b=c/BqgqAhkTCXSUQY6vH3tRcy+pFo7z641Uv4HkZtO54naG4LQW2IYGE3tHgN2IWa/nDMgF
	RBOPh3yj0DiHRV6Jv/EjshnQSeeqaJ1XoaAhkIQQcD+WL6nnl0GHGJIh1shMDxkcDvBYrF
	omdfzCNslRzfZU37xM5b1xx1IHW0AAs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795515318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hHECIuUR9HcEzeZJ8C7pKu2f5dLD2DBLgztjbd6Qj3I=;
	b=uxVnzLUpjnNAWOcwfHtp5T/70XZjQ3CO+h/0j+vuEslAFYpI+6QtS31IKi2pPs4CO4PYZx
	SMx8HB7hz9DDSbPkktMCo8UBD9ldw2G8deZY8iIq+fTyAzTqGxgS9fWiPvUSwMp6G2Gdux
	AysjkX/Xr7jtrSgU/3qdTfNuA/3E72M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dPWKFZ5L;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 885F943984;
	Tue, 24 Nov 2026 10:15:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E031F000C0;
	Tue, 24 Nov 2026 10:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795515317;
	bh=hHECIuUR9HcEzeZJ8C7pKu2f5dLD2DBLgztjbd6Qj3I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dPWKFZ5LG9YCMDzt2kiKA/v9gin8Z5x5M8m2NT7aGz3CCfIJbdV04+DqSdm8fUw/y
	 HcfWdjV/MgD4Q+SHwFPx6zJVZQvjtnQ44m9MwLz8lV8p5m2D43+hdZwctL1wLtvWuz
	 yODDoYeYLT6gtj4nJIDi6u7UIh1VTYeU0hn88qSrp126h1r9fY0p8eBz61Hj6TaKu9
	 i2SuPF0ywEaGPdevN74Hb2UVMyQLGn4R0MwB4yjw8L/t7p09RHj3wuhsEvDAvaP+MA
	 shL/P5t2LSFLsKwtd4zWfCarVE5KK448QJf/Vzn/+6WbPNQ1cwJX4LJqYk5tPHWz5v
	 aWTdOo//a6l6w==
Date: Tue, 24 Nov 2026 12:15:04 +0200
From: Mike Rapoport <rppt@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Alex Williamson <alex.williamson@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Chris Down <chris@chrisdown.name>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v11 00/13] PCI: liveupdate: PCI core support for Live
 Update
Message-ID: <awVjqLFrXY_PCm7X@kernel.org>
References: <20261118223704.3286085-1-dmatlack@google.com>
 <DN0FL1752MH5.1FSZE620OJBM0@google.com>
 <awKlfqlQYhphXCvf@kernel.org>
 <DN2TQRX57C04.ZT5UUS6AQ1L6@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DN2TQRX57C04.ZT5UUS6AQ1L6@google.com>
X-Stat-Signature: t7iiuzdqu7n9iwe7mk4oan8bwfhkdjta
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 671DD14000B
X-HE-Tag: 1795515318-426585
X-HE-Meta: U2FsdGVkX1/M9KwvsAz/hC8pZ/nNQdqV7jCpadw19jrnL/ZOEiS5N//jvudPuC8UZ/2nECHY8LCsVdNaFQVx/skhFdgSfF2HC3bRr+XbhjK5EigY+nHuWCLrsPJw7PRxerS5VZjxqePCToKMlwGIVmCrguVMS2d30ajShxODeYPCUx4BSm2BzTLgWVFu3u9AOpR6TKUPT8kqXPgWULOPCuMnorlT8DJ5X06qvfzdZJooiOjYmSdG6mDJcG2mQNurgzCbuxXitjVxKwRvVaedt7lX9gEya7N7WtPARnFOE9n7B0/EREWwactcdLrQ8obRVMplqSDmtUncR6xZqMALRjBNggFBC9JB+6obpCwjlKurt+DHOkZ7/XOurjL5L0q0B7Ojj82ClTwtKhvklfXdHsiyDd4dUJtebT1h1Dw0iuSmHDlE02ruVlvigbNuxNoPzBDuu8wX7lS5XCtlEQG6TfkxlxsCDRslPH2C4lvBn7KsrMJj10MtSrjnDhyDE8ysGP0LArN1cUIcKL+SYShnwwVd/PFu8o8l4tvHLVYrHoos+nKZYyqJB9YEnD+lwDFQtvpQgFiXmGUp7YqalLw+PH7mc8IZ9FSXcs11LbcPANn3BKgrZgRxF+mOIaNq9ZO92J5vuU1nZtP2C/SkTGW7xCbSDauCKCH/HtU3sVtRFAuUSxLE85GAXnY0l6RwWhhsA80dMACWSxgzEZ4knejlynyAGHFs1Zp2wuHybgcX3kecfdqroAWyEeVVMpeFO+JnSsMMZ1PQdRVHbL+DBE6vSaHSt13Fun+gbQTV1Q9Vkr9DGT/EkKbGKlpyWKAkXzC8LNN629ElhD0jG9/8oFvJG/BMqaxhl4eC8SjKls+2xwqd7QLvhhgfMcdNS90rEpiZKkGN0Zy0L+yLhq5TzeW9KW8fZ1C5/Dc3GvPpQv/8EofGxX/VaCSfAo8USKfM+MywiXPuPg2dhOX7McNonA8
 TNFYTpbR
 4bFGsexjROLFTS1io2Hmy+24RlFHOA25tYHZl7pXd/b8yYdgrlIqA/4KdhkXV+02PQo7k0wEme0K7wdUzE7yalP3wGz6IZz0AVs+EFbv8myZWKbE1vZ8+dY/xyoRyr7BTPvdEK9Kt/HmD4QuqqrnmVISF2UcLyfKLENVX5TjRZfr5bLYO8EHgt1B3Btij9ztuZfUXNB+Q0I0vCdpsFDXRqwBhVUuBfNFAblLMHmd8zaTv5gvD7p/TC0sGxeYGdj8FAxf6lZvuqsgfiFERSqwyAosMic9BRgL8iLWeQiWpWsqtdwnRhbhBo/921eLlrjRAvMu6U09g0tVCfSRUgcOPmAIEV35DhkmzkNA3waswRxpu05jBxpwGBfhLB5Q45pMfDxDtKX9BmErgITSLHWdCLW+Jl3aM4pLRP4OOBxr2aRpGjvjbFe4lq38Ga6Jn4kHPaeZHQRKOjbQHySaMymLujj2WUEz/bR5A+DSgp2xVKlOgC4ST5aRtxzu7YvVedCmx71h4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 11:07:04AM -0800, David Matlack wrote:
> On Sun Nov 22, 2026 at 12:19 AM PST, Mike Rapoport wrote:
> 
> Hopefully I did this all correctly... This is my first time sending
> in-reply-to fixup! patches.

This is my first time merging !fixup patches and it seems b4 managed it
well :)

Please check I didn't miss anything:

https://git.kernel.org/liveupdate/linux/l/lu-pci-preservation

-- 
Sincerely yours,
Mike.

