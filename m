Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1B2DC5CFDB
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 14:34:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F34C6B06C2; Fri, 14 Aug 2026 10:34:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AB956B06C3; Fri, 14 Aug 2026 10:34:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B9F36B06C4; Fri, 14 Aug 2026 10:34:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 571B76B06C2
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 10:34:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CD556C016A
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 14:34:22 +0000 (UTC)
X-FDA: 85100120364.07.6CB68B7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 417468000A
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 14:34:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XFFyRI8M;
	spf=pass (imf30.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786718061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WnUIBmU3KRDn2nbquHueUxXwAiL4Yfqk4FNKfUeSxKw=;
	b=JS/yoF4p1UtXehBbeGnsBtNX0bAnSrZGhbjzVq5WzLo07mItlizwJH3ot7OsECxBHx6rDO
	VCOsj3dVKNH3yCXI+HDYbGQF9EurDSCojauLwU68gAwd/F1rrwbEabZ0yHQulVjlPIFCXJ
	Q+zjphwjt0eLv3Z5vjzVgik0esJPbLs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786718061;
	b=8RnBhozxrKbutVZkNULkyN5z87M+99pQDViIzRlGlgNpEY1xQH917hreKZ5MOatGXYJ04m
	BB4BfKgn/teXknA04K574upLEacCFb2zGSF+Uo97K3AJB1Gw47rXm7ui0EC731c28RYrDB
	3kLcgri084MpCVWfRDtkASHYFsQnLfE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XFFyRI8M;
	spf=pass (imf30.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B75D0600C3;
	Fri, 14 Aug 2026 14:34:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88A81F000E9;
	Fri, 14 Aug 2026 14:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786718060;
	bh=WnUIBmU3KRDn2nbquHueUxXwAiL4Yfqk4FNKfUeSxKw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XFFyRI8MGAIAcpPAoAInDOVPA/wHhF23IygPCfI0YmHvJmF/4hjn8aySLVksV+b0o
	 PzuIJbQi994J3Jej6AleO2PCYf8WOBu4+Bdfs5nv3SxzUEonxyx63Mx0rUM79DRQmG
	 gSFZ2CuuI6A3W6Mik7tI0wejnc3cV0GPAxWTd24oV2IsFOoAS54g8oWSAGogpdIwNE
	 GsJ3aluRWLI2fkBlrJn+wC9TYeslwjjbP9SxcAbUqfXOrK1QcUKE7EJBG4gzJnuWZX
	 ehuVv9kRFtflPxiw5wVFKZseH0+NnbHBs8RLr0+vxPiEYccedVzJiV/0d7s81j9TJI
	 5mRBU8XPzMp/w==
Date: Fri, 14 Aug 2026 15:34:15 +0100
From: Mark Brown <broonie@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Hajime Tazaki <thehajime@gmail.com>, linux-mm@kvack.org,
	geert@linux-m68k.org, daniel@thingy.jp,
	Shuah Khan <shuah@kernel.org>, Kees Cook <kees@kernel.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Will Drewry <wad@chromium.org>,
	Brendan Jackman <jackmanb@google.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	"Ricardo B. Marliere" <rbm@suse.com>,
	linux-kselftest@vger.kernel.org, linux-um@lists.infradead.org
Subject: Re: [RFC PATCH 5/6] selftests: run tests on nommu architecture
Message-ID: <4355a510-2e00-41f7-9bb3-8f6b2d95503b@sirena.org.uk>
References: <20260813063401.1786548-1-thehajime@gmail.com>
 <20260813063401.1786548-6-thehajime@gmail.com>
 <an8MlE22U3586R42@lucifer>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="p/oWFWIZW5lIg4+P"
Content-Disposition: inline
In-Reply-To: <an8MlE22U3586R42@lucifer>
X-Cookie: Body by Nautilus, Brain by Mattel.
X-Rspam-User: 
X-Stat-Signature: zh11m7q53hhtc5xu3yb5qdkysgwk9rf9
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 417468000A
X-HE-Tag: 1786718061-32185
X-HE-Meta: U2FsdGVkX1+wrv0snfwReFt2HYjXwFWXe8VfyxGdkO8oXrYSGZIwreMU3KSD8IsFr81O7JGRMsQytohb85bv6mNXRwiPuli5JBt9ryMGe0Crc1wMESrn+0WFmO3BawxsxHU1z5U5YT+IADSQkL9013diI0NZOCF0CUVBQFVf3j+7p3tjmupqY0W8tZtRg8Q5Z7ZqM9w61FA+pdt4XhIwLCmrbEqHwlC0DaA77VzWPf0YsawK4D2ZljpOWORtNSFrAGIClxj5ATqcNrHdJZiCKT03IFf7cNhPFresAphUy1xOZRH+9j0OQ/3cLhRwNacE69WXMvlLUrK9vBjivZ//h97KTdomO+el17D3aS+2hT3ibbAG5MfSAnKJVr+lbxzqJSdIli2WI2I4V2Oshsvci6TwagvtUOxdoCSt6NJhfczpfROTgZFw4W/Jjbf8vrlxn8Q2x/4ZV5LAVK4n1vTfZcPNj1jY0jgT/svogmS4XoF0H4S6V9yb2y/X18Q8sXJIXAPNf91rvLTw/cygrLif+B+BWU4/571Ttq8/awlO5mTt98HpijOW8MX7D4sfsNYX91akzl3pa669j9fwvR/ks78nafolNOy7WKEtuC3O2HehyHc1JcXmxc5NZKST6HGJtSoFiEvClhAyHaYuNqOg1j9ke/YhtE+yU4+PcaINBBzfewuN72pwLsoczy80jJ4Zt1rBYMa9jvOyFvjVKc/o4EVMhLx2eZXJ9E3/Gy3mMGmFVZb0fnPqn7H37FKnt0TnYKtwe0z+NnNAnyXFPrSOZR2IMWodHK9nFnN7aN9eGE1t0q0JmzcGcFcRpuGS/wXR6uO6EZy3U/owM5iuUBDlY/5NJPbKabC25CCkZiI2aJxWKhH1t4aUxeI62OaWPWCK49GI0InXYxhlFNQxdhhsRbBGJZyBaFIwRKjzJjYqX4HFF7u+FyfsinWFtj0gUe0lo6nZufW4hduaFKTMJnW
 s7xwi+ZO
 NAZllONBK/UaqoW/UVEdf/8QLcJO7Z2MZdBih/pNiag0GlFL5FZ5j7Tc8kPYmSclIOpX5mw/BkIGXAq8MN/4dyMFgit/HS9qh0cfaczrG0TVH77ECfooRDyNzezP2GC0706/q+INi8nmeGB2m3L5POvmhN8qDxMsYN2HMiMyZTGLXep3qoz4u7CgsZf49RRI6cDzmi55vAEmZP8WkPhbqXyps0Dqzek3AOoRJJRoUjlnXWt1RYa2TosnLQdZZaWMP/7jS2D6zbr2ghea2zhEam1W5kXvtHbCWkNSMpf0UQpoL58eU7/+PfFRcQa9S2T9+amL+Xd59ad2K3253UBQXL/gZbQb8z2Ko11so71urKXr80ziEim2eZnh+ZiyaIgcPrNfi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--p/oWFWIZW5lIg4+P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 14, 2026 at 01:50:50PM +0100, Lorenzo Stoakes (ARM) wrote:

> So at this point you're not really running much of the selftests at all,
> and are only happening to run those that don't do the very basic stuff
> nommu can't deal with.

> I think an audit of existing tests to figure out what works with nommu vs
> what doesn't is really unreasonable again, given nobody tests or seemingly
> uses these arches.

> So this patch might beget more nommu carve outs and exceptions and
> therefore nommu workload and maintenance, which isn't really sustainable.

> I know I complain about lack of testing on nommu, but at the same time I
> don't think running arbitrary tests that happen to work on it and who kno=
ws
> if they are valid asserts anyway really fixes things.

> And given nobody really is doing testing, it's not really a great RoI
> here...

Perhaps a good first step here is to start off with getting some public
CI set up, then build up to getting things running cleanly.  That way
there'll be visible ongoing coverage which will help motivate getting
whatever changes integrated, and if the changes are done bit by bit
there should be clearer explanations for why they make sense on nommu.

You could perhaps use a skiplist to ignore tests that don't work yet so
the CI starts off clean?

>=20
> ...OTOH I suppose it's a minimal change we can largely ignore as long as
> this doesn't lead to additional work/auditing from anybody but nommu
> enthusiasts.
>=20
> But I'm just not sure that will be the case :(
>=20
> (I'm amazed we support a mode in linux that can't fork() in 2026 :)
>=20
>=20
> > ---
> >  Documentation/dev-tools/kselftest.rst       | 12 ++++++++++++
> >  tools/testing/selftests/kselftest/runner.sh |  9 +++++++--
> >  tools/testing/selftests/kselftest_harness.h |  4 ++++
> >  tools/testing/selftests/lib.mk              |  8 ++++++++
> >  4 files changed, 31 insertions(+), 2 deletions(-)
> >
> > diff --git a/Documentation/dev-tools/kselftest.rst b/Documentation/dev-=
tools/kselftest.rst
> > index 64c0ec7428a2..800b2b688aff 100644
> > --- a/Documentation/dev-tools/kselftest.rst
> > +++ b/Documentation/dev-tools/kselftest.rst
> > @@ -230,6 +230,18 @@ section::
> >
> >  .. _tar's auto-compress: https://www.gnu.org/software/tar/manual/html_=
node/gzip.html#auto_002dcompress
> >
> > +Build and test on nommu target
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> > +
> > +If you (cross-)build kselftests for nommu targets, or run tests on nom=
mu targets, use
> > +``NOMMU=3D1`` as a make variable/environment setting to tell build sys=
tem to do the additional
> > +checks.  These nommu targets may differ in several ways, such as not s=
upporting fork(2) or
> > +using musl or another libc.  Set this variable to apply the necessary =
build and test adjustments.
> > +
> > +  $ make ARCH=3Dum NOMMU=3D1 O=3Dbuild kselftest
> > +  $ make ARCH=3Dum NOMMU=3D1 -C tools/testing/selftests/mm run_tests
> > +  $ NOMMU=3D1 /tmp/kselftest_install/run_kselftest.sh -s -c mm
> > +
> >  Contributing new tests
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > diff --git a/tools/testing/selftests/kselftest/runner.sh b/tools/testin=
g/selftests/kselftest/runner.sh
> > index 311811dc55a0..7287d8290b6c 100644
> > --- a/tools/testing/selftests/kselftest/runner.sh
> > +++ b/tools/testing/selftests/kselftest/runner.sh
> > @@ -38,8 +38,12 @@ tap_prefix()
> >
> >  tap_timeout()
> >  {
> > +	# nommu doesn't support timeout command (missing fork(2))
> > +	if [ "$NOMMU" =3D "1" ] ; then
> > +		echo "timeout isn't supported for nommu"
> > +		$1
> >  	# Make sure tests will time out if utility is available.
> > -	if [ -x /usr/bin/timeout ] ; then
> > +	elif [ -x /usr/bin/timeout ] ; then
> >  		/usr/bin/timeout --foreground "$kselftest_timeout" \
> >  			/usr/bin/timeout "$kselftest_timeout" $1
> >  	else
> > @@ -130,6 +134,7 @@ run_one()
> >  				return $KSFT_FAIL
> >  			fi
> >  		fi
> > +		OLDDIR=3D$(pwd)
> >  		cd `dirname $TEST` > /dev/null
> >  		(((( tap_timeout "$cmd" 2>&1; echo $? >&3) |
> >  			tap_prefix >&4) 3>&1) |
> > @@ -147,7 +152,7 @@ run_one()
> >  		*)
> >  			ktap_test_fail "$TEST_HDR_MSG # exit=3D$rc";;
> >  		esac
> > -		cd - >/dev/null
> > +		cd "$OLDDIR" >/dev/null
> >  	fi
> >
> >  	return $rc
> > diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testin=
g/selftests/kselftest_harness.h
> > index 261e4df94d9d..8eee7b14f824 100644
> > --- a/tools/testing/selftests/kselftest_harness.h
> > +++ b/tools/testing/selftests/kselftest_harness.h
> > @@ -1274,6 +1274,10 @@ static int test_harness_run(int argc, char **arg=
v)
> >  	unsigned int count =3D 0;
> >  	unsigned int pass_count =3D 0;
> >
> > +#ifdef CONFIG_NOMMU
> > +	ksft_print_msg("harness test doesn't support on NOMMU architecture (n=
o fork(2)).\n");
> > +	return KSFT_SKIP;
> > +#endif /* CONFIG_NOMMU */
> >  	ret =3D test_harness_argv_check(argc, argv);
> >  	if (ret !=3D KSFT_PASS)
> >  		return ret;
> > diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/l=
ib.mk
> > index 2cc819006424..4734b5ce613f 100644
> > --- a/tools/testing/selftests/lib.mk
> > +++ b/tools/testing/selftests/lib.mk
> > @@ -97,6 +97,14 @@ TEST_GEN_PROGS :=3D $(patsubst %,$(OUTPUT)/%,$(TEST_=
GEN_PROGS))
> >  TEST_GEN_PROGS_EXTENDED :=3D $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_PROGS=
_EXTENDED))
> >  TEST_GEN_FILES :=3D $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_FILES))
> >
> > +# detect if users request NOMMU build or not
> > +# User can set NOMMU to 1 to build/test for NOMMU platforms
> > +NOMMU ?=3D 0
> > +ifeq ($(NOMMU),1)
> > +CFLAGS +=3D -DCONFIG_NOMMU
> > +export NOMMU
> > +endif
> > +
> >  all: $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES) \
> >  	$(if $(TEST_GEN_MODS_DIR),gen_mods_dir)
> >
> > --
> > 2.43.0
> >
>=20
> --
> Cheers, Lorenzo

--p/oWFWIZW5lIg4+P
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmp/J2YACgkQJNaLcl1U
h9BXcAf/UqWczLxiNOc/Hmk71YZaKMzdL3pklWPu2E6Huj9UoT5KdXtKzHCnqcjs
bulah3Acd+ap+Xv0VTQ0HQuRbsJnyg/LsIm+xBAvllafk8FXZLWBajhZvmRsb6OG
pWx/5Udoc45FuL0kXPIKn4IaweB4qQwFBCw7WqopDEkidW5mBveiFblf5lqbwWPN
U502huc+u7ShUQfKX4M5axSWBTER0HYNQuyROAQMw3BYpARu6YOS16nng5h5adoQ
zCGgx/XFAMcgHrJZVDlSDqpgDO1FTFYF3h4ROppqt2nYfP8XsnrNKZ2L9BJRotgi
ttU2bzsTTwccgRjbgI+Z6HGG6OH12w==
=4XkF
-----END PGP SIGNATURE-----

--p/oWFWIZW5lIg4+P--

