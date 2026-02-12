Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE377EE3698
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 15:23:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 218F56B0005; Thu, 12 Feb 2026 10:23:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C6F06B0089; Thu, 12 Feb 2026 10:23:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A9066B008A; Thu, 12 Feb 2026 10:23:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EDA3D6B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 10:23:21 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 686251B2F7D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 15:23:20 +0000 (UTC)
X-FDA: 84436173360.20.8BA23AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id AFC96C0004
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 15:23:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=wngCniLs;
	spf=pass (imf10.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770909798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xia0EUTLAwfvNV6z0o7rjaLmeBxyZx+b2OgjR9h/lAc=;
	b=IHDryS6/ZuWrWwda8euCG+L/vTdR7mQooGDMRN/D0DXao6BvAjd5mUOQnEddPNljc2w5wj
	PcZBp2i8sR6rOIU+eHUBuTzFgX1IyfS1XNGvkuqIS7Ds59kgXBHLbhTqKNbyuj0m4QA8Dn
	E2h3yd9LZR15CiH9A1q4QbcB7yDSxAQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=wngCniLs;
	spf=pass (imf10.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770909798; a=rsa-sha256;
	cv=none;
	b=AzL4tMrMItfqD1JUU3aez21LjEdZc6vyu2AVW+qpKyfYt86V95RDUKd3kuL6XZwWXs2XnJ
	uDb4gc0DlqqYTHDbFaImoABnHa3HrnIxRMw2r7U8QyK5jV5HzZGaETUV9VK1p+s2CprGLK
	YVbD02YcfCVZUSg+WXPCG6WDoR/o/9g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D0EF60051;
	Thu, 12 Feb 2026 15:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BFDAC4CEF7;
	Thu, 12 Feb 2026 15:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770909797;
	bh=CXREZTqBenKo9jtPZTzM+VTNbxYZim0gWfWTgptwF30=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wngCniLsYobfy+cnJ0iQ8hJvHAE59mq29LzSxEBhVQD6cI6RhSToLCotLXlve5lyC
	 8O9Cv1a38Xqxsewi18XZ0aua6LyV4dre6Smx82wZWl8uDMPY+BtIhiLNMp0LTdQ+lo
	 QrW8b4Sy7tngQXd9V3e/ck2hvS4+DiaRwSdmf39A=
Date: Thu, 12 Feb 2026 16:23:14 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Gabriele Paoloni <gpaoloni@redhat.com>
Cc: corbet@lwn.net, skhan@linuxfoundation.org, arnd@arndb.de,
	brendan.higgins@linux.dev, raemoar63@gmail.com,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com,
	acarminati@nvidia.com, linux-mm@kvack.org,
	safety-architecture@lists.elisa.tech, kstewart@linuxfoundation.org,
	chuckwolber@gmail.com
Subject: Re: [RFC PATCH v3 1/6] Documentation: extend the 'Function
 documentation' with expected behavior and constraints of use
Message-ID: <2026021207-hatchery-spore-2800@gregkh>
References: <20260212124923.222484-1-gpaoloni@redhat.com>
 <20260212124923.222484-2-gpaoloni@redhat.com>
 <2026021221-grading-clatter-b7bf@gregkh>
 <CA+wEVJaFX4AE5ruKLvgYZhmNsOabovLp=2LAaLUYe5B9r51qEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+wEVJaFX4AE5ruKLvgYZhmNsOabovLp=2LAaLUYe5B9r51qEA@mail.gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AFC96C0004
X-Stat-Signature: 8pi7nixk4h9zoj3ehyednocrfb5ihomq
X-Rspam-User: 
X-HE-Tag: 1770909798-114388
X-HE-Meta: U2FsdGVkX1+xxt4ggmaSUvop56TjVZ3/rqjXfRjPKU6uiGSNMrq43HT/U+fl5ircd0cQHmuUQQtE9WAkg6QlYGsLU/dAGE7alYsMICfeUtCNtvhcp1ehmYRK/LTm+Qr/PoAEGsaDSWUOuZUPWxVV/1vgYOZgV+qt+CGMa3MmfWLaNYrFbW1dQbEcVciOlhLW1x+kQh3jxXzhwR3vp4GVbck6bHJtqIi4MEjWwLxa7XxQ84fRluCU+ZpxdzKxD7M76TDrZ/ZpjRgZcH/J3HAY+yrDpwhSgPFBcsccwxlTIOcN+eGVUfZPGPUUVFRAu4uaN3BmSmiy6ms0ujnvtu+lCjfh7CkKS8taDJ4/xtWhvA5Sr+hlQtGrP5qfugu2hOU0/wWadRCs/v+SiDJ9gTF/4DnPzLSfQZdqHcYqu57qRQWsZCLrXz0u9UJcYh3oxhkII01jj3m074ckexX2OALslex/IoT8KsJ/IRgGHqseE0cw4Z71iiHehMjB+6w19eDkoCiDw1MT5qEU4uo4nlsAe6xZECK3K2E0tFthSFtlQXyfDg0W8QisX8oCWRfqd8nfASqWLAZS5RTZ1h5KH3FWBaW/ybU9tuOWknTfTRL6hC+NDoe4tn2q3mmbCOlm+UN1dRS/6ADZ9HaKLyRtuMU2GrTN9liThlvkQAC+JUuMEBs5KKQX+CjmPdumNORlzJKznIcI0KDfCcuq+1nKbwBlDnmtU+O2ybjP0w6P3IP2OMArE5YcWf/4lAcc8wW1QUDVazJpKEL2GMj1nt/HU6Yzo49EqYIq5+noIN5SeluO/AFQRzXE6NVvuscFD5bUUBMgvZFYpkGLhCGjr1CZZbRAha0YpAFb6IgDr87t3ElEvZUhxGqpwYECGUxlmBQvw8RiLLF1EeJeEjT0Y+N/6qaxnbrZOkvPDn+We/LJgJQ6SIQs2cXJn8/Ig8dUdlaYNCXixj+QSmFg6vJxMEPmDKm
 73hPTmPX
 n1h9cGCF20DSmzhSH1PUdPSG38lwkkxGk3FnxsS1KQ2JYKunV6AqeBvNfe6bOuwT6oQ70EJNbBCxYMG31rRSZAdJSO+Ab/7Hdt0HcezhIJ9LJcDPC3LF6bxzCs2EMI5P0zqmd5vP2f0OhfKPb0S3twBuRuArzfwQ0TZCQjPylm+o5j/5WsA64rCLItrSPjcGo20TIYoxy2nljxnRYfET0+AVAn9lwiwk32CbhB8Nl4xzpKs8Ixqd1ifCGQ3H/d/E0Rcu2OJ/7rCWSNANM00oBOMX5YxP4RW2L8Xr4CFJ0qBjj92yvku6vDQZ1h+0rKzxdUnRyUtaa5/9r9KLF+F331Gcye4Vk4HCRnMGwH6IlZKS8FN4kvEWkFYqp/Txyn0VpKnU1Nwo9BqACn0sNoQwklUib9yLRnqvlYyDjrVBuR0OdIUc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 03:00:01PM +0100, Gabriele Paoloni wrote:
> On Thu, Feb 12, 2026 at 1:59 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Feb 12, 2026 at 01:49:18PM +0100, Gabriele Paoloni wrote:
> > > Extend the longer description section of a function kernel-doc
> > > header with an itemised list of function's behaviors and
> > > constraints of use.
> > > These are useful to link and trace test cases (e.g. KUnit) to
> > > the different behavior IDs and define the constraints to be
> > > met by the function's caller.
> > >
> > > Signed-off-by: Gabriele Paoloni <gpaoloni@redhat.com>
> > > ---
> > >  Documentation/doc-guide/kernel-doc.rst | 19 +++++++++++++++++++
> > >  1 file changed, 19 insertions(+)
> > >
> > > diff --git a/Documentation/doc-guide/kernel-doc.rst b/Documentation/doc-guide/kernel-doc.rst
> > > index 8d2c09fb36e4..23e6c4b45b14 100644
> > > --- a/Documentation/doc-guide/kernel-doc.rst
> > > +++ b/Documentation/doc-guide/kernel-doc.rst
> > > @@ -83,6 +83,25 @@ The general format of a function and function-like macro kernel-doc comment is::
> > >     *
> > >     * The longer description may have multiple paragraphs.
> > >     *
> > > +   * When specifying testable code behaviour the longer description must contain
> > > +   * a paragraph formatted as follows:
> > > +   *
> > > +   * function_name behavior:
> > > +   * [ID1] - [expected behavior]
> > > +   *
> > > +   * [ID2] - [expected behavior]
> > > +   *
> > > +   * [...]
> > > +   *
> > > +   * [IDn] - [expected behavior]
> > > +   *
> > > +   * function_name constraints of use:
> > > +   * [ID1] - [constraint to be met by the caller]
> > > +   *
> > > +   * [ID2] - [constraint to be met by the caller]
> > > +   *
> > > +   * [IDn] - [constraint to be met by the caller]
> >
> > So the same "id" is used for a behavior, AND a constraint?
> 
> The idea is to have a specific behaviour or constraint of use
> identified by the tuple [function_name behavior][ID].
> So I think we could have a problem for duplicated symbols (but
> it is a sort of corner case...)

I am trying to say that you have ID1 listed in two places above.  So
that's not unique with a [function_name][ID] pair, where does the
"behavior" part come in?

What is now parsing these comments to ensure that they are unique, in
correct order, and are used elsewhere?  What is the text for such a
behavior and constraint?

Heck, what does a "constraint" mean?

> > And what defines an "id"?  I see in your example you use number.number,
> > but is that specified?
> 
> I thought that there is no need to specify an ID format as long as the ID is
> unique and referenced by the kunit tests testing the symbol.
> Basically I thought that in some cases it is easier to enumerate 1, 2, 3,
> whereas in others a, b, c can be used or even a mix 1a, 1b, 2a, 2b etc.
> So I wanted to leave such freedom to the programmer.

Ok, so be aware that people will then put whatever they want in there,
making it impossible for you to parse :(

> > And how is a id going to stay in sync across different files?  That
> > feels impossible to maintain for any length of time, and puts a burden
> > on the developer who wishes to add/remove a test or "id", AND a
> > maintainer who has to remember to go and look in multiple places for
> > such an id sync up.
> 
> Well given that the tested ids are defined by the tuples mentioned above,
> the relation between a kunit test and the tested tuples should be not
> ambiguous.

How do I "know" that there is a test that matches the tuple at all?
Your patch series proves this, it adds the tuple in one, and then the
test in another.  If you add another patch that adds another comment,
how do I as a maintainer know if this refers to an existing test, or a
new one somewhere else?

> Also I thought that, when writing a kunit test, the tester should know which
> behavior is being tested and hence it should be easy to define the tested
> tuples in the kunit header.
> So I do not see much of a burden, but maybe I am missing something here...

if there is no automatic way of linking a comment to a test, the ids
WILL get out of sync.  We have 20+ years of history for "simple" things
like enums and strings getting out of sync in the same exact file.
Whenever you are going to allow a free-form structure like this, and yet
expect a maintainer and developer to always know how to keep it in sync,
that's just an impossible task, please do not do that.

And let's go back to the root issue, why have an id at all?  Who
benefits from this?  Who requires it?  Who wants it?  Who will do the
work to add/maintain/update them all?

thanks,

greg k-h

