Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADDCACAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 01:01:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1940B8E0016; Mon,  8 Sep 2025 21:01:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 144EE8E0002; Mon,  8 Sep 2025 21:01:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 081BF8E0016; Mon,  8 Sep 2025 21:01:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EB6628E0002
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 21:01:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BC40FB8A49
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:01:56 +0000 (UTC)
X-FDA: 83867909832.01.A70B753
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 191194000F
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:01:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pk2HB/ml";
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757379715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xUex9f0CYBvNxwYMg72wfopJfXOfiQ4px7qk5KwNOSE=;
	b=s8qM62Pu7QG3k5/m3ud5XmCezCBFxX4vXn80U4MmUStIAV9cK2ynyQFJGiN4ZLLX/EOFBl
	pa8A0VYiyR1DANKup79aEYWACRoumHI9vsfeMh1i6msCH7lSNY9AcJ6iyLiJJX/ecl14KD
	c9ZC7dhdUnu0YX5MEKf4ERkJLann5sE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pk2HB/ml";
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757379715; a=rsa-sha256;
	cv=none;
	b=xoXNMmaaO0raJCLdOxMU7xsDzjmyfsW0x4WGHWdsfegp76x+/IqkMa31wMcoGUdIFasTU6
	w0xL93sec5NNZcnJCZ8raimw8rqiP6t4/YRTl6FAKWjJggiLKxtUQTwhjKn/B6r418iG7k
	GUkHUz5I85E7qL9w9VcnUzeBY34urO8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 49F6060140;
	Tue,  9 Sep 2025 01:01:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDAB1C4CEF1;
	Tue,  9 Sep 2025 01:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757379714;
	bh=jk9o4KGOZ/CqEAdi6n2rbEl/LNSY7ucNQJZqEdxSR3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pk2HB/mlUv63og6M8TymI0CD2funNF+uMrzox28tM7teDA+edY3bSvgM6FChOB8Zc
	 MOjN1cTZgUB0u2zALxRpfgI0l+0p/O0ZosqkuVbjrz324wKFDoBX6qb2NAtG7voBlr
	 CU/3P13S6qtIks+B4HETvd0RJtCyKPOWnqjkCuoZwWKE1nadZebxNr8tPBcAdStYah
	 4wbV1MY00hFNl4ZWQnnVUbgYog2DFUY/6SzqzRB673EiPI1ykTZA3Fn+AbvHeRMfaQ
	 uSzmNN9Z1lslYngseS4JLRHJ7gI93xrp1PqWPu/mYw5l/aGB1cbTts9czHtYlo3lvc
	 naA+0kxahA6SA==
From: SeongJae Park <sj@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Rik van Riel <riel@surriel.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add Jann Horn as rmap reviewer
Date: Mon,  8 Sep 2025 18:01:52 -0700
Message-Id: <20250909010152.63978-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250908194959.820913-1-lorenzo.stoakes@oracle.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 191194000F
X-Stat-Signature: ye4xq48oz9mohrftqcq89o1oyfdwacc4
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757379714-833923
X-HE-Meta: U2FsdGVkX1+NajfZXyu3ViOmSjhxB6YfU/cLtI2HWJJ4oCaL/ubMj58ztmXGN15jnREBQtuYUz6IK53qMVYhOKOqKkHSJxHyjEM5EAvWQGF4+Bd7be09+BVU9FXbQdhDArSCkoMqF1ad0L3FQYs2Gf8uVN+X1tGh84lJ49sB6UWpvtPzjds94VRuTUuvOrZ3S1oJD96fmppI8jTtWj2z9aXBR3zk6zn7s8Ah4WE6cHcX+yIe/HpOOyPpkiGYjLd+wR4YpXfO1hmXVMtw2W2stgL+6P2EB9Yl+y6B8Ib9eanddGp0fJTp9c4b7qVNgxIaNcjgZuw7Y583R89zFk1pgxx0xVYbEy0ZZQAu1TVoRgeY9Iqmv0rTFDahbrXVCshT2wKuUEm7VhXPJXNNky70D+N3EAshSWMyQmHyjvJO1ywW4/6/saQ4/2kasFXmnOQOuzoq8jvMkrccXFyu280DinmBfCW3I4qfAFdDol3liWd+huWt6yaBYQwqIa9gChX4JGZb2RzeBytI1UxxwgdCoFshwIhz+GX7MXWSDzKq8+XBrqfemp2Yft4I0LnaC8OzqvsbxkTGjFNYmIvTnHRJCsApvBVQIbwAIlvAbHNjxKqupzYQacWFBGh9kV4jWXUG/fGc8iyCc5Pz9MQ++CNNwD0MiONcU3HM6rFJghwX0r41+2HS0ImObi2zMZom2emPm+RLkGF6ptJu22Bd4I/o4n0fZQRnFTDajJfk5yEsmkReGFU6KPxAKtar3j1ncZgZ3o0MybBBTmAEOHhRCiKFj3sYxa06XnViEFs1DfqMLUUL9jKqi5NsCxTjWkrNWSo1MgCI8KIqNaHN60GI37mVg+KKgHZkKlcD9us1OS1uUuCImhIZM01POeScFsDnmH2YUcJtbngkyCSfFzXK5V449Rx1W5mTJo6tmDlsY0P8oSb8WVEJHa9r2rBpbAW0i+TkfYmliA6Xi+7O4BPPmkc
 dprFG7v3
 JJzwlXtTNJFZptgED5smg52eWkFWV0ACxwiPe/FiIh7DHP9wxJjQhbR3mquJTw2TMC4eMPzMcwXCMIqf+Qw83SF71BBl8rqeLd9XWTca5ubVBA5xk5Mi3H+vwPhUV1hZG7B5tjztsoaNkXxYj21cc0vceDQCtM5OyxpYx43uUXfEjYkMAy5QlQ/ghdQjdU0b3QWlkDP6OeRLVYEZStKhD33D/4A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  8 Sep 2025 20:49:59 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> Jann has been an excellent contributor in all areas of memory management,
> and has demonstrated great expertise in the reverse mapping.
> 
> It's therefore appropriate for him to become a reviewer.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

