Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB2AFD3EE9D
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 17:26:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 347C86B02CB; Thu, 22 Jan 2026 12:26:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31F0F6B02D0; Thu, 22 Jan 2026 12:26:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 255EA6B02D1; Thu, 22 Jan 2026 12:26:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 150E56B02CB
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:26:04 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A544DC1BE7
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:26:03 +0000 (UTC)
X-FDA: 84360277806.14.120B3C6
Received: from mail-10628.protonmail.ch (mail-10628.protonmail.ch [79.135.106.28])
	by imf28.hostedemail.com (Postfix) with ESMTP id 87C69C0011
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:26:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=c07CYpp9;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf28.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.28 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769102762; a=rsa-sha256;
	cv=none;
	b=vOT6O+RrAVBDypKPuZbYQqMPpZDnxtleQwXXtVhVgbBjueWeoSrqStTdsjF5s4nSUPF3ku
	zy1tpTW8wfoLUjdmwZ+gRrcJttyH8F5OovCEgCuyYkp9a1vLDjCWorTPusfXWRoe2HkcVW
	AMHUwHnfS7Asc+zYoYMpXk7OT269K2s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=c07CYpp9;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf28.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.28 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769102762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nyjwh9Rs5YqQ4WtOoe0Vcb06dokpFc8gAXu8v/qQW98=;
	b=zgUwCuPstdjgLoQ2/tCnt5ZmcjggPs5fHc6DsL3Gcy35stAwTu/RJk8tbHYRLwrSi2UgIB
	2PfXuvZQu51xcRMfyRGxOSpUPrLKFf8RiNPuv7p3CTSMMvKesOHj8E/5xOq1f2shWMD8E0
	ZMxOPvJeDoFFGDsmg0le95ex/ddiy+4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1769102758; x=1769361958;
	bh=nyjwh9Rs5YqQ4WtOoe0Vcb06dokpFc8gAXu8v/qQW98=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=c07CYpp94NIFyoXpn3kW9d+lErgFdARNLb9OXtFOY1xHVNUtO7s3LxdFbP+VmxIwN
	 J3xDvdtLWKso2Ppg10yfLSpRmxdPN8CGBQGjy66nDxsX/h3f6GcDr7pM9ShGxq7ha1
	 jF+1ZdUU55T3hRuUQ5ucsMij53ElLsCsnczXZ1XaHT8k3KDhv5+xb4R7Lm58ur66SF
	 XuWrbsA+/nxs3fbevZmb2XAZDUCdcZ/ZOZE1/oorhRILXjctvWsbl7cfQcr55Im579
	 d4DcjWuqxA2BMJF/DR53xWca4z3MKA+FsanD1Opn7NiWHtGxokkUjtJJDSPCvHglpS
	 g5QJpjK/7AiWw==
Date: Thu, 22 Jan 2026 17:25:48 +0000
To: Andrew Morton <akpm@linux-foundation.org>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Borislav Petkov <bp@alien8.de>, corbet@lwn.net, morbo@google.com, rppt@kernel.org, lorenzo.stoakes@oracle.com, ubizjak@gmail.com, mingo@redhat.com, vincenzo.frascino@arm.com, maciej.wieczor-retman@intel.com, maz@kernel.org, catalin.marinas@arm.com, yeoreum.yun@arm.com, will@kernel.org, jackmanb@google.com, samuel.holland@sifive.com, glider@google.com, osandov@fb.com, nsc@kernel.org, luto@kernel.org, jpoimboe@kernel.org, Liam.Howlett@oracle.com, kees@kernel.org, jan.kiszka@siemens.com, thomas.lendacky@amd.com, jeremy.linton@arm.com, dvyukov@google.com, axelrasmussen@google.com, leitao@debian.org, ryabinin.a.a@gmail.com, bigeasy@linutronix.de, peterz@infradead.org, mark.rutland@arm.com, urezki@gmail.com, brgerst@gmail.com, hpa@zytor.com, mhocko@suse.com, andreyknvl@gmail.com, weixugc@google.com, kbingham@kernel.org, vbabka@suse.cz, nathan@kernel.org, trintaeoitogc@gmail.com, samitolvanen@google.com, tglx@kernel.org, thuth@redhat.com, surenb@google.com, anshuman.khandual@arm
 .com,
	smostafa@google.com, yuanchu@google.com, ada.coupriediaz@arm.com, dave.hansen@linux.intel.com, kas@kernel.org, nick.desaulniers+lkml@gmail.com, david@kernel.org, ardb@kernel.org, justinstitt@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, kasan-dev@googlegroups.com, llvm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v8 00/14] kasan: x86: arm64: KASAN tag-based mode for x86
