Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26285E63F2D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 06:21:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D4EE6B0005; Mon, 16 Feb 2026 01:21:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ACC06B0088; Mon, 16 Feb 2026 01:21:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D9756B0089; Mon, 16 Feb 2026 01:21:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1AD176B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 01:21:32 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2779C3CA5
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 06:21:21 +0000 (UTC)
X-FDA: 84449322762.08.99B8D89
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id BC40E40008
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 06:21:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WUgi46UG;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771222879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+B3VYFqqOtn4OFDnrRnwc7y2rxPOL/UksRHhaZ3LZ4U=;
	b=sLbHcHiVNjmp88U7L/u9J+lazgXHmxX9K908TFngmQduAequv4xYJbsACoTi5jBl8Gs63x
	ELvEXPgVwank64QZNgyHt/roGTsJVawaC2HCs8xt124A5sTf+zVsD3oAhSlt8ZONpT7CNq
	gz/FpCHNf/Egm4MwRTQDtbF5sDaklkQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WUgi46UG;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771222879; a=rsa-sha256;
	cv=none;
	b=5QWfPICB5vRFZKOGWb7TrfxV0gvGNKyIHsbcswbBmymq5NjFLXi+gUNqgI34ZQ3Plpq36i
	dMMtbRvm7yYKMQamdx9lMI80BTpNYj/TAiAInkRQrsukUZtFflPHO2XTYAEIjMi/I1YNy4
	E1Tp9IqXlbsuXGionu8OEt4fpy7xkaw=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2a77c1d5c3bso10312415ad.0
        for <linux-mm@kvack.org>; Sun, 15 Feb 2026 22:21:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771222878; x=1771827678; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+B3VYFqqOtn4OFDnrRnwc7y2rxPOL/UksRHhaZ3LZ4U=;
        b=WUgi46UGAMybu3fwugGEAKFMirARo3jNVQEkYhJNsFtXcKpwf+C2UqmknqYV10Yk9j
         Q5VkVbVwTeN4HSm1PRG/OCX3/NacLHIjEusLrw5GPrb2UzCuFEXJi+71Qtaus9PTmuAR
         HDkBR2z2GuOOtPUYwbhYh2ZVzfQN27DITezdFBnTkADNjQWb3GGQAy9royiX3PBjWrpv
         FheYcubD06uxlaYbB8F0ceo3yMr2/kop8IlqJKKhGlrJYxHCzTSlSpGJkA09KC0SGGyb
         sJQYQcF13foUik2C5imsLPEXlCCKFfPdtxVEr11ySzMizFAPx25dqlcGCC8qyBekQJq6
         B81Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771222878; x=1771827678;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+B3VYFqqOtn4OFDnrRnwc7y2rxPOL/UksRHhaZ3LZ4U=;
        b=hBfMPuh//maJeKn1SoXGAr889x/lsu1u6/IISvN5Pd4tEfhZGAWOmXnUjSKpVzF7Uv
         GoKGrgk6W3hf+Tj4Ut5KIfspRzgc3ODuoKlmDgQUo89w7F0F97eWoQchVyzlJYoU2jf6
         vCfanvCCwD4qCGMfF3hRh92rnpMhU8HBzjgYZuA2ET5mQMjLSXxV9hqNs0tCpNsH2GYa
         9Wpgo9KmwUVjhVsv/IzVxrJkcAhaq28Td6bujVYWIdXQksZ3y+l6gQizh9wf20zMf1L2
         ToxcYnLcxZyhaNCB1t9xNX04+0cTGgjgLt7RAPnsCOhXm2FQqZvkVRX1J04NmQCfj6BO
         ZGQQ==
X-Forwarded-Encrypted: i=1; AJvYcCW5k9c/xa2euD+MplzLQnZ9VkTPXX6YdNHS8kXLuODXOFV56Tmb1QeG2XRxVWxp/sMuLkvlhxdijQ==@kvack.org
X-Gm-Message-State: AOJu0YyIqYI0rBYhgLoqn6BGnSmcxPq0i/HgPdLSULvO7jY/3wjyHHGN
	Cm050M5/qs8RGwKW3gd46WvqbMlOtZX9ptXSuY3rrNpaVDJMjJQWE1Dm
