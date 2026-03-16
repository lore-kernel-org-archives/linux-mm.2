Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 814A3F53D6C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 21:45:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A75A16B03A9; Mon, 16 Mar 2026 17:45:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CF596B03AA; Mon, 16 Mar 2026 17:45:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B0696B03AB; Mon, 16 Mar 2026 17:45:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 771E96B03A9
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:45:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 20CD58C09D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:45:51 +0000 (UTC)
X-FDA: 84553258902.13.D39E807
Received: from lithops.sigma-star.at (mailout.nod.at [116.203.167.152])
	by imf06.hostedemail.com (Postfix) with ESMTP id ABE3C180007
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:45:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of richard@nod.at designates 116.203.167.152 as permitted sender) smtp.mailfrom=richard@nod.at
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773697549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/UyC2rv+fuf1B8esy+O+vyfPhSfBzfj4uOXEAJ8jSnc=;
	b=MXgmvAz4g8KkUB+VYLK8oz405cKOHjSTC5yI0l9+KiIWjZygaWE+Q8egXrMjjg2Micxzb+
	3ola/Z+x7EtFSOJUBNmU2gknvTL2D/bTT/dxQtIK4cnXRZvTKAxzr1lE/CANKhYI3gV/T1
	fypErpH7WRLLUmdOM9ThL0+kMKlZ3b8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of richard@nod.at designates 116.203.167.152 as permitted sender) smtp.mailfrom=richard@nod.at;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773697549; a=rsa-sha256;
	cv=none;
	b=cPyNHBPK+0xIios3ds7hxUjcGNakVrZu6dUez+PpwPAFeYW4E2Laq96dK3uxn3gd1QlL7t
	SfVfnT2B1+eWq/Z4fwdVJ+RTo6NbodE2GoXHxeoDPwEG4cvgS3DamqmTQvf/vuUiTXymI4
	y5MAsev5TmHMOthkN4Y1336sci1ha4o=
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id DE7AC2C14A6;
	Mon, 16 Mar 2026 22:45:45 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id gGqg7UAYOlZ6; Mon, 16 Mar 2026 22:45:44 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 3AEF62C14A8;
	Mon, 16 Mar 2026 22:45:44 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Q-DUhqY-5-xt; Mon, 16 Mar 2026 22:45:43 +0100 (CET)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
	by lithops.sigma-star.at (Postfix) with ESMTP id A7EA82C14A6;
	Mon, 16 Mar 2026 22:45:43 +0100 (CET)
Date: Mon, 16 Mar 2026 22:45:43 +0100 (CET)
From: Richard Weinberger <richard@nod.at>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"K . Y . Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	mcoquelin stm32 <mcoquelin.stm32@gmail.com>, 
	alexandre torgue <alexandre.torgue@foss.st.com>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, 
	Vignesh Raghavendra <vigneshr@ti.com>, 
	Bodo Stroesser <bostroesser@gmail.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, 
	David Howells <dhowells@redhat.com>, 
	Marc Dionne <marc.dionne@auristor.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>, 
	linux-hyperv <linux-hyperv@vger.kernel.org>, 
	linux-stm32 <linux-stm32@st-md-mailman.stormreply.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	linux-mtd <linux-mtd@lists.infradead.org>, 
	linux-staging@lists.linux.dev, 
	linux-scsi <linux-scsi@vger.kernel.org>, 
	target-devel <target-devel@vger.kernel.org>, 
	linux-afs <linux-afs@lists.infradead.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, ryan roberts <ryan.roberts@arm.com>
