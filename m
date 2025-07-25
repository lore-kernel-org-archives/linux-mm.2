Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A3E7C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 16:46:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A6706B009B; Fri, 25 Jul 2025 12:46:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27DED6B009C; Fri, 25 Jul 2025 12:46:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 194066B009E; Fri, 25 Jul 2025 12:46:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E5856B009B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 12:46:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C2A681139EC
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:46:34 +0000 (UTC)
X-FDA: 83703365508.13.41D8D2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id E21E040014
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:46:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gfDBlPAS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753461993; a=rsa-sha256;
	cv=none;
	b=hSd/tCD4I75OlRFS5CPMDQ71F7WLN8u39T57WZVeQohYB8PzPa8QJ2zTzLLDtdPhEwWJ+e
	SC6tbiybaQHsTL1Co5Vw2e7o2I8C/HakL6X5LD+VcSWUl46asiIfcsmTFDxK4Rr4pBISmT
	DzsZl01Y739RPTyDqgUcYHPgw/KO+8w=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gfDBlPAS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753461993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QfpCHcwHlHinm9ZtR/fViVngG0sNf7Ts+uB3ZCh5Xx8=;
	b=srhdwfv8tBhQdi7uNdDWhQgl/S1HZE3yQzTx3ukY710c/ydi0PFopg0TG3oNZgd4Y7FzCj
	QMFfTz957z19uzKJX0iF92vYXVLXCujhYnwF96qFH9sX73k4HQkFVJmWh28OrcIlnRAafE
	pUWbEZbJ7ogbniPcFkFrtq7pLHrqjbc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3BB4B43681;
	Fri, 25 Jul 2025 16:46:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864CAC4CEE7;
	Fri, 25 Jul 2025 16:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753461991;
	bh=QfpCHcwHlHinm9ZtR/fViVngG0sNf7Ts+uB3ZCh5Xx8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gfDBlPASXlIlyZFsABQdJ0MBZXFqFDpZ4v19uM76so5Lf3LnGvL62sFFPOXsJY1Di
	 77ENC5Y+xHf5+f7+h8pgVKM6hYCtOZNneQpJxNf742fty/OmoXMQ4n71XzKwYyDgI3
	 nrsr7Y0XSIKTOo0eBgmRAJjXWKXn5kEVs2tT1WdnMMnJn536HH8ZKXamygOC3GNXe9
	 bXdOJa3s1/K4acl8rXY57hKN4gydNVBhB2tvtjHX74R/NqoQVO1ZfHmx6PNI5P3Es8
	 Feb8oKNp76Zg7CeDnIdRFiLard1U8oTXtFyavDVraSrknpwPg1bGlDS/XXEiohzwWS
	 tPTItG4nJZMvw==
Date: Fri, 25 Jul 2025 17:46:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Deepak Gupta <debug@rivosinc.com>, Will Deacon <will@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Monk Chiang <monk.chiang@sifive.com>,
	Kito Cheng <kito.cheng@sifive.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
	llvm@lists.linux.dev, rick.p.edgecombe@intel.com,
	cleger@rivosinc.com, apatel@ventanamicro.com,
	ajones@ventanamicro.com, conor.dooley@microchip.com,
	charlie@rivosinc.com, samuel.holland@sifive.com, bjorn@rivosinc.com,
	fweimer@redhat.com, jeffreyalaw@gmail.com,
	heinrich.schuchardt@canonical.com, andrew@sifive.com,
	ved@rivosinc.com
Subject: Re: [PATCH 10/11] scs: generic scs code updated to leverage hw
 assisted shadow stack
Message-ID: <aIO05OZyhjZ5JADT@finisterre.sirena.org.uk>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
 <20250724-riscv_kcfi-v1-10-04b8fa44c98c@rivosinc.com>
 <20250725161327.GC1724026@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ptTNb7F4keuuu5CT"
