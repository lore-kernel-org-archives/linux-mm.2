Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 974BB606A335
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 13:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cfvWjkj9
Received: by kanga.kvack.org (Postfix)
	id 8C9B06B05B3; Sat,  7 Nov 2026 08:27:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 873986B05B4; Sat,  7 Nov 2026 08:27:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 789DA6B05B5; Sat,  7 Nov 2026 08:27:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 58FF76B05B3
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 08:27:35 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC2E2A7EBB
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:27:34 +0000 (UTC)
X-FDA: 85408400028.25.F4A9C1A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 601BC80003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:27:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cfvWjkj9;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794058053;
	b=NwujiIDNZUZDJcls5LSKcFOx4yrwGWA+8qSZOdLaT0Kec4AO41ldfffKVGHvRyJmuiNrAg
	LmZ6zVM7L4BlmFxjiI/XhylJrlS98z9kBoYqwkc/1ZqsKTUXZ0wYANxeRori/unraA2+Lw
	df1lM3FapjxMkpb7CMlcuEyl2czwrK0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cfvWjkj9;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794058053;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LeMCQcp+aNw2vY2DViJmjvnYhSi5FExNVb5PVTrMZ8I=;
	b=bywfJtcxEAbcB936sBidI0VnoBQipIzPaMUlmPPELPOdgbpAtTmurRq6VsE2Vs7ReeQpVa
	SovvnvLv/oyMN8R4NIuzsuEOvTq0N1sgFtfrI2v8rEaaDR4Poy1nKCdn+qIO1AGc5Ydhdy
	LZrDiDwhAAKD9HcNMHV/N0s3Z/zUYRg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E76AB60202;
	Sat,  7 Nov 2026 13:27:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD22F1F008A5;
	Sat,  7 Nov 2026 13:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794058052;
	bh=LeMCQcp+aNw2vY2DViJmjvnYhSi5FExNVb5PVTrMZ8I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cfvWjkj9ub0BgN3rJLFiTs4aeo/Bwv2O2u8hiotL6T3h0Og00tAicVZTQRMjal2N4
	 YxBzIHsPtHFhBACJkAxTonpp6Wz4HYzPjpseNKyIYbkesT54caFh+LPEgc6KMapfg5
	 SX8PpxZoYSz8Pd4l2MNDjMF8mwn8AbnyibfSLd9oVPzfGl6nPRD93q3QXTWjkIijkc
	 z4p9pQU4AlO7M7qbmeSv9wDKXxIGzj3FKRfcnCRSeOvBHFFDlWt3mcSaWhgytNSPXL
	 dFkn2e4AFuRBElNx1uwR8NN29zOq6SGVrSEm0f9XYa8NDnCPDe0zQMoEvsaeqhtSRp
	 UHdFFwwUS1XWQ==
Message-ID: <sashiko-outbox-202923@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6/7] io_uring: account the ring context and SQPOLL
 thread data to memcg
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tao Cui" <cui.tao@linux.dev>, akpm@linux-foundation.org, dgilbert@interlog.com, mkp@kernel.org, loberman@redhat.com, jmeneghi@redhat.com, kraxel@redhat.com, vivek.kasireddy@intel.com, mst@redhat.com, jasowangio@gmail.com, eperezma@redhat.com, stefanha@redhat.com, sgarzare@redhat.com, rostedt@goodmis.org, vdonnefort@google.com, mhiramat@kernel.org, jgg@ziepe.ca, kevin.tian@intel.com, axboe@kernel.dk
Cc: linux-mm@kvack.org, James.Bottomley@HansenPartnership.com, sumit.semwal@linaro.org, christian.koenig@amd.com, phasta@kernel.org, joro@8bytes.org, will@kernel.org, linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org, kvm@vger.kernel.org, virtualization@lists.linux.dev, linux-trace-kernel@vger.kernel.org, bobbyeshleman@meta.com, mathieu.desnoyers@efficios.com, robin.murphy@arm.com, mason@kernel.org, aesteve@redhat.com, tjmercier@google.com, harry@kernel.org, vbabka@suse.cz, cuitao@kylinos.cn, media-ci@linuxtv.org
In-Reply-To: <20261106131829.3228926-7-cui.tao@linux.dev>
References: <20261106131829.3228926-1-cui.tao@linux.dev>
 <20261106131829.3228926-7-cui.tao@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 13:27:30 +0000
