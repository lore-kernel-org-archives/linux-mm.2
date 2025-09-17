Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D840CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 21:19:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF0948E0077; Wed, 17 Sep 2025 17:19:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC7E28E006B; Wed, 17 Sep 2025 17:19:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E05848E0077; Wed, 17 Sep 2025 17:19:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D08378E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:19:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6691E13B96D
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:19:39 +0000 (UTC)
X-FDA: 83900008878.08.E83BCEB
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf19.hostedemail.com (Postfix) with ESMTP id F18B41A0007
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:19:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=CcH3wsDP;
	spf=pass (imf19.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758143977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=djRf9vFpcYD+NIrGmvtw89De7IcIWa6+q7heNKofahc=;
	b=vMIQmpn9qT1cxgDgbGepGHVfJcShdYQuMDsZog2WT3F8aVbynT60BcEsoKTkP+eOuew7t2
	gRYPIFOZzLWNof+Lbo11Aoe44vrqXH1HUa5ZDCAeW7azNj73NZlRi+mQop4EjWu0B8GL1S
	217Sh/SF5dop67cMCSSW/NwbDNIP4DA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=CcH3wsDP;
	spf=pass (imf19.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758143977; a=rsa-sha256;
	cv=none;
	b=w6DIdJX4C/FKWjpHCKveRBXubS/FqfE+MMh6X4LVM/a2KD4rOtZjB9pK5hDOFVb+EE2HAq
	VBQPllrfJsMnJvHF5xWRG2Qia9MFCYP/H9aS0EsVOBx/AyRzgDpf5AXoYjTSCtCDsyjMGO
	lVNHUyJ0hp7+P1KBV5ScXFaQzkF/C4M=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b0787fc3008so33263266b.3
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1758143975; x=1758748775; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=djRf9vFpcYD+NIrGmvtw89De7IcIWa6+q7heNKofahc=;
        b=CcH3wsDPrtroh50+bYNl36YyNeRybJO37FQknJEfLpYszM63f9eaNfJEZfYhZtgqAb
         uU9SZk75VuYbFA2xmY3Gu/a3N8VBPzUnPzSAqWDIy6bT5eBvcr81Cz6ZcIJq4SegekEH
         5YN4aqGALDL594RNKf/1n1oJXLWbX6iR0F7J+9i0KEOkJbx+tO3xJEv48uGYa8ma4Yb5
         JmeUbQ79FMm1h0//ykgFbg3AWW6ds7jD42hTNv7TOncHKjCfa3pyGyHgZ5mBK5Cdv2Go
         E1QLNFMP3RirNM17ufcwFerTmoeHlLaw5K6Kxi5AtLpg1SidYso+Ah3J3QCWBBSZTmuV
         Sn+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758143975; x=1758748775;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=djRf9vFpcYD+NIrGmvtw89De7IcIWa6+q7heNKofahc=;
        b=hPzEmjEzb9gdvhKGUjXlF0aZ9QvS4fpIKcBvOfaHlpM5WT3jDi6BucOXclHTpBOwuo
         bUYSfKIYIZCAc8mZIo5Wwni3kT122ubD1PcCDGgBWyIJnLSWf+TQW3tjOXW/arLCT4kh
         eI2Beu3Yu5s/Df1OOkE6+MwYCKYC2jcc5crhgpHLqd2u2koNhbnrWooaQiyTS9pBcB6j
         7kKip5CcKhzjdG/aZzcXXVvRI1myXv/yuEINdgzlUonZvu9th3K41iYYUepR953xx/WZ
         nGw/13nx5vdgRAc1VIKzQksymLD49D04as35DaGtxzeY/pOe1m/YpAFouZl6OGvOc7jp
         OwiA==
X-Forwarded-Encrypted: i=1; AJvYcCUktoSOTnbnmObjc5F3zBkKXNwnBoES/98eRLHhMiB0zf4u97XAtvEDfyuJQjnV/mw9sON7LZGZdA==@kvack.org
X-Gm-Message-State: AOJu0Yzxrxx0Q8XABNe9pmveDLEqcg7wEmA1RX06RrBB6PLJ+VsOZ2q/
	e1cFqMtY5OTJqqvK8EMxiewOMqlMO0k7AarCJz93CKVNRr8L9X9uRoDOA6FqHcvq5xR2iRyXlq0
	WiYfiUDu0izRYEJ2uWoFivElrkWgdR/FHjTy6MeRnug==
X-Gm-Gg: ASbGnctot9Y36gLF2EUwfTQLdObVYUZwKYXZ8f82Hib9GFR8j1q2AwKX7YFp26ucsRL
	Uhpst53UDihygyebU95+tZyrEQfL0+boPBhV+x2YAH32vAreFk897RHWry4K7RfdtRnOWPh8K/t
	/ibxx0cAVJUcJgG4Sk3gY+ACJ+1xxLfxXZqPUhix5AVHHvinODLKeF7XZh9ioS1TUzDH7IFYGV/
	ubt/OZUt/IV+JtPprHEoylk+JVNbk4vL3+yzlV85ZL6DZTxVjV9g08=
X-Google-Smtp-Source: AGHT+IFx0UdBWSFzYZQCS0rHKafbSNkZSpgCULmd3CeOoP1qT5yHjsnFa6vko92RxDrAUE/s9j8jFsO1c8h9Tuwiqu4=
X-Received: by 2002:a17:907:3f20:b0:b04:6858:13ce with SMTP id
 a640c23a62f3a-b1bbd49ad36mr433982366b.38.1758143975487; Wed, 17 Sep 2025
 14:19:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
 <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
 <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com>
 <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com>
 <20250917201408.GX39973@ZenIV> <CAGudoHFEE4nS_cWuc3xjmP=OaQSXMCg0eBrKCBHc3tf104er3A@mail.gmail.com>
 <20250917203435.GA39973@ZenIV> <CAKPOu+8wLezQY05ZLSd4P2OySe7qqE7CTHzYG6pobpt=xV--Jg@mail.gmail.com>
 <20250917211009.GE39973@ZenIV>
In-Reply-To: <20250917211009.GE39973@ZenIV>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 17 Sep 2025 23:19:23 +0200
X-Gm-Features: AS18NWBuDJyrihrXYWVEdB4-Fs__rxwIrvhTfFiInfF4MuBKEbv8_ShZGxuvgzQ
Message-ID: <CAKPOu+-yOH6yzPEw1rayR1thO0OdPYCRL-CWkRTp9YFuHuRr9A@mail.gmail.com>
Subject: Re: Need advice with iput() deadlock during writeback
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mateusz Guzik <mjguzik@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: F18B41A0007
X-Stat-Signature: 96jf4d1qt1x3k7xg8f6ycb4wr76ume6u
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758143976-304189
X-HE-Meta: U2FsdGVkX1/LUa9uMmvJKyrOWWeqvdpowbqLIAY8kg4MYN1HSNItumgbaBpFFaEbEt3/pZveGBABFcGaAIQ887KlCSHH/G15gO4QtBMwBsuPc8KtVRSiobXTnHF8dEZSSE/w+D788GR4PAAYgTp14iHaBMu3YzKeM6w5by8BJwY5E/lAjhShY9Hn1Hf9O0eex9wMY4G+jVzrgtxQ6bFdSUf2PIl0StT8x2Vd6wBh/5r02pLZQ5ex+HHCf30iOdcr+5hpoPKA0w9slHQu56gM1Sd8jK1HOYoZ/3inYn4MhPknPTMZTawjfnvMfY58TsfUtGgdjSVxMt8EuDlXAhkqfLkxhYQPpQPNXBzQzqPjIjXgEgp8u4Da1xtUdoGfjp2rcg2o/N3IozVqDVdbNmCjEtK1DWojCJwq98sjf29iI1CnFnAzlf/uI0toEJkkZ/nEq1YlfguC5JgcgMoI9cBV6vBAKJ9xKJ37jAZHvKnrGAVECF95ZeVnKE9uMOVPeUyaro2OhlhgNZEo6x8u1Da0nyzlF4PSQJJeT46qGvy9oQTy1LVp5niQchxaqowO68FUF26qkyoWKKqLyYCf/mP/zDgEwctC/WG3RPTiCfeBHy1ntcOuMENx0Sb2MbVonjYZcPBZKYN3yKMgmgdU7Q+4pZ6Oxh632shk1w3O4ZOn4BmEfZRr3BXVqYyM5rO3zRQx1JRDgYDg0ZVUQomDfXwBDL0tyNv7j57n4bmWFo0h8phIJjdGenCfdrS1loyS6BP9JeQtJRqg7gARtHFMSUjFwgOV/EOaIH/yQbOGVKr1oChAqxyyUUgXLNubviIkDvlcBT4WZ82LLHgMU8nlW05XoWDSig7EV+qmD5+mKso0pAwKcTPU51lWLlWDUn6QJ8Sd5hFGvuxKGDUW/TVbPQP8owljdNDei3UzINpvpJC6KHIYoDyAV8ZM29T4PBLWKr7eLLq4x+tdcPWhBV+Gl7K
 yRg+wOnj
 p/uyMpK8jwYs1AUjVddqJZrdtf5pcOAWhuJfbL+MsQjWtgGotbYeWwp/byhtw6c+A6vfoH3eUhN4kXiQKxvOdTUPI9j9pMQMBIzdAA6uHd5dxx9QypnkbmVck8hDoaagtIPwMHxOoTA/eX0VnCztPpuVO50sl3a6g+TaaA1ChkYdYSyQQzEc0zY23NQ7VRqPCpOvbwwt/bvh6k2XFBTQKUVp/scuETTYYw2pQlD+8bmwXWMdwGEBA4AD7SQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 11:10=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> =
wrote:
> > Each filesystem (struct ceph_fs_client) has its own inode_wq.
>
> Yes, but
>          if (llist_add(&ci->async_llist, &delayed_ceph_iput_list))
>                  schedule_delayed_work(&delayed_ceph_iput_work, 1);
> won't have anything to do with that.

Mateusz did not mention that the list must be flushed on umount, but
that's what "incomplete sketch" means.

(The patch I submitted uses inode_wq, but that's a different thread.)

