Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E4A86083611
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 11:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mQzHaBn9
Received: by kanga.kvack.org (Postfix)
	id 4C0076B05BF; Tue,  3 Nov 2026 06:40:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4702C6B05C0; Tue,  3 Nov 2026 06:40:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35F106B05C1; Tue,  3 Nov 2026 06:40:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 11AC96B05BF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:40:26 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8469EC025E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:40:25 +0000 (UTC)
X-FDA: 85393614810.24.20B958A
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id 99B44100005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:40:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=mQzHaBn9;
	spf=pass (imf14.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793706023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=utxuIcSFdiIIVfsjndjc/ld0Uu9VZGyZLJcerN1xmmI=;
	b=zbNwjFqcQOkMwe8JYmY6pmdC0IB2q0hRELX2sL5UN+tRaFisGnRDxXOLtiu6/T1O7jVOh7
	cQdVOtHoOnowUaKNmRHH3XS55ZxFx8vjYtFKzOHtomSMut3Gm1gG3zKm7X0goQGZmho+BR
	oECksYw7e/kmibdSikT7/Gk/syhRV80=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=mQzHaBn9;
	spf=pass (imf14.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793706023;
	b=f8Hco1tpL+MaGa3Ek8sQN+BhRGsOXmiSwgz+Is56kHVUsBetlfCl6hhYFXu6f2FoKLFYyN
	k8/ASLJehimJMrQkkevR47ENYqE58SaW/Yu3NFuVp+yU6scaK5JHhHptGmSLb4/OXu8x7Q
	fn6SN7my8gNlxcZRPDJpCiTh0txEzEE=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48e0d885929so3258511f8f.3
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 03:40:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793706022; x=1794310822; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=utxuIcSFdiIIVfsjndjc/ld0Uu9VZGyZLJcerN1xmmI=;
        b=mQzHaBn93cRFxIEU0UpBVLQLT2uJ9R6Z5Fj2cdZ/IfNM+Km4H/UMyIgplotXvqHKSs
         Snlehik/1fQN9zo+Xqz4w5Tmv+hYwoUWVGcKBizyuT818rvni5mqhZReRDix2lM4LZD6
         tuEoIjCxiPuA3/YmLSb4B912M3A8bXg+TqUdUU9rf2YlJX8lQLzePvJq+zmNnrA9b1TF
         BHCIfIW3qZd2JTPFDxGrlecGDkSnADJuC6BxmR0kk2WMYe/Yu+fIVTDxb0br4DHrZZAu
         dvOI9ksftX3BV3M6raw6mCQokdQ6+3lzYOq4YTm81Bx0+pmFEpdizbVvB7qqYuh2UDaC
         yDfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793706022; x=1794310822;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=utxuIcSFdiIIVfsjndjc/ld0Uu9VZGyZLJcerN1xmmI=;
        b=kqCNxKh6QuwE1sP8Uk7qlTZmNqcjEkSBDszfaeob8cs6AbND79juJ3Wkmjh7bo/06L
         0g60ryty89EdpGrTO7KQkpi7DzCcf+IidZNdsXbKiDyv1POwsQ3zuGu9pwM1u78TSa1y
         pLyrlPqbhw+4g3N3ytomuwDZmPTSffXor8S8dsGZfspjqcEDeOHZPXeJ0joRUvztNVYs
         aHKGqn7DicKlV1wyBIHdTU5tardAVRceaSjjVpZSE7J1Um1KT+TumPTtkPNNWcjDcfum
         AGpYnNplnMq27zGpPXVszt2kWwTcoMeoiAinCCvBEbDa/wH//lgkJJL9WQTemkuXgwS2
         j9Gw==
X-Forwarded-Encrypted: i=1; AKwUvByV3T0mS8uP3iU55jLE/fQyFNcq0kXxqt0EypIxaxSCEroEbj6s6PCnqYp9iMe8MmdvhYEn9a4Sag==@kvack.org
X-Gm-Message-State: APuU4Z+/JsOqR5w/LSai/n/tCW3DRCOp9Gbj2/ood4yl0KGNEmK4WyRH
	ivTtnAOND4xev2JdKYDK8+Al9M2i0h7T9dce6DuQhruzAmbt8oIZq/hr+M5g2iTj2XU=
X-Gm-Gg: AYBFou2FF3XRo+QW4jpWUmLNiXcGAl1ojWfoZr3j60oorike5sHfXToBW5qwAnVdTOu
	TjI7KtG5aka6zRi9WiWEQjG1Dqb0dt7jbMrx8MD4oncu+RuyMYms//nKs2CI5viq0qPfti4z4Cy
	GSz3raqe09XQdk4np4VG8mulyCEp/mSqeuj90JpkIZh81i+jRDX4KGaZ22vwkGoS6GrL1wR2F0A
	hWlmDos2HZPFXxOd5IzJiR+KtIirK1AX9ecarGgKxDrd4YnSgLp8SKUHTE/Wx260tlDXY3QDAJI
	AnA6hq6+0SX26wPlrI+cFza4zor4cOjnYITp8YaciBlx93KIVuzyptiloyF5+64TXO01Aak5VFk
	LWobsU4KbH3dS6aaOnKvl3hVkWUfCjyS8STU2GesiHoNvzgb5ozAURO6ZgW6VZHWc8o2Z89zE7R
	s8ucpKAzTlcSDHXff3fok5CwtNi02eATZs+icB5rH89pgSuFTQPwPPoPZiiMyDQ3FGrBARwRAd6
	nrFkEW0AZOdWLG5LbuO/5xZp8niGGnDrx8xZ9ccYLxWIStCxCOncbK5mQT/tuGspMgs/e0M7ou/
	JnzW/P8hlEUU9jVSfxrBjSM=
X-Received: by 2002:a5d:5c84:0:b0:48f:bcbf:26f2 with SMTP id ffacd0b85a97d-48fbcbf2becmr528573f8f.55.1793706022163;
        Tue, 03 Nov 2026 03:40:22 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71bab1a8sm24248670f8f.57.2026.11.03.03.40.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 03:40:21 -0800 (PST)
Message-ID: <897b0ea8-d2f4-42e9-ad22-e331c5b085c7@gmail.com>
Date: Tue, 3 Nov 2026 12:40:20 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] x86: hugetlb: disable default CMA reservations on
 32-bit kernel
To: Qi Zheng <qi.zheng@linux.dev>, muchun.song@linux.dev, osalvador@suse.de,
 david@kernel.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org, x86@kernel.org
References: <cover.1793692578.git.zhengqi.arch@bytedance.com>
 <61eee83da19a87337e68a7747fc0b89ee5d0393b.1793692578.git.zhengqi.arch@bytedance.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <61eee83da19a87337e68a7747fc0b89ee5d0393b.1793692578.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uix3cazio7okukda1in6rj8mnfzarnog
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 99B44100005
X-HE-Tag: 1793706023-503056
X-HE-Meta: U2FsdGVkX19Bz4qw5xqAQMdTGL4+7umuG4mB5aF3JYkUx99JrbYHjbPa6fP6njeeHHtkmDRO/Mex6begOGOCyvbhCbm91oCcEwnOCsBWFtKP7RA9OqctX5YAidqvsJbnmK4KPJ+Iu3yLbgKYdvwQBO4AimoT+o9xe9nGyDbtNIkk0EI/R8I8MhUUcbMzlW6F8UB3kHfOHy5zjgNlET3PhEDG5iynWYTgfN58yRq2nh5tZuknbgrnFa0iiaow5yA5CnbJDi15HwJ8PZU6sRFU1Upi0Wokk1Ztdlrl6KoOEzWFvb9YXsYK7EQZRmpcoDFRpPE3NSB7fJAGO10XFNVcIjIFI8GpIXex+eH9DcGh9QH2ozq/FrCAPgnOnm3C8a16YlzOPHt63EG+D1F9eNABpu7BrFHLhlqfEOiB473VS15X1oHSxcrobqd3gosoVz3zoRo4V3Nj86cQ3OTkxkqW8eC41Fy5J12Fod6HY059GLZVD3fQZoQ9VWdW0g9wk0hfTCNiIS0bZWFyZ526MJp5P01fx0239I48Ls50VYixPep4LWO4pg9N6Mtr6bjPTJKUKgNFvQl7nFlzHOmHOkuv4oDb4KsDaGDBartd7+BYd6OiYlbB2o3wnqXvzB56IDgUieBozbJ1jZ5EKdmlxCkHzAr2oArIFot0fUtjQI/ICSKUf86Y4dg8Xaw2RL7sYIAum59JMJvVYbTwDT6O5JSWtFYW0+Lj1jhCSg2ItwaDzpPlLlkHNRnYk+qm9hiJdVoA6bcVO30VMMY1W2bgBdIGgnYtwRCtI7wWUzgeCcMnaqkrCbhqPWWLo+IntOuNRWXPB/eXUFdN8veQXP5ZcGvnKLe5KDsUUrkzNvSN/alWpaLJyjPfsuDRDaznC9YcBp/cy2Xf009Yl1qKWKHiWA5HuBb6ysKU0FvCgbU+flizY9lXCif/LYgLs2y0L90X7i4mqKUR+wNFs5L/ClrMnEV
 cb8lXksC
 oJIxZ+9RXsz4Hbev7/5UFIq6HzAYxqz8Wh1hXQLZtbVQCsHGz4R8KvgppPgkMQcLnVkYLZlVvgMJNoLyOifKSR4pmOv7NtcIFNzGTvg8tu4bMwGy5Lv1Kidv8xSgZO/jE5D+7gcxOXjpmiQjcSsYJ4wSOGU2YGYW1WsTvgWjCLTSmTTe00vqpau+VX/wxKBbqR8b1HzaTIeVbZUSmb8RmnZoChdHLd1bgJnzF+DiM1yD2E2/GmM+HpdCL/Nr5YBPF0B+OE9wC7q2ROi9sfTVsUmVK0FnU7xnVFbt1Q/+7XPAGAQaqFJ+IsxWFW0wJ/vT+5IvuXXa21bDJTTpX+Lv5H74WzYA14E9NSLRIC3MSfUDNKb0Kffd/BEHHh0B6SjczZIeTXpkBhqYkPf4KgcoifMP8O+r2VYoODXygB4Hcw385wvASnVdXmEvuV+OLklROsdfbrsQEnX1VAMxWZzw0WgpgcNk0r5WnVFE5fSJypqHHslE4CR+ZXaZMAQeun44BRc0t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 9:01 AM, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> A 32-bit x86 kernel can run on a 64-bit-capable CPU advertising GBPAGES.

weird. anyway, LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

> arch_hugetlb_cma_order() checks only this feature and returns a nonzero
> order, although gigantic HugeTLB support on x86 requires CONFIG_X86_64.
> Specifying hugetlb_cma= can therefore reserve a CMA area that cannot
> serve the intended gigantic HugeTLB allocations.
> 
> On non-PAE kernels, the folded PUD_SHIFT yields a 4 MiB order, which is
> equal to MAX_PAGE_ORDER. With CONFIG_DEBUG_VM enabled, this triggers the
> VM_WARN_ON(order <= MAX_PAGE_ORDER) check in hugetlb_cma_reserve(),
> warning that hugetlb_cma is attempting to reserve a non-gigantic order.
> 
> Require CONFIG_X86_64 as well as GBPAGES when selecting the default CMA
> order to avoid these ineffective reservations.
> 
> Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
> Cc: stable@vger.kernel.org
> Cc: x86@kernel.org
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>  arch/x86/mm/hugetlbpage.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
> index 3b26621c91286..70726a99ede7b 100644
> --- a/arch/x86/mm/hugetlbpage.c
> +++ b/arch/x86/mm/hugetlbpage.c
> @@ -45,7 +45,7 @@ arch_initcall(gigantic_pages_init);
>  
>  unsigned int __init arch_hugetlb_cma_order(void)
>  {
> -	if (boot_cpu_has(X86_FEATURE_GBPAGES))
> +	if (IS_ENABLED(CONFIG_X86_64) && boot_cpu_has(X86_FEATURE_GBPAGES))
>  		return PUD_SHIFT - PAGE_SHIFT;
>  
>  	return 0;


-- 
cheers,
jose a. p-a

