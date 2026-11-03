Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC0146082BDC
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CoJeH/FT
Received: by kanga.kvack.org (Postfix)
	id 1FC756B05C9; Tue,  3 Nov 2026 10:18:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D5886B05CA; Tue,  3 Nov 2026 10:18:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1134F6B05CB; Tue,  3 Nov 2026 10:18:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E65E16B05C9
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:18:53 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 94FF9A042F
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:18:53 +0000 (UTC)
X-FDA: 85394165346.17.B4E980F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id CED3318000D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:18:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CoJeH/FT";
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793719131;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bc8aT4Z6get1K0vbpp5ygtanM/hIwI+PelNNb0VgB7c=;
	b=SfgvttKAvh/lJbvWsktS4YVFl8O/r/zu2g0dKECvMicKZKmH5TddEB8/FMW/cCNfEFmCnG
	sLaaerVfS3oDMek0C07474Ih7/fSW3O2ZuEhMB10KgrG2ZK4ka8lU598tj/yPu7jzVBqxE
	22jkFKXeAfz2OK8mj2Ulu++CQffAzOE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793719131;
	b=VARadozrqoAvDZ6H4jQu7/UqKLWr4/r2ZoUrM9qCgMnOucU3YVFiROqdNydGZWvRw73SNF
	JPMNLGqjrqq1iJf5eBWrXoE5v+rJDJzf+7Ub+QNpnTftdDPjA250QMbCK6s39S4GmTY8bQ
	PdYAVRIBy6h8HmZ2dmEVWWyRfnzoZxA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CoJeH/FT";
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B24DC42217;
	Tue,  3 Nov 2026 15:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856681F0093A;
	Tue,  3 Nov 2026 15:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793719130;
	bh=Bc8aT4Z6get1K0vbpp5ygtanM/hIwI+PelNNb0VgB7c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CoJeH/FTtYurhrEu7pHCjreAy8kglbRPwM3Bp2MFbNXs5sfimskiQ6GdFaw2b46h5
	 LFYZjIjC0HLk9VtZElPrV+LCrvrtO/TXriYCzcHxI7ww7m4DuMtGSua9gCijZ8ag5C
	 C1QyPEjg//XpCtccxJ83qTFkU2bPqiwCZUATJ82pjvzmj0HhclIwZdtkBZ4X0D4FpB
	 W2kjXVSW4Jh+gJKkh7n8hluL4QKxxLPc9zkayoPnR79tHeS7TL9oS5+LArhquuyOcO
	 R0f20W9hUcQSALMEMf5u4F5ldJdbIIx8/qJHUPE3ePz+MiGIzk37ns/uj3hE88ZoNC
	 wd/gwuy246nxg==
Message-ID: <sashiko-outbox-195591@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 11/23] selftests/proc: check that a faulting writer
 doesn't hold up removal
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, "Jann Horn" <jannh@google.com>, "Josef
 Bacik" <josef@toxicpanda.com>, "Chris Mason" <mason@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, NeilBrown <neil@brown.name>, "Eric Dumazet" <edumazet@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Al Viro" <viro@zeniv.linux.org.uk>, "Jonathan
 Corbet" <corbet@lwn.net>, "Christoph Hellwig" <hch@lst.de>, "Greg
 Kroah-Hartman" <gregkh@suse.de>, "Joel Granados" <joel.granados@kernel.org>, "Kees
 Cook" <kees@kernel.org>, "Jan Kara" <jack@suse.cz>, "Jan Kara" <jack@suse.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-usb@vger.kernel.org, samba-technical@lists.samba.org, sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-serial@vger.kernel.org, "Takashi
 Iwai" <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, tytso@mit.edu, dmitry.torokhov@gmail.com, "Petr
 Pavlu" <petr.pavlu@suse.com>, "Anna Schumaker" <anna@kernel.org>, yukuai@fygo.io, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261102-work-procfs-drivers-v1-11-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
 <20261102-work-procfs-drivers-v1-11-a994bd4d3b1a@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:18:48 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 3rctghskqwzekjsr9j3w5jui7dsbnes5
