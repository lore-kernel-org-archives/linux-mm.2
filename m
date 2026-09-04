Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DDFCC61DD3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 05:33:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 426EB6B0088; Fri,  4 Sep 2026 01:33:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D86A6B008A; Fri,  4 Sep 2026 01:33:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EE616B008C; Fri,  4 Sep 2026 01:33:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0ED196B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 01:33:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 896051606E8
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 05:33:39 +0000 (UTC)
X-FDA: 85174962558.29.7FC333C
Received: from mta0.migadu.com (out-191.mta0.migadu.com [91.218.175.191])
	by imf07.hostedemail.com (Postfix) with ESMTP id 681F440003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 05:33:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="s/fXJIUz";
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.191 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788500017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aH4uD7GTCpQD2ykD3RsY6bcY6MCmeysTDUJsNCvh0sI=;
	b=0zZ0Fk7zGmS/pqu4LzrpdlR1zd59jq/XzNamlw/l9pAwMrnr9659Dsv7J7bmD/Tigj+8hj
	nriQpUPsPz+C/P1uo6rWu/J74WyrCh56Ry5SOJjEupPY7dWVH4ouDXqt1BRvm6F+zYNMoW
	yOE/V54xZ758EjIhwsS0Nnld6X1FIcQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788500017;
	b=tSgoqUvTkSBRIYUKQmh3gm7c5iYDsVIM7I9hUvdPHICfw8uBfPYrorPePOCvMYpKb1YzMV
	wHRn7fI5vpzc/BSGcD4cY1O2NTh/Y8RBY7ibwUK65IbS35ZwlGx0ebP00mFpRsxlg+G1nm
	HbVh24ARXvP4xWJL0ubKNm7bUwz1zlw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="s/fXJIUz";
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.191 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7KwgNRUvE81Flv3MCvzg9gLOP2UeUiR1MgUJyPfduP4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788500015; v=1; x=1789104815;
 b=s/fXJIUzAtbiSf36KY3P7OvzYDYSdjttQUma3z90OPAXzp1iex34YZsj/aVuczyyCnzJvZ0i
 8x0h0pGrJ3TToAZTp+Y57Edb4dC04Yu0xqxOvj92duB1HhWlcJEPoEUV4xc87LfaC4J3dYQq8dD
 RD0MJt2N8pM3PtT2o+n/tBJk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 88679e7f5a2622ed;
	Fri, 04 Sep 2026 05:33:35 +0000
X-Mizu-Trace-ID: 88679e7f5a2622ed
X-Migadu-Flow: FLOW_OUT
Date: Fri, 4 Sep 2026 13:33:28 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Youngjun Park <youngjun.park@lge.com>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	nphamcs@gmail.com, baohua@kernel.org, hannes@cmpxchg.org,
	yosry@kernel.org, shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev, david@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/16] mm, swap: refactor swapoff + add xswap_destroy
Message-ID: <appYKKppIlwJ7vD7@fedora>
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
 <20260827094509.1016740-15-hebaoquan@kylinos.cn>
 <apkaxIJRdo4zwnS1@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apkaxIJRdo4zwnS1@yjaykim-PowerEdge-T330>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 681F440003
