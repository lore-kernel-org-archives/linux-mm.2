Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BEF8C79F85
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 23:21:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D0476B00B0; Sat,  5 Sep 2026 19:21:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 681CE6B00B1; Sat,  5 Sep 2026 19:21:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 596A96B00B2; Sat,  5 Sep 2026 19:21:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3AD246B00B0
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 19:21:32 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A827C16044C
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 23:21:31 +0000 (UTC)
X-FDA: 85181282382.14.97E05A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id EB5EE180002
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 23:21:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="msU87/qV";
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788650490;
	b=Xkbi/14n68WyQZX4uE/BsEqwWT9o9cOblCylZmEswW+bvKLGttzl+1Tdy0TF3UflyTDe/P
	Ab9B9Nmwws1sFK5B/E+SHl4zEVYc2p95a8hpnZICc0ALeI7wFqt6bT+4MuPwtRK7dFE4jh
	fCat4uSowG82svlx82bBkN8/xC+k9ZQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788650490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1DctgdNMON0RcIzT8CNT0PP0dVflKtlHhY7ioRXj7zg=;
	b=bAz1YGG0kxBJ5THMCetF3eQ83O2uJw4gQhjLgFBW627v3ZbNHdkrqdv36lTYhJxixjn4LW
	ReQ1eyJmX6jaue4qOqx5BXeP7KjfppCrdBoCcNm3tySPFR4ElQtAwD5+vtXSH8FVkr3nZU
	jOb1fWj1V1HDZgqx5GKYoRwnyLWBaww=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="msU87/qV";
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7024860AA5;
	Sat,  5 Sep 2026 23:21:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6910A1F00A3A;
	Sat,  5 Sep 2026 23:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788650488;
	bh=1DctgdNMON0RcIzT8CNT0PP0dVflKtlHhY7ioRXj7zg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=msU87/qVV31p4uoJ92QcwUWglP0JZdHVb8xXjhNMlEntOlfHdQx3NyIKQd09NXVyy
	 099+mBApeBTBMlFZZRN2dx9AUEQQNl/ksRRv8kiPLrTbU4BNqcF3s3UhoAEMWUR4Wy
	 mhLvlV+B4MFJJWvV1ZpJASpdwa6sjiwHS19I9Iew=
Date: Sat, 5 Sep 2026 16:21:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: <david@kernel.org>, <ljs@kernel.org>, <riel@surriel.com>,
 <liam@infradead.org>, <vbabka@kernel.org>, <harry@kernel.org>,
 <jannh@google.com>, <lance.yang@linux.dev>, <minchan.kim@gmail.com>,
 <lwoodman@redhat.com>, <kamezawa.hiroyu@jp.fujitsu.com>, <mel@csn.ul.ie>,
 <linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
Subject: Re: [PATCH] mm/rmap: fix missing barrier between anon_vma init and
 vma->anon_vma publish
Message-Id: <20260905162128.46fe06ad3689af1db637a005@linux-foundation.org>
In-Reply-To: <20260905061820.642437-1-tujinjiang@huawei.com>
References: <20260905061820.642437-1-tujinjiang@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EB5EE180002
X-Stat-Signature: cjrdstezk9xdhigckofqwz3ptinmo9dh
X-HE-Tag: 1788650489-855940
X-HE-Meta: U2FsdGVkX19XW56UwrQUqCQdMZvQx76mQg35MNNyCJ1mZ4oul6g2W93jJJ155dfOuyURedfoSAla8VX28l3x2HEYQmR5M5T/hs8yCTlUDmZT1w+K9h9QMDTU+TDErBlTd11yx/a20QNhdg9295FWfxHn0VAmwvJbOLRWqHfB/xK/8GzjWnQfZSXpyCwwo8M7z8j3lKAE7p5arlPkA7V+oNuKSzN3l6oyj0GNmn0NeD5izS1xGaUJ7hV0fuOhq1FHok122Cp16mRZU89ZmUZg3MaM5v2YBPGiNFRW4qefUBvlxHlInVHBJA1L1p0M9TNwr0h5vsExdu947aYU5YMuHfOSCOxMz2Rj89nx3bTftH+eHLM5ySZ1592YvEUpka6CtRqfg38zKaHgNQY8lVwPubJvy7P/4T0crMHICn0p04BkV7DZa2N0BvAPbqrj93Aumt1nMq9+gAoCdNbv6O/UnpTgk94agWQ6CHvPHnnUsUmRrj1+01LHYYkDcXUiV4m/ErO5ltwJYMn86xFORddfpPNd9JU1CcHwfTno4VU8oxIgJ5AY+1WNvYAVCeUDAm3eM4iMFtynwITlyyBF1gPfUb9T9EleGx6e814vcg2el3BtxdRAqaKlWVPdwFxpllMhFeKTIkAmNBttLhxxywFy1bw64p90E0Yl4PFMXDJFApnQ90uGAw97FaNzM8RUGKQflQrHcaq4RTGXgWNQfoVL1+pT+r/31NFcW4LfYZ2zKJP+c0eOOPjR01IrEFUqpqcTxPfHNn66YOIk3hnn01Gi/d/jzcqOL8fyhwdP5U+NrYuIp5yTM1dF9eBwIqpiz2GzZ8VrLQlg6K8Jrq7R3r8g2WAcBTUkeEFg2udbLsWEFIfpivUlyxiRPmw0ZlsOGN6tcBVqdSAuCw5Um5trXplYhDFLlp7gYataxlkUqPQX/h+Tzkcv46DfK+vskHMrBZoMpNALz2AmfNe9lWfH+Rp
 5W+xJJO/
 QHsNdnRwFxP2Z5yBQw0WfHfP8JTkV238cYYzhNw0tWzIBOw5oM4Lz17v8CsVyQh9N5WfKrpGXL8mAUqg3zq/TdDjrHCh3O/BxWQZIfM2jd4Vl+eTYJfHFkhEbqeXt+/Y4l3XBD3ky7nDWJpODk7KoylZnHKNfazMrIoG1fmol/vX69ywb/+vONrkQyAs47T0CDnUm2g+xW2lned1JysrYhXVckN/K6jJ14422n4Iojao8esYbcdyeXwh2hNMKAgYNFIqeVwahyR95JhHVxC5nXlA+iuxQmfoZBi2WK/DXcceUedxD3lf3oQalCxYGJ6hDnzheBpAWjW6qho6uI2HWTJ9lCrhmy9ZFBY+TZHJOYYZ2Hk4IpWg3xwuJi2qbylyyvlW4avmLS+elvQmZySqX86JMrNmA1RNfl//bV8xfYAha5co=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 5 Sep 2026 14:18:19 +0800 Jinjiang Tu <tujinjiang@huawei.com> wrote:

> On arm64 server, we found  __anon_vma_prepare() reuses anon_vma and
> anon_vma->root is stale due to missing memory barrier, leading to
> lock and unlock two different anon_vma->root, thus leading to a anon_vma
> will never be unlocked, and another anon_vma couldn't be locked anymore.
> 
> The race is as follows:
>
> ...
> 
> Without this fix, our production environment could reproduce this issue
> about 2-5 times each month.

That's important info.  Can you tell us more?  How was this observed by
operations people?  A copy-n-paste of the kernel messages would be helpful.

This will help downstream people to decide whether this patch fixes a
thing they're seeing happen.


