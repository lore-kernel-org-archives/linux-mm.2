Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D638E10F3DED
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 17:34:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B29D6B0095; Sat, 28 Mar 2026 13:34:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 462156B0096; Sat, 28 Mar 2026 13:34:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 329B56B0098; Sat, 28 Mar 2026 13:34:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 21EFC6B0095
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 13:34:51 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A55271395EA
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:34:50 +0000 (UTC)
X-FDA: 84596171940.22.EF9F828
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id D8632C000A
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:34:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OnSb9kG1;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774719289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GorH3JvMwp4+9tmLN/C3nSlG6cps84tNiwKBkcun5Fo=;
	b=VkQVVd+spkhJCKWUpDsGAN8bsTtvzTKvxBU4zS36QGuAnnyWAuM+h2E7pONGO3PtkuvYxf
	ekTo8H+IcmBA2nayIiBda/cDt377sDxq2+kLjmBfRZgoLg3SYFbKA+AmzxrQ6uX2wp6rLd
	TP27iVf1xt3QM3pUyx6z+NvOQRONbeM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OnSb9kG1;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774719289; a=rsa-sha256;
	cv=none;
	b=skHJvCj4NnYgpnYC07PLuLDcfOaf5N+U9mtJi96yUrOUQEoB1JI2GwwcXP+GkzGRO8+tCU
	TbTBC6Qzdn6nPK73QL6FA4OWms+HAnOgn5X0qE5Msfo3EFDmWBfo/HohyAJJxPBvrykJc9
	V9c8vx/hjmyA/PQqSUc7agQs627p+0A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DA0B643BCD;
	Sat, 28 Mar 2026 17:34:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E668C4CEF7;
	Sat, 28 Mar 2026 17:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774719287;
	bh=aQ3MMdx7p7PT0107c2kdHBgzcaOXQ1T/12rvaMrKp9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OnSb9kG1bYqnldIcBcKk2EvB36oYLB60sQIZih0Af2UU8DMKt7bgMPnsEFQM47lkQ
	 cZWyXz8t+BI7uVKPROxL0ivzwEmhHHcPWXpS3GSMwq4K3aIfRF31AIU6GlPO4DkTnI
	 hMBHdDenxqEIi33zgMeU5iOUnneJE/0rBUR6LLnDR0vGj6TPbUFm3gxJlzzSd5U4cv
	 gGYLc2BrXV9idYvXWmpvHdCrOtmBEp+xOMO//YTrkr1yPkT9YzUt3RR21ODF7zxX7Z
	 XS9WjI3qk56saHh+3E6+PUjpvVb3NezznMTlVlDQ9fKITzPBy7rQdI0MCoTHFOBLnN
	 HXxObClhzgAvw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"# 5 . 19 . x" <stable@vger.kernel.org>,
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
Subject: Re: (sashiko review) [RFC PATCH 1/2] Docs/admin-guide/mm/damon/reclaim: warn commit_inputs vs param updates race
Date: Sat, 28 Mar 2026 10:34:45 -0700
Message-ID: <20260328173446.53021-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260328172415.49940-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D8632C000A
X-Stat-Signature: 7g1iuwosqm6wrdcjre39i91o6qe41e4u
X-Rspam-User: 
X-HE-Tag: 1774719288-80452
X-HE-Meta: U2FsdGVkX1/8tp9j3TVeGJZ3sbRicUyMDKsuxLEpyq2pRlz0iahGKj5UYgp9/GkUk8JLsurWYayYvhsnEVWTpcSe0cWHpcUls2Fs8sRx0ByYMqTTiu5WndcVpUf0jZayuAbdhp5HrJBwb7BwQGX5jFQn6ocn9dY//8M96YIx67Vc5RfD5kdG2nMA+MRv8uB0a8U844EYLaMIDaNjO7061PuTTxWm6RLcLlyHI6O6mspeREiEZMCmPIgdtblNzfLp9bLYD6gDdm4WWVXCLax1SJyVGdSzCvp7990toVPttX9r+ERJkqt1BciDIMWmgYee9Wqzvi+jmGqkPoysCQkbE6HMp6pf1ba+G9MWauBBl1uJJJHdLrjg41P/AggDnJRp2iHIjPz33fOJL+etnXZQ+zG+gEsHf3rh9fTOZII/bnGx65dQrtdGb5kRTFwdsqLHKguSxRZI0XnUg5l0rPStVxH9FzibguOu/ythj9dbv2SZZfvBNi4HjnLt1BVgGwWeNTKwXY7I4JTAq+2bwGQT82hEiG4cLX45p4KjdDCi0o4Hr8v556+dXBmEfkjga6vNfLk2tNCRLzH7OgsRH0HeWNMgKJVwiBUmqYriVXWKpX2rBiDMvENLhdTSF3+gZB2AG5bqZ1fFNJAcaNX+9cFW2Mk9DRLZhoIG54g2pdYSOQEp71xLhZOHXbD/3sPgeetSMhy5rXeIsxjpi4oLwvdMRCSDy579VDFA5/Q141jyFq/7mThSNhPEHd1BGjcvCRRG4hwnXWG/ugOeK/RKcUbCFRd3FWgpde28A0rV9uZRhVFhrGhZqdo3FRNiR4aHGa0dMgs/WaAYWosve6o/cG7KDvnf7LzGYbsAYCsipvQH+HK3jC4aTskTRLyjkKdSODk/E11S+UgR0LD5ARCKLFPMR0kxyy7cDj2XRuqqk9URqeVw9+B827OdQpgydz4a5FFD3/hmXgvZngpqflnO1oA
 R5ESvBOa
 fhAemf+g0Fgq6LJgA/ksZnmVSiiwfJHokytPD2uaOkh1+VcsSnI1xFil5qN/JYxHwccBJgxy2h3QKa1ZfEuSYDXf0tvN1SN15IpllEWzV8pxdXVZZ9CllDWkjVq4SKq840NbPQHPS/W6U532yIjOYPm9jMICna7NeO1axtynaAfVjUURwWgC8+ULQ2XYS+q962GlqESE/JpaC841SPkZTrBN3VYUwOGeHkJ0HJo7FqNWLPnWWwDOLTJJC38RWfM/o6V2h2neosVh3diOVCUlxxlXQ3UoLOkOLMbDX7qxfXBP4Ydtxe/o1CeSpZNHxVAdoTvL5rdR98kVOib7WUeX0BoOcJu4H5FnmWWRLT6RIasAwG2i786fCRzbHFMpz+LnCaMp3qzjY0/Y2yFb0sfi5RXCATNiz2ijnyrfGQgFTFdq0dSA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260328172415.49940-2-sj@kernel.org
