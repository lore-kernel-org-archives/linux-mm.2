Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C57EC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 06:05:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18D6F8E0003; Tue, 22 Jul 2025 02:05:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 165548E0001; Tue, 22 Jul 2025 02:05:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A28B8E0003; Tue, 22 Jul 2025 02:05:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F03E38E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 02:05:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9F3D416026E
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 06:05:52 +0000 (UTC)
X-FDA: 83690864544.08.4A986DE
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8B6E51A0006
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 06:05:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=Rt+E8HhE;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf19.hostedemail.com: domain of usama.anjum@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753164350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VhCpAJRtyrpO9LNFpOQfttsLoSYxRVIjLuyWcDDI3VE=;
	b=gwA7svpvqWESFTHEG+3lq9Pz+lIiTW2BTu9ibHL5C/ZqnY/c0ehKRFd3O+HJUimmyNindx
	8rpJbL3POuT1pFrAFA/hMH4+81UWJDni051rDQnrJ5GGQAD2YP9nRUFlLyTWxuz1+B0xfU
	0G+3X/N7Xy5DAqJaJFPwtPCKBbtub90=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753164350; a=rsa-sha256;
	cv=pass;
	b=4uJOo+CZ6vZ4HBfkSkOpNsb09IZi3oH5/HgsPF+BGTOOUxdEEGru6ME056k+cFRpDiqZFP
	M36lnIPqGwQYqpJ703LHq8Kou6Vpt+tLa2b+ZJoCAZLwaH0te8ZR+FIvbV5C81LQ3uJzvo
	eWCNQNOsIHeoD/LrXzrriOS6PdsHyUA=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=Rt+E8HhE;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf19.hostedemail.com: domain of usama.anjum@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=1; a=rsa-sha256; t=1753164321; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=S1oweLJPFegpQ8Q9s6wiaHHEB+455a/vNxaDuWiCOL6lSXH8xXvez64SrZBLqsRjuTlK/Lpr9KVJIwDjbzXcDccu6TXDD4GUAOflS/7WXXsaQR38xli6xLhJUN70yR6K1OyNczVSJI3rqHYeltVLZ6prOOunEXmNmDij9fDhhio=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1753164321; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=VhCpAJRtyrpO9LNFpOQfttsLoSYxRVIjLuyWcDDI3VE=; 
	b=dFQMGr3VpKrLrMqdLtIVBV8C8J6gbBYxgYncsmElc/R7T8+Gya4MIQBl4ZmLhsKME3vEMcA45GD0xjbRe4+eqxywJGMpH0DHdyNModbjFtKQoAEX29GuMDE3b1PMFtZU8BJdPbPy7gkS7UmyDfIJjiKhsiI1A/ul0NWHrVHbSpk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass header.from=<usama.anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1753164321;
	s=zohomail; d=collabora.com; i=usama.anjum@collabora.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:References:Cc:Cc:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=VhCpAJRtyrpO9LNFpOQfttsLoSYxRVIjLuyWcDDI3VE=;
	b=Rt+E8HhENiewnbQ0DW+A2M0f12nScQFsjJNv8dFuRR0inIhXWZOrNKqF/GqQRTGU
	beoZMjzkcDNjHcf3q8qyjAFdFOodYUreIrk0uvctuH6S+Ff03FJxbDblYR8ngDvvlqh
	YtW+GJRMeZt1C/9zRHCyCVrRMLIp6Q36fN515qCE=
Received: by mx.zohomail.com with SMTPS id 1753164318402568.3670175945726;
	Mon, 21 Jul 2025 23:05:18 -0700 (PDT)
Message-ID: <91fc0c41-6d25-4f60-9de3-23d440fc8e00@collabora.com>
Date: Tue, 22 Jul 2025 11:05:11 +0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Excessive page cache occupies DMA32 memory
To: Greg KH <gregkh@linuxfoundation.org>, Matthew Wilcox
 <willy@infradead.org>, Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
 Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
 Manivannan Sadhasivam <mani@kernel.org>, Jeff Johnson <jjohnson@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>
References: <766ef20e-7569-46f3-aa3c-b576e4bab4c6@collabora.com>
 <aH51JnZ8ZAqZ6N5w@casper.infradead.org>
 <2025072238-unplanted-movable-7dfb@gregkh>
