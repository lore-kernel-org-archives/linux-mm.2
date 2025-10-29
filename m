Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 872DDCCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 19:48:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6DA98E00E3; Wed, 29 Oct 2025 15:48:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E44898E00B2; Wed, 29 Oct 2025 15:48:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5C758E00E3; Wed, 29 Oct 2025 15:48:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C1F958E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:48:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 75BB712B41A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:48:37 +0000 (UTC)
X-FDA: 84052189074.15.EC60FA2
Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id CAA4840017
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:48:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=hansenpartnership.com header.s=20151216 header.b=WaNijHqd;
	dmarc=pass (policy=quarantine) header.from=hansenpartnership.com;
	spf=pass (imf11.hostedemail.com: domain of James.Bottomley@HansenPartnership.com designates 198.37.111.173 as permitted sender) smtp.mailfrom=James.Bottomley@HansenPartnership.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761767315; a=rsa-sha256;
	cv=none;
	b=B+Ve9MScFs8bfo+XQOl1W+RwIl/Sv8WfNVc5zf9t57bP40rJpYVt1N2rQIvVGTDgA+0GTo
	L+Lz2zVbxWJefCUpyGjIPOnydMWTn7fF4gzhOx9sCiuIXlG74J43FibzlmXv7afLMrQyBw
	wH6NwC+FGc549pb1px9wO0ZafVAICE0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=hansenpartnership.com header.s=20151216 header.b=WaNijHqd;
	dmarc=pass (policy=quarantine) header.from=hansenpartnership.com;
	spf=pass (imf11.hostedemail.com: domain of James.Bottomley@HansenPartnership.com designates 198.37.111.173 as permitted sender) smtp.mailfrom=James.Bottomley@HansenPartnership.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761767315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wVedIwTPIS0Lhz0trR8qt8N5gMRk0wLi6s5VbYclEv0=;
	b=HxknBXOEVA7GR8juVtb+eaL+Mh8IKKPDCyeivjCDsgMZwF3jjUw31wZ0Z2UPuWJCod+bLJ
	8cZJwP7mg9ReOeAcqvdbBkn6b2QXK2BRznj2i19SYUGJHdv1QNoIWOjxEdpNXygRoyURl0
	k7tTNzJegFGw/HCPgLNri/EAMJloLac=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1761767314;
	bh=5NCabDDMXTJSsByGjaPrqENSsbg5yBpUcGI08rLkWXI=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=WaNijHqdZl3AhlKntLNMYK9nqFOA12V1LsBsoL+/Oa8wxJoMZ1UjSYREV5kCaEkCv
	 5Rp6VZdfPh/LWMmdsQ4aKW6GxYQodJRuv/sj6TvvbUImAAtzwes2Uj8nl649QN1xxS
	 0CjzFTQsQzrE2vv7Mf5a1i8pzdju/vroG6XnmFfM=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id ACE9F1C00DB;
	Wed, 29 Oct 2025 15:48:33 -0400 (EDT)
Message-ID: <ee61156bfb87cf0a2ecc13bca7d39efca45a7213.camel@HansenPartnership.com>
Subject: Re: [PATCH v2 22/50] convert efivarfs
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ard Biesheuvel <ardb@kernel.org>, linux-fsdevel@vger.kernel.org, 
 torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz,
 raven@themaw.net,  miklos@szeredi.hu, neil@brown.name,
 a.hindborg@kernel.org, linux-mm@kvack.org,  linux-efi@vger.kernel.org,
 ocfs2-devel@lists.linux.dev, kees@kernel.org,  rostedt@goodmis.org,
 gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, 
 paul@paul-moore.com, casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org,
  john.johansen@canonical.com, selinux@vger.kernel.org,
 borntraeger@linux.ibm.com,  bpf@vger.kernel.org
