Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A971A606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 01:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ea3+EMLq
Received: by kanga.kvack.org (Postfix)
	id 69D7F6B00EF; Sat, 21 Nov 2026 20:39:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 674F76B05B0; Sat, 21 Nov 2026 20:39:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58C546B05B3; Sat, 21 Nov 2026 20:39:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 28A656B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:39:14 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9CCB1405D7
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:39:13 +0000 (UTC)
X-FDA: 85461046986.11.E7B4F65
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 05A7140005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:39:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ea3+EMLq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795311552;
	b=6j7aSM1igOGi6Wcyl7UlVAPkJ+yE3cjVwCmc5oPsSho1U6RlRr/c+bh8ACuNfkqYbG7DKs
	smsrtEAxBOSixNWzPIpSvNnUY+G9RYrfjpzl7OzmResDpf1rmEwwEBm4koST02WzvI78C5
	tfTvvThosnGzIN24WRGGgRn180U1rL8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795311552;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kNajklT4NWRuvO4tlojLaU4FTOaYuorZJL8FQmjQkns=;
	b=T4s6q2t2myyE4TY4Pte/AYB75m8EKXdZm77/k/e1z7veYo502gMD114Lg+1tZs9O5ZIW0w
	ZbdVqjFnaayseSh7m74hOmHIaemKuqlmGR7Qtj3a6eO0FRUXX/QNomAM+Bh1Qc6dLBpZzG
	5vCBgk7J5KvgQGiqg8tFsxZbenlhCLc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ea3+EMLq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F9D7432D2;
	Sun, 22 Nov 2026 01:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD50C1F000CF;
	Sun, 22 Nov 2026 01:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795311551;
	bh=kNajklT4NWRuvO4tlojLaU4FTOaYuorZJL8FQmjQkns=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ea3+EMLqjbQ7qRwbgCzK72nDD3YzZxWc1ejtUmKtpm9Lrr3/e6OuxoRh+5RMhVCsN
	 BZWuGk0Bt7/F+krh5/ygopq7dBx48ThSHbOSMMC8cTspbSKNNuw3RjUn4SwSKTWbQV
	 7BNjzqFIQQqcN/BHxkGsOAVmgcUiAshbKS6bPDq6X2LUSnFc9Nh7i1ti+oCIwcuYMa
	 tnXAWhjoz51Rz4t0myRbUv0viKkltsiVJ3f5M6tVl/dtg4BxvVjj9BojY7YOC1/3Xq
	 vXiF1rDkzkLVwb4lwyAHatrNxUwQnSY10RRforwNqLbpx5RvP8nlGumxKzU9/gfZ/V
	 l/gDihNp8yKWQ==
Message-ID: <sashiko-outbox-227627@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v6 25/26] selftests/userland: Add userland test
 suite
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, "Aleksa
 Sarai" <aleksa@amutable.com>, "Alexander Mikhalitsyn" <alex@amutable.com>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Andy Lutomirski" <luto@amacapital.net>, "Arnd
 Bergmann" <arnd@arndb.de>, "Christian Brauner" <brauner@kernel.org>, "David
 Howells" <dhowells@redhat.com>, "Giuseppe Scrivano" <giuseppe@scrivano.org>, "Hugh
 Dickins" <hughd@google.com>, "Jan Kara" <jack@suse.cz>, "Jeff Layton" <jlayton@kernel.org>, "Jonathan
 Corbet" <corbet@lwn.net>, "Josef Bacik" <josef@toxicpanda.com>, "Kees Cook" <kees@kernel.org>, "KP
 Singh" <kpsingh@kernel.org>, "Lennart Poettering" <lennart@poettering.net>, "Neal
 Gompa" <neal@gompa.dev>, "Oleg Nesterov" <oleg@redhat.com>, "Paul Moore" <paul@paul-moore.com>, "Pavel
 Tikhomirov" <ptikhomirov@virtuozzo.com>, "Serge Hallyn" <sergeh@kernel.org>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Zygmunt Krynicki" <zygmunt.krynicki@canonical.com>
