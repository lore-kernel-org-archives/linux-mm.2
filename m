Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CC5EE677E8
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 15:18:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFA2B6B008A; Mon, 22 Dec 2025 10:18:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C900B6B008C; Mon, 22 Dec 2025 10:18:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9F8E6B0092; Mon, 22 Dec 2025 10:18:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A7BC86B008A
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:18:28 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 508B41401C9
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:18:28 +0000 (UTC)
X-FDA: 84247463496.19.CE68964
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 06EB880017
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:18:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="YwK/dXwQ";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of vkuznets@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vkuznets@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766416706; a=rsa-sha256;
	cv=none;
	b=sVQCpn645sqUcXNMclpbS5NzXRxmBZCZY9uHBwcAULZNBUXH4BsXLRupgKI0Lg7YNMS4oj
	RaLxqwBQDRlu3rv318Ohk8DoJYv7iVMsIe3Q2Zi9L70A29QI/uVQPDN+4ddMuWIl6e5SyD
	SggGrjpKg4NzI7IzSIKa5ghfsXACUEQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="YwK/dXwQ";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of vkuznets@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vkuznets@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766416706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UH8Tj+hO+9Px011nIh7uooZ2jg8XcW365GrQaMUujdE=;
	b=n8pz8AxryzZ8o/KILPNc7P0BG3DZ2haUU4fF66nJruuQkQv2xUR/qeyIy3Q2j5wEpPpT/U
	AczWBjEO4mOOHbqZ3qqOsUAnvrSf7NqT/l/RBrKdYq2Xwde2lIyn8WypjquiF/zyLGfy53
	WXIX0rBuhF+Sw1DqrIAhxs26F5KfgAY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766416705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UH8Tj+hO+9Px011nIh7uooZ2jg8XcW365GrQaMUujdE=;
	b=YwK/dXwQrPfI6nC60oxxzKbM4eB2jp1LWCRwjQxQB+Rt9cn2IEOHvfirVgtyqjr+FxnB1O
	tjjXvsTwc2hVTi/or9BUKTNljdAnwm/nVrVg83d8ckAJeW3Dksi76AB3fi8yIXBDunutC+
	hTW71nDJx6hYPmQGFl8SkNBsKSedhtc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-198-Vwgn8k2XOgiePjnghCfo6A-1; Mon, 22 Dec 2025 10:18:24 -0500
X-MC-Unique: Vwgn8k2XOgiePjnghCfo6A-1
X-Mimecast-MFC-AGG-ID: Vwgn8k2XOgiePjnghCfo6A_1766416703
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-477563a0c75so22236495e9.1
        for <linux-mm@kvack.org>; Mon, 22 Dec 2025 07:18:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766416703; x=1767021503;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UH8Tj+hO+9Px011nIh7uooZ2jg8XcW365GrQaMUujdE=;
        b=SASUfYLP8h9olrT0AKe+0IeLo7m015FPiLd07yX5iurVwYdqG9jL86bT3q8WtfSBae
         5ABpeL40tbmrWIKRBi7GdbcRx2MVXx0tgkw3PIfoTfu1rA8QtbSSwNYBEcqfImFfaiP3
         6QQjuBtt5s7bcDEOijvpvzPihhJhXwTiyGiJBYe7zs0jrpjNsQLiXWA7iLJOG9gXeaNZ
         H1EvEJnpBLx92P7NI+E5hSqvKbB/Vtd7I+EhbnaWJ/qJDKbEHBsK7x9k7PgkvxPgCE7X
         stAlfgU1p1YTa4Kw6aC7n5PqCY6TTKbdLxVp0GrL7TIWuXjdYXhe1n/aRSyoPkcTXzvF
         igHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxVu1mmFd4qfc3F1hQXDwjd86YfUNcnJwJKJD/BG/6pVC4F8ygzJ/Fcg7GyLNhD7Oru5Tk1b5UAQ==@kvack.org