X-Gm-Gg: AZuq6aK5AtFk5Vw5mPTp8QaJ28T6MKZnKc2djOS8kn7yUWfz7bFDBsRfQSzaGRdez0R
	PVqzGMat6ZwXyuYknBdw7LbhZ+fYS72rbsuF5P2pc/9FQHlpHbBN0k/7GD/fM6T0UUyQXFOiVey
	gjDjJE/UUkdbT2IYwhAKZN/bIiu7cvFikwNpJ7ga5qS9xA+G+6o6eXqpmUCrD5n9uf/H25+RWOc
	yhfTRCbbwhSMtSkc8SBv/sZyZ/7tSlaocQr6boqVgObEfk4adN353m/zcqOp9jTRPdP0N4Q0IS3
	fpytMFHHNrgwQubraIygpeWKyLN64ibUKhptQpwsLXUZBbXJAS+Jqqcsy2/vjus32eNNIOPkXg+
	aNxI7rymsQe64f7vC84A0nDeTCcq4UVaCNH+aT2qKBQJg/BrHPd+jl3J5aklmHPo5aF5PmmWjfe
	AW6y0L2icpnj7jTNxoD/WOP94P2MRgc+Ng+fNwKubAETABccv0ipJqwQ3WZ8I=
X-Received: by 2002:a17:903:298d:b0:296:2aed:4fab with SMTP id d9443c01a7336-2ab50519c2dmr97137435ad.23.1771222878384;
        Sun, 15 Feb 2026 22:21:18 -0800 (PST)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a9d5bbcsm60375565ad.56.2026.02.15.22.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Feb 2026 22:21:17 -0800 (PST)
Date: Mon, 16 Feb 2026 14:21:12 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Barry Song <21cnbao@gmail.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Carsten Grohmann <mail@carstengrohmann.de>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	linux-kernel@vger.kernel.org, "open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>, 
	Carsten Grohmann <carstengrohmann@gmx.de>
Subject: Re: [PATCH v3 2/3] mm, swap: reduce indention for hibernate
 allocation helper
Message-ID: <aZK0B841VeaDQ5w4@KASONG-MC4>
References: <20260216-hibernate-perf-v3-0-74e025091145@tencent.com>
 <20260216-hibernate-perf-v3-2-74e025091145@tencent.com>
 <CAGsJ_4ynCA_w4Xcwu1k=2Hw3bMnURBxC2FeZEzN+uzBp+9YJcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4ynCA_w4Xcwu1k=2Hw3bMnURBxC2FeZEzN+uzBp+9YJcw@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: 9hjn9ymroq7h4tmp7nw19rw5ejkc45yn
