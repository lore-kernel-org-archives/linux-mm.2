Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2710C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 20:05:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B42CE6B0095; Mon, 24 Aug 2026 16:05:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACBE66B009B; Mon, 24 Aug 2026 16:05:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9943D6B009D; Mon, 24 Aug 2026 16:05:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6B0C86B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:05:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D582AA023E
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:05:33 +0000 (UTC)
X-FDA: 85137242946.10.3A997D1
Received: from relay.hostedemail.com (unirelay08 [10.200.18.71])
	by imf09.hostedemail.com (Postfix) with ESMTP id B7C00140008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:05:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787601931;
	b=AqSA0Q1AELw3Y34zIvpZiRTeH3IiQi6m0sDuoxk4pPHMY9VKszMnUjBNg505wtTSZXkTJP
	gJJd9CgLgNHVxcUmgIbtMhBkg+hmjRmG9WsxTgP7rjwMT8ZqxRCYpSgGmn2MAZmDlBhUcC
	b5oFdsAOWZp3OzBck0Z5EJiGdvAGnNA=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787601931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ML7HHzIBIY+3IBPehSYQGk7L3J1173sVNVbh7u06TnM=;
	b=Y8lhLtwpvUYzzBqmt0wni8XdR7SgewdAPfSDIXcpcrT3GnnfgxRMRbdvKd3mJf1kN8xVLE
	qCZC2Woj6Ps1MMUueDtf5u+wwwGJBSk5Pirpq/531HXYDytBGUZuzmSU719z+G0RWvHpeo
	gF3UBVaoFc35MCM/GtgeyW+T6y22Igo=
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 44F6A140264
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:05:31 +0000 (UTC)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 17A8DA0244
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:05:31 +0000 (UTC)
X-FDA: 85137242862.14.26697A1
Received: from mta1.migadu.com (out-195.mta1.migadu.com [95.215.58.195])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0058BA0019
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:05:28 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787601929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ML7HHzIBIY+3IBPehSYQGk7L3J1173sVNVbh7u06TnM=;
	b=VSxT0yTduRu35lCMa8AHIi+N6MGGFO08Iqvn80Um6ZPhHFk5Cnro4Aqd7Tm7n6MQ29DHMX
	EYi9lwCHbdcVjurVJXfy/WN9eo+e31l2QVfqL0CLbiCF9UbtgVNao8kQ/2KwjdUGag8zwN
	cAaz8N/VbjPH7Tsue/U140TGHRGuWOQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SmKSF22X;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.195 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787601929;
	b=aBl+OZtV7lAzJt8CG2eg4da/IzLzXA1RhnrZN3C0q0HBhUgIiAA6rXE922xRtKuewiZa7k
	UD7MBBloTwlcPQvmq4IW9ISvHyZz8A8LTgUcMNPtmLKd3Qtp9sXi5vboBi3i1tuU5a097t
	xxWt+b4vWE06l/d+grg2dAmmGCVzm2U=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cDaxavN3YsQTGlyaT2Hh5wZsVWAILscK7C8PR7eni/8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787601926; v=1; x=1788206726;
 b=SmKSF22XETMJFReee/ZW6Du8yL4xCbaaY4bj9oCpAf+QT3agCrojEnzCkUdb3G0N2rGOFJzl
 NAWTbGFR3iHEfzqAGZyrNGna8rOuQrgmFf9ZwEx1fUzGGtJ/FakAXM1F8B6nj8nuA1CmuVA2cY2
 GFpijtp8n+4pS09Sx+jg2lpw=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:1f::)
	by smtp.migadu.com with ESMTPS id 2ab2a7625b0c0edf;
	Mon, 24 Aug 2026 20:05:26 +0000
