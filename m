Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E87ECAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 09:35:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6E238E000C; Wed, 24 Sep 2025 05:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B45788E0001; Wed, 24 Sep 2025 05:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A355D8E000C; Wed, 24 Sep 2025 05:35:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 89FC28E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:35:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3E61CBB5C9
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:35:15 +0000 (UTC)
X-FDA: 83923635390.28.7976FB2
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	by imf23.hostedemail.com (Postfix) with ESMTP id 245B4140008
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:35:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="k vMndgh";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=RYDdD8qp;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758706513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RwxT2y/Fo/wEThm0R0fUBSP/jGcCTaRkM4zay+eO9dw=;
	b=8k8HpB4e83WLjRgB4U5AQnQ1mqrKZ37pyb0ivsx378JBDzrXtyje172zuL5AVfZGAKxFMu
	foQdeZnwVyacfkcx/TV0cAfoR2P81YXlCIQN35yqRbw4IciCEq2sdisyf6Yq9G0xK4Awgq
	5e55PRJjJ7SGuKo+t0bh+SnqhGq3Tvk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758706513; a=rsa-sha256;
	cv=none;
	b=XHAKQ+Crw9hjI+290nSt55k9UYgZPQbNtOf6ULIgY7D4Fqw+2OXPGf+gAMNO2AJ6C7zQl4
	SR3rDKcgZ0H7MkvtVTyhJ98aYXUfjAsmmDKFy5qUUF5vP5KNpHIojWYz54Du7hsNVUimoX
	u/eHTqucQ7wUwYBM35wWLjGYeJQg4oE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="k vMndgh";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=RYDdD8qp;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 516A41400066;
	Wed, 24 Sep 2025 05:35:12 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Wed, 24 Sep 2025 05:35:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758706512; x=
	1758792912; bh=RwxT2y/Fo/wEThm0R0fUBSP/jGcCTaRkM4zay+eO9dw=; b=k
	vMndgh3LWI5bt978muw7xZXLFR0zG2Zvtm29snab06KD1qCWwf78LuunSI+70ITZ
	vzKQ/+dHBhX4f1l4eFdotSVQDxFcrd0wZaRXH23ZMOy/3M8SN6DXeJuPEDyEpyLC
	SuwCqrvVvCHtOYpXbkHYhhgBN6dVp1FLBxYrZO3nQ7xUILeJspn1mMbJ0OFj6D8u
	piV1PnfNaOtkcR0lr9MXV9rjeN0193HURfi8kimzrrCp2AmlYxZNPCAU0XmHernj
	7AkZnYC2d4Xld9rShTiWjyNMNC8J9FTc1oSQYrHreLRjdaywczxQCSruaD2JMQAu
	WZH77WsmVsodzZnU1oaMw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1758706512; x=1758792912; bh=RwxT2y/Fo/wEThm0R0fUBSP/jGcCTaRkM4z
	ay+eO9dw=; b=RYDdD8qpjfFM8OH1AibRws/QOX6fSJsCbuEGcqgbdyCjeVwcOxI
	Rd69Tp9DeQjpT5hdFwqJB1Uj988E5TNDnFWnq5bhe9l2BKBTycKgRUTRGgmh4D28
	4cWWcrqLh3LlJhIhWxoY1i0c5tp3Zet1EKa4+rgMasQXhvRxUsBj9Vo1TCHvmTA9
	lnH/UAw21Y0v1dpner/PkpKfOXBmnHMaK66z1V5tfTG+Yzj6fSWb3a/ZXaYI6Z+S
	Ib936NuRVozYHksu3EUqWiE0ozQA9qhGChGtpIIz+SYDnD/AagKnneeGT4poN+5u
	6q2IaB0EhstAQT6yR7bwDTKjWn4Ygu7eX6Q==
X-ME-Sender: <xms:TrvTaF-yzhq6wApsY0I5VOyWJBAA3-4rOlIknmkh0mdaHuu-Uf5fJw>
    <xme:TrvTaDYvZM26CQzDqwxrRlWDBad8nwgGLKZCR2lc3v8D0mh_vPdlFFm7q_3mI6QLY
    flsQ8sRorMijWOZO99LuIAlpQz3oRDUYZeliUiwHla-ewMQw-bet58>
