Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92FDCC624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 19:35:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E53AA6B008C; Sat,  5 Sep 2026 15:35:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E057E6B0095; Sat,  5 Sep 2026 15:35:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1AAC6B0096; Sat,  5 Sep 2026 15:35:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9A7146B008C
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 15:35:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6687AA036A
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 19:35:53 +0000 (UTC)
X-FDA: 85180713786.09.939C65B
Received: from outbound.st.icloud.com (st-2005c-snip4-2.eps.apple.com [57.103.79.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7CD65100006
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 19:35:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b="xYlP7d/H";
	spf=pass (imf05.hostedemail.com: domain of bfguo@icloud.com designates 57.103.79.45 as permitted sender) smtp.mailfrom=bfguo@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788636951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5cezDtxlrHR9EE90cG0MGu9l/gtilxYv/wFRi03p5CY=;
	b=iLTRNLEXLtMbKTwfv8kgo4HvXv05BgtSkmNSaNs9IfpBkc2lpyBR78/rMKwq+Q4xvz+skm
	2SZIFL9hIMEVXJpCStGuHAJ28xjzBSqXqubQOHTVBC9J5Lno8K+NatyCw0Ijgs3FsuohO+
	czmwTTEKBQ1+KEIVaPfLtXcji2zhh78=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788636951;
	b=8Ny4feE3u8cPy9HiP0ZU+5JcHHnLmlzsvlJwYQX/8X+6uWvwqW3WArbGrlyMBZvdnqExu0
	uysTybAdOs69463qPuW4YXS656XpVaWhYGx64XdEaFbmnD+jE1voH5nte8mNnJ3S6bPpYl
	7oKW0suKZ3k8l5g6yvfrKCAIoEr8IbU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b="xYlP7d/H";
	spf=pass (imf05.hostedemail.com: domain of bfguo@icloud.com designates 57.103.79.45 as permitted sender) smtp.mailfrom=bfguo@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-20-percent-1 (Postfix) with ESMTPS id 541171800362;
	Sat, 05 Sep 2026 19:35:46 +0000 (UTC)
X-ICL-RepId: 01a07311-df40-7bc0-814d-5f116123f2c8
X-ICL-Out-Info: HUtFAUMEWwJACUgATUQeDx5WFlZNRAJCTQtPHV4PRQBAC1YGVBcOVk1bHlQYWCtbE1UXRgkZCF0dGR5XUF4IXh9MHB0OWAYSAlpFAlQXA1ccVkVcGEMJXQVXHB0eQ0VbE1UXRgkZCF0dGQhHHwowA0IOVgNDB0UALRkcV1BeCF4fTBwdDlgGEh1QHA5RVhtKBnsRUiBVPVwSDxtFPHcpez5+PnIjcCxnPxQ1cF0JS0YJSR0OBFQHXQVd
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1788636950; x=1791228950; bh=5cezDtxlrHR9EE90cG0MGu9l/gtilxYv/wFRi03p5CY=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=xYlP7d/HGHwwS9l4ltBvg+bwAR3UE2k8aaC0n9FRoe2EstONodWFCWhXdzjiXWr5YNGCWihIWyoJNqT4YOMc0V3swB9F3pv+yj58lCdug35TxJU66fv4STV7uVEcjrixwRmFqs9ru2yoZNXafdrcvAJ/OPZwu2BCdfb/y0j/JvVLgqkPNOo1uN2IWylRk6T07drRrZkCoYqPmDnpHGzSTgBn2NG03v8ijztiRonHxgx2J+pYzXOtip8G5rkSZ01Q4BVt2k9/nJdJPH1tlnODon2WwV4mZ4MQ+6JFenbZw3tglu09syklMz0AXySqenX1lx55ybNdAQjRoSB5u4ZZyQ==
mail-alias-created-date: 1772519804199
Received: from BINGFANGGUO-MC0 (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-20-percent-1 (Postfix) with ESMTPSA id E677A180009D;
	Sat, 05 Sep 2026 19:35:39 +0000 (UTC)
Date: Sun, 6 Sep 2026 03:35:34 +0800
From: Bingfang Guo <bfguo@icloud.com>
To: Muchun Song <muchun.song@linux.dev>
Cc: bingfangguo@tencent.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Subject: Re: [PATCH RFC v2 2/6] mm/memcg: get memcgid reference only after
 swap charging success
Message-ID: <apxvBiaMbVnb6cvQ@BINGFANGGUO-MC0>
References: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
 <20260901-bingfangguo-memcgid-rework-v2-2-8edd7f7a7251@tencent.com>
 <a2fb9ea3-78dc-4bee-a64e-0928983961ad@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2fb9ea3-78dc-4bee-a64e-0928983961ad@linux.dev>
X-Proofpoint-GUID: f1AQX1aTWqZN4lSzMnJQFR8nPOtEeKPA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA1MDIxOCBTYWx0ZWRfX7iWWTN2q2aep
 YsFgd7msiqRVkD/rJQXi1/QlA+kVGXDWCKtn4WB9tUowU0vkGImtXVZ4hhsoHlCHnd/IeNQ6Dku
 MK+/ttyGh/Yz4c2V2oy06avcjMT6X5x1JnmH0YBw8H2cHoqI7WRSPpMJPj5b70ChIv4s50CGyoQ
 M4uK/OsaiXpI/5gqVECxKvrWAx1zEQuBIPJhVEo2HlaANoslSCHmuSelXpZxUkuZRaqApt27XXm
 SSnMHpLrDdPrLoNWvhXdfyVwA3KSpxgh2avBzAqTKz5u3YYI6pDP/g1EHel+vFvpk8pU0CwHTZi
 Z8j5tULbt0FreMybyaTkgEhknTxXIgdnt21gD0eYd1/9L15hnxH9lMXi9Lgdtc=
X-Authority-Info-Out: v=2.4 cv=F/5at6hN c=1 sm=1 tr=0 ts=6a9c6f14
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10
 a=x7bEGLp0ZPQA:10 a=vu5NlEYW-o8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=kWxB-xFdqsxXOBgkBTwA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: f1AQX1aTWqZN4lSzMnJQFR8nPOtEeKPA
X-JNJ: AAAAAAABQtsNwvohzyHt18T/0XBw4zXFE4+rSf1ZKh25MuxUte1NkrQswCQK75JHel8fA7OxzS92/1Hos834UchYn/lKqif2Zda/FvdlEf2XjL+bRuZsi3HuLgn2RkCfOJiOSByR8BM9/fy/332snyhjR4TsbZKBtWg7bb1oIkNpTKQzV8SeMeo+Qn3yI0m61IGRbpb+jNQNXLeVuNGwfjkHvP8sqZpHpAOrFkgsCtQwiuQZ5ZfEzkJEqkuQVG4Kx/cXOpJM/6M+5yxW7/TGDf2Z8rR3SoqFjIcT7zoq7sAMv6wTG1gcDd7W9mmFCe4olo6YgsjlfULevVzja6q3eek+f2G14qDi0Q8m46NjVAfLpsE11mh4ATE8m+zUClBwsmRwugerTW19PeG9uPRAuhpQZR8ySGZqCUUEpFc1lAkOAFlVg9eQKjsLY/gbT1VN9XInEjtWV23yvVhn+yYLROVcQ0CdTzkzMv/Fu5EkvmGXf99jt8KE1RQvsJKb5uzE11Tl7Dh7u8KR+ZaKHmxbbia6ajjKsBES5KedYxM1Tn3cRYruV5AFKSr3KuCS7V4SlKEeUrl7A0uEMzvUhv1kwIIrIVo2vr6tUaE2FRiwaWUX25bY6UISum/f3h+NcnQR0cN0zvB0yRgY3FlM6nWkW4b/U+EJBDEOnhN6dKx+fHOVEq6COLvQqXC873kXjyuMLLDpBrKTBjCVC2cB6TMyyIqH6q7k3JEthiP0LgqGQmiyx5sqOd5cr96OKQju+nydnCuamVFir597b7+cePYPSUKogHK69US98/eWOH1YxqqpPn9svSEy2sk6kI57wzfaIR9AmhLuNK5tyLbxGWDZKigtShbfmafSe0L4LGWdswZvX2zh7OGrmNWzKoSyyMSOCBz202q6bET2/LGDIc42K4IbAK1GqeR0qpH8GxkB2iYmhB4JgM9yxRtSjD5fH+dPpblA+8t9UQ7CBk4HycWePod
 sMRxyRk8
 3Srh7gsBITtCb7xOUnRuawvoZwth+eUn9Kr6qyMQtzBJBYuPzaszmj3fKnM1kL47y05+/LqvSlIHM81Z9bPDajhoY5k+EO95NWk5iqKiXiJ6YCKukQm74qK98SRhNfkzR9N6+ADYJUymAboZvbbfUdwCvH7BOZ7bFBuHNMkh92ZrvjdkCj2tRJQknZmKKf21ETJd0m2CcHT960/G+RQr+aKLEPsKlNXns39TnUDVw354HLbH/DlVfrJFJPz9oAnyA1cqhJnMPFt0vljB4c2+N2qfvaKNgZ70d4qf48iMTDQAGoA633zMff+loSJAzXifQhEdBjMHHQ4nWt2s/hWuyjcc6btA9gHiWZIWz4d5SUlMU1mMKCj2GY+i5gfXW3lbufp76dNHQ8V084CR0H42em4wCaK2wCteBf7Tayiwh+a1X+NEE5FfT+yFw0HgqUDCHKMcznaUm7EJ262p8336/H3xhRk/4qi+RCCLamK2gEqwzzw==
X-Stat-Signature: 6agxp5fg6h4p19e8xdhifncap9zpqffj
X-Rspamd-Queue-Id: 7CD65100006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788636951-756686
X-HE-Meta: U2FsdGVkX198CsEXwQLEHek/V5Hr0sG0C2XE+lX9wCULsW9Csdtacw33XyamJkUaJmgk1r2AZ4+0Svz0+tPO9jN4+Iw2q7EPRoa0i2ePOLIFz+ZUQx64QAD/ZEWL5sU5TvdqhdRwl9HuoB9W84aJPkuWHwaFeJu7mCpHlGQEMcqNrK0vuKgbcVrE5WZ1Nt5OXQb8YTxCh8ediaqNMmS/vIYdPLaBS8U1nLms4Ge+2o1xUJ0UmVI02Ys6PJq2dnd52cing/9fsN1jsGSYQOWAm4J6TJT8em+qxiM5w+8geuDXVhDxBmP61NzsTRIpO9E0lyBHUeJx27WhzG+Je0bt1IaghSqgXD85q5gAN0MEhJ3kRqQipSZ0r1F6CMCGtqGKz2yZfKY2NPkyzYbvjWYaJ6dpUI4N2uZaGNeuA+C2LcA8eWMvz8kstsJ/7QCi86L1lChmJwq0BPxjnZnYr679X/2KUsttQQvvIhJV1SInd1IBPhhGZarAp/Pn3c1aYhNGCPkCQQVZkxl2rMTGAZRaw1St4GgwZx8g2upHgCf59RW0u5K/6HDFRHzu4pwQW+HFnjNcgPeydTlnXqRgLgwlHTdUYI/bDm+zD6g0QPZZ3rJvJ99a6atbKRUSSipkhJ86kl4Jx35qAkgnLvUTDeV+nVAALr1qKy3z0Nx74J7TSjEYkDDqUlMhsw0YRlAsFhSf2p89+itcM97TbjMZ4GlLI9Btb+9VmKa1rq1xvcGvHYonvw0PbSADgNJNobpPiMVv158D68biKIJHHyvMgy/gEnNZe106lawlIcF3vnw7imZZNBpZfZdwgHBSpAbDi1YqFqMfi1FA6Q+ArfCvZ9EIZD2eZO+DdtAIYQA6b8A9zJ9WnAaQ9yNGR7lw8oWbJp0MbFUcur3e0BIAYSOpiE5YJILatTy4QQm3fl6TcOSCq3QbuzWB5ZuqUHJ1uozYuHvMZLjb4K6D+RA/7UWAn9j
 T55Z8Dw/
 OI8PNtMBTWtqO4oJijsnK/mNTgJgxg1sUWU+HUdiXlJA4P0QLjM+5fgBu3F2IM/rsGETk6qMoWUCCRNtu1D5G6h/SPlQzgkBg/CKit/1/zjgIuPr9NNDuIrCEBvs/6PC2hFcBs3E+2s7ueoRYbtfRrrZPnN6RRfALhPBsGIpaFY3Id4SFHnIpsPGVPI3rC57fWUbsm6FTls2yabNOPuJ2L6jhmX4vQ4YxA2kaWBN+JPyLn1NsLqvftjE2t7SGnQnpZrUa4CrMXvuFhRpgMCGIvOlrVnc3D5aYreLc1uLlYpjthHfw+lmqbTGjTgLZ1P8wvss0S388ykzHGnXREf170NOzN1aNt0jST7m3w72pskFKqNWeiVMReUtnvhUj4uE6U4j9VvBmMDsTrqURkywxeHkLdwJJH/XegCuWaPOptgZjPi3kVIScQp9/JzupyuMbMJaMDHNDetutQfM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 05, 2026 at 03:12:19PM +0800, Muchun Song wrote:
> 
> 

Hi, Muchun!  Thanks for your insightful reviews!

> On 2026/9/1 16:58, Bingfang Guo via B4 Relay wrote:
> > From: Bingfang Guo <bingfangguo@tencent.com>
> > 
> > __mem_cgroup_try_charge_swap() pinned the memcg private id before the
> > swap counter was charged and had to undo the pin on the failure path.
> > Hold RCU lock for an extended period (which should be fine,
> > __memcg1_swapout() does this as well) so concurrent memcg release can
> > be avoided, and take the id reference to its online parent only after
> > charging has succeeded.
> > 
> > The failure path is now a plain return, and the id is only pinned for
> > entries that actually end up charged to swap.
> > 
> > Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> > ---
> >   mm/memcontrol.c | 15 +++++++++------
> >   1 file changed, 9 insertions(+), 6 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 31cec9dde55f0..ecb4fb07d7735 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -5755,6 +5755,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
> >   	struct page_counter *counter;
> >   	struct mem_cgroup *memcg;
> >   	struct obj_cgroup *objcg;
> > +	unsigned short memcgid;
> >   	if (do_memsw_account())
> >   		return 0;
> > @@ -5772,22 +5773,24 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
> >   		return 0;
> >   	}
> > -	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
> > -	/* memcg is pined by memcg ID. */
> > -	rcu_read_unlock();
> > +	while (memcg_is_dying(memcg))
> > +		memcg = parent_mem_cgroup(memcg);
> 
> Since we've already chosen to expand the scope of RCU holding, it
> seems we don't need to check whether the memcg is in a dying state
> here. The upcoming stats updates aren't really tied to whether the
> memcg is dying anyway, right? Why don't we just simplify the code?
> 
> Muchun,
> Thanks.

Yeah, indeed. Whether the memcg is dying doesn't make much
difference, and dying memcgs should be rare so walking up till
some online parent should be useless in most cases. And it does
seem a bit strange to do that here...

So I agree that removing the check would be better as well! I
will make the change in the next version.

Regards,
Bingfang

> >   	if (!mem_cgroup_is_root(memcg) &&
> >   	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
> >   		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
> >   		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
> > -		mem_cgroup_private_id_put(memcg, nr_pages);
> > +		rcu_read_unlock();
> >   		return -ENOMEM;
> >   	}
> >   	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
> > +	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
> > +	memcgid = mem_cgroup_private_id(memcg);
> > +	rcu_read_unlock();
> > +
> >   	ci = swap_cluster_get_and_lock(folio);
> > -	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages,
> > -			  mem_cgroup_private_id(memcg));
> > +	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages, memcgid);
> >   	swap_cluster_unlock(ci);
> >   	return 0;
> > 
> 