# start of sashiko.dev inline review
commit 8b189801fc104c5ecc412454a3d8db6a3faf27d6
Author: SeongJae Park <sj@kernel.org>
    
Docs/admin-guide/mm/damon/reclaim: warn commit_inputs vs param updates race

This commit adds documentation warning users not to write to module
parameters while commit_inputs is in progress. This warning is intended to
help users avoid a race condition that can cause undefined kernel behavior.

Link: https://lore.kernel.org/20260319161620.189392-3-objecting@objecting.org

> diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
> --- a/Documentation/admin-guide/mm/damon/reclaim.rst
> +++ b/Documentation/admin-guide/mm/damon/reclaim.rst
> @@ -71,6 +71,10 @@ of parametrs except ``enabled`` again.  Once the re-reading is done, this
>  parameter is set as ``N``.  If invalid parameters are found while the
>  re-reading, DAMON_RECLAIM will be disabled.
>  
> +Once ``Y`` is written to this parametr, the user must not write to any

This isn't a bug, but there is a typo ("parametr") in this line.

> +parameters until reading ``commit_inputs`` again returns ``N``.  If users
> +violate this rule, the kernel can do undefined behaviors.

Is it acceptable to document a race condition that leads to undefined
behavior instead of fixing it?

Even if the module parameter interface is restricted to root, user space
shouldn't be able to trigger kernel undefined behavior (which could lead to
memory corruption or crashes) simply by writing to module parameters
concurrently.

Should the underlying race condition in DAMON_RECLAIM be fixed with proper
synchronization rather than relying on userspace adherence to a documentation
warning?

This isn't a bug, but the phrasing "can do undefined behaviors" is slightly
awkward. Rephrasing to "may exhibit undefined behavior" might be more natural.


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260328172415.49940-2-sj@kernel.org
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260328172415.49940-2-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

