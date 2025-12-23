Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15C5AE6F086
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 19:46:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 649CC6B0095; Tue, 23 Dec 2025 14:46:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CD186B0096; Tue, 23 Dec 2025 14:46:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D9986B0098; Tue, 23 Dec 2025 14:46:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3ED1E6B0095
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 14:46:32 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E76F8B97FE
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 19:46:31 +0000 (UTC)
X-FDA: 84251767782.10.89E83C3
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf11.hostedemail.com (Postfix) with ESMTP id E1AB74000A
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 19:46:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eU9K0RjU;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766519190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6vzEZcO5hVRV8zIXh0SZ6K9qj2jT+ZzhCbLviEbk4mk=;
	b=qGcWGZLpmIKwWwvTVA+yxx39rjc0JYosxjXXPf1tKBAgcMwC6e3GsNiNB/ho8wVAomEjtO
	/H4tNve9Akh71Rb/4mhP0ACbH2eh0v5NXp4+5CMC2xi5SYc8sdIvNNZDhj3eHYOjKxXqg3
	H9g6wd3rc/23tu3RCtpFw7cbVbiFJRc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eU9K0RjU;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766519190; a=rsa-sha256;
	cv=none;
	b=N4IeLi5fTMjJYVV10iidUa+wWNc2TdcW9dA4tWk66XtEkft4NTcfBNnbGvYdDjxMRDNuvf
	6lN57NSVznSM4fzG3aMUd2nxeqbLZkZNQZBKyG/AAEjMxqBPNwq4qldq5zCK5PoMIGcHRw
	t6NwbxlOCN8HkJ9b8mMV4h2p7VhOC5s=
Date: Tue, 23 Dec 2025 11:46:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766519187;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6vzEZcO5hVRV8zIXh0SZ6K9qj2jT+ZzhCbLviEbk4mk=;
	b=eU9K0RjU0zeKvccQ9oR5fEIkzhnG8y76apeoFH01jiVk905Jwv1zT6cFYhRE8YRkQBEbWA
	V9pkhZQ00aBkVdRlwTyfU2uMoqHr68W30/+CIZ4hRWeI3kcX4BlCgNts+t1PN3/GNOSGU0
	hxp7Me3b8nWtiUVNDnuP4BfYV+IhVPY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	JP Kobryn <inwardvessel@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Michal Hocko <mhocko@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH bpf-next v4 0/6] mm: bpf kfuncs to access memcg data
Message-ID: <gy7vymh74pfh2oeo7ge3d27rkctbumunrkfcsqnhsl5jafs6yv@weu5dmztpvz4>
References: <20251223044156.208250-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251223044156.208250-1-roman.gushchin@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E1AB74000A
X-Stat-Signature: s88pdx6ake1n6ksjypb65qh3dr3hjybj
X-HE-Tag: 1766519189-740479
X-HE-Meta: U2FsdGVkX1/dSrNnp4S727eC+JTUQU0kjDC0zOvVJ91zy4gxNnQpGFhxkmCNZHA+lZkwQBfRt3/H5OZhpvYV+Uw3DyiiB0PC8IofDKXQKjRTYeCTmDNi+lQGcL3IF/3t/ZJXBYSxEUcpVoEjwbUDDh9ecACOSWavJzvDWFTIAFEMGFkLnjUUlAt8sJ6g9I22yzQ0f5IiWVU6E8ttWEUpcB6E8zi5XId+5jrxqV3BZIWxTmj1SS7AUx7vX9Hi2vzDA3yd9axxKZGa8huxYsvOlECLGj3Ceqlgu5sSnq4OQ31PYP9njsRJiW/wHvGF3hwCCNs5/VppZJ5qGDxUhaWWp5t1/8Bj9Z+HZQeiYufTy8UMKSb9hGtQ1ggoC/8uJYFl+FA3WuzfCasEepc1qiFaJ/wRnEtF0wIWJ1YQDmvJICxrp6qhBMF5Yy15yyFDUVYw0OC/cr/zzIE2ks2ssjo1HtvRrJjsKDvLzqyjC9qd7WZp8HAThI0tCLUVey4wtIJRa5e6CRM33AvsYNYJIF7y/t0ZGznL5iiwAhAGtcVRR0xFAyrppabfskGgrXyCkRMU/BS3jA7jg+aaOgqv9PHdZkHac235VENq1O2RXlPSW14BdwFaY0w8L/wh11dyyYrQQvKcUq5JwH55iFD5xJLW2ylxBX2zOePv8F6cXdkM7PTFytrnOe4kF42uqEt0kAfrMfmtkIuC2LwoG3E7m4n/LhiqD3VIw1eUaGR12DBElgNagte+tC76upuw3L9KARxOxjh3D6L0KtkjW9gxdXyjI8rTf7R6szXrLgaAHRLdbvT0uMvQHny0UgieQAYCRdAwN2Vbr5eoJeuSVmmTnKLr7v3X5r0G3f8EFOGbh6+wpMGPobcuVzdpx7ZdOeXCWuq/0wvaCwL81xwo5Dertj2nSli0OMfIb0GSrmN5pzgsLIHB7QOGxHI+OW2eDckRKpQP+D9lG4hc4YBQzwKRv6/
 F2cIREio
 y5p/cqSyGD5lb2X1vDac2SGCWhKYC9rHMQTV+cMMjyH1DjPPoIpSHRPKFz/oWceDVt+/0RzmlPl+dia1gx6TUYFU2qqIq6/PonJ4pWa1tw31WdmyQ4TerS9JkzI/Zd89ACGrcrhYyR9gYbDR0Xuc09IJCoUvyBFLqVORf0lRZFJdhJhYacv9qfzdkGGO2+ysc1QY9SiFXHFJ31rjg/zYDRhcYNxMN4iPmvqVqUATyJG08cGw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 22, 2025 at 08:41:50PM -0800, Roman Gushchin wrote:
> Introduce kfuncs to simplify the access to the memcg data.
> These kfuncs can be used to accelerate monitoring use cases and
> for implementing custom OOM policies once BPF OOM is landed.
> 
> This patchset was separated out from the BPF OOM patchset to simplify
> the logistics and accelerate the landing of the part which is useful
> by itself. No functional changes since BPF OOM v2.

For the series:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