In-Reply-To: <20261122011809.2667684-26-jarkko@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
 <20261122011809.2667684-26-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 01:39:09 +0000
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 05A7140005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: 3d61yp5p3wmo7k8ytc7m5b6yaa9o7by3
X-HE-Tag: 1795311551-878994
X-HE-Meta: U2FsdGVkX1/8L83U3Jlo+w1wZtHciKBEjVznTW/2/buWgOisvYgl2s3hZZeCdPKMQZCvyK1sfz7mxMJ2iIDAeTHpJR+aj4Z3AkyZdlyVk43CxzrX04BNdZhUv5JJY6Emri/iSeyPjnHMZG5A9eKw5/YjXcGmJjeqWSS921NoG6EryQxRb6MK6cQyY2NH7Eztt5GiIfSVP62LlE/rodhRXMZlYOwiKuszzasY/pzGPimTeAHsR7njlfMAxQNsvq3UudLDzz6XasRFuCZduafV6w2C4r4zrJKnwHKydkvapNRiskdwfr3AhLW780A31puQ4hea2buQtK6rqc9w6x1iCTQQwGKUl9HTc7jA7YjnEiX7Hh8Z8QnZ+KpakGDaV1ojlPx9E70i4bpOyeqojRYF75gKjKhOiTRmmoZFRYrpN57I7IRPoOQ9i+8M74ufxMgBJ4Izo2Jsl8buE6r06z0M67oOUAAp9b48qJlfjgi48IEtisrb/6lDyjgnRyynFWzr86CppH1EaNGgpKqrOjJJSSUacQeu1JKt/GuSIut70luYy/AEv8fw3dMHGsY3dbe/QRQ08Lvz+d1hTBE6eaS2qs0DqpRefi5irvL1jndT5rQBAfKsLcUti/HYPWNP2VhcRv8Lk4y9KO4VZsuUuBc6BQ8VJ8ASkU4Ahyg2FfA/tcREpatYTgvgBQr4CJ2KdR6Vzl8JcMBh59HvU3KQ13yV3jNq3IohwPaOCrwter088p84wF28BOWzUm+Yjq4l9oCHVXVCoajg/dWut5tbqhHHDegHV2+3xV/b2pN8Xb4tBiJetOM/r24H/XIcgQOjSmfn+pQCPTtRbdu0Ri9388beGV/Ef8/UyKE5Q3Pzt9EIeEEktROborfdBZ/7fd2dPYxvaAYpL1w5IdT1AFu8LfyA4cO/RsXTFUi39AqqLC2alLVAfRiFkXp344Bq5PK9wKHgEhSNFa3plwRbGgq/eho
 Smsr90eA
 /mX+/OZ7/HeM3qxyKBv/JO/9+Z07ycZAW+T36hbFu73Lr5mtRSoLHo699nxKMhhxhULaIz+tEN4Uh5wslIW4tW7aiCIliGMrpFRI6jdBvOF/PbNVfuzqMWsXDE9I0POmJeGp2eG90SNE2HwnnO7DWQ3ISCoaURXVuZRSK5ZVDQ755o45lgfvW0duhLVl7JGMgD0AkXXuZet9JBwU/XhanAqxzA6+oyyqCjBJV5Iq6f4L+cj3/EKuOv6cmF7oGkrbC7aBrkJ+PnZSyhL3mEKhtkpJEiiGg0naoVhjd9YjPBueIAXbyvTwJWyrGpWr8rvV8bg5EW/MNfwszAwHQMfD4Mzufx4cU9SatmsBQBfUZJFisoq+//lY0SdqMg6r4Na4KL8KTtBMCmGdV9SVfmgw+E65z457zUv6/m6wVbuK/8eYGPpPBfDfD4T1OiRa5kc6JNcNHySPbGzGrOgl3OTK0M6aXT742XCv+2vMCsHnj9r3SLwlRdKWrKkbvrDB6IdOMqRDwiQ/VomTffd3KZX0TJN20j6Jivw7JtZ/ka1c+mE8Qw20jZeOUlb2FzxDdmChjn5jeVNZT+zp92Jr5+6tTuhi++tmWdsvWaagz1Z1UeOg3pj13PCZIRS8m+Sg9E4xPj9eOYoYgaDE7YmCVmEmpte/fB+r44kPP6ePs6aVrfAaQ0Yi/UEyWFq7gzTM0qka9m9HfKAr9lnKJyD3pZm5J4UibvY39e4nVmFPdzoZSFWq8l9hnJ1t/LzEMXhcyuMrt0juGsSdtl/2/NCxG25zk09hPTj7R26ub3bRHpnShymLF1bkKDPgxqBNDfnVhj2fPMcFX
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
- [Medium] selftests/userland: host /tmp mount leak in
  check_child_src_slave_locking()
