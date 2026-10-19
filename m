Received: from smtp.lore.kernel.org (ip-10-30-226-214.us-west-2.compute.internal [10.30.226.214])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB2B606DA4E
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 14:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UvtLynSd
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C1E3CCF2E5
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 14:54:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8BDA6B0293; Mon, 19 Oct 2026 10:54:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3CD76B0294; Mon, 19 Oct 2026 10:54:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D52CA6B0295; Mon, 19 Oct 2026 10:54:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB1C86B0293
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:54:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3D610804F6
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:54:13 +0000 (UTC)
X-FDA: 85339671186.14.526AFD1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id CFE1540008
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:54:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UvtLynSd;
	spf=pass (imf04.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792421651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LA9yLlWDsUw4mAlFrb8iNJ8Iy8siUyde3QGxANbXUgc=;
	b=2dpsRPXXAjd2N7mgmrrvOs04VFGg2dlKtIo+0PRXt2ApKdCU8UvLjhkALe4BOduKzwFiF8
	7gUDQehxmRu1ojOdcKcedPT95CDTpJdAEEY3j9TncIMs6JcYk31ftBUGO0btwso/Hv5PY6
	jCU3cO3he9dhCiVVcJW6YaTiW7FnN1c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792421651;
	b=6RBnwrPUbjKkRW/BchEsIl3JQ2UYg+VL7iPFm/5Mtfto/gV+E0Iam3WIuhHo+NXGIe5fmk
	ZuzaDYaUcgaFfAOuKvBAf8CDC7/QT4Axoz99wjBqn0FVdhQcgJLdqpnCGiqKgVmG2W1m7/
	sPZS+U+fm6W8btnsX4J6urHlsahvrCA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UvtLynSd;
	spf=pass (imf04.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792421650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LA9yLlWDsUw4mAlFrb8iNJ8Iy8siUyde3QGxANbXUgc=;
	b=UvtLynSdU2e0dyCiWhqmESnUtFzGg1EQGqE2wVPoGifBwpchOVjwLwyL5iZr3EwmwoF6g6
	jFz/EOgQEYObmfe/kPQ3wKMJ2CedbxYeQJVpiTXTS2Q9pXYeCxlzVV3iIIVLN6dXB4zLNE
	c/DD7O0taz/Xveaf3DPRZsS6J6wjZ5w=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-58-BFeS7YMuPXOJqu7Wckh88g-1; Mon,
 19 Oct 2026 14:54:00 +0000
X-MC-Unique: BFeS7YMuPXOJqu7Wckh88g-1
X-Mimecast-MFC-AGG-ID: BFeS7YMuPXOJqu7Wckh88g_1792421637
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A9A5A195399B;
	Mon, 19 Oct 2026 14:53:46 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 07778410;
	Mon, 19 Oct 2026 14:53:42 +0000 (UTC)
Message-ID: <1bae2a1a-e4fd-4f11-94e3-c9ff9b37a399@redhat.com>
Date: Mon, 19 Oct 2026 10:53:41 -0400
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] cgroup/cpuset: use mems_allowed_seq when checking a
 policy nodemask
To: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org,
 cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 ridong.chen@linux.dev, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
 akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, brendan.jackman@linux.dev, ziy@nvidia.com,
 david@kernel.org, mgorman@techsingularity.net
References: <20261014222456.2318284-1-gourry@gourry.net>
 <20261014222456.2318284-3-gourry@gourry.net>
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20261014222456.2318284-3-gourry@gourry.net>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: ul3loVRjJYc34WGlKzyTFT9i086NSwvspPRFlAeAdp8_1792421637
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CFE1540008
X-Stat-Signature: rmgub8p55gtnuh5iysqhw51sw7mks1nr
X-Rspam-User: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792421650-399185
X-HE-Meta: U2FsdGVkX19ogU6qwS/z7WU09ho0sJMYr1WjWHXGDbQtHUgHI+NBa7iaE+jnEFWM3v14HUtKiSuwnfk+0r+1dFgNLyDeUBQgdGT8Ms6TX724XC62pfF+U43uuqJxl+6kvg5U47EWbjpgVTjUuQlP3HqOArJltgWXG2nefK1WT5TenKK9glqO0DBRpESqb5CPb0W/rgBrguTBor3+qvsimfmuj2AW4V+vsGub9kDqHO9rLm6zDepfZSzl5CQZJ0MFIvllda2UVyYiYag+GuJuCunnl8YNLLW88SJKf9Uy+8QaNHSCAMXROvSI1ILIk3ncZv3ff6vd5AaQ68T5YH5kedobiuz3XHsu60CzQE+2VDPkP5nJytwu9aHAr3kY9BHapfRGn6T1PEpdcBxKf/3MdoxW5ZDMpfBebCB8vrTdpwG5lM3Dpr/LbgzUv2k63UGwmJRTAmoJs16DytnXzlbw3O+RejZRPhkCrThjcBlJ0ST82SAB9gYflCE6yi0FVqIRtiD8i9i/EzvDQvwiKJQfJRVh99uyYKk1J51nyPEEExhz7s40vxouEyhSt2yfyZ74HotD2V+g6hYx4qEdj/qjVJWMBsMHVBKWaoonLKawx+rvndUHCAWr1mu3YRRXq/8rPYt9ZpTYoLnQPbSUZnxVE2svJikxKA+eLXJTvvngSPZ7HEdWXWQjbegX3/Rbw/VYWg1ZTYYwwT0+mvXHaxUUgEp+esodz7oc0o7jsxQ8CpGkU1svK7ibEI4BPl1mmxl1CPccq63B/GMGgV/kSdpMFBRaFXa7+ZItspWUj+RovnzZsJe6gsmB8D4NKOawvSUaQOoCjWDoXiRDXTvF5QwUttL1IuCq22XA1z7eNNssUjsF7dwems2FnRKU3FyLrOfOSYoYm9NlJTSLoimQC6O5iG1jPJ20xJAGGaHps0cn+Hrq2tQiXGDRhxd2VV9fkUmhJcrGRcjLOoHZ/7gqyNF
 ICtuKOqo
 1nuK8JQLsnhEGhKOuR8aOc1xP4ZjYynKXPvxe/A2yfutZCaAyfsQZ9oAMefFvklcFOZ1pklAA6Fz/EeP7gKrXfe6Sc/HqfuxqTQ9uziOL3rZ9i7DsXrxTC5ZUll99OvbRZv+lh/cBLUDRSf2ba+MUO3zpZHdFBCXccWDNNcoY6DS/fXLNKnvqL/c9kPMa70w57Xlsp4ld8pe99kWHVpYk2mkk7Qq5CWagYIh6oFQPdD5f1Un+f1g+/4clphj3UA7XtsPW85b2KJ74p91HPu+4xP4zrJfTcqGUhXHP4NW+4ulTJBMZpL8MNLmu0oP14vWYCCPTMZJ4iF1VOAq8cSBKtmIROnE7oriSjN5K1YPYcoUsbwpULuztrS194ZN0R+6auAjHcrvkxQYxgIlweTyyGP2X/JQsYS387Rh/WoBHlWxdqR48qszoRRCJyFA9A/i8T/PyksUgsZ2Kz5I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/14/26 6:24 PM, Gregory Price (Meta) wrote:
> A cpuset update changes the task's mems_allowed and rebinds its
> mempolicy in separate steps under mems_allowed_seq, but the check
> reads both without it.  This can cause a spurious numa placement
> miss under some cpuset/mempolicy combinations.
>
> A reader that loads one mask before the update and the other after
> it can see a spurious empty intersection and drop the nodemask.
>
> For example, a task with cpuset.mems={0} and MPOL_BIND={0}.  If the
> cpuset moves to mems={1,2}, the policy is rebound to {1}.
>
> The allocator can race and compare the old mems_allowed {0} against
> the new policy {1} - which will result in a dropped nodemask and a
> misplaced allocation on node 2.
>
> Simply retry the intersection until mems_allowed_seq is stable.
>
> This covers the task policy, which is rebound under mems_allowed_seq.
> VMA policies are rebound afterwards by mpol_rebind_mm(), outside
> mems_allowed_seq, and are not covered by this change.
>
> Fixes: cc9a6c877661 ("cpuset: mm: reduce large amounts of memory barrier related damage v3")
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>   kernel/cgroup/cpuset.c | 13 ++++++++++++-
>   1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 3f52717c19654..8ee239d5c6b48 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -4354,10 +4354,21 @@ nodemask_t cpuset_mems_allowed(struct task_struct *tsk)
>    * @nodemask: the nodemask to be checked
>    *
>    * Are any of the nodes in the nodemask allowed in current->mems_allowed?
> + *
> + * A cpuset update rebinds the task's mempolicy and changes mems_allowed in
> + * separate steps, so retry if an update raced with the check.
>    */
>   int cpuset_nodemask_valid_mems_allowed(const nodemask_t *nodemask)
>   {
> -	return nodes_intersects(*nodemask, current->mems_allowed);
> +	unsigned int seq;
> +	int ret;
> +
> +	do {
> +		seq = read_mems_allowed_begin();
> +		ret = nodes_intersects(*nodemask, current->mems_allowed);
> +	} while (read_mems_allowed_retry(seq));
> +
> +	return ret;
>   }
>   
>   /*
Reviewed-by: Waiman Long <longman@redhat.com>


