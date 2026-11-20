Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CF25606A697
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 22:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VS5VVo7j
Received: by kanga.kvack.org (Postfix)
	id 1A1196B05B7; Fri, 20 Nov 2026 17:45:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14FEB6B05B8; Fri, 20 Nov 2026 17:45:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE44D6B05B9; Fri, 20 Nov 2026 17:45:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD9506B05B7
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:45:00 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2294A160202
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:45:00 +0000 (UTC)
X-FDA: 85456979160.10.28FD6FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8275120004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:44:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VS5VVo7j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795214698;
	b=ncpldFpXluqrbitqJNYkL+Gw7B10fRbzd0f/eiKmBlJm3tFcWUtEyPon1h+1NRLL7iBxw3
	YCRlqN8viEpRsl5uF8Oj5hcSG0sRDT8ipksC0yVPSUyUmBxqynnw7XbB/5+ureBpuEOckG
	mQW9zYCRkkE45U1W64R4p+Y3xSGYPOA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795214698;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p2Lf6qpcYVJhQ5+q/779aR/iL3yLTW5qgQJ75weSGn4=;
	b=Dbvm4sONu7kMnJB4JBImMda2HzgBj2W4kOC69cFUe8Y0NOkoPbQgOmMUdeL07eMzUsS5NC
	6zwAY1lNMsJKNCzay1wJEiriVPmFCYusUBCRdVRfWLXkx9eeWffguN7R+mzy38dYoZqeSi
	UTZiilmUMJ00Wi+BZatZvo3CwnVja6U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VS5VVo7j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D94B060A51;
	Fri, 20 Nov 2026 22:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D168D1F000E0;
	Fri, 20 Nov 2026 22:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795214697;
	bh=p2Lf6qpcYVJhQ5+q/779aR/iL3yLTW5qgQJ75weSGn4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VS5VVo7jR8o9HFGRVBMaebXWwvuWWI8YlUW/45Fk+GzxPhR5b82izYDOtFYH74FD4
	 FkZtvDm5bTTPH1SyT+RSOm8jKHjtbdUmYWtBlCMGw4La2B3p1phgsBE4IW6yM9E2kv
	 lqjxol/m+d7i9nSgiQBtoklLVYGFMrdxr9HiIQXEPW8HXqkbEmmJWKtu8Avuu4nkZz
	 eJWeN1lEqr5xxU+JwV78FwX9nlLAaTRnEy3gP+htbeWSa3b/Vzfn+3ALeMpuMnN0R5
	 uRP+RCU2x26NhQtg/3FHhW5NOh1eb50DR3FJem32SfLytVRCzBMlAEVWzwF2iPwFXM
	 OszCw/wOYPplQ==