- [Medium] selftests/userland: 64K-page E2BIG failure in
  test_userns_set_idmap()
- [Low] selftests/userland: Python 3.10+ parenthesized with-statements
  in test
--

commit ceac0bb92c4f38107df4d9a282065b54c6373344
Author: Jarkko Sakkinen <jarkko@kernel.org>

selftests/userland: Add userland test suite

This commit adds a kselftest suite for the userland control object uAPI,
covering namespace sharing, mount-namespace configuration, waitid(P_USERLAN=
D),
pidfd_send_signal(), and userns_set_idmap().

> diff --git a/tools/testing/selftests/userland/userland_test.py b/tools/te=
sting/selftests/userland/userland_test.py
> new file mode 100755
> index 0000000000000..eb29cbc9c8f10
> --- /dev/null
> +++ b/tools/testing/selftests/userland/userland_test.py
> @@ -0,0 +1,2306 @@

[ ... ]

> +            with (
> +                self.closing_fd(rns.get_nsfd(CloneFlag.NEWNS)) as mntns_=
fd,
> +                self.closing_fd(rns.make_mount("tmpfs")) as rootfd,
> +            ):

[Severity: Low]
Will parenthesized multi-item with-statements fail with a SyntaxError on
Python 3.9?

Documentation/process/changes.rst specifies Python 3.9.x as the minimal
supported version, whereas parenthesized context managers across multiple
clauses were added in Python 3.10.

[ ... ]

> +            def check_child_src_slave_locking() -> None:
> +                self.enter_userns_if_unpriv()
> +                os.unshare(CloneFlag.NEWNS)
> +                with self.closing_fd(self.make_plain_mount("tmpfs")) as =
tfd:
> +                    os.mkdir("sub", 0o755, dir_fd=3Dtfd)
> +                    Sys.move_mount(
> +                        tfd,
> +                        "",
> +                        Sys.AT_FDCWD,
> +                        "/tmp",
> +                        MoveMountFlag.F_EMPTY_PATH,
> +                    )

[Severity: Medium]
When running as root, does check_child_src_slave_locking() propagate its
tmpfs mount onto the host /tmp and leave it mounted after the test exits?

enter_userns_if_unpriv() is a no-op when os.geteuid() =3D=3D 0, so
os.unshare(CloneFlag.NEWNS) stays in the initial user namespace and
preserves MS_SHARED peer groups with the host mount namespace.  Mounting
tfd onto /tmp without first calling Sys.set_mount_propagation("/") (as
check_standalone_mntns() does) propagates a fresh tmpfs over the host
/tmp, and cleanup only detaches /tmp/sub.

[ ... ]

> +            big_buf =3D ctypes.create_string_buffer(65536)
> +            with self.assertRaises(OSError) as cm:
> +                Sys.userns_set_idmap_raw(
> +                    userns_fd, ctypes.addressof(big_buf), size=3D65536
> +                )
> +            self.assertEqual(cm.exception.errno, errno.E2BIG)

[Severity: Medium]
Does this assertion fail on kernels with 64 KiB (or larger) base pages?

userns_set_idmap() returns -E2BIG only when size > PAGE_SIZE.  On a 64 KiB
page kernel, size=3D65536 passes the PAGE_SIZE check, copy_struct_from_user=
()
succeeds on the zero-filled buffer, and the syscall returns -EINVAL instead
because the extent counts are all zero.  Sizing the buffer with
os.sysconf("SC_PAGE_SIZE") + 1 would exceed PAGE_SIZE on all architectures.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122011809.2667=
684-1-jarkko@kernel.org?part=3D25

