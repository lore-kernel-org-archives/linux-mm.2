Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0458CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 12:39:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95C2B6B0005; Thu, 28 May 2026 08:39:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E61D6B0088; Thu, 28 May 2026 08:39:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D5DC6B008A; Thu, 28 May 2026 08:39:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6891E6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:39:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0A8841A07C7
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:39:30 +0000 (UTC)
X-FDA: 84816784500.27.6713BFC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 755A420007
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:39:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TdX3A6Wh;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779971968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LjOzL2NyUyCTma94sZKS4fSd2UcLIZWOihtjlrGif9M=;
	b=0VrKsovXaoW88k0kBnD7nYNea2hQnDKz5hP9wR8/fZdFLjWmqUn9+2K/7gvVAt1v2nvzq4
	4tNdhWPtjotwQ25r5gPXd81/apKb5buGDK/Ud7dfuY7RbEnRL6jBUmwLQABeE8oZ4+RXo2
	dCyJbobrxZH3wo6kXVLE0yAigsMqDdU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TdX3A6Wh;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779971968; a=rsa-sha256;
	cv=none;
	b=8TwWxUE4J/7p5EdfNZlh8Dqe26Ax3qyLZzKptU0Wa7u8mz7bOWJKJNhQvKmNWTlUHw4G6O
	ZcO75yZTxZoaQHNhqZ3PCMJFBNMelIh5Znu7mkgsPJwqSUk2icmH6wyDeYGZQl/8lEDfu9
	8NfDxwB+VsvKOiOhWU+pRGHmE5gIBlg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D5D8D6054D;
	Thu, 28 May 2026 12:39:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1981F000E9;
	Thu, 28 May 2026 12:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779971967;
	bh=LjOzL2NyUyCTma94sZKS4fSd2UcLIZWOihtjlrGif9M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TdX3A6WhsV2nqy6+cmmWG145Nlh49u8GVavjcX97KRruYVRyz/sGeGpKyv9mPrkSs
	 Cxe1Rjip23w422M4eSOW6H70usxBTO+ieZzkGKi7P0PG4PBRR4cgQV8cTfgypLhbpF
	 BM57rT5leqcqmysGGsLIUlfyEuDNh2ngYqxbiSTKKWnDOtOz5BkqlffrhOjWow/75Y
	 NQ28Q+/UQReKL7O6PWOxTBcJVBszmh5e+45Z7BJGTSDyAglZC0gCtijikOwx63voFo
	 A2khGbG0CIOWxww3k28B4ahItobPCUnsScQP7aeohU5zh+P9EHxV0HBjeDa6hQXXd4
	 bF5ivNkVQEDHg==
Date: Thu, 28 May 2026 14:39:22 +0200
From: Christian Brauner <brauner@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, Jan Kara <jack@suse.cz>, 
	Kiryl Shutsemau <kirill@shutemov.name>, Peter Xu <peterx@redhat.com>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 0/2] userfaultfd: merge fs/userfaultfd.c into
 mm/userfaultfd.c
Message-ID: <20260528-raumakustik-absitzen-verzweifeln-885bd6a70835@brauner>
References: <20260523173759.3964908-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260523173759.3964908-1-rppt@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 755A420007
X-Stat-Signature: arct434s69494f577e783h1w6b1y7h9c
X-HE-Tag: 1779971968-351593
X-HE-Meta: U2FsdGVkX1/zOmDJrFtaxz4i1lRL/idA5H5qerc6OTRhs2zf3BDXzwDHPBDEk0B0Cw4dZ4aVTVi+TyelqW273x8pbGIbF/8ACg6nLy+ItsnNLhti4kwwNGbb5qwrIdtY8zaWTdWAOenG1whW/OMyw/MqPT1t4Y6G+pzXVFKfpLqH/H6Siw7hOlK2inF9gUia5iVWVMBlYrFBKLCzKLwcu4sy70jbfeqlIkdXqmGUVJli0cRLj5cWkOz2dKi+lCwo52AoJKA/dLxW0AckO5K/Ay7GR1790o6aoYlOYxD7jj12JWwPhBVSy/x7v03YhhBiPt8tbDO2+w72pKs7ZC1IvAU38pPycjahOblK1xVvrqFICSYS7rVNWpDueTrEGT4iPxgbRDzk/i06JC0kNZvSpGYx4yRf2r4QWUG9xYCnwmjHgPqsWAIQaEg1RlNRZ+U0UwjV6QXtJhJJCnF5NW6IpiKseWp1VO08kz25JSnWYx2rP9geymu68a1WzpYBfuw3pmP+A9Cc+/GzaqRTv2QM5pb0n3LPBJjKJUkENvdqHHHX4AEKLVwumaUqBGaYhgvlVTneLmxpd6CJpsUUSbEFwlSpBAlGVp0waJRnkdFDhenuOgHvzXiqbX0637QIJjpllRq/NtgrDViyqudSb+vMOcc+ljEelCnZf3+6pBUVuehRuYk2vMVkvsGYFtAiByN2xiWsX++6lZy2r/GxrVOGVPTEolE9QdjGSgXqoV8bhexRaY2w8gZuV5F/mZJ6uHM9FBpdy33Udy+f7t+ad7q2OIgS/H3kZxJE69sJeeHzSDCUfOxV9YcNwL2WjMIVmlTkqNR8B21qzpWi5m6zcVDdocAU4Ra2rYcaZ9wtS12UmcblziUQC9u0XSZ0k+lK782nAix2zAmauSbmP89+XvqE/8oKe9wUz5R0UKqFKq8D9DawNjGljrR+hcsb7HdyTXWNbqVkl15uKc9BVgGhwF6
 GLdvqN54
 8ffx4FFsnUU72se3oS7uYz5hY2JAvQTaiZHhF+OIMgcV6xmGbRzLA/cn+mDuovPwwuwnjr3hWzlcTSAM90tE9Pa1pUDuYeeRwL3H7DTIzFzaQBI79ZTWvnlniJn2o2KIxJZqafKxWTc7SbBjG9sWvzeMQOXt4Dq7/tfxISSYbEFxKZ0tKIVBR7O+aaYm/OGxMOz4OkgPpJfOCKemoJ+gI6i/OYhYRdYssIsDfcLcJm93s0U/gb2u4xD+wvkfDmZlNsdO4z9zNiVMG7yndmwrGIKJ/OdDuvSYw/Q9aSNnVxHdyrZB3vWC1uypNtUCEJ6Hz/vN8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 23, 2026 at 08:37:57PM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Hi,
> 
> These patches merge fs/userfaultfd.c into mm/userfaultfd.c and make
> functions used only inside mm/userfaultfd.c static.

Yes, please take this thing out of fs/

Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>

