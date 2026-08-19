Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9E6DC5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 14:47:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A163E6B008A; Wed, 19 Aug 2026 10:47:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C63A6B008C; Wed, 19 Aug 2026 10:47:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DC3C6B0092; Wed, 19 Aug 2026 10:47:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 56FF86B008A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:47:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD9811A012F
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 14:47:38 +0000 (UTC)
X-FDA: 85118297796.14.C14D058
Received: from flow-a6-smtp.messagingengine.com (flow-a6-smtp.messagingengine.com [103.168.172.141])
	by imf14.hostedemail.com (Postfix) with ESMTP id B2580100004
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 14:47:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=VtH5Myjf;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="W MISdAP";
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787150856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UonL2h5MQ2AxCpmdIS2MMrVR/omeEZrCxIjmbzCsxdk=;
	b=hwTF5VbQWYQCMweyUkkw5dp6Y178n7sQJFPxWjG6PZ0zx2QDJhB/ZdYchGk09W/c/Gr+Pp
	QJ54Z/eASvkr3uj5nU9g1/ZlZdJWTwQzXLRmjtfmJDrzRnteYpmhvpBFaAYE3M8JhVZwde
	P0o4hc0sqfSgHFJvrwraGzXk+3T1TYY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=VtH5Myjf;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="W MISdAP";
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787150856;
	b=7J2rEJXRTGzIQCuj2os0QNwpQHCblF8PhEEGyG7/bzOIeN9swLIGxByO0k08tH00h3yHUM
	RyOfpd8c4MRMd0UqdiUYjMhceWX5OwmxCJqWFYgWEGH3EpGpmpQwqhhMOVedR7is/0vUlF
	rHXAaCuIkfob+A3Zn9XQFsM7Uzj5Ox8=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.phl.internal (Postfix) with ESMTP id 125371380212;
	Wed, 19 Aug 2026 10:47:36 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Wed, 19 Aug 2026 10:47:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm1;
	 t=1787150856; x=1787158056; bh=UonL2h5MQ2AxCpmdIS2MMrVR/omeEZrC
	xIjmbzCsxdk=; b=VtH5MyjfZERrSnlCK/tHd76sNRNLWsBcJQ6EZUJryrrjzPAm
	nc3FtmqnXPUTOQZLuqNA/Jr2SQUhhb4kmnyCdXBT+kSirnErt+E6LoYdcroMbH1s
	9kjw+FrA43VoSEu1dEIqgdkvmqkFg4FyBsixflIbhZ6/hB1tMfXBldUG7CBp94Q9
	6lg8A/hXVDFC9Oon4+LMKgYAr+/PC7CmmBK/B0MadIxblEzL80/p6unj4ryRap8d
	uOOA+AtNLDAKMq1vAJiUzX9x9VxM7GIvU5UZIxhkVjNs0zOwKG5xjYswqDYUoRFI
	drJmX7pAG8DtWqgkaBb9uncX1w0pGGbJEXt+lA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1787150856; x=
	1787158056; bh=UonL2h5MQ2AxCpmdIS2MMrVR/omeEZrCxIjmbzCsxdk=; b=W
	MISdAPic10bsGcEIlkzD91PsB26EFyQC3R8WpmyiYMoZBCBghS0dgJbk0Bc78hAF
	cTB3oAyj6zFjpGMuYE28HwfeQ/qNhmolmVgRI2/Gpvgbs0H9J4wYuqUaYsoZIq26
	fLLT/BPNKdQktCAokCJqBtTfJdwfpxOEReX2N04e/HMJDBwW17g0yzzkGlcMMdUB
	JogKJNZClDvB5Vs3aHz7jzmq/0dgoYS/nzfxhUwFANr7+3d6pdPorVGTinK/uR35
	pr4gov4b+l0YgYPWDO++SbxNvqMl4v19dPa41AWWZaCGZllMLY58+0rRnHT4fGHQ
	8PBtRistOXlOzTF6SDeEA==
X-ME-Sender: <xms:B8KFakLrWdEIcyzoS2Q6_LzFyOD0GhlZbTcstUoDkpmMVdBatZWPEg>
    <xme:B8KFapBqzwsoxpQj68Uwo_gD-okcQaeTiy3jSxFqopOamFqIJY5ecmrex-VwqBw6t
    BYXKfU91jJkG1DU8JZg8hST-ozWvwzCiUonPe-8CvGSb-Ewr5BuoVA>
