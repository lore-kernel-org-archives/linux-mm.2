Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B12CCCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 01:03:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DA1D6B00C2; Wed, 20 Aug 2025 21:03:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 089806B00C3; Wed, 20 Aug 2025 21:03:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE1866B00C4; Wed, 20 Aug 2025 21:03:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DC10C6B00C2
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 21:03:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 877C81A01F4
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 01:03:27 +0000 (UTC)
X-FDA: 83798966454.28.3F8BA41
Received: from mail3-164.sinamail.sina.com.cn (mail3-164.sinamail.sina.com.cn [202.108.3.164])
	by imf24.hostedemail.com (Postfix) with ESMTP id 659BF180003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 01:03:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=ZU5audtK;
	spf=pass (imf24.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.164 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755738205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3BE4U4qULMJ4toWt5V1Co35e1iLPvH1DLi6EO1scyLE=;
	b=PJ6D0zWO4TuF24AjzwqGFkvcWkTf7b21LV03VstKVRP9yo30pKKQkO0EQ5X8Tn3An++Zev
	6+RyjrsGrteBOx6gq2U0uHdPvV6OBcW8pMhCKpfbzvOyX/DEGHeGQaFaHf4x5BO/5YhgyB
	mcLK5TaaHIjjUCEGHUOm4WjvkJnlkKg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755738205; a=rsa-sha256;
	cv=none;
	b=64PfHaNTbY029OYfY/+Zd1qfEDgE+z+7KcRq00oagX9Ouki4c9J4qdgPseP1OzrBbIwBNE
	cty9e/abwnV8Ku4fw/bZjW4VTpO3g99uVuUIWvO13lnFnBAHd/12EgBxLwkXxKov+TrK7z
	mgm8TXbmJH+pPHFXHucp1HwQQXdsvD8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=ZU5audtK;
	spf=pass (imf24.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.164 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1755738204;
	bh=3BE4U4qULMJ4toWt5V1Co35e1iLPvH1DLi6EO1scyLE=;
	h=From:Subject:Date:Message-ID;
	b=ZU5audtKElEfeu61jgWrjtxD+8S5jLHVrBlRSTYcEB525qXsUJDcprKY1FYdTE0s/
	 DUqbI1YfNHwfa5fej/BlRoqEpfXjiNd8HTxrxRGKz3GS7xeIkRgospIzmIjNnf7Tnp
	 zJJTlgGVSftIumhkaBBdkbHC3/Wjl9jip9Ifr0eo=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.58.236])
	by sina.com (10.54.253.32) with ESMTP
	id 68A670550000338B; Thu, 21 Aug 2025 09:03:19 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 7136754456954
