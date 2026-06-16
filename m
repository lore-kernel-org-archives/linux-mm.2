Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A66CCD98EF
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:12:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97D056B00E8; Tue, 16 Jun 2026 17:12:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 906786B00EA; Tue, 16 Jun 2026 17:12:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F6066B00EB; Tue, 16 Jun 2026 17:12:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 52CEE6B00E8
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:12:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E32DE1A0281
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:12:33 +0000 (UTC)
X-FDA: 84887024586.22.E5D6795
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id B357920004
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:12:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VJG04cDU;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781644352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qK4T7fdzf+4jS5Qz9HQ8ZJ3mxvv+i3xvL3Ify4/NlU0=;
	b=Nrtf8lGSw5AMLo8Ox4QyRtgKtQW5389XZjCLNWx7QMKyZb/qbe4idN1nydnCQUbK/ULwVD
	FeQSRaSRKRJ8Rr2I6jQjZi1y1nYMZkyn0b85bDi4Klcc/THYukjim9ZlDT1fTIflMt8bvb
	mzLmvD0Rz/YxT2Oejf5ZRhhHZYI9mu0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VJG04cDU;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781644352;
	b=uEebTNGEj+YFAdnd39U0nFF5AD1nYC+4j6d494o9Knaoi3sZMhQgYCYJSJFe8nlQx1R4H5
	89DU+ZzaVA+pLJCNFjTiXnGv/JKqJZbSEET7TpkGz7x6aBHx5K1h3CGu99yXyunf/zO9nV
	3mkVAfmnQewHyKf8pldZ9YipHVIXQWM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781644351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qK4T7fdzf+4jS5Qz9HQ8ZJ3mxvv+i3xvL3Ify4/NlU0=;
	b=VJG04cDUKZC5mZn9J18Aoks/ySSxyWfcMa8sDS0gq7jMbDXC2MWD4TcesPU7hpRWft8OAh
	/W6j69Pkdhlj6W8Zv7MldY5RU7JqYzZIbQPG8batgpDH85qw2fANyTRn96qQP5q2Qy9M4I
	guT2XrE4ttqoDPGDAyFHxyBerrPBbOI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-444-x5XZe8uwOSelAPufU04BYg-1; Tue,
 16 Jun 2026 09:10:15 -0400
X-MC-Unique: x5XZe8uwOSelAPufU04BYg-1
X-Mimecast-MFC-AGG-ID: x5XZe8uwOSelAPufU04BYg_1781615413
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9DED81802678;
	Tue, 16 Jun 2026 13:10:12 +0000 (UTC)
Received: from fedora (unknown [10.44.32.13])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 037541954105;
	Tue, 16 Jun 2026 13:10:07 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue, 16 Jun 2026 15:10:12 +0200 (CEST)
Date: Tue, 16 Jun 2026 15:10:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Breno Leitao <leitao@debian.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>, lance.yang@linux.dev,
	Davidlohr Bueso <dave@stgolabs.net>, Qian Cai <cai@lca.pw>,
	sj@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v3 3/3] mm/kmemleak: stop the per-cpu and struct page
 scans early too
Message-ID: <ajFLLnHNm-mUMRaz@redhat.com>
References: <20260615-kmemleak-stack-resched-v3-0-acecd7d7fd92@debian.org>
 <20260615-kmemleak-stack-resched-v3-3-acecd7d7fd92@debian.org>
 <ajEgSI_UiTPU5eIF@redhat.com>
 <ajFFTw6natWGsoCy@gmail.com>
MIME-Version: 1.0
In-Reply-To: <ajFFTw6natWGsoCy@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: LxFYz4VvdtRPUt8FoaMKYvtS80T656cw1xtYBpCD5g8_1781615413
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: B357920004
X-Rspam-User: 
X-Stat-Signature: fj6uemi3dj5djrhu88rrn5hae3jpe64m
X-Rspamd-Server: rspam09
X-HE-Tag: 1781644351-539845
X-HE-Meta: U2FsdGVkX18i5c2FZXFRL/2ilE0MRIx9UAoq7vH49vusv54EBVSCobOht3OQC3zZEvEUkm4Gdnl59n5tzFgG8qIhYKZsP8bbFOgfjqCV9n5sq626XxamcYkUNrdQvuMhgQ0PICZ3hZ5apZ1GWP3hdaWlfnd59sNcfsur3e4W6uPumqbTOscS5pXfS2AXOp91XWeahP2wimhW8hbq4iiOSvrSV7PPECe63LhpaVNeV3czXSTbMW2hwmBbubFinj3w102X5eKAQeTcY8pi0YGbc3DPIwDF3jJlooBj1uVt94sVq+DMB/KFwn+/Jcwo63GDczEfThevrE2u2cTMx0fGVNzUkmxF/njVPfHNza42DEOsYPq8XGPnc+aNjBlQSySl+r93IpziL+Fzt7uxB0VB4DvIU3RrIP1DxL1j65Nt1bIC5aWXFG1XPHFRwFUQbwWrxcHHuf9VRg7TxXZ2j7EXWK90VVcDhTNK0nzxmj5nfGGx7Hk7z2WvcmmH+ry34ePv4oIHsns7DBIRhQXtFf2XT87bGDZEecLMxXDhQV1bA9t1aM96N3WAuBq9o4XrWCPZhB6YO2RIQx4k4Tih3ywN4YCZTp/Uu+cO7gV5Bj3S+jeO0VJMhi+0mhaRNe5GilwSoim3VKStiefXFZSr6Ca0MyOxq2gwVSzGyBzRLUeGWMAvZlCQ9/WZg9Xfgi3FfAZssPmxYaZAGeLkUKtrn6q7g74d7ph0pXhOMcJfIdk2e9qBpXCLnSagfRnp4sUSl9X2lk7tSKm/NZIHeiA2z0WA5A8wAaa6iEljkC+2k1wWQY4M9G77BdTxP2EumWy/sOQ7KmT8mNPEqr9A+/hu3Ymo2x8ErAjvyJ0uQzEyc6fEsOzu/g1Jz+V51TJ/DheE4iQBX84yJpFb4fmMYcOeUMZnB9k6dEXNeYkjmA2zqeZNtZIymp0rPSgl6oxA29yoPLR2swjcLEjPt7gdH0zwpNH
 EL1AXaoc
 El4fmlZNgcYof8wJjewvJYRj+B6TbFktn/KjccUypeV4wc5SdPuihCk1dZccL8TzIjXELjMgR3+W2kcFFwSUJzIKnBExJZ9kR3lS7Y+thi6hWZ0G7A9HMjMyszzdCN79BsAR6WTBKP1YTfK/2jwXH4r+Hqifu2EX5HoylgcW0dmJXvnmujwDGob4K+vVPAZwqGKnW0YcGtIZz2Y8/ICCaje/32CMOvAnsiLahRllpuc6o2EtURDhjq/ixZU5ejV+2n6MdJI23XGwtxoAErcLvgvaVfri/ts8vza53PnuegMufq87lQtr63hLPtorqZHR6kKzgGLloWzHWPYJNB4jKipDSzKVWR1f+D6W3CwlVB/Q3yUd8NX9vOVQonw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Breno,

On 06/16, Breno Leitao wrote:
>
> So I'd rather keep this series as-is and do that optimization as a follow-up
> once it lands, instead of growing a patch that's already been reviewed. Are
> you OK with that?

OK, agreed.

I don't think you need my ack, but FWIW

Reviewed-by: Oleg Nesterov <oleg@redhat.com>


