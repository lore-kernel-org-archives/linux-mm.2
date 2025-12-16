Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF92CD5B87E
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 01:23:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D8C86B0088; Mon, 15 Dec 2025 20:23:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0865B6B0089; Mon, 15 Dec 2025 20:23:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC70B6B008A; Mon, 15 Dec 2025 20:23:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D9DF56B0088
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:23:23 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8A3BF58935
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:23:23 +0000 (UTC)
X-FDA: 84223586286.20.E3836AD
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2EFDFC000C
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:23:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765848201; a=rsa-sha256;
	cv=none;
	b=Swz+coDoW5fdWjrMzWQ1bR5r3QJYVDDRgh8qC0+OnFsqePQVfi4IpPHWArrhfkA1gzONaM
	glnaJTyp8IARqlodk0dro8hjo+faZd2ywv5b97n7QtwlBViBrx3JeNiv2NPg6GDpWKiM5M
	Bfu9b8Or1hwOnapzrD1LPTmgTSrgCc4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765848201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TF3w5gFxZa4Iq6hXG8Se4p/eL6arJKPotHIvE1Ck0HA=;
	b=rhcqE6KJK/XFISSxBxxBe00ZKYk9FPpq+agvYPimRLE2DfSZFzVd4xmzv5JequSFmpQHnv
	lCmtMB5Zqg0sE0v9F1c1AEUJq+QoidoNJVTjUCI60x4q2ysSD+MDoEqAXK7l0e2OyLjdEJ
	qpiUuvb0ZaJb+1s1OSGvwY2mBVajkEU=
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dVfLh2h7bzYQtjX
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 09:22:52 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id BFD1F1A1362
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 09:23:16 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgAniPiEtEBpyU9cAQ--.32796S2;
	Tue, 16 Dec 2025 09:23:16 +0800 (CST)
Message-ID: <aa796873-2b64-4211-b1b6-71f8aaba8441@huaweicloud.com>
Date: Tue, 16 Dec 2025 09:23:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next 4/5] mm/mglru: combine shrink_many into
 shrink_node_memcgs
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, corbet@lwn.net, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, zhengqi.arch@bytedance.com,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, lujialin4@huawei.com, zhongjinji@honor.com
References: <20251209012557.1949239-1-chenridong@huaweicloud.com>
 <20251209012557.1949239-5-chenridong@huaweicloud.com>
 <20251215211754.GG905277@cmpxchg.org>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20251215211754.GG905277@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgAniPiEtEBpyU9cAQ--.32796S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZF1DArW8uw43CFy7tw17Awb_yoWfGrbE93
	Wvv3W2kw1UKw4DKa17CrsYyFZ3GF18CF1DGw1UXrs7Kas8ZFW7Zr4kGryfXrn2grW2kFsx
	uFy5XrySkry3ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbxxYFVCjjxCrM7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUxo
	7KDUUUU
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Queue-Id: 2EFDFC000C
X-Rspamd-Server: rspam03
X-Stat-Signature: 5w631abui6ub88pqdqr3ii1ska6z6g6g
X-Rspam-User: 
X-HE-Tag: 1765848199-218705
X-HE-Meta: U2FsdGVkX1/HgHbPgWHkYOGfXOCfKLivWYouMuxACcAdPT9QT3kzTAC2vGorpHYsBpzFfPjr4Qbl2IaiaP+RBKYDRKe8VYHkQipdOumQi3I/Vpau7lw78UkhDWYQMQHM8c6nMrANQJSSHsdy7/Nrfay69pFcd4z2D+ILObxw/MRp3n03kRVn1OqKqqAA9ZOnHxj9LKWHqpnrllgBmALt4bvv2GlsSs1dFdnFZWquxX5piRZvywar5iztjpUWpBV93uuKpxGpualUlaHLX5qncwCgI7L2JjUMC8M/ZIu+TzeX+i1RQd8MM8b9SW+ByqYSllwLwXiJ/AHe9J1e+bKgLDJOHO1PvAyqgcVrcZP8QMAQ0CmG0/Bxepi86mg0FxwK61uh5HEwV0cW5a5I6U6NT9s3W/UQRdaANchwk57mMRxmPhsdAca+m524j3WWw1H0kt5nRY8eN2ITTa/V6vjAo89Bm26rUp5xcfaYBR6eOf4U1zA+6kgpYHr/X0/FmTE2y+d3KDbSRAM7XaXg8gl9/JiGt2hI1vl2BFgRyP+yq78vdkvUcLhTb44UjyERIwA0uqwFaXWQsQLWyFgEMNqaiCWJp2gB0Q/TKZnvpfiU3i5W/xSJNCmAAC8ws+8StxmLljp8q0uxMOhQCAQJpD+/KtfAn+e6ixRi8eHM7bJ0qB7rEbN+cOBaDsP1biL99fyeHA57L4+mPyELmYy3eIC/i4oNg7Lz3kPG7mtm3eMIV7n/xM6pdIMF7kclh2QPXKSRxG6uWdS6YGo2lpwEsMjdw9MJPZHuU1Jq0ss6z+mL++bnuxt9/Nk/KbkElKklKfEXbd2H8qNILnNzt//A7gBQZFfuorWVlgLOtLmEX2AglWD9RvE7APyex/XFZlo/tciScktqTk4Zge4wWHtNCEI9WNbEfhqxCcXMfA9AThFFVlGaHklcqI3UyVE7QwHpgg+YLo2nEgfnMerJWJ7oTcE
 x51721Ek
 /vzxe6DPJXbVHRGvFBr6ASDNn5dbQ06TvLlceiAJfPedC9VuhAlM5iHRq0P+4Eb1wNlzaaHwvyIgy+QhuYXHKtLDcJ3zP9DinkPxrRX8TyiwacgGy/+HVFxgAhdwOCn4U30jdUMemLq6m8xmF237ecSO9hu9AFlECX5KQpYVl5iy+sXw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/16 5:17, Johannes Weiner wrote:
> On Tue, Dec 09, 2025 at 01:25:56AM +0000, Chen Ridong wrote:
>> @@ -5822,6 +5779,12 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
>>  
>>  		shrink_one(lruvec, sc);
>>  
>> +		if (should_abort_scan(lruvec, sc)) {
> 
> Can you please rename this and add the jump label check?
> 
> 		if (lru_gen_enabled() && lru_gen_should_abort_scan())
> 
> The majority of the checks in there already happen inside
> shrink_node_memcgs() itself. Factoring those out is probably better in
> another patch, but no need to burden classic LRU in the meantime.

Thank you very much.

Thank you for the suggestion. lru_gen_should_abort_scan() is indeed a better name, and including the
lru_gen_enabled() check in the condition is necessary.

I'll update the patch accordingly.

-- 
Best regards,
Ridong


