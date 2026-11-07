Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5896C606D826
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 16:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VM9YuiWn
Received: by kanga.kvack.org (Postfix)
	id 2B8AE6B05BA; Sat,  7 Nov 2026 11:46:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 291276B05BB; Sat,  7 Nov 2026 11:46:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17EA66B05BC; Sat,  7 Nov 2026 11:46:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA4F86B05BA
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 11:46:25 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7BEFC1603C9
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 16:46:25 +0000 (UTC)
X-FDA: 85408901130.11.BD055F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5B535140003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 16:46:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VM9YuiWn;
	spf=pass (imf26.hostedemail.com: domain of cel@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cel@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794069983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iQPFcguwJfJnGIUghj3vW2cnp0ZTKsyoI6OiYKG+trA=;
	b=PsvszNTqFzIHl2uJy8U/DDR7LH/RVRjRg7DM82sOcxX2npQe5Konf6eDVRLikGY2dr94hh
	OWW1md658rbKOqCKzTXXXck1WqeJyjDE2b0EbmOxqp2wPfu/ObCz6uodfEyUV1wkEmItXG
	UaWILfz86MEq25h9LWU2umEmKuiUZlY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794069983;
	b=JLoe1h/IpnLnRKsxhoXki4dRp3jXDL2rGja+ZWCOB14POsNUf9f6qqvsppSEFchuPa4s2x
	/C0lXh5ZfEn6uhcl663i/yNmnq9CYbAEA4VxAr6hkERPnB93chuW2Fawsf9gb8lofrkB27
	YQ/u1Xek12rQzokravZFOVYbHQAAuU4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VM9YuiWn;
	spf=pass (imf26.hostedemail.com: domain of cel@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cel@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7245B43823;
	Sat,  7 Nov 2026 16:46:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C841F008A6;
	Sat,  7 Nov 2026 16:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794069982;
	bh=iQPFcguwJfJnGIUghj3vW2cnp0ZTKsyoI6OiYKG+trA=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=VM9YuiWnX2AxixylKQUoq+kcitnOG5EzbF2X9QExC8KlL2MDA2iyK+MohWy7Is5c9
	 XVSDhAm8H/yBVlmhN+3IQseSQF2jGl1M+I2ez83FRgJrdtIoEzyyJH3UteHcMNBF3J
	 CIxYy49tvs705sBEv6+oNmDe+XeTRlWWJAeIlasE4z+WjzM0vX46Vs29hEnM0d2wZb
	 W1dkb+g9MV6DZn1boZSIdWYUouaQYtnA2TMkW/lFIttT5mLiUtyZmeYkxA+HrJ549d
	 6AW15GkyWYPIpCmvFv4xURMQ9MDEdEzTK3dhB19k8mh2nE5zuDwmhWf+JnyyfSm3ph
	 PLuUxIL3o5qoA==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 8E1DEF40067;
	Sat,  7 Nov 2026 11:46:19 -0500 (EST)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Sat, 07 Nov 2026 11:46:19 -0500
X-ME-Sender: <xms:21Xvams7wVEmHspjWmbwhLpib2xNIptoVYE-80X8WqZqZcb1XPT-CA>
    <xme:21XvamRC29Zg9ykNiW0vwrANU0AC0j8D3WACLizfxgWZ2OLmopVNcj-qyZCZTBqLn
    FnUPDv24PUXWdCZGoMgnY4GISxXuJoqj_FJTWVyN8AgQyPiOZVj9Iah>
X-ME-Proxy-Cause: dmFkZTEtlYS0+TY9rHJo1vCDNDBgG/0TlQu1ZgAaexztyT5e7mSb39t8Qfa0vTeatlfpwP
    5ATotugI+S69Aq5UXpsB8wdUtjDvDqFpA717Gwij4u69sZUh6KSv9WWk6Jq//TgMNLfNVi
    Uz7LSIH08qzFkhYYh9/35LIN1zJWwwarlCDU1iQg4wt21opJj09VkTQ37+xtOv284TX8B8
    yl81LC5xmVZyo6A9GjLU5A0F5I2dYlaICl6rU5kYsMelZGpwWY/AOYhI+JMNgaonKgFQaK
    ku+gQcY5aJl2LKRp0R1zioHZwwCKpV/Rgf4D5rEiKrG8xxXM/BULju0eld0dqqIZyyKUfJ
    GW19ru42mbqsCpPSyXWqDBJxl5bN5OUlD62byk006CGbw520QKU/yBNHckj8/a7Aw/pswE
    cEiGWvUnIlIDfqqhyBtbUxKdieVFtOg/Nh7ULYvIP/0NmKpXY6WcXU9anidEQ88SbIQjDc
    p8Yn7T3r8Bo4iwmbKTgS1vVIcIOOKv75MyWqZv/+HCroxzEXbbFU7dyYNipmhzrf5va650
    CqAuf2hfcDqsbABPPTHxkCEDCl/Z7jZw9/P1SXCFxyI0OJaeowmrBr44zHzsSCW7ueEBOE
    v4mcadw/NREalORTbhxI6N8vjS1sruRGJ2ATEo0TnxHIE3AAjUR+ONXu5PSg
X-ME-Proxy: <xmx:21XvanTCUxiRZL_4tn_RpzN8CzyhB8rLiSKq-UOIyotAbmuEjI7sGA>
    <xmx:21XvaurCk3dCumlVKotKWDf68V8MDwwzlx-dEeK7pWGM9HqcR4oZkQ>
    <xmx:21XvavRZiOL5frHmdBkAVeJ6cjpU89f7VYn1Ikw-RN984COqc-2ICA>
    <xmx:21XvaoJKJLPj7VOMrYps6zuTHuKL8ZgDDK4Gr4RreYxXio5VOww0yA>
    <xmx:21Xvag3Tq78e8w_19g2SFkvau64M8X7d5PUoh2FKftcFG01vhemSEsb1>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 5E62D782738; Sat,  7 Nov 2026 11:46:19 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AjxZksNfZZQV
Date: Sat, 07 Nov 2026 11:45:59 -0500
From: "Chuck Lever" <cel@kernel.org>
To: "Christian Brauner" <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Jann Horn" <jannh@google.com>, "Josef Bacik" <josef@toxicpanda.com>,
 "Chris Mason" <mason@kernel.org>, "Jeff Layton" <jlayton@kernel.org>,
 NeilBrown <neil@brown.name>, "Eric Dumazet" <edumazet@kernel.org>,
 "Thomas Gleixner" <tglx@kernel.org>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Jonathan Corbet" <corbet@lwn.net>, "Christoph Hellwig" <hch@lst.de>,
 "Greg Kroah-Hartman" <gregkh@suse.de>,
 "Joel Granados" <joel.granados@kernel.org>, "Kees Cook" <kees@kernel.org>,
 "Jan Kara" <jack@suse.cz>, "Jan Kara" <jack@suse.com>,
 linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
 linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-s390@vger.kernel.org,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 linux-um@lists.infradead.org, linux-wireless@vger.kernel.org,
 "Linuxppc Dev" <linuxppc-dev@lists.ozlabs.org>, netdev@vger.kernel.org,
 ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org,
 coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org,
 linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net,
 jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org,
 linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org,
 linux-sh@vger.kernel.org, linux-usb@vger.kernel.org,
 samba-technical@lists.samba.org, sparclinux@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org,
 linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
 "Takashi Iwai" <tiwai@suse.de>, linux-input@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-debuggers@vger.kernel.org
Message-Id: <a1e2d05f-08c6-41ac-a8f9-6985ee00dc97@app.fastmail.com>
In-Reply-To: <20261104-work-procfs-net-v2-10-221e2437fed1@kernel.org>
References: <20261104-work-procfs-net-v2-0-221e2437fed1@kernel.org>
 <20261104-work-procfs-net-v2-10-221e2437fed1@kernel.org>
Subject: Re: [PATCH RESEND v2 10/13] SUNRPC: let procfs own the wait queue of the
 procfs channel files
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qa4f9i4oyhju1nzypi3tuagxq4e3g8ft
X-Rspamd-Queue-Id: 5B535140003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1794069983-186991
X-HE-Meta: U2FsdGVkX1+jWByKlUi5JU4+yD0IL3NmBiWqCVnOUTu9I/m+BL6qd1m90/DjjI6a0DpdRhjvL/TY1JmZckuk7i0MSM9SkEgwDQajt75yTqXZlFQ0tk5H1ymMW5LQVMJlvp5lhb+3PFGW94rQByHqUlvJiRygx07qrXudnogbocsIe2b48X9sDnzueqbIBYRmrjjof15GdGWuQ4eq5cO5j2026a+wajRQDrrbGvgGZgj+D1qMikmX5ULknFnh+9tViWggwxKx9sYeaiVjp2S1fDkkpGF7Vde6YQLm0iOPxkr1up3/DBFtucRKXhgIXQ6PS+5pefzNguq2gtWmmkIwgkMZIx/mkRvDMsEzwKlPWn+9z5ZwaUyXWbarJr2yCt8iPTCu9nRap6mE/AbfqaDgEHnLmSM0HxQboAZ5IyvwasXPLGLa+9dMq4AFLYYm0d5SjM5i1utwYjBo7hcP09mPSGs1NSOx5z+6CGwVIOUpkYs20dES4NYuKU00djtsGmbp+XnClllqF22SSYwLcJhzgXNsYAx8SNttNZYRubeMbJCVQboyop79E1Vy+i6c/8C6rEQ1h/L0Red69PqkPv+0jZBNmOL4g+xVC1c6R4hbzt5SGcv7+/g4nfn5NCFP6eQMZ0LXhVv7AjY3+xI0jkp6rth43gDkWIazUQquoVE2ZqsMXFEd59Xbegl2t85R5r1Rd4Uk3T0N0HQ3eLL0RK3Z9a7dnTEyi+/Z8/dLisSJg8uRmh3tbu/BGbEEjteaihPTT2N0vaGtjQzgUQobRC1JvhnuU+0h10OQZ/drklLEMaUkiOomc8WXVw8+ZO28YJ47SciasZ4vB5DPRUOWIZFm0/uETgIwvhY80dRfz1jwBSQipdys8JbhcVc69McXNL/UYcpVbMIyTxWdLReC93b3IytBN45ZAWzkZdeay2l9Hq1diY6/WaxxQSB7gI7snDZ3Kz68aPD1NtngLXr3S/l
 JmHBKXnq
 72JQZXfNon45x6kBHPxeB/GOBYTle23Cg3Sydl453R/KU+bLHbEcSM8nfK8SjNIyOFnkxpBBCCLeFZcSV1Dy6zsdAsSp93l9ofnpGeJOCquJ6/2PJeUcwGR1l7dMU5GM351jrmgLxjtgjvnJAmyGsMQJo946o7b29ZLxWpU5IlUgZqu5lAqqB8+xUhHq00pKaoYZ62F1/rKnjkjV2lLBazEGElrZXDf83Dq+FHvq5aQyKFp0yrnglAyUH9xVx8Y2NWa0DzoOSju3eqeLUb2twJ7NwTsOsvkPRUo6ZGh9Ix3K3L4ccYZmd0bFoAHvaVZ0G9lsIH1EPmx+gpCkXcuVVc5N3flxYlwWIzEY4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On Wed, Nov 4, 2026, at 4:13 PM, Christian Brauner wrote:
> cache_poll() sleeps the poller on queue_wait, which went back to being
> a static queue so that a poll() on a procfs channel file can't be left
> on the queue of a cache_detail that its network namespace freed. procfs
> owns the queue poll() uses now and it outlives the file, so the procfs
> channel files leave the poll_wait() to procfs and an upcall wakes their
> pollers through proc_poll_notify(). The channel entry is remembered in
> the cache_detail for that and forgotten before the entries are removed.
> The rpc_pipefs files keep sleeping on queue_wait, procfs has nothing to
> do with them.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---

Acked-by: Chuck Lever <cel@kernel.org>


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)

