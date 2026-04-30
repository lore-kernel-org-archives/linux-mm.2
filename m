Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61BEBFF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 01:08:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A3B26B0088; Wed, 29 Apr 2026 21:08:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 654CA6B008A; Wed, 29 Apr 2026 21:08:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56A9C6B008C; Wed, 29 Apr 2026 21:08:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 42E4A6B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:08:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C05771BA320
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 01:00:24 +0000 (UTC)
X-FDA: 84713416410.22.BC8E4DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id C1C2A20007
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 01:00:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H8++NKB0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777510823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mCokaaiijHtYDOccRoJOeAVP25EYT0Tme3ss2q8h1Ek=;
	b=KILmsqaTMhlUiKXGgz7g0cNrciCwCrGyBga2tcfPcl6NvzaNOD6GNttQxf9pJ3BQcrt2pX
	HnHX5G/0lIXAPGlr3V5vvKVcf1v4QxjLNFE5pm+OMBOiM09HS6viKmPhFwPpcjj44eOdKP
	BT60kosfs5+HbehipLKDvk/RwelI2rM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777510823; a=rsa-sha256;
	cv=none;
	b=Uv9msKOkMXLTmWw9Q6bxoWIsW4L9VCfIQV40t9Pd0E2vbQClpZgOnLHZ68l4LJz+QkbdUr
	U/AmC/EP4Hg6x7M3o5okU+OkNwFCEjbfGZM2KE4YecFXeDsJHhGNIc+YSPkPv9SDJ3TmWT
	ST9QD0s8rorq7KgxDz6ybSLcojcJDvA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H8++NKB0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D6B86024D;
	Thu, 30 Apr 2026 01:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BDFCC19425;
	Thu, 30 Apr 2026 01:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777510821;
	bh=wSFWxLyFmwkXCFlEqXdpW5aD9S/d9XFlVOX1pPmAbnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H8++NKB04PVoYU78Xho68s/d2aq4pwIy99pVtsI8OXDHx5luQL//4gQmPqP2fMJA9
	 vRCzfpwUs1OkROvSO/XcudpFJjqJ39Ra64kLarQC/6l3IodxJUqcrfUr/AK+OJN49m
	 BGHRXxwNcg0U0ccm7CoYlW+RLuIhkACKb/IJCtIkmW9x2KdvNjEj9YLOyD4o+6AKDI
	 B53z36PpE+a6YdMVFY+pllqe7epGTOsbX/Kia4wEzMVVtjtIMFGUlhNV+e9Nkwl5sM
	 uUPPgJcPCki5tj1/WihbxoIGi2+dCZWENwsyzTanrMHyudLJefh2RVOv7CblI4iPZe
	 W8UFXOeJC6NXA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Manuel Ebner <manuelebner@mailbox.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	workflows@vger.kernel.org,
	linux-sound@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 1/3] Documentation: adopt new coding style of type-aware kmalloc-family
Date: Wed, 29 Apr 2026 18:00:12 -0700
Message-ID: <20260430010013.113971-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260430005333.113698-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C1C2A20007
X-Stat-Signature: ptihc5g8setq11xkjkmru1ojs6gyy8p9
X-Rspam-User: 
X-HE-Tag: 1777510822-455184
X-HE-Meta: U2FsdGVkX1+baXzngl0AA7a+Oygj4aU5Q4stTE1CfViKRxbaSbfnRNsSlF7Kpy+oNQ2ATdolvFvwLasicId3dsSsAdECRsTXNSKnGxHFnShqdfTvW7fkmERvGX7HSK0Ox+XNOrs5mvSe4ztiYNrdxe/YVlxK5CJ58ktOQWKLjaMdgN1RNLMRUu+B5Dd22AXmHBi4rPBE2YOlv2BcCFr32gBOB1tMHrsAlbg1k16j3GEgC3E2n8W2LyVVczJT5gq2G4SoDsQSqYb8/uikpsqlZXnTwYiDAE5q3aujgZzgI63isDtEACG3qghGIZZfCyA1YzngW11bABNkC+mxeZQG1X8zuTJROCjoXfOAUtySNHCGzpNzBj4urrHfMoP/TH1GBZrRZ3uBdtkdTdHdit6YWgBBJq+2+73K9njmQcfSuICDkYOizw4Fp/hHPb5HwaBH5m1ENr6TZlekpRDqkrR980TWazh22JPP2PIjoGK6HW/xNrfk0zLvFDbFYVmgZWK4CF65CJYi7IyNLFFVNlHH523ipbRJz5QUTzkaqVc4vUGVBtOZP4MH9N7F+xlSHx8mvYO9kZnsMMaxtNQu77NipVdKVYqpxZU+cGAPYnI57FaKiNlqDioSUSAnqtcXRrRBlEJwz3yONNjBv3mzBiK6oXrkOZEfb5h9ZwNCU1nBHgExVknaks2gDP8PMgXpnLmIK0bERMD10S66cnraoUEC4cYQ91KKCeE5jrWT5c6QyyGPUeAw1Nwt9n6Q6C2ICwzna7y3Vxezpiw5cI+1Uyu/1T5/Syv5r7l1fT+2HvdP9LaE/lglQK8Ev8u1Ct+8exVm8Rricks1t+sJqjwqEfJ52MmQiPCyr3pAIOSvQdL3aIAcOI0IkXxS+832PjaVN1AIPm/I7fD7offX/C2sjwgzoK4MmDiEL5uaKAjNJ9DxKdzqIxhaNYZfTaf4lVQIJr0xtTYc5R7ag2t3jP7kQdk
 f6ZDn9v9
 XoSeuezcFFGmRDrdUZD8FJrYZ919O6D18eCoO+gmvsyDwUBO+vUmWd8q1Re0fPLxlDc8s2dxaOZNUTF1vkFdOXCEukzMq6WNTX+ubnItKejKcCdGMbzTfm/sf7057N4fF+k/iIdy1Y8i6ACYD3k1tBet0GcqZBuavFJpeF/1s7KKyNTjb/gJ6H18rME7xAOlCJvItHuh5b2Y3sbV184730ns0FmxpT1zHc0uwvgHVk8MTgloj1M4/92ijx9uNI1m/I6iSIWY2OGOtR0t26ZNYtu4s97eD0nQwvAhQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Apr 2026 17:53:36 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Wed, 29 Apr 2026 09:14:44 +0200 Manuel Ebner <manuelebner@mailbox.org> wrote:
> 
> > Update the documentation to reflect new type-aware kmalloc-family as
> > suggested in commit 2932ba8d9c99 ("slab: Introduce kmalloc_obj()
> > and family")
> > 
> > ptr = kmalloc(sizeof(*ptr), gfp);
> >  -> ptr = kmalloc_obj(*ptr);
> > ptr = kmalloc(sizeof(struct some_obj_name), gfp);
> >  -> ptr = kmalloc_obj(*ptr);
> > ptr = kzalloc(sizeof(*ptr), gfp);
> >  -> ptr = kzalloc_obj(*ptr);
> > ptr = kmalloc_array(count, sizeof(*ptr), gfp);
> >  -> ptr = kmalloc_objs(*ptr, count);
> > ptr = kcalloc(count, sizeof(*ptr), gfp);
> >  -> ptr = kzalloc_objs(*ptr, count);

Forgot asking this, sorry.  Shouldn't 'gfp' parameters be kept?

> > 
> > Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
> 
> Acked-by: SeongJae Park <sj@kernel.org>

My Acked-by: is still valid regardless of your answer to my trivial question.


Thanks,
SJ

[...]

