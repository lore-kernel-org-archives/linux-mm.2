Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1596C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 17:52:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5608A6B0088; Fri, 18 Sep 2026 13:52:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 511326B008A; Fri, 18 Sep 2026 13:52:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FFCB6B008C; Fri, 18 Sep 2026 13:52:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 10D3D6B0088
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:52:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F4121A071D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 17:52:04 +0000 (UTC)
X-FDA: 85227626568.01.A85B062
Received: from outbound.pv.icloud.com (pv-2006g-snip4-5.eps.apple.com [57.103.67.108])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6F7F640006
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 17:52:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=h+wBuvz5;
	spf=pass (imf07.hostedemail.com: domain of bfguo@icloud.com designates 57.103.67.108 as permitted sender) smtp.mailfrom=bfguo@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789753922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7LBbzHTkFaCBQX5XE30CFYaJt4ycrCQUuP75OzRZKK0=;
	b=G+uHvtwHp2JmJ014VQXZpTFKYaw8tGJUaHGSBfxAyEcYizm3C/XIInpnXmEHw1VZqXE3Nq
	F+wDhF6kl/xcLH9kHM3NEiVTQx2NLWADrHtbzz/Ri95G8onTvmKmjrdBpQ6L+APnD3kxwA
	y2RZfNhhDNoQ/gNhkOAckTvK22mnUj0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789753922;
	b=zZGsu05MGm4W95S6IkAzq5lsMDkw4Kmwty4e8zXRcXEUGTSQLTO03IcLRRgAQP6LeTLPJf
	HVDnxgCBOEoUjkHfvRb1cp/ACLi//RcVK8Q6xFAyrZzJqQgaNXzu2ppbWD5NpG9b0weqSH
	9TglUIT0K5Nau5GBLXkfQSw6RdlzHeA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=h+wBuvz5;
	spf=pass (imf07.hostedemail.com: domain of bfguo@icloud.com designates 57.103.67.108 as permitted sender) smtp.mailfrom=bfguo@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-20-percent-1 (Postfix) with ESMTPS id 674CF1800129;
	Fri, 18 Sep 2026 17:52:00 +0000 (UTC)
X-ICL-RepId: 01a0b5a5-8b8c-7eb9-9063-5a7d1cf93b47
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhOAEMGWQdeCEwCQwZYClBcHA4PUQxHH3kRUAFYHlZeWhdeTVEPDxlaFFwYU0VRH1RYQQ4KWgtQUR1fAgoERwRbF0YDU0VCBhcRUAFYHlZeWhdeTUcfQE1iSQFaGVscQBdKbk1TDw8ZWhRcGFNFUR9UWF4EU1YOEUhJBSNiEnwkfBV3PFo7SjB7MX0qcSp8N34tfEB6KAJOGQxKHVJWWxNVF0YJ
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1789753921; x=1792345921; bh=7LBbzHTkFaCBQX5XE30CFYaJt4ycrCQUuP75OzRZKK0=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=h+wBuvz5TjM3UJFsobLYuvoJS3YevTdzxuY7iWRm7Fyo1rdauiIdGGsKwmH8dCmpapPw35EsoqkVEEz7hUcTbvlqCZVa2TT8CYoWiVEp7Ca3DMoTOwxAjXsswsoqzYy0JBZuaQVYP/7ae8lpxhqI6EZk9C2lA1M+DfZO/le+Vd36HaK2BkgFc7vSifamE3mHmDsKtNyq6ZDrPLkqqv/g6o0AnsT4rsFC7qWX9x9AW/SDStiEIQSzlKIuYU8dWK+SL4pOkhYeDBpzOVxfOfsHIBHiF451Yb5M4XKOo1XMgLnEUIP89ieg8IjNpiJVip1mHUbeW+Rhwpx1Zy3stlRTVw==
mail-alias-created-date: 1772519804199
Received: from BINGFANGGUO-MC0 (unknown [17.156.192.29])
	by p00-icloudmta-asmtp-us-west-1a-20-percent-1 (Postfix) with ESMTPSA id AE94618000B7;
	Fri, 18 Sep 2026 17:51:54 +0000 (UTC)
