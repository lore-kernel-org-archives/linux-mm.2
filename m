Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDFB4606A32A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 02:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FeZXY1bn
Received: by kanga.kvack.org (Postfix)
	id 750686B05C1; Sat, 21 Nov 2026 21:14:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 728116B05C2; Sat, 21 Nov 2026 21:14:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63E656B05C3; Sat, 21 Nov 2026 21:14:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F7DB6B05C1
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:14:23 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 82CAC1C277D
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:14:22 +0000 (UTC)
X-FDA: 85461135564.11.FC5D8F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id D90A5A0005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:14:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FeZXY1bn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795313661;
	b=GNk7y3kl9PiQrFMDCB/wGSdAiI8SdUGwYrN0/rkVOnHG0zh0lYi0CMopPwxdr7vJh+AEri
	Upbz7eXxCamPH/oadm97b3MFsLfCF5boRTNtuMLbUX2kI34Lbttm3E1lGCextLzxiQNlOV
	M9J00pZzE9VZrFEcPkVUytK4r5xIPfo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795313661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h5VA1YE3lZnMuc4pgcwx05FrLM8HqoJ1Sdgg4XfYCTc=;
	b=1KzPU3Wdx+CETLyc8fAamPl8lopxZrjQzVgiGtqLA7ktRSoucyrdphD2UL7jhqC3FG/PNy
	tcrtw+iiQy0seJT8H+JxhwpGt9Y9ysrlh8STH8coqyEbgy83Rpar4fB+6mgD/iVrFGMwaJ
	vgCWucjk+aSA/yzmwP/H8THb5KGB5Q4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FeZXY1bn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1DC6345911;
	Sun, 22 Nov 2026 02:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585771F000CA;
	Sun, 22 Nov 2026 02:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795313660;
	bh=h5VA1YE3lZnMuc4pgcwx05FrLM8HqoJ1Sdgg4XfYCTc=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=FeZXY1bnXRjfWfDhdd9xvxA2C1PvOyxAVG/K78D8Kl9qL79GS5Qc997rcaK+Aa0DZ
	 jl7mxVscPW7m/j4p3AR8o7Pgfv7EdqDS7MMMUdCmSkdniwuxKXU0nZ1MvJtABdS0To
	 MGbUtZ0CeNa6NIJe+6hVKxEcz0iQdZ5UtGu4oMb0/TY1/v48944cY4nucneJ6g6kNI
	 rwBf2H2sqlK4Eqycd2/wLe9kB2+F3DlVJHlbuudR+Wj4FMYMVYloWJ2vmPZtPUaCsz
	 JYGGcRSqFRIHgjga3nhOPl0vDkmiDNg/9CgrfDzA44h72yk+os9ZejeY4N1M/xJOfN
	 H4vWAxohEgGEA==
