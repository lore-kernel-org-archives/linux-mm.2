Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9C23FD375E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 13:42:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 247A06B0005; Wed, 25 Feb 2026 08:42:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21B006B008A; Wed, 25 Feb 2026 08:42:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 134FB6B008C; Wed, 25 Feb 2026 08:42:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F3A6D6B0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:42:08 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 93A24140604
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:42:08 +0000 (UTC)
X-FDA: 84483092736.19.A268534
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id CDA2A80009
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:42:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m2vjG47l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772026926; a=rsa-sha256;
	cv=none;
	b=Ruw9WZS86fEYmWwhg1mAUihOzpvlmNlh5bYluXlXVExpTHQSi8C/SR6moJLIOx0YQkHxYl
	edZRchWJLkkT9x3WcGaveWoU+Y3oeN8X2adE/xgROOLHLJAKD7nc6u2/ywKPZidbNusN3Z
	phfDubrpDg9gro/SmQtgc5Vnbgkph1s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m2vjG47l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772026926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cB8pFgzoXiS8oHU6id6SFbNWmqF1i7v9+5UxlpFB7KM=;
	b=YGxEf70iAfShUzWkSzJFW2gDjO+M16GP0mLI55eQzqwVwvpJ1KZ7aDDXIRRgZzKp12NInv
	nSIX8/DWuXtm98YRmvuurQPZBEZ8NmA8/ltGwHOZGrecs2VXiM2ZJSsWffEVycq78mxjcX
	2MEd6kUBdheCENio29jHKBu+IkqcfLA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 270E160054;
	Wed, 25 Feb 2026 13:42:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DEBC116D0;
	Wed, 25 Feb 2026 13:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772026925;
	bh=cB8pFgzoXiS8oHU6id6SFbNWmqF1i7v9+5UxlpFB7KM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m2vjG47lCL8wvzKx95YvT22pf5xmSCGALtEu0Zif9X/qVgX6FyXAVrx2xQaQR8K5K
	 A/CQ9yxXWDjweFRbYO058O8r/Ptf8KJHE+qF0zCdeKX3/H6jCSGjYZ0BTGYQVgb+33
	 JIsp614OS+iz5RwBgGjQ4oHHS8s16Qdzex+kP9BzNksPTzxtIDg3oV6FDzszjVYU4B
	 n+HmJzjFDYo6WnDFnJaO55+ZLeppHFSOVfVXqSsU2VZxYmdQEwg9uZfYyBqmfrQDFt
	 IKUV0Le0vbDepWBg3Ifc1e6twBOiBKmgUcxV4P9p3mMJjzUq7FWIB0x8QOdioC/tvN
	 7YhiVtDgOzRMg==
Date: Wed, 25 Feb 2026 13:41:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Deepak Gupta <debug@rivosinc.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Will Deacon <will@kernel.org>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/5] arm64: gcs: Use the new common
 vm_mmap_shadow_stack() helper
Message-ID: <39ea6eb6-6ccf-44a3-bfe3-289371f1bacd@sirena.org.uk>
References: <20260224175800.2500729-1-catalin.marinas@arm.com>
 <20260224175800.2500729-3-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="V2JcFvgVMXS0vhD6"
