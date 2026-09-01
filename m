Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B4F0C624D7
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:57:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 819EE6B01F8; Tue,  1 Sep 2026 09:57:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CACE6B01F9; Tue,  1 Sep 2026 09:57:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B9D16B01FA; Tue,  1 Sep 2026 09:57:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF5B76B01F8
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:57:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5808680444
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:57:41 +0000 (UTC)
X-FDA: 85165346322.04.2C5FF2E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 508541A0008
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:57:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="MtJhN/fn";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788271059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=agwo4ogI1pqxdy5iNzHZWMq9fgC/4O+9PRQpyNWft68=;
	b=GdRERrNANizs71hXifIUokM745A8wVfI8/XGwRvq4lQUzhOjebYLxyqbKSldzQ/00C2Jzz
	QCeCEFYBU8Js/FKR9szr15Cl5mVZ4eB26mSrnndhPo2T/Xwmhh46iEMeqJQCYXuzQXHJBf
	ZzV2sq7MrQF3Qty0TchjLHyU+jrtC8I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="MtJhN/fn";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788271059;
	b=3cgWAQeqQPpraS2oPwGkRDqoG3hzIzmaMz5zvx7RG8TXOiItvqpYn22xKe32xoH9MfTj1u
	5kwXi1H15o9PiiHHPNphorMGBlrUoN3PSnKIvmyejPPaMSVV862jPJ1QG56f8T0JiQyyI2
	RS67r88Et9wT5Xy4zOIK1wzFKn3oKz4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3BF6343200;
	Tue,  1 Sep 2026 13:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA531F00A3E;
	Tue,  1 Sep 2026 13:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788271058;
	bh=agwo4ogI1pqxdy5iNzHZWMq9fgC/4O+9PRQpyNWft68=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MtJhN/fnwJpQ0jDMdX9aHpHd1KWLdoQ8RNyZmmbTur0MWWXkmPyj3DHXvlsvmWwoM
	 iSU3lqn5xllXqxFm2mSgQzIn8ghlKSIaO0g5Rmtqs9Znc70lZf3Af0QFtWE66UeMmD
	 hqK7yAgo/u0x5eWbnXk7HhHlszEZwZ6B3Xb9J9B/Y3l/S+1652MVDWGO7/3KgSHbSA
	 t7TKwr333d6Pek6ziq9tPkoZLuqMJqbrsiIWEM5cbbXgrruzzallxiqLoLW6sxnjAx
	 oNcctNxr/JWwdomR51woir0FpdUhsXHafeDZzCiqTZzSoXNrhOjyF05PMcuMDQvUYs
	 x8tUh8Jwj5I+g==
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfauth.ams.internal (Postfix) with ESMTP id 177151980075;
	Tue,  1 Sep 2026 09:57:17 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Tue, 01 Sep 2026 09:57:31 -0400
X-ME-Sender: <xms:vNmWahMoRfGHJylVp69tkl0ZxHuyu14twTOMSzDVmUdqODOOFCaOUA>
    <xme:vNmWamC04sA7HLbhLFXFetRTQirQ4BCq3h9mf_X9eZoWhHHweJXfeNQnDFEkN-eZU
    TNHprwg5j4bwG2-RtgLS24xR65NPMHQ58PhK4w0lkjNf7M__AtigCJf>
X-ME-Received: <xmr:vNmWaq3HcGhSb341ukDeOtyXnIIR93_LM4ZWQrR0RvGyHQIkedHYy9DG-ho>
X-ME-Proxy-Cause: dmFkZTGhE4xc2F35+/cH9QWJSP+T2sSz31kKWkLnMEla92oo5cnqKuXMLiYgktGt0fz0/P
    1nAHqKz2XC4RLt0sZBuXgNoB+I3Lv5/lZeidGsyd69PUr2tNaXTbLl4Hq1jVnQD2pxKsB5
    RUmimEN9ymjBpSBDK05+FgJk8e63uei569IciHBQw1D9FCH5SBdcJBtIvv01IcUYKhgTIS
    f90WviMk+GkUmSBdkywQGyAi+Kb+Qs4cZvbCzXW86phJx62/9vfGS9f/B1vGm3MjEXgufi
    xD125CxPznssp42WHeX1rGj2+Px0NTxJU25KbS651lVg+nwXVCAiD9QMRn4oxFx34KkMYx
    /ylDM1rHu63l41H8z2zMGbuFg+bbu5OoPfGY964XH8pFkw0h2B5akZ5tb7ZRd15sBoxvJ5
    9ZPlIQHmBss5JGvVitt5oDAdab0/sDuOhYj6IGcWNKZc4l5IguhFNv0eBdiZ2XkP48/xyz
    q6bQQrm1dnGYKm/bGEuYX/jvKq3w6ZA5D0pVnRf58fwOUna5/8IR1fgu8jrX3MTvyrkxwQ
    2WRtxks1DmwJsWM60SDXg8t4yPY+L4AyFb79enpcuanRGGerAd74MDz5L2Upjp9/rU+vza
    OvhtVRTr2CvEdlW0VE/ceLVnrcS0aqrnoB++f7ZsN6y8Joe2E6rYjhbsCAXw
