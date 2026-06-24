Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 212ECCDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 20:50:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE5A06B0088; Wed, 24 Jun 2026 16:50:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A969E6B008A; Wed, 24 Jun 2026 16:50:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 987206B008C; Wed, 24 Jun 2026 16:50:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 71D866B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:50:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 06ECE167389
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 20:50:06 +0000 (UTC)
X-FDA: 84915998412.01.54255E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4CA5C120005
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 20:50:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=j66JsQBM;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782334204;
	b=59I0bZbOYxXewyTAbrc0YwlB42gsj86NOp17tVwfWsU1JtdWKqnHtJvhNsEf4hseJj8R7R
	amElfUVtLo4jNMdNS70/SBpde6rnqECELfFReEFj+sUqIOeyNAc8bhyqoHhDlr0i/cfcwu
	OnQAV1/n15yLet+cA2Kd8ktdyZ9tISA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782334204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mt+5vsX/ekVrYMgwH57dH0T4RbSG+uoxTYLUskkE9Z8=;
	b=14px3EMz3lXee5x0cWWkLAIkLvA0ZAIYS67W6Z+5Csd3vnczIrVSO3RBj78JdOWOp1YnX1
	zxkiOZARn4wzK2sMfLddnrEoLq575yNFKSNOeXDr2LIxTISWDOSW0phd8dDU3JOb7W4baE
	JeSKsb3Q48O05TQNTj4sMuh855rd3lQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=j66JsQBM;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6AD7340A7E;
	Wed, 24 Jun 2026 20:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7001F000E9;
	Wed, 24 Jun 2026 20:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782334203;
	bh=mt+5vsX/ekVrYMgwH57dH0T4RbSG+uoxTYLUskkE9Z8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=j66JsQBMFPs41v9dNwhtsaZf3xJtm/qweu7T3hqT3ZyF41juOU4ndrACbcRVqcjZL
	 dSN0uceGGNpUbqclvZD/XfLshUX76h/TegbdmR/p82Ockzg25IzACznehVpcXk86pp
	 lHITeEX+0UC7kjKAAQRbgOjH20YNg9VNUFQJPMXM=
Date: Wed, 24 Jun 2026 13:50:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>,
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 0/3] ovl: make cachestat() work
Message-Id: <20260624135002.09ab1f9387eb4708b0707175@linux-foundation.org>
In-Reply-To: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4CA5C120005
X-Stat-Signature: rh36dsmbbpznepmrdy6zswc3grh9ikgt
X-HE-Tag: 1782334204-894081
X-HE-Meta: U2FsdGVkX1/kY/1rgP3m6AgVFqOT7DoaLLyfsoZiDuCSa55on79B7J3NjCFSfjugD2QBI5cS0fMTlt4h7fhut+sXyKi8l5e4gLlit0rvYy5DaoZxR6gBpHmBA/ItKhb6JMzFXSVTfjmXMfTXC5fppIbOM6ZKiUOssm6142d/6C8Q+5ZnnrCu/T2fGv2RtJLyC/Jk6VFE//GFdaZm0wee8BJmGNjaF7QToG28cx5J/Mx/CY/gZ9lvFXgymlyFhQngx5b22e7pvJzY1fswlKjWswveeXAkX1avnU9Bdl+jo5lNx0ZswXaT0QOP6RBfHZFfeXCTa7dMQ2nKtpoeUy5Jzhh6pf+2T+F92hbp19Iu6uMLoPAQ7RhkKDJTQ8XdyCRsl1+DFGsqnDfyNQ1iiPsyd+wI9yAJ3pY0wKHHMbECaIi1vzQg0WPMGLg6w9OIqMW2pnNszevgeeAPUdX4nC7Ct5R2pgspG9O2lF5d1YbKUnsPR7KGyYHZCiQrjiSqUAoIYN0JbqZwAvv6Rrjyilb0l6NbgrdC4tZ2gg7mocwYnpUJWy7fUAGJxuATU9G1uykE8I7m/8H/8J1wsyK7wuvC3O79R66dearercz8NxoehXfduAzYqz+t577PAVxUGBtwPNeirBPEXX6H3dOKTnlErqGlubQBJRC4YszCOeCVrRhvLx/ftbXJNkfQ2trVNGjKUrS5YHkjzJqK6StpSJn9ECyYoySy+4xi7u0fhHalE74e1tMTOOOUDZL82O6Ikne+pF7CYIYj6OSf9yrlv56Os1wygXtS5m1nmsx/MG7MHvyI6YCNVeOMafCR7/FwK3TDCZO8mBp1NGpkax62wDJUQcM5WZtlJypVboZqFH7PL5uVq+Bsx65aiJwx4ODZfMtOXvee5EN8dtXa/nPqRtaahdg1YwFgA9CR2kSBRNoC8PmkISRuS3TyXa1jqCW5LFmE6RUvDVV3MeztM3fg/pj
 m+MIY8gw
 oWX7LbTMXxyb9h21cIpJdGX+Q+tYQI0om1YuyIHbY+LeXhgAO1A7nC+Fw0dD5+30zCxWbHIAAgQmsa5G5IYxZRaMZXhSuQGCDyg1eY5T7q1NmG8wXHFzSAHAeH52DcT07hCk0Zvf8i6PE5g8wqIHD765jSL0nkFhvijdfvM3ugABR60z+Zk+D67dpSpH7x8YUSaUy/qjA7JrIbnhNWy5GBvkNYZ3S0JAoy6a/zjJ2DPR1Z9IhhGrIuMch4skchwYBz0eaYvZSRwNov7MiIb/za9QCHsv5RX8Go1IP+R6C2+W+Nz7QI+u/GSLKPh3fVmdmc+6dsZP+voMOOUTxI0tKuimOiuRSJXEoQIj9PHef3y7V3Py7TZOeDH6R0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Jun 2026 13:14:47 +0200 Pavel Tikhomirov <ptikhomirov@virtuozzo.com> wrote:

> We were using cachestat() for our internal Virtuozzo cache related tests
> and I saw that test behaves wrong on overlayfs, syscall returns all
> zeroes instead of any meaningful cache statistics there. Let's fix it
> similar to what was done for fadvise().

Thanks.  Sashiko seems to have a found a couple of issues:
	https://sashiko.dev/#/patchset/20260623111533.2285005-1-ptikhomirov@virtuozzo.com