X-Rspamd-Queue-Id: BC40E40008
X-Rspam-User: 
X-HE-Tag: 1771222879-323468
X-HE-Meta: U2FsdGVkX1/2ZshVUtPYefdLFzTztcPRdiM7GMFgYiPstizbE2raViBL+G/ccqQuUhyNj5tqlB3S00vCuZCUY3J5msJxIkihhUwuizmBnx1c21AEPMsppAqsYXGwvuOOksstyFBRnvrKjDh21rgTM0GoQC0xdl4LRQqS/Flvlrq2bSbjHwHnF4r0uMuqQFy6t+xBfUUL8QQDUhXqmyVIHKxxWhO3rbQ5x5vp6XtzPIv0Z53KWqThbdEbjwW9otdOC0oJ243BerlQ2xsiG6skEfg8NX2nAyntWC7lqL0DT7GU5a7dCDMegzau2q0M5l7/W2eVHNgeCu4G8nqwzTQlskp17cmzBU5GHG3RNRRj9hV9Rrdg6xV4bKpF0NIaXyMqJlZMqsCdBqPcli9UKy3NppqN0igQiiRF9829CrfkvseCLIRWZGyt8n7cBGAE8+91QgCqmeSvnn/9lwE7Z5vUNi5ltlFGKq/BdxBTJNWFkZKTrfi1+Ys+MBmD29wAgVV3/vrNI0Le4Z1+eQwlIDRIzNjR1AKJAu5YRvA00D2OrPOX3vsxzVhac5eMzlCMsp93EimA9xhH8BFSKq5bEM8Qo7AJRCpos2vGG/NBTUODsJCtkzBMfr/t95ttZxc3QEwTk1du6jZatMk41jsXIfMOwEIeRrVE+SAKRl/takIpXSu2Id6uY9D8GhgStxsyNtRo+j9H9GpHQT20SiFtYNouafWUsG2HWVZ2O+b6FnlVFRIjikC3BH0uBsFKBn24Aj1aAy41oxyuc9ew+KaJJBxXEDgXuv7kwxSjiDJnp9sbRGpucNFQVJZ/ZeRENVEtKCCcSkQTE4wpG5enUZbpTuKQWQ5B3HAlsLBY7CyZwC/gPQXeeJn8vYVP/gr/y2RFb/3oho3lVjNSSmn1BbVAbvCkPpykIC7Oo3IgpTlcNmPhhaYSxB1pa+e4IAm3hTelTY+ybdapSjGwLMcLMc5HJ/0
 ASCzDLQE
 Fp0KjRrFR+56NpyZDOArNiVbOzRhDW+BGkofYrR003kWOedWCtZfvFHCpYPzfoOTX8h/NkFiyfqNimAKpU8YcO5JAl0Skvl0kTVtGA40awOgFrsJo4h6dkEYIWJ0MxKTfxZVc47JTF1h/Uf2CUW+ptBtWbMCfoDIz8UFvGgMzuZXp+zeOqO7tioQ4+3sJ++ncBiuASs+IVhcqae4dAsyVCcR3qqOAMX4/vMmwQENzyMIDn0IpIBdA2ZD+KIfJ1+EOnOtuRazDk7Ci42HzvKmGA+Iae8Q3NcDn+NOeouevXw+l+Xe2D4Hlxs7BxEZNu3zol+vPo2bkkz3Oy3A7ScWQ0ziIFqGOZ2Ymb6/7CzMSk7rlEJhR3hCs6djuAHUSrG7iyXoiR6JThJFYRtYy6ze2JnfDng1RX7qOkRaf7anurcToLbtpJ/eeGin8YZTGgo4H8ooyjWB4/E3qivWJxCnv43+8Coly8vSG2VMi9gTgVvxEh8mF8MmX9IL61lhh89mMmZ60
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 07:20:49AM +0800, Barry Song wrote:
> On Mon, Feb 16, 2026 at 3:00 AM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > It doesn't have to check the device flag, as the allocator will also
> > check the device flag and refuse to allocate if the device is not
> > writable. This might cause a trivial waste of CPU cycles of hibernate
> > allocation raced with swapoff, but that is very unlikely to happen.
> > Removing the check on the common path should be more helpful.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/swapfile.c | 38 ++++++++++++++++++--------------------
> >  1 file changed, 18 insertions(+), 20 deletions(-)
> >
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 32e0e7545ab8..0d1b17c99221 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -1936,27 +1936,25 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
> >
> >         /* This is called for allocating swap entry, not cache */
> >         if (get_swap_device_info(si)) {
> 
> 
> I guess we could further reduce indentation by doing:
> if (!get_swap_device_info(si))
>     goto fail;
> 

Agree, I think we can make it even simpler by having:

/* Return empty entry if device is not usable (swapoff or full) */
if (!si || !get_swap_device_info(si))
	return entry;

Then the `fail` label is also gone.

I'll post a v4 later today combined with your another suggestion. Thanks!

