Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B8A9CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 14:38:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24731900181; Thu, 14 Aug 2025 10:38:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F74E900172; Thu, 14 Aug 2025 10:38:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10DE3900181; Thu, 14 Aug 2025 10:38:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EEEF8900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:38:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2875F13871D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 14:38:30 +0000 (UTC)
X-FDA: 83775618780.08.C45570C
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf24.hostedemail.com (Postfix) with ESMTP id 388D718000D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 14:38:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf24.hostedemail.com: domain of cmarinas@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755182308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dwtL26rJ7sGQE4nAN5aaFmbSPzOYOhKpn+6h1QM/F0Y=;
	b=027cFm/dbZhyp9bVnoA8+6gsqzv2lYRFYBQu5+Wg0JPy6sNeY+hYmGJzYy67OMNsDsBtYu
	q5STjUN9CLmsmDVVNjHf9SFqOAsdq9Ww15mjssKKELFtoyUX7W5Utm5ZFXT75y+8JOI+5L
	tnckz1qsY/gS5jHH5rjTojqPmgTL2EY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf24.hostedemail.com: domain of cmarinas@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755182308; a=rsa-sha256;
	cv=none;
	b=SXgKz3SW1W2ozoQa3UoevkQ+Ua/DnODRj6F09s59K/S6wGP8Teqqav1BXtgoRhtA9Ffm1u
	mLQdGxP9Nz4nVw7uDycJ+zSCBybJcto+CjIBn8XaxL+V0xphF62BLEJRXSuj8qrua7ZfjD
	5bENrWN+t5SX6tNNW8wkB1y3zilqTH8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 870DBA55AD1;
	Thu, 14 Aug 2025 14:38:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F94C4CEED;
	Thu, 14 Aug 2025 14:38:25 +0000 (UTC)
Date: Thu, 14 Aug 2025 15:38:23 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gu Bowen <gubowen5@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org,
	linux-mm@kvack.org, Waiman Long <llong@redhat.com>,
	Breno Leitao <leitao@debian.org>,
	John Ogness <john.ogness@linutronix.de>,
	Lu Jialin <lujialin4@huawei.com>
Subject: Re: [PATCH v3] mm: Fix possible deadlock in console_trylock_spinning
Message-ID: <aJ303-YBCCLFeIoy@arm.com>
References: <20250813085310.2260586-1-gubowen5@huawei.com>
 <20250813155616.d7e5a832ce7cda7764942d10@linux-foundation.org>
 <f3e631dc-245a-4efe-98e5-cbe94464daec@huawei.com>
 <aJ3f05Dqzx0OouJa@arm.com>
 <2025081450-tibia-angelfish-3aa2@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025081450-tibia-angelfish-3aa2@gregkh>