X-ME-Received: <xmr:TrvTaCXfO89CeQeVUULQ7Qf8YKT3s4F8dvlxLeIs8dKXBANWGBhQjPBdj4FIsQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeifedviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtledu
    hfeffeffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepfedv
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehrihgthhgrrhgurdifvghihigrnh
    hgsehgmhgrihhlrdgtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgu
    rghtihhonhdrohhrghdprhgtphhtthhopegurghvihgusehrvgguhhgrthdrtghomhdprh
    gtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdrtghomhdprhgt
    phhtthhopeiiihihsehnvhhiughirgdrtghomhdprhgtphhtthhopegsrgholhhinhdrfi
    grnhhgsehlihhnuhigrdgrlhhisggrsggrrdgtohhmpdhrtghpthhtoheplhhirghmrdhh
    ohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhopehnphgrtghhvgesrhgvug
    hhrghtrdgtohhmpdhrtghpthhtoheprhihrghnrdhrohgsvghrthhssegrrhhmrdgtohhm
X-ME-Proxy: <xmx:TrvTaBhfFuMyhpo4uXpgNh3p_nO-TnnYMz9RMIbqJdE46e_eMjApDg>
    <xmx:TrvTaOlh3qDt7P7GojARw2Co5wK4Yhp2yO0MnTTs5PfrPrY-m7scnQ>
    <xmx:TrvTaIKqbDjo1CAsg9HWvWwb5biiu12mx927pxGrpBKnJALEzLj54w>
    <xmx:TrvTaLXCILAvhQdhQY_T7fw7WGSU3t6SHBTs4P6vSTrq8IkoGQmW8Q>
    <xmx:ULvTaC5F9Q24qi6KRUWvlw6vPR_SpZL9pgigh3WnZufXlum8wnQjQvkw>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 24 Sep 2025 05:35:10 -0400 (EDT)
Date: Wed, 24 Sep 2025 10:35:07 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, xu.xin16@zte.com.cn, 
	chengming.zhou@linux.dev, linux-mm@kvack.org, Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [Patch v3 1/2] mm/ksm: get mm_slot by mm_slot_entry() when slot
 is !NULL
Message-ID: <27storxu4seijr5smul3xx7pofe45ittjrchii3jtwbntalsiy@2cu3wf42drwa>
References: <20250924004854.29889-1-richard.weiyang@gmail.com>
 <20250924004854.29889-2-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250924004854.29889-2-richard.weiyang@gmail.com>
X-Stat-Signature: bim6jcnxa1ehn8oi3g97i6pbq4t4bhjo
X-Rspam-User: 
X-Rspamd-Queue-Id: 245B4140008
X-Rspamd-Server: rspam10
X-HE-Tag: 1758706512-858397
X-HE-Meta: U2FsdGVkX198c6ctXfjYoks4NpN0NNWTsQFZK5oKiIw6tjsDcWUXFRuAx+g9mGPJ+d8a2013PsKDiHoIhZEXSDozzCb/QoXdOcCyf0dg8hkStxVWw9gMrSGcsGI+XWRE0GF4JFD2J06/96CckiH8ZXsRy78I/IOSQE04i94n350Gg42KgR/FGSAlCm0Prjn3MjZZkw2mxtnbD7ksIEf1Yqx7i+Fte+w+A0nl5YQHIPOJ5PEE/Nw5qzbYdJRyptwni4RFVU1OdUudn56XgiDrsjIVTyD6YfyIxoSIgB4oBn6Fx8Ti6bX42scBIlKHORHftQ3zQSRfNFiM8ATHvkC9CEOSG+9u8r5BUWPUiZONZuSBEFbUTPjd+ZzkfIQte74Va0YlMGoFmK4os/ZX4amg+1hwOJkAi2ZizQNAoQgOnWs+5afztM3qQKZYFJ+cU89blh/caBw59g/Ubmr0s4uGNaqA/BKo2iKIXnAnVYJfqnXZ0+g5iJiuDcDcYPmtKXdqJfx2LGK5qXN6UoQfwI4Ih7qmgAXiOWgdwY2B6KtJyJUabZBVqkeBDQefrCr3sy8mo68OvTeusrfixNGigi4bUEUPeAVrYAm5SAGQcbUfm6KtIZsVyPjXqVfrJztDB1b0tIn9VAMU7qdqU6HctQt6Yv8FC5Wro/KO9MiAd/kELvHkOoyq0HMI/HQYzBbXMxUmyiaGlneuMdZgQG+ph7aJ7q6ji5eKF43qvOiBhoaUExT6W7ODRk+FuLlP3PGw1RGTqw3br09eGq0Bkk1tfjAslCX66Npvr9rWnuX1ap3dZDk2h/K3gWDLDkSO2n/ONoH0d6hj695RRm7TkaLgiHi17iX6QBLbQ3PaIt8xDsj+MV9XoJB9VK0VAoQTv3DC+o1CkvITElpP33L/o6QgTzeO/wudJshoZxbVHC+QG6A6YYZ5Rm+UBQQXKvhVS8SbSdMDMyxLIY/yPfQA8L+W4t/
 vrGwS9Gz
 6zaGf8OjXKz4SsCWUxhcJE9Z8tyfI9z70MTPUKl/0yVA2QO0rvyScVnsft+6bSBPQhzu6AXidHmDz87zHAiMaLceXQUSwuNjF4+ymnr2w3ruSCt3JeaPHDkzWGbLPybPpK8536KMmFzrs3QUslgv7ceBwcFc72nFy2GL5cT/u+dhhLtxifpoC0uWnlc0QznlfpG8xUW9Vxj0Yix+33hwBdmUNd0wFqb9br/BEETEr/s+I5cZFfQGzUUWIPXVla+hOcgaVAFz2ar8U+sl2KqHnVtuxiIvgP0eeDtkKrLBJDi2JlT/NM43d5bU4pc3HoyZJKJsyTdemK4lhLAlHeNvopnPaKVi0Qm4BX/M4CxjKTnAfHcQQb7gk/j36x0SM8jNRbgfTBHJQuy0Qw8PM3L+pae5SrESJEIPg434zs9Ev8DiNWqJArAzh1RPH0rIw3thW2RmVmcOjl3VN9a17DOaPeEO44b2xBUQaIcUqCQMTZie9dcBdtpkE9zVFZP08p4jCin4pWSqUKJzQ/066r9FEFGAZCGB9J1UBzcQI3H3g5wK4l2FUMK7N9XqxqFdpw3Mt7jcWAsX1zV/cs60P2sB8D50XEXEwa2y1WdXIngm4NVR5R1L5TqSFZ8a+byhKglHjD7izqw5bF2VUits60EMhmMKddN8d1LAwz+pnkBZ0wJF73b1N+qffryyHoFqMvJD2Xc6Z2t+wb8PYDIKq7/3rWYnsW4rJ1dvtq007L0Z79+ULIhStQTF21VBDRaEHV4D/08kWzxqx7E7r0ZoV5nxXxrnCfnXpFRqFKxT6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 12:48:53AM +0000, Wei Yang wrote:
> Patch series "mm_slot: fix the usage of mm_slot_entry", v2.
> 
> When using mm_slot in ksm, there is code like:
> 
>      slot = mm_slot_lookup(mm_slots_hash, mm);
>      mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>      if (mm_slot && ..) {
>      }
> 
> The mm_slot_entry() won't return a valid value if slot is NULL generally.
> But currently it works since slot is the first element of struct
> ksm_mm_slot.
> 
> To reduce the ambiguity and make it robust, access mm_slot_entry() when
> slot is !NULL.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Cc: Kiryl Shutsemau <kirill@shutemov.name>
> Cc: xu xin <xu.xin16@zte.com.cn>
> Cc: Dan Carpenter <dan.carpenter@linaro.org>
> 
> ---
> v3:
>   * fix uninitialized mm_slot
> ---
>  mm/ksm.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 2dbe92e3dd52..c00a21800067 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -2921,7 +2921,7 @@ int __ksm_enter(struct mm_struct *mm)
>  
>  void __ksm_exit(struct mm_struct *mm)
>  {
> -	struct ksm_mm_slot *mm_slot;
> +	struct ksm_mm_slot *mm_slot = NULL;
>  	struct mm_slot *slot;
>  	int easy_to_free = 0;
>  
> @@ -2936,15 +2936,17 @@ void __ksm_exit(struct mm_struct *mm)
>  
>  	spin_lock(&ksm_mmlist_lock);
>  	slot = mm_slot_lookup(mm_slots_hash, mm);
> -	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
> -	if (mm_slot && ksm_scan.mm_slot != mm_slot) {
> -		if (!mm_slot->rmap_list) {
> -			hash_del(&slot->hash);
> -			list_del(&slot->mm_node);
> -			easy_to_free = 1;
> -		} else {
> -			list_move(&slot->mm_node,
> -				  &ksm_scan.mm_slot->slot.mm_node);
> +	if (slot) {
> +		mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
> +		if (ksm_scan.mm_slot != mm_slot) {
> +			if (!mm_slot->rmap_list) {
> +				hash_del(&slot->hash);
> +				list_del(&slot->mm_node);
> +				easy_to_free = 1;
> +			} else {
> +				list_move(&slot->mm_node,
> +					  &ksm_scan.mm_slot->slot.mm_node);
> +			}

Indent level gets extreme.

Any reason not to fold slot check inside mm_slot_entry() as I suggested
on early version.

>  		}
>  	}
>  	spin_unlock(&ksm_mmlist_lock);
> -- 
> 2.34.1
> 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

