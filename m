Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3C46F43691
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 11:24:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2D346B00DE; Fri, 17 Apr 2026 07:24:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D054A6B00DF; Fri, 17 Apr 2026 07:24:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C42326B00E0; Fri, 17 Apr 2026 07:24:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B190E6B00DE
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 07:24:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5F46BC0282
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 11:24:33 +0000 (UTC)
X-FDA: 84667814826.30.74EB715
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id B941240004
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 11:24:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BmmCFImz;
	spf=pass (imf27.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776425071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XUGd9sXA3iMVPtDyVAZLMroj7EyV6lWBISQZs0eocik=;
	b=i1LCXtFowKAymyc2XuguVrbyB/DksKO6Inabf/U9tfon8xq8CQ30+rCk6keIcg3yoCrJtz
	o/EvpnCjBeqLRARwsJdnawoIs5RlzfirGuYRgmz2zhOVVP8oPY47y23RFh1qkOFMkr8ujM
	JlKe4A7HKL+yTLdEt1mFFB+vRKXxU1A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BmmCFImz;
	spf=pass (imf27.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776425071; a=rsa-sha256;
	cv=none;
	b=ftUg2UU/lwCCDgaPooubj6SlEXm0GaC9krHRUEqjKLyGxMWZXhCLMfIVRzagfqG5kVdnUB
	QE0stM6tbE8T0d/fPDf12elCPgt6wxobnhJdV2m2Idu335qbcc26eF09eN6f892HHq3G9w
	4kxEdY+hVtXkpzx9W2w2MAL41DTWoJY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2393260128;
	Fri, 17 Apr 2026 11:24:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D8FC19425;
	Fri, 17 Apr 2026 11:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776425070;
	bh=L6qitQy/q2D5JdYnKYv/Txw+aDlW8qjnq+Ex/xEZJBA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BmmCFImzd8rfQeHh6WEjrihCh1bJMjsCsqipim0MpJH3fREzC2oiN+B7ekS3HF6zk
	 o+EfCbNjbyQJqJg5ns/kRppBMsQGjjP3QXiImsMVaDj552nTiUUAqj8mko91YWwNcs
	 V5R/WgOxvQ2d6hGRrnWCChbcaKdVQEIOvWmrs44+zIJ9TyqHpMqpWmxdzYvTRMV836
	 C+ybj+CkhaTwhs+7UK9ysXriW5tkSMu74FSmXXzGORRxQjcIBIb7I+Gv6iH8ifZmz3
	 CvQUTwh2c8dvFG86D2ylkfhpvSXn4mgVM2z3bt5rR/hstnHcrGTt2e/OsZ8kyIn2VJ
	 AqUX3+B4MYjVg==
Date: Fri, 17 Apr 2026 12:24:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Aishwarya TCV <aishwarya.tcv@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Specify requirement for
 PROC_MEM_ALWAYS_FORCE=y
Message-ID: <8260f624-7ed8-4766-8f80-0d0d4dbb5cb1@sirena.org.uk>
References: <20260416-selftests-mm-proc-mem-always-force-v1-1-3f5865153c67@kernel.org>
 <17ea54b2-d43f-49a9-9dd4-d2330a8daa92@kernel.org>
 <5357ef55-15c0-4c66-867d-898fa7f51414@sirena.org.uk>
 <aeE4XSuXY8RfphVs@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rurjnzOyeXujEi3i"
Content-Disposition: inline
In-Reply-To: <aeE4XSuXY8RfphVs@kernel.org>
X-Cookie: Uh-oh!!  I'm having TOO MUCH FUN!!
X-Stat-Signature: gg3jk7xtqky7i175857dt3tu3i7actum
X-Rspamd-Queue-Id: B941240004
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776425071-339850
X-HE-Meta: U2FsdGVkX1+KIQCm59NXshFZXuLGEaHV2FO4uUjFVIT9IUnWZowzFe840Jf+rfC5bux4/Sgm1UzYjyDU1I4/HabF9uUaOFXwNlIdtJFzoXsAf3YaOq0r6y3aVxJvPIJdXtR+B08CPpD+sI2V23VylnomnQ+N5Kl6yyX82gQPGLiAB/gSvUs3a4Qyr+llxLoT0N56hi+LuEfv2GVcXXjCcL7yrAmaR/+toLiGz3mxXZ4JmOWMhPDJ7R018NPEchJxTv9nUgVLWmK/nSLnM/74AcLI4854OZg5aWp2agc/hHtlt62dmKQHg2/xWtTor+2aGQj79ywd6d0Tti4gPDkUxwU7J5LIEPg+FwuNrL2rETnz/tUyfO2jNs3cUbTkBh0FUJElWGwbOPsFmOlqVwuyV7Cidcz8jDMsMu2x9Xy7tXKbfJCzgOaecUFDgg1PPluc3rFcHPgM3StMgsmPyhlf2Iv8WhxiprglrBnWdG/YbHzxVmhtmz9SYgJzDF+BD6sh5DBe8gfKepXUdARHT5zg9KjZ2g6A4l/uLBY7rkJSkiuW4KRpz5d1L8NCeik7Zv/FVV05b8OX+9ijxvsiNi0qP4mhmZEZ+Vn7TpDBkBtqeK/70oduQ2x5C83XqrBimPIbvRcnN3dwtOjQgPKXGnPz1eqIQuWBSAVYpeGgD7aHPiXytpDSAXcwtnnrS2Z9JFRv/MBMlr3Qvx4HYVkx8duPXOd0/ijcYHPBnvH951o7vDWM/BVXhxwo2Y6LzeJxQ0MfTo0YY0sm3LubHJtIELMMKE/NUy9CgriFn+yxUh771IwAZDf1DdXgAiIc7uDMAfaC0LHxgLseITc404vlvmfXJU7xUCVUVr4pKDYPCnrbGO2y1pbcj+CwYNZ6+z7iZ9IbIRYHR4eeompvVVMYlmnBHd3Jd1xsjb0NysF/yCMd9O9RFMmaf9wsJAnuwwKHuRliDrOBPUQc5GkKFMXFPQi
 thSdkD8H
 aS7WzwoA9EdmJhmGyHvM7aFJVbtLUglEraau2H599IKU7ptBGdOaiEpytG1cjmmurU5iU2mChqVuBulX+nLwMgHvmMeXgv6+FCaZX0gW9QVHkeY7Uwgm9JWQ5JHDWHipR7621tWOP+JFdMZf90M+Ut2rkWbtmA8k+txFU4whzyp0qqqayCxvsGi5ZNiXwRYtDk6AKQI2PhkeOp4rdn+vzpRB0yIzSSat6gd0LYho13P7lm1+RK8KvvBdjpFFfiOAQmkKICKRCuweuEXzz1KQ9hBXDTA7AM9Upggx3seqaYxd5EBw+x17DetlBWndgdwvyS7co0o427MNNs1idNHvVIhsY3KZPKftIq8chUU+TuMfNEkc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--rurjnzOyeXujEi3i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 16, 2026 at 10:28:29PM +0300, Mike Rapoport wrote:

> But sure graceful skips are better than failing the entire tests. Would be
> something like this:

> @@ -622,10 +621,17 @@ static void test_prot_none(void)

> +	mem_fd =3D open("/proc/self/mem", O_RDWR);
> +	if (mem_fd < 0) {
> +		ksft_test_result_skip("opening /proc/self/mem failed\n");
> +		return;
> +	}
> +

The string reported in ksft_test_result_*() is the name of the test, it
should be the same name as is used for pass or fail.  This is used to
correlate test results between runs.  The error should be logged with a
separate print, in this case ksft_perror() is probably a good choice.

>  {
> -	mem_fd =3D open("/proc/self/mem", O_RDWR);
> -	if (mem_fd < 0)
> -		ksft_exit_fail_msg("opening /proc/self/mem failed\n");

Yes, this is a preexisting bug in the test which I see there are more
instances of :(

> --- a/tools/testing/selftests/mm/mkdirty.c
> +++ b/tools/testing/selftests/mm/mkdirty.c

>  static void test_ptrace_write(void)
>  {
>  	char data =3D 1;
> +	int mem_fd;
>  	char *mem;
>  	int ret;
> =20
>  	ksft_print_msg("[INFO] PTRACE write access\n");
> =20
> +	mem_fd =3D open("/proc/self/mem", O_RDWR);
> +	if (mem_fd < 0) {
> +		ksft_test_result_skip("opening /proc/self/mem failed\n");
> +		return;
> +	}

Same with mkdirty.

--rurjnzOyeXujEi3i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmniGGgACgkQJNaLcl1U
h9Aq9wf/YXGg0YC6URYjkBzqhPoqyKQtnKLLfLCjk3ZQsGUUQx92Cn17KGkNoADf
FX1mnlXc8YTLPO/u6fu86GDV9oeOBcE7+fQMiZ+UrGyt8weNg/V2AtZv+YkuOYrs
aWxdkzKkriB8c3NHFOKmAondmg8Syjv6dVwbmYZsZksrxIdaWXGoFA6FPvvnKl0N
YAZiWW0RkYB9RgO2zpEMK1icVTnDe2CoqcOglDK1BRF2VVx6j9ZLCkKUdThMH5GS
CQ0u7m+67zxC0Qxsb3Pv5OWOEkqxD1AAspjnzfYxC9rd/di5Iav0mBLaq8CHoL2R
cCjF3smz2rEIo1gxF1JpjKLDLMQ+nQ==
=kWZG
-----END PGP SIGNATURE-----

--rurjnzOyeXujEi3i--

