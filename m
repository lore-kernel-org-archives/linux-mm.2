Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03F6560A263D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gpYfA8iv
Received: by kanga.kvack.org (Postfix)
	id 22A7D6B05D1; Tue,  3 Nov 2026 10:01:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 203756B05D2; Tue,  3 Nov 2026 10:01:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1404A6B05D3; Tue,  3 Nov 2026 10:01:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EFB8F6B05D1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:01:22 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 725291A0484
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:01:22 +0000 (UTC)
X-FDA: 85394121204.19.5505E98
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id AF4941C0021
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:01:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gpYfA8iv;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793718080;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pruwCsX2Nj8P2A3ZkDZfqhhveDP+NyBs8rSomhgGUU8=;
	b=e0Rm4AOdJwflgXGvBdkbH2Op6ih/L7l0fJJaB9i9i69ie6TotGe6U8jtfbsimHIWja2+4M
	ZyOmZqqzwNTR6QoXz+LmdHa145QbitRi7UDiBeoBujc8jofHLz9T3Qz6CrUnhhpKbhkmKU
	PjHLbIfnMm/dv57H4mszkW/cbfC9SVg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793718080;
	b=6c2+ePMq0YDEvQej/I52S+F/rNL0Q0dXW0Use2Hs2ITNaf9NqnAr+IL5HYKZuWeOvGOtGb
	cGBbAecQ+AeoqCNcG+sUB7lWi6Wa9Dc75sjrvxjzPA7b7Jl/jbnAgT7U/BBDPlFwcEbanR
	b5ayPxDvxJGoDB0Lv+C6pZhu5fPHjl0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gpYfA8iv;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 19CFD609FB;
	Tue,  3 Nov 2026 15:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD2A1F000C1;
	Tue,  3 Nov 2026 15:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793718079;
	bh=pruwCsX2Nj8P2A3ZkDZfqhhveDP+NyBs8rSomhgGUU8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gpYfA8ivu0EAnWhduZFmphtcIFZSGsJJkhZlvzy5YyKRExQz2lKkkw8OFY07G7zhl
	 QXK+/wAx2e3lUZBCumPvDuR1/CWFBc91Z6WG2Hpe/KA3keAWuqHeKEckj6rl+uRvUm
	 0DD2mqqO1kQPWJtMH9mgPG2OwfUnYuJ9j6ikz9y+dNaFMbCTYjhiXpIP4eWCi5yjYi
	 Hz31AyUaH/D1IdodghQ/+cQxG+cvoF7GjEMSxwIAcogBIdrkyj4oC8VJmOIa5uaDa8
	 BqiLNz4agF5A0jKeip5ntCNO+LfhUsYbiRyktw0MpTevQA8rbeHsgsbIZcoz3mCr6C
	 TOSw9p+fDzh/g==
Message-ID: <sashiko-outbox-195535@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 08/16] selftests/proc: check that a faulting reader
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
In-Reply-To: <20261102-work-procfs-core-v1-8-75df35e4f8b8@kernel.org>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
 <20261102-work-procfs-core-v1-8-75df35e4f8b8@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:01:17 +0000
