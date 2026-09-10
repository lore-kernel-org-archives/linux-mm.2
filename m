Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3EAFC88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 21:37:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEAA06B008A; Thu, 10 Sep 2026 17:37:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC0E16B008C; Thu, 10 Sep 2026 17:37:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFD766B0092; Thu, 10 Sep 2026 17:37:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 793F56B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:37:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 086DCA06DA
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 21:37:44 +0000 (UTC)
X-FDA: 85199164848.28.AAD43D3
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1C67F1C0002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 21:37:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=A2UvTguW;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789076262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ozbwghE9AMpwIIhz2P8UJs4AXIT1SYFdl3Q4CzsGjEs=;
	b=TM/2bjnXmZdW1f3/n+9rkxm+3jYJK6g6nPch9xOdlRV3BYsbcqSjhG+x8DhfI/OjKqwfdd
	lIf5P+Kp78h/fqOqns0T5qdQkDpMFG1I5d07IujKwT/rddz89oLk3t463hbLGuQ7WWaNBD
	SCOuBSHZg3y3Tv0UJQeQ6TuTUDGKb7A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789076262;
	b=sPjlooXanJbcpwqo/Izai9dldfOIIHhzd0aqQx/nUOzwCn+5A/zGwQI/TpO0kJwHVmOy9l
	pZZ9zd4XjCFVsdQC8ioXAHExqBi9sOg7HRxdB+ObH9bmYYqFl7Le/utpI973KhV1U1OmCX
	5ER1oEp4sVMVVlfXNsJKPpCndEn3V+s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=A2UvTguW;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-52f83889a93so3198911cf.2
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789076261; x=1789681061; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ozbwghE9AMpwIIhz2P8UJs4AXIT1SYFdl3Q4CzsGjEs=;
        b=A2UvTguWSzdTJ47OrWwCeasqVW689HavUNbDdcBUWKEOapJMgXVEsVapicjQy/fvoK
         8201hHnFQTGfuO7VmMuuNdCvK5Jk4TgmcrA92S7tFQuPoTFIXbRWE4w68i1GELFPuJ+q
         rWLtW4GiXIV10LjbX1fNgbFlp0W8orty5crcz0bLL0TvFwyIIDK6Vpt5DfUoxfFQkvuh
         xXc1S23w7HQ2d72UtD5INvZuOdLmxClGly1d6ss0ubWX3aKNYQp2ivdMmYHRtR9m5B1q
         utnqB1r5yr+AsteeV1gV5zmEGg6RkbUM1Q7lrMwk2wMur5Zw/cF4gOqFA2zqg5UT5GhQ
         KRWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789076261; x=1789681061;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ozbwghE9AMpwIIhz2P8UJs4AXIT1SYFdl3Q4CzsGjEs=;
        b=GVRp+q4Al5FkB6Tm/bjU9QQ9Q6JB/9aBEvCBtI4Pxt6uA7Bdt0aAem6En+KUaACEl4
         q2EKDIJEilpSVgJ87f+fwB0mfEGac3S/SrdRkg9ukE47g+LQ7BOYvA6aVU0+a5iReKmr
         +EI49rrPOMoUsvJmoZ2OQ3KmN6WX2y8c0Cb5xWbrUjSf/f6v5ZzJlnjuH9KOoQc9OTaH
         XQSLXW2VunbeS9lGygdhqZfhIUfOd6zQyVwF+GqDxNUJX4kX7fJVTgQITnk6YJfeL8hb
         BT8g+847jyrqnpJNWsUDTpNCkAhKFjrzmD2u7IrrK4wLnLnOmSvMWH9tHVQFgiKuXcD2
         yvDw==
X-Forwarded-Encrypted: i=1; AKwUvByV0vo7fOZHxNXYAAktXZPxqOwxQb/yMmBdbKd1DooeMHVIZMj0pedf/CSCJz2pr9pQXI1/AiUA6g==@kvack.org
X-Gm-Message-State: AFuF++masAxcfoGNAxrwH/pJIGx83Lw1jix98iZskzChBwTwg93aPyZ9
	5REDORQ/1Amxg2Zv16dvYiiGQKcZNepInQJ8mOVcityQX6pZ8bjV7Nzj9abA0J+sKjg=