Date: Sat, 19 Sep 2026 01:51:49 +0800
From: Bingfang Guo <bfguo@icloud.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: bingfangguo@tencent.com, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] memcg: keep swap charging under RCU protection
Message-ID: <aq16NUyNTEmDQmPx@BINGFANGGUO-MC0>
References: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
 <20260918-bingfangguo-memcgid-rework-v1-1-5bbf3220d88f@tencent.com>
 <aq1qj7Owhuk2BQsv@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq1qj7Owhuk2BQsv@linux.dev>
X-Authority-Info-Out: v=2.4 cv=KOpXzVFo c=1 sm=1 tr=0 ts=6aad7a40
 cx=c_apl:c_pps:t_out a=aW9mcIavGNWWFvFFKOxBSA==:117
 a=aW9mcIavGNWWFvFFKOxBSA==:17 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10
 a=x7bEGLp0ZPQA:10 a=vu5NlEYW-o8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=pb9MNQf3OW9oSO2XpcAA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: Rw08J6G-psqXahF495GT95dTwOoiL6V0
X-Proofpoint-ORIG-GUID: Rw08J6G-psqXahF495GT95dTwOoiL6V0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDI1NiBTYWx0ZWRfX9vXqa8M6eOE6
 /yM357GhFu8cUzzxGSazpp4GH1bpjI+z3aarcpSirBIAjCL28L1PoPTD0zjuomTYKePPIdUISU3
 yiF++4s24VGSsZrpVDwRBxTjp19hLocUhqJ72rEu+iVkiPYx9LXVwCmWOaCqAPa9bMJuxMpHnCa
 I4mH6/kMPxrLmR8b+IWGzv7YBCYoTUt0FnFXM8ZX/zUFfvl4nNsKE+7+EsFEnywQ2z7KmVud1iZ
 YRi+ChzjEGjkivpA39W7iOY9RgBII7AXdBHpamERn/PjveIJ0BpyqD0B9x6rDTZSHwfhdiemu1Y
 uAd8poqknaIa5QGUigL/Iza9zcyF8uU+MQwE0Kuig++VmjrMlZuWwnGGCnFtTg=