Content-Type: multipart/mixed; boundary="===============3579480507848251298=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <a20bfb0569b8af98b16097472118dd35c85fc9c1e258860871b01bfa9c6c9384@mail.kernel.org>
In-Reply-To: <20261122011809.2667684-26-jarkko@kernel.org>
References: <20261122011809.2667684-26-jarkko@kernel.org>
Subject: Re: [RFC PATCH v6 25/26] selftests/userland: Add userland test suite
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 02:14:16 +0000 (UTC)
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D90A5A0005
X-Stat-Signature: 4oz89ms6uue6rkowe4ja9wf88633x5dw
X-HE-Tag: 1795313660-517150
X-HE-Meta: U2FsdGVkX18X2rRaueOFuot+KRawXefpjtAgDU13yojow5UIxYxKqGMbXMJDo86Fb6B4R97eVlQ3DKN0frBHqmn/KCX7uta1aVPZR7/QxcMjMa5aUqAlTAWeWNsjRZliuTflI4MfpxVcUJzD3YJy928eeIQDK1UC6r+gFVmOJ1bjR6SJFC5SzgiemydG95r8XXJzH1BTezUGXW9uTk9/8Jr6FBAszTqX+t4ZJ/vI05rCs5nAmxIh8n6rbH5eOiTKF8tU2zuB2fRCM3/GTuVC7x8X64/Qr+nn+YJBwUTQNRNbWLsQ1rKJE2HCg5k6pQ/gRiX/Qw/Dujg1vA7CWj/sPetztOQQ+zhcTpjttg0w+ceQICOfAqles5Qfpv4UCOL7bEabN+IX57RqHnIy8+1t9cFDDsCL1TS5iXptP6n5AksFOhMAIh8HGN8l7miGAyheTaQr+y0BZI2UxoCkGcHFXg0MwdxCi38Qm+OxHN/d320Kh8dXidGQTsuhvUg/F4NtPOSWyyKwgOB96o1HesSujEIwki/hVSLK8G7eUyfzXsh8DW4hzKZANchOxy0tJmRQT14SEqcHOtWWZ7i8Pa3h9aPF0I3TF13OeVs2VJO/kQxX8CVuheQo6XO2PEl3eYUikHbbI1qALNbuUZoDAZKPJ3qMsqDgJB7QOZCoEneQg3jXq3r7rFkngwuWE1ManPhwvFWaeIG2HXtDUE2NUWy/v7VqTWlmsVAkdgxdw9KtjuKFw/Zr0LWiA68LA3cMTY2VT04DC1JgTmLbfAap/EHpJNqh0koTlwrHm52XeZj98LfW/So5IRHH52/tRK/8Df1egr9xD14uQQBnoWpHCbI/UbS8eO/+DT6s+P5BZD3lsVvj+tk93Npu8yRC+lCKQsFyN0YmBj68sEpgODMV8lchRKfL7TdTpuvuLazkovGUQpaG5aDquAUSNhmhQIJvMojv7qANUnx+4LEeiMWUmYt
 vAmkJbDN
 MM1R0019WtA6kjaN/Qs6CqnfkqQffdZT2/aoBdvhY14CT0JogNo0DNMrHg1/nxYRYuESTGsBQhJviFxHvT6QE9LrcAo4fUr5Vk0HYbqrv+1Ht2WnbqfflGoFfM5la0te1qCcAXKDwfHcVSm2LVajt766CU+BYyn0GqiEfE/GwhEFfA8NT8LUGxeaItQReD3VD9Mb4FWnma9SEc1uJLdBVh2yIKZYNIIPB2UrqkA3UsevYbRRPlH6b+gXetWWbsOEks/cHei32MCAZvf7HF1DJHBLD2/+mKZjUE0NTtSXFmC5JpNv5TnxvsNJU7ir8oT/fmwiILVAXrir7n7XwB/plenOerCPAhOXbADfDjvuXx4p7V+JpW86VLISXQK1P+ME74XTmu0RfkRtmJ4+iFFYRwJCUdLwVR8Izd65CCTvXhUX3K7cG9+nrq12urkrQOyZHHVClg0ftwOhkJ2eJgeKJSI90qp92fsZvT1qVCHHhgQwZGdTWAKGPHQ+nm4ncSBpEcbtbFT+6iahHVb3mx0qGEYvRxXG6NzA3YHiYM0+xUjNtHRmLA0swOCnJHDSIB09mrb26TXa8yWmthWWaM3o3Z6v+0woDBcFlVXpD5MEjgEmd6sQukb7CZQWcZYk+fNCWVIED0L1pkEX6p4P8kcMpA+MGs5ou4X6YlK4jEZILIRezezOFdhdjm9Uisw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============3579480507848251298==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> selftests/userland: Add userland test suite

TL;DR:
- Selftest may fail on out-of-tree builds: ksft.py helper isn't installed
  (TEST_INCLUDES)
- Plain i386 userspace on x86_64 may get x32 syscall numbers and wrongly skip
- Time-namespace case may fail without TIME_NS; a socket recv may hang on
  failure

> diff --git a/tools/testing/selftests/userland/Makefile b/tools/testing/selftests/userland/Makefile
> new file mode 100644
> index 000000000000..baf26c6780bb
> --- /dev/null
> +++ b/tools/testing/selftests/userland/Makefile
> @@ -0,0 +1,5 @@
> +# SPDX-License-Identifier: GPL-2.0
> +include ../lib.mk
> +
> +TEST_PROGS := test_smoke.sh
> +TEST_FILES := userland_cells.py userland_test.py

Will this suite run under an out-of-tree build such as
"make O=/tmp/kselftest kselftest"?

With O= set, the run_tests recipe in lib.mk copies only $(TEST_PROGS) and
$(TEST_FILES) into $(OUTPUT), and INSTALL_INCLUDES copies nothing because
TEST_INCLUDES is not set.

test_smoke.sh then execs userland_test.py from the copied location, and
KtapRunner._load_ksft() looks for the helper relative to that file:

    ksft_dir = str(Path(__file__).resolve().parents[1] / "kselftest")
    ...
    return importlib.import_module("ksft")

Nothing in that flow creates <dir>/kselftest/kselftest, so
import_module() raises ModuleNotFoundError and run_one() records
"not ok ... selftests: userland: test_smoke.sh # exit=1" even on a kernel
with CONFIG_USERLAND=y.

Would adding the helper to TEST_INCLUDES keep the layout that
_load_ksft() expects?

    TEST_INCLUDES := ../kselftest/ksft.py

net/packetdrill/Makefile does this for ../../kselftest/ktap_helpers.sh.

[ ... ]

> diff --git a/tools/testing/selftests/userland/userland_cells.py b/tools/testing/selftests/userland/userland_cells.py
> new file mode 100644
> --- /dev/null
> +++ b/tools/testing/selftests/userland/userland_cells.py

[ ... ]

> +        elif mach == "x86_64" and ptr_size == 4:
> +            base = 0x40000000
> +            arch_legacy = {
> +                "pivot_root": base + 155,
> +                "umount2": base + 166,
> +                "waitid": base + 529,
> +                "execveat": base + 545,
> +            }

