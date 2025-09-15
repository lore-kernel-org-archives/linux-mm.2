Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 910CECAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 21:47:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DACA58E0002; Mon, 15 Sep 2025 17:47:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5D4F8E0001; Mon, 15 Sep 2025 17:47:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C248D8E0002; Mon, 15 Sep 2025 17:47:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB9628E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 17:47:21 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 386BD5AD2E
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 21:47:21 +0000 (UTC)
X-FDA: 83892821082.13.F96A499
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	by imf30.hostedemail.com (Postfix) with ESMTP id 062A58000B
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 21:47:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmx.com header.s=s31663417 header.b=Wc5aIdc2;
	spf=pass (imf30.hostedemail.com: domain of quwenruo.btrfs@gmx.com designates 212.227.17.20 as permitted sender) smtp.mailfrom=quwenruo.btrfs@gmx.com;
	dmarc=pass (policy=quarantine) header.from=gmx.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757972839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KldUXbA6jxKjrjYh+I14mkmRysmqtKYyOaNv5IqImaI=;
	b=XuJL0Od++Wyr7VY61Y9IWumK9WyxkHQYIHtVXxfUTftU0RojviUIyr2kW6Dlz78Ych0u37
	X1SCneHpkL5FCzyp9US0TQm8U6knBHo2/IbhALHVrGe0Bd6dcEtHg/4KvB6ey/bhrw4oNm
	F2St8QjdDo5Wtfvuw6ON8EGhWO8woSw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmx.com header.s=s31663417 header.b=Wc5aIdc2;
	spf=pass (imf30.hostedemail.com: domain of quwenruo.btrfs@gmx.com designates 212.227.17.20 as permitted sender) smtp.mailfrom=quwenruo.btrfs@gmx.com;
	dmarc=pass (policy=quarantine) header.from=gmx.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757972839; a=rsa-sha256;
	cv=none;
	b=rdrD24l2RIHVugDOEx3H+t3hnw0Z42aYPsN3EZDYtGWN0Fhd1D2ap9akmV7yjp20pthBMn
	cy4WSdqQYV/LcOMIUQTD8uIz9PIfVlSvIGbfYnRlJ1GPG9+jShWPBkCfQlZ4rbHkRa/I3S
	O/+GCfMvNx2BC3n42jAKEHjYAIFtWdY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1757972815; x=1758577615; i=quwenruo.btrfs@gmx.com;
	bh=KldUXbA6jxKjrjYh+I14mkmRysmqtKYyOaNv5IqImaI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Wc5aIdc2a/EnwTZbsTSWOmofYEghjfhHJ1z7tFQbJs2KnNcoNZ8ydblx9lJ81/FM
	 jkxZjiyya3OD1vikluhvJvn69k0EDolfXeUMGNVb4f27xONoKv6SL6/V7EFIe4Nei
	 Q/v6QJNZSVx3PcM+xftXJwIXNGgpPmSBy2Y5D+iCtMOoyQy0lb3TxEOogm0oZMEB/
	 Vl40Z1fyiKBZesj8e02e9eX53kOaxYLu64h78spzPtYVVBM3vuVqQb7pecOL4EkUM
	 WZ061CperdZp73sZa0bVBATdu9vZZdOeawrhhJHzPTkKcLy6ZAiO9ewkd0VcJCMPN
	 FXFCeizVrudeYRZ5cw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [172.16.0.229] ([159.196.52.54]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Ma20q-1uv6AU1JLQ-00YDXc; Mon, 15
 Sep 2025 23:46:54 +0200
Message-ID: <fc7da57f-5b11-4056-857c-bb16a4a20bb5@gmx.com>
Date: Tue, 16 Sep 2025 07:16:48 +0930
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Any way to ensure minimal folio size and alignment for iomap
 based direct IO?
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
 Matthew Wilcox <willy@infradead.org>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 linux-btrfs <linux-btrfs@vger.kernel.org>, linux-mm@kvack.org,
 mcgrof@kernel.org, p.raghav@samsung.com
References: <9598a140-aa45-4d73-9cd2-0c7ca6e4020a@gmx.com>
 <aMgOtdmxNoYB7_Ye@casper.infradead.org>
 <2h2azgruselzle2roez7umdh5lghtm7kkfxib26pxzsjhmcdja@x3wjdx2r6jeu>
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
In-Reply-To: <2h2azgruselzle2roez7umdh5lghtm7kkfxib26pxzsjhmcdja@x3wjdx2r6jeu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:HS/slqYo8mj0FsMnrwbDhkes0jmjlcS4YWe/yySyAg5bgJ80APy
 /143fdwi/2DaXbMa8p/N++vP56YdFS/1vNvQor7oRqYgrQS6bOlziuMVI2FikNMT5ZgQPiW
 iNUIeyD0ccIwUvm0ME9S86tsiSAyk1/QDzuS/5mos8f33rY6NJ2QpKXzCV17mfrcFDONItP
 xCzUDOFdcDir4zeQxm48g==
UI-OutboundReport: notjunk:1;M01:P0:B7K4i2eMn1A=;jjg2vMdShOT7vAVFijqVb1aW20u
 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
 aLHcI1T0YhyaZuzRR5L
X-Rspamd-Queue-Id: 062A58000B
X-Stat-Signature: cncxg53ibh6neat7j33q49c5pe6yt33j
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757972838-793069
X-HE-Meta: U2FsdGVkX1+LTRgNcKAtO9Grdh3ubOllYd0Nz72yZLS1J6FyDmZNfGk9LMppMA6ntKBBASnXCqccmVbgpb5phbsjVvmeT8HikYvd+oHwo+4xOq+laAxRVU7DrHwivZ4mHvkIAXN//O7Bk4NHP0hOdcaYRtCtqW3IWJo+24j4SXZrewk4/TxEVV3fZsfjAtp43SEGW8JdIa6mTZ1S/6nkxmv3BhyJUcHxHcBWaxIS/4eDK4Rq84jTk0UfzTfLpz3EmQNjknETq+MYZqTrF+DRD7U7JRPXkR3zxXDFqwWkdOnZF+kBPXS6hkucyrDLpwD5VZMBb7fCbSK6C93AL7JpmCqfqavu8JOQSGRQIsgLillvIGbcqZkED6BesKljcxZzGS7pi74zZU/g8m9/tvnMLLk0y/QgXC1ljxEm3WSoEn5A2XZyLvbopIda1WT7xkG/Y1+SCXTZkNIh6CArJLqoN25i7EKoroNQ3AzUA1FZ4ERGKu2VauZWw0d1IrqRsEWQr2P4MhwlVgBGqxpPOQJazQTPjXxCqSUbGkR5Wgz6RbINmVJy6BVGVeEyn/jb+3xZBkY8UzXdM8G7CatAnxwiZnmAU1H9EtGBjs5egRj3YBXynZaTqsdwkNrUpw3RmfrLsNKNHLPOdv9xfHrCdrATzt9w35BdEqlqLBrp0llTSrgGh4kcLbvBexK3BwJfLy5B333bDjz0VNmUmvSg51JD58kPozVZkiXPnX7d0meX1wsLCyXf7nEaQSRoWlQ6Rkc1Vgfc6LldmTNecKiOOfZXcjZegs6WJXA46vJyOpCbeYyUtEVhxSz723aGHk7l4ZKCVav+Zx0awiBJ4r+3xJKBnoVPfQjjlb2flM7dJnUm6jVagwTaxdR8l5x9h8OhStaNYvLhYJLOwnDbsbXdZay8DHnOFGLNQcJZ0HtuRDAMvbuVNIURePzlR8NlLyscHGz3onmMiU6yJsc3eGN3Lor
 EUd8MUDA
 wnQEcElLvnEvdPFf0UHjgLGlDGNRXyZaICKvbjePpPPt7EwZeuAE1eGjtFYoBrmrB6yc8O3VSsCK1f7i2tiPaccZt4Cuq8sNXpwjHHfB1NiWNcJMfSPGuulyVAS+P4njhf0Wf6rxBN66c9C4hFCBTHs8fvOSh3c76JE08FaXOLGhX+eqIzzMt5c4sPFjYv9VvoLWxHDWPWzXoBzGI92DD+zF2gKP55O+xK1A2PRlaBA5uRONdLYsjYXSVBLWrE3LYeTH4E8iEvb7cYssqvgXoPXl7sEpj9IdBh2YIQ4Bs5I47vcIrT08vRDpOFOeCpF0ejp0ZJHxWmpFENzYZAduIGwf4ZrchgTxc2/t+jzkW0dz5YdWZ0Sm7ksYl8+vJWMPaKgFTpadwqZ44R7KhEDmHlxGkHuTxVGGaBtiGA9QX5UIU3i2xkaT6DrSvp/YYi6XHP7oWjF4psdgqmRLQqHdIRQijzjTQ7ziqdTn/bLFt47ChfkDRSy//NUCzcQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



=E5=9C=A8 2025/9/16 03:42, Pankaj Raghav (Samsung) =E5=86=99=E9=81=93:
>>> But unfortunately I can not find any folio allocation for the direct I=
O
>>> routine except the zero_page...
>>>
>>> Any clue on the iomap part, or is the btrfs requirement incompatible w=
ith
>>> iomap in the first place?
>>
>> It's nothing to do with iomap.  We can't make the assumption that
>> userspace is using large folios for, eg, anonymous memory.  Or if
>> the memory is backed by page cache, we can't assume that the file
>> that's mmaped is on a similarly-aligned block device.
>=20
> Just to add to willy's point, XFS did not have this requirement when we
> upstreamed block size > page size support. The only thing that XFS does
> is to pad the direct I/O with zeroes if I/O was smaller than block size.
>=20
> Is it very difficult to add multi-shot checksum calls for a data block
> in btrfs? Does it break certain reliability guarantees?

I'd say it's not impossible, but still not an easy thing to do.

E.g. at data read time we need to verify the checksum. Currently we're=20
able to do the checksum for one block in one go, then advance the bio iter=
.

But with multi-shot one, we have to update the shash several times=20
before we can determine if the result is correct.

There is even compression algorithm which can not support multi-shot=20
interface, lzo.

Thankfully compression is only possible for buffered IO, so it's not=20
involved in this case.

>=20
> Another crazy idea would be to either fall back to buffered I/O if this
> condition is not met or allocate a new folio and copy the contents so th=
at
> it meets the condition of single large folio that matches the block
> size (like we do in bio_copy_user_iov() when we cannot map).

I'd prefer to reject the direct IO completely, but also fine with=20
falling back to buffered IO.

However then the problem is why the read iov_iter passes the alignment=20
check, but we still get the bio not meeting the large folio requirement?


Anyway the direction is clear (double check on the iov iter alignment),=20
and for the worst case, introduce multi-shot checksum verification code.

Thanks a lot for the help,
Qu

>=20
> --
> Pankaj


