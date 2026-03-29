Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE029F3D5FB
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 15:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46D656B009B; Sun, 29 Mar 2026 11:50:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 444DC6B009D; Sun, 29 Mar 2026 11:50:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 359FC6B009E; Sun, 29 Mar 2026 11:50:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 23B926B009B
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 11:50:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B038C1B807A
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:49:59 +0000 (UTC)
X-FDA: 84599536518.05.D43D360
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 16F041C0003
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:49:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rccDmTva;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774799398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y4ye14QqSmbEhKAHc4l162ibE3elER6IAYBpr3CPkoE=;
	b=ZLW3br4bqjuoKx79XAppqN9gpUWpyKav6dUbphZfLd3p6yi1EgIZezspFACOSIAOxtu0/E
	CDp5/Fun7UuDCMMpWvZQB/7hrG4IFIGuBApT4/EhP1R2B9lnEFSUK3tnsXJau1uZOI2HEm
	DsQUH+ZsA3I9Xo8oFGTPFEvoQ4v3reY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rccDmTva;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774799398; a=rsa-sha256;
	cv=none;
	b=gZq07A6dkEfgL4MzBguV5mx48r6tNO1lPWyDFLwPxAKwH+i+5hswiYvdmMKB5EbfF8L/N5
	/f5SvVoTajhzHx0esGCpqr+xmuVUh4a7+KpGS1M8hbj5UaYGM4VVj/5kzWTSy1CrImHfAs
	LNiCwZSn58cdGeUOjTWxAPWz3FTn7IQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8CCAC60054;
	Sun, 29 Mar 2026 15:49:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23B5C116C6;
	Sun, 29 Mar 2026 15:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774799397;
	bh=iE1Cap7oN+cp6nkIZohrvPTbgBqghi/30U/wEpUeb2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rccDmTvaNBFtG9O+4KtDSMXF6lJD4aeHtHbnhdOu9vkiC7eSwr9SvG/jFYNbZNc6g
	 JN+OX3Hr2QjdpnVuQvJb1sP2J341QhyVxuUZSXP7gH5k+LpF2yNH32nZCmSzQaZ4c2
	 fwDx+1W9h5Rlffzx2ysJkKIAvndzh54p+HfJguh/edCJFyTxzeTUWob8Hbpcb7CLSu
	 fDz7G7LvlieYNbfcQslHnSSsG3DmcNdDYBzNcr2IT5cBrFv650AtxtAfZAJsFMJepO
	 e5S0oYofBVoqC4N7U/lHOE9maIIgdhrzT0uM+XZBWBF3Hb6MSIXMeh4nuGohvpUoHr
	 w3FkpWiHDbqkQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"# 6 . 0 . x" <stable@vger.kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH 2/2] Docs/admin-guide/mm/damon/lru_sort: warn commit_inputs vs param updates race
