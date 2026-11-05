Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C69B606B9E6
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cC58zNRz
Received: by kanga.kvack.org (Postfix)
	id 47E456B05BE; Thu,  5 Nov 2026 14:30:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42E6F6B05BF; Thu,  5 Nov 2026 14:30:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31DA66B05C0; Thu,  5 Nov 2026 14:30:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C4736B05BE
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:30:26 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8BB6A80984
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:30:25 +0000 (UTC)
X-FDA: 85402056810.11.B0E1DAF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id C396E40014
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:30:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cC58zNRz;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793907023;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fWBORYPn6/i1UGDhFg9BaDP0viM8Zy1xYrqG6aqMLCs=;
	b=YhHz8JHI0UcNASKYyDTAWh3+C+RuVGKLSb4ZrD99Pn6PvdXLvv+UerFs7oluXfC1q1z+15
	u74H1fN+V9ggsxOvjDWTNz6JFtZay3Ou9LggZnFECc6Nm69Bd7WMySGQd6vkCUPER1EDQp
	TolCI7hExbi2PwNLm+Vbtl+iTKTLpac=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793907023;
	b=uUpixDQRTD/cgSJkmVOiriWyWTHtkJvkCkd1QDRj1yRv6Mm4bZ3BaHTowt/sc1Kn7UREAT
	+kpnG4TFkp1Q1iYT794JVN0sP1EoCH5id8YnCgz3yjrgCRVlLnGETWuhGbrTDjprq2m01H
	tf9HjQZzwLxStiAksRSw+jpGn9IdqDA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cC58zNRz;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 153244108C;
	Thu,  5 Nov 2026 19:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20631F000C1;
	Thu,  5 Nov 2026 19:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907023;
	bh=fWBORYPn6/i1UGDhFg9BaDP0viM8Zy1xYrqG6aqMLCs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cC58zNRzclL+bqWmFXm5jJss9grSFRNwu88igA3PKBCqEyRDhY2ITvGQVUDEPAijP
	 jc6EoImewJYAZeqNGxexTBcbXnIYrSP7cSjUbXV1pz/HzU27Iu4eyLpGA/mmB75GEJ
	 Mn/pLMLT3OA10M3sQou5NayTSnUUzk77VngzaE9sBLAsEd3IdtCBVhgIPLYs3hgSxI
	 s4cHJ5Csz2wq2CZzuXzn0ag28Cn7YJO/RX2qYjDwC/dec6cnK4P2MZKghUHrp1JdY2
	 VH7rOBjE/sAe72AY4GXbLOvjFtttoNkBV+HgMrjt5Pyq1LLAAfjEG7EQr2rtiIdsRA
	 yRfo09CVnuQmQ==
Message-ID: <sashiko-outbox-199908@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 45/51] selftests/proc: check a sysctl listing
 while entries come and go
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-45-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-45-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:30:20 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C396E40014
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 41hb9jz1s68xcj4hce1udzu5esx9zgoa
X-Rspam-User: 
X-HE-Tag: 1793907023-328434
X-HE-Meta: U2FsdGVkX1+k4pFDlJvpAa+b5x1CYVEy2Hrgq9GRbIq/n03Cavw813DXrkghQEcecUrdlDeKgRdQnXCZ05vrt97XCQgzvBWxT1946baH+Gl/ZfAYkkdIMUFFo33rjMme5zvo/4/ioU6fQusv7jS15kfV+oAcut+ocErco4lVy7p9W7CJ0nm8rJr+CrHUtYm8q6E7mW5IeK6q0ZO8wBPkYHgdXr1pRADgckxaOZAOlKLp5FPSr3HK6U4LtGqtpzFxgP87yyouZt+mz8Xs8rDW+O00m87DiYt5vxCD3UTbivKHjeJNHp0tn+04LIQ4ZE4UnUKOUf1RQEM4SzE/p4476EY9SJGocdRrDHH1UnFioriPrF4DwPwZOz1mNJ1bbFjwTs/BSbulTjpuMOMoS0fQQnVVp5/wzjMiJ5TSLIqxdr82Afmrci1EKLjaiTTSShl4EXslBRp5Vj1rPPcQnCewIsfKNx/K+tFwrapMFmajBV8J+sgBOEPFENgKpqmUrewdorpnNGISIyQ+RnTPIq2Wwvwdzk5hrzlhfrU79EXbWh/3ZXnrmIHOVL0euIghmilUr9H0wSku6GDda1exLge3alOEP1UIZqtq02p7vRtY2sJT1h1crm5wqYKKa9EVtA8pueQf7MZeolGzXG/7RoCQcfUvDxX7cUM1smIgY66m1BoYL/tM+HHe9+bwCY+0KtK8dyTZMhaQ7UENT56J1m4L7GYwQKCozt+LKceIyrfgiU93vzFkvFaID6kW7HiJA3S1uRhujuRNRzkSsMLVqAVI6f4FNUXwXr3CJ/2R1AYIsWDAstXL1Uq5T4i3FSNUqfEm0jamaGXAR6CkVTZp9IBWJSBe/T/UorzdDPjUhOZ7+eLO513Mu4dh/fpaFglv9OkSqK5jMlDfvHQfT+KbCVI2+9Nb2dVBL1bwZ7fP+QxwNd3/tIb47ygZQrT7SsSBgr4vX0iqbGGt06pMUknBOQI
 dx76zhSU
 GqEUYuptqzd9MRjnCtM50KQM1iBSc/YUqaR7CKtVHfc0A7j+Czrw58gSlmKIlHI/Ggd+W34O/Lj4gyB+a1zqlIyhOWaVMONA2gcfOXkGrwKHLIReWerMdjJvhXiLRXCwfyCh4IE2SiXEUyqB6uPpD5ykO8snTUBOJaKXMhdvZhPKbKmief3Udguu4aoYWmpGLX3xxfexNr3ED96V2JhgaA/2z+xfBxwNjBrvo3/Av9f+k3smBUi4nwS36ZuVUrMP+i0Ix8/SIkDy6tnwDyBFX7LVJpm+DrQHNQx4fksJeiDARW73ujoiRpsdnE6ZvM5FhSREu3ZYvoJevrY3/MRifCb1szu0dc81LuB51ZSmyku1jrah6epL9I5sT6HtMM4ubZJu27toP4p0RdsA3MbSM/bSEo28PGyYCpDJXydfqf0J/fPHHH+jJ69OEqpIjk6mZfPcgodyVrFSEd8AdPTmYYBGigrw3PKPwdlLlDg/mh3NTVxcTrSsTQ4pcyVWKf5mZh0kGMnElLKCNmpElRIqtkAYBgh0qlx3230u3wBObwmkFm2L4c91X0pLh57lJvffCWDtaC7us+VTzWxFRx5fsl8vCx6awoUne+ZyXYjiXKv+ETCWwRSvJCkk580FpmUsqNiCUTxkOiIbkwcKUn4ry1oB8cC5uIAt9on2e
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
- [Low] selftests/proc: duplicate readdir churn test in proc-sysctl-readdir=
-churn.c
--

