Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBCD3606D3E7
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 16:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DudqRbSQ
Received: by kanga.kvack.org (Postfix)
	id CADC36B05B4; Sat,  7 Nov 2026 11:10:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5E506B05B5; Sat,  7 Nov 2026 11:10:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4CEE6B05B6; Sat,  7 Nov 2026 11:10:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8EADE6B05B4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 11:10:33 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 283171603B3
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 16:10:33 +0000 (UTC)
X-FDA: 85408810746.08.81746C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7E5451C0011
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 16:10:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DudqRbSQ;
	spf=pass (imf21.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794067831;
	b=JEYioPIpfLDG3TxpWUm2sb3zP21n9msDMU1u4xZAd9992sxE6PJ/HFVTdxrh02cpD2epgP
	TxNlAZGlCdhndbu3GIDzNfRbLg04iHJYeR81dqe4GY02Ynyjh6mVKJEvSOdRo3eBSHpjPk
	Gwp8YYGwHLRrtDQ/9hVk3Os2X5xZi0g=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DudqRbSQ;
	spf=pass (imf21.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794067831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yrl1fDgvB8SejpyA+O0u1vRjlm41/COeTHtKBCR1yZ8=;
	b=QTZhLf6KHg3WTStVnI9kTEn7FNnRId2H7PcTt4rjC1imNejB+95p+EdaRJlrsxoWHpA1Mq
	9jBFwuiVZOl0uEdHQavdZrhEktdkEqoCoit43Y1rfxj9fZMsUUjI2KIL82g8xCRE/l+zgj
	Oc6rpRjHWDGFvvT1ezpq2aO4jZA0DGk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8275861877;
	Sat,  7 Nov 2026 16:10:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1758C1F0089F;
	Sat,  7 Nov 2026 16:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794067830;
	bh=yrl1fDgvB8SejpyA+O0u1vRjlm41/COeTHtKBCR1yZ8=;
	h=Date:From:To:CC:Subject:In-Reply-To:References;
	b=DudqRbSQXCpr6NhdcgkB28/OJ09fv/xb+ZGVAY2ZZcm0NtXYxKjH24XfLPv1YVH+1
	 N2Smc+eQQaJmUtmHSjIuIOHPbXtdHkwnaUWqwn18l1Zgme7MhVjd/tmwPXx2sHiZmJ
	 bVG7HcpDVP0TwBfdMqAH6zxIyHwUkaCeHOVhR2aYppt91bZLwCTiFYtodZA1aRzQhT
	 JFzXQc4CJvaSMHUeBSzyyst4sJaPobtuTL08pUib1PO2/6JKi1TR0Oc7vVJSOMiTRg
	 di9pOtOgBcjQKNqN/zgV0r2ojSo7IUXfYme+kVAZvSpJolvZJtmmOXjKLjiXPaiu1m
	 qPutBKIcKy2tg==
Date: Sat, 07 Nov 2026 08:10:28 -0800
From: Kees Cook <kees@kernel.org>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
CC: Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>,
 Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>,
 Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>,
 Eric Dumazet <edumazet@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>,
 Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>,
 Joel Granados <joel.granados@kernel.org>, Jan Kara <jack@suse.cz>,
 Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-acpi@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-um@lists.infradead.org,
 linux-wireless@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 netdev@vger.kernel.org, ntfs3@lists.linux.dev,
 platform-driver-x86@vger.kernel.org, coreteam@netfilter.org,
 kexec@lists.infradead.org, linux-pci@vger.kernel.org,
 linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net,
 jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org,
 linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org,
 linux-sh@vger.kernel.org, linux-usb@vger.kernel.org,
 samba-technical@lists.samba.org, sparclinux@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org,
 linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
 Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-debuggers@vger.kernel.org,
 "Christian Brauner (Amutable)" <brauner@kernel.org>,
 Chuck Lever <cel@kernel.org>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_RESEND_v2_07/23=5D_proc=3A_let_pr?=
 =?US-ASCII?Q?ocfs_own_the_seq=5Ffile_of_seq=5Ffile_entries?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20261104-work-procfs-core-v2-7-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org> <20261104-work-procfs-core-v2-7-76ace653a773@kernel.org>
Message-ID: <8A21EE2A-F392-40B7-9152-CBC440FDDA70@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7E5451C0011
X-Stat-Signature: rskuchm5ffnr5i55pbto5i8894iy4ar1
X-Rspam-User: 
X-HE-Tag: 1794067831-849024
X-HE-Meta: U2FsdGVkX19hB39KF36H7ZalLRnJtlmgD1UfSdxtABZ4pw4vWi98WXbzjnrNBa3pL6hQmz42DFmmvNs4yc8QZukXzT+vQQ4w9FpWqIUo85epsJ1OeMKqjED/LrTtYybc6BGpxJSjLT0OqOfVpUCof8ZUqDDKnALve96/Y2BV8/1XJgGLtwEEOH9zcIZCr4TS7E6gugZIyv3MjslWkjpYUH+Rtx/wSegj6vdG8qUvu/raj8YJRxWHyDvXVtM3IFycSzHojekd8Ll8ws32upQzNgpXIyoqcoqZNvfinBKKlG1aItPmzXhbMt/T5nPmmUFlg/hmWpYORsmk9kbn5i5S/sOjzKrmfIfKfaDymNz9ONTNM9xxWqUcOMa6X/77Gnf8Ufk4Ibo6K7/vU4tbxtEMor1LwWDkPmmHUv0PFrnIIwzYGht8jGxcBDLv9et1CSaRYJR7Gv6JxBYwcn1JfaD0nXdmXGlH8AUsYFulV5oLmKQLIeQFoV0UVkSi5iEcGOSoNYXTCuEhlt0FjXWfbD6yeB01t0bv4HFrEULH6DK3ekRbuE1C16f9k3GCu8p3Qw62JMeGPOU92zvi5crsLLHENXb+YobIv7YeW9p+DV0D8az+P8WKawz1T70o5Bi6SLXq98w1bjh7iwqkzMDhv5117gZlU8Z1elH+R2il28tA5NmSObQSckov2qK4sxLcpMhOTay+2IJVI7XbVu6SP7U+URP/t4YBI7ZWE/dsZ0ocMTAPz02MKnKHpYRphSb/JNyYymQNqxQFjWb63Ik4nuFjNALa4kdeC4D9E5qfknOCxEsODPZcV6dL/eMSt9Su0KtBy0K4Lq5Oe/yCe7abYrzZREWUa9tI3lOqLurflWif5ecVFgBPxmvzYKdYTjkeYV40S1huwfMxfn851ckkW6c4vpudBMraBiuAwz1HDLztQBKrndSQgTnOuk3kQBBRQZc/qDvGfBIurIfRPV5F/5t
 R6TBtOcz
 eREY8jyd4sFwOg0XZNah13IXE8z4xt6dnmb1ZgzkOz6xiubiYQQ3eRrPyIdNRUK2qlhkDXbtq0Zmjqsy3ZxJpPhLjjWCuS0o/KeDSIBkbPrUaMcyI4AKOlPDFBEyf4pvxhHmIgfv/yJOdFfP3o8UJ8ZkSkTHAXoLAEO5sJsFK/LRzznLaLzVIEWJx0jw4KsrVlCxtJwLuhCBus5wkTyLKHKVWOqe752APc/1fUDVLWyyfvE6ePFgJYDygiDQozFl6url5jRKiIP6m3tBYV5iIY5ci3XrIexxnN4fq9jqRKorEQrR3JeR5D5RwP/EsIXL8Imv1Ia2S8oo5SJ+iFVU4Sq/DBqhf3nWwod06yDQfNGb+wBNQ5ZKFaOnn76ZLHuCf9FDI6uuuYniUQIQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On November 4, 2026 11:30:58 AM PST, Christian Brauner <brauner@kernel=2Eo=
rg> wrote:
> [=2E=2E=2E]
>+static int pde_init_seq_direct(struct proc_dir_entry *pde)
>+{
>+	struct seq_operations *ops;
>+
>+	if (!pde_is_seq_file(pde))
>+		return 0;
>+	ops =3D kmalloc(sizeof(*ops), GFP_KERNEL);

Please use the new style typed allocation calls for objects:

ops =3D kmalloc_obj(*ops);

(This happened to jump out at me, but please check the other patches for t=
his pattern=2E)

> 		dp->open =3D kzalloc(sizeof(*dp->open), GFP_KERNEL);

Same, etc=2E

--=20
Kees Cook

