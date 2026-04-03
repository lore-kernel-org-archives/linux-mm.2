Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BFA2E8538E
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 19:31:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15E086B0005; Fri,  3 Apr 2026 15:31:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10EDA6B0088; Fri,  3 Apr 2026 15:31:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 024626B008A; Fri,  3 Apr 2026 15:31:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E2C1E6B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 15:31:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 14F22B7620
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 19:31:24 +0000 (UTC)
X-FDA: 84618238488.06.00380FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 49EA4C0007
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 19:31:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EGIz2L4c;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775244682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=azW6hIaAj7pYHIRevixecPca3fqcRek5lijsb5xtcdM=;
	b=XPAdiZxgUuISKEFfHGTtV0T4kjHmdCs1wWzxrTHonkUvyAxY+m+c8GGTL1WGUp4zBqiRYA
	GCm0LHEO6mNLh1A1hR/s19A6YCo+53kauLsftqQ3+d2KreoKS+/RkqJBJhWgX1GuhvsRG7
	BPAZfCvpyqscEjZHAyzKnC+yZFETsJg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775244682; a=rsa-sha256;
	cv=none;
	b=10wu6Lu8tjngOTpaJ4qxS/HfhYJAfg+X6CftMYuBjzIeWWAIGFnLB8SkcZxCt5oGczjiGw
	zgOJoUrDBibt35ii4jh5Ouqsi60wH5zeY+LJkeIdYICZ0Huo6WChN+duwONijsP9DxLqsg
	q27HQmRIeNEdnZ14AZ63z6zdwaU1who=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EGIz2L4c;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8EDDB60008;
	Fri,  3 Apr 2026 19:31:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5C1C4CEF7;
	Fri,  3 Apr 2026 19:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775244681;
	bh=SHFHqC8w2kUQwRe6EmPocABGOxkTrKhHh+l6fkBMYbY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EGIz2L4cevKoCrFnVhvj8ZfWMeuWaRcR8OymVhhZlE8vpRocla36JkC8xjsx8VMfr
	 8REMVw2/Ie79jv89WKQ6WJGmUTs7V2HHK24HZ/0p592YfA5nscObDDbCMVB4lzVUyW
	 Y8aBIRMPqursfMdncdS49L5OSsbJzfkBBXFY1nIM=
Date: Fri, 3 Apr 2026 12:31:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, david@kernel.org, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
 Jason@zx2c4.com, shuah@kernel.org
Subject: Re: [PATCH v2 2/2] selftests/mm: verify droppable mappings cannot
 be locked
Message-Id: <20260403123120.82cb5becb19e1b572d474394@linux-foundation.org>
In-Reply-To: <20260402235933.10588-3-anthony.yznaga@oracle.com>
References: <20260402235933.10588-1-anthony.yznaga@oracle.com>
	<20260402235933.10588-3-anthony.yznaga@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 49EA4C0007
X-Stat-Signature: 8m9zipes1csnag3n5hf1y7xhgzka8cqu
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775244682-450234
X-HE-Meta: U2FsdGVkX18sXXEpSBTbOfIK+1aAB0sO0esj+XAC9O5Pmfis4zIcFqL80h/IQW375ZGX8B6KPNmiBATw73K9tcMDycqEIXEKJXmEpXmaEZlj20YojLmslpNEOnHpyD6zuz8cw62AxB354+vJzmGhoEkcADM8TRT3iXvCsgW2i39FWW7McU+EvuqUK1A8XT4ZzjhtM4ENvK1r6VwNpoKA6kwR2Xilyy4D6TGZyj+jEWaVn5lpqIloDjkxK/w++kvBUZAZPX8D5OHFw++ZGqrs3L6PWJmI0tYUA28BRqTHdq+lkjQtL4wcADtEFXBFpF+E8U/CL3jyLgctL0k7c/00hvQWT/daE2KoAV0bT8ZCVBAolDWsAkv1LuZPIWvIlAkf6gFjsX+bzMwfpkssU5T9i/KjGrcCesR1GZW8Vv/I9YjuDhmJRxGXalzQUt/oDvw00mibZSNX/EJOVo0eWYVzF6Iumg+7UFD2EA3BTIc6pwgfh91A81Bs326413PXH/bPkiyqe9nNdlRrZ4PtgklsPG5vF3VFgz1dKEwRe/N5MaLwofWzPXMwWWqCVE/LiOYQTckeBBLCTPoFluINpZnBXo9Bloc1ubldmy9P5QWi7ZudrZXKQR09m10YizQp9uKku7V4HgL0bEUQ1ekmwXTigqzd4JorGbBUyUJQHY1M17Hq5Pk9PwG+iavJjBJ0aW7BrObW/bnkN3u77wWhsdt5NBd9mj+45VY4eLpKGSQFX0CHzkF09dR4snDgy7E+/31AxXabaYkFGGV3vzvpFRbB2DwFAxNUHr0HFKmvWcoyXLEbn5yn/Gk5hN1B775kGINj/j56Klh7fmIHy1junuuiBGTzZTX9rXXHj0ZbiuDzXTmNkGczCyH4qizQybA4+xgtOjX7HWdB5EGVo01Sh4woeRei4CnwSpGNolb2BbaX1DmsP5pbCNS26gSt+PO91guvyc3m9n9M8sb7vWiu5h3
 NPUks8q5
 6vciRdL6dtBSi6keApYSxFpNLO5aHIGdGmFVdZnijm6lXxRT8r8meX3znLj6cF4+dTTxDBU3K9g1PiTjVsxBmjaLtUrJ8fqj91YhPluxOC6i+j9P+BODYlKgvypku24I5S/ul3/+nV9E2bCh1Ov+zFQo8UKzD6kkIVURatFrYZiAmpK742flzAejutqPakrPNLfk7CfmiMocqmwnXPrevfgGXuWkBqJ7eNxFMyFVdQpXyBlVFq2oDHCCDUeUeaepkd9Dxxftuo2TwLJv/LiBvd/GbjpRos4H0F38XeVlNZ5CiSdF6zzjVE8CH5whzl+F6JimMVML6a6a0uG8lgbRi++J+/JQ9gQew5bWA84sOGiDlTmJVln+8hYyGncC0Oe3LSSzT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Apr 2026 16:59:33 -0700 Anthony Yznaga <anthony.yznaga@oracle.com> wrote:

> For configs that support MAP_DROPPABLE verify that a mapping created
> with MAP_DROPPABLE cannot be locked via mlock(), and that it will not
> be locked if it's created after mlockall(MCL_FUTURE).

There are a few queries from the AI reviewbot;
	https://sashiko.dev/#/patchset/20260402235933.10588-1-anthony.yznaga@oracle.com

