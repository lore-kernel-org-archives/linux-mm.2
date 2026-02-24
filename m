Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6445CE9B248
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 09:53:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 813606B0088; Tue, 24 Feb 2026 04:53:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C0D66B0089; Tue, 24 Feb 2026 04:53:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CCBF6B008A; Tue, 24 Feb 2026 04:53:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 57BC86B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 04:53:17 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E1548B9ACF
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:53:16 +0000 (UTC)
X-FDA: 84478887192.06.EFC11F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3DAB4A000C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:53:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PazVMNIV;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771926795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dqLOm0PM7kcvpjftBJlRGEhwi4F/wqsNJqUoHigpCYU=;
	b=G4wPKYpaeG/1nsqMXzZpGb7HnFv5PPlHLUglR5wuDWtLDdE8xN1f7VTTmcTPs3q3SAt2XA
	SjAWfCUcw5DiCWp2fPcHEFxM8+O1yN0GCvp/+Lcj69Wy+d26xae48RUwGYFi63CUUU9Oxc
	7/FXF3Wgx8K0xRFqDzAI/wGA6yov9QQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PazVMNIV;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771926795; a=rsa-sha256;
	cv=none;
	b=GcnG8dPmvZl8LhOhr3DpZHN9yoS6z7CJo1OCZeeDMVusuazwt2rTdCHU5Kd1FjHQXU5zNN
	cjToTOumQ9BFe15Mq0+xWm844vHSYE4RqhyBPVBJJD1r6EuGKqJxWXJmNUCIS0dX5kGGWx
	Lhh7LX1rjTkGAHzniNCD9APWIT9ex0M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3440040BCA;
	Tue, 24 Feb 2026 09:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02DEC116D0;
	Tue, 24 Feb 2026 09:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771926794;
	bh=dqLOm0PM7kcvpjftBJlRGEhwi4F/wqsNJqUoHigpCYU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PazVMNIVrnDgSPiJ3FUli5BCxqck3xy49vEaki781IWSysnCstNXLDJHfT2CY7mxz
	 6UZAKfjuBBy6v9NZDDMFZyz6nezomxLaLhOCC4hz+BReH7i7oDebgBVXanCgikIBbC
	 fMYYI6uQlNm7M47ehvrcFq7UfeTFgHPXO3k85TdYP1L3EumeOzBUuUjyo1t7414yc5
	 /aJ7ym+RPxCD+eD8K65j0IFpc9Mv/JCyyA61V7T0jRgGkvPV0eA9t/ifE7Oz4ItytR
	 kK+aUQiaItrgLsWnb1lSuMLdVNFUWM+nel9DKT9ya/IJ8v88xxH1Yo70IKbMsIk7t7
	 1TCDPuCqcTUuA==
Date: Tue, 24 Feb 2026 10:53:09 +0100
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-nvme@lists.infradead.org, bpf@vger.kernel.org, lwn@lwn.net
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: LSF/MM/BPF: 2026: Call for Proposals
Message-ID: <20260224-sangen-aufatmen-06ba16719f33@brauner>
References: <20260110-lsfmm-2026-cfp-ae970765d60e@brauner>
 <20260119-bagger-desaster-e11c27458c49@brauner>
 <20260129-beidseitig-unwohl-9ae543e9f9f5@brauner>
 <20260216-ruhelosigkeit-umlegen-548e2a107686@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260216-ruhelosigkeit-umlegen-548e2a107686@brauner>
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DAB4A000C
X-Rspamd-Server: rspam02
X-Stat-Signature: qmc57grhqk7xyc1unhysxo5q84ns7sqp
X-HE-Tag: 1771926795-352579
X-HE-Meta: U2FsdGVkX1++K3TwJN4xvNr/TOsDlGs/InOvv2f76KcB/3SEpkeruQewf8RD6mfZSaEYWe+2B4Lgw3xJguZfDYl9/n20RzQqhjURXV8uVf7vuzmgt6wDosoRRxPNeJ+UOV3Nj4U1JfKMORXw4B73FXUmxJT7AdqtIq1H8mO8vQVaLgXNi5ZP/v33ArQD4pzBzqcMCB5dsVSdloeddHa94CA3Pnf+Jgj3GjXNsJ0fkdFvdbNQ1xNEIEQcR5bgIjHsqly5XbVZ03ugbID9dJsTxaheEy+uioembSYHDglklJHH/DXYVMcWXeH1OWOhWCBj0aXsaQ/C+LR6bEooh7gtcZ9kN59z5eFQ5yD7YI9uhbV74XM02z82d1P6u1o1qS3vvfF067V5+Pd6ixnCbCtD94UNHULVJ5IdvojgMg4Yee+9BsT29yZGzLd1OTg/JNgg38TkfkqDv+Fnrbf6bD839tBqfmllk2Kcki6lQAHJEYkhQBafYt66ZN1rTD77MZ/n8TXGJjgRYVq4VUwEJjHkdm6tKp60JTziltt0Xh5uTexYmy7VEm1R41k3tEzih0Wipa4SDTZMf5VtCv3xsdiCy2pIjFhMRqdtn6rKub0fQBNepXdjU9aSoQJKVzCM9wdFyrvP1jCWcVro/knHe+I5hKxthkY2QbO2xXXcwxW7BfgHLXaxGYb/CAJZ80s6226L+EYSnatQuOS7jQp8r0zL1mEbcrmVv423hlui40iwPdLGHFgGYx3ybT0nBy3G69KL8vRcuco/f49O+zbwbtkR0CKuJPTdaw6ZkPsHCQMJmZxbI3Ca21gO3RqZnslHBCZ9Ui4nLhBOqhZmiJSJfWJke6ZBMKDuxqlPTmcQ+7n2iIRneL3mIK7x9HyDtVOBzfoZkunjK9HjsVFMW5r7JICvBgpu4vCpfvMU0wfNerVr39TZSBNK1djZYIXZp2O8liO5VKEphwUUYEfMk8StQWD
 5JCaKBKw
 k+fbcDds8dkCPQ4QP23Wa+v0JVESoDCYbNADjh8XcnPMMnb9cHMI9oHA6HnZ8b+KW68M3VMMTOROiHFiCfomd4hPZS2FsLUgqk1L1Izg5z4um4UqRJzmHvOoqG66zM+7dJAOf2Uar5Lg2PGlmsH9B1huwgz2N5rVoOvlhz8i/HZTK+xDb+pYx8fPlJnaKkBskxGKl3mWPlLs+ScAa6w3v+mg+5OqocLNxXOoTSeN014bguHSN+jzTddZKn0GxIcT/fYz5Irvd5BA66J9ksf+0oJZkRqHiyM4qGfdgjH2OpajnHOY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000006, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Don't forget to pester^wask^wremind your respective organizations to
> sponsor LSF/MM/BPF 2026! If it helps, you can tell them that we're
> considering renaming it LSF/MM/BPF/AI.

I have just looked at the sponsorship site for LSF/MM/BPF/AI again and
we all really need to go out and go steal some of that AI funding money
and funnel it into one of the conferences that really drives development
of the operating system that drives the compute for all of this.

Please go and remind your organizations to sponsor. They should know how
to get in touch with the Linux Foundation. Just going by the sponsorship
page we're missing a bunch of large organizations that we would
appreciate if they decided to pitch in. :)

Christian

