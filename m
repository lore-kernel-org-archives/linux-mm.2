Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 728ABC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 10:45:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 815676B008A; Thu, 10 Sep 2026 06:45:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C69C6B008C; Thu, 10 Sep 2026 06:45:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B50B6B0092; Thu, 10 Sep 2026 06:45:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49B646B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:45:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 829E4A4D4F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:45:39 +0000 (UTC)
X-FDA: 85197521598.17.2037486
Received: from flow-a5-smtp.messagingengine.com (flow-a5-smtp.messagingengine.com [103.168.172.140])
	by imf28.hostedemail.com (Postfix) with ESMTP id 83368C000E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:45:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="F dAfoBX";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=RmGKVhSf;
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.140 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789037137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZYgQzfa2ctP1UICDBHl7m4arCSxFxSkit8FF1mVtkqU=;
	b=O7WiBjsNnpKk9bjf9kzOKGk7MWTGMloVAyo9JL7yMWUz56ed7tnSPyeN3h9fNbSmYVrAc4
	2C5ksg/6IJYMy3sIeD4NhKi0TFu+OqHBgRIVn7hxIECBPTglTobLn2xU1RlHjPUBOG6gIb
	6YBGoU6cbdjwT67bop28ydvoITbCXjM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789037137;
	b=kfCNt75/IKfeUE9v3F24gqfAn7QI9clUNBQuqelYacYq1udEE9R+7DRf3dGt7uSEyd391O
	S3iWQVE2TbmUSY8obpeN+r+CJ6kfLt+GikBORvkUV7U9O+cPA/qikIfudx9PQYSf77P2wk
	spsVuogvneM16ulqON+M//ZIzvJ+uew=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="F dAfoBX";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=RmGKVhSf;
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.140 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.phl.internal (Postfix) with ESMTP id BEBD0138037C;
	Thu, 10 Sep 2026 06:45:36 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 10 Sep 2026 06:45:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789037136; x=
	1789044336; bh=ZYgQzfa2ctP1UICDBHl7m4arCSxFxSkit8FF1mVtkqU=; b=F
	dAfoBX4AFXFQNQNyJ4iIIMmtIQpz5kX3rzgchRvXVNWGV6sQGY8YJT8N93ucoBpc
	tBNXjeY7vNbS2Dj7qwj9wJGxgkvwe9bb0FXmhrlset3Ng3gncoTmLDR7w2zwlgSr
	+Sb+I7shLqMMgFW70uudbRpDQ8SSHMWQX9h2pW3huX+vJmzk1hoOeCZpH9o1A9+I
	g/idStTOaG1+GQz4y853QQp3M+2LCuC0nB68Uft8MaSfM6h/BqQGxLA38z0PeQJ1
	F2JfLwdIl0doRpmX4fyrcd0oPvu9X+xIXeBWgPjtv9+27TF3SKybmVXanKJgAsXZ
	m9DyJNK11W/ghf9vJzziw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789037136; x=1789044336; bh=ZYgQzfa2ctP1UICDBHl7m4arCSxFxSkit8F
	F1mVtkqU=; b=RmGKVhSf855Dtaopl545RstTURk1eyeXbJk0rz1lc8kD2L3Rcpz
	BtczOMR+IFNuoqyM+YTdp2hdfFO4UWU5cnwGmwutbYKycEs+dJKjQQDEFO5YxuBb
	SqijZELFYmwd8Nl4bN2tpbrT7nCLXy/TuPvHfVeKpfWC7YBJxJZzK73uPiXmnR0L
	9iDDJcEhijs53rmTUwOTLXVcUaGgj7VjCHgfW0sLxin6OSTru2+Jc2Vg+YixIz4c
	0gNVQKcoajcF80ORo7sDCEUVmCod7ekqxYc5UmAYEg3K70TiNns+iCGGq06qTsSp
	yyuwrkQ1gmzbzOawyxy3wYR2rTBFC8FkOLg==
X-ME-Sender: <xms:UIqiaprW4RWq-sJxdABzaweJCI0aZGJ6mAOM2uA0PZZvv4Y0bH60xg>
    <xme:UIqiasXHNn9xPQaWW5x2ckXZFRrm6bRtFLuN8593ZiSwf97CycBgYMVui4f7lempg
    Y8HUKeR5fBqzgHlVSOwok-luoGyv6-0Fl7hrJbQyW8SdLCoEVQrdQQo>
