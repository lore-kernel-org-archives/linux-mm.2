Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62DB2CCF9EB
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 16:06:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB2E78006A; Mon, 27 Oct 2025 12:06:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8A5F8000A; Mon, 27 Oct 2025 12:06:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A79828006A; Mon, 27 Oct 2025 12:06:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 957FF8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:06:53 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2B42A1601D9
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:06:53 +0000 (UTC)
X-FDA: 84044372706.15.40732E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8923640015
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:06:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BtLEgncf;
	spf=pass (imf04.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761581211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9YaxFzMZ0c4eJws2vIlpi2nPydWcPYMujlhMq+qzzPc=;
	b=jeEOqUD+TaGXmLMPf2/cu2ePuVXlFyAYfKEaqu1o1oDN1malFlUReBsrA/8j2AX96pXF1L
	waaoEqvoBnOqGHxhOCU7M89hkyLi36I/WOKPTI2UcoQAXdR4qex0KtcSRPO5Lh/M7znmeU
	/YjblsYhAtu70rxa4mWaCUMgDRYxJkM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BtLEgncf;
	spf=pass (imf04.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761581211; a=rsa-sha256;
	cv=none;
	b=SsrwN9tN+r7cYxzqD7GUCicUki85f8pC8qtWT+DkQZRLxQu32z1CuEahHJCFMnFyZwdS5M
	j6IK8OTg8uBM/bIENgvUwfCqVOfKTUzj4M9PWHfD10i5QUHQccgQSKjUV6TPMAJ/EDJrm9
	SM0qmK8Wp76TIblFcpJ2cykjkCZTlEs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A6C08604F8;
	Mon, 27 Oct 2025 16:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D84C4CEF1;
	Mon, 27 Oct 2025 16:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761581210;
	bh=lgYGdJqJLSXnsekhf4n7haNtiB25n4IV3mTGIwEdIt0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BtLEgncf3+Nx2+/q5LePpZKjn73XUJB/FjnjW8HOPme7rRrIUzbkPoZ9yLit4Xdd6
	 1th/Izvrun+V9r9cyFF2FlcbICtJKaG7RzQ4ySXdiKJ0f+BrpN9c0DmY0cFNsethnt
	 cdyTZ4OMaCzePVC69gtUtKBPD12NlwU2AB/Xoy51tq8Il91BP9lhqFAok/9W2zvVWJ
	 NZ4g22e8RDxsHWMXBgWXmPN6PT9kHcGH9sNxc443NtmfgHkcK5kK/BwM3lywrlVfzC
	 dR1hJ6hqKugOAnPoiTvkuXKy6Xx2ZYi4tCp7OGoNfX+KysZvHF1SvCGQlKhMyvcFdd
	 M1GxuWkiW9oxw==
Date: Mon, 27 Oct 2025 06:06:49 -1000
From: Tejun Heo <tj@kernel.org>
To: jinji zhong <jinji.z.zhong@gmail.com>
Cc: minchan@kernel.org, senozhatsky@chromium.org,
	philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
	christoph.boehmwalder@linbit.com, corbet@lwn.net,
	hannes@cmpxchg.org, mkoutny@suse.com, axboe@kernel.dk,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	akpm@linux-foundation.org, terrelln@fb.com, dsterba@suse.com,
	muchun.song@linux.dev, linux-kernel@vger.kernel.org,
	drbd-dev@lists.linbit.com, linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org, linux-block@vger.kernel.org,
	linux-mm@kvack.org, zhongjinji@honor.com, liulu.liu@honor.com,
	feng.han@honor.com
Subject: Re: [RFC PATCH 0/3] Introduce per-cgroup compression priority
Message-ID: <aP-Ymcsoyls04jov@slm.duckdns.org>
References: <cover.1761439133.git.jinji.z.zhong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1761439133.git.jinji.z.zhong@gmail.com>
X-Rspamd-Queue-Id: 8923640015
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: dr737bbfztrxhbmm7ifrqrz7cxa7e4e6
X-HE-Tag: 1761581211-500420
X-HE-Meta: U2FsdGVkX1/bLPESoyOmuHPt546XgfbtTWU/0U5+Qj+YPySEfF3HEwlPbp9LHTb9/374Pbe5H0y6r+Ucgdhp8XyFABi5nxrj07ndNS9SOQAw4cUR96NYm4pGsRkUcS9ToE4GLMkD+3GgFw6re3W2x+nqhF/eap+N1ilY6JgL/qr7DHlIVGKtnCMwJ/PB2NOkhEyh7hsMy34fE7RKaZ+wi8GrkoFpTDIQ8T6vjY02Uys7dIAfLdWiZpsvajLKK3G0e2FETcaNLHSUXbxr3dpq+6Baheg2VXXOIg9b/rMOyZ4Iytqz/aBx8A0AHF1Z3uJaa8SNlpwVH4j2sEOJJ0mxI5qn273sMR1gcxRzsngz38oBthesbbv3beghDNlgB2JPd8Ns2g9wkFfDkVKPgGF3qqfqNLzPslZEOP5v2qO2axpO8W0FtLaeNHBe0AdS9wifxue2MdUf0KLDA1m9lpQkH4u3vx7YNuCR4ZMRtYZZU8BO3g4QS0TazjlvK4VQXGaf6UzhGLv1ApG1tJZkDHF0fh/5yRZonNlvFRYVSXAzgeQSKDbDNq7EqEpV+dxr3dxmM9h4hDytJR8vrIUWQ09kuFnwXWzkxIvuHv1XjpZdn0fq2UlQf5O8aVX9g3dbhxHCSIkqH3Mu81L4vY10hyUh5XnkM5o7Unt/XTWV6fb1mdh9of/VtY4GnJdC30ge3vwaVu9BS5S5UBRp84+sIPeIznnBiOD0s0WWa68WgWl2uHc43pgcgCHrSHyrqXoikTFBMt49/qBqpnGqW2HV10fljG1yufOPu4r5v5jpys38Ju7+DfEgmuHgqIJ5y/zc9OSEwZfHAkIqUgZV4KRVR3m7bFHygnWnKeIpuB8aX4ZwPykBZLAbup8/mJmYpvba0OpEI5+XQUx0QDNUkkfX8znNpLg4/XS9v47Qq4DnnS/3GZ0hAYL0qJnYzVurYoZEauahW7/XlmLM+ipJqGSwcnO
 tRWYLtZf
 5QxjmRouoNbbJPgFS8ga9Jvt33c025PQ2Klk0PYIMsh8sqjwZ5WbsJgwTb1OW4Hnlt8BZcqQUueVSH4zd+2fI+i5P/8fC+MbVmTZDhdtzzs/ssze16/eHarj0qxSQT4YwEPYEIu1CCQ4pEe+Ffzi7oN1oJSI3DKgdjVTeRsEWm5bgj96yW8o9Qf12KMJWZb9dEwUUkawWyijH7ImZCDE1tHGcyP8H5xkZ3SmNhIm7R9Xximq9bjmmRT3ZWSxQs4VssMg4CY4Z5MOT927NWY9WAZ3musGk+Sv3tI1d
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Sun, Oct 26, 2025 at 01:05:07AM +0000, jinji zhong wrote:
> This patch introduces a per-cgroup compression priority mechanism,
> where different compression priorities map to different algorithms.
> This allows administrators to select appropriate compression
> algorithms on a per-cgroup basis.

I don't think it makes sense to tie this to cgroups. Is there something
preventing this from following the process hierarchy?

Thanks.

-- 
tejun

