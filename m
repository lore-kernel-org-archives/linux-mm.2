Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E7BB60B57D4
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K07H6Dgp
Received: by kanga.kvack.org (Postfix)
	id 4B6C66B0608; Mon,  2 Nov 2026 10:15:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48E036B0609; Mon,  2 Nov 2026 10:15:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CB286B060A; Mon,  2 Nov 2026 10:15:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3986B0608
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:15:31 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B24A0C0168
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:15:30 +0000 (UTC)
X-FDA: 85390528020.17.6119FAA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 228AE40013
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:15:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K07H6Dgp;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632529;
	b=Lh1VGuXajJkpXRQAp2Sg3xJoDmjgUaf6lFYtrGVKCIbPEiOA6ha+e/igfCZBiuNPgW5TwT
	EtMyhSEIs6tRF9ayHGP+5jyIs9PLy+jFInA4Cdjw44w+8P2ndhF1wbEeBbW+sN2dbM2jbJ
	cIUzC36tKOZGLy1It2DGPPsjVTgOfFw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uqUPlqkVta7QAPXLZJT6suihZgAnRDLT5vupBHeyO4s=;
	b=kt3FhpFL5bTNJcrfWAkiDKWY59em1o6dk3eOCnfzYv5xC/K6DjjoefCXkDPD8gZK+tlPHJ
	7FW4RKs8ONBlnKXc7UDZECL7PVh2GjnmOF5jGMZPPBeXAzMmxEscbPwz9HGvBrSflCAIAL
	O+QlcHEG1Otqs7xfkIzrQ3gzulLFg1Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K07H6Dgp;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AA04E60622;
	Mon,  2 Nov 2026 15:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE851F00A16;
	Mon,  2 Nov 2026 15:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632528;
	bh=uqUPlqkVta7QAPXLZJT6suihZgAnRDLT5vupBHeyO4s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K07H6DgppmhjUzA8+0NvjY7yHQipr4m8oLVhiW3s0IC2W+EupQPm6gJKU+28EOLMo
	 ytsqmp2pAFMMQpfHQ0Wyna6YlGcqSQ+dgAV6MDlvYvPjzU8kQRGTkrG1lhPTqfArqI
	 dVD+B8MamidXEDMwqT0ERIrfhYFIA3eoMDoVWtHSeDxJdLPXAmIQaGdzoC62l1El2G
	 i8wpqlu2RXRNlt9QGkmYS9Qy3Pwts3AoFGKUsZpbwSDXJbq5FkiNKN6I0KH7pIa1hV
	 wVqttZUVmqYAZqekG+NuIEvcr42DI0fAfY0mUmxdDr1FE9td5gy6RJd+Bw2QL7Zkxc
	 nK+eCnmHWp8qw==
Date: Mon, 2 Nov 2026 15:15:26 +0000
From: Harry Yoo <harry@kernel.org>
To: Puranjay Mohan <puranjay@kernel.org>
Cc: linux-mm@kvack.org, Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm/slab: Call call_rcu() directly from
 __kfree_rcu_sheaf() in any context
Message-ID: <auiobcNmt-sjg-2H@thinkstation>
References: <20261016155340.3304319-1-puranjay@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016155340.3304319-1-puranjay@kernel.org>
X-Stat-Signature: jxzirr114xijcsmucyuskxzn8148s3o5
X-Rspamd-Queue-Id: 228AE40013
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793632528-802209
X-HE-Meta: U2FsdGVkX19Rs/B6d7sWhe48VrtC7J0ovYe+pDkC9XPxiWiqbDdMweT2LSNo69OaIVHLWkyT1oOx/CpeT2XclHxVXEcmrV5DYJhrs4aHGvnw0361FuAPbs9dbV8WE+JQNinzHApzA6OEZSQyOWe7IfhQoYvCEWsgo7vL/dq8g2ZmPE1yTcPVi9ix2BjG0jRIHxbiKwMDFQ55hWXDFpXa0WAaCWgziECnAPP1i0XkqVLSvNN7ljE/J46XpTItDWAGRMTX5E03CsUHRkgyHnUprKli75sQBGzQLrRzsOyruKtWBJhowt312YaSfDb7r3HmJQY2FABel4xEQZ+E7M9loRsHUhessABJWH/4raV+DANkhvkIJTojitmcLeLfPv2mbxFqJ4zqaPptzvuWgl1O1IqIX1K95ldF1wyuSZMiW4kls7WfopbKQcLoNr3WjXXiz45xadH8qBeDO6bwXWlGURggoOxIk006BDTZkZxBnMF8Z9pUe+uGHueuHAkH5fVoPJyoB4A61cg0FrBoW8/CZdiRafq1wI3431itxD7qVmdq+oQCvfiJfMoyZH/4bh9gEfdu6idcVS3O9zQnTna6dQOFmtOckDHzMcgNjun1CgyrzVYOcn0iWO6w4UqTBwH1osf8Mim8ZjkrbvIJYVD30bU95ss33m71F/v8p4w7Hi3C9R2UVdaqE+qXseKSUkSrhPDcrgCOxwaWUtOAExhM5yFl+rDXR4gv5jcIik2V/DyNOp7/GfPzV7x3lIBPLPiEr21ddK59y6AA8qD+rbHnAi8OObEyLAgqAN6EfhrfcteKUuoP8ctHDNKcDun0jcstDayGutQ1A9Vrps8ETRI9URsFCgZFWGQ8KV9Y65yG4/SqHwYafbVGVwwQvcCJSjGRiUXGStd/PF5mhm3DpXulbikm7m3KcNw6Mt2LWn2Gmfb951ZU+o5rm3Wt23OBJHpr5eg7QBvjAk2SlooaasQ
 C7ofaRX2
 igVjPetJG7BLENbpdWQKmXAOG+JSlHNeq8CR24fl0OGr+1Z31N/wALsQAEScUTwhknNoBrqlnxliKZnvfEA/PKtyN2B6aC3Lq4N5S1gEVRRyAwKXk52lt9N0U6/zpPt3Auiv0oJRPqlMTyaRUZxQhxudsE7scdV0vKvmb0Y8bux0pTnE1rEydD3hV933223Zvssh9N7+hm+mHdlycTEJRY5PTlUOE9EpRIsu53RgzjdvTEFfEa1wOeAY/GIalXCe7zMkDzcAhwX07isT5cwwHAuTHr2hoUo6zF/FSNF+9rzDrfu3tGtyiPkyNIZAQDZASJwvquSkH8oIjb+txWG0cFZdUrtZDGXCe2K9xl/uAHW/XaNs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 16, 2026 at 08:53:39AM -0700, Puranjay Mohan wrote:
> __kfree_rcu_sheaf() can run with allow_spin == false, e.g. from
> kfree_rcu_nolock(), where it may interrupt call_rcu() itself on the same
> CPU. call_rcu() was not reentrant, so commit 69abda97a09b2 ("mm/slab:
> extend deferred free mechanism to handle rcu sheaves") added a fallback:
> when !allow_spin and IRQs are disabled, the full rcu sheaf is put on a
> per-CPU llist and submitted to call_rcu() later from irq_work.
> 
> call_rcu() now handles this itself. When it is called with IRQs disabled
> (from NMI, or re-entered from instrumentation), it stages the callback on
> a per-CPU list and re-issues it from irq_work. Callers no longer need to
> guard against that, so always call call_rcu() directly and remove the
> rcu_sheaves llist and its irq_work handling.
> 
> Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

Thanks Puranjay for cleaning this up.

-- 
Cheers,
Harry / Hyeonggon