X-ME-Received: <xmr:UIqiahR0YZAyg9ogTPmjBcYs8-AI2C2g8q1WL99GNb5xl-oGQjTSz-F57-Q>
X-ME-Proxy-Cause: dmFkZTE87Z+QS4xVAJvYfxA5lQAfXmH0aCot7TBmx0IaDvGmQHEsolxxhNS5RvvVKSmZ36
    P5I61EVYH0sxtNzv6UfnGLrkEFvP4iPAR0jI1D+kk+/PF/Y1RJ5kj2xDd0ncg2Sz8CraWk
    u+L2Iwu2cZRENajCgjruyidgflkJUEH77Rb6BIFzoc78t6Sw4WNd8m2f0OyKzLQQt7eSn1
    g9f9ONyeUvOBi9rFwsP4OA3kPHdUz07PfjoaqmSVhELKJ2wz+dS9LGUpQZBrRzWyqWANAd
    5+/w6NQUhzp3wSMoGE7FubkoTz7CIqwm8JKTAIuYvVwxZ+0HZo2V1psyjnWjFV6VYa46Yn
    rIqtEnsSrEvQmvGZ9UmpuPRJiZt56xT07GoBSKpbzwiX6Ex9nCbDsJhXu98FV8NtuFL9Pq
    Tg7Yji7Ydde8GQW9Z0v2E53sk/3QWEyCBI29M6r7KbzNMeiOsgNmwBtyMZLA4mD9uxxleD
    pMkJFr1kNbQXMrZT4vlPMVPdBtbtrSwX5fwqJ4FQ07fPiW8EHURvX2UUemct1+YYitB2Su
    IyBuDHMrXG6Azi6KnPGHcu2voQV45mnpPmULjn6PkQzx/BvOEcuPgc4830i3yMsnrgIF0q
    Sq2Ay8BNNa6JPBhkZL8Qw4CDgRuB8klFITV+mOil2L8sOmho43qUcytcmsEA
X-ME-Proxy: <xmx:UIqiak42CcUGK_F1X5V-_t3ofOwXq-9uDYKPX6iYFcyEXlbZb-xpgg>
    <xmx:UIqiar288PFupx6D6bghvoXnWAcNDMcJixd1GNI_eE2xZEb_a0yjXw>
    <xmx:UIqiatI1kzi2JvBbobn9t6KjZkMd1iWLjZj5dkWIBK0EtKZgG_i_AQ>
    <xmx:UIqiap-6vAXf4kE-F50L3GYPNzty8L5f-Y0YmaY4633H3aGblG4Lpw>
    <xmx:UIqiauV-lOCqk1XflcOqoA2znnd7vJOkZY5ZbmFSz-vkxPXHL_G1ywK_>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Sep 2026 06:45:35 -0400 (EDT)
Date: Thu, 10 Sep 2026 11:45:34 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	rppt@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, usama.anjum@arm.com, usama.arif@linux.dev, nico.pache@linux.dev, 
	ziy@nvidia.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, ryan.roberts@arm.com, 
	shuah@kernel.org, surenb@google.com, vbabka@kernel.org, agordeev@linux.ibm.com, 
	jgg@ziepe.ca, leon@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v5 08/19] selftests/mm: add folio-order check for address
 ranges
Message-ID: <aqKFXlpSELmCtt-z@thinkstation>
References: <20260908125105.1510704-1-kirill@shutemov.name>
 <20260908125105.1510704-9-kirill@shutemov.name>
 <feb76c81-db9d-4a36-9a31-0b2b31e3c3fb@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <feb76c81-db9d-4a36-9a31-0b2b31e3c3fb@linux.alibaba.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 83368C000E