X-Gm-Gg: AYBFou0jMQE1MWfEc+fvpvBMLsWv/CqYS6OeVWHjFSigEBOQ4S8waZpNi7YUKvlSjlK
	WK3w5a6hnEdUPxGuUFhCGcfVo+q7Rjq6AVs/Nz+pHDvWoGifv39b7vi+BkusBz8v3jalZEmQ3Yu
	OLH0i1awHQrijmBmtkhNgAfILEzqyaLtVK3qL0ixbX9lnN20IM4usbbzy6er/Zjgqo3XFQK/8te
	8b3dNURJaBm385w0umBSUfX70cB19gQ+EjckHibkrHGq80AaCG0WC4u1q6ky5rTqeR3GoWjd1dU
	C2aFP/l2fZyj5Cf5J5V87Vnxx09T/5Fj8uGCxsQQlYl5YZzTBivna5kxw0RWak7dmUHSJGGWNix
	0MTvDFzHNlExP1+4hpNpMK8LRODRZaA8yNXd7E7jhjIpUkVTv/NJH02c5lMktIazh/HcnScQXhU
	umj3C7PWGcG66rAqX7EJFBlXm4rSY925zrMMIVEfP/k/w78lXq7kd6inNt+7QcnwLnv3hzuXZ+j
	KaepZFB9jad/wsnp2QaF2CmULGbJU68Rxd+
X-Received: by 2002:a05:622a:393:b0:530:a441:c52d with SMTP id d75a77b69052e-530c876307fmr21122731cf.46.1789076261010;
        Thu, 10 Sep 2026 14:37:41 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f4d3779sm5444196d6.43.2026.09.10.14.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 14:37:40 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: kexec@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v8 00/12] PCI: liveupdate: PCI core support for Live Update
Date: Thu, 10 Sep 2026 21:37:36 +0000
Message-ID: <178907602445.560913.2482730956380750475.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260728221007.2098560-1-dmatlack@google.com>
References: <20260728221007.2098560-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 6i6m1qtzxdwdn4uagudntifqr17qhpz4
X-Rspamd-Queue-Id: 1C67F1C0002
X-HE-Tag: 1789076261-47415
X-HE-Meta: U2FsdGVkX1/yfl5Taq7F5220b2Z9Z4mqcgpjhPbBxQQC2LoucT8i1sc8HhHo2HcAZlGZAks7KcrH43zdy8SRd/fcgWR8zf1D5TN07qFlzCY7hn8ZbwBQLLOdE5B7BlevO8urVreY+tN35DbelkblFG4AbGt3zVfuALjC+j2CFGGsg3hp0kwpCxLcgn22hZIHvC18e4ZZl6oSfV2dflpcj7rxZ3q7mCERCBru1wmBXsbHVQVPzAWeU7zAv3EhRluo7ftgYlbsrgqRaDFM6cELD/31sJb1WfttOP/8145FwSjrje6wR5v9u7ppZcp0Ey2nRTcXxLaZ6VylIUb8A8krKjAfyiM7hxeVyPPsZQS00/Riu70As0PgeDlmAQG3a71C1PJgACp+JCUndpjbzQVBrxM8k12VZy1tOO1UglXlhzDM+Vm4lMSKDVMBtEQBkviDol3/oiqS3RhVKPR1fr5lZNKq7GlHRg60AtNIgvoR5OstYHgHHMVWm7SHN7hAguvNX3PI81/uISQ+i519gei/9UnQiUNMHZd3YHc3PcrQLhwMDnQZQa0UZ5W2g3JQ7P3FRSfMYzaHuE7/ZHmqEUt8SMJINrJkWpgAOGeONdOQSd/9eU8AH2Ngqj92dbEKqSNSqOZmZ92EPL6of7xGs2wNfkBIrPi9ugk0vZojWTZsYm8JCI8w6ePXECa8WDW/hqPhDnkKYhaY22Ln7BguHGSWdVWneoErFBREHY7xVqqAkWgvy0ar/4lQxDyzOQUwM44Ztt91TfC1VSux+UHHOIyQcynkUEnbPo98lrrABrt4iQA5qgDmvuDQPm5FgIZuZTHtD3wGwlCRtR6phWJf4W0WwZj15KML+y/AGVJJx4pSoU8tv7qYcvKQFnHdjndbYLArkZBT6rRBC+Ach3nuWdI/RmuaRDK48RKdS65QWcm/kVqmqX7PSlgKD0L+bquXdUWNQrlSBKXqZC11nU7+I5V
 UH8YhwO0
 MzAxl5km/l+Qvw39YHYYVIIIbbH/WhLZkPQRnAFBkX1OEDdZxXb+6rp/whakZ0gbf6sXNt8mdior4ZPqdEZX1W5jSb/FwZoOND2VyHngPdvxZlfD2xfzk8Xln36CTDwSmjlXvQJVNW3I3xaRNpixAFEIB8aasVcs6APiHsYqu/8JH7DOE+SWgwZ/6jKqfpznQcKlcLW2GGn2vcIv5w61oznR11EdFNATzlRu3gWXKLHHuUu763bg0REwXlLlyDz7/+WHE8C3I5i5Q62c3PB7UB+WDCv21Xk86fImE43Rt7YskpXH6R2BwGUmZ66WOSrPdDCk8f+9RjVfuPp9F+8CzdKaPwC7PnokAWF3DTe/A0zCmMGU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, 28 Jul 2026 22:09:54 +0000, David Matlack wrote:
