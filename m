Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1421ACD4F2C
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 07:01:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F0B76B0099; Fri, 12 Jun 2026 03:01:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A1486B009B; Fri, 12 Jun 2026 03:01:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 290136B009D; Fri, 12 Jun 2026 03:01:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 19E536B0099
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:01:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A49A1C2C10
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:01:51 +0000 (UTC)
X-FDA: 84870365622.03.06CFCA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id EEFAF1C0009
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:01:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k1E2EpB1;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781247710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xNfxQa1vwlWCvaXRQjFfS1B0XulfLE64TNHTVCMhrdo=;
	b=x+rQZW4s1WDF9sNJC5hOXUgeqxIhusZY02xD9jbE5cVuz//IWcCq9UcjRfCcFiuyjyudP4
	0HT6W2Vy254y0iX/0G79Ug4xc3GB9uKzg96tEBu339WrpIblcWeYBGRRWygFjVA6b970mk
	r3hEukdoVO7POrBu3UuHnTIYolUq3pA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781247710;
	b=yqMtHvuqN5d1oEtxdwgqotbaEqdaUEWo7vbX5zqlv626BGSMeka94rBjeTE9vQfFchmuev
	Okz79VIpVhTB2FuLz47ZhH7/ilaRUCeHCJwqmGBl19rJslUdiEkxdBUL9spOtxpYZ1Q8jA
	7wQ6dlvCgdlXL8cq3hyiorIS4O+eJ+A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k1E2EpB1;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0EA7643A4E;
	Fri, 12 Jun 2026 07:01:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390011F000E9;
	Fri, 12 Jun 2026 07:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781247708;
	bh=xNfxQa1vwlWCvaXRQjFfS1B0XulfLE64TNHTVCMhrdo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k1E2EpB1k5J7CBcJb6cpSck/EYkFoXJ/XOO8TUkLoNokPwku9IASWmksUIjVGuaRH
	 Sij34V1NILT409NuiOjlzlPDCOF6WV5EPJzJoL1kBnHa9F0FmprR92wqyJZDi09Ir7
	 94eMUFLAmJRdhzNRpiPMevc2+a4sqlCWfkh0ad0B7H1CBFM7wbDYuOqlpb5+ciBe2a
	 AL8VsQs40bUw6r7aiXBtZzfjX7RfbFq/dn4cfFzq/hXbtb9FbFDu5ZI92fvM3n5OMa
	 OfpmLLwptq4WD9EWd9O/znlGB1UnsWh/GDlyLkYy5ehoDsF8692YWhg900C28x+Ya+
	 YQ4V0+5oJNb5w==
Date: Fri, 12 Jun 2026 10:01:41 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, Tarun Sahu <tarunsahu@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/memfd_luo: validate serialized_data before conversion
Message-ID: <aiuu1QzAk_pkQKNV@kernel.org>
References: <c2478f79207b10a13282d917c961261d17b86a15.1781173768.git.tarunsahu@google.com>
 <aiqso7rkpX6oMer7@kernel.org>
 <2vxzmrx1qjuf.fsf@kernel.org>
 <airGIioUmTtU9326@kernel.org>
 <air5ho0LOIEKVzRG@plex>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <air5ho0LOIEKVzRG@plex>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EEFAF1C0009
