Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 122F2C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 04:00:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7C666B0005; Sat, 11 Jul 2026 00:00:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C52FE6B0088; Sat, 11 Jul 2026 00:00:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8F6D6B008A; Sat, 11 Jul 2026 00:00:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9C0696B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:00:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13D5DC405C
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:00:28 +0000 (UTC)
X-FDA: 84975143736.03.B43E764
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id C6A1C20007
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:00:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Lq5Ijklz;
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783742426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wMB9hZGkaNnwU+JYIYN9xiLdBP2WXXzf3/msHhze5/I=;
	b=K7v4BSiiHhhcI+juKdduvB19G840RFPl8/sA9IpPEhukHj7vdsoj3D+TqVdsXmW/IzapCu
	A3KBc8K4goj1MLER0u2ve+CbLDXJLxfmpUcinJjAxvQdo0pWHZuwTtale7owk3f6xVGmuW
	369PZvxeaPeHN0kKBpuqu9FMT3aZz4c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Lq5Ijklz;
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783742426;
	b=aUAObl/CwZY/be/5zVd3F6dnqNjOBa1mtAvkeCcV+7s96HZGg3U8tPinm73pPaFyB0UTOU
	PSdhvaVNKVn7ptCaNhT+lufyVsuidpa3aP0DhX2NavKKh1YZFq9xMFExkV1dEF8R439XAe
	m427rUFraT+UcTqf72yiP/rDMEy0sYU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wMB9hZGkaNnwU+JYIYN9xiLdBP2WXXzf3/msHhze5/I=; b=Lq5IjklznlhOxbOFWGArIucJvy
	I3GnYkDwy030lx6S8plMsKAyZqlpBTEFH6fpxu/jDASiHiWPsDcJdKa+nQ139s2OUnCncc6LGL2ct
	KJDW4cXXxcc5bUZB67uZQDTcv86WEWTKiFAHv/WTpbVjsqxdPHvbGFJkPLadbKfUNGL56x4qjTjeF
	aKfm6AEuyW90q7GxzW/J6Y4sO9unabXq7KTAXL/7FEAQTI9Rg1fpKTlAQDq3AS6uMh4h60XQjzIRa
	smkKTZabq731dSl9jbfCy+AIyPsPwAH3jhI3YnyLZjL7CDQuKk8siwHX1c2JwBlE40QNKSLBVHk87
	26XeQ38A==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wiOt3-00000008bTu-3VjP;
	Sat, 11 Jul 2026 04:00:21 +0000
Date: Sat, 11 Jul 2026 05:00:21 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Hongru Zhang <zhanghongru06@gmail.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, david@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, baohua@kernel.org, shakeel.butt@linux.dev,
	linux-kernel@vger.kernel.org, Hongru Zhang <zhanghongru@xiaomi.com>
Subject: Re: [RFC PATCH v3] mm: retry page faults under per-VMA lock when
 mmap_lock is not required
Message-ID: <alG_1bhH5aqQCNEh@casper.infradead.org>
References: <20260626075019.1833065-1-zhanghongru@xiaomi.com>
 <ak0Xl6q52exX9sBH@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak0Xl6q52exX9sBH@lucifer>
