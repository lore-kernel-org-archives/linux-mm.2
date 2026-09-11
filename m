Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BA5BC88E41
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 00:17:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 159DF6B008A; Thu, 10 Sep 2026 20:17:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10BC86B008C; Thu, 10 Sep 2026 20:17:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 023086B0092; Thu, 10 Sep 2026 20:17:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE9DF6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 20:17:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C7D414063E
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 00:17:40 +0000 (UTC)
X-FDA: 85199567880.16.1241E05
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id EF96BA0007
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 00:17:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=X22wITFU;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789085859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qGubHrOUaqKed99hLIWnPWqg+R/An1NQxE3VePdAsS8=;
	b=B4gOBQUYXBYlBb1be2rVjbw6SPY21kHq8dMqCj9IOFdPW7Q+/5j4FcPOkbP6j7ohEAMGes
	0OiAddtQZRxgWdgCcx41WjKkJ18Wl9Cgd2Uezqy+TeYx7Yk+RiJF5WLhTpCyDyKqTeggCt
	R6jhjjpbr1NWrfBcTpwQWTqqP8i7pwQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=X22wITFU;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789085859;
	b=Vi9SpqpR/6fVFI/h8nhlBitL9ICfdLZFBFUpOoYe835LU5b4+Tez/AQHzkR/Zf2ImjfHuI
	MZWbdoEdS4XazHpNEce31imkipz+lMtQ+/uykBKDatfK74IwYtd9ICQGR1DxIK4vDykbwK
	DI29DP4XqcdNm2j/1czm0vIGSmpB9lc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A54142AE3;
	Fri, 11 Sep 2026 00:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2563A1F0089A;
	Fri, 11 Sep 2026 00:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789085857;
	bh=qGubHrOUaqKed99hLIWnPWqg+R/An1NQxE3VePdAsS8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=X22wITFUBnw2s1G3bTYYh6PPwLO2OObQAmukcHTIsN8nXzwTrmBf6GCes+Up9hgO5
	 gxB4OE/GB4hsLxPnHsmV5zK4McPstEAzFnGeyaFYN8Ao9sTBsze/3F98e1gx8Co96k
	 5H1YNkWaLQ8J5XSbEhmQWinEWSQO80KjGmCB/2P0=
Date: Thu, 10 Sep 2026 17:17:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: chrisl@kernel.org, nphamcs@gmail.com, baoquan.he@linux.dev,
 baohua@kernel.org, youngjun.park@lge.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] mm, swap: Fix potential NULL dereference when
 trying a sleep table allocation
Message-Id: <20260910171736.02208c335ee41edd89a23809@linux-foundation.org>
In-Reply-To: <20260907091356.53026-2-shikemeng@huaweicloud.com>
References: <20260907091356.53026-1-shikemeng@huaweicloud.com>
	<20260907091356.53026-2-shikemeng@huaweicloud.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ip4pgtjbtmp4b6ywy8ppn8jscb7fi6ep
X-Rspamd-Queue-Id: EF96BA0007
X-Rspamd-Server: rspam07
X-HE-Tag: 1789085858-183633
X-HE-Meta: U2FsdGVkX19mshmlhESzwqVB8nBo4y6P5PKUsuDajxc1Z/Ofb0FXfqfUnBq1TdlDCpjtp68xg7hH+QUIoynMtKX2fWPyiAs+5X6q0qSwMPOojxmchGwuecuqRIIjAFVfYMGuLQDvtkc5LLugEzSkHpaXm+E6kmGnHacN2JZP3nLIoA5jAXGdQnUSTzS/4K0JGORBsWs4m5Md8Sn2a1RNrcon2lFA+Gqv//zmwY2+vaymv/t1b8A65CJS3Xteu4mbFmRoUxhs9veA6EpVzggLEiAPXXfIrYsAp/jlgnCFTNrbQSwaifSjT9AP+CRta/Ndj7TCR79M5UuN7Rb3exwWmo2hrioJEoTc2uFEvWp8QZx+y6BxkOkZwWb97HbPsN47TETq9mh1jDMnngyeRBl5C00LZUZAPbhQlikvTO7lD9n/0Kdiib/PediJ0ketswfPRDEwN1Fw7N1bzpnIBTxMBMI2CY0IIqbs6+d9aFtPOvJ3ZN8jz8RENQhBXiqDoZ/hq4MaRvxd4jb/gw+Bp7g/kCoRoJVxbtWIHLUG1m/I3Xc1g5zQWPeKhsNyPZiWaxXo4NbNjI1IFIG9gitX7A+2+attIpQR23rrXSnKiDYU2edPsZniWDQy3WzTXYnqczxiaa/bhc4nEOVEhahTtXthNe/JlPF8yeaiKOLkdfwi8o0UTNGqiAcQvaLsqSWvAB4XLD8B471ZbDBWcbSaUlFUuKJD8NxHCLV19oOjVSpgwKfFORKlXnuoV800IcN7Et2B1BMY4TupRVd5R/5Ou17T/ipLKSFPNi0/Vd6ynhAOWNMR9un/UYqh9FXXgAgZ/MUJ1kgYSfVMV+Qp8ccpadGPnN5Qi0ke+IdLFgQ5XZ4LtW7z68yFWIMXSAKyT30jjg6uL9XRqcnARXA4sckw6LfRcyaWffiaKNgySYsQowI7qZ/KbLS3n2ghAGLs7C4otFi3AwzGI613cOSN8BmkmAf
 B1jfUdoG
 /Mi9zEuxLby6VDWHyVsvqJMLDvLFvWD2MIPhW/FuNk+OWzqT/3oDp/3NKNGn0zyyN7pBulU+cb431TPwWipj/8V9MvaEgB2ypGQ6WHL1lYNhta42W/DD9iBvU4pJMZIPbPRswy0Lw6U2GTAmIRceWKUur/GXQcFeZNL6vh6yOJQD+Ten4SXJVA7um95d3DcRuSEVvBXdEg3hDOSvm/YfAwUczlBZkL4IbDHPD9dhIkpQX3SQzWdNmbuKVxGH619jd2CC50CHrehugZH15BybA7CcvKBjE5wu1tVBoKxKrsAZTGDIIPO+DGzy8pkwKn1X6bvmGUODtAuPWd04=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  7 Sep 2026 17:13:53 +0800 Kemeng Shi <shikemeng@huaweicloud.com> wrote:

> The root cause of this issue is because multi-tables are updated in non
> atomic context. To be more specific, the issue could be triggerred as
> following:
> 
> ...
> 
> Since memory order guarantee between ci->table, as well as between
> ci->table and ci->zero_bitmap, fix the issue by making tables
> visible at the end of swap_cluster_populate().
> 

Sashiko suggests this might be incomplete:
	https://sashiko.dev/#/patchset/20260907091356.53026-1-shikemeng@huaweicloud.com

