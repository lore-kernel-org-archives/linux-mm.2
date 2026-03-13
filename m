Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19996106FD69
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 02:22:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 039D06B0005; Thu, 12 Mar 2026 22:22:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFF156B0088; Thu, 12 Mar 2026 22:22:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0B836B0089; Thu, 12 Mar 2026 22:22:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CFFD76B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 22:22:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7992CBA376
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 02:22:00 +0000 (UTC)
X-FDA: 84539439600.29.FEE7D33
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8501418000B
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 02:21:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SU3wXYAJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773368518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yoj2TNP7JEQqQk/ei2IsLY3yTJ1xZV3q2Z8oxdSgkbQ=;
	b=z7BSnyo2uwrJ+L6udmZVMI67Vb8rMZtd/I0V4Vpl18nVOQUsvCNqu+wpc8TlhkqAZH+w7X
	jPuctJtSOL2aaEe9Ed9wlIno0p8Gaw9CRIT29RFWdSZF3koVZk1CFO0edQANkTcFpPKAEp
	3M0kDDHTcZOqd+LV/tdFPu0rDChIdHg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773368518; a=rsa-sha256;
	cv=none;
	b=WEc9Ufo14cwUTw2AgLoVaLNfQFfLMbsu8x8Gh25TzT8xKKnE1B1kbeM3z2WSCGVV6LGPP+
	LTUnThgXNZ9c4tREhxwEGHbDoefFjI5S2/o2IKfM1T9q8a61kYiAJTeWXnEvGFHDdzjLaF
	PbpNo74WxkIWnzUAweYzgrqiIFWUdDo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SU3wXYAJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773368517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Yoj2TNP7JEQqQk/ei2IsLY3yTJ1xZV3q2Z8oxdSgkbQ=;
	b=SU3wXYAJtnkRMiRetgQ3d3ssDbMP8ORRvdTuy4M4lYjpgLw/14fOVHNeLGx7KHdX8y57OF
	cktyZrZeDX6EISCR4i25fZk0NWGTDi5PVs07w2XRj9KwsmqUPh4DuRHosE4v+pVaDyYNkD
	Z/UzKaRwvgg6Jjmgxh6IGqXT9T+rAxk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-467-Akn9SZghOTCS8SStdyP28A-1; Thu,
 12 Mar 2026 22:21:53 -0400
X-MC-Unique: Akn9SZghOTCS8SStdyP28A-1
X-Mimecast-MFC-AGG-ID: Akn9SZghOTCS8SStdyP28A_1773368511
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 739A2197750B;
	Fri, 13 Mar 2026 02:21:50 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.171])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B0133180075B;
	Fri, 13 Mar 2026 02:21:38 +0000 (UTC)
Date: Fri, 13 Mar 2026 10:21:32 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, shuah@kernel.org, linux-mm@kvack.org,
	ljs@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev
Subject: Re: [PATCH 0/4] selftests/mm: skip several tests when thp is not
 available
Message-ID: <abN0rOql8VXOCb_Y@gmail.com>
References: <20260312114027.634559-1-chuhu@redhat.com>
 <dca1580e-96fc-4ca7-bd21-abeddb3c8c44@kernel.org>
MIME-Version: 1.0
In-Reply-To: <dca1580e-96fc-4ca7-bd21-abeddb3c8c44@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: Tv4nggt-sRNr9LN4cGgixtQMmjvzTlwM21W1NHZnwZM_1773368511
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8501418000B
X-Stat-Signature: krdqumutp6km1a3j4s5hb4y35qm568ik
X-Rspam-User: 
X-HE-Tag: 1773368518-235216
X-HE-Meta: U2FsdGVkX1/CCYguFmNWWsDsfYO7u5gj2X5sQRtx+cK1/4SpdO1GaIKwK4EaPfwN8ADL5bvXAd/P1mlsAx8sEaplzNWO9SGHtv1obQv9bhZW0Lu2eMsrxcG3Qg3NN/fi8sXNYeo9WQXIXtWJXRyS9ZUMg3FD8ZdP0vP29keJw/mv7xPhjGeIjf25GyykXZPOeVa9P3/e9n8mmIqRTa9okAadm1/fZHUcvBJHgKHr0zrABA2JaeDmBBTauTnDfqK7NgV0ab7PZ+8cOrRzxeKXAtxd5zKAuBRZVopGEPDi+MoBFrkAE4JfUU7rKVetsrPzQZSJMgrxU2icy6F5jghRBtDfuwPF3ppCgrPyiZFGBZZ8fMaoMbDvaOad1MHQTRerfnisdSQkvIayJQzTC+AsYR3mXnlV3HNvn3FoHKnqOPP3Oh1ce8iRhgMYPViEprb8cTlT9900qs36P4+86u13z0yGePHanXb420JvdfOAw3McgLwmTYSPfYHb1uEdcb5HkRtW8bUYxmvm3DHd4C/Qg/jWa7nZcclCxUkjG/oK0ry1QpGfqaW08a6bgt6UEgF9p/LNlMvwX7j0s9AfaL5LBtATdrWsmIe4E5XjuoxIZFl/aaKvkPCSo6RH5I+8qXdWyhuaRUbCTBlFbTghndtp+9J12wq5d1oQx+63b5xY4GMv7JSkpZtJlm1kjsaaTkwEZW2peWIIXq6mr1WhUw7D4lcPJ6B/qUYCjwNw9UZcjT3TqjMFaF+lZqNKJdT4TgBIpY3SxNDtJAYmyu/AjWBR0D7yBtl8VClMRJ4P5RP202EstfsS0CAhjAEUwx3COXqzNtrWkAY2w83Egra/HymCgIfyYn5coW6DVXOenXqYkrJrbFdtRtTB/GKcRReQ/mMfUwo8J0dwn9teaRujuk0K5D4dbYtOXJmE0brnHtQbtStdG1hHlq8WSUTJeJWGosMdtTMasmhP0b4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 08:39:31PM +0100, David Hildenbrand (Arm) wrote:
> On 3/12/26 12:40, Chunyu Hu wrote:
> > There are several tests requires transprarent hugepages, when run on thp
> > disabled kernel such as realtime kernel, there will be false positve.
> > Mark those tests as skip when thp is not available.
> 
> We expend that people that run the tests have the configs as contained in
> 
> 	tools/testing/selftests/mm/config

I didn't notice we have such as file. It's a good template for people to
refer to. We can see in the test log when some tests are skipped:

  'skipped test(s) detected. Consider enabling relevant config options to
   improve coverage.'
 
Then this template is helpful for user to 'enable relevant config' when
they building kernle themself. But some users just run the default product
kernel which is a pre-compiled kernel with product config.

> 
> enabled.
> 
> I'm fine with teaching the tests that that is no longer required.
> 
> Should we then remove
> 
> 	CONFIG_TRANSPARENT_HUGEPAGE=y
> 
> from the file, or leave it in there for people building their configs to
> know what to enable for best test coverage? (I doubt people do use it
> for that purpose)

The config template is good for people to getting better coverage. Maybe we
leave it there, and point people to this config template in the log when some
tests are skipped due to kernel config. And yes, user may not do this
and they want to detect issue in there product config.

  'skipped test(s) detected. Consider enabling relevant config options to
   improve coverage. See selftests/mm/config.'

I find the commit that introduced this config template. And there's a guide
in the commit message that about how to merge the config.

  '8c749ce93ee6 selftests: create test-specific kconfig fragments'

> 
> -- 
> Cheers,
> 
> David
> 