Content-Disposition: inline
In-Reply-To: <20260224175800.2500729-3-catalin.marinas@arm.com>
X-Cookie: From concentrate.
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CDA2A80009
X-Stat-Signature: fy5gnpseqqyq93zhrwwhjqqiqme3bhky
X-HE-Tag: 1772026926-660747
X-HE-Meta: U2FsdGVkX1805J+o5gOZRUr1YRS58qZZN33XADPwAHixmzX+Jt89DNPWWp/ZnVNC+5GIVqPjApvkTtJHNhPblAaojSVVx8E9VreOBZgNINr6W/rOH1TVdkULnc4N0mqenplvjesN/Q3cidry2PxfVCfrDsPpINf0uaq3MfT/39TV8ddx2JpQrwHYtzhlCxH/lk5Jzln6ZNa3G1qsyCY4VgiGMUpLSfT45BG+QucOQo8luZAGGImze9Go5wmoP4E5a9LYJRfIV+LY/KBofI/gVKKbde1Yh/3B/7NZjuEnAIEiNaijjsvQKdvc8k8Oo0//2R3JdvA4gW16sDexH+FmCYnbqXSNQCSHVj7Zy13yrs8kmANcImR5JFei6zpV+6HgooZHyG3aKPQzTdEOY6lvE0gSqybS28hoWPv++CueFHI60OyrCYtt+TOnx3fbpYC+TgwNPXSbuAwwQOZrqj7cuSw4blLISKUbvfE3pyU/MCR8Bvg9ESzyLyrFRECDDP/Ruulf7AQe/e+8Bk7K7sp+jMzyJDSg75Y3BpO1ocA3HTRWu9vTNFzcgisSZhIZrx9P6t2MQzUXj2iAbqZiEvBbIfqMn7Pl6/QBkRy1/G1mBrhj7eLDI1JAGjFpG67HxdhHdNlwO7rdqPDYp5W2i5rXuLInmZtgkhKN8nD4W5N4Y5YWdK+btqkR+o3ugt40m+m+Q6ird9/VLogfyiAmhBKmDS9TM1XaE9ZMYaxmCPRI/rpjSUO67+7RbdJ5+PDiAUTJq40T/xFgxr/kw6BTGXNtIV2jMwFuQ03e6Qt5wJYRGPLO4x0vpPHJYR2TUp8+5cruTkgnrIZ54H3u35jsv3JrJQPaNPnxLDpP3DV5CNrdtwSgchOFjqnc0OkJ4Wmd3hM6wkDY3OcIn7pDVUVbD3w5vLMLKGxr11EtiEkGzWg2nqdIqkxRZLnMihgeml0YyQUvfWafQYcS4Ln4VT6wdrI
 8OExCPGb
 lYRnBJJtgxdAWZnjlREFHn4gU7fituBeM0nYMQRRrOVr6exPFd1V5wtGpF6Ana4Yb7ndHYQfpkUvz4N27ywCkovl8l8LD5LZrujo01yf7wXLbZCCp8BxNLNZ48ZO3v60gAdkBOXVPGVhGbsdjJFiK33xgculiPN8GlEzOQwXcShXBQDFeluUa5mes4kKv5ySx/ZdTJmm+awcbSEgpmweVbi6xTtbpqlEIIMtpnQNFr5Jl1mN+UuCqoh9bET6ReiMEhcBqE+fSOgGgLqvbT9SMk5W0R1wDE4wcl6d+h5pbGvchdcs2QWTugkDWBT5H5FfWG28ng0FeR5rpVY1f8O+EzFKXYN2O1JGebldHy6DYFdzDSKX5j32COGQXsajQNZKb9w8mVlRbmgWv8sqvwLGsL3LCT7zxELTczzVF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--V2JcFvgVMXS0vhD6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 24, 2026 at 05:57:54PM +0000, Catalin Marinas wrote:
> Replace the arm64 map_shadow_stack() content with a call to
> vm_mmap_shadow_stack().

Reviewed-by: Mark Brown <broonie@kernel.org>

--V2JcFvgVMXS0vhD6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmme/CYACgkQJNaLcl1U
h9DznQf/bf+eQi22k33fcYOVgTazsrmX2lO+xFNLhmSVp7+6+7mI8vDusST8+kKg
oByJcksziAC4ggsK78oNaSNgD4q0Q0mEkM6EN+JjpbBCdXQAoRHVmmQefxFszg/f
uP5gvKhwwaOLReOUEVwVzvGBADiPzyaBlWzVbhcHdD9eCUqozvAB6REovppOl9Mi
mxRQzSWRRqe84jLyKr2vuFo0IHN5obNOm1E7RDtd65A8kcnCvh4Ke6hry6GGQti3
nwklIHw2icucpQJKqxPMYRNKYQtkZ97b/OagyacEUuI9Os2UkT2u5PFrZ+sHHRFQ
dqNv96YfhwS7LmOLP9GsBkoJAPssIQ==
=EH9v
-----END PGP SIGNATURE-----

--V2JcFvgVMXS0vhD6--

