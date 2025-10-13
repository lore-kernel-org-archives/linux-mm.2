Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C47B0CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 08:14:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CF138E0020; Mon, 13 Oct 2025 04:14:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A7238E0002; Mon, 13 Oct 2025 04:14:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E3CC8E0020; Mon, 13 Oct 2025 04:14:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0DA648E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 04:14:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 91CF113A81B
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:14:32 +0000 (UTC)
X-FDA: 83992379184.08.B79508B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id C6377C0003
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:14:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V3AtLQ1f;
	spf=pass (imf10.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760343270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lv4v1mVXUGBZme+ObR4gv86sycJFRBxk4vuLZjff9Pw=;
	b=Yg9StI7pOMgvmkopiGVTZUlZ0cdVI3N/K28l5LDpqdktu43fLSRahYYFlmmQYy8IbcWXCb
	PgvbqS6rgp8cFERnunELEpO9EIq8VCfY7zBMX894zmVxoPJHPzKlhO4rOP7EnRyRnG9rtS
	czfDGPkz1S9Avf7gyXCzHea4BH/bKo8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V3AtLQ1f;
	spf=pass (imf10.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760343270; a=rsa-sha256;
	cv=none;
	b=g8zxWSSSqTb3UQh9hGtYREY3WkKj2RrMAlzXC+BzG8qpw7sCfV6QdlbMSLdLc6oXTtM6zL
	F3L4+M4d3n81P55FD4oyjBeLQybkT+Jliue5S5o2m5q8C8Ij+uRPR5mQMN2PqP/G0qyagp
	+p5hB3HcZp4sDbBNETvaCSQGwbFthFk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D2E344B35;
	Mon, 13 Oct 2025 08:14:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A99C4CEE7;
	Mon, 13 Oct 2025 08:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760343269;
	bh=TlFiaImgbVabS38jmlSM6UkcfOwbkJdDdnK/tEF+2vY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V3AtLQ1fS8zZ/2ezshsTwCsBvJcjgi0ekhuX1RhLLC8H5aAMLaGDUkWo/LvUlIIm9
	 OvzGYgpbpld7XTthVPMOdKM5yOUnL/uGR4mhcQ1zjDDEOP3a4FYRFN8MDfAJZ0hN/0
	 B1r73UiFOk74eDqSWg51UPKQ6EsGQ6x8a0MyvK5PQNUWG4pyM44sqa5bLKYCC8etQt
	 EfcNW1rBaNDRxSpFuNXseyY3tXMjkeLDN1sMysKNKPQZECVPp/0y1gnONQUpiVl/40
	 mAg7LJim2aPbunYRmHMLtQevGQBRb1g/DQUfQHKcxpy9z2fbpePDVuqKd5KoQ0NQJS
	 noU/c3DYR/HIA==
Message-ID: <2fd2cca0-6669-47c0-a322-4c702d5319d3@kernel.org>
Date: Mon, 13 Oct 2025 17:14:24 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/10] mm: rename filemap_flush to filemap_fdatawrite_kick
To: Christoph Hellwig <hch@lst.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov
 <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, v9fs@lists.linux.dev,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 ocfs2-devel@lists.linux.dev, linux-xfs@vger.kernel.org, linux-mm@kvack.org
References: <20251013025808.4111128-1-hch@lst.de>
 <20251013025808.4111128-11-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20251013025808.4111128-11-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C6377C0003
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 7uqdwgft1ot6789m4u8f7mq93kbjsg7f
X-HE-Tag: 1760343270-64755
X-HE-Meta: U2FsdGVkX18iLB54Lv2PlAcka8aSBtl0i9x+rO5XKU4Jkjwq4swOh9CxHD8iXWUvceV48M3PtOz29se/VHJ+5Ogewj4WgZmlPgNJCX+0AwVI1eE0SrdA/Y54yBetAIKxjXnWI+6sBZ1bGJl9kJ/FodTR4EPKoA1CvlYg8i1b+AZyMGabr8VYYyVGCLHHrhsA0oiAx2icgwdXEMYBrLiFkUDtaIVW1vTL1TIdMrIlH8ASue/10NyUvJNnNWi078FHXjP92814IgRXcJdTZ4TTfYGAzW5Mp9IratNPDEflURzSvkY/4VnhMK/rD+Q8ydiGrpU6P+QaqZ5hik0aNUFiKpu3wMxD23QfmBK+gFRpsJusv8UkTUsVQaHDVmiakDcYg8G0yo5+lHraMD3r4HLhd0C9IQR8qf49nurUYPRkdOpjP8rL8PVj/h3KxL3ad6GnSG3rxSfUaQG2tQ1FxpAAdBr+fSgNfYhyF9mXT97yAM2GeA4e32cDscl9x0z2nlXg64wW2n4MtSJy8l6TJW53RXjZF7NJ0ZALlAq+ykcs8PZB0MJjijHt5GMzPvjjFuzX7bulA+Gz7IooEUCEeWtSjPAfOUk6RgBomRhqQH2BS5X0aPyVURikzOW0rUp0neDWyIID5lK+rDiNRhiBpJCTE83iV+TfEK0wiLKN7LqcuPdpWMDFRT88Xem6T/izpk04kOchJnERALghvev04IGSmS2E2dQhTMx2sGZI9vMPt3hygq3SHUHxWvOU0Ku9iahV7+l6Pemp112XU5s2ZZxBU35lfKL7LDj4Bs1hVB3o7MfrrPFv6sNr1rJwNaq6KUjw2DSgpGwmSk79nVZ8xGW0sMK1i7gZ6efNmphCQHFMNcwnKJW6VvT/Rno4ZS8xrVsjuKh29jPFc+A6JpHvon6ThMhNWSiAAhAt5FwH2uZMSkoftYheGRUG15EYZZh4l9qFuoLGlIZQC6tmWzmrssr
 5kpiAyMG
 TEUxI6APkR4xXq+fFblcgrn0LqW8J5wCGGHbS2jmF69SWZXKb9xiLHLBcbgDcd7/64SKOkDxYtsJH+pYPbWNvX+P9eaTB0ARtMHBdcLimHJRpLD3KfVISqo3msHde0pqLrJz9Wh5Vq4LZG9y8IhCu/RZeX1bZius7G7iGX4kiBO+NFGmDbLq8L6sMlMPRXPkHCya72IYn7fF+kgzs8B+hU3FqzUIQRPbFbTP01lcCh7yJhRporkJ45dPcxLIW3/yBzwkMVFchxTDkndOZdPJGVaDuJS0TaZ69UdP8UwXz93Od7gCq+FWNNJw5Wxg/LY1cddmSjsG6ijeHoco0hkauE//4uCEmtIRWvSWzLiISy/X4LXJt0uW5E8TNOlNNeQkQO9pHqPn0O1Dy+pCs8/C7X/w5ig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/13 11:58, Christoph Hellwig wrote:
> Make the naming consistent with the other helpers and get away from
> the flush terminology that is way to overloaded.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research