X-Mizu-Trace-ID: 2ab2a7625b0c0edf
X-Migadu-Flow: FLOW_OUT
Date: Mon, 24 Aug 2026 13:05:21 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Enlin Mu <enlin.mu@linux.dev>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org, ljs@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, enlin.mu@unisoc.com
Subject: Re: [PATCH v2] mm/vmscan: fix comment logic in balance_pgdat
Message-ID: <aoyj6LCBRolC78N2@linux.dev>
References: <20260821064057.4081-1-enlin.mu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821064057.4081-1-enlin.mu@linux.dev>
X-HE-Meta: U2FsdGVkX19Rwx0oppDEj5vURiFlpiklnS3M32n/GTVjRG2P/4w8JdhtBjy377nx7dtefOmaDm8NuTqD9QyDDcXhHW5+3kre7khZC1y4UugIgFhc/SGjUrtRcOu377URqrjktN9RQ7TXu5kYgwL2kg7AsHS+1myHRJDnGVQc6eao5hP6H84KCYY/gLw71V6kN9r9JDFZoP5xkraeaSaWduVdAbqSGHCSTYDJPRhg8x53Xle5cLV718E0j/DVNJiel51+tmmNGMlLTnN+4a6ejyfLuOKS1DhtYayCM66pQyfc3Znz9y3QAkFf/W6uayS4h3D26NZkVm19mrkNZgi/BvlnxKCp5zuKqE08c7mws6IE0mfAeTJnOA4IfvjNTTSY70qm2T73j4QRzZgTm/NQtZop5TCDJjRLWj8mvMNpmOKHIGfSCQZwjzf1ahhc8JuMDrwAuJE6Q8Hf6PycUTJT3VzUBJKXuBsoggClls4qczkZxLVFMt1ZWzu2A1+QkZcJ8BjGR2sYX4oR2ISEeDsJE6iIFJdkgmIKOS9fplyQN/Tv8+0g+GaKamk+M5VYbKhUhXiLAXQ9OTFZnstU6Aq+WO153RpCKSocopQ0wfFHUkGPVMfQd766qRBPgEN+npuQ5la/LCpZgk5rQm14s9BH7zd78udYHZxKaSUAIpmr9QZhG+GQgDP6suql3PwiKn1ON1WVPLsrYUXfdkq80X4UpxtxPCf56pepN3SkggdEQFW5MdTPY8MwWRmddCBQVXvSBZtCyZ/gsTX1ybQ7nPJyZT9VZ1ckBPkFFapo0Q9Z54FtpvHyedzqcD4NSvIl1GPW4CR3tQ/V0rDmNFGjpG73DoNsoAjVg9x+g/g4+B+S86duCvVUBiLwhG59oOHYqlQZf+KpEYSyoDloDfFzI+j9VxfC/yjDalC9vWHV6igUi1Z5FkkehSXazoccu2wpcfT+q1QV3Uek+/CFu0U41hJ
 5i7+MnAt
 Xz6sX8oChK6aBpGnP2VkvE8VR5EqXOwCfIKkcNBzbAYfXxT3vzP6i40MrSpOgzam0HmUXZxSl3egs+1JR40QX8lmvDzBHlX93C9QvlS7/sqFbeIRZJyJNeoIX2H5mUDl2x8ugtCCgUANexyE8ph4U1JqWR+O/xS8krBLCeZB+G0QBG0dD93mU2YDHp6o3OuON6I6K7fP44SyIXU2NBvjHvrjaqYSXa4IMEdnzranaGAmn74NaE1lNvkWHTDd1VVmiCJegPywcSyU6ZqeslHkJ3bHI/vulUdmPeAByEHm4+cMPk3aRI3HFUjYprRfazS1B5v/OlGgOp0O+BkVlcLTUEy6hCvJtQFiT5VWG53EgwdkOERDeIHF69oVMtsTPA1F33B3T4EJRWSBcCA1gd+r7zv/xin4dsi9oVigaCI8QAPv+opw=
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B7C00140008
X-HE-Tag-Orig: 1787601928-957212
X-Rspam-User: 
X-Stat-Signature: du8tqwgfu34rw4hmrxow7bupy3ntr1si
X-HE-Tag: 1787601931-606483
X-HE-Meta: U2FsdGVkX18qD/5fOEjvD0b2M8p85gFblKksy3yZ+nMFqfa5PS/sqkafVo7eGAayV1Mi0/FSewKdIw1hEQecpvq78EnvbTGR1UFlQCjrDDH0lmLw7/XPFJK9B2wfsNXfXhUcnHBxn3ZR2jx+mNyNIdlExtw6hPGM7aHkTV4GE9Va5WZARZY1QC19ez+rj3Sefbz8qR4nxnUuVQcL+095laLDSHV6Yr+6YFBenPDxermQ2ftWcvUZ+2R62uK5aox253RJ3Alne/Bo3WbW4AKIV9MwVRJdbTxHLn2bioXxG8CZXx9rK0qC0LaZPV2k8691jqEJPXgASudXY1TcDPNvRNqHgikGIO5bSy14A0lguq43isi63YtO83aVZyatv9gYtvCms0LcMOJPopfCP66LHZ6ciZmVR48H1Knm9bCVx1Qcsx91sSr7h3rd0hZ/0cNvRm+osgD41JLyFH+7RsTHcBjR+wuBnDB5WNvfam2fnJZZsbMvyjIySfXhD4mCVd0zjkN3X0RA8vcQyJCJCgsZTtZQqt9gETI+uIOz1zfSZMbcgH3pTZ/hmiy22SSWQn2rB1YJ15BMJ6HD9LUoKbrhfrnHzlhr6OJyWBhwMiHMMjWOn2RkXC85J64GlBr5JDo7NjcHXM6fp1RloQivJzjTwHfVcFU0BiGUdRfQd7H+t3SPiITUBp4yf0X7mJYK2+nz7wy25bRnCld/mslIvqtgpOYQELCimFNResemhm2M/xFihn4gDwE/1UZqeQzjiA0B5ixbkDDJkf7ICBUkhxrDmWckCSOE+6EBTRiFDgbolfRLdXJ2etQfRVkmehB9bJ8F4uZor+NjfsVVDMsSGs8NMbQyxuLj7xytyxeYVpohZeEgDW93Ykn4sSE2r5yWkOtwUMhSw+tb5D08tnYvwgER7T2MPCOsprOutnToO2bFX0eq6IMre786Zowpl3qLO9a80kh+qD+oEySNz7ETxKl
 5HM4Tnda
 CelgUllWoZCenUnqP6QS712hsS0U2J7Fek79wBZmHjuc5N0Cv4CNs4RkODYlq2TFVeHo03eVDMXk6yihAghTkPMyekDebOilsv5lauCj6LyNkE5hq6z7wHgibJTcqxzABiH7Q9r12A6h1zvhOU7BjkBvd5kcfi9anETY1Sgs2DZGit9Ubd1/eTpDa6p55G88SrFBz24RW2TS+GmGgi/sAthDEKJXmRTyg1D25DiUVOeWb6H0RllJdrPpXNNO5NCoptis5P5A+ESk/TuHbFQf6BtDonjYBn8stdyzeQwoizLym9V5tv3Bot7ZRdOtcaXLo79Tm5/w6kK1H+Z7qUsMK2ziF7DlauFK/o+f2Ab3i8+SCSIFPui0Yuar4lqw0bz1G93yZvrdmiqBeggRaCmbyek9retbZMRKoEiXKhyG1ozXZxuCJA9tXeCgxAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 02:40:57PM +0800, Enlin Mu wrote:
> In balance_pgdat(), when the low watermark is met, processes sleeping on
> pfmemalloc_wait are woken up because they are able to safely make forward
> progress.
> 
> However, the comment incorrectly states "they should not be able",
> which contradicts the actual code behavior. Fix this typo to accurately
> reflect the logic.
> 
> No functional changes are introduced.
> 
> Signed-off-by: Enlin Mu <enlin.mu@unisoc.com>
> Signed-off-by: Enlin Mu <enlin.mu@linux.dev>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>