X-Stat-Signature: kdh8owfnsmmopzbgrfk9eyjbf1ifij66
X-HE-Tag: 1781247709-319070
X-HE-Meta: U2FsdGVkX1/xk3kSlEQlF71FvDeboOFpfDv88MdKZMJ2ZAxn2kTnRiCtlTM0A4QUCfQoKXUmx7oAuimw5VsCSp+xslf5KmKY9fAuJQ6iFLF37tGohhZfVRsmIwxElR0W3zHLgu63tUJxfyGQNVtHkL/8Job5dANH7tCpDGWiIaYw9RM6KYxijJ+PmUY7GlRYKovIzNPj2gvCepSMwplJKiKueThBdeJAvvS1xC5ynQyqA9XLTI1AtycWW+oif2xPk4sGePIYOwJz0VSNEjiorFNNDbVoLr8764nfl5/hXGjBPleE5ZJiaponcfAeu2H0aKy/GMAxhR+iPPhA7ABhM7cUY2otCxd4N1cATSMZOr3m4Ejd0inOBsBtaQlBgpGx9HbsZcTnteYcoOrtcYL3hUVf/zXBifq4gs52ERmrhjQz4zL8CSuGnNcTptLgmEpQ6YJP7hhq1wYIMUfpKNJoKQoXGA/zCTAA48rQ7VxwuXcFREwlIjMaZRkGuWiWO6m9LKutmus8Iv6zSr48pNRAtvU0bBUpUUVOY+EWoFeOodibxQqbcOrxxKOibdOaU1lyHjXb40QGec2txz9KYd5FSvpLYsTLXq2H7IeSyIZiqJ+7FGoiPaRps6BoTb0CyTwWXF9YMjSJcbGMBHHfgqaPXdBi856YAi2oi0q3MwkoGoucUHwmBZkYF7PaqSM3kyni/sOqm7sUpyR8qy9re9Wv/S6TFNVtYg1rtjDoVjAMMRDdG6D/NIQlQr1kubaaWc+rB/RBZnSJ4avXoKw5tdwgytXscfgmX+34IfhlcxHVHrAbk2KozE7b0ue31Y93Ym+18qRWfnmYMzz4BBI91uerTFfn1plxbaBXgDdBupUTc3N+6NnyVqL+LwB5yCIr8tny+IYVsqEuFK6ofta8eUDxh1dbwpwhjhClJX3Csk9pya+8+SxXZTe2XxH1enAAvVUGNQDVtMLNDsvLiQnvQ2m
 naEHuPW8
 CfVeXD+2BQOEnB7Jbn30gNvuPDi1EZAtrNpFmPtdkKmSIPK9uDTLH36hTcXx80yYEMlKXeRvToP8mXRyQGB6ppTYdGCNlH7PsokzS8Vv5+/Zs8/UKpMmGkN0OO7bWqmF3jnOmqKrsZ+1K5d8qoIohwrBc5k99eAXnj/5IsfA/wEAEaqgjKfpkCuCvEbk6MNzVU3A4Ur2Q6xygT8y/l7ho1TPgGCW3C6BNNal7AiVAM4Xm8aq7sclHjEY5ois8jNO4zoavvoXWCek4jyB4if9wbKS46ItdImR+Ae03C2R1OCw+gDHPgIE4WfyZ/H6EM62cI3tx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 06:11:13PM +0000, Pasha Tatashin wrote:
> On 06-11 17:28, Mike Rapoport wrote:
> > On Thu, Jun 11, 2026 at 03:37:12PM +0200, Pratyush Yadav wrote:
> > > On Thu, Jun 11 2026, Mike Rapoport wrote:
> > > 
> > > > On Thu, Jun 11, 2026 at 10:30:03AM +0000, Tarun Sahu wrote:
> > > >> In memfd_luo_finish() and memfd_luo_retrieve(), phys_to_virt() was called
> > > >> on args->serialized_data before checking if the physical address is valid.
> > > >> Since physical address 0 does not map to virtual NULL (due to direct
> > > >> mapping offsets), the subsequent check 'if (!ser)' was ineffective at
> > > >> catching a missing serialized_data, leading to unsafe dereferences later.
> > > >> 
> > > >> Validate that args->serialized_data is non-zero before calling
> > > >> phys_to_virt().
> > > >> 
> > > >> Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
> > > >> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> > > >> ---
> > > >>  mm/memfd_luo.c | 10 ++++++----
> > > >>  1 file changed, 6 insertions(+), 4 deletions(-)
> > > >> 
> > > >> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> > > >> index 59de210bee5f..10f3983b0060 100644
> > > >> --- a/mm/memfd_luo.c
> > > >> +++ b/mm/memfd_luo.c
> > > >> @@ -397,10 +397,11 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
> > > >>  	if (args->retrieve_status)
> > > >>  		return;
> > > >>  
> > > >> -	ser = phys_to_virt(args->serialized_data);
> > > >> -	if (!ser)
> > > >> +	if (!args->serialized_data)
> > > >
> > > > We really should make args->serialized_data a KHOSER_PTR
> > > 
> > > Hmm, that would also be a good idea. I suppose then it would be a better
> > > to directly convert to using KHOSER_PTR() instead of this patch?
> > 
> > Makes sense.
> 
> I think we should systematically cover all  phys_to_virt  conversions 
> and add  KOSHER_PTR() , instead of an ad-hoc approach of adding it as we 
> go. So, let's take this patch and do a series where we properly convert 
> everything and provide guidance for others to use going forward.

It's too late for this patch for -rc1. So let's systematically convert all
4 or 5 direct phys_to_virt() conversions in the next cycle and be done with
it.

We have enough time to make it by -rc2.
 
> Pasha

-- 
Sincerely yours,
Mike.

