Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D77B0606A338
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 11:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=etQ7lRRk
Received: by kanga.kvack.org (Postfix)
	id CEA426B05B1; Sat, 21 Nov 2026 06:10:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9ACD6B05B2; Sat, 21 Nov 2026 06:10:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB3236B05B3; Sat, 21 Nov 2026 06:10:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B3BD6B05B1
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 06:10:48 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9B5C01203DF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 11:10:46 +0000 (UTC)
X-FDA: 85458858492.15.506DA97
Received: from mta0.migadu.com (out-62.mta0.migadu.com [91.218.175.62])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7503F40007
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 11:10:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=etQ7lRRk;
	spf=pass (imf11.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.62 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795259445;
	b=5vsv9JRAlD1JTXLDCAr9OpPRKbcqyp/PyM681nr1Z2RgqgtLfMFqcfLqyRBOObS2ndZ8hK
	UFeFHbGX4C9JoCGtThBF2o25EDkUN4WLluxGmfOnqDyYEEXvxYnFIyqM/k9ZkxLv+i9qBg
	tu3rJnA9tKLnLQYy+9I2gfu9KMsEmr0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795259445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YbGsFuHzMPCucKqbbbZkf1QYXb3rREx6Caxd6NEAakw=;
	b=WL9SCnEOfUuijLgObreZFTY1gBTonUMco3QGW2wi9pUUeOfLHjyJoleVsz96CV3TYxEv80
	Ux+dzcbrQivzuFW3Vo9DDOuGoEUDpSpgSQ+tlT4SQtL8IWOYHMPiIGaqcqInyKzcP71zwo
	fozYnv3F+y10H3zKXx1/Q55DA5yk4mo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=etQ7lRRk;
	spf=pass (imf11.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.62 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lHOuyTOIwmr32upG1vX/kfSW8Fr2iMJ6LuKhLpVCBY8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795259442; v=1; x=1795864242;
 b=etQ7lRRko/Jc7US8ntLfYO2CcqEimKnOy6hVXJS+PrFpThGqxPJ1Z7WcFYZPHFKTUJ3NHoip
 rlonQT1urAaYJYDT86CdCbh961FRNskzQldANqp5tMtVanwkDlXh2MRGi2drvpljvl+kk9ffeUy
 N9q/q3OSTIkuue/kxU3OqKKg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9deb2bf611a5095e;
	Sat, 21 Nov 2026 11:10:42 +0000
X-Mizu-Trace-ID: 9deb2bf611a5095e
X-Migadu-Flow: FLOW_OUT
Message-ID: <57ef6b0f-e9eb-4484-b07f-63c848ffde4e@linux.dev>
Date: Sat, 21 Nov 2026 19:10:37 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: shrinker: stop counting when the seq buffer overflows
To: Xuewen Wang <wangxuewen_ky@163.com>, akpm@linux-foundation.org,
 david@fromorbit.com, roman.gushchin@linux.dev, muchun.song@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Xuewen Wang <wangxuewen@kylinos.cn>
References: <20261120110538.3256962-1-wangxuewen_ky@163.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261120110538.3256962-1-wangxuewen_ky@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 7503F40007
X-Stat-Signature: t7a8tmstg9hsnr6gsmkzmrr5bzx81z4j
X-Rspam-User:
X-HE-Tag: 1795259444-16926
X-HE-Meta: U2FsdGVkX1+1V+Oy/aMZ1vM1zu3N5hsMkeU19CR44Ql4Dgk5AvYYovcYxCKlyS3qcSK72uLQJsHltKQHIF9WnNskIViq6SpoCuI/o57EX/Gee+O//mLVhxDDlXUjomUKdu2ha7PbwNivhvYbcoFRrAEa00qwlaXPhTuJU6CLAHWs0xWmp+CFDGUxHzoGqePi8YhyY1qo4ZIphYHxe+qndpWREFINfJCNv2MRkE0d1V2XoRiMo0xe5Ha6py7qhBVgsBeFlAp9dMFdezsMKVR9NO2l25stJntVqVEkS6q2FM3W5WfT9lvWWAK4PtOp9/amQdNMuq1uykUubp9NK0THe535RMe5kJ3jeUYbB+NqUa04PGfvHj6o4mgiESd5VELClvr52JAMiWKplK9dMZi/ESUYDBDyrJvo0HyixvJGaHYidxrpNGxwwojoRwekUouGRb8zloVzw6MFfimMFZg/YhcLErhS0x/drmxxcUkXJsIyknQSARu827Yg/6hpvhJ8Z/Oe+V8KN80ObzDkp/krnc/EVr3uh4JvCNQoXLmh7t3vGETQxMUjrIxDK+e35tt8J1jckqPIotzp+h19XbgsfMcVkj+LoWj+EHfrM0UeqWQOZKQHWFN1ABeq1BJWzcd1tFZcOvGhywlDScMUXlZDL7JDlRfOWkminOn1HgLIZg/walBt5nC6GniA89cO3EcIuVn6ImlFqjMzi0EBmoVy69jKVN8Utso2ar/YzCDHG1oS7JT4dJhOsfiTLcU6MoVjJ1Mwy1hWBFkDpnTwQnf1ZuEhcW1zD/WY7g8cD6mSaQtK/mqG6r3cm+lnUOuWCzc6E2iAuokfXg3NeE4QbZrox7NC8/9ykIr07evUWdW25hBCZTL9dNHXJtYRQQTawRQo1pQhvf674Y6P8yXXR55VoMJIrhHL+OpXGWxFM4J/qnqmDTwPIl4PrdMzei5VZvE+gP0EqABJ1ezjGSZknVJ
 cdrQhsP+
 3GrgLrYl3IHFmJDF1sY2QP4l8gHf0m7ZI7ZBchytdPsNHmX/82pOrEjuAwoBNND4lcXq2F1rDUGmu4jvQwcrqXrNVy+xsFm6trs33SP+AWujjhPpDUL9HRPTIZ0oCk1djI1psb/ylTvotookQPh2GE76MjriKA1IA4U28kasp1u6LvPIl+Dc/djdKeJiQN8Y+AmW40ReIIIPdOEA/CuazXtiI4T9ftd3Yo2X44uFanvQNFicWqfBuoZTs+AuMTb/WbyIFY7I3JnEOknADwZeWUOz5tZr7FGW0RpmcCVmrx7akJjJNiRDVSIn7FzigcFbvKFEqbwm/OGeMJ92YWCuMmA3KJ2qLeqCTCl4qEbg7BYPzRGloos3BlopOY5gESH8ok1pOgV/YsGYPZnw/szpiG4RjBJLY+VWvwr082Aa2T/7k0R2dqxrX/FAa77/5S98H3dVDcqSstk8gFAIbphl1ia9H4DCxi4gW/tTzgbzBfBhWOmE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/20/26 7:05 PM, Xuewen Wang wrote:
> From: Xuewen Wang <wangxuewen@kylinos.cn>
> 
> The shrinker debugfs count file uses single_open(), so all memcg rows
> belong to one seq_file record. When the buffer overflows, seq_file grows
> it and retries the entire record. Queries for subsequent memcgs in
> an overflowing pass cannot contribute to the final output.
> 
> Stop the traversal once seq_has_overflowed() is true, using the existing
> mem_cgroup_iter_break() path to release the current memcg reference.
> Leave the overflow state intact and return zero so seq_file can retry.
> 
> Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
> ---
> In a single-node KVM guest with 1024 cgroups each caching 16 ordinary
> files on ext4, the 8865-byte output required three show attempts. Count
> callbacks fell from 3075 to 2472 (19.6%). With probes disabled, six fresh
> guests per variant each performed 101 full reads. The median of guest
> medians fell from 128.2 us to 112.2 us (12.4%, about 16 us per read).
> Small and sparse outputs had unchanged callback counts. Complete output,
> small reads and seek-to-zero rereads matched; concurrent memcg deletion
> and signal interruption checks also passed.
> 
> The successful pass still traverses the full list. Early exit skips
> count queries for subsequent memcgs in overflowing passes.
> 
> When overflow coincides with a pending signal, the original code can
> return -EINTR in the current pass. With early exit, seq_file attempts to
> grow the buffer first. The retry can return -EINTR, or buffer allocation
> can fail first with -ENOMEM.

Would something like the following work instead?

  		if (!memcg_aware) {
  			mem_cgroup_iter_break(NULL, memcg);
  			break;
  		}

  		if (signal_pending(current)) {
  			mem_cgroup_iter_break(NULL, memcg);
  			ret = -EINTR;
  			break;
  		}

+		if (seq_has_overflowed(m)) {
+			mem_cgroup_iter_break(NULL, memcg);
+			break;
+		}
  	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);

Thanks,
Qi

> 
>   mm/shrinker_debug.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/shrinker_debug.c b/mm/shrinker_debug.c
> index cafb566301326..3022d103b0b1e 100644
> --- a/mm/shrinker_debug.c
> +++ b/mm/shrinker_debug.c
> @@ -74,7 +74,7 @@ static int shrinker_debugfs_count_show(struct seq_file *m, void *v)
>   			seq_putc(m, '\n');
>   		}
>   
> -		if (!memcg_aware) {
> +		if (!memcg_aware || seq_has_overflowed(m)) {
>   			mem_cgroup_iter_break(NULL, memcg);
>   			break;
>   		}