X-SMAIL-UIID: 7C74DE84D15245F8AEC04F122A052724-20250821-090319-1
From: Hillf Danton <hdanton@sina.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Mason <clm@fb.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: Occasionally relinquish zone lock in batch freeing
Date: Thu, 21 Aug 2025 09:03:06 +0800
Message-ID: <20250821010307.5142-1-hdanton@sina.com>
In-Reply-To: <20250820151307.1821686-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 659BF180003
X-Stat-Signature: f83c5y1rhx1abe8eekg9pbh3qqzoygd3
X-HE-Tag: 1755738204-470697
X-HE-Meta: U2FsdGVkX1/ZvYVeJcD4uielD6ahEhyFehi6PwzQ66V/CnNN1Jzm8B6bRfnUopMhLq200MxzyTHS7HkfNBQjYRdsb2pSG2JFAaOZkGz9dUnYxi0SRho1A/V4db3Af4g+3OIKMRejyU+IX3OFcDFSBQJEwLoEIFA/ObJbTsdedHOcoDgIlOHC+zuZn3y1qrEatj49+GJPi28+W651uqIkj/qx/r5qkti8zMfmmUS6sxEHfcxZKwO9ehnv76YgRNAFannx8sqxiHHReVIgsHXrta4DZ/m3OVtUw6zvQIvGomYO7O97hrQ7Ur0lbeAdruNwZNkt8Gc5W88PmTypWEJxbX+/AGrEHM8St6zMZKe0h+Z1cKE8RC+IJ2I9vMJLpX2MsgZPTX/qriYZyV1YQ3oj/sQp2lPmW7uW5+vog354vYLaejjIwasYjmSMdeG54GbtQY02Ccos+0Enxf9Yu5+Is9/jLcAkAnWvZpyJFI95V8wpn6BTbYCAhY74Q/OTUK2KAgzB9Eek9kCzGSur8q4Bk5lLhET5GXjwbjl7YcTecQiEK8CsAFL6HI9XjVa/FoxXefEH66zKv8i4kkqDNoTBF5+SKPlAGuAQiIfXNEgcwGm+OW+CCG73/TLMRt6aTCUrrEUR+xOLuk/BWV/zP3Oj71S0/OQtlnWfv6hQ+0GoaunTCoB1KVJ5lxAFvtPIq2dV2XZbAO0iAEuSZhh+M4H0492FruaSE1Mdz8EZiA1+snA2DJcnRWxFp9DpCFfMTYEDcj2qC2MVMj3f/0rDHUUQSXziaqGf5fMbt4gR9l+44R4+sOexIZdWjwQmFTebSyHUIYcb/nzj9lmSt04uzj/w62NYU+ox8OAMcrenkrYK9Uep78bkXwomQtG6nR/3Nqlt+JrScG8oxymLwYi7bEGVjOb/oYgjsLCLHWmr2p+BUdLuZzyhzbTSshYgH+VKZT3O3eH8kDfRhdhrXdmKBIV
 JiCjKpPp
 PrONzRg9ayi7eQCd+a8tLF/S2qdBmWI1lZImKG2AYo6i1AYMR9foq8Xj5VpcpjvZAPZJsrEGRnhuazNHU6XtaLw7qmxTwvdbQzqBitKUiK9+rZFjVnQhTAfujjvZWlIvzDUVCRVGNG6Wp4W0ILdM+T4RQq9KQOvF2sLxFGFoaRukJxD0nwCtId1fQTyo7FcINA+J0yWSzwqK4fINlymt3lUAbV1DRUHPaifSuYOO+3kVz68z8mmtsVbkELxG83bLU/qaZMyVDKbw/eoYT9U1tFs8H3sTXcQW1j+VkVhKi0yY2ScWCfu/X2VmU8Vl+T+Onh6kdQv4WTIrSSBiiuBlFKawql/qFvZ+Pvji/o4ijf4bkthcj/PplsWJrCrIzddLVDVPwjvJWOpg9es+md29ObB/vvWvro3pTHvrSMceWOIdHbpU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 Aug 2025 08:13:07 -0700 Joshua Hahn wrote:
> On Wed, 20 Aug 2025 09:29:00 +0800 Hillf Danton <hdanton@sina.com> wrote:
> > On Mon, 18 Aug 2025 11:58:03 -0700 Joshua Hahn wrote:
> > > 
> > > While testing workloads with high sustained memory pressure on large machines
> > > (1TB memory, 316 CPUs), we saw an unexpectedly high number of softlockups.
> > > Further investigation showed that the lock in free_pcppages_bulk was being held
> > > for a long time, even being held while 2k+ pages were being freed.
> > > 
> > > Instead of holding the lock for the entirety of the freeing, check to see if
> > > the zone lock is contended every pcp->batch pages. If there is contention,
> > > relinquish the lock so that other processors have a change to grab the lock
> > > and perform critical work.
> > > 
> > Instead of the unlock/lock game, simply return with the rest left to workqueue
> > in case of lock contension. But workqueue is still unable to kill soft lockup
> > if the number of contending CPUs is large enough.
> 
> Thank you for the idea. One concern that I have is that sometimes, we do expect
> free_pcppages_bulk to actually free all of the pages that it has promised to
> do. One example is when it is called from drain_zone_pages. Of course, we can
> have a while loop that would call free_pcppages_bulk until it returns 0, but
> I think that would be reduced to unlocking / locking over and over again.
> 
In the case of drain_zone_pages(), I think adding something like the pcpu_drain_mutex
to the path updating zone counters is a cure.

