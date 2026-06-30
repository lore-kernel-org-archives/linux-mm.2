Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C570AC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 22:14:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DA7F6B00A6; Tue, 30 Jun 2026 18:14:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 864296B00A8; Tue, 30 Jun 2026 18:14:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72C066B00A9; Tue, 30 Jun 2026 18:14:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 43A606B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 18:14:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BAF701664C8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:14:37 +0000 (UTC)
X-FDA: 84937984194.17.EFA3B73
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf26.hostedemail.com (Postfix) with ESMTP id 87D14140003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:14:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2026062701 header.b=Le3gGuua;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf26.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782857676;
	b=N1qyA/jaiZfl1yt8VdvEbU2FJ35tUCYbA+nFwbRlch+5Hq3yg9f5aQG2hTPYCWp4w8jkN9
	UsgedYt5XMcs+cuoKbTWAnJ2u5gMkTARGIstLNWqs179izy5Av2i3siCrEU7/iWCbF17EW
	H4vKF2TCu0NIe1VlPL5/iuxR4/2E1M4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782857676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WRAReKFHVDRGS4isJ32YVCLo/+68kLt6VkxwNq2bQEI=;
	b=32oL0RgJesxUKIGF1uxje78hhq4JAM7h0ucMzIAbIbS6fF+pKUD534CuB9ZoKX2c2cIR8e
	GUP2U2HsfRD8s1/cdAUM+lnsgeTObfA8aP8lw3bxoJ8tPxj+JPi1kTnLZCZr+hSteC4lar
	PISuuLB6fshWeBd9wQouGxQzQqu1Qzg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2026062701 header.b=Le3gGuua;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf26.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
Received: from [10.124.221.63] ([192.55.55.46])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 65UME0h43868545
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 30 Jun 2026 15:14:07 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 65UME0h43868545
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026062701; t=1782857649;
	bh=WRAReKFHVDRGS4isJ32YVCLo/+68kLt6VkxwNq2bQEI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Le3gGuua4QujchktITkW78RVVX/pciaMDX+V4ewXrvem4cEKDcRHD8/vnw23DlKfa
	 T2dLkYtbU5PineWlU6if8Hq4SFVNjwap+LKMcAVXKfIqPRc+bupAm6MVrxKbTG5Q/s
	 +50YCU+/ZHCfZNHdQGj/lJIAcVpAfNuAhRtElFwAthYOvbWicz45cYE3/cnNbvh902
	 XWG2CLsXwBwoabcJ1tqfI4v7xH8EkG02J66Y7yuvA26XfXfCoiHIzF7fJOwgynL2BO
	 fmECy8fAjZ25wurQs8oPrysAOu+xPCYiZUWNDiicky2BP2jl/rd1rQAAHJew1wB5J5
	 9D9VJBSMWpVew==
Message-ID: <86e805c9-ede0-473c-b8a4-8b20439eaa6b@zytor.com>
Date: Tue, 30 Jun 2026 15:13:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
To: Dave Hansen <dave.hansen@intel.com>, Xiang Mei <xmei5@asu.edu>
Cc: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        linux-hardening@vger.kernel.org, Uladzislau Rezki <urezki@gmail.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jennifer Miller <jmill@asu.edu>,
        Tiffany Bao <tbao@asu.edu>, Ruoyu Wang <fishw@asu.edu>,
        Adam Doupe <doupe@asu.edu>, Kyle Zeng <zengyhkyle@asu.edu>,
        Yan Shoshitaishvili <yans@asu.edu>