Message-ID: <305430349.46051.1773697543461.JavaMail.zimbra@nod.at>
In-Reply-To: <e3071ae43af79277d3919bafb71f009694d0854d.1773695307.git.ljs@kernel.org>
References: <cover.1773695307.git.ljs@kernel.org> <e3071ae43af79277d3919bafb71f009694d0854d.1773695307.git.ljs@kernel.org>
Subject: Re: [PATCH v2 09/16] mtdchar: replace deprecated mmap hook with
 mmap_prepare, clean up
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF148 (Linux)/8.8.12_GA_3809)
Thread-Topic: mtdchar: replace deprecated mmap hook with mmap_prepare, clean up
Thread-Index: pNh82O8fJN+FJCj96uoZroIJd3hL7Q==
X-Stat-Signature: bj7q65x7a71ao5t9tyz5tawcry69h7t4
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: ABE3C180007
X-HE-Tag: 1773697548-312398
X-HE-Meta: U2FsdGVkX19f1AZr9yNPu/GgEzOtVbuyF7JoobHaOkT1fecvwHreHcGJe6NjvoIEyHrUmdeyrKAf+UTUkgId3wIiAQ4Blw0oYO3Lcl0aSZilN7qckMEbVN1TBtN3UG8oH9mqKEG/SUlLob0SP+CtmRb23l4i0oz7bivRaABGS32Be/iGSuWPNc0s0RT3tXcrM9jcV0a95vVCmHkCcr/k2w03LYeRdForl1Lu70eipp3GJOocNVg647GmMqOCrNTqok0AHwo03mSyCyTmWqpZoVfmGNe3EmIKbLLlhPmGS3kUNWH6fPnTgITjUT0ws50R0p1xqxm5FS0UN5SaSmmDWmwn5j9CVkS5pnsyamPBpo3LNE5vXICJWzkY7Sb5SDak3hEDxEZpEDeVyRN38Fx2cZlrKhaisCIPsE92xIj6aZYsviosyBqEXwrIUtHDpqGzFMK2Ld6u3KDbROPP+Pchhsit49ukB+x1Zcw+DYdZQEOo+18/AQ7FazxxSdblbpllfncPfHm7XryGm/VAI92DtgtlVQCbZeAq7CHF8YDW2SyEZlIEeIPhqFhtTO5l4ZbpUVXG6hot8YQpuy2kbnhVDObH2X5T7p24g86s0Q2WuaLViXkmu8D0yYmeq5m5aOpTEHQRAmquAkUiF/UfEVxbwskLnas6tP8MF5hiAuCRu9C7jlkL0NGwtmzS7GpkIVl5TikScZNJgJE7iCqxZeLYIKJXOkPLgCLDoLVzT+hskvWdLUT272rWuO+RwR6gXeE6gXe6CeOxE5kk6SYckSQ52yD6X7EN5I+1TO4DwtfDD28dRL+WQ0nFn2tv1LZr5WTVDFz6O73cKRsi4loCr2vLVdRC3PD6Pjp8h+RU67LgXZaaOSnDQ3xdGn3iWazD5v4s/VUdYH8Dm4rNBH3f5mEzsocPwIZKKlHrWDZ90uQ9huDrfiQC/LNsxd9YeyWuGmktja8dmuAEhN8ybnxX6Pn
 m7BUwoqm
 OF6m1IfBzgPhWirHqBcJJqNzPzZIK5Q6Amk9t9X3aip39L0UJgOU7H6zxxUaTQSoC64ZvwkuFvTYv1LagQbrvpbkABsUKeHv6prhyobxpirqsyiCUSw/cNS5jlKTQp9h34u9Sbv1uEvwaBl0ugx48JTaNly4Xf+J+XoKd9sa4UXnCajOrEXhGQRkx1E0r1G/oBGymamCyu6jJ+Vw4W6T8xFfnEcD2+Y+Q19q7rd7JwzuCBEwOfI3+AJYIj49IngxKe/JOuGG17vFEWOH48Cb5O32Su+36DiOMRTaMFG1O7523Wemp4uVkYNQYKLVb6uViZSaCw7sji4N8Yoicw8aM17UB21bEIeapq5Xq/sa60a0LhWA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

----- Urspr=C3=BCngliche Mail -----
> Von: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>

[...]

> Commit f5cf8f07423b ("mtd: Disable mtdchar mmap on MMU systems") commente=
d
> out the CONFIG_MMU part of this function back in 2012, so after ~14 years
> it's probably reasonable to remove this altogether rather than updating
> dead code.
>=20
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
> drivers/mtd/mtdchar.c | 21 +++------------------
> 1 file changed, 3 insertions(+), 18 deletions(-)

Acked-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard

