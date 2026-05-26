Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6DE7CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 09:39:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF8326B008A; Tue, 26 May 2026 05:39:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACFDA6B008C; Tue, 26 May 2026 05:39:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E5EB6B0093; Tue, 26 May 2026 05:39:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8EC676B008A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 05:39:34 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3EEE71A02E9
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:39:34 +0000 (UTC)
X-FDA: 84809073468.13.C182643
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 20A7640006
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:39:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qoNEcAdf;
	spf=pass (imf17.hostedemail.com: domain of weilin.chang@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=weilin.chang@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779788372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v5VXP9slAmYUpjIt0IEowgDjvebOXXmY8Xwpz6lhtnU=;
	b=wi3qqrxKbUcPd4dF5QV8UCQYNxfRZc1jzvN78/3I+182NNJMLdc8d6qMoXrtusz91DtsUY
	KQx465b9s99yAeaHIn8IOspyObs2mOHIxqp1XeNLgnHeYk13RSUmCfBClp9MHbqqQTcBux
	PJnjDWVrdrUMAfH/4XKhY5pPUieMGqE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779788372; a=rsa-sha256;
	cv=none;
	b=o+T046i4xNx9PzJFrYXWF789Q2jXTBGJH7Wx47wOxkX4uiuQFv8IXuzzC5waApuU9SK9rJ
	eFVWXs+TuS8DIaNIpWgpKikA7Mj60OQAEN/oOlS5834x+vYs91fP6MvPbgfE/sT14o6vAT
	Bmt/qCLc01/pZ5/QU4HakLCKglMFYwU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qoNEcAdf;
	spf=pass (imf17.hostedemail.com: domain of weilin.chang@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=weilin.chang@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E7FFE16F3;
	Tue, 26 May 2026 02:39:25 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 89FF53F86F;
	Tue, 26 May 2026 02:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779788371; bh=oMmoMD+GjALPUvOfptwGTWbIMDRQTKkEmSqw2+XfJvc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qoNEcAdfIv6OxKiwWgg6Qodpo0AIVqevYc0ITRnZAVuHBGkLI45Yq0n51FQdVnUxw
	 /dsmasqhbW1eQwcvx3sjeHlUbewhgu3PlcuPlBOFrfUIySQqZfR4rEEJhaIrCtY3Ef
	 jX2igp5g1BVy3pANfLTkrmgkzVtcd50TqMTT1+eU=
Date: Tue, 26 May 2026 10:39:18 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: "Liam R. Howlett" <liam@infradead.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH 2/2] Documentation: maple_tree: Clarify behavior when
 using reserved values
Message-ID: <uspsobhmhxsuw6f6nwmug3jqcyrhhhhzcnt2gqlx2lxwzknc44@vvyqe5snqtjg>
References: <20260504165746.1422057-1-weilin.chang@arm.com>
 <20260504165746.1422057-3-weilin.chang@arm.com>
 <5qnwgdcxqat2zo5qe7qy63xm5awo5l4lkdkf4umbj3sl2ct5sj@v5c3szzdbbq3>
 <q2dtphja7i45kknjk3bs4hn2bpictyoaideyjfbdh4sz4pxllo@xtsyvo3eztdb>
 <kkunuk6hph3uwljo26qqgskczsodydsxvbadycube6n2rldjba@rz6of4335slj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <kkunuk6hph3uwljo26qqgskczsodydsxvbadycube6n2rldjba@rz6of4335slj>
X-Rspam-User: 
X-Rspamd-Queue-Id: 20A7640006
X-Stat-Signature: zepyr6w5cpanwoa98o83mn45rorqw8i5
X-Rspamd-Server: rspam06
X-HE-Tag: 1779788371-842819
X-HE-Meta: U2FsdGVkX18BcA32dwg0KywkFQe92v7VxT68AQqJ/WDWzM8n91yr57beqZGxyB/Z99QIUXaQCz3nfWjRF2IhEf9hbEZytjkWI85k6Kyj59PlGjfiew89iUIR+BwfxOucKF2EHJvtuKQjx37F8M/YNZIhPbn6e9Zg/vt/wCu9RvGblDdMsilVK2AB/6FpYiqVOTNJhygLo1/Lv6vNCCIj9Nlc5XbzLKr3nsQ3/SlF/nGwJrfSxkPHbUlw6PpMIfnkDk2+XN+TjrGGdMz9WUu+WMpyRANWhBCXp8Z8HN/1+9fxbN9k2IGzYSFg99+MRtjMSJ42+NfVUW2Kw+Y20oAyue1wPkZHUV/41bQ0cBxWAvUAQTEVwj98o4bMKjhTcnJ14EHz5N5KAK+BsQyxuzfCme1GXpEmO/GiKGvlNIE8P4yUR5YXessEYh60YOSjn3R+Ub9sLGv3jEo24fCKlVjHn9canJMXL5lkSCi19XKJYxQHW4FowHqIJhc1w5lv6vw/FVhtYJAoS325eRYuiK7MA/bDs805QBXO0XB1d2X7AAbJoRlZIte2NewThXAmka9rgmz8H6KhzHDEDaYUAqkiHwbVeAzE3g+/jOJV1ivQ50RdJ0SVXAcJ/KgUAO869t1n2jCWe6Y+jdVCM05xt9StHc1OVJ8nivxFMksjmDHoj77Ge4xD+ZXyuGQLhKBwDsJq7fHErS/ibjW4tC/EYPBFvmgVL/B511RX3sBBi1EP7tWfGTJhIhw12WFLLtzPkQ/46m4W95qVy2FuUdkCl6/D37X/b6kxQWUGvYUoTcLYjUdPzP4iZCO/bkaPYSkFVdEuv0qClqhMC208TdYxQhgfIxkR82p+QAFOQynFnnJKAucPklhAAx/a5Dh80cADjtKwwogNCmu0n8hpWpc5oI366RAAynWyG2Cw+5NtCH6NjOxH8VPaXMEUdLLtCpsteXYVv6kG1qn0v6WqoqpAeuV
 h+Pk7zhh
 qAvBxtc6NrqIyEYxkysu6HqOfcH2t8e0O8T+3JtfbehxscNHH0mQa+Hmy790jkElzWia6ejrxuX/2ys2wA2QDqpYow+qCSEXF8X4bZTRhTcaBc5FEoo3SGrKRFJdctpgfJER2q5jjTDH2fy7MxwhDghsJDeYpnAOuaGQTZHdqD8hFN+mGRKmAghzd5WvKYRe8qnCw2bAI5TcNzqsJ4r0jQdf+q6xIzny1QcpYYAPm3RFbv+ZTRKfLp0kRv0+jUrOCdfmv7jT2zacE4iQZRuUJIxsq9Aczhx7xc5Pp46hKhjL8oCD2ObXi0HQ8K0urAjL09ET55doQ/SoVRcI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 04:50:36PM -0400, Liam R. Howlett wrote:
> On 26/05/07 11:09PM, Wei-Lin Chang wrote:
> > On Thu, May 07, 2026 at 05:24:11AM +0200, Liam R. Howlett wrote:
> > > On 26/05/04 05:57PM, Wei-Lin Chang wrote:
> > > > It doesn't matter whether the normal or the advanced API is used if the
> > > > user uses xa_{mk, to}_value when storing and retrieving the values. Just
> > > > specify that the normal API blocks usages of reserved values while the
> > > > advanced API does not.
> > > 
> > > Your comment above is incorrect.
> > > 
> > > The normal API will filter out reserved values on return while the
> > > advanced API will return whatever is stored there regardless of the
> > > value.
> > > 
> > > Meaning, if you store a reserved value with the advanced API, it will
> > > not be returned by the normal API.
> > 
> > This is valuable information, thanks for explaining.
> 
> Hmm, maybe I answered too quickly here.  We filter out XA_ZERO_ENTRY on
> normal API searches, which is in the reserved range.
> 
> > However, I'm confused how this shows my comment incorrect?
> 
> It matters if you use the xa_(mk, to}_value since the top bit will be
> lost.  Re-reading your comment, you don't specifically say that though,
> you said 'if the user uses..', so I was confused by your wording of what
> you were saying.

Ah, sorry for not being clear.

> 
> > 
> > From the original doc:
> > 
> > <quote>
> > If the user needs to use a reserved value, then the user can convert the
> > value when using the :ref:`maple-tree-advanced-api`, but are blocked by
> > the normal API.
> > </quote>
> > 
> > To me this is conveying the following points:
> > 
> > 1. User can convert the value with xa_{mk, to}_value() when using the
> >    advanced API if reserved values are being stored. This works because
> >    those functions transform the reserved values into non-reserved ones.
> > 2. User can not use reserved values with or without xa_{mk, to}_value()
> >    with the normal API.
> > 3. What happens when reserved values are stored is not clearly stated,
> >    but the normal API will block it.
> > 
> > In my understanding 2. is incorrect because if xa_{mk, to}_value() are
> > deployed, it doesn't matter whether the normal or advanced API is used,
> > they both work since the values stored aren't reserved.
> > 
> > Please do you mind pointing out what I am getting wrong here?
> 
> I think you are missing the part where the top bit may be lost?
> 
> I also don't think the reserved values will matter if you use the
> advanced API exclusively.  You would have to filter the special cases or
> whatever you want - that is, if you mix the interfaces then you may see
> odd behaviour in regards to the special cases in the normal API while
> the advanced API would return the reserved items and need to be filtered
> at a higher level than the maple tree code.

I see.

> 
> > 
> > I was genuinely confused when I was reading the doc and trying to use
> > this data structure.
> 
> Then we need to rework the wording somehow.  Thanks.
> 
> > 
> > > 
> > > > 
> > > > Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> > > > ---
> > > >  Documentation/core-api/maple_tree.rst | 6 +++---
> > > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/Documentation/core-api/maple_tree.rst b/Documentation/core-api/maple_tree.rst
> > > > index 87020a30ba69..e5ccafb84804 100644
> > > > --- a/Documentation/core-api/maple_tree.rst
> > > > +++ b/Documentation/core-api/maple_tree.rst
> > > > @@ -30,9 +30,9 @@ Tree reserves values with the bottom two bits set to '10' which are below 4096
> > > >  (ie 2, 6, 10 .. 4094) for internal use.  If the entries may use reserved
> > > >  entries then the users can convert the entries using xa_mk_value() and convert
> > > >  them back by calling xa_to_value().  Note that xa_{mk, to}_value() bit shifts
> > > > -the given data, so the top bit will be lost.  If the user needs to use a
> > > > -reserved value, then the user can convert the value when using the
> > > > -:ref:`maple-tree-advanced-api`, but are blocked by the normal API.
> > > > +the given data, so the top bit will be lost.  Usage of reserved values is
> > > > +blocked by the normal API, and will cause undefined behavior if used with the
> > > > +:ref:`maple-tree-advanced-api`.
> > > 
> > > Which behaviour is undefined?
> > 
> > I originally thought storing reserved values could break the tree
> > because of its internal use (see 3. above).
> 
> You can't break the tree by storing reserved values.  The normal API
> will outright not allow storing it while the advanced API will store and
> return it.
> 
> The issue comes from when you mix and match - if you store a reserved
> value using the advanced api and then iterate through with the normal
> api, some values may be lost.  Today, that's XA_ZERO_ENTRY only, but we
> reserve the right to change that if it is necessary for some tree
> version.
> 
> Does that make sense?

Yes! Thanks for taking the time to explain.

Thanks,
Wei-Lin Chang

> 
> Thanks,
> Liam

