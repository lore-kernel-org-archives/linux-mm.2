Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 152EDCCF9E3
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 09:58:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CC108E0142; Sat, 25 Oct 2025 05:58:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17CA78E0135; Sat, 25 Oct 2025 05:58:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B9ED8E0142; Sat, 25 Oct 2025 05:58:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E6B708E0135
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 05:58:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7926589717
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 09:58:28 +0000 (UTC)
X-FDA: 84036186696.22.058A5C7
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf07.hostedemail.com (Postfix) with ESMTP id 069FD40008
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 09:58:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=Q08AOXNr;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf07.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761386306; a=rsa-sha256;
	cv=none;
	b=hbmPgdkeghdwMHqfKZvmCZhh5JNK+hkYKMKydcMqjVMg+cYxGn1RUPTtxFDFryMlkf74Nc
	wGomblXZZjyqDXKZh0H1PaEV/QnrE8NQTnBFj595w+qn1w5YqKIIMApDfi4wZw9iKNCfq8
	UPhymEMQx/lPHhMe9IJtqEcqEJ0baGg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=Q08AOXNr;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf07.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761386306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ms6OfP7fnnzpCwdbYToJLw7bxMeGDjNJVbU9DiQwtVI=;
	b=PxRHuCLiDaOwKgkhPdgGYHKlUxZ/P3GFqxfZi0nhWiOPK7earXh8GuuLVMUOu7KWp4zPMD
	CY3znFFeX5xh6tJ4EH49cDjoZfRDUF2BmYXjg4xDrYAudc27LhQmP/Hw6N8NfKoUDYs4AU
	su1f7CrOnT9YAyf1IPQCpul37AxGjTQ=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4625140E01FA;
	Sat, 25 Oct 2025 09:58:22 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id cg6j5_G3VMKG; Sat, 25 Oct 2025 09:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1761386297; bh=Ms6OfP7fnnzpCwdbYToJLw7bxMeGDjNJVbU9DiQwtVI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q08AOXNrmI0dbWJn9pwr6BSQMn9Gj5/TVHljcN8YHbcvuD+VNTZRbqwL44BBvjVZr
	 uDc6PfQq6NipuOghVTnlFaX/RAvaXT3VI5iGphL5efzfi3wLXXYUw7gYs2plxRXfZH
	 In1Th1OjQzic6hFSn+qB6LuAl34Le0Q4Y0OLGxg4d/BikHHX6qTyq5byoBqvzTrMa3
	 5vxEBRuWO6nrk+gHIRjVeq5ndEqJS4pE6TGqZsWqLEe1GE41FIRupxCEeoNR3d2HcW
	 amMMjVwHAdUHhVeEnRjtTZbLdK6+PQWSz7WoI/AD5wC56JDv7O8C8EIykrnAEOaEMa
	 jrROfIb9JsMAQlIZIQC/YLFpnyIqCaCkK27wDMjZKy7l1L7b9vf8Y9QP72TAcnbW0s
	 uhDNewwmvUepZiPYFR7U/cypvdozm1R10BnRvPY3y1Fd1Julhawl8u5Tu6z3ziD9qu
	 9aohJHRmSqRwyh7+YjOAQ13nY+l50ZIsUCjRgb/lIPVsoEDEa5PicRQI1Vl+QXmDUR
	 IQeJnshJyT1d8x3bzTVz+jOP40CXW2NwqE2HeMDeQelEEr9dJtoPR3p9p39THROXFu
	 3lwQkxeWpS6cwbdlzpJSkrYdyN6WBQK1HB+sHX8DcegOZIciQwJNq090RfR949JAV6
	 eqKN1cBgm/zBdi36gQPiisQU=
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id E78F140E019F;
	Sat, 25 Oct 2025 09:57:49 +0000 (UTC)
Date: Sat, 25 Oct 2025 11:57:43 +0200
From: Borislav Petkov <bp@alien8.de>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andy Lutomirski <luto@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, peterz@infradead.org,
	dave.hansen@linux.intel.com, mingo@redhat.com, tglx@linutronix.de,
	akpm@linux-foundation.org, david@redhat.com, derkling@google.com,
	junaids@google.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, reijiw@google.com, rientjes@google.com,
	rppt@kernel.org, vbabka@suse.cz, x86@kernel.org,
	yosry.ahmed@linux.dev