References: <20260629214712.1198680-1-xmei5@asu.edu>
 <d9775951-fe04-4d1f-b205-bd4626590f5e@intel.com>
 <CAPpSM+QTiwgPk3KNmWbjSk_SS8LLL5XDfikWC1A98vetom3yeg@mail.gmail.com>
 <4e96acf4-25e7-4f30-8455-f9b3f49062be@intel.com>
 <CAPpSM+RhcW=xciX50W3G+2mUVNkmLfL1-BScPN_2TekMbzYVcg@mail.gmail.com>
 <c7c5d2c7-db83-404f-b40f-ee01ae8b9299@intel.com>
 <CAPpSM+QVOwhmwspjaUg+FqKsHjiEn7C+gYPEcpJ_UZA=JMj7zw@mail.gmail.com>
 <cb547653-0ed0-4fc5-b022-6f0b9691a4c7@intel.com>
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <cb547653-0ed0-4fc5-b022-6f0b9691a4c7@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 87D14140003
X-Stat-Signature: yhbg8ia8zy4xz4xj8fz7akrxq8a3znr8
X-HE-Tag: 1782857675-208980
X-HE-Meta: U2FsdGVkX1/GA9HmrzbWcvcz2hRREt3P7DQDOiK7jobq9T56xFKZt0x5K7Da4VtaHLwej/EE0hVEZbu59gDNfgnK9ATrlgkmiRVcV3sZvOBXY2SyC4B6A/dh3qg+uhporipEVya0wR2gXvPqr86P4gx+6s8KaIGINKxdEIw64w9YdFoZp6FD3kvvEcmam+/VIOZUWNOouwmveA7KOkYpHLNtbcmDHOY8nVRkGOmCEXSFjRFMCK41b/4ntwI+LtSc8VjPO+rQN+1E1D91pAsi42cKp8DArlPS57uFAKPOi6xDGtOtz5TsbIBKYFomtsO9HHeE7II2Bt0Seo3RN0Jm1rH9zlDAGJO+pGFA9ZWq8mWkAvlIXyXd3wyFMp3i2TWz2c3Oco086p0wZ0SILi8iHf9ZvIwPB/ge0VEv5oAIcf4AD47XjB12Ym89NOREV1+W1kWPeqlDqjMHy8izvs9cC/CvWdiPy6iV9vEqFkv5n+jVA6r1GPs1P1KbIDiOO27y5Eud9diHjXnX2QY36ME6tJE4do56yDdh6HzFIjMU7YMYcZrnNS1cymPyW/mFyyccR9K/vtZ5UJVnuFfMVXiJd9yB7V53E79hiNz4vrTOzqWyLwVdfq6N/KOPzgtmwSlqZa/2aNyT9FnRPesmrhCp+7oDawiLbjBarqXL61CwIJN0ivlUCZQKvsXiYd/gKUmHs96QCn9p0W9l7Q4GePZHaD8HdkUyOyji9sLTV8SIQJ9lNM+2Iv2MCwNMGX0sJ6A+KwW9wUwTezTY0jtidKkrD+xbgnse7E8gtbv9MAzWqG+4W4P6PeSmWP8/07Mu4iAF7dLyW5JeAPF8uxjPbj8aMAChPWEz3Kcl2xvTuVwr3kDU3DcEEVnLpLAFS9nGHXJF4/uUcjZdrR6k4IbqQ9w374uuXiMtn1KFbkBbd0pU/onNvHacY8fTq8bbFUFZqejdXN2hag7T8/9kYmzfOlu
 zs+lckls
 fs0DOs1SeAVtS2ZsFyf+2UozAx4bkKduluSbksc2XAjqkzimicU24gGEy+d1KuftUsXQr7ox+9aCSZimZwuwMY5r4UuH/bKhDhYRX2KZnaZ1DmGjUZuTM+lYsZ9Zdmy1if6D0bQyzNMhHcyP7Mzjl02CvYuJ5f7bQV692mZ5vqGX+fT40G5PbUlaValo2SZ5+xIaXlRdkWiJw4bBlAJiTP0zwZjORiNnj9bjPAZkh1s+uI7gP0OOUtpkEnFWBkyQWnLmGz4xI90W2NV4JwvcOIM3J6yFiwKg+AWTj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-30 15:05, Dave Hansen wrote:
> On 6/30/26 15:02, Xiang Mei wrote:
>> Please feel free to ask any questions; I am glad to help.
> 
> How do the CET features: kernel IBT and the (theoretical for Linux)
> kernel shadow stacks impact the situation?

CET should prevent this from being the target of a JOP attack.

Kernel shadow stacks should prevent most stack-pivot attacks in general.

	-hpa


