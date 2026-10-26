Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FA0C606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 12:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gp/6q80U
Received: by kanga.kvack.org (Postfix)
	id 58EDF6B05B0; Mon, 26 Oct 2026 08:53:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5406C6B05B5; Mon, 26 Oct 2026 08:53:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4565F6B05B6; Mon, 26 Oct 2026 08:53:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0F3656B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:53:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 814341C1C0B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:53:23 +0000 (UTC)
X-FDA: 85364768286.28.E6FF1C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id CE707100008
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:53:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gp/6q80U";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of xiang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=xiang@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793019201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VIxTiNRgypXMaqJ3sKqKWSTzccttj631MPKMikg/mfI=;
	b=D6kpUhlAUNI/BKmKvgMNs4OCJffFlQuT8revcb1deX6M9ezkBj128gGyCdkOzm/C133U53
	X7ltwwSOaZQIfhALMDtAmLqPqtWypSHB2aSAM3UdDWvH3hD9KfATfWhjBmNlip8L5CPSKD
	RawdK07RGDZf8jX+sk3JJH0lbIysAWo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gp/6q80U";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of xiang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=xiang@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793019201;
	b=ZNVWqGqUgSv7E/D0OZKwrRCMUEasxHFeybm6tgnCA9yE/JkK99WNwVLR0A1ks1OwYdhMsK
	dV4su1pw5iRMcKUF6vJyJ3LopaqbSN2T7+X8q1HswX2jeeQ84v2V4d9gQwf6a75dqS+xUk
	nN4cUms7CrdX1ImIvqbCJYwilRrO1HI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0E7C24020F;
	Mon, 26 Oct 2026 12:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40FF21F01825;
	Mon, 26 Oct 2026 12:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793019200;
	bh=VIxTiNRgypXMaqJ3sKqKWSTzccttj631MPKMikg/mfI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gp/6q80UQa7H3T+mI9Qp2Mly9TnA3bLnYUSDuIVxjJPVzooXT1imqeZ1sxvuWbIOG
	 LYVKUiqdbq7fCSyHHUCaasxU212uwFC+l8Guh7izu7tVOVGfz7y5ILaAhaBKVpzBFC
	 a8FcnusT7OWdWh8zf2VYD/mfncAaOAM1jML9Ey9nmbN09VZoqub54qzT4Z6atUX4eG
	 HsAMGyjYnmp7WTD4GFYCLrtlfcCjUsRvyYrIP9cJoB7eQeQOsmHY6LZ9TC5ineBii+
	 KueuN8O9SJSwwR3j5yjgAsM5CdCWy8/Z2qoW1lKaGMjwwZ3rScf+H5hw51T4/5Flnd
	 CzmxNfeNYudqg==
Date: Mon, 26 Oct 2026 13:53:12 +0100
From: Gao Xiang <xiang@kernel.org>
To: "Gupta, Pankaj" <pankaj.gupta@amd.com>
Cc: Muchun Song <muchun.song@linux.dev>,
	Jialiang Huang <huang-jl@deepseek.com>, lance.yang@linux.dev,
	baohua@kernel.org, damon@lists.linux.dev, david@kernel.org,
	kunwu.chan@gmail.com, lianux.mm@gmail.com, linux-mm@kvack.org,
	mst@redhat.com, ryncsn@gmail.com, sj@kernel.org,
	virtualization@lists.linux.dev, xueyuan.chen21@gmail.com,
	Matthew Wilcox <willy@infradead.org>, xiang@kernel.org
Subject: Re: [FYI] DAMON and virtio-balloon in DeepSeek's DSec paper
Message-ID: <at9NOPA2VqV54yan@MacBookPro>
References: <20260925054408.10431-1-lance.yang@linux.dev>
 <20260929123241.1408414-1-huang-jl@deepseek.com>
 <aruyFPzEe3pS_Qzx@XiangdeMacBook-Pro.local>
 <AA71E56E-F29A-44B2-B5A0-7806CD684B21@linux.dev>
 <ary5Nn9le4xG7_-N@MacBookPro>
 <CEE47F27-874B-486A-995F-E223249659FE@linux.dev>
 <arzlfSOgtC-CLoZt@MacBookPro>
 <8839b7e4-a830-4c88-9e7d-dd35757c5167@amd.com>
 <at9LyF8xIIPKcLSD@MacBookPro>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <at9LyF8xIIPKcLSD@MacBookPro>
