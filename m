Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C4EAD25931
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 09:40:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBD836B0088; Tue, 27 Jan 2026 04:40:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6ACF6B0089; Tue, 27 Jan 2026 04:40:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D69656B008A; Tue, 27 Jan 2026 04:40:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C40056B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 04:40:53 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 786F71A0ABE
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:40:53 +0000 (UTC)
X-FDA: 84377249586.20.340E945
Received: from mvsmtppost12.nm.naver.com (mvsmtppost12.nm.naver.com [61.247.196.223])
	by imf29.hostedemail.com (Postfix) with ESMTP id C7F45120002
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:40:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=naver.com header.s=s20171208 header.b=kyx1leyk;
	spf=pass (imf29.hostedemail.com: domain of s9430939@naver.com designates 61.247.196.223 as permitted sender) smtp.mailfrom=s9430939@naver.com;
	dmarc=pass (policy=none) header.from=naver.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769506851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4b3W+DvYzoP+sOvS3TKFFA4rdbGCYhj0Yuo9Qc93NsI=;
	b=hlQJyyj2Ocs1MMmTsmrmfVKfTEMcBrqX6BdVxOfLqYKxE2F/lTIbgDuMXp8PMlgq+5W5MZ
	a+9QSXdYsYZOPr4NkS4eP7qmaR0stLixCfTCI+IgMXi9Zs3gPOiQC70IGC4Lw4GZHtmEcs
	fcoP4xd+nPTZoJWFDmOqpExAJDM+Xxk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=naver.com header.s=s20171208 header.b=kyx1leyk;
	spf=pass (imf29.hostedemail.com: domain of s9430939@naver.com designates 61.247.196.223 as permitted sender) smtp.mailfrom=s9430939@naver.com;
	dmarc=pass (policy=none) header.from=naver.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769506851; a=rsa-sha256;
	cv=none;
	b=C/WNdjQ7CsGr7FMF6LJy2hejocXPXOqscFtNEouY4eRFEf7u1y5EW9YyEiGJXUwttnbsHf
	MqaoMeIe2tZmmqHiSjaU56GLZMUd4zURRJ8oME5fJuOzuEapRPVT2T92sqECUuZ6WOBZNb
	DXHEzxeZzczT9rns9zF8Ayymk1sBy1Q=
X-Originating-IP: 14.38.141.199
Received: from cvsendbo030.nm ([10.112.20.49])
  by mvsmtppost12.nm.naver.com with ESMTP id nHVmZcIcQv62NixzQPGsRQ
  for <linux-mm@kvack.org>;
  Tue, 27 Jan 2026 09:40:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1769506846; bh=ML+q55qoXSOPTyi44AcgK+slIpN+AUa4DpHF+hZ/ldg=;
	h=Date:From:To:Subject:Message-ID:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=kyx1leykCtQPjxmVG1tx6AXw6UhwsPEOo1AXDxbwI0izVBGWQz3g4EaIF4RJewXt6
	 70x5Is8rgI8C2cZ3SaU8wJGRAekfZTz3orq5rTp18m+Ni0riNEjlZiCHg6rCAlA2ZG
	 MT0WMP+JbQq/iBt/DsTbtVjqjcz9DwY6Ix0laOdBvUCtgH2rlwi6fscQ2zwN6zMtDn
	 4VA5muMNAaa6ZnQFKb876FqImF2/SctrX5Xjfovv20oDrMdkVy/nxkd+0X7zWwqH33
	 7prm9gpU64sYNofGKL/noTCkLdg+qqACcmxkybUmLKgQ6hUNhX35O3pDnaO/ZnpJBw
	 gMVk9BXRnTxYg==
X-Session-ID: lD8u+2tZQjam9MPaDL3jOA
X-Originating-IP: 14.38.141.199
X-Works-Send-Opt: LdYZjAIYjHmZaAKqKBmmKxbwKqpYkEljxBmwjAg=
X-Works-Smtp-Source: VqbXFAvrFqJZ+Hm9FAtd+6E=
Received: from JMW-Ubuntu ([14.38.141.199])
  by cvnsmtp010.nm.naver.com with ESMTP id lD8u+2tZQjam9MPaDL3jOA
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Tue, 27 Jan 2026 09:40:45 -0000
Date: Tue, 27 Jan 2026 18:40:44 +0900
From: Minu Jin <s9430939@naver.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, akpm@linux-foundation.org,
	david@kernel.org, kees@kernel.org, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] fork: clarify copy_mm() comment for kernel thread
Message-ID: <aXiIHEH7Yt53fXNI@JMW-Ubuntu>
References: <20260127055321.2400480-1-s9430939@naver.com>
 <d8d4dc93-78ab-47e5-8daf-36fd9468ed97@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8d4dc93-78ab-47e5-8daf-36fd9468ed97@lucifer.local>
