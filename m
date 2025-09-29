Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76C2BCAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 20:30:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B83488E002D; Mon, 29 Sep 2025 16:30:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5AF78E0002; Mon, 29 Sep 2025 16:30:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A70778E002D; Mon, 29 Sep 2025 16:30:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8FE888E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 16:30:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2A1CE13B1FD
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 20:30:27 +0000 (UTC)
X-FDA: 83943430494.11.A838301
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id D2DBB1C0004
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 20:30:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AUqgQ+eJ;
	spf=pass (imf20.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759177824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ED1psDbRxh+awECp5ObirtrhKEHX9W6DPJ6DbuNO3yc=;
	b=dnaq5yyAAx1c8VKwiMpkHt+D8Rcla56XU0ihJ51A6B5lQ/IBoXKnAXjFDan9747fHBYf3H
	k/N/NNX0hsp9n2AkDCgTK0iS+AmEAmEojhSKiUvr3Nusq2RvCB3lkl4FFN/AuIu+TECGvP
	3wPHTPYXOgUF3PFMZfowE8aW6i5qSZU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AUqgQ+eJ;
	spf=pass (imf20.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759177824; a=rsa-sha256;
	cv=none;
	b=4ho8a2arTKjRux8mlcuy5lI/XmIMAmIGUrnJ8opRKKj8j+ag704+C36bDEjeargdlv1knX
	q8k+jSckzt4T48Kt3xGtlQCn7+XKps9LZlXbT9f8HgWFvoBJI9m3NsslWCRqLOlUEau4//
	vG6F40WnhBODos4E9+peHWY28jKu52Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759177824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ED1psDbRxh+awECp5ObirtrhKEHX9W6DPJ6DbuNO3yc=;
	b=AUqgQ+eJfa5+OLBGnS0pz/d4WT92c1ZJgx/OUnor+0DW4K1mEo6+RUW3MSp3dHVzbzkVoX
	D0ybU0n226293Swb1keahVIlMyqYEuJM4U9VSVBpbxje0nGe3dnx+RK8dJP76ZVExPvdFj
	Np/EVZY1jAfqSRdomWBrPnymY4xTffA=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-151-UCkucCb_P8Kj7vn-9M--iw-1; Mon, 29 Sep 2025 16:30:23 -0400
X-MC-Unique: UCkucCb_P8Kj7vn-9M--iw-1
X-Mimecast-MFC-AGG-ID: UCkucCb_P8Kj7vn-9M--iw_1759177822
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8635d475523so605957085a.3
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 13:30:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759177822; x=1759782622;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ED1psDbRxh+awECp5ObirtrhKEHX9W6DPJ6DbuNO3yc=;
        b=KdN6GNB7QGOXcr+oZpd35ebFly6WZfGE2ymvL2fbYaSs3AL3uEdQ7BfZ9CNFP54hNx
         0PMyQj89Nfb6kRGoH3i7UOOaTSEdJrkmOwIX9q/Yag9plK8iPTXJaGoerihz3jR07fPx
         g720yYLMVX3e+5rzjlfmknJUV13npj/8UmneS2KbykJAh/lipXGt8+yvCCqccbzn9pO+
         CRaIsdtSEV9wP56XZDSljupASDXbeNqFAVkc35U7EkWG1eKd9SlMblutE0FGZgjKFdKU
         FtbgpE2cqz+9AL+XtPPKqN67hqwVBdKNOU9ovgSWZ4+dUNTgF5rAHwbtsQ3ZODE77KMh
         Vq+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUwYMzkJC94W8gocIiuX8IqeaMwGSBQ749EwSJahKfFej88eE4ZlhXvfdRO8yRgnSLO0WpizX8g+A==@kvack.org
X-Gm-Message-State: AOJu0Yw2cvxblDNnp+W25giYOBdBmdE7ZZjmNlLJg+R0hENkZD/Y+NZU
	wUDhWcnr5Qm9cW7SirM8022x+f1f+eadygbovdkFmd0UG78Xgr/fp3e1xAUzuXBuDOtdaId2Dkg
	t9tVT4rvqcrkdjNCMKRy0TdDc7XSrAGbtSKS+nJZ/wulfQYg76Kqpitp7uF0m
X-Gm-Gg: ASbGncuDbi34EWatdsalz9CmdI/VU5QDoou7xoueiouqIhs6dVDwbrjm25E4mjj2XIE
	qUGFk4rE8195LGrT20u1eetUqoLY/q76xsRYDToDy93mQ2wY7n2NWxR1KtjSh+rt+EtDDFu1Iyg
	u1DZAaVkxbl5w4Dh4lOfyEOtrBKxnko9lCnvAa0Dlp2IBC6+tH6zYDiM0gcKjAjhU0+OI+n9Qzl
	lxUfKhuJceQLRdaAsDR5eIHAJKPm0Hlpa82144i86zTlYIo4D7mCBDUs4w2gnvyAS6EEKG+1dcT
	jImTuMPw+dgLZz4ZGQwedng+WJFLQ2kd
X-Received: by 2002:a05:620a:a081:b0:85d:aabb:47eb with SMTP id af79cd13be357-85daabb4f6bmr1567704285a.1.1759177822073;
        Mon, 29 Sep 2025 13:30:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFoX/kLFB0raBhDVSgUsXtnHy2vC9HP7SOMsWy1u7H4bghzZYyOPvSYloRcGn2gZ7C3qhVxew==
X-Received: by 2002:a05:620a:a081:b0:85d:aabb:47eb with SMTP id af79cd13be357-85daabb4f6bmr1567700885a.1.1759177821570;
        Mon, 29 Sep 2025 13:30:21 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-85c2a1913d5sm888620785a.31.2025.09.29.13.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 13:30:21 -0700 (PDT)
Date: Mon, 29 Sep 2025 16:30:20 -0400
From: Peter Xu <peterx@redhat.com>
To: "David P. Reed" <dpreed@deepplum.com>
Cc: James Houghton <jthoughton@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: PROBLEM: userfaultfd REGISTER minor mode on MAP_PRIVATE range
 fails
Message-ID: <aNrsXJsKaw24ADAp@x1.local>
References: <aMmMnfU-Koopc9mL@x1.local>
 <1758043654.112619688@apps.rackspace.com>
 <CAJHvVciL-6OLMPDGQjZ=VGDwvwKJznq0BL49uSj+DSq63LOUYQ@mail.gmail.com>
 <1758052343.971831541@apps.rackspace.com>
 <CAJHvVchHKxiVKFjUz4ir4PVDvUihLhiSRMBWqpMEZfwLdereuA@mail.gmail.com>
 <1758306560.96630670@apps.rackspace.com>
 <CAJHvVcj_gd=48k-dgbLeEoqn_f+QD-ifscu_DPvpAmPd1Kg=GA@mail.gmail.com>
 <1758998720.44976697@apps.rackspace.com>
 <CADrL8HW0eNsHnEsEdKYRNvFRBMvrDMrHawa55Kik9QFeVNEwgA@mail.gmail.com>
 <1759175092.67312651@apps.rackspace.com>
MIME-Version: 1.0
In-Reply-To: <1759175092.67312651@apps.rackspace.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: O8lb12Y6dIq0vAtuDGt9HW59n0SA9qY0oqHc_r0gEEI_1759177822
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D2DBB1C0004
X-Stat-Signature: qanoyrw1pgr8byigitqgtp8pkdiuauuh
X-HE-Tag: 1759177824-610960
X-HE-Meta: U2FsdGVkX1/0ItHpQBNYvVP12wEBWKk6VSfTjgZOwaO7MFy1XwdI/sTKMwhVXc6rEFCeF6VPSST7jkm1eQwLDV+2+HVPbrjmvgmRxcFW6DSo/Vzi9HjmTYBOL7o1kdd0LzpLL03cRJpxynizo81xwrDSj+/o+8MqC9pDb94NkvJKyl0DL1lh5oFvUkj7TL0Vg7R4ellSE+JH3iYWGoN8iKrDzXvlcYm1PXt9K7sissTOleGd2PnbJA+wGojzd7SZAR4bNvCog/w1cTn2cHBnJzgZ8Q7HLKFb63awqnbAcJqc2xKNqpUZxtUlykTYyQ1s3kRbLY+BN2bfuT9zD+o1pxhzo/rxSD/IAzW3zDvNMu5v8xC1Mx5YCyIv9YF6DFwYhz8CN5s50YiTLFjfg/5sFrEJRI4R8dNYg6xflp3WXtTDs4VCywlDEgws4vNxG0Tn4etCufErMmJIKiKSCyYukag4Tbhxe/3aBZWtIqYFDNxJMRoZNdyE5i9f0ZPnWq8vWOmuW9MmtwVpSYZ9f5A4+g69noKulcKFGve6adN96B1LvQ/PY2Tg8a5mkqZNtuM7+Uk5uBIn63Aw+bcRM5cNbw4V2zGJk50e8BKimQRUvrbSLeWB738uECY/aMBYGEGbOYFKugqjsIu06Jr84QzrHK4n1snDb8khACEn0F06bPa7O+5i532l8mjvyLAHDAb7nf88LFxDrj9lpnD8l+I1z4+feAcQxQCjqnrtBcUUeNFo0OhE2hioI1qHIqeDOqOWKxSi54IKyCUoOCcbi14JDPvIV/bSOmfddzArO/uPwNc/DFGIqAYP384mqb4eUzlwFWCG+Rpnakwmf+iDck7CgLBHxrm/oyiQxmifdfIuxpCx+kGYrsoGY0nxS1HivYbWJtJNcarq+7RAyCV59pQMmf8PLsEVXa3vWqjrbORlQKeaKQxqmEqMXbWjXOdMaIsqTThs4v+O9rxlnp9QzJP
 3gB9Rocp
 tGHuam9akAUy61uxJDJ7Tg1s0EamYhhk6qjJQ2c7kMX0P9dgFTfW05YjEZlq/8CGjPvl70MVTjLLfY6WEjhiro5yFYq7/u8IhfMs5B6/k7WKx/006x9o0xfD72yAzdGpKvyMAZAEk3gGTPfRwrJBKAtRLjj0UctNlkM7tlB7OAUo8Psg/HYaEvFBwwdZOXeYFj/nFWmVs49RmcjB7vfapUZbvX9IA0BJAMuwnO/i4idqYwGm63ATOshyWJFXnokG7lSdnWl1SzFUW5FQU4bs7QxRn4uhjU/ucoyfKrvWjTBiorgCZ6QuNpZC/4zRAfxIp3npw6NW19HEaKBgEu0z2u3zoYLriO/15buS/tnaNc0n9IfPkoLbdaCsJwMn2/7jCM+Egn4wvA6dt8mcjNM3VyJ6BKMibptkNUTIkFZdJ09P8BpLVvrpJmhw4CLNPhvt22x9vN2FvjqGr8e7VS5x0cqSb/pCm63aXPIJ+FJIpEE8IM0grtROE6JfRXozCnYoIpaMp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 29, 2025 at 03:44:52PM -0400, David P. Reed wrote:
> I thought it was a general purpose interface. My mistake. But I think it
> can be more general, at least encompassing my goal of having a userspace
> "interface" that monitors processes' page faults.

To James: thanks for the great writeup.  Somehow, I just feel like userfaultfd
(as a linux submodule) got some sheer luck to have you around. :)

To David: just to say, I still think it's a general purpose interface, at
least that's the hope..

I agree with you at least on one point you mentioned, that shmem also can
swap, and that was accounted as minor faults when swapin happens at a
specific virtual address.  It doesn't sound fair if anon isn't doing the
same. Indeed.

It was just not in the radar when minor fault was introduced by Axel, even
it was for a solo purpose for live migration at that time.. but the hope is
the interface designed should service a generic purpose.

Now the problem is, userfaultfd wasn't initially used for monitoring system
activities.  As its name implies, it provides the userspace a way to
resolve a fault, but only if a fault happens first..

Meanwhile, system activities should definitely at least involve swapouts,
which unfortunately doesn't involve page faults, but only happen the other
way round when the system wants to secretly move things out.. that is what
userfaultfd is out of control.

It just sounds like it won't suffice your need even if we could add minor
fault support for anon private memories on swap cache. However, if
userfaultfd is used to do everything (including swap in/outs), then it's by
nature all trappable + accountable, on both swap in/outs to/from any media.
Then swapout will be driven by the userspace too, then everything will be
in solid control, including monitoring of the activities.

Thanks,

-- 
Peter Xu