X-Stat-Signature: 3naqqdpk9tq9zc64kxxkwqw7bbbf1cpc
X-Rspam-User: 
X-HE-Tag: 1789037137-784516
X-HE-Meta: U2FsdGVkX1+h2ze1Zow9rGyB7tE+20L0ljqxCal9CrDGPUnhMfGcYK4/fFblzi2s5P4+0Lr7PZuTBV0LDdFWzKWcGa1mMTAP1Xl6JTYEvwATGjNj0VVtU2cPSaZhen3jdyeTFA/bMgs7Yml2TsasHSdfcW+Sjj+kHU3LU6SoWSQLkoPglVBZQX5JdXo7SIZcf2IYFuVtz7YQlcuJ/p0ljma52gZVafR+XQpxAAtHQPd9PxPOuP8OT2T7wUFWUewy2G6is5tJZWfrCY3ERSZk1i35etjRDT86/exKSAKDpflOtEh8PfdphsWjEiasuYYCaA5Ux0UitiP/3X3RZrnvUgP69mLx8mIcFiGRi/y8FLt87PePuy8H9WXl62DESeyLnbin/sI7sQ/fT3CJRItDzIabF1N6HmH/0jN/C0k6kXYEqwoPcaXzS69Ay2lZ7vw7sMSD7XlcGoNdpCInFRyz0gvmJX8V5oGfTt9wB4lsCAZuJsjGczynuOuYMuax4tWrKXWkYz54FZm39XpQJpq/y1c1Tg3DZh7xNPQOhT0j+4plXsLsxy7WT1lDrEr9ou4pi6UA7eTeCKkjqCVS61exfXeE7AoP2RLfF7GdRNMaSQpY/NF2lOvnc3T+CenZ23m1rH2N3MLhvzsazVxG5YcxDDwtLC3e+CQUh88bUeHlYrVXJuyo6lM6nwrnY6f+gvcQJYKc5jV+Nn2O7clr0h03wUntF4V3SP5Z/+Qs9xTVjw/EHSBFWvKkgXUwCxbhrdB94GPAk7k/51lylIyRnogI7HugLsmVJaegWF4Sxv/9bdRPinixV3CUeqI5j039l3RkcudBpupufqtWgFBPHJ+/SkEPC2qis5CVrB8tKDyRQ47IvPg3YKWQa28f+iytgFkj0Gp5qmUxmP5vtr40wAWKK36k8Ie2WWEqK5L4aTOQK8wjRSeKvEwfyi55htu2J50Rf6lasoGrmBom6B/emZU
 8M0TLsHo
 rV68ldrCyvV2PG2YpANVNr8S1f5ziw2rU1uH8Ky/oNmGsef+ZzFdmvrJLv/in45D28Q6C8UroBef9C+/xXnaJ8d1eOH2CfRriYjjCBCDGkjNX7JUlmGOpIGGZDTS27nlxTsUhT7vW+zahqekhLPje0rDptf908AvGlzBmzmfQr4nwU6MYHeE116o/xcPhRkC+niepO7DImEio5AxU9Oa5F0rHaKuazEYukajNTZ0h9tXeCFG6qj+zJWe81m+QGV3cROxY6CAVcviAgR4/2PL9GMCAO7ceNuLQhU41UgNWSuFN/EakS0KqzoTXC6gkTHvGs3cR3SeOrKFj6Nr33UUo+0OjFfTg8faOKfxz80GMC1eT7LWNPzgtElb8WQJYAWrXtWKko0GcBROok4rUfHPqBSzD4RG260+i5mpqBTdhtEooaWL/D5bZMjd74Ikjy85Spm43wCCyoNtPSh70H6ctCqJ10Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 06:01:13PM +0800, Baolin Wang wrote:
> 
> 
> On 9/8/26 8:50 PM, Kiryl Shutsemau wrote:
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > 
> > An mTHP collapse test needs to know that a range is backed by folios of the
> > target order, and that they sit where a collapse would put them.  Nothing
> > answers that today: is_backed_by_folio() classifies the folio behind a
> > single page, and check_huge_anon() reads smaps AnonHugePages, which only
> > accounts PMD mappings.
> 
> Have you checked check_large_folios() in vm_util.c? It seems to meet your
> requirements, or am I missing something?

The changelog is out of date, sorry: since 6dedaf0d46a9 check_huge_anon()
counts mTHP folios through check_large_folios() rather than reading
smaps, and it is what check_huge() already uses for mthp_khugepaged.

It could do this job too, called once per window.

What is_range_backed_by_order() adds is alignment check: the folio has
to sit at the window start. And check_large_folios() reopens two fds per
per call which kinda wasteful.

The collapse_order_* cases check three windows per case, so I wanted a
helper whose contract is "this window is one folio of this order".

I will fix the changelog if the series gets respun.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

