Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1214C5DF7D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 02:49:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D88F6B008A; Tue, 18 Aug 2026 22:49:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 989C16B008C; Tue, 18 Aug 2026 22:49:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 878E66B0092; Tue, 18 Aug 2026 22:49:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 622766B008A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 22:49:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF24C1C0F63
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:49:25 +0000 (UTC)
X-FDA: 85116487890.11.D4EAD47
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id CF6D8A0008
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:49:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vJl0n3O7;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787107764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5mBZvCeN2//ZyvUUsC1lfsgAjSbsE53j1pTePzGlSm0=;
	b=T8EQgIgzli1Mb8D59tfeoNIQOPpFfaJ8VS6+FC+eXoxMOyBDvDdKzrVfmg5NnG1862cAz4
	mU39ri7XHLlUtzwrVkgdRWMKgOb5DGppp6gw3H0HYden4Qqbx4YExpnpNHMPaFZZDWPOyP
	RTach1jlBBXOOcladwUjiBFNgAktdvA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vJl0n3O7;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787107764;
	b=qDMQHolHKyTmNue4vGq4o/m+vUb1fDzZhyUCAW2Y39kAP8Anl1Z4faqsWMYz2M6n5JP2wL
	F5Z0ASTwSU5o3GqVy/pvg2RgLT1YjYzQNVlQOYr66vgrR8H7YTV6IvbYqYcdmFNx98EL/Z
	MYBpO57AxhiARtLxg0g3qX+WoCTCxSk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B7DA416A3;
	Tue, 18 Aug 2026 19:49:18 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E01DD3F66F;
	Tue, 18 Aug 2026 19:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787107762; bh=oAq7LZNVfuWLyY8F6bgNDhoqq4F1x7DlAd3a+zTStqs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vJl0n3O768ihB63yzY/C3psnBKMwgj31m+kzmZIZlkySfUrUB1m+qr/j5JU5c9Afe
	 eXlqYLfwodRGlGGDBoPRCFbNWaxAndC9cqljsF8lDwcjTwNIut2KUoxp62ngsl8nn1
	 zy9caih5g0LTIVBgKUQNdkShhYRX1qD1/PYrFpfg=
Date: Wed, 19 Aug 2026 08:19:19 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, linux-alpha@vger.kernel.org, linux-snps-arc@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
	linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-um@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>
Subject: Re: [RFC V3 1/8] mm: Make ptrval_to_str() generally available
Message-ID: <mc5cbirsrv24mwu4bg35ksxjyzfoydlgewq4tt7uu3ij7f642o@m4w7dm37nmdh>
References: <20260818040041.1891769-1-anshuman.khandual@arm.com>
 <20260818040041.1891769-2-anshuman.khandual@arm.com>
 <55d92b3e-ad3f-464f-b2db-a2552353223e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55d92b3e-ad3f-464f-b2db-a2552353223e@kernel.org>
X-Stat-Signature: 6gyeowsxch9jp88biysyti1hrazcgnui
X-Rspamd-Queue-Id: CF6D8A0008
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787107763-98865
X-HE-Meta: U2FsdGVkX19jerHo5NgudRXdojd3LmKqF6UtbNPc6RV1PmzSTbviV8AL72xCAo29xuJw/QL9AMBcexfj5WhKakOzZ6NrLf9WzENszLX82UvGa++XpQ3UK0d9zuTgR+gMx6GFuXpWU+D8aTDM1axijeCK/6kNmYQ5GAIYyVT8Iv5LKJrLGx8FeaKys90zAstc98QlBOVlVoj8j/lt4awMhULEhr3Nxevm/PraWG/uTEXTp2dIxX6GHN/VH3YeefnxXIVTpl0LXlCqpD4VMJ5SNg9WBtUnAgSyk52iQV3fsxz+p0Zjjxn6nzB7duUp1YBfDWBBOn8mDIsaQ9+EHao7wq8G/htTgZPZLW1O4CQ+y2/69fiHuQHoQQvDYem+yMKfI1XV5p1uyHz7TA1TnBJffAr8/hXy5IDGvdd0+fsqeibh6nbDTSeGyrhdJkUOYJuZ9w14cbakZv4Ab0NYanU3/CMjdp7ldCVjDwmuQHdbec5YkybCeOuCJIvThcJX4ebG5UU9qfSOmzaLIMijkVETvCLt/yfRhphTic2omVbP6Eq65GbDJzeOYCidjUHfOgpucbqWGhN3FvAOqqcOWH9dZdbpGtQLtvIlGIzpWfCUFEv4CURKh58oBa/RCPi+zykXrdK3M0JQr2ESjsu/8zXaDbfG0FFhKUfejitd4aTsV8CS0M3nDdnxKJPfcPk4Zpkt+xypNbJtBO+PKDghlb/XZkSnl/IQzJIp8TqNqDhD9IRrYMZnNAxfue78fQSnUK+3WDbjY2VouNY8coO0c8N3xm/TtXyDvU8CmUfYTA3Mmy3pzDqx8Pi91Qt6qpTXO/e+TOIXAslhNoO73h6WNbkENIiWepeFr3RHtK3hHpV6wl1acOo+/WkvzdP9OFT3kshbmkXxbfiF5E+/eVLTmtmkcBPq3E5HsoKzR6iJPX2F8Lc2HlW54pXB21u55n+BhTSd/rFbvyRxq6GsMeyijjG
 gv2BceRN
 1k2ajp60DMTCS9v404sB9Kx7RNDMm5tkZdN7XVgqHnA0s5X2KjDILrpeZAVzvJUuY9VnX2UcX99SOHooplideBeZzaZj7Qw4mYzQjXHynEjAlvpJmvr0Cb+q+Nzztfl6PSJ+CuBEHiysC+vNgaUSSusQa5N47gvrgjrgqItOV12RTGIWl+r5s9sJZebIM9JhHExNQty5g2h5XtDjq/YyACsrlcJIJDCPU3XDvAZ105+b8U3QKeZVwTsJcOTPnH6XZ4ZawZo5F3IghLWQMrcool7YyWe+uxD0UYPOCLuZKSm55hGf5oXsk/tgwnb/4RW9UidV8pgqnQrVfXmqriis+bTjyl7wHxfhvZ58nWK42f8wJBOEg6Iwiv5kfw7vzENy3vGrxGq/ppk68vBPwA3sBljxsYHriJtzhdXQe7FUwnO8JmvzzSnSWC4iSWh0BWWd/x3MPyRwn873jSOxO5LSkS0wFB8isHCrc30xNzAwkx91mE65l+nzxvggJZ7frb1cNdsvRlKp1nDwMn1ynRwXje8saQhz4GaJA+B2K1Vl0k/TupVost5Uwg727Mkgo9eiPjYIrboOl/860FHoJXti8Pw0Ti25PB1RFi9xT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 07:25:07PM +0200, David Hildenbrand (Arm) wrote:
> On 8/18/26 06:00, Anshuman Khandual wrote:
> > Move ptrval_to_str() inside a header thus making the helper more generally
> > available for new users which are being added later. While here, also move
> > another related string size macro PTVAL_STR_MAX inside the header as well.
> > 
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: David Hildenbrand <david@kernel.org>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: linux-mm@kvack.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > ---
> 
> I would have placed that into include/linux/pgtable.h. Any particular reason for
> mm_types?

Yes - that works as well. These declaration and macros need to be moved inside
#ifndef __ASSEMBLY__ block in include/linux/pgtable.h file. Will do the change
as suggested while dropping the RFC tag once v7.3-rc1 is released.

> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> -- 
> Cheers,
> 
> David

