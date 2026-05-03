Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5C79FF885A
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 04:21:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A35356B0005; Sun,  3 May 2026 00:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E60A6B008A; Sun,  3 May 2026 00:21:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FB896B008C; Sun,  3 May 2026 00:21:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7E7E86B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 00:21:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 115621A077D
	for <linux-mm@kvack.org>; Sun,  3 May 2026 04:21:23 +0000 (UTC)
X-FDA: 84724809246.04.FDC6112
Received: from smtp153-163.sina.com.cn (smtp153-163.sina.com.cn [61.135.153.163])
	by imf15.hostedemail.com (Postfix) with ESMTP id C52D6A0002
	for <linux-mm@kvack.org>; Sun,  3 May 2026 04:21:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=PvdIuwOf;
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf15.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.163 as permitted sender) smtp.mailfrom=hdanton@sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777782081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NqBpTn+bRUilCJGhIuKwvhpXbcBES7U3IIxz55lRz6M=;
	b=cCndgVFnEkaDVvZOOnUK0XT8mHmJ2p2s8i7KiMLzMs5zoAH2OZXKgNqq1chs4RW1TE6fBI
	d1+eonXgEKrnMcVF2SdFSnc85u698zCjXjyHYcampOlV9CjbHk4rUGLQfcU9ItKej+QCEJ
	divX7SF+t2qtLbGF+0ulnG1qmIHSV/U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777782081; a=rsa-sha256;
	cv=none;
	b=dZcfJ0FmlzUbTgOrPLo65FtTeK8mliP8q37Xbn6uLH/sDc1UD3uigP9WMqEht/J1G11McG
	VxoWAOPosRt3r+4zxJt+xy/vR2dET0OhMUZLgTOI88Nrr2J3Yxiu2aZkmxyQKxjPJdxr6e
	BWcTEKLrJKPKsV+61IGmK48lbUcq4Mg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=PvdIuwOf;
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf15.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.163 as permitted sender) smtp.mailfrom=hdanton@sina.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1777782079;
	bh=NqBpTn+bRUilCJGhIuKwvhpXbcBES7U3IIxz55lRz6M=;
	h=From:Subject:Date:Message-ID;
	b=PvdIuwOf8yVUTWbCOZApgsnP4VNsUE/4g5fJw7DKixwCW5anHrGwXDd56wcIPey/Q
	 Ulrg1Ddm0b6E4ry/wakzxuld/a4RcWENfB6h/4rGc+3PMqAvGFbHEQ3NIl3I5CKiBe
	 8OVyafruM46Qw0hUOuJJNPh+EyzrQlgA9quW2IT0=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.62.144])
	by sina.com (10.54.253.32) with ESMTP
	id 69F6CD1400005414; Sun, 3 May 2026 12:20:37 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 7364784456617
