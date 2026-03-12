Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54836103E301
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 10:26:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EFA06B0088; Thu, 12 Mar 2026 06:26:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D1B26B0089; Thu, 12 Mar 2026 06:26:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F4AD6B008A; Thu, 12 Mar 2026 06:26:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4ECAA6B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 06:26:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E4ECA137BE4
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 10:26:50 +0000 (UTC)
X-FDA: 84537032580.06.D60DE1A
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id F204CC000B
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 10:26:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XMtkSaOg;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of seven.yi.lee@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=seven.yi.lee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773311209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XanPOnxY51YvsD0Ag7bQ6//A3PB5jw978tzRC78Dbxk=;
	b=QSlnBcbZLQfJI50Ykq3vc6bDxzcZTaWNVkekJPMf2WxQIO19s0GlOk6grWMe28s4ZTQwOS
	nhKRZQyC4VfEf99Nut4Uui1croMNZKqF3PAsVHgQFiB2fuP0QB2BnAZI7u52a/KSdLW7cJ
	qAMS6sqeEUdIoFBvdAa0J3V+SKTJuOU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773311209; a=rsa-sha256;
	cv=pass;
	b=3Unw8qb2mhg6hycfofwF4GdU17wFUpKi1Pd3Idv39+76jMIEbSjuyb97gMWvnPsXUCQeAm
	LZxYyq08k70WwVKeInObZE8dRgYM1hV+2O+/DEjQK4QfM6IXauVX27xUQ1smMQ4WH8AR2U
	MFWpG/bTvWeUxWItY4OYbqTdksRfJtM=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XMtkSaOg;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of seven.yi.lee@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=seven.yi.lee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-82748257f5fso1130916b3a.1
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 03:26:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773311208; cv=none;
        d=google.com; s=arc-20240605;
        b=CPAQPcSVtyVb+q2ArhTsKfyznJhlWZTI7p0cBMzrM90KaYGsdrjOZiKSrQIYCYYovn
         EPQtsSe0t5gjyngTIMcWQbhImhuNQBG1y67WPHkZGbRn9Rtk+gLFIbDF+2noNgqxWaTi
         +WIpM1S2ObNhIhqTWKcQQxYfkn3HZBpFG/5avknV7K7ZuxGfIT4J9ITIbwfE/pOonBHg
         KcBkb7a9MwK3PwCUBm6p9uQ6HeJxSNwQ9CNmr+BQd0YqaHh0zaEAp0cI7HH3HKTHqD50
         2Q7hceEfqF1chcDm4XDLHfBvcGlEhUvmXfwA9CfgOUk4PMc/Aby38qkmDQFjdlz4smfn
         iEDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=XanPOnxY51YvsD0Ag7bQ6//A3PB5jw978tzRC78Dbxk=;
        fh=03B2eNhb8gIj8k7V7KmmViKy4r916P9QInXiRYaJS9w=;
        b=IdNMsvP9AD0WL0moQoS5OJ7ePjmqOoY/Ql9hYef3kyRjQUvAJ1vjic6vS74C/ObIRH
         GoD3bt5W4gP8cjPIJ0xDKh3qLjHsbMC6+yECuzZhXYqyTgrGnwARlZXR766xXBw8MPex
         mqk+H5ValAaHcdUFDhqTLt9f/MDk1cZR0yqVvjbbBChkiVg2eISscVV45Na+PTTNnRZS
         er0OSre+oTbgggBdHdPtewpQW6Ha/TLR5dYaPz6Leko7fnu3yHc6DSmwd5PTSdTYuyPM
         bY90eVCU1S1wnympOw7APO+pNPj7/TptVMAs/VC9EFOtyh3jITLkAMlSGgBKiEvAtTP4
         UfbA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773311208; x=1773916008; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XanPOnxY51YvsD0Ag7bQ6//A3PB5jw978tzRC78Dbxk=;
        b=XMtkSaOgOmk4PGIPIH5bpGmHk04hGEnkXnj8FJ2uMGMgw7I6rJyfSdp6YKrmlnqWmy
         pvCsVOB/8IDrG4fwctCvlUZiTXuzPAz/WIbNfWarPetT6EFMKQbIlqN5kR26jizw4jWj
         Hy6+ZeQ8mU3yZVZJ1TW4XmJZKGuUTJ9cD/taM0ZievTyWTuVibTZvBIdeBi9D09/zT1G
         drEyTuHBql5UYNMOkgu+CDsj48PEeHstmetdLm6bvru79b7qA8jgF46FboZqYrsJ2dFb
         wLFK4Gpp/T2i2zi5Rc8a8O0FUmT/iaLvrg8xEImYejj6RkFAaZbiRSKq99oRsfiW0m8F
         J8bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773311208; x=1773916008;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XanPOnxY51YvsD0Ag7bQ6//A3PB5jw978tzRC78Dbxk=;
        b=p6Wt5eKErlMVZeOkAqz/zdAoW7JZqxQtOVZtQMx8u/ubIrffvyhziPb09u1h8mi6ZJ
         q9sPDshlaHG9UFlE4CWvYd1bcCJS/4deZcsa+6CkI0smFfAm8DvW5oeZ/mtYPgECPNxW
         J+5nMF+HPrrScZ8rdehpjnNj/K8g++ibT5vluBL34+HVs45g7q+a2HoJjn0cOYQL3LmH
         gySBmqqKIvytC++ur6HF9ryMl6DecqPluU9s/gMXMR0ZVbQs3m9fWd/2c6aP1P6WbkqS
         HqgLuGQeleeDeXOMexk72CEHtc1ZTdMPXjy5Ta4OhmJjPGOUxhrqoZkpL6jLltYbAU/P
         6rdw==
