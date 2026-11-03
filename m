Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B38A606C86E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 14:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PVuIrc17
Received: by kanga.kvack.org (Postfix)
	id 3E6F66B05BF; Tue,  3 Nov 2026 09:48:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3712A6B05C0; Tue,  3 Nov 2026 09:48:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EDCF6B05C1; Tue,  3 Nov 2026 09:48:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D5C656B05BF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:48:50 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0A0D01603FA
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:48:50 +0000 (UTC)
X-FDA: 85394089620.08.9E54160
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6E9FE14000D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:48:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PVuIrc17;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793717328;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0V+CicgMBoN1QbZ4PU2bDKMr8pvOiaSaM7EPJ1DfD7w=;
	b=FXTjZ9+SI+Sog1/81LFX2EWt0JbCrLST5ja9HTwwLC0PURnQhLgOwPzpIaxuwRCkd6cv/d
	/Ox7VcotxhR61eJEX2tLYV8ZfjsjmgiIYW7dYSIor8oaV8+gVoJEVBvF44ep2URClx/k8c
	vbIREmKd2k7V3qLtCPoVYDTaaCizVlE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793717328;
	b=RQvxXRooMEysddEGhTTkmKsMD742t/cvTOaYzC5rwdCcafc+toyAGTMdIwqQioO2hQhgVT
	GhwZC4NBbfDtxd1fHfGPUIgrN//sENsZ6cj5NGnivUrsvbm0vPIq9DlsYAx5DwizY1B8Mk
	lcyU7fN0feagEudccIU41IorSdUsh3c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PVuIrc17;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 04F2A60622;
	Tue,  3 Nov 2026 14:48:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0571F00919;
	Tue,  3 Nov 2026 14:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717327;
	bh=0V+CicgMBoN1QbZ4PU2bDKMr8pvOiaSaM7EPJ1DfD7w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PVuIrc17XR1DR65SazgbGfICE7wjxOzqZgkY9U1rqo2UnB6kZRbNYqycjDbOYBHPI
	 mtr+oI337If1hGZt23auaywjb3aFf3e8V7x2KLacnHZWCqxTNAHGtZLRjV/QTQa/U0
	 2ZVG3QOmYYo3Vbue///pzGjX2fvcEVYSv1E5A4Nokf1yW93VnBHjLJNY9R0S7cKzna
	 lEsPjbqB4XU52YaxjHh1FMLVvCbZQad8DMHktuK95ryZyb144WX0kMVeswfQ7MIXWT
	 q6wVkMNqoNp3Q2h44ir/sz5Pqydvc1rrrcEksxS0NSkW2lL6OZFvuNnmSZDzSaqv1o
	 ng7I2nNH/acPg==