Date: Wed, 29 Oct 2025 15:48:32 -0400
In-Reply-To: <20251029193755.GU2441659@ZenIV>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
	 <20251028004614.393374-23-viro@zeniv.linux.org.uk>
	 <66300d81c5e127e3bca8c6c4d997da386b142004.camel@HansenPartnership.com>
	 <20251028174540.GN2441659@ZenIV> <20251028210805.GP2441659@ZenIV>
	 <CAMj1kXF6tvg6+CL_1x7h0HK1PoSGtxDjc0LQ1abGQBd5qrbffg@mail.gmail.com>
	 <9f079d0c8cffb150c0decb673a12bfe1b835efc9.camel@HansenPartnership.com>
	 <20251029193755.GU2441659@ZenIV>
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 prefer-encrypt=mutual;
 keydata=mQENBE58FlABCADPM714lRLxGmba4JFjkocqpj1/6/Cx+IXezcS22azZetzCXDpm2MfNElecY3qkFjfnoffQiw5rrOO0/oRSATOh8+2fmJ6el7naRbDuh+i8lVESfdlkoqX57H5R8h/UTIp6gn1mpNlxjQv6QSZbl551zQ1nmkSVRbA5TbEp4br5GZeJ58esmYDCBwxuFTsSsdzbOBNthLcudWpJZHURfMc0ew24By1nldL9F37AktNcCipKpC2U0NtGlJjYPNSVXrCd1izxKmO7te7BLP+7B4DNj1VRnaf8X9+VIApCi/l4Kdx+ZR3aLTqSuNsIMmXUJ3T8JRl+ag7kby/KBp+0OpotABEBAAG0N0phbWVzIEJvdHRvbWxleSA8SmFtZXMuQm90dG9tbGV5QEhhbnNlblBhcnRuZXJzaGlwLmNvbT6JAVgEEwEIAEICGwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAhkBFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAmBLmY0FCRs1hL0ACgkQgUrkfCFIVNaEiQgAg18F4G7PGWQ68xqnIrccke7Reh5thjUz6kQIii6Dh64BDW6/UvXn20UxK2uSs/0TBLO81k1mV4c6rNE+H8b7IEjieGR9frBsp/+Q01JpToJfzzMUY7ZTDV1IXQZ+AY9L7vRzyimnJHx0Ba4JTlAyHB+Ly5i4Ab2+uZcnNfBXquWrG3oPWz+qPK88LJLya5Jxse1m1QT6R/isDuPivBzntLOooxPk+Cwf5sFAAJND+idTAzWzslexr9j7rtQ1UW6FjO4CvK9yVNz7dgG6FvEZl6J/HOr1rivtGgpCZTBzKNF8jg034n49zGfKkkzWLuXbPUOp3/oGfsKv8pnEu1c2GbQpSmFtZXMgQm90dG9tbGV5IDxqZWpiQGxpbnV4LnZuZXQuaWJtLmNvbT6JAVYEEwEIAEACGwMHCwkIB
 wMCAQYVC
	AIJCgsEFgIDAQIeAQIXgBYhBNVgbnPItGJxvq2a34FK5HwhSFTWBQJgS5mXBQkbNYS9AAoJEIFK5HwhSFTWEYEH/1YZpV+1uCI2MVz0wTRlnO/3OW/xnyigrw+K4cuO7MToo0tHJb/qL9CBJ2ddG6q+GTnF5kqUe87t7M7rSrIcAkIZMbJmtIbKk0j5EstyYqlE1HzvpmssGpg/8uJBBuWbU35af1ubKCjUs1+974mYXkfLmS0a6h+cG7atVLmyClIc2frd3o0zHF9+E7BaB+HQzT4lheQAXv9KI+63ksnbBpcZnS44t6mi1lzUE65+Am1z+1KJurF2Qbj4AkICzJjJa0bXa9DmFunjPhLbCU160LppaG3OksxuNOTkGCo/tEotDOotZNBYejWaXN2nr9WrH5hDfQ5zLayfKMtLSd33T9u0IUphbWVzIEJvdHRvbWxleSA8amVqYkBrZXJuZWwub3JnPokBVQQTAQgAPwIbAwYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AWIQTVYG5zyLRicb6tmt+BSuR8IUhU1gUCYEuZmAUJGzWEvQAKCRCBSuR8IUhU1gacCAC+QZN+RQd+FOoh5g884HQm8S07ON0/2EMiaXBiL6KQb5yP3w2PKEhug3+uPzugftUfgPEw6emRucrFFpwguhriGhB3pgWJIrTD4JUevrBgjEGOztJpbD73bLLyitSiPQZ6OFVOqIGhdqlc3n0qoNQ45n/w3LMVj6yP43SfBQeQGEdq4yHQxXPs0XQCbmr6Nf2p8mNsIKRYf90fCDmABH1lfZxoGJH/frQOBCJ9bMRNCNy+aFtjd5m8ka5M7gcDvM7TAsKhD5O5qFs4aJHGajF4gCGoWmXZGrISQvrNl9kWUhgsvoPqb2OTTeAQVRuV8C4FQamxzE3MRNH25j6s/qujtCRKYW1lcyBCb3R0b21sZXkgPGplamJAbGludXguaWJtLmNvbT6JAV
 QEEwEIAD
	4CGwMFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AWIQTVYG5zyLRicb6tmt+BSuR8IUhU1gUCYEuZmQUJGzWEvQAKCRCBSuR8IUhU1kyHB/9VIOkf8RapONUdZ+7FgEpDgESE/y3coDeeb8jrtJyeefWCA0sWU8GSc9KMcMoSUetUreB+fukeVTe/f2NcJ87Bkq5jUEWff4qsbqf5PPM+wlD873StFc6mP8koy8bb7QcH3asH9fDFXUz7Oz5ubI0sE8+qD+Pdlk5qmLY5IiZ4D98V239nrKIhDymcuL7VztyWfdFSnbVXmumIpi79Ox536P2aMe3/v+1jAsFQOIjThMo/2xmLkQiyacB2veMcBzBkcair5WC7SBgrz2YsMCbC37X7crDWmCI3xEuwRAeDNpmxhVCb7jEvigNfRWQ4TYQADdC4KsilPfuW8Edk/8tPtCVKYW1lcyBCb3R0b21sZXkgPEpCb3R0b21sZXlAT2Rpbi5jb20+iQEfBDABAgAJBQJXI+B0Ah0gAAoJEIFK5HwhSFTWzkwH+gOg1UG/oB2lc0DF3lAJPloSIDBW38D3rezXTUiJtAhenWrH2Cl/ejznjdTukxOcuR1bV8zxR9Zs9jhUin2tgCCxIbrdvFIoYilMMRKcue1q0IYQHaqjd7ko8BHn9UysuX8qltJFar0BOClIlH95gdKWJbK46mw7bsXeD66N9IhAsOMJt6mSJmUdIOMuKy4dD4X3adegKMmoTRvHOndZQClTZHiYt5ECRPO534Lb/gyKAKQkFiwirsgx11ZSx3zGlw28brco6ohSLMBylna/Pbbn5hII86cjrCXWtQ4mE0Y6ofeFjpmMdfSRUxy6LHYd3fxVq9PoAJTv7vQ6bLTDFNa0KkphbWVzIEJvdHRvbWxleSA8SkJvdHRvbWxleUBQYXJhbGxlbHMuY29tPokBHwQwAQIACQUCVyPgjAIdIAAKCRCBSuR8IUhU1tXiB/9
 D9OOU8qB
	CZPxkxB6ofp0j0pbZppRe6iCJ+btWBhSURz25DQzQNu5GVBRQt1Us6v3PPGU1cEWi5WL935nw+1hXPIVB3x8hElvdCO2aU61bMcpFd138AFHMHJ+emboKHblnhuY5+L1OlA1QmPw6wQooCor1h113lZiBZGrPFxjRYbWYVQmVaM6zhkiGgIkzQw/g9v57nAzYuBhFjnVHgmmu6/B0N8z6xD5sSPCZSjYSS38UG9w189S8HVr4eg54jReIEvLPRaxqVEnsoKmLisryyaw3EpqZcYAWoX0Am+58CXq3j5OvrCvbyqQIWFElba3Ka/oT7CnTdo/SUL/jPNobtCxKYW1lcyBCb3R0b21sZXkgPGplamJAaGFuc2VucGFydG5lcnNoaXAuY29tPokBVwQTAQgAQRYhBNVgbnPItGJxvq2a34FK5HwhSFTWBQJjg2eQAhsDBQkbNYS9BQsJCAcCAiICBhUKCQgLAgQWAgMBAh4HAheAAAoJEIFK5HwhSFTWbtAH/087y9vzXYAHMPbjd8etB/I3OEFKteFacXBRBRDKXI9ZqK5F/xvd1fuehwQWl2Y/sivD4cSAP0iM/rFOwv9GLyrr82pD/GV/+1iXt9kjlLY36/1U2qoyAczY+jsS72aZjWwcO7Og8IYTaRzlqif9Zpfj7Q0Q1e9SAefMlakI6dcZTSlZWaaXCefdPBCc7BZ0SFY4kIg0iqKaagdgQomwW61nJZ+woljMjgv3HKOkiJ+rcB/n+/moryd8RnDhNmvYASheazYvUwaF/aMj5rIb/0w5p6IbFax+wGF5RmH2U5NeUlhIkTodUF/P7g/cJf4HCL+RA1KU/xS9o8zrAOeut2+4UgRaZ7bmEwgqhkjOPQMBBwIDBH4GsIgL0yQij5S5ISDZmlR7qDQPcWUxMVx6zVPsAoITdjKFjaDmUATkS+l5zmiCrUBcJ6MBavPiYQ4kqn4/xwaJAbMEGAEIACYCGwIWIQTV
 YG5zyLRi
	cb6tmt+BSuR8IUhU1gUCZag0LwUJDwLkSQCBdiAEGRMIAB0WIQTnYEDbdso9F2cI+arnQslM7pishQUCWme25gAKCRDnQslM7pishdi9AQDyOvLYOBkylBqiTlJrMnGCCsWgGZwPpKq3e3s7JQ/xBAEAlx29pPY5z0RLyIDUsjf9mtkSNTaeaQ6TIjDrFa+8XH8JEIFK5HwhSFTWkasH/j7LL9WH9dRfwfTwuMMj1/KGzjU/4KFIu4uKxDaevKpGS7sDx4F56mafCdGD8u4+ri6bJr/3mmuzIdyger0vJdRlTrnpX3ONXvR57p1JHgCljehE1ZB0RCzIk0vKhdt8+CDBQWfKbbKBTmzA7wR68raMQb2D7nQ9d0KXXbtr7Hag29yj92aUAZ/sFoe9RhDOcRUptdYyPKU1JHgJyc0Z7HwNjRSJ4lKJSKP+Px0/XxT3gV3LaDLtHuHa2IujLEAKcPzTr5DOV+xsgA3iSwTYI6H5aEe+ZRv/rA4sdjqRiVpo2d044aCUFUNQ3PiIHPAZR3KK5O64m6+BJMDXBvgSsMy4VgRaZ7clEggqhkjOPQMBBwIDBMfuMuE+PECbOoYjkD0Teno7TDbcgxJNgPV7Y2lQbNBnexMLOEY6/xJzRi1Xm/o9mOyZ+VIj8h4G5V/eWSntNkwDAQgHiQE8BBgBCAAmAhsMFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAmWoNBwFCQ8C4/cACgkQgUrkfCFIVNZs4AgAnIjU1QEPLdpotiy3X01sKUO+hvcT3/Cd6g55sJyKJ5/U0o3f8fdSn6MWPhi1m62zbAxcLJFiTZ3OWNCZAMEvwHrXFb684Ey6yImQ9gm2dG2nVuCzr1+9gIaMSBeZ+4kUJqhdWSJjrNLQG38GbnBuYOJUD+x6oJ2AT10/mQfBVZ3qWDQXr/je2TSf0OIXaWyG6meG5yTqOEv0eaTH22yBb1nbodoZkmlMMb56jzRGZ
 uorhFE06
	N0Eb0kiGz5cCIrHZoH10dHWoa7/Z+AzfL0caOKjcmsnUPcmcrqmWzJTEibLA81z15GBCrldfQVt+dF7Us2kc0hKUgaWeI8Gv4CzwLkCDQRUdhaZARAApeF9gbNSBBudW8xeMQIiB/CZwK4VOEP7nGHZn3UsWemsvE9lvjbFzbqcIkbUp2V6ExM5tyEgzio2BavLe1ZJGHVaKkL3cKLABoYi/yBLEnogPFzzYfK2fdipm2G+GhLaqfDxtAQ7cqXeo1TCsZLSvjD+kLVV1TvKlaHS8tUCh2oUyR7fTbv6WHi5H8DLyR0Pnbt9E9/Gcs1j11JX+MWJ7jset2FVDsB5U1LM70AjhXiDiQCtNJzKaqKdMei8zazWS50iMKKeo4m/adWBjG/8ld3fQ7/Hcj6Opkh8xPaCnmgDZovYGavw4Am2tjRqE6G6rPQpS0we5I6lSsKNBP/2FhLmI9fnsBnZC1l1NrASRSX1BK0xf4LYB2Ww3fYQmbbApAUBbWZ/1aQoc2ECKbSK9iW0gfZ8rDggfMw8nzpmEEExl0hU6wtJLymyDV+QGoPx5KwYK/6qAUNJQInUYz8z2ERM/HOI09Zu3jiauFBDtouSIraX/2DDvTf7Lfe1+ihARFSlp64kEMAsjKutNBK2u5oj4H7hQ7zD+BvWLHxMgysOtYYtwggweOrM/k3RndsZ/z3nsGqF0ggct1VLuH2eznDksI+KkZ3Bg0WihQyJ7Z9omgaQAyRDFct+jnJsv2Iza+xIvPei+fpbGNAyFvj0e+TsZoQGcC34/ipGwze651UAEQEAAYkBHwQoAQIACQUCVT6BaAIdAwAKCRCBSuR8IUhU1p5QCAC7pgjOM17Hxwqz9mlGELilYqjzNPUoZt5xslcTFGxj/QWNzu0K8gEQPePnc5dTfumzWL077nxhdKYtoqwm2C6fOmXiJBZx6khBfRqctUvN2DlOB6dFf5I+1QT9TRBvceGzw01E4Gi0xj
 WKAB6OII
	MAdnPcDVFzaXJdlAAJdjfg/lyJtAyxifflG8NnXJ3elwGqoBso84XBNWWzbc5VKmatzhYLOvXtfzDhu4mNPv/z7S1HTtRguI0NlH5RVBzSvfzybin9hysE3/+r3C0HJ2xiOHzucNAmG03aztzZYDMTbKQW4bQqeD5MJxT68vBYu8MtzfIe41lSLpb/qlwq1qg0iQElBBgBAgAPBQJUdhaZAhsMBQkA7U4AAAoJEIFK5HwhSFTW3YgH/AyJL2rlCvGrkLcas94ND9Pmn0cUlVrPl7wVGcIV+6I4nrw6u49TyqNMmsYam2YpjervJGgbvIbMzoHFCREi6R9XyUsw5w7GCRoWegw2blZYi5A52xe500+/RruG//MKfOtVUotu3N+u7FcXaYAg9gbYeGNZCV70vI+cnFgq0AEJRdjidzfCWVKPjafTo7jHeFxX7Q22kUfWOkMzzhoDbFg0jPhVYNiEXpNyXCwirzvKA7bvFwZPlRkbfihaiXDE7QKIUtQ10i5kw4C9rqDKwx8F0PaWDRF9gGaKd7/IJGHJaac/OcSJ36zxgkNgLsVX5GUroJ2GaZcR7W9Vppj5H+C4UgRkuRyTEwgqhkjOPQMBBwIDBOySomnsW2SkApXv1zUBaD38dFEj0LQeDEMdSE7bm1fnrdjAYt0f/CtbUUiDaPodQk2qeHzOP6wA/2K6rrjwNIWJAT0EGAEIACcDGyAEFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAmWoM/gFCQSxfmUACgkQgUrkfCFIVNZhTgf/VQxtQ5rgu2aoXh2KOH6naGzPKDkYDJ/K7XCJAq3nJYEpYN8G+F8mL/ql0hrihAsHfjmoDOlt+INa3AcG3v0jDZIMEzmcjAlu7g5NcXS3kntcMHgw3dCgE9eYDaKGipUCubdXvBaZWU6AUlTldaB8FE6u7It7+UO+IW4/L+KpLYKs8V5POInu2rqahlm7vgxY5iv4Txz4EvC
 W2e4dAlG
	8mT2Eh9SkH+YVOmaKsajgZgrBxA7fWmGoxXswEVxJIFj3vW7yNc0C5HaUdYa5iGOMs4kg2ht4s7yy7NRQuh7BifWjo6BQ6k4S1H+6axZucxhSV1L6zN9d+lr3Xo/vy1unzA==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 
