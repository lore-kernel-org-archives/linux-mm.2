Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A172EE2082
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 10:07:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64B996B0099; Fri,  6 Feb 2026 05:07:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F9726B00A0; Fri,  6 Feb 2026 05:07:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DBA56B00A1; Fri,  6 Feb 2026 05:07:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3DA7C6B0099
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 05:07:53 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CFAA61C2CD
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:07:52 +0000 (UTC)
X-FDA: 84413605584.25.D943435
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	by imf20.hostedemail.com (Postfix) with ESMTP id CA8E81C0003
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:07:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=dhO0tVyh;
	spf=pass (imf20.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770372470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n7zGrdaEsDLLJ1RJqF9wbK0puJiQDIqXQjEhB/FWJOs=;
	b=c0JWVOpwInJxyOnUJYJPclLIaTYY2RRkTAx2acGuehg59PlQQcjHykDS2l/pw1SsT3z/Q7
	ULjWVLBrf/5GlESfuoTqdUGDQ+9mCOWZ5WFUG8L6yJpBNI8WUfEh63yCwNrE8H7r8+95nr
	LhpwhnDGgNZk/OYf1vSvc/8rJ1/uNR8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=dhO0tVyh;
	spf=pass (imf20.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770372470; a=rsa-sha256;
	cv=none;
	b=r9VPet60J4aWvyZkjrAlH54229qj7+EZDNB1WQ4wQwXkQeMTDy733pMqPuczOoJuf56zFW
	FShXsag3vUWWzy47et+YFQsiqtAdxUy0zIu4Rt9WOYPOuCXKEuy+GVY5z9h9KrB3GAq31N
	BKOkP+dwm1RWmrnIShnqLnaikn6ahSo=
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260206100745epoutp02cf9c60bc8b711fe319e9b536c74405e1~RoGDBJRHa0904809048epoutp02w
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:07:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260206100745epoutp02cf9c60bc8b711fe319e9b536c74405e1~RoGDBJRHa0904809048epoutp02w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1770372465;
	bh=n7zGrdaEsDLLJ1RJqF9wbK0puJiQDIqXQjEhB/FWJOs=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=dhO0tVyhRmvneYC2J4/aPn5TV70WkxXaajKs3CmO7kGjZzsSaPnIejHSqeb4zT8BJ
	 4jSCaxsmXvZT8q924JTXzZ0njQrQ3iWvQqpIL81O4QYKAdAChfyUBEtE0EGNZMdaHH
	 AzdbDGXi9DFTsQJ3bi97bl8tcjexsR/BBtXfOnHg=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260206100745epcas5p3a8327b1297e84e90ffb34615103a4773~RoGCMjuIl1568815688epcas5p3Q;
	Fri,  6 Feb 2026 10:07:45 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.94]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4f6qXJ0LDnz6B9m4; Fri,  6 Feb
	2026 10:07:44 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260206100743epcas5p1a70b6c71343aa9c1ebd818d70b3dceee~RoGAgY7uA0598805988epcas5p1W;
	Fri,  6 Feb 2026 10:07:43 +0000 (GMT)
Received: from [107.111.86.57] (unknown [107.111.86.57]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260206100739epsmtip183b7d9978cef2ff67102e2bc7008cce0~RoF9acq2q1596515965epsmtip1z;
	Fri,  6 Feb 2026 10:07:39 +0000 (GMT)
Message-ID: <28bfd5b4-0c97-46dd-9579-b162e44873a2@samsung.com>
Date: Fri, 6 Feb 2026 15:37:38 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/6] AG aware parallel writeback for XFS
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, djwong@kernel.org
Cc: Brian Foster <bfoster@redhat.com>, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, willy@infradead.org, mcgrof@kernel.org,
	clm@meta.com, david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
	ritesh.list@gmail.com, dave@stgolabs.net, cem@kernel.org,
	wangyufei@vivo.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, gost.dev@samsung.com, anuj20.g@samsung.com,
	vishak.g@samsung.com, joshi.k@samsung.com
From: Kundan Kumar <kundan.kumar@samsung.com>
In-Reply-To: <20260206062527.GA25841@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260206100743epcas5p1a70b6c71343aa9c1ebd818d70b3dceee
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260116101236epcas5p12ba3de776976f4ea6666e16a33ab6ec4
References: <CGME20260116101236epcas5p12ba3de776976f4ea6666e16a33ab6ec4@epcas5p1.samsung.com>
	<20260116100818.7576-1-kundan.kumar@samsung.com> <aXEvAD5Rf5QLp4Ma@bfoster>
	<ca048ecf-5aec-4a0d-8faf-ad9fcd310e21@samsung.com>
	<aXN3EtxKFXX8DEbl@bfoster>
	<e7413e3b-3fae-4aab-90a1-4a6695156b2e@samsung.com>
	<20260206062527.GA25841@lst.de>
X-Rspam-User: 
X-Rspamd-Queue-Id: CA8E81C0003
X-Rspamd-Server: rspam07
X-Stat-Signature: x5778sg8srbjqsnwdr786thwdjso5mgc
X-HE-Tag: 1770372469-725385
X-HE-Meta: U2FsdGVkX18ekE17thtO7dnKAJ3brqIVQb0RhNiDZ19X4feN6btW6zZ94XJZWepga54wBbZukuxHgTjc8gJMKEGFyJvcQlv0CrAirv5ijQ43IExXmmCsOM1lQrPGmwuzihioKQ70qeKyh2knjPd3PDkur1GFU4ZMJT8XGsttvoIv5O/dZ48xcV9tNWya5CFqttgkfZV5lNL2pv9Or8hvZgltepICNL9UAB4hr9f4622GAjE51OvGDkWbGAu3kX+HhpcwwGXVMJrNV4cls4UUE9xHE+g7AtrDjsig+6hG4nlcgK/q4d1WV9mfp8BCc5oJkU8wPQr1Ei8/9cpe59gtUZcwhi5oi2BIH8znJdHAY4Hrw02TWPA78QNxqFhkrGjsJpB+XRvHP4+CYto6ZDdXglwK55HChmHWGUoe1+NlFXi0MmYKlAncWI2S6rtPZX4Cva5HVcpVl3VQoeokIQwJlXh8qZ7z/YZnmG+2ImZxHWdwh4WbdMHUPc7yy0iz1125FY9vC3hownkA7zQLgBxDDj2KHxQD/d8p0Pfz4ULK7YGycZLftrgUSEiHa2/zWZj/RCfRSDSaGdztWFXGvNXz0idiSUAYCTax8E0oIm5LDQm+CRkHA191p1sAlSw85EkkMBlVeRWeHH1vfkWscKte5qSr1pd7qFNMNRAhKTcdokWLwFPpGFlGBgDr6hj7v/ffdqcqQYV44HxB+FAtPrM1gpXgrrf1CgJ8UMeo14NtLas88CYnwipYhu+5j0z6baF8V9ZnJg8bvPRZepUwAmOQkNaZDgzKoQjjWm3vqzfalTdYAxrABWHMyJcSzk+QthPy57HT83aRhV5bujzqPKeabCoFEfnLkuprdLMQoSBlQ3peo+FafqlLQyksTv6ZrdiSH+C92/tuO207wEcC1JYA988DLJS1DZ5tHNo5JjrMPteb+eKyLhinRnFF/I1p3sHOf65jRuyzk/HCdXDPmnt
 QPs6qEin
 CzK4uZ4vtT+caHKXiwyLE40lRgJQr0NqqXBoK6SGaBVF/Mj71OmNwab4m0wiALJkYbJuQ0N6pQtyUuKao3ZOTHjJrO3JRMSVjnvB39qjor9tSf2bi3tB9g2JuRpBzf0HAoxP2jQvHYo2XS8vpUfUQrRwD5KYU8k0FLtcRLp7Ocp5Pm6OV+OLGDP+ca+VoKPcDxX4k80A0uheKZfQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/6/2026 11:55 AM, Christoph Hellwig wrote:
> I fear we're deep down a rabbit hole solving the wrong problem here.
> Traditionally block allocation, in XFS and in general, was about finding
> the "best" location to avoid seeks.  With SSDs the seeks themselves are
> kinda pointless, although large sequential write streams are still very
> useful of course, as is avoiding both freespace and bmap fragmentation.
> On the other hand avoiding contention from multiple writers is a good
> thing.  (this is discounting the HDD case, where the industry is very
> rapidly moving to zoned device, for which zoned XFS has a totally
> different allocator)
> 
> With multi-threaded writeback this become important for writeback, but
> even before this would be useful for direct and uncached I/O.
> 
> So I think the first thing I'd look into it to tune the allocator to
> avoid that contention, by by spreading different allocation streams from
> different core to different AGs, and relax the very sophisticated and
> detailed placement done by the XFS allocator.

When you say "coarse-grained sharding", do you mean tracking a single
"home AG" per inode (no per-folio tagging) and using it as a best-effort
hint for writeback routing?

If so, we can align with that and keep the threading model generic by
relying on bdi writeback contexts. Concretely, XFS would set up a 
bounded number of bdi wb contexts at mount time, and route each inode to 
its home shard. Does this align with what you have in mind?

We had implemented a similar approach in earlier versions of this
series[1]. But the feedback[2] that we got was that mapping high level
writeback to eventual AG allocation can be sometimes inaccurate (aged
filesystems, inode spanning accross multiple AGs, etc.), so we moved to
per folio tagging to make the routing decision closer to the actual IO.
That said, I agree that the per folio approach is complex.

Darrick, does this direction look reasonable to you as well?

[1] 
https://lore.kernel.org/all/20251014120845.2361-1-kundan.kumar@samsung.com/
[2] https://lore.kernel.org/all/20251107133742.GA5596@lst.de/


