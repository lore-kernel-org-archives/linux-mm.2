Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FE52EA812D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 15:11:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CD076B008A; Tue, 10 Feb 2026 10:11:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 797286B0099; Tue, 10 Feb 2026 10:11:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68FC16B009B; Tue, 10 Feb 2026 10:11:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 555EA6B008A
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 10:11:30 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 280A01603CB
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:11:30 +0000 (UTC)
X-FDA: 84428885940.25.DF7E9A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6F485140011
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:11:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=urq6vVA5;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770736288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N50d5yoJEqwbqnZ5LKdQgUqIYICL7m6tk09qrc5ZAc4=;
	b=bEnYmw/OgkdT8HNkLB2Gg4XZDBrzy7Xo+tx9MSdZKSnQ91GUfoRrnfGOS8WfG7aEfRfTmz
	AMbBlh7O4/Qdz7/W5h4ZCWoLv7VEdaYfqv79kluftLgZZlgsUjNa/+wgikNF0zagpHyAG+
	kIOxx6/Ng3KSZbMDh+exFSZyQv2g43M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=urq6vVA5;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770736288; a=rsa-sha256;
	cv=none;
	b=CL1uI7LNO8Q0avMrAZa4EV+jSVrdpr0RxTvV85aB9wDQlFfUpZDsYuRwZnQ8uvUOpD7YMb
	K518UB/5U7OgxsJ4TQK4aUqfM7CvcKJQ+WBonyAOfOYGB/y/b3a7+pL7wZiKVO6Ult8yBt
	MpEZBYZUsMAyrv9lkGaa4phPJ98n3cQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6621B43431;
	Tue, 10 Feb 2026 15:11:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8C5C19421;
	Tue, 10 Feb 2026 15:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770736287;
	bh=DrZA2lEnZtuNLdn/aPtjSDtEw66qk6VI5lqRaUZw6MU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=urq6vVA5/zKz3Gz1KYHkENaWXWCJIrhCTsYUwnayOnesr9oKXBBLBNMjlu+XBMlsX
	 uvq+Efs174+4yyISyJyhtDzzs/cN02rvp2iUIhXHkx/anXX8qt9ZAmETpPgSslZHmi
	 dOfA+PMsiB9phlzplVn1h4BGTREeTKK/mGvc6yXqdxvQxzLhPLxFwqFd5ksvBLgBcA
	 bXe2QTazQVXJjMFOS7sSTsI47jqhux9/INIvbsc/ERm/5Uzn5QYdEvPtT9gAmiWW1c
	 l9kJ02GWTagzlQ4QKwDTfsaZp4dl08KF0CAozjxLRxRQf1YPFG1TFMTQoA3lk8WvtB
	 TCA+9Vof32JbQ==
Date: Tue, 10 Feb 2026 17:11:08 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Borislav Petkov <bp@alien8.de>, Brian Cain <bcain@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guo Ren <guoren@kernel.org>, Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matt Turner <mattst88@gmail.com>, Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	Stafford Horne <shorne@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>, Vineet Gupta <vgupta@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
	linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
	linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, linux-sh@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
	linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH v2 2/4] mm: rename my_zero_pfn() to zero_pfn()
Message-ID: <aYtKjEYYiVDRi7vF@kernel.org>
References: <20260209144058.2092871-1-rppt@kernel.org>
 <20260209144058.2092871-3-rppt@kernel.org>
 <b932ac24-2465-4176-a5fa-d9b904600a15@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b932ac24-2465-4176-a5fa-d9b904600a15@lucifer.local>
X-Stat-Signature: k1asyxasbazm5dwpd6dpqzxuo6o3uxzc
X-Rspamd-Queue-Id: 6F485140011
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770736288-665821
X-HE-Meta: U2FsdGVkX19D4XsJvF9QyIQ8xlzRK1sI3j79L/Pms8luXHrEwrxwrEvpJsRqImO4l2P8ThwyTW/nDR/MpBvGG9oDWA/pC1z6fWerspmCmywGWM5mSoGRWpOes7VxSzKZ59iuKrbo7tnzPYSqMuiypUdfW82stqVTlZUdqZDP24AKv+t/niyoW8DAh5OzK7+jUpp+kudxFlc0Fw5gCTYnMxkGz3+0Twjcd5DTjicbmRos/rJJ3kudXC0IHYjyMdBoI31fHGcDd2riyx3h2zAS6P9xN3hKtrVImBiM2ca9aB3OlDtQLsNsk+KBzYdCQle/lG7P4y71CWF90kMLFMKlgmByjBmUyXPIMCIhRGgnYw0rDDraTE7h2RX3G+GyS/yA6f4bGoLhslNAABbj+f5aUM+kjYdzbciT2rPIK5IsvoHpSBlNJqVcBxAskggYVLfZb0wUwFzpo4/DHnWNkAhFsMZhd3gwYakU8zcSeJO2S09Gg+yKj8v+UuEm2yaOzOtz+U/mpvP3njSZqzdglWAynWOmU+hde3mrr9wa0QzbveYbcXNBuJc0SqXxwa25fW56LM+4WGWPeLTOvBrDcO+ytSsLqulB57sdbOWYTogGlUc5QkpGdEPkXDGnyy26h4lwYVGzkOBwpvI0Rb0i89bEBmfMBHYOzlaiu2YXuMXY6tXDfDGikSyQp2Bec3CEG+7kWP89BMQOXdEvcLkgblZJkt5VvYFn51HFLUHqjQb9Ifwr8A/E4tm+wzVGfsRjMzoCDIkmDlIBZW6JxVj9TioTfcZ8QGNpKPxy2bIBh5sASHoZGVEab96t47zMRGpOoR3FEE4amPymAEcr8bDPjFNDNlgH8x19L0WmK8rFLuuTjPYVl3/pkn8XV3i+9scPUN9JYPVCPgFmEu8fY8FIiXz9zg/L+U40RseWhFh13G9sM5TMwxJNEmuTlx5HF/gwRsgPZhS9vzYwmOcbrbvXoxj
 kB/ATGjr
 m+0+hCtcjFwQjlosA2piAwES8N7xJ5irqBSorYGZ+YIqfWK0AKD6q9UEfFgjdTHNS24dmUwo/YLTarr/birZPTnvencz0d1ffhjxA40I+aEdO+9okVJ6L+MoPDuTFRKixpT+Cy2KzC+NplkF6gftj0LkHq+Kxh6Edi1jE2esnAmFjH8H7e+QtqNDuCq0/39ppg3LW2AXKdOOtwFF2SQKfy2PG1bb1s3NRMGMbg+EkHk8kY2K2kolubzfwuPvZYVmw47aYSX1YOAZ8izgzrX0iYmXX69J+4xCm2xq3m8WPq/lc/S9uH8TxHmF/OLqBzFz2jnznhJexQfk3Fjc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 02:52:56PM +0000, Lorenzo Stoakes wrote:
> On Mon, Feb 09, 2026 at 04:40:55PM +0200, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> >
> > my_zero_pfn() is a silly name.
> 
> Is it too late to ask for it to be renamed to lorenzos_zero_pfn()? I've long
> felt it was mine, due to the previous naming, and I feel like maybe it's time to
> make it official... ;)

It's not too late, but the pfn will go to the highest bidder ;-P

-- 
Sincerely yours,
Mike.

