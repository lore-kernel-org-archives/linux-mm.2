Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB300C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 15:39:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD1616B0099; Thu, 24 Sep 2026 11:39:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D83236B009B; Thu, 24 Sep 2026 11:39:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9B396B009D; Thu, 24 Sep 2026 11:39:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A77116B0099
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:39:38 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 35F9AC03DB
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:39:38 +0000 (UTC)
X-FDA: 85249065636.29.3535273
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9D0F0180005
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:39:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HPY+OX1I;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790264376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V/51A88+wcKZYh7YQiVLLkkIW6U8j3LDTQlEVBev4Eo=;
	b=0uad5npfoOwHkros0l4HF2EUtr4dP9vh6f2rxV4rHcXbXs9zBWjrUiuOWqIBmt6Zho9TYQ
	RgeniHC7O6CbJudsBofJqsqSTMAdMg5a5LAHJ4mW848pB0X5941sgWPwRLrGdey7atidqp
	xd+ud47Rah+NQyGCBWVtq/AyevDXkXc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790264376;
	b=J0YdYMVPVwN5OY4nt1dwoNjEDxZ+RQCjAKfurts1g0dyXxyoqytdiy598wHdj1cfN6J5CY
	EkqBRgt3Nkcr1FvoC8t0+1yZjnLeQ4YFruYlpieByrXQTEhjTrzy9L/aFpEcXDsYY+tDWi
	Hn3gD9rHzZqHddQt/UGDblz6OQbVOvk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HPY+OX1I;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C7D2601DE;
	Thu, 24 Sep 2026 15:39:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A10B1F000FF;
	Thu, 24 Sep 2026 15:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790264375;
	bh=V/51A88+wcKZYh7YQiVLLkkIW6U8j3LDTQlEVBev4Eo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HPY+OX1IFUI5BVqOQkfPERmKSAn/n4y6s4BtNXRKq+mgnhKm7zWaY6EBmB9tR4a29
	 bHEb4an9nQPrscOJq0VKAD100xzvna1ePl9GVCYhOv4K7FmSLaeCF4qvOMVrnFysha
	 rWaH9SXY0O1+bUuDUIfMi3Wz75+mSGyeQ3djugLUJJORR09kB+mmq+tAoY4/0fG9rd
	 drwzcZrA0CF9+lq12RQnEe1kd+9Bf8hGiJ/apsKOCspHffkVEaVnuOMgdaWSIwN25+
	 tRAnATzo6ouSxDVx6LTlYzAMVQ3274V8vSXx/fCczcehWM+y6qiX68vMNp8UJtvAJx
	 szcjb8uHwnGFA==
Date: Thu, 24 Sep 2026 16:39:33 +0100
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
	Damien Le Moal <damien.lemoal@opensource.wdc.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kees Cook <kees@kernel.org>
Subject: Re: [PATCH RFC 2/8] mm, slab: introduce slab_debug=N
Message-ID: <arVB9DuVa28Pxz-a@thinkstation>
References: <20260923-slub_tiny_rework-v1-0-a0e66d536eb5@kernel.org>
 <20260923-slub_tiny_rework-v1-2-a0e66d536eb5@kernel.org>
 <arUx56ee_nkxYP_f@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arUx56ee_nkxYP_f@thinkstation>
X-Rspam-User: 
X-Stat-Signature: axy6ezo35tamy81a6gxtrmtfkf4cjory
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9D0F0180005
X-HE-Tag: 1790264376-74900
X-HE-Meta: U2FsdGVkX19ddG38cGckL19RBguFR5HsjEpEJhjf9X91+MAdbpTnmUggkM/oBJUJMJaJzZZatLGa0Lzfx2H+qBHGndS7QC0QWDwRikOnprv4HwGlV2bNLyNf3UaEyXkJwt5NquQpTsXXY9n24VH76RKX+WTIqSdO3QPnuf6t7/lsZ04bHfDxsQ6KuXE/2PKMfY0Hf6maZc56/laxzCyGLP5Tch98UhJMndUK6HO6xeCHb1eZSzN7dNrhS2c3d1xBdd/poDUouwQ086YEfK559GZeCjY7zu3X0Qu3d7TRHrTM3yJsqz0sWu5M5pZsbVk1ta+UACL+XX5CmEAUPPC0/IMAu7o+sWf4S1ArICierTruy7ptv5K4P71o9sVO0BacidyCXAa1S+S2k5Vn2njKKgtzxGSKcMVKWHLBH+8IOPp+d0UJACSxlSStzVoRyvNCdOcjN+9f7SJ76q8gOKYTSfcNg9U9a8WsT9MykZcxwJLxpWzRGAA3gAgjcLSKT2hgBE+ugjdwvTUzoijL7j2lsSYsgiU/CEO3kdNEkI6GzT4POFKt1RKS/4PmR7EdGX12TM6M50gUe2O/y7n657RquQadYa9pOydnbSAA505M8XoAlSE8tVfVMYnc/Zg3QpDf03vIM29WRlGznXYnXJNUY3XiligHYcAuD02DdIBkVTE1VTQGa91+myA0uRVAr1HSUwlVF1NxFpwSPhgoc0IspuFqL6aCKwr4DomZQfQbXjHTnKTJ57MAQQ/vvrbdmhrRwLmebpoDyIkNwbHDu0sLfPWpexjATLvZiVjnVuasngk0i5xMMHFlPF6FEQZXIR4Azo4m5EKFYJ1PS80qKckUI/NFD+IYoNWhz9T1u08vYvg8cvDdPPUxZfUUjCFruuemdoak6/dOBCiD7IvowsJSllp0RDPMz9AMLw3MoodkWK2JmHKIGEWXnbOhCdaPX24rV352K8fBIceH7T/I2ey
 o483sgDW
 8uxXJazv93n3CTH8MfLITZSDEvbv7wtdDfWxXkWx4trJGyWJak9Tnt+sJJ+T4ggcj42kSwsiknDOQm2KJ6TJX1aKOtEoyQS1w4U6W7qrTpFq7mUoZIggwmwsUyYAr+7C1fYtr7M64XiKIPEsW7ciuTVsFwb9l9rscZpS6AZUxaADaCytX4Xlr/X8Rh1UyRqviT1l2xQtSAw7V27i/gm8MknuJTj8f6WZEeX/x79B5DRna3cYT1s5MEKr7WulJH7URCpM1N7mFW0zp/k1ZWsDmgqNx8NhxXW/2hHW/15PrwVYmO6k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 03:48:43PM +0100, Harry Yoo wrote:
> On Wed, Sep 23, 2026 at 05:45:07PM +0200, Vlastimil Babka (SUSE) wrote:
> > Enabling slab_debug has the side-effect of disabling all percpu caching
> > of objects (now via sheaves), which can be sometimes useful for saving
> > memory for e.g. kdump kernels. To make this possible without the
> > overhead (CPU or memory) of actual debugging options such as poisoning,
> > introduce a No-op debug option that only forces the debugging slow paths
> > and zero sheaf capacity.
> 
> Just to clarify, the intended behavior of slab_debug=- still
> does not change, right? (the name "No-op" could be confusing here I
> guess)
> 
> And My LLM flagged an issue here (that I reviewed)
> 
> Implementing it as debug flag has a few side effects:
> 
>   - pointer hashing will be disabled unless hash_pointers=always is
>     specified. [+Cc: Kees]
> 
>   - Disable slab merging. Since this does not affect object metadata
>     layout, this could be excluded.

excluded "from SLAB_NEVER_MERGE"
Obviously it should be still part of SLAB_MERGE_SAME though.

