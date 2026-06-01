Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB3E6CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:17:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 627496B03C3; Mon,  1 Jun 2026 10:17:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 600376B03C5; Mon,  1 Jun 2026 10:17:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53BCF6B03C6; Mon,  1 Jun 2026 10:17:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 459136B03C3
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:17:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DD1D7140722
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:17:35 +0000 (UTC)
X-FDA: 84831546870.01.DDFCD29
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id D676B40008
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:17:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IXhmkp7m;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780323453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xMHohn8ib+nTT0MSQlhmtBxUWKbPZdtUePwCdFaiEsw=;
	b=BfOZ6WKo8TeFUUQE8hjq9ykhIGdlu1Ow8WYPUzXiufe180WstTiaeOgoj0yPSGKHL6fd4k
	gy/3juqKiw15CMs687K6rFLf8fR1CsGiXH9H75WNzbqE8qepvJX3LDBFu2KZuwy96Srpmx
	3AIXdZKSD4cdWxH3t0w9cVwciqYsb1A=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IXhmkp7m;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780323453; a=rsa-sha256;
	cv=none;
	b=G+ucj9HHSMKhyPmQF0rm5N7yeAiQWHNiv0J1FEvCGonCjcFBaEqbvidoXEEWvNUd2BscmO
	s3VznjBLyia98KRjrh9iwRRUVluc3gxsx7ZWtDAP5wUs6oqyrTJL0wpjVNXP5rlTcAMavD
	D3LSRH4TDZKtP5Niljwz6T7CbSdaST4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7675F601D9;
	Mon,  1 Jun 2026 14:17:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41BC1F00898;
	Mon,  1 Jun 2026 14:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780323453;
	bh=xMHohn8ib+nTT0MSQlhmtBxUWKbPZdtUePwCdFaiEsw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IXhmkp7mBhjIym69+Gd+c3c9qim3s2Ac8Y50DlNa1quvP/JTINsdzGvxgqJK5UW1B
	 kuJk5vPd2lnzQZjfqDAcoEdLGXwBeq7pfpJ00ZWaz2NH8hDhG5tJeVJvDsXlWvEaCQ
	 UU2jShEOH9WuGO58I0CVUfHJFVSRbtP89RlnmEIJ7LeHra37iBu9uS2pg1lCur8yUn
	 M1e+icRKBBaBO6CyWXkBBp8XHb4lYPoSJEOoW/EUrQaWuhmkt0qHoC6YuNqlDgzffF
	 IspfXiI79vc9MszQuu7DwZPioR4Hju54V0SX3NXDqslCCkjId4N5tGYJ+tXfJrkb4w
	 lpweXzLLsEesA==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 2EB1AF4006A;
	Mon,  1 Jun 2026 10:17:32 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 01 Jun 2026 10:17:32 -0400
X-ME-Sender: <xms:fJQdarRmLao3cuH4oAxgdbYlbbkHp0V6yMXuxLK6B6-KAq8ij8RlMA>
    <xme:fJQdauWvODjUidPW1BDS6DQzrUeS-knE6hW7l0SIQRS7wCitv4NmbhxZKB7VxbHp1
    FvezvFbZ4yHzimsH5QRQdUFp93ycEwr6zma4eo5lGd_dqEvf2xnkA>
X-ME-Received: <xmr:fJQdagE50eEj_E5caFAvkJM-Vvv0u3E1tLzWVNhSGtk2xaF1YoT_b-fL784VHg>
X-ME-Proxy-Cause: dmFkZTE6mAFYKimHixwxhoERaI7ppCWM6z9OXgM0GSKfL73ERbp4dYaq+CUDt86WyAgf9u
    FXiiryEE7YGZSfeiy69NuQe92wj7dAL3e4YHB0O0VoR9GLr7XTofPaL4fb3PcaTHqYbkvK
    993FsjYOn+v+t7bGnVOUsoP2sAfNw3WSHvXxQQoJBS6c5T7DnB/DcKIrG6OLWdQuki+L03
    rpBbjpy2NkcKfDWET/gNj/8OvusXYleGvHaZmmOfAm7BCWCIObpKPPcka8daFiAEk6TzuT
    26QU/fhH6pJVERpzk+O6wnrICszLI6fhL/gfL5oFSgyKIa+xVC2YWRHEH5SYsiWTP3uhpH
    6SNwEGiAEX23J6Ou1RQ2Gs7awP+etlPITl/0cRiwXxjSV2ONsY40ddFdQvxvZXfqEBplC8
    s/gSM1XPerws/L35jlISY/cyvQhjkQK8dTgKCrSMqw7d5A7+UgI4X9Kv5beV2bSqF10yDg
    OkRZA+PaVN5pTFI7xK3SLnMfUSEgiELsiXpKxIFXmqFNsE1EZRQUhfc9BQPTqK2JcNxKS6
    XYP4JIkEIM88aQaNBBNw3Y7ASFAuc5KeppVleLWrBYBlz607H51BjOC1IuLiGkVvzPjB+w
    Ht1jfTHy4SMPRMwsX6xxhbKH54oNeGGvh5bjUBDDBjj92oL35gZ4KNLefsCg
X-ME-Proxy: <xmx:fJQdahf9NrUuiwYn5UbzeWeGpcYG3cyZTydlPebjHO-qilGvHeJYjA>
    <xmx:fJQdapp6mZwDfV3wmKjXnomANsEzMnVycIHJ7KM8YmtfY9zgxT_Gmg>
    <xmx:fJQdaiAO4nXvcVyiu-RIG7JVUNWBzkM8FPnTf8b3S_XsD_cy7wzbXQ>
    <xmx:fJQdaiflYIz2YHEDFGrCP9BXJKmsQ5Rf7HgL5uGeHwPj9W59Vb35aA>
    <xmx:fJQdais7hEqnVxq1sT0BstTVLKplrzTkV1lZjrXbv3u4V5PAZmbrj0DG>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 1 Jun 2026 10:17:31 -0400 (EDT)
