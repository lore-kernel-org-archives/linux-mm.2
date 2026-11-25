Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69AE4606A32E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 12:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=U7ugaIV+
Received: by kanga.kvack.org (Postfix)
	id 564566B09E8; Wed, 25 Nov 2026 07:27:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53AC66B09E9; Wed, 25 Nov 2026 07:27:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4789E6B09EA; Wed, 25 Nov 2026 07:27:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2174C6B09E8
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:27:38 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 89C68C0EBE
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:27:37 +0000 (UTC)
X-FDA: 85473567354.03.7B1D015
Received: from mta0.migadu.com (out-147.mta0.migadu.com [91.218.175.147])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4D28F4000C
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:27:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U7ugaIV+;
	spf=pass (imf04.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.147 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795609655;
	b=oMrA11DaA+7Q6FKvqMyQG8sxF7lBU9JbQ10VakbPauTFuAn3F3U5rESvtsUwexVGiGiyjF
	U1Ai+CqZE/K66cVygK+y/iDwt7RrrcuGYGnctCTGM4eJSxX9LeDT1VVXL2PdejYNMGGe/f
	HqxdxzNM4O8Rsan/fUJPvJFGOih6p80=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795609655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OTCd5NkrqHvXsUhIx0bTbw94JLFTal3qGzbAQE4IqP0=;
	b=XsJRW3RVh5IL5AljJIv05CXTYOiS/3G4IAgNPiggvodHbcGc+0qBeo5tV2MUsw4HZUhk2E
	XeoCQa9KZODGFWHIOCB4sbyDcdFlIQp/OqEcjN73EZxUdEcHwv7N3LpZspN5nKK9HEChVt
	bng1YuO/+XtNgf/AzWua3a+jVa73YCQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U7ugaIV+;
	spf=pass (imf04.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.147 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=P0nTBQTPzorVy5GRLFfEaZDrD2qvxynS7PM+7Y2LdM0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795609653; v=1; x=1796214453;
 b=U7ugaIV+IhgfMXlU7luNKqTxtQ4mtXeK0w87YNBWYWhuVUk7sZ5JL21K0eE+hBfG7/VcejQL
 3xQianR3ki2vYytB59kzmUn24vdQ1MC/lwU5C1G5K/Li2HvANg+E1IxrJNqlYV/IfGFA617lz+6
 wSCsyg9WImC5KvQVGx8xbEQM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 92f14202dec0adab;
	Wed, 25 Nov 2026 12:27:33 +0000
X-Mizu-Trace-ID: 92f14202dec0adab
X-Migadu-Flow: FLOW_OUT
Message-ID: <4dd527b4-d384-4c74-adc0-82035f6a37dd@linux.dev>
Date: Wed, 25 Nov 2026 20:27:18 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 10/16] mm/mglru: Run aging when pages are rare outside
 the youngest gen
To: Andrew Morton <akpm@linux-foundation.org>,
 "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: ryncsn@gmail.com, axelrasmussen@google.com,
 baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org,
 hui.zhu@linux.dev, kunwu.chan@gmail.com, liam@infradead.org,
 lianux.mm@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org,
 mhocko@suse.com, qi.zheng@linux.dev, rppt@kernel.org,
 shakeel.butt@linux.dev, sidchintamaneni@gmail.com, surenb@google.com,
 wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com,
 zhangbo56@xiaomi.com, zhuhui@kylinos.cn
References: <CAMgjq7C_cH75JrYs8=P5LbxnDjDD6bqeqsCidOPa=r8Z+42sCQ@mail.gmail.com>
 <20261116042556.42111-1-baohua@kernel.org>
 <20261115205046.8473acf5a93d69d460598559@linux-foundation.org>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261115205046.8473acf5a93d69d460598559@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4D28F4000C
X-Stat-Signature: iofrd8h8rcy5yyorgx34yscams1y95uq
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795609655-472928
X-HE-Meta: U2FsdGVkX19ZbuHccJQ9o8MRHrEa0xrndjKmqjyXZ8jFSX3iKCu2nycSaM5Wy4/Vq/jZNolEOZEzDIiTkaQnVV93Ksi+5WZNknhPTFlP+Uf1nyuu1xS/qoAilfdqFVRjhYEqJW5My/LQR3Ls2l6wMguQyIO0n60c4ee1UgeF2YQsc+sS16u4b+ArlbBTAUxIJEHt9We7rbRs++cDZGY6rFAhdQPpw5R+fGvxQt7gfbzi/mGT3vSycWZB3N6C/ULEGq21u+Kr94dKa9nRPOPQHMu8FEGXloHLqNdCyhxvTgeLXSg7uy4Vcf6TYI32bnGzRLctGWTHuGE7oZRrbYxDs/EuG9YAbP9zOHZFAQB4+V+cyk5vWS/mQUzpH2pM59vsPDLdmNfPTjK34OeZ5ItyC/dTkj3oNU5mC5G2Wjgldagp5JWoR5bFMlz9kcqEoSIFUJUpeMblsbRlVPDVhxSobb/oi4sPFlRdPuRoZtCODElVmRioo5Y8h4fT8ONENThxhgvBog/K4h6UPDTN7Zn4fLARlfwcTEo6z61CTKGYwAMEE4bWxCL8njRYnKu+VRYCCizW3/Wx+ClC6QsmP9JodhWCbWrnfQqYXSD0lu81ghVKQanpya38dX36fAJJPhqiTrp5rYnXB/czWVjCAtGs7C1vYDAIe3mGb8AYvhrNLbBei0CqtzTIHKa/tKUQbMZh5fj62pSX69+4mBF92Sry5W4Ae7A5+7OBmuqd2WvQUb45z98ako5sSB2ugz4SAntY590v3C5US6vaLh5YzMK7vu/mU3pIS70/Bm6vdtnGeaIrWGfuf5KlOmmgCqs1OeNMypl3/K7e6gn49y37nJUyoIu5u1Fe3tlnUZ/u/bbwoN0Tsj+I8xvfX5F5Y5s3d8N5JvQEY7HmWux7URAi7hG8p7jw52lPuxMKS3tg2uIcHxNhWpkmav7b6UFFuhEg5xR3FR9OlmxuOTcH+FsNYG5
 UL9SAlmk
 6GN1YGoOVIP/DBt+pUhhmHGYUttfftBCE8Cjj4+uRbITI0fEiE8AhyG/y9CwXpqDBCI6pU6fE4y+bfUYW7VGqCfs3U+u7qjqDD6qu+dGS89SK7sGBgvYIP0YrSvHYBZytIbITNyC1YQ2DLw1678+INRqKgKm71tlo/6NLu7ta6s9A0P2YropjvOOq1scEhvIbQLpA1cCD4Mmyfrf3A5hs8UbW08SFYXAFZ2h+Hi9kzWup/9fuwcmz8BVCq8tbB2FSOoQF1Kda7EhZDhQGDKl5F9S9LMxLArdN22uWkke9rVMjpkuf5o/phdh4dfJ5SZv3aZIk0GBC8oC/nx+JaBskZOTqsTUwYm81ckG+9CJJd+9Bo/h9wAEGQ2DdHQvPlflnlhJQRvTzim8wcfzWMOZkg0hO+V5Cqe5dx1rpPn3nNNqULUhkJ5vZfiakVJ7D78ArFsIEVQAPa42S6744aN0HNdv/mcB/3E5FAtcIPfFChESxW4hwjN8VR1KmzpuYGBauLrim/PEwwRQbMx/r7WIzB0ZK7U8sMawW2dyp5TK3PT+RiS/qYHdcT8GLQXhYn+acLgo6p8e14XnkctV2CC2xdIPfsZ5Za91/wUna0WjfCfowgC39xw80zFvQxnClAz6UezY7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/16/2026 12:50 PM, Andrew Morton wrote:
> On Mon, 16 Nov 2026 12:25:56 +0800 "Barry Song (Xiaomi)" <baohua@kernel.org> wrote:
> 
>> On Sun, Nov 15, 2026 at 11:55 PM Kairui Song <ryncsn@gmail.com> wrote:
>> [...]
>>>
>>> A little nit: with the rounding above, I think we don't need youngest
>>> / old as an array, just an accumulative value seems enough now? But
>>> feel free to ignore this so we can avoid more update noise in this
>>> series.
>>
>> Makes sense to me!
>>
>> I guess Andrew could help squash the cleanup below into the patch?
> 
> yep.
> 
>> As suggested by Kairui[1], we don't need youngest and old as
>> array. just an accumulative value should be enough.
>>
>> No functional change.
> 
> It got a bit messy because the later "mm/mglru: restrict eviction
> accounting to eligible zones" alters this code also, but I think I
> figured it out.  And I might have accidentally fixed an 80-col thing
> while in there ;)
> 
> Here's the end-of-series result - please check.  It compiles!
> 
> 
> static bool lru_gen_imbalanced(struct lruvec *lruvec, struct scan_control *sc,
> 		int swappiness)
> {
> 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
> 	unsigned long youngest = 0, old = 0;
> 	DEFINE_MAX_SEQ(lruvec);
> 	DEFINE_MIN_SEQ(lruvec);
> 	int type;
> 
> 	if (sc->priority > AGING_PRIORITY)
> 		return false;
> 
> 	/*
> 	 * Round up or down corner swappiness, to balance the heavy biased
> 	 * type better
> 	 */
> 	if (swappiness == MIN_SWAPPINESS + 1)
> 		swappiness = MIN_SWAPPINESS;
> 	else if (swappiness == MAX_SWAPPINESS)
> 		swappiness = MAX_SWAPPINESS + 1;
> 
> 	for_each_evictable_type(type, swappiness) {
> 		unsigned long seq;
> 
> 		youngest += lruvec_gen_size(lrugen, type, max_seq,
> 					    sc->reclaim_idx + 1);
> 		for (seq = min_seq[type]; seq < max_seq; seq++)
> 			old += lruvec_gen_size(lrugen, type, seq,
> 					       sc->reclaim_idx + 1);
> 	}
> 
> 	/* the vast majority of pages sit in the youngest gen */
> 	return youngest > old * MAX_NR_GENS;
> }

With that,

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong


