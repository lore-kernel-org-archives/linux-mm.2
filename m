Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D48A66082BD3
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 14:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I1YHc/Mt
Received: by kanga.kvack.org (Postfix)
	id 260CD6B05BB; Tue,  3 Nov 2026 09:48:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 213B96B05BC; Tue,  3 Nov 2026 09:48:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08B516B05BD; Tue,  3 Nov 2026 09:48:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BB29B6B05BB
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:48:36 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4F12BA0471
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:48:36 +0000 (UTC)
X-FDA: 85394089032.04.E3C7D46
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id C393320003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:48:35 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="I1YHc/Mt";
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793717314;
	b=05PTBYERdgU1pBQIbIDLf4sEM5YrR7EUVyS31x9w2ycwZipMeP9+qayr2Q4NhoSQL/j1TA
	IWE+tbFbXywNUMyNAqx1ZOq4wW2NpPEzJPvONRDvkhi4FNY+RruzwhO3mgU3YBFZWKyTWf
	y2NvsXvvZjSM2IQ9EwhwIJeFJAIEneY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="I1YHc/Mt";
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793717314;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y+bptWnMsm9688ffvlZik5wuheu2AuAp4FHdf42AsHs=;
	b=DB/sFo8AfdwiR6sUk7vKdjbvcOx2h+95aPKI2ECy0JdKXGIhFNStR9/MC8GvBoyEVeuwJt
	hrkXlRmw61bzR/PlS3KkXFnCChUCt88SN46PiLTLuK7ttH9VvQFmmBUYw2vrGKs4qE5jr8
	hCwKzeGL3kJ8o+z5zEKShgQ2JJadLbc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E94064018B;
	Tue,  3 Nov 2026 14:48:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C941F000C1;
	Tue,  3 Nov 2026 14:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717313;
	bh=Y+bptWnMsm9688ffvlZik5wuheu2AuAp4FHdf42AsHs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I1YHc/MtZN8GDa7UIDwX7EZbAGqySvUQ9iJMmqHpFghXtS1a7u1snUSRoQZbPgotf
	 rzTS20EjRbQSiraVWbKDq4ZCE++cNFCKRi5Aaifb5wigRVmBCmMaDT7YdKMsDB9tDI
	 EKZhwJ8mtHIR7tJTtUGX8l08CJRlHDCymC+ysWL+tDYTrAJTPYswbt5itzEnPuNwmU
	 0VvXfu6Z2XZnOqblVvT6wHfP6+iohenxq+H4qRRnC04rlzIf4Onp6n05i56McAI+1Y
	 TqDE/PH+7Hpp+X7zYzUT3YtEtnTjOTA8j+Z92u2V2zFKtu1xuQnbMQURmWoACjuOYC
	 jjzKWAkws/G0g==