X-Gm-Message-State: AOJu0YxLocOQwn3V2ErmdYtXAzhxCDtWeD7g31SyLG/kq3P2fOei6b6j
	wQt9HdmwX7BRBtYucWJmoLEN6de4aR6mRta4mBOq9kJGdq9LP/xriVJY6YrYT2OP+4iRy6r7KP9
	JmeSRyE/h/tc91ccZrD8MtyLjnIyTsb7K6Ug6FVWJcldc+Wch/QuZEZfamUC5
X-Gm-Gg: AY/fxX4q/W5TLOHXTSxkWGV/bjjWks2oL90RcvngaJ9geT4hw1DnfgjCIb8go9bN8zB
	mes4wCGrt5tU+WugH8WZZvHeJXA/vaK5bMAa4xpHIKuyaeUWPqf24HniR9BrNuoeXBWoKZnwIFB
	YAnO+4iqxatF0mWINaPvyaXfVNk9DQIX+hriTFOXKQf0+3yY/G0vRcZLUti2ZFPpZ5sxe/zbmSv
	IFzSToicasIAv+pBf1FRU/BnchyX6EmFXFpKhR6Gsv6hr2DqTiBtn97ZkIallJc0IWzJHF2gSRW
	9ZNjxlRzkbV9cksrHI8unTwfzlPD558aU4rzvsQ8C2TlKk7XRZqBqH437X8BBysuIsQktVEPeXP
	YjIlJ6Q==
X-Received: by 2002:a05:600c:b99:b0:479:3a86:dc1c with SMTP id 5b1f17b1804b1-47d195a6369mr121974435e9.36.1766416702810;
        Mon, 22 Dec 2025 07:18:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHr7kRWLmF77zObXmR81gcalju2xmUT6oHsISYvyqaDxwFu7HCMtpj/4EWck79NTdJ+UCUdBA==
X-Received: by 2002:a05:600c:b99:b0:479:3a86:dc1c with SMTP id 5b1f17b1804b1-47d195a6369mr121974055e9.36.1766416702432;
        Mon, 22 Dec 2025 07:18:22 -0800 (PST)
Received: from fedora (g3.ign.cz. [91.219.240.17])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d193cbc0bsm195443905e9.11.2025.12.22.07.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 07:18:22 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Ingo Molnar <mingo@kernel.org>, Kiryl
 Shutsemau <kas@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Pradipta Banerjee <prbanerj@redhat.com>, Frank Liang
 <xiliang@redhat.com>, Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH] vmgenid: Remap memory as decrypted
In-Reply-To: <CAHmME9o1oJXjt4=5qqGDdBbiK75dvea_e=Z4ceStmk=Z5AYgjQ@mail.gmail.com>
References: <20251222144646.1426256-1-vkuznets@redhat.com>
 <CAHmME9o1oJXjt4=5qqGDdBbiK75dvea_e=Z4ceStmk=Z5AYgjQ@mail.gmail.com>
