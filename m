Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6A77606A320
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 01:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HF9uETWv
Received: by kanga.kvack.org (Postfix)
	id B2D356B00EF; Sun, 22 Nov 2026 20:09:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADE316B05B0; Sun, 22 Nov 2026 20:09:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F3CC6B05B3; Sun, 22 Nov 2026 20:09:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 773636B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:09:03 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E539B12077B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:09:02 +0000 (UTC)
X-FDA: 85464599724.09.9798473
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5DEFE1C0009
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:09:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HF9uETWv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795396141;
	b=Fajis2LZOOG3xmPVm1xTBzyS40u6sNFbmOP3z/ShYTTzmBRpUVc4nELkNjSSttVZKWmc7g
	MCKaZRJuMBEMd/gJFb0abD+A5SyRAjMwENG+REgIkRsMfaiv319/BvkaNYQTGPcSYs3jP/
	1wPYwAWi5PRS1lnTCVVOBfCpDI4Q2ns=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795396141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=54suIHluMeZO/ufn4/dBIrDiE7/KVFZ3u4m3JUaSiGc=;
	b=GaLF00P9IqpxJcOpWL7EAfM6X02tHxn42VuiX0VAgTK9G8hnc/l1ybnKJSUkHoH8AU66ud
	pJB0w5vNdQ6CLzZBZg4xScmmLxXnZ7T/IhZCTgsaQH3KFDahJVhlBDyvPsdsyLgwvOAwoQ
	DEpZTbwoiMo8nQ9tDusrE9frtnEzUyg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HF9uETWv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 69F096060E;
	Mon, 23 Nov 2026 01:09:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5FAE31F000C0;
	Mon, 23 Nov 2026 01:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795396140;
	bh=54suIHluMeZO/ufn4/dBIrDiE7/KVFZ3u4m3JUaSiGc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HF9uETWvgDgCbmGGppAFO03CUDvTiOIhaCY09lktVw3xBo+nBNXLRW9vgavEdg8Yq
	 w6jb69qUgfdhMLLUmmEukONSxkeSOgm4ac11L4U2+6RHH7AfddReVAfDbiWC20UZJ1
	 ObzV8+KU9EaJEEKwf9vQ0MB3DAwy3F+GuZAUWZiOM7AyEKWqXvrFk7f7TpuEGttoN4
	 Fy8mjA8UXStRyDAuKWmm+xzq5TtrHIVGOHkgItUyaQRjYNC63yXCwvcjmrZVfvnU/t
	 +zElr+nCAMWfHgU4XzXa9pP0+2Ljdb0uQglf4xGcMb1ZolxErN/TPOiWi0uas5nrft
	 DoyDlnL5SNLMA==
