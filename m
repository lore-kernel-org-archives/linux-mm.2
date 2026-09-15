Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF6BFC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:21:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E61D96B00B0; Tue, 15 Sep 2026 08:21:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E39136B00B1; Tue, 15 Sep 2026 08:21:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D75F46B00B2; Tue, 15 Sep 2026 08:21:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BDBF26B00B0
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:21:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 54D70C03E6
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:21:11 +0000 (UTC)
X-FDA: 85215906342.27.1AAC663
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id B54B640010
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:21:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gObKfAKF;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789474869;
	b=SRbj22ECw2CyrMHYw4sg9BRFgYJIrCEgHi1TqCWG/8i3MV9GLlDa4bAMU9XZ13u1vCDMJI
	thJk/L3daVxRBwEEeQBfeysFfXM+kBQATO2eZToroIHHNJzB9jtz7ShsMaooe8GNJ7BF32
	YRf2+knx6gXu7iXftgSJXvKS2+SUifE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gObKfAKF;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789474869;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zfyJBviruOrXl2JCvdG1FvDmNuy7BpjW1g6Twwn8tGo=;
	b=DfAnB4qbMueF9IyaTZk8yH5eYS4MKCQST9Enjoo1Qlz39V2biG0VGHN/Ily2pWO/hCN/nA
	99RphaXy35+CiauXrz5EiKwjMicF35/4/MudxdJpjva2dCdJSXtPwq1ZxMrTUfUMlrwV9p
	pd6AmNY+36O19+2Z/dhpSAHyRMaReqw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 120A04381D;
	Tue, 15 Sep 2026 12:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373A11F00893;
	Tue, 15 Sep 2026 12:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789474869;
	bh=zfyJBviruOrXl2JCvdG1FvDmNuy7BpjW1g6Twwn8tGo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gObKfAKFXTY0hrJS7QZn4qiNIiTIRIBlMSNnER3mXV89dBb57+qlUdDcC7JXNusYj
	 DN3AV6iDTkMMLCKiEUO0tLOW3BC8L8HfDFUz39G5Pai9HhjjNkui+WJehHBvCAlYI6
	 l1+furIrRu5FFpirKDF9oXFfJBGjua8Iyd0PslloNxEu3qlU5WfgMOvXrxDBbQLMUU
	 Hqf4H4ziX5u2zvxCwKkGT4L9W/w3y3hNNkeb0JCCYiu0nrv5MgfHg4dM1guzvKexB6
	 ypTSTOfhsabV+KeBEgLsJEWgU6XLC9cNbo4Q/j9aFrVeLGZ92YWgG0nY7ceyp4UFja
	 rQpYWXr+PJ5lQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 49/50] iommufd: stop putting descriptors back on
 failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: linux-openrisc@vger.kernel.org, virtualization@lists.linux.dev, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, io-uring@vger.kernel.org, linux-csky@vger.kernel.org, kvm@vger.kernel.org, linux-sh@vger.kernel.org, "David
 Airlie" <airlied@redhat.com>, "Ingo Molnar" <mingo@redhat.com>, "Jann Horn" <jannh@google.com>, linux-kernel@vger.kernel.org, "Peter
 Zijlstra" <peterz@infradead.org>, linux-mm@kvack.org, bpf@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-mips@vger.kernel.org, sparclinux@vger.kernel.org, "Eugenio
 Perez" <eperezma@redhat.com>, linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org, linux-hexagon@vger.kernel.org, linux-parisc@vger.kernel.org, "Jens
 Axboe" <axboe@kernel.dk>, =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxl?=
 =?utf-8?b?KQ==?= <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, linux-m68k@lists.linux-m68k.org, linux-um@lists.infradead.org, "Oleg
 Nesterov" <oleg@redhat.com>, linux-snps-arc@lists.infradead.org, linux-hyperv@vger.kernel.org, "Michael
 S. Tsirkin" <mst@redhat.com>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-49-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-49-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:21:06 +0000