X-Stat-Signature: cmb8qc3a83f8cezatsc5j7sgn4nap6r1
X-Rspamd-Queue-Id: AF4941C0021
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793718080-662246
X-HE-Meta: U2FsdGVkX1+Cf7KKhQ5PWjTpp2kPvBQ3B8Lhz0ON3vxZ3sETgbeCHrKU3iQtQJHiPYqMxi42xWIElJFzQCxihbh3gqzJWizMoCn5t5VcJUCGw5X1EUeZ6R8TFi55ePEbr3ZyPUXXapRn6T6f44gqyUTH2/t1Z96uLB/rL0TkQ6G/KXucCxD22Hp8vKdKth3FpdaBqO6j2VwUzG1UUVTuK1quR56sZxvG6AzZd+ioEbNo3DNsJOLfjH+CJdBRl3eJjkHTqahGP90PmVs0R04nILBEHsvjWMSqpZyStoby9IIruy1sSRZ8U4xjdx+E9Ko4WxIUY6sU6n9Jq091pn7jGChmBNp2IR6dEKBztjqm00yQxUkQIKJZqsCu0QRHYZaSQaiKoxufIESDRjmoXpic+a1nUEFpXpNDLEVnjwGtlFQkwdjOgrOrIZnzHDKWcs1dWZ0ycPmoGJsSX05Q0AxqruaRKWlAM30jYCWl/crU/im5VAuZsFb2akTspeu7X3Zf4tWWX2my7XEgkbd8NWhIA6fONpQ6vmWkbwJJnhqGZbh1j325BlhPHvK6poKc4SpzaYiSlo/Mr7B7Pb+/HwxOwyPWMoeHrrrYbGtu2V+S0nd8SifatXzPLVqy3o2vFkibGvgm1JmsRcj+YWtR51+JqkH7dqwqJN2CSpTVwMQl4Klyf3MNQ5U5/m0T5RoBiYRhMuUkBMPKWZaijRuLp0QrtFK8zIafiCy4XR8fPEMHEx1dWE2Zec53kR7BVcWkBFqQVa5pUjFvQvvzzy1DJfunH1bROHb+03vQjr9zPOQghOxryIDUXVDpV0bCNgBTdz2+rcZUSb4rGjfj1iWr6gPs9hxLU9j6dt+ncA65CHWVnYbW7M+249a9KxCJWOJEbi04TCVO5AvWvuCu0X2sFCh9GtBoAEUL3Qn8TtMkCj6VT9GnTg9P7clFn6I3cXk6iAK8T5qZdTs4ZSXL+wqRawr
 QfWNtPI8
 e0r7RekdCAA2KNTKCOfzmsQz7xhqha0XaQ88MQdVGFuZb/7cOloPmtn00xvBgdUU52JnsgFq8B2Pq1sweSM8+xmJE2RJzoXAM33hV0VtIUYTzKnkZoZzulIknVlcPyfNhZdTQFQO1wBPBu2C5zhtcfpDWvLcAoRy4cHQOg5gJ1MzF+Tc74qk+25YV/eVLqbayOf7oJ4LNibQIrp9GMd7oH4yEpNrBD7Vk4Fw+uIFCQM0ffI3Vh3ds8SWi/z1cgfS3f/aok+i07iymlr6hyrxZrFTYYHUEiqdwvYNQyRjmrtkBwO4nlg7EbH/dvRUuCjhQOng96i/m7gVm5ci6tqUP30jfZnNzHNgO1KQDcLVPhaMLzeqOCXoSpRBibbyvi8wzGZLA7hQhLeieXxY5JI/Qb8p2+7zmNv3WdsBId3HKwh3GiNlB5CMo9HMWPYFFXp7VHUmbjlu7uXFtFGcUpcjdX1K+flINwrWRrPLMKsdsRaTofkr3x0eHT1X6gbd09/q6MbWoc+RSM9qPJtexW38zQwQJxbtspXba7HsfyWrvSTXOt2jdsA2cCns/4Vy5n18x0Iqnep2F3PCrwDJzSOYJVdkXT0NMAX/8PXVI79u2Qe9hHbiIUU4lD594QD7xSsJBp6ceOPH0wN2JKVzqbIrtv4DO8Nd6bJX/mXdt
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
- [Low] selftests/proc: Makefile and .gitignore entries in wrong commit
--

commit 9de4ed28fcd6656e6c6c2bb55f1514d9aa6600f6
Author: Christian Brauner <brauner@kernel.org>

selftests/proc: check that a faulting reader doesn't hold up removal

This commit adds a selftest in tools/testing/selftests/proc/proc-remove-slo=
w-reader.c
that verifies removing a /proc/net/dev_snmp6/<dev> entry does not block whe=
n a
concurrent reader faults while copying to userspace via userfaultfd.

> diff --git a/tools/testing/selftests/proc/proc-remove-slow-reader.c b/too=
ls/testing/selftests/proc/proc-remove-slow-reader.c
> new file mode 100644
> index 0000000000000..a201645beca9d
> --- /dev/null
> +++ b/tools/testing/selftests/proc/proc-remove-slow-reader.c
> @@ -0,0 +1,133 @@
[ ... ]
> +TEST(remove_while_reader_faults)
> +{

[Severity: Low]
Should this commit also include the corresponding tools/testing/selftests/p=
roc/Makefile
and tools/testing/selftests/proc/.gitignore entries for proc-remove-slow-re=
ader?

In the current series, those entries:

  tools/testing/selftests/proc/Makefile:
    TEST_GEN_PROGS +=3D proc-remove-slow-reader

  tools/testing/selftests/proc/.gitignore:
    /proc-remove-slow-reader

were placed in the earlier commit ("selftests/proc: check that a faulting
readlink() doesn't hold up removal") before proc-remove-slow-reader.c exist=
s.
Building tools/testing/selftests/proc at that earlier commit or any interme=
diate
commit before this one fails due to the missing source file, breaking bisec=
tion,
and cherry-picking this commit on its own leaves the new test unbuilt.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-core-v1-0-75df35e4f8b8@kernel.org?part=3D8

