Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8379C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 21:44:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 326686B007B; Fri, 25 Jul 2025 17:44:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D7C76B0089; Fri, 25 Jul 2025 17:44:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ED196B008A; Fri, 25 Jul 2025 17:44:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0FC0B6B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 17:44:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6F1B516084B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 21:44:31 +0000 (UTC)
X-FDA: 83704116342.17.1F11505
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id C37A4180008
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 21:44:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GR04n0h2;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753479869; a=rsa-sha256;
	cv=none;
	b=NUXZM9LrntKqScc1WXYgFsQ2edL69asswGoK2eS8INOUBey7GAOocHO71Dl+g7RgcZ8+FS
	l9RbkVLuvLpzBo4SR4wKZ/852KTs53QHFwNcnkVz7gDYj/jbPE0JRllyxjSgQUuh0MfZEf
	9BmWNmj5yHJosD1wcVrlf966vOaFjvE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GR04n0h2;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753479869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gV0uiHQiPlueC2H7utxHpOACMb1EJSqyHPmIgUY634Q=;
	b=YWgkKbXVxIDYkEzEByO5C3TYgBfBTpTWZ6vpDXESvuEbA9+IoN+SkW1E4gMZljBaOEYzed
	gf1KlrQ2pov+uClKk01biUJpnmRo2/JcLlA9XDdMedPPFj0TI/VM6BNuQDJtY11XJSYF0/
	7vfhDeWDUDD8sYQRejx3xEE3KxC8Wwg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1807E601ED;
	Fri, 25 Jul 2025 21:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACB2C4CEE7;
	Fri, 25 Jul 2025 21:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753479868;
	bh=Ur6WVXT+zlU1qsY+I4gZjcoE9NWvZt+RtiuwS/szdVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GR04n0h2o7S/xCW5QmNqXw0mx9KKrV7Bou45GpHi+j+ANJPKxQLvZ9PfLOvkLueoV
	 iewzYhackZhg3IIg+T1egjF9vzT9BPwour7oxs0Wr6PudfsqI3poqM00mQyLWTYBGo
	 AZanlJD+u8n6eXSv1gyH24ANwMLfV0b6RIzaRaTkMf8G7E12UZt9brJCZ2KWVAWopg
	 TSEh+G3lWKZsoIUbBonjuCtCzJwprqRRQS5LbTPrnoIJ8g/sLTf5ykqeiYM+8IDg7y
	 auhemNSr4+RXgkM8j8FyY3KBk4rb6MPxXRweam1z4jN8XErKCM4GvM+aurj3r4zGrB
	 FdcrV3bIMLVRg==