X-ME-Proxy: <xmx:vNmWalhfMApERZzjpc7TJG7GtCgdX_4w67qtsX1G62pSARN2GZWDIw>
    <xmx:vNmWaiXm6FAPUBkUzXVBQI0eO7tHb2vPP-rixD6Ad7WIkQTws5E-Kg>
    <xmx:vNmWagSsKBNh9mcPCUFna8QpbE6wA1vVhKB8VhCwB5se-N496qRphw>
    <xmx:vNmWahXZHR9XIJgivKj91oeRT0NDLSv9qe3xafv6It9647nhJIe3lw>
    <xmx:vNmWajSxgwuhyjaLfEEt6Ejf2oTMeCpXSZHSN-d4vScBLmiRwr-9557Q>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 1 Sep 2026 09:57:14 -0400 (EDT)
Date: Tue, 1 Sep 2026 14:57:13 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 	Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>,
 	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, 	Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, 	Usama Arif <usama.arif@linux.dev>,
 Guo Ren <guoren@kernel.org>, Brian Cain <bcain@kernel.org>,
 	Geert Uytterhoeven <geert@linux-m68k.org>,
 Dinh Nguyen <dinguyen@kernel.org>,
 	Simon Schuster <schuster.simon@siemens-energy.com>,
 Jonas Bonn <jonas@southpole.se>,
 	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 Stafford Horne <shorne@gmail.com>,
 	Yoshinori Sato <ysato@users.sourceforge.jp>,
 Rich Felker <dalias@libc.org>,
 	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Paul Walmsley <pjw@kernel.org>, 	Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, 	Alexandre Ghiti <alex@ghiti.fr>,
 Russell King <linux@armlinux.org.uk>, 	Vineet Gupta <vgupta@kernel.org>,
 Michal Simek <monstr@monstr.eu>, Chris Zankel <chris@zankel.net>,
 	Max Filippov <jcmvbkbc@gmail.com>, Will Deacon <will@kernel.org>,
 	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, 	Peter Zijlstra <peterz@infradead.org>,
 "David S. Miller" <davem@davemloft.net>,
 	Andreas Larsson <andreas@gaisler.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 	Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>,
 	Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>,
 	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 	Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 	Michael Ellerman <mpe@ellerman.id.au>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 	Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 	Sven Schnelle <svens@linux.ibm.com>,
 Richard Weinberger <richard@nod.at>,
 	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>,
 	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, 	Arnd Bergmann <arnd@arndb.de>,
 Vlastimil Babka <vbabka@kernel.org>, 	Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, 	Michal Hocko <mhocko@suse.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, 	John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
 	linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org,
 linux-hexagon@vger.kernel.org, 	linux-m68k@lists.linux-m68k.org,
 linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org,
 	linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 	linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org,
 sparclinux@vger.kernel.org, 	linux-alpha@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, 	linux-um@lists.infradead.org,
 Hugh Dickins <hughd@google.com>, Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH 12/12] mm: change the contract for free_pgtables(),
 update docs
Message-ID: <apbUpMDJglS99_yK@thinkstation>
References: <20260901-rcu-pagetable-freeing-v1-0-5456a81c8212@kernel.org>
 <20260901-rcu-pagetable-freeing-v1-12-5456a81c8212@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-rcu-pagetable-freeing-v1-12-5456a81c8212@kernel.org>
