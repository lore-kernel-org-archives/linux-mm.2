Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C4F7E7E375
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 11:57:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B8526B0005; Fri,  3 Apr 2026 07:57:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 568C26B0089; Fri,  3 Apr 2026 07:57:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 457386B008A; Fri,  3 Apr 2026 07:57:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 34CA06B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 07:57:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B666F13A8F6
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 11:57:03 +0000 (UTC)
X-FDA: 84617093526.19.AA61189
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 26F031C0003
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 11:57:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="WExiF/lE";
	spf=pass (imf21.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775217422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hlI1RBQqJjfpWuFZsCc6c4R0ASQxP62EyBGuIa0hpOs=;
	b=utIql5saTYzrxaPMlZsk1H8dlaluO5luPNwiF8ZauIYd8tQ1TI7rSw1Sgp2A96xQmkw7Wi
	QWp8WqgtDIHXobSPg6SC897rm6zzgJaicTtfT5WwqHtwVScPrEdSXLRLgsItjI0pcxcwvs
	kzxtFuSgn9xHSTYIo2rbTndv4bfRB54=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="WExiF/lE";
	spf=pass (imf21.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775217422; a=rsa-sha256;
	cv=none;
	b=YvTDKLlb9QlJ/++LWXd0W+YhV8LYvcIRuOzBRLIUSR15TETDwNhRczGZN1SWUVrLk5c1ul
	Vhw4kzK7fqGc8cnPaGMfRgTr1PffzIzXPFWrSDvVMq9PR7RCwmMXTEFX1AKf/Ovmbw0fRf
	3OI/FmJTUaEc3HGLcz3NLWWq13TsKzQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 975CF60121;
	Fri,  3 Apr 2026 11:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F48C4CEF7;
	Fri,  3 Apr 2026 11:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775217421;
	bh=hlI1RBQqJjfpWuFZsCc6c4R0ASQxP62EyBGuIa0hpOs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WExiF/lER3/HxYWRZ7/VYGGhEbpEpz9xoEPNjcsCFvTGNpufubq1/grWFEw4iuMUy
	 OoXV5ZN9cvTpw+MrimzFf6s9HmUgEebMHP6rxEPoVqpOak+AAKYreCCI+aI8f5Gcf8
	 zd3TXBgf41BbeUDYgDIMBFsxjCPG+plKws+G4eTYF97BpuDvffRy9f5yT7XQBVGQbe
	 XqHjaEsIVjnSBX+EIpGZbUC6lXfkWCjygMqGuZgL2M9uFpPhtTcBQ2hiVkdvbT8xp0
	 yn+PYHPMRpNNVo0RArrBjXz2Wp47lKN2V/BGSRUsMLv3YU6gYJZRfQsOsmZPjmN+O6
	 y2sPDI66WCWpQ==
Date: Fri, 3 Apr 2026 12:56:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Douglas Anderson <dianders@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Robin Murphy <robin.murphy@arm.com>,
	Leon Romanovsky <leon@kernel.org>,
	Paul Burton <paul.burton@mips.com>,
	Saravana Kannan <saravanak@kernel.org>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Eric Dumazet <edumazet@google.com>, Toshi Kani <toshi.kani@hp.com>,
	Christoph Hellwig <hch@lst.de>,
	Alexey Kardashevskiy <aik@ozlabs.ru>,
	Johan Hovold <johan@kernel.org>, ardb@kernel.org,
	catalin.marinas@arm.com, chleroy@kernel.org, david@kernel.org,
	driver-core@lists.linux.dev, kees@kernel.org, kevin.brodsky@arm.com,
	lenb@kernel.org, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com, maz@kernel.org,
	miko.lenczewski@arm.com, mpe@ellerman.id.au, npiggin@gmail.com,
	osalvador@suse.de, oupton@kernel.org, peterz@infradead.org,
	tglx@kernel.org, will@kernel.org, yangyicong@hisilicon.com,
	yeoreum.yun@arm.com
Subject: Re: [PATCH v3 9/9] driver core: Replace dev->offline +
 ->offline_disabled with DEV_FLAGs
Message-ID: <57452867-60be-4292-9bc5-4e2faf1f3cb4@sirena.org.uk>
References: <20260403005005.30424-1-dianders@chromium.org>
 <20260402174925.v3.9.I897d478b4a9361d79cd5073207c1062fd4d0d0e4@changeid>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="AVRN0JUTTuR+6v5a"
Content-Disposition: inline
In-Reply-To: <20260402174925.v3.9.I897d478b4a9361d79cd5073207c1062fd4d0d0e4@changeid>
X-Cookie: The Korean War must have been fun.
X-Rspam-User: 
X-Stat-Signature: ey834rhaocaopc7dnxymk4mmuqge7dsx
X-Rspamd-Queue-Id: 26F031C0003
X-Rspamd-Server: rspam09
X-HE-Tag: 1775217422-876186
X-HE-Meta: U2FsdGVkX19vr+/XLtGH9OVxRJRdsBP4bcDj14gebhllXanojuKkVcHU7U5ciURQb/mMFu/ZYOHYIQAtvcZHfAXukNzZ5it5uEiwH8v84JYOjr59uRinIoLWc9opuxfRnHSpemQ1RzItx2STr8r6Q3zb1dZO3ibOUzs4t1W6VNTlDRU5Mobc4IHyOfFFJUmJ0cYcDe1UN18DsUu2+Dho0Ac3LJKbxoFBttMZ7Lxp+qMTBqbJk9GtV+PLjEYo00LnfVwO3pAVhO26FcsHTmJcUrwS2oiPbnchCKll3cHlvG8t00MGDInenCsl9j+Ol664jz74ri0BzOOCVfkDOIH+ae0R9qw/lO3qR/+CA1zZoY/zYjVgOl+GzOJFkDlGHQ4zPgBcQzTb7Xusl7G4uwwIXHg9krKumvNFWOnb8L9BMO86TyTikf8HPRyXbZbEPYfQXR+MeF7ruHA6T3j+dhEntzWnYf5ELterTqzkXQ9AdG7z60cVCnw5gQ4SAQTRPUfu+ZlpLtwCslV2Iem7PlZz2amS6yc5sk3Z7dPePtOl4ib9XLLmb2Y8oB7qK17PR1Yq1WccWmWN5PYvcwB+uw1Inc8etH1dtupL8HSTAuWBJYf6oCwuEMlYAZ2wYGMXc3oP9/hKILJxedC6OcuEXGbaUYAkaqFM1fHcQ/3LfT8x6yxNaXMfECY57IjsWyk/CltKQp0iKiusuWZ2OyNEThxGlnxVj0T13RJQQ6A1tZZSoywltMapwR7gad2bkA2opbRVMqFQSrxnFUGvv8vp39XeGKQzoSpRVqwLBc6qyuTNxQIvM+qK0J3MTNTpBLJ9SERgfE9JVJWdA68D7vTaLDJQTMI3QtYgtURMkE2uLDW2pS3dhlBx5LULLKdacw5oyZ6aJxMov+fedZlsK8rx0pl9Pt2/UFT2zVosY/sMRyLML3Kq/Xn10LYDUPNr28g61vX47tbjY9Z6t5fCabRWWed
 h7ar+rwo
 v7tqvPeewerCHQR1A1dADSeNzroVK/8+0/Hp9ZfVGvLNNh7WWrcCjOy7VNN7BKLWQFIwJXTI2p7XAOEFSBMV9zb48rfwLzH997ZE9CvANkbveuBlEpZ+Rv/idxHrRh92BTnggfXu69crZoOwP54dsiNfatbbFxVnlOZqU3xJyf20MiB2RhfZjrAovs/y9CyWj5riDC0HpsdChgREDP5SY5YvShuGszgzTgTo1xAJnh2JTUmPezsZxwagUuNYdWf5h3jGReMR2qWs2I1ISOCkrXIVtLeC2P8zRWeVmAoRNg1kI7f1Ni7M4uaLy+3rvg690o/K0chNRkrJe7HGeOjrbO2s47qUyAJHPlzBLbcHJm/XiwL/hfedGcofgHs08xUQzgp/s79eNZqhhQ9QuudapLpW4BN4Z865rJhVE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--AVRN0JUTTuR+6v5a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 02, 2026 at 05:49:55PM -0700, Douglas Anderson wrote:
> In C, bitfields are not necessarily safe to modify from multiple
> threads without locking. Switch "offline" and "offline_disabled" over
> to the "flags" field so modifications are safe.

Acked-by: Mark Brown <broonie@kernel.org>

--AVRN0JUTTuR+6v5a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnPqwIACgkQJNaLcl1U
h9DTzAf+NmJvooER0KUGxju0cXbQLPzjhe+zmzezOQJa1zXjXfgBycnhieaqK7ny
S+ZKb3sGXOFz1uf62w0rkTigz6ZBhVej2811kP/v6hOK59NgZZTJQfO8dQuSxEnT
a/yLND6ngy2gm9svEKalKOxPy9JbUJjkq+j/fHmoGQtgZJzi3MQgf8Dj9JD9Hi9K
CfKa+1VEAm39ijM8hfGOPXIHopw7PmdFfwGHkxLjmh4CRnWEhvWLFCPR+FiBQ0Sn
XrkEJ4xDFRK5m2nxMzIK4mnPEH5oNBFredP+/WQ/ak8W69Tqy7XcVG1E5yZLgzci
4Y9/xe7D3PUt6PvteNaqZANk/e1zpA==
=qXM/
-----END PGP SIGNATURE-----

--AVRN0JUTTuR+6v5a--