Content-Language: en-US
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, kernel@collabora.com,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 iommu@lists.linux.dev, Robin Murphy <robin.murphy@arm.com>
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
In-Reply-To: <2025072238-unplanted-movable-7dfb@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Stat-Signature: jzwdmp471etddua4ccjwr1brcbxqhjy7
X-Rspamd-Queue-Id: 8B6E51A0006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753164350-78300
X-HE-Meta: U2FsdGVkX1/ceB9HnXLwuhKI2A45PZQ86XSsVJeS8nYU8NxICNjM2xhFTXuQfvCJEZs9NjdUzM/rzL7S9YsWuj1sWPuYtSX6oXjoamVm6XmKE4U4mWdxsClUV5e2RmzjQToTtvvcEqrbyOWr97sF1ywqwzqFP+XfIvbb/eHCqmS3yMLMPv2jC3lHAc16nrsTIArX22p6epPRZd9TdSwfgVVIFO7N3YrkCjbBa/DFiRTbllEvpp7OwTkVyG/8AXjsMHqxogEoU++4HNM3DYN8kwv2CafJCOzruq2qglJ281vCTfLLyc8xFQaD7tZ8XI34+JryA5JMeN9p2vv+n1hta2MAfhZD1zvCWhtcvH1ypVMS9Aw2mVX/+p60WACaLs1gyQmzYVkpDOKX3mWsoiq6WfIYDQ4eIQV1QpyhoRP9x5NBREN9UHCUfb2mAZPSkR2LTLvHDQRMXC8ummpL6K3lIWnpW/5DN11zVOy+WxOwC9Qh+DMPzOhVF8KQyC/i+3sZoaYVR7GAZQxqtOLRj3ONjPUHlDc8srzT6q3PTPv83rkXH4OTAoTxTKdgzmrHW8hmjK5a5l263/R7Pg/wpxfAPIPcehxkdPU2uZlhdkMEgJlpH6L8xlVb8vTpDdR0PpXUh299f6xGDgo2ZEleSUmRKE9zGNQaFFZ6RFZTOIeihOIgCFMt5hZ7ZLQPU+NedayBS9XSRY1SwyTUk95VF77puY9y5VWmo6u1G9jRfZ+SaD5R/fPumiFBFAG8wmaN5ONrG2cm+byxJnQFKohrVXqRYJ/N/7j/KIyl/ur7iXTnuwnvi5iPJ+qdPZPA7JjQnqWm8tg3fglpSYwXFqcvXheE7IrJwVcAXlCVpPKFAvoUVIaYQ0CeVNAFjw+VNXcSwZSCOmZPGT7jQoexiF2o91Z5c7cXlZhdO8am2sVGNs+4uFZ1BYgMFM8D82fy9d5qgsHLOs5XPsZi1pAuZAtNuF8
 NtiuINs/
 7ENgKXHV5TLZqADVgIFsMgbY6ixG2656bnjw0lC+V3+gTMiAYK0OHcujdV91KJ+YvCxBMBtmPvO8gdDucmfCUBJu6HM2ONxQc+FHWpSZPqr663/rkljY+irzfvzWalwU3mbF5FBH1zWP5z4movF8L6XSnxCvMSPkXETTldbX78hPOvwlAipQQya0orSOsyXvdNYe2gDJG9z65UcSgQq2bqjexU1lvFmXFxvNN3BDcBGyCtCP9tNNGYYCoBU9CtVMBUlWuvdnj50WosKt4tM2mfHRoxFuiHllBhRBSrL0VBcuoEzc7N/NFEBkbBzEBUAYhfOT9mKCXr2croZkGoKbmi18wvYmw3G4CmQD3lJeJhswcCpnIlAm+LOTtiIMFCiHsZ229tGuy069slXPCw+b/VHzMYNm084OGeQtd2QbH4iValKxLm0oZQP4nOjfRNhuD4i1g
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adding ath/mhi and dma API developers to the discussion.

On 7/22/25 10:32 AM, Greg KH wrote:
> On Mon, Jul 21, 2025 at 06:13:10PM +0100, Matthew Wilcox wrote:
>> On Mon, Jul 21, 2025 at 08:03:12PM +0500, Muhammad Usama Anjum wrote:
>>> Hello,
>>>
>>> When 10-12GB our of total 16GB RAM is being used as page cache
>>> (active_file + inactive_file) at suspend time, the drivers fail to allocate
>>> dma memory at resume as dma memory is either occupied by the page cache or
>>> fragmented. Example:
>>>
>>> kworker/u33:5: page allocation failure: order:7, mode:0xc04(GFP_NOIO|GFP_DMA32), nodemask=(null),cpuset=/,mems_allowed=0
>>
>> Just to be clear, this is not a page cache problem.  The driver is asking
>> us to do a 512kB allocation without doing I/O!  This is a ridiculous
>> request that should be expected to fail.
>>
>> The solution, whatever it may be, is not related to the page cache.
>> I reject your diagnosis.  Almost all of the page cache is clean and
>> could be dropped (as far as I can tell from the output below).
>>
>> Now, I'm not too familiar with how the page allocator chooses to fail
>> this request.  Maybe it should be trying harder to drop bits of the page
>> cache.  Maybe it should be doing some compaction. 
That's very thoughtful. I'll look at the page allocator why isn't it dropping
cache or doing compaction.

>> I am not inclined to
>> go digging on your behalf, because frankly I'm offended by the suggestion
>> that the page cache is at fault.
I apologize—that wasn't my intention.

>>
>> Perhaps somebody else will help you, or you can dig into this yourself.
> 
> I'm with Matthew, this really looks like a driver bug somehow.  If there
> is page cache memory that is "clean", the driver should be able to
> access it just fine if really required.
> 
> What exact driver(s) is having this problem?  What is the exact error,
> and on what lines of code?
The issue occurs on both ath11k and mhi drivers during resume, when
dma_alloc_coherent(GFP_KERNEL) fails and returns -ENOMEM. This failure has
been observed at multiple points in these drivers.

For example, in the mhi driver, the failure is triggered when the
MHI's st_worker gets scheduled-in at resume.

mhi_pm_st_worker()
-> mhi_fw_load_handler()
   -> mhi_load_image_bhi()
      -> mhi_alloc_bhi_buffer()
         -> dma_alloc_coherent(GFP_KERNEL) returns -ENOMEM


Thank you,
- Usama


