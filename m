Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A7F3CF6A86
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 08:44:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BDCA6B0093; Thu,  8 Jan 2026 03:44:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56B476B0095; Thu,  8 Jan 2026 03:44:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46D776B0096; Thu,  8 Jan 2026 03:44:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 331F76B0093
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 03:44:10 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BD3CF1A05D2
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 08:44:09 +0000 (UTC)
X-FDA: 84308159418.14.3FA8F8A
Received: from sg-1-109.ptr.blmpb.com (sg-1-109.ptr.blmpb.com [118.26.132.109])
	by imf08.hostedemail.com (Postfix) with ESMTP id 436EA160002
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 08:44:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=I7EVdV8+;
	spf=pass (imf08.hostedemail.com: domain of guojinhui.liam@bytedance.com designates 118.26.132.109 as permitted sender) smtp.mailfrom=guojinhui.liam@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767861848; a=rsa-sha256;
	cv=none;
	b=UrSk1MnpN2I5XPzG273JZFrZBe5DqYnlNHijJVbzActzOfAs+A9fCgIlGgemBgPnu07rk/
	tFeSqfMvOUtYtOucxO4sX8Oeq4WeZrg6DTB7dukA8ZtK/Qql4xzL4C/zopWBNmSLyUpSRY
	tmUrn4H67y3eqxb+1pwZSQ3jwLrciw8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=I7EVdV8+;
	spf=pass (imf08.hostedemail.com: domain of guojinhui.liam@bytedance.com designates 118.26.132.109 as permitted sender) smtp.mailfrom=guojinhui.liam@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767861848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N1FuXjS01s3YMgMgzoZhF0uCB3O/s+D9Jm9fJvlCcWo=;
	b=diPOiHjYnSj1awWKF0oa0ALYa4+Brkp3yuwTIeS1abCsm7J+tQVQAU49CuEqe1r4qlH6X3
	pIdiDu/ex32qLbgby7LvHGlCfW0OetmIXZs9BlzmG2S1SlHV//ERrEUCkCd0NuCiop45hU
	ROiNH6NM0rjGZaquITncNoMJE7BpONk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1767861839; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=N1FuXjS01s3YMgMgzoZhF0uCB3O/s+D9Jm9fJvlCcWo=;
 b=I7EVdV8+EOk9KvCmJ2bXtrKDnFFxQSlMQ3PDAEY+DGJZDgmBzdwHX0bFiCbNnRx8cpI9r5
 mP/6+1GR4WW6p801cbjP5ynNt6mULVvbNzlk8IelP8eVQhtW0/WXeISYz0OiAIAClZ+ouA
 4DVMrUmFIeGScfZm6Ygi4e5d4/+Az/ERBFY4+EV3OtSc0HdrhZEwgpxPqrpfvXd/f2GK1r
 /rHYz6iFmAGpTcmeeMMtAS7CWY9Y8QV5Nd3xQSyAiaVIeXhAhQAc4eWNApSBBaJMBuFq4T
 lSrGJDa5L7aJmJ35pXojg2S2tq3O8f/U4BkyzLulRHj3kETpAyfLbTg8Pz0rsw==
Message-Id: <20260108084326.1952-1-guojinhui.liam@bytedance.com>
X-Original-From: Jinhui Guo <guojinhui.liam@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Cc: <akpm@linux-foundation.org>, <axboe@kernel.dk>, <bhelgaas@google.com>, 
	<catalin.marinas@arm.com>, <cgroups@vger.kernel.org>, 
	<chenridong@huawei.com>, <dakr@kernel.org>, <davem@davemloft.net>, 
	<edumazet@google.com>, <frederic@kernel.org>, <gmonaco@redhat.com>, 
	<gregkh@linuxfoundation.org>, <guojinhui.liam@bytedance.com>, 
	<hannes@cmpxchg.org>, <horms@kernel.org>, <jiangshanlai@gmail.com>, 
	<kuba@kernel.org>, <linux-arm-kernel@lists.infradead.org>, 
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <linux-pci@vger.kernel.org>, <longman@redhat.com>, 
	<marco.crivellari@suse.com>, <mhocko@suse.com>, <mingo@redhat.com>, 
	<mkoutny@suse.com>, <muchun.song@linux.dev>, <netdev@vger.kernel.org>, 
	<pabeni@redhat.com>, <pauld@redhat.com>, <peterz@infradead.org>, 
	<rafael@kernel.org>, <roman.gushchin@linux.dev>, 
	<shakeel.butt@linux.dev>, <tglx@linutronix.de>, <tj@kernel.org>, 
	<vbabka@suse.cz>, <will@kernel.org>
