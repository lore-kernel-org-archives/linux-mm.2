Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAAF8606A32A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 05:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SAKS3ST4
Received: by kanga.kvack.org (Postfix)
	id AF4C26B00EF; Fri, 20 Nov 2026 00:58:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA5FD6B05B0; Fri, 20 Nov 2026 00:58:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94BF26B05B1; Fri, 20 Nov 2026 00:58:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A3356B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:58:13 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A5AD4160D6B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:58:12 +0000 (UTC)
X-FDA: 85454442024.21.9C84BF3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1627AC0005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:58:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SAKS3ST4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795154291;
	b=sSVZukjLXeTMDMnYRGtaS3eNss7TIlT84za3ESFcbSp21k1WwPcEIGF28fKOvkxWTScEs5
	H3u9UMo5azLWsoourXj1xiBlCgvq2A4XPomGw+7e2Utw8rSyIYmcrqC74gOmRBoOknuC88
	2E1Yc9n/uqHbfCA6kjaW6r7j7DX3d5U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795154291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3J4zWN2xZSuepJxvtOxZd6Cv2PFcMo5B56sR2qMDpP8=;
	b=OOReZmShwR8C/acUtVLiWP//pp7f0ZgWZ3ymgdJIz2PjOUDAK0mvjOEyGA9ujeO8yDLEVs
	W8eaxPxi5siatX1ULKEIWltGGibmHleLifvutgwmNOA4XKZYABEDf+2L34Cb86/7L5D5gm
	0LOrZLHuidOrJVvRH/BRV5Fg1qy+3fw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SAKS3ST4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 4C5816211F;
	Fri, 20 Nov 2026 05:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 535581F000EB;
	Fri, 20 Nov 2026 05:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795154290;
	bh=3J4zWN2xZSuepJxvtOxZd6Cv2PFcMo5B56sR2qMDpP8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SAKS3ST4i7tiUXuSP7l7klGig8K851mCaNcA83yfT7HS5evQwuV9pHxHXPYNRVoBN
	 OECH81IdbXkatDGtQDTEbZ0S0zjQEdVbnmzdw9mOYz1Xg30Zaplgj5W19nP62y6YlV
	 Tri0TfVHScfjfdkqkwMEqDkkVdZoLgLFmUKDwq/GJAQHq+lyIRFPSxG1deSxZD/b8w
	 aozC4d3ZTBXnBMBMor/w9ZkVSDiVqdnfcfimj2dN+sC1cm0iMw+VPyVRobRXELJYS6
	 2S8q7BhHWzui3oDk1v9py06mOrro/JTr5AlYK88Mj3Em8Yv5p5dWVOcoaGbo7wvjA3
	 aTGgS+xSE9t4w==
Date: Fri, 20 Nov 2026 07:58:06 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Andy Lutomirski <luto@kernel.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Arnd Bergmann <arnd@arndb.de>, Ben Segall <bsegall@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Christian Brauner <brauner@kernel.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Chris Zankel <chris@zankel.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	"David S. Miller" <davem@davemloft.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	"Hallgrimur H. Gunnarsson" <halg@google.com>,
	Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Juri Lelli <juri.lelli@redhat.com>, Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Matt Turner <mattst88@gmail.com>, Max Filippov <jcmvbkbc@gmail.com>,
	Mel Gorman <mgorman@suse.de>, Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>, Neal Gompa <neal@gompa.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Moore <paul@paul-moore.com>, Paul Walmsley <pjw@kernel.org>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Rich Felker <dalias@libc.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Serge Hallyn <sergeh@kernel.org>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v4 00/14] Namespace for namespace roots
Message-ID: <av_hbgzwo-1FcAPZ@kernel.org>
References: <20261119224312.1037966-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119224312.1037966-1-jarkko@kernel.org>
X-Rspamd-Server: rspam05
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1627AC0005
X-Stat-Signature: kr5i1184f8rq4e6kbczqitoboe76qyqp
X-HE-Tag: 1795154290-867666
X-HE-Meta: U2FsdGVkX18uE3btYd0+z99sCSJTWLX7iVWrpjxJ9jWMh+ttxfFo6ZZyhsekX6swaWV5Fvq0lEmdjUbAuAnbkaTVt3o24GbBvo71bsIVmdthmpSWTEC0CZUzBvd7DlirWpTujDBFv+iUh/PlfFqKXrsAaOnbHDMimSQnfZ6n8x2uSn36tRGDNlDcjgYj0NCeTs2rC412kW27mZBbG5flOjxxFOjBV+NoDp4e8rdn7u+AQTfkvAer4QXpAm7P7SWqkWEIK8BPMpLmVIRC5VMR7lmYdZAtMuV+5NWdhWFpWTOSE59/bjVAw04rFlOKhoAPdJPv6S06+LudPVygEKl6LjSYfxpcznmyYHvDrKigUqmCsDbR0jFd/W5D2TF19Uofak/Wuti3P5DejITYfybfpK0rvb8OrQrOpP5dcftk0KfMof/uHqkQZBuqcs8nI5sdWHUGdqfWBzlSloy/cHK/end7G8uwSJwBl2Q/rnwzfRLb5mgbyA668i+JTCM3LDLDREMwfzQ5I+moH4nGTU9a2AABbqMIC5ZLNNE/o8i+uKWQKmxaeDc8HWXZ5AAMttLhCLMxzgGOyBhKMrHWS8r3UAeQ3KHtMStQPPeUnXrJoIwfnHa8W716KdTnubZAMeqLhbudXWGRyRJVfsABKirGa9D0KbcLgC9cP4+XQ1H5n1Wfh7ULPc+0UrajoQHalg9L3gLYfaJ9e8hjQOc1983C752Ky/wQUZAYH+j9atYX8c0GyaC3tTfnT6/4V/S3xOlg7tSfNkUesOWfHXFd5ZRxQtFgRsMWKZ9aNEb8xBHOIZUD8pArhtVjfDyyl0OUTClIu745wEcAYDo8Xxx8PRMQ15m7r20WgH/8Vogk6a+NBhM8j8DBIS1PbzCJa3JQ94vqLbYaIAeqWlIvYdU/3zy9I2+z3KypZc5a1/uCgLblLEtoPiKHfVx8BojlbbgUj3jp+DpmE18CtGyzyruN4zi
 7ulLZ+4Q
 WqamiPR1Cg5ffjAagJhJ9VdvEouVbSQT/fanD/flEZrdrOmVgYjes+D+K0GetgPql+dQ+sPTR5nqZEKQEcOr6P94s6JnXl9eBG3ORF/A7AgnAtq/2cZYxHRt0+Nr10HKyjg0JNbV/FSqD8YLIuekqyPwrQnZ+Tgcv8Kcwt5HYg7bcAXPduUAXxKEO3LaKx94iqXaQgYB85BWctW6VQHtmfV/P+4lJus1M2Vvau/Os4wvLZQqJO5otNy1CTVvSCM2qy8yx9ulq/M4wIYUSNZoGOTVR1hefINzQKm8lWgQ3fkzJmf9nhh7L70+4j6GYqPBPfK1AFNrWIxbj6ZUvSz0GQbjoHEBuywvaVFaCTiLdAFifwNbNlaE0lhEZOGhVaJITkTzNpCA0HMJfR8kq9F027TLYS/dYgrkGm3R9447JVHfzdQFIuFkBrPquix7Jvveq/V5MXlD2nUJOALl8IBKcQA+WiZAdceCcWcRJfPQu572F4dw3zf9Its1O1tmZR2+yX4Ggb1sdNAm8EKY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 12:42:58AM +0200, Jarkko Sakkinen wrote:
>   nsproxy: Pass nsproxy to create_new_namespaces()
>   rootns: Add core infrastructure for root namespaces
>   rootns: Track init lifecycle via copy_process() and pid_namespace
>   rootns: Add rootns() system call
>   rootns: Add ROOTNS_WAIT ioctl
>   rootns: Add ROOTNS_KILL ioctl
>   fork: Support CLONE_INTO_ROOTNS in clone3()
>   fs: Support FSCONFIG_SET_ROOTNS in fsconfig()
>   fs: Support MOVE_MOUNT_T_MNTNS in move_mount()
>   security: Add rootns LSM hooks
>   arch: Wire up rootns() system call
>   docs: Document root namespace uAPI
>   selftests/rootns: Add root namespace test suite
>   MAINTAINERS: Add entry for ROOT NAMESPACE

Since David's picking up patches, and starting to drill them, I've not
paid apparently enough attention to patch division. Just noticed when
I had hard time finding mqueue and procfs changes.

I've now re-sliced these into a bit more sane pieces:

$ git log --oneline master..
d8e24a6bc14e (HEAD -> rootns, origin/rootns) MAINTAINERS: Add entry for ROOT NAMESPACE
f2569e56a267 selftests/rootns: Add root namespace test suite
bea05e758f8e docs: Document root namespace uAPI
dd05a49aff77 arch: Wire up rootns() system call
2dee7a5fddec bpf: Register rootns LSM hooks
73c51e02b830 security: Add rootns LSM hooks
3cfd6576a037 mount: Support MOVE_MOUNT_T_MNTNS in move_mount()
9ed7387038ea ipc/mqueue: Implement ->set_rootns() fs_context operation
624f0ed9c1c7 proc: Implement ->set_rootns() fs_context operation
1085e6ae2eb3 fs: Support FSCONFIG_SET_ROOTNS in fsconfig()
d2898dbdc39b fork: Support CLONE_INTO_ROOTNS in clone3()
42dbccb5890e rootns: Add ROOTNS_KILL ioctl
14cbda3e5bca rootns: Add ROOTNS_WAIT ioctl
b2cc82539b75 rootns: Add rootns() system call
d29215aa7f0f rootns: Track init lifecycle via copy_process() and pid_namespace
0f9ce7febb49 rootns: Add core infrastructure for root namespaces
7a0e8f969fc7 mount: Enforce mount_too_revealing() for foreign mntns
8c61aee3afbf mount: Add mnt_ns_get_root()
07d239d0287c userns: Factor out install_user_ns_cred()
bf74588e706d nsfs: Add nsproxy_open_namespace()
645d31a1c516 nsproxy: Pass nsproxy to create_new_namespaces()

I would also divide "arch: Wire up rootns() system call" into multiple
patches, if this was not an RFC.

Br, Jarkko

