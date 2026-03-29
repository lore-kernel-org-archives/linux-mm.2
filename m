Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E9E4F3D5FB
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 15:49:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBE846B0099; Sun, 29 Mar 2026 11:49:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6F716B009B; Sun, 29 Mar 2026 11:49:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAC4B6B009D; Sun, 29 Mar 2026 11:49:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 996F16B0099
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 11:49:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4C730B99E2
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:49:41 +0000 (UTC)
X-FDA: 84599535762.05.355F48C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 976322000B
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:49:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MRAwzZcD;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774799379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mS8WIPOMBQve06QAERNdielHHz71tVzZq+JMzw09EMw=;
	b=udZ7KUA1TfJUnI2wQFUv3KbPPNoaPFRF34a7Akh58cY3TzPYNCGnrXdsUNq8HXnn9KlsW9
	/nDTbb5ckDuvCF3aDCErXVopguoCG1gf3QjgdLF3/BeP6JylW5JTtl3ZPKELRWyZl2yJcy
	GrSOIBkQQ99cZOyynBpdElOtegREDjQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MRAwzZcD;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774799379; a=rsa-sha256;
	cv=none;
	b=UKf/oDnIwwZLy41v4/Zcadwc7UcDWG4QbYlzR6N7fsc79/If9X8PcYclVQJb1hmXNTTWX9
	wDY42cCfJFb+IKl7uG70rF9pqd4jQiN/G2CYUZqDCKVFf0roC+AkbSzkSwl++UWltkN0OY
	uDWJAD2RYkJVBWZRYCLGQwsTR/E+/1k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C5792440C2;
	Sun, 29 Mar 2026 15:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A184C116C6;
	Sun, 29 Mar 2026 15:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774799378;
	bh=ZlPTTq6A7hzTBwvtr1yc4gLjYsyrTWFBrDRXyxAL2rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MRAwzZcDa4xWkzBPdlwJK55mF2P9NzFn+1tUk258au2qXsvaBVmC/XnB+pF945B07
	 f4tkwLLa0OJThp56SIgkPhz0rMzz4d5GEksISRcVw9drEVIMfQNo+DI8AOKWln3nSB
	 QWOAAo2mjg62anKWFvC1V5FryRgRjkpFXdwKdS795yW234UwoBEHHaBR8n7dcflbzE
	 2ZbxgHyWnuR+tVo7qtwayL1g1ZKdJ6GVKcdPmXLoEQ150pUKPr8y7n8fJz380pZtBq
	 o3gmRQx35K/LquBsgPJKLnt/NSmpPfIXi0/H1StNtG9XqxVFtRcBVFgZFZFqkbpcTa
	 EaRoNMRVQrLUQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"# 5 . 19 . x" <stable@vger.kernel.org>,
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
Subject: Re: (sashiko review) [PATCH 1/2] Docs/admin-guide/mm/damon/reclaim: warn commit_inputs vs param updates race
Date: Sun, 29 Mar 2026 08:49:36 -0700
Message-ID: <20260329154937.47706-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260329153052.46657-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: axjt45ey1uze3rkpmdyzc9djhm9fbti7
X-Rspamd-Queue-Id: 976322000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1774799379-846653
X-HE-Meta: U2FsdGVkX1+biXWRSOqEbrzZ49LDhZaKFkcSXTE3TJszbBbgcM9mP/D/o+cbYdNm4hH4AnNPXyDMWpLBI69PosORdKCQfnCk64hozJoW/mOINtV99Ri2997MZ+9vIflnAs0XK26koQ2N/HfOYM3/GcNneQvPLpW5VEMQcTd8g5Vrpw27Wc941G9V7eeIaV3gxy5KoxyaQrm5c/ZOhSe/xq7hO18UB5jdoKjL1JVIpWQ0LgX+ZLSeBbtC2GaDFXRmd02FpzwgDTJfMXi/RYRIAVCA4B/zTRvOjrOsHIaA/yATQWo84+TE/cUi4lC0UTrRt1JAABUtpmWfsw7+HTOaZ3CERwdbY8JNhSYOF8xwmzebwjLfq5+jqeHszGGj2pP+LCYmhIG8KQukZ5FCwyQvflpWAr5KYXXt1SS6EfO5Rzvi1HVaejBHKoeUqm0Q3YT70B8dDss0joSPVk9JZ9bkb1Liy+DMltkIGYTrV8kyiHzhyHpM6uKAOUHceA9tisP+g2x6o8W5x6YWrKrhsStSYONp7Xppx8T60hbo3plN8luDfOFkD4oGFXu7aS+2f9PDY8NJTn6D/qhwJ7OJz2z55XqlnSXGWFySdv1CKOlCNRXSK1e8LWUiwfVzY38PgwB4S1Cgah8AYXwBmnlnQhlf8+2JdQzkN+myu/rLeCKyq3TDZD3kqZ081YufHPqzadOodKUNzJtJEPxxlshXpOhMqIe4TZL+BzMhV587PD9ewF+xQ111bydK7gFMa2Bhr00uuCzRll0ignEm5EFPxXTo73ERIUZ0lc2RkqPKfpSMI+qh734kdD+i6wtm9QbCBeMy9AxTlztIcQzdeOH1gO/eK24/8Qv8Ojn/1CKvPkUxjFXPJGIYOsbieRyuBlscskbdrd/q3FHbYIxr7xvYMwkXNMLImM4Cp7uFxssqEiYf3QuRfyX23qFu683FytA/d90WNZf3nIGD2D2oDynftsr
 O305/iNy
 il5rILdbpAGoTSCBoHhPVoyT4PFnDw0uMlamiE4+xzE6/nXTT2UDU3oJki9ZY1r5oewSg1rkG81aTSqyur/2eLLXKgKL677HBKCAXymZbUUTbh0ht9Tt5vk2nh5W1I19b2XZ/iqEvIO2aW7h9yB7C9hknmqUKTKkBTAdhtoqovwC38qQzZIoThKwfsjwKS741LHC67a/37F15qATUp6DvglE8GjVmbfVes3vo2tenkn+SnYjH0MNboRxZzuWkPmRC9TxaklnIUnrXVyPe9cZDpFWJbmfAAPUPFEkhL/HYAO6QpF4pUWjSRdjqSpL7PAlVqC0AEkbOPfOg9VlJhrmVR2x8Nnm+RyW3yQTDsdhwIbcJVYZ1rIUvCX74KIx8WQK5EIK5ItYOYCbTO/vcMtWTxKn0LaSQwub/JZpcLC6l05Q0pNw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260329153052.46657-2-sj@kernel.org
