Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BD4DC98315
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 14:18:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 577266B0088; Thu, 24 Sep 2026 10:18:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5002D6B008A; Thu, 24 Sep 2026 10:18:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C9476B008C; Thu, 24 Sep 2026 10:18:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06E7A6B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:18:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 922E7A656C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:18:57 +0000 (UTC)
X-FDA: 85248862314.04.007FB12
Received: from mail-qk2-f35.google.com (mail-qk2-f35.google.com [74.125.230.227])
	by imf04.hostedemail.com (Postfix) with ESMTP id B32D740002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:18:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JdkHFNVD;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.227 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790259535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=54F62XHPr5jXjg3/coQJmTQQL9rWGQ8xIoRYSOjr2Ds=;
	b=cTkQqmesYPd/mUSaSmpb+pWDZLylHS4i5O4eWICRZKjlXTSj2xvfbYZXvum51uRGNMpbyY
	B7zc500sUT09IaN4oEOFQ8Dt73WaNtxbL5oNNY2LEg43xg7gi51q6B5K7AuQEGsEZ5s3Yj
	22FNeuZfT+YYrooe8QLhO36GDrbw7vI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JdkHFNVD;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.227 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790259535;
	b=NryDFxX94m890VNs0ANpDpSaTF8s9/HDuEdDFfs7JlLKsXE/nuy7EPGKugh7KRtrAk6d2i
	WMrjaiS7tKIdmvU/H/+Pt6PXDho5wR3uLURcH1VmZ+TXbXwnx9B47X4LlQguvD8LQu5aVY
	fSMnBpbPKYXJI1x1TwX+5k6AvSBv60U=
Received: by mail-qk2-f35.google.com with SMTP id af79cd13be357-93910cadeb3so161933685a.0
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790259535; x=1790864335; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=54F62XHPr5jXjg3/coQJmTQQL9rWGQ8xIoRYSOjr2Ds=;
        b=JdkHFNVDDythBIq7aMbk7d4MXn8sxz8VpUc1gPj94ckjBGFz//R9ZL0RB3ZzQCqszN
         9j5UgKoNvI72hCVGtg9diuTricyOu63gOcVF8T3yUGJZ8EE7ua56lWEnoU5123ZQjSG7
         BxdMAiDNuSSfBvBJKdEvLNMhwLgMBGVu3LngX+VcU1d8ALtMWjb8Lj+0hmDa8eFpeTqQ
         dpjdy2eC2gkIaB6wudNUNsu0yMCbPSU4xIhVAJfSmhv0RbQylbHoE+4XbNaM847tI+YR
         JDmWN/eib2CsufvLE1PSPgXVLejW4+mdIdq8w7BKi3jA2bJ+9KDOBFxM+fqof1lROhs/
         1Cbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790259535; x=1790864335;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=54F62XHPr5jXjg3/coQJmTQQL9rWGQ8xIoRYSOjr2Ds=;
        b=rSEJTG+Q++ir6Bm0vzGVvvec7FqCPgK91Esm5XLGBNN+zX5r0bl9BZoCh/2kncTe8D
         mLVm92p0zLfrwu0EdehG+rLQRmGrsmsKBnuQM3ga1OrzZPbPJjhKQSOIPlZ4GaZTj1rA
         c/VBOQeZDncmWn2Vw+kTypKjSOvZQMKdjsOQghcj9AdFJWl8WpjRlKCHOQHDPChMHUYA
         xXkEm9wYl1fzMTP9+YXEY2WWcZaxeIyV0mWhPLenexh8MsJ0BSn3OnT/wLFxi2bmJgNu
         T0m1l5G0uRJf9pEk6gZQFKzKaUXyo7Z1o1rFlcbkfCS1Z1FDpoDggHyF3EBXet36SBhA
         Vd7A==
X-Forwarded-Encrypted: i=1; AKwUvBzh4wfVxbWvmvYME0MSKxo+ymHnFhyshw5Em4g2QulxtBfAQ/T4zB7WkO3VI7W3+QNfVeNrG6GuVQ==@kvack.org
X-Gm-Message-State: AFuF++mdOYPZn6z4agrNllMhyBr2A0KzQsLB3JewMqb3PYVER/erjCXJ
	6honhe4BFiHyKgOdUhS5ZmX+7WiajBu4ZVCote9lPqH4/aqQYAfzvw55m+8nrFntLXY=
