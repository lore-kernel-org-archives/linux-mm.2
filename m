Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1D50606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 15:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iDVtXHZd
Received: by kanga.kvack.org (Postfix)
	id D77346B05B2; Mon, 16 Nov 2026 10:27:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D26DA6B05B3; Mon, 16 Nov 2026 10:27:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C16AA6B05B4; Mon, 16 Nov 2026 10:27:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B7B36B05B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:27:15 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A90A160152
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:27:15 +0000 (UTC)
X-FDA: 85441360830.20.31AB89A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 59D2B18000E
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:27:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iDVtXHZd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794842833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=upQeaziCAp0s4MI1ooCF98Esj09UZt1W17ULeweJf7s=;
	b=JptdNaGBvwGLhx8GTll1eIAFyNIiYQFZe9ppaXAroAtCRk4ifHvsfUKusSPWYVaGc9v7Sj
	VshqG2OohJ2BIDI0eJXldLMO4cm9rKyYs37bmSJdcIAzuUihoRLeD+200T/3+5ozpexD8D
	vm1AtlceSEXikvGNzt3bZ5XHLFEVBE0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iDVtXHZd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794842833;
	b=p2L67Rge1wVAXc5e5O8/OsB9skyXcgO0S+mWYMShsTQj5+VrwNCblJpFnsz3ZF7UUbhdZ8
	lilvT+ChxExw4r/C/wBu+j8x5+aZQ6Bet76cRlTxo6LMzq4GT1D5rzC6p4PYS7Lm/JU82o
	zQHa7DdYwhfliXSPpQ9aUkZAl5gNSlo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 83D2940AD7;
	Mon, 16 Nov 2026 15:27:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3DAA1F000C5;
	Mon, 16 Nov 2026 15:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794842832;
	bh=upQeaziCAp0s4MI1ooCF98Esj09UZt1W17ULeweJf7s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iDVtXHZd3KFWd+PePqI5m3ksMYq2Ip2nzvIZCcXiHgLN+WyUxRnE9/q7AUHvuLjp1
	 J/qMSEJJMZD2w3rETtxoaxmT6/AyHRT2OX4tLc+WW14/OFxFHkUsKF5V0YLLXfuPab
	 g9Pr3oRKBVQhIb9okU7FDIZhxqd0r8xq2SARQuaQDCLFzfVwOeST5AG3ezeG+HXor/
	 8sD55VUCq1P938fItCtDJot9h5YEr7ixBSg9akAXV5UxgwQkulpfdXjZDFeREIOXbC
	 49XA/TiY8veuAci/EuK0XrLA8wWUpZRCGFqxF0vj2fpYkmBgZI03DPR6e5aOykZTQC
	 epkhjpM0bh/0Q==
Message-ID: <6c573cf8-4c33-46e0-9309-1d645ee827df@kernel.org>
Date: Mon, 16 Nov 2026 16:27:07 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] mm/ksm: add initialization helpers for
 scan_get_next_rmap_item()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, "Xu Xin (vivo)"
 <xu.xin@linux.dev>
Cc: chengming.zhou@linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20261116014434.310003-1-xu.xin@linux.dev>
 <20261116014655.310486-1-xu.xin@linux.dev> <avsOr-03NtFVG-6a@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <avsOr-03NtFVG-6a@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 59D2B18000E
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: qisocoqnkh878irgdf1xgbs5c3jypzqw
X-Rspam-User: 
X-HE-Tag: 1794842833-904591
X-HE-Meta: U2FsdGVkX185QJdLE+CKVQ0komh2vW016n68FNWp7DrB15ZfOCHZMc07Cj5YQVAiX3dXE6EzABkUbPDUDyjWiDweGV8NS85ZMA0veVGtTBbvX7TiH69E1UsIqxI7hqC0/FAF6O6yxhT8Gv1EUvcdpHr16E5rLBUkpQQCpX7mp4I2aMY744cvQAiWAHqRig1QBX9eSCB5Vf1aU2S4+HarYeDlhotOx3mEI1DkRWUfWbw5Z6cOyAlOv1/b2D8ifHT6jcugMYDvrPCi1GSzglZIng2q5FNx/fU2Pc4y3Y1cesSHFG1qGg77bJkyIa7ELBtdXs7Dsy500KIX47wg/ypXNzWR3MGwh0vabqyyyqEX5w2HvHeeA6Xkt9VwjQyxTDuvYmlK1w/d88msyWFw+ICTh0ZhXyVmwPySqIR4ebb32p3QZS8/PEf9XZ17x+iT9IMbPeNEfTmHwZMAwzt7McPJXHzh8ysnYlK5uoOIS5W/onDJEGDPgUihJynB8qZVaXN9qxdNllsJdBDThdUh7vezmU4HBLWVuSS7qdpz9lVDFQzFKEFRWSJGFlwsBGw9hQO5J6cY6Cpo175NjXsq26N2ffmRrd3Hz5GKAuIns6hrvL6jrvvjfAO6lsnv6pQpDlhSZ3dXxPSdsBptHokF33maefsmrhv/5J2Ki3jlW/dlQ9se3xskRX4zSVXQ2CqgSE1M18xdgK9jNMLKNWcwS0/B6jqZaxZO1+AX/RBlU1WgjXaMdTFkiDC7juGsdgETh7Og4v1sfCTcultiBNdWlAeYW9aHgDVj2ITFTcDVGKu/QMjkWkLkGEFplKZtNlCMjqiBq2L3jccDBb5fEu4F3i3jeW8kOJWxeGU+oPUC+89K1wguroSANnRvJnkgsR5ckPl0JxIBlSStBx2duPVcM7Kbo96AofhCv/hzAuDVuEZr3JX6d20n5fGMxwbsw6Nkdb5KJBHbudulmzAvFp3W0hr
 GICmfDqa
 xDSuEg4AKc96RfeEbr8eo7n3o05qCIZrVbcjXGna9VWycgyvMFCqya/FLUxTQ4nRyYwlH/zMunqi453qxcRCdRYCGuBL9DXQB9UW/zrarUzj+AcRZHZTpslZ/gCbuvWvfXs0NzNLvZ3XGntFWW/YZhj1KbmswNaek1ZcyLg/MYw+DVxC9Ukx38wGV4FqvabnUQo6MNvFOkmAcnK6okzglEpSXqAjUAPmE7nzkXaiSb1eFSy4Tf+U+Ut+io2Jsxq+kWZTHDpPHuH/jSg1pdJmA5xIoSQbDHvKXBNsuU7wESW2P79bK2h3KIfZs6XIU99W+vqpQwvQpKDHaVuQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


>> +static struct ksm_mm_slot *scan_get_first_mm(void)
>> +{
>> +	struct ksm_mm_slot *mm_slot = &ksm_mm_head;
>> +	struct mm_slot *slot;
>> +
>> +	scoped_guard(spinlock, &ksm_mmlist_lock) {
>> +		slot = list_entry(mm_slot->slot.mm_node.next,
>> +				  struct mm_slot, mm_node);
>> +		mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>> +		ksm_scan.mm_slot = mm_slot;
>> +	}
>> +
>> +	/*
>> +	 * Although we tested list_empty() above, a racing __ksm_exit
> 
> I think you need to update this comment to reflect the fact that you moved the
> list_empty() check :)

Yeah, with both things

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

Xu, can you send a v4 that I can pick up?

-- 
Cheers,

David