X-Rspamd-Queue-Id: CED3318000D
X-Rspam-User: 
X-HE-Tag: 1793719131-723449
X-HE-Meta: U2FsdGVkX1+OvQeJK5LqHz3bFBlVAR/1FNG7J65stNEiICzB9olaQ1v3mNgTDo4WEPqD66JgxE7y5/tWEv95cITwXXyEnVcT8JMuWKWSSYMJv6y5ppFwwGMDhFUtZ4wFc5Wbcg+l7rmD2u6Wc+Aqjk8O9ht6+9cGD2n9MT6fQKRkOEWAiuRrTWTrywjeF3ARFFzo4RfBYVw4j6acAl37XT0aLh9cvViU6i1yYEjdmsqoRRvpFq1tLSFdtTXUdgbIYB16firL1Tx6gdYjgRTpzC79RHXEI9AIPTquhBQMfM84qT6Putl+qRoG+Paqeq7AR0WrQ/ZdTLxAu4YbXsWEbqOFHrCl/jhMkNIehWKgjQkqZ7bVU0M+fW/TrmOgLUY+nqY+UQsmZD2Jr8AnVGCxFQq1MR7e8wVMLODGX6U4DwQItervHRAGSo0whTaSBAdOomLbtIlNAoCmbVhVpOvUEsPpl/BZby6n6RAkoIWogGRJruRPEXF7CBlzUqhiy38KSNwmPQNNVZ+pRAeqnJ9SULdJijXKi+/Y4Pc8av/feXiW0+4TYJexAW7FjT0+fC79Bx47ZA5tRCW5HhX/xIa9tZTZSq2kN9AXFkpjikqDyg5qG1LM0hy3QtsJEK4v1TXwPYLxSQzYKN/xMgGYOlLxyW3Y04dEIqSer1IYofLwKSFOfsmee4Gd5v33iuC3UNoMUbmvPJhGiwPtyXWWylwDKubA9uDXzMgAbuPRsw2CTSlnsf+2RyNpsZQgnQwMyIfpaoTTyq15CFYeR2OvQ6W/K6SuMBp0Y+7XiLv7x0Qdnm5EqXopFFmfNuYLzrUbsA10hcxh0PPkO1nWtTLi2TpouND1WuZa0flJZbdPhgEyW0eHvN56MdOvfO3t6UWnNsAczxCYwLqTSLpH/5zZOazRYyKpppz8hMk0bFkj+olCYzxkCq9381pxgcJTaK2wFL0JuWdRStd+e/28OOoriei
 m16inr0D
 YY7ndJFjFQedw/qbVVNzZK3wRzufwMRGfUB/HON2FhBUrMB7F+kjTfBWRJB21+DlVIR/uhIGUQlDeo0GaT0vf1F+4EE9VafTsIfUimVWc/PsA1pl8gdnqws+cPPUdA3+rStuzd/Ig6Tku6uFY4w9A+FcVBSaBHwnD7SSt2+y1QDbWPw2EN1Xmzenre3uj/RM9onK8ZdavXsjcmhGIfIdAgrIwUb13PwsrFiEBsqB2hpvt/xzchD1R1jqxR4I1f+eIgL+Qt8deEZyMG71xL77GSX05BKaoHAQCTP4dhqzO579Wk0SKc32+rkGtHoo5uYBH3Drtpo/6Cxo0nmwPY2MCKzohQeHeEScLaURhmyOhVC7up9NPmr3f2hOn2WaIJkblTSByMyTU+QHEjchde1WQGqMApSd+6n6sXefrp6pQYA/waZDZzCWFGlJ4WXwy+LDHDb9sFqZQ6h3F7qlZnaEXM8DN6kJjQd13bd9s2viBUh65LbRYJWO9FKzcx9F4vUpVS9ILvENV+SQXOs64vCQw13SLD3f4XQrgEPjz2UYfSjnnaoeYplvEF7ouzkr2sw0TyyeRLHc7rgf1J7WwBbzpic+fWi0UlwtCKXKHh3ZFVFYuuG1jpvwNzn9fp/uX7wu0tkH/4lS4S1PQrS8XM0Q/9tTBWjQoOcfGDEdU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] selftests/proc: fail and leak scsi_debug host without CONFIG_SCS=