Subject: Re: [PATCH 01/21] x86/mm/asi: Add
 CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
Message-ID: <20251025095743.GUaPyfF5YRbZxTYu9s@fat_crate.local>
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-1-2d861768041f@google.com>
 <20251024223746.GTaPv_uiyc0wd1fPjV@fat_crate.local>
 <DDQY0TEKY4MU.2MMSAEB8QQZ4S@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DDQY0TEKY4MU.2MMSAEB8QQZ4S@google.com>
X-Stat-Signature: deozi64qp3n7inqgsrzwy1q69w53haqw
X-Rspamd-Queue-Id: 069FD40008
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761386305-526109
X-HE-Meta: U2FsdGVkX1+S55tPN8jFzQVcOgzQhW73pb0NYPL46h6rqcj8eOIWsWh4YODdgede5J8K2NcjH4myO7Z75Hs8hr6lu9qJxElM/7nnafJItzM8PztE9aMm1N1zDRs4vN4A5H0erWILnqsRqJf4d6ZEM6E2J8PGZwGbKN+d+R62otYXiY2DaqcH8LvnbgT7uf3lmTsZX4QLKX+WBg18zj8wJIyHAkNZ3ki0m20TNlAxp2jD8uFEveY9tuCnt9XdRtVVZKzc6+uPqXhx/AczdFWvrlAI555xCLNB0iVuTclKsJzTLIwdM1n7aI7m14+oBb8dDy12y+05f8v0HPP6+iJl9u44FOsPuDoHBdGLTu/ThvmS4FSgEl79R1Ass+dBumfAH8vR7N3LlaZpjMQJX4viTjE/JEVlc8lRFZbLS1yjCh48Q70QMextNuRMKLHtaj0VzhnGTvHkNB7F4FdboJzTxF4voUWbluROrHPt04pe05WFURq4/kK1aqPmDbla/YXQvK/h0DDXqZM/fG60gPJMgznjf2nFvOmsl9NKVqiOyX31xoyYTth46+QZsV9i0ew6tZCr4MqG/wLXEQTeNTRNnzstHHC5WBIgSQkrKQiZuWnHH0KeP32DG4xynU2veHS/jK0LQV/DXdbavKDGy3GaEXrk9TEWVNjTpbTD+SrIZ07SaKuDvWt+qYaQjldq+cvLoYPlpwn3J+SjI0v27BUjq9DgANq98YvN3ALbvT0fKsOZes/6e9tkoZdQ+CtzSdFAZ0B4L34i+t5FguvmOzI3fmwutEE/qGTWoohZxgeeltntLmK0IJpksCPT+jnzl8QOZUQ0OawtnqhX3gTeb9jAXJ4Q/w4C8MPj4k0zVv3hvUWolawuTP1f6ItNQNGuYVhAPRFztep1JAAbm4tXkUch8eXCOUVGS0hywrbIUBLMOkcQKTPOX/VzxxZsrrXhmVoFPiqogVa4e5PLeL90qC2
 QJ3jgW2T
 NeDv5o09aYnTR5txXoW3VdUkrY5NN2Qmhe5bSmkU/+IfIfwnm/gPtx1r9Te8MhnkvVfb6hePzT6WeRIiCqUG5lVnZBTAtqGT/uNGDFTRiXS8CS0PKzajx9O+ZAP4+rWySHVnqxECcFnf3K89RbDzmIkNtsxQIJN3xx8/4QOK+0Q9zorD2J8kydYpNXzWNLAQMM89n2gE4Vb/PvAOmbUZ0H4dFv/OSlgyoaiSwVksjQXcqsU6O6JOUPRwsoyxjN7e+AfF8oY5OsxQLoxKOEPcXHm7MAg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 11:32:30PM +0000, Brendan Jackman wrote:
> Sure, CONFIG_ASI sounds great to me, if it sounds good to you :)

Meh, I'm just being practical. :)

> And yeah if someone doesn't know what ASI is, they probably don't know
> what ADDRESS_SPACE_ISOLATION is either to be honest. The Kconfig file
> has a nice place to document it.

Right.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

