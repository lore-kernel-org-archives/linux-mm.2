Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AE716082BC3
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 21:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VN2aaJi0
Received: by kanga.kvack.org (Postfix)
	id 77E516B05B2; Mon,  2 Nov 2026 16:12:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 701116B05B3; Mon,  2 Nov 2026 16:12:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CA956B05B4; Mon,  2 Nov 2026 16:12:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 24AED6B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:12:15 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 021A8160258
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:12:12 +0000 (UTC)
X-FDA: 85391426946.30.EEC494C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id DE121100009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:12:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VN2aaJi0;
	spf=pass (imf05.hostedemail.com: domain of cel@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cel@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793653931;
	b=eSzrqIFg6MxBnVTlLw7AwolUgFLPft4mL5KFTHJrgY45gfGnX8kTf4zExvEO26lqnarqLJ
	BVPNs+3uRnpLaWPVU5iEgUGqVNdvWDiR9oRmfpA/ORe5ad3IsXvw6ROo5eh0bfoi2g5eoD
	2puWK65E7i8O18WuQOuqFarHeL/K8lE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VN2aaJi0;
	spf=pass (imf05.hostedemail.com: domain of cel@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cel@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793653931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2GzKULsklpP+bGy2QkTiTCDYRGUHpWIftO7smBM1HBU=;
	b=vND7ppNtpCUAiBeHGCR++cQYol01pytYTRfh15s+OEDdBu1G8XJFW9KjxfUC8Ch5fGxVtB
	u/NXjKwPZnbQeBtDxL22sKhxj1haXnYOkyU8hB7G0qNaLFU+OMBFyiRMmj61qTRedHziCR
	jVXHTGEW+OhJBJCml6gLzG/mcL6JBVA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 39AAF43E65;
	Mon,  2 Nov 2026 21:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920A91F00A1E;
	Mon,  2 Nov 2026 21:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793653930;
	bh=2GzKULsklpP+bGy2QkTiTCDYRGUHpWIftO7smBM1HBU=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=VN2aaJi0Enpo/UwbibABrTO9FP8EGEVLUb/vz9vQBNp8OjC3NmVCO1mof8njQrb0N
	 8nTaojVL7vqiOuVRmq6zN/ICTYAKzSqCZH2qK1irIxxLycT71QkpcLIf16xxIK093j
	 lKKQF1fjRBAJ5OCqWniikA7NThq5OCN0EujOkX1IqIYQgV5w0Qbi3132kg3ee/7DDv
	 iZOteq29zRi36GgmLA4PQTkgMuWdxOHacxyUYs54S+gyeSe9Uj/RO7kAaIBRnQK0PC
	 yGCoolHduytEqDS8DEJewjzj3XLbooRKj+GefsCn1nFmGMsKRiZSByfrTTgdlxRhV9
	 MrUhNhz/3+a5g==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id BD91CF4006B;
	Mon,  2 Nov 2026 16:12:07 -0500 (EST)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Mon, 02 Nov 2026 16:12:07 -0500
X-ME-Sender: <xms:p_zoar5wEOL-zlzp67mMM3x-0bNAjLemfC24U704bCdiqApcAHrL5g>
    <xme:p_zoaruIAZVbhbJzkx6BZiPT6OnY7CcZh02-zEnuIJo4UcNxLgosp2J6h-TjliEVB
    ZqPJYchFTqtRNpd3xztymrlwtOCf3UCUYjdeN78ZHthOZxdfY00mLZG>
X-ME-Proxy-Cause: dmFkZTGxQYs5bpjtdWlj8Aj0/kqiZPUFTcG+D5sN6gK6OkOpehgbLdIraoHIQBNOWiC1QO
    mSiq7CL0AgyKU65TRh9vty9eizP0QQR2Z1J75kzFRAHQ8v9pgNzRqji+qoE5q3T4Jsup+X
    lzhToSRo/U4CDB0WiseMMwJQb5pcYnSUocPTYgbfxcxlJvkIz24hVYMUVudHFBxGqfAX9y
    NRDQxVeK5x1i3Ddsg7AnpUJtaaABZOgfFKMPhhjC21xlDH5T8xynEUHv8Edi58BP4r6DL0
    tXBEiINt8Tc23nn0L1i3BHrhk7xFRR/K75qYZJEABSfJdxx23pck1s5cvRrC4mNh0d07cq
    HGqupMbxlMLGMsZjotNq8oNhgdgag6r7eoO6ewOX1TyUeE9ji0ElKsavbILPyuWY3lDPj6
    kLgEwwgkqtpl6Law0FU+iVEL+uJ3v7diWIhR0jGD6twa2ajmdS50u8Oktw1hPNF+UDlUQg
    yRIKtfDMmxM/Iq3R6DZSCzcwPA38v1HlDy+8UHl2XtcweDNG2ziQfFDzT1wklzeKBNEIzn
    ncu1wt1SWxYrYOypHpFH//wS1fzQ136rl7/PeJ5P1hx6Kup+TY4sKx8NYC5+s3heyhXAT3
    qvO+b0k172/Cyt1JkoPLBDRysBXKaKKQpHWfUnjG6Zu8N7q1Sv1Cn7PvRxMg
X-ME-Proxy: <xmx:p_zoaoHJ7xvsGvW3yFXcg2GyCfq0QOXNhFMLApvXbwcVoRvOTLpFJg>
    <xmx:p_zoaqD_fWcNQS-k0yAhxYt-R3IJf7E5eyB3ofH-w9Jcw-Ciu6FGTA>
    <xmx:p_zoaiEsVZ8oScPDYN1YcYKCJawqQx0MVy6PLKPjVBYTbZu4plkUXw>
    <xmx:p_zoamlot3YNd3N_kPvGE0BeCL_hccbMjKBcqkXjEFdndcPA6R8aDg>
    <xmx:p_zoajqn1Cb4ZRHuQPt4ntIWweEfW3VpSRM9FhhgkVteT1l-hSkXouXh>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 96E7B78273E; Mon,  2 Nov 2026 16:12:07 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: A5s7LfNSi9ds
Date: Mon, 02 Nov 2026 16:11:47 -0500
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
Message-Id: <7a864852-252c-4a62-b4f7-33072e33b7dc@app.fastmail.com>
In-Reply-To: <20261102-work-procfs-net-v1-9-982104a4f592@kernel.org>
References: <20261102-work-procfs-net-v1-0-982104a4f592@kernel.org>
 <20261102-work-procfs-net-v1-9-982104a4f592@kernel.org>
Subject: Re: [PATCH RFC 09/11] SUNRPC: drop the ioctl of the procfs channel files
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7strewms9dpzi9hb5pqtr195sp7i4kyg
X-Rspamd-Queue-Id: DE121100009
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793653930-674802
X-HE-Meta: U2FsdGVkX18ZGyn1C/jKpbEtS7XI88PpuDP8786TyVQGTTRUgXoiPSiddOb3qip6qT3qompK5SKrxkLPGCsm6tW7NSXUx8weSAtdBSULIpRarbLslQDmbQ+sy792iJTcTJZM/iwyaZZyn56fCZSZlg59hPm6uhaMf0yIJfi5IFoiXwLd/OoMPx8LIq5DRrNiyTMyQEYLv2G3WNMZ/zw4kxMjfutCchx1PhD+fyxJM9uobWFpizoLaItGnpLdkJf0Lw7XCx7lD2/Y2mmKUgCnQuuGFN1yB1gadnglAeipiqsV9lWOdmGwC/vcF6zDHm8nsnGoLP9aGf0A0/NiNGa4xk9+l64X+NdE0vINQp2vuATvDXPpaf2uwO4bDV0KG6+Wlh2UZS9U1BXWuH8p2IywrddtTYlcHdDV+bgtYpJa2KkkmkQlJc9UXFW6Te5iKhc9sDdz40buYK1juve3hZi2tFfF75XVbrmwyarZyw0AXfu4Peop1jA1dFWpVExPRsGHlB8EEWRR9wK6Ul/UoOnpq8yHcANlwLOG8gGsGOyoLttlBIm4b9E7h2I8Lw4pqTHIh8a46WJoSzDIdGnlhAWzBR735n3rwGq/RI2svHjariG1Q4kUR64U3SD1TabIfQu4FZarqgS7MEiiOj9jUnEfYCJ5GnsWEviLX7PBJSTf2IQdwh1O+t+xUpcDSlIAtpcrHajVB/Z4MA161E+Qxpkmbts08DLrF+Qb6me+L+SRt3OHo4Jk9t7HJMOCf8zHi2kK+k5D7Xk6YDA91f07fqrICQLegkQfiC/OQ7tP/0oNjepwDVV6ot0ohXQddI/CjT4zxJqEtiF56GceA6BAcs3RDvnqpLYly5Tu+XaDUyREaxd10d1LTMYfkCDrFlmFSIqYf6IZEathfWfk+jLgzPoAiD2gSWtRNzNeQDvHSv1fvjiBfWSswwkpSAmEZWkaDZJqkhAzCVHjtgRI4/6ieEn
 3Jsoj5b9
 +tzyBy1THKAw77gj2KD9CEEQkiNoK2X58tBMb+mo33bQN4pSEe7oJ1uVWk5NEyAnIMMdPWR6ym8rLeHtex4CyH0Spb7Fh4nmulzgIhsfGyNv9+rSEIo+Ge1VWn5iTNleDwGTyDpdRqN0jz9zwFYag7yqIFXnjsivgynho+KGkIgU1Z57MJoMI2kOzoY3yj60mmUgRCW9cO3mD5yPa72YVrvM7pUXQbPSHJF2hFdLBEVD7sn30XNtdzk/plGS2bWhp5r/BIYMLHbhGg7OpseG2uWFMpEIzBs0RIukJDFN4LtDTleRxDJMGpQHjTnmBuOrDKcmSyKMWCGSjJtPl09Fua0PDbwDik4X1kMrM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On Mon, Nov 2, 2026, at 10:07 AM, Christian Brauner wrote:
> do_vfs_ioctl() answers FIONREAD for regular files with i_size - f_pos
> before it gets to the file's ->unlocked_ioctl(). The channel files are
> regular files, so cache_ioctl_procfs() has never seen FIONREAD and only
> ever failed other commands with -EINVAL. Drop it. Other commands fail
> with -ENOTTY now.
>
> The rpc_pipefs channel files are regular files as well.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Acked-by: Chuck Lever <cel@kernel.org>


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)

