Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E038FB3CF5
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 10:15:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F27296B00A5; Mon, 30 Mar 2026 06:15:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED8166B00A9; Mon, 30 Mar 2026 06:15:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DED866B00B5; Mon, 30 Mar 2026 06:15:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C90906B00A5
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:15:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 95DE7140644
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:15:09 +0000 (UTC)
X-FDA: 84602321538.13.0075686
Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	by imf24.hostedemail.com (Postfix) with ESMTP id 60F9A180009
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:15:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=LbTb25hB;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	spf=pass (imf24.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774865707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VFMJ46N9qMdCvcsjoGJqP/bweEV5DGEGreIBFziMe8k=;
	b=TRsHMoXTp10O2Ph8I+N//Mlz2PjAKb9FqASsbQOtIrLdM7ev9xPW7ag0ZW276PTQO8jW7y
	XV834HVx2McGytOVtXlViRxL9AQIIdUTIKWCCatwKWfv3KlMA/WmELbLLnmIrvRQSJKiEP
	lNFVVwlD1a9aCjZE2wUcGC3DVG1SZ1Q=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774865707; a=rsa-sha256;
	cv=pass;
	b=4qMdFkPEmDziOXHwMwZ4iJ8A66w3QxJ/8QU2/R0nxFDuLF2zqj/k+PKcXqvTPQo6qPDkKj
	sExp7mHRDkUaEVCY7QUzCqVLVUjTvxfErSXqKMnfGSBHytQ7q2GiE2BmtAWT6c2gQx47qG
	GmBswTYxeIj3nxEU9FYkMVhkCJ/pj3Q=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=LbTb25hB;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	spf=pass (imf24.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=1; a=rsa-sha256; t=1774865691; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=BqBNPlsbzpkZ+nAmQue2nRCOWhYiEPqo7AWEzt5CvcaDmEdA9uNaeqyrNf4VU+o3WJ7+BwKWB8wiKPSqhKtfwEHXxupP0qJGmSm84MYPq3cd5E5EFL5yLtQ29/H0odCUL7T4IsIm8lGnMShijCzH8s9Ae8xXqi1Sxhf8CyMg6kE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774865691; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=VFMJ46N9qMdCvcsjoGJqP/bweEV5DGEGreIBFziMe8k=; 
	b=CV2gAapZAm2PUzu9fJF5VwFJi6zo2YJcBvN/sNok7fvgYxoHzszCVXqMnfrP7V6Z5WlfoR2/VDzRX0s9Bkg5uLXxQ8QhkQ11JsKu6BpUXi1h+D0+aJ62lI4mJrXGA41x6sX+8lvp+J+p7ASK3WsDRdZhWmnkl+WasP+cc2Bah5I=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774865691;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=VFMJ46N9qMdCvcsjoGJqP/bweEV5DGEGreIBFziMe8k=;
	b=LbTb25hBZBzpC8Z5NKK0i433O5MjyarWBNGLh7xmSmMPfdrIlbw8fKdN+RJ1G+dM
	W6veJs4XGnVfxhWAnjyPbdpqmsn8CQ52Qhx3RYDHcNF2v0AM/H22G6VMulNp8vRcZtw
	de1+BwDrIhXgk+92kQHN2VjPe+uOHkiE+0dVWBrQ=
Received: from mail.zoho.com by mx.zoho.eu
	with SMTP id 1774865691675946.9053187433396; Mon, 30 Mar 2026 12:14:51 +0200 (CEST)
Received: from mail.zoho.eu by mx.zoho.eu
	with SMTP id 1774865691288564.2940483954262; Mon, 30 Mar 2026 12:14:51 +0200 (CEST)
Date: Mon, 30 Mar 2026 11:14:51 +0100
From: Herbert <objecting@objecting.org>
To: <david@kernel.org>
Cc: <krzk@kernel.org>, <ljs@kernel.org>, <hlcj1234567@gmail.com>,
	<sj@kernel.org>, <akpm@linux-foundation.org>,
	<damon@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<kees@kernel.org>, <gregkh@linuxfoundation.org>,
	<brauner@kernel.org>
Message-ID: <19d3e3d3297.190bc89f62053.5899613485100180781@objecting.org>
In-Reply-To: <25688dbc-cd11-4137-bad4-a215198feee6@kernel.org>
References: <20260326072737.341964-1-objecting@objecting.org>
 <cbd0aafa-bd45-4f4d-a2dd-440473657dba@lucifer.local>
 <b2cdda38-1007-41a7-a992-de953a088a08@kernel.org>
 <ae7dc7de-966e-4e04-bb55-318d97c61909@lucifer.local>
 <a9f267d5-b0a3-4118-a1c2-5caa8a3b638d@kernel.org>
 <14366e29-4ee2-490e-8e4a-0c5cace1f313@lucifer.local>
 <04B79050-4353-4FD2-A596-1474BDB94B3F@objecting.org>
 <b263a722-e9b8-4a43-a075-46e4a753871d@kernel.org>
 <043CED5F-7014-4776-824E-07E027B7BDC3@objecting.org>
 <cea99016-5407-4392-9b7d-2e6a994f550f@lucifer.local>
 <E1A667AB-DCE4-4034-A36B-DAA458780A81@objecting.org>
 <e5d45f3c-4f46-40d1-bb7a-0a2f930fd7ae@kernel.org>
 <82256A72-42FD-475E-935C-629964FA80E7@objecting.org>
 <11429699-81b4-4c1e-b247-480136fd1faf@kernel.org>
 <6deb290e-b168-4de2-95f8-fc784ed31c27@kernel.org> <25688dbc-cd11-4137-bad4-a215198feee6@kernel.org>
Subject: Re: [PATCH] mm/damon: introduce DAMON-based NUMA memory tiering
 module
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Normal
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Rspamd-Queue-Id: 60F9A180009
X-Stat-Signature: xaiy76jbeg7preg664bk6bb1jta74gu4
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774865707-383325
X-HE-Meta: U2FsdGVkX1+HaJi3qQXRp3NX7ghqNsHfMAWJTTtt79Js6HCFdwlHOEiv0RaAoEEnxcGMFNgrHzO7EJwI9BrKISVQeRBZiKXUqZpqhxSeGs7te1JaaxVbXgN3LirYoQloCjRn5DsGGEPO4vr+3n9jrQvYy5EweeSNS/HACw+ah6aoY8m9TtuUiR0YmXDIhny049HBmkcEOVK2sO4KW6cGnT2iGt0Xb/ufrWEUKevAu5MGuMrtHaQFDPD0GA0ToGCqCc09GG1UmUEt6VT6vXXE7/StRSAGOUeanuhuoMZ3RB7JYAutGh60U4+qrS0X5Ga0JW4bEG9ooWtHBeVvFDzYuSZqF983aBOCTB3i5JuAijBvGi+5u57tM14Ba8wuYrxOtv3j8lzc+Pfeur+j4+9TymCBy278P/oRASqtLii/Ouf5zlqtPr4DRDHxhTjJVFZTwgQY9lt+dtrXmDlkXlxJgvm7k9MlvUBaS5PlawjnVpAcTvXV9+N5iFy+riO9zDTQgEe1UNON+xgOu/RJCBuB8Nc3KMgMrYQM58Bdp0uE6JnKkEs8FxybFJ4b1bT0GJMm1fvK8qVDYquBbFhg6TE4R6tpzU4JZLNP/UBcwIEac8fv3gWn7DJtuxm4/fsnlRFsEGujy0SKKKqNxHWx5zCfEzIQGkApqWHOLIwudwJWuQIex/Q9P2Se2fHMG6Mncam8GmCx0KingVd6+WYQIQmJHLW90bFjA/+sc9xcuIedwIOg15oyhWOwNvJGVcF0gF6hbC/ayTnOgnMOdvID5hQyX0ZPEvD6VzE5bW+myAvaobOmFEFWJIhLI/3Dnum833KgFwMRH+TZ1FdfajoseRVrkjBI13/ZpJn3B4spXsmYqr1p+Ulo/IOLtkLBdnE53M+lk+b/wMHVtyKzeDYveGr6wsdrPkqnGs0CcHIndkLbMb9KsJa6d4mg+wYPqfatmJLMhVPqPYN7gjjoP2ejgoa
 rV7YOhAb
 n+BZNPKKDsRA6zZkiWZ3LyF3cmLxepo+LfTbndXrjrZLGnIyO0/0Oddk+B+wUEL2leJpLir2eZ/aOHNG4ArcqiAP79IsGqZTYlyOmKLa3PrJD6wXHU1MTwkEG0+FxfoaBp6fWAg6Cls93Bvk9KmalWXquQRZxhy1DTuebotxQNCqf5hZaXRa/b7m1xisCyqmiJx4BsmIRLjpUBzV3xDMnCKkgf6zqahdAPVe79wbtahGBk1rzwbh2lvtI+mUZJgf4ugQYol2An7ogUBXMDmL4JmTnNlSoPaCJIJwMgUrcpWOUpuOKGsPDp1h+iZ3wWoIRpP0u7vn75Ig+XuqmX7ePh1Q/dPNJZPQETilPET+wTXeXMZfPy8itOO/W9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>









---- On Mon, 30 Mar 2026 09:16:44 +0100 david@kernel.org wrote ----


> On 3/30/26 09:50, Krzysztof Kozlowski wrote:
> > On 30/03/2026 08:27, David Hildenbrand (Arm) wrote:
> >> On 3/27/26 16:22, Josh Law wrote:
> >>>
> >>>
> >>>
> >>>
> >>> Hello david, thanks for being polite about this whole thing!
> >>>
> >>>
> >>> so, you are talking to a real human, i promise you that now
> >>
> >> That's exactly, what I would say if I were a bot ;)
> >>
> >> As a first step, fix the line wrapping. The following document was
> >> helpful to me in the past:
> >>
> >> =C2=A0=C2=A0=C2=A0=C2=A0Documentation/process/email-clients.rst
> >
> > Yeah, good luck. Several people asked for that already, like 10 or 20
> > times. Andrew asked that a few times.
> >
> > And yesterday we got another sloppy posting, so that would be it for
> > having some time off to learn things and take slowly. 3 days after this
> > AI slop which does not even build.
>
> Bot confirmed, I guess :)
> --
> Cheers,
>
> David








? That was me learning the ropes, by making a patch to the QCOM subsystem


and it was a genuinely "ok" patch.


May you please tell me what I did wrong here.




V/R




Josh Law


