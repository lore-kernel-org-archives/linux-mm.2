Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41E5DC624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 02:42:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9DE46B0088; Tue,  1 Sep 2026 22:42:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4ECE6B008A; Tue,  1 Sep 2026 22:42:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF0EB6B008C; Tue,  1 Sep 2026 22:42:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 925F96B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 22:42:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 10D76A06ED
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:42:45 +0000 (UTC)
X-FDA: 85167274290.18.A03BACB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7600A80006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:42:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NAjcIJTO;
	spf=pass (imf02.hostedemail.com: domain of mkp@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mkp@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788316963;
	b=XI58VsmKeH6+eAwg1MTZDDDzEww9lwVCN0J4fS49fXv6q16zmo20daMdwcnXkvcAYdHHUj
	PUQ2D+ad2oA6TFknHubn5wl0DMGWfTKwCUfJBObwGU3QLs8qK7gq3eJwcqFcF90a21S0VC
	spDvDqyO2VY944Vx5hRvUE/cOoDaYI0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788316963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MDrYntgOMTi6ocL58pgFzcqpX1F+wE38GAJwY5mRR+U=;
	b=cGN+sO/A2nnxpMVKhCRPzDEe6gThSLyM79E7CWmb6wAcgYoQI6o7vtsDO0BzglLJqO7RGg
	d/P5tS0fs/cJ8fKxVzxRv/adjZbCxDYitt4XDI8W8fKRKUX3n5JVIIkWQlX7AlpX/gF6v1
	JIUvEnCE236G12n/I64zuXgeEySCPk4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NAjcIJTO;
	spf=pass (imf02.hostedemail.com: domain of mkp@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mkp@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC53543905;
	Wed,  2 Sep 2026 02:42:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719FA1F00A3D;
	Wed,  2 Sep 2026 02:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788316961;
	bh=MDrYntgOMTi6ocL58pgFzcqpX1F+wE38GAJwY5mRR+U=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=NAjcIJTOBEMoOM+34V1M1t7rYDhsQzsY96Oxt+/8fXjZU1EhQvItzc1Awvskb+uqa
	 IfH+TtD4vkldHbquzgnKIdU/H46+2e7MDI5BGBZ6sMSMoeE65ZASX8WMy7r1/0KTcC
	 ZyUEmns5GwM1hUatKb/dMCiTNqErX5QiV4pY/FG3oQNE//88IsBUMBePyYhIFHjnPI
	 pMPLShAe8/I1+U3pilyXXVDbwOiF+b2bidtyWbVg8CnMuxs+xJQHOfyt2YL4z/CbiC
	 1lnvMdRXSd7wCe6IKv33wukxGW2P9k4Aun1S3TU+pFdXG46uz/ODPuU6jyQcR7rIRq
	 ryTr11LLdMbeg==
To: Mike Rapoport <rppt@kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,  Brian King
 <brking@us.ibm.com>,  Hannes Reinecke <hare@suse.com>,  "James E.J.
 Bottomley" <James.Bottomley@hansenpartnership.com>,  Matthew Wilcox
 <willy@infradead.org>,  Wen Xiong <wenxiong@linux.ibm.com>,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  linux-scsi@vger.kernel.org,  target-devel@vger.kernel.org,  Hannes
 Reinecke <hare@kernel.org>,  John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v2 0/4] scsi: replace __get_free_pages() with kmalloc()
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <apK13danJIU2PD8f@kernel.org> (Mike Rapoport's message of "Sat,
	29 Aug 2026 13:35:09 +0300")
Message-ID: <yq1se3sfk71.fsf@mail.kernel.org>
References: <20260704-b4-scsi-v2-0-7d2d21a810de@kernel.org>
	<apK13danJIU2PD8f@kernel.org>
Date: Tue, 01 Sep 2026 22:42:39 -0400
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7600A80006
X-Stat-Signature: yj5cjzj9p8qy5babce9a8g8zi4yk1p78
X-HE-Tag: 1788316963-486410
X-HE-Meta: U2FsdGVkX1814iWYQFT0WjVfpIMSzsx1ngjF0WhBuMMmZgRMO2KcHHXdoo1ACX7bh+7ezBtshr8zlQEE2EcilZ1StSvAZfnaNeb7izW/sQZnZwbHkVktpBVUcpIckeKKSmKN7sk9xw1ZRfYtrVKopE4a/UbIhu/w1cbSlXQscOHOdvym13VM4nPJdkI12jsxpSVdIQJ/9JUwtMWEmkshySj7rnv6VzoKLyTQBvNa9yjZ58yKMW1b+H3Y+Nok9H5fZKZSqUuDajOUolROvo8BNR/uYYPOn6iLQRFkvQ9OwvPorOgjfr126YK12+h2P143hpXi1PWve00wUWxLBW7K6FvoK6rKou537X9YSDZ7uU5LprH4PTvme7tvhn3CALXOOlj0W6datJLva4twhtJbav7H3w91CAaNo8US37VcUbc9mt7JZ+brqH2v7BQnatHTTF5s25AJltgyB9P9MuB2wFp7+nwzE0taYVARGgzIuDqUi/tmexhleNwejItJPU9hqKnMBQOpNCNZhnJ2QVtYxqD8tiWbYIdpJhiProxT1fijwom8nib+iyozOx3HjxJAAkUjdN6ocvpY/Ac2ybDdqLFJQ4cdhQhg+nhUMkC4lgXGKtRxT0hKjX6anvoMV5spKLCpzHOKBA3xb4bpuN8SqjbAQpSxwjzh/1xRnhKaoeBhazvnag1gc/LGBQxoNNKL0AMgSVfYI7Lg1K9KmmyNRqZgivl7oH2CX457Pjj6z5v8tMr8ldLf8FqQoSkzaBkBTSSOy6NsUgvoRO7skeF8DdhblSJ+N/HnxuPe56zeEM0T+6gw/TZQdRXyPkjSNSakmfPPqdVEfhbIkD7/Icg4uGVXK6cS7yiwKyELHzKl7uZRy8zPQph2NWsfFg18hesqDnhCdOSRJDFf+gnJaoSniUtopNgII7iy5defNup6Lwh+SXmscJiZWOdqRMa9/KG1j+iz/waU8FiyMe+1xtD
 8fsUSBfz
 Ww41z+Ieytzs0wxaYrMsomsCU+9VMmnvkvfiRQ8vTcw5yq10UJu5lMhOJd9z6WfrAKq1Ch7sH++hqQ849GYqiZUCR+85s/U3GCZbak9Vbw2rEmqjM6Vs1aMpbpiWpFunBUDdeNjkkBATv2k7bwvNXSZpm06BBWzeeqts+ZGzO6r2KOFxY+Eh+bqtmZGL+fM9kySZxzDyQJhSaiLk28NavmDiK3/7bNGJPFBhErAljAbsdv990g0OE3EpQW8Qs1NQnoowZU/L2Sy0rVowGHvwGz50OWqJclohSCnB5kNZsMWetxm/2zVg8ShBdWfSRJ0phIG1KtnskG5zEzgrKjiVPvnq7dg2rUOwen7OPxH79VXn9amJEbRGO9sDdSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Mike,

> This seems to fall between the cracks.
>
> Do you want me to resend?

It still applies. Now queued up, thanks!

-- 
Martin K. Petersen