Message-ID: <sashiko-outbox-195510@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 38/38] selftests/proc: check that a faulting
 readlink() doesn't hold up removal
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-38-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-38-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:48:45 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6E9FE14000D
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: tqtdi8ssprrmx6zcn9pf5uazmh76oqm8
X-Rspam-User: 
X-HE-Tag: 1793717328-707454
X-HE-Meta: U2FsdGVkX1+X9puGdwrCxUFz5DW0Sbyo43uqLYDFmdZyZK7uGPml8QFuyhf/c+VmvMWCBKTBQKXM/UY8I4GgEXeeRbIH+0h6iMGI6bucc+i/n7WD9dUiy/Wyqj+/rHIN/kxPGZ0c6ic26oz70lR7sm/udqm4L79tHIYifHNMTt/we3TLfW3VRAOVIRYP2sKGDDC3sNoVFZbcZk13d4fpds0jT24wMcrRh2C3wvTV/fGGEOF9RlL0sM8GtUMpMVyGujum1oNwnXGZXpAmb7zn5fd31B3yH8qs3JFwmBFqlXCAL/plxU5prr2XbQYRYR9ti7/WOAy/Y5QsW15q8hIkbu/fQx16H3sg24m16OkQ42pkyd6GFK/dOJNYJB5/9VNfO8lm0pHEv/lsh+xWMy59Q6DAOwVOm1s7MPvQEOz/bLYNJ5kgkwpaLmZgeN0oxwjBgIKJ8g2fOnG0gNqmo/TXZ+xqxEK3QMR1mREruF1JBJve8D/WryOcT4TClIwa+NG9Wxr9Km/6zpNfkMSAu5QOG5O/Qso7LFKzWDH4/mIrViyp7AI/Es6BeQdpl/a3vYHuQPs047APrDXCTeN3gBtT3/fxUiIEx/N+o5FgSrU387iK5DEa30nS3vTFXxS4bh8Aep7KE8LdvV4CeOuLkNd+5H8UJCPExCT2C862tFyZ7otDt5snEqHWe2LevMhkhvWqZEXUUxdxSQTHzVyP8h09y+BLxFmW1XflvwoE7A/kjjdwQHxkptyP680U9fREQ4ee3mmJ/J1geezKK+AOCO7s1J8AwJrtqpcpW85mGVQiSmfF4lKJDMjPI7XQ68nRDRh3iJ2kxkeBKkZhIJSbJqU5Ot5zoOLjQLzt6lZmAjIa24RhN2RojlTZC1BUsKKj306yFVSOEkGJm9sD4h0QSraKG/h1RO3DDguKXxqqnSWIdKpTd93clAvjwUbBklGI7oPNcldWyzELPhloszYNx8V
 ftqfyssn
 gKQIP3lDAjSD0iWpi2KR40zTpxgOSJ8Dndffzbz1nGglweQMdCf/JYgd+nMD5rsa38hWpe26nr/mOct7WGNI0d6tMA/SrUw6aTcuL1YCdd+YyD0xO6ZOfm1BRZNQqqzELdlVIq/z6RmKHI0Eg1w9xI7h2w7j/EKH4t0Y6aD3m5i0M4T/IUbeOmqxa+45Xk8yERzqQrPf8pWM+AqMCExDcAa7YbrfNUM/5WdWOx8I35Ej0Rx7kDyn9U1uFnvzixQ1inVftSWjzX8FPxmNhv6nD3ethO/uoVeyy0b3oN8DNneiriZYSRC4vOY1mB6CIeUsD9uBiThguMeBorD1djHIDmtxu0SsdjWJowNKQ+PDuKbnTgBVnZRVd38NVQKoFSxaJuwEtgWryignp/hBVJDVpZX6QH268sa1huU3c8JLn9WFiuFDvXhb6+uhvh90uKaWsetnyRttlqeFaSSUeo5EjuNbY8KBG4vTPQ+d7gVN2N8T7Zc1uZqGjyaMd59tNqug5sZ8RhaA0RvehgTZiWryive+Dl1ZtX7SieLUpAdCZVa7ffHqK4B72pQshTNt2hB6NrDHo8afRyCOWNnRtJqvtqZfs5pDdHS6abADKnAD8fu/IKHQVqBQxHnNdcYHSPuSEaE4wiI7496DCTELLdQXAq1a1WQ075kLqPp/z
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
- [Medium] selftests/proc: Makefile adds nonexistent proc-remove-slow-reade=
r target
--

commit ac0073c08526e8690efa58576485d79bbd906522
Author: Christian Brauner <brauner@kernel.org>

selftests/proc: check that a faulting readlink() doesn't hold up removal

This commit adds a selftest verifying that a readlink() call faulting via
userfaultfd on /proc/asound/<id> does not block removal of the /proc symlink
when renaming a dummy sound card.

> diff --git a/tools/testing/selftests/proc/.gitignore b/tools/testing/self=
tests/proc/.gitignore
> index 7b81334927820..e2566cc0ae079 100644
> --- a/tools/testing/selftests/proc/.gitignore
> +++ b/tools/testing/selftests/proc/.gitignore
> @@ -22,6 +22,8 @@
>  /proc-uptime-002
>  /proc-pidns
>  /proc-remove-slow-sysctl
> +/proc-remove-slow-reader
> +/proc-remove-slow-readlink
>  /read
>  /self
>  /setns-dcache
> diff --git a/tools/testing/selftests/proc/Makefile b/tools/testing/selfte=
sts/proc/Makefile
> index bce6beca72744..6a9bdc999f545 100644
> --- a/tools/testing/selftests/proc/Makefile
> +++ b/tools/testing/selftests/proc/Makefile
> @@ -33,5 +33,7 @@ TEST_GEN_PROGS +=3D proc-fsconfig-hidepid
>  TEST_GEN_PROGS +=3D proc-sysctl-readdir-churn
>  TEST_GEN_PROGS +=3D proc-pidns
>  TEST_GEN_PROGS +=3D proc-remove-slow-sysctl
> +TEST_GEN_PROGS +=3D proc-remove-slow-reader

[Severity: Medium]
Was proc-remove-slow-reader added to TEST_GEN_PROGS in
tools/testing/selftests/proc/Makefile (and to
tools/testing/selftests/proc/.gitignore) by mistake?

This patch adds tools/testing/selftests/proc/proc-remove-slow-readlink.c, b=
ut
tools/testing/selftests/proc/proc-remove-slow-reader.c does not exist in the
tree. Because the default all target in tools/testing/selftests/lib.mk depe=
nds
on $(TEST_GEN_PROGS), building the proc selftests fails with no rule to make
target proc-remove-slow-reader.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D38