X-ME-Received: <xmr:B8KFaiTQ-dXnOYg1CorVe3ey7qp5D8bcfdpJagiW393TFZdOwDbvGwbwwZA>
X-ME-Proxy-Cause: dmFkZTG4UQS/DVUAK5X00HSGpN6xmMu8uBi5bskMhLAP0oEuwAkNxTjLWFc3XzHZWIojDa
    s6HUbu4KlljgoIHpmjjTOx4CskWkaz7H+bLQyr6BFagYbQ5ilNbxpyk92OO/wSomoPYLSu
    alFr2PpG5Tgpfykgu2ThxJDFTikEpxo1DG0ZXxsvjS2CBtvS207bGrONdLVrlkZIpNIgZy
    Cys6AQnVD7k1LeiOWl8R1+zfKatmgbdACZjUwLulVROccyM2RRCINtUhMKfYPJuqXePvdH
    KEu67YHmszJuxP4JkxeKwBoZQB24kQIiPlGXynhOfDWu+wNDbKwex7TQYI+4bJDJ1+Z9Kv
    mxAA8RzQ7ay6y+WsDyCh0749nUMJHjutpz/uYHRyuyvzFeXSVfCRqtOSFD59kMpzjNxvHB
    auLWTsdK/mG1rmryINKYTezrVxxu/VXB97HFl9yBsTeYVjc+qTLgjd7kaTem6vQEAcwAG1
    lMStUDjJTdaDvrtdT4Wu3csq8jGvSkPkKXhhNKSDf/zoau7PF+y5KB2PF5oREXov+OVi7V
    64dKi0h/MLf5D7wsE1ZgxlcY0EJtYF6C3XdD6hEIvGAtkO554SPq0Ve4O3p7EVkKdoxtS9
    NaRUyWBfTJunetDnecaSNHIj7D7nFJmdwaW8w9bH3UT0IDMWQOChbjkWMXSg
X-ME-Proxy: <xmx:B8KFajfHMLKqyaUMxX9ZDud3UoQr6FObdqy7iBpk9Zpq2PdkzO36pw>
    <xmx:B8KFaqiVvKb72fzaCJxLABXDWLRmy1M1JYatMbQcfFv34p0YGXZg7Q>
    <xmx:B8KFau_vyuF5mdd-hdDU8hQDg7x5C5aQfdWf0RJiiGwS5ASo3gujrw>
    <xmx:B8KFaqkiCjIbrQgA7Ebo9cdzHdFMR8UOPJODPDZvuaLNlNZxm-15aQ>
    <xmx:CMKFamxuUAKuT2HAGrvLWLoETuYTE0NYUqjXOExsM5qBkrwp0c47e3Ls>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 19 Aug 2026 10:47:34 -0400 (EDT)
Date: Wed, 19 Aug 2026 15:47:33 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	ljs@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	baoquan.he@linux.dev, youngjun.park@lge.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] mm: include swap.h in swapops.h
Message-ID: <aoXB5vZf_vwB-FOT@thinkstation>
References: <20260818115026.656406-1-kirill@shutemov.name>
 <CAGsJ_4z_+Z_VppY3ravJxTgguK=m_pcYcbrogoOR2BdC6D-o7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4z_+Z_VppY3ravJxTgguK=m_pcYcbrogoOR2BdC6D-o7Q@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B2580100004