Date: Mon, 23 Nov 2026 03:08:56 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Cc: bpf@vger.kernel.org, containers@lists.linux.dev,
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>, Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Message-ID: <awOSKAvA-65pF3kw@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <awOEa303zNUDrzA3@kernel.org>
 <awOFGIWekH9-vlhM@kernel.org>
 <awOHVCpztLQv4Uwv@kernel.org>
 <awOIIuoNvNLZ_scF@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awOIIuoNvNLZ_scF@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5DEFE1C0009
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: sdwwnmaw7qbee3t6fcbekc7xbbuo9m8d
X-Rspam-User:
X-HE-Tag: 1795396141-484443
X-HE-Meta: U2FsdGVkX18KC8iVQR3DrKT7gT9y71Y75U7EuwNrsoDi6aXt+M/XBniiQlyjySf/Nd16oWt3qkLtn7ohPKwFbEVl5OGvWhvem+J/dEnDj51xCa9Awg6p6fSdnrJkX/4z7FWa8nQjUwvwiilN4om65Go3OlLC2BYhbwRPMOEGn4MbJhZBlG902YsyhkSSnyPK2BFfn1qIMxOP2IXqziK1cCEp2RN7ZQlenRfPtnJCepSmhHO/aEnq+fSnCN8nvrL4BYTfDNbKoXjGRGN07Vnqk89smqLIK3T5pC7RhAcjIv4kpSZtzf/mNOMd7A7+QJODiPCrqkk+/VOtie52AlRiHwb17Sr7C/zNcY3Ska9WxoBmpBwcLMTMLpwTzJD+1wX5Ax8TfehZf+6/U+z9d/MhRUrC/5r0mNADRaDeUodXc0rwL5JRmpqbws0DkSwDJkVPI7ngztaAWldfcncWJhty7K26IO4+5ZhSIn+6TUPQomYlRoKh2O65uZLtiK6E7UDBBH0EIruuoVJbjtaQDS5BTuvP9aoIghcfZOyEDj9CzFWwL2RBfx5OWeiTdMciPzFvtaVfZRA7ukEkS3OowGuL1BRGFahB7t7oi08whQxtXl2WDT4NYD9hfFpbBQwhl4m3heYBosrNCikpDritGPCnN2m43zmr6uefHPWqrumBOv09vZLQpftFRjuyol6JODZiBZtBxa28YmjFfjHPHN1JMN13B4Fw5X23+ueRw1uWPzEsGUQMnjAkIS/cFcFF3Xmp6FLKsw676sPx3DYNvErf50CqPDdsJ0cU1Jw47VRObYdQZzCOlmiY3Autw86I9VauzeokGAz+1+ZWiGfcdJM0x9ewX6wfWH3E0jSVNkpTIZCynhvOH7gF+QLubhYk9dPPCvWSsCo9Kj8sccm0BKXcCPrW+1V/rqHHTSjpkl6eSwkXauU7MQRSOOjS+QLbITpG39OPw6o36L62kJ1eq3a
 d6MMG8qt
 cFkAdPdiK9co225LH58Bhe7Lnoe8d6vyu1oEGzPtJc7xkUUJr2sb5MGi325Kbavuehs7ucUPTSsdW+jlDuq2x14dPi2hyb+ooO8o1u2/RAKNnMbkv+DV8NF61W+1ah7CUhv8NVDtgcmJ1KjIxCkhuwsJw3F/mwoPPuvbe8f3A9unsSpCtRKVfS5pHVu9uGKhVZCGxyGec04dWve7dK3azSdHiYImIDD3FUQ3KdBTtFQZk+f/e0o2kQdMCoCUHohB/nBglfv8c/4B80i+Ab+VX4zxw64GkBcnDcStHpz3usep2Alm5MX6pvYV3dg+wn51q2N0rPjwCppLFNYgpXhAjj7NSw8lL+5Myyg+sSIrJe9vXN34V4aO7k5oTLa388QhJv75Hs4dPhFIzbKBB8npSRu/qQXOg93AgK9qua1MCDf6Jn1PUkSv1evMlWah6N3dhrLAo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 02:26:14AM +0200, Jarkko Sakkinen wrote:
> On Mon, Nov 23, 2026 at 02:22:49AM +0200, Jarkko Sakkinen wrote:
> > On Mon, Nov 23, 2026 at 02:13:16AM +0200, Jarkko Sakkinen wrote:
> > > On Mon, Nov 23, 2026 at 02:10:23AM +0200, Jarkko Sakkinen wrote:
> > > > On Sun, Nov 22, 2026 at 09:35:13PM +0200, Jarkko Sakkinen wrote:
> > > > > SYSCALLS
> > > > > ========
> > > > > 
> > > > > Two new system calls are proposed:
> > > > > 
> > > > > 1. userland_open(): open an opaque staircase-initialized container
> > > > >    object (modeled on Intel SGX enclave initialization with separate
> > > > >    build and live states) with no embryonic state, opting selected
> > > > >    shared namespaces in via an allow-list instead of unshare semantics.
> > > > > 2. userns_set_idmap(): configure all UID, GID, and project ID map
> > > > >    extents for a container user namespace in a single atomic system
> > > > >    call.
> > > > 
> > > > Andy, perhaps a bit too far of the box idea but I'll just throw this out.
> > > > 
> > > > An alternative to userland_open() would a file e.g., virtual device
> > > > file, and necessary wiring for open().
> > > > 
> > > > Then the added syscall surface would reduce only to userns_set_idmap(),
> > > > and it adds more robustness to access control (e.g. who can create
> > > > containers).
> > > > 
> > > > What do you think of this?
> > > 
> > > Also, easy way to detect the feature. This does make sense to me.
> > 
> > This as a side-effect would enable LKM compilation, and reorganization
> > of the beef of the core feature as a driver. Not sure what would be
> > the best location for the driver tho, perhaps just drivers/userland.
> > 
> > I.e., full decoupling from the syscalls.
> 
> Right, and LKMs are great for live patching. This has enough quantative
> weight.

Not actually sure given clone flags etc. if detachment is doable, or
even if it can be, makes sense. Likely not so great idea after all,
after thinking this for a while  (at least not in this form).

Br, Jarkko