Message-ID: <aXJcoHSRLY7tzIpU@wieczorr-mobl1.localdomain>
In-Reply-To: <20260113093400.412cb4c5596ff3336ac803fb@linux-foundation.org>
References: <cover.1768233085.git.m.wieczorretman@pm.me> <20260112102957.359c8de904b11dc23cffd575@linux-foundation.org> <20260113114705.GJaWYwubl3yCqa1POx@fat_crate.local> <20260113093400.412cb4c5596ff3336ac803fb@linux-foundation.org>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 460f3c13defaa3d7589248b966d5fcef4b3ce730
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 87C69C0011
X-Stat-Signature: 7kwrtw16mkdtuxfcany6ib7nmxb1att4
X-HE-Tag: 1769102761-405834
X-HE-Meta: U2FsdGVkX19s9yAc4g6xmvs0/dL7EZMxSBQ+0JRnZkT65pqNS4yOExDhYyLvQ/u8MAWgoa/vAJxkb91CHlNKYjpeZbijh+y/Ib5RXX2vGBA2akaHJNr3af4TfgM/wXkz6M+8Zx1//CwUFzgQFzGg4fAKXmoef4k7f5KOHlXlXevr4E/kn8mr48A25WhQLWBW6lJl+/+v0UDlVH5FLi6A2TF/SyITqsyx3+dLDMSV0Jhx7s2b7NPYTZywa/doflcvyad3M51q6aiurxjsMru6X8eoK7rKQBHSqG4VDlLHjeviwqLORMgFdcOnZL0B4juVRzUAvTEs/It+cWOzwbVgkPQxe3DcXCc/Ivk45gRV4fPp1dZ8/MAw+Wtv5F5WXcaMRL/AnB9RIW7YDStIJWv7tcWZ/20v7X8/wsrpNM8sAHDRsKd36bPRU0teuEZxXTAVMaTG6cZ7wHWlpch00byt43/grBZ8RsbyLAPhxnPo47ZKGwlO9xOcIVtck67ta5IJPBHs+8iM5xJN6KZtr8l3UdYByXkSQYSgvijOMrtxbin5Un9EKGQag5635QzjFAJJ3jfvpyNMjffYaoUF0Zd7VPAXH76phF0naSFbPMQ+kNZ4emnQyS/SCp6Ljs1eLLFQfdSB+pI4tskcGLcOJLlM2H4yAvrpUTrZZz7s+PNYAsqbMdoCiIFTG/82sPeKIClWLQA/i+xzDPa0i3TjVr4hmWiP6csAE8sJ6umA8AcLmW4vT2mI8047T5kbk8PprqS4pOIK84yhiiX2lATQ2xa85ZfttB4HK3QM+Pm6uoZsh21mqd5ZKLQAZ5g3lISxr0epTa1MtNavE6QQjwP6VVZm94JPnKWVHLTH3TUdSA6CbhtJmvxsRM3YqmGfFqXrsbYtK0mNeJ1vCc1gJDRt+GpSWFbiH4ZZJ+Yjqveaatjmef5v0YKB0pPMBc3+Xo2/+g4YAgvumFZTeuBfEEy3uy9
 MRuSl78C
 gEwB1g15kAubKdYIOKHOVM2OlJDkNszHOaZUSKlENrgHwCU8KsLc5NKZyTsvqSt3uqjANsSuJukOr8kP8optZwDZ24OvTWlBwnH1OYOql69f8vTYP6j5FXPBHs3sadYRPFor4Wcf9c+HhKJCumYxYSQBe4+p0I7OMDvA/5EILG2LcJthJgHO/5LcSRMAZT4pWWsP154ZP2jw4ScWWBvR8+D54QMkYC2eY9yyXU5i82K4yvb5RI8nDGLfCJ8Cd7tsX84QFeGXGHzilzgEFbt6mQ9PrkpoZWquS2N/veilqhWKxSHg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-13 at 09:34:00 -0800, Andrew Morton wrote:
>On Tue, 13 Jan 2026 12:47:05 +0100 Borislav Petkov <bp@alien8.de> wrote:
>
>> On Mon, Jan 12, 2026 at 10:29:57AM -0800, Andrew Morton wrote:
>> > The review process seems to be proceeding OK so I'll add this to
>> > mm.git's mm-new branch, which is not included in linux-next.  I'll aim
>> > to hold it there for a week while people check the patches over and
>> > send out their acks (please).  Then I hope I can move it into mm.git's
>> > mm-unstable branch where it will receive linux-next exposure.
>>=20
>> Yah, you can drop this one and take the next revision after all comments=
 have
>> been addressed.
>
>Cool, I removed the series.

I sent v9 with (I hope) all comments addressed:
https://lore.kernel.org/all/cover.1768845098.git.m.wieczorretman@pm.me/

--=20
Kind regards
Maciej Wiecz=C3=B3r-Retman


