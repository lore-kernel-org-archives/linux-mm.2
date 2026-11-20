Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA87D606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NqYTjW+h
Received: by kanga.kvack.org (Postfix)
	id DCE916B05D2; Fri, 20 Nov 2026 05:36:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA5EB6B05D3; Fri, 20 Nov 2026 05:36:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE3BA6B05D4; Fri, 20 Nov 2026 05:36:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A96736B05D2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:36:41 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 357C51A0E81
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:36:41 +0000 (UTC)
X-FDA: 85455143802.15.5543CFA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 971E580005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:36:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NqYTjW+h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795170999;
	b=dkdfXMovnrZOSycWVogBejCU5q78NLWdNHh77HTKHOYCnFrFOPxcMb6o6OS2bG9szJ0Egt
	s2RHto/FOnB0poDc8VGEdEGx/UXoUarigFcbRWmMoo3ENj7afKIyUXNUqG1CsVrw33xKvK
	Pg6SNLQnayE1PjNG6lCugdAPNymSY4w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795170999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OBbEyP/H6djxrJo03P55CCCJILRL7MXtwftvePmw9sQ=;
	b=mL3sK57ciChK+nE5CWzXDXFMF3b7owaxaNa8xK2jj9rH+SLSXhcbXDWubvnA4eUVS7uCGg
	wyE5YBt/Zm5Z1ecS1WGgjxPqJD74ijlw00cdno+TLAc6jNnMc0xlCVvEsAdMgzQwDuEHyB
	mZiRTmVSnutGlnzA0egj3MM7M+8EKWc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NqYTjW+h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2121F62731;
	Fri, 20 Nov 2026 10:36:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C85D1F000C6;
	Fri, 20 Nov 2026 10:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795170998;
	bh=OBbEyP/H6djxrJo03P55CCCJILRL7MXtwftvePmw9sQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NqYTjW+hRZedNoLan48YbMHilMOqdxA6SvuPNs27BdYAJtMieE3b+p88qlC0nltBB
	 dKXeSnrN0Ai0EUxJOQPnJ08kxNl9XL5rXMHb6+ul/GWzw/SWMIHxWj2ENcIOAH+hw0
	 VG0b6+k1zpQx25ACmN44hZt0lyQABY4JM+N+BzaVBEA3dfT6Lc9rBBGWjDO5J6ZMst
	 hHsY6Be0hY2pKTeiR75KILAhbrgWhWpjDEnKrsUmyeq4DxKZQWegGyYXhtBJOLkwjQ
	 vPrNR05u216qwRlxj5CK8Ti3YFnayv1KeFvoQxn0SgTKyPVu/3xmbO8jPRbaV1gML1
	 lWT3/zctQXpVA==
Date: Fri, 20 Nov 2026 10:36:35 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: shao.mingyin@zte.com.cn, akpm@linux-foundation.org, linux-mm@kvack.org, 
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/balloon: fix NR_BALLOON_PAGES accounting on migration
 failure
Message-ID: <awAijOul2KPFT1CQ@lucifer>
References: <20261115004708909xx05JgB9nXnOCG0zL7h_K@zte.com.cn>
 <avia_XgVOuN_pZ72@gremlin>
 <96462da9-9437-4774-a5c7-f99858481ece@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96462da9-9437-4774-a5c7-f99858481ece@kernel.org>
