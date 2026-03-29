Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 969C2F3D61C
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 18:06:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE8B16B0092; Sun, 29 Mar 2026 14:06:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D99226B0095; Sun, 29 Mar 2026 14:06:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C88186B0096; Sun, 29 Mar 2026 14:06:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B2A596B0092
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 14:06:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 54AF11604E8
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 18:06:21 +0000 (UTC)
X-FDA: 84599880162.10.6C21CEB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id B9A8410000C
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 18:06:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=tr2tVTF1;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf05.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774807579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T0oBJHQcF5Qq9kL6sBM6aAHIZn/LTcqeG2y+IZ0wBR0=;
	b=IL/xx2vCnQpKtoeB9WpfbLXCvYh/434Ytv25so0sA9zG0/0IMeQdlZAcpSnjddyUwAuMfd
	hK6HUSRNMw5NuM9ZlIkCtP/bzTXmfuj6C70Okd2waU/IIYBCeDIb8MdX+QBQ+OD0IKFrMf
	B8OwmvQpI8oC2N0uyCZ5u3QiKBCibMA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774807579; a=rsa-sha256;
	cv=none;
	b=sg6URHO/9OFmW60yOrVGCx6D5SM0OyQc7AKWC+GGEaLtBoXqgEIQdhOalPPApM7h51NiBd
	oIJMXAGQxF8/jv4ZHsLhM1hVAF1k3mq5e1+Aisyuu4yufmvQe23n0xz0LXQ+7b5A2dk4fV
	MAmMj1whj8oYZNnaL0FoW8JhXIZvADs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=tr2tVTF1;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf05.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A22060054;
	Sun, 29 Mar 2026 18:06:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35054C116C6;
	Sun, 29 Mar 2026 18:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774807578;
	bh=fYkZJVxP84Kryjvvaxn8j5axvqqmkHDBm6BWLUMry58=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tr2tVTF1XGw3NZgrZZQHL68G9BeEHSGVLujgo17G1IKBrJ/dYvnpxvNoDUSVb3HA9
	 kqEA4qTJYDQRMZFPeoj+WNCZXsK3RdX7B+46ysB1VDXqyDEy2P3bosXeuXFHnjXIR7
	 zju9AB3mDNys/6B+xEyb+c20kZ7OT/eoa8FPdfQQ=
Date: Sun, 29 Mar 2026 20:05:53 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"# 5 . 19 . x" <stable@vger.kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, damon@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko status) [PATCH 0/2] Docs/admin-guide/mm/damon: warn
 commit_inputs vs other params race
Message-ID: <2026032915-library-embolism-b48c@gregkh>
References: <20260329153052.46657-1-sj@kernel.org>
 <20260329154917.47598-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260329154917.47598-1-sj@kernel.org>
X-Rspamd-Queue-Id: B9A8410000C
X-Stat-Signature: 4fttykntwhm49qp6g8j53j7q6n3spwca
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774807579-915837
X-HE-Meta: U2FsdGVkX1+ROj0Asn/wzRJ3VaH0eB0K/gN0b3vn6NZ+QH69gW0Jv9dE1JhZigB0mJiGMSmxRUW3ywctQJX5T11z95gKuwTtNzam6W43QTtM7AQONF1m8p2rFWW4mlQtFe0HTqSK6bQROONq60xAQZxtT2PhYAIblbGcfj0mNGuY9KBenU/vGeNNfVQY8M+JXaO1DrfqJpN0EylJgtERzKBC2LiSr8Ii/ENrbsAuROx2XxfLR6TtBC/hqGBYweLgiVvFf0+HVEWN4VeEx+JGfRVGu1SI+GbP/OMg1s0KbDWmqHZh/7T5cSklZqAqR7YhEfJk4DY2c5+hFZHlRMmMCXsVgfPFffGxaOzdq3e7YtVXs12TKVCgrw70wQwdc1CJUsTJu8b50gX+0fT/MgkLkfkBtB3LpUomXlzlx4LBboLIgvmwViPsqhz8TXgZgZrXdtiiWW4gs6yCQtP9AwUQ1kI2bLUisAOkAMZNihFiAlSsUKGFqj/BAmCz3e6AtZtxJPZNTaRu1tN8MaOwijVBrt0yEiXzKgRWkxWXu/gj/8euJTCjpLLGkch9D4re5KNdjBRjXnv7Uinab/3LGwt9qjLKubfctxBs5T+o7GjlYlVs7jCqHlmCpOVqWbTDloxN9CTEgTqMNMYY11fXmZQ+ZQpTxpDQk9Ioz2N82eYrm36GB//pquob3MF1sIFHvNjFinReuCYWLNInr3Tk5sX00bSkS27oiFNFzmPSt05cLq/1lb2kfm2Y9TZsHdNmYm8FbvxwvsS+9DX/bNtEyg6e9UQ4sBRhnhU1PDwrlyqvjwvrBCcrRJZdHSK+SpNprGu21XyS4KPb2vOsqptgd0PFFtMttLZy/gQCqcHAWTnIQP0lWCQ4I9WfAv2egS6PYwGtGjAosLsr0ML6SktXVxRlrFyVxOKZgeUYhewjdrti6TNZGxvu3Fc26lzKIh6I8NPqPwIuc7gWnQ3feIWzdVG
 4AfUsXpW
 qhB1We+sOX1JNAlx94KpAJTRpeDBPT5J7cSRYS3aNih3igJj0vAaT/rn39KMOEwyKZSa3SQyCDOz7eAoZ1kM4MQ9JSspoWkHwyQ1op6OQToLuCXafLgrx0GIaebOknTtAG62YuPwr82oYPfK3JX53NlHf43mZZOddvvJWG3OrwfqaSNaAhg5fjPfCfCD1beVtS/Ir55GlQ4qtgQ52gEzpbeNVQJt5RW37B4fP6iKZ/RjmRAuQF0vWK7m/z+BZZPReT/USIbh9gqSvulFuD2gPjskj+p2Smqsgiobtvgu8un51PpwMGEyMVAct7MGYRj6TI4j+cZHGc/xeP2RUZcR2quKLNsv0hWXjCmXEVPXPg2ishwEyHb/PGr4LtzsmJxXNx7SH9D4IUCyLu38crKtvw0B9wOLMyDACz1KE140IS/QIR6XybsoDsP0JCfpVUFG9oAamEPUqDZHzTTY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 29, 2026 at 08:49:16AM -0700, SeongJae Park wrote:
> Forwarding sashiko.dev review status for this thread.
> 
> # review url: https://sashiko.dev/#/patchset/20260329153052.46657-1-sj@kernel.org

Why are you doing this?  If we want to see the review, can't we just go
and look at the tool itself?  sending it back to all of us feels odd,
especially when it is your own patches.

confused,

greg k-h

