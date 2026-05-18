Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C227CD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 21:35:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94F606B0093; Fri, 22 May 2026 17:35:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 900B66B0095; Fri, 22 May 2026 17:35:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EF166B0096; Fri, 22 May 2026 17:35:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A97D6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:35:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 126A48D936
	for <linux-mm@kvack.org>; Fri, 22 May 2026 21:35:36 +0000 (UTC)
X-FDA: 84796362672.20.D4014C0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2355240009
	for <linux-mm@kvack.org>; Fri, 22 May 2026 21:35:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CBTyM+d3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779485734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SZK/RLi1t6r+HjjdQF3xlH9OtNELyE9KnVbJoRHv44Y=;
	b=R6naMuVFG6PhCuikpLisnjswq1RZS4lyHViEk8uB5y8+Str0JM4OkHEitBYmzit+vZzRu3
	89+ag+4MFJ49Nxu6ZX21C9HxY5qe1EorBiiTIPvJ+Aqeu3JMLttQyxSNtbAIUcCBx6DFp0
	X0/kvuG1nkIPwakBUqJ0wLiN3iPZ358=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CBTyM+d3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779485734; a=rsa-sha256;
	cv=none;
	b=hwzsNPDDxpjy18nSyZu7z4h7E4l/1Aw+zTYucmCmAIwZv26RqaqIms40nO9krmlM6tHRqP
	G3mM3a5rF0ghr8elZQcPCahpxK9ag52TiSgVn2h6KBYM67ZNK/ezi/SRkSH309bJ10B0J2
	13r6e/VRH1BSfqJ5ZUBdlH3ze87/7Zg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779485733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SZK/RLi1t6r+HjjdQF3xlH9OtNELyE9KnVbJoRHv44Y=;
	b=CBTyM+d31JpZork+5l8JqX9EFrB/rJvmgdv9vhvDY0Ba7LpdNcVJf8BfWejH39uQvNyDTh
	KsvB+rMPaoi0yw8DM8FNeA7Fu1TEKfjjA3dozVzXvAulgi2SQLixvC7c5wJuUxbBRZT52a
	7kRRBob3rPXgR9lGOtSFLEtufWmH4SY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-503-u81rjDZiNkyYeWxRmA2-0A-1; Fri,
 22 May 2026 17:35:29 -0400
X-MC-Unique: u81rjDZiNkyYeWxRmA2-0A-1
X-Mimecast-MFC-AGG-ID: u81rjDZiNkyYeWxRmA2-0A_1779485727
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EF7D019560B5;
	Fri, 22 May 2026 21:35:25 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.2])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7AF171800465;
	Fri, 22 May 2026 21:35:24 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 0518D40147DDB; Mon, 18 May 2026 13:24:42 -0300 (-03)
Date: Mon, 18 May 2026 13:24:42 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras.c@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feun <boqun.feng@gmail.com>
Subject: Re: [PATCH v3 0/4] Introduce QPW for per-cpu operations (v3)
Message-ID: <ags9StiliW+fB1lV@tpad>
References: <20260323175544.807534301@redhat.com>
 <agsMqeTRU9MbzdQk@localhost.localdomain>
MIME-Version: 1.0
In-Reply-To: <agsMqeTRU9MbzdQk@localhost.localdomain>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: as4rXShlEqDxT0dJpaFvhbkOyMIo_TxkOxQk03Ca0wo_1779485727
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2355240009
X-Stat-Signature: 4zsseirgsz96dcufwecj4okzowywuuuh
X-Rspam-User: 
X-HE-Tag: 1779485733-545370
X-HE-Meta: U2FsdGVkX19Auj8eTL1JO/38CZ3gfjckYYHs9h7lcTjmG62LasQdTBiAIAYMkDLQiZgRtQ/kOAxryJdZPrrkHLDAM50gxcNa4SCJE8JksAe2ydtXA/mEI/Gjc4i1mo1NPDGjSJEgKm5N1TYNWZvr/o5qG2oamJ89+g+MNT3IWIpxkJE+DijKz7hsSvIQ/vVFEJRbKnWucONRpAWo59jwRQIEZwFpzdGJS41UUQzayAd5u3J/iboTlDBkKjfJWyAUr1zh7wNa88yggwiJyvMTeyGSximdz6m+NcRyaLZg6Tmlv5o1Oto6KY9h6adfYWzXsRh4SKrXMRzxIgHHlDI6kM1aiTp1W9ZOiByts7lz2Fh8AJUSWHtOp0GdsIZhU2VvWmDRY2Gs0+RR4wN6MP7oksxSL/Wu7aCLaYqTHrli0FRBYs8M5lLXvYH5Jy2+Iz+qdgNiBBc3hHlcpBxDZEKOs3kdS+FIweaFGcv+qKk3+oF4WgDyQBYPAHkVkFST0ipvdNhNXtD5cKjdKAjQJYaRybZnlSdyLP/Em0jbEfNuz/23T5pVHq/Qyjq82KqS59/DyLBs8PWCQq8vsmqDtOdwqRGETgQcy8oGvRdmEy832ahlBQxC4vhFGj8WBovSUIh6C6uZeSN2P8wmFuu+QDOEkZS/Ebt3MQtKmEaBd/SDckaqt/lUCRZaJmaTMHLNgKfQvlsa0H+650Nnq7SRP04YCPEgFpk3Da51zdPeQ+3xbMmLyJ8ZwF/uDiIAvU7ytHdl16ZquyPExhSyiN8+YCKs7G5X8qrxJ8vbhFGqBdvUEzUbKQckEb5HrbVecw77uANRQKAGek5wP8w7lh9teQTEBUuXXYc2igyrmtOPjlDrTkjQvCXz9mt3gS2K7+MTzir2Tz1UuWeSHTzO3HG7u+YNSU70syFXeCpEpkWVZS+u9kqYlZsSZbBcKFcEv4mucmpePcpgpozsy46AKNzied3
 cWoK96P6
 NvCwnG7gwkD8S6IUv04pwUgQ70huyRZmv2DdNPkhnmuJV5a4eX/eRl+F7DsrCYfDSGKf165np1iAJEoLBQHFWwrzKjUdeNB6fEJNftRqEbcwzcNnzz4oBCnvk3inz6S+HgOLP7Si6rSXtHIsjBMWncX/eNEv2JKHjQkPI1UGbsd24xsRPhEOR7KCtZojpP3udzFPYC5QshXpSgjU7uYOvPYzwug4wjbMKOlkjndbr3LuN3SqXXGKYU8yiLTuMVf0EXaKdkIc2lZIhndJgvmjIUMHxclomuS/zAXhZ5jWz7TvTyqO+PBo6+FPNrZm6sDiWbjj0JKKeQnCK4VsaoF61LXFbqr3pIGad9qjfGSLHuZZdBVT8Ab/4agOPHKa/05sN/Nll5gWDNsleHRe8G5xyqghqiyQfEU8hrTbAD0ta3GLdODg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 02:57:13PM +0200, Frederic Weisbecker wrote:
> Hi,
> 
> Is there any plan to proceed with this patchset?
> 
> Thanks.

Yes, will address Sashiko's comments and repost.


