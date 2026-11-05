Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 355ED606A32F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 09:52:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 505BA6B05B0; Thu,  5 Nov 2026 04:52:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B7046B05B8; Thu,  5 Nov 2026 04:52:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A6A36B05B9; Thu,  5 Nov 2026 04:52:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 187776B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:52:32 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9D4661C4238
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:52:31 +0000 (UTC)
X-FDA: 85400600502.29.7E33993
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf30.hostedemail.com (Postfix) with ESMTP id 895A380002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:52:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793872349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SqrTjgENN7Dfs+HehxbKPgACeb32UvvfMAFijNHd6N4=;
	b=SHFNwKTuj3uPlYL88lwiOZJFyHjp587Atg7I/8C+o6nmcyqXFVmxTstNB4bqqTtP/52Xsr
	5XmszAZGCxmWOyZFiErq+PtQ17VfFFo2kkCylScLZwfONBrHJeinxAWM4bQqsZbHco5Kka
	ELjnuTQMYeW1fArOco7y3+BFycZ+2q4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793872349;
	b=eyoXjVtG+3LWXDXsiudoy7obAq2OqOS6kLaVxodUe3wTHzTgFs6oAJdL68NtmFHHKJ+GSK
	ezMAm6GJUV9Z4sdep33Pk/ehghPRX/W0WrcUGeNd3U9QqRnG+c1jdGugFwgUGtshjfbBZc
	I5ktNK15pnwMpKZSLxdnVhXL0n4eF7Y=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-91c79a9a739so23591996d6.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 01:52:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793872349; x=1794477149;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SqrTjgENN7Dfs+HehxbKPgACeb32UvvfMAFijNHd6N4=;
        b=LLojfy7JNAWcZqaiS4oPjZcp5TJfwx4bp+wgyoHIG/pyWVmRA6Z4xlLW+mySgy/tkE
         W1vJTXLAcwZwRr0vNjnbEmSvxZk+BO5JZXev2MOEltKf0Dq1V2Vlph4nXk7HFJbglq+r
         j6BZ17bO67scnqIaFM+LOYMCuE0B7AZYduEIiSN6sgqapMEz7uhjvP6mQ9ml1NKgb7yT
         Hq9RGlF2DYJkTlBYyKKeiG+ZFVdHjIHn6gvxKbp1H8LZczTSdACuVvMDgC3YsDTO6YA2
         F7PrUlYEN7SLFXgdEEMiPZgqF5Iw17ScZMMowo57onpdWdUQzTvlhlMvfvb8HohEvpFQ
         /IVg==
X-Forwarded-Encrypted: i=1; AKwUvBygMcASIbf7filMy0MD2I8WAQjUBDFPb+Le5ef/HBTt9DQq+662lhQ2P19nbsXsI5U3Z5ehPwJk1A==@kvack.org
X-Gm-Message-State: APuU4Z+a4T2MEhd1KRiOLnRQOEJoxHraXWheE75tyOBRpeR7ITSFTl6B
	LEXTUdPwqMxZpIRZZ3m0fvzVMoJnHULsdvZTowbVmSzeCu85JLlKxSfzxdns1IHfZD8=
X-Gm-Gg: AYBFou300mf0PhOWi1ZL59udFHXuqsBoh1svc62vbrWqFTe7mPLevjbJpezSFRBKAd5
	DojXB55DEX7U/0GAs2L0WHkxAlwUFtX4VTUap/da70WvhmauCmU0L9NkMXccf9k4er6KVbu1AQN
	b9m1HgBwMfS1R7FHUfsL0SyysSP1Dm7bukQ9z+hAvqsnGK4IE7+YOo+nGU2HJTVdQiksJKA52/S
	Pp9sFkMyGtYdoOoX29tE4WPCgZCrj9AyrtvSZAZKw5KNWD5NXpjAZooniU2oomoKjymFWNAX3jG
	UFUAwEcXZACdtHUPR/r/RM4VUmEgwa0Qygnxlv5TIbC10Pg2ONmkNcqR48KeM9GnAs+CBcuX+RI
	kVQdfkE9PbdW9PsllEc2SUHrmC0QFNsSqwev2uFUvJQ8sEqB+ybz93vTnMqKClLa07UQV0+rX4O
	6Xcy96tzKtC6Ij9STz63X2VfK4sNj5v3Fnqf8JXvssskHUFrhQCb5rpCL6kXMZx4QJ2DGZVeyy5
	SWE08w5/UemfG0LztMlVnoLrdriUcG7xM0VySyPC2pGSm5uXdRsNNf8X0YMoLgwYkzJz7yo7JZK
	pQc7mmIpE2Bs1WKrwHrtkBfypkg7eLFr6GKIipaZnaBKWxZxYDIq4QZFttrlKmXfMuuXPEN+kL4
	TiVBjq3wT5E04uPs=
X-Received: by 2002:a05:6214:246b:b0:91e:9ada:f25a with SMTP id 6a1803df08f44-91e9adaf733mr10703076d6.23.1793872348619;
        Thu, 05 Nov 2026 01:52:28 -0800 (PST)
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com. [209.85.160.169])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91e7dfb3a6csm43407346d6.13.2026.11.05.01.52.28
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 01:52:28 -0800 (PST)
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-53653e30353so21938881cf.2
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 01:52:28 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzU0CQWpizB6/XebnKlVTlukJ7aIRtWP0LXZoksi4FEhNDhi3h2ttE796TcbgL9VkMxHBO7SE5HpA==@kvack.org
X-Received: by 2002:a05:6102:3ec5:b0:7cc:2bb7:131d with SMTP id
 ada2fe7eead31-7d072baa484mr7324212137.9.1793871885062; Thu, 05 Nov 2026
 01:44:45 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org> <20261104-work-procfs-bugfixes-v2-10-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-10-021c84d852e0@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 5 Nov 2026 10:44:33 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUy1RYKG0g8OWss3AD-jyYx3DXL0K7ABYkFUdxTxZ9VdQ@mail.gmail.com>
X-Gm-Features: AclHuK9D-nB8icBns0zdoQH8fV1cfUPJ6LOey8o_VlUZpDIGqKC4cFf8-j5-HdE
Message-ID: <CAMuHMdUy1RYKG0g8OWss3AD-jyYx3DXL0K7ABYkFUdxTxZ9VdQ@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 10/51] zorro: size the proc files like what they serve
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>, 
	Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
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
	Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: w8toe5k99dr9fxgie7p5geg89495mpnr
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 895A380002
X-HE-Tag: 1793872349-556453
X-HE-Meta: U2FsdGVkX19rOLqOveFxIn9BMU6Ph268KyZW3Aoq2nb7kjRebmHkr/lCcfG1IY8FIJTAzX2/2sg7P/AAoaFHjCt/KZRgL/+5dDhLAf110LhW6jOtu4HeOytIHoLjR+d7eJkSBI+qEIkg1UUF4gPpDDIyPgB7cliOdejRPr99DVGfznjHW1gTomMR6csTyME9XvlFIm8mtsV2e8cu3iN/Qhnu+aT7Z4hpWlQi8RGyynJe+KfSK5U1UBlirEarb65p9orPw4eP81Hse77F7z9+P4P3G3eiWqD/tXiaRGrQqe0xxFEe8n14DJoC24wAF7tXbi5gMSg0X3efvBtO2XIAm/mzjXkkW/uQamRWfic3AKvM+zHN7h7r0p92dNRc8+BOzwqZYJcMLni/sQ/JEL9qiro/oJ5A0i/xaLnHTOr/mdx8DIbrLe3CIFAkr9N04KdxO91jTXKY0J98aER6yPYAzk6hsakU8BbQD4ErVp1XUw9ztZ7EiTNv5rvUxUcJ//CJ6UsnOrRJvg2X9C9YQA83PeARzdeucEalCRSchmKnq7IRRZJAsLahgZ5jjBHtzZIv43t8+n9ye/AxBvU2D7tyMsBAKT98IUcFv3hFf4xOlLIeuux88s+fxX0E+KwKpXc05G/Tp2u8yk16LK2VmldHuNY/9+4r2y4sAhFdYTQlmsMlsqBzGbRm/xh7FhlEVOTBv3d5UutUvBxm6WwUSfUPwL3CK8kO6iB7y7IYBxoOPFoWtrpmKJyhGS/jtWFnULJcebon/0A+LeBzuVNop0cbf5+aN0KHoevUMOpaejZ3RTOiVdYYdMTkibkdR+rBwFJZQq9dJd18b2Gix7qNCmCaVsSp9quKUwL5fwfurS4YPibfikV0WZXOIGjDk8FzhYC12kyhU04s0Vka7gwJHNcPotnMPK0DhvoXcvmoGZ3zn44ljK4SxrcVfVL80NQx8PCs0ME0ClIAUyf8znO5GB/
 u8LQVn1P
 8jR/RalP9HQpNR6T5OFNETb8SLKHbSx4w+hrGtdLOWNcRkf5nWG4dQZqpm/7RdtMIaPvrpnVin33KjpYRTntQaWOyhtJKvCgaIJkhKDLqWGg5Ek/WH4gZ9FTG26mH3wvcAvfYMVpWfrInurgCet4Hb12U5dF5cSU7TSW4FI2GaU50UR4cswbfybJWkp2ZfcYKQf4nT1rsSL/aTr9EIe5f/yt5SwyR0fUqyUAxVEcAVq1FT3ygW4c96MQM9QNwDUMcYFK+6EJ74u8IzugeZdIzUQDInJuW1QUoeq+6lTOUs1KpJhC9JlxoKFYFaa3G3bDfOgdAUK7ddVyQDvUqqBpA+SBqCwzmCXn6TzCdc49XCDxQePF40CAiJigeESjrIrXXmTPD9WFhVwXi/T67fClai/nvmWlmHKYdjoTbwU33BO1SkBK5S1j6qezZMZBxDqVuU1A10oO/OVwrNyKO94je8hFX0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 4 Nov 2026 at 20:18, Christian Brauner <brauner@kernel.org> wrote:
> The files under /proc/bus/zorro hand out a struct ConfigDev and seek
> within that, but their size says sizeof(struct zorro_dev). Say
> sizeof(struct ConfigDev).
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