X-Stat-Signature: k35np49n1yro4q7yogq19js9aknu6gur
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 508541A0008
X-Rspam-User: 
X-HE-Tag: 1788271059-592185
X-HE-Meta: U2FsdGVkX18cwEkLzapC+RCW5DltnCekIBWDJcttcXFWYE93lsSsWpyz19WDUzUh65IHNeVti6ykKlqCww9q9W45Kg+TRUo+m1mMRK9ZMg0NIKFB7G5SeeYlGq9Kk6cQFNaIXpNJebRRQ889dkYu/tgzs9SPZu7gif4M0aD4quamJklOQ9MZPFUMWKt3u/XkiA3Ek7U/qisQRtVVYKgJApYcsq/4PV7fBrGOGoTAfb1dSPoznQBHcrpnWH0C3lz8psud9l2TuBHi0unskqjeutX1DKAvXCHf9cJHChyiRfWq2VuUvSfupnDAHghD+fzh0t56VY+IKjylQnwuQJ0diV4NWF3I99DOmFMF7UIxFrSVlizNj2WPDb4sSGxlHgReqxMBKgEo+WgofrVPawMniKGkYmRRAnphQ2bMA+x/uHcViDt9SYk9fjV6IpMJYi030BNhSkpaf4KyeqS1TuaSANXjqdUH9uXxPhoRYNXbMapC+R6p0GquS21k8mhAXayv4sK6o+/kZKwExmfmGbVn1Yp5tj3PG/xiMAjYPfpTFT5nU486hw7DDqLTD5lNXvX1Qn1IWE/NtrKS4ey0OjZWoHlwgSVSZ7a42k+4aC/sAlRrFcwbMDngUV/FsxpFr99h3w9udne6BimSNrL3pc7pk2JikVlmqk2sP/OhLG5Vkgo7wv2fTzxqwQkohHRIaBpApINUkk6dEGz9f1eSqX1jEfN6snBsXcRYbmOm2eAxYuqFmagE9ZtStE2amidjOoboqCkkLfI4TDz0/o4JzPLtJgYsOMbAFKDy94tVlUfwfQnIeDNYHSUMv+Gc76Ioy4ZTPdZZqi4lfskPEDfGaonqX1Fr0d36O86I8OsIPHq7Fv/SY26Df5uyiSjgzhfYoTkTDyCdlh/wOuGRG4p4zjJjOVxQ0MxCci4wEEXrPBgbnBB16+O6nuOM1YoesveVvLH+ewBTsGpEhjMiN/JKW+s
 p4QEfhIv
 BP/CDa5YyhYxEwzgsq2B6oKI22XSYenqpvKTx7VlG4/rSBP6N6RrEe1zo4ythgmHlLn8A2WS9LjBFutRa3WKUMtLkKTZA9qlu88mJ36RBuiy2Az3SMlsLUm3Ft713ifT7HPlauK6M8m3x9XVjVe94gjctkCpllqX92gWgpniJW8WE2pwZrdAxRkXosm1u31Xsl4i2Wg4ZrBNgKcVJX3M8x3G2BTzFQTM3zq6NWjj6itvtvdFkXNv0vwW51xdZZlLUV+aGC1n6gCuVnDt5eOvI/Qh8DUh1owjIED1Oty8w/dd3mf6XCx0cQw6MandHcOoYg0aXwmWCFCdRjR7usGe2IRXkG/Bwp3XafUYODfEzPLkUXUKXZOQEAmwqgI8oH4wUdxT1NXz8eX8SjgX5pfj2zQuOYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 12:01:32PM +0100, Lorenzo Stoakes (ARM) wrote:
> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> index b91b1a98029c..ff8ff3706485 100644
> --- a/mm/pgtable-generic.c
> +++ b/mm/pgtable-generic.c
> @@ -386,9 +386,21 @@ pte_t *pte_offset_map_rw_nolock(struct mm_struct *mm, pmd_t *pmd,
>   * be read-only/read-write protected.
>   *
>   * Note that free_pgtables(), used after unmapping detached vmas, or when
> - * exiting the whole mm, does not take page table lock before freeing a page
> - * table, and may not use RCU at all: "outsiders" like khugepaged should avoid
> - * pte_offset_map() and co once the vma is detached from mm or mm_users is zero.
> + * exiting the whole mm, does not take the page table lock before freeing a
> + * table.
> + *
> + * However, the PMD entry is cleared first, and the table freed only after
> + * an RCU grace period, so a walker that mapped the table under
> + * rcu_read_lock() stays safe, and the pmd_same() recheck in
> + * pte_offset_map_lock() detects the teardown.
> + *
> + * Therefore it is safe for "outsiders" like khugepaged to use
> + * pte_offset_map() and co. for VMAs that might be undergoing page table
> + * teardown.

Is it strictly true?

free_pte_range() clears the pmd without taking the PTL, so the
pmd_same() recheck in pte_offset_map_lock() can pass and the pmd gets
cleared right after.

Readers are fine -- __pte_offset_map() holds rcu_read_lock() until
pte_unmap(), so the table cannot go away.

khugepaged is an odd example here. collapse_pte_mapped_thp() and
retract_page_tables() don't rely on this recheck -- they take pmd_lock()
plus the ptl and do their own pmd_same() under both.

Can we say walks are safe and leave the write rule where it is?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