X-Stat-Signature: sp6xazxm3eb1zgep4nt7pz89r1q7mi33
X-HE-Tag: 1788500017-860962
X-HE-Meta: U2FsdGVkX1/vmgXIOMztC6BWj8FzfodsBrG+pLru8pac6um/OlDI/ECt3q1c95FGBnBfe82JV2xehUmBWrjTgLGeSTIVMDH6VeoWsQSfTvATHHNnVFlK/O+xJDA5EUsl+tOmF/wHPP77aI+6SRZm2gVkfcg1eMYWE956FDKqXzMoaWTn6UkjThim5PZKN92KssSMUf2Jq85HWZxdoVpnDrAa0NH1H5OhR9O7yHI8UJzki78viDWtp5MkKcjGAMmj+K8kDiQ1hC8Sc9wnSRxgRz/2f5/cFI+DDWq+LpIaHBve2kMKRduS0RGoI1D4EMjKwFZGWva+d5A7Y7MUS44Z7PkQi3or7nAOMUie08bqKZY+G9I7hBytPqAcgbdR05LLfDitQ4w7g+/0UpADcZ/toPPZwxBFJDN4z81rf2bJu1Sb3e7zpUtE02IE7PSmdi0ljFsbSCw8RoSeIHZtFcOQ/3vD5FrwJ2HVK8GqmELF0zn/+NNe/MHLllnXPyb1fFtxqwyi150cQmex4ljTWadVbFKe4gUJdvD7QwtSbe7HCs/GKa7ktWmUcqhjfgqo+scu7EnQqEX+hqBYdXnT1d9/K4r8nitXrs5AThOcg+j0nB/cgZgXiSSm7HjID5LDawWygludhZ/38eXReRFVx8uePMRG9T12v1HoXgjv0Uj3UrFdm8izN/xuO/Q+yRDnsjphysoGhnhHr2k5KA7psJxsMvX4+AzEk4WgQnFIo3yZFDhkE7voT5dbqQvPz8oaGm2CX0aaqEQgW30ZV+x7lY/sGDJaBO8e1ifFnb6Xgjjv9fJkcoLgb1oSSPo/Kzms/7n95MBwX8EgzbI2wzd25QsA0v4rmYV1wYALZTEkQRbIjgGTNdvYz+eEJrLNI3bezJvU5plP6ZE8yCLBADsa4sDPbItUxmMoJ+2+rSaXf8GNREW8djx/EmnZc6KO+5AusyChU7pRO8C4vdW+/N33OWh
 Xwst41iC
 eEtYHz6/uQ0pY4qS1pSWH9BRV6yl8yiz/mYVpP+zI9HXXFl/70wCTCdMBdqq576T4JvWeX6TpGPV4yS+6PBi6fPmEg93VCjFw69e/KPk1b3O4mfKqRrr/khfN8W85j47Nz7bLtFCELzSKgJ/0fdxKta+4Y5lznI1KCL7JUDtlB15cstkEp7Mg7RRYnHMtMp3lUBiDpgkyRR/TSZH4TqoljQinrDkIN2X+qylWcxvxAQ9lBw+OTHPdss0yye90ux3NUV0JVrMFSnYZE/bOveqWK3JlYfbn6/v2euaViJWd/PhVTXsPbvBs+IpQcWNTGEswDlS2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/03/26 at 03:59pm, Youngjun Park wrote:
> On Thu, Aug 27, 2026 at 05:45:04PM +0800, Baoquan He wrote:
> > +/* Tear down a file-less xswap device by its swap type. */
> > +static int xswap_destroy(int type)
> > +{
> > +	struct swap_info_struct *p;
> > +
> > +	p = swap_type_to_info(type);
> > +	if (!p)
> > +		return -EINVAL;
> > +
> > +	spin_lock(&swap_lock);
> > +	if (!(p->flags & SWP_WRITEOK) || !(p->flags & SWP_XSWAP)) {
> > +		spin_unlock(&swap_lock);
> > +		return -EINVAL;
> > +	}
> > +	/* Refuse swapoff while the device is pinned for hibernation */
> > +	if (p->flags & SWP_HIBERNATION) {
> > +		spin_unlock(&swap_lock);
> > +		return -EBUSY;
> > +	}
> 
> non-blockfile swap device must not be chosen for Hibernation.
> There is no space to hibernate.

You areright.

xswap devices are file-less and zswap-backed with no disk space,
so they cannot host a hibernation image. Sashiko has reported this, v2
excludes SWP_XSWAP devices from hibernation device discovery (both 
find_first_swap() and __find_hibernation_swap_type()), so they are never
chosen for hibernation.

