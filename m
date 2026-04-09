Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53B9FF364AB
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 18:20:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFE126B0005; Thu,  9 Apr 2026 14:20:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD51B6B0089; Thu,  9 Apr 2026 14:20:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EB256B008A; Thu,  9 Apr 2026 14:20:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8F4FA6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:20:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 436C7E0242
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:20:12 +0000 (UTC)
X-FDA: 84639831864.27.E84849B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 439221C000D
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:20:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="JQ/eRRmO";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775758810; a=rsa-sha256;
	cv=none;
	b=irV8MKy5uupVBptyGvxt+QCA0N5VokVZwlkWi8ISKdUVJ4N+gsDvWyevjdMtleMOr/T5ob
	IOM5606viN42hQkd7lwlerwR1kCwLeGTmEmJ7l4U7UGaCI71+xDCYv96Yy8qwR8yCAFyql
	ku276uZ5stRUrbBjjBYrZmDxvSPe5JI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="JQ/eRRmO";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775758810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJIjAA/eD1RMhgEHl8pVFaQQejDlSrTIr/cMNOh1tJg=;
	b=4ebxXXUf9ePGRtdfEKmuQTH8M+kfHOKsgqRZeUaNKnqlBTamq5hYWsvxwPe6TNjIek2qsv
	mheRkj96X4wiLUi6QeprAReKPznfreRMVOTUlUaHuMnbraUsvnYorbuUOzgKQKxUnK8Plc
	dPXT1LSXa8hQcOHjvP7CFZTltz+7pxU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D00E2405CD;
	Thu,  9 Apr 2026 18:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD532C4CEF7;
	Thu,  9 Apr 2026 18:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775758808;
	bh=ZigHSvBx+14kIC9PKUwmY331LWP2TKj0II3UDkUytQE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JQ/eRRmOmwVPwBC6gVdr4zwewEVLiI/+vLuKtcpWC10Bk0bb2vqaE8VDNfsbIzKJ7
	 bUpUhXPjK5cZDnRd0tMElCfCuWDCoS83Rrk6RdORF0CTiiDQNEh728lRv01BW3G7Cf
	 QuWR0/5swDp3fhZk0qgzrD0SXGVIMhyh8LAEJr450idKjGtUC32p8J2n+Fc32OzmW8
	 V5+ekgqF7ORGzdhUv1DRoEBDIJq0wI3vU4Kls8FJMkL9D5oD9l9BQVke9JFsBRs1S4
	 gjPSsLLZnCxWgT5UAPWLRbakWvvXpPTWaGRq8AOTvTKNTT2LUVeluT8XOCgY9cYDAt
	 OpzqJcpkEvG7g==
Message-ID: <d34c4a14-e69d-4fba-905f-59424d38e0b0@kernel.org>
Date: Thu, 9 Apr 2026 20:20:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm: stress-ng --mremap triggers severe lruvec lock
 contention in populate/unmap paths
To: John Hubbard <jhubbard@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Hugh Dickins <hughd@google.com>
Cc: Joseph Salisbury <joseph.salisbury@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Peter Xu <peterx@redhat.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, linux-mm@kvack.org,
 LKML <linux-kernel@vger.kernel.org>
References: <a3474fcf-9f20-47ee-9d15-233e5c7e3f83@oracle.com>
 <4a4f5b48-8a1d-48f8-8760-0f5d43b5d483@nvidia.com>
 <982e5964-5ea6-eaf7-a11a-0692f14a6943@google.com> <adfhGOHcg4AF3IFn@lucifer>
 <2cec5f0a-93cc-4572-9793-17f9fd123d2c@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2cec5f0a-93cc-4572-9793-17f9fd123d2c@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qyrkkmj96ajgyp458e48jd1bqnj3srmf
X-Rspamd-Queue-Id: 439221C000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775758810-643881
X-HE-Meta: U2FsdGVkX1/Kz3Z7Ndqlc+uNxJD4ZiYuxr3UAYg/JxU0WPVTI6bx6flL7jLEWN2D2HGjt2dmQVzs4w3+tyynhkHeFBh0PkL58Q6xOiLm63N/MqXnl23DRNus8jf9KAtzf97+UOTxicS0WPK1NfRpkbHgjikceZyme5MjVvremFFsFPvNU8aUPG/zXSFeTIV7crhr8tRgkyvnrlLBw3ulN1LSCIoWqbwpKStiwPQEpYyHXFBzyb9j13FwVIercqo1X/JKGAG9RIXqftDzz3kfgNfpMySJqz4fAlenZc8S2hGAEaWvPHq1r9AaDaRe7PwwVCfNwjij4V1s5C2W1VRzpWZMvidc5jGbwNCcFUpH/rCbjjVh7Hw/sM9e1IslJwKjq0QSlakLzn5J7k849eFA5N/WdlDSzrydtMnvCP73TahA9fhtTnhF3WSn9F003VDVBOK2Fw44UxVhcwHrRjDMq0e2JrZ3YHIE0/h6vySVzMOfoNHtIprhA5yCmqn0cyJf/3GOfKLAZQ16e5SKwP5zAZE0iRTpLU5uLFYO+VgVhpflpz52aIZva9r1ueUuXR5xgYCgAn8PxZbpzeEsU7Ok1MUOQWnL4MZdxTDlRnNhKT5IZas28Zf6PUXRD/jBh4BQrwIAgRkNgAGjzVWYehHnj+Lv9Cy9AoTzAYXlGC0fNfztUSIHqKeb24Dwk/DMDNyvYNBYAl287pv4qmNqn3xFSTwvuEVVcFteCZMrYIQdAk4fQNUKSVWi5T+sfJz5WPM7auZyTcPk7ebLySndJAND9NACPL521N5qxnJ288ALXxI1JETxOEOeRy10LiIQFB8PV/UYDKCYnWLLiYL69UrG6PebU1C/u/XOFnFmuHzMK/zdOhn0hJJnVEPr85PhubtukB5xLa7vk4Vk0hGPdjfKcgnrDmKYzBG+e3PAvQliKx9jnnvyV5QbL5pH3KTaqsfvNKLRK4j+5mki367M2cD
 kj2sMmPP
 c9GscRjH5IrE8f2ljz4hCxZPOTblW9wGcJzXPTj3l3FzHqWrQm4qVj+NM9BDb6T+iUlAJimV9xpeX0WlZlfRIpyXoI+3+E0KJeLB7LiaePGuBAkDjIbQwMerIqzbVzUxcbksff6dD7b9d1kf6rHPb8X1pSstRGFJ6OAjTp2Iikh8bK0ramThx8nmk5iCBCihOwwkz4TGZBjbOjB+eJsIkr23tpQVeJGcaEsNeT4XWP0Yz2cH63xP5QCS8AXtIc7ftIKOR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> 
> Oops, yes.
> 
> I'm on the fence about whether to post an updated version of this.
> Maybe wait until someone pops up with a real need for it?
> 
> Thoughts?

+1

-- 
Cheers,

David

