Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E96ABFCE08D
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 14:26:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59B8A6B00B2; Thu, 26 Feb 2026 09:26:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5490C6B00B3; Thu, 26 Feb 2026 09:26:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4542F6B00B4; Thu, 26 Feb 2026 09:26:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 30F536B00B2
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:26:33 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E42E91B6928
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:26:32 +0000 (UTC)
X-FDA: 84486833424.17.E2AA432
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id E1034100003
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:26:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Tua+cVV0;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772115991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/CI97IoT2McZdhRjfbdLwKL1tR4tCBu6EcPq4+DB7D0=;
	b=a8eY5LOWT/5bEQ0NNDUkmvfmzBDxYUXxBbF++NJuVfKOewkpgA5GClHqG/lyZ0ecwnNaS4
	jFIdJHVB+eFeYC2kLk9FPgsuQyhmL69ixJk/B7y6qrV3xkbx+ENdXPWgi8/UgHJlnqvvIe
	cMj2dw/7xAv39Je2Us3Wf9IprrQAXtc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772115991; a=rsa-sha256;
	cv=none;
	b=6a62XCLjgDtfSc6zdFQgj4XUQKY4tE+MuY2m66roB8VRBOr/q95afVgcIqc7R8kZssviPe
	ZBr5Ry9QPw12wLRBVxHDJqkcXFA3OUQVm8HUUyOrYaPlIGZkL9Ea3qUUkFxcPhxwajX/b4
	avnptdQ8IzYDG1o34WkAZ7dGkUgtsl4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Tua+cVV0;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4806b8fca44so1309565e9.0
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:26:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772115989; x=1772720789; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/CI97IoT2McZdhRjfbdLwKL1tR4tCBu6EcPq4+DB7D0=;
        b=Tua+cVV07kVIPn3FIacnAsx5LUgFk4GRRZcBIZeTZIbXbJEMZM9LZiR8W26Xbd3ZjI
         YLWs8WYj3Rjoi2tDlH4GJbSguVkesR1Di5CHVaKZLEBeU0L7/RZmkFDxPJFcb9mSQ5cq
         9kX0dIruZZS1hxq4z/Potw2VH5IPHxItxe0A7EnwZ1W4pFFtqhAwcUMODDSi2wGsQx7o
         BGB8cfFfHtdY+ySLAuGgQh8elQ1Zh4VPeqbIk040t/nyHDx3w8TC8iIvLbJKxpOHI7V+
         4ofDHn01UVaR23G+5HNalcZZvKrprrfE4wkkTyHgxdEJOpiNGZctCDnD3N0J//E5sUN1
         OjzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772115989; x=1772720789;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/CI97IoT2McZdhRjfbdLwKL1tR4tCBu6EcPq4+DB7D0=;
        b=u/4/8/rsEx1KhUP0UIiapsn1DvXIuP2XI0V9abxWqJSf+0ch33GYRfPw3DFw5oOg4V
         iGk+zu1e6bk+Iq6TbsLfk6zmmfwXEjS7aiuuMzyLhgvp5ZgDCftHlaCO/6lfGtPdQWKj
         xkkIfosWG5R7hI8pAhJAHl7EchsMACltUDCjmBWgufvVvQcSwEJgoMavUcnAsp3hW0xB
         Eh+jqrLLwL2ijyvPIj8UKrx9NNk0zBWg6BZhXzU/xUvgoR5zX9hqEYvRvhVfyFuAzb92
         IGDN2Hu/tHGmBUYRLgTjL0tA5vve6nApi8A5K4v2JB/5u/7gttOUTUS+STkH4/5D5FbS
         uzCQ==
X-Gm-Message-State: AOJu0Yzh56d9TcObqARRj+3E8cf+YuAb9CgIJnrLDifN8TFcj9fenQMS
	+M/4NItx8vf46VsPd+S/h2jLclBkp2eT0x3YsRe6onlfAm48xVcqViElwSBv4ye/d3E=
X-Gm-Gg: ATEYQzxrC4CM+nXyNyQ7/iLPpmV8piYcDBM6xzRqwqMTVIgEOtAwBGU4/GtbKVcRLaB
	fVIwzkOE8E+rS/ZfM9XAN/1r9jsF1aq5aBHWyvV27FcDQRreFzAo55vdaTcG1p7FY1pn2hirEZO
	aEZWhvep0OJYRaVpQ7hMRTqjM92HcP9ssgM5JhejRrwxEYMW/LZ4qYLLsiCUoSlly0bW4QffpHU
	omONnHRwvehsKoR5eL8XnlWNqFcLD+NAw7clkSOse4NGUmeaJMXqNScKgr7RLShTHCo02ljiHo+
	En6k+f1sc9BmqoY0S3kWpYatfOTVWbn6Zu+cnUugv6thEbx7c6JoudisEGFyWofvYg5yLX32A59
	Oq3OF7i2qjVMV+RHkG15/I8Oi7uXNYr17qIcqMk8kVIdoFUDNY78ywtVH3Jd7hbvoRhdWzfYaW1
	5RF1IpfomPe4AFD7NrPNUaZBIbXOxGMiiGWN1NtR0dih65pKd3c0mNKvf6yh/vhg//7DG2
