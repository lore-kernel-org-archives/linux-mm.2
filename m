Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 398A2606D2D3
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i7EFxg3V
Received: by kanga.kvack.org (Postfix)
	id 518056B05B5; Tue,  3 Nov 2026 10:05:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C9A86B05C2; Tue,  3 Nov 2026 10:05:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B91D6B05C4; Tue,  3 Nov 2026 10:05:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 233886B05B5
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:05:39 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B3239160201
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:05:38 +0000 (UTC)
X-FDA: 85394131956.28.CFE7572
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0F6CD140006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:05:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i7EFxg3V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793718337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IPfcmrcYcWX5lHrSru9Jn6n30jillltoM7EEkw0R5FY=;
	b=M0CE+ytkpo1GoRScfeV/f05AVAVws3/6HBX4dichWWNwoqZveZTADEr0lqVGHMxArSUBEW
	IWCN+HXDfkEOmvJUizWYptZyiJ/jUGD/JCpbUPUReNiYnG22iO4JH8cxFEs/qVWKwL+wAa
	0SBwHNf1Eisuzw3vOa4V/fv99r/V6Js=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i7EFxg3V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793718337;
	b=EYdxRDyVKh+J+POkmozV+kWAl5oKI00FTnZ9WHjmPpluBJ62oGvgj7dtsoZBVbSPAiUqhA
	a7hMPNMRTYc/OL7j4o3AMMsKM6NL3BBqSVmywt0BvR61HhM07CMYxd0GwL8wzEfP+GzI7m
	aQuelzeiZ4UMqzCzAofuS6GzIzpg+kM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8576060233;
	Tue,  3 Nov 2026 15:05:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE301F000C1;
	Tue,  3 Nov 2026 15:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793718336;
	bh=IPfcmrcYcWX5lHrSru9Jn6n30jillltoM7EEkw0R5FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i7EFxg3V7LiVQlqu8g676hJBANeRvsSGORz8SVztNkzVPMstOH8WIxPuhsKQjBDCt
	 Jmw3i2bsC8Nr9dlBur0QU12T0/idc3zOpSS4jruSjYWDlqHDfphVroG5rpf0HOkwY7
	 d3tPTNrgnLhntZI+F9MEB3J34SQ0hvuSOqL2dIVjnS3bElYdlmrJ4GUurhiPgO7312
	 0hdKRAcooUqT9/OF/D3wsE1mAW7cMg4am0VtyypFQDLBQDzoSCjuQZxP6EobwPLLlt
	 JpVGZ1H8EptRPXzvCCNasSFlCEErCWvk/Cqjj0KmyQhweuHYzUpdyX3q3fjT2zYGb/
	 OvneJ4V790e/Q==
