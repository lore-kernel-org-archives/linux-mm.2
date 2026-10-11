Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BC72CA9EC5
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 01:10:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 002A96B0088; Sat, 10 Oct 2026 21:10:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF4896B008A; Sat, 10 Oct 2026 21:10:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0AE46B008C; Sat, 10 Oct 2026 21:10:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C0E6C6B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 21:10:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 192BC40544
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 01:10:20 +0000 (UTC)
X-FDA: 85308564600.29.A432A78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 56B2F20002
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 01:10:18 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PK9+v9li;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791681018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xltzwB3NQYDsmBs7/fawoEbWxdY8ZqumAutpEK8h9+Y=;
	b=37bdH+kZ2fdkuO80wlC2cJFpV9I2MEB946XuYRTsyzM6nSM2Xl+j1ikwmpcMkuhE5QCFEz
	D6h6R4hb8iCGvYbyEZJ+iSYCE88GsJk9BdwqjU5dfzKTi4yp9zXdzmuq8i/f7a75J1QIe9
	us+WS/5t8UJ7CenilAL1NIdKx6115Bg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PK9+v9li;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791681018;
	b=nTBuKxiqRJHTXm09Ijttb6BpNcx73EWq5pIRCoVYKn+gFeqQA0QpGiMTDnVvha70VzdyQ1
	m36YST98htM54kzC53/ivs3pBL//qPRvspxMBmoe3Iq0AaWYNEkMCMOMrPzwmS4sFYUE4b
	rIkXpFgFM2Tg8BcG3Zi/sasSakZAytA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 220E2419FA;
	Sun, 11 Oct 2026 01:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5241F000FF;
	Sun, 11 Oct 2026 01:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791681017;
	bh=xltzwB3NQYDsmBs7/fawoEbWxdY8ZqumAutpEK8h9+Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=PK9+v9li3U5XqaVPu8ElDX3Hu6oj8rZHWjl8VDl7rehL/duOva6+mndCiPVHQ3elA
	 VdpQOJrXeEbGPDotExzttZ4w4FUVV3ZeFuCLyEcRgvO5mjICOFACBTCa9EepVvmUpb
	 P5zYo7Zjg9WkwRI5TNrLv9pwjQ9tPDrjjDVANtrU=
Date: Sat, 10 Oct 2026 18:10:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, I Hsin Cheng
 <richard120310@gmail.com>, Ching-Chun Huang <jserv@ccns.ncku.edu.tw>, Chris
 Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Barry Song
 <baohua@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] lib/plist: fix plist_requeue() shortcut inserting the
 node at the list head
Message-Id: <20261010181016.44f5e2883b6820bb32c04204@linux-foundation.org>
In-Reply-To: <CADGQE7G-PAiJ2W8uhFO_-e9GGtEPey=drfSqLfWdxXDys3mJNg@mail.gmail.com>
References: <20261009051857.758182-1-nickolai@csail.mit.edu>
	<20261010162558.62abcd2ec967b009d0cb3bbb@linux-foundation.org>
	<CADGQE7G-PAiJ2W8uhFO_-e9GGtEPey=drfSqLfWdxXDys3mJNg@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 56B2F20002
X-Stat-Signature: 6pzbh7mbukxyb8qbmd33trwcu63ha4wa
X-HE-Tag: 1791681018-278914
X-HE-Meta: U2FsdGVkX1+d6tM/r7Sc00cbliORa25qwr829pmuFS1RDgN1dN23ILVkQA9DKZoxGmVZvuUITbLG0ouXDT6Lpu4T6k7WB7kSGdnF3/W4AX4eFd0BzdO8cVIGGN1LXjOXC/Zz3uUCzvdSOt6Ko6UHkXSuwCWGBAjQcH52tyNDNcSgjzBP/HJ4/YZ+8X5HClVhoBS6RBZFry/kdrmYx0Dc3FHj+bTY7RbtwEVddtT1SLV10KbDGH+T9wWwBxFY5eAFeMQEWeVyw2/+RaFNHAzOpOuF/QU9uxaMvW2qYhVF9gUx9k1019M9ObWUH4J+/7wyQrlisENHhhcPwe7FYCNg3qx6/zoI05hiM2s0KpGk0UPatdP6MxgFSiT/NZZQGBMf0M9SOzkJBj2lFV5Ph00VqPuh9Cye3XsoZRLC9lnlC8hRfOhxRBUkl0GK8CWNoG1a4TiQm/XqxjQrSfn5e5j+3TTTWgWkLMsZ1018l8XrtbF3dlgnuzTvtq9UC2EiB/sA+mkwHTnItYZKCnHuPYT0Q1iVRzzHdopWnG+pUHNGjTTAVaPk+5y3ltY06jxx5CBfnBu4gql6FfRdCyFSDRh8WCkOQIMl6vRRc790BlO9vm+EJ+vUdP3s7cb8cemkyPiH11n6+tgHacOp8bnT0H6bMwUIuhO4CF0FlYBGZJ9ZegVIZdeoJX4W14FXjDIEs2uejpuWc3lpSp3vdr1C+ATX2RnifiZ+XhzsIwPwYoyG1HdCS5bUUCMFBv79cAMES8pPW8w/isp4tKzt82hE2junYfjH7zXwhrQMUMCOxTZUU6ze2+JhhrSNRLApdCUkhhelkLdkpETDWvCGjAZLC+svc4j4n2Ge0Np6AWg7K1+G4QFQosj1PzRYSpdIDOkqvcNwZdlgyDvOdSLSV4jECXNmP6hF3/ry8ZkHYPEKvdy7DOo0QI2+oXEVBGhzVMZWnoT2SVjo4ynvZ8GseZag3zw
 u3GeFg0M
 5dixVIbih9zwWlnNhyow3Jc5fo26qXUccJq4I0V0p7Mb+h8lcSJ5UwiQ7uZcbwF2srgwTMt1BbhYNEWd/gLFEW0mDPg0wzlgs88vIw8DWX3v2CiW54IlAxcwaHVJltQm4TpgRMGKznihB7ZketmxC+VPQSyu7XNsGK9+zPn5KXzrzHKiO1MTr4S7pkno9gqa499kAVlT98JpQeyLNZL6xgBLM24iRMoPgFzjGyuyCh/J1eFDF3UGZSXnBzbGabAKUbygIPLG5hphnqzuo27krNcmP6n1637jHkNjJb3qN4P0DlfVk52u6lcE+u5ANrzOtdXrP/z+ENY5ltGoIO8aSQ5sAx/WVcKURCrw5SaPA9A5C6y6/D+SiMHAL0uDQkRUeCog8fT0h0jU1Y9PASw5nP7eQ2TqtaAQVthiWYYmTHU4vZaI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 10 Oct 2026 19:33:46 -0400 Nickolai Zeldovich <nickolai@csail.mit.edu> wrote:

> On Sat, Oct 10, 2026 at 7:26 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> > I recently queued a fix for this problem from Alex:
> >         https://lore.kernel.org/20260903222456.1881786-1-handyhandyman.adam@gmail.com
> >
> > The two patches are rather different.  Please review Alex's change and
> > and let us know of any alterations/improvements which you see.
> 
> This patch is equivalent; I don't see any reason to prefer my fix

Thanks.  Can I add your Reviewed-by:?

> (except for the test case that might be helpful in catching
> regressions).

I like test cases and I take patches ;)

