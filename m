Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFAB6C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 17:59:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD3266B00BF; Tue, 30 Jun 2026 13:59:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAAC96B00C0; Tue, 30 Jun 2026 13:59:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A99496B00C1; Tue, 30 Jun 2026 13:59:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 84F686B00BF
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:59:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 03BC58FBB4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:59:21 +0000 (UTC)
X-FDA: 84937340964.19.42425DD
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2800B1C0002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:59:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TQXeOatU;
	spf=pass (imf21.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782842360;
	b=VDKD+Ex6mVc9EHFO1QtK4ZFrR/gGhFGFNKHJ0ljMM4+yfyQtiZvpl1cnkt6admW29CbZoE
	fmIUxOA9+yhRmL4VKoRUoFkMJAZFZYRKESLt+vKhVSoJI22np19toe+r2scwwKtDSlmxQb
	kCf3SnNoFkui3m83k3QvYRF6EypuYl8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782842360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Us+CXl62OP+IHnxEOFdUPPagDbtagb/X32b+PDoHuVk=;
	b=Killu/6G0hXHYNWMi9tCTeBlItpqNho00IuwJvisIBLhlzKPl+PW7Vh/ibXIr0wIHUfwmk
	/gPeA1DflD8jo0kDc5qhTa7pyseaH6163ZshtcfeqN5loQb9NYw7qLjz8iLRBaxipWF7it
	Zshrwkg44ED13JIiXoFxiR+jPCq0MBg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TQXeOatU;
	spf=pass (imf21.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-474e7ba9fd6so1116484f8f.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782842358; x=1783447158; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Us+CXl62OP+IHnxEOFdUPPagDbtagb/X32b+PDoHuVk=;
        b=TQXeOatU6OuFS0Y91H2MIy1jia03rIGRkj9sDo/+w1C3h5c9tEoVYusSgn+AQeJVIK
         IUJyTHx+SFxiAq3dEH4q3Z/3bWbYnJoBYNF62jpT7ixZpdv6jy62DhcTpSDcGXxF7kn/
         R3FF2a/yXXHFKiGCBfZy2MBx2pjrIlQop7TMLaK/mxv1BjB1K7PbLdwVtrsJ/mfTcmJq
         vxfBx0s7SOYJrn0nsYWQXpPdUN4q5hu0bpuTgiJmL1v5fG2V1JKrY48gji+jYBXBfwxm
         9+r/hKvTIOpQAYY3zZbJOLTXf1oHgue9h4FwpSnmXwV3D4R/Ny5/26nYUAxJYgHes1VV
         K8wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782842358; x=1783447158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Us+CXl62OP+IHnxEOFdUPPagDbtagb/X32b+PDoHuVk=;
        b=q0Aq6gvy3GLts7OcMrscgUIBc1AkpSlTUpVwhBhQapkmek29hkGeXJCQ4DNG6RfrfO
         QSg0Pgg7lhWM40gwinGwL8WdDo8Nr5gH6dPXmmITnNP5Q2XJ/el5WD31/WkbSUZar10T
         La8eqgry7yhT2tm6v1VhgmzkRfBaSGMLqLKcyw9RPChkS/LgsaKSSZVIc2IF53gGiDLf
         iOhpM8HzuT/CdFyUMV9/cJeXiVeVb3aLpLDkA2tsTnJdono4UM5X2HGsgUVT7uc+RmDg
         BUe+ouunAnBuQRwx/iWlpwEc77lGOJyoegmYX9KUryLu0TqYeQD3JqFn+38mZHaP83iU
         yxOA==
X-Forwarded-Encrypted: i=1; AFNElJ+PcfsD0U++UmdBMTK5g1J+bCV6516xQyLvhIdZo6FY+MS44nQTPHD1pGIOyRC4GwWmm9CYzhVX3g==@kvack.org
X-Gm-Message-State: AOJu0Ywd7LGIXJ/zIMcYagGrbilU6MwMCTjt+QQw2l0uzfVeD3NVzRCr
	6oT0kjV8+gvF+nJ6FHTpw6MCGAMym7Z4SzNlhYroV/JGbMAC0xyPGb5T
X-Gm-Gg: AfdE7cm0WOhgH3extO+tjH1iLOt+uvYLfwmWlGWR6FAhEfi1miVgHTlEDpIR07wrGrn
	Vpp4CpgBthw6RCJ64CCrDAN/+tQMzJsZLk8WApQJesdY3hjqsWXOYVfBibS/9rjnkHW6U7r+Mxb
	5PJw5Tb1VcP3J7o1oDLpw0+LQJS/vUNPhbhOpAcGKnqzC+89ZhJ9wkTlwbz+nMAfHjM8twv6eeU
	Xu6cQRkrPrMOtqB2KHR5w8CwXbUeAI43HB4l4Gp90eVmU19vbVg+d6fqPKyoFjd22ArJnKEk0Wa
	xNioU6MJu5QGpg/WH2d8OwviJlxFcwTxyG/wuU9QcG4qcQne9D9CaJUp0GhMrnJpQmI1fdbehmS
	uxXWoTKMkZj2pBw5bPSRxBbqu/JCpHLo2T9kGUjmtLDjeN69TtazM9yNdIibW9fZBfSI5BlaLZY
	sZfGEEu1Je9izwefATobKp3RZlEK2uy7rxkfpTszkogboHeg==
X-Received: by 2002:a05:600c:a06:b0:493:b811:e549 with SMTP id 5b1f17b1804b1-493b82b61fcmr66519375e9.29.1782842358265;
        Tue, 30 Jun 2026 10:59:18 -0700 (PDT)
Received: from pumpkin (host-92-21-50-228.as13285.net. [92.21.50.228])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493be4c7f90sm11943955e9.2.2026.06.30.10.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 10:59:17 -0700 (PDT)
Date: Tue, 30 Jun 2026 18:59:16 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Jann Horn <jannh@google.com>, John Ericson <mail@johnericson.me>, Farid
 Zakaria <farid.m.zakaria@gmail.com>, Jan Kara <jack@suse.cz>, Kees Cook
 <kees@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, shuah@kernel.org,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-mm
 <linux-mm@kvack.org>, linux-kselftest <linux-kselftest@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] fs: support $ORIGIN in ELF interpreter paths
Message-ID: <20260630185916.5a694895@pumpkin>
In-Reply-To: <20260628-debatten-vertagen-amortisieren-3bf518773e75@brauner>
References: <20260622043934.179879-1-farid.m.zakaria@gmail.com>
	<sfv7zc6jboy2oxv7zuyofysas4ncbzenwsuzveiyduisfr6i7q@mx23er7uxdbg>
	<CACCo2jkDuwy5w_yhX8833m+s-rY736pk8xtKjxg3_y_7BCOHeg@mail.gmail.com>
	<24420045-a6eb-4999-ab19-1e344eaba8a4@app.fastmail.com>
	<20260625-atomkraftgegner-hunger-kursbuch-b452ff2becab@brauner>
	<CAG48ez2X1p5Nm2_sU=SK9wUusUO8c3_T-=FGrrOhkm7Kn9Y_7g@mail.gmail.com>
	<20260628-ungeordnet-orgel-stechen-36dd64038541@brauner>
	<20260628-debatten-vertagen-amortisieren-3bf518773e75@brauner>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: rbf8og4ijqx49qwsjrrxetr6rdif9h1f
X-Rspamd-Queue-Id: 2800B1C0002
X-Rspamd-Server: rspam06
X-HE-Tag: 1782842359-373348
X-HE-Meta: U2FsdGVkX1+V0M0zmX7XcAepU8egLTRiB5S09yRtDXFayIaIZv2Er+5e3GplhPvDc09CCBe4O4vwYXhIpfK94S3oWdzDJ/UCWvyOn4kHbSzhPldOH5kNThYKUwnIj0l0BZcGzRy3ji3hdFapUnTff0oz1YsjMtj19b54atBQExFdqnKmkXSOqZBsts7Iq/1+DGQtYMSZeQrjTbqfLP8/nqiAAog4sdIuQuCKGvgWLXBrAYMfyjK7dCkV8AMRRjUd7xLUp++QAjQiI1xoISvTKRlnPE2CT9sjBj6aQsjONc+LzdMORUhAj5WSfVnKnIIKpkhsU51Cmon7MI6mOXwNhcvqLjv5x3fiiHgipZf2VZ9HAar3PE6nJg3Zk6SpNj30n19yhhfX6W831dELoT8aadLWJEmuuXGq/h6byPiRT6onLZPRhquzeZXQWS4RSiUg04U/AscOg7mvmlGcEtl9dZLhX0eoi+92jQNlTEjKZKe3YA+fR+M1IKfzSkcwK47Qa6ObOcrna2wlUpap4SO18lrGvQiUeGfXkdGtQoZufz6iPboGOxfPWM+Sp3OtQU2JDKIvBLKPFrx5P8fPr3w/WQQQGDd1XR+F0SldkYcVVknc/7VKjMPq36xUT/x2wUmAHb3+Qkyai2xJ5zv/B+q2UvXNqrcHGikYYtzusQhLODzblNP5YpKnNUSiQrGE7DV9pNuL5K6royVFPCNT3nflOXp92VYwqdz7TEf4n7h646oc2r9Wi4jBEvqJdM/rtccA295rYmgUJYxYpd8z99uaYAxlBGd6q8Xxs/0sT5sprDGHSgPauN89GJgIRRqk3/iZRzBWedibJN+TujvBSSvijuRfJQzb/3GdXRLsax/dLdAPO6OEbBeopZb/Rs167S8xfk8lurScSftCTl5tO9khTPaKa/aMNXi6ESuOHdOoNKUc9AgICZCSSQZcQDXDIXW6qG+XgjPUZ9xF+51XOgc
 5/8JaD03
 6HX8pPcdBL7CVI6uw20gwAvRKMVKPv+yQ8jiKNTTsmkJbt10GpnXdZLSRXQSAGePWkXDM1tTAalDaBm2l2udsmTQw3f8N1ZQQTLsURA0iC1j8p8qal8brQi+tpPrUiDgj1lujP3ckXpZ2cHGEwLNYfc0CVzKn9LYvORrWc1W08TCSwvvJAbXazWAmUVTiy0brW911481d54HCp/Gz5UIToAE59GIbRKAWCmRpkldO1/NI9QYWmsz1xpHQvKn/qJ2kf8U0sOEf0dHA7NsSGizsneXhdWGoaPICcr43V59YxyWT+SIKgoOaK4VO66JzLyFECT98w8miHX0t3Xq84hl+sDekXS9sO0QRqAr3uk26F22zBH5eMqfnc691YmF4E4S3N4arCz64ReoL6P5txfluFPbZY6yMb0tlkL2PAjVVLuCrkzvwKVJu/4ELX1ryHM94EBZDFeJ1ZSSXBwrMkolXQ/pWLXTDu68rxFRQrqfQKJ4l4UNEN++kWbatFkbuK4DTqmgE/7EC+DP/Aw51GFlv7KB3uRrZt4taYXQ21gx2Fwuu8PVl+QQoLX0j/tTqmcec+I6EkwgI8b+/GhUvNJcZ6Gn21g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 28 Jun 2026 15:20:11 +0200
Christian Brauner <brauner@kernel.org> wrote:

...
> In a way we have been doing something in systemd that goes in a similar
> direction. As of systemd 261 systemd _only_ links against libc and nothing
> else.
> 
> Any other shared library is dlopen()ened as needed (discoverable via
> elf-notes). Lennart wrote about this just a few days ago:
> https://mastodon.social/@pid_eins/116781776665322560
> 
> This effectively minimizes the work the loader has to do at startup. Imho, your
> effort with wrap-buddy is related. To me moving the loader invocation out of
> the kernel and into userspace makes a lot of sense to me.

I've done that for libraries that a program doesn't normally need.
But it doesn't make sense for a long-lived daemon.
The work almost certainly needs doing at some point.

The other problem is that it is hard to handle symbol versioning.
So the function you get may not match the one the header file
defined and you suffer the consequences.

	David

