Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42254606A338
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 23:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YcWOQZ2m
Received: by kanga.kvack.org (Postfix)
	id 5C3DF6B05B0; Fri, 13 Nov 2026 18:02:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 545C16B05B1; Fri, 13 Nov 2026 18:02:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40D5B6B05B2; Fri, 13 Nov 2026 18:02:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1D0DF6B05B0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:02:47 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6056AC02F9
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:02:45 +0000 (UTC)
X-FDA: 85431622290.25.6919B78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 91D6A14000C
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:02:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YcWOQZ2m;
	spf=pass (imf09.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794610963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ll4G4Q/q4XxD/HDGmclEgc4oOKKpDop1k/0Nt4LDa/I=;
	b=yo66Gq1pXxZh/pQsOM2JEW70jxx/91jV/JIP50rkuz0kp5iLk0N0J6bKHx1I7gfYKehUnT
	GSmUZOutxpppLPXXt4e4Eo8+F8iGWQKJl30WtL/yatBAZK+4ww7LcJUz6PIycC2CfXWW93
	9sLeahBz6k2/Pc1ppZ2Lu0FvQylbZKI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794610963;
	b=SCz3NoK3TEL5z8uI7xzbjPSX8g/g18w2YciCkTQjvc1uH8s+Qi2st+bV6qVyYUbP5jTt7x
	IYMu+Omg0aiiG4QNbEsVNQzWeDvIoxXY+jjpiH0NGHs6wODpf9zIY5jL1ZYwFt7LuUHklv
	ef4M+MeTPbHDvjJK4q0azqDHeYMiBEI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YcWOQZ2m;
	spf=pass (imf09.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4BD4342463;
	Fri, 13 Nov 2026 23:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C431F000C4;
	Fri, 13 Nov 2026 23:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794610962;
	bh=Ll4G4Q/q4XxD/HDGmclEgc4oOKKpDop1k/0Nt4LDa/I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YcWOQZ2mnmKIwfWqO86r36Y2thtdPt7NDxIJB1lck9jkiPFShHR8nf2BIT0tT2NP/
	 JopWy5LGV/I2uPyIA9lN4OxYRrf6K9K9CkF3nsRXOqUvUzFbLh2C98FR/8GCNMwm/Z
	 0tx2fmGRcFyrFI2fEge6AGnEVDVPxd9G0hj2dPVjejCU/RGcqxZr45+HSiSdZdR7/f
	 rEiVVLlYql5q3JybO7rdInm9Ap8JxBPlCdvGSY8fSVvGsaqbj3X9I5cUybgbhNRVv2
	 u8Y5s/KI6ck9NhvAIFsnBadsPV80J19oKVlPlhmPKcc8wWWuj1sjCmE3H4SGUQgQ3C
	 62V0u9JD1cyWg==
Received: by traversing.sirena.org.uk (Postfix, from userid 1000)
	id 8BD9A3287899; Fri, 13 Nov 2026 23:02:37 +0000 (GMT)
Date: Fri, 13 Nov 2026 23:02:37 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	sashiko-reviews@lists.linux.dev,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Usama Arif <usama.arif@linux.dev>, Kairui Song <kasong@tencent.com>,
	Balbir Singh <balbirs@nvidia.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Yu-cheng Yu <yu-cheng.yu@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, Peng Fan <peng.fan@nxp.com>,
	Josef Bacik <jbacik@fb.com>, Chris Mason <mason@kernel.org>,
	linux-mm@kvack.org, Borislav Petkov <bp@alien8.de>,
	Dennis Zhou <dennisszhou@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Subject: Re: [PATCH 10/13] mm/migrate_device: refuse to migrate shadow stacks
Message-ID: <8b5c7020-76a9-404c-bb2d-dba434c8705f@sirena.org.uk>
References: <avYJ-CxBEpdO1Wmu@gremlin>
 <816E22E2-C7DD-4DD1-AAC9-F51F4D1ED71C@linux.dev>
 <avdveCV9uW1zwXXd@gremlin>
 <F185BA4F-F26B-48EF-AB3C-848D72FA630D@nvidia.com>
 <20261113144316.57192d4ab088e7fc64eee47a@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Nv7RrJjmbTmkdLju"
Content-Disposition: inline
In-Reply-To: <20261113144316.57192d4ab088e7fc64eee47a@linux-foundation.org>
X-Cookie: Earth is a beta site.
X-Stat-Signature: cb6sypt7yinmmte48sorpajaqcsuh5xe
X-Rspamd-Queue-Id: 91D6A14000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794610963-200760
X-HE-Meta: U2FsdGVkX1/RpIc/VQLq4k71J0IlTTC86CmZtmvTdfWBRsefkxa2C2zP59gGYiwQ0wzeH6phlF+ErbO+awpI+053cckJ33ETJdMuTH0x+NxxJAyhEBQXQ8TReq03LDQu6ODFaX8re3vXQUVXDqqjRC9FdZkShW8iBZoVXyFq9gNRLLCTE2lii/dGFOX3VI4kDanKS9ZVUeVeE1/Iq3Jh7UzmH/Je6UPnt4Ng1VlPVMXIptTpEucnWzuKhJCidWCz6yYR8khOHMR20btI2XcBjVjMGkqRjpFVjxYS/1SVPU5afDQ5rz16yaO8w0dCaiixdRpb7eUwj57iXVU4WP/LysvLfWTWV5O8kofXngWBPxFQ6UiIxGePvig3/LYnLtSATP6uurRCijyNunmm8gXkT5lNXdVWbbt7xx7MDXWAJsfQDPU8WRcQn9x5So8wsfOP8eQasJJZRY+z3ca9tHcxDPzhgwU84ECsVAY365ZwunTZEV2ok4BUpJsGQ3wd6LZcuemM2oZCw6CiDecyahK6ojKqOSkulGa+bv4+8KFMwMN5FjZEuWy4dBW/NXEhCxzINUlx19i/9zDWUuD701H6AUekH1rmhxHml/7X+sdMTKNYB2RVTQXOU2MAERoC0nJgJYAyQdB7RvvA4cKqzjktjH/e24H6TgaPzZY+0Ol2iNJRlk5EF70HOQHipMcbRt6UO8Hwj/xVscyFdT0BeB+7xnqkajLMMieEocrysqYA1Y6+IfO4z+OGszJTX9+og2K8PNHiGeie2yDrYupeBgaGON6lS+2GuTBmioewlEeBYsHUwSx2QqRB/DirUXbI2UIaTG9FvDOR4ObAF+CBaksftVYiitCXCPISvY1eus9sXTCOmA1pgehflkoiodCFF1SLdWKmvOWc++tZctpiMG5ErGGJCIkwZYqfrw21weHq3Us2RXfu5UY9yJyhs7QEd+KSkkmVCNFzBIG9C1YilXx
 jmnT4pdw
 SbPd0jHhKKlpm/IO7J79OKFEDcKvAFqV2luCaE/V3YloWX3kYFL8wwvj0CGwwLXA6hObW8rqvS2cHjY8frgmtwxIpV+RG8fbM3Q409wVJDVT7CnAxblymMNmx/MOHcgiUMp8x6VZMSWXmwHtes/CnmB7fOo0D6nazIApiFKkL6J2/qCGHzXK4Sl2GofPRGNVJMz7to6a07hKOkNlHlNMHQ9o6R9onRg2UEzHMtSj49FZkRR7TFqlMpi0R4vhu+4LMFMMKkLYyBA+WPLPRa5bfKIJikcJtBZcgwvYwsKtrnxxL7eQ69C7If4HN9VpTonX2LztMChWQlYLkcLBtMTQPE8KIKUTt+Q+W7f4x/CbqAERctpAXfDVpsGh2X4kvOb+IEL21hmdov/f84DeRqOzsxJ2v3qQvIXEK1c0w2PTjlMsgk/ZAk00xc+RZ0f5qO8iFz0kcoeRhxXChVCNNNrv+KcRxpDKCAzb8oPUp6brvDVZdchUcGQTOx87qvMaVUFQodMDQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


--Nv7RrJjmbTmkdLju
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 13, 2026 at 02:43:16PM -0800, Andrew Morton wrote:

> The main issue is teaching it how to get reliable, high-bandwidth
> access to git and to mailing list archives - LLMs are often blocked for
> <reasons>.  For the mailing-list problem I gave it last-resort access
> to my local 100GB of email archives.  Gulp.  Dovecot's indexing helps a
> lot!

Konstantin has maintainer-containter which does a local lore and git
mirror in a container:

  https://git.kernel.org/pub/scm/utils/maintainer-container/maintainer-container.git

It's early days yet but of particular note here is that it has a MCP
interface.

--Nv7RrJjmbTmkdLju
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQReagvpf3TrrA7BoYYv73Ows9A4iQUCaveXDQAKCRAv73Ows9A4
iXnLAP9Y6nNY+wLgV+TwNUVGYCPbqtqb8GP+nUAiWl6CW6eEzgEAx/RWJknZapZy
kzNGR0pB0nFGmHqW3Kqp1r4hvliX4AM=
=clnb
-----END PGP SIGNATURE-----

--Nv7RrJjmbTmkdLju--

