Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FB7DCA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 07:30:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09D986B0450; Sat, 16 Aug 2025 03:30:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04E4A6B0451; Sat, 16 Aug 2025 03:30:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECD1F6B0452; Sat, 16 Aug 2025 03:30:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DFC6D6B0450
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 03:30:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 72386160385
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:30:17 +0000 (UTC)
X-FDA: 83781797274.15.41657A7
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf23.hostedemail.com (Postfix) with ESMTP id BB65F140002
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:30:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xeNdiuBN;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755329415; a=rsa-sha256;
	cv=none;
	b=fuUy1EEJQUuaMetMLptcVxY/+cKtpk/SAZdETBm0H/jBrX/yj6YMAqR9H4Qh08EBUfiADB
	fXn7Mfgsa61NHvsdFZQGvMRhtNDOS+688jhnuVVYWRcRsf4T1FmC+3cLkortKRQCqxys6+
	98+oYMPJGoWbMJivo9Md6narTAvbI/M=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xeNdiuBN;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755329415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sS1FtSlT4bn4kDXSqYkA8BbpUFShaEGquX0GDZtdk9U=;
	b=uqofZSWQHQbZArUmzsK6y9OQ80su2X3DjLp9cVfCabKSfnBK3ZzI+aiA4CQsYzsF6A4jhq
	pgjYOj8XN38BWWcAv6lKSyozuiT4z517zLITmHql5V8UiIM2b0xp2uyvLjBlzHpSVEcXX3
	0HCD4UrFh+roiL8bHxe5xOqF5RUZUUU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 0F3845C499E;
	Sat, 16 Aug 2025 07:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A79C4CEEF;
	Sat, 16 Aug 2025 07:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755329414;
	bh=W1jPhQbOGvJw7bmvZPdhh7Lule+hHk8dgqDnHCJClug=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=xeNdiuBN7WIW7MvKM1RCruMKLATDNGUNtsrGckot72L2Sni5mUCFfbVMPdyjM8QU1
	 hyk43WlO47ZjnE4NMBBmtL7Bdggy3qnYRVagfBz7Q4RzMOKsw2m7XcA3WCTUNra3P3
	 AZjJBaAIvsvb8QILmsQSB0SHMocxrxeSLe1jj+xU=
Date: Sat, 16 Aug 2025 00:30:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, wang lian <lianux.mm@gmail.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand
 <david@redhat.com>, linux-mm@kvack.org, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev
 Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan
 <shuah@kernel.org>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 3/5] selftests/mm: reimplement is_backed_by_thp()
 with more precise check
Message-Id: <20250816003013.e12ecb8f2dc45e7f934ff281@linux-foundation.org>
In-Reply-To: <20250815023915.1394655-4-ziy@nvidia.com>
References: <20250815023915.1394655-1-ziy@nvidia.com>
	<20250815023915.1394655-4-ziy@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: BB65F140002
X-Stat-Signature: eiah1h8zew7oa36ssxfkjco7sdmeofje
X-HE-Tag: 1755329415-998525
X-HE-Meta: U2FsdGVkX18FKPl3/himu7b6NEMeLiAXJwy9gKj1M2sZ/S0L2YrufIy7JaytCcXAx1hdne1mqc1I/aSCIewfCdsFhDIoTGMmUwaZvMTDPfbrdLqDqoGHr7IQRm1c1aQwUNUEhVHTp/Rbz2SSzzXljT/8hT4xRfY1JGTqEdrdMpT56nrTdAoMkPFGGNaxshbCoUihbsWYo0lZHvfEZRQpWZDQYZFmo07xo6eExWy5E6jGvKTmvS4nzMOqV//GrAUZo6zcTxo9YqQ5C8hK5l8aMW90uNyIS7e04aob5K5Gzds3O/Bsoc9a0DLfwv66Caiji8549MXOspQPBycKVULCzDTtfefW0YONLRS49xpJG45OW373mH6vokbOk/IS78XzALd/7BxBngG75uxtjFNntXeiF20EeRwgWlkBl2/59flXy9VwqHvPldZsPzJ7J43q46U2MrFtIoufxz/mg0wSLDjVlNnTZ8TFE+7LDf0UPqxvz3fhx1fPdzrXklDY2tctV58HCM76n3bJezVUpA7M86B2yE5a4fLhAdLeDo2eur0ox+vZav4x/uFrJHi1d/Vr78Lu/AfxfFk3wzzacyDtb1+PMyNm0p7ESzxCIrrwXpQglf566o9pdxJIq/EARr4WOBK7eG7ERFSAxnS06e99l0kMpnO5FAPe5BDezYKhy0AvINYzL3KvCZOz3BLjTfoRAA2FC5ZA9FAmy9CYWxBUYCyrCvek7TGY2YPNweZR8VEdIMIAzYYMzu7la1p4+IoR9X73NJ+2c7858ZcrWrXJZ0qp5bveO4fQru+cnt1ZcAT2Oq3k2uVIKViyup/zMQ8QasctbqrXHSiEFbJJjLGw3QH3wOmQhbchFjFFpZPJD907yOOQAmRJviBtoxwLsRIp/vT4KgCMRYdvRnRy9CirQUMPGX8OazcLIdLCmKNGzHT+p5Y2J/12LKJsIh/ugAyihi9CfFuSoTsguJ6n5XC
 pyYfyMw/
 LDsIUbM9yQJ7DMrkyYSXFsMbTLNTITCFcpByzK+FsJJOWMSLgmvYiTA1xK71uRxbgtHlmCZ+HOMjDuKdmKRY1AFXcuuctzhDZcgVbk3MnAAoq1pyq4LOmps57wMYbV8cXNCGqMg+H3Xv4RYdmtIUwaLNN5JhzTEBrBvtrubuHFC64C6DNb9Yz6lwUx9UdJ+AOptDHNdMMCliSgwOJYUAYrICdG0Xhe7edECPWrbvOqBn4nJp++VxVNr08jkbxp8/UQQ6Wjom47LSBpekCpGEAmsW6czKwVAi1pRe51OYgdYSlyulsMI3lopYkfomRa3yimGN1lVsyfU1kHz+9UQa6x68lSraDXgJQxMzK4SUny2lHqz3uehTdNTDXmQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I hit a large reject.  Can you please redo against next mm-new?

Thanks.