Date: Thu,  8 Jan 2026 16:43:26 +0800
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
From: "Jinhui Guo" <guojinhui.liam@bytedance.com>
Subject: Re: [PATCH 01/33] PCI: Prepare to protect against concurrent isolated cpuset change
X-Lms-Return-Path: <lba+2695f6e4d+0da2f4+kvack.org+guojinhui.liam@bytedance.com>
In-Reply-To: <20260107190534.GA441483@bhelgaas>
References: <20260107190534.GA441483@bhelgaas>
X-Mailer: git-send-email 2.17.1
To: <helgaas@kernel.org>
X-Rspamd-Queue-Id: 436EA160002
X-Rspam-User: 
X-Stat-Signature: ocqnt7fnjqu8bdnw8kadjqba8o4piaom
X-Rspamd-Server: rspam07
X-HE-Tag: 1767861846-898050
X-HE-Meta: U2FsdGVkX1+6b3K34SAyh+tRz3oc4zh6nujc3X7d2a9PXFTLSKtnTf9l59tS1+aWPf0N5dzIiUhDFWd5ZvfOAI1HnU0lEOfbREAJwbHx1pYc9+iKvxQzN1osEDV5wlxDUwCDwt7Im6NzY/YKOx59zKoeLU8znyI50hRG8k2Ui6YLyznTI83JxPj+7k2ycALfjzeQw3VPxonb+5hG3r3avQeV8UCByxqDSB+xRw22Zmi2uHo7YEpY5F6qXBBnvAbT1dNrD1RIxukq+8JiauAMCBY2KTzPWH3Et1sG2tVXvFb8j5qEwjegRJC1wZIbnEpqZQTqwtGI4HWmKhFbOOLrJf8lli+UWhAbV9eXErM6j5NWHgS8pulElXL1c4k/oBAnH6gNlYQMkSKn6wmhzCO02eVBMDRVaGGSpgqZbuF/ogqhjzvB/U9bSovCmZXQkUTAledl7G+8OpSgwEybo4Gu9P5cgrQdX/ZicR/p6zL4dpJL6oXKCmVEML9mBLPn5H/p59tyNDQzXzAJNCrxWBa8uGUVV4OrMqV0hZji7G4k6oBgvVI0cJuMT0vn9DjNfKY6K8N8grHXHSmWISUyfH8cfE6LK0gOgCIT3JWGonz+b37SHVB3GHrZgLcA8XdPHOvw1l4Ao3FLdnQcm+aiLhrkP8eh+EULJTin8fNbi1LOA79aczLslI2h8SylPSxx4oZGGAsxLQhYyjuwlzmkvZDiNE2KWMrULTOcZYQjuEPW83DGnUQywvdAVRmXyuk8yZyRcAH9ofrSNha1WuyvOOOfnUAfnNCVonOKmrairI0Mj4JcAntQo/rJuUmkdj/oyc11S9Hvlv+NZkOKyeTsMV9J3/xrkncEWbtj4aXJzNJAMfLUhUB5NT0RXEYOwz68fAyvezEA9UxrG26kyO5cibj/hyQ7aGvhlwrkHQsbO7sNZCI9Luzjm+11BTK21dcre10+HzDP+ABckVMA04twgfk
 siZzVaFg
 +Oyw03sjVPvEO8ayJqkTumUtyjRTPwDlEdmJltsNzrd3CYA94FawPJ62LCJ0befMJUCUshMSEtsN15qIBmpVpNZOCHrE1sewwFnqEi195uNbK0qOu/pWANyjzNtrxCpevALOQ2v4ZSeG9XH9bsqtDvODuRValtbkK/KrvjJ7MHjE6t073Zn8hczaUj+SKMCgaltVrfMl6dUZZkkfNlIFX3EQnxbtYQYMQArQVr5fzFpyVrqfafDTmIk+XkGFc/lC2tM3iQ2DNi+E4+60hHxac2bAkhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jan 7, 2026 at 13:05:34 -0600, Bjorn Helgaas worte:
> [+cc Jinhui]
>=20
> On Thu, Jan 01, 2026 at 11:13:26PM +0100, Frederic Weisbecker wrote:
> > HK_TYPE_DOMAIN will soon integrate cpuset isolated partitions and
> > therefore be made modifiable at runtime. Synchronize against the cpumas=
k
> > update using RCU.
> >=20
> > The RCU locked section includes both the housekeeping CPU target
> > election for the PCI probe work and the work enqueue.
> >=20
> > This way the housekeeping update side will simply need to flush the
> > pending related works after updating the housekeeping mask in order to
> > make sure that no PCI work ever executes on an isolated CPU. This part
> > will be handled in a subsequent patch.
> >=20
> > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
>=20
> Just FYI, Jinhui posted a series that touches this same code and might
> need some coordination:
>=20
>   https://lore.kernel.org/r/20260107175548.1792-1-guojinhui.liam@bytedanc=
e.com
>=20
> IIUC, Jinhui's series adds some more NUMA smarts in the driver core
> sync probing path and removes corresponding NUMA code from the PCI
> core probe path.

Hi Bjorn,

Thanks for pointing out the series.

I=E2=80=99ll resolve the conflicts and send a new patchset once this one is=
 merged.

Best Regards,
Jinhui

