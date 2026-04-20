Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4897F36C47
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 07:47:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C349B6B00EB; Mon, 20 Apr 2026 03:47:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE5126B00EC; Mon, 20 Apr 2026 03:47:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFAC56B00ED; Mon, 20 Apr 2026 03:47:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9DD726B00EB
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 03:47:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 375211B8CA5
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 07:47:21 +0000 (UTC)
X-FDA: 84678153882.08.6AA344C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9E29940004
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 07:47:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CZn3hqC9;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776671239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kK+co6oi7OJL6AdCRJzKMKk7CVCzuI1If0cbhdqxXNc=;
	b=hc4p5Y40ueunBtdTzhosghofjIiqLH2/uf5nThdnlmqnEB3r6/9i4JI3+OB84ispzdOSDl
	sFjnR6GArLGEKp55SxhKsB6NJluzas1tzTxSvX8k4Y0V9FN4aLzdS1JLi71jgGyp2dp8SY
	yvHbQ3Rd7QOzp0MvsI7IsJW6S9VFXsc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CZn3hqC9;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776671239; a=rsa-sha256;
	cv=none;
	b=NR5h+AgyepKMY8TXcd4nUNXBKbO3seo54lWXYoBBHmzhYAfm4pQZWU9C2cgmj7FXY0+HZP
	YcGxcJovl/ooZuJQtvN2KuGFIZ0Eq6uDkBAgiHikbwTUgmdJ/59x3nCxp34Jocmw4y4Ev6
	8ADaA5hbfBudMvhZRT8/lSBZAdWGVZk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A520F60055;
	Mon, 20 Apr 2026 07:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66EFEC19425;
	Mon, 20 Apr 2026 07:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776671238;
	bh=agb+sgSiSYKFVQT9I2o8YMrHn6TQc/1PqXRh14+ZJVs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CZn3hqC9GA4j71Xo5OkIfUZn8nGPyLyVDcfSo3KQT5Vr/B9asz9/eBj1rwRff6/7Y
	 vDdxjyt3h9KQh/xQJSTHFTjY+P93rdLj1gSNitrQeglfT6C4EKSmaNy/CUCFhE/vEk
	 /83eYHWjCf3g8tcI5p9kP9ziFaJ5wIOiIRuu4HvZdOnQUqviRUcv6jVappWaOCp8an
	 g0LJ0MlOKAiRlkMijOpFY2SwX2nrmVeOyvlPqrpoRj6zgQwI81n/PSbCR+Mh7MyKW2
	 IKxqinKEd7odlIKQ1HGhrszfFOJzX7mV37cN7HVXeIP3edXB7N1tZH5f/a6rBYh9gy
	 SK6Rcr3phUU7Q==
Date: Mon, 20 Apr 2026 10:47:09 +0300
From: Mike Rapoport <rppt@kernel.org>
To: =?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v8 0/2] kho: add support for deferred struct page init
Message-ID: <aeXZ_YvsSNDWcC0S@kernel.org>
References: <20260416110654.247398-1-mclapinski@google.com>
 <aeD5kboEdzwuR4P_@kernel.org>
 <CAAi7L5dFaxwoU5dho8sJJ41+SSwgrmXW_NjQZnn7UPzj0zoowg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAi7L5dFaxwoU5dho8sJJ41+SSwgrmXW_NjQZnn7UPzj0zoowg@mail.gmail.com>
X-Stat-Signature: xuii5upe43arueag8wfqczc8diosk4w6
X-Rspamd-Queue-Id: 9E29940004
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776671239-375415
X-HE-Meta: U2FsdGVkX1+DROqysWZFKXhaYFlZwY7iXsbUWJVXa61j8NpU/IR+s1jesZFyRREF/DAV5P02AcYhD8g4JOw19QHF7YSIiE1lS/6QqyTnM6HnyRa+lZMjscs/OpDu2j5bKQ8rjHx9ERMh6BSnTfGGB/uwbcUBicD1O+DzSAPRhF+HeVUIVBwxOKkrFQMG2cweCEHdxxGti1tQ3R7MydakN37vYT4vyaHQM+F8hy+XPYCdwWmMA8wsnnkrf/4Vl1y2NNH6I6dxVzOdPUkD6WWXON/YX+UiO6QITmHrWAvadLyR1J8pbSkBSUH/gKtN5B/EBwkXvEHT7vU92cvz6Pur/RnPMDKhXUPIIFDrCDVwYsLitFjAX2XFTAUuvKK0UATbG7O/yb8W46IsUxj9IB/S/7YHwGSsNsRU+IFsgMZQyf/H437SRdXuxvTdDtgNlxHflrDPd/iyBXdRD/QOnbbk2Ieq+mxWQtZrPiY3aj/bkUHsQehVv18uSJaWYwB8hEfzPlWDfgXaGd1FNT8NDn2aVtJKp+ZHJA/7gQrjemyu7o+0kvt5JxmP3K5u07xEZvlQxak/ZakaQOtJtAVsR6zFKYYiRQYdZflXitN5rlOTb0iY2Wjp15NhG021S7yRCeg1iFmDYHS4HlVD5pArKAOdqSGHADtWFhoda2cARRWwsVJzs73mVWv2v9K9GQtgMSiDqbh3ACIL21b3tx9x+4gY5wAMW7pVcnSJdXEkqJpyBu51VsrEDLKS+Xmye7Xe4DoioReg9fLqdW7giTQ7NcxMi55NFYmb74BohnKxkwfCI9B3u5bRuzkE0vzVGwmFC9igy+kxkTdHUdxLAW+VeyK/6FjdyBfRR5fkTZXD0+RgMsREC1X8X90ERAIlScPZFJJOVUikZaHNhogjAIzfXQEjY4vmJhvKTKZmE66QqUNENTzxf/yxnhScP0AKnTgy4HnrwwmglILmn5TSJhHGQH/
 96cH/ceF
 iOLA40jvGQnyQzaazF8iCEJekH2675EUMAfbqfNP47U+3ayLw7M7lcBY7W9m7tSUPI/8rK5obF7atVBKW06OP4S3PBuphoyKHRHLldc5k5tsA/iBafrXXCrpq8VXAqRCcV9atcGz5S8gb7WXjJlq2yBLEbf2IFF0IQfMiGw1TgSFnsox9RH83b1vhpdmcCYfJ3y/NgAZV9Cux/z61C/ZlaKBif4G1pzndnFsESJmSvMZWmjjwsQvCr+hqq86AxP15eksWsA/IVNEBIfm1Zl2HXH8L4H7mxVIgOzFOYEJ70EVfsqNrO4BiStJn3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Michal,

On Thu, Apr 16, 2026 at 05:23:32PM +0200, Michał Cłapiński wrote:
> >
> > Any chance you can clean that monster and send it as patch 3?
> 
> I fear that would delay this series somewhere into v15, which I would
> like to avoid. Can I clean it up and send it separately?

If the test is public, a link to a repo would be also useful, even before
the cleanup.
 
-- 
Sincerely yours,
Mike.

