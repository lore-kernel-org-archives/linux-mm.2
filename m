Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1CE0606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 06:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xuB89//u
Received: by kanga.kvack.org (Postfix)
	id C97F76B05B1; Fri, 30 Oct 2026 02:55:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C47C96B05B3; Fri, 30 Oct 2026 02:55:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5E856B05B4; Fri, 30 Oct 2026 02:55:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CA766B05B1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:55:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC97A1605CF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:55:33 +0000 (UTC)
X-FDA: 85378381746.25.FBEC56B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0D6B040006
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:55:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="xuB89//u";
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793343332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OVfOJhiBuJkTiRJC5ASmF34dYnZgJiFJ6DSZ+ArOXlo=;
	b=nhXB4phvWl1XbwHvDPaW4h+nCZprdatTYOmqVqy3oZgd+4oarZzqvWR93tzy3WNMzNJsjP
	UL+NGj1qmgNcRv9bW5J5jtQCwc17QOkgamP2Yzo72W6cK5OPKR8Azj47oaFyjI8JRhaBQ5
	lLWIr6hE1GE0p/GozO77LIcDgk05wa0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="xuB89//u";
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793343332;
	b=U6lyHEMg58w/XAynOW9h59XTl9qXcUvgceEPBbImo5F2l+/aWICWxCA0YO5kupHobCgTeZ
	cRMXJRRQvai1gOVcab/GlHokmiYQW06/vxQzatImiDVVr214c4eLnazhNS8uk+ufI1pBkH
	rMpkEv7wlKBnZw+N5NtinwpCauywmiY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 84AF443DBD;
	Fri, 30 Oct 2026 06:55:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3AF1F000C1;
	Fri, 30 Oct 2026 06:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793343330;
	bh=OVfOJhiBuJkTiRJC5ASmF34dYnZgJiFJ6DSZ+ArOXlo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=xuB89//uo1UEibq3QfgB2G6IHiwiq+oF1UwZUei3D4anuztPm9je6n6tMN5ijd0T6
	 jlZWVbnp2PFF9fW/wRJDHl1jH4E3Qxuu8prQNOVIDjMac7Eiasaiw5jKZBkOCG2v7L
	 ZMGzCRQ9maTcfufIDB3pRV6Ty3QcYCBh/fXrg3KU=
Date: Thu, 29 Oct 2026 23:55:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jackie Liu" <liu.yun@linux.dev>
Cc: glider@google.com, dvyukov@google.com, elver@google.com, pjw@kernel.org,
 alex@ghiti.fr, aou@eecs.berkeley.edu, linux-riscv@lists.infradead.org,
 linux-mm@kvack.org, kasan-dev@googlegroups.com, muchun.song@linux.dev
Subject: Re: [PATCH v2 0/3] kfence: fix pool allocation failure handling
Message-Id: <20261029235529.0a4a37da0ae150fcfd4ef954@linux-foundation.org>
In-Reply-To: <67833df2daf24cc413c212c14306b9230dde996f@linux.dev>
References: <cover.1793242457.git.liuyun01@kylinos.cn>
	<20261029182645.d6e7b119a562c973d19cda63@linux-foundation.org>
	<67833df2daf24cc413c212c14306b9230dde996f@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0D6B040006
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: huj3eg65znmkurmqm6bnq1pz3j6cduy8
X-HE-Tag: 1793343331-768282
X-HE-Meta: U2FsdGVkX19+oU6USQ3pYimUK1PVFahxl8pxDfOLQw+MpjUuVL2o2+QJmLO+vUW5jmsxAcx6hd8Ox/lf6DKcpYhgNJ4FZRsG+Rwf7ztN4hrO3IF7mMIbJLoqxT+sIYqQPsaDNj23ksM52gFDRuCNJhUZT41DmYDFVa42zCdycUP9BvtYDQjVhA/vwBTuSvxSlvAfqC2y+hLpFE63yw7xlo2n6EBzXKaHkm8i+q6CUPgJMuEDvcNik/nOubpXBdPE2fvN9Pf7fTr6qV47e9OVsYA//5PcCZDhWeuHMmELRNtB530YqKOHx0lTe5TDZtWEFuUzcXSJ17uJHlFs5yF39A2CGYyt4e8N2H6GGjHGQUlkDTUySI/6VMpHV2UqW/dzyydCx/dkvkaNZ7NwI9Et0R1VWUn0AqPiksJjcQ+lElF1j8Y8DJp0Au4SYOtKdVFqyUvSU1ZQGTfVw3EtsCjqvvmxYywXuYLo/QwqW+8vllJYlVOKuBSiNCmRmxzEevZt8np4U3p3J0zx5dxUduXHfkIq4WdSqzXQu3twzM0MDJVO7KkcdspDGB4/EtUP3/OK63eg8C3aqTpxFip9Bwuy8zITXMH1Kad6Ba9niVRO6GhWGQzZYQuY6hmS+z9bcN8aflEDba5E+KYsPYQ9dPv/8svv600414qafVOKZHuHqCTj4LzRfDCpKaCWIcF+glsHYVP4hOJQ8cWD02TD4swuC+OkwVaUzAFxc3SknX0IrTETdP+cLC5l/slwxzIJg94cwslSEpiYgeKK5uNGhLw36bsAJG/mj+mrE6Xli9O8slC8GaoH+2xI/CTD7IbJej04grmuBV55PHO23+tVeAOeNfx5qvuyljtVlj3Z+GrM7bO/t3iunOBUhCHzZUqgIuMpxPRW918OqnRKmweqGf0PGvHqR02BUQYVzEiLAvf8GgGybihIbw20bSM+ulvSSanSfz6FJ0BHNq0zwnjMxuY
 9g+vme0i
 7RqAWee82HxB8i5vD/Um942s3x5sbihaNhlPGoigV0wNcUK8wMESb6B47CU7FfDij0+TFfTWWyHgW2VbCMGD7+A1Iu5+wYxz+47vYeB5aMh4Kt9kCrxJl2pwUt6d2ZmGnQPp5WhGqsQlGDno7q6RiLq98RCBZK7siOSiQoNe+W8/zmu9bazVQbMHn6/htl6YAusxYe+c2U0rtQz3R1/UofXXQ9Nxjb/xp2y9qMkgdTvca9Ol77U/GJFZtXoC/DKqiymgG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 30 Oct 2026 05:55:21 +0000 "Jackie Liu" <liu.yun@linux.dev> wrote:

> 
> Also, Sashiko has reported an issue with patch 3/3.

thanks, I missed that.

> Could you please apply only the first two patches and drop patch 3/3
> for now? I'll address the reported issue and resend the third patch
> separately once it's fixed.

Sure.

