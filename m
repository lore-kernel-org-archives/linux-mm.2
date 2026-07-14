Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 690BBC4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 19:41:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29E3D6B0093; Tue, 14 Jul 2026 15:41:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 276246B0099; Tue, 14 Jul 2026 15:41:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B6926B009B; Tue, 14 Jul 2026 15:41:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ECF896B0093
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:41:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7D4921A04E3
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:41:48 +0000 (UTC)
X-FDA: 84988402296.15.17DEA0E
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3F33D120008
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:41:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zl8Y98I6;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784058106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kYcYCSULV/hfG7U7cWmlPQ/oHtSU1VEtwNwKSB8CpEM=;
	b=O1bKGC0Ra2AErRbJEJcDoFUuhq6S7LnWnUru1ebATmNsCdUAwhJZ7txUXFAnzaYnkHokKV
	Oya4oABxaMA/X4i730JxcmXmsZjWzDAmQeL5vMWoQm2UQrPzCLGYZXdmRK9JmhySbaVCyT
	4ul8EU8ikjfnJb0k8xTf54g4bwJyIXg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zl8Y98I6;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784058106;
	b=vfyog2MV6AgdViHFNwfxqLfXCGIKyEYwdYejzs0xeiXyJqd3LaSjpHqlo1Vk/kCrmGEK/+
	z/2m+TTgsRvgqhTVXnodwUIEzVGGw+3eMSS2Qhck2q+Hi4kbSDpHvA7BJVpApFLFcHW9eC
	MS1++cTwXvUyvAoyZ/tycyfWnMA0G6c=
Date: Tue, 14 Jul 2026 12:41:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784058103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kYcYCSULV/hfG7U7cWmlPQ/oHtSU1VEtwNwKSB8CpEM=;
	b=Zl8Y98I6TSwbZ6r8suDxniwyylFwFl2e1Uau1HCcE8ii377yG/8MagwcljzpEk0YOb8REZ
	qHJAuCBiRirQETZGb7LWtF5StJUHNQdqGjh3TlG5a6CDN6PbPEj9NBsA88g0TA5LrGRNq2
	e6ARkIOGoJ2oH9RrVX684FV/RY5Ob9o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: brauner@kernel.org, qi.zheng@linux.dev, jack@suse.cz, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-mm@kvack.org, hughd@google.com, boris@bur.io, clm@fb.com, dsterba@suse.com, 
	linux-btrfs@vger.kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org, hannes@cmpxchg.org, 
	riel@surriel.com, kernel-team@meta.com
Subject: Re: [PATCH] fs: push nr_cached_objects memcg gating into individual
 filesystems
Message-ID: <alaQ0VgxOuLVoYbU@linux.dev>
References: <20260714101454.1202449-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714101454.1202449-1-usama.arif@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3F33D120008
X-Stat-Signature: icj6a88rzgbudux8xkpqeqojxwxb366y
X-HE-Tag: 1784058105-412317
X-HE-Meta: U2FsdGVkX1/T7FsxKF+zw9YBMZ54sljIcaylN4XYoRPT4mcqGn3h4k7hxTgoUPKV8hwvpZNKlpzW8tWJ3rw+jtmccSCDtjvFkUqTMHt9987e5Iv3hgBy0PHBQ3cKOfc6+s+iQh93cDrJ2M3R+sbmAxd1xAyN0pJgLIL8jBRfclsX5h+bCzWVeXyMO0p9Szpgp99EaA4M78pCR3U1Bujm2/EEsZoArKMEq8a0FaPItoRf+PVEdxd4+q0Nh8FEREiZVrX75fyOPV8/GhH2MX7cXlZw1Twmv1WVl5QYhhueUj2XZId4KCG/JnMc05sW8fIh14mRe9tVO5aAcwNMlPc8X+cGlkglvcSbebYaDhwVeNMpL+bu9VZ6j8ogaxfc60HqszJBLFiXKjPqauhA15td0lOeYgQ+ahThRtrg7Kc3F8Vf+p5KB74VlBEIKgX7P6B8vIQAiC0FjJHpVUjbBHf8sPTgkbReyS65HfAx+tefCgTRVmypZfSQfOnGpU8EHuKElIWHJi248+pwGbDN98IhpNGwn1U20NLBXaXaNl74SL7yLnSGNzIkgw4Xtz0Kg4+eg32hHXZT0s3QPN7iAFAgF9gF/R180bRxpX+Wra54VNdrBtkXMyWc5pH1QIVPVjjgfiUtGIrfVkvIV1f8q1HDCLqsrtJuqnM9KcGNE9FYlN5rSAwTw8IpgJv3w6Ny637M6FQIdtlNaiQXS3EZXtAUu22BFhaQxh42zrxI4W+o//7HGg00rQu/5gvvZzOEk7TheqyvtpAlT3VTtTqARYH6m+MB9o65a9ZcHkbFBu3kh58za06kfOl02NBXA+VnzaTNQ/W8luh5YV7jf8T8Nm1nDokK74bTq6ri43QNEzC5ik4VcOfzbm3+TssDDP8uoqr0iLyVvtt7b+zLnXCaxtdFYCmuIXEXMOpuBKUSkRpzFTwF08JSJezpdml5pCoVx4J8/5TmyojE/wtn88kCblt
 8X0+g/vR
 dage8zUPdmRfzMD/S/H2n8EXQjUk8jnXBJYFcwp0Ci0+sDZbn5d9lgsa38+rYEjIlwIndlrNbXL78zW8Whz5Qw2bURLEtDTtme03tQXE3Eb25yYMQqzOGJUbFy+1C76oExZopBznzRcQyTkW4saCmVqz0gUqrs8zF0h9Hk6m60qSRoDejsiIGd79g9Gu237g+4EyU6lSzdLo6RFT5e5P2nv6rq+IsdCqsxZ1fFPiGIE0Q9FyMmtdSHmJgb8gwn+7Bfuri
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 03:14:54AM -0700, Usama Arif wrote:
> Commit 0baad6f9b997 ("fs/super: skip non-memcg-aware nr_cached_objects
> in memcg slab shrink") added a check in fs/super.c that skips the
> ->nr_cached_objects() hook whenever the shrinker is invoked for a
> non-root memcg, because none of the current implementations (btrfs,
> xfs, shmem huge) honour sc->memcg.
> 
> That policy is really a filesystem-owned property: fs/super.c should
> not encode the assumption that these hooks are never memcg-aware,
> since a future implementation might legitimately filter by sc->memcg.
> Move the check into btrfs_nr_cached_objects(), xfs_fs_nr_cached_objects()
> and shmem_unused_huge_count() so each filesystem can lift the
> restriction independently once its underlying counters/scans become
> memcg-aware, without needing a coordinated change to fs/super.c.
> 
> Behaviour is unchanged: calls into these hooks from shrink_slab_memcg()
> still early-return 0 for non-root memcg contexts, keeping the shrinker
> bit clearable in each memcg's bitmap; the global (kswapd or root
> direct reclaim) path still drives them as before.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