Message-ID: <sashiko-outbox-226305@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v4 13/14] selftests/rootns: Add root namespace test
 suite
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org, "Albert Ou" <aou@eecs.berkeley.edu>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Alexandre
 Ghiti" <alex@ghiti.fr>, "Andreas Larsson" <andreas@gaisler.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Andy Lutomirski" <luto@amacapital.net>, "Andy
 Lutomirski" <luto@kernel.org>, "Anna-Maria Behnsen" <anna-maria@linutronix.de>, "Arnd
 Bergmann" <arnd@arndb.de>, "Ben Segall" <bsegall@google.com>, "Borislav
 Petkov" <bp@alien8.de>, "Casey Schaufler" <casey@schaufler-ca.com>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Christian
 Brauner" <brauner@kernel.org>, =?utf-8?b?Q2hyaXN0b3BoZSBMZXJveSAoQ1Mg?=
 =?utf-8?b?R1JPVVAp?= <chleroy@kernel.org>, "Chris Zankel" <chris@zankel.net>, "Dave
 Hansen" <dave.hansen@linux.intel.com>, "David Hildenbrand" <david@kernel.org>, "David
 Howells" <dhowells@redhat.com>, "Davidlohr Bueso" <dave@stgolabs.net>, "David
 S. Miller" <davem@davemloft.net>, "Dietmar Eggemann" <dietmar.eggemann@arm.com>, "Frederic
 Weisbecker" <frederic@kernel.org>, "Geert Uytterhoeven" <geert@linux-m68k.org>, "Hallgrimur
 H. Gunnarsson" <halg@google.com>, "Heiko Carstens" <hca@linux.ibm.com>, "Helge
 Deller" <deller@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@redhat.com>, "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Jan Kara" <jack@suse.cz>, "John
 Johansen" <john.johansen@canonical.com>, "John Paul Adrian Glaubitz" <glaubitz@physik.fu-berlin.de>, "Jonathan
 Corbet" <corbet@lwn.net>, "Josef Bacik" <josef@toxicpanda.com>, "Juri Lelli" <juri.lelli@redhat.com>, "Kees
 Cook" <kees@kernel.org>, "K Prateek Nayak" <kprateek.nayak@amd.com>, "Liam
 R. Howlett" <liam@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Madhavan
 Srinivasan" <maddy@linux.ibm.com>, "Magnus Lindholm" <linmag7@gmail.com>, "Manfred
 Spraul" <manfred@colorfullife.com>, "Mark Rutland" <mark.rutland@arm.com>, "Matt
 Turner" <mattst88@gmail.com>, "Max Filippov" <jcmvbkbc@gmail.com>, "Mel
 Gorman" <mgorman@suse.de>, "Michael Ellerman" <mpe@ellerman.id.au>, "Michal
 Hocko" <mhocko@suse.com>, "Michal Simek" <monstr@monstr.eu>, "Mike Rapoport" <rppt@kernel.org>, "Neal
 Gompa" <neal@gompa.dev>, "Nicholas Piggin" <npiggin@gmail.com>, "Palmer
 Dabbelt" <palmer@dabbelt.com>, "Paul Moore" <paul@paul-moore.com>, "Paul
 Walmsley" <pjw@kernel.org>, "Pavel Tikhomirov" <ptikhomirov@virtuozzo.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Richard
 Henderson" <richard.henderson@linaro.org>, "Rich Felker" <dalias@libc.org>,
 =?utf-8?b?Uml0ZXNoIEhhcmphbmkgKElCTSk=?= <ritesh.list@gmail.com>, "Russell
 King" <linux@armlinux.org.uk>, "Serge Hallyn" <sergeh@kernel.org>, "Shrikanth
 Hegde" <sshegde@linux.ibm.com>, "Shuah Khan" <skhan@linuxfoundation.org>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Suren Baghdasaryan" <surenb@google.com>, "Sven
 Schnelle" <svens@linux.ibm.com>, "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>, "Thomas
 Gleixner" <tglx@kernel.org>, "Valentin Schneider" <vschneid@redhat.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Vincent Guittot" <vincent.guittot@linaro.org>, "Vincenzo
 Frascino" <vincenzo.frascino@arm.com>, "Vlastimil Babka" <vbabka@kernel.org>, "Will
 Deacon" <will@kernel.org>, "Yoshinori Sato" <ysato@users.sourceforge.jp>, "Zygmunt
 Krynicki" <zygmunt.krynicki@canonical.com>