Does this branch also catch plain i386 userspace running on an x86_64
kernel?

platform.machine() comes from uname(), and a 32-bit task only sees the
compat machine string when it runs with PER_LINUX32:

    #define override_architecture(name) \
            (personality(current->personality) == PER_LINUX32 && \
             copy_to_user(name->machine, COMPAT_UTS_MACHINE, ...

So an i386 Docker image or chroot entered without linux32 reports
mach == "x86_64" with ptr_size == 4, and gets the x32 numbering.  The
test then calls userland_open as 0x40000000 + 474 instead of 474, and
do_syscall_32_irqs_on() returns -ENOSYS for nr >= IA32_NR_syscalls.

ENOSYS is in SKIP_ERRNOS, so probe_pre_idmap_mkdir() reports
"userland_open() unavailable" and the suite exits KSFT_SKIP.  The compat
entry paths of userland_open, userns_set_idmap, clone3, fsconfig and
waitid(P_USERLAND) are then never exercised in the configuration that
needs them.

The function already tells these cases apart on other architectures.
Would gating this branch on "x32" in multiarch, and sending the remaining
x86_64/ptr_size == 4 case to the i386 numbers (217/52/284/358), work?

[ ... ]

> diff --git a/tools/testing/selftests/userland/userland_test.py b/tools/testing/selftests/userland/userland_test.py
> new file mode 100755
> --- /dev/null
> +++ b/tools/testing/selftests/userland/userland_test.py

[ ... ]

> +    def test_get_nsfd(self) -> None:
> +        try:
> +            rns = Userland()
> +        except OSError as exc:
> +            if exc.errno in SKIP_ERRNOS:
> +                self.skipTest(f"userland_open() unavailable: {exc}")
> +            raise
> +        with rns:
> +            for case in NS_TYPE_CASES:
> +                with self.subTest(ns=case.name):
> +                    with self.closing_fd(rns.get_nsfd(case.nstype)) as nsfd:

A subsystem pattern flags this as potentially concerning: test_get_nsfd()
requires USERLAND_GET_NSFD to succeed for every entry in NS_TYPE_CASES,
including NsTypeCase("time", CloneFlag.NEWTIME).

CONFIG_USERLAND does not depend on TIME_NS, and userland_get_nsfd()
handles that configuration explicitly:

    case CLONE_NEWTIME:
    #ifdef CONFIG_TIME_NS
            ns = to_ns_common(userland->ns->time_ns);
            break;
    #else
            return -EOPNOTSUPP;
    #endif

On a CONFIG_USERLAND=y, CONFIG_TIME_NS=n kernel, the OSError(EOPNOTSUPP)
is raised inside subTest(ns="time"), the test is marked failed, and
KtapRunner.main() exits KSFT_FAIL.  The selftest config fragment sets
CONFIG_TIME_NS=y, so a run that follows it does not hit this.

Should the time case be skipped on EOPNOTSUPP?  test_share_nsfd() already
handles a missing time namespace with "if not os.path.exists(ns_path):
continue".

[ ... ]

> +        def check_dead_ancestor_pidns() -> None:
> +            self.enter_userns_if_unpriv()
> +            s_p, s_c = socket.socketpair(socket.AF_UNIX, socket.SOCK_DGRAM)
> +            p1 = os.fork()
> +            if p1 == 0:
> +                s_p.close()
> +                try:
> +                    os.unshare(CloneFlag.NEWPID)
> +                    p2 = os.fork()
> +                    if p2 == 0:
> +                        with Userland() as nested_u:
> +                            socket.send_fds(s_c, [b"U"], [nested_u.fd])
> +                        os._exit(0)
> +                    os._exit(self.reap_exit_code(p2))
> +                finally:
> +                    s_c.close()
> +            s_c.close()
> +            try:
> +                _, recv_u, _, _ = socket.recv_fds(s_p, 1, 1)
> +            finally:
> +                s_p.close()

Can this recv_fds() block forever?

If p1's os.unshare(CloneFlag.NEWPID) fails, or p2's Userland() or
send_fds() fails, nothing is ever sent.  Closing the other end of an
AF_UNIX SOCK_DGRAM socketpair does not wake the reader, because
unix_release_sock() only sets the peer's sk_shutdown for SOCK_STREAM and
SOCK_SEQPACKET.

p1 and p2 are forks of the run_forked() child, so their exceptions end in
_exit(1) after writing a fail payload, while the run_forked() child stays
blocked in recv_fds() and keeps the pipe's write end open.  The parent
then blocks in pipe.read_all(), so a failure turns into a hang.  Under
run_kselftest.sh the 45s default timeout kills it, and the tests that sort
after test_clone_flags_and_pidns_ancestry never run.

create_userland_as_uid() in the same file guards the same fd-passing
pattern with select.select([s_parent], [], [], 5.0).  Would the same
timeout, or a SOCK_SEQPACKET socketpair, turn this into a normal test
failure?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/44972669664
--===============3579480507848251298==--

