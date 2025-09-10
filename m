Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 079DBCA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 16:34:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 365E58E000A; Wed, 10 Sep 2025 12:34:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 316418E0002; Wed, 10 Sep 2025 12:34:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2049A8E000A; Wed, 10 Sep 2025 12:34:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0959F8E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:34:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 945201DA053
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:34:50 +0000 (UTC)
X-FDA: 83873889540.17.7A96DD7
Received: from blackbird.sr71.net (blackbird.sr71.net [198.145.64.142])
	by imf19.hostedemail.com (Postfix) with ESMTP id A1EB01A0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:34:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of dave@sr71.net designates 198.145.64.142 as permitted sender) smtp.mailfrom=dave@sr71.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757522089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G1VGNtTxsSa5nO2Imc+ky+WEMJh0OsY2+KqAjaV/88Q=;
	b=XWHQdnN0YapS0ILYlOfvF4DSCXIhsC1hxMFDf6Z26xMtG/c7gN5Vys+3egk4GD9+f/Cr0+
	3HZfMolYV1+jEssFpsSURLuHf3iY+HoUT8+ZTscrH58Jh22xQdJENmT9/idvWVnImcOWMt
	Sy0feUnsY5LAt9hPDZMjqMXM2Zsa2l0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of dave@sr71.net designates 198.145.64.142 as permitted sender) smtp.mailfrom=dave@sr71.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757522089; a=rsa-sha256;
	cv=none;
	b=CmNH9fre3mqlEtSR44/e8DPR1Asb6wsvclH9q4DJiQr0J53eONPwys5N53iYZPTpJi8RJ1
	VOGGqYQ74VQ9ZsffF4gEsNt5yB3zjjoevZbsS0QhJxVHLCNUWXXTgi2m9M3HE6NPDBrrGk
	tRtuxrSZSKaDAMYKTuqFD5q84uukvxI=
Received: from [0.0.0.0] (unknown [134.134.139.69])
	(Authenticated sender: dave)
	by blackbird.sr71.net (Postfix) with ESMTPSA id 4234E20193;
	Wed, 10 Sep 2025 09:34:45 -0700 (PDT)
Message-ID: <dec53524-97ee-4e56-8795-c7549c295fac@sr71.net>
Date: Wed, 10 Sep 2025 09:34:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
To: Richard Weinberger <richard@nod.at>, Arnd Bergmann <arnd@arndb.de>
Cc: ksummit <ksummit@lists.linux.dev>,
 linux-kernel <linux-kernel@vger.kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 linuxppc-dev@lists.ozlabs.org, linux-mips <linux-mips@vger.kernel.org>,
 linux-mm <linux-mm@kvack.org>, imx@lists.linux.dev,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Lucas Stach <l.stach@pengutronix.de>,
 Linus Walleij <linus.walleij@linaro.org>,
 Geert Uytterhoeven <geert+renesas@glider.be>,
 Ankur Arora <ankur.a.arora@oracle.com>, David Hildenbrand
 <david@redhat.com>, Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, vbabka <vbabka@suse.cz>,
 Suren Baghdasaryan <surenb@google.com>, Ira Weiny <ira.weiny@intel.com>,
 Nishanth Menon <nm@ti.com>, heiko <heiko@sntech.de>,
 Alexander Sverdlin <alexander.sverdlin@gmail.com>,
 "Chester A. Unal" <chester.a.unal@arinc9.com>,
 Sergio Paracuellos <sergio.paracuellos@gmail.com>,
 Andreas Larsson <andreas@gaisler.com>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
 <497308537.21756.1757513073548.JavaMail.zimbra@nod.at>
From: Dave Hansen <dave@sr71.net>
Content-Language: en-US
In-Reply-To: <497308537.21756.1757513073548.JavaMail.zimbra@nod.at>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A1EB01A0005
X-Rspamd-Server: rspam05
X-Stat-Signature: cm4m1a4m8mhpwr4oir1t3hxxsn98ij6i
X-Rspam-User: 
X-HE-Tag: 1757522088-824399
X-HE-Meta: U2FsdGVkX19507B1LP8PeOtLhE166h4CLWPP5H7rCrq8Mb13UTzZi4FIkMMJK1Cbup1maJovqkz9uWKpvu+tpbk5TGhoxqrhfnGeGd4X26qu/tDT8XuWls9Ft7+jG1FjQEmZT5dJJIdZgqgJTIhtvMPs9Sb6cKuC4CRL0ATeycU9GX4RElhij7hNlYbapFj3Xjs99NrVgaomL065XrDtBuAJ4D40cxTICBh0RryxRUmUtJBYCXTfSqBxZ6kip/EI36rjrizJYAGqWlbwnobpxtOGONgjudcL6QtZ6MDILFuXdSAKaax3nyFCaEP2gCFeQMu18EPLspBfFTXhCNAxuWVoSBCKtqykHhw7sUGy26xLMiRlSvOUClUcAssR6HwVNysgfeAW6qw3BGHRLXSXDN7SSI7vkhnfDCNQPeTBm+srBxFKj17+mvwWG2WFXmtjS3uoam02GIY2B59igRw4cGE1EyFjepLzlc1k81sUNNv2883fDTqGQAa7YGwINBOnR2DMB3bQRVAkTeYiBvEirNdTfzzzCnkA6Rrh2kFdzwSh4vAetc0rhW9MIQsOUJyWVzu/YbyH45QDlSM02DR46u/Xwkq/TBE6ID6B99jHY9qwGGe3OV9r4dU/Iln2FoyP/P/u1YJzBfsmnQ5geMHJNeWjxks5dEuq8oZpHrRFfy93E2oZSY4cnbO5mz7ncAxuRbQcqpvLU285dssPAosIJbK6JV3d1xb5efFhcICblLF1OQ1cr2LAb4EClqGrA01c6zNMbUMSGk9hBURg+WiMHf1Rw+64Atnjk7lsyhnn4Muwyaz2Mgrai9Qf2b7QKL/jaA086kTVatL4+SzBbB/qF+J/fYkiyUbCDQmX39Nci+ws2oXh5qWZpEl1mkQtRYxvYg6YMcBsQuiH/nC0Pb9GL9ZCySLG5ZRwG+qgKD2FPgCILDtsgcQP831WZedDJjv8QMSLDugxQ5q+Y3W0aY5
 0df4Rkl2
 4+j8pqyHEaFfcqxUEIzjMluPnR0xc0qXjjUEY3pa/BwmixZWsfenklINQNkodMkHNAZVtnGmmiTsx70pke+XNN3sxzsjnNTxfXoAz9vNXE82cVj++lyJGG9fgbcmaWdyMRbgm2JeIgkbLEw3ainih2rUU/6Ayi0m5pddTZpT9qb9gUud0ss8uOnlkiGSTveIXmzyxT1McAQ6jh3eRFtn8BiMmgjAPCYCARxfppMR7XSSarYs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/25 07:04, Richard Weinberger wrote:
> I am part of a team responsible for products based on various 32-bit
> SoCs, so I'm alarmed. These products, which include ARMv7 and PPC32
> architectures with up to 2 GiB of RAM, are communication systems
> with five-figure deployments worldwide.
> 
> Removing high memory will have an impact on these systems. The
> oldest kernel version they run is 4.19 LTS, with upgrades to a more
> recent LTS release currently in progress. We typically upgrade the
> kernel every few years and will continue to support these systems
> for at least the next 10 years.
> 
> Even with a new memory split, which could utilize most of the
> available memory, I expect there to be issues with various
> applications and FPGA device drivers.
I'd be really curious what the _actual_ issues would be with a
non-standard split. There are a lot of "maybe" problems and solutions
here, but it's hard to move forward without known practical problems to
tackle.

Has anybody run into actual end user visible problems when using one of
weirdo PAGE_OFFSET configs?

