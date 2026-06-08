Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA280CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 10:37:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A5F26B008C; Mon,  8 Jun 2026 06:37:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37EB36B0092; Mon,  8 Jun 2026 06:37:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BA666B0093; Mon,  8 Jun 2026 06:37:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F26D6B008C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 06:37:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BC43F1C2BF3
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:37:34 +0000 (UTC)
X-FDA: 84856394028.10.E419520
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1E25F4000D
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:37:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ejm8OtTw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780915053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bi6ela1PzKjx+8mELW2MCPCgwE8HURVXok4aZqsq08w=;
	b=LSPFopW5+2oBcO4yyHaupqPTt0Re3Y4ArQOEEXmjiLGdAfHzufNgMghYmUbCfjN3MAmWhD
	dsRYFP1nlNEqBB/lQwF5r5adjcYrTHATlUk5wjWf4fVS8WfNwfU3nb5BeemvgLvkv/uspo
	XdLavV9UPzoVv5fd7OKAMfSQU7RuIfc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ejm8OtTw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780915053;
	b=oR+BmmJYGwHZRi+GIQTTNR+ddFDez4geJ2vo4k6Ushmw+79Xaolp9zBFvYNf9hU1/BQizv
	1LfB2yvsCUv4v1ewKQMh7yX2Pw0r4qAUvjJlgcy+6J/ZfttzM4yMbXsDOOullxic+F79BW
	2wHQvJ8UsAzy966X+8ndqKGCJSkgYPw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5172843639;
	Mon,  8 Jun 2026 10:37:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F8A1F00893;
	Mon,  8 Jun 2026 10:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780915052;
	bh=bi6ela1PzKjx+8mELW2MCPCgwE8HURVXok4aZqsq08w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ejm8OtTwRK1IxMRRB2gaW8FKerJb/HjUQOjE+YqwbnZ7GZWKS4mR+EcctpvKDEepV
	 ZRuMVzDnpZHrnnzIzGMHYICj8tNavzox34ngAIGylYMDBRBYT9LO1lMxVNues4WUm6
	 KyFwrSf0Es2fA+Mq20Rs/0u7SJZsskczIbQYnoB7EG4SbTV4QiCwYX/vNlaS1O2O9Q
	 BuT/dJay7Ts4xuszmsFv1jTFzOfWr1eCsyb+MiVsHBUag64oqS8XGs9aAgrZ2Qi7O1
	 Th/RubEtnIRs/tS1BoKtip0bFK/VB16gyJ/rHbsW9nPzlqVBQHwVPgV/9ONOfFfYlR
	 HO4K8GEgRKW7w==
