Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 358E4C624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 16:44:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B87566B0088; Sat,  5 Sep 2026 12:43:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B37A86B008A; Sat,  5 Sep 2026 12:43:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4E406B008C; Sat,  5 Sep 2026 12:43:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 74AC66B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 12:43:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D0F5D1C1F2A
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:43:58 +0000 (UTC)
X-FDA: 85180280556.25.0EAF732
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf11.hostedemail.com (Postfix) with ESMTP id F215B4000A
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:43:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="r46w+lF/";
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788626637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2MnNWKE1aLOQVvI4VXrDjnmlyCcUk8F5PrqoE1ht1fY=;
	b=uVt84pYUsfp8d88c60Aii7YyRcdTlR8tOcrFKFUCym0hMgjXSEK5mAmcMaAxhUl61KnOCL
	UUCPRyIHekdXob0+dwdu6nrnuiFwV1+EgKqa/BSBehF9aYmjf5EqRwXI9JApyIaOLYBW9I
	WR70G5aps2vGBs+L8Uk7TKNFt/srl3s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788626637;
	b=udpdEmOwGxpIj6PwqV78/Q3+kNhGBTFiX+krBb2sMSCJiGo/C8CX6IY6ytJSIYgZwp1oP3
	yqDG5LPtj0zcWocSgL4jxB6j7qgcJ5hH8xcb/8F+fIVAm9kdxXAuag2Hg5QyvfuFjGciY6
	jnshBT1CSWS9EjpMBxb0gXdJ4v4j7xM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="r46w+lF/";
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-529a1ee0e62so26587911cf.2
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 09:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788626636; x=1789231436; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2MnNWKE1aLOQVvI4VXrDjnmlyCcUk8F5PrqoE1ht1fY=;
        b=r46w+lF/TuG0B4hhM6+Qbia45dZ4HTvAu8Pdsivhq8zjxwN75hDdjhwUIVpDlH/Wop
         kCXJfqWpV67XwKZ/Y2bkTtWOKs/N4ADnl8bwGZ0t1/78lTx3NzBcwGXOAF1Js1gYpWgs
         GEqFWPKfkJYnxZ9i0VSVEpj8Pubi/CfdjSmjQu/OQ8l42DJVLkK5qOVP82RF2pn3B9iG
         pRafXXxpBtlSCboXFei+RXXJcOuc0L/MX2NVlJQQ7gccv+ZFARtXUOEsVbCoSI5+vcyZ
         ITtyghwtXJ5awVvls+X09BS0VllfrYzLjxAWSOsV9YlMR/Rgpf/RmQ7RK3Y8OWux4Ul0
         ixrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788626636; x=1789231436;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2MnNWKE1aLOQVvI4VXrDjnmlyCcUk8F5PrqoE1ht1fY=;
        b=T6UVCC5aXsfwP0kAM71Zgdk/JMRyV7uVKuSssoWz5crqOKfR3y4iC5Y7fwLShBbUkR
         2fy6OoUWImdJZLZYORS3ko21vJN2wh7D/rX4nii9QK4yoZO/xVO5o6gR+PnlsFus4mbX
         lUou0Im6YoetY8WrkbpubZ9O3nGkuhQB0TBRNZuvgCVcPklV6+GHtBAB/C4W2/3vA75f
         PinOcyfarbiRuzA7KivX7t/iYUZ02jt5hdQ9mtvrqNzO7taH5ghSymMnUkUuuIlPdEqP
         7F05m1sj/gaPQHoWOOosCXXqRe5uDHZigie35Gh0aV/7hhJdjeW+fdqshENV6oT5Sarv
         5QYw==
X-Forwarded-Encrypted: i=1; AKwUvBxcPVzG++mW4bVIRuoD7fM4Gp3iJGoC3S3+vQx1dNwWzNo9Wj8nOh6e3c9XM5kY9bWWjPFjHyrJmw==@kvack.org
X-Gm-Message-State: AFuF++mqkyDa1TYnwfK6A9ILfwQABfyrF41MF0vmAFsVmtvnPNvd6WYB
	FOISV9wzQsbW2dYqAsbdEHEb4EVTeKgMA4K5Ue+x3CtHZG+ylWtAViLN94mNMwe0TWk=
X-Gm-Gg: AYBFou2XBuaDkSygvEIpxfnktzEd83vpMqycPActHM3bizCBOGbDrZCCf+ABa82oHMd
	fMBqmXmxkPuJMNgOpKvvSU4TG4tNLnnvybALSuXmey+9UmVXZiJ7TPOs68tDCe+ox6fEfRMNopQ
	NEtHgr+8NtY3zh0Afi6jAcvw7CpF08BT7SNuijzFSum2/QjlNjH3JQDZRfBHg1xxQ48IpLe/NIw
	ovPyOnheeQ/L6Zgf2JVMK4iW6uPC+m8sLjDjX38VkY04Q1rThi2wfp550juvpO788OcKOZz4cEl
	QNNmIwz5LuxfY75sCfdRTxvOqJDIv+3IxaPvUOsaZBPJFy/7f1Ht3PK7LpTtcjzuq+tg5wwE6SH
	PNu/DcAO4jd1CClC5NaJJ7OMxLSIn72GMsZKVq5Abqls4alZ3kOuASdSBh/8Wy2blqQdqu7r1FU
	zYLAXir/4adYsmeZGOPOMylm5JwrxmmLbPuH7xRixKk1YXYbe21QVSjN5DRo6bpE69l7ByzHqib
	E6TaBEOqi4g8qEtwaw7dFZFg8efSjvfr9MOgd4xl08H
