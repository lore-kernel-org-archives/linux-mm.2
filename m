Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C616EA810C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 13:15:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 631BB6B0088; Tue, 10 Feb 2026 08:15:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E03A6B0089; Tue, 10 Feb 2026 08:15:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DF0E6B008A; Tue, 10 Feb 2026 08:15:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3CEFE6B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:15:56 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E8F47B9D39
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:15:55 +0000 (UTC)
X-FDA: 84428594670.05.D617E82
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1DD1E140008
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:15:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CjfTqjjZ;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770729353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x0SPraHkWY4ytIGa3ssvCkBPtYNsoLRqE5+KaHhxgq0=;
	b=d4Q03sYMhN1uzVzlnVAXM03osMWwaydUZOSpmtCxSkvIH/b3yRtUktHps2nOgBzP1sW35X
	uc/dwxM7oFWyyoxCadiMpAX4L/vl7QIVjqfDX4EHYeg95LWA7eVoGH04Zk6MeM1ezxOAZz
	UGCuoshcu6UUbjnoQGgBH5Tv/ghekvg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CjfTqjjZ;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770729353; a=rsa-sha256;
	cv=none;
	b=YSXPDpUrKAe8DnW8rAPJhDyaMeQRUwvJk/23O7dlzSD9vM1HdEic1cZ74005EYXMQ1YZFl
	VIcelr+5qEZbOuGJewLEibxaJYZDPf1og0mi7tJhaP8YX+La+8MV2ODEi03q0x2ieJfJHO
	86zTkmvdTvH4a2k1lhO32IplZgXa0zY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7C4F260097;
	Tue, 10 Feb 2026 13:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D52C116C6;
	Tue, 10 Feb 2026 13:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770729352;
	bh=IV/D02QN8hR7lkLeDhxWOSdoEhss8wgB/k3cihsIPIY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=CjfTqjjZ07zhsQQs7536tQfJMZz4vCamo5ynyp/Pr4qbqJzAgqa/Q3peYK6WevRaq
	 FSWd0GQUj0rxiU+rMen13hnT1r1VOq7xnjrOnW6/1cNeAr3FjOmigw786oy4/Rg0ak
	 21/fUUSNVzUuXxdEZcCEEsr98oJTm1BDskt4yhJAy/IZ3mnvGdweeP3W/s/cdz9hun
	 CDQXcO66W1hcNsKKcoXIK/UF+LNL4z0n3LsFS2pTzU0mU9b3Rz2dGXGNCPiiASuh15
	 egAoYqh8GXpta28pgfRUofLlZDYHy9hlwZdMi6YflhOjd5L4NV6DzqlUpfP+hXatng
	 It1tMCEsIc/XA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Alexander Graf <graf@amazon.com>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Hugh Dickins
 <hughd@google.com>,  Baolin Wang <baolin.wang@linux.alibaba.com>,  Andrew
 Morton <akpm@linux-foundation.org>,  Jason Gunthorpe <jgg@nvidia.com>,
  Samiullah Khawaja <skhawaja@google.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: memfd_luo: preserve file seals