X-JNJ: AAAAAAABTX1bygvuXCKE1uqtLnv6DoY6RuVkFeGF6oB9mf3GmrUhZQkKSNQyKOP/T7PSUdsS21klhKbJVRg+50yJBLHYpVKryExKrAnzF1rcApNToIJKjLWExg+/YXuuZN2r8Zu6ST49v5bp1FuKTgIBhCbyUGMPI8q5buEuJdXIj1u+4rq9T5nowMKkHkOWFI0wIy7OgGXrM+TU6XygjGxqeQB6OmjAgIVoPrc/hXggzV34W1xBtyDKtWmOLYwplEuVuJ0d2c4wUDSiNmeTX8+1jy5K6uwDCWcUtCJ57UzLhZq3TtHk6H1Bsr4txi/q7h3BKCJ07iyF/d++2tSA1zH2ZONh9obKin2jAivpGJ0lmwuujMfi20DAnnlzJPTF41MTtM3gPwRWsdOGnj0/BrWCrt5oJTyzbqiTOt+2IV1GQpe7VJ7xh/SxmOmxGcdZ9iuY1mBCMdQAVdeRJGGrvPq+0xbBfeb7eM6+PcrIXFUp9EPAU8UqTp9ugVOfw7hYsY8KKNn8IzOrEkw9V0NopvArQcTbWs5LzEICUBpIcNNyzUyHImi2xY3t4QgApYxrBuoEyUcBEcIK8SBNY2Hk30FOHJvwB01bGIw+fhe6SQJVHUUQ90uINAv8ofnT9V0qcMIt0mX7lgVJy6IwsbXSgLu0/pEQL5MUoCy6BXI5BPuv65RALBOwTyYegF2jM/eI80misUtPQwLldKOpc/0q4WQQe1ds+KlKKhe4pkNix3lYexJ4aqX2O1PDRuxKRpIenE2I4SUHYwJR8bsZ3cml2Zr/0IZGjyT85RBGmP9XFDHP4V8Hm17GE9pC1ZZp73d96g7aSnULXU8AOkPw0xl6Mu9p4X1QZ/UsgejPH0ZWn2Y01TWyAeEgKB+BnNEBzN0BsjEWv0gj49ApYWTNtzssuNovKZiNi0HskcbwM7DUzpwueDGEGg5FcAuWelOBr41/1TFO4gxOAFVxqF9ZPCL8Aq4
 y0Al/H/3
 nOgNPgPnzuDXeIPPIXE3aClmb89ekZZ6oPJcEQ6zZu0c3Fgxr8Ye9EUebfV4gTauJ37SALA1FiWOTkHKQIqD99If6hoetfwSaO1Fh3TaAJ5ikJuTeVyb3Twi/kChYFobtXe8gktS8Lzkj6+Z0p+Wd16apsakxP30Mphey+WDU7raPPYex2MoeSBnEWfim5LSR9Ejlsct/IPepbRoaX6VuuwzHADAnnxmrVyd++WAvS1oF6gLmG7M86FW3QzS3BglSWT2mTza0KjJytv+pnk+NLJ/uGFalUZDuRzeO6dNpv2cmkYOoqLhVIGB3aLDtbA4XFFCx3VbL8OaVXNO0pr3WJHtB6Uw075fOVIH/jhkO4sI0MRMSiJiKQZfQNb4BICFQVrK4uoW4USxsgB/g74Hvm+0WJxkySuJaCsQzLsshggh+13WzVjb8xlFtB1nPMMJIt4cI
X-Stat-Signature: 86m8ims7ctsbs5ac46fxccsdoojwzbda
X-Rspam-User: 
X-Rspamd-Queue-Id: 6F7F640006
X-Rspamd-Server: rspam03
X-HE-Tag: 1789753922-98831
X-HE-Meta: U2FsdGVkX18o5HTdOzRdICQNfL3RpEnz1dX0VmCtAH8y8VwDztsa0Ejw/k8nPKsj/msNRGZT4aJWPYvbEpE309B8z3XYSBzMPNNf5elGp+9lI4E+un1taIU1ZIwWrMejxhxQVmC/a2yvNRkCzYOcs6JEIzs1JYIExmx3/h02ji2nKBGOhE9y2Qaes2ky0qNviZrzPwEMfbvZv42bzxFirtFZgy+LPhmzQjIcIkikj+O3g7X62/t/XXoSQu+SISq6LCCR7hf6qKU1wK3cdrBLp0AgAnm0lTegmnVhQ7I6SQmlL6sp665gcMe6q0p4G3oQ53DgNPN3A+WEk4nBI2YoH9BDR5hgqOoEA8FV7ws44NbkKF5izKWyOxUVLKrktR8ORgNV3M5R2eXq2VExm40k30yq4qHhAVnEeCPaz6Gx1rfeqGZ9xEVNIkYsYC3HwHf9ejg3M5kIUE6htDZMe1A3asRJSSE38GcvJ+f8DweMEbd6H9wJIU4/7e6L7boH0ZLrvjl24MTbKnVZ59acNerat/TAUyZR0JY3tvxIhwFepGkYfvCjKd+3G8JK+i72P3lOf5Sd6/3haPY3oC5/wPksJiV0Z6rabk1XmH75MYXmx5PU1LpIBncvdmCUqgwuU8CyVS3k8Xcw0MaSQGk8OFemOOv9ULXxb29DyRekMs1GrTzJTzATE59DfqilFTFaNVYzO2aqBfOENDCvjejUDZxrxrKg3SrNJZ3u7C3KA7knoW3x0gUI5Kz2WtQkiDJMJ3vAvsBK9kWEpm3p+0ctYwuW6Q23htB2PFU48VIA5SQkQtUf8ifUuAHFxoqRMbBWdsX7MpS9x9yqUffXX36Lm5Bzcv0k7R3tnXugdVicg+lUuDlnJ1PslmbXMzErVKDPQLiWPy7VbllPyd0+DeR6XC636zm2kU29Go6IEHtYy0FubwKr6Ekh75KBvkotcAprW68xRJpht421VyHf0C0iqFK
 +FRtvprY
 C3sM7UeNwsKsrxiP9GK4E2qY1ymeRAco1lI0xO31Gj1zSJBpuh5O66jaxPix2FodBw9mbxEWiZKZfPk9STiaDJlVUzsXKCXHf9aScH2NTAtH0qQJFORc4+ZfEU8dypfWAZbO8YhVP9C4M2HIdMPwlAq8Kvz0ffcywmmJlzxG0/Xuor+lOLYUxNVTlhcshqdqMR7fMxyOIRUEo5JASIK5IFQTtN6FR79x3THohP7FLRuOlilEcpkmDnuAQs6ZzmDEQa03HSR0mB15yB2pqKK/hT3J6crHrDp4Vh9wqasI3+4ek12BUXqawkMC9UwKvldguB8VsmorZ+U5bGHWiMj/0LGQlcANskob7EuaoT8NiJGYQV5g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 09:46:47AM -0700, Shakeel Butt wrote:
> On Fri, Sep 18, 2026 at 05:18:40PM +0800, Bingfang Guo via B4 Relay wrote:
> > From: Bingfang Guo <bingfangguo@tencent.com>
> > 
> > This is a preparatory work for unbinding memcgid from memcg. No
> > functional change.
> > 
> > The swap charging path currently drops its RCU read lock after acquiring
> > a private ID reference. This is safe because the ID reference pins the
> > memcg's CSS.
> > 
> > Moving private ID references to objcgs will remove that lifetime
> > guarantee. Keep the RCU read lock held while accessing the memcg for
> > counter charging, statistics and failure handling. (This matches what
> > __memcg1_swapout() already does.).
> > 
> > Save the private ID before dropping the RCU read lock, and use the saved
> > value when recording the swap entry. The swap cluster locking remains
> > outside the RCU read-side critical section.
> > 
> > Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> > ---
> >  mm/memcontrol.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 791e536efaebe..72522ec827c9a 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -5954,6 +5954,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
> >  	struct page_counter *counter;
> >  	struct mem_cgroup *memcg;
> >  	struct obj_cgroup *objcg;
> > +	unsigned short private_id;
> >  
> >  	if (do_memsw_account())
> >  		return 0;
> > @@ -5973,20 +5974,21 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
> >  
> 
> If there is one more spin of this patch, I think scoped_guard(rcu) would be more
> readable here, so please use that here.
> 

Hi, Shakeel. Thanks for your review and suggestion!

It looks like a good idea. I will include that in the next version!

> >  	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
> >  	/* memcg is pined by memcg ID. */
> > -	rcu_read_unlock();
> > +	private_id = mem_cgroup_private_id(memcg);
> >  
> >  	if (!mem_cgroup_is_root(memcg) &&
> >  	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
> >  		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
> >  		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
> >  		mem_cgroup_private_id_put(memcg, nr_pages);
> > +		rcu_read_unlock();
> >  		return -ENOMEM;
> >  	}
> >  	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
> > +	rcu_read_unlock();
> >  
> >  	ci = swap_cluster_get_and_lock(folio);
> > -	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages,
> > -			  mem_cgroup_private_id(memcg));
> > +	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages, private_id);
> >  	swap_cluster_unlock(ci);
> >  
> >  	return 0;
> > 
> > -- 
> > 2.43.7
> > 
> > 