Date: Mon, 1 Jun 2026 15:17:30 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH 0/6] userfaultfd/pagemap: pre-existing fixes
Message-ID: <ah2S7MJ2VK6R-NSN@thinkstation>
References: <20260529172331.356655-1-kas@kernel.org>
 <20260529173448.40a37785ecbecb6868fdd6a2@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529173448.40a37785ecbecb6868fdd6a2@linux-foundation.org>
X-Stat-Signature: j1nmifxe6kfk5imforxti431x5gjrek3
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D676B40008
X-HE-Tag: 1780323453-100446
X-HE-Meta: U2FsdGVkX1+LIQe+u1U5x4/hAv+9JQYeYo4dxNg9e3wwBym81PhKRoBOHthHGXJ5C6JsjjU3sv3RyAMjjXHBjgwQSx5mSI7TXGiC8b7g0VODJOqZG3UF5cqLZ/fFOb2bB2yYUwVUHReOGZKQNtJGIk6bxPvNJVK6O5hRTSvcBcukd0WP98vg3GmfmPELTHCV9H+bryB9T52T3NLJX+JIVrgJN7ObZHvUvJmtbuG7HP+pwqZCaqEEJ1D1MUveAIMQISu53pmzNyU4fix1gwzd/vCLu/nX1zC5rFK971XWGEFrkJVseS/sj8pqQ/Ub1zqpx0wg+tqajNnrcak/IgfTGF4A6zdP++tnXbZeanI15XrTfgi7RKbsXB1z5u3gtywdtToNEf02Um6X3tQ1JOmT8RxTUPxCkdWsG56XgyFtHKwBVcEP68tLJ07ct+7Tb/+CDB8gEVCiSCi6uOuHgs49gkGbtaGQfzQOMvN/O+V5JbV8Yxx8yRHVumUK+TU7MwzusJnwFyD0rvSpcDZ7t80vygrLOyvHFhf8uBfpgCEJd86VHTn8bI19FDQeFKfNCYlgjp9jvFtxBlwSefLpF9nBAnYUMwtHjhwGb8tvLJUMR3aAEOx9YOfVECSG1Zsaz/aXW0CaXWhDi88m7BoyiASSTIxDt4OMT9462S731rXrQyBmrtor+tfCv7GKEiWEW6n7+x3C0c0K7NitXCpO3vvRVrgJ/wtp+ucMKw+tnNm43dyQxD5tm9DEnsheMGWFWnikF4p2Udws13XfYS/vtNUqmeK/qs8hbbAkj4p5pawSQh04uNpX3giMG+IrDYRvX5PZaMnHB5p3HTQN5jdcvLCtsgUKlMGMwft4BVTc54P4k1i4Z+wz5JXdPkAxosKH6QGYc4AhogdTXTKxe6Ynmsc6EY0C6tKufl4JXqpcWxsWDYEl/rEncYYSA0Gzik0/l+dxTfzQ4jN7KsxI8mkFndH
 9BFV9TBh
 JHK9fPPsnTTscgaz7NKWZLzXPhCSn1ysGfbqtvJZKY0JDFpw+ApUAEzsfEj/wqRsaIgKMFUlzcIxbNz+B5gpqVvx+28p8Tg6Zh4KKnWZpor0FM2mnnUcWyX20+iNfFpsxbDrIkPQYFzaD6EGL3/VFpBAqI2wX5KjfdYQL2KzqMFOC5Ghty0dKbMVzgkPCfaPQEsWjQ/y5/70JXSs+bAiUsp97UWsa6tFvz9mVmY8YiRKEr3n9lGdQa4Z3hvjiEw0c1XkFpIptEke+13ZqyjqaQHuG2edtcJSStqrrAQJBRe+Hghyl/CDLOukauVz3T24Tcq61Jp2y4w2vvAbBdsTwqdQSJLfRn1gX6+I+MQprEIr4O0U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 05:34:48PM -0700, Andrew Morton wrote:
> On Fri, 29 May 2026 18:23:24 +0100 "Kiryl Shutsemau (Meta)" <kas@kernel.org> wrote:
> 
> > These are pre-existing bug fixes that were carried at the front of the
> > userfaultfd RWP working-set-tracking series up to v5 [1]. Per review
> > feedback that fixes should not sit in the middle of a feature series,
> > they are split out and sent on their own; the RWP series is reposted
> > rebased on top of this.
> > 
> > All six were flagged by the Sashiko AI review of the RWP series and
> > carry Reported-by: Sashiko AI review <sashiko-bot@kernel.org>. They are
> > independent of RWP, apply to mm-new directly, and carry Cc: stable@.
> 
> And...  this made Sashiko point at other stuff:
> 	https://sashiko.dev/#/patchset/20260529172331.356655-1-kas@kernel.org
> 
> I can't figure out why four of the scans failed - "View Raw Log" comes up empty.

Seems to be passed now.

> It's concerning how frequently Sashiko is finding pre-existing things.  What
> would a full scan of mm/ tell us?  Gulp.

Yeah... :/

I will look at the new batch of pre-existing issues when I have spare
cycles. I am not sure I have the bandwidth to find the bottom of this
rabbit hole.

What do you want me to with the main userfaultfd patchset? Sashiko
failed to apply it because it is on top of the pre-existing fixes.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

