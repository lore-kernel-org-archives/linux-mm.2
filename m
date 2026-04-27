Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3447CFF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 13:15:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62DF86B008A; Mon, 27 Apr 2026 09:15:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DE836B008C; Mon, 27 Apr 2026 09:15:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F5C16B0092; Mon, 27 Apr 2026 09:15:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4001E6B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:15:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C1A6E1601B7
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:15:42 +0000 (UTC)
X-FDA: 84704382924.27.2D7AE4A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 109E014001D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:15:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="Durjr/hU";
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777295741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S/s8xgft+FNrzEyW9/6uYjKgCVwm5+kMCent6gWBWjw=;
	b=hTwpQ+Kqw/HAm/TxCmDoiFDFMntaePY1hPEU07T4RhSAzYcyjCj0J6YzDsgJjNelGSYBK+
	V95HrCHBxb8ys+DCie2JDgjQZCpFmU8SNXFcTO1+iSS8tj6LdQ9Wy7olhDq/1mxAhWSHxk
	EHu03zhlKaqsWJcqmDm3lfZXGcoAVJk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="Durjr/hU";
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777295741; a=rsa-sha256;
	cv=none;
	b=4uprrU62cIihHaES58CY3sXQz3+d54xHWNuyow4gGRkXozV2aRipNkjabl27ZSGrx2ew7r
	+f5ep6Ajk2BGhl7JbuKH9n8UabyG8OAKK+hcpWf3Mt4uewk/wMu04Se3V9f01RqAQ1JwzR
	5kvko620OjBcz/j/WNo/tH3WjnuSwjM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=S/s8xgft+FNrzEyW9/6uYjKgCVwm5+kMCent6gWBWjw=; b=Durjr/hUfSN05kGXzJwLwFeokv
	5HiCq4Y67GFQMXjU1dqtcJrXStJGANzyfZZQszjh9WF39ujDhnmy+ZKS9HWWkIVLG08Aqr62qvDGG
	p0m1xFGk7E+8TW9v2XCmXolH4AkwT4xuyIJDRwwez6L0Fo2Hjyd7vPzsKqOjFxdl9Ag0XaPiqI/L2
	K7Ia4KaCapj4VXZeUpYjhqBVfQK78wOXMHOIScqbr37bOijPcyM871RW4sATHsmw7hnnHrkcAzl8I
	7Cf/tjMMFe0jMtYRiHhIW8VSD7YKL609pqd16IL0kQlbeTAn/wRkWeyatKCa+L5oTsXwhPZDL4iaD
	n5vvTEMw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wHLoH-000000027Ij-3Pcx;
	Mon, 27 Apr 2026 13:15:37 +0000
Date: Mon, 27 Apr 2026 14:15:37 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.com>
Cc: Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org,
	lsf-pc@lists.linux-foundation.org
Subject: Re: [Lsf-pc] Large memory allocations at LSF/MM
Message-ID: <ae9heafyGwN3ctUe@casper.infradead.org>
References: <aepANOFKoA4jn8NN@casper.infradead.org>
 <6cc83a53-4392-4925-9187-d682b60edea8@arm.com>
 <ae9AHWvXUTuoqlfA@thinkstation>
 <9cecea5d-9377-4d90-97c3-0cd8b2f77b35@linux.dev>
 <616cb4c1-ca1d-4e37-a92e-b8f6f675bd3c@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <616cb4c1-ca1d-4e37-a92e-b8f6f675bd3c@suse.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 109E014001D
X-Rspam-User: 
X-Stat-Signature: rdwpuwrtj6cog515krhq7rf914zeqr1m
X-HE-Tag: 1777295740-986736
X-HE-Meta: U2FsdGVkX18rcv/CMlhblLbiQpnR2chAzIqNXfrJNWWbSx7FvyHagF0M+y17br2WGD7VBl5yZWQUOpbud6pYuOvG/LldJ21miKVJGL4gdnP+c8EDALEnp/DQ7Cg/S6alaSbnppXeCrTlj5YmYYNsozozdZW98/+qpt/MHO6XQiih1bWGnEuQ/dGkqDrofr+o2qhiyoXmfTXhfOWnNjfruC7Ufb5IkYa3AZPpeGmtmVoJMp/KcWeQkwTmSpciP/8FPwr7rUOUrZM0z4VHokzz+sJUVi2RMSowcwqnsZrCyEUsM4QIKQLnzPD+QvnSjAoOMLfZGRYdmyefpxo5xVzNAUYqWT7PVo/oLI6ZxpraukIJ2yAEwXcrKTpiI70PNeEyDP3t+h7t5agUbsGyyOAts59MnokLxC/zNt+3vzCzDfs2vlRHP1yQK69Nb9paexLAkkrPODYO8+Y5U/K0hZy3QyfNZKaCLo9Xr5NZSILLityJq556/+W6NXh7/DK+vn6m9CULGbWSlcyN996qdIYwhSD4d0Y4U27dip94xmxTTEKGal/1RZGfh+Z5KGu5O04Ronmjb6vyt3/HufN9ViVzXYwlePD2aT6KK0ARJNVYkG6B4XGI7Sp+IbF1rZZ0/Ybm+y1qk+anUMjHs2TniGWgPYw1YOooe8WsvfCWAINzjzzwWmTeY8D4KIfuaW9EsRs7CmtdW+YFOXHNrI+AnGWacr3yLorcjd+YLmKBM5qdIlBKxIUamTJAca/576cHmBaCUxCnTMDsUNlE/r399t7uKILaZi3Phg5XLYONfirb5/k4SLknDImhl+QgIF0OkRF3sivNVK0RbS5tS07U+xRsPSaPt1dacSQkKsFPvinYs4KuOa4rLx2xIQK4JtLDa0agvf5/cSxMHNIfYG7KpN/M+Lx7EOEQWFWJsDUInMpxQ749sXqDLrQdPEobC75lQdbMHCkHNgNJ6jXCYeHJZsu
 Lcqi9/qW
 g0RozJvca0S0Vc99cQNMZSCUb1lXhV1kilMliikZ+GrDgemZMdagq2a/cfB+pJysU1kklO+Rn3F21lb6ndIGQn2GtR5numcJp1rA2BBaQ2H0HMJrQGt+S5fvdTFn6orU+kpu3l+iizGmQSWNs2Sc2jV/kmh5jqSnJcJLV1LFvp66zGqou7Yt5FkN88QFUQD2tKHPUo6fNTGA8x6nLseGroYjsaSBl5Z4S0Z/rLwfKvo9IEApNeqAPb8IiTpAxQz+cQCM6m3G8LDaZwWI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 02:35:45PM +0200, Vlastimil Babka wrote:
> Well meanwhile we managed to extend the session to 1:30 :)
> 
> ICYMI:
> https://docs.google.com/spreadsheets/d/1mGEdDrWskp7Ua91jGXzquQGinorcD58DAVXhOiRp2Gg/edit?usp=sharing

Sorry, I meant to follow up with the good news that we found some more
time.  If you guys want, I can split you apart into three separate
topics, or just leave it as a Hydra session.  It all feels pretty
connected to me, so maybe keep it all the way it is?

Looking forward to seeing you all next week!

