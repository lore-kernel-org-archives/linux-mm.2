Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D717C5518E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 10:08:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BE926B0088; Fri, 20 Feb 2026 05:08:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0420E6B0089; Fri, 20 Feb 2026 05:08:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8FC46B008A; Fri, 20 Feb 2026 05:08:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C325D6B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 05:08:38 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1EFCF1CFE8
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 10:08:38 +0000 (UTC)
X-FDA: 84464410716.19.BD37B58
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf12.hostedemail.com (Postfix) with ESMTP id A66084000C
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 10:08:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CFE1givt;
	spf=pass (imf12.hostedemail.com: domain of pankaj.raghav@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771582116; a=rsa-sha256;
	cv=none;
	b=HlddNe13P6TJ3aOYpJwgIJoAMpjMS2Oupr4A6JRgyGcO4z3XvGAkiWbqlZJekDaQzUTIGD
	41igOALuWWSvjV7S03ESOXTfxSwJgouRer7J72nAbxeEm/DL8FtCgVczH4O0+2pyQB4tBt
	AF9SeKu66CtUFhC8PW2uFI1pn2rS4mc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CFE1givt;
	spf=pass (imf12.hostedemail.com: domain of pankaj.raghav@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771582116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8tDGJbI5FE8OyurRsiUKK7fUsDEFmbQate1+4YcD99o=;
	b=BAsHlxi3JlM/1GdvPPj/GPpg2bxR4jIl39u6QiKSJwXf5nPIsgH1Ql0bcv5po/YjhJSOyS
	/HEt2WncankeAIWpiVxfDMayp5bvtXlHqD+bOMNM1W5mfNP4enobFftHyS0SBnWmFCbEim
	gMaBkRDrVl3iK8FH09gKnbZ8Syakxhg=
Date: Fri, 20 Feb 2026 10:08:26 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771582110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8tDGJbI5FE8OyurRsiUKK7fUsDEFmbQate1+4YcD99o=;
	b=CFE1givtQqWIkgpUoykKYf0ZibeD6kxuIu8KPMJi1urMTEkYxiL9t1mA+WjPJ8a6ISnluW
	Ao/a0OlZC18fs3Z6PaadaAOCuz4G5ccBYj5MfPeRgP0vkjoVCwbXh7QjwFRtOsl5HjN+JB
	thrd5F8gIpvJ0cY6Um/Nw+s4dSzcgjg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: linux-xfs@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org
Cc: Andres Freund <andres@anarazel.de>, djwong@kernel.org, 
	john.g.garry@oracle.com, willy@infradead.org, hch@lst.de, ritesh.list@gmail.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, Luis Chamberlain <mcgrof@kernel.org>, 
	dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com, 
	tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <sjuplc6ud6ym3qyn7qmhzpr3jzjxpf6wcza3s2cenvmwwibbxr@aorfpiuxf7qy>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A66084000C
X-Stat-Signature: kmp1crk6iec6azfkdkyhdrkatfejinb8
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771582114-407876
X-HE-Meta: U2FsdGVkX19OfjNvzN4t055kF7sC/APJNkZXbyNc2mlySYMOOZNJXH0XRKll1F6gDjJWFZWixToLalN7w+e+yKCrdwAzlvRk97KSgYnVwoWC14Q+hkCWLvgAV/cMUQWRHNXAaIm4zn6BKaATRsFaNqY0ZBlOExm9VNziL6E4T7ECQK48KOfOgFfmLM4m7DBnDazvj0KoyULByWHEKQhIe1wCxNb4/UDgZup49g+lbf2A/VihTFmYWapLx7F6gwHog1k8xvgzHobCq5n4Z4zXuNgmtf+rzdehGcXZaPtpfIPrlJAPLhobxLiKt7VaTQ0pwS4wwudc42RNHsMw87/FzPZIzlLWIZmB3GzcB8aOiZMtkGPImaCl6Qh+xXigRfmu4SOaKo846cs5Ty5sBhrS4iw/UeoxFa63kDubATMsIvwTCis1Jt4NbKLJI2TqwqsvrlMAklQYGSEY73OZ/dnyweoNwUA0ksFte/YtqLYedLiPfHD0GCXHIIppw+fMsW/eJ+QDLL7l80lipkGmIqEVjWspaTG1T+gaEdGdQgPPZC0BED3MqJEgU96EzuRPsRn2aHCZXythj/KkZAQU5yVq0XiMNo5tOtoMQElp/UTjYCMonmxmJFtfFI+rJPJrmOzaF94LPvlVN4cuYJRW02IstJAVqCpxuiWfEX3Af+4oHe3swfZjrux6vgond3dW/iFB7DCUSMPTBMFk08WP7u+FSsrYdTWh5I1mFuA+ZraGTpQF7/Y6n8nK0AleEMqQR5lCKafVgNtITKuXV51ivv0uUVbbUO/zIfj0gadjZ51VosyWoTF6t0aWjfHz8u9fFEl32d967AlZa3RC9vfq+wGNhpJrw9TiCTCnwDHSvxfa50IzC7xnkmKJg6SK8Pw5HYSxfmoUj9sYEX10Z6hyMhxOvP8VwD4iaoaxYJ7lVUliPCCQVqNmY/6cr4IyhybB/VUhv8grTKQid1fajlPZ1jl
 am/efJT3
 Ct5ED8oWLKHmAH/peaLTW0H2rS1LCGIkO1cS8Yb9nirQsdy8ftqKTl4+P8CMg5wo1bKDvy5ZirvP+KGtUCODF1q7hj3iynenFTrO+gM3gU6pZlZthXvD819Mi4JtaRRXmV5KjjIL3jnkroeK7q4aNINPyAo6DZzuba9VzqmFzxQQb8U4iTClJc7awBhYnm0limh9RGpwQPLbUYsCh1aahsRh21rk7/NZr69wFjmMExfxabcYCy8/A88cu+QIlR8Xn2Z8qD3Y3iYiuhLa0N60HTT40BQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 11:20:36AM +0100, Pankaj Raghav wrote:
> Hi all,
> 
> Atomic (untorn) writes for Direct I/O have successfully landed in kernel
> for ext4 and XFS[1][2]. However, extending this support to Buffered I/O
> remains a contentious topic, with previous discussions often stalling due to
> concerns about complexity versus utility.
> 

Hi,

Thanks a lot everyone for the input on this topic. I would like to
summarize some of the important points discussed here so that it could
be used as a reference for the talk and RFCs going forward:

- There is a general consensus to add atomic support to buffered IO
  path.

- First step is to add support to RWF_WRITETHROUGH as initially proposed
  by Dave Chinner.

  Semantics of RWF_WRITETHROUGH (based on my understanding):
  
  * Immediate Writeback Initiation: When RWF_WRITETHROUGH is used with a
    buffered write, the kernel will immediately initiate the writeback of
    the data to storage. We use page cache to serialize overlapping
    writes.
  
  Folio Lock -> Copy data to the page cache -> Initiate and complete writeback -> Unlock folio
  
  * Synchronous I/O Behavior: The I/O operation will behave synchronously
    from the application's perspective. This means the system call
    will block until the write operation has been submitted to the device.
    Any I/O errors will be reported directly to the caller. (Similar to Direct I/O)
  
  * No Inherent Data Integrity Guarantees: Unlike RWF_DSYNC,
    RWF_WRITETHROUGH itself does not inherently guarantee that the data
    has reached non-volatile storage.

- Once we have writethrough infrastructure is in place, we layer in
  atomic support to buffered IO path. But they will require more
  guarantees such as no short copies, using stable pages during
  writeback, etc.

Feel free to add/correct the above points.

--
Pankaj

