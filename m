Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 031F9D43369
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 03:46:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62FA96B0005; Thu, 11 Dec 2025 22:46:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E0406B0006; Thu, 11 Dec 2025 22:46:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CF216B0007; Thu, 11 Dec 2025 22:46:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35C466B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 22:46:19 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0065C1A0403
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 03:46:18 +0000 (UTC)
X-FDA: 84209431278.06.50826D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6BF8B40006
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 03:46:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="C4QZX/JD";
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765511177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yCl7lxaeUL7yy0JNSl41xrCAb4aCZBcyKphqll9vbX0=;
	b=m8YYWiK6iOfaERai8Ro+AZgeQzaSPw3G9Qz3o0dHQnTGkfqfdFwcsX0QsARFg2+0PspMFT
	o3ayA9V0wY3HMQ0Gt4dKZeYuXGLT8kqjE4bKV63hKSLnGAZXrjAlJ4ft9eqKE/dXwmxH2N
	Gzw7eI9Crgy02XByRI/C4//1thEbOPg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="C4QZX/JD";
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765511177; a=rsa-sha256;
	cv=none;
	b=0CfHAD6l1+7OJ7gJXky9ihQ8Z5drM058JTa4L3qA5hF1zpYY/nDTO2P5jOWubsQV5XTg0i
	ImgvIiTR7/5D6OFEom8tof+OlMe9D8D//uFVtRoDJ89kWsPODj1NBKsVdVjAg9j5fNK6+R
	mHT321RApM8lCkf/S6UAnC67n27wU/I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BA3A660122;
	Fri, 12 Dec 2025 03:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F894C4CEF1;
	Fri, 12 Dec 2025 03:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765511176;
	bh=qWErqwHAXMoJbr0ah1yv8tAp2YJDlDct0fUARVDvVi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C4QZX/JD1nZN7473nf5CYMKQ0CFajZXk8vZziiCmrLgU2wuvXn55tATlM/mJvmK1w
	 6CIFM0Yh/83i+ThQSdmg5FIsxBkfKvkHApjPaIRqZlOFDdKIt5xUvOWK1rLfW/5zty
	 eFtABNX2glTPZuwG7CVCEliHWQT7Zx+SMaPhWw7i3vq/qx8tVSzVaemxW0WSqc8xXQ
	 I30rOT8i4WFzx1/vZHX+cWQpXjrpqbK3C7nQoY/xfDzKbNOAajcnvEV36Bam4cbNIh
	 qSPA4pCkOjZUzEiLkyzGl0BHBizALqxRMCG0FVSv9MykJZpRUQZmvQZC78aZ4PNCmZ
	 cagh4AXKUb6nQ==
