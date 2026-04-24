Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37BA5FED3CA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 13:19:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8343C6B00A3; Fri, 24 Apr 2026 09:19:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80C9A6B00A6; Fri, 24 Apr 2026 09:19:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 722846B00A7; Fri, 24 Apr 2026 09:19:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 60CAB6B00A3
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:19:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EAE4040134
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:19:30 +0000 (UTC)
X-FDA: 84693506100.08.61A4FD7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id 61DE940007
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:19:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=i9X1T2X+;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf17.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777036769; a=rsa-sha256;
	cv=none;
	b=M92quYi2QCP/kWWcyOdkBJ3OKQoCCkMB/12/nxgH7P74WrBUDEFZQ/jDKavTsfIBfq4cl4
	KFwq7EAOIamGaCPBiyefsC3FzDjp82WC6eanexuAV4CvGjrtFp7Gjqk5xZb67mF2iPF0t0
	TdAfQT5OGbKU+f5asHQ3xtKkKW3+48I=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=i9X1T2X+;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf17.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777036769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sXX8DCyTeaTt4IdZmkdODt+bPlX1tsjH9okoeWinoGE=;
	b=zONsjafQKmQsKzoJdOCFkZNx11nMzqmuNSBCU5TcvlO/vrFBa8vR2JELy5s5IiCb7lopZd
	2FpsEtS0RJqo5oWOgZMMmdMPOAcKWonjiJQBJsZf22iwMRxZFUplYcyRI1Ar7mHcl4g5uj
	Oqm3FZgXcItd5ZqfNW7UCtTQWYECZ5I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sXX8DCyTeaTt4IdZmkdODt+bPlX1tsjH9okoeWinoGE=; b=i9X1T2X+j7Rh8FdSDr4hl4IDUK
	zsnG28/uG4V+Ypkb0qn22B3vMKmhwi58tajOcz0klI4b66gkS+auXluE/FJDxwEvVBi+LcWgjWN9R
	r7Gl6Ur74cwqK+Uj9caVGY2/pNnZ2iz9rBqyvwp+sGbSEsmWpMyLo0Rm44dMsm6raXUZSQ0n5C1gR
	q8DGKOuyUxXP7CCGXYrJsWG/YWLOqVwrzavUkJnknsGwIXZV6alWMkBDIismCv94L5wireRkMUmPC
	ludTMUXCkrlAnWE2FWrQBVY2jTlZKd92I3KTBBq2njwzHO0NeWCUF7uJ0tOEe8dJLRFAFiQgIx7C+
	OGYmjLGg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wGGR7-0000000FBlQ-2Efw;
	Fri, 24 Apr 2026 13:19:13 +0000
Date: Fri, 24 Apr 2026 14:19:13 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Breno Leitao <leitao@debian.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v5 0/4] mm/memory-failure: add panic option for
 unrecoverable pages
Message-ID: <aett0XmQ1EPSDdnY@casper.infradead.org>
References: <20260424-ecc_panic-v5-0-a35f4b50425c@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424-ecc_panic-v5-0-a35f4b50425c@debian.org>
X-Rspamd-Queue-Id: 61DE940007
X-Rspamd-Server: rspam12
X-Stat-Signature: fha4jg6rcdy641famegoz75nmh4osq3j
X-Rspam-User: 
X-HE-Tag: 1777036768-296830
X-HE-Meta: U2FsdGVkX1/r7we/YlfQ7edUCHW7ZO19/8+C7YgvrRRP9efI/SOK9xb2zRvKexRs/Dz1F1GFA4BrlWSLrL5SbxrFYuFRu6xgxPO7G/Z57UJ5ZLN+2xwJtHXCfvFFwftGbD812k3rVR9Q4Bb6PqAhnLyFJpoVA+2ZIAnQgTeqn6l/t/Jrwdq22Hd8+oBgAdcK66SAX284q7aSwe3us2H32Nh/zf0u/hKKNs1v7oMbRkUdcW6gbndVBSCK2+Ch8BIAOtuUQ05IaU7G4MuYI2knLxRfZPqGWadiR1FDmDC1yaO73rBH+oI7RXFX1eqrGnPamR3TdO8OPzeVt+zdxHEGEAHlsFn4SocAqPxWXNVVYjIuvn9AoVJiHVmfPOolxn2vWr5K6ujU/YVeyJmwnUFIpmhejebAeCHAvBpQua0v9BV4DbPk33uyrv9cCegIhBAQSigSIZEQelL1p6UxeRisTFm1fYgS59hzoiq3h0XGNXnP4WmGmC5A4WiPcg4UzgwEoxZ4g2EPsZrP64rGWjZ2YQREs5rL69UOLp2vNlX9UYEPSn3seV2aWNDaeVOFiRy7H3bBCUAyU4yezKdRGdyjul4zNV4n9dR22d2KMChBWZaTZX39KIr1e1L2GPtRYpHM+DgAJ71DQMxIHZAsrhIUCkJu4QAIvmk7ufye5oOmy1OWLGzKeJMCv97K1HA40UUleRM1P9Mlm2b8qruwOaV09cXTsHPdigwKjiNNkivwcUBJEWg82b3DwN49oK0tRJbYVRdWnW0j9imThaUFXNOIPNz9hE7GG3JNgm1Gn92QHx4WZuaWT8JhUacWw3rv5LCzyPgGhlMPxnPoQfTAH993R9sQI7/HPiHT4MaPwuRdw74uNQ61KUcb7m6QKWn8jSzvQA7ZyhOJzwfYclyN5AUmnead//xYIlmqpde9n0xKadzwBAfse92x6/8eW/xRsGYGuqxBprjrb6bGaemXI6e
 OaI88sWo
 ZTiwMgnKhun5jpmS+EUmY32dI7myRYyi4DtYRRoUk6APDtL28BWGFrmKOoVs4hKxhZV4nRzWCzjjT6AxHavk5q5qWvIfES9m2Msxl2b12EYGLqxogkG5rBsw8ZOgOtNP0bgCt8kjgr1QAFjbwrjW0MGUnBLkt/tgBOkyz+GDu6XsxqNlUGdnNjsYPcnLxxBDcyNd2dpGymL9xGaPqOVKnSOMegodppzxojhshkw9cuIrOC5BZHGpKNL53rroe8jvPeK73cwbYPpsS3XFQPUvZhv62BnfOM+sOots/o2i4lFjiOUaOzMWZS6FGQBTY0TLAtykl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 05:23:58AM -0700, Breno Leitao wrote:
> This is a common problem on large fleets. We frequently observe multi-bit ECC
> errors hitting kernel slab pages, where memory_failure() fails to recover them
> and the system crashes later at an unrelated code path, making root cause
> analysis unnecessarily difficult.

Who is "we"?  Please attribute your patches to your employer by putting
their name in brackets after yours.  My ~/.gitconfig has:

[user]
        name = Matthew Wilcox (Oracle)