Content-Disposition: inline
In-Reply-To: <20250725161327.GC1724026@google.com>
X-Cookie: Do not cut switchbacks.
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E21E040014
X-Stat-Signature: xe3b3zk4ff3bcmwc1m8nf6nkudmw8oqz
X-Rspam-User: 
X-HE-Tag: 1753461992-9206
X-HE-Meta: U2FsdGVkX1/RrEEs7QdaNS5sU6WeMqpevyYu3/zPnrOpeglUf8yOV+sQj2jQuGrH3MyKPCjzHezkGpHCgkLyjpqUIo4vheIcp1GFBu+Cr335FUwyYUYagKnoUzi8W4HcYNoEAwbazMYCkb1fVY45ooUpylSd1PGcLiOvZ3NT+orxJ7EiHs484L0Hb+iZ6ol/dj2ETTQt+iWeSAxLmBOLoGiCXs6h9XTTXoMy6BZbf+P7i/8hRkgPgH+ehkkMidrkgKlgMnfqksOKJbXRcZd7jyT7+hbq5UTAWkOhLewdmCJI2uLGWavLiBkZ9CvehFqNXGCTNyENUnJuZJ+g8bWw3YEogIz8+omGv80yeWRFbOByzPPmcU6EOxCrvqkD2RNxDfJHhiptZFrWJ5zEFv9mP1g4zl/GTmZ+yUntprCm44tPHJeP+cUeU457eHLCnoJ/vGPzoEl4OM6+f9p/NmAtiPzq9XTvItMJSI5XkIu+Cf6IzNmSb/5W1SumdZyZ2YxF+wtzkqjPBTW2gv9/wAq44aa8xYrdiYU31/S/tMFQH38zWHys02/CgiYU7pOFGSd8xVlUNhy9JydMx+X+U5qS65AqW8rDA+tK/caTlBOgNteiLiEWOfyZcfQ30uEwdLqmK360pni5kzWBDYIA0KVMWHdSc8nllt/qKP794osKWEPcDwb+oOcTYT7WsXZtXOvXnlx3XwUTvw8bv+u9XLaNNsUEiTIfkaUHMAQbKXWKRPYhhW5jAeoIX5X9cq+Fh/v3r4ccj9c/CaZZwNqqsTKSi9yn2CNZ3WOJZAHvFXh0bLnPildD2eHd6TcShyv7A7VkxR5PPGmrAFsaaMVyvPOs9mYnzKLvvJKSEjk5JZoWGoiQZlkER40hGWK/r1A++Sny2adRNb9v5xYyHsxJ5zE+9344F8O03EhGKcuGww8CkcKokUxdwSGTYEDjrenMZkBc8ns5/5xwa0kyJwugYZL
 HcrI5Ccb
 +lhekFbGVFpSSRLBW/hjxBmfMOCbXOgKmNsqFOYQX6CCso7p6kD4EFikInDAyB9RCjbaHydl90SRjvID/bLjB/MGkVJyRoNf/A71/KNDbSRK7aHHxV5Qc9cJaSXYm5+sPVPZ/VyURFrFI8FX32yY4JJBUEWls9WJJJETXHjG77PYrhnLFuEQ78DNSlGabDdsSF5nGjlQfb5+iagr2Oh0ciz3V7q7N0WGmA7u39XVZgXHL/4kEOOtzT6XdZVlpWsySemBoECxvPUO+ycruqKSGxcJzsvwBeZLSXI0vYNdPIXfCrlewxHY/g/MOX0MkykO7E4pwvRh0k8qVwwXfOEzPwali6cRNfDpgYQQFc9Yileqoitcbp2p2y92D4NU6Puy4+MDLWwtBc4uRfR4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--ptTNb7F4keuuu5CT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 25, 2025 at 04:13:27PM +0000, Sami Tolvanen wrote:
> On Thu, Jul 24, 2025 at 04:37:03PM -0700, Deepak Gupta wrote:

> > If shadow stack have memory protections from underlying cpu, use those
> > protections. arches can define PAGE_KERNEL_SHADOWSTACK to vmalloc such shadow
> > stack pages. Hw assisted shadow stack pages grow downwards like regular
> > stack. Clang based software shadow call stack grows low to high address.

> Is this the case for all the current hardware shadow stack
> implementations? If not, we might want a separate config for the
> shadow stack direction instead.

It's true for arm64.

--ptTNb7F4keuuu5CT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmiDtOMACgkQJNaLcl1U
h9ArZwf/YMJkuoQ2j9bLF9ONvIrnXY0fItNlrfggfCoxTcY9cRIgb8l8qOxc6uA/
S2sVyA97Le95wnFpBayjCXiFb7F5ooRUS+41Wo4PvG/kTTJsKWqydoQpAZyzQNV+
V1a4cITUFqNi6mYcrEcWzd9RndDfhxXSOaaNgIq2uGgGVMZVXM4LiDqzaP+IS8+y
apL1au6vq87T3R5llhBOzHXr3ot14xeeNfPE9ls3fjM3e0PqhEEXhiljoCKV8szV
18kXUuSAEs1Xpf/WR2dbQj2aWzdPWSm26CT3mIULr+cO93Yczz0oIJqwE8MrykTI
8XzoTTcoH0r8nWPzdxA34nliH8cp6A==
=wvEv
-----END PGP SIGNATURE-----

--ptTNb7F4keuuu5CT--

