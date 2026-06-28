Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69396C43327
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 16:10:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A2BA6B008A; Sun, 28 Jun 2026 12:10:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07A176B0092; Sun, 28 Jun 2026 12:10:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFC436B0093; Sun, 28 Jun 2026 12:10:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB3766B008A
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 12:10:15 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 51EA3140424
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 16:10:15 +0000 (UTC)
X-FDA: 84929808390.15.72D5FD1
Received: from outbound.st.icloud.com (p-east2-cluster6-host2-snip4-10.eps.apple.com [57.103.76.191])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7967DC0006
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 16:10:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=sr3e2g9F;
	spf=pass (imf28.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.76.191 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782663013;
	b=wn/+39GmXBCr2FwMQblXuCnyeiUncM3gv1rGmsrbbqHFRgEEVS8n1gQJf/IiKtclxT1Kpt
	7T71UmLR+1m9XtFuyv2CG+tAJPXXLh6fzyCvelqO8KfpWV2vgbmskWaacahTb7bJ/wTO9I
	9a6IZQt9Ivu/WMpT10+N2/RdrNhyFqo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782663013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GaBNDeR2xfrwSpodfoIAyoWtjJIBJ4SFFIvZEX+sTsM=;
	b=Q95kZhjEbm8ruuTmDMLaED0aPlr1wCr9+Grtz5uqyjinH0vq4Udb6+Gh3UsKLAFsJFnrjU
	dWMq0Onji51J9EBLqxaJ0oquL7sqOe0wSi2jCLvb8YNuYTAkFcWWEAGzeiOzoZkfD8nXZb
	xvajiv+C1Vnj2HN91wo2R7xDl3OIPH4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=sr3e2g9F;
	spf=pass (imf28.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.76.191 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-10 (Postfix) with ESMTPS id 73C491800377;
	Sun, 28 Jun 2026 16:10:10 +0000 (UTC)
X-ICL-RepId: 019f0efe-d85c-7b15-90b6-30e986067b6c
X-ICL-Out-Info: HUtFAUMEWwJACUgATUQeDx5WFlZNRAJCTQhKB0MGWQReCEsLQwZcBlBcHA4XXhtCFUsVXANcDkswUBtfAkIPHBNWFRMLU1ZbE1UXRgkZCF0dGQpQUAVaEhhcFFxQWB5GElYNXQkZGEZeUBtfAkIPHBNWFRMdQxkPKwhKBEMHRQJeCyUTCVNWWxNVF0YJGQhdHRkVWgkKV1FFXxoGWgZTH0BfSwFAA1wKRxRABQwGRgFJWB4DCw9cUUUOTHMEVAddBV1WUAJaVRIEQAhWUF4IXh9MHA==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1782663012; x=1785255012; bh=GaBNDeR2xfrwSpodfoIAyoWtjJIBJ4SFFIvZEX+sTsM=; h=Message-ID:Date:MIME-Version:To:Subject:From:Content-Type:x-icloud-hme; b=sr3e2g9FhA9S9fg6JXADqte276Zg6oprY2kmpQI32kgEA3C/ekmvaiarOHTZNVGXyUkmLzqrQg2G7V+FGT1J1xh2Ll4thyuR0HSfX+PqsIOZ5KqLgtN7WicLDib+5dbRXZ1xC5R9Tm1QW9Imfq1ZVoGULK6mSv4ssIZMbAP48PT6NYOK1JSWi4DWTDhWvVTtBJHGEDe5nOI2uwbUQlsQnfmRCMYCVA0P/+jyYU0tXMP1HxkNbP9/cR+DZPkUS8FYBwjxAr28M8VQEE1G26iEOEZtd2/WO4DdyxznVRxOCNnst/oW1o76oL8cb28YHsAvBfEeZoaWvLMQ/PmL33CEfA==
Received: from [192.168.255.10] (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-10 (Postfix) with ESMTPSA id 378D01800105;
	Sun, 28 Jun 2026 16:10:01 +0000 (UTC)
Message-ID: <c5fb5718-0f32-4787-86a1-39af0f87c574@icloud.com>
Date: Mon, 29 Jun 2026 00:09:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: david@kernel.org
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org,
 bruzzhang@tencent.com, hannes@cmpxchg.org, kasong@tencent.com,
 liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev,
 rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com,
 vbabka@kernel.org, weixugc@google.com, yuanchu@google.com,
 zippermonkey@icloud.com
References: <c6220407-fbdf-47ab-a80c-732e470894bf@kernel.org>
Subject: Re: [PATCH v4 2/5] mm/vmscan: extract folio_free() from
 shrink_folio_list()
From: Zhang Peng <zippermonkey@icloud.com>
In-Reply-To: <c6220407-fbdf-47ab-a80c-732e470894bf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI4MDE0NCBTYWx0ZWRfX5CSM3oh0hUoy
 RuDw3kshCgBSe48wJ4S5LKw3ulTRgkpS96dQ2gCevoTjosZEZwd0RFzrXkEAu4k7vs75+3KYuJT
 5huOCGXSeM96jGWgH6pa1ov9pIKy6S5Rb/mwd7qb354DA6t4Xe1rb38wBv6TWg/0kz3aW/TeaDy
 1RxiSmRTGH2ziyHll1vtk38jhF6Hi0irDG8bo2xqaz4UP50qSrnIXlIlCgKd6LRa+4ZkpGEOy+s
 eM9qL6XnsSW3K+jGSnWUR1p1qonhpXvtEhUJpIsgkrQsB+a7L3p78sZcsy4CH78Of9ltglmVtjS
 oIL+dc0Eg7pAw1hSMCI
X-Proofpoint-ORIG-GUID: -OBesckUmrxjzLRpCYceLOHYbKCzqiKE
X-Proofpoint-GUID: -OBesckUmrxjzLRpCYceLOHYbKCzqiKE
X-Rspam-User: 
X-Stat-Signature: m4rsxa3w513npif5csyj9mfzgcc4m5fc
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7967DC0006
X-HE-Tag: 1782663013-508648
X-HE-Meta: U2FsdGVkX1+vJoBTjIgfNJ7AFouiixRl33C9444ppQvhGgb20p+IaT8/kbU3DJQCzSPWEPkFgiL2etcOyoUgaaZeEMTiC3/plqPD5PZ5LJoAX0mtu7uGcbZ4BqpkB6w563nSfZzCWARXIhBb6QAvJMVv7/RbL0Fsl5F6vYH7sEi1n18rNPNW5X12DZ8tURRZ9iuHGr2nBak86dUgM2+xIAPq4uaIQWzpcLmzai/b34Z6hBYk2XHuHOit4pwHW5S8O4C4SLEcgo8kbRM4yEBcssSW44AlFUwmhWKHZTS086sYgpAmq0Xqk/CJFpf9jqu0Zjr4iIP3DI2gyf/tiXcnvfnwn5Y8/GaQ43ObVxdsaUv9gsCyx68qo/rf2xuyWZDJITpAabNBhueG5mv9yyYwx33g+4c7pK8DitKTzm+1O0Cq+f7MHq7RKBLhbObMZezBpy1JRjcr6Xgb6YBZ+Ob4PuABdUNszas/vvEjMIdJ19MO2fawsxMk2YIZ7RgjzE+ob+y7LN4uNfi+AIeMfjC/tfSWa1NQaJfcGYqCFTzMdtoW5Rmgmk8CtICsIAk6QYrUrt71rz3i4XGT/bVO4V1FZGNC3/kzK/OiOWt8aqzMYKBOtLd/+tAlnWXJrQurBuaqnfjqVm0tleuKhcHQ2Q8/pshrNvNQfAWQqOv0gZMCgls1nT84Hfr00PHYR+34YEWcYrORMpEhCryfsmCpOfru54tsDD7GZ/LK0J5gANY+J9lYcHkYp7GK2sJ1Ra5LJ8A/wDHRNWgbsQKlsXkt5M/C+az2Of8lLXg7znxpyE5soShplei2H4Gp3BPeUl1Tn+fP97qHb7spVyEwMvjhksWyE1JP4ZMLZKTbxIPi5xTwWhNRf+5czdb53kizDbL5WFa+pqZPmbayYr93h6Atr/1lEDvFVGEXYOBI0nTs7FeQoG1gdVR81VB92c2VfbUl51dyQJIb+qInS1hxML5Xj+T
 7pVMjI3w
 nFOVJAa6lszjj+UXhVM2v1TprpTghrF/UwmUUV4ZnjIDsmeuKftKH46QpvwHg8SELpq23J9kYLDnDQqRsFMMLoiFhQ7EeBerHAHEozP6cQ3Y+0Nr5ogRRSLUwlE/ZRjt6gJzZgpQdzUW/LgjUom/EeSmLOjn/ElSxaqk4I4lechKL7gjhf5twRWtpAFYT1MTbq42PTmIRf2btsvze7VEDW0dUijaJY6R4/VW374JrABybm8wE4dDNxfPQ6c+02IXyYoefRGnd4NuubD/sLNR5pUgPZxpuJz98HDWIuB0ZtsM5oduBVh/BCj5jlWIMieCSInLmXo8sohGqH/or5WQze1Emch7KhnoAxqHPIWL6R8MlwwPShHjAUm+65rWyhcIxHt3a11dtL2hE0gflg1OP5VSWlqE0mgw+3h+R5rD1SXSHxWrL0OkPo8KOvFIye/S7vW3uFFwsqLBqO56BORokJhkJmYIYtO61CQhG1Ui+gqU5HVGb9FLx/cTLSM0VbqFofd4ltu2q8OF5C417wQ3DqG94Kaldmpsuxo1X5iRiVQHvoO04vdEeBnL5nzIIWz+epY8WCGM6LKvcHKI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 02:17:53PM +0200, David Hildenbrand wrote:
 > I don't quite like the function name, as it sounds like something very
 > generic, when it's really specific to memory reclaim code ...

On Wed, Jun 17, 2026 at 02:24:24PM +0200, David Hildenbrand wrote:
 > Stumbling over patch #4, I think if we call this something with a
 > "try", a bool would be fine.

Right, renamed to folio_try_reclaim_free().  try_ + bool reads
naturally, and the name makes it obvious this isn't a generic free.

 > You can just drop the "else", no?
 > VM_WARN_ON_FOLIO_ONCE(folio_ref_count(folio), folio);
 > Likely can shorten ... Or just drop the comment completely

All done — dropped the else, added the refcount assert at free_it,
removed the stale "swapped out as a whole" comment.  Also made
nr_pages const and reflowed the buffer-release comment to use the
extra columns.