X-Forwarded-Encrypted: i=1; AJvYcCXVxw4eVEOGYnmCCl+vVi68R0j06dZ7uxOzl+sYavIp7p6N7sX1hiDhoSECKsc7rDm3C8o0IwUStA==@kvack.org
X-Gm-Message-State: AOJu0YwHze1FaAfskZUJ6YpdkAuR4o4IU2hmegnbIqu4fpydvtlceFhu
	xuPKj3ZqnQmjpyCK1p+Dnw5eZr7oCWhclUNO12Wza181ksCvaGvO2oIDUUwUM3yc21eOmM2k2F2
	8eztH0T+Nu6CTUYTCHatlSw/FPAFPWWI=
X-Gm-Gg: ATEYQzwHIXq9sxS+c2+GGHuiGY1l6nyhJiqRnEA6RI7HtS6u7RUBfhhEfB0J4XHXCZm
	eujUlvT+q+Q0eo8motwJk8A57un5C5PzAawbohquL05kZnMuh7vcmjRq7DslF4vV8eI642hxpUf
	F000R6VBhALXwidLZn4x1zQz2JTOMLB4laYh8cnYWnJOVYG0ok4B0MU2XYmbWxXiyddPOVwYp2y
	LMJzhRXv/ifj2qBxrpAFQ1YARxe3V/96wb9HCk7GwqQba/rXs0CxdyQgg4Cy6ncqfa+zvs0xocx
	SS98oJoZ9A==
X-Received: by 2002:a05:6a00:c90:b0:827:26b6:c11f with SMTP id
 d2e1a72fcca58-82a072febb1mr2946528b3a.31.1773311207770; Thu, 12 Mar 2026
 03:26:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260312091207.2016518-1-seven.yi.lee@gmail.com> <878qbxpeoa.fsf@DESKTOP-5N7EMDA>
In-Reply-To: <878qbxpeoa.fsf@DESKTOP-5N7EMDA>
From: Yee Li <seven.yi.lee@gmail.com>
Date: Thu, 12 Mar 2026 18:26:10 +0800
X-Gm-Features: AaiRm50bQAC-fpj8JCT4o2RRLkW5gPS8IrWtPocoCdZLLPZoUx5KKkT0m0xLzPI
Message-ID: <CALX8JfTEEXWNVJdDGK_rDCQQc4swR1ApyShUPYX4U69rVzUosw@mail.gmail.com>
Subject: Re: [PATCH] mm/mempolicy: add sysfs interface to override NUMA node bandwidth
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, dan.j.williams@intel.com, 
	linux-mm@kvack.org, joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org, 
	Jonathan.Cameron@huawei.com, linux-cxl@vger.kernel.org, dave.jiang@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: 5kzq36mpqwt4mnopbtoaun47kqk189pe
