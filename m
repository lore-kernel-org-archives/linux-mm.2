Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38CD4F94CA2
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 01:48:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F3B66B0089; Tue, 21 Apr 2026 21:48:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A55A6B008A; Tue, 21 Apr 2026 21:48:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BAD96B008C; Tue, 21 Apr 2026 21:48:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 65F956B0089
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 21:48:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 25FF4E699D
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 01:48:20 +0000 (UTC)
X-FDA: 84684506760.22.E13D03D
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2742320015
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 01:48:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uYYPg5af;
	spf=pass (imf13.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776822498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Q/C73m2ud1wZ0KXWo0mIOVakWeAibL2+LZFP/oYci4=;
	b=8LSKQhJ+YFJ+P4Go9h6lgoQE6jfmO5cIcqtFZ3zF4PvS6gRAgJ6KCpc6+o9kxrMOGbFytC
	+mB/jmjGrg/nmOHyeN9OXfI3LhLu0rz7XSJl7dWIfRrlXGnIVfAsWXA/umEkrH2VTEMZ/r
	hKldwkhjXsuRg0GD5NUuLB3F27w4vlc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uYYPg5af;
	spf=pass (imf13.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776822498; a=rsa-sha256;
	cv=none;
	b=0zKiBe9iEj9Jxv3ZiqRB8AXQhsa0aFl2xD++YdJbb2N3lQVbpjeppcCFDsSRKAJr0DSFwf
	N549hAXP8/QKSOdRa38Kecjlja7DZ90pQqy1WwveAPdMXcU14gvYtLJzEQRKKKHIwm1E3I
	oTiobO0BoHTHM4B3kdK3P8KyWbG4kSg=
Date: Wed, 22 Apr 2026 09:48:05 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776822495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7Q/C73m2ud1wZ0KXWo0mIOVakWeAibL2+LZFP/oYci4=;
	b=uYYPg5afRpbDLM6CFdKyq9HrrEUoHCuCx0PeTwqnal5qZbtXXRGw1JWzRC7Vclp9NtjQYt
	ynT+KgeXxlcRPrZvEWvcd6yn7oSfHHLlRfEzFcaHAzRCXb3qq2iBeCHIZ53RB+C3+p7k3w
	Pm31zg4DmnUkvkB94MbrrDK1estlRkU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, usama.arif@linux.dev,
	baohua@kernel.org, kasong@tencent.com, nphamcs@gmail.com,
	shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/3] mm/swap: use swap_ops to register swap device's
 methods
Message-ID: <aego1T9d6PVudYqj@MiWiFi-R3L-srv>
References: <20260417033951.1111038-1-baoquan.he@linux.dev>
 <20260417033951.1111038-3-baoquan.he@linux.dev>
 <CACePvbWZO-=Nwho9Hfk-2HpuggZyb+Yt306MdA4X_icAt6+Z9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbWZO-=Nwho9Hfk-2HpuggZyb+Yt306MdA4X_icAt6+Z9w@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2742320015
X-Stat-Signature: kw3zcm1wpui6i9sxs4a1hjbwz8sye83p
X-Rspam-User: 
X-HE-Tag: 1776822497-183314
X-HE-Meta: U2FsdGVkX1/MW7Zod9rVE40o+jlNpiJNZ3PXaEuieRh+rtscC0ZKhODqpndHTxK1W0AtGzjlGNsAbkWYD0PDiuUXQe4r2cXnnSZkCtKZseX3BXenIhx+vTAlSZxxH99QgqeJgMjgKUMQ6GeOKSnBnnCw5t1MYVQIdCcLe9m06l3rAjI3vQhD1W50QbgUBMuRUy5hWqE3sbrcwLdfPQisOvN5n9B2S5aCTC64WnHp9Bb6Zu4/4j679CahF6/gKacCvSB3BK3ANf5EIeX8f/MLZAse3yQoPSUQYnbnf1KGqE1TKFwmCZ6a6Vl4e+Hp+2MACBx1Kpzaz0m8//W18+APdUgmejqYaEN+cxRZLF4qD/Fz5OTRjm0NrsIGVaugmE1K96uLYx0eCR1AdNIv/AXyt8FQ8uzqKHgaXb7DlV9SNRIV6Pf3i3Fzu4JgEu9MoQbqyAcFz5Q8b6hWxd02lNvsMrCVnRlYAGpgz8JfaS0rWAe0kmUx2+eCcAky76K8ZN8mWO0+TCDOG9MgbkFxEyXShgQEheG/E2B/I31J/Mg0KAdFamMbPX1Rmi8J4tauV0sAA4Aw+2730UIc+4AOSNCSAOxHarDqSzU88XqBM8XGPHtf7537kXPEVghjQ0xvQq4GU8B7L9OlPd7D/DQV5YoK/hNC7XHNLWA6QZ2kjVRbve+8UsU015AHBFVq0B3GPQMnPWxGq7C7OlJaWTotEij/8PPiTcwKn/6ZKobn+ttYQ1CnwfBc3yxi1zDG3DRR3mhAYquumH8ongDHKXZOxyfyvBMbbT4Lw4JFnPWqjcJNIL3maZPOKTKh1ELrUnXE7TvQHYMUgGbRuxgUUPvVYJ/l6q91JljmnfjJBWG7tVckpj0NPVaJt5gE0blr0u+EF70Oapj4HbfsCOoiOcue0pKQwmX8AjCBYKJd4Ese6RIdeaTPEi81tBAOFJ4DU3sdpuCXSdWoCqh+fKzp3deeFyu
 a5nxASZQ
 cAENADxEg0R78koBJ2NHLqoQwpHqVcRXrTKbs5W+WHhlBbYgmdgpO47ey303i2cMI7yL8Kn8Oh/bxogqJUPDUw76rjtrT0DC6W4GGoCBXjinwwCoEBSp959SGzVegJ9J5Oh/fSyoQFtWtnvaZ276MNrvFFFbZg+SDl7xZ6/kb/WOcoQSLhsr/VtHQk/GTTwFeI6MZdC0zYFameUY8HEMwm7QNqMir9gYy9lJmlCT17atQJyhnOFZl+Mvv/89T4/O0rZii8dXlCjw6y+0el7l66p0PYYx5eMlyPeVPMEYG7x8NwFmsE0b3q0p+vRNwv+qSWzE9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/17/26 at 07:30pm, Chris Li wrote:
> On Thu, Apr 16, 2026 at 8:40 PM Baoquan He <baoquan.he@linux.dev> wrote:
...snip...
> > +int init_swap_ops(struct swap_info_struct *sis)
> > +{
> > +       /*
> > +        * ->flags can be updated non-atomically, but that will
> > +        * never affect SWP_FS_OPS, so the data_race is safe.
> > +        */
> > +       if (data_race(sis->flags & SWP_FS_OPS))
> > +               sis->ops = &bdev_fs_swap_ops;
> > +       /*
> > +        * ->flags can be updated non-atomically, but that will
> > +        * never affect SWP_SYNCHRONOUS_IO, so the data_race is safe.
> > +        */
> > +       else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
> > +               sis->ops = &bdev_sync_swap_ops;
> > +       else
> > +               sis->ops = &bdev_async_swap_ops;
> > +
> > +       if (!sis->ops || !sis->ops->read_folio || !sis->ops->write_folio)
> > +               return -1;
> Nitpick:
> 
> For int type error return, you should use  -EINVAL or some thing with
> error code. If you don't care about error code, change the return type
> to bool instead.

Thanks for careful reviewing, returning -EINVAL looks better, I will
change like that and repost.

Thanks
Baoquan