commit 89d111e3f559a343f6b04af3c2c0857d3d1f5a29
Author: Christian Brauner <brauner@kernel.org>

selftests/proc: check a sysctl listing while entries come and go

This commit adds a selftest in proc-sysctl-readdir-churn.c to verify that a
multi-call getdents64() listing of /proc/sys/net/ipv4/conf does not repeat =
or
skip entries when a network device is registered or unregistered in between
calls.

> diff --git a/tools/testing/selftests/proc/proc-sysctl-readdir-churn.c b/t=
ools/testing/selftests/proc/proc-sysctl-readdir-churn.c
> new file mode 100644
> index 0000000000000..b2ad097b464aa
> --- /dev/null
> +++ b/tools/testing/selftests/proc/proc-sysctl-readdir-churn.c
> @@ -0,0 +1,152 @@
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
> +
> +FIXTURE_SETUP(sysctl_readdir)
> +{
> +	int tun;
> +
> +	if (unshare(CLONE_NEWNET))
> +		SKIP(return, "unshare(CLONE_NEWNET): %s", strerror(errno));
> +	tun =3D open("/dev/net/tun", O_RDWR | O_CLOEXEC);
> +	if (tun < 0)
> +		SKIP(return, "/dev/net/tun: %s", strerror(errno));
> +	close(tun);
> +	self->dir =3D open(CONF_DIR, O_RDONLY | O_DIRECTORY | O_CLOEXEC);
> +	if (self->dir < 0)
> +		SKIP(return, CONF_DIR ": %s", strerror(errno));
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
> +	ASSERT_EQ(access(TUN_PATH, F_OK), 0);
> +
> +	while (list(self->dir, self->buf, sizeof(self->buf), self->names,
> +		    &self->n) > 0)
> +		;
> +	EXPECT_EQ(count(self->names, self->n, "all"), 1);
> +	EXPECT_EQ(count(self->names, self->n, "default"), 1);
> +	EXPECT_EQ(count(self->names, self->n, "lo"), 1);
> +	close(tun);
> +}
> +
> +/* a device unregistered in front of the position doesn't skip an entry =
*/
> +TEST_F(sysctl_readdir, unregister_in_front)
> +{
> +	int tun;
> +
> +	tun =3D tun_open(TUN_NAME);
> +	ASSERT_GE(tun, 0);
> +	ASSERT_EQ(access(TUN_PATH, F_OK), 0);
> +
> +	/* ".", ".." and the device, "all" doesn't fit */
> +	ASSERT_EQ(list(self->dir, self->buf, SMALL_BUF, self->names, &self->n),=
 3);
> +	ASSERT_EQ(count(self->names, self->n, TUN_NAME), 1);
> +
> +	/* closing the device unregisters its sysctls under RTNL */
> +	close(tun);
> +	ASSERT_EQ(access(TUN_PATH, F_OK), -1);
> +
> +	while (list(self->dir, self->buf, sizeof(self->buf), self->names,
> +		    &self->n) > 0)
> +		;
> +	EXPECT_EQ(count(self->names, self->n, "all"), 1);
> +	EXPECT_EQ(count(self->names, self->n, "default"), 1);
> +	EXPECT_EQ(count(self->names, self->n, "lo"), 1);
> +}

[Severity: Low]
As reported by Sashiko on RFC [1], this isn't a bug, but tun_open(),
list(), count(), the fixture state in FIXTURE(sysctl_readdir),
FIXTURE_SETUP(sysctl_readdir), FIXTURE_TEARDOWN(sysctl_readdir), and the
register_in_front and unregister_in_front test cases in
tools/testing/selftests/proc/proc-sysctl-readdir-churn.c duplicate the
helpers, FIXTURE(proc_readdir), and the add_in_front and remove_in_front
test cases in tools/testing/selftests/proc/proc-readdir-churn.c, differing
only in the target directory (/proc/sys/net/ipv4/conf vs
/proc/net/dev_snmp6) and expected entries.

Should these sysctl cases be added to
tools/testing/selftests/proc/proc-readdir-churn.c (for example using
FIXTURE_VARIANT() and FIXTURE_VARIANT_ADD()) rather than introducing a
separate standalone test file?

[1] https://lore.kernel.org/r/sashiko-outbox-195504@kernel.org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D45