X-Rspamd-Queue-Id: 971E580005
X-Stat-Signature: m7y77dgwstmnhitw1puoq9dy5p1mrzkt
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam01
X-HE-Tag: 1795170999-151779
X-HE-Meta: U2FsdGVkX19jJptUGRgQTGpQuCQMm1GUVD1+SJAW1+pxsze77sMZgYUX7f2tTr0LJ25D/AqY3VUG8F4qQliCsGkamEoqP9hR/YQC0ArkQ4hu73SWXb+8ExOL4pSc/5JMPPpjmCar6jgv/LDp9wI6JJiQ5VW6TkuzvGHuajzGodST/O4XxTdH44EMupqifLcc1RoTAD5DnO3JOqVmNeVvagwxJKGxp0ttpSRPulIcGb99K5hXG9xP9T0qUaGFdeemEeywWalmj4EJV5lTuyhWKhzxMSOgSpfB8JSWp6esxS8wXHlWbHkUmtgDiOVHv0ywy3LjIFup08vwIozdLQK8m4Xc50ghwKxanjX+cCLUbgD6auNYsodAJVjA/4UwmhNUAp0+Ut1bshKJpgyyH2rhkQWlRkI8JQRiacM5K1y/D0qwx3Iy30mMRWfPM+wvEbPC01RANAbY+hqtnvcXYB7kxgrk0DE5p4II95vsJd5/8M46Yn/K/D4vkhZJ4A+WkpFIkyoZTRZqIwZJtgQMOR7nTCp9NN+VrAYNB7e1K10BKjuefZa1buaG1/rGFF999p842+Ec5KEyWJUF9nBFrRwcTd1DeXpn8pGdRdwGbgggCXlFm/2KD0EPZWlHpUE8cEaD3AyzdB7vhrO1GMwZCiaveFrkH58ydOslQ5ilG3SU6bwTQEgOwkwo/RPVJqXdQXwWWepqEaIR9iD/921kw+GATH/dGroSg9jx2dwsoHS8qDVnc2qGhqF/1RG0Kc+hMI4uoYISvNlB6+UfzW54GEK+L5zGEhoPMBkRkmOoxg+OlWMoToCmDElNxZ1qaJ75wXgkpzBfbiMLwTi/CEWA7na90YCRIu2FhdrX+fnGvP7ksFoK4hhqwtIfdf/3qsZPebE29wsRYjdHgLJeQ14sULCDGL+GDCZSAjA/N1YGiUN3zhauqbKFv4XrJ8QfOjqy2AdPv0I5qSMnF3xQjY7ti6V
 CedLxFjO
 gU7ra+rInmGDLUirxWWMwrRttRIWfbv549MiiWRYmjcE8gojcQH2C9doE7G2rC1w+43m2WbU3f/hdS0mv4RhRqWbNCNfqdWCZOYmVTrAfRjY+sz4XSPUj0WfewbyTfG2Hot2CvLljQ2q9ptxAwh8REUU0gXvkFdrmBUnkcx89i6VM73EuyFWHE0vqN+VXzj6QwR2ez/WYzCUdy8FCsSd6fn3pCcvqXQBWXXw4WP2Qol/tY0iAX3Xmoc6aqM8jRFFNqgwH736K/mOxdSB79yBJUozW4vy3hsWGicO92ip4E2Pgrm1CU1WQHTtLTYQY10piq9UZ4X+oElvQ32mQEfp2cm21BshsmaTe9JtM4LcFRjK0y7WMvo/2TtY3/mSMqvGHYUy717ln5JCPPwoSQ898sgVju9cHes0VLytl9OdZnlR8N9+byah0cfXhVkZEz/qG2C7YU3EUwYiUakOqegKNbpBJPOJDP8oqzXxkUgY0j4zZ6aQ0/+yktXYwgQLtwD/t/LOLXukcOcL/kSI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 10:59:47AM +0100, David Hildenbrand (Arm) wrote:
> On 11/14/26 18:31, Lorenzo Stoakes (ARM) wrote:
> > NAK.
> >
> > this is generated by some AI slopper's script, spamming the kernel. The
> > patches I looked at were wrong/broken, so no to anything from this person.
> >
> > They've sent 300 mails in under four weeks spanniing: ata, scsi, target,
> > ufs, nvme/nvmet, ubifs, ublk, zloop, dm, md, mmc, virtio-blk, mfd, gpio,
> > pwm, spi, PCI, ASoC, ACPI, net, vfs mount, block partitions, and now mm.
> >
> > and 17 series across 7 subsystems over the past 23 hours.
> >
> > We need a way to ban emails from people like this...
>
> Yeah, that's absolutely annoying. In particular as we REQUIRE people to
> understand the changes they submit, and own the code.
>
> That clearly won't happen in this case.
>
> There is a real (low prio) bug hiding in there, so something to be fixed. I'll
> take care of it.
>
> I'll take care of it.

Ack, yeah, I think the best approach is to treat these as reports, and if
there's anything valid pull that out for a member of the core team :)

--
Cheers, Lorenzo

