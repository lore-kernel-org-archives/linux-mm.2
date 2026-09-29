Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6311CCA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 18:14:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB59B6B0088; Tue, 29 Sep 2026 14:14:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E18A06B008A; Tue, 29 Sep 2026 14:14:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE0216B008C; Tue, 29 Sep 2026 14:14:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9EC576B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:14:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 046A91205E8
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 18:14:06 +0000 (UTC)
X-FDA: 85267598934.21.AD5B6EF
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2A1E51C0008
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 18:14:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cKl1WrG9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 36_-7agcKCDgjlUngUfaiiafY.Wigfchor-ggepUWe.ila@flex--pratmal.bounces.google.com designates 74.125.82.197 as permitted sender) smtp.mailfrom=36_-7agcKCDgjlUngUfaiiafY.Wigfchor-ggepUWe.ila@flex--pratmal.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790705645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZh9La+paKQR4zf/FQmxkRWHM4xhm7VufrGTHjDBftg=;
	b=0bcmRKRASBYPr0ttOKoK3ELpd7sOZUyA26TTDh7qqfzodiILiFz+fdcuoeEz3dkicyObqc
	xK7ea1K1PFbEGq2PaH+A3ToUKQOq8XBVdIMTIljP6lmpNFWTtN+atO/gB9ayc10jDHxISh
	7HGPSdLJ0pUCPm8LvYi39crBpe52NtY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cKl1WrG9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 36_-7agcKCDgjlUngUfaiiafY.Wigfchor-ggepUWe.ila@flex--pratmal.bounces.google.com designates 74.125.82.197 as permitted sender) smtp.mailfrom=36_-7agcKCDgjlUngUfaiiafY.Wigfchor-ggepUWe.ila@flex--pratmal.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790705645;
	b=b38+k1qqLKTYdNXVgr0jkp+X9dzBWUkvLAXKwTvF3G16JrPhmSWRtCB/Fi/fG62C+ls1Yc
	155t0a9iSyaU1YeTFXtLnnJLB7eX57f267ljHVFhteWTc/jvOonY8reog/+enG6ZUPNHoB
	cxkn78y0BXTGJKfga3oQNYcl4R8rI58=
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-33baaba6371so16767586eec.1
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 11:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790705644; x=1791310444; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mZh9La+paKQR4zf/FQmxkRWHM4xhm7VufrGTHjDBftg=;
        b=cKl1WrG9NTdt00BvaWX0xBq5MLtYz+Vbd22tUS4qqZdKYpRBfH0MKdZLOb7eh9pNTL
         2enUdEfWLzSdCN/gzEjUT/QtHglv2zOZMfML8bOc4ubObTQobPvQkj+Wov4hvaGO93TP
         zhAif4778OPz1L54zp6yADlSM3fscYwkyOxbr3jNzvMaBHQXsduqujKz4Y1AUk/6wsep
         f+n3uT5HIviYDYTtnUNcpwpgnX2jejC6Nvah+2nMPg+OrAe/9e0/p9hemsECc+SMw4nj
         gH1Tj7urcY0ALUvMknzELewLfDDJiBqCdnl/5jj/BrL3ht8tqZnaPqtGz3dHHJpHc2HL
         kgwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790705644; x=1791310444;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mZh9La+paKQR4zf/FQmxkRWHM4xhm7VufrGTHjDBftg=;
        b=tV4FFv8YEzomMAaDwG/QvKYEsdO4KBI9uuXWh4cJWkS0PsNBPZwFIUwUiodrgqfqtG
         EVFCYvBA+c8z4Y0xn3LoPT2GfIitNqZbIanUQSCRL2WhO077J7wHRpm49dEf2KAktCgz
         3IuuDDhvbeasWq6xRqwO90t5eLKncDgWZ/hwu41yKMrkoN7bztZpznsien+3YoGQNHRH
         eJbCdpyJ7MRFbI+l5JOz+7HF2PUab0oow5nMDxPAf1UaQk+B65EtIW+jGtw842Pz2LXo
         8UuSBHrIrLvD67Q6rNTXSLADkCYzg/nmxDjISV1MLO9xNx4oULwtz7fR2v/JanOerMj7
         m6Ag==
X-Forwarded-Encrypted: i=1; AKwUvBwpFcGuSY8GV2efMnLgdmFLoYwOtE7KeiRCbYJty/AzfjSSv9JB/YSeg9uC6wMPKdWbf5Jv62NC7A==@kvack.org
X-Gm-Message-State: AFq9FYJeBdgRwnLptHxssyXj5bvUhKMm9Z8VzqQdh8W28+v7RVoOL/li
	srpCzYT39FjnK2mV1n0mOmUsmhvywNn1uM2eoxZLGRFW/Jc4xLCaER/YkTzIY/kZZ6hy2Ik8Eur
	gejuARNf5NA==
