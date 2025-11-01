Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35DF5CCF9F8
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 00:03:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DCE18E00E4; Fri, 31 Oct 2025 20:03:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88D208E0068; Fri, 31 Oct 2025 20:03:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77C978E00E4; Fri, 31 Oct 2025 20:03:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 60CBB8E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 20:03:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 294EA160629
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 00:03:02 +0000 (UTC)
X-FDA: 84060087804.19.356E317
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 47FFC18000A
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 00:03:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C3BeBJrg;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761955380; a=rsa-sha256;
	cv=none;
	b=tkyKBkH9xLl1xBBc/eqbn38D84rPi62cjeKzdx+4yhlRL0DLUoYwyIfMMJYy4GiSx5cnu/
	yyrgqz1F4HAUKWRre5dr+sYK9MKs17jD5AtN6Ojr2l5p05xQR9BUHfdE/qcp5QRH10dokC
	M4v6yGgtYKqJ00zPaHiCRLGwuvA9kuk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C3BeBJrg;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761955380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GfCNWBS1ikjrBIm0dtaNQbw8vuR8lrZUDpjp5Sbevek=;
	b=WuXuCYyBRHVpXc2JE/g7Wg7WOtDFBnhi8o+yQwBddMEyKL2Z9PF3yv2Si5XFcPkT3wGCDz
	fEynwVLHiseDYUUh7GlMy7NGSOU8lbFWXlDlCsrugH/MquyvoZCnZj4mByVU71z9XfsaEs
	ZmOP+1LQx8apFsmICu6NuceOOYMEhdY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761955379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GfCNWBS1ikjrBIm0dtaNQbw8vuR8lrZUDpjp5Sbevek=;
	b=C3BeBJrgoVsUk8v8r1K8l4SNjc3oPcsyxxcZ/hBqKs4vkC+91KTX3sy39e5WyShMdWYoYa
	LW3Kk8U3KkgaFNv8M7k8jRuV0dDtJ1+FDHoxuvjP9YrQDM6MKCwRrqlFOBXgEaHVTE2L8k
	/RXbtX6Mc90PX43Z0nRkzMq7gVaEfWA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-656-hD-RQpKSPtywSMqrN95LSw-1; Fri,
 31 Oct 2025 20:02:56 -0400
X-MC-Unique: hD-RQpKSPtywSMqrN95LSw-1
X-Mimecast-MFC-AGG-ID: hD-RQpKSPtywSMqrN95LSw_1761955375
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C0CAB19560B5;
	Sat,  1 Nov 2025 00:02:54 +0000 (UTC)
Received: from localhost (unknown [10.72.112.3])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 38B101800452;
	Sat,  1 Nov 2025 00:02:52 +0000 (UTC)
Date: Sat, 1 Nov 2025 08:02:47 +0800
From: Baoquan He <bhe@redhat.com>
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>
Subject: Re: [PATCH v2 3/5] mm, swap: Remove redundant comment for
 read_swap_cache_async
Message-ID: <aQVOJ7/OlY3Kz8Ug@MiWiFi-R3L-srv>
References: <20251031065011.40863-1-youngjun.park@lge.com>
 <20251031065011.40863-4-youngjun.park@lge.com>
