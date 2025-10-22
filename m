Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7A35CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 03:56:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 114E18E000E; Tue, 21 Oct 2025 23:56:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C6178E0002; Tue, 21 Oct 2025 23:56:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1D5D8E000E; Tue, 21 Oct 2025 23:56:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E070C8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 23:56:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 793655A9BD
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:56:30 +0000 (UTC)
X-FDA: 84024388140.06.5B2CAA9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id B2C9014000F
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:56:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761105388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B9yDBSZbtu3S8SA3yE2NSAwua43sKWyr0w1HZMmIGEE=;
	b=RFiiBNjDRzOeB7/mwG5aZLjqJuhmfHDMYnBVod3zAWKPypdZ2g3hvqTKi+ElOmZJcU7K0M
	gJCIGKxsXFFJRqlggB54mzjRZ6e7Idl210uYOWnNOUd/0g9kfVFdWW3maMtUkF4XO5KzM8
	p38Nnjl3MU/hPu6te3FzW/2fjPAN+ko=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761105388; a=rsa-sha256;
	cv=none;
	b=6TXtkWTnjEnLMUyeTVW9ZR2hhsOU0kahMKOORLMLbKdt2OeycofDwcGDLd7PRt48XHV+q4
	965y4zXqJyazAI2s6wHlnJyQ7/Uve8d7+w7Hh8gnGRsptfc5sNcbTetj8rSB7yZJOSFbaS
	LvkOwu7zsqyLIECpFxIgeTvs6BEBgNc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C20CC1063;
	Tue, 21 Oct 2025 20:56:19 -0700 (PDT)
Received: from [10.163.68.114] (unknown [10.163.68.114])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B81B33F66E;
	Tue, 21 Oct 2025 20:56:23 -0700 (PDT)
Message-ID: <873b6b5a-1c44-4cfd-a36e-adaa171077b8@arm.com>
Date: Wed, 22 Oct 2025 09:26:20 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmstat: Fix indentation in fold_diff function.
To: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 jinnasujing@gmail.com
References: <aPc4I/8zXCGyiapN@pilot-ThinkCentre-M930t-N000>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <aPc4I/8zXCGyiapN@pilot-ThinkCentre-M930t-N000>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 18pwqdq88sxwxb6bprw9jawpyfn8ibka
X-Rspamd-Queue-Id: B2C9014000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761105388-88304
X-HE-Meta: U2FsdGVkX1+sDDZxb9XSYpyFMLZ77T66zZ6oc+I9YamAq35w34UIysZVxypy1VELHR+ksg3dmCsrL/n5hr3wS+i5fg3PKS0/nJ8o1OWGoXr4uJu/pnhnTMJ96Sfv7ucrFJ06EcrZbLf6azm1CuJZL8PqwWVug6Pt6IpMnNvkRCTxsNM++83WTev2pfS56CQVkuVbOpOqAT1YgP7GiLQdRtK6jNNDXY0por5Xsass0kV8geEt7uUH8z81lIK47mOV6oLvAa1Fc9O3swaEe9iE+Bx3GyhCwvFYrOn7KVl//8lQamkpEl33drL2q6oEXnkbODQZ3HkmLzrsWZHHsaoCSQzNdv2tcfqGd4EhFArmjCKE3g3deZKuKH77c66tx1chacX1oshPTQWxNqGTPW/4z0O8EuOEe7/AYvX9kqmaJz+3fCYlz37UiBXSR74mXS4DYvZtxJAE3vW/EnaniK89p0lOwsswjF9hL7dnQy98k4GL2sg5YVefz+1Hss4evXJh8oaEDHQBwbZPlQIazCIGqRc6TZPE0Fa5HlMF6LsturWs7HopUB1RckjWJIQcqyvel0QbQUBiu3bvWLAjMwceWMKCtP9hJmaZdFliuprNvYgLGJKs8Jy+4/H4wiu+LdHLMroq5gBlIDV7fO7E0pmE+p9H/v2fykBTC7/UaaPPMuIbwvoOVPI6Dy8wIuynmsj0UiAtlbKmvhXq3CFuGlneKxvNowkNGF0SKA9IWQs31vyusxzxelvSWff7H/agncmpRP+siH1yrvv2cyw93SLn6B9L2bgItahpmUGwZyWgwW3Ckcm1efsUTwLajcC8F7VlM6Liw3YUzqb42ONxyx7OGk9OZxbOWmJZOiCkWGqwT5pMqdS7tx8sDRPSZ5zTG+jLhxluIKdkgDjdnF57wgr9ZaGO2wS/wcpU3iBbrDNMWJvSRFGJcTX63k9Dgv6ZDkJAL8nwC/P5BZN5/A4EM9A
 bS4QdliQ
 4a6JD0gNBWK47OsJGt+i5N5qOAiMnMuWfWKVN71ejcXvsbps/ig8OUun7wQ7Es7gghr5oFYp/IDpcn2jDtGf0YTAGaaNbw3U2cv46sh9FWR+e+Cmu0XWeiK3Z0VQ4yH6MzLbfnfQwZluMQfL3LP+bfwem5g2nrvHQK1BmR7F5wkHTL5qeUTSuXiXJyVXPQgOde1ZtzfOx3Tm3yIp71dwywnnFIYMS6x9tX2z9EHhcWQAdxRLI0Axff86/nJle6DGCS1eMKJPQlMUbK6MCam6bXqi744L/hCGdkwrmtGC7knjtlLw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 21/10/25 1:07 pm, Jing Su wrote:
> Adjust misaligned braces in the fold_diff function to improve
> code readability and maintain consistent coding style.
>
> Signed-off-by: Jing Su <jingsusu@didiglobal.com>

Reviewed-by: Dev Jain <dev.jain@arm.com>
  
  