X-Rspamd-Queue-Id: F204CC000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1773311208-150950
X-HE-Meta: U2FsdGVkX18J/b8PX8Xf8EzKl3sSAsKVbNUPX73D7UAFkN2HG8Xa5Ado6t6wksRcL9SwqAV1z3Pe0DYrZBgf497S1FtWsb751zQxN6Vn7k2/gZI0Pu8RPJ0Y66EF9DORKgbCQaawq3Y3pmWpm5sHFBZl3DrptMI0n41/FHThaV+OV37h6b6pQdlUxac14Hzbpd72GankDB5jb2+idLcBAe3ZWracoE67e5/K5xmjRihA3dhUdgBWg+DsuXesdW7kzfOtlPwKcA1bU7NCGeCnAacw3YWK7sD/mJVqGOb9JXTz45+d0LA67/nMo6FyZvr2zt/BGp5tYa6pJE38U8niTqYkn/VyD6UW/bgAaGFmEc9zTyx7VA47UrikGj8VxAYvRWHASFheRDRNUp1VCS6VSyO1CdRD7uep9uFj889bSNUIiqXtEUfBcLLBGQL38FraZaSEVl4vfB87s9MCW8+qRBaWyR961kz+dAqrwijJprSU3NMwkxYRMSK0c6/47gI9QlgCjXRYDeqXTvEQ8qAIj+7ff6kwACzrULJTfEM53TUgMD4yOFO9eNMyLHW3Cmhab4gYCFxL3vA5XqYGltSAJhjPSqAo0JFut3DPdkq81FD82cVh9VThvL637vEG6fae4ZcEQsiPi0OFCbFlJ3KCq4qrjA5XnnyCOJvLUVpYS3rgNhLHhsqyXvZH9VrkuNp6I0UQ5X3fKJoFvafY8z37XbvRZPrcGN4guEQixEL8IiMx0mEiMTpJyQ+T1ck6JHgooNbUY9KTvXuWtjgXaLzmfhMgg/PvRmSHDIc+eSp9kmrxGPq6IiamSCwW4XUHy4bK+yDfxHllTZO8pgFtuJbszWTHgwwe+5nZ0TKIZkMIw3R15srBb3tP26BOCtiw/OXQxUMeZ6DCye3mauN6ZsadOzzRdrKuy+XGvIu43gGiz59AQ56JiYo+mc9cLsMH4fXrIJ54P7aXwZJ9t5W4s5o
 cljZyJcw
 4lzpiBZ+1eNj2j6T7DR0R4R6//MBCBiSqKdxk2YxD9EDMny67KggNyApfTTfpFSlh9wlsZdvaekBKLAapRu7rXZcb3TD8eBf7Qp0+NYgEaGUNOR8yp8F/fq5ktQW46xyeYdCKwAUy8Y5GH5QG7udaI4JsOmzUnx+Dmo23k6CARIyW1pvkIkhhIhUfvvtUrLPRcFFkgWpfTYa5IvWaW407bw30tISCsvzGmimpDSvZklKwIB3/O4w69WJZHu2eshbMOwKtXef8bl8i0g+JTYU3VqoEcPKjI3SU3mAKH8xamGLVN8PpoiGF8rhyAXAeGYrMACbVRFX/soGneYtwyC7MXEt0i+od5nTf0CgMvg1uod7roO1RWiolVo15IiBnsm+/uooHnRhU1KW4yH/Qu6eKy5Ml9eGU5/KRq1TAXqguv/LuB3HIq1qQSOJrvL72WTi8SpOy49klVlFDHaRYuisJFE8TmdvZNCt+gl45+rC2EI3fV9oIrT3CqNkPRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> How to use this new interface?  Can you provide an example?

Hi Ying,
A quick example:

1. Check current (original) bandwidth
cd /sys/kernel/mm/mempolicy/weighted_interleave
$ cat bw_node*
20000(MB/s)
10000(MB/s)
0

2. Check current interleave weights
$ cat node*
21
10
1

3. Override a node's bandwidth
$ echo 10000 > bw_node2

4. After override, check results:
$ cat bw_node*
20000(MB/s)
10000(MB/s)
10000(MB/s)

$ cat node*
2
1
1

