Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28308CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 01:42:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E15E8E0097; Wed, 17 Sep 2025 21:42:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6927E8E006B; Wed, 17 Sep 2025 21:42:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CF538E0097; Wed, 17 Sep 2025 21:42:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D2098E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:42:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8CF26C0750
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 01:42:12 +0000 (UTC)
X-FDA: 83900670504.20.C5D936E
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf25.hostedemail.com (Postfix) with ESMTP id 32C78A0008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 01:42:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hrQO9Dq9;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758159730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VK0aNf8yfpHz4wwNcRBOG7PZ4LEkmtROha+wWS9FpmI=;
	b=zIG0qOO/heAnMhZYaO6EX9p314XuTNBTVeCFUAUFFFn7W6wrMrqzURBZRIVy/YIAfXOFbW
	E8Y6Dg7XNUAgQpgiOxhOYOtdScmdkyZT/Mq/bQktuT0+Z1CY5Od5agfO2AV/axmbM9PU6W
	1CG/r30CqDlWOzH9rowqdp4Alv3RbfA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758159730; a=rsa-sha256;
	cv=none;
	b=S4qymV4fnhCUT4iBsUY6P4jwVD5GWXqFcpHi3o/KC4R0OmSFLOHo6/8+64fSYvH5EDUZBT
	pF+loD8Qh8SmGwCTIx4695ZiGVAHnkIT+eziQNDK/Gp8UyV5ouRIjhead1l6bdHT8Uzt1J
	rlsd1qqMZk64LbttjPvXNYdsAtJ6wdw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hrQO9Dq9;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <5df18d21-a451-4261-8606-8faa41149028@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758159724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VK0aNf8yfpHz4wwNcRBOG7PZ4LEkmtROha+wWS9FpmI=;
	b=hrQO9Dq9bMzluTVloFTx0iPFN5W5c7NwX73MJwymgHVsjC9uKhV3UV6Gi/plzxmqOiQ39Q
	LSLT4gwnPIYTnlOQ6uAdLqJYwR3zhoUBwzuzJz5yxHRIvbCMPCGubCRTWrJqzOo249v7nL
	4q7EIHNA24aorORBSO+DjiwfI9r1lc0=
Date: Thu, 18 Sep 2025 09:41:58 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 1/1] selftests/mm: skip soft-dirty tests when
 CONFIG_MEM_SOFT_DIRTY is disabled
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@redhat.com, lorenzo.stoakes@oracle.com, shuah@kernel.org,
 ioworker0@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
References: <20250917133137.62802-1-lance.yang@linux.dev>
 <20250917153046.b781f65ea9a54875f4ddd02e@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20250917153046.b781f65ea9a54875f4ddd02e@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 32C78A0008
X-Stat-Signature: e993g3whz38iobodwwbfkuc35zdtauw3
X-Rspam-User: 
X-HE-Tag: 1758159729-736869
X-HE-Meta: U2FsdGVkX19pQYCWw2Du9rZHa0okurgete3+t5g0GWzPILiuREljF20gVKlEo4Tie2qNTCKHbPQ/hoPjLNW1ZUtnZnwZoPlEdxLeB9EfFeWve74lRDa0LuCV/8BNlTpowplLNDkQuZQQUHayYQZMZZV1XApM0lD/EoSSbkPUbJX747ukTB6Icn8G+7bJxCGMY2+P6W00a9cJ71QKOPrPZCp521v3r0YailofwwcpAxUAHRZSMDEx6/Hu45NpWdWSF9kuWQNmIQUKobjUDPfhT6JmiMtA+uHxN4/8NNaF9dMKARtrT36avGDRx0/YXVm3LJ9yCWry0PzkSHY4In4vfeyfqrT/wso/hfgqcMLxMPCEEuX8IrC9SplSgAtVuxBhlmxtE59KjwBz24JFl3or7XRpQIaQdZ/9L3cYx62JS/jnDBHL7AYca4vm6YV61J328XNinK4JQvN/ZWKqJii/rK6OKLNpC/l55o+k2GgwiB7mHwxDS9cZZO19owdKV82CYlG3vJZbHkJr6ZfKe2WN1aJwwmXHFQjgPZ4vvwOrWQLdf+2N4Emxz9dER8/8SZ4l9y4qjlKWXAE0YOsHoq1YLrrbvSCXJ2VTP+qP/JAUAmmK8CkOq1QD3/xYjGRQ9O9w8533mpkDEcAC52vsaqnjLnszPS7yYUyw5clM0dMqrSIndVtZRumwWUs1VVlVlyRpbruLkBAxwzxoOGNo9xWooqEIIROxDeNtkf4466BK3W2ujH6crF5r/Pf1aUOr7nOl9D+q5j1vRdtuWXjggSaWwJyw39OlzSS/hKYLurlKrjr+fKeWjxBaoJibO1c6BHeR7XVjtPVDTG/lMVSswvXbTB5XmfnRUWLnr71lZNNhakNBf9Z3XvyU8AGSCLvuSN58FGJVs+CvwJglND2KUoQi60PGtIEt+LrML6Y8/Y/t5QPpRNfUc2ZmchbAeF+gPh6WcX6Q2RPLAvTQggKHNP6
 m62knVGf
 0sezz01GPbpG96l+ACOXGdvTFS1Te0jTaUp5RDqqs3WOn6ixZyU3wZNyIP6yxCfTNW/ASOruAdu160J+6wsqxFWMa9elBGlMg622ukTjU1r9w120weV5ht0IHDFkiWobOFKEGO79Wax18T9g55oPhEczZJakqyt+suWkshuJlMzPQFC7VX2JNG3tbSHnZZvSv8ZB8nvxVDA2jSVDNERBvVK8j9dLL/+LfSnnVYwOcTWP/dIwIcmiZs7il+VhziXPsJB6c
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/18 06:30, Andrew Morton wrote:
> On Wed, 17 Sep 2025 21:31:37 +0800 Lance Yang <lance.yang@linux.dev> wrote:
> 
>> The madv_populate and soft-dirty kselftests currently fail on systems where
>> CONFIG_MEM_SOFT_DIRTY is disabled.
>>
>> Introduce a new helper softdirty_supported() into vm_util.c/h to ensure
>> tests are properly skipped when the feature is not enabled.
> 
> It's pretty sad for us to ship kernels which have known selftest flaws
> like this.
> 
> would
> 
> 	Fixes: 9f3265db6ae8 ("selftests: vm: add test for Soft-Dirty PTE bit")
> 
> be appropriate?

Yes. Thanks for providing the Fixes: tag!


