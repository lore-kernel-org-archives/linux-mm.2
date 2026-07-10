Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A3D8C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 16:47:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FF4C6B0092; Fri, 10 Jul 2026 12:47:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AF496B0093; Fri, 10 Jul 2026 12:47:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 777576B0095; Fri, 10 Jul 2026 12:47:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 501256B0092
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:47:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E97A38F1D4
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:47:47 +0000 (UTC)
X-FDA: 84973448574.01.100FA68
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1C0D140002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:47:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="K/0nc6m1";
	spf=pass (imf04.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.182 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783702066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ldYpDeT5zs3T98XMfsT8ni9uE73SXe2oYxwTATvCf1s=;
	b=D7lgELme2Zu+jVBMySnJNpF5/bF87N99MPfE0ZsBcn2P8OPVKkrduADOajCJjVhgNyCACl
	Scpkpg5y96O9DC8GUBD86/H4UQaOD0unSbdoQHruaX5ZEDlxp1EMGJVwADF0gf5/JmiDWN
	4VakS1FGsDzxggW/E/bas5ZpF/mlq0Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="K/0nc6m1";
	spf=pass (imf04.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.182 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783702066;
	b=iRRSf1J0/B1TPGjENJqKokmjb7sqCEH8kMvWfowV3JuRQvBA3sgTeYuXMyJ2DJlDli7Z2h
	4flS8SOTqgD2cSypeIQWUvSg6LCfPXZ0lq9fRk4fdeAAhXJw0T6Ru8xR55w9tKyqjIWCMN
	37seLDaJ2PwwVg+3TB42ASCgBxQ72OA=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-9204711e831so93963685a.2
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1783702065; x=1784306865; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ldYpDeT5zs3T98XMfsT8ni9uE73SXe2oYxwTATvCf1s=;
        b=K/0nc6m1/2uJoTXzWE/XHoZLqezt96mWtmEDBLR/KNQkcBNRefom3KyaSuI44lg9kT
         vZTPYnSFE/uCVxMpzXfBZ3nVa+I9haBO9LIMYx0VUJrJz+P7qMJhf/G9k/LSeOAIaoxr
         ScX5VlbzTtSbvaSNSxBO2K+N9RWoagG2oROiTBOhJwIEWxU+7AUmDQB0NF4hcJUN6lmZ
         KpRCk225R7BJKyBcGMVQY8STBPTygqzjJMjGm7vkQmMGYrVbi8eOhYLAShABd4tPchMj
         DNzxTY504KveqzB2Fsaiu7p9oHNzEGfgZAY+aacYcQ6OWsjB3T3h0lpmqLr2iW9sfz04
         35KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783702065; x=1784306865;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ldYpDeT5zs3T98XMfsT8ni9uE73SXe2oYxwTATvCf1s=;
        b=nWwepNFzn8QmCpPD8KGh1UClaRZlq8+ooZn+wG1QeBkBIX4NXwm7Lwnb2a42ejrwW0
         x0qAVLoGn9Hl5a9QhWINNRdqVTAHKs42iKyOzPzSc3lN7PGsMNDF0Ri6pfCDa0dtoRMC
         y13EJrJshltYVZyHKsTMnuHmTJbX+SgopnCyfIzC4ywG03ciYJe+cV3L8q2vfXMyzoqN
         94/5PINsrr8tizP/StbzLbnsa++UL8KsLAbdpFhrPg6D6pYxN0S5P3wwIUgQTwAoAR2U
         ntnTntJ8ot60ze9xrsX5gCCKOqEhnR0mXsvfXsRZyMMXVToYUDN79x+7UvscjdKp3CRf
         nXdA==
X-Forwarded-Encrypted: i=1; AHgh+Ro9w6Blhm7BbVW9Igtlaw4byr4q/CFbIJL23IZflwY2NKIrJvtg9o/GutsmFz6U0VSzD3sLwxh6fA==@kvack.org
X-Gm-Message-State: AOJu0YxRByJ+PbLlZP3/zZHJxK+hjY7NwkPAOnFikglBHpfsCfIUf9in
	Dlwnu6D9c2gi+QmA2Nd+83YzUhDlsYUqBjdPqN3PQEvQlahPU4PqvEM7KIPhtf133OE=
X-Gm-Gg: AfdE7ckXNd66MpIJ1raa3ZvcZCgfJGdDPLA8o4eTfQoNv+uCbP63eEcwVHBTNziflN0
	fEoTyqoZew6me0CYYwobf2qIdcCrZsa8cTj2NM0WgDjcjviNXYJNiz+BkzBGsDjqavPt1XeBRrI
	IClDzJPHERNZZQXRIUTnewXfQYsj5qZ3uypanzLfpbzlpT4icYzxUioRRd9ieayb2a47PLIgwuD
	5mzQxsS3RVzSjGEKaiR74is22Q0GsUh6D0/di3fzyGROOJpc4ope1Ilye1d8AkxaHx/9P+2f8hd
	A6wTLJEeAZ6gHDRBwU9BGoLNhb7W40z0N5GyZMIorXb/4N3nmMSboTvFlVjy50aDRup49kjHhGW
	5a/Nf8LQ0MVTmiYj6tk7Qjg3sbUi4V76J5xPB+7AK0KG4b0ZawI77I4WlbHRb
X-Received: by 2002:a05:620a:4044:b0:92a:3ceb:9cf1 with SMTP id af79cd13be357-92ecf68b839mr1385461685a.37.1783702065110;
        Fri, 10 Jul 2026 09:47:45 -0700 (PDT)
Received: from ziepe.ca ([159.2.72.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd5bbac2asm45778726d6.21.2026.07.10.09.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 09:47:44 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wiEO7-00000007ZDn-3hnt;
	Fri, 10 Jul 2026 13:47:43 -0300
Date: Fri, 10 Jul 2026 13:47:43 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
	corbet@lwn.net, dakr@kernel.org, david@kernel.org,
	decui@microsoft.com, haiyangz@microsoft.com, kees@kernel.org,
	kys@microsoft.com, leon@kernel.org, liam@infradead.org,
	lizhi.hou@amd.com, ljs@kernel.org, longli@microsoft.com,
	lyude@redhat.com, maarten.lankhorst@linux.intel.com,
	mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
	nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
	rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
	skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
	vbabka@kernel.org, wei.liu@kernel.org,
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v7 2/8] mm/hmm: add hmm_range_fault_unlocked_timeout()
 for mmap lock-drop support
Message-ID: <20260710164743.GX118978@ziepe.ca>
References: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
 <178345362182.660027.12809852179204464964.stgit@skinsburskii>
 <20260710162749.GP118978@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710162749.GP118978@ziepe.ca>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1C0D140002
X-Stat-Signature: bf9wqc689xyqx5j3m3xswraxf1g381of
X-HE-Tag: 1783702065-754019
X-HE-Meta: U2FsdGVkX1/keKcyNnoICO0xUXytUyEB9gdni9ivXHvwfTzV6+M/U9MOrrpkca+KWNugmFYXdQtz7rL5KXzpUbjOTV/JJwYGD6xgasj+onvHep7uDYFkVkwtDbGQhAZ2ltHWhDzq0ukf7HRfvCgPDYVOy7Sh1r0avyC0M+INxJPMXTMS4T0OFoC7X9OJYQUyqEb4HG7S9h22lIN4Sq8qtSSOj6tNr/qDfbQgRRxafm/hxx2VYhA7Zc3y8f2qX5korNaO6btHN0xvQdMr2Q7rl7WU/n3QKlkjr7qzrMqxMtWqp44b2f2k9iE9LIkx6JgpaeZjovA4jdFKmj/Xg3BoOw8n1l0JMsslrszm3E2HhMyhRxhLZtJdejXigUDsW2TOTI/QbQS+9g6a+5FQltcKKVTiQka4BAArE7kjNrSX1f8SVL7AXtmI7E3XB6fmoefJfI39cj6o6nZ23J5sltAvY3ojgK1huy8mTAtl9FLCTbt5yPer2S3uPDG5QerO4Fn28kyJg2YM+Z21pR4f1lD8dqfZ+0/EQTA5oabISrCmBiGjdJUjBbV4g/AgChWX4ri1Tjmn2m5aF48eDZzyuvIpejbbDt1IAzSRErvolbCDQLZ8UbsLX1XT22RLjDnmbRRwzT03YvOAVahrZmkVzlyDCXuhdOZGkhOWmDTyzU4JKoTrmdZNTfGkdaotZ8iScSd9SLk+V4GXhy6PfjfEwLIot9wltUkzKZUB6qUlD1zuRtjLHu2eLuWP/uQFeny+6jJL1x9/Ai6AHRb+t2YxzBjQUluvl5fatZQqh/yOHjZKhOS2iwbsGgvGDo2fXhoZpPnRnyjsUk6B2BWXp8Vkh44P1TVD1NtwJvAuHLD1OXd/kYO/hzd9uT+r1FDtbV4rU27Gh9RYmGr+jPmAOQG7uvtmfod+zS3TV/UrUUb6+1JJp3XwIanPhKNRb5nKJp9+vk1JhZtqoCaYfSzPPFLoSzE
 TTwcQSs0
 vTuWo72Dm4VXQnFwueF8L+6QpGIlvhCDYDqAnNRwv7I+dO1ab/riX7/MTDDCCjWUybq8O2Zsztk9O7iz+irftL0cQIci8U77bl3JkELTteuc8z6LEPp3H/V+Z3MGFUyZxR1o293vMW3t4X3roSImxqhxzi4p45S1KHSoh9lFO6ro+s9ZLVPaKW9zvcx7iTXqmAuzPkkEW8f+sOuqFd1BILLsfVJbmiCWEQ+CK6uSP2Ms81JSjoU8x99g2Yk2CH+hdvb63KDA9JUZx2sZRhQvTu9QEXwoZEQjRN92oQzsWEC2iDNt2yPQk9eS/vSUlNAFD8ueb1No0nmi/hWE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 01:27:49PM -0300, Jason Gunthorpe wrote:
> On Tue, Jul 07, 2026 at 12:47:01PM -0700, Stanislav Kinsburskii wrote:
> 
> > +int hmm_range_fault_unlocked_timeout(struct hmm_range *range,
> > +				     unsigned long timeout)
> > +{
> > +	struct mm_struct *mm = range->notifier->mm;
> > +	unsigned long deadline = 0;
> > +	int locked, ret;
> > +
> > +	if (timeout)
> > +		deadline = jiffies + timeout;
> > +
> > +	do {
> > +		if (fatal_signal_pending(current))
> > +			return -EINTR;
> > +
> > +		if (timeout && time_after(jiffies, deadline))
> > +			return -EBUSY;
> 
> I really dislike there is a timeout here, HMM is supposed to be more
> deterministic. GUP doesn't have a timeout, what is this about?

It looks like you've moved the timeout processing related to the mmnu
notifier sequence from the callers into this helper. I'm fine with
that, but maybe add some comments that this timeout is helping
implement the mmu notifiers, and we do expect that the HMM part will
not timeout.

Though it is a little hard to see how your stated purpose of enabling
userfaultfd is going to work, aren't you pretty much guarenteed to hit
a timeout if the userfaultfd process is adversly scheduled? That's
going to end up broken.

So, maybe the deadline should be resetting after every handled fault?
ie the timeout really is only about the mmu notifier and we don't
count the time spent handling faults or walking?

Jason