Message-ID: <sashiko-outbox-195504@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 32/38] selftests/proc: check a sysctl listing while
 entries come and go
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-32-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-32-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:48:31 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C393320003
X-Stat-Signature: 5f9azxkdri4scgnc5j8z4ccgtsx343nj
X-Rspam-User: 
X-HE-Tag: 1793717315-475770
X-HE-Meta: U2FsdGVkX1+pnbx2P3S7aeIMphf8vXaJCaH5seVlBx2dCNhSJ+AU8RAcJW8Cg7bC8R8MzrMxdojoZYictoMuJZnO7Sze6/ap0uEVFf48bLq6MyOtQYtnO0RH6IXWKX/hqmKsJq93NISXUoRANS9kTY9Fk5qAgQgz7TTrj+OrE02d7JkLToT3hZuQlhPY9IHsN2graOB27G339hP8zhMMdEhOUtJTokQJq7SGkbQBRMsHDeIhrtS+wgaxCTJHTj1dkkfmqLZ4fnWM7+EwayiGa7izek+ugP8AQOBM2pyOVD86Xd44cvzyH1vGVGJkSIUy+XcxvTavM+/7I6vadwqZQZ5brvicCesAGC/fbOl+opGwR4LKNIieBW83LdUTq5ZpYxfXVxbwwPtaEmKPehg/C1sfhYBHnilSLPds//VmrONCqcXyceakDHMk3msfjOK598/SO4zbbsLaWqu1ZCfb3Jt9MpSVwr7ewOVgN1efm7lFWRdC3ztioXaxQNWfCFMGw4/lvb2APSQXuqAjgc9pCg9/88e+8HJhsmxie594ulwQpaw0OJEyv4cUnyiEEg7Thev1Ge1pevis9hkCj5XRE2ZsYIcaKkWEDx6qemtJTurcMUi/mVoBlLJStKnt7f0HmE7vQbByGUU41ZLmMxeqNi2n/C015iJ/dL2InQFh3cvYHpyRdIRGBwwuIdvv/Pv52zv/TtLp065wR0hD+MJx8fhhOF7REtsnwDsiBGv/9Zd2EqKX2mlGcxhAdnoueaK3tO5zl0hrtbMgDBaCYZg44DV9d/buq/Sxu/kwoVhaAxHxEAC0dl4BFfgnq8L5fyTVvXdTBTqqdDifiSfhIT/wSP4FmFz/G577tTm4izbGGGiX2DwRXpazkYy19kSIQ2H9sfSLGRK8EYuF5jYM/1ZaPjiz1YV5xs3B2C6BKbiDYqZ80SNnAqrb6/PuPvoXa8oDPW6abRXDRH4Lwzt+UOv
 zHaUvboo
 Hfx6lzFYKuKlJ2tGCV9YVD0WHfvTt3/bKnGfCpJ49s+f+JGDm5704gCknPxXe9frWwzhN8kn0NJgXWW3XRjmyO6KcFCTQgF7Q8YnqBCL/hF9fsGTWyf6WcZjK5m+e0Y3SdflVoOPGzXJyb2DMs111ZTjfF3czjXnC/mGTXwsMnhtUHEtB4ILQKYlTfLLdrhdcyc19KdrztqL8QmCZGOJJF1oKOF379cJVWuNS5BaJ8PM1ooRdXIU2VEMK9/X1tSpEbNz7KWytH9xaFuCLJVksawBM9a2lXmFU11brLUjJBU19yEKKqb+ViiubCHB9Of+3DXwsPe0m8aIao2lbgcqBeiY6EfOQEZ2iVRuNuPave3rUQXsGkdx7+0O/bsMixhuJAGgaPqEhwkrDT8oNP0TcPjMqNbbHxE41voFMEk2hGWrM+FPHBFVmW5rWgYp+rtMvyvUEE8c6Mgq25Qh4WvY2TwpOFV9AzvNGB0upHUSg9j5/jOK4OjusI3OV7UxhLzdOZsdOoh6FUkVHajr2KACyBGznBMeS9fFKlfNnTBb4dI+SBCJ9ZbkeOpu72V+mHdWk+f7v50cEAYfjzsIXsORjg9ZmIOv6T/5gGo+c/A9/mEoCKCQgeSDDnFc+7BB/grpXAosTxjnxcv03/iDLwWf6OYk7FjdGyEDfwZuM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] selftests/proc: missing prerequisite skips in sysctl_readdir_set=
up()
- [Low] selftests/proc: proc-sysctl-readdir-churn duplicates proc-readdir-c=
hurn
--

commit 9b75f87bfb2fb1adbf5b6ac83f3bfdac725df7f5
Author: Christian Brauner <brauner@kernel.org>

selftests/proc: check a sysctl listing while entries come and go

This commit adds a new kselftest binary, proc-sysctl-readdir-churn, to veri=
fy
that multi-call getdents64() listings of /proc/sys/net/ipv4/conf do not rep=
eat
or skip entries when a tun network device is registered or unregistered
between calls.

> diff --git a/tools/testing/selftests/proc/proc-sysctl-readdir-churn.c b/t=
ools/testing/selftests/proc/proc-sysctl-readdir-churn.c
> new file mode 100644
> index 0000000000000..0e067a3619c44
> --- /dev/null
> +++ b/tools/testing/selftests/proc/proc-sysctl-readdir-churn.c
> @@ -0,0 +1,147 @@

[ ... ]

