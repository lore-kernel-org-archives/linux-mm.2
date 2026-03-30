Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45D87FF494B
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 07:23:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 529976B0095; Mon, 30 Mar 2026 03:23:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 501696B0096; Mon, 30 Mar 2026 03:23:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 417856B0098; Mon, 30 Mar 2026 03:23:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2FC586B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 03:23:20 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 35535160596
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:23:19 +0000 (UTC)
X-FDA: 84601888518.20.8FCAB11
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0F53480015
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:23:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WMEpqDF1;
	spf=pass (imf02.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774855397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NZ0LQnOR95aHR/QhroiVMVa82mQ7m1GAsbziC8rzFfs=;
	b=XL8ARP1FPCsSEEADQAJr1F9KWM643LbBqdkGK0sTwqOouFxHoXYG+4cO4YnUJ0yoTnRr+O
	rs5/lKV76B0sfvv5BZNL3SwjYu4UINb5nS5jN6pHnxULGaCLa45sycHuKCtzDzRIHcrs25
	VYqCNRp2ax3e/i+s6YArAmwPCXwabU0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WMEpqDF1;
	spf=pass (imf02.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774855397; a=rsa-sha256;
	cv=none;
	b=uDooYpUrJ5AHkM8RqsCoxoraufT7JE+zfciTql67AiS8jeMpm6i/VNBxBmloBRzBmbt8BR
	edBa9++naWBrHmIcpUAkENMzFiDw81Qt0UPsk/r21CNb2DwDMAiyFoZUXvjyMrfmeIxNcY
	uS+FJ0tJCnIwm8/ywbbDDIWRV/CKChU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774855396;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NZ0LQnOR95aHR/QhroiVMVa82mQ7m1GAsbziC8rzFfs=;
	b=WMEpqDF1IsSpKcYeTheT7jZQV3e0uHXH8WMORTcl3MuLZdS12VukbC6XlSnNKducwLGs8x
	g4x0avanpO8QYv1cnUjmpMIjNA/S7G31WTYmA3Gam+Kb7pqm/MnQoS9FVavxblmwN7V+mg
	SR5OXnI2EgzDdD5RxccgU6tJVa9yrDc=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-317-fGKYOVhYOZ2uhwf7pa-XVw-1; Mon, 30 Mar 2026 03:23:13 -0400
X-MC-Unique: fGKYOVhYOZ2uhwf7pa-XVw-1
X-Mimecast-MFC-AGG-ID: fGKYOVhYOZ2uhwf7pa-XVw_1774855392
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-82c675116f1so8429198b3a.2
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 00:23:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774855392; x=1775460192;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NZ0LQnOR95aHR/QhroiVMVa82mQ7m1GAsbziC8rzFfs=;
        b=VBz+BxepO4YIM5GCoaEtBbNi+uJUSBSwYqiD1jmPsivadARSiZwXGJEQ1PwsOoJTHp
         Z/NYRPhV9ViXxPDVcw2vyiawhBKuC9Kp9ziMzIgMzWCmjcsiriMQRqoJo23fYweSsDh/
         wlbhjE6eeJcVaPqjAFBui6KWqEQh7BPwL0ze/RcT1nGWgUAmvENIW0m7nRqWJbuwHWy5
         NZnIOUxUIP3ppBmuBTM23D238ltnJE4gV2Wa4wraQe8g3BWStiss4OA1kOZ++xRKytH+
         HEP0GJOOqI5iUudGjD2K0ooG8zjzrfA2qz8y01eOCLEopyZFnW7X6CjE143c9EUWvaNq
         /UTg==
X-Forwarded-Encrypted: i=1; AJvYcCWY3dKOTuG/vsGbfQH2t9NDv/khI83wNhmHplYRbIFN/jna+tMKlF79/em6kXguW7bv3TlP6lvqGA==@kvack.org
X-Gm-Message-State: AOJu0YywHRxIUbGMxqYXZm8lA60Z9Ju2XJ3RCdTs0mHOp48fNyG76mGu
	7bybFU2qKVnfEpP07ISfwZXWNMB42JL5Gz50atAOmawNrt4bvGYZs/iaVO2nr5pOa0MVHGM5ytz
	cWCy8zIuCdEfx/UHwkymgsjSU+EFprUj0pvSWdLgGV7gPW+/DOKSC
X-Gm-Gg: ATEYQzxpkJAsD9+JQ8TByBTdkVnT+720zZamzr1H6iYclLvisIp8G923SHH5yxJ8L9S
	BiynA2glFLb6kLRxJLzp03kf7teUi3b2WbhBAwGZFIYTFsboDh/QyS253A3HMBiA6IPw43Y2JkZ
	qC3GVeJw9PWeq0OTc+E1QOqC4ZxbRjxGE7W45gWIJgq6aHQM4zvuX1OYko+s2I1Prs7kmvM1dye
	ZlgwwLygxD4QPL4M2TXTgP+eJ9yie9AoETChcgj9B3pvxpx33mFgJF+UwLfohvppZSEClBDSss5
	/Q49oawn5EbTd3aXnp9Y8Qiw78O8bmJYYpqifL0gvIHItXywYiJwOPPjqKIntFuNmYSO0GeATRx
	2cmfgKRsI5nWFg+B/0Q==
X-Received: by 2002:a05:6a00:2d01:b0:82a:79b8:2049 with SMTP id d2e1a72fcca58-82c95c21e4fmr10957440b3a.25.1774855392513;
        Mon, 30 Mar 2026 00:23:12 -0700 (PDT)
X-Received: by 2002:a05:6a00:2d01:b0:82a:79b8:2049 with SMTP id d2e1a72fcca58-82c95c21e4fmr10957402b3a.25.1774855392034;
        Mon, 30 Mar 2026 00:23:12 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82ca85d3a71sm7217393b3a.30.2026.03.30.00.23.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 00:23:11 -0700 (PDT)
Date: Mon, 30 Mar 2026 15:23:08 +0800
From: Li Wang <liwang@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, rppt@kernel.org, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org, aubaker@redhat.com,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3] selftests/mm: skip hugetlb_dio tests when DIO
 alignment is incompatible
Message-ID: <acok3JY66OcV0Qab@redhat.com>
References: <20260330053915.75442-1-liwang@redhat.com>
 <a5b7add7-0507-40c0-a324-81f243ffa261@kernel.org>
MIME-Version: 1.0
In-Reply-To: <a5b7add7-0507-40c0-a324-81f243ffa261@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5jSITkTtEUjUFvbgRshawmml6YbrT5sIH5R8HISa2Fs_1774855392
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Stat-Signature: o5cuywd95oed4k1thhm9u5wgw7drp1j6
X-Rspamd-Queue-Id: 0F53480015
X-Rspamd-Server: rspam09
X-HE-Tag: 1774855396-648039
X-HE-Meta: U2FsdGVkX1+7maZFqsgNLMVsRK5ugNc9ELiQ/jWli9UuNIoWrBajnQ9XuPYFmZD9f01RdzMagCrNay1XtxAqTtFVmIdW5GTVvd/BMk1cPTaNZuVtA//mhHmzv8d5RFGglUpBH+RMDa/cb2VgnBIB7Alpp92GnFuIqDe8yIn0wkkdZODzPOcyzPdnOt3zA7o762/9g7Jg/c3TjFAOsxImUlTkOuR52ocvrig7DtsyR2N29adRrYK5t3bCHf3pu61B13Sf4PQAwG8KgX8noK71F7IO3KKM9mgLCyNHajWAtce19g9GnGarccxupxrY9QOu1rekXgOnapSQhK0vDBYlb/NkUkk8sRWAi9nPUyIFIi/8kTuSEZ5LhFwW3PMPPfkB1CvIUau7CTwWaBNgD+3uBPFHpMslfWQDJFOXzZsNcDEBqdj0I/wt0qa5EwWBkHK4hMHRXt/DvuplAJ1LfZaz8rYBJwzUX1v4QX6JW0WOc3B7kAI0fXhJukSUM+SY2IOC2jXW44XebxlIOQ28WYipSNm0Svec5uTmV62tmfL5MMbQGL4+32Jjdrpsq20aQGpSyWgcQP0840UbMf3dIOZ8qCK0loLpZLiam0RGerqw/h7w6Zyj1KpJsB7AeO8PjepKFEmE2XMfwmx2jCBn8DihaABYSnNEPFh7LtC9mxCkuIqJ18Hte0vF+m9H55+S9QGoSv8U6zZdJj+QyKo5Sl64YZRLXZTl5LCCX6tFSUPHOCPIljCMxGwFkcqoPqWH0VeX2x+WjaQKr6eoJc1Kt95kyTtODxKS4qLp6dBhMZqoQ1aVmLXjH0syHqgKgXzpcm0BdejqPj6W57fpjNMUUduiAGu1fy8JdxQ3/58xe0YnOdUNhw4LJHcclAcVZypdiclWnPeFbNNKfgLSmNO8mtCWCLvEQK45FIqilYlSYRxrMSKrIyx6s5V9KNVle0nm+ZsE5jpFEBS5L8lpTyi8eRH
 76WGHIi+
 kEAX+AgabNy/wb2KcV6JNGtyCR3+qufXVAF74KOIj637G+wqY6dlayx2mCT5kKOWOQ8ONBa2OtWW5tricQI4aNfEyYSk3szvuJKVZz7OEKocBKa2WNTxdgD1CIWPxI+vfr3PYLm+/4iGBK5Z11el/PNGRVDxnF13oRwMXS5RchG823xMAgtqaHcj+tR3f3IuS1eCF1VEN/m+hl8rdonj6UGHLB3I2fYw5jWG0NF5fgJ6mxxU3MX4e1rSyKFHnoh4j8Awn1lvS86GSRLDyjOMZtjf6rLxQ7X025WsEyXD6y+3FyFzZhdgsHfOb4oFV3bEF26f37u+ny8vumVoy6AsHCc17BRfLK5r/y3gshEtPfiEWpU/IHpLb5ELjls06A+lsolYrehnK4tNhN+g3uSOyzw+dsLbM7HZ4soXrgBKcg55JFI8sy92lYnM29SxdafIcsy+RcnLvDEkLqFvrz234porAeBLgSFxiYExQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 08:02:01AM +0200, David Hildenbrand (Arm) wrote:

> >  	/* Open the file to DIO */
> 
> This comment is misleading as we are not opening "the" file, but we create a new one.
> See below, maybe we should clean that up.

+1

> >  int main(void)
> >  {
> > -	size_t pagesize = 0;
> > -	int fd;
> > +	size_t pagesize = psize();
> > +	unsigned int dio_align = get_dio_alignment();
> 
> Both could be const.

+1

> Why can't we simply open the file once and pass the fd to run_dio_using_hugetlb()?
> 
> fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
> if (fd < 0)
> 	ksft_exit_skip("Unable to allocate file: %s\n", strerror(errno));
> dio_align = get_dio_alignment(fd);
> if (dio_align <= 0)
> 	ksft_exit_skip("Unable to obtain DIO alignment: %s\n", strerror(errno));

Yes, apparently this is a good suggestion. Thanks!

-- 
Regards,
Li Wang