MIME-Version: 1.0
X-Stat-Signature: 5kodd98btrgtzrqdz4pwfn163375dsdb
X-Rspamd-Queue-Id: CAA4840017
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761767315-136553
X-HE-Meta: U2FsdGVkX1++FlB6Vy8cJT+PmfO2ZL3Z51gQES38yTLigH//h9Y/YXuxGs+sSxqJu8a6dQJ/i+CRNHitbltQ47vOOvIMdxchyiIkoIcucAu7P2mnmsbu04MikwGflcs6mrdCmoqD1848OpHUAPRl8rBJx0yX8NIfAMsvaz+qkOWycH1+p1L+5zSCpqBAopQ7Z14rMg0iGweK+H8DQTior4VMnKqclc7ehScHTX1hDR/2GA0rHuOYhLetL68XO5S7cNQGCMdHjXyzjAz92aK2F9upl5bkYgLCYhqPtf5qfeVT9mLrFI286olWQC58DSY7egDdwx6edgjks8UEG4Myik/Kn2Z9/MjY6SijESGyzwaZIR+Zc0IbJ2lLdOe3SKFfS5xFbfdK0nTDWaGbD6fXGGnGPdlACFpqfIH/y7zoqQb5n+O85WUVf7ev1NkaB8iSxMY6aOPGlawnpn6/tsnMH4lerIoXsEdbHbgbAAEQe5DBMEIuL8+laM3PrPGdy4GqCaMEwND2Xu4VbjXgYf4vhmJAvDwpgNlgqSjOSOtzKcUwrDrzqBw/5R9fFV/jO3uTuB3DzIbB3Yn2HV7WBISX2PQAMkA7ZFyAx365l5S0qeA8TAdKWjhbk08KcY3fw+4emEgBKBMAK0hl3CWe+A9KDmSGys6s2v1EC0nuwp2RVNlFRREonQgN5HQYXpW1RBVwM1VSZ+5bgJ+7tRZpST0nx2VlGeaXu4lePGAE40QdoScrM8eQUPPjgW8Znu645IbmvyBOaid6cRqnB0PrSS9G6I7c2d0Lq1SomhfJLMLm9U6qZuHwjwhXMOO1e9a+lBiU9olneua94x4ukU8BnDUGqKtos/E5FNuR6saSzSwiLhstpCtUENWwuxnqWfzASnL2lVoIt+Vd5VdHR9BiIu7kOU9xiCT6V3HoYAqm565EWXDxzV7grStFxrwFA2ZrPDcKAG8tov7jL4LV3SabPPh
 ulxUEbmm
 FhKqqKXvmeHs9hvLqg/sQwAS8mP4izjvleo6rznwfKSkS+po+7Oa+aeokWsMZXZwrJY/Si/9EjT3KrqxPJ9+GdIBN8ooWgNse45+4f1FJ5pzIdWmfQCHirl2HSBotIQatyBtBsAJkhoSF7cr6RBwNjxazaTQF7iDal8ivud46jXUm6ovZUkkIALAC3jvUoMQ6bu9C41oF8WKHhIbkYFwKdjQTUqCsTGlA008wY1cYskteuDIDYMBC92gA6g/qYxPYeh9OMW3Ms6I1+If8ymNZR6sHNq8Ef7GyA1ElWrGdFAW9H7xNv3Bc7J+IKev2FEK9/Fgo/3Pf2tUqijoqRaH3vdBZt4Ubna8Ey8rhSQAhwmdR6IVR6ku95kAtjT3HuP4tE0fycF7unRsaDYJAXuF/KInWcw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2025-10-29 at 19:37 +0000, Al Viro wrote:
> On Wed, Oct 29, 2025 at 02:57:51PM -0400, James Bottomley wrote:
>=20
> > I think this all looks OK.=C2=A0 The reason for the convolution is that
> > simple_start/done_creating() didn't exist when I did the conversion
> > ... although if they had, I'm not sure I'd have thought of
> > reworking efivarfs_create_dentry to use them.=C2=A0 I tried to update
> > some redundant bits, but it wasn't the focus of what I was trying
> > to fix.
> >=20
> > So I think the cleanup works and looks nice.
> >=20
> > >=20
> > > Relying on the -EEXIST return value to detect duplicates, and
> > > combining the two callbacks seem like neat optimizations to me,
> > > so
> > >=20
> > > Acked-by: Ard Biesheuvel <ardb@kernel.org>
> > >=20
> > > but I have to confess I am slightly out of my depth when it comes
> > > to
> > > VFS stuff.
> >=20
> > Yes, ack too.
>=20
> 	Umm...=C2=A0 FWIW, I've got a few more followups on top of that
> (see
> #untested.efivarfs, current head at 36051c773015).=C2=A0 Not sure what
> would be the best way to deal with that stuff - I hope to get the
> main series stabilized and merged in the coming window.

Unless there's a bug lurking somewhere, I think think the cleanups are
great, but can wait for stabilization of the main series.

> =C2=A0 Right now I'm collecting feedback (acked-by, etc.), and there's a
> couple of outright bugfixes in front of the series, so I'd expect at
> least a rebase to -rc4...
>=20
> Hell knows - one variant would be a never-rebased branch containing
> the introduction of simple_done_creating() + variant of efivarfs
> patch (as posted) ported on top of that (with d_instantiate()+dget()
> in place of d_make_persistent()), then have both #work.persistency
> and efivarfs followups pulling that branch...=C2=A0 Or I could simply hol=
d
> them back until the next cycle.=C2=A0 Up to you - the main series is what
> I really want to get out of the way ASAP, especially considering the
> potential for conflicts with the stuff Neil Brown is playing with.

git log fs/efivarfs

will tell you were not a high patch throughput subsystem, so I'd guess
we won't need a stable base to work from because we can just wait ...
however, if a sudden unexpected flood of patches did come in, this
choice could be revisited, so it's probably the best one to start with.

Regards,

James


