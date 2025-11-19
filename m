Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 932ADCF2564
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 00:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D19AA6B0011; Tue, 18 Nov 2025 19:54:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF10A6B0089; Tue, 18 Nov 2025 19:54:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2EBF6B009D; Tue, 18 Nov 2025 19:54:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B24746B0011
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 19:54:07 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5597316028E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 00:54:07 +0000 (UTC)
X-FDA: 84125534934.05.3039573
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id A50C8160002
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 00:54:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="VoM/x51p";
	spf=pass (imf08.hostedemail.com: domain of oupton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=oupton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763513645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ia4Jz6cmDrN09XgjuGqDrF/80hZrLXIy7Z24x5aUL+c=;
	b=6vCCrXq4+t4chB0orG+ajz4/My5LrAAcsc0wc3DdRwj/rSLhgZ89w/PplUAIMjPGdR1Pz5
	v3qXl2RwZX4MftZPGM4eDhLY/DcUn7sgLutVbPBGDRuiwBQZhqk1pbE33Z+RmEeIiTSKi7
	A7ZYmK6sMzKr2qiOTTWpFP0VAqIk/5o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763513645; a=rsa-sha256;
	cv=none;
	b=JNiN8Mbt+soXL+94Gq2H6pbjq8+z3BmqY0ZJueZfH1u+M1akdJLJrIOGQTyRpHve3CSm1w
	wj8kFi2+lYGhZ12EL4oKcYNnOieeqWP0f3pqo5TSEZ0cR1shGDmGO5S1ef4hH93sot9VAw
	odZSWITyf4IcAPd0U7ohN40pzIbkk2M=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="VoM/x51p";
	spf=pass (imf08.hostedemail.com: domain of oupton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=oupton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BCC94385E;
	Wed, 19 Nov 2025 00:54:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A199C2BCB6;
	Wed, 19 Nov 2025 00:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763513643;
	bh=SpJfGIQpV72H2dtRGzaRjB5DzZJk8SmDJ++Y4B2SDVw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VoM/x51pdvlXZkIb0y3a2nU1/4bS8NbLwuWP8QVhR9Fzbb1Ck9yOE0LIMEknJsCAo
	 1c9Yhj9WTIQXytyIyDy6nfVDBVBMq+gAvmLp7bnRqegoCvV3VQb9BMygT2ThCGVrdi
	 +VqP7NQW36mTUNW5FJkoqhN2A1qlskv9KIh79BMOTPCiAxifEM9z6kIla+ApCNo7Ks
	 iok/zofUPYMqLDTFHA8i1Yc1mLW8zGjQ8zV6hENvF4+jYkEVKEABR44GfcHXucN+R/
	 cqyrQTrXN9Fos0LGQ9TO3XmXg2enU1p7+bBPOgai8Fg4Q5Igs9Rb3WaNyzPISxpFTH
	 x0I98fWDWnRmQ==
Date: Tue, 18 Nov 2025 16:54:01 -0800
From: Oliver Upton <oupton@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	bpf@vger.kernel.org, Uladzislau Rezki <urezki@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
Message-ID: <aR0VKf8bdvU72Pq8@kernel.org>
References: <20251117173530.43293-1-vishal.moola@gmail.com>
 <20251117173530.43293-2-vishal.moola@gmail.com>
 <20251118224448.GA998046@ax162>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251118224448.GA998046@ax162>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: A50C8160002
X-Stat-Signature: 3kd5rktj8n19i636o38q49hexz9iw5is
X-HE-Tag: 1763513645-643366
X-HE-Meta: U2FsdGVkX18DTGtBQ4VU2VO0cYEaN8ux0WncbXSTBSD1Q19bXYA3ZiR80VoLEsAnTVkKjzccSG1WAZ4bGH5d8WATYv3KawIgpHAijIqKTzOSJtYqSriz84Bu5w6XySpm5zwXuEg7xVtB1xyyQs5FJPumlwY9TZUfQdSgNV6/y2sFQj9urLhq4umhP6bCkYoWXNaKgOvs43PP78tck/mjGD0Ej2zAOaKSLYXJf/U2BBPDXfrFpmfCaRaMDuusNQn19qKjlkpfnIKIHqQTddO4/j8J8Y+2a1FkxJ89OwbW5Zi7lvOhx4ZaL8mvdkSnUNoFx1yfG429zUAAb1O/S+leRcHq33d1jv3J33qnZwGUXsX+hgFIBF0Q/UzdM7/OK3JJISR/Ey1iKaJ5RyO1hbxkbPaeY0v4xXc5a40Bikztp5EMEnct1n6fjNJDH4u65jN7h2JxUWkVOqFmiTZKlVYMvlq6Oyj/d3+ki82hNZ51w2rRIAgVUl11+Q5+wanc68184ns/NApVg7aQPfs9aZi9H6XQHfYRTS2H8vhRvqVlCfW1ddO1GgDz1Kfn4r6he7A4t67A/TOItb6dBOdKP38QQM846UnXBEaRuL+2Ynxe7dPjYz+LrPoiufJ+zrotopTi3Zhth4v1ddAU/F74Ux79eI/CStWHB+qtJenxQmPLqeT9kgUWGOLoUZTPNf8yqDbDAP/6yIKgN24Xr0/agP2aXubPAexwW68n+k17LKbzKFInWzlLvtWDxL9sNpgTDj9nYj9P06qV0sFUKHNAHK8JR8NSirlagAF7DpB6Fv6uEdbtsy1oyKfv7bt9DCahiqBU/hRjwgUYTPpIvsDtQwNBPm75iKvt3c6ouUAX3EDKaIkhcJQu1ZWOb+ZAPlMkWbyawh3KkAEqRq8QKE7ya6YdRstjYxRECS+8qYHqdffYjeqLyki47j4l4vsDIjTi4C805R538odAKeGazGkP+7v
 tARcG6CZ
 pzb3SzUwS5xc/v+7iAhmf7p5cowpYevV/szPs0crx7UcMq2G/jCzYlgSuVk+OxeO/PQ1Y5Ad/scV4Ykr84+6gsTPIr3/vVcTn9JB4gp3sWww+SCmvfl7gheACGgaNwnB/gCc/mhbafopfSfKRphkzdqeGB9oVedabnvfRKlUsJmDw0ST9tvN4YXlKhW856nvUB/JkhTPzjHkVZtZismRVfmAVoaNBKMzXRQLKhH8yt1uj4GU8YcfvwkuCCSpCRlVaVO0sM6O+BOScmc1WloMLaSfxayeHxujjmx+ECj28m81hvI/YoQp1Uv5mD5Vi626kElyuSdLKfFT1DrE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Nathan,

Thanks for reporting this.

On Tue, Nov 18, 2025 at 03:44:48PM -0700, Nathan Chancellor wrote:
> where kvm_arch_alloc_vm() from arch/arm64/kvm/arm.c is
> 
>   struct kvm *kvm_arch_alloc_vm(void)
>   {
>       size_t sz = sizeof(struct kvm);
> 
>       if (!has_vhe())
>           return kzalloc(sz, GFP_KERNEL_ACCOUNT);
> 
>       return __vmalloc(sz, GFP_KERNEL_ACCOUNT | __GFP_HIGHMEM | __GFP_ZERO);
>   }
> 
> Should __GFP_HIGHMEM be dropped from the call to __vmalloc? It looks
> like it was added by commit 115bae923ac8 ("KVM: arm64: Add memcg
> accounting to KVM allocations") back in 5.16.

Yep. May as well switch to kvzalloc() while we're at it.

Thanks,
Oliver

