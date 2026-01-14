Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27A42D38FF2
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 17:33:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E2636B0089; Wed, 14 Jan 2026 12:33:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A8866B008C; Wed, 14 Jan 2026 12:33:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E2EB6B0092; Wed, 14 Jan 2026 12:33:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6CEC06B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:33:12 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1DCD0BA259
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:33:12 +0000 (UTC)
X-FDA: 84331265424.30.494F199
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4A39F40009
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:33:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pC47ahXs;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768411990; a=rsa-sha256;
	cv=none;
	b=V3XG+5N6E1Om9G4Bte502TG4Xuf+E96kmPMsDlcvRqV9QF6PIGyPF6VpxGkOA0qd25cyCo
	u5g8Neo7XFrR3WaA92mTBdKiJDFYMhw2BPWZD0QLyg3PkUfzj3QtEOO13zxNKf0rPkE9Hl
	QBsso9p5csPR6tWOPdPpWeU3KT+7044=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pC47ahXs;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768411990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bCjYai9Len2QQEYBKyLKOlFSVdw2VqJPxFxPg7dhnMU=;
	b=JnExrePapd90yzCiHWQZpU9RZtfeyBD3mSYrvMaEWD6WSQFWAf1H+QdE+/3UIFiODMztJg
	eqwj1iz4FJRVTe3K6BpTGjUpABuQt2NZV3VC9pOYOF6/Ft7D32snj/r74jyyX5i7stIMWr
	Men1dxQHKigxM7rQbQJx73rCfHFVj+g=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8c52e25e636so7878285a.2
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768411989; x=1769016789; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bCjYai9Len2QQEYBKyLKOlFSVdw2VqJPxFxPg7dhnMU=;
        b=pC47ahXsyk3PjeZYtBxGZfXH7wvmQk0nzmO7gahh9VxegzxAxJz3n2DYSsn0qYcCKx
         oFV81HvHNTIpUFLTolyOSSEZjtNjkwxM0jHm457flVVGjtNiS7dHDmueWA65iwdzp0bi
         kAQSxEpR/+v8uMo6k0d0IVjppIKd2Rb/BVDn806Sov5xRE76s1ZPUi52y9gfnhGTlgmP
         /iu4Rl7tBmSm/gV9utqfT2nghOcxynyee76G1hU9MEZmNCIWQJm+TgJujGM4Vup+691D
         lPPEtMawSPt83e/zffy3rOyTWPR7Wir1QTMArKQranTHUA2XGSI5UlFQHRXWG087Ce0R
         cRGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768411989; x=1769016789;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bCjYai9Len2QQEYBKyLKOlFSVdw2VqJPxFxPg7dhnMU=;
        b=mpm9EXeDQgmhGitohdjNxMSKaBcs76IYiwap3RFABW8G/u3gByG7VCihbt6fAdN+PB
         opXMkvg+RzMe+PEbqRLSatbWEysoiapvCt6U1rXJKlym0Rj01eg/289HWePhVIUeNb3W
         C1jHGBhIrMGtF+2lJ8jsL+60sAKVnkdbfAhfiDHqGB3e/KlfsWPqp2bIwQ9wc5ncXjda
         L1pyAF3ervQ1vIuksBbc88s+ymiMrL6xPuOx3pSaT988n+V5Fh5XWkZzNkX8ykwmGaFL
         UBh88dlTf7C+H5e1jd4oF8D+chw0M4UvrAURcI11V6EAheAg+d5DyqDqz7ougdXb+KIm
         n0Iw==
X-Gm-Message-State: AOJu0YxxOskeRYbjGnfqy9BcR4kV5k/5w+yL4jr6YvFF9hVmQz43VL4B
	/GOVqE7Xf/JLD1Owy7cX+c8r1HaFX2TlU4fp8S/+63IekwIoKkDFV7fNSHZ0bFkmzNU=
X-Gm-Gg: AY/fxX5xqCDVYglr6Mubfu7jj2Esee111HOlw0V9k1hpU38VP1Is7/5C3N9EDYWRRTE
	gZA/gzcDbqwd9fQGcFetFDk5hKB4mMwzFpVp4Jemu+FaMg65lfOpN82hrvGHLpQDVQmiH91gfYF
	7GvghBRMGB13rV7SKyNitwcoHXcpGrb5FFyXQyAn+raS6u1zNerNqSpsyXbzNFHyl7xk6n3DLfR
	gfKTh1/D/tmMKC0IIQ758oKGwE/4dIXUnfCx2Y1xvvJg9syAWcDFY6xd0C+KLYpgHlTLFZbtYVy
	3yh6gdFLmht240FH8imDBXk0mZAI9FddaU3oJ8GSRoBEiTTrR6n+kbeB8t7O7eoBZCsNGE2A0Ub
	yw0QtX7/Vul6xou7wk0eWEYBzdIXxZrtthxcacJLUO86lGCoA63QUeBui8wfGBBFGfZcYXpjokG
	AkNi+0BZ9A7LYynGzBnxvYo5HEhuz8etN4un9GJGR5N99KkJvLG1v417QkMI1iV0iv4gDxkA==
X-Received: by 2002:a05:620a:458b:b0:8b2:7290:27da with SMTP id af79cd13be357-8c52fafd245mr470291685a.12.1768411989233;
        Wed, 14 Jan 2026 09:33:09 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c530b6e7d4sm198764985a.28.2026.01.14.09.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 09:33:08 -0800 (PST)
Date: Wed, 14 Jan 2026 12:32:36 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	kernel-team@meta.com, dan.j.williams@intel.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com, mst@redhat.com,
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com, osalvador@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH 7/8] dax/kmem: add sysfs interface for runtime hotplug
 state control
Message-ID: <aWfTNGMqn7S3b9z9@gourry-fedora-PF4VCD3F>
References: <20260114085201.3222597-1-gourry@gourry.net>
 <20260114085201.3222597-8-gourry@gourry.net>
 <3555385d-23de-492c-8192-a991f91d4343@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3555385d-23de-492c-8192-a991f91d4343@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4A39F40009
X-Stat-Signature: z91ha6z5n3cyn3fidzg9fwnn5qi7ebkb
X-Rspam-User: 
X-HE-Tag: 1768411990-307397
X-HE-Meta: U2FsdGVkX19Fb3y8Jv3xERG7pRORtVZ7ClIPxfLXe5IqT7TDs/E/3efPC3y91CprSQ08CjLIAoEylWRTZGbCaYnrv2YWeko3Zt+u3eEBsJt87xunszj0oGeD3BPtzblCEFV0sQo4E/J7ZS2I6IpZsDZFRez7zO/Yn2OEeAGRXER7Qj3PTrMg9n3R+kbLCDJweiLIOlP5JJuJtl6llRW/E4CCil2GqZnG58SnbFk5XI13grKeFDKbj7XJFMDSl3Rqng1zBOPnwErkg90sLDJdxOR5/TQSmKUwdPGotI2AesXT88P6gLUVND7WhDSfxogimNNMSfLujS9pnYzDqo7SpKyan9YOFQBvcY/9ZCV+A1aApUdrH6acVOETvf9NC3wRRjjOlbGKtMg0RvvAwbjaNi4K6c0pXT9cP2OemKBiX6HCCRa9BC5vx0NsctD0qc5SjTnI3I8ussTsjNASOBM8vZQpV0tvUQ6LdchEWIMiychRQUOL2PHIIRl875VXPVQN6vDBqhYqq6Fs/+rl5nDYaJ0LaBqfw9m5Ycl8xaE3vBdkJIHLHomxVfgbblp86m0aURLIz+cSvMp0gNdqKkgMJoxHxyI4AbKjkvudhls3F5peEIv3Tnt2uLo9uApFC4z3rvRzFgow8iTia974HwNoED+rw0jfYKniu419g4R71Q2LL8FWtjLNEskOqY5c7ZncoNalcU389ZAIy2o0ibxPWWEyhsqk9HiURgKHCFKb2SJnfuOq5kM0HYBuRkSoP6b+ooAak93TIoRgVwZrJ09w0RBTYcavZMlkmpxL2uUW75ZaWadZIt52C4OXzPZdawEtv+9SmWaHRzi4kW/2fUkMzYURmdFl1oaRMXqaknYLBnGpwt6O3BkKsp+PKnMVCppQa8A7VEMaYP0Nqd6Rt0dGskasP9RVcRAekKXUrldSGgl/evNYei0mNm94pkEHhaEvFwQUgrjqZgmMcqg5H3d
 NiZY6ntf
 LoVkRS3Pq1FuqvkH83+wuEfewbzMVPXTlY/A+jXmhHJJJHIS9AzUd57noXeMoaYzn0HhmvSWV/z7BEbbsilK7kG3fx3z9qPwL+Q5FEEl/ze++u0WyKy4Y0M9RTskx4CER+9u7ssYV5QIsetaXj1TpJoI1Mf3izxYSKr6jcZ9tiDVjhCej9lBqdq2pzlQNo/gAvAWOiYFa/nd0ziGn8c2s8BhzvotSGhznPRHkYW0OsMsmVUKvARHR1rSBg/xyC+lnTvbcuJ3Ltp8tKLYYhMtkZV9BNGHIy8Bbjv4FCTE6592JCpkgoq8BbWN+YO5k68eVClYCrtNurNomW1k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 11:55:21AM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/14/26 09:51, Gregory Price wrote:
> > The dax kmem driver currently onlines memory automatically during
> > probe using the system's default online policy but provides no way
> > to control or query the memory state at runtime. Users cannot change
> > the online type after probe, and there's no atomic way to offline and
> > remove memory blocks together.
> > 
> > Add a new 'hotplug' sysfs attribute that allows userspace to control
> > and query the memory state. The interface supports the following states:
> > 
> >    - "offline": memory is added but not online
> >    - "online": memory is online as normal system RAM
> >    - "online_movable": memory is online in ZONE_MOVABLE
> >    - "unplug": memory is offlined and removed
> > 
> > The initial state after probe uses MMOP_SYSTEM_DEFAULT to preserve
> > backwards compatibility - existing systems with auto-online policies
> > will continue to work as before.
> > 
> > The state machine enforces valid transitions:
> >    - From offline: can transition to online, online_movable, or unplug
> >    - From online/online_movable: can transition to offline or unplug
> >    - Cannot switch directly between online and online_movable
> 
> Do we have to support these transitions right from the start?
> 
> What are the use cases for adding memory as offline and then onlining it,
> and why do we have to support that through this interface?
>

the default build config does this, so anyone using the SYSTEM_DEFAULT
will have to at least support this unless we want to change peoples
existing systems.  They'll expect to use the existing pattern.

That is:

add_memory_driver_managed(, SYSTEM_DEFAULT) -> offline
echo online[_*] -> memory*/state

If we disallow "offline", then we essentially leave it "unplugged" and
the second line (existing user policy) breaks.

I thought this would be considered "breaking userland".

I could see disallow "offline" if the memory is "online", and just force
"unplug".

> It would be a lot simpler if we would only allow
> 
> >    - "offline": memory is added but not online
> >    - "online": memory is online as normal system RAM
> >    - "online_movable": memory is online in ZONE_MOVABLE
> >    - "unplug": memory is offlined and removed
> 
> That is, transitioning from offline to online or vice versa fails with
> -ENOSUPP. User space can do that itself through sysfs and if there is ever a
> good use case we can extend this interface here to allow it.
> 
> Or is there a good use case that really requires this?
> 

There's no good use case, just existing users and expected behavior.

~Gregory