Message-Id: <20260915122107.373A11F00893@smtp.kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B54B640010
X-Rspam-User: 
X-Stat-Signature: phw71rin76tmrjtmgtj4fjx9cc1aqx6o
X-HE-Tag: 1789474869-288636
X-HE-Meta: U2FsdGVkX19yO/igVWqN4dq/eomaHDXL/0+agGHYxFRRaQR6F0N4/8JWcQYxIs22WVrGB82qiTfwthyCsDSxC6nLNCTgV25TxxEydm6WaZ+f5B1I9TrVJwoqPpsojZ2Ngi0thBZ/FLdGKdyMdFXs8RKjbxrhxzwyiHeyOd5OT2SuIgEhMDNtrHZgMrQGDCZ4PeegWOi3gpujEnL/06lx2mbjKr3WS0MQ9qPNK0qADf/soUdzS79qW3QU0rQluPLQf9ZwIEL0xu2G/p+ybT1sAR9ZkTY6jMbZ/Pl1nX0u++zHaJj3ZF5U/XXeL1ud//+iSI4/nUlBTklrAYMcOx4X+a+1q+982MQUMjqlrlzAtt2o6Fmep/f5qKT7FwYrB1CCjfp0d2FTUrlaY3UfynMYh8M+T9617pF3bqBcGhCpAV3kQOJdD/RDBUw5fpWfD6HBgwgIPWegEAXq17cYQbGTwjF4NfRAwim7OdzneI6ri0QfIGbeLA8/sSoSrTJVckjdT/0SSefFEnVWR1K+rZunJ0xAMkROduCoDCfGnM398JoqdoPuMxKMbVxGuyzkCluGda10LHAEX8zcpFIWiay0M8UWKqFtyL4u7dUsT9dR63AR7wCoH7M2r4lzvUqnjcY2njBfSb0/boPQYTG5uVvUFU1xogpL16MijD8WnZe6OqpasJBm6FMeT0fv69cciNhmjeYmNqAC3iDr2uXXXap5PyR6vO3CMD+ZDdEBAmo9b2NcmDTC8qmxzsMcEBIaIp3nbhtWnLBuMRq9JCPkgzYpanN7OmA/Sn2IyaRKefmPk3qlsqM9VSbTbwK6Spk4XZTaXXEnLh0wtqC9dxmD6EYryz/rMftjJEfx0Rdlpd6sPlFoqtS3pSqtpDjJ9pXH0YqfFPjr9ygqUBI7ldJdawpfpEL9+7iK7Ggcd3luiJLmiLD3f8XczGkCTrvzpCtmILJo1uadeHY0HldhTDhfqDX
 GIO/Ep6p
 TbrqePm2aWLoVq68nWRUZ5s+4WLwu5iRO+JFnYcecTh9iw+n7E62p7nfvInTSTgq0Iy/FrGVNuGIBBckxuVMeQJn9fK+/eayxeBjvsZ+Izguj5eCuXbdL9aEUOK9R33/59E+E+E0Y8YPkjrFimtPMZzFNyOClrKAX3ZU9cZHsxJf2G+6ZqXAjfTAC6so3l+5Vis41zwTkYCSEW7TrGIGGxnBJEkJZYlO6D9hw/zc74EGnTmPMIH5izfacQKsO2lrPR2uOUwUr56NYkrGOZxzpO04FiUNbbXCPZbDDP4IWV2Wgc8PaGMqeJX2pGMsP7C/5HXF1i9AClGooAKbpCs2rqs6JJb4aZzDgfsNOQUUAImAhVZEfJzzaGV0Jbomt5GGoflfnUw8hePl1W9Cr6jle2Gksv9HYB9jLUTQ700ye17t8ZQLxoBNpAhh4v/MLrC5Xe7CGD5JDhnQXw8IJj/9gzkpQRd+vvxr+rY0IDCylgzPnuT65m0+amYpgNb8ttII6whOL7PYJKSNB0Rx6RVZZDxZOHRO1gsssfy+VTHMgkR535v1cj5KUlW4R9KBw8cTchWadEp8tOUNW9xnrkonDCoMuvAxOLQjNabwbSUFmfU18zgYpcdbk/aFTN6HkSD41ug0FKEc0cEzLsA+wKafYeiLHnT4/IiLTKgvKBbzsy2r4aZpFgKEx+kfCmd7C/UwyWKQi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Rely on the fd exit path machinery.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D49


