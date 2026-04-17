Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69D69F43697
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 12:37:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFFCE6B00EF; Fri, 17 Apr 2026 08:37:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB0C26B00F1; Fri, 17 Apr 2026 08:37:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9FDB6B00F2; Fri, 17 Apr 2026 08:37:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA7B06B00EF
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 08:37:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 720AFB6058
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 12:37:54 +0000 (UTC)
X-FDA: 84667999668.13.951117B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id C68F91A0011
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 12:37:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LJI48adG;
	spf=pass (imf19.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776429472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wcPe5anv+XOPlGBuaeWDvE98G+5U+w17cN/TzHS72W0=;
	b=Crtn+jEpYIkR0AS2tV7baW+g2yONZoZr9Kkb3UciXGFW0lZkwbFQqcE0Pg7y2fGXbDr+s8
	dGWQ2BQJsw086b8Q5gmKz/9T3VpXwOXma9jMEYL9wZt9He9tgaUpgJOkqWihCQ3P4JjwgT
	HsrVTfypmp/RNA9GgT559fT/OlvYBr4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LJI48adG;
	spf=pass (imf19.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776429472; a=rsa-sha256;
	cv=none;
	b=dkaB+8LiivEl/rUTaS36AYseUoGqYtDzQx1zr7LcjEnp2YJ1h4e6zTF9PYt8nc+w39QW/0
	3pnRRUnoXLkEe45x5hVPoDSb0xPsyNcwnrxN7o5YPokWsIzqTjjLfczvrkBUo3tW42GpF7
	ATE0OwyFtyvgvk0DA6sTsIE7gDvVvEY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3457060128;
	Fri, 17 Apr 2026 12:37:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C8EC19425;
	Fri, 17 Apr 2026 12:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776429471;
	bh=3V+1JeRzd24DClnOrQ9aq3AVM1QM0xWwhGfZaoC1XwE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LJI48adGM3785seEzMFbj3rLKP4F/ni5aDsMwk04wQQep35nTAdL1EFbi/ueCoDJW
	 x982Ls943GgCo6EKbr/7p4oQUGlKsalbxal+5EdwrBJSWiq05Rz/pmzxNB7+uOlaU3
	 eMbLwRLPXuHXPYFIrDLJKG/N+l6h/LuHQ3H+C1sP8l/y1k0/mvnViNW0qwohnte80h
	 bDLcGfwxq8XQrfXrRefyb/pkpia93j0RYqRlV711XLg17cqw4peihVP4JgaZcHMe3g
	 kElEv8ZYPy2ZfQKmTYkG7+UmYOlVhOEIVFaHTtpbGiiGh4K97YWyIQSZK7bZ+sdOFD
	 9BuqQSer9/eNg==
Date: Fri, 17 Apr 2026 13:37:46 +0100
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
Message-ID: <ad3c60a8-8346-44cb-927f-367dd0c39b1a@sirena.org.uk>
References: <20260416-selftests-mm-proc-mem-always-force-v1-1-3f5865153c67@kernel.org>
 <17ea54b2-d43f-49a9-9dd4-d2330a8daa92@kernel.org>
 <5357ef55-15c0-4c66-867d-898fa7f51414@sirena.org.uk>
 <aeE4XSuXY8RfphVs@kernel.org>
 <8260f624-7ed8-4766-8f80-0d0d4dbb5cb1@sirena.org.uk>
 <aeIonE2r89VdTJZt@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="WvM8zwGvYrTLpcPO"
Content-Disposition: inline
In-Reply-To: <aeIonE2r89VdTJZt@kernel.org>
X-Cookie: Uh-oh!!  I'm having TOO MUCH FUN!!
X-Stat-Signature: ijk6dog59xkqixhzkoomzngdgxgoawpc
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C68F91A0011
X-HE-Tag: 1776429472-851701
X-HE-Meta: U2FsdGVkX1/Ol90B4+O7ZC7fDjAVOYsDKVM2uJ3e3x1CFFc+0/pZkdfD0aWgN9681O0xlaAsJqsEXhgwQqmqV9za/0FiZYlAqr87GENGQOx0PGq+7Lx6SpK78pxOvA6WR+x8xeWhoI2o3lzH6yRDch+PU3lL2Em85BTHzXH6+QW9X49HdgEzJqKzQdk2d6oTkqKVNsvD5LpCDvFMghm9EG/Pw4OykmzS1oWj4KO7tJypL6Cbw0WmbBu/rf0BjgO66wrAvgOBrLl5eu0GDcsK8V735JRecinhQOnyhZfxb7p5PUM8Js8NswTPjPm7rhcGHD9jQDW+35L+UKtBcg7FBdUTre2NiEClkVLMej4Eiisl6Ta/mICMIyJRM1/ZDJ7peD1ZsFB7/pJNnP/QNdlwQP+TQhO1YdqQq94mahw6kmCAdSE3gejYC1oQfH6B8mSjnqH/gQVoGxGuo408CwaUIDKJnrHNTPgnUtlkt6myUax9msz8eZsk9rnuwTwD+Egk3C0RIcxBgeoli5l1Dc7lDphL/AxBj5cqzsIUmPamexAzJlW4LFM072WS8Orry9GqsAI5j+P5H7E7swS6sLz+HodBehOuc3CEWD3zzz1JP9/wVok3bOICTUFzpfCIFesQ6zJSk2adxNIsMNcUeUxKXRBmdUANy5ozdUBFh7yIQwFXauMHKtcFib9NKnS6wcaxOHCbAhy/s/A6ZUYzUFrrL+YE3gfZR8p8Q9spGtl21wcYqp1Upqjwpei4RN395HlsjyFdZsMoyguouyBgqj6NZFFXC5n4nT6ibfYhXhqbbDCMCsdPVIz7bxJ1HlPqUn0F76cKQCRga4gAAt7xOqDUYorY+GjZvrym8wTyedj1gZ+SVc7/czDPzcdhmsap9vnQwTTFjMJADx2iiqha5DuFVkcMQQoj2jtDfTYdJs89dYJY0n+Gr2iEyWOVY7PNPzYsIpt7w4+3ti/uRuFdEVw
 yrYtVyub
 KLt0oqDepy0R/bP84h0zki2dWyUWJvFRkwGbtO/6vzWzDv5IvYubaYrndUb+ouQ1by/bl9NNb5zDFWODskXdF/7u1/OV3VrWHZFq4OXMSB0DuJivtNh3o2bDkLx0a6iPwOQk6JOEiUBQVtcYXS2O/wX9gZwMlYj0BMGdPbiGMKkNy1jbyuMNjWLbZU8QC0pe+uINJGkak2/Cx82ZQHToiRDIuQtmNRH1ROpOgtj1sVL+vgah3TnFMrWhqskG4zVwUYW8gLIn+T79ngt++nPx/8ryzdRCmUfdm29agXjoxv3jX+hqg2ojoFw7t9MZlNw1c8sUPgH4WqcGi/TwhFKcOImAj5akdl2NIxN+eQDn49tfi+DE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--WvM8zwGvYrTLpcPO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 17, 2026 at 03:33:32PM +0300, Mike Rapoport wrote:
> On Fri, Apr 17, 2026 at 12:24:25PM +0100, Mark Brown wrote:

> > >  {
> > > -	mem_fd = open("/proc/self/mem", O_RDWR);
> > > -	if (mem_fd < 0)
> > > -		ksft_exit_fail_msg("opening /proc/self/mem failed\n");

> > Yes, this is a preexisting bug in the test which I see there are more
> > instances of :(

> Do you mean that ksft_exit_fail_msg() should also print the test name and
> the actual failure message should be ksft_perror() before?

Oh, I hadn't read that closely enough - if bombing out of the entire
program it's not an issue.

--WvM8zwGvYrTLpcPO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmniKZkACgkQJNaLcl1U
h9CUXQf/b4HKtAKgUlKmw4k5mcM9h3raGw+Kp/OhcI3iGExLzD7Z6MM3OSS0aqf7
52XBXkTSFt3BVCT6G3dEW9nC7tc3cWzO1G4RKjk5wLX5x7Nu/Eeic2lcqqeOVawz
V2i6VT90YaC4MKf+x0ydPYntbYFIYSpSMCNo88kPQKrgkOiFb9jcy85eOabL9/62
iaK9S8M9Wk8MwiAHblPbEUPqU4+9xJWvkje1e+R5RdOYjSaCWgzs3c6SdaxaG4SR
M2lHD9WmhBl7Pp+OeUiOxU7jyMuWADBJQatPN7CL9bwkcXS+osuMKdb8Fw7GTqG7
FGHHo2Gy3yz9rI8i8hVdJNQqHtqrjw==
=Mej+
-----END PGP SIGNATURE-----

--WvM8zwGvYrTLpcPO--

