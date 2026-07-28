Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEC31C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 05:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 965556B007B; Tue, 28 Jul 2026 01:24:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 916556B0088; Tue, 28 Jul 2026 01:24:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E0726B008A; Tue, 28 Jul 2026 01:24:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 468DA6B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:24:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AF3C8C0299
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:24:31 +0000 (UTC)
X-FDA: 85037045142.22.69EDE12
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id 13A61A0003
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:24:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=c3iCs7MH;
	spf=pass (imf25.hostedemail.com: domain of hughd@google.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785216270;
	b=Zx8CqNI5Nez9jShgxdOiEYCj/PjwoiFFWDHRyrPwsLVsyCOo8/FjzVRpmk4iybfacd+irN
	pNEbYsWufytfQkSor/83Oz3S0fGPtGVg1oV+r7wDHuI39C0xIK7NgR7+iJyYyNts9IIMaX
	ymkJIuyQXcxbV56lMuugjI49QUJxr+o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=c3iCs7MH;
	spf=pass (imf25.hostedemail.com: domain of hughd@google.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785216270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+dP2n6X89PfagInpqwKnt0atKqO22OfQKc1DqTtxeCs=;
	b=uF+oEJEncKRwr5cJAg1oVD4GweP+sXrxNd7cmaoYjadYSjG0BxF5g0yu62LGjlX+L38e0r
	gvg1yOikkXW9NYDOlihPtfEQUbRcLiTDYarqIvkuZV1oM82RSx62pKsXjVw/LmW6k0TTah
	JEQ2/g26nudhrngXQ8dRyxVVqTks9kk=
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-66892c81725so3859479d50.2
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 22:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785216269; x=1785821069; darn=kvack.org;
        h=content-type:mime-version:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+dP2n6X89PfagInpqwKnt0atKqO22OfQKc1DqTtxeCs=;
        b=c3iCs7MHGALRUmu7unjp3HKu0hZLdtcNIHQynqQMGXJtplYSb9LoWAWqmqyS5d4NLk
         dbcjyqW4aLtNRCGiB/e1MSI2/kUnnh2+SgiWQD77D7WC474oBBfS6CUp0lhALDR4fbzH
         tryoH0GYBbDPEpcMDIFQScbEzRdx9eHEhlvuKjie04g+bKNK3m7fHZj8hmBB709IVG2i
         eUsBSs+SXSXe1WL6C+SmpbopKZIEoqpmTtTE2tgCjEi/9hGKnwTHDSbAo673DinYlqLz
         mv+5en75qJ1aYfTWKqNOB9Htvxy69I5yEUCwDZvEl8PmbmOMECxvi1mh9QF7rOk8zQEN
         zdlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785216269; x=1785821069;
        h=content-type:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=+dP2n6X89PfagInpqwKnt0atKqO22OfQKc1DqTtxeCs=;
        b=LE8WRC/otByh4EBjRBaahcSqQJgEn3bd/tYRcC1X8LAOYWldDz4DQiVeaPoxJXW8ec
         gLFiBLTX+ITzuK5keVGRzehem8cQt1+S+njLQMWk3CO4Vtnyk5QwTbKGq9V46lgLr26Q
         kdH2Flqko/N7cx/Rde81YCHLoR2PkS6e0OYTJ7z7FoShz8TfnHMYNTzmnDw6qF6bkxOq
         N4HnvbKqXTMl5ii6tfFM9JSa1LtL08fmkNsduO1SIToc8BzHqS7k/npEu8eYhi/YnuU3
         PDnl5NVKNSpekjzZ4AARtmmu8SlTmpvABO5l2i+XJTULt6d1aNfOK7DqqrCoLTquzrba
         3OFQ==
X-Forwarded-Encrypted: i=1; AHgh+RpyWeFBc/JjX3Bf0N+FZxCUHAo/1c0jlNageuPi5EpBaCd9tTDK00r472OeMXBxTx8qweP2j5Wf2A==@kvack.org
X-Gm-Message-State: AOJu0YyEb/VlLa0zKQRZOdpG0hPtg3JG1h2Ehq4aiPKU+afDoyLfPK7H
	yTWgm2xg6QdhoGCHIlKl+CRA72S1tr6K6F7soKU3FUouOLoJig/PPrdvhSnZRCktUA==
X-Gm-Gg: AR+sD13Fx4B4WbiJFO29IpbmWEYhSecoNVsA0OrDvRWmS90PZSUQ6KoA161SZPN7qnA
	BwEVa1NBcymNTWIPzjfxLHCS3KZDINWR+NzHDZzZvaFIpHLD4IN5ZomqnxxT/Dpjo8+pYcDfm2B
	ElsVqR1gRYTR92zh+q2P8jze25f74WDLcC7YR1NcJWZ8zUykHTT5C0wK3BIDpKVF8D/pL9MhM+Y
	1GKy3gI8bs17sjRBiXqgZp5YbJHW0EWtuDWkqF9fJLrGMsnDpXeVsOnGzyn7LPQw0QahCqWolv4
	6Q2mtqA6brtzdytuLViGed/+wKfjTyFxNQVF6RuLtNT+sPRJBlsqx4hsEt7Mujmi2tB7oFnbe0v
	sEQYqJB9NLl6QGEiXwQ9QytDCAe8bJnKvqXycIllpTrtHVhtLEZT9KccI49gYXsIcxenRE1Tdsb
	VRHX2VjhVpddte+Q7W/7frBA12y4N0lkZRt14ArsCSmywpgCfmRWt25ODFxRbVWA==
X-Received: by 2002:a05:690e:4088:b0:662:f28b:7c63 with SMTP id 956f58d0204a3-669057a7895mr344755d50.63.1785216268371;
        Mon, 27 Jul 2026 22:24:28 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-668c6d2f9e0sm4496668d50.2.2026.07.27.22.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 22:24:27 -0700 (PDT)
Date: Mon, 27 Jul 2026 22:24:14 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Zi Yan <ziy@nvidia.com>, Kairui Song <ryncsn@gmail.com>, 
    Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
    David Hildenbrand <david@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, 
    Chris Arges <carges@cloudflare.com>, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] mm/filemap: __filemap_add_folio() restore index before
 retrying
Message-ID: <562fbfa6-dd6d-0b6a-2461-ed2ff1173bc8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 13A61A0003
X-Stat-Signature: sofbhjrd8cup7kys35foodr48e4qzkzt
X-Rspam-User: 
X-HE-Tag: 1785216269-153745
X-HE-Meta: U2FsdGVkX1/+xDu4I2/yWXFT0ztplHNAc1NjQBFoWLEKDKxtPeVBsOr+qgolVn+9edrmFf3L/VS2b7j1lvHqJOdWTp2uQJW4RqXq01bShWdNjzaPX5tPvkJN/u7XMaheIiBg0+mi6/rEqdIhgW+It/ip/OtKnpE1EUTHU1uiGLt8aXaTkP8rfbN00Y+5ZMTN0MUinGA4vt/Q8w/UTvK7naxJBZZR84x3j0G1JVwOJU0FVjbDA2imc4R+3TerbwOP1qg3J08mU6VLqL060gaVbCt0ORYHzvZI1F8g7a8P69/bkrwWhfD0icoqTvrPaNDwSdNKZ6eSnfgpBM1shRJICSie63L/q/+YOlRM+ml8pmcHIwbfevzGTL/4UOmq0MlN7fPHcmhkBNNDWkNvy21+63qDX00/JQb4yTMEekK8BaRAgF4wHPlRtK6vMHOtnpVDzV19N82H4kBB1Dw0YijYaEk6teYvA3zRGdnh6QOdVmKt4T+W6ifsIAKiyebILef4Mhmvys8tqUFrmpCRZpF6AStN3iW8WhH35vcKJH1kBHpTc6X5UQ7HrYcHb3XtYwEltGxQVLMajXgXFvF2Q4BGfGp3DDVqYctX/jo3qWEH2D+AqLYKi63aoszwzy4CcHdmm/DsNmBb24Bkm/ej/pxOcMRRqFJ3MhCNOuv7hBh2OwOBcvDjmFlgk2E+EzPw1hjmQXCqJ9Dzv0ro3HzBoBhRWCn5cWP9aILdxtPAzwT85e6kpQx9dqHS2M+gjZ8RrgBPii/jyZHogfJY+2HFTYSt5zqsaWsTdEQ9OTES07QWGFDwqudWvknrYdURoZzokExYXKmETuDdeefZtCTRgiGq2gB9B4cisfK6UjDUv97AblXm67eqXJ1dIsda38aXcKCi557KIumm+wsdY7bYpnmSlBhABtaklpPdrffK7ari+y/RmBgYxcIB7p+nsfK9xIdKp2kWoRTogQ7c+A3fyiA
 o8Stjq2i
 QpI82+c6qIvY2RaHOhlJEORki1d4aAm8cXauAMXkWCeZHQROyqMdvnbIJZxyyc+g6C0/F55yN60nd9EJ9gsW4gq2PGoWCJnLZ6dlXX3q0QLTeBY3Uxq+K/RG1pdkNCrnIIf0mPHT3SMK4cG0YxYVLQ2S/DAwKVXbfaRJSvJl0jnXqBzlvj9t7gbNs6y75rpNCEDn3SybJr+zt5TCIpQrGkl7ZCxIMCA4QD8zRPHeCYWdAcKqOMzFQWLDGwqifhE8dZ6JQY5MzUGlkB8bvzzCktGy3SM9s2UJT+9Fn2gINoLCBnCYSDV0nTOmmN0yJiQBqiOUYYyLAQUYCSBjv42B6Ii0+OVh73LZEks87Frh1dqQtCzgmOrNMZf5G8G6UHonMI1SfoZ8Beg/qQer33ZvC/967CtyeaABC1Sgm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In __filemap_add_folio()'s split-a-conflict loop, xas_set_order() is
applied repeatedly: each application modifies xas.xa_index, rounding it
down according to the split_order attempted at that stage: and if all
goes as intended, it eventually (or immediately) converges on an
xas_try_split() to the required folio_order, with xas.xa_index now the
same as index: then xas_store() puts the new folio into the xarray there.

But if a new node was needed, and GFP_NOWAIT allocation did not get one,
the lock is dropped, xas_nomem() used to allocate, and sequence retried.
If (that part of) the xarray is unchanged when the lock is reacquired,
no problem. But what if the conflict was meanwhile resolved by another
thread (perhaps even doing the same thing, inserting a folio at that same
index)? Isn't there a danger of now putting our folio into the xarray at
an intermediate rounded-down index? With !folio_contains() bug to follow,
when CONFIG_DEBUG_VM=y is checking for that.

Fix this with an xas_set_order() to restore the original xas.xa_index at
the bottom of the loop, so the retry does a full re-evaluation after
reacquiring the lock, and cannot reach xas_store() with the wrong index.

Production was suffering from rare SIGILLs and SIGSEGVs, executable text
found a page away from where it belonged, !folio_contains() bug hit when
debug enabled: symptoms not seen since this patch went in.

Fixes: 200a89c159a7 ("mm/filemap: use xas_try_split() in __filemap_add_folio()")
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: stable@vger.kernel.org
---
 mm/filemap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index 58eb9d240643..d721986d5f46 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -931,6 +931,12 @@ noinline int __filemap_add_folio(struct address_space *mapping,
 
 		if (!xas_nomem(&xas, gfp))
 			break;
+
+		/*
+		 * Lock has been dropped: start again with the original index
+		 * and order (but now with the memory reserved by xas_nomem()).
+		 */
+		xas_set_order(&xas, index, forder);
 	}
 
 	if (xas_error(&xas))