In-Reply-To: <20261119224312.1037966-14-jarkko@kernel.org>
References: <20261119224312.1037966-1-jarkko@kernel.org>
 <20261119224312.1037966-14-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 22:44:52 +0000
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8275120004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: aa4xc79qwtb91gpk17zbrw764z717cdn
X-HE-Tag: 1795214698-128806
X-HE-Meta: U2FsdGVkX19KMctsi21SdRR3E1Ybm5tgo0FsfVK1VRE2xgpXKfBbvYgWQ0TSGcSorSIXga2Qbe568XfNcw3trWOnpPEh5CsIUQSzynLZ+OZuM5wSTjHauKOeVMFX7MxFsb7ivU2Plfg+vKlO5rldfurfvjig+RpZxMphEYDQSUrZoMiALHoM2G/k3jAo9mTNbd0h5VWMPC9QgD1rWJaZVM+en/pF3k14YPa+3DW+u/9vLUelr5BhuMBtSwbtCZY79REkXv3xPwvPmw2kll/r7copuYGHnv99A+wjXnJijDAPHNnueNep1UUZSHaf3CC0pNoKF89I7iHNa8x1ZrksjrSyJ+UYgfLS4drGGxgf8aDWwo9IDtegyaymCw/rpFHEFEjce1Pwga1Fuq6Tm7NSXOH5PXzZ4DL4LFrPkaGoQJxpxc6iRpKFs85utqY35eNhIcVjb2+PG0bLwW4HYyZqwgeVyjnlDMIHoM+SPrN+nHNcHofgcRoRHrIbi8IWmdPWaBFVr8RpBWX+7gP5uypzcnV+Z20PsBgqKqUCnIsZd/W7mN/5xBi08HpymZLutHzF7FVStKuGDedGxOpGJ3eDcaKtjYnlBR14/0ULjtg0wG2Rnfu0ewkLrGxZUUOF5G6/JWSRMkhJ1CFa4ZBZtf2mifJoX7MvJ7zO9wJyke+b2DesQ9PU4Q6bewOPiogcIs5oWoSz/vp7Y0X1Ul7gPK40qfvsBfRoybAO1Gg7bBKffaxdrnu6wiEFtOMttnOAdQFhWeIiXdeBFLigZl8q+oKaLEQbuYq13Yjb/RBKPoBDvz6qBJM4sLhdFBSz8bLh0hIr2XgtIZJf1UvOfSknXw6eoy33n8jurNqdoEpXeiq+U8Zn5U5f+QWPoDOG6Q8aPVcPRBjp7zIEm6Gmt4HBCipbxwCJ8UTXUfmmuWAsmRussUP9vtMh0xjkGCNT7pv0PiW31SYIY/XbPFqwBXeJQkN
 UbW4WUoj
 IzME03KhGmsY32ylsV54hgKvyALJyRLtKa2JLkhx2a6VV3v6Lfq7/0G5Cbc3z4PIqQUBKG7kWeYdEt59hmIBOZmFRGMDnA+E5SlW5+soN6gjVs2iAzOn3D++G9NU83ZqR5Is1PmHgjKg4pyfAR6sOlOLff8e51u7s546E4QWaB3LcJUzv9rLpHh1GO9ww6loa58RzXDoVFhi7sAlV1M7HeAB4xlCqRcO2fGw22EnwebtPpp3fTNX9/2B3MrUvkDic1xV5MmZWWh6BbSBcS4+VkHDfNuUYZfRRMW3H75KYraeUOPnl/7HaWmcTyx7xB36TT04plcD3zRI8aEIJZqfPhWGuhoQq+ytN1xrbn4mrpPPTUWudJ5nG6C7mfMm9S8CqGF3eHwwsnx5DtYvDNbyiq5/cGyOSwrudT5wFASlF3SgXsM1cCJ+GSBVa9/UedIO/ECz7tf+YRjIOUNe4YcQjKevlBExrmPew/ax86olpGRo1l2zqEfAt+G+yY6yoaU/lN1QM2ARrwnr3ul98ixKLd3Tnug8LrbugDa0SIWDrG4R27pOKpgpeXiwfwvZ/rrxA8gZLtISEZ024rJhO0l3FpQIyxDC4RUYdbccD7GLb54dZiXASOg8bvxCK0+Ra+CdYV1cZxP5T8i9m+2A5fesVjoKD6NYh9etiqLVU0LL6MaC2h5vBv4YQXoGBYaba+GnSKbSZZEfHWiXAYdERlVCtWZou+7e3MKkvEbNvm7PHNhV8Ksmw28WHY/IxYbupttbrH1DGXTpcdicdPLjKXuS9xNnU9+dZZaIoa1b4SYAcRpqzIMiXXlKyrqW8OPMMSFoxRI1MY70VT1Z78RT/bC1EryJbpssGHqHCm7ZvJBN4FpD86pcE6Bqy6eXO8VB2mAyd6lFcI2I1N6EYxMu0aF/YUkyu0jqTNJ/h7oGyNiF+gfwgqu8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] selftests/rootns: wrong _IOC_NONE direction in _io() on
  wide-ioc archs
