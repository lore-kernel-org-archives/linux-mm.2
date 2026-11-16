Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B098606A330
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dgaswur9
Received: by kanga.kvack.org (Postfix)
	id 328996B05EB; Mon, 16 Nov 2026 06:28:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D9ED6B05EC; Mon, 16 Nov 2026 06:28:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CCCA6B05ED; Mon, 16 Nov 2026 06:28:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E88256B05EB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:28:31 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7F69A1A0903
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:28:31 +0000 (UTC)
X-FDA: 85440759222.02.A103AA0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id C45E620004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:28:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dgaswur9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794828510;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RW3Nmjz+GbO91KVwbZw20axMMPWohpmxD8TXxvGg3/8=;
	b=g6ojDthEv+UIPjiK3b/re4ofarB2EMUmyhvyWvcZBWIqpHU7mD8734ortSBGjgTij/Lz8L
	dEblk+WoYQNgI45HpI4LJSzn0cmkx6ForQAf8tKajHEbCxgfEdGG0EU9onSNNT9TDpNWo3
	2eEVgEuCcvOYfRGTgHEZGf9/zNsqTfg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dgaswur9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794828510;
	b=rGHevC2kfHK51lVKBHBvQNYuzLyoxu0Xxk3vGyfSiEfrY183RSbKk7oMoch7ayznJioW0A
	JkjCUYM7xatJwnttZjsTSVVm9CtfTdtMqcEYW7z3U49RrIk8+2uwG2XR6qT4RSSsPPrikt
	oxjixzjr9HAHBvH7h6mKCgtOxwAZxP0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D402746344;
	Mon, 16 Nov 2026 11:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E091F000C4;
	Mon, 16 Nov 2026 11:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794828508;
	bh=RW3Nmjz+GbO91KVwbZw20axMMPWohpmxD8TXxvGg3/8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dgaswur9NKmVb2Cj2LBZvzzO++YPkgo2pM4LudFKJRS+BkMI5ErMhhAJqeDzhVlDv
	 eCPlnjvzIK+Il93Dk6xH3UrLaJjZsGk3GL/xs8+hSbIxs45r7o6sNqCn1GqDoq24qq
	 2QUS9uyBVKqILqww7albcp/nEZC5F+Gxqn2u6w+1S/QSyjVgBvEMBaBvy8oC1WrTZV
	 rcnaX+dbnp5rdl8gyPjgXF2DkHTYsV59wdAhIGeMurQ7N8u+SHTHNYNZNVuKeBPD4z
	 5O24la+RsvuF8Pvvu97OG2nsodEcHs5Rzt5fUjwVYjICfJDOyrd8HrYrpVXTeV62Oy
	 fIYgTSktA3yuQ==
Message-ID: <sashiko-outbox-216927@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 34/44] selftests/ovl: test data-only layers on
 pseudo filesystems
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Jann Horn" <jannh@google.com>, "Chris Mason" <mason@kernel.org>, "Josef
 Bacik" <josef@toxicpanda.com>, "Christoph Hellwig" <hch@lst.de>, linux-nvme@lists.infradead.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, apparmor@lists.ubuntu.com, linux-efi@vger.kernel.org, linux-s390@vger.kernel.org, linux-usb@vger.kernel.org, "Amir
 Goldstein" <amir73il@gmail.com>, "Chuck Lever" <cel@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, "Anna Schumaker" <anna@kernel.org>, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261116-work-loop-pseudo-v3-34-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
 <20261116-work-loop-pseudo-v3-34-8cbbea1cf34f@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 11:28:27 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C45E620004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: yz4pok5kahrdka1bzg8dduryu9zpjig5
X-HE-Tag: 1794828509-450189
X-HE-Meta: U2FsdGVkX1+xXAItWqeOzo/Wf4vGp3/4ZQfhRgKiko8DvjHKk5QmHpDM3p9WT3F4mMBok7Uhe9URKyKhTjRFcKQK424+crog3ZPcUZ5lcXhxwtaZcOhAZIOwsXUU+6sEO6HAEQBW1/SqHezqHYbiMbKS1Gd+ll1uyWSMmkSUGmyaNggwv/vcUpgZvmOSTov7ezKHlH1pqpvfl0SW8YVOdq9/lQ/ojGniAxFVzAj77Gp6Unu/JsNMTXuLus/Cg3hQd8TaP+YcNTE5ntpSmsSDZ5eiZIwZe6Eegvj88gXnCIjNtmorcmHDhb2V0B00rj8Q04KCHd/A+bymzS5aJsyCWP7Jm7Zi1Pw3Y2AbLb+5IEoIsmduw5CAHatnO1GeAhYTXP+6DNSMWCed1D0cHfX+2tlAqX+cHgkA5NdRgqwR/NFfdf9ToXGcs8HUPyVzXmVwg8kO83B4FTHFAqnjUSzMOjbIXhx6m1waHuzQ1jSTAUbdrdtKT2+336rZD2aydfpXW+YwG9q07QJLZX+BC4PcB6Z4hyfUO+lT6+OQx/CboHfzRbkmSZn3+PTGFn4TsCACe7wjHCtutKi0huL8WrnYfJb4+5z1zBTW0ROCklmcFPE54CSLso3aItFjvgJZXFmgzvK+h95bvivQFoUIXbPhoJcIJyA2PzZ3ie89R0aqq7hWWCa1FUCHn8eEJkLF8Z8cUn2phMmWyfnatqisdoRsmtX3/A9unPCbhXUELCeH628tPFTQnreH2RG5O/GlA5hehMMetokb3OGcEsxYVRxT046h7JnFlBP8JsaSTfqThidiYfpZcDHrRGQ6+qi8bImwXr2KwUT2TLnJA/F5/gXZkX5T15ZbrwZU+jb+rvmITmLJXpF7qay1LPhauecedq2JrtPxZQaQ8eB43EMMFFn80uQ2GAhekUQPhsPNUIOxX/aA03OjtK65jP+gs43eWV6rh70herN7WDCPwfqizM2
 Ry5yHLJD
 sd+XGfuOzufUqJD+dYwK4DjFnn+k4LQSUQUX+YmMbyKfjV58e94fqQkYgcSq6lrWXJE4oyrPJ2jTfXAr+dbeoUSmA+MyTb/CwIrHcRqC0innRdE27KcuMG9sjBnIdcLfxz77JMttWCVu6yt9oTvfaTW6bSAjPL0Y5CFtsoHBegf0cwFU/FQtcwk0j6xiOW04DA9YVTirEM79o6ZBwf2VZZ6XyBh70tqFyeLmFpBdRhB880E3CJ5pFc/w2QGSnh2KTuyT4Fw8ZoWTi848kFtnNCXoe3wcICCqzSOvmMBpUROB2Du93qyg/EuBr/cFyIXxhzqkaMCTQFouWj0GjsqSOd6S/TGhoMr9s8eYlsMYaSkC8Exna6xB6xGdDhBKzUh6rISU7hSbVNU4JmMqRH7bmFLx5QfT4dGn1mnL03aCeYWCf8AQU1rRYamVMWe4zSijfaOPfksbpUf+UUJeIhQqCYZBXOA+PcBlP2FW68NnkmdNgvDvtwa7bgzR2HbJJ2KZjJrBAyVEhJIVC9wYuEYQ+SPBrmFAf5P2umP4HCs7Qrk+XxM7GhrdzkuU3stGTPBy0Em18LOeAKW5B6SIw8w2HccD31g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Low] selftests/ovl: missing prerequisite skips in setup_tmp() and
  tests