> NOTE: I am sending v8 out a little earlier than I normally would since I
> will be AFK from July 29th (tomorrow) through August 6th and would like
> to post the changes made in response to v7 feedback before then. I will
> respond to any review feedback on v8 on August 7th or shortly after.
> 
> This series can be found on GitHub:
> 
> [...]

Applied,

https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git/log/?h=lu-pci-preservation

Thanks.

[01/12] PCI: liveupdate: Set up FLB handler for the PCI core
        commit: acff3a35a49097424762f255afdaf2a122e926a3
[02/12] PCI: liveupdate: Track outgoing preserved PCI devices
        commit: ced0d433a98ccc33495a985580bfefb62d73b16c
[03/12] PCI: liveupdate: Track incoming preserved PCI devices
        commit: d96e637021905ee22ef75f3608b46287b3d44508
[04/12] PCI: liveupdate: Document driver binding responsibilities
        commit: 4d9305a6938a66ccc1154dc5fa5a8a9ac56eb549
[05/12] PCI: liveupdate: Preserve bus numbers during Live Update
        commit: 8db5cb4011d0ebde5fbadf1236dfcb23bb8ce007
[06/12] PCI: liveupdate: Auto-preserve upstream bridges across Live Update
        commit: a7709b31ea29cb7d65b75beb844e0b92a20d4ab0
[07/12] PCI: Refactor matching logic for pci_dev_acs_ops
        commit: d2cc005d11de82f352e1f30f7b9aa2a4c463dec0
[08/12] PCI: liveupdate: Adopt ACS controls in incoming preserved devices
        commit: bd5970669fa8a2c1bc04c3fa516a0667a090c604
[09/12] PCI: liveupdate: Adopt ARI Forwarding Enable on preserved bridges
        commit: 48928296f529d15ecf66c263f3cc5fc657894e26
[10/12] PCI: liveupdate: Freeze preservation status during shutdown
        commit: 09907e211d2d63cc74f5a00e5949866f1078da76
[11/12] PCI: liveupdate: Do not disable bus mastering on preserved devices during kexec
        commit: 7f44eb94b1a85d2827610726e43de5554795cbdc
[12/12] Documentation: PCI: Add documentation for Live Update
        commit: c08eff447b966b21511c997272612e9665b0bd6e

Best regards,
-- 
Pasha Tatashin <pasha.tatashin@soleen.com>