X-Stat-Signature: orbaqwciu77bj9q8r4dqp8p6ghyf3n5u
X-Rspamd-Queue-Id: C6A1C20007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783742425-441991
X-HE-Meta: U2FsdGVkX18nBBhsK1ULmdQPJzdMcujhOfwe41hS5tqgVECDaD5w0i/vCVkRTFYoJrkpW//jWGUIYI7wfTpp8y9udMeGDCEt9WAE+8qsekFHX16OfVy/vMh3gB3RhiuePBVZMRQP7Yl0j4Rncc8AnkJuiX3KY7M48kdp5YaftlUYMyHgu8NV6O3sJyajISM+MRlQSLgfOka88pEB46infCNr7ZKSW7T+7nMDl/p8tTGFeRtSshIgSgGM700Upzo5SgKqZCOApC9LNhivTfsKKbUZzfJSifuVEIkspNp084U106NLONl+aapetMoM5NqMJx+YiXAHkUi1OmfHqDD1vwvlo6TB5aZFqZ/nkQKVT2H5SIIHBp/u7RYNKR+XGVyaSWsZeHXc3u6HmEu+AJOcOfPn+w9nnVd9+WbN9v7B19Wv/PpIJL3UQZ0bXIBtfhytNlx+Q4vG4KFgFbcVR5IXVD/n2i99CImgAaC1z3SOEuYtaieReWyTakN3UprFIIVauhsn9+wQHven6VP19FKD/z7nezxuQkknl48+3DusO6SMyiaNL58vs/emzyg0CC1tXwCz8RHzc8UnwljMqeemng3K38aXmHaTI9qL3M193600Rr6zeBKGb5MaUWHl+q4xFTwV1nrFhRIbz/pGsTER+KXDs/+cJQ/0Q1X6WDK+IkYd39EEwF4aBTpxVm+h/qmqBO43MPGPUCNxAirFdOBHuavIFoen1/cuHHh2Osg4gaEDLPgC8olXRVq6UT0cBferYZLcpjnStYZFODx8WTYY7I+hoG6Kbx14E8wXERJcMDPl9T5yp/vCEgSnncbAvelO52reK54ZY5OesMEsP/8dqa9AEifzsnnSk6jECz8LkLJ2N8MJAUWgHXi0ilWd94+/JNXFP/L7efEbmMAp268ziWWX1OI15GFQkv2ubq9GG5FJ5Eg9gHeA333uu+DVpitjQZxSwntJKiqkrsOjW+a
 3LnpAAjx
 QF9Btm/YjXccSxvpiERyVHagrc858NgXc6EA0EHkL0uZCyY2dBA7BxAEiQ6wcIzrpGah8+8SgX7U9kCvk3zLXlIS2pyUVRj6V5E8ysD86xm29tQAYPzJrrf+EavXiwUIxfzQzwPwlD+FRyT0P5NoU7mHVIqcJ5MMTtpmd3b93OuzZHzmdK+1Cgjn6tNPqlOCfxj/Mke3ygujD2dz2QeRZLtmRUmLkGpEJY7I4fEaSp1TShmemeDSdw+tigfKls7237DVBdS1ibysnK/4SVwJh9w68AOKmY+5tzOrsEO/rHOHnjFezZ6/PR/iPCiAAQYMWs+6a4EJugkusEs7c3aoxXa6fNKkx3pm++cGvcisqwNdOw/evCXwA0+LnumHi8mgNKVNLss57PHwR3fM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 05:52:31PM +0100, Lorenzo Stoakes wrote:
> +cc Vlata, the only one from the MEMORY MAPPING - LOCKING people excluded,
> and Willy as he's been heavily involved. But see below you need to cc- way
> more.

Ugh, I hadn't seen this.

No.

I've been looking into this problem, and as usual it has turned into a
yak-shaving exercise.  I think I'm five yaks deep at this point:

 - Need to start by simplifying filemap_fault
   https://lore.kernel.org/linux-mm/20260625195040.2508362-1-willy@infradead.org/
 - To do that, need to improve how we handle unlocking for faults
   (not posted because ...)
 - To do that, need to redo the hugetlb fault handler
   (not posted because ...)
 - To do that, need to get Jane's series landed
   https://lore.kernel.org/linux-mm/20260617172534.1740152-1-jane.chu@oracle.com/
   https://lore.kernel.org/linux-mm/20260709184740.1286561-1-willy@infradead.org/
 - To do that, need to redo how we handle hwpoison of hugetlb code
   https://lore.kernel.org/linux-mm/alEpBqExnyvBnnxi@casper.infradead.org/

So yeah, I'm not impressed by the approach taken in this patch which
adds more complexity on top of a system that's creaking at the seams
with existing complexity.

