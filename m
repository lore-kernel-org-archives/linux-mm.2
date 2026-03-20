Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0EDB1098796
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 15:17:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECBA56B0113; Fri, 20 Mar 2026 11:17:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA34C6B0114; Fri, 20 Mar 2026 11:17:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB8EB6B0115; Fri, 20 Mar 2026 11:17:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CB6006B0113
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:17:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 80DD81D3A9
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:17:39 +0000 (UTC)
X-FDA: 84566795838.12.2F85DE3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id B6F7C140002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:17:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sAZHewiW;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774019857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y81w8+nWcYaavUrsZIUEB1oSlxDqwkIWlr6MKQodSI0=;
	b=Ly8GbKjpOqES14k4ZeLr0ET5Zb+6yeTu/yfIbts/KwfOx8T6cM3iW/7MFWS3oT003Y8y0I
	bFYXX0m7mRe4bMryPu9wdQRIrCXkoauk/JzkVFu5+9ILWbcu5zyv5KFCTx6WlRDsxvS3BB
	xb7Htgm5601zXBLam6jmF0QMBp6wX/g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sAZHewiW;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774019857; a=rsa-sha256;
	cv=none;
	b=YsKdYC7uwH1x9avL4FhQLd30SbVQJJtIUhs3W/4nWAWXyyi+fTBUb6H9xIfmjAVhkAVuSY
	xZZEnCtAKJknoFtmGJRzo/NVhLHcH7yzZtlcyaR4n95B1uZ6JZdRM5lK9POW9Xw1CMrasy
	XTm2i+NcPAGTAPLFCENLNdnH54Jf2Qw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D1F4340C1A;
	Fri, 20 Mar 2026 15:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D489C4CEF7;
	Fri, 20 Mar 2026 15:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774019856;
	bh=grkTVeJT4rKD+G/1Q+egwehQigyFRB+VPVj+azdo7e0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sAZHewiWExVTt/zyFbzLIdCJD/bpTcUx3fFXkZjbR6wKEsW7ip/YwFCzNC3CwykXJ
	 w5UpXWdWe93cL6g+gJP9CVwYzxK8GOTOvJ3lF6Wf0AI99wfokjkUr4VCd2AJBtj7AD
	 pa5VlsXzi8qcT9RN/YdnAypXmVremhTxo3nY7+Ttpxh1U/0D3oBJUqjmUzn2ju/SAl
	 6YEffy743Q1F9GS390x2hrnmTUIitsfIoIPLHulvQOHVVDK8kDbIn6CoF0Pfx8KynQ
	 iVY/NTMjmlGIlL3O8xkQBxLmSg5GkZSjX0JEmvcvLlPOD9x/FCx97QX8Gu/v4cDPrQ
	 hQJlnR4iloMjQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [RFC PATCH v2 03/10] Docs/mm/damon/design: update for context pause/resume feature
Date: Fri, 20 Mar 2026 08:17:28 -0700
Message-ID: <20260320151729.99156-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319052157.99433-4-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B6F7C140002
X-Rspamd-Server: rspam08
X-Stat-Signature: hpjddermubuf35q1cdprofatgpepkbtg
X-HE-Tag: 1774019857-438175
X-HE-Meta: U2FsdGVkX18KrRuOLd445rHUiLzAY7eLaf4JyQxuis9pw/sCkP7MFcV4HkyHCz9dkg0gCL14Gc08+ftl6Hz/IN5MEzKwrjqQpD8thRBJktYMXJPOYYIGE9PVKX2TmiJn2gdrZhO+4tQA8t3NK2x4l6nf+QS6Hmum+HjAWkOgfd5hyTkknvICF5YjEGQ/WBFVQy+uz4yUCK9b1DfmdVCxwtgcDAygDkO6zdSlDPn5E2WH07wOqG38VW0EUxQglRLGYgEmdid2VkqMRYGemJ9YadbjITcXD7jTtu9qKdxSkGzjz3+IriW955lZ7Az23AHG743uy20ieKwKwzr1NHW5xkC3UR5FO1mcObcGWcF5QqcMRtrxhW8hQQcb+KHkIKZzaTSDn4KVm0T46gx4D2G/idHrv0u2RGP0Td4LqJrwrVSHdc/oZULzF7drMVaRQjbG5F3p0Rvi3qo+4V1okBVcQJ/7g1FvH6A2awDBhxGe5nWuQYqNqAhL5XqIg4siPdi9l19VaI8fZfN2tQnEeUIwJBxaMbRCHUA4WZvfukN3MSkBiLZI/sw6o+8DMHjsLQTwY5eVMFL985BFPe/18MczWgcWrS6uGUymcJHr+o7kxwrHqc785viRf0683uaqv54xmXAF9tjb4+ty5XFZ20uftojRD9KxARFZKLjseJtyhwOEuvvWVMGUt5BjssTezBp83erdjXzPREZ2XnMPduWs2h56gMgTM64WxvMzwGzjVp9TSqvTQkxQxjYUy8xPhzIL6pd1Rp9vlR7ULEr/gpG17cdYFAEvghqx2zwro0o9YdNjnHc6E+4p/lkHtJWP1L0ilV9QNIuTkU29leKJZGaFkKxE02d/ESm9qRL5Ed3dTwi0Lis4TNTdDkLdlZWu2XpWFDtmxEw70lpHoicGh5NVHVXM5RZQOzIk//CFp9ripoKDC/b7dM2o447bGFA5HyFzzemWxKGXUFF+Wc92kA4
 aNurfwvU
 3T6IlDAPb13pv69Q1bBxg6UUcm5pPawECtKc32u02Y6FipmOV43EJEDJPWXmnOK1VRxADVYJwSEP4pIQ2B7mytZn23NkZFKBw1L0ydLaHj4T2zTWOVZLKhiW6KwgfJ/BUDMnTIjsJViixSTheMDVkTWU2nLpDLfMxq3FOwoO47AqCssQvxO+0ypUWw/LQdHWaXc2296enOc+/4A4qywyJsMu2zFImTxIYg6fEb1BYBxyPgDUukzkqt7HhIQXl6I8AEO7fUQT7GANmM03n4JNcJ0VNVhTk+5lpiQAH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 18 Mar 2026 22:21:46 -0700 SeongJae Park <sj@kernel.org> wrote:

> Update DAMON design document for the context execution pause/resume
> feature.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  Documentation/mm/damon/design.rst | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
> index 838b14d225193..e2e4fe3fb3986 100644
> --- a/Documentation/mm/damon/design.rst
> +++ b/Documentation/mm/damon/design.rst
> @@ -19,6 +19,13 @@ types of monitoring.
>  To know how user-space can do the configurations and start/stop DAMON, refer to
>  :ref:`DAMON sysfs interface <sysfs_interface>` documentation.
>  
> +Users can also request each context execution to be paused and resumed.  When
> +it is paused, the kdamond does nothing but only online parameters updates
> +including resume request handling.

Sashiko comment
(https://sashiko.dev/#/patchset/20260319052157.99433-4-sj@kernel.org) below.

: This isn't a bug, but the phrasing "does nothing but only online parameters
: updates" is a bit awkward. Could this be reworded for clarity, perhaps to
: something like "does nothing other than apply online parameter updates"?

I pretty sure Sashiko is more English fluent than I.  But, shouldn't
's/apply/applying/' ?  I will update the sentence to "When it is paused, the
kdamond does nothing other than applying online parameter update" in the next
revision.


Thanks,
SJ

[...]

