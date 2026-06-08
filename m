Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABBC7CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 14:33:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D6A86B008C; Mon,  8 Jun 2026 10:33:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 187476B0092; Mon,  8 Jun 2026 10:33:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09DE56B0093; Mon,  8 Jun 2026 10:33:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA6126B008C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:33:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B27801C00FD
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:33:00 +0000 (UTC)
X-FDA: 84856987320.21.25BCFA3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 23410C0014
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:32:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cEsURHEf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780929179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qy6RsutX/3EyVvMKECKZYGii+tGoP9bV2Cwg6nx5MYE=;
	b=SourpyYoW8o+k6b2I5kbh9LiMFss0bT3lC1tfL0me18Iix8vJRSf0jpwrDh6WPzmMxH3o9
	JduSc+huVn/ma0zLIn5M2Tgd0OvRdV4f6VduarsmF12oRP8a9low1J8jh0y6MBixQ9DRZd
	PZ7TQq7lwNMQzLBo+5KEjh3EBg1Nm4Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cEsURHEf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780929179;
	b=xDYfRQLu1vH8avzvMcE83iDHsgRyA3FILZjIgNLmQdilsoBYUSRijCdcO0dfAUnQ5Z2DOI
	utq6O0daXvSYBaJzx0SQ0SIjCYh9UPPePdn7wvwzvc5XLC2VoUQi2WEml1xEEgjfCmyoKt
	CJKiXNlrC2dolGhBuw+y8bcas0eh0v0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8FA57601D8;
	Mon,  8 Jun 2026 14:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1F21F00893;
	Mon,  8 Jun 2026 14:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780929178;
	bh=Qy6RsutX/3EyVvMKECKZYGii+tGoP9bV2Cwg6nx5MYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cEsURHEf+SyzeAxZqsgtOJg6ZDapk8ZljfaEDNhoKiKBwqIoUfkXVTVRH2YlKK17P
	 Rv3AB3+hIAkCAKvTE4ImtOEsqj/I0QTrihl04ffmcoKkWW+EkJJTc2wEZNF7+rk+b/
	 tQXl8BQ1/hMHLIDy/O+xITkpYuuHWnyoR0Nf35JYBOvAu34+vHU4hCw/8XI+Yja1Ml
	 +PLPVMrXqIedo43nx1UcSHJC9usaHhGIsMquSuSEheOS4Jq6Dyq+iCrx5Sc/7zJsSL
	 oiF9oVYNlGEQ5X1o8nRTVcOENm6PekOG2F1fqlla+yyVmZz6E/vnKsR5QT37hNCXTg
	 RJn/uEb+rjgEw==
From: SeongJae Park <sj@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	wangzhigang17@huawei.com,
	liqiqi23@huawei.com
