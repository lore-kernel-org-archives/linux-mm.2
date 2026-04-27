Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91096FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 17:37:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0FF26B0098; Mon, 27 Apr 2026 13:37:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC0976B0099; Mon, 27 Apr 2026 13:37:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD6DF6B009D; Mon, 27 Apr 2026 13:37:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ABAF26B0098
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:37:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3B6B51601D7
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:37:05 +0000 (UTC)
X-FDA: 84705041610.08.02BF977
Received: from out203-205-221-233.mail.qq.com (out203-205-221-233.mail.qq.com [203.205.221.233])
	by imf07.hostedemail.com (Postfix) with ESMTP id D01CA40006
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:37:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=WSzzdu5t;
	spf=pass (imf07.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.233 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777311423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PP94l61ktUAdCfnTosXBLrQQI5dFNrQT1AgczBpp/Vo=;
	b=M5N2tKzunfpfFWd/bxZA/j+qBdjgx/jNyXXwlMsOQ1aWepfO1yIHvE2dqnGwG8mRwwa7q6
	7M7JErICrJAG5YZgUTfZqt8lS2qyQcn7NT8f2xWxTzorH9ECCzQlV5WO4yOh1UQBULtSE6
	6+9eCcBD8RB4oAg2vqa0z7r6ydJD7F0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777311423; a=rsa-sha256;
	cv=none;
	b=C63n5kmWTI4g/YItNquzZXLM22PREkkFVY+b4vMrKzAVDN0r70ksfWDtHCWR2rdn624tGt
	3dJe0OnywWFjb8hxhV0HIQJqGj91KlBCzc6z5xZlcV324/ZvjSj868joYgl3eH13gGHXa9
	7zXYrzARxl2BhIj3pVVwa5sh015UAxc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=WSzzdu5t;
	spf=pass (imf07.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.233 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1777311419; bh=PP94l61ktUAdCfnTosXBLrQQI5dFNrQT1AgczBpp/Vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WSzzdu5tPrw3odt4Qk0QOT8gjWl2yp0+j2RUklpezwHq7WPagHzKKZoivipyuW28h
	 7AFhMvxtbeZxxwEgq16zg4igTQPpp9AfvcInY6H4ioe+McrMIWK1JyPh1LBPnxIH0l
	 WGsq/xvvVXqEVMbjQDUaNt0+walWfeN4g/eek8rA=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrszc56-0.qq.com (NewEsmtp) with SMTP
	id 9391448C; Tue, 28 Apr 2026 01:36:57 +0800
X-QQ-mid: xmsmtpt1777311417t96kki4yo
Message-ID: <tencent_0714B5E66F3D7447C26FC82CA0B8E29E3F09@qq.com>
X-QQ-XMAILINFO: NT7uTz3cNku2cexzM5GuVauNym8iEH5o3rHHWZRmDHTS86RLpSLvm9SfnpgZHc
	 H8VF6tu2VrGeKVOsYVATZQwATwq1P796Wi82RyOZHt4lT1hJ3JVhFoCMDGGlpo/4EvUj84WrAP8R
	 eV4LvnIQy7d2Zt2ccxeWQKFzD7WHtgsVj4EC3XysgjR3f2C8atES3t7Nb3/WtkZpAOMHgu86x3aO
	 0S3dXQBblmFxGGQ/CU5/igWK+a+PiebcZuSGxqncSo/bFFyJfjdUjiHRdaYZnL3SFZKLcc8/2k1U
	 ogPj/wbCQmPiQbiidvplqxdu6SyXmJH4SXN+Euffm2rriSs5ftqPMETSNCNt+ASoIQ01vodaPpB3
	 3sSkLKnH8OtP0WQW3BjufnBboNdIVZISjjYG2x30QfptyrzEL4WQlP6bmb5mcUnjDhU+VboFPRyb
	 MQPrIb92oOWv55d+BrfNeNvU6G8qaZM1xcXFmKTUsEI0rVaiQwoOlpwu/Lqh2c8vxnWBzwyiaRFG
	 S4oiWxB3ZIDD5qw/3YCzoVl5PC5w1DwnxZu8OwEeiZZ2QkIyDtgltnBrIulUXIYrbAKgialDoyeH
	 09Lnfm7cprRnqgDjMZaFgRdwMbooap9jAhPlXMIZB8ve4TOj6+6Qcn66pYMd7jZRMkLzBIUJbQTK
	 aNIjJGMr1ul1fiYqJIac/X3TI86wp1/tWfSkTdjdLuZN4lmSZs/cAyCyGvw0t5CoxKhRtFgKo1JE
	 sf7lmNspYPPrP6yFQNFyck96mYF7JhTmOdiDCTXytJk5JRzuPlb0oW9H57KEkcNW6vP5we4aSHZR
	 F+CZyry3X+gRJXVASgufF954ZcrSx6PnH/Y7lpn6svAokbBLOa0Ttv30CyvgCW6aoJveCoqAuN1W
	 W+q5UJZTIfvzIF3qqeHv5C9aCvpsAd1AXM07zUXXYaX18m5PiL8An8rOsYI0QogB2Pc52H7cbUVv
	 5Ct3y8QBk6ImMkH+f+T1DG3dwt1dlJPO4COrg9vfqlkSQVU0C/U4VAdCGqvQTssAUJs/yrh3958C
	 42ZeEUOaJBZFpKlPkv
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
From: fujunjie <fujunjie1@qq.com>
To: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Haoran Zhu <zhr1502@sjtu.edu.cn>
Subject: Re: [PATCH v2 0/2] mm/filemap: tighten mmap_miss hit accounting
Date: Mon, 27 Apr 2026 17:36:56 +0000
X-OQ-MSGID: <20260427173656.883899-1-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <tencent_4EDE373816615C46CFD48A6EF3B61E232308@qq.com>
References: <tencent_4EDE373816615C46CFD48A6EF3B61E232308@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D01CA40006
X-Stat-Signature: muoj99fsjuumwb8gen4r9eucg9e39obj
X-Rspam-User: 
X-HE-Tag: 1777311422-663369
X-HE-Meta: U2FsdGVkX1/KG5HJhGsd81OAhRI+oIRvNj1JRS4Ss90eIHjLWWuDdkAyqTFePZbhp9tEWEqq0KtwcwWeaWg6i7Pnc7rWk7LT2vII429htqZQ7V6xEPgRE5GAfGAZ+/cLYRsl5/r5gEEc9LbqpF6VGDtE/CP5yCSjiYWjc3f5gXHmvjZoH3fR+IudkZJaDbw7DtMwcRVKPeRxFD2nqz3qHOYBXj2a3eHedE7ND2Cs0fwWmsyroaUK/vNyh2UzMYBbJi0Ib5dsMayzVcJmVNDk+KJOL5xCcMbOPDgm+qmMXJmz7pX97/mv8juxsG9WujsqDukJr0sjgFr1YGyKdaQzgxqECYvWWWcwNj4oXGvEnQrY/3mQ2W8OruVDLReQOp70LRAu38xYgJ9jo+5hiDmW4wEndTb4kExrSf1SkXEbCPF/oJ89HYusiu3b9HdZlxThyNv2CVhz2NT5yoN2wMAR154Q4+Ti3GdA/EEMs+T88by7Yl1SMudHBw0cPVVQJnc85zMqZGfhcNn32q8YEq5kciTAV1iCVzkLu/RcaRXSVa4YpNGB9iMvoman1Pv9DJGAskuIbR8EI6qXu6FdQY+VkHFO5uOjcd/OaalmfHwQxeB8yds90ZBOOvatC+spfbrrKqwpFkV8tdO/9gC677mGC2em5EyJ+bJxdDxHQ7ySFxyF39eU0hGNieG5RrHW88VNGD6gDgGEs8g0l+Z5lL17ZQ2g0cNms5zEUso6YMrcOvB3kF1ts1/yUM0u41e1QcRH0uxutNSTo4o/4NJmVi+vwbjReb/Xqt3AivkD1eLsrRF/gEFhziVti2DCfqNHrpzb3o5nfQmdfpgg6Na0Bvi1T2t1dhn3IixpK5bEGENl+qGmznT3cpYXfTAL/czl5JiJ3CjwPNcApNByxubTWKIqUy9mgDPUNykmNiaEb7JZ3MJx+jc9Dbcw4FlCgW/qH7YAcVNvqhqL2Y4Qpt3GCpX
 EF9at22Q
 VAETFQhmW8iJsDSJS1+LsZBXvJLuYsc1W81HDsFo4UfJxwNr5fWZEfjPlc9fp6FCqWQsSnUnvShcYLdAJVscCZkrjhF/JoFLNFz+bCwicM1LgCCov8Z5JC90GGNpucbyCYYj0IUeV8UdvG7p/EgUMGMFRh4bLKZBmn7CNCD90xHBOUtriveRfuZMAVcwbZw4rgPrHQjazJeBp19y/J0ULtmoZrbjKVLVoHxQrsCsGfJCfeSwjhBn1N7bPp+mXASjs/QafkypUN2znsdw0aMjapijHzAS4Ka4NdpKQCFs/vMPIG2Mn4URfTHkSyxNUtJSNCM5SQIKAz+9SJV9WReFmz3Z3tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry for the broken threading in the v2 series.

It looks like my outgoing mail path rewrote the cover letter Message-ID
after git-send-email generated the patch references, so the two patches
ended up referring to an ID that is not present in the archive.

The patch contents are unchanged.  I'll make sure to avoid this problem
in future revisions.

Sorry for the noise.

Thanks,
fujunjie


