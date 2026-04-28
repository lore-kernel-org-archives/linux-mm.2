Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E92C5FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 11:34:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46A5D6B0088; Tue, 28 Apr 2026 07:34:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F3726B008C; Tue, 28 Apr 2026 07:34:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E24E6B0092; Tue, 28 Apr 2026 07:34:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1BDE26B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:34:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B415AA05C4
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:34:15 +0000 (UTC)
X-FDA: 84707756070.06.0136011
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by imf03.hostedemail.com (Postfix) with ESMTP id F40FC2000D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:34:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of segher@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=segher@kernel.crashing.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777376054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r2VT2v38m41OJS5IqZzssjeRJKc2hKIY8tTqzqnq+aM=;
	b=CypEJzJzwGiHiW4WyXA1zZYeLBLF5noGpq213JBkAkWkihW7qTCL4lbH/RWBemyrxNCZHv
	fpy/Tq/NBSVl66coGJaKjZxBccMmDGGEwJAkz+Dcn088oGr465UzYXqOsLEWsZZbmydHoi
	AtA9MGcHk7ECrBHovDfd2iJByvwtBpg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777376054; a=rsa-sha256;
	cv=none;
	b=tix0D3JftucRsEOKx7D7krjc8NLBPhrIfJ3rJ1GFbz89DNzQRLjGnKBtmqiPXuyjq/wl9U
	bek9ewb1erhjBa8+Tx13MD7UcfGpTJR+0otOKTnD1y1nqaoxja6eO5rsucAkm9Vk7zCRrF
	HKZ4RXBq+xr3lfSWBvwFe1kWKrdQUrE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of segher@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=segher@kernel.crashing.org
Received: from gate.crashing.org (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 63SBY0U31059939;
	Tue, 28 Apr 2026 06:34:00 -0500
Received: (from segher@localhost)
	by gate.crashing.org (8.18.1/8.18.1/Submit) id 63SBY0B51059937;
	Tue, 28 Apr 2026 06:34:00 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date: Tue, 28 Apr 2026 06:34:00 -0500
From: Segher Boessenkool <segher@kernel.crashing.org>
To: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: Yury Norov <ynorov@nvidia.com>,
        "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Laight <david.laight.linux@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-alpha@vger.kernel.org,
        Yury Norov <yury.norov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-snps-arc@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
        dmaengine@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-fsi@lists.ozlabs.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-media@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@lists.linux.dev, bpf@vger.kernel.org,
        kasan-dev@googlegroups.com, linux-mm@kvack.org,
        linux-x25@vger.kernel.org, rust-for-linux@vger.kernel.org,
        linux-sound@vger.kernel.org, sound-open-firmware@alsa-project.org,
        linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org,
        loongarch@lists.linux.dev, linux-m68k@vger.kernel.org,
        linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH v1 2/9] uaccess: Convert INLINE_COPY_{TO/FROM}_USER
 to kconfig and reduce ifdefery
Message-ID: <afCbKJg_Cq7yNO9j@gate>
References: <cover.1777306795.git.chleroy@kernel.org>
 <9fe875d2f55af59c12708336c571a46038528678.1777306795.git.chleroy@kernel.org>
 <ae-tVFVfx72oCC_i@yury>
 <f54c3c2b-33da-42a0-80b7-0f6615d930ce@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f54c3c2b-33da-42a0-80b7-0f6615d930ce@citrix.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: F40FC2000D
X-Rspamd-Server: rspam04
X-Stat-Signature: 5wjs6wrwgmbe4z88z37fqworatni4mcu
X-HE-Tag: 1777376053-851400
X-HE-Meta: U2FsdGVkX1+lpWmvZjE3qV3byyWhMPUbTrViGx8pt7Sx30jICV6x7a5vulwJxCZoma13NG8k7h0f/QITbdk3HM3SwbtYAfVunFzkDMJ9sER+xxdSInexlU4A9Mi/x3i6UKP+tMFuiGGtE0j3d9adwBlhgMfbGcvjl56PHD03vFfaFRMnIvX0fKieWrW35Mw4MkFoQeqJgF5vp5z8GZE8tJ70JURpOQpIgZ34wvmFq5HGQ4Cl043PWx/WqPryc7P6pb+OCh7HlADYNR6KQN/VvJQJNL72Jki2tCBp66ZgwZp+ymA9s8EtCF1fUaMQcIFrpp2+oWqe7l2ke4Sq/3s0PYouItrZRYTAthAVsXOlxGbEiyZKZtXgztoUGIjLIVw6Iz4YlgSKf4Jw5UocozFwqxBpjw3Yj6bTeaXIR6ncNkt9DSoqUyqPs//KrsRQh1N5+qFOe7dvzXR8wBM2pGxRujzG+ZPIuZrcDvbxcuAIZW2ZGbSMqLi8DxI/R5U9JriwLrnFUgeGLigw7C80pd4TVOs3RrewU3QFjw5S5XSsyGyrzMW3kmXJajiPX6ueeE8XfLMe65VW8BLD7NP0Db/7WOlXNBXcQft3hQmPagHTq135PC5oZz/3Sd69+U3nI0JLpdphTKh7HCN01GCUIT/MNv8s1GQCTJUSeA/UQ2nHXbWWaTm8RSeGm4/lphDp+5MytXu2z0AipHwUllqSrv3hQg/qgkkG/sWEFVXVmChovGq1gZAknM8cYI9Ri3443LFdjO2lXpYhSiaUwJTsc/fIOF2PEjbvd7XfC4x4GX2eW/uRShJLwhGSVyt+yt+uAlJuu8VQF9RTOmU1W/j3pYKwvRZ8GHcOFD/fbE0dXu3dYIPR5lSWgARs4Wqwu0Gf4yHzkiXd17k1AEWhAbHT0lPz0sRiVwI+EW84t8lSVZYYwJYGDi3d2DoXwvlKONwF6gjhKLmcDQH9EvFswe85sxJ
 dHMqT0BH
 Hr3NAhotltssNCnjSW9VHkqKN+z+3uV7Mwf4Dr/wtvsKPLPwO5DeK6uw3Z8bOGSfJAZXQ4sqmdpjSW50rIzb8tNOyM7FG3B47+AwyWDpwe3YDiDEShiq06HIW4Pajn4Wu/GMbXgNlk1lCm1lZesb6kkzLq4JaOa+HF5RvNENUrAySKpjlwbYfNageM285SjLHkAT+TIqGMGD9g65yW2XSdqBKyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 09:39:33PM +0100, Andrew Cooper wrote:
> On 27/04/2026 7:39 pm, Yury Norov wrote:
> > On Mon, Apr 27, 2026 at 07:13:43PM +0200, Christophe Leroy (CS GROUP) wrote:
> >> Among the 21 architectures supported by the kernel, 16 define both
> >> INLINE_COPY_TO_USER and INLINE_COPY_FROM_USER while the 5 other ones
> >> don't define any of the two.
> >>
> >> To simplify and reduce risk of mistakes, convert them to a single
> >> kconfig item named CONFIG_ARCH_WANTS_NOINLINE_COPY which will be
> > We've got a special word for it: outline. Can you name it
> > CONFIG_OUTLINE_USERCOPY, or similar?
> 
> You can't swap the "in" for "out" like this.  "out of line" is the
> opposite of "inline" in this context, while "outline" means something
> different and unrelated.

Yeah.  Technically much more correct for it is inline vs. functional.
Not that that term won't be misunderstood as well :-)


Segher

