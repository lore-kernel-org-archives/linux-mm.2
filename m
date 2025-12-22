Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07670E674B8
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 14:53:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C9806B008A; Mon, 22 Dec 2025 09:53:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 680166B008C; Mon, 22 Dec 2025 09:53:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59FD06B0092; Mon, 22 Dec 2025 09:53:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4BA956B008A
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 09:53:33 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E12B6B6A42
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:53:32 +0000 (UTC)
X-FDA: 84247400664.17.1A3F504
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3728340007
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:53:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=zx2c4.com header.s=20210105 header.b=SZjCoDiq;
	dmarc=pass (policy=quarantine) header.from=zx2c4.com;
	spf=pass (imf17.hostedemail.com: domain of "SRS0=JxEM=64=zx2c4.com=Jason@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=JxEM=64=zx2c4.com=Jason@kernel.org"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766415210; a=rsa-sha256;
	cv=none;
	b=eJgbX5oGPVFY2qM3YUo6c48M+oFJzB8NsB/lhKDrNr5aYKCB41lXdI8oiRCD4uuMzVrq57
	4brjT09MUNBDfVHTEWAr4iS1WqX2tdzXrSxxC0pqHvqdF5vN8sp/TemFpiWgUD+X3RRV2a
	uZXz0yRlODHI2aDqCUPU6K2zxFb0FN0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=zx2c4.com header.s=20210105 header.b=SZjCoDiq;
	dmarc=pass (policy=quarantine) header.from=zx2c4.com;
	spf=pass (imf17.hostedemail.com: domain of "SRS0=JxEM=64=zx2c4.com=Jason@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=JxEM=64=zx2c4.com=Jason@kernel.org"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766415210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T9lSiBEy5UB1MaNtZHcgE0XwHOzo0d/saNHBe5IPouw=;
	b=JObbNSLKqAq9IJv/SKeQPDYOYxjVuXe3bQfHSo2EjUoXF9tBAUKTMbbk4iicf40S2KkXXB
	DszXRRrFLbFsH0wQEaFjObWdo73KrSKN0VxqO5NfpApscHEoqn8aNHq7DLnnL5HtmfzS+0
	ifG7ByTSV0yTVwamR5Dz1TGG2CdpAoo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3BEFB4178E
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D68C7C113D0
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1766415205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T9lSiBEy5UB1MaNtZHcgE0XwHOzo0d/saNHBe5IPouw=;
	b=SZjCoDiqZhXbVAcMdO5HGgMDDeQ1TDqi24TX3HnDJ3T+Di/Pvp1kfxhhuup9lMrSURA6n9
	eDzJ1Ul4uHn+E0rO514Xo/tTARL6TrBcE6ps5gnACh/cfRhay6DRWdwDmxqpB3LWwTplYv
	3mrX2NbQ/IIASxsR7V7KEaS7qFAhwSc=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 23b24ffc (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
	for <linux-mm@kvack.org>;
	Mon, 22 Dec 2025 14:53:25 +0000 (UTC)
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-450063be247so1730073b6e.2
        for <linux-mm@kvack.org>; Mon, 22 Dec 2025 06:53:25 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUMrA+MjqQbuu4NiGMF6KF9HgNiEZud9IvGVLTn0DoFuf8ANO922ZgI56ZuCN2qBG/KRC0BWWw0Lg==@kvack.org
X-Gm-Message-State: AOJu0Yz91s2K7826BF2AocjptVk2PS6scJ9ApiSzUm9AflX8HejqQth7
	+0J6o+ZyDg2W6geF+bOMKZmu+uJfofEgBP5hsWHpeii9nMmFEF3Z5aBoYT55M6WMJjVLOnweQNb
	7esw7KotIPMW7euhSanBJZbiEOZIetWE=
X-Google-Smtp-Source: AGHT+IFTf2XKWBRY63AeXvVokgJ+ixlCXnNao1q68M88Rc2Dj1xw+5JkGcVC5O5axXCpWJHRwm3Wo8JNrRzcDU7JokA=
X-Received: by 2002:a05:6808:444c:b0:450:275c:8803 with SMTP id
 5614622812f47-457b208d257mr4977048b6e.28.1766415203846; Mon, 22 Dec 2025
 06:53:23 -0800 (PST)
MIME-Version: 1.0
References: <20251222144646.1426256-1-vkuznets@redhat.com>
In-Reply-To: <20251222144646.1426256-1-vkuznets@redhat.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 22 Dec 2025 15:53:14 +0100
X-Gmail-Original-Message-ID: <CAHmME9o1oJXjt4=5qqGDdBbiK75dvea_e=Z4ceStmk=Z5AYgjQ@mail.gmail.com>
X-Gm-Features: AQt7F2pMAqGmvIaa01CtlxkkuAmrjURhKxCm1srntPWQEULez3FFB8tJCeMRdu0
Message-ID: <CAHmME9o1oJXjt4=5qqGDdBbiK75dvea_e=Z4ceStmk=Z5AYgjQ@mail.gmail.com>
Subject: Re: [PATCH] vmgenid: Remap memory as decrypted
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Ingo Molnar <mingo@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Pradipta Banerjee <prbanerj@redhat.com>, Frank Liang <xiliang@redhat.com>, 
	Alexander Graf <graf@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 3728340007
X-Rspamd-Server: rspam10
X-Stat-Signature: wbcgeja8b3ubc3t1yg1z61a3osu858sp
X-HE-Tag: 1766415209-680099
X-HE-Meta: U2FsdGVkX1/rxDtdRcQvjtpZ68pmg6d8q2/nCx2ncIAuZKBOcY8HhCk+SW/XDOEZPOhO9OWXSi70ZDfjN34Iab5Er8WJliHo1WIVcAVkah0F4Lf7D/cP6P272YUX2l/tvOgcMR8nifYqTf70qZ9Vg8eoV8YzSltdpHHEjCo5jZVc+cwLnPjz8+defuAWpp9vkBnykj80PWtCyjKmAex5QojSJUolhQKq1g6lEPXrMWGIwlbUJYp7YlEjUvvfPEw/HJbaROBmROLpGxr1H6fp8aXGE9X8vSMaTvLiyBVWtXPl/dCDHXOA+cT1HEeA5DeZUL4nVawddlynwgPlZ8ozzsE+V3WOMLC3pFzCauuLHc+VlMJPO2gWFeTOzUFPWtxrACyB8E4toRqqmQaDq5r9vnSTWXvxZQ6TtTkKN/NZWRzcPFT/X1rm3YQ31Z8sAO3lZgFG+xtFUB9mGNXhRyqxt/HFDWrZdhxXkrnwtIwNhYNekmoSMGaEE/LbrgScGXOVbs4elRX5IQOoTgU4aSKnMvemftiU3F6IIDx5Phbsf6ttgj7Fx02oLSf27ChHKbpMox9g+tnjY3h2vGRtoJtXzqlt+jOo0G9+gZj+SD0kgLnsm7tQhL9sdhhT2J9VNCjO85JCilCZEzPU2tvFoI7i1X77MsCrnAUa/F+/2jCKL9W+zi+4aXBlpaj4UupBnrTFFLG7/dbcgxr1xsC4mHtc6B4hGxJJEjkr6domdXKF0NtMVER+6PDZ0rt/lxMfiHT/kx8slPp0fjL8eC6LuLK4hVA38KXiWU1lw7rQyGBh91A+nr/14gXcBYUEu6o9RHU0fW6xaOqsvllWl0z2O5HnTwgp2LmgV/KwHPV7HrsA2dYF73S8Q8F3/8Nj7XGQGxJSI5ve6oq2vCADsvQcZDtpTbfhafvCtJmWxAbJAAbSqBNGxXR0p6pRI4+Kb7kroC/YOokMnWYIR+uBOv3BoXC
 rNjIcJfq
 zMwaIAIQGBzh/3MhPE7+YRGNHI/0tRzqvr1nGCAGFOtBEhOh6Kx2828JsnHY01TYADb+A/xiJ6wgFlVYHP9aOymuTu2JjH7xafamljM8FK1OIp+ytt86gAoUwnR0N78jAdPPTrn6KdYq/+Pc+b1vl2w4Lx/RZiuMPxF3fo3qQVNIFFwRM2iUkU/fLoScyHCbNSJOEtAZnDwLru+CqWsZIp8B4qBCktk5rKZl2lNOyC6iG/7FYTeBx0LJmX3HEiwfAJz9Cr+hRBUXw3XCZOfXUPvVhn/kTETtmcOztI1L9Du0oMlFhKNKB2GFUasH9I0g+2iEe0cmuDzU3bF1AAjRdYPWWLZ1FNiDB9yGmytqOd959cs+P+jpOGtPC2VtdAPHAni3NizRCsuHvtdYaYJxDVglRk3K45bnNaH4mL5cXMjPMerr3Pu5m/Tn8OH/fY++lWdHM66h4hTbKqo3FoMrWKz8sK4z4jNde1g5Pex2LG9MOZy2voX/UebyHTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vitaly,

On Mon, Dec 22, 2025 at 3:46=E2=80=AFPM Vitaly Kuznetsov <vkuznets@redhat.c=
om> wrote:
> -       virt_addr =3D devm_memremap(&device->dev, phys_addr, VMGENID_SIZE=
, MEMREMAP_WB);
> +       virt_addr =3D devm_memremap(&device->dev, phys_addr, VMGENID_SIZE=
,
> +                                 MEMREMAP_WB | MEMREMAP_DEC);

Thanks for this patch. I still need to do a bit of my own testing with
it, but I've preliminarily applied it to the random.git tree:
https://git.kernel.org/pub/scm/linux/kernel/git/crng/random.git/commit/?id=
=3D9476583268980ce64ed75f124768fe3bff6fff4c

Should this patch CC stable@, by the way?

Regards,
Jason

