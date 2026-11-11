Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8101606A326
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 16:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MXRFtoMu
Received: by kanga.kvack.org (Postfix)
	id CAF766B05B3; Wed, 11 Nov 2026 11:15:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C866B6B05B4; Wed, 11 Nov 2026 11:15:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9CA96B05B5; Wed, 11 Nov 2026 11:15:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 931ED6B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:15:43 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 84E0280357
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:15:41 +0000 (UTC)
X-FDA: 85423338882.25.F202701
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id CEE831C0005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:15:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MXRFtoMu;
	spf=pass (imf20.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794413740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6VIZ3PtCdrmMEOv2W4/v/h0FEesRkpl7sdLewNtxWW4=;
	b=ARrdEo70OCz3Ww6sRzeTXHBTTjFTCDRkthZM2GyzGhLfWskenwa85UUZWAv/qLM9spdbDG
	/N22CRoHiQMMWJ+/kb9Ypp8SxbQhYGuly1PMQwM/O5v+lTEoP3PTZO5C2EEpOgae4bdvUr
	QBanfRztD5y47sG0eQayWrgP7EXOzsE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794413740;
	b=c7VvppvSVz4NQfGIhnNg5qppmR5iFgjyhbR2NZjtzjM796aN1eZAjBtf4KV6LFF/dHlLrE
	1HvkW0IKEapXrk26ma1jSojAcOz62qs7ijGiL0fmAAN3/O9tV6gUsshP0qgyaNIWXQkXmM
	rgRR+pJKV8URSuJvGJ8ARRgue2n5aYA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MXRFtoMu;
	spf=pass (imf20.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DBAC863E0D;
	Wed, 11 Nov 2026 16:15:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE261F00A05;
	Wed, 11 Nov 2026 16:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794413738;
	bh=6VIZ3PtCdrmMEOv2W4/v/h0FEesRkpl7sdLewNtxWW4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MXRFtoMupiT3qJYgXy2sB5augkLgLy01qRPMNW45hSF9TkcmcmWYGEuV1Vz8rWyW6
	 0ooJ3PmsQeytlwlshiRdctOVUiFAzHmpWyxKu9nbUHJdynm5l0dpxSF3+fMGPvTAtl
	 h5Wrl2+XF/DcnC0+tpUiX1ybjfuL2oM7cFwCwZpi+3ORaDY+l4Ad0P+yIjIazHFrIA
	 YKx6+GKltenDm8orj9uCHBo4Wv2y5lbssOY/NWJ+aLstSRAD6AtSBoYHk9V08IH3J8
	 /HJ0P69c8aNYZzrVMV0lGp4+KJ7N/z8bUp+urrmmHsLr3Ll0KkVI476EDVM0DHH0/9
	 +L8aD2xMGC3+A==
Date: Wed, 11 Nov 2026 16:15:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-hardening@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Ard Biesheuvel <ardb+git@google.com>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	=?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
Subject: Re: [PATCH RFC v10 22/22] mm: Add basic tests for
 kpkeys_hardened_pgtables
Message-ID: <9deffbb1-75fd-407e-90cc-59bf4c2fa1a6@sirena.org.uk>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-22-aa6c4d9603bc@arm.com>
 <2d13fbb7-b5b4-446e-8709-5b43349ff19a@sirena.org.uk>
 <9e59fd71-97e7-422c-a7dd-bc23c6e6a852@arm.com>
 <717cccfe-81d6-4e09-a466-5361ae27776f@sirena.org.uk>
 <0b29393f-bb84-4df1-a699-f7afcb50f2e8@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="OedQK9JKFipfKU6l"
Content-Disposition: inline
In-Reply-To: <0b29393f-bb84-4df1-a699-f7afcb50f2e8@arm.com>
X-Cookie: Do not pick the flowers.
X-Stat-Signature: mpeysdhegxp9xqrihpw5sxr9xytud5g4
X-Rspamd-Queue-Id: CEE831C0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794413739-126556
X-HE-Meta: U2FsdGVkX181rezU1GW3xNsB71i0vaeeuipq7OPZhP6XiynwaYBv3p1xZPaaHtzU4c4z/9wvjM9cH61z39BdkRh7QKzjgKh0vUJ/bFSdZqaO46/uBB9l+ox+IN5ZP5Dz3MjK7zlXcyQU76QH3UQTuVdjsJDeHUBAna2VgzH3F/srN7mZU6kvRsFRVdKO+NX5qfxH9WrlOCuZk09U5n5YAASmgmcbu1Nd9rXQdLdtY0RDZgCeCiRMFfZ3XY6mSjsNl8uHxQZ616PUOvWZbLPKp/1L9+z7T1YuyRHTX9aE+bBDMRjyi7slGUyS+yZDHBVF4HIpyBwdDoJB+eLlnZtC4Cps67B+6B58VPa2Z5R1LFVZ/U1uUT3GtO46Xs0UHNzB0ha0oJjnLyW26D9ILu5I0ImcHz8NQeha1v6yNEGHaZGOmCX7UTX7VleJVB3f34hu8cs1arKvrU3ji0nnPWu964HGANJkd/acPTsLxo5fb7PwpYXfqAFGf+hBg0VkBkOP042N9n0A5epkYi0AAR5BN6ISYYSfP7l/JrV6OLnQjrYSD/lnl8Wss9Q+z0HaiKi7y+H7hmFKNt/QNDMr2N4JnwsdoHkTyf+1/dJolu6xhfKZCx2m062kbyYIu+JIQ3vU8oDo0w+IdjR1X2nwTgZ/tSH8C/I71Oo8gWTqOcTute1gNh3kbtgmhFymj7g1bLE3gQxfdIR6zk4eeWJBXwXSsWVGayo1N6xsyJcEqTQ2IZRalu8azEvUjXdlrsCEwFtioascMvBq09b+JC8qrbiLx0MkxOMQKjNGCeKeD6vFzwAoxZVsb2etv/QA2m1IgcaFNBw+07DBHl72D7H56zAPaJryLmmn40d88YCHwes1xYBzp+jZC0yS3RZoIYqgehgClZoOlIzaoy/L7L8krc6oSiitK8H2CDuJYfcyxlJadbV8NsgfynNxzLtFomDTkJHak6Wzu3/+5AVY6u8n4AL
 O/dvqWCP
 CgCA45MwyT90WB3g90IxpYVLsZNNti+r2veAYgvljcmWzKy1mudgGt+fUkTIz4zkCnXyivOHK7zKz9N/njsqclsOL+Coy6FreQyCxwSrnprlkrbnHa3dtJBlAaG6083FdEhCkhK7C/SJfwx8EDsoLwrXZybdQvsqq0/ZacZyJoq1YEJxMzKAV95Jv8s52Y9+urhK9wjqD80fg/BMD0u3ACvSXIqQP1/7ji75hfVb3vkSHa7QCxIqqsI5IbtPDPMjAlKRGuYVaLk84HuzuUWp5e67QFpLrFNDnFXRxt4+bzlciZbl2twU0KutPM0SAetiULOOnXb8TaD1mpZIu6O1PlMDNJR5aUn4XI1C3Tji7e3UTJcD5XJgUUfxGMFvG540DobRTSWpmgpG8cPPfRpxchrx+YTB/w+uRzWrKwliuysmv4ZgzbLNLIPugdxF6jMqkvNCXDsZJkmFFJuMqHaiUINvrBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


--OedQK9JKFipfKU6l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 11, 2026 at 04:29:02PM +0100, Kevin Brodsky wrote:
> On 10/11/2026 12:24, Mark Brown wrote:
> > On Tue, Nov 10, 2026 at 10:01:36AM +0100, Kevin Brodsky wrote:

> >> Do you mean adding the dependency KPKEYS_HARDENED_PGTABLES=y to

> > Yes, or something like that - unfortunately KUnit checks to see if the
> > config options appear in the configuration so something that vanishes on
> > other architectures causes issues.

> Alright, I guess there's not much we can do then, short of creating
> arch-specific fragments.

Or my suggestion below, or come up with some generic option that could
always be there and would in turn select hardening things.  There's
probably a case for having something given that the hardening features
will tend to catch some kinds of test error but that feels more config
fragment like.  Another idea would be to teach KUnit about the idea that
it should try turning on some config options but not worry if they're
not selected.

> > Perhaps the default for the config
> > option ought to depend on KUNIT_ALL_TESTS?

> Not sure I'm following, the config already has default KUNIT_ALL_TESTS?

The config for the test does, but KPKEYS_HARDENED_PGTABLES which the
test depends on does not so unless the underlying defconfig turns that
on the test won't be enabled.  I was suggesting also adding a default
for testing.

--OedQK9JKFipfKU6l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmr0lJ8ACgkQJNaLcl1U
h9Dq7gf/ZN2+f02DNQ9bdbwTMYXtyyu+7wCmjXUlHCsNgO5GlbWut9+uS4GmuCc9
WunBOQc+J/oUb1xLrMkgaxOW8h2KAztK6MPg8BzPufhwZctxuJ0HsBbUgTgnmHpc
uoZtu7URTziUz+kLkGEIB4+6a34aEQiW4SYdu5Z22jWqmT4vxb9JIQDA0e5V/Roc
hg2/qulDP5GDSotg3oHcwqqbXrxt4zvb6Z2fKdAZUJz3zc8gon/WHyqUXgJHRVOn
bFcpqtPEyz0j7rRAyFagwJ42Sq2SRDsU/qjaHb8Hne1OK9cK0DSMMlCJ3Lf/+sx3
Dk0E+Do8vqDs8wBZ0lCJuKqAtRjyng==
=+B7J
-----END PGP SIGNATURE-----

--OedQK9JKFipfKU6l--