Date: Mon, 22 Dec 2025 16:18:20 +0100
Message-ID: <87jyye35qb.fsf@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: AeWMDGBXLJ29TGpY5KNf_ohQFnlJL80gTawrCyG-Ils_1766416703
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 06EB880017
X-Stat-Signature: 5zufpk5t7e9tmz8pea31fptqw6dp74gg
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766416705-224714
X-HE-Meta: U2FsdGVkX188jK6CgowPvrYLqtyxMt6wbh/TcxfgYRQTGNpBpekqSvxFCwxIeqkqSAMcoV3S6TpXR/IaMDCJovgIM0XKzqHje7DwYrLSuMyQBaljVvuaINbu3LXK+2HROvQoP6gc3koGb56Nr1yTRNUk27lkiTd74quHA7n58YpgL9bTX3Vi4WdElVEp0xjMX4eT7XTjDhuwJU1mNjY944VnFQuxZLzCOPO2Wnoqj2p+IPA4woBpB6NMIbssY4xFGGMABoUZdj+tEjg82NnLLurlizvJXKNWZ2fJlBU6fQsqLvjTsfSwFDPJKgKrLRWkhfUjPJF9bm7oWzxLHD016BiLYdA0cU9Lx+UR5uthPDbmCC9wryqfEm6PIznTEiKKYT3rIN6/7/IeWBVq3Qkg9C5lmn9Wni1cLwugtiwBYen/eyfCPofNMjimtuiUWDh/qfSGPufgDmgYaD1bIlcQPoes1Z0TjFHHJP1KXKUFalnxBbl6xDMv4xe5ZSZIU42oRsyRlCDxowuYle5rn0MTGd//u4dogZ/CP/cf+2GMXl2os0bRO+sYQ5qDmJYFrMjz3MRtqgd/NerRj28H2UrutSCZwRC32yuXW59NJGC83eVg52B4WKSBHCKcNO41PKSP5C3LUl+DNx+5tCwJT1IOkAuAf/jJ3CZ1wbJb2Ep8I0rewrH+dTGLSEQQQBVarOMR/e3bpH1P+J7FBgmqaYsgsfOpQ8zJVKIoB9ppfqQY4TYT+dvwGnZ3p+fPyg4ettoLV6BvAB03ECWs48NoVxHrU54U0EWdmeDdBFQU+1ueqacxp8kix6yTJz9YooYfGV0DF7nq1atrVHB4E4GQNRLxN1TxC5fMtYV8htfsxo+Oq78uoCCMClZNoSm8FusCPdYYg4cAIjRhUYnQyY7/64l/hsGieg8kwlpc1IZ0QaVimzJiASzj+YPeUeuLDwhHrj1wIdG06CSoFp6KGZPg+C1
 8TufsQEz
 fNmWWXBLGjiETVCmMAUR8e/bdwuGv6q2G7DFhly4aJS4muEbnnpPknGO8spJByIqay5SdQLBYEJlGlMsCp5f6SQm/L3uq05WiyhyvuYsxmMH6S6aurTdGAVNMdmoRCDlN/Bv4BvJHsyBB3h0WmVH+SXbwgY9PLc0WHKEV/GKXibcbI96xq23GPsB9zGelApIdCDuM/KF9qcRT9iWj/Tvzrc76iOqnSVaDwvcEEdrlaViN02HxySvyyZt5EqyemXL3sMBn+sApY6K2y/TeXQrWvAO1PVtjbz2VVqsaaAswgrW7n7hRgwWoS2M6GLDpwTdcA+Q9S0c3X47KpK+4ZB+7z17Jl2D+DtjNeZNvQySGQNDYwY+iHCf6gJWhPq8Ij37urcTv9j8UjPdJ+0EADfAk/Zr8DPWLe7zu8ezUCsR0qCN47PxjMHR/dp2bQPWJOLCL6qJctPpZwvFhYpe3WS7dDmJ+SKE1z58Q/mzqAXwT/EgKcsU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> Hi Vitaly,
>
> On Mon, Dec 22, 2025 at 3:46=E2=80=AFPM Vitaly Kuznetsov <vkuznets@redhat=
.com> wrote:
>> -       virt_addr =3D devm_memremap(&device->dev, phys_addr, VMGENID_SIZ=
E, MEMREMAP_WB);
>> +       virt_addr =3D devm_memremap(&device->dev, phys_addr, VMGENID_SIZ=
E,
>> +                                 MEMREMAP_WB | MEMREMAP_DEC);
>
> Thanks for this patch. I still need to do a bit of my own testing with
> it, but I've preliminarily applied it to the random.git tree:
> https://git.kernel.org/pub/scm/linux/kernel/git/crng/random.git/commit/?i=
d=3D9476583268980ce64ed75f124768fe3bff6fff4c
>
> Should this patch CC stable@, by the way?
>

I'm not sure how common the configuration (SEV-SNP/(TDX?) + vmgenid) is
but I guess AWS SEV-SNP config is significant enough to justify stable@
as all kernels 6.15+ don't boot there at all.

--=20
Vitaly