X-Received: from dybme43.prod.google.com ([2002:a05:7301:18ab:b0:34a:10b2:be3d])
 (user=pratmal job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7300:c8c8:b0:33c:e61:e201
 with SMTP id 5a478bee46e88-34c647d537fmr196806eec.22.1790705643313; Tue, 29
 Sep 2026 11:14:03 -0700 (PDT)
Date: Tue, 29 Sep 2026 18:14:02 +0000
In-Reply-To: <20260929123241.1408414-1-huang-jl@deepseek.com>
Mime-Version: 1.0
References: <20260929123241.1408414-1-huang-jl@deepseek.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260929181402.44684-1-pratmal@google.com>
Subject: Re: [FYI] DAMON and virtio-balloon in DeepSeek's DSec paper
From: Pratyush Mallick <pratmal@google.com>
To: huang-jl@deepseek.com
Cc: baohua@kernel.org, damon@lists.linux.dev, david@kernel.org, 
	kunwu.chan@gmail.com, lance.yang@linux.dev, lianux.mm@gmail.com, 
	linux-mm@kvack.org, mst@redhat.com, ryncsn@gmail.com, sj@kernel.org, 
	virtualization@lists.linux.dev, xiang@kernel.org, xueyuan.chen21@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 2A1E51C0008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: jxb15yuudty965c8tkqtdkxwnr6inedk
X-HE-Tag: 1790705645-758278
X-HE-Meta: U2FsdGVkX1964KID/QV4BrUckrxUrJfR6+CR09PFjffmb6louulSJ/db4fuF0hBNUZQZzRO9nSFnA/UFSTZyYYmb0WGDCWvnXYgqo/9vPPLQxuVcgHXDdcpDsEcNLR67qNWviYNJs4MK1UU0QaGGvk5pQicsYoTDB1nqvbLomZxnBWNVx6wLK3JMNdD575NQAYzu5yEMz3fyFCm+TSrZ3BTqRp8ftOrSB34vJUj+6H1tLxHTuSU51V+f4Y2zFUJPWnakwZBNGhRNjWtnx2SoxK083IKmZOveb/qWL1RmEVcVaTQb2XHJEG/0JWryxO4cUworF/rUdqokpYJtOeqjVTNjmGfghjO6WgHy49F/xyJ+ho43yAYS4Rf1rA1CK4+dzNXTqFEKCoeQ1yULKmFLTXaVNKdeQaWMGG/3Odkq6Jobuazfn6MvUhWLxu81ulCyXAb7xRTy45SObbLQlYyuIP2yD0cMPJBz/sqU5eoi+PJ17y2Uf5+X47S21iAQRb/Nr5d66gtF2ws9CqGlhFbel51h+1joNjldzHb6rXBAa0EKeE2sJlVsN5uIOxaDAoADj4q7uXuH5nuOOBdEAHBTWnx3IHz1NGPOfDo5+ABML//x1zMxW1dK6td5mykgU9X5A1hIbT90r8hJxt4Nj69uS2KyWH0gk4sWcHm1NsErRGS0zZuno7nktHYhgu2Po/bQM6zi5yTI33kY/+ok8EswfClszERX/2IAZbTAbd+as1IczXl2Nx60RiM3YHLgne/ea9EbnCMZnI1B7kWUBkX9VFvv7qxFkCB86o8rZcBzVc2u2eyWw/xJotOyCDIaw7lZFpM+KlwDcHWJDOK3CCJ3KwuedbaYnUgfgL9ROGEWyCvpJZ+reHMurA/c+yXm0A+lDz8NmgY0XFx3KxoFkC98HwgnKGWDQ6K0bshJ7+WYTyEHrdSENBOuvfTb6U3bR0kXs66ikFK1UBJybkiU+RG
 Sq9WgS59
 VTI2oswX2T164ftab7CHUagNhkhHFDp+Pp60zD5Ddl5Fwiw35kAG8oWxRG9DwJw4PdFTcsDpvatJx7OdTxruWqRCofam+c1lQ7HtUu5BZdmUqrGwqjvCjFtT7SsqAgI+ST7EnO0B6mitEMyZgECCxJgtXBVagc9bl7j+RdFhwsutxTWUcOr5/6hkdAXUCwV6pN5I3QnMK/9BtDY4ecMANQM9GyL7cC/uoLPCMzWsqmLqv0sniXJUSdQTgWprdzDMZWQTa8dhpWMliZY9D/d34m2xO5ctuasAQdj7kYLkeq1kGWMmfEmMl9InDLCP4UtqZUwo6boQwRNwg9GeJh+P0QSmT+B0KnTcC6eDRIoSD2SKlqqV5rZx0PkdST5736o5bQzT5Wfxp0CG0w3sAKQQ2MhvgziuX/chrMkbrLaTo9ZlDt4GMEsmEN85bG4J2u20avbZ8OxN5Mpfn6dXJ+gmA1g8fc6O/HMzh6OvrdBQZHNHDLZ8vuyqOQYrkumcAuY7bwTktZ9mtldBhsY2xqJMNYvhK82257g9JR+XMr0xBa7oyyDWgGBJ1JpAoe7+H2KnFTsbd8eWKUSYmcrEM5HX5rRCqTnrQtD8LstVaQsixoZsVwul1PNSy47H9t97aVSgG48qCsg7yKhGfuSg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> We have not yet fully explored how best to tune the DAMON and free-page
> reporting parameters for our workloads.

You can also try tuning page_reporting_delay_ms, which can help you with
saving time-integrated host memory.

[1] https://lore.kernel.org/20260731193705.2902728-1-pratmal@google.com

Thanks,
Pratyush