X-Gm-Gg: AYBFou2fsKWUjnCxvV1yyt7b7OLmXX3lv5n1YggB+gxU0ThWSiTIsBmGDcAewkJ28Fr
	z4AbTzzazTZCaZxgOl/OEO5cIIA3tZ3tFAsnBdpQKPgulz2v1bENeFDGTUkt+itjT75iK4+pxsT
	4aQ+0Q92Y1DA/m2/mmcxg19NwBH36ptEXtWp9PxbHN7Yce/zE/UabhOy3kImjqnn+sjpqdM+5mR
	egt0YC6cX8iuzNpYgL5zvVefvsm40P/BskBwR1WKjKE1y2sSpliLRFVgpfTLKZsg+8XtH8NS0Fy
	blApXsaDo82478n/nCB1Kd4JhfYQCFD+avXqFRWPGhdaZOkbWpvsm+dXYd/PUbwHwuiyF/DMr63
	FFWQmz0ldZMpFTjy4rwKrc7gsqtT1oG443iKpUHn4NEiVaI6QPfPQhgCR/+Le79wkwr+CcZ8dxC
	OOQZBymTTncg32Kbo50AkyHrlhRDwnJMq27LbYyiVJUgajT5cANeBz+wfSzBohfJeSBxb3V/GP0
	X3U6ARluHd4+5j4vHP6mk1GpJulEPL7KX7sHjf3zLUmTO2oWiVyL+s=
X-Received: by 2002:a05:620a:3185:b0:939:ed29:8ad with SMTP id af79cd13be357-93c3625bda0mr311149485a.3.1790259534711;
        Thu, 24 Sep 2026 07:18:54 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c2c22f729sm342356985a.13.2026.09.24.07.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 07:18:54 -0700 (PDT)
Date: Thu, 24 Sep 2026 10:18:52 -0400
From: Gregory Price <gourry@gourry.net>
To: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arUu5gwgqmU6xeUD@gourry-fedora-PF4VCD3F>
References: <aqLi6cIjD2wJwk0B@cmpxchg.org>
 <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
 <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <CAMgjq7CJBHkoZmg9oKNgGA8czL0djyBTCAkPz8ETm-tX=Qci4g@mail.gmail.com>
 <arEotFqE7ZZoxMHd@gourry-fedora-PF4VCD3F>
 <CACePvbXb1WLz=OAAzVawf3oc3+dE3Z7qfPdagQ2dYuf3OALc2g@mail.gmail.com>
 <arFe215hUcjLhvmS@gourry-fedora-PF4VCD3F>
 <arOeYHEf9aO7AU5X@MiWiFi-R3L-srv>
 <CACePvbXHan6Sfmdq6JFrcaMMy6SGvzPs-pautLtg-9D6=W09qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACePvbXHan6Sfmdq6JFrcaMMy6SGvzPs-pautLtg-9D6=W09qg@mail.gmail.com>
