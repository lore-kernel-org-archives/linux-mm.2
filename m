Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71DF7606A321
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 10:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=z8Wnlr4v
Received: by kanga.kvack.org (Postfix)
	id 8E0856B05B3; Wed, 28 Oct 2026 06:56:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 891C26B05B4; Wed, 28 Oct 2026 06:56:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 781236B05B5; Wed, 28 Oct 2026 06:56:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 571B86B05B3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:56:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5A7F6120C7C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:56:06 +0000 (UTC)
X-FDA: 85371730332.06.4E43347
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id 73C26140005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:56:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=z8Wnlr4v;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793184964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=42fUzzG0W2qYfbl++Ffgg89HqosiKQlRzn2fAEw0aa4=;
	b=rz19Y/QrDQpkIkl8pTJz05IrukpCWWUsv07P2vPR+Qd7XA1by3JqBntWItwQwqdk48N9SN
	8ON+oQQf6dcUi1kONIjfsT6iSdppFhAU8O6R7y7aEWJjRJcoe6CgfX00RMMECnVtcATJez
	R6AQBS5lPx5oB36lBPBh77chQ0JtDcw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=z8Wnlr4v;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793184964;
	b=gS35iu2xOTp15TVQdi95wmVoS7tk9tkGrkRnFgz6QZDNU/lMvyAflxn5qSjTmd1zs/ybI3
	UcOU8hAM5wHi3VFGqI58CJ3ZRBTFv+qshbAtkFwhVMwOKlPPMk0MidtTpNT/Kr/pjnF6YJ
	6Pz00YNntUriaEWNWug4/qpr8DIpvJQ=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a218c463d1so5348115e9.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793184963; x=1793789763; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=42fUzzG0W2qYfbl++Ffgg89HqosiKQlRzn2fAEw0aa4=;
        b=z8Wnlr4vz1hEsh5+j0nP6RctYkVR+O2g3g6wB3fpaaR7x11P67gvoWhWZ3kjBVNlSM
         ad3R66yU60KPfkWbydM3zX9lfOgTEQ39RmKV7b94Kd0PcxB/53J5hVQSFGrhmiR/98JI
         /nAndw3+CdpVaS80P4nScYCZoDDjwVQsZh13f1ERbqEF6HyPDl+Do0WHdiy/3NNTumPy
         l65A7ZnkdQwVyeRaovVmZ0qFyZ8kSFKHf5d6OtzmS0H0cKmpKgGz9EwSWYB7l4oCebAm
         hj2sqbwX1wi8oMLCVWSsx9JqjtOevxrGw5M3Fba28511yenARqFeh4DRTSCkYplCn8sd
         k5xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793184963; x=1793789763;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=42fUzzG0W2qYfbl++Ffgg89HqosiKQlRzn2fAEw0aa4=;
        b=0NzwH+pn7fGrONynucQD+VXtGk6KkNldB5UezaF+X8Dbf4ANev8h7flaal57KZ8UiM
         8bvxvPDzZWQNCY7B6Op/pr6SUeid432CpprVnkCyDh96jfX8XZNjGRanAwgc3rqOIRZk
         S1aDLk6tD18Qs9UQcI9bIrpO7DnKXlBC8W4YQdcnvS4UJwr+kz/iVdIAzyP303MGKIud
         E/0qzb2DCi6gITFMPrlsLfoZu72qTffgWa4fide12erc+A6p0FkUJPZ4b1uf3PdYERMW
         yErnwhigMDEW3GjfT4uXK2Ok/soLOv22oZ3dw2o9PsVDA9Hzv7uZP6xpkU72Wg5yN1aK
         A0Qg==
X-Gm-Message-State: AFq9FYLr7AW6o0H1doOcnYPh6l2rertPmQemUcEEwjC2x7mFLH9KTS/I
	N5xW0tBIZ5IiOcY0Hvv08Kte70KNc5Q1xGVtmXNxoEpYmtlOBO4BJnjM
X-Gm-Gg: AYBFou2qzLJWrkPos38qz5G9bjcfcf19GvLQTRupTLmSkFpaQ7xZdr/wZjtSZUqZrcS
	c3k+dpnQXZigFmDKU+BTClpJyfvGYVt9umjHscJkR20dsj+YwBx/+MOimzzoYtxBPfpSMRyky8C
	C9j8p3UW3QJ/VfyOD2C23odSnG4BhsvwUS55R4tDcSuuBzwl5bxDRX92KNorgFiqQ8ChCY/JB53
	ZnwDjY/bFeWyqkAfqscPcEI4N0BmFXrFb+DpLQOHlLdtEgtTNbdA6aPIiaOt70Gml9fXZkp/vNL
	lk/Ijs4y0h7boI0EZUWVNMfKJV+WibWeGSkGRPINTnavuAi1lzCNJ2AVSK+hBNmbwM1mf5p7YJd
	C3gXCC0YYlbqLdR//XTEGd+9c5QkaODS/sNwXlvsUSvx97gih9ptQFbHqsiQOLX9tILNBA/agzP
	jYFqczZGtd1skbTArUtz+lN7w5RLn6WTaUa9t9tGBzIjs1S8FCRJViH9VKc38FlzYrd1VeLguCO
	dM50H6sBIUxFLQe2eoiYTwBoJfb2f7DoGaZ2OJ9DZ+o0EBi1ofvfTp1QHhCcyJBYX/agwto3OrC
	vIy19t5EhSnLCIHkG9jmGy4F