X-Rspamd-Queue-Id: CE707100008
X-Stat-Signature: nkep3ogda17aajy8gtkpo6smaqonikd6
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793019201-306851
X-HE-Meta: U2FsdGVkX18hbBIajLyL3YuQ9k2fTIHbjzj+SMbSBA4WAmMI4zBLzbT+gPEfwPFClJtJvT/BI1Lh49FLKyIIOR+txIcZ9XdXgt6BbwPMVYTfmV9JyZRwLl+RKOnOoxskTOYgkYddxSkfRTCtpi7d5t45btv3fxC+sxe4/urQvPUqX3jQwJWKKMxwOXtG7nAZrukb0l2FSDuLdW9P2rhAm0TwSv2NsOuCKKorW+39EOK3A3BqsVhTYwyexZIxVPectQ5bI7GRMuJ2IyAohjEPsUqc6FwGvIhoOfD5RetDndYomglP4xbv6ebRvYiO9HB2viyq+ez6vJ/6G1b5lka50GLdxE437bsY6KmjiQoWED0Cb4BBooBpkZ2yp4+3VtoMYKDs8iSpzusNwTUAz2P4uSW6DUJpBm2K6ldiznJ7SH7ILDpqv0RcwPQsUddNsNEQvAAZPAVD1aDqfIgLUE86/1QmGr0Pb5i+eP+27sTEPoZbr+lo5oA5yyQ2hRU+Pr1ZYzUJCd3VgULmyZhnd/vWIupq9zviZtw6IBJmsQEJYQzxxjBbwpwtYICdIup5Ad2ciYWeDGuIUhPaNgaGmYsG3JKmkhwIL7iL9Soia3fQC1gUyvk9rL6/uWD4sLtFEZowqcCOBO9jPdM4EWKsfGwwV+p8w2gg39swWcOeFT2c+GPjKT9GYAhfX3AzkVphEi46qPN+i9AqHjBvRZTOkVRGxgTHB5aHfuguunX/QwiNopgwORgfzWFk9/E34qJqd2Xs99u6ZZ1o8ayBVIWuBQhQENPI05DkHj0DzI7Kwae3IpZjJ6ldsZI2dt0BKg/FwsHqn5io0YdQpXMq6adr6zzHGcMqsXi4zbEf1S8GwWVRFeeezSzUmCZfarj8ndXt7IxtLQIDHkiRzPwBPREyK9zNL5kW2yI2QLv1bfESgQuYNQcZBTvUqFF4xZHPFoNKi5DDUwwaGPTOq2TMTammPKR
 CxSQ68qX
 15uxqAOmoKYKyuzK3AD8mEe336RPqdwk+2Hv88p/S7631YnvYJ0bzjReHFBC/I8lMdyJzCHrnj9/pClNyCrYseUzCByWC/xyO19MwP6XSTNcvseSK+ZnkWbyVFMhg5oOrFZGF2CL3b0+a18ZjLlNpbsDA1ceF4PHgG9sdZYKRBR+K5/Va1bAMQmrOWylGNL/oDhuK/zwcaf1skRAn28GLbDeZdSMYLZg9OvbstD4HDQcwc16677Q00ay0LXa6fy8th0BdMUFoERjVCN1AQCvY3vkBKo+6mgwWh+emH+nZuac+e3BP3cPlzKug76PAe+PEYIdFIlF3Ga/KrtF7/bskRTlRew2UCkt1zK+TNVKZdPVOmJo9uFu5ekOd3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 01:47:04PM +0100, Gao Xiang wrote:
> On Mon, Oct 26, 2026 at 01:35:44PM +0100, Gupta, Pankaj wrote:
> > 
> > > > > Anyway, it'd be better to get some numbers with RL or agent workloads
> > > > > (especially the host memory is under reasonable pressure) before
> > > > > landing all these new infras upstream if proceeding in this way.
> > > > At least for now, as far as I'm concerned, I don't intend to land all the
> > > > features mentioned here. The first thing I want to address is on-demand
> > > > allocation of struct page.
> > >  From my point of view, on-demend allocation of `struct page` for FSDAX
> > > is indeed useful and can be landed upstream, mainly because `struct page`
> > > initialization takes much long time for large FSDAX devices even a small
> > > range is used, that impacts the guest startup time a lot.
> > 
> > Would on-demand allocation of 'struct page' from the device itself (a
> > variant of the altmap case) solve this problem?
> > 
> > For virtio-pmem, since device memory is backed by host page cache. So, in
> > the worst case host will provide memory for all the 'struct pages', but the
> > guest itself won't OOM.
> > 
> > Just sharing this idea. Anything I am missing? It could be another
> > optimization on top of Muchun's work.
> 
> I know virtio-pmem struct page can be allocated from the device itself.
> 
> But I don't think it changes too much, since guest kernel implementation
> shouldn't imply anything of the host. So that the pmem and struct page
> can be backed by anonymous memory or other types of memory, and it can
> still cause unexpected large amount of memory on the host instead. But
> allocating on the device is sightly better than allocate struct page in
> the guest.
> 
> The problem is it's hard to make sure the on-demand allocation is always
> successful since the guest knows nothing from the host, so that it
> exposes security risks like denial-of-service or more.
> 
> If this security concern is not resolved (e.g. implement a reclaim path),
> my thought is I think we shouldn't overcommit the struct page since it's
> a functional defect if virtio-pmem is reasonably large.
> 

But I agree that allowing on-demand `struct page` allocation from the
device (rather than allocate using the guest memory) has lower risk,
maybe allowing this can be the first step to enable on-demand
allocation (actually it's not an overcommitting from the guest view
since the whole pmem memory range for struct page is reserved).

Thanks,
Gao Xiang


> Thanks,
> Gao Xiang
> 
> 
> > 
> > Thanks,
> > 
> > Pankaj
> > 
> > > 
> > > But in order to make it safe for production, I suggest reserve the
> > > guest memory in advance for the worst cases of `struct page` at the first
> > > stage, otherwise it could cause unexpected issues for many guest workloads:
> > > it's hard to perdict if the guest memory is still enough, it's unfriendly
> > > to system designers as well (that would completely based on their
> > > experience and hard to ensure the service quality beforehand.)
> > > 
> > > Since the guest memory for `struct page` is touched on-demand, the memory
> > > over-committing on the host is still workable, the memory reservation
> > > can be removed after the reclaim path is done.
> > 

