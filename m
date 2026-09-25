Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EE9AC9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 08:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E81386B0088; Fri, 25 Sep 2026 04:08:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E32C86B008A; Fri, 25 Sep 2026 04:08:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D217B6B008C; Fri, 25 Sep 2026 04:08:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AB2756B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 04:08:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 28E8C1205A7
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 08:08:42 +0000 (UTC)
X-FDA: 85251558084.05.C508EA1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 69483180005
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 08:08:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z8WZVuAJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790323720;
	b=36vL2qXVyuYKJs4bFqtTrwbpKrQlxubVvC7TRCnvIPGvmLH1K6RjNPGcoyUm0eiB8e814/
	3cE1ZxfdgA+21HT2mZIcn9Sm0SeTEUzbmB8AjsNn4mQc2/awMRvC0hUcK3NOkwOxeHLtI3
	Jpcwj6Dc6F5sqXXFX2HZ0B+KOjTfql0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z8WZVuAJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790323720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VssZtow+PvU5/GrIpjEZcxeGBES/hOF/QJJEZPsoZ6g=;
	b=f7bhuApliTaW2A6/6Sbn51AybqMADtsiLpjyRNGw0bMJ2VV12h6CVbudTwz8hvH/HK8E5p
	RciqYFix/N+1+9Q9ySIc3xJ9H1BThrAMmcgD6RnPApLlnDBaot6wj0JnARBoSFkkd0URe+
	dtaJimblUfzHcMRb5B5ghXtvVyDZh1U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CD5C56022F;
	Fri, 25 Sep 2026 08:08:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7061F000FF;
	Fri, 25 Sep 2026 08:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790323719;
	bh=VssZtow+PvU5/GrIpjEZcxeGBES/hOF/QJJEZPsoZ6g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Z8WZVuAJy4c0zx2TnjaNqTri7t5ZdtKFf6tMcORIkfOxFuzppwT4nRD2+EnZlB9Yo
	 ydbNDLc10IAkNYk9UAnO5mUZ4nO6+JTHJKoJbPlYX3/eb0Y+DxECbpc7INuATfWbQd
	 7mQ3bBaGdlKF3ADgSFy64XFX6cSeQeN+bQv0YohImZQ/IQzKBY4VIS8kov5DRi9VQD
	 EDr7clnHdJmoQRTrkaNVtQDgsvIZ1Az9nLWu+l3eTT3ELmuEcG6VL2mmbmPwlyPRNJ
	 9kVVRA7LGl5nunUu3s3qbUxE2KxuWFd8AqQt897xiGtJ5UJ2mabbz49gN0vNfcAwGD
	 3J9g4IJ7cYKDw==
Message-ID: <0e908ba2-2b75-4b21-8909-ab1619734bcc@kernel.org>
Date: Fri, 25 Sep 2026 10:08:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: Remove slab_folio()
Content-Language: en-US
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
References: <20260923183655.3364885-1-willy@infradead.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260923183655.3364885-1-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: ug68yf3krkotdssjaeow49jhrmuacdwn
X-Rspam-User: 
X-Rspamd-Queue-Id: 69483180005
X-HE-Tag: 1790323720-86321
X-HE-Meta: U2FsdGVkX183ii+iaj+n4+SRhq8nUQxNJQqKIaIeWasdRtiHRNGM8ST6k7ZZXO/txmY2J5HnMcajQANOOkxfFKRpDsrYUBPy8ydZDs+bkpEzylpVwflm0SHS70auDeZW0d/3hMdV/jf8g/u2TMnVtH9wwsd0v4XUo45s4fYkgZNev99qCocKP0xQKGjSdEVt/AMgD4NRTTWAiohSmrHUSn9GUlk5Xn5iDkpstxEQzrvBTQE5r5Ketkv5XG4ThFHlaAmCeMjq9ujaFcWxUIU/p/boJT3Iht0zbyv5EMEleysDINKX4lZLixYrIZD0KZGqnVS8aU0a+Basp9DXtnx34FCEv3SEm0IOIAq8Qk3cRAoZkvl4Qkag9iMdHg3h/JMVEzql061wHRHuSnFUuL3TI5QmF1qDPFG1FXxcdgvgUlbE4l7ynt1zLNj+e7PgI8WfQM0dUBKTxe8SvLDWWuM030s4ceSSdG+JEyBQGVSMXo1qALrNBXuH1hlO9ftFERqAVZukKeE16NEGTsrt8TwdZQK+NeMQguRwByvqUWdfw3qdoGcPnBZCVg7iUfMVWKCXc4ARdEc62TVIhKzOgdZR/V2gak0uaDHIGox5F8vFJ2nB8Rn/k8+xKoNkY8PB1YvYYUZONWDUIgNqTBEZ+jLSRDXUpWE+RJNGfbiKeHdIcLbVuGUSg7A/Q/570+Sl1WR6GjHPtHWBSCALKGJvft+wm3Cr0nOPkgsBIsGnsz1j2q3y8liZ7dK+4oubrReAjHYIaYKNX31cJWaKwXc/loUpjY1eQtW33aUjPNMkw5WMYu13aeOTMj4mNPzFNUKSBnIBcZxypZSGyx9uWaVyHRQaXqXn17SgOXhsCb9c5yl4jw3cokvENslSZNlV+dnJOIz/FoJFBVd0+xOUzJzCnmKrv5wNI9win4pWJpvEo6Oyw5Ud4xoMq82qnFiXkDfGPNbMQG0eBbRN3/j4tlE1mc/
 BH7NC+sB
 cKVNB9wM99b9wWgzXyk6rEN+tJztmSmxE+tBLAuJv7lSQjl9UT3xMmGPwvK+vAEQe//G3AcYHkgJ74T9Y6o4Rq7lTdNI9feSOEhnPkn1zkVzJ03leGWhvyTeaRMDznw/W2yiWNG3+Nfq6wuZtj8Vmsfy8zkGErYg+i+RBYDzaaMrHcWPmpB4pJ7tVCDeIC0lHmBqIzTAbSk9iIGMyJlnzfe2plh5A3PO9PNo0QyvP+bbsLMqrTPahQLjECl5Ngt/6ApkaEuthnxpiHvOPfZo4u5zWFRcH0FXqglmlz2F1XsikOvmtHC4Qp2tv2GDFJCxr9tJMPRgtp/33dmIdi2xKNB/f/zBDJ45vFhaiAFzM5D+L9YbXJizxkN8fCkdXs9pCyL6B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/26 20:36, Matthew Wilcox (Oracle) wrote:
> This is the final step of divorcing struct slab from struct folio.
> It's still tied to struct page, but there are no more mentions of folios
> in the slab code.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