I_PROC_FS
--

commit d0cceed0cde591b286c7977ad630183fc653ded2
Author: Christian Brauner <brauner@kernel.org>

selftests/proc: check that a faulting writer doesn't hold up removal

This commit adds a procfs selftest that uses userfaultfd and scsi_debug to
verify that a writer faulting during copy-in does not block removal of a
/proc/scsi/scsi_debug/<host> entry and fails with -EIO once the fault is
resolved.

> diff --git a/tools/testing/selftests/proc/proc-remove-slow-writer.c b/too=
ls/testing/selftests/proc/proc-remove-slow-writer.c
> new file mode 100644
> index 0000000000000..f69ca75ba87cb
> --- /dev/null
> +++ b/tools/testing/selftests/proc/proc-remove-slow-writer.c
> @@ -0,0 +1,203 @@

[ ... ]

> +/* the numbers of the hosts in /proc/scsi/scsi_debug as a bitmap */
> +static int list_hosts(unsigned long *hosts)
> +{
> +	struct dirent *d;
> +	DIR *dir;
> +
> +	memset(hosts, 0, MAX_HOSTS / 8);
> +	dir =3D opendir(HOST_DIR);
> +	if (!dir)
> +		/* the directory comes with the first host and goes with the last */
> +		return errno =3D=3D ENOENT ? 0 : -errno;

[ ... ]

> +FIXTURE_SETUP(host)
> +{
> +	unsigned long before[MAX_HOSTS / HOST_BITS];
> +	unsigned long after[MAX_HOSTS / HOST_BITS];
> +
> +	self->host =3D -1;
> +	if (access(ADD_HOST, W_OK) && system("modprobe -q scsi_debug add_host=
=3D0"))
> +		SKIP(return, "no scsi_debug");
> +	if (access(ADD_HOST, W_OK))
> +		SKIP(return, ADD_HOST ": %s", strerror(errno));
> +
> +	/* host numbers are reused, so look for the one that's new */
> +	ASSERT_EQ(list_hosts(before), 0);
> +	ASSERT_EQ(add_host(1), 0);
> +	ASSERT_EQ(list_hosts(after), 0);
> +	self->host =3D new_host(before, after);
> +	ASSERT_GE(self->host, 0);
> +	snprintf(self->path, sizeof(self->path), HOST_DIR "/%d", self->host);
> +}
> +
> +FIXTURE_TEARDOWN(host)
> +{
> +	if (self->host >=3D 0 && !access(self->path, F_OK))
> +		add_host(-1);
> +}

[Severity: Medium]
What happens if the test runs on a kernel where scsi_debug is available
(CONFIG_SCSI_DEBUG is enabled), but CONFIG_SCSI_PROC_FS is disabled?

The sysfs attribute /sys/bus/pseudo/drivers/scsi_debug/add_host is still
present and writable without CONFIG_SCSI_PROC_FS, while /proc/scsi is never
created. In FIXTURE_SETUP(host), list_hosts(before) sees ENOENT on
/proc/scsi/scsi_debug and returns 0, add_host(1) creates a new scsi_debug
host in the kernel, and list_hosts(after) still sees ENOENT and returns 0
with an empty bitmap.

As a result, new_host(before, after) returns -1 and ASSERT_GE(self->host, 0)
fails the test instead of skipping for the missing prerequisite. Because
FIXTURE_SETUP(host) aborts with self->host still set to -1, the newly
created scsi_debug host is never removed by add_host(-1) and remains leaked.

Should FIXTURE_SETUP(host) check that /proc/scsi exists and skip before
calling add_host(1)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-drivers-v1-0-a994bd4d3b1a@kernel.org?part=3D11