X-Stat-Signature: qe8rjm8gmpgg61eoaqfdwg5ixt7hfrxw
X-Rspam-User: 
X-HE-Tag: 1787150856-268672
X-HE-Meta: U2FsdGVkX19y4n0kofg6nxBK3syIewFtVKrFqo/orKS3hX3AXlMu4VhB7HKjvn7jVdascCMrwM3nzku27PC7Wppd7q47+j+5/jOsBL8Y7SUQjZFpVtMJ5B5LDOTGmKLpMU1LZ8QBTHdVsbpu3mcVaoJpsNaQ2DmtfRR1oUfQlK5vmNzz6QTLh2o9X49i7rpTOoQeUppwVej0MYVo2vv4juwdG48YrX86siBR+HKA09uCu8eH9+QcV0v1morYysyG/X40ezDnrLg0VdH0fWcAZS3trFJgUAqYUxjgIo6Lnv8RHl9rNCmvOCypr0nCukRek4Vd0+2l3Z7uy59+l+7MfiNsf26IWEQ2I58GCQmv2/ORA8hyfYeqrpkO750BJ06/zGXcGNbNtnjExZSJ/YM/Vtmwqa4vagqLvS4ZZOuz1cFmG47ekCeikgrsir1cqHbYu/jCskwbk2jLNISaCfNSbgsJs/bAaVKZevc/usEapxMRQ0BM2iGe+53rXSkLodS+wbyeAUxUJxoWL5teZyb1JUhBJq6yH0Ky0aQyVSIE78v+1K0sZ5D9FdPb7aLQpU8T1/mnQ9sA/ms1QUUvPzrDiUklwB0IAGOXrR2Enjy4VTjqi9ZmoiwNg/6IUa1hhAqO09WgaDggwj/oB0+iPhbCs/RzvJxCKAq5rMUPloDt//goAKhnL0YupTHLui/puVhdjCi8JgcwkJJLusfBpk91oyxtiIvwSG7nI/gCvewUUaPyhDIr/9N0kNaKG1kh5erZCnUNFsp9RPTrsz4h5+9LF+1tKQ3eP2GVGw15A9y66KVrghaWu4LbxxbK43SA6ZYVw8jeHpXW8Qqs90jJY9fPO+suaiqwuVnY/5th3hAvQPP3pKgkgvNq+slkmUXhR8XG2swg59XKauVDKwHm0L9ngEXmdEQ1EYAmp4Fzov0MLV3b7gqKXiJHWaXX//+/begDUXBlzjk2cLQfGXXgOZR
 Qkeyz44N
 jQRlgaIKSCu1Z8Rx9b3tbvyAAhpYtppwk2rtGH0LWmBobRTXqsjVDCTVCFDKCNoJIwXpT3uEPIyJVT4+k62RW82VUW1g8oeIFM8YgysE+2o0fa+hL775AOkua7bKMio2nrhUmOQnJB3wStwPx790WkCzinJy3lqlKY98cOrNbWTVktqQXALpMJV8RjT7hQuTT9yLibXzNOI0hPOv+OvDnVQ2HTKf8Mo2jJnAIECvZiEnJieuNWz6X2zcTT61/sLT18UnLvGgdqLh4tqUNxTjTDnjUt//e09mKikVgzAWwKshAcUctxFsBmSKej21TSzWkzrHDmRtRxA8IwrbxcuqoF6zRT8EyKubhhfY47nRSvowWF0NVwXuN7cl6qxT8PjT7u8nn3K2e5CGimYun0zc/J0W1hwOXwKmxtdkETILv5D2YGqyS2gXXAbidrPI1SYK6ZZIo4UkJf86VHGtdCAd9x3cAywYOH1WulDi3Qs5ljwbmvpPoJbQu5ETF0pF0Zm2Q8HiMO8QhYwM4Veg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 19, 2026 at 01:26:07PM +0800, Barry Song wrote:
> On Tue, Aug 18, 2026 at 7:50 PM Kiryl Shutsemau <kirill@shutemov.name> wrote:
> >
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> >
> > swapops.h uses MAX_SWAPFILES_SHIFT, SWP_MIGRATION_READ and SWP_PTE_MARKER,
> > all of which swap.h defines, but does not include swap.h.  It compiles only
> > where the translation unit pulled swap.h in first.  leafops.h includes
> > swapops.h on the line above swap.h, so a file whose include list reaches
> > leafops.h before swap.h gets:
> >
> >     In file included from include/linux/leafops.h:11:
> >     include/linux/swapops.h:88:21: error: use of undeclared
> >     identifier 'MAX_SWAPFILES_SHIFT'
> >
> > A header that uses a definition has to include the header that provides it.
> >
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes: https://lore.kernel.org/oe-kbuild-all/202608181757.mza9RRj7-lkp@intel.com/
> > Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> > ---
> 
> Basically, is this preparing for the patchset below?
> 
> https://lore.kernel.org/linux-mm/20260816224609.308019-1-kirill@shutemov.name/

My patchset just triggered inert bug.

> Reviewed-by: Barry Song <baohua@kernel.org>

Thanks!

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