X-Stat-Signature: z1aeqpjuugamioepar7jwrf56uu3b1ex
X-Rspam-User: 
X-Rspamd-Queue-Id: 388D718000D
X-Rspamd-Server: rspam05
X-HE-Tag: 1755182308-746040
X-HE-Meta: U2FsdGVkX19oGM4WQBOgNV1e8WlzsRR9jvZNpvf1s09BrJ7mx8DAmAeV9EV/z8qRCj43jwbGg85a4BVojlbry24/omB4PEuUZzliBKD4Kv19pSGEmyS3TwvBbriF59wYJwD577C7vpe2IpCrEnMQF45AQyODBwn5rasWt6iG0gEop8OfjrbJRZbXMfLrDYe8UopldBAMDpat7jxspyqssfF/qGZ88oqNHbwqcPIAY2M7Tq/CbNl4Tq1glLsn72gGkjGTnOWP4tl4EboCTdIyQemxTJzYJUK0pcpzS+BA//6fqWtY8/VsGdkn9Wl1CbMuB+0rze2Cue8ObDkS8S1vOv3oaQZ6fDhrNDTv/8F3FZy1cAf12PkT00l+Og0QNqp2GGpIJF4s/UGeA33DUWgSGxc/Ae4jUbPJyrNE3KRzLOahgZ/5NbRSsoxE7iuoDsgrTa06U6srTyVWlWq7bSZFCmVZIktFOKCT2jolRjgzrgHP/iffqGYSPWd3DiiI/rgl5jvp3JvBWgdAHN8wHOR1lAbtHF+mAAT3ct3xBqmAqEtKA3Mq3v3A5E25wWg20U7Soz87Ep9+uA96sK8onWI6yXC4NGTW3gGbfK8fVGXVlqxqadW6yLBcw2v7yIny54dzXI7lrNGbuEzmls2eGCm+aQTtUy6HBMlGmLIwEaVztCkSttIMNKO2vqNRwzKDvsj3HUEyt6VgymC2qMpT1odKL5ZkJNs2BWn59RHfpYckbigKmuKP8oxAyrBbXHAyH60yIkYz1Z1o/QWKmVmiJKTewrBd+Upj8u2e8K+pxrJdlT5zMYK9k0yQ11+lAQl/lJ90yiQUVW3hj4LTO5OSDNfnOaSmHBbA3TeBqe4OYsteZrWCDRFqh3JAQLDhKuyL7D56akCzX/H6q0f3YF5Q+jNeQD2fa2kwQ0bOD5EPFTjhmWuFTIaTXX/qTTX/6qY+uS9I2N98chG5lYWGoFRxPis
 RoEIjbui
 nocydYGJJo0o3ofoIoxgu0556VaTfz/ay8BoMyTS/NdCRnQSJoepJFzlCsco45wZOPc63lcHO5jIFhw0CMeO9KCPoi9ip1Q2RJOhIlkIJEaLWVvzC1D4SkvLNmMNCBeOKOXYSA/CWcc+WLAPuulGU6YVIQG0IK327ymv+tseP2fdcJrn0xMgph5Jg/PLh6KT/LWNY5X1HKkmGpAb0ridjUbgMGh7gFTz8T4HqUwkPC9IWvcrPM+9eNTgcN0teWqQddg9XQcQxkbvYxur7GH+LaIBUUr/zNrMmjhg1e1cIyfEBZtMQneZFOkhX8cJVQXLzvRnLmAJF2ptikNYmjCOWxalD6v6ln6GgyWq5E/Ue3xzcscW04b6x735MK2Pc87agZwyT9+/ud/IS+3H539inrMgr3tpU7ZqtyvWk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 03:56:58PM +0200, Greg Kroah-Hartman wrote:
> On Thu, Aug 14, 2025 at 02:08:35PM +0100, Catalin Marinas wrote:
> > On Thu, Aug 14, 2025 at 10:33:56AM +0800, Gu Bowen wrote:
> > > On 8/14/2025 6:56 AM, Andrew Morton wrote:
> > > > I'm not sure which kernel version this was against, but kmemleak.c has
> > > > changed quite a lot.
> > > > 
> > > > Could we please see a patch against a latest kernel version?  Linus
> > > > mainline will suit.
> > > > 
> > > > Thanks.
> > > 
> > > I discovered this issue in kernel version 5.10. Afterwards, I reviewed the
> > > code of the mainline version and found that this deadlock path no longer
> > > exists due to the refactoring of console_lock in v6.2-rc1. For details on
> > > the refactoring, you can refer to this link :
> > > https://lore.kernel.org/all/20221116162152.193147-1-john.ogness@linutronix.de/.
> > > Therefore, theoretically, this issue existed before the refactoring of
> > > console_lock.
> > 
> > Oh, so you can no longer hit this issue with mainline. This wasn't
> > mentioned (or I missed it) in the commit log.
> > 
> > So this would be a stable-only fix that does not have a correspondent
> > upstream. Adding Greg for his opinion.
> 
> Why not take the upstream changes instead?

Gu reckons there are 40 patches -
https://lore.kernel.org/all/20221116162152.193147-1-john.ogness@linutronix.de/

I haven't checked what ended in mainline and whether we could do with
fewer backports.

-- 
Catalin