From: SJ Park <sj@kernel.org>
To: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Aveline Noir <jm5905938@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Docs/admin-guide/mm/damon/reclaim: improve language
Date: Tue,  3 Nov 2026 07:05:28 -0800
Message-ID: <20261103150528.88546-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103120043.100887-2-manuelebnerli@mailbox.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0F6CD140006
X-Stat-Signature: 3zsqrad71wjtnykkrdaf6gbxpf7zs4k5
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793718336-69967
X-HE-Meta: U2FsdGVkX18sh8sBs17d9iIN+MIrlJYkB63TxnxNDYvbVGUGAA3AOR5dZWY7AZxOs+EJRZTq+ewTn5tE2nHC6RES2ohcdI+jWhCYiECRAAIZIlBM6YHZVDdfe9bNxLtUtI9rvNZ5NO3Bod1R98I7U6sSWB11N7GIQ/ETmQxHrOXxz1coiziRQy9LGoCzvy2LDqUFd7MD8TDwyvo/nlmM8EKDmb+tbk14hNeK1cikTT9KdZXyb9aCpZre0cLj3RB8s92jab9YlYXol6JL6uzh/MOp/HIQ0IuHllkNQNsjua6sVBzTSCNmg62eE4kY0d6lI1oce/UGeVZZiGsY9mDPdzTIO3xdTG8b0YIJv3H/lu+TJA6LBs2G0vvKxg9kGWAOXd46ofsYy6HVZFDAKIkKomDRl8U240wFUlY3MS8APkAncmMwR/C+actTFKCsLopCudfcT545NUAyBHHiibgdxQuNCJJc8w6qcJc98+NX3pnDglP+4zAPXwbhbPXYwvyIY0JdSVGahnMziJvC1Zy2CO648SnLMOk5AW//NZvh3uTsaIuPkfnnGP8VCYpWysBFFeZUOSyahJC3VV33l+wnXt6XhXZ0wMnRNvorRT3iTXcXKiTlM3dX3cDpRAUBe0zlwdgISjLXOrH21uCVu+bYpjZePMMtkbNAlL/13e+40isnVA61JCjjCEUdmUdFhgAO6z0+A2CQIO9i5vCMM9sJkyXi73VceHlpjs6LnMZqK8KDPEviqaKNRWZJz4zPcBJLe26ebueE2DZiiIWFChcfY+WpQ50Zdj8YT/gV2OE02Pmu7oIRwZ+rnDOQW5UL2aFgivHphTtqZdOfZrLWSVkk8y01EBJkOZLXcoKzwKTl2IdgJ9EBe4Gum9+00LHd6u8YqPqKGtKdZ8DD6ESL4MSWPr5XJWwFoyc/kF2EVBKlVkLyjp0sOFEdRUVK+nRLzns8khxHlHyn977ViIftKje
 7AN7Y04F
 s1aOCQgeDdgzBNKTG2cOurOhbrKs48L5YcaAKXCT5d5zZTqbGCYXFYznV+UTXJCtKuZzccz6pL8fKsceR6I9eRdFdOOLOL/Q89W1UgAylurG/7NUGV+5fTOOLvwXvkH0A7xutBqlFQsaieP6w8G8WCubJqACLzoROIiqWb9PxX2xm+ESZYcHEZFwHkDOSbNBZ4ch0R8fsxYLBqxzBSvAfemXSQ5KSIf06tNV33xG3DmZepuQnQ70t/SCeQ61f1u08hnQcWmKzRBNut5TcU5+/1gs3L+KfoQkgat98OxglU91j+C6gEClytZsGwuIafDK1nFWD4wdF0ZJ0DORg7MF68/F0Uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello Manuel,

On Tue,  3 Nov 2026 13:00:42 +0100 Manuel Ebner <manuelebnerli@mailbox.org> wrote:

> Fix upper case.  Fix tenses.  Replace 'set as' with 'set to'.  Add space after

Please wrap lines for 75 chars per line, from the next time.  Otherwise,
checkpatch.pl will warn like below:

    WARNING: Prefer a maximum 75 chars per line (possible unwrapped commit description?)

> sentence to make it double space.  Rewrite and refine complex sentences.
> 
> CC: Aveline Noir <jm5905938@gmail.com>
> Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
> ---
> That's the final version.

Thank you for revisioning.

[...]
> --- a/Documentation/admin-guide/mm/damon/reclaim.rst
> +++ b/Documentation/admin-guide/mm/damon/reclaim.rst
> @@ -4,7 +4,7 @@
>  DAMON-based Reclamation
>  =======================
>  
> -DAMON-based Reclamation (DAMON_RECLAIM) is a static kernel module that aimed to
> +DAMON-based reclamation (DAMON_RECLAIM) is a static kernel module that aimes to

Sashiko suggested [1] s/aimes/aims/ ?

[...]
> @@ -88,7 +89,7 @@ identifies the region as cold, and reclaims it.
>  autotune_monitoring_intervals
>  -----------------------------
>  
> -If this parameter is set as ``Y``, DAMON_RECLAIM automatically tunes DAMON's
> +If this parameter is set to ``Y``, DAMON_RECLAIM automatically tunes DAMON's
>  sampling and aggregation intervals.  The auto-tuning aims to capture meaningful
>  amount of access events in each DAMON-snapshot, while keeping the sampling
>  interval 5 milliseconds in minimum, and 10 seconds in maximum.  Setting this as

Sashiko also suggested [1] to update above 'Setting this as' to 'Setting this
to'.

Other than above two,

Reviewed-by: SJ Park <sj@kernel.org>

Assuming you don't mind accepting above two Sashiko suggestions, I applied this
patch with the suggested changes to damon/next [1] tree.  I will repost it soon
(~1 week) as an mm.git merge request.  So, no action from your side is needed
for now.

[1] https://lore.kernel.org
[2] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