Date: Sun, 29 Mar 2026 08:49:54 -0700
Message-ID: <20260329154955.47813-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260329153052.46657-3-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 16F041C0003
X-Stat-Signature: yndtbq3hjsggesufdo76ae3w5o93qrah
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774799397-125592
X-HE-Meta: U2FsdGVkX19fHr+diL55hV+xIeK6dInun2ojRPiSIS2Hf6a0ZorKvpxiZpLybAeftdKCwZ50XbMidqoLfWtaGTU/TqLrHsOYr2DziM9SaSqpvu+eMumPihYvLAnr2ekYYj6cUh9QCEC6FOCHHP1wc6cX/DRlK/1Chymex1tj2TMZcDHAgN1ileXRIyzHaKdmkkOfObVPYKtlNeFI5Bgg/d3bYanViiLGNHc7/ql6KZKzAIIuRtf3+hjuBs0m/b5jbR38sX6reMrGZbbBAQWn2SE4eyOrqenXB+9IsZEEjo4iYbIHWmrGfNIlyJsoNUAqGHQsHHz+FcYSX8N5z2mugy7vhkQ0EomkaqvyfQv+O/NNH0QBu4nRrgNoUW/nOaD7T2sa0RZw8GdToZuUmZH8/SDB36qG6B/Yz0Y6CkJRcgP0AkDXYlcenUENH8eiJ6K0gFjYyjfltM2/yNZ5W2sVFSvrcwDtkP+vAd8EnY83hSc/fM6Yvw5CV0ocSB6wzzwds1sNVrjDwxsFdAwjXEej3q+BgjlNdDZE/TW/idsvb5RHURQHjUqFh97MP5lUyjTUuKVHuF/8CPLl9crtTE4cAxZWm1NqaYAfMtmQIPXV2L62RY1igCUJ+GIJZipcJCVPqQdibSmjPQTyQXxrrXYZ7TwezkMawsA8rWqLqZ7v9nzZk4QTNiP7fSbK04tZj1xg6zXTFvtrMfvsfSHB8WijtltM6lmzn33o8nHGEagm2SC7JmosJPlabC+z4WCmZYw/Zv4n1tljZ+FQVBTXkMmE2f8GBtTAKDKdRPW/Nx5dLwP65z8Ni/KiucBfw9qschc9xF6wwYlx+4DkYHZpVPp05Ql2PDQAsdabwsH8yTm/DcYUEsbMky5hCTdSTA20bkbrgPTJXjTBTHqEBuXV26VsnQ81kOJ2YvT+TMNGlDhv4dzDmifjKfBs2NFvtROTHA4vUs1N/iFxJylBmQZAFqR
 8y1nZefR
 7LsdXju8K1CKyEdVszdQuFEoYhSrkwFfVhxhJdStdEpwefDTPuu/hbKQsp+Y5x0UZPB/5LVtffOSAxG0nUIaMHwvvLq7FDV1TaEFfcLCBBipbnXjUAwIoF3/1MMBaXwjQ4L1Y5yc7IF/zrx0sSfBLfbntwe/QaQdh26OIxYaSJwji0tJcGom9BdDkochsT+fHbNB5eZbzxHsZZTcl+Ob/YayEMgTKH6qMVtMcFVQrVpmQkpk8NfCPuE69P1BUTlhAx0za4G697WnKza5Fc0NBgexgoEyPGUmzvelWkLRQDOsJvFLnwjdcxAQ8UYJK/8xt5xtPZxUf+OqoLt0mnSNXdrDiTu0rB3usJ4gjP0dnInFLuo91bZHXcX7lM/zBmyoWgR5BlcyxcWLmbCdCsTzgSkxsXXlw/xkE0g2l9K3Kiw7Tyy0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260329153052.46657-3-sj@kernel.org
# start of sashiko.dev inline review
commit 7f5e14b7be3b4aea36d62a6c529ef25dde22e973
Author: SeongJae Park <sj@kernel.org>

Docs/admin-guide/mm/damon/lru_sort: warn commit_inputs vs param updates race

This commit updates the DAMON LRU_SORT documentation to warn users against
modifying module parameters while the kdamond thread is processing a
commit_inputs request. It states that violating this rule can cause races
and undefined behavior in the kernel.

Link: https://lore.kernel.org/20260319161620.189392-2-objecting@objecting.org

> diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
> index a7dea7c75a9b..14cc6b2db897 100644
> --- a/Documentation/admin-guide/mm/damon/lru_sort.rst
> +++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
> @@ -79,6 +79,10 @@ of parametrs except ``enabled`` again.  Once the re-reading is done, this
>  parameter is set as ``N``.  If invalid parameters are found while the
>  re-reading, DAMON_LRU_SORT will be disabled.
>  
> +Once ``Y`` is written to this parameter, the user must not write to any
> +parameters until reading ``commit_inputs`` again returns ``N``.  If users
> +violate this rule, the kernel may exhibit undefined behavior.

Is it safe to rely on userspace following documentation to prevent kernel
data races?

The kernel is generally expected to be robust against concurrent or unexpected
userspace inputs. Does addressing a data race with a documentation warning
leave the kernel vulnerable to crashes or instability if a user ignores this
rule?

Could this underlying race condition be resolved with proper synchronization,
such as locks or mutexes, rather than documenting the undefined behavior?


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260329153052.46657-3-sj@kernel.org
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260329153052.46657-3-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

