Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48FA3CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 00:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80F428E0093; Wed, 17 Sep 2025 20:10:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BFA48E006B; Wed, 17 Sep 2025 20:10:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6893B8E0093; Wed, 17 Sep 2025 20:10:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 534D18E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 20:10:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CC7191DFA48
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 00:10:54 +0000 (UTC)
X-FDA: 83900440428.02.53DF235
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0E9BF2000F
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 00:10:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OyJdYQkk;
	spf=pass (imf13.hostedemail.com: domain of krzk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=krzk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758154253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xi42tIiFz0VEWPMs7nosEz/UcVMm2VD5sou3CrZsCAE=;
	b=fDNW+7J+Aq5EUpVhDOb1+jJu4xA32xHzHziJAaTlTa38suSFbHOQDiFjdGfFemG2dZDgv+
	S/dVyR3+MeMbQT5EY9M3vwGdNK7uzyw/KfXuNwDDl1OexKX9eD732tmWxB1vPTo1AopC1l
	EDeSpnRKVRp9akQevNPKokrrt/T9tGQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758154253; a=rsa-sha256;
	cv=none;
	b=aMJuCoeaTs4/WchYKEcwUcRVBPVQVn+9fh9HpWp/x5E+oSYh+3FSUNMbPPbwMrp6q0VWYa
	HcroBOPi1uwVyu5TJxAJe/BAnbwruEskTxcdDPz50tyCqh96H1buXNs0kP8bxXUhHaSf4M
	srXa0I2xaaRENjGhr31X1JE9MsKs4Y8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OyJdYQkk;
	spf=pass (imf13.hostedemail.com: domain of krzk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=krzk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 64B8760008;
	Thu, 18 Sep 2025 00:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C556CC4CEE7;
	Thu, 18 Sep 2025 00:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758154252;
	bh=8mtrXdMjzuzHAbOpsanLGbWf7gnLc5D1Foi3/VnOcgM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OyJdYQkkFpHHEcM9nT6ur2S750w/3F2tqMonFEN576RIpuDdF180SobzO6c01xrAG
	 5mTH7Bhinw/iqB4GxWe6fzkRy+b3A0pY9rRC6BFmmTeJgmR2IVLSGt/S/LoPv6A5hQ
	 yFvYrMINAcPLCaBYCtaEIUk/y9s5skLO2xJqPa7SBDUDFvDbcYxWOOcg+kLK0CoFbv
	 sGjJW6y72/Xrylr8p+PCJMBXtHFVGD1RN7/xvXcOz1i2H3o6JA1K810vPe3UhqPTkD
	 zLSmoqhLwH5kNdxo8+UQ7Pzh4SbJpJ/RqwBv8ciIFpNJQ9xIuuOBHQ7riYj8pp/J72
	 aQdzs3S5D+kHw==
Message-ID: <7585233a-a41d-45b0-b009-58b9dfb9a828@kernel.org>
Date: Thu, 18 Sep 2025 09:10:46 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V13 6/6] dt-bindings: riscv: Add Svrsw60t59b extension
 description
To: Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
 linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Conor Dooley <conor@kernel.org>,
 Deepak Gupta <debug@rivosinc.com>, Ved Shanbhogue <ved@rivosinc.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Arnd Bergmann <arnd@arndb.de>, David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Chunyan Zhang <zhang.lyra@gmail.com>
References: <20250917033703.1695933-1-zhangchunyan@iscas.ac.cn>
 <20250917033703.1695933-7-zhangchunyan@iscas.ac.cn>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <20250917033703.1695933-7-zhangchunyan@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gnihob5j4r1sbktsaqa95x7o36jousr9
X-Rspamd-Queue-Id: 0E9BF2000F
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758154252-204446
X-HE-Meta: U2FsdGVkX1+sO1J+auktEkZRUypwdZYoNt4SlPhccZHwINuLV7Gi5aj5hh+T9mLioZew6CPR4Ob+TVOrYY6BZDOtHdTOwUpK0pLJTM7nEn5ktcQZi3n/vbTGvApn60e3sewlHgJ2O1IjN+zfVc4xvJGs93QAx3ixyg5D8q/SCzm07gX4Y23hVAyieDAz3sC0QoWZp59QcadJQQXQ4/x8cvLG+/Pv3JNQ/SF1rKVaIpMXt+BO52q9CsIakqJirXxjSPnihy2D6aXjkc5mLba2/YeUnki6PHQmLfspy9zXmh2OF/350CIhi5gzmtwTfFjVOK2Oic2lGaExns2SUwsMevPpZgVekYDFwUQ8RlyOxf3Cs46ifz/9DxK1oyh0opgVzgdc6ZOmv8tFNV0aM6y2/6soIRKaXHOpZ9joIA9Ysw8Zi39/x8zhBxLCXE5mDXMrXh/tIgA/R/ApUgnlrSdnQFI5FWGGlNPSlnEZ0ybQ2c37PoyxzKckUMKc2d9DG30kG9ETDyuOBWBPFnDG+h9LC3NcLBgg0dVuck1Wl7s/UHmSCxIOcWLABacgsjzvsCMxuU6oeFr/ovlj6CPDPvtjdL9eWFCRTHpnBKim8rEpHxsVLrJVGp9J0d2cSQUViyfB8jr+n4zm6cBa39WNMgLzObLgQrH6xCjQcn1ljGncCf1KOommfUDRjULOOpsC9FcayTTc4mMeSRJLYCyKhGc4M0qDBFpu1GFS2cyUD/n1HW6CpkQv4JUBmI73SpWbUTIT4YWTw0PvzvIAaHDlbbgZ5riJ15Q0MGYBNFekSndZhmaGQxWoep+P0Z5AqfHOvrxr7ImqtZDpHWvW2Yem0ttcnt+FJ9qXdzbSkjhGTSSzAMP1KFWfz2O5rpTvsBDq+zZK7cFV2313CtycA9rtQzfICPNF4DK6BdryMgUuXXss1R5Vlsl2o755F6e2Vo2L7hj3keyRezH7iDGeTV5qm62
 bC6nt52v
 NLragB4I/FbQV/h/vi53yVBmQpRxKWwDZI+qoSlQGziWdkSSV+PlfuOmnvnfVg2q+jsX8Ja6pARQLbV7ohos1Lj0jvAlxXX6N85izOZxwV6J8R3gMxSTUJApffxe7IakdcEMMbIzjidM90rgZdJY3sJQ6NXJ5krk/4ntTx/XJ6kFZ/eboXD5Tsw+i3arrMBBX4AwDC+Ng8j13jPBiqAo2/DKzZGQm7D9KhqAE7h3MN1yHG15gAHw0pbssslSEqWnYjLha/unTCVVpPhW0eoTKM5aNF1kTlZqpX0x4VcDRvflLqBZpsiGTW5hJ9OOSp8HN5tNAjoG3Q4V65no=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/09/2025 12:37, Chunyan Zhang wrote:
> Add description for the Svrsw60t59b extension (PTE Reserved for SW
> bits 60:59) extension which was ratified recently in
> riscv-non-isa/riscv-iommu.
> 
> Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> ---
>  Documentation/devicetree/bindings/riscv/extensions.yaml | 6 ++++++
>  1 file changed, 6 insertions(+)

<form letter>
Please use scripts/get_maintainers.pl to get a list of necessary people
and lists to CC. It might happen, that command when run on an older
kernel, gives you outdated entries. Therefore please be sure you base
your patches on recent Linux kernel.

Tools like b4 or scripts/get_maintainer.pl provide you proper list of
people, so fix your workflow. Tools might also fail if you work on some
ancient tree (don't, instead use mainline) or work on fork of kernel
(don't, instead use mainline). Just use b4 and everything should be
fine, although remember about `b4 prep --auto-to-cc` if you added new
patches to the patchset.

You missed at least devicetree list (maybe more), so this won't be
tested by automated tooling. Performing review on untested code might be
a waste of time.

Please kindly resend and include all necessary To/Cc entries.
</form letter>

Best regards,
Krzysztof