> +#define CONF_DIR	"/proc/sys/net/ipv4/conf"
> +#define TUN_NAME	"a0"		/* sorts before "all" */
> +#define TUN_PATH	CONF_DIR "/" TUN_NAME
> +#define SMALL_BUF	80		/* ".", ".." and one short name */
> +#define NAMES		64
> +
> +static int tun_open(const char *name)
> +{
> +	struct ifreq ifr =3D {};
> +	int fd;
> +
> +	fd =3D open("/dev/net/tun", O_RDWR | O_CLOEXEC);
> +	if (fd < 0)
> +		return -1;
> +	strncpy(ifr.ifr_name, name, IFNAMSIZ - 1);
> +	ifr.ifr_flags =3D IFF_TUN | IFF_NO_PI;
> +	if (ioctl(fd, TUNSETIFF, &ifr)) {
> +		close(fd);
> +		return -1;
> +	}
> +	return fd;
> +}
> +
> +/* one getdents64() into @buf, the names appended to @names */
> +static int list(int fd, char *buf, size_t size, char names[][NAME_MAX + =
1],
> +		int *n)
> +{
> +	long ret, off;
> +	int got =3D 0;
> +
> +	ret =3D syscall(__NR_getdents64, fd, buf, size);
> +	if (ret < 0)
> +		return -errno;
> +	for (off =3D 0; off < ret;) {
> +		struct dirent64 *d =3D (void *)(buf + off);
> +
> +		if (*n < NAMES)
> +			strcpy(names[(*n)++], d->d_name);
> +		got++;
> +		off +=3D d->d_reclen;
> +	}
> +	return got;
> +}
> +
> +static int count(char names[][NAME_MAX + 1], int n, const char *name)
> +{
> +	int i, c =3D 0;
> +
> +	for (i =3D 0; i < n; i++)
> +		if (!strcmp(names[i], name))
> +			c++;
> +	return c;
> +}
> +
> +FIXTURE(sysctl_readdir) {
> +	int dir;
> +	int n;
> +	char names[NAMES][NAME_MAX + 1];
> +	char buf[65536];
> +};

[Severity: Low]
This isn't a bug, but tun_open(), list(), count(), the fixture state in
FIXTURE(sysctl_readdir), and the register_in_front and unregister_in_front
test flows in tools/testing/selftests/proc/proc-sysctl-readdir-churn.c
duplicate the helpers, FIXTURE(proc_readdir), and the add_in_front and
remove_in_front test cases in tools/testing/selftests/proc/proc-readdir-chu=
rn.c,
differing only in the target directory (/proc/sys/net/ipv4/conf vs
/proc/net/dev_snmp6) and expected baseline entries (all, default, and lo vs
lo).

Could this be parameterized in proc-readdir-churn.c using FIXTURE_VARIANT a=
nd
FIXTURE_VARIANT_ADD instead of introducing a second standalone test file wi=
th
duplicated helpers and test logic?

> +
> +FIXTURE_SETUP(sysctl_readdir)
> +{
> +	if (unshare(CLONE_NEWNET))
> +		SKIP(return, "unshare(CLONE_NEWNET): %s", strerror(errno));
> +	if (access("/dev/net/tun", F_OK))
> +		SKIP(return, "/dev/net/tun: %s", strerror(errno));
> +	self->dir =3D open(CONF_DIR, O_RDONLY | O_DIRECTORY | O_CLOEXEC);
> +	ASSERT_GE(self->dir, 0);
> +	self->n =3D 0;
> +}
> +
> +FIXTURE_TEARDOWN(sysctl_readdir)
> +{
> +	close(self->dir);
> +}
> +
> +/* a device registered in front of the position doesn't repeat an entry =
*/
> +TEST_F(sysctl_readdir, register_in_front)
> +{
> +	int tun;
> +
> +	/* ".", ".." and "all", "default" doesn't fit */
> +	ASSERT_EQ(list(self->dir, self->buf, SMALL_BUF, self->names, &self->n),=
 3);
> +	ASSERT_EQ(count(self->names, self->n, "all"), 1);
> +
> +	tun =3D tun_open(TUN_NAME);
> +	ASSERT_GE(tun, 0);

[Severity: Medium]
In FIXTURE_SETUP(sysctl_readdir), opening CONF_DIR (/proc/sys/net/ipv4/conf)
is checked with ASSERT_GE(self->dir, 0), whereas proc-readdir-churn.c skips
when opening SNMP6_DIR fails:

tools/testing/selftests/proc/proc-readdir-churn.c:FIXTURE_SETUP(proc_readdi=
r) {
	...
	self->dir =3D open(SNMP6_DIR, O_RDONLY | O_DIRECTORY | O_CLOEXEC);
	if (self->dir < 0)
		SKIP(return, SNMP6_DIR ": %s", strerror(errno));
}

In addition, FIXTURE_SETUP(sysctl_readdir) only checks
access("/dev/net/tun", F_OK). On systems where /dev/net/tun exists as a
static device node (for example, created by udev or kmod static-nodes) while
CONFIG_TUN is disabled, access("/dev/net/tun", F_OK) succeeds, but
open("/dev/net/tun", ...) inside tun_open(TUN_NAME) fails with ENODEV or
ENXIO and triggers ASSERT_GE(tun, 0) in register_in_front and
unregister_in_front.

Since tools/testing/selftests/proc/config only enables CONFIG_PROC_FS=3Dy at
this point, will running this test on a kernel without CONFIG_SYSCTL,
CONFIG_INET, or CONFIG_TUN fail the test instead of skipping when those
prerequisites are unavailable?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D32

