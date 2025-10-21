Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0EB8CCD19F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 03:17:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC64A8E000E; Mon, 20 Oct 2025 23:17:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E76AB8E0002; Mon, 20 Oct 2025 23:17:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3E308E000E; Mon, 20 Oct 2025 23:17:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BCA258E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 23:17:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4BFDF1A03A1
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:17:32 +0000 (UTC)
X-FDA: 84020661144.08.CB6A574
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0242D140005
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:17:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmx.com header.s=s31663417 header.b=opuuB7Hl;
	dmarc=pass (policy=quarantine) header.from=gmx.com;
	spf=pass (imf26.hostedemail.com: domain of quwenruo.btrfs@gmx.com designates 212.227.17.22 as permitted sender) smtp.mailfrom=quwenruo.btrfs@gmx.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761016650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kh1SyStXJPG/UN/20xIpd9r7yNVZN6g5tCu2/tEqBys=;
	b=s+tjbkXQj+QY+okO41++Zj5y2eCWjIcBc3YLdbMjlIA8P5OxzlySouyI1OjpNoy/vy774o
	0ABy7IFtZKyYo9OpYysfIC4k+gjMHCORyW8JBR5T/D5wk481Mn+P9r4gMe8iUXwVSzzzBe
	yPV2tM6nEO3DECg91raoUkwDB4ImGQ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761016650; a=rsa-sha256;
	cv=none;
	b=5KW73vpekxTFo9Xmz0vn/B5IPCySjM4lqPeZKfM5qM9R7ZB0uRM46wwreh+SchrCH4t5mr
	Ur6E8nFbnLz1xqgEH4PLYoDRqlIboL9S3k2fIL+OneR6i5xA/w4U/lkFOEbQUArO6/AjtV
	NJUdEH5x9gckemao0+p7+4UqCTwZQpc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmx.com header.s=s31663417 header.b=opuuB7Hl;
	dmarc=pass (policy=quarantine) header.from=gmx.com;
	spf=pass (imf26.hostedemail.com: domain of quwenruo.btrfs@gmx.com designates 212.227.17.22 as permitted sender) smtp.mailfrom=quwenruo.btrfs@gmx.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1761016630; x=1761621430; i=quwenruo.btrfs@gmx.com;
	bh=Kh1SyStXJPG/UN/20xIpd9r7yNVZN6g5tCu2/tEqBys=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=opuuB7HlyLZsToRbyaflDxs54OlYAVIOUaSCSX+j67lupdVPo0HfCVto5Rc1LUXc
	 8e6isj+Mh2JpH9aZE/VfNBcyqs4MXhu6DRssk5ML2kfoT6SSgImySvaYA44ed78Aq
	 uS8dNCUnVdlRTQUUzDGWTceP/MSjm3zdION1umqxkRxfyUwijRaRfzpab7fB/hntT
	 A48dSkFL7W9ZTgBgJ6keYa927TNPjxX2WsqVRzRnzmIyjuzTV1yMo2tCtjed0zb9G
	 a16XDgEbhVb6MyBii3m26lGxX/DtdqBs0eUJi0/oXn8W9+SRxyun2+2ikVwQlnkY4
	 ewXVOL94gYcGvrkmbQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [172.16.0.229] ([159.196.52.54]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MHXBp-1uy4IO2wUL-00EP9l; Tue, 21
 Oct 2025 05:17:10 +0200
Message-ID: <b91eb17a-71ce-422c-99a1-c2970a015666@gmx.com>
Date: Tue, 21 Oct 2025 13:47:03 +1030
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: O_DIRECT vs BLK_FEAT_STABLE_WRITES, was Re: [PATCH] btrfs: never
 trust the bio from direct IO
To: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, djwong@kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-mm@kvack.org, martin.petersen@oracle.com,
 jack@suse.com
References: <aPYIS5rDfXhNNDHP@infradead.org>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <aPYIS5rDfXhNNDHP@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:heh+exyaLZgTrjGd1PWKLbOpy5V579t59E47W4iGAQrBv/QN7lM
 b8+63YHNXJNUp0KAE1vp20tRJhPkVXAOL/yucj6sD5NzyKLWeCgTK/bggsCBL/KBQe8d5Yx
 6dx5s6pRPJw+Sa9ltQHA8faBlrftyNx4A8GMsToGJamT7vtv6ZwJlDu32zFf27gQHQSXQia
 VELLANNZ6ColOY5cg1zGg==
UI-OutboundReport: notjunk:1;M01:P0:SsvwGXYMYFs=;1DBgOk85iNX1tFewJeknkLq/ea1
 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
 d8SfwT+Xcj3JR7gmyZ0pzJhWbE=
X-Rspam-User: 
X-Rspamd-Queue-Id: 0242D140005
X-Rspamd-Server: rspam02
X-Stat-Signature: nuc98qxobq1a8hyf9mzz7herksm5gogd
X-HE-Tag: 1761016649-815452
X-HE-Meta: U2FsdGVkX19WOiy0oP3vNMpr6enMT+J9AjEo3/sJ9y3MNW7PFoItnzadZErS3XQZO0DFvXimi1bU3dLe+a47mrFdnh5TCOac1oVRxpa45F2RFtD3iTU32rTauomvxP0URgmLzSc0fOuroAnxCtzUxBicxoK1dtQ3CXFogqjq2hBL4GlhXWovWWM+0R1l00GDB0FMZVHzTJy+QHym4MlhyMTcWYGk7O2KCWY4JOesnonJrNlETsYiF6TMSrcll8285TbkSyTgo65Fap85XQLrANa0YTqOcM5pm4lR8OFVjcI3hsojuf9rJam9XbqUgCRJHNbdT7tssFp0EkHoxG5NxP+O1aJqy/FFeNyKTtnbn5/bxxerSSHoW3BUo1bfEHj7wG3+6YKIuOHH3J4873Q34Ur/ldRxRlAG8uhUWHVfhaR6laLpQEz9Wxl0wOQCX9vb5Pt33UPDEexUxfzMypFzQe9iPggV7Yfmt/0zx8f/3UUohW0DdIdyxLqpJormDDc0hZBewXWZCb9BEpj0yBuFy9Na0Gc6+UAVI48T1KSUj+z6eUussPHT8OmdQPc5VTvmvRrDCC36KxSxKhfiTGVzmIwn2/oGyrNeScuc6ZYvxEauAxftxpFLvIZqRAuRAnXrMv/eq0XX3jcFSZVTwcO+vYhtqLvzZtZ30lJX5ud0LEWHzygRsQr0iq7OxrspFcRWUHKn5068Lnbg5EZRITT7uI0cKcoOw8l0k7+vtlksAfWDaCCd5Ic9jtgi4TSV/mBTI9WBzolypp0ORBiPBZ35lrT24CkH9N5FKyenCdWKnTzG8h7p++9gADzP2nIhu3WJ3RTKu0KOcXVnDhqPTaKGZkFFRK2Qq8kVfh0kB+KoH/O2bguil9Mqiv+fvBYN2MpGOWN3baP+w6NA6i7H/66NM/8KJG51wTbVSRU7SqDR2os/ZnQGD3YxqdPJTI2gkINsdMERRW5V907HfRvIFxB
 skbDfYdP
 +b4S2SdpONK4POLMLNGJbN5h9QjncAaRQcrXqAuwFkKKpqHbIqvjP1mBO0zTdjmSItFO8v8wX5wqrKn62wL1fUZQCp/JvnrIdzx0vmg49zt8IiEFikl8qwDRazSV9CPujD0DDBi9V56wsgW+78uaAgK/pMjeJwSsYvRZvvqMdVlqbeXCWIM4RElzFNECP40PiSZFB1/6vslT3LEnLdocpEAoKDnnAFmmhpJDg+jeV8TfvMQaK2wXGRsFRDT9/YMUCw4lLWU0aubt7I9JCRb9swix3ksznel6qeGNmWnb6irl+pnjmVQyvDouU5IKJwaTDc2RScju5sXIGYh6EpTu1z1QHcTfcnnwKH0RtMuUbSLx+/Rzp5zGrO8AhfDDK+FY1Ng2EFejpYfPArtZKJL7xi8X2/WmBseZOVbi2uHoJWgrJVPvc+1GDqaEDEg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



=E5=9C=A8 2025/10/20 20:30, Christoph Hellwig =E5=86=99=E9=81=93:>
>> But still, such performance drop can be very obvious, and performance
>> oriented users (who are very happy running various benchmark tools) are
>> going to notice or even complain.
>=20
> I've unfortunately seen much bigger performance drops with direct I/O an=
d
> PI on fast SSDs, but we still should be safe by default.

Off-topic a little, mind to share the performance drop with PI enabled=20
on XFS?

With this patch I'm able to enable direct IO for inodes with checksums.
I thought it would easily improve the performance, but the truth is,=20
it's not that different from buffered IO fall back.

It's still the old 200MiB/s (vs ~2GiB/s nodatasum), no matter falling=20
back to buffered IO or not (and extra traces indeed shows it's really=20
going direct IO path).

So I start wondering if it's the checksum itself causing the miserable=20
performance numbers.

Thanks,
Qu