Subject: Re: [PATCH] samples/damon/mtier: fail early if address range parameters are invalid
Date: Mon,  8 Jun 2026 07:32:49 -0700
Message-ID: <20260608143250.69024-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260608111534.264-1-yuzenghui@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 99xfed4c4opni5y7b16mgnieudfa3kfz
X-Rspamd-Queue-Id: 23410C0014
X-HE-Tag: 1780929178-902311
X-HE-Meta: U2FsdGVkX1/V7h/FVVrz7SkTOLQqJNMU0QObhwe1kUJmrjHmDvaIjnMtIHwDFHmfzjAwSc5pl8wxJ0G+HpjvsUtCg6Gr3X/U1Hy56OXrtjxHT5c1F7kAK+BJYGikj37rR51cGsD8/x5uOUlPDj1AMiAJfwyWHYP08qiIS1v05w+7C8SADpcFriwIUt6A0kHObBi5+AyLpnrIvAd8JZbIxgW+qtpulfNMwJ7jXO79ciL+cdpEw3/Uy0xmUtuKYCtElfiD2+xEowYJF/gwxnMt0O+Vw36HfJSkBWrbQ3MCqJ8MFQ8uEHQNttkS9Sgbq7Vj0L0KaLNWayZWfcFUVskiUAP+nWG3pn8OQkh7VU07sWPfn7RTAly4T6zWKaTwHIECisJ/vIvBugbSjVPBuNlJhfvGDwthSGYx8R+4SXwuRpWklyBBQDd0yz3AP8VC2KLjSYBLysy0GHmEZVmyjYyNH9GjNTz8wxFT6s/xHSWBTEU/RyqkffQ2R/awTvHCP57dYhF7liwW/34JsxCjPSf330kXlcQ6U8KQ+AGoQY1XqKkceCVQimFj3Ovv5p+2bIYA+sWmhkRsgbhCGjV1M8yUqspvWk+/xmZ4/IMwYwQ40i8SNPt35U2FB6KB0Kry3YNTTrlCSCfaUHNARYA669TOZBhOGd/K/yGZZXXlMPZnOvI7jtFzW3IP2j6D5+kXsQLwLyGpA74ofqc/Ciu8mFzrL6wkDNUlLBWGwEaV08fI0mwKYjlQpJjw2nNoFDkqtAVyYAgv8SJeUbKUvbMJ9rFTsVG196IglzojJA36yCPnuO/uRsQ0toBjEo6cQ7ccaax19mAXtMLrJiU7qHltB+pL0WBF0v772Va6HmS8vBGQ5obmUZaoun7YrXlZQZnZAx2g5FW0Kq1E0mC4j+nV+hrEdm6plm3Zb/olZNu88hjtJo2TdXLmfY+SH5zpNT1rC3Iktdr/lUfcN6PheWt9bjM
 bV3cXF7S
 1r9j4htkLYAyMK8ex2rIo3GsD8Y45MhzFUZPj+9NoRa+8SkFZwj/9DXG5r4gIaZZPVeDp4kEuoYlp3AwsB03T3uCHpirqcgJK0kOhYX4PGyyjxsXoURsS/adWKy7zLk9Jqbty4MbFZ+wE6cWFKGhbQQHZQmbJi3MpWMOwRRPbUADRNFj5norOBV2hPlr9zalr4NsWioCuax3U7mHSYtkdAm1coaubGQgrBS5JcVpXOGiyVzPoTe1ZpPsVzDsE8EFoa5zBKhwASMTOJr1Ze/QhPDuChg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 8 Jun 2026 19:15:34 +0800 Zenghui Yu <yuzenghui@huawei.com> wrote:

> The comment on top of `struct damon_region` clearly says that
> 
>     For any use case, @ar should be non-zero positive size.
> 
> which is now verified in damon_verify_new_region() if the kernel is built
> with DAMON_DEBUG_SANITY.
> 
> The WARN_ONCE() can be triggered if the mtier sample module is enabled
> before node{0,1}_{start,end}_addr have been properly initialized, which is
> obviously not good.
> 
>  ------------[ cut here ]------------
>  start 0 >= end 0
>  WARNING: mm/damon/core.c:116 at damon_new_region+0xf0/0x118, CPU#39: bash/34144
>  Call trace:
>   damon_new_region+0xf0/0x118 (P)
>   damon_sample_mtier_build_ctx+0xd4/0x368
>   damon_sample_mtier_start+0x1c/0x90
>   damon_sample_mtier_enable_store+0x98/0xb0
>   param_attr_store+0xb4/0x128
>   module_attr_store+0x2c/0x50
>   sysfs_kf_write+0x58/0x90
>   kernfs_fop_write_iter+0x16c/0x238
>   vfs_write+0x2c0/0x370
>   ksys_write+0x74/0x118
>   __arm64_sys_write+0x24/0x38
>   invoke_syscall+0xa8/0x118
>   el0_svc_common.constprop.0+0x48/0xf0
>   do_el0_svc+0x24/0x38
>   el0_svc+0x54/0x370
>   el0t_64_sync_handler+0xa0/0xe8
>   el0t_64_sync+0x1ac/0x1b0
>  ---[ end trace 0000000000000000 ]---
> 
> Fix it by checking the validity of parameters right before
> damon_new_region() and fail early if they're invalid.

Good catch, thank you for this patch.

> 
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>  samples/damon/mtier.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
> index 775838a23d93..4a5d3fb12e1b 100644
> --- a/samples/damon/mtier.c
> +++ b/samples/damon/mtier.c
> @@ -118,6 +118,9 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
>  	} else {
>  		addr.start = promote ? node1_start_addr : node0_start_addr;
>  		addr.end = promote ? node1_end_addr : node0_end_addr;
> +
> +		if (addr.start >= addr.end)
> +			goto free_out;
>  	}

Sashiko found [1] same issue can happen if detect_node_addresses is true, and
nodes 0 and 1 are both memoryless.  It shouldn't be a blocker of this patch,
but fixing it together can be very simple by moving this address check to the
out of the above if block, right here.  Zenghui, could you please update this
patch to do that?

Also, seems this patch is based on an old tree.  Could you please use
mm-new [2] as the base of your DAMON patches from next time?

[1] https://lore.kernel.org/20260608112455.274231F00893@smtp.kernel.org
[2] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