MIME-Version: 1.0
In-Reply-To: <20251031065011.40863-4-youngjun.park@lge.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SN-wPxvzhPpm8ytoB-vqI07XhShRXmH4jOpt2txh-Fk_1761955375
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: g3gkid6r1xhz4t91pbdcfd3a5mscd7bh
X-Rspamd-Queue-Id: 47FFC18000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761955380-213957
X-HE-Meta: U2FsdGVkX18XtundJehKzhqJwKc1r5GLF69x+Ywgw1uoa70NJa67rOOpfKFwmfAUzgVxX1n93C55excYGaCYwWCRdlhB+6HCopH0KCHLsGruCWB1WDKlBd5zo0itatmo0QReUl7N/vnhiU0lssDAZAJAU9zgLgSL0x/jpi+G/qpqk/lA71LEIq783ofTAHcWF1D15fTtoS7GNn6VDmVl0t60qyXXp8f4iPEsPELdy9uR1qVq3xQeEVgJjSGY6uf3OBV2a3NSLvKaJBQYkPf2olGZjhYsdjJHxQYH/+7AWTBODlWcBhFx5MsieGYqmnLu0Tb63lUg9XRVyIM7JrGWaaoAJ4G5wREi99jut42fQ38qKjyB/qVnCMImtYUC9ktlCqMH7SRK45nj9mj+FZtKBCThS+oivdd9o3bwROqh9IuBm9hTuvbFIv/OAcK26tO6Z0VPHR/jj4ZnJwKD8aEd6ogT20pMhP846DMyQPsiPDC6pbVoN33QuhE9CYe4QMSLj3Ykadpi29bHGVZTENr8CccHOTS22H9qMM/BpFgHXAsXr9bhtqPAcQmu8NtFDbFNWn6E/fvh4nKXx1q8lhlXkGBiL2VYbfaDiAY+hInY6cZtIGb2NaJJ4rr7D3fKrmoYbBK/jbsVB+5S9r6KZabGWORzDHj7R/7M6vGWDSe7xp0vm+YH5T0zqay9g5F1zeH9Q24O8tQFNqy48AkVV73G9vipZ+XnUE1E6sB8ICvbWVRTEDPEk/b2lojgE82jeUm7iJjggl9CnoS9Z+aj4ebjhh7JgqtM+ehiu/S/0UhnA/+QFbRaR1E428ceyKbPN6teNmReOaVt8yoBVG8EJNbw7PthwiIoVQilnpEH120ugbquWaLzEPPatpnEefpHhVnYs8/S9gWwQUIYZpfgwwNOoL0ks1m6wq1RjG3KA570NOlFeHz5VL2P4A1ol39Lk+iEr+4L7//RpEPodE2x275
 sn32Wa3F
 rfZa3eZ8dd4j7pZqGsVx5zpFSNcK3sUbvimKEfnzYFGZxsJUV7GQef/Bo4NMQava273oNJ8IskIG/IKnn0X7OcnNUPIwcJuLSi6o6IrZX+DN2bT9npspJHIIhWfrAE76iacZVeiPV4U9KvP8wbSUFWcmUK/KNdrCi1uIEzBRMxmAs8euwKDIY2dCZLuFcWAiPyF9azZntNbNDMSM++7vakBDL/ONkIYCuy6VmIieH/uzF7++vQSFbBi/VrYq6u5UGNDR8bTd+R4VgoT0kWIZm1zMZKSZuv+aIKdbw1XAWTbyODxQOhS/WSpgBz342+8Pw4Vv1DWWHdBAwyEeUAd2oW6rKNIoTlmwKhAk/kJaeYkM0vbTCLGjafBIy98Ji1NgbN9zhlB07T0txyalN7aS63mgwGrUcNChCHwCJsrV9FlWMPS51p33GUCdgnaLl+fzXpaRBV2ZCB3ay4KcHSyiTFE+ZffyOPTR0w0f1gInGPx6G7ugz8gQWX2Q8fIT2br7U6mbcDQUtP+D/wzzOOC+Qwicr5OEt3Dlx3VfG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/31/25 at 03:50pm, Youngjun Park wrote:
> The function now manages get/put_swap_device() internally, making the
> comment explaining this behavior to callers unnecessary.
> 
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> 
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index b13e9c4baa90..d20d238109f9 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -509,10 +509,6 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>   * and reading the disk if it is not already cached.
>   * A failure return means that either the page allocation failed or that
>   * the swap entry is no longer in use.
> - *
> - * get/put_swap_device() aren't needed to call this function, because
> - * __read_swap_cache_async() call them and swap_read_folio() holds the
> - * swap cache folio lock.
>   */
>  struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>  		struct vm_area_struct *vma, unsigned long addr,

Reviewed-by: Baoquan He <bhe@redhat.com>

> -- 
> 2.34.1
> 


