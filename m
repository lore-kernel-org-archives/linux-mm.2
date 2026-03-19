Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66DC7109190B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90A2A6B0585; Thu, 19 Mar 2026 14:59:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BB5E6B0586; Thu, 19 Mar 2026 14:59:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D0F16B0587; Thu, 19 Mar 2026 14:59:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 69DD16B0585
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:59:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 12B2CC2466
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:59:37 +0000 (UTC)
X-FDA: 84563726394.04.3C53471
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0230E1A0007
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:59:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RlINErwB;
	spf=pass (imf19.hostedemail.com: domain of audra@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=audra@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773946775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fsfMjIfsjtusJhQnCeKcSJI9AYx2DQ1suMzXsS8unaE=;
	b=Uf/BreFN7rKU1AUKRunvSUf8gyh+Z/lrIXdHeJmRf7TdCasG9I6Vul9Xrlxh1bkJQFK4RR
	Jil2bMBziFIgS9mmTF8ODImWv5y1UJXI77JTOepXLzeErWkoFSLX1Ny6HygsC5Xgs0UYDX
	/33mt5b/kGU9HV56EXwL+O0AsKmhPqE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RlINErwB;
	spf=pass (imf19.hostedemail.com: domain of audra@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=audra@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773946775; a=rsa-sha256;
	cv=none;
	b=jYBI2iMVg1kJsseu5M1p19hG/TuFSIxgOzGGnFqELwif6u18lGuBRA20oC+JUcIteDHgmh
	dNncLws0OVH04GHerS6A91hml5Pam8OL4HgqNuFHjEQkZZeb9vcf6rNYTt8dN1ul5RFBxj
	IgfvP4ltnN0/m7wL5Wgy1SmKTnNS5Rs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773946774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fsfMjIfsjtusJhQnCeKcSJI9AYx2DQ1suMzXsS8unaE=;
	b=RlINErwBqGVeroV9aN6Ld48u1OqJXTRCQJN9bHRg44REBbPlDJoOGx6GXgGBz4fc+gOoae
	VIqxUKLjcqEbwGieErd7XlZnvE9NaCZfyvkOQyeFMBBj1ec8Tb/LVNLe0UxOStSxIDrMCi
	l+bB2kS4PbjBL8aLBsOi1I882y8dxCM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-af_DePgMM2K06eY_rYCjTg-1; Thu,
 19 Mar 2026 14:59:28 -0400
X-MC-Unique: af_DePgMM2K06eY_rYCjTg-1
X-Mimecast-MFC-AGG-ID: af_DePgMM2K06eY_rYCjTg_1773946766
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1802A1956089;
	Thu, 19 Mar 2026 18:59:26 +0000 (UTC)
Received: from fedora (unknown [10.22.80.202])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0A57D1800763;
	Thu, 19 Mar 2026 18:59:23 +0000 (UTC)
Date: Thu, 19 Mar 2026 14:59:21 -0400
From: Audra Mitchell <audra@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kselftest@vger.kernel.org, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Fix soft-dirty kselftest supported check
Message-ID: <abxHibvF8E5dcrUf@fedora>
References: <20260218184210.206466-1-audra@redhat.com>
 <c1b6f8eb-602b-4306-ad60-7a181fd94a45@kernel.org>
 <abludfGu4upPcyRI@fedora>
 <f635585f-7488-4bfe-8566-1c19f493c6a3@kernel.org>
MIME-Version: 1.0
In-Reply-To: <f635585f-7488-4bfe-8566-1c19f493c6a3@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: U4PQIn9VnKpOxiUA0pEAjhqqXcVlDx1rzGjwT2Z3bzM_1773946766
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 0230E1A0007
X-Rspamd-Server: rspam08
X-Stat-Signature: pw5grf3c17dwwreyij8pdi4n9a59p5nx
X-HE-Tag: 1773946774-309119
X-HE-Meta: U2FsdGVkX1+ht/gdqpJoXhTP+j7gKn9lyuQ5g1GQoBrUDkZkklPcu3BVLN0nuLtibUlYs6VxkTnfqHVNbpHam4yfgU3IERmdwleXKwrRBT8WtRpgqQXJb2GsRhiXl+gjUOz9z0xE/k5SIPNl6Kc4cn69J58AoH3O3ouh7mLEwlatApcdcXkepnNKUE06ML0GtNYoc2DdqVxfUPX+8wvaqxwqDRUr+DAzO3BrI63SzTZwGk9FtREfMEmWCYtXpQUj4Dkq4nmJILfnvQWRqjrRnTXuZgxjdZHpJqH/s/V3AVMG91z4e03TS0JwMFl6up6EPh+JuwKC9WsRYYXbqPvJF7jIYKcnyCBnrUHKdWUFtzbnBgMNzowexcaR13texTBkmeW9ja/UILKyCB8Bm9gDUZI9Fabnd+qYYukDyxlxrYnsW9ByFy9SbXiPwcI5uMWtTpYsVngGdchkQk3W81BzJ7GnGQ/ZG8hVwU+txCponCV2zKIe1Yz9SeuqpvVi06LZ7OxEAdmc7xYfJkT3mrlCM79nE5FO7tNW0s/hB4fAjbHlGVDaOBDDy1d+YsuyD3FL/bY1YnEGF7m9d4e5qQ5b8ytkYQp8E01B0Rx9cVKesqPrPpmxH2Z7oBOo3F0wsICogHWwheEKZkGa2G65GsHriptEFLWRCa361xokWZTWS+UHCaLIyZwjqIdgeBWwlEZ2U+Lmp9BVyT4Wx7XPwOil4PVOu9D6s5vktTVHmnnmevR2oV/YR+ifcx4m/hJYjvipe2ELV3Lc4ZvkZnBtgQf04QYsJNP+DfZgmTJiyjq9MDk2Jjfxx3IY2zL9hug8MS7Dh4kUJyyRzucF8rSy9I1kwJ/6zVm9ddRYKyoPB3xS4ceEWZ9YI9usQi4k+QMKp4+u051OpprYsIHofFZ6gAWxoYlIWIqN3yu6h2Pvx/u87mDMa1Qgli+ZzLniaBy6703+hq3fs76wZCa550MuOF7
 sRmZ6GKY
 cD7Eo10tQ2mxYFxgHgUN3Knm/EcCVX3hKmOnxnEq28L3fZZK77ndfxBwUua9QHTsXDj6r3eBvbqhMXEO49QEgtMg1gERipryBUzhPIQP/SjwNFZPMTzFihpUtTEo0r6TQMSu0ywavhS2OMUySKprMGllmX9kVOoNylxz5JKbnQujlNmGZLj89RF+ajxNtCFjrp4651SdTHLXwdwrsXDIKKaKsZBgFLzm1Pk+sCyrgl5+Eo5RU3GIgIMUG5BkE3m+OO4j3lisz7grkDDcNHRCVJ+ON7vLbpXJYmyP7SWg9/AoY0juD/4QM6ThGLYzUEkFPaA5ff2rDvD079egXNA8AMiy/8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> What about simply testing for success on a test area, wouldn't that be more reliable
> and clearer?

Hey I tested your version of this patch and it works fine on s390 and x86_64.
I have no issue with this version at all!

Would you prefer to push this fix since you wrote it or do you want me to push
a v2 and give you credit?

> > Fixes: 600bca580579 ("selftests/mm: check that PAGEMAP_SCAN returns correct categories")
> 
> Yes, please add that. We nowadays also add proper Fixes tags for tests.

Sure thing!

-- Audra


