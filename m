Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EE7EE9A048
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 14:53:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 113756B0005; Thu, 19 Feb 2026 09:53:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 097096B0089; Thu, 19 Feb 2026 09:53:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED7DC6B008A; Thu, 19 Feb 2026 09:53:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D5E426B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 09:53:36 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4FBC21B5745
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 14:53:36 +0000 (UTC)
X-FDA: 84461500032.26.CB7F228
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8E309180009
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 14:53:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=33m25o9O;
	dmarc=pass (policy=reject) header.from=acm.org;
	spf=pass (imf06.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.14 as permitted sender) smtp.mailfrom=bvanassche@acm.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771512814; a=rsa-sha256;
	cv=none;
	b=qCdgLRcgZf8WxPMdr3gHWeHs7zy4zKRkevJKJ+EmeT2IrWu/9Rb1zMI/C6LK2vdOEsyVU2
	H+17A2mY2Fy4ip0C7RRJCUAP3n8pckFo0yLYGPwUuNCaYvlF+SHIHK6aO1g88+XYiq06Eq
	KpWujqVFdZ6mZdryqoJcrdicKs0LJYE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=33m25o9O;
	dmarc=pass (policy=reject) header.from=acm.org;
	spf=pass (imf06.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.14 as permitted sender) smtp.mailfrom=bvanassche@acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771512814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hunk2Dv1mebPSEeGUspQczD42feWNf6sRslRoqaD9x4=;
	b=7+kxDmvm8Qkg8akSJ9vTmg9JiDFjrTQYXRVuXafYdQk4DYGvSh3Eu3Pb/+fepjnyW6b1Iv
	SYYSDCiAYtZZGhdHAxfsn1d4O4plBZf5aTSxAtM2hggPyoKU1ZQsWqswCjEuBb8llaeNRQ
	Z3s1iyMy8JicWpLOWNJHvjKvk+ugZfU=
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fGxG53hkfz1XM0nn;
	Thu, 19 Feb 2026 14:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1771512812; x=1774104813; bh=Hunk2Dv1mebPSEeGUspQczD4
	2feWNf6sRslRoqaD9x4=; b=33m25o9OsFO5l3zjvISU1ttAkoFEsdWWD7CgzOx6
	fC4HehvWZSOk3tjy5SD4cMAU8Lt99d8I/f5YC8NmHFO8wz+m75fWLW3TX/tXiN9y
	PPKSBfZmsgmnTuQPOzARa1MGLiCP71c7dT72r5OxKVSYB2UtapBdyfaSqpTvUTaC
	sjaMkrANYElMsbMEIlliiDx/T6lUR5hk6hSlvLoBLSldrGFiTLaV0Af4mfqt6Fe0
	D7AN6/3OzTpCgoCufHH3hLRO1rasGIPT5ndOrNaqobxHy7Pp2mifDFeWHXRVCPke
	gM81OQAepWn2NKRQH5OBSsD/lJyVQFA4vn/TP8BMvtyaNA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id yijDWlHsKgO7; Thu, 19 Feb 2026 14:53:32 +0000 (UTC)
Received: from [10.237.57.149] (173-255-98-114.utilitytelephone.net [173.255.98.114])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fGxG232syz1XM6JF;
	Thu, 19 Feb 2026 14:53:30 +0000 (UTC)
Message-ID: <e2733d9f-823d-433b-9bfd-24df20b98b7d@acm.org>
Date: Thu, 19 Feb 2026 06:53:28 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Memory fragmentation with large block sizes
To: Hannes Reinecke <hare@suse.de>, lsf-pc
 <lsf-pc@lists.linux-foundation.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 linux-mm@kvack.org
References: <f22caf98-1375-493a-a275-0500ffac3e81@suse.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f22caf98-1375-493a-a275-0500ffac3e81@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: w1t8wcm3nu97s33jjrnhjm8mgqpwutuq
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8E309180009
X-HE-Tag: 1771512814-338204
X-HE-Meta: U2FsdGVkX1/mpZgt49KRuZs2VxUH0qsAnspli5E5RuoLdFGjlGVnEq9OchxZoHsAXH1OEIVKGG+T0DyRIgKxpCvt58jRsBGvzxKKrdUShSNfEFTxbQdf3AstvDrY57KYO+x94QjfnxqFoVS9OW0+o1JixO8vEDHW6XZLLehaYukvGLhkXL0CDLq9LBlbAMulRPAYgrk7OzGEGRAwm9N3jCS5IjL1+KJ00k4rmaZuwQpVvZ+2goHfsqNXqdm7eeXX5FeplAphtNb5FLv7pxwmXmOVUoqksILr68238bTP/t+esQXNcSW1x5Dgw96zPhv+oRO3gRmU94Kn0Qz1joacRiAzPPMwgawk1Gpl5HpEjTZbp6E0LTHlC2g/WiXFFa2nuzk3JThB/MpZYXA0f6pQTbzSwslntZ3Ah39KxLkMIt7h9XCWwQpFi/fx/JHLvYV0JjlpdLNrJ5yG3mCJCnW2NQhkCfci+UFjr9lgiwn5Wr5DjPe3EN+d/6gyu+krZuLg1ZrOEEm9CkCzbDTT3/1v6KoqMYxzOuHMWaluS0YXiD3gHaDO5X/MtaBiDse7jdlIwl7ii2fWvkQ0HzZwoNC+VNSyiCdbsQSAf8E1+kITedz71YaJcPjNzAYvw7A4UdQ7mLWQSFrkx+doUIAZ/bTons3d5Pun16L40KSy3VhBBKuXXn4fQ00MW6FJGHbGBW+4VvAVJT3cPy+Lkn8SI4dkz8PzcH6GylhL8Sr1r7w+4RDbzM3lhn7K436q1At+TvIjq9VBmZjfrc2v0JArn1kZXNQbAjk4LT/z6Mb0FXzRVwUiYhz5urcteVLETygAOUrOo7aICny6GLi5O8fH00MoNZi+v6Sh3H5oE/dQrmF2VETLwCLfEKjRmAEkofPGcsNxrrB8doJ4gpHxnm5WkhhLhM0FFoPPRoKUZYndC5gVRNBjDqvqoZsVLTNjQt31IX4SsfvOJIQw9fHVkq3N9gL
 Y7kcYHMH
 ctOc2Xciqz1v5CqR2Pn/yGM38Yg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/19/26 1:54 AM, Hannes Reinecke wrote:
> I (together with the Czech Technical University) did some experiments=20
> trying to measure memory fragmentation with large block sizes.
> Testbed used was an nvme setup talking to a nvmet storage over
> the network.
>=20
> Doing so raised some challenges:
>=20
> - How do you _generate_ memory fragmentation? The MM subsystem is
>  =C2=A0 precisely geared up to avoid it, so you would need to come up
>  =C2=A0 with some idea how to defeat it. With the help from Willy I man=
aged
>  =C2=A0 to come up with something, but I really would like to discuss
>  =C2=A0 what would be the best option here.
> - What is acceptable memory fragmentation? Are we good enough if the
>  =C2=A0 measured fragmentation does not grow during the test runs?
> - Do we have better visibility into memory fragmentation other than
>  =C2=A0 just reading /proc/buddyinfo?

The larger the block size, the higher the write amplification (WAF),
isn't it? Why to increase the block size since there is a solution
available that doesn't increase WAF, namely zoned storage?

Additionally, why is contiguous memory required for block sizes
larger than the page size? Does this perhaps come from the VFS layer?
If so, is this something that can be fixed?

Thanks,

Bart.