From: SeongJae Park <sj@kernel.org>
To: JaeJoon Jung <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: modified damon_call_control from static to kmalloc
Date: Thu, 11 Dec 2025 19:46:12 -0800
Message-ID: <20251212034613.41033-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHOvCC6ixeLQeTJANkAvQhRviLyr7=xNBs-_jeKEo+qF6E3qAg@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6BF8B40006
X-Stat-Signature: xe9rwbdqcrf4exya8dz5ctkeaqt6fben
X-Rspam-User: 
X-HE-Tag: 1765511177-880686
X-HE-Meta: U2FsdGVkX1/TCMSVTuJ5OYuq0ouZdR/vHtpCxG6HbryysGpoM25s9VQKuMZOEjqQP7whgaC+6G3jKETV67e5YZKuqHo7nghJwyadUlOVP5pZOmCU1Ddd+X4beSo+KjxP1A8cUqqE70xZ4JhNstnMMo0jp09bjbYgDfiyLc9mojGsBM+Ua7gCtLeXSZMHhXgUADpCB2BeZU+tYGS2xbIN+IHOlpdxAAUOa2u5w+Skqx4AADZ43UD6dDjPgq4lI2fdERXYtZUJpOXTQJ/Zo3D+OiVd8KuwMfpwphzK1ol2kHEzITbpLZW6+CS6fLOYUYQ6X4WcPbtUa1+tu/dgmt++YDFb54EWe8Mt5lw2P70ergTmGdtw10QYvdHnyXc9Ti1ZlabzIzy0vCFWX1K0K+UWbNWLvmvmlZkuhVfyKKj1YD//iDPV4gNvH1e3cOiqOQmhxtCMrX21lQWYfQB+ySudACUKk98qBDEb+rE3FCPt1S0cEdsJHn7bsR1U5TqnX4z/9o1LhXyRXy8/Ca9APwNzGblehxRmbJGgJXInanVrfMmu4xl4shIIsVEoBsMOJdOuavp4jBiV9MHK7ykCCUuNv5veththoGG9T2gQQFIfTPaCTSK3wsy4nN5P7oRNSnILWGRhX2BommOmhzyH94BrGOwyYATnktDpi8MHLwzdl26Q0BCEfWRhp7x0jGWUVwhEM1pzt20QefQ6NYJHRDU1P0HgMHhy5iMDrLk3p7zoQ9JE57zrtQFTrjQJn9TzNjOdeImm+CP3kkw6TmUZ+n7TMPgvQod91sH1Qu0itpW+qYAz3+wbZApYq1tXvXjipZkEA3jpuuco6HqPF09zxd67HS81uJbYnf7FUo1p1iELXZ+Ex85flOFIVcN9bvIzMPtPugsKoPvfF3VUU2WI8yl/WzuimR0AlfzzCjBlhua0ENClKbKAEZ0o9oEpZlPbE7efVg82jgMpMrqfuNcLUSt
 iCl4Y+AD
 aZ6wur5qxDzXbGkiV4jC+nyOAw/xy0KMRBeuB+oq/OXtcHPq/4ciQuyj87OsHaSStFXxrcrHGPvkyQu4K+DC3hdTONV26jgUiYMUwWyn7ti8kz0wC4fknNaN8sv8hbKOtoKoHXv8Sx/aZZL7e0EraS8p+b7b+01H1AhVmloaY6tIyP9znOIOB8MllQWgdcVuAOXMpc7+2dDNH4N+Ch7VFxRs5GYerySwnO0AWOkgwdH/a9FLY4FYA7E6JqYGyE/3Liiib8QyRTHXLsXOQeXPhHORwa/vDYT/4YeqrP7lrQk8GYU4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Dec 2025 17:13:09 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

> On Thu, 11 Dec 2025 at 16:54, SeongJae Park <sj@kernel.org> wrote:
> >
> > On Thu, 11 Dec 2025 16:38:46 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> >
> > > On Thu, 11 Dec 2025 at 15:04, SeongJae Park <sj@kernel.org> wrote:
> > [...]
> > > > Sounds good.  Would you mind sending a patch for that?
> > >
> > > Would you like me to send you the patch with only the comments corrected?
> >
> > I was just asking your preferrence, and seems you have no strong one.  I will
> > do that on my own unless you mind.
> 
> I have been argued the following so far:
> "I proposed unifying them into kmalloc()/kfree() methods and
> removing the dealloc_on_cancel."

Based on your previous email [1], I understand you argue this patch is better
to be merged as-is, though you agree it has the pros and the cons.  And
therefore you are letting me to make the final decision.

I was implicitly saying I show the cons more than the pros, so don't want to
merge this as is.  Sorry if it was too implicit.  Hope now my opinion is
clearly reached out to you.

I also suggested making the comment better, and you agreed it but I understand
you are not interested in making that change.  I will do it.

So, all is well and no more action from your side is required.

> I apologize for not being able to respond promptly and smoothly
> this week due to a busy my external lecture schedule.

No worry, take your time.

[1] https://lore.kernel.org/CAHOvCC6bJLf=LuBpm90n5poz8Sqhz9wjXtk5ypbPwkvhb1ptag@mail.gmail.com


Thanks,
SJ

[...]