X-Stat-Signature: w7tcgsa8agef6wzk9fs1dkqb3apgjbym
X-Rspamd-Queue-Id: 601BC80003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794058053-378621
X-HE-Meta: U2FsdGVkX19BdWezarsHqpmW7sj+Jd3jrjI/BWmGDHLtYOqKEC4Rshx79afdXMoHEXkfO8SBtkqv/TLy8lWctV1xSvELah28zuF+7Ki9krGYLKQzymvJY3241XlmJHBGm5MaieScUcndYPSqlbuzZGMoGh2MqocGvHC2WdYARLkZedBYH27i/fwQGHRyy3f2wISeZP9Kshfe0CLX4ORofEdC8Nd9HZHs/wWzWVORJxNNZyvCe7qzh2Mxs0x2+i8nncNKrzlKoekg1SA5MHzt4ggEAsHudZYor7u+sjnVKJfZDuKhnVAxcOQ+xzGi4kWFwwKvIUApKedhLSTXzpv+4KS1k6rnI6zDcyW3abPN2hQaay6FH7qvqv7Lb3mdG0rmU7dhVhr8sgwv2sAa/O2Vx+GgGwHVChCdRYhe8Z3l4hI2d6L69zVTHwss8wd1m8MIMZzaLFcgSxJfwgpHeCW2OA7gfNMt52YVZ0itu6MEw+881yoDRZdtR2KTT4IVyAOW0rjYTuxqQqtyRWHDI4oPwsJLf6wl3ghsbdD3XEWqm0womXSXRvmBg/EPeuOb/YVsS+/ksgoe7fDk1GWD4WTDYwaxbfZG+lRaHwyDn+fWgYVNWRiNmWfcxPE6kus+tNXmr7FsLGuJXjEDqt+kZHGHok5GXhx5H2/GHn4Mz4SN2EGI73WrK2dAvz0n5Sup617XRveXXWh9RvXsmbYOGEMBEnkGQ+YWDxCgF2EaJ0kX7KCjv1yNk6MPRYzTNHEHuu0Rqyht3DXpbd+o9EKQBOmJvKqqtrIsCA1HMX45pCH7DHKv7yApFkHR0jMgmHb60pn5c5SpL4muBWlXCSduK0w4VDlDzYWLwutp3Lvj0QlWhCY/l+1wkv2GZFD8y5zOt0GkFEbDYBk/Na+3t6YWHyou4VvPoxDFvmJNGoPuP1zkXZgs4nSCt3SyB0FkPAMHkMNNNUlOh7YFelo/G2AX1I6
 VT8GJbga
 GgRF8klplcFGHf1GQHgLLCiMzQqicXyi5WTigZK2EpB1m5OuQC2UWqTmSwqf0MRXUDCAXsDTbitLzpP6IXedZ0ceCYqeOr/1nwSKKMsAkzVoamaB7T9ZyaqjXFJq6DLa0Mm8Shifws3/0XoyErY/jygYC7/x2TluotGROY7bOirTo6j5tS0tA7cYS8CTt19ZsjMwwp3an5Y4x12+e8pnlSxnNxVHfTBTehJmZug0Vytc2bDJxjmh9wff1hn5368gKaEmgcUwuRSTmkyNH1edWdSFCcFCipLt8DAPIa8KH17kCzresKwI9Agrl+xSPm1YK3KobYNTiWq4OI/88Z1akMMXqkYLhVn0+81Mdotl3nb+B6OWmDYuhkDqtDoOmjfYX6iCbt+cgeRsxFJi9+sCPog71l6HKFtEK33dH687SvZjs7sBaRhYZD2E6b9Y1T+jwIqv3eYnphq37Pl/M1YnYQZQZ4uqIXOocxYMNCCJnC+PaNGxM1RNDxiUJQgjQkjJiy7oDEbYMDYwVDyhSaziBrQK9xb6jEHjtzzOHfzn1fVc+RfqiH4h5ZgmL7o1j0OUP9tfNcFqMtYXY5x/FVjTwt1EZz8y4X1cxvtq2Vb03qvU1diKsQJ6U76+aEJUo/hNDSXXpjssUKGcJ9jJL96A9HH7WNfie90ujJ5OlxG43iDOFVatuiX+KwZfKQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] io_uring: commit message omits rsrc and tctx changes and
  uncharged allocs
--

commit 3d47975c4208930279f98824279734ca99b5e9bd
Author: Tao Cui <cuitao@kylinos.cn>

> io_uring: account the ring context and SQPOLL thread data to memcg
>
> The io_ring_ctx and the SQPOLL io_sqd are the last per-ring allocations
> made with plain GFP_KERNEL.  The larger surfaces around them are
> already charged: io_mapped_ubuf and io_rsrc_node since commit
> 075d5837bafc ("io_uring/rsrc: charge buffer arrays and nodes to memcg"),
> the tctx node and its XArrays since commit 0b34e7b20a48 ("io_uring:
> charge tctx nodes and personalities").
>
> Charge the context and the SQPOLL thread data the same way.
>
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>

[Severity: Low]
Does the commit message match the actual changes and current tree state?

Alongside io_ring_ctx and io_sq_data, the patch also switches new_array in
io_coalesce_buffer(), ctx->hash_map in io_init_wq_offload(), and
io_uring_task in io_uring_alloc_task_context() to GFP_KERNEL_ACCOUNT without
mentioning them in the subject or changelog.

The changelog also says these are the last per-ring GFP_KERNEL allocations.
While commit "io_uring: account the remaining per-object allocations to
memcg" later in the series converts io_alloc_cache_init() and io_wq_create(=
),
percpu_ref_init(&ctx->refs, ...) in io_ring_ctx_alloc(),
percpu_counter_init(&tctx->inflight, ...) in io_uring_alloc_task_context(),
and alloc_cpumask_var(&wq->cpu_mask, ...) in io_wq_create() still use plain
GFP_KERNEL.

Finally, the cited commits 075d5837bafc ("io_uring/rsrc: charge buffer
arrays and nodes to memcg") and 0b34e7b20a48 ("io_uring: charge tctx nodes
and personalities") are not present in the base tree, so io_alloc_imu(),
io_rsrc_node_alloc(), io_tctx_install_node(), tctx->xa, and
ctx->personalities remain uncharged.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106131829.3228=
926-1-cui.tao@linux.dev?part=3D6