From: SeongJae Park <sj@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mempolicy: Clarify what RECLAIM_ZONE means
Date: Fri, 25 Jul 2025 14:44:26 -0700
Message-Id: <20250725214426.51487-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250725173546.2295177-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C37A4180008
X-Stat-Signature: shg6hmbbrx8t7g4udut5m5kqa8hpzfzb
X-HE-Tag: 1753479869-855178
X-HE-Meta: U2FsdGVkX1/nt4S4pdYwYzM3WITAJCaSSkUMxVA9+W4u/7EYRriw0g4Y8S5zIFmAq7POTliCTeXx00TUQRcMzELjmoRhY/swnsVVjmljwARdnCFFqtt3ysC5qYyNAjMWu5GxmRcDP1XYa9SWi7PS7hYkEA54YHyMUHu4PNPKpxRKnYbIGe0Tr3rc/C0o1ZO5+IXN430gGtCCs5mKWRM4EiDevz8mjcpfbiXejWs5cHceFlvj7b+JEPoDSI/KMCtHh533xPhbW6xRfTGgBvplHZODB0xrSkIUrAH2hZHAZdIkSyfqsGFjugKuemjVIkdhTJ71SNZ4pvtE4IXYkWAyXqzT9TlGtlGtVA14WiTaN95Wh7ctcSoyMpMhajdgy35FfuPJAy7x7/6kONEf11xVBqQhXDNoGz9GZrKGV7ki0tN5VodZ2Bi21uXfm9vLlwLzxKcME0Ajr3kU8SMjS3bE42OPvxPZbiAqfmfVcPCSNbw+o6s+etSOxwsNVBAbE9YsjI3eDxaKF5nHh+5oOPa2n89IkqpkpoONdg034YLShiCTXjqSIoTBIOZ8iZDO9UWcWLxg6Ag1DeymqlGXT3oXmK0hTgJkletbPcPDc31Fz3/K/kE91Si0Ddi6uEVdAEZh2mXR609LU2paD5lIIXapLKRNfSgZLURr8lFpBpLukH6tA1Cd0t7c1g5UWsykao5QxxQSWSqoQMbaZEGtEh0INhkD0tXV+9xVHeDXQCbUikYFw12gQO+NwKmV0pZ0LAzsW4H8PFyy6VPyUANCaKm/Q/XZJcwC2m4Dt91i5oGv9xu3hRH+cJpi+3Y7yau9H2hNsqZ74DtxgEDzhcUpg519Iq6q738xzOOcmMGEB4jGyhPcfX1eXtm6AHCVNUElJglHEnmEOM1Ut4mI+jIjzB76lqUS4kmA/T2wRbnkwJC2pcGxNk9VM+FbJsxoG1nXLK7LAJNMyDaAd9M3JxujMkM
 Y13XgOfZ
 Qs/R2L9LmyrfZKSC3w/MFpZOJmjrpcxQs+zjJNHEkKX/CVXZ/1/UeLUHo5OhpUz+bEcmyQgYfoMjAU66ZMCgW6bg3Tq5jH5mZSBBspBMCZo3JJFVB3nJOkpC7/NL4fZtx+Fi3uepIy71X5GidylH+fhBy5irBsEnV1pZy6mw1qihuPxsC3eWUp3QRjvXj0UA8aL9pLiv4oEzwUDDSPPzNHRas352EfBSZHUTm0Vhk1JlDOb13Eq1CvqFlb5gahE4/8ZEgrov0lqgUfP6yg7W2m2gr7DCzvqws3mQbPY0S3GGBypKmJoZ2H9jwFU653EK5CEHBQrZ0GKgxyqKwHAQIdvrWFZ1ywsgY0ffS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Joshua,

On Fri, 25 Jul 2025 10:35:45 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> The zone_reclaim_mode API controls reclaim behavior when a node runs out of
> memory. Contrary to its user-facing name, it is internally referred to as
> "node_reclaim_mode". This is slightly confusing but there is not much we can
> do given that it has already been exposed to userspace (since at least 2.6).
> 
> However, what we can do is to make sure the internal description of what the
> bits inside zone_reclaim_mode aligns with what it does in practice.
> Setting RECLAIM_ZONE does indeed run shrink_inactive_list, but a more holistic
> description would be to explain that zone reclaim modulates whether page
> allocation (and khugepaged collapsing) prefers reclaiming & attempting to
> allocate locally or should fall back to the next node in the zonelist.
> 
> Change the description to clarify what zone reclaim entails.
> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  include/uapi/linux/mempolicy.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
> index 1f9bb10d1a47..24083809d920 100644
> --- a/include/uapi/linux/mempolicy.h
> +++ b/include/uapi/linux/mempolicy.h
> @@ -69,7 +69,7 @@ enum {
>   * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
>   * ABI.  New bits are OK, but existing bits can never change.
>   */
> -#define RECLAIM_ZONE	(1<<0)	/* Run shrink_inactive_list on the zone */
> +#define RECLAIM_ZONE	(1<<0)	/* Prefer reclaiming & allocating locally */
>  #define RECLAIM_WRITE	(1<<1)	/* Writeout pages during reclaim */
>  #define RECLAIM_UNMAP	(1<<2)	/* Unmap pages during reclaim */

I agree the new comment is more holistic.  It explains general
zone_reclaim_mode behavior (how the system works if the mode is turned on by
having any of rightmost three bits is set) well.  But, I think the old
description is for the specific mode of it (when the rightmost bit is set), and
the place is appropriate for that purpose.

What about keeping the old comment but adding the holistic description on the
upper multi-lines comments block?

And the behavior is also well described in zone_reclaim_mode section of
Documentation/admin-guide/sysctl/vm.rst document in my opinion.  Maybe putting
a reference to the doc together for readers who curious about more details
could also be useful?


Thanks,
SJ

[...]