X-Stat-Signature: oixfiq1ccgqbpd3dzcfbfs56onbybqt4
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B32D740002
X-HE-Tag: 1790259535-639225
X-HE-Meta: U2FsdGVkX18mAOchbCl9dt4LgXTig9XfP/0pTMnYq5j51FKpEh2otJXKKWKEanf/inFMiviD0ik1JnjX7aVcibN9CKmMaOxbrRNeQD+sHU3ouVhfXoq4gkbwj4wMN/ZaGphKh8TJVfGFqIaSxwjGibwuFAn4o/cHnTzcPf6WnBELae+AF4zphCFj2m0x9tWDkE9GgJY+uOuqVaac58kUD9QgpbgtomZht/pewn49Y8vwCyYRzKkz/WWuRzmiAs2no5OD8T9BYOtXDbvtMAUMgvNGVfj32bbjwOsH2A8MimyXJbb8gnBSGwOgBLk4xMLkAH2Njhapjut0c4/UHTZsNASDdFrfIchf5iQgd1e9mMIGpel66Bj6sn9GyveBMrV/9I0hJp4FcLy5YIsvoeCW25RWJQnX7CPczzykPMS5NgZoR6GSGI+yvbAYHQGfrFtNRt98MFtoQ8NbKPu4mvhL5/ElopM3hpqmlX4HKozZuK9P+L15tLbkzFB3fthMumuDZAMkjgYjpqkYfmLSbVNeoqn4KJBrRGdqD0AZ5Utjx2v4ZnHlFv+TxLgaBsJx2WsSlA5yP7zN46zHztYsspGqiKJhjSONkZQVcKM0gdUyQI82LsQseB+0m7/zNENM2cU0TNnmKzM/oOv7cWiflDjIlC55FFV+c5xTya6qvVDcPAOK4wS9gY1y3UkhgMLeVsatwHF5ujKSZf7T0MUNePDhorLoYTlEUkpkzYSfgwkb+y7e0e3gdShq3wGKQ1y7zdnfHK01HxXppCUQDGyfEi38y7I8K8SUwQUauvD3OWaywx1b9IWzJ2nTnqiOTinaZVRBghSLMBgPsjN7jzjBUoE/bdOUFIZPBh2nxZhzIdIcrUsNauLwRiEuio4EevWjaM5tzrzeY19niiw9WcOTn1eDcBlEpACng8VSFfW1ry8OKXTXcRu2qMb2XDwk3SusbCGuglMuY9R8zfsKq43dTqF
 mFIMDyU2
 OOCzGVmoITNr6LEqM78Fjaa3cIau25p7E2S9aCtECfHLXsVWsqIxiEF/iOuLMmngS1o9Ja/x2/60XtxJasyuKSbTwWdHH/jC5J/f0Vc2j6lwgsq2L7S4m2G8jBSGa6mTUu7Np5nKcadFZ1hlIstkqOjMw2PD9yxPzjDJWgZvTjJLKAdETu+jT/phrxNJJav0P4h9MWcYXMSu3+FDK356DecktcMnY07nzZRZg/abzbPKJWQEAnsrr+3MPxIhQ1ksKi9mEgFu9XK+eDPd/icdVVAfb/k/CNtsmwrVwzL53+bjZSmaOQcQjWbVykOcgD6IQB1HX6fX2uUJ9p76Rhkq7Kj6rLcyG2gblZI/nR+vGazDcPbQ+zc53K6MxS2hs/v2ECEzV4sRSBMYltM9HYSkNc3XYeyBUSJTKuYgA0mos+fjIsmh1PJeXVe9Ux47XJWTR7/1A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 01:02:54AM -1000, Chris Li wrote:
> >
> > It's hard to say. When 37e84351198b ("mm: memcontrol: charge swap to
> > cgroup2") introduced memory.swap.*, it was clearly defined as charging
> > "the actual number of swap entries used by a cgroup". Please see the
> > commit log. With that, zswap still reserved a swap slot even when the
> > data never reached disk. And not to mention zram, it's backend is RAM,
> > but not physical disk.
> 
> Right, that definition matches what I have in mind. The actual number
> of swap entries regardless of the backing type.
> 
> Changing the meaning of that breaks existing users.
> 

Except that you are the one proposing the change in definition.

You conveniently skipped the message where I laid out, in detail,
why this interpretation is not grounded in either the documentation
or in the introduction of the counter.

You do not redefine contracts because "that's what you have in mind".

> > Now some deployments do use memory.swap.* as an SLO signal, and that is
> > real use cases as Chris and Kairui told. So I don't think this is about
> > who is right and who is wrong.
> >
> > To keep the existing deployment working and at the same time give the
> > physical slot its own knob, I think the solution is to add a memory.pswap.*
> > counter as you suggested. And that is not something we think of from a
> > brain storm, it comes from real deployments which already depend on the
> > current memory.swap.* behavior.
> 
> I think it is important not to break the existing usage of
> memory.swap.* behavior. I am fine with adding another counter.
> 

Then you should stop distracting everyone and propose your solution and
make the argument for redefining the counter to mean "what you have in
mind" and justify the addition of the new interface.

I think there is merit in the argument - both Johannes and Rik have
some concerns whether it makes sense.  There's something to discuss.

But the core issue here is that your use case is counter to documented
purpose of the counter, and just because you can derive meaning in
combination with another counter does not mean that is contractually
guaranteed by the ABI.

If you want to make the argument that it is, in fact, contractually
guaranteed by the ABI - then this is a different discussion, and the
introduction of memory.pswap would be tangential to vswap (though it
would enable vswap=on to be the default without breaking anyone).

Seek a way forward, not a way to stonewall.

~Gregory