X-Received: by 2002:a05:600c:8b25:b0:477:9a4d:b92d with SMTP id 5b1f17b1804b1-483a9637a0emr185809025e9.5.1772115989240;
        Thu, 26 Feb 2026 06:26:29 -0800 (PST)
Received: from ?IPV6:2001:1a48:8:903:1ed6:4f73:ce38:f9d4? ([2001:1a48:8:903:1ed6:4f73:ce38:f9d4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483c3b84139sm54445015e9.14.2026.02.26.06.26.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Feb 2026 06:26:29 -0800 (PST)
Message-ID: <f35958ae-c3b0-49ca-a22a-983c2e23459a@suse.com>
Date: Thu, 26 Feb 2026 15:26:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm/slab: clean up and constify sysfs attributes
Content-Language: en-US
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>,
 Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260223-sysfs-const-slub-v1-0-ff86ffc26fff@weissschuh.net>
From: Vlastimil Babka <vbabka@suse.com>
In-Reply-To: <20260223-sysfs-const-slub-v1-0-ff86ffc26fff@weissschuh.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Stat-Signature: jax3w5pykcitfx5gocuqg45p69ziehsa
X-Rspamd-Queue-Id: E1034100003
X-Rspam-User: 
X-HE-Tag: 1772115990-686287
X-HE-Meta: U2FsdGVkX1/b5ScBHQhVxorq9dUvSjTm5c43JafKQHXAJdE2DxLMYVdtU4Ps6kpuVRfRy/Z/+tdH9voflQGOTdmZaJsG3igQhecu0f5v8D3yseVSjMarOFZ2EIf279LCmAoBa1qvZJ6+o+lGpSgblBbVX5XmNnPv1gnV8C8UpKu2jFAiicYqt0ZH4jjer7BK22rcL+ccr89WpVWiqgCrv27QxVTD4iOyEsq+LnPdZsx3gnKAreIOFtZN9UCV654GINSIGvxiMgajBxTXAbPjZjhyMEfOFoG8KuipKVeUJMdbXQLm9SxYBBvwOYvo7dx8gX0rVUyomZJt/7ZktxL0yVNsIydg9loowVzXCkQ6LojvJXRDautYsAxq9qkB/KFyfOVlxJ0hTl0FspNeykDBd0MkVXu/RVWCCQl6yq0olXt6bFNM5qvOn09RNIITy+yCY7EfxUn1KKT0fMQPVPZkfR4WL4ZwMwytjJq/xLrYKecilUk5VUGtTdreVw5Ohjj5vawCR72tzOai/bhrEQKy/Kj8I0bPCxPXU4GzBZaxQZexhA/Hsi7Iku7hFiCJDFWBkrJFAxC/CP/T8KBcnXuCEADXO9t8Sqe2d9keCdiC7lCwHx6C+INNSoS/0L9fv87+QYAQo+EwlVq8kFh1HvVH50L3K3GQsd+egc4fqRwdiD0rODL+FhkThOoltS1sYarxHUJI3lgNynkdr4lBjCtlB5NhS7HoHUXRuxah1wl/MUU9MXTc/HDl/JcW2/LbT/p1bB6hugluzbucnAVKUb3qcOT3QqSxf5AF6cx1AkxWdcmnCMlE9a9DB6q0iLWKnzyhw7DsNEfHD+uh206kmqshnwM4o99Lz7WTh9tKNmT09MNTp4bZFOaETTc42GEdXMXEADjFdfCPt9qvIUbqWaaxdtOx4Ztfc50+WWlrYUZ/itO45G8GLhLE5FWIyDtq+4l8PK1BSfXKH7zNi2dyEBK
 QggqMcf/
 9CFDAocUSoIkgT9ZRyR+6mtIdceNB5bwny7Ny/ZZmg7HhM+ulK1wGJrni6+blgknkDSkEdwMNDTZvlxSjURfUR+l9UwsG4+bytLTIkrnRMOHC83KBEuAyQWiLYDIDJ0Mm9uJ6EXvmpKQZOHrXVYCt9VqDc+P90Fei/JM7I4DiySzpnLvMiO5S96SWZQsUaG8i4yxT+wLMhMKQ3hY14awS1qKIzrwpPyqJYLPkeO0PtyocBezXhWSV69JV6q24ka2fEtHcqmiDRZmv/bItoqsl4rUSRFhu/W0P0OJo0CWUB5IVFWWjWjJldMYR013EtIk647U57jU7ql95XhOsEBSxG1bCFYz/vGebA4fwNPyPBLgDa8Np4omR738PAJCm7J8ujFcg0IRit1P0T24vZXRxwqYEeDTElZzbKRMpDEYU4gvGpzXZ0t8fWFNXgzgFiHbaHmVY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/23/26 22:37, Thomas Weißschuh wrote:
> Some small cleanups to the slab sysfs attributes.

Added to slab/for-next, thanks!

> Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
> ---
> Thomas Weißschuh (2):
>       mm/slab: create sysfs attribute through default_groups
>       mm/slab: constify sysfs attributes
> 
>  mm/slub.c | 24 ++++++++----------------
>  1 file changed, 8 insertions(+), 16 deletions(-)
> ---
> base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
> change-id: 20260223-sysfs-const-slub-3bd764c37b6b
> 
> Best regards,


