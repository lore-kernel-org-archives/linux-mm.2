Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA99B606A32E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 08:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H5N7Zrud
Received: by kanga.kvack.org (Postfix)
	id DF8B96B05CF; Wed, 11 Nov 2026 03:48:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D821A6B05D1; Wed, 11 Nov 2026 03:48:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C70746B05D2; Wed, 11 Nov 2026 03:48:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A693E6B05CF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:48:13 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3E50016025B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:48:13 +0000 (UTC)
X-FDA: 85422211266.23.48B1022
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 942001C0004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:48:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H5N7Zrud;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794386891;
	b=x76IfKhfa3RJIvUbvbUv6R6CdXo5NOyZ6W1GkATUWN6GfnKS0CggCaBwW3xUe29tIsDh8W
	h3Ry9zzzGnwZzKfPSQH9G9Woso4/86oowSu00IVvWTK72CCHmfVM8/pV32f2FiHGAKTM8Q
	WcHgppDsnBU8LbowlQt2wB6Qgp2deSo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794386891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aNLBnRUOOTL7tx4y3L3gcUkjBYqMniv/b4tCvxqDYJ0=;
	b=S11dIhyDFP+vBBMgaFcVzfVgjgjS7S+IwoKCKs+d1XOB+xneODAm9yTIT+HaFxKuhTN38r
	XveHkVBoRwFxHTaRdieXbndJceEyTYsxCAmxmZtHRNu+rYy500W2W97JoTcZUS0H+ruG4x
	Bsv/mrDBSpkTfw68EyQov98TIGlP+dA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H5N7Zrud;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 199BE61CCE;
	Wed, 11 Nov 2026 08:48:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3818D1F00A06;
	Wed, 11 Nov 2026 08:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794386890;
	bh=aNLBnRUOOTL7tx4y3L3gcUkjBYqMniv/b4tCvxqDYJ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=H5N7ZrudHWzkIgfZxXk7xBYZ++P+0L4owLET8foVocNlNcYmd9dJ6OW6ETC4ogmcU
	 nWZMaTHBkcM0MUlqspAboSHRChVa3n+fwhrR90HKGNDRbBjbMomZtDrWpEDrsr7kGu
	 CAJGV1pnSTeCiKrIj91IqzOaGNjsfGLuxgdw5m+FxcAU1rq1ooNDZwf/rVCGgXNuX9
	 wNuRJ0fUoqjXXiP6edoggUnFL3a5gaSnLnhjs+x2f2QtOsQZKD3Wwizvy2l8ELxvoD
	 2izvUwWuYHOM+/M6u3/Mt0RdH3QLQBRcCvkpwCaDTSzi+RAAylK9U9c7v82nXPBOts
	 NIkdlAh+XJazg==
Date: Wed, 11 Nov 2026 08:48:06 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Xu Xin (vivo)" <xu.xin@linux.dev>
Cc: david@kernel.org, akpm@linux-foundation.org, chengming.zhou@linux.dev, 
	link@vivo.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	tujinjiang@huawei.com, xiao.wang@vivo.com
Subject: Re: [PATCH 2/4] ksm: skip rmap_item allocation for non-zero pages
 under only_merge_zero_pages
Message-ID: <avQrosxY3dUIx6jo@lucifer>
References: <avMKhCLDv-ybpmIZ@gremlin>
 <20261111083632.57199-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111083632.57199-1-xu.xin@linux.dev>
X-Rspamd-Queue-Id: 942001C0004
X-Rspamd-Server: rspam12
X-Stat-Signature: 4x43p1kxaw83upkxru6k3o4jbkga8csr
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794386891-427090
X-HE-Meta: U2FsdGVkX19GJBPKOo55ccDHMFV/3Xphfd4nXDsq1UeZrOnKBvq7btirA8xF4Vu/QcPsDlqAUahtPXsPnP6QrwPO5mYzcC19etld+EyPbi0+LnvOkRQx6/8Yvv7yAK6DPpwVsFV/mxBSYEpI8II0uJOuK7y59pAJ9m/yoOzoUxbsU9Dl0h40c4lBeBA0ITfEG7MtUhvoOw6io3b3iIMFNMB95lLz84nf6B7V/wm/YQ8slhvuiMqY5txY/w7lGo+y6v+64IMvyfgiN3zhsTvBG/1ahDfY5cAMU93hIh6rzFnWb26SVZNGpWAmQcDUxkLRL0erI/FraqIwahFRNdww7PFQkzQunXNqHdeDR9Z173kTV12pd81/2JioVdDUTOJ5CoMtxxu5362TsIPgOZsPRN4DO9gwn168BqMWhMgkVDSDuwfNNCIeop85FTW5V0ZzucOtINJasqNbq/QPp3vBWlhQjsIPFh5yVhOa3EhzzvzlYWH0xip8WCNKqFVyP6BPIjHPTSYH21crStlf+X5T0VzaHgUMIBKDCcSfRg3jUmXv/Nl6zeiBJM1RhPZ1w5NWlEuSXqfqzxlTmTq7knsjlkDYj6yS9mzIfIAKq7fyx4SEp/cOZM7ZXPMQJpifmaTt3ULMdLqA1QqLTyShhRSwkmZhUbjniSW9WpqFGDrWFd9HiLVoJoY9fpUEfM8+qztkBaLgGuWeArQP3DNqvBHistU0SrLGYg0X9ZZdpLbMWc9Eccn0UQJ8ITcJld+S7I+Yj2IClEhAo0cJcRzanvpSAoE2p/dP/815MDmrr0ALDE/NrhAE8r9+mBS6sucLYXmvam8gTHzFJSzo3mde5gOqYI7ta1178sYCdSeePppw6YHsKotBkin4B+zV+4vh7MGKY5S8YRHXHSM0huNjvkyqlKhebXRShi5bs7feeqmu467yyp5ZPGgBykBXWmpcf4IghTbzNkv+wqvVzAGY77a
 KLAPANDc
 ACyz42sIh8NEBYJShvPl9FBwvmeZ0J/RIrRE/gX58QkuWeVg7mAb0GH7WlyUvMnphrvswfux5FqJ3FLmYl+qM7MpfoKHjAq4/WURU+2ufoX9ISSJJ8G4e7DZozzkgeLt8TiSj1gX+/640DoHqtcLhqQ+OP78RApoLDXYlrECvqYkiAu9M8ZEK7kxf+qQa0jRpxXZM2UonhzJHBoh84rRzjzpmHpuOOazOhiotbNUQ5LLoitsLdAHvt00PlBlmkZWcto1KgfYMCtlRvvagHTogm3qUi+omAyPvnVRbJgSBDttombRmrdRp5/PqSzmi2/RPS9SLtl6l0RNQ6akB7boOGsR9S47Bb+fmnrI0ZvUTBdHnqcECgAyXbTVxtXfNGIjXPHsxLZ/r5nR6yGufE+HqP72Zt8iCqqCzif7NsmoFbldgfQpADhxCT9+D49ybF4mPj454
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 04:36:32PM +0800, Xu Xin (vivo) wrote:
> Whenever it's a good time for sending a v3, I'll make sure to address Lorenzo's
> feedback by rewriting the commit messages and comments, and simplifying
> scan_get_next_rmap_item() as much as possible.

Thanks, appreciate it :)

--
Cheers, Lorenzo