Date: Mon, 8 Jun 2026 11:37:27 +0100
From: Mark Brown <broonie@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: fix ksft_process_madv.sh test category
Message-ID: <23069ced-21e3-43ea-a338-182f6f861583@sirena.org.uk>
References: <20260608103224.344101-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cq+yAeCdDhOAl0L7"
Content-Disposition: inline
In-Reply-To: <20260608103224.344101-1-sarthak.sharma@arm.com>
X-Cookie: We've upped our standards, so up yours!
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1E25F4000D
X-Stat-Signature: jyxms1hubpm39c61soua9qgndkaphi6m
X-Rspam-User: 
X-HE-Tag: 1780915052-446236
X-HE-Meta: U2FsdGVkX18LDYfmCIsVx5U0YvVrjGKtZDOqI/nN1vhl2UPSkcdjonMj22fLxRLSnLhr8EoiJDOfn0+ZlisCZPXGZsoSrn8wJJrq3g32/mEhQTkhS4+KTerfOM2rB9WP7r4bbyC2aXB3ZZP79sGMC1MP38IM7rTTf+Ux6xqjgzLk2ZRjkTdSnpwqiassMMCcTLskjoKn/9utrEbpVc8hJrWL2kjSCpa5RJIC9fV0QzY7mur+0EyAmSGrGZi2g0i7U1Uv/Z4rABlwPIUVbcn31LVQIwKD0SwD9cbxw4wWAnkKux1VBKgC6NbCMfWs0EHIOaQygJZJuRklz1thMM0FSng2VizluI4QJe7D7p28hFqCFTo0LhKvDrqIekuUC6AUz+0+Hb1a/1UklqIS5gM7Ee0f0WM6apWVbl65LZBliFOCEDgNiwIPLYADOPZjS0TcXk/KoppYngfC5Vbf9enURcxVE+Swwrh5aAJQMpBuKxTOUFCc19jPmRTe2D13P6qo1WPq0jRClid54qNT4xdk8KregLnhW1g1r4N6dk8LJqiOBt2vq7afEd3Xa5QR7VVg5kONg8kLMb+ZuwEDo6SeMTuW1UHsZWuVTyPo6vBXY+zToQ8OEkPap9sQVNIO0NRlf/2ejApo+i+1z0ZrfQFvnAqUFFR6k+Npd9P1uOcIeysK8XhrVh2HkY1257uFcXf8Cf8N54KcCRTd7MeR0647QzuSqH8mPBRvyawcqi9v453PTQiCg1/syFkwoUjy8GgXpbWA7gpsA5PNR5bya9szZ6sPe2dlDVbehDOHq1HP7O3CQKhx4rh/S0m7zfLXndHZ0mbiQeOoYFKU43R6UD5GraOZ4kvHeQpIQAhgMa+1Yx6plGpPLEEoqaIW1fbnfJz/AHCIGNSgD0X2hfBImymw7gbJcr/rJDj5rdTphSFZXckq2bSVG/9chHWh/8wEHgZrADNsOtOy2VdJeUsAvuZ
 JhV9jEO+
 bTphJvRFi14NazQCqeOqFu+PHJvhuJrBWP2+XkkpREf/ibB1mvSS/p7NIlot6s3bHRJLZAIXKz97GXYRhEVFds+769Gq9I40QO1mF8oVhN9aPgON/lsQnhuVfMHATLK92EvixSmBz0ndtBknn+GBfqAY1P+uIyp5jolEbc/qPsBaltCb+t1EiaqRwAQRN7RRkukRt6WogabjuPpoAffUajhC9D6u+7Fplm7RvL8/pjhG1k8Vr8p7wCUX61/aI8axzV0Z1B0j1nCR03NP0zGdk7ph5VnsN7n9EpOOrYH2l5+LTbI634gprD/PAtevIw2khzQ7m4C4p2lds+uU4ysywrn0n2p9uAH0pm8S67l/YWYqhNOccypLAm97hbgDaIuROtAsK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--cq+yAeCdDhOAl0L7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 08, 2026 at 04:02:24PM +0530, Sarthak Sharma wrote:
> ksft_process_madv.sh currently runs run_vmtests.sh with the
> mmap category. Update it to run the process_madv category,
> since ksft_mmap.sh already runs the mmap category tests.

> -./run_vmtests.sh -t mmap
> +./run_vmtests.sh -t process_madv

Sorry about that, obviously a cut'n'paste error.

Reviewed-by: Mark Brown <broonie@kernel.org>

--cq+yAeCdDhOAl0L7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmomm2YACgkQJNaLcl1U
h9DLXgf9EsUNsYMgg1YbwFjooXAaQP3U0UTcEACKdnwX/Li0OSW+969rU2vjx3NX
hbgrpkCnSf4bl4K5uMgXmiJvA1yBnWRKMZWttgZVhN9GT1u1vZoo3VyohJbqaFEJ
st4GkGvGw1+u/+s736Pa2UvmlU9b0jO6XNq52csGFQAoxL53+2knpND8iGzxQz/E
e7heBbbFkXY73tjeKPgagFlLDDt6bi5ZyIQCwwumLribvsCucmIxnduva2rJt8TA
uBjiuVVGxIAVqRLlpN0biP5wMbu8nY6Uei5cbC3qWOXX7Jx6b2xelBZ2h/fTQqjc
71l1kn0Ud9DICYy2nfzzDnhuvEJ0Hg==
=1EMQ
-----END PGP SIGNATURE-----

--cq+yAeCdDhOAl0L7--

