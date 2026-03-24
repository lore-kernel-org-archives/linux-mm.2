Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93656E9A777
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 11:49:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E87F66B0005; Tue, 24 Mar 2026 07:49:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E37E76B0088; Tue, 24 Mar 2026 07:49:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D26C46B0095; Tue, 24 Mar 2026 07:49:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDC286B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:49:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B15F5FC59
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:49:02 +0000 (UTC)
X-FDA: 84580785324.15.221A135
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9DC4F80008
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:49:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PGnL8Y89;
	spf=pass (imf02.hostedemail.com: domain of akiyks@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=akiyks@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774352940; a=rsa-sha256;
	cv=none;
	b=wlxs//SG7fBZ+bAxUYie6x2CBR4HSA6+Gsjfim3PjvBj9rUEhxpAzWx/KlUyfJzeAqgbLd
	LcwEWge7phPlI4xZYjFtgABAEGdPLi9jXPJnjO4pZpaH5TermQJGhQMhYTb8PwCQ8KlxH0
	CsrVgGTjTsfgPR5xsewaqRd7jiJVYxs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774352940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EOmnOvJidcot6jxLrH1u76JLYVqpj1sXzmwoS6+GMMY=;
	b=afTWARsfO6GSEf9ghHvHAewUUXCcSvnC4x0rzT+GD7hOZ532jiMPRXaiS5LJKZky38z0uA
	kkHLGg6Glwmcmlsn6Js41GlRCyjMAFeIRpIJUMHPGgf31reafm/6tMh4CLquEWlM76s330
	W9g84220BADvO20kzye8kdBW4Rw1/GA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PGnL8Y89;
	spf=pass (imf02.hostedemail.com: domain of akiyks@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=akiyks@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-35a1230c60eso1857896a91.3
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774352939; x=1774957739; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EOmnOvJidcot6jxLrH1u76JLYVqpj1sXzmwoS6+GMMY=;
        b=PGnL8Y89aLP1xv6jD5dpwe6hDKyiJJ1GxIoFUKxlxoB+6ACwdjM+Fnp3V1ZU/X/yvt
         yzvIZi2K/+iCCnY4zhXZMDMLZwTIMd5M1eL/BM8roP6o5RFDmat/vQ4j+pMibXaskT82
         xLENZbPLL64yFyhlhiZBE7YCT5k1QeOuma6T83/uBlv3oc4SV/uVXfOMKytjbmeLOsTQ
         lETHHsTBehXzoYGD+AEy7rnumvpGiX03NgGBCUjkKNIXlfYPBYWIGbSUURFprKtj7a00
         gx4d/IUf/b8Wt5Ch7k5D2wYHGUfZ/vYrS9cHlvD16OSY5LKdk05oHIwlDnFKDCvSDiJR
         LLdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774352939; x=1774957739;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EOmnOvJidcot6jxLrH1u76JLYVqpj1sXzmwoS6+GMMY=;
        b=Y63vfA41qb5w4fJ7X4h7G9L5Y7RjAQf1aZiXg/oMJUG+11w/oCr+XaZJgRQJEHBQIh
         x58wlpf+cER49QCObtUTHQhP0/544wRnz1Li5I/Hx4yFVYnofBlo0IzP6GPMNtSwlDjq
         YODgyqjKaTKjml9wpP3FzNqUnGOSOHs3FWdugbxlQ3fI59GVTyccqZAYkvnOqrj9P7Qr
         ChCQ23Cqo8zPLaeXstLqNWy756rGOBy0+SqGnjx9X39mRPt/0Tt5msiSsIlIj7CXQdbx
         fKhrqVdUq9x4rno5bJkye/DiFkt0gdi6TBCN/aQEL9LzL83f7XKfl+jXHoMXHA5308Zh
         xLpw==
X-Forwarded-Encrypted: i=1; AJvYcCXr/9iCn3yAH1dJLoaUyGfdQjcUYFKut64/SXlgUy5vNa21EW+1c1wRlZWOgNN84pVge21Qg1gN4w==@kvack.org
X-Gm-Message-State: AOJu0YzSwJHj9Yrpmg0u77uw14MLgoDLst/uEbz2c8tSQX+YtlfwzsZl
	g42l+pr7eR3thIJnC5YtXt+HOsKFPF0rOhIHa7zrDen5llI022rOaS4O
X-Gm-Gg: ATEYQzyl/j90xFwkih0CRCOsi2xy+LCg6Kcl+KSTbOzutaQZ3HQXZLxtjTWw7G2Vx89
	n/9/cweCExjMZDevmibxYYKUkUbg/wbea+MuEk8cRqBMP3gITyfymwpgH/Jrshtr0LVaTC/ffoP
	ndhNUpL6GDu7Ljatk5kBg3YshkQnAtXyzGl4d/hnhLcv3P5l9+Q3PyNLJGm380RtnKwOGhNdCjU
	HSQEgyau/EqmsyRSNg3tYrLrJPzEOx6mInN5zj27v3GE+Gpq8T1ye/si+KRmebDLm+DFkED5tAG
	a4J6HwfKJ2qT1T4ZqB0ZySzEciJmWov/1L+7vQ1DemuFoxH5owsL6Uet52v7815x0xV9KRFLOoa
	lfL6Kpfvk3lCKjjQxNWWWOjeq3QJB9Szu9NceZNLy9tn9eAO79iwBoDqdoMURDkmvCN75bEb5me
	RcSIY89k3iMFHqwL93DQduSdirejhIQ95esog2PSNOqHQAiw3GY+5EDYhb6AU5gRHE+g92
X-Received: by 2002:a17:902:e54a:b0:2ae:825b:49a5 with SMTP id d9443c01a7336-2b0825bf592mr154385155ad.0.1774352939359;
        Tue, 24 Mar 2026 04:48:59 -0700 (PDT)
Received: from [10.0.2.15] (KD106167137155.ppp-bb.dion.ne.jp. [106.167.137.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0836a31ecsm143127965ad.77.2026.03.24.04.48.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2026 04:48:59 -0700 (PDT)
Message-ID: <2ceb291b-3b18-43a7-9d51-5c752f1eebf4@gmail.com>
Date: Tue, 24 Mar 2026 20:48:55 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: leitao@debian.org
Cc: akpm@linux-foundation.org, corbet@lwn.net, kernel-team@meta.com,
 linmiaohe@huawei.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, nao.horiguchi@gmail.com,
 rdunlap@infradead.org, skhan@linuxfoundation.org
References: <acJh0Sk4UdjaTFLh@gmail.com>
Subject: Re: [PATCH 2/2] Documentation: document
 panic_on_unrecoverable_memory_failure sysctl
Content-Language: en-US
From: Akira Yokosawa <akiyks@gmail.com>
In-Reply-To: <acJh0Sk4UdjaTFLh@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9DC4F80008
X-Stat-Signature: 4b9df67zr3iqt34o7yk3m5rfg84mpo36
X-HE-Tag: 1774352940-966354
X-HE-Meta: U2FsdGVkX1/tvnCRGO6msPaT3/V2LTmSEyZ1eO+VI6+UZe9Ly3m7TK6XQTZ1YXh17QuIXHCM4joPenpsmvH1p4JrOqkwsSs8KSSnrY4ihEoaUY8jqz4JLjcPNdj6mUMktxqAxL/2lkEzUqoeeTFCFywniMk+Mf1uVo2lKxPxbAa9hgVrYl7JS7Ccv7c0HgxayN0zXe9XvRZUONZPNxFBf+KyjEhrGsIx/W5dO+PLGp04lZzKHog8+cvrxmZjUcDe5TtkelWxa3n68V+qcQsTYvxYU6AGNaktru399QQ4MruyeYb6sE8i5xu/KbLdsJgc7C9Ul4Og3Wu1wcWgdtFAL/99aeZgvlrKYs3C8PIHRYZtsujFyIdWiq/C2gRW4cJkZ2c+pOON9d+6C6q0OSCERU2BPd4LJNqNXDr2B0yy6LnDxLgL5f50/6u4MVZktAqDMgeRchyJrCWdp2VDbSpSJjcmU5wrZiIw/tOWjSjAcMQHXpmXKewict3VVSFZpQ1anmAnYvGK6kwRcEugvsy2rXeeiu+RArMDlpzJoLIBjQs57pQ/0qDs4sAg+ZBG+/DYNw+GEE6Gw1HJr35+I+aoXZJnn0wk3Ak1K0dHYWcB6JijWUMWq0O3+dowEiUm9G9afXSAjMozQzw78L8/3j3dgsdHllFfjp7lrNhHoI3FjGwRZKJcJQjrBpADZhmNMFZpqpoPX5OisTdxCx0iy6eDWbeYo6DXM9Kr0ZS5a2hZB46fjTLf31KbsSC8Kq7stqvUnYPjEltol9p1yWrpj+Bijzx3K+Lg/Tc++vA6ckqU0hcgkQH+wxYvRMfiJciOvwdshicNFgWPoT52NEfK02HKiP+4Fp6spR2FKzyDJUqqJX92RtXe+MdhDtWbkHyG4N/pC53CFOg8TgMcS38uthkOru6Bq7WxVtr4v7Un/GhtN00UPa/Njkp/A2TBe/cnEJQTcb+d36IWjHt0y5zma5N
 pP4WA8Lq
 vujo3Xlw+ngZHIXqv5TNMZexQf6A2SPxy9Zd8lY5feAq8YXsMygm2LcwW2WIeu8XqlP2apCdrU5U3H1rXiLLjZORlPjrme8Deg0lacxUaY3iWXr9S6fNrQPSorFpm1dcNH1+S3Pux4ScwlZcRG+44cKscrlZkYoFD1MfIMb5c+UtC9Ko=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Tue, 24 Mar 2026 03:09:25 -0700, Breno Leitao wrote:
> Hello Randy,
> 
> On Mon, Mar 23, 2026 at 09:51:55AM -0700, Randy Dunlap wrote:
>> On 3/23/26 8:29 AM, Breno Leitao wrote:
>> > Document the new vm.panic_on_unrecoverable_memory_failure sysctl in the
>> > admin guide, following the same format as panic_on_unrecovered_nmi.
>> >
>> > Signed-off-by: Breno Leitao <leitao@debian.org>
>> > ---
>> >  Documentation/admin-guide/sysctl/vm.rst | 27 +++++++++++++++++++++++++++
>> >  1 file changed, 27 insertions(+)
>> >
>> > diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
>> > index 97e12359775c9..3310fb8272fb9 100644
>> > --- a/Documentation/admin-guide/sysctl/vm.rst
>> > +++ b/Documentation/admin-guide/sysctl/vm.rst
>>
>>
>> > +
>> > += ===================================================================
>> > +0 Try to continue operation (default).
>> > +1 Panic immediately.  If the ``panic`` sysctl is also non-zero then the
>> > +  machine will be rebooted.
>> > += ===================================================================
>>
>> The table begin and end lines must be at least as long as the text (may be
>> longer). Please extend the =========== lines by a few characters.
> 
> The HTML renders correctly in Sphinx (likely due to automatic column
> expansion), but I agree the raw table format should be properly
> structured.

Just to be clear, Sphinx is behaving as expected here.

The table is in the form of so-called "simple tables" in the reST
(or docutils) parlance.  The rightmost column can exceed the width
indicated by "==========".

Quote from [1]:

   The rightmost column is unbounded; text may continue past the
   edge of the table (as indicated by the table borders). However,
   it is recommended that borders be made long enough to contain
   the entire text.

[1]: https://docutils.sourceforge.io/docs/ref/rst/restructuredtext.html#simple-tables

So, it's just a recommendation, rather than a requirement.

"Grid tables" have a stricter rule.

Hope this helps.

Regards,
Akira

> 
> I'll send v2 with this corrected.
> 
> Thanks for the review,
> --breno