X-Received: by 2002:ac8:598e:0:b0:530:3140:f0f5 with SMTP id d75a77b69052e-530547e047cmr134840771cf.5.1788626635947;
        Sat, 05 Sep 2026 09:43:55 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530541c86f1sm46782371cf.24.2026.09.05.09.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 09:43:55 -0700 (PDT)
Date: Sat, 5 Sep 2026 12:43:53 -0400
From: Gregory Price <gourry@gourry.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
	David Hildenbrand <david@kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, 
	mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-new 301/316] mm/memory_hotplug.c:1507:13: warning:
 'node_is_memoryless' defined but not used
Message-ID: <apxGfmKgqnj0TDTn@gourry-fedora-PF4VCD3F>
References: <202609050628.ywCLhOj5-lkp@intel.com>
 <20260904185658.cb3316b1d54ab7320620c26f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904185658.cb3316b1d54ab7320620c26f@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F215B4000A
X-Stat-Signature: sbe1x6p3rqttqsx69ig6ctjn4nteqtmp
X-HE-Tag: 1788626636-228206
X-HE-Meta: U2FsdGVkX1/4kd1B7sdxw7poIlaB103sANnuLjZep+ySNgBksEujObPRhCNoeLY8eXDnoUlPTLY7BcOsELLdqW97ZZTIOWKGCoV5+mJ5cT/+YS1DR2jntxjRADS1NgGiveIIAKqIGE7VfHzQd2ZZXTeiQCecDe1uNEN+2KvfZ7RlJpwkkAfiF50n2mQHQj/qwnQk3i4I1iFKcR6N94l/KCNdZhj+gnKJIZb9QoOAMfbHD1xJd4caEpc8dUVTXFeM23x6SKlzALwHhkDLVf7yJ4kdMBzucGsFMOodXfpH+bx6V8khVprvl2/B6DT/14Exm3Z2vakbxEvwY8F7DlQtMzEj6sikVi+KSjlSuq7qBcyh1/ZXZIbSDkTOxS0VCDplYfh8OHZJVG0xJHFwnPrXD+QcZS2T7aMWf194Dv0jDvvB6LA26gwU6ntM5jCj7vWdWaG/Q/XPuWRtDteQMq+mr3VC2JMnTK07jEWpTr1BKOp5Z83iNHrqrJYcymBQLF5QzNT96+UBfT8VtLI9O+PLAFxO31MdRlSdP1yRmPCVW/aFbGFZKTBUkOlKQJEtQ4pr7021vN4ZOo9fzvffd+iBSwFf335A7Fc9u+DoyZCf/jKCUuI6GSAnB79RsHJ4D+bnIAt3x2vmHXdOKVS080KQRjmA7gz+DIcWO4/mUyV8K6yZHb2QSijKlLCBzOh/WLbfbjs6iNciSiJ2U9FwCOIsI8cJSCuma+szTT0Q9cbrvU6MMwWI9sznWvEotQaYhLuQnNs3kBwf7nn9dzvd/UVOZualwP64jN9TUv9qbvweEbcJMf3AFESLPIJHfTPEvqA+3ibf/Vi38v/IXU7VdiM18d5XuqhzCrZztvMc5I1IltWzf8dRvFtVyQwr5BoGWfIPAno7XuOxfCtoqiUCBmxBhvwHKXHCI+cEsFSI1MNdjiccGKVPISUc1DbGH9YVHhdfuzdF0uyrZiQZ6VP3RsI
 90ZN1BmU
 5Ea1/lRbh7T44jATHxNK8/dajI2SeDTsoaHyEsZh15pFLEYS9+TNuozCvE5sRgU/SVife8vlh0gUfhXC/EG8j0vYRVqbqJKmJLiXS4+8OEqlLbaQTX9/32Y1kHpNMcJqxIKv9Vz/50UWvTtRXp8jQqSr9CxmhgLqR0XFtLAK7v0H+3aqKfUtG72WNCVLPfr0zL6cFRgQ6hox+Avs7c32aOtG8yqg3eIl4xqFc9sR1WX1jZqKtlRXSR7uVIuKzTQfQbr7awqgfZEVX1mrcHeqAnvDJ5L2y0a843TG0ZGw50rpLuodJdTout+RdppxhKaNYEmlOo4/vt+pknKEJIRfTDDNeOVcDz/ak5UW5aXICXI4B0OkRWz5wvaXSEYp4pS0FdFQS0nRqqsDzhAMW5w8T/PBA0bwQG5Nhm1N6tI4jY3dDQyZeUyP/OPDtgl3N7p/W0ru/9PIqvnhkD/+seTk9MqPHAOTi8wjFxpfP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 06:56:58PM -0700, Andrew Morton wrote:
> On Sat, 05 Sep 2026 06:32:19 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > Hi Gregory,
> > 
> > FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.
> > 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> > head:   e3fc12b08aadde9cec7b3799ac0e0c9a1aa245c4
> > commit: 77a622e07892674da28eb3ad349ddd96df10aded [301/316] mm/memory_hotplug: factor out node_is_memoryless()
> > config: x86_64-randconfig-161-20260904 (https://download.01.org/0day-ci/archive/20260905/202609050628.ywCLhOj5-lkp@intel.com/config)
> > compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
> > smatch: v0.5.0-9187-g5189e3fb
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260905/202609050628.ywCLhOj5-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202609050628.ywCLhOj5-lkp@intel.com/
> > 
> > All warnings (new ones prefixed by >>):
> > 
> > >> mm/memory_hotplug.c:1507:13: warning: 'node_is_memoryless' defined but not used [-Wunused-function]
> >     1507 | static bool node_is_memoryless(int nid)
> >          |             ^~~~~~~~~~~~~~~~~~
> 
> Thanks.  Let me try this:

Thanks Andrew, sorry for the churn.

~GRegory