X-SMAIL-UIID: 3343487F9BA74A10AE68F0A8C7327C34-20260503-122037-1
From: Hillf Danton <hdanton@sina.com>
To: Vlastimil Babka <vbabka@suse.com>
Cc: Kairui Song <ryncsn@gmail.com>,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Improving MGLRU
Date: Sun,  3 May 2026 12:20:28 +0800
Message-ID: <20260503042030.279-1-hdanton@sina.com>
In-Reply-To: <83c146d2-d52f-41f3-975d-ad607a6f741c@suse.com>
References: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com> <20260502085645.262-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C52D6A0002
X-Rspamd-Server: rspam04
X-Stat-Signature: c4fmw97ityfcikgwhface6zf97hsdxpu
X-HE-Tag: 1777782078-907844
X-HE-Meta: U2FsdGVkX18CjDDj+YVNjTH4PT/eJTK1mR/Br0xMW2A90SQC+2Ytw6+8CBHoJr9E1NhxK4mvviRfTlZpkVrsSmZgqXuhV6Gyu5HaNsRQZaaOXblMamnbF4gp0FPvSqlNFZeDCNUveuolh0aO+h2GSwMZPYzCWWKoW9/VIHFxGdW5J90fuCOwClbz+oI6lnGcuM8uv+npgVO4DOoBgtbSCYKNsKfrpViht5QG3vDegY5NcluO2QvvAW/J3w0msd2+kmEr6GuYTG3NA2MnwvZni7fmyZdc2LELOTlSLz9BYFoYK7+JYRCmA7DOwmRd4Aeq6RjmO4wHLVDk9vtENU3JEZ41PAkLu3yuxXOTmZ29XXzMrM8pm/j/qJy2ijO/zIrJoEWnpVRPp8e0fwyc8i4NnqqicIl0m9N5pnGnIHm5Ewx5KNijjR++rGlzHgRVuVCd/2/OT3W/qqIuCZvLPiDXRzB7bgigC/4HBGdhfAWxNMVu7lWtnaTO2RYQtfIm0GncY5JOz19RDwcijksvDnA4c/0Jnxgljle8q1hBxDDyJu8PnqAf/QHa4ekoiltSNt+J2MDPnUpaHulgEGOEKGa5ceVEiIQ9BgZMWoZRGAA5ZwdyvQEnT1A+hWwd84wlN5Lx8KXfpnQxXV1+AG6SmvAVYVt9k9HhVqRVuzBdKMZxARmfWd7guoyABPm6IDasTS6n6vna71RKuYhk3zaz4IyilaHGzURsuPWgYR0mccpydycnGEtPRYbZudIJXqSFGIaahieBNLxcZtPNS0YmqHV+UpMkPRNeCjWMX6F1wAiT5H+ZNWCxu2iuDHSwxd98TsUriK3vsF1ENnTtHvWKCtvuwZehPAO8XGOvtdxIHMOcPRpkfTdwL282jG1WDODSvQZ8BhCsNJB484pkXzuVdUo7h77xgNqTSdpR4mXchImqrlhfnyPo056VsnaSA/QxDOIyY5IPCODJrnzQd1dvxvj
 DDPzNjFL
 TP5TVD3laeZOR28DDJcW3a2JJi4epfgMg2pEWebyyEngj0ceG4bgAnRqFstMGAynwcJyFGDfAQjDoeACgfV1QOdke3sv8qEB+ilU0Eqn+dXF2QlNr0fbiruYmsGVT/GDERrUFSK/hdBj6czy0bJiRv1ROZyT/oVfN4LnCGQaM/4hHgSoBXHkG3C02MloXLjLZVXm3aGaLfb3S8s5iEqpEsGeshoeA2wKUkPY7DtbemwZ4QEgiJupfqIPTvWRudNhyiiZNR2GZcMIWslIq/SyhwukHxy3rHYq3ue11W6sQ0kdoVKv3cIq4v2NPOQtfmzIcSvOetKI/xA/BFmart5UKNWkDhqF61VysmsKhqG/mcEtwyOc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 2 May 2026 13:53:20 +0200 Vlastimil Babka wrote:
>On 5/2/26 10:56, Hillf Danton wrote:
>> On Thu, 26 Feb 2026 15:54:22 +0000 Matthew Wilcox wrote:
>>> On Fri, Feb 20, 2026 at 01:25:33AM +0800, Kairui Song wrote:
>>> > MGLRU has been introduced in the mainline for years, but we still have two LRUs
>>> > today. There are many reasons MGLRU is still not the only LRU implementation in
>>> > the kernel.
>>> 
>>> To my mind, the biggest problem with MGLRU is that Google dumped it on us
>>> and ran away.  Commit 44958000bada claimed that it was now maintained and
>>> added three people as maintainers.  In the six months since that commit,
>>> none of those three people have any commits in mm/!  This is a shameful
>>> state of affairs.
>>> 
>>> I say rip it out.
>>> 
>> I suspect you are kidding again. Go and cut it off then we know how sharp
>> you are.
>> 
> I can't wait for the day when you finally decide to do that with your e-mail
> "contributions".
>
Frankly I will get you disappointed because I do not have so much energy to
do anything unusual like turning page to folio. That is too heavy a burdern
on the right shoulder for a non native English speaker.