In-Reply-To: <aXd8I4czYUpl72qq@kernel.org> (Mike Rapoport's message of "Mon,
	26 Jan 2026 16:37:23 +0200")
References: <20260123095854.535058-1-pratyush@kernel.org>
	<20260123095854.535058-3-pratyush@kernel.org>
	<aXYGkb-QtYNaWYw4@kernel.org> <2vxzqzrca6cm.fsf@kernel.org>
	<aXd8I4czYUpl72qq@kernel.org>
Date: Tue, 10 Feb 2026 14:15:48 +0100
Message-ID: <2vxzo6lwu4cb.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Stat-Signature: w67y4zjqqsjoofuchzwmaeqmsnsagtno
X-Rspamd-Queue-Id: 1DD1E140008
X-Rspam-User: 
X-HE-Tag: 1770729352-596356
X-HE-Meta: U2FsdGVkX1/S+iBy6RghHNAXAcvc6X8RUy9bCSE5qE96hc9twOS1U5kqYV4/y62jpSQjSPxAScWiTU6Oc7JwL0Qjm6Rs86eoXP0KeXUHoDIZZJFkaDu7tCElNk+2Rk2BuMmkK9S3DpxUsf0TFzIwMcO/FWeGP0HYXD5JVeC4pgpY5u8nfBxpLma0mrsZseeyvbaOZkUD5QWefXbpsiO+ktQGCfU60OietN5+Hk8N72XqaWpbooWLJyN/5T46eln4uwOpgegJK4RcPMLx+Gvchd1ZYGsVtOyWHAj4PJNRuw9xxePPOKAnETdNPuksOmuKfaGp/9dd4r5iRvdMn126d1K145T7uv9fnNjhAcf8B1E9KyXu8l6GmmGMNV0KDAXctDI6gnHfK2/mKtI2FtrCt4XI5RB3TU/mpw2t5UHMFXOsDLVk0BldkzSBr9S3IUbblpnPisYak4f/sccfcDud89kMGLUSaL2PI+RxRI070LaD06Cjmrqcjp/9QVgXNAZ0WzNg2Qs7Km6Fn197yksvEXwOrtAEeP81yXqgTpK6/VQRmuZdV2HsnnWepKRMAn/HV87uxzk5CPUchbCmMIVsj7VgfhBz1eqeEwdNemNWA6b6bvw+6ZcddQrmOyYEANx9thGGYXDEUhglCBrwliLaCpCZ3Ae0sCdUu4kwwdCRwr2quU+YA3BGJTyIbmLKuSrjoNKBBQlmv6N022zPj1TvLbRrgTlsWwyBXVhlh3nKwRZGxjxF2D1yzsCqEk/gpLs8DXUul0z0F4yS1K+DRTsruAvCt+cfHGLi5qnkqAWJhuo52uTO5vHnNtlYSBD+lkCJLYvaRLCMODA72nGUC5CpMD8CTNXFTc3mJ8Ons98Wv1vQrineUe2ZjbQUgqdGtM2ofrsnPYzaO4owCHg+RB3AmkujtGZdr4ax8IDk/zBXsgH59mEZGdi1rFLPqjYwKEsXGB/OfCWEh7GpRkMADpF
 HkutSn70
 Cwqfn76ekRjQeqRD7fHyLkjQ12JN57m4KW73q3RfhQ4zIdap1Fy0WLeqlbu+KvPYd9ZxzvM5B52C7sqxwaqdCjEiMwqpaTooILDYL73KNaBt03PjD4an/ZPHhdPE9jBzMmjUz7PzODqqWd+4rYBzvB4wK4gDcldRV3h8N09VXM3R+LfFZOdsunhU2gd++8L62/Xr9e60AIiW9UpZRwAa/hyS478e5BsB7mpMKRc5Ap9pnJ3lp0+pQYZ8RqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26 2026, Mike Rapoport wrote:

> Hi Pratyush,
>
> On Mon, Jan 26, 2026 at 01:47:21PM +0100, Pratyush Yadav wrote:
>> Hi Mike,
>> 
>> On Sun, Jan 25 2026, Mike Rapoport wrote:
>> > On Fri, Jan 23, 2026 at 10:58:51AM +0100, Pratyush Yadav wrote:
>
> ...
>
>> >> -	file = memfd_alloc_file("", 0);
>> >> +	/*
>> >> +	 * The seals are preserved. Allow sealing here so they can be added
>> >> +	 * later.
>> >> +	 */
>> >> +	file = memfd_alloc_file("", MFD_ALLOW_SEALING);
>> >
>> > I think we should select flags passed to memfd_alloc_file() based on
>> > ser->seals (and later based on ser->seals and ser->flags).
>> 
>> Not sure what you mean.
>> 
>> I think the only seal we can set via memfd_alloc_file() flags is
>> MFD_NOEXEC_SEAL, which is really a F_SEAL_EXEC and plus a change of the
>> inode's mode. And now that I think of it, that is a valid use case that
>> we might as well support. But I think that should be done by preserving
>> the mode of the inode directly, and then copying the seals back. The
>> main reason for that is that the mode can be changed after the memfd is
>> created too.
>>
>> Other than that, all other seals are set by fcntl (via
>> memfd_add_seals()), so I don't see what else we can pass to
>> memfd_alloc_file().
>
> Hmm, "using ser->seals" was bad phrasing :)
>
> Now we add support for creating memfd with MFD_ALLOW_SEALING and at some
> point we'd want MFD_HUGETLB and huge page size.
> So I think we should have a field in ser that will define what flags should
> be used for creation of memfd and based on the value of that field pass the
> flags to memfd_alloc_file().

I am not planning to re-use any of memfd machinery we have now for
HugeTLB. The main reason is that the HugeTLB support is different enough
that any shared code or data structures aren't worth the extra
complexity.

So HugeTLB gets its own serialization structures and file handlers.
struct hugemfd_ser in [0] has a field for order which we can use to
decide the flags.

[0] https://lore.kernel.org/linux-mm/20251206230222.853493-11-pratyush@kernel.org/

>
> For seals support this field can be hardwired to MFD_ALLOW_SEALING at preserve
> time.
[...]

-- 
Regards,
Pratyush Yadav