- [Low] selftests/ovl: duplicated setup_tmp() and datadir test cases
--

commit 9dfbd53c60eeeb8dceed3a46417fda9ee76bb58b
Author: Christian Brauner <brauner@kernel.org>

selftests/ovl: test data-only layers on pseudo filesystems

This commit adds an overlayfs selftest verifying that data-only layers on
pseudo filesystems (sysfs and procfs) are rejected while tmpfs data-only
layers and sysfs lower layers remain allowed.

> diff --git a/tools/testing/selftests/filesystems/overlayfs/pseudo_datadir=
.c b/tools/testing/selftests/filesystems/overlayfs/pseudo_datadir.c
> new file mode 100644
> index 0000000000000..3b59fd3e9f5c2
> --- /dev/null
> +++ b/tools/testing/selftests/filesystems/overlayfs/pseudo_datadir.c
> @@ -0,0 +1,131 @@
[ ... ]
> +static int setup_tmp(void)
> +{
> +	if (unshare(CLONE_NEWNS))
> +		return -errno;
> +	if (sys_mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL))
> +		return -errno;
> +	if (sys_mount("tmpfs", "/tmp", "tmpfs", 0, NULL))
> +		return -errno;
> +	if (mkdir("/tmp/lower", 0755) || mkdir("/tmp/data", 0755) ||
> +	    mkdir("/tmp/merged", 0755))
> +		return -errno;
> +	return 0;
> +}

[Severity: Low]
Should these tests invoke SKIP() with a reason string when root privileges
or kernel overlayfs support are unavailable?

Running this test without root privileges causes setup_tmp() to fail with
-EPERM on unshare(CLONE_NEWNS), and running on a kernel without
CONFIG_OVERLAY_FS causes mount_lowerdir() and fsmount_layers() to return
-ENODEV, failing all four tests in make run_tests instead of skipping them.

[ ... ]

> +TEST(datadir_sysfs)
> +{
> +	ASSERT_EQ(setup_tmp(), 0);
> +
> +	EXPECT_EQ(mount_lowerdir("/tmp/lower::/sys/kernel"), -EINVAL);
> +	EXPECT_EQ(fsmount_layers("/tmp/lower", "/sys/kernel", false), -EINVAL);
> +	EXPECT_EQ(fsmount_layers("/tmp/lower", "/sys/kernel", true), -EINVAL);
> +}
> +
> +TEST(datadir_procfs)
> +{
> +	ASSERT_EQ(setup_tmp(), 0);
> +
> +	EXPECT_EQ(mount_lowerdir("/tmp/lower::/proc"), -EINVAL);
> +	EXPECT_EQ(fsmount_layers("/tmp/lower", "/proc", false), -EINVAL);
> +	EXPECT_EQ(fsmount_layers("/tmp/lower", "/proc", true), -EINVAL);
> +}
> +
> +TEST(datadir_tmpfs)
> +{
> +	ASSERT_EQ(setup_tmp(), 0);
> +
> +	EXPECT_EQ(mount_lowerdir("/tmp/lower::/tmp/data"), 0);
> +	EXPECT_EQ(fsmount_layers("/tmp/lower", "/tmp/data", false), 0);
> +	EXPECT_EQ(fsmount_layers("/tmp/lower", "/tmp/data", true), 0);
> +}
> +
> +TEST(lowerdir_sysfs)
> +{
> +	ASSERT_EQ(setup_tmp(), 0);

[Severity: Low]
This isn't a bug, but could setup_tmp() move into a FIXTURE_SETUP() block,
and could the three datadir_* tests be parameterized with FIXTURE_VARIANT()
over the path and expected return code to avoid duplicating the setup and
mount sequence?  Also, since set_layers_via_fds.c already tests lowerdir+
and datadir+ layer configuration, should these cases live there instead of
in a new standalone binary?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116-work-loop-=
pseudo-v3-0-8cbbea1cf34f@kernel.org?part=3D34

