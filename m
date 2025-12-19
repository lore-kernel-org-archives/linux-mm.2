Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15C02D7496F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 09:31:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 668496B0088; Fri, 19 Dec 2025 04:31:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 653266B0089; Fri, 19 Dec 2025 04:31:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56A176B008A; Fri, 19 Dec 2025 04:31:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 406486B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 04:31:22 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EDAA41A0509
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:31:21 +0000 (UTC)
X-FDA: 84235702362.08.A9A3710
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 593121C000A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:31:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SvcBAeCu;
	spf=pass (imf21.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766136680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j8TZc5XwPNYMEoE4seJjAVwVtp8dsPoJJX4kIRgwWZM=;
	b=tEoZJnpPNkgY4zo3F+pSIXgISGuGL1POSsXyBgifQkY2+0iLCiu41+0dKAO1+nNrL8bacx
	6TCuglth+jyl2ERX8YHAUCJ01hTI9lw63OqRJ8lywiACqGJnXlEbvXpoaMU8HbZgIB9Bck
	cfGNGiOOTDgqbBNwl1PmcueHgA/i4Hs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SvcBAeCu;
	spf=pass (imf21.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766136680; a=rsa-sha256;
	cv=none;
	b=BHxyZuhcj80kLk9U/7PmXeb6jInmeZnhmeWLP3mwwrfV3EZ1xr9Xugl8g35jDAYQqXJqUw
	I9pqt2dK0wOmwS+1ycklqLjiibmbkxkShN2U6ExUQF1EN1sNNO8m/ZwqJ4BeSMfnUWb0iA
	v0xDVqV6Zprtxd7crN4uDyizVB0nvks=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D4FE360018;
	Fri, 19 Dec 2025 09:31:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C49C4CEF1;
	Fri, 19 Dec 2025 09:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766136679;
	bh=JDYyYGh8RrQI+zVY9L46NOe+/hWd6ylKrEcBti0g6qI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SvcBAeCu/Pdh7bz9GUGnJaSUHchFxGcvlI53HUKKzdzPql2UPl+smqieCqxW1wsQZ
	 EuoSKZEsntAzSe7zk6TKtg6GbVQJc+dU4H5Lq7/CRLTB0J7l2sP9cJQn0HJliWUu6B
	 z/Zc64Ldf8XVFX+m5hUYl5sEYIXrETQG/TxcJeHkijpPLPwiHDjRyLOPTOORnsv/64
	 cG6ZES1auagKZSszkJHI/LpAOHg6S0LU3FokQuuGl3jvEOGufr1Dwy8faUAoP3z8Tc
	 ZKAd1OAGMCgQ8lofMQAk7vNtl10f6FWCCOuhf45N99nAuDYF6mxrcTKNE4tipo8/ES
	 1VVHQZMet/rHQ==
Date: Fri, 19 Dec 2025 09:31:10 +0000
From: Mark Brown <broonie@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>, Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>, christian.koenig@amd.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	Aishwarya TCV <Aishwarya.TCV@arm.com>
Subject: Re: [PATCH v10 2/3] mm: Fix OOM killer inaccuracy on large many-core
 systems
Message-ID: <2a772584-2269-4008-809a-6123e226ebe3@sirena.org.uk>
References: <20251213185608.3418096-1-mathieu.desnoyers@efficios.com>
 <20251213185608.3418096-3-mathieu.desnoyers@efficios.com>
 <c8acf650-ef96-4449-ba85-557dedba0ffc@sirena.org.uk>
 <72ad1fed-574e-4850-beac-91626e5aaa0e@efficios.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nB8gAt2CMqOecX2t"
Content-Disposition: inline
In-Reply-To: <72ad1fed-574e-4850-beac-91626e5aaa0e@efficios.com>
X-Cookie: Save gas, don't eat beans.
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 593121C000A
X-Stat-Signature: sph58iogohy1tft5b5fieitet4ft11eg
X-Rspam-User: 
X-HE-Tag: 1766136680-55045
X-HE-Meta: U2FsdGVkX191cPne/nec6a2UonXBuRglncxvHRuOZO+z9VMhRVwVU2tfK6bNBUlz3s6e+rVOPxG0vmXgemSAi/AlxME4aasfALsDk3CkpQ+zVp1p6XNskIhd6ApAbfJaqRzaCVenLXSn6eVGw30nhJu/IJaXwysxxxFsvk7LHxl3C7zlzi8QO3uBl9yMklMps3zNKzWPaGMeg2Y6RlRt0sRACAxtjU8JXYMf9m+HtzpYZ7KFxMp/anj/OFJK1VwWPU1gccUFm5VOtAJQ2mMrkz8YLNwQLo+MSAKmimG+SM3ySEsXRWlktZV4obuV9rJKNh0UV8/bIKIB/oBPvKbcqumlkqKkbFPwvu9KBV5xWbl9OIpZhynCdxpwY05wezH+7yxMXAopyuvb8BaKV0kgeNekmUfAdcRQ/S3FLCQTdsgI9dA365TkK5PlTSvvrwRLVbV6qWQiwLiS2uXom4MCeJuzbETCKxsZa5mHT3HmNAwe1Kq4YBqOpu877ISMAXPjSyUEFO8iGHEpqmH+GjUdNDVilotMOpHsQgb1WbnNgZd3SlZBnfaSViXT2udynM47k36cXfIhz3nULJ7PHjYCKqVf+Z0YsgKUrmwbGVRJerQvFMqOXG0uWPBRMTUsR8/mLEVH+goQO84j+a3QonrFHLG8nz4Te3R3rCEyg6Imy76AeAvPixfJtiwhMOxiMUlGa9RB51WzeuB5f+DOnoRruoDW+R//GMb/NPsPKh6DbJNFZeOvyATp2YavXLf0ESShkOT6GLcUjsGw84rmGNbZc0GcrcXpEZ7QnSaWHcKmJLNZHbNesntUWOusoI42Z2E/rfwoXqO3UlYiqn8X6Ec0STBVe3Qh0QbxriCJSkWu6u1GY01HaThiAlYnWjxagkUKeEnPOw2pwFL73+n5iJ3frGa/dkLEj255nix10MCNhR3Fq2NZ3Xpk42sUfy4TMv6QCsVI/ASkj34jMhvQFcb
 ezd2z9F6
 K6hqMLQt8if+0de0mAPeVlkTtK6mFBZJnYscgsJqn76v50PocWHFTV5GElzsidDSdTOrC77ImSU+zmf6PFquYF9i8XH+KDXZFNI4mJFLxYPRf+RB2loN4rgEjdjHMbLJc8L9EL7+e75TdjKkKUUVmF04kPAyw7uUR/RrhO1cRngCR0nyYLP5/8R9Ce9OkiVv+CViR1RGKoR7rMcUxjg5AwDjE5hSVzMDGUCqvejDksaXouVZfHNqIU/cRr3sp0w3qYx/z/YDXQ3/MX/iwZFUbEnEbPBrvqCxRoG6BibBUtugDHGfJptLRCxXygZ7USWUntiyQCePDBV5SIXmWj6wPpRilzluButkyr5O119F9Hb/JcI5UPxMkxdFqr/PXrwjdq2do
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--nB8gAt2CMqOecX2t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 18, 2025 at 05:18:04PM -0500, Mathieu Desnoyers wrote:
> On 2025-12-18 13:00, Mark Brown wrote:

> An ugly work-around that may work (and then we can improve on this),
> at the end of mm/init-mm.c:init_mm (completely untested):

>        .cpu_bitmap     = { [0 ... ((3*BITS_TO_LONGS(NR_CPUS))-1 + ((69905 * NR_MM_COUNTERS * 64) / BYTES_PER_LONG))] = 0UL },

That doesn't seem to fix the FVP unfortunately (BYTES_PER_LONG doesn't
exist, but even just deleting the division entirely fails in the same
way).

--nB8gAt2CMqOecX2t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmlFG10ACgkQJNaLcl1U
h9DefQf+JvhAM2zVW8yicN4Cg9fpYL03mrmvjIMlhXaVtEKithjABrlXzEEnlEg+
+zjtAMmjdy6Rk/9g54g3fYkcixYEqyyUsVAW9NMMWs+zzvVRaDvol9QqVeuaSn4g
6IpUfrPOtlWq6PKKMhcCiLmiK2Rh+83F0NJYtr2/NpDNmg2pelTUgURJa3+6FRsv
LxhkCeEDvayR0U6J4PT3iDQrRACrqkLZ+tXAArOS/jQ9BPC4yQhXfCISptkXadbI
8fnQKlQUlAPh8OJN2lqiqUZWJ0z+OTl4/s5MKoRqB6sEh6bI6vftmyZCcFF7rjlW
w2PeciwdUO+nJz/TS73YbVRA72dd9Q==
=7twn
-----END PGP SIGNATURE-----

--nB8gAt2CMqOecX2t--

