Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1934FF94CBE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 07:04:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F25C6B0005; Thu, 23 Apr 2026 03:04:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A2DE6B008A; Thu, 23 Apr 2026 03:04:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46FF46B008C; Thu, 23 Apr 2026 03:04:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 333766B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 03:04:20 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CCBAE1203C9
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:04:19 +0000 (UTC)
X-FDA: 84688931838.15.D126F9D
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id D940AC000D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:04:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B47EqKgJ;
	spf=pass (imf28.hostedemail.com: domain of thecharlesjenkins@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=thecharlesjenkins@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776927857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8qPIWsE1aC3FA/rveJpSyhd4EiiBmj/2eCVy34kXTaI=;
	b=2g50I1cEePrIRswBiy5Qp6V+CXdbFvBeKvXEK+NHMDbx+IP7JugJTtVLXVIYJCajUG6eyS
	f1Yx/NNkIFSMrkco9NdUGMLefTnhkyZ47JRzibi0mjQ8DxCXAKzbUPbhXN2SZVqeZvpgDh
	dEs/PVWbfMkmDSHSc7vJU9hiJN0APtc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B47EqKgJ;
	spf=pass (imf28.hostedemail.com: domain of thecharlesjenkins@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=thecharlesjenkins@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776927857; a=rsa-sha256;
	cv=none;
	b=TVAoPlnbUgaybspehrPB9Zt/62PoQAxRec4q2IdZse8XhhqatxnfH5aW82jDoJSHFOzW8e
	GQbIWmFgfxgSHlIiRx2rA1lFK5anMQs6ziyJlYyn8QT+svD3X4o/rytBpS6wV2GYuVudX3
	AF8lmdC65vwhCZBVMUZw96D7hSF1EK8=
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-12dbd0f8063so90109c88.0
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 00:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776927857; x=1777532657; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8qPIWsE1aC3FA/rveJpSyhd4EiiBmj/2eCVy34kXTaI=;
        b=B47EqKgJK5/l1Lwn8i64UMIzUF/SFqB/uqTh7aBA1lRhwtlg/k8bERzI6CdZKyDIhv
         NJIadrTshIEqdE6AqE4TY/Bv/azYYzWfcF9y6AB0eq2Q0XuZNoilJLcML5l6441avxr6
         miwvpMR1tgzjaNsnng4KlNPQbs+yHJTBnKRm/p/4k0ktu5BaqL+5OTgZC33baTa5Ou2J
         saxijzg1V4BGjRrwXtD1TcNCEscJxm9inETiaWcbDa2RBH560VkwBKTaTzlJ5TRahYsZ
         76Twvtr0/RxWK47wkS8V7KJwMIDGHxpegnPMzO47eUFJ/FyNZ6NFj1ek9/6xM422TREZ
         Mcog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776927857; x=1777532657;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8qPIWsE1aC3FA/rveJpSyhd4EiiBmj/2eCVy34kXTaI=;
        b=hZFpC0TtVq602UQ/vAicLOJxj6Yjhft3OLg/nsk4divDdxgBzcyRuVZs1MZGza0Qnc
         hZRrchrly6VCbH1px05NIQboSUazG6CA/TPahRFRieAlD5WFWTiiFwHrSiqLcSWlNNxt
         SK0nM0NDY7TVAP0ueZ0Mnisf/al5VZifPnx+5MoNotZfoDVOGjJZdhF1CM11f+U5eNlA
         e3XxP+1ylxHtwVmWiJXB/m581rAX6I5KXlUBWeSAmN5e9Sya1TXcS9UWM2255wAjoESx
         ZvHkgwUoXnj8VYreP5gJdhkFYV5jcdLK3olRxdBMU2GzTLNLCcqaZMHtukqNjygogpPS
         BJNA==
X-Forwarded-Encrypted: i=1; AFNElJ8sYle5kMStv5g32fnOJWpwWYI5kHWGo6uoOTfA6Ihm31LFbs2fVEp6t4KT1R4MKDP+P6b4d3jSmQ==@kvack.org
X-Gm-Message-State: AOJu0YxutzVRic/RNXke6kd3z6Oo14qVMTzCL1ZaT7JHxlKhPJmq2fv8
	oo0YhrUMB/hO0bVbGb02hOoAlmVftvhYrtpUhb13i0pOzQAFbPyHBL++
X-Gm-Gg: AeBDieu18HwfXABT7F7bR9kfgFhkH7olNlyHA9PiehFkGy5Itm3rTXrBDMcjP5DYzqo
	zNwMAaEIaJvuDom3RdYut5ROHXVWGwz3+03Cz+ctx3b9huyx97stfbeCWILTVS/DVu5FMsPvlEJ
	djXm/Gw3Yw6YD9OVBRnwHoKZ9WSwnam0w0iwqOWfOlznlk44/UapZt47ZeGprCSbmsqSmTIv6fz
	lxmiZnsMLOT65Yzjhk7xJGyjYRZaQtXlLEJXGtEX/T9eF4hHoL4laHHT/g6WXD/jvjJbLJSm3kL
	Z9hPDTCo5lB6Uruos9YpjLXQkVz0m+mcPBDMH4hQ9loMRhIbMZEnTROEtEn1Udk130W/RQ49C1A
	yUSolAUN87Z4WcC/5qvEO6lkbZTdzEk40FPhSCqSGvjLUDi1gui23l+lhfgsonCdGScpqEE/9SZ
	gCV2Mr5ZAfBdE0Rvuq+K1XYIu096+XrKWKkQ==
X-Received: by 2002:a05:7022:12b:b0:11a:3734:3db3 with SMTP id a92af1059eb24-12c73fac54dmr17782302c88.32.1776927856545;
        Thu, 23 Apr 2026 00:04:16 -0700 (PDT)
Received: from inky.localdomain ([2601:647:6700:64d0::3877])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c74a185a8sm27322792c88.9.2026.04.23.00.04.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 00:04:15 -0700 (PDT)
Date: Thu, 23 Apr 2026 00:04:13 -0700
From: Charlie Jenkins <thecharlesjenkins@gmail.com>
To: Kees Cook <kees@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Documentation/binfmt-misc.rst: Clarify "P" flag
Message-ID: <20260423070413.GA156309@inky.localdomain>
References: <20260419-binfmt_misc_doc_update_p-v1-0-757c12f33cc2@gmail.com>
 <202604211026.C462A59EC0@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202604211026.C462A59EC0@keescook>
X-Stat-Signature: bhrndh3mufjrssjgd516fsei9r8w3fpp
X-Rspamd-Queue-Id: D940AC000D
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776927857-708349
X-HE-Meta: U2FsdGVkX1+fkiVulXHu6UKB6ssZc0czlLvMBOpHNnpmqT3nEy4DL77zhOFWmg6ACQK9UusO6UvzY9weWoSE8ApDXN77eurTlYNRHROp/0PJYY/wRjgm1czJsO74aDV3abEjci+i/puAj52ED9M3aEs05Up8oac8JHkvVsZ6HoK2a8/pRD59VjXdPscpN7ah83JfENpiBB25lHN5/jSPsaWb6a1KO7CO04wObfsQN4S5Inhw4q7Esl0SBEJnXnzMJPrktAgJUjy7oFhT5CRGSu+IgYn5zBh79meUJWvQjofW4CirNtt0ZR/Ug765D3HwFuT6Hn+/CkMD3Hj4Dindb0MSKtSAF69GaT2nlzE0Ud/drBd4MQ4Jy52YpLih2h0fNZflxB8p4Uz8iCwkos7xH8UZA04NiaAa5j4zXHnGyQFUZpDe+MvpzuGo03jibtIk3C884X08O8Y8h328NDVhg63uO/n29xDb7qg/FjfH8yfwA1ozuQ6DvtQI2oHwpCucQJHyCRNoTXOCvMjcvHSzLmdVDOTPZD/60CGJ132NF8eleVBRQzwh5Xu+FoJpMY4WsDuYzNDdPc/jYruv2GyEpXdk7Cuh66gtoV1C3GCYro4nKwCMkHv5pTczv4E/A+ovjltg4/MsnKBHuYST1rbCU89FfbAfO8qSdnKnkr0opPiN3/MH70GZ3kKE3/eoFRFoZSgDKyJOxGh1t68YDBbRatdXCxhEBOVXS+L5faAmB4IqqhYtmYYnAnzoRKwGhMLY0kN/CPTsdarnNa7wQ/0dGxWvfSQTtdaYygxQfQSPPNDe6gcvnCxTs06z3tC/6NOSQ9AaqR9FR9ZcsXXGnUIwLjKOQv1FlWdJWA+lczgFD9M6u6VjHwePXVu8EvvBxWqWVeuN8rjBbkIrjN5LR64UH447Z9tkET7U4NdsG/j6bSpYBSeN2X0x21eqYd6J9wW/CQRZvOXmhGPrjj1lI7C
 UB28yvkz
 qmDJU+ymMzILDFQ1WPx0RI/xIztAhOlVJS+UIJh2V28o8Eitjb+Fw1lmSOt3ckbb6Q42itczddgw+4/ccocTgluhGBcESJRkcINKecmmsYnQBQIhuMRA9yb0grH5QWZXJry8dyi1FkwIZUCyrp3oYrHOubGvKfMO6DNbbxUF3813DczdvjoXtsqIRH4cHngzEbqMm/t4SId9apbKHZFe3+/rfCdrvcOe4Skr8mzEsZWbgxAdSwuzlDepAdHc8Y6tyPayPAFUFeF3HpkVWPoBm4kPkk7TB+ohOPJnkHjjbSMf+KYg6u2A2Ne5v/UBRM/b4R9A5Xsz8+b1wu2EpSVt/7WVePOCNLuhf+5f3eitxwZfbvvueLoqDKRrz8+KPGXre6h+9sf0pc5xUbyZ9LKFat8vEVd3KwSBlbzO+UUTLxhOr+dOXUT9fmHbQvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 10:29:07AM -0700, Kees Cook wrote:
> On Sun, Apr 19, 2026 at 12:11:01AM -0400, Charlie Jenkins wrote:
> > Improve the wording of the description of the "P" flag to explain that
> > the interpreter gets the path to the file provided by execve and not the
> > full path as well as documenting that AT_FLAGS can be read to see if the
> > "P" flag is set.
> 
> Thanks for the clarifications! I'll get this into the execve tree once
> the merge window is over. (I usually wait for -rc2 to be released.)
> (Or maybe this should go via linux-doc? I should add this file to the
> EXEC entry in MAINTAINERS...)
> 
> How did you happen across this mismatch(?weakness?) in the docs?

I was writing an interpreter application that was using binfmt-misc and
was using this documentation to do so. I was getting unexpected results
so I read through the kernel code to figure out what was going on.

- Charlie

> 
> -Kees
> 
> -- 
> Kees Cook

