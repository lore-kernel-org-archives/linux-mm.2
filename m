Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66705EB7ECF
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 12:49:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC0CB6B008A; Wed,  4 Mar 2026 07:49:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C89446B0093; Wed,  4 Mar 2026 07:49:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B41226B008A; Wed,  4 Mar 2026 07:49:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 954CB6B008C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 07:49:03 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 43B0C8BFB2
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 12:49:03 +0000 (UTC)
X-FDA: 84508360566.03.86936D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id E88D5120010;
	Wed,  4 Mar 2026 12:49:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ICg+Flg0;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772628541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u0sl2xeZlds5Iy6bRSJyOtzmAWoNSGdfCC73OX1/eZw=;
	b=2YzpIfQxHWk7dU9h58eDlBoVnChCrGeeTON8+soYrHVZtWeFwQ19E3dhs//ee7D341xQwJ
	CVcN6nxKiVwsU0at5UV8oNmO9XSmy5Q/oYzJZILbagqZ9FnkRxTpN5DSkie2x48+KJ5ZsX
	TYjLzJJAcF9JOyak/mZ3TNhu3Bob/Bg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772628541; a=rsa-sha256;
	cv=none;
	b=e0UYBsAd5sfA+tN1mqBlRg9jQhh3dzJ8euHM8g5aShaUAP5ZJE9ZkozawQlDmWSNKquUuq
	cQM6aEQcmfrfHVEPbfubC+jjy5AxsUGlZuAD3ZNNqe0RqlGW8LypzL0NbT/DNoQSjZap0H
	CrTm8+sBTTeG+f6U1jX+XfV3zmUOYns=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ICg+Flg0;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A154A43CFA;
	Wed,  4 Mar 2026 12:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D61C19423;
	Wed,  4 Mar 2026 12:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772628539;
	bh=VZ1IQZ9wkbkriXYlTeVOKrSSDilZmIyjz5pgJIAWLf4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ICg+Flg0GucrcK/Rp72ulJveVObDKbF74VwXPM1WlSI1LMqELjkUi6Z1yVFSvEdzx
	 sg4f3jMhAsjPe5+eS4uJwrFgCLC2x634qa7461r+1moEHf8kfuFszeph0AdcKmsKt1
	 YMDXm8+ua/G1ZldiSP/pvm7kJJ5+jdEmXmP4WjhB+BGHY1wWU2IemjZNp5ejFtDqX6
	 s2Oj6yA0YXmbBsB/pxBp3PhBqI5lTneSZBpJ+rUdDB0eqzmP+2sLWm8Ifx5AUBKSWg
	 VFnLzZ2Iex6vpQbWkYuo7BYDlnmJBzjw37/lgcK6OewxZWkKpJpOLSe+IP52ji6eXd
	 MSUewpqUQg7zA==
Date: Wed, 4 Mar 2026 13:48:53 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 18/32] fs: Provide operation for fetching
 mapping_metadata_bhs
Message-ID: <20260304-schalldicht-bushaltestelle-0ed92f03754a@brauner>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-50-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260303103406.4355-50-jack@suse.cz>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E88D5120010
X-Stat-Signature: 4y47no87ifky4rkmhuprtxe4gbbg3i4c
X-HE-Tag: 1772628540-174503
X-HE-Meta: U2FsdGVkX19ROylkmRWzkByC0T1YeZylQwOiM6TYqu178dVsrQsGlXdY7yr0cuC5RpOlyV4QWCrt4ALlFvX+ve1ywIryuV64l/wugTr84H6ihFPG97vonU7oES4ffNRTW7V17Jn38dXa9hMZBSc9ccOEMFGg1WVnM4vXxZKRL4gmOLOf9H/oK2bNf6GI9Ofhmutq6GRZDntep47FouBvn+dKlnNJYm7B4fq3AeMci3qgw4fA/rJQZBX1KJDBuT1Nb02Vq8dZSRXYLfVRTPZm18CbVyfUU62ShprSFrOzCOTpaT9AwV5vG/oVf3xDG9nypuq3GGc9xDOtWy+xxAGbB7f/dXBNMiCjT0uHB9efz3rBavE5nV2U9p2WGekrlCnGde/Yh0aO6PR5wNIBwQ1l2KjghHt52wEBv/VXl3uuinyCjie+1eTHtHb0HI1mri1dJCF3ZRQe9U7bk2H4Uz1QEE88vB7Nug/7EIblyvb8vUwlCaghw4/Of8NuEFkWXpjQSyv342aK6R1PbdQB+dYRlYNdNgNj5Fzs3H0jxV5GpfrvtQwuk173BRMhjvG7lFf/uFtvqIsdsceWGBWV1YmlVU3p5uvUXlwQxG7hZns0NwXeXbBSqsgpPdilv7vfJrjtkvAVXJ9TJUasw+cn1cOgGg1xGHarhJA4r+o1XlkJRdqQUOhUHeU/ff2UBh7pwtg02gbRRIUChc1aW4PkfCfnaMqD+UvGBbTLphPSDE3vQFpzYi7u2MiP8fMWzK5YRFxk4DtG50mk6B2/BGe+9BNXuucsnEOwK7lowKkq9+g1pDG1tvjbgfRVwlQK4yvtmNSMqeWaq9US3/s8xZtZE4SZO7WTQKYKavPsAGYdb+T3jNh1aPizSUBMJUmGWTzGphOYXlYaeHHRI+JChvUeiqTAnZgZsHemrS1m9DS1ct0Fyp3phS8qzzIPVN/bYfpzCRntnhXOgX1629BDq1zm+VB
 frCPjzMx
 L8btWYA/vqhGRwkmgpqHA/ii9rzw5jRz94p+cDcvsKIeOBZON+UMapRU5oyIQtzqdTTBOYrxRpeaQCHyCcoQiQbuRswPjvjmFLetLC7r3GUFffF1+J1YOFUpnyxrNVFYr4ChYn5XiN2SRDzWeA8J8o8NooROhFlVkvfbfcJZj5G+qMPYrAH3g6ZDnrN6+CWiASEDKZB0T9jK8v4MsMYs5Us4b9i/1FU50icYRbl5KVV5HnAvvRiWAInl1CImjk0oy8mn2mw5kFtKDL45yRZWVGjpejjJDDJYuRCU8NXzmChTMPl8jp+k5N++y3BbSfZ8xdU0YJLOmtEWXWoKS4LWjTJPR9k9Z8P94WH4mD/NP+3eKJLRz53IbCVRHCzTEpu0QfXNJVt7ITxgIpRXk5raysDElAzVy1k7qV/akF+BVIjOlMuM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 11:34:07AM +0100, Jan Kara wrote:
> When we move mapping_metadata_bhs to fs-private part of an inode the
> generic code will need a way to get to this struct from general struct
> inode. Add inode operation for this similarly to operation for grabbing
> offset_ctx.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---

Yeah, it's a good enough trade-off, I think.