- [Low] selftests/rootns: non-blocking accepted socket in
  CellService._on_accept()
- [Low] selftests/rootns: resource leaks on Cell init and test setUp()
  failures
--

commit 646cdbb1cf35062e2a914f151927bb968fe747a7
Author: Jarkko Sakkinen <jarkko@kernel.org>

selftests/rootns: Add root namespace test suite

This commit adds a kselftest suite for the rootns and mount-namespace
configuration uAPI, covering privileged, unprivileged, and edge-case
scenarios.

> diff --git a/tools/testing/selftests/rootns/rootns_cells.py b/tools/testi=
ng/selftests/rootns/rootns_cells.py
> new file mode 100755
> index 0000000000000..b690ed71a5211
> --- /dev/null
> +++ b/tools/testing/selftests/rootns/rootns_cells.py

[ ... ]

> +def _io(magic: int, nr: int) -> int:
> +    return _ioc(0, magic, nr, 0)
> +
> +
> +def _iowr(magic: int, nr: int, size: int) -> int:
> +    rw =3D 6 if _is_wide_ioc_arch() else 3
> +    return _ioc(rw, magic, nr, size)

[Severity: Medium]
Should _io() pass direction 1 instead of 0 when _is_wide_ioc_arch() is
True?

On PowerPC, SPARC, Alpha, and MIPS, _IOC_NONE is 1U rather than 0U, so
_IO() sets bit 29.  Passing 0 encodes the wrong ioctl numbers for
ROOTNS_GET_NSFD, ROOTNS_KILL, and NS_GET_*, causing the kernel to reject
them with ENOTTY.

[ ... ]

> +@dataclass
> +class Cell:
> +    name: str
> +    flags: int =3D ROOTNS_KILL_ON_CLOSE | ROOTNS_CLOSE_ON_EXEC
> +    cfd: int =3D field(init=3DFalse, default=3D-1)
> +    mntns_fd: int =3D field(init=3DFalse, default=3D-1)
> +    root_dfd: int =3D field(init=3DFalse, default=3D-1)
> +    init_pid: int | None =3D field(init=3DFalse, default=3DNone)
> +    exit_status: int | None =3D field(init=3DFalse, default=3DNone)
> +
> +    def __post_init__(self) -> None:
> +        self.cfd =3D rootns(self.flags)
> +        self.mntns_fd =3D rootns_get_nsfd(self.cfd, CLONE_NEWNS)

[Severity: Low]
Does Cell.__post_init__() leak self.cfd and the namespaces it pins if
rootns_get_nsfd() raises OSError?

Similarly, in rootns_test.py, unittest does not run tearDown() when
setUp() fails or raises an exception, so CellServiceTest.setUp() leaks
self.daemon_pid and self.tmpdir if the daemon readiness loop calls
self.fail(), and RootnsUapiTest.setUp() leaks self.cell's file descriptors
if setup_rootfs() fails.

[ ... ]

> +class CellService:
> +    def __init__(self, sock_path: str) -> None:

[ ... ]

> +        self.srv.setblocking(False)
> +        self.sel.register(self.srv, selectors.EVENT_READ, self._on_accep=
t)

[ ... ]

> +    def _on_accept(self) -> None:
> +        conn, _ =3D self.srv.accept()
> +        with conn:
> +            data =3D b""
> +            while not data.endswith(b"\n"):
> +                chunk =3D conn.recv(4096)
> +                if not chunk:
> +                    break
> +                data +=3D chunk

[Severity: Low]
Can conn.recv(4096) raise an uncaught BlockingIOError here?

In Python, socket.accept() on a non-blocking listening socket returns a
non-blocking client socket.  If _on_accept() runs after connect() wakes the
listening socket but before the client sends its request line, conn.recv()
fails with EAGAIN and crashes serve_forever() unless conn.setblocking(True)
is called first.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119224312.1037=
966-1-jarkko@kernel.org?part=3D13

