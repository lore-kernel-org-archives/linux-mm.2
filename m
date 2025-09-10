Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACC05CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 22:23:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5ACE8E000A; Wed, 10 Sep 2025 18:23:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E32E38E0001; Wed, 10 Sep 2025 18:23:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4EF88E000A; Wed, 10 Sep 2025 18:23:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C10498E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 18:23:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8D8771DAF28
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:23:27 +0000 (UTC)
X-FDA: 83874768054.08.1F3EEE1
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf28.hostedemail.com (Postfix) with ESMTP id AD162C000D
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:23:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=WpMAvgD6;
	spf=pass (imf28.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757543005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LM+55SwUsPANj31RCezenKuaHRhr9zuwNwXrw/Wq6K4=;
	b=FHOp7u1A30S3DgaCynjdlu9tSE72aeIdJ2j1PB+auYBQoG5RBbAFWAXSS1giQTj1OCRpef
	naQIUdvENzxvtfeHKH2w/GSKDhQkDDyFluS1IPxmO9PlndcyOMlSi11U7UQwaQPVRDTvwG
	jpEm2G/+4Un3GjDBjisz0ET5V7mFXuk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757543005; a=rsa-sha256;
	cv=none;
	b=dy4sS0VRdecbqkS1gePEVrznM36vjOjOpiiEhjyDa0QAJ4UQuzPNgz6TXhmzyoHdBom0XW
	11X+w/YWOp+pTln5jIo4vTqLApMp44UxgPhLTOWoDUP86Cc23d75tgex/sGGZ8ehamU719
	cOoO7tlJpgFJPqslQwbje6n/nK8miuI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=WpMAvgD6;
	spf=pass (imf28.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1757543004;
	bh=LM+55SwUsPANj31RCezenKuaHRhr9zuwNwXrw/Wq6K4=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=WpMAvgD6GMATvItnqpD1VojP0d+Qfo969hz/SXi+3gGWPd1Lg23TH/1uBw8S46zQ9
	 66O+x+jWYOl/w+6y7EDTI1dUg2exKLaC2J3efjO0/MIZUVACdkqa7Esb4F4HAQcJzb
	 725zPQztnpwEJMgmmLKg5srvUYJnYMb+Jt6I4zjQ=
Received: by gentwo.org (Postfix, from userid 1003)
	id BA5364033E; Wed, 10 Sep 2025 15:23:24 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id B96034033A;
	Wed, 10 Sep 2025 15:23:24 -0700 (PDT)
Date: Wed, 10 Sep 2025 15:23:24 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
cc: Vlastimil Babka <vbabka@suse.cz>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    David Rientjes <rientjes@google.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2 02/22] slab: Remove unnecessary test from
 alloc_single_from_partial()
In-Reply-To: <20250910115507.1991829-3-willy@infradead.org>
Message-ID: <52418c79-5a06-67b8-3925-d635e9c0a894@gentwo.org>
References: <20250910115507.1991829-1-willy@infradead.org> <20250910115507.1991829-3-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AD162C000D
X-Stat-Signature: ja6yy8ca8xp7616hn7fqf599rik94fxs
X-Rspam-User: 
X-HE-Tag: 1757543005-498506
X-HE-Meta: U2FsdGVkX19qSePu50rarZnFCNKeCkAhvuLC8O49DBIh794i9XbumZzCEEFhkuenmRVwSGqsVbcFpTfSNio4fhNAPbaUAuBZmWyWhNt/aPbjy/Y+xkKDh/+B/g7TzPRIp6aNY9X3RCtaMbLPGk+fgKKa8N16nBXpE1BF+NMMsvDMIn9srW5ZfmWr8Dy4M9T01+MjTgLQKpnrbi0N3MSTAC/DcEtj2oMsfVC+dKuzS4zbnt0YZ3T2SyQDMQ2aEPU+H5QZXZ9+xdDkIFQ7GnRG3OBl3PfZYCGLNm0+CNmOX+R2wt64cZwj0XdK86kq6SK6vS5exCs80qatvuTbxMn1u0JSBODGbA5AUh7HEdKiV1WCUnwLYHNDVai5wlLi6LdDELJ3o4U6yz2nH5HA1hM9drjxooDOzNy8lWyaR/NEZigv8uS4G2ibSAVi8zR3q/i/+AT8Ngq35qnJdN1w6pkd/F0DufAUST3JwEF7zgCy9yUxsWhzPsjJAgrBLXJSbR6v7EJRQ+RX0FdCPTbiIklDN7o2+7IwJYt2VAhB5Rrv9M0eXRuhlwxW1EotF+zNsYgDspR24PjJZOMga8uGPZzpeut1b3deo1abOBdYVajgqa4JyKmQsTsX5M8p80URZVXyfL+SHyppnqK6sCLZs7VDjagQEEFh5HoZFB0QHpWcY7/+a9T1+AUvL5vG+nEUME/gw3dPOi0jVSeUTlzY02A1q30w1RcGy4suIu/FzcwmcIPXnKNlw4oZWkrBK3FBB/rWWLPru+sx1S78fcLwuV/DL+suuGjOG9m3w6da1IGUk4yIVNJVljqqb2CJugiUWqUkgwH4PTRR9YX64mOzmzgS8MjhOA5XkeHWd01CzzSK5lMfnIrAMEm1kVoxh//fUIBcyvJhdkTdsAQdPQuJ3GUI8yegzyRW9fydq2GbDNVYLsxBKmxOVdBIcsJxPswwQGZHAQFhMt8d9ltxAHOnteA
 YWSNsh8E
 hKoCs47ZqqH5klIwNxLaB8lgV+1v1amf7GZszJxO3Ywxkm/F7Vx6BZ46qbMt5KP1K9k23m/QmliJAixqT/prCTYW8HI5aMKkYs0bL6UN9Wpe7dnFVv1RStyRFn9hzOtFq1YZMuQEDzE/DzWYs2pxElRR+Yr46dCtPhpavgmonIC4b+S6Dg0njIBX6AgCghVnzSog+bEI0lYooy93E//McJJEzOTn9Go8GPLi6iw7yQ/S/4VqRpUyVwPUcnkBN93qvXb0RTM2VpkVoL2ui5beSB7oLXdRPKJg7yYX2GPU9rwUmP8ZwWpVldaCY4gvN1/rVsfYyDuE5KI9oIuQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Sep 2025, Matthew Wilcox (Oracle) wrote:

> We know this is a slab because we already modified slab->inuse
> just two lines earlier.

Yea looks to me like we should do the debug processing before we modify
the slab metadata.

If alloc_debug_processing() fails then we know that there is something
corrupted and we better not do further modifications to the slab metadata.


