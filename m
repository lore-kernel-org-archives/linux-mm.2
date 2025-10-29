Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9D0DCCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 14:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25E358E007F; Wed, 29 Oct 2025 10:56:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20F078E0045; Wed, 29 Oct 2025 10:56:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1260B8E007F; Wed, 29 Oct 2025 10:56:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F31BA8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:56:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AAB11BAEF8
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:56:09 +0000 (UTC)
X-FDA: 84051452058.02.90EE2EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 28F4A160013
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:56:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P3kOGNvK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761749768; a=rsa-sha256;
	cv=none;
	b=dcAKyt01v7PMxIV9gR3khZVrSsrhTE8l0Eu5P4RcYJ50XwKbDsN88BsQCB9qxaxJYEPy3C
	6SH92h1YiCeCgMJc2YsftKiCCEar5/aTEcxMboPm7xw55MxU+UbBxp/PvtpKxFRbXHeHZS
	r7Elu03+aOsv4+Qd6e1f61QkqWfQL6U=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P3kOGNvK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761749768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NWQryUjSwQW73bTKY8T3e0hgWS+XmWERKd3i/Y6xVUc=;
	b=BiAG07uEfRn6+FO8+nZcQAVFbQsKH5Z3eIAs0CLxFdbHeMS5ChueA3MhUuUk6yldanfJvz
	nIIsejhX3Dp/CL4uXcfw1oJZ9XcP53TLV/ZM0nljmgcXPqSH1HVsnz4XU6+QWyMsFz5qhR
	g8MuSXrjOsdQIXlFIRJQYaNKU8v2k+0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 272AE42B75;
	Wed, 29 Oct 2025 14:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D57C4CEF7;
	Wed, 29 Oct 2025 14:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761749767;
	bh=NWQryUjSwQW73bTKY8T3e0hgWS+XmWERKd3i/Y6xVUc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P3kOGNvKTTaLITLdtrF8r6T+Xs78Yq4HQi6kWz236WATKXQdPp2XEX+cQxgJd/PFI
	 jDd1y56NENE0CpUW8N86hTC+2HCqI14HBpgtwmWp1l9C4MDMfu7AMSEhBBDeD87QFD
	 7EdmbNkHw6g6yC0WAp5a8LIu4RbyyZMQlm4EBheXTO9Bxb4P1RG6/3nUUu9XtdJ0c7
	 n0poN9hUAk3VUHCZ8fVd22FibYZoakHk6wVajElsV4JoUcE5pQyN6MWGHOIhR/FPA+
	 xxpHUb1k2SzFfqubY29hNkN9b8shoBOMgpW7t1G6cRuPmopl5JitHhndM5vZYFnyJ8
	 hwZeU0iHaJT+Q==
Date: Wed, 29 Oct 2025 15:56:02 +0100
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, Carlos Maiolino <cem@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: allow file systems to increase the minimum writeback chunk size
 v2
Message-ID: <20251029-zielorientiert-pritsche-eedd6964dab0@brauner>
References: <20251017034611.651385-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251017034611.651385-1-hch@lst.de>
X-Stat-Signature: 6qjyetwbgoqiexgr5nitmnw7eojd8kuw
X-Rspamd-Queue-Id: 28F4A160013
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761749767-846948
X-HE-Meta: U2FsdGVkX1+pD8VF0KlsLYlF4JHnSrFMk3LcVdrTJufhoqgHooHRI9acCXZpfWn4fZBFtobXQzjiusLEqOmBnsVcwsah98x4kn7QKMj6zRh1EcHSzH2mHsPEPk4gi9rJj/kOnbrFIRu95/Av+Fya/PZ5YcrX/B77CWh5XdcdQMQ3Rpv+Le/hpB1T7gJbS0n7DFn7JOYBs09gqRAxx1QD+Z8XU4/vwlTIYHIuzV2t+CQZNzTLcC7jMTasfSloAwGDx+ynX7Ldq0nBqf+cAiOhJyP1qUdw5VbiBNlPKlXTDHCx36uVbsCnOz1kXH80OmQ8FDHl2XvowabTdoUys27t4rFdaPARQGfKavVWRCgnus3Md8RXMuZOAibwfp7URInCdOeEmhYWnjRAY0uRBNuQ1NXwY2hSu+Wp9HBm0Pp7Fe5j84iXaUnnghFqBNRAV447z534b9bP+DTj1jsM3zJvzhrGZaUxOb0Wf4pz5++geYy6JwnZPbbDxN+p25UiRgaEoXK3nuaii1YMtPAAqPPm42cDYBLXpfzlbtO3nF3QX7LlVejQzVr49yp+QBGSjf2AYSg7NxbwpL7TGu9klf5pg85miOwuC0HMRb0c3lQexigzUnd2Y8mH16b9RnO2hyH557F9ZsgmGLMuhz+hey50fSN7zKlr4tKSpB+nfplDO0QyRB/usULLML+1dZl8NyiRaQwU+dkcOgM0+yPOcNrWO1Zw/0AvPnycFd2we7M2VQ+y8dm837AllaGk9QpZCBVPacZm3TKPpENcK7uMqVHL5nQrdyOsA524tbv1OyyGIV9R+M+KNJ9bheNNEy4CTgU+Z3A9bShOhBbCyjed206RU0Pkxo3MOp17qudv382uODg4oWXlAq7scY1qmRxt4Z79OTncj7qp1oIvwEpbJ1tngvJH1kBkih41jqQM/vAnj4xUkm7bFROxmUFywHDuGKMQNSi+hwzVHg1C1hzwMQq
 zIyUQATA
 l9EH1VIVk5ZpA9A7b4dxGe9ULtM9W1bnJsu6aFy3UuhgTmbs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now queued and pushed out. Sorry for the delay.