X-Rspam-User: 
X-Rspamd-Queue-Id: C7F45120002
X-Rspamd-Server: rspam07
X-Stat-Signature: fqd3bapzibjd165kkkzc647iz8m8gkp3
X-HE-Tag: 1769506850-250224
X-HE-Meta: U2FsdGVkX19cPVBj/8BDPd2092ra1FwE1CQPeJJkkG9VJvwRVUbBq3AwX6st36n0C1pd8sJ2mJ9lpuCPO4ZPw9PoBo5IfYD0Cs51XOqBzc/YQUGt3mnr7PdL4ek8xAYP8a838hahnaZWJ8qOqdbAB6+cpiHwIuO+1NTaDh7qt24GqtpG2QMERDtDFzqGg594aMKKfNwBNhvMkLCIb2hmJAMEXI+u76QDZTZD70F0NjobiDksr9A6yr/yjP+tC+uiWAHQUeRqoGKkkhG/bk0KsV8W3gheH3JrNzS9eNnInMK9P4KAnNG6pLwAC9Oz2HPPwyjynsOT2a476RMmROEKEXEnSRoldKKs56qCIcGU+jcaR9/9ZWu8/EuRUrFBlxdlG5Rf+PiJtr123cnaY4T/mLvGNswCay9cxPBaNC9kVqlKUGnRuelLQyy7EU7wfaNwALM6NjWKqKv2Q5IHL1O79IH5+c+YiX09VI8CClSoe2/P5xWQHO4SkSY6zCpOuOdR5oqj5h5UC2LdgXwprUkNB0aqpdPnoUUCzHHb+OGjk/y0Lva6mHTLTvNmPSA/gfHTJVTSY+1CzDi758FpE9s5SN5khQbEo0aekAWoiBIZJGgXySFgeAiutmZqVsOg3J96mWd5NCDtnX6tmM1Os37Bwlk0RblP0qVBLbIEpsBUkOPIMF3ReCufpEQsf2bfRNJgpqwRnnwrRduGLUwwaYKTNy58zKW4IRl83/G74McwVpSKfNf9R1nu7vu2jeC9sgW9QT3KAXlFfv28AP6ACazzs7g5yhqI18MP0Rhkf3VskZYprsXfY/9JsLldtBFA0kxiobGyWw3H5IzyEYg6lvxIOdIMAkmzlaN83fJQOA4EFsJths/cnTht9sqckavzOKZj0WEICp1cc5TBsBzVmC/XYmuyBHroa7jJU2ydz11EgpKFHZDtUpSOHBy4/VMDeoMMU7isnPudQ6kpE2Z8UOK
 eSy1zBF/
 zPaCVOWSrfvCE4IUKB7+xRlGYhgsYrI4TFYtQ4882yb9e1B9YFexuvqcBO7V9L666DaxBvfxNxrfgfSPhgfA08kD3PVH3DhxO0rZLvUnut+cvAS/spk0OYpOKerdX8nXlbfJ0ercdAQoj4uEHXIWKUidBBE9OlTYoT0+NVxHNPLS2d+uqFdT1bqujKIYEDUCVn86Nffk24KN/t9L6qT+O+WHPMWoCk8EuYN2sUHHn5OFPF+e3L8RsRLO2N8xY0R2nYYaNV4JmKJ4hP/KICIYUyCGu+DYCm9dxxjI/pG+9Gj8+YfvTlVjpJ4c/3ueQCUM/1qB/x0X6dtK8+D2ALHt8HxLXaOcQQiSrJ/+fIJGU2CE8+DwgzUB00rdd27zaReef0gKXPGsldGFa3qV1hVvglcNwJ28Op4UMswfUTQTFBx4jOV+acuH+Q2581TPy4g5JraRIs5dfnRKgwmCkGHcno8QTMR/HMZ5BizCJn6D+jhgTO+PKuY1115Knejq+8LusiHU8kL9SoRtNmejpyVgTJsgEPdHbi5/YH/eBEwv4EOHJm1OaaB5YobPQvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.163421, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 09:25:26AM +0000, Lorenzo Stoakes wrote:
> On Tue, Jan 27, 2026 at 02:53:21PM +0900, Minu Jin wrote:
> > The existing comment is misleading:
> >
> >     1. "steal a active VM" suggests this code performs the active_mm
> >        borrowing, but the actual borrowing happens in context_switch()
> >        where 'next->active_mm = prev->active_mm' is assigned.
> >        This code simply returns 0 to skip mm copying for kernel threads.
> 
> Yeah but the comment as it stands implies that you are doing that elsewhere
> so I don't think this is a problem.
> 
> Referring to a specific other function in a comment unnecessarily makes
> bitrot easier.
> 
> >
> >     2. "active VM" is outdated terminology, the kernel uses "active_mm".
> 
> Well VM refers to the virtual address space so it's perfectly fine
> terminology.
> 
> >
> > Update the comment to accurately describe what this code does.
> 
> I hate to say it but this sort of enumerated list is very AI-like so if you
> are sending a patch that is AI-generated please do indicate that this is so
> (and put e.g. Co-Developed-by: <whatever>) if so.
> 
> >
> > Signed-off-by: Minu Jin <s9430939@naver.com>
> 
> Thanks for the patch but I honestly don't think this is all that
> misleading. This original comment is from 2005 and I don't think anybody's
> been all that confused by it in the meantime.
> 
> So I don't think we should take this.
> 
> Cheers, Lorenzo
> 

Hi Lorenzo,

Thanks for your feedback and historical context.
I understand your point about preserving the existing comment.

About 'AI-like' formatting:
I am not a native English speaker, 
so I used an AI tool to help structure and refine my English sentences
for better clarity.

However, the technical analysis and the logic in the patch 
were entirely my own findings from studying the code.

I'll keep your advice in mind regarding 'bitrot' and will focus
on more impactful technical issues in the future.

Thanks again for the review.

Minu Jin.