X-Received: by 2002:a05:600c:a11:b0:4a1:e11f:b2e1 with SMTP id 5b1f17b1804b1-4a966773233mr39854085e9.15.1793184962863;
        Wed, 28 Oct 2026 03:56:02 -0700 (PDT)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a978795f4dsm33227565e9.9.2026.10.28.03.56.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 03:56:01 -0700 (PDT)
Message-ID: <599fe237-0a05-4e95-b377-7186cb0d761a@gmail.com>
Date: Wed, 28 Oct 2026 11:56:00 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/vmalloc: warn on NULL page in
 remap_vmalloc_range_partial
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ye Liu <liuye@kylinos.cn>
References: <20261026-vmalloc_remap-v1-0-b7a907814e90@linux.dev>
 <20261026-vmalloc_remap-v1-2-b7a907814e90@linux.dev>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261026-vmalloc_remap-v1-2-b7a907814e90@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 73C26140005
X-Stat-Signature: 6kabe5kyzonrtkbbfckqfuco8tm9up19
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793184964-331621
X-HE-Meta: U2FsdGVkX18SqmEs0MejXVkuKTkg8OfYSrpDwXzjxXrj/7IsilAb9gmMlcky4BR4c15bNWVCumP/s0SM55SHuSXqlLUzEgCkMJ8qyudTQ78bHKMm9dhGB9E+9B4Xwzk91v7O+hD2Vqz1ZLyEqs0OCmvvoI2KxpAkRKFkIJ760hbh9J4VRRTFs1Hf64fU3PnqlCuhJ7jBRqDbTPErLfJNB2J2+JyfLqZgiZoQR18mZ/+klmwXc+fWbA21HICwwJGeHk4y3pYMRinH8CilxVc2J8IEAFtXqaMejHzuzE9VM+uxFkMA2ByTdaWA8eE9Iv8Lct46d+7W+R2ZYf8pckai0KRrtveY1VPhfFwbR3zyD2VgwW6F4jJOAT1SKy7VGTUYglwkVkMNF+fAEWrGPyUVOAGFWziUqyn0EVa8nNdODNdjoC+1EBFyHHgJmkqPvm4lo7H8z7j0b+Iktzgq7vpmCulRzdqkiu30HJpRUJPe7PTokPuIZSlzwbs2v2rtA6/Jc5HKhfIgK91iF4mQrvaPsU43cqeFvLz3/Igjngdl9C8SI+cnxLt4vK7NVpA//SBnCuZG/9LlVB6BFMUcL2g/5E+zCY12J0eGvZlj2KCKaGsf3RCN+uHv+QGsH97CTos8r0A2br/8WFsD8cOSWjL4Vq+K3VmYUnAnmrzv1ePqL7K4eW24XqOueh7bXnPI7QPOTdVYjz6nxujFOsqROUEEX4XDjYrpy1cAixn0FruUgUH/b5AYlxoB59fhS6/iykWp9eSmqDPnAtL1aMi3PU08whSt7YgABfXygEMYRFRMR3qUcnaHPl1roX2trT488iiSD0taatfGS2QUywNM5j5LpShSuR29eBDHB0lPUpQUneMKC/F5jtwkpNGOXPnkfFfGOuyoXp0H8B7odBoVmCPf7g2TBaXoKcLGsetMPLBZYhZwjAJxdsrKgNBtJoSxJTJyYvf2dhzBd0PLIXN+FZf
 lEZBU713
 aLO1xkcQ5zqxPeJp0eqku7SpcLYhukru4LkUUIAK1H950eW0qG3PPdl2s/iBJ2UlqA3He0P4hCSljYXuxGiuC+kElyEhDrgIJyXzXPcm1xyuAcomGg9h5hWHOSG1OTOAS3VePwbGYCsEY7QHxwCbVgaKNO/3ZB+2qeh0ND3guxQmnzvuHrjmLSEZDHe8oqyJruGS+MZ2AuFzoPFOErOuSLE6RCLrPAguGKZFrHGZMDP9so4r1jCcX+//7ArsSm1Esbll/8qOsUbUwCRsJLYpdws1YwNIi+qnh0GCba0rKi6nQ79SB3RtgkPpPFe/XfChhKU2EFShrrRSaAzRQY/C+9ZXZXKNmnVuiLEUDrkBrdQrc7NhzjjqxhR6MtL2pH2/WEz23blD5/2xRGn7qBxry5TeL9cbPhmoU3SRzwl8LK9KOhOPy3osiDtDcZZ0Jk8Wbu/Q1NHS+sfPn3ZdefeEqfteE0Tb8myg6joIQilcm8I+c8wo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/26/26 7:09 AM, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> remap_vmalloc_range_partial() oopses if vmalloc_to_page() returns
> NULL, which never happens today because VM_USERMAP areas keep every
> page mapped. Add a WARN_ON(!page) to flag a break before the oops.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  mm/vmalloc.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index a888eca016a8..59ba203a4eff 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4906,6 +4906,7 @@ int remap_vmalloc_range_partial(struct vm_area_struct *vma, unsigned long uaddr,
>  		struct page *page = vmalloc_to_page(kaddr);
>  		int ret;
>  
> +		WARN_ON(!page);
>  		ret = vm_insert_page(vma, uaddr, page);

doesn't this still hand the NULL page to vm_insert_page() right after,
so we warn and then oops anyway? wouldn't something like this be what
you want here?

		if (WARN_ON_ONCE(!page))
			return -EINVAL;

-- 
cheers,
jose a. p-a