# start of sashiko.dev inline review
commit 140a828ed89f6ed59d7b68f9bb0f1ec9b051eec7
Author: SeongJae Park <sj@kernel.org>

Docs/admin-guide/mm/damon/reclaim: warn commit_inputs vs param updates race

This commit adds documentation warning users not to update DAMON reclaim
module parameters while a commit_inputs request is in progress. It notes
that doing so can cause undefined behavior due to races with the kdamond
thread reading those parameters.

Link: https://lore.kernel.org/20260319161620.189392-3-objecting@objecting.org

> diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
> index 47854c461706..d7a0225b4950 100644
> --- a/Documentation/admin-guide/mm/damon/reclaim.rst
> +++ b/Documentation/admin-guide/mm/damon/reclaim.rst
[ ... ]
> @@ -71,6 +71,10 @@ of parametrs except ``enabled`` again.  Once the re-reading is done, this
>  parameter is set as ``N``.  If invalid parameters are found while the
>  re-reading, DAMON_RECLAIM will be disabled.
>  
> +Once ``Y`` is written to this parameter, the user must not write to any
> +parameters until reading ``commit_inputs`` again returns ``N``.  If users
> +violate this rule, the kernel may exhibit undefined behavior.

Is it acceptable to rely on documentation to prevent undefined behavior
triggered by userspace?

If users write to sysfs parameters concurrently, can it still crash the
kernel? For example, in damon_reclaim_apply_parameters(), the code verifies
if (!damon_reclaim_mon_attrs.aggr_interval) to prevent division by zero. If
a user concurrently writes 0 to the parameter via sysfs immediately after
this check but before damon_reclaim_new_scheme() executes, wouldn't the
subsequent .min_age_region = min_age / damon_reclaim_mon_attrs.aggr_interval
calculation result in a divide-by-zero kernel panic?

Should this race be fixed in the code using synchronization primitives
rather than adding a documentation warning?


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260329153052.46657-2-sj@kernel.org
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260329153052.46657-2-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

